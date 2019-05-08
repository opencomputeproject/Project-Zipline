/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_xp10_decomp.vh"

module cr_huf_comp_core
  #(parameter
    SINGLE_PIPE          = 0,
    FPGA_MOD             = 0 
   )
  (
   
   core_bimc_odat, core_bimc_osync, huf_comp_ib_out, huf_comp_ob_out,
   huf_comp_sch_update, huf_comp_stats,
   huf_comp_xp10_decomp_lz77d_stat_events, sa_bip2_reg, sm_bip2_reg,
   ecc_error_reg, short_bl_ism_data, short_bl_ism_vld,
   long_bl_ism_data, long_bl_ism_vld, st_short_bl_ism_data,
   st_short_bl_ism_vld, st_long_bl_ism_data, st_long_bl_ism_vld,
   short_ht_dbg_cntr_rebuild, short_ht_dbg_cntr_rebuild_failed,
   short_ht_dbg_cntr_rebuild_cnt,
   short_ht_dbg_cntr_rebuild_failed_cnt, long_ht_dbg_cntr_rebuild,
   long_ht_dbg_cntr_rebuild_failed, long_ht_dbg_cntr_rebuild_cnt,
   long_ht_dbg_cntr_rebuild_failed_cnt, short_st_dbg_cntr_rebuild,
   short_st_dbg_cntr_rebuild_failed, short_st_dbg_cntr_rebuild_cnt,
   short_st_dbg_cntr_rebuild_failed_cnt, long_st_dbg_cntr_rebuild,
   long_st_dbg_cntr_rebuild_failed, long_st_dbg_cntr_rebuild_cnt,
   long_st_dbg_cntr_rebuild_failed_cnt,
   
   clk, rst_n, lvm, mlvm, ovstb, core_bimc_rst_n, core_bimc_isync,
   core_bimc_idat, huf_comp_ib_in, huf_comp_ob_in, su_ready,
   huf_comp_in_module_id, huf_comp_out_module_id,
   sw_henc_huff_win_size_in_entries, sw_henc_xp9_first_blk_thrsh,
   sw_short_ht_config, sw_long_ht_config, sw_st_short_ht_config,
   sw_st_long_ht_config, sw_xp9_disable_modes, sw_xp10_disable_modes,
   sw_deflate_disable_modes, sw_disable_sub_pipe,
   sw_sa_out_tlv_parse_action_0, sw_sa_out_tlv_parse_action_1,
   sw_sm_in_tlv_parse_action_0, sw_sm_in_tlv_parse_action_1,
   short_ism_rdy, long_ism_rdy, st_short_ism_rdy, st_long_ism_rdy,
   sw_debug_control, sw_prefix_adj, sw_gzip_os, ism_ecc_error
   );
   
