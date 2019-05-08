/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/















module cr_isf_core 
(
  
  bimc_odat, bimc_osync, isf_ib_out, isf_ob_out, isf_int,
  isf_sup_cqe_exit, isf_sup_cqe_rx, isf_sup_rqe_rx, isf_fifo_ia_rdata,
  isf_fifo_ia_status, isf_fifo_ia_capability, isf_fifo_fifo_status_0,
  isf_fifo_fifo_status_1, ib_bytes_cnt_stb, ib_bytes_cnt_amt,
  debug_stat, debug_trig_cap_hi, debug_trig_cap_lo, debug_ss_cap_sb,
  debug_ss_cap_lo, debug_ss_cap_hi, isf_stat_events,
  
  clk, rst_n, ovstb, lvm, mlvm, bimc_rst_n, bimc_isync, bimc_idat,
  isf_ib_in, isf_ob_in, isf_fifo_ia_wdata, isf_fifo_ia_config,
  debug_ctl_config, ctl_config, reg_addr, wr_stb, single_step_rd,
  isf_tlv_parse_action_0, isf_tlv_parse_action_1,
  system_stall_limit_config, trace_ctl_en_config,
  trace_ctl_limits_config, aux_cmd_ev_mask_val_0_comp_config,
  aux_cmd_ev_mask_val_0_crypto_config,
  aux_cmd_ev_mask_val_1_comp_config,
  aux_cmd_ev_mask_val_1_crypto_config,
  aux_cmd_ev_mask_val_2_comp_config,
  aux_cmd_ev_mask_val_2_crypto_config,
  aux_cmd_ev_mask_val_3_comp_config,
  aux_cmd_ev_mask_val_3_crypto_config,
  aux_cmd_ev_match_val_0_comp_config,
  aux_cmd_ev_match_val_0_crypto_config,
  aux_cmd_ev_match_val_1_comp_config,
  aux_cmd_ev_match_val_1_crypto_config,
  aux_cmd_ev_match_val_2_comp_config,
  aux_cmd_ev_match_val_2_crypto_config,
  aux_cmd_ev_match_val_3_comp_config,
  aux_cmd_ev_match_val_3_crypto_config, debug_trig_mask_hi_config,
  debug_trig_mask_lo_config, debug_trig_match_hi_config,
  debug_trig_match_lo_config, debug_trig_tlv_config, dbg_cmd_disable,
  xp9_disable, isf_module_id, cceip_cfg
  );
  
