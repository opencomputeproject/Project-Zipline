/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











`include "cr_su.vh"




module cr_su_regs (
  input                                        clk,
  input                                        i_reset_,
  input                                        i_sw_init,

  
  input      [`CR_SU_DECL]                     i_addr,
  input                                        i_wr_strb,
  input      [31:0]                            i_wr_data,
  input                                        i_rd_strb,
  output     [31:0]                            o_rd_data,
  output                                       o_ack,
  output                                       o_err_ack,

  
  output     [`CR_SU_C_SPARE_T_DECL]           o_spare_config,
  output     [`CR_SU_C_DBG_T_DECL]             o_dbg_config,

  
  input      [`CR_SU_C_REVID_T_DECL]           i_revision_config,
  input      [`CR_SU_C_SPARE_T_DECL]           i_spare_config,
  input      [`CR_SU_C_HB_SUP_T_DECL]          i_hb_sup,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_0_T_DECL] i_history_buffer_part0_0,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_1_T_DECL] i_history_buffer_part1_0,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_2_T_DECL] i_history_buffer_part2_0,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_3_T_DECL] i_history_buffer_part3_0,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_0_T_DECL] i_history_buffer_part0_1,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_1_T_DECL] i_history_buffer_part1_1,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_2_T_DECL] i_history_buffer_part2_1,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_3_T_DECL] i_history_buffer_part3_1,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_0_T_DECL] i_history_buffer_part0_2,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_1_T_DECL] i_history_buffer_part1_2,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_2_T_DECL] i_history_buffer_part2_2,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_3_T_DECL] i_history_buffer_part3_2,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_0_T_DECL] i_history_buffer_part0_3,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_1_T_DECL] i_history_buffer_part1_3,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_2_T_DECL] i_history_buffer_part2_3,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_3_T_DECL] i_history_buffer_part3_3,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_0_T_DECL] i_history_buffer_part0_4,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_1_T_DECL] i_history_buffer_part1_4,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_2_T_DECL] i_history_buffer_part2_4,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_3_T_DECL] i_history_buffer_part3_4,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_0_T_DECL] i_history_buffer_part0_5,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_1_T_DECL] i_history_buffer_part1_5,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_2_T_DECL] i_history_buffer_part2_5,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_3_T_DECL] i_history_buffer_part3_5,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_0_T_DECL] i_history_buffer_part0_6,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_1_T_DECL] i_history_buffer_part1_6,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_2_T_DECL] i_history_buffer_part2_6,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_3_T_DECL] i_history_buffer_part3_6,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_0_T_DECL] i_history_buffer_part0_7,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_1_T_DECL] i_history_buffer_part1_7,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_2_T_DECL] i_history_buffer_part2_7,
  input      [`CR_SU_C_HISTORY_BUFFER_PART_3_T_DECL] i_history_buffer_part3_7,
  input      [`CR_SU_C_AGG_SU_COUNTER_T_DECL]  i_agg_su_count_a,

  
  output reg                                   o_reg_written,
  output reg                                   o_reg_read,
  output     [31:0]                            o_reg_wr_data,
  output reg [`CR_SU_DECL]                     o_reg_addr
  );


  


  
  


  
  wire [`CR_SU_DECL] ws_read_addr    = o_reg_addr;
  wire [`CR_SU_DECL] ws_addr         = o_reg_addr;
  

  wire n_wr_strobe = i_wr_strb;
  wire n_rd_strobe = i_rd_strb;

  wire w_32b_aligned    = (o_reg_addr[1:0] == 2'h0);

  wire w_valid_rd_addr     = (w_32b_aligned && (ws_addr >= `CR_SU_REVISION_CONFIG) && (ws_addr <= `CR_SU_HB_SUP))
                          || (w_32b_aligned && (ws_addr >= `CR_SU_HISTORY_BUFFER_PART0_0) && (ws_addr <= `CR_SU_AGG_SU_COUNT_A));

  wire w_valid_wr_addr     = (w_32b_aligned && (ws_addr >= `CR_SU_REVISION_CONFIG) && (ws_addr <= `CR_SU_HB_SUP))
                          || (w_32b_aligned && (ws_addr >= `CR_SU_HISTORY_BUFFER_PART0_0) && (ws_addr <= `CR_SU_AGG_SU_COUNT_A));

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
    `CR_SU_REVISION_CONFIG: begin
      r32_mux_0_data[07:00] = i_revision_config[07:00]; 
    end
    `CR_SU_SPARE_CONFIG: begin
      r32_mux_0_data[31:00] = i_spare_config[31:00]; 
    end
    `CR_SU_DBG_CONFIG: begin
      r32_mux_0_data[00:00] = o_dbg_config[00:00]; 
    end
    `CR_SU_HB_SUP: begin
      r32_mux_0_data[02:00] = i_hb_sup[02:00]; 
    end
    `CR_SU_HISTORY_BUFFER_PART0_0: begin
      r32_mux_0_data[23:00] = i_history_buffer_part0_0[23:00]; 
    end
    `CR_SU_HISTORY_BUFFER_PART1_0: begin
      r32_mux_0_data[23:00] = i_history_buffer_part1_0[23:00]; 
    end
    `CR_SU_HISTORY_BUFFER_PART2_0: begin
      r32_mux_0_data[23:00] = i_history_buffer_part2_0[23:00]; 
      r32_mux_0_data[31:24] = i_history_buffer_part2_0[31:24]; 
    end
    `CR_SU_HISTORY_BUFFER_PART3_0: begin
      r32_mux_0_data[15:00] = i_history_buffer_part3_0[15:00]; 
      r32_mux_0_data[26:16] = i_history_buffer_part3_0[26:16]; 
      r32_mux_0_data[31:31] = i_history_buffer_part3_0[27:27]; 
    end
    `CR_SU_HISTORY_BUFFER_PART0_1: begin
      r32_mux_0_data[23:00] = i_history_buffer_part0_1[23:00]; 
    end
    `CR_SU_HISTORY_BUFFER_PART1_1: begin
      r32_mux_0_data[23:00] = i_history_buffer_part1_1[23:00]; 
    end
    `CR_SU_HISTORY_BUFFER_PART2_1: begin
      r32_mux_0_data[23:00] = i_history_buffer_part2_1[23:00]; 
      r32_mux_0_data[31:24] = i_history_buffer_part2_1[31:24]; 
    end
    `CR_SU_HISTORY_BUFFER_PART3_1: begin
      r32_mux_0_data[15:00] = i_history_buffer_part3_1[15:00]; 
      r32_mux_0_data[26:16] = i_history_buffer_part3_1[26:16]; 
      r32_mux_0_data[31:31] = i_history_buffer_part3_1[27:27]; 
    end
    `CR_SU_HISTORY_BUFFER_PART0_2: begin
      r32_mux_0_data[23:00] = i_history_buffer_part0_2[23:00]; 
    end
    `CR_SU_HISTORY_BUFFER_PART1_2: begin
      r32_mux_0_data[23:00] = i_history_buffer_part1_2[23:00]; 
    end
    `CR_SU_HISTORY_BUFFER_PART2_2: begin
      r32_mux_0_data[23:00] = i_history_buffer_part2_2[23:00]; 
      r32_mux_0_data[31:24] = i_history_buffer_part2_2[31:24]; 
    end
    `CR_SU_HISTORY_BUFFER_PART3_2: begin
      r32_mux_0_data[15:00] = i_history_buffer_part3_2[15:00]; 
      r32_mux_0_data[26:16] = i_history_buffer_part3_2[26:16]; 
      r32_mux_0_data[31:31] = i_history_buffer_part3_2[27:27]; 
    end
    `CR_SU_HISTORY_BUFFER_PART0_3: begin
      r32_mux_0_data[23:00] = i_history_buffer_part0_3[23:00]; 
    end
    `CR_SU_HISTORY_BUFFER_PART1_3: begin
      r32_mux_0_data[23:00] = i_history_buffer_part1_3[23:00]; 
    end
    `CR_SU_HISTORY_BUFFER_PART2_3: begin
      r32_mux_0_data[23:00] = i_history_buffer_part2_3[23:00]; 
      r32_mux_0_data[31:24] = i_history_buffer_part2_3[31:24]; 
    end
    endcase

    case (ws_read_addr)
    `CR_SU_HISTORY_BUFFER_PART3_3: begin
      r32_mux_1_data[15:00] = i_history_buffer_part3_3[15:00]; 
      r32_mux_1_data[26:16] = i_history_buffer_part3_3[26:16]; 
      r32_mux_1_data[31:31] = i_history_buffer_part3_3[27:27]; 
    end
    `CR_SU_HISTORY_BUFFER_PART0_4: begin
      r32_mux_1_data[23:00] = i_history_buffer_part0_4[23:00]; 
    end
    `CR_SU_HISTORY_BUFFER_PART1_4: begin
      r32_mux_1_data[23:00] = i_history_buffer_part1_4[23:00]; 
    end
    `CR_SU_HISTORY_BUFFER_PART2_4: begin
      r32_mux_1_data[23:00] = i_history_buffer_part2_4[23:00]; 
      r32_mux_1_data[31:24] = i_history_buffer_part2_4[31:24]; 
    end
    `CR_SU_HISTORY_BUFFER_PART3_4: begin
      r32_mux_1_data[15:00] = i_history_buffer_part3_4[15:00]; 
      r32_mux_1_data[26:16] = i_history_buffer_part3_4[26:16]; 
      r32_mux_1_data[31:31] = i_history_buffer_part3_4[27:27]; 
    end
    `CR_SU_HISTORY_BUFFER_PART0_5: begin
      r32_mux_1_data[23:00] = i_history_buffer_part0_5[23:00]; 
    end
    `CR_SU_HISTORY_BUFFER_PART1_5: begin
      r32_mux_1_data[23:00] = i_history_buffer_part1_5[23:00]; 
    end
    `CR_SU_HISTORY_BUFFER_PART2_5: begin
      r32_mux_1_data[23:00] = i_history_buffer_part2_5[23:00]; 
      r32_mux_1_data[31:24] = i_history_buffer_part2_5[31:24]; 
    end
    `CR_SU_HISTORY_BUFFER_PART3_5: begin
      r32_mux_1_data[15:00] = i_history_buffer_part3_5[15:00]; 
      r32_mux_1_data[26:16] = i_history_buffer_part3_5[26:16]; 
      r32_mux_1_data[31:31] = i_history_buffer_part3_5[27:27]; 
    end
    `CR_SU_HISTORY_BUFFER_PART0_6: begin
      r32_mux_1_data[23:00] = i_history_buffer_part0_6[23:00]; 
    end
    `CR_SU_HISTORY_BUFFER_PART1_6: begin
      r32_mux_1_data[23:00] = i_history_buffer_part1_6[23:00]; 
    end
    `CR_SU_HISTORY_BUFFER_PART2_6: begin
      r32_mux_1_data[23:00] = i_history_buffer_part2_6[23:00]; 
      r32_mux_1_data[31:24] = i_history_buffer_part2_6[31:24]; 
    end
    `CR_SU_HISTORY_BUFFER_PART3_6: begin
      r32_mux_1_data[15:00] = i_history_buffer_part3_6[15:00]; 
      r32_mux_1_data[26:16] = i_history_buffer_part3_6[26:16]; 
      r32_mux_1_data[31:31] = i_history_buffer_part3_6[27:27]; 
    end
    `CR_SU_HISTORY_BUFFER_PART0_7: begin
      r32_mux_1_data[23:00] = i_history_buffer_part0_7[23:00]; 
    end
    `CR_SU_HISTORY_BUFFER_PART1_7: begin
      r32_mux_1_data[23:00] = i_history_buffer_part1_7[23:00]; 
    end
    `CR_SU_HISTORY_BUFFER_PART2_7: begin
      r32_mux_1_data[23:00] = i_history_buffer_part2_7[23:00]; 
      r32_mux_1_data[31:24] = i_history_buffer_part2_7[31:24]; 
    end
    `CR_SU_HISTORY_BUFFER_PART3_7: begin
      r32_mux_1_data[15:00] = i_history_buffer_part3_7[15:00]; 
      r32_mux_1_data[26:16] = i_history_buffer_part3_7[26:16]; 
      r32_mux_1_data[31:31] = i_history_buffer_part3_7[27:27]; 
    end
    `CR_SU_AGG_SU_COUNT_A: begin
      r32_mux_1_data[31:00] = i_agg_su_count_a[31:00]; 
    end
    endcase

  end

  
  

  
  

  reg  [31:0]  f32_data;

  assign o_reg_wr_data = f32_data;

  
  

  
  assign       o_rd_data  = (o_ack  & ~n_write) ? r32_formatted_reg_data : { 32 { 1'b0 } };
  

  
  

  wire w_load_spare_config = w_do_write & (ws_addr == `CR_SU_SPARE_CONFIG);
  wire w_load_dbg_config   = w_do_write & (ws_addr == `CR_SU_DBG_CONFIG);


  


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
  

  cr_su_regs_flops u_cr_su_regs_flops (
        .clk                                    ( clk ),
        .i_reset_                               ( i_reset_ ),
        .i_sw_init                              ( i_sw_init ),
        .o_spare_config                         ( o_spare_config ),
        .o_dbg_config                           ( o_dbg_config ),
        .w_load_spare_config                    ( w_load_spare_config ),
        .w_load_dbg_config                      ( w_load_dbg_config ),
        .f32_data                               ( f32_data )
  );

  

  

  `ifdef CR_SU_DIGEST_1808A9542F770223F494BD4FAE95D7D6
  `else
    initial begin
      $display("Error: the core decode file (cr_su_regs.sv) and include file (cr_su.vh) were compiled");
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


module cr_su_regs_flops (
  input                               clk,
  input                               i_reset_,
  input                               i_sw_init,

  
  output reg [`CR_SU_C_SPARE_T_DECL]  o_spare_config,
  output reg [`CR_SU_C_DBG_T_DECL]    o_dbg_config,


  
  input                               w_load_spare_config,
  input                               w_load_dbg_config,

  input      [31:0]                             f32_data
  );

  
  

  
  

  
  
  
  always_ff @(posedge clk or negedge i_reset_) begin
    if(~i_reset_) begin
      
      o_spare_config[31:00] <= 32'd0; 
      o_dbg_config[00:00]   <= 1'd0; 
    end
    else if(i_sw_init) begin
      
      o_spare_config[31:00] <= 32'd0; 
      o_dbg_config[00:00]   <= 1'd0; 
    end
    else begin
      if(w_load_spare_config) o_spare_config[31:00] <= f32_data[31:00]; 
      if(w_load_dbg_config)   o_dbg_config[00:00]   <= f32_data[00:00]; 
    end
  end
  

  

endmodule
