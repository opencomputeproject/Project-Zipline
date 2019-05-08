/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/









module cr_huf_comp_regfile 
  (
   
   rbus_ring_o, sw_henc_huff_win_size_in_entries,
   sw_henc_xp9_first_blk_thrsh, sw_prefix_adj, sw_gzip_os,
   sw_sa_out_tlv_parse_action_0, sw_sa_out_tlv_parse_action_1,
   sw_sm_in_tlv_parse_action_0, sw_sm_in_tlv_parse_action_1,
   sw_short_ht_config, sw_long_ht_config, sw_st_short_ht_config,
   sw_st_long_ht_config, sw_xp9_disable_modes, sw_xp10_disable_modes,
   sw_deflate_disable_modes, sw_disable_sub_pipe, sw_debug_control,
   huf_comp_ob_out, huf_comp_ob_in_mod, im_available_huf,
   im_available_he_sh, im_available_he_lng, im_available_he_st_sh,
   im_available_he_st_lng, short_ism_rdy, long_ism_rdy,
   st_short_ism_rdy, st_long_ism_rdy, core_bimc_rst_n,
   core_bimc_isync, core_bimc_idat, ism_ecc_error, huf_comp_int,
   
   rst_n, clk, cfg_start_addr, cfg_end_addr, rbus_ring_i,
   huf_comp_ob_out_pre, huf_comp_ob_in, im_consumed_huf,
   im_consumed_he_sh, im_consumed_he_lng, im_consumed_he_st_sh,
   im_consumed_he_st_lng, short_bl_ism_data, short_bl_ism_vld,
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
   long_st_dbg_cntr_rebuild_failed_cnt, lvm, mlvm, ovstb,
   core_bimc_odat, core_bimc_osync, sa_bip2_reg, sm_bip2_reg,
   ecc_error_reg
   );

