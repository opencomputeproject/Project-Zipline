/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
































`include "ccx_std.vh"
`include "messages.vh"
`include "nx_mem_typePKG_v2.svp"
module nx_ram_2rw_indirect_access
  #(parameter 
    CMND_ADDRESS=0,       
    STAT_ADDRESS=0,       
    ALIGNMENT=2,          
    N_TIMER_BITS=6,       
                          
    N_REG_ADDR_BITS=16,   
                          
    N_DATA_BITS=32,       
    N_ENTRIES=1,          
    N_INIT_INC_BITS=0,    
                          
                          
    SPECIALIZE=1,         
    IN_FLOP=0,
    OUT_FLOP=0,
    RD_LATENCY=1,
    SW_RD_PORT=0,
    SW_WR_PORT=0
    parameter [`BIT_VEC(N_DATA_BITS)] RESET_DATA=0)
   (input logic                             clk,
    input logic 			    rst_n,

    
    input logic [`BIT_VEC(N_REG_ADDR_BITS)] reg_addr,
    
    input logic [3:0] 			    cmnd_op,
    input logic [`LOG_VEC(N_ENTRIES)] 	    cmnd_addr,

    output logic [2:0] 			    stat_code,
    output logic [`BIT_VEC(5)] 		    stat_datawords,
    output logic [`LOG_VEC(N_ENTRIES)] 	    stat_addr,

    output logic [15:0]                     capability_lst,
    output logic [3:0]                      capability_type,    

    input logic 			    wr_stb,
    input logic [`BIT_VEC(N_DATA_BITS)]     wr_dat,
    
    output logic [`BIT_VEC(N_DATA_BITS)]    rd_dat,


`ifdef ENA_BIMC
    input logic 			    ovstb,
    input logic 			    lvm, 
    input logic 			    mlvm, 
    input logic 			    mrdten,
    input logic 			    bimc_rst_n,
    input logic 			    bimc_isync,
    input logic 			    bimc_idat,
    output logic 			    bimc_odat,
    output logic 			    bimc_osync,
    output logic 			    ro_uncorrectable_ecc_error_a,
    output logic 			    ro_uncorrectable_ecc_error_b,
`endif

    
    input logic [`LOG_VEC(N_ENTRIES)] 	    hw_adda, 
    input logic 			    hw_wea, 
    input logic [`BIT_VEC(N_DATA_BITS)]     hw_bwea, 
    input logic 			    hw_csa, 
    input logic [`BIT_VEC(N_DATA_BITS)]     hw_dina, 
    output logic [`BIT_VEC(N_DATA_BITS)]    hw_douta,
    output logic 			    hw_yielda,

    input logic [`LOG_VEC(N_ENTRIES)] 	    hw_addb, 
    input logic 			    hw_web, 
    input logic [`BIT_VEC(N_DATA_BITS)]     hw_bweb, 
    input logic 			    hw_csb, 
    input logic [`BIT_VEC(N_DATA_BITS)]     hw_dinb, 
    output logic [`BIT_VEC(N_DATA_BITS)]    hw_doutb,
    output logic 			    hw_yieldb
  );


   import nx_mem_typePKG_v2::*;  

   localparam capabilities_t capabilities_t_set
     = '{ init_inc     : (N_INIT_INC_BITS>0)? TRUE : FALSE,
	  compare      : FALSE,
          reserved_op  : 4'b0,
          default      : TRUE};  
      
   

  logic                         enable;  
  logic                         yield;
  logic [`LOG_VEC(N_ENTRIES)]   sw_add;
  logic                         sw_cs;  
  logic [`BIT_VEC(N_DATA_BITS)] sw_wdat;
  logic                         sw_we;

  logic [`LOG_VEC(N_ENTRIES)]   add;    
  logic [`BIT_VEC(N_DATA_BITS)] bwe;    
  logic                         cs;     
  logic [`BIT_VEC(N_DATA_BITS)] din;    
  logic                         we;     
  logic [`BIT_VEC(N_DATA_BITS)] dout;  


   
   logic                        sw_csa;
   assign sw_csa = sw_cs && (sw_we?(SW_WR_PORT==0):(SW_RD_PORT==0));
   assign csa  = hw_csa || sw_csa;
   assign adda = hw_csa ? hw_adda : sw_add;
   assign bwea = hw_csa ? hw_bwea : {N_DATA_BITS{1'b1}}; 
   assign dina = hw_csa ? hw_dina : sw_wdat;
   assign wea  = hw_csa ? hw_wea  : sw_we;

   assign hw_douta = enable ? douta : rd_dat;   

   logic                        sw_csb;
   assign sw_csb = sw_cs && (sw_we?(SW_WR_PORT==1):(SW_RD_PORT==1));
   assign csb  = hw_csb || sw_csa;
   assign addb = hw_csb ? hw_addb : sw_add;
   assign bweb = hw_csb ? hw_bweb : {N_DATA_BITS{1'b1}}; 
   assign dinb = hw_csb ? hw_dinb : sw_wdat;
   assign web  = hw_csb ? hw_web  : sw_we;

   assign hw_doutb = enable ? doutb : rd_dat;   

   always_comb begin
      hw_yielda = 0;
      hw_yieldb = 0;
      if (yield) begin
         if (sw_we) begin
            if (SW_WR_PORT)
              hw_yieldb = 1;
            else
              hw_yielda = 1;
         end
         else begin
            if (SW_RD_PORT)
              hw_yieldb = 1;
            else
              hw_yielda = 1;
         end
      end 
   end

   logic grant;
   assign grant = (sw_csa && !hw_csa) || (sw_csb && !hw_csb);

   localparam TOTAL_LATENCY = IN_FLOP+OUT_FLOP+RD_LATENCY;
   logic [`BIT_VEC(TOTAL_LATENCY)] r_rsp;
   always_ff@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         r_rsp <= '0;
      end
      begin
         r_rsp <= {r_rsp[TOTAL_LATENCY-2:0], !sw_we && grant};
      end
   end
   
   nx_ram_2rw 
     #(.WIDTH(N_DATA_BITS), 
       .DEPTH(N_ENTRIES),
       .SPECIALIZE(SPECIALIZE), 
       .LATCH(LATCH),
       .IN_FLOP(IN_FLOP),
       .OUT_FLOP(OUT_FLOP),
       .RD_LATENCY(RD_LATENCY))
   u_ram
     (.*);

  logic [`LOG_VEC(N_ENTRIES)] addr_limit; 
   assign addr_limit = N_ENTRIES-1;

   nx_indirect_access_cntrl_v2
     #(.MEM_TYPE              (RAM_2RW),
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
       (.rsp                  (r_rsp[TOTAL_LATENCY-1]),
        .grant                (grant),
        .sw_rdat              (SW_RD_PORT?doutb:douta),
        .reset                (), 
        .cmnd_table_id        ('0),
        .stat_table_id        (),
	.sw_ce                (),
	.sw_match             ('0),
	.sw_aindex            ('0),
        .*);
     
   
   
`ifndef SYNTHESIS
   function [`BIT_VEC(N_DATA_BITS)] set
     (input integer addr, logic [`BIT_VEC(N_DATA_BITS)] data);


     `DEBUG("(%d, 0x%x)", addr, data);
     
     if (addr > stat_addr) begin
       `ERROR("Received address of %d, maximum supported is %d", 
              addr, stat_addr);
       return {N_DATA_BITS{1'bx}};
     end
     else if (stat_addr)
       u_ram.g.u_ram.set_backdoor(6, addr, data);
     else
       `ERROR("Backdoor write to disabled memory is not supported");

     return data;
   endfunction : set
   
   function [`BIT_VEC(N_DATA_BITS)] get
     (input integer addr);

     logic [`BIT_VEC(N_DATA_BITS)] data;
     
     if (addr > stat_addr) begin
       `ERROR("Received address of %d, maximum supported is %d", 
              addr, stat_addr);
       data = {N_DATA_BITS{1'bx}};
     end
     else if (stat_addr)
       u_ram.g.u_ram.get_backdoor(4, addr, data);
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
       u_ram.g.u_ram.get_backdoor(4, addr, rdata);
     else
       rdata = rd_dat;
     
     if ((check !== {N_DATA_BITS{1'bx}}) && (rdata != check))
       `ERROR("read 0x%0x from %s[%d] but expecting 0x%0x", 
              rdata, name, addr, check);
     else
       `INFO("backdoor read 0x%0x from %s[%d]", rdata, name, addr);
   endtask : read
   
   task write (input string name, input integer addr,
               input bit [`BIT_VEC(N_DATA_BITS)] wdata);
     if (addr > stat_addr)
       `ERROR("Received address of %d, maximum supported is %d", 
              addr, N_ENTRIES);
     else if (stat_addr)
       u_ram.g.u_ram.set_backdoor(6, addr, wdata);
     else
       `ERROR("Backdoor write in INIT state is not supported"); 
     
     `INFO("backdoor write 0x%x to %s[%d]", wdata, name, addr);
   endtask : write
`endif

endmodule 







