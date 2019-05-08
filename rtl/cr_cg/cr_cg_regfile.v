/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_cg.vh"

module cr_cg_regfile 

  (
  
  rbus_ring_o, cg_tlv_parse_action_0, cg_tlv_parse_action_1,
  debug_ctl_config,
  
  rst_n, clk, rbus_ring_i, cfg_start_addr, cfg_end_addr
  );

`include "cr_structs.sv"   
  import cr_cgPKG::*;
  import cr_cg_regfilePKG::*;
  
  
  output rbus_ring_t                    rbus_ring_o;
  
  output cg_tlv_parse_action_31_0_t     cg_tlv_parse_action_0;
  output cg_tlv_parse_action_63_32_t    cg_tlv_parse_action_1;
  output debug_ctl_t                    debug_ctl_config;

  
  input logic 			        rst_n;
  input logic 			        clk;
  input rbus_ring_t                     rbus_ring_i;
  
   input [`N_RBUS_ADDR_BITS-1:0] cfg_start_addr;
   input [`N_RBUS_ADDR_BITS-1:0] cfg_end_addr;
   
  
  
  logic                 locl_ack;               
  logic                 locl_err_ack;           
  logic [31:0]          locl_rd_data;           
  logic                 locl_rd_strb;           
  logic                 locl_wr_strb;           
  logic                 rd_stb;                 
  logic                 wr_stb;                 
  
  
  logic [`CR_CG_DECL]                  locl_addr;
  logic [`N_RBUS_DATA_BITS-1:0]        locl_wr_data;
  spare_t                              spare; 
  
  
  
  

  
  revid_t revid_wire;
  
  CR_TIE_CELL  revid_wire_0 (.ob(revid_wire.f.revid[0]), .o());
  CR_TIE_CELL  revid_wire_1 (.ob(revid_wire.f.revid[1]), .o());
  CR_TIE_CELL  revid_wire_2 (.ob(revid_wire.f.revid[2]), .o());
  CR_TIE_CELL  revid_wire_3 (.ob(revid_wire.f.revid[3]), .o());
  CR_TIE_CELL  revid_wire_4 (.ob(revid_wire.f.revid[4]), .o());
  CR_TIE_CELL  revid_wire_5 (.ob(revid_wire.f.revid[5]), .o());
  CR_TIE_CELL  revid_wire_6 (.ob(revid_wire.f.revid[6]), .o());
  CR_TIE_CELL  revid_wire_7 (.ob(revid_wire.f.revid[7]), .o());
  
  genvar                               i;
  
  
  
  cr_cg_regs u_cr_cg_regs (
                           
                           .o_rd_data           (locl_rd_data[31:0]), 
                           .o_ack               (locl_ack),      
                           .o_err_ack           (locl_err_ack),  
                           .o_spare_config      (spare),         
                           .o_cg_tlv_parse_action_0(cg_tlv_parse_action_0[`CR_CG_C_CG_TLV_PARSE_ACTION_31_0_T_DECL]), 
                           .o_cg_tlv_parse_action_1(cg_tlv_parse_action_1[`CR_CG_C_CG_TLV_PARSE_ACTION_63_32_T_DECL]), 
                           .o_debug_ctl_config  (debug_ctl_config[`CR_CG_C_DEBUG_CTL_T_DECL]), 
                           .o_reg_written       (wr_stb),        
                           .o_reg_read          (rd_stb),        
                           .o_reg_wr_data       (),              
                           .o_reg_addr          (),              
                           
                           .clk                 (clk),
                           .i_reset_            (rst_n),         
                           .i_sw_init           (1'd0),          
                           .i_addr              (locl_addr),     
                           .i_wr_strb           (locl_wr_strb),  
                           .i_wr_data           (locl_wr_data),  
                           .i_rd_strb           (locl_rd_strb),  
                           .i_revision_config   (revid_wire),    
                           .i_spare_config      (spare));         

  
  
  
  nx_rbus_ring 
  #(
    .N_RBUS_ADDR_BITS (`N_RBUS_ADDR_BITS),             
    .N_LOCL_ADDR_BITS (`CR_CG_WIDTH),           
    .N_RBUS_DATA_BITS (`N_RBUS_DATA_BITS))             
  u_nx_rbus_ring 
  (.*,
   
   .rbus_addr_o                         (rbus_ring_o.addr),      
   .rbus_wr_strb_o                      (rbus_ring_o.wr_strb),   
   .rbus_wr_data_o                      (rbus_ring_o.wr_data),   
   .rbus_rd_strb_o                      (rbus_ring_o.rd_strb),   
   .locl_addr_o                         (locl_addr),             
   .locl_wr_strb_o                      (locl_wr_strb),          
   .locl_wr_data_o                      (locl_wr_data),          
   .locl_rd_strb_o                      (locl_rd_strb),          
   .rbus_rd_data_o                      (rbus_ring_o.rd_data),   
   .rbus_ack_o                          (rbus_ring_o.ack),       
   .rbus_err_ack_o                      (rbus_ring_o.err_ack),   
   
   .rbus_addr_i                         (rbus_ring_i.addr),      
   .rbus_wr_strb_i                      (rbus_ring_i.wr_strb),   
   .rbus_wr_data_i                      (rbus_ring_i.wr_data),   
   .rbus_rd_strb_i                      (rbus_ring_i.rd_strb),   
   .rbus_rd_data_i                      (rbus_ring_i.rd_data),   
   .rbus_ack_i                          (rbus_ring_i.ack),       
   .rbus_err_ack_i                      (rbus_ring_i.err_ack),   
   .locl_rd_data_i                      (locl_rd_data),          
   .locl_ack_i                          (locl_ack),              
   .locl_err_ack_i                      (locl_err_ack));          


  
endmodule 










