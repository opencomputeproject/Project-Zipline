/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_isf.vh"

module cr_isf

  (
  
  bimc_odat, bimc_osync, isf_ib_out, rbus_ring_o, isf_ob_out,
  isf_stat_events, isf_int, isf_sup_cqe_exit, isf_sup_cqe_rx,
  isf_sup_rqe_rx,
  
  clk, rst_n, scan_en, scan_mode, scan_rst_n, ovstb, lvm, mlvm,
  bimc_rst_n, bimc_isync, bimc_idat, isf_ib_in, rbus_ring_i,
  cfg_start_addr, cfg_end_addr, isf_ob_in, dbg_cmd_disable,
  xp9_disable, isf_module_id, cceip_cfg
  );

`include "cr_structs.sv"
`include "ccx_std.vh"

   import cr_isfPKG::*;

  import cr_isf_regsPKG::*;
  
  
  
  input                                 clk;
  input                                 rst_n; 

  
  
  
  input                                 scan_en;
  input                                 scan_mode;
  input                                 scan_rst_n;

  
  
  
  input                                 ovstb;
  input                                 lvm;
  input                                 mlvm;

  
  
  
  input                                 bimc_rst_n;
  input                                 bimc_isync;
  input                                 bimc_idat;
  output                                bimc_odat;
  output                                bimc_osync;

  
  
  
  input  axi4s_dp_bus_t                 isf_ib_in;
  output axi4s_dp_rdy_t                 isf_ib_out;
  
  
  
  
  input  rbus_ring_t                    rbus_ring_i;
  output rbus_ring_t                    rbus_ring_o;
   
  input [`N_RBUS_ADDR_BITS-1:0]         cfg_start_addr;
  input [`N_RBUS_ADDR_BITS-1:0]         cfg_end_addr;
   
  
  
  
  input  axi4s_dp_rdy_t                 isf_ob_in;
  output axi4s_dp_bus_t                 isf_ob_out;

  
  
  
  output isf_stats_t                    isf_stat_events;

  
  
  
  output isf_int_t                      isf_int;
  output                                isf_sup_cqe_exit;
  output                                isf_sup_cqe_rx;
  output                                isf_sup_rqe_rx;

  
  
  
  input                                 dbg_cmd_disable;
  input                                 xp9_disable;

  
  
  
  input  [`MODULE_ID_WIDTH-1:0]         isf_module_id;
  input                                 cceip_cfg;

  
  
  aux_cmd_ev_mask_val_0_comp_t aux_cmd_ev_mask_val_0_comp_config;
  aux_cmd_ev_mask_val_0_crypto_t aux_cmd_ev_mask_val_0_crypto_config;
  aux_cmd_ev_mask_val_1_comp_t aux_cmd_ev_mask_val_1_comp_config;
  aux_cmd_ev_mask_val_1_crypto_t aux_cmd_ev_mask_val_1_crypto_config;
  aux_cmd_ev_mask_val_2_comp_t aux_cmd_ev_mask_val_2_comp_config;
  aux_cmd_ev_mask_val_2_crypto_t aux_cmd_ev_mask_val_2_crypto_config;
  aux_cmd_ev_mask_val_3_comp_t aux_cmd_ev_mask_val_3_comp_config;
  aux_cmd_ev_mask_val_3_crypto_t aux_cmd_ev_mask_val_3_crypto_config;
  aux_cmd_ev_match_val_0_comp_t aux_cmd_ev_match_val_0_comp_config;
  aux_cmd_ev_match_val_0_crypto_t aux_cmd_ev_match_val_0_crypto_config;
  aux_cmd_ev_match_val_1_comp_t aux_cmd_ev_match_val_1_comp_config;
  aux_cmd_ev_match_val_1_crypto_t aux_cmd_ev_match_val_1_crypto_config;
  aux_cmd_ev_match_val_2_comp_t aux_cmd_ev_match_val_2_comp_config;
  aux_cmd_ev_match_val_2_crypto_t aux_cmd_ev_match_val_2_crypto_config;
  aux_cmd_ev_match_val_3_comp_t aux_cmd_ev_match_val_3_comp_config;
  aux_cmd_ev_match_val_3_crypto_t aux_cmd_ev_match_val_3_crypto_config;
  ctl_t                 ctl_config;             
  debug_ctl_t           debug_ctl_config;       
  debug_ss_cap_hi_t     debug_ss_cap_hi;        
  debug_ss_cap_lo_t     debug_ss_cap_lo;        
  debug_ss_cap_sb_t     debug_ss_cap_sb;        
  debug_stat_t          debug_stat;             
  debug_trig_cap_hi_t   debug_trig_cap_hi;      
  debug_trig_cap_lo_t   debug_trig_cap_lo;      
  debug_trig_mask_hi_t  debug_trig_mask_hi_config;
  debug_trig_mask_lo_t  debug_trig_mask_lo_config;
  debug_trig_match_hi_t debug_trig_match_hi_config;
  debug_trig_match_lo_t debug_trig_match_lo_config;
  debug_trig_tlv_t      debug_trig_tlv_config;  
  logic [3:0]           ib_bytes_cnt_amt;       
  logic                 ib_bytes_cnt_stb;       
  isf_fifo_fifo_status_0_t isf_fifo_fifo_status_0;
  isf_fifo_fifo_status_1_t isf_fifo_fifo_status_1;
  isf_fifo_ia_capability_t isf_fifo_ia_capability;
  isf_fifo_ia_config_t  isf_fifo_ia_config;     
  isf_fifo_t            isf_fifo_ia_rdata;      
  isf_fifo_ia_status_t  isf_fifo_ia_status;     
  isf_fifo_t            isf_fifo_ia_wdata;      
  isf_tlv_parse_action_31_0_t isf_tlv_parse_action_0;
  isf_tlv_parse_action_63_32_t isf_tlv_parse_action_1;
  logic [`CR_ISF_DECL]  reg_addr;               
  system_stall_limit_t  system_stall_limit_config;
  trace_ctl_en_t        trace_ctl_en_config;    
  trace_ctl_limits_t    trace_ctl_limits_config;
  logic                 wr_stb;                 
  

  
  logic                 single_step_rd;

  cr_isf_core u_cr_isf_core
  (
   
   
   .bimc_odat                           (bimc_odat),
   .bimc_osync                          (bimc_osync),
   .isf_ib_out                          (isf_ib_out),
   .isf_ob_out                          (isf_ob_out),
   .isf_int                             (isf_int),
   .isf_sup_cqe_exit                    (isf_sup_cqe_exit),
   .isf_sup_cqe_rx                      (isf_sup_cqe_rx),
   .isf_sup_rqe_rx                      (isf_sup_rqe_rx),
   .isf_fifo_ia_rdata                   (isf_fifo_ia_rdata),
   .isf_fifo_ia_status                  (isf_fifo_ia_status),
   .isf_fifo_ia_capability              (isf_fifo_ia_capability),
   .isf_fifo_fifo_status_0              (isf_fifo_fifo_status_0),
   .isf_fifo_fifo_status_1              (isf_fifo_fifo_status_1),
   .ib_bytes_cnt_stb                    (ib_bytes_cnt_stb),
   .ib_bytes_cnt_amt                    (ib_bytes_cnt_amt[3:0]),
   .debug_stat                          (debug_stat),
   .debug_trig_cap_hi                   (debug_trig_cap_hi),
   .debug_trig_cap_lo                   (debug_trig_cap_lo),
   .debug_ss_cap_sb                     (debug_ss_cap_sb),
   .debug_ss_cap_lo                     (debug_ss_cap_lo),
   .debug_ss_cap_hi                     (debug_ss_cap_hi),
   .isf_stat_events                     (isf_stat_events),
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .bimc_rst_n                          (bimc_rst_n),
   .bimc_isync                          (bimc_isync),
   .bimc_idat                           (bimc_idat),
   .isf_ib_in                           (isf_ib_in),
   .isf_ob_in                           (isf_ob_in),
   .isf_fifo_ia_wdata                   (isf_fifo_ia_wdata),
   .isf_fifo_ia_config                  (isf_fifo_ia_config),
   .debug_ctl_config                    (debug_ctl_config),
   .ctl_config                          (ctl_config),
   .reg_addr                            (reg_addr[`CR_ISF_DECL]),
   .wr_stb                              (wr_stb),
   .single_step_rd                      (single_step_rd),
   .isf_tlv_parse_action_0              (isf_tlv_parse_action_0),
   .isf_tlv_parse_action_1              (isf_tlv_parse_action_1),
   .system_stall_limit_config           (system_stall_limit_config),
   .trace_ctl_en_config                 (trace_ctl_en_config),
   .trace_ctl_limits_config             (trace_ctl_limits_config),
   .aux_cmd_ev_mask_val_0_comp_config   (aux_cmd_ev_mask_val_0_comp_config),
   .aux_cmd_ev_mask_val_0_crypto_config (aux_cmd_ev_mask_val_0_crypto_config),
   .aux_cmd_ev_mask_val_1_comp_config   (aux_cmd_ev_mask_val_1_comp_config),
   .aux_cmd_ev_mask_val_1_crypto_config (aux_cmd_ev_mask_val_1_crypto_config),
   .aux_cmd_ev_mask_val_2_comp_config   (aux_cmd_ev_mask_val_2_comp_config),
   .aux_cmd_ev_mask_val_2_crypto_config (aux_cmd_ev_mask_val_2_crypto_config),
   .aux_cmd_ev_mask_val_3_comp_config   (aux_cmd_ev_mask_val_3_comp_config),
   .aux_cmd_ev_mask_val_3_crypto_config (aux_cmd_ev_mask_val_3_crypto_config),
   .aux_cmd_ev_match_val_0_comp_config  (aux_cmd_ev_match_val_0_comp_config),
   .aux_cmd_ev_match_val_0_crypto_config(aux_cmd_ev_match_val_0_crypto_config),
   .aux_cmd_ev_match_val_1_comp_config  (aux_cmd_ev_match_val_1_comp_config),
   .aux_cmd_ev_match_val_1_crypto_config(aux_cmd_ev_match_val_1_crypto_config),
   .aux_cmd_ev_match_val_2_comp_config  (aux_cmd_ev_match_val_2_comp_config),
   .aux_cmd_ev_match_val_2_crypto_config(aux_cmd_ev_match_val_2_crypto_config),
   .aux_cmd_ev_match_val_3_comp_config  (aux_cmd_ev_match_val_3_comp_config),
   .aux_cmd_ev_match_val_3_crypto_config(aux_cmd_ev_match_val_3_crypto_config),
   .debug_trig_mask_hi_config           (debug_trig_mask_hi_config),
   .debug_trig_mask_lo_config           (debug_trig_mask_lo_config),
   .debug_trig_match_hi_config          (debug_trig_match_hi_config),
   .debug_trig_match_lo_config          (debug_trig_match_lo_config),
   .debug_trig_tlv_config               (debug_trig_tlv_config),
   .dbg_cmd_disable                     (dbg_cmd_disable),
   .xp9_disable                         (xp9_disable),
   .isf_module_id                       (isf_module_id[`MODULE_ID_WIDTH-1:0]),
   .cceip_cfg                           (cceip_cfg));



    cr_isf_regfile u_cr_isf_regfile 
  (
   
   
   .rbus_ring_o                         (rbus_ring_o),
   .isf_fifo_ia_wdata                   (isf_fifo_ia_wdata),
   .isf_fifo_ia_config                  (isf_fifo_ia_config),
   .reg_addr                            (reg_addr[`CR_ISF_DECL]),
   .wr_stb                              (wr_stb),
   .single_step_rd                      (single_step_rd),
   .isf_tlv_parse_action_0              (isf_tlv_parse_action_0),
   .isf_tlv_parse_action_1              (isf_tlv_parse_action_1),
   .debug_ctl_config                    (debug_ctl_config),
   .trace_ctl_en_config                 (trace_ctl_en_config),
   .trace_ctl_limits_config             (trace_ctl_limits_config),
   .ctl_config                          (ctl_config),
   .system_stall_limit_config           (system_stall_limit_config),
   .aux_cmd_ev_mask_val_0_comp_config   (aux_cmd_ev_mask_val_0_comp_config),
   .aux_cmd_ev_mask_val_0_crypto_config (aux_cmd_ev_mask_val_0_crypto_config),
   .aux_cmd_ev_mask_val_1_comp_config   (aux_cmd_ev_mask_val_1_comp_config),
   .aux_cmd_ev_mask_val_1_crypto_config (aux_cmd_ev_mask_val_1_crypto_config),
   .aux_cmd_ev_mask_val_2_comp_config   (aux_cmd_ev_mask_val_2_comp_config),
   .aux_cmd_ev_mask_val_2_crypto_config (aux_cmd_ev_mask_val_2_crypto_config),
   .aux_cmd_ev_mask_val_3_comp_config   (aux_cmd_ev_mask_val_3_comp_config),
   .aux_cmd_ev_mask_val_3_crypto_config (aux_cmd_ev_mask_val_3_crypto_config),
   .aux_cmd_ev_match_val_0_comp_config  (aux_cmd_ev_match_val_0_comp_config),
   .aux_cmd_ev_match_val_0_crypto_config(aux_cmd_ev_match_val_0_crypto_config),
   .aux_cmd_ev_match_val_1_comp_config  (aux_cmd_ev_match_val_1_comp_config),
   .aux_cmd_ev_match_val_1_crypto_config(aux_cmd_ev_match_val_1_crypto_config),
   .aux_cmd_ev_match_val_2_comp_config  (aux_cmd_ev_match_val_2_comp_config),
   .aux_cmd_ev_match_val_2_crypto_config(aux_cmd_ev_match_val_2_crypto_config),
   .aux_cmd_ev_match_val_3_comp_config  (aux_cmd_ev_match_val_3_comp_config),
   .aux_cmd_ev_match_val_3_crypto_config(aux_cmd_ev_match_val_3_crypto_config),
   .debug_trig_mask_hi_config           (debug_trig_mask_hi_config),
   .debug_trig_mask_lo_config           (debug_trig_mask_lo_config),
   .debug_trig_match_hi_config          (debug_trig_match_hi_config),
   .debug_trig_match_lo_config          (debug_trig_match_lo_config),
   .debug_trig_tlv_config               (debug_trig_tlv_config),
   
   .rst_n                               (rst_n),
   .clk                                 (clk),
   .rbus_ring_i                         (rbus_ring_i),
   .cfg_start_addr                      (cfg_start_addr[`N_RBUS_ADDR_BITS-1:0]),
   .cfg_end_addr                        (cfg_end_addr[`N_RBUS_ADDR_BITS-1:0]),
   .isf_fifo_ia_rdata                   (isf_fifo_ia_rdata),
   .isf_fifo_ia_status                  (isf_fifo_ia_status),
   .isf_fifo_ia_capability              (isf_fifo_ia_capability),
   .isf_fifo_fifo_status_0              (isf_fifo_fifo_status_0),
   .isf_fifo_fifo_status_1              (isf_fifo_fifo_status_1),
   .debug_stat                          (debug_stat),
   .debug_trig_cap_hi                   (debug_trig_cap_hi),
   .debug_trig_cap_lo                   (debug_trig_cap_lo),
   .debug_ss_cap_sb                     (debug_ss_cap_sb),
   .debug_ss_cap_lo                     (debug_ss_cap_lo),
   .debug_ss_cap_hi                     (debug_ss_cap_hi),
   .ib_bytes_cnt_stb                    (ib_bytes_cnt_stb),
   .ib_bytes_cnt_amt                    (ib_bytes_cnt_amt[3:0]));
  
endmodule











