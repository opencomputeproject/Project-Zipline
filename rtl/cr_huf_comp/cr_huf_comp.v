/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_huf_comp.vh"
`include "ccx_std.vh"


module cr_huf_comp
#(parameter 
  HUF_COMP_STUB=0,
  SINGLE_PIPE  =0,
  FPGA_MOD     =0)
  (
   
   huf_comp_ib_out, rbus_ring_o, huf_comp_ob_out, huf_comp_sch_update,
   huf_comp_stat_events, huf_comp_int,
   huf_comp_xp10_decomp_lz77d_stat_events, im_available_huf,
   im_available_he_lng, im_available_he_sh, im_available_he_st_lng,
   im_available_he_st_sh,
   
   clk, rst_n, scan_en, scan_mode, scan_rst_n, ovstb, lvm, mlvm,
   huf_comp_ib_in, rbus_ring_i, cfg_start_addr, cfg_end_addr,
   huf_comp_ob_in, huf_comp_in_module_id, huf_comp_out_module_id,
   su_ready, im_consumed_huf, im_consumed_he_sh, im_consumed_he_lng,
   im_consumed_he_st_sh, im_consumed_he_st_lng
   );

`include "cr_structs.sv"
   
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;
  
  
  
  input         clk;
  input         rst_n; 

  
  
  
  input         scan_en;
  input         scan_mode;
  input         scan_rst_n;

  
  
  
  input         ovstb;
  input         lvm;
  input         mlvm;

  
  
  
  input         axi4s_dp_bus_t huf_comp_ib_in;
  output        axi4s_dp_rdy_t huf_comp_ib_out;
  
  
  
  
  input         rbus_ring_t rbus_ring_i;
  output        rbus_ring_t rbus_ring_o;
  input [`N_RBUS_ADDR_BITS-1:0] cfg_start_addr;
  input [`N_RBUS_ADDR_BITS-1:0] cfg_end_addr;
  
  
  
  input         axi4s_dp_rdy_t huf_comp_ob_in;
  output        axi4s_dp_bus_t huf_comp_ob_out;

  
  
  
  input         [`MODULE_ID_WIDTH-1:0] huf_comp_in_module_id; 
   input [`MODULE_ID_WIDTH-1:0]        huf_comp_out_module_id; 
   
  
  
  
  input 			               su_ready;
  output        sched_update_if_bus_t          huf_comp_sch_update;
  output 	huf_comp_stats_t               huf_comp_stat_events;
  output 	generic_int_t                  huf_comp_int;
   output [`LZ77D_STATS_WIDTH-1:0]             huf_comp_xp10_decomp_lz77d_stat_events;
  
  
  
  output	im_available_t	               im_available_huf;
  output	im_available_t	               im_available_he_lng;
  output	im_available_t	               im_available_he_sh;
  output	im_available_t	               im_available_he_st_lng;
  output	im_available_t	               im_available_he_st_sh;
  input 	im_consumed_t	               im_consumed_huf;
  input         im_consumed_t	               im_consumed_he_sh;
  input         im_consumed_t	               im_consumed_he_lng;
  input         im_consumed_t	               im_consumed_he_st_sh;
  input         im_consumed_t	               im_consumed_he_st_lng;
  
`ifndef CR_HUF_COMP_BBOX

  
  
  logic			core_bimc_idat;		
  logic			core_bimc_isync;	
  logic			core_bimc_odat;		
  logic			core_bimc_osync;	
  logic			core_bimc_rst_n;	
  logic			ecc_error_reg;		
  axi4s_dp_rdy_t	huf_comp_ob_in_mod;	
  axi4s_dp_bus_t	huf_comp_ob_out_pre;	
  logic			ism_ecc_error;		
  lng_bl_t		long_bl_ism_data;	
  logic			long_bl_ism_vld;	
  logic			long_ht_dbg_cntr_rebuild;
  logic [1:0]		long_ht_dbg_cntr_rebuild_cnt;
  logic			long_ht_dbg_cntr_rebuild_failed;
  logic [1:0]		long_ht_dbg_cntr_rebuild_failed_cnt;
  logic			long_ism_rdy;		
  logic			long_st_dbg_cntr_rebuild;
  logic [1:0]		long_st_dbg_cntr_rebuild_cnt;
  logic			long_st_dbg_cntr_rebuild_failed;
  logic [1:0]		long_st_dbg_cntr_rebuild_failed_cnt;
  logic			rst_sync_n;		
  logic			sa_bip2_reg;		
  sh_bl_t		short_bl_ism_data;	
  logic			short_bl_ism_vld;	
  logic			short_ht_dbg_cntr_rebuild;
  logic [1:0]		short_ht_dbg_cntr_rebuild_cnt;
  logic			short_ht_dbg_cntr_rebuild_failed;
  logic [1:0]		short_ht_dbg_cntr_rebuild_failed_cnt;
  logic			short_ism_rdy;		
  logic			short_st_dbg_cntr_rebuild;
  logic [1:0]		short_st_dbg_cntr_rebuild_cnt;
  logic			short_st_dbg_cntr_rebuild_failed;
  logic [1:0]		short_st_dbg_cntr_rebuild_failed_cnt;
  logic			sm_bip2_reg;		
  st_lng_bl_t		st_long_bl_ism_data;	
  logic			st_long_bl_ism_vld;	
  logic			st_long_ism_rdy;	
  st_sh_bl_t		st_short_bl_ism_data;	
  logic			st_short_bl_ism_vld;	
  logic			st_short_ism_rdy;	
  henc_debug_cntrl_t	sw_debug_control;	
  henc_deflate_disable_modes_t sw_deflate_disable_modes;
  henc_disable_sub_pipe_t sw_disable_sub_pipe;	
  logic [`CR_HUF_COMP_C_HENC_GZIP_OS_T_DECL] sw_gzip_os;
  logic [`CR_HUF_COMP_C_HENC_HUFF_WIN_SIZE_IN_ENTRIES_T_DECL] sw_henc_huff_win_size_in_entries;
  logic [`CR_HUF_COMP_C_HENC_EX9_FIRST_BLK_THRESH_T_DECL] sw_henc_xp9_first_blk_thrsh;
  ht_config_t		sw_long_ht_config;	
  logic [`CR_HUF_COMP_C_HENC_SCH_UPDATE_PREFIX_ADJ_T_DECL] sw_prefix_adj;
  logic [`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_31_0_T_DECL] sw_sa_out_tlv_parse_action_0;
  logic [`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_63_32_T_DECL] sw_sa_out_tlv_parse_action_1;
  ht_config_t		sw_short_ht_config;	
  logic [`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_31_0_T_DECL] sw_sm_in_tlv_parse_action_0;
  logic [`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_63_32_T_DECL] sw_sm_in_tlv_parse_action_1;
  small_ht_config_t	sw_st_long_ht_config;	
  small_ht_config_t	sw_st_short_ht_config;	
  henc_xp10_disable_modes_t sw_xp10_disable_modes;
  henc_xp9_disable_modes_t sw_xp9_disable_modes;
  

 
   cr_rst_sync comp_rst
     (
      
      .rst_n				(rst_sync_n),		 
      
      .clk				(clk),
      .async_rst_n			(rst_n),		 
      .bypass_reset			(scan_mode),		 
      .test_rst_n			(scan_rst_n));		 
   
  

  generate if (HUF_COMP_STUB == 1)
  begin: huf_comp_stub_start
     reg tlv_is_ftr_reg;
     
     
     `include "cr_huf_comp_sch_update_stub.v"

     wire tlv_is_ftr = (tlv_types_e'(huf_comp_ib_in.tdata[7:0]) == FTR) & huf_comp_ib_in.tuser[0] & huf_comp_ib_in.tvalid;
     wire footer_w13 = tlv_is_ftr_reg &  huf_comp_ib_in.tuser[1];
     
     always_comb
       begin
	  huf_comp_ob_out_pre.tvalid = huf_comp_ib_in.tvalid;
	  huf_comp_ob_out_pre.tlast  = huf_comp_ib_in.tlast;
	  huf_comp_ob_out_pre.tid    = huf_comp_ib_in.tid;
	  huf_comp_ob_out_pre.tstrb  = huf_comp_ib_in.tstrb;   
	  huf_comp_ob_out_pre.tuser  = huf_comp_ib_in.tuser;  
	  huf_comp_ob_out_pre.tdata  = huf_comp_ib_in.tdata;  
	  huf_comp_ib_out.tready     = huf_comp_ob_in.tready; 
           
	  
	  if (footer_w13)
	    huf_comp_ob_out_pre.tdata ={ huf_comp_ib_in.tdata[63:44], num_bytes[23:0], huf_comp_ib_in.tdata[19:0] };	  
       end

    
	 
     always @(posedge clk or negedge rst_n)
       begin
	  if (!rst_n)
	    begin	   
	       tlv_is_ftr_reg <= 0;
	    end
	  else
	    begin
	       if (tlv_is_ftr)
		 tlv_is_ftr_reg <= 1;
	       else if (huf_comp_ib_in.tuser[1] && huf_comp_ob_in.tready && huf_comp_ib_in.tvalid)
		 tlv_is_ftr_reg <= 0;
	    end
       end 
     
  end 


     
  else
   begin: huf_comp_rtl_start

  
   
   
   
  
  cr_huf_comp_core
    #(
      .SINGLE_PIPE        (SINGLE_PIPE), 
      .FPGA_MOD           (FPGA_MOD)     
     )
  u_cr_huf_comp_core
  (
   
   
   .core_bimc_odat			(core_bimc_odat),
   .core_bimc_osync			(core_bimc_osync),
   .huf_comp_ib_out			(huf_comp_ib_out),
   .huf_comp_ob_out			(huf_comp_ob_out_pre),	 
   .huf_comp_sch_update			(huf_comp_sch_update),
   .huf_comp_stats			(huf_comp_stat_events),	 
   .huf_comp_xp10_decomp_lz77d_stat_events(huf_comp_xp10_decomp_lz77d_stat_events[`LZ77D_STATS_WIDTH-1:0]),
   .sa_bip2_reg				(sa_bip2_reg),
   .sm_bip2_reg				(sm_bip2_reg),
   .ecc_error_reg			(ecc_error_reg),
   .short_bl_ism_data			(short_bl_ism_data),
   .short_bl_ism_vld			(short_bl_ism_vld),
   .long_bl_ism_data			(long_bl_ism_data),
   .long_bl_ism_vld			(long_bl_ism_vld),
   .st_short_bl_ism_data		(st_short_bl_ism_data),
   .st_short_bl_ism_vld			(st_short_bl_ism_vld),
   .st_long_bl_ism_data			(st_long_bl_ism_data),
   .st_long_bl_ism_vld			(st_long_bl_ism_vld),
   .short_ht_dbg_cntr_rebuild		(short_ht_dbg_cntr_rebuild),
   .short_ht_dbg_cntr_rebuild_failed	(short_ht_dbg_cntr_rebuild_failed),
   .short_ht_dbg_cntr_rebuild_cnt	(short_ht_dbg_cntr_rebuild_cnt[1:0]),
   .short_ht_dbg_cntr_rebuild_failed_cnt(short_ht_dbg_cntr_rebuild_failed_cnt[1:0]),
   .long_ht_dbg_cntr_rebuild		(long_ht_dbg_cntr_rebuild),
   .long_ht_dbg_cntr_rebuild_failed	(long_ht_dbg_cntr_rebuild_failed),
   .long_ht_dbg_cntr_rebuild_cnt	(long_ht_dbg_cntr_rebuild_cnt[1:0]),
   .long_ht_dbg_cntr_rebuild_failed_cnt	(long_ht_dbg_cntr_rebuild_failed_cnt[1:0]),
   .short_st_dbg_cntr_rebuild		(short_st_dbg_cntr_rebuild),
   .short_st_dbg_cntr_rebuild_failed	(short_st_dbg_cntr_rebuild_failed),
   .short_st_dbg_cntr_rebuild_cnt	(short_st_dbg_cntr_rebuild_cnt[1:0]),
   .short_st_dbg_cntr_rebuild_failed_cnt(short_st_dbg_cntr_rebuild_failed_cnt[1:0]),
   .long_st_dbg_cntr_rebuild		(long_st_dbg_cntr_rebuild),
   .long_st_dbg_cntr_rebuild_failed	(long_st_dbg_cntr_rebuild_failed),
   .long_st_dbg_cntr_rebuild_cnt	(long_st_dbg_cntr_rebuild_cnt[1:0]),
   .long_st_dbg_cntr_rebuild_failed_cnt	(long_st_dbg_cntr_rebuild_failed_cnt[1:0]),
   
   .clk					(clk),
   .rst_n				(rst_sync_n),		 
   .lvm					(lvm),
   .mlvm				(mlvm),
   .ovstb				(ovstb),
   .core_bimc_rst_n			(core_bimc_rst_n),
   .core_bimc_isync			(core_bimc_isync),
   .core_bimc_idat			(core_bimc_idat),
   .huf_comp_ib_in			(huf_comp_ib_in),
   .huf_comp_ob_in			(huf_comp_ob_in_mod),	 
   .su_ready				(su_ready),
   .huf_comp_in_module_id		(huf_comp_in_module_id[`MODULE_ID_WIDTH-1:0]),
   .huf_comp_out_module_id		(huf_comp_out_module_id[`MODULE_ID_WIDTH-1:0]),
   .sw_henc_huff_win_size_in_entries	(sw_henc_huff_win_size_in_entries[`CR_HUF_COMP_C_HENC_HUFF_WIN_SIZE_IN_ENTRIES_T_DECL]),
   .sw_henc_xp9_first_blk_thrsh		(sw_henc_xp9_first_blk_thrsh[`CR_HUF_COMP_C_HENC_EX9_FIRST_BLK_THRESH_T_DECL]),
   .sw_short_ht_config			(sw_short_ht_config),
   .sw_long_ht_config			(sw_long_ht_config),
   .sw_st_short_ht_config		(sw_st_short_ht_config),
   .sw_st_long_ht_config		(sw_st_long_ht_config),
   .sw_xp9_disable_modes		(sw_xp9_disable_modes),
   .sw_xp10_disable_modes		(sw_xp10_disable_modes),
   .sw_deflate_disable_modes		(sw_deflate_disable_modes),
   .sw_disable_sub_pipe			(sw_disable_sub_pipe),
   .sw_sa_out_tlv_parse_action_0	(sw_sa_out_tlv_parse_action_0[`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_31_0_T_DECL]),
   .sw_sa_out_tlv_parse_action_1	(sw_sa_out_tlv_parse_action_1[`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_63_32_T_DECL]),
   .sw_sm_in_tlv_parse_action_0		(sw_sm_in_tlv_parse_action_0[`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_31_0_T_DECL]),
   .sw_sm_in_tlv_parse_action_1		(sw_sm_in_tlv_parse_action_1[`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_63_32_T_DECL]),
   .short_ism_rdy			(short_ism_rdy),
   .long_ism_rdy			(long_ism_rdy),
   .st_short_ism_rdy			(st_short_ism_rdy),
   .st_long_ism_rdy			(st_long_ism_rdy),
   .sw_debug_control			(sw_debug_control),
   .sw_prefix_adj			(sw_prefix_adj[`CR_HUF_COMP_C_HENC_SCH_UPDATE_PREFIX_ADJ_T_DECL]),
   .sw_gzip_os				(sw_gzip_os[`CR_HUF_COMP_C_HENC_GZIP_OS_T_DECL]),
   .ism_ecc_error			(ism_ecc_error));
