/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/















`include "cr_huf_comp.vh"
module cr_huf_comp_is
  #(parameter
    DAT_WIDTH        =10,       
    CNT_WIDTH        =3,        
    SYM_FREQ_WIDTH   =15,       
    CNTRL_WIDTH      =1,        
    MAX_NUM_SYM_USED =576,      
    REPLICATOR_LOAD  =8         
   )
  (
   
   is_sc_rd, is_ht_sym_lo, is_ht_sym_hi, is_ht_sym_unique,
   is_ht_sym_sort_freq, is_ht_sym_sort_freq_sym, is_ht_meta,
   is_ht_seq_id, is_ht_eob,
   
   clk, rst_n, sc_is_vld, sc_is_sym0, sc_is_sym1, sc_is_sym2,
   sc_is_sym3, sc_is_cnt0, sc_is_cnt1, sc_is_cnt2, sc_is_cnt3,
   sc_is_meta, sc_is_seq_id, sc_is_eob, ht_is_not_ready
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

  parameter NUM_IN_SYMBOLS   =4;



   
   
   
 
 
 
 input                                        clk;
 input                                        rst_n; 
 
 
 

 
 input [NUM_IN_SYMBOLS-1:0] 		      sc_is_vld;       
 input [DAT_WIDTH-1:0]  		      sc_is_sym0;      
 input [DAT_WIDTH-1:0]  		      sc_is_sym1;      
 input [DAT_WIDTH-1:0]  		      sc_is_sym2;      
 input [DAT_WIDTH-1:0]  		      sc_is_sym3;      
 input [CNT_WIDTH-1:0]  		      sc_is_cnt0;      
 input [CNT_WIDTH-1:0]  		      sc_is_cnt1;      
 input [CNT_WIDTH-1:0]  		      sc_is_cnt2;      
 input [CNT_WIDTH-1:0]  		      sc_is_cnt3;      
 input [CNTRL_WIDTH-1:0]                      sc_is_meta;      
 input [`CREOLE_HC_SEQID_WIDTH-1:0] 	      sc_is_seq_id;    
 input e_pipe_eob                             sc_is_eob;       
                                                               
                                                               
                                                               
                                                               
 
 input  				      ht_is_not_ready; 

 
 
 

 
 output 	                              is_sc_rd;       

 
 output [DAT_WIDTH-1:0] 		      is_ht_sym_lo;   
 output [DAT_WIDTH-1:0] 		      is_ht_sym_hi;   
 output [DAT_WIDTH-1:0] 		      is_ht_sym_unique; 
 output [MAX_NUM_SYM_USED-1:0][SYM_FREQ_WIDTH-1:0] is_ht_sym_sort_freq; 
 output [MAX_NUM_SYM_USED-1:0][DAT_WIDTH-1:0] is_ht_sym_sort_freq_sym; 
 output [CNTRL_WIDTH-1:0]                     is_ht_meta;
 output [`CREOLE_HC_SEQID_WIDTH-1:0]          is_ht_seq_id;  
 output e_pipe_eob                            is_ht_eob;     
                                                             
                                                             
                                                             
                                                             

 
 
 e_pipe_eob		eob;			
 wire [CNTRL_WIDTH-1:0]	meta;			
 wire [MAX_NUM_SYM_USED-1:0] [SYM_FREQ_WIDTH-1:0] new_freq;
 wire			not_ready;		
 wire [`CREOLE_HC_SEQID_WIDTH-1:0] seq_id;	
 wire [DAT_WIDTH-1:0]	sym_hi;			
 wire [DAT_WIDTH-1:0]	sym_lo;			
 
 


cr_huf_comp_is_counter 
    #(
      .DAT_WIDTH        (DAT_WIDTH), 
      .CNT_WIDTH        (CNT_WIDTH), 
      .SYM_FREQ_WIDTH   (SYM_FREQ_WIDTH), 
      .CNTRL_WIDTH      (CNTRL_WIDTH),
      .MAX_NUM_SYM_USED (MAX_NUM_SYM_USED)
     )
   insert_sort_counter (
			
			.is_sc_rd	(is_sc_rd),
			.new_freq	(new_freq),
			.meta		(meta[CNTRL_WIDTH-1:0]),
			.seq_id		(seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
			.eob		(eob),
			.sym_lo		(sym_lo[DAT_WIDTH-1:0]),
			.sym_hi		(sym_hi[DAT_WIDTH-1:0]),
			
			.clk		(clk),
			.rst_n		(rst_n),
			.sc_is_vld	(sc_is_vld[NUM_IN_SYMBOLS-1:0]),
			.sc_is_sym0	(sc_is_sym0[DAT_WIDTH-1:0]),
			.sc_is_sym1	(sc_is_sym1[DAT_WIDTH-1:0]),
			.sc_is_sym2	(sc_is_sym2[DAT_WIDTH-1:0]),
			.sc_is_sym3	(sc_is_sym3[DAT_WIDTH-1:0]),
			.sc_is_cnt0	(sc_is_cnt0[CNT_WIDTH-1:0]),
			.sc_is_cnt1	(sc_is_cnt1[CNT_WIDTH-1:0]),
			.sc_is_cnt2	(sc_is_cnt2[CNT_WIDTH-1:0]),
			.sc_is_cnt3	(sc_is_cnt3[CNT_WIDTH-1:0]),
			.sc_is_meta	(sc_is_meta[CNTRL_WIDTH-1:0]),
			.sc_is_seq_id	(sc_is_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
			.sc_is_eob	(sc_is_eob),
			.not_ready	(not_ready));

   
  
  
  cr_huf_comp_is_sorter 
    #(
      .DAT_WIDTH        (DAT_WIDTH), 
      .REPLICATOR_LOAD  (REPLICATOR_LOAD),
      .SYM_FREQ_WIDTH   (SYM_FREQ_WIDTH), 
      .CNTRL_WIDTH      (CNTRL_WIDTH),
      .MAX_NUM_SYM_USED (MAX_NUM_SYM_USED)
     )
   insert_sort_sorter (
		       
		       .not_ready	(not_ready),
		       .is_ht_sym_lo	(is_ht_sym_lo[DAT_WIDTH-1:0]),
		       .is_ht_sym_hi	(is_ht_sym_hi[DAT_WIDTH-1:0]),
		       .is_ht_sym_unique(is_ht_sym_unique[DAT_WIDTH-1:0]),
		       .is_ht_sym_sort_freq(is_ht_sym_sort_freq),
		       .is_ht_sym_sort_freq_sym(is_ht_sym_sort_freq_sym),
		       .is_ht_meta	(is_ht_meta[CNTRL_WIDTH-1:0]),
		       .is_ht_seq_id	(is_ht_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
		       .is_ht_eob	(is_ht_eob),
		       
		       .clk		(clk),
		       .rst_n		(rst_n),
		       .new_freq	(new_freq),
		       .meta		(meta[CNTRL_WIDTH-1:0]),
		       .seq_id		(seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
		       .eob		(eob),
		       .sym_lo		(sym_lo[DAT_WIDTH-1:0]),
		       .sym_hi		(sym_hi[DAT_WIDTH-1:0]),
		       .ht_is_not_ready	(ht_is_not_ready));
   
endmodule 







