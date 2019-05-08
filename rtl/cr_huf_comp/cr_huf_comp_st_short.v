/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_huf_comp.vh"

module cr_huf_comp_st_short
  (
   
   st1_hw1_short_not_ready, st2_hw2_short_not_ready,
   st1_lut1_short_wr, st1_lut1_short_intf, st2_lut2_short_wr,
   st2_lut2_short_intf, st1_sa_short_size_rdy, st1_sa_short_table_rdy,
   st1_sa_short_intf, st2_sa_short_size_rdy, st2_sa_short_table_rdy,
   st2_sa_short_intf, short_st1_dbg_cntr_rebuild,
   short_st1_dbg_cntr_rebuild_failed, short_st2_dbg_cntr_rebuild,
   short_st2_dbg_cntr_rebuild_failed, st_short_bl_ism_data,
   st_short_bl_ism_vld, st_short_bimc_odat, st_short_bimc_osync,
   
   clk, rst_n, hw1_st1_short_intf, hw2_st2_short_intf,
   lut1_st1_short_full, lut2_st2_short_full, sa_st1_short_read_done,
   sa_st2_short_read_done, sw_short_st1_deflate_max_code_length,
   sw_short_st1_force_rebuild, sw_short_st1_max_rebuild_limit,
   sw_short_st1_xp_max_code_length,
   sw_short_st2_deflate_max_code_length, sw_short_st2_force_rebuild,
   sw_short_st2_max_rebuild_limit, sw_short_st2_xp_max_code_length,
   st_short_ism_rdy, sw_ism_on, st_short_bimc_idat,
   st_short_bimc_isync, lvm, mlvm, mrdten
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

  `ifdef THESE_AUTOS_SHOULD_BE_EMPTY
   
   
  `endif
 
 
 
 input			                        clk;
 input			                        rst_n;
 
 
 

 
 input s_short_hw_st_intf                       hw1_st1_short_intf;
 input s_short_hw_st_intf                       hw2_st2_short_intf;

 
 input                                          lut1_st1_short_full;
 input                                          lut2_st2_short_full;

 
 input                                          sa_st1_short_read_done;   
 input                                          sa_st2_short_read_done; 
   
 
 input [`CREOLE_HC_ST_SYM_CODELENGTH-1:0]	sw_short_st1_deflate_max_code_length;
 input [`CR_HUF_COMP_HT_CONFIG_T_FORCE_REBUILD_DECL] sw_short_st1_force_rebuild;	
 input [9:0]		                        sw_short_st1_max_rebuild_limit;
 input [`CREOLE_HC_ST_SYM_CODELENGTH-1:0]	sw_short_st1_xp_max_code_length;
 input [`CREOLE_HC_ST_SYM_CODELENGTH-1:0]	sw_short_st2_deflate_max_code_length;
 input [`CR_HUF_COMP_HT_CONFIG_T_FORCE_REBUILD_DECL] sw_short_st2_force_rebuild;	
 input [9:0]		                        sw_short_st2_max_rebuild_limit;
 input [`CREOLE_HC_ST_SYM_CODELENGTH-1:0]	sw_short_st2_xp_max_code_length;

 
 input		                                st_short_ism_rdy;
 input		                                sw_ism_on;

 input		                                st_short_bimc_idat;
 input		                                st_short_bimc_isync;
 input		                                lvm;	
 input		                                mlvm;	
 input		                                mrdten;		
   
 
 
 

 
 output                                         st1_hw1_short_not_ready;
 output                                         st2_hw2_short_not_ready;

 
 output                                         st1_lut1_short_wr;
 output s_st_lut_intf                           st1_lut1_short_intf;
 output                                         st2_lut2_short_wr;
 output s_st_lut_intf                           st2_lut2_short_intf;

 
 output                                         st1_sa_short_size_rdy;
 output                                         st1_sa_short_table_rdy;   
 output s_st_sa_intf                            st1_sa_short_intf;
   
 output                                         st2_sa_short_size_rdy;
 output                                         st2_sa_short_table_rdy;   
 output s_st_sa_intf                            st2_sa_short_intf;
   
 
 output                                         short_st1_dbg_cntr_rebuild;
 output                                         short_st1_dbg_cntr_rebuild_failed;
 output                                         short_st2_dbg_cntr_rebuild;
 output                                         short_st2_dbg_cntr_rebuild_failed;

 
 output st_sh_bl_t	                        st_short_bl_ism_data;
 output		                                st_short_bl_ism_vld;

 output logic		                        st_short_bimc_odat;
 output logic		                        st_short_bimc_osync; 
   
 
 
 logic			bimc_odat_0;		
 logic			bimc_osync_0;		
 
 

 
 
 

 
 

    cr_huf_comp_st
    #(
      .DAT_WIDTH        (`CREOLE_HC_SHORT_DAT_WIDTH),
      .MAX_SYMBOL_TABLE_DEPTH(584)
     )
     symbol_table_builder_inst1 (
				 
				 .st_hw_not_ready	(st1_hw1_short_not_ready), 
				 .st_lut_wr		(st1_lut1_short_wr), 
				 .st_lut_wr_type	(st1_lut1_short_intf.wr_type), 
				 .st_lut_wr_data	(st1_lut1_short_intf.wr_data), 
				 .st_lut_wr_addr	(st1_lut1_short_intf.wr_addr), 
				 .st_lut_wr_done	(st1_lut1_short_intf.wr_done), 
				 .st_lut_sizes_val	(st1_lut1_short_intf.sizes_val), 
				 .st_lut_seq_id		(st1_lut1_short_intf.seq_id), 
				 .st_lut_stcl_size	(st1_lut1_short_intf.stcl_size), 
				 .st_lut_st_size	(st1_lut1_short_intf.st_size), 
				 .st_lut_hclen		(st1_lut1_short_intf.hclen), 
				 .st_lut_hlit		(st1_lut1_short_intf.hlit), 
				 .st_lut_hdist		(st1_lut1_short_intf.hdist), 
				 .st_sa_size_rdy	(st1_sa_short_size_rdy), 
				 .st_sa_size_seq_id	(st1_sa_short_intf.size_seq_id), 
				 .st_sa_eob		(st1_sa_short_intf.eob), 
				 .st_sa_build_error	(st1_sa_short_intf.build_error), 
				 .st_sa_table_rdy	(st1_sa_short_table_rdy), 
				 .st_dbg_cntr_rebuild	(short_st1_dbg_cntr_rebuild), 
				 .st_dbg_cntr_rebuild_failed(short_st1_dbg_cntr_rebuild_failed), 
				 .st_bl_ism_data	(st_short_bl_ism_data), 
				 .st_bl_ism_vld		(st_short_bl_ism_vld), 
				 .bimc_odat		(bimc_odat_0),	 
				 .bimc_osync		(bimc_osync_0),	 
				 
				 .clk			(clk),		 
				 .rst_n			(rst_n),	 
				 .hw_st_val		(hw1_st1_short_intf.val), 
				 .hw_st_symbol		(hw1_st1_short_intf.symbol), 
				 .hw_st_extra		(hw1_st1_short_intf.extra), 
				 .hw_st_extra_length	(hw1_st1_short_intf.extra_length), 
				 .hw_st_last_ptr	(hw1_st1_short_intf.last_ptr), 
				 .hw_st_extra_size	(hw1_st1_short_intf.extra_size), 
				 .hw_st_seq_id		(hw1_st1_short_intf.seq_id), 
				 .hw_st_hlit		(hw1_st1_short_intf.hlit), 
				 .hw_st_hdist		(hw1_st1_short_intf.hdist), 
				 .hw_st_deflate		(hw1_st1_short_intf.deflate), 
				 .hw_st_eob		(hw1_st1_short_intf.eob), 
				 .hw_st_build_error	(hw1_st1_short_intf.build_error), 
				 .lut_st_full		(lut1_st1_short_full), 
				 .sa_st_read_done	(sa_st1_short_read_done), 
				 .sw_st_xp_max_code_length(sw_short_st1_xp_max_code_length), 
				 .sw_st_deflate_max_code_length(sw_short_st1_deflate_max_code_length), 
				 .sw_st_max_rebuild_limit(sw_short_st1_max_rebuild_limit[9:0]), 
				 .sw_st_force_rebuild	(sw_short_st1_force_rebuild[`CR_HUF_COMP_HT_CONFIG_T_FORCE_REBUILD_DECL]), 
				 .sw_ism_on		(sw_ism_on),	 
				 .st_ism_rdy		(st_short_ism_rdy), 
				 .bimc_idat		(st_short_bimc_idat), 
				 .bimc_isync		(st_short_bimc_isync), 
				 .lvm			(lvm),
				 .mlvm			(mlvm),
				 .mrdten		(mrdten));

 

    cr_huf_comp_st
    #(
      .DAT_WIDTH        (`CREOLE_HC_SHORT_DAT_WIDTH),
      .MAX_SYMBOL_TABLE_DEPTH(584)
     )
     symbol_table_builder_inst2 (
				 
				 .st_hw_not_ready	(st2_hw2_short_not_ready), 
				 .st_lut_wr		(st2_lut2_short_wr), 
				 .st_lut_wr_type	(st2_lut2_short_intf.wr_type), 
				 .st_lut_wr_data	(st2_lut2_short_intf.wr_data), 
				 .st_lut_wr_addr	(st2_lut2_short_intf.wr_addr), 
				 .st_lut_wr_done	(st2_lut2_short_intf.wr_done), 
				 .st_lut_sizes_val	(st2_lut2_short_intf.sizes_val), 
				 .st_lut_seq_id		(st2_lut2_short_intf.seq_id), 
				 .st_lut_stcl_size	(st2_lut2_short_intf.stcl_size), 
				 .st_lut_st_size	(st2_lut2_short_intf.st_size), 
				 .st_lut_hclen		(st2_lut2_short_intf.hclen), 
				 .st_lut_hlit		(st2_lut2_short_intf.hlit), 
				 .st_lut_hdist		(st2_lut2_short_intf.hdist), 
				 .st_sa_size_rdy	(st2_sa_short_size_rdy), 
				 .st_sa_size_seq_id	(st2_sa_short_intf.size_seq_id), 
				 .st_sa_eob		(st2_sa_short_intf.eob), 
				 .st_sa_build_error	(st2_sa_short_intf.build_error), 
				 .st_sa_table_rdy	(st2_sa_short_table_rdy), 
				 .st_dbg_cntr_rebuild	(short_st2_dbg_cntr_rebuild), 
				 .st_dbg_cntr_rebuild_failed(short_st2_dbg_cntr_rebuild_failed), 
				 .st_bl_ism_data	(),		 
				 .st_bl_ism_vld		(),		 
				 .bimc_odat		(st_short_bimc_odat), 
				 .bimc_osync		(st_short_bimc_osync), 
				 
				 .clk			(clk),		 
				 .rst_n			(rst_n),	 
				 .hw_st_val		(hw2_st2_short_intf.val), 
				 .hw_st_symbol		(hw2_st2_short_intf.symbol), 
				 .hw_st_extra		(hw2_st2_short_intf.extra), 
				 .hw_st_extra_length	(hw2_st2_short_intf.extra_length), 
				 .hw_st_last_ptr	(hw2_st2_short_intf.last_ptr), 
				 .hw_st_extra_size	(hw2_st2_short_intf.extra_size), 
				 .hw_st_seq_id		(hw2_st2_short_intf.seq_id), 
				 .hw_st_hlit		(hw2_st2_short_intf.hlit), 
				 .hw_st_hdist		(hw2_st2_short_intf.hdist), 
				 .hw_st_deflate		(hw2_st2_short_intf.deflate), 
				 .hw_st_eob		(hw2_st2_short_intf.eob), 
				 .hw_st_build_error	(hw2_st2_short_intf.build_error), 
				 .lut_st_full		(lut2_st2_short_full), 
				 .sa_st_read_done	(sa_st2_short_read_done), 
				 .sw_st_xp_max_code_length(sw_short_st2_xp_max_code_length), 
				 .sw_st_deflate_max_code_length(sw_short_st2_deflate_max_code_length), 
				 .sw_st_max_rebuild_limit(sw_short_st2_max_rebuild_limit[9:0]), 
				 .sw_st_force_rebuild	(sw_short_st2_force_rebuild[`CR_HUF_COMP_HT_CONFIG_T_FORCE_REBUILD_DECL]), 
				 .sw_ism_on		(1'b0),		 
				 .st_ism_rdy		(1'b0),		 
				 .bimc_idat		(bimc_odat_0),	 
				 .bimc_isync		(bimc_osync_0),	 
				 .lvm			(lvm),
				 .mlvm			(mlvm),
				 .mrdten		(mrdten));


endmodule 








