/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











`include "cr_lz77_comp.vh"




module cr_lz77_comp_regs (
  input                                      clk,
  input                                      i_reset_,
  input                                      i_sw_init,

  
  input      [`CR_LZ77_COMP_DECL]            i_addr,
  input                                      i_wr_strb,
  input      [31:0]                          i_wr_data,
  input                                      i_rd_strb,
  output     [31:0]                          o_rd_data,
  output                                     o_ack,
  output                                     o_err_ack,

  
  output     [`CR_LZ77_COMP_C_SPARE_T_DECL]  o_spare,
  output     [`CR_LZ77_COMP_C_TLV_PARSE_ACTION_15_0_T_DECL] o_tlv_parse_action_15_0,
  output     [`CR_LZ77_COMP_C_TLV_PARSE_ACTION_31_16_T_DECL] o_tlv_parse_action_31_16,
  output     [`CR_LZ77_COMP_C_COMPRESSION_CFG_T_DECL] o_compression_cfg,
  output     [`CR_LZ77_COMP_C_OUT_PART0_T_DECL] o_out_ia_wdata_part0,
  output     [`CR_LZ77_COMP_C_OUT_PART1_T_DECL] o_out_ia_wdata_part1,
  output     [`CR_LZ77_COMP_C_OUT_PART2_T_DECL] o_out_ia_wdata_part2,
  output     [`CR_LZ77_COMP_C_OUT_IA_CONFIG_T_DECL] o_out_ia_config,
  output     [`CR_LZ77_COMP_C_OUT_IM_CONFIG_T_DECL] o_out_im_config,
  output     [`CR_LZ77_COMP_C_OUT_IM_CONSUMED_T_DECL] o_out_im_read_done,
  output     [`CR_LZ77_COMP_C_POWER_CREDIT_BURST_T_DECL] o_power_credit_burst,

  
  input      [`CR_LZ77_COMP_C_REVID_T_DECL]  i_revid,
  input      [`CR_LZ77_COMP_C_SPARE_T_DECL]  i_spare,
  input      [`CR_LZ77_COMP_C_LZ77_COMP_DEBUG_STATUS_T_DECL] i_lz77_comp_debug_status,
  input      [`CR_LZ77_COMP_C_OUT_IA_CAPABILITY_T_DECL] i_out_ia_capability,
  input      [`CR_LZ77_COMP_C_OUT_IA_STATUS_T_DECL] i_out_ia_status,
  input      [`CR_LZ77_COMP_C_OUT_PART0_T_DECL] i_out_ia_rdata_part0,
  input      [`CR_LZ77_COMP_C_OUT_PART1_T_DECL] i_out_ia_rdata_part1,
  input      [`CR_LZ77_COMP_C_OUT_PART2_T_DECL] i_out_ia_rdata_part2,
  input      [`CR_LZ77_COMP_C_OUT_IM_STATUS_T_DECL] i_out_im_status,
  input      [`CR_LZ77_COMP_C_OUT_IM_CONSUMED_T_DECL] i_out_im_read_done,

  
  output reg                                 o_reg_written,
  output reg                                 o_reg_read,
  output     [31:0]                          o_reg_wr_data,
  output reg [`CR_LZ77_COMP_DECL]            o_reg_addr
  );


  


  
  


  
  wire [`CR_LZ77_COMP_DECL] ws_read_addr    = o_reg_addr;
  wire [`CR_LZ77_COMP_DECL] ws_addr         = o_reg_addr;
  

  wire n_wr_strobe = i_wr_strb;
  wire n_rd_strobe = i_rd_strb;

  wire w_32b_aligned    = (o_reg_addr[1:0] == 2'h0);

  wire w_valid_rd_addr     = (w_32b_aligned && (ws_addr >= `CR_LZ77_COMP_REVID) && (ws_addr <= `CR_LZ77_COMP_POWER_CREDIT_BURST));

  wire w_valid_wr_addr     = (w_32b_aligned && (ws_addr >= `CR_LZ77_COMP_REVID) && (ws_addr <= `CR_LZ77_COMP_POWER_CREDIT_BURST));

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
    `CR_LZ77_COMP_REVID: begin
      r32_mux_0_data[07:00] = i_revid[07:00]; 
    end
    `CR_LZ77_COMP_SPARE: begin
      r32_mux_0_data[31:00] = i_spare[31:00]; 
    end
    `CR_LZ77_COMP_TLV_PARSE_ACTION_15_0: begin
      r32_mux_0_data[01:00] = o_tlv_parse_action_15_0[01:00]; 
      r32_mux_0_data[03:02] = o_tlv_parse_action_15_0[03:02]; 
      r32_mux_0_data[05:04] = o_tlv_parse_action_15_0[05:04]; 
      r32_mux_0_data[07:06] = o_tlv_parse_action_15_0[07:06]; 
      r32_mux_0_data[09:08] = o_tlv_parse_action_15_0[09:08]; 
      r32_mux_0_data[11:10] = o_tlv_parse_action_15_0[11:10]; 
      r32_mux_0_data[13:12] = o_tlv_parse_action_15_0[13:12]; 
      r32_mux_0_data[15:14] = o_tlv_parse_action_15_0[15:14]; 
      r32_mux_0_data[17:16] = o_tlv_parse_action_15_0[17:16]; 
      r32_mux_0_data[19:18] = o_tlv_parse_action_15_0[19:18]; 
      r32_mux_0_data[21:20] = o_tlv_parse_action_15_0[21:20]; 
      r32_mux_0_data[23:22] = o_tlv_parse_action_15_0[23:22]; 
      r32_mux_0_data[25:24] = o_tlv_parse_action_15_0[25:24]; 
      r32_mux_0_data[27:26] = o_tlv_parse_action_15_0[27:26]; 
      r32_mux_0_data[29:28] = o_tlv_parse_action_15_0[29:28]; 
      r32_mux_0_data[31:30] = o_tlv_parse_action_15_0[31:30]; 
    end
    `CR_LZ77_COMP_TLV_PARSE_ACTION_31_16: begin
      r32_mux_0_data[01:00] = o_tlv_parse_action_31_16[01:00]; 
      r32_mux_0_data[03:02] = o_tlv_parse_action_31_16[03:02]; 
      r32_mux_0_data[05:04] = o_tlv_parse_action_31_16[05:04]; 
      r32_mux_0_data[07:06] = o_tlv_parse_action_31_16[07:06]; 
      r32_mux_0_data[09:08] = o_tlv_parse_action_31_16[09:08]; 
      r32_mux_0_data[11:10] = o_tlv_parse_action_31_16[11:10]; 
      r32_mux_0_data[13:12] = o_tlv_parse_action_31_16[13:12]; 
      r32_mux_0_data[15:14] = o_tlv_parse_action_31_16[15:14]; 
      r32_mux_0_data[17:16] = o_tlv_parse_action_31_16[17:16]; 
      r32_mux_0_data[19:18] = o_tlv_parse_action_31_16[19:18]; 
      r32_mux_0_data[21:20] = o_tlv_parse_action_31_16[21:20]; 
      r32_mux_0_data[23:22] = o_tlv_parse_action_31_16[23:22]; 
      r32_mux_0_data[25:24] = o_tlv_parse_action_31_16[25:24]; 
      r32_mux_0_data[27:26] = o_tlv_parse_action_31_16[27:26]; 
      r32_mux_0_data[29:28] = o_tlv_parse_action_31_16[29:28]; 
      r32_mux_0_data[31:30] = o_tlv_parse_action_31_16[31:30]; 
    end
    `CR_LZ77_COMP_COMPRESSION_CFG: begin
      r32_mux_0_data[00:00] = o_compression_cfg[00:00]; 
      r32_mux_0_data[17:01] = o_compression_cfg[17:01]; 
    end
    `CR_LZ77_COMP_LZ77_COMP_DEBUG_STATUS: begin
      r32_mux_0_data[03:00] = i_lz77_comp_debug_status[03:00]; 
      r32_mux_0_data[07:04] = i_lz77_comp_debug_status[07:04]; 
      r32_mux_0_data[09:08] = i_lz77_comp_debug_status[09:08]; 
      r32_mux_0_data[10:10] = i_lz77_comp_debug_status[10:10]; 
      r32_mux_0_data[12:11] = i_lz77_comp_debug_status[12:11]; 
      r32_mux_0_data[13:13] = i_lz77_comp_debug_status[13:13]; 
      r32_mux_0_data[14:14] = i_lz77_comp_debug_status[14:14]; 
    end
    `CR_LZ77_COMP_OUT_IA_CAPABILITY: begin
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
    `CR_LZ77_COMP_OUT_IA_STATUS: begin
      r32_mux_0_data[08:00] = i_out_ia_status[08:00]; 
      r32_mux_0_data[28:24] = i_out_ia_status[13:09]; 
      r32_mux_0_data[31:29] = i_out_ia_status[16:14]; 
    end
    `CR_LZ77_COMP_OUT_IA_WDATA_PART0: begin
      r32_mux_0_data[05:00] = o_out_ia_wdata_part0[05:00]; 
      r32_mux_0_data[13:06] = o_out_ia_wdata_part0[13:06]; 
      r32_mux_0_data[14:14] = o_out_ia_wdata_part0[14:14]; 
      r32_mux_0_data[22:15] = o_out_ia_wdata_part0[22:15]; 
      r32_mux_0_data[30:23] = o_out_ia_wdata_part0[30:23]; 
      r32_mux_0_data[31:31] = o_out_ia_wdata_part0[31:31]; 
    end
    `CR_LZ77_COMP_OUT_IA_WDATA_PART1: begin
      r32_mux_0_data[31:00] = o_out_ia_wdata_part1[31:00]; 
    end
    `CR_LZ77_COMP_OUT_IA_WDATA_PART2: begin
      r32_mux_0_data[31:00] = o_out_ia_wdata_part2[31:00]; 
    end
    `CR_LZ77_COMP_OUT_IA_CONFIG: begin
      r32_mux_0_data[08:00] = o_out_ia_config[08:00]; 
      r32_mux_0_data[31:28] = o_out_ia_config[12:09]; 
    end
    `CR_LZ77_COMP_OUT_IA_RDATA_PART0: begin
      r32_mux_0_data[05:00] = i_out_ia_rdata_part0[05:00]; 
      r32_mux_0_data[13:06] = i_out_ia_rdata_part0[13:06]; 
      r32_mux_0_data[14:14] = i_out_ia_rdata_part0[14:14]; 
      r32_mux_0_data[22:15] = i_out_ia_rdata_part0[22:15]; 
      r32_mux_0_data[30:23] = i_out_ia_rdata_part0[30:23]; 
      r32_mux_0_data[31:31] = i_out_ia_rdata_part0[31:31]; 
    end
    `CR_LZ77_COMP_OUT_IA_RDATA_PART1: begin
      r32_mux_0_data[31:00] = i_out_ia_rdata_part1[31:00]; 
    end
    `CR_LZ77_COMP_OUT_IA_RDATA_PART2: begin
      r32_mux_0_data[31:00] = i_out_ia_rdata_part2[31:00]; 
    end
    `CR_LZ77_COMP_OUT_IM_CONFIG: begin
      r32_mux_0_data[09:00] = o_out_im_config[09:00]; 
      r32_mux_0_data[31:30] = o_out_im_config[11:10]; 
    end
    `CR_LZ77_COMP_OUT_IM_STATUS: begin
      r32_mux_0_data[08:00] = i_out_im_status[08:00]; 
      r32_mux_0_data[29:29] = i_out_im_status[09:09]; 
      r32_mux_0_data[30:30] = i_out_im_status[10:10]; 
      r32_mux_0_data[31:31] = i_out_im_status[11:11]; 
    end
    `CR_LZ77_COMP_OUT_IM_READ_DONE: begin
      r32_mux_0_data[30:30] = i_out_im_read_done[00:00]; 
      r32_mux_0_data[31:31] = i_out_im_read_done[01:01]; 
    end
    `CR_LZ77_COMP_POWER_CREDIT_BURST: begin
      r32_mux_0_data[31:00] = o_power_credit_burst[31:00]; 
    end
    endcase

  end

  
  

  
  

  reg  [31:0]  f32_data;

  assign o_reg_wr_data = f32_data;

  
  

  
  assign       o_rd_data  = (o_ack  & ~n_write) ? r32_formatted_reg_data : { 32 { 1'b0 } };
  

  
  

  wire w_load_spare                  = w_do_write & (ws_addr == `CR_LZ77_COMP_SPARE);
  wire w_load_tlv_parse_action_15_0  = w_do_write & (ws_addr == `CR_LZ77_COMP_TLV_PARSE_ACTION_15_0);
  wire w_load_tlv_parse_action_31_16 = w_do_write & (ws_addr == `CR_LZ77_COMP_TLV_PARSE_ACTION_31_16);
  wire w_load_compression_cfg        = w_do_write & (ws_addr == `CR_LZ77_COMP_COMPRESSION_CFG);
  wire w_load_out_ia_wdata_part0     = w_do_write & (ws_addr == `CR_LZ77_COMP_OUT_IA_WDATA_PART0);
  wire w_load_out_ia_wdata_part1     = w_do_write & (ws_addr == `CR_LZ77_COMP_OUT_IA_WDATA_PART1);
  wire w_load_out_ia_wdata_part2     = w_do_write & (ws_addr == `CR_LZ77_COMP_OUT_IA_WDATA_PART2);
  wire w_load_out_ia_config          = w_do_write & (ws_addr == `CR_LZ77_COMP_OUT_IA_CONFIG);
  wire w_load_out_im_config          = w_do_write & (ws_addr == `CR_LZ77_COMP_OUT_IM_CONFIG);
  wire w_load_out_im_read_done       = w_do_write & (ws_addr == `CR_LZ77_COMP_OUT_IM_READ_DONE);
  wire w_load_power_credit_burst     = w_do_write & (ws_addr == `CR_LZ77_COMP_POWER_CREDIT_BURST);


  


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
  

  cr_lz77_comp_regs_flops u_cr_lz77_comp_regs_flops (
        .clk                                    ( clk ),
        .i_reset_                               ( i_reset_ ),
        .i_sw_init                              ( i_sw_init ),
        .o_spare                                ( o_spare ),
        .o_tlv_parse_action_15_0                ( o_tlv_parse_action_15_0 ),
        .o_tlv_parse_action_31_16               ( o_tlv_parse_action_31_16 ),
        .o_compression_cfg                      ( o_compression_cfg ),
        .o_out_ia_wdata_part0                   ( o_out_ia_wdata_part0 ),
        .o_out_ia_wdata_part1                   ( o_out_ia_wdata_part1 ),
        .o_out_ia_wdata_part2                   ( o_out_ia_wdata_part2 ),
        .o_out_ia_config                        ( o_out_ia_config ),
        .o_out_im_config                        ( o_out_im_config ),
        .o_out_im_read_done                     ( o_out_im_read_done ),
        .o_power_credit_burst                   ( o_power_credit_burst ),
        .w_load_spare                           ( w_load_spare ),
        .w_load_tlv_parse_action_15_0           ( w_load_tlv_parse_action_15_0 ),
        .w_load_tlv_parse_action_31_16          ( w_load_tlv_parse_action_31_16 ),
        .w_load_compression_cfg                 ( w_load_compression_cfg ),
        .w_load_out_ia_wdata_part0              ( w_load_out_ia_wdata_part0 ),
        .w_load_out_ia_wdata_part1              ( w_load_out_ia_wdata_part1 ),
        .w_load_out_ia_wdata_part2              ( w_load_out_ia_wdata_part2 ),
        .w_load_out_ia_config                   ( w_load_out_ia_config ),
        .w_load_out_im_config                   ( w_load_out_im_config ),
        .w_load_out_im_read_done                ( w_load_out_im_read_done ),
        .w_load_power_credit_burst              ( w_load_power_credit_burst ),
        .f32_data                               ( f32_data )
  );

  

  

  `ifdef CR_LZ77_COMP_DIGEST_889EED44749447E5BFCF1D192F166C23
  `else
    initial begin
      $display("Error: the core decode file (cr_lz77_comp_regs.sv) and include file (cr_lz77_comp.vh) were compiled");
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


