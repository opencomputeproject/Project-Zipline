/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_huf_comp.vh"

module cr_huf_comp_is_long
  (
   
   is_sc_long_rd, is_ht_long_intf,
   
   clk, rst_n, sc_is_long_vld, sc_is_long_intf, ht_is_long_not_ready
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

  `ifdef THESE_AUTOS_SHOULD_BE_EMPTY
   
   
  `endif
 
 
 
 input			                        clk;
 input			                        rst_n;
 
 
 

 
 input   		                        sc_is_long_vld;   
 input  s_sc_is_long_intf                       sc_is_long_intf;   

 
 input                                          ht_is_long_not_ready;
   
 
 
 

 
 output                                         is_sc_long_rd;

 
 output s_is_ht_long_intf                       is_ht_long_intf;
   
   
 
 

 
 
 

 

    cr_huf_comp_is 
    #(
      .DAT_WIDTH        (`CREOLE_HC_LONG_DAT_WIDTH),       
      .CNT_WIDTH        (`CREOLE_HC_LONG_CNT_WIDTH),       
      .SYM_FREQ_WIDTH   (`CREOLE_HC_LONG_FREQ_WIDTH),      
      .MAX_NUM_SYM_USED (`CREOLE_HC_LONG_NUM_MAX_SYM_USED)  
     )
    insert_sort (
		 
		 .is_sc_rd		(is_sc_long_rd),	 
		 .is_ht_sym_lo		(is_ht_long_intf.sym_lo[(`CREOLE_HC_LONG_DAT_WIDTH)-1:0]), 
		 .is_ht_sym_hi		(is_ht_long_intf.sym_hi[(`CREOLE_HC_LONG_DAT_WIDTH)-1:0]), 
		 .is_ht_sym_unique	(is_ht_long_intf.sym_unique[(`CREOLE_HC_LONG_DAT_WIDTH)-1:0]), 
		 .is_ht_sym_sort_freq	(is_ht_long_intf.sort_freq), 
		 .is_ht_sym_sort_freq_sym(is_ht_long_intf.sort_freq_sym), 
		 .is_ht_meta		(),			 
		 .is_ht_seq_id		(is_ht_long_intf.seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
		 .is_ht_eob		(is_ht_long_intf.eob),	 
		 
		 .clk			(clk),			 
		 .rst_n			(rst_n),		 
		 .sc_is_vld		({3'b0,sc_is_long_vld}), 
		 .sc_is_sym0		(sc_is_long_intf.long[(`CREOLE_HC_LONG_DAT_WIDTH)-1:0]), 
		 .sc_is_sym1		(`CREOLE_HC_LONG_DAT_WIDTH'b0), 
		 .sc_is_sym2		(`CREOLE_HC_LONG_DAT_WIDTH'b0), 
		 .sc_is_sym3		(`CREOLE_HC_LONG_DAT_WIDTH'b0), 
		 .sc_is_cnt0		(sc_is_long_intf.cnt),	 
		 .sc_is_cnt1		(`CREOLE_HC_LONG_CNT_WIDTH'b0), 
		 .sc_is_cnt2		(`CREOLE_HC_LONG_CNT_WIDTH'b0), 
		 .sc_is_cnt3		(`CREOLE_HC_LONG_CNT_WIDTH'b0), 
		 .sc_is_meta		(1'b0),			 
		 .sc_is_seq_id		(sc_is_long_intf.seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
		 .sc_is_eob		(sc_is_long_intf.eob),	 
		 .ht_is_not_ready	(ht_is_long_not_ready));	 
   

endmodule 