`include "cr_structs.sv"
  
  import cr_isfPKG::*;
  
  import cr_isf_regsPKG::*;

  
  
  
  input                                   clk;
  input                                   rst_n; 
  
  
  
  
  input                                   ovstb;
  input                                   lvm;
  input                                   mlvm;

  
  
  
  input                                   bimc_rst_n;
  input                                   bimc_isync;
  input                                   bimc_idat;
  output                                  bimc_odat;
  output                                  bimc_osync;
  
  
  
  input  axi4s_dp_bus_t                   isf_ib_in;
  output axi4s_dp_rdy_t                   isf_ib_out;

  
  
  
  input  axi4s_dp_rdy_t                   isf_ob_in;
  output axi4s_dp_bus_t                   isf_ob_out;

  
  
  
  output isf_int_t                        isf_int;
  output                                  isf_sup_cqe_exit;
  output                                  isf_sup_cqe_rx;
  output                                  isf_sup_rqe_rx;

  
  
  
  output isf_fifo_t                       isf_fifo_ia_rdata;
  output isf_fifo_ia_status_t             isf_fifo_ia_status;
  output isf_fifo_ia_capability_t         isf_fifo_ia_capability;
  output isf_fifo_fifo_status_0_t         isf_fifo_fifo_status_0;
  output isf_fifo_fifo_status_1_t         isf_fifo_fifo_status_1;
  output                                  ib_bytes_cnt_stb;
  output [3:0]                            ib_bytes_cnt_amt;
  output debug_stat_t                     debug_stat;
  output debug_trig_cap_hi_t              debug_trig_cap_hi;
  output debug_trig_cap_lo_t              debug_trig_cap_lo;
  output debug_ss_cap_sb_t                debug_ss_cap_sb;  
  output debug_ss_cap_lo_t                debug_ss_cap_lo;  
  output debug_ss_cap_hi_t                debug_ss_cap_hi;  

  input  isf_fifo_t                       isf_fifo_ia_wdata;
  input  isf_fifo_ia_config_t             isf_fifo_ia_config;
  input  debug_ctl_t                      debug_ctl_config;
  input  ctl_t                            ctl_config;
  input  [`CR_ISF_DECL]                   reg_addr;
  input                                   wr_stb;
  input                                   single_step_rd;
  input  isf_tlv_parse_action_31_0_t      isf_tlv_parse_action_0;
  input  isf_tlv_parse_action_63_32_t     isf_tlv_parse_action_1;
  input  system_stall_limit_t             system_stall_limit_config;
  input  trace_ctl_en_t                   trace_ctl_en_config;
  input  trace_ctl_limits_t               trace_ctl_limits_config; 
  input  aux_cmd_ev_mask_val_0_comp_t     aux_cmd_ev_mask_val_0_comp_config;
  input  aux_cmd_ev_mask_val_0_crypto_t   aux_cmd_ev_mask_val_0_crypto_config;
  input  aux_cmd_ev_mask_val_1_comp_t     aux_cmd_ev_mask_val_1_comp_config;
  input  aux_cmd_ev_mask_val_1_crypto_t   aux_cmd_ev_mask_val_1_crypto_config;
  input  aux_cmd_ev_mask_val_2_comp_t     aux_cmd_ev_mask_val_2_comp_config;
  input  aux_cmd_ev_mask_val_2_crypto_t   aux_cmd_ev_mask_val_2_crypto_config;
  input  aux_cmd_ev_mask_val_3_comp_t     aux_cmd_ev_mask_val_3_comp_config;
  input  aux_cmd_ev_mask_val_3_crypto_t   aux_cmd_ev_mask_val_3_crypto_config;
  input  aux_cmd_ev_match_val_0_comp_t    aux_cmd_ev_match_val_0_comp_config;
  input  aux_cmd_ev_match_val_0_crypto_t  aux_cmd_ev_match_val_0_crypto_config;
  input  aux_cmd_ev_match_val_1_comp_t    aux_cmd_ev_match_val_1_comp_config;
  input  aux_cmd_ev_match_val_1_crypto_t  aux_cmd_ev_match_val_1_crypto_config;
  input  aux_cmd_ev_match_val_2_comp_t    aux_cmd_ev_match_val_2_comp_config;
  input  aux_cmd_ev_match_val_2_crypto_t  aux_cmd_ev_match_val_2_crypto_config;
  input  aux_cmd_ev_match_val_3_comp_t    aux_cmd_ev_match_val_3_comp_config;
  input  aux_cmd_ev_match_val_3_crypto_t  aux_cmd_ev_match_val_3_crypto_config;
  input  debug_trig_mask_hi_t             debug_trig_mask_hi_config;
  input  debug_trig_mask_lo_t             debug_trig_mask_lo_config;
  input  debug_trig_match_hi_t            debug_trig_match_hi_config;
  input  debug_trig_match_lo_t            debug_trig_match_lo_config;
  input  debug_trig_tlv_t                 debug_trig_tlv_config;

  
  
  
  output isf_stats_t                      isf_stat_events;

  
  
  
  input                                   dbg_cmd_disable;
  input                                   xp9_disable;

  
  
  
  input  [`MODULE_ID_WIDTH-1:0]           isf_module_id;
  input                                   cceip_cfg;

  
  
  wire                  aux_cmd_match0_ev;      
  wire                  aux_cmd_match1_ev;      
  wire                  aux_cmd_match2_ev;      
  wire                  aux_cmd_match3_ev;      
  wire                  axi_slv_aempty;         
  wire                  axi_slv_empty;          
  axi4s_dp_bus_t        axi_slv_ob;             
  wire                  axi_slv_ovfl;           
  wire                  axi_slv_rd;             
  wire                  ib_cmd_cnt_stb;         
  wire                  ib_frame_cnt_stb;       
  wire                  ib_prot_error;          
  wire [`LOG_VEC((`ISF_FIFO_ENTRIES)+1)] isf_fifo_depth;
  wire                  isf_sys_stall_intr;     
  wire                  mask_debug;             
  wire                  ovfl_int;               
  wire                  pre_tlvp_fifo_aempty;   
  wire                  pre_tlvp_fifo_afull;    
  wire                  pre_tlvp_fifo_empty;    
  wire                  pre_tlvp_fifo_empty_mod;
  wire                  pre_tlvp_fifo_rd;       
  wire [($bits(axi4s_dp_bus_t))-1:0] pre_tlvp_fifo_rdata;
  wire                  pre_tlvp_fifo_wr;       
  wire                  ss_rd_ok;               
  wire                  tlvp_error;             
  wire                  trigger_hit;            
  wire                  xxx_fifo_empty;         
  


  
  
  
  axi4s_dp_bus_t                         isf_pre_tlvp_fifo_ib_in;
  axi4s_dp_bus_t                         isf_tlv_mod_ib_in;
  tlvp_if_bus_t                          isf_term_tlv;
  logic [`BIT_VEC(`ISF_FIFO_WIDTH)]      isf_fifo_wdata;  
  logic [`BIT_VEC(`ISF_FIFO_WIDTH)]      isf_fifo_sw_wdata;  
  logic [15:0]                           capability_lst;
  logic                                  isf_fifo_hw_rd;
  logic                                  isf_fifo_hw_wr;
  logic                                  isf_term_empty;
  logic                                  isf_uncor_ecc_error;
  wire [(`ISF_FIFO_WIDTH)-1:0]           isf_fifo_rdata;     
  wire [(`ISF_FIFO_WIDTH)-1:0]           isf_fifo_sw_rdata;  
  logic                                  axi_slv_ob_mod_tdata_msb;

  
  assign debug_stat.trigger_hit  = trigger_hit;
  assign debug_stat.ss_rd_ok     = ss_rd_ok;  

  
  
  
  
  
  
  assign isf_int.sys_stall      = isf_sys_stall_intr;        
  assign isf_int.ovfl           = ovfl_int;
  assign isf_int.prot_err       = ib_prot_error;
  assign isf_int.tlvp_int       = tlvp_error;
  assign isf_int.uncor_ecc_err  = isf_uncor_ecc_error;


  
  
  
  
  

  cr_axi4s_slv2
  #(
    .N_ENTRIES (16),
    .N_AFULL_VAL (3),
    .N_AEMPTY_VAL (1)
    )
  u_isf_axi4s_slv
  (
   
   
   .axi4s_ib_out                        (isf_ib_out),            
   .axi4s_slv_out                       (axi_slv_ob),            
   .axi4s_slv_empty                     (axi_slv_empty),         
   .axi4s_slv_aempty                    (axi_slv_aempty),        
   .overflow                            (axi_slv_ovfl),          
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .axi4s_ib_in                         (isf_ib_in),             
   .axi4s_slv_rd                        (axi_slv_rd));            

  

  
  
  
  
  assign axi_slv_ob_mod_tdata_msb  = dbg_cmd_disable && mask_debug ? 1'b0 :  axi_slv_ob.tdata[63];

  
  assign isf_fifo_wdata = {{(`ISF_FIFO_WIDTH-($bits(axi4s_dp_bus_t)))+1{1'b0}}, 
                           axi_slv_ob.tid, axi_slv_ob.tstrb,
                           axi_slv_ob.tuser, axi_slv_ob.tlast, axi_slv_ob_mod_tdata_msb, axi_slv_ob.tdata[62:0]};

  
  assign isf_fifo_sw_wdata  = {{(`ISF_FIFO_WIDTH-($bits(axi4s_dp_bus_t)))+1{1'b0}},
                               isf_fifo_ia_wdata.tid, isf_fifo_ia_wdata.tstrb,
                               isf_fifo_ia_wdata.tuser, isf_fifo_ia_wdata.tlast,
                               isf_fifo_ia_wdata.tdata_hi, isf_fifo_ia_wdata.tdata_lo};


  
  
  assign    {isf_pre_tlvp_fifo_ib_in.tid,
             isf_pre_tlvp_fifo_ib_in.tstrb,
             isf_pre_tlvp_fifo_ib_in.tuser,
             isf_pre_tlvp_fifo_ib_in.tlast,
             isf_pre_tlvp_fifo_ib_in.tdata}  = isf_fifo_rdata[$bits(axi4s_dp_bus_t)-2:0];

  assign     isf_pre_tlvp_fifo_ib_in.tvalid  = 1'b1;

  
  
  assign    {isf_fifo_ia_rdata.tid,
             isf_fifo_ia_rdata.tstrb,
             isf_fifo_ia_rdata.tuser,
             isf_fifo_ia_rdata.tlast,
             isf_fifo_ia_rdata.tdata_hi,
             isf_fifo_ia_rdata.tdata_lo}  = isf_fifo_sw_rdata[$bits(axi4s_dp_bus_t)-2:0];

  assign     isf_fifo_ia_rdata.spare      = 3'h0;

 
  assign     isf_tlv_mod_ib_in               = pre_tlvp_fifo_rdata;

  
  assign isf_fifo_ia_capability.ack_error      = capability_lst[15];
  assign isf_fifo_ia_capability.sim_tmo        = capability_lst[14];
  assign isf_fifo_ia_capability.reserved_op    = capability_lst[13:10];
  assign isf_fifo_ia_capability.compare        = capability_lst[9];
  assign isf_fifo_ia_capability.set_init_start = capability_lst[8];
  assign isf_fifo_ia_capability.initialize_inc = capability_lst[7];
  assign isf_fifo_ia_capability.initialize     = capability_lst[6];
  assign isf_fifo_ia_capability.reset          = capability_lst[5];
  assign isf_fifo_ia_capability.disabled       = capability_lst[4];
  assign isf_fifo_ia_capability.enable         = capability_lst[3];
  assign isf_fifo_ia_capability.write          = capability_lst[2];
  assign isf_fifo_ia_capability.read           = capability_lst[1];
  assign isf_fifo_ia_capability.nop            = capability_lst[0];

  
   

  nx_fifo_1r1w_indirect_access_debug
  #(
    .CMND_ADDRESS (`CR_ISF_ISF_FIFO_IA_CONFIG),       
    .STAT_ADDRESS (`CR_ISF_ISF_FIFO_IA_STATUS),       
    .FSTAT_ADDRESS (`CR_ISF_ISF_FIFO_FIFO_STATUS_0),  
    .ALIGNMENT (2),                                   
    .N_TIMER_BITS (6),                                
    .N_REG_ADDR_BITS (`CR_ISF_WIDTH),                 
    .N_DATA_BITS (`ISF_FIFO_WIDTH),                   
    .N_ENTRIES (`ISF_FIFO_ENTRIES),                   
    .N_INIT_INC_BITS (0),                             
    .SPECIALIZE (1),                                  
    .OUT_FLOP (1))                                    
  u_isf_dbg_fifo
  (
   
   
   .rd_data                             (isf_fifo_rdata[(`ISF_FIFO_WIDTH)-1:0]), 
   .xxx_fifo_empty                      (xxx_fifo_empty),
   .full                                (),                      
   .fifo_depth                          (isf_fifo_depth[`LOG_VEC((`ISF_FIFO_ENTRIES)+1)]), 
   .bimc_odat                           (bimc_odat),
   .bimc_osync                          (bimc_osync),
   .ro_uncorrectable_ecc_error          (isf_uncor_ecc_error),   
   .stat_code                           (isf_fifo_ia_status.code), 
   .stat_datawords                      (isf_fifo_ia_status.datawords), 
   .stat_addr                           (isf_fifo_ia_status.addr), 
   .capability_lst                      (capability_lst),        
   .capability_type                     (isf_fifo_ia_capability.mem_type), 
   .rd_dat                              (isf_fifo_sw_rdata),     
   .fifo_status_0                       (isf_fifo_fifo_status_0), 
   .fifo_status_1                       (isf_fifo_fifo_status_1), 
   
   .wr_data                             (isf_fifo_wdata[(`ISF_FIFO_WIDTH)-1:0]), 
   .wr                                  (isf_fifo_hw_wr),        
   .rd                                  (isf_fifo_hw_rd),        
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .bimc_idat                           (bimc_idat),
   .bimc_rst_n                          (bimc_rst_n),
   .bimc_isync                          (bimc_isync),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .mrdten                              (1'd0),                  
   .reg_addr                            (reg_addr[`BIT_VEC((`CR_ISF_WIDTH))]),
   .cmnd_op                             (isf_fifo_ia_config.op), 
   .cmnd_addr                           (isf_fifo_ia_config.addr), 
   .wr_stb                              (wr_stb),
   .wr_dat                              (isf_fifo_sw_wdata),     
   .load_dbg_values                     (debug_ctl_config.load_dbg_values), 
   .dbg_wr_pointer                      (debug_ctl_config.dbg_wr_pointer[`LOG_VEC((`ISF_FIFO_ENTRIES))]), 
   .dbg_fifo_depth                      (debug_ctl_config.dbg_fifo_depth[`LOG_VEC((`ISF_FIFO_ENTRIES)+1)]), 
   .force_sw_access                     (debug_ctl_config.force_sw_access)); 

  
  
  cr_isf_support u_cr_isf_support
  (
   
   
   .trigger_hit                         (trigger_hit),
   .ss_rd_ok                            (ss_rd_ok),
   .debug_trig_cap_hi                   (debug_trig_cap_hi),
   .debug_trig_cap_lo                   (debug_trig_cap_lo),
   .debug_ss_cap_sb                     (debug_ss_cap_sb),
   .debug_ss_cap_lo                     (debug_ss_cap_lo),
   .debug_ss_cap_hi                     (debug_ss_cap_hi),
   .isf_sys_stall_intr                  (isf_sys_stall_intr),
   .isf_sup_cqe_exit                    (isf_sup_cqe_exit),
   .isf_sup_cqe_rx                      (isf_sup_cqe_rx),
   .isf_sup_rqe_rx                      (isf_sup_rqe_rx),
   .mask_debug                          (mask_debug),
   .axi_slv_rd                          (axi_slv_rd),
   .isf_fifo_hw_rd                      (isf_fifo_hw_rd),
   .isf_fifo_hw_wr                      (isf_fifo_hw_wr),
   .pre_tlvp_fifo_wr                    (pre_tlvp_fifo_wr),
   .pre_tlvp_fifo_empty_mod             (pre_tlvp_fifo_empty_mod),
   .isf_stat_events                     (isf_stat_events),
   .ovfl_int                            (ovfl_int),
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .ctl_config                          (ctl_config),
   .debug_ctl_config                    (debug_ctl_config),
   .system_stall_limit_config           (system_stall_limit_config),
   .debug_trig_mask_hi_config           (debug_trig_mask_hi_config),
   .debug_trig_mask_lo_config           (debug_trig_mask_lo_config),
   .debug_trig_match_hi_config          (debug_trig_match_hi_config),
   .debug_trig_match_lo_config          (debug_trig_match_lo_config),
   .debug_trig_tlv_config               (debug_trig_tlv_config),
   .single_step_rd                      (single_step_rd),
   .axi_slv_ob                          (axi_slv_ob),
   .axi_slv_empty                       (axi_slv_empty),
   .axi_slv_aempty                      (axi_slv_aempty),
   .axi_slv_ovfl                        (axi_slv_ovfl),
   .isf_fifo_depth                      (isf_fifo_depth[`LOG_VEC(`ISF_FIFO_ENTRIES+1)]),
   .isf_fifo_in_tvalid                  (axi_slv_ob.tvalid),     
   .pre_tlvp_fifo_afull                 (pre_tlvp_fifo_afull),
   .pre_tlvp_fifo_empty                 (pre_tlvp_fifo_empty),
   .pre_tlvp_fifo_rd                    (pre_tlvp_fifo_rd),
   .isf_tlv_mod_ib_in                   (isf_tlv_mod_ib_in),
   .isf_term_empty                      (isf_term_empty),
   .isf_term_tlv                        (isf_term_tlv),
   .isf_ob_in                           (isf_ob_in),
   .isf_ob_out                          (isf_ob_out),
   .aux_cmd_match0_ev                   (aux_cmd_match0_ev),
   .aux_cmd_match1_ev                   (aux_cmd_match1_ev),
   .aux_cmd_match2_ev                   (aux_cmd_match2_ev),
   .aux_cmd_match3_ev                   (aux_cmd_match3_ev),
   .ib_frame_cnt_stb                    (ib_frame_cnt_stb),
   .ib_cmd_cnt_stb                      (ib_cmd_cnt_stb));

  
  
  
  


  cr_fifo_wrap1 
  #(
    .N_DATA_BITS ($bits(axi4s_dp_bus_t)),    
    .N_ENTRIES (16),                     
    .N_AFULL_VAL (3),                    
    .N_AEMPTY_VAL (1))                   
  u_isf_pre_tlvp_fifo
  (
   
   
   .full                                (),                      
   .afull                               (pre_tlvp_fifo_afull),   
   .rdata                               (pre_tlvp_fifo_rdata[($bits(axi4s_dp_bus_t))-1:0]), 
   .empty                               (pre_tlvp_fifo_empty),   
   .aempty                              (pre_tlvp_fifo_aempty),  
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .wdata                               (isf_pre_tlvp_fifo_ib_in), 
   .wen                                 (pre_tlvp_fifo_wr),      
   .ren                                 (pre_tlvp_fifo_rd));      


  

  

  cr_isf_tlv_mods u_cr_isf_tlv_mods
  (
   
   
   .ib_bytes_cnt_stb                    (ib_bytes_cnt_stb),
   .ib_bytes_cnt_amt                    (ib_bytes_cnt_amt[3:0]),
   .ib_frame_cnt_stb                    (ib_frame_cnt_stb),
   .ib_cmd_cnt_stb                      (ib_cmd_cnt_stb),
   .isf_fifo_tlvp_rd                    (pre_tlvp_fifo_rd),      
   .isf_tlv_mod_ob_out                  (isf_ob_out),            
   .isf_term_empty                      (isf_term_empty),
   .isf_term_tlv                        (isf_term_tlv),
   .aux_cmd_match0_ev                   (aux_cmd_match0_ev),
   .aux_cmd_match1_ev                   (aux_cmd_match1_ev),
   .aux_cmd_match2_ev                   (aux_cmd_match2_ev),
   .aux_cmd_match3_ev                   (aux_cmd_match3_ev),
   .tlvp_error                          (tlvp_error),
   .ib_prot_error                       (ib_prot_error),
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .isf_tlv_parse_action_0              (isf_tlv_parse_action_0),
   .isf_tlv_parse_action_1              (isf_tlv_parse_action_1),
   .trace_ctl_en_config                 (trace_ctl_en_config),
   .trace_ctl_limits_config             (trace_ctl_limits_config),
   .ctl_config                          (ctl_config),
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
   .isf_tlv_mod_ib_in                   (isf_tlv_mod_ib_in),     
   .isf_tlv_mod_ob_in                   (isf_ob_in),             
   .isf_fifo_empty                      (pre_tlvp_fifo_empty_mod), 
   .isf_fifo_aempty                     (pre_tlvp_fifo_aempty),  
   .dbg_cmd_disable                     (dbg_cmd_disable),
   .xp9_disable                         (xp9_disable),
   .isf_module_id                       (isf_module_id[`MODULE_ID_WIDTH-1:0]),
   .cceip_cfg                           (cceip_cfg));

endmodule 