`include "cr_structs.sv"
   
   import cr_huf_compPKG::*;
   import cr_huf_comp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   
   
   
   input         clk;
   input         rst_n; 
   
   input 					lvm;
   input 					mlvm;
   input 					ovstb;
   input 					core_bimc_rst_n;
   input 					core_bimc_isync;
   input 					core_bimc_idat;   
   output logic 				core_bimc_odat;   
   output logic 				core_bimc_osync;
   
   
   
   input 	 axi4s_dp_bus_t huf_comp_ib_in;
   output 	 axi4s_dp_rdy_t huf_comp_ib_out;
   
   
   
   
   input 	 axi4s_dp_rdy_t huf_comp_ob_in;
   output 	 axi4s_dp_bus_t huf_comp_ob_out;

   
   
   
   input 			                su_ready;
   output        sched_update_if_bus_t          huf_comp_sch_update;

   output        huf_comp_stats_t               huf_comp_stats;
   output 	 [`LZ77D_STATS_WIDTH-1:0]              huf_comp_xp10_decomp_lz77d_stat_events;
   
   output 	 sa_bip2_reg;
   output 	 sm_bip2_reg;
   output 	 ecc_error_reg;
   

   input [`MODULE_ID_WIDTH-1:0] huf_comp_in_module_id;
   input [`MODULE_ID_WIDTH-1:0] huf_comp_out_module_id;
   
   
   
   
   input logic [`CR_HUF_COMP_C_HENC_HUFF_WIN_SIZE_IN_ENTRIES_T_DECL] sw_henc_huff_win_size_in_entries;
   input logic [`CR_HUF_COMP_C_HENC_EX9_FIRST_BLK_THRESH_T_DECL]     sw_henc_xp9_first_blk_thrsh;
   input ht_config_t                                                 sw_short_ht_config;
   input ht_config_t                                                 sw_long_ht_config;
   input small_ht_config_t                                           sw_st_short_ht_config;
   input small_ht_config_t                                           sw_st_long_ht_config;
   input henc_xp9_disable_modes_t                                    sw_xp9_disable_modes;
   input henc_xp10_disable_modes_t                                   sw_xp10_disable_modes;
   input henc_deflate_disable_modes_t                                sw_deflate_disable_modes;
   input henc_disable_sub_pipe_t                                     sw_disable_sub_pipe;
   input [`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_31_0_T_DECL]        sw_sa_out_tlv_parse_action_0;
   input [`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_63_32_T_DECL]       sw_sa_out_tlv_parse_action_1;
   input [`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_31_0_T_DECL] 	     sw_sm_in_tlv_parse_action_0;
   input [`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_63_32_T_DECL]        sw_sm_in_tlv_parse_action_1;
   input                                                             short_ism_rdy;
   input                                                             long_ism_rdy;
   input                                                             st_short_ism_rdy;
   input                                                             st_long_ism_rdy;
   input henc_debug_cntrl_t                                          sw_debug_control;
   input [`CR_HUF_COMP_C_HENC_SCH_UPDATE_PREFIX_ADJ_T_DECL]          sw_prefix_adj;
   input [`CR_HUF_COMP_C_HENC_GZIP_OS_T_DECL] 			     sw_gzip_os;

   input                                                             ism_ecc_error;
   
   
   
   
   
   output sh_bl_t		                                     short_bl_ism_data;
   output		                                             short_bl_ism_vld;
   output lng_bl_t		                                     long_bl_ism_data;
   output		                                             long_bl_ism_vld;
   output st_sh_bl_t		                                     st_short_bl_ism_data;
   output		                                             st_short_bl_ism_vld;
   output st_lng_bl_t		                                     st_long_bl_ism_data;
   output		                                             st_long_bl_ism_vld;

   
   
   
   output logic		                                             short_ht_dbg_cntr_rebuild;
   output logic		                                             short_ht_dbg_cntr_rebuild_failed;
   output logic	[1:0]	                                             short_ht_dbg_cntr_rebuild_cnt;
   output logic	[1:0]	                                             short_ht_dbg_cntr_rebuild_failed_cnt;
   output logic		                                             long_ht_dbg_cntr_rebuild;
   output logic		                                             long_ht_dbg_cntr_rebuild_failed;
   output logic	[1:0]	                                             long_ht_dbg_cntr_rebuild_cnt;
   output logic	[1:0]	                                             long_ht_dbg_cntr_rebuild_failed_cnt;
   output logic		                                             short_st_dbg_cntr_rebuild;
   output logic		                                             short_st_dbg_cntr_rebuild_failed;
   output logic	[1:0]	                                             short_st_dbg_cntr_rebuild_cnt;
   output logic	[1:0]	                                             short_st_dbg_cntr_rebuild_failed_cnt;
   output logic		                                             long_st_dbg_cntr_rebuild;
   output logic		                                             long_st_dbg_cntr_rebuild_failed;
   output logic	[1:0]	                                             long_st_dbg_cntr_rebuild_cnt;
   output logic	[1:0]	                                             long_st_dbg_cntr_rebuild_failed_cnt;
   
   
   
   logic		be_lz_dp_ready;		
   bhp_mtf_hdr_bus_t	bhp_mtf_hdr_bus;	
   logic		bhp_mtf_hdr_valid;	
   logic		ee_ecc_error;		
   fhp_lz_prefix_dp_bus_t fhp_lz_prefix_dp_bus;	
   fhp_lz_prefix_hdr_bus_t fhp_lz_prefix_hdr_bus;
   logic		fhp_lz_prefix_hdr_valid;
   logic		fhp_lz_prefix_valid;	
   s_seq_id_type_intf	hdr_long_ht1_type;	
   s_seq_id_type_intf	hdr_long_ht2_type;	
   s_seq_id_type_intf	hdr_long_hw1_type;	
   s_seq_id_type_intf	hdr_long_hw2_type;	
   s_seq_id_type_intf	hdr_short_ht1_type;	
   s_seq_id_type_intf	hdr_short_ht2_type;	
   s_seq_id_type_intf	hdr_short_hw1_type;	
   s_seq_id_type_intf	hdr_short_hw2_type;	
   axi4s_dp_rdy_t	huf_comp_ib_out_pre;	
   s_hw_lut_intf	hw1_lut1_long_intf;	
   logic		hw1_lut1_long_wr;	
   s_hw_lut_intf	hw1_lut1_short_intf;	
   logic		hw1_lut1_short_wr;	
   s_hw_lut_intf	hw2_lut2_long_intf;	
   logic		hw2_lut2_long_wr;	
   s_hw_lut_intf	hw2_lut2_short_intf;	
   logic		hw2_lut2_short_wr;	
   logic		is_sc_long_rd;		
   logic		is_sc_short_rd;		
   logic [`CREOLE_HC_SEQID_WIDTH-1:0] long_ht1_hdr_seq_id;
   logic [`CREOLE_HC_SEQID_WIDTH-1:0] long_ht2_hdr_seq_id;
   logic [`CREOLE_HC_SEQID_WIDTH-1:0] long_hw1_hdr_seq_id;
   s_hw_ph_intf		long_hw1_ph_intf;	
   logic [`CREOLE_HC_SEQID_WIDTH-1:0] long_hw2_hdr_seq_id;
   s_hw_ph_intf		long_hw2_ph_intf;	
   logic		lut1_hw1_long_full;	
   logic		lut1_hw1_short_full;	
   logic		lut1_st1_long_full;	
   logic		lut1_st1_short_full;	
   logic		lut2_hw2_long_full;	
   logic		lut2_hw2_short_full;	
   logic		lut2_st2_long_full;	
   logic		lut2_st2_short_full;	
   logic		lut_long_sa_ro_uncorrectable_ecc_error;
   logic		lut_sa_long_data_val;	
   s_lut_sa_intf	lut_sa_long_intf;	
   logic		lut_sa_long_st_stcl_val;
   logic		lut_sa_short_data_val;	
   s_lut_sa_intf	lut_sa_short_intf;	
   logic		lut_sa_short_st_stcl_val;
   logic		lut_short_sa_ro_uncorrectable_ecc_error;
   logic		lz77_hb_ro_uncorrectable_ecc_error_a;
   logic		lz77_hb_ro_uncorrectable_ecc_error_b;
   logic		lz77_pfx0_ro_uncorrectable_ecc_error;
   logic		lz77_pfx1_ro_uncorrectable_ecc_error;
   logic		lz77_stall_stb;		
   lz_be_dp_bus_t	lz_be_dp_bus;		
   logic		lz_be_dp_valid;		
   logic		lz_fhp_pre_prefix_ready;
   logic		lz_fhp_prefix_hdr_ready;
   logic		lz_fhp_usr_prefix_ready;
   logic		lz_mtf_dp_ready;	
   lz_symbol_bus_t	mtf_lz_dp_bus;		
   logic		mtf_lz_dp_valid;	
   logic		mtf_sdd_dp_ready;	
   s_ph_hw_intf		ph_long_hw1_intf;	
   logic		ph_long_hw1_val;	
   s_ph_hw_intf		ph_long_hw2_intf;	
   logic		ph_long_hw2_val;	
   logic		ph_sa_ro_uncorrectable_ecc_error;
   s_ph_hw_intf		ph_short_hw1_intf;	
   logic		ph_short_hw1_val;	
   s_ph_hw_intf		ph_short_hw2_intf;	
   logic		ph_short_hw2_val;	
   s_sa_lut_intf	sa_lut_long_intf;	
   s_sa_lut_intf	sa_lut_short_intf;	
   s_sa_sm_intf		sa_sm_intf;		
   s_sa_sq_intf		sa_sq_intf;		
   logic		sa_st1_long_read_done;	
   logic		sa_st1_short_read_done;	
   logic		sa_st2_long_read_done;	
   logic		sa_st2_short_read_done;	
   s_sc_is_long_intf	sc_is_long_intf;	
   logic		sc_is_long_vld_pre;	
   s_sc_is_short_intf	sc_is_short_intf;	
   logic [3:0]		sc_is_short_vld_pre;	
   logic		sc_long_sa_ro_uncorrectable_ecc_error;
   logic		sc_short_sa_ro_uncorrectable_ecc_error;
   s_sc_sm_long_intf	sc_sm_long_intf_pre;	
   s_sc_sm_shrt_intf	sc_sm_shrt_intf_pre;	
   lz_symbol_bus_t	sdd_mtf_dp_bus;		
   logic		sdd_mtf_dp_valid;	
   s_sm_seq_id_intf	seq_id_intf_array [`CREOLE_HC_SEQID_NUM];
   logic [`CREOLE_HC_SEQID_NUM-1:0] seq_id_intf_array_vld;
   logic [`CREOLE_HC_SEQID_WIDTH-1:0] short_ht1_hdr_seq_id;
   logic [`CREOLE_HC_SEQID_WIDTH-1:0] short_ht2_hdr_seq_id;
   logic [`CREOLE_HC_SEQID_WIDTH-1:0] short_hw1_hdr_seq_id;
   s_hw_ph_intf		short_hw1_ph_intf;	
   logic [`CREOLE_HC_SEQID_WIDTH-1:0] short_hw2_hdr_seq_id;
   s_hw_ph_intf		short_hw2_ph_intf;	
   s_sm_predet_mem_intf	sm_predet_mem_long_intf;
   s_sm_predet_mem_intf	sm_predet_mem_shrt_intf;
   s_sm_sc_long_intf	sm_sc_long_intf;	
   s_sm_sc_shrt_intf	sm_sc_shrt_intf;	
   s_sm_seq_id_intf	sm_seq_id_intf;		
   s_sm_seq_id_wr_intf	sm_seq_id_wr_intf;	
   s_sm_sq_intf		sm_sq_intf;		
   s_sq_sa_intf		sq_sa_intf;		
   logic		sq_sa_ro_uncorrectable_ecc_error;
   s_sq_sm_intf		sq_sm_intf_pre;		
   s_st_lut_intf	st1_lut1_long_intf;	
   logic		st1_lut1_long_wr;	
   s_st_lut_intf	st1_lut1_short_intf;	
   logic		st1_lut1_short_wr;	
   s_st_sa_intf		st1_sa_long_intf;	
   logic		st1_sa_long_size_rdy_pre;
   logic		st1_sa_long_table_rdy_pre;
   s_st_sa_intf		st1_sa_short_intf;	
   logic		st1_sa_short_size_rdy_pre;
   logic		st1_sa_short_table_rdy_pre;
   s_st_lut_intf	st2_lut2_long_intf;	
   logic		st2_lut2_long_wr;	
   s_st_lut_intf	st2_lut2_short_intf;	
   logic		st2_lut2_short_wr;	
   s_st_sa_intf		st2_sa_long_intf;	
   logic		st2_sa_long_size_rdy_pre;
   logic		st2_sa_long_table_rdy_pre;
   s_st_sa_intf		st2_sa_short_intf;	
   logic		st2_sa_short_size_rdy_pre;
   logic		st2_sa_short_table_rdy_pre;
   
   logic [3:0] 		sc_is_short_vld;
   logic  		sc_is_long_vld;
   logic 		st1_sa_short_size_rdy;
   logic 		st1_sa_long_size_rdy;
   logic 		st2_sa_short_size_rdy;
   logic 		st2_sa_long_size_rdy;
   logic 		st1_sa_short_table_rdy;
   logic 		st1_sa_long_table_rdy;
   logic 		st2_sa_short_table_rdy;
   logic 		st2_sa_long_table_rdy;
   s_sc_sm_long_intf	sc_sm_long_intf;	
   s_sc_sm_shrt_intf	sc_sm_shrt_intf;
   s_sq_sm_intf		sq_sm_intf;
   logic 		mrdten;
   huf_comp_stats_t     huf_comp_stats_sa;
   
   logic 		sc_short_bimc_odat;
   logic 		sc_short_bimc_osync;
   logic 		sc_short_bimc_rst_n;
   logic 		sc_short_bimc_isync;
   logic 		sc_short_bimc_idat;
   logic 		sc_long_bimc_odat;
   logic 		sc_long_bimc_osync;
   logic 		sc_long_bimc_rst_n;
   logic 		sc_long_bimc_isync;
   logic 		sc_long_bimc_idat;
   logic 		lut_short_bimc_odat;
   logic 		lut_short_bimc_osync;
   logic 		lut_short_bimc_rst_n;
   logic 		lut_short_bimc_isync;
   logic 		lut_short_bimc_idat;
   logic 		lut_long_bimc_odat;
   logic 		lut_long_bimc_osync;
   logic 		lut_long_bimc_rst_n;
   logic 		lut_long_bimc_isync;
   logic 		lut_long_bimc_idat;
   logic 		ph_bimc_odat;
   logic 		ph_bimc_osync;
   logic 		ph_bimc_rst_n;
   logic 		ph_bimc_isync;
   logic 		ph_bimc_idat;
   logic 		sq_bimc_odat;
   logic 		sq_bimc_osync;
   logic 		sq_bimc_rst_n;
   logic 		sq_bimc_isync;
   logic 		sq_bimc_idat;
   logic 		decomp_bimc_odat;
   logic 		decomp_bimc_osync;
   logic 		decomp_bimc_rst_n;
   logic 		decomp_bimc_isync;
   logic 		decomp_bimc_idat;
   logic                ee_bimc_odat;
   logic 		ee_bimc_osync;
   logic 		ee_bimc_rst_n;
   logic 		ee_bimc_isync;
   logic 		ee_bimc_idat;
   logic 		ecc_error;
   logic 		lz77_hb_ro_uncorrectable_ecc_error_a_reg;
   logic 		lz77_hb_ro_uncorrectable_ecc_error_b_reg;
   logic 		lz77_pfx0_ro_uncorrectable_ecc_error_reg;
   logic 		lz77_pfx1_ro_uncorrectable_ecc_error_reg;
   logic 		ee_ecc_error_reg;
   
   
   
   always_comb begin
      ecc_error                     = lut_long_sa_ro_uncorrectable_ecc_error    |
				      lut_short_sa_ro_uncorrectable_ecc_error   |
				      ph_sa_ro_uncorrectable_ecc_error          |
				      sc_long_sa_ro_uncorrectable_ecc_error     |
				      sc_short_sa_ro_uncorrectable_ecc_error    |
				      sq_sa_ro_uncorrectable_ecc_error          |
				      ee_ecc_error_reg                         |
				      lz77_hb_ro_uncorrectable_ecc_error_a_reg  |
				      lz77_hb_ro_uncorrectable_ecc_error_b_reg  |
				      lz77_pfx0_ro_uncorrectable_ecc_error_reg  |
				      lz77_pfx1_ro_uncorrectable_ecc_error_reg  |
				      ism_ecc_error;
      mrdten                        = 0;
      huf_comp_ib_out.tready        = huf_comp_ib_out_pre.tready;       
      sc_sm_shrt_intf.rdy           = sc_sm_shrt_intf_pre.rdy;   
      sc_sm_long_intf.rdy           = sc_sm_long_intf_pre.rdy;         
      sc_is_short_vld               = sc_is_short_vld_pre; 
      sc_is_long_vld                = sc_is_long_vld_pre;         
      st1_sa_short_size_rdy         = st1_sa_short_size_rdy_pre;   
      st1_sa_long_size_rdy          = st1_sa_long_size_rdy_pre;         
      st2_sa_short_size_rdy         = st2_sa_short_size_rdy_pre;   
      st2_sa_long_size_rdy          = st2_sa_long_size_rdy_pre;         
      st1_sa_short_table_rdy        = st1_sa_short_table_rdy_pre;   
      st1_sa_long_table_rdy         = st1_sa_long_table_rdy_pre;         
      st2_sa_short_table_rdy        = st2_sa_short_table_rdy_pre;   
      st2_sa_long_table_rdy         = st2_sa_long_table_rdy_pre; 
      sq_sm_intf.rdy                = sq_sm_intf_pre.rdy; 

      
      sc_short_bimc_rst_n           = core_bimc_rst_n;
      sc_long_bimc_rst_n            = core_bimc_rst_n;
      lut_short_bimc_rst_n          = core_bimc_rst_n;
      lut_long_bimc_rst_n           = core_bimc_rst_n;
      ph_bimc_rst_n                 = core_bimc_rst_n;
      sq_bimc_rst_n                 = core_bimc_rst_n;
      decomp_bimc_rst_n             = core_bimc_rst_n;
      ee_bimc_rst_n                 = core_bimc_rst_n;
      
      sc_short_bimc_isync           = core_bimc_isync;
      sc_short_bimc_idat            = core_bimc_idat;
      sc_long_bimc_isync            = sc_short_bimc_osync;
      sc_long_bimc_idat             = sc_short_bimc_odat;
      lut_short_bimc_isync          = sc_long_bimc_osync;
      lut_short_bimc_idat           = sc_long_bimc_odat;
      lut_long_bimc_isync           = lut_short_bimc_osync;
      lut_long_bimc_idat            = lut_short_bimc_odat;
      ph_bimc_isync                 = lut_long_bimc_osync;
      ph_bimc_idat                  = lut_long_bimc_odat;
      sq_bimc_isync                 = ph_bimc_osync;
      sq_bimc_idat                  = ph_bimc_odat;
      decomp_bimc_isync             = sq_bimc_osync;
      decomp_bimc_idat              = sq_bimc_odat;
      ee_bimc_isync                 = decomp_bimc_osync;
      ee_bimc_idat                  = decomp_bimc_odat;
      core_bimc_osync               = ee_bimc_osync;
      core_bimc_odat                = ee_bimc_odat;
      huf_comp_stats                = huf_comp_stats_sa;
      
      huf_comp_stats.lz77_stall_stb = lz77_stall_stb;
      
      
   end 

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
	 
	 
	 ee_ecc_error_reg <= 0;
	 lz77_hb_ro_uncorrectable_ecc_error_a_reg <= 0;
	 lz77_hb_ro_uncorrectable_ecc_error_b_reg <= 0;
	 lz77_pfx0_ro_uncorrectable_ecc_error_reg <= 0;
	 lz77_pfx1_ro_uncorrectable_ecc_error_reg <= 0;
	 
      end
      else begin
	 lz77_hb_ro_uncorrectable_ecc_error_a_reg <= lz77_hb_ro_uncorrectable_ecc_error_a;
	 lz77_hb_ro_uncorrectable_ecc_error_b_reg <= lz77_hb_ro_uncorrectable_ecc_error_b;
	 lz77_pfx0_ro_uncorrectable_ecc_error_reg <= lz77_pfx0_ro_uncorrectable_ecc_error;
	 lz77_pfx1_ro_uncorrectable_ecc_error_reg <= lz77_pfx1_ro_uncorrectable_ecc_error;
	 ee_ecc_error_reg                         <= ee_ecc_error;	 
      end
   end
   
   
   cr_huf_comp_sm cr_huf_comp_sm
     (
      
      .huf_comp_ib_out			(huf_comp_ib_out_pre),	 
      .sm_sq_intf			(sm_sq_intf),
      .sm_seq_id_wr_intf		(sm_seq_id_wr_intf),
      .sm_seq_id_intf			(sm_seq_id_intf),
      .sm_sc_shrt_intf			(sm_sc_shrt_intf),
      .sm_sc_long_intf			(sm_sc_long_intf),
      .sm_predet_mem_shrt_intf		(sm_predet_mem_shrt_intf),
      .sm_predet_mem_long_intf		(sm_predet_mem_long_intf),
      .lz77_stall_stb			(lz77_stall_stb),
      .sm_bip2_reg			(sm_bip2_reg),
      
      .clk				(clk),
      .rst_n				(rst_n),
      .huf_comp_ib_in			(huf_comp_ib_in),
      .huf_comp_module_id		(huf_comp_in_module_id), 
      .sq_sm_intf			(sq_sm_intf),
      .sc_sm_shrt_intf			(sc_sm_shrt_intf),
      .sc_sm_long_intf			(sc_sm_long_intf),
      .sa_sm_intf			(sa_sm_intf),
      .sw_henc_huff_win_size_in_entries	(sw_henc_huff_win_size_in_entries[`CR_HUF_COMP_C_HENC_HUFF_WIN_SIZE_IN_ENTRIES_T_DECL]),
      .sw_henc_xp9_first_blk_thrsh	(sw_henc_xp9_first_blk_thrsh[`CR_HUF_COMP_C_HENC_EX9_FIRST_BLK_THRESH_T_DECL]),
      .sw_sm_in_tlv_parse_action_0	(sw_sm_in_tlv_parse_action_0[`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_31_0_T_DECL]),
      .sw_sm_in_tlv_parse_action_1	(sw_sm_in_tlv_parse_action_1[`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_63_32_T_DECL]));
   
   
   cr_huf_comp_sc_short cr_huf_comp_sc_short
     (
      
      .sc_short_bimc_odat		(sc_short_bimc_odat),
      .sc_short_bimc_osync		(sc_short_bimc_osync),
      .sc_short_sa_ro_uncorrectable_ecc_error(sc_short_sa_ro_uncorrectable_ecc_error),
      .sc_sm_shrt_intf			(sc_sm_shrt_intf_pre),	 
      .sc_is_short_intf			(sc_is_short_intf),
      .sc_is_short_vld			(sc_is_short_vld_pre[3:0]), 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .lvm				(lvm),
      .mlvm				(mlvm),
      .mrdten				(mrdten),
      .sc_short_bimc_rst_n		(sc_short_bimc_rst_n),
      .sc_short_bimc_isync		(sc_short_bimc_isync),
      .sc_short_bimc_idat		(sc_short_bimc_idat),
      .sm_sc_shrt_intf			(sm_sc_shrt_intf),
      .is_sc_short_rd			(is_sc_short_rd));
   
   cr_huf_comp_sc_long cr_huf_comp_sc_long
     (
      
      .sc_long_bimc_odat		(sc_long_bimc_odat),
      .sc_long_bimc_osync		(sc_long_bimc_osync),
      .sc_long_sa_ro_uncorrectable_ecc_error(sc_long_sa_ro_uncorrectable_ecc_error),
      .sc_sm_long_intf			(sc_sm_long_intf_pre),	 
      .sc_is_long_intf			(sc_is_long_intf),
      .sc_is_long_vld			(sc_is_long_vld_pre),	 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .lvm				(lvm),
      .mlvm				(mlvm),
      .mrdten				(mrdten),
      .sc_long_bimc_rst_n		(sc_long_bimc_rst_n),
      .sc_long_bimc_isync		(sc_long_bimc_isync),
      .sc_long_bimc_idat		(sc_long_bimc_idat),
      .sm_sc_long_intf			(sm_sc_long_intf),
      .is_sc_long_rd			(is_sc_long_rd));

   
 cr_huf_comp_lut_short lut_short(
				 
				 .lut_short_bimc_odat	(lut_short_bimc_odat),
				 .lut_short_bimc_osync	(lut_short_bimc_osync),
				 .lut_short_sa_ro_uncorrectable_ecc_error(lut_short_sa_ro_uncorrectable_ecc_error),
				 .lut1_hw1_short_full	(lut1_hw1_short_full),
				 .lut2_hw2_short_full	(lut2_hw2_short_full),
				 .lut1_st1_short_full	(lut1_st1_short_full),
				 .lut2_st2_short_full	(lut2_st2_short_full),
				 .lut_sa_short_st_stcl_val(lut_sa_short_st_stcl_val),
				 .lut_sa_short_data_val	(lut_sa_short_data_val),
				 .lut_sa_short_intf	(lut_sa_short_intf),
				 
				 .clk			(clk),
				 .rst_n			(rst_n),
				 .lvm			(lvm),
				 .mlvm			(mlvm),
				 .mrdten		(mrdten),
				 .lut_short_bimc_rst_n	(lut_short_bimc_rst_n),
				 .lut_short_bimc_isync	(lut_short_bimc_isync),
				 .lut_short_bimc_idat	(lut_short_bimc_idat),
				 .hw1_lut1_short_wr	(hw1_lut1_short_wr),
				 .hw1_lut1_short_intf	(hw1_lut1_short_intf),
				 .hw2_lut2_short_wr	(hw2_lut2_short_wr),
				 .hw2_lut2_short_intf	(hw2_lut2_short_intf),
				 .st1_lut1_short_wr	(st1_lut1_short_wr),
				 .st1_lut1_short_intf	(st1_lut1_short_intf),
				 .st2_lut2_short_wr	(st2_lut2_short_wr),
				 .st2_lut2_short_intf	(st2_lut2_short_intf),
				 .sa_lut_short_intf	(sa_lut_short_intf));
 
 cr_huf_comp_lut_long lut_long(
			       
			       .lut_long_bimc_odat(lut_long_bimc_odat),
			       .lut_long_bimc_osync(lut_long_bimc_osync),
			       .lut_long_sa_ro_uncorrectable_ecc_error(lut_long_sa_ro_uncorrectable_ecc_error),
			       .lut1_hw1_long_full(lut1_hw1_long_full),
			       .lut2_hw2_long_full(lut2_hw2_long_full),
			       .lut1_st1_long_full(lut1_st1_long_full),
			       .lut2_st2_long_full(lut2_st2_long_full),
			       .lut_sa_long_st_stcl_val(lut_sa_long_st_stcl_val),
			       .lut_sa_long_data_val(lut_sa_long_data_val),
			       .lut_sa_long_intf(lut_sa_long_intf),
			       
			       .clk		(clk),
			       .rst_n		(rst_n),
			       .lvm		(lvm),
			       .mlvm		(mlvm),
			       .mrdten		(mrdten),
			       .lut_long_bimc_rst_n(lut_long_bimc_rst_n),
			       .lut_long_bimc_isync(lut_long_bimc_isync),
			       .lut_long_bimc_idat(lut_long_bimc_idat),
			       .hw1_lut1_long_wr(hw1_lut1_long_wr),
			       .hw1_lut1_long_intf(hw1_lut1_long_intf),
			       .hw2_lut2_long_wr(hw2_lut2_long_wr),
			       .hw2_lut2_long_intf(hw2_lut2_long_intf),
			       .st1_lut1_long_wr(st1_lut1_long_wr),
			       .st1_lut1_long_intf(st1_lut1_long_intf),
			       .st2_lut2_long_wr(st2_lut2_long_wr),
			       .st2_lut2_long_intf(st2_lut2_long_intf),
			       .sa_lut_long_intf(sa_lut_long_intf));

    
   cr_huf_comp_seq_id_array cr_huf_comp_seq_id_array
     (
      
      .seq_id_intf_array		(seq_id_intf_array),
      .seq_id_intf_array_vld		(seq_id_intf_array_vld[`CREOLE_HC_SEQID_NUM-1:0]),
      .hdr_short_ht1_type		(hdr_short_ht1_type),
      .hdr_short_ht2_type		(hdr_short_ht2_type),
      .hdr_long_ht1_type		(hdr_long_ht1_type),
      .hdr_long_ht2_type		(hdr_long_ht2_type),
      .hdr_short_hw1_type		(hdr_short_hw1_type),
      .hdr_short_hw2_type		(hdr_short_hw2_type),
      .hdr_long_hw1_type		(hdr_long_hw1_type),
      .hdr_long_hw2_type		(hdr_long_hw2_type),
      .hdr_short_st1_type		(),			 
      .hdr_short_st2_type		(),			 
      .hdr_long_st1_type		(),			 
      .hdr_long_st2_type		(),			 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .sm_seq_id_wr_intf		(sm_seq_id_wr_intf),
      .sm_seq_id_intf			(sm_seq_id_intf),
      .sa_sm_intf			(sa_sm_intf),
      .short_ht1_hdr_seq_id		(short_ht1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
      .short_ht2_hdr_seq_id		(short_ht2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
      .long_ht1_hdr_seq_id		(long_ht1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
      .long_ht2_hdr_seq_id		(long_ht2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
      .short_hw1_hdr_seq_id		(short_hw1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
      .short_hw2_hdr_seq_id		(short_hw2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
      .long_hw1_hdr_seq_id		(long_hw1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
      .long_hw2_hdr_seq_id		(long_hw2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
      .short_st1_hdr_seq_id		(`CREOLE_HC_SEQID_WIDTH'b0), 
      .short_st2_hdr_seq_id		(`CREOLE_HC_SEQID_WIDTH'b0), 
      .long_st1_hdr_seq_id		(`CREOLE_HC_SEQID_WIDTH'b0), 
      .long_st2_hdr_seq_id		(`CREOLE_HC_SEQID_WIDTH'b0)); 
   
    
   cr_huf_comp_ph cr_huf_comp_ph
     (
      
      .ph_bimc_odat			(ph_bimc_odat),
      .ph_bimc_osync			(ph_bimc_osync),
      .ph_sa_ro_uncorrectable_ecc_error	(ph_sa_ro_uncorrectable_ecc_error),
      .ph_long_hw1_intf			(ph_long_hw1_intf),
      .ph_long_hw2_intf			(ph_long_hw2_intf),
      .ph_long_hw1_val			(ph_long_hw1_val),
      .ph_long_hw2_val			(ph_long_hw2_val),
      .ph_short_hw1_intf		(ph_short_hw1_intf),
      .ph_short_hw2_intf		(ph_short_hw2_intf),
      .ph_short_hw1_val			(ph_short_hw1_val),
      .ph_short_hw2_val			(ph_short_hw2_val),
      
      .clk				(clk),
      .rst_n				(rst_n),
      .lvm				(lvm),
      .mlvm				(mlvm),
      .mrdten				(mrdten),
      .ph_bimc_rst_n			(ph_bimc_rst_n),
      .ph_bimc_isync			(ph_bimc_isync),
      .ph_bimc_idat			(ph_bimc_idat),
      .sm_predet_mem_long_intf		(sm_predet_mem_long_intf),
      .sm_predet_mem_shrt_intf		(sm_predet_mem_shrt_intf),
      .seq_id_intf_array		(seq_id_intf_array),
      .long_hw1_ph_intf			(long_hw1_ph_intf),
      .long_hw2_ph_intf			(long_hw2_ph_intf),
      .short_hw1_ph_intf		(short_hw1_ph_intf),
      .short_hw2_ph_intf		(short_hw2_ph_intf));
   
    
   cr_huf_comp_sq cr_huf_comp_sq
     (
      
      .sq_bimc_odat			(sq_bimc_odat),
      .sq_bimc_osync			(sq_bimc_osync),
      .sq_sa_ro_uncorrectable_ecc_error	(sq_sa_ro_uncorrectable_ecc_error),
      .sq_sa_intf			(sq_sa_intf),
      .sq_sm_intf			(sq_sm_intf_pre),	 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .lvm				(lvm),
      .mlvm				(mlvm),
      .mrdten				(mrdten),
      .ovstb				(ovstb),
      .sq_bimc_isync			(sq_bimc_isync),
      .sq_bimc_idat			(sq_bimc_idat),
      .sq_bimc_rst_n			(sq_bimc_rst_n),
      .sa_sq_intf			(sa_sq_intf),
      .sm_sq_intf			(sm_sq_intf));

    
   cr_huf_comp_sa cr_huf_comp_sa
     (
      
      .huf_comp_ob_out			(huf_comp_ob_out),
      .sa_sm_intf			(sa_sm_intf),
      .sa_st1_short_read_done		(sa_st1_short_read_done),
      .sa_st1_long_read_done		(sa_st1_long_read_done),
      .sa_st2_short_read_done		(sa_st2_short_read_done),
      .sa_st2_long_read_done		(sa_st2_long_read_done),
      .sa_lut_long_intf			(sa_lut_long_intf),
      .sa_lut_short_intf		(sa_lut_short_intf),
      .sa_sq_intf			(sa_sq_intf),
      .huf_comp_sch_update		(huf_comp_sch_update),
      .huf_comp_stats			(huf_comp_stats_sa),	 
      .fhp_lz_prefix_hdr_valid		(fhp_lz_prefix_hdr_valid),
      .fhp_lz_prefix_valid		(fhp_lz_prefix_valid),
      .fhp_lz_prefix_hdr_bus		(fhp_lz_prefix_hdr_bus),
      .fhp_lz_prefix_dp_bus		(fhp_lz_prefix_dp_bus),
      .sdd_mtf_dp_bus			(sdd_mtf_dp_bus),
      .sdd_mtf_dp_valid			(sdd_mtf_dp_valid),
      .be_lz_dp_ready			(be_lz_dp_ready),
      .bhp_mtf_hdr_bus			(bhp_mtf_hdr_bus),
      .bhp_mtf_hdr_valid		(bhp_mtf_hdr_valid),
      .ecc_error_reg			(ecc_error_reg),
      .sa_bip2_reg			(sa_bip2_reg),
      
      .clk				(clk),
      .rst_n				(rst_n),
      .huf_comp_ob_in			(huf_comp_ob_in),
      .huf_comp_module_id		(huf_comp_out_module_id), 
      .seq_id_intf_array		(seq_id_intf_array),
      .seq_id_intf_array_vld		(seq_id_intf_array_vld[`CREOLE_HC_SEQID_NUM-1:0]),
      .st1_sa_long_intf			(st1_sa_long_intf),
      .st1_sa_long_size_rdy		(st1_sa_long_size_rdy),
      .st1_sa_long_table_rdy		(st1_sa_long_table_rdy),
      .st1_sa_short_intf		(st1_sa_short_intf),
      .st1_sa_short_size_rdy		(st1_sa_short_size_rdy),
      .st1_sa_short_table_rdy		(st1_sa_short_table_rdy),
      .st2_sa_long_intf			(st2_sa_long_intf),
      .st2_sa_long_size_rdy		(st2_sa_long_size_rdy),
      .st2_sa_long_table_rdy		(st2_sa_long_table_rdy),
      .st2_sa_short_intf		(st2_sa_short_intf),
      .st2_sa_short_size_rdy		(st2_sa_short_size_rdy),
      .st2_sa_short_table_rdy		(st2_sa_short_table_rdy),
      .lut_sa_long_data_val		(lut_sa_long_data_val),
      .lut_sa_long_intf			(lut_sa_long_intf),
      .lut_sa_long_st_stcl_val		(lut_sa_long_st_stcl_val),
      .lut_sa_short_data_val		(lut_sa_short_data_val),
      .lut_sa_short_intf		(lut_sa_short_intf),
      .lut_sa_short_st_stcl_val		(lut_sa_short_st_stcl_val),
      .sq_sa_intf			(sq_sa_intf),
      .sw_xp9_disable_modes		(sw_xp9_disable_modes),
      .sw_xp10_disable_modes		(sw_xp10_disable_modes),
      .sw_deflate_disable_modes		(sw_deflate_disable_modes),
      .sw_sa_out_tlv_parse_action_0	(sw_sa_out_tlv_parse_action_0[`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_31_0_T_DECL]),
      .sw_sa_out_tlv_parse_action_1	(sw_sa_out_tlv_parse_action_1[`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_63_32_T_DECL]),
      .sw_prefix_adj			(sw_prefix_adj[`CR_HUF_COMP_C_HENC_SCH_UPDATE_PREFIX_ADJ_T_DECL]),
      .sw_gzip_os			(sw_gzip_os[`CR_HUF_COMP_C_HENC_GZIP_OS_T_DECL]),
      .su_ready				(su_ready),
      .lz_fhp_prefix_hdr_ready		(lz_fhp_prefix_hdr_ready),
      .lz_fhp_pre_prefix_ready		(lz_fhp_pre_prefix_ready),
      .lz_fhp_usr_prefix_ready		(lz_fhp_usr_prefix_ready),
      .mtf_sdd_dp_ready			(mtf_sdd_dp_ready),
      .lz_be_dp_bus			(lz_be_dp_bus),
      .lz_be_dp_valid			(lz_be_dp_valid),
      .ecc_error			(ecc_error));
   
     
    cr_huf_comp_reconstruct cr_huf_comp_reconstruct
     (
      
      .bimc_odat			(decomp_bimc_odat),	 
      .bimc_osync			(decomp_bimc_osync),	 
      .lz_fhp_prefix_hdr_ready		(lz_fhp_prefix_hdr_ready),
      .lz_fhp_pre_prefix_ready		(lz_fhp_pre_prefix_ready),
      .lz_fhp_usr_prefix_ready		(lz_fhp_usr_prefix_ready),
      .lz_fhp_dbg_data_ready		(),			 
      .lz_mtf_dp_ready			(lz_mtf_dp_ready),
      .lz_be_dp_valid			(lz_be_dp_valid),
      .lz_be_dp_bus			(lz_be_dp_bus),
      .lz_bytes_decomp			(),			 
      .lz_hb_bytes			(),			 
      .lz_hb_head_ptr			(),			 
      .lz_hb_tail_ptr			(),			 
      .lz_local_bytes			(),			 
      .xp10_decomp_lz77d_stat_events	(huf_comp_xp10_decomp_lz77d_stat_events), 
      .lz77_hb_ro_uncorrectable_ecc_error_a(lz77_hb_ro_uncorrectable_ecc_error_a),
      .lz77_hb_ro_uncorrectable_ecc_error_b(lz77_hb_ro_uncorrectable_ecc_error_b),
      .lz77_pfx0_ro_uncorrectable_ecc_error(lz77_pfx0_ro_uncorrectable_ecc_error),
      .lz77_pfx1_ro_uncorrectable_ecc_error(lz77_pfx1_ro_uncorrectable_ecc_error),
      
      .clk				(clk),
      .rst_n				(rst_n),
      .ovstb				(ovstb),
      .lvm				(lvm),
      .mlvm				(mlvm),
      .bimc_idat			(decomp_bimc_idat),	 
      .bimc_isync			(decomp_bimc_isync),	 
      .bimc_rst_n			(decomp_bimc_rst_n),	 
      .fhp_lz_prefix_hdr_valid		(fhp_lz_prefix_hdr_valid),
      .fhp_lz_prefix_hdr_bus		(fhp_lz_prefix_hdr_bus),
      .fhp_lz_prefix_valid		(fhp_lz_prefix_valid),
      .fhp_lz_prefix_dp_bus		(fhp_lz_prefix_dp_bus),
      .fhp_lz_dbg_data_valid		(1'd0),			 
      .fhp_lz_dbg_data_bus		(64'd0),		 
      .mtf_lz_dp_valid			(mtf_lz_dp_valid),
      .mtf_lz_dp_bus			(mtf_lz_dp_bus),
      .be_lz_dp_ready			(be_lz_dp_ready),
      .sw_LZ_BYPASS_CONFIG		(1'b0));			 


    
   cr_xp10_decomp_mtf cr_xp10_decomp_mtf 
     (
      
      .mtf_bhp_hdr_ready		(),			 
      .mtf_sdd_dp_ready			(mtf_sdd_dp_ready),
      .mtf_lz_dp_valid			(mtf_lz_dp_valid),
      .mtf_lz_dp_bus			(mtf_lz_dp_bus),
      
      .clk				(clk),
      .rst_n				(rst_n),
      .ovstb				(1'd1),			 
      .lvm				(1'd0),			 
      .mlvm				(1'd0),			 
      .bhp_mtf_hdr_valid		(bhp_mtf_hdr_valid),
      .bhp_mtf_hdr_bus			(bhp_mtf_hdr_bus),
      .sdd_mtf_dp_valid			(sdd_mtf_dp_valid),
      .sdd_mtf_dp_bus			(sdd_mtf_dp_bus),
      .lz_mtf_dp_ready			(lz_mtf_dp_ready));


    
    cr_huf_comp_encoder_engine 
    #(
      .SINGLE_PIPE        (SINGLE_PIPE),  
      .FPGA_MOD           (FPGA_MOD)     
     )
    u_encoder_engine 
     (
      
      .hw1_lut1_long_intf		(hw1_lut1_long_intf),
      .hw1_lut1_long_wr			(hw1_lut1_long_wr),
      .hw1_lut1_short_intf		(hw1_lut1_short_intf),
      .hw1_lut1_short_wr		(hw1_lut1_short_wr),
      .hw2_lut2_long_intf		(hw2_lut2_long_intf),
      .hw2_lut2_long_wr			(hw2_lut2_long_wr),
      .hw2_lut2_short_intf		(hw2_lut2_short_intf),
      .hw2_lut2_short_wr		(hw2_lut2_short_wr),
      .is_sc_long_rd			(is_sc_long_rd),
      .is_sc_short_rd			(is_sc_short_rd),
      .long_bl_ism_data			(long_bl_ism_data),
      .long_bl_ism_vld			(long_bl_ism_vld),
      .long_ht_dbg_cntr_rebuild		(long_ht_dbg_cntr_rebuild),
      .long_ht_dbg_cntr_rebuild_failed	(long_ht_dbg_cntr_rebuild_failed),
      .long_ht_dbg_cntr_rebuild_cnt	(long_ht_dbg_cntr_rebuild_cnt[1:0]),
      .long_ht_dbg_cntr_rebuild_failed_cnt(long_ht_dbg_cntr_rebuild_failed_cnt[1:0]),
      .long_ht1_hdr_seq_id		(long_ht1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
      .long_ht2_hdr_seq_id		(long_ht2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
      .long_hw1_hdr_seq_id		(long_hw1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
      .long_hw1_ph_intf			(long_hw1_ph_intf),
      .long_hw2_hdr_seq_id		(long_hw2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
      .long_hw2_ph_intf			(long_hw2_ph_intf),
      .long_st_dbg_cntr_rebuild		(long_st_dbg_cntr_rebuild),
      .long_st_dbg_cntr_rebuild_failed	(long_st_dbg_cntr_rebuild_failed),
      .long_st_dbg_cntr_rebuild_cnt	(long_st_dbg_cntr_rebuild_cnt[1:0]),
      .long_st_dbg_cntr_rebuild_failed_cnt(long_st_dbg_cntr_rebuild_failed_cnt[1:0]),
      .short_bl_ism_data		(short_bl_ism_data),
      .short_bl_ism_vld			(short_bl_ism_vld),
      .short_ht_dbg_cntr_rebuild	(short_ht_dbg_cntr_rebuild),
      .short_ht_dbg_cntr_rebuild_failed	(short_ht_dbg_cntr_rebuild_failed),
      .short_ht_dbg_cntr_rebuild_cnt	(short_ht_dbg_cntr_rebuild_cnt[1:0]),
      .short_ht_dbg_cntr_rebuild_failed_cnt(short_ht_dbg_cntr_rebuild_failed_cnt[1:0]),
      .short_ht1_hdr_seq_id		(short_ht1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
      .short_ht2_hdr_seq_id		(short_ht2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
      .short_hw1_hdr_seq_id		(short_hw1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
      .short_hw1_ph_intf		(short_hw1_ph_intf),
      .short_hw2_hdr_seq_id		(short_hw2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
      .short_hw2_ph_intf		(short_hw2_ph_intf),
      .short_st_dbg_cntr_rebuild	(short_st_dbg_cntr_rebuild),
      .short_st_dbg_cntr_rebuild_failed	(short_st_dbg_cntr_rebuild_failed),
      .short_st_dbg_cntr_rebuild_cnt	(short_st_dbg_cntr_rebuild_cnt[1:0]),
      .short_st_dbg_cntr_rebuild_failed_cnt(short_st_dbg_cntr_rebuild_failed_cnt[1:0]),
      .st1_lut1_long_intf		(st1_lut1_long_intf),
      .st1_lut1_long_wr			(st1_lut1_long_wr),
      .st1_lut1_short_intf		(st1_lut1_short_intf),
      .st1_lut1_short_wr		(st1_lut1_short_wr),
      .st1_sa_long_intf			(st1_sa_long_intf),
      .st1_sa_long_size_rdy_pre		(st1_sa_long_size_rdy_pre),
      .st1_sa_long_table_rdy_pre	(st1_sa_long_table_rdy_pre),
      .st1_sa_short_intf		(st1_sa_short_intf),
      .st1_sa_short_size_rdy_pre	(st1_sa_short_size_rdy_pre),
      .st1_sa_short_table_rdy_pre	(st1_sa_short_table_rdy_pre),
      .st2_lut2_long_intf		(st2_lut2_long_intf),
      .st2_lut2_long_wr			(st2_lut2_long_wr),
      .st2_lut2_short_intf		(st2_lut2_short_intf),
      .st2_lut2_short_wr		(st2_lut2_short_wr),
      .st2_sa_long_intf			(st2_sa_long_intf),
      .st2_sa_long_size_rdy_pre		(st2_sa_long_size_rdy_pre),
      .st2_sa_long_table_rdy_pre	(st2_sa_long_table_rdy_pre),
      .st2_sa_short_intf		(st2_sa_short_intf),
      .st2_sa_short_size_rdy_pre	(st2_sa_short_size_rdy_pre),
      .st2_sa_short_table_rdy_pre	(st2_sa_short_table_rdy_pre),
      .st_long_bl_ism_data		(st_long_bl_ism_data),
      .st_long_bl_ism_vld		(st_long_bl_ism_vld),
      .st_short_bl_ism_data		(st_short_bl_ism_data),
      .st_short_bl_ism_vld		(st_short_bl_ism_vld),
      .ee_ecc_error			(ee_ecc_error),
      .ee_bimc_odat			(ee_bimc_odat),
      .ee_bimc_osync			(ee_bimc_osync),
      
      .clk				(clk),
      .hdr_long_ht1_type		(hdr_long_ht1_type),
      .hdr_long_ht2_type		(hdr_long_ht2_type),
      .hdr_long_hw1_type		(hdr_long_hw1_type),
      .hdr_long_hw2_type		(hdr_long_hw2_type),
      .hdr_short_ht1_type		(hdr_short_ht1_type),
      .hdr_short_ht2_type		(hdr_short_ht2_type),
      .hdr_short_hw1_type		(hdr_short_hw1_type),
      .hdr_short_hw2_type		(hdr_short_hw2_type),
      .long_ism_rdy			(long_ism_rdy),
      .lut1_hw1_long_full		(lut1_hw1_long_full),
      .lut1_hw1_short_full		(lut1_hw1_short_full),
      .lut1_st1_long_full		(lut1_st1_long_full),
      .lut1_st1_short_full		(lut1_st1_short_full),
      .lut2_hw2_long_full		(lut2_hw2_long_full),
      .lut2_hw2_short_full		(lut2_hw2_short_full),
      .lut2_st2_long_full		(lut2_st2_long_full),
      .lut2_st2_short_full		(lut2_st2_short_full),
      .mrdten				(mrdten),
      .ph_long_hw1_intf			(ph_long_hw1_intf),
      .ph_long_hw1_val			(ph_long_hw1_val),
      .ph_long_hw2_intf			(ph_long_hw2_intf),
      .ph_long_hw2_val			(ph_long_hw2_val),
      .ph_short_hw1_intf		(ph_short_hw1_intf),
      .ph_short_hw1_val			(ph_short_hw1_val),
      .ph_short_hw2_intf		(ph_short_hw2_intf),
      .ph_short_hw2_val			(ph_short_hw2_val),
      .rst_n				(rst_n),
      .sa_st1_long_read_done		(sa_st1_long_read_done),
      .sa_st1_short_read_done		(sa_st1_short_read_done),
      .sa_st2_long_read_done		(sa_st2_long_read_done),
      .sa_st2_short_read_done		(sa_st2_short_read_done),
      .sc_is_long_intf			(sc_is_long_intf),
      .sc_is_long_vld			(sc_is_long_vld),
      .sc_is_short_intf			(sc_is_short_intf),
      .sc_is_short_vld			(sc_is_short_vld[3:0]),
      .short_ism_rdy			(short_ism_rdy),
      .st_long_ism_rdy			(st_long_ism_rdy),
      .st_short_ism_rdy			(st_short_ism_rdy),
      .sw_disable_sub_pipe		(sw_disable_sub_pipe),
      .lvm				(lvm),
      .mlvm				(mlvm),
      .ovstb				(ovstb),
      .ee_bimc_rst_n			(ee_bimc_rst_n),
      .ee_bimc_isync			(ee_bimc_isync),
      .ee_bimc_idat			(ee_bimc_idat),
      .sw_short_ht_config		(sw_short_ht_config),
      .sw_long_ht_config		(sw_long_ht_config),
      .sw_st_short_ht_config		(sw_st_short_ht_config),
      .sw_st_long_ht_config		(sw_st_long_ht_config),
      .sw_debug_control			(sw_debug_control),
      .sw_force_block_stall		(8'h00));		 
   
endmodule 