end
endgenerate
   
   
  cr_huf_comp_regfile
  u_cr_huf_comp_regfile 
  (
   
   
   .rbus_ring_o				(rbus_ring_o),
   .sw_henc_huff_win_size_in_entries	(sw_henc_huff_win_size_in_entries[`CR_HUF_COMP_C_HENC_HUFF_WIN_SIZE_IN_ENTRIES_T_DECL]),
   .sw_henc_xp9_first_blk_thrsh		(sw_henc_xp9_first_blk_thrsh[`CR_HUF_COMP_C_HENC_EX9_FIRST_BLK_THRESH_T_DECL]),
   .sw_prefix_adj			(sw_prefix_adj[`CR_HUF_COMP_C_HENC_SCH_UPDATE_PREFIX_ADJ_T_DECL]),
   .sw_gzip_os				(sw_gzip_os[`CR_HUF_COMP_C_HENC_GZIP_OS_T_DECL]),
   .sw_sa_out_tlv_parse_action_0	(sw_sa_out_tlv_parse_action_0[`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_31_0_T_DECL]),
   .sw_sa_out_tlv_parse_action_1	(sw_sa_out_tlv_parse_action_1[`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_63_32_T_DECL]),
   .sw_sm_in_tlv_parse_action_0		(sw_sm_in_tlv_parse_action_0[`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_31_0_T_DECL]),
   .sw_sm_in_tlv_parse_action_1		(sw_sm_in_tlv_parse_action_1[`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_63_32_T_DECL]),
   .sw_short_ht_config			(sw_short_ht_config),
   .sw_long_ht_config			(sw_long_ht_config),
   .sw_st_short_ht_config		(sw_st_short_ht_config),
   .sw_st_long_ht_config		(sw_st_long_ht_config),
   .sw_xp9_disable_modes		(sw_xp9_disable_modes),
   .sw_xp10_disable_modes		(sw_xp10_disable_modes),
   .sw_deflate_disable_modes		(sw_deflate_disable_modes),
   .sw_disable_sub_pipe			(sw_disable_sub_pipe),
   .sw_debug_control			(sw_debug_control),
   .huf_comp_ob_out			(huf_comp_ob_out),
   .huf_comp_ob_in_mod			(huf_comp_ob_in_mod),
   .im_available_huf			(im_available_huf),
   .im_available_he_sh			(im_available_he_sh),
   .im_available_he_lng			(im_available_he_lng),
   .im_available_he_st_sh		(im_available_he_st_sh),
   .im_available_he_st_lng		(im_available_he_st_lng),
   .short_ism_rdy			(short_ism_rdy),
   .long_ism_rdy			(long_ism_rdy),
   .st_short_ism_rdy			(st_short_ism_rdy),
   .st_long_ism_rdy			(st_long_ism_rdy),
   .core_bimc_rst_n			(core_bimc_rst_n),
   .core_bimc_isync			(core_bimc_isync),
   .core_bimc_idat			(core_bimc_idat),
   .ism_ecc_error			(ism_ecc_error),
   .huf_comp_int			(huf_comp_int),
   
   .rst_n				(rst_sync_n),		 
   .clk					(clk),
   .cfg_start_addr			(cfg_start_addr[`N_RBUS_ADDR_BITS-1:0]),
   .cfg_end_addr			(cfg_end_addr[`N_RBUS_ADDR_BITS-1:0]),
   .rbus_ring_i				(rbus_ring_i),
   .huf_comp_ob_out_pre			(huf_comp_ob_out_pre),
   .huf_comp_ob_in			(huf_comp_ob_in),
   .im_consumed_huf			(im_consumed_huf),
   .im_consumed_he_sh			(im_consumed_he_sh),
   .im_consumed_he_lng			(im_consumed_he_lng),
   .im_consumed_he_st_sh		(im_consumed_he_st_sh),
   .im_consumed_he_st_lng		(im_consumed_he_st_lng),
   .short_bl_ism_data			(short_bl_ism_data),
   .short_bl_ism_vld			(short_bl_ism_vld),
   .long_bl_ism_data			(long_bl_ism_data),
   .long_bl_ism_vld			(long_bl_ism_vld),
   .st_short_bl_ism_data		(st_short_bl_ism_data),
   .st_short_bl_ism_vld			(st_short_bl_ism_vld),
   .st_long_bl_ism_data			(st_long_bl_ism_data),
   .st_long_bl_ism_vld			(st_long_bl_ism_vld),
   .short_ht_dbg_cntr_rebuild		(short_ht_dbg_cntr_rebuild),
   .short_ht_dbg_cntr_rebuild_failed	(short_ht_dbg_cntr_rebuild_failed),
   .short_ht_dbg_cntr_rebuild_cnt	(short_ht_dbg_cntr_rebuild_cnt[1:0]),
   .short_ht_dbg_cntr_rebuild_failed_cnt(short_ht_dbg_cntr_rebuild_failed_cnt[1:0]),
   .long_ht_dbg_cntr_rebuild		(long_ht_dbg_cntr_rebuild),
   .long_ht_dbg_cntr_rebuild_failed	(long_ht_dbg_cntr_rebuild_failed),
   .long_ht_dbg_cntr_rebuild_cnt	(long_ht_dbg_cntr_rebuild_cnt[1:0]),
   .long_ht_dbg_cntr_rebuild_failed_cnt	(long_ht_dbg_cntr_rebuild_failed_cnt[1:0]),
   .short_st_dbg_cntr_rebuild		(short_st_dbg_cntr_rebuild),
   .short_st_dbg_cntr_rebuild_failed	(short_st_dbg_cntr_rebuild_failed),
   .short_st_dbg_cntr_rebuild_cnt	(short_st_dbg_cntr_rebuild_cnt[1:0]),
   .short_st_dbg_cntr_rebuild_failed_cnt(short_st_dbg_cntr_rebuild_failed_cnt[1:0]),
   .long_st_dbg_cntr_rebuild		(long_st_dbg_cntr_rebuild),
   .long_st_dbg_cntr_rebuild_failed	(long_st_dbg_cntr_rebuild_failed),
   .long_st_dbg_cntr_rebuild_cnt	(long_st_dbg_cntr_rebuild_cnt[1:0]),
   .long_st_dbg_cntr_rebuild_failed_cnt	(long_st_dbg_cntr_rebuild_failed_cnt[1:0]),
   .lvm					(lvm),
   .mlvm				(mlvm),
   .ovstb				(ovstb),
   .core_bimc_odat			(core_bimc_odat),
   .core_bimc_osync			(core_bimc_osync),
   .sa_bip2_reg				(sa_bip2_reg),
   .sm_bip2_reg				(sm_bip2_reg),
   .ecc_error_reg			(ecc_error_reg));
`endif
endmodule














