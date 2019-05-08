/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











`include "cr_osf.vh"




module cr_osf_regs (
  input                                    clk,
  input                                    i_reset_,
  input                                    i_sw_init,

  
  input      [`CR_OSF_DECL]                i_addr,
  input                                    i_wr_strb,
  input      [31:0]                        i_wr_data,
  input                                    i_rd_strb,
  output     [31:0]                        o_rd_data,
  output                                   o_ack,
  output                                   o_err_ack,

  
  output     [`CR_OSF_C_SPARE_T_DECL]      o_spare_config,
  output     [`CR_OSF_C_OSF_TLV_PARSE_ACTION_31_0_T_DECL] o_osf_tlv_parse_action_0,
  output     [`CR_OSF_C_OSF_TLV_PARSE_ACTION_63_32_T_DECL] o_osf_tlv_parse_action_1,
  output     [`CR_OSF_C_DEBUG_CTL_T_DECL]  o_debug_ctl_config,
  output     [`CR_OSF_C_DATA_FIFO_DEBUG_CTL_T_DECL] o_data_fifo_debug_ctl_config,
  output     [`CR_OSF_C_DATA_FIFO_DEBUG_SS_CTL_T_DECL] o_data_fifo_debug_ss_ctl_config,
  output     [`CR_OSF_C_PDT_FIFO_DEBUG_CTL_T_DECL] o_pdt_fifo_debug_ctl_config,
  output     [`CR_OSF_C_PDT_FIFO_DEBUG_SS_CTL_T_DECL] o_pdt_fifo_debug_ss_ctl_config,
  output     [`CR_OSF_C_OSF_DATA_FIFO_PART0_T_DECL] o_osf_data_fifo_ia_wdata_part0,
  output     [`CR_OSF_C_OSF_DATA_FIFO_PART1_T_DECL] o_osf_data_fifo_ia_wdata_part1,
  output     [`CR_OSF_C_OSF_DATA_FIFO_PART2_T_DECL] o_osf_data_fifo_ia_wdata_part2,
  output     [`CR_OSF_C_OSF_DATA_FIFO_IA_CONFIG_T_DECL] o_osf_data_fifo_ia_config,
  output     [`CR_OSF_C_OSF_PDT_FIFO_PART0_T_DECL] o_osf_pdt_fifo_ia_wdata_part0,
  output     [`CR_OSF_C_OSF_PDT_FIFO_PART1_T_DECL] o_osf_pdt_fifo_ia_wdata_part1,
  output     [`CR_OSF_C_OSF_PDT_FIFO_PART2_T_DECL] o_osf_pdt_fifo_ia_wdata_part2,
  output     [`CR_OSF_C_OSF_PDT_FIFO_IA_CONFIG_T_DECL] o_osf_pdt_fifo_ia_config,
  output     [`CR_OSF_C_OB_AGG_DATA_BYTES_GLOBAL_CONFIG_T_DECL] o_ob_agg_data_bytes_global_config,
  output     [`CR_OSF_C_OB_AGG_FRAME_GLOBAL_CONFIG_T_DECL] o_ob_agg_frame_global_config,

  
  input      [`CR_OSF_C_REVID_T_DECL]      i_revision_config,
  input      [`CR_OSF_C_SPARE_T_DECL]      i_spare_config,
  input      [`CR_OSF_C_DATA_FIFO_DEBUG_STAT_T_DECL] i_data_fifo_debug_stat,
  input      [`CR_OSF_C_PDT_FIFO_DEBUG_STAT_T_DECL] i_pdt_fifo_debug_stat,
  input      [`CR_OSF_C_OSF_DATA_FIFO_IA_CAPABILITY_T_DECL] i_osf_data_fifo_ia_capability,
  input      [`CR_OSF_C_OSF_DATA_FIFO_IA_STATUS_T_DECL] i_osf_data_fifo_ia_status,
  input      [`CR_OSF_C_OSF_DATA_FIFO_PART0_T_DECL] i_osf_data_fifo_ia_rdata_part0,
  input      [`CR_OSF_C_OSF_DATA_FIFO_PART1_T_DECL] i_osf_data_fifo_ia_rdata_part1,
  input      [`CR_OSF_C_OSF_DATA_FIFO_PART2_T_DECL] i_osf_data_fifo_ia_rdata_part2,
  input      [`CR_OSF_C_OSF_DATA_FIFO_FIFO_STATUS_0_T_DECL] i_osf_data_fifo_fifo_status_0,
  input      [`CR_OSF_C_OSF_DATA_FIFO_FIFO_STATUS_1_T_DECL] i_osf_data_fifo_fifo_status_1,
  input      [`CR_OSF_C_OSF_PDT_FIFO_IA_CAPABILITY_T_DECL] i_osf_pdt_fifo_ia_capability,
  input      [`CR_OSF_C_OSF_PDT_FIFO_IA_STATUS_T_DECL] i_osf_pdt_fifo_ia_status,
  input      [`CR_OSF_C_OSF_PDT_FIFO_PART0_T_DECL] i_osf_pdt_fifo_ia_rdata_part0,
  input      [`CR_OSF_C_OSF_PDT_FIFO_PART1_T_DECL] i_osf_pdt_fifo_ia_rdata_part1,
  input      [`CR_OSF_C_OSF_PDT_FIFO_PART2_T_DECL] i_osf_pdt_fifo_ia_rdata_part2,
  input      [`CR_OSF_C_OSF_PDT_FIFO_FIFO_STATUS_0_T_DECL] i_osf_pdt_fifo_fifo_status_0,
  input      [`CR_OSF_C_OSF_PDT_FIFO_FIFO_STATUS_1_T_DECL] i_osf_pdt_fifo_fifo_status_1,
  input      [`CR_OSF_C_OB_AGG_DATA_BYTES_0_COUNTER_PART0_T_DECL] i_ob_agg_data_bytes_0_count_part0_a,
  input      [`CR_OSF_C_OB_AGG_DATA_BYTES_0_COUNTER_PART1_T_DECL] i_ob_agg_data_bytes_0_count_part1_a,
  input      [`CR_OSF_C_OB_AGG_DATA_BYTES_GLOBAL_READ_T_DECL] i_ob_agg_data_bytes_global_read,
  input      [`CR_OSF_C_OB_AGG_FRAME_0_COUNTER_PART0_T_DECL] i_ob_agg_frame_0_count_part0_a,
  input      [`CR_OSF_C_OB_AGG_FRAME_0_COUNTER_PART1_T_DECL] i_ob_agg_frame_0_count_part1_a,
  input      [`CR_OSF_C_OB_AGG_FRAME_GLOBAL_READ_T_DECL] i_ob_agg_frame_global_read,

  
  output reg                               o_reg_written,
  output reg                               o_reg_read,
  output     [31:0]                        o_reg_wr_data,
  output reg [`CR_OSF_DECL]                o_reg_addr
  );


  


  
  


  
  wire [`CR_OSF_DECL] ws_read_addr    = o_reg_addr;
  wire [`CR_OSF_DECL] ws_addr         = o_reg_addr;
  

  wire n_wr_strobe = i_wr_strb;
  wire n_rd_strobe = i_rd_strb;

  wire w_32b_aligned    = (o_reg_addr[1:0] == 2'h0);

  wire w_valid_rd_addr     = (w_32b_aligned && (ws_addr >= `CR_OSF_REVISION_CONFIG) && (ws_addr <= `CR_OSF_SPARE_CONFIG))
                          || (w_32b_aligned && (ws_addr >= `CR_OSF_OSF_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_OSF_OSF_DATA_FIFO_IA_RDATA_PART2))
                          || (w_32b_aligned && (ws_addr >= `CR_OSF_OSF_DATA_FIFO_FIFO_STATUS_0) && (ws_addr <= `CR_OSF_OSF_PDT_FIFO_IA_RDATA_PART2))
                          || (w_32b_aligned && (ws_addr >= `CR_OSF_OSF_PDT_FIFO_FIFO_STATUS_0) && (ws_addr <= `CR_OSF_OB_AGG_FRAME_GLOBAL_CONFIG));

  wire w_valid_wr_addr     = (w_32b_aligned && (ws_addr >= `CR_OSF_REVISION_CONFIG) && (ws_addr <= `CR_OSF_SPARE_CONFIG))
                          || (w_32b_aligned && (ws_addr >= `CR_OSF_OSF_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_OSF_OSF_DATA_FIFO_IA_RDATA_PART2))
                          || (w_32b_aligned && (ws_addr >= `CR_OSF_OSF_DATA_FIFO_FIFO_STATUS_0) && (ws_addr <= `CR_OSF_OSF_PDT_FIFO_IA_RDATA_PART2))
                          || (w_32b_aligned && (ws_addr >= `CR_OSF_OSF_PDT_FIFO_FIFO_STATUS_0) && (ws_addr <= `CR_OSF_OB_AGG_FRAME_GLOBAL_CONFIG));

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
    `CR_OSF_REVISION_CONFIG: begin
      r32_mux_0_data[07:00] = i_revision_config[07:00]; 
    end
    `CR_OSF_SPARE_CONFIG: begin
      r32_mux_0_data[31:00] = i_spare_config[31:00]; 
    end
    `CR_OSF_OSF_TLV_PARSE_ACTION_0: begin
      r32_mux_0_data[01:00] = o_osf_tlv_parse_action_0[01:00]; 
      r32_mux_0_data[03:02] = o_osf_tlv_parse_action_0[03:02]; 
      r32_mux_0_data[05:04] = o_osf_tlv_parse_action_0[05:04]; 
      r32_mux_0_data[07:06] = o_osf_tlv_parse_action_0[07:06]; 
      r32_mux_0_data[09:08] = o_osf_tlv_parse_action_0[09:08]; 
      r32_mux_0_data[11:10] = o_osf_tlv_parse_action_0[11:10]; 
      r32_mux_0_data[13:12] = o_osf_tlv_parse_action_0[13:12]; 
      r32_mux_0_data[15:14] = o_osf_tlv_parse_action_0[15:14]; 
      r32_mux_0_data[17:16] = o_osf_tlv_parse_action_0[17:16]; 
      r32_mux_0_data[19:18] = o_osf_tlv_parse_action_0[19:18]; 
      r32_mux_0_data[21:20] = o_osf_tlv_parse_action_0[21:20]; 
      r32_mux_0_data[23:22] = o_osf_tlv_parse_action_0[23:22]; 
      r32_mux_0_data[25:24] = o_osf_tlv_parse_action_0[25:24]; 
      r32_mux_0_data[27:26] = o_osf_tlv_parse_action_0[27:26]; 
      r32_mux_0_data[29:28] = o_osf_tlv_parse_action_0[29:28]; 
      r32_mux_0_data[31:30] = o_osf_tlv_parse_action_0[31:30]; 
    end
    `CR_OSF_OSF_TLV_PARSE_ACTION_1: begin
      r32_mux_0_data[01:00] = o_osf_tlv_parse_action_1[01:00]; 
      r32_mux_0_data[03:02] = o_osf_tlv_parse_action_1[03:02]; 
      r32_mux_0_data[05:04] = o_osf_tlv_parse_action_1[05:04]; 
      r32_mux_0_data[07:06] = o_osf_tlv_parse_action_1[07:06]; 
      r32_mux_0_data[09:08] = o_osf_tlv_parse_action_1[09:08]; 
      r32_mux_0_data[11:10] = o_osf_tlv_parse_action_1[11:10]; 
      r32_mux_0_data[13:12] = o_osf_tlv_parse_action_1[13:12]; 
      r32_mux_0_data[15:14] = o_osf_tlv_parse_action_1[15:14]; 
      r32_mux_0_data[17:16] = o_osf_tlv_parse_action_1[17:16]; 
      r32_mux_0_data[19:18] = o_osf_tlv_parse_action_1[19:18]; 
      r32_mux_0_data[21:20] = o_osf_tlv_parse_action_1[21:20]; 
      r32_mux_0_data[23:22] = o_osf_tlv_parse_action_1[23:22]; 
      r32_mux_0_data[25:24] = o_osf_tlv_parse_action_1[25:24]; 
      r32_mux_0_data[27:26] = o_osf_tlv_parse_action_1[27:26]; 
      r32_mux_0_data[29:28] = o_osf_tlv_parse_action_1[29:28]; 
      r32_mux_0_data[31:30] = o_osf_tlv_parse_action_1[31:30]; 
    end
    `CR_OSF_DEBUG_CTL_CONFIG: begin
      r32_mux_0_data[01:00] = o_debug_ctl_config[01:00]; 
      r32_mux_0_data[02:02] = o_debug_ctl_config[02:02]; 
      r32_mux_0_data[03:03] = o_debug_ctl_config[03:03]; 
      r32_mux_0_data[04:04] = o_debug_ctl_config[04:04]; 
    end
    `CR_OSF_DATA_FIFO_DEBUG_CTL_CONFIG: begin
      r32_mux_0_data[01:00] = o_data_fifo_debug_ctl_config[01:00]; 
      r32_mux_0_data[02:02] = o_data_fifo_debug_ctl_config[02:02]; 
      r32_mux_0_data[12:04] = o_data_fifo_debug_ctl_config[11:03]; 
      r32_mux_0_data[25:16] = o_data_fifo_debug_ctl_config[21:12]; 
      r32_mux_0_data[31:31] = o_data_fifo_debug_ctl_config[22:22]; 
    end
    `CR_OSF_DATA_FIFO_DEBUG_SS_CTL_CONFIG: begin
      r32_mux_0_data[00:00] = o_data_fifo_debug_ss_ctl_config[00:00]; 
    end
    `CR_OSF_DATA_FIFO_DEBUG_STAT: begin
      r32_mux_0_data[00:00] = i_data_fifo_debug_stat[00:00]; 
    end
    `CR_OSF_PDT_FIFO_DEBUG_CTL_CONFIG: begin
      r32_mux_0_data[01:00] = o_pdt_fifo_debug_ctl_config[01:00]; 
      r32_mux_0_data[02:02] = o_pdt_fifo_debug_ctl_config[02:02]; 
      r32_mux_0_data[11:04] = o_pdt_fifo_debug_ctl_config[10:03]; 
      r32_mux_0_data[20:12] = o_pdt_fifo_debug_ctl_config[19:11]; 
      r32_mux_0_data[31:31] = o_pdt_fifo_debug_ctl_config[20:20]; 
    end
    `CR_OSF_PDT_FIFO_DEBUG_SS_CTL_CONFIG: begin
      r32_mux_0_data[00:00] = o_pdt_fifo_debug_ss_ctl_config[00:00]; 
    end
    `CR_OSF_PDT_FIFO_DEBUG_STAT: begin
      r32_mux_0_data[00:00] = i_pdt_fifo_debug_stat[00:00]; 
    end
    `CR_OSF_OSF_DATA_FIFO_IA_CAPABILITY: begin
      r32_mux_0_data[00:00] = i_osf_data_fifo_ia_capability[00:00]; 
      r32_mux_0_data[01:01] = i_osf_data_fifo_ia_capability[01:01]; 
      r32_mux_0_data[02:02] = i_osf_data_fifo_ia_capability[02:02]; 
      r32_mux_0_data[03:03] = i_osf_data_fifo_ia_capability[03:03]; 
      r32_mux_0_data[04:04] = i_osf_data_fifo_ia_capability[04:04]; 
      r32_mux_0_data[05:05] = i_osf_data_fifo_ia_capability[05:05]; 
      r32_mux_0_data[06:06] = i_osf_data_fifo_ia_capability[06:06]; 
      r32_mux_0_data[07:07] = i_osf_data_fifo_ia_capability[07:07]; 
      r32_mux_0_data[08:08] = i_osf_data_fifo_ia_capability[08:08]; 
      r32_mux_0_data[09:09] = i_osf_data_fifo_ia_capability[09:09]; 
      r32_mux_0_data[13:10] = i_osf_data_fifo_ia_capability[13:10]; 
      r32_mux_0_data[14:14] = i_osf_data_fifo_ia_capability[14:14]; 
      r32_mux_0_data[15:15] = i_osf_data_fifo_ia_capability[15:15]; 
      r32_mux_0_data[31:28] = i_osf_data_fifo_ia_capability[19:16]; 
    end
    `CR_OSF_OSF_DATA_FIFO_IA_STATUS: begin
      r32_mux_0_data[08:00] = i_osf_data_fifo_ia_status[08:00]; 
      r32_mux_0_data[28:24] = i_osf_data_fifo_ia_status[13:09]; 
      r32_mux_0_data[31:29] = i_osf_data_fifo_ia_status[16:14]; 
    end
    `CR_OSF_OSF_DATA_FIFO_IA_WDATA_PART0: begin
      r32_mux_0_data[31:00] = o_osf_data_fifo_ia_wdata_part0[31:00]; 
    end
    `CR_OSF_OSF_DATA_FIFO_IA_WDATA_PART1: begin
      r32_mux_0_data[31:00] = o_osf_data_fifo_ia_wdata_part1[31:00]; 
    end
    `CR_OSF_OSF_DATA_FIFO_IA_WDATA_PART2: begin
      r32_mux_0_data[00:00] = o_osf_data_fifo_ia_wdata_part2[00:00]; 
      r32_mux_0_data[03:01] = o_osf_data_fifo_ia_wdata_part2[03:01]; 
      r32_mux_0_data[11:04] = o_osf_data_fifo_ia_wdata_part2[11:04]; 
      r32_mux_0_data[19:12] = o_osf_data_fifo_ia_wdata_part2[19:12]; 
      r32_mux_0_data[20:20] = o_osf_data_fifo_ia_wdata_part2[20:20]; 
    end
    `CR_OSF_OSF_DATA_FIFO_IA_CONFIG: begin
      r32_mux_0_data[08:00] = o_osf_data_fifo_ia_config[08:00]; 
      r32_mux_0_data[31:28] = o_osf_data_fifo_ia_config[12:09]; 
    end
    `CR_OSF_OSF_DATA_FIFO_IA_RDATA_PART0: begin
      r32_mux_0_data[31:00] = i_osf_data_fifo_ia_rdata_part0[31:00]; 
    end
    `CR_OSF_OSF_DATA_FIFO_IA_RDATA_PART1: begin
      r32_mux_0_data[31:00] = i_osf_data_fifo_ia_rdata_part1[31:00]; 
    end
    `CR_OSF_OSF_DATA_FIFO_IA_RDATA_PART2: begin
      r32_mux_0_data[00:00] = i_osf_data_fifo_ia_rdata_part2[00:00]; 
      r32_mux_0_data[03:01] = i_osf_data_fifo_ia_rdata_part2[03:01]; 
      r32_mux_0_data[11:04] = i_osf_data_fifo_ia_rdata_part2[11:04]; 
      r32_mux_0_data[19:12] = i_osf_data_fifo_ia_rdata_part2[19:12]; 
      r32_mux_0_data[20:20] = i_osf_data_fifo_ia_rdata_part2[20:20]; 
    end
    `CR_OSF_OSF_DATA_FIFO_FIFO_STATUS_0: begin
      r32_mux_0_data[08:00] = i_osf_data_fifo_fifo_status_0[08:00]; 
      r32_mux_0_data[24:16] = i_osf_data_fifo_fifo_status_0[17:09]; 
      r32_mux_0_data[28:28] = i_osf_data_fifo_fifo_status_0[18:18]; 
      r32_mux_0_data[29:29] = i_osf_data_fifo_fifo_status_0[19:19]; 
      r32_mux_0_data[30:30] = i_osf_data_fifo_fifo_status_0[20:20]; 
      r32_mux_0_data[31:31] = i_osf_data_fifo_fifo_status_0[21:21]; 
    end
    endcase

    case (ws_read_addr)
    `CR_OSF_OSF_DATA_FIFO_FIFO_STATUS_1: begin
      r32_mux_1_data[09:00] = i_osf_data_fifo_fifo_status_1[09:00]; 
    end
    `CR_OSF_OSF_PDT_FIFO_IA_CAPABILITY: begin
      r32_mux_1_data[00:00] = i_osf_pdt_fifo_ia_capability[00:00]; 
      r32_mux_1_data[01:01] = i_osf_pdt_fifo_ia_capability[01:01]; 
      r32_mux_1_data[02:02] = i_osf_pdt_fifo_ia_capability[02:02]; 
      r32_mux_1_data[03:03] = i_osf_pdt_fifo_ia_capability[03:03]; 
      r32_mux_1_data[04:04] = i_osf_pdt_fifo_ia_capability[04:04]; 
      r32_mux_1_data[05:05] = i_osf_pdt_fifo_ia_capability[05:05]; 
      r32_mux_1_data[06:06] = i_osf_pdt_fifo_ia_capability[06:06]; 
      r32_mux_1_data[07:07] = i_osf_pdt_fifo_ia_capability[07:07]; 
      r32_mux_1_data[08:08] = i_osf_pdt_fifo_ia_capability[08:08]; 
      r32_mux_1_data[09:09] = i_osf_pdt_fifo_ia_capability[09:09]; 
      r32_mux_1_data[13:10] = i_osf_pdt_fifo_ia_capability[13:10]; 
      r32_mux_1_data[14:14] = i_osf_pdt_fifo_ia_capability[14:14]; 
      r32_mux_1_data[15:15] = i_osf_pdt_fifo_ia_capability[15:15]; 
      r32_mux_1_data[31:28] = i_osf_pdt_fifo_ia_capability[19:16]; 
    end
    `CR_OSF_OSF_PDT_FIFO_IA_STATUS: begin
      r32_mux_1_data[07:00] = i_osf_pdt_fifo_ia_status[07:00]; 
      r32_mux_1_data[28:24] = i_osf_pdt_fifo_ia_status[12:08]; 
      r32_mux_1_data[31:29] = i_osf_pdt_fifo_ia_status[15:13]; 
    end
    `CR_OSF_OSF_PDT_FIFO_IA_WDATA_PART0: begin
      r32_mux_1_data[31:00] = o_osf_pdt_fifo_ia_wdata_part0[31:00]; 
    end
    `CR_OSF_OSF_PDT_FIFO_IA_WDATA_PART1: begin
      r32_mux_1_data[31:00] = o_osf_pdt_fifo_ia_wdata_part1[31:00]; 
    end
    `CR_OSF_OSF_PDT_FIFO_IA_WDATA_PART2: begin
      r32_mux_1_data[00:00] = o_osf_pdt_fifo_ia_wdata_part2[00:00]; 
      r32_mux_1_data[03:01] = o_osf_pdt_fifo_ia_wdata_part2[03:01]; 
      r32_mux_1_data[11:04] = o_osf_pdt_fifo_ia_wdata_part2[11:04]; 
      r32_mux_1_data[19:12] = o_osf_pdt_fifo_ia_wdata_part2[19:12]; 
      r32_mux_1_data[20:20] = o_osf_pdt_fifo_ia_wdata_part2[20:20]; 
    end
    `CR_OSF_OSF_PDT_FIFO_IA_CONFIG: begin
      r32_mux_1_data[07:00] = o_osf_pdt_fifo_ia_config[07:00]; 
      r32_mux_1_data[31:28] = o_osf_pdt_fifo_ia_config[11:08]; 
    end
    `CR_OSF_OSF_PDT_FIFO_IA_RDATA_PART0: begin
      r32_mux_1_data[31:00] = i_osf_pdt_fifo_ia_rdata_part0[31:00]; 
    end
    `CR_OSF_OSF_PDT_FIFO_IA_RDATA_PART1: begin
      r32_mux_1_data[31:00] = i_osf_pdt_fifo_ia_rdata_part1[31:00]; 
    end
    `CR_OSF_OSF_PDT_FIFO_IA_RDATA_PART2: begin
      r32_mux_1_data[00:00] = i_osf_pdt_fifo_ia_rdata_part2[00:00]; 
      r32_mux_1_data[03:01] = i_osf_pdt_fifo_ia_rdata_part2[03:01]; 
      r32_mux_1_data[11:04] = i_osf_pdt_fifo_ia_rdata_part2[11:04]; 
      r32_mux_1_data[19:12] = i_osf_pdt_fifo_ia_rdata_part2[19:12]; 
      r32_mux_1_data[20:20] = i_osf_pdt_fifo_ia_rdata_part2[20:20]; 
    end
    `CR_OSF_OSF_PDT_FIFO_FIFO_STATUS_0: begin
      r32_mux_1_data[07:00] = i_osf_pdt_fifo_fifo_status_0[07:00]; 
      r32_mux_1_data[23:16] = i_osf_pdt_fifo_fifo_status_0[15:08]; 
      r32_mux_1_data[28:28] = i_osf_pdt_fifo_fifo_status_0[16:16]; 
      r32_mux_1_data[29:29] = i_osf_pdt_fifo_fifo_status_0[17:17]; 
      r32_mux_1_data[30:30] = i_osf_pdt_fifo_fifo_status_0[18:18]; 
      r32_mux_1_data[31:31] = i_osf_pdt_fifo_fifo_status_0[19:19]; 
    end
    `CR_OSF_OSF_PDT_FIFO_FIFO_STATUS_1: begin
      r32_mux_1_data[08:00] = i_osf_pdt_fifo_fifo_status_1[08:00]; 
    end
    `CR_OSF_OB_AGG_DATA_BYTES_0_COUNT_PART0_A: begin
      r32_mux_1_data[31:00] = i_ob_agg_data_bytes_0_count_part0_a[31:00]; 
    end
    `CR_OSF_OB_AGG_DATA_BYTES_0_COUNT_PART1_A: begin
      r32_mux_1_data[17:00] = i_ob_agg_data_bytes_0_count_part1_a[17:00]; 
    end
    `CR_OSF_OB_AGG_DATA_BYTES_GLOBAL_READ: begin
      r32_mux_1_data[00:00] = i_ob_agg_data_bytes_global_read[00:00]; 
    end
    `CR_OSF_OB_AGG_DATA_BYTES_GLOBAL_CONFIG: begin
      r32_mux_1_data[00:00] = o_ob_agg_data_bytes_global_config[00:00]; 
    end
    `CR_OSF_OB_AGG_FRAME_0_COUNT_PART0_A: begin
      r32_mux_1_data[31:00] = i_ob_agg_frame_0_count_part0_a[31:00]; 
    end
    `CR_OSF_OB_AGG_FRAME_0_COUNT_PART1_A: begin
      r32_mux_1_data[17:00] = i_ob_agg_frame_0_count_part1_a[17:00]; 
    end
    `CR_OSF_OB_AGG_FRAME_GLOBAL_READ: begin
      r32_mux_1_data[00:00] = i_ob_agg_frame_global_read[00:00]; 
    end
    `CR_OSF_OB_AGG_FRAME_GLOBAL_CONFIG: begin
      r32_mux_1_data[00:00] = o_ob_agg_frame_global_config[00:00]; 
    end
    endcase

  end

  
  

  
  

  reg  [31:0]  f32_data;

  assign o_reg_wr_data = f32_data;

  
  

  
  assign       o_rd_data  = (o_ack  & ~n_write) ? r32_formatted_reg_data : { 32 { 1'b0 } };
  

  
  

  wire w_load_spare_config                    = w_do_write & (ws_addr == `CR_OSF_SPARE_CONFIG);
  wire w_load_osf_tlv_parse_action_0          = w_do_write & (ws_addr == `CR_OSF_OSF_TLV_PARSE_ACTION_0);
  wire w_load_osf_tlv_parse_action_1          = w_do_write & (ws_addr == `CR_OSF_OSF_TLV_PARSE_ACTION_1);
  wire w_load_debug_ctl_config                = w_do_write & (ws_addr == `CR_OSF_DEBUG_CTL_CONFIG);
  wire w_load_data_fifo_debug_ctl_config      = w_do_write & (ws_addr == `CR_OSF_DATA_FIFO_DEBUG_CTL_CONFIG);
  wire w_load_data_fifo_debug_ss_ctl_config   = w_do_write & (ws_addr == `CR_OSF_DATA_FIFO_DEBUG_SS_CTL_CONFIG);
  wire w_load_pdt_fifo_debug_ctl_config       = w_do_write & (ws_addr == `CR_OSF_PDT_FIFO_DEBUG_CTL_CONFIG);
  wire w_load_pdt_fifo_debug_ss_ctl_config    = w_do_write & (ws_addr == `CR_OSF_PDT_FIFO_DEBUG_SS_CTL_CONFIG);
  wire w_load_osf_data_fifo_ia_wdata_part0    = w_do_write & (ws_addr == `CR_OSF_OSF_DATA_FIFO_IA_WDATA_PART0);
  wire w_load_osf_data_fifo_ia_wdata_part1    = w_do_write & (ws_addr == `CR_OSF_OSF_DATA_FIFO_IA_WDATA_PART1);
  wire w_load_osf_data_fifo_ia_wdata_part2    = w_do_write & (ws_addr == `CR_OSF_OSF_DATA_FIFO_IA_WDATA_PART2);
  wire w_load_osf_data_fifo_ia_config         = w_do_write & (ws_addr == `CR_OSF_OSF_DATA_FIFO_IA_CONFIG);
  wire w_load_osf_pdt_fifo_ia_wdata_part0     = w_do_write & (ws_addr == `CR_OSF_OSF_PDT_FIFO_IA_WDATA_PART0);
  wire w_load_osf_pdt_fifo_ia_wdata_part1     = w_do_write & (ws_addr == `CR_OSF_OSF_PDT_FIFO_IA_WDATA_PART1);
  wire w_load_osf_pdt_fifo_ia_wdata_part2     = w_do_write & (ws_addr == `CR_OSF_OSF_PDT_FIFO_IA_WDATA_PART2);
  wire w_load_osf_pdt_fifo_ia_config          = w_do_write & (ws_addr == `CR_OSF_OSF_PDT_FIFO_IA_CONFIG);
  wire w_load_ob_agg_data_bytes_global_config = w_do_write & (ws_addr == `CR_OSF_OB_AGG_DATA_BYTES_GLOBAL_CONFIG);
  wire w_load_ob_agg_frame_global_config      = w_do_write & (ws_addr == `CR_OSF_OB_AGG_FRAME_GLOBAL_CONFIG);


  


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
  

  cr_osf_regs_flops u_cr_osf_regs_flops (
        .clk                                    ( clk ),
        .i_reset_                               ( i_reset_ ),
        .i_sw_init                              ( i_sw_init ),
        .o_spare_config                         ( o_spare_config ),
        .o_osf_tlv_parse_action_0               ( o_osf_tlv_parse_action_0 ),
        .o_osf_tlv_parse_action_1               ( o_osf_tlv_parse_action_1 ),
        .o_debug_ctl_config                     ( o_debug_ctl_config ),
        .o_data_fifo_debug_ctl_config           ( o_data_fifo_debug_ctl_config ),
        .o_data_fifo_debug_ss_ctl_config        ( o_data_fifo_debug_ss_ctl_config ),
        .o_pdt_fifo_debug_ctl_config            ( o_pdt_fifo_debug_ctl_config ),
        .o_pdt_fifo_debug_ss_ctl_config         ( o_pdt_fifo_debug_ss_ctl_config ),
        .o_osf_data_fifo_ia_wdata_part0         ( o_osf_data_fifo_ia_wdata_part0 ),
        .o_osf_data_fifo_ia_wdata_part1         ( o_osf_data_fifo_ia_wdata_part1 ),
        .o_osf_data_fifo_ia_wdata_part2         ( o_osf_data_fifo_ia_wdata_part2 ),
        .o_osf_data_fifo_ia_config              ( o_osf_data_fifo_ia_config ),
        .o_osf_pdt_fifo_ia_wdata_part0          ( o_osf_pdt_fifo_ia_wdata_part0 ),
        .o_osf_pdt_fifo_ia_wdata_part1          ( o_osf_pdt_fifo_ia_wdata_part1 ),
        .o_osf_pdt_fifo_ia_wdata_part2          ( o_osf_pdt_fifo_ia_wdata_part2 ),
        .o_osf_pdt_fifo_ia_config               ( o_osf_pdt_fifo_ia_config ),
        .o_ob_agg_data_bytes_global_config      ( o_ob_agg_data_bytes_global_config ),
        .o_ob_agg_frame_global_config           ( o_ob_agg_frame_global_config ),
        .w_load_spare_config                    ( w_load_spare_config ),
        .w_load_osf_tlv_parse_action_0          ( w_load_osf_tlv_parse_action_0 ),
        .w_load_osf_tlv_parse_action_1          ( w_load_osf_tlv_parse_action_1 ),
        .w_load_debug_ctl_config                ( w_load_debug_ctl_config ),
        .w_load_data_fifo_debug_ctl_config      ( w_load_data_fifo_debug_ctl_config ),
        .w_load_data_fifo_debug_ss_ctl_config   ( w_load_data_fifo_debug_ss_ctl_config ),
        .w_load_pdt_fifo_debug_ctl_config       ( w_load_pdt_fifo_debug_ctl_config ),
        .w_load_pdt_fifo_debug_ss_ctl_config    ( w_load_pdt_fifo_debug_ss_ctl_config ),
        .w_load_osf_data_fifo_ia_wdata_part0    ( w_load_osf_data_fifo_ia_wdata_part0 ),
        .w_load_osf_data_fifo_ia_wdata_part1    ( w_load_osf_data_fifo_ia_wdata_part1 ),
        .w_load_osf_data_fifo_ia_wdata_part2    ( w_load_osf_data_fifo_ia_wdata_part2 ),
        .w_load_osf_data_fifo_ia_config         ( w_load_osf_data_fifo_ia_config ),
        .w_load_osf_pdt_fifo_ia_wdata_part0     ( w_load_osf_pdt_fifo_ia_wdata_part0 ),
        .w_load_osf_pdt_fifo_ia_wdata_part1     ( w_load_osf_pdt_fifo_ia_wdata_part1 ),
        .w_load_osf_pdt_fifo_ia_wdata_part2     ( w_load_osf_pdt_fifo_ia_wdata_part2 ),
        .w_load_osf_pdt_fifo_ia_config          ( w_load_osf_pdt_fifo_ia_config ),
        .w_load_ob_agg_data_bytes_global_config ( w_load_ob_agg_data_bytes_global_config ),
        .w_load_ob_agg_frame_global_config      ( w_load_ob_agg_frame_global_config ),
        .f32_data                               ( f32_data )
  );

  

  

  `ifdef CR_OSF_DIGEST_CB9E9292F32F4496B74DE844F3AA6642
  `else
    initial begin
      $display("Error: the core decode file (cr_osf_regs.sv) and include file (cr_osf.vh) were compiled");
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


module cr_osf_regs_flops (
  input                                    clk,
  input                                    i_reset_,
  input                                    i_sw_init,

  
  output reg [`CR_OSF_C_SPARE_T_DECL]      o_spare_config,
  output reg [`CR_OSF_C_OSF_TLV_PARSE_ACTION_31_0_T_DECL] o_osf_tlv_parse_action_0,
  output reg [`CR_OSF_C_OSF_TLV_PARSE_ACTION_63_32_T_DECL] o_osf_tlv_parse_action_1,
  output reg [`CR_OSF_C_DEBUG_CTL_T_DECL]  o_debug_ctl_config,
  output reg [`CR_OSF_C_DATA_FIFO_DEBUG_CTL_T_DECL] o_data_fifo_debug_ctl_config,
  output reg [`CR_OSF_C_DATA_FIFO_DEBUG_SS_CTL_T_DECL] o_data_fifo_debug_ss_ctl_config,
  output reg [`CR_OSF_C_PDT_FIFO_DEBUG_CTL_T_DECL] o_pdt_fifo_debug_ctl_config,
  output reg [`CR_OSF_C_PDT_FIFO_DEBUG_SS_CTL_T_DECL] o_pdt_fifo_debug_ss_ctl_config,
  output reg [`CR_OSF_C_OSF_DATA_FIFO_PART0_T_DECL] o_osf_data_fifo_ia_wdata_part0,
  output reg [`CR_OSF_C_OSF_DATA_FIFO_PART1_T_DECL] o_osf_data_fifo_ia_wdata_part1,
  output reg [`CR_OSF_C_OSF_DATA_FIFO_PART2_T_DECL] o_osf_data_fifo_ia_wdata_part2,
  output reg [`CR_OSF_C_OSF_DATA_FIFO_IA_CONFIG_T_DECL] o_osf_data_fifo_ia_config,
  output reg [`CR_OSF_C_OSF_PDT_FIFO_PART0_T_DECL] o_osf_pdt_fifo_ia_wdata_part0,
  output reg [`CR_OSF_C_OSF_PDT_FIFO_PART1_T_DECL] o_osf_pdt_fifo_ia_wdata_part1,
  output reg [`CR_OSF_C_OSF_PDT_FIFO_PART2_T_DECL] o_osf_pdt_fifo_ia_wdata_part2,
  output reg [`CR_OSF_C_OSF_PDT_FIFO_IA_CONFIG_T_DECL] o_osf_pdt_fifo_ia_config,
  output reg [`CR_OSF_C_OB_AGG_DATA_BYTES_GLOBAL_CONFIG_T_DECL] o_ob_agg_data_bytes_global_config,
  output reg [`CR_OSF_C_OB_AGG_FRAME_GLOBAL_CONFIG_T_DECL] o_ob_agg_frame_global_config,


  
  input                                    w_load_spare_config,
  input                                    w_load_osf_tlv_parse_action_0,
  input                                    w_load_osf_tlv_parse_action_1,
  input                                    w_load_debug_ctl_config,
  input                                    w_load_data_fifo_debug_ctl_config,
  input                                    w_load_data_fifo_debug_ss_ctl_config,
  input                                    w_load_pdt_fifo_debug_ctl_config,
  input                                    w_load_pdt_fifo_debug_ss_ctl_config,
  input                                    w_load_osf_data_fifo_ia_wdata_part0,
  input                                    w_load_osf_data_fifo_ia_wdata_part1,
  input                                    w_load_osf_data_fifo_ia_wdata_part2,
  input                                    w_load_osf_data_fifo_ia_config,
  input                                    w_load_osf_pdt_fifo_ia_wdata_part0,
  input                                    w_load_osf_pdt_fifo_ia_wdata_part1,
  input                                    w_load_osf_pdt_fifo_ia_wdata_part2,
  input                                    w_load_osf_pdt_fifo_ia_config,
  input                                    w_load_ob_agg_data_bytes_global_config,
  input                                    w_load_ob_agg_frame_global_config,

  input      [31:0]                             f32_data
  );

  
  

  
  

  
  
  
  always_ff @(posedge clk or negedge i_reset_) begin
    if(~i_reset_) begin
      
      o_spare_config[31:00]                    <= 32'd0; 
      o_osf_tlv_parse_action_0[01:00]          <= 2'd1; 
      o_osf_tlv_parse_action_0[03:02]          <= 2'd3; 
      o_osf_tlv_parse_action_0[05:04]          <= 2'd3; 
      o_osf_tlv_parse_action_0[07:06]          <= 2'd3; 
      o_osf_tlv_parse_action_0[09:08]          <= 2'd3; 
      o_osf_tlv_parse_action_0[11:10]          <= 2'd1; 
      o_osf_tlv_parse_action_0[13:12]          <= 2'd3; 
      o_osf_tlv_parse_action_0[15:14]          <= 2'd1; 
      o_osf_tlv_parse_action_0[17:16]          <= 2'd3; 
      o_osf_tlv_parse_action_0[19:18]          <= 2'd3; 
      o_osf_tlv_parse_action_0[21:20]          <= 2'd3; 
      o_osf_tlv_parse_action_0[23:22]          <= 2'd3; 
      o_osf_tlv_parse_action_0[25:24]          <= 2'd3; 
      o_osf_tlv_parse_action_0[27:26]          <= 2'd3; 
      o_osf_tlv_parse_action_0[29:28]          <= 2'd3; 
      o_osf_tlv_parse_action_0[31:30]          <= 2'd3; 
      o_osf_tlv_parse_action_1[01:00]          <= 2'd3; 
      o_osf_tlv_parse_action_1[03:02]          <= 2'd3; 
      o_osf_tlv_parse_action_1[05:04]          <= 2'd3; 
      o_osf_tlv_parse_action_1[07:06]          <= 2'd1; 
      o_osf_tlv_parse_action_1[09:08]          <= 2'd3; 
      o_osf_tlv_parse_action_1[11:10]          <= 2'd3; 
      o_osf_tlv_parse_action_1[13:12]          <= 2'd3; 
      o_osf_tlv_parse_action_1[15:14]          <= 2'd3; 
      o_osf_tlv_parse_action_1[17:16]          <= 2'd3; 
      o_osf_tlv_parse_action_1[19:18]          <= 2'd3; 
      o_osf_tlv_parse_action_1[21:20]          <= 2'd3; 
      o_osf_tlv_parse_action_1[23:22]          <= 2'd3; 
      o_osf_tlv_parse_action_1[25:24]          <= 2'd3; 
      o_osf_tlv_parse_action_1[27:26]          <= 2'd3; 
      o_osf_tlv_parse_action_1[29:28]          <= 2'd3; 
      o_osf_tlv_parse_action_1[31:30]          <= 2'd3; 
      o_debug_ctl_config[01:00]                <= 2'd0; 
      o_debug_ctl_config[02:02]                <= 1'd0; 
      o_debug_ctl_config[03:03]                <= 1'd0; 
      o_debug_ctl_config[04:04]                <= 1'd0; 
      o_data_fifo_debug_ctl_config[01:00]      <= 2'd0; 
      o_data_fifo_debug_ctl_config[02:02]      <= 1'd0; 
      o_data_fifo_debug_ctl_config[11:03]      <= 9'd0; 
      o_data_fifo_debug_ctl_config[21:12]      <= 10'd0; 
      o_data_fifo_debug_ctl_config[22:22]      <= 1'd0; 
      o_data_fifo_debug_ss_ctl_config[00:00]   <= 1'd0; 
      o_pdt_fifo_debug_ctl_config[01:00]       <= 2'd0; 
      o_pdt_fifo_debug_ctl_config[02:02]       <= 1'd0; 
      o_pdt_fifo_debug_ctl_config[10:03]       <= 8'd0; 
      o_pdt_fifo_debug_ctl_config[19:11]       <= 9'd0; 
      o_pdt_fifo_debug_ctl_config[20:20]       <= 1'd0; 
      o_pdt_fifo_debug_ss_ctl_config[00:00]    <= 1'd0; 
      o_osf_data_fifo_ia_wdata_part0[31:00]    <= 32'd0; 
      o_osf_data_fifo_ia_wdata_part1[31:00]    <= 32'd0; 
      o_osf_data_fifo_ia_wdata_part2[00:00]    <= 1'd0; 
      o_osf_data_fifo_ia_config[08:00]         <= 9'd0; 
      o_osf_data_fifo_ia_config[12:09]         <= 4'd0; 
      o_osf_pdt_fifo_ia_wdata_part0[31:00]     <= 32'd0; 
      o_osf_pdt_fifo_ia_wdata_part1[31:00]     <= 32'd0; 
      o_osf_pdt_fifo_ia_wdata_part2[00:00]     <= 1'd0; 
      o_osf_pdt_fifo_ia_config[07:00]          <= 8'd0; 
      o_osf_pdt_fifo_ia_config[11:08]          <= 4'd0; 
      o_ob_agg_data_bytes_global_config[00:00] <= 1'd0; 
      o_ob_agg_frame_global_config[00:00]      <= 1'd0; 
    end
    else if(i_sw_init) begin
      
      o_spare_config[31:00]                    <= 32'd0; 
      o_osf_tlv_parse_action_0[01:00]          <= 2'd1; 
      o_osf_tlv_parse_action_0[03:02]          <= 2'd3; 
      o_osf_tlv_parse_action_0[05:04]          <= 2'd3; 
      o_osf_tlv_parse_action_0[07:06]          <= 2'd3; 
      o_osf_tlv_parse_action_0[09:08]          <= 2'd3; 
      o_osf_tlv_parse_action_0[11:10]          <= 2'd1; 
      o_osf_tlv_parse_action_0[13:12]          <= 2'd3; 
      o_osf_tlv_parse_action_0[15:14]          <= 2'd1; 
      o_osf_tlv_parse_action_0[17:16]          <= 2'd3; 
      o_osf_tlv_parse_action_0[19:18]          <= 2'd3; 
      o_osf_tlv_parse_action_0[21:20]          <= 2'd3; 
      o_osf_tlv_parse_action_0[23:22]          <= 2'd3; 
      o_osf_tlv_parse_action_0[25:24]          <= 2'd3; 
      o_osf_tlv_parse_action_0[27:26]          <= 2'd3; 
      o_osf_tlv_parse_action_0[29:28]          <= 2'd3; 
      o_osf_tlv_parse_action_0[31:30]          <= 2'd3; 
      o_osf_tlv_parse_action_1[01:00]          <= 2'd3; 
      o_osf_tlv_parse_action_1[03:02]          <= 2'd3; 
      o_osf_tlv_parse_action_1[05:04]          <= 2'd3; 
      o_osf_tlv_parse_action_1[07:06]          <= 2'd1; 
      o_osf_tlv_parse_action_1[09:08]          <= 2'd3; 
      o_osf_tlv_parse_action_1[11:10]          <= 2'd3; 
      o_osf_tlv_parse_action_1[13:12]          <= 2'd3; 
      o_osf_tlv_parse_action_1[15:14]          <= 2'd3; 
      o_osf_tlv_parse_action_1[17:16]          <= 2'd3; 
      o_osf_tlv_parse_action_1[19:18]          <= 2'd3; 
      o_osf_tlv_parse_action_1[21:20]          <= 2'd3; 
      o_osf_tlv_parse_action_1[23:22]          <= 2'd3; 
      o_osf_tlv_parse_action_1[25:24]          <= 2'd3; 
      o_osf_tlv_parse_action_1[27:26]          <= 2'd3; 
      o_osf_tlv_parse_action_1[29:28]          <= 2'd3; 
      o_osf_tlv_parse_action_1[31:30]          <= 2'd3; 
      o_debug_ctl_config[01:00]                <= 2'd0; 
      o_debug_ctl_config[02:02]                <= 1'd0; 
      o_debug_ctl_config[03:03]                <= 1'd0; 
      o_debug_ctl_config[04:04]                <= 1'd0; 
      o_data_fifo_debug_ctl_config[01:00]      <= 2'd0; 
      o_data_fifo_debug_ctl_config[02:02]      <= 1'd0; 
      o_data_fifo_debug_ctl_config[11:03]      <= 9'd0; 
      o_data_fifo_debug_ctl_config[21:12]      <= 10'd0; 
      o_data_fifo_debug_ctl_config[22:22]      <= 1'd0; 
      o_data_fifo_debug_ss_ctl_config[00:00]   <= 1'd0; 
      o_pdt_fifo_debug_ctl_config[01:00]       <= 2'd0; 
      o_pdt_fifo_debug_ctl_config[02:02]       <= 1'd0; 
      o_pdt_fifo_debug_ctl_config[10:03]       <= 8'd0; 
      o_pdt_fifo_debug_ctl_config[19:11]       <= 9'd0; 
      o_pdt_fifo_debug_ctl_config[20:20]       <= 1'd0; 
      o_pdt_fifo_debug_ss_ctl_config[00:00]    <= 1'd0; 
      o_osf_data_fifo_ia_wdata_part0[31:00]    <= 32'd0; 
      o_osf_data_fifo_ia_wdata_part1[31:00]    <= 32'd0; 
      o_osf_data_fifo_ia_wdata_part2[00:00]    <= 1'd0; 
      o_osf_data_fifo_ia_config[08:00]         <= 9'd0; 
      o_osf_data_fifo_ia_config[12:09]         <= 4'd0; 
      o_osf_pdt_fifo_ia_wdata_part0[31:00]     <= 32'd0; 
      o_osf_pdt_fifo_ia_wdata_part1[31:00]     <= 32'd0; 
      o_osf_pdt_fifo_ia_wdata_part2[00:00]     <= 1'd0; 
      o_osf_pdt_fifo_ia_config[07:00]          <= 8'd0; 
      o_osf_pdt_fifo_ia_config[11:08]          <= 4'd0; 
      o_ob_agg_data_bytes_global_config[00:00] <= 1'd0; 
      o_ob_agg_frame_global_config[00:00]      <= 1'd0; 
    end
    else begin
      if(w_load_spare_config)                    o_spare_config[31:00]                    <= f32_data[31:00]; 
      if(w_load_osf_tlv_parse_action_0)          o_osf_tlv_parse_action_0[01:00]          <= f32_data[01:00]; 
      if(w_load_osf_tlv_parse_action_0)          o_osf_tlv_parse_action_0[03:02]          <= f32_data[03:02]; 
      if(w_load_osf_tlv_parse_action_0)          o_osf_tlv_parse_action_0[05:04]          <= f32_data[05:04]; 
      if(w_load_osf_tlv_parse_action_0)          o_osf_tlv_parse_action_0[07:06]          <= f32_data[07:06]; 
      if(w_load_osf_tlv_parse_action_0)          o_osf_tlv_parse_action_0[09:08]          <= f32_data[09:08]; 
      if(w_load_osf_tlv_parse_action_0)          o_osf_tlv_parse_action_0[11:10]          <= f32_data[11:10]; 
      if(w_load_osf_tlv_parse_action_0)          o_osf_tlv_parse_action_0[13:12]          <= f32_data[13:12]; 
      if(w_load_osf_tlv_parse_action_0)          o_osf_tlv_parse_action_0[15:14]          <= f32_data[15:14]; 
      if(w_load_osf_tlv_parse_action_0)          o_osf_tlv_parse_action_0[17:16]          <= f32_data[17:16]; 
      if(w_load_osf_tlv_parse_action_0)          o_osf_tlv_parse_action_0[19:18]          <= f32_data[19:18]; 
      if(w_load_osf_tlv_parse_action_0)          o_osf_tlv_parse_action_0[21:20]          <= f32_data[21:20]; 
      if(w_load_osf_tlv_parse_action_0)          o_osf_tlv_parse_action_0[23:22]          <= f32_data[23:22]; 
      if(w_load_osf_tlv_parse_action_0)          o_osf_tlv_parse_action_0[25:24]          <= f32_data[25:24]; 
      if(w_load_osf_tlv_parse_action_0)          o_osf_tlv_parse_action_0[27:26]          <= f32_data[27:26]; 
      if(w_load_osf_tlv_parse_action_0)          o_osf_tlv_parse_action_0[29:28]          <= f32_data[29:28]; 
      if(w_load_osf_tlv_parse_action_0)          o_osf_tlv_parse_action_0[31:30]          <= f32_data[31:30]; 
      if(w_load_osf_tlv_parse_action_1)          o_osf_tlv_parse_action_1[01:00]          <= f32_data[01:00]; 
      if(w_load_osf_tlv_parse_action_1)          o_osf_tlv_parse_action_1[03:02]          <= f32_data[03:02]; 
      if(w_load_osf_tlv_parse_action_1)          o_osf_tlv_parse_action_1[05:04]          <= f32_data[05:04]; 
      if(w_load_osf_tlv_parse_action_1)          o_osf_tlv_parse_action_1[07:06]          <= f32_data[07:06]; 
      if(w_load_osf_tlv_parse_action_1)          o_osf_tlv_parse_action_1[09:08]          <= f32_data[09:08]; 
      if(w_load_osf_tlv_parse_action_1)          o_osf_tlv_parse_action_1[11:10]          <= f32_data[11:10]; 
      if(w_load_osf_tlv_parse_action_1)          o_osf_tlv_parse_action_1[13:12]          <= f32_data[13:12]; 
      if(w_load_osf_tlv_parse_action_1)          o_osf_tlv_parse_action_1[15:14]          <= f32_data[15:14]; 
      if(w_load_osf_tlv_parse_action_1)          o_osf_tlv_parse_action_1[17:16]          <= f32_data[17:16]; 
      if(w_load_osf_tlv_parse_action_1)          o_osf_tlv_parse_action_1[19:18]          <= f32_data[19:18]; 
      if(w_load_osf_tlv_parse_action_1)          o_osf_tlv_parse_action_1[21:20]          <= f32_data[21:20]; 
      if(w_load_osf_tlv_parse_action_1)          o_osf_tlv_parse_action_1[23:22]          <= f32_data[23:22]; 
      if(w_load_osf_tlv_parse_action_1)          o_osf_tlv_parse_action_1[25:24]          <= f32_data[25:24]; 
      if(w_load_osf_tlv_parse_action_1)          o_osf_tlv_parse_action_1[27:26]          <= f32_data[27:26]; 
      if(w_load_osf_tlv_parse_action_1)          o_osf_tlv_parse_action_1[29:28]          <= f32_data[29:28]; 
      if(w_load_osf_tlv_parse_action_1)          o_osf_tlv_parse_action_1[31:30]          <= f32_data[31:30]; 
      if(w_load_debug_ctl_config)                o_debug_ctl_config[01:00]                <= f32_data[01:00]; 
      if(w_load_debug_ctl_config)                o_debug_ctl_config[02:02]                <= f32_data[02:02]; 
      if(w_load_debug_ctl_config)                o_debug_ctl_config[03:03]                <= f32_data[03:03]; 
      if(w_load_debug_ctl_config)                o_debug_ctl_config[04:04]                <= f32_data[04:04]; 
      if(w_load_data_fifo_debug_ctl_config)      o_data_fifo_debug_ctl_config[01:00]      <= f32_data[01:00]; 
      if(w_load_data_fifo_debug_ctl_config)      o_data_fifo_debug_ctl_config[02:02]      <= f32_data[02:02]; 
      if(w_load_data_fifo_debug_ctl_config)      o_data_fifo_debug_ctl_config[11:03]      <= f32_data[12:04]; 
      if(w_load_data_fifo_debug_ctl_config)      o_data_fifo_debug_ctl_config[21:12]      <= f32_data[25:16]; 
      if(w_load_data_fifo_debug_ctl_config)      o_data_fifo_debug_ctl_config[22:22]      <= f32_data[31:31]; 
      if(w_load_data_fifo_debug_ss_ctl_config)   o_data_fifo_debug_ss_ctl_config[00:00]   <= f32_data[00:00]; 
      if(w_load_pdt_fifo_debug_ctl_config)       o_pdt_fifo_debug_ctl_config[01:00]       <= f32_data[01:00]; 
      if(w_load_pdt_fifo_debug_ctl_config)       o_pdt_fifo_debug_ctl_config[02:02]       <= f32_data[02:02]; 
      if(w_load_pdt_fifo_debug_ctl_config)       o_pdt_fifo_debug_ctl_config[10:03]       <= f32_data[11:04]; 
      if(w_load_pdt_fifo_debug_ctl_config)       o_pdt_fifo_debug_ctl_config[19:11]       <= f32_data[20:12]; 
      if(w_load_pdt_fifo_debug_ctl_config)       o_pdt_fifo_debug_ctl_config[20:20]       <= f32_data[31:31]; 
      if(w_load_pdt_fifo_debug_ss_ctl_config)    o_pdt_fifo_debug_ss_ctl_config[00:00]    <= f32_data[00:00]; 
      if(w_load_osf_data_fifo_ia_wdata_part0)    o_osf_data_fifo_ia_wdata_part0[31:00]    <= f32_data[31:00]; 
      if(w_load_osf_data_fifo_ia_wdata_part1)    o_osf_data_fifo_ia_wdata_part1[31:00]    <= f32_data[31:00]; 
      if(w_load_osf_data_fifo_ia_wdata_part2)    o_osf_data_fifo_ia_wdata_part2[00:00]    <= f32_data[00:00]; 
      if(w_load_osf_data_fifo_ia_config)         o_osf_data_fifo_ia_config[08:00]         <= f32_data[08:00]; 
      if(w_load_osf_data_fifo_ia_config)         o_osf_data_fifo_ia_config[12:09]         <= f32_data[31:28]; 
      if(w_load_osf_pdt_fifo_ia_wdata_part0)     o_osf_pdt_fifo_ia_wdata_part0[31:00]     <= f32_data[31:00]; 
      if(w_load_osf_pdt_fifo_ia_wdata_part1)     o_osf_pdt_fifo_ia_wdata_part1[31:00]     <= f32_data[31:00]; 
      if(w_load_osf_pdt_fifo_ia_wdata_part2)     o_osf_pdt_fifo_ia_wdata_part2[00:00]     <= f32_data[00:00]; 
      if(w_load_osf_pdt_fifo_ia_config)          o_osf_pdt_fifo_ia_config[07:00]          <= f32_data[07:00]; 
      if(w_load_osf_pdt_fifo_ia_config)          o_osf_pdt_fifo_ia_config[11:08]          <= f32_data[31:28]; 
      if(w_load_ob_agg_data_bytes_global_config) o_ob_agg_data_bytes_global_config[00:00] <= f32_data[00:00]; 
      if(w_load_ob_agg_frame_global_config)      o_ob_agg_frame_global_config[00:00]      <= f32_data[00:00]; 
    end
  end

  
  
  
  always_ff @(posedge clk) begin
      if(w_load_osf_data_fifo_ia_wdata_part2)    o_osf_data_fifo_ia_wdata_part2[03:01]    <= f32_data[03:01]; 
      if(w_load_osf_data_fifo_ia_wdata_part2)    o_osf_data_fifo_ia_wdata_part2[11:04]    <= f32_data[11:04]; 
      if(w_load_osf_data_fifo_ia_wdata_part2)    o_osf_data_fifo_ia_wdata_part2[19:12]    <= f32_data[19:12]; 
      if(w_load_osf_data_fifo_ia_wdata_part2)    o_osf_data_fifo_ia_wdata_part2[20:20]    <= f32_data[20:20]; 
      if(w_load_osf_pdt_fifo_ia_wdata_part2)     o_osf_pdt_fifo_ia_wdata_part2[03:01]     <= f32_data[03:01]; 
      if(w_load_osf_pdt_fifo_ia_wdata_part2)     o_osf_pdt_fifo_ia_wdata_part2[11:04]     <= f32_data[11:04]; 
      if(w_load_osf_pdt_fifo_ia_wdata_part2)     o_osf_pdt_fifo_ia_wdata_part2[19:12]     <= f32_data[19:12]; 
      if(w_load_osf_pdt_fifo_ia_wdata_part2)     o_osf_pdt_fifo_ia_wdata_part2[20:20]     <= f32_data[20:20]; 
  end
  

  

endmodule
