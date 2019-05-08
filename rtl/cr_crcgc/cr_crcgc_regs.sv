/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











`include "cr_crcgc.vh"




module cr_crcgc_regs (
  input                                       clk,
  input                                       i_reset_,
  input                                       i_sw_init,

  
  input      [`CR_CRCGC_DECL]                 i_addr,
  input                                       i_wr_strb,
  input      [31:0]                           i_wr_data,
  input                                       i_rd_strb,
  output     [31:0]                           o_rd_data,
  output                                      o_ack,
  output                                      o_err_ack,

  
  output     [`CR_CRCGC_C_SPARE_T_DECL]       o_spare_config,
  output     [`CR_CRCGC_C_REGS_TLV_PARSE_ACTION_31_0_T_DECL] o_regs_tlv_parse_action_0,
  output     [`CR_CRCGC_C_REGS_TLV_PARSE_ACTION_63_32_T_DECL] o_regs_tlv_parse_action_1,
  output     [`CR_CRCGC_C_CRCGC_CTRL_T_DECL]  o_regs_crcgc_ctrl,

  
  input      [`CR_CRCGC_C_REVID_T_DECL]       i_revision_config,
  input      [`CR_CRCGC_C_SPARE_T_DECL]       i_spare_config,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_2_T_DECL] i_history_buffer_part2_0,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_1_T_DECL] i_history_buffer_part1_0,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_0_T_DECL] i_history_buffer_part0_0,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_2_T_DECL] i_history_buffer_part2_1,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_1_T_DECL] i_history_buffer_part1_1,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_0_T_DECL] i_history_buffer_part0_1,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_2_T_DECL] i_history_buffer_part2_2,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_1_T_DECL] i_history_buffer_part1_2,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_0_T_DECL] i_history_buffer_part0_2,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_2_T_DECL] i_history_buffer_part2_3,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_1_T_DECL] i_history_buffer_part1_3,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_0_T_DECL] i_history_buffer_part0_3,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_2_T_DECL] i_history_buffer_part2_4,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_1_T_DECL] i_history_buffer_part1_4,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_0_T_DECL] i_history_buffer_part0_4,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_2_T_DECL] i_history_buffer_part2_5,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_1_T_DECL] i_history_buffer_part1_5,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_0_T_DECL] i_history_buffer_part0_5,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_2_T_DECL] i_history_buffer_part2_6,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_1_T_DECL] i_history_buffer_part1_6,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_0_T_DECL] i_history_buffer_part0_6,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_2_T_DECL] i_history_buffer_part2_7,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_1_T_DECL] i_history_buffer_part1_7,
  input      [`CR_CRCGC_C_HISTORY_BUFFER_PART_0_T_DECL] i_history_buffer_part0_7,
  input      [`CR_CRCGC_C_CRCGC_CTRL_T_DECL]  i_regs_crcgc_ctrl,

  
  output reg                                  o_reg_written,
  output reg                                  o_reg_read,
  output     [31:0]                           o_reg_wr_data,
  output reg [`CR_CRCGC_DECL]                 o_reg_addr
  );


  


  
  


  
  wire [`CR_CRCGC_DECL] ws_read_addr    = o_reg_addr;
  wire [`CR_CRCGC_DECL] ws_addr         = o_reg_addr;
  

  wire n_wr_strobe = i_wr_strb;
  wire n_rd_strobe = i_rd_strb;

  wire w_32b_aligned    = (o_reg_addr[1:0] == 2'h0);

  wire w_valid_rd_addr     = (w_32b_aligned && (ws_addr >= `CR_CRCGC_REVISION_CONFIG) && (ws_addr <= `CR_CRCGC_SPARE_CONFIG))
                          || (w_32b_aligned && (ws_addr >= `CR_CRCGC_REGS_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_CRCGC_REGS_TLV_PARSE_ACTION_1))
                          || (w_32b_aligned && (ws_addr >= `CR_CRCGC_HISTORY_BUFFER_PART2_0) && (ws_addr <= `CR_CRCGC_HISTORY_BUFFER_PART0_0))
                          || (w_32b_aligned && (ws_addr >= `CR_CRCGC_HISTORY_BUFFER_PART2_1) && (ws_addr <= `CR_CRCGC_REGS_CRCGC_CTRL));

  wire w_valid_wr_addr     = (w_32b_aligned && (ws_addr >= `CR_CRCGC_REVISION_CONFIG) && (ws_addr <= `CR_CRCGC_SPARE_CONFIG))
                          || (w_32b_aligned && (ws_addr >= `CR_CRCGC_REGS_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_CRCGC_REGS_TLV_PARSE_ACTION_1))
                          || (w_32b_aligned && (ws_addr >= `CR_CRCGC_HISTORY_BUFFER_PART2_0) && (ws_addr <= `CR_CRCGC_HISTORY_BUFFER_PART0_0))
                          || (w_32b_aligned && (ws_addr >= `CR_CRCGC_HISTORY_BUFFER_PART2_1) && (ws_addr <= `CR_CRCGC_REGS_CRCGC_CTRL));

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

  wire [31:0]  r32_formatted_reg_data = f32_mux_0_data;

  always_comb begin
    r32_mux_0_data = 0;

    case (ws_read_addr)
    `CR_CRCGC_REVISION_CONFIG: begin
      r32_mux_0_data[07:00] = i_revision_config[07:00]; 
    end
    `CR_CRCGC_SPARE_CONFIG: begin
      r32_mux_0_data[31:00] = i_spare_config[31:00]; 
    end
    `CR_CRCGC_REGS_TLV_PARSE_ACTION_0: begin
      r32_mux_0_data[01:00] = o_regs_tlv_parse_action_0[01:00]; 
      r32_mux_0_data[03:02] = o_regs_tlv_parse_action_0[03:02]; 
      r32_mux_0_data[05:04] = o_regs_tlv_parse_action_0[05:04]; 
      r32_mux_0_data[07:06] = o_regs_tlv_parse_action_0[07:06]; 
      r32_mux_0_data[09:08] = o_regs_tlv_parse_action_0[09:08]; 
      r32_mux_0_data[11:10] = o_regs_tlv_parse_action_0[11:10]; 
      r32_mux_0_data[13:12] = o_regs_tlv_parse_action_0[13:12]; 
      r32_mux_0_data[15:14] = o_regs_tlv_parse_action_0[15:14]; 
      r32_mux_0_data[17:16] = o_regs_tlv_parse_action_0[17:16]; 
      r32_mux_0_data[19:18] = o_regs_tlv_parse_action_0[19:18]; 
      r32_mux_0_data[21:20] = o_regs_tlv_parse_action_0[21:20]; 
      r32_mux_0_data[23:22] = o_regs_tlv_parse_action_0[23:22]; 
      r32_mux_0_data[25:24] = o_regs_tlv_parse_action_0[25:24]; 
      r32_mux_0_data[27:26] = o_regs_tlv_parse_action_0[27:26]; 
      r32_mux_0_data[29:28] = o_regs_tlv_parse_action_0[29:28]; 
      r32_mux_0_data[31:30] = o_regs_tlv_parse_action_0[31:30]; 
    end
    `CR_CRCGC_REGS_TLV_PARSE_ACTION_1: begin
      r32_mux_0_data[01:00] = o_regs_tlv_parse_action_1[01:00]; 
      r32_mux_0_data[03:02] = o_regs_tlv_parse_action_1[03:02]; 
      r32_mux_0_data[05:04] = o_regs_tlv_parse_action_1[05:04]; 
      r32_mux_0_data[07:06] = o_regs_tlv_parse_action_1[07:06]; 
      r32_mux_0_data[09:08] = o_regs_tlv_parse_action_1[09:08]; 
      r32_mux_0_data[11:10] = o_regs_tlv_parse_action_1[11:10]; 
      r32_mux_0_data[13:12] = o_regs_tlv_parse_action_1[13:12]; 
      r32_mux_0_data[15:14] = o_regs_tlv_parse_action_1[15:14]; 
      r32_mux_0_data[17:16] = o_regs_tlv_parse_action_1[17:16]; 
      r32_mux_0_data[19:18] = o_regs_tlv_parse_action_1[19:18]; 
      r32_mux_0_data[21:20] = o_regs_tlv_parse_action_1[21:20]; 
      r32_mux_0_data[23:22] = o_regs_tlv_parse_action_1[23:22]; 
      r32_mux_0_data[25:24] = o_regs_tlv_parse_action_1[25:24]; 
      r32_mux_0_data[27:26] = o_regs_tlv_parse_action_1[27:26]; 
      r32_mux_0_data[29:28] = o_regs_tlv_parse_action_1[29:28]; 
      r32_mux_0_data[31:30] = o_regs_tlv_parse_action_1[31:30]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART2_0: begin
      r32_mux_0_data[07:00] = i_history_buffer_part2_0[07:00]; 
      r32_mux_0_data[18:08] = i_history_buffer_part2_0[18:08]; 
      r32_mux_0_data[19:19] = i_history_buffer_part2_0[19:19]; 
      r32_mux_0_data[20:20] = i_history_buffer_part2_0[20:20]; 
      r32_mux_0_data[21:21] = i_history_buffer_part2_0[21:21]; 
      r32_mux_0_data[31:22] = i_history_buffer_part2_0[31:22]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART1_0: begin
      r32_mux_0_data[31:00] = i_history_buffer_part1_0[31:00]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART0_0: begin
      r32_mux_0_data[31:00] = i_history_buffer_part0_0[31:00]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART2_1: begin
      r32_mux_0_data[07:00] = i_history_buffer_part2_1[07:00]; 
      r32_mux_0_data[18:08] = i_history_buffer_part2_1[18:08]; 
      r32_mux_0_data[19:19] = i_history_buffer_part2_1[19:19]; 
      r32_mux_0_data[20:20] = i_history_buffer_part2_1[20:20]; 
      r32_mux_0_data[21:21] = i_history_buffer_part2_1[21:21]; 
      r32_mux_0_data[31:22] = i_history_buffer_part2_1[31:22]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART1_1: begin
      r32_mux_0_data[31:00] = i_history_buffer_part1_1[31:00]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART0_1: begin
      r32_mux_0_data[31:00] = i_history_buffer_part0_1[31:00]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART2_2: begin
      r32_mux_0_data[07:00] = i_history_buffer_part2_2[07:00]; 
      r32_mux_0_data[18:08] = i_history_buffer_part2_2[18:08]; 
      r32_mux_0_data[19:19] = i_history_buffer_part2_2[19:19]; 
      r32_mux_0_data[20:20] = i_history_buffer_part2_2[20:20]; 
      r32_mux_0_data[21:21] = i_history_buffer_part2_2[21:21]; 
      r32_mux_0_data[31:22] = i_history_buffer_part2_2[31:22]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART1_2: begin
      r32_mux_0_data[31:00] = i_history_buffer_part1_2[31:00]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART0_2: begin
      r32_mux_0_data[31:00] = i_history_buffer_part0_2[31:00]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART2_3: begin
      r32_mux_0_data[07:00] = i_history_buffer_part2_3[07:00]; 
      r32_mux_0_data[18:08] = i_history_buffer_part2_3[18:08]; 
      r32_mux_0_data[19:19] = i_history_buffer_part2_3[19:19]; 
      r32_mux_0_data[20:20] = i_history_buffer_part2_3[20:20]; 
      r32_mux_0_data[21:21] = i_history_buffer_part2_3[21:21]; 
      r32_mux_0_data[31:22] = i_history_buffer_part2_3[31:22]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART1_3: begin
      r32_mux_0_data[31:00] = i_history_buffer_part1_3[31:00]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART0_3: begin
      r32_mux_0_data[31:00] = i_history_buffer_part0_3[31:00]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART2_4: begin
      r32_mux_0_data[07:00] = i_history_buffer_part2_4[07:00]; 
      r32_mux_0_data[18:08] = i_history_buffer_part2_4[18:08]; 
      r32_mux_0_data[19:19] = i_history_buffer_part2_4[19:19]; 
      r32_mux_0_data[20:20] = i_history_buffer_part2_4[20:20]; 
      r32_mux_0_data[21:21] = i_history_buffer_part2_4[21:21]; 
      r32_mux_0_data[31:22] = i_history_buffer_part2_4[31:22]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART1_4: begin
      r32_mux_0_data[31:00] = i_history_buffer_part1_4[31:00]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART0_4: begin
      r32_mux_0_data[31:00] = i_history_buffer_part0_4[31:00]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART2_5: begin
      r32_mux_0_data[07:00] = i_history_buffer_part2_5[07:00]; 
      r32_mux_0_data[18:08] = i_history_buffer_part2_5[18:08]; 
      r32_mux_0_data[19:19] = i_history_buffer_part2_5[19:19]; 
      r32_mux_0_data[20:20] = i_history_buffer_part2_5[20:20]; 
      r32_mux_0_data[21:21] = i_history_buffer_part2_5[21:21]; 
      r32_mux_0_data[31:22] = i_history_buffer_part2_5[31:22]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART1_5: begin
      r32_mux_0_data[31:00] = i_history_buffer_part1_5[31:00]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART0_5: begin
      r32_mux_0_data[31:00] = i_history_buffer_part0_5[31:00]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART2_6: begin
      r32_mux_0_data[07:00] = i_history_buffer_part2_6[07:00]; 
      r32_mux_0_data[18:08] = i_history_buffer_part2_6[18:08]; 
      r32_mux_0_data[19:19] = i_history_buffer_part2_6[19:19]; 
      r32_mux_0_data[20:20] = i_history_buffer_part2_6[20:20]; 
      r32_mux_0_data[21:21] = i_history_buffer_part2_6[21:21]; 
      r32_mux_0_data[31:22] = i_history_buffer_part2_6[31:22]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART1_6: begin
      r32_mux_0_data[31:00] = i_history_buffer_part1_6[31:00]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART0_6: begin
      r32_mux_0_data[31:00] = i_history_buffer_part0_6[31:00]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART2_7: begin
      r32_mux_0_data[07:00] = i_history_buffer_part2_7[07:00]; 
      r32_mux_0_data[18:08] = i_history_buffer_part2_7[18:08]; 
      r32_mux_0_data[19:19] = i_history_buffer_part2_7[19:19]; 
      r32_mux_0_data[20:20] = i_history_buffer_part2_7[20:20]; 
      r32_mux_0_data[21:21] = i_history_buffer_part2_7[21:21]; 
      r32_mux_0_data[31:22] = i_history_buffer_part2_7[31:22]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART1_7: begin
      r32_mux_0_data[31:00] = i_history_buffer_part1_7[31:00]; 
    end
    `CR_CRCGC_HISTORY_BUFFER_PART0_7: begin
      r32_mux_0_data[31:00] = i_history_buffer_part0_7[31:00]; 
    end
    `CR_CRCGC_REGS_CRCGC_CTRL: begin
      r32_mux_0_data[00:00] = i_regs_crcgc_ctrl[00:00]; 
      r32_mux_0_data[01:01] = i_regs_crcgc_ctrl[01:01]; 
      r32_mux_0_data[31:02] = i_regs_crcgc_ctrl[31:02]; 
    end
    endcase

  end

  
  

  
  

  reg  [31:0]  f32_data;

  assign o_reg_wr_data = f32_data;

  
  

  
  assign       o_rd_data  = (o_ack  & ~n_write) ? r32_formatted_reg_data : { 32 { 1'b0 } };
  

  
  

  wire w_load_spare_config            = w_do_write & (ws_addr == `CR_CRCGC_SPARE_CONFIG);
  wire w_load_regs_tlv_parse_action_0 = w_do_write & (ws_addr == `CR_CRCGC_REGS_TLV_PARSE_ACTION_0);
  wire w_load_regs_tlv_parse_action_1 = w_do_write & (ws_addr == `CR_CRCGC_REGS_TLV_PARSE_ACTION_1);
  wire w_load_regs_crcgc_ctrl         = w_do_write & (ws_addr == `CR_CRCGC_REGS_CRCGC_CTRL);


  


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

    end
  end

  
  always_ff @(posedge clk) begin
    if (i_wr_strb)               f32_data       <= i_wr_data;

  end
  

  cr_crcgc_regs_flops u_cr_crcgc_regs_flops (
        .clk                                    ( clk ),
        .i_reset_                               ( i_reset_ ),
        .i_sw_init                              ( i_sw_init ),
        .o_spare_config                         ( o_spare_config ),
        .o_regs_tlv_parse_action_0              ( o_regs_tlv_parse_action_0 ),
        .o_regs_tlv_parse_action_1              ( o_regs_tlv_parse_action_1 ),
        .o_regs_crcgc_ctrl                      ( o_regs_crcgc_ctrl ),
        .w_load_spare_config                    ( w_load_spare_config ),
        .w_load_regs_tlv_parse_action_0         ( w_load_regs_tlv_parse_action_0 ),
        .w_load_regs_tlv_parse_action_1         ( w_load_regs_tlv_parse_action_1 ),
        .w_load_regs_crcgc_ctrl                 ( w_load_regs_crcgc_ctrl ),
        .f32_data                               ( f32_data )
  );

  

  

  `ifdef CR_CRCGC_DIGEST_794FB70BC64B4B4678BDE34F8517F7FB
  `else
    initial begin
      $display("Error: the core decode file (cr_crcgc_regs.sv) and include file (cr_crcgc.vh) were compiled");
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


module cr_crcgc_regs_flops (
  input                                       clk,
  input                                       i_reset_,
  input                                       i_sw_init,

  
  output reg [`CR_CRCGC_C_SPARE_T_DECL]       o_spare_config,
  output reg [`CR_CRCGC_C_REGS_TLV_PARSE_ACTION_31_0_T_DECL] o_regs_tlv_parse_action_0,
  output reg [`CR_CRCGC_C_REGS_TLV_PARSE_ACTION_63_32_T_DECL] o_regs_tlv_parse_action_1,
  output reg [`CR_CRCGC_C_CRCGC_CTRL_T_DECL]  o_regs_crcgc_ctrl,


  
  input                                       w_load_spare_config,
  input                                       w_load_regs_tlv_parse_action_0,
  input                                       w_load_regs_tlv_parse_action_1,
  input                                       w_load_regs_crcgc_ctrl,

  input      [31:0]                             f32_data
  );

  
  

  
  

  
  
  
  always_ff @(posedge clk or negedge i_reset_) begin
    if(~i_reset_) begin
      
      o_spare_config[31:00]            <= 32'd0; 
      o_regs_tlv_parse_action_0[01:00] <= 2'd1; 
      o_regs_tlv_parse_action_0[03:02] <= 2'd0; 
      o_regs_tlv_parse_action_0[05:04] <= 2'd1; 
      o_regs_tlv_parse_action_0[07:06] <= 2'd1; 
      o_regs_tlv_parse_action_0[09:08] <= 2'd1; 
      o_regs_tlv_parse_action_0[11:10] <= 2'd0; 
      o_regs_tlv_parse_action_0[13:12] <= 2'd2; 
      o_regs_tlv_parse_action_0[15:14] <= 2'd0; 
      o_regs_tlv_parse_action_0[17:16] <= 2'd1; 
      o_regs_tlv_parse_action_0[19:18] <= 2'd1; 
      o_regs_tlv_parse_action_0[21:20] <= 2'd1; 
      o_regs_tlv_parse_action_0[23:22] <= 2'd0; 
      o_regs_tlv_parse_action_0[25:24] <= 2'd0; 
      o_regs_tlv_parse_action_0[27:26] <= 2'd0; 
      o_regs_tlv_parse_action_0[29:28] <= 2'd0; 
      o_regs_tlv_parse_action_0[31:30] <= 2'd0; 
      o_regs_tlv_parse_action_1[01:00] <= 2'd0; 
      o_regs_tlv_parse_action_1[03:02] <= 2'd0; 
      o_regs_tlv_parse_action_1[05:04] <= 2'd0; 
      o_regs_tlv_parse_action_1[07:06] <= 2'd0; 
      o_regs_tlv_parse_action_1[09:08] <= 2'd1; 
      o_regs_tlv_parse_action_1[11:10] <= 2'd1; 
      o_regs_tlv_parse_action_1[13:12] <= 2'd0; 
      o_regs_tlv_parse_action_1[15:14] <= 2'd1; 
      o_regs_tlv_parse_action_1[17:16] <= 2'd1; 
      o_regs_tlv_parse_action_1[19:18] <= 2'd1; 
      o_regs_tlv_parse_action_1[21:20] <= 2'd1; 
      o_regs_tlv_parse_action_1[23:22] <= 2'd1; 
      o_regs_tlv_parse_action_1[25:24] <= 2'd1; 
      o_regs_tlv_parse_action_1[27:26] <= 2'd1; 
      o_regs_tlv_parse_action_1[29:28] <= 2'd1; 
      o_regs_tlv_parse_action_1[31:30] <= 2'd1; 
      o_regs_crcgc_ctrl[00:00]         <= 1'd1; 
      o_regs_crcgc_ctrl[01:01]         <= 1'd1; 
      o_regs_crcgc_ctrl[31:02]         <= 30'd0; 
    end
    else if(i_sw_init) begin
      
      o_spare_config[31:00]            <= 32'd0; 
      o_regs_tlv_parse_action_0[01:00] <= 2'd1; 
      o_regs_tlv_parse_action_0[03:02] <= 2'd0; 
      o_regs_tlv_parse_action_0[05:04] <= 2'd1; 
      o_regs_tlv_parse_action_0[07:06] <= 2'd1; 
      o_regs_tlv_parse_action_0[09:08] <= 2'd1; 
      o_regs_tlv_parse_action_0[11:10] <= 2'd0; 
      o_regs_tlv_parse_action_0[13:12] <= 2'd2; 
      o_regs_tlv_parse_action_0[15:14] <= 2'd0; 
      o_regs_tlv_parse_action_0[17:16] <= 2'd1; 
      o_regs_tlv_parse_action_0[19:18] <= 2'd1; 
      o_regs_tlv_parse_action_0[21:20] <= 2'd1; 
      o_regs_tlv_parse_action_0[23:22] <= 2'd0; 
      o_regs_tlv_parse_action_0[25:24] <= 2'd0; 
      o_regs_tlv_parse_action_0[27:26] <= 2'd0; 
      o_regs_tlv_parse_action_0[29:28] <= 2'd0; 
      o_regs_tlv_parse_action_0[31:30] <= 2'd0; 
      o_regs_tlv_parse_action_1[01:00] <= 2'd0; 
      o_regs_tlv_parse_action_1[03:02] <= 2'd0; 
      o_regs_tlv_parse_action_1[05:04] <= 2'd0; 
      o_regs_tlv_parse_action_1[07:06] <= 2'd0; 
      o_regs_tlv_parse_action_1[09:08] <= 2'd1; 
      o_regs_tlv_parse_action_1[11:10] <= 2'd1; 
      o_regs_tlv_parse_action_1[13:12] <= 2'd0; 
      o_regs_tlv_parse_action_1[15:14] <= 2'd1; 
      o_regs_tlv_parse_action_1[17:16] <= 2'd1; 
      o_regs_tlv_parse_action_1[19:18] <= 2'd1; 
      o_regs_tlv_parse_action_1[21:20] <= 2'd1; 
      o_regs_tlv_parse_action_1[23:22] <= 2'd1; 
      o_regs_tlv_parse_action_1[25:24] <= 2'd1; 
      o_regs_tlv_parse_action_1[27:26] <= 2'd1; 
      o_regs_tlv_parse_action_1[29:28] <= 2'd1; 
      o_regs_tlv_parse_action_1[31:30] <= 2'd1; 
      o_regs_crcgc_ctrl[00:00]         <= 1'd1; 
      o_regs_crcgc_ctrl[01:01]         <= 1'd1; 
      o_regs_crcgc_ctrl[31:02]         <= 30'd0; 
    end
    else begin
      if(w_load_spare_config)            o_spare_config[31:00]            <= f32_data[31:00]; 
      if(w_load_regs_tlv_parse_action_0) o_regs_tlv_parse_action_0[01:00] <= f32_data[01:00]; 
      if(w_load_regs_tlv_parse_action_0) o_regs_tlv_parse_action_0[03:02] <= f32_data[03:02]; 
      if(w_load_regs_tlv_parse_action_0) o_regs_tlv_parse_action_0[05:04] <= f32_data[05:04]; 
      if(w_load_regs_tlv_parse_action_0) o_regs_tlv_parse_action_0[07:06] <= f32_data[07:06]; 
      if(w_load_regs_tlv_parse_action_0) o_regs_tlv_parse_action_0[09:08] <= f32_data[09:08]; 
      if(w_load_regs_tlv_parse_action_0) o_regs_tlv_parse_action_0[11:10] <= f32_data[11:10]; 
      if(w_load_regs_tlv_parse_action_0) o_regs_tlv_parse_action_0[13:12] <= f32_data[13:12]; 
      if(w_load_regs_tlv_parse_action_0) o_regs_tlv_parse_action_0[15:14] <= f32_data[15:14]; 
      if(w_load_regs_tlv_parse_action_0) o_regs_tlv_parse_action_0[17:16] <= f32_data[17:16]; 
      if(w_load_regs_tlv_parse_action_0) o_regs_tlv_parse_action_0[19:18] <= f32_data[19:18]; 
      if(w_load_regs_tlv_parse_action_0) o_regs_tlv_parse_action_0[21:20] <= f32_data[21:20]; 
      if(w_load_regs_tlv_parse_action_0) o_regs_tlv_parse_action_0[23:22] <= f32_data[23:22]; 
      if(w_load_regs_tlv_parse_action_0) o_regs_tlv_parse_action_0[25:24] <= f32_data[25:24]; 
      if(w_load_regs_tlv_parse_action_0) o_regs_tlv_parse_action_0[27:26] <= f32_data[27:26]; 
      if(w_load_regs_tlv_parse_action_0) o_regs_tlv_parse_action_0[29:28] <= f32_data[29:28]; 
      if(w_load_regs_tlv_parse_action_0) o_regs_tlv_parse_action_0[31:30] <= f32_data[31:30]; 
      if(w_load_regs_tlv_parse_action_1) o_regs_tlv_parse_action_1[01:00] <= f32_data[01:00]; 
      if(w_load_regs_tlv_parse_action_1) o_regs_tlv_parse_action_1[03:02] <= f32_data[03:02]; 
      if(w_load_regs_tlv_parse_action_1) o_regs_tlv_parse_action_1[05:04] <= f32_data[05:04]; 
      if(w_load_regs_tlv_parse_action_1) o_regs_tlv_parse_action_1[07:06] <= f32_data[07:06]; 
      if(w_load_regs_tlv_parse_action_1) o_regs_tlv_parse_action_1[09:08] <= f32_data[09:08]; 
      if(w_load_regs_tlv_parse_action_1) o_regs_tlv_parse_action_1[11:10] <= f32_data[11:10]; 
      if(w_load_regs_tlv_parse_action_1) o_regs_tlv_parse_action_1[13:12] <= f32_data[13:12]; 
      if(w_load_regs_tlv_parse_action_1) o_regs_tlv_parse_action_1[15:14] <= f32_data[15:14]; 
      if(w_load_regs_tlv_parse_action_1) o_regs_tlv_parse_action_1[17:16] <= f32_data[17:16]; 
      if(w_load_regs_tlv_parse_action_1) o_regs_tlv_parse_action_1[19:18] <= f32_data[19:18]; 
      if(w_load_regs_tlv_parse_action_1) o_regs_tlv_parse_action_1[21:20] <= f32_data[21:20]; 
      if(w_load_regs_tlv_parse_action_1) o_regs_tlv_parse_action_1[23:22] <= f32_data[23:22]; 
      if(w_load_regs_tlv_parse_action_1) o_regs_tlv_parse_action_1[25:24] <= f32_data[25:24]; 
      if(w_load_regs_tlv_parse_action_1) o_regs_tlv_parse_action_1[27:26] <= f32_data[27:26]; 
      if(w_load_regs_tlv_parse_action_1) o_regs_tlv_parse_action_1[29:28] <= f32_data[29:28]; 
      if(w_load_regs_tlv_parse_action_1) o_regs_tlv_parse_action_1[31:30] <= f32_data[31:30]; 
      if(w_load_regs_crcgc_ctrl)         o_regs_crcgc_ctrl[00:00]         <= f32_data[00:00]; 
      if(w_load_regs_crcgc_ctrl)         o_regs_crcgc_ctrl[01:01]         <= f32_data[01:01]; 
      if(w_load_regs_crcgc_ctrl)         o_regs_crcgc_ctrl[31:02]         <= f32_data[31:02]; 
    end
  end
  

  

endmodule
