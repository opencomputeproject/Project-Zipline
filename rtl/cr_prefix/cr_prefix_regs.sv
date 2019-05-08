/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











`include "cr_prefix.vh"




module cr_prefix_regs (
  input                                         clk,
  input                                         i_reset_,
  input                                         i_sw_init,

  
  input      [`CR_PREFIX_DECL]                  i_addr,
  input                                         i_wr_strb,
  input      [31:0]                             i_wr_data,
  input                                         i_rd_strb,
  output     [31:0]                             o_rd_data,
  output                                        o_ack,
  output                                        o_err_ack,

  
  output     [`CR_PREFIX_C_SPARE_T_DECL]        o_spare_config,
  output     [`CR_PREFIX_C_PREFIX_REC_US_CTRL_T_DECL] o_regs_rec_us_ctrl,
  output     [`CR_PREFIX_C_PREFIX_DEBUG_CONTROL_T_DECL] o_regs_rec_debug_control,
  output     [`CR_PREFIX_C_PREFIX_BREAKPOINT_ADDR_T_DECL] o_regs_breakpoint_addr,
  output     [`CR_PREFIX_C_PREFIX_BREAKPOINT_CONT_T_DECL] o_regs_breakpoint_cont,
  output     [`CR_PREFIX_C_PREFIX_BREAKPOINT_STEP_T_DECL] o_regs_breakpoint_step,
  output     [`CR_PREFIX_C_PREFIX_ERROR_CONTROL_T_DECL] o_regs_error_control,
  output     [`CR_PREFIX_C_REGS_TLV_PARSE_ACTION_31_0_T_DECL] o_regs_tlv_parse_action_0,
  output     [`CR_PREFIX_C_REGS_TLV_PARSE_ACTION_63_32_T_DECL] o_regs_tlv_parse_action_1,
  output     [`CR_PREFIX_C_FEATURE_PART0_T_DECL] o_feature_ia_wdata_part0,
  output     [`CR_PREFIX_C_FEATURE_PART1_T_DECL] o_feature_ia_wdata_part1,
  output     [`CR_PREFIX_C_FEATURE_IA_CONFIG_T_DECL] o_feature_ia_config,
  output     [`CR_PREFIX_C_FEATURE_CTR_T_DECL]  o_feature_ctr_ia_wdata_part0,
  output     [`CR_PREFIX_C_FEATURE_CTR_IA_CONFIG_T_DECL] o_feature_ctr_ia_config,
  output     [`CR_PREFIX_C_REC_INST_T_DECL]     o_recim_ia_wdata_part0,
  output     [`CR_PREFIX_C_RECIM_IA_CONFIG_T_DECL] o_recim_ia_config,
  output     [`CR_PREFIX_C_REC_SAT_PART0_T_DECL] o_recsat_ia_wdata_part0,
  output     [`CR_PREFIX_C_REC_SAT_PART1_T_DECL] o_recsat_ia_wdata_part1,
  output     [`CR_PREFIX_C_REC_SAT_PART2_T_DECL] o_recsat_ia_wdata_part2,
  output     [`CR_PREFIX_C_REC_SAT_PART3_T_DECL] o_recsat_ia_wdata_part3,
  output     [`CR_PREFIX_C_REC_SAT_PART4_T_DECL] o_recsat_ia_wdata_part4,
  output     [`CR_PREFIX_C_REC_SAT_PART5_T_DECL] o_recsat_ia_wdata_part5,
  output     [`CR_PREFIX_C_REC_SAT_PART6_T_DECL] o_recsat_ia_wdata_part6,
  output     [`CR_PREFIX_C_REC_SAT_PART7_T_DECL] o_recsat_ia_wdata_part7,
  output     [`CR_PREFIX_C_REC_SAT_PART8_T_DECL] o_recsat_ia_wdata_part8,
  output     [`CR_PREFIX_C_REC_SAT_PART9_T_DECL] o_recsat_ia_wdata_part9,
  output     [`CR_PREFIX_C_REC_SAT_PART10_T_DECL] o_recsat_ia_wdata_part10,
  output     [`CR_PREFIX_C_REC_SAT_PART11_T_DECL] o_recsat_ia_wdata_part11,
  output     [`CR_PREFIX_C_REC_SAT_PART12_T_DECL] o_recsat_ia_wdata_part12,
  output     [`CR_PREFIX_C_REC_SAT_PART13_T_DECL] o_recsat_ia_wdata_part13,
  output     [`CR_PREFIX_C_REC_SAT_PART14_T_DECL] o_recsat_ia_wdata_part14,
  output     [`CR_PREFIX_C_REC_SAT_PART15_T_DECL] o_recsat_ia_wdata_part15,
  output     [`CR_PREFIX_C_REC_SAT_PART16_T_DECL] o_recsat_ia_wdata_part16,
  output     [`CR_PREFIX_C_REC_SAT_PART17_T_DECL] o_recsat_ia_wdata_part17,
  output     [`CR_PREFIX_C_REC_SAT_PART18_T_DECL] o_recsat_ia_wdata_part18,
  output     [`CR_PREFIX_C_REC_SAT_PART19_T_DECL] o_recsat_ia_wdata_part19,
  output     [`CR_PREFIX_C_REC_SAT_PART20_T_DECL] o_recsat_ia_wdata_part20,
  output     [`CR_PREFIX_C_REC_SAT_PART21_T_DECL] o_recsat_ia_wdata_part21,
  output     [`CR_PREFIX_C_REC_SAT_PART22_T_DECL] o_recsat_ia_wdata_part22,
  output     [`CR_PREFIX_C_REC_SAT_PART23_T_DECL] o_recsat_ia_wdata_part23,
  output     [`CR_PREFIX_C_REC_SAT_PART24_T_DECL] o_recsat_ia_wdata_part24,
  output     [`CR_PREFIX_C_REC_SAT_PART25_T_DECL] o_recsat_ia_wdata_part25,
  output     [`CR_PREFIX_C_REC_SAT_PART26_T_DECL] o_recsat_ia_wdata_part26,
  output     [`CR_PREFIX_C_REC_SAT_PART27_T_DECL] o_recsat_ia_wdata_part27,
  output     [`CR_PREFIX_C_REC_SAT_PART28_T_DECL] o_recsat_ia_wdata_part28,
  output     [`CR_PREFIX_C_REC_SAT_PART29_T_DECL] o_recsat_ia_wdata_part29,
  output     [`CR_PREFIX_C_REC_SAT_PART30_T_DECL] o_recsat_ia_wdata_part30,
  output     [`CR_PREFIX_C_REC_SAT_PART31_T_DECL] o_recsat_ia_wdata_part31,
  output     [`CR_PREFIX_C_RECSAT_IA_CONFIG_T_DECL] o_recsat_ia_config,
  output     [`CR_PREFIX_C_REC_CT_PART0_T_DECL] o_recct_ia_wdata_part0,
  output     [`CR_PREFIX_C_REC_CT_PART1_T_DECL] o_recct_ia_wdata_part1,
  output     [`CR_PREFIX_C_REC_CT_PART2_T_DECL] o_recct_ia_wdata_part2,
  output     [`CR_PREFIX_C_REC_CT_PART3_T_DECL] o_recct_ia_wdata_part3,
  output     [`CR_PREFIX_C_REC_CT_PART4_T_DECL] o_recct_ia_wdata_part4,
  output     [`CR_PREFIX_C_REC_CT_PART5_T_DECL] o_recct_ia_wdata_part5,
  output     [`CR_PREFIX_C_REC_CT_PART6_T_DECL] o_recct_ia_wdata_part6,
  output     [`CR_PREFIX_C_REC_CT_PART7_T_DECL] o_recct_ia_wdata_part7,
  output     [`CR_PREFIX_C_REC_CT_PART8_T_DECL] o_recct_ia_wdata_part8,
  output     [`CR_PREFIX_C_REC_CT_PART9_T_DECL] o_recct_ia_wdata_part9,
  output     [`CR_PREFIX_C_REC_CT_PART10_T_DECL] o_recct_ia_wdata_part10,
  output     [`CR_PREFIX_C_REC_CT_PART11_T_DECL] o_recct_ia_wdata_part11,
  output     [`CR_PREFIX_C_REC_CT_PART12_T_DECL] o_recct_ia_wdata_part12,
  output     [`CR_PREFIX_C_REC_CT_PART13_T_DECL] o_recct_ia_wdata_part13,
  output     [`CR_PREFIX_C_REC_CT_PART14_T_DECL] o_recct_ia_wdata_part14,
  output     [`CR_PREFIX_C_REC_CT_PART15_T_DECL] o_recct_ia_wdata_part15,
  output     [`CR_PREFIX_C_REC_CT_PART16_T_DECL] o_recct_ia_wdata_part16,
  output     [`CR_PREFIX_C_REC_CT_PART17_T_DECL] o_recct_ia_wdata_part17,
  output     [`CR_PREFIX_C_REC_CT_PART18_T_DECL] o_recct_ia_wdata_part18,
  output     [`CR_PREFIX_C_REC_CT_PART19_T_DECL] o_recct_ia_wdata_part19,
  output     [`CR_PREFIX_C_REC_CT_PART20_T_DECL] o_recct_ia_wdata_part20,
  output     [`CR_PREFIX_C_REC_CT_PART21_T_DECL] o_recct_ia_wdata_part21,
  output     [`CR_PREFIX_C_REC_CT_PART22_T_DECL] o_recct_ia_wdata_part22,
  output     [`CR_PREFIX_C_REC_CT_PART23_T_DECL] o_recct_ia_wdata_part23,
  output     [`CR_PREFIX_C_REC_CT_PART24_T_DECL] o_recct_ia_wdata_part24,
  output     [`CR_PREFIX_C_REC_CT_PART25_T_DECL] o_recct_ia_wdata_part25,
  output     [`CR_PREFIX_C_REC_CT_PART26_T_DECL] o_recct_ia_wdata_part26,
  output     [`CR_PREFIX_C_REC_CT_PART27_T_DECL] o_recct_ia_wdata_part27,
  output     [`CR_PREFIX_C_REC_CT_PART28_T_DECL] o_recct_ia_wdata_part28,
  output     [`CR_PREFIX_C_REC_CT_PART29_T_DECL] o_recct_ia_wdata_part29,
  output     [`CR_PREFIX_C_REC_CT_PART30_T_DECL] o_recct_ia_wdata_part30,
  output     [`CR_PREFIX_C_REC_CT_PART31_T_DECL] o_recct_ia_wdata_part31,
  output     [`CR_PREFIX_C_RECCT_IA_CONFIG_T_DECL] o_recct_ia_config,
  output     [`CR_PREFIX_C_PSR_T_DECL]          o_psr_ia_wdata_part0,
  output     [`CR_PREFIX_C_PSR_IA_CONFIG_T_DECL] o_psr_ia_config,
  output     [`CR_PREFIX_C_BIMC_MONITOR_MASK_T_DECL] o_bimc_monitor_mask,
  output     [`CR_PREFIX_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_uncorrectable_error_cnt,
  output     [`CR_PREFIX_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_correctable_error_cnt,
  output     [`CR_PREFIX_C_BIMC_PARITY_ERROR_CNT_T_DECL] o_bimc_parity_error_cnt,
  output     [`CR_PREFIX_C_BIMC_GLOBAL_CONFIG_T_DECL] o_bimc_global_config,
  output     [`CR_PREFIX_C_BIMC_ECCPAR_DEBUG_T_DECL] o_bimc_eccpar_debug,
  output     [`CR_PREFIX_C_BIMC_CMD2_T_DECL]    o_bimc_cmd2,
  output     [`CR_PREFIX_C_BIMC_CMD1_T_DECL]    o_bimc_cmd1,
  output     [`CR_PREFIX_C_BIMC_CMD0_T_DECL]    o_bimc_cmd0,
  output     [`CR_PREFIX_C_BIMC_RXCMD2_T_DECL]  o_bimc_rxcmd2,
  output     [`CR_PREFIX_C_BIMC_RXRSP2_T_DECL]  o_bimc_rxrsp2,
  output     [`CR_PREFIX_C_BIMC_POLLRSP2_T_DECL] o_bimc_pollrsp2,
  output     [`CR_PREFIX_C_BIMC_DBGCMD2_T_DECL] o_bimc_dbgcmd2,

  
  input      [`CR_PREFIX_C_REVID_T_DECL]        i_revision_config,
  input      [`CR_PREFIX_C_SPARE_T_DECL]        i_spare_config,
  input      [`CR_PREFIX_C_PREFIX_REC_US_CTRL_T_DECL] i_regs_rec_us_ctrl,
  input      [`CR_PREFIX_C_PREFIX_DEBUG_CONTROL_T_DECL] i_regs_rec_debug_control,
  input      [`CR_PREFIX_C_PREFIX_BREAKPOINT_ADDR_T_DECL] i_regs_breakpoint_addr,
  input      [`CR_PREFIX_C_PREFIX_BREAKPOINT_CONT_T_DECL] i_regs_breakpoint_cont,
  input      [`CR_PREFIX_C_PREFIX_BREAKPOINT_STEP_T_DECL] i_regs_breakpoint_step,
  input      [`CR_PREFIX_C_PREFIX_DEBUG_STATUS_T_DECL] i_rec_debug_status,
  input      [`CR_PREFIX_C_PREFIX_ERROR_CONTROL_T_DECL] i_regs_error_control,
  input      [`CR_PREFIX_C_FEATURE_IA_CAPABILITY_T_DECL] i_feature_ia_capability,
  input      [`CR_PREFIX_C_FEATURE_IA_STATUS_T_DECL] i_feature_ia_status,
  input      [`CR_PREFIX_C_FEATURE_PART0_T_DECL] i_feature_ia_rdata_part0,
  input      [`CR_PREFIX_C_FEATURE_PART1_T_DECL] i_feature_ia_rdata_part1,
  input      [`CR_PREFIX_C_FEATURE_CTR_IA_CAPABILITY_T_DECL] i_feature_ctr_ia_capability,
  input      [`CR_PREFIX_C_FEATURE_CTR_IA_STATUS_T_DECL] i_feature_ctr_ia_status,
  input      [`CR_PREFIX_C_FEATURE_CTR_T_DECL]  i_feature_ctr_ia_rdata_part0,
  input      [`CR_PREFIX_C_RECIM_IA_CAPABILITY_T_DECL] i_recim_ia_capability,
  input      [`CR_PREFIX_C_RECIM_IA_STATUS_T_DECL] i_recim_ia_status,
  input      [`CR_PREFIX_C_REC_INST_T_DECL]     i_recim_ia_rdata_part0,
  input      [`CR_PREFIX_C_RECSAT_IA_CAPABILITY_T_DECL] i_recsat_ia_capability,
  input      [`CR_PREFIX_C_RECSAT_IA_STATUS_T_DECL] i_recsat_ia_status,
  input      [`CR_PREFIX_C_REC_SAT_PART0_T_DECL] i_recsat_ia_rdata_part0,
  input      [`CR_PREFIX_C_REC_SAT_PART1_T_DECL] i_recsat_ia_rdata_part1,
  input      [`CR_PREFIX_C_REC_SAT_PART2_T_DECL] i_recsat_ia_rdata_part2,
  input      [`CR_PREFIX_C_REC_SAT_PART3_T_DECL] i_recsat_ia_rdata_part3,
  input      [`CR_PREFIX_C_REC_SAT_PART4_T_DECL] i_recsat_ia_rdata_part4,
  input      [`CR_PREFIX_C_REC_SAT_PART5_T_DECL] i_recsat_ia_rdata_part5,
  input      [`CR_PREFIX_C_REC_SAT_PART6_T_DECL] i_recsat_ia_rdata_part6,
  input      [`CR_PREFIX_C_REC_SAT_PART7_T_DECL] i_recsat_ia_rdata_part7,
  input      [`CR_PREFIX_C_REC_SAT_PART8_T_DECL] i_recsat_ia_rdata_part8,
  input      [`CR_PREFIX_C_REC_SAT_PART9_T_DECL] i_recsat_ia_rdata_part9,
  input      [`CR_PREFIX_C_REC_SAT_PART10_T_DECL] i_recsat_ia_rdata_part10,
  input      [`CR_PREFIX_C_REC_SAT_PART11_T_DECL] i_recsat_ia_rdata_part11,
  input      [`CR_PREFIX_C_REC_SAT_PART12_T_DECL] i_recsat_ia_rdata_part12,
  input      [`CR_PREFIX_C_REC_SAT_PART13_T_DECL] i_recsat_ia_rdata_part13,
  input      [`CR_PREFIX_C_REC_SAT_PART14_T_DECL] i_recsat_ia_rdata_part14,
  input      [`CR_PREFIX_C_REC_SAT_PART15_T_DECL] i_recsat_ia_rdata_part15,
  input      [`CR_PREFIX_C_REC_SAT_PART16_T_DECL] i_recsat_ia_rdata_part16,
  input      [`CR_PREFIX_C_REC_SAT_PART17_T_DECL] i_recsat_ia_rdata_part17,
  input      [`CR_PREFIX_C_REC_SAT_PART18_T_DECL] i_recsat_ia_rdata_part18,
  input      [`CR_PREFIX_C_REC_SAT_PART19_T_DECL] i_recsat_ia_rdata_part19,
  input      [`CR_PREFIX_C_REC_SAT_PART20_T_DECL] i_recsat_ia_rdata_part20,
  input      [`CR_PREFIX_C_REC_SAT_PART21_T_DECL] i_recsat_ia_rdata_part21,
  input      [`CR_PREFIX_C_REC_SAT_PART22_T_DECL] i_recsat_ia_rdata_part22,
  input      [`CR_PREFIX_C_REC_SAT_PART23_T_DECL] i_recsat_ia_rdata_part23,
  input      [`CR_PREFIX_C_REC_SAT_PART24_T_DECL] i_recsat_ia_rdata_part24,
  input      [`CR_PREFIX_C_REC_SAT_PART25_T_DECL] i_recsat_ia_rdata_part25,
  input      [`CR_PREFIX_C_REC_SAT_PART26_T_DECL] i_recsat_ia_rdata_part26,
  input      [`CR_PREFIX_C_REC_SAT_PART27_T_DECL] i_recsat_ia_rdata_part27,
  input      [`CR_PREFIX_C_REC_SAT_PART28_T_DECL] i_recsat_ia_rdata_part28,
  input      [`CR_PREFIX_C_REC_SAT_PART29_T_DECL] i_recsat_ia_rdata_part29,
  input      [`CR_PREFIX_C_REC_SAT_PART30_T_DECL] i_recsat_ia_rdata_part30,
  input      [`CR_PREFIX_C_REC_SAT_PART31_T_DECL] i_recsat_ia_rdata_part31,
  input      [`CR_PREFIX_C_RECCT_IA_CAPABILITY_T_DECL] i_recct_ia_capability,
  input      [`CR_PREFIX_C_RECCT_IA_STATUS_T_DECL] i_recct_ia_status,
  input      [`CR_PREFIX_C_REC_CT_PART0_T_DECL] i_recct_ia_rdata_part0,
  input      [`CR_PREFIX_C_REC_CT_PART1_T_DECL] i_recct_ia_rdata_part1,
  input      [`CR_PREFIX_C_REC_CT_PART2_T_DECL] i_recct_ia_rdata_part2,
  input      [`CR_PREFIX_C_REC_CT_PART3_T_DECL] i_recct_ia_rdata_part3,
  input      [`CR_PREFIX_C_REC_CT_PART4_T_DECL] i_recct_ia_rdata_part4,
  input      [`CR_PREFIX_C_REC_CT_PART5_T_DECL] i_recct_ia_rdata_part5,
  input      [`CR_PREFIX_C_REC_CT_PART6_T_DECL] i_recct_ia_rdata_part6,
  input      [`CR_PREFIX_C_REC_CT_PART7_T_DECL] i_recct_ia_rdata_part7,
  input      [`CR_PREFIX_C_REC_CT_PART8_T_DECL] i_recct_ia_rdata_part8,
  input      [`CR_PREFIX_C_REC_CT_PART9_T_DECL] i_recct_ia_rdata_part9,
  input      [`CR_PREFIX_C_REC_CT_PART10_T_DECL] i_recct_ia_rdata_part10,
  input      [`CR_PREFIX_C_REC_CT_PART11_T_DECL] i_recct_ia_rdata_part11,
  input      [`CR_PREFIX_C_REC_CT_PART12_T_DECL] i_recct_ia_rdata_part12,
  input      [`CR_PREFIX_C_REC_CT_PART13_T_DECL] i_recct_ia_rdata_part13,
  input      [`CR_PREFIX_C_REC_CT_PART14_T_DECL] i_recct_ia_rdata_part14,
  input      [`CR_PREFIX_C_REC_CT_PART15_T_DECL] i_recct_ia_rdata_part15,
  input      [`CR_PREFIX_C_REC_CT_PART16_T_DECL] i_recct_ia_rdata_part16,
  input      [`CR_PREFIX_C_REC_CT_PART17_T_DECL] i_recct_ia_rdata_part17,
  input      [`CR_PREFIX_C_REC_CT_PART18_T_DECL] i_recct_ia_rdata_part18,
  input      [`CR_PREFIX_C_REC_CT_PART19_T_DECL] i_recct_ia_rdata_part19,
  input      [`CR_PREFIX_C_REC_CT_PART20_T_DECL] i_recct_ia_rdata_part20,
  input      [`CR_PREFIX_C_REC_CT_PART21_T_DECL] i_recct_ia_rdata_part21,
  input      [`CR_PREFIX_C_REC_CT_PART22_T_DECL] i_recct_ia_rdata_part22,
  input      [`CR_PREFIX_C_REC_CT_PART23_T_DECL] i_recct_ia_rdata_part23,
  input      [`CR_PREFIX_C_REC_CT_PART24_T_DECL] i_recct_ia_rdata_part24,
  input      [`CR_PREFIX_C_REC_CT_PART25_T_DECL] i_recct_ia_rdata_part25,
  input      [`CR_PREFIX_C_REC_CT_PART26_T_DECL] i_recct_ia_rdata_part26,
  input      [`CR_PREFIX_C_REC_CT_PART27_T_DECL] i_recct_ia_rdata_part27,
  input      [`CR_PREFIX_C_REC_CT_PART28_T_DECL] i_recct_ia_rdata_part28,
  input      [`CR_PREFIX_C_REC_CT_PART29_T_DECL] i_recct_ia_rdata_part29,
  input      [`CR_PREFIX_C_REC_CT_PART30_T_DECL] i_recct_ia_rdata_part30,
  input      [`CR_PREFIX_C_REC_CT_PART31_T_DECL] i_recct_ia_rdata_part31,
  input      [`CR_PREFIX_C_PSR_IA_CAPABILITY_T_DECL] i_psr_ia_capability,
  input      [`CR_PREFIX_C_PSR_IA_STATUS_T_DECL] i_psr_ia_status,
  input      [`CR_PREFIX_C_PSR_T_DECL]          i_psr_ia_rdata_part0,
  input      [`CR_PREFIX_C_BIMC_MONITOR_T_DECL] i_bimc_monitor,
  input      [`CR_PREFIX_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_uncorrectable_error_cnt,
  input      [`CR_PREFIX_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_correctable_error_cnt,
  input      [`CR_PREFIX_C_BIMC_PARITY_ERROR_CNT_T_DECL] i_bimc_parity_error_cnt,
  input      [`CR_PREFIX_C_BIMC_GLOBAL_CONFIG_T_DECL] i_bimc_global_config,
  input      [`CR_PREFIX_C_BIMC_MEMID_T_DECL]   i_bimc_memid,
  input      [`CR_PREFIX_C_BIMC_ECCPAR_DEBUG_T_DECL] i_bimc_eccpar_debug,
  input      [`CR_PREFIX_C_BIMC_CMD2_T_DECL]    i_bimc_cmd2,
  input      [`CR_PREFIX_C_BIMC_RXCMD2_T_DECL]  i_bimc_rxcmd2,
  input      [`CR_PREFIX_C_BIMC_RXCMD1_T_DECL]  i_bimc_rxcmd1,
  input      [`CR_PREFIX_C_BIMC_RXCMD0_T_DECL]  i_bimc_rxcmd0,
  input      [`CR_PREFIX_C_BIMC_RXRSP2_T_DECL]  i_bimc_rxrsp2,
  input      [`CR_PREFIX_C_BIMC_RXRSP1_T_DECL]  i_bimc_rxrsp1,
  input      [`CR_PREFIX_C_BIMC_RXRSP0_T_DECL]  i_bimc_rxrsp0,
  input      [`CR_PREFIX_C_BIMC_POLLRSP2_T_DECL] i_bimc_pollrsp2,
  input      [`CR_PREFIX_C_BIMC_POLLRSP1_T_DECL] i_bimc_pollrsp1,
  input      [`CR_PREFIX_C_BIMC_POLLRSP0_T_DECL] i_bimc_pollrsp0,
  input      [`CR_PREFIX_C_BIMC_DBGCMD2_T_DECL] i_bimc_dbgcmd2,
  input      [`CR_PREFIX_C_BIMC_DBGCMD1_T_DECL] i_bimc_dbgcmd1,
  input      [`CR_PREFIX_C_BIMC_DBGCMD0_T_DECL] i_bimc_dbgcmd0,

  
  output reg                                    o_reg_written,
  output reg                                    o_reg_read,
  output     [31:0]                             o_reg_wr_data,
  output reg [`CR_PREFIX_DECL]                  o_reg_addr
  );


  


  
  


  
  wire [`CR_PREFIX_DECL] ws_read_addr    = o_reg_addr;
  wire [`CR_PREFIX_DECL] ws_addr         = o_reg_addr;
  

  wire n_wr_strobe = i_wr_strb;
  wire n_rd_strobe = i_rd_strb;

  wire w_32b_aligned    = (o_reg_addr[1:0] == 2'h0);

  wire w_valid_rd_addr     = (w_32b_aligned && (ws_addr >= `CR_PREFIX_REVISION_CONFIG) && (ws_addr <= `CR_PREFIX_REGS_ERROR_CONTROL))
                          || (w_32b_aligned && (ws_addr >= `CR_PREFIX_REGS_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_PREFIX_PSR_IA_RDATA_PART0))
                          || (w_32b_aligned && (ws_addr >= `CR_PREFIX_BIMC_MONITOR) && (ws_addr <= `CR_PREFIX_BIMC_DBGCMD0));

  wire w_valid_wr_addr     = (w_32b_aligned && (ws_addr >= `CR_PREFIX_REVISION_CONFIG) && (ws_addr <= `CR_PREFIX_REGS_ERROR_CONTROL))
                          || (w_32b_aligned && (ws_addr >= `CR_PREFIX_REGS_TLV_PARSE_ACTION_0) && (ws_addr <= `CR_PREFIX_PSR_IA_RDATA_PART0))
                          || (w_32b_aligned && (ws_addr >= `CR_PREFIX_BIMC_MONITOR) && (ws_addr <= `CR_PREFIX_BIMC_DBGCMD0));

  wire w_valid_addr     = w_valid_wr_addr | w_valid_rd_addr;


  parameter IDLE    = 3'h0,
            WR_PREP = 3'h1,
            WR_REG  = 3'h3,
            WAIT    = 3'h4,
            RD_PREP = 3'h5,
            RD_REG  = 3'h7;

  reg  n_write;

  always_ff @(posedge clk or negedge i_reset_) begin
    if (~i_reset_)
      n_write <= 0;
    else if (i_sw_init)
      n_write <= 0;
    else if (i_wr_strb)
      n_write <= 1;
    else if (o_ack)
      n_write <= 0;
  end

  reg  [2:0] f_state;
  reg        f_prev_do_read;


  wire       w_do_write      = ((f_state == WR_PREP));
  wire       w_do_read       = ((f_state == RD_PREP));


  

  wire [2:0] w_next_state    = n_wr_strobe                                ? WR_PREP
                             : n_rd_strobe                                ? RD_PREP
                             : f_state == WR_PREP                         ? WR_REG
                             : f_state == RD_PREP                         ? RD_REG
                             :                                              IDLE;

  wire       w_next_ack      = ((f_state == RD_PREP));

  wire       w_next_err_ack  = ((f_state == RD_PREP) & ~w_valid_rd_addr);

  reg        f_ack;
  reg        f_err_ack;

  assign o_ack      = f_ack | (f_state == WR_PREP);
  assign o_err_ack  = f_err_ack | ((f_state == WR_PREP) & ~w_valid_wr_addr);

  


  
  

  
  


  reg  [31:0]  r32_mux_0_data, f32_mux_0_data;
  reg  [31:0]  r32_mux_1_data, f32_mux_1_data;
  reg  [31:0]  r32_mux_2_data, f32_mux_2_data;
  reg  [31:0]  r32_mux_3_data, f32_mux_3_data;
  reg  [31:0]  r32_mux_4_data, f32_mux_4_data;
  reg  [31:0]  r32_mux_5_data, f32_mux_5_data;

  wire [31:0]  r32_formatted_reg_data = f32_mux_0_data
                                      | f32_mux_1_data
                                      | f32_mux_2_data
                                      | f32_mux_3_data
                                      | f32_mux_4_data
                                      | f32_mux_5_data;

  always_comb begin
    r32_mux_0_data = 0;
    r32_mux_1_data = 0;
    r32_mux_2_data = 0;
    r32_mux_3_data = 0;
    r32_mux_4_data = 0;
    r32_mux_5_data = 0;

    case (ws_read_addr)
    `CR_PREFIX_REVISION_CONFIG: begin
      r32_mux_0_data[07:00] = i_revision_config[07:00]; 
    end
    `CR_PREFIX_SPARE_CONFIG: begin
      r32_mux_0_data[31:00] = i_spare_config[31:00]; 
    end
    `CR_PREFIX_REGS_REC_US_CTRL: begin
      r32_mux_0_data[00:00] = i_regs_rec_us_ctrl[00:00]; 
      r32_mux_0_data[31:01] = i_regs_rec_us_ctrl[31:01]; 
    end
    `CR_PREFIX_REGS_REC_DEBUG_CONTROL: begin
      r32_mux_0_data[00:00] = i_regs_rec_debug_control[00:00]; 
      r32_mux_0_data[31:01] = i_regs_rec_debug_control[31:01]; 
    end
    `CR_PREFIX_REGS_BREAKPOINT_ADDR: begin
      r32_mux_0_data[07:00] = i_regs_breakpoint_addr[07:00]; 
      r32_mux_0_data[31:08] = i_regs_breakpoint_addr[31:08]; 
    end
    `CR_PREFIX_REGS_BREAKPOINT_CONT: begin
      r32_mux_0_data[00:00] = i_regs_breakpoint_cont[00:00]; 
      r32_mux_0_data[31:01] = i_regs_breakpoint_cont[31:01]; 
    end
    `CR_PREFIX_REGS_BREAKPOINT_STEP: begin
      r32_mux_0_data[00:00] = i_regs_breakpoint_step[00:00]; 
      r32_mux_0_data[31:01] = i_regs_breakpoint_step[31:01]; 
    end
    `CR_PREFIX_REC_DEBUG_STATUS: begin
      r32_mux_0_data[07:00] = i_rec_debug_status[07:00]; 
      r32_mux_0_data[08:08] = i_rec_debug_status[08:08]; 
      r32_mux_0_data[09:09] = i_rec_debug_status[09:09]; 
      r32_mux_0_data[31:10] = i_rec_debug_status[31:10]; 
    end
    `CR_PREFIX_REGS_ERROR_CONTROL: begin
      r32_mux_0_data[00:00] = i_regs_error_control[00:00]; 
      r32_mux_0_data[31:01] = i_regs_error_control[31:01]; 
    end
    `CR_PREFIX_REGS_TLV_PARSE_ACTION_0: begin
      r32_mux_0_data[01:00] = o_regs_tlv_parse_action_0[01:00]; 
      r32_mux_0_data[03:02] = o_regs_tlv_parse_action_0[03:02]; 
      r32_mux_0_data[05:04] = o_regs_tlv_parse_action_0[05:04]; 
      r32_mux_0_data[07:06] = o_regs_tlv_parse_action_0[07:06]; 
      r32_mux_0_data[09:08] = o_regs_tlv_parse_action_0[09:08]; 
      r32_mux_0_data[11:10] = o_regs_tlv_parse_action_0[11:10]; 
      r32_mux_0_data[13:12] = o_regs_tlv_parse_action_0[13:12]; 
      r32_mux_0_data[15:14] = o_regs_tlv_parse_action_0[15:14]; 
      r32_mux_0_data[17:16] = o_regs_tlv_parse_action_0[17:16]; 
      r32_mux_0_data[19:18] = o_regs_tlv_parse_action_0[19:18]; 
      r32_mux_0_data[21:20] = o_regs_tlv_parse_action_0[21:20]; 
      r32_mux_0_data[23:22] = o_regs_tlv_parse_action_0[23:22]; 
      r32_mux_0_data[25:24] = o_regs_tlv_parse_action_0[25:24]; 
      r32_mux_0_data[27:26] = o_regs_tlv_parse_action_0[27:26]; 
      r32_mux_0_data[29:28] = o_regs_tlv_parse_action_0[29:28]; 
      r32_mux_0_data[31:30] = o_regs_tlv_parse_action_0[31:30]; 
    end
    `CR_PREFIX_REGS_TLV_PARSE_ACTION_1: begin
      r32_mux_0_data[01:00] = o_regs_tlv_parse_action_1[01:00]; 
      r32_mux_0_data[03:02] = o_regs_tlv_parse_action_1[03:02]; 
      r32_mux_0_data[05:04] = o_regs_tlv_parse_action_1[05:04]; 
      r32_mux_0_data[07:06] = o_regs_tlv_parse_action_1[07:06]; 
      r32_mux_0_data[09:08] = o_regs_tlv_parse_action_1[09:08]; 
      r32_mux_0_data[11:10] = o_regs_tlv_parse_action_1[11:10]; 
      r32_mux_0_data[13:12] = o_regs_tlv_parse_action_1[13:12]; 
      r32_mux_0_data[15:14] = o_regs_tlv_parse_action_1[15:14]; 
      r32_mux_0_data[17:16] = o_regs_tlv_parse_action_1[17:16]; 
      r32_mux_0_data[19:18] = o_regs_tlv_parse_action_1[19:18]; 
      r32_mux_0_data[21:20] = o_regs_tlv_parse_action_1[21:20]; 
      r32_mux_0_data[23:22] = o_regs_tlv_parse_action_1[23:22]; 
      r32_mux_0_data[25:24] = o_regs_tlv_parse_action_1[25:24]; 
      r32_mux_0_data[27:26] = o_regs_tlv_parse_action_1[27:26]; 
      r32_mux_0_data[29:28] = o_regs_tlv_parse_action_1[29:28]; 
      r32_mux_0_data[31:30] = o_regs_tlv_parse_action_1[31:30]; 
    end
    `CR_PREFIX_FEATURE_IA_CAPABILITY: begin
      r32_mux_0_data[00:00] = i_feature_ia_capability[00:00]; 
      r32_mux_0_data[01:01] = i_feature_ia_capability[01:01]; 
      r32_mux_0_data[02:02] = i_feature_ia_capability[02:02]; 
      r32_mux_0_data[03:03] = i_feature_ia_capability[03:03]; 
      r32_mux_0_data[04:04] = i_feature_ia_capability[04:04]; 
      r32_mux_0_data[05:05] = i_feature_ia_capability[05:05]; 
      r32_mux_0_data[06:06] = i_feature_ia_capability[06:06]; 
      r32_mux_0_data[07:07] = i_feature_ia_capability[07:07]; 
      r32_mux_0_data[08:08] = i_feature_ia_capability[08:08]; 
      r32_mux_0_data[09:09] = i_feature_ia_capability[09:09]; 
      r32_mux_0_data[13:10] = i_feature_ia_capability[13:10]; 
      r32_mux_0_data[14:14] = i_feature_ia_capability[14:14]; 
      r32_mux_0_data[15:15] = i_feature_ia_capability[15:15]; 
      r32_mux_0_data[31:28] = i_feature_ia_capability[19:16]; 
    end
    `CR_PREFIX_FEATURE_IA_STATUS: begin
      r32_mux_0_data[07:00] = i_feature_ia_status[07:00]; 
      r32_mux_0_data[28:24] = i_feature_ia_status[12:08]; 
      r32_mux_0_data[31:29] = i_feature_ia_status[15:13]; 
    end
    `CR_PREFIX_FEATURE_IA_WDATA_PART0: begin
      r32_mux_0_data[07:00] = o_feature_ia_wdata_part0[07:00]; 
      r32_mux_0_data[15:08] = o_feature_ia_wdata_part0[15:08]; 
      r32_mux_0_data[23:16] = o_feature_ia_wdata_part0[23:16]; 
      r32_mux_0_data[31:24] = o_feature_ia_wdata_part0[31:24]; 
    end
    `CR_PREFIX_FEATURE_IA_WDATA_PART1: begin
      r32_mux_0_data[01:00] = o_feature_ia_wdata_part1[01:00]; 
      r32_mux_0_data[02:02] = o_feature_ia_wdata_part1[02:02]; 
      r32_mux_0_data[03:03] = o_feature_ia_wdata_part1[03:03]; 
      r32_mux_0_data[05:04] = o_feature_ia_wdata_part1[05:04]; 
      r32_mux_0_data[06:06] = o_feature_ia_wdata_part1[06:06]; 
      r32_mux_0_data[07:07] = o_feature_ia_wdata_part1[07:07]; 
      r32_mux_0_data[09:08] = o_feature_ia_wdata_part1[09:08]; 
      r32_mux_0_data[10:10] = o_feature_ia_wdata_part1[10:10]; 
      r32_mux_0_data[11:11] = o_feature_ia_wdata_part1[11:11]; 
      r32_mux_0_data[13:12] = o_feature_ia_wdata_part1[13:12]; 
      r32_mux_0_data[14:14] = o_feature_ia_wdata_part1[14:14]; 
      r32_mux_0_data[15:15] = o_feature_ia_wdata_part1[15:15]; 
      r32_mux_0_data[31:16] = o_feature_ia_wdata_part1[31:16]; 
    end
    `CR_PREFIX_FEATURE_IA_CONFIG: begin
      r32_mux_0_data[07:00] = o_feature_ia_config[07:00]; 
      r32_mux_0_data[31:28] = o_feature_ia_config[11:08]; 
    end
    `CR_PREFIX_FEATURE_IA_RDATA_PART0: begin
      r32_mux_0_data[07:00] = i_feature_ia_rdata_part0[07:00]; 
      r32_mux_0_data[15:08] = i_feature_ia_rdata_part0[15:08]; 
      r32_mux_0_data[23:16] = i_feature_ia_rdata_part0[23:16]; 
      r32_mux_0_data[31:24] = i_feature_ia_rdata_part0[31:24]; 
    end
    `CR_PREFIX_FEATURE_IA_RDATA_PART1: begin
      r32_mux_0_data[01:00] = i_feature_ia_rdata_part1[01:00]; 
      r32_mux_0_data[02:02] = i_feature_ia_rdata_part1[02:02]; 
      r32_mux_0_data[03:03] = i_feature_ia_rdata_part1[03:03]; 
      r32_mux_0_data[05:04] = i_feature_ia_rdata_part1[05:04]; 
      r32_mux_0_data[06:06] = i_feature_ia_rdata_part1[06:06]; 
      r32_mux_0_data[07:07] = i_feature_ia_rdata_part1[07:07]; 
      r32_mux_0_data[09:08] = i_feature_ia_rdata_part1[09:08]; 
      r32_mux_0_data[10:10] = i_feature_ia_rdata_part1[10:10]; 
      r32_mux_0_data[11:11] = i_feature_ia_rdata_part1[11:11]; 
      r32_mux_0_data[13:12] = i_feature_ia_rdata_part1[13:12]; 
      r32_mux_0_data[14:14] = i_feature_ia_rdata_part1[14:14]; 
      r32_mux_0_data[15:15] = i_feature_ia_rdata_part1[15:15]; 
      r32_mux_0_data[31:16] = i_feature_ia_rdata_part1[31:16]; 
    end
    `CR_PREFIX_FEATURE_CTR_IA_CAPABILITY: begin
      r32_mux_0_data[00:00] = i_feature_ctr_ia_capability[00:00]; 
      r32_mux_0_data[01:01] = i_feature_ctr_ia_capability[01:01]; 
      r32_mux_0_data[02:02] = i_feature_ctr_ia_capability[02:02]; 
      r32_mux_0_data[03:03] = i_feature_ctr_ia_capability[03:03]; 
      r32_mux_0_data[04:04] = i_feature_ctr_ia_capability[04:04]; 
      r32_mux_0_data[05:05] = i_feature_ctr_ia_capability[05:05]; 
      r32_mux_0_data[06:06] = i_feature_ctr_ia_capability[06:06]; 
      r32_mux_0_data[07:07] = i_feature_ctr_ia_capability[07:07]; 
      r32_mux_0_data[08:08] = i_feature_ctr_ia_capability[08:08]; 
      r32_mux_0_data[09:09] = i_feature_ctr_ia_capability[09:09]; 
      r32_mux_0_data[13:10] = i_feature_ctr_ia_capability[13:10]; 
      r32_mux_0_data[14:14] = i_feature_ctr_ia_capability[14:14]; 
      r32_mux_0_data[15:15] = i_feature_ctr_ia_capability[15:15]; 
      r32_mux_0_data[31:28] = i_feature_ctr_ia_capability[19:16]; 
    end
    `CR_PREFIX_FEATURE_CTR_IA_STATUS: begin
      r32_mux_0_data[07:00] = i_feature_ctr_ia_status[07:00]; 
      r32_mux_0_data[28:24] = i_feature_ctr_ia_status[12:08]; 
      r32_mux_0_data[31:29] = i_feature_ctr_ia_status[15:13]; 
    end
    `CR_PREFIX_FEATURE_CTR_IA_WDATA_PART0: begin
      r32_mux_0_data[07:00] = o_feature_ctr_ia_wdata_part0[07:00]; 
      r32_mux_0_data[31:08] = o_feature_ctr_ia_wdata_part0[31:08]; 
    end
    `CR_PREFIX_FEATURE_CTR_IA_CONFIG: begin
      r32_mux_0_data[07:00] = o_feature_ctr_ia_config[07:00]; 
      r32_mux_0_data[31:28] = o_feature_ctr_ia_config[11:08]; 
    end
    `CR_PREFIX_FEATURE_CTR_IA_RDATA_PART0: begin
      r32_mux_0_data[07:00] = i_feature_ctr_ia_rdata_part0[07:00]; 
      r32_mux_0_data[31:08] = i_feature_ctr_ia_rdata_part0[31:08]; 
    end
    `CR_PREFIX_RECIM_IA_CAPABILITY: begin
      r32_mux_0_data[00:00] = i_recim_ia_capability[00:00]; 
      r32_mux_0_data[01:01] = i_recim_ia_capability[01:01]; 
      r32_mux_0_data[02:02] = i_recim_ia_capability[02:02]; 
      r32_mux_0_data[03:03] = i_recim_ia_capability[03:03]; 
      r32_mux_0_data[04:04] = i_recim_ia_capability[04:04]; 
      r32_mux_0_data[05:05] = i_recim_ia_capability[05:05]; 
      r32_mux_0_data[06:06] = i_recim_ia_capability[06:06]; 
      r32_mux_0_data[07:07] = i_recim_ia_capability[07:07]; 
      r32_mux_0_data[08:08] = i_recim_ia_capability[08:08]; 
      r32_mux_0_data[09:09] = i_recim_ia_capability[09:09]; 
      r32_mux_0_data[13:10] = i_recim_ia_capability[13:10]; 
      r32_mux_0_data[14:14] = i_recim_ia_capability[14:14]; 
      r32_mux_0_data[15:15] = i_recim_ia_capability[15:15]; 
      r32_mux_0_data[31:28] = i_recim_ia_capability[19:16]; 
    end
    `CR_PREFIX_RECIM_IA_STATUS: begin
      r32_mux_0_data[07:00] = i_recim_ia_status[07:00]; 
      r32_mux_0_data[28:24] = i_recim_ia_status[12:08]; 
      r32_mux_0_data[31:29] = i_recim_ia_status[15:13]; 
    end
    `CR_PREFIX_RECIM_IA_WDATA_PART0: begin
      r32_mux_0_data[00:00] = o_recim_ia_wdata_part0[00:00]; 
      r32_mux_0_data[01:01] = o_recim_ia_wdata_part0[01:01]; 
      r32_mux_0_data[09:02] = o_recim_ia_wdata_part0[09:02]; 
      r32_mux_0_data[17:10] = o_recim_ia_wdata_part0[17:10]; 
      r32_mux_0_data[21:18] = o_recim_ia_wdata_part0[21:18]; 
      r32_mux_0_data[23:22] = o_recim_ia_wdata_part0[23:22]; 
    end
    `CR_PREFIX_RECIM_IA_CONFIG: begin
      r32_mux_0_data[07:00] = o_recim_ia_config[07:00]; 
      r32_mux_0_data[31:28] = o_recim_ia_config[11:08]; 
    end
    `CR_PREFIX_RECIM_IA_RDATA_PART0: begin
      r32_mux_0_data[00:00] = i_recim_ia_rdata_part0[00:00]; 
      r32_mux_0_data[01:01] = i_recim_ia_rdata_part0[01:01]; 
      r32_mux_0_data[09:02] = i_recim_ia_rdata_part0[09:02]; 
      r32_mux_0_data[17:10] = i_recim_ia_rdata_part0[17:10]; 
      r32_mux_0_data[21:18] = i_recim_ia_rdata_part0[21:18]; 
      r32_mux_0_data[23:22] = i_recim_ia_rdata_part0[23:22]; 
    end
    `CR_PREFIX_RECSAT_IA_CAPABILITY: begin
      r32_mux_0_data[00:00] = i_recsat_ia_capability[00:00]; 
      r32_mux_0_data[01:01] = i_recsat_ia_capability[01:01]; 
      r32_mux_0_data[02:02] = i_recsat_ia_capability[02:02]; 
      r32_mux_0_data[03:03] = i_recsat_ia_capability[03:03]; 
      r32_mux_0_data[04:04] = i_recsat_ia_capability[04:04]; 
      r32_mux_0_data[05:05] = i_recsat_ia_capability[05:05]; 
      r32_mux_0_data[06:06] = i_recsat_ia_capability[06:06]; 
      r32_mux_0_data[07:07] = i_recsat_ia_capability[07:07]; 
      r32_mux_0_data[08:08] = i_recsat_ia_capability[08:08]; 
      r32_mux_0_data[09:09] = i_recsat_ia_capability[09:09]; 
      r32_mux_0_data[13:10] = i_recsat_ia_capability[13:10]; 
      r32_mux_0_data[14:14] = i_recsat_ia_capability[14:14]; 
      r32_mux_0_data[15:15] = i_recsat_ia_capability[15:15]; 
      r32_mux_0_data[31:28] = i_recsat_ia_capability[19:16]; 
    end
    `CR_PREFIX_RECSAT_IA_STATUS: begin
      r32_mux_0_data[06:00] = i_recsat_ia_status[06:00]; 
      r32_mux_0_data[28:24] = i_recsat_ia_status[11:07]; 
      r32_mux_0_data[31:29] = i_recsat_ia_status[14:12]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART0: begin
      r32_mux_0_data[31:00] = o_recsat_ia_wdata_part0[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART1: begin
      r32_mux_0_data[31:00] = o_recsat_ia_wdata_part1[31:00]; 
    end
    endcase

    case (ws_read_addr)
    `CR_PREFIX_RECSAT_IA_WDATA_PART2: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part2[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART3: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part3[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART4: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part4[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART5: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part5[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART6: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part6[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART7: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part7[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART8: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part8[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART9: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part9[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART10: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part10[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART11: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part11[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART12: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part12[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART13: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part13[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART14: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part14[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART15: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part15[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART16: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part16[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART17: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part17[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART18: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part18[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART19: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part19[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART20: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part20[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART21: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part21[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART22: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part22[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART23: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part23[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART24: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part24[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART25: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part25[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART26: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part26[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART27: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part27[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART28: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part28[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART29: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part29[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART30: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part30[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_WDATA_PART31: begin
      r32_mux_1_data[31:00] = o_recsat_ia_wdata_part31[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_CONFIG: begin
      r32_mux_1_data[06:00] = o_recsat_ia_config[06:00]; 
      r32_mux_1_data[31:28] = o_recsat_ia_config[10:07]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART0: begin
      r32_mux_1_data[31:00] = i_recsat_ia_rdata_part0[31:00]; 
    end
    endcase

    case (ws_read_addr)
    `CR_PREFIX_RECSAT_IA_RDATA_PART1: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part1[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART2: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part2[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART3: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part3[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART4: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part4[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART5: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part5[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART6: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part6[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART7: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part7[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART8: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part8[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART9: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part9[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART10: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part10[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART11: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part11[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART12: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part12[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART13: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part13[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART14: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part14[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART15: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part15[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART16: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part16[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART17: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part17[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART18: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part18[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART19: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part19[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART20: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part20[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART21: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part21[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART22: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part22[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART23: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part23[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART24: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part24[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART25: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part25[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART26: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part26[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART27: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part27[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART28: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part28[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART29: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part29[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART30: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part30[31:00]; 
    end
    `CR_PREFIX_RECSAT_IA_RDATA_PART31: begin
      r32_mux_2_data[31:00] = i_recsat_ia_rdata_part31[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_CAPABILITY: begin
      r32_mux_2_data[00:00] = i_recct_ia_capability[00:00]; 
      r32_mux_2_data[01:01] = i_recct_ia_capability[01:01]; 
      r32_mux_2_data[02:02] = i_recct_ia_capability[02:02]; 
      r32_mux_2_data[03:03] = i_recct_ia_capability[03:03]; 
      r32_mux_2_data[04:04] = i_recct_ia_capability[04:04]; 
      r32_mux_2_data[05:05] = i_recct_ia_capability[05:05]; 
      r32_mux_2_data[06:06] = i_recct_ia_capability[06:06]; 
      r32_mux_2_data[07:07] = i_recct_ia_capability[07:07]; 
      r32_mux_2_data[08:08] = i_recct_ia_capability[08:08]; 
      r32_mux_2_data[09:09] = i_recct_ia_capability[09:09]; 
      r32_mux_2_data[13:10] = i_recct_ia_capability[13:10]; 
      r32_mux_2_data[14:14] = i_recct_ia_capability[14:14]; 
      r32_mux_2_data[15:15] = i_recct_ia_capability[15:15]; 
      r32_mux_2_data[31:28] = i_recct_ia_capability[19:16]; 
    end
    endcase

    case (ws_read_addr)
    `CR_PREFIX_RECCT_IA_STATUS: begin
      r32_mux_3_data[06:00] = i_recct_ia_status[06:00]; 
      r32_mux_3_data[28:24] = i_recct_ia_status[11:07]; 
      r32_mux_3_data[31:29] = i_recct_ia_status[14:12]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART0: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part0[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART1: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part1[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART2: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part2[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART3: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part3[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART4: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part4[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART5: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part5[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART6: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part6[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART7: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part7[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART8: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part8[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART9: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part9[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART10: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part10[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART11: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part11[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART12: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part12[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART13: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part13[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART14: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part14[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART15: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part15[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART16: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part16[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART17: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part17[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART18: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part18[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART19: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part19[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART20: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part20[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART21: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part21[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART22: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part22[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART23: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part23[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART24: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part24[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART25: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part25[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART26: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part26[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART27: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part27[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART28: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part28[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART29: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part29[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_WDATA_PART30: begin
      r32_mux_3_data[31:00] = o_recct_ia_wdata_part30[31:00]; 
    end
    endcase

    case (ws_read_addr)
    `CR_PREFIX_RECCT_IA_WDATA_PART31: begin
      r32_mux_4_data[31:00] = o_recct_ia_wdata_part31[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_CONFIG: begin
      r32_mux_4_data[06:00] = o_recct_ia_config[06:00]; 
      r32_mux_4_data[31:28] = o_recct_ia_config[10:07]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART0: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part0[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART1: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part1[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART2: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part2[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART3: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part3[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART4: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part4[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART5: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part5[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART6: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part6[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART7: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part7[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART8: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part8[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART9: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part9[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART10: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part10[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART11: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part11[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART12: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part12[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART13: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part13[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART14: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part14[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART15: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part15[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART16: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part16[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART17: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part17[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART18: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part18[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART19: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part19[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART20: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part20[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART21: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part21[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART22: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part22[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART23: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part23[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART24: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part24[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART25: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part25[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART26: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part26[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART27: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part27[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART28: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part28[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART29: begin
      r32_mux_4_data[31:00] = i_recct_ia_rdata_part29[31:00]; 
    end
    endcase

    case (ws_read_addr)
    `CR_PREFIX_RECCT_IA_RDATA_PART30: begin
      r32_mux_5_data[31:00] = i_recct_ia_rdata_part30[31:00]; 
    end
    `CR_PREFIX_RECCT_IA_RDATA_PART31: begin
      r32_mux_5_data[31:00] = i_recct_ia_rdata_part31[31:00]; 
    end
    `CR_PREFIX_PSR_IA_CAPABILITY: begin
      r32_mux_5_data[00:00] = i_psr_ia_capability[00:00]; 
      r32_mux_5_data[01:01] = i_psr_ia_capability[01:01]; 
      r32_mux_5_data[02:02] = i_psr_ia_capability[02:02]; 
      r32_mux_5_data[03:03] = i_psr_ia_capability[03:03]; 
      r32_mux_5_data[04:04] = i_psr_ia_capability[04:04]; 
      r32_mux_5_data[05:05] = i_psr_ia_capability[05:05]; 
      r32_mux_5_data[06:06] = i_psr_ia_capability[06:06]; 
      r32_mux_5_data[07:07] = i_psr_ia_capability[07:07]; 
      r32_mux_5_data[08:08] = i_psr_ia_capability[08:08]; 
      r32_mux_5_data[09:09] = i_psr_ia_capability[09:09]; 
      r32_mux_5_data[13:10] = i_psr_ia_capability[13:10]; 
      r32_mux_5_data[14:14] = i_psr_ia_capability[14:14]; 
      r32_mux_5_data[15:15] = i_psr_ia_capability[15:15]; 
      r32_mux_5_data[31:28] = i_psr_ia_capability[19:16]; 
    end
    `CR_PREFIX_PSR_IA_STATUS: begin
      r32_mux_5_data[08:00] = i_psr_ia_status[08:00]; 
      r32_mux_5_data[28:24] = i_psr_ia_status[13:09]; 
      r32_mux_5_data[31:29] = i_psr_ia_status[16:14]; 
    end
    `CR_PREFIX_PSR_IA_WDATA_PART0: begin
      r32_mux_5_data[31:00] = o_psr_ia_wdata_part0[31:00]; 
    end
    `CR_PREFIX_PSR_IA_CONFIG: begin
      r32_mux_5_data[08:00] = o_psr_ia_config[08:00]; 
      r32_mux_5_data[31:28] = o_psr_ia_config[12:09]; 
    end
    `CR_PREFIX_PSR_IA_RDATA_PART0: begin
      r32_mux_5_data[31:00] = i_psr_ia_rdata_part0[31:00]; 
    end
    `CR_PREFIX_BIMC_MONITOR: begin
      r32_mux_5_data[00:00] = i_bimc_monitor[00:00]; 
      r32_mux_5_data[01:01] = i_bimc_monitor[01:01]; 
      r32_mux_5_data[02:02] = i_bimc_monitor[02:02]; 
      r32_mux_5_data[03:03] = i_bimc_monitor[03:03]; 
      r32_mux_5_data[04:04] = i_bimc_monitor[04:04]; 
      r32_mux_5_data[05:05] = i_bimc_monitor[05:05]; 
      r32_mux_5_data[06:06] = i_bimc_monitor[06:06]; 
    end
    `CR_PREFIX_BIMC_MONITOR_MASK: begin
      r32_mux_5_data[00:00] = o_bimc_monitor_mask[00:00]; 
      r32_mux_5_data[01:01] = o_bimc_monitor_mask[01:01]; 
      r32_mux_5_data[02:02] = o_bimc_monitor_mask[02:02]; 
      r32_mux_5_data[03:03] = o_bimc_monitor_mask[03:03]; 
      r32_mux_5_data[04:04] = o_bimc_monitor_mask[04:04]; 
      r32_mux_5_data[05:05] = o_bimc_monitor_mask[05:05]; 
      r32_mux_5_data[06:06] = o_bimc_monitor_mask[06:06]; 
    end
    `CR_PREFIX_BIMC_ECC_UNCORRECTABLE_ERROR_CNT: begin
      r32_mux_5_data[31:00] = i_bimc_ecc_uncorrectable_error_cnt[31:00]; 
    end
    `CR_PREFIX_BIMC_ECC_CORRECTABLE_ERROR_CNT: begin
      r32_mux_5_data[31:00] = i_bimc_ecc_correctable_error_cnt[31:00]; 
    end
    `CR_PREFIX_BIMC_PARITY_ERROR_CNT: begin
      r32_mux_5_data[31:00] = i_bimc_parity_error_cnt[31:00]; 
    end
    `CR_PREFIX_BIMC_GLOBAL_CONFIG: begin
      r32_mux_5_data[00:00] = i_bimc_global_config[00:00]; 
      r32_mux_5_data[01:01] = i_bimc_global_config[01:01]; 
      r32_mux_5_data[02:02] = i_bimc_global_config[02:02]; 
      r32_mux_5_data[03:03] = i_bimc_global_config[03:03]; 
      r32_mux_5_data[04:04] = i_bimc_global_config[04:04]; 
      r32_mux_5_data[05:05] = i_bimc_global_config[05:05]; 
      r32_mux_5_data[31:06] = i_bimc_global_config[31:06]; 
    end
    `CR_PREFIX_BIMC_MEMID: begin
      r32_mux_5_data[11:00] = i_bimc_memid[11:00]; 
    end
    `CR_PREFIX_BIMC_ECCPAR_DEBUG: begin
      r32_mux_5_data[11:00] = i_bimc_eccpar_debug[11:00]; 
      r32_mux_5_data[15:12] = i_bimc_eccpar_debug[15:12]; 
      r32_mux_5_data[17:16] = i_bimc_eccpar_debug[17:16]; 
      r32_mux_5_data[19:18] = i_bimc_eccpar_debug[19:18]; 
      r32_mux_5_data[21:20] = i_bimc_eccpar_debug[21:20]; 
      r32_mux_5_data[22:22] = i_bimc_eccpar_debug[22:22]; 
      r32_mux_5_data[23:23] = i_bimc_eccpar_debug[23:23]; 
      r32_mux_5_data[27:24] = i_bimc_eccpar_debug[27:24]; 
      r32_mux_5_data[28:28] = i_bimc_eccpar_debug[28:28]; 
    end
    `CR_PREFIX_BIMC_CMD2: begin
      r32_mux_5_data[07:00] = i_bimc_cmd2[07:00]; 
      r32_mux_5_data[08:08] = i_bimc_cmd2[08:08]; 
      r32_mux_5_data[09:09] = i_bimc_cmd2[09:09]; 
      r32_mux_5_data[10:10] = i_bimc_cmd2[10:10]; 
    end
    `CR_PREFIX_BIMC_CMD1: begin
      r32_mux_5_data[15:00] = o_bimc_cmd1[15:00]; 
      r32_mux_5_data[27:16] = o_bimc_cmd1[27:16]; 
      r32_mux_5_data[31:28] = o_bimc_cmd1[31:28]; 
    end
    `CR_PREFIX_BIMC_CMD0: begin
      r32_mux_5_data[31:00] = o_bimc_cmd0[31:00]; 
    end
    `CR_PREFIX_BIMC_RXCMD2: begin
      r32_mux_5_data[07:00] = i_bimc_rxcmd2[07:00]; 
      r32_mux_5_data[08:08] = i_bimc_rxcmd2[08:08]; 
      r32_mux_5_data[09:09] = i_bimc_rxcmd2[09:09]; 
    end
    `CR_PREFIX_BIMC_RXCMD1: begin
      r32_mux_5_data[15:00] = i_bimc_rxcmd1[15:00]; 
      r32_mux_5_data[27:16] = i_bimc_rxcmd1[27:16]; 
      r32_mux_5_data[31:28] = i_bimc_rxcmd1[31:28]; 
    end
    `CR_PREFIX_BIMC_RXCMD0: begin
      r32_mux_5_data[31:00] = i_bimc_rxcmd0[31:00]; 
    end
    `CR_PREFIX_BIMC_RXRSP2: begin
      r32_mux_5_data[07:00] = i_bimc_rxrsp2[07:00]; 
      r32_mux_5_data[08:08] = i_bimc_rxrsp2[08:08]; 
      r32_mux_5_data[09:09] = i_bimc_rxrsp2[09:09]; 
    end
    `CR_PREFIX_BIMC_RXRSP1: begin
      r32_mux_5_data[31:00] = i_bimc_rxrsp1[31:00]; 
    end
    `CR_PREFIX_BIMC_RXRSP0: begin
      r32_mux_5_data[31:00] = i_bimc_rxrsp0[31:00]; 
    end
    `CR_PREFIX_BIMC_POLLRSP2: begin
      r32_mux_5_data[07:00] = i_bimc_pollrsp2[07:00]; 
      r32_mux_5_data[08:08] = i_bimc_pollrsp2[08:08]; 
      r32_mux_5_data[09:09] = i_bimc_pollrsp2[09:09]; 
    end
    `CR_PREFIX_BIMC_POLLRSP1: begin
      r32_mux_5_data[31:00] = i_bimc_pollrsp1[31:00]; 
    end
    `CR_PREFIX_BIMC_POLLRSP0: begin
      r32_mux_5_data[31:00] = i_bimc_pollrsp0[31:00]; 
    end
    `CR_PREFIX_BIMC_DBGCMD2: begin
      r32_mux_5_data[07:00] = i_bimc_dbgcmd2[07:00]; 
      r32_mux_5_data[08:08] = i_bimc_dbgcmd2[08:08]; 
      r32_mux_5_data[09:09] = i_bimc_dbgcmd2[09:09]; 
    end
    `CR_PREFIX_BIMC_DBGCMD1: begin
      r32_mux_5_data[15:00] = i_bimc_dbgcmd1[15:00]; 
      r32_mux_5_data[27:16] = i_bimc_dbgcmd1[27:16]; 
      r32_mux_5_data[31:28] = i_bimc_dbgcmd1[31:28]; 
    end
    `CR_PREFIX_BIMC_DBGCMD0: begin
      r32_mux_5_data[31:00] = i_bimc_dbgcmd0[31:00]; 
    end
    endcase

  end

  
  

  
  

  reg  [31:0]  f32_data;

  assign o_reg_wr_data = f32_data;

  
  

  
  assign       o_rd_data  = (o_ack  & ~n_write) ? r32_formatted_reg_data : { 32 { 1'b0 } };
  

  
  

  wire w_load_spare_config                     = w_do_write & (ws_addr == `CR_PREFIX_SPARE_CONFIG);
  wire w_load_regs_rec_us_ctrl                 = w_do_write & (ws_addr == `CR_PREFIX_REGS_REC_US_CTRL);
  wire w_load_regs_rec_debug_control           = w_do_write & (ws_addr == `CR_PREFIX_REGS_REC_DEBUG_CONTROL);
  wire w_load_regs_breakpoint_addr             = w_do_write & (ws_addr == `CR_PREFIX_REGS_BREAKPOINT_ADDR);
  wire w_load_regs_breakpoint_cont             = w_do_write & (ws_addr == `CR_PREFIX_REGS_BREAKPOINT_CONT);
  wire w_load_regs_breakpoint_step             = w_do_write & (ws_addr == `CR_PREFIX_REGS_BREAKPOINT_STEP);
  wire w_load_regs_error_control               = w_do_write & (ws_addr == `CR_PREFIX_REGS_ERROR_CONTROL);
  wire w_load_regs_tlv_parse_action_0          = w_do_write & (ws_addr == `CR_PREFIX_REGS_TLV_PARSE_ACTION_0);
  wire w_load_regs_tlv_parse_action_1          = w_do_write & (ws_addr == `CR_PREFIX_REGS_TLV_PARSE_ACTION_1);
  wire w_load_feature_ia_wdata_part0           = w_do_write & (ws_addr == `CR_PREFIX_FEATURE_IA_WDATA_PART0);
  wire w_load_feature_ia_wdata_part1           = w_do_write & (ws_addr == `CR_PREFIX_FEATURE_IA_WDATA_PART1);
  wire w_load_feature_ia_config                = w_do_write & (ws_addr == `CR_PREFIX_FEATURE_IA_CONFIG);
  wire w_load_feature_ctr_ia_wdata_part0       = w_do_write & (ws_addr == `CR_PREFIX_FEATURE_CTR_IA_WDATA_PART0);
  wire w_load_feature_ctr_ia_config            = w_do_write & (ws_addr == `CR_PREFIX_FEATURE_CTR_IA_CONFIG);
  wire w_load_recim_ia_wdata_part0             = w_do_write & (ws_addr == `CR_PREFIX_RECIM_IA_WDATA_PART0);
  wire w_load_recim_ia_config                  = w_do_write & (ws_addr == `CR_PREFIX_RECIM_IA_CONFIG);
  wire w_load_recsat_ia_wdata_part0            = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART0);
  wire w_load_recsat_ia_wdata_part1            = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART1);
  wire w_load_recsat_ia_wdata_part2            = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART2);
  wire w_load_recsat_ia_wdata_part3            = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART3);
  wire w_load_recsat_ia_wdata_part4            = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART4);
  wire w_load_recsat_ia_wdata_part5            = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART5);
  wire w_load_recsat_ia_wdata_part6            = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART6);
  wire w_load_recsat_ia_wdata_part7            = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART7);
  wire w_load_recsat_ia_wdata_part8            = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART8);
  wire w_load_recsat_ia_wdata_part9            = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART9);
  wire w_load_recsat_ia_wdata_part10           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART10);
  wire w_load_recsat_ia_wdata_part11           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART11);
  wire w_load_recsat_ia_wdata_part12           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART12);
  wire w_load_recsat_ia_wdata_part13           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART13);
  wire w_load_recsat_ia_wdata_part14           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART14);
  wire w_load_recsat_ia_wdata_part15           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART15);
  wire w_load_recsat_ia_wdata_part16           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART16);
  wire w_load_recsat_ia_wdata_part17           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART17);
  wire w_load_recsat_ia_wdata_part18           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART18);
  wire w_load_recsat_ia_wdata_part19           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART19);
  wire w_load_recsat_ia_wdata_part20           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART20);
  wire w_load_recsat_ia_wdata_part21           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART21);
  wire w_load_recsat_ia_wdata_part22           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART22);
  wire w_load_recsat_ia_wdata_part23           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART23);
  wire w_load_recsat_ia_wdata_part24           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART24);
  wire w_load_recsat_ia_wdata_part25           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART25);
  wire w_load_recsat_ia_wdata_part26           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART26);
  wire w_load_recsat_ia_wdata_part27           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART27);
  wire w_load_recsat_ia_wdata_part28           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART28);
  wire w_load_recsat_ia_wdata_part29           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART29);
  wire w_load_recsat_ia_wdata_part30           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART30);
  wire w_load_recsat_ia_wdata_part31           = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_WDATA_PART31);
  wire w_load_recsat_ia_config                 = w_do_write & (ws_addr == `CR_PREFIX_RECSAT_IA_CONFIG);
  wire w_load_recct_ia_wdata_part0             = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART0);
  wire w_load_recct_ia_wdata_part1             = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART1);
  wire w_load_recct_ia_wdata_part2             = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART2);
  wire w_load_recct_ia_wdata_part3             = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART3);
  wire w_load_recct_ia_wdata_part4             = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART4);
  wire w_load_recct_ia_wdata_part5             = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART5);
  wire w_load_recct_ia_wdata_part6             = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART6);
  wire w_load_recct_ia_wdata_part7             = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART7);
  wire w_load_recct_ia_wdata_part8             = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART8);
  wire w_load_recct_ia_wdata_part9             = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART9);
  wire w_load_recct_ia_wdata_part10            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART10);
  wire w_load_recct_ia_wdata_part11            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART11);
  wire w_load_recct_ia_wdata_part12            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART12);
  wire w_load_recct_ia_wdata_part13            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART13);
  wire w_load_recct_ia_wdata_part14            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART14);
  wire w_load_recct_ia_wdata_part15            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART15);
  wire w_load_recct_ia_wdata_part16            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART16);
  wire w_load_recct_ia_wdata_part17            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART17);
  wire w_load_recct_ia_wdata_part18            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART18);
  wire w_load_recct_ia_wdata_part19            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART19);
  wire w_load_recct_ia_wdata_part20            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART20);
  wire w_load_recct_ia_wdata_part21            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART21);
  wire w_load_recct_ia_wdata_part22            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART22);
  wire w_load_recct_ia_wdata_part23            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART23);
  wire w_load_recct_ia_wdata_part24            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART24);
  wire w_load_recct_ia_wdata_part25            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART25);
  wire w_load_recct_ia_wdata_part26            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART26);
  wire w_load_recct_ia_wdata_part27            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART27);
  wire w_load_recct_ia_wdata_part28            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART28);
  wire w_load_recct_ia_wdata_part29            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART29);
  wire w_load_recct_ia_wdata_part30            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART30);
  wire w_load_recct_ia_wdata_part31            = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_WDATA_PART31);
  wire w_load_recct_ia_config                  = w_do_write & (ws_addr == `CR_PREFIX_RECCT_IA_CONFIG);
  wire w_load_psr_ia_wdata_part0               = w_do_write & (ws_addr == `CR_PREFIX_PSR_IA_WDATA_PART0);
  wire w_load_psr_ia_config                    = w_do_write & (ws_addr == `CR_PREFIX_PSR_IA_CONFIG);
  wire w_load_bimc_monitor_mask                = w_do_write & (ws_addr == `CR_PREFIX_BIMC_MONITOR_MASK);
  wire w_load_bimc_ecc_uncorrectable_error_cnt = w_do_write & (ws_addr == `CR_PREFIX_BIMC_ECC_UNCORRECTABLE_ERROR_CNT);
  wire w_load_bimc_ecc_correctable_error_cnt   = w_do_write & (ws_addr == `CR_PREFIX_BIMC_ECC_CORRECTABLE_ERROR_CNT);
  wire w_load_bimc_parity_error_cnt            = w_do_write & (ws_addr == `CR_PREFIX_BIMC_PARITY_ERROR_CNT);
  wire w_load_bimc_global_config               = w_do_write & (ws_addr == `CR_PREFIX_BIMC_GLOBAL_CONFIG);
  wire w_load_bimc_eccpar_debug                = w_do_write & (ws_addr == `CR_PREFIX_BIMC_ECCPAR_DEBUG);
  wire w_load_bimc_cmd2                        = w_do_write & (ws_addr == `CR_PREFIX_BIMC_CMD2);
  wire w_load_bimc_cmd1                        = w_do_write & (ws_addr == `CR_PREFIX_BIMC_CMD1);
  wire w_load_bimc_cmd0                        = w_do_write & (ws_addr == `CR_PREFIX_BIMC_CMD0);
  wire w_load_bimc_rxcmd2                      = w_do_write & (ws_addr == `CR_PREFIX_BIMC_RXCMD2);
  wire w_load_bimc_rxrsp2                      = w_do_write & (ws_addr == `CR_PREFIX_BIMC_RXRSP2);
  wire w_load_bimc_pollrsp2                    = w_do_write & (ws_addr == `CR_PREFIX_BIMC_POLLRSP2);
  wire w_load_bimc_dbgcmd2                     = w_do_write & (ws_addr == `CR_PREFIX_BIMC_DBGCMD2);


  


  always_ff @(posedge clk or negedge i_reset_) begin
    if(~i_reset_) begin
      
      f_state        <= IDLE;
      f_ack          <= 0;
      f_err_ack      <= 0;
      f_prev_do_read <= 0;

      o_reg_addr     <= 0;
      o_reg_written  <= 0;
      o_reg_read     <= 0;

      f32_mux_0_data <= 0;
      f32_mux_1_data <= 0;
      f32_mux_2_data <= 0;
      f32_mux_3_data <= 0;
      f32_mux_4_data <= 0;
      f32_mux_5_data <= 0;

    end
    else if(i_sw_init) begin
      
      f_state        <= IDLE;
      f_ack          <= 0;
      f_err_ack      <= 0;
      f_prev_do_read <= 0;

      o_reg_addr     <= 0;
      o_reg_written  <= 0;
      o_reg_read     <= 0;

      f32_mux_0_data <= 0;
      f32_mux_1_data <= 0;
      f32_mux_2_data <= 0;
      f32_mux_3_data <= 0;
      f32_mux_4_data <= 0;
      f32_mux_5_data <= 0;

    end
    else begin
      f_state        <= w_next_state;
      f_ack          <= w_next_ack & !i_wr_strb & !i_rd_strb;
      f_err_ack      <= w_next_err_ack;
      f_prev_do_read <= w_do_read;

      if (i_wr_strb | i_rd_strb) o_reg_addr     <= i_addr;
      o_reg_written  <= (w_do_write & w_32b_aligned & w_valid_wr_addr);
      o_reg_read     <= (w_do_read  & w_32b_aligned & w_valid_rd_addr);

      if (w_do_read)             f32_mux_0_data <= r32_mux_0_data;
      if (w_do_read)             f32_mux_1_data <= r32_mux_1_data;
      if (w_do_read)             f32_mux_2_data <= r32_mux_2_data;
      if (w_do_read)             f32_mux_3_data <= r32_mux_3_data;
      if (w_do_read)             f32_mux_4_data <= r32_mux_4_data;
      if (w_do_read)             f32_mux_5_data <= r32_mux_5_data;

    end
  end

  
  always_ff @(posedge clk) begin
    if (i_wr_strb)               f32_data       <= i_wr_data;

  end
  

  cr_prefix_regs_flops u_cr_prefix_regs_flops (
        .clk                                    ( clk ),
        .i_reset_                               ( i_reset_ ),
        .i_sw_init                              ( i_sw_init ),
        .o_spare_config                         ( o_spare_config ),
        .o_regs_rec_us_ctrl                     ( o_regs_rec_us_ctrl ),
        .o_regs_rec_debug_control               ( o_regs_rec_debug_control ),
        .o_regs_breakpoint_addr                 ( o_regs_breakpoint_addr ),
        .o_regs_breakpoint_cont                 ( o_regs_breakpoint_cont ),
        .o_regs_breakpoint_step                 ( o_regs_breakpoint_step ),
        .o_regs_error_control                   ( o_regs_error_control ),
        .o_regs_tlv_parse_action_0              ( o_regs_tlv_parse_action_0 ),
        .o_regs_tlv_parse_action_1              ( o_regs_tlv_parse_action_1 ),
        .o_feature_ia_wdata_part0               ( o_feature_ia_wdata_part0 ),
        .o_feature_ia_wdata_part1               ( o_feature_ia_wdata_part1 ),
        .o_feature_ia_config                    ( o_feature_ia_config ),
        .o_feature_ctr_ia_wdata_part0           ( o_feature_ctr_ia_wdata_part0 ),
        .o_feature_ctr_ia_config                ( o_feature_ctr_ia_config ),
        .o_recim_ia_wdata_part0                 ( o_recim_ia_wdata_part0 ),
        .o_recim_ia_config                      ( o_recim_ia_config ),
        .o_recsat_ia_wdata_part0                ( o_recsat_ia_wdata_part0 ),
        .o_recsat_ia_wdata_part1                ( o_recsat_ia_wdata_part1 ),
        .o_recsat_ia_wdata_part2                ( o_recsat_ia_wdata_part2 ),
        .o_recsat_ia_wdata_part3                ( o_recsat_ia_wdata_part3 ),
        .o_recsat_ia_wdata_part4                ( o_recsat_ia_wdata_part4 ),
        .o_recsat_ia_wdata_part5                ( o_recsat_ia_wdata_part5 ),
        .o_recsat_ia_wdata_part6                ( o_recsat_ia_wdata_part6 ),
        .o_recsat_ia_wdata_part7                ( o_recsat_ia_wdata_part7 ),
        .o_recsat_ia_wdata_part8                ( o_recsat_ia_wdata_part8 ),
        .o_recsat_ia_wdata_part9                ( o_recsat_ia_wdata_part9 ),
        .o_recsat_ia_wdata_part10               ( o_recsat_ia_wdata_part10 ),
        .o_recsat_ia_wdata_part11               ( o_recsat_ia_wdata_part11 ),
        .o_recsat_ia_wdata_part12               ( o_recsat_ia_wdata_part12 ),
        .o_recsat_ia_wdata_part13               ( o_recsat_ia_wdata_part13 ),
        .o_recsat_ia_wdata_part14               ( o_recsat_ia_wdata_part14 ),
        .o_recsat_ia_wdata_part15               ( o_recsat_ia_wdata_part15 ),
        .o_recsat_ia_wdata_part16               ( o_recsat_ia_wdata_part16 ),
        .o_recsat_ia_wdata_part17               ( o_recsat_ia_wdata_part17 ),
        .o_recsat_ia_wdata_part18               ( o_recsat_ia_wdata_part18 ),
        .o_recsat_ia_wdata_part19               ( o_recsat_ia_wdata_part19 ),
        .o_recsat_ia_wdata_part20               ( o_recsat_ia_wdata_part20 ),
        .o_recsat_ia_wdata_part21               ( o_recsat_ia_wdata_part21 ),
        .o_recsat_ia_wdata_part22               ( o_recsat_ia_wdata_part22 ),
        .o_recsat_ia_wdata_part23               ( o_recsat_ia_wdata_part23 ),
        .o_recsat_ia_wdata_part24               ( o_recsat_ia_wdata_part24 ),
        .o_recsat_ia_wdata_part25               ( o_recsat_ia_wdata_part25 ),
        .o_recsat_ia_wdata_part26               ( o_recsat_ia_wdata_part26 ),
        .o_recsat_ia_wdata_part27               ( o_recsat_ia_wdata_part27 ),
        .o_recsat_ia_wdata_part28               ( o_recsat_ia_wdata_part28 ),
        .o_recsat_ia_wdata_part29               ( o_recsat_ia_wdata_part29 ),
        .o_recsat_ia_wdata_part30               ( o_recsat_ia_wdata_part30 ),
        .o_recsat_ia_wdata_part31               ( o_recsat_ia_wdata_part31 ),
        .o_recsat_ia_config                     ( o_recsat_ia_config ),
        .o_recct_ia_wdata_part0                 ( o_recct_ia_wdata_part0 ),
        .o_recct_ia_wdata_part1                 ( o_recct_ia_wdata_part1 ),
        .o_recct_ia_wdata_part2                 ( o_recct_ia_wdata_part2 ),
        .o_recct_ia_wdata_part3                 ( o_recct_ia_wdata_part3 ),
        .o_recct_ia_wdata_part4                 ( o_recct_ia_wdata_part4 ),
        .o_recct_ia_wdata_part5                 ( o_recct_ia_wdata_part5 ),
        .o_recct_ia_wdata_part6                 ( o_recct_ia_wdata_part6 ),
        .o_recct_ia_wdata_part7                 ( o_recct_ia_wdata_part7 ),
        .o_recct_ia_wdata_part8                 ( o_recct_ia_wdata_part8 ),
        .o_recct_ia_wdata_part9                 ( o_recct_ia_wdata_part9 ),
        .o_recct_ia_wdata_part10                ( o_recct_ia_wdata_part10 ),
        .o_recct_ia_wdata_part11                ( o_recct_ia_wdata_part11 ),
        .o_recct_ia_wdata_part12                ( o_recct_ia_wdata_part12 ),
        .o_recct_ia_wdata_part13                ( o_recct_ia_wdata_part13 ),
        .o_recct_ia_wdata_part14                ( o_recct_ia_wdata_part14 ),
        .o_recct_ia_wdata_part15                ( o_recct_ia_wdata_part15 ),
        .o_recct_ia_wdata_part16                ( o_recct_ia_wdata_part16 ),
        .o_recct_ia_wdata_part17                ( o_recct_ia_wdata_part17 ),
        .o_recct_ia_wdata_part18                ( o_recct_ia_wdata_part18 ),
        .o_recct_ia_wdata_part19                ( o_recct_ia_wdata_part19 ),
        .o_recct_ia_wdata_part20                ( o_recct_ia_wdata_part20 ),
        .o_recct_ia_wdata_part21                ( o_recct_ia_wdata_part21 ),
        .o_recct_ia_wdata_part22                ( o_recct_ia_wdata_part22 ),
        .o_recct_ia_wdata_part23                ( o_recct_ia_wdata_part23 ),
        .o_recct_ia_wdata_part24                ( o_recct_ia_wdata_part24 ),
        .o_recct_ia_wdata_part25                ( o_recct_ia_wdata_part25 ),
        .o_recct_ia_wdata_part26                ( o_recct_ia_wdata_part26 ),
        .o_recct_ia_wdata_part27                ( o_recct_ia_wdata_part27 ),
        .o_recct_ia_wdata_part28                ( o_recct_ia_wdata_part28 ),
        .o_recct_ia_wdata_part29                ( o_recct_ia_wdata_part29 ),
        .o_recct_ia_wdata_part30                ( o_recct_ia_wdata_part30 ),
        .o_recct_ia_wdata_part31                ( o_recct_ia_wdata_part31 ),
        .o_recct_ia_config                      ( o_recct_ia_config ),
        .o_psr_ia_wdata_part0                   ( o_psr_ia_wdata_part0 ),
        .o_psr_ia_config                        ( o_psr_ia_config ),
        .o_bimc_monitor_mask                    ( o_bimc_monitor_mask ),
        .o_bimc_ecc_uncorrectable_error_cnt     ( o_bimc_ecc_uncorrectable_error_cnt ),
        .o_bimc_ecc_correctable_error_cnt       ( o_bimc_ecc_correctable_error_cnt ),
        .o_bimc_parity_error_cnt                ( o_bimc_parity_error_cnt ),
        .o_bimc_global_config                   ( o_bimc_global_config ),
        .o_bimc_eccpar_debug                    ( o_bimc_eccpar_debug ),
        .o_bimc_cmd2                            ( o_bimc_cmd2 ),
        .o_bimc_cmd1                            ( o_bimc_cmd1 ),
        .o_bimc_cmd0                            ( o_bimc_cmd0 ),
        .o_bimc_rxcmd2                          ( o_bimc_rxcmd2 ),
        .o_bimc_rxrsp2                          ( o_bimc_rxrsp2 ),
        .o_bimc_pollrsp2                        ( o_bimc_pollrsp2 ),
        .o_bimc_dbgcmd2                         ( o_bimc_dbgcmd2 ),
        .w_load_spare_config                    ( w_load_spare_config ),
        .w_load_regs_rec_us_ctrl                ( w_load_regs_rec_us_ctrl ),
        .w_load_regs_rec_debug_control          ( w_load_regs_rec_debug_control ),
        .w_load_regs_breakpoint_addr            ( w_load_regs_breakpoint_addr ),
        .w_load_regs_breakpoint_cont            ( w_load_regs_breakpoint_cont ),
        .w_load_regs_breakpoint_step            ( w_load_regs_breakpoint_step ),
        .w_load_regs_error_control              ( w_load_regs_error_control ),
        .w_load_regs_tlv_parse_action_0         ( w_load_regs_tlv_parse_action_0 ),
        .w_load_regs_tlv_parse_action_1         ( w_load_regs_tlv_parse_action_1 ),
        .w_load_feature_ia_wdata_part0          ( w_load_feature_ia_wdata_part0 ),
        .w_load_feature_ia_wdata_part1          ( w_load_feature_ia_wdata_part1 ),
        .w_load_feature_ia_config               ( w_load_feature_ia_config ),
        .w_load_feature_ctr_ia_wdata_part0      ( w_load_feature_ctr_ia_wdata_part0 ),
        .w_load_feature_ctr_ia_config           ( w_load_feature_ctr_ia_config ),
        .w_load_recim_ia_wdata_part0            ( w_load_recim_ia_wdata_part0 ),
        .w_load_recim_ia_config                 ( w_load_recim_ia_config ),
        .w_load_recsat_ia_wdata_part0           ( w_load_recsat_ia_wdata_part0 ),
        .w_load_recsat_ia_wdata_part1           ( w_load_recsat_ia_wdata_part1 ),
        .w_load_recsat_ia_wdata_part2           ( w_load_recsat_ia_wdata_part2 ),
        .w_load_recsat_ia_wdata_part3           ( w_load_recsat_ia_wdata_part3 ),
        .w_load_recsat_ia_wdata_part4           ( w_load_recsat_ia_wdata_part4 ),
        .w_load_recsat_ia_wdata_part5           ( w_load_recsat_ia_wdata_part5 ),
        .w_load_recsat_ia_wdata_part6           ( w_load_recsat_ia_wdata_part6 ),
        .w_load_recsat_ia_wdata_part7           ( w_load_recsat_ia_wdata_part7 ),
        .w_load_recsat_ia_wdata_part8           ( w_load_recsat_ia_wdata_part8 ),
        .w_load_recsat_ia_wdata_part9           ( w_load_recsat_ia_wdata_part9 ),
        .w_load_recsat_ia_wdata_part10          ( w_load_recsat_ia_wdata_part10 ),
        .w_load_recsat_ia_wdata_part11          ( w_load_recsat_ia_wdata_part11 ),
        .w_load_recsat_ia_wdata_part12          ( w_load_recsat_ia_wdata_part12 ),
        .w_load_recsat_ia_wdata_part13          ( w_load_recsat_ia_wdata_part13 ),
        .w_load_recsat_ia_wdata_part14          ( w_load_recsat_ia_wdata_part14 ),
        .w_load_recsat_ia_wdata_part15          ( w_load_recsat_ia_wdata_part15 ),
        .w_load_recsat_ia_wdata_part16          ( w_load_recsat_ia_wdata_part16 ),
        .w_load_recsat_ia_wdata_part17          ( w_load_recsat_ia_wdata_part17 ),
        .w_load_recsat_ia_wdata_part18          ( w_load_recsat_ia_wdata_part18 ),
        .w_load_recsat_ia_wdata_part19          ( w_load_recsat_ia_wdata_part19 ),
        .w_load_recsat_ia_wdata_part20          ( w_load_recsat_ia_wdata_part20 ),
        .w_load_recsat_ia_wdata_part21          ( w_load_recsat_ia_wdata_part21 ),
        .w_load_recsat_ia_wdata_part22          ( w_load_recsat_ia_wdata_part22 ),
        .w_load_recsat_ia_wdata_part23          ( w_load_recsat_ia_wdata_part23 ),
        .w_load_recsat_ia_wdata_part24          ( w_load_recsat_ia_wdata_part24 ),
        .w_load_recsat_ia_wdata_part25          ( w_load_recsat_ia_wdata_part25 ),
        .w_load_recsat_ia_wdata_part26          ( w_load_recsat_ia_wdata_part26 ),
        .w_load_recsat_ia_wdata_part27          ( w_load_recsat_ia_wdata_part27 ),
        .w_load_recsat_ia_wdata_part28          ( w_load_recsat_ia_wdata_part28 ),
        .w_load_recsat_ia_wdata_part29          ( w_load_recsat_ia_wdata_part29 ),
        .w_load_recsat_ia_wdata_part30          ( w_load_recsat_ia_wdata_part30 ),
        .w_load_recsat_ia_wdata_part31          ( w_load_recsat_ia_wdata_part31 ),
        .w_load_recsat_ia_config                ( w_load_recsat_ia_config ),
        .w_load_recct_ia_wdata_part0            ( w_load_recct_ia_wdata_part0 ),
        .w_load_recct_ia_wdata_part1            ( w_load_recct_ia_wdata_part1 ),
        .w_load_recct_ia_wdata_part2            ( w_load_recct_ia_wdata_part2 ),
        .w_load_recct_ia_wdata_part3            ( w_load_recct_ia_wdata_part3 ),
        .w_load_recct_ia_wdata_part4            ( w_load_recct_ia_wdata_part4 ),
        .w_load_recct_ia_wdata_part5            ( w_load_recct_ia_wdata_part5 ),
        .w_load_recct_ia_wdata_part6            ( w_load_recct_ia_wdata_part6 ),
        .w_load_recct_ia_wdata_part7            ( w_load_recct_ia_wdata_part7 ),
        .w_load_recct_ia_wdata_part8            ( w_load_recct_ia_wdata_part8 ),
        .w_load_recct_ia_wdata_part9            ( w_load_recct_ia_wdata_part9 ),
        .w_load_recct_ia_wdata_part10           ( w_load_recct_ia_wdata_part10 ),
        .w_load_recct_ia_wdata_part11           ( w_load_recct_ia_wdata_part11 ),
        .w_load_recct_ia_wdata_part12           ( w_load_recct_ia_wdata_part12 ),
        .w_load_recct_ia_wdata_part13           ( w_load_recct_ia_wdata_part13 ),
        .w_load_recct_ia_wdata_part14           ( w_load_recct_ia_wdata_part14 ),
        .w_load_recct_ia_wdata_part15           ( w_load_recct_ia_wdata_part15 ),
        .w_load_recct_ia_wdata_part16           ( w_load_recct_ia_wdata_part16 ),
        .w_load_recct_ia_wdata_part17           ( w_load_recct_ia_wdata_part17 ),
        .w_load_recct_ia_wdata_part18           ( w_load_recct_ia_wdata_part18 ),
        .w_load_recct_ia_wdata_part19           ( w_load_recct_ia_wdata_part19 ),
        .w_load_recct_ia_wdata_part20           ( w_load_recct_ia_wdata_part20 ),
        .w_load_recct_ia_wdata_part21           ( w_load_recct_ia_wdata_part21 ),
        .w_load_recct_ia_wdata_part22           ( w_load_recct_ia_wdata_part22 ),
        .w_load_recct_ia_wdata_part23           ( w_load_recct_ia_wdata_part23 ),
        .w_load_recct_ia_wdata_part24           ( w_load_recct_ia_wdata_part24 ),
        .w_load_recct_ia_wdata_part25           ( w_load_recct_ia_wdata_part25 ),
        .w_load_recct_ia_wdata_part26           ( w_load_recct_ia_wdata_part26 ),
        .w_load_recct_ia_wdata_part27           ( w_load_recct_ia_wdata_part27 ),
        .w_load_recct_ia_wdata_part28           ( w_load_recct_ia_wdata_part28 ),
        .w_load_recct_ia_wdata_part29           ( w_load_recct_ia_wdata_part29 ),
        .w_load_recct_ia_wdata_part30           ( w_load_recct_ia_wdata_part30 ),
        .w_load_recct_ia_wdata_part31           ( w_load_recct_ia_wdata_part31 ),
        .w_load_recct_ia_config                 ( w_load_recct_ia_config ),
        .w_load_psr_ia_config                   ( w_load_psr_ia_config ),
        .w_load_bimc_monitor_mask               ( w_load_bimc_monitor_mask ),
        .w_load_bimc_ecc_uncorrectable_error_cnt ( w_load_bimc_ecc_uncorrectable_error_cnt ),
        .w_load_bimc_ecc_correctable_error_cnt  ( w_load_bimc_ecc_correctable_error_cnt ),
        .w_load_bimc_parity_error_cnt           ( w_load_bimc_parity_error_cnt ),
        .w_load_bimc_global_config              ( w_load_bimc_global_config ),
        .w_load_bimc_eccpar_debug               ( w_load_bimc_eccpar_debug ),
        .w_load_bimc_cmd2                       ( w_load_bimc_cmd2 ),
        .w_load_bimc_cmd1                       ( w_load_bimc_cmd1 ),
        .w_load_bimc_cmd0                       ( w_load_bimc_cmd0 ),
        .w_load_bimc_rxcmd2                     ( w_load_bimc_rxcmd2 ),
        .w_load_bimc_rxrsp2                     ( w_load_bimc_rxrsp2 ),
        .w_load_bimc_pollrsp2                   ( w_load_bimc_pollrsp2 ),
        .w_load_bimc_dbgcmd2                    ( w_load_bimc_dbgcmd2 ),
        .w_load_psr_ia_wdata_part0              ( w_load_psr_ia_wdata_part0 ),
        .f32_data                               ( f32_data )
  );

  

  

  `ifdef CR_PREFIX_DIGEST_5B27845C94AA6EB5CA8D09863FF27F69
  `else
    initial begin
      $display("Error: the core decode file (cr_prefix_regs.sv) and include file (cr_prefix.vh) were compiled");
      $display("       from different rdb sources.  Please regenerate both files so they can be synchronized.");
      $display("");
      $finish;
    end
  `endif

  `ifdef REGISTER_ERROR_CODE_MONITOR_ENABLE
    always @(posedge clk)
      if (i_reset_) begin
        if (~w_valid_addr)
          $display($time, "Error: %m.i_addr = %x, o_err_ack  = 1'b%b, access to an address hole detected", i_addr, o_err_ack);
        else if (~w_valid_wr_addr & n_write)
          $display($time, "Warning: %m.i_addr = %x, o_err_ack  = 1'b%b, write to an read-only (RO) register detected", i_addr, o_err_ack);
      end
  `endif

  

endmodule


module cr_prefix_regs_flops (
  input                                         clk,
  input                                         i_reset_,
  input                                         i_sw_init,

  
  output reg [`CR_PREFIX_C_SPARE_T_DECL]        o_spare_config,
  output reg [`CR_PREFIX_C_PREFIX_REC_US_CTRL_T_DECL] o_regs_rec_us_ctrl,
  output reg [`CR_PREFIX_C_PREFIX_DEBUG_CONTROL_T_DECL] o_regs_rec_debug_control,
  output reg [`CR_PREFIX_C_PREFIX_BREAKPOINT_ADDR_T_DECL] o_regs_breakpoint_addr,
  output reg [`CR_PREFIX_C_PREFIX_BREAKPOINT_CONT_T_DECL] o_regs_breakpoint_cont,
  output reg [`CR_PREFIX_C_PREFIX_BREAKPOINT_STEP_T_DECL] o_regs_breakpoint_step,
  output reg [`CR_PREFIX_C_PREFIX_ERROR_CONTROL_T_DECL] o_regs_error_control,
  output reg [`CR_PREFIX_C_REGS_TLV_PARSE_ACTION_31_0_T_DECL] o_regs_tlv_parse_action_0,
  output reg [`CR_PREFIX_C_REGS_TLV_PARSE_ACTION_63_32_T_DECL] o_regs_tlv_parse_action_1,
  output reg [`CR_PREFIX_C_FEATURE_PART0_T_DECL] o_feature_ia_wdata_part0,
  output reg [`CR_PREFIX_C_FEATURE_PART1_T_DECL] o_feature_ia_wdata_part1,
  output reg [`CR_PREFIX_C_FEATURE_IA_CONFIG_T_DECL] o_feature_ia_config,
  output reg [`CR_PREFIX_C_FEATURE_CTR_T_DECL]  o_feature_ctr_ia_wdata_part0,
  output reg [`CR_PREFIX_C_FEATURE_CTR_IA_CONFIG_T_DECL] o_feature_ctr_ia_config,
  output reg [`CR_PREFIX_C_REC_INST_T_DECL]     o_recim_ia_wdata_part0,
  output reg [`CR_PREFIX_C_RECIM_IA_CONFIG_T_DECL] o_recim_ia_config,
  output reg [`CR_PREFIX_C_REC_SAT_PART0_T_DECL] o_recsat_ia_wdata_part0,
  output reg [`CR_PREFIX_C_REC_SAT_PART1_T_DECL] o_recsat_ia_wdata_part1,
  output reg [`CR_PREFIX_C_REC_SAT_PART2_T_DECL] o_recsat_ia_wdata_part2,
  output reg [`CR_PREFIX_C_REC_SAT_PART3_T_DECL] o_recsat_ia_wdata_part3,
  output reg [`CR_PREFIX_C_REC_SAT_PART4_T_DECL] o_recsat_ia_wdata_part4,
  output reg [`CR_PREFIX_C_REC_SAT_PART5_T_DECL] o_recsat_ia_wdata_part5,
  output reg [`CR_PREFIX_C_REC_SAT_PART6_T_DECL] o_recsat_ia_wdata_part6,
  output reg [`CR_PREFIX_C_REC_SAT_PART7_T_DECL] o_recsat_ia_wdata_part7,
  output reg [`CR_PREFIX_C_REC_SAT_PART8_T_DECL] o_recsat_ia_wdata_part8,
  output reg [`CR_PREFIX_C_REC_SAT_PART9_T_DECL] o_recsat_ia_wdata_part9,
  output reg [`CR_PREFIX_C_REC_SAT_PART10_T_DECL] o_recsat_ia_wdata_part10,
  output reg [`CR_PREFIX_C_REC_SAT_PART11_T_DECL] o_recsat_ia_wdata_part11,
  output reg [`CR_PREFIX_C_REC_SAT_PART12_T_DECL] o_recsat_ia_wdata_part12,
  output reg [`CR_PREFIX_C_REC_SAT_PART13_T_DECL] o_recsat_ia_wdata_part13,
  output reg [`CR_PREFIX_C_REC_SAT_PART14_T_DECL] o_recsat_ia_wdata_part14,
  output reg [`CR_PREFIX_C_REC_SAT_PART15_T_DECL] o_recsat_ia_wdata_part15,
  output reg [`CR_PREFIX_C_REC_SAT_PART16_T_DECL] o_recsat_ia_wdata_part16,
  output reg [`CR_PREFIX_C_REC_SAT_PART17_T_DECL] o_recsat_ia_wdata_part17,
  output reg [`CR_PREFIX_C_REC_SAT_PART18_T_DECL] o_recsat_ia_wdata_part18,
  output reg [`CR_PREFIX_C_REC_SAT_PART19_T_DECL] o_recsat_ia_wdata_part19,
  output reg [`CR_PREFIX_C_REC_SAT_PART20_T_DECL] o_recsat_ia_wdata_part20,
  output reg [`CR_PREFIX_C_REC_SAT_PART21_T_DECL] o_recsat_ia_wdata_part21,
  output reg [`CR_PREFIX_C_REC_SAT_PART22_T_DECL] o_recsat_ia_wdata_part22,
  output reg [`CR_PREFIX_C_REC_SAT_PART23_T_DECL] o_recsat_ia_wdata_part23,
  output reg [`CR_PREFIX_C_REC_SAT_PART24_T_DECL] o_recsat_ia_wdata_part24,
  output reg [`CR_PREFIX_C_REC_SAT_PART25_T_DECL] o_recsat_ia_wdata_part25,
  output reg [`CR_PREFIX_C_REC_SAT_PART26_T_DECL] o_recsat_ia_wdata_part26,
  output reg [`CR_PREFIX_C_REC_SAT_PART27_T_DECL] o_recsat_ia_wdata_part27,
  output reg [`CR_PREFIX_C_REC_SAT_PART28_T_DECL] o_recsat_ia_wdata_part28,
  output reg [`CR_PREFIX_C_REC_SAT_PART29_T_DECL] o_recsat_ia_wdata_part29,
  output reg [`CR_PREFIX_C_REC_SAT_PART30_T_DECL] o_recsat_ia_wdata_part30,
  output reg [`CR_PREFIX_C_REC_SAT_PART31_T_DECL] o_recsat_ia_wdata_part31,
  output reg [`CR_PREFIX_C_RECSAT_IA_CONFIG_T_DECL] o_recsat_ia_config,
  output reg [`CR_PREFIX_C_REC_CT_PART0_T_DECL] o_recct_ia_wdata_part0,
  output reg [`CR_PREFIX_C_REC_CT_PART1_T_DECL] o_recct_ia_wdata_part1,
  output reg [`CR_PREFIX_C_REC_CT_PART2_T_DECL] o_recct_ia_wdata_part2,
  output reg [`CR_PREFIX_C_REC_CT_PART3_T_DECL] o_recct_ia_wdata_part3,
  output reg [`CR_PREFIX_C_REC_CT_PART4_T_DECL] o_recct_ia_wdata_part4,
  output reg [`CR_PREFIX_C_REC_CT_PART5_T_DECL] o_recct_ia_wdata_part5,
  output reg [`CR_PREFIX_C_REC_CT_PART6_T_DECL] o_recct_ia_wdata_part6,
  output reg [`CR_PREFIX_C_REC_CT_PART7_T_DECL] o_recct_ia_wdata_part7,
  output reg [`CR_PREFIX_C_REC_CT_PART8_T_DECL] o_recct_ia_wdata_part8,
  output reg [`CR_PREFIX_C_REC_CT_PART9_T_DECL] o_recct_ia_wdata_part9,
  output reg [`CR_PREFIX_C_REC_CT_PART10_T_DECL] o_recct_ia_wdata_part10,
  output reg [`CR_PREFIX_C_REC_CT_PART11_T_DECL] o_recct_ia_wdata_part11,
  output reg [`CR_PREFIX_C_REC_CT_PART12_T_DECL] o_recct_ia_wdata_part12,
  output reg [`CR_PREFIX_C_REC_CT_PART13_T_DECL] o_recct_ia_wdata_part13,
  output reg [`CR_PREFIX_C_REC_CT_PART14_T_DECL] o_recct_ia_wdata_part14,
  output reg [`CR_PREFIX_C_REC_CT_PART15_T_DECL] o_recct_ia_wdata_part15,
  output reg [`CR_PREFIX_C_REC_CT_PART16_T_DECL] o_recct_ia_wdata_part16,
  output reg [`CR_PREFIX_C_REC_CT_PART17_T_DECL] o_recct_ia_wdata_part17,
  output reg [`CR_PREFIX_C_REC_CT_PART18_T_DECL] o_recct_ia_wdata_part18,
  output reg [`CR_PREFIX_C_REC_CT_PART19_T_DECL] o_recct_ia_wdata_part19,
  output reg [`CR_PREFIX_C_REC_CT_PART20_T_DECL] o_recct_ia_wdata_part20,
  output reg [`CR_PREFIX_C_REC_CT_PART21_T_DECL] o_recct_ia_wdata_part21,
  output reg [`CR_PREFIX_C_REC_CT_PART22_T_DECL] o_recct_ia_wdata_part22,
  output reg [`CR_PREFIX_C_REC_CT_PART23_T_DECL] o_recct_ia_wdata_part23,
  output reg [`CR_PREFIX_C_REC_CT_PART24_T_DECL] o_recct_ia_wdata_part24,
  output reg [`CR_PREFIX_C_REC_CT_PART25_T_DECL] o_recct_ia_wdata_part25,
  output reg [`CR_PREFIX_C_REC_CT_PART26_T_DECL] o_recct_ia_wdata_part26,
  output reg [`CR_PREFIX_C_REC_CT_PART27_T_DECL] o_recct_ia_wdata_part27,
  output reg [`CR_PREFIX_C_REC_CT_PART28_T_DECL] o_recct_ia_wdata_part28,
  output reg [`CR_PREFIX_C_REC_CT_PART29_T_DECL] o_recct_ia_wdata_part29,
  output reg [`CR_PREFIX_C_REC_CT_PART30_T_DECL] o_recct_ia_wdata_part30,
  output reg [`CR_PREFIX_C_REC_CT_PART31_T_DECL] o_recct_ia_wdata_part31,
  output reg [`CR_PREFIX_C_RECCT_IA_CONFIG_T_DECL] o_recct_ia_config,
  output reg [`CR_PREFIX_C_PSR_T_DECL]          o_psr_ia_wdata_part0,
  output reg [`CR_PREFIX_C_PSR_IA_CONFIG_T_DECL] o_psr_ia_config,
  output reg [`CR_PREFIX_C_BIMC_MONITOR_MASK_T_DECL] o_bimc_monitor_mask,
  output reg [`CR_PREFIX_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_uncorrectable_error_cnt,
  output reg [`CR_PREFIX_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_correctable_error_cnt,
  output reg [`CR_PREFIX_C_BIMC_PARITY_ERROR_CNT_T_DECL] o_bimc_parity_error_cnt,
  output reg [`CR_PREFIX_C_BIMC_GLOBAL_CONFIG_T_DECL] o_bimc_global_config,
  output reg [`CR_PREFIX_C_BIMC_ECCPAR_DEBUG_T_DECL] o_bimc_eccpar_debug,
  output reg [`CR_PREFIX_C_BIMC_CMD2_T_DECL]    o_bimc_cmd2,
  output reg [`CR_PREFIX_C_BIMC_CMD1_T_DECL]    o_bimc_cmd1,
  output reg [`CR_PREFIX_C_BIMC_CMD0_T_DECL]    o_bimc_cmd0,
  output reg [`CR_PREFIX_C_BIMC_RXCMD2_T_DECL]  o_bimc_rxcmd2,
  output reg [`CR_PREFIX_C_BIMC_RXRSP2_T_DECL]  o_bimc_rxrsp2,
  output reg [`CR_PREFIX_C_BIMC_POLLRSP2_T_DECL] o_bimc_pollrsp2,
  output reg [`CR_PREFIX_C_BIMC_DBGCMD2_T_DECL] o_bimc_dbgcmd2,


  
  input                                         w_load_spare_config,
  input                                         w_load_regs_rec_us_ctrl,
  input                                         w_load_regs_rec_debug_control,
  input                                         w_load_regs_breakpoint_addr,
  input                                         w_load_regs_breakpoint_cont,
  input                                         w_load_regs_breakpoint_step,
  input                                         w_load_regs_error_control,
  input                                         w_load_regs_tlv_parse_action_0,
  input                                         w_load_regs_tlv_parse_action_1,
  input                                         w_load_feature_ia_wdata_part0,
  input                                         w_load_feature_ia_wdata_part1,
  input                                         w_load_feature_ia_config,
  input                                         w_load_feature_ctr_ia_wdata_part0,
  input                                         w_load_feature_ctr_ia_config,
  input                                         w_load_recim_ia_wdata_part0,
  input                                         w_load_recim_ia_config,
  input                                         w_load_recsat_ia_wdata_part0,
  input                                         w_load_recsat_ia_wdata_part1,
  input                                         w_load_recsat_ia_wdata_part2,
  input                                         w_load_recsat_ia_wdata_part3,
  input                                         w_load_recsat_ia_wdata_part4,
  input                                         w_load_recsat_ia_wdata_part5,
  input                                         w_load_recsat_ia_wdata_part6,
  input                                         w_load_recsat_ia_wdata_part7,
  input                                         w_load_recsat_ia_wdata_part8,
  input                                         w_load_recsat_ia_wdata_part9,
  input                                         w_load_recsat_ia_wdata_part10,
  input                                         w_load_recsat_ia_wdata_part11,
  input                                         w_load_recsat_ia_wdata_part12,
  input                                         w_load_recsat_ia_wdata_part13,
  input                                         w_load_recsat_ia_wdata_part14,
  input                                         w_load_recsat_ia_wdata_part15,
  input                                         w_load_recsat_ia_wdata_part16,
  input                                         w_load_recsat_ia_wdata_part17,
  input                                         w_load_recsat_ia_wdata_part18,
  input                                         w_load_recsat_ia_wdata_part19,
  input                                         w_load_recsat_ia_wdata_part20,
  input                                         w_load_recsat_ia_wdata_part21,
  input                                         w_load_recsat_ia_wdata_part22,
  input                                         w_load_recsat_ia_wdata_part23,
  input                                         w_load_recsat_ia_wdata_part24,
  input                                         w_load_recsat_ia_wdata_part25,
  input                                         w_load_recsat_ia_wdata_part26,
  input                                         w_load_recsat_ia_wdata_part27,
  input                                         w_load_recsat_ia_wdata_part28,
  input                                         w_load_recsat_ia_wdata_part29,
  input                                         w_load_recsat_ia_wdata_part30,
  input                                         w_load_recsat_ia_wdata_part31,
  input                                         w_load_recsat_ia_config,
  input                                         w_load_recct_ia_wdata_part0,
  input                                         w_load_recct_ia_wdata_part1,
  input                                         w_load_recct_ia_wdata_part2,
  input                                         w_load_recct_ia_wdata_part3,
  input                                         w_load_recct_ia_wdata_part4,
  input                                         w_load_recct_ia_wdata_part5,
  input                                         w_load_recct_ia_wdata_part6,
  input                                         w_load_recct_ia_wdata_part7,
  input                                         w_load_recct_ia_wdata_part8,
  input                                         w_load_recct_ia_wdata_part9,
  input                                         w_load_recct_ia_wdata_part10,
  input                                         w_load_recct_ia_wdata_part11,
  input                                         w_load_recct_ia_wdata_part12,
  input                                         w_load_recct_ia_wdata_part13,
  input                                         w_load_recct_ia_wdata_part14,
  input                                         w_load_recct_ia_wdata_part15,
  input                                         w_load_recct_ia_wdata_part16,
  input                                         w_load_recct_ia_wdata_part17,
  input                                         w_load_recct_ia_wdata_part18,
  input                                         w_load_recct_ia_wdata_part19,
  input                                         w_load_recct_ia_wdata_part20,
  input                                         w_load_recct_ia_wdata_part21,
  input                                         w_load_recct_ia_wdata_part22,
  input                                         w_load_recct_ia_wdata_part23,
  input                                         w_load_recct_ia_wdata_part24,
  input                                         w_load_recct_ia_wdata_part25,
  input                                         w_load_recct_ia_wdata_part26,
  input                                         w_load_recct_ia_wdata_part27,
  input                                         w_load_recct_ia_wdata_part28,
  input                                         w_load_recct_ia_wdata_part29,
  input                                         w_load_recct_ia_wdata_part30,
  input                                         w_load_recct_ia_wdata_part31,
  input                                         w_load_recct_ia_config,
  input                                         w_load_psr_ia_config,
  input                                         w_load_bimc_monitor_mask,
  input                                         w_load_bimc_ecc_uncorrectable_error_cnt,
  input                                         w_load_bimc_ecc_correctable_error_cnt,
  input                                         w_load_bimc_parity_error_cnt,
  input                                         w_load_bimc_global_config,
  input                                         w_load_bimc_eccpar_debug,
  input                                         w_load_bimc_cmd2,
  input                                         w_load_bimc_cmd1,
  input                                         w_load_bimc_cmd0,
  input                                         w_load_bimc_rxcmd2,
  input                                         w_load_bimc_rxrsp2,
  input                                         w_load_bimc_pollrsp2,
  input                                         w_load_bimc_dbgcmd2,
  input                                         w_load_psr_ia_wdata_part0,

  input      [31:0]                             f32_data
  );

  
  

  
  

  
  
  
  always_ff @(posedge clk or negedge i_reset_) begin
    if(~i_reset_) begin
      
      o_spare_config[31:00]                     <= 32'd0; 
      o_regs_rec_us_ctrl[00:00]                 <= 1'd0; 
      o_regs_rec_us_ctrl[31:01]                 <= 31'd0; 
      o_regs_rec_debug_control[00:00]           <= 1'd0; 
      o_regs_rec_debug_control[31:01]           <= 31'd0; 
      o_regs_breakpoint_addr[07:00]             <= 8'd0; 
      o_regs_breakpoint_addr[31:08]             <= 24'd0; 
      o_regs_breakpoint_cont[00:00]             <= 1'd0; 
      o_regs_breakpoint_cont[31:01]             <= 31'd0; 
      o_regs_breakpoint_step[00:00]             <= 1'd0; 
      o_regs_breakpoint_step[31:01]             <= 31'd0; 
      o_regs_error_control[00:00]               <= 1'd1; 
      o_regs_error_control[31:01]               <= 31'd0; 
      o_regs_tlv_parse_action_0[01:00]          <= 2'd1; 
      o_regs_tlv_parse_action_0[03:02]          <= 2'd0; 
      o_regs_tlv_parse_action_0[05:04]          <= 2'd2; 
      o_regs_tlv_parse_action_0[07:06]          <= 2'd1; 
      o_regs_tlv_parse_action_0[09:08]          <= 2'd1; 
      o_regs_tlv_parse_action_0[11:10]          <= 2'd0; 
      o_regs_tlv_parse_action_0[13:12]          <= 2'd2; 
      o_regs_tlv_parse_action_0[15:14]          <= 2'd1; 
      o_regs_tlv_parse_action_0[17:16]          <= 2'd1; 
      o_regs_tlv_parse_action_0[19:18]          <= 2'd1; 
      o_regs_tlv_parse_action_0[21:20]          <= 2'd1; 
      o_regs_tlv_parse_action_0[23:22]          <= 2'd2; 
      o_regs_tlv_parse_action_0[25:24]          <= 2'd2; 
      o_regs_tlv_parse_action_0[27:26]          <= 2'd2; 
      o_regs_tlv_parse_action_0[29:28]          <= 2'd2; 
      o_regs_tlv_parse_action_0[31:30]          <= 2'd1; 
      o_regs_tlv_parse_action_1[01:00]          <= 2'd1; 
      o_regs_tlv_parse_action_1[03:02]          <= 2'd1; 
      o_regs_tlv_parse_action_1[05:04]          <= 2'd1; 
      o_regs_tlv_parse_action_1[07:06]          <= 2'd0; 
      o_regs_tlv_parse_action_1[09:08]          <= 2'd1; 
      o_regs_tlv_parse_action_1[11:10]          <= 2'd1; 
      o_regs_tlv_parse_action_1[13:12]          <= 2'd1; 
      o_regs_tlv_parse_action_1[15:14]          <= 2'd1; 
      o_regs_tlv_parse_action_1[17:16]          <= 2'd1; 
      o_regs_tlv_parse_action_1[19:18]          <= 2'd1; 
      o_regs_tlv_parse_action_1[21:20]          <= 2'd1; 
      o_regs_tlv_parse_action_1[23:22]          <= 2'd1; 
      o_regs_tlv_parse_action_1[25:24]          <= 2'd1; 
      o_regs_tlv_parse_action_1[27:26]          <= 2'd1; 
      o_regs_tlv_parse_action_1[29:28]          <= 2'd1; 
      o_regs_tlv_parse_action_1[31:30]          <= 2'd1; 
      o_feature_ia_wdata_part0[07:00]           <= 8'd0; 
      o_feature_ia_wdata_part0[15:08]           <= 8'd0; 
      o_feature_ia_wdata_part0[23:16]           <= 8'd0; 
      o_feature_ia_wdata_part0[31:24]           <= 8'd0; 
      o_feature_ia_wdata_part1[01:00]           <= 2'd0; 
      o_feature_ia_wdata_part1[02:02]           <= 1'd0; 
      o_feature_ia_wdata_part1[03:03]           <= 1'd0; 
      o_feature_ia_wdata_part1[05:04]           <= 2'd0; 
      o_feature_ia_wdata_part1[06:06]           <= 1'd0; 
      o_feature_ia_wdata_part1[07:07]           <= 1'd0; 
      o_feature_ia_wdata_part1[09:08]           <= 2'd0; 
      o_feature_ia_wdata_part1[10:10]           <= 1'd0; 
      o_feature_ia_wdata_part1[11:11]           <= 1'd0; 
      o_feature_ia_wdata_part1[13:12]           <= 2'd0; 
      o_feature_ia_wdata_part1[14:14]           <= 1'd0; 
      o_feature_ia_wdata_part1[15:15]           <= 1'd0; 
      o_feature_ia_wdata_part1[31:16]           <= 16'd0; 
      o_feature_ia_config[07:00]                <= 8'd0; 
      o_feature_ia_config[11:08]                <= 4'd0; 
      o_feature_ctr_ia_wdata_part0[07:00]       <= 8'd0; 
      o_feature_ctr_ia_wdata_part0[31:08]       <= 24'd0; 
      o_feature_ctr_ia_config[07:00]            <= 8'd0; 
      o_feature_ctr_ia_config[11:08]            <= 4'd0; 
      o_recim_ia_wdata_part0[00:00]             <= 1'd0; 
      o_recim_ia_wdata_part0[01:01]             <= 1'd0; 
      o_recim_ia_wdata_part0[09:02]             <= 8'd0; 
      o_recim_ia_wdata_part0[17:10]             <= 8'd0; 
      o_recim_ia_wdata_part0[21:18]             <= 4'd0; 
      o_recim_ia_wdata_part0[23:22]             <= 2'd0; 
      o_recim_ia_config[07:00]                  <= 8'd0; 
      o_recim_ia_config[11:08]                  <= 4'd0; 
      o_recsat_ia_wdata_part0[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part1[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part2[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part3[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part4[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part5[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part6[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part7[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part8[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part9[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part10[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part11[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part12[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part13[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part14[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part15[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part16[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part17[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part18[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part19[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part20[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part21[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part22[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part23[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part24[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part25[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part26[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part27[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part28[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part29[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part30[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part31[31:00]           <= 32'd0; 
      o_recsat_ia_config[06:00]                 <= 7'd0; 
      o_recsat_ia_config[10:07]                 <= 4'd0; 
      o_recct_ia_wdata_part0[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part1[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part2[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part3[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part4[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part5[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part6[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part7[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part8[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part9[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part10[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part11[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part12[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part13[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part14[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part15[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part16[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part17[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part18[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part19[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part20[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part21[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part22[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part23[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part24[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part25[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part26[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part27[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part28[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part29[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part30[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part31[31:00]            <= 32'd0; 
      o_recct_ia_config[06:00]                  <= 7'd0; 
      o_recct_ia_config[10:07]                  <= 4'd0; 
      o_psr_ia_config[08:00]                    <= 9'd0; 
      o_psr_ia_config[12:09]                    <= 4'd0; 
      o_bimc_monitor_mask[00:00]                <= 1'd0; 
      o_bimc_monitor_mask[01:01]                <= 1'd0; 
      o_bimc_monitor_mask[02:02]                <= 1'd0; 
      o_bimc_monitor_mask[03:03]                <= 1'd0; 
      o_bimc_monitor_mask[04:04]                <= 1'd0; 
      o_bimc_monitor_mask[05:05]                <= 1'd0; 
      o_bimc_monitor_mask[06:06]                <= 1'd0; 
      o_bimc_ecc_uncorrectable_error_cnt[31:00] <= 32'd0; 
      o_bimc_ecc_correctable_error_cnt[31:00]   <= 32'd0; 
      o_bimc_parity_error_cnt[31:00]            <= 32'd0; 
      o_bimc_global_config[00:00]               <= 1'd1; 
      o_bimc_global_config[01:01]               <= 1'd0; 
      o_bimc_global_config[02:02]               <= 1'd0; 
      o_bimc_global_config[03:03]               <= 1'd0; 
      o_bimc_global_config[04:04]               <= 1'd0; 
      o_bimc_global_config[05:05]               <= 1'd0; 
      o_bimc_global_config[31:06]               <= 26'd0; 
      o_bimc_eccpar_debug[11:00]                <= 12'd0; 
      o_bimc_eccpar_debug[15:12]                <= 4'd0; 
      o_bimc_eccpar_debug[17:16]                <= 2'd0; 
      o_bimc_eccpar_debug[19:18]                <= 2'd0; 
      o_bimc_eccpar_debug[21:20]                <= 2'd0; 
      o_bimc_eccpar_debug[22:22]                <= 1'd0; 
      o_bimc_eccpar_debug[23:23]                <= 1'd0; 
      o_bimc_eccpar_debug[27:24]                <= 4'd0; 
      o_bimc_eccpar_debug[28:28]                <= 1'd0; 
      o_bimc_cmd2[07:00]                        <= 8'd0; 
      o_bimc_cmd2[08:08]                        <= 1'd0; 
      o_bimc_cmd2[09:09]                        <= 1'd0; 
      o_bimc_cmd2[10:10]                        <= 1'd0; 
      o_bimc_cmd1[15:00]                        <= 16'd0; 
      o_bimc_cmd1[27:16]                        <= 12'd0; 
      o_bimc_cmd1[31:28]                        <= 4'd0; 
      o_bimc_cmd0[31:00]                        <= 32'd0; 
      o_bimc_rxcmd2[07:00]                      <= 8'd0; 
      o_bimc_rxcmd2[08:08]                      <= 1'd0; 
      o_bimc_rxrsp2[07:00]                      <= 8'd0; 
      o_bimc_rxrsp2[08:08]                      <= 1'd0; 
      o_bimc_pollrsp2[07:00]                    <= 8'd0; 
      o_bimc_pollrsp2[08:08]                    <= 1'd0; 
      o_bimc_dbgcmd2[07:00]                     <= 8'd0; 
      o_bimc_dbgcmd2[08:08]                     <= 1'd0; 
    end
    else if(i_sw_init) begin
      
      o_spare_config[31:00]                     <= 32'd0; 
      o_regs_rec_us_ctrl[00:00]                 <= 1'd0; 
      o_regs_rec_us_ctrl[31:01]                 <= 31'd0; 
      o_regs_rec_debug_control[00:00]           <= 1'd0; 
      o_regs_rec_debug_control[31:01]           <= 31'd0; 
      o_regs_breakpoint_addr[07:00]             <= 8'd0; 
      o_regs_breakpoint_addr[31:08]             <= 24'd0; 
      o_regs_breakpoint_cont[00:00]             <= 1'd0; 
      o_regs_breakpoint_cont[31:01]             <= 31'd0; 
      o_regs_breakpoint_step[00:00]             <= 1'd0; 
      o_regs_breakpoint_step[31:01]             <= 31'd0; 
      o_regs_error_control[00:00]               <= 1'd1; 
      o_regs_error_control[31:01]               <= 31'd0; 
      o_regs_tlv_parse_action_0[01:00]          <= 2'd1; 
      o_regs_tlv_parse_action_0[03:02]          <= 2'd0; 
      o_regs_tlv_parse_action_0[05:04]          <= 2'd2; 
      o_regs_tlv_parse_action_0[07:06]          <= 2'd1; 
      o_regs_tlv_parse_action_0[09:08]          <= 2'd1; 
      o_regs_tlv_parse_action_0[11:10]          <= 2'd0; 
      o_regs_tlv_parse_action_0[13:12]          <= 2'd2; 
      o_regs_tlv_parse_action_0[15:14]          <= 2'd1; 
      o_regs_tlv_parse_action_0[17:16]          <= 2'd1; 
      o_regs_tlv_parse_action_0[19:18]          <= 2'd1; 
      o_regs_tlv_parse_action_0[21:20]          <= 2'd1; 
      o_regs_tlv_parse_action_0[23:22]          <= 2'd2; 
      o_regs_tlv_parse_action_0[25:24]          <= 2'd2; 
      o_regs_tlv_parse_action_0[27:26]          <= 2'd2; 
      o_regs_tlv_parse_action_0[29:28]          <= 2'd2; 
      o_regs_tlv_parse_action_0[31:30]          <= 2'd1; 
      o_regs_tlv_parse_action_1[01:00]          <= 2'd1; 
      o_regs_tlv_parse_action_1[03:02]          <= 2'd1; 
      o_regs_tlv_parse_action_1[05:04]          <= 2'd1; 
      o_regs_tlv_parse_action_1[07:06]          <= 2'd0; 
      o_regs_tlv_parse_action_1[09:08]          <= 2'd1; 
      o_regs_tlv_parse_action_1[11:10]          <= 2'd1; 
      o_regs_tlv_parse_action_1[13:12]          <= 2'd1; 
      o_regs_tlv_parse_action_1[15:14]          <= 2'd1; 
      o_regs_tlv_parse_action_1[17:16]          <= 2'd1; 
      o_regs_tlv_parse_action_1[19:18]          <= 2'd1; 
      o_regs_tlv_parse_action_1[21:20]          <= 2'd1; 
      o_regs_tlv_parse_action_1[23:22]          <= 2'd1; 
      o_regs_tlv_parse_action_1[25:24]          <= 2'd1; 
      o_regs_tlv_parse_action_1[27:26]          <= 2'd1; 
      o_regs_tlv_parse_action_1[29:28]          <= 2'd1; 
      o_regs_tlv_parse_action_1[31:30]          <= 2'd1; 
      o_feature_ia_wdata_part0[07:00]           <= 8'd0; 
      o_feature_ia_wdata_part0[15:08]           <= 8'd0; 
      o_feature_ia_wdata_part0[23:16]           <= 8'd0; 
      o_feature_ia_wdata_part0[31:24]           <= 8'd0; 
      o_feature_ia_wdata_part1[01:00]           <= 2'd0; 
      o_feature_ia_wdata_part1[02:02]           <= 1'd0; 
      o_feature_ia_wdata_part1[03:03]           <= 1'd0; 
      o_feature_ia_wdata_part1[05:04]           <= 2'd0; 
      o_feature_ia_wdata_part1[06:06]           <= 1'd0; 
      o_feature_ia_wdata_part1[07:07]           <= 1'd0; 
      o_feature_ia_wdata_part1[09:08]           <= 2'd0; 
      o_feature_ia_wdata_part1[10:10]           <= 1'd0; 
      o_feature_ia_wdata_part1[11:11]           <= 1'd0; 
      o_feature_ia_wdata_part1[13:12]           <= 2'd0; 
      o_feature_ia_wdata_part1[14:14]           <= 1'd0; 
      o_feature_ia_wdata_part1[15:15]           <= 1'd0; 
      o_feature_ia_wdata_part1[31:16]           <= 16'd0; 
      o_feature_ia_config[07:00]                <= 8'd0; 
      o_feature_ia_config[11:08]                <= 4'd0; 
      o_feature_ctr_ia_wdata_part0[07:00]       <= 8'd0; 
      o_feature_ctr_ia_wdata_part0[31:08]       <= 24'd0; 
      o_feature_ctr_ia_config[07:00]            <= 8'd0; 
      o_feature_ctr_ia_config[11:08]            <= 4'd0; 
      o_recim_ia_wdata_part0[00:00]             <= 1'd0; 
      o_recim_ia_wdata_part0[01:01]             <= 1'd0; 
      o_recim_ia_wdata_part0[09:02]             <= 8'd0; 
      o_recim_ia_wdata_part0[17:10]             <= 8'd0; 
      o_recim_ia_wdata_part0[21:18]             <= 4'd0; 
      o_recim_ia_wdata_part0[23:22]             <= 2'd0; 
      o_recim_ia_config[07:00]                  <= 8'd0; 
      o_recim_ia_config[11:08]                  <= 4'd0; 
      o_recsat_ia_wdata_part0[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part1[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part2[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part3[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part4[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part5[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part6[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part7[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part8[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part9[31:00]            <= 32'd0; 
      o_recsat_ia_wdata_part10[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part11[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part12[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part13[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part14[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part15[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part16[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part17[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part18[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part19[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part20[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part21[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part22[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part23[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part24[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part25[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part26[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part27[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part28[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part29[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part30[31:00]           <= 32'd0; 
      o_recsat_ia_wdata_part31[31:00]           <= 32'd0; 
      o_recsat_ia_config[06:00]                 <= 7'd0; 
      o_recsat_ia_config[10:07]                 <= 4'd0; 
      o_recct_ia_wdata_part0[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part1[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part2[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part3[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part4[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part5[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part6[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part7[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part8[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part9[31:00]             <= 32'd0; 
      o_recct_ia_wdata_part10[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part11[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part12[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part13[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part14[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part15[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part16[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part17[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part18[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part19[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part20[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part21[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part22[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part23[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part24[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part25[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part26[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part27[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part28[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part29[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part30[31:00]            <= 32'd0; 
      o_recct_ia_wdata_part31[31:00]            <= 32'd0; 
      o_recct_ia_config[06:00]                  <= 7'd0; 
      o_recct_ia_config[10:07]                  <= 4'd0; 
      o_psr_ia_config[08:00]                    <= 9'd0; 
      o_psr_ia_config[12:09]                    <= 4'd0; 
      o_bimc_monitor_mask[00:00]                <= 1'd0; 
      o_bimc_monitor_mask[01:01]                <= 1'd0; 
      o_bimc_monitor_mask[02:02]                <= 1'd0; 
      o_bimc_monitor_mask[03:03]                <= 1'd0; 
      o_bimc_monitor_mask[04:04]                <= 1'd0; 
      o_bimc_monitor_mask[05:05]                <= 1'd0; 
      o_bimc_monitor_mask[06:06]                <= 1'd0; 
      o_bimc_ecc_uncorrectable_error_cnt[31:00] <= 32'd0; 
      o_bimc_ecc_correctable_error_cnt[31:00]   <= 32'd0; 
      o_bimc_parity_error_cnt[31:00]            <= 32'd0; 
      o_bimc_global_config[00:00]               <= 1'd1; 
      o_bimc_global_config[01:01]               <= 1'd0; 
      o_bimc_global_config[02:02]               <= 1'd0; 
      o_bimc_global_config[03:03]               <= 1'd0; 
      o_bimc_global_config[04:04]               <= 1'd0; 
      o_bimc_global_config[05:05]               <= 1'd0; 
      o_bimc_global_config[31:06]               <= 26'd0; 
      o_bimc_eccpar_debug[11:00]                <= 12'd0; 
      o_bimc_eccpar_debug[15:12]                <= 4'd0; 
      o_bimc_eccpar_debug[17:16]                <= 2'd0; 
      o_bimc_eccpar_debug[19:18]                <= 2'd0; 
      o_bimc_eccpar_debug[21:20]                <= 2'd0; 
      o_bimc_eccpar_debug[22:22]                <= 1'd0; 
      o_bimc_eccpar_debug[23:23]                <= 1'd0; 
      o_bimc_eccpar_debug[27:24]                <= 4'd0; 
      o_bimc_eccpar_debug[28:28]                <= 1'd0; 
      o_bimc_cmd2[07:00]                        <= 8'd0; 
      o_bimc_cmd2[08:08]                        <= 1'd0; 
      o_bimc_cmd2[09:09]                        <= 1'd0; 
      o_bimc_cmd2[10:10]                        <= 1'd0; 
      o_bimc_cmd1[15:00]                        <= 16'd0; 
      o_bimc_cmd1[27:16]                        <= 12'd0; 
      o_bimc_cmd1[31:28]                        <= 4'd0; 
      o_bimc_cmd0[31:00]                        <= 32'd0; 
      o_bimc_rxcmd2[07:00]                      <= 8'd0; 
      o_bimc_rxcmd2[08:08]                      <= 1'd0; 
      o_bimc_rxrsp2[07:00]                      <= 8'd0; 
      o_bimc_rxrsp2[08:08]                      <= 1'd0; 
      o_bimc_pollrsp2[07:00]                    <= 8'd0; 
      o_bimc_pollrsp2[08:08]                    <= 1'd0; 
      o_bimc_dbgcmd2[07:00]                     <= 8'd0; 
      o_bimc_dbgcmd2[08:08]                     <= 1'd0; 
    end
    else begin
      if(w_load_spare_config)                     o_spare_config[31:00]                     <= f32_data[31:00]; 
      if(w_load_regs_rec_us_ctrl)                 o_regs_rec_us_ctrl[00:00]                 <= f32_data[00:00]; 
      if(w_load_regs_rec_us_ctrl)                 o_regs_rec_us_ctrl[31:01]                 <= f32_data[31:01]; 
      if(w_load_regs_rec_debug_control)           o_regs_rec_debug_control[00:00]           <= f32_data[00:00]; 
      if(w_load_regs_rec_debug_control)           o_regs_rec_debug_control[31:01]           <= f32_data[31:01]; 
      if(w_load_regs_breakpoint_addr)             o_regs_breakpoint_addr[07:00]             <= f32_data[07:00]; 
      if(w_load_regs_breakpoint_addr)             o_regs_breakpoint_addr[31:08]             <= f32_data[31:08]; 
      if(w_load_regs_breakpoint_cont)             o_regs_breakpoint_cont[00:00]             <= f32_data[00:00]; 
      if(w_load_regs_breakpoint_cont)             o_regs_breakpoint_cont[31:01]             <= f32_data[31:01]; 
      if(w_load_regs_breakpoint_step)             o_regs_breakpoint_step[00:00]             <= f32_data[00:00]; 
      if(w_load_regs_breakpoint_step)             o_regs_breakpoint_step[31:01]             <= f32_data[31:01]; 
      if(w_load_regs_error_control)               o_regs_error_control[00:00]               <= f32_data[00:00]; 
      if(w_load_regs_error_control)               o_regs_error_control[31:01]               <= f32_data[31:01]; 
      if(w_load_regs_tlv_parse_action_0)          o_regs_tlv_parse_action_0[01:00]          <= f32_data[01:00]; 
      if(w_load_regs_tlv_parse_action_0)          o_regs_tlv_parse_action_0[03:02]          <= f32_data[03:02]; 
      if(w_load_regs_tlv_parse_action_0)          o_regs_tlv_parse_action_0[05:04]          <= f32_data[05:04]; 
      if(w_load_regs_tlv_parse_action_0)          o_regs_tlv_parse_action_0[07:06]          <= f32_data[07:06]; 
      if(w_load_regs_tlv_parse_action_0)          o_regs_tlv_parse_action_0[09:08]          <= f32_data[09:08]; 
      if(w_load_regs_tlv_parse_action_0)          o_regs_tlv_parse_action_0[11:10]          <= f32_data[11:10]; 
      if(w_load_regs_tlv_parse_action_0)          o_regs_tlv_parse_action_0[13:12]          <= f32_data[13:12]; 
      if(w_load_regs_tlv_parse_action_0)          o_regs_tlv_parse_action_0[15:14]          <= f32_data[15:14]; 
      if(w_load_regs_tlv_parse_action_0)          o_regs_tlv_parse_action_0[17:16]          <= f32_data[17:16]; 
      if(w_load_regs_tlv_parse_action_0)          o_regs_tlv_parse_action_0[19:18]          <= f32_data[19:18]; 
      if(w_load_regs_tlv_parse_action_0)          o_regs_tlv_parse_action_0[21:20]          <= f32_data[21:20]; 
      if(w_load_regs_tlv_parse_action_0)          o_regs_tlv_parse_action_0[23:22]          <= f32_data[23:22]; 
      if(w_load_regs_tlv_parse_action_0)          o_regs_tlv_parse_action_0[25:24]          <= f32_data[25:24]; 
      if(w_load_regs_tlv_parse_action_0)          o_regs_tlv_parse_action_0[27:26]          <= f32_data[27:26]; 
      if(w_load_regs_tlv_parse_action_0)          o_regs_tlv_parse_action_0[29:28]          <= f32_data[29:28]; 
      if(w_load_regs_tlv_parse_action_0)          o_regs_tlv_parse_action_0[31:30]          <= f32_data[31:30]; 
      if(w_load_regs_tlv_parse_action_1)          o_regs_tlv_parse_action_1[01:00]          <= f32_data[01:00]; 
      if(w_load_regs_tlv_parse_action_1)          o_regs_tlv_parse_action_1[03:02]          <= f32_data[03:02]; 
      if(w_load_regs_tlv_parse_action_1)          o_regs_tlv_parse_action_1[05:04]          <= f32_data[05:04]; 
      if(w_load_regs_tlv_parse_action_1)          o_regs_tlv_parse_action_1[07:06]          <= f32_data[07:06]; 
      if(w_load_regs_tlv_parse_action_1)          o_regs_tlv_parse_action_1[09:08]          <= f32_data[09:08]; 
      if(w_load_regs_tlv_parse_action_1)          o_regs_tlv_parse_action_1[11:10]          <= f32_data[11:10]; 
      if(w_load_regs_tlv_parse_action_1)          o_regs_tlv_parse_action_1[13:12]          <= f32_data[13:12]; 
      if(w_load_regs_tlv_parse_action_1)          o_regs_tlv_parse_action_1[15:14]          <= f32_data[15:14]; 
      if(w_load_regs_tlv_parse_action_1)          o_regs_tlv_parse_action_1[17:16]          <= f32_data[17:16]; 
      if(w_load_regs_tlv_parse_action_1)          o_regs_tlv_parse_action_1[19:18]          <= f32_data[19:18]; 
      if(w_load_regs_tlv_parse_action_1)          o_regs_tlv_parse_action_1[21:20]          <= f32_data[21:20]; 
      if(w_load_regs_tlv_parse_action_1)          o_regs_tlv_parse_action_1[23:22]          <= f32_data[23:22]; 
      if(w_load_regs_tlv_parse_action_1)          o_regs_tlv_parse_action_1[25:24]          <= f32_data[25:24]; 
      if(w_load_regs_tlv_parse_action_1)          o_regs_tlv_parse_action_1[27:26]          <= f32_data[27:26]; 
      if(w_load_regs_tlv_parse_action_1)          o_regs_tlv_parse_action_1[29:28]          <= f32_data[29:28]; 
      if(w_load_regs_tlv_parse_action_1)          o_regs_tlv_parse_action_1[31:30]          <= f32_data[31:30]; 
      if(w_load_feature_ia_wdata_part0)           o_feature_ia_wdata_part0[07:00]           <= f32_data[07:00]; 
      if(w_load_feature_ia_wdata_part0)           o_feature_ia_wdata_part0[15:08]           <= f32_data[15:08]; 
      if(w_load_feature_ia_wdata_part0)           o_feature_ia_wdata_part0[23:16]           <= f32_data[23:16]; 
      if(w_load_feature_ia_wdata_part0)           o_feature_ia_wdata_part0[31:24]           <= f32_data[31:24]; 
      if(w_load_feature_ia_wdata_part1)           o_feature_ia_wdata_part1[01:00]           <= f32_data[01:00]; 
      if(w_load_feature_ia_wdata_part1)           o_feature_ia_wdata_part1[02:02]           <= f32_data[02:02]; 
      if(w_load_feature_ia_wdata_part1)           o_feature_ia_wdata_part1[03:03]           <= f32_data[03:03]; 
      if(w_load_feature_ia_wdata_part1)           o_feature_ia_wdata_part1[05:04]           <= f32_data[05:04]; 
      if(w_load_feature_ia_wdata_part1)           o_feature_ia_wdata_part1[06:06]           <= f32_data[06:06]; 
      if(w_load_feature_ia_wdata_part1)           o_feature_ia_wdata_part1[07:07]           <= f32_data[07:07]; 
      if(w_load_feature_ia_wdata_part1)           o_feature_ia_wdata_part1[09:08]           <= f32_data[09:08]; 
      if(w_load_feature_ia_wdata_part1)           o_feature_ia_wdata_part1[10:10]           <= f32_data[10:10]; 
      if(w_load_feature_ia_wdata_part1)           o_feature_ia_wdata_part1[11:11]           <= f32_data[11:11]; 
      if(w_load_feature_ia_wdata_part1)           o_feature_ia_wdata_part1[13:12]           <= f32_data[13:12]; 
      if(w_load_feature_ia_wdata_part1)           o_feature_ia_wdata_part1[14:14]           <= f32_data[14:14]; 
      if(w_load_feature_ia_wdata_part1)           o_feature_ia_wdata_part1[15:15]           <= f32_data[15:15]; 
      if(w_load_feature_ia_wdata_part1)           o_feature_ia_wdata_part1[31:16]           <= f32_data[31:16]; 
      if(w_load_feature_ia_config)                o_feature_ia_config[07:00]                <= f32_data[07:00]; 
      if(w_load_feature_ia_config)                o_feature_ia_config[11:08]                <= f32_data[31:28]; 
      if(w_load_feature_ctr_ia_wdata_part0)       o_feature_ctr_ia_wdata_part0[07:00]       <= f32_data[07:00]; 
      if(w_load_feature_ctr_ia_wdata_part0)       o_feature_ctr_ia_wdata_part0[31:08]       <= f32_data[31:08]; 
      if(w_load_feature_ctr_ia_config)            o_feature_ctr_ia_config[07:00]            <= f32_data[07:00]; 
      if(w_load_feature_ctr_ia_config)            o_feature_ctr_ia_config[11:08]            <= f32_data[31:28]; 
      if(w_load_recim_ia_wdata_part0)             o_recim_ia_wdata_part0[00:00]             <= f32_data[00:00]; 
      if(w_load_recim_ia_wdata_part0)             o_recim_ia_wdata_part0[01:01]             <= f32_data[01:01]; 
      if(w_load_recim_ia_wdata_part0)             o_recim_ia_wdata_part0[09:02]             <= f32_data[09:02]; 
      if(w_load_recim_ia_wdata_part0)             o_recim_ia_wdata_part0[17:10]             <= f32_data[17:10]; 
      if(w_load_recim_ia_wdata_part0)             o_recim_ia_wdata_part0[21:18]             <= f32_data[21:18]; 
      if(w_load_recim_ia_wdata_part0)             o_recim_ia_wdata_part0[23:22]             <= f32_data[23:22]; 
      if(w_load_recim_ia_config)                  o_recim_ia_config[07:00]                  <= f32_data[07:00]; 
      if(w_load_recim_ia_config)                  o_recim_ia_config[11:08]                  <= f32_data[31:28]; 
      if(w_load_recsat_ia_wdata_part0)            o_recsat_ia_wdata_part0[31:00]            <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part1)            o_recsat_ia_wdata_part1[31:00]            <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part2)            o_recsat_ia_wdata_part2[31:00]            <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part3)            o_recsat_ia_wdata_part3[31:00]            <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part4)            o_recsat_ia_wdata_part4[31:00]            <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part5)            o_recsat_ia_wdata_part5[31:00]            <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part6)            o_recsat_ia_wdata_part6[31:00]            <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part7)            o_recsat_ia_wdata_part7[31:00]            <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part8)            o_recsat_ia_wdata_part8[31:00]            <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part9)            o_recsat_ia_wdata_part9[31:00]            <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part10)           o_recsat_ia_wdata_part10[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part11)           o_recsat_ia_wdata_part11[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part12)           o_recsat_ia_wdata_part12[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part13)           o_recsat_ia_wdata_part13[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part14)           o_recsat_ia_wdata_part14[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part15)           o_recsat_ia_wdata_part15[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part16)           o_recsat_ia_wdata_part16[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part17)           o_recsat_ia_wdata_part17[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part18)           o_recsat_ia_wdata_part18[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part19)           o_recsat_ia_wdata_part19[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part20)           o_recsat_ia_wdata_part20[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part21)           o_recsat_ia_wdata_part21[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part22)           o_recsat_ia_wdata_part22[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part23)           o_recsat_ia_wdata_part23[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part24)           o_recsat_ia_wdata_part24[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part25)           o_recsat_ia_wdata_part25[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part26)           o_recsat_ia_wdata_part26[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part27)           o_recsat_ia_wdata_part27[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part28)           o_recsat_ia_wdata_part28[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part29)           o_recsat_ia_wdata_part29[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part30)           o_recsat_ia_wdata_part30[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_wdata_part31)           o_recsat_ia_wdata_part31[31:00]           <= f32_data[31:00]; 
      if(w_load_recsat_ia_config)                 o_recsat_ia_config[06:00]                 <= f32_data[06:00]; 
      if(w_load_recsat_ia_config)                 o_recsat_ia_config[10:07]                 <= f32_data[31:28]; 
      if(w_load_recct_ia_wdata_part0)             o_recct_ia_wdata_part0[31:00]             <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part1)             o_recct_ia_wdata_part1[31:00]             <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part2)             o_recct_ia_wdata_part2[31:00]             <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part3)             o_recct_ia_wdata_part3[31:00]             <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part4)             o_recct_ia_wdata_part4[31:00]             <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part5)             o_recct_ia_wdata_part5[31:00]             <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part6)             o_recct_ia_wdata_part6[31:00]             <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part7)             o_recct_ia_wdata_part7[31:00]             <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part8)             o_recct_ia_wdata_part8[31:00]             <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part9)             o_recct_ia_wdata_part9[31:00]             <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part10)            o_recct_ia_wdata_part10[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part11)            o_recct_ia_wdata_part11[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part12)            o_recct_ia_wdata_part12[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part13)            o_recct_ia_wdata_part13[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part14)            o_recct_ia_wdata_part14[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part15)            o_recct_ia_wdata_part15[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part16)            o_recct_ia_wdata_part16[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part17)            o_recct_ia_wdata_part17[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part18)            o_recct_ia_wdata_part18[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part19)            o_recct_ia_wdata_part19[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part20)            o_recct_ia_wdata_part20[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part21)            o_recct_ia_wdata_part21[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part22)            o_recct_ia_wdata_part22[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part23)            o_recct_ia_wdata_part23[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part24)            o_recct_ia_wdata_part24[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part25)            o_recct_ia_wdata_part25[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part26)            o_recct_ia_wdata_part26[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part27)            o_recct_ia_wdata_part27[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part28)            o_recct_ia_wdata_part28[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part29)            o_recct_ia_wdata_part29[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part30)            o_recct_ia_wdata_part30[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_wdata_part31)            o_recct_ia_wdata_part31[31:00]            <= f32_data[31:00]; 
      if(w_load_recct_ia_config)                  o_recct_ia_config[06:00]                  <= f32_data[06:00]; 
      if(w_load_recct_ia_config)                  o_recct_ia_config[10:07]                  <= f32_data[31:28]; 
      if(w_load_psr_ia_config)                    o_psr_ia_config[08:00]                    <= f32_data[08:00]; 
      if(w_load_psr_ia_config)                    o_psr_ia_config[12:09]                    <= f32_data[31:28]; 
      if(w_load_bimc_monitor_mask)                o_bimc_monitor_mask[00:00]                <= f32_data[00:00]; 
      if(w_load_bimc_monitor_mask)                o_bimc_monitor_mask[01:01]                <= f32_data[01:01]; 
      if(w_load_bimc_monitor_mask)                o_bimc_monitor_mask[02:02]                <= f32_data[02:02]; 
      if(w_load_bimc_monitor_mask)                o_bimc_monitor_mask[03:03]                <= f32_data[03:03]; 
      if(w_load_bimc_monitor_mask)                o_bimc_monitor_mask[04:04]                <= f32_data[04:04]; 
      if(w_load_bimc_monitor_mask)                o_bimc_monitor_mask[05:05]                <= f32_data[05:05]; 
      if(w_load_bimc_monitor_mask)                o_bimc_monitor_mask[06:06]                <= f32_data[06:06]; 
      if(w_load_bimc_ecc_uncorrectable_error_cnt) o_bimc_ecc_uncorrectable_error_cnt[31:00] <= f32_data[31:00]; 
      if(w_load_bimc_ecc_correctable_error_cnt)   o_bimc_ecc_correctable_error_cnt[31:00]   <= f32_data[31:00]; 
      if(w_load_bimc_parity_error_cnt)            o_bimc_parity_error_cnt[31:00]            <= f32_data[31:00]; 
      if(w_load_bimc_global_config)               o_bimc_global_config[00:00]               <= f32_data[00:00]; 
      if(w_load_bimc_global_config)               o_bimc_global_config[01:01]               <= f32_data[01:01]; 
      if(w_load_bimc_global_config)               o_bimc_global_config[02:02]               <= f32_data[02:02]; 
      if(w_load_bimc_global_config)               o_bimc_global_config[03:03]               <= f32_data[03:03]; 
      if(w_load_bimc_global_config)               o_bimc_global_config[04:04]               <= f32_data[04:04]; 
      if(w_load_bimc_global_config)               o_bimc_global_config[05:05]               <= f32_data[05:05]; 
      if(w_load_bimc_global_config)               o_bimc_global_config[31:06]               <= f32_data[31:06]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[11:00]                <= f32_data[11:00]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[15:12]                <= f32_data[15:12]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[17:16]                <= f32_data[17:16]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[19:18]                <= f32_data[19:18]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[21:20]                <= f32_data[21:20]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[22:22]                <= f32_data[22:22]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[23:23]                <= f32_data[23:23]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[27:24]                <= f32_data[27:24]; 
      if(w_load_bimc_eccpar_debug)                o_bimc_eccpar_debug[28:28]                <= f32_data[28:28]; 
      if(w_load_bimc_cmd2)                        o_bimc_cmd2[07:00]                        <= f32_data[07:00]; 
      if(w_load_bimc_cmd2)                        o_bimc_cmd2[08:08]                        <= f32_data[08:08]; 
      if(w_load_bimc_cmd2)                        o_bimc_cmd2[09:09]                        <= f32_data[09:09]; 
      if(w_load_bimc_cmd2)                        o_bimc_cmd2[10:10]                        <= f32_data[10:10]; 
      if(w_load_bimc_cmd1)                        o_bimc_cmd1[15:00]                        <= f32_data[15:00]; 
      if(w_load_bimc_cmd1)                        o_bimc_cmd1[27:16]                        <= f32_data[27:16]; 
      if(w_load_bimc_cmd1)                        o_bimc_cmd1[31:28]                        <= f32_data[31:28]; 
      if(w_load_bimc_cmd0)                        o_bimc_cmd0[31:00]                        <= f32_data[31:00]; 
      if(w_load_bimc_rxcmd2)                      o_bimc_rxcmd2[07:00]                      <= f32_data[07:00]; 
      if(w_load_bimc_rxcmd2)                      o_bimc_rxcmd2[08:08]                      <= f32_data[08:08]; 
      if(w_load_bimc_rxrsp2)                      o_bimc_rxrsp2[07:00]                      <= f32_data[07:00]; 
      if(w_load_bimc_rxrsp2)                      o_bimc_rxrsp2[08:08]                      <= f32_data[08:08]; 
      if(w_load_bimc_pollrsp2)                    o_bimc_pollrsp2[07:00]                    <= f32_data[07:00]; 
      if(w_load_bimc_pollrsp2)                    o_bimc_pollrsp2[08:08]                    <= f32_data[08:08]; 
      if(w_load_bimc_dbgcmd2)                     o_bimc_dbgcmd2[07:00]                     <= f32_data[07:00]; 
      if(w_load_bimc_dbgcmd2)                     o_bimc_dbgcmd2[08:08]                     <= f32_data[08:08]; 
    end
  end

  
  
  
  always_ff @(posedge clk) begin
      if(w_load_psr_ia_wdata_part0)               o_psr_ia_wdata_part0[31:00]               <= f32_data[31:00]; 
      if(w_load_bimc_rxcmd2)                      o_bimc_rxcmd2[09:09]                      <= f32_data[09:09]; 
      if(w_load_bimc_rxrsp2)                      o_bimc_rxrsp2[09:09]                      <= f32_data[09:09]; 
      if(w_load_bimc_pollrsp2)                    o_bimc_pollrsp2[09:09]                    <= f32_data[09:09]; 
      if(w_load_bimc_dbgcmd2)                     o_bimc_dbgcmd2[09:09]                     <= f32_data[09:09]; 
  end
  

  

endmodule
