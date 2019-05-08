/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_huf_comp.vh"

module cr_huf_comp_st_long
  (
   
   st1_hw1_long_not_ready, st2_hw2_long_not_ready, st1_lut1_long_wr,
   st1_lut1_long_intf, st2_lut2_long_wr, st2_lut2_long_intf,
   st1_sa_long_size_rdy, st1_sa_long_table_rdy, st1_sa_long_intf,
   st2_sa_long_size_rdy, st2_sa_long_table_rdy, st2_sa_long_intf,
   long_st1_dbg_cntr_rebuild, long_st1_dbg_cntr_rebuild_failed,
   long_st2_dbg_cntr_rebuild, long_st2_dbg_cntr_rebuild_failed,
   st_long_bl_ism_data, st_long_bl_ism_vld, st_long_bimc_odat,
   st_long_bimc_osync,
   
   clk, rst_n, hw1_st1_long_intf, hw2_st2_long_intf,
   lut1_st1_long_full, lut2_st2_long_full, sa_st1_long_read_done,
   sa_st2_long_read_done, sw_long_st1_force_rebuild,
   sw_long_st1_max_rebuild_limit, sw_long_st1_xp_max_code_length,
   sw_long_st2_force_rebuild, sw_long_st2_max_rebuild_limit,
   sw_long_st2_xp_max_code_length, sw_ism_on, st_long_ism_rdy,
   st_long_bimc_idat, st_long_bimc_isync, lvm, mlvm, mrdten
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

  `ifdef THESE_AUTOS_SHOULD_BE_EMPTY
   
   
  `endif
 
 
 
 input			                        clk;
 input			                        rst_n;
 
 
 

 
 input s_long_hw_st_intf                        hw1_st1_long_intf;
 input s_long_hw_st_intf                        hw2_st2_long_intf;

 
 input                                          lut1_st1_long_full;
 input                                          lut2_st2_long_full;

 
 input                                          sa_st1_long_read_done; 
 input                                          sa_st2_long_read_done; 
   
 
 input [`CR_HUF_COMP_HT_CONFIG_T_FORCE_REBUILD_DECL] sw_long_st1_force_rebuild;	
 input [9:0]		                        sw_long_st1_max_rebuild_limit;
 input [`CREOLE_HC_ST_SYM_CODELENGTH-1:0]	sw_long_st1_xp_max_code_length;
 input [`CR_HUF_COMP_HT_CONFIG_T_FORCE_REBUILD_DECL] sw_long_st2_force_rebuild;	
 input [9:0]		                        sw_long_st2_max_rebuild_limit;
 input [`CREOLE_HC_ST_SYM_CODELENGTH-1:0]	sw_long_st2_xp_max_code_length;
 input	                                        sw_ism_on;

 
 input		                                st_long_ism_rdy;

 input		                                st_long_bimc_idat;
 input		                                st_long_bimc_isync;
 input		                                lvm;	
 input		                                mlvm;	
 input		                                mrdten;
   
 
 
 

 
 output                                         st1_hw1_long_not_ready;
 output                                         st2_hw2_long_not_ready;

 
 output                                         st1_lut1_long_wr;
 output s_st_lut_intf                           st1_lut1_long_intf;
 output                                         st2_lut2_long_wr;
 output s_st_lut_intf                           st2_lut2_long_intf;

 
 output                                         st1_sa_long_size_rdy; 
 output                                         st1_sa_long_table_rdy; 
 output s_st_sa_intf                            st1_sa_long_intf;

 output                                         st2_sa_long_size_rdy; 
 output                                         st2_sa_long_table_rdy; 
 output s_st_sa_intf                            st2_sa_long_intf;

 
 output                                         long_st1_dbg_cntr_rebuild;
 output                                         long_st1_dbg_cntr_rebuild_failed;
 output                                         long_st2_dbg_cntr_rebuild;
 output                                         long_st2_dbg_cntr_rebuild_failed; 

 
 output st_lng_bl_t                             st_long_bl_ism_data;
 output                                         st_long_bl_ism_vld;

 output logic		                        st_long_bimc_odat;
 output logic		                        st_long_bimc_osync;
 
   
 
 
 logic			bimc_odat_0;		
 logic			bimc_osync_0;		
 
 

 
 
 


 

    cr_huf_comp_st
    #(
      .DAT_WIDTH        (`CREOLE_HC_LONG_DAT_WIDTH),
      .MAX_SYMBOL_TABLE_DEPTH(249)
     )
     symbol_table_builder_inst1 (
				 
				 .st_hw_not_ready	(st1_hw1_long_not_ready), 
				 .st_lut_wr		(st1_lut1_long_wr), 
				 .st_lut_wr_type	(st1_lut1_long_intf.wr_type), 
				 .st_lut_wr_data	(st1_lut1_long_intf.wr_data), 
				 .st_lut_wr_addr	(st1_lut1_long_intf.wr_addr), 
				 .st_lut_wr_done	(st1_lut1_long_intf.wr_done), 
				 .st_lut_sizes_val	(st1_lut1_long_intf.sizes_val), 
				 .st_lut_seq_id		(st1_lut1_long_intf.seq_id), 
				 .st_lut_stcl_size	(st1_lut1_long_intf.stcl_size), 
				 .st_lut_st_size	(st1_lut1_long_intf.st_size), 
				 .st_lut_hclen		(st1_lut1_long_intf.hclen), 
				 .st_lut_hlit		(st1_lut1_long_intf.hlit), 
				 .st_lut_hdist		(st1_lut1_long_intf.hdist), 
				 .st_sa_size_rdy	(st1_sa_long_size_rdy), 
				 .st_sa_size_seq_id	(st1_sa_long_intf.size_seq_id), 
				 .st_sa_eob		(st1_sa_long_intf.eob), 
				 .st_sa_build_error	(st1_sa_long_intf.build_error), 
				 .st_sa_table_rdy	(st1_sa_long_table_rdy), 
				 .st_dbg_cntr_rebuild	(long_st1_dbg_cntr_rebuild), 
				 .st_dbg_cntr_rebuild_failed(long_st1_dbg_cntr_rebuild_failed), 
				 .st_bl_ism_data	(st_long_bl_ism_data), 
				 .st_bl_ism_vld		(st_long_bl_ism_vld), 
				 .bimc_odat		(bimc_odat_0),	 
				 .bimc_osync		(bimc_osync_0),	 
				 
				 .clk			(clk),		 
				 .rst_n			(rst_n),	 
				 .hw_st_val		(hw1_st1_long_intf.val), 
				 .hw_st_symbol		(hw1_st1_long_intf.symbol), 
				 .hw_st_extra		(hw1_st1_long_intf.extra), 
				 .hw_st_extra_length	(hw1_st1_long_intf.extra_length), 
				 .hw_st_last_ptr	(hw1_st1_long_intf.last_ptr), 
				 .hw_st_extra_size	(hw1_st1_long_intf.extra_size), 
				 .hw_st_seq_id		(hw1_st1_long_intf.seq_id), 
				 .hw_st_hlit		(`CREOLE_HC_HLIT_WIDTH'b0), 
				 .hw_st_hdist		(`CREOLE_HC_HDIST_WIDTH'b0), 
				 .hw_st_deflate		(1'b0),		 
				 .hw_st_eob		(hw1_st1_long_intf.eob), 
				 .hw_st_build_error	(hw1_st1_long_intf.build_error), 
				 .lut_st_full		(lut1_st1_long_full), 
				 .sa_st_read_done	(sa_st1_long_read_done), 
				 .sw_st_xp_max_code_length(sw_long_st1_xp_max_code_length), 
				 .sw_st_deflate_max_code_length(4'hf),	 
				 .sw_st_max_rebuild_limit(sw_long_st1_max_rebuild_limit[9:0]), 
				 .sw_st_force_rebuild	(sw_long_st1_force_rebuild[`CR_HUF_COMP_HT_CONFIG_T_FORCE_REBUILD_DECL]), 
				 .sw_ism_on		(sw_ism_on),	 
				 .st_ism_rdy		(st_long_ism_rdy), 
				 .bimc_idat		(st_long_bimc_idat), 
				 .bimc_isync		(st_long_bimc_isync), 
				 .lvm			(lvm),
				 .mlvm			(mlvm),
				 .mrdten		(mrdten));

 

    cr_huf_comp_st
    #(
      .DAT_WIDTH        (`CREOLE_HC_LONG_DAT_WIDTH),
      .MAX_SYMBOL_TABLE_DEPTH(249)
     )
     symbol_table_builder_inst2 (
				 
				 .st_hw_not_ready	(st2_hw2_long_not_ready), 
				 .st_lut_wr		(st2_lut2_long_wr), 
				 .st_lut_wr_type	(st2_lut2_long_intf.wr_type), 
				 .st_lut_wr_data	(st2_lut2_long_intf.wr_data), 
				 .st_lut_wr_addr	(st2_lut2_long_intf.wr_addr), 
				 .st_lut_wr_done	(st2_lut2_long_intf.wr_done), 
				 .st_lut_sizes_val	(st2_lut2_long_intf.sizes_val), 
				 .st_lut_seq_id		(st2_lut2_long_intf.seq_id), 
				 .st_lut_stcl_size	(st2_lut2_long_intf.stcl_size), 
				 .st_lut_st_size	(st2_lut2_long_intf.st_size), 
				 .st_lut_hclen		(st2_lut2_long_intf.hclen), 
				 .st_lut_hlit		(st2_lut2_long_intf.hlit), 
				 .st_lut_hdist		(st2_lut2_long_intf.hdist), 
				 .st_sa_size_rdy	(st2_sa_long_size_rdy), 
				 .st_sa_size_seq_id	(st2_sa_long_intf.size_seq_id), 
				 .st_sa_eob		(st2_sa_long_intf.eob), 
				 .st_sa_build_error	(st2_sa_long_intf.build_error), 
				 .st_sa_table_rdy	(st2_sa_long_table_rdy), 
				 .st_dbg_cntr_rebuild	(long_st2_dbg_cntr_rebuild), 
				 .st_dbg_cntr_rebuild_failed(long_st2_dbg_cntr_rebuild_failed), 
				 .st_bl_ism_data	(),		 
				 .st_bl_ism_vld		(),		 
				 .bimc_odat		(st_long_bimc_odat), 
				 .bimc_osync		(st_long_bimc_osync), 
				 
				 .clk			(clk),		 
				 .rst_n			(rst_n),	 
				 .hw_st_val		(hw2_st2_long_intf.val), 
				 .hw_st_symbol		(hw2_st2_long_intf.symbol), 
				 .hw_st_extra		(hw2_st2_long_intf.extra), 
				 .hw_st_extra_length	(hw2_st2_long_intf.extra_length), 
				 .hw_st_last_ptr	(hw2_st2_long_intf.last_ptr), 
				 .hw_st_extra_size	(hw2_st2_long_intf.extra_size), 
				 .hw_st_seq_id		(hw2_st2_long_intf.seq_id), 
				 .hw_st_hlit		(`CREOLE_HC_HLIT_WIDTH'b0), 
				 .hw_st_hdist		(`CREOLE_HC_HDIST_WIDTH'b0), 
				 .hw_st_deflate		(1'b0),		 
				 .hw_st_eob		(hw2_st2_long_intf.eob), 
				 .hw_st_build_error	(hw2_st2_long_intf.build_error), 
				 .lut_st_full		(lut2_st2_long_full), 
				 .sa_st_read_done	(sa_st2_long_read_done), 
				 .sw_st_xp_max_code_length(sw_long_st2_xp_max_code_length), 
				 .sw_st_deflate_max_code_length(4'hf),	 
				 .sw_st_max_rebuild_limit(sw_long_st2_max_rebuild_limit[9:0]), 
				 .sw_st_force_rebuild	(sw_long_st2_force_rebuild[`CR_HUF_COMP_HT_CONFIG_T_FORCE_REBUILD_DECL]), 
				 .sw_ism_on		(1'b0),		 
				 .st_ism_rdy		(1'b0),		 
				 .bimc_idat		(bimc_odat_0),	 
				 .bimc_isync		(bimc_osync_0),	 
				 .lvm			(lvm),
				 .mlvm			(mlvm),
				 .mrdten		(mrdten));

endmodule 








