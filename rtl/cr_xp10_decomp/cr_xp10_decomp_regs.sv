/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











`include "cr_xp10_decomp.vh"




module cr_xp10_decomp_regs (
  input                                        clk,
  input                                        i_reset_,
  input                                        i_sw_init,

  
  input      [`CR_XP10_DECOMP_DECL]            i_addr,
  input                                        i_wr_strb,
  input      [31:0]                            i_wr_data,
  input                                        i_rd_strb,
  output     [31:0]                            o_rd_data,
  output                                       o_ack,
  output                                       o_err_ack,

  
  output     [`CR_XP10_DECOMP_C_SPARE_T_DECL]  o_spare_config,
  output     [`CR_XP10_DECOMP_C_LZ_BYPASS_T_DECL] o_lz_bypass_config,
  output     [`CR_XP10_DECOMP_C_IGNORE_CRC_T_DECL] o_ignore_crc_config,
  output     [`CR_XP10_DECOMP_C_LZ_DECOMP_OLIMIT_T_DECL] o_lz_decomp_olimit,
  output     [`CR_XP10_DECOMP_C_DECOMP_DP_TLV_PARSE_ACTION_31_0_T_DECL] o_decomp_dp_tlv_parse_action_0,
  output     [`CR_XP10_DECOMP_C_DECOMP_DP_TLV_PARSE_ACTION_63_32_T_DECL] o_decomp_dp_tlv_parse_action_1,
  output     [`CR_XP10_DECOMP_C_LZ77D_OUT_PART0_T_DECL] o_lz77d_out_ia_wdata_part0,
  output     [`CR_XP10_DECOMP_C_LZ77D_OUT_PART1_T_DECL] o_lz77d_out_ia_wdata_part1,
  output     [`CR_XP10_DECOMP_C_LZ77D_OUT_PART2_T_DECL] o_lz77d_out_ia_wdata_part2,
  output     [`CR_XP10_DECOMP_C_LZ77D_OUT_IA_CONFIG_T_DECL] o_lz77d_out_ia_config,
  output     [`CR_XP10_DECOMP_C_LZ77D_OUT_IM_CONFIG_T_DECL] o_lz77d_out_im_config,
  output     [`CR_XP10_DECOMP_C_LZ77D_OUT_IM_CONSUMED_T_DECL] o_lz77d_out_im_read_done,
  output     [`CR_XP10_DECOMP_C_XPD_OUT_PART0_T_DECL] o_xpd_out_ia_wdata_part0,
  output     [`CR_XP10_DECOMP_C_XPD_OUT_PART1_T_DECL] o_xpd_out_ia_wdata_part1,
  output     [`CR_XP10_DECOMP_C_XPD_OUT_PART2_T_DECL] o_xpd_out_ia_wdata_part2,
  output     [`CR_XP10_DECOMP_C_XPD_OUT_IA_CONFIG_T_DECL] o_xpd_out_ia_config,
  output     [`CR_XP10_DECOMP_C_XPD_OUT_IM_CONFIG_T_DECL] o_xpd_out_im_config,
  output     [`CR_XP10_DECOMP_C_XPD_OUT_IM_CONSUMED_T_DECL] o_xpd_out_im_read_done,
  output     [`CR_XP10_DECOMP_C_HTF_BL_OUT_PART0_T_DECL] o_htf_bl_out_ia_wdata_part0,
  output     [`CR_XP10_DECOMP_C_HTF_BL_OUT_PART1_T_DECL] o_htf_bl_out_ia_wdata_part1,
  output     [`CR_XP10_DECOMP_C_HTF_BL_OUT_PART2_T_DECL] o_htf_bl_out_ia_wdata_part2,
  output     [`CR_XP10_DECOMP_C_HTF_BL_OUT_IA_CONFIG_T_DECL] o_htf_bl_out_ia_config,
  output     [`CR_XP10_DECOMP_C_HTF_BL_OUT_IM_CONFIG_T_DECL] o_htf_bl_out_im_config,
  output     [`CR_XP10_DECOMP_C_HTF_BL_OUT_IM_CONSUMED_T_DECL] o_htf_bl_out_im_read_done,
  output     [`CR_XP10_DECOMP_C_BIMC_MONITOR_MASK_T_DECL] o_bimc_monitor_mask,
  output     [`CR_XP10_DECOMP_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_uncorrectable_error_cnt,
  output     [`CR_XP10_DECOMP_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_correctable_error_cnt,
  output     [`CR_XP10_DECOMP_C_BIMC_PARITY_ERROR_CNT_T_DECL] o_bimc_parity_error_cnt,
  output     [`CR_XP10_DECOMP_C_BIMC_GLOBAL_CONFIG_T_DECL] o_bimc_global_config,
  output     [`CR_XP10_DECOMP_C_BIMC_ECCPAR_DEBUG_T_DECL] o_bimc_eccpar_debug,
  output     [`CR_XP10_DECOMP_C_BIMC_CMD2_T_DECL] o_bimc_cmd2,
  output     [`CR_XP10_DECOMP_C_BIMC_CMD1_T_DECL] o_bimc_cmd1,
  output     [`CR_XP10_DECOMP_C_BIMC_CMD0_T_DECL] o_bimc_cmd0,
  output     [`CR_XP10_DECOMP_C_BIMC_RXCMD2_T_DECL] o_bimc_rxcmd2,
  output     [`CR_XP10_DECOMP_C_BIMC_RXRSP2_T_DECL] o_bimc_rxrsp2,
  output     [`CR_XP10_DECOMP_C_BIMC_POLLRSP2_T_DECL] o_bimc_pollrsp2,
  output     [`CR_XP10_DECOMP_C_BIMC_DBGCMD2_T_DECL] o_bimc_dbgcmd2,

  
  input      [`CR_XP10_DECOMP_C_REVID_T_DECL]  i_revision_config,
  input      [`CR_XP10_DECOMP_C_SPARE_T_DECL]  i_spare_config,
  input      [`CR_XP10_DECOMP_C_LZ_BYTES_DECOMP_T_DECL] i_lz_bytes_decomp,
  input      [`CR_XP10_DECOMP_C_LZ_HB_BYTES_T_DECL] i_lz_hb_bytes,
  input      [`CR_XP10_DECOMP_C_LZ_LOCAL_BYTES_T_DECL] i_lz_local_bytes,
  input      [`CR_XP10_DECOMP_C_LZ_HB_TAIL_PTR_T_DECL] i_lz_hb_tail_ptr,
  input      [`CR_XP10_DECOMP_C_LZ_HB_HEAD_PTR_T_DECL] i_lz_hb_head_ptr,
  input      [`CR_XP10_DECOMP_C_LZ77D_OUT_IA_CAPABILITY_T_DECL] i_lz77d_out_ia_capability,
  input      [`CR_XP10_DECOMP_C_LZ77D_OUT_IA_STATUS_T_DECL] i_lz77d_out_ia_status,
  input      [`CR_XP10_DECOMP_C_LZ77D_OUT_PART0_T_DECL] i_lz77d_out_ia_rdata_part0,
  input      [`CR_XP10_DECOMP_C_LZ77D_OUT_PART1_T_DECL] i_lz77d_out_ia_rdata_part1,
  input      [`CR_XP10_DECOMP_C_LZ77D_OUT_PART2_T_DECL] i_lz77d_out_ia_rdata_part2,
  input      [`CR_XP10_DECOMP_C_LZ77D_OUT_IM_STATUS_T_DECL] i_lz77d_out_im_status,
  input      [`CR_XP10_DECOMP_C_LZ77D_OUT_IM_CONSUMED_T_DECL] i_lz77d_out_im_read_done,
  input      [`CR_XP10_DECOMP_C_XPD_OUT_IA_CAPABILITY_T_DECL] i_xpd_out_ia_capability,
  input      [`CR_XP10_DECOMP_C_XPD_OUT_IA_STATUS_T_DECL] i_xpd_out_ia_status,
  input      [`CR_XP10_DECOMP_C_XPD_OUT_PART0_T_DECL] i_xpd_out_ia_rdata_part0,
  input      [`CR_XP10_DECOMP_C_XPD_OUT_PART1_T_DECL] i_xpd_out_ia_rdata_part1,
  input      [`CR_XP10_DECOMP_C_XPD_OUT_PART2_T_DECL] i_xpd_out_ia_rdata_part2,
  input      [`CR_XP10_DECOMP_C_XPD_OUT_IM_STATUS_T_DECL] i_xpd_out_im_status,
  input      [`CR_XP10_DECOMP_C_XPD_OUT_IM_CONSUMED_T_DECL] i_xpd_out_im_read_done,
  input      [`CR_XP10_DECOMP_C_HTF_BL_OUT_IA_CAPABILITY_T_DECL] i_htf_bl_out_ia_capability,
  input      [`CR_XP10_DECOMP_C_HTF_BL_OUT_IA_STATUS_T_DECL] i_htf_bl_out_ia_status,
  input      [`CR_XP10_DECOMP_C_HTF_BL_OUT_PART0_T_DECL] i_htf_bl_out_ia_rdata_part0,
  input      [`CR_XP10_DECOMP_C_HTF_BL_OUT_PART1_T_DECL] i_htf_bl_out_ia_rdata_part1,
  input      [`CR_XP10_DECOMP_C_HTF_BL_OUT_PART2_T_DECL] i_htf_bl_out_ia_rdata_part2,
  input      [`CR_XP10_DECOMP_C_HTF_BL_OUT_IM_STATUS_T_DECL] i_htf_bl_out_im_status,
  input      [`CR_XP10_DECOMP_C_HTF_BL_OUT_IM_CONSUMED_T_DECL] i_htf_bl_out_im_read_done,
  input      [`CR_XP10_DECOMP_C_BIMC_MONITOR_T_DECL] i_bimc_monitor,
  input      [`CR_XP10_DECOMP_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_uncorrectable_error_cnt,
  input      [`CR_XP10_DECOMP_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_correctable_error_cnt,
  input      [`CR_XP10_DECOMP_C_BIMC_PARITY_ERROR_CNT_T_DECL] i_bimc_parity_error_cnt,
  input      [`CR_XP10_DECOMP_C_BIMC_GLOBAL_CONFIG_T_DECL] i_bimc_global_config,
  input      [`CR_XP10_DECOMP_C_BIMC_MEMID_T_DECL] i_bimc_memid,
  input      [`CR_XP10_DECOMP_C_BIMC_ECCPAR_DEBUG_T_DECL] i_bimc_eccpar_debug,
  input      [`CR_XP10_DECOMP_C_BIMC_CMD2_T_DECL] i_bimc_cmd2,
  input      [`CR_XP10_DECOMP_C_BIMC_RXCMD2_T_DECL] i_bimc_rxcmd2,
  input      [`CR_XP10_DECOMP_C_BIMC_RXCMD1_T_DECL] i_bimc_rxcmd1,
  input      [`CR_XP10_DECOMP_C_BIMC_RXCMD0_T_DECL] i_bimc_rxcmd0,
  input      [`CR_XP10_DECOMP_C_BIMC_RXRSP2_T_DECL] i_bimc_rxrsp2,
  input      [`CR_XP10_DECOMP_C_BIMC_RXRSP1_T_DECL] i_bimc_rxrsp1,
  input      [`CR_XP10_DECOMP_C_BIMC_RXRSP0_T_DECL] i_bimc_rxrsp0,
  input      [`CR_XP10_DECOMP_C_BIMC_POLLRSP2_T_DECL] i_bimc_pollrsp2,
  input      [`CR_XP10_DECOMP_C_BIMC_POLLRSP1_T_DECL] i_bimc_pollrsp1,
  input      [`CR_XP10_DECOMP_C_BIMC_POLLRSP0_T_DECL] i_bimc_pollrsp0,
  input      [`CR_XP10_DECOMP_C_BIMC_DBGCMD2_T_DECL] i_bimc_dbgcmd2,
  input      [`CR_XP10_DECOMP_C_BIMC_DBGCMD1_T_DECL] i_bimc_dbgcmd1,
  input      [`CR_XP10_DECOMP_C_BIMC_DBGCMD0_T_DECL] i_bimc_dbgcmd0,

  
  output reg                                   o_reg_written,
  output reg                                   o_reg_read,
  output     [31:0]                            o_reg_wr_data,
  output reg [`CR_XP10_DECOMP_DECL]            o_reg_addr
  );


  


  
  


  
  wire [`CR_XP10_DECOMP_DECL] ws_read_addr    = o_reg_addr;
  wire [`CR_XP10_DECOMP_DECL] ws_addr         = o_reg_addr;
  

  wire n_wr_strobe = i_wr_strb;
  wire n_rd_strobe = i_rd_strb;

  wire w_32b_aligned    = (o_reg_addr[1:0] == 2'h0);

  wire w_valid_rd_addr     = (w_32b_aligned && (ws_addr >= `CR_XP10_DECOMP_REVISION_CONFIG) && (ws_addr <= `CR_XP10_DECOMP_LZ_DECOMP_OLIMIT))
                          || (w_32b_aligned && (ws_addr >= `CR_XP10_DECOMP_DECOMP_DP_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_XP10_DECOMP_HTF_BL_OUT_IM_READ_DONE))
                          || (w_32b_aligned && (ws_addr >= `CR_XP10_DECOMP_BIMC_MONITOR) && (ws_addr <= `CR_XP10_DECOMP_BIMC_DBGCMD0));

  wire w_valid_wr_addr     = (w_32b_aligned && (ws_addr >= `CR_XP10_DECOMP_REVISION_CONFIG) && (ws_addr <= `CR_XP10_DECOMP_LZ_DECOMP_OLIMIT))
                          || (w_32b_aligned && (ws_addr >= `CR_XP10_DECOMP_DECOMP_DP_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_XP10_DECOMP_HTF_BL_OUT_IM_READ_DONE))
                          || (w_32b_aligned && (ws_addr >= `CR_XP10_DECOMP_BIMC_MONITOR) && (ws_addr <= `CR_XP10_DECOMP_BIMC_DBGCMD0));

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

  wire [31:0]  r32_formatted_reg_data = f32_mux_0_data
                                      | f32_mux_1_data
                                      | f32_mux_2_data;

  always_comb begin
    r32_mux_0_data = 0;
    r32_mux_1_data = 0;
    r32_mux_2_data = 0;

    case (ws_read_addr)
    `CR_XP10_DECOMP_REVISION_CONFIG: begin
      r32_mux_0_data[07:00] = i_revision_config[07:00]; 
    end
    `CR_XP10_DECOMP_SPARE_CONFIG: begin
      r32_mux_0_data[31:00] = i_spare_config[31:00]; 
    end
    `CR_XP10_DECOMP_LZ_BYPASS_CONFIG: begin
      r32_mux_0_data[00:00] = o_lz_bypass_config[00:00]; 
    end
    `CR_XP10_DECOMP_IGNORE_CRC_CONFIG: begin
      r32_mux_0_data[00:00] = o_ignore_crc_config[00:00]; 
    end
    `CR_XP10_DECOMP_LZ_BYTES_DECOMP: begin
      r32_mux_0_data[16:00] = i_lz_bytes_decomp[16:00]; 
    end
    `CR_XP10_DECOMP_LZ_HB_BYTES: begin
      r32_mux_0_data[16:00] = i_lz_hb_bytes[16:00]; 
    end
    `CR_XP10_DECOMP_LZ_LOCAL_BYTES: begin
      r32_mux_0_data[16:00] = i_lz_local_bytes[16:00]; 
    end
    `CR_XP10_DECOMP_LZ_HB_TAIL_PTR: begin
      r32_mux_0_data[11:00] = i_lz_hb_tail_ptr[11:00]; 
    end
    `CR_XP10_DECOMP_LZ_HB_HEAD_PTR: begin
      r32_mux_0_data[11:00] = i_lz_hb_head_ptr[11:00]; 
    end
    `CR_XP10_DECOMP_LZ_DECOMP_OLIMIT: begin
      r32_mux_0_data[23:00] = o_lz_decomp_olimit[23:00]; 
    end
    `CR_XP10_DECOMP_DECOMP_DP_TLV_PARSE_ACTION_0: begin
      r32_mux_0_data[01:00] = o_decomp_dp_tlv_parse_action_0[01:00]; 
      r32_mux_0_data[03:02] = o_decomp_dp_tlv_parse_action_0[03:02]; 
      r32_mux_0_data[05:04] = o_decomp_dp_tlv_parse_action_0[05:04]; 
      r32_mux_0_data[07:06] = o_decomp_dp_tlv_parse_action_0[07:06]; 
      r32_mux_0_data[09:08] = o_decomp_dp_tlv_parse_action_0[09:08]; 
      r32_mux_0_data[11:10] = o_decomp_dp_tlv_parse_action_0[11:10]; 
      r32_mux_0_data[13:12] = o_decomp_dp_tlv_parse_action_0[13:12]; 
      r32_mux_0_data[15:14] = o_decomp_dp_tlv_parse_action_0[15:14]; 
      r32_mux_0_data[17:16] = o_decomp_dp_tlv_parse_action_0[17:16]; 
      r32_mux_0_data[19:18] = o_decomp_dp_tlv_parse_action_0[19:18]; 
      r32_mux_0_data[21:20] = o_decomp_dp_tlv_parse_action_0[21:20]; 
      r32_mux_0_data[23:22] = o_decomp_dp_tlv_parse_action_0[23:22]; 
      r32_mux_0_data[25:24] = o_decomp_dp_tlv_parse_action_0[25:24]; 
      r32_mux_0_data[27:26] = o_decomp_dp_tlv_parse_action_0[27:26]; 
      r32_mux_0_data[29:28] = o_decomp_dp_tlv_parse_action_0[29:28]; 
      r32_mux_0_data[31:30] = o_decomp_dp_tlv_parse_action_0[31:30]; 
    end
    `CR_XP10_DECOMP_DECOMP_DP_TLV_PARSE_ACTION_1: begin
      r32_mux_0_data[01:00] = o_decomp_dp_tlv_parse_action_1[01:00]; 
      r32_mux_0_data[03:02] = o_decomp_dp_tlv_parse_action_1[03:02]; 
      r32_mux_0_data[05:04] = o_decomp_dp_tlv_parse_action_1[05:04]; 
      r32_mux_0_data[07:06] = o_decomp_dp_tlv_parse_action_1[07:06]; 
      r32_mux_0_data[09:08] = o_decomp_dp_tlv_parse_action_1[09:08]; 
      r32_mux_0_data[11:10] = o_decomp_dp_tlv_parse_action_1[11:10]; 
      r32_mux_0_data[13:12] = o_decomp_dp_tlv_parse_action_1[13:12]; 
      r32_mux_0_data[15:14] = o_decomp_dp_tlv_parse_action_1[15:14]; 
      r32_mux_0_data[17:16] = o_decomp_dp_tlv_parse_action_1[17:16]; 
      r32_mux_0_data[19:18] = o_decomp_dp_tlv_parse_action_1[19:18]; 
      r32_mux_0_data[21:20] = o_decomp_dp_tlv_parse_action_1[21:20]; 
      r32_mux_0_data[23:22] = o_decomp_dp_tlv_parse_action_1[23:22]; 
      r32_mux_0_data[25:24] = o_decomp_dp_tlv_parse_action_1[25:24]; 
      r32_mux_0_data[27:26] = o_decomp_dp_tlv_parse_action_1[27:26]; 
      r32_mux_0_data[29:28] = o_decomp_dp_tlv_parse_action_1[29:28]; 
      r32_mux_0_data[31:30] = o_decomp_dp_tlv_parse_action_1[31:30]; 
    end
    `CR_XP10_DECOMP_LZ77D_OUT_IA_CAPABILITY: begin
      r32_mux_0_data[00:00] = i_lz77d_out_ia_capability[00:00]; 
      r32_mux_0_data[01:01] = i_lz77d_out_ia_capability[01:01]; 
      r32_mux_0_data[02:02] = i_lz77d_out_ia_capability[02:02]; 
      r32_mux_0_data[03:03] = i_lz77d_out_ia_capability[03:03]; 
      r32_mux_0_data[04:04] = i_lz77d_out_ia_capability[04:04]; 
      r32_mux_0_data[05:05] = i_lz77d_out_ia_capability[05:05]; 
      r32_mux_0_data[06:06] = i_lz77d_out_ia_capability[06:06]; 
      r32_mux_0_data[07:07] = i_lz77d_out_ia_capability[07:07]; 
      r32_mux_0_data[08:08] = i_lz77d_out_ia_capability[08:08]; 
      r32_mux_0_data[09:09] = i_lz77d_out_ia_capability[09:09]; 
      r32_mux_0_data[13:10] = i_lz77d_out_ia_capability[13:10]; 
      r32_mux_0_data[14:14] = i_lz77d_out_ia_capability[14:14]; 
      r32_mux_0_data[15:15] = i_lz77d_out_ia_capability[15:15]; 
      r32_mux_0_data[31:28] = i_lz77d_out_ia_capability[19:16]; 
    end
    `CR_XP10_DECOMP_LZ77D_OUT_IA_STATUS: begin
      r32_mux_0_data[08:00] = i_lz77d_out_ia_status[08:00]; 
      r32_mux_0_data[28:24] = i_lz77d_out_ia_status[13:09]; 
      r32_mux_0_data[31:29] = i_lz77d_out_ia_status[16:14]; 
    end
    `CR_XP10_DECOMP_LZ77D_OUT_IA_WDATA_PART0: begin
      r32_mux_0_data[05:00] = o_lz77d_out_ia_wdata_part0[05:00]; 
      r32_mux_0_data[13:06] = o_lz77d_out_ia_wdata_part0[13:06]; 
      r32_mux_0_data[14:14] = o_lz77d_out_ia_wdata_part0[14:14]; 
      r32_mux_0_data[22:15] = o_lz77d_out_ia_wdata_part0[22:15]; 
      r32_mux_0_data[30:23] = o_lz77d_out_ia_wdata_part0[30:23]; 
      r32_mux_0_data[31:31] = o_lz77d_out_ia_wdata_part0[31:31]; 
    end
    `CR_XP10_DECOMP_LZ77D_OUT_IA_WDATA_PART1: begin
      r32_mux_0_data[31:00] = o_lz77d_out_ia_wdata_part1[31:00]; 
    end
    `CR_XP10_DECOMP_LZ77D_OUT_IA_WDATA_PART2: begin
      r32_mux_0_data[31:00] = o_lz77d_out_ia_wdata_part2[31:00]; 
    end
    `CR_XP10_DECOMP_LZ77D_OUT_IA_CONFIG: begin
      r32_mux_0_data[08:00] = o_lz77d_out_ia_config[08:00]; 
      r32_mux_0_data[31:28] = o_lz77d_out_ia_config[12:09]; 
    end
    `CR_XP10_DECOMP_LZ77D_OUT_IA_RDATA_PART0: begin
      r32_mux_0_data[05:00] = i_lz77d_out_ia_rdata_part0[05:00]; 
      r32_mux_0_data[13:06] = i_lz77d_out_ia_rdata_part0[13:06]; 
      r32_mux_0_data[14:14] = i_lz77d_out_ia_rdata_part0[14:14]; 
      r32_mux_0_data[22:15] = i_lz77d_out_ia_rdata_part0[22:15]; 
      r32_mux_0_data[30:23] = i_lz77d_out_ia_rdata_part0[30:23]; 
      r32_mux_0_data[31:31] = i_lz77d_out_ia_rdata_part0[31:31]; 
    end
    `CR_XP10_DECOMP_LZ77D_OUT_IA_RDATA_PART1: begin
      r32_mux_0_data[31:00] = i_lz77d_out_ia_rdata_part1[31:00]; 
    end
    `CR_XP10_DECOMP_LZ77D_OUT_IA_RDATA_PART2: begin
      r32_mux_0_data[31:00] = i_lz77d_out_ia_rdata_part2[31:00]; 
    end
    `CR_XP10_DECOMP_LZ77D_OUT_IM_CONFIG: begin
      r32_mux_0_data[09:00] = o_lz77d_out_im_config[09:00]; 
      r32_mux_0_data[31:30] = o_lz77d_out_im_config[11:10]; 
    end
    `CR_XP10_DECOMP_LZ77D_OUT_IM_STATUS: begin
      r32_mux_0_data[08:00] = i_lz77d_out_im_status[08:00]; 
      r32_mux_0_data[29:29] = i_lz77d_out_im_status[09:09]; 
      r32_mux_0_data[30:30] = i_lz77d_out_im_status[10:10]; 
      r32_mux_0_data[31:31] = i_lz77d_out_im_status[11:11]; 
    end
    `CR_XP10_DECOMP_LZ77D_OUT_IM_READ_DONE: begin
      r32_mux_0_data[30:30] = i_lz77d_out_im_read_done[00:00]; 
      r32_mux_0_data[31:31] = i_lz77d_out_im_read_done[01:01]; 
    end
    endcase

    case (ws_read_addr)
    `CR_XP10_DECOMP_XPD_OUT_IA_CAPABILITY: begin
      r32_mux_1_data[00:00] = i_xpd_out_ia_capability[00:00]; 
      r32_mux_1_data[01:01] = i_xpd_out_ia_capability[01:01]; 
      r32_mux_1_data[02:02] = i_xpd_out_ia_capability[02:02]; 
      r32_mux_1_data[03:03] = i_xpd_out_ia_capability[03:03]; 
      r32_mux_1_data[04:04] = i_xpd_out_ia_capability[04:04]; 
      r32_mux_1_data[05:05] = i_xpd_out_ia_capability[05:05]; 
      r32_mux_1_data[06:06] = i_xpd_out_ia_capability[06:06]; 
      r32_mux_1_data[07:07] = i_xpd_out_ia_capability[07:07]; 
      r32_mux_1_data[08:08] = i_xpd_out_ia_capability[08:08]; 
      r32_mux_1_data[09:09] = i_xpd_out_ia_capability[09:09]; 
      r32_mux_1_data[13:10] = i_xpd_out_ia_capability[13:10]; 
      r32_mux_1_data[14:14] = i_xpd_out_ia_capability[14:14]; 
      r32_mux_1_data[15:15] = i_xpd_out_ia_capability[15:15]; 
      r32_mux_1_data[31:28] = i_xpd_out_ia_capability[19:16]; 
    end
    `CR_XP10_DECOMP_XPD_OUT_IA_STATUS: begin
      r32_mux_1_data[08:00] = i_xpd_out_ia_status[08:00]; 
      r32_mux_1_data[28:24] = i_xpd_out_ia_status[13:09]; 
      r32_mux_1_data[31:29] = i_xpd_out_ia_status[16:14]; 
    end
    `CR_XP10_DECOMP_XPD_OUT_IA_WDATA_PART0: begin
      r32_mux_1_data[30:00] = o_xpd_out_ia_wdata_part0[30:00]; 
      r32_mux_1_data[31:31] = o_xpd_out_ia_wdata_part0[31:31]; 
    end
    `CR_XP10_DECOMP_XPD_OUT_IA_WDATA_PART1: begin
      r32_mux_1_data[31:00] = o_xpd_out_ia_wdata_part1[31:00]; 
    end
    `CR_XP10_DECOMP_XPD_OUT_IA_WDATA_PART2: begin
      r32_mux_1_data[31:00] = o_xpd_out_ia_wdata_part2[31:00]; 
    end
    `CR_XP10_DECOMP_XPD_OUT_IA_CONFIG: begin
      r32_mux_1_data[08:00] = o_xpd_out_ia_config[08:00]; 
      r32_mux_1_data[31:28] = o_xpd_out_ia_config[12:09]; 
    end
    `CR_XP10_DECOMP_XPD_OUT_IA_RDATA_PART0: begin
      r32_mux_1_data[30:00] = i_xpd_out_ia_rdata_part0[30:00]; 
      r32_mux_1_data[31:31] = i_xpd_out_ia_rdata_part0[31:31]; 
    end
    `CR_XP10_DECOMP_XPD_OUT_IA_RDATA_PART1: begin
      r32_mux_1_data[31:00] = i_xpd_out_ia_rdata_part1[31:00]; 
    end
    `CR_XP10_DECOMP_XPD_OUT_IA_RDATA_PART2: begin
      r32_mux_1_data[31:00] = i_xpd_out_ia_rdata_part2[31:00]; 
    end
    `CR_XP10_DECOMP_XPD_OUT_IM_CONFIG: begin
      r32_mux_1_data[09:00] = o_xpd_out_im_config[09:00]; 
      r32_mux_1_data[31:30] = o_xpd_out_im_config[11:10]; 
    end
    `CR_XP10_DECOMP_XPD_OUT_IM_STATUS: begin
      r32_mux_1_data[08:00] = i_xpd_out_im_status[08:00]; 
      r32_mux_1_data[29:29] = i_xpd_out_im_status[09:09]; 
      r32_mux_1_data[30:30] = i_xpd_out_im_status[10:10]; 
      r32_mux_1_data[31:31] = i_xpd_out_im_status[11:11]; 
    end
    `CR_XP10_DECOMP_XPD_OUT_IM_READ_DONE: begin
      r32_mux_1_data[30:30] = i_xpd_out_im_read_done[00:00]; 
      r32_mux_1_data[31:31] = i_xpd_out_im_read_done[01:01]; 
    end
    `CR_XP10_DECOMP_HTF_BL_OUT_IA_CAPABILITY: begin
      r32_mux_1_data[00:00] = i_htf_bl_out_ia_capability[00:00]; 
      r32_mux_1_data[01:01] = i_htf_bl_out_ia_capability[01:01]; 
      r32_mux_1_data[02:02] = i_htf_bl_out_ia_capability[02:02]; 
      r32_mux_1_data[03:03] = i_htf_bl_out_ia_capability[03:03]; 
      r32_mux_1_data[04:04] = i_htf_bl_out_ia_capability[04:04]; 
      r32_mux_1_data[05:05] = i_htf_bl_out_ia_capability[05:05]; 
      r32_mux_1_data[06:06] = i_htf_bl_out_ia_capability[06:06]; 
      r32_mux_1_data[07:07] = i_htf_bl_out_ia_capability[07:07]; 
      r32_mux_1_data[08:08] = i_htf_bl_out_ia_capability[08:08]; 
      r32_mux_1_data[09:09] = i_htf_bl_out_ia_capability[09:09]; 
      r32_mux_1_data[13:10] = i_htf_bl_out_ia_capability[13:10]; 
      r32_mux_1_data[14:14] = i_htf_bl_out_ia_capability[14:14]; 
      r32_mux_1_data[15:15] = i_htf_bl_out_ia_capability[15:15]; 
      r32_mux_1_data[31:28] = i_htf_bl_out_ia_capability[19:16]; 
    end
    `CR_XP10_DECOMP_HTF_BL_OUT_IA_STATUS: begin
      r32_mux_1_data[07:00] = i_htf_bl_out_ia_status[07:00]; 
      r32_mux_1_data[28:24] = i_htf_bl_out_ia_status[12:08]; 
      r32_mux_1_data[31:29] = i_htf_bl_out_ia_status[15:13]; 
    end
    `CR_XP10_DECOMP_HTF_BL_OUT_IA_WDATA_PART0: begin
      r32_mux_1_data[00:00] = o_htf_bl_out_ia_wdata_part0[00:00]; 
      r32_mux_1_data[01:01] = o_htf_bl_out_ia_wdata_part0[01:01]; 
      r32_mux_1_data[30:02] = o_htf_bl_out_ia_wdata_part0[30:02]; 
      r32_mux_1_data[31:31] = o_htf_bl_out_ia_wdata_part0[31:31]; 
    end
    `CR_XP10_DECOMP_HTF_BL_OUT_IA_WDATA_PART1: begin
      r32_mux_1_data[07:00] = o_htf_bl_out_ia_wdata_part1[07:00]; 
      r32_mux_1_data[15:08] = o_htf_bl_out_ia_wdata_part1[15:08]; 
      r32_mux_1_data[23:16] = o_htf_bl_out_ia_wdata_part1[23:16]; 
      r32_mux_1_data[31:24] = o_htf_bl_out_ia_wdata_part1[31:24]; 
    end
    `CR_XP10_DECOMP_HTF_BL_OUT_IA_WDATA_PART2: begin
      r32_mux_1_data[07:00] = o_htf_bl_out_ia_wdata_part2[07:00]; 
      r32_mux_1_data[15:08] = o_htf_bl_out_ia_wdata_part2[15:08]; 
      r32_mux_1_data[23:16] = o_htf_bl_out_ia_wdata_part2[23:16]; 
      r32_mux_1_data[31:24] = o_htf_bl_out_ia_wdata_part2[31:24]; 
    end
    `CR_XP10_DECOMP_HTF_BL_OUT_IA_CONFIG: begin
      r32_mux_1_data[07:00] = o_htf_bl_out_ia_config[07:00]; 
      r32_mux_1_data[31:28] = o_htf_bl_out_ia_config[11:08]; 
    end
    `CR_XP10_DECOMP_HTF_BL_OUT_IA_RDATA_PART0: begin
      r32_mux_1_data[00:00] = i_htf_bl_out_ia_rdata_part0[00:00]; 
      r32_mux_1_data[01:01] = i_htf_bl_out_ia_rdata_part0[01:01]; 
      r32_mux_1_data[30:02] = i_htf_bl_out_ia_rdata_part0[30:02]; 
      r32_mux_1_data[31:31] = i_htf_bl_out_ia_rdata_part0[31:31]; 
    end
    `CR_XP10_DECOMP_HTF_BL_OUT_IA_RDATA_PART1: begin
      r32_mux_1_data[07:00] = i_htf_bl_out_ia_rdata_part1[07:00]; 
      r32_mux_1_data[15:08] = i_htf_bl_out_ia_rdata_part1[15:08]; 
      r32_mux_1_data[23:16] = i_htf_bl_out_ia_rdata_part1[23:16]; 
      r32_mux_1_data[31:24] = i_htf_bl_out_ia_rdata_part1[31:24]; 
    end
    `CR_XP10_DECOMP_HTF_BL_OUT_IA_RDATA_PART2: begin
      r32_mux_1_data[07:00] = i_htf_bl_out_ia_rdata_part2[07:00]; 
      r32_mux_1_data[15:08] = i_htf_bl_out_ia_rdata_part2[15:08]; 
      r32_mux_1_data[23:16] = i_htf_bl_out_ia_rdata_part2[23:16]; 
      r32_mux_1_data[31:24] = i_htf_bl_out_ia_rdata_part2[31:24]; 
    end
    `CR_XP10_DECOMP_HTF_BL_OUT_IM_CONFIG: begin
      r32_mux_1_data[07:00] = o_htf_bl_out_im_config[07:00]; 
      r32_mux_1_data[31:30] = o_htf_bl_out_im_config[09:08]; 
    end
    `CR_XP10_DECOMP_HTF_BL_OUT_IM_STATUS: begin
      r32_mux_1_data[07:00] = i_htf_bl_out_im_status[07:00]; 
      r32_mux_1_data[29:29] = i_htf_bl_out_im_status[08:08]; 
      r32_mux_1_data[30:30] = i_htf_bl_out_im_status[09:09]; 
      r32_mux_1_data[31:31] = i_htf_bl_out_im_status[10:10]; 
    end
    `CR_XP10_DECOMP_HTF_BL_OUT_IM_READ_DONE: begin
      r32_mux_1_data[30:30] = i_htf_bl_out_im_read_done[00:00]; 
      r32_mux_1_data[31:31] = i_htf_bl_out_im_read_done[01:01]; 
    end
    endcase

    case (ws_read_addr)
    `CR_XP10_DECOMP_BIMC_MONITOR: begin
      r32_mux_2_data[00:00] = i_bimc_monitor[00:00]; 
      r32_mux_2_data[01:01] = i_bimc_monitor[01:01]; 
      r32_mux_2_data[02:02] = i_bimc_monitor[02:02]; 
      r32_mux_2_data[03:03] = i_bimc_monitor[03:03]; 
      r32_mux_2_data[04:04] = i_bimc_monitor[04:04]; 
      r32_mux_2_data[05:05] = i_bimc_monitor[05:05]; 
      r32_mux_2_data[06:06] = i_bimc_monitor[06:06]; 
    end
    `CR_XP10_DECOMP_BIMC_MONITOR_MASK: begin
      r32_mux_2_data[00:00] = o_bimc_monitor_mask[00:00]; 
      r32_mux_2_data[01:01] = o_bimc_monitor_mask[01:01]; 
      r32_mux_2_data[02:02] = o_bimc_monitor_mask[02:02]; 
      r32_mux_2_data[03:03] = o_bimc_monitor_mask[03:03]; 
      r32_mux_2_data[04:04] = o_bimc_monitor_mask[04:04]; 
      r32_mux_2_data[05:05] = o_bimc_monitor_mask[05:05]; 
      r32_mux_2_data[06:06] = o_bimc_monitor_mask[06:06]; 
    end
    `CR_XP10_DECOMP_BIMC_ECC_UNCORRECTABLE_ERROR_CNT: begin
      r32_mux_2_data[31:00] = i_bimc_ecc_uncorrectable_error_cnt[31:00]; 
    end
    `CR_XP10_DECOMP_BIMC_ECC_CORRECTABLE_ERROR_CNT: begin
      r32_mux_2_data[31:00] = i_bimc_ecc_correctable_error_cnt[31:00]; 
    end
    `CR_XP10_DECOMP_BIMC_PARITY_ERROR_CNT: begin
      r32_mux_2_data[31:00] = i_bimc_parity_error_cnt[31:00]; 
    end
    `CR_XP10_DECOMP_BIMC_GLOBAL_CONFIG: begin
      r32_mux_2_data[00:00] = i_bimc_global_config[00:00]; 
      r32_mux_2_data[01:01] = i_bimc_global_config[01:01]; 
      r32_mux_2_data[02:02] = i_bimc_global_config[02:02]; 
      r32_mux_2_data[03:03] = i_bimc_global_config[03:03]; 
      r32_mux_2_data[04:04] = i_bimc_global_config[04:04]; 
      r32_mux_2_data[05:05] = i_bimc_global_config[05:05]; 
      r32_mux_2_data[31:06] = i_bimc_global_config[31:06]; 
    end
    `CR_XP10_DECOMP_BIMC_MEMID: begin
      r32_mux_2_data[11:00] = i_bimc_memid[11:00]; 
    end
    `CR_XP10_DECOMP_BIMC_ECCPAR_DEBUG: begin
      r32_mux_2_data[11:00] = i_bimc_eccpar_debug[11:00]; 
      r32_mux_2_data[15:12] = i_bimc_eccpar_debug[15:12]; 
      r32_mux_2_data[17:16] = i_bimc_eccpar_debug[17:16]; 
      r32_mux_2_data[19:18] = i_bimc_eccpar_debug[19:18]; 
      r32_mux_2_data[21:20] = i_bimc_eccpar_debug[21:20]; 
      r32_mux_2_data[22:22] = i_bimc_eccpar_debug[22:22]; 
      r32_mux_2_data[23:23] = i_bimc_eccpar_debug[23:23]; 
      r32_mux_2_data[27:24] = i_bimc_eccpar_debug[27:24]; 
      r32_mux_2_data[28:28] = i_bimc_eccpar_debug[28:28]; 
    end
    `CR_XP10_DECOMP_BIMC_CMD2: begin
      r32_mux_2_data[07:00] = i_bimc_cmd2[07:00]; 
      r32_mux_2_data[08:08] = i_bimc_cmd2[08:08]; 
      r32_mux_2_data[09:09] = i_bimc_cmd2[09:09]; 
      r32_mux_2_data[10:10] = i_bimc_cmd2[10:10]; 
    end
    `CR_XP10_DECOMP_BIMC_CMD1: begin
      r32_mux_2_data[15:00] = o_bimc_cmd1[15:00]; 
      r32_mux_2_data[27:16] = o_bimc_cmd1[27:16]; 
      r32_mux_2_data[31:28] = o_bimc_cmd1[31:28]; 
    end
    `CR_XP10_DECOMP_BIMC_CMD0: begin
      r32_mux_2_data[31:00] = o_bimc_cmd0[31:00]; 
    end
    `CR_XP10_DECOMP_BIMC_RXCMD2: begin
      r32_mux_2_data[07:00] = i_bimc_rxcmd2[07:00]; 
      r32_mux_2_data[08:08] = i_bimc_rxcmd2[08:08]; 
      r32_mux_2_data[09:09] = i_bimc_rxcmd2[09:09]; 
    end
    `CR_XP10_DECOMP_BIMC_RXCMD1: begin
      r32_mux_2_data[15:00] = i_bimc_rxcmd1[15:00]; 
      r32_mux_2_data[27:16] = i_bimc_rxcmd1[27:16]; 
      r32_mux_2_data[31:28] = i_bimc_rxcmd1[31:28]; 
    end
    `CR_XP10_DECOMP_BIMC_RXCMD0: begin
      r32_mux_2_data[31:00] = i_bimc_rxcmd0[31:00]; 
    end
    `CR_XP10_DECOMP_BIMC_RXRSP2: begin
      r32_mux_2_data[07:00] = i_bimc_rxrsp2[07:00]; 
      r32_mux_2_data[08:08] = i_bimc_rxrsp2[08:08]; 
      r32_mux_2_data[09:09] = i_bimc_rxrsp2[09:09]; 
    end
    `CR_XP10_DECOMP_BIMC_RXRSP1: begin
      r32_mux_2_data[31:00] = i_bimc_rxrsp1[31:00]; 
    end
    `CR_XP10_DECOMP_BIMC_RXRSP0: begin
      r32_mux_2_data[31:00] = i_bimc_rxrsp0[31:00]; 
    end
    `CR_XP10_DECOMP_BIMC_POLLRSP2: begin
      r32_mux_2_data[07:00] = i_bimc_pollrsp2[07:00]; 
      r32_mux_2_data[08:08] = i_bimc_pollrsp2[08:08]; 
      r32_mux_2_data[09:09] = i_bimc_pollrsp2[09:09]; 
    end
    `CR_XP10_DECOMP_BIMC_POLLRSP1: begin
      r32_mux_2_data[31:00] = i_bimc_pollrsp1[31:00]; 
    end
    `CR_XP10_DECOMP_BIMC_POLLRSP0: begin
      r32_mux_2_data[31:00] = i_bimc_pollrsp0[31:00]; 
    end
    `CR_XP10_DECOMP_BIMC_DBGCMD2: begin
      r32_mux_2_data[07:00] = i_bimc_dbgcmd2[07:00]; 
      r32_mux_2_data[08:08] = i_bimc_dbgcmd2[08:08]; 
      r32_mux_2_data[09:09] = i_bimc_dbgcmd2[09:09]; 
    end
    `CR_XP10_DECOMP_BIMC_DBGCMD1: begin
      r32_mux_2_data[15:00] = i_bimc_dbgcmd1[15:00]; 
      r32_mux_2_data[27:16] = i_bimc_dbgcmd1[27:16]; 
      r32_mux_2_data[31:28] = i_bimc_dbgcmd1[31:28]; 
    end
    `CR_XP10_DECOMP_BIMC_DBGCMD0: begin
      r32_mux_2_data[31:00] = i_bimc_dbgcmd0[31:00]; 
    end
    endcase

  end

  
  

  
  

  reg  [31:0]  f32_data;

  assign o_reg_wr_data = f32_data;

  
  

  
  assign       o_rd_data  = (o_ack  & ~n_write) ? r32_formatted_reg_data : { 32 { 1'b0 } };
  

  
  

  wire w_load_spare_config                     = w_do_write & (ws_addr == `CR_XP10_DECOMP_SPARE_CONFIG);
  wire w_load_lz_bypass_config                 = w_do_write & (ws_addr == `CR_XP10_DECOMP_LZ_BYPASS_CONFIG);
  wire w_load_ignore_crc_config                = w_do_write & (ws_addr == `CR_XP10_DECOMP_IGNORE_CRC_CONFIG);
  wire w_load_lz_decomp_olimit                 = w_do_write & (ws_addr == `CR_XP10_DECOMP_LZ_DECOMP_OLIMIT);
  wire w_load_decomp_dp_tlv_parse_action_0     = w_do_write & (ws_addr == `CR_XP10_DECOMP_DECOMP_DP_TLV_PARSE_ACTION_0);
  wire w_load_decomp_dp_tlv_parse_action_1     = w_do_write & (ws_addr == `CR_XP10_DECOMP_DECOMP_DP_TLV_PARSE_ACTION_1);
  wire w_load_lz77d_out_ia_wdata_part0         = w_do_write & (ws_addr == `CR_XP10_DECOMP_LZ77D_OUT_IA_WDATA_PART0);
  wire w_load_lz77d_out_ia_wdata_part1         = w_do_write & (ws_addr == `CR_XP10_DECOMP_LZ77D_OUT_IA_WDATA_PART1);
  wire w_load_lz77d_out_ia_wdata_part2         = w_do_write & (ws_addr == `CR_XP10_DECOMP_LZ77D_OUT_IA_WDATA_PART2);
  wire w_load_lz77d_out_ia_config              = w_do_write & (ws_addr == `CR_XP10_DECOMP_LZ77D_OUT_IA_CONFIG);
  wire w_load_lz77d_out_im_config              = w_do_write & (ws_addr == `CR_XP10_DECOMP_LZ77D_OUT_IM_CONFIG);
  wire w_load_lz77d_out_im_read_done           = w_do_write & (ws_addr == `CR_XP10_DECOMP_LZ77D_OUT_IM_READ_DONE);
  wire w_load_xpd_out_ia_wdata_part0           = w_do_write & (ws_addr == `CR_XP10_DECOMP_XPD_OUT_IA_WDATA_PART0);
  wire w_load_xpd_out_ia_wdata_part1           = w_do_write & (ws_addr == `CR_XP10_DECOMP_XPD_OUT_IA_WDATA_PART1);
  wire w_load_xpd_out_ia_wdata_part2           = w_do_write & (ws_addr == `CR_XP10_DECOMP_XPD_OUT_IA_WDATA_PART2);
  wire w_load_xpd_out_ia_config                = w_do_write & (ws_addr == `CR_XP10_DECOMP_XPD_OUT_IA_CONFIG);
  wire w_load_xpd_out_im_config                = w_do_write & (ws_addr == `CR_XP10_DECOMP_XPD_OUT_IM_CONFIG);
  wire w_load_xpd_out_im_read_done             = w_do_write & (ws_addr == `CR_XP10_DECOMP_XPD_OUT_IM_READ_DONE);
  wire w_load_htf_bl_out_ia_wdata_part0        = w_do_write & (ws_addr == `CR_XP10_DECOMP_HTF_BL_OUT_IA_WDATA_PART0);
  wire w_load_htf_bl_out_ia_wdata_part1        = w_do_write & (ws_addr == `CR_XP10_DECOMP_HTF_BL_OUT_IA_WDATA_PART1);
  wire w_load_htf_bl_out_ia_wdata_part2        = w_do_write & (ws_addr == `CR_XP10_DECOMP_HTF_BL_OUT_IA_WDATA_PART2);
  wire w_load_htf_bl_out_ia_config             = w_do_write & (ws_addr == `CR_XP10_DECOMP_HTF_BL_OUT_IA_CONFIG);
  wire w_load_htf_bl_out_im_config             = w_do_write & (ws_addr == `CR_XP10_DECOMP_HTF_BL_OUT_IM_CONFIG);
  wire w_load_htf_bl_out_im_read_done          = w_do_write & (ws_addr == `CR_XP10_DECOMP_HTF_BL_OUT_IM_READ_DONE);
  wire w_load_bimc_monitor_mask                = w_do_write & (ws_addr == `CR_XP10_DECOMP_BIMC_MONITOR_MASK);
  wire w_load_bimc_ecc_uncorrectable_error_cnt = w_do_write & (ws_addr == `CR_XP10_DECOMP_BIMC_ECC_UNCORRECTABLE_ERROR_CNT);
  wire w_load_bimc_ecc_correctable_error_cnt   = w_do_write & (ws_addr == `CR_XP10_DECOMP_BIMC_ECC_CORRECTABLE_ERROR_CNT);
  wire w_load_bimc_parity_error_cnt            = w_do_write & (ws_addr == `CR_XP10_DECOMP_BIMC_PARITY_ERROR_CNT);
  wire w_load_bimc_global_config               = w_do_write & (ws_addr == `CR_XP10_DECOMP_BIMC_GLOBAL_CONFIG);
  wire w_load_bimc_eccpar_debug                = w_do_write & (ws_addr == `CR_XP10_DECOMP_BIMC_ECCPAR_DEBUG);
  wire w_load_bimc_cmd2                        = w_do_write & (ws_addr == `CR_XP10_DECOMP_BIMC_CMD2);
  wire w_load_bimc_cmd1                        = w_do_write & (ws_addr == `CR_XP10_DECOMP_BIMC_CMD1);
  wire w_load_bimc_cmd0                        = w_do_write & (ws_addr == `CR_XP10_DECOMP_BIMC_CMD0);
  wire w_load_bimc_rxcmd2                      = w_do_write & (ws_addr == `CR_XP10_DECOMP_BIMC_RXCMD2);
  wire w_load_bimc_rxrsp2                      = w_do_write & (ws_addr == `CR_XP10_DECOMP_BIMC_RXRSP2);
  wire w_load_bimc_pollrsp2                    = w_do_write & (ws_addr == `CR_XP10_DECOMP_BIMC_POLLRSP2);
  wire w_load_bimc_dbgcmd2                     = w_do_write & (ws_addr == `CR_XP10_DECOMP_BIMC_DBGCMD2);


  


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

    end
  end

  
  always_ff @(posedge clk) begin
    if (i_wr_strb)               f32_data       <= i_wr_data;

  end
  

  cr_xp10_decomp_regs_flops u_cr_xp10_decomp_regs_flops (
        .clk                                    ( clk ),
        .i_reset_                               ( i_reset_ ),
        .i_sw_init                              ( i_sw_init ),
        .o_spare_config                         ( o_spare_config ),
        .o_lz_bypass_config                     ( o_lz_bypass_config ),
        .o_ignore_crc_config                    ( o_ignore_crc_config ),
        .o_lz_decomp_olimit                     ( o_lz_decomp_olimit ),
        .o_decomp_dp_tlv_parse_action_0         ( o_decomp_dp_tlv_parse_action_0 ),
        .o_decomp_dp_tlv_parse_action_1         ( o_decomp_dp_tlv_parse_action_1 ),
        .o_lz77d_out_ia_wdata_part0             ( o_lz77d_out_ia_wdata_part0 ),
        .o_lz77d_out_ia_wdata_part1             ( o_lz77d_out_ia_wdata_part1 ),
        .o_lz77d_out_ia_wdata_part2             ( o_lz77d_out_ia_wdata_part2 ),
        .o_lz77d_out_ia_config                  ( o_lz77d_out_ia_config ),
        .o_lz77d_out_im_config                  ( o_lz77d_out_im_config ),
        .o_lz77d_out_im_read_done               ( o_lz77d_out_im_read_done ),
        .o_xpd_out_ia_wdata_part0               ( o_xpd_out_ia_wdata_part0 ),
        .o_xpd_out_ia_wdata_part1               ( o_xpd_out_ia_wdata_part1 ),
        .o_xpd_out_ia_wdata_part2               ( o_xpd_out_ia_wdata_part2 ),
        .o_xpd_out_ia_config                    ( o_xpd_out_ia_config ),
        .o_xpd_out_im_config                    ( o_xpd_out_im_config ),
        .o_xpd_out_im_read_done                 ( o_xpd_out_im_read_done ),
        .o_htf_bl_out_ia_wdata_part0            ( o_htf_bl_out_ia_wdata_part0 ),
        .o_htf_bl_out_ia_wdata_part1            ( o_htf_bl_out_ia_wdata_part1 ),
        .o_htf_bl_out_ia_wdata_part2            ( o_htf_bl_out_ia_wdata_part2 ),
        .o_htf_bl_out_ia_config                 ( o_htf_bl_out_ia_config ),
        .o_htf_bl_out_im_config                 ( o_htf_bl_out_im_config ),
        .o_htf_bl_out_im_read_done              ( o_htf_bl_out_im_read_done ),
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
        .w_load_spare_config                    ( w_load_spare_config ),
        .w_load_lz_bypass_config                ( w_load_lz_bypass_config ),
        .w_load_ignore_crc_config               ( w_load_ignore_crc_config ),
        .w_load_lz_decomp_olimit                ( w_load_lz_decomp_olimit ),
        .w_load_decomp_dp_tlv_parse_action_0    ( w_load_decomp_dp_tlv_parse_action_0 ),
        .w_load_decomp_dp_tlv_parse_action_1    ( w_load_decomp_dp_tlv_parse_action_1 ),
        .w_load_lz77d_out_ia_wdata_part0        ( w_load_lz77d_out_ia_wdata_part0 ),
        .w_load_lz77d_out_ia_wdata_part1        ( w_load_lz77d_out_ia_wdata_part1 ),
        .w_load_lz77d_out_ia_wdata_part2        ( w_load_lz77d_out_ia_wdata_part2 ),
        .w_load_lz77d_out_ia_config             ( w_load_lz77d_out_ia_config ),
        .w_load_lz77d_out_im_config             ( w_load_lz77d_out_im_config ),
        .w_load_lz77d_out_im_read_done          ( w_load_lz77d_out_im_read_done ),
        .w_load_xpd_out_ia_wdata_part0          ( w_load_xpd_out_ia_wdata_part0 ),
        .w_load_xpd_out_ia_wdata_part1          ( w_load_xpd_out_ia_wdata_part1 ),
        .w_load_xpd_out_ia_wdata_part2          ( w_load_xpd_out_ia_wdata_part2 ),
        .w_load_xpd_out_ia_config               ( w_load_xpd_out_ia_config ),
        .w_load_xpd_out_im_config               ( w_load_xpd_out_im_config ),
        .w_load_xpd_out_im_read_done            ( w_load_xpd_out_im_read_done ),
        .w_load_htf_bl_out_ia_wdata_part0       ( w_load_htf_bl_out_ia_wdata_part0 ),
        .w_load_htf_bl_out_ia_wdata_part1       ( w_load_htf_bl_out_ia_wdata_part1 ),
        .w_load_htf_bl_out_ia_wdata_part2       ( w_load_htf_bl_out_ia_wdata_part2 ),
        .w_load_htf_bl_out_ia_config            ( w_load_htf_bl_out_ia_config ),
        .w_load_htf_bl_out_im_config            ( w_load_htf_bl_out_im_config ),
        .w_load_htf_bl_out_im_read_done         ( w_load_htf_bl_out_im_read_done ),
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
        .f32_data                               ( f32_data )
  );

  

  

  `ifdef CR_XP10_DECOMP_DIGEST_9A564C2E5C207FDA87989348812B8778
  `else
    initial begin
      $display("Error: the core decode file (cr_xp10_decomp_regs.sv) and include file (cr_xp10_decomp.vh) were compiled");
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


module cr_xp10_decomp_regs_flops (
  input                                        clk,
  input                                        i_reset_,
  input                                        i_sw_init,

  
  output reg [`CR_XP10_DECOMP_C_SPARE_T_DECL]  o_spare_config,
  output reg [`CR_XP10_DECOMP_C_LZ_BYPASS_T_DECL] o_lz_bypass_config,
  output reg [`CR_XP10_DECOMP_C_IGNORE_CRC_T_DECL] o_ignore_crc_config,
  output reg [`CR_XP10_DECOMP_C_LZ_DECOMP_OLIMIT_T_DECL] o_lz_decomp_olimit,
  output reg [`CR_XP10_DECOMP_C_DECOMP_DP_TLV_PARSE_ACTION_31_0_T_DECL] o_decomp_dp_tlv_parse_action_0,
  output reg [`CR_XP10_DECOMP_C_DECOMP_DP_TLV_PARSE_ACTION_63_32_T_DECL] o_decomp_dp_tlv_parse_action_1,
  output reg [`CR_XP10_DECOMP_C_LZ77D_OUT_PART0_T_DECL] o_lz77d_out_ia_wdata_part0,
  output reg [`CR_XP10_DECOMP_C_LZ77D_OUT_PART1_T_DECL] o_lz77d_out_ia_wdata_part1,
  output reg [`CR_XP10_DECOMP_C_LZ77D_OUT_PART2_T_DECL] o_lz77d_out_ia_wdata_part2,
  output reg [`CR_XP10_DECOMP_C_LZ77D_OUT_IA_CONFIG_T_DECL] o_lz77d_out_ia_config,
  output reg [`CR_XP10_DECOMP_C_LZ77D_OUT_IM_CONFIG_T_DECL] o_lz77d_out_im_config,
  output reg [`CR_XP10_DECOMP_C_LZ77D_OUT_IM_CONSUMED_T_DECL] o_lz77d_out_im_read_done,
  output reg [`CR_XP10_DECOMP_C_XPD_OUT_PART0_T_DECL] o_xpd_out_ia_wdata_part0,
  output reg [`CR_XP10_DECOMP_C_XPD_OUT_PART1_T_DECL] o_xpd_out_ia_wdata_part1,
  output reg [`CR_XP10_DECOMP_C_XPD_OUT_PART2_T_DECL] o_xpd_out_ia_wdata_part2,
  output reg [`CR_XP10_DECOMP_C_XPD_OUT_IA_CONFIG_T_DECL] o_xpd_out_ia_config,
  output reg [`CR_XP10_DECOMP_C_XPD_OUT_IM_CONFIG_T_DECL] o_xpd_out_im_config,
  output reg [`CR_XP10_DECOMP_C_XPD_OUT_IM_CONSUMED_T_DECL] o_xpd_out_im_read_done,
  output reg [`CR_XP10_DECOMP_C_HTF_BL_OUT_PART0_T_DECL] o_htf_bl_out_ia_wdata_part0,
  output reg [`CR_XP10_DECOMP_C_HTF_BL_OUT_PART1_T_DECL] o_htf_bl_out_ia_wdata_part1,
  output reg [`CR_XP10_DECOMP_C_HTF_BL_OUT_PART2_T_DECL] o_htf_bl_out_ia_wdata_part2,
  output reg [`CR_XP10_DECOMP_C_HTF_BL_OUT_IA_CONFIG_T_DECL] o_htf_bl_out_ia_config,
  output reg [`CR_XP10_DECOMP_C_HTF_BL_OUT_IM_CONFIG_T_DECL] o_htf_bl_out_im_config,
  output reg [`CR_XP10_DECOMP_C_HTF_BL_OUT_IM_CONSUMED_T_DECL] o_htf_bl_out_im_read_done,
  output reg [`CR_XP10_DECOMP_C_BIMC_MONITOR_MASK_T_DECL] o_bimc_monitor_mask,
  output reg [`CR_XP10_DECOMP_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_uncorrectable_error_cnt,
  output reg [`CR_XP10_DECOMP_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_correctable_error_cnt,
  output reg [`CR_XP10_DECOMP_C_BIMC_PARITY_ERROR_CNT_T_DECL] o_bimc_parity_error_cnt,
  output reg [`CR_XP10_DECOMP_C_BIMC_GLOBAL_CONFIG_T_DECL] o_bimc_global_config,
  output reg [`CR_XP10_DECOMP_C_BIMC_ECCPAR_DEBUG_T_DECL] o_bimc_eccpar_debug,
  output reg [`CR_XP10_DECOMP_C_BIMC_CMD2_T_DECL] o_bimc_cmd2,
  output reg [`CR_XP10_DECOMP_C_BIMC_CMD1_T_DECL] o_bimc_cmd1,
  output reg [`CR_XP10_DECOMP_C_BIMC_CMD0_T_DECL] o_bimc_cmd0,
  output reg [`CR_XP10_DECOMP_C_BIMC_RXCMD2_T_DECL] o_bimc_rxcmd2,
  output reg [`CR_XP10_DECOMP_C_BIMC_RXRSP2_T_DECL] o_bimc_rxrsp2,
  output reg [`CR_XP10_DECOMP_C_BIMC_POLLRSP2_T_DECL] o_bimc_pollrsp2,
  output reg [`CR_XP10_DECOMP_C_BIMC_DBGCMD2_T_DECL] o_bimc_dbgcmd2,


  
  input                                        w_load_spare_config,
  input                                        w_load_lz_bypass_config,
  input                                        w_load_ignore_crc_config,
  input                                        w_load_lz_decomp_olimit,
  input                                        w_load_decomp_dp_tlv_parse_action_0,
  input                                        w_load_decomp_dp_tlv_parse_action_1,
  input                                        w_load_lz77d_out_ia_wdata_part0,
  input                                        w_load_lz77d_out_ia_wdata_part1,
  input                                        w_load_lz77d_out_ia_wdata_part2,
  input                                        w_load_lz77d_out_ia_config,
  input                                        w_load_lz77d_out_im_config,
  input                                        w_load_lz77d_out_im_read_done,
  input                                        w_load_xpd_out_ia_wdata_part0,
  input                                        w_load_xpd_out_ia_wdata_part1,
  input                                        w_load_xpd_out_ia_wdata_part2,
  input                                        w_load_xpd_out_ia_config,
  input                                        w_load_xpd_out_im_config,
  input                                        w_load_xpd_out_im_read_done,
  input                                        w_load_htf_bl_out_ia_wdata_part0,
  input                                        w_load_htf_bl_out_ia_wdata_part1,
  input                                        w_load_htf_bl_out_ia_wdata_part2,
  input                                        w_load_htf_bl_out_ia_config,
  input                                        w_load_htf_bl_out_im_config,
  input                                        w_load_htf_bl_out_im_read_done,
  input                                        w_load_bimc_monitor_mask,
  input                                        w_load_bimc_ecc_uncorrectable_error_cnt,
  input                                        w_load_bimc_ecc_correctable_error_cnt,
  input                                        w_load_bimc_parity_error_cnt,
  input                                        w_load_bimc_global_config,
  input                                        w_load_bimc_eccpar_debug,
  input                                        w_load_bimc_cmd2,
  input                                        w_load_bimc_cmd1,
  input                                        w_load_bimc_cmd0,
  input                                        w_load_bimc_rxcmd2,
  input                                        w_load_bimc_rxrsp2,
  input                                        w_load_bimc_pollrsp2,
  input                                        w_load_bimc_dbgcmd2,

  input      [31:0]                             f32_data
  );

  
  

  
  

  
  
  
  always_ff @(posedge clk or negedge i_reset_) begin
    if(~i_reset_) begin
      
      o_spare_config[31:00]                     <= 32'd0; 
      o_lz_bypass_config[00:00]                 <= 1'd0; 
      o_ignore_crc_config[00:00]                <= 1'd0; 
      o_lz_decomp_olimit[23:00]                 <= 24'd8388608; 
      o_decomp_dp_tlv_parse_action_0[01:00]     <= 2'd0; 
      o_decomp_dp_tlv_parse_action_0[03:02]     <= 2'd0; 
      o_decomp_dp_tlv_parse_action_0[05:04]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[07:06]     <= 2'd3; 
      o_decomp_dp_tlv_parse_action_0[09:08]     <= 2'd3; 
      o_decomp_dp_tlv_parse_action_0[11:10]     <= 2'd2; 
      o_decomp_dp_tlv_parse_action_0[13:12]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[15:14]     <= 2'd2; 
      o_decomp_dp_tlv_parse_action_0[17:16]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[19:18]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[21:20]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[23:22]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[25:24]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[27:26]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[29:28]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[31:30]     <= 2'd0; 
      o_decomp_dp_tlv_parse_action_1[01:00]     <= 2'd0; 
      o_decomp_dp_tlv_parse_action_1[03:02]     <= 2'd0; 
      o_decomp_dp_tlv_parse_action_1[05:04]     <= 2'd0; 
      o_decomp_dp_tlv_parse_action_1[07:06]     <= 2'd2; 
      o_decomp_dp_tlv_parse_action_1[09:08]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[11:10]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[13:12]     <= 2'd0; 
      o_decomp_dp_tlv_parse_action_1[15:14]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[17:16]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[19:18]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[21:20]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[23:22]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[25:24]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[27:26]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[29:28]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[31:30]     <= 2'd1; 
      o_lz77d_out_ia_wdata_part0[05:00]         <= 6'd0; 
      o_lz77d_out_ia_wdata_part1[31:00]         <= 32'd0; 
      o_lz77d_out_ia_wdata_part2[31:00]         <= 32'd0; 
      o_lz77d_out_ia_config[08:00]              <= 9'd0; 
      o_lz77d_out_ia_config[12:09]              <= 4'd0; 
      o_lz77d_out_im_config[09:00]              <= 10'd512; 
      o_lz77d_out_im_config[11:10]              <= 2'd3; 
      o_lz77d_out_im_read_done[00:00]           <= 1'd0; 
      o_lz77d_out_im_read_done[01:01]           <= 1'd0; 
      o_xpd_out_ia_wdata_part0[30:00]           <= 31'd0; 
      o_xpd_out_ia_wdata_part1[31:00]           <= 32'd0; 
      o_xpd_out_ia_wdata_part2[31:00]           <= 32'd0; 
      o_xpd_out_ia_config[08:00]                <= 9'd0; 
      o_xpd_out_ia_config[12:09]                <= 4'd0; 
      o_xpd_out_im_config[09:00]                <= 10'd512; 
      o_xpd_out_im_config[11:10]                <= 2'd3; 
      o_xpd_out_im_read_done[00:00]             <= 1'd0; 
      o_xpd_out_im_read_done[01:01]             <= 1'd0; 
      o_htf_bl_out_ia_wdata_part0[31:31]        <= 1'd0; 
      o_htf_bl_out_ia_wdata_part1[31:24]        <= 8'd0; 
      o_htf_bl_out_ia_wdata_part2[31:24]        <= 8'd0; 
      o_htf_bl_out_ia_config[07:00]             <= 8'd0; 
      o_htf_bl_out_ia_config[11:08]             <= 4'd0; 
      o_htf_bl_out_im_config[07:00]             <= 8'd226; 
      o_htf_bl_out_im_config[09:08]             <= 2'd3; 
      o_htf_bl_out_im_read_done[00:00]          <= 1'd0; 
      o_htf_bl_out_im_read_done[01:01]          <= 1'd0; 
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
    end
    else if(i_sw_init) begin
      
      o_spare_config[31:00]                     <= 32'd0; 
      o_lz_bypass_config[00:00]                 <= 1'd0; 
      o_ignore_crc_config[00:00]                <= 1'd0; 
      o_lz_decomp_olimit[23:00]                 <= 24'd8388608; 
      o_decomp_dp_tlv_parse_action_0[01:00]     <= 2'd0; 
      o_decomp_dp_tlv_parse_action_0[03:02]     <= 2'd0; 
      o_decomp_dp_tlv_parse_action_0[05:04]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[07:06]     <= 2'd3; 
      o_decomp_dp_tlv_parse_action_0[09:08]     <= 2'd3; 
      o_decomp_dp_tlv_parse_action_0[11:10]     <= 2'd2; 
      o_decomp_dp_tlv_parse_action_0[13:12]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[15:14]     <= 2'd2; 
      o_decomp_dp_tlv_parse_action_0[17:16]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[19:18]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[21:20]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[23:22]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[25:24]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[27:26]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[29:28]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_0[31:30]     <= 2'd0; 
      o_decomp_dp_tlv_parse_action_1[01:00]     <= 2'd0; 
      o_decomp_dp_tlv_parse_action_1[03:02]     <= 2'd0; 
      o_decomp_dp_tlv_parse_action_1[05:04]     <= 2'd0; 
      o_decomp_dp_tlv_parse_action_1[07:06]     <= 2'd2; 
      o_decomp_dp_tlv_parse_action_1[09:08]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[11:10]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[13:12]     <= 2'd0; 
      o_decomp_dp_tlv_parse_action_1[15:14]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[17:16]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[19:18]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[21:20]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[23:22]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[25:24]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[27:26]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[29:28]     <= 2'd1; 
      o_decomp_dp_tlv_parse_action_1[31:30]     <= 2'd1; 
      o_lz77d_out_ia_wdata_part0[05:00]         <= 6'd0; 
      o_lz77d_out_ia_wdata_part1[31:00]         <= 32'd0; 
      o_lz77d_out_ia_wdata_part2[31:00]         <= 32'd0; 
      o_lz77d_out_ia_config[08:00]              <= 9'd0; 
      o_lz77d_out_ia_config[12:09]              <= 4'd0; 
      o_lz77d_out_im_config[09:00]              <= 10'd512; 
      o_lz77d_out_im_config[11:10]              <= 2'd3; 
      o_lz77d_out_im_read_done[00:00]           <= 1'd0; 
      o_lz77d_out_im_read_done[01:01]           <= 1'd0; 
      o_xpd_out_ia_wdata_part0[30:00]           <= 31'd0; 
      o_xpd_out_ia_wdata_part1[31:00]           <= 32'd0; 
      o_xpd_out_ia_wdata_part2[31:00]           <= 32'd0; 
      o_xpd_out_ia_config[08:00]                <= 9'd0; 
      o_xpd_out_ia_config[12:09]                <= 4'd0; 
      o_xpd_out_im_config[09:00]                <= 10'd512; 
      o_xpd_out_im_config[11:10]                <= 2'd3; 
      o_xpd_out_im_read_done[00:00]             <= 1'd0; 
      o_xpd_out_im_read_done[01:01]             <= 1'd0; 
      o_htf_bl_out_ia_wdata_part0[31:31]        <= 1'd0; 
      o_htf_bl_out_ia_wdata_part1[31:24]        <= 8'd0; 
      o_htf_bl_out_ia_wdata_part2[31:24]        <= 8'd0; 
      o_htf_bl_out_ia_config[07:00]             <= 8'd0; 
      o_htf_bl_out_ia_config[11:08]             <= 4'd0; 
      o_htf_bl_out_im_config[07:00]             <= 8'd226; 
      o_htf_bl_out_im_config[09:08]             <= 2'd3; 
      o_htf_bl_out_im_read_done[00:00]          <= 1'd0; 
      o_htf_bl_out_im_read_done[01:01]          <= 1'd0; 
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
    end
    else begin
      if(w_load_spare_config)                     o_spare_config[31:00]                     <= f32_data[31:00]; 
      if(w_load_lz_bypass_config)                 o_lz_bypass_config[00:00]                 <= f32_data[00:00]; 
      if(w_load_ignore_crc_config)                o_ignore_crc_config[00:00]                <= f32_data[00:00]; 
      if(w_load_lz_decomp_olimit)                 o_lz_decomp_olimit[23:00]                 <= f32_data[23:00]; 
      if(w_load_decomp_dp_tlv_parse_action_0)     o_decomp_dp_tlv_parse_action_0[01:00]     <= f32_data[01:00]; 
      if(w_load_decomp_dp_tlv_parse_action_0)     o_decomp_dp_tlv_parse_action_0[03:02]     <= f32_data[03:02]; 
      if(w_load_decomp_dp_tlv_parse_action_0)     o_decomp_dp_tlv_parse_action_0[05:04]     <= f32_data[05:04]; 
      if(w_load_decomp_dp_tlv_parse_action_0)     o_decomp_dp_tlv_parse_action_0[07:06]     <= f32_data[07:06]; 
      if(w_load_decomp_dp_tlv_parse_action_0)     o_decomp_dp_tlv_parse_action_0[09:08]     <= f32_data[09:08]; 
      if(w_load_decomp_dp_tlv_parse_action_0)     o_decomp_dp_tlv_parse_action_0[11:10]     <= f32_data[11:10]; 
      if(w_load_decomp_dp_tlv_parse_action_0)     o_decomp_dp_tlv_parse_action_0[13:12]     <= f32_data[13:12]; 
      if(w_load_decomp_dp_tlv_parse_action_0)     o_decomp_dp_tlv_parse_action_0[15:14]     <= f32_data[15:14]; 
      if(w_load_decomp_dp_tlv_parse_action_0)     o_decomp_dp_tlv_parse_action_0[17:16]     <= f32_data[17:16]; 
      if(w_load_decomp_dp_tlv_parse_action_0)     o_decomp_dp_tlv_parse_action_0[19:18]     <= f32_data[19:18]; 
      if(w_load_decomp_dp_tlv_parse_action_0)     o_decomp_dp_tlv_parse_action_0[21:20]     <= f32_data[21:20]; 
      if(w_load_decomp_dp_tlv_parse_action_0)     o_decomp_dp_tlv_parse_action_0[23:22]     <= f32_data[23:22]; 
      if(w_load_decomp_dp_tlv_parse_action_0)     o_decomp_dp_tlv_parse_action_0[25:24]     <= f32_data[25:24]; 
      if(w_load_decomp_dp_tlv_parse_action_0)     o_decomp_dp_tlv_parse_action_0[27:26]     <= f32_data[27:26]; 
      if(w_load_decomp_dp_tlv_parse_action_0)     o_decomp_dp_tlv_parse_action_0[29:28]     <= f32_data[29:28]; 
      if(w_load_decomp_dp_tlv_parse_action_0)     o_decomp_dp_tlv_parse_action_0[31:30]     <= f32_data[31:30]; 
      if(w_load_decomp_dp_tlv_parse_action_1)     o_decomp_dp_tlv_parse_action_1[01:00]     <= f32_data[01:00]; 
      if(w_load_decomp_dp_tlv_parse_action_1)     o_decomp_dp_tlv_parse_action_1[03:02]     <= f32_data[03:02]; 
      if(w_load_decomp_dp_tlv_parse_action_1)     o_decomp_dp_tlv_parse_action_1[05:04]     <= f32_data[05:04]; 
      if(w_load_decomp_dp_tlv_parse_action_1)     o_decomp_dp_tlv_parse_action_1[07:06]     <= f32_data[07:06]; 
      if(w_load_decomp_dp_tlv_parse_action_1)     o_decomp_dp_tlv_parse_action_1[09:08]     <= f32_data[09:08]; 
      if(w_load_decomp_dp_tlv_parse_action_1)     o_decomp_dp_tlv_parse_action_1[11:10]     <= f32_data[11:10]; 
      if(w_load_decomp_dp_tlv_parse_action_1)     o_decomp_dp_tlv_parse_action_1[13:12]     <= f32_data[13:12]; 
      if(w_load_decomp_dp_tlv_parse_action_1)     o_decomp_dp_tlv_parse_action_1[15:14]     <= f32_data[15:14]; 
      if(w_load_decomp_dp_tlv_parse_action_1)     o_decomp_dp_tlv_parse_action_1[17:16]     <= f32_data[17:16]; 
      if(w_load_decomp_dp_tlv_parse_action_1)     o_decomp_dp_tlv_parse_action_1[19:18]     <= f32_data[19:18]; 
      if(w_load_decomp_dp_tlv_parse_action_1)     o_decomp_dp_tlv_parse_action_1[21:20]     <= f32_data[21:20]; 
      if(w_load_decomp_dp_tlv_parse_action_1)     o_decomp_dp_tlv_parse_action_1[23:22]     <= f32_data[23:22]; 
      if(w_load_decomp_dp_tlv_parse_action_1)     o_decomp_dp_tlv_parse_action_1[25:24]     <= f32_data[25:24]; 
      if(w_load_decomp_dp_tlv_parse_action_1)     o_decomp_dp_tlv_parse_action_1[27:26]     <= f32_data[27:26]; 
      if(w_load_decomp_dp_tlv_parse_action_1)     o_decomp_dp_tlv_parse_action_1[29:28]     <= f32_data[29:28]; 
      if(w_load_decomp_dp_tlv_parse_action_1)     o_decomp_dp_tlv_parse_action_1[31:30]     <= f32_data[31:30]; 
      if(w_load_lz77d_out_ia_wdata_part0)         o_lz77d_out_ia_wdata_part0[05:00]         <= f32_data[05:00]; 
      if(w_load_lz77d_out_ia_wdata_part1)         o_lz77d_out_ia_wdata_part1[31:00]         <= f32_data[31:00]; 
      if(w_load_lz77d_out_ia_wdata_part2)         o_lz77d_out_ia_wdata_part2[31:00]         <= f32_data[31:00]; 
      if(w_load_lz77d_out_ia_config)              o_lz77d_out_ia_config[08:00]              <= f32_data[08:00]; 
      if(w_load_lz77d_out_ia_config)              o_lz77d_out_ia_config[12:09]              <= f32_data[31:28]; 
      if(w_load_lz77d_out_im_config)              o_lz77d_out_im_config[09:00]              <= f32_data[09:00]; 
      if(w_load_lz77d_out_im_config)              o_lz77d_out_im_config[11:10]              <= f32_data[31:30]; 
      if(w_load_lz77d_out_im_read_done)           o_lz77d_out_im_read_done[00:00]           <= f32_data[30:30]; 
      if(w_load_lz77d_out_im_read_done)           o_lz77d_out_im_read_done[01:01]           <= f32_data[31:31]; 
      if(w_load_xpd_out_ia_wdata_part0)           o_xpd_out_ia_wdata_part0[30:00]           <= f32_data[30:00]; 
      if(w_load_xpd_out_ia_wdata_part1)           o_xpd_out_ia_wdata_part1[31:00]           <= f32_data[31:00]; 
      if(w_load_xpd_out_ia_wdata_part2)           o_xpd_out_ia_wdata_part2[31:00]           <= f32_data[31:00]; 
      if(w_load_xpd_out_ia_config)                o_xpd_out_ia_config[08:00]                <= f32_data[08:00]; 
      if(w_load_xpd_out_ia_config)                o_xpd_out_ia_config[12:09]                <= f32_data[31:28]; 
      if(w_load_xpd_out_im_config)                o_xpd_out_im_config[09:00]                <= f32_data[09:00]; 
      if(w_load_xpd_out_im_config)                o_xpd_out_im_config[11:10]                <= f32_data[31:30]; 
      if(w_load_xpd_out_im_read_done)             o_xpd_out_im_read_done[00:00]             <= f32_data[30:30]; 
      if(w_load_xpd_out_im_read_done)             o_xpd_out_im_read_done[01:01]             <= f32_data[31:31]; 
      if(w_load_htf_bl_out_ia_wdata_part0)        o_htf_bl_out_ia_wdata_part0[31:31]        <= f32_data[31:31]; 
      if(w_load_htf_bl_out_ia_wdata_part1)        o_htf_bl_out_ia_wdata_part1[31:24]        <= f32_data[31:24]; 
      if(w_load_htf_bl_out_ia_wdata_part2)        o_htf_bl_out_ia_wdata_part2[31:24]        <= f32_data[31:24]; 
      if(w_load_htf_bl_out_ia_config)             o_htf_bl_out_ia_config[07:00]             <= f32_data[07:00]; 
      if(w_load_htf_bl_out_ia_config)             o_htf_bl_out_ia_config[11:08]             <= f32_data[31:28]; 
      if(w_load_htf_bl_out_im_config)             o_htf_bl_out_im_config[07:00]             <= f32_data[07:00]; 
      if(w_load_htf_bl_out_im_config)             o_htf_bl_out_im_config[09:08]             <= f32_data[31:30]; 
      if(w_load_htf_bl_out_im_read_done)          o_htf_bl_out_im_read_done[00:00]          <= f32_data[30:30]; 
      if(w_load_htf_bl_out_im_read_done)          o_htf_bl_out_im_read_done[01:01]          <= f32_data[31:31]; 
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
    end
  end

  
  
  
  always_ff @(posedge clk) begin
      if(w_load_lz77d_out_ia_wdata_part0)         o_lz77d_out_ia_wdata_part0[13:06]         <= f32_data[13:06]; 
      if(w_load_lz77d_out_ia_wdata_part0)         o_lz77d_out_ia_wdata_part0[14:14]         <= f32_data[14:14]; 
      if(w_load_lz77d_out_ia_wdata_part0)         o_lz77d_out_ia_wdata_part0[22:15]         <= f32_data[22:15]; 
      if(w_load_lz77d_out_ia_wdata_part0)         o_lz77d_out_ia_wdata_part0[30:23]         <= f32_data[30:23]; 
      if(w_load_lz77d_out_ia_wdata_part0)         o_lz77d_out_ia_wdata_part0[31:31]         <= f32_data[31:31]; 
      if(w_load_xpd_out_ia_wdata_part0)           o_xpd_out_ia_wdata_part0[31:31]           <= f32_data[31:31]; 
      if(w_load_htf_bl_out_ia_wdata_part0)        o_htf_bl_out_ia_wdata_part0[00:00]        <= f32_data[00:00]; 
      if(w_load_htf_bl_out_ia_wdata_part0)        o_htf_bl_out_ia_wdata_part0[01:01]        <= f32_data[01:01]; 
      if(w_load_htf_bl_out_ia_wdata_part0)        o_htf_bl_out_ia_wdata_part0[30:02]        <= f32_data[30:02]; 
      if(w_load_htf_bl_out_ia_wdata_part1)        o_htf_bl_out_ia_wdata_part1[07:00]        <= f32_data[07:00]; 
      if(w_load_htf_bl_out_ia_wdata_part1)        o_htf_bl_out_ia_wdata_part1[15:08]        <= f32_data[15:08]; 
      if(w_load_htf_bl_out_ia_wdata_part1)        o_htf_bl_out_ia_wdata_part1[23:16]        <= f32_data[23:16]; 
      if(w_load_htf_bl_out_ia_wdata_part2)        o_htf_bl_out_ia_wdata_part2[07:00]        <= f32_data[07:00]; 
      if(w_load_htf_bl_out_ia_wdata_part2)        o_htf_bl_out_ia_wdata_part2[15:08]        <= f32_data[15:08]; 
      if(w_load_htf_bl_out_ia_wdata_part2)        o_htf_bl_out_ia_wdata_part2[23:16]        <= f32_data[23:16]; 
      if(w_load_bimc_rxcmd2)                      o_bimc_rxcmd2[09:09]                      <= f32_data[09:09]; 
      if(w_load_bimc_rxrsp2)                      o_bimc_rxrsp2[09:09]                      <= f32_data[09:09]; 
      if(w_load_bimc_pollrsp2)                    o_bimc_pollrsp2[09:09]                    <= f32_data[09:09]; 
      if(w_load_bimc_dbgcmd2)                     o_bimc_dbgcmd2[09:09]                     <= f32_data[09:09]; 
  end
  

  

endmodule
