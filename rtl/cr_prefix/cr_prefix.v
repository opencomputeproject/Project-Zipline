/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/






















`include "cr_prefix.vh"
`include "crPKG.svp"

module cr_prefix
  #(parameter 
    PREFIX_STUB=0)     
   (
  
  prefix_ib_out, rbus_ring_o, prefix_ob_out, prefix_stat_events,
  prefix_int,
  
  clk, rst_n, scan_en, scan_mode, scan_rst_n, ovstb, lvm, mlvm,
  prefix_ib_in, rbus_ring_i, cfg_start_addr, cfg_end_addr,
  prefix_ob_in, prefix_module_id
  );

`include "cr_structs.sv"

  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;
  
  
  
  input                            clk;
  input                            rst_n; 

  
  
  
  input                            scan_en;
  input                            scan_mode;
  input                            scan_rst_n;

  
  
  
  input                            ovstb;
  input                            lvm;
  input                            mlvm;

  
  
  
  input  axi4s_dp_bus_t            prefix_ib_in;
  output axi4s_dp_rdy_t            prefix_ib_out;
  
  
  
  
  input  rbus_ring_t               rbus_ring_i;
  output rbus_ring_t               rbus_ring_o;

  input  [`N_RBUS_ADDR_BITS-1:0]   cfg_start_addr;
  input  [`N_RBUS_ADDR_BITS-1:0]   cfg_end_addr;
   
  
  
  
  input  axi4s_dp_rdy_t            prefix_ob_in;
  output axi4s_dp_bus_t            prefix_ob_out;

  
  
  
  output [`PREFIX_STATS_WIDTH-1:0] prefix_stat_events;

  
  
  
  input  [`MODULE_ID_WIDTH-1:0]    prefix_module_id;

  
  
  
  output logic [2:0]               prefix_int;
  
  `ifndef CR_PREFIX_BBOX
  
  feature_t                        fe_config [0:`N_PREFIX_FEATURES-1];
  feature_ctr_t                    feature_ctr [0:`N_PREFIX_FEATURES-1];
  rec_ct_t                         rec_ct_dout;            
  rec_inst_t                       rec_im_dout;            
  psr_t                            rec_psr [0:426];
  logic                            prefix_rst_n;
  
  
  
  logic                 bimc_interrupt;         
  logic                 bimc_rst_n;             
  logic                 pt_ib_ro_uncorrectable_ecc_error;
  logic [`LOG_VEC(`N_PREFIX_CT_ENTRIES)] rec_ct_addr;
  logic                 rec_ct_cs;              
  logic                 rec_ct_yield;           
  prefix_debug_status_t rec_debug_status;       
  logic [`LOG_VEC(`N_PREFIX_IM_ENTRIES)] rec_im_addr;
  logic                 rec_im_cs;              
  logic                 rec_im_yield;           
  logic [`LOG_VEC(`N_PREFIX_SAT_ENTRIES)] rec_sat_addr;
  logic                 rec_sat_cs;             
  logic [895:0]         rec_sat_dout;           
  logic                 rec_sat_yield;          
  logic                 recct_uncorrectable_ecc_error;
  logic                 recim_uncorrectable_ecc_error;
  logic                 recsat_uncorrectable_ecc_error;
  prefix_breakpoint_addr_t regs_breakpoint_addr;
  logic                 regs_breakpoint_cont;   
  logic                 regs_breakpoint_step;   
  logic                 regs_ld_breakpoint;     
  prefix_debug_control_t regs_rec_debug_control;
  prefix_rec_us_ctrl_t  regs_rec_us_ctrl;       
  logic [`CR_PREFIX_C_REGS_TLV_PARSE_ACTION_31_0_T_DECL] tlv_parse_action_0;
  logic [`CR_PREFIX_C_REGS_TLV_PARSE_ACTION_63_32_T_DECL] tlv_parse_action_1;
  logic                 tlvp_bimc_idat;         
  logic                 tlvp_bimc_isync;        
  logic                 tlvp_bimc_odat;         
  logic                 tlvp_bimc_osync;        
  logic                 tlvp_error;             
  logic                 tlvp_ob_ro_uncorrectable_ecc_error;
  logic                 usr_ib_ro_uncorrectable_ecc_error;
  logic                 usr_ob_ro_uncorrectable_ecc_error;
  

  assign prefix_int[0] = tlvp_error;
  assign prefix_int[1] = bimc_interrupt;
  
    always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      prefix_int[2] <= 1'b0;
    end
    else begin
      prefix_int[2] <= tlvp_ob_ro_uncorrectable_ecc_error |
                      usr_ib_ro_uncorrectable_ecc_error |
                      usr_ob_ro_uncorrectable_ecc_error |
                      recsat_uncorrectable_ecc_error |
                      recct_uncorrectable_ecc_error |
                      recim_uncorrectable_ecc_error;
    end
  end 
  
  
  
  
  cr_rst_sync u_cr_rst_sync
    (
     
     .rst_n                             (prefix_rst_n),          
     
     .clk                               (clk),                   
     .async_rst_n                       (rst_n),                 
     .bypass_reset                      (scan_mode),             
     .test_rst_n                        (scan_rst_n));           


  
  
  
  
  cr_prefix_core 
  #(.PREFIX_STUB (PREFIX_STUB))
  u_cr_prefix_core
  (
   
   
   .prefix_ib_out                       (prefix_ib_out),
   .prefix_ob_out                       (prefix_ob_out),         
   .feature_ctr                         (feature_ctr),
   .rec_im_addr                         (rec_im_addr[`LOG_VEC(`N_PREFIX_IM_ENTRIES)]),
   .rec_im_cs                           (rec_im_cs),
   .rec_sat_addr                        (rec_sat_addr[`LOG_VEC(`N_PREFIX_SAT_ENTRIES)]),
   .rec_sat_cs                          (rec_sat_cs),
   .rec_ct_addr                         (rec_ct_addr[`LOG_VEC(`N_PREFIX_CT_ENTRIES)]),
   .rec_ct_cs                           (rec_ct_cs),
   .rec_debug_status                    (rec_debug_status),
   .rec_psr                             (rec_psr),
   .tlvp_bimc_odat                      (tlvp_bimc_odat),
   .tlvp_bimc_osync                     (tlvp_bimc_osync),
   .pt_ib_ro_uncorrectable_ecc_error    (pt_ib_ro_uncorrectable_ecc_error),
   .usr_ib_ro_uncorrectable_ecc_error   (usr_ib_ro_uncorrectable_ecc_error),
   .tlvp_ob_ro_uncorrectable_ecc_error  (tlvp_ob_ro_uncorrectable_ecc_error),
   .usr_ob_ro_uncorrectable_ecc_error   (usr_ob_ro_uncorrectable_ecc_error),
   .prefix_stat_events                  (prefix_stat_events[`PREFIX_STATS_WIDTH-1:0]),
   .tlvp_error                          (tlvp_error),
   
   .clk                                 (clk),
   .rst_n                               (prefix_rst_n),          
   .prefix_ib_in                        (prefix_ib_in),
   .prefix_ob_in                        (prefix_ob_in),          
   .rec_im_dout                         (rec_im_dout),
   .rec_im_yield                        (rec_im_yield),
   .rec_sat_dout                        (rec_sat_dout[895:0]),
   .rec_ct_dout                         (rec_ct_dout),
   .regs_rec_debug_control              (regs_rec_debug_control),
   .regs_breakpoint_addr                (regs_breakpoint_addr),
   .regs_ld_breakpoint                  (regs_ld_breakpoint),
   .regs_breakpoint_cont                (regs_breakpoint_cont),
   .regs_breakpoint_step                (regs_breakpoint_step),
   .prefix_module_id                    (prefix_module_id[`MODULE_ID_WIDTH-1:0]),
   .fe_config                           (fe_config),
   .tlv_parse_action_1                  (tlv_parse_action_1[`CR_PREFIX_C_REGS_TLV_PARSE_ACTION_63_32_T_DECL]),
   .tlv_parse_action_0                  (tlv_parse_action_0[`CR_PREFIX_C_REGS_TLV_PARSE_ACTION_31_0_T_DECL]),
   .regs_rec_us_ctrl                    (regs_rec_us_ctrl),
   .tlvp_bimc_idat                      (tlvp_bimc_idat),
   .tlvp_bimc_isync                     (tlvp_bimc_isync),
   .bimc_rst_n                          (bimc_rst_n));

 
  
  
  
  
  cr_prefix_regfile
 
  u_cr_prefix_regfile 
  (
   
   
   .rbus_ring_o                         (rbus_ring_o),
   .regs_rec_debug_control              (regs_rec_debug_control),
   .regs_breakpoint_addr                (regs_breakpoint_addr),
   .regs_ld_breakpoint                  (regs_ld_breakpoint),
   .regs_breakpoint_cont                (regs_breakpoint_cont),
   .regs_breakpoint_step                (regs_breakpoint_step),
   .rec_im_dout                         (rec_im_dout),
   .rec_im_yield                        (rec_im_yield),
   .rec_sat_dout                        (rec_sat_dout[895:0]),
   .rec_sat_yield                       (rec_sat_yield),
   .rec_ct_dout                         (rec_ct_dout),
   .rec_ct_yield                        (rec_ct_yield),
   .fe_config                           (fe_config),
   .tlv_parse_action_1                  (tlv_parse_action_1[`CR_PREFIX_C_REGS_TLV_PARSE_ACTION_63_32_T_DECL]),
   .tlv_parse_action_0                  (tlv_parse_action_0[`CR_PREFIX_C_REGS_TLV_PARSE_ACTION_31_0_T_DECL]),
   .regs_rec_us_ctrl                    (regs_rec_us_ctrl),
   .bimc_rst_n                          (bimc_rst_n),
   .tlvp_bimc_idat                      (tlvp_bimc_idat),
   .tlvp_bimc_isync                     (tlvp_bimc_isync),
   .bimc_interrupt                      (bimc_interrupt),
   .recsat_uncorrectable_ecc_error      (recsat_uncorrectable_ecc_error),
   .recct_uncorrectable_ecc_error       (recct_uncorrectable_ecc_error),
   .recim_uncorrectable_ecc_error       (recim_uncorrectable_ecc_error),
   
   .rst_n                               (prefix_rst_n),          
   .clk                                 (clk),
   .cfg_start_addr                      (cfg_start_addr[`N_RBUS_ADDR_BITS-1:0]),
   .cfg_end_addr                        (cfg_end_addr[`N_RBUS_ADDR_BITS-1:0]),
   .rbus_ring_i                         (rbus_ring_i),
   .feature_ctr                         (feature_ctr),
   .rec_debug_status                    (rec_debug_status),
   .rec_im_addr                         (rec_im_addr[`LOG_VEC(`N_PREFIX_IM_ENTRIES)]),
   .rec_im_cs                           (rec_im_cs),
   .rec_sat_addr                        (rec_sat_addr[`LOG_VEC(`N_PREFIX_SAT_ENTRIES)]),
   .rec_sat_cs                          (rec_sat_cs),
   .rec_ct_addr                         (rec_ct_addr[`LOG_VEC(`N_PREFIX_CT_ENTRIES)]),
   .rec_ct_cs                           (rec_ct_cs),
   .rec_psr                             (rec_psr),
   .tlvp_bimc_odat                      (tlvp_bimc_odat),
   .tlvp_bimc_osync                     (tlvp_bimc_osync));
  `endif  
endmodule














