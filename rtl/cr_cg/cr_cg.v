/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_cg.vh"

module cr_cg #
(
 parameter  STUB_MODE=0
 )
(
 
 cg_ib_out, rbus_ring_o, cg_ob_out, cg_stat_events, cg_int,
 
 clk, rst_n, scan_en, scan_mode, scan_rst_n, ovstb, lvm, mlvm,
 ext_ib_out, cg_ib_in, rbus_ring_i, cfg_start_addr, cfg_end_addr,
 cg_ob_in, cg_module_id, cceip_cfg
 );

`include "cr_structs.sv"
`include "ccx_std.vh"

  import cr_cgPKG::*;
  import cr_cg_regsPKG::*;
  
  
  
  input                                clk;
  input                                rst_n; 

  
  
  
  input                                scan_en;
  input                                scan_mode;
  input                                scan_rst_n;

  
  
  
  input                                ovstb;
  input                                lvm;
  input                                mlvm;

  
  
  
  input         axi4s_dp_rdy_t         ext_ib_out;  
  input         axi4s_dp_bus_t         cg_ib_in;
  output        axi4s_dp_rdy_t         cg_ib_out;
  
  
  
  
  input         rbus_ring_t            rbus_ring_i;
  output        rbus_ring_t            rbus_ring_o;
   input [`N_RBUS_ADDR_BITS-1:0] cfg_start_addr;
   input [`N_RBUS_ADDR_BITS-1:0] cfg_end_addr;
   
  
  
  
  input         axi4s_dp_rdy_t         cg_ob_in;
  output        axi4s_dp_bus_t         cg_ob_out;

  
  
  
  output        cg_stats_t             cg_stat_events;

  
  
  
  output        tlvp_int_t             cg_int;

  
  
  
  input         [`MODULE_ID_WIDTH-1:0] cg_module_id;
  input                                cceip_cfg;

  
  
  cg_tlv_parse_action_31_0_t cg_tlv_parse_action_0;
  cg_tlv_parse_action_63_32_t cg_tlv_parse_action_1;
  debug_ctl_t           debug_ctl_config;       
  


  cr_cg_core #
  (
   .STUB_MODE (STUB_MODE)
   )
  u_cr_cg_core
  (
   
   
   .cg_ib_out                           (cg_ib_out),
   .cg_ob_out                           (cg_ob_out),
   .cg_int                              (cg_int),
   .cg_stat_events                      (cg_stat_events),
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .ext_ib_out                          (ext_ib_out),
   .cg_ib_in                            (cg_ib_in),
   .cg_ob_in                            (cg_ob_in),
   .cg_tlv_parse_action_0               (cg_tlv_parse_action_0),
   .cg_tlv_parse_action_1               (cg_tlv_parse_action_1),
   .debug_ctl_config                    (debug_ctl_config),
   .cg_module_id                        (cg_module_id[`MODULE_ID_WIDTH-1:0]),
   .cceip_cfg                           (cceip_cfg));

  cr_cg_regfile
 
  u_cr_cg_regfile 
  (
   
   
   .rbus_ring_o                         (rbus_ring_o),
   .cg_tlv_parse_action_0               (cg_tlv_parse_action_0),
   .cg_tlv_parse_action_1               (cg_tlv_parse_action_1),
   .debug_ctl_config                    (debug_ctl_config),
   
   .rst_n                               (rst_n),
   .clk                                 (clk),
   .rbus_ring_i                         (rbus_ring_i),
   .cfg_start_addr                      (cfg_start_addr[`N_RBUS_ADDR_BITS-1:0]),
   .cfg_end_addr                        (cfg_end_addr[`N_RBUS_ADDR_BITS-1:0]));
  
endmodule











