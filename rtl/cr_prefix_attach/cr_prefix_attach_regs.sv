/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











`include "cr_prefix_attach.vh"




module cr_prefix_attach_regs (
  input                                clk,
  input                                i_reset_,
  input                                i_sw_init,

  
  input      [`CR_PREFIX_ATTACH_DECL]  i_addr,
  input                                i_wr_strb,
  input      [31:0]                    i_wr_data,
  input                                i_rd_strb,
  output     [31:0]                    o_rd_data,
  output                               o_ack,
  output                               o_err_ack,

  
  output     [`CR_PREFIX_ATTACH_C_SPARE_T_DECL] o_spare_config,
  output     [`CR_PREFIX_ATTACH_C_REGS_CCEIP_TLV_PARSE_ACTION_31_0_T_DECL] o_regs_cceip_tlv_parse_action_0,
  output     [`CR_PREFIX_ATTACH_C_REGS_CCEIP_TLV_PARSE_ACTION_63_32_T_DECL] o_regs_cceip_tlv_parse_action_1,
  output     [`CR_PREFIX_ATTACH_C_PFD_PART0_T_DECL] o_pfdmem_ia_wdata_part0,
  output     [`CR_PREFIX_ATTACH_C_PFD_PART1_T_DECL] o_pfdmem_ia_wdata_part1,
  output     [`CR_PREFIX_ATTACH_C_PFDMEM_IA_CONFIG_T_DECL] o_pfdmem_ia_config,
  output     [`CR_PREFIX_ATTACH_C_PHD_PART0_T_DECL] o_phdmem_ia_wdata_part0,
  output     [`CR_PREFIX_ATTACH_C_PHD_PART1_T_DECL] o_phdmem_ia_wdata_part1,
  output     [`CR_PREFIX_ATTACH_C_PHDMEM_IA_CONFIG_T_DECL] o_phdmem_ia_config,
  output     [`CR_PREFIX_ATTACH_C_PREFIX_ATTACH_ERROR_CONTROL_T_DECL] o_regs_error_control,
  output     [`CR_PREFIX_ATTACH_C_REGS_CDDIP_TLV_PARSE_ACTION_31_0_T_DECL] o_regs_cddip_tlv_parse_action_0,
  output     [`CR_PREFIX_ATTACH_C_REGS_CDDIP_TLV_PARSE_ACTION_63_32_T_DECL] o_regs_cddip_tlv_parse_action_1,

  
  input      [`CR_PREFIX_ATTACH_C_REVID_T_DECL] i_revision_config,
  input      [`CR_PREFIX_ATTACH_C_SPARE_T_DECL] i_spare_config,
  input      [`CR_PREFIX_ATTACH_C_PFDMEM_IA_CAPABILITY_T_DECL] i_pfdmem_ia_capability,
  input      [`CR_PREFIX_ATTACH_C_PFDMEM_IA_STATUS_T_DECL] i_pfdmem_ia_status,
  input      [`CR_PREFIX_ATTACH_C_PFD_PART0_T_DECL] i_pfdmem_ia_rdata_part0,
  input      [`CR_PREFIX_ATTACH_C_PFD_PART1_T_DECL] i_pfdmem_ia_rdata_part1,
  input      [`CR_PREFIX_ATTACH_C_PHDMEM_IA_CAPABILITY_T_DECL] i_phdmem_ia_capability,
  input      [`CR_PREFIX_ATTACH_C_PHDMEM_IA_STATUS_T_DECL] i_phdmem_ia_status,
  input      [`CR_PREFIX_ATTACH_C_PHD_PART0_T_DECL] i_phdmem_ia_rdata_part0,
  input      [`CR_PREFIX_ATTACH_C_PHD_PART1_T_DECL] i_phdmem_ia_rdata_part1,
  input      [`CR_PREFIX_ATTACH_C_PREFIX_ATTACH_ERROR_CONTROL_T_DECL] i_regs_error_control,

  
  output reg                           o_reg_written,
  output reg                           o_reg_read,
  output     [31:0]                    o_reg_wr_data,
  output reg [`CR_PREFIX_ATTACH_DECL]  o_reg_addr
  );


  


  
  


  
  wire [`CR_PREFIX_ATTACH_DECL] ws_read_addr    = o_reg_addr;
  wire [`CR_PREFIX_ATTACH_DECL] ws_addr         = o_reg_addr;
  

  wire n_wr_strobe = i_wr_strb;
  wire n_rd_strobe = i_rd_strb;

  wire w_32b_aligned    = (o_reg_addr[1:0] == 2'h0);

  wire w_valid_rd_addr     = (w_32b_aligned && (ws_addr >= `CR_PREFIX_ATTACH_REVISION_CONFIG) && (ws_addr <= `CR_PREFIX_ATTACH_SPARE_CONFIG))
                          || (w_32b_aligned && (ws_addr >= `CR_PREFIX_ATTACH_REGS_CCEIP_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_PREFIX_ATTACH_REGS_ERROR_CONTROL))
                          || (w_32b_aligned && (ws_addr >= `CR_PREFIX_ATTACH_REGS_CDDIP_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_PREFIX_ATTACH_REGS_CDDIP_TLV_PARSE_ACTION_1));

  wire w_valid_wr_addr     = (w_32b_aligned && (ws_addr >= `CR_PREFIX_ATTACH_REVISION_CONFIG) && (ws_addr <= `CR_PREFIX_ATTACH_SPARE_CONFIG))
                          || (w_32b_aligned && (ws_addr >= `CR_PREFIX_ATTACH_REGS_CCEIP_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_PREFIX_ATTACH_REGS_ERROR_CONTROL))
                          || (w_32b_aligned && (ws_addr >= `CR_PREFIX_ATTACH_REGS_CDDIP_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_PREFIX_ATTACH_REGS_CDDIP_TLV_PARSE_ACTION_1));

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
    `CR_PREFIX_ATTACH_REVISION_CONFIG: begin
      r32_mux_0_data[07:00] = i_revision_config[07:00]; 
    end
    `CR_PREFIX_ATTACH_SPARE_CONFIG: begin
      r32_mux_0_data[31:00] = i_spare_config[31:00]; 
    end
    `CR_PREFIX_ATTACH_REGS_CCEIP_TLV_PARSE_ACTION_0: begin
      r32_mux_0_data[01:00] = o_regs_cceip_tlv_parse_action_0[01:00]; 
      r32_mux_0_data[03:02] = o_regs_cceip_tlv_parse_action_0[03:02]; 
      r32_mux_0_data[05:04] = o_regs_cceip_tlv_parse_action_0[05:04]; 
      r32_mux_0_data[07:06] = o_regs_cceip_tlv_parse_action_0[07:06]; 
      r32_mux_0_data[09:08] = o_regs_cceip_tlv_parse_action_0[09:08]; 
      r32_mux_0_data[11:10] = o_regs_cceip_tlv_parse_action_0[11:10]; 
      r32_mux_0_data[13:12] = o_regs_cceip_tlv_parse_action_0[13:12]; 
      r32_mux_0_data[15:14] = o_regs_cceip_tlv_parse_action_0[15:14]; 
      r32_mux_0_data[17:16] = o_regs_cceip_tlv_parse_action_0[17:16]; 
      r32_mux_0_data[19:18] = o_regs_cceip_tlv_parse_action_0[19:18]; 
      r32_mux_0_data[21:20] = o_regs_cceip_tlv_parse_action_0[21:20]; 
      r32_mux_0_data[23:22] = o_regs_cceip_tlv_parse_action_0[23:22]; 
      r32_mux_0_data[25:24] = o_regs_cceip_tlv_parse_action_0[25:24]; 
      r32_mux_0_data[27:26] = o_regs_cceip_tlv_parse_action_0[27:26]; 
      r32_mux_0_data[29:28] = o_regs_cceip_tlv_parse_action_0[29:28]; 
      r32_mux_0_data[31:30] = o_regs_cceip_tlv_parse_action_0[31:30]; 
    end
    `CR_PREFIX_ATTACH_REGS_CCEIP_TLV_PARSE_ACTION_1: begin
      r32_mux_0_data[01:00] = o_regs_cceip_tlv_parse_action_1[01:00]; 
      r32_mux_0_data[03:02] = o_regs_cceip_tlv_parse_action_1[03:02]; 
      r32_mux_0_data[05:04] = o_regs_cceip_tlv_parse_action_1[05:04]; 
      r32_mux_0_data[07:06] = o_regs_cceip_tlv_parse_action_1[07:06]; 
      r32_mux_0_data[09:08] = o_regs_cceip_tlv_parse_action_1[09:08]; 
      r32_mux_0_data[11:10] = o_regs_cceip_tlv_parse_action_1[11:10]; 
      r32_mux_0_data[13:12] = o_regs_cceip_tlv_parse_action_1[13:12]; 
      r32_mux_0_data[15:14] = o_regs_cceip_tlv_parse_action_1[15:14]; 
      r32_mux_0_data[17:16] = o_regs_cceip_tlv_parse_action_1[17:16]; 
      r32_mux_0_data[19:18] = o_regs_cceip_tlv_parse_action_1[19:18]; 
      r32_mux_0_data[21:20] = o_regs_cceip_tlv_parse_action_1[21:20]; 
      r32_mux_0_data[23:22] = o_regs_cceip_tlv_parse_action_1[23:22]; 
      r32_mux_0_data[25:24] = o_regs_cceip_tlv_parse_action_1[25:24]; 
      r32_mux_0_data[27:26] = o_regs_cceip_tlv_parse_action_1[27:26]; 
      r32_mux_0_data[29:28] = o_regs_cceip_tlv_parse_action_1[29:28]; 
      r32_mux_0_data[31:30] = o_regs_cceip_tlv_parse_action_1[31:30]; 
    end
    `CR_PREFIX_ATTACH_PFDMEM_IA_CAPABILITY: begin
      r32_mux_0_data[00:00] = i_pfdmem_ia_capability[00:00]; 
      r32_mux_0_data[01:01] = i_pfdmem_ia_capability[01:01]; 
      r32_mux_0_data[02:02] = i_pfdmem_ia_capability[02:02]; 
      r32_mux_0_data[03:03] = i_pfdmem_ia_capability[03:03]; 
      r32_mux_0_data[04:04] = i_pfdmem_ia_capability[04:04]; 
      r32_mux_0_data[05:05] = i_pfdmem_ia_capability[05:05]; 
      r32_mux_0_data[06:06] = i_pfdmem_ia_capability[06:06]; 
      r32_mux_0_data[07:07] = i_pfdmem_ia_capability[07:07]; 
      r32_mux_0_data[08:08] = i_pfdmem_ia_capability[08:08]; 
      r32_mux_0_data[09:09] = i_pfdmem_ia_capability[09:09]; 
      r32_mux_0_data[13:10] = i_pfdmem_ia_capability[13:10]; 
      r32_mux_0_data[14:14] = i_pfdmem_ia_capability[14:14]; 
      r32_mux_0_data[15:15] = i_pfdmem_ia_capability[15:15]; 
      r32_mux_0_data[31:28] = i_pfdmem_ia_capability[19:16]; 
    end
    `CR_PREFIX_ATTACH_PFDMEM_IA_STATUS: begin
      r32_mux_0_data[12:00] = i_pfdmem_ia_status[12:00]; 
      r32_mux_0_data[28:24] = i_pfdmem_ia_status[17:13]; 
      r32_mux_0_data[31:29] = i_pfdmem_ia_status[20:18]; 
    end
    `CR_PREFIX_ATTACH_PFDMEM_IA_WDATA_PART0: begin
      r32_mux_0_data[31:00] = o_pfdmem_ia_wdata_part0[31:00]; 
    end
    `CR_PREFIX_ATTACH_PFDMEM_IA_WDATA_PART1: begin
      r32_mux_0_data[31:00] = o_pfdmem_ia_wdata_part1[31:00]; 
    end
    `CR_PREFIX_ATTACH_PFDMEM_IA_CONFIG: begin
      r32_mux_0_data[12:00] = o_pfdmem_ia_config[12:00]; 
      r32_mux_0_data[31:28] = o_pfdmem_ia_config[16:13]; 
    end
    `CR_PREFIX_ATTACH_PFDMEM_IA_RDATA_PART0: begin
      r32_mux_0_data[31:00] = i_pfdmem_ia_rdata_part0[31:00]; 
    end
    `CR_PREFIX_ATTACH_PFDMEM_IA_RDATA_PART1: begin
      r32_mux_0_data[31:00] = i_pfdmem_ia_rdata_part1[31:00]; 
    end
    `CR_PREFIX_ATTACH_PHDMEM_IA_CAPABILITY: begin
      r32_mux_0_data[00:00] = i_phdmem_ia_capability[00:00]; 
      r32_mux_0_data[01:01] = i_phdmem_ia_capability[01:01]; 
      r32_mux_0_data[02:02] = i_phdmem_ia_capability[02:02]; 
      r32_mux_0_data[03:03] = i_phdmem_ia_capability[03:03]; 
      r32_mux_0_data[04:04] = i_phdmem_ia_capability[04:04]; 
      r32_mux_0_data[05:05] = i_phdmem_ia_capability[05:05]; 
      r32_mux_0_data[06:06] = i_phdmem_ia_capability[06:06]; 
      r32_mux_0_data[07:07] = i_phdmem_ia_capability[07:07]; 
      r32_mux_0_data[08:08] = i_phdmem_ia_capability[08:08]; 
      r32_mux_0_data[09:09] = i_phdmem_ia_capability[09:09]; 
      r32_mux_0_data[13:10] = i_phdmem_ia_capability[13:10]; 
      r32_mux_0_data[14:14] = i_phdmem_ia_capability[14:14]; 
      r32_mux_0_data[15:15] = i_phdmem_ia_capability[15:15]; 
      r32_mux_0_data[31:28] = i_phdmem_ia_capability[19:16]; 
    end
    `CR_PREFIX_ATTACH_PHDMEM_IA_STATUS: begin
      r32_mux_0_data[11:00] = i_phdmem_ia_status[11:00]; 
      r32_mux_0_data[28:24] = i_phdmem_ia_status[16:12]; 
      r32_mux_0_data[31:29] = i_phdmem_ia_status[19:17]; 
    end
    `CR_PREFIX_ATTACH_PHDMEM_IA_WDATA_PART0: begin
      r32_mux_0_data[31:00] = o_phdmem_ia_wdata_part0[31:00]; 
    end
    `CR_PREFIX_ATTACH_PHDMEM_IA_WDATA_PART1: begin
      r32_mux_0_data[31:00] = o_phdmem_ia_wdata_part1[31:00]; 
    end
    `CR_PREFIX_ATTACH_PHDMEM_IA_CONFIG: begin
      r32_mux_0_data[11:00] = o_phdmem_ia_config[11:00]; 
      r32_mux_0_data[31:28] = o_phdmem_ia_config[15:12]; 
    end
    `CR_PREFIX_ATTACH_PHDMEM_IA_RDATA_PART0: begin
      r32_mux_0_data[31:00] = i_phdmem_ia_rdata_part0[31:00]; 
    end
    `CR_PREFIX_ATTACH_PHDMEM_IA_RDATA_PART1: begin
      r32_mux_0_data[31:00] = i_phdmem_ia_rdata_part1[31:00]; 
    end
    `CR_PREFIX_ATTACH_REGS_ERROR_CONTROL: begin
      r32_mux_0_data[00:00] = i_regs_error_control[00:00]; 
      r32_mux_0_data[31:01] = i_regs_error_control[31:01]; 
    end
    `CR_PREFIX_ATTACH_REGS_CDDIP_TLV_PARSE_ACTION_0: begin
      r32_mux_0_data[01:00] = o_regs_cddip_tlv_parse_action_0[01:00]; 
      r32_mux_0_data[03:02] = o_regs_cddip_tlv_parse_action_0[03:02]; 
      r32_mux_0_data[05:04] = o_regs_cddip_tlv_parse_action_0[05:04]; 
      r32_mux_0_data[07:06] = o_regs_cddip_tlv_parse_action_0[07:06]; 
      r32_mux_0_data[09:08] = o_regs_cddip_tlv_parse_action_0[09:08]; 
      r32_mux_0_data[11:10] = o_regs_cddip_tlv_parse_action_0[11:10]; 
      r32_mux_0_data[13:12] = o_regs_cddip_tlv_parse_action_0[13:12]; 
      r32_mux_0_data[15:14] = o_regs_cddip_tlv_parse_action_0[15:14]; 
      r32_mux_0_data[17:16] = o_regs_cddip_tlv_parse_action_0[17:16]; 
      r32_mux_0_data[19:18] = o_regs_cddip_tlv_parse_action_0[19:18]; 
      r32_mux_0_data[21:20] = o_regs_cddip_tlv_parse_action_0[21:20]; 
      r32_mux_0_data[23:22] = o_regs_cddip_tlv_parse_action_0[23:22]; 
      r32_mux_0_data[25:24] = o_regs_cddip_tlv_parse_action_0[25:24]; 
      r32_mux_0_data[27:26] = o_regs_cddip_tlv_parse_action_0[27:26]; 
      r32_mux_0_data[29:28] = o_regs_cddip_tlv_parse_action_0[29:28]; 
      r32_mux_0_data[31:30] = o_regs_cddip_tlv_parse_action_0[31:30]; 
    end
    `CR_PREFIX_ATTACH_REGS_CDDIP_TLV_PARSE_ACTION_1: begin
      r32_mux_0_data[01:00] = o_regs_cddip_tlv_parse_action_1[01:00]; 
      r32_mux_0_data[03:02] = o_regs_cddip_tlv_parse_action_1[03:02]; 
      r32_mux_0_data[05:04] = o_regs_cddip_tlv_parse_action_1[05:04]; 
      r32_mux_0_data[07:06] = o_regs_cddip_tlv_parse_action_1[07:06]; 
      r32_mux_0_data[09:08] = o_regs_cddip_tlv_parse_action_1[09:08]; 
      r32_mux_0_data[11:10] = o_regs_cddip_tlv_parse_action_1[11:10]; 
      r32_mux_0_data[13:12] = o_regs_cddip_tlv_parse_action_1[13:12]; 
      r32_mux_0_data[15:14] = o_regs_cddip_tlv_parse_action_1[15:14]; 
      r32_mux_0_data[17:16] = o_regs_cddip_tlv_parse_action_1[17:16]; 
      r32_mux_0_data[19:18] = o_regs_cddip_tlv_parse_action_1[19:18]; 
      r32_mux_0_data[21:20] = o_regs_cddip_tlv_parse_action_1[21:20]; 
      r32_mux_0_data[23:22] = o_regs_cddip_tlv_parse_action_1[23:22]; 
      r32_mux_0_data[25:24] = o_regs_cddip_tlv_parse_action_1[25:24]; 
      r32_mux_0_data[27:26] = o_regs_cddip_tlv_parse_action_1[27:26]; 
      r32_mux_0_data[29:28] = o_regs_cddip_tlv_parse_action_1[29:28]; 
      r32_mux_0_data[31:30] = o_regs_cddip_tlv_parse_action_1[31:30]; 
    end
    endcase

  end

  
  

  
  

  reg  [31:0]  f32_data;

  assign o_reg_wr_data = f32_data;

  
  

  
  assign       o_rd_data  = (o_ack  & ~n_write) ? r32_formatted_reg_data : { 32 { 1'b0 } };
  

  
  

  wire w_load_spare_config                  = w_do_write & (ws_addr == `CR_PREFIX_ATTACH_SPARE_CONFIG);
  wire w_load_regs_cceip_tlv_parse_action_0 = w_do_write & (ws_addr == `CR_PREFIX_ATTACH_REGS_CCEIP_TLV_PARSE_ACTION_0);
  wire w_load_regs_cceip_tlv_parse_action_1 = w_do_write & (ws_addr == `CR_PREFIX_ATTACH_REGS_CCEIP_TLV_PARSE_ACTION_1);
  wire w_load_pfdmem_ia_wdata_part0         = w_do_write & (ws_addr == `CR_PREFIX_ATTACH_PFDMEM_IA_WDATA_PART0);
  wire w_load_pfdmem_ia_wdata_part1         = w_do_write & (ws_addr == `CR_PREFIX_ATTACH_PFDMEM_IA_WDATA_PART1);
  wire w_load_pfdmem_ia_config              = w_do_write & (ws_addr == `CR_PREFIX_ATTACH_PFDMEM_IA_CONFIG);
  wire w_load_phdmem_ia_wdata_part0         = w_do_write & (ws_addr == `CR_PREFIX_ATTACH_PHDMEM_IA_WDATA_PART0);
  wire w_load_phdmem_ia_wdata_part1         = w_do_write & (ws_addr == `CR_PREFIX_ATTACH_PHDMEM_IA_WDATA_PART1);
  wire w_load_phdmem_ia_config              = w_do_write & (ws_addr == `CR_PREFIX_ATTACH_PHDMEM_IA_CONFIG);
  wire w_load_regs_error_control            = w_do_write & (ws_addr == `CR_PREFIX_ATTACH_REGS_ERROR_CONTROL);
  wire w_load_regs_cddip_tlv_parse_action_0 = w_do_write & (ws_addr == `CR_PREFIX_ATTACH_REGS_CDDIP_TLV_PARSE_ACTION_0);
  wire w_load_regs_cddip_tlv_parse_action_1 = w_do_write & (ws_addr == `CR_PREFIX_ATTACH_REGS_CDDIP_TLV_PARSE_ACTION_1);


  


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
  

  cr_prefix_attach_regs_flops u_cr_prefix_attach_regs_flops (
        .clk                                    ( clk ),
        .i_reset_                               ( i_reset_ ),
        .i_sw_init                              ( i_sw_init ),
        .o_spare_config                         ( o_spare_config ),
        .o_regs_cceip_tlv_parse_action_0        ( o_regs_cceip_tlv_parse_action_0 ),
        .o_regs_cceip_tlv_parse_action_1        ( o_regs_cceip_tlv_parse_action_1 ),
        .o_pfdmem_ia_wdata_part0                ( o_pfdmem_ia_wdata_part0 ),
        .o_pfdmem_ia_wdata_part1                ( o_pfdmem_ia_wdata_part1 ),
        .o_pfdmem_ia_config                     ( o_pfdmem_ia_config ),
        .o_phdmem_ia_wdata_part0                ( o_phdmem_ia_wdata_part0 ),
        .o_phdmem_ia_wdata_part1                ( o_phdmem_ia_wdata_part1 ),
        .o_phdmem_ia_config                     ( o_phdmem_ia_config ),
        .o_regs_error_control                   ( o_regs_error_control ),
        .o_regs_cddip_tlv_parse_action_0        ( o_regs_cddip_tlv_parse_action_0 ),
        .o_regs_cddip_tlv_parse_action_1        ( o_regs_cddip_tlv_parse_action_1 ),
        .w_load_spare_config                    ( w_load_spare_config ),
        .w_load_regs_cceip_tlv_parse_action_0   ( w_load_regs_cceip_tlv_parse_action_0 ),
        .w_load_regs_cceip_tlv_parse_action_1   ( w_load_regs_cceip_tlv_parse_action_1 ),
        .w_load_pfdmem_ia_wdata_part0           ( w_load_pfdmem_ia_wdata_part0 ),
        .w_load_pfdmem_ia_wdata_part1           ( w_load_pfdmem_ia_wdata_part1 ),
        .w_load_pfdmem_ia_config                ( w_load_pfdmem_ia_config ),
        .w_load_phdmem_ia_wdata_part0           ( w_load_phdmem_ia_wdata_part0 ),
        .w_load_phdmem_ia_wdata_part1           ( w_load_phdmem_ia_wdata_part1 ),
        .w_load_phdmem_ia_config                ( w_load_phdmem_ia_config ),
        .w_load_regs_error_control              ( w_load_regs_error_control ),
        .w_load_regs_cddip_tlv_parse_action_0   ( w_load_regs_cddip_tlv_parse_action_0 ),
        .w_load_regs_cddip_tlv_parse_action_1   ( w_load_regs_cddip_tlv_parse_action_1 ),
        .f32_data                               ( f32_data )
  );

  

  

  `ifdef CR_PREFIX_ATTACH_DIGEST_9CE9C3F960237F5068B8224348931AD8
  `else
    initial begin
      $display("Error: the core decode file (cr_prefix_attach_regs.sv) and include file (cr_prefix_attach.vh) were compiled");
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


module cr_prefix_attach_regs_flops (
  input  clk,
  input  i_reset_,
  input  i_sw_init,

  
  output reg [`CR_PREFIX_ATTACH_C_SPARE_T_DECL] o_spare_config,
  output reg [`CR_PREFIX_ATTACH_C_REGS_CCEIP_TLV_PARSE_ACTION_31_0_T_DECL] o_regs_cceip_tlv_parse_action_0,
  output reg [`CR_PREFIX_ATTACH_C_REGS_CCEIP_TLV_PARSE_ACTION_63_32_T_DECL] o_regs_cceip_tlv_parse_action_1,
  output reg [`CR_PREFIX_ATTACH_C_PFD_PART0_T_DECL] o_pfdmem_ia_wdata_part0,
  output reg [`CR_PREFIX_ATTACH_C_PFD_PART1_T_DECL] o_pfdmem_ia_wdata_part1,
  output reg [`CR_PREFIX_ATTACH_C_PFDMEM_IA_CONFIG_T_DECL] o_pfdmem_ia_config,
  output reg [`CR_PREFIX_ATTACH_C_PHD_PART0_T_DECL] o_phdmem_ia_wdata_part0,
  output reg [`CR_PREFIX_ATTACH_C_PHD_PART1_T_DECL] o_phdmem_ia_wdata_part1,
  output reg [`CR_PREFIX_ATTACH_C_PHDMEM_IA_CONFIG_T_DECL] o_phdmem_ia_config,
  output reg [`CR_PREFIX_ATTACH_C_PREFIX_ATTACH_ERROR_CONTROL_T_DECL] o_regs_error_control,
  output reg [`CR_PREFIX_ATTACH_C_REGS_CDDIP_TLV_PARSE_ACTION_31_0_T_DECL] o_regs_cddip_tlv_parse_action_0,
  output reg [`CR_PREFIX_ATTACH_C_REGS_CDDIP_TLV_PARSE_ACTION_63_32_T_DECL] o_regs_cddip_tlv_parse_action_1,


  
  input  w_load_spare_config,
  input  w_load_regs_cceip_tlv_parse_action_0,
  input  w_load_regs_cceip_tlv_parse_action_1,
  input  w_load_pfdmem_ia_wdata_part0,
  input  w_load_pfdmem_ia_wdata_part1,
  input  w_load_pfdmem_ia_config,
  input  w_load_phdmem_ia_wdata_part0,
  input  w_load_phdmem_ia_wdata_part1,
  input  w_load_phdmem_ia_config,
  input  w_load_regs_error_control,
  input  w_load_regs_cddip_tlv_parse_action_0,
  input  w_load_regs_cddip_tlv_parse_action_1,

  input      [31:0]                             f32_data
  );

  
  

  
  

  
  
  
  always_ff @(posedge clk or negedge i_reset_) begin
    if(~i_reset_) begin
      
      o_spare_config[31:00]                  <= 32'd0; 
      o_regs_cceip_tlv_parse_action_0[01:00] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[03:02] <= 2'd0; 
      o_regs_cceip_tlv_parse_action_0[05:04] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[07:06] <= 2'd2; 
      o_regs_cceip_tlv_parse_action_0[09:08] <= 2'd2; 
      o_regs_cceip_tlv_parse_action_0[11:10] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[13:12] <= 2'd2; 
      o_regs_cceip_tlv_parse_action_0[15:14] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[17:16] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[19:18] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[21:20] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[23:22] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[25:24] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[27:26] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[29:28] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[31:30] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[01:00] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[03:02] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[05:04] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[07:06] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[09:08] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[11:10] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[13:12] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[15:14] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[17:16] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[19:18] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[21:20] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[23:22] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[25:24] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[27:26] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[29:28] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[31:30] <= 2'd1; 
      o_pfdmem_ia_wdata_part0[31:00]         <= 32'd0; 
      o_pfdmem_ia_wdata_part1[31:00]         <= 32'd0; 
      o_pfdmem_ia_config[12:00]              <= 13'd0; 
      o_pfdmem_ia_config[16:13]              <= 4'd0; 
      o_phdmem_ia_wdata_part0[31:00]         <= 32'd0; 
      o_phdmem_ia_wdata_part1[31:00]         <= 32'd0; 
      o_phdmem_ia_config[11:00]              <= 12'd0; 
      o_phdmem_ia_config[15:12]              <= 4'd0; 
      o_regs_error_control[00:00]            <= 1'd1; 
      o_regs_error_control[31:01]            <= 31'd0; 
      o_regs_cddip_tlv_parse_action_0[01:00] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[03:02] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[05:04] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[07:06] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[09:08] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[11:10] <= 2'd2; 
      o_regs_cddip_tlv_parse_action_0[13:12] <= 2'd2; 
      o_regs_cddip_tlv_parse_action_0[15:14] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[17:16] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[19:18] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[21:20] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[23:22] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[25:24] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[27:26] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[29:28] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[31:30] <= 2'd0; 
      o_regs_cddip_tlv_parse_action_1[01:00] <= 2'd0; 
      o_regs_cddip_tlv_parse_action_1[03:02] <= 2'd0; 
      o_regs_cddip_tlv_parse_action_1[05:04] <= 2'd0; 
      o_regs_cddip_tlv_parse_action_1[07:06] <= 2'd2; 
      o_regs_cddip_tlv_parse_action_1[09:08] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[11:10] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[13:12] <= 2'd0; 
      o_regs_cddip_tlv_parse_action_1[15:14] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[17:16] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[19:18] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[21:20] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[23:22] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[25:24] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[27:26] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[29:28] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[31:30] <= 2'd1; 
    end
    else if(i_sw_init) begin
      
      o_spare_config[31:00]                  <= 32'd0; 
      o_regs_cceip_tlv_parse_action_0[01:00] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[03:02] <= 2'd0; 
      o_regs_cceip_tlv_parse_action_0[05:04] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[07:06] <= 2'd2; 
      o_regs_cceip_tlv_parse_action_0[09:08] <= 2'd2; 
      o_regs_cceip_tlv_parse_action_0[11:10] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[13:12] <= 2'd2; 
      o_regs_cceip_tlv_parse_action_0[15:14] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[17:16] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[19:18] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[21:20] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[23:22] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[25:24] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[27:26] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[29:28] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_0[31:30] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[01:00] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[03:02] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[05:04] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[07:06] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[09:08] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[11:10] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[13:12] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[15:14] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[17:16] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[19:18] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[21:20] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[23:22] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[25:24] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[27:26] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[29:28] <= 2'd1; 
      o_regs_cceip_tlv_parse_action_1[31:30] <= 2'd1; 
      o_pfdmem_ia_wdata_part0[31:00]         <= 32'd0; 
      o_pfdmem_ia_wdata_part1[31:00]         <= 32'd0; 
      o_pfdmem_ia_config[12:00]              <= 13'd0; 
      o_pfdmem_ia_config[16:13]              <= 4'd0; 
      o_phdmem_ia_wdata_part0[31:00]         <= 32'd0; 
      o_phdmem_ia_wdata_part1[31:00]         <= 32'd0; 
      o_phdmem_ia_config[11:00]              <= 12'd0; 
      o_phdmem_ia_config[15:12]              <= 4'd0; 
      o_regs_error_control[00:00]            <= 1'd1; 
      o_regs_error_control[31:01]            <= 31'd0; 
      o_regs_cddip_tlv_parse_action_0[01:00] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[03:02] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[05:04] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[07:06] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[09:08] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[11:10] <= 2'd2; 
      o_regs_cddip_tlv_parse_action_0[13:12] <= 2'd2; 
      o_regs_cddip_tlv_parse_action_0[15:14] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[17:16] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[19:18] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[21:20] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[23:22] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[25:24] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[27:26] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[29:28] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_0[31:30] <= 2'd0; 
      o_regs_cddip_tlv_parse_action_1[01:00] <= 2'd0; 
      o_regs_cddip_tlv_parse_action_1[03:02] <= 2'd0; 
      o_regs_cddip_tlv_parse_action_1[05:04] <= 2'd0; 
      o_regs_cddip_tlv_parse_action_1[07:06] <= 2'd2; 
      o_regs_cddip_tlv_parse_action_1[09:08] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[11:10] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[13:12] <= 2'd0; 
      o_regs_cddip_tlv_parse_action_1[15:14] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[17:16] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[19:18] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[21:20] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[23:22] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[25:24] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[27:26] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[29:28] <= 2'd1; 
      o_regs_cddip_tlv_parse_action_1[31:30] <= 2'd1; 
    end
    else begin
      if(w_load_spare_config)                  o_spare_config[31:00]                  <= f32_data[31:00]; 
      if(w_load_regs_cceip_tlv_parse_action_0) o_regs_cceip_tlv_parse_action_0[01:00] <= f32_data[01:00]; 
      if(w_load_regs_cceip_tlv_parse_action_0) o_regs_cceip_tlv_parse_action_0[03:02] <= f32_data[03:02]; 
      if(w_load_regs_cceip_tlv_parse_action_0) o_regs_cceip_tlv_parse_action_0[05:04] <= f32_data[05:04]; 
      if(w_load_regs_cceip_tlv_parse_action_0) o_regs_cceip_tlv_parse_action_0[07:06] <= f32_data[07:06]; 
      if(w_load_regs_cceip_tlv_parse_action_0) o_regs_cceip_tlv_parse_action_0[09:08] <= f32_data[09:08]; 
      if(w_load_regs_cceip_tlv_parse_action_0) o_regs_cceip_tlv_parse_action_0[11:10] <= f32_data[11:10]; 
      if(w_load_regs_cceip_tlv_parse_action_0) o_regs_cceip_tlv_parse_action_0[13:12] <= f32_data[13:12]; 
      if(w_load_regs_cceip_tlv_parse_action_0) o_regs_cceip_tlv_parse_action_0[15:14] <= f32_data[15:14]; 
      if(w_load_regs_cceip_tlv_parse_action_0) o_regs_cceip_tlv_parse_action_0[17:16] <= f32_data[17:16]; 
      if(w_load_regs_cceip_tlv_parse_action_0) o_regs_cceip_tlv_parse_action_0[19:18] <= f32_data[19:18]; 
      if(w_load_regs_cceip_tlv_parse_action_0) o_regs_cceip_tlv_parse_action_0[21:20] <= f32_data[21:20]; 
      if(w_load_regs_cceip_tlv_parse_action_0) o_regs_cceip_tlv_parse_action_0[23:22] <= f32_data[23:22]; 
      if(w_load_regs_cceip_tlv_parse_action_0) o_regs_cceip_tlv_parse_action_0[25:24] <= f32_data[25:24]; 
      if(w_load_regs_cceip_tlv_parse_action_0) o_regs_cceip_tlv_parse_action_0[27:26] <= f32_data[27:26]; 
      if(w_load_regs_cceip_tlv_parse_action_0) o_regs_cceip_tlv_parse_action_0[29:28] <= f32_data[29:28]; 
      if(w_load_regs_cceip_tlv_parse_action_0) o_regs_cceip_tlv_parse_action_0[31:30] <= f32_data[31:30]; 
      if(w_load_regs_cceip_tlv_parse_action_1) o_regs_cceip_tlv_parse_action_1[01:00] <= f32_data[01:00]; 
      if(w_load_regs_cceip_tlv_parse_action_1) o_regs_cceip_tlv_parse_action_1[03:02] <= f32_data[03:02]; 
      if(w_load_regs_cceip_tlv_parse_action_1) o_regs_cceip_tlv_parse_action_1[05:04] <= f32_data[05:04]; 
      if(w_load_regs_cceip_tlv_parse_action_1) o_regs_cceip_tlv_parse_action_1[07:06] <= f32_data[07:06]; 
      if(w_load_regs_cceip_tlv_parse_action_1) o_regs_cceip_tlv_parse_action_1[09:08] <= f32_data[09:08]; 
      if(w_load_regs_cceip_tlv_parse_action_1) o_regs_cceip_tlv_parse_action_1[11:10] <= f32_data[11:10]; 
      if(w_load_regs_cceip_tlv_parse_action_1) o_regs_cceip_tlv_parse_action_1[13:12] <= f32_data[13:12]; 
      if(w_load_regs_cceip_tlv_parse_action_1) o_regs_cceip_tlv_parse_action_1[15:14] <= f32_data[15:14]; 
      if(w_load_regs_cceip_tlv_parse_action_1) o_regs_cceip_tlv_parse_action_1[17:16] <= f32_data[17:16]; 
      if(w_load_regs_cceip_tlv_parse_action_1) o_regs_cceip_tlv_parse_action_1[19:18] <= f32_data[19:18]; 
      if(w_load_regs_cceip_tlv_parse_action_1) o_regs_cceip_tlv_parse_action_1[21:20] <= f32_data[21:20]; 
      if(w_load_regs_cceip_tlv_parse_action_1) o_regs_cceip_tlv_parse_action_1[23:22] <= f32_data[23:22]; 
      if(w_load_regs_cceip_tlv_parse_action_1) o_regs_cceip_tlv_parse_action_1[25:24] <= f32_data[25:24]; 
      if(w_load_regs_cceip_tlv_parse_action_1) o_regs_cceip_tlv_parse_action_1[27:26] <= f32_data[27:26]; 
      if(w_load_regs_cceip_tlv_parse_action_1) o_regs_cceip_tlv_parse_action_1[29:28] <= f32_data[29:28]; 
      if(w_load_regs_cceip_tlv_parse_action_1) o_regs_cceip_tlv_parse_action_1[31:30] <= f32_data[31:30]; 
      if(w_load_pfdmem_ia_wdata_part0)         o_pfdmem_ia_wdata_part0[31:00]         <= f32_data[31:00]; 
      if(w_load_pfdmem_ia_wdata_part1)         o_pfdmem_ia_wdata_part1[31:00]         <= f32_data[31:00]; 
      if(w_load_pfdmem_ia_config)              o_pfdmem_ia_config[12:00]              <= f32_data[12:00]; 
      if(w_load_pfdmem_ia_config)              o_pfdmem_ia_config[16:13]              <= f32_data[31:28]; 
      if(w_load_phdmem_ia_wdata_part0)         o_phdmem_ia_wdata_part0[31:00]         <= f32_data[31:00]; 
      if(w_load_phdmem_ia_wdata_part1)         o_phdmem_ia_wdata_part1[31:00]         <= f32_data[31:00]; 
      if(w_load_phdmem_ia_config)              o_phdmem_ia_config[11:00]              <= f32_data[11:00]; 
      if(w_load_phdmem_ia_config)              o_phdmem_ia_config[15:12]              <= f32_data[31:28]; 
      if(w_load_regs_error_control)            o_regs_error_control[00:00]            <= f32_data[00:00]; 
      if(w_load_regs_error_control)            o_regs_error_control[31:01]            <= f32_data[31:01]; 
      if(w_load_regs_cddip_tlv_parse_action_0) o_regs_cddip_tlv_parse_action_0[01:00] <= f32_data[01:00]; 
      if(w_load_regs_cddip_tlv_parse_action_0) o_regs_cddip_tlv_parse_action_0[03:02] <= f32_data[03:02]; 
      if(w_load_regs_cddip_tlv_parse_action_0) o_regs_cddip_tlv_parse_action_0[05:04] <= f32_data[05:04]; 
      if(w_load_regs_cddip_tlv_parse_action_0) o_regs_cddip_tlv_parse_action_0[07:06] <= f32_data[07:06]; 
      if(w_load_regs_cddip_tlv_parse_action_0) o_regs_cddip_tlv_parse_action_0[09:08] <= f32_data[09:08]; 
      if(w_load_regs_cddip_tlv_parse_action_0) o_regs_cddip_tlv_parse_action_0[11:10] <= f32_data[11:10]; 
      if(w_load_regs_cddip_tlv_parse_action_0) o_regs_cddip_tlv_parse_action_0[13:12] <= f32_data[13:12]; 
      if(w_load_regs_cddip_tlv_parse_action_0) o_regs_cddip_tlv_parse_action_0[15:14] <= f32_data[15:14]; 
      if(w_load_regs_cddip_tlv_parse_action_0) o_regs_cddip_tlv_parse_action_0[17:16] <= f32_data[17:16]; 
      if(w_load_regs_cddip_tlv_parse_action_0) o_regs_cddip_tlv_parse_action_0[19:18] <= f32_data[19:18]; 
      if(w_load_regs_cddip_tlv_parse_action_0) o_regs_cddip_tlv_parse_action_0[21:20] <= f32_data[21:20]; 
      if(w_load_regs_cddip_tlv_parse_action_0) o_regs_cddip_tlv_parse_action_0[23:22] <= f32_data[23:22]; 
      if(w_load_regs_cddip_tlv_parse_action_0) o_regs_cddip_tlv_parse_action_0[25:24] <= f32_data[25:24]; 
      if(w_load_regs_cddip_tlv_parse_action_0) o_regs_cddip_tlv_parse_action_0[27:26] <= f32_data[27:26]; 
      if(w_load_regs_cddip_tlv_parse_action_0) o_regs_cddip_tlv_parse_action_0[29:28] <= f32_data[29:28]; 
      if(w_load_regs_cddip_tlv_parse_action_0) o_regs_cddip_tlv_parse_action_0[31:30] <= f32_data[31:30]; 
      if(w_load_regs_cddip_tlv_parse_action_1) o_regs_cddip_tlv_parse_action_1[01:00] <= f32_data[01:00]; 
      if(w_load_regs_cddip_tlv_parse_action_1) o_regs_cddip_tlv_parse_action_1[03:02] <= f32_data[03:02]; 
      if(w_load_regs_cddip_tlv_parse_action_1) o_regs_cddip_tlv_parse_action_1[05:04] <= f32_data[05:04]; 
      if(w_load_regs_cddip_tlv_parse_action_1) o_regs_cddip_tlv_parse_action_1[07:06] <= f32_data[07:06]; 
      if(w_load_regs_cddip_tlv_parse_action_1) o_regs_cddip_tlv_parse_action_1[09:08] <= f32_data[09:08]; 
      if(w_load_regs_cddip_tlv_parse_action_1) o_regs_cddip_tlv_parse_action_1[11:10] <= f32_data[11:10]; 
      if(w_load_regs_cddip_tlv_parse_action_1) o_regs_cddip_tlv_parse_action_1[13:12] <= f32_data[13:12]; 
      if(w_load_regs_cddip_tlv_parse_action_1) o_regs_cddip_tlv_parse_action_1[15:14] <= f32_data[15:14]; 
      if(w_load_regs_cddip_tlv_parse_action_1) o_regs_cddip_tlv_parse_action_1[17:16] <= f32_data[17:16]; 
      if(w_load_regs_cddip_tlv_parse_action_1) o_regs_cddip_tlv_parse_action_1[19:18] <= f32_data[19:18]; 
      if(w_load_regs_cddip_tlv_parse_action_1) o_regs_cddip_tlv_parse_action_1[21:20] <= f32_data[21:20]; 
      if(w_load_regs_cddip_tlv_parse_action_1) o_regs_cddip_tlv_parse_action_1[23:22] <= f32_data[23:22]; 
      if(w_load_regs_cddip_tlv_parse_action_1) o_regs_cddip_tlv_parse_action_1[25:24] <= f32_data[25:24]; 
      if(w_load_regs_cddip_tlv_parse_action_1) o_regs_cddip_tlv_parse_action_1[27:26] <= f32_data[27:26]; 
      if(w_load_regs_cddip_tlv_parse_action_1) o_regs_cddip_tlv_parse_action_1[29:28] <= f32_data[29:28]; 
      if(w_load_regs_cddip_tlv_parse_action_1) o_regs_cddip_tlv_parse_action_1[31:30] <= f32_data[31:30]; 
    end
  end
  

  

endmodule