`include "cr_structs.sv"
`include "bimc_master.vh"   
   import cr_huf_compPKG::*;
   import cr_huf_comp_regfilePKG::*;
   
   
   output rbus_ring_t                                                 rbus_ring_o;
   output logic [`CR_HUF_COMP_C_HENC_HUFF_WIN_SIZE_IN_ENTRIES_T_DECL] sw_henc_huff_win_size_in_entries;
   output logic [`CR_HUF_COMP_C_HENC_EX9_FIRST_BLK_THRESH_T_DECL]     sw_henc_xp9_first_blk_thrsh;
   output logic [`CR_HUF_COMP_C_HENC_SCH_UPDATE_PREFIX_ADJ_T_DECL]    sw_prefix_adj;
   output logic [`CR_HUF_COMP_C_HENC_GZIP_OS_T_DECL] 		      sw_gzip_os;
   output logic [`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_31_0_T_DECL]  sw_sa_out_tlv_parse_action_0;
   output logic [`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_63_32_T_DECL] sw_sa_out_tlv_parse_action_1;
   output logic [`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_31_0_T_DECL]   sw_sm_in_tlv_parse_action_0;
   output logic [`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_63_32_T_DECL]  sw_sm_in_tlv_parse_action_1;
   output ht_config_t                                                 sw_short_ht_config;
   output ht_config_t                                                 sw_long_ht_config;
   output small_ht_config_t                                           sw_st_short_ht_config;
   output small_ht_config_t                                           sw_st_long_ht_config;
   output henc_xp9_disable_modes_t                                    sw_xp9_disable_modes;
   output henc_xp10_disable_modes_t                                   sw_xp10_disable_modes;
   output henc_deflate_disable_modes_t                                sw_deflate_disable_modes;
   output henc_disable_sub_pipe_t                                     sw_disable_sub_pipe;
   output henc_debug_cntrl_t                                          sw_debug_control;
   output axi4s_dp_bus_t                                              huf_comp_ob_out;
   output axi4s_dp_rdy_t                                              huf_comp_ob_in_mod;
   output im_available_t	                                      im_available_huf;
   output im_available_t	                                      im_available_he_sh;
   output im_available_t	                                      im_available_he_lng;
   output im_available_t	                                      im_available_he_st_sh;
   output im_available_t	                                      im_available_he_st_lng;
   output                                                             short_ism_rdy;
   output                                                             long_ism_rdy;
   output                                                             st_short_ism_rdy;
   output                                                             st_long_ism_rdy;
   
   
   input logic 			                                      rst_n;
   input logic 							      clk;
   input [`N_RBUS_ADDR_BITS-1:0]                                      cfg_start_addr;
   input [`N_RBUS_ADDR_BITS-1:0]                                      cfg_end_addr;
   input rbus_ring_t                                                  rbus_ring_i;
   input axi4s_dp_bus_t                                               huf_comp_ob_out_pre;
   input axi4s_dp_rdy_t                                               huf_comp_ob_in;
   input im_consumed_t	                                              im_consumed_huf;
   input im_consumed_t	                                              im_consumed_he_sh;
   input im_consumed_t	                                              im_consumed_he_lng;
   input im_consumed_t	                                              im_consumed_he_st_sh;
   input im_consumed_t	                                              im_consumed_he_st_lng;
   input sh_bl_t                                                      short_bl_ism_data;
   input                                                              short_bl_ism_vld;
   input lng_bl_t                                                     long_bl_ism_data;
   input                                                              long_bl_ism_vld;
   input st_sh_bl_t                                                   st_short_bl_ism_data;
   input                                                              st_short_bl_ism_vld;
   input st_lng_bl_t                                                  st_long_bl_ism_data;
   input                                                              st_long_bl_ism_vld;
   input		                                              short_ht_dbg_cntr_rebuild;
   input		                                              short_ht_dbg_cntr_rebuild_failed;
   input [1:0]	                                                      short_ht_dbg_cntr_rebuild_cnt;
   input [1:0]	                                                      short_ht_dbg_cntr_rebuild_failed_cnt;
   input		                                              long_ht_dbg_cntr_rebuild;
   input		                                              long_ht_dbg_cntr_rebuild_failed;
   input [1:0]	                                                      long_ht_dbg_cntr_rebuild_cnt;
   input [1:0]	                                                      long_ht_dbg_cntr_rebuild_failed_cnt;
   input		                                              short_st_dbg_cntr_rebuild;
   input		                                              short_st_dbg_cntr_rebuild_failed;
   input [1:0]	                                                      short_st_dbg_cntr_rebuild_cnt;
   input [1:0]	                                                      short_st_dbg_cntr_rebuild_failed_cnt;
   input		                                              long_st_dbg_cntr_rebuild;
   input		                                              long_st_dbg_cntr_rebuild_failed;
   input [1:0]	                                                      long_st_dbg_cntr_rebuild_cnt;
   input [1:0]	                                                      long_st_dbg_cntr_rebuild_failed_cnt;

   
   
   input 					lvm;
   input 					mlvm;
   input 					ovstb;
   output logic					core_bimc_rst_n;
   output logic					core_bimc_isync;
   output logic					core_bimc_idat;   
   input  					core_bimc_odat;   
   input  					core_bimc_osync;

   output logic 				ism_ecc_error;
   input 					sa_bip2_reg;
   input 					sm_bip2_reg;
   input 					ecc_error_reg;

   output generic_int_t                         huf_comp_int;
   
   
   
   
   logic		bimc_ecc_error;		
   logic		bimc_interrupt;		
   logic [`CR_C_BIMC_CMD2_T_DECL] i_bimc_cmd2;	
   logic [`CR_C_BIMC_DBGCMD0_T_DECL] i_bimc_dbgcmd0;
   logic [`CR_C_BIMC_DBGCMD1_T_DECL] i_bimc_dbgcmd1;
   logic [`CR_C_BIMC_DBGCMD2_T_DECL] i_bimc_dbgcmd2;
   logic [`CR_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_correctable_error_cnt;
   logic [`CR_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_uncorrectable_error_cnt;
   logic [`CR_C_BIMC_ECCPAR_DEBUG_T_DECL] i_bimc_eccpar_debug;
   logic [`CR_C_BIMC_GLOBAL_CONFIG_T_DECL] i_bimc_global_config;
   logic [`CR_C_BIMC_MEMID_T_DECL] i_bimc_memid;
   logic [`CR_C_BIMC_MONITOR_T_DECL] i_bimc_monitor;
   logic [`CR_C_BIMC_PARITY_ERROR_CNT_T_DECL] i_bimc_parity_error_cnt;
   logic [`CR_C_BIMC_POLLRSP0_T_DECL] i_bimc_pollrsp0;
   logic [`CR_C_BIMC_POLLRSP1_T_DECL] i_bimc_pollrsp1;
   logic [`CR_C_BIMC_POLLRSP2_T_DECL] i_bimc_pollrsp2;
   logic [`CR_C_BIMC_RXCMD0_T_DECL] i_bimc_rxcmd0;
   logic [`CR_C_BIMC_RXCMD1_T_DECL] i_bimc_rxcmd1;
   logic [`CR_C_BIMC_RXCMD2_T_DECL] i_bimc_rxcmd2;
   logic [`CR_C_BIMC_RXRSP0_T_DECL] i_bimc_rxrsp0;
   logic [`CR_C_BIMC_RXRSP1_T_DECL] i_bimc_rxrsp1;
   logic [`CR_C_BIMC_RXRSP2_T_DECL] i_bimc_rxrsp2;
   logic		im_rdy;			
   logic		locl_ack;		
   logic		locl_err_ack;		
   logic [31:0]		locl_rd_data;		
   logic		locl_rd_strb;		
   logic		locl_wr_strb;		
   logic [`CR_HUF_COMP_C_BIMC_CMD0_T_DECL] o_bimc_cmd0;
   logic [`CR_HUF_COMP_C_BIMC_CMD1_T_DECL] o_bimc_cmd1;
   logic [`CR_HUF_COMP_C_BIMC_CMD2_T_DECL] o_bimc_cmd2;
   logic [`CR_HUF_COMP_C_BIMC_DBGCMD2_T_DECL] o_bimc_dbgcmd2;
   logic [`CR_HUF_COMP_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_correctable_error_cnt;
   logic [`CR_HUF_COMP_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_uncorrectable_error_cnt;
   logic [`CR_HUF_COMP_C_BIMC_ECCPAR_DEBUG_T_DECL] o_bimc_eccpar_debug;
   logic [`CR_HUF_COMP_C_BIMC_GLOBAL_CONFIG_T_DECL] o_bimc_global_config;
   logic [`CR_HUF_COMP_C_BIMC_MONITOR_MASK_T_DECL] o_bimc_monitor_mask;
   logic [`CR_HUF_COMP_C_BIMC_PARITY_ERROR_CNT_T_DECL] o_bimc_parity_error_cnt;
   logic [`CR_HUF_COMP_C_BIMC_POLLRSP2_T_DECL] o_bimc_pollrsp2;
   logic [`CR_HUF_COMP_C_BIMC_RXCMD2_T_DECL] o_bimc_rxcmd2;
   logic [`CR_HUF_COMP_C_BIMC_RXRSP2_T_DECL] o_bimc_rxrsp2;
   logic		rd_stb;			
   logic		ro_uncorrectable_ecc_error_0;
   logic		ro_uncorrectable_ecc_error_1;
   logic		ro_uncorrectable_ecc_error_2;
   logic		ro_uncorrectable_ecc_error_3;
   logic		ro_uncorrectable_ecc_error_4;
   logic		wr_stb;			
   

   logic [`CR_HUF_COMP_DECL]       reg_addr;		
   logic [`CR_HUF_COMP_DECL]       locl_addr;
   logic [`N_RBUS_DATA_BITS-1:0]   locl_wr_data;


   
   logic		he_long_bl_ism_bimc_idat;            
   logic		he_long_bl_ism_bimc_isync;           
   logic		he_long_bl_ism_bimc_odat;            
   logic		he_long_bl_ism_bimc_osync;
   logic		he_long_bl_ism_bimc_rst_n;
   
   logic		he_short_bl_ism_bimc_idat;           
   logic		he_short_bl_ism_bimc_isync;          
   logic		he_short_bl_ism_bimc_odat;           
   logic		he_short_bl_ism_bimc_osync;
   logic		he_short_bl_ism_bimc_rst_n;
         
   logic		he_st_short_bl_ism_bimc_idat;        
   logic		he_st_short_bl_ism_bimc_isync;       
   logic		he_st_short_bl_ism_bimc_odat;        
   logic		he_st_short_bl_ism_bimc_osync; 
   logic		he_st_short_bl_ism_bimc_rst_n;
   
   logic		he_st_long_bl_ism_bimc_idat; 
   logic		he_st_long_bl_ism_bimc_isync;
   logic		he_st_long_bl_ism_bimc_odat; 
   logic		he_st_long_bl_ism_bimc_osync;
   logic		he_st_long_bl_ism_bimc_rst_n;
   
   logic		im_bimc_idat;		             
   logic		im_bimc_isync;		             
   logic		im_bimc_odat;		             
   logic		im_bimc_osync;
   logic		im_bimc_rst_n;	

   logic 		bimc_idat;		             
   logic 		bimc_isync;		             
   logic 		bimc_odat;		             
   logic 		bimc_osync;
   logic 		bimc_rst_n;
   logic [`N_RBUS_ADDR_BITS-1:0] cfg_start_addr_reg;
   logic [`N_RBUS_ADDR_BITS-1:0] cfg_end_addr_reg;
   
   spare_t                         spare;    
   
   out_t                  out_ia_wdata;
   out_ia_config_t        out_ia_config;
   out_t                  out_ia_rdata;
   out_ia_status_t        out_ia_status;
   out_ia_capability_t    out_ia_capability;
   
   out_im_status_t         out_im_status;
   out_im_config_t         out_im_config;

   sh_bl_t                  sh_bl_ia_wdata;
   sh_bl_ia_config_t        sh_bl_ia_config;
   sh_bl_t                  sh_bl_ia_rdata;
   sh_bl_ia_status_t        sh_bl_ia_status;
   sh_bl_ia_capability_t    sh_bl_ia_capability;
   
   sh_bl_im_status_t        sh_bl_im_status;
   sh_bl_im_config_t        sh_bl_im_config;

   lng_bl_t                  lng_bl_ia_wdata;
   lng_bl_ia_config_t        lng_bl_ia_config;
   lng_bl_t                  lng_bl_ia_rdata;
   lng_bl_ia_status_t        lng_bl_ia_status;
   lng_bl_ia_capability_t    lng_bl_ia_capability;
   
   lng_bl_im_status_t        lng_bl_im_status;
   lng_bl_im_config_t        lng_bl_im_config;

   st_sh_bl_t                st_sh_bl_ia_wdata;
   st_sh_bl_ia_config_t      st_sh_bl_ia_config;
   st_sh_bl_t                st_sh_bl_ia_rdata;
   st_sh_bl_ia_status_t      st_sh_bl_ia_status;
   st_sh_bl_ia_capability_t  st_sh_bl_ia_capability;
   
   st_sh_bl_im_status_t      st_sh_bl_im_status;
   st_sh_bl_im_config_t      st_sh_bl_im_config;

   st_lng_bl_t               st_lng_bl_ia_wdata;
   st_lng_bl_ia_config_t     st_lng_bl_ia_config;
   st_lng_bl_t               st_lng_bl_ia_rdata;
   st_lng_bl_ia_status_t     st_lng_bl_ia_status;
   st_lng_bl_ia_capability_t st_lng_bl_ia_capability;
   
   st_lng_bl_im_status_t     st_lng_bl_im_status;
   st_lng_bl_im_config_t     st_lng_bl_im_config;
   
   im_din_t                       im_din;
   logic                          im_vld;

   short_rebuild_limit_counter_t     short_rebuild_limit_count_a [1];
   long_rebuild_limit_counter_t      long_rebuild_limit_count_a [1];
   short_st_rebuild_limit_counter_t  short_st_rebuild_limit_count_a [1];
   long_st_rebuild_limit_counter_t   long_st_rebuild_limit_count_a [1];
   short_rebuild_counter_t           short_rebuild_count_a [1];
   long_rebuild_counter_t            long_rebuild_count_a [1];
   short_st_rebuild_counter_t        short_st_rebuild_count_a [1];
   long_st_rebuild_counter_t         long_st_rebuild_count_a [1];
   
   
   
   

   
   revid_t revid_wire;
     
   CR_TIE_CELL revid_wire_0 (.ob(revid_wire.f.revid[0]), .o());
   CR_TIE_CELL revid_wire_1 (.ob(revid_wire.f.revid[1]), .o());
   CR_TIE_CELL revid_wire_2 (.ob(revid_wire.f.revid[2]), .o());
   CR_TIE_CELL revid_wire_3 (.ob(revid_wire.f.revid[3]), .o());
   CR_TIE_CELL revid_wire_4 (.ob(revid_wire.f.revid[4]), .o());
   CR_TIE_CELL revid_wire_5 (.ob(revid_wire.f.revid[5]), .o());
   CR_TIE_CELL revid_wire_6 (.ob(revid_wire.f.revid[6]), .o());
   CR_TIE_CELL revid_wire_7 (.ob(revid_wire.f.revid[7]), .o());
   
   
   always_comb begin
      
      im_din.desc.eob             = huf_comp_ob_out_pre.tlast; 
      im_din.desc.bytes_vld       = huf_comp_ob_out_pre.tstrb; 
      im_din.desc.im_meta[14]     = huf_comp_ob_out_pre.tid;
      im_din.desc.im_meta[22:15]  = 8'd0;
      im_din.desc.im_meta[13:6]   = huf_comp_ob_out_pre.tuser;
      im_din.desc.im_meta[5:0]    = 6'd0;                     
      im_din.data                 = huf_comp_ob_out_pre.tdata;

      
      he_long_bl_ism_bimc_rst_n      = bimc_rst_n;
      he_short_bl_ism_bimc_rst_n     = bimc_rst_n;
      he_st_long_bl_ism_bimc_rst_n   = bimc_rst_n;
      he_st_short_bl_ism_bimc_rst_n  = bimc_rst_n;
      im_bimc_rst_n                  = bimc_rst_n;
      core_bimc_rst_n                = bimc_rst_n;
      	
      he_long_bl_ism_bimc_idat       = core_bimc_odat;            
      he_long_bl_ism_bimc_isync      = core_bimc_osync; 
      
      he_short_bl_ism_bimc_idat      = he_long_bl_ism_bimc_odat;           
      he_short_bl_ism_bimc_isync     = he_long_bl_ism_bimc_osync;
      
      he_st_short_bl_ism_bimc_idat   = he_short_bl_ism_bimc_odat;        
      he_st_short_bl_ism_bimc_isync  = he_short_bl_ism_bimc_osync;
      
      he_st_long_bl_ism_bimc_idat    = he_st_short_bl_ism_bimc_odat; 
      he_st_long_bl_ism_bimc_isync   = he_st_short_bl_ism_bimc_osync;
      
      im_bimc_idat                   = he_st_long_bl_ism_bimc_odat;		             
      im_bimc_isync                  = he_st_long_bl_ism_bimc_osync;

      bimc_idat                      = im_bimc_odat;
      bimc_isync                     = im_bimc_osync;

      core_bimc_idat                 = bimc_odat;
      core_bimc_isync                = bimc_osync; 

      ism_ecc_error                  = ro_uncorrectable_ecc_error_0 |
				       ro_uncorrectable_ecc_error_1 |
				       ro_uncorrectable_ecc_error_2 |
				       ro_uncorrectable_ecc_error_3 |
				       ro_uncorrectable_ecc_error_4 ;
      
      
   end 


   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
	 huf_comp_int               <= 0;
	 cfg_start_addr_reg         <= 0;
	 cfg_end_addr_reg           <= 0;
      end
      else begin
	 huf_comp_int.tlvp_err      <= sm_bip2_reg | sa_bip2_reg;
	 huf_comp_int.uncor_ecc_err <= ecc_error_reg;
	 huf_comp_int.bimc_int      <= bimc_interrupt;
	 cfg_start_addr_reg         <= cfg_start_addr;
	 cfg_end_addr_reg           <= cfg_end_addr;
      end
   end
   
   
   bimc_master bimc_master
     (
      
      .bimc_ecc_error			(bimc_ecc_error),
      .bimc_interrupt			(bimc_interrupt),
      .bimc_odat			(bimc_odat),
      .bimc_rst_n			(bimc_rst_n),
      .bimc_osync			(bimc_osync),
      .i_bimc_monitor			(i_bimc_monitor[`CR_C_BIMC_MONITOR_T_DECL]),
      .i_bimc_ecc_uncorrectable_error_cnt(i_bimc_ecc_uncorrectable_error_cnt[`CR_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]),
      .i_bimc_ecc_correctable_error_cnt	(i_bimc_ecc_correctable_error_cnt[`CR_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]),
      .i_bimc_parity_error_cnt		(i_bimc_parity_error_cnt[`CR_C_BIMC_PARITY_ERROR_CNT_T_DECL]),
      .i_bimc_global_config		(i_bimc_global_config[`CR_C_BIMC_GLOBAL_CONFIG_T_DECL]),
      .i_bimc_memid			(i_bimc_memid[`CR_C_BIMC_MEMID_T_DECL]),
      .i_bimc_eccpar_debug		(i_bimc_eccpar_debug[`CR_C_BIMC_ECCPAR_DEBUG_T_DECL]),
      .i_bimc_cmd2			(i_bimc_cmd2[`CR_C_BIMC_CMD2_T_DECL]),
      .i_bimc_rxcmd2			(i_bimc_rxcmd2[`CR_C_BIMC_RXCMD2_T_DECL]),
      .i_bimc_rxcmd1			(i_bimc_rxcmd1[`CR_C_BIMC_RXCMD1_T_DECL]),
      .i_bimc_rxcmd0			(i_bimc_rxcmd0[`CR_C_BIMC_RXCMD0_T_DECL]),
      .i_bimc_rxrsp2			(i_bimc_rxrsp2[`CR_C_BIMC_RXRSP2_T_DECL]),
      .i_bimc_rxrsp1			(i_bimc_rxrsp1[`CR_C_BIMC_RXRSP1_T_DECL]),
      .i_bimc_rxrsp0			(i_bimc_rxrsp0[`CR_C_BIMC_RXRSP0_T_DECL]),
      .i_bimc_pollrsp2			(i_bimc_pollrsp2[`CR_C_BIMC_POLLRSP2_T_DECL]),
      .i_bimc_pollrsp1			(i_bimc_pollrsp1[`CR_C_BIMC_POLLRSP1_T_DECL]),
      .i_bimc_pollrsp0			(i_bimc_pollrsp0[`CR_C_BIMC_POLLRSP0_T_DECL]),
      .i_bimc_dbgcmd2			(i_bimc_dbgcmd2[`CR_C_BIMC_DBGCMD2_T_DECL]),
      .i_bimc_dbgcmd1			(i_bimc_dbgcmd1[`CR_C_BIMC_DBGCMD1_T_DECL]),
      .i_bimc_dbgcmd0			(i_bimc_dbgcmd0[`CR_C_BIMC_DBGCMD0_T_DECL]),
      
      .clk				(clk),
      .rst_n				(rst_n),
      .bimc_idat			(bimc_idat),
      .bimc_isync			(bimc_isync),
      .o_bimc_monitor_mask		(o_bimc_monitor_mask[`CR_C_BIMC_MONITOR_MASK_T_DECL]),
      .o_bimc_ecc_uncorrectable_error_cnt(o_bimc_ecc_uncorrectable_error_cnt[`CR_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]),
      .o_bimc_ecc_correctable_error_cnt	(o_bimc_ecc_correctable_error_cnt[`CR_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]),
      .o_bimc_parity_error_cnt		(o_bimc_parity_error_cnt[`CR_C_BIMC_PARITY_ERROR_CNT_T_DECL]),
      .o_bimc_global_config		(o_bimc_global_config[`CR_C_BIMC_GLOBAL_CONFIG_T_DECL]),
      .o_bimc_eccpar_debug		(o_bimc_eccpar_debug[`CR_C_BIMC_ECCPAR_DEBUG_T_DECL]),
      .o_bimc_cmd2			(o_bimc_cmd2[`CR_C_BIMC_CMD2_T_DECL]),
      .o_bimc_cmd1			(o_bimc_cmd1[`CR_C_BIMC_CMD1_T_DECL]),
      .o_bimc_cmd0			(o_bimc_cmd0[`CR_C_BIMC_CMD0_T_DECL]),
      .o_bimc_rxcmd2			(o_bimc_rxcmd2[`CR_C_BIMC_RXCMD2_T_DECL]),
      .o_bimc_rxrsp2			(o_bimc_rxrsp2[`CR_C_BIMC_RXRSP2_T_DECL]),
      .o_bimc_pollrsp2			(o_bimc_pollrsp2[`CR_C_BIMC_POLLRSP2_T_DECL]),
      .o_bimc_dbgcmd2			(o_bimc_dbgcmd2[`CR_C_BIMC_DBGCMD2_T_DECL]));
   
   
   
   nx_interface_monitor_pipe nx_interface_monitor_pipe 
     (
      
      .ob_in_mod    (huf_comp_ob_in_mod), 
      .ob_out       (huf_comp_ob_out), 
      .im_vld       (im_vld),
      
      .clk          (clk),
      .rst_n        (rst_n),
      .ob_out_pre   (huf_comp_ob_out_pre), 
      .ob_in        (huf_comp_ob_in),  
      .im_rdy       (im_rdy)
      );
   
   genvar              i;
   
   
   
   cr_huf_comp_regs u_cr_huf_comp_regs (
					
					.o_rd_data	(locl_rd_data[31:0]), 
					.o_ack		(locl_ack),	 
					.o_err_ack	(locl_err_ack),	 
					.o_spare_config	(spare),	 
					.o_prefix_adj	(sw_prefix_adj[`CR_HUF_COMP_C_HENC_SCH_UPDATE_PREFIX_ADJ_T_DECL]), 
					.o_henc_huff_win_size_in_entries(sw_henc_huff_win_size_in_entries[`CR_HUF_COMP_C_HENC_HUFF_WIN_SIZE_IN_ENTRIES_T_DECL]), 
					.o_henc_xp9_first_blk_thrsh(sw_henc_xp9_first_blk_thrsh[`CR_HUF_COMP_C_HENC_EX9_FIRST_BLK_THRESH_T_DECL]), 
					.o_short_ht_config(sw_short_ht_config), 
					.o_long_ht_config(sw_long_ht_config), 
					.o_st_short_ht_config(sw_st_short_ht_config), 
					.o_st_long_ht_config(sw_st_long_ht_config), 
					.o_xp9_disable_modes(sw_xp9_disable_modes), 
					.o_xp10_disable_modes(sw_xp10_disable_modes), 
					.o_deflate_disable_modes(sw_deflate_disable_modes), 
					.o_force_block_stall(),		 
					.o_disable_sub_pipe(sw_disable_sub_pipe), 
					.o_debug_control(sw_debug_control), 
					.o_out_ia_wdata_part0(out_ia_wdata.r.part0), 
					.o_out_ia_wdata_part1(out_ia_wdata.r.part1), 
					.o_out_ia_wdata_part2(out_ia_wdata.r.part2), 
					.o_out_ia_config(out_ia_config), 
					.o_out_im_config(out_im_config), 
					.o_out_im_read_done(),		 
					.o_sh_bl_ia_wdata_part0(sh_bl_ia_wdata.r.part0), 
					.o_sh_bl_ia_wdata_part1(sh_bl_ia_wdata.r.part1), 
					.o_sh_bl_ia_wdata_part2(sh_bl_ia_wdata.r.part2), 
					.o_sh_bl_ia_config(sh_bl_ia_config), 
					.o_sh_bl_im_config(sh_bl_im_config), 
					.o_sh_bl_im_read_done(),	 
					.o_lng_bl_ia_wdata_part0(lng_bl_ia_wdata.r.part0), 
					.o_lng_bl_ia_wdata_part1(lng_bl_ia_wdata.r.part1), 
					.o_lng_bl_ia_wdata_part2(lng_bl_ia_wdata.r.part2), 
					.o_lng_bl_ia_config(lng_bl_ia_config), 
					.o_lng_bl_im_config(lng_bl_im_config), 
					.o_lng_bl_im_read_done(),	 
					.o_st_sh_bl_ia_wdata_part0(st_sh_bl_ia_wdata.r.part0), 
					.o_st_sh_bl_ia_wdata_part1(st_sh_bl_ia_wdata.r.part1), 
					.o_st_sh_bl_ia_wdata_part2(st_sh_bl_ia_wdata.r.part2), 
					.o_st_sh_bl_ia_config(st_sh_bl_ia_config), 
					.o_st_sh_bl_im_config(st_sh_bl_im_config), 
					.o_st_sh_bl_im_read_done(),	 
					.o_st_lng_bl_ia_wdata_part0(st_lng_bl_ia_wdata.r.part0), 
					.o_st_lng_bl_ia_wdata_part1(st_lng_bl_ia_wdata.r.part1), 
					.o_st_lng_bl_ia_wdata_part2(st_lng_bl_ia_wdata.r.part2), 
					.o_st_lng_bl_ia_config(st_lng_bl_ia_config), 
					.o_st_lng_bl_im_config(st_lng_bl_im_config), 
					.o_st_lng_bl_im_read_done(),	 
					.o_sm_in_tlv_parse_action_0(sw_sm_in_tlv_parse_action_0[`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_31_0_T_DECL]), 
					.o_sm_in_tlv_parse_action_1(sw_sm_in_tlv_parse_action_1[`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_63_32_T_DECL]), 
					.o_sa_out_tlv_parse_action_0(sw_sa_out_tlv_parse_action_0[`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_31_0_T_DECL]), 
					.o_sa_out_tlv_parse_action_1(sw_sa_out_tlv_parse_action_1[`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_63_32_T_DECL]), 
					.o_bimc_monitor_mask(o_bimc_monitor_mask[`CR_HUF_COMP_C_BIMC_MONITOR_MASK_T_DECL]),
					.o_bimc_ecc_uncorrectable_error_cnt(o_bimc_ecc_uncorrectable_error_cnt[`CR_HUF_COMP_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]),
					.o_bimc_ecc_correctable_error_cnt(o_bimc_ecc_correctable_error_cnt[`CR_HUF_COMP_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]),
					.o_bimc_parity_error_cnt(o_bimc_parity_error_cnt[`CR_HUF_COMP_C_BIMC_PARITY_ERROR_CNT_T_DECL]),
					.o_bimc_global_config(o_bimc_global_config[`CR_HUF_COMP_C_BIMC_GLOBAL_CONFIG_T_DECL]),
					.o_bimc_eccpar_debug(o_bimc_eccpar_debug[`CR_HUF_COMP_C_BIMC_ECCPAR_DEBUG_T_DECL]),
					.o_bimc_cmd2	(o_bimc_cmd2[`CR_HUF_COMP_C_BIMC_CMD2_T_DECL]),
					.o_bimc_cmd1	(o_bimc_cmd1[`CR_HUF_COMP_C_BIMC_CMD1_T_DECL]),
					.o_bimc_cmd0	(o_bimc_cmd0[`CR_HUF_COMP_C_BIMC_CMD0_T_DECL]),
					.o_bimc_rxcmd2	(o_bimc_rxcmd2[`CR_HUF_COMP_C_BIMC_RXCMD2_T_DECL]),
					.o_bimc_rxrsp2	(o_bimc_rxrsp2[`CR_HUF_COMP_C_BIMC_RXRSP2_T_DECL]),
					.o_bimc_pollrsp2(o_bimc_pollrsp2[`CR_HUF_COMP_C_BIMC_POLLRSP2_T_DECL]),
					.o_bimc_dbgcmd2	(o_bimc_dbgcmd2[`CR_HUF_COMP_C_BIMC_DBGCMD2_T_DECL]),
					.o_gzip_os	(sw_gzip_os[`CR_HUF_COMP_C_HENC_GZIP_OS_T_DECL]), 
					.o_reg_written	(wr_stb),	 
					.o_reg_read	(rd_stb),	 
					.o_reg_wr_data	(),		 
					.o_reg_addr	(reg_addr),	 
					
					.clk		(clk),
					.i_reset_	(rst_n),	 
					.i_sw_init	(1'd0),		 
					.i_addr		(locl_addr),	 
					.i_wr_strb	(locl_wr_strb),	 
					.i_wr_data	(locl_wr_data),	 
					.i_rd_strb	(locl_rd_strb),	 
					.i_revision_config(revid_wire),	 
					.i_spare_config	(spare),	 
					.i_out_ia_capability(out_ia_capability), 
					.i_out_ia_status(out_ia_status), 
					.i_out_ia_rdata_part0(out_ia_rdata.r.part0), 
					.i_out_ia_rdata_part1(out_ia_rdata.r.part1), 
					.i_out_ia_rdata_part2(out_ia_rdata.r.part2), 
					.i_out_im_status(out_im_status), 
					.i_out_im_read_done(2'd0),	 
					.i_sh_bl_ia_capability(sh_bl_ia_capability), 
					.i_sh_bl_ia_status(sh_bl_ia_status), 
					.i_sh_bl_ia_rdata_part0(sh_bl_ia_rdata.r.part0), 
					.i_sh_bl_ia_rdata_part1(sh_bl_ia_rdata.r.part1), 
					.i_sh_bl_ia_rdata_part2(sh_bl_ia_rdata.r.part2), 
					.i_sh_bl_im_status(sh_bl_im_status), 
					.i_sh_bl_im_read_done(2'd0),	 
					.i_lng_bl_ia_capability(lng_bl_ia_capability), 
					.i_lng_bl_ia_status(lng_bl_ia_status), 
					.i_lng_bl_ia_rdata_part0(lng_bl_ia_rdata.r.part0), 
					.i_lng_bl_ia_rdata_part1(lng_bl_ia_rdata.r.part1), 
					.i_lng_bl_ia_rdata_part2(lng_bl_ia_rdata.r.part2), 
					.i_lng_bl_im_status(lng_bl_im_status), 
					.i_lng_bl_im_read_done(2'd0),	 
					.i_st_sh_bl_ia_capability(st_sh_bl_ia_capability), 
					.i_st_sh_bl_ia_status(st_sh_bl_ia_status), 
					.i_st_sh_bl_ia_rdata_part0(st_sh_bl_ia_rdata.r.part0), 
					.i_st_sh_bl_ia_rdata_part1(st_sh_bl_ia_rdata.r.part1), 
					.i_st_sh_bl_ia_rdata_part2(st_sh_bl_ia_rdata.r.part2), 
					.i_st_sh_bl_im_status(st_sh_bl_im_status), 
					.i_st_sh_bl_im_read_done(2'd0),	 
					.i_st_lng_bl_ia_capability(st_lng_bl_ia_capability), 
					.i_st_lng_bl_ia_status(st_lng_bl_ia_status), 
					.i_st_lng_bl_ia_rdata_part0(st_lng_bl_ia_rdata.r.part0), 
					.i_st_lng_bl_ia_rdata_part1(st_lng_bl_ia_rdata.r.part1), 
					.i_st_lng_bl_ia_rdata_part2(st_lng_bl_ia_rdata.r.part2), 
					.i_st_lng_bl_im_status(st_lng_bl_im_status), 
					.i_st_lng_bl_im_read_done(2'd0), 
					.i_short_rebuild_limit_count_a(short_rebuild_limit_count_a[0]), 
					.i_long_rebuild_limit_count_a(long_rebuild_limit_count_a[0]), 
					.i_short_st_rebuild_limit_count_a(short_st_rebuild_limit_count_a[0]), 
					.i_long_st_rebuild_limit_count_a(long_st_rebuild_limit_count_a[0]), 
					.i_short_rebuild_count_a(short_rebuild_count_a[0]), 
					.i_long_rebuild_count_a(long_rebuild_count_a[0]), 
					.i_short_st_rebuild_count_a(short_st_rebuild_count_a[0]), 
					.i_long_st_rebuild_count_a(long_st_rebuild_count_a[0]), 
					.i_bimc_monitor	(i_bimc_monitor), 
					.i_bimc_ecc_uncorrectable_error_cnt(i_bimc_ecc_uncorrectable_error_cnt), 
					.i_bimc_ecc_correctable_error_cnt(i_bimc_ecc_correctable_error_cnt), 
					.i_bimc_parity_error_cnt(i_bimc_parity_error_cnt), 
					.i_bimc_global_config(i_bimc_global_config), 
					.i_bimc_memid	(i_bimc_memid),	 
					.i_bimc_eccpar_debug(i_bimc_eccpar_debug), 
					.i_bimc_cmd2	(i_bimc_cmd2),	 
					.i_bimc_rxcmd2	(i_bimc_rxcmd2), 
					.i_bimc_rxcmd1	(i_bimc_rxcmd1), 
					.i_bimc_rxcmd0	(i_bimc_rxcmd0), 
					.i_bimc_rxrsp2	(i_bimc_rxrsp2), 
					.i_bimc_rxrsp1	(i_bimc_rxrsp1), 
					.i_bimc_rxrsp0	(i_bimc_rxrsp0), 
					.i_bimc_pollrsp2(i_bimc_pollrsp2), 
					.i_bimc_pollrsp1(i_bimc_pollrsp1), 
					.i_bimc_pollrsp0(i_bimc_pollrsp0), 
					.i_bimc_dbgcmd2	(i_bimc_dbgcmd2), 
					.i_bimc_dbgcmd1	(i_bimc_dbgcmd1), 
					.i_bimc_dbgcmd0	(i_bimc_dbgcmd0)); 

   
   
   
   nx_rbus_ring 
     #(.N_RBUS_ADDR_BITS (`N_RBUS_ADDR_BITS),             
       .N_LOCL_ADDR_BITS (`CR_HUF_COMP_WIDTH),           
       .N_RBUS_DATA_BITS (`N_RBUS_DATA_BITS))             
   u_nx_rbus_ring 
     (
      
      .rbus_addr_o			(rbus_ring_o.addr),	 
      .rbus_wr_strb_o			(rbus_ring_o.wr_strb),	 
      .rbus_wr_data_o			(rbus_ring_o.wr_data),	 
      .rbus_rd_strb_o			(rbus_ring_o.rd_strb),	 
      .locl_addr_o			(locl_addr),		 
      .locl_wr_strb_o			(locl_wr_strb),		 
      .locl_wr_data_o			(locl_wr_data),		 
      .locl_rd_strb_o			(locl_rd_strb),		 
      .rbus_rd_data_o			(rbus_ring_o.rd_data),	 
      .rbus_ack_o			(rbus_ring_o.ack),	 
      .rbus_err_ack_o			(rbus_ring_o.err_ack),	 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .cfg_start_addr			(cfg_start_addr_reg),	 
      .cfg_end_addr			(cfg_end_addr_reg),	 
      .rbus_addr_i			(rbus_ring_i.addr),	 
      .rbus_wr_strb_i			(rbus_ring_i.wr_strb),	 
      .rbus_wr_data_i			(rbus_ring_i.wr_data),	 
      .rbus_rd_strb_i			(rbus_ring_i.rd_strb),	 
      .rbus_rd_data_i			(rbus_ring_i.rd_data),	 
      .rbus_ack_i			(rbus_ring_i.ack),	 
      .rbus_err_ack_i			(rbus_ring_i.err_ack),	 
      .locl_rd_data_i			(locl_rd_data),		 
      .locl_ack_i			(locl_ack),		 
      .locl_err_ack_i			(locl_err_ack));		 

   
   
   
   nx_interface_monitor 
     #(.IN_FLIGHT       (5),                                  
       .CMND_ADDRESS    (`CR_HUF_COMP_OUT_IA_CONFIG),        
       .STAT_ADDRESS    (`CR_HUF_COMP_OUT_IA_STATUS),        
       .IMRD_ADDRESS    (`CR_HUF_COMP_OUT_IM_READ_DONE),     
       .N_REG_ADDR_BITS (`CR_HUF_COMP_WIDTH),                
       .N_DATA_BITS     (`N_AXI_IM_WIDTH),                        
       .N_ENTRIES       (`N_AXI_IM_ENTRIES),                      
       .SPECIALIZE      (1))                                  
   u_nx_interface_monitor 
     (
      
      .stat_code			({out_ia_status.f.code}), 
      .stat_datawords			(out_ia_status.f.datawords), 
      .stat_addr			(out_ia_status.f.addr),	 
      .capability_lst			(out_ia_capability.r.part0[15:0]), 
      .capability_type			(out_ia_capability.f.mem_type), 
      .rd_dat				(out_ia_rdata),		 
      .bimc_odat			(im_bimc_odat),		 
      .bimc_osync			(im_bimc_osync),	 
      .ro_uncorrectable_ecc_error	(ro_uncorrectable_ecc_error_0), 
      .im_rdy				(im_rdy),
      .im_available			(im_available_huf),	 
      .im_status			(out_im_status),	 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .reg_addr				(reg_addr),		 
      .cmnd_op				(out_ia_config.f.op),	 
      .cmnd_addr			(out_ia_config.f.addr),	 
      .wr_stb				(wr_stb),
      .wr_dat				(out_ia_wdata),		 
      .ovstb				(ovstb),
      .lvm				(lvm),
      .mlvm				(mlvm),
      .mrdten				(1'd0),			 
      .bimc_rst_n			(im_bimc_rst_n),	 
      .bimc_isync			(im_bimc_isync),	 
      .bimc_idat			(im_bimc_idat),		 
      .im_din				(im_din),		 
      .im_vld				(im_vld),
      .im_consumed			(im_consumed_huf),	 
      .im_config			(out_im_config));	 

   
   
   
   nx_interface_monitor 
     #(.IN_FLIGHT       (4),                                 
       .IN_FLIGHT_USE   (1),
       .CMND_ADDRESS    (`CR_HUF_COMP_SH_BL_IA_CONFIG),      
       .STAT_ADDRESS    (`CR_HUF_COMP_SH_BL_IA_STATUS),        
       .IMRD_ADDRESS    (`CR_HUF_COMP_SH_BL_IM_READ_DONE),     
       .N_REG_ADDR_BITS (`CR_HUF_COMP_WIDTH),                
       .N_DATA_BITS     (96),                                
       .N_ENTRIES       (`ROUND_UP_DIV(`CREOLE_HC_SHORT_NUM_MAX_SYM_USED,8)*2), 
       .SPECIALIZE      (1))                                 
   u_he_short_bl_ism
     (
      
      .stat_code			({sh_bl_ia_status.f.code}), 
      .stat_datawords			(sh_bl_ia_status.f.datawords), 
      .stat_addr			(sh_bl_ia_status.f.addr), 
      .capability_lst			(sh_bl_ia_capability.r.part0[15:0]), 
      .capability_type			(sh_bl_ia_capability.f.mem_type), 
      .rd_dat				(sh_bl_ia_rdata),	 
      .bimc_odat			(he_short_bl_ism_bimc_odat), 
      .bimc_osync			(he_short_bl_ism_bimc_osync), 
      .ro_uncorrectable_ecc_error	(ro_uncorrectable_ecc_error_1), 
      .im_rdy				(short_ism_rdy),	 
      .im_available			(im_available_he_sh),	 
      .im_status			(sh_bl_im_status),	 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .reg_addr				(reg_addr),		 
      .cmnd_op				(sh_bl_ia_config.f.op),	 
      .cmnd_addr			(sh_bl_ia_config.f.addr), 
      .wr_stb				(wr_stb),
      .wr_dat				(sh_bl_ia_wdata),	 
      .ovstb				(ovstb),
      .lvm				(lvm),
      .mlvm				(mlvm),
      .mrdten				(1'd0),			 
      .bimc_rst_n			(he_short_bl_ism_bimc_rst_n), 
      .bimc_isync			(he_short_bl_ism_bimc_isync), 
      .bimc_idat			(he_short_bl_ism_bimc_idat), 
      .im_din				(short_bl_ism_data),	 
      .im_vld				(short_bl_ism_vld),	 
      .im_consumed			(im_consumed_he_sh),	 
      .im_config			(sh_bl_im_config));	 
        

   
   

   
   nx_interface_monitor 
     #(.IN_FLIGHT       (4),                                 
       .IN_FLIGHT_USE   (1),
       .CMND_ADDRESS    (`CR_HUF_COMP_LNG_BL_IA_CONFIG),      
       .STAT_ADDRESS    (`CR_HUF_COMP_LNG_BL_IA_STATUS),        
       .IMRD_ADDRESS    (`CR_HUF_COMP_LNG_BL_IM_READ_DONE),     
       .N_REG_ADDR_BITS (`CR_HUF_COMP_WIDTH),                
       .N_DATA_BITS     (96),                                
       .N_ENTRIES       (`ROUND_UP_DIV(`CREOLE_HC_LONG_NUM_MAX_SYM_USED,8)*2), 
       .SPECIALIZE      (0))                                 
   u_he_long_bl_ism
     (
      
      .stat_code			({lng_bl_ia_status.f.code}), 
      .stat_datawords			(lng_bl_ia_status.f.datawords), 
      .stat_addr			(lng_bl_ia_status.f.addr), 
      .capability_lst			(lng_bl_ia_capability.r.part0[15:0]), 
      .capability_type			(lng_bl_ia_capability.f.mem_type), 
      .rd_dat				(lng_bl_ia_rdata),	 
      .bimc_odat			(he_long_bl_ism_bimc_odat), 
      .bimc_osync			(he_long_bl_ism_bimc_osync), 
      .ro_uncorrectable_ecc_error	(ro_uncorrectable_ecc_error_2), 
      .im_rdy				(long_ism_rdy),		 
      .im_available			(im_available_he_lng),	 
      .im_status			(lng_bl_im_status),	 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .reg_addr				(reg_addr),		 
      .cmnd_op				(lng_bl_ia_config.f.op), 
      .cmnd_addr			(lng_bl_ia_config.f.addr), 
      .wr_stb				(wr_stb),
      .wr_dat				(lng_bl_ia_wdata),	 
      .ovstb				(ovstb),
      .lvm				(lvm),
      .mlvm				(mlvm),
      .mrdten				(1'd0),			 
      .bimc_rst_n			(he_long_bl_ism_bimc_rst_n), 
      .bimc_isync			(he_long_bl_ism_bimc_isync), 
      .bimc_idat			(he_long_bl_ism_bimc_idat), 
      .im_din				(long_bl_ism_data),	 
      .im_vld				(long_bl_ism_vld),	 
      .im_consumed			(im_consumed_he_lng),	 
      .im_config			(lng_bl_im_config));	 


   
   
   nx_interface_monitor 
     #(.IN_FLIGHT       (4),                                 
       .IN_FLIGHT_USE   (1),
       .CMND_ADDRESS    (`CR_HUF_COMP_ST_SH_BL_IA_CONFIG),      
       .STAT_ADDRESS    (`CR_HUF_COMP_ST_SH_BL_IA_STATUS),        
       .IMRD_ADDRESS    (`CR_HUF_COMP_ST_SH_BL_IM_READ_DONE),     
       .N_REG_ADDR_BITS (`CR_HUF_COMP_WIDTH),                
       .N_DATA_BITS     (96),                                
       .N_ENTRIES       (`ROUND_UP_DIV(`CREOLE_HC_ST_SYMB_DEPTH,8)*2), 
       .SPECIALIZE      (0))                                 
   u_he_st_short_bl_ism
     (
      
      .stat_code			({st_sh_bl_ia_status.f.code}), 
      .stat_datawords			(st_sh_bl_ia_status.f.datawords), 
      .stat_addr			(st_sh_bl_ia_status.f.addr), 
      .capability_lst			(st_sh_bl_ia_capability.r.part0[15:0]), 
      .capability_type			(st_sh_bl_ia_capability.f.mem_type), 
      .rd_dat				(st_sh_bl_ia_rdata),	 
      .bimc_odat			(he_st_short_bl_ism_bimc_odat), 
      .bimc_osync			(he_st_short_bl_ism_bimc_osync), 
      .ro_uncorrectable_ecc_error	(ro_uncorrectable_ecc_error_3), 
      .im_rdy				(st_short_ism_rdy),	 
      .im_available			(im_available_he_st_sh), 
      .im_status			(st_sh_bl_im_status),	 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .reg_addr				(reg_addr),		 
      .cmnd_op				(st_sh_bl_ia_config.f.op), 
      .cmnd_addr			(st_sh_bl_ia_config.f.addr), 
      .wr_stb				(wr_stb),
      .wr_dat				(st_sh_bl_ia_wdata),	 
      .ovstb				(ovstb),
      .lvm				(lvm),
      .mlvm				(mlvm),
      .mrdten				(1'd0),			 
      .bimc_rst_n			(he_st_short_bl_ism_bimc_rst_n), 
      .bimc_isync			(he_st_short_bl_ism_bimc_isync), 
      .bimc_idat			(he_st_short_bl_ism_bimc_idat), 
      .im_din				(st_short_bl_ism_data),	 
      .im_vld				(st_short_bl_ism_vld),	 
      .im_consumed			(im_consumed_he_st_sh),	 
      .im_config			(st_sh_bl_im_config));	 

   
   
   nx_interface_monitor 
     #(.IN_FLIGHT       (4),                                 
       .IN_FLIGHT_USE   (1),
       .CMND_ADDRESS    (`CR_HUF_COMP_ST_LNG_BL_IA_CONFIG),      
       .STAT_ADDRESS    (`CR_HUF_COMP_ST_LNG_BL_IA_STATUS),        
       .IMRD_ADDRESS    (`CR_HUF_COMP_ST_LNG_BL_IM_READ_DONE),     
       .N_REG_ADDR_BITS (`CR_HUF_COMP_WIDTH),                
       .N_DATA_BITS     (96),                                
       .N_ENTRIES       (`ROUND_UP_DIV(`CREOLE_HC_ST_SYMB_DEPTH,8)*2), 
       .SPECIALIZE      (0))                                 
   u_he_st_long_bl_ism
     (
      
      .stat_code			({st_lng_bl_ia_status.f.code}), 
      .stat_datawords			(st_lng_bl_ia_status.f.datawords), 
      .stat_addr			(st_lng_bl_ia_status.f.addr), 
      .capability_lst			(st_lng_bl_ia_capability.r.part0[15:0]), 
      .capability_type			(st_lng_bl_ia_capability.f.mem_type), 
      .rd_dat				(st_lng_bl_ia_rdata),	 
      .bimc_odat			(he_st_long_bl_ism_bimc_odat), 
      .bimc_osync			(he_st_long_bl_ism_bimc_osync), 
      .ro_uncorrectable_ecc_error	(ro_uncorrectable_ecc_error_4), 
      .im_rdy				(st_long_ism_rdy),	 
      .im_available			(im_available_he_st_lng), 
      .im_status			(st_lng_bl_im_status),	 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .reg_addr				(reg_addr),		 
      .cmnd_op				(st_lng_bl_ia_config.f.op), 
      .cmnd_addr			(st_lng_bl_ia_config.f.addr), 
      .wr_stb				(wr_stb),
      .wr_dat				(st_lng_bl_ia_wdata),	 
      .ovstb				(ovstb),
      .lvm				(lvm),
      .mlvm				(mlvm),
      .mrdten				(1'b0),			 
      .bimc_rst_n			(he_st_long_bl_ism_bimc_rst_n), 
      .bimc_isync			(he_st_long_bl_ism_bimc_isync), 
      .bimc_idat			(he_st_long_bl_ism_bimc_idat), 
      .im_din				(st_long_bl_ism_data),	 
      .im_vld				(st_long_bl_ism_vld),	 
      .im_consumed			(im_consumed_he_st_lng), 
      .im_config			(st_lng_bl_im_config));	 


   

   nx_event_counter_array
     #(
       
       .BASE_ADDRESS			(`CR_HUF_COMP_SHORT_REBUILD_LIMIT_COUNT_A), 
       .ALIGNMENT			(2),			 
       .N_ADDR_BITS			(`CR_HUF_COMP_WIDTH),	 
       .N_COUNTERS			(1),			 
       .N_COUNT_BY_BITS			(2),			 
       .N_COUNTER_BITS			(`CR_HUF_COMP_C_SHORT_REBUILD_LIMIT_COUNTER_T_WIDTH)) 
   u_short_rebuild_limit_counters
     (
      
      .counter_a			(short_rebuild_limit_count_a), 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .reg_addr				(reg_addr[`BIT_VEC((`CR_HUF_COMP_WIDTH))]),
      .counter_config			(1'b0),			 
      .rd_stb				(rd_stb),
      .wr_stb				(1'b0),			 
      .reg_data				(`CR_HUF_COMP_C_SHORT_REBUILD_LIMIT_COUNTER_T_WIDTH'd0), 
      .count_stb			(short_ht_dbg_cntr_rebuild_failed), 
      .count_by				(short_ht_dbg_cntr_rebuild_failed_cnt), 
      .count_id				(1'b0));			 

   

   nx_event_counter_array
     #(
       
       .BASE_ADDRESS			(`CR_HUF_COMP_LONG_REBUILD_LIMIT_COUNT_A), 
       .ALIGNMENT			(2),			 
       .N_ADDR_BITS			(`CR_HUF_COMP_WIDTH),	 
       .N_COUNTERS			(1),			 
       .N_COUNT_BY_BITS			(2),			 
       .N_COUNTER_BITS			(`CR_HUF_COMP_C_LONG_REBUILD_LIMIT_COUNTER_T_WIDTH)) 
   u_long_rebuild_limit_counters
     (
      
      .counter_a			(long_rebuild_limit_count_a), 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .reg_addr				(reg_addr[`BIT_VEC((`CR_HUF_COMP_WIDTH))]),
      .counter_config			(1'b0),			 
      .rd_stb				(rd_stb),
      .wr_stb				(1'b0),			 
      .reg_data				(`CR_HUF_COMP_C_LONG_REBUILD_LIMIT_COUNTER_T_WIDTH'd0), 
      .count_stb			(long_ht_dbg_cntr_rebuild_failed), 
      .count_by				(long_ht_dbg_cntr_rebuild_failed_cnt), 
      .count_id				(1'b0));			 

   

   nx_event_counter_array
     #(
       
       .BASE_ADDRESS			(`CR_HUF_COMP_SHORT_ST_REBUILD_LIMIT_COUNT_A), 
       .ALIGNMENT			(2),			 
       .N_ADDR_BITS			(`CR_HUF_COMP_WIDTH),	 
       .N_COUNTERS			(1),			 
       .N_COUNT_BY_BITS			(2),			 
       .N_COUNTER_BITS			(`CR_HUF_COMP_C_SHORT_ST_REBUILD_LIMIT_COUNTER_T_WIDTH)) 
   u_short_st_rebuild_limit_counters
     (
      
      .counter_a			(short_st_rebuild_limit_count_a), 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .reg_addr				(reg_addr[`BIT_VEC((`CR_HUF_COMP_WIDTH))]),
      .counter_config			(1'b0),			 
      .rd_stb				(rd_stb),
      .wr_stb				(1'b0),			 
      .reg_data				(`CR_HUF_COMP_C_SHORT_ST_REBUILD_LIMIT_COUNTER_T_WIDTH'd0), 
      .count_stb			(short_st_dbg_cntr_rebuild_failed), 
      .count_by				(short_st_dbg_cntr_rebuild_failed_cnt), 
      .count_id				(1'b0));			 

   

   nx_event_counter_array
     #(
       
       .BASE_ADDRESS			(`CR_HUF_COMP_LONG_ST_REBUILD_LIMIT_COUNT_A), 
       .ALIGNMENT			(2),			 
       .N_ADDR_BITS			(`CR_HUF_COMP_WIDTH),	 
       .N_COUNTERS			(1),			 
       .N_COUNT_BY_BITS			(2),			 
       .N_COUNTER_BITS			(`CR_HUF_COMP_C_LONG_ST_REBUILD_LIMIT_COUNTER_T_WIDTH)) 
   u_long_st_rebuild_limit_counters
     (
      
      .counter_a			(long_st_rebuild_limit_count_a), 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .reg_addr				(reg_addr[`BIT_VEC((`CR_HUF_COMP_WIDTH))]),
      .counter_config			(1'b0),			 
      .rd_stb				(rd_stb),
      .wr_stb				(1'b0),			 
      .reg_data				(`CR_HUF_COMP_C_LONG_ST_REBUILD_LIMIT_COUNTER_T_WIDTH'd0), 
      .count_stb			(long_st_dbg_cntr_rebuild_failed), 
      .count_by				(long_st_dbg_cntr_rebuild_failed_cnt), 
      .count_id				(1'b0));			 

   

   nx_event_counter_array
     #(
       
       .BASE_ADDRESS			(`CR_HUF_COMP_SHORT_REBUILD_COUNT_A), 
       .ALIGNMENT			(2),			 
       .N_ADDR_BITS			(`CR_HUF_COMP_WIDTH),	 
       .N_COUNTERS			(1),			 
       .N_COUNT_BY_BITS			(2),			 
       .N_COUNTER_BITS			(`CR_HUF_COMP_C_SHORT_REBUILD_COUNTER_T_WIDTH)) 
   u_short_rebuild_counters
     (
      
      .counter_a			(short_rebuild_count_a), 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .reg_addr				(reg_addr[`BIT_VEC((`CR_HUF_COMP_WIDTH))]),
      .counter_config			(1'b0),			 
      .rd_stb				(rd_stb),
      .wr_stb				(1'b0),			 
      .reg_data				(`CR_HUF_COMP_C_SHORT_REBUILD_COUNTER_T_WIDTH'd0), 
      .count_stb			(short_ht_dbg_cntr_rebuild), 
      .count_by				(short_ht_dbg_cntr_rebuild_cnt), 
      .count_id				(1'b0));			 

   
   

   nx_event_counter_array
     #(
       
       .BASE_ADDRESS			(`CR_HUF_COMP_LONG_REBUILD_COUNT_A), 
       .ALIGNMENT			(2),			 
       .N_ADDR_BITS			(`CR_HUF_COMP_WIDTH),	 
       .N_COUNTERS			(1),			 
       .N_COUNT_BY_BITS			(2),			 
       .N_COUNTER_BITS			(`CR_HUF_COMP_C_LONG_REBUILD_COUNTER_T_WIDTH)) 
   u_long_rebuild_counters
     (
      
      .counter_a			(long_rebuild_count_a),	 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .reg_addr				(reg_addr[`BIT_VEC((`CR_HUF_COMP_WIDTH))]),
      .counter_config			(1'b0),			 
      .rd_stb				(rd_stb),
      .wr_stb				(1'b0),			 
      .reg_data				(`CR_HUF_COMP_C_LONG_REBUILD_COUNTER_T_WIDTH'd0), 
      .count_stb			(long_ht_dbg_cntr_rebuild), 
      .count_by				(long_ht_dbg_cntr_rebuild_cnt), 
      .count_id				(1'b0));			 

   

   nx_event_counter_array
     #(
       
       .BASE_ADDRESS			(`CR_HUF_COMP_SHORT_ST_REBUILD_COUNT_A), 
       .ALIGNMENT			(2),			 
       .N_ADDR_BITS			(`CR_HUF_COMP_WIDTH),	 
       .N_COUNTERS			(1),			 
       .N_COUNT_BY_BITS			(2),			 
       .N_COUNTER_BITS			(`CR_HUF_COMP_C_SHORT_ST_REBUILD_COUNTER_T_WIDTH)) 
   u_short_st_rebuild_counters
     (
      
      .counter_a			(short_st_rebuild_count_a), 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .reg_addr				(reg_addr[`BIT_VEC((`CR_HUF_COMP_WIDTH))]),
      .counter_config			(1'b0),			 
      .rd_stb				(rd_stb),
      .wr_stb				(1'b0),			 
      .reg_data				(`CR_HUF_COMP_C_SHORT_ST_REBUILD_COUNTER_T_WIDTH'd0), 
      .count_stb			(short_st_dbg_cntr_rebuild), 
      .count_by				(short_st_dbg_cntr_rebuild_cnt), 
      .count_id				(1'b0));			 

   

   nx_event_counter_array
     #(
       
       .BASE_ADDRESS			(`CR_HUF_COMP_LONG_ST_REBUILD_COUNT_A), 
       .ALIGNMENT			(2),			 
       .N_ADDR_BITS			(`CR_HUF_COMP_WIDTH),	 
       .N_COUNTERS			(1),			 
       .N_COUNT_BY_BITS			(2),			 
       .N_COUNTER_BITS			(`CR_HUF_COMP_C_LONG_ST_REBUILD_COUNTER_T_WIDTH)) 
   u_long_st_rebuild_counters
     (
      
      .counter_a			(long_st_rebuild_count_a), 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .reg_addr				(reg_addr[`BIT_VEC((`CR_HUF_COMP_WIDTH))]),
      .counter_config			(1'b0),			 
      .rd_stb				(rd_stb),
      .wr_stb				(1'b0),			 
      .reg_data				(`CR_HUF_COMP_C_LONG_ST_REBUILD_COUNTER_T_WIDTH'd0), 
      .count_stb			(long_st_dbg_cntr_rebuild), 
      .count_by				(long_st_dbg_cntr_rebuild_cnt), 
      .count_id				(1'b0));			 


   
endmodule 










