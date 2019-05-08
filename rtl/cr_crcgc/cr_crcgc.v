/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_crcgc.vh"

module cr_crcgc #
(
 parameter  STUB_MODE=0
 )

  (
  
  crcgc_ib_out, rbus_ring_o, crcgc_ob_out, crcgc_stat_events,
  crcgc_int,
  
  clk, rst_n, scan_en, scan_mode, scan_rst_n, ovstb, lvm, mlvm,
  ext_ib_out, crcgc_ib_in, rbus_ring_i, cfg_start_addr, cfg_end_addr,
  crcgc_ob_in, cceip_cfg, crcgc_mode, crcgc_module_id
  );

`include "cr_structs.sv"

  import cr_crcgc_regfilePKG::*;
  import cr_crcgc_regsPKG::*;
  
  
  
  input         clk;
  input         rst_n; 

  
  
  
  input         scan_en;
  input         scan_mode;
  input         scan_rst_n;

  
  
  
  input         ovstb;
  input         lvm;
  input         mlvm;

  
  
  
  input         axi4s_dp_rdy_t ext_ib_out;  
  input         axi4s_dp_bus_t crcgc_ib_in;
  output        axi4s_dp_rdy_t crcgc_ib_out;
  
  
  
  
  input         rbus_ring_t rbus_ring_i;
  output        rbus_ring_t rbus_ring_o;
   input [`N_RBUS_ADDR_BITS-1:0] cfg_start_addr;
   input [`N_RBUS_ADDR_BITS-1:0] cfg_end_addr;
   
  
  
  
  input         axi4s_dp_rdy_t crcgc_ob_in;
  output        axi4s_dp_bus_t crcgc_ob_out;

  
  
  
  output        [`CRCGC_STATS_WIDTH-1:0] crcgc_stat_events;

  
  
  
  input         cceip_cfg;
  input [2:0]   crcgc_mode;
  input         [`MODULE_ID_WIDTH-1:0] crcgc_module_id;

  
  
  
  output                               crcgc_int;
  
`ifndef CR_CRCGC_BBOX

  
  
  logic [95:0]          cts_hb [7:0];           
  logic                 regs_crc_chk_en;        
  logic                 regs_crc_gen_en;        
  logic [`CR_CRCGC_C_REGS_TLV_PARSE_ACTION_31_0_T_DECL] tlv_parse_action_0;
  logic [`CR_CRCGC_C_REGS_TLV_PARSE_ACTION_63_32_T_DECL] tlv_parse_action_1;
  logic                 tlvp_error;             
  
  assign crcgc_int = tlvp_error;
  
  
  
  
  cr_crcgc_core#
  (
   .STUB_MODE (STUB_MODE)
   )
   u_cr_crcgc_core
  (
   
   
   .crcgc_ib_out                        (crcgc_ib_out),
   .crcgc_ob_out                        (crcgc_ob_out),
   .cts_hb                              (cts_hb),
   .crcgc_stat_events                   (crcgc_stat_events[`CRCGC_STATS_WIDTH-1:0]),
   .tlvp_error                          (tlvp_error),
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .ext_ib_out                          (ext_ib_out),
   .crcgc_ib_in                         (crcgc_ib_in),
   .crcgc_ob_in                         (crcgc_ob_in),
   .cceip_cfg                           (cceip_cfg),
   .crcgc_mode                          (crcgc_mode[2:0]),
   .crcgc_module_id                     (crcgc_module_id[`MODULE_ID_WIDTH-1:0]),
   .tlv_parse_action_1                  (tlv_parse_action_1[`CR_CRCGC_C_REGS_TLV_PARSE_ACTION_63_32_T_DECL]),
   .tlv_parse_action_0                  (tlv_parse_action_0[`CR_CRCGC_C_REGS_TLV_PARSE_ACTION_31_0_T_DECL]),
   .regs_crc_gen_en                     (regs_crc_gen_en),
   .regs_crc_chk_en                     (regs_crc_chk_en));
  
  
  
  cr_crcgc_regfile

  u_cr_crcgc_regfile 
  (
   
   
   .rbus_ring_o                         (rbus_ring_o),
   .tlv_parse_action_0                  (tlv_parse_action_0[`CR_CRCGC_C_REGS_TLV_PARSE_ACTION_31_0_T_DECL]),
   .tlv_parse_action_1                  (tlv_parse_action_1[`CR_CRCGC_C_REGS_TLV_PARSE_ACTION_63_32_T_DECL]),
   .regs_crc_gen_en                     (regs_crc_gen_en),
   .regs_crc_chk_en                     (regs_crc_chk_en),
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .rbus_ring_i                         (rbus_ring_i),
   .cfg_start_addr                      (cfg_start_addr[`N_RBUS_ADDR_BITS-1:0]),
   .cfg_end_addr                        (cfg_end_addr[`N_RBUS_ADDR_BITS-1:0]),
   .cts_hb                              (cts_hb));
  `endif
endmodule











