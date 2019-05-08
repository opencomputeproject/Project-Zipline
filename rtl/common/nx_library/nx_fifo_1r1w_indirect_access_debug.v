/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "messages.vh"
`include "ccx_std.vh"
`include "nx_mem_typePKG.svp"
module nx_fifo_1r1w_indirect_access_debug 
#(
  CMND_ADDRESS=0,       
  STAT_ADDRESS=0,       
  FSTAT_ADDRESS=0,      
  ALIGNMENT=2,          
  N_TIMER_BITS=6,       
  N_REG_ADDR_BITS=16,   
  N_DATA_BITS=32,       
  N_ENTRIES=1,          
  N_INIT_INC_BITS=0,    
  SPECIALIZE=1,         
  OUT_FLOP=0)           

   (
  
  rd_data, xxx_fifo_empty, full, fifo_depth, bimc_odat, bimc_osync,
  ro_uncorrectable_ecc_error, stat_code, stat_datawords, stat_addr,
  capability_lst, capability_type, rd_dat, fifo_status_0,
  fifo_status_1,
  
  wr_data, wr, rd, clk, rst_n, bimc_idat, bimc_rst_n, bimc_isync, lvm,
  mlvm, mrdten, reg_addr, cmnd_op, cmnd_addr, wr_stb, wr_dat,
  load_dbg_values, dbg_wr_pointer, dbg_fifo_depth, force_sw_access
  );
   
   

   typedef struct packed {
      logic 	                  overflow;                 
      logic 		          underflow;                
      logic 		          full;                     
      logic 		          empty;                    
      logic [`LOG_VEC(N_ENTRIES)] wr_pointer;  
      logic [`LOG_VEC(N_ENTRIES)] rd_pointer;  
   } fifo_status_0_t;
   
   

   typedef struct packed {
      logic [`LOG_VEC(N_ENTRIES+1)] depth;
   } fifo_status_1_t;
   
		        
   
   input [N_DATA_BITS-1:0] 	      wr_data;
   input 			      wr;    
   output wire [N_DATA_BITS-1:0]      rd_data;
   input 			      rd;
   output reg 			      xxx_fifo_empty;
   output reg 			      full;
   output reg [`LOG_VEC(N_ENTRIES+1)] fifo_depth;
   
   
   input 			    clk ;
   input 			    rst_n;

   
   input 			    bimc_idat; 
   input 			    bimc_rst_n; 
   input 			    bimc_isync;
   
   output wire 			    bimc_odat; 
   output wire 			    bimc_osync;
   output wire 			    ro_uncorrectable_ecc_error;
   
   input 			    lvm; 
   input 			    mlvm;
   input 			    mrdten;
   
   
   input logic [`BIT_VEC(N_REG_ADDR_BITS)] reg_addr;
   
   input logic [3:0] 			   cmnd_op;
   input logic [`LOG_VEC(N_ENTRIES)] 	   cmnd_addr;
   
   output logic [2:0] 			   stat_code;
   output logic [`BIT_VEC(5)] 		   stat_datawords;
   output logic [`LOG_VEC(N_ENTRIES)] 	   stat_addr;
   
   output logic [15:0] 			   capability_lst;
   output logic [3:0] 			   capability_type; 
   
   input logic 				   wr_stb;
   input logic [`BIT_VEC(N_DATA_BITS)] 	   wr_dat;
   
   output logic [`BIT_VEC(N_DATA_BITS)]    rd_dat;					   
   output 				   fifo_status_0_t fifo_status_0;
   output 				   fifo_status_1_t fifo_status_1;
   
   input                                   load_dbg_values;
   input [`LOG_VEC(N_ENTRIES)]             dbg_wr_pointer;
   input [`LOG_VEC(N_ENTRIES+1)]           dbg_fifo_depth;
   input                                   force_sw_access;

   reg 				       wr_reg;
   reg 				       und_flow;
   reg 				       ovr_flow;
   reg                                 empty;
   
   reg [`LOG_VEC(N_ENTRIES)] 	       fifo_rd_addr;
   reg [`LOG_VEC(N_ENTRIES)] 	       fifo_wr_addr;
   

   reg [`LOG_VEC(N_ENTRIES+1)] 	       fifo_depth_nxt;
   reg [`LOG_VEC(N_ENTRIES)] 	       fifo_rd_addr_nxt;
   reg [`LOG_VEC(N_ENTRIES)] 	       fifo_wr_addr_nxt;
   
   
   wire [1:0] 			       fifo_op_dly   = {wr_reg,     rd};
   wire [1:0] 			       fifo_op       = {wr,         rd};
   
   

    
   always_comb begin
      if (fifo_op_dly == 2'b01) begin
	 fifo_depth_nxt = fifo_depth - 1'd1;
      end
      else if (fifo_op_dly == 2'b10) begin
	 fifo_depth_nxt = fifo_depth + 1'd1;
      end
      else begin
	 fifo_depth_nxt = fifo_depth;
      end
   end

   
   
   always_comb begin

      if ((fifo_op_dly == 2'b01) || (fifo_op_dly == 2'b11)) begin
	 fifo_rd_addr_nxt = fifo_rd_addr + 1'd1;
      end
      else begin
	 fifo_rd_addr_nxt = fifo_rd_addr;
      end
   end

   
   
   always_comb begin
      if (!full && ((fifo_op == 2'b10) || (fifo_op == 2'b11))) begin
	 fifo_wr_addr_nxt = fifo_wr_addr + 1'd1;
      end
      else begin
	 fifo_wr_addr_nxt = fifo_wr_addr;
      end
   end
   

   wire 			      hw_yield;
   
   always_comb begin
      fifo_status_0.overflow     = ovr_flow;
      fifo_status_0.underflow    = und_flow;
      fifo_status_0.full         = full;
      fifo_status_0.empty        = empty;
      fifo_status_0.wr_pointer   = fifo_wr_addr;
      fifo_status_0.rd_pointer   = fifo_rd_addr;
      fifo_status_1.depth        = fifo_depth;
   end

   always_comb begin
      empty  = 1'd1;
      full   = 1'd0;
      if (((fifo_depth_nxt == 0) && rd) || (fifo_depth == 0))
	empty = 1'd1;
      else 
        empty = 1'd0;
      if (((fifo_depth_nxt == N_ENTRIES) && wr_reg) || (fifo_depth == N_ENTRIES))
	full = 1'd1;
      else 
	full = 1'd0;
   end

   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
	 fifo_rd_addr    <= 0;
         fifo_wr_addr    <= 0;
         fifo_depth      <= 0;
         wr_reg          <= 1'd0;
         ovr_flow        <= 1'd0;
         und_flow        <= 1'd0;
         xxx_fifo_empty      <= 1'd0;
      end
      else begin 
	 fifo_rd_addr    <= fifo_rd_addr_nxt;
	 fifo_wr_addr    <= load_dbg_values ? dbg_wr_pointer : fifo_wr_addr_nxt;
	 fifo_depth      <= load_dbg_values ? dbg_fifo_depth : fifo_depth_nxt;
	 wr_reg          <= wr;


         xxx_fifo_empty      <= (((fifo_depth_nxt == 1) && (fifo_op == 2'b01)) || (fifo_depth_nxt == 0));

	 if (wr && full) begin
	    ovr_flow         <= 1'd1;
	 end
	 if (rd && empty) begin
	    und_flow         <= 1'd1;
	 end
	 if (rd && reg_addr == FSTAT_ADDRESS) begin
	    ovr_flow         <= 1'd0;
            und_flow         <= 1'd0;
	 end
      end
   end 
   

   wire [`LOG_VEC(N_ENTRIES)]   hw_raddr  = (rd == 0) ? fifo_rd_addr : fifo_rd_addr_nxt;   
   wire [`LOG_VEC(N_ENTRIES)]   hw_waddr  = fifo_wr_addr;
   wire [`BIT_VEC(N_DATA_BITS)] hw_din    = wr_data;
   wire [`BIT_VEC(N_DATA_BITS)] hw_dout;
   assign                       rd_data   = hw_dout;
	   
   
   
   wire hw_cs = ~force_sw_access && (~(hw_raddr == hw_waddr) |  wr);
   wire hw_re = ~(hw_raddr == hw_waddr);
   wire hw_we =   wr;
   
   
   nx_fifo_1r1w_indirect_access_debug_cntrl
     #( 
	.CMND_ADDRESS          (CMND_ADDRESS),       
	.STAT_ADDRESS          (STAT_ADDRESS),       
	.ALIGNMENT             (ALIGNMENT),          
	.N_TIMER_BITS          (N_TIMER_BITS),       
	.N_REG_ADDR_BITS       (N_REG_ADDR_BITS),    
	.N_DATA_BITS           (N_DATA_BITS),        
	.N_ENTRIES             (N_ENTRIES),          
	.N_INIT_INC_BITS       (N_INIT_INC_BITS),    
	.SPECIALIZE            (SPECIALIZE),         
        .OUT_FLOP              (OUT_FLOP))           
        
   u_nx_fifo_1r1w_indirect_access_debug_cntrl
     (
      
      .stat_code                        (stat_code[2:0]),
      .stat_datawords                   (stat_datawords[`BIT_VEC(5)]),
      .stat_addr                        (stat_addr[`LOG_VEC(N_ENTRIES)]),
      .capability_lst                   (capability_lst[15:0]),
      .capability_type                  (capability_type[3:0]),
      .rd_dat                           (rd_dat[`BIT_VEC(N_DATA_BITS)]),
      .bimc_odat                        (bimc_odat),
      .bimc_osync                       (bimc_osync),
      .ro_uncorrectable_ecc_error       (ro_uncorrectable_ecc_error),
      .hw_dout                          (hw_dout[`BIT_VEC(N_DATA_BITS)]),
      .hw_yield                         (hw_yield),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .reg_addr                         (reg_addr[`BIT_VEC(N_REG_ADDR_BITS)]),
      .cmnd_op                          (cmnd_op[3:0]),
      .cmnd_addr                        (cmnd_addr[`LOG_VEC(N_ENTRIES)]),
      .wr_stb                           (wr_stb),
      .wr_dat                           (wr_dat[`BIT_VEC(N_DATA_BITS)]),
      .lvm                              (lvm),
      .mlvm                             (mlvm),
      .mrdten                           (mrdten),
      .bimc_rst_n                       (bimc_rst_n),
      .bimc_isync                       (bimc_isync),
      .bimc_idat                        (bimc_idat),
      .hw_cs                            (hw_cs),
      .hw_raddr                         (hw_raddr[`LOG_VEC(N_ENTRIES)]),
      .hw_waddr                         (hw_waddr[`LOG_VEC(N_ENTRIES)]),
      .hw_we                            (hw_we),
      .hw_re                            (hw_re),
      .hw_din                           (hw_din[`BIT_VEC(N_DATA_BITS)]));
   
endmodule 








