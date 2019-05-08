/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











`include "cr_cceip_64_sa.vh"




module cr_cceip_64_sa_regs (
  input                                        clk,
  input                                        i_reset_,
  input                                        i_sw_init,

  
  input      [`CR_CCEIP_64_SA_DECL]            i_addr,
  input                                        i_wr_strb,
  input      [31:0]                            i_wr_data,
  input                                        i_rd_strb,
  output     [31:0]                            o_rd_data,
  output                                       o_ack,
  output                                       o_err_ack,

  
  output     [`CR_CCEIP_64_SA_C_SPARE_T_DECL]  o_spare_config,
  output     [`CR_CCEIP_64_SA_C_SA_GLOBAL_CTRL_T_DECL] o_sa_global_ctrl,
  output     [`CR_CCEIP_64_SA_C_SA_CTRL_T_DECL] o_sa_ctrl_ia_wdata_part0,
  output     [`CR_CCEIP_64_SA_C_SA_CTRL_IA_CONFIG_T_DECL] o_sa_ctrl_ia_config,
  output     [`CR_CCEIP_64_SA_C_SA_SNAPSHOT_PART1_T_DECL] o_sa_snapshot_ia_wdata_part0,
  output     [`CR_CCEIP_64_SA_C_SA_SNAPSHOT_PART0_T_DECL] o_sa_snapshot_ia_wdata_part1,
  output     [`CR_CCEIP_64_SA_C_SA_SNAPSHOT_IA_CONFIG_T_DECL] o_sa_snapshot_ia_config,
  output     [`CR_CCEIP_64_SA_C_SA_COUNT_PART1_T_DECL] o_sa_count_ia_wdata_part0,
  output     [`CR_CCEIP_64_SA_C_SA_COUNT_PART0_T_DECL] o_sa_count_ia_wdata_part1,
  output     [`CR_CCEIP_64_SA_C_SA_COUNT_IA_CONFIG_T_DECL] o_sa_count_ia_config,

  
  input      [`CR_CCEIP_64_SA_C_REVID_T_DECL]  i_revision_config,
  input      [`CR_CCEIP_64_SA_C_SPARE_T_DECL]  i_spare_config,
  input      [`CR_CCEIP_64_SA_C_SA_GLOBAL_CTRL_T_DECL] i_sa_global_ctrl,
  input      [`CR_CCEIP_64_SA_C_SA_CTRL_IA_CAPABILITY_T_DECL] i_sa_ctrl_ia_capability,
  input      [`CR_CCEIP_64_SA_C_SA_CTRL_IA_STATUS_T_DECL] i_sa_ctrl_ia_status,
  input      [`CR_CCEIP_64_SA_C_SA_CTRL_T_DECL] i_sa_ctrl_ia_rdata_part0,
  input      [`CR_CCEIP_64_SA_C_SA_SNAPSHOT_IA_CAPABILITY_T_DECL] i_sa_snapshot_ia_capability,
  input      [`CR_CCEIP_64_SA_C_SA_SNAPSHOT_IA_STATUS_T_DECL] i_sa_snapshot_ia_status,
  input      [`CR_CCEIP_64_SA_C_SA_SNAPSHOT_PART1_T_DECL] i_sa_snapshot_ia_rdata_part0,
  input      [`CR_CCEIP_64_SA_C_SA_SNAPSHOT_PART0_T_DECL] i_sa_snapshot_ia_rdata_part1,
  input      [`CR_CCEIP_64_SA_C_SA_COUNT_IA_CAPABILITY_T_DECL] i_sa_count_ia_capability,
  input      [`CR_CCEIP_64_SA_C_SA_COUNT_IA_STATUS_T_DECL] i_sa_count_ia_status,
  input      [`CR_CCEIP_64_SA_C_SA_COUNT_PART1_T_DECL] i_sa_count_ia_rdata_part0,
  input      [`CR_CCEIP_64_SA_C_SA_COUNT_PART0_T_DECL] i_sa_count_ia_rdata_part1,

  
  output reg                                   o_reg_written,
  output reg                                   o_reg_read,
  output     [31:0]                            o_reg_wr_data,
  output reg [`CR_CCEIP_64_SA_DECL]            o_reg_addr
  );


  


  
  


  
  wire [`CR_CCEIP_64_SA_DECL] ws_read_addr    = o_reg_addr;
  wire [`CR_CCEIP_64_SA_DECL] ws_addr         = o_reg_addr;
  

  wire n_wr_strobe = i_wr_strb;
  wire n_rd_strobe = i_rd_strb;

  wire w_32b_aligned    = (o_reg_addr[1:0] == 2'h0);

  wire w_valid_rd_addr     = (w_32b_aligned && (ws_addr >= `CR_CCEIP_64_SA_REVISION_CONFIG) && (ws_addr <= `CR_CCEIP_64_SA_SA_COUNT_IA_RDATA_PART1));

  wire w_valid_wr_addr     = (w_32b_aligned && (ws_addr >= `CR_CCEIP_64_SA_REVISION_CONFIG) && (ws_addr <= `CR_CCEIP_64_SA_SA_COUNT_IA_RDATA_PART1));

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
    `CR_CCEIP_64_SA_REVISION_CONFIG: begin
      r32_mux_0_data[07:00] = i_revision_config[07:00]; 
    end
    `CR_CCEIP_64_SA_SPARE_CONFIG: begin
      r32_mux_0_data[31:00] = i_spare_config[31:00]; 
    end
    `CR_CCEIP_64_SA_SA_GLOBAL_CTRL: begin
      r32_mux_0_data[00:00] = i_sa_global_ctrl[00:00]; 
      r32_mux_0_data[01:01] = i_sa_global_ctrl[01:01]; 
      r32_mux_0_data[31:02] = i_sa_global_ctrl[31:02]; 
    end
    `CR_CCEIP_64_SA_SA_CTRL_IA_CAPABILITY: begin
      r32_mux_0_data[00:00] = i_sa_ctrl_ia_capability[00:00]; 
      r32_mux_0_data[01:01] = i_sa_ctrl_ia_capability[01:01]; 
      r32_mux_0_data[02:02] = i_sa_ctrl_ia_capability[02:02]; 
      r32_mux_0_data[03:03] = i_sa_ctrl_ia_capability[03:03]; 
      r32_mux_0_data[04:04] = i_sa_ctrl_ia_capability[04:04]; 
      r32_mux_0_data[05:05] = i_sa_ctrl_ia_capability[05:05]; 
      r32_mux_0_data[06:06] = i_sa_ctrl_ia_capability[06:06]; 
      r32_mux_0_data[07:07] = i_sa_ctrl_ia_capability[07:07]; 
      r32_mux_0_data[08:08] = i_sa_ctrl_ia_capability[08:08]; 
      r32_mux_0_data[09:09] = i_sa_ctrl_ia_capability[09:09]; 
      r32_mux_0_data[13:10] = i_sa_ctrl_ia_capability[13:10]; 
      r32_mux_0_data[14:14] = i_sa_ctrl_ia_capability[14:14]; 
      r32_mux_0_data[15:15] = i_sa_ctrl_ia_capability[15:15]; 
      r32_mux_0_data[31:28] = i_sa_ctrl_ia_capability[19:16]; 
    end
    `CR_CCEIP_64_SA_SA_CTRL_IA_STATUS: begin
      r32_mux_0_data[05:00] = i_sa_ctrl_ia_status[05:00]; 
      r32_mux_0_data[28:24] = i_sa_ctrl_ia_status[10:06]; 
      r32_mux_0_data[31:29] = i_sa_ctrl_ia_status[13:11]; 
    end
    `CR_CCEIP_64_SA_SA_CTRL_IA_WDATA_PART0: begin
      r32_mux_0_data[09:00] = o_sa_ctrl_ia_wdata_part0[09:00]; 
      r32_mux_0_data[31:10] = o_sa_ctrl_ia_wdata_part0[31:10]; 
    end
    `CR_CCEIP_64_SA_SA_CTRL_IA_CONFIG: begin
      r32_mux_0_data[05:00] = o_sa_ctrl_ia_config[05:00]; 
      r32_mux_0_data[31:28] = o_sa_ctrl_ia_config[09:06]; 
    end
    `CR_CCEIP_64_SA_SA_CTRL_IA_RDATA_PART0: begin
      r32_mux_0_data[09:00] = i_sa_ctrl_ia_rdata_part0[09:00]; 
      r32_mux_0_data[31:10] = i_sa_ctrl_ia_rdata_part0[31:10]; 
    end
    `CR_CCEIP_64_SA_SA_SNAPSHOT_IA_CAPABILITY: begin
      r32_mux_0_data[00:00] = i_sa_snapshot_ia_capability[00:00]; 
      r32_mux_0_data[01:01] = i_sa_snapshot_ia_capability[01:01]; 
      r32_mux_0_data[02:02] = i_sa_snapshot_ia_capability[02:02]; 
      r32_mux_0_data[03:03] = i_sa_snapshot_ia_capability[03:03]; 
      r32_mux_0_data[04:04] = i_sa_snapshot_ia_capability[04:04]; 
      r32_mux_0_data[05:05] = i_sa_snapshot_ia_capability[05:05]; 
      r32_mux_0_data[06:06] = i_sa_snapshot_ia_capability[06:06]; 
      r32_mux_0_data[07:07] = i_sa_snapshot_ia_capability[07:07]; 
      r32_mux_0_data[08:08] = i_sa_snapshot_ia_capability[08:08]; 
      r32_mux_0_data[09:09] = i_sa_snapshot_ia_capability[09:09]; 
      r32_mux_0_data[13:10] = i_sa_snapshot_ia_capability[13:10]; 
      r32_mux_0_data[14:14] = i_sa_snapshot_ia_capability[14:14]; 
      r32_mux_0_data[15:15] = i_sa_snapshot_ia_capability[15:15]; 
      r32_mux_0_data[31:28] = i_sa_snapshot_ia_capability[19:16]; 
    end
    `CR_CCEIP_64_SA_SA_SNAPSHOT_IA_STATUS: begin
      r32_mux_0_data[05:00] = i_sa_snapshot_ia_status[05:00]; 
      r32_mux_0_data[28:24] = i_sa_snapshot_ia_status[10:06]; 
      r32_mux_0_data[31:29] = i_sa_snapshot_ia_status[13:11]; 
    end
    `CR_CCEIP_64_SA_SA_SNAPSHOT_IA_WDATA_PART0: begin
      r32_mux_0_data[17:00] = o_sa_snapshot_ia_wdata_part0[17:00]; 
      r32_mux_0_data[31:18] = o_sa_snapshot_ia_wdata_part0[31:18]; 
    end
    `CR_CCEIP_64_SA_SA_SNAPSHOT_IA_WDATA_PART1: begin
      r32_mux_0_data[31:00] = o_sa_snapshot_ia_wdata_part1[31:00]; 
    end
    `CR_CCEIP_64_SA_SA_SNAPSHOT_IA_CONFIG: begin
      r32_mux_0_data[05:00] = o_sa_snapshot_ia_config[05:00]; 
      r32_mux_0_data[31:28] = o_sa_snapshot_ia_config[09:06]; 
    end
    `CR_CCEIP_64_SA_SA_SNAPSHOT_IA_RDATA_PART0: begin
      r32_mux_0_data[17:00] = i_sa_snapshot_ia_rdata_part0[17:00]; 
      r32_mux_0_data[31:18] = i_sa_snapshot_ia_rdata_part0[31:18]; 
    end
    `CR_CCEIP_64_SA_SA_SNAPSHOT_IA_RDATA_PART1: begin
      r32_mux_0_data[31:00] = i_sa_snapshot_ia_rdata_part1[31:00]; 
    end
    `CR_CCEIP_64_SA_SA_COUNT_IA_CAPABILITY: begin
      r32_mux_0_data[00:00] = i_sa_count_ia_capability[00:00]; 
      r32_mux_0_data[01:01] = i_sa_count_ia_capability[01:01]; 
      r32_mux_0_data[02:02] = i_sa_count_ia_capability[02:02]; 
      r32_mux_0_data[03:03] = i_sa_count_ia_capability[03:03]; 
      r32_mux_0_data[04:04] = i_sa_count_ia_capability[04:04]; 
      r32_mux_0_data[05:05] = i_sa_count_ia_capability[05:05]; 
      r32_mux_0_data[06:06] = i_sa_count_ia_capability[06:06]; 
      r32_mux_0_data[07:07] = i_sa_count_ia_capability[07:07]; 
      r32_mux_0_data[08:08] = i_sa_count_ia_capability[08:08]; 
      r32_mux_0_data[09:09] = i_sa_count_ia_capability[09:09]; 
      r32_mux_0_data[13:10] = i_sa_count_ia_capability[13:10]; 
      r32_mux_0_data[14:14] = i_sa_count_ia_capability[14:14]; 
      r32_mux_0_data[15:15] = i_sa_count_ia_capability[15:15]; 
      r32_mux_0_data[31:28] = i_sa_count_ia_capability[19:16]; 
    end
    `CR_CCEIP_64_SA_SA_COUNT_IA_STATUS: begin
      r32_mux_0_data[05:00] = i_sa_count_ia_status[05:00]; 
      r32_mux_0_data[28:24] = i_sa_count_ia_status[10:06]; 
      r32_mux_0_data[31:29] = i_sa_count_ia_status[13:11]; 
    end
    `CR_CCEIP_64_SA_SA_COUNT_IA_WDATA_PART0: begin
      r32_mux_0_data[17:00] = o_sa_count_ia_wdata_part0[17:00]; 
      r32_mux_0_data[31:18] = o_sa_count_ia_wdata_part0[31:18]; 
    end
    `CR_CCEIP_64_SA_SA_COUNT_IA_WDATA_PART1: begin
      r32_mux_0_data[31:00] = o_sa_count_ia_wdata_part1[31:00]; 
    end
    `CR_CCEIP_64_SA_SA_COUNT_IA_CONFIG: begin
      r32_mux_0_data[05:00] = o_sa_count_ia_config[05:00]; 
      r32_mux_0_data[31:28] = o_sa_count_ia_config[09:06]; 
    end
    `CR_CCEIP_64_SA_SA_COUNT_IA_RDATA_PART0: begin
      r32_mux_0_data[17:00] = i_sa_count_ia_rdata_part0[17:00]; 
      r32_mux_0_data[31:18] = i_sa_count_ia_rdata_part0[31:18]; 
    end
    `CR_CCEIP_64_SA_SA_COUNT_IA_RDATA_PART1: begin
      r32_mux_0_data[31:00] = i_sa_count_ia_rdata_part1[31:00]; 
    end
    endcase

  end

  
  

  
  

  reg  [31:0]  f32_data;

  assign o_reg_wr_data = f32_data;

  
  

  
  assign       o_rd_data  = (o_ack  & ~n_write) ? r32_formatted_reg_data : { 32 { 1'b0 } };
  

  
  

  wire w_load_spare_config               = w_do_write & (ws_addr == `CR_CCEIP_64_SA_SPARE_CONFIG);
  wire w_load_sa_global_ctrl             = w_do_write & (ws_addr == `CR_CCEIP_64_SA_SA_GLOBAL_CTRL);
  wire w_load_sa_ctrl_ia_wdata_part0     = w_do_write & (ws_addr == `CR_CCEIP_64_SA_SA_CTRL_IA_WDATA_PART0);
  wire w_load_sa_ctrl_ia_config          = w_do_write & (ws_addr == `CR_CCEIP_64_SA_SA_CTRL_IA_CONFIG);
  wire w_load_sa_snapshot_ia_wdata_part0 = w_do_write & (ws_addr == `CR_CCEIP_64_SA_SA_SNAPSHOT_IA_WDATA_PART0);
  wire w_load_sa_snapshot_ia_wdata_part1 = w_do_write & (ws_addr == `CR_CCEIP_64_SA_SA_SNAPSHOT_IA_WDATA_PART1);
  wire w_load_sa_snapshot_ia_config      = w_do_write & (ws_addr == `CR_CCEIP_64_SA_SA_SNAPSHOT_IA_CONFIG);
  wire w_load_sa_count_ia_wdata_part0    = w_do_write & (ws_addr == `CR_CCEIP_64_SA_SA_COUNT_IA_WDATA_PART0);
  wire w_load_sa_count_ia_wdata_part1    = w_do_write & (ws_addr == `CR_CCEIP_64_SA_SA_COUNT_IA_WDATA_PART1);
  wire w_load_sa_count_ia_config         = w_do_write & (ws_addr == `CR_CCEIP_64_SA_SA_COUNT_IA_CONFIG);


  


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
  

  cr_cceip_64_sa_regs_flops u_cr_cceip_64_sa_regs_flops (
        .clk                                    ( clk ),
        .i_reset_                               ( i_reset_ ),
        .i_sw_init                              ( i_sw_init ),
        .o_spare_config                         ( o_spare_config ),
        .o_sa_global_ctrl                       ( o_sa_global_ctrl ),
        .o_sa_ctrl_ia_wdata_part0               ( o_sa_ctrl_ia_wdata_part0 ),
        .o_sa_ctrl_ia_config                    ( o_sa_ctrl_ia_config ),
        .o_sa_snapshot_ia_wdata_part0           ( o_sa_snapshot_ia_wdata_part0 ),
        .o_sa_snapshot_ia_wdata_part1           ( o_sa_snapshot_ia_wdata_part1 ),
        .o_sa_snapshot_ia_config                ( o_sa_snapshot_ia_config ),
        .o_sa_count_ia_wdata_part0              ( o_sa_count_ia_wdata_part0 ),
        .o_sa_count_ia_wdata_part1              ( o_sa_count_ia_wdata_part1 ),
        .o_sa_count_ia_config                   ( o_sa_count_ia_config ),
        .w_load_spare_config                    ( w_load_spare_config ),
        .w_load_sa_global_ctrl                  ( w_load_sa_global_ctrl ),
        .w_load_sa_ctrl_ia_wdata_part0          ( w_load_sa_ctrl_ia_wdata_part0 ),
        .w_load_sa_ctrl_ia_config               ( w_load_sa_ctrl_ia_config ),
        .w_load_sa_snapshot_ia_wdata_part0      ( w_load_sa_snapshot_ia_wdata_part0 ),
        .w_load_sa_snapshot_ia_wdata_part1      ( w_load_sa_snapshot_ia_wdata_part1 ),
        .w_load_sa_snapshot_ia_config           ( w_load_sa_snapshot_ia_config ),
        .w_load_sa_count_ia_wdata_part0         ( w_load_sa_count_ia_wdata_part0 ),
        .w_load_sa_count_ia_wdata_part1         ( w_load_sa_count_ia_wdata_part1 ),
        .w_load_sa_count_ia_config              ( w_load_sa_count_ia_config ),
        .f32_data                               ( f32_data )
  );

  

  

  `ifdef CR_CCEIP_64_SA_DIGEST_29707F92A58C8647023343952EDBFB72
  `else
    initial begin
      $display("Error: the core decode file (cr_cceip_64_sa_regs.sv) and include file (cr_cceip_64_sa.vh) were compiled");
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


module cr_cceip_64_sa_regs_flops (
  input                                        clk,
  input                                        i_reset_,
  input                                        i_sw_init,

  
  output reg [`CR_CCEIP_64_SA_C_SPARE_T_DECL]  o_spare_config,
  output reg [`CR_CCEIP_64_SA_C_SA_GLOBAL_CTRL_T_DECL] o_sa_global_ctrl,
  output reg [`CR_CCEIP_64_SA_C_SA_CTRL_T_DECL] o_sa_ctrl_ia_wdata_part0,
  output reg [`CR_CCEIP_64_SA_C_SA_CTRL_IA_CONFIG_T_DECL] o_sa_ctrl_ia_config,
  output reg [`CR_CCEIP_64_SA_C_SA_SNAPSHOT_PART1_T_DECL] o_sa_snapshot_ia_wdata_part0,
  output reg [`CR_CCEIP_64_SA_C_SA_SNAPSHOT_PART0_T_DECL] o_sa_snapshot_ia_wdata_part1,
  output reg [`CR_CCEIP_64_SA_C_SA_SNAPSHOT_IA_CONFIG_T_DECL] o_sa_snapshot_ia_config,
  output reg [`CR_CCEIP_64_SA_C_SA_COUNT_PART1_T_DECL] o_sa_count_ia_wdata_part0,
  output reg [`CR_CCEIP_64_SA_C_SA_COUNT_PART0_T_DECL] o_sa_count_ia_wdata_part1,
  output reg [`CR_CCEIP_64_SA_C_SA_COUNT_IA_CONFIG_T_DECL] o_sa_count_ia_config,


  
  input                                        w_load_spare_config,
  input                                        w_load_sa_global_ctrl,
  input                                        w_load_sa_ctrl_ia_wdata_part0,
  input                                        w_load_sa_ctrl_ia_config,
  input                                        w_load_sa_snapshot_ia_wdata_part0,
  input                                        w_load_sa_snapshot_ia_wdata_part1,
  input                                        w_load_sa_snapshot_ia_config,
  input                                        w_load_sa_count_ia_wdata_part0,
  input                                        w_load_sa_count_ia_wdata_part1,
  input                                        w_load_sa_count_ia_config,

  input      [31:0]                             f32_data
  );

  
  

  
  

  
  
  
  always_ff @(posedge clk or negedge i_reset_) begin
    if(~i_reset_) begin
      
      o_spare_config[31:00]               <= 32'd0; 
      o_sa_global_ctrl[00:00]             <= 1'd0; 
      o_sa_global_ctrl[01:01]             <= 1'd0; 
      o_sa_global_ctrl[31:02]             <= 30'd0; 
      o_sa_ctrl_ia_wdata_part0[09:00]     <= 10'd0; 
      o_sa_ctrl_ia_wdata_part0[31:10]     <= 22'd0; 
      o_sa_ctrl_ia_config[05:00]          <= 6'd0; 
      o_sa_ctrl_ia_config[09:06]          <= 4'd0; 
      o_sa_snapshot_ia_wdata_part0[17:00] <= 18'd0; 
      o_sa_snapshot_ia_wdata_part0[31:18] <= 14'd0; 
      o_sa_snapshot_ia_wdata_part1[31:00] <= 32'd0; 
      o_sa_snapshot_ia_config[05:00]      <= 6'd0; 
      o_sa_snapshot_ia_config[09:06]      <= 4'd0; 
      o_sa_count_ia_wdata_part0[17:00]    <= 18'd0; 
      o_sa_count_ia_wdata_part0[31:18]    <= 14'd0; 
      o_sa_count_ia_wdata_part1[31:00]    <= 32'd0; 
      o_sa_count_ia_config[05:00]         <= 6'd0; 
      o_sa_count_ia_config[09:06]         <= 4'd0; 
    end
    else if(i_sw_init) begin
      
      o_spare_config[31:00]               <= 32'd0; 
      o_sa_global_ctrl[00:00]             <= 1'd0; 
      o_sa_global_ctrl[01:01]             <= 1'd0; 
      o_sa_global_ctrl[31:02]             <= 30'd0; 
      o_sa_ctrl_ia_wdata_part0[09:00]     <= 10'd0; 
      o_sa_ctrl_ia_wdata_part0[31:10]     <= 22'd0; 
      o_sa_ctrl_ia_config[05:00]          <= 6'd0; 
      o_sa_ctrl_ia_config[09:06]          <= 4'd0; 
      o_sa_snapshot_ia_wdata_part0[17:00] <= 18'd0; 
      o_sa_snapshot_ia_wdata_part0[31:18] <= 14'd0; 
      o_sa_snapshot_ia_wdata_part1[31:00] <= 32'd0; 
      o_sa_snapshot_ia_config[05:00]      <= 6'd0; 
      o_sa_snapshot_ia_config[09:06]      <= 4'd0; 
      o_sa_count_ia_wdata_part0[17:00]    <= 18'd0; 
      o_sa_count_ia_wdata_part0[31:18]    <= 14'd0; 
      o_sa_count_ia_wdata_part1[31:00]    <= 32'd0; 
      o_sa_count_ia_config[05:00]         <= 6'd0; 
      o_sa_count_ia_config[09:06]         <= 4'd0; 
    end
    else begin
      if(w_load_spare_config)               o_spare_config[31:00]               <= f32_data[31:00]; 
      if(w_load_sa_global_ctrl)             o_sa_global_ctrl[00:00]             <= f32_data[00:00]; 
      if(w_load_sa_global_ctrl)             o_sa_global_ctrl[01:01]             <= f32_data[01:01]; 
      if(w_load_sa_global_ctrl)             o_sa_global_ctrl[31:02]             <= f32_data[31:02]; 
      if(w_load_sa_ctrl_ia_wdata_part0)     o_sa_ctrl_ia_wdata_part0[09:00]     <= f32_data[09:00]; 
      if(w_load_sa_ctrl_ia_wdata_part0)     o_sa_ctrl_ia_wdata_part0[31:10]     <= f32_data[31:10]; 
      if(w_load_sa_ctrl_ia_config)          o_sa_ctrl_ia_config[05:00]          <= f32_data[05:00]; 
      if(w_load_sa_ctrl_ia_config)          o_sa_ctrl_ia_config[09:06]          <= f32_data[31:28]; 
      if(w_load_sa_snapshot_ia_wdata_part0) o_sa_snapshot_ia_wdata_part0[17:00] <= f32_data[17:00]; 
      if(w_load_sa_snapshot_ia_wdata_part0) o_sa_snapshot_ia_wdata_part0[31:18] <= f32_data[31:18]; 
      if(w_load_sa_snapshot_ia_wdata_part1) o_sa_snapshot_ia_wdata_part1[31:00] <= f32_data[31:00]; 
      if(w_load_sa_snapshot_ia_config)      o_sa_snapshot_ia_config[05:00]      <= f32_data[05:00]; 
      if(w_load_sa_snapshot_ia_config)      o_sa_snapshot_ia_config[09:06]      <= f32_data[31:28]; 
      if(w_load_sa_count_ia_wdata_part0)    o_sa_count_ia_wdata_part0[17:00]    <= f32_data[17:00]; 
      if(w_load_sa_count_ia_wdata_part0)    o_sa_count_ia_wdata_part0[31:18]    <= f32_data[31:18]; 
      if(w_load_sa_count_ia_wdata_part1)    o_sa_count_ia_wdata_part1[31:00]    <= f32_data[31:00]; 
      if(w_load_sa_count_ia_config)         o_sa_count_ia_config[05:00]         <= f32_data[05:00]; 
      if(w_load_sa_count_ia_config)         o_sa_count_ia_config[09:06]         <= f32_data[31:28]; 
    end
  end
  

  

endmodule
