/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_huf_comp.vh"

module cr_huf_comp_sq
  (
   
   sq_bimc_odat, sq_bimc_osync, sq_sa_ro_uncorrectable_ecc_error,
   sq_sa_intf, sq_sm_intf,
   
   clk, rst_n, lvm, mlvm, mrdten, ovstb, sq_bimc_isync, sq_bimc_idat,
   sq_bimc_rst_n, sa_sq_intf, sm_sq_intf
   );
   
`include "cr_structs.sv"
   
   import cr_huf_compPKG::*;
   import cr_huf_comp_regsPKG::*;
   
   
   
   
   input                               clk;
   input 			       rst_n;
   
   
   
   
   input 			      lvm;
   input 			      mlvm;
   input 			      mrdten;
   input 			      ovstb;
   input  			      sq_bimc_isync;
   input  			      sq_bimc_idat;
   input  			      sq_bimc_rst_n;  
   output logic  		      sq_bimc_odat;   
   output logic  		      sq_bimc_osync;
   output logic 		      sq_sa_ro_uncorrectable_ecc_error;
   
   
   
   input  s_sa_sq_intf                 sa_sq_intf;             
   output s_sq_sa_intf                 sq_sa_intf;

   
   
   
   input  s_sm_sq_intf                 sm_sq_intf;
   output s_sq_sm_intf                 sq_sm_intf; 

      
   
   
   logic		empty;			
   logic		full;			
   logic [(`CREOLE_HC_SYMBOL_QUEUE_WIDTH)-1:0] rdata;
   
   logic [`LOG_VEC((`N_HUFF_SQ_DEPTH)+1)]  used_slots;
   logic 	 		           aempty;
   logic 				   afull;
   
   
   always_comb begin
      aempty            = 0;
      afull             = 0;
      sq_sm_intf.rdy    = 0;
      if (used_slots == 1)
	aempty = 1;
      if (used_slots >= (`N_HUFF_SQ_DEPTH-1))
	afull  = 1;
      
      if ((!afull) || (afull && !full && !sm_sq_intf.wr))
	sq_sm_intf.rdy    = 1;
      sq_sa_intf.aempty   = aempty;
      sq_sa_intf.empty    = empty;
      sq_sa_intf.eot      = rdata[74];
      sq_sa_intf.sot      = rdata[73];		   
      sq_sa_intf.byte_vld = rdata[72:70];	     
      sq_sa_intf.tlast    = rdata[69];	     
      sq_sa_intf.eob      = rdata[68];	     
      sq_sa_intf.seq_id   = rdata[67:64];	     
      sq_sa_intf.data     = rdata[63:0];	     	     
   end

   
   
   
   

   
   cr_huf_comp_fifo 
     #(.DEPTH            (`N_HUFF_SQ_DEPTH),               
       .WIDTH            (`CREOLE_HC_SYMBOL_QUEUE_WIDTH),
       .RD_LATENCY       (2))
   symbol_queue
     (
      
      .empty				(empty),
      .full				(full),
      .used_slots			(used_slots),		 
      .free_slots			(),			 
      .rerr				(),			 
      .rdata				(rdata[(`CREOLE_HC_SYMBOL_QUEUE_WIDTH)-1:0]),
      .underflow			(),			 
      .overflow				(),			 
      .bimc_odat			(sq_bimc_odat),		 
      .bimc_osync			(sq_bimc_osync),	 
      .ro_uncorrectable_ecc_error	(sq_sa_ro_uncorrectable_ecc_error), 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .wen				(sm_sq_intf.wr),	 
      .wdata				({sm_sq_intf.eot, sm_sq_intf.sot, sm_sq_intf.byte_vld, sm_sq_intf.tlast, sm_sq_intf.eob, sm_sq_intf.seq_id, sm_sq_intf.data}), 
      .ren				(sa_sq_intf.rd),	 
      .clear				(1'd0),			 
      .bimc_iclk			(sq_bimc_isync),	 
      .bimc_idat			(sq_bimc_idat),		 
      .bimc_isync			(sq_bimc_isync),	 
      .bimc_rst_n			(sq_bimc_rst_n),	 
      .lvm				(lvm),
      .mlvm				(mlvm),
      .mrdten				(mrdten),
      .ovstb				(ovstb));
   

   
   

   
   
endmodule 








