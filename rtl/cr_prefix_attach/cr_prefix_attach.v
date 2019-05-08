/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_prefix_attach.vh"
`include "crPKG.svp"

module cr_prefix_attach
#(parameter 
  PREFIX_ATTACH_STUB=0)    
  (
  
  bimc_odat, bimc_osync, prefix_attach_ib_out, rbus_ring_o,
  prefix_attach_ob_out, prefix_attach_int,
  
  clk, rst_n, scan_en, scan_mode, scan_rst_n, ovstb, lvm, mlvm,
  bimc_rst_n, bimc_idat, bimc_isync, prefix_attach_ib_in, rbus_ring_i,
  cfg_start_addr, cfg_end_addr, prefix_attach_ob_in, cceip_cfg,
  prefix_attach_module_id
  );

`include "cr_structs.sv"
`include "ccx_std.vh"

  import cr_prefix_attachPKG::*;
  import cr_prefix_attach_regsPKG::*;
  
  
  
  input                         clk;
  input                         rst_n; 

  
  
  
  input                         scan_en;
  input                         scan_mode;
  input                         scan_rst_n;

  
  
  
  input                         ovstb;
  input                         lvm;
  input                         mlvm;

  input                         bimc_rst_n;        
  input                         bimc_idat;       
  input                         bimc_isync;      
    
  output logic                  bimc_odat;       
  output logic                  bimc_osync;
  
  
  
  input  axi4s_dp_bus_t         prefix_attach_ib_in;
  output axi4s_dp_rdy_t         prefix_attach_ib_out;
  
  
  
  
  input   rbus_ring_t           rbus_ring_i;
  output  rbus_ring_t           rbus_ring_o;
   
   input [`N_RBUS_ADDR_BITS-1:0] cfg_start_addr;
   input [`N_RBUS_ADDR_BITS-1:0] cfg_end_addr;
   
  
  
  
  input    axi4s_dp_rdy_t       prefix_attach_ob_in;
  output   axi4s_dp_bus_t       prefix_attach_ob_out;


  
  
  
  input                          cceip_cfg;
  input   [`MODULE_ID_WIDTH-1:0] prefix_attach_module_id;

  
  
  
  output                         prefix_attach_int;
  
  
  
  logic [`CR_PREFIX_ATTACH_C_REGS_CCEIP_TLV_PARSE_ACTION_31_0_T_DECL] cceip_tlv_parse_action_0;
  logic [`CR_PREFIX_ATTACH_C_REGS_CCEIP_TLV_PARSE_ACTION_63_32_T_DECL] cceip_tlv_parse_action_1;
  logic [`CR_PREFIX_ATTACH_C_REGS_CDDIP_TLV_PARSE_ACTION_31_0_T_DECL] cddip_tlv_parse_action_0;
  logic [`CR_PREFIX_ATTACH_C_REGS_CDDIP_TLV_PARSE_ACTION_63_32_T_DECL] cddip_tlv_parse_action_1;
  logic [`LOG_VEC(`CR_PREFIX_PFD_ENTRIES)] pfd_mem_addr;
  logic                 pfd_mem_cs;             
  pfd_t                 pfd_mem_dout;           
  logic                 pfd_mem_yield;          
  logic [`LOG_VEC(`CR_PREFIX_PHD_ENTRIES)] phd_mem_addr;
  logic                 phd_mem_cs;             
  phd_t                 phd_mem_dout;           
  logic                 phd_mem_yield;          
  logic                 tlvp_error;             
  
  logic [31:0]          tlv_parse_action_0;
  logic [31:0]          tlv_parse_action_1;

  assign prefix_attach_int = tlvp_error; 
  
  
  always_comb begin
    if(cceip_cfg) begin
      tlv_parse_action_0 = cceip_tlv_parse_action_0;
      tlv_parse_action_1 = cceip_tlv_parse_action_1;
    end
    else begin
      tlv_parse_action_0 = cddip_tlv_parse_action_0;
      tlv_parse_action_1 = cddip_tlv_parse_action_1;
    end
  end

  cr_prefix_attach_core 
  #(.PREFIX_ATTACH_STUB (PREFIX_ATTACH_STUB))
  u_cr_prefix_attach_core
  (
   
   
   .prefix_attach_ib_out                (prefix_attach_ib_out),
   .prefix_attach_ob_out                (prefix_attach_ob_out),
   .pfd_mem_addr                        (pfd_mem_addr[`LOG_VEC(`CR_PREFIX_PFD_ENTRIES)]),
   .pfd_mem_cs                          (pfd_mem_cs),
   .phd_mem_addr                        (phd_mem_addr[`LOG_VEC(`CR_PREFIX_PHD_ENTRIES)]),
   .phd_mem_cs                          (phd_mem_cs),
   .tlvp_error                          (tlvp_error),
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .cceip_cfg                           (cceip_cfg),
   .prefix_attach_module_id             (prefix_attach_module_id[`MODULE_ID_WIDTH-1:0]),
   .tlv_parse_action_0                  (tlv_parse_action_0[31:0]),
   .tlv_parse_action_1                  (tlv_parse_action_1[31:0]),
   .prefix_attach_ib_in                 (prefix_attach_ib_in),
   .prefix_attach_ob_in                 (prefix_attach_ob_in),
   .pfd_mem_dout                        (pfd_mem_dout),
   .pfd_mem_yield                       (pfd_mem_yield),
   .phd_mem_dout                        (phd_mem_dout),
   .phd_mem_yield                       (phd_mem_yield));

  cr_prefix_attach_regfile
 
  u_cr_prefix_attach_regfile 
  (
   
   
   .rbus_ring_o                         (rbus_ring_o),
   .cceip_tlv_parse_action_0            (cceip_tlv_parse_action_0[`CR_PREFIX_ATTACH_C_REGS_CCEIP_TLV_PARSE_ACTION_31_0_T_DECL]),
   .cceip_tlv_parse_action_1            (cceip_tlv_parse_action_1[`CR_PREFIX_ATTACH_C_REGS_CCEIP_TLV_PARSE_ACTION_63_32_T_DECL]),
   .cddip_tlv_parse_action_0            (cddip_tlv_parse_action_0[`CR_PREFIX_ATTACH_C_REGS_CDDIP_TLV_PARSE_ACTION_31_0_T_DECL]),
   .cddip_tlv_parse_action_1            (cddip_tlv_parse_action_1[`CR_PREFIX_ATTACH_C_REGS_CDDIP_TLV_PARSE_ACTION_63_32_T_DECL]),
   .pfd_mem_dout                        (pfd_mem_dout),
   .pfd_mem_yield                       (pfd_mem_yield),
   .phd_mem_dout                        (phd_mem_dout),
   .phd_mem_yield                       (phd_mem_yield),
   .bimc_odat                           (bimc_odat),
   .bimc_osync                          (bimc_osync),
   
   .rst_n                               (rst_n),
   .clk                                 (clk),
   .rbus_ring_i                         (rbus_ring_i),
   .cfg_start_addr                      (cfg_start_addr[`N_RBUS_ADDR_BITS-1:0]),
   .cfg_end_addr                        (cfg_end_addr[`N_RBUS_ADDR_BITS-1:0]),
   .pfd_mem_addr                        (pfd_mem_addr[`LOG_VEC(`CR_PREFIX_PFD_ENTRIES)]),
   .pfd_mem_cs                          (pfd_mem_cs),
   .phd_mem_addr                        (phd_mem_addr[`LOG_VEC(`CR_PREFIX_PHD_ENTRIES)]),
   .phd_mem_cs                          (phd_mem_cs),
   .bimc_rst_n                          (bimc_rst_n),
   .bimc_idat                           (bimc_idat),
   .bimc_isync                          (bimc_isync));
  
endmodule











