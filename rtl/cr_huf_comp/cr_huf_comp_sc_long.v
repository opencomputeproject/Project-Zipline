/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_huf_comp.vh"

module cr_huf_comp_sc_long
  (
   
   sc_long_bimc_odat, sc_long_bimc_osync,
   sc_long_sa_ro_uncorrectable_ecc_error, sc_sm_long_intf,
   sc_is_long_intf, sc_is_long_vld,
   
   clk, rst_n, lvm, mlvm, mrdten, sc_long_bimc_rst_n,
   sc_long_bimc_isync, sc_long_bimc_idat, sm_sc_long_intf,
   is_sc_long_rd
   );
   
`include "cr_structs.sv"
   
   import cr_huf_compPKG::*;
   import cr_huf_comp_regsPKG::*;
   
   
   
   input                               clk;
   input 			       rst_n;
   
   
   
   input 			      lvm;
   input 			      mlvm;
   input 			      mrdten;
   input  			      sc_long_bimc_rst_n;
   input  			      sc_long_bimc_isync;
   input  			      sc_long_bimc_idat;   
   output logic  		      sc_long_bimc_odat;   
   output logic  		      sc_long_bimc_osync;
   output logic 		      sc_long_sa_ro_uncorrectable_ecc_error;
   
   
   
   input  s_sm_sc_long_intf            sm_sc_long_intf;
   output s_sc_sm_long_intf            sc_sm_long_intf;
   
   
   
   
   input                               is_sc_long_rd;
   output s_sc_is_long_intf            sc_is_long_intf;
   output logic                        sc_is_long_vld;
   
   
   
      
   
   
   logic		empty;			
   logic		full;			
   logic		overflow;		
   logic		underflow;		
   


   logic [8:0]       used_slots;
   logic [8:0]       free_slots;
   logic [14:0]      wr_data;
   logic [14:0]      rd_data;
   logic 	     wr;
   logic 	     aempty;
   logic 	     fifo_rd;
   
   
   
   always_comb begin
      fifo_rd                 = 0;
      if (is_sc_long_rd && used_slots > 0)
	fifo_rd               = 1;
      
      sc_sm_long_intf.rdy     = free_slots > 4;
      aempty                  = 0;
      
      if (used_slots <= 1)
	aempty                = 1;
 
      if (!empty)
	sc_is_long_vld        = 1;
      else 
	sc_is_long_vld        = 0;

      sc_is_long_intf.cnt     = {2'd0, rd_data[14]};
      sc_is_long_intf.long    = rd_data[13:6];
      sc_is_long_intf.seq_id  = rd_data[5:2];
      sc_is_long_intf.eob     = e_pipe_eob'(rd_data[1:0]);
      
   end

   
   always_ff @(negedge rst_n or posedge clk) begin
      if (!rst_n) begin
	 
	 
	 
	 wr <= 0;
	 wr_data <= 0;
	 
      end
      else begin
	 wr    <= 1'd0;
	 if (sm_sc_long_intf.wr) begin
	    wr <= 1'd1;
	    wr_data <= {sm_sc_long_intf.vld,
			sm_sc_long_intf.long, 
			sm_sc_long_intf.seq_id,
			sm_sc_long_intf.eob};
	 end 
      end 
   end
   
   
   
   nx_fifo_ram_1r1w  
     #(.DEPTH            (256),               
       .WIDTH            (15),
       .UNDERFLOW_ASSERT (1),
       .OVERFLOW_ASSERT  (1),
       .SPECIALIZE       (1),
       .IN_FLOP          (0),
       .OUT_FLOP         (0),
       .RD_LATENCY       (1))  
   sc_fifo_long
     (
      
      .empty				(empty),
      .full				(full),
      .used_slots			(used_slots),		 
      .free_slots			(free_slots),		 
      .rerr				(),			 
      .rdata				(rd_data),		 
      .underflow			(underflow),
      .overflow				(overflow),
      .bimc_odat			(sc_long_bimc_odat),	 
      .bimc_osync			(sc_long_bimc_osync),	 
      .ro_uncorrectable_ecc_error	(sc_long_sa_ro_uncorrectable_ecc_error), 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .wen				(wr),			 
      .wdata				(wr_data),		 
      .ren				(fifo_rd),		 
      .clear				(1'd0),			 
      .bimc_idat			(sc_long_bimc_idat),	 
      .bimc_isync			(sc_long_bimc_isync),	 
      .bimc_rst_n			(sc_long_bimc_rst_n),	 
      .lvm				(lvm),
      .mlvm				(mlvm),
      .mrdten				(mrdten));
   
  
  
   
endmodule 









