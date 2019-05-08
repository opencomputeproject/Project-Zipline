/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
 






`include "cr_huf_comp.vh"

module cr_huf_comp_htb_short
  #(parameter
    SINGLE_PIPE          = 0
   )
  (
   
   ht_is_short_not_ready, ht1_hw1_short_intf, ht1_hw1_short_freq_val,
   ht2_hw2_short_intf, ht2_hw2_short_freq_val, short_ht1_hdr_seq_id,
   short_ht2_hdr_seq_id, short_ht1_dbg_cntr_rebuild,
   short_ht1_dbg_cntr_rebuild_failed, short_ht2_dbg_cntr_rebuild,
   short_ht2_dbg_cntr_rebuild_failed, htb_short_bimc_odat,
   htb_short_bimc_osync, htb_short_ecc_error,
   
   clk, rst_n, is_ht_short_intf, hw1_ht1_short_not_ready,
   hw1_ht1_short_intf, hw2_ht2_short_not_ready, hw2_ht2_short_intf,
   hdr_short_ht1_type, hdr_short_ht2_type,
   sw_short_ht1_xp_max_code_length,
   sw_short_ht1_deflate_max_code_length,
   sw_short_ht1_max_rebuild_limit, sw_short_ht1_force_rebuild,
   sw_short_ht2_xp_max_code_length,
   sw_short_ht2_deflate_max_code_length,
   sw_short_ht2_max_rebuild_limit, sw_short_ht2_force_rebuild,
   sw_disable_sub_pipe, htb_short_bimc_idat, htb_short_bimc_isync,
   lvm, mlvm, mrdten
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

  `ifdef THESE_AUTOS_SHOULD_BE_EMPTY
   
   
  `endif
 
 
 
 input			                        clk;
 input			                        rst_n;
 
 
 

 
 input  s_is_ht_short_intf                       is_ht_short_intf;

 
 input                                           hw1_ht1_short_not_ready;
 input  s_hw_ht_short_intf                       hw1_ht1_short_intf;
   
 
 input                                           hw2_ht2_short_not_ready;
 input  s_hw_ht_short_intf                       hw2_ht2_short_intf;   
   
 
 input  s_seq_id_type_intf		         hdr_short_ht1_type;
 input	s_seq_id_type_intf	                 hdr_short_ht2_type;

 
 input [`CREOLE_HC_SYM_CODELENGTH-1:0]   	sw_short_ht1_xp_max_code_length;
 input [`CREOLE_HC_SYM_CODELENGTH-1:0]   	sw_short_ht1_deflate_max_code_length;
 input [9:0]  	                                sw_short_ht1_max_rebuild_limit;
 input [`CR_HUF_COMP_HT_CONFIG_T_FORCE_REBUILD_DECL] sw_short_ht1_force_rebuild;
 input [`CREOLE_HC_SYM_CODELENGTH-1:0]   	sw_short_ht2_xp_max_code_length;
 input [`CREOLE_HC_SYM_CODELENGTH-1:0]   	sw_short_ht2_deflate_max_code_length;
 input [9:0]  	                                sw_short_ht2_max_rebuild_limit;
 input [`CR_HUF_COMP_HT_CONFIG_T_FORCE_REBUILD_DECL] sw_short_ht2_force_rebuild;
 input henc_disable_sub_pipe_t                  sw_disable_sub_pipe;

 input		                                htb_short_bimc_idat;
 input		                                htb_short_bimc_isync;
 input		                                lvm;	
 input		                                mlvm;	
 input		                                mrdten;	

 
 
 

 
 output 	                                 ht_is_short_not_ready;
   
 
 output s_ht_hw_short_intf                       ht1_hw1_short_intf;
 output logic [1:0]	                         ht1_hw1_short_freq_val;

 
 output s_ht_hw_short_intf                       ht2_hw2_short_intf;
 output logic [1:0]	                         ht2_hw2_short_freq_val;
   
 
 output [`CREOLE_HC_SEQID_WIDTH-1:0]            short_ht1_hdr_seq_id;
 output [`CREOLE_HC_SEQID_WIDTH-1:0]            short_ht2_hdr_seq_id;

 
 output                                         short_ht1_dbg_cntr_rebuild;
 output                                         short_ht1_dbg_cntr_rebuild_failed;
 output                                         short_ht2_dbg_cntr_rebuild;
 output                                         short_ht2_dbg_cntr_rebuild_failed;  

 output logic		                        htb_short_bimc_odat;
 output logic		                        htb_short_bimc_osync;
 output logic                                   htb_short_ecc_error;
   
 
 
 logic			bimc_odat_0;		
 logic			bimc_osync_0;		
 logic			htb1_ecc_error;		
 logic			htb2_ecc_error;		
 
 
 
 reg			ht_is_short_not_ready;
 
 e_pipe_eob                                     is_ht1_short_intf_eob;	 
 e_pipe_eob                                     is_ht2_short_intf_eob;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0]             is_ht1_short_intf_seq_id;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0]             is_ht2_short_intf_seq_id;    
 logic                                          ht1_is_not_ready;
 logic                                          ht2_is_not_ready;
 logic                                          ht2_is_not_ready_pre;
 

 
 
 
 


 always_comb
  begin

    is_ht1_short_intf_eob    = MIDDLE;
    is_ht1_short_intf_seq_id = 0;
    is_ht2_short_intf_eob    = MIDDLE;
    is_ht2_short_intf_seq_id = 0;

    htb_short_ecc_error      = htb1_ecc_error | htb2_ecc_error;

    ht2_is_not_ready         = ht2_is_not_ready_pre | sw_disable_sub_pipe.disable_second_pipe;
      
    
    
    ht_is_short_not_ready    = ht1_is_not_ready && ht2_is_not_ready;

    
    
    
    if((is_ht_short_intf.eob != MIDDLE) && (ht1_is_not_ready == 1'b0))
    begin
       is_ht1_short_intf_eob    = is_ht_short_intf.eob;
       is_ht1_short_intf_seq_id = is_ht_short_intf.seq_id;
    end
    else if(is_ht_short_intf.eob != MIDDLE)
    begin
       is_ht2_short_intf_eob    = is_ht_short_intf.eob;
       is_ht2_short_intf_seq_id = is_ht_short_intf.seq_id;
    end
       
 end
    

 

    cr_huf_comp_htb
    #(
      .DAT_WIDTH        (`CREOLE_HC_SHORT_DAT_WIDTH),       
      .SYM_FREQ_WIDTH   (`CREOLE_HC_SHORT_FREQ_WIDTH),      
      .SYM_ADDR_WIDTH   (`CREOLE_HC_SHORT_SYM_ADDR_WIDTH),  
      .CODELENGTH_WIDTH (`CREOLE_HC_SYM_CODELENGTH),
      .MAX_NUM_SYM_USED (`CREOLE_HC_SHORT_NUM_MAX_SYM_USED),
      .SPECIALIZE       (1)
     )
    tree_builder_inst1 (
			
			.ht_is_not_ready(ht1_is_not_ready),	 
			.ht_hw_sym_lo	(ht1_hw1_short_intf.sym_lo[(`CREOLE_HC_SHORT_DAT_WIDTH)-1:0]), 
			.ht_hw_sym_hi	(ht1_hw1_short_intf.sym_hi[(`CREOLE_HC_SHORT_DAT_WIDTH)-1:0]), 
			.ht_hw_meta	(),			 
			.ht_hw_seq_id	(ht1_hw1_short_intf.seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
			.ht_hw_sym_sort_freq(ht1_hw1_short_intf.sym_freq[((`CREOLE_HC_SHORT_FREQ_WIDTH)*2)-1:0]), 
			.ht_hw_sym_sort_freq_val(ht1_hw1_short_freq_val[1:0]), 
			.ht_hw_sym_dpth	(ht1_hw1_short_intf.sym_dpth), 
			.ht_hw_zero_symbols(ht1_hw1_short_intf.zero_symbols), 
			.ht_hw_build_error(ht1_hw1_short_intf.build_error), 
			.ht_hw_eob	(ht1_hw1_short_intf.eob), 
			.ht_hw_sym_unique(),			 
			.ht_hdr_seq_id	(short_ht1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
			.ht_dbg_cntr_rebuild(short_ht1_dbg_cntr_rebuild), 
			.ht_dbg_cntr_rebuild_failed(short_ht1_dbg_cntr_rebuild_failed), 
			.bimc_odat	(bimc_odat_0),		 
			.bimc_osync	(bimc_osync_0),		 
			.htb_ecc_error	(htb1_ecc_error),	 
			
			.clk		(clk),			 
			.rst_n		(rst_n),		 
			.is_ht_sym_lo	(is_ht_short_intf.sym_lo[(`CREOLE_HC_SHORT_DAT_WIDTH)-1:0]), 
			.is_ht_sym_hi	(is_ht_short_intf.sym_hi[(`CREOLE_HC_SHORT_DAT_WIDTH)-1:0]), 
			.is_ht_sym_unique(is_ht_short_intf.sym_unique[(`CREOLE_HC_SHORT_DAT_WIDTH)-1:0]), 
			.is_ht_sym_sort_freq(is_ht_short_intf.sort_freq), 
			.is_ht_sym_sort_freq_sym(is_ht_short_intf.sort_freq_sym), 
			.is_ht_meta	(1'b0),			 
			.is_ht_seq_id	(is_ht1_short_intf_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
			.is_ht_eob	(is_ht1_short_intf_eob), 
			.hw_ht_sym_freq_rd(hw1_ht1_short_intf.sym_freq_rd), 
			.hw_ht_sym_freq_seq_id(hw1_ht1_short_intf.seq_id), 
			.hw_ht_sym_freq_rd_addr(hw1_ht1_short_intf.sym_freq_addr[(`CREOLE_HC_SHORT_SYM_ADDR_WIDTH)-2:0]), 
			.hw_ht_sym_freq_rd_done(hw1_ht1_short_intf.rd_done), 
			.hw_ht_not_ready(hw1_ht1_short_not_ready), 
			.hdr_ht_type	(hdr_short_ht1_type),	 
			.sw_ht_xp_max_code_length(sw_short_ht1_xp_max_code_length[(`CREOLE_HC_SYM_CODELENGTH)-1:0]), 
			.sw_ht_deflate_max_code_length(sw_short_ht1_deflate_max_code_length[(`CREOLE_HC_SYM_CODELENGTH)-1:0]), 
			.sw_ht_max_rebuild_limit(sw_short_ht1_max_rebuild_limit[9:0]), 
			.sw_ht_force_rebuild(sw_short_ht1_force_rebuild[`CR_HUF_COMP_HT_CONFIG_T_FORCE_REBUILD_DECL]), 
			.bimc_isync	(htb_short_bimc_isync),	 
			.bimc_idat	(htb_short_bimc_idat),	 
			.lvm		(lvm),
			.mlvm		(mlvm),
			.mrdten		(mrdten));
   
generate
   
 if (SINGLE_PIPE==1) 

   begin  : one_pipe

   always_comb
    begin
       ht2_is_not_ready_pre = 1'b1;
    end

  

    cr_huf_comp_htb
    #(
      .DAT_WIDTH        (`CREOLE_HC_SHORT_DAT_WIDTH),       
      .SYM_FREQ_WIDTH   (`CREOLE_HC_SHORT_FREQ_WIDTH),      
      .SYM_ADDR_WIDTH   (`CREOLE_HC_SHORT_SYM_ADDR_WIDTH),  
      .CODELENGTH_WIDTH (`CREOLE_HC_SYM_CODELENGTH),
      .MAX_NUM_SYM_USED (`CREOLE_HC_SHORT_NUM_MAX_SYM_USED),
      .SPECIALIZE       (1)
     )
    tree_builder_inst2 (
			
			.ht_is_not_ready(),			 
			.ht_hw_sym_lo	(ht2_hw2_short_intf.sym_lo[(`CREOLE_HC_SHORT_DAT_WIDTH)-1:0]), 
			.ht_hw_sym_hi	(ht2_hw2_short_intf.sym_hi[(`CREOLE_HC_SHORT_DAT_WIDTH)-1:0]), 
			.ht_hw_meta	(),			 
			.ht_hw_seq_id	(ht2_hw2_short_intf.seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
			.ht_hw_sym_sort_freq(ht2_hw2_short_intf.sym_freq[((`CREOLE_HC_SHORT_FREQ_WIDTH)*2)-1:0]), 
			.ht_hw_sym_sort_freq_val(ht2_hw2_short_freq_val[1:0]), 
			.ht_hw_sym_dpth	(ht2_hw2_short_intf.sym_dpth), 
			.ht_hw_zero_symbols(ht2_hw2_short_intf.zero_symbols), 
			.ht_hw_build_error(ht2_hw2_short_intf.build_error), 
			.ht_hw_eob	(ht2_hw2_short_intf.eob), 
			.ht_hw_sym_unique(),			 
			.ht_hdr_seq_id	(short_ht2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
			.ht_dbg_cntr_rebuild(short_ht2_dbg_cntr_rebuild), 
			.ht_dbg_cntr_rebuild_failed(short_ht2_dbg_cntr_rebuild_failed), 
			.bimc_odat	(htb_short_bimc_odat),	 
			.bimc_osync	(htb_short_bimc_osync),	 
			.htb_ecc_error	(htb2_ecc_error),	 
			
			.clk		(clk),			 
			.rst_n		(rst_n),		 
			.is_ht_sym_lo	({`CREOLE_HC_SHORT_DAT_WIDTH{1'b0}}), 
			.is_ht_sym_hi	({`CREOLE_HC_SHORT_DAT_WIDTH{1'b0}}), 
			.is_ht_sym_unique({`CREOLE_HC_SHORT_DAT_WIDTH{1'b0}}), 
			.is_ht_sym_sort_freq({`CREOLE_HC_SHORT_NUM_MAX_SYM_USED*`CREOLE_HC_SHORT_FREQ_WIDTH{1'b0}}), 
			.is_ht_sym_sort_freq_sym({`CREOLE_HC_SHORT_NUM_MAX_SYM_USED*`CREOLE_HC_SHORT_DAT_WIDTH{1'b0}}), 
			.is_ht_meta	(1'b0),			 
			.is_ht_seq_id	({`CREOLE_HC_SEQID_WIDTH{1'b0}}), 
			.is_ht_eob	(MIDDLE),		 
			.hw_ht_sym_freq_rd(hw2_ht2_short_intf.sym_freq_rd), 
			.hw_ht_sym_freq_seq_id(hw2_ht2_short_intf.seq_id), 
			.hw_ht_sym_freq_rd_addr(hw2_ht2_short_intf.sym_freq_addr[(`CREOLE_HC_SHORT_SYM_ADDR_WIDTH)-2:0]), 
			.hw_ht_sym_freq_rd_done(hw2_ht2_short_intf.rd_done), 
			.hw_ht_not_ready(hw2_ht2_short_not_ready), 
			.hdr_ht_type	(hdr_short_ht2_type),	 
			.sw_ht_xp_max_code_length(sw_short_ht2_xp_max_code_length[(`CREOLE_HC_SYM_CODELENGTH)-1:0]), 
			.sw_ht_deflate_max_code_length(sw_short_ht2_deflate_max_code_length[(`CREOLE_HC_SYM_CODELENGTH)-1:0]), 
			.sw_ht_max_rebuild_limit(sw_short_ht2_max_rebuild_limit[9:0]), 
			.sw_ht_force_rebuild(sw_short_ht2_force_rebuild[`CR_HUF_COMP_HT_CONFIG_T_FORCE_REBUILD_DECL]), 
			.bimc_isync	(bimc_osync_0),		 
			.bimc_idat	(bimc_odat_0),		 
			.lvm		(lvm),
			.mlvm		(mlvm),
			.mrdten		(mrdten));
     
  end
else 
  begin : two_pipes

  

    cr_huf_comp_htb
    #(
      .DAT_WIDTH        (`CREOLE_HC_SHORT_DAT_WIDTH),       
      .SYM_FREQ_WIDTH   (`CREOLE_HC_SHORT_FREQ_WIDTH),      
      .SYM_ADDR_WIDTH   (`CREOLE_HC_SHORT_SYM_ADDR_WIDTH),  
      .CODELENGTH_WIDTH (`CREOLE_HC_SYM_CODELENGTH),
      .MAX_NUM_SYM_USED (`CREOLE_HC_SHORT_NUM_MAX_SYM_USED),
      .SPECIALIZE       (1)
     )
    tree_builder_inst2 (
			
			.ht_is_not_ready(ht2_is_not_ready_pre),	 
			.ht_hw_sym_lo	(ht2_hw2_short_intf.sym_lo[(`CREOLE_HC_SHORT_DAT_WIDTH)-1:0]), 
			.ht_hw_sym_hi	(ht2_hw2_short_intf.sym_hi[(`CREOLE_HC_SHORT_DAT_WIDTH)-1:0]), 
			.ht_hw_meta	(),			 
			.ht_hw_seq_id	(ht2_hw2_short_intf.seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
			.ht_hw_sym_sort_freq(ht2_hw2_short_intf.sym_freq[((`CREOLE_HC_SHORT_FREQ_WIDTH)*2)-1:0]), 
			.ht_hw_sym_sort_freq_val(ht2_hw2_short_freq_val[1:0]), 
			.ht_hw_sym_dpth	(ht2_hw2_short_intf.sym_dpth), 
			.ht_hw_zero_symbols(ht2_hw2_short_intf.zero_symbols), 
			.ht_hw_build_error(ht2_hw2_short_intf.build_error), 
			.ht_hw_eob	(ht2_hw2_short_intf.eob), 
			.ht_hw_sym_unique(),			 
			.ht_hdr_seq_id	(short_ht2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
			.ht_dbg_cntr_rebuild(short_ht2_dbg_cntr_rebuild), 
			.ht_dbg_cntr_rebuild_failed(short_ht2_dbg_cntr_rebuild_failed), 
			.bimc_odat	(htb_short_bimc_odat),	 
			.bimc_osync	(htb_short_bimc_osync),	 
			.htb_ecc_error	(htb2_ecc_error),	 
			
			.clk		(clk),			 
			.rst_n		(rst_n),		 
			.is_ht_sym_lo	(is_ht_short_intf.sym_lo[(`CREOLE_HC_SHORT_DAT_WIDTH)-1:0]), 
			.is_ht_sym_hi	(is_ht_short_intf.sym_hi[(`CREOLE_HC_SHORT_DAT_WIDTH)-1:0]), 
			.is_ht_sym_unique(is_ht_short_intf.sym_unique[(`CREOLE_HC_SHORT_DAT_WIDTH)-1:0]), 
			.is_ht_sym_sort_freq(is_ht_short_intf.sort_freq), 
			.is_ht_sym_sort_freq_sym(is_ht_short_intf.sort_freq_sym), 
			.is_ht_meta	(1'b0),			 
			.is_ht_seq_id	(is_ht2_short_intf_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
			.is_ht_eob	(is_ht2_short_intf_eob), 
			.hw_ht_sym_freq_rd(hw2_ht2_short_intf.sym_freq_rd), 
			.hw_ht_sym_freq_seq_id(hw2_ht2_short_intf.seq_id), 
			.hw_ht_sym_freq_rd_addr(hw2_ht2_short_intf.sym_freq_addr[(`CREOLE_HC_SHORT_SYM_ADDR_WIDTH)-2:0]), 
			.hw_ht_sym_freq_rd_done(hw2_ht2_short_intf.rd_done), 
			.hw_ht_not_ready(hw2_ht2_short_not_ready), 
			.hdr_ht_type	(hdr_short_ht2_type),	 
			.sw_ht_xp_max_code_length(sw_short_ht2_xp_max_code_length[(`CREOLE_HC_SYM_CODELENGTH)-1:0]), 
			.sw_ht_deflate_max_code_length(sw_short_ht2_deflate_max_code_length[(`CREOLE_HC_SYM_CODELENGTH)-1:0]), 
			.sw_ht_max_rebuild_limit(sw_short_ht2_max_rebuild_limit[9:0]), 
			.sw_ht_force_rebuild(sw_short_ht2_force_rebuild[`CR_HUF_COMP_HT_CONFIG_T_FORCE_REBUILD_DECL]), 
			.bimc_isync	(bimc_osync_0),		 
			.bimc_idat	(bimc_odat_0),		 
			.lvm		(lvm),
			.mlvm		(mlvm),
			.mrdten		(mrdten));
   
     
  end
   
endgenerate 
 

endmodule 








