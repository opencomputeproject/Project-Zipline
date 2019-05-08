/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/




















`include "ccx_std.vh"
`include "messages.vh"
`include "nx_mem_typePKG.svp"
module nx_table_monitor
  #(parameter
    CMND_ADDRESS=0,       
    STAT_ADDRESS=0,       
    IMRD_ADDRESS=0,       
    ALIGNMENT=2,          
    N_TIMER_BITS=6,       
                          
    N_REG_ADDR_BITS=16,   
                          
    N_DATA_BITS= 32,      
    N_ENTRIES=1,          
    N_INIT_INC_BITS=0,    
                          
                          
    parameter [`BIT_VEC(N_DATA_BITS)] RESET_DATA=0)

   (
   
   stat_code, stat_datawords, stat_addr, capability_lst,
   capability_type, rd_dat, im_available, tmon_credit_available,
   im_status,
   
   clk, rst_n, reg_addr, cmnd_op, cmnd_addr, wr_stb, wr_dat,
   im_consumed, tmon_credit_used, table_data, im_config
   );
   
`include "cr_structs.sv"
   
   typedef struct packed {
      logic [1:0] mode;  
      logic [`LOG_VEC(N_ENTRIES+1)] wr_credit_config;         
   } im_config_t;
    
   typedef struct 		    packed {
      im_available_t                available;
      logic 			    overflow;
      logic [`LOG_VEC(N_ENTRIES)]   wr_pointer;  
   } im_status_t;

   
   
   input logic 			    clk;
   input logic 			    rst_n;
   
   
   input logic [`BIT_VEC(N_REG_ADDR_BITS)] reg_addr;
   
   input logic [3:0] 			   cmnd_op;
   input logic [`LOG_VEC(N_ENTRIES)] 	   cmnd_addr;
   
   output logic [2:0] 			   stat_code;
   output logic [`BIT_VEC(5)] 		   stat_datawords;
   output logic [`LOG_VEC(N_ENTRIES)] 	   stat_addr;
   
   output logic [15:0] 			   capability_lst;
   output logic [3:0] 			   capability_type; 
   
   input logic 				   wr_stb;
   input logic [`BIT_VEC(N_DATA_BITS)]     wr_dat;
   output logic [`BIT_VEC(N_DATA_BITS)]    rd_dat;  

   output 				   im_available_t im_available;
   input 				   im_consumed_t im_consumed;

   
   input                                   tmon_credit_used;
   output                                  tmon_credit_available;
   input [`BIT_VEC(N_DATA_BITS)]           table_data[`BIT_VEC(N_ENTRIES)];
   
   
   input 				   im_config_t                      im_config;
   output 				   im_status_t                      im_status;
   
   typedef struct 			    packed {
      logic 				    dis_used;   
      logic 				    dis_return; 
      logic [`LOG_VEC(N_ENTRIES+1)] 	    credit_limit;
   } sw_config_t;
   
   typedef struct 			    packed {
      logic 				    used_err;   
      logic 				    return_err; 
      logic [`LOG_VEC(N_ENTRIES+1)] 	    credit_issued;
   } hw_status_t;

  
   import nx_mem_typePKG::*;  

   localparam capabilities_t capabilities_t_set
     = '{ nop          : TRUE,
          read         : TRUE,          
          default      : FALSE};  
   
   
   logic [`LOG_VEC(N_ENTRIES)] 		    sw_add;
   logic 				    sw_cs;
   logic                                    im_rd_stb;
   
   logic 				    ready;                    
   logic 				    sw_init;
   logic [`LOG_VEC(N_ENTRIES)] 		    wr_pointer;

   logic 				    overflow;

   assign im_available = im_status.available;
   
   assign sw_init = im_config.mode == 2'b11 ? 1'd1 : 1'd0;
   
   
   hw_status_t hw_status;
   sw_config_t sw_config;

   logic                                    r_bank_wr_pointer;
   logic                                    r_bank_rd_pointer;
   assign wr_pointer = r_bank_wr_pointer ? (N_ENTRIES/2-1) : (N_ENTRIES-1);

   always_ff@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         r_bank_wr_pointer <= 0;
         r_bank_rd_pointer <= 0;
      end
      else begin
         if (tmon_credit_used)
           r_bank_wr_pointer <= !r_bank_wr_pointer;

         if (im_rd_stb && |hw_status.credit_issued)
           r_bank_rd_pointer <= !r_bank_rd_pointer;
      end
   end

   
   always_comb begin
      im_status.available.bank_lo = ready & !r_bank_rd_pointer;
      im_status.available.bank_hi = ready &  r_bank_rd_pointer;
      im_status.overflow          = overflow;
      im_status.wr_pointer        = wr_pointer;
      sw_config.dis_used          = 1'd0;
      sw_config.dis_return        = 1'd0;
      sw_config.credit_limit      = im_config.wr_credit_config;
   end

   assign im_rd_stb     = (wr_stb && (reg_addr == IMRD_ADDRESS)) | im_consumed.bank_lo | im_consumed.bank_hi;

   logic [`LOG_VEC(N_ENTRIES/2+1)] credit_used;
   logic [`LOG_VEC(N_ENTRIES/2+1)] credit_return;
   logic [`LOG_VEC(N_ENTRIES/2+1)] credit_available;

   always_comb begin
      credit_return = 0;
      credit_used = 0;
      if (im_config.mode == 2'b10) begin
         credit_used = tmon_credit_used ? (N_ENTRIES/2) : 0;
         credit_return = im_rd_stb ? (N_ENTRIES/2) : 0;
      end
      ready = 0;
      if (im_config.mode != 2'b11) begin
         ready = |hw_status.credit_issued;
      end
   end
   
   nx_credit_manager 
     #(.N_MAX_CREDITS                 (N_ENTRIES),                          
       .N_USED_LAG_CYCLES             (0),      
       .N_MAX_CREDITS_PER_CYCLE       (N_ENTRIES/2))
   u_nx_credit_manager
     (.*);
   
   assign tmon_credit_available = |credit_available;

   logic [`LOG_VEC(N_ENTRIES)] addr_limit; 
   assign addr_limit = N_ENTRIES-1;

   logic                       r_sw_cs;
   logic [`BIT_VEC(N_DATA_BITS)] r_rdata;
   always_ff@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         r_sw_cs <= 1'b0;
      end
      else begin
         r_sw_cs <= sw_cs;
         r_rdata <= table_data[sw_add];
      end
   end
   

   nx_indirect_access_cntrl_v2
     #(.MEM_TYPE              (REG),
       .CAPABILITIES          (capabilities_t_set),
       .CMND_ADDRESS          (CMND_ADDRESS),
       .STAT_ADDRESS          (STAT_ADDRESS),
       .ALIGNMENT             (ALIGNMENT),
       .N_TIMER_BITS          (N_TIMER_BITS),
       .N_REG_ADDR_BITS       (N_REG_ADDR_BITS),
       .N_INIT_INC_BITS       (N_INIT_INC_BITS),
       .N_DATA_BITS           (N_DATA_BITS),
       .N_ENTRIES             (N_ENTRIES),
       .RESET_DATA            (RESET_DATA),
       .N_TABLES              (1))
   u_cntrl
       (.enable               (),
        .yield                (),
        .sw_we                (),
        .sw_wdat              (),
        .grant                (sw_cs),
        .rsp                  (r_sw_cs),
        .sw_rdat              (r_rdata),
        .reset                (), 
        .cmnd_table_id        ('0),
        .stat_table_id        (),
	.sw_ce                (),
	.sw_match             ('0),
	.sw_aindex            ('0),
        
        
        .stat_code                      (stat_code[2:0]),
        .stat_datawords                 (stat_datawords[`BIT_VEC(5)]),
        .stat_addr                      (stat_addr[`LOG_VEC(N_ENTRIES)]),
        .capability_lst                 (capability_lst[15:0]),
        .capability_type                (capability_type[3:0]),
        .rd_dat                         (rd_dat[`BIT_VEC(N_DATA_BITS)]),
        .sw_cs                          (sw_cs),
        .sw_add                         (sw_add[`LOG_VEC(N_ENTRIES)]),
        
        .clk                            (clk),
        .rst_n                          (rst_n),
        .wr_stb                         (wr_stb),
        .reg_addr                       (reg_addr[`BIT_VEC(N_REG_ADDR_BITS)]),
        .cmnd_op                        (cmnd_op[3:0]),
        .cmnd_addr                      (cmnd_addr[`LOG_VEC(N_ENTRIES)]),
        .addr_limit                     (addr_limit),
        .wr_dat                         (wr_dat[`BIT_VEC(N_DATA_BITS)]));
     
   
   
`ifndef SYNTHESIS
   
   function [`BIT_VEC(N_DATA_BITS)] get
     (input integer addr);

     logic [`BIT_VEC(N_DATA_BITS)] data;
     
     if (addr > stat_addr) begin
       `ERROR("Received address of %d, maximum supported is %d", 
              addr, stat_addr);
       data = {N_DATA_BITS{1'bx}};
     end
     else if (stat_addr)
       data = table_data[addr];
     else
       data = rd_dat;

     `DEBUG("(addr=%d, data=0x%x)", addr, data);

     return data;
   endfunction : get
   
   task read (input string name, input integer addr,
              output bit [`BIT_VEC(N_DATA_BITS)] rdata,
              input [`BIT_VEC(N_DATA_BITS)] check={N_DATA_BITS{1'bx}});
     if (addr > stat_addr) begin
       `ERROR("Received address of %d, maximum supported is %d", 
              addr, N_ENTRIES);
       rdata = {N_DATA_BITS{1'bx}};
     end
     else if (stat_addr)
       rdata = table_data[addr];
     else
       rdata = rd_dat;
     
     if ((check !== {N_DATA_BITS{1'bx}}) && (rdata != check))
       `ERROR("read 0x%0x from %s[%d] but expecting 0x%0x", 
              rdata, name, addr, check);
     else
       `INFO("backdoor read 0x%0x from %s[%d]", rdata, name, addr);
   endtask : read
`endif

endmodule 






