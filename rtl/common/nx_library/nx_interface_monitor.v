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
module nx_interface_monitor
  #(parameter
    IN_FLIGHT=0,          
    IN_FLIGHT_USE=0,
                          
    CMND_ADDRESS=0,       
    STAT_ADDRESS=0,       
    IMRD_ADDRESS=0,       
    ALIGNMENT=2,          
    N_TIMER_BITS=6,       
                          
    N_REG_ADDR_BITS=16,   
                          
    N_DATA_BITS= 32,      
    N_ENTRIES=1,          
    N_INIT_INC_BITS=0,    
                          
                          
    SPECIALIZE=1,         
    LATCH=0,              
    parameter [`BIT_VEC(N_DATA_BITS)] RAM_MASK={N_DATA_BITS{1'b1}}, 
    parameter [`BIT_VEC(N_DATA_BITS)] RESET_DATA=0)                 

   (
   
   stat_code, stat_datawords, stat_addr, capability_lst,
   capability_type, rd_dat, bimc_odat, bimc_osync,
   ro_uncorrectable_ecc_error, im_rdy, im_available, im_status,
   
   clk, rst_n, reg_addr, cmnd_op, cmnd_addr, wr_stb, wr_dat, ovstb,
   lvm, mlvm, mrdten, bimc_rst_n, bimc_isync, bimc_idat, im_din,
   im_vld, im_consumed, im_config
   );

   localparam N_RAM_BITS = count_ram_mask_ones(); 

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
   
