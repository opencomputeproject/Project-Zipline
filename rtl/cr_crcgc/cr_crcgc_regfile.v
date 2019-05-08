/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_crcgc.vh"
 
module cr_crcgc_regfile 

   (
  
  rbus_ring_o, tlv_parse_action_0, tlv_parse_action_1,
  regs_crc_gen_en, regs_crc_chk_en,
  
  clk, rst_n, rbus_ring_i, cfg_start_addr, cfg_end_addr, cts_hb
  );

`include "cr_structs.sv" 
  
  import cr_crcgcPKG::*;
  import cr_crcgc_regfilePKG::*;
  
  
  
  
  input logic                         clk;   
  input logic                         rst_n;
  
  
  
  
  input                               rbus_ring_t rbus_ring_i;
  output                              rbus_ring_t rbus_ring_o;
  input [`N_RBUS_ADDR_BITS-1:0]       cfg_start_addr;
  input [`N_RBUS_ADDR_BITS-1:0]       cfg_end_addr;
   
  
  
  
  output [`CR_CRCGC_C_REGS_TLV_PARSE_ACTION_31_0_T_DECL]  tlv_parse_action_0;
  output [`CR_CRCGC_C_REGS_TLV_PARSE_ACTION_63_32_T_DECL] tlv_parse_action_1;
  output                                                  regs_crc_gen_en;
  output                                                  regs_crc_chk_en;
 
    
  
  
  
  input logic [95:0]                   cts_hb[7:0];

   
   
   logic                locl_ack;               
   logic                locl_err_ack;           
   logic [31:0]         locl_rd_data;           
   logic                locl_rd_strb;           
   logic                locl_wr_strb;           
   logic                rd_stb;                 
   logic                wr_stb;                 
   
   
   logic [`CR_CRCGC_DECL]       locl_addr;
   logic [`N_RBUS_DATA_BITS-1:0]    locl_wr_data;
   spare_t                          spare; 

  logic [31:0]                      history_buffer_part0_0;
  logic [31:0]                      history_buffer_part1_0;
  logic [31:0]                      history_buffer_part2_0;
  logic [31:0]                      history_buffer_part0_1;
  logic [31:0]                      history_buffer_part1_1;
  logic [31:0]                      history_buffer_part2_1;
  logic [31:0]                      history_buffer_part0_2;
  logic [31:0]                      history_buffer_part1_2;
  logic [31:0]                      history_buffer_part2_2;
  logic [31:0]                      history_buffer_part0_3;
  logic [31:0]                      history_buffer_part1_3;
  logic [31:0]                      history_buffer_part2_3;
  logic [31:0]                      history_buffer_part0_4;
  logic [31:0]                      history_buffer_part1_4;
  logic [31:0]                      history_buffer_part2_4;
  logic [31:0]                      history_buffer_part0_5;
  logic [31:0]                      history_buffer_part1_5;
  logic [31:0]                      history_buffer_part2_5;
  logic [31:0]                      history_buffer_part0_6;
  logic [31:0]                      history_buffer_part1_6;
  logic [31:0]                      history_buffer_part2_6;
  logic [31:0]                      history_buffer_part0_7;
  logic [31:0]                      history_buffer_part1_7;
  logic [31:0]                      history_buffer_part2_7;
  crcgc_ctrl_t                      regs_crcgc_ctrl;
  

  
  assign history_buffer_part0_0 = cts_hb[0][31:0];
  assign history_buffer_part1_0 = cts_hb[0][63:32];
  assign history_buffer_part2_0 = cts_hb[0][95:64];
  
  assign history_buffer_part0_1 = cts_hb[1][31:0];
  assign history_buffer_part1_1 = cts_hb[1][63:32];
  assign history_buffer_part2_1 = cts_hb[1][95:64];
  
  assign history_buffer_part0_2 = cts_hb[2][31:0];
  assign history_buffer_part1_2 = cts_hb[2][63:32];
  assign history_buffer_part2_2 = cts_hb[2][95:64];
  
  assign history_buffer_part0_3 = cts_hb[3][31:0];
  assign history_buffer_part1_3 = cts_hb[3][63:32];
  assign history_buffer_part2_3 = cts_hb[3][95:64];
  
  assign history_buffer_part0_4 = cts_hb[4][31:0];
  assign history_buffer_part1_4 = cts_hb[4][63:32];
  assign history_buffer_part2_4 = cts_hb[4][95:64];
  
  assign history_buffer_part0_5 = cts_hb[5][31:0];
  assign history_buffer_part1_5 = cts_hb[5][63:32];
  assign history_buffer_part2_5 = cts_hb[5][95:64];
  
  assign history_buffer_part0_6 = cts_hb[6][31:0];
  assign history_buffer_part1_6 = cts_hb[6][63:32];
  assign history_buffer_part2_6 = cts_hb[6][95:64];
  
  assign history_buffer_part0_7 = cts_hb[7][31:0];
  assign history_buffer_part1_7 = cts_hb[7][63:32];
  assign history_buffer_part2_7 = cts_hb[7][95:64];

  assign regs_crc_gen_en = regs_crcgc_ctrl.f.regs_crc_gen_en;
  assign regs_crc_chk_en = regs_crcgc_ctrl.f.regs_crc_chk_en;
  
   
   
   

   
   revid_t revid_wire;
     
   CR_TIE_CELL revid_wire_0 (.ob(revid_wire.f.revid[0] ), .o());
   CR_TIE_CELL revid_wire_1 (.ob(revid_wire.f.revid[1]), .o());
   CR_TIE_CELL revid_wire_2 (.ob(revid_wire.f.revid[2]), .o());
   CR_TIE_CELL revid_wire_3 (.ob(revid_wire.f.revid[3]), .o());
   CR_TIE_CELL revid_wire_4 (.ob(revid_wire.f.revid[4]), .o());
   CR_TIE_CELL revid_wire_5 (.ob(revid_wire.f.revid[5]), .o());
   CR_TIE_CELL revid_wire_6 (.ob(revid_wire.f.revid[6]), .o());
   CR_TIE_CELL revid_wire_7 (.ob(revid_wire.f.revid[7]), .o());
   
   
   
   genvar              i;
   
   
   cr_crcgc_regs 
     u_cr_crcgc_regs 
      (
       
       .o_rd_data                       (locl_rd_data[31:0]),    
       .o_ack                           (locl_ack),              
       .o_err_ack                       (locl_err_ack),          
       .o_spare_config                  (spare),                 
       .o_regs_tlv_parse_action_0       (tlv_parse_action_0),    
       .o_regs_tlv_parse_action_1       (tlv_parse_action_1),    
       .o_regs_crcgc_ctrl               (regs_crcgc_ctrl),       
       .o_reg_written                   (wr_stb),                
       .o_reg_read                      (rd_stb),                
       .o_reg_wr_data                   (),                      
       .o_reg_addr                      (),                      
       
       .clk                             (clk),
       .i_reset_                        (rst_n),                 
       .i_sw_init                       (1'd0),                  
       .i_addr                          (locl_addr),             
       .i_wr_strb                       (locl_wr_strb),          
       .i_wr_data                       (locl_wr_data),          
       .i_rd_strb                       (locl_rd_strb),          
       .i_revision_config               (revid_wire),            
       .i_spare_config                  (spare),                 
       .i_history_buffer_part2_0        (history_buffer_part2_0), 
       .i_history_buffer_part1_0        (history_buffer_part1_0), 
       .i_history_buffer_part0_0        (history_buffer_part0_0), 
       .i_history_buffer_part2_1        (history_buffer_part2_1), 
       .i_history_buffer_part1_1        (history_buffer_part1_1), 
       .i_history_buffer_part0_1        (history_buffer_part0_1), 
       .i_history_buffer_part2_2        (history_buffer_part2_2), 
       .i_history_buffer_part1_2        (history_buffer_part1_2), 
       .i_history_buffer_part0_2        (history_buffer_part0_2), 
       .i_history_buffer_part2_3        (history_buffer_part2_3), 
       .i_history_buffer_part1_3        (history_buffer_part1_3), 
       .i_history_buffer_part0_3        (history_buffer_part0_3), 
       .i_history_buffer_part2_4        (history_buffer_part2_4), 
       .i_history_buffer_part1_4        (history_buffer_part1_4), 
       .i_history_buffer_part0_4        (history_buffer_part0_4), 
       .i_history_buffer_part2_5        (history_buffer_part2_5), 
       .i_history_buffer_part1_5        (history_buffer_part1_5), 
       .i_history_buffer_part0_5        (history_buffer_part0_5), 
       .i_history_buffer_part2_6        (history_buffer_part2_6), 
       .i_history_buffer_part1_6        (history_buffer_part1_6), 
       .i_history_buffer_part0_6        (history_buffer_part0_6), 
       .i_history_buffer_part2_7        (history_buffer_part2_7), 
       .i_history_buffer_part1_7        (history_buffer_part1_7), 
       .i_history_buffer_part0_7        (history_buffer_part0_7), 
       .i_regs_crcgc_ctrl               (regs_crcgc_ctrl));      

   
   
   
   nx_rbus_ring 
     #(.IO_ASYNC         (1),                             
    
       .N_RBUS_ADDR_BITS (`N_RBUS_ADDR_BITS),             
       .N_LOCL_ADDR_BITS (`CR_CRCGC_WIDTH),           
       .N_RBUS_DATA_BITS (`N_RBUS_DATA_BITS))             
   u_nx_rbus_ring 
     (.*,
      
      .rbus_addr_o                      (rbus_ring_o.addr),      
      .rbus_wr_strb_o                   (rbus_ring_o.wr_strb),   
      .rbus_wr_data_o                   (rbus_ring_o.wr_data),   
      .rbus_rd_strb_o                   (rbus_ring_o.rd_strb),   
      .locl_addr_o                      (locl_addr),             
      .locl_wr_strb_o                   (locl_wr_strb),          
      .locl_wr_data_o                   (locl_wr_data),          
      .locl_rd_strb_o                   (locl_rd_strb),          
      .rbus_rd_data_o                   (rbus_ring_o.rd_data),   
      .rbus_ack_o                       (rbus_ring_o.ack),       
      .rbus_err_ack_o                   (rbus_ring_o.err_ack),   
      
      .rbus_addr_i                      (rbus_ring_i.addr),      
      .rbus_wr_strb_i                   (rbus_ring_i.wr_strb),   
      .rbus_wr_data_i                   (rbus_ring_i.wr_data),   
      .rbus_rd_strb_i                   (rbus_ring_i.rd_strb),   
      .rbus_rd_data_i                   (rbus_ring_i.rd_data),   
      .rbus_ack_i                       (rbus_ring_i.ack),       
      .rbus_err_ack_i                   (rbus_ring_i.err_ack),   
      .locl_rd_data_i                   (locl_rd_data),          
      .locl_ack_i                       (locl_ack),              
      .locl_err_ack_i                   (locl_err_ack));                 


   
endmodule 










