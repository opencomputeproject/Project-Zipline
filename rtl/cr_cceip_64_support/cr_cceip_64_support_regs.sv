/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











`include "cr_cceip_64_support.vh"




module cr_cceip_64_support_regs (
  input                                   clk,
  input                                   i_reset_,
  input                                   i_sw_init,

  
  input      [`CR_CCEIP_64_SUPPORT_DECL]  i_addr,
  input                                   i_wr_strb,
  input      [31:0]                       i_wr_data,
  input                                   i_rd_strb,
  output     [31:0]                       o_rd_data,
  output                                  o_ack,
  output                                  o_err_ack,

  
  output     [`CR_CCEIP_64_SUPPORT_C_SPARE_T_DECL] o_spare_config,
  output     [`CR_CCEIP_64_SUPPORT_C_IM_CONSUMED_T_DECL] o_im_consumed,
  output     [`CR_CCEIP_64_SUPPORT_C_SOFT_RST_T_DECL] o_soft_rst,
  output     [`CR_CCEIP_64_SUPPORT_C_CTL_T_DECL] o_ctl,
  output     [`CR_CCEIP_64_SUPPORT_C_DF_MUX_CTRL_T_DECL] o_df_mux_ctrl,
  output     [`CR_CCEIP_64_SUPPORT_C_BIMC_MONITOR_MASK_T_DECL] o_bimc_monitor_mask,
  output     [`CR_CCEIP_64_SUPPORT_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_uncorrectable_error_cnt,
  output     [`CR_CCEIP_64_SUPPORT_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_correctable_error_cnt,
  output     [`CR_CCEIP_64_SUPPORT_C_BIMC_PARITY_ERROR_CNT_T_DECL] o_bimc_parity_error_cnt,
  output     [`CR_CCEIP_64_SUPPORT_C_BIMC_GLOBAL_CONFIG_T_DECL] o_bimc_global_config,
  output     [`CR_CCEIP_64_SUPPORT_C_BIMC_ECCPAR_DEBUG_T_DECL] o_bimc_eccpar_debug,
  output     [`CR_CCEIP_64_SUPPORT_C_BIMC_CMD2_T_DECL] o_bimc_cmd2,
  output     [`CR_CCEIP_64_SUPPORT_C_BIMC_CMD1_T_DECL] o_bimc_cmd1,
  output     [`CR_CCEIP_64_SUPPORT_C_BIMC_CMD0_T_DECL] o_bimc_cmd0,
  output     [`CR_CCEIP_64_SUPPORT_C_BIMC_RXCMD2_T_DECL] o_bimc_rxcmd2,
  output     [`CR_CCEIP_64_SUPPORT_C_BIMC_RXRSP2_T_DECL] o_bimc_rxrsp2,
  output     [`CR_CCEIP_64_SUPPORT_C_BIMC_POLLRSP2_T_DECL] o_bimc_pollrsp2,
  output     [`CR_CCEIP_64_SUPPORT_C_BIMC_DBGCMD2_T_DECL] o_bimc_dbgcmd2,

  
  input      [`CR_CCEIP_64_SUPPORT_C_BLKID_REVID_T_DECL] i_blkid_revid_config,
  input      [`CR_CCEIP_64_SUPPORT_C_SPARE_T_DECL] i_spare_config,
  input      [`CR_CCEIP_64_SUPPORT_C_IM_AVAILABLE_T_DECL] i_im_available,
  input      [`CR_CCEIP_64_SUPPORT_C_IM_CONSUMED_T_DECL] i_im_consumed,
  input      [`CR_CCEIP_64_SUPPORT_C_SOFT_RST_T_DECL] i_soft_rst,
  input      [`CR_CCEIP_64_SUPPORT_C_CTL_T_DECL] i_ctl,
  input      [`CR_CCEIP_64_SUPPORT_C_DF_MUX_CTRL_T_DECL] i_df_mux_ctrl,
  input      [`CR_CCEIP_64_SUPPORT_C_PIPE_STAT_T_DECL] i_pipe_stat,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_MONITOR_T_DECL] i_bimc_monitor,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_uncorrectable_error_cnt,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_correctable_error_cnt,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_PARITY_ERROR_CNT_T_DECL] i_bimc_parity_error_cnt,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_GLOBAL_CONFIG_T_DECL] i_bimc_global_config,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_MEMID_T_DECL] i_bimc_memid,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_ECCPAR_DEBUG_T_DECL] i_bimc_eccpar_debug,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_CMD2_T_DECL] i_bimc_cmd2,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_RXCMD2_T_DECL] i_bimc_rxcmd2,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_RXCMD1_T_DECL] i_bimc_rxcmd1,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_RXCMD0_T_DECL] i_bimc_rxcmd0,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_RXRSP2_T_DECL] i_bimc_rxrsp2,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_RXRSP1_T_DECL] i_bimc_rxrsp1,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_RXRSP0_T_DECL] i_bimc_rxrsp0,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_POLLRSP2_T_DECL] i_bimc_pollrsp2,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_POLLRSP1_T_DECL] i_bimc_pollrsp1,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_POLLRSP0_T_DECL] i_bimc_pollrsp0,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_DBGCMD2_T_DECL] i_bimc_dbgcmd2,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_DBGCMD1_T_DECL] i_bimc_dbgcmd1,
  input      [`CR_CCEIP_64_SUPPORT_C_BIMC_DBGCMD0_T_DECL] i_bimc_dbgcmd0,

  
  output reg                              o_cceip_int0_int_control_read,
  output reg                              o_cceip_int0_int_control_write,
  output reg [`CR_CCEIP_64_SUPPORT_C_CCEIP_INT0_INT_CONTROL_DATA_DECL] o_cceip_int0_int_control_data,
  output reg [`CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_CONTROL_ADDR_DECL] o_cceip_int0_int_control_addr,
  input      [`CR_CCEIP_64_SUPPORT_C_CCEIP_INT0_INT_CONTROL_DATA_DECL] i_cceip_int0_int_control_data,
  input                                   i_cceip_int0_int_control_ack,
  output reg                              o_cceip_int1_int_control_read,
  output reg                              o_cceip_int1_int_control_write,
  output reg [`CR_CCEIP_64_SUPPORT_C_CCEIP_INT1_INT_CONTROL_DATA_DECL] o_cceip_int1_int_control_data,
  output reg [`CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_CONTROL_ADDR_DECL] o_cceip_int1_int_control_addr,
  input      [`CR_CCEIP_64_SUPPORT_C_CCEIP_INT1_INT_CONTROL_DATA_DECL] i_cceip_int1_int_control_data,
  input                                   i_cceip_int1_int_control_ack,

  
  output reg                              o_reg_written,
  output reg                              o_reg_read,
  output     [31:0]                       o_reg_wr_data,
  output reg [`CR_CCEIP_64_SUPPORT_DECL]  o_reg_addr
  );


  


  
  


  
  wire [`CR_CCEIP_64_SUPPORT_DECL] ws_read_addr    = o_reg_addr;
  wire [`CR_CCEIP_64_SUPPORT_DECL] ws_addr         = o_reg_addr;
  

  wire n_wr_strobe = i_wr_strb;
  wire n_rd_strobe = i_rd_strb;

  wire w_32b_aligned    = (o_reg_addr[1:0] == 2'h0);

  wire w_valid_rd_addr     = (w_32b_aligned && (ws_addr >= `CR_CCEIP_64_SUPPORT_BLKID_REVID_CONFIG) && (ws_addr <= `CR_CCEIP_64_SUPPORT_PIPE_STAT))
                          || (w_32b_aligned && (ws_addr >= `CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_RAW_STATUS) && (ws_addr <= `CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_MASK_CONFIG))
                          || (w_32b_aligned && (ws_addr >= `CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_RAW_STATUS) && (ws_addr <= `CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_MASK_CONFIG))
                          || (w_32b_aligned && (ws_addr >= `CR_CCEIP_64_SUPPORT_BIMC_MONITOR) && (ws_addr <= `CR_CCEIP_64_SUPPORT_BIMC_DBGCMD0));

  wire w_valid_wr_addr     = (w_32b_aligned && (ws_addr >= `CR_CCEIP_64_SUPPORT_BLKID_REVID_CONFIG) && (ws_addr <= `CR_CCEIP_64_SUPPORT_PIPE_STAT))
                          || (w_32b_aligned && (ws_addr >= `CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_RAW_STATUS) && (ws_addr <= `CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_MASK_CONFIG))
                          || (w_32b_aligned && (ws_addr >= `CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_RAW_STATUS) && (ws_addr <= `CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_MASK_CONFIG))
                          || (w_32b_aligned && (ws_addr >= `CR_CCEIP_64_SUPPORT_BIMC_MONITOR) && (ws_addr <= `CR_CCEIP_64_SUPPORT_BIMC_DBGCMD0));

  wire w_valid_ram_rd_addr = (w_32b_aligned && (ws_addr >= `CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_RAW_STATUS) && (ws_addr <= `CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_MASK_CONFIG))
                          || (w_32b_aligned && (ws_addr >= `CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_RAW_STATUS) && (ws_addr <= `CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_MASK_CONFIG));

  wire w_valid_ram_wr_addr = (w_32b_aligned && (ws_addr == `CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_RAW_STATUS))
                          || (w_32b_aligned && (ws_addr == `CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_MASK_CONFIG))
                          || (w_32b_aligned && (ws_addr == `CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_RAW_STATUS))
                          || (w_32b_aligned && (ws_addr == `CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_MASK_CONFIG));


  wire w_valid_addr     = w_valid_wr_addr | w_valid_rd_addr;


  parameter IDLE    = 3'h0,
            WR_PREP = 3'h1,
            WR_RAM  = 3'h2,
            WR_REG  = 3'h3,
            WAIT    = 3'h4,
            RD_PREP = 3'h5,
            RD_RAM  = 3'h6,
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

  wire w_ram_ack        = i_cceip_int0_int_control_ack || i_cceip_int1_int_control_ack;

  wire       w_do_write      = ((f_state == WR_PREP));
  wire       w_do_read       = (((f_state == RD_PREP) & ~w_valid_ram_rd_addr) || ((f_state == RD_RAM) & w_ram_ack));


  

  wire [2:0] w_next_state    = w_valid_ram_wr_addr & (f_state == WR_PREP) ? WR_RAM
                             : w_valid_ram_rd_addr & (f_state == RD_PREP) ? RD_RAM
                             : ~w_ram_ack          & (f_state == WR_RAM)  ? WR_RAM
                             : ~w_ram_ack          & (f_state == RD_RAM)  ? RD_RAM
                             :                        f_state == WR_RAM   ? WR_REG
                             :                        f_state == RD_RAM   ? RD_REG
                             : n_wr_strobe                                ? WR_PREP
                             : n_rd_strobe                                ? RD_PREP
                             : f_state == WR_PREP                         ? WR_REG
                             : f_state == RD_PREP                         ? RD_REG
                             :                                              IDLE;

  wire       w_next_ack      = ((f_state == RD_RAM ) &  w_ram_ack)
                             | ((f_state == RD_PREP) & !w_valid_ram_rd_addr);

  wire       w_next_err_ack  = ((f_state == RD_PREP) & ~w_valid_rd_addr);

  reg        f_ack;
  reg        f_err_ack;

  assign o_ack      = f_ack | ((f_state == WR_RAM ) &  w_ram_ack) | ((f_state == WR_PREP) & !w_valid_ram_wr_addr);
  assign o_err_ack  = f_err_ack | ((f_state == WR_PREP) & ~w_valid_wr_addr);

  

  
  
  wire             w_eval_ram_read  = (f_state == RD_PREP);
  wire             w_eval_ram_write = (f_state == WR_PREP);

  reg        r_next_cceip_int0_int_control_read;
  reg        r_next_cceip_int0_int_control_write;
  reg    [`CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_CONTROL_ADDR_DECL] rs_next_cceip_int0_int_control_addr;

  always_comb begin
    r_next_cceip_int0_int_control_read  = o_cceip_int0_int_control_read;
    r_next_cceip_int0_int_control_write = o_cceip_int0_int_control_write;
    rs_next_cceip_int0_int_control_addr = o_cceip_int0_int_control_addr;

    if(i_cceip_int0_int_control_ack) begin
      r_next_cceip_int0_int_control_read  = 0;
      r_next_cceip_int0_int_control_write = 0;
    end
    else if(w_eval_ram_read || w_eval_ram_write) begin
      if((ws_addr >= `CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_RAW_STATUS) && (ws_addr <= `CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_MASK_CONFIG) && w_32b_aligned ) begin
        r_next_cceip_int0_int_control_write = w_valid_ram_wr_addr & w_eval_ram_write;
        r_next_cceip_int0_int_control_read  = w_valid_ram_rd_addr & w_eval_ram_read;
        rs_next_cceip_int0_int_control_addr = ((ws_addr - `CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_RAW_STATUS) >> 2) & {`CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_CONTROL_ADDR_WIDTH{1'b1}};
      end
    end
  end

  reg        r_next_cceip_int1_int_control_read;
  reg        r_next_cceip_int1_int_control_write;
  reg    [`CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_CONTROL_ADDR_DECL] rs_next_cceip_int1_int_control_addr;

  always_comb begin
    r_next_cceip_int1_int_control_read  = o_cceip_int1_int_control_read;
    r_next_cceip_int1_int_control_write = o_cceip_int1_int_control_write;
    rs_next_cceip_int1_int_control_addr = o_cceip_int1_int_control_addr;

    if(i_cceip_int1_int_control_ack) begin
      r_next_cceip_int1_int_control_read  = 0;
      r_next_cceip_int1_int_control_write = 0;
    end
    else if(w_eval_ram_read || w_eval_ram_write) begin
      if((ws_addr >= `CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_RAW_STATUS) && (ws_addr <= `CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_MASK_CONFIG) && w_32b_aligned ) begin
        r_next_cceip_int1_int_control_write = w_valid_ram_wr_addr & w_eval_ram_write;
        r_next_cceip_int1_int_control_read  = w_valid_ram_rd_addr & w_eval_ram_read;
        rs_next_cceip_int1_int_control_addr = ((ws_addr - `CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_RAW_STATUS) >> 2) & {`CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_CONTROL_ADDR_WIDTH{1'b1}};
      end
    end
  end

  
  

  
  


  reg  [31:0]  r32_mux_0_data, f32_mux_0_data;
  reg  [31:0]  r32_mux_1_data, f32_mux_1_data;

  wire [31:0]  r32_formatted_reg_data = f32_mux_0_data
                                      | f32_mux_1_data;

  always_comb begin
    r32_mux_0_data = 0;
    r32_mux_1_data = 0;

    case (ws_read_addr)
    `CR_CCEIP_64_SUPPORT_BLKID_REVID_CONFIG: begin
      r32_mux_0_data[15:00] = i_blkid_revid_config[15:00]; 
      r32_mux_0_data[31:16] = i_blkid_revid_config[31:16]; 
    end
    `CR_CCEIP_64_SUPPORT_SPARE_CONFIG: begin
      r32_mux_0_data[31:00] = i_spare_config[31:00]; 
    end
    `CR_CCEIP_64_SUPPORT_IM_AVAILABLE: begin
      r32_mux_0_data[00:00] = i_im_available[00:00]; 
      r32_mux_0_data[01:01] = i_im_available[01:01]; 
      r32_mux_0_data[02:02] = i_im_available[02:02]; 
      r32_mux_0_data[03:03] = i_im_available[03:03]; 
      r32_mux_0_data[04:04] = i_im_available[04:04]; 
      r32_mux_0_data[05:05] = i_im_available[05:05]; 
      r32_mux_0_data[06:06] = i_im_available[06:06]; 
      r32_mux_0_data[07:07] = i_im_available[07:07]; 
      r32_mux_0_data[08:08] = i_im_available[08:08]; 
      r32_mux_0_data[09:09] = i_im_available[09:09]; 
      r32_mux_0_data[10:10] = i_im_available[10:10]; 
      r32_mux_0_data[11:11] = i_im_available[11:11]; 
      r32_mux_0_data[12:12] = i_im_available[12:12]; 
      r32_mux_0_data[13:13] = i_im_available[13:13]; 
      r32_mux_0_data[14:14] = i_im_available[14:14]; 
      r32_mux_0_data[15:15] = i_im_available[15:15]; 
      r32_mux_0_data[16:16] = i_im_available[16:16]; 
      r32_mux_0_data[17:17] = i_im_available[17:17]; 
    end
    `CR_CCEIP_64_SUPPORT_IM_CONSUMED: begin
      r32_mux_0_data[00:00] = i_im_consumed[00:00]; 
      r32_mux_0_data[01:01] = i_im_consumed[01:01]; 
      r32_mux_0_data[02:02] = i_im_consumed[02:02]; 
      r32_mux_0_data[03:03] = i_im_consumed[03:03]; 
      r32_mux_0_data[04:04] = i_im_consumed[04:04]; 
      r32_mux_0_data[05:05] = i_im_consumed[05:05]; 
      r32_mux_0_data[06:06] = i_im_consumed[06:06]; 
      r32_mux_0_data[07:07] = i_im_consumed[07:07]; 
      r32_mux_0_data[08:08] = i_im_consumed[08:08]; 
      r32_mux_0_data[09:09] = i_im_consumed[09:09]; 
      r32_mux_0_data[10:10] = i_im_consumed[10:10]; 
      r32_mux_0_data[11:11] = i_im_consumed[11:11]; 
      r32_mux_0_data[12:12] = i_im_consumed[12:12]; 
      r32_mux_0_data[13:13] = i_im_consumed[13:13]; 
      r32_mux_0_data[14:14] = i_im_consumed[14:14]; 
      r32_mux_0_data[15:15] = i_im_consumed[15:15]; 
      r32_mux_0_data[16:16] = i_im_consumed[16:16]; 
      r32_mux_0_data[17:17] = i_im_consumed[17:17]; 
    end
    `CR_CCEIP_64_SUPPORT_SOFT_RST: begin
      r32_mux_0_data[00:00] = i_soft_rst[00:00]; 
    end
    `CR_CCEIP_64_SUPPORT_CTL: begin
      r32_mux_0_data[00:00] = i_ctl[00:00]; 
    end
    `CR_CCEIP_64_SUPPORT_DF_MUX_CTRL: begin
      r32_mux_0_data[00:00] = i_df_mux_ctrl[00:00]; 
    end
    `CR_CCEIP_64_SUPPORT_PIPE_STAT: begin
      r32_mux_0_data[00:00] = i_pipe_stat[00:00]; 
      r32_mux_0_data[01:01] = i_pipe_stat[01:01]; 
      r32_mux_0_data[02:02] = i_pipe_stat[02:02]; 
      r32_mux_0_data[15:08] = i_pipe_stat[10:03]; 
      r32_mux_0_data[23:16] = i_pipe_stat[18:11]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_MONITOR: begin
      r32_mux_0_data[00:00] = i_bimc_monitor[00:00]; 
      r32_mux_0_data[01:01] = i_bimc_monitor[01:01]; 
      r32_mux_0_data[02:02] = i_bimc_monitor[02:02]; 
      r32_mux_0_data[03:03] = i_bimc_monitor[03:03]; 
      r32_mux_0_data[04:04] = i_bimc_monitor[04:04]; 
      r32_mux_0_data[05:05] = i_bimc_monitor[05:05]; 
      r32_mux_0_data[06:06] = i_bimc_monitor[06:06]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_MONITOR_MASK: begin
      r32_mux_0_data[00:00] = o_bimc_monitor_mask[00:00]; 
      r32_mux_0_data[01:01] = o_bimc_monitor_mask[01:01]; 
      r32_mux_0_data[02:02] = o_bimc_monitor_mask[02:02]; 
      r32_mux_0_data[03:03] = o_bimc_monitor_mask[03:03]; 
      r32_mux_0_data[04:04] = o_bimc_monitor_mask[04:04]; 
      r32_mux_0_data[05:05] = o_bimc_monitor_mask[05:05]; 
      r32_mux_0_data[06:06] = o_bimc_monitor_mask[06:06]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_ECC_UNCORRECTABLE_ERROR_CNT: begin
      r32_mux_0_data[31:00] = i_bimc_ecc_uncorrectable_error_cnt[31:00]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_ECC_CORRECTABLE_ERROR_CNT: begin
      r32_mux_0_data[31:00] = i_bimc_ecc_correctable_error_cnt[31:00]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_PARITY_ERROR_CNT: begin
      r32_mux_0_data[31:00] = i_bimc_parity_error_cnt[31:00]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_GLOBAL_CONFIG: begin
      r32_mux_0_data[00:00] = i_bimc_global_config[00:00]; 
      r32_mux_0_data[01:01] = i_bimc_global_config[01:01]; 
      r32_mux_0_data[02:02] = i_bimc_global_config[02:02]; 
      r32_mux_0_data[03:03] = i_bimc_global_config[03:03]; 
      r32_mux_0_data[04:04] = i_bimc_global_config[04:04]; 
      r32_mux_0_data[05:05] = i_bimc_global_config[05:05]; 
      r32_mux_0_data[31:06] = i_bimc_global_config[31:06]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_MEMID: begin
      r32_mux_0_data[11:00] = i_bimc_memid[11:00]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_ECCPAR_DEBUG: begin
      r32_mux_0_data[11:00] = i_bimc_eccpar_debug[11:00]; 
      r32_mux_0_data[15:12] = i_bimc_eccpar_debug[15:12]; 
      r32_mux_0_data[17:16] = i_bimc_eccpar_debug[17:16]; 
      r32_mux_0_data[19:18] = i_bimc_eccpar_debug[19:18]; 
      r32_mux_0_data[21:20] = i_bimc_eccpar_debug[21:20]; 
      r32_mux_0_data[22:22] = i_bimc_eccpar_debug[22:22]; 
      r32_mux_0_data[23:23] = i_bimc_eccpar_debug[23:23]; 
      r32_mux_0_data[27:24] = i_bimc_eccpar_debug[27:24]; 
      r32_mux_0_data[28:28] = i_bimc_eccpar_debug[28:28]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_CMD2: begin
      r32_mux_0_data[07:00] = i_bimc_cmd2[07:00]; 
      r32_mux_0_data[08:08] = i_bimc_cmd2[08:08]; 
      r32_mux_0_data[09:09] = i_bimc_cmd2[09:09]; 
      r32_mux_0_data[10:10] = i_bimc_cmd2[10:10]; 
    end
    endcase

    case (ws_read_addr)
    `CR_CCEIP_64_SUPPORT_BIMC_CMD1: begin
      r32_mux_1_data[15:00] = o_bimc_cmd1[15:00]; 
      r32_mux_1_data[27:16] = o_bimc_cmd1[27:16]; 
      r32_mux_1_data[31:28] = o_bimc_cmd1[31:28]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_CMD0: begin
      r32_mux_1_data[31:00] = o_bimc_cmd0[31:00]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_RXCMD2: begin
      r32_mux_1_data[07:00] = i_bimc_rxcmd2[07:00]; 
      r32_mux_1_data[08:08] = i_bimc_rxcmd2[08:08]; 
      r32_mux_1_data[09:09] = i_bimc_rxcmd2[09:09]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_RXCMD1: begin
      r32_mux_1_data[15:00] = i_bimc_rxcmd1[15:00]; 
      r32_mux_1_data[27:16] = i_bimc_rxcmd1[27:16]; 
      r32_mux_1_data[31:28] = i_bimc_rxcmd1[31:28]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_RXCMD0: begin
      r32_mux_1_data[31:00] = i_bimc_rxcmd0[31:00]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_RXRSP2: begin
      r32_mux_1_data[07:00] = i_bimc_rxrsp2[07:00]; 
      r32_mux_1_data[08:08] = i_bimc_rxrsp2[08:08]; 
      r32_mux_1_data[09:09] = i_bimc_rxrsp2[09:09]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_RXRSP1: begin
      r32_mux_1_data[31:00] = i_bimc_rxrsp1[31:00]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_RXRSP0: begin
      r32_mux_1_data[31:00] = i_bimc_rxrsp0[31:00]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_POLLRSP2: begin
      r32_mux_1_data[07:00] = i_bimc_pollrsp2[07:00]; 
      r32_mux_1_data[08:08] = i_bimc_pollrsp2[08:08]; 
      r32_mux_1_data[09:09] = i_bimc_pollrsp2[09:09]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_POLLRSP1: begin
      r32_mux_1_data[31:00] = i_bimc_pollrsp1[31:00]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_POLLRSP0: begin
      r32_mux_1_data[31:00] = i_bimc_pollrsp0[31:00]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_DBGCMD2: begin
      r32_mux_1_data[07:00] = i_bimc_dbgcmd2[07:00]; 
      r32_mux_1_data[08:08] = i_bimc_dbgcmd2[08:08]; 
      r32_mux_1_data[09:09] = i_bimc_dbgcmd2[09:09]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_DBGCMD1: begin
      r32_mux_1_data[15:00] = i_bimc_dbgcmd1[15:00]; 
      r32_mux_1_data[27:16] = i_bimc_dbgcmd1[27:16]; 
      r32_mux_1_data[31:28] = i_bimc_dbgcmd1[31:28]; 
    end
    `CR_CCEIP_64_SUPPORT_BIMC_DBGCMD0: begin
      r32_mux_1_data[31:00] = i_bimc_dbgcmd0[31:00]; 
    end
    default: begin
      if((ws_read_addr >= `CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_RAW_STATUS) && (ws_read_addr <= `CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_MASK_CONFIG) && (ws_read_addr[1:0] == {2{1'b0}})) begin
        r32_mux_1_data[23:00] = i_cceip_int0_int_control_data[23:00];
      end
      else if((ws_read_addr >= `CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_RAW_STATUS) && (ws_read_addr <= `CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_MASK_CONFIG) && (ws_read_addr[1:0] == {2{1'b0}})) begin
        r32_mux_1_data[09:00] = i_cceip_int1_int_control_data[09:00];
      end
    end
    endcase

  end

  
  

  
  

  reg  [31:0]  f32_data;

  assign o_reg_wr_data = f32_data;

  
  

  
  assign       o_rd_data  = (o_ack  & ~n_write) ? r32_formatted_reg_data : { 32 { 1'b0 } };
  

  
  

  wire w_load_spare_config                     = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_SPARE_CONFIG);
  wire w_load_im_consumed                      = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_IM_CONSUMED);
  wire w_load_soft_rst                         = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_SOFT_RST);
  wire w_load_ctl                              = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_CTL);
  wire w_load_df_mux_ctrl                      = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_DF_MUX_CTRL);
  wire w_load_bimc_monitor_mask                = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_BIMC_MONITOR_MASK);
  wire w_load_bimc_ecc_uncorrectable_error_cnt = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_BIMC_ECC_UNCORRECTABLE_ERROR_CNT);
  wire w_load_bimc_ecc_correctable_error_cnt   = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_BIMC_ECC_CORRECTABLE_ERROR_CNT);
  wire w_load_bimc_parity_error_cnt            = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_BIMC_PARITY_ERROR_CNT);
  wire w_load_bimc_global_config               = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_BIMC_GLOBAL_CONFIG);
  wire w_load_bimc_eccpar_debug                = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_BIMC_ECCPAR_DEBUG);
  wire w_load_bimc_cmd2                        = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_BIMC_CMD2);
  wire w_load_bimc_cmd1                        = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_BIMC_CMD1);
  wire w_load_bimc_cmd0                        = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_BIMC_CMD0);
  wire w_load_bimc_rxcmd2                      = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_BIMC_RXCMD2);
  wire w_load_bimc_rxrsp2                      = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_BIMC_RXRSP2);
  wire w_load_bimc_pollrsp2                    = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_BIMC_POLLRSP2);
  wire w_load_bimc_dbgcmd2                     = w_do_write & (ws_addr == `CR_CCEIP_64_SUPPORT_BIMC_DBGCMD2);
  wire w_load_cceip_int0_int_control           = w_do_write & (r_next_cceip_int0_int_control_write) & w_32b_aligned;
  wire w_load_cceip_int1_int_control           = w_do_write & (r_next_cceip_int1_int_control_write) & w_32b_aligned;


  


  always_ff @(posedge clk or negedge i_reset_) begin
    if(~i_reset_) begin
      
      f_state                        <= IDLE;
      f_ack                          <= 0;
      f_err_ack                      <= 0;
      f_prev_do_read                 <= 0;

      o_reg_addr                     <= 0;
      o_reg_written                  <= 0;
      o_reg_read                     <= 0;
      o_cceip_int0_int_control_read  <= 0;
      o_cceip_int0_int_control_write <= 0;
      o_cceip_int0_int_control_addr  <= 0;
      o_cceip_int1_int_control_read  <= 0;
      o_cceip_int1_int_control_write <= 0;
      o_cceip_int1_int_control_addr  <= 0;
      f32_mux_0_data                 <= 0;
      f32_mux_1_data                 <= 0;

    end
    else if(i_sw_init) begin
      
      f_state                        <= IDLE;
      f_ack                          <= 0;
      f_err_ack                      <= 0;
      f_prev_do_read                 <= 0;

      o_reg_addr                     <= 0;
      o_reg_written                  <= 0;
      o_reg_read                     <= 0;
      o_cceip_int0_int_control_read  <= 0;
      o_cceip_int0_int_control_write <= 0;
      o_cceip_int0_int_control_addr  <= 0;
      o_cceip_int1_int_control_read  <= 0;
      o_cceip_int1_int_control_write <= 0;
      o_cceip_int1_int_control_addr  <= 0;
      f32_mux_0_data                 <= 0;
      f32_mux_1_data                 <= 0;

    end
    else begin
      f_state                        <= w_next_state;
      f_ack                          <= w_next_ack & !i_wr_strb & !i_rd_strb;
      f_err_ack                      <= w_next_err_ack;
      f_prev_do_read                 <= w_do_read | (w_ram_ack & ~n_write);

      if (i_wr_strb | i_rd_strb)        o_reg_addr                           <= i_addr;
      o_reg_written                  <= (w_do_write & w_32b_aligned & w_valid_wr_addr);
      o_reg_read                     <= (w_do_read  & w_32b_aligned & w_valid_rd_addr);
      o_cceip_int0_int_control_read  <= r_next_cceip_int0_int_control_read;
      o_cceip_int0_int_control_write <= r_next_cceip_int0_int_control_write;
      o_cceip_int0_int_control_addr  <= rs_next_cceip_int0_int_control_addr;
      o_cceip_int1_int_control_read  <= r_next_cceip_int1_int_control_read;
      o_cceip_int1_int_control_write <= r_next_cceip_int1_int_control_write;
      o_cceip_int1_int_control_addr  <= rs_next_cceip_int1_int_control_addr;
      if (w_do_read)                    f32_mux_0_data                       <= r32_mux_0_data;
      if (w_do_read)                    f32_mux_1_data                       <= r32_mux_1_data;
      if(w_load_cceip_int0_int_control) o_cceip_int0_int_control_data[23:00] <= f32_data[23:00];
      if(w_load_cceip_int1_int_control) o_cceip_int1_int_control_data[09:00] <= f32_data[09:00];
    end
  end

  
  always_ff @(posedge clk) begin
    if (i_wr_strb)                      f32_data                             <= i_wr_data;

  end
  

  cr_cceip_64_support_regs_flops u_cr_cceip_64_support_regs_flops (
        .clk                                    ( clk ),
        .i_reset_                               ( i_reset_ ),
        .i_sw_init                              ( i_sw_init ),
        .o_spare_config                         ( o_spare_config ),
        .o_im_consumed                          ( o_im_consumed ),
        .o_soft_rst                             ( o_soft_rst ),
        .o_ctl                                  ( o_ctl ),
        .o_df_mux_ctrl                          ( o_df_mux_ctrl ),
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
        .w_load_im_consumed                     ( w_load_im_consumed ),
        .w_load_soft_rst                        ( w_load_soft_rst ),
        .w_load_ctl                             ( w_load_ctl ),
        .w_load_df_mux_ctrl                     ( w_load_df_mux_ctrl ),
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

  

  

  `ifdef CR_CCEIP_64_SUPPORT_DIGEST_CB51FCACA0AA2109EDEE80A687C631EA
  `else
    initial begin
      $display("Error: the core decode file (cr_cceip_64_support_regs.sv) and include file (cr_cceip_64_support.vh) were compiled");
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


module cr_cceip_64_support_regs_flops (
  input  clk,
  input  i_reset_,
  input  i_sw_init,

  
  output reg [`CR_CCEIP_64_SUPPORT_C_SPARE_T_DECL] o_spare_config,
  output reg [`CR_CCEIP_64_SUPPORT_C_IM_CONSUMED_T_DECL] o_im_consumed,
  output reg [`CR_CCEIP_64_SUPPORT_C_SOFT_RST_T_DECL] o_soft_rst,
  output reg [`CR_CCEIP_64_SUPPORT_C_CTL_T_DECL] o_ctl,
  output reg [`CR_CCEIP_64_SUPPORT_C_DF_MUX_CTRL_T_DECL] o_df_mux_ctrl,
  output reg [`CR_CCEIP_64_SUPPORT_C_BIMC_MONITOR_MASK_T_DECL] o_bimc_monitor_mask,
  output reg [`CR_CCEIP_64_SUPPORT_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_uncorrectable_error_cnt,
  output reg [`CR_CCEIP_64_SUPPORT_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_correctable_error_cnt,
  output reg [`CR_CCEIP_64_SUPPORT_C_BIMC_PARITY_ERROR_CNT_T_DECL] o_bimc_parity_error_cnt,
  output reg [`CR_CCEIP_64_SUPPORT_C_BIMC_GLOBAL_CONFIG_T_DECL] o_bimc_global_config,
  output reg [`CR_CCEIP_64_SUPPORT_C_BIMC_ECCPAR_DEBUG_T_DECL] o_bimc_eccpar_debug,
  output reg [`CR_CCEIP_64_SUPPORT_C_BIMC_CMD2_T_DECL] o_bimc_cmd2,
  output reg [`CR_CCEIP_64_SUPPORT_C_BIMC_CMD1_T_DECL] o_bimc_cmd1,
  output reg [`CR_CCEIP_64_SUPPORT_C_BIMC_CMD0_T_DECL] o_bimc_cmd0,
  output reg [`CR_CCEIP_64_SUPPORT_C_BIMC_RXCMD2_T_DECL] o_bimc_rxcmd2,
  output reg [`CR_CCEIP_64_SUPPORT_C_BIMC_RXRSP2_T_DECL] o_bimc_rxrsp2,
  output reg [`CR_CCEIP_64_SUPPORT_C_BIMC_POLLRSP2_T_DECL] o_bimc_pollrsp2,
  output reg [`CR_CCEIP_64_SUPPORT_C_BIMC_DBGCMD2_T_DECL] o_bimc_dbgcmd2,


  
  input  w_load_spare_config,
  input  w_load_im_consumed,
  input  w_load_soft_rst,
  input  w_load_ctl,
  input  w_load_df_mux_ctrl,
  input  w_load_bimc_monitor_mask,
  input  w_load_bimc_ecc_uncorrectable_error_cnt,
  input  w_load_bimc_ecc_correctable_error_cnt,
  input  w_load_bimc_parity_error_cnt,
  input  w_load_bimc_global_config,
  input  w_load_bimc_eccpar_debug,
  input  w_load_bimc_cmd2,
  input  w_load_bimc_cmd1,
  input  w_load_bimc_cmd0,
  input  w_load_bimc_rxcmd2,
  input  w_load_bimc_rxrsp2,
  input  w_load_bimc_pollrsp2,
  input  w_load_bimc_dbgcmd2,

  input      [31:0]                             f32_data
  );

  
  

  
  

  
  
  
  always_ff @(posedge clk or negedge i_reset_) begin
    if(~i_reset_) begin
      
      o_spare_config[31:00]                     <= 32'd0; 
      o_im_consumed[00:00]                      <= 1'd0; 
      o_im_consumed[01:01]                      <= 1'd0; 
      o_im_consumed[02:02]                      <= 1'd0; 
      o_im_consumed[03:03]                      <= 1'd0; 
      o_im_consumed[04:04]                      <= 1'd0; 
      o_im_consumed[05:05]                      <= 1'd0; 
      o_im_consumed[06:06]                      <= 1'd0; 
      o_im_consumed[07:07]                      <= 1'd0; 
      o_im_consumed[08:08]                      <= 1'd0; 
      o_im_consumed[09:09]                      <= 1'd0; 
      o_im_consumed[10:10]                      <= 1'd0; 
      o_im_consumed[11:11]                      <= 1'd0; 
      o_im_consumed[12:12]                      <= 1'd0; 
      o_im_consumed[13:13]                      <= 1'd0; 
      o_im_consumed[14:14]                      <= 1'd0; 
      o_im_consumed[15:15]                      <= 1'd0; 
      o_im_consumed[16:16]                      <= 1'd0; 
      o_im_consumed[17:17]                      <= 1'd0; 
      o_soft_rst[00:00]                         <= 1'd0; 
      o_ctl[00:00]                              <= 1'd1; 
      o_df_mux_ctrl[00:00]                      <= 1'd0; 
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
      o_im_consumed[00:00]                      <= 1'd0; 
      o_im_consumed[01:01]                      <= 1'd0; 
      o_im_consumed[02:02]                      <= 1'd0; 
      o_im_consumed[03:03]                      <= 1'd0; 
      o_im_consumed[04:04]                      <= 1'd0; 
      o_im_consumed[05:05]                      <= 1'd0; 
      o_im_consumed[06:06]                      <= 1'd0; 
      o_im_consumed[07:07]                      <= 1'd0; 
      o_im_consumed[08:08]                      <= 1'd0; 
      o_im_consumed[09:09]                      <= 1'd0; 
      o_im_consumed[10:10]                      <= 1'd0; 
      o_im_consumed[11:11]                      <= 1'd0; 
      o_im_consumed[12:12]                      <= 1'd0; 
      o_im_consumed[13:13]                      <= 1'd0; 
      o_im_consumed[14:14]                      <= 1'd0; 
      o_im_consumed[15:15]                      <= 1'd0; 
      o_im_consumed[16:16]                      <= 1'd0; 
      o_im_consumed[17:17]                      <= 1'd0; 
      o_soft_rst[00:00]                         <= 1'd0; 
      o_ctl[00:00]                              <= 1'd1; 
      o_df_mux_ctrl[00:00]                      <= 1'd0; 
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
      if(w_load_im_consumed)                      o_im_consumed[00:00]                      <= f32_data[00:00]; 
      if(w_load_im_consumed)                      o_im_consumed[01:01]                      <= f32_data[01:01]; 
      if(w_load_im_consumed)                      o_im_consumed[02:02]                      <= f32_data[02:02]; 
      if(w_load_im_consumed)                      o_im_consumed[03:03]                      <= f32_data[03:03]; 
      if(w_load_im_consumed)                      o_im_consumed[04:04]                      <= f32_data[04:04]; 
      if(w_load_im_consumed)                      o_im_consumed[05:05]                      <= f32_data[05:05]; 
      if(w_load_im_consumed)                      o_im_consumed[06:06]                      <= f32_data[06:06]; 
      if(w_load_im_consumed)                      o_im_consumed[07:07]                      <= f32_data[07:07]; 
      if(w_load_im_consumed)                      o_im_consumed[08:08]                      <= f32_data[08:08]; 
      if(w_load_im_consumed)                      o_im_consumed[09:09]                      <= f32_data[09:09]; 
      if(w_load_im_consumed)                      o_im_consumed[10:10]                      <= f32_data[10:10]; 
      if(w_load_im_consumed)                      o_im_consumed[11:11]                      <= f32_data[11:11]; 
      if(w_load_im_consumed)                      o_im_consumed[12:12]                      <= f32_data[12:12]; 
      if(w_load_im_consumed)                      o_im_consumed[13:13]                      <= f32_data[13:13]; 
      if(w_load_im_consumed)                      o_im_consumed[14:14]                      <= f32_data[14:14]; 
      if(w_load_im_consumed)                      o_im_consumed[15:15]                      <= f32_data[15:15]; 
      if(w_load_im_consumed)                      o_im_consumed[16:16]                      <= f32_data[16:16]; 
      if(w_load_im_consumed)                      o_im_consumed[17:17]                      <= f32_data[17:17]; 
      if(w_load_soft_rst)                         o_soft_rst[00:00]                         <= f32_data[00:00]; 
      if(w_load_ctl)                              o_ctl[00:00]                              <= f32_data[00:00]; 
      if(w_load_df_mux_ctrl)                      o_df_mux_ctrl[00:00]                      <= f32_data[00:00]; 
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
      if(w_load_bimc_rxcmd2)                      o_bimc_rxcmd2[09:09]                      <= f32_data[09:09]; 
      if(w_load_bimc_rxrsp2)                      o_bimc_rxrsp2[09:09]                      <= f32_data[09:09]; 
      if(w_load_bimc_pollrsp2)                    o_bimc_pollrsp2[09:09]                    <= f32_data[09:09]; 
      if(w_load_bimc_dbgcmd2)                     o_bimc_dbgcmd2[09:09]                     <= f32_data[09:09]; 
  end
  

  

endmodule