`ifdef ENA_BIMC
   input logic 				   ovstb;
   input logic 				   lvm; 
   input logic 				   mlvm; 
   input logic 				   mrdten;
   input logic 				   bimc_rst_n;
   input logic 				   bimc_isync;
   input logic 				   bimc_idat;
   output logic 			   bimc_odat;
   output logic 			   bimc_osync;
   output logic 			   ro_uncorrectable_ecc_error;
`endif
   
   
   input 				   im_din_t 	   im_din;
   input 				   im_vld;
   output 				   im_rdy;

   output 				   im_available_t im_available;
   input 				   im_consumed_t im_consumed;
   
   
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
     = '{ init_inc     : (N_INIT_INC_BITS>0)? TRUE : FALSE,
	  compare      : FALSE,
          reserved_op  : 4'b0,
          default      : TRUE};  
   
   
   localparam N_ENTRIES_HALF   = (N_ENTRIES/2);

   logic [3:0] 	                     im_din_space_avail;
   im_din_t                          im_din_dly;
   logic 			     im_din_empty;
   logic 			     im_din_full;
   logic 			     im_din_rd;

   
   im_available_t im_available_pre;
      

   
   
   
   logic 				    enable;  
   logic 				    yield;
   logic [`LOG_VEC(N_ENTRIES)] 		    sw_add;
   logic 				    sw_cs;  
   logic [`BIT_VEC(N_DATA_BITS)] 	    sw_wdat;
   logic 				    sw_we;
   
   logic [`LOG_VEC(N_ENTRIES)] 		    add;    
   logic [`BIT_VEC(N_DATA_BITS)] 	    bwe;    
   logic 				    cs;     
   logic [`BIT_VEC(N_DATA_BITS)] 	    din;    
   logic 				    we;     
   logic [`BIT_VEC(N_DATA_BITS)] 	    dout;
   
   
   
   logic [`LOG_VEC(N_ENTRIES)] 		    hw_add;
   logic 				    hw_we;
   logic 				    hw_cs; 
   logic [`BIT_VEC(N_DATA_BITS)] 	    hw_din; 
   logic 				    hw_yield;
   logic [`LOG_VEC((N_ENTRIES/2)+1)] 	    credit_available;
   logic [`LOG_VEC((N_ENTRIES/2)+1)] 	    credit_return;
   logic [`LOG_VEC((N_ENTRIES/2)+1)] 	    credit_used;
   logic 				    im_rd_stb;
   
   logic 				    ready;                    
   logic 				    bank_status;        
   logic 				    im_vld_qual;
   logic 				    sw_init;
   logic [`LOG_VEC(N_ENTRIES)] 		    wr_pointer;

   logic 				    im_vld_dly;
   logic 				    overflow;

   logic 				    im_vld_mod;
   logic 				    im_vld_if;

   assign im_vld_mod = im_vld & im_rdy;
   
			
   im_consumed_t im_consumed_reg;
   

   assign im_vld_dly = ~im_din_empty && (credit_available != 0);
   assign im_din_rd  = im_vld_dly;

   assign im_vld_if  = (IN_FLIGHT_USE != 0) ? im_vld : im_vld_mod;
   

   
   
   sync_fifo 
     #(.DATAWIDTH     (N_DATA_BITS),
       .DEPTH         (8),
       .RD_REG_MODE   (0), 
       .RD_LATCH_MODE (0))
   u_sync_fifo
     (
      
      .dout				(im_din_dly),		 
      .full				(im_din_full),		 
      .empty				(im_din_empty),		 
      .space_avail			(im_din_space_avail),	 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .din				(im_din),		 
      .wr_en				(im_vld_if),		 
      .rd_en				(im_din_rd));		 
   
   
   assign sw_init = im_config.mode == 2'b11 ? 1'd1 : 1'd0;
   
   
   hw_status_t hw_status;
   sw_config_t sw_config;

   assign wr_pointer = hw_add == 0 ? N_ENTRIES-1 : hw_add - 1; 
   
   
   assign sw_config.dis_used         = 1'd0;
   assign sw_config.dis_return       = 1'd0;
   assign sw_config.credit_limit     = im_config.wr_credit_config;
   assign im_available_pre.bank_lo   = ready & !bank_status;
   assign im_available_pre.bank_hi   = ready &  bank_status;
   assign im_status.overflow         = overflow;
   assign im_status.wr_pointer       = wr_pointer;
   assign im_status.available        = im_available_pre;
   
   
   assign im_rd_stb     = (wr_stb && (reg_addr == IMRD_ADDRESS)) | im_consumed_reg.bank_lo | im_consumed_reg.bank_hi;

   always_comb begin
      credit_return = 0;
      if (im_rd_stb) begin
	 credit_return = N_ENTRIES_HALF;
      end
   end
	   
	    

   
   assign im_rdy    = im_config.mode == 2'b00 ? 1'd1                                          : 
	              im_config.mode == 2'b01 ? 1'd1                                          : 
		      im_config.mode == 2'b10 ? (im_din_space_avail > IN_FLIGHT) & ~hw_yield  : 
		                                1'd1;                                           
   
   
   assign ready     = im_config.mode == 2'b00 ?   |hw_status.credit_issued                    : 
	              im_config.mode == 2'b01 ?   |hw_status.credit_issued                    : 
		      im_config.mode == 2'b10 ?   (hw_status.credit_issued >= N_ENTRIES_HALF) : 
                                                  1'd0;                                         
   
   
   assign im_vld_qual = im_config.mode == 2'b00 ?   im_vld_dly & |credit_available            : 
	                im_config.mode == 2'b01 ?   im_vld_dly                                : 
		        im_config.mode == 2'b10 ?   im_vld_dly                                : 
			                            1'd0;                                       

   

   assign hw_cs  = im_vld_qual;
   assign hw_we  = im_vld_qual;
   assign hw_din = im_din_dly;
   
   
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
	 
	 
	 bank_status <= 0;
	 hw_add <= 0;
	 im_available <= 0;
	 im_consumed_reg <= 0;
	 overflow <= 0;
	 
      end
      else begin
	 im_available    <= im_available_pre;
	 im_consumed_reg <= im_consumed;
	 if (sw_init) begin
	    bank_status <= 0;
	    hw_add <= 0;
	    overflow <= 0;
	 end
	 overflow <= overflow | (im_vld_mod & im_din_full);
	 if (im_vld_qual) begin
	    hw_add <= hw_add + 1;
	    if (im_config.mode == 2'b10) begin
	       if (im_din_dly.desc.eob)
		 if (hw_add < N_ENTRIES_HALF)
		   hw_add <= N_ENTRIES_HALF;
		 else 
		   hw_add <= 0;
	       else
		 hw_add <= hw_add + 1;
	    end
	 end
	 if (im_rd_stb && (hw_status.credit_issued >= N_ENTRIES_HALF)) begin
	    bank_status <= ~bank_status;
	 end
      end
   end
   
   
   assign cs  = hw_cs || sw_cs;
   assign add = hw_cs ? hw_add : sw_add;
   assign bwe = {N_DATA_BITS{1'b1}}; 
   assign din = hw_cs ? hw_din : sw_wdat;
   assign we  = hw_cs ? hw_we  : sw_we;
 
   assign hw_yield = yield;

   always_comb begin
      if (hw_we) 
	if (im_config.mode == 2'b00)
	  credit_used = 1;
	else if (im_config.mode == 2'b10)
	  if (im_din_dly.desc.eob)
	    if (hw_add < N_ENTRIES_HALF)
	      credit_used = N_ENTRIES_HALF - hw_add;
	    else 
	      credit_used = N_ENTRIES - hw_add; 
	  else
	    credit_used = 1;
	else 
	  credit_used = 0;  
      else
	credit_used = 0;
   end		   
   
   
   nx_credit_manager 
     #(.N_MAX_CREDITS                 (N_ENTRIES),                          
       .N_USED_LAG_CYCLES             (0),      
       .N_MAX_CREDITS_PER_CYCLE       (N_ENTRIES/2)) 
   u_nx_credit_manager
     (.*);

   logic [`BIT_VEC(N_RAM_BITS)] ram_din;
   logic [`BIT_VEC(N_RAM_BITS)] ram_bwe;
   logic [`BIT_VEC(N_RAM_BITS)] ram_dout;

   
   function int count_ram_mask_ones;
      int count;
      count = 0;
      for (int i=0; i<N_DATA_BITS; i++) begin
	 if (RAM_MASK[i]) 
	   count++;
      end
      return count;
   endfunction

   function [`BIT_VEC(N_RAM_BITS)] pack_ram;
      input [`BIT_VEC(N_DATA_BITS)] in;
      begin
         int j;
         j = 0;
         for (int i=0; i<N_DATA_BITS; i++) begin
            if (RAM_MASK[i]) begin 
               pack_ram[j] = in[i];
               j++;
            end
         end
         return pack_ram;
      end
   endfunction

   function [`BIT_VEC(N_DATA_BITS)] unpack_ram;
      input [`BIT_VEC(N_RAM_BITS)] in;
      begin
         int j;
         j = 0;
         unpack_ram = 0;
         for (int i=0; i<N_DATA_BITS; i++) begin
            if (RAM_MASK[i]) begin 
               unpack_ram[i] = in[j];
               j++;
            end
         end
         return unpack_ram;
      end
   endfunction

   assign ram_din = pack_ram(din);
   assign ram_bwe = pack_ram(bwe);
   assign dout = unpack_ram(ram_dout);

   nx_ram_1rw
     #(.WIDTH(N_RAM_BITS), 
       .DEPTH(N_ENTRIES),
       .SPECIALIZE(SPECIALIZE), 
       .LATCH(LATCH)) 
   u_ram
     (.din (ram_din),
      .dout (ram_dout),
      .bwe (ram_bwe),
      .*);


  logic [`LOG_VEC(N_ENTRIES)] addr_limit; 
   assign addr_limit = N_ENTRIES-1;

   nx_indirect_access_cntrl
     #(.MEM_TYPE              (SPRAM),
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
       (.grant                (!hw_cs),
        .sw_rdat              (dout),
        .reset                (), 
        .cmnd_table_id        ('0),
        .stat_table_id        (),
	.sw_ce                (),
	.sw_match             ('0),
	.sw_aindex            ('0),
        
	
	.stat_code			(stat_code[2:0]),
	.stat_datawords			(stat_datawords[`BIT_VEC(5)]),
	.stat_addr			(stat_addr[`LOG_VEC(N_ENTRIES)]),
	.capability_lst			(capability_lst[15:0]),
	.capability_type		(capability_type[3:0]),
	.enable				(enable),
	.rd_dat				(rd_dat[`BIT_VEC(N_DATA_BITS)]),
	.sw_cs				(sw_cs),
	.sw_we				(sw_we),
	.sw_add				(sw_add[`LOG_VEC(N_ENTRIES)]),
	.sw_wdat			(sw_wdat[`BIT_VEC(N_DATA_BITS)]),
	.yield				(yield),
	
	.clk				(clk),
	.rst_n				(rst_n),
	.wr_stb				(wr_stb),
	.reg_addr			(reg_addr[`BIT_VEC(N_REG_ADDR_BITS)]),
	.cmnd_op			(cmnd_op[3:0]),
	.cmnd_addr			(cmnd_addr[`LOG_VEC(N_ENTRIES)]),
	.addr_limit			(addr_limit),
	.wr_dat				(wr_dat[`BIT_VEC(N_DATA_BITS)]));
     
   
   
`ifndef SYNTHESIS
   
   
   task read (input string name, input integer addr,
              output bit [`BIT_VEC(N_DATA_BITS)] rdata,
              input [`BIT_VEC(N_DATA_BITS)] check={N_DATA_BITS{1'bx}});
     if (addr > stat_addr) begin
       `ERROR("Received address of %d, maximum supported is %d", 
              addr, N_ENTRIES);
       rdata = {N_DATA_BITS{1'bx}};
     end
     else if (stat_addr)
       u_ram.g.u_ram.get_backdoor(4, addr, rdata[`BIT_VEC(N_RAM_BITS)]);
     else
       rdata = rd_dat;

      rdata = unpack_ram(rdata[`BIT_VEC(N_RAM_BITS)]);

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
       u_ram.g.u_ram.set_backdoor(6, addr, pack_ram(wdata));
     else
       `ERROR("Backdoor write in INIT state is not supported"); 
     
     `INFO("backdoor write 0x%x to %s[%d]", wdata, name, addr);
   endtask : write
`endif

endmodule 