module cr_lz77_comp_regs_flops (
  input                                      clk,
  input                                      i_reset_,
  input                                      i_sw_init,

  
  output reg [`CR_LZ77_COMP_C_SPARE_T_DECL]  o_spare,
  output reg [`CR_LZ77_COMP_C_TLV_PARSE_ACTION_15_0_T_DECL] o_tlv_parse_action_15_0,
  output reg [`CR_LZ77_COMP_C_TLV_PARSE_ACTION_31_16_T_DECL] o_tlv_parse_action_31_16,
  output reg [`CR_LZ77_COMP_C_COMPRESSION_CFG_T_DECL] o_compression_cfg,
  output reg [`CR_LZ77_COMP_C_OUT_PART0_T_DECL] o_out_ia_wdata_part0,
  output reg [`CR_LZ77_COMP_C_OUT_PART1_T_DECL] o_out_ia_wdata_part1,
  output reg [`CR_LZ77_COMP_C_OUT_PART2_T_DECL] o_out_ia_wdata_part2,
  output reg [`CR_LZ77_COMP_C_OUT_IA_CONFIG_T_DECL] o_out_ia_config,
  output reg [`CR_LZ77_COMP_C_OUT_IM_CONFIG_T_DECL] o_out_im_config,
  output reg [`CR_LZ77_COMP_C_OUT_IM_CONSUMED_T_DECL] o_out_im_read_done,
  output reg [`CR_LZ77_COMP_C_POWER_CREDIT_BURST_T_DECL] o_power_credit_burst,


  
  input                                      w_load_spare,
  input                                      w_load_tlv_parse_action_15_0,
  input                                      w_load_tlv_parse_action_31_16,
  input                                      w_load_compression_cfg,
  input                                      w_load_out_ia_wdata_part0,
  input                                      w_load_out_ia_wdata_part1,
  input                                      w_load_out_ia_wdata_part2,
  input                                      w_load_out_ia_config,
  input                                      w_load_out_im_config,
  input                                      w_load_out_im_read_done,
  input                                      w_load_power_credit_burst,

  input      [31:0]                             f32_data
  );

  
  

  
  

  
  
  
  always_ff @(posedge clk or negedge i_reset_) begin
    if(~i_reset_) begin
      
      o_spare[31:00]                  <= 32'd0; 
      o_tlv_parse_action_15_0[01:00]  <= 2'd1; 
      o_tlv_parse_action_15_0[03:02]  <= 2'd0; 
      o_tlv_parse_action_15_0[05:04]  <= 2'd1; 
      o_tlv_parse_action_15_0[07:06]  <= 2'd1; 
      o_tlv_parse_action_15_0[09:08]  <= 2'd0; 
      o_tlv_parse_action_15_0[11:10]  <= 2'd2; 
      o_tlv_parse_action_15_0[13:12]  <= 2'd2; 
      o_tlv_parse_action_15_0[15:14]  <= 2'd1; 
      o_tlv_parse_action_15_0[17:16]  <= 2'd1; 
      o_tlv_parse_action_15_0[19:18]  <= 2'd1; 
      o_tlv_parse_action_15_0[21:20]  <= 2'd1; 
      o_tlv_parse_action_15_0[23:22]  <= 2'd1; 
      o_tlv_parse_action_15_0[25:24]  <= 2'd1; 
      o_tlv_parse_action_15_0[27:26]  <= 2'd1; 
      o_tlv_parse_action_15_0[29:28]  <= 2'd1; 
      o_tlv_parse_action_15_0[31:30]  <= 2'd1; 
      o_tlv_parse_action_31_16[01:00] <= 2'd1; 
      o_tlv_parse_action_31_16[03:02] <= 2'd1; 
      o_tlv_parse_action_31_16[05:04] <= 2'd1; 
      o_tlv_parse_action_31_16[07:06] <= 2'd2; 
      o_tlv_parse_action_31_16[09:08] <= 2'd1; 
      o_tlv_parse_action_31_16[11:10] <= 2'd1; 
      o_tlv_parse_action_31_16[13:12] <= 2'd1; 
      o_tlv_parse_action_31_16[15:14] <= 2'd1; 
      o_tlv_parse_action_31_16[17:16] <= 2'd1; 
      o_tlv_parse_action_31_16[19:18] <= 2'd1; 
      o_tlv_parse_action_31_16[21:20] <= 2'd1; 
      o_tlv_parse_action_31_16[23:22] <= 2'd1; 
      o_tlv_parse_action_31_16[25:24] <= 2'd1; 
      o_tlv_parse_action_31_16[27:26] <= 2'd1; 
      o_tlv_parse_action_31_16[29:28] <= 2'd1; 
      o_tlv_parse_action_31_16[31:30] <= 2'd1; 
      o_compression_cfg[00:00]        <= 1'd1; 
      o_compression_cfg[17:01]        <= 17'd65536; 
      o_out_ia_wdata_part0[05:00]     <= 6'd0; 
      o_out_ia_wdata_part1[31:00]     <= 32'd0; 
      o_out_ia_wdata_part2[31:00]     <= 32'd0; 
      o_out_ia_config[08:00]          <= 9'd0; 
      o_out_ia_config[12:09]          <= 4'd0; 
      o_out_im_config[09:00]          <= 10'd512; 
      o_out_im_config[11:10]          <= 2'd3; 
      o_out_im_read_done[00:00]       <= 1'd0; 
      o_out_im_read_done[01:01]       <= 1'd0; 
      o_power_credit_burst[31:00]     <= 32'd0; 
    end
    else if(i_sw_init) begin
      
      o_spare[31:00]                  <= 32'd0; 
      o_tlv_parse_action_15_0[01:00]  <= 2'd1; 
      o_tlv_parse_action_15_0[03:02]  <= 2'd0; 
      o_tlv_parse_action_15_0[05:04]  <= 2'd1; 
      o_tlv_parse_action_15_0[07:06]  <= 2'd1; 
      o_tlv_parse_action_15_0[09:08]  <= 2'd0; 
      o_tlv_parse_action_15_0[11:10]  <= 2'd2; 
      o_tlv_parse_action_15_0[13:12]  <= 2'd2; 
      o_tlv_parse_action_15_0[15:14]  <= 2'd1; 
      o_tlv_parse_action_15_0[17:16]  <= 2'd1; 
      o_tlv_parse_action_15_0[19:18]  <= 2'd1; 
      o_tlv_parse_action_15_0[21:20]  <= 2'd1; 
      o_tlv_parse_action_15_0[23:22]  <= 2'd1; 
      o_tlv_parse_action_15_0[25:24]  <= 2'd1; 
      o_tlv_parse_action_15_0[27:26]  <= 2'd1; 
      o_tlv_parse_action_15_0[29:28]  <= 2'd1; 
      o_tlv_parse_action_15_0[31:30]  <= 2'd1; 
      o_tlv_parse_action_31_16[01:00] <= 2'd1; 
      o_tlv_parse_action_31_16[03:02] <= 2'd1; 
      o_tlv_parse_action_31_16[05:04] <= 2'd1; 
      o_tlv_parse_action_31_16[07:06] <= 2'd2; 
      o_tlv_parse_action_31_16[09:08] <= 2'd1; 
      o_tlv_parse_action_31_16[11:10] <= 2'd1; 
      o_tlv_parse_action_31_16[13:12] <= 2'd1; 
      o_tlv_parse_action_31_16[15:14] <= 2'd1; 
      o_tlv_parse_action_31_16[17:16] <= 2'd1; 
      o_tlv_parse_action_31_16[19:18] <= 2'd1; 
      o_tlv_parse_action_31_16[21:20] <= 2'd1; 
      o_tlv_parse_action_31_16[23:22] <= 2'd1; 
      o_tlv_parse_action_31_16[25:24] <= 2'd1; 
      o_tlv_parse_action_31_16[27:26] <= 2'd1; 
      o_tlv_parse_action_31_16[29:28] <= 2'd1; 
      o_tlv_parse_action_31_16[31:30] <= 2'd1; 
      o_compression_cfg[00:00]        <= 1'd1; 
      o_compression_cfg[17:01]        <= 17'd65536; 
      o_out_ia_wdata_part0[05:00]     <= 6'd0; 
      o_out_ia_wdata_part1[31:00]     <= 32'd0; 
      o_out_ia_wdata_part2[31:00]     <= 32'd0; 
      o_out_ia_config[08:00]          <= 9'd0; 
      o_out_ia_config[12:09]          <= 4'd0; 
      o_out_im_config[09:00]          <= 10'd512; 
      o_out_im_config[11:10]          <= 2'd3; 
      o_out_im_read_done[00:00]       <= 1'd0; 
      o_out_im_read_done[01:01]       <= 1'd0; 
      o_power_credit_burst[31:00]     <= 32'd0; 
    end
    else begin
      if(w_load_spare)                  o_spare[31:00]                  <= f32_data[31:00]; 
      if(w_load_tlv_parse_action_15_0)  o_tlv_parse_action_15_0[01:00]  <= f32_data[01:00]; 
      if(w_load_tlv_parse_action_15_0)  o_tlv_parse_action_15_0[03:02]  <= f32_data[03:02]; 
      if(w_load_tlv_parse_action_15_0)  o_tlv_parse_action_15_0[05:04]  <= f32_data[05:04]; 
      if(w_load_tlv_parse_action_15_0)  o_tlv_parse_action_15_0[07:06]  <= f32_data[07:06]; 
      if(w_load_tlv_parse_action_15_0)  o_tlv_parse_action_15_0[09:08]  <= f32_data[09:08]; 
      if(w_load_tlv_parse_action_15_0)  o_tlv_parse_action_15_0[11:10]  <= f32_data[11:10]; 
      if(w_load_tlv_parse_action_15_0)  o_tlv_parse_action_15_0[13:12]  <= f32_data[13:12]; 
      if(w_load_tlv_parse_action_15_0)  o_tlv_parse_action_15_0[15:14]  <= f32_data[15:14]; 
      if(w_load_tlv_parse_action_15_0)  o_tlv_parse_action_15_0[17:16]  <= f32_data[17:16]; 
      if(w_load_tlv_parse_action_15_0)  o_tlv_parse_action_15_0[19:18]  <= f32_data[19:18]; 
      if(w_load_tlv_parse_action_15_0)  o_tlv_parse_action_15_0[21:20]  <= f32_data[21:20]; 
      if(w_load_tlv_parse_action_15_0)  o_tlv_parse_action_15_0[23:22]  <= f32_data[23:22]; 
      if(w_load_tlv_parse_action_15_0)  o_tlv_parse_action_15_0[25:24]  <= f32_data[25:24]; 
      if(w_load_tlv_parse_action_15_0)  o_tlv_parse_action_15_0[27:26]  <= f32_data[27:26]; 
      if(w_load_tlv_parse_action_15_0)  o_tlv_parse_action_15_0[29:28]  <= f32_data[29:28]; 
      if(w_load_tlv_parse_action_15_0)  o_tlv_parse_action_15_0[31:30]  <= f32_data[31:30]; 
      if(w_load_tlv_parse_action_31_16) o_tlv_parse_action_31_16[01:00] <= f32_data[01:00]; 
      if(w_load_tlv_parse_action_31_16) o_tlv_parse_action_31_16[03:02] <= f32_data[03:02]; 
      if(w_load_tlv_parse_action_31_16) o_tlv_parse_action_31_16[05:04] <= f32_data[05:04]; 
      if(w_load_tlv_parse_action_31_16) o_tlv_parse_action_31_16[07:06] <= f32_data[07:06]; 
      if(w_load_tlv_parse_action_31_16) o_tlv_parse_action_31_16[09:08] <= f32_data[09:08]; 
      if(w_load_tlv_parse_action_31_16) o_tlv_parse_action_31_16[11:10] <= f32_data[11:10]; 
      if(w_load_tlv_parse_action_31_16) o_tlv_parse_action_31_16[13:12] <= f32_data[13:12]; 
      if(w_load_tlv_parse_action_31_16) o_tlv_parse_action_31_16[15:14] <= f32_data[15:14]; 
      if(w_load_tlv_parse_action_31_16) o_tlv_parse_action_31_16[17:16] <= f32_data[17:16]; 
      if(w_load_tlv_parse_action_31_16) o_tlv_parse_action_31_16[19:18] <= f32_data[19:18]; 
      if(w_load_tlv_parse_action_31_16) o_tlv_parse_action_31_16[21:20] <= f32_data[21:20]; 
      if(w_load_tlv_parse_action_31_16) o_tlv_parse_action_31_16[23:22] <= f32_data[23:22]; 
      if(w_load_tlv_parse_action_31_16) o_tlv_parse_action_31_16[25:24] <= f32_data[25:24]; 
      if(w_load_tlv_parse_action_31_16) o_tlv_parse_action_31_16[27:26] <= f32_data[27:26]; 
      if(w_load_tlv_parse_action_31_16) o_tlv_parse_action_31_16[29:28] <= f32_data[29:28]; 
      if(w_load_tlv_parse_action_31_16) o_tlv_parse_action_31_16[31:30] <= f32_data[31:30]; 
      if(w_load_compression_cfg)        o_compression_cfg[00:00]        <= f32_data[00:00]; 
      if(w_load_compression_cfg)        o_compression_cfg[17:01]        <= f32_data[17:01]; 
      if(w_load_out_ia_wdata_part0)     o_out_ia_wdata_part0[05:00]     <= f32_data[05:00]; 
      if(w_load_out_ia_wdata_part1)     o_out_ia_wdata_part1[31:00]     <= f32_data[31:00]; 
      if(w_load_out_ia_wdata_part2)     o_out_ia_wdata_part2[31:00]     <= f32_data[31:00]; 
      if(w_load_out_ia_config)          o_out_ia_config[08:00]          <= f32_data[08:00]; 
      if(w_load_out_ia_config)          o_out_ia_config[12:09]          <= f32_data[31:28]; 
      if(w_load_out_im_config)          o_out_im_config[09:00]          <= f32_data[09:00]; 
      if(w_load_out_im_config)          o_out_im_config[11:10]          <= f32_data[31:30]; 
      if(w_load_out_im_read_done)       o_out_im_read_done[00:00]       <= f32_data[30:30]; 
      if(w_load_out_im_read_done)       o_out_im_read_done[01:01]       <= f32_data[31:31]; 
      if(w_load_power_credit_burst)     o_power_credit_burst[31:00]     <= f32_data[31:00]; 
    end
  end

  
  
  
  always_ff @(posedge clk) begin
      if(w_load_out_ia_wdata_part0)     o_out_ia_wdata_part0[13:06]     <= f32_data[13:06]; 
      if(w_load_out_ia_wdata_part0)     o_out_ia_wdata_part0[14:14]     <= f32_data[14:14]; 
      if(w_load_out_ia_wdata_part0)     o_out_ia_wdata_part0[22:15]     <= f32_data[22:15]; 
      if(w_load_out_ia_wdata_part0)     o_out_ia_wdata_part0[30:23]     <= f32_data[30:23]; 
      if(w_load_out_ia_wdata_part0)     o_out_ia_wdata_part0[31:31]     <= f32_data[31:31]; 
  end
  

  

endmodule
