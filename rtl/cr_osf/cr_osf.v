/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_osf.vh"

module cr_osf

  (
  
  bimc_odat, bimc_osync, osf_ib_out, osf_cg_ib_out, rbus_ring_o,
  osf_ob_out, osf_stat_events, osf_sup_cqe_exit, osf_int,
  eng_self_test_en,
  
  clk, rst_n, scan_en, scan_mode, scan_rst_n, ovstb, lvm, mlvm,
  bimc_rst_n, bimc_isync, bimc_idat, osf_ib_in, osf_cg_ib_in,
  ext_ib_out, rbus_ring_i, cfg_start_addr, cfg_end_addr, osf_ob_in,
  sup_osf_halt, osf_module_id
  );

`include "cr_structs.sv"
`include "ccx_std.vh"

  import cr_osfPKG::*;

  import cr_osf_regsPKG::*;

  
  
  
  input                                clk;
  input                                rst_n; 

  
  
  
  input                                scan_en;
  input                                scan_mode;
  input                                scan_rst_n;

  
  
  
  input                                ovstb;
  input                                lvm;
  input                                mlvm;

  
  
  
  input                                bimc_rst_n;
  input                                bimc_isync;
  input                                bimc_idat;
  output                               bimc_odat;
  output                               bimc_osync;

  
  
  
  input  axi4s_dp_bus_t                osf_ib_in;
  output axi4s_dp_rdy_t                osf_ib_out;
  
  
  
  
  input  axi4s_dp_bus_t                osf_cg_ib_in;
  output axi4s_dp_rdy_t                osf_cg_ib_out;
  
  
  
  
  
  
  input  axi4s_dp_rdy_t                ext_ib_out;  

  
  
  
  input  rbus_ring_t                   rbus_ring_i;
  output rbus_ring_t                   rbus_ring_o;
  
   input [`N_RBUS_ADDR_BITS-1:0] cfg_start_addr;
   input [`N_RBUS_ADDR_BITS-1:0] cfg_end_addr;
   
  
  
  
  input  axi4s_dp_rdy_t                osf_ob_in;
  output axi4s_dp_bus_t                osf_ob_out;

  
  
  
  output osf_stats_t                   osf_stat_events;

  
  
  
  output                               osf_sup_cqe_exit;
  output osf_int_t                     osf_int;
  input                                sup_osf_halt;

  
  
  
  output                               eng_self_test_en;
  
  
  
  input  [`MODULE_ID_WIDTH-1:0]        osf_module_id;

  
  
  data_fifo_debug_ctl_t data_fifo_debug_ctl_config;
  data_fifo_debug_stat_t data_fifo_debug_stat;  
  logic                 data_fifo_single_step_rd;
  debug_ctl_t           debug_ctl_config;       
  logic [3:0]           ob_bytes_cnt_amt;       
  logic                 ob_bytes_cnt_stb;       
  logic                 ob_frame_cnt_stb;       
  osf_data_fifo_fifo_status_0_t osf_data_fifo_fifo_status_0;
  osf_data_fifo_fifo_status_1_t osf_data_fifo_fifo_status_1;
  osf_data_fifo_ia_capability_t osf_data_fifo_ia_capability;
  osf_data_fifo_ia_config_t osf_data_fifo_ia_config;
  osf_data_fifo_t       osf_data_fifo_ia_rdata; 
  osf_data_fifo_ia_status_t osf_data_fifo_ia_status;
  osf_data_fifo_t       osf_data_fifo_ia_wdata; 
  osf_pdt_fifo_fifo_status_0_t osf_pdt_fifo_fifo_status_0;
  osf_pdt_fifo_fifo_status_1_t osf_pdt_fifo_fifo_status_1;
  osf_pdt_fifo_ia_capability_t osf_pdt_fifo_ia_capability;
  osf_pdt_fifo_ia_config_t osf_pdt_fifo_ia_config;
  osf_pdt_fifo_t        osf_pdt_fifo_ia_rdata;  
  osf_pdt_fifo_ia_status_t osf_pdt_fifo_ia_status;
  osf_pdt_fifo_t        osf_pdt_fifo_ia_wdata;  
  osf_tlv_parse_action_31_0_t osf_tlv_parse_action_0;
  osf_tlv_parse_action_63_32_t osf_tlv_parse_action_1;
  pdt_fifo_debug_ctl_t  pdt_fifo_debug_ctl_config;
  pdt_fifo_debug_stat_t pdt_fifo_debug_stat;    
  logic                 pdt_fifo_single_step_rd;
  logic [`CR_OSF_DECL]  reg_addr;               
  logic                 wr_stb;                 
  

  
  assign eng_self_test_en = debug_ctl_config.eng_self_test_en;

  cr_osf_core u_cr_osf_core
  (
   
   
   .bimc_odat                           (bimc_odat),
   .bimc_osync                          (bimc_osync),
   .osf_ib_out                          (osf_ib_out),
   .osf_cg_ib_out                       (osf_cg_ib_out),
   .osf_ob_out                          (osf_ob_out),
   .osf_stat_events                     (osf_stat_events),
   .osf_sup_cqe_exit                    (osf_sup_cqe_exit),
   .osf_int                             (osf_int),
   .data_fifo_debug_stat                (data_fifo_debug_stat),
   .osf_data_fifo_ia_rdata              (osf_data_fifo_ia_rdata),
   .osf_data_fifo_ia_status             (osf_data_fifo_ia_status),
   .osf_data_fifo_ia_capability         (osf_data_fifo_ia_capability),
   .osf_data_fifo_fifo_status_0         (osf_data_fifo_fifo_status_0),
   .osf_data_fifo_fifo_status_1         (osf_data_fifo_fifo_status_1),
   .pdt_fifo_debug_stat                 (pdt_fifo_debug_stat),
   .osf_pdt_fifo_ia_rdata               (osf_pdt_fifo_ia_rdata),
   .osf_pdt_fifo_ia_status              (osf_pdt_fifo_ia_status),
   .osf_pdt_fifo_ia_capability          (osf_pdt_fifo_ia_capability),
   .osf_pdt_fifo_fifo_status_0          (osf_pdt_fifo_fifo_status_0),
   .osf_pdt_fifo_fifo_status_1          (osf_pdt_fifo_fifo_status_1),
   .ob_bytes_cnt_stb                    (ob_bytes_cnt_stb),
   .ob_bytes_cnt_amt                    (ob_bytes_cnt_amt[3:0]),
   .ob_frame_cnt_stb                    (ob_frame_cnt_stb),
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .bimc_rst_n                          (bimc_rst_n),
   .bimc_isync                          (bimc_isync),
   .bimc_idat                           (bimc_idat),
   .osf_ib_in                           (osf_ib_in),
   .osf_cg_ib_in                        (osf_cg_ib_in),
   .ext_ib_out                          (ext_ib_out),
   .osf_ob_in                           (osf_ob_in),
   .sup_osf_halt                        (sup_osf_halt),
   .osf_data_fifo_ia_wdata              (osf_data_fifo_ia_wdata),
   .osf_data_fifo_ia_config             (osf_data_fifo_ia_config),
   .data_fifo_debug_ctl_config          (data_fifo_debug_ctl_config),
   .data_fifo_single_step_rd            (data_fifo_single_step_rd),
   .osf_pdt_fifo_ia_wdata               (osf_pdt_fifo_ia_wdata),
   .osf_pdt_fifo_ia_config              (osf_pdt_fifo_ia_config),
   .pdt_fifo_debug_ctl_config           (pdt_fifo_debug_ctl_config),
   .pdt_fifo_single_step_rd             (pdt_fifo_single_step_rd),
   .debug_ctl_config                    (debug_ctl_config),
   .osf_tlv_parse_action_0              (osf_tlv_parse_action_0),
   .osf_tlv_parse_action_1              (osf_tlv_parse_action_1),
   .reg_addr                            (reg_addr[`CR_OSF_DECL]),
   .wr_stb                              (wr_stb),
   .osf_module_id                       (osf_module_id[`MODULE_ID_WIDTH-1:0]));




  cr_osf_regfile

  u_cr_osf_regfile 
  (
   
   
   .rbus_ring_o                         (rbus_ring_o),
   .osf_data_fifo_ia_wdata              (osf_data_fifo_ia_wdata),
   .osf_data_fifo_ia_config             (osf_data_fifo_ia_config),
   .osf_pdt_fifo_ia_wdata               (osf_pdt_fifo_ia_wdata),
   .osf_pdt_fifo_ia_config              (osf_pdt_fifo_ia_config),
   .reg_addr                            (reg_addr[`CR_OSF_DECL]),
   .wr_stb                              (wr_stb),
   .data_fifo_single_step_rd            (data_fifo_single_step_rd),
   .pdt_fifo_single_step_rd             (pdt_fifo_single_step_rd),
   .data_fifo_debug_ctl_config          (data_fifo_debug_ctl_config),
   .pdt_fifo_debug_ctl_config           (pdt_fifo_debug_ctl_config),
   .osf_tlv_parse_action_0              (osf_tlv_parse_action_0),
   .osf_tlv_parse_action_1              (osf_tlv_parse_action_1),
   .debug_ctl_config                    (debug_ctl_config),
   
   .cfg_start_addr                      (cfg_start_addr[`N_RBUS_ADDR_BITS-1:0]),
   .cfg_end_addr                        (cfg_end_addr[`N_RBUS_ADDR_BITS-1:0]),
   .rst_n                               (rst_n),
   .clk                                 (clk),
   .rbus_ring_i                         (rbus_ring_i),
   .osf_data_fifo_ia_rdata              (osf_data_fifo_ia_rdata),
   .osf_data_fifo_ia_status             (osf_data_fifo_ia_status),
   .osf_data_fifo_ia_capability         (osf_data_fifo_ia_capability),
   .osf_data_fifo_fifo_status_0         (osf_data_fifo_fifo_status_0),
   .osf_data_fifo_fifo_status_1         (osf_data_fifo_fifo_status_1),
   .osf_pdt_fifo_ia_rdata               (osf_pdt_fifo_ia_rdata),
   .osf_pdt_fifo_ia_status              (osf_pdt_fifo_ia_status),
   .osf_pdt_fifo_ia_capability          (osf_pdt_fifo_ia_capability),
   .osf_pdt_fifo_fifo_status_0          (osf_pdt_fifo_fifo_status_0),
   .osf_pdt_fifo_fifo_status_1          (osf_pdt_fifo_fifo_status_1),
   .data_fifo_debug_stat                (data_fifo_debug_stat),
   .pdt_fifo_debug_stat                 (pdt_fifo_debug_stat),
   .ob_bytes_cnt_stb                    (ob_bytes_cnt_stb),
   .ob_bytes_cnt_amt                    (ob_bytes_cnt_amt[3:0]),
   .ob_frame_cnt_stb                    (ob_frame_cnt_stb));
  
endmodule











