/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







 
module cr_prefix_regfile 
 
   (
  
  rbus_ring_o, regs_rec_debug_control, regs_breakpoint_addr,
  regs_ld_breakpoint, regs_breakpoint_cont, regs_breakpoint_step,
  rec_im_dout, rec_im_yield, rec_sat_dout, rec_sat_yield, rec_ct_dout,
  rec_ct_yield, fe_config, tlv_parse_action_1, tlv_parse_action_0,
  regs_rec_us_ctrl, bimc_rst_n, tlvp_bimc_idat, tlvp_bimc_isync,
  bimc_interrupt, recsat_uncorrectable_ecc_error,
  recct_uncorrectable_ecc_error, recim_uncorrectable_ecc_error,
  
  rst_n, clk, cfg_start_addr, cfg_end_addr, rbus_ring_i, feature_ctr,
  rec_debug_status, rec_im_addr, rec_im_cs, rec_sat_addr, rec_sat_cs,
  rec_ct_addr, rec_ct_cs, rec_psr, tlvp_bimc_odat, tlvp_bimc_osync
  );

`include "cr_structs.sv"
`include "bimc_master.vh"   
   import cr_prefixPKG::*;
   import cr_prefix_regfilePKG::*;

   
  
  
  
  input logic                                    rst_n;
  input logic                                    clk;
   
  
  
  
  input [`N_RBUS_ADDR_BITS-1:0]                  cfg_start_addr;
  input [`N_RBUS_ADDR_BITS-1:0]                  cfg_end_addr;
  input                                          rbus_ring_t rbus_ring_i;
  output                                         rbus_ring_t rbus_ring_o;
  
  
  
  
  input  feature_ctr_t                           feature_ctr[0:`N_PREFIX_FEATURES-1] ;
    
  
  
  
  input  prefix_debug_status_t                   rec_debug_status;
  output prefix_debug_control_t                  regs_rec_debug_control;
  output prefix_breakpoint_addr_t                regs_breakpoint_addr;
  output logic                                   regs_ld_breakpoint ;
  output logic                                   regs_breakpoint_cont ;
  output logic                                   regs_breakpoint_step;
 
          
  
  
  
  input [`LOG_VEC(`N_PREFIX_IM_ENTRIES)]         rec_im_addr;
  input logic                                    rec_im_cs;
  output rec_inst_t                              rec_im_dout;
  output logic                                   rec_im_yield;
       
  
  
  
  input  logic [`LOG_VEC(`N_PREFIX_SAT_ENTRIES)] rec_sat_addr;
  input  logic                                   rec_sat_cs;
  output [895:0]                                 rec_sat_dout;
  output logic                                   rec_sat_yield;
      
  
  
  
  input  logic [`LOG_VEC(`N_PREFIX_CT_ENTRIES)]  rec_ct_addr;
  input  logic                                   rec_ct_cs;
  output rec_ct_t                                rec_ct_dout;
  output logic                                   rec_ct_yield; 
      
  
  
  
  input  psr_t                                   rec_psr[0:426] ;
  
  
  
  
  output feature_t                                         fe_config[0:`N_PREFIX_FEATURES-1];
  output [`CR_PREFIX_C_REGS_TLV_PARSE_ACTION_63_32_T_DECL] tlv_parse_action_1;
  output [`CR_PREFIX_C_REGS_TLV_PARSE_ACTION_31_0_T_DECL]  tlv_parse_action_0;
  output prefix_rec_us_ctrl_t                              regs_rec_us_ctrl;
 
  
  
  
  output logic                                  bimc_rst_n;
  output logic                                  tlvp_bimc_idat;
  output logic                                  tlvp_bimc_isync;
  input                                         tlvp_bimc_odat;
  input                                         tlvp_bimc_osync;
  
  
  
  
  output logic                                  bimc_interrupt;
  output logic                                  recsat_uncorrectable_ecc_error;
  output logic                                  recct_uncorrectable_ecc_error;
  output logic                                  recim_uncorrectable_ecc_error;
  
   logic                                        recct_bimc_odat;        
   logic                                        recct_bimc_osync;       
   logic                                        recct_bimc_idat;        
   logic                                        recct_bimc_isync;       
   logic                                        recim_bimc_odat;        
   logic                                        recim_bimc_osync;        
   logic                                        recim_bimc_idat;        
   logic                                        recim_bimc_isync;       
   logic                                        recsat_bimc_odat;       
   logic                                        recsat_bimc_osync;        
   logic                                        recsat_bimc_idat;       
   logic                                        recsat_bimc_isync;       
   logic                                        bimc_odat;       
   logic                                        bimc_osync;        
   logic                                        bimc_idat;       
   logic                                        bimc_isync;      
   
  logic [895:0] recsat_wr_dat;
  logic [895:0] recsat_rd_dat;

 prefix_error_control_t                            regs_error_control;
  
                            
   
   
   logic                bimc_ecc_error;         
   logic [`CR_C_BIMC_CMD2_T_DECL] i_bimc_cmd2;  
   logic [`CR_C_BIMC_DBGCMD0_T_DECL] i_bimc_dbgcmd0;
   logic [`CR_C_BIMC_DBGCMD1_T_DECL] i_bimc_dbgcmd1;
   logic [`CR_C_BIMC_DBGCMD2_T_DECL] i_bimc_dbgcmd2;
   logic [`CR_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_correctable_error_cnt;
   logic [`CR_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_uncorrectable_error_cnt;
   logic [`CR_C_BIMC_ECCPAR_DEBUG_T_DECL] i_bimc_eccpar_debug;
   logic [`CR_C_BIMC_GLOBAL_CONFIG_T_DECL] i_bimc_global_config;
   logic [`CR_C_BIMC_MEMID_T_DECL] i_bimc_memid;
   logic [`CR_C_BIMC_MONITOR_T_DECL] i_bimc_monitor;
   logic [`CR_C_BIMC_PARITY_ERROR_CNT_T_DECL] i_bimc_parity_error_cnt;
   logic [`CR_C_BIMC_POLLRSP0_T_DECL] i_bimc_pollrsp0;
   logic [`CR_C_BIMC_POLLRSP1_T_DECL] i_bimc_pollrsp1;
   logic [`CR_C_BIMC_POLLRSP2_T_DECL] i_bimc_pollrsp2;
   logic [`CR_C_BIMC_RXCMD0_T_DECL] i_bimc_rxcmd0;
   logic [`CR_C_BIMC_RXCMD1_T_DECL] i_bimc_rxcmd1;
   logic [`CR_C_BIMC_RXCMD2_T_DECL] i_bimc_rxcmd2;
   logic [`CR_C_BIMC_RXRSP0_T_DECL] i_bimc_rxrsp0;
   logic [`CR_C_BIMC_RXRSP1_T_DECL] i_bimc_rxrsp1;
   logic [`CR_C_BIMC_RXRSP2_T_DECL] i_bimc_rxrsp2;
   logic                locl_ack;               
   logic                locl_err_ack;           
   logic [31:0]         locl_rd_data;           
   logic                locl_rd_strb;           
   logic                locl_wr_strb;           
   logic [`CR_PREFIX_C_BIMC_CMD0_T_DECL] o_bimc_cmd0;
   logic [`CR_PREFIX_C_BIMC_CMD1_T_DECL] o_bimc_cmd1;
   logic [`CR_PREFIX_C_BIMC_CMD2_T_DECL] o_bimc_cmd2;
   logic [`CR_PREFIX_C_BIMC_DBGCMD2_T_DECL] o_bimc_dbgcmd2;
   logic [`CR_PREFIX_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_correctable_error_cnt;
   logic [`CR_PREFIX_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_uncorrectable_error_cnt;
   logic [`CR_PREFIX_C_BIMC_ECCPAR_DEBUG_T_DECL] o_bimc_eccpar_debug;
   logic [`CR_PREFIX_C_BIMC_GLOBAL_CONFIG_T_DECL] o_bimc_global_config;
   logic [`CR_PREFIX_C_BIMC_MONITOR_MASK_T_DECL] o_bimc_monitor_mask;
   logic [`CR_PREFIX_C_BIMC_PARITY_ERROR_CNT_T_DECL] o_bimc_parity_error_cnt;
   logic [`CR_PREFIX_C_BIMC_POLLRSP2_T_DECL] o_bimc_pollrsp2;
   logic [`CR_PREFIX_C_BIMC_RXCMD2_T_DECL] o_bimc_rxcmd2;
   logic [`CR_PREFIX_C_BIMC_RXRSP2_T_DECL] o_bimc_rxrsp2;
   logic                rd_stb;                 
   logic                wr_stb;                 
   
  
   logic [31:0]                                         regs_breakpoint_cont_r;
   logic [31:0]                                         regs_breakpoint_step_r;
   logic [`CR_PREFIX_DECL]                      reg_addr; 
   logic [`CR_PREFIX_DECL]                      locl_addr;
   logic [`N_RBUS_DATA_BITS-1:0]                locl_wr_data;
   spare_t                                      spare; 
      
  
   
   feature_t                                    feature_rst_dat[`N_PREFIX_FEATURES-1:0];
   feature_t                                    feature_ia_wdata;
   feature_t                                    feature_ia_rdata;  
   feature_ia_config_t                          feature_ia_config;  
   feature_ia_status_t                          feature_ia_status;  
   feature_ia_capability_t                      feature_ia_capability;
 
   
   feature_ctr_t                                feature_ctr_ia_wdata;
   feature_ctr_t                                feature_ctr_ia_rdata;  
   feature_ctr_ia_config_t                      feature_ctr_ia_config;  
   feature_ctr_ia_status_t                      feature_ctr_ia_status;  
   feature_ctr_ia_capability_t                  feature_ctr_ia_capability;
 
  
   
   rec_inst_t                                   recim_ia_wdata;
   rec_inst_t                                   recim_ia_rdata;  
   recim_ia_config_t                            recim_ia_config;  
   recim_ia_status_t                            recim_ia_status;  
   recim_ia_capability_t                        recim_ia_capability;
  
   
   rec_sat_t                                    recsat_ia_wdata; 
   rec_sat_t                                    recsat_ia_rdata;  
   recsat_ia_config_t                           recsat_ia_config;  
   recsat_ia_status_t                           recsat_ia_status;  
   recsat_ia_capability_t                       recsat_ia_capability;
  
   
   rec_ct_t                                     recct_ia_wdata;
   rec_ct_t                                     recct_ia_rdata;  
   recct_ia_config_t                            recct_ia_config;  
   recct_ia_status_t                            recct_ia_status;  
   recct_ia_capability_t                        recct_ia_capability;
  
   
   psr_t                                        psr_ia_wdata;
   psr_t                                        psr_ia_rdata;  
   psr_ia_config_t                              psr_ia_config;  
   psr_ia_status_t                              psr_ia_status;  
   psr_ia_capability_t                          psr_ia_capability;
                
  

   
  always_comb begin
      
    recim_bimc_idat             = bimc_odat;
    recim_bimc_isync            = bimc_osync;
    
    recsat_bimc_idat            = recim_bimc_odat;
    recsat_bimc_isync           = recim_bimc_osync;
   
    recct_bimc_idat             = recsat_bimc_odat;
    recct_bimc_isync            = recsat_bimc_osync;
    
    tlvp_bimc_idat               = recct_bimc_odat;    
    tlvp_bimc_isync              = recct_bimc_osync;
    
    bimc_idat                   = tlvp_bimc_odat;    
    bimc_isync                  = tlvp_bimc_osync;

    regs_ld_breakpoint          = wr_stb & (reg_addr== `CR_PREFIX_REGS_BREAKPOINT_ADDR); 
    regs_breakpoint_cont        = wr_stb & (reg_addr== `CR_PREFIX_REGS_BREAKPOINT_CONT); 
    regs_breakpoint_step        = wr_stb & (reg_addr== `CR_PREFIX_REGS_BREAKPOINT_STEP); 

    
    
   end 
    
  genvar k;
    generate
    for(k=0;k<128;k=k+1) begin
      assign recsat_wr_dat[(k*7)+6:(k*7)]   = recsat_ia_wdata[(k*8)+6:(k*8)];
      assign recsat_ia_rdata[(k*8)+7:(k*8)] = {1'b0,recsat_rd_dat[(k*7)+6:(k*7)]};
    end
  endgenerate
      
  
   
   bimc_master bimc_master
     (
      
      .bimc_ecc_error                   (bimc_ecc_error),
      .bimc_interrupt                   (bimc_interrupt),
      .bimc_odat                        (bimc_odat),
      .bimc_rst_n                       (bimc_rst_n),
      .bimc_osync                       (bimc_osync),
      .i_bimc_monitor                   (i_bimc_monitor[`CR_C_BIMC_MONITOR_T_DECL]),
      .i_bimc_ecc_uncorrectable_error_cnt(i_bimc_ecc_uncorrectable_error_cnt[`CR_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]),
      .i_bimc_ecc_correctable_error_cnt (i_bimc_ecc_correctable_error_cnt[`CR_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]),
      .i_bimc_parity_error_cnt          (i_bimc_parity_error_cnt[`CR_C_BIMC_PARITY_ERROR_CNT_T_DECL]),
      .i_bimc_global_config             (i_bimc_global_config[`CR_C_BIMC_GLOBAL_CONFIG_T_DECL]),
      .i_bimc_memid                     (i_bimc_memid[`CR_C_BIMC_MEMID_T_DECL]),
      .i_bimc_eccpar_debug              (i_bimc_eccpar_debug[`CR_C_BIMC_ECCPAR_DEBUG_T_DECL]),
      .i_bimc_cmd2                      (i_bimc_cmd2[`CR_C_BIMC_CMD2_T_DECL]),
      .i_bimc_rxcmd2                    (i_bimc_rxcmd2[`CR_C_BIMC_RXCMD2_T_DECL]),
      .i_bimc_rxcmd1                    (i_bimc_rxcmd1[`CR_C_BIMC_RXCMD1_T_DECL]),
      .i_bimc_rxcmd0                    (i_bimc_rxcmd0[`CR_C_BIMC_RXCMD0_T_DECL]),
      .i_bimc_rxrsp2                    (i_bimc_rxrsp2[`CR_C_BIMC_RXRSP2_T_DECL]),
      .i_bimc_rxrsp1                    (i_bimc_rxrsp1[`CR_C_BIMC_RXRSP1_T_DECL]),
      .i_bimc_rxrsp0                    (i_bimc_rxrsp0[`CR_C_BIMC_RXRSP0_T_DECL]),
      .i_bimc_pollrsp2                  (i_bimc_pollrsp2[`CR_C_BIMC_POLLRSP2_T_DECL]),
      .i_bimc_pollrsp1                  (i_bimc_pollrsp1[`CR_C_BIMC_POLLRSP1_T_DECL]),
      .i_bimc_pollrsp0                  (i_bimc_pollrsp0[`CR_C_BIMC_POLLRSP0_T_DECL]),
      .i_bimc_dbgcmd2                   (i_bimc_dbgcmd2[`CR_C_BIMC_DBGCMD2_T_DECL]),
      .i_bimc_dbgcmd1                   (i_bimc_dbgcmd1[`CR_C_BIMC_DBGCMD1_T_DECL]),
      .i_bimc_dbgcmd0                   (i_bimc_dbgcmd0[`CR_C_BIMC_DBGCMD0_T_DECL]),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .bimc_idat                        (bimc_idat),
      .bimc_isync                       (bimc_isync),
      .o_bimc_monitor_mask              (o_bimc_monitor_mask[`CR_C_BIMC_MONITOR_MASK_T_DECL]),
      .o_bimc_ecc_uncorrectable_error_cnt(o_bimc_ecc_uncorrectable_error_cnt[`CR_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]),
      .o_bimc_ecc_correctable_error_cnt (o_bimc_ecc_correctable_error_cnt[`CR_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]),
      .o_bimc_parity_error_cnt          (o_bimc_parity_error_cnt[`CR_C_BIMC_PARITY_ERROR_CNT_T_DECL]),
      .o_bimc_global_config             (o_bimc_global_config[`CR_C_BIMC_GLOBAL_CONFIG_T_DECL]),
      .o_bimc_eccpar_debug              (o_bimc_eccpar_debug[`CR_C_BIMC_ECCPAR_DEBUG_T_DECL]),
      .o_bimc_cmd2                      (o_bimc_cmd2[`CR_C_BIMC_CMD2_T_DECL]),
      .o_bimc_cmd1                      (o_bimc_cmd1[`CR_C_BIMC_CMD1_T_DECL]),
      .o_bimc_cmd0                      (o_bimc_cmd0[`CR_C_BIMC_CMD0_T_DECL]),
      .o_bimc_rxcmd2                    (o_bimc_rxcmd2[`CR_C_BIMC_RXCMD2_T_DECL]),
      .o_bimc_rxrsp2                    (o_bimc_rxrsp2[`CR_C_BIMC_RXRSP2_T_DECL]),
      .o_bimc_pollrsp2                  (o_bimc_pollrsp2[`CR_C_BIMC_POLLRSP2_T_DECL]),
      .o_bimc_dbgcmd2                   (o_bimc_dbgcmd2[`CR_C_BIMC_DBGCMD2_T_DECL]));
   

   
   
   
   
   

   
   revid_t revid_wire;
     
   CR_TIE_CELL revid_wire_0 (.ob(revid_wire.f.revid[0]), .o());
   CR_TIE_CELL revid_wire_1 (.ob(revid_wire.f.revid[1]), .o());
   CR_TIE_CELL revid_wire_2 (.ob(revid_wire.f.revid[2]), .o());
   CR_TIE_CELL revid_wire_3 (.ob(revid_wire.f.revid[3]), .o());
   CR_TIE_CELL revid_wire_4 (.ob(revid_wire.f.revid[4]), .o());
   CR_TIE_CELL revid_wire_5 (.ob(revid_wire.f.revid[5]), .o());
   CR_TIE_CELL revid_wire_6 (.ob(revid_wire.f.revid[6]), .o());
   CR_TIE_CELL revid_wire_7 (.ob(revid_wire.f.revid[7]), .o());
   
     
  
  
  

   genvar              i;

   always_comb begin
      integer ii;

      for (ii=0; ii<`N_PREFIX_FEATURES; ii++) begin
        feature_rst_dat[ii] = feature_t_reset;
      end
   end
   

   nx_reg_indirect_access
       #(
         
         .CMND_ADDRESS                  (`CR_PREFIX_FEATURE_IA_CONFIG), 
         .STAT_ADDRESS                  (`CR_PREFIX_FEATURE_IA_STATUS), 
         .ALIGNMENT                     (2),                     
         .N_DATA_BITS                   ($bits(feature_t)),      
         .N_REG_ADDR_BITS               (`CR_PREFIX_WIDTH),      
         .N_ENTRIES                     (`N_PREFIX_FEATURES))    
      FEATURE
        (
         
         .stat_code                     (feature_ia_status.f.code), 
         .stat_datawords                (feature_ia_status.f.datawords), 
         .stat_addr                     (feature_ia_status.f.addr), 
         .capability_lst                (feature_ia_capability.r.part0[15:0]), 
         .capability_type               (feature_ia_capability.f.mem_type), 
         .rd_dat                        (feature_ia_rdata),      
         .mem_a                         (fe_config),             
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .addr                          (reg_addr),              
         .cmnd_op                       (feature_ia_config.f.op), 
         .cmnd_addr                     (feature_ia_config.f.addr), 
         .wr_stb                        (wr_stb),
         .wr_dat                        (feature_ia_wdata),      
         .rst_dat                       (feature_rst_dat));      
  
  
  
  
   

   nx_roreg_indirect_access
       #(
         
         .CMND_ADDRESS                  (`CR_PREFIX_FEATURE_CTR_IA_CONFIG), 
         .STAT_ADDRESS                  (`CR_PREFIX_FEATURE_CTR_IA_STATUS), 
         .ALIGNMENT                     (2),                     
         .N_DATA_BITS                   ($bits(feature_ctr_t)),  
         .N_REG_ADDR_BITS               (`CR_PREFIX_WIDTH),      
         .N_ENTRIES                     (`N_PREFIX_FEATURES))    
      FEATURE_CTRR
        (
         
         .stat_code                     (feature_ctr_ia_status.f.code), 
         .stat_datawords                (feature_ctr_ia_status.f.datawords), 
         .stat_addr                     (feature_ctr_ia_status.f.addr), 
         .capability_lst                (feature_ctr_ia_capability.r.part0[15:0]), 
         .capability_type               (feature_ctr_ia_capability.f.mem_type), 
         .rd_dat                        (feature_ctr_ia_rdata),  
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .addr                          (reg_addr),              
         .cmnd_op                       (feature_ctr_ia_config.f.op), 
         .cmnd_addr                     (feature_ctr_ia_config.f.addr), 
         .wr_stb                        (wr_stb),
         .wr_dat                        (feature_ctr_ia_wdata),  
         .mem_a                         (feature_ctr));          
  
  
  
  
   

   nx_roreg_indirect_access
       #(
         
         .CMND_ADDRESS                  (`CR_PREFIX_PSR_IA_CONFIG), 
         .STAT_ADDRESS                  (`CR_PREFIX_PSR_IA_STATUS), 
         .ALIGNMENT                     (2),                     
         .N_DATA_BITS                   ($bits(psr_t)),          
         .N_REG_ADDR_BITS               (`CR_PREFIX_WIDTH),      
         .N_ENTRIES                     (427))                   
      PSR
        (
         
         .stat_code                     (psr_ia_status.f.code),  
         .stat_datawords                (psr_ia_status.f.datawords), 
         .stat_addr                     (psr_ia_status.f.addr),  
         .capability_lst                (psr_ia_capability.r.part0[15:0]), 
         .capability_type               (psr_ia_capability.f.mem_type), 
         .rd_dat                        (psr_ia_rdata),          
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .addr                          (reg_addr),              
         .cmnd_op                       (psr_ia_config.f.op),    
         .cmnd_addr                     (psr_ia_config.f.addr),  
         .wr_stb                        (wr_stb),
         .wr_dat                        (psr_ia_wdata),          
         .mem_a                         (rec_psr));              
  
  
  
  
  
  
  nx_ram_1r1w_indirect_access # 
    (
     
     .CMND_ADDRESS                      (`CR_PREFIX_RECIM_IA_CONFIG), 
     .STAT_ADDRESS                      (`CR_PREFIX_RECIM_IA_STATUS), 
     .ALIGNMENT                         (2),                     
     .N_TIMER_BITS                      (6),                     
     .N_REG_ADDR_BITS                   (`CR_PREFIX_WIDTH),      
     .N_DATA_BITS                       ($bits(rec_inst_t)),     
     .N_ENTRIES                         (`N_PREFIX_IM_ENTRIES),  
     .N_INIT_INC_BITS                   (0),                     
     .SPECIALIZE                        (1),                     
     .IN_FLOP                           (1),                     
     .OUT_FLOP                          (0),                     
     .RD_LATENCY                        (1),                     
     .RESET_DATA                        (rec_inst_t_reset))      
  RECIM                         
    (
     
     .stat_code                         (recim_ia_status.f.code), 
     .stat_datawords                    (recim_ia_status.f.datawords), 
     .stat_addr                         (recim_ia_status.f.addr), 
     .capability_lst                    (recim_ia_capability.r.part0[15:0]), 
     .capability_type                   ({recim_ia_capability.f.mem_type}), 
     .rd_dat                            (recim_ia_rdata),        
     .bimc_odat                         (recim_bimc_odat),       
     .bimc_osync                        (recim_bimc_osync),      
     .ro_uncorrectable_ecc_error        (recim_uncorrectable_ecc_error), 
     .hw_dout                           (rec_im_dout),           
     .hw_yield                          (rec_im_yield),          
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .reg_addr                          (reg_addr),              
     .cmnd_op                           (recim_ia_config.f.op),  
     .cmnd_addr                         (recim_ia_config.f.addr), 
     .wr_stb                            (wr_stb),                
     .wr_dat                            (recim_ia_wdata),        
     .lvm                               (1'b0),                  
     .mlvm                              (1'b0),                  
     .mrdten                            (1'b0),                  
     .bimc_rst_n                        (bimc_rst_n),            
     .bimc_isync                        (recim_bimc_isync),      
     .bimc_idat                         (recim_bimc_idat),       
     .hw_cs                             (rec_im_cs),             
     .hw_raddr                          (rec_im_addr),           
     .hw_waddr                          ({($clog2(`N_PREFIX_IM_ENTRIES)){1'b0}}), 
     .hw_we                             (1'b0),                  
     .hw_re                             (1'b1),                  
     .hw_din                            ({$bits(rec_inst_t){1'b0}})); 
  

                   
  
  
  
  
  
  nx_ram_1r1w_indirect_access # 
    (
     
     .CMND_ADDRESS                      (`CR_PREFIX_RECSAT_IA_CONFIG), 
     .STAT_ADDRESS                      (`CR_PREFIX_RECSAT_IA_STATUS), 
     .ALIGNMENT                         (2),                     
     .N_TIMER_BITS                      (6),                     
     .N_REG_ADDR_BITS                   (`CR_PREFIX_WIDTH),      
     .N_DATA_BITS                       (896),                   
     .N_ENTRIES                         (`N_PREFIX_SAT_ENTRIES), 
     .N_INIT_INC_BITS                   (0),                     
     .SPECIALIZE                        (1),                     
     .IN_FLOP                           (1),                     
     .OUT_FLOP                          (0),                     
     .RD_LATENCY                        (1),                     
     .RESET_DATA                        (rec_sat_t_reset))       
  RECSAT                         
    (
     
     .stat_code                         (recsat_ia_status.f.code), 
     .stat_datawords                    (recsat_ia_status.f.datawords), 
     .stat_addr                         (recsat_ia_status.f.addr), 
     .capability_lst                    (recsat_ia_capability.r.part0[15:0]), 
     .capability_type                   ({recsat_ia_capability.f.mem_type}), 
     .rd_dat                            (recsat_rd_dat),         
     .bimc_odat                         (recsat_bimc_odat),      
     .bimc_osync                        (recsat_bimc_osync),     
     .ro_uncorrectable_ecc_error        (recsat_uncorrectable_ecc_error), 
     .hw_dout                           (rec_sat_dout),          
     .hw_yield                          (rec_sat_yield),         
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .reg_addr                          (reg_addr),              
     .cmnd_op                           (recsat_ia_config.f.op), 
     .cmnd_addr                         (recsat_ia_config.f.addr), 
     .wr_stb                            (wr_stb),                
     .wr_dat                            (recsat_wr_dat),         
     .lvm                               (1'b0),                  
     .mlvm                              (1'b0),                  
     .mrdten                            (1'b0),                  
     .bimc_rst_n                        (bimc_rst_n),            
     .bimc_isync                        (recsat_bimc_isync),     
     .bimc_idat                         (recsat_bimc_idat),      
     .hw_cs                             (rec_sat_cs),            
     .hw_raddr                          (rec_sat_addr),          
     .hw_waddr                          ({($clog2(`N_PREFIX_SAT_ENTRIES)){1'b0}}), 
     .hw_we                             (1'b0),                  
     .hw_re                             (1'b1),                  
     .hw_din                            ({896{1'b0}}));          

  
  
  
  
  
  
  
  nx_ram_1r1w_indirect_access # 
    (
     
     .CMND_ADDRESS                      (`CR_PREFIX_RECCT_IA_CONFIG), 
     .STAT_ADDRESS                      (`CR_PREFIX_RECCT_IA_STATUS), 
     .ALIGNMENT                         (2),                     
     .N_TIMER_BITS                      (6),                     
     .N_REG_ADDR_BITS                   (`CR_PREFIX_WIDTH),      
     .N_DATA_BITS                       ($bits(rec_ct_t)),       
     .N_ENTRIES                         (`N_PREFIX_CT_ENTRIES),  
     .N_INIT_INC_BITS                   (0),                     
     .SPECIALIZE                        (1),                     
     .IN_FLOP                           (1),                     
     .OUT_FLOP                          (0),                     
     .RD_LATENCY                        (1),                     
     .RESET_DATA                        (rec_ct_t_reset))        
  RECCT                         
    (
     
     .stat_code                         (recct_ia_status.f.code), 
     .stat_datawords                    (recct_ia_status.f.datawords), 
     .stat_addr                         (recct_ia_status.f.addr), 
     .capability_lst                    (recct_ia_capability.r.part0[15:0]), 
     .capability_type                   ({recct_ia_capability.f.mem_type}), 
     .rd_dat                            (recct_ia_rdata),        
     .bimc_odat                         (recct_bimc_odat),       
     .bimc_osync                        (recct_bimc_osync),      
     .ro_uncorrectable_ecc_error        (recct_uncorrectable_ecc_error), 
     .hw_dout                           (rec_ct_dout),           
     .hw_yield                          (rec_ct_yield),          
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .reg_addr                          (reg_addr),              
     .cmnd_op                           (recct_ia_config.f.op),  
     .cmnd_addr                         (recct_ia_config.f.addr), 
     .wr_stb                            (wr_stb),                
     .wr_dat                            (recct_ia_wdata),        
     .lvm                               (1'b0),                  
     .mlvm                              (1'b0),                  
     .mrdten                            (1'b0),                  
     .bimc_rst_n                        (bimc_rst_n),            
     .bimc_isync                        (recct_bimc_isync),      
     .bimc_idat                         (recct_bimc_idat),       
     .hw_cs                             (rec_ct_cs),             
     .hw_raddr                          (rec_ct_addr),           
     .hw_waddr                          ({($clog2(`N_PREFIX_CT_ENTRIES)){1'b0}}), 
     .hw_we                             (1'b0),                  
     .hw_re                             (1'b1),                  
     .hw_din                            ({$bits(rec_ct_t){1'b0}})); 
               

        
   
   
   
   cr_prefix_regs u_cr_prefix_regs 
     (
      
      .o_rd_data                        (locl_rd_data[31:0]),    
      .o_ack                            (locl_ack),              
      .o_err_ack                        (locl_err_ack),          
      .o_spare_config                   (spare),                 
      .o_regs_rec_us_ctrl               (regs_rec_us_ctrl),      
      .o_regs_rec_debug_control         (regs_rec_debug_control), 
      .o_regs_breakpoint_addr           (regs_breakpoint_addr),  
      .o_regs_breakpoint_cont           (regs_breakpoint_cont_r), 
      .o_regs_breakpoint_step           (regs_breakpoint_step_r), 
      .o_regs_error_control             (regs_error_control),    
      .o_regs_tlv_parse_action_0        (tlv_parse_action_0),    
      .o_regs_tlv_parse_action_1        (tlv_parse_action_1),    
      .o_feature_ia_wdata_part0         (feature_ia_wdata.r.part0), 
      .o_feature_ia_wdata_part1         (feature_ia_wdata.r.part1), 
      .o_feature_ia_config              (feature_ia_config),     
      .o_feature_ctr_ia_wdata_part0     (feature_ctr_ia_wdata.r.part0), 
      .o_feature_ctr_ia_config          (feature_ctr_ia_config), 
      .o_recim_ia_wdata_part0           (recim_ia_wdata),        
      .o_recim_ia_config                (recim_ia_config),       
      .o_recsat_ia_wdata_part0          (recsat_ia_wdata.r.part0), 
      .o_recsat_ia_wdata_part1          (recsat_ia_wdata.r.part1), 
      .o_recsat_ia_wdata_part2          (recsat_ia_wdata.r.part2), 
      .o_recsat_ia_wdata_part3          (recsat_ia_wdata.r.part3), 
      .o_recsat_ia_wdata_part4          (recsat_ia_wdata.r.part4), 
      .o_recsat_ia_wdata_part5          (recsat_ia_wdata.r.part5), 
      .o_recsat_ia_wdata_part6          (recsat_ia_wdata.r.part6), 
      .o_recsat_ia_wdata_part7          (recsat_ia_wdata.r.part7), 
      .o_recsat_ia_wdata_part8          (recsat_ia_wdata.r.part8), 
      .o_recsat_ia_wdata_part9          (recsat_ia_wdata.r.part9), 
      .o_recsat_ia_wdata_part10         (recsat_ia_wdata.r.part10), 
      .o_recsat_ia_wdata_part11         (recsat_ia_wdata.r.part11), 
      .o_recsat_ia_wdata_part12         (recsat_ia_wdata.r.part12), 
      .o_recsat_ia_wdata_part13         (recsat_ia_wdata.r.part13), 
      .o_recsat_ia_wdata_part14         (recsat_ia_wdata.r.part14), 
      .o_recsat_ia_wdata_part15         (recsat_ia_wdata.r.part15), 
      .o_recsat_ia_wdata_part16         (recsat_ia_wdata.r.part16), 
      .o_recsat_ia_wdata_part17         (recsat_ia_wdata.r.part17), 
      .o_recsat_ia_wdata_part18         (recsat_ia_wdata.r.part18), 
      .o_recsat_ia_wdata_part19         (recsat_ia_wdata.r.part19), 
      .o_recsat_ia_wdata_part20         (recsat_ia_wdata.r.part20), 
      .o_recsat_ia_wdata_part21         (recsat_ia_wdata.r.part21), 
      .o_recsat_ia_wdata_part22         (recsat_ia_wdata.r.part22), 
      .o_recsat_ia_wdata_part23         (recsat_ia_wdata.r.part23), 
      .o_recsat_ia_wdata_part24         (recsat_ia_wdata.r.part24), 
      .o_recsat_ia_wdata_part25         (recsat_ia_wdata.r.part25), 
      .o_recsat_ia_wdata_part26         (recsat_ia_wdata.r.part26), 
      .o_recsat_ia_wdata_part27         (recsat_ia_wdata.r.part27), 
      .o_recsat_ia_wdata_part28         (recsat_ia_wdata.r.part28), 
      .o_recsat_ia_wdata_part29         (recsat_ia_wdata.r.part29), 
      .o_recsat_ia_wdata_part30         (recsat_ia_wdata.r.part30), 
      .o_recsat_ia_wdata_part31         (recsat_ia_wdata.r.part31), 
      .o_recsat_ia_config               (recsat_ia_config),      
      .o_recct_ia_wdata_part0           (recct_ia_wdata.r.part0), 
      .o_recct_ia_wdata_part1           (recct_ia_wdata.r.part1), 
      .o_recct_ia_wdata_part2           (recct_ia_wdata.r.part2), 
      .o_recct_ia_wdata_part3           (recct_ia_wdata.r.part3), 
      .o_recct_ia_wdata_part4           (recct_ia_wdata.r.part4), 
      .o_recct_ia_wdata_part5           (recct_ia_wdata.r.part5), 
      .o_recct_ia_wdata_part6           (recct_ia_wdata.r.part6), 
      .o_recct_ia_wdata_part7           (recct_ia_wdata.r.part7), 
      .o_recct_ia_wdata_part8           (recct_ia_wdata.r.part8), 
      .o_recct_ia_wdata_part9           (recct_ia_wdata.r.part9), 
      .o_recct_ia_wdata_part10          (recct_ia_wdata.r.part10), 
      .o_recct_ia_wdata_part11          (recct_ia_wdata.r.part11), 
      .o_recct_ia_wdata_part12          (recct_ia_wdata.r.part12), 
      .o_recct_ia_wdata_part13          (recct_ia_wdata.r.part13), 
      .o_recct_ia_wdata_part14          (recct_ia_wdata.r.part14), 
      .o_recct_ia_wdata_part15          (recct_ia_wdata.r.part15), 
      .o_recct_ia_wdata_part16          (recct_ia_wdata.r.part16), 
      .o_recct_ia_wdata_part17          (recct_ia_wdata.r.part17), 
      .o_recct_ia_wdata_part18          (recct_ia_wdata.r.part18), 
      .o_recct_ia_wdata_part19          (recct_ia_wdata.r.part19), 
      .o_recct_ia_wdata_part20          (recct_ia_wdata.r.part20), 
      .o_recct_ia_wdata_part21          (recct_ia_wdata.r.part21), 
      .o_recct_ia_wdata_part22          (recct_ia_wdata.r.part22), 
      .o_recct_ia_wdata_part23          (recct_ia_wdata.r.part23), 
      .o_recct_ia_wdata_part24          (recct_ia_wdata.r.part24), 
      .o_recct_ia_wdata_part25          (recct_ia_wdata.r.part25), 
      .o_recct_ia_wdata_part26          (recct_ia_wdata.r.part26), 
      .o_recct_ia_wdata_part27          (recct_ia_wdata.r.part27), 
      .o_recct_ia_wdata_part28          (recct_ia_wdata.r.part28), 
      .o_recct_ia_wdata_part29          (recct_ia_wdata.r.part29), 
      .o_recct_ia_wdata_part30          (recct_ia_wdata.r.part30), 
      .o_recct_ia_wdata_part31          (recct_ia_wdata.r.part31), 
      .o_recct_ia_config                (recct_ia_config),       
      .o_psr_ia_wdata_part0             (psr_ia_wdata.r.part0),  
      .o_psr_ia_config                  (psr_ia_config),         
      .o_bimc_monitor_mask              (o_bimc_monitor_mask[`CR_PREFIX_C_BIMC_MONITOR_MASK_T_DECL]),
      .o_bimc_ecc_uncorrectable_error_cnt(o_bimc_ecc_uncorrectable_error_cnt[`CR_PREFIX_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]),
      .o_bimc_ecc_correctable_error_cnt (o_bimc_ecc_correctable_error_cnt[`CR_PREFIX_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]),
      .o_bimc_parity_error_cnt          (o_bimc_parity_error_cnt[`CR_PREFIX_C_BIMC_PARITY_ERROR_CNT_T_DECL]),
      .o_bimc_global_config             (o_bimc_global_config[`CR_PREFIX_C_BIMC_GLOBAL_CONFIG_T_DECL]),
      .o_bimc_eccpar_debug              (o_bimc_eccpar_debug[`CR_PREFIX_C_BIMC_ECCPAR_DEBUG_T_DECL]),
      .o_bimc_cmd2                      (o_bimc_cmd2[`CR_PREFIX_C_BIMC_CMD2_T_DECL]),
      .o_bimc_cmd1                      (o_bimc_cmd1[`CR_PREFIX_C_BIMC_CMD1_T_DECL]),
      .o_bimc_cmd0                      (o_bimc_cmd0[`CR_PREFIX_C_BIMC_CMD0_T_DECL]),
      .o_bimc_rxcmd2                    (o_bimc_rxcmd2[`CR_PREFIX_C_BIMC_RXCMD2_T_DECL]),
      .o_bimc_rxrsp2                    (o_bimc_rxrsp2[`CR_PREFIX_C_BIMC_RXRSP2_T_DECL]),
      .o_bimc_pollrsp2                  (o_bimc_pollrsp2[`CR_PREFIX_C_BIMC_POLLRSP2_T_DECL]),
      .o_bimc_dbgcmd2                   (o_bimc_dbgcmd2[`CR_PREFIX_C_BIMC_DBGCMD2_T_DECL]),
      .o_reg_written                    (wr_stb),                
      .o_reg_read                       (rd_stb),                
      .o_reg_wr_data                    (),                      
      .o_reg_addr                       (reg_addr),              
      
      .clk                              (clk),
      .i_reset_                         (rst_n),                 
      .i_sw_init                        (1'd0),                  
      .i_addr                           (locl_addr),             
      .i_wr_strb                        (locl_wr_strb),          
      .i_wr_data                        (locl_wr_data),          
      .i_rd_strb                        (locl_rd_strb),          
      .i_revision_config                (revid_wire),            
      .i_spare_config                   (spare),                 
      .i_regs_rec_us_ctrl               (regs_rec_us_ctrl),      
      .i_regs_rec_debug_control         (regs_rec_debug_control), 
      .i_regs_breakpoint_addr           (regs_breakpoint_addr),  
      .i_regs_breakpoint_cont           (regs_breakpoint_cont_r), 
      .i_regs_breakpoint_step           (regs_breakpoint_step_r), 
      .i_rec_debug_status               (rec_debug_status),      
      .i_regs_error_control             (regs_error_control),    
      .i_feature_ia_capability          (feature_ia_capability), 
      .i_feature_ia_status              (feature_ia_status),     
      .i_feature_ia_rdata_part0         (feature_ia_rdata.r.part0), 
      .i_feature_ia_rdata_part1         (feature_ia_rdata.r.part1), 
      .i_feature_ctr_ia_capability      (feature_ctr_ia_capability), 
      .i_feature_ctr_ia_status          (feature_ctr_ia_status), 
      .i_feature_ctr_ia_rdata_part0     (feature_ctr_ia_rdata.r.part0), 
      .i_recim_ia_capability            (recim_ia_capability),   
      .i_recim_ia_status                (recim_ia_status),       
      .i_recim_ia_rdata_part0           (recim_ia_rdata),        
      .i_recsat_ia_capability           (recsat_ia_capability),  
      .i_recsat_ia_status               (recsat_ia_status),      
      .i_recsat_ia_rdata_part0          (recsat_ia_rdata.r.part0), 
      .i_recsat_ia_rdata_part1          (recsat_ia_rdata.r.part1), 
      .i_recsat_ia_rdata_part2          (recsat_ia_rdata.r.part2), 
      .i_recsat_ia_rdata_part3          (recsat_ia_rdata.r.part3), 
      .i_recsat_ia_rdata_part4          (recsat_ia_rdata.r.part4), 
      .i_recsat_ia_rdata_part5          (recsat_ia_rdata.r.part5), 
      .i_recsat_ia_rdata_part6          (recsat_ia_rdata.r.part6), 
      .i_recsat_ia_rdata_part7          (recsat_ia_rdata.r.part7), 
      .i_recsat_ia_rdata_part8          (recsat_ia_rdata.r.part8), 
      .i_recsat_ia_rdata_part9          (recsat_ia_rdata.r.part9), 
      .i_recsat_ia_rdata_part10         (recsat_ia_rdata.r.part10), 
      .i_recsat_ia_rdata_part11         (recsat_ia_rdata.r.part11), 
      .i_recsat_ia_rdata_part12         (recsat_ia_rdata.r.part12), 
      .i_recsat_ia_rdata_part13         (recsat_ia_rdata.r.part13), 
      .i_recsat_ia_rdata_part14         (recsat_ia_rdata.r.part14), 
      .i_recsat_ia_rdata_part15         (recsat_ia_rdata.r.part15), 
      .i_recsat_ia_rdata_part16         (recsat_ia_rdata.r.part16), 
      .i_recsat_ia_rdata_part17         (recsat_ia_rdata.r.part17), 
      .i_recsat_ia_rdata_part18         (recsat_ia_rdata.r.part18), 
      .i_recsat_ia_rdata_part19         (recsat_ia_rdata.r.part19), 
      .i_recsat_ia_rdata_part20         (recsat_ia_rdata.r.part20), 
      .i_recsat_ia_rdata_part21         (recsat_ia_rdata.r.part21), 
      .i_recsat_ia_rdata_part22         (recsat_ia_rdata.r.part22), 
      .i_recsat_ia_rdata_part23         (recsat_ia_rdata.r.part23), 
      .i_recsat_ia_rdata_part24         (recsat_ia_rdata.r.part24), 
      .i_recsat_ia_rdata_part25         (recsat_ia_rdata.r.part25), 
      .i_recsat_ia_rdata_part26         (recsat_ia_rdata.r.part26), 
      .i_recsat_ia_rdata_part27         (recsat_ia_rdata.r.part27), 
      .i_recsat_ia_rdata_part28         (recsat_ia_rdata.r.part28), 
      .i_recsat_ia_rdata_part29         (recsat_ia_rdata.r.part29), 
      .i_recsat_ia_rdata_part30         (recsat_ia_rdata.r.part30), 
      .i_recsat_ia_rdata_part31         (recsat_ia_rdata.r.part31), 
      .i_recct_ia_capability            (recct_ia_capability),   
      .i_recct_ia_status                (recct_ia_status),       
      .i_recct_ia_rdata_part0           (recct_ia_rdata.r.part0), 
      .i_recct_ia_rdata_part1           (recct_ia_rdata.r.part1), 
      .i_recct_ia_rdata_part2           (recct_ia_rdata.r.part2), 
      .i_recct_ia_rdata_part3           (recct_ia_rdata.r.part3), 
      .i_recct_ia_rdata_part4           (recct_ia_rdata.r.part4), 
      .i_recct_ia_rdata_part5           (recct_ia_rdata.r.part5), 
      .i_recct_ia_rdata_part6           (recct_ia_rdata.r.part6), 
      .i_recct_ia_rdata_part7           (recct_ia_rdata.r.part7), 
      .i_recct_ia_rdata_part8           (recct_ia_rdata.r.part8), 
      .i_recct_ia_rdata_part9           (recct_ia_rdata.r.part9), 
      .i_recct_ia_rdata_part10          (recct_ia_rdata.r.part10), 
      .i_recct_ia_rdata_part11          (recct_ia_rdata.r.part11), 
      .i_recct_ia_rdata_part12          (recct_ia_rdata.r.part12), 
      .i_recct_ia_rdata_part13          (recct_ia_rdata.r.part13), 
      .i_recct_ia_rdata_part14          (recct_ia_rdata.r.part14), 
      .i_recct_ia_rdata_part15          (recct_ia_rdata.r.part15), 
      .i_recct_ia_rdata_part16          (recct_ia_rdata.r.part16), 
      .i_recct_ia_rdata_part17          (recct_ia_rdata.r.part17), 
      .i_recct_ia_rdata_part18          (recct_ia_rdata.r.part18), 
      .i_recct_ia_rdata_part19          (recct_ia_rdata.r.part19), 
      .i_recct_ia_rdata_part20          (recct_ia_rdata.r.part20), 
      .i_recct_ia_rdata_part21          (recct_ia_rdata.r.part21), 
      .i_recct_ia_rdata_part22          (recct_ia_rdata.r.part22), 
      .i_recct_ia_rdata_part23          (recct_ia_rdata.r.part23), 
      .i_recct_ia_rdata_part24          (recct_ia_rdata.r.part24), 
      .i_recct_ia_rdata_part25          (recct_ia_rdata.r.part25), 
      .i_recct_ia_rdata_part26          (recct_ia_rdata.r.part26), 
      .i_recct_ia_rdata_part27          (recct_ia_rdata.r.part27), 
      .i_recct_ia_rdata_part28          (recct_ia_rdata.r.part28), 
      .i_recct_ia_rdata_part29          (recct_ia_rdata.r.part29), 
      .i_recct_ia_rdata_part30          (recct_ia_rdata.r.part30), 
      .i_recct_ia_rdata_part31          (recct_ia_rdata.r.part31), 
      .i_psr_ia_capability              (psr_ia_capability),     
      .i_psr_ia_status                  (psr_ia_status),         
      .i_psr_ia_rdata_part0             (psr_ia_rdata.r.part0),  
      .i_bimc_monitor                   (i_bimc_monitor),        
      .i_bimc_ecc_uncorrectable_error_cnt(i_bimc_ecc_uncorrectable_error_cnt), 
      .i_bimc_ecc_correctable_error_cnt (i_bimc_ecc_correctable_error_cnt), 
      .i_bimc_parity_error_cnt          (i_bimc_parity_error_cnt), 
      .i_bimc_global_config             (i_bimc_global_config),  
      .i_bimc_memid                     (i_bimc_memid),          
      .i_bimc_eccpar_debug              (i_bimc_eccpar_debug),   
      .i_bimc_cmd2                      (i_bimc_cmd2),           
      .i_bimc_rxcmd2                    (i_bimc_rxcmd2),         
      .i_bimc_rxcmd1                    (i_bimc_rxcmd1),         
      .i_bimc_rxcmd0                    (i_bimc_rxcmd0),         
      .i_bimc_rxrsp2                    (i_bimc_rxrsp2),         
      .i_bimc_rxrsp1                    (i_bimc_rxrsp1),         
      .i_bimc_rxrsp0                    (i_bimc_rxrsp0),         
      .i_bimc_pollrsp2                  (i_bimc_pollrsp2),       
      .i_bimc_pollrsp1                  (i_bimc_pollrsp1),       
      .i_bimc_pollrsp0                  (i_bimc_pollrsp0),       
      .i_bimc_dbgcmd2                   (i_bimc_dbgcmd2),        
      .i_bimc_dbgcmd1                   (i_bimc_dbgcmd1),        
      .i_bimc_dbgcmd0                   (i_bimc_dbgcmd0));       

   
   
   
   nx_rbus_ring 
     #(.N_RBUS_ADDR_BITS (`N_RBUS_ADDR_BITS),             
       .N_LOCL_ADDR_BITS (`CR_PREFIX_WIDTH),           
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










