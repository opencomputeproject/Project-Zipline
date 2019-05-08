/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











`include "cr_huf_comp.vh"




module cr_huf_comp_regs (
  input                                         clk,
  input                                         i_reset_,
  input                                         i_sw_init,

  
  input      [`CR_HUF_COMP_DECL]                i_addr,
  input                                         i_wr_strb,
  input      [31:0]                             i_wr_data,
  input                                         i_rd_strb,
  output     [31:0]                             o_rd_data,
  output                                        o_ack,
  output                                        o_err_ack,

  
  output     [`CR_HUF_COMP_C_SPARE_T_DECL]      o_spare_config,
  output     [`CR_HUF_COMP_C_HENC_SCH_UPDATE_PREFIX_ADJ_T_DECL] o_prefix_adj,
  output     [`CR_HUF_COMP_C_HENC_HUFF_WIN_SIZE_IN_ENTRIES_T_DECL] o_henc_huff_win_size_in_entries,
  output     [`CR_HUF_COMP_C_HENC_EX9_FIRST_BLK_THRESH_T_DECL] o_henc_xp9_first_blk_thrsh,
  output     [`CR_HUF_COMP_C_HT_CONFIG_T_DECL]  o_short_ht_config,
  output     [`CR_HUF_COMP_C_HT_CONFIG_T_DECL]  o_long_ht_config,
  output     [`CR_HUF_COMP_C_SMALL_HT_CONFIG_T_DECL] o_st_short_ht_config,
  output     [`CR_HUF_COMP_C_SMALL_HT_CONFIG_T_DECL] o_st_long_ht_config,
  output     [`CR_HUF_COMP_C_HENC_XP9_DISABLE_MODES_T_DECL] o_xp9_disable_modes,
  output     [`CR_HUF_COMP_C_HENC_XP10_DISABLE_MODES_T_DECL] o_xp10_disable_modes,
  output     [`CR_HUF_COMP_C_HENC_DEFLATE_DISABLE_MODES_T_DECL] o_deflate_disable_modes,
  output     [`CR_HUF_COMP_C_HENC_FORCE_BLOCK_STALL_T_DECL] o_force_block_stall,
  output     [`CR_HUF_COMP_C_HENC_DISABLE_SUB_PIPE_T_DECL] o_disable_sub_pipe,
  output     [`CR_HUF_COMP_C_HENC_DEBUG_CNTRL_T_DECL] o_debug_control,
  output     [`CR_HUF_COMP_C_OUT_PART0_T_DECL]  o_out_ia_wdata_part0,
  output     [`CR_HUF_COMP_C_OUT_PART1_T_DECL]  o_out_ia_wdata_part1,
  output     [`CR_HUF_COMP_C_OUT_PART2_T_DECL]  o_out_ia_wdata_part2,
  output     [`CR_HUF_COMP_C_OUT_IA_CONFIG_T_DECL] o_out_ia_config,
  output     [`CR_HUF_COMP_C_OUT_IM_CONFIG_T_DECL] o_out_im_config,
  output     [`CR_HUF_COMP_C_OUT_IM_CONSUMED_T_DECL] o_out_im_read_done,
  output     [`CR_HUF_COMP_C_SH_BL_PART0_T_DECL] o_sh_bl_ia_wdata_part0,
  output     [`CR_HUF_COMP_C_SH_BL_PART1_T_DECL] o_sh_bl_ia_wdata_part1,
  output     [`CR_HUF_COMP_C_SH_BL_PART2_T_DECL] o_sh_bl_ia_wdata_part2,
  output     [`CR_HUF_COMP_C_SH_BL_IA_CONFIG_T_DECL] o_sh_bl_ia_config,
  output     [`CR_HUF_COMP_C_SH_BL_IM_CONFIG_T_DECL] o_sh_bl_im_config,
  output     [`CR_HUF_COMP_C_SH_BL_IM_CONSUMED_T_DECL] o_sh_bl_im_read_done,
  output     [`CR_HUF_COMP_C_LNG_BL_PART0_T_DECL] o_lng_bl_ia_wdata_part0,
  output     [`CR_HUF_COMP_C_LNG_BL_PART1_T_DECL] o_lng_bl_ia_wdata_part1,
  output     [`CR_HUF_COMP_C_LNG_BL_PART2_T_DECL] o_lng_bl_ia_wdata_part2,
  output     [`CR_HUF_COMP_C_LNG_BL_IA_CONFIG_T_DECL] o_lng_bl_ia_config,
  output     [`CR_HUF_COMP_C_LNG_BL_IM_CONFIG_T_DECL] o_lng_bl_im_config,
  output     [`CR_HUF_COMP_C_LNG_BL_IM_CONSUMED_T_DECL] o_lng_bl_im_read_done,
  output     [`CR_HUF_COMP_C_ST_SH_BL_PART0_T_DECL] o_st_sh_bl_ia_wdata_part0,
  output     [`CR_HUF_COMP_C_ST_SH_BL_PART1_T_DECL] o_st_sh_bl_ia_wdata_part1,
  output     [`CR_HUF_COMP_C_ST_SH_BL_PART2_T_DECL] o_st_sh_bl_ia_wdata_part2,
  output     [`CR_HUF_COMP_C_ST_SH_BL_IA_CONFIG_T_DECL] o_st_sh_bl_ia_config,
  output     [`CR_HUF_COMP_C_ST_SH_BL_IM_CONFIG_T_DECL] o_st_sh_bl_im_config,
  output     [`CR_HUF_COMP_C_ST_SH_BL_IM_CONSUMED_T_DECL] o_st_sh_bl_im_read_done,
  output     [`CR_HUF_COMP_C_ST_LNG_BL_PART0_T_DECL] o_st_lng_bl_ia_wdata_part0,
  output     [`CR_HUF_COMP_C_ST_LNG_BL_PART1_T_DECL] o_st_lng_bl_ia_wdata_part1,
  output     [`CR_HUF_COMP_C_ST_LNG_BL_PART2_T_DECL] o_st_lng_bl_ia_wdata_part2,
  output     [`CR_HUF_COMP_C_ST_LNG_BL_IA_CONFIG_T_DECL] o_st_lng_bl_ia_config,
  output     [`CR_HUF_COMP_C_ST_LNG_BL_IM_CONFIG_T_DECL] o_st_lng_bl_im_config,
  output     [`CR_HUF_COMP_C_ST_LNG_BL_IM_CONSUMED_T_DECL] o_st_lng_bl_im_read_done,
  output     [`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_31_0_T_DECL] o_sm_in_tlv_parse_action_0,
  output     [`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_63_32_T_DECL] o_sm_in_tlv_parse_action_1,
  output     [`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_31_0_T_DECL] o_sa_out_tlv_parse_action_0,
  output     [`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_63_32_T_DECL] o_sa_out_tlv_parse_action_1,
  output     [`CR_HUF_COMP_C_BIMC_MONITOR_MASK_T_DECL] o_bimc_monitor_mask,
  output     [`CR_HUF_COMP_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_uncorrectable_error_cnt,
  output     [`CR_HUF_COMP_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_correctable_error_cnt,
  output     [`CR_HUF_COMP_C_BIMC_PARITY_ERROR_CNT_T_DECL] o_bimc_parity_error_cnt,
  output     [`CR_HUF_COMP_C_BIMC_GLOBAL_CONFIG_T_DECL] o_bimc_global_config,
  output     [`CR_HUF_COMP_C_BIMC_ECCPAR_DEBUG_T_DECL] o_bimc_eccpar_debug,
  output     [`CR_HUF_COMP_C_BIMC_CMD2_T_DECL]  o_bimc_cmd2,
  output     [`CR_HUF_COMP_C_BIMC_CMD1_T_DECL]  o_bimc_cmd1,
  output     [`CR_HUF_COMP_C_BIMC_CMD0_T_DECL]  o_bimc_cmd0,
  output     [`CR_HUF_COMP_C_BIMC_RXCMD2_T_DECL] o_bimc_rxcmd2,
  output     [`CR_HUF_COMP_C_BIMC_RXRSP2_T_DECL] o_bimc_rxrsp2,
  output     [`CR_HUF_COMP_C_BIMC_POLLRSP2_T_DECL] o_bimc_pollrsp2,
  output     [`CR_HUF_COMP_C_BIMC_DBGCMD2_T_DECL] o_bimc_dbgcmd2,
  output     [`CR_HUF_COMP_C_HENC_GZIP_OS_T_DECL] o_gzip_os,

  
  input      [`CR_HUF_COMP_C_REVID_T_DECL]      i_revision_config,
  input      [`CR_HUF_COMP_C_SPARE_T_DECL]      i_spare_config,
  input      [`CR_HUF_COMP_C_OUT_IA_CAPABILITY_T_DECL] i_out_ia_capability,
  input      [`CR_HUF_COMP_C_OUT_IA_STATUS_T_DECL] i_out_ia_status,
  input      [`CR_HUF_COMP_C_OUT_PART0_T_DECL]  i_out_ia_rdata_part0,
  input      [`CR_HUF_COMP_C_OUT_PART1_T_DECL]  i_out_ia_rdata_part1,
  input      [`CR_HUF_COMP_C_OUT_PART2_T_DECL]  i_out_ia_rdata_part2,
  input      [`CR_HUF_COMP_C_OUT_IM_STATUS_T_DECL] i_out_im_status,
  input      [`CR_HUF_COMP_C_OUT_IM_CONSUMED_T_DECL] i_out_im_read_done,
  input      [`CR_HUF_COMP_C_SH_BL_IA_CAPABILITY_T_DECL] i_sh_bl_ia_capability,
  input      [`CR_HUF_COMP_C_SH_BL_IA_STATUS_T_DECL] i_sh_bl_ia_status,
  input      [`CR_HUF_COMP_C_SH_BL_PART0_T_DECL] i_sh_bl_ia_rdata_part0,
  input      [`CR_HUF_COMP_C_SH_BL_PART1_T_DECL] i_sh_bl_ia_rdata_part1,
  input      [`CR_HUF_COMP_C_SH_BL_PART2_T_DECL] i_sh_bl_ia_rdata_part2,
  input      [`CR_HUF_COMP_C_SH_BL_IM_STATUS_T_DECL] i_sh_bl_im_status,
  input      [`CR_HUF_COMP_C_SH_BL_IM_CONSUMED_T_DECL] i_sh_bl_im_read_done,
  input      [`CR_HUF_COMP_C_LNG_BL_IA_CAPABILITY_T_DECL] i_lng_bl_ia_capability,
  input      [`CR_HUF_COMP_C_LNG_BL_IA_STATUS_T_DECL] i_lng_bl_ia_status,
  input      [`CR_HUF_COMP_C_LNG_BL_PART0_T_DECL] i_lng_bl_ia_rdata_part0,
  input      [`CR_HUF_COMP_C_LNG_BL_PART1_T_DECL] i_lng_bl_ia_rdata_part1,
  input      [`CR_HUF_COMP_C_LNG_BL_PART2_T_DECL] i_lng_bl_ia_rdata_part2,
  input      [`CR_HUF_COMP_C_LNG_BL_IM_STATUS_T_DECL] i_lng_bl_im_status,
  input      [`CR_HUF_COMP_C_LNG_BL_IM_CONSUMED_T_DECL] i_lng_bl_im_read_done,
  input      [`CR_HUF_COMP_C_ST_SH_BL_IA_CAPABILITY_T_DECL] i_st_sh_bl_ia_capability,
  input      [`CR_HUF_COMP_C_ST_SH_BL_IA_STATUS_T_DECL] i_st_sh_bl_ia_status,
  input      [`CR_HUF_COMP_C_ST_SH_BL_PART0_T_DECL] i_st_sh_bl_ia_rdata_part0,
  input      [`CR_HUF_COMP_C_ST_SH_BL_PART1_T_DECL] i_st_sh_bl_ia_rdata_part1,
  input      [`CR_HUF_COMP_C_ST_SH_BL_PART2_T_DECL] i_st_sh_bl_ia_rdata_part2,
  input      [`CR_HUF_COMP_C_ST_SH_BL_IM_STATUS_T_DECL] i_st_sh_bl_im_status,
  input      [`CR_HUF_COMP_C_ST_SH_BL_IM_CONSUMED_T_DECL] i_st_sh_bl_im_read_done,
  input      [`CR_HUF_COMP_C_ST_LNG_BL_IA_CAPABILITY_T_DECL] i_st_lng_bl_ia_capability,
  input      [`CR_HUF_COMP_C_ST_LNG_BL_IA_STATUS_T_DECL] i_st_lng_bl_ia_status,
  input      [`CR_HUF_COMP_C_ST_LNG_BL_PART0_T_DECL] i_st_lng_bl_ia_rdata_part0,
  input      [`CR_HUF_COMP_C_ST_LNG_BL_PART1_T_DECL] i_st_lng_bl_ia_rdata_part1,
  input      [`CR_HUF_COMP_C_ST_LNG_BL_PART2_T_DECL] i_st_lng_bl_ia_rdata_part2,
  input      [`CR_HUF_COMP_C_ST_LNG_BL_IM_STATUS_T_DECL] i_st_lng_bl_im_status,
  input      [`CR_HUF_COMP_C_ST_LNG_BL_IM_CONSUMED_T_DECL] i_st_lng_bl_im_read_done,
  input      [`CR_HUF_COMP_C_SHORT_REBUILD_LIMIT_COUNTER_T_DECL] i_short_rebuild_limit_count_a,
  input      [`CR_HUF_COMP_C_LONG_REBUILD_LIMIT_COUNTER_T_DECL] i_long_rebuild_limit_count_a,
  input      [`CR_HUF_COMP_C_SHORT_ST_REBUILD_LIMIT_COUNTER_T_DECL] i_short_st_rebuild_limit_count_a,
  input      [`CR_HUF_COMP_C_LONG_ST_REBUILD_LIMIT_COUNTER_T_DECL] i_long_st_rebuild_limit_count_a,
  input      [`CR_HUF_COMP_C_SHORT_REBUILD_COUNTER_T_DECL] i_short_rebuild_count_a,
  input      [`CR_HUF_COMP_C_LONG_REBUILD_COUNTER_T_DECL] i_long_rebuild_count_a,
  input      [`CR_HUF_COMP_C_SHORT_ST_REBUILD_COUNTER_T_DECL] i_short_st_rebuild_count_a,
  input      [`CR_HUF_COMP_C_LONG_ST_REBUILD_COUNTER_T_DECL] i_long_st_rebuild_count_a,
  input      [`CR_HUF_COMP_C_BIMC_MONITOR_T_DECL] i_bimc_monitor,
  input      [`CR_HUF_COMP_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_uncorrectable_error_cnt,
  input      [`CR_HUF_COMP_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_correctable_error_cnt,
  input      [`CR_HUF_COMP_C_BIMC_PARITY_ERROR_CNT_T_DECL] i_bimc_parity_error_cnt,
  input      [`CR_HUF_COMP_C_BIMC_GLOBAL_CONFIG_T_DECL] i_bimc_global_config,
  input      [`CR_HUF_COMP_C_BIMC_MEMID_T_DECL] i_bimc_memid,
  input      [`CR_HUF_COMP_C_BIMC_ECCPAR_DEBUG_T_DECL] i_bimc_eccpar_debug,
  input      [`CR_HUF_COMP_C_BIMC_CMD2_T_DECL]  i_bimc_cmd2,
  input      [`CR_HUF_COMP_C_BIMC_RXCMD2_T_DECL] i_bimc_rxcmd2,
  input      [`CR_HUF_COMP_C_BIMC_RXCMD1_T_DECL] i_bimc_rxcmd1,
  input      [`CR_HUF_COMP_C_BIMC_RXCMD0_T_DECL] i_bimc_rxcmd0,
  input      [`CR_HUF_COMP_C_BIMC_RXRSP2_T_DECL] i_bimc_rxrsp2,
  input      [`CR_HUF_COMP_C_BIMC_RXRSP1_T_DECL] i_bimc_rxrsp1,
  input      [`CR_HUF_COMP_C_BIMC_RXRSP0_T_DECL] i_bimc_rxrsp0,
  input      [`CR_HUF_COMP_C_BIMC_POLLRSP2_T_DECL] i_bimc_pollrsp2,
  input      [`CR_HUF_COMP_C_BIMC_POLLRSP1_T_DECL] i_bimc_pollrsp1,
  input      [`CR_HUF_COMP_C_BIMC_POLLRSP0_T_DECL] i_bimc_pollrsp0,
  input      [`CR_HUF_COMP_C_BIMC_DBGCMD2_T_DECL] i_bimc_dbgcmd2,
  input      [`CR_HUF_COMP_C_BIMC_DBGCMD1_T_DECL] i_bimc_dbgcmd1,
  input      [`CR_HUF_COMP_C_BIMC_DBGCMD0_T_DECL] i_bimc_dbgcmd0,

  
  output reg                                    o_reg_written,
  output reg                                    o_reg_read,
  output     [31:0]                             o_reg_wr_data,
  output reg [`CR_HUF_COMP_DECL]                o_reg_addr
  );


  


  
  


  
  wire [`CR_HUF_COMP_DECL] ws_read_addr    = o_reg_addr;
  wire [`CR_HUF_COMP_DECL] ws_addr         = o_reg_addr;
  

  wire n_wr_strobe = i_wr_strb;
  wire n_rd_strobe = i_rd_strb;

  wire w_32b_aligned    = (o_reg_addr[1:0] == 2'h0);

  wire w_valid_rd_addr     = (w_32b_aligned && (ws_addr >= `CR_HUF_COMP_REVISION_CONFIG) && (ws_addr <= `CR_HUF_COMP_ST_LNG_BL_IM_READ_DONE))
                          || (w_32b_aligned && (ws_addr >= `CR_HUF_COMP_SM_IN_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_HUF_COMP_SM_IN_TLV_PARSE_ACTION_1))
                          || (w_32b_aligned && (ws_addr >= `CR_HUF_COMP_SA_OUT_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_HUF_COMP_SHORT_REBUILD_LIMIT_COUNT_A))
                          || (w_32b_aligned && (ws_addr == `CR_HUF_COMP_LONG_REBUILD_LIMIT_COUNT_A))
                          || (w_32b_aligned && (ws_addr == `CR_HUF_COMP_SHORT_ST_REBUILD_LIMIT_COUNT_A))
                          || (w_32b_aligned && (ws_addr == `CR_HUF_COMP_LONG_ST_REBUILD_LIMIT_COUNT_A))
                          || (w_32b_aligned && (ws_addr == `CR_HUF_COMP_SHORT_REBUILD_COUNT_A))
                          || (w_32b_aligned && (ws_addr == `CR_HUF_COMP_LONG_REBUILD_COUNT_A))
                          || (w_32b_aligned && (ws_addr == `CR_HUF_COMP_SHORT_ST_REBUILD_COUNT_A))
                          || (w_32b_aligned && (ws_addr == `CR_HUF_COMP_LONG_ST_REBUILD_COUNT_A))
                          || (w_32b_aligned && (ws_addr >= `CR_HUF_COMP_BIMC_MONITOR) && (ws_addr <= `CR_HUF_COMP_BIMC_DBGCMD0))
                          || (w_32b_aligned && (ws_addr == `CR_HUF_COMP_GZIP_OS));

  wire w_valid_wr_addr     = (w_32b_aligned && (ws_addr >= `CR_HUF_COMP_REVISION_CONFIG) && (ws_addr <= `CR_HUF_COMP_ST_LNG_BL_IM_READ_DONE))
                          || (w_32b_aligned && (ws_addr >= `CR_HUF_COMP_SM_IN_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_HUF_COMP_SM_IN_TLV_PARSE_ACTION_1))
                          || (w_32b_aligned && (ws_addr >= `CR_HUF_COMP_SA_OUT_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_HUF_COMP_SHORT_REBUILD_LIMIT_COUNT_A))
                          || (w_32b_aligned && (ws_addr == `CR_HUF_COMP_LONG_REBUILD_LIMIT_COUNT_A))
                          || (w_32b_aligned && (ws_addr == `CR_HUF_COMP_SHORT_ST_REBUILD_LIMIT_COUNT_A))
                          || (w_32b_aligned && (ws_addr == `CR_HUF_COMP_LONG_ST_REBUILD_LIMIT_COUNT_A))
                          || (w_32b_aligned && (ws_addr == `CR_HUF_COMP_SHORT_REBUILD_COUNT_A))
                          || (w_32b_aligned && (ws_addr == `CR_HUF_COMP_LONG_REBUILD_COUNT_A))
                          || (w_32b_aligned && (ws_addr == `CR_HUF_COMP_SHORT_ST_REBUILD_COUNT_A))
                          || (w_32b_aligned && (ws_addr == `CR_HUF_COMP_LONG_ST_REBUILD_COUNT_A))
                          || (w_32b_aligned && (ws_addr >= `CR_HUF_COMP_BIMC_MONITOR) && (ws_addr <= `CR_HUF_COMP_BIMC_DBGCMD0))
                          || (w_32b_aligned && (ws_addr == `CR_HUF_COMP_GZIP_OS));

  wire w_valid_addr     = w_valid_wr_addr | w_valid_rd_addr;


  parameter IDLE    = 3'h0,
            WR_PREP = 3'h1,
            WR_REG  = 3'h3,
            WAIT    = 3'h4,
            RD_PREP = 3'h5,
            RD_REG  = 3'h7;

  reg  n_write;

  always_ff @(posedge clk or negedge i_reset_) begin
    if (~i_reset_)
      n_write <= 0;
    else if (i_sw_init)
      n_write <= 0;
    else if (i_wr_strb)
      n_write <= 1;
    else if (o_ack)
      n_write <= 0;
  end

  reg  [2:0] f_state;
  reg        f_prev_do_read;


  wire       w_do_write      = ((f_state == WR_PREP));
  wire       w_do_read       = ((f_state == RD_PREP));


  

  wire [2:0] w_next_state    = n_wr_strobe                                ? WR_PREP
                             : n_rd_strobe                                ? RD_PREP
                             : f_state == WR_PREP                         ? WR_REG
                             : f_state == RD_PREP                         ? RD_REG
                             :                                              IDLE;

  wire       w_next_ack      = ((f_state == RD_PREP));

  wire       w_next_err_ack  = ((f_state == RD_PREP) & ~w_valid_rd_addr);

  reg        f_ack;
  reg        f_err_ack;

  assign o_ack      = f_ack | (f_state == WR_PREP);
  assign o_err_ack  = f_err_ack | ((f_state == WR_PREP) & ~w_valid_wr_addr);

  


  
  

  
  


  reg  [31:0]  r32_mux_0_data, f32_mux_0_data;
  reg  [31:0]  r32_mux_1_data, f32_mux_1_data;
  reg  [31:0]  r32_mux_2_data, f32_mux_2_data;
  reg  [31:0]  r32_mux_3_data, f32_mux_3_data;

  wire [31:0]  r32_formatted_reg_data = f32_mux_0_data
                                      | f32_mux_1_data
                                      | f32_mux_2_data
                                      | f32_mux_3_data;

  always_comb begin
    r32_mux_0_data = 0;
    r32_mux_1_data = 0;
    r32_mux_2_data = 0;
    r32_mux_3_data = 0;

    case (ws_read_addr)
    `CR_HUF_COMP_REVISION_CONFIG: begin
      r32_mux_0_data[07:00] = i_revision_config[07:00]; 
    end
    `CR_HUF_COMP_SPARE_CONFIG: begin
      r32_mux_0_data[31:00] = i_spare_config[31:00]; 
    end
    `CR_HUF_COMP_PREFIX_ADJ: begin
      r32_mux_0_data[01:00] = o_prefix_adj[01:00]; 
    end
    `CR_HUF_COMP_HENC_HUFF_WIN_SIZE_IN_ENTRIES: begin
      r32_mux_0_data[14:00] = o_henc_huff_win_size_in_entries[14:00]; 
    end
    `CR_HUF_COMP_HENC_XP9_FIRST_BLK_THRSH: begin
      r32_mux_0_data[22:00] = o_henc_xp9_first_blk_thrsh[22:00]; 
    end
    `CR_HUF_COMP_SHORT_HT_CONFIG: begin
      r32_mux_0_data[02:00] = o_short_ht_config[02:00]; 
      r32_mux_0_data[12:03] = o_short_ht_config[12:03]; 
      r32_mux_0_data[17:13] = o_short_ht_config[17:13]; 
      r32_mux_0_data[22:18] = o_short_ht_config[22:18]; 
    end
    `CR_HUF_COMP_LONG_HT_CONFIG: begin
      r32_mux_0_data[02:00] = o_long_ht_config[02:00]; 
      r32_mux_0_data[12:03] = o_long_ht_config[12:03]; 
      r32_mux_0_data[17:13] = o_long_ht_config[17:13]; 
      r32_mux_0_data[22:18] = o_long_ht_config[22:18]; 
    end
    `CR_HUF_COMP_ST_SHORT_HT_CONFIG: begin
      r32_mux_0_data[02:00] = o_st_short_ht_config[02:00]; 
      r32_mux_0_data[12:03] = o_st_short_ht_config[12:03]; 
      r32_mux_0_data[16:13] = o_st_short_ht_config[16:13]; 
      r32_mux_0_data[20:17] = o_st_short_ht_config[20:17]; 
    end
    `CR_HUF_COMP_ST_LONG_HT_CONFIG: begin
      r32_mux_0_data[02:00] = o_st_long_ht_config[02:00]; 
      r32_mux_0_data[12:03] = o_st_long_ht_config[12:03]; 
      r32_mux_0_data[16:13] = o_st_long_ht_config[16:13]; 
      r32_mux_0_data[20:17] = o_st_long_ht_config[20:17]; 
    end
    `CR_HUF_COMP_XP9_DISABLE_MODES: begin
      r32_mux_0_data[00:00] = o_xp9_disable_modes[00:00]; 
      r32_mux_0_data[01:01] = o_xp9_disable_modes[01:01]; 
      r32_mux_0_data[02:02] = o_xp9_disable_modes[02:02]; 
    end
    `CR_HUF_COMP_XP10_DISABLE_MODES: begin
      r32_mux_0_data[00:00] = o_xp10_disable_modes[00:00]; 
      r32_mux_0_data[01:01] = o_xp10_disable_modes[01:01]; 
      r32_mux_0_data[02:02] = o_xp10_disable_modes[02:02]; 
      r32_mux_0_data[03:03] = o_xp10_disable_modes[03:03]; 
    end
    `CR_HUF_COMP_DEFLATE_DISABLE_MODES: begin
      r32_mux_0_data[00:00] = o_deflate_disable_modes[00:00]; 
      r32_mux_0_data[01:01] = o_deflate_disable_modes[01:01]; 
      r32_mux_0_data[02:02] = o_deflate_disable_modes[02:02]; 
      r32_mux_0_data[03:03] = o_deflate_disable_modes[03:03]; 
    end
    `CR_HUF_COMP_FORCE_BLOCK_STALL: begin
      r32_mux_0_data[00:00] = o_force_block_stall[00:00]; 
      r32_mux_0_data[01:01] = o_force_block_stall[01:01]; 
      r32_mux_0_data[02:02] = o_force_block_stall[02:02]; 
      r32_mux_0_data[03:03] = o_force_block_stall[03:03]; 
      r32_mux_0_data[04:04] = o_force_block_stall[04:04]; 
      r32_mux_0_data[05:05] = o_force_block_stall[05:05]; 
      r32_mux_0_data[06:06] = o_force_block_stall[06:06]; 
      r32_mux_0_data[07:07] = o_force_block_stall[07:07]; 
    end
    `CR_HUF_COMP_DISABLE_SUB_PIPE: begin
      r32_mux_0_data[00:00] = o_disable_sub_pipe[00:00]; 
    end
    `CR_HUF_COMP_DEBUG_CONTROL: begin
      r32_mux_0_data[00:00] = o_debug_control[00:00]; 
    end
    `CR_HUF_COMP_OUT_IA_CAPABILITY: begin
      r32_mux_0_data[00:00] = i_out_ia_capability[00:00]; 
      r32_mux_0_data[01:01] = i_out_ia_capability[01:01]; 
      r32_mux_0_data[02:02] = i_out_ia_capability[02:02]; 
      r32_mux_0_data[03:03] = i_out_ia_capability[03:03]; 
      r32_mux_0_data[04:04] = i_out_ia_capability[04:04]; 
      r32_mux_0_data[05:05] = i_out_ia_capability[05:05]; 
      r32_mux_0_data[06:06] = i_out_ia_capability[06:06]; 
      r32_mux_0_data[07:07] = i_out_ia_capability[07:07]; 
      r32_mux_0_data[08:08] = i_out_ia_capability[08:08]; 
      r32_mux_0_data[09:09] = i_out_ia_capability[09:09]; 
      r32_mux_0_data[13:10] = i_out_ia_capability[13:10]; 
      r32_mux_0_data[14:14] = i_out_ia_capability[14:14]; 
      r32_mux_0_data[15:15] = i_out_ia_capability[15:15]; 
      r32_mux_0_data[31:28] = i_out_ia_capability[19:16]; 
    end
    `CR_HUF_COMP_OUT_IA_STATUS: begin
      r32_mux_0_data[08:00] = i_out_ia_status[08:00]; 
      r32_mux_0_data[28:24] = i_out_ia_status[13:09]; 
      r32_mux_0_data[31:29] = i_out_ia_status[16:14]; 
    end
    `CR_HUF_COMP_OUT_IA_WDATA_PART0: begin
      r32_mux_0_data[05:00] = o_out_ia_wdata_part0[05:00]; 
      r32_mux_0_data[13:06] = o_out_ia_wdata_part0[13:06]; 
      r32_mux_0_data[14:14] = o_out_ia_wdata_part0[14:14]; 
      r32_mux_0_data[22:15] = o_out_ia_wdata_part0[22:15]; 
      r32_mux_0_data[30:23] = o_out_ia_wdata_part0[30:23]; 
      r32_mux_0_data[31:31] = o_out_ia_wdata_part0[31:31]; 
    end
    `CR_HUF_COMP_OUT_IA_WDATA_PART1: begin
      r32_mux_0_data[31:00] = o_out_ia_wdata_part1[31:00]; 
    end
    `CR_HUF_COMP_OUT_IA_WDATA_PART2: begin
      r32_mux_0_data[31:00] = o_out_ia_wdata_part2[31:00]; 
    end
    `CR_HUF_COMP_OUT_IA_CONFIG: begin
      r32_mux_0_data[08:00] = o_out_ia_config[08:00]; 
      r32_mux_0_data[31:28] = o_out_ia_config[12:09]; 
    end
    `CR_HUF_COMP_OUT_IA_RDATA_PART0: begin
      r32_mux_0_data[05:00] = i_out_ia_rdata_part0[05:00]; 
      r32_mux_0_data[13:06] = i_out_ia_rdata_part0[13:06]; 
      r32_mux_0_data[14:14] = i_out_ia_rdata_part0[14:14]; 
      r32_mux_0_data[22:15] = i_out_ia_rdata_part0[22:15]; 
      r32_mux_0_data[30:23] = i_out_ia_rdata_part0[30:23]; 
      r32_mux_0_data[31:31] = i_out_ia_rdata_part0[31:31]; 
    end
    `CR_HUF_COMP_OUT_IA_RDATA_PART1: begin
      r32_mux_0_data[31:00] = i_out_ia_rdata_part1[31:00]; 
    end
    `CR_HUF_COMP_OUT_IA_RDATA_PART2: begin
      r32_mux_0_data[31:00] = i_out_ia_rdata_part2[31:00]; 
    end
    `CR_HUF_COMP_OUT_IM_CONFIG: begin
      r32_mux_0_data[09:00] = o_out_im_config[09:00]; 
      r32_mux_0_data[31:30] = o_out_im_config[11:10]; 
    end
    `CR_HUF_COMP_OUT_IM_STATUS: begin
      r32_mux_0_data[08:00] = i_out_im_status[08:00]; 
      r32_mux_0_data[29:29] = i_out_im_status[09:09]; 
      r32_mux_0_data[30:30] = i_out_im_status[10:10]; 
      r32_mux_0_data[31:31] = i_out_im_status[11:11]; 
    end
    `CR_HUF_COMP_OUT_IM_READ_DONE: begin
      r32_mux_0_data[30:30] = i_out_im_read_done[00:00]; 
      r32_mux_0_data[31:31] = i_out_im_read_done[01:01]; 
    end
    `CR_HUF_COMP_SH_BL_IA_CAPABILITY: begin
      r32_mux_0_data[00:00] = i_sh_bl_ia_capability[00:00]; 
      r32_mux_0_data[01:01] = i_sh_bl_ia_capability[01:01]; 
      r32_mux_0_data[02:02] = i_sh_bl_ia_capability[02:02]; 
      r32_mux_0_data[03:03] = i_sh_bl_ia_capability[03:03]; 
      r32_mux_0_data[04:04] = i_sh_bl_ia_capability[04:04]; 
      r32_mux_0_data[05:05] = i_sh_bl_ia_capability[05:05]; 
      r32_mux_0_data[06:06] = i_sh_bl_ia_capability[06:06]; 
      r32_mux_0_data[07:07] = i_sh_bl_ia_capability[07:07]; 
      r32_mux_0_data[08:08] = i_sh_bl_ia_capability[08:08]; 
      r32_mux_0_data[09:09] = i_sh_bl_ia_capability[09:09]; 
      r32_mux_0_data[13:10] = i_sh_bl_ia_capability[13:10]; 
      r32_mux_0_data[14:14] = i_sh_bl_ia_capability[14:14]; 
      r32_mux_0_data[15:15] = i_sh_bl_ia_capability[15:15]; 
      r32_mux_0_data[31:28] = i_sh_bl_ia_capability[19:16]; 
    end
    endcase

    case (ws_read_addr)
    `CR_HUF_COMP_SH_BL_IA_STATUS: begin
      r32_mux_1_data[07:00] = i_sh_bl_ia_status[07:00]; 
      r32_mux_1_data[28:24] = i_sh_bl_ia_status[12:08]; 
      r32_mux_1_data[31:29] = i_sh_bl_ia_status[15:13]; 
    end
    `CR_HUF_COMP_SH_BL_IA_WDATA_PART0: begin
      r32_mux_1_data[20:00] = o_sh_bl_ia_wdata_part0[20:00]; 
      r32_mux_1_data[21:21] = o_sh_bl_ia_wdata_part0[21:21]; 
      r32_mux_1_data[22:22] = o_sh_bl_ia_wdata_part0[22:22]; 
      r32_mux_1_data[23:23] = o_sh_bl_ia_wdata_part0[23:23]; 
      r32_mux_1_data[30:24] = o_sh_bl_ia_wdata_part0[30:24]; 
      r32_mux_1_data[31:31] = o_sh_bl_ia_wdata_part0[31:31]; 
    end
    `CR_HUF_COMP_SH_BL_IA_WDATA_PART1: begin
      r32_mux_1_data[31:00] = o_sh_bl_ia_wdata_part1[31:00]; 
    end
    `CR_HUF_COMP_SH_BL_IA_WDATA_PART2: begin
      r32_mux_1_data[31:00] = o_sh_bl_ia_wdata_part2[31:00]; 
    end
    `CR_HUF_COMP_SH_BL_IA_CONFIG: begin
      r32_mux_1_data[07:00] = o_sh_bl_ia_config[07:00]; 
      r32_mux_1_data[31:28] = o_sh_bl_ia_config[11:08]; 
    end
    `CR_HUF_COMP_SH_BL_IA_RDATA_PART0: begin
      r32_mux_1_data[20:00] = i_sh_bl_ia_rdata_part0[20:00]; 
      r32_mux_1_data[21:21] = i_sh_bl_ia_rdata_part0[21:21]; 
      r32_mux_1_data[22:22] = i_sh_bl_ia_rdata_part0[22:22]; 
      r32_mux_1_data[23:23] = i_sh_bl_ia_rdata_part0[23:23]; 
      r32_mux_1_data[30:24] = i_sh_bl_ia_rdata_part0[30:24]; 
      r32_mux_1_data[31:31] = i_sh_bl_ia_rdata_part0[31:31]; 
    end
    `CR_HUF_COMP_SH_BL_IA_RDATA_PART1: begin
      r32_mux_1_data[31:00] = i_sh_bl_ia_rdata_part1[31:00]; 
    end
    `CR_HUF_COMP_SH_BL_IA_RDATA_PART2: begin
      r32_mux_1_data[31:00] = i_sh_bl_ia_rdata_part2[31:00]; 
    end
    `CR_HUF_COMP_SH_BL_IM_CONFIG: begin
      r32_mux_1_data[07:00] = o_sh_bl_im_config[07:00]; 
      r32_mux_1_data[31:30] = o_sh_bl_im_config[09:08]; 
    end
    `CR_HUF_COMP_SH_BL_IM_STATUS: begin
      r32_mux_1_data[07:00] = i_sh_bl_im_status[07:00]; 
      r32_mux_1_data[29:29] = i_sh_bl_im_status[08:08]; 
      r32_mux_1_data[30:30] = i_sh_bl_im_status[09:09]; 
      r32_mux_1_data[31:31] = i_sh_bl_im_status[10:10]; 
    end
    `CR_HUF_COMP_SH_BL_IM_READ_DONE: begin
      r32_mux_1_data[30:30] = i_sh_bl_im_read_done[00:00]; 
      r32_mux_1_data[31:31] = i_sh_bl_im_read_done[01:01]; 
    end
    `CR_HUF_COMP_LNG_BL_IA_CAPABILITY: begin
      r32_mux_1_data[00:00] = i_lng_bl_ia_capability[00:00]; 
      r32_mux_1_data[01:01] = i_lng_bl_ia_capability[01:01]; 
      r32_mux_1_data[02:02] = i_lng_bl_ia_capability[02:02]; 
      r32_mux_1_data[03:03] = i_lng_bl_ia_capability[03:03]; 
      r32_mux_1_data[04:04] = i_lng_bl_ia_capability[04:04]; 
      r32_mux_1_data[05:05] = i_lng_bl_ia_capability[05:05]; 
      r32_mux_1_data[06:06] = i_lng_bl_ia_capability[06:06]; 
      r32_mux_1_data[07:07] = i_lng_bl_ia_capability[07:07]; 
      r32_mux_1_data[08:08] = i_lng_bl_ia_capability[08:08]; 
      r32_mux_1_data[09:09] = i_lng_bl_ia_capability[09:09]; 
      r32_mux_1_data[13:10] = i_lng_bl_ia_capability[13:10]; 
      r32_mux_1_data[14:14] = i_lng_bl_ia_capability[14:14]; 
      r32_mux_1_data[15:15] = i_lng_bl_ia_capability[15:15]; 
      r32_mux_1_data[31:28] = i_lng_bl_ia_capability[19:16]; 
    end
    `CR_HUF_COMP_LNG_BL_IA_STATUS: begin
      r32_mux_1_data[05:00] = i_lng_bl_ia_status[05:00]; 
      r32_mux_1_data[28:24] = i_lng_bl_ia_status[10:06]; 
      r32_mux_1_data[31:29] = i_lng_bl_ia_status[13:11]; 
    end
    `CR_HUF_COMP_LNG_BL_IA_WDATA_PART0: begin
      r32_mux_1_data[20:00] = o_lng_bl_ia_wdata_part0[20:00]; 
      r32_mux_1_data[21:21] = o_lng_bl_ia_wdata_part0[21:21]; 
      r32_mux_1_data[22:22] = o_lng_bl_ia_wdata_part0[22:22]; 
      r32_mux_1_data[23:23] = o_lng_bl_ia_wdata_part0[23:23]; 
      r32_mux_1_data[30:24] = o_lng_bl_ia_wdata_part0[30:24]; 
      r32_mux_1_data[31:31] = o_lng_bl_ia_wdata_part0[31:31]; 
    end
    `CR_HUF_COMP_LNG_BL_IA_WDATA_PART1: begin
      r32_mux_1_data[31:00] = o_lng_bl_ia_wdata_part1[31:00]; 
    end
    `CR_HUF_COMP_LNG_BL_IA_WDATA_PART2: begin
      r32_mux_1_data[31:00] = o_lng_bl_ia_wdata_part2[31:00]; 
    end
    `CR_HUF_COMP_LNG_BL_IA_CONFIG: begin
      r32_mux_1_data[05:00] = o_lng_bl_ia_config[05:00]; 
      r32_mux_1_data[31:28] = o_lng_bl_ia_config[09:06]; 
    end
    `CR_HUF_COMP_LNG_BL_IA_RDATA_PART0: begin
      r32_mux_1_data[20:00] = i_lng_bl_ia_rdata_part0[20:00]; 
      r32_mux_1_data[21:21] = i_lng_bl_ia_rdata_part0[21:21]; 
      r32_mux_1_data[22:22] = i_lng_bl_ia_rdata_part0[22:22]; 
      r32_mux_1_data[23:23] = i_lng_bl_ia_rdata_part0[23:23]; 
      r32_mux_1_data[30:24] = i_lng_bl_ia_rdata_part0[30:24]; 
      r32_mux_1_data[31:31] = i_lng_bl_ia_rdata_part0[31:31]; 
    end
    `CR_HUF_COMP_LNG_BL_IA_RDATA_PART1: begin
      r32_mux_1_data[31:00] = i_lng_bl_ia_rdata_part1[31:00]; 
    end
    `CR_HUF_COMP_LNG_BL_IA_RDATA_PART2: begin
      r32_mux_1_data[31:00] = i_lng_bl_ia_rdata_part2[31:00]; 
    end
    `CR_HUF_COMP_LNG_BL_IM_CONFIG: begin
      r32_mux_1_data[05:00] = o_lng_bl_im_config[05:00]; 
      r32_mux_1_data[31:30] = o_lng_bl_im_config[07:06]; 
    end
    `CR_HUF_COMP_LNG_BL_IM_STATUS: begin
      r32_mux_1_data[05:00] = i_lng_bl_im_status[05:00]; 
      r32_mux_1_data[29:29] = i_lng_bl_im_status[06:06]; 
      r32_mux_1_data[30:30] = i_lng_bl_im_status[07:07]; 
      r32_mux_1_data[31:31] = i_lng_bl_im_status[08:08]; 
    end
    `CR_HUF_COMP_LNG_BL_IM_READ_DONE: begin
      r32_mux_1_data[30:30] = i_lng_bl_im_read_done[00:00]; 
      r32_mux_1_data[31:31] = i_lng_bl_im_read_done[01:01]; 
    end
    `CR_HUF_COMP_ST_SH_BL_IA_CAPABILITY: begin
      r32_mux_1_data[00:00] = i_st_sh_bl_ia_capability[00:00]; 
      r32_mux_1_data[01:01] = i_st_sh_bl_ia_capability[01:01]; 
      r32_mux_1_data[02:02] = i_st_sh_bl_ia_capability[02:02]; 
      r32_mux_1_data[03:03] = i_st_sh_bl_ia_capability[03:03]; 
      r32_mux_1_data[04:04] = i_st_sh_bl_ia_capability[04:04]; 
      r32_mux_1_data[05:05] = i_st_sh_bl_ia_capability[05:05]; 
      r32_mux_1_data[06:06] = i_st_sh_bl_ia_capability[06:06]; 
      r32_mux_1_data[07:07] = i_st_sh_bl_ia_capability[07:07]; 
      r32_mux_1_data[08:08] = i_st_sh_bl_ia_capability[08:08]; 
      r32_mux_1_data[09:09] = i_st_sh_bl_ia_capability[09:09]; 
      r32_mux_1_data[13:10] = i_st_sh_bl_ia_capability[13:10]; 
      r32_mux_1_data[14:14] = i_st_sh_bl_ia_capability[14:14]; 
      r32_mux_1_data[15:15] = i_st_sh_bl_ia_capability[15:15]; 
      r32_mux_1_data[31:28] = i_st_sh_bl_ia_capability[19:16]; 
    end
    `CR_HUF_COMP_ST_SH_BL_IA_STATUS: begin
      r32_mux_1_data[03:00] = i_st_sh_bl_ia_status[03:00]; 
      r32_mux_1_data[28:24] = i_st_sh_bl_ia_status[08:04]; 
      r32_mux_1_data[31:29] = i_st_sh_bl_ia_status[11:09]; 
    end
    `CR_HUF_COMP_ST_SH_BL_IA_WDATA_PART0: begin
      r32_mux_1_data[20:00] = o_st_sh_bl_ia_wdata_part0[20:00]; 
      r32_mux_1_data[21:21] = o_st_sh_bl_ia_wdata_part0[21:21]; 
      r32_mux_1_data[22:22] = o_st_sh_bl_ia_wdata_part0[22:22]; 
      r32_mux_1_data[23:23] = o_st_sh_bl_ia_wdata_part0[23:23]; 
      r32_mux_1_data[30:24] = o_st_sh_bl_ia_wdata_part0[30:24]; 
      r32_mux_1_data[31:31] = o_st_sh_bl_ia_wdata_part0[31:31]; 
    end
    `CR_HUF_COMP_ST_SH_BL_IA_WDATA_PART1: begin
      r32_mux_1_data[31:00] = o_st_sh_bl_ia_wdata_part1[31:00]; 
    end
    `CR_HUF_COMP_ST_SH_BL_IA_WDATA_PART2: begin
      r32_mux_1_data[31:00] = o_st_sh_bl_ia_wdata_part2[31:00]; 
    end
    endcase

    case (ws_read_addr)
    `CR_HUF_COMP_ST_SH_BL_IA_CONFIG: begin
      r32_mux_2_data[03:00] = o_st_sh_bl_ia_config[03:00]; 
      r32_mux_2_data[31:28] = o_st_sh_bl_ia_config[07:04]; 
    end
    `CR_HUF_COMP_ST_SH_BL_IA_RDATA_PART0: begin
      r32_mux_2_data[20:00] = i_st_sh_bl_ia_rdata_part0[20:00]; 
      r32_mux_2_data[21:21] = i_st_sh_bl_ia_rdata_part0[21:21]; 
      r32_mux_2_data[22:22] = i_st_sh_bl_ia_rdata_part0[22:22]; 
      r32_mux_2_data[23:23] = i_st_sh_bl_ia_rdata_part0[23:23]; 
      r32_mux_2_data[30:24] = i_st_sh_bl_ia_rdata_part0[30:24]; 
      r32_mux_2_data[31:31] = i_st_sh_bl_ia_rdata_part0[31:31]; 
    end
    `CR_HUF_COMP_ST_SH_BL_IA_RDATA_PART1: begin
      r32_mux_2_data[31:00] = i_st_sh_bl_ia_rdata_part1[31:00]; 
    end
    `CR_HUF_COMP_ST_SH_BL_IA_RDATA_PART2: begin
      r32_mux_2_data[31:00] = i_st_sh_bl_ia_rdata_part2[31:00]; 
    end
    `CR_HUF_COMP_ST_SH_BL_IM_CONFIG: begin
      r32_mux_2_data[03:00] = o_st_sh_bl_im_config[03:00]; 
      r32_mux_2_data[31:30] = o_st_sh_bl_im_config[05:04]; 
    end
    `CR_HUF_COMP_ST_SH_BL_IM_STATUS: begin
      r32_mux_2_data[03:00] = i_st_sh_bl_im_status[03:00]; 
      r32_mux_2_data[29:29] = i_st_sh_bl_im_status[04:04]; 
      r32_mux_2_data[30:30] = i_st_sh_bl_im_status[05:05]; 
      r32_mux_2_data[31:31] = i_st_sh_bl_im_status[06:06]; 
    end
    `CR_HUF_COMP_ST_SH_BL_IM_READ_DONE: begin
      r32_mux_2_data[30:30] = i_st_sh_bl_im_read_done[00:00]; 
      r32_mux_2_data[31:31] = i_st_sh_bl_im_read_done[01:01]; 
    end
    `CR_HUF_COMP_ST_LNG_BL_IA_CAPABILITY: begin
      r32_mux_2_data[00:00] = i_st_lng_bl_ia_capability[00:00]; 
      r32_mux_2_data[01:01] = i_st_lng_bl_ia_capability[01:01]; 
      r32_mux_2_data[02:02] = i_st_lng_bl_ia_capability[02:02]; 
      r32_mux_2_data[03:03] = i_st_lng_bl_ia_capability[03:03]; 
      r32_mux_2_data[04:04] = i_st_lng_bl_ia_capability[04:04]; 
      r32_mux_2_data[05:05] = i_st_lng_bl_ia_capability[05:05]; 
      r32_mux_2_data[06:06] = i_st_lng_bl_ia_capability[06:06]; 
      r32_mux_2_data[07:07] = i_st_lng_bl_ia_capability[07:07]; 
      r32_mux_2_data[08:08] = i_st_lng_bl_ia_capability[08:08]; 
      r32_mux_2_data[09:09] = i_st_lng_bl_ia_capability[09:09]; 
      r32_mux_2_data[13:10] = i_st_lng_bl_ia_capability[13:10]; 
      r32_mux_2_data[14:14] = i_st_lng_bl_ia_capability[14:14]; 
      r32_mux_2_data[15:15] = i_st_lng_bl_ia_capability[15:15]; 
      r32_mux_2_data[31:28] = i_st_lng_bl_ia_capability[19:16]; 
    end
    `CR_HUF_COMP_ST_LNG_BL_IA_STATUS: begin
      r32_mux_2_data[03:00] = i_st_lng_bl_ia_status[03:00]; 
      r32_mux_2_data[28:24] = i_st_lng_bl_ia_status[08:04]; 
      r32_mux_2_data[31:29] = i_st_lng_bl_ia_status[11:09]; 
    end
    `CR_HUF_COMP_ST_LNG_BL_IA_WDATA_PART0: begin
      r32_mux_2_data[20:00] = o_st_lng_bl_ia_wdata_part0[20:00]; 
      r32_mux_2_data[21:21] = o_st_lng_bl_ia_wdata_part0[21:21]; 
      r32_mux_2_data[22:22] = o_st_lng_bl_ia_wdata_part0[22:22]; 
      r32_mux_2_data[23:23] = o_st_lng_bl_ia_wdata_part0[23:23]; 
      r32_mux_2_data[30:24] = o_st_lng_bl_ia_wdata_part0[30:24]; 
      r32_mux_2_data[31:31] = o_st_lng_bl_ia_wdata_part0[31:31]; 
    end
    `CR_HUF_COMP_ST_LNG_BL_IA_WDATA_PART1: begin
      r32_mux_2_data[31:00] = o_st_lng_bl_ia_wdata_part1[31:00]; 
    end
    `CR_HUF_COMP_ST_LNG_BL_IA_WDATA_PART2: begin
      r32_mux_2_data[31:00] = o_st_lng_bl_ia_wdata_part2[31:00]; 
    end
    `CR_HUF_COMP_ST_LNG_BL_IA_CONFIG: begin
      r32_mux_2_data[03:00] = o_st_lng_bl_ia_config[03:00]; 
      r32_mux_2_data[31:28] = o_st_lng_bl_ia_config[07:04]; 
    end
    `CR_HUF_COMP_ST_LNG_BL_IA_RDATA_PART0: begin
      r32_mux_2_data[20:00] = i_st_lng_bl_ia_rdata_part0[20:00]; 
      r32_mux_2_data[21:21] = i_st_lng_bl_ia_rdata_part0[21:21]; 
      r32_mux_2_data[22:22] = i_st_lng_bl_ia_rdata_part0[22:22]; 
      r32_mux_2_data[23:23] = i_st_lng_bl_ia_rdata_part0[23:23]; 
      r32_mux_2_data[30:24] = i_st_lng_bl_ia_rdata_part0[30:24]; 
      r32_mux_2_data[31:31] = i_st_lng_bl_ia_rdata_part0[31:31]; 
    end
    `CR_HUF_COMP_ST_LNG_BL_IA_RDATA_PART1: begin
      r32_mux_2_data[31:00] = i_st_lng_bl_ia_rdata_part1[31:00]; 
    end
    `CR_HUF_COMP_ST_LNG_BL_IA_RDATA_PART2: begin
      r32_mux_2_data[31:00] = i_st_lng_bl_ia_rdata_part2[31:00]; 
    end
    `CR_HUF_COMP_ST_LNG_BL_IM_CONFIG: begin
      r32_mux_2_data[03:00] = o_st_lng_bl_im_config[03:00]; 
      r32_mux_2_data[31:30] = o_st_lng_bl_im_config[05:04]; 
    end
    `CR_HUF_COMP_ST_LNG_BL_IM_STATUS: begin
      r32_mux_2_data[03:00] = i_st_lng_bl_im_status[03:00]; 
      r32_mux_2_data[29:29] = i_st_lng_bl_im_status[04:04]; 
      r32_mux_2_data[30:30] = i_st_lng_bl_im_status[05:05]; 
      r32_mux_2_data[31:31] = i_st_lng_bl_im_status[06:06]; 
    end
    `CR_HUF_COMP_ST_LNG_BL_IM_READ_DONE: begin
      r32_mux_2_data[30:30] = i_st_lng_bl_im_read_done[00:00]; 
      r32_mux_2_data[31:31] = i_st_lng_bl_im_read_done[01:01]; 
    end
    `CR_HUF_COMP_SM_IN_TLV_PARSE_ACTION_0: begin
      r32_mux_2_data[01:00] = o_sm_in_tlv_parse_action_0[01:00]; 
      r32_mux_2_data[03:02] = o_sm_in_tlv_parse_action_0[03:02]; 
      r32_mux_2_data[05:04] = o_sm_in_tlv_parse_action_0[05:04]; 
      r32_mux_2_data[07:06] = o_sm_in_tlv_parse_action_0[07:06]; 
      r32_mux_2_data[09:08] = o_sm_in_tlv_parse_action_0[09:08]; 
      r32_mux_2_data[11:10] = o_sm_in_tlv_parse_action_0[11:10]; 
      r32_mux_2_data[13:12] = o_sm_in_tlv_parse_action_0[13:12]; 
      r32_mux_2_data[15:14] = o_sm_in_tlv_parse_action_0[15:14]; 
      r32_mux_2_data[17:16] = o_sm_in_tlv_parse_action_0[17:16]; 
      r32_mux_2_data[19:18] = o_sm_in_tlv_parse_action_0[19:18]; 
      r32_mux_2_data[21:20] = o_sm_in_tlv_parse_action_0[21:20]; 
      r32_mux_2_data[23:22] = o_sm_in_tlv_parse_action_0[23:22]; 
      r32_mux_2_data[25:24] = o_sm_in_tlv_parse_action_0[25:24]; 
      r32_mux_2_data[27:26] = o_sm_in_tlv_parse_action_0[27:26]; 
      r32_mux_2_data[29:28] = o_sm_in_tlv_parse_action_0[29:28]; 
      r32_mux_2_data[31:30] = o_sm_in_tlv_parse_action_0[31:30]; 
    end
    `CR_HUF_COMP_SM_IN_TLV_PARSE_ACTION_1: begin
      r32_mux_2_data[01:00] = o_sm_in_tlv_parse_action_1[01:00]; 
      r32_mux_2_data[03:02] = o_sm_in_tlv_parse_action_1[03:02]; 
      r32_mux_2_data[05:04] = o_sm_in_tlv_parse_action_1[05:04]; 
      r32_mux_2_data[07:06] = o_sm_in_tlv_parse_action_1[07:06]; 
      r32_mux_2_data[09:08] = o_sm_in_tlv_parse_action_1[09:08]; 
      r32_mux_2_data[11:10] = o_sm_in_tlv_parse_action_1[11:10]; 
      r32_mux_2_data[13:12] = o_sm_in_tlv_parse_action_1[13:12]; 
      r32_mux_2_data[15:14] = o_sm_in_tlv_parse_action_1[15:14]; 
      r32_mux_2_data[17:16] = o_sm_in_tlv_parse_action_1[17:16]; 
      r32_mux_2_data[19:18] = o_sm_in_tlv_parse_action_1[19:18]; 
      r32_mux_2_data[21:20] = o_sm_in_tlv_parse_action_1[21:20]; 
      r32_mux_2_data[23:22] = o_sm_in_tlv_parse_action_1[23:22]; 
      r32_mux_2_data[25:24] = o_sm_in_tlv_parse_action_1[25:24]; 
      r32_mux_2_data[27:26] = o_sm_in_tlv_parse_action_1[27:26]; 
      r32_mux_2_data[29:28] = o_sm_in_tlv_parse_action_1[29:28]; 
      r32_mux_2_data[31:30] = o_sm_in_tlv_parse_action_1[31:30]; 
    end
    `CR_HUF_COMP_SA_OUT_TLV_PARSE_ACTION_0: begin
      r32_mux_2_data[01:00] = o_sa_out_tlv_parse_action_0[01:00]; 
      r32_mux_2_data[03:02] = o_sa_out_tlv_parse_action_0[03:02]; 
      r32_mux_2_data[05:04] = o_sa_out_tlv_parse_action_0[05:04]; 
      r32_mux_2_data[07:06] = o_sa_out_tlv_parse_action_0[07:06]; 
      r32_mux_2_data[09:08] = o_sa_out_tlv_parse_action_0[09:08]; 
      r32_mux_2_data[11:10] = o_sa_out_tlv_parse_action_0[11:10]; 
      r32_mux_2_data[13:12] = o_sa_out_tlv_parse_action_0[13:12]; 
      r32_mux_2_data[15:14] = o_sa_out_tlv_parse_action_0[15:14]; 
      r32_mux_2_data[17:16] = o_sa_out_tlv_parse_action_0[17:16]; 
      r32_mux_2_data[19:18] = o_sa_out_tlv_parse_action_0[19:18]; 
      r32_mux_2_data[21:20] = o_sa_out_tlv_parse_action_0[21:20]; 
      r32_mux_2_data[23:22] = o_sa_out_tlv_parse_action_0[23:22]; 
      r32_mux_2_data[25:24] = o_sa_out_tlv_parse_action_0[25:24]; 
      r32_mux_2_data[27:26] = o_sa_out_tlv_parse_action_0[27:26]; 
      r32_mux_2_data[29:28] = o_sa_out_tlv_parse_action_0[29:28]; 
      r32_mux_2_data[31:30] = o_sa_out_tlv_parse_action_0[31:30]; 
    end
    `CR_HUF_COMP_SA_OUT_TLV_PARSE_ACTION_1: begin
      r32_mux_2_data[01:00] = o_sa_out_tlv_parse_action_1[01:00]; 
      r32_mux_2_data[03:02] = o_sa_out_tlv_parse_action_1[03:02]; 
      r32_mux_2_data[05:04] = o_sa_out_tlv_parse_action_1[05:04]; 
      r32_mux_2_data[07:06] = o_sa_out_tlv_parse_action_1[07:06]; 
      r32_mux_2_data[09:08] = o_sa_out_tlv_parse_action_1[09:08]; 
      r32_mux_2_data[11:10] = o_sa_out_tlv_parse_action_1[11:10]; 
      r32_mux_2_data[13:12] = o_sa_out_tlv_parse_action_1[13:12]; 
      r32_mux_2_data[15:14] = o_sa_out_tlv_parse_action_1[15:14]; 
      r32_mux_2_data[17:16] = o_sa_out_tlv_parse_action_1[17:16]; 
      r32_mux_2_data[19:18] = o_sa_out_tlv_parse_action_1[19:18]; 
      r32_mux_2_data[21:20] = o_sa_out_tlv_parse_action_1[21:20]; 
      r32_mux_2_data[23:22] = o_sa_out_tlv_parse_action_1[23:22]; 
      r32_mux_2_data[25:24] = o_sa_out_tlv_parse_action_1[25:24]; 
      r32_mux_2_data[27:26] = o_sa_out_tlv_parse_action_1[27:26]; 
      r32_mux_2_data[29:28] = o_sa_out_tlv_parse_action_1[29:28]; 
      r32_mux_2_data[31:30] = o_sa_out_tlv_parse_action_1[31:30]; 
    end
    `CR_HUF_COMP_SHORT_REBUILD_LIMIT_COUNT_A: begin
      r32_mux_2_data[11:00] = i_short_rebuild_limit_count_a[11:00]; 
    end
    `CR_HUF_COMP_LONG_REBUILD_LIMIT_COUNT_A: begin
      r32_mux_2_data[11:00] = i_long_rebuild_limit_count_a[11:00]; 
    end
    `CR_HUF_COMP_SHORT_ST_REBUILD_LIMIT_COUNT_A: begin
      r32_mux_2_data[11:00] = i_short_st_rebuild_limit_count_a[11:00]; 
    end
    `CR_HUF_COMP_LONG_ST_REBUILD_LIMIT_COUNT_A: begin
      r32_mux_2_data[11:00] = i_long_st_rebuild_limit_count_a[11:00]; 
    end
    `CR_HUF_COMP_SHORT_REBUILD_COUNT_A: begin
      r32_mux_2_data[31:00] = i_short_rebuild_count_a[31:00]; 
    end
    endcase

    case (ws_read_addr)
    `CR_HUF_COMP_LONG_REBUILD_COUNT_A: begin
      r32_mux_3_data[31:00] = i_long_rebuild_count_a[31:00]; 
    end
    `CR_HUF_COMP_SHORT_ST_REBUILD_COUNT_A: begin
      r32_mux_3_data[31:00] = i_short_st_rebuild_count_a[31:00]; 
    end
    `CR_HUF_COMP_LONG_ST_REBUILD_COUNT_A: begin
      r32_mux_3_data[31:00] = i_long_st_rebuild_count_a[31:00]; 
    end
    `CR_HUF_COMP_BIMC_MONITOR: begin
      r32_mux_3_data[00:00] = i_bimc_monitor[00:00]; 
      r32_mux_3_data[01:01] = i_bimc_monitor[01:01]; 
      r32_mux_3_data[02:02] = i_bimc_monitor[02:02]; 
      r32_mux_3_data[03:03] = i_bimc_monitor[03:03]; 
      r32_mux_3_data[04:04] = i_bimc_monitor[04:04]; 
      r32_mux_3_data[05:05] = i_bimc_monitor[05:05]; 
      r32_mux_3_data[06:06] = i_bimc_monitor[06:06]; 
    end
    `CR_HUF_COMP_BIMC_MONITOR_MASK: begin
      r32_mux_3_data[00:00] = o_bimc_monitor_mask[00:00]; 
      r32_mux_3_data[01:01] = o_bimc_monitor_mask[01:01]; 
      r32_mux_3_data[02:02] = o_bimc_monitor_mask[02:02]; 
      r32_mux_3_data[03:03] = o_bimc_monitor_mask[03:03]; 
      r32_mux_3_data[04:04] = o_bimc_monitor_mask[04:04]; 
      r32_mux_3_data[05:05] = o_bimc_monitor_mask[05:05]; 
      r32_mux_3_data[06:06] = o_bimc_monitor_mask[06:06]; 
    end
    `CR_HUF_COMP_BIMC_ECC_UNCORRECTABLE_ERROR_CNT: begin
      r32_mux_3_data[31:00] = i_bimc_ecc_uncorrectable_error_cnt[31:00]; 
    end
    `CR_HUF_COMP_BIMC_ECC_CORRECTABLE_ERROR_CNT: begin
      r32_mux_3_data[31:00] = i_bimc_ecc_correctable_error_cnt[31:00]; 
    end
    `CR_HUF_COMP_BIMC_PARITY_ERROR_CNT: begin
      r32_mux_3_data[31:00] = i_bimc_parity_error_cnt[31:00]; 
    end
    `CR_HUF_COMP_BIMC_GLOBAL_CONFIG: begin
      r32_mux_3_data[00:00] = i_bimc_global_config[00:00]; 
      r32_mux_3_data[01:01] = i_bimc_global_config[01:01]; 
      r32_mux_3_data[02:02] = i_bimc_global_config[02:02]; 
      r32_mux_3_data[03:03] = i_bimc_global_config[03:03]; 
      r32_mux_3_data[04:04] = i_bimc_global_config[04:04]; 
      r32_mux_3_data[05:05] = i_bimc_global_config[05:05]; 
      r32_mux_3_data[31:06] = i_bimc_global_config[31:06]; 
    end
    `CR_HUF_COMP_BIMC_MEMID: begin
      r32_mux_3_data[11:00] = i_bimc_memid[11:00]; 
    end
    `CR_HUF_COMP_BIMC_ECCPAR_DEBUG: begin
      r32_mux_3_data[11:00] = i_bimc_eccpar_debug[11:00]; 
      r32_mux_3_data[15:12] = i_bimc_eccpar_debug[15:12]; 
      r32_mux_3_data[17:16] = i_bimc_eccpar_debug[17:16]; 
      r32_mux_3_data[19:18] = i_bimc_eccpar_debug[19:18]; 
      r32_mux_3_data[21:20] = i_bimc_eccpar_debug[21:20]; 
      r32_mux_3_data[22:22] = i_bimc_eccpar_debug[22:22]; 
      r32_mux_3_data[23:23] = i_bimc_eccpar_debug[23:23]; 
      r32_mux_3_data[27:24] = i_bimc_eccpar_debug[27:24]; 
      r32_mux_3_data[28:28] = i_bimc_eccpar_debug[28:28]; 
    end
    `CR_HUF_COMP_BIMC_CMD2: begin
      r32_mux_3_data[07:00] = i_bimc_cmd2[07:00]; 
      r32_mux_3_data[08:08] = i_bimc_cmd2[08:08]; 
      r32_mux_3_data[09:09] = i_bimc_cmd2[09:09]; 
      r32_mux_3_data[10:10] = i_bimc_cmd2[10:10]; 
    end
    `CR_HUF_COMP_BIMC_CMD1: begin
      r32_mux_3_data[15:00] = o_bimc_cmd1[15:00]; 
      r32_mux_3_data[27:16] = o_bimc_cmd1[27:16]; 
      r32_mux_3_data[31:28] = o_bimc_cmd1[31:28]; 
    end
    `CR_HUF_COMP_BIMC_CMD0: begin
      r32_mux_3_data[31:00] = o_bimc_cmd0[31:00]; 
    end
    `CR_HUF_COMP_BIMC_RXCMD2: begin
      r32_mux_3_data[07:00] = i_bimc_rxcmd2[07:00]; 
      r32_mux_3_data[08:08] = i_bimc_rxcmd2[08:08]; 
      r32_mux_3_data[09:09] = i_bimc_rxcmd2[09:09]; 
    end
    `CR_HUF_COMP_BIMC_RXCMD1: begin
      r32_mux_3_data[15:00] = i_bimc_rxcmd1[15:00]; 
      r32_mux_3_data[27:16] = i_bimc_rxcmd1[27:16]; 
      r32_mux_3_data[31:28] = i_bimc_rxcmd1[31:28]; 
    end
    `CR_HUF_COMP_BIMC_RXCMD0: begin
      r32_mux_3_data[31:00] = i_bimc_rxcmd0[31:00]; 
    end
    `CR_HUF_COMP_BIMC_RXRSP2: begin
      r32_mux_3_data[07:00] = i_bimc_rxrsp2[07:00]; 
      r32_mux_3_data[08:08] = i_bimc_rxrsp2[08:08]; 
      r32_mux_3_data[09:09] = i_bimc_rxrsp2[09:09]; 
    end
    `CR_HUF_COMP_BIMC_RXRSP1: begin
      r32_mux_3_data[31:00] = i_bimc_rxrsp1[31:00]; 
    end
    `CR_HUF_COMP_BIMC_RXRSP0: begin
      r32_mux_3_data[31:00] = i_bimc_rxrsp0[31:00]; 
    end
    `CR_HUF_COMP_BIMC_POLLRSP2: begin
      r32_mux_3_data[07:00] = i_bimc_pollrsp2[07:00]; 
      r32_mux_3_data[08:08] = i_bimc_pollrsp2[08:08]; 
      r32_mux_3_data[09:09] = i_bimc_pollrsp2[09:09]; 
    end
    `CR_HUF_COMP_BIMC_POLLRSP1: begin
      r32_mux_3_data[31:00] = i_bimc_pollrsp1[31:00]; 
    end
    `CR_HUF_COMP_BIMC_POLLRSP0: begin
      r32_mux_3_data[31:00] = i_bimc_pollrsp0[31:00]; 
    end
    `CR_HUF_COMP_BIMC_DBGCMD2: begin
      r32_mux_3_data[07:00] = i_bimc_dbgcmd2[07:00]; 
      r32_mux_3_data[08:08] = i_bimc_dbgcmd2[08:08]; 
      r32_mux_3_data[09:09] = i_bimc_dbgcmd2[09:09]; 
    end
    `CR_HUF_COMP_BIMC_DBGCMD1: begin
      r32_mux_3_data[15:00] = i_bimc_dbgcmd1[15:00]; 
      r32_mux_3_data[27:16] = i_bimc_dbgcmd1[27:16]; 
      r32_mux_3_data[31:28] = i_bimc_dbgcmd1[31:28]; 
    end
    `CR_HUF_COMP_BIMC_DBGCMD0: begin
      r32_mux_3_data[31:00] = i_bimc_dbgcmd0[31:00]; 
    end
    `CR_HUF_COMP_GZIP_OS: begin
      r32_mux_3_data[07:00] = o_gzip_os[07:00]; 
    end
    endcase

  end

  
  

  
  

  reg  [31:0]  f32_data;

  assign o_reg_wr_data = f32_data;

  
  

  
  assign       o_rd_data  = (o_ack  & ~n_write) ? r32_formatted_reg_data : { 32 { 1'b0 } };
  

  
  

  wire w_load_spare_config                     = w_do_write & (ws_addr == `CR_HUF_COMP_SPARE_CONFIG);
  wire w_load_prefix_adj                       = w_do_write & (ws_addr == `CR_HUF_COMP_PREFIX_ADJ);
  wire w_load_henc_huff_win_size_in_entries    = w_do_write & (ws_addr == `CR_HUF_COMP_HENC_HUFF_WIN_SIZE_IN_ENTRIES);
  wire w_load_henc_xp9_first_blk_thrsh         = w_do_write & (ws_addr == `CR_HUF_COMP_HENC_XP9_FIRST_BLK_THRSH);
  wire w_load_short_ht_config                  = w_do_write & (ws_addr == `CR_HUF_COMP_SHORT_HT_CONFIG);
  wire w_load_long_ht_config                   = w_do_write & (ws_addr == `CR_HUF_COMP_LONG_HT_CONFIG);
  wire w_load_st_short_ht_config               = w_do_write & (ws_addr == `CR_HUF_COMP_ST_SHORT_HT_CONFIG);
  wire w_load_st_long_ht_config                = w_do_write & (ws_addr == `CR_HUF_COMP_ST_LONG_HT_CONFIG);
  wire w_load_xp9_disable_modes                = w_do_write & (ws_addr == `CR_HUF_COMP_XP9_DISABLE_MODES);
  wire w_load_xp10_disable_modes               = w_do_write & (ws_addr == `CR_HUF_COMP_XP10_DISABLE_MODES);
  wire w_load_deflate_disable_modes            = w_do_write & (ws_addr == `CR_HUF_COMP_DEFLATE_DISABLE_MODES);
  wire w_load_force_block_stall                = w_do_write & (ws_addr == `CR_HUF_COMP_FORCE_BLOCK_STALL);
  wire w_load_disable_sub_pipe                 = w_do_write & (ws_addr == `CR_HUF_COMP_DISABLE_SUB_PIPE);
  wire w_load_debug_control                    = w_do_write & (ws_addr == `CR_HUF_COMP_DEBUG_CONTROL);
  wire w_load_out_ia_wdata_part0               = w_do_write & (ws_addr == `CR_HUF_COMP_OUT_IA_WDATA_PART0);
  wire w_load_out_ia_wdata_part1               = w_do_write & (ws_addr == `CR_HUF_COMP_OUT_IA_WDATA_PART1);
  wire w_load_out_ia_wdata_part2               = w_do_write & (ws_addr == `CR_HUF_COMP_OUT_IA_WDATA_PART2);
  wire w_load_out_ia_config                    = w_do_write & (ws_addr == `CR_HUF_COMP_OUT_IA_CONFIG);
  wire w_load_out_im_config                    = w_do_write & (ws_addr == `CR_HUF_COMP_OUT_IM_CONFIG);
  wire w_load_out_im_read_done                 = w_do_write & (ws_addr == `CR_HUF_COMP_OUT_IM_READ_DONE);
  wire w_load_sh_bl_ia_wdata_part0             = w_do_write & (ws_addr == `CR_HUF_COMP_SH_BL_IA_WDATA_PART0);
  wire w_load_sh_bl_ia_wdata_part1             = w_do_write & (ws_addr == `CR_HUF_COMP_SH_BL_IA_WDATA_PART1);
  wire w_load_sh_bl_ia_wdata_part2             = w_do_write & (ws_addr == `CR_HUF_COMP_SH_BL_IA_WDATA_PART2);
  wire w_load_sh_bl_ia_config                  = w_do_write & (ws_addr == `CR_HUF_COMP_SH_BL_IA_CONFIG);
  wire w_load_sh_bl_im_config                  = w_do_write & (ws_addr == `CR_HUF_COMP_SH_BL_IM_CONFIG);
  wire w_load_sh_bl_im_read_done               = w_do_write & (ws_addr == `CR_HUF_COMP_SH_BL_IM_READ_DONE);
  wire w_load_lng_bl_ia_wdata_part0            = w_do_write & (ws_addr == `CR_HUF_COMP_LNG_BL_IA_WDATA_PART0);
  wire w_load_lng_bl_ia_wdata_part1            = w_do_write & (ws_addr == `CR_HUF_COMP_LNG_BL_IA_WDATA_PART1);
  wire w_load_lng_bl_ia_wdata_part2            = w_do_write & (ws_addr == `CR_HUF_COMP_LNG_BL_IA_WDATA_PART2);
  wire w_load_lng_bl_ia_config                 = w_do_write & (ws_addr == `CR_HUF_COMP_LNG_BL_IA_CONFIG);
  wire w_load_lng_bl_im_config                 = w_do_write & (ws_addr == `CR_HUF_COMP_LNG_BL_IM_CONFIG);
  wire w_load_lng_bl_im_read_done              = w_do_write & (ws_addr == `CR_HUF_COMP_LNG_BL_IM_READ_DONE);
  wire w_load_st_sh_bl_ia_wdata_part0          = w_do_write & (ws_addr == `CR_HUF_COMP_ST_SH_BL_IA_WDATA_PART0);
  wire w_load_st_sh_bl_ia_wdata_part1          = w_do_write & (ws_addr == `CR_HUF_COMP_ST_SH_BL_IA_WDATA_PART1);
  wire w_load_st_sh_bl_ia_wdata_part2          = w_do_write & (ws_addr == `CR_HUF_COMP_ST_SH_BL_IA_WDATA_PART2);
  wire w_load_st_sh_bl_ia_config               = w_do_write & (ws_addr == `CR_HUF_COMP_ST_SH_BL_IA_CONFIG);
  wire w_load_st_sh_bl_im_config               = w_do_write & (ws_addr == `CR_HUF_COMP_ST_SH_BL_IM_CONFIG);
  wire w_load_st_sh_bl_im_read_done            = w_do_write & (ws_addr == `CR_HUF_COMP_ST_SH_BL_IM_READ_DONE);
  wire w_load_st_lng_bl_ia_wdata_part0         = w_do_write & (ws_addr == `CR_HUF_COMP_ST_LNG_BL_IA_WDATA_PART0);
  wire w_load_st_lng_bl_ia_wdata_part1         = w_do_write & (ws_addr == `CR_HUF_COMP_ST_LNG_BL_IA_WDATA_PART1);
  wire w_load_st_lng_bl_ia_wdata_part2         = w_do_write & (ws_addr == `CR_HUF_COMP_ST_LNG_BL_IA_WDATA_PART2);
  wire w_load_st_lng_bl_ia_config              = w_do_write & (ws_addr == `CR_HUF_COMP_ST_LNG_BL_IA_CONFIG);
  wire w_load_st_lng_bl_im_config              = w_do_write & (ws_addr == `CR_HUF_COMP_ST_LNG_BL_IM_CONFIG);
  wire w_load_st_lng_bl_im_read_done           = w_do_write & (ws_addr == `CR_HUF_COMP_ST_LNG_BL_IM_READ_DONE);
  wire w_load_sm_in_tlv_parse_action_0         = w_do_write & (ws_addr == `CR_HUF_COMP_SM_IN_TLV_PARSE_ACTION_0);
  wire w_load_sm_in_tlv_parse_action_1         = w_do_write & (ws_addr == `CR_HUF_COMP_SM_IN_TLV_PARSE_ACTION_1);
  wire w_load_sa_out_tlv_parse_action_0        = w_do_write & (ws_addr == `CR_HUF_COMP_SA_OUT_TLV_PARSE_ACTION_0);
  wire w_load_sa_out_tlv_parse_action_1        = w_do_write & (ws_addr == `CR_HUF_COMP_SA_OUT_TLV_PARSE_ACTION_1);
  wire w_load_bimc_monitor_mask                = w_do_write & (ws_addr == `CR_HUF_COMP_BIMC_MONITOR_MASK);
  wire w_load_bimc_ecc_uncorrectable_error_cnt = w_do_write & (ws_addr == `CR_HUF_COMP_BIMC_ECC_UNCORRECTABLE_ERROR_CNT);
  wire w_load_bimc_ecc_correctable_error_cnt   = w_do_write & (ws_addr == `CR_HUF_COMP_BIMC_ECC_CORRECTABLE_ERROR_CNT);
  wire w_load_bimc_parity_error_cnt            = w_do_write & (ws_addr == `CR_HUF_COMP_BIMC_PARITY_ERROR_CNT);
  wire w_load_bimc_global_config               = w_do_write & (ws_addr == `CR_HUF_COMP_BIMC_GLOBAL_CONFIG);
  wire w_load_bimc_eccpar_debug                = w_do_write & (ws_addr == `CR_HUF_COMP_BIMC_ECCPAR_DEBUG);
  wire w_load_bimc_cmd2                        = w_do_write & (ws_addr == `CR_HUF_COMP_BIMC_CMD2);
  wire w_load_bimc_cmd1                        = w_do_write & (ws_addr == `CR_HUF_COMP_BIMC_CMD1);
  wire w_load_bimc_cmd0                        = w_do_write & (ws_addr == `CR_HUF_COMP_BIMC_CMD0);
  wire w_load_bimc_rxcmd2                      = w_do_write & (ws_addr == `CR_HUF_COMP_BIMC_RXCMD2);
  wire w_load_bimc_rxrsp2                      = w_do_write & (ws_addr == `CR_HUF_COMP_BIMC_RXRSP2);
  wire w_load_bimc_pollrsp2                    = w_do_write & (ws_addr == `CR_HUF_COMP_BIMC_POLLRSP2);
  wire w_load_bimc_dbgcmd2                     = w_do_write & (ws_addr == `CR_HUF_COMP_BIMC_DBGCMD2);
  wire w_load_gzip_os                          = w_do_write & (ws_addr == `CR_HUF_COMP_GZIP_OS);


  


  always_ff @(posedge clk or negedge i_reset_) begin
    if(~i_reset_) begin
      
      f_state        <= IDLE;
      f_ack          <= 0;
      f_err_ack      <= 0;
      f_prev_do_read <= 0;

      o_reg_addr     <= 0;
      o_reg_written  <= 0;
      o_reg_read     <= 0;

      f32_mux_0_data <= 0;
      f32_mux_1_data <= 0;
      f32_mux_2_data <= 0;
      f32_mux_3_data <= 0;

    end
    else if(i_sw_init) begin
      
      f_state        <= IDLE;
      f_ack          <= 0;
      f_err_ack      <= 0;
      f_prev_do_read <= 0;

      o_reg_addr     <= 0;
      o_reg_written  <= 0;
      o_reg_read     <= 0;

      f32_mux_0_data <= 0;
      f32_mux_1_data <= 0;
      f32_mux_2_data <= 0;
      f32_mux_3_data <= 0;

    end
    else begin
      f_state        <= w_next_state;
      f_ack          <= w_next_ack & !i_wr_strb & !i_rd_strb;
      f_err_ack      <= w_next_err_ack;
      f_prev_do_read <= w_do_read;

      if (i_wr_strb | i_rd_strb) o_reg_addr     <= i_addr;
      o_reg_written  <= (w_do_write & w_32b_aligned & w_valid_wr_addr);
      o_reg_read     <= (w_do_read  & w_32b_aligned & w_valid_rd_addr);

      if (w_do_read)             f32_mux_0_data <= r32_mux_0_data;
      if (w_do_read)             f32_mux_1_data <= r32_mux_1_data;
      if (w_do_read)             f32_mux_2_data <= r32_mux_2_data;
      if (w_do_read)             f32_mux_3_data <= r32_mux_3_data;

    end
  end

  
  always_ff @(posedge clk) begin
    if (i_wr_strb)               f32_data       <= i_wr_data;

  end
  

  cr_huf_comp_regs_flops u_cr_huf_comp_regs_flops (
        .clk                                    ( clk ),
        .i_reset_                               ( i_reset_ ),
        .i_sw_init                              ( i_sw_init ),
        .o_spare_config                         ( o_spare_config ),
        .o_prefix_adj                           ( o_prefix_adj ),
        .o_henc_huff_win_size_in_entries        ( o_henc_huff_win_size_in_entries ),
        .o_henc_xp9_first_blk_thrsh             ( o_henc_xp9_first_blk_thrsh ),
        .o_short_ht_config                      ( o_short_ht_config ),
        .o_long_ht_config                       ( o_long_ht_config ),
        .o_st_short_ht_config                   ( o_st_short_ht_config ),
        .o_st_long_ht_config                    ( o_st_long_ht_config ),
        .o_xp9_disable_modes                    ( o_xp9_disable_modes ),
        .o_xp10_disable_modes                   ( o_xp10_disable_modes ),
        .o_deflate_disable_modes                ( o_deflate_disable_modes ),
        .o_force_block_stall                    ( o_force_block_stall ),
        .o_disable_sub_pipe                     ( o_disable_sub_pipe ),
        .o_debug_control                        ( o_debug_control ),
        .o_out_ia_wdata_part0                   ( o_out_ia_wdata_part0 ),
        .o_out_ia_wdata_part1                   ( o_out_ia_wdata_part1 ),
        .o_out_ia_wdata_part2                   ( o_out_ia_wdata_part2 ),
        .o_out_ia_config                        ( o_out_ia_config ),
        .o_out_im_config                        ( o_out_im_config ),
        .o_out_im_read_done                     ( o_out_im_read_done ),
        .o_sh_bl_ia_wdata_part0                 ( o_sh_bl_ia_wdata_part0 ),
        .o_sh_bl_ia_wdata_part1                 ( o_sh_bl_ia_wdata_part1 ),
        .o_sh_bl_ia_wdata_part2                 ( o_sh_bl_ia_wdata_part2 ),
        .o_sh_bl_ia_config                      ( o_sh_bl_ia_config ),
        .o_sh_bl_im_config                      ( o_sh_bl_im_config ),
        .o_sh_bl_im_read_done                   ( o_sh_bl_im_read_done ),
        .o_lng_bl_ia_wdata_part0                ( o_lng_bl_ia_wdata_part0 ),
        .o_lng_bl_ia_wdata_part1                ( o_lng_bl_ia_wdata_part1 ),
        .o_lng_bl_ia_wdata_part2                ( o_lng_bl_ia_wdata_part2 ),
        .o_lng_bl_ia_config                     ( o_lng_bl_ia_config ),
        .o_lng_bl_im_config                     ( o_lng_bl_im_config ),
        .o_lng_bl_im_read_done                  ( o_lng_bl_im_read_done ),
        .o_st_sh_bl_ia_wdata_part0              ( o_st_sh_bl_ia_wdata_part0 ),
        .o_st_sh_bl_ia_wdata_part1              ( o_st_sh_bl_ia_wdata_part1 ),
        .o_st_sh_bl_ia_wdata_part2              ( o_st_sh_bl_ia_wdata_part2 ),
        .o_st_sh_bl_ia_config                   ( o_st_sh_bl_ia_config ),
        .o_st_sh_bl_im_config                   ( o_st_sh_bl_im_config ),
        .o_st_sh_bl_im_read_done                ( o_st_sh_bl_im_read_done ),
        .o_st_lng_bl_ia_wdata_part0             ( o_st_lng_bl_ia_wdata_part0 ),
        .o_st_lng_bl_ia_wdata_part1             ( o_st_lng_bl_ia_wdata_part1 ),
        .o_st_lng_bl_ia_wdata_part2             ( o_st_lng_bl_ia_wdata_part2 ),
        .o_st_lng_bl_ia_config                  ( o_st_lng_bl_ia_config ),
        .o_st_lng_bl_im_config                  ( o_st_lng_bl_im_config ),
        .o_st_lng_bl_im_read_done               ( o_st_lng_bl_im_read_done ),
        .o_sm_in_tlv_parse_action_0             ( o_sm_in_tlv_parse_action_0 ),
        .o_sm_in_tlv_parse_action_1             ( o_sm_in_tlv_parse_action_1 ),
        .o_sa_out_tlv_parse_action_0            ( o_sa_out_tlv_parse_action_0 ),
        .o_sa_out_tlv_parse_action_1            ( o_sa_out_tlv_parse_action_1 ),
        .o_bimc_monitor_mask                    ( o_bimc_monitor_mask ),
        .o_bimc_ecc_uncorrectable_error_cnt     ( o_bimc_ecc_uncorrectable_error_cnt ),
        .o_bimc_ecc_correctable_error_cnt       ( o_bimc_ecc_correctable_error_cnt ),
        .o_bimc_parity_error_cnt                ( o_bimc_parity_error_cnt ),
        .o_bimc_global_config                   ( o_bimc_global_config ),
        .o_bimc_eccpar_debug                    ( o_bimc_eccpar_debug ),
        .o_bimc_cmd2                            ( o_bimc_cmd2 ),
        .o_bimc_cmd1                            ( o_bimc_cmd1 ),
        .o_bimc_cmd0                            ( o_bimc_cmd0 ),
        .o_bimc_rxcmd2                          ( o_bimc_rxcmd2 ),
        .o_bimc_rxrsp2                          ( o_bimc_rxrsp2 ),
        .o_bimc_pollrsp2                        ( o_bimc_pollrsp2 ),
        .o_bimc_dbgcmd2                         ( o_bimc_dbgcmd2 ),
        .o_gzip_os                              ( o_gzip_os ),
        .w_load_spare_config                    ( w_load_spare_config ),
        .w_load_prefix_adj                      ( w_load_prefix_adj ),
        .w_load_henc_huff_win_size_in_entries   ( w_load_henc_huff_win_size_in_entries ),
        .w_load_henc_xp9_first_blk_thrsh        ( w_load_henc_xp9_first_blk_thrsh ),
        .w_load_short_ht_config                 ( w_load_short_ht_config ),
        .w_load_long_ht_config                  ( w_load_long_ht_config ),
        .w_load_st_short_ht_config              ( w_load_st_short_ht_config ),
        .w_load_st_long_ht_config               ( w_load_st_long_ht_config ),
        .w_load_xp9_disable_modes               ( w_load_xp9_disable_modes ),
        .w_load_xp10_disable_modes              ( w_load_xp10_disable_modes ),
        .w_load_deflate_disable_modes           ( w_load_deflate_disable_modes ),
        .w_load_force_block_stall               ( w_load_force_block_stall ),
        .w_load_disable_sub_pipe                ( w_load_disable_sub_pipe ),
        .w_load_debug_control                   ( w_load_debug_control ),
        .w_load_out_ia_wdata_part0              ( w_load_out_ia_wdata_part0 ),
        .w_load_out_ia_wdata_part1              ( w_load_out_ia_wdata_part1 ),
        .w_load_out_ia_wdata_part2              ( w_load_out_ia_wdata_part2 ),
        .w_load_out_ia_config                   ( w_load_out_ia_config ),
        .w_load_out_im_config                   ( w_load_out_im_config ),
        .w_load_out_im_read_done                ( w_load_out_im_read_done ),
        .w_load_sh_bl_ia_wdata_part0            ( w_load_sh_bl_ia_wdata_part0 ),
        .w_load_sh_bl_ia_wdata_part1            ( w_load_sh_bl_ia_wdata_part1 ),
        .w_load_sh_bl_ia_wdata_part2            ( w_load_sh_bl_ia_wdata_part2 ),
        .w_load_sh_bl_ia_config                 ( w_load_sh_bl_ia_config ),
        .w_load_sh_bl_im_config                 ( w_load_sh_bl_im_config ),
        .w_load_sh_bl_im_read_done              ( w_load_sh_bl_im_read_done ),
        .w_load_lng_bl_ia_wdata_part0           ( w_load_lng_bl_ia_wdata_part0 ),
        .w_load_lng_bl_ia_wdata_part1           ( w_load_lng_bl_ia_wdata_part1 ),
        .w_load_lng_bl_ia_wdata_part2           ( w_load_lng_bl_ia_wdata_part2 ),
        .w_load_lng_bl_ia_config                ( w_load_lng_bl_ia_config ),
        .w_load_lng_bl_im_config                ( w_load_lng_bl_im_config ),
        .w_load_lng_bl_im_read_done             ( w_load_lng_bl_im_read_done ),
        .w_load_st_sh_bl_ia_wdata_part0         ( w_load_st_sh_bl_ia_wdata_part0 ),
        .w_load_st_sh_bl_ia_wdata_part1         ( w_load_st_sh_bl_ia_wdata_part1 ),
        .w_load_st_sh_bl_ia_wdata_part2         ( w_load_st_sh_bl_ia_wdata_part2 ),
        .w_load_st_sh_bl_ia_config              ( w_load_st_sh_bl_ia_config ),
        .w_load_st_sh_bl_im_config              ( w_load_st_sh_bl_im_config ),
        .w_load_st_sh_bl_im_read_done           ( w_load_st_sh_bl_im_read_done ),
        .w_load_st_lng_bl_ia_wdata_part0        ( w_load_st_lng_bl_ia_wdata_part0 ),
        .w_load_st_lng_bl_ia_wdata_part1        ( w_load_st_lng_bl_ia_wdata_part1 ),
        .w_load_st_lng_bl_ia_wdata_part2        ( w_load_st_lng_bl_ia_wdata_part2 ),
        .w_load_st_lng_bl_ia_config             ( w_load_st_lng_bl_ia_config ),
        .w_load_st_lng_bl_im_config             ( w_load_st_lng_bl_im_config ),
        .w_load_st_lng_bl_im_read_done          ( w_load_st_lng_bl_im_read_done ),
        .w_load_sm_in_tlv_parse_action_0        ( w_load_sm_in_tlv_parse_action_0 ),
        .w_load_sm_in_tlv_parse_action_1        ( w_load_sm_in_tlv_parse_action_1 ),
        .w_load_sa_out_tlv_parse_action_0       ( w_load_sa_out_tlv_parse_action_0 ),
        .w_load_sa_out_tlv_parse_action_1       ( w_load_sa_out_tlv_parse_action_1 ),
        .w_load_bimc_monitor_mask               ( w_load_bimc_monitor_mask ),
        .w_load_bimc_ecc_uncorrectable_error_cnt ( w_load_bimc_ecc_uncorrectable_error_cnt ),
        .w_load_bimc_ecc_correctable_error_cnt  ( w_load_bimc_ecc_correctable_error_cnt ),
        .w_load_bimc_parity_error_cnt           ( w_load_bimc_parity_error_cnt ),
        .w_load_bimc_global_config              ( w_load_bimc_global_config ),
        .w_load_bimc_eccpar_debug               ( w_load_bimc_eccpar_debug ),
        .w_load_bimc_cmd2                       ( w_load_bimc_cmd2 ),
        .w_load_bimc_cmd1                       ( w_load_bimc_cmd1 ),
        .w_load_bimc_cmd0                       ( w_load_bimc_cmd0 ),
        .w_load_bimc_rxcmd2                     ( w_load_bimc_rxcmd2 ),
        .w_load_bimc_rxrsp2                     ( w_load_bimc_rxrsp2 ),
        .w_load_bimc_pollrsp2                   ( w_load_bimc_pollrsp2 ),
        .w_load_bimc_dbgcmd2                    ( w_load_bimc_dbgcmd2 ),
        .w_load_gzip_os                         ( w_load_gzip_os ),
        .f32_data                               ( f32_data )
  );

  

  

  `ifdef CR_HUF_COMP_DIGEST_28F943719C8A0BF8F0458E150F3D3E95
  `else
    initial begin
      $display("Error: the core decode file (cr_huf_comp_regs.sv) and include file (cr_huf_comp.vh) were compiled");
      $display("       from different rdb sources.  Please regenerate both files so they can be synchronized.");
      $display("");
      $finish;
    end
  `endif

  `ifdef REGISTER_ERROR_CODE_MONITOR_ENABLE
    always @(posedge clk)
      if (i_reset_) begin
        if (~w_valid_addr)
          $display($time, "Error: %m.i_addr = %x, o_err_ack  = 1'b%b, access to an address hole detected", i_addr, o_err_ack);
        else if (~w_valid_wr_addr & n_write)
          $display($time, "Warning: %m.i_addr = %x, o_err_ack  = 1'b%b, write to an read-only (RO) register detected", i_addr, o_err_ack);
      end
  `endif

  

endmodule


module cr_huf_comp_regs_flops (
  input                                         clk,
  input                                         i_reset_,
  input                                         i_sw_init,

  
  output reg [`CR_HUF_COMP_C_SPARE_T_DECL]      o_spare_config,
  output reg [`CR_HUF_COMP_C_HENC_SCH_UPDATE_PREFIX_ADJ_T_DECL] o_prefix_adj,
  output reg [`CR_HUF_COMP_C_HENC_HUFF_WIN_SIZE_IN_ENTRIES_T_DECL] o_henc_huff_win_size_in_entries,
  output reg [`CR_HUF_COMP_C_HENC_EX9_FIRST_BLK_THRESH_T_DECL] o_henc_xp9_first_blk_thrsh,
  output reg [`CR_HUF_COMP_C_HT_CONFIG_T_DECL]  o_short_ht_config,
  output reg [`CR_HUF_COMP_C_HT_CONFIG_T_DECL]  o_long_ht_config,
  output reg [`CR_HUF_COMP_C_SMALL_HT_CONFIG_T_DECL] o_st_short_ht_config,
  output reg [`CR_HUF_COMP_C_SMALL_HT_CONFIG_T_DECL] o_st_long_ht_config,
  output reg [`CR_HUF_COMP_C_HENC_XP9_DISABLE_MODES_T_DECL] o_xp9_disable_modes,
  output reg [`CR_HUF_COMP_C_HENC_XP10_DISABLE_MODES_T_DECL] o_xp10_disable_modes,
  output reg [`CR_HUF_COMP_C_HENC_DEFLATE_DISABLE_MODES_T_DECL] o_deflate_disable_modes,
  output reg [`CR_HUF_COMP_C_HENC_FORCE_BLOCK_STALL_T_DECL] o_force_block_stall,
  output reg [`CR_HUF_COMP_C_HENC_DISABLE_SUB_PIPE_T_DECL] o_disable_sub_pipe,
  output reg [`CR_HUF_COMP_C_HENC_DEBUG_CNTRL_T_DECL] o_debug_control,
  output reg [`CR_HUF_COMP_C_OUT_PART0_T_DECL]  o_out_ia_wdata_part0,
  output reg [`CR_HUF_COMP_C_OUT_PART1_T_DECL]  o_out_ia_wdata_part1,
  output reg [`CR_HUF_COMP_C_OUT_PART2_T_DECL]  o_out_ia_wdata_part2,
  output reg [`CR_HUF_COMP_C_OUT_IA_CONFIG_T_DECL] o_out_ia_config,
  output reg [`CR_HUF_COMP_C_OUT_IM_CONFIG_T_DECL] o_out_im_config,
  output reg [`CR_HUF_COMP_C_OUT_IM_CONSUMED_T_DECL] o_out_im_read_done,
  output reg [`CR_HUF_COMP_C_SH_BL_PART0_T_DECL] o_sh_bl_ia_wdata_part0,
  output reg [`CR_HUF_COMP_C_SH_BL_PART1_T_DECL] o_sh_bl_ia_wdata_part1,
  output reg [`CR_HUF_COMP_C_SH_BL_PART2_T_DECL] o_sh_bl_ia_wdata_part2,
  output reg [`CR_HUF_COMP_C_SH_BL_IA_CONFIG_T_DECL] o_sh_bl_ia_config,
  output reg [`CR_HUF_COMP_C_SH_BL_IM_CONFIG_T_DECL] o_sh_bl_im_config,
  output reg [`CR_HUF_COMP_C_SH_BL_IM_CONSUMED_T_DECL] o_sh_bl_im_read_done,
  output reg [`CR_HUF_COMP_C_LNG_BL_PART0_T_DECL] o_lng_bl_ia_wdata_part0,
  output reg [`CR_HUF_COMP_C_LNG_BL_PART1_T_DECL] o_lng_bl_ia_wdata_part1,
  output reg [`CR_HUF_COMP_C_LNG_BL_PART2_T_DECL] o_lng_bl_ia_wdata_part2,
  output reg [`CR_HUF_COMP_C_LNG_BL_IA_CONFIG_T_DECL] o_lng_bl_ia_config,
  output reg [`CR_HUF_COMP_C_LNG_BL_IM_CONFIG_T_DECL] o_lng_bl_im_config,
  output reg [`CR_HUF_COMP_C_LNG_BL_IM_CONSUMED_T_DECL] o_lng_bl_im_read_done,
  output reg [`CR_HUF_COMP_C_ST_SH_BL_PART0_T_DECL] o_st_sh_bl_ia_wdata_part0,
  output reg [`CR_HUF_COMP_C_ST_SH_BL_PART1_T_DECL] o_st_sh_bl_ia_wdata_part1,
  output reg [`CR_HUF_COMP_C_ST_SH_BL_PART2_T_DECL] o_st_sh_bl_ia_wdata_part2,
  output reg [`CR_HUF_COMP_C_ST_SH_BL_IA_CONFIG_T_DECL] o_st_sh_bl_ia_config,
  output reg [`CR_HUF_COMP_C_ST_SH_BL_IM_CONFIG_T_DECL] o_st_sh_bl_im_config,
  output reg [`CR_HUF_COMP_C_ST_SH_BL_IM_CONSUMED_T_DECL] o_st_sh_bl_im_read_done,
  output reg [`CR_HUF_COMP_C_ST_LNG_BL_PART0_T_DECL] o_st_lng_bl_ia_wdata_part0,
  output reg [`CR_HUF_COMP_C_ST_LNG_BL_PART1_T_DECL] o_st_lng_bl_ia_wdata_part1,
  output reg [`CR_HUF_COMP_C_ST_LNG_BL_PART2_T_DECL] o_st_lng_bl_ia_wdata_part2,
  output reg [`CR_HUF_COMP_C_ST_LNG_BL_IA_CONFIG_T_DECL] o_st_lng_bl_ia_config,
  output reg [`CR_HUF_COMP_C_ST_LNG_BL_IM_CONFIG_T_DECL] o_st_lng_bl_im_config,
  output reg [`CR_HUF_COMP_C_ST_LNG_BL_IM_CONSUMED_T_DECL] o_st_lng_bl_im_read_done,
  output reg [`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_31_0_T_DECL] o_sm_in_tlv_parse_action_0,
  output reg [`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_63_32_T_DECL] o_sm_in_tlv_parse_action_1,
  output reg [`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_31_0_T_DECL] o_sa_out_tlv_parse_action_0,
  output reg [`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_63_32_T_DECL] o_sa_out_tlv_parse_action_1,
  output reg [`CR_HUF_COMP_C_BIMC_MONITOR_MASK_T_DECL] o_bimc_monitor_mask,
  output reg [`CR_HUF_COMP_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_uncorrectable_error_cnt,
  output reg [`CR_HUF_COMP_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_correctable_error_cnt,
  output reg [`CR_HUF_COMP_C_BIMC_PARITY_ERROR_CNT_T_DECL] o_bimc_parity_error_cnt,
  output reg [`CR_HUF_COMP_C_BIMC_GLOBAL_CONFIG_T_DECL] o_bimc_global_config,
  output reg [`CR_HUF_COMP_C_BIMC_ECCPAR_DEBUG_T_DECL] o_bimc_eccpar_debug,
  output reg [`CR_HUF_COMP_C_BIMC_CMD2_T_DECL]  o_bimc_cmd2,
  output reg [`CR_HUF_COMP_C_BIMC_CMD1_T_DECL]  o_bimc_cmd1,
  output reg [`CR_HUF_COMP_C_BIMC_CMD0_T_DECL]  o_bimc_cmd0,
  output reg [`CR_HUF_COMP_C_BIMC_RXCMD2_T_DECL] o_bimc_rxcmd2,
  output reg [`CR_HUF_COMP_C_BIMC_RXRSP2_T_DECL] o_bimc_rxrsp2,
  output reg [`CR_HUF_COMP_C_BIMC_POLLRSP2_T_DECL] o_bimc_pollrsp2,
  output reg [`CR_HUF_COMP_C_BIMC_DBGCMD2_T_DECL] o_bimc_dbgcmd2,
  output reg [`CR_HUF_COMP_C_HENC_GZIP_OS_T_DECL] o_gzip_os,


  
  input                                         w_load_spare_config,
  input                                         w_load_prefix_adj,
  input                                         w_load_henc_huff_win_size_in_entries,
  input                                         w_load_henc_xp9_first_blk_thrsh,
  input                                         w_load_short_ht_config,
  input                                         w_load_long_ht_config,
  input                                         w_load_st_short_ht_config,
  input                                         w_load_st_long_ht_config,
  input                                         w_load_xp9_disable_modes,
  input                                         w_load_xp10_disable_modes,
  input                                         w_load_deflate_disable_modes,
  input                                         w_load_force_block_stall,
  input                                         w_load_disable_sub_pipe,
  input                                         w_load_debug_control,
  input                                         w_load_out_ia_wdata_part0,
  input                                         w_load_out_ia_wdata_part1,
  input                                         w_load_out_ia_wdata_part2,
  input                                         w_load_out_ia_config,
  input                                         w_load_out_im_config,
  input                                         w_load_out_im_read_done,
  input                                         w_load_sh_bl_ia_wdata_part0,
  input                                         w_load_sh_bl_ia_wdata_part1,
  input                                         w_load_sh_bl_ia_wdata_part2,
  input                                         w_load_sh_bl_ia_config,
  input                                         w_load_sh_bl_im_config,
  input                                         w_load_sh_bl_im_read_done,
  input                                         w_load_lng_bl_ia_wdata_part0,
  input                                         w_load_lng_bl_ia_wdata_part1,
  input                                         w_load_lng_bl_ia_wdata_part2,
  input                                         w_load_lng_bl_ia_config,
  input                                         w_load_lng_bl_im_config,
  input                                         w_load_lng_bl_im_read_done,
  input                                         w_load_st_sh_bl_ia_wdata_part0,
  input                                         w_load_st_sh_bl_ia_wdata_part1,
  input                                         w_load_st_sh_bl_ia_wdata_part2,
  input                                         w_load_st_sh_bl_ia_config,
  input                                         w_load_st_sh_bl_im_config,
  input                                         w_load_st_sh_bl_im_read_done,
  input                                         w_load_st_lng_bl_ia_wdata_part0,
  input                                         w_load_st_lng_bl_ia_wdata_part1,
  input                                         w_load_st_lng_bl_ia_wdata_part2,
  input                                         w_load_st_lng_bl_ia_config,
  input                                         w_load_st_lng_bl_im_config,
  input                                         w_load_st_lng_bl_im_read_done,
  input                                         w_load_sm_in_tlv_parse_action_0,
  input                                         w_load_sm_in_tlv_parse_action_1,
  input                                         w_load_sa_out_tlv_parse_action_0,
  input                                         w_load_sa_out_tlv_parse_action_1,
  input                                         w_load_bimc_monitor_mask,
  input                                         w_load_bimc_ecc_uncorrectable_error_cnt,
  input                                         w_load_bimc_ecc_correctable_error_cnt,
  input                                         w_load_bimc_parity_error_cnt,
  input                                         w_load_bimc_global_config,
  input                                         w_load_bimc_eccpar_debug,
  input                                         w_load_bimc_cmd2,
  input                                         w_load_bimc_cmd1,
  input                                         w_load_bimc_cmd0,
  input                                         w_load_bimc_rxcmd2,
  input                                         w_load_bimc_rxrsp2,
  input                                         w_load_bimc_pollrsp2,
  input                                         w_load_bimc_dbgcmd2,
  input                                         w_load_gzip_os,

  input      [31:0]                             f32_data
  );

  
  

  
  

  
  
  
  always_ff @(posedge clk or negedge i_reset_) begin
    if(~i_reset_) begin
      
      o_spare_config[31:00]                     <= 32'd0; 
      o_prefix_adj[01:00]                       <= 2'd0; 
      o_henc_huff_win_size_in_entries[14:00]    <= 15'd8192; 
      o_henc_xp9_first_blk_thrsh[22:00]         <= 23'd8192; 
      o_short_ht_config[02:00]                  <= 3'd0; 
      o_short_ht_config[12:03]                  <= 10'd1023; 
      o_short_ht_config[17:13]                  <= 5'd27; 
      o_short_ht_config[22:18]                  <= 5'd15; 
      o_long_ht_config[02:00]                   <= 3'd0; 
      o_long_ht_config[12:03]                   <= 10'd1023; 
      o_long_ht_config[17:13]                   <= 5'd27; 
      o_long_ht_config[22:18]                   <= 5'd15; 
      o_st_short_ht_config[02:00]               <= 3'd0; 
      o_st_short_ht_config[12:03]               <= 10'd1023; 
      o_st_short_ht_config[16:13]               <= 4'd8; 
      o_st_short_ht_config[20:17]               <= 4'd7; 
      o_st_long_ht_config[02:00]                <= 3'd0; 
      o_st_long_ht_config[12:03]                <= 10'd1023; 
      o_st_long_ht_config[16:13]                <= 4'd8; 
      o_st_long_ht_config[20:17]                <= 4'd7; 
      o_xp9_disable_modes[00:00]                <= 1'd0; 
      o_xp9_disable_modes[01:01]                <= 1'd0; 
      o_xp9_disable_modes[02:02]                <= 1'd0; 
      o_xp10_disable_modes[00:00]               <= 1'd0; 
      o_xp10_disable_modes[01:01]               <= 1'd0; 
      o_xp10_disable_modes[02:02]               <= 1'd0; 
      o_xp10_disable_modes[03:03]               <= 1'd0; 
      o_deflate_disable_modes[00:00]            <= 1'd0; 
      o_deflate_disable_modes[01:01]            <= 1'd0; 
      o_deflate_disable_modes[02:02]            <= 1'd0; 
      o_deflate_disable_modes[03:03]            <= 1'd0; 
      o_force_block_stall[00:00]                <= 1'd0; 
      o_force_block_stall[01:01]                <= 1'd0; 
      o_force_block_stall[02:02]                <= 1'd0; 
      o_force_block_stall[03:03]                <= 1'd0; 
      o_force_block_stall[04:04]                <= 1'd0; 
      o_force_block_stall[05:05]                <= 1'd0; 
      o_force_block_stall[06:06]                <= 1'd0; 
      o_force_block_stall[07:07]                <= 1'd0; 
      o_disable_sub_pipe[00:00]                 <= 1'd0; 
      o_debug_control[00:00]                    <= 1'd0; 
      o_out_ia_wdata_part0[05:00]               <= 6'd0; 
      o_out_ia_wdata_part1[31:00]               <= 32'd0; 
      o_out_ia_wdata_part2[31:00]               <= 32'd0; 
      o_out_ia_config[08:00]                    <= 9'd0; 
      o_out_ia_config[12:09]                    <= 4'd0; 
      o_out_im_config[09:00]                    <= 10'd512; 
      o_out_im_config[11:10]                    <= 2'd3; 
      o_out_im_read_done[00:00]                 <= 1'd0; 
      o_out_im_read_done[01:01]                 <= 1'd0; 
      o_sh_bl_ia_wdata_part0[20:00]             <= 21'd0; 
      o_sh_bl_ia_wdata_part1[31:00]             <= 32'd0; 
      o_sh_bl_ia_wdata_part2[31:00]             <= 32'd0; 
      o_sh_bl_ia_config[07:00]                  <= 8'd0; 
      o_sh_bl_ia_config[11:08]                  <= 4'd0; 
      o_sh_bl_im_config[07:00]                  <= 8'd144; 
      o_sh_bl_im_config[09:08]                  <= 2'd3; 
      o_sh_bl_im_read_done[00:00]               <= 1'd0; 
      o_sh_bl_im_read_done[01:01]               <= 1'd0; 
      o_lng_bl_ia_wdata_part0[20:00]            <= 21'd0; 
      o_lng_bl_ia_wdata_part1[31:00]            <= 32'd0; 
      o_lng_bl_ia_wdata_part2[31:00]            <= 32'd0; 
      o_lng_bl_ia_config[05:00]                 <= 6'd0; 
      o_lng_bl_ia_config[09:06]                 <= 4'd0; 
      o_lng_bl_im_config[05:00]                 <= 6'd62; 
      o_lng_bl_im_config[07:06]                 <= 2'd3; 
      o_lng_bl_im_read_done[00:00]              <= 1'd0; 
      o_lng_bl_im_read_done[01:01]              <= 1'd0; 
      o_st_sh_bl_ia_wdata_part0[20:00]          <= 21'd0; 
      o_st_sh_bl_ia_wdata_part1[31:00]          <= 32'd0; 
      o_st_sh_bl_ia_wdata_part2[31:00]          <= 32'd0; 
      o_st_sh_bl_ia_config[03:00]               <= 4'd0; 
      o_st_sh_bl_ia_config[07:04]               <= 4'd0; 
      o_st_sh_bl_im_config[03:00]               <= 4'd10; 
      o_st_sh_bl_im_config[05:04]               <= 2'd3; 
      o_st_sh_bl_im_read_done[00:00]            <= 1'd0; 
      o_st_sh_bl_im_read_done[01:01]            <= 1'd0; 
      o_st_lng_bl_ia_wdata_part0[20:00]         <= 21'd0; 
      o_st_lng_bl_ia_wdata_part1[31:00]         <= 32'd0; 
      o_st_lng_bl_ia_wdata_part2[31:00]         <= 32'd0; 
      o_st_lng_bl_ia_config[03:00]              <= 4'd0; 
      o_st_lng_bl_ia_config[07:04]              <= 4'd0; 
      o_st_lng_bl_im_config[03:00]              <= 4'd10; 
      o_st_lng_bl_im_config[05:04]              <= 2'd3; 
      o_st_lng_bl_im_read_done[00:00]           <= 1'd0; 
      o_st_lng_bl_im_read_done[01:01]           <= 1'd0; 
      o_sm_in_tlv_parse_action_0[01:00]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[03:02]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[05:04]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[07:06]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[09:08]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[11:10]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[13:12]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[15:14]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[17:16]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[19:18]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[21:20]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[23:22]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[25:24]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[27:26]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[29:28]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[31:30]         <= 2'd2; 
      o_sm_in_tlv_parse_action_1[01:00]         <= 2'd2; 
      o_sm_in_tlv_parse_action_1[03:02]         <= 2'd2; 
      o_sm_in_tlv_parse_action_1[05:04]         <= 2'd2; 
      o_sm_in_tlv_parse_action_1[07:06]         <= 2'd2; 
      o_sm_in_tlv_parse_action_1[09:08]         <= 2'd2; 
      o_sm_in_tlv_parse_action_1[11:10]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[13:12]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[15:14]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[17:16]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[19:18]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[21:20]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[23:22]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[25:24]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[27:26]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[29:28]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[31:30]         <= 2'd1; 
      o_sa_out_tlv_parse_action_0[01:00]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[03:02]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[05:04]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[07:06]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[09:08]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[11:10]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[13:12]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[15:14]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[17:16]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[19:18]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[21:20]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[23:22]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[25:24]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[27:26]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[29:28]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[31:30]        <= 2'd2; 
      o_sa_out_tlv_parse_action_1[01:00]        <= 2'd2; 
      o_sa_out_tlv_parse_action_1[03:02]        <= 2'd2; 
      o_sa_out_tlv_parse_action_1[05:04]        <= 2'd2; 
      o_sa_out_tlv_parse_action_1[07:06]        <= 2'd2; 
      o_sa_out_tlv_parse_action_1[09:08]        <= 2'd2; 
      o_sa_out_tlv_parse_action_1[11:10]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[13:12]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[15:14]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[17:16]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[19:18]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[21:20]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[23:22]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[25:24]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[27:26]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[29:28]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[31:30]        <= 2'd1; 
      o_bimc_monitor_mask[00:00]                <= 1'd0; 
      o_bimc_monitor_mask[01:01]                <= 1'd0; 
      o_bimc_monitor_mask[02:02]                <= 1'd0; 
      o_bimc_monitor_mask[03:03]                <= 1'd0; 
      o_bimc_monitor_mask[04:04]                <= 1'd0; 
      o_bimc_monitor_mask[05:05]                <= 1'd0; 
      o_bimc_monitor_mask[06:06]                <= 1'd0; 
      o_bimc_ecc_uncorrectable_error_cnt[31:00] <= 32'd0; 
      o_bimc_ecc_correctable_error_cnt[31:00]   <= 32'd0; 
      o_bimc_parity_error_cnt[31:00]            <= 32'd0; 
      o_bimc_global_config[00:00]               <= 1'd1; 
      o_bimc_global_config[01:01]               <= 1'd0; 
      o_bimc_global_config[02:02]               <= 1'd0; 
      o_bimc_global_config[03:03]               <= 1'd0; 
      o_bimc_global_config[04:04]               <= 1'd0; 
      o_bimc_global_config[05:05]               <= 1'd0; 
      o_bimc_global_config[31:06]               <= 26'd0; 
      o_bimc_eccpar_debug[11:00]                <= 12'd0; 
      o_bimc_eccpar_debug[15:12]                <= 4'd0; 
      o_bimc_eccpar_debug[17:16]                <= 2'd0; 
      o_bimc_eccpar_debug[19:18]                <= 2'd0; 
      o_bimc_eccpar_debug[21:20]                <= 2'd0; 
      o_bimc_eccpar_debug[22:22]                <= 1'd0; 
      o_bimc_eccpar_debug[23:23]                <= 1'd0; 
      o_bimc_eccpar_debug[27:24]                <= 4'd0; 
      o_bimc_eccpar_debug[28:28]                <= 1'd0; 
      o_bimc_cmd2[07:00]                        <= 8'd0; 
      o_bimc_cmd2[08:08]                        <= 1'd0; 
      o_bimc_cmd2[09:09]                        <= 1'd0; 
      o_bimc_cmd2[10:10]                        <= 1'd0; 
      o_bimc_cmd1[15:00]                        <= 16'd0; 
      o_bimc_cmd1[27:16]                        <= 12'd0; 
      o_bimc_cmd1[31:28]                        <= 4'd0; 
      o_bimc_cmd0[31:00]                        <= 32'd0; 
      o_bimc_rxcmd2[07:00]                      <= 8'd0; 
      o_bimc_rxcmd2[08:08]                      <= 1'd0; 
      o_bimc_rxrsp2[07:00]                      <= 8'd0; 
      o_bimc_rxrsp2[08:08]                      <= 1'd0; 
      o_bimc_pollrsp2[07:00]                    <= 8'd0; 
      o_bimc_pollrsp2[08:08]                    <= 1'd0; 
      o_bimc_dbgcmd2[07:00]                     <= 8'd0; 
      o_bimc_dbgcmd2[08:08]                     <= 1'd0; 
      o_gzip_os[07:00]                          <= 8'd3; 
    end
    else if(i_sw_init) begin
      
      o_spare_config[31:00]                     <= 32'd0; 
      o_prefix_adj[01:00]                       <= 2'd0; 
      o_henc_huff_win_size_in_entries[14:00]    <= 15'd8192; 
      o_henc_xp9_first_blk_thrsh[22:00]         <= 23'd8192; 
      o_short_ht_config[02:00]                  <= 3'd0; 
      o_short_ht_config[12:03]                  <= 10'd1023; 
      o_short_ht_config[17:13]                  <= 5'd27; 
      o_short_ht_config[22:18]                  <= 5'd15; 
      o_long_ht_config[02:00]                   <= 3'd0; 
      o_long_ht_config[12:03]                   <= 10'd1023; 
      o_long_ht_config[17:13]                   <= 5'd27; 
      o_long_ht_config[22:18]                   <= 5'd15; 
      o_st_short_ht_config[02:00]               <= 3'd0; 
      o_st_short_ht_config[12:03]               <= 10'd1023; 
      o_st_short_ht_config[16:13]               <= 4'd8; 
      o_st_short_ht_config[20:17]               <= 4'd7; 
      o_st_long_ht_config[02:00]                <= 3'd0; 
      o_st_long_ht_config[12:03]                <= 10'd1023; 
      o_st_long_ht_config[16:13]                <= 4'd8; 
      o_st_long_ht_config[20:17]                <= 4'd7; 
      o_xp9_disable_modes[00:00]                <= 1'd0; 
      o_xp9_disable_modes[01:01]                <= 1'd0; 
      o_xp9_disable_modes[02:02]                <= 1'd0; 
      o_xp10_disable_modes[00:00]               <= 1'd0; 
      o_xp10_disable_modes[01:01]               <= 1'd0; 
      o_xp10_disable_modes[02:02]               <= 1'd0; 
      o_xp10_disable_modes[03:03]               <= 1'd0; 
      o_deflate_disable_modes[00:00]            <= 1'd0; 
      o_deflate_disable_modes[01:01]            <= 1'd0; 
      o_deflate_disable_modes[02:02]            <= 1'd0; 
      o_deflate_disable_modes[03:03]            <= 1'd0; 
      o_force_block_stall[00:00]                <= 1'd0; 
      o_force_block_stall[01:01]                <= 1'd0; 
      o_force_block_stall[02:02]                <= 1'd0; 
      o_force_block_stall[03:03]                <= 1'd0; 
      o_force_block_stall[04:04]                <= 1'd0; 
      o_force_block_stall[05:05]                <= 1'd0; 
      o_force_block_stall[06:06]                <= 1'd0; 
      o_force_block_stall[07:07]                <= 1'd0; 
      o_disable_sub_pipe[00:00]                 <= 1'd0; 
      o_debug_control[00:00]                    <= 1'd0; 
      o_out_ia_wdata_part0[05:00]               <= 6'd0; 
      o_out_ia_wdata_part1[31:00]               <= 32'd0; 
      o_out_ia_wdata_part2[31:00]               <= 32'd0; 
      o_out_ia_config[08:00]                    <= 9'd0; 
      o_out_ia_config[12:09]                    <= 4'd0; 
      o_out_im_config[09:00]                    <= 10'd512; 
      o_out_im_config[11:10]                    <= 2'd3; 
      o_out_im_read_done[00:00]                 <= 1'd0; 
      o_out_im_read_done[01:01]                 <= 1'd0; 
      o_sh_bl_ia_wdata_part0[20:00]             <= 21'd0; 
      o_sh_bl_ia_wdata_part1[31:00]             <= 32'd0; 
      o_sh_bl_ia_wdata_part2[31:00]             <= 32'd0; 
      o_sh_bl_ia_config[07:00]                  <= 8'd0; 
      o_sh_bl_ia_config[11:08]                  <= 4'd0; 
      o_sh_bl_im_config[07:00]                  <= 8'd144; 
      o_sh_bl_im_config[09:08]                  <= 2'd3; 
      o_sh_bl_im_read_done[00:00]               <= 1'd0; 
      o_sh_bl_im_read_done[01:01]               <= 1'd0; 
      o_lng_bl_ia_wdata_part0[20:00]            <= 21'd0; 
      o_lng_bl_ia_wdata_part1[31:00]            <= 32'd0; 
      o_lng_bl_ia_wdata_part2[31:00]            <= 32'd0; 
      o_lng_bl_ia_config[05:00]                 <= 6'd0; 
      o_lng_bl_ia_config[09:06]                 <= 4'd0; 
      o_lng_bl_im_config[05:00]                 <= 6'd62; 
      o_lng_bl_im_config[07:06]                 <= 2'd3; 
      o_lng_bl_im_read_done[00:00]              <= 1'd0; 
      o_lng_bl_im_read_done[01:01]              <= 1'd0; 
      o_st_sh_bl_ia_wdata_part0[20:00]          <= 21'd0; 
      o_st_sh_bl_ia_wdata_part1[31:00]          <= 32'd0; 
      o_st_sh_bl_ia_wdata_part2[31:00]          <= 32'd0; 
      o_st_sh_bl_ia_config[03:00]               <= 4'd0; 
      o_st_sh_bl_ia_config[07:04]               <= 4'd0; 
      o_st_sh_bl_im_config[03:00]               <= 4'd10; 
      o_st_sh_bl_im_config[05:04]               <= 2'd3; 
      o_st_sh_bl_im_read_done[00:00]            <= 1'd0; 
      o_st_sh_bl_im_read_done[01:01]            <= 1'd0; 
      o_st_lng_bl_ia_wdata_part0[20:00]         <= 21'd0; 
      o_st_lng_bl_ia_wdata_part1[31:00]         <= 32'd0; 
      o_st_lng_bl_ia_wdata_part2[31:00]         <= 32'd0; 
      o_st_lng_bl_ia_config[03:00]              <= 4'd0; 
      o_st_lng_bl_ia_config[07:04]              <= 4'd0; 
      o_st_lng_bl_im_config[03:00]              <= 4'd10; 
      o_st_lng_bl_im_config[05:04]              <= 2'd3; 
      o_st_lng_bl_im_read_done[00:00]           <= 1'd0; 
      o_st_lng_bl_im_read_done[01:01]           <= 1'd0; 
      o_sm_in_tlv_parse_action_0[01:00]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[03:02]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[05:04]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[07:06]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[09:08]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[11:10]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[13:12]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[15:14]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[17:16]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[19:18]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[21:20]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[23:22]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[25:24]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[27:26]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[29:28]         <= 2'd2; 
      o_sm_in_tlv_parse_action_0[31:30]         <= 2'd2; 
      o_sm_in_tlv_parse_action_1[01:00]         <= 2'd2; 
      o_sm_in_tlv_parse_action_1[03:02]         <= 2'd2; 
      o_sm_in_tlv_parse_action_1[05:04]         <= 2'd2; 
      o_sm_in_tlv_parse_action_1[07:06]         <= 2'd2; 
      o_sm_in_tlv_parse_action_1[09:08]         <= 2'd2; 
      o_sm_in_tlv_parse_action_1[11:10]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[13:12]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[15:14]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[17:16]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[19:18]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[21:20]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[23:22]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[25:24]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[27:26]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[29:28]         <= 2'd1; 
      o_sm_in_tlv_parse_action_1[31:30]         <= 2'd1; 
      o_sa_out_tlv_parse_action_0[01:00]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[03:02]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[05:04]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[07:06]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[09:08]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[11:10]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[13:12]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[15:14]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[17:16]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[19:18]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[21:20]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[23:22]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[25:24]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[27:26]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[29:28]        <= 2'd2; 
      o_sa_out_tlv_parse_action_0[31:30]        <= 2'd2; 
      o_sa_out_tlv_parse_action_1[01:00]        <= 2'd2; 
      o_sa_out_tlv_parse_action_1[03:02]        <= 2'd2; 
      o_sa_out_tlv_parse_action_1[05:04]        <= 2'd2; 
      o_sa_out_tlv_parse_action_1[07:06]        <= 2'd2; 
      o_sa_out_tlv_parse_action_1[09:08]        <= 2'd2; 
      o_sa_out_tlv_parse_action_1[11:10]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[13:12]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[15:14]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[17:16]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[19:18]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[21:20]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[23:22]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[25:24]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[27:26]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[29:28]        <= 2'd1; 
      o_sa_out_tlv_parse_action_1[31:30]        <= 2'd1; 
      o_bimc_monitor_mask[00:00]                <= 1'd0; 
      o_bimc_monitor_mask[01:01]                <= 1'd0; 
      o_bimc_monitor_mask[02:02]                <= 1'd0; 
      o_bimc_monitor_mask[03:03]                <= 1'd0; 
      o_bimc_monitor_mask[04:04]                <= 1'd0; 
      o_bimc_monitor_mask[05:05]                <= 1'd0; 
      o_bimc_monitor_mask[06:06]                <= 1'd0; 
      o_bimc_ecc_uncorrectable_error_cnt[31:00] <= 32'd0; 
      o_bimc_ecc_correctable_error_cnt[31:00]   <= 32'd0; 
      o_bimc_parity_error_cnt[31:00]            <= 32'd0; 
      o_bimc_global_config[00:00]               <= 1'd1; 
      o_bimc_global_config[01:01]               <= 1'd0; 
      o_bimc_global_config[02:02]               <= 1'd0; 
      o_bimc_global_config[03:03]               <= 1'd0; 
      o_bimc_global_config[04:04]               <= 1'd0; 
      o_bimc_global_config[05:05]               <= 1'd0; 
      o_bimc_global_config[31:06]               <= 26'd0; 
      o_bimc_eccpar_debug[11:00]                <= 12'd0; 
      o_bimc_eccpar_debug[15:12]                <= 4'd0; 
      o_bimc_eccpar_debug[17:16]                <= 2'd0; 
      o_bimc_eccpar_debug[19:18]                <= 2'd0; 
      o_bimc_eccpar_debug[21:20]                <= 2'd0; 
      o_bimc_eccpar_debug[22:22]                <= 1'd0; 
      o_bimc_eccpar_debug[23:23]                <= 1'd0; 
      o_bimc_eccpar_debug[27:24]                <= 4'd0; 
      o_bimc_eccpar_debug[28:28]                <= 1'd0; 
      o_bimc_cmd2[07:00]                        <= 8'd0; 
      o_bimc_cmd2[08:08]                        <= 1'd0; 
      o_bimc_cmd2[09:09]                        <= 1'd0; 
      o_bimc_cmd2[10:10]                        <= 1'd0; 
      o_bimc_cmd1[15:00]                        <= 16'd0; 
      o_bimc_cmd1[27:16]                        <= 12'd0; 
      o_bimc_cmd1[31:28]                        <= 4'd0; 
      o_bimc_cmd0[31:00]                        <= 32'd0; 
      o_bimc_rxcmd2[07:00]                      <= 8'd0; 
      o_bimc_rxcmd2[08:08]                      <= 1'd0; 
      o_bimc_rxrsp2[07:00]                      <= 8'd0; 
      o_bimc_rxrsp2[08:08]                      <= 1'd0; 
      o_bimc_pollrsp2[07:00]                    <= 8'd0; 
      o_bimc_pollrsp2[08:08]                    <= 1'd0; 
      o_bimc_dbgcmd2[07:00]                     <= 8'd0; 
      o_bimc_dbgcmd2[08:08]                     <= 1'd0; 
      o_gzip_os[07:00]                          <= 8'd3; 
    end
    else begin
      if(w_load_spare_config)                     o_spare_config[31:00]                     <= f32_data[31:00]; 
      if(w_load_prefix_adj)                       o_prefix_adj[01:00]                       <= f32_data[01:00]; 
      if(w_load_henc_huff_win_size_in_entries)    o_henc_huff_win_size_in_entries[14:00]    <= f32_data[14:00]; 
      if(w_load_henc_xp9_first_blk_thrsh)         o_henc_xp9_first_blk_thrsh[22:00]         <= f32_data[22:00]; 
      if(w_load_short_ht_config)                  o_short_ht_config[02:00]                  <= f32_data[02:00]; 
      if(w_load_short_ht_config)                  o_short_ht_config[12:03]                  <= f32_data[12:03]; 
      if(w_load_short_ht_config)                  o_short_ht_config[17:13]                  <= f32_data[17:13]; 
      if(w_load_short_ht_config)                  o_short_ht_config[22:18]                  <= f32_data[22:18]; 
      if(w_load_long_ht_config)                   o_long_ht_config[02:00]                   <= f32_data[02:00]; 
      if(w_load_long_ht_config)                   o_long_ht_config[12:03]                   <= f32_data[12:03]; 
      if(w_load_long_ht_config)                   o_long_ht_config[17:13]                   <= f32_data[17:13]; 
      if(w_load_long_ht_config)                   o_long_ht_config[22:18]                   <= f32_data[22:18]; 
      if(w_load_st_short_ht_config)               o_st_short_ht_config[02:00]               <= f32_data[02:00]; 
      if(w_load_st_short_ht_config)               o_st_short_ht_config[12:03]               <= f32_data[12:03]; 
      if(w_load_st_short_ht_config)               o_st_short_ht_config[16:13]               <= f32_data[16:13]; 
      if(w_load_st_short_ht_config)               o_st_short_ht_config[20:17]               <= f32_data[20:17]; 
      if(w_load_st_long_ht_config)                o_st_long_ht_config[02:00]                <= f32_data[02:00]; 
      if(w_load_st_long_ht_config)                o_st_long_ht_config[12:03]                <= f32_data[12:03]; 
      if(w_load_st_long_ht_config)                o_st_long_ht_config[16:13]                <= f32_data[16:13]; 
      if(w_load_st_long_ht_config)                o_st_long_ht_config[20:17]                <= f32_data[20:17]; 
      if(w_load_xp9_disable_modes)                o_xp9_disable_modes[00:00]                <= f32_data[00:00]; 
      if(w_load_xp9_disable_modes)                o_xp9_disable_modes[01:01]                <= f32_data[01:01]; 
      if(w_load_xp9_disable_modes)                o_xp9_disable_modes[02:02]                <= f32_data[02:02]; 
      if(w_load_xp10_disable_modes)               o_xp10_disable_modes[00:00]               <= f32_data[00:00]; 
      if(w_load_xp10_disable_modes)               o_xp10_disable_modes[01:01]               <= f32_data[01:01]; 
      if(w_load_xp10_disable_modes)               o_xp10_disable_modes[02:02]               <= f32_data[02:02]; 
      if(w_load_xp10_disable_modes)               o_xp10_disable_modes[03:03]               <= f32_data[03:03]; 
      if(w_load_deflate_disable_modes)            o_deflate_disable_modes[00:00]            <= f32_data[00:00]; 
      if(w_load_deflate_disable_modes)            o_deflate_disable_modes[01:01]            <= f32_data[01:01]; 
      if(w_load_deflate_disable_modes)            o_deflate_disable_modes[02:02]            <= f32_data[02:02]; 
      if(w_load_deflate_disable_modes)            o_deflate_disable_modes[03:03]            <= f32_data[03:03]; 
      if(w_load_force_block_stall)                o_force_block_stall[00:00]                <= f32_data[00:00]; 
      if(w_load_force_block_stall)                o_force_block_stall[01:01]                <= f32_data[01:01]; 
      if(w_load_force_block_stall)                o_force_block_stall[02:02]                <= f32_data[02:02]; 
      if(w_load_force_block_stall)                o_force_block_stall[03:03]                <= f32_data[03:03]; 
      if(w_load_force_block_stall)                o_force_block_stall[04:04]                <= f32_data[04:04]; 
      if(w_load_force_block_stall)                o_force_block_stall[05:05]                <= f32_data[05:05]; 
      if(w_load_force_block_stall)                o_force_block_stall[06:06]                <= f32_data[06:06]; 
      if(w_load_force_block_stall)                o_force_block_stall[07:07]                <= f32_data[07:07]; 
      if(w_load_disable_sub_pipe)                 o_disable_sub_pipe[00:00]                 <= f32_data[00:00]; 
      if(w_load_debug_control)                    o_debug_control[00:00]                    <= f32_data[00:00]; 
      if(w_load_out_ia_wdata_part0)               o_out_ia_wdata_part0[05:00]               <= f32_data[05:00]; 
      if(w_load_out_ia_wdata_part1)               o_out_ia_wdata_part1[31:00]               <= f32_data[31:00]; 
      if(w_load_out_ia_wdata_part2)               o_out_ia_wdata_part2[31:00]               <= f32_data[31:00]; 
      if(w_load_out_ia_config)                    o_out_ia_config[08:00]                    <= f32_data[08:00]; 
      if(w_load_out_ia_config)                    o_out_ia_config[12:09]                    <= f32_data[31:28]; 
      if(w_load_out_im_config)                    o_out_im_config[09:00]                    <= f32_data[09:00]; 
      if(w_load_out_im_config)                    o_out_im_config[11:10]                    <= f32_data[31:30]; 
      if(w_load_out_im_read_done)                 o_out_im_read_done[00:00]                 <= f32_data[30:30]; 
      if(w_load_out_im_read_done)                 o_out_im_read_done[01:01]                 <= f32_data[31:31]; 
      if(w_load_sh_bl_ia_wdata_part0)             o_sh_bl_ia_wdata_part0[20:00]             <= f32_data[20:00]; 
      if(w_load_sh_bl_ia_wdata_part1)             o_sh_bl_ia_wdata_part1[31:00]             <= f32_data[31:00]; 
      if(w_load_sh_bl_ia_wdata_part2)             o_sh_bl_ia_wdata_part2[31:00]             <= f32_data[31:00]; 
      if(w_load_sh_bl_ia_config)                  o_sh_bl_ia_config[07:00]                  <= f32_data[07:00]; 
      if(w_load_sh_bl_ia_config)                  o_sh_bl_ia_config[11:08]                  <= f32_data[31:28]; 
      if(w_load_sh_bl_im_config)                  o_sh_bl_im_config[07:00]                  <= f32_data[07:00]; 
      if(w_load_sh_bl_im_config)                  o_sh_bl_im_config[09:08]                  <= f32_data[31:30]; 
      if(w_load_sh_bl_im_read_done)               o_sh_bl_im_read_done[00:00]               <= f32_data[30:30]; 
      if(w_load_sh_bl_im_read_done)               o_sh_bl_im_read_done[01:01]               <= f32_data[31:31]; 
      if(w_load_lng_bl_ia_wdata_part0)            o_lng_bl_ia_wdata_part0[20:00]            <= f32_data[20:00]; 
      if(w_load_lng_bl_ia_wdata_part1)            o_lng_bl_ia_wdata_part1[31:00]            <= f32_data[31:00]; 
      if(w_load_lng_bl_ia_wdata_part2)            o_lng_bl_ia_wdata_part2[31:00]            <= f32_data[31:00]; 
      if(w_load_lng_bl_ia_config)                 o_lng_bl_ia_config[05:00]                 <= f32_data[05:00]; 
      if(w_load_lng_bl_ia_config)                 o_lng_bl_ia_config[09:06]                 <= f32_data[31:28]; 
      if(w_load_lng_bl_im_config)                 o_lng_bl_im_config[05:00]                 <= f32_data[05:00]; 
      if(w_load_lng_bl_im_config)                 o_lng_bl_im_config[07:06]                 <= f32_data[31:30]; 
      if(w_load_lng_bl_im_read_done)              o_lng_bl_im_read_done[00:00]              <= f32_data[30:30]; 
      if(w_load_lng_bl_im_read_done)              o_lng_bl_im_read_done[01:01]              <= f32_data[31:31]; 
      if(w_load_st_sh_bl_ia_wdata_part0)          o_st_sh_bl_ia_wdata_part0[20:00]          <= f32_data[20:00]; 
      if(w_load_st_sh_bl_ia_wdata_part1)          o_st_sh_bl_ia_wdata_part1[31:00]          <= f32_data[31:00]; 
      if(w_load_st_sh_bl_ia_wdata_part2)          o_st_sh_bl_ia_wdata_part2[31:00]          <= f32_data[31:00]; 
      if(w_load_st_sh_bl_ia_config)               o_st_sh_bl_ia_config[03:00]               <= f32_data[03:00]; 
      if(w_load_st_sh_bl_ia_config)               o_st_sh_bl_ia_config[07:04]               <= f32_data[31:28]; 
      if(w_load_st_sh_bl_im_config)               o_st_sh_bl_im_config[03:00]               <= f32_data[03:00]; 
      if(w_load_st_sh_bl_im_config)               o_st_sh_bl_im_config[05:04]               <= f32_data[31:30]; 
      if(w_load_st_sh_bl_im_read_done)            o_st_sh_bl_im_read_done[00:00]            <= f32_data[30:30]; 
      if(w_load_st_sh_bl_im_read_done)            o_st_sh_bl_im_read_done[01:01]            <= f32_data[31:31]; 
      if(w_load_st_lng_bl_ia_wdata_part0)         o_st_lng_bl_ia_wdata_part0[20:00]         <= f32_data[20:00]; 
      if(w_load_st_lng_bl_ia_wdata_part1)         o_st_lng_bl_ia_wdata_part1[31:00]         <= f32_data[31:00]; 
      if(w_load_st_lng_bl_ia_wdata_part2)         o_st_lng_bl_ia_wdata_part2[31:00]         <= f32_data[31:00]; 
      if(w_load_st_lng_bl_ia_config)              o_st_lng_bl_ia_config[03:00]              <= f32_data[03:00]; 
      if(w_load_st_lng_bl_ia_config)              o_st_lng_bl_ia_config[07:04]              <= f32_data[31:28]; 
      if(w_load_st_lng_bl_im_config)              o_st_lng_bl_im_config[03:00]              <= f32_data[03:00]; 
      if(w_load_st_lng_bl_im_config)              o_st_lng_bl_im_config[05:04]              <= f32_data[31:30]; 
      if(w_load_st_lng_bl_im_read_done)           o_st_lng_bl_im_read_done[00:00]           <= f32_data[30:30]; 
      if(w_load_st_lng_bl_im_read_done)           o_st_lng_bl_im_read_done[01:01]           <= f32_data[31:31]; 
      if(w_load_sm_in_tlv_parse_action_0)         o_sm_in_tlv_parse_action_0[01:00]         <= f32_data[01:00]; 
      if(w_load_sm_in_tlv_parse_action_0)         o_sm_in_tlv_parse_action_0[03:02]         <= f32_data[03:02]; 
      if(w_load_sm_in_tlv_parse_action_0)         o_sm_in_tlv_parse_action_0[05:04]         <= f32_data[05:04]; 
      if(w_load_sm_in_tlv_parse_action_0)         o_sm_in_tlv_parse_action_0[07:06]         <= f32_data[07:06]; 
      if(w_load_sm_in_tlv_parse_action_0)         o_sm_in_tlv_parse_action_0[09:08]         <= f32_data[09:08]; 
      if(w_load_sm_in_tlv_parse_action_0)         o_sm_in_tlv_parse_action_0[11:10]         <= f32_data[11:10]; 
      if(w_load_sm_in_tlv_parse_action_0)         o_sm_in_tlv_parse_action_0[13:12]         <= f32_data[13:12]; 
      if(w_load_sm_in_tlv_parse_action_0)         o_sm_in_tlv_parse_action_0[15:14]         <= f32_data[15:14]; 
      if(w_load_sm_in_tlv_parse_action_0)         o_sm_in_tlv_parse_action_0[17:16]         <= f32_data[17:16]; 
      if(w_load_sm_in_tlv_parse_action_0)         o_sm_in_tlv_parse_action_0[19:18]         <= f32_data[19:18]; 
      if(w_load_sm_in_tlv_parse_action_0)         o_sm_in_tlv_parse_action_0[21:20]         <= f32_data[21:20]; 
      if(w_load_sm_in_tlv_parse_action_0)         o_sm_in_tlv_parse_action_0[23:22]         <= f32_data[23:22]; 
      if(w_load_sm_in_tlv_parse_action_0)         o_sm_in_tlv_parse_action_0[25:24]         <= f32_data[25:24]; 
      if(w_load_sm_in_tlv_parse_action_0)         o_sm_in_tlv_parse_action_0[27:26]         <= f32_data[27:26]; 
      if(w_load_sm_in_tlv_parse_action_0)         o_sm_in_tlv_parse_action_0[29:28]         <= f32_data[29:28]; 
      if(w_load_sm_in_tlv_parse_action_0)         o_sm_in_tlv_parse_action_0[31:30]         <= f32_data[31:30]; 
      if(w_load_sm_in_tlv_parse_action_1)         o_sm_in_tlv_parse_action_1[01:00]         <= f32_data[01:00]; 
      if(w_load_sm_in_tlv_parse_action_1)         o_sm_in_tlv_parse_action_1[03:02]         <= f32_data[03:02]; 
      if(w_load_sm_in_tlv_parse_action_1)         o_sm_in_tlv_parse_action_1[05:04]         <= f32_data[05:04]; 
      if(w_load_sm_in_tlv_parse_action_1)         o_sm_in_tlv_parse_action_1[07:06]         <= f32_data[07:06]; 
      if(w_load_sm_in_tlv_parse_action_1)         o_sm_in_tlv_parse_action_1[09:08]         <= f32_data[09:08]; 
      if(w_load_sm_in_tlv_parse_action_1)         o_sm_in_tlv_parse_action_1[11:10]         <= f32_data[11:10]; 
      if(w_load_sm_in_tlv_parse_action_1)         o_sm_in_tlv_parse_action_1[13:12]         <= f32_data[13:12]; 
      if(w_load_sm_in_tlv_parse_action_1)         o_sm_in_tlv_parse_action_1[15:14]         <= f32_data[15:14]; 
      if(w_load_sm_in_tlv_parse_action_1)         o_sm_in_tlv_parse_action_1[17:16]         <= f32_data[17:16]; 
      if(w_load_sm_in_tlv_parse_action_1)         o_sm_in_tlv_parse_action_1[19:18]         <= f32_data[19:18]; 
      if(w_load_sm_in_tlv_parse_action_1)         o_sm_in_tlv_parse_action_1[21:20]         <= f32_data[21:20]; 
      if(w_load_sm_in_tlv_parse_action_1)         o_sm_in_tlv_parse_action_1[23:22]         <= f32_data[23:22]; 
      if(w_load_sm_in_tlv_parse_action_1)         o_sm_in_tlv_parse_action_1[25:24]         <= f32_data[25:24]; 
      if(w_load_sm_in_tlv_parse_action_1)         o_sm_in_tlv_parse_action_1[27:26]         <= f32_data[27:26]; 
      if(w_load_sm_in_tlv_parse_action_1)         o_sm_in_tlv_parse_action_1[29:28]         <= f32_data[29:28]; 
      if(w_load_sm_in_tlv_parse_action_1)         o_sm_in_tlv_parse_action_1[31:30]         <= f32_data[31:30]; 
      if(w_load_sa_out_tlv_parse_action_0)        o_sa_out_tlv_parse_action_0[01:00]        <= f32_data[01:00]; 
      if(w_load_sa_out_tlv_parse_action_0)        o_sa_out_tlv_parse_action_0[03:02]        <= f32_data[03:02]; 
      if(w_load_sa_out_tlv_parse_action_0)        o_sa_out_tlv_parse_action_0[05:04]        <= f32_data[05:04]; 
      if(w_load_sa_out_tlv_parse_action_0)        o_sa_out_tlv_parse_action_0[07:06]        <= f32_data[07:06]; 
      if(w_load_sa_out_tlv_parse_action_0)        o_sa_out_tlv_parse_action_0[09:08]        <= f32_data[09:08]; 
      if(w_load_sa_out_tlv_parse_action_0)        o_sa_out_tlv_parse_action_0[11:10]        <= f32_data[11:10]; 
      if(w_load_sa_out_tlv_parse_action_0)        o_sa_out_tlv_parse_action_0[13:12]        <= f32_data[13:12]; 
      if(w_load_sa_out_tlv_parse_action_0)        o_sa_out_tlv_parse_action_0[15:14]        <= f32_data[15:14]; 
      if(w_load_sa_out_tlv_parse_action_0)        o_sa_out_tlv_parse_action_0[17:16]        <= f32_data[17:16]; 
      if(w_load_sa_out_tlv_parse_action_0)        o_sa_out_tlv_parse_action_0[19:18]        <= f32_data[19:18]; 
      if(w_load_sa_out_tlv_parse_action_0)        o_sa_out_tlv_parse_action_0[21:20]        <= f32_data[21:20]; 
      if(w_load_sa_out_tlv_parse_action_0)        o_sa_out_tlv_parse_action_0[23:22]        <= f32_data[23:22]; 
      if(w_load_sa_out_tlv_parse_action_0)        o_sa_out_tlv_parse_action_0[25:24]        <= f32_data[25:24]; 
      if(w_load_sa_out_tlv_parse_action_0)        o_sa_out_tlv_parse_action_0[27:26]        <= f32_data[27:26]; 
      if(w_load_sa_out_tlv_parse_action_0)        o_sa_out_tlv_parse_action_0[29:28]        <= f32_data[29:28]; 
      if(w_load_sa_out_tlv_parse_action_0)        o_sa_out_tlv_parse_action_0[31:30]        <= f32_data[31:30]; 
      if(w_load_sa_out_tlv_parse_action_1)        o_sa_out_tlv_parse_action_1[01:00]        <= f32_data[01:00]; 
      if(w_load_sa_out_tlv_parse_action_1)        o_sa_out_tlv_parse_action_1[03:02]        <= f32_data[03:02]; 
      if(w_load_sa_out_tlv_parse_action_1)        o_sa_out_tlv_parse_action_1[05:04]        <= f32_data[05:04]; 
      if(w_load_sa_out_tlv_parse_action_1)        o_sa_out_tlv_parse_action_1[07:06]        <= f32_data[07:06]; 
      if(w_load_sa_out_tlv_parse_action_1)        o_sa_out_tlv_parse_action_1[09:08]        <= f32_data[09:08]; 
      if(w_load_sa_out_tlv_parse_action_1)        o_sa_out_tlv_parse_action_1[11:10]        <= f32_data[11:10]; 
      if(w_load_sa_out_tlv_parse_action_1)        o_sa_out_tlv_parse_action_1[13:12]        <= f32_data[13:12]; 
      if(w_load_sa_out_tlv_parse_action_1)        o_sa_out_tlv_parse_action_1[15:14]        <= f32_data[15:14]; 
      if(w_load_sa_out_tlv_parse_action_1)        o_sa_out_tlv_parse_action_1[17:16]        <= f32_data[17:16]; 
      if(w_load_sa_out_tlv_parse_action_1)        o_sa_out_tlv_parse_action_1[19:18]        <= f32_data[19:18]; 
      if(w_load_sa_out_tlv_parse_action_1)        o_sa_out_tlv_parse_action_1[21:20]        <= f32_data[21:20]; 
      if(w_load_sa_out_tlv_parse_action_1)        o_sa_out_tlv_parse_action_1[23:22]        <= f32_data[23:22]; 
      if(w_load_sa_out_tlv_parse_action_1)        o_sa_out_tlv_parse_action_1[25:24]        <= f32_data[25:24]; 
      if(w_load_sa_out_tlv_parse_action_1)        o_sa_out_tlv_parse_action_1[27:26]        <= f32_data[27:26]; 
      if(w_load_sa_out_tlv_parse_action_1)        o_sa_out_tlv_parse_action_1[29:28]        <= f32_data[29:28]; 
      if(w_load_sa_out_tlv_parse_action_1)        o_sa_out_tlv_parse_action_1[31:30]        <= f32_data[31:30]; 
      if(w_load_bimc_monitor_mask)                o_bimc_monitor_mask[00:00]                <= f32_data[00:00]; 
      if(w_load_bimc_monitor_mask)                o_bimc_monitor_mask[01:01]                <= f32_data[01:01]; 
      if(w_load_bimc_monitor_mask)                o_bimc_monitor_mask[02:02]                <= f32_data[02:02]; 
      if(w_load_bimc_monitor_mask)                o_bimc_monitor_mask[03:03]                <= f32_data[03:03]; 
      if(w_load_bimc_monitor_mask)                o_bimc_monitor_mask[04:04]                <= f32_data[04:04]; 
      if(w_load_bimc_monitor_mask)                o_bimc_monitor_mask[05:05]                <= f32_data[05:05]; 
      if(w_load_bimc_monitor_mask)                o_bimc_monitor_mask[06:06]                <= f32_data[06:06]; 
      if(w_load_bimc_ecc_uncorrectable_error_cnt) o_bimc_ecc_uncorrectable_error_cnt[31:00] <= f32_data[31:00]; 
      if(w_load_bimc_ecc_correctable_error_cnt)   o_bimc_ecc_correctable_error_cnt[31:00]   <= f32_data[31:00]; 
      if(w_load_bimc_parity_error_cnt)            o_bimc_parity_error_cnt[31:00]            <= f32_data[31:00]; 
      if(w_load_bimc_global_config)               o_bimc_global_config[00:00]               <= f32_data[00:00]; 
      if(w_load_bimc_global_config)               o_bimc_global_config[01:01]               <= f32_data[01:01]; 
      if(w_load_bimc_global_config)               o_bimc_global_config[02:02]               <= f32_data[02:02]; 
      if(w_load_bimc_global_config)               o_bimc_global_config[03:03]               <= f32_data[03:03]; 
      if(w_load_bimc_global_config)               o_bimc_global_config[04:04]               <= f32_data[04:04]; 
      if(w_load_bimc_global_config)               o_bimc_global_config[05:05]               <= f32_data[05:05]; 
      if(w_load_bimc_global_config)               o_bimc_global_config[31:06]               <= f32_data[31:06]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[11:00]                <= f32_data[11:00]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[15:12]                <= f32_data[15:12]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[17:16]                <= f32_data[17:16]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[19:18]                <= f32_data[19:18]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[21:20]                <= f32_data[21:20]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[22:22]                <= f32_data[22:22]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[23:23]                <= f32_data[23:23]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[27:24]                <= f32_data[27:24]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[28:28]                <= f32_data[28:28]; 
      if(w_load_bimc_cmd2)                        o_bimc_cmd2[07:00]                        <= f32_data[07:00]; 
      if(w_load_bimc_cmd2)                        o_bimc_cmd2[08:08]                        <= f32_data[08:08]; 
      if(w_load_bimc_cmd2)                        o_bimc_cmd2[09:09]                        <= f32_data[09:09]; 
      if(w_load_bimc_cmd2)                        o_bimc_cmd2[10:10]                        <= f32_data[10:10]; 
      if(w_load_bimc_cmd1)                        o_bimc_cmd1[15:00]                        <= f32_data[15:00]; 
      if(w_load_bimc_cmd1)                        o_bimc_cmd1[27:16]                        <= f32_data[27:16]; 
      if(w_load_bimc_cmd1)                        o_bimc_cmd1[31:28]                        <= f32_data[31:28]; 
      if(w_load_bimc_cmd0)                        o_bimc_cmd0[31:00]                        <= f32_data[31:00]; 
      if(w_load_bimc_rxcmd2)                      o_bimc_rxcmd2[07:00]                      <= f32_data[07:00]; 
      if(w_load_bimc_rxcmd2)                      o_bimc_rxcmd2[08:08]                      <= f32_data[08:08]; 
      if(w_load_bimc_rxrsp2)                      o_bimc_rxrsp2[07:00]                      <= f32_data[07:00]; 
      if(w_load_bimc_rxrsp2)                      o_bimc_rxrsp2[08:08]                      <= f32_data[08:08]; 
      if(w_load_bimc_pollrsp2)                    o_bimc_pollrsp2[07:00]                    <= f32_data[07:00]; 
      if(w_load_bimc_pollrsp2)                    o_bimc_pollrsp2[08:08]                    <= f32_data[08:08]; 
      if(w_load_bimc_dbgcmd2)                     o_bimc_dbgcmd2[07:00]                     <= f32_data[07:00]; 
      if(w_load_bimc_dbgcmd2)                     o_bimc_dbgcmd2[08:08]                     <= f32_data[08:08]; 
      if(w_load_gzip_os)                          o_gzip_os[07:00]                          <= f32_data[07:00]; 
    end
  end

  
  
  
  always_ff @(posedge clk) begin
      if(w_load_out_ia_wdata_part0)               o_out_ia_wdata_part0[13:06]               <= f32_data[13:06]; 
      if(w_load_out_ia_wdata_part0)               o_out_ia_wdata_part0[14:14]               <= f32_data[14:14]; 
      if(w_load_out_ia_wdata_part0)               o_out_ia_wdata_part0[22:15]               <= f32_data[22:15]; 
      if(w_load_out_ia_wdata_part0)               o_out_ia_wdata_part0[30:23]               <= f32_data[30:23]; 
      if(w_load_out_ia_wdata_part0)               o_out_ia_wdata_part0[31:31]               <= f32_data[31:31]; 
      if(w_load_sh_bl_ia_wdata_part0)             o_sh_bl_ia_wdata_part0[21:21]             <= f32_data[21:21]; 
      if(w_load_sh_bl_ia_wdata_part0)             o_sh_bl_ia_wdata_part0[22:22]             <= f32_data[22:22]; 
      if(w_load_sh_bl_ia_wdata_part0)             o_sh_bl_ia_wdata_part0[23:23]             <= f32_data[23:23]; 
      if(w_load_sh_bl_ia_wdata_part0)             o_sh_bl_ia_wdata_part0[30:24]             <= f32_data[30:24]; 
      if(w_load_sh_bl_ia_wdata_part0)             o_sh_bl_ia_wdata_part0[31:31]             <= f32_data[31:31]; 
      if(w_load_lng_bl_ia_wdata_part0)            o_lng_bl_ia_wdata_part0[21:21]            <= f32_data[21:21]; 
      if(w_load_lng_bl_ia_wdata_part0)            o_lng_bl_ia_wdata_part0[22:22]            <= f32_data[22:22]; 
      if(w_load_lng_bl_ia_wdata_part0)            o_lng_bl_ia_wdata_part0[23:23]            <= f32_data[23:23]; 
      if(w_load_lng_bl_ia_wdata_part0)            o_lng_bl_ia_wdata_part0[30:24]            <= f32_data[30:24]; 
      if(w_load_lng_bl_ia_wdata_part0)            o_lng_bl_ia_wdata_part0[31:31]            <= f32_data[31:31]; 
      if(w_load_st_sh_bl_ia_wdata_part0)          o_st_sh_bl_ia_wdata_part0[21:21]          <= f32_data[21:21]; 
      if(w_load_st_sh_bl_ia_wdata_part0)          o_st_sh_bl_ia_wdata_part0[22:22]          <= f32_data[22:22]; 
      if(w_load_st_sh_bl_ia_wdata_part0)          o_st_sh_bl_ia_wdata_part0[23:23]          <= f32_data[23:23]; 
      if(w_load_st_sh_bl_ia_wdata_part0)          o_st_sh_bl_ia_wdata_part0[30:24]          <= f32_data[30:24]; 
      if(w_load_st_sh_bl_ia_wdata_part0)          o_st_sh_bl_ia_wdata_part0[31:31]          <= f32_data[31:31]; 
      if(w_load_st_lng_bl_ia_wdata_part0)         o_st_lng_bl_ia_wdata_part0[21:21]         <= f32_data[21:21]; 
      if(w_load_st_lng_bl_ia_wdata_part0)         o_st_lng_bl_ia_wdata_part0[22:22]         <= f32_data[22:22]; 
      if(w_load_st_lng_bl_ia_wdata_part0)         o_st_lng_bl_ia_wdata_part0[23:23]         <= f32_data[23:23]; 
      if(w_load_st_lng_bl_ia_wdata_part0)         o_st_lng_bl_ia_wdata_part0[30:24]         <= f32_data[30:24]; 
      if(w_load_st_lng_bl_ia_wdata_part0)         o_st_lng_bl_ia_wdata_part0[31:31]         <= f32_data[31:31]; 
      if(w_load_bimc_rxcmd2)                      o_bimc_rxcmd2[09:09]                      <= f32_data[09:09]; 
      if(w_load_bimc_rxrsp2)                      o_bimc_rxrsp2[09:09]                      <= f32_data[09:09]; 
      if(w_load_bimc_pollrsp2)                    o_bimc_pollrsp2[09:09]                    <= f32_data[09:09]; 
      if(w_load_bimc_dbgcmd2)                     o_bimc_dbgcmd2[09:09]                     <= f32_data[09:09]; 
  end
  

  

endmodule
