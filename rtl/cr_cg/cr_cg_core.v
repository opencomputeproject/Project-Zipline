/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_cg.vh"

module cr_cg_core #
(
 parameter  STUB_MODE=0
 )

(
  
  cg_ib_out, cg_ob_out, cg_int, cg_stat_events,
  
  clk, rst_n, ext_ib_out, cg_ib_in, cg_ob_in, cg_tlv_parse_action_0,
  cg_tlv_parse_action_1, debug_ctl_config, cg_module_id, cceip_cfg
  );
  
`include "cr_structs.sv"
  
  import cr_cgPKG::*;
  import cr_cg_regsPKG::*;

  
  
  
  input                                 clk;
  input                                 rst_n; 
  
  
  
  
  
  
  input  axi4s_dp_rdy_t                 ext_ib_out;  
  input  axi4s_dp_bus_t                 cg_ib_in;
  output axi4s_dp_rdy_t                 cg_ib_out;

  
  
  
  input  axi4s_dp_rdy_t                 cg_ob_in;
  output axi4s_dp_bus_t                 cg_ob_out;

  
  
  
  input  cg_tlv_parse_action_31_0_t     cg_tlv_parse_action_0;
  input  cg_tlv_parse_action_63_32_t    cg_tlv_parse_action_1;
  input  debug_ctl_t                    debug_ctl_config;

  
  
  
  output tlvp_int_t                     cg_int;

  
  
  
  output cg_stats_t                     cg_stat_events;

  
  
  
  input  [`MODULE_ID_WIDTH-1:0]         cg_module_id;
  input                                 cceip_cfg;

  
  axi4s_dp_bus_t   cg_ib_in_mod;

  always_comb
  begin
    
    
    cg_ib_in_mod.tvalid  = ext_ib_out.tready ? cg_ib_in.tvalid : 1'b0; 
    cg_ib_in_mod.tlast   = cg_ib_in.tlast;
    cg_ib_in_mod.tid     = cg_ib_in.tid;
    cg_ib_in_mod.tstrb   = cg_ib_in.tstrb;   
    cg_ib_in_mod.tuser   = cg_ib_in.tuser;  
    cg_ib_in_mod.tdata   = cg_ib_in.tdata;  
  end

  


  cr_cg_tlv_mods #
  (
   .STUB_MODE (STUB_MODE)
   )

  u_cr_cg_tlv_mods 
  (
   
   
   .cg_ib_out                           (cg_ib_out),
   .cg_ob_out                           (cg_ob_out),
   .cg_int                              (cg_int),
   .cg_stat_events                      (cg_stat_events),
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .cg_tlv_parse_action_0               (cg_tlv_parse_action_0),
   .cg_tlv_parse_action_1               (cg_tlv_parse_action_1),
   .debug_ctl_config                    (debug_ctl_config),
   .cg_ib_in                            (cg_ib_in_mod),          
   .cg_ob_in                            (cg_ob_in),
   .cg_module_id                        (cg_module_id[`MODULE_ID_WIDTH-1:0]),
   .cceip_cfg                           (cceip_cfg));

endmodule 









