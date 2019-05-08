/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











`include "cr_isf.vh"




module cr_isf_regs (
  input                                         clk,
  input                                         i_reset_,
  input                                         i_sw_init,

  
  input      [`CR_ISF_DECL]                     i_addr,
  input                                         i_wr_strb,
  input      [31:0]                             i_wr_data,
  input                                         i_rd_strb,
  output     [31:0]                             o_rd_data,
  output                                        o_ack,
  output                                        o_err_ack,

  
  output     [`CR_ISF_C_SPARE_T_DECL]           o_spare_config,
  output     [`CR_ISF_C_ISF_TLV_PARSE_ACTION_31_0_T_DECL] o_isf_tlv_parse_action_0,
  output     [`CR_ISF_C_ISF_TLV_PARSE_ACTION_63_32_T_DECL] o_isf_tlv_parse_action_1,
  output     [`CR_ISF_C_CTL_T_DECL]             o_ctl_config,
  output     [`CR_ISF_C_SYSTEM_STALL_LIMIT_T_DECL] o_system_stall_limit_config,
  output     [`CR_ISF_C_DEBUG_CTL_T_DECL]       o_debug_ctl_config,
  output     [`CR_ISF_C_DEBUG_SS_CTL_T_DECL]    o_debug_ss_ctl_config,
  output     [`CR_ISF_C_DEBUG_TRIG_TLV_T_DECL]  o_debug_trig_tlv_config,
  output     [`CR_ISF_C_DEBUG_TRIG_MATCH_LO_T_DECL] o_debug_trig_match_lo_config,
  output     [`CR_ISF_C_DEBUG_TRIG_MATCH_HI_T_DECL] o_debug_trig_match_hi_config,
  output     [`CR_ISF_C_DEBUG_TRIG_MASK_LO_T_DECL] o_debug_trig_mask_lo_config,
  output     [`CR_ISF_C_DEBUG_TRIG_MASK_HI_T_DECL] o_debug_trig_mask_hi_config,
  output     [`CR_ISF_C_TRACE_CTL_EN_T_DECL]    o_trace_ctl_en_config,
  output     [`CR_ISF_C_TRACE_CTL_LIMITS_T_DECL] o_trace_ctl_limits_config,
  output     [`CR_ISF_C_AUX_CMD_EV_MATCH_VAL_0_COMP_T_DECL] o_aux_cmd_ev_match_val_0_comp_config,
  output     [`CR_ISF_C_AUX_CMD_EV_MATCH_VAL_0_CRYPTO_T_DECL] o_aux_cmd_ev_match_val_0_crypto_config,
  output     [`CR_ISF_C_AUX_CMD_EV_MASK_VAL_0_COMP_T_DECL] o_aux_cmd_ev_mask_val_0_comp_config,
  output     [`CR_ISF_C_AUX_CMD_EV_MASK_VAL_0_CRYPTO_T_DECL] o_aux_cmd_ev_mask_val_0_crypto_config,
  output     [`CR_ISF_C_AUX_CMD_EV_MATCH_VAL_1_COMP_T_DECL] o_aux_cmd_ev_match_val_1_comp_config,
  output     [`CR_ISF_C_AUX_CMD_EV_MATCH_VAL_1_CRYPTO_T_DECL] o_aux_cmd_ev_match_val_1_crypto_config,
  output     [`CR_ISF_C_AUX_CMD_EV_MASK_VAL_1_COMP_T_DECL] o_aux_cmd_ev_mask_val_1_comp_config,
  output     [`CR_ISF_C_AUX_CMD_EV_MASK_VAL_1_CRYPTO_T_DECL] o_aux_cmd_ev_mask_val_1_crypto_config,
  output     [`CR_ISF_C_AUX_CMD_EV_MATCH_VAL_2_COMP_T_DECL] o_aux_cmd_ev_match_val_2_comp_config,
  output     [`CR_ISF_C_AUX_CMD_EV_MATCH_VAL_2_CRYPTO_T_DECL] o_aux_cmd_ev_match_val_2_crypto_config,
  output     [`CR_ISF_C_AUX_CMD_EV_MASK_VAL_2_COMP_T_DECL] o_aux_cmd_ev_mask_val_2_comp_config,
  output     [`CR_ISF_C_AUX_CMD_EV_MASK_VAL_2_CRYPTO_T_DECL] o_aux_cmd_ev_mask_val_2_crypto_config,
  output     [`CR_ISF_C_AUX_CMD_EV_MATCH_VAL_3_COMP_T_DECL] o_aux_cmd_ev_match_val_3_comp_config,
  output     [`CR_ISF_C_AUX_CMD_EV_MATCH_VAL_3_CRYPTO_T_DECL] o_aux_cmd_ev_match_val_3_crypto_config,
  output     [`CR_ISF_C_AUX_CMD_EV_MASK_VAL_3_COMP_T_DECL] o_aux_cmd_ev_mask_val_3_comp_config,
  output     [`CR_ISF_C_AUX_CMD_EV_MASK_VAL_3_CRYPTO_T_DECL] o_aux_cmd_ev_mask_val_3_crypto_config,
  output     [`CR_ISF_C_ISF_FIFO_PART0_T_DECL]  o_isf_fifo_ia_wdata_part0,
  output     [`CR_ISF_C_ISF_FIFO_PART1_T_DECL]  o_isf_fifo_ia_wdata_part1,
  output     [`CR_ISF_C_ISF_FIFO_PART2_T_DECL]  o_isf_fifo_ia_wdata_part2,
  output     [`CR_ISF_C_ISF_FIFO_IA_CONFIG_T_DECL] o_isf_fifo_ia_config,
  output     [`CR_ISF_C_IB_AGG_DATA_BYTES_GLOBAL_CONFIG_T_DECL] o_ib_agg_data_bytes_global_config,

  
  input      [`CR_ISF_C_REVID_T_DECL]           i_revision_config,
  input      [`CR_ISF_C_SPARE_T_DECL]           i_spare_config,
  input      [`CR_ISF_C_DEBUG_STAT_T_DECL]      i_debug_stat,
  input      [`CR_ISF_C_DEBUG_TRIG_CAP_LO_T_DECL] i_debug_trig_cap_lo,
  input      [`CR_ISF_C_DEBUG_TRIG_CAP_HI_T_DECL] i_debug_trig_cap_hi,
  input      [`CR_ISF_C_DEBUG_SS_CAP_SB_T_DECL] i_debug_ss_cap_sb,
  input      [`CR_ISF_C_DEBUG_SS_CAP_LO_T_DECL] i_debug_ss_cap_lo,
  input      [`CR_ISF_C_DEBUG_SS_CAP_HI_T_DECL] i_debug_ss_cap_hi,
  input      [`CR_ISF_C_ISF_FIFO_IA_CAPABILITY_T_DECL] i_isf_fifo_ia_capability,
  input      [`CR_ISF_C_ISF_FIFO_IA_STATUS_T_DECL] i_isf_fifo_ia_status,
  input      [`CR_ISF_C_ISF_FIFO_PART0_T_DECL]  i_isf_fifo_ia_rdata_part0,
  input      [`CR_ISF_C_ISF_FIFO_PART1_T_DECL]  i_isf_fifo_ia_rdata_part1,
  input      [`CR_ISF_C_ISF_FIFO_PART2_T_DECL]  i_isf_fifo_ia_rdata_part2,
  input      [`CR_ISF_C_ISF_FIFO_FIFO_STATUS_0_T_DECL] i_isf_fifo_fifo_status_0,
  input      [`CR_ISF_C_ISF_FIFO_FIFO_STATUS_1_T_DECL] i_isf_fifo_fifo_status_1,
  input      [`CR_ISF_C_IB_AGG_DATA_BYTES_0_COUNTER_PART0_T_DECL] i_ib_agg_data_bytes_0_count_part0_a,
  input      [`CR_ISF_C_IB_AGG_DATA_BYTES_0_COUNTER_PART1_T_DECL] i_ib_agg_data_bytes_0_count_part1_a,
  input      [`CR_ISF_C_IB_AGG_DATA_BYTES_GLOBAL_READ_T_DECL] i_ib_agg_data_bytes_global_read,

  
  output reg                                    o_reg_written,
  output reg                                    o_reg_read,
  output     [31:0]                             o_reg_wr_data,
  output reg [`CR_ISF_DECL]                     o_reg_addr
  );


  


  
  


  
  wire [`CR_ISF_DECL] ws_read_addr    = o_reg_addr;
  wire [`CR_ISF_DECL] ws_addr         = o_reg_addr;
  

  wire n_wr_strobe = i_wr_strb;
  wire n_rd_strobe = i_rd_strb;

  wire w_32b_aligned    = (o_reg_addr[1:0] == 2'h0);

  wire w_valid_rd_addr     = (w_32b_aligned && (ws_addr >= `CR_ISF_REVISION_CONFIG) && (ws_addr <= `CR_ISF_SPARE_CONFIG))
                          || (w_32b_aligned && (ws_addr >= `CR_ISF_ISF_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_ISF_ISF_FIFO_IA_RDATA_PART2))
                          || (w_32b_aligned && (ws_addr >= `CR_ISF_ISF_FIFO_FIFO_STATUS_0) && (ws_addr <= `CR_ISF_IB_AGG_DATA_BYTES_GLOBAL_CONFIG));

  wire w_valid_wr_addr     = (w_32b_aligned && (ws_addr >= `CR_ISF_REVISION_CONFIG) && (ws_addr <= `CR_ISF_SPARE_CONFIG))
                          || (w_32b_aligned && (ws_addr >= `CR_ISF_ISF_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_ISF_ISF_FIFO_IA_RDATA_PART2))
                          || (w_32b_aligned && (ws_addr >= `CR_ISF_ISF_FIFO_FIFO_STATUS_0) && (ws_addr <= `CR_ISF_IB_AGG_DATA_BYTES_GLOBAL_CONFIG));

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

  wire [31:0]  r32_formatted_reg_data = f32_mux_0_data
                                      | f32_mux_1_data;

  always_comb begin
    r32_mux_0_data = 0;
    r32_mux_1_data = 0;

    case (ws_read_addr)
    `CR_ISF_REVISION_CONFIG: begin
      r32_mux_0_data[07:00] = i_revision_config[07:00]; 
    end
    `CR_ISF_SPARE_CONFIG: begin
      r32_mux_0_data[31:00] = i_spare_config[31:00]; 
    end
    `CR_ISF_ISF_TLV_PARSE_ACTION_0: begin
      r32_mux_0_data[01:00] = o_isf_tlv_parse_action_0[01:00]; 
      r32_mux_0_data[03:02] = o_isf_tlv_parse_action_0[03:02]; 
      r32_mux_0_data[05:04] = o_isf_tlv_parse_action_0[05:04]; 
      r32_mux_0_data[07:06] = o_isf_tlv_parse_action_0[07:06]; 
      r32_mux_0_data[09:08] = o_isf_tlv_parse_action_0[09:08]; 
      r32_mux_0_data[11:10] = o_isf_tlv_parse_action_0[11:10]; 
      r32_mux_0_data[13:12] = o_isf_tlv_parse_action_0[13:12]; 
      r32_mux_0_data[15:14] = o_isf_tlv_parse_action_0[15:14]; 
      r32_mux_0_data[17:16] = o_isf_tlv_parse_action_0[17:16]; 
      r32_mux_0_data[19:18] = o_isf_tlv_parse_action_0[19:18]; 
      r32_mux_0_data[21:20] = o_isf_tlv_parse_action_0[21:20]; 
      r32_mux_0_data[23:22] = o_isf_tlv_parse_action_0[23:22]; 
      r32_mux_0_data[25:24] = o_isf_tlv_parse_action_0[25:24]; 
      r32_mux_0_data[27:26] = o_isf_tlv_parse_action_0[27:26]; 
      r32_mux_0_data[29:28] = o_isf_tlv_parse_action_0[29:28]; 
      r32_mux_0_data[31:30] = o_isf_tlv_parse_action_0[31:30]; 
    end
    `CR_ISF_ISF_TLV_PARSE_ACTION_1: begin
      r32_mux_0_data[01:00] = o_isf_tlv_parse_action_1[01:00]; 
      r32_mux_0_data[03:02] = o_isf_tlv_parse_action_1[03:02]; 
      r32_mux_0_data[05:04] = o_isf_tlv_parse_action_1[05:04]; 
      r32_mux_0_data[07:06] = o_isf_tlv_parse_action_1[07:06]; 
      r32_mux_0_data[09:08] = o_isf_tlv_parse_action_1[09:08]; 
      r32_mux_0_data[11:10] = o_isf_tlv_parse_action_1[11:10]; 
      r32_mux_0_data[13:12] = o_isf_tlv_parse_action_1[13:12]; 
      r32_mux_0_data[15:14] = o_isf_tlv_parse_action_1[15:14]; 
      r32_mux_0_data[17:16] = o_isf_tlv_parse_action_1[17:16]; 
      r32_mux_0_data[19:18] = o_isf_tlv_parse_action_1[19:18]; 
      r32_mux_0_data[21:20] = o_isf_tlv_parse_action_1[21:20]; 
      r32_mux_0_data[23:22] = o_isf_tlv_parse_action_1[23:22]; 
      r32_mux_0_data[25:24] = o_isf_tlv_parse_action_1[25:24]; 
      r32_mux_0_data[27:26] = o_isf_tlv_parse_action_1[27:26]; 
      r32_mux_0_data[29:28] = o_isf_tlv_parse_action_1[29:28]; 
      r32_mux_0_data[31:30] = o_isf_tlv_parse_action_1[31:30]; 
    end
    `CR_ISF_CTL_CONFIG: begin
      r32_mux_0_data[02:00] = o_ctl_config[02:00]; 
      r32_mux_0_data[05:03] = o_ctl_config[05:03]; 
      r32_mux_0_data[08:08] = o_ctl_config[06:06]; 
      r32_mux_0_data[12:12] = o_ctl_config[07:07]; 
      r32_mux_0_data[13:13] = o_ctl_config[08:08]; 
      r32_mux_0_data[14:14] = o_ctl_config[09:09]; 
      r32_mux_0_data[15:15] = o_ctl_config[10:10]; 
    end
    `CR_ISF_SYSTEM_STALL_LIMIT_CONFIG: begin
      r32_mux_0_data[31:00] = o_system_stall_limit_config[31:00]; 
    end
    `CR_ISF_DEBUG_CTL_CONFIG: begin
      r32_mux_0_data[02:00] = o_debug_ctl_config[02:00]; 
      r32_mux_0_data[03:03] = o_debug_ctl_config[03:03]; 
      r32_mux_0_data[13:04] = o_debug_ctl_config[13:04]; 
      r32_mux_0_data[26:16] = o_debug_ctl_config[24:14]; 
      r32_mux_0_data[28:28] = o_debug_ctl_config[25:25]; 
      r32_mux_0_data[31:31] = o_debug_ctl_config[26:26]; 
    end
    `CR_ISF_DEBUG_SS_CTL_CONFIG: begin
      r32_mux_0_data[00:00] = o_debug_ss_ctl_config[00:00]; 
    end
    `CR_ISF_DEBUG_STAT: begin
      r32_mux_0_data[00:00] = i_debug_stat[00:00]; 
      r32_mux_0_data[01:01] = i_debug_stat[01:01]; 
    end
    `CR_ISF_DEBUG_TRIG_TLV_CONFIG: begin
      r32_mux_0_data[07:00] = o_debug_trig_tlv_config[07:00]; 
      r32_mux_0_data[28:08] = o_debug_trig_tlv_config[28:08]; 
    end
    `CR_ISF_DEBUG_TRIG_MATCH_LO_CONFIG: begin
      r32_mux_0_data[31:00] = o_debug_trig_match_lo_config[31:00]; 
    end
    `CR_ISF_DEBUG_TRIG_MATCH_HI_CONFIG: begin
      r32_mux_0_data[31:00] = o_debug_trig_match_hi_config[31:00]; 
    end
    `CR_ISF_DEBUG_TRIG_MASK_LO_CONFIG: begin
      r32_mux_0_data[31:00] = o_debug_trig_mask_lo_config[31:00]; 
    end
    `CR_ISF_DEBUG_TRIG_MASK_HI_CONFIG: begin
      r32_mux_0_data[31:00] = o_debug_trig_mask_hi_config[31:00]; 
    end
    `CR_ISF_DEBUG_TRIG_CAP_LO: begin
      r32_mux_0_data[31:00] = i_debug_trig_cap_lo[31:00]; 
    end
    `CR_ISF_DEBUG_TRIG_CAP_HI: begin
      r32_mux_0_data[31:00] = i_debug_trig_cap_hi[31:00]; 
    end
    `CR_ISF_DEBUG_SS_CAP_SB: begin
      r32_mux_0_data[07:00] = i_debug_ss_cap_sb[07:00]; 
      r32_mux_0_data[08:08] = i_debug_ss_cap_sb[08:08]; 
      r32_mux_0_data[16:09] = i_debug_ss_cap_sb[16:09]; 
      r32_mux_0_data[24:17] = i_debug_ss_cap_sb[24:17]; 
      r32_mux_0_data[25:25] = i_debug_ss_cap_sb[25:25]; 
      r32_mux_0_data[27:26] = i_debug_ss_cap_sb[27:26]; 
    end
    `CR_ISF_DEBUG_SS_CAP_LO: begin
      r32_mux_0_data[31:00] = i_debug_ss_cap_lo[31:00]; 
    end
    `CR_ISF_DEBUG_SS_CAP_HI: begin
      r32_mux_0_data[31:00] = i_debug_ss_cap_hi[31:00]; 
    end
    `CR_ISF_TRACE_CTL_EN_CONFIG: begin
      r32_mux_0_data[00:00] = o_trace_ctl_en_config[00:00]; 
    end
    `CR_ISF_TRACE_CTL_LIMITS_CONFIG: begin
      r32_mux_0_data[15:00] = o_trace_ctl_limits_config[15:00]; 
      r32_mux_0_data[31:16] = o_trace_ctl_limits_config[31:16]; 
    end
    `CR_ISF_AUX_CMD_EV_MATCH_VAL_0_COMP_CONFIG: begin
      r32_mux_0_data[31:00] = o_aux_cmd_ev_match_val_0_comp_config[31:00]; 
    end
    `CR_ISF_AUX_CMD_EV_MATCH_VAL_0_CRYPTO_CONFIG: begin
      r32_mux_0_data[31:00] = o_aux_cmd_ev_match_val_0_crypto_config[31:00]; 
    end
    `CR_ISF_AUX_CMD_EV_MASK_VAL_0_COMP_CONFIG: begin
      r32_mux_0_data[31:00] = o_aux_cmd_ev_mask_val_0_comp_config[31:00]; 
    end
    `CR_ISF_AUX_CMD_EV_MASK_VAL_0_CRYPTO_CONFIG: begin
      r32_mux_0_data[31:00] = o_aux_cmd_ev_mask_val_0_crypto_config[31:00]; 
    end
    `CR_ISF_AUX_CMD_EV_MATCH_VAL_1_COMP_CONFIG: begin
      r32_mux_0_data[31:00] = o_aux_cmd_ev_match_val_1_comp_config[31:00]; 
    end
    endcase

    case (ws_read_addr)
    `CR_ISF_AUX_CMD_EV_MATCH_VAL_1_CRYPTO_CONFIG: begin
      r32_mux_1_data[31:00] = o_aux_cmd_ev_match_val_1_crypto_config[31:00]; 
    end
    `CR_ISF_AUX_CMD_EV_MASK_VAL_1_COMP_CONFIG: begin
      r32_mux_1_data[31:00] = o_aux_cmd_ev_mask_val_1_comp_config[31:00]; 
    end
    `CR_ISF_AUX_CMD_EV_MASK_VAL_1_CRYPTO_CONFIG: begin
      r32_mux_1_data[31:00] = o_aux_cmd_ev_mask_val_1_crypto_config[31:00]; 
    end
    `CR_ISF_AUX_CMD_EV_MATCH_VAL_2_COMP_CONFIG: begin
      r32_mux_1_data[31:00] = o_aux_cmd_ev_match_val_2_comp_config[31:00]; 
    end
    `CR_ISF_AUX_CMD_EV_MATCH_VAL_2_CRYPTO_CONFIG: begin
      r32_mux_1_data[31:00] = o_aux_cmd_ev_match_val_2_crypto_config[31:00]; 
    end
    `CR_ISF_AUX_CMD_EV_MASK_VAL_2_COMP_CONFIG: begin
      r32_mux_1_data[31:00] = o_aux_cmd_ev_mask_val_2_comp_config[31:00]; 
    end
    `CR_ISF_AUX_CMD_EV_MASK_VAL_2_CRYPTO_CONFIG: begin
      r32_mux_1_data[31:00] = o_aux_cmd_ev_mask_val_2_crypto_config[31:00]; 
    end
    `CR_ISF_AUX_CMD_EV_MATCH_VAL_3_COMP_CONFIG: begin
      r32_mux_1_data[31:00] = o_aux_cmd_ev_match_val_3_comp_config[31:00]; 
    end
    `CR_ISF_AUX_CMD_EV_MATCH_VAL_3_CRYPTO_CONFIG: begin
      r32_mux_1_data[31:00] = o_aux_cmd_ev_match_val_3_crypto_config[31:00]; 
    end
    `CR_ISF_AUX_CMD_EV_MASK_VAL_3_COMP_CONFIG: begin
      r32_mux_1_data[31:00] = o_aux_cmd_ev_mask_val_3_comp_config[31:00]; 
    end
    `CR_ISF_AUX_CMD_EV_MASK_VAL_3_CRYPTO_CONFIG: begin
      r32_mux_1_data[31:00] = o_aux_cmd_ev_mask_val_3_crypto_config[31:00]; 
    end
    `CR_ISF_ISF_FIFO_IA_CAPABILITY: begin
      r32_mux_1_data[00:00] = i_isf_fifo_ia_capability[00:00]; 
      r32_mux_1_data[01:01] = i_isf_fifo_ia_capability[01:01]; 
      r32_mux_1_data[02:02] = i_isf_fifo_ia_capability[02:02]; 
      r32_mux_1_data[03:03] = i_isf_fifo_ia_capability[03:03]; 
      r32_mux_1_data[04:04] = i_isf_fifo_ia_capability[04:04]; 
      r32_mux_1_data[05:05] = i_isf_fifo_ia_capability[05:05]; 
      r32_mux_1_data[06:06] = i_isf_fifo_ia_capability[06:06]; 
      r32_mux_1_data[07:07] = i_isf_fifo_ia_capability[07:07]; 
      r32_mux_1_data[08:08] = i_isf_fifo_ia_capability[08:08]; 
      r32_mux_1_data[09:09] = i_isf_fifo_ia_capability[09:09]; 
      r32_mux_1_data[13:10] = i_isf_fifo_ia_capability[13:10]; 
      r32_mux_1_data[14:14] = i_isf_fifo_ia_capability[14:14]; 
      r32_mux_1_data[15:15] = i_isf_fifo_ia_capability[15:15]; 
      r32_mux_1_data[31:28] = i_isf_fifo_ia_capability[19:16]; 
    end
    `CR_ISF_ISF_FIFO_IA_STATUS: begin
      r32_mux_1_data[09:00] = i_isf_fifo_ia_status[09:00]; 
      r32_mux_1_data[28:24] = i_isf_fifo_ia_status[14:10]; 
      r32_mux_1_data[31:29] = i_isf_fifo_ia_status[17:15]; 
    end
    `CR_ISF_ISF_FIFO_IA_WDATA_PART0: begin
      r32_mux_1_data[31:00] = o_isf_fifo_ia_wdata_part0[31:00]; 
    end
    `CR_ISF_ISF_FIFO_IA_WDATA_PART1: begin
      r32_mux_1_data[31:00] = o_isf_fifo_ia_wdata_part1[31:00]; 
    end
    `CR_ISF_ISF_FIFO_IA_WDATA_PART2: begin
      r32_mux_1_data[00:00] = o_isf_fifo_ia_wdata_part2[00:00]; 
      r32_mux_1_data[03:01] = o_isf_fifo_ia_wdata_part2[03:01]; 
      r32_mux_1_data[11:04] = o_isf_fifo_ia_wdata_part2[11:04]; 
      r32_mux_1_data[19:12] = o_isf_fifo_ia_wdata_part2[19:12]; 
      r32_mux_1_data[20:20] = o_isf_fifo_ia_wdata_part2[20:20]; 
    end
    `CR_ISF_ISF_FIFO_IA_CONFIG: begin
      r32_mux_1_data[09:00] = o_isf_fifo_ia_config[09:00]; 
      r32_mux_1_data[31:28] = o_isf_fifo_ia_config[13:10]; 
    end
    `CR_ISF_ISF_FIFO_IA_RDATA_PART0: begin
      r32_mux_1_data[31:00] = i_isf_fifo_ia_rdata_part0[31:00]; 
    end
    `CR_ISF_ISF_FIFO_IA_RDATA_PART1: begin
      r32_mux_1_data[31:00] = i_isf_fifo_ia_rdata_part1[31:00]; 
    end
    `CR_ISF_ISF_FIFO_IA_RDATA_PART2: begin
      r32_mux_1_data[00:00] = i_isf_fifo_ia_rdata_part2[00:00]; 
      r32_mux_1_data[03:01] = i_isf_fifo_ia_rdata_part2[03:01]; 
      r32_mux_1_data[11:04] = i_isf_fifo_ia_rdata_part2[11:04]; 
      r32_mux_1_data[19:12] = i_isf_fifo_ia_rdata_part2[19:12]; 
      r32_mux_1_data[20:20] = i_isf_fifo_ia_rdata_part2[20:20]; 
    end
    `CR_ISF_ISF_FIFO_FIFO_STATUS_0: begin
      r32_mux_1_data[09:00] = i_isf_fifo_fifo_status_0[09:00]; 
      r32_mux_1_data[25:16] = i_isf_fifo_fifo_status_0[19:10]; 
      r32_mux_1_data[28:28] = i_isf_fifo_fifo_status_0[20:20]; 
      r32_mux_1_data[29:29] = i_isf_fifo_fifo_status_0[21:21]; 
      r32_mux_1_data[30:30] = i_isf_fifo_fifo_status_0[22:22]; 
      r32_mux_1_data[31:31] = i_isf_fifo_fifo_status_0[23:23]; 
    end
    `CR_ISF_ISF_FIFO_FIFO_STATUS_1: begin
      r32_mux_1_data[10:00] = i_isf_fifo_fifo_status_1[10:00]; 
    end
    `CR_ISF_IB_AGG_DATA_BYTES_0_COUNT_PART0_A: begin
      r32_mux_1_data[31:00] = i_ib_agg_data_bytes_0_count_part0_a[31:00]; 
    end
    `CR_ISF_IB_AGG_DATA_BYTES_0_COUNT_PART1_A: begin
      r32_mux_1_data[17:00] = i_ib_agg_data_bytes_0_count_part1_a[17:00]; 
    end
    `CR_ISF_IB_AGG_DATA_BYTES_GLOBAL_READ: begin
      r32_mux_1_data[00:00] = i_ib_agg_data_bytes_global_read[00:00]; 
    end
    `CR_ISF_IB_AGG_DATA_BYTES_GLOBAL_CONFIG: begin
      r32_mux_1_data[00:00] = o_ib_agg_data_bytes_global_config[00:00]; 
    end
    endcase

  end

  
  

  
  

  reg  [31:0]  f32_data;

  assign o_reg_wr_data = f32_data;

  
  

  
  assign       o_rd_data  = (o_ack  & ~n_write) ? r32_formatted_reg_data : { 32 { 1'b0 } };
  

  
  

  wire w_load_spare_config                         = w_do_write & (ws_addr == `CR_ISF_SPARE_CONFIG);
  wire w_load_isf_tlv_parse_action_0               = w_do_write & (ws_addr == `CR_ISF_ISF_TLV_PARSE_ACTION_0);
  wire w_load_isf_tlv_parse_action_1               = w_do_write & (ws_addr == `CR_ISF_ISF_TLV_PARSE_ACTION_1);
  wire w_load_ctl_config                           = w_do_write & (ws_addr == `CR_ISF_CTL_CONFIG);
  wire w_load_system_stall_limit_config            = w_do_write & (ws_addr == `CR_ISF_SYSTEM_STALL_LIMIT_CONFIG);
  wire w_load_debug_ctl_config                     = w_do_write & (ws_addr == `CR_ISF_DEBUG_CTL_CONFIG);
  wire w_load_debug_ss_ctl_config                  = w_do_write & (ws_addr == `CR_ISF_DEBUG_SS_CTL_CONFIG);
  wire w_load_debug_trig_tlv_config                = w_do_write & (ws_addr == `CR_ISF_DEBUG_TRIG_TLV_CONFIG);
  wire w_load_debug_trig_match_lo_config           = w_do_write & (ws_addr == `CR_ISF_DEBUG_TRIG_MATCH_LO_CONFIG);
  wire w_load_debug_trig_match_hi_config           = w_do_write & (ws_addr == `CR_ISF_DEBUG_TRIG_MATCH_HI_CONFIG);
  wire w_load_debug_trig_mask_lo_config            = w_do_write & (ws_addr == `CR_ISF_DEBUG_TRIG_MASK_LO_CONFIG);
  wire w_load_debug_trig_mask_hi_config            = w_do_write & (ws_addr == `CR_ISF_DEBUG_TRIG_MASK_HI_CONFIG);
  wire w_load_trace_ctl_en_config                  = w_do_write & (ws_addr == `CR_ISF_TRACE_CTL_EN_CONFIG);
  wire w_load_trace_ctl_limits_config              = w_do_write & (ws_addr == `CR_ISF_TRACE_CTL_LIMITS_CONFIG);
  wire w_load_aux_cmd_ev_match_val_0_comp_config   = w_do_write & (ws_addr == `CR_ISF_AUX_CMD_EV_MATCH_VAL_0_COMP_CONFIG);
  wire w_load_aux_cmd_ev_match_val_0_crypto_config = w_do_write & (ws_addr == `CR_ISF_AUX_CMD_EV_MATCH_VAL_0_CRYPTO_CONFIG);
  wire w_load_aux_cmd_ev_mask_val_0_comp_config    = w_do_write & (ws_addr == `CR_ISF_AUX_CMD_EV_MASK_VAL_0_COMP_CONFIG);
  wire w_load_aux_cmd_ev_mask_val_0_crypto_config  = w_do_write & (ws_addr == `CR_ISF_AUX_CMD_EV_MASK_VAL_0_CRYPTO_CONFIG);
  wire w_load_aux_cmd_ev_match_val_1_comp_config   = w_do_write & (ws_addr == `CR_ISF_AUX_CMD_EV_MATCH_VAL_1_COMP_CONFIG);
  wire w_load_aux_cmd_ev_match_val_1_crypto_config = w_do_write & (ws_addr == `CR_ISF_AUX_CMD_EV_MATCH_VAL_1_CRYPTO_CONFIG);
  wire w_load_aux_cmd_ev_mask_val_1_comp_config    = w_do_write & (ws_addr == `CR_ISF_AUX_CMD_EV_MASK_VAL_1_COMP_CONFIG);
  wire w_load_aux_cmd_ev_mask_val_1_crypto_config  = w_do_write & (ws_addr == `CR_ISF_AUX_CMD_EV_MASK_VAL_1_CRYPTO_CONFIG);
  wire w_load_aux_cmd_ev_match_val_2_comp_config   = w_do_write & (ws_addr == `CR_ISF_AUX_CMD_EV_MATCH_VAL_2_COMP_CONFIG);
  wire w_load_aux_cmd_ev_match_val_2_crypto_config = w_do_write & (ws_addr == `CR_ISF_AUX_CMD_EV_MATCH_VAL_2_CRYPTO_CONFIG);
  wire w_load_aux_cmd_ev_mask_val_2_comp_config    = w_do_write & (ws_addr == `CR_ISF_AUX_CMD_EV_MASK_VAL_2_COMP_CONFIG);
  wire w_load_aux_cmd_ev_mask_val_2_crypto_config  = w_do_write & (ws_addr == `CR_ISF_AUX_CMD_EV_MASK_VAL_2_CRYPTO_CONFIG);
  wire w_load_aux_cmd_ev_match_val_3_comp_config   = w_do_write & (ws_addr == `CR_ISF_AUX_CMD_EV_MATCH_VAL_3_COMP_CONFIG);
  wire w_load_aux_cmd_ev_match_val_3_crypto_config = w_do_write & (ws_addr == `CR_ISF_AUX_CMD_EV_MATCH_VAL_3_CRYPTO_CONFIG);
  wire w_load_aux_cmd_ev_mask_val_3_comp_config    = w_do_write & (ws_addr == `CR_ISF_AUX_CMD_EV_MASK_VAL_3_COMP_CONFIG);
  wire w_load_aux_cmd_ev_mask_val_3_crypto_config  = w_do_write & (ws_addr == `CR_ISF_AUX_CMD_EV_MASK_VAL_3_CRYPTO_CONFIG);
  wire w_load_isf_fifo_ia_wdata_part0              = w_do_write & (ws_addr == `CR_ISF_ISF_FIFO_IA_WDATA_PART0);
  wire w_load_isf_fifo_ia_wdata_part1              = w_do_write & (ws_addr == `CR_ISF_ISF_FIFO_IA_WDATA_PART1);
  wire w_load_isf_fifo_ia_wdata_part2              = w_do_write & (ws_addr == `CR_ISF_ISF_FIFO_IA_WDATA_PART2);
  wire w_load_isf_fifo_ia_config                   = w_do_write & (ws_addr == `CR_ISF_ISF_FIFO_IA_CONFIG);
  wire w_load_ib_agg_data_bytes_global_config      = w_do_write & (ws_addr == `CR_ISF_IB_AGG_DATA_BYTES_GLOBAL_CONFIG);


  


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

    end
  end

  
  always_ff @(posedge clk) begin
    if (i_wr_strb)               f32_data       <= i_wr_data;

  end
  

  cr_isf_regs_flops u_cr_isf_regs_flops (
        .clk                                    ( clk ),
        .i_reset_                               ( i_reset_ ),
        .i_sw_init                              ( i_sw_init ),
        .o_spare_config                         ( o_spare_config ),
        .o_isf_tlv_parse_action_0               ( o_isf_tlv_parse_action_0 ),
        .o_isf_tlv_parse_action_1               ( o_isf_tlv_parse_action_1 ),
        .o_ctl_config                           ( o_ctl_config ),
        .o_system_stall_limit_config            ( o_system_stall_limit_config ),
        .o_debug_ctl_config                     ( o_debug_ctl_config ),
        .o_debug_ss_ctl_config                  ( o_debug_ss_ctl_config ),
        .o_debug_trig_tlv_config                ( o_debug_trig_tlv_config ),
        .o_debug_trig_match_lo_config           ( o_debug_trig_match_lo_config ),
        .o_debug_trig_match_hi_config           ( o_debug_trig_match_hi_config ),
        .o_debug_trig_mask_lo_config            ( o_debug_trig_mask_lo_config ),
        .o_debug_trig_mask_hi_config            ( o_debug_trig_mask_hi_config ),
        .o_trace_ctl_en_config                  ( o_trace_ctl_en_config ),
        .o_trace_ctl_limits_config              ( o_trace_ctl_limits_config ),
        .o_aux_cmd_ev_match_val_0_comp_config   ( o_aux_cmd_ev_match_val_0_comp_config ),
        .o_aux_cmd_ev_match_val_0_crypto_config ( o_aux_cmd_ev_match_val_0_crypto_config ),
        .o_aux_cmd_ev_mask_val_0_comp_config    ( o_aux_cmd_ev_mask_val_0_comp_config ),
        .o_aux_cmd_ev_mask_val_0_crypto_config  ( o_aux_cmd_ev_mask_val_0_crypto_config ),
        .o_aux_cmd_ev_match_val_1_comp_config   ( o_aux_cmd_ev_match_val_1_comp_config ),
        .o_aux_cmd_ev_match_val_1_crypto_config ( o_aux_cmd_ev_match_val_1_crypto_config ),
        .o_aux_cmd_ev_mask_val_1_comp_config    ( o_aux_cmd_ev_mask_val_1_comp_config ),
        .o_aux_cmd_ev_mask_val_1_crypto_config  ( o_aux_cmd_ev_mask_val_1_crypto_config ),
        .o_aux_cmd_ev_match_val_2_comp_config   ( o_aux_cmd_ev_match_val_2_comp_config ),
        .o_aux_cmd_ev_match_val_2_crypto_config ( o_aux_cmd_ev_match_val_2_crypto_config ),
        .o_aux_cmd_ev_mask_val_2_comp_config    ( o_aux_cmd_ev_mask_val_2_comp_config ),
        .o_aux_cmd_ev_mask_val_2_crypto_config  ( o_aux_cmd_ev_mask_val_2_crypto_config ),
        .o_aux_cmd_ev_match_val_3_comp_config   ( o_aux_cmd_ev_match_val_3_comp_config ),
        .o_aux_cmd_ev_match_val_3_crypto_config ( o_aux_cmd_ev_match_val_3_crypto_config ),
        .o_aux_cmd_ev_mask_val_3_comp_config    ( o_aux_cmd_ev_mask_val_3_comp_config ),
        .o_aux_cmd_ev_mask_val_3_crypto_config  ( o_aux_cmd_ev_mask_val_3_crypto_config ),
        .o_isf_fifo_ia_wdata_part0              ( o_isf_fifo_ia_wdata_part0 ),
        .o_isf_fifo_ia_wdata_part1              ( o_isf_fifo_ia_wdata_part1 ),
        .o_isf_fifo_ia_wdata_part2              ( o_isf_fifo_ia_wdata_part2 ),
        .o_isf_fifo_ia_config                   ( o_isf_fifo_ia_config ),
        .o_ib_agg_data_bytes_global_config      ( o_ib_agg_data_bytes_global_config ),
        .w_load_spare_config                    ( w_load_spare_config ),
        .w_load_isf_tlv_parse_action_0          ( w_load_isf_tlv_parse_action_0 ),
        .w_load_isf_tlv_parse_action_1          ( w_load_isf_tlv_parse_action_1 ),
        .w_load_ctl_config                      ( w_load_ctl_config ),
        .w_load_system_stall_limit_config       ( w_load_system_stall_limit_config ),
        .w_load_debug_ctl_config                ( w_load_debug_ctl_config ),
        .w_load_debug_ss_ctl_config             ( w_load_debug_ss_ctl_config ),
        .w_load_debug_trig_tlv_config           ( w_load_debug_trig_tlv_config ),
        .w_load_debug_trig_match_lo_config      ( w_load_debug_trig_match_lo_config ),
        .w_load_debug_trig_match_hi_config      ( w_load_debug_trig_match_hi_config ),
        .w_load_debug_trig_mask_lo_config       ( w_load_debug_trig_mask_lo_config ),
        .w_load_debug_trig_mask_hi_config       ( w_load_debug_trig_mask_hi_config ),
        .w_load_trace_ctl_en_config             ( w_load_trace_ctl_en_config ),
        .w_load_trace_ctl_limits_config         ( w_load_trace_ctl_limits_config ),
        .w_load_aux_cmd_ev_match_val_0_comp_config ( w_load_aux_cmd_ev_match_val_0_comp_config ),
        .w_load_aux_cmd_ev_match_val_0_crypto_config ( w_load_aux_cmd_ev_match_val_0_crypto_config ),
        .w_load_aux_cmd_ev_mask_val_0_comp_config ( w_load_aux_cmd_ev_mask_val_0_comp_config ),
        .w_load_aux_cmd_ev_mask_val_0_crypto_config ( w_load_aux_cmd_ev_mask_val_0_crypto_config ),
        .w_load_aux_cmd_ev_match_val_1_comp_config ( w_load_aux_cmd_ev_match_val_1_comp_config ),
        .w_load_aux_cmd_ev_match_val_1_crypto_config ( w_load_aux_cmd_ev_match_val_1_crypto_config ),
        .w_load_aux_cmd_ev_mask_val_1_comp_config ( w_load_aux_cmd_ev_mask_val_1_comp_config ),
        .w_load_aux_cmd_ev_mask_val_1_crypto_config ( w_load_aux_cmd_ev_mask_val_1_crypto_config ),
        .w_load_aux_cmd_ev_match_val_2_comp_config ( w_load_aux_cmd_ev_match_val_2_comp_config ),
        .w_load_aux_cmd_ev_match_val_2_crypto_config ( w_load_aux_cmd_ev_match_val_2_crypto_config ),
        .w_load_aux_cmd_ev_mask_val_2_comp_config ( w_load_aux_cmd_ev_mask_val_2_comp_config ),
        .w_load_aux_cmd_ev_mask_val_2_crypto_config ( w_load_aux_cmd_ev_mask_val_2_crypto_config ),
        .w_load_aux_cmd_ev_match_val_3_comp_config ( w_load_aux_cmd_ev_match_val_3_comp_config ),
        .w_load_aux_cmd_ev_match_val_3_crypto_config ( w_load_aux_cmd_ev_match_val_3_crypto_config ),
        .w_load_aux_cmd_ev_mask_val_3_comp_config ( w_load_aux_cmd_ev_mask_val_3_comp_config ),
        .w_load_aux_cmd_ev_mask_val_3_crypto_config ( w_load_aux_cmd_ev_mask_val_3_crypto_config ),
        .w_load_isf_fifo_ia_wdata_part0         ( w_load_isf_fifo_ia_wdata_part0 ),
        .w_load_isf_fifo_ia_wdata_part1         ( w_load_isf_fifo_ia_wdata_part1 ),
        .w_load_isf_fifo_ia_wdata_part2         ( w_load_isf_fifo_ia_wdata_part2 ),
        .w_load_isf_fifo_ia_config              ( w_load_isf_fifo_ia_config ),
        .w_load_ib_agg_data_bytes_global_config ( w_load_ib_agg_data_bytes_global_config ),
        .f32_data                               ( f32_data )
  );

  

  

  `ifdef CR_ISF_DIGEST_59367190026ADA0AC4F6AB07903E0DD4
  `else
    initial begin
      $display("Error: the core decode file (cr_isf_regs.sv) and include file (cr_isf.vh) were compiled");
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


module cr_isf_regs_flops (
  input                                         clk,
  input                                         i_reset_,
  input                                         i_sw_init,

  
  output reg [`CR_ISF_C_SPARE_T_DECL]           o_spare_config,
  output reg [`CR_ISF_C_ISF_TLV_PARSE_ACTION_31_0_T_DECL] o_isf_tlv_parse_action_0,
  output reg [`CR_ISF_C_ISF_TLV_PARSE_ACTION_63_32_T_DECL] o_isf_tlv_parse_action_1,
  output reg [`CR_ISF_C_CTL_T_DECL]             o_ctl_config,
  output reg [`CR_ISF_C_SYSTEM_STALL_LIMIT_T_DECL] o_system_stall_limit_config,
  output reg [`CR_ISF_C_DEBUG_CTL_T_DECL]       o_debug_ctl_config,
  output reg [`CR_ISF_C_DEBUG_SS_CTL_T_DECL]    o_debug_ss_ctl_config,
  output reg [`CR_ISF_C_DEBUG_TRIG_TLV_T_DECL]  o_debug_trig_tlv_config,
  output reg [`CR_ISF_C_DEBUG_TRIG_MATCH_LO_T_DECL] o_debug_trig_match_lo_config,
  output reg [`CR_ISF_C_DEBUG_TRIG_MATCH_HI_T_DECL] o_debug_trig_match_hi_config,
  output reg [`CR_ISF_C_DEBUG_TRIG_MASK_LO_T_DECL] o_debug_trig_mask_lo_config,
  output reg [`CR_ISF_C_DEBUG_TRIG_MASK_HI_T_DECL] o_debug_trig_mask_hi_config,
  output reg [`CR_ISF_C_TRACE_CTL_EN_T_DECL]    o_trace_ctl_en_config,
  output reg [`CR_ISF_C_TRACE_CTL_LIMITS_T_DECL] o_trace_ctl_limits_config,
  output reg [`CR_ISF_C_AUX_CMD_EV_MATCH_VAL_0_COMP_T_DECL] o_aux_cmd_ev_match_val_0_comp_config,
  output reg [`CR_ISF_C_AUX_CMD_EV_MATCH_VAL_0_CRYPTO_T_DECL] o_aux_cmd_ev_match_val_0_crypto_config,
  output reg [`CR_ISF_C_AUX_CMD_EV_MASK_VAL_0_COMP_T_DECL] o_aux_cmd_ev_mask_val_0_comp_config,
  output reg [`CR_ISF_C_AUX_CMD_EV_MASK_VAL_0_CRYPTO_T_DECL] o_aux_cmd_ev_mask_val_0_crypto_config,
  output reg [`CR_ISF_C_AUX_CMD_EV_MATCH_VAL_1_COMP_T_DECL] o_aux_cmd_ev_match_val_1_comp_config,
  output reg [`CR_ISF_C_AUX_CMD_EV_MATCH_VAL_1_CRYPTO_T_DECL] o_aux_cmd_ev_match_val_1_crypto_config,
  output reg [`CR_ISF_C_AUX_CMD_EV_MASK_VAL_1_COMP_T_DECL] o_aux_cmd_ev_mask_val_1_comp_config,
  output reg [`CR_ISF_C_AUX_CMD_EV_MASK_VAL_1_CRYPTO_T_DECL] o_aux_cmd_ev_mask_val_1_crypto_config,
  output reg [`CR_ISF_C_AUX_CMD_EV_MATCH_VAL_2_COMP_T_DECL] o_aux_cmd_ev_match_val_2_comp_config,
  output reg [`CR_ISF_C_AUX_CMD_EV_MATCH_VAL_2_CRYPTO_T_DECL] o_aux_cmd_ev_match_val_2_crypto_config,
  output reg [`CR_ISF_C_AUX_CMD_EV_MASK_VAL_2_COMP_T_DECL] o_aux_cmd_ev_mask_val_2_comp_config,
  output reg [`CR_ISF_C_AUX_CMD_EV_MASK_VAL_2_CRYPTO_T_DECL] o_aux_cmd_ev_mask_val_2_crypto_config,
  output reg [`CR_ISF_C_AUX_CMD_EV_MATCH_VAL_3_COMP_T_DECL] o_aux_cmd_ev_match_val_3_comp_config,
  output reg [`CR_ISF_C_AUX_CMD_EV_MATCH_VAL_3_CRYPTO_T_DECL] o_aux_cmd_ev_match_val_3_crypto_config,
  output reg [`CR_ISF_C_AUX_CMD_EV_MASK_VAL_3_COMP_T_DECL] o_aux_cmd_ev_mask_val_3_comp_config,
  output reg [`CR_ISF_C_AUX_CMD_EV_MASK_VAL_3_CRYPTO_T_DECL] o_aux_cmd_ev_mask_val_3_crypto_config,
  output reg [`CR_ISF_C_ISF_FIFO_PART0_T_DECL]  o_isf_fifo_ia_wdata_part0,
  output reg [`CR_ISF_C_ISF_FIFO_PART1_T_DECL]  o_isf_fifo_ia_wdata_part1,
  output reg [`CR_ISF_C_ISF_FIFO_PART2_T_DECL]  o_isf_fifo_ia_wdata_part2,
  output reg [`CR_ISF_C_ISF_FIFO_IA_CONFIG_T_DECL] o_isf_fifo_ia_config,
  output reg [`CR_ISF_C_IB_AGG_DATA_BYTES_GLOBAL_CONFIG_T_DECL] o_ib_agg_data_bytes_global_config,


  
  input                                         w_load_spare_config,
  input                                         w_load_isf_tlv_parse_action_0,
  input                                         w_load_isf_tlv_parse_action_1,
  input                                         w_load_ctl_config,
  input                                         w_load_system_stall_limit_config,
  input                                         w_load_debug_ctl_config,
  input                                         w_load_debug_ss_ctl_config,
  input                                         w_load_debug_trig_tlv_config,
  input                                         w_load_debug_trig_match_lo_config,
  input                                         w_load_debug_trig_match_hi_config,
  input                                         w_load_debug_trig_mask_lo_config,
  input                                         w_load_debug_trig_mask_hi_config,
  input                                         w_load_trace_ctl_en_config,
  input                                         w_load_trace_ctl_limits_config,
  input                                         w_load_aux_cmd_ev_match_val_0_comp_config,
  input                                         w_load_aux_cmd_ev_match_val_0_crypto_config,
  input                                         w_load_aux_cmd_ev_mask_val_0_comp_config,
  input                                         w_load_aux_cmd_ev_mask_val_0_crypto_config,
  input                                         w_load_aux_cmd_ev_match_val_1_comp_config,
  input                                         w_load_aux_cmd_ev_match_val_1_crypto_config,
  input                                         w_load_aux_cmd_ev_mask_val_1_comp_config,
  input                                         w_load_aux_cmd_ev_mask_val_1_crypto_config,
  input                                         w_load_aux_cmd_ev_match_val_2_comp_config,
  input                                         w_load_aux_cmd_ev_match_val_2_crypto_config,
  input                                         w_load_aux_cmd_ev_mask_val_2_comp_config,
  input                                         w_load_aux_cmd_ev_mask_val_2_crypto_config,
  input                                         w_load_aux_cmd_ev_match_val_3_comp_config,
  input                                         w_load_aux_cmd_ev_match_val_3_crypto_config,
  input                                         w_load_aux_cmd_ev_mask_val_3_comp_config,
  input                                         w_load_aux_cmd_ev_mask_val_3_crypto_config,
  input                                         w_load_isf_fifo_ia_wdata_part0,
  input                                         w_load_isf_fifo_ia_wdata_part1,
  input                                         w_load_isf_fifo_ia_wdata_part2,
  input                                         w_load_isf_fifo_ia_config,
  input                                         w_load_ib_agg_data_bytes_global_config,

  input      [31:0]                             f32_data
  );

  
  

  
  

  
  
  
  always_ff @(posedge clk or negedge i_reset_) begin
    if(~i_reset_) begin
      
      o_spare_config[31:00]                         <= 32'd0; 
      o_isf_tlv_parse_action_0[01:00]               <= 2'd2; 
      o_isf_tlv_parse_action_0[03:02]               <= 2'd2; 
      o_isf_tlv_parse_action_0[05:04]               <= 2'd2; 
      o_isf_tlv_parse_action_0[07:06]               <= 2'd2; 
      o_isf_tlv_parse_action_0[09:08]               <= 2'd2; 
      o_isf_tlv_parse_action_0[11:10]               <= 2'd2; 
      o_isf_tlv_parse_action_0[13:12]               <= 2'd2; 
      o_isf_tlv_parse_action_0[15:14]               <= 2'd2; 
      o_isf_tlv_parse_action_0[17:16]               <= 2'd2; 
      o_isf_tlv_parse_action_0[19:18]               <= 2'd2; 
      o_isf_tlv_parse_action_0[21:20]               <= 2'd2; 
      o_isf_tlv_parse_action_0[23:22]               <= 2'd2; 
      o_isf_tlv_parse_action_0[25:24]               <= 2'd2; 
      o_isf_tlv_parse_action_0[27:26]               <= 2'd2; 
      o_isf_tlv_parse_action_0[29:28]               <= 2'd2; 
      o_isf_tlv_parse_action_0[31:30]               <= 2'd2; 
      o_isf_tlv_parse_action_1[01:00]               <= 2'd2; 
      o_isf_tlv_parse_action_1[03:02]               <= 2'd2; 
      o_isf_tlv_parse_action_1[05:04]               <= 2'd2; 
      o_isf_tlv_parse_action_1[07:06]               <= 2'd2; 
      o_isf_tlv_parse_action_1[09:08]               <= 2'd2; 
      o_isf_tlv_parse_action_1[11:10]               <= 2'd2; 
      o_isf_tlv_parse_action_1[13:12]               <= 2'd2; 
      o_isf_tlv_parse_action_1[15:14]               <= 2'd2; 
      o_isf_tlv_parse_action_1[17:16]               <= 2'd2; 
      o_isf_tlv_parse_action_1[19:18]               <= 2'd2; 
      o_isf_tlv_parse_action_1[21:20]               <= 2'd2; 
      o_isf_tlv_parse_action_1[23:22]               <= 2'd2; 
      o_isf_tlv_parse_action_1[25:24]               <= 2'd2; 
      o_isf_tlv_parse_action_1[27:26]               <= 2'd2; 
      o_isf_tlv_parse_action_1[29:28]               <= 2'd2; 
      o_isf_tlv_parse_action_1[31:30]               <= 2'd2; 
      o_ctl_config[02:00]                           <= 3'd0; 
      o_ctl_config[05:03]                           <= 3'd0; 
      o_ctl_config[06:06]                           <= 1'd0; 
      o_ctl_config[07:07]                           <= 1'd0; 
      o_ctl_config[08:08]                           <= 1'd0; 
      o_ctl_config[09:09]                           <= 1'd0; 
      o_ctl_config[10:10]                           <= 1'd0; 
      o_system_stall_limit_config[31:00]            <= 32'd0; 
      o_debug_ctl_config[02:00]                     <= 3'd0; 
      o_debug_ctl_config[03:03]                     <= 1'd0; 
      o_debug_ctl_config[13:04]                     <= 10'd0; 
      o_debug_ctl_config[24:14]                     <= 11'd0; 
      o_debug_ctl_config[25:25]                     <= 1'd0; 
      o_debug_ctl_config[26:26]                     <= 1'd0; 
      o_debug_ss_ctl_config[00:00]                  <= 1'd0; 
      o_debug_trig_tlv_config[07:00]                <= 8'd0; 
      o_debug_trig_tlv_config[28:08]                <= 21'd0; 
      o_debug_trig_match_lo_config[31:00]           <= 32'd0; 
      o_debug_trig_match_hi_config[31:00]           <= 32'd0; 
      o_debug_trig_mask_lo_config[31:00]            <= 32'd0; 
      o_debug_trig_mask_hi_config[31:00]            <= 32'd0; 
      o_trace_ctl_en_config[00:00]                  <= 1'd0; 
      o_trace_ctl_limits_config[15:00]              <= 16'd0; 
      o_trace_ctl_limits_config[31:16]              <= 16'd65535; 
      o_aux_cmd_ev_match_val_0_comp_config[31:00]   <= 32'd0; 
      o_aux_cmd_ev_match_val_0_crypto_config[31:00] <= 32'd0; 
      o_aux_cmd_ev_mask_val_0_comp_config[31:00]    <= 32'd0; 
      o_aux_cmd_ev_mask_val_0_crypto_config[31:00]  <= 32'd0; 
      o_aux_cmd_ev_match_val_1_comp_config[31:00]   <= 32'd0; 
      o_aux_cmd_ev_match_val_1_crypto_config[31:00] <= 32'd0; 
      o_aux_cmd_ev_mask_val_1_comp_config[31:00]    <= 32'd0; 
      o_aux_cmd_ev_mask_val_1_crypto_config[31:00]  <= 32'd0; 
      o_aux_cmd_ev_match_val_2_comp_config[31:00]   <= 32'd0; 
      o_aux_cmd_ev_match_val_2_crypto_config[31:00] <= 32'd0; 
      o_aux_cmd_ev_mask_val_2_comp_config[31:00]    <= 32'd0; 
      o_aux_cmd_ev_mask_val_2_crypto_config[31:00]  <= 32'd0; 
      o_aux_cmd_ev_match_val_3_comp_config[31:00]   <= 32'd0; 
      o_aux_cmd_ev_match_val_3_crypto_config[31:00] <= 32'd0; 
      o_aux_cmd_ev_mask_val_3_comp_config[31:00]    <= 32'd0; 
      o_aux_cmd_ev_mask_val_3_crypto_config[31:00]  <= 32'd0; 
      o_isf_fifo_ia_wdata_part0[31:00]              <= 32'd0; 
      o_isf_fifo_ia_wdata_part1[31:00]              <= 32'd0; 
      o_isf_fifo_ia_wdata_part2[00:00]              <= 1'd0; 
      o_isf_fifo_ia_config[09:00]                   <= 10'd0; 
      o_isf_fifo_ia_config[13:10]                   <= 4'd0; 
      o_ib_agg_data_bytes_global_config[00:00]      <= 1'd0; 
    end
    else if(i_sw_init) begin
      
      o_spare_config[31:00]                         <= 32'd0; 
      o_isf_tlv_parse_action_0[01:00]               <= 2'd2; 
      o_isf_tlv_parse_action_0[03:02]               <= 2'd2; 
      o_isf_tlv_parse_action_0[05:04]               <= 2'd2; 
      o_isf_tlv_parse_action_0[07:06]               <= 2'd2; 
      o_isf_tlv_parse_action_0[09:08]               <= 2'd2; 
      o_isf_tlv_parse_action_0[11:10]               <= 2'd2; 
      o_isf_tlv_parse_action_0[13:12]               <= 2'd2; 
      o_isf_tlv_parse_action_0[15:14]               <= 2'd2; 
      o_isf_tlv_parse_action_0[17:16]               <= 2'd2; 
      o_isf_tlv_parse_action_0[19:18]               <= 2'd2; 
      o_isf_tlv_parse_action_0[21:20]               <= 2'd2; 
      o_isf_tlv_parse_action_0[23:22]               <= 2'd2; 
      o_isf_tlv_parse_action_0[25:24]               <= 2'd2; 
      o_isf_tlv_parse_action_0[27:26]               <= 2'd2; 
      o_isf_tlv_parse_action_0[29:28]               <= 2'd2; 
      o_isf_tlv_parse_action_0[31:30]               <= 2'd2; 
      o_isf_tlv_parse_action_1[01:00]               <= 2'd2; 
      o_isf_tlv_parse_action_1[03:02]               <= 2'd2; 
      o_isf_tlv_parse_action_1[05:04]               <= 2'd2; 
      o_isf_tlv_parse_action_1[07:06]               <= 2'd2; 
      o_isf_tlv_parse_action_1[09:08]               <= 2'd2; 
      o_isf_tlv_parse_action_1[11:10]               <= 2'd2; 
      o_isf_tlv_parse_action_1[13:12]               <= 2'd2; 
      o_isf_tlv_parse_action_1[15:14]               <= 2'd2; 
      o_isf_tlv_parse_action_1[17:16]               <= 2'd2; 
      o_isf_tlv_parse_action_1[19:18]               <= 2'd2; 
      o_isf_tlv_parse_action_1[21:20]               <= 2'd2; 
      o_isf_tlv_parse_action_1[23:22]               <= 2'd2; 
      o_isf_tlv_parse_action_1[25:24]               <= 2'd2; 
      o_isf_tlv_parse_action_1[27:26]               <= 2'd2; 
      o_isf_tlv_parse_action_1[29:28]               <= 2'd2; 
      o_isf_tlv_parse_action_1[31:30]               <= 2'd2; 
      o_ctl_config[02:00]                           <= 3'd0; 
      o_ctl_config[05:03]                           <= 3'd0; 
      o_ctl_config[06:06]                           <= 1'd0; 
      o_ctl_config[07:07]                           <= 1'd0; 
      o_ctl_config[08:08]                           <= 1'd0; 
      o_ctl_config[09:09]                           <= 1'd0; 
      o_ctl_config[10:10]                           <= 1'd0; 
      o_system_stall_limit_config[31:00]            <= 32'd0; 
      o_debug_ctl_config[02:00]                     <= 3'd0; 
      o_debug_ctl_config[03:03]                     <= 1'd0; 
      o_debug_ctl_config[13:04]                     <= 10'd0; 
      o_debug_ctl_config[24:14]                     <= 11'd0; 
      o_debug_ctl_config[25:25]                     <= 1'd0; 
      o_debug_ctl_config[26:26]                     <= 1'd0; 
      o_debug_ss_ctl_config[00:00]                  <= 1'd0; 
      o_debug_trig_tlv_config[07:00]                <= 8'd0; 
      o_debug_trig_tlv_config[28:08]                <= 21'd0; 
      o_debug_trig_match_lo_config[31:00]           <= 32'd0; 
      o_debug_trig_match_hi_config[31:00]           <= 32'd0; 
      o_debug_trig_mask_lo_config[31:00]            <= 32'd0; 
      o_debug_trig_mask_hi_config[31:00]            <= 32'd0; 
      o_trace_ctl_en_config[00:00]                  <= 1'd0; 
      o_trace_ctl_limits_config[15:00]              <= 16'd0; 
      o_trace_ctl_limits_config[31:16]              <= 16'd65535; 
      o_aux_cmd_ev_match_val_0_comp_config[31:00]   <= 32'd0; 
      o_aux_cmd_ev_match_val_0_crypto_config[31:00] <= 32'd0; 
      o_aux_cmd_ev_mask_val_0_comp_config[31:00]    <= 32'd0; 
      o_aux_cmd_ev_mask_val_0_crypto_config[31:00]  <= 32'd0; 
      o_aux_cmd_ev_match_val_1_comp_config[31:00]   <= 32'd0; 
      o_aux_cmd_ev_match_val_1_crypto_config[31:00] <= 32'd0; 
      o_aux_cmd_ev_mask_val_1_comp_config[31:00]    <= 32'd0; 
      o_aux_cmd_ev_mask_val_1_crypto_config[31:00]  <= 32'd0; 
      o_aux_cmd_ev_match_val_2_comp_config[31:00]   <= 32'd0; 
      o_aux_cmd_ev_match_val_2_crypto_config[31:00] <= 32'd0; 
      o_aux_cmd_ev_mask_val_2_comp_config[31:00]    <= 32'd0; 
      o_aux_cmd_ev_mask_val_2_crypto_config[31:00]  <= 32'd0; 
      o_aux_cmd_ev_match_val_3_comp_config[31:00]   <= 32'd0; 
      o_aux_cmd_ev_match_val_3_crypto_config[31:00] <= 32'd0; 
      o_aux_cmd_ev_mask_val_3_comp_config[31:00]    <= 32'd0; 
      o_aux_cmd_ev_mask_val_3_crypto_config[31:00]  <= 32'd0; 
      o_isf_fifo_ia_wdata_part0[31:00]              <= 32'd0; 
      o_isf_fifo_ia_wdata_part1[31:00]              <= 32'd0; 
      o_isf_fifo_ia_wdata_part2[00:00]              <= 1'd0; 
      o_isf_fifo_ia_config[09:00]                   <= 10'd0; 
      o_isf_fifo_ia_config[13:10]                   <= 4'd0; 
      o_ib_agg_data_bytes_global_config[00:00]      <= 1'd0; 
    end
    else begin
      if(w_load_spare_config)                         o_spare_config[31:00]                         <= f32_data[31:00]; 
      if(w_load_isf_tlv_parse_action_0)               o_isf_tlv_parse_action_0[01:00]               <= f32_data[01:00]; 
      if(w_load_isf_tlv_parse_action_0)               o_isf_tlv_parse_action_0[03:02]               <= f32_data[03:02]; 
      if(w_load_isf_tlv_parse_action_0)               o_isf_tlv_parse_action_0[05:04]               <= f32_data[05:04]; 
      if(w_load_isf_tlv_parse_action_0)               o_isf_tlv_parse_action_0[07:06]               <= f32_data[07:06]; 
      if(w_load_isf_tlv_parse_action_0)               o_isf_tlv_parse_action_0[09:08]               <= f32_data[09:08]; 
      if(w_load_isf_tlv_parse_action_0)               o_isf_tlv_parse_action_0[11:10]               <= f32_data[11:10]; 
      if(w_load_isf_tlv_parse_action_0)               o_isf_tlv_parse_action_0[13:12]               <= f32_data[13:12]; 
      if(w_load_isf_tlv_parse_action_0)               o_isf_tlv_parse_action_0[15:14]               <= f32_data[15:14]; 
      if(w_load_isf_tlv_parse_action_0)               o_isf_tlv_parse_action_0[17:16]               <= f32_data[17:16]; 
      if(w_load_isf_tlv_parse_action_0)               o_isf_tlv_parse_action_0[19:18]               <= f32_data[19:18]; 
      if(w_load_isf_tlv_parse_action_0)               o_isf_tlv_parse_action_0[21:20]               <= f32_data[21:20]; 
      if(w_load_isf_tlv_parse_action_0)               o_isf_tlv_parse_action_0[23:22]               <= f32_data[23:22]; 
      if(w_load_isf_tlv_parse_action_0)               o_isf_tlv_parse_action_0[25:24]               <= f32_data[25:24]; 
      if(w_load_isf_tlv_parse_action_0)               o_isf_tlv_parse_action_0[27:26]               <= f32_data[27:26]; 
      if(w_load_isf_tlv_parse_action_0)               o_isf_tlv_parse_action_0[29:28]               <= f32_data[29:28]; 
      if(w_load_isf_tlv_parse_action_0)               o_isf_tlv_parse_action_0[31:30]               <= f32_data[31:30]; 
      if(w_load_isf_tlv_parse_action_1)               o_isf_tlv_parse_action_1[01:00]               <= f32_data[01:00]; 
      if(w_load_isf_tlv_parse_action_1)               o_isf_tlv_parse_action_1[03:02]               <= f32_data[03:02]; 
      if(w_load_isf_tlv_parse_action_1)               o_isf_tlv_parse_action_1[05:04]               <= f32_data[05:04]; 
      if(w_load_isf_tlv_parse_action_1)               o_isf_tlv_parse_action_1[07:06]               <= f32_data[07:06]; 
      if(w_load_isf_tlv_parse_action_1)               o_isf_tlv_parse_action_1[09:08]               <= f32_data[09:08]; 
      if(w_load_isf_tlv_parse_action_1)               o_isf_tlv_parse_action_1[11:10]               <= f32_data[11:10]; 
      if(w_load_isf_tlv_parse_action_1)               o_isf_tlv_parse_action_1[13:12]               <= f32_data[13:12]; 
      if(w_load_isf_tlv_parse_action_1)               o_isf_tlv_parse_action_1[15:14]               <= f32_data[15:14]; 
      if(w_load_isf_tlv_parse_action_1)               o_isf_tlv_parse_action_1[17:16]               <= f32_data[17:16]; 
      if(w_load_isf_tlv_parse_action_1)               o_isf_tlv_parse_action_1[19:18]               <= f32_data[19:18]; 
      if(w_load_isf_tlv_parse_action_1)               o_isf_tlv_parse_action_1[21:20]               <= f32_data[21:20]; 
      if(w_load_isf_tlv_parse_action_1)               o_isf_tlv_parse_action_1[23:22]               <= f32_data[23:22]; 
      if(w_load_isf_tlv_parse_action_1)               o_isf_tlv_parse_action_1[25:24]               <= f32_data[25:24]; 
      if(w_load_isf_tlv_parse_action_1)               o_isf_tlv_parse_action_1[27:26]               <= f32_data[27:26]; 
      if(w_load_isf_tlv_parse_action_1)               o_isf_tlv_parse_action_1[29:28]               <= f32_data[29:28]; 
      if(w_load_isf_tlv_parse_action_1)               o_isf_tlv_parse_action_1[31:30]               <= f32_data[31:30]; 
      if(w_load_ctl_config)                           o_ctl_config[02:00]                           <= f32_data[02:00]; 
      if(w_load_ctl_config)                           o_ctl_config[05:03]                           <= f32_data[05:03]; 
      if(w_load_ctl_config)                           o_ctl_config[06:06]                           <= f32_data[08:08]; 
      if(w_load_ctl_config)                           o_ctl_config[07:07]                           <= f32_data[12:12]; 
      if(w_load_ctl_config)                           o_ctl_config[08:08]                           <= f32_data[13:13]; 
      if(w_load_ctl_config)                           o_ctl_config[09:09]                           <= f32_data[14:14]; 
      if(w_load_ctl_config)                           o_ctl_config[10:10]                           <= f32_data[15:15]; 
      if(w_load_system_stall_limit_config)            o_system_stall_limit_config[31:00]            <= f32_data[31:00]; 
      if(w_load_debug_ctl_config)                     o_debug_ctl_config[02:00]                     <= f32_data[02:00]; 
      if(w_load_debug_ctl_config)                     o_debug_ctl_config[03:03]                     <= f32_data[03:03]; 
      if(w_load_debug_ctl_config)                     o_debug_ctl_config[13:04]                     <= f32_data[13:04]; 
      if(w_load_debug_ctl_config)                     o_debug_ctl_config[24:14]                     <= f32_data[26:16]; 
      if(w_load_debug_ctl_config)                     o_debug_ctl_config[25:25]                     <= f32_data[28:28]; 
      if(w_load_debug_ctl_config)                     o_debug_ctl_config[26:26]                     <= f32_data[31:31]; 
      if(w_load_debug_ss_ctl_config)                  o_debug_ss_ctl_config[00:00]                  <= f32_data[00:00]; 
      if(w_load_debug_trig_tlv_config)                o_debug_trig_tlv_config[07:00]                <= f32_data[07:00]; 
      if(w_load_debug_trig_tlv_config)                o_debug_trig_tlv_config[28:08]                <= f32_data[28:08]; 
      if(w_load_debug_trig_match_lo_config)           o_debug_trig_match_lo_config[31:00]           <= f32_data[31:00]; 
      if(w_load_debug_trig_match_hi_config)           o_debug_trig_match_hi_config[31:00]           <= f32_data[31:00]; 
      if(w_load_debug_trig_mask_lo_config)            o_debug_trig_mask_lo_config[31:00]            <= f32_data[31:00]; 
      if(w_load_debug_trig_mask_hi_config)            o_debug_trig_mask_hi_config[31:00]            <= f32_data[31:00]; 
      if(w_load_trace_ctl_en_config)                  o_trace_ctl_en_config[00:00]                  <= f32_data[00:00]; 
      if(w_load_trace_ctl_limits_config)              o_trace_ctl_limits_config[15:00]              <= f32_data[15:00]; 
      if(w_load_trace_ctl_limits_config)              o_trace_ctl_limits_config[31:16]              <= f32_data[31:16]; 
      if(w_load_aux_cmd_ev_match_val_0_comp_config)   o_aux_cmd_ev_match_val_0_comp_config[31:00]   <= f32_data[31:00]; 
      if(w_load_aux_cmd_ev_match_val_0_crypto_config) o_aux_cmd_ev_match_val_0_crypto_config[31:00] <= f32_data[31:00]; 
      if(w_load_aux_cmd_ev_mask_val_0_comp_config)    o_aux_cmd_ev_mask_val_0_comp_config[31:00]    <= f32_data[31:00]; 
      if(w_load_aux_cmd_ev_mask_val_0_crypto_config)  o_aux_cmd_ev_mask_val_0_crypto_config[31:00]  <= f32_data[31:00]; 
      if(w_load_aux_cmd_ev_match_val_1_comp_config)   o_aux_cmd_ev_match_val_1_comp_config[31:00]   <= f32_data[31:00]; 
      if(w_load_aux_cmd_ev_match_val_1_crypto_config) o_aux_cmd_ev_match_val_1_crypto_config[31:00] <= f32_data[31:00]; 
      if(w_load_aux_cmd_ev_mask_val_1_comp_config)    o_aux_cmd_ev_mask_val_1_comp_config[31:00]    <= f32_data[31:00]; 
      if(w_load_aux_cmd_ev_mask_val_1_crypto_config)  o_aux_cmd_ev_mask_val_1_crypto_config[31:00]  <= f32_data[31:00]; 
      if(w_load_aux_cmd_ev_match_val_2_comp_config)   o_aux_cmd_ev_match_val_2_comp_config[31:00]   <= f32_data[31:00]; 
      if(w_load_aux_cmd_ev_match_val_2_crypto_config) o_aux_cmd_ev_match_val_2_crypto_config[31:00] <= f32_data[31:00]; 
      if(w_load_aux_cmd_ev_mask_val_2_comp_config)    o_aux_cmd_ev_mask_val_2_comp_config[31:00]    <= f32_data[31:00]; 
      if(w_load_aux_cmd_ev_mask_val_2_crypto_config)  o_aux_cmd_ev_mask_val_2_crypto_config[31:00]  <= f32_data[31:00]; 
      if(w_load_aux_cmd_ev_match_val_3_comp_config)   o_aux_cmd_ev_match_val_3_comp_config[31:00]   <= f32_data[31:00]; 
      if(w_load_aux_cmd_ev_match_val_3_crypto_config) o_aux_cmd_ev_match_val_3_crypto_config[31:00] <= f32_data[31:00]; 
      if(w_load_aux_cmd_ev_mask_val_3_comp_config)    o_aux_cmd_ev_mask_val_3_comp_config[31:00]    <= f32_data[31:00]; 
      if(w_load_aux_cmd_ev_mask_val_3_crypto_config)  o_aux_cmd_ev_mask_val_3_crypto_config[31:00]  <= f32_data[31:00]; 
      if(w_load_isf_fifo_ia_wdata_part0)              o_isf_fifo_ia_wdata_part0[31:00]              <= f32_data[31:00]; 
      if(w_load_isf_fifo_ia_wdata_part1)              o_isf_fifo_ia_wdata_part1[31:00]              <= f32_data[31:00]; 
      if(w_load_isf_fifo_ia_wdata_part2)              o_isf_fifo_ia_wdata_part2[00:00]              <= f32_data[00:00]; 
      if(w_load_isf_fifo_ia_config)                   o_isf_fifo_ia_config[09:00]                   <= f32_data[09:00]; 
      if(w_load_isf_fifo_ia_config)                   o_isf_fifo_ia_config[13:10]                   <= f32_data[31:28]; 
      if(w_load_ib_agg_data_bytes_global_config)      o_ib_agg_data_bytes_global_config[00:00]      <= f32_data[00:00]; 
    end
  end

  
  
  
  always_ff @(posedge clk) begin
      if(w_load_isf_fifo_ia_wdata_part2)              o_isf_fifo_ia_wdata_part2[03:01]              <= f32_data[03:01]; 
      if(w_load_isf_fifo_ia_wdata_part2)              o_isf_fifo_ia_wdata_part2[11:04]              <= f32_data[11:04]; 
      if(w_load_isf_fifo_ia_wdata_part2)              o_isf_fifo_ia_wdata_part2[19:12]              <= f32_data[19:12]; 
      if(w_load_isf_fifo_ia_wdata_part2)              o_isf_fifo_ia_wdata_part2[20:20]              <= f32_data[20:20]; 
  end
  

  

endmodule
