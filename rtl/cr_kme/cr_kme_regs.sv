/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/












`include "cr_kme.vh"




module cr_kme_regs (
  input                                         clk,
  input                                         i_reset_,
  input                                         i_sw_init,

  
  input      [`CR_KME_DECL]                     i_addr,
  input                                         i_wr_strb,
  input      [31:0]                             i_wr_data,
  input                                         i_rd_strb,
  output     [31:0]                             o_rd_data,
  output                                        o_ack,
  output                                        o_err_ack,

  
  output     [`CR_KME_C_SPARE_T_DECL]           o_spare_config,
  output     [`CR_KME_C_CCEIP0_OUT_PART0_T_DECL] o_cceip0_out_ia_wdata_part0,
  output     [`CR_KME_C_CCEIP0_OUT_PART1_T_DECL] o_cceip0_out_ia_wdata_part1,
  output     [`CR_KME_C_CCEIP0_OUT_PART2_T_DECL] o_cceip0_out_ia_wdata_part2,
  output     [`CR_KME_C_CCEIP0_OUT_IA_CONFIG_T_DECL] o_cceip0_out_ia_config,
  output     [`CR_KME_C_CCEIP0_OUT_IM_CONFIG_T_DECL] o_cceip0_out_im_config,
  output     [`CR_KME_C_CCEIP0_OUT_IM_CONSUMED_T_DECL] o_cceip0_out_im_read_done,
  output     [`CR_KME_C_CCEIP1_OUT_PART0_T_DECL] o_cceip1_out_ia_wdata_part0,
  output     [`CR_KME_C_CCEIP1_OUT_PART1_T_DECL] o_cceip1_out_ia_wdata_part1,
  output     [`CR_KME_C_CCEIP1_OUT_PART2_T_DECL] o_cceip1_out_ia_wdata_part2,
  output     [`CR_KME_C_CCEIP1_OUT_IA_CONFIG_T_DECL] o_cceip1_out_ia_config,
  output     [`CR_KME_C_CCEIP1_OUT_IM_CONFIG_T_DECL] o_cceip1_out_im_config,
  output     [`CR_KME_C_CCEIP1_OUT_IM_CONSUMED_T_DECL] o_cceip1_out_im_read_done,
  output     [`CR_KME_C_CCEIP2_OUT_PART0_T_DECL] o_cceip2_out_ia_wdata_part0,
  output     [`CR_KME_C_CCEIP2_OUT_PART1_T_DECL] o_cceip2_out_ia_wdata_part1,
  output     [`CR_KME_C_CCEIP2_OUT_PART2_T_DECL] o_cceip2_out_ia_wdata_part2,
  output     [`CR_KME_C_CCEIP2_OUT_IA_CONFIG_T_DECL] o_cceip2_out_ia_config,
  output     [`CR_KME_C_CCEIP2_OUT_IM_CONFIG_T_DECL] o_cceip2_out_im_config,
  output     [`CR_KME_C_CCEIP2_OUT_IM_CONSUMED_T_DECL] o_cceip2_out_im_read_done,
  output     [`CR_KME_C_CCEIP3_OUT_PART0_T_DECL] o_cceip3_out_ia_wdata_part0,
  output     [`CR_KME_C_CCEIP3_OUT_PART1_T_DECL] o_cceip3_out_ia_wdata_part1,
  output     [`CR_KME_C_CCEIP3_OUT_PART2_T_DECL] o_cceip3_out_ia_wdata_part2,
  output     [`CR_KME_C_CCEIP3_OUT_IA_CONFIG_T_DECL] o_cceip3_out_ia_config,
  output     [`CR_KME_C_CCEIP3_OUT_IM_CONFIG_T_DECL] o_cceip3_out_im_config,
  output     [`CR_KME_C_CCEIP3_OUT_IM_CONSUMED_T_DECL] o_cceip3_out_im_read_done,
  output     [`CR_KME_C_CDDIP0_OUT_PART0_T_DECL] o_cddip0_out_ia_wdata_part0,
  output     [`CR_KME_C_CDDIP0_OUT_PART1_T_DECL] o_cddip0_out_ia_wdata_part1,
  output     [`CR_KME_C_CDDIP0_OUT_PART2_T_DECL] o_cddip0_out_ia_wdata_part2,
  output     [`CR_KME_C_CDDIP0_OUT_IA_CONFIG_T_DECL] o_cddip0_out_ia_config,
  output     [`CR_KME_C_CDDIP0_OUT_IM_CONFIG_T_DECL] o_cddip0_out_im_config,
  output     [`CR_KME_C_CDDIP0_OUT_IM_CONSUMED_T_DECL] o_cddip0_out_im_read_done,
  output     [`CR_KME_C_CDDIP1_OUT_PART0_T_DECL] o_cddip1_out_ia_wdata_part0,
  output     [`CR_KME_C_CDDIP1_OUT_PART1_T_DECL] o_cddip1_out_ia_wdata_part1,
  output     [`CR_KME_C_CDDIP1_OUT_PART2_T_DECL] o_cddip1_out_ia_wdata_part2,
  output     [`CR_KME_C_CDDIP1_OUT_IA_CONFIG_T_DECL] o_cddip1_out_ia_config,
  output     [`CR_KME_C_CDDIP1_OUT_IM_CONFIG_T_DECL] o_cddip1_out_im_config,
  output     [`CR_KME_C_CDDIP1_OUT_IM_CONSUMED_T_DECL] o_cddip1_out_im_read_done,
  output     [`CR_KME_C_CDDIP2_OUT_PART0_T_DECL] o_cddip2_out_ia_wdata_part0,
  output     [`CR_KME_C_CDDIP2_OUT_PART1_T_DECL] o_cddip2_out_ia_wdata_part1,
  output     [`CR_KME_C_CDDIP2_OUT_PART2_T_DECL] o_cddip2_out_ia_wdata_part2,
  output     [`CR_KME_C_CDDIP2_OUT_IA_CONFIG_T_DECL] o_cddip2_out_ia_config,
  output     [`CR_KME_C_CDDIP2_OUT_IM_CONFIG_T_DECL] o_cddip2_out_im_config,
  output     [`CR_KME_C_CDDIP2_OUT_IM_CONSUMED_T_DECL] o_cddip2_out_im_read_done,
  output     [`CR_KME_C_CDDIP3_OUT_PART0_T_DECL] o_cddip3_out_ia_wdata_part0,
  output     [`CR_KME_C_CDDIP3_OUT_PART1_T_DECL] o_cddip3_out_ia_wdata_part1,
  output     [`CR_KME_C_CDDIP3_OUT_PART2_T_DECL] o_cddip3_out_ia_wdata_part2,
  output     [`CR_KME_C_CDDIP3_OUT_IA_CONFIG_T_DECL] o_cddip3_out_ia_config,
  output     [`CR_KME_C_CDDIP3_OUT_IM_CONFIG_T_DECL] o_cddip3_out_im_config,
  output     [`CR_KME_C_CDDIP3_OUT_IM_CONSUMED_T_DECL] o_cddip3_out_im_read_done,
  output     [`CR_KME_C_CKV_PART0_T_DECL]       o_ckv_ia_wdata_part0,
  output     [`CR_KME_C_CKV_PART1_T_DECL]       o_ckv_ia_wdata_part1,
  output     [`CR_KME_C_CKV_IA_CONFIG_T_DECL]   o_ckv_ia_config,
  output     [`CR_KME_C_KIM_ENTRY0_T_DECL]      o_kim_ia_wdata_part0,
  output     [`CR_KME_C_KIM_ENTRY1_T_DECL]      o_kim_ia_wdata_part1,
  output     [`CR_KME_C_KIM_IA_CONFIG_T_DECL]   o_kim_ia_config,
  output     [`CR_KME_C_LABEL_METADATA_T_DECL]  o_label0_config,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label0_data7,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label0_data6,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label0_data5,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label0_data4,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label0_data3,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label0_data2,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label0_data1,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label0_data0,
  output     [`CR_KME_C_LABEL_METADATA_T_DECL]  o_label1_config,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label1_data7,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label1_data6,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label1_data5,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label1_data4,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label1_data3,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label1_data2,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label1_data1,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label1_data0,
  output     [`CR_KME_C_LABEL_METADATA_T_DECL]  o_label2_config,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label2_data7,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label2_data6,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label2_data5,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label2_data4,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label2_data3,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label2_data2,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label2_data1,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label2_data0,
  output     [`CR_KME_C_LABEL_METADATA_T_DECL]  o_label3_config,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label3_data7,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label3_data6,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label3_data5,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label3_data4,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label3_data3,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label3_data2,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label3_data1,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label3_data0,
  output     [`CR_KME_C_LABEL_METADATA_T_DECL]  o_label4_config,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label4_data7,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label4_data6,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label4_data5,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label4_data4,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label4_data3,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label4_data2,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label4_data1,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label4_data0,
  output     [`CR_KME_C_LABEL_METADATA_T_DECL]  o_label5_config,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label5_data7,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label5_data6,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label5_data5,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label5_data4,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label5_data3,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label5_data2,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label5_data1,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label5_data0,
  output     [`CR_KME_C_LABEL_METADATA_T_DECL]  o_label6_config,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label6_data7,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label6_data6,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label6_data5,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label6_data4,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label6_data3,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label6_data2,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label6_data1,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label6_data0,
  output     [`CR_KME_C_LABEL_METADATA_T_DECL]  o_label7_config,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label7_data7,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label7_data6,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label7_data5,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label7_data4,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label7_data3,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label7_data2,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label7_data1,
  output     [`CR_KME_C_LABEL_DATA_T_DECL]      o_label7_data0,
  output     [`CR_KME_C_KDF_DRBG_CTRL_T_DECL]   o_kdf_drbg_ctrl,
  output     [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_31_0,
  output     [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_63_32,
  output     [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_95_64,
  output     [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_127_96,
  output     [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_159_128,
  output     [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_191_160,
  output     [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_223_192,
  output     [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_255_224,
  output     [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_0_state_value_31_0,
  output     [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_0_state_value_63_32,
  output     [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_0_state_value_95_64,
  output     [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_0_state_value_127_96,
  output     [`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_0_T_DECL] o_kdf_drbg_seed_0_reseed_interval_0,
  output     [`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_1_T_DECL] o_kdf_drbg_seed_0_reseed_interval_1,
  output     [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_31_0,
  output     [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_63_32,
  output     [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_95_64,
  output     [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_127_96,
  output     [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_159_128,
  output     [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_191_160,
  output     [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_223_192,
  output     [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_255_224,
  output     [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_1_state_value_31_0,
  output     [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_1_state_value_63_32,
  output     [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_1_state_value_95_64,
  output     [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_1_state_value_127_96,
  output     [`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_0_T_DECL] o_kdf_drbg_seed_1_reseed_interval_0,
  output     [`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_1_T_DECL] o_kdf_drbg_seed_1_reseed_interval_1,
  output     [`CR_KME_C_INT_STATUS_T_DECL]      o_interrupt_status,
  output     [`CR_KME_C_INT_MASK_T_DECL]        o_interrupt_mask,
  output     [`CR_KME_C_STICKY_ENG_BP_T_DECL]   o_engine_sticky_status,
  output     [`CR_KME_C_BIMC_MONITOR_MASK_T_DECL] o_bimc_monitor_mask,
  output     [`CR_KME_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_uncorrectable_error_cnt,
  output     [`CR_KME_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_correctable_error_cnt,
  output     [`CR_KME_C_BIMC_PARITY_ERROR_CNT_T_DECL] o_bimc_parity_error_cnt,
  output     [`CR_KME_C_BIMC_GLOBAL_CONFIG_T_DECL] o_bimc_global_config,
  output     [`CR_KME_C_BIMC_ECCPAR_DEBUG_T_DECL] o_bimc_eccpar_debug,
  output     [`CR_KME_C_BIMC_CMD2_T_DECL]       o_bimc_cmd2,
  output     [`CR_KME_C_BIMC_CMD1_T_DECL]       o_bimc_cmd1,
  output     [`CR_KME_C_BIMC_CMD0_T_DECL]       o_bimc_cmd0,
  output     [`CR_KME_C_BIMC_RXCMD2_T_DECL]     o_bimc_rxcmd2,
  output     [`CR_KME_C_BIMC_RXRSP2_T_DECL]     o_bimc_rxrsp2,
  output     [`CR_KME_C_BIMC_POLLRSP2_T_DECL]   o_bimc_pollrsp2,
  output     [`CR_KME_C_BIMC_DBGCMD2_T_DECL]    o_bimc_dbgcmd2,
  output     [`CR_KME_C_IM_CONSUMED_T_DECL]     o_im_consumed,
  output     [`CR_KME_C_TREADY_OVERRIDE_T_DECL] o_tready_override,
  output     [`CR_KME_C_SA_CTRL_DEP_T_DECL]     o_regs_sa_ctrl,
  output     [`CR_KME_C_SA_SNAPSHOT_PART1_T_DECL] o_sa_snapshot_ia_wdata_part0,
  output     [`CR_KME_C_SA_SNAPSHOT_PART0_T_DECL] o_sa_snapshot_ia_wdata_part1,
  output     [`CR_KME_C_SA_SNAPSHOT_IA_CONFIG_T_DECL] o_sa_snapshot_ia_config,
  output     [`CR_KME_C_SA_COUNT_PART1_T_DECL]  o_sa_count_ia_wdata_part0,
  output     [`CR_KME_C_SA_COUNT_PART0_T_DECL]  o_sa_count_ia_wdata_part1,
  output     [`CR_KME_C_SA_COUNT_IA_CONFIG_T_DECL] o_sa_count_ia_config,
  output     [`CR_KME_C_KOP_FIFO_OVERRIDE_T_DECL] o_cceip_encrypt_kop_fifo_override,
  output     [`CR_KME_C_KOP_FIFO_OVERRIDE_T_DECL] o_cceip_validate_kop_fifo_override,
  output     [`CR_KME_C_KOP_FIFO_OVERRIDE_T_DECL] o_cddip_decrypt_kop_fifo_override,
  output     [`CR_KME_C_SA_GLOBAL_CTRL_T_DECL]  o_sa_global_ctrl,
  output     [`CR_KME_C_SA_CTRL_T_DECL]         o_sa_ctrl_ia_wdata_part0,
  output     [`CR_KME_C_SA_CTRL_IA_CONFIG_T_DECL] o_sa_ctrl_ia_config,
  output     [`CR_KME_C_KDF_TEST_KEY_SIZE_T_DECL] o_kdf_test_key_size_config,

  
  input      [`CR_KME_C_BLKID_REVID_T_DECL]     i_blkid_revid_config,
  input      [`CR_KME_C_REVID_T_DECL]           i_revision_config,
  input      [`CR_KME_C_SPARE_T_DECL]           i_spare_config,
  input      [`CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_DECL] i_cceip0_out_ia_capability,
  input      [`CR_KME_C_CCEIP0_OUT_IA_STATUS_T_DECL] i_cceip0_out_ia_status,
  input      [`CR_KME_C_CCEIP0_OUT_PART0_T_DECL] i_cceip0_out_ia_rdata_part0,
  input      [`CR_KME_C_CCEIP0_OUT_PART1_T_DECL] i_cceip0_out_ia_rdata_part1,
  input      [`CR_KME_C_CCEIP0_OUT_PART2_T_DECL] i_cceip0_out_ia_rdata_part2,
  input      [`CR_KME_C_CCEIP0_OUT_IM_STATUS_T_DECL] i_cceip0_out_im_status,
  input      [`CR_KME_C_CCEIP0_OUT_IM_CONSUMED_T_DECL] i_cceip0_out_im_read_done,
  input      [`CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_DECL] i_cceip1_out_ia_capability,
  input      [`CR_KME_C_CCEIP1_OUT_IA_STATUS_T_DECL] i_cceip1_out_ia_status,
  input      [`CR_KME_C_CCEIP1_OUT_PART0_T_DECL] i_cceip1_out_ia_rdata_part0,
  input      [`CR_KME_C_CCEIP1_OUT_PART1_T_DECL] i_cceip1_out_ia_rdata_part1,
  input      [`CR_KME_C_CCEIP1_OUT_PART2_T_DECL] i_cceip1_out_ia_rdata_part2,
  input      [`CR_KME_C_CCEIP1_OUT_IM_STATUS_T_DECL] i_cceip1_out_im_status,
  input      [`CR_KME_C_CCEIP1_OUT_IM_CONSUMED_T_DECL] i_cceip1_out_im_read_done,
  input      [`CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_DECL] i_cceip2_out_ia_capability,
  input      [`CR_KME_C_CCEIP2_OUT_IA_STATUS_T_DECL] i_cceip2_out_ia_status,
  input      [`CR_KME_C_CCEIP2_OUT_PART0_T_DECL] i_cceip2_out_ia_rdata_part0,
  input      [`CR_KME_C_CCEIP2_OUT_PART1_T_DECL] i_cceip2_out_ia_rdata_part1,
  input      [`CR_KME_C_CCEIP2_OUT_PART2_T_DECL] i_cceip2_out_ia_rdata_part2,
  input      [`CR_KME_C_CCEIP2_OUT_IM_STATUS_T_DECL] i_cceip2_out_im_status,
  input      [`CR_KME_C_CCEIP2_OUT_IM_CONSUMED_T_DECL] i_cceip2_out_im_read_done,
  input      [`CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_DECL] i_cceip3_out_ia_capability,
  input      [`CR_KME_C_CCEIP3_OUT_IA_STATUS_T_DECL] i_cceip3_out_ia_status,
  input      [`CR_KME_C_CCEIP3_OUT_PART0_T_DECL] i_cceip3_out_ia_rdata_part0,
  input      [`CR_KME_C_CCEIP3_OUT_PART1_T_DECL] i_cceip3_out_ia_rdata_part1,
  input      [`CR_KME_C_CCEIP3_OUT_PART2_T_DECL] i_cceip3_out_ia_rdata_part2,
  input      [`CR_KME_C_CCEIP3_OUT_IM_STATUS_T_DECL] i_cceip3_out_im_status,
  input      [`CR_KME_C_CCEIP3_OUT_IM_CONSUMED_T_DECL] i_cceip3_out_im_read_done,
  input      [`CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_DECL] i_cddip0_out_ia_capability,
  input      [`CR_KME_C_CDDIP0_OUT_IA_STATUS_T_DECL] i_cddip0_out_ia_status,
  input      [`CR_KME_C_CDDIP0_OUT_PART0_T_DECL] i_cddip0_out_ia_rdata_part0,
  input      [`CR_KME_C_CDDIP0_OUT_PART1_T_DECL] i_cddip0_out_ia_rdata_part1,
  input      [`CR_KME_C_CDDIP0_OUT_PART2_T_DECL] i_cddip0_out_ia_rdata_part2,
  input      [`CR_KME_C_CDDIP0_OUT_IM_STATUS_T_DECL] i_cddip0_out_im_status,
  input      [`CR_KME_C_CDDIP0_OUT_IM_CONSUMED_T_DECL] i_cddip0_out_im_read_done,
  input      [`CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_DECL] i_cddip1_out_ia_capability,
  input      [`CR_KME_C_CDDIP1_OUT_IA_STATUS_T_DECL] i_cddip1_out_ia_status,
  input      [`CR_KME_C_CDDIP1_OUT_PART0_T_DECL] i_cddip1_out_ia_rdata_part0,
  input      [`CR_KME_C_CDDIP1_OUT_PART1_T_DECL] i_cddip1_out_ia_rdata_part1,
  input      [`CR_KME_C_CDDIP1_OUT_PART2_T_DECL] i_cddip1_out_ia_rdata_part2,
  input      [`CR_KME_C_CDDIP1_OUT_IM_STATUS_T_DECL] i_cddip1_out_im_status,
  input      [`CR_KME_C_CDDIP1_OUT_IM_CONSUMED_T_DECL] i_cddip1_out_im_read_done,
  input      [`CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_DECL] i_cddip2_out_ia_capability,
  input      [`CR_KME_C_CDDIP2_OUT_IA_STATUS_T_DECL] i_cddip2_out_ia_status,
  input      [`CR_KME_C_CDDIP2_OUT_PART0_T_DECL] i_cddip2_out_ia_rdata_part0,
  input      [`CR_KME_C_CDDIP2_OUT_PART1_T_DECL] i_cddip2_out_ia_rdata_part1,
  input      [`CR_KME_C_CDDIP2_OUT_PART2_T_DECL] i_cddip2_out_ia_rdata_part2,
  input      [`CR_KME_C_CDDIP2_OUT_IM_STATUS_T_DECL] i_cddip2_out_im_status,
  input      [`CR_KME_C_CDDIP2_OUT_IM_CONSUMED_T_DECL] i_cddip2_out_im_read_done,
  input      [`CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_DECL] i_cddip3_out_ia_capability,
  input      [`CR_KME_C_CDDIP3_OUT_IA_STATUS_T_DECL] i_cddip3_out_ia_status,
  input      [`CR_KME_C_CDDIP3_OUT_PART0_T_DECL] i_cddip3_out_ia_rdata_part0,
  input      [`CR_KME_C_CDDIP3_OUT_PART1_T_DECL] i_cddip3_out_ia_rdata_part1,
  input      [`CR_KME_C_CDDIP3_OUT_PART2_T_DECL] i_cddip3_out_ia_rdata_part2,
  input      [`CR_KME_C_CDDIP3_OUT_IM_STATUS_T_DECL] i_cddip3_out_im_status,
  input      [`CR_KME_C_CDDIP3_OUT_IM_CONSUMED_T_DECL] i_cddip3_out_im_read_done,
  input      [`CR_KME_C_CKV_IA_CAPABILITY_T_DECL] i_ckv_ia_capability,
  input      [`CR_KME_C_CKV_IA_STATUS_T_DECL]   i_ckv_ia_status,
  input      [`CR_KME_C_CKV_PART0_T_DECL]       i_ckv_ia_rdata_part0,
  input      [`CR_KME_C_CKV_PART1_T_DECL]       i_ckv_ia_rdata_part1,
  input      [`CR_KME_C_KIM_IA_CAPABILITY_T_DECL] i_kim_ia_capability,
  input      [`CR_KME_C_KIM_IA_STATUS_T_DECL]   i_kim_ia_status,
  input      [`CR_KME_C_KIM_ENTRY0_T_DECL]      i_kim_ia_rdata_part0,
  input      [`CR_KME_C_KIM_ENTRY1_T_DECL]      i_kim_ia_rdata_part1,
  input      [`CR_KME_C_KDF_DRBG_CTRL_T_DECL]   i_kdf_drbg_ctrl,
  input      [`CR_KME_C_INT_STATUS_T_DECL]      i_interrupt_status,
  input      [`CR_KME_C_STICKY_ENG_BP_T_DECL]   i_engine_sticky_status,
  input      [`CR_KME_C_BIMC_MONITOR_T_DECL]    i_bimc_monitor,
  input      [`CR_KME_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_uncorrectable_error_cnt,
  input      [`CR_KME_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_correctable_error_cnt,
  input      [`CR_KME_C_BIMC_PARITY_ERROR_CNT_T_DECL] i_bimc_parity_error_cnt,
  input      [`CR_KME_C_BIMC_GLOBAL_CONFIG_T_DECL] i_bimc_global_config,
  input      [`CR_KME_C_BIMC_MEMID_T_DECL]      i_bimc_memid,
  input      [`CR_KME_C_BIMC_ECCPAR_DEBUG_T_DECL] i_bimc_eccpar_debug,
  input      [`CR_KME_C_BIMC_CMD2_T_DECL]       i_bimc_cmd2,
  input      [`CR_KME_C_BIMC_RXCMD2_T_DECL]     i_bimc_rxcmd2,
  input      [`CR_KME_C_BIMC_RXCMD1_T_DECL]     i_bimc_rxcmd1,
  input      [`CR_KME_C_BIMC_RXCMD0_T_DECL]     i_bimc_rxcmd0,
  input      [`CR_KME_C_BIMC_RXRSP2_T_DECL]     i_bimc_rxrsp2,
  input      [`CR_KME_C_BIMC_RXRSP1_T_DECL]     i_bimc_rxrsp1,
  input      [`CR_KME_C_BIMC_RXRSP0_T_DECL]     i_bimc_rxrsp0,
  input      [`CR_KME_C_BIMC_POLLRSP2_T_DECL]   i_bimc_pollrsp2,
  input      [`CR_KME_C_BIMC_POLLRSP1_T_DECL]   i_bimc_pollrsp1,
  input      [`CR_KME_C_BIMC_POLLRSP0_T_DECL]   i_bimc_pollrsp0,
  input      [`CR_KME_C_BIMC_DBGCMD2_T_DECL]    i_bimc_dbgcmd2,
  input      [`CR_KME_C_BIMC_DBGCMD1_T_DECL]    i_bimc_dbgcmd1,
  input      [`CR_KME_C_BIMC_DBGCMD0_T_DECL]    i_bimc_dbgcmd0,
  input      [`CR_KME_C_IM_AVAILABLE_T_DECL]    i_im_available,
  input      [`CR_KME_C_IM_CONSUMED_T_DECL]     i_im_consumed,
  input      [`CR_KME_C_TREADY_OVERRIDE_T_DECL] i_tready_override,
  input      [`CR_KME_C_SA_CTRL_DEP_T_DECL]     i_regs_sa_ctrl,
  input      [`CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_DECL] i_sa_snapshot_ia_capability,
  input      [`CR_KME_C_SA_SNAPSHOT_IA_STATUS_T_DECL] i_sa_snapshot_ia_status,
  input      [`CR_KME_C_SA_SNAPSHOT_PART1_T_DECL] i_sa_snapshot_ia_rdata_part0,
  input      [`CR_KME_C_SA_SNAPSHOT_PART0_T_DECL] i_sa_snapshot_ia_rdata_part1,
  input      [`CR_KME_C_SA_COUNT_IA_CAPABILITY_T_DECL] i_sa_count_ia_capability,
  input      [`CR_KME_C_SA_COUNT_IA_STATUS_T_DECL] i_sa_count_ia_status,
  input      [`CR_KME_C_SA_COUNT_PART1_T_DECL]  i_sa_count_ia_rdata_part0,
  input      [`CR_KME_C_SA_COUNT_PART0_T_DECL]  i_sa_count_ia_rdata_part1,
  input      [`CR_KME_C_IDLE_T_DECL]            i_idle_components,
  input      [`CR_KME_C_SA_GLOBAL_CTRL_T_DECL]  i_sa_global_ctrl,
  input      [`CR_KME_C_SA_CTRL_IA_CAPABILITY_T_DECL] i_sa_ctrl_ia_capability,
  input      [`CR_KME_C_SA_CTRL_IA_STATUS_T_DECL] i_sa_ctrl_ia_status,
  input      [`CR_KME_C_SA_CTRL_T_DECL]         i_sa_ctrl_ia_rdata_part0,

  
  output reg                                    o_reg_written,
  output reg                                    o_reg_read,
  output     [31:0]                             o_reg_wr_data,
  output reg [`CR_KME_DECL]                     o_reg_addr
  );


  


  
  


  
  wire [`CR_KME_DECL] ws_read_addr    = o_reg_addr;
  wire [`CR_KME_DECL] ws_addr         = o_reg_addr;
  

  wire n_wr_strobe = i_wr_strb;
  wire n_rd_strobe = i_rd_strb;

  wire w_32b_aligned    = (o_reg_addr[1:0] == 2'h0);

  wire w_valid_rd_addr     = (w_32b_aligned && (ws_addr >= `CR_KME_BLKID_REVID_CONFIG) && (ws_addr <= `CR_KME_KIM_IA_RDATA_PART1))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_LABEL0_CONFIG) && (ws_addr <= `CR_KME_LABEL0_DATA0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_LABEL1_CONFIG) && (ws_addr <= `CR_KME_LABEL1_DATA0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_LABEL2_CONFIG) && (ws_addr <= `CR_KME_LABEL2_DATA0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_LABEL3_CONFIG) && (ws_addr <= `CR_KME_LABEL3_DATA0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_LABEL4_CONFIG) && (ws_addr <= `CR_KME_LABEL4_DATA0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_LABEL5_CONFIG) && (ws_addr <= `CR_KME_LABEL5_DATA0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_LABEL6_CONFIG) && (ws_addr <= `CR_KME_LABEL6_DATA0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_LABEL7_CONFIG) && (ws_addr <= `CR_KME_LABEL7_DATA0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_KDF_DRBG_CTRL) && (ws_addr <= `CR_KME_ENGINE_STICKY_STATUS))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_BIMC_MONITOR) && (ws_addr <= `CR_KME_BIMC_DBGCMD0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_IM_AVAILABLE) && (ws_addr <= `CR_KME_KDF_TEST_KEY_SIZE_CONFIG));

  wire w_valid_wr_addr     = (w_32b_aligned && (ws_addr >= `CR_KME_BLKID_REVID_CONFIG) && (ws_addr <= `CR_KME_KIM_IA_RDATA_PART1))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_LABEL0_CONFIG) && (ws_addr <= `CR_KME_LABEL0_DATA0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_LABEL1_CONFIG) && (ws_addr <= `CR_KME_LABEL1_DATA0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_LABEL2_CONFIG) && (ws_addr <= `CR_KME_LABEL2_DATA0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_LABEL3_CONFIG) && (ws_addr <= `CR_KME_LABEL3_DATA0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_LABEL4_CONFIG) && (ws_addr <= `CR_KME_LABEL4_DATA0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_LABEL5_CONFIG) && (ws_addr <= `CR_KME_LABEL5_DATA0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_LABEL6_CONFIG) && (ws_addr <= `CR_KME_LABEL6_DATA0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_LABEL7_CONFIG) && (ws_addr <= `CR_KME_LABEL7_DATA0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_KDF_DRBG_CTRL) && (ws_addr <= `CR_KME_ENGINE_STICKY_STATUS))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_BIMC_MONITOR) && (ws_addr <= `CR_KME_BIMC_DBGCMD0))
                          || (w_32b_aligned && (ws_addr >= `CR_KME_IM_AVAILABLE) && (ws_addr <= `CR_KME_KDF_TEST_KEY_SIZE_CONFIG));

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
  reg  [31:0]  r32_mux_6_data, f32_mux_6_data;
  reg  [31:0]  r32_mux_7_data, f32_mux_7_data;
  reg  [31:0]  r32_mux_8_data, f32_mux_8_data;

  wire [31:0]  r32_formatted_reg_data = f32_mux_0_data
                                      | f32_mux_1_data
                                      | f32_mux_2_data
                                      | f32_mux_3_data
                                      | f32_mux_4_data
                                      | f32_mux_5_data
                                      | f32_mux_6_data
                                      | f32_mux_7_data
                                      | f32_mux_8_data;

  always_comb begin
    r32_mux_0_data = 0;
    r32_mux_1_data = 0;
    r32_mux_2_data = 0;
    r32_mux_3_data = 0;
    r32_mux_4_data = 0;
    r32_mux_5_data = 0;
    r32_mux_6_data = 0;
    r32_mux_7_data = 0;
    r32_mux_8_data = 0;

    case (ws_read_addr)
    `CR_KME_BLKID_REVID_CONFIG: begin
      r32_mux_0_data[15:00] = i_blkid_revid_config[15:00]; 
      r32_mux_0_data[31:16] = i_blkid_revid_config[31:16]; 
    end
    `CR_KME_REVISION_CONFIG: begin
      r32_mux_0_data[07:00] = i_revision_config[07:00]; 
    end
    `CR_KME_SPARE_CONFIG: begin
      r32_mux_0_data[31:00] = i_spare_config[31:00]; 
    end
    `CR_KME_CCEIP0_OUT_IA_CAPABILITY: begin
      r32_mux_0_data[00:00] = i_cceip0_out_ia_capability[00:00]; 
      r32_mux_0_data[01:01] = i_cceip0_out_ia_capability[01:01]; 
      r32_mux_0_data[02:02] = i_cceip0_out_ia_capability[02:02]; 
      r32_mux_0_data[03:03] = i_cceip0_out_ia_capability[03:03]; 
      r32_mux_0_data[04:04] = i_cceip0_out_ia_capability[04:04]; 
      r32_mux_0_data[05:05] = i_cceip0_out_ia_capability[05:05]; 
      r32_mux_0_data[06:06] = i_cceip0_out_ia_capability[06:06]; 
      r32_mux_0_data[07:07] = i_cceip0_out_ia_capability[07:07]; 
      r32_mux_0_data[08:08] = i_cceip0_out_ia_capability[08:08]; 
      r32_mux_0_data[09:09] = i_cceip0_out_ia_capability[09:09]; 
      r32_mux_0_data[13:10] = i_cceip0_out_ia_capability[13:10]; 
      r32_mux_0_data[14:14] = i_cceip0_out_ia_capability[14:14]; 
      r32_mux_0_data[15:15] = i_cceip0_out_ia_capability[15:15]; 
      r32_mux_0_data[31:28] = i_cceip0_out_ia_capability[19:16]; 
    end
    `CR_KME_CCEIP0_OUT_IA_STATUS: begin
      r32_mux_0_data[08:00] = i_cceip0_out_ia_status[08:00]; 
      r32_mux_0_data[28:24] = i_cceip0_out_ia_status[13:09]; 
      r32_mux_0_data[31:29] = i_cceip0_out_ia_status[16:14]; 
    end
    `CR_KME_CCEIP0_OUT_IA_WDATA_PART0: begin
      r32_mux_0_data[05:00] = o_cceip0_out_ia_wdata_part0[05:00]; 
      r32_mux_0_data[13:06] = o_cceip0_out_ia_wdata_part0[13:06]; 
      r32_mux_0_data[14:14] = o_cceip0_out_ia_wdata_part0[14:14]; 
      r32_mux_0_data[22:15] = o_cceip0_out_ia_wdata_part0[22:15]; 
      r32_mux_0_data[30:23] = o_cceip0_out_ia_wdata_part0[30:23]; 
      r32_mux_0_data[31:31] = o_cceip0_out_ia_wdata_part0[31:31]; 
    end
    `CR_KME_CCEIP0_OUT_IA_WDATA_PART1: begin
      r32_mux_0_data[31:00] = o_cceip0_out_ia_wdata_part1[31:00]; 
    end
    `CR_KME_CCEIP0_OUT_IA_WDATA_PART2: begin
      r32_mux_0_data[31:00] = o_cceip0_out_ia_wdata_part2[31:00]; 
    end
    `CR_KME_CCEIP0_OUT_IA_CONFIG: begin
      r32_mux_0_data[08:00] = o_cceip0_out_ia_config[08:00]; 
      r32_mux_0_data[31:28] = o_cceip0_out_ia_config[12:09]; 
    end
    `CR_KME_CCEIP0_OUT_IA_RDATA_PART0: begin
      r32_mux_0_data[05:00] = i_cceip0_out_ia_rdata_part0[05:00]; 
      r32_mux_0_data[13:06] = i_cceip0_out_ia_rdata_part0[13:06]; 
      r32_mux_0_data[14:14] = i_cceip0_out_ia_rdata_part0[14:14]; 
      r32_mux_0_data[22:15] = i_cceip0_out_ia_rdata_part0[22:15]; 
      r32_mux_0_data[30:23] = i_cceip0_out_ia_rdata_part0[30:23]; 
      r32_mux_0_data[31:31] = i_cceip0_out_ia_rdata_part0[31:31]; 
    end
    `CR_KME_CCEIP0_OUT_IA_RDATA_PART1: begin
      r32_mux_0_data[31:00] = i_cceip0_out_ia_rdata_part1[31:00]; 
    end
    `CR_KME_CCEIP0_OUT_IA_RDATA_PART2: begin
      r32_mux_0_data[31:00] = i_cceip0_out_ia_rdata_part2[31:00]; 
    end
    `CR_KME_CCEIP0_OUT_IM_CONFIG: begin
      r32_mux_0_data[09:00] = o_cceip0_out_im_config[09:00]; 
      r32_mux_0_data[31:30] = o_cceip0_out_im_config[11:10]; 
    end
    `CR_KME_CCEIP0_OUT_IM_STATUS: begin
      r32_mux_0_data[08:00] = i_cceip0_out_im_status[08:00]; 
      r32_mux_0_data[29:29] = i_cceip0_out_im_status[09:09]; 
      r32_mux_0_data[30:30] = i_cceip0_out_im_status[10:10]; 
      r32_mux_0_data[31:31] = i_cceip0_out_im_status[11:11]; 
    end
    `CR_KME_CCEIP0_OUT_IM_READ_DONE: begin
      r32_mux_0_data[30:30] = i_cceip0_out_im_read_done[00:00]; 
      r32_mux_0_data[31:31] = i_cceip0_out_im_read_done[01:01]; 
    end
    `CR_KME_CCEIP1_OUT_IA_CAPABILITY: begin
      r32_mux_0_data[00:00] = i_cceip1_out_ia_capability[00:00]; 
      r32_mux_0_data[01:01] = i_cceip1_out_ia_capability[01:01]; 
      r32_mux_0_data[02:02] = i_cceip1_out_ia_capability[02:02]; 
      r32_mux_0_data[03:03] = i_cceip1_out_ia_capability[03:03]; 
      r32_mux_0_data[04:04] = i_cceip1_out_ia_capability[04:04]; 
      r32_mux_0_data[05:05] = i_cceip1_out_ia_capability[05:05]; 
      r32_mux_0_data[06:06] = i_cceip1_out_ia_capability[06:06]; 
      r32_mux_0_data[07:07] = i_cceip1_out_ia_capability[07:07]; 
      r32_mux_0_data[08:08] = i_cceip1_out_ia_capability[08:08]; 
      r32_mux_0_data[09:09] = i_cceip1_out_ia_capability[09:09]; 
      r32_mux_0_data[13:10] = i_cceip1_out_ia_capability[13:10]; 
      r32_mux_0_data[14:14] = i_cceip1_out_ia_capability[14:14]; 
      r32_mux_0_data[15:15] = i_cceip1_out_ia_capability[15:15]; 
      r32_mux_0_data[31:28] = i_cceip1_out_ia_capability[19:16]; 
    end
    `CR_KME_CCEIP1_OUT_IA_STATUS: begin
      r32_mux_0_data[08:00] = i_cceip1_out_ia_status[08:00]; 
      r32_mux_0_data[28:24] = i_cceip1_out_ia_status[13:09]; 
      r32_mux_0_data[31:29] = i_cceip1_out_ia_status[16:14]; 
    end
    `CR_KME_CCEIP1_OUT_IA_WDATA_PART0: begin
      r32_mux_0_data[05:00] = o_cceip1_out_ia_wdata_part0[05:00]; 
      r32_mux_0_data[13:06] = o_cceip1_out_ia_wdata_part0[13:06]; 
      r32_mux_0_data[14:14] = o_cceip1_out_ia_wdata_part0[14:14]; 
      r32_mux_0_data[22:15] = o_cceip1_out_ia_wdata_part0[22:15]; 
      r32_mux_0_data[30:23] = o_cceip1_out_ia_wdata_part0[30:23]; 
      r32_mux_0_data[31:31] = o_cceip1_out_ia_wdata_part0[31:31]; 
    end
    `CR_KME_CCEIP1_OUT_IA_WDATA_PART1: begin
      r32_mux_0_data[31:00] = o_cceip1_out_ia_wdata_part1[31:00]; 
    end
    `CR_KME_CCEIP1_OUT_IA_WDATA_PART2: begin
      r32_mux_0_data[31:00] = o_cceip1_out_ia_wdata_part2[31:00]; 
    end
    `CR_KME_CCEIP1_OUT_IA_CONFIG: begin
      r32_mux_0_data[08:00] = o_cceip1_out_ia_config[08:00]; 
      r32_mux_0_data[31:28] = o_cceip1_out_ia_config[12:09]; 
    end
    `CR_KME_CCEIP1_OUT_IA_RDATA_PART0: begin
      r32_mux_0_data[05:00] = i_cceip1_out_ia_rdata_part0[05:00]; 
      r32_mux_0_data[13:06] = i_cceip1_out_ia_rdata_part0[13:06]; 
      r32_mux_0_data[14:14] = i_cceip1_out_ia_rdata_part0[14:14]; 
      r32_mux_0_data[22:15] = i_cceip1_out_ia_rdata_part0[22:15]; 
      r32_mux_0_data[30:23] = i_cceip1_out_ia_rdata_part0[30:23]; 
      r32_mux_0_data[31:31] = i_cceip1_out_ia_rdata_part0[31:31]; 
    end
    `CR_KME_CCEIP1_OUT_IA_RDATA_PART1: begin
      r32_mux_0_data[31:00] = i_cceip1_out_ia_rdata_part1[31:00]; 
    end
    `CR_KME_CCEIP1_OUT_IA_RDATA_PART2: begin
      r32_mux_0_data[31:00] = i_cceip1_out_ia_rdata_part2[31:00]; 
    end
    `CR_KME_CCEIP1_OUT_IM_CONFIG: begin
      r32_mux_0_data[09:00] = o_cceip1_out_im_config[09:00]; 
      r32_mux_0_data[31:30] = o_cceip1_out_im_config[11:10]; 
    end
    `CR_KME_CCEIP1_OUT_IM_STATUS: begin
      r32_mux_0_data[08:00] = i_cceip1_out_im_status[08:00]; 
      r32_mux_0_data[29:29] = i_cceip1_out_im_status[09:09]; 
      r32_mux_0_data[30:30] = i_cceip1_out_im_status[10:10]; 
      r32_mux_0_data[31:31] = i_cceip1_out_im_status[11:11]; 
    end
    `CR_KME_CCEIP1_OUT_IM_READ_DONE: begin
      r32_mux_0_data[30:30] = i_cceip1_out_im_read_done[00:00]; 
      r32_mux_0_data[31:31] = i_cceip1_out_im_read_done[01:01]; 
    end
    `CR_KME_CCEIP2_OUT_IA_CAPABILITY: begin
      r32_mux_0_data[00:00] = i_cceip2_out_ia_capability[00:00]; 
      r32_mux_0_data[01:01] = i_cceip2_out_ia_capability[01:01]; 
      r32_mux_0_data[02:02] = i_cceip2_out_ia_capability[02:02]; 
      r32_mux_0_data[03:03] = i_cceip2_out_ia_capability[03:03]; 
      r32_mux_0_data[04:04] = i_cceip2_out_ia_capability[04:04]; 
      r32_mux_0_data[05:05] = i_cceip2_out_ia_capability[05:05]; 
      r32_mux_0_data[06:06] = i_cceip2_out_ia_capability[06:06]; 
      r32_mux_0_data[07:07] = i_cceip2_out_ia_capability[07:07]; 
      r32_mux_0_data[08:08] = i_cceip2_out_ia_capability[08:08]; 
      r32_mux_0_data[09:09] = i_cceip2_out_ia_capability[09:09]; 
      r32_mux_0_data[13:10] = i_cceip2_out_ia_capability[13:10]; 
      r32_mux_0_data[14:14] = i_cceip2_out_ia_capability[14:14]; 
      r32_mux_0_data[15:15] = i_cceip2_out_ia_capability[15:15]; 
      r32_mux_0_data[31:28] = i_cceip2_out_ia_capability[19:16]; 
    end
    `CR_KME_CCEIP2_OUT_IA_STATUS: begin
      r32_mux_0_data[08:00] = i_cceip2_out_ia_status[08:00]; 
      r32_mux_0_data[28:24] = i_cceip2_out_ia_status[13:09]; 
      r32_mux_0_data[31:29] = i_cceip2_out_ia_status[16:14]; 
    end
    `CR_KME_CCEIP2_OUT_IA_WDATA_PART0: begin
      r32_mux_0_data[05:00] = o_cceip2_out_ia_wdata_part0[05:00]; 
      r32_mux_0_data[13:06] = o_cceip2_out_ia_wdata_part0[13:06]; 
      r32_mux_0_data[14:14] = o_cceip2_out_ia_wdata_part0[14:14]; 
      r32_mux_0_data[22:15] = o_cceip2_out_ia_wdata_part0[22:15]; 
      r32_mux_0_data[30:23] = o_cceip2_out_ia_wdata_part0[30:23]; 
      r32_mux_0_data[31:31] = o_cceip2_out_ia_wdata_part0[31:31]; 
    end
    endcase

    case (ws_read_addr)
    `CR_KME_CCEIP2_OUT_IA_WDATA_PART1: begin
      r32_mux_1_data[31:00] = o_cceip2_out_ia_wdata_part1[31:00]; 
    end
    `CR_KME_CCEIP2_OUT_IA_WDATA_PART2: begin
      r32_mux_1_data[31:00] = o_cceip2_out_ia_wdata_part2[31:00]; 
    end
    `CR_KME_CCEIP2_OUT_IA_CONFIG: begin
      r32_mux_1_data[08:00] = o_cceip2_out_ia_config[08:00]; 
      r32_mux_1_data[31:28] = o_cceip2_out_ia_config[12:09]; 
    end
    `CR_KME_CCEIP2_OUT_IA_RDATA_PART0: begin
      r32_mux_1_data[05:00] = i_cceip2_out_ia_rdata_part0[05:00]; 
      r32_mux_1_data[13:06] = i_cceip2_out_ia_rdata_part0[13:06]; 
      r32_mux_1_data[14:14] = i_cceip2_out_ia_rdata_part0[14:14]; 
      r32_mux_1_data[22:15] = i_cceip2_out_ia_rdata_part0[22:15]; 
      r32_mux_1_data[30:23] = i_cceip2_out_ia_rdata_part0[30:23]; 
      r32_mux_1_data[31:31] = i_cceip2_out_ia_rdata_part0[31:31]; 
    end
    `CR_KME_CCEIP2_OUT_IA_RDATA_PART1: begin
      r32_mux_1_data[31:00] = i_cceip2_out_ia_rdata_part1[31:00]; 
    end
    `CR_KME_CCEIP2_OUT_IA_RDATA_PART2: begin
      r32_mux_1_data[31:00] = i_cceip2_out_ia_rdata_part2[31:00]; 
    end
    `CR_KME_CCEIP2_OUT_IM_CONFIG: begin
      r32_mux_1_data[09:00] = o_cceip2_out_im_config[09:00]; 
      r32_mux_1_data[31:30] = o_cceip2_out_im_config[11:10]; 
    end
    `CR_KME_CCEIP2_OUT_IM_STATUS: begin
      r32_mux_1_data[08:00] = i_cceip2_out_im_status[08:00]; 
      r32_mux_1_data[29:29] = i_cceip2_out_im_status[09:09]; 
      r32_mux_1_data[30:30] = i_cceip2_out_im_status[10:10]; 
      r32_mux_1_data[31:31] = i_cceip2_out_im_status[11:11]; 
    end
    `CR_KME_CCEIP2_OUT_IM_READ_DONE: begin
      r32_mux_1_data[30:30] = i_cceip2_out_im_read_done[00:00]; 
      r32_mux_1_data[31:31] = i_cceip2_out_im_read_done[01:01]; 
    end
    `CR_KME_CCEIP3_OUT_IA_CAPABILITY: begin
      r32_mux_1_data[00:00] = i_cceip3_out_ia_capability[00:00]; 
      r32_mux_1_data[01:01] = i_cceip3_out_ia_capability[01:01]; 
      r32_mux_1_data[02:02] = i_cceip3_out_ia_capability[02:02]; 
      r32_mux_1_data[03:03] = i_cceip3_out_ia_capability[03:03]; 
      r32_mux_1_data[04:04] = i_cceip3_out_ia_capability[04:04]; 
      r32_mux_1_data[05:05] = i_cceip3_out_ia_capability[05:05]; 
      r32_mux_1_data[06:06] = i_cceip3_out_ia_capability[06:06]; 
      r32_mux_1_data[07:07] = i_cceip3_out_ia_capability[07:07]; 
      r32_mux_1_data[08:08] = i_cceip3_out_ia_capability[08:08]; 
      r32_mux_1_data[09:09] = i_cceip3_out_ia_capability[09:09]; 
      r32_mux_1_data[13:10] = i_cceip3_out_ia_capability[13:10]; 
      r32_mux_1_data[14:14] = i_cceip3_out_ia_capability[14:14]; 
      r32_mux_1_data[15:15] = i_cceip3_out_ia_capability[15:15]; 
      r32_mux_1_data[31:28] = i_cceip3_out_ia_capability[19:16]; 
    end
    `CR_KME_CCEIP3_OUT_IA_STATUS: begin
      r32_mux_1_data[08:00] = i_cceip3_out_ia_status[08:00]; 
      r32_mux_1_data[28:24] = i_cceip3_out_ia_status[13:09]; 
      r32_mux_1_data[31:29] = i_cceip3_out_ia_status[16:14]; 
    end
    `CR_KME_CCEIP3_OUT_IA_WDATA_PART0: begin
      r32_mux_1_data[05:00] = o_cceip3_out_ia_wdata_part0[05:00]; 
      r32_mux_1_data[13:06] = o_cceip3_out_ia_wdata_part0[13:06]; 
      r32_mux_1_data[14:14] = o_cceip3_out_ia_wdata_part0[14:14]; 
      r32_mux_1_data[22:15] = o_cceip3_out_ia_wdata_part0[22:15]; 
      r32_mux_1_data[30:23] = o_cceip3_out_ia_wdata_part0[30:23]; 
      r32_mux_1_data[31:31] = o_cceip3_out_ia_wdata_part0[31:31]; 
    end
    `CR_KME_CCEIP3_OUT_IA_WDATA_PART1: begin
      r32_mux_1_data[31:00] = o_cceip3_out_ia_wdata_part1[31:00]; 
    end
    `CR_KME_CCEIP3_OUT_IA_WDATA_PART2: begin
      r32_mux_1_data[31:00] = o_cceip3_out_ia_wdata_part2[31:00]; 
    end
    `CR_KME_CCEIP3_OUT_IA_CONFIG: begin
      r32_mux_1_data[08:00] = o_cceip3_out_ia_config[08:00]; 
      r32_mux_1_data[31:28] = o_cceip3_out_ia_config[12:09]; 
    end
    `CR_KME_CCEIP3_OUT_IA_RDATA_PART0: begin
      r32_mux_1_data[05:00] = i_cceip3_out_ia_rdata_part0[05:00]; 
      r32_mux_1_data[13:06] = i_cceip3_out_ia_rdata_part0[13:06]; 
      r32_mux_1_data[14:14] = i_cceip3_out_ia_rdata_part0[14:14]; 
      r32_mux_1_data[22:15] = i_cceip3_out_ia_rdata_part0[22:15]; 
      r32_mux_1_data[30:23] = i_cceip3_out_ia_rdata_part0[30:23]; 
      r32_mux_1_data[31:31] = i_cceip3_out_ia_rdata_part0[31:31]; 
    end
    `CR_KME_CCEIP3_OUT_IA_RDATA_PART1: begin
      r32_mux_1_data[31:00] = i_cceip3_out_ia_rdata_part1[31:00]; 
    end
    `CR_KME_CCEIP3_OUT_IA_RDATA_PART2: begin
      r32_mux_1_data[31:00] = i_cceip3_out_ia_rdata_part2[31:00]; 
    end
    `CR_KME_CCEIP3_OUT_IM_CONFIG: begin
      r32_mux_1_data[09:00] = o_cceip3_out_im_config[09:00]; 
      r32_mux_1_data[31:30] = o_cceip3_out_im_config[11:10]; 
    end
    `CR_KME_CCEIP3_OUT_IM_STATUS: begin
      r32_mux_1_data[08:00] = i_cceip3_out_im_status[08:00]; 
      r32_mux_1_data[29:29] = i_cceip3_out_im_status[09:09]; 
      r32_mux_1_data[30:30] = i_cceip3_out_im_status[10:10]; 
      r32_mux_1_data[31:31] = i_cceip3_out_im_status[11:11]; 
    end
    `CR_KME_CCEIP3_OUT_IM_READ_DONE: begin
      r32_mux_1_data[30:30] = i_cceip3_out_im_read_done[00:00]; 
      r32_mux_1_data[31:31] = i_cceip3_out_im_read_done[01:01]; 
    end
    `CR_KME_CDDIP0_OUT_IA_CAPABILITY: begin
      r32_mux_1_data[00:00] = i_cddip0_out_ia_capability[00:00]; 
      r32_mux_1_data[01:01] = i_cddip0_out_ia_capability[01:01]; 
      r32_mux_1_data[02:02] = i_cddip0_out_ia_capability[02:02]; 
      r32_mux_1_data[03:03] = i_cddip0_out_ia_capability[03:03]; 
      r32_mux_1_data[04:04] = i_cddip0_out_ia_capability[04:04]; 
      r32_mux_1_data[05:05] = i_cddip0_out_ia_capability[05:05]; 
      r32_mux_1_data[06:06] = i_cddip0_out_ia_capability[06:06]; 
      r32_mux_1_data[07:07] = i_cddip0_out_ia_capability[07:07]; 
      r32_mux_1_data[08:08] = i_cddip0_out_ia_capability[08:08]; 
      r32_mux_1_data[09:09] = i_cddip0_out_ia_capability[09:09]; 
      r32_mux_1_data[13:10] = i_cddip0_out_ia_capability[13:10]; 
      r32_mux_1_data[14:14] = i_cddip0_out_ia_capability[14:14]; 
      r32_mux_1_data[15:15] = i_cddip0_out_ia_capability[15:15]; 
      r32_mux_1_data[31:28] = i_cddip0_out_ia_capability[19:16]; 
    end
    `CR_KME_CDDIP0_OUT_IA_STATUS: begin
      r32_mux_1_data[08:00] = i_cddip0_out_ia_status[08:00]; 
      r32_mux_1_data[28:24] = i_cddip0_out_ia_status[13:09]; 
      r32_mux_1_data[31:29] = i_cddip0_out_ia_status[16:14]; 
    end
    `CR_KME_CDDIP0_OUT_IA_WDATA_PART0: begin
      r32_mux_1_data[05:00] = o_cddip0_out_ia_wdata_part0[05:00]; 
      r32_mux_1_data[13:06] = o_cddip0_out_ia_wdata_part0[13:06]; 
      r32_mux_1_data[14:14] = o_cddip0_out_ia_wdata_part0[14:14]; 
      r32_mux_1_data[22:15] = o_cddip0_out_ia_wdata_part0[22:15]; 
      r32_mux_1_data[30:23] = o_cddip0_out_ia_wdata_part0[30:23]; 
      r32_mux_1_data[31:31] = o_cddip0_out_ia_wdata_part0[31:31]; 
    end
    `CR_KME_CDDIP0_OUT_IA_WDATA_PART1: begin
      r32_mux_1_data[31:00] = o_cddip0_out_ia_wdata_part1[31:00]; 
    end
    `CR_KME_CDDIP0_OUT_IA_WDATA_PART2: begin
      r32_mux_1_data[31:00] = o_cddip0_out_ia_wdata_part2[31:00]; 
    end
    `CR_KME_CDDIP0_OUT_IA_CONFIG: begin
      r32_mux_1_data[08:00] = o_cddip0_out_ia_config[08:00]; 
      r32_mux_1_data[31:28] = o_cddip0_out_ia_config[12:09]; 
    end
    `CR_KME_CDDIP0_OUT_IA_RDATA_PART0: begin
      r32_mux_1_data[05:00] = i_cddip0_out_ia_rdata_part0[05:00]; 
      r32_mux_1_data[13:06] = i_cddip0_out_ia_rdata_part0[13:06]; 
      r32_mux_1_data[14:14] = i_cddip0_out_ia_rdata_part0[14:14]; 
      r32_mux_1_data[22:15] = i_cddip0_out_ia_rdata_part0[22:15]; 
      r32_mux_1_data[30:23] = i_cddip0_out_ia_rdata_part0[30:23]; 
      r32_mux_1_data[31:31] = i_cddip0_out_ia_rdata_part0[31:31]; 
    end
    `CR_KME_CDDIP0_OUT_IA_RDATA_PART1: begin
      r32_mux_1_data[31:00] = i_cddip0_out_ia_rdata_part1[31:00]; 
    end
    `CR_KME_CDDIP0_OUT_IA_RDATA_PART2: begin
      r32_mux_1_data[31:00] = i_cddip0_out_ia_rdata_part2[31:00]; 
    end
    endcase

    case (ws_read_addr)
    `CR_KME_CDDIP0_OUT_IM_CONFIG: begin
      r32_mux_2_data[09:00] = o_cddip0_out_im_config[09:00]; 
      r32_mux_2_data[31:30] = o_cddip0_out_im_config[11:10]; 
    end
    `CR_KME_CDDIP0_OUT_IM_STATUS: begin
      r32_mux_2_data[08:00] = i_cddip0_out_im_status[08:00]; 
      r32_mux_2_data[29:29] = i_cddip0_out_im_status[09:09]; 
      r32_mux_2_data[30:30] = i_cddip0_out_im_status[10:10]; 
      r32_mux_2_data[31:31] = i_cddip0_out_im_status[11:11]; 
    end
    `CR_KME_CDDIP0_OUT_IM_READ_DONE: begin
      r32_mux_2_data[30:30] = i_cddip0_out_im_read_done[00:00]; 
      r32_mux_2_data[31:31] = i_cddip0_out_im_read_done[01:01]; 
    end
    `CR_KME_CDDIP1_OUT_IA_CAPABILITY: begin
      r32_mux_2_data[00:00] = i_cddip1_out_ia_capability[00:00]; 
      r32_mux_2_data[01:01] = i_cddip1_out_ia_capability[01:01]; 
      r32_mux_2_data[02:02] = i_cddip1_out_ia_capability[02:02]; 
      r32_mux_2_data[03:03] = i_cddip1_out_ia_capability[03:03]; 
      r32_mux_2_data[04:04] = i_cddip1_out_ia_capability[04:04]; 
      r32_mux_2_data[05:05] = i_cddip1_out_ia_capability[05:05]; 
      r32_mux_2_data[06:06] = i_cddip1_out_ia_capability[06:06]; 
      r32_mux_2_data[07:07] = i_cddip1_out_ia_capability[07:07]; 
      r32_mux_2_data[08:08] = i_cddip1_out_ia_capability[08:08]; 
      r32_mux_2_data[09:09] = i_cddip1_out_ia_capability[09:09]; 
      r32_mux_2_data[13:10] = i_cddip1_out_ia_capability[13:10]; 
      r32_mux_2_data[14:14] = i_cddip1_out_ia_capability[14:14]; 
      r32_mux_2_data[15:15] = i_cddip1_out_ia_capability[15:15]; 
      r32_mux_2_data[31:28] = i_cddip1_out_ia_capability[19:16]; 
    end
    `CR_KME_CDDIP1_OUT_IA_STATUS: begin
      r32_mux_2_data[08:00] = i_cddip1_out_ia_status[08:00]; 
      r32_mux_2_data[28:24] = i_cddip1_out_ia_status[13:09]; 
      r32_mux_2_data[31:29] = i_cddip1_out_ia_status[16:14]; 
    end
    `CR_KME_CDDIP1_OUT_IA_WDATA_PART0: begin
      r32_mux_2_data[05:00] = o_cddip1_out_ia_wdata_part0[05:00]; 
      r32_mux_2_data[13:06] = o_cddip1_out_ia_wdata_part0[13:06]; 
      r32_mux_2_data[14:14] = o_cddip1_out_ia_wdata_part0[14:14]; 
      r32_mux_2_data[22:15] = o_cddip1_out_ia_wdata_part0[22:15]; 
      r32_mux_2_data[30:23] = o_cddip1_out_ia_wdata_part0[30:23]; 
      r32_mux_2_data[31:31] = o_cddip1_out_ia_wdata_part0[31:31]; 
    end
    `CR_KME_CDDIP1_OUT_IA_WDATA_PART1: begin
      r32_mux_2_data[31:00] = o_cddip1_out_ia_wdata_part1[31:00]; 
    end
    `CR_KME_CDDIP1_OUT_IA_WDATA_PART2: begin
      r32_mux_2_data[31:00] = o_cddip1_out_ia_wdata_part2[31:00]; 
    end
    `CR_KME_CDDIP1_OUT_IA_CONFIG: begin
      r32_mux_2_data[08:00] = o_cddip1_out_ia_config[08:00]; 
      r32_mux_2_data[31:28] = o_cddip1_out_ia_config[12:09]; 
    end
    `CR_KME_CDDIP1_OUT_IA_RDATA_PART0: begin
      r32_mux_2_data[05:00] = i_cddip1_out_ia_rdata_part0[05:00]; 
      r32_mux_2_data[13:06] = i_cddip1_out_ia_rdata_part0[13:06]; 
      r32_mux_2_data[14:14] = i_cddip1_out_ia_rdata_part0[14:14]; 
      r32_mux_2_data[22:15] = i_cddip1_out_ia_rdata_part0[22:15]; 
      r32_mux_2_data[30:23] = i_cddip1_out_ia_rdata_part0[30:23]; 
      r32_mux_2_data[31:31] = i_cddip1_out_ia_rdata_part0[31:31]; 
    end
    `CR_KME_CDDIP1_OUT_IA_RDATA_PART1: begin
      r32_mux_2_data[31:00] = i_cddip1_out_ia_rdata_part1[31:00]; 
    end
    `CR_KME_CDDIP1_OUT_IA_RDATA_PART2: begin
      r32_mux_2_data[31:00] = i_cddip1_out_ia_rdata_part2[31:00]; 
    end
    `CR_KME_CDDIP1_OUT_IM_CONFIG: begin
      r32_mux_2_data[09:00] = o_cddip1_out_im_config[09:00]; 
      r32_mux_2_data[31:30] = o_cddip1_out_im_config[11:10]; 
    end
    `CR_KME_CDDIP1_OUT_IM_STATUS: begin
      r32_mux_2_data[08:00] = i_cddip1_out_im_status[08:00]; 
      r32_mux_2_data[29:29] = i_cddip1_out_im_status[09:09]; 
      r32_mux_2_data[30:30] = i_cddip1_out_im_status[10:10]; 
      r32_mux_2_data[31:31] = i_cddip1_out_im_status[11:11]; 
    end
    `CR_KME_CDDIP1_OUT_IM_READ_DONE: begin
      r32_mux_2_data[30:30] = i_cddip1_out_im_read_done[00:00]; 
      r32_mux_2_data[31:31] = i_cddip1_out_im_read_done[01:01]; 
    end
    `CR_KME_CDDIP2_OUT_IA_CAPABILITY: begin
      r32_mux_2_data[00:00] = i_cddip2_out_ia_capability[00:00]; 
      r32_mux_2_data[01:01] = i_cddip2_out_ia_capability[01:01]; 
      r32_mux_2_data[02:02] = i_cddip2_out_ia_capability[02:02]; 
      r32_mux_2_data[03:03] = i_cddip2_out_ia_capability[03:03]; 
      r32_mux_2_data[04:04] = i_cddip2_out_ia_capability[04:04]; 
      r32_mux_2_data[05:05] = i_cddip2_out_ia_capability[05:05]; 
      r32_mux_2_data[06:06] = i_cddip2_out_ia_capability[06:06]; 
      r32_mux_2_data[07:07] = i_cddip2_out_ia_capability[07:07]; 
      r32_mux_2_data[08:08] = i_cddip2_out_ia_capability[08:08]; 
      r32_mux_2_data[09:09] = i_cddip2_out_ia_capability[09:09]; 
      r32_mux_2_data[13:10] = i_cddip2_out_ia_capability[13:10]; 
      r32_mux_2_data[14:14] = i_cddip2_out_ia_capability[14:14]; 
      r32_mux_2_data[15:15] = i_cddip2_out_ia_capability[15:15]; 
      r32_mux_2_data[31:28] = i_cddip2_out_ia_capability[19:16]; 
    end
    `CR_KME_CDDIP2_OUT_IA_STATUS: begin
      r32_mux_2_data[08:00] = i_cddip2_out_ia_status[08:00]; 
      r32_mux_2_data[28:24] = i_cddip2_out_ia_status[13:09]; 
      r32_mux_2_data[31:29] = i_cddip2_out_ia_status[16:14]; 
    end
    `CR_KME_CDDIP2_OUT_IA_WDATA_PART0: begin
      r32_mux_2_data[05:00] = o_cddip2_out_ia_wdata_part0[05:00]; 
      r32_mux_2_data[13:06] = o_cddip2_out_ia_wdata_part0[13:06]; 
      r32_mux_2_data[14:14] = o_cddip2_out_ia_wdata_part0[14:14]; 
      r32_mux_2_data[22:15] = o_cddip2_out_ia_wdata_part0[22:15]; 
      r32_mux_2_data[30:23] = o_cddip2_out_ia_wdata_part0[30:23]; 
      r32_mux_2_data[31:31] = o_cddip2_out_ia_wdata_part0[31:31]; 
    end
    `CR_KME_CDDIP2_OUT_IA_WDATA_PART1: begin
      r32_mux_2_data[31:00] = o_cddip2_out_ia_wdata_part1[31:00]; 
    end
    `CR_KME_CDDIP2_OUT_IA_WDATA_PART2: begin
      r32_mux_2_data[31:00] = o_cddip2_out_ia_wdata_part2[31:00]; 
    end
    `CR_KME_CDDIP2_OUT_IA_CONFIG: begin
      r32_mux_2_data[08:00] = o_cddip2_out_ia_config[08:00]; 
      r32_mux_2_data[31:28] = o_cddip2_out_ia_config[12:09]; 
    end
    `CR_KME_CDDIP2_OUT_IA_RDATA_PART0: begin
      r32_mux_2_data[05:00] = i_cddip2_out_ia_rdata_part0[05:00]; 
      r32_mux_2_data[13:06] = i_cddip2_out_ia_rdata_part0[13:06]; 
      r32_mux_2_data[14:14] = i_cddip2_out_ia_rdata_part0[14:14]; 
      r32_mux_2_data[22:15] = i_cddip2_out_ia_rdata_part0[22:15]; 
      r32_mux_2_data[30:23] = i_cddip2_out_ia_rdata_part0[30:23]; 
      r32_mux_2_data[31:31] = i_cddip2_out_ia_rdata_part0[31:31]; 
    end
    `CR_KME_CDDIP2_OUT_IA_RDATA_PART1: begin
      r32_mux_2_data[31:00] = i_cddip2_out_ia_rdata_part1[31:00]; 
    end
    `CR_KME_CDDIP2_OUT_IA_RDATA_PART2: begin
      r32_mux_2_data[31:00] = i_cddip2_out_ia_rdata_part2[31:00]; 
    end
    `CR_KME_CDDIP2_OUT_IM_CONFIG: begin
      r32_mux_2_data[09:00] = o_cddip2_out_im_config[09:00]; 
      r32_mux_2_data[31:30] = o_cddip2_out_im_config[11:10]; 
    end
    `CR_KME_CDDIP2_OUT_IM_STATUS: begin
      r32_mux_2_data[08:00] = i_cddip2_out_im_status[08:00]; 
      r32_mux_2_data[29:29] = i_cddip2_out_im_status[09:09]; 
      r32_mux_2_data[30:30] = i_cddip2_out_im_status[10:10]; 
      r32_mux_2_data[31:31] = i_cddip2_out_im_status[11:11]; 
    end
    `CR_KME_CDDIP2_OUT_IM_READ_DONE: begin
      r32_mux_2_data[30:30] = i_cddip2_out_im_read_done[00:00]; 
      r32_mux_2_data[31:31] = i_cddip2_out_im_read_done[01:01]; 
    end
    `CR_KME_CDDIP3_OUT_IA_CAPABILITY: begin
      r32_mux_2_data[00:00] = i_cddip3_out_ia_capability[00:00]; 
      r32_mux_2_data[01:01] = i_cddip3_out_ia_capability[01:01]; 
      r32_mux_2_data[02:02] = i_cddip3_out_ia_capability[02:02]; 
      r32_mux_2_data[03:03] = i_cddip3_out_ia_capability[03:03]; 
      r32_mux_2_data[04:04] = i_cddip3_out_ia_capability[04:04]; 
      r32_mux_2_data[05:05] = i_cddip3_out_ia_capability[05:05]; 
      r32_mux_2_data[06:06] = i_cddip3_out_ia_capability[06:06]; 
      r32_mux_2_data[07:07] = i_cddip3_out_ia_capability[07:07]; 
      r32_mux_2_data[08:08] = i_cddip3_out_ia_capability[08:08]; 
      r32_mux_2_data[09:09] = i_cddip3_out_ia_capability[09:09]; 
      r32_mux_2_data[13:10] = i_cddip3_out_ia_capability[13:10]; 
      r32_mux_2_data[14:14] = i_cddip3_out_ia_capability[14:14]; 
      r32_mux_2_data[15:15] = i_cddip3_out_ia_capability[15:15]; 
      r32_mux_2_data[31:28] = i_cddip3_out_ia_capability[19:16]; 
    end
    `CR_KME_CDDIP3_OUT_IA_STATUS: begin
      r32_mux_2_data[08:00] = i_cddip3_out_ia_status[08:00]; 
      r32_mux_2_data[28:24] = i_cddip3_out_ia_status[13:09]; 
      r32_mux_2_data[31:29] = i_cddip3_out_ia_status[16:14]; 
    end
    `CR_KME_CDDIP3_OUT_IA_WDATA_PART0: begin
      r32_mux_2_data[05:00] = o_cddip3_out_ia_wdata_part0[05:00]; 
      r32_mux_2_data[13:06] = o_cddip3_out_ia_wdata_part0[13:06]; 
      r32_mux_2_data[14:14] = o_cddip3_out_ia_wdata_part0[14:14]; 
      r32_mux_2_data[22:15] = o_cddip3_out_ia_wdata_part0[22:15]; 
      r32_mux_2_data[30:23] = o_cddip3_out_ia_wdata_part0[30:23]; 
      r32_mux_2_data[31:31] = o_cddip3_out_ia_wdata_part0[31:31]; 
    end
    endcase

    case (ws_read_addr)
    `CR_KME_CDDIP3_OUT_IA_WDATA_PART1: begin
      r32_mux_3_data[31:00] = o_cddip3_out_ia_wdata_part1[31:00]; 
    end
    `CR_KME_CDDIP3_OUT_IA_WDATA_PART2: begin
      r32_mux_3_data[31:00] = o_cddip3_out_ia_wdata_part2[31:00]; 
    end
    `CR_KME_CDDIP3_OUT_IA_CONFIG: begin
      r32_mux_3_data[08:00] = o_cddip3_out_ia_config[08:00]; 
      r32_mux_3_data[31:28] = o_cddip3_out_ia_config[12:09]; 
    end
    `CR_KME_CDDIP3_OUT_IA_RDATA_PART0: begin
      r32_mux_3_data[05:00] = i_cddip3_out_ia_rdata_part0[05:00]; 
      r32_mux_3_data[13:06] = i_cddip3_out_ia_rdata_part0[13:06]; 
      r32_mux_3_data[14:14] = i_cddip3_out_ia_rdata_part0[14:14]; 
      r32_mux_3_data[22:15] = i_cddip3_out_ia_rdata_part0[22:15]; 
      r32_mux_3_data[30:23] = i_cddip3_out_ia_rdata_part0[30:23]; 
      r32_mux_3_data[31:31] = i_cddip3_out_ia_rdata_part0[31:31]; 
    end
    `CR_KME_CDDIP3_OUT_IA_RDATA_PART1: begin
      r32_mux_3_data[31:00] = i_cddip3_out_ia_rdata_part1[31:00]; 
    end
    `CR_KME_CDDIP3_OUT_IA_RDATA_PART2: begin
      r32_mux_3_data[31:00] = i_cddip3_out_ia_rdata_part2[31:00]; 
    end
    `CR_KME_CDDIP3_OUT_IM_CONFIG: begin
      r32_mux_3_data[09:00] = o_cddip3_out_im_config[09:00]; 
      r32_mux_3_data[31:30] = o_cddip3_out_im_config[11:10]; 
    end
    `CR_KME_CDDIP3_OUT_IM_STATUS: begin
      r32_mux_3_data[08:00] = i_cddip3_out_im_status[08:00]; 
      r32_mux_3_data[29:29] = i_cddip3_out_im_status[09:09]; 
      r32_mux_3_data[30:30] = i_cddip3_out_im_status[10:10]; 
      r32_mux_3_data[31:31] = i_cddip3_out_im_status[11:11]; 
    end
    `CR_KME_CDDIP3_OUT_IM_READ_DONE: begin
      r32_mux_3_data[30:30] = i_cddip3_out_im_read_done[00:00]; 
      r32_mux_3_data[31:31] = i_cddip3_out_im_read_done[01:01]; 
    end
    `CR_KME_CKV_IA_CAPABILITY: begin
      r32_mux_3_data[00:00] = i_ckv_ia_capability[00:00]; 
      r32_mux_3_data[01:01] = i_ckv_ia_capability[01:01]; 
      r32_mux_3_data[02:02] = i_ckv_ia_capability[02:02]; 
      r32_mux_3_data[03:03] = i_ckv_ia_capability[03:03]; 
      r32_mux_3_data[04:04] = i_ckv_ia_capability[04:04]; 
      r32_mux_3_data[05:05] = i_ckv_ia_capability[05:05]; 
      r32_mux_3_data[06:06] = i_ckv_ia_capability[06:06]; 
      r32_mux_3_data[07:07] = i_ckv_ia_capability[07:07]; 
      r32_mux_3_data[08:08] = i_ckv_ia_capability[08:08]; 
      r32_mux_3_data[09:09] = i_ckv_ia_capability[09:09]; 
      r32_mux_3_data[13:10] = i_ckv_ia_capability[13:10]; 
      r32_mux_3_data[14:14] = i_ckv_ia_capability[14:14]; 
      r32_mux_3_data[15:15] = i_ckv_ia_capability[15:15]; 
      r32_mux_3_data[31:28] = i_ckv_ia_capability[19:16]; 
    end
    `CR_KME_CKV_IA_STATUS: begin
      r32_mux_3_data[14:00] = i_ckv_ia_status[14:00]; 
      r32_mux_3_data[28:24] = i_ckv_ia_status[19:15]; 
      r32_mux_3_data[31:29] = i_ckv_ia_status[22:20]; 
    end
    `CR_KME_CKV_IA_WDATA_PART0: begin
      r32_mux_3_data[31:00] = o_ckv_ia_wdata_part0[31:00]; 
    end
    `CR_KME_CKV_IA_WDATA_PART1: begin
      r32_mux_3_data[31:00] = o_ckv_ia_wdata_part1[31:00]; 
    end
    `CR_KME_CKV_IA_CONFIG: begin
      r32_mux_3_data[14:00] = o_ckv_ia_config[14:00]; 
      r32_mux_3_data[31:28] = o_ckv_ia_config[18:15]; 
    end
    `CR_KME_CKV_IA_RDATA_PART0: begin
      r32_mux_3_data[31:00] = i_ckv_ia_rdata_part0[31:00]; 
    end
    `CR_KME_CKV_IA_RDATA_PART1: begin
      r32_mux_3_data[31:00] = i_ckv_ia_rdata_part1[31:00]; 
    end
    `CR_KME_KIM_IA_CAPABILITY: begin
      r32_mux_3_data[00:00] = i_kim_ia_capability[00:00]; 
      r32_mux_3_data[01:01] = i_kim_ia_capability[01:01]; 
      r32_mux_3_data[02:02] = i_kim_ia_capability[02:02]; 
      r32_mux_3_data[03:03] = i_kim_ia_capability[03:03]; 
      r32_mux_3_data[04:04] = i_kim_ia_capability[04:04]; 
      r32_mux_3_data[05:05] = i_kim_ia_capability[05:05]; 
      r32_mux_3_data[06:06] = i_kim_ia_capability[06:06]; 
      r32_mux_3_data[07:07] = i_kim_ia_capability[07:07]; 
      r32_mux_3_data[08:08] = i_kim_ia_capability[08:08]; 
      r32_mux_3_data[09:09] = i_kim_ia_capability[09:09]; 
      r32_mux_3_data[13:10] = i_kim_ia_capability[13:10]; 
      r32_mux_3_data[14:14] = i_kim_ia_capability[14:14]; 
      r32_mux_3_data[15:15] = i_kim_ia_capability[15:15]; 
      r32_mux_3_data[31:28] = i_kim_ia_capability[19:16]; 
    end
    `CR_KME_KIM_IA_STATUS: begin
      r32_mux_3_data[13:00] = i_kim_ia_status[13:00]; 
      r32_mux_3_data[28:24] = i_kim_ia_status[18:14]; 
      r32_mux_3_data[31:29] = i_kim_ia_status[21:19]; 
    end
    `CR_KME_KIM_IA_WDATA_PART0: begin
      r32_mux_3_data[14:00] = o_kim_ia_wdata_part0[14:00]; 
      r32_mux_3_data[27:26] = o_kim_ia_wdata_part0[16:15]; 
      r32_mux_3_data[30:28] = o_kim_ia_wdata_part0[19:17]; 
      r32_mux_3_data[31:31] = o_kim_ia_wdata_part0[20:20]; 
    end
    `CR_KME_KIM_IA_WDATA_PART1: begin
      r32_mux_3_data[00:00] = o_kim_ia_wdata_part1[00:00]; 
      r32_mux_3_data[12:01] = o_kim_ia_wdata_part1[12:01]; 
      r32_mux_3_data[31:28] = o_kim_ia_wdata_part1[16:13]; 
    end
    `CR_KME_KIM_IA_CONFIG: begin
      r32_mux_3_data[13:00] = o_kim_ia_config[13:00]; 
      r32_mux_3_data[31:28] = o_kim_ia_config[17:14]; 
    end
    `CR_KME_KIM_IA_RDATA_PART0: begin
      r32_mux_3_data[14:00] = i_kim_ia_rdata_part0[14:00]; 
      r32_mux_3_data[27:26] = i_kim_ia_rdata_part0[16:15]; 
      r32_mux_3_data[30:28] = i_kim_ia_rdata_part0[19:17]; 
      r32_mux_3_data[31:31] = i_kim_ia_rdata_part0[20:20]; 
    end
    `CR_KME_KIM_IA_RDATA_PART1: begin
      r32_mux_3_data[00:00] = i_kim_ia_rdata_part1[00:00]; 
      r32_mux_3_data[12:01] = i_kim_ia_rdata_part1[12:01]; 
      r32_mux_3_data[31:28] = i_kim_ia_rdata_part1[16:13]; 
    end
    `CR_KME_LABEL0_CONFIG: begin
      r32_mux_3_data[07:00] = o_label0_config[07:00]; 
      r32_mux_3_data[08:08] = o_label0_config[08:08]; 
      r32_mux_3_data[30:25] = o_label0_config[14:09]; 
      r32_mux_3_data[31:31] = o_label0_config[15:15]; 
    end
    `CR_KME_LABEL0_DATA7: begin
      r32_mux_3_data[31:00] = o_label0_data7[31:00]; 
    end
    `CR_KME_LABEL0_DATA6: begin
      r32_mux_3_data[31:00] = o_label0_data6[31:00]; 
    end
    `CR_KME_LABEL0_DATA5: begin
      r32_mux_3_data[31:00] = o_label0_data5[31:00]; 
    end
    `CR_KME_LABEL0_DATA4: begin
      r32_mux_3_data[31:00] = o_label0_data4[31:00]; 
    end
    `CR_KME_LABEL0_DATA3: begin
      r32_mux_3_data[31:00] = o_label0_data3[31:00]; 
    end
    `CR_KME_LABEL0_DATA2: begin
      r32_mux_3_data[31:00] = o_label0_data2[31:00]; 
    end
    endcase

    case (ws_read_addr)
    `CR_KME_LABEL0_DATA1: begin
      r32_mux_4_data[31:00] = o_label0_data1[31:00]; 
    end
    `CR_KME_LABEL0_DATA0: begin
      r32_mux_4_data[31:00] = o_label0_data0[31:00]; 
    end
    `CR_KME_LABEL1_CONFIG: begin
      r32_mux_4_data[07:00] = o_label1_config[07:00]; 
      r32_mux_4_data[08:08] = o_label1_config[08:08]; 
      r32_mux_4_data[30:25] = o_label1_config[14:09]; 
      r32_mux_4_data[31:31] = o_label1_config[15:15]; 
    end
    `CR_KME_LABEL1_DATA7: begin
      r32_mux_4_data[31:00] = o_label1_data7[31:00]; 
    end
    `CR_KME_LABEL1_DATA6: begin
      r32_mux_4_data[31:00] = o_label1_data6[31:00]; 
    end
    `CR_KME_LABEL1_DATA5: begin
      r32_mux_4_data[31:00] = o_label1_data5[31:00]; 
    end
    `CR_KME_LABEL1_DATA4: begin
      r32_mux_4_data[31:00] = o_label1_data4[31:00]; 
    end
    `CR_KME_LABEL1_DATA3: begin
      r32_mux_4_data[31:00] = o_label1_data3[31:00]; 
    end
    `CR_KME_LABEL1_DATA2: begin
      r32_mux_4_data[31:00] = o_label1_data2[31:00]; 
    end
    `CR_KME_LABEL1_DATA1: begin
      r32_mux_4_data[31:00] = o_label1_data1[31:00]; 
    end
    `CR_KME_LABEL1_DATA0: begin
      r32_mux_4_data[31:00] = o_label1_data0[31:00]; 
    end
    `CR_KME_LABEL2_CONFIG: begin
      r32_mux_4_data[07:00] = o_label2_config[07:00]; 
      r32_mux_4_data[08:08] = o_label2_config[08:08]; 
      r32_mux_4_data[30:25] = o_label2_config[14:09]; 
      r32_mux_4_data[31:31] = o_label2_config[15:15]; 
    end
    `CR_KME_LABEL2_DATA7: begin
      r32_mux_4_data[31:00] = o_label2_data7[31:00]; 
    end
    `CR_KME_LABEL2_DATA6: begin
      r32_mux_4_data[31:00] = o_label2_data6[31:00]; 
    end
    `CR_KME_LABEL2_DATA5: begin
      r32_mux_4_data[31:00] = o_label2_data5[31:00]; 
    end
    `CR_KME_LABEL2_DATA4: begin
      r32_mux_4_data[31:00] = o_label2_data4[31:00]; 
    end
    `CR_KME_LABEL2_DATA3: begin
      r32_mux_4_data[31:00] = o_label2_data3[31:00]; 
    end
    `CR_KME_LABEL2_DATA2: begin
      r32_mux_4_data[31:00] = o_label2_data2[31:00]; 
    end
    `CR_KME_LABEL2_DATA1: begin
      r32_mux_4_data[31:00] = o_label2_data1[31:00]; 
    end
    `CR_KME_LABEL2_DATA0: begin
      r32_mux_4_data[31:00] = o_label2_data0[31:00]; 
    end
    `CR_KME_LABEL3_CONFIG: begin
      r32_mux_4_data[07:00] = o_label3_config[07:00]; 
      r32_mux_4_data[08:08] = o_label3_config[08:08]; 
      r32_mux_4_data[30:25] = o_label3_config[14:09]; 
      r32_mux_4_data[31:31] = o_label3_config[15:15]; 
    end
    `CR_KME_LABEL3_DATA7: begin
      r32_mux_4_data[31:00] = o_label3_data7[31:00]; 
    end
    `CR_KME_LABEL3_DATA6: begin
      r32_mux_4_data[31:00] = o_label3_data6[31:00]; 
    end
    `CR_KME_LABEL3_DATA5: begin
      r32_mux_4_data[31:00] = o_label3_data5[31:00]; 
    end
    `CR_KME_LABEL3_DATA4: begin
      r32_mux_4_data[31:00] = o_label3_data4[31:00]; 
    end
    `CR_KME_LABEL3_DATA3: begin
      r32_mux_4_data[31:00] = o_label3_data3[31:00]; 
    end
    `CR_KME_LABEL3_DATA2: begin
      r32_mux_4_data[31:00] = o_label3_data2[31:00]; 
    end
    `CR_KME_LABEL3_DATA1: begin
      r32_mux_4_data[31:00] = o_label3_data1[31:00]; 
    end
    `CR_KME_LABEL3_DATA0: begin
      r32_mux_4_data[31:00] = o_label3_data0[31:00]; 
    end
    `CR_KME_LABEL4_CONFIG: begin
      r32_mux_4_data[07:00] = o_label4_config[07:00]; 
      r32_mux_4_data[08:08] = o_label4_config[08:08]; 
      r32_mux_4_data[30:25] = o_label4_config[14:09]; 
      r32_mux_4_data[31:31] = o_label4_config[15:15]; 
    end
    endcase

    case (ws_read_addr)
    `CR_KME_LABEL4_DATA7: begin
      r32_mux_5_data[31:00] = o_label4_data7[31:00]; 
    end
    `CR_KME_LABEL4_DATA6: begin
      r32_mux_5_data[31:00] = o_label4_data6[31:00]; 
    end
    `CR_KME_LABEL4_DATA5: begin
      r32_mux_5_data[31:00] = o_label4_data5[31:00]; 
    end
    `CR_KME_LABEL4_DATA4: begin
      r32_mux_5_data[31:00] = o_label4_data4[31:00]; 
    end
    `CR_KME_LABEL4_DATA3: begin
      r32_mux_5_data[31:00] = o_label4_data3[31:00]; 
    end
    `CR_KME_LABEL4_DATA2: begin
      r32_mux_5_data[31:00] = o_label4_data2[31:00]; 
    end
    `CR_KME_LABEL4_DATA1: begin
      r32_mux_5_data[31:00] = o_label4_data1[31:00]; 
    end
    `CR_KME_LABEL4_DATA0: begin
      r32_mux_5_data[31:00] = o_label4_data0[31:00]; 
    end
    `CR_KME_LABEL5_CONFIG: begin
      r32_mux_5_data[07:00] = o_label5_config[07:00]; 
      r32_mux_5_data[08:08] = o_label5_config[08:08]; 
      r32_mux_5_data[30:25] = o_label5_config[14:09]; 
      r32_mux_5_data[31:31] = o_label5_config[15:15]; 
    end
    `CR_KME_LABEL5_DATA7: begin
      r32_mux_5_data[31:00] = o_label5_data7[31:00]; 
    end
    `CR_KME_LABEL5_DATA6: begin
      r32_mux_5_data[31:00] = o_label5_data6[31:00]; 
    end
    `CR_KME_LABEL5_DATA5: begin
      r32_mux_5_data[31:00] = o_label5_data5[31:00]; 
    end
    `CR_KME_LABEL5_DATA4: begin
      r32_mux_5_data[31:00] = o_label5_data4[31:00]; 
    end
    `CR_KME_LABEL5_DATA3: begin
      r32_mux_5_data[31:00] = o_label5_data3[31:00]; 
    end
    `CR_KME_LABEL5_DATA2: begin
      r32_mux_5_data[31:00] = o_label5_data2[31:00]; 
    end
    `CR_KME_LABEL5_DATA1: begin
      r32_mux_5_data[31:00] = o_label5_data1[31:00]; 
    end
    `CR_KME_LABEL5_DATA0: begin
      r32_mux_5_data[31:00] = o_label5_data0[31:00]; 
    end
    `CR_KME_LABEL6_CONFIG: begin
      r32_mux_5_data[07:00] = o_label6_config[07:00]; 
      r32_mux_5_data[08:08] = o_label6_config[08:08]; 
      r32_mux_5_data[30:25] = o_label6_config[14:09]; 
      r32_mux_5_data[31:31] = o_label6_config[15:15]; 
    end
    `CR_KME_LABEL6_DATA7: begin
      r32_mux_5_data[31:00] = o_label6_data7[31:00]; 
    end
    `CR_KME_LABEL6_DATA6: begin
      r32_mux_5_data[31:00] = o_label6_data6[31:00]; 
    end
    `CR_KME_LABEL6_DATA5: begin
      r32_mux_5_data[31:00] = o_label6_data5[31:00]; 
    end
    `CR_KME_LABEL6_DATA4: begin
      r32_mux_5_data[31:00] = o_label6_data4[31:00]; 
    end
    `CR_KME_LABEL6_DATA3: begin
      r32_mux_5_data[31:00] = o_label6_data3[31:00]; 
    end
    `CR_KME_LABEL6_DATA2: begin
      r32_mux_5_data[31:00] = o_label6_data2[31:00]; 
    end
    `CR_KME_LABEL6_DATA1: begin
      r32_mux_5_data[31:00] = o_label6_data1[31:00]; 
    end
    `CR_KME_LABEL6_DATA0: begin
      r32_mux_5_data[31:00] = o_label6_data0[31:00]; 
    end
    `CR_KME_LABEL7_CONFIG: begin
      r32_mux_5_data[07:00] = o_label7_config[07:00]; 
      r32_mux_5_data[08:08] = o_label7_config[08:08]; 
      r32_mux_5_data[30:25] = o_label7_config[14:09]; 
      r32_mux_5_data[31:31] = o_label7_config[15:15]; 
    end
    `CR_KME_LABEL7_DATA7: begin
      r32_mux_5_data[31:00] = o_label7_data7[31:00]; 
    end
    `CR_KME_LABEL7_DATA6: begin
      r32_mux_5_data[31:00] = o_label7_data6[31:00]; 
    end
    `CR_KME_LABEL7_DATA5: begin
      r32_mux_5_data[31:00] = o_label7_data5[31:00]; 
    end
    endcase

    case (ws_read_addr)
    `CR_KME_LABEL7_DATA4: begin
      r32_mux_6_data[31:00] = o_label7_data4[31:00]; 
    end
    `CR_KME_LABEL7_DATA3: begin
      r32_mux_6_data[31:00] = o_label7_data3[31:00]; 
    end
    `CR_KME_LABEL7_DATA2: begin
      r32_mux_6_data[31:00] = o_label7_data2[31:00]; 
    end
    `CR_KME_LABEL7_DATA1: begin
      r32_mux_6_data[31:00] = o_label7_data1[31:00]; 
    end
    `CR_KME_LABEL7_DATA0: begin
      r32_mux_6_data[31:00] = o_label7_data0[31:00]; 
    end
    `CR_KME_KDF_DRBG_CTRL: begin
      r32_mux_6_data[01:00] = i_kdf_drbg_ctrl[01:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_0_STATE_KEY_31_0: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_0_state_key_31_0[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_0_STATE_KEY_63_32: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_0_state_key_63_32[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_0_STATE_KEY_95_64: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_0_state_key_95_64[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_0_STATE_KEY_127_96: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_0_state_key_127_96[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_0_STATE_KEY_159_128: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_0_state_key_159_128[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_0_STATE_KEY_191_160: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_0_state_key_191_160[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_0_STATE_KEY_223_192: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_0_state_key_223_192[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_0_STATE_KEY_255_224: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_0_state_key_255_224[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_0_STATE_VALUE_31_0: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_0_state_value_31_0[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_0_STATE_VALUE_63_32: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_0_state_value_63_32[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_0_STATE_VALUE_95_64: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_0_state_value_95_64[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_0_STATE_VALUE_127_96: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_0_state_value_127_96[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_0_RESEED_INTERVAL_0: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_0_reseed_interval_0[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_0_RESEED_INTERVAL_1: begin
      r32_mux_6_data[15:00] = o_kdf_drbg_seed_0_reseed_interval_1[15:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_1_STATE_KEY_31_0: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_1_state_key_31_0[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_1_STATE_KEY_63_32: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_1_state_key_63_32[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_1_STATE_KEY_95_64: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_1_state_key_95_64[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_1_STATE_KEY_127_96: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_1_state_key_127_96[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_1_STATE_KEY_159_128: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_1_state_key_159_128[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_1_STATE_KEY_191_160: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_1_state_key_191_160[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_1_STATE_KEY_223_192: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_1_state_key_223_192[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_1_STATE_KEY_255_224: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_1_state_key_255_224[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_1_STATE_VALUE_31_0: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_1_state_value_31_0[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_1_STATE_VALUE_63_32: begin
      r32_mux_6_data[31:00] = o_kdf_drbg_seed_1_state_value_63_32[31:00]; 
    end
    endcase

    case (ws_read_addr)
    `CR_KME_KDF_DRBG_SEED_1_STATE_VALUE_95_64: begin
      r32_mux_7_data[31:00] = o_kdf_drbg_seed_1_state_value_95_64[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_1_STATE_VALUE_127_96: begin
      r32_mux_7_data[31:00] = o_kdf_drbg_seed_1_state_value_127_96[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_1_RESEED_INTERVAL_0: begin
      r32_mux_7_data[31:00] = o_kdf_drbg_seed_1_reseed_interval_0[31:00]; 
    end
    `CR_KME_KDF_DRBG_SEED_1_RESEED_INTERVAL_1: begin
      r32_mux_7_data[15:00] = o_kdf_drbg_seed_1_reseed_interval_1[15:00]; 
    end
    `CR_KME_INTERRUPT_STATUS: begin
      r32_mux_7_data[00:00] = i_interrupt_status[00:00]; 
      r32_mux_7_data[01:01] = i_interrupt_status[01:01]; 
      r32_mux_7_data[02:02] = i_interrupt_status[02:02]; 
      r32_mux_7_data[03:03] = i_interrupt_status[03:03]; 
      r32_mux_7_data[04:04] = i_interrupt_status[04:04]; 
    end
    `CR_KME_INTERRUPT_MASK: begin
      r32_mux_7_data[00:00] = o_interrupt_mask[00:00]; 
      r32_mux_7_data[01:01] = o_interrupt_mask[01:01]; 
      r32_mux_7_data[02:02] = o_interrupt_mask[02:02]; 
      r32_mux_7_data[03:03] = o_interrupt_mask[03:03]; 
      r32_mux_7_data[04:04] = o_interrupt_mask[04:04]; 
    end
    `CR_KME_ENGINE_STICKY_STATUS: begin
      r32_mux_7_data[00:00] = i_engine_sticky_status[00:00]; 
      r32_mux_7_data[01:01] = i_engine_sticky_status[01:01]; 
      r32_mux_7_data[02:02] = i_engine_sticky_status[02:02]; 
      r32_mux_7_data[03:03] = i_engine_sticky_status[03:03]; 
      r32_mux_7_data[04:04] = i_engine_sticky_status[04:04]; 
      r32_mux_7_data[05:05] = i_engine_sticky_status[05:05]; 
      r32_mux_7_data[06:06] = i_engine_sticky_status[06:06]; 
      r32_mux_7_data[07:07] = i_engine_sticky_status[07:07]; 
    end
    `CR_KME_BIMC_MONITOR: begin
      r32_mux_7_data[00:00] = i_bimc_monitor[00:00]; 
      r32_mux_7_data[01:01] = i_bimc_monitor[01:01]; 
      r32_mux_7_data[02:02] = i_bimc_monitor[02:02]; 
      r32_mux_7_data[03:03] = i_bimc_monitor[03:03]; 
      r32_mux_7_data[04:04] = i_bimc_monitor[04:04]; 
      r32_mux_7_data[05:05] = i_bimc_monitor[05:05]; 
      r32_mux_7_data[06:06] = i_bimc_monitor[06:06]; 
    end
    `CR_KME_BIMC_MONITOR_MASK: begin
      r32_mux_7_data[00:00] = o_bimc_monitor_mask[00:00]; 
      r32_mux_7_data[01:01] = o_bimc_monitor_mask[01:01]; 
      r32_mux_7_data[02:02] = o_bimc_monitor_mask[02:02]; 
      r32_mux_7_data[03:03] = o_bimc_monitor_mask[03:03]; 
      r32_mux_7_data[04:04] = o_bimc_monitor_mask[04:04]; 
      r32_mux_7_data[05:05] = o_bimc_monitor_mask[05:05]; 
      r32_mux_7_data[06:06] = o_bimc_monitor_mask[06:06]; 
    end
    `CR_KME_BIMC_ECC_UNCORRECTABLE_ERROR_CNT: begin
      r32_mux_7_data[31:00] = i_bimc_ecc_uncorrectable_error_cnt[31:00]; 
    end
    `CR_KME_BIMC_ECC_CORRECTABLE_ERROR_CNT: begin
      r32_mux_7_data[31:00] = i_bimc_ecc_correctable_error_cnt[31:00]; 
    end
    `CR_KME_BIMC_PARITY_ERROR_CNT: begin
      r32_mux_7_data[31:00] = i_bimc_parity_error_cnt[31:00]; 
    end
    `CR_KME_BIMC_GLOBAL_CONFIG: begin
      r32_mux_7_data[00:00] = i_bimc_global_config[00:00]; 
      r32_mux_7_data[01:01] = i_bimc_global_config[01:01]; 
      r32_mux_7_data[02:02] = i_bimc_global_config[02:02]; 
      r32_mux_7_data[03:03] = i_bimc_global_config[03:03]; 
      r32_mux_7_data[04:04] = i_bimc_global_config[04:04]; 
      r32_mux_7_data[05:05] = i_bimc_global_config[05:05]; 
      r32_mux_7_data[31:06] = i_bimc_global_config[31:06]; 
    end
    `CR_KME_BIMC_MEMID: begin
      r32_mux_7_data[11:00] = i_bimc_memid[11:00]; 
    end
    `CR_KME_BIMC_ECCPAR_DEBUG: begin
      r32_mux_7_data[11:00] = i_bimc_eccpar_debug[11:00]; 
      r32_mux_7_data[15:12] = i_bimc_eccpar_debug[15:12]; 
      r32_mux_7_data[17:16] = i_bimc_eccpar_debug[17:16]; 
      r32_mux_7_data[19:18] = i_bimc_eccpar_debug[19:18]; 
      r32_mux_7_data[21:20] = i_bimc_eccpar_debug[21:20]; 
      r32_mux_7_data[22:22] = i_bimc_eccpar_debug[22:22]; 
      r32_mux_7_data[23:23] = i_bimc_eccpar_debug[23:23]; 
      r32_mux_7_data[27:24] = i_bimc_eccpar_debug[27:24]; 
      r32_mux_7_data[28:28] = i_bimc_eccpar_debug[28:28]; 
    end
    `CR_KME_BIMC_CMD2: begin
      r32_mux_7_data[07:00] = i_bimc_cmd2[07:00]; 
      r32_mux_7_data[08:08] = i_bimc_cmd2[08:08]; 
      r32_mux_7_data[09:09] = i_bimc_cmd2[09:09]; 
      r32_mux_7_data[10:10] = i_bimc_cmd2[10:10]; 
    end
    `CR_KME_BIMC_CMD1: begin
      r32_mux_7_data[15:00] = o_bimc_cmd1[15:00]; 
      r32_mux_7_data[27:16] = o_bimc_cmd1[27:16]; 
      r32_mux_7_data[31:28] = o_bimc_cmd1[31:28]; 
    end
    `CR_KME_BIMC_CMD0: begin
      r32_mux_7_data[31:00] = o_bimc_cmd0[31:00]; 
    end
    `CR_KME_BIMC_RXCMD2: begin
      r32_mux_7_data[07:00] = i_bimc_rxcmd2[07:00]; 
      r32_mux_7_data[08:08] = i_bimc_rxcmd2[08:08]; 
      r32_mux_7_data[09:09] = i_bimc_rxcmd2[09:09]; 
    end
    `CR_KME_BIMC_RXCMD1: begin
      r32_mux_7_data[15:00] = i_bimc_rxcmd1[15:00]; 
      r32_mux_7_data[27:16] = i_bimc_rxcmd1[27:16]; 
      r32_mux_7_data[31:28] = i_bimc_rxcmd1[31:28]; 
    end
    `CR_KME_BIMC_RXCMD0: begin
      r32_mux_7_data[31:00] = i_bimc_rxcmd0[31:00]; 
    end
    `CR_KME_BIMC_RXRSP2: begin
      r32_mux_7_data[07:00] = i_bimc_rxrsp2[07:00]; 
      r32_mux_7_data[08:08] = i_bimc_rxrsp2[08:08]; 
      r32_mux_7_data[09:09] = i_bimc_rxrsp2[09:09]; 
    end
    `CR_KME_BIMC_RXRSP1: begin
      r32_mux_7_data[31:00] = i_bimc_rxrsp1[31:00]; 
    end
    `CR_KME_BIMC_RXRSP0: begin
      r32_mux_7_data[31:00] = i_bimc_rxrsp0[31:00]; 
    end
    `CR_KME_BIMC_POLLRSP2: begin
      r32_mux_7_data[07:00] = i_bimc_pollrsp2[07:00]; 
      r32_mux_7_data[08:08] = i_bimc_pollrsp2[08:08]; 
      r32_mux_7_data[09:09] = i_bimc_pollrsp2[09:09]; 
    end
    `CR_KME_BIMC_POLLRSP1: begin
      r32_mux_7_data[31:00] = i_bimc_pollrsp1[31:00]; 
    end
    `CR_KME_BIMC_POLLRSP0: begin
      r32_mux_7_data[31:00] = i_bimc_pollrsp0[31:00]; 
    end
    `CR_KME_BIMC_DBGCMD2: begin
      r32_mux_7_data[07:00] = i_bimc_dbgcmd2[07:00]; 
      r32_mux_7_data[08:08] = i_bimc_dbgcmd2[08:08]; 
      r32_mux_7_data[09:09] = i_bimc_dbgcmd2[09:09]; 
    end
    `CR_KME_BIMC_DBGCMD1: begin
      r32_mux_7_data[15:00] = i_bimc_dbgcmd1[15:00]; 
      r32_mux_7_data[27:16] = i_bimc_dbgcmd1[27:16]; 
      r32_mux_7_data[31:28] = i_bimc_dbgcmd1[31:28]; 
    end
    `CR_KME_BIMC_DBGCMD0: begin
      r32_mux_7_data[31:00] = i_bimc_dbgcmd0[31:00]; 
    end
    endcase

    case (ws_read_addr)
    `CR_KME_IM_AVAILABLE: begin
      r32_mux_8_data[00:00] = i_im_available[00:00]; 
      r32_mux_8_data[01:01] = i_im_available[01:01]; 
      r32_mux_8_data[02:02] = i_im_available[02:02]; 
      r32_mux_8_data[03:03] = i_im_available[03:03]; 
      r32_mux_8_data[04:04] = i_im_available[04:04]; 
      r32_mux_8_data[05:05] = i_im_available[05:05]; 
      r32_mux_8_data[06:06] = i_im_available[06:06]; 
      r32_mux_8_data[07:07] = i_im_available[07:07]; 
      r32_mux_8_data[08:08] = i_im_available[08:08]; 
      r32_mux_8_data[09:09] = i_im_available[09:09]; 
      r32_mux_8_data[10:10] = i_im_available[10:10]; 
      r32_mux_8_data[11:11] = i_im_available[11:11]; 
      r32_mux_8_data[12:12] = i_im_available[12:12]; 
      r32_mux_8_data[13:13] = i_im_available[13:13]; 
      r32_mux_8_data[14:14] = i_im_available[14:14]; 
      r32_mux_8_data[15:15] = i_im_available[15:15]; 
    end
    `CR_KME_IM_CONSUMED: begin
      r32_mux_8_data[00:00] = i_im_consumed[00:00]; 
      r32_mux_8_data[01:01] = i_im_consumed[01:01]; 
      r32_mux_8_data[02:02] = i_im_consumed[02:02]; 
      r32_mux_8_data[03:03] = i_im_consumed[03:03]; 
      r32_mux_8_data[04:04] = i_im_consumed[04:04]; 
      r32_mux_8_data[05:05] = i_im_consumed[05:05]; 
      r32_mux_8_data[06:06] = i_im_consumed[06:06]; 
      r32_mux_8_data[07:07] = i_im_consumed[07:07]; 
      r32_mux_8_data[08:08] = i_im_consumed[08:08]; 
      r32_mux_8_data[09:09] = i_im_consumed[09:09]; 
      r32_mux_8_data[10:10] = i_im_consumed[10:10]; 
      r32_mux_8_data[11:11] = i_im_consumed[11:11]; 
      r32_mux_8_data[12:12] = i_im_consumed[12:12]; 
      r32_mux_8_data[13:13] = i_im_consumed[13:13]; 
      r32_mux_8_data[14:14] = i_im_consumed[14:14]; 
      r32_mux_8_data[15:15] = i_im_consumed[15:15]; 
    end
    `CR_KME_TREADY_OVERRIDE: begin
      r32_mux_8_data[00:00] = i_tready_override[00:00]; 
      r32_mux_8_data[01:01] = i_tready_override[01:01]; 
      r32_mux_8_data[02:02] = i_tready_override[02:02]; 
      r32_mux_8_data[03:03] = i_tready_override[03:03]; 
      r32_mux_8_data[04:04] = i_tready_override[04:04]; 
      r32_mux_8_data[05:05] = i_tready_override[05:05]; 
      r32_mux_8_data[06:06] = i_tready_override[06:06]; 
      r32_mux_8_data[07:07] = i_tready_override[07:07]; 
      r32_mux_8_data[08:08] = i_tready_override[08:08]; 
    end
    `CR_KME_REGS_SA_CTRL: begin
      r32_mux_8_data[00:00] = i_regs_sa_ctrl[00:00]; 
      r32_mux_8_data[01:01] = i_regs_sa_ctrl[01:01]; 
      r32_mux_8_data[07:02] = i_regs_sa_ctrl[07:02]; 
      r32_mux_8_data[12:08] = i_regs_sa_ctrl[12:08]; 
      r32_mux_8_data[31:13] = i_regs_sa_ctrl[31:13]; 
    end
    `CR_KME_SA_SNAPSHOT_IA_CAPABILITY: begin
      r32_mux_8_data[00:00] = i_sa_snapshot_ia_capability[00:00]; 
      r32_mux_8_data[01:01] = i_sa_snapshot_ia_capability[01:01]; 
      r32_mux_8_data[02:02] = i_sa_snapshot_ia_capability[02:02]; 
      r32_mux_8_data[03:03] = i_sa_snapshot_ia_capability[03:03]; 
      r32_mux_8_data[04:04] = i_sa_snapshot_ia_capability[04:04]; 
      r32_mux_8_data[05:05] = i_sa_snapshot_ia_capability[05:05]; 
      r32_mux_8_data[06:06] = i_sa_snapshot_ia_capability[06:06]; 
      r32_mux_8_data[07:07] = i_sa_snapshot_ia_capability[07:07]; 
      r32_mux_8_data[08:08] = i_sa_snapshot_ia_capability[08:08]; 
      r32_mux_8_data[09:09] = i_sa_snapshot_ia_capability[09:09]; 
      r32_mux_8_data[13:10] = i_sa_snapshot_ia_capability[13:10]; 
      r32_mux_8_data[14:14] = i_sa_snapshot_ia_capability[14:14]; 
      r32_mux_8_data[15:15] = i_sa_snapshot_ia_capability[15:15]; 
      r32_mux_8_data[31:28] = i_sa_snapshot_ia_capability[19:16]; 
    end
    `CR_KME_SA_SNAPSHOT_IA_STATUS: begin
      r32_mux_8_data[04:00] = i_sa_snapshot_ia_status[04:00]; 
      r32_mux_8_data[28:24] = i_sa_snapshot_ia_status[09:05]; 
      r32_mux_8_data[31:29] = i_sa_snapshot_ia_status[12:10]; 
    end
    `CR_KME_SA_SNAPSHOT_IA_WDATA_PART0: begin
      r32_mux_8_data[17:00] = o_sa_snapshot_ia_wdata_part0[17:00]; 
      r32_mux_8_data[31:18] = o_sa_snapshot_ia_wdata_part0[31:18]; 
    end
    `CR_KME_SA_SNAPSHOT_IA_WDATA_PART1: begin
      r32_mux_8_data[31:00] = o_sa_snapshot_ia_wdata_part1[31:00]; 
    end
    `CR_KME_SA_SNAPSHOT_IA_CONFIG: begin
      r32_mux_8_data[04:00] = o_sa_snapshot_ia_config[04:00]; 
      r32_mux_8_data[31:28] = o_sa_snapshot_ia_config[08:05]; 
    end
    `CR_KME_SA_SNAPSHOT_IA_RDATA_PART0: begin
      r32_mux_8_data[17:00] = i_sa_snapshot_ia_rdata_part0[17:00]; 
      r32_mux_8_data[31:18] = i_sa_snapshot_ia_rdata_part0[31:18]; 
    end
    `CR_KME_SA_SNAPSHOT_IA_RDATA_PART1: begin
      r32_mux_8_data[31:00] = i_sa_snapshot_ia_rdata_part1[31:00]; 
    end
    `CR_KME_SA_COUNT_IA_CAPABILITY: begin
      r32_mux_8_data[00:00] = i_sa_count_ia_capability[00:00]; 
      r32_mux_8_data[01:01] = i_sa_count_ia_capability[01:01]; 
      r32_mux_8_data[02:02] = i_sa_count_ia_capability[02:02]; 
      r32_mux_8_data[03:03] = i_sa_count_ia_capability[03:03]; 
      r32_mux_8_data[04:04] = i_sa_count_ia_capability[04:04]; 
      r32_mux_8_data[05:05] = i_sa_count_ia_capability[05:05]; 
      r32_mux_8_data[06:06] = i_sa_count_ia_capability[06:06]; 
      r32_mux_8_data[07:07] = i_sa_count_ia_capability[07:07]; 
      r32_mux_8_data[08:08] = i_sa_count_ia_capability[08:08]; 
      r32_mux_8_data[09:09] = i_sa_count_ia_capability[09:09]; 
      r32_mux_8_data[13:10] = i_sa_count_ia_capability[13:10]; 
      r32_mux_8_data[14:14] = i_sa_count_ia_capability[14:14]; 
      r32_mux_8_data[15:15] = i_sa_count_ia_capability[15:15]; 
      r32_mux_8_data[31:28] = i_sa_count_ia_capability[19:16]; 
    end
    `CR_KME_SA_COUNT_IA_STATUS: begin
      r32_mux_8_data[04:00] = i_sa_count_ia_status[04:00]; 
      r32_mux_8_data[28:24] = i_sa_count_ia_status[09:05]; 
      r32_mux_8_data[31:29] = i_sa_count_ia_status[12:10]; 
    end
    `CR_KME_SA_COUNT_IA_WDATA_PART0: begin
      r32_mux_8_data[17:00] = o_sa_count_ia_wdata_part0[17:00]; 
      r32_mux_8_data[31:18] = o_sa_count_ia_wdata_part0[31:18]; 
    end
    `CR_KME_SA_COUNT_IA_WDATA_PART1: begin
      r32_mux_8_data[31:00] = o_sa_count_ia_wdata_part1[31:00]; 
    end
    `CR_KME_SA_COUNT_IA_CONFIG: begin
      r32_mux_8_data[04:00] = o_sa_count_ia_config[04:00]; 
      r32_mux_8_data[31:28] = o_sa_count_ia_config[08:05]; 
    end
    `CR_KME_SA_COUNT_IA_RDATA_PART0: begin
      r32_mux_8_data[17:00] = i_sa_count_ia_rdata_part0[17:00]; 
      r32_mux_8_data[31:18] = i_sa_count_ia_rdata_part0[31:18]; 
    end
    `CR_KME_SA_COUNT_IA_RDATA_PART1: begin
      r32_mux_8_data[31:00] = i_sa_count_ia_rdata_part1[31:00]; 
    end
    `CR_KME_IDLE_COMPONENTS: begin
      r32_mux_8_data[00:00] = i_idle_components[00:00]; 
      r32_mux_8_data[01:01] = i_idle_components[01:01]; 
      r32_mux_8_data[02:02] = i_idle_components[02:02]; 
      r32_mux_8_data[03:03] = i_idle_components[03:03]; 
      r32_mux_8_data[04:04] = i_idle_components[04:04]; 
      r32_mux_8_data[05:05] = i_idle_components[05:05]; 
      r32_mux_8_data[06:06] = i_idle_components[06:06]; 
      r32_mux_8_data[07:07] = i_idle_components[07:07]; 
      r32_mux_8_data[08:08] = i_idle_components[08:08]; 
      r32_mux_8_data[09:09] = i_idle_components[09:09]; 
      r32_mux_8_data[10:10] = i_idle_components[10:10]; 
      r32_mux_8_data[11:11] = i_idle_components[11:11]; 
      r32_mux_8_data[31:12] = i_idle_components[31:12]; 
    end
    `CR_KME_CCEIP_ENCRYPT_KOP_FIFO_OVERRIDE: begin
      r32_mux_8_data[00:00] = o_cceip_encrypt_kop_fifo_override[00:00]; 
      r32_mux_8_data[01:01] = o_cceip_encrypt_kop_fifo_override[01:01]; 
      r32_mux_8_data[02:02] = o_cceip_encrypt_kop_fifo_override[02:02]; 
      r32_mux_8_data[03:03] = o_cceip_encrypt_kop_fifo_override[03:03]; 
      r32_mux_8_data[04:04] = o_cceip_encrypt_kop_fifo_override[04:04]; 
      r32_mux_8_data[05:05] = o_cceip_encrypt_kop_fifo_override[05:05]; 
      r32_mux_8_data[06:06] = o_cceip_encrypt_kop_fifo_override[06:06]; 
    end
    `CR_KME_CCEIP_VALIDATE_KOP_FIFO_OVERRIDE: begin
      r32_mux_8_data[00:00] = o_cceip_validate_kop_fifo_override[00:00]; 
      r32_mux_8_data[01:01] = o_cceip_validate_kop_fifo_override[01:01]; 
      r32_mux_8_data[02:02] = o_cceip_validate_kop_fifo_override[02:02]; 
      r32_mux_8_data[03:03] = o_cceip_validate_kop_fifo_override[03:03]; 
      r32_mux_8_data[04:04] = o_cceip_validate_kop_fifo_override[04:04]; 
      r32_mux_8_data[05:05] = o_cceip_validate_kop_fifo_override[05:05]; 
      r32_mux_8_data[06:06] = o_cceip_validate_kop_fifo_override[06:06]; 
    end
    `CR_KME_CDDIP_DECRYPT_KOP_FIFO_OVERRIDE: begin
      r32_mux_8_data[00:00] = o_cddip_decrypt_kop_fifo_override[00:00]; 
      r32_mux_8_data[01:01] = o_cddip_decrypt_kop_fifo_override[01:01]; 
      r32_mux_8_data[02:02] = o_cddip_decrypt_kop_fifo_override[02:02]; 
      r32_mux_8_data[03:03] = o_cddip_decrypt_kop_fifo_override[03:03]; 
      r32_mux_8_data[04:04] = o_cddip_decrypt_kop_fifo_override[04:04]; 
      r32_mux_8_data[05:05] = o_cddip_decrypt_kop_fifo_override[05:05]; 
      r32_mux_8_data[06:06] = o_cddip_decrypt_kop_fifo_override[06:06]; 
    end
    `CR_KME_SA_GLOBAL_CTRL: begin
      r32_mux_8_data[00:00] = i_sa_global_ctrl[00:00]; 
      r32_mux_8_data[01:01] = i_sa_global_ctrl[01:01]; 
      r32_mux_8_data[31:02] = i_sa_global_ctrl[31:02]; 
    end
    `CR_KME_SA_CTRL_IA_CAPABILITY: begin
      r32_mux_8_data[00:00] = i_sa_ctrl_ia_capability[00:00]; 
      r32_mux_8_data[01:01] = i_sa_ctrl_ia_capability[01:01]; 
      r32_mux_8_data[02:02] = i_sa_ctrl_ia_capability[02:02]; 
      r32_mux_8_data[03:03] = i_sa_ctrl_ia_capability[03:03]; 
      r32_mux_8_data[04:04] = i_sa_ctrl_ia_capability[04:04]; 
      r32_mux_8_data[05:05] = i_sa_ctrl_ia_capability[05:05]; 
      r32_mux_8_data[06:06] = i_sa_ctrl_ia_capability[06:06]; 
      r32_mux_8_data[07:07] = i_sa_ctrl_ia_capability[07:07]; 
      r32_mux_8_data[08:08] = i_sa_ctrl_ia_capability[08:08]; 
      r32_mux_8_data[09:09] = i_sa_ctrl_ia_capability[09:09]; 
      r32_mux_8_data[13:10] = i_sa_ctrl_ia_capability[13:10]; 
      r32_mux_8_data[14:14] = i_sa_ctrl_ia_capability[14:14]; 
      r32_mux_8_data[15:15] = i_sa_ctrl_ia_capability[15:15]; 
      r32_mux_8_data[31:28] = i_sa_ctrl_ia_capability[19:16]; 
    end
    `CR_KME_SA_CTRL_IA_STATUS: begin
      r32_mux_8_data[04:00] = i_sa_ctrl_ia_status[04:00]; 
      r32_mux_8_data[28:24] = i_sa_ctrl_ia_status[09:05]; 
      r32_mux_8_data[31:29] = i_sa_ctrl_ia_status[12:10]; 
    end
    `CR_KME_SA_CTRL_IA_WDATA_PART0: begin
      r32_mux_8_data[04:00] = o_sa_ctrl_ia_wdata_part0[04:00]; 
      r32_mux_8_data[31:05] = o_sa_ctrl_ia_wdata_part0[31:05]; 
    end
    `CR_KME_SA_CTRL_IA_CONFIG: begin
      r32_mux_8_data[04:00] = o_sa_ctrl_ia_config[04:00]; 
      r32_mux_8_data[31:28] = o_sa_ctrl_ia_config[08:05]; 
    end
    `CR_KME_SA_CTRL_IA_RDATA_PART0: begin
      r32_mux_8_data[04:00] = i_sa_ctrl_ia_rdata_part0[04:00]; 
      r32_mux_8_data[31:05] = i_sa_ctrl_ia_rdata_part0[31:05]; 
    end
    `CR_KME_KDF_TEST_KEY_SIZE_CONFIG: begin
      r32_mux_8_data[31:00] = o_kdf_test_key_size_config[31:00]; 
    end
    endcase

  end

  
  

  
  

  reg  [31:0]  f32_data;

  assign o_reg_wr_data = f32_data;

  
  

  
  assign       o_rd_data  = (o_ack  & ~n_write) ? r32_formatted_reg_data : { 32 { 1'b0 } };
  

  
  

  wire w_load_spare_config                       = w_do_write & (ws_addr == `CR_KME_SPARE_CONFIG);
  wire w_load_cceip0_out_ia_wdata_part0          = w_do_write & (ws_addr == `CR_KME_CCEIP0_OUT_IA_WDATA_PART0);
  wire w_load_cceip0_out_ia_wdata_part1          = w_do_write & (ws_addr == `CR_KME_CCEIP0_OUT_IA_WDATA_PART1);
  wire w_load_cceip0_out_ia_wdata_part2          = w_do_write & (ws_addr == `CR_KME_CCEIP0_OUT_IA_WDATA_PART2);
  wire w_load_cceip0_out_ia_config               = w_do_write & (ws_addr == `CR_KME_CCEIP0_OUT_IA_CONFIG);
  wire w_load_cceip0_out_im_config               = w_do_write & (ws_addr == `CR_KME_CCEIP0_OUT_IM_CONFIG);
  wire w_load_cceip0_out_im_read_done            = w_do_write & (ws_addr == `CR_KME_CCEIP0_OUT_IM_READ_DONE);
  wire w_load_cceip1_out_ia_wdata_part0          = w_do_write & (ws_addr == `CR_KME_CCEIP1_OUT_IA_WDATA_PART0);
  wire w_load_cceip1_out_ia_wdata_part1          = w_do_write & (ws_addr == `CR_KME_CCEIP1_OUT_IA_WDATA_PART1);
  wire w_load_cceip1_out_ia_wdata_part2          = w_do_write & (ws_addr == `CR_KME_CCEIP1_OUT_IA_WDATA_PART2);
  wire w_load_cceip1_out_ia_config               = w_do_write & (ws_addr == `CR_KME_CCEIP1_OUT_IA_CONFIG);
  wire w_load_cceip1_out_im_config               = w_do_write & (ws_addr == `CR_KME_CCEIP1_OUT_IM_CONFIG);
  wire w_load_cceip1_out_im_read_done            = w_do_write & (ws_addr == `CR_KME_CCEIP1_OUT_IM_READ_DONE);
  wire w_load_cceip2_out_ia_wdata_part0          = w_do_write & (ws_addr == `CR_KME_CCEIP2_OUT_IA_WDATA_PART0);
  wire w_load_cceip2_out_ia_wdata_part1          = w_do_write & (ws_addr == `CR_KME_CCEIP2_OUT_IA_WDATA_PART1);
  wire w_load_cceip2_out_ia_wdata_part2          = w_do_write & (ws_addr == `CR_KME_CCEIP2_OUT_IA_WDATA_PART2);
  wire w_load_cceip2_out_ia_config               = w_do_write & (ws_addr == `CR_KME_CCEIP2_OUT_IA_CONFIG);
  wire w_load_cceip2_out_im_config               = w_do_write & (ws_addr == `CR_KME_CCEIP2_OUT_IM_CONFIG);
  wire w_load_cceip2_out_im_read_done            = w_do_write & (ws_addr == `CR_KME_CCEIP2_OUT_IM_READ_DONE);
  wire w_load_cceip3_out_ia_wdata_part0          = w_do_write & (ws_addr == `CR_KME_CCEIP3_OUT_IA_WDATA_PART0);
  wire w_load_cceip3_out_ia_wdata_part1          = w_do_write & (ws_addr == `CR_KME_CCEIP3_OUT_IA_WDATA_PART1);
  wire w_load_cceip3_out_ia_wdata_part2          = w_do_write & (ws_addr == `CR_KME_CCEIP3_OUT_IA_WDATA_PART2);
  wire w_load_cceip3_out_ia_config               = w_do_write & (ws_addr == `CR_KME_CCEIP3_OUT_IA_CONFIG);
  wire w_load_cceip3_out_im_config               = w_do_write & (ws_addr == `CR_KME_CCEIP3_OUT_IM_CONFIG);
  wire w_load_cceip3_out_im_read_done            = w_do_write & (ws_addr == `CR_KME_CCEIP3_OUT_IM_READ_DONE);
  wire w_load_cddip0_out_ia_wdata_part0          = w_do_write & (ws_addr == `CR_KME_CDDIP0_OUT_IA_WDATA_PART0);
  wire w_load_cddip0_out_ia_wdata_part1          = w_do_write & (ws_addr == `CR_KME_CDDIP0_OUT_IA_WDATA_PART1);
  wire w_load_cddip0_out_ia_wdata_part2          = w_do_write & (ws_addr == `CR_KME_CDDIP0_OUT_IA_WDATA_PART2);
  wire w_load_cddip0_out_ia_config               = w_do_write & (ws_addr == `CR_KME_CDDIP0_OUT_IA_CONFIG);
  wire w_load_cddip0_out_im_config               = w_do_write & (ws_addr == `CR_KME_CDDIP0_OUT_IM_CONFIG);
  wire w_load_cddip0_out_im_read_done            = w_do_write & (ws_addr == `CR_KME_CDDIP0_OUT_IM_READ_DONE);
  wire w_load_cddip1_out_ia_wdata_part0          = w_do_write & (ws_addr == `CR_KME_CDDIP1_OUT_IA_WDATA_PART0);
  wire w_load_cddip1_out_ia_wdata_part1          = w_do_write & (ws_addr == `CR_KME_CDDIP1_OUT_IA_WDATA_PART1);
  wire w_load_cddip1_out_ia_wdata_part2          = w_do_write & (ws_addr == `CR_KME_CDDIP1_OUT_IA_WDATA_PART2);
  wire w_load_cddip1_out_ia_config               = w_do_write & (ws_addr == `CR_KME_CDDIP1_OUT_IA_CONFIG);
  wire w_load_cddip1_out_im_config               = w_do_write & (ws_addr == `CR_KME_CDDIP1_OUT_IM_CONFIG);
  wire w_load_cddip1_out_im_read_done            = w_do_write & (ws_addr == `CR_KME_CDDIP1_OUT_IM_READ_DONE);
  wire w_load_cddip2_out_ia_wdata_part0          = w_do_write & (ws_addr == `CR_KME_CDDIP2_OUT_IA_WDATA_PART0);
  wire w_load_cddip2_out_ia_wdata_part1          = w_do_write & (ws_addr == `CR_KME_CDDIP2_OUT_IA_WDATA_PART1);
  wire w_load_cddip2_out_ia_wdata_part2          = w_do_write & (ws_addr == `CR_KME_CDDIP2_OUT_IA_WDATA_PART2);
  wire w_load_cddip2_out_ia_config               = w_do_write & (ws_addr == `CR_KME_CDDIP2_OUT_IA_CONFIG);
  wire w_load_cddip2_out_im_config               = w_do_write & (ws_addr == `CR_KME_CDDIP2_OUT_IM_CONFIG);
  wire w_load_cddip2_out_im_read_done            = w_do_write & (ws_addr == `CR_KME_CDDIP2_OUT_IM_READ_DONE);
  wire w_load_cddip3_out_ia_wdata_part0          = w_do_write & (ws_addr == `CR_KME_CDDIP3_OUT_IA_WDATA_PART0);
  wire w_load_cddip3_out_ia_wdata_part1          = w_do_write & (ws_addr == `CR_KME_CDDIP3_OUT_IA_WDATA_PART1);
  wire w_load_cddip3_out_ia_wdata_part2          = w_do_write & (ws_addr == `CR_KME_CDDIP3_OUT_IA_WDATA_PART2);
  wire w_load_cddip3_out_ia_config               = w_do_write & (ws_addr == `CR_KME_CDDIP3_OUT_IA_CONFIG);
  wire w_load_cddip3_out_im_config               = w_do_write & (ws_addr == `CR_KME_CDDIP3_OUT_IM_CONFIG);
  wire w_load_cddip3_out_im_read_done            = w_do_write & (ws_addr == `CR_KME_CDDIP3_OUT_IM_READ_DONE);
  wire w_load_ckv_ia_wdata_part0                 = w_do_write & (ws_addr == `CR_KME_CKV_IA_WDATA_PART0);
  wire w_load_ckv_ia_wdata_part1                 = w_do_write & (ws_addr == `CR_KME_CKV_IA_WDATA_PART1);
  wire w_load_ckv_ia_config                      = w_do_write & (ws_addr == `CR_KME_CKV_IA_CONFIG);
  wire w_load_kim_ia_wdata_part0                 = w_do_write & (ws_addr == `CR_KME_KIM_IA_WDATA_PART0);
  wire w_load_kim_ia_wdata_part1                 = w_do_write & (ws_addr == `CR_KME_KIM_IA_WDATA_PART1);
  wire w_load_kim_ia_config                      = w_do_write & (ws_addr == `CR_KME_KIM_IA_CONFIG);
  wire w_load_label0_config                      = w_do_write & (ws_addr == `CR_KME_LABEL0_CONFIG);
  wire w_load_label0_data7                       = w_do_write & (ws_addr == `CR_KME_LABEL0_DATA7);
  wire w_load_label0_data6                       = w_do_write & (ws_addr == `CR_KME_LABEL0_DATA6);
  wire w_load_label0_data5                       = w_do_write & (ws_addr == `CR_KME_LABEL0_DATA5);
  wire w_load_label0_data4                       = w_do_write & (ws_addr == `CR_KME_LABEL0_DATA4);
  wire w_load_label0_data3                       = w_do_write & (ws_addr == `CR_KME_LABEL0_DATA3);
  wire w_load_label0_data2                       = w_do_write & (ws_addr == `CR_KME_LABEL0_DATA2);
  wire w_load_label0_data1                       = w_do_write & (ws_addr == `CR_KME_LABEL0_DATA1);
  wire w_load_label0_data0                       = w_do_write & (ws_addr == `CR_KME_LABEL0_DATA0);
  wire w_load_label1_config                      = w_do_write & (ws_addr == `CR_KME_LABEL1_CONFIG);
  wire w_load_label1_data7                       = w_do_write & (ws_addr == `CR_KME_LABEL1_DATA7);
  wire w_load_label1_data6                       = w_do_write & (ws_addr == `CR_KME_LABEL1_DATA6);
  wire w_load_label1_data5                       = w_do_write & (ws_addr == `CR_KME_LABEL1_DATA5);
  wire w_load_label1_data4                       = w_do_write & (ws_addr == `CR_KME_LABEL1_DATA4);
  wire w_load_label1_data3                       = w_do_write & (ws_addr == `CR_KME_LABEL1_DATA3);
  wire w_load_label1_data2                       = w_do_write & (ws_addr == `CR_KME_LABEL1_DATA2);
  wire w_load_label1_data1                       = w_do_write & (ws_addr == `CR_KME_LABEL1_DATA1);
  wire w_load_label1_data0                       = w_do_write & (ws_addr == `CR_KME_LABEL1_DATA0);
  wire w_load_label2_config                      = w_do_write & (ws_addr == `CR_KME_LABEL2_CONFIG);
  wire w_load_label2_data7                       = w_do_write & (ws_addr == `CR_KME_LABEL2_DATA7);
  wire w_load_label2_data6                       = w_do_write & (ws_addr == `CR_KME_LABEL2_DATA6);
  wire w_load_label2_data5                       = w_do_write & (ws_addr == `CR_KME_LABEL2_DATA5);
  wire w_load_label2_data4                       = w_do_write & (ws_addr == `CR_KME_LABEL2_DATA4);
  wire w_load_label2_data3                       = w_do_write & (ws_addr == `CR_KME_LABEL2_DATA3);
  wire w_load_label2_data2                       = w_do_write & (ws_addr == `CR_KME_LABEL2_DATA2);
  wire w_load_label2_data1                       = w_do_write & (ws_addr == `CR_KME_LABEL2_DATA1);
  wire w_load_label2_data0                       = w_do_write & (ws_addr == `CR_KME_LABEL2_DATA0);
  wire w_load_label3_config                      = w_do_write & (ws_addr == `CR_KME_LABEL3_CONFIG);
  wire w_load_label3_data7                       = w_do_write & (ws_addr == `CR_KME_LABEL3_DATA7);
  wire w_load_label3_data6                       = w_do_write & (ws_addr == `CR_KME_LABEL3_DATA6);
  wire w_load_label3_data5                       = w_do_write & (ws_addr == `CR_KME_LABEL3_DATA5);
  wire w_load_label3_data4                       = w_do_write & (ws_addr == `CR_KME_LABEL3_DATA4);
  wire w_load_label3_data3                       = w_do_write & (ws_addr == `CR_KME_LABEL3_DATA3);
  wire w_load_label3_data2                       = w_do_write & (ws_addr == `CR_KME_LABEL3_DATA2);
  wire w_load_label3_data1                       = w_do_write & (ws_addr == `CR_KME_LABEL3_DATA1);
  wire w_load_label3_data0                       = w_do_write & (ws_addr == `CR_KME_LABEL3_DATA0);
  wire w_load_label4_config                      = w_do_write & (ws_addr == `CR_KME_LABEL4_CONFIG);
  wire w_load_label4_data7                       = w_do_write & (ws_addr == `CR_KME_LABEL4_DATA7);
  wire w_load_label4_data6                       = w_do_write & (ws_addr == `CR_KME_LABEL4_DATA6);
  wire w_load_label4_data5                       = w_do_write & (ws_addr == `CR_KME_LABEL4_DATA5);
  wire w_load_label4_data4                       = w_do_write & (ws_addr == `CR_KME_LABEL4_DATA4);
  wire w_load_label4_data3                       = w_do_write & (ws_addr == `CR_KME_LABEL4_DATA3);
  wire w_load_label4_data2                       = w_do_write & (ws_addr == `CR_KME_LABEL4_DATA2);
  wire w_load_label4_data1                       = w_do_write & (ws_addr == `CR_KME_LABEL4_DATA1);
  wire w_load_label4_data0                       = w_do_write & (ws_addr == `CR_KME_LABEL4_DATA0);
  wire w_load_label5_config                      = w_do_write & (ws_addr == `CR_KME_LABEL5_CONFIG);
  wire w_load_label5_data7                       = w_do_write & (ws_addr == `CR_KME_LABEL5_DATA7);
  wire w_load_label5_data6                       = w_do_write & (ws_addr == `CR_KME_LABEL5_DATA6);
  wire w_load_label5_data5                       = w_do_write & (ws_addr == `CR_KME_LABEL5_DATA5);
  wire w_load_label5_data4                       = w_do_write & (ws_addr == `CR_KME_LABEL5_DATA4);
  wire w_load_label5_data3                       = w_do_write & (ws_addr == `CR_KME_LABEL5_DATA3);
  wire w_load_label5_data2                       = w_do_write & (ws_addr == `CR_KME_LABEL5_DATA2);
  wire w_load_label5_data1                       = w_do_write & (ws_addr == `CR_KME_LABEL5_DATA1);
  wire w_load_label5_data0                       = w_do_write & (ws_addr == `CR_KME_LABEL5_DATA0);
  wire w_load_label6_config                      = w_do_write & (ws_addr == `CR_KME_LABEL6_CONFIG);
  wire w_load_label6_data7                       = w_do_write & (ws_addr == `CR_KME_LABEL6_DATA7);
  wire w_load_label6_data6                       = w_do_write & (ws_addr == `CR_KME_LABEL6_DATA6);
  wire w_load_label6_data5                       = w_do_write & (ws_addr == `CR_KME_LABEL6_DATA5);
  wire w_load_label6_data4                       = w_do_write & (ws_addr == `CR_KME_LABEL6_DATA4);
  wire w_load_label6_data3                       = w_do_write & (ws_addr == `CR_KME_LABEL6_DATA3);
  wire w_load_label6_data2                       = w_do_write & (ws_addr == `CR_KME_LABEL6_DATA2);
  wire w_load_label6_data1                       = w_do_write & (ws_addr == `CR_KME_LABEL6_DATA1);
  wire w_load_label6_data0                       = w_do_write & (ws_addr == `CR_KME_LABEL6_DATA0);
  wire w_load_label7_config                      = w_do_write & (ws_addr == `CR_KME_LABEL7_CONFIG);
  wire w_load_label7_data7                       = w_do_write & (ws_addr == `CR_KME_LABEL7_DATA7);
  wire w_load_label7_data6                       = w_do_write & (ws_addr == `CR_KME_LABEL7_DATA6);
  wire w_load_label7_data5                       = w_do_write & (ws_addr == `CR_KME_LABEL7_DATA5);
  wire w_load_label7_data4                       = w_do_write & (ws_addr == `CR_KME_LABEL7_DATA4);
  wire w_load_label7_data3                       = w_do_write & (ws_addr == `CR_KME_LABEL7_DATA3);
  wire w_load_label7_data2                       = w_do_write & (ws_addr == `CR_KME_LABEL7_DATA2);
  wire w_load_label7_data1                       = w_do_write & (ws_addr == `CR_KME_LABEL7_DATA1);
  wire w_load_label7_data0                       = w_do_write & (ws_addr == `CR_KME_LABEL7_DATA0);
  wire w_load_kdf_drbg_ctrl                      = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_CTRL);
  wire w_load_kdf_drbg_seed_0_state_key_31_0     = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_0_STATE_KEY_31_0);
  wire w_load_kdf_drbg_seed_0_state_key_63_32    = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_0_STATE_KEY_63_32);
  wire w_load_kdf_drbg_seed_0_state_key_95_64    = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_0_STATE_KEY_95_64);
  wire w_load_kdf_drbg_seed_0_state_key_127_96   = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_0_STATE_KEY_127_96);
  wire w_load_kdf_drbg_seed_0_state_key_159_128  = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_0_STATE_KEY_159_128);
  wire w_load_kdf_drbg_seed_0_state_key_191_160  = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_0_STATE_KEY_191_160);
  wire w_load_kdf_drbg_seed_0_state_key_223_192  = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_0_STATE_KEY_223_192);
  wire w_load_kdf_drbg_seed_0_state_key_255_224  = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_0_STATE_KEY_255_224);
  wire w_load_kdf_drbg_seed_0_state_value_31_0   = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_0_STATE_VALUE_31_0);
  wire w_load_kdf_drbg_seed_0_state_value_63_32  = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_0_STATE_VALUE_63_32);
  wire w_load_kdf_drbg_seed_0_state_value_95_64  = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_0_STATE_VALUE_95_64);
  wire w_load_kdf_drbg_seed_0_state_value_127_96 = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_0_STATE_VALUE_127_96);
  wire w_load_kdf_drbg_seed_0_reseed_interval_0  = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_0_RESEED_INTERVAL_0);
  wire w_load_kdf_drbg_seed_0_reseed_interval_1  = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_0_RESEED_INTERVAL_1);
  wire w_load_kdf_drbg_seed_1_state_key_31_0     = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_1_STATE_KEY_31_0);
  wire w_load_kdf_drbg_seed_1_state_key_63_32    = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_1_STATE_KEY_63_32);
  wire w_load_kdf_drbg_seed_1_state_key_95_64    = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_1_STATE_KEY_95_64);
  wire w_load_kdf_drbg_seed_1_state_key_127_96   = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_1_STATE_KEY_127_96);
  wire w_load_kdf_drbg_seed_1_state_key_159_128  = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_1_STATE_KEY_159_128);
  wire w_load_kdf_drbg_seed_1_state_key_191_160  = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_1_STATE_KEY_191_160);
  wire w_load_kdf_drbg_seed_1_state_key_223_192  = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_1_STATE_KEY_223_192);
  wire w_load_kdf_drbg_seed_1_state_key_255_224  = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_1_STATE_KEY_255_224);
  wire w_load_kdf_drbg_seed_1_state_value_31_0   = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_1_STATE_VALUE_31_0);
  wire w_load_kdf_drbg_seed_1_state_value_63_32  = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_1_STATE_VALUE_63_32);
  wire w_load_kdf_drbg_seed_1_state_value_95_64  = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_1_STATE_VALUE_95_64);
  wire w_load_kdf_drbg_seed_1_state_value_127_96 = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_1_STATE_VALUE_127_96);
  wire w_load_kdf_drbg_seed_1_reseed_interval_0  = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_1_RESEED_INTERVAL_0);
  wire w_load_kdf_drbg_seed_1_reseed_interval_1  = w_do_write & (ws_addr == `CR_KME_KDF_DRBG_SEED_1_RESEED_INTERVAL_1);
  wire w_load_interrupt_status                   = w_do_write & (ws_addr == `CR_KME_INTERRUPT_STATUS);
  wire w_load_interrupt_mask                     = w_do_write & (ws_addr == `CR_KME_INTERRUPT_MASK);
  wire w_load_engine_sticky_status               = w_do_write & (ws_addr == `CR_KME_ENGINE_STICKY_STATUS);
  wire w_load_bimc_monitor_mask                  = w_do_write & (ws_addr == `CR_KME_BIMC_MONITOR_MASK);
  wire w_load_bimc_ecc_uncorrectable_error_cnt   = w_do_write & (ws_addr == `CR_KME_BIMC_ECC_UNCORRECTABLE_ERROR_CNT);
  wire w_load_bimc_ecc_correctable_error_cnt     = w_do_write & (ws_addr == `CR_KME_BIMC_ECC_CORRECTABLE_ERROR_CNT);
  wire w_load_bimc_parity_error_cnt              = w_do_write & (ws_addr == `CR_KME_BIMC_PARITY_ERROR_CNT);
  wire w_load_bimc_global_config                 = w_do_write & (ws_addr == `CR_KME_BIMC_GLOBAL_CONFIG);
  wire w_load_bimc_eccpar_debug                  = w_do_write & (ws_addr == `CR_KME_BIMC_ECCPAR_DEBUG);
  wire w_load_bimc_cmd2                          = w_do_write & (ws_addr == `CR_KME_BIMC_CMD2);
  wire w_load_bimc_cmd1                          = w_do_write & (ws_addr == `CR_KME_BIMC_CMD1);
  wire w_load_bimc_cmd0                          = w_do_write & (ws_addr == `CR_KME_BIMC_CMD0);
  wire w_load_bimc_rxcmd2                        = w_do_write & (ws_addr == `CR_KME_BIMC_RXCMD2);
  wire w_load_bimc_rxrsp2                        = w_do_write & (ws_addr == `CR_KME_BIMC_RXRSP2);
  wire w_load_bimc_pollrsp2                      = w_do_write & (ws_addr == `CR_KME_BIMC_POLLRSP2);
  wire w_load_bimc_dbgcmd2                       = w_do_write & (ws_addr == `CR_KME_BIMC_DBGCMD2);
  wire w_load_im_consumed                        = w_do_write & (ws_addr == `CR_KME_IM_CONSUMED);
  wire w_load_tready_override                    = w_do_write & (ws_addr == `CR_KME_TREADY_OVERRIDE);
  wire w_load_regs_sa_ctrl                       = w_do_write & (ws_addr == `CR_KME_REGS_SA_CTRL);
  wire w_load_sa_snapshot_ia_wdata_part0         = w_do_write & (ws_addr == `CR_KME_SA_SNAPSHOT_IA_WDATA_PART0);
  wire w_load_sa_snapshot_ia_wdata_part1         = w_do_write & (ws_addr == `CR_KME_SA_SNAPSHOT_IA_WDATA_PART1);
  wire w_load_sa_snapshot_ia_config              = w_do_write & (ws_addr == `CR_KME_SA_SNAPSHOT_IA_CONFIG);
  wire w_load_sa_count_ia_wdata_part0            = w_do_write & (ws_addr == `CR_KME_SA_COUNT_IA_WDATA_PART0);
  wire w_load_sa_count_ia_wdata_part1            = w_do_write & (ws_addr == `CR_KME_SA_COUNT_IA_WDATA_PART1);
  wire w_load_sa_count_ia_config                 = w_do_write & (ws_addr == `CR_KME_SA_COUNT_IA_CONFIG);
  wire w_load_cceip_encrypt_kop_fifo_override    = w_do_write & (ws_addr == `CR_KME_CCEIP_ENCRYPT_KOP_FIFO_OVERRIDE);
  wire w_load_cceip_validate_kop_fifo_override   = w_do_write & (ws_addr == `CR_KME_CCEIP_VALIDATE_KOP_FIFO_OVERRIDE);
  wire w_load_cddip_decrypt_kop_fifo_override    = w_do_write & (ws_addr == `CR_KME_CDDIP_DECRYPT_KOP_FIFO_OVERRIDE);
  wire w_load_sa_global_ctrl                     = w_do_write & (ws_addr == `CR_KME_SA_GLOBAL_CTRL);
  wire w_load_sa_ctrl_ia_wdata_part0             = w_do_write & (ws_addr == `CR_KME_SA_CTRL_IA_WDATA_PART0);
  wire w_load_sa_ctrl_ia_config                  = w_do_write & (ws_addr == `CR_KME_SA_CTRL_IA_CONFIG);
  wire w_load_kdf_test_key_size_config           = w_do_write & (ws_addr == `CR_KME_KDF_TEST_KEY_SIZE_CONFIG);


  


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
      f32_mux_6_data <= 0;
      f32_mux_7_data <= 0;
      f32_mux_8_data <= 0;

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
      f32_mux_6_data <= 0;
      f32_mux_7_data <= 0;
      f32_mux_8_data <= 0;

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
      if (w_do_read)             f32_mux_6_data <= r32_mux_6_data;
      if (w_do_read)             f32_mux_7_data <= r32_mux_7_data;
      if (w_do_read)             f32_mux_8_data <= r32_mux_8_data;

    end
  end

  
  always_ff @(posedge clk) begin
    if (i_wr_strb)               f32_data       <= i_wr_data;

  end
  

  cr_kme_regs_flops u_cr_kme_regs_flops (
        .clk                                    ( clk ),
        .i_reset_                               ( i_reset_ ),
        .i_sw_init                              ( i_sw_init ),
        .o_spare_config                         ( o_spare_config ),
        .o_cceip0_out_ia_wdata_part0            ( o_cceip0_out_ia_wdata_part0 ),
        .o_cceip0_out_ia_wdata_part1            ( o_cceip0_out_ia_wdata_part1 ),
        .o_cceip0_out_ia_wdata_part2            ( o_cceip0_out_ia_wdata_part2 ),
        .o_cceip0_out_ia_config                 ( o_cceip0_out_ia_config ),
        .o_cceip0_out_im_config                 ( o_cceip0_out_im_config ),
        .o_cceip0_out_im_read_done              ( o_cceip0_out_im_read_done ),
        .o_cceip1_out_ia_wdata_part0            ( o_cceip1_out_ia_wdata_part0 ),
        .o_cceip1_out_ia_wdata_part1            ( o_cceip1_out_ia_wdata_part1 ),
        .o_cceip1_out_ia_wdata_part2            ( o_cceip1_out_ia_wdata_part2 ),
        .o_cceip1_out_ia_config                 ( o_cceip1_out_ia_config ),
        .o_cceip1_out_im_config                 ( o_cceip1_out_im_config ),
        .o_cceip1_out_im_read_done              ( o_cceip1_out_im_read_done ),
        .o_cceip2_out_ia_wdata_part0            ( o_cceip2_out_ia_wdata_part0 ),
        .o_cceip2_out_ia_wdata_part1            ( o_cceip2_out_ia_wdata_part1 ),
        .o_cceip2_out_ia_wdata_part2            ( o_cceip2_out_ia_wdata_part2 ),
        .o_cceip2_out_ia_config                 ( o_cceip2_out_ia_config ),
        .o_cceip2_out_im_config                 ( o_cceip2_out_im_config ),
        .o_cceip2_out_im_read_done              ( o_cceip2_out_im_read_done ),
        .o_cceip3_out_ia_wdata_part0            ( o_cceip3_out_ia_wdata_part0 ),
        .o_cceip3_out_ia_wdata_part1            ( o_cceip3_out_ia_wdata_part1 ),
        .o_cceip3_out_ia_wdata_part2            ( o_cceip3_out_ia_wdata_part2 ),
        .o_cceip3_out_ia_config                 ( o_cceip3_out_ia_config ),
        .o_cceip3_out_im_config                 ( o_cceip3_out_im_config ),
        .o_cceip3_out_im_read_done              ( o_cceip3_out_im_read_done ),
        .o_cddip0_out_ia_wdata_part0            ( o_cddip0_out_ia_wdata_part0 ),
        .o_cddip0_out_ia_wdata_part1            ( o_cddip0_out_ia_wdata_part1 ),
        .o_cddip0_out_ia_wdata_part2            ( o_cddip0_out_ia_wdata_part2 ),
        .o_cddip0_out_ia_config                 ( o_cddip0_out_ia_config ),
        .o_cddip0_out_im_config                 ( o_cddip0_out_im_config ),
        .o_cddip0_out_im_read_done              ( o_cddip0_out_im_read_done ),
        .o_cddip1_out_ia_wdata_part0            ( o_cddip1_out_ia_wdata_part0 ),
        .o_cddip1_out_ia_wdata_part1            ( o_cddip1_out_ia_wdata_part1 ),
        .o_cddip1_out_ia_wdata_part2            ( o_cddip1_out_ia_wdata_part2 ),
        .o_cddip1_out_ia_config                 ( o_cddip1_out_ia_config ),
        .o_cddip1_out_im_config                 ( o_cddip1_out_im_config ),
        .o_cddip1_out_im_read_done              ( o_cddip1_out_im_read_done ),
        .o_cddip2_out_ia_wdata_part0            ( o_cddip2_out_ia_wdata_part0 ),
        .o_cddip2_out_ia_wdata_part1            ( o_cddip2_out_ia_wdata_part1 ),
        .o_cddip2_out_ia_wdata_part2            ( o_cddip2_out_ia_wdata_part2 ),
        .o_cddip2_out_ia_config                 ( o_cddip2_out_ia_config ),
        .o_cddip2_out_im_config                 ( o_cddip2_out_im_config ),
        .o_cddip2_out_im_read_done              ( o_cddip2_out_im_read_done ),
        .o_cddip3_out_ia_wdata_part0            ( o_cddip3_out_ia_wdata_part0 ),
        .o_cddip3_out_ia_wdata_part1            ( o_cddip3_out_ia_wdata_part1 ),
        .o_cddip3_out_ia_wdata_part2            ( o_cddip3_out_ia_wdata_part2 ),
        .o_cddip3_out_ia_config                 ( o_cddip3_out_ia_config ),
        .o_cddip3_out_im_config                 ( o_cddip3_out_im_config ),
        .o_cddip3_out_im_read_done              ( o_cddip3_out_im_read_done ),
        .o_ckv_ia_wdata_part0                   ( o_ckv_ia_wdata_part0 ),
        .o_ckv_ia_wdata_part1                   ( o_ckv_ia_wdata_part1 ),
        .o_ckv_ia_config                        ( o_ckv_ia_config ),
        .o_kim_ia_wdata_part0                   ( o_kim_ia_wdata_part0 ),
        .o_kim_ia_wdata_part1                   ( o_kim_ia_wdata_part1 ),
        .o_kim_ia_config                        ( o_kim_ia_config ),
        .o_label0_config                        ( o_label0_config ),
        .o_label0_data7                         ( o_label0_data7 ),
        .o_label0_data6                         ( o_label0_data6 ),
        .o_label0_data5                         ( o_label0_data5 ),
        .o_label0_data4                         ( o_label0_data4 ),
        .o_label0_data3                         ( o_label0_data3 ),
        .o_label0_data2                         ( o_label0_data2 ),
        .o_label0_data1                         ( o_label0_data1 ),
        .o_label0_data0                         ( o_label0_data0 ),
        .o_label1_config                        ( o_label1_config ),
        .o_label1_data7                         ( o_label1_data7 ),
        .o_label1_data6                         ( o_label1_data6 ),
        .o_label1_data5                         ( o_label1_data5 ),
        .o_label1_data4                         ( o_label1_data4 ),
        .o_label1_data3                         ( o_label1_data3 ),
        .o_label1_data2                         ( o_label1_data2 ),
        .o_label1_data1                         ( o_label1_data1 ),
        .o_label1_data0                         ( o_label1_data0 ),
        .o_label2_config                        ( o_label2_config ),
        .o_label2_data7                         ( o_label2_data7 ),
        .o_label2_data6                         ( o_label2_data6 ),
        .o_label2_data5                         ( o_label2_data5 ),
        .o_label2_data4                         ( o_label2_data4 ),
        .o_label2_data3                         ( o_label2_data3 ),
        .o_label2_data2                         ( o_label2_data2 ),
        .o_label2_data1                         ( o_label2_data1 ),
        .o_label2_data0                         ( o_label2_data0 ),
        .o_label3_config                        ( o_label3_config ),
        .o_label3_data7                         ( o_label3_data7 ),
        .o_label3_data6                         ( o_label3_data6 ),
        .o_label3_data5                         ( o_label3_data5 ),
        .o_label3_data4                         ( o_label3_data4 ),
        .o_label3_data3                         ( o_label3_data3 ),
        .o_label3_data2                         ( o_label3_data2 ),
        .o_label3_data1                         ( o_label3_data1 ),
        .o_label3_data0                         ( o_label3_data0 ),
        .o_label4_config                        ( o_label4_config ),
        .o_label4_data7                         ( o_label4_data7 ),
        .o_label4_data6                         ( o_label4_data6 ),
        .o_label4_data5                         ( o_label4_data5 ),
        .o_label4_data4                         ( o_label4_data4 ),
        .o_label4_data3                         ( o_label4_data3 ),
        .o_label4_data2                         ( o_label4_data2 ),
        .o_label4_data1                         ( o_label4_data1 ),
        .o_label4_data0                         ( o_label4_data0 ),
        .o_label5_config                        ( o_label5_config ),
        .o_label5_data7                         ( o_label5_data7 ),
        .o_label5_data6                         ( o_label5_data6 ),
        .o_label5_data5                         ( o_label5_data5 ),
        .o_label5_data4                         ( o_label5_data4 ),
        .o_label5_data3                         ( o_label5_data3 ),
        .o_label5_data2                         ( o_label5_data2 ),
        .o_label5_data1                         ( o_label5_data1 ),
        .o_label5_data0                         ( o_label5_data0 ),
        .o_label6_config                        ( o_label6_config ),
        .o_label6_data7                         ( o_label6_data7 ),
        .o_label6_data6                         ( o_label6_data6 ),
        .o_label6_data5                         ( o_label6_data5 ),
        .o_label6_data4                         ( o_label6_data4 ),
        .o_label6_data3                         ( o_label6_data3 ),
        .o_label6_data2                         ( o_label6_data2 ),
        .o_label6_data1                         ( o_label6_data1 ),
        .o_label6_data0                         ( o_label6_data0 ),
        .o_label7_config                        ( o_label7_config ),
        .o_label7_data7                         ( o_label7_data7 ),
        .o_label7_data6                         ( o_label7_data6 ),
        .o_label7_data5                         ( o_label7_data5 ),
        .o_label7_data4                         ( o_label7_data4 ),
        .o_label7_data3                         ( o_label7_data3 ),
        .o_label7_data2                         ( o_label7_data2 ),
        .o_label7_data1                         ( o_label7_data1 ),
        .o_label7_data0                         ( o_label7_data0 ),
        .o_kdf_drbg_ctrl                        ( o_kdf_drbg_ctrl ),
        .o_kdf_drbg_seed_0_state_key_31_0       ( o_kdf_drbg_seed_0_state_key_31_0 ),
        .o_kdf_drbg_seed_0_state_key_63_32      ( o_kdf_drbg_seed_0_state_key_63_32 ),
        .o_kdf_drbg_seed_0_state_key_95_64      ( o_kdf_drbg_seed_0_state_key_95_64 ),
        .o_kdf_drbg_seed_0_state_key_127_96     ( o_kdf_drbg_seed_0_state_key_127_96 ),
        .o_kdf_drbg_seed_0_state_key_159_128    ( o_kdf_drbg_seed_0_state_key_159_128 ),
        .o_kdf_drbg_seed_0_state_key_191_160    ( o_kdf_drbg_seed_0_state_key_191_160 ),
        .o_kdf_drbg_seed_0_state_key_223_192    ( o_kdf_drbg_seed_0_state_key_223_192 ),
        .o_kdf_drbg_seed_0_state_key_255_224    ( o_kdf_drbg_seed_0_state_key_255_224 ),
        .o_kdf_drbg_seed_0_state_value_31_0     ( o_kdf_drbg_seed_0_state_value_31_0 ),
        .o_kdf_drbg_seed_0_state_value_63_32    ( o_kdf_drbg_seed_0_state_value_63_32 ),
        .o_kdf_drbg_seed_0_state_value_95_64    ( o_kdf_drbg_seed_0_state_value_95_64 ),
        .o_kdf_drbg_seed_0_state_value_127_96   ( o_kdf_drbg_seed_0_state_value_127_96 ),
        .o_kdf_drbg_seed_0_reseed_interval_0    ( o_kdf_drbg_seed_0_reseed_interval_0 ),
        .o_kdf_drbg_seed_0_reseed_interval_1    ( o_kdf_drbg_seed_0_reseed_interval_1 ),
        .o_kdf_drbg_seed_1_state_key_31_0       ( o_kdf_drbg_seed_1_state_key_31_0 ),
        .o_kdf_drbg_seed_1_state_key_63_32      ( o_kdf_drbg_seed_1_state_key_63_32 ),
        .o_kdf_drbg_seed_1_state_key_95_64      ( o_kdf_drbg_seed_1_state_key_95_64 ),
        .o_kdf_drbg_seed_1_state_key_127_96     ( o_kdf_drbg_seed_1_state_key_127_96 ),
        .o_kdf_drbg_seed_1_state_key_159_128    ( o_kdf_drbg_seed_1_state_key_159_128 ),
        .o_kdf_drbg_seed_1_state_key_191_160    ( o_kdf_drbg_seed_1_state_key_191_160 ),
        .o_kdf_drbg_seed_1_state_key_223_192    ( o_kdf_drbg_seed_1_state_key_223_192 ),
        .o_kdf_drbg_seed_1_state_key_255_224    ( o_kdf_drbg_seed_1_state_key_255_224 ),
        .o_kdf_drbg_seed_1_state_value_31_0     ( o_kdf_drbg_seed_1_state_value_31_0 ),
        .o_kdf_drbg_seed_1_state_value_63_32    ( o_kdf_drbg_seed_1_state_value_63_32 ),
        .o_kdf_drbg_seed_1_state_value_95_64    ( o_kdf_drbg_seed_1_state_value_95_64 ),
        .o_kdf_drbg_seed_1_state_value_127_96   ( o_kdf_drbg_seed_1_state_value_127_96 ),
        .o_kdf_drbg_seed_1_reseed_interval_0    ( o_kdf_drbg_seed_1_reseed_interval_0 ),
        .o_kdf_drbg_seed_1_reseed_interval_1    ( o_kdf_drbg_seed_1_reseed_interval_1 ),
        .o_interrupt_status                     ( o_interrupt_status ),
        .o_interrupt_mask                       ( o_interrupt_mask ),
        .o_engine_sticky_status                 ( o_engine_sticky_status ),
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
        .o_im_consumed                          ( o_im_consumed ),
        .o_tready_override                      ( o_tready_override ),
        .o_regs_sa_ctrl                         ( o_regs_sa_ctrl ),
        .o_sa_snapshot_ia_wdata_part0           ( o_sa_snapshot_ia_wdata_part0 ),
        .o_sa_snapshot_ia_wdata_part1           ( o_sa_snapshot_ia_wdata_part1 ),
        .o_sa_snapshot_ia_config                ( o_sa_snapshot_ia_config ),
        .o_sa_count_ia_wdata_part0              ( o_sa_count_ia_wdata_part0 ),
        .o_sa_count_ia_wdata_part1              ( o_sa_count_ia_wdata_part1 ),
        .o_sa_count_ia_config                   ( o_sa_count_ia_config ),
        .o_cceip_encrypt_kop_fifo_override      ( o_cceip_encrypt_kop_fifo_override ),
        .o_cceip_validate_kop_fifo_override     ( o_cceip_validate_kop_fifo_override ),
        .o_cddip_decrypt_kop_fifo_override      ( o_cddip_decrypt_kop_fifo_override ),
        .o_sa_global_ctrl                       ( o_sa_global_ctrl ),
        .o_sa_ctrl_ia_wdata_part0               ( o_sa_ctrl_ia_wdata_part0 ),
        .o_sa_ctrl_ia_config                    ( o_sa_ctrl_ia_config ),
        .o_kdf_test_key_size_config             ( o_kdf_test_key_size_config ),
        .w_load_spare_config                    ( w_load_spare_config ),
        .w_load_cceip0_out_ia_wdata_part0       ( w_load_cceip0_out_ia_wdata_part0 ),
        .w_load_cceip0_out_ia_wdata_part1       ( w_load_cceip0_out_ia_wdata_part1 ),
        .w_load_cceip0_out_ia_wdata_part2       ( w_load_cceip0_out_ia_wdata_part2 ),
        .w_load_cceip0_out_ia_config            ( w_load_cceip0_out_ia_config ),
        .w_load_cceip0_out_im_config            ( w_load_cceip0_out_im_config ),
        .w_load_cceip0_out_im_read_done         ( w_load_cceip0_out_im_read_done ),
        .w_load_cceip1_out_ia_wdata_part0       ( w_load_cceip1_out_ia_wdata_part0 ),
        .w_load_cceip1_out_ia_wdata_part1       ( w_load_cceip1_out_ia_wdata_part1 ),
        .w_load_cceip1_out_ia_wdata_part2       ( w_load_cceip1_out_ia_wdata_part2 ),
        .w_load_cceip1_out_ia_config            ( w_load_cceip1_out_ia_config ),
        .w_load_cceip1_out_im_config            ( w_load_cceip1_out_im_config ),
        .w_load_cceip1_out_im_read_done         ( w_load_cceip1_out_im_read_done ),
        .w_load_cceip2_out_ia_wdata_part0       ( w_load_cceip2_out_ia_wdata_part0 ),
        .w_load_cceip2_out_ia_wdata_part1       ( w_load_cceip2_out_ia_wdata_part1 ),
        .w_load_cceip2_out_ia_wdata_part2       ( w_load_cceip2_out_ia_wdata_part2 ),
        .w_load_cceip2_out_ia_config            ( w_load_cceip2_out_ia_config ),
        .w_load_cceip2_out_im_config            ( w_load_cceip2_out_im_config ),
        .w_load_cceip2_out_im_read_done         ( w_load_cceip2_out_im_read_done ),
        .w_load_cceip3_out_ia_wdata_part0       ( w_load_cceip3_out_ia_wdata_part0 ),
        .w_load_cceip3_out_ia_wdata_part1       ( w_load_cceip3_out_ia_wdata_part1 ),
        .w_load_cceip3_out_ia_wdata_part2       ( w_load_cceip3_out_ia_wdata_part2 ),
        .w_load_cceip3_out_ia_config            ( w_load_cceip3_out_ia_config ),
        .w_load_cceip3_out_im_config            ( w_load_cceip3_out_im_config ),
        .w_load_cceip3_out_im_read_done         ( w_load_cceip3_out_im_read_done ),
        .w_load_cddip0_out_ia_wdata_part0       ( w_load_cddip0_out_ia_wdata_part0 ),
        .w_load_cddip0_out_ia_wdata_part1       ( w_load_cddip0_out_ia_wdata_part1 ),
        .w_load_cddip0_out_ia_wdata_part2       ( w_load_cddip0_out_ia_wdata_part2 ),
        .w_load_cddip0_out_ia_config            ( w_load_cddip0_out_ia_config ),
        .w_load_cddip0_out_im_config            ( w_load_cddip0_out_im_config ),
        .w_load_cddip0_out_im_read_done         ( w_load_cddip0_out_im_read_done ),
        .w_load_cddip1_out_ia_wdata_part0       ( w_load_cddip1_out_ia_wdata_part0 ),
        .w_load_cddip1_out_ia_wdata_part1       ( w_load_cddip1_out_ia_wdata_part1 ),
        .w_load_cddip1_out_ia_wdata_part2       ( w_load_cddip1_out_ia_wdata_part2 ),
        .w_load_cddip1_out_ia_config            ( w_load_cddip1_out_ia_config ),
        .w_load_cddip1_out_im_config            ( w_load_cddip1_out_im_config ),
        .w_load_cddip1_out_im_read_done         ( w_load_cddip1_out_im_read_done ),
        .w_load_cddip2_out_ia_wdata_part0       ( w_load_cddip2_out_ia_wdata_part0 ),
        .w_load_cddip2_out_ia_wdata_part1       ( w_load_cddip2_out_ia_wdata_part1 ),
        .w_load_cddip2_out_ia_wdata_part2       ( w_load_cddip2_out_ia_wdata_part2 ),
        .w_load_cddip2_out_ia_config            ( w_load_cddip2_out_ia_config ),
        .w_load_cddip2_out_im_config            ( w_load_cddip2_out_im_config ),
        .w_load_cddip2_out_im_read_done         ( w_load_cddip2_out_im_read_done ),
        .w_load_cddip3_out_ia_wdata_part0       ( w_load_cddip3_out_ia_wdata_part0 ),
        .w_load_cddip3_out_ia_wdata_part1       ( w_load_cddip3_out_ia_wdata_part1 ),
        .w_load_cddip3_out_ia_wdata_part2       ( w_load_cddip3_out_ia_wdata_part2 ),
        .w_load_cddip3_out_ia_config            ( w_load_cddip3_out_ia_config ),
        .w_load_cddip3_out_im_config            ( w_load_cddip3_out_im_config ),
        .w_load_cddip3_out_im_read_done         ( w_load_cddip3_out_im_read_done ),
        .w_load_ckv_ia_wdata_part0              ( w_load_ckv_ia_wdata_part0 ),
        .w_load_ckv_ia_wdata_part1              ( w_load_ckv_ia_wdata_part1 ),
        .w_load_ckv_ia_config                   ( w_load_ckv_ia_config ),
        .w_load_kim_ia_wdata_part0              ( w_load_kim_ia_wdata_part0 ),
        .w_load_kim_ia_wdata_part1              ( w_load_kim_ia_wdata_part1 ),
        .w_load_kim_ia_config                   ( w_load_kim_ia_config ),
        .w_load_label0_config                   ( w_load_label0_config ),
        .w_load_label0_data7                    ( w_load_label0_data7 ),
        .w_load_label0_data6                    ( w_load_label0_data6 ),
        .w_load_label0_data5                    ( w_load_label0_data5 ),
        .w_load_label0_data4                    ( w_load_label0_data4 ),
        .w_load_label0_data3                    ( w_load_label0_data3 ),
        .w_load_label0_data2                    ( w_load_label0_data2 ),
        .w_load_label0_data1                    ( w_load_label0_data1 ),
        .w_load_label0_data0                    ( w_load_label0_data0 ),
        .w_load_label1_config                   ( w_load_label1_config ),
        .w_load_label1_data7                    ( w_load_label1_data7 ),
        .w_load_label1_data6                    ( w_load_label1_data6 ),
        .w_load_label1_data5                    ( w_load_label1_data5 ),
        .w_load_label1_data4                    ( w_load_label1_data4 ),
        .w_load_label1_data3                    ( w_load_label1_data3 ),
        .w_load_label1_data2                    ( w_load_label1_data2 ),
        .w_load_label1_data1                    ( w_load_label1_data1 ),
        .w_load_label1_data0                    ( w_load_label1_data0 ),
        .w_load_label2_config                   ( w_load_label2_config ),
        .w_load_label2_data7                    ( w_load_label2_data7 ),
        .w_load_label2_data6                    ( w_load_label2_data6 ),
        .w_load_label2_data5                    ( w_load_label2_data5 ),
        .w_load_label2_data4                    ( w_load_label2_data4 ),
        .w_load_label2_data3                    ( w_load_label2_data3 ),
        .w_load_label2_data2                    ( w_load_label2_data2 ),
        .w_load_label2_data1                    ( w_load_label2_data1 ),
        .w_load_label2_data0                    ( w_load_label2_data0 ),
        .w_load_label3_config                   ( w_load_label3_config ),
        .w_load_label3_data7                    ( w_load_label3_data7 ),
        .w_load_label3_data6                    ( w_load_label3_data6 ),
        .w_load_label3_data5                    ( w_load_label3_data5 ),
        .w_load_label3_data4                    ( w_load_label3_data4 ),
        .w_load_label3_data3                    ( w_load_label3_data3 ),
        .w_load_label3_data2                    ( w_load_label3_data2 ),
        .w_load_label3_data1                    ( w_load_label3_data1 ),
        .w_load_label3_data0                    ( w_load_label3_data0 ),
        .w_load_label4_config                   ( w_load_label4_config ),
        .w_load_label4_data7                    ( w_load_label4_data7 ),
        .w_load_label4_data6                    ( w_load_label4_data6 ),
        .w_load_label4_data5                    ( w_load_label4_data5 ),
        .w_load_label4_data4                    ( w_load_label4_data4 ),
        .w_load_label4_data3                    ( w_load_label4_data3 ),
        .w_load_label4_data2                    ( w_load_label4_data2 ),
        .w_load_label4_data1                    ( w_load_label4_data1 ),
        .w_load_label4_data0                    ( w_load_label4_data0 ),
        .w_load_label5_config                   ( w_load_label5_config ),
        .w_load_label5_data7                    ( w_load_label5_data7 ),
        .w_load_label5_data6                    ( w_load_label5_data6 ),
        .w_load_label5_data5                    ( w_load_label5_data5 ),
        .w_load_label5_data4                    ( w_load_label5_data4 ),
        .w_load_label5_data3                    ( w_load_label5_data3 ),
        .w_load_label5_data2                    ( w_load_label5_data2 ),
        .w_load_label5_data1                    ( w_load_label5_data1 ),
        .w_load_label5_data0                    ( w_load_label5_data0 ),
        .w_load_label6_config                   ( w_load_label6_config ),
        .w_load_label6_data7                    ( w_load_label6_data7 ),
        .w_load_label6_data6                    ( w_load_label6_data6 ),
        .w_load_label6_data5                    ( w_load_label6_data5 ),
        .w_load_label6_data4                    ( w_load_label6_data4 ),
        .w_load_label6_data3                    ( w_load_label6_data3 ),
        .w_load_label6_data2                    ( w_load_label6_data2 ),
        .w_load_label6_data1                    ( w_load_label6_data1 ),
        .w_load_label6_data0                    ( w_load_label6_data0 ),
        .w_load_label7_config                   ( w_load_label7_config ),
        .w_load_label7_data7                    ( w_load_label7_data7 ),
        .w_load_label7_data6                    ( w_load_label7_data6 ),
        .w_load_label7_data5                    ( w_load_label7_data5 ),
        .w_load_label7_data4                    ( w_load_label7_data4 ),
        .w_load_label7_data3                    ( w_load_label7_data3 ),
        .w_load_label7_data2                    ( w_load_label7_data2 ),
        .w_load_label7_data1                    ( w_load_label7_data1 ),
        .w_load_label7_data0                    ( w_load_label7_data0 ),
        .w_load_kdf_drbg_ctrl                   ( w_load_kdf_drbg_ctrl ),
        .w_load_kdf_drbg_seed_0_state_key_31_0  ( w_load_kdf_drbg_seed_0_state_key_31_0 ),
        .w_load_kdf_drbg_seed_0_state_key_63_32 ( w_load_kdf_drbg_seed_0_state_key_63_32 ),
        .w_load_kdf_drbg_seed_0_state_key_95_64 ( w_load_kdf_drbg_seed_0_state_key_95_64 ),
        .w_load_kdf_drbg_seed_0_state_key_127_96 ( w_load_kdf_drbg_seed_0_state_key_127_96 ),
        .w_load_kdf_drbg_seed_0_state_key_159_128 ( w_load_kdf_drbg_seed_0_state_key_159_128 ),
        .w_load_kdf_drbg_seed_0_state_key_191_160 ( w_load_kdf_drbg_seed_0_state_key_191_160 ),
        .w_load_kdf_drbg_seed_0_state_key_223_192 ( w_load_kdf_drbg_seed_0_state_key_223_192 ),
        .w_load_kdf_drbg_seed_0_state_key_255_224 ( w_load_kdf_drbg_seed_0_state_key_255_224 ),
        .w_load_kdf_drbg_seed_0_state_value_31_0 ( w_load_kdf_drbg_seed_0_state_value_31_0 ),
        .w_load_kdf_drbg_seed_0_state_value_63_32 ( w_load_kdf_drbg_seed_0_state_value_63_32 ),
        .w_load_kdf_drbg_seed_0_state_value_95_64 ( w_load_kdf_drbg_seed_0_state_value_95_64 ),
        .w_load_kdf_drbg_seed_0_state_value_127_96 ( w_load_kdf_drbg_seed_0_state_value_127_96 ),
        .w_load_kdf_drbg_seed_0_reseed_interval_0 ( w_load_kdf_drbg_seed_0_reseed_interval_0 ),
        .w_load_kdf_drbg_seed_0_reseed_interval_1 ( w_load_kdf_drbg_seed_0_reseed_interval_1 ),
        .w_load_kdf_drbg_seed_1_state_key_31_0  ( w_load_kdf_drbg_seed_1_state_key_31_0 ),
        .w_load_kdf_drbg_seed_1_state_key_63_32 ( w_load_kdf_drbg_seed_1_state_key_63_32 ),
        .w_load_kdf_drbg_seed_1_state_key_95_64 ( w_load_kdf_drbg_seed_1_state_key_95_64 ),
        .w_load_kdf_drbg_seed_1_state_key_127_96 ( w_load_kdf_drbg_seed_1_state_key_127_96 ),
        .w_load_kdf_drbg_seed_1_state_key_159_128 ( w_load_kdf_drbg_seed_1_state_key_159_128 ),
        .w_load_kdf_drbg_seed_1_state_key_191_160 ( w_load_kdf_drbg_seed_1_state_key_191_160 ),
        .w_load_kdf_drbg_seed_1_state_key_223_192 ( w_load_kdf_drbg_seed_1_state_key_223_192 ),
        .w_load_kdf_drbg_seed_1_state_key_255_224 ( w_load_kdf_drbg_seed_1_state_key_255_224 ),
        .w_load_kdf_drbg_seed_1_state_value_31_0 ( w_load_kdf_drbg_seed_1_state_value_31_0 ),
        .w_load_kdf_drbg_seed_1_state_value_63_32 ( w_load_kdf_drbg_seed_1_state_value_63_32 ),
        .w_load_kdf_drbg_seed_1_state_value_95_64 ( w_load_kdf_drbg_seed_1_state_value_95_64 ),
        .w_load_kdf_drbg_seed_1_state_value_127_96 ( w_load_kdf_drbg_seed_1_state_value_127_96 ),
        .w_load_kdf_drbg_seed_1_reseed_interval_0 ( w_load_kdf_drbg_seed_1_reseed_interval_0 ),
        .w_load_kdf_drbg_seed_1_reseed_interval_1 ( w_load_kdf_drbg_seed_1_reseed_interval_1 ),
        .w_load_interrupt_status                ( w_load_interrupt_status ),
        .w_load_interrupt_mask                  ( w_load_interrupt_mask ),
        .w_load_engine_sticky_status            ( w_load_engine_sticky_status ),
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
        .w_load_im_consumed                     ( w_load_im_consumed ),
        .w_load_tready_override                 ( w_load_tready_override ),
        .w_load_regs_sa_ctrl                    ( w_load_regs_sa_ctrl ),
        .w_load_sa_snapshot_ia_wdata_part0      ( w_load_sa_snapshot_ia_wdata_part0 ),
        .w_load_sa_snapshot_ia_wdata_part1      ( w_load_sa_snapshot_ia_wdata_part1 ),
        .w_load_sa_snapshot_ia_config           ( w_load_sa_snapshot_ia_config ),
        .w_load_sa_count_ia_wdata_part0         ( w_load_sa_count_ia_wdata_part0 ),
        .w_load_sa_count_ia_wdata_part1         ( w_load_sa_count_ia_wdata_part1 ),
        .w_load_sa_count_ia_config              ( w_load_sa_count_ia_config ),
        .w_load_cceip_encrypt_kop_fifo_override ( w_load_cceip_encrypt_kop_fifo_override ),
        .w_load_cceip_validate_kop_fifo_override ( w_load_cceip_validate_kop_fifo_override ),
        .w_load_cddip_decrypt_kop_fifo_override ( w_load_cddip_decrypt_kop_fifo_override ),
        .w_load_sa_global_ctrl                  ( w_load_sa_global_ctrl ),
        .w_load_sa_ctrl_ia_wdata_part0          ( w_load_sa_ctrl_ia_wdata_part0 ),
        .w_load_sa_ctrl_ia_config               ( w_load_sa_ctrl_ia_config ),
        .w_load_kdf_test_key_size_config        ( w_load_kdf_test_key_size_config ),
        .f32_data                               ( f32_data )
  );

  

  

  `ifdef CR_KME_DIGEST_3FE7A8A8BB9DF2AAEF69F2383C0979F7
  `else
    initial begin
      $display("Error: the core decode file (cr_kme_regs.sv) and include file (cr_kme.vh) were compiled");
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


module cr_kme_regs_flops (
  input                                         clk,
  input                                         i_reset_,
  input                                         i_sw_init,

  
  output reg [`CR_KME_C_SPARE_T_DECL]           o_spare_config,
  output reg [`CR_KME_C_CCEIP0_OUT_PART0_T_DECL] o_cceip0_out_ia_wdata_part0,
  output reg [`CR_KME_C_CCEIP0_OUT_PART1_T_DECL] o_cceip0_out_ia_wdata_part1,
  output reg [`CR_KME_C_CCEIP0_OUT_PART2_T_DECL] o_cceip0_out_ia_wdata_part2,
  output reg [`CR_KME_C_CCEIP0_OUT_IA_CONFIG_T_DECL] o_cceip0_out_ia_config,
  output reg [`CR_KME_C_CCEIP0_OUT_IM_CONFIG_T_DECL] o_cceip0_out_im_config,
  output reg [`CR_KME_C_CCEIP0_OUT_IM_CONSUMED_T_DECL] o_cceip0_out_im_read_done,
  output reg [`CR_KME_C_CCEIP1_OUT_PART0_T_DECL] o_cceip1_out_ia_wdata_part0,
  output reg [`CR_KME_C_CCEIP1_OUT_PART1_T_DECL] o_cceip1_out_ia_wdata_part1,
  output reg [`CR_KME_C_CCEIP1_OUT_PART2_T_DECL] o_cceip1_out_ia_wdata_part2,
  output reg [`CR_KME_C_CCEIP1_OUT_IA_CONFIG_T_DECL] o_cceip1_out_ia_config,
  output reg [`CR_KME_C_CCEIP1_OUT_IM_CONFIG_T_DECL] o_cceip1_out_im_config,
  output reg [`CR_KME_C_CCEIP1_OUT_IM_CONSUMED_T_DECL] o_cceip1_out_im_read_done,
  output reg [`CR_KME_C_CCEIP2_OUT_PART0_T_DECL] o_cceip2_out_ia_wdata_part0,
  output reg [`CR_KME_C_CCEIP2_OUT_PART1_T_DECL] o_cceip2_out_ia_wdata_part1,
  output reg [`CR_KME_C_CCEIP2_OUT_PART2_T_DECL] o_cceip2_out_ia_wdata_part2,
  output reg [`CR_KME_C_CCEIP2_OUT_IA_CONFIG_T_DECL] o_cceip2_out_ia_config,
  output reg [`CR_KME_C_CCEIP2_OUT_IM_CONFIG_T_DECL] o_cceip2_out_im_config,
  output reg [`CR_KME_C_CCEIP2_OUT_IM_CONSUMED_T_DECL] o_cceip2_out_im_read_done,
  output reg [`CR_KME_C_CCEIP3_OUT_PART0_T_DECL] o_cceip3_out_ia_wdata_part0,
  output reg [`CR_KME_C_CCEIP3_OUT_PART1_T_DECL] o_cceip3_out_ia_wdata_part1,
  output reg [`CR_KME_C_CCEIP3_OUT_PART2_T_DECL] o_cceip3_out_ia_wdata_part2,
  output reg [`CR_KME_C_CCEIP3_OUT_IA_CONFIG_T_DECL] o_cceip3_out_ia_config,
  output reg [`CR_KME_C_CCEIP3_OUT_IM_CONFIG_T_DECL] o_cceip3_out_im_config,
  output reg [`CR_KME_C_CCEIP3_OUT_IM_CONSUMED_T_DECL] o_cceip3_out_im_read_done,
  output reg [`CR_KME_C_CDDIP0_OUT_PART0_T_DECL] o_cddip0_out_ia_wdata_part0,
  output reg [`CR_KME_C_CDDIP0_OUT_PART1_T_DECL] o_cddip0_out_ia_wdata_part1,
  output reg [`CR_KME_C_CDDIP0_OUT_PART2_T_DECL] o_cddip0_out_ia_wdata_part2,
  output reg [`CR_KME_C_CDDIP0_OUT_IA_CONFIG_T_DECL] o_cddip0_out_ia_config,
  output reg [`CR_KME_C_CDDIP0_OUT_IM_CONFIG_T_DECL] o_cddip0_out_im_config,
  output reg [`CR_KME_C_CDDIP0_OUT_IM_CONSUMED_T_DECL] o_cddip0_out_im_read_done,
  output reg [`CR_KME_C_CDDIP1_OUT_PART0_T_DECL] o_cddip1_out_ia_wdata_part0,
  output reg [`CR_KME_C_CDDIP1_OUT_PART1_T_DECL] o_cddip1_out_ia_wdata_part1,
  output reg [`CR_KME_C_CDDIP1_OUT_PART2_T_DECL] o_cddip1_out_ia_wdata_part2,
  output reg [`CR_KME_C_CDDIP1_OUT_IA_CONFIG_T_DECL] o_cddip1_out_ia_config,
  output reg [`CR_KME_C_CDDIP1_OUT_IM_CONFIG_T_DECL] o_cddip1_out_im_config,
  output reg [`CR_KME_C_CDDIP1_OUT_IM_CONSUMED_T_DECL] o_cddip1_out_im_read_done,
  output reg [`CR_KME_C_CDDIP2_OUT_PART0_T_DECL] o_cddip2_out_ia_wdata_part0,
  output reg [`CR_KME_C_CDDIP2_OUT_PART1_T_DECL] o_cddip2_out_ia_wdata_part1,
  output reg [`CR_KME_C_CDDIP2_OUT_PART2_T_DECL] o_cddip2_out_ia_wdata_part2,
  output reg [`CR_KME_C_CDDIP2_OUT_IA_CONFIG_T_DECL] o_cddip2_out_ia_config,
  output reg [`CR_KME_C_CDDIP2_OUT_IM_CONFIG_T_DECL] o_cddip2_out_im_config,
  output reg [`CR_KME_C_CDDIP2_OUT_IM_CONSUMED_T_DECL] o_cddip2_out_im_read_done,
  output reg [`CR_KME_C_CDDIP3_OUT_PART0_T_DECL] o_cddip3_out_ia_wdata_part0,
  output reg [`CR_KME_C_CDDIP3_OUT_PART1_T_DECL] o_cddip3_out_ia_wdata_part1,
  output reg [`CR_KME_C_CDDIP3_OUT_PART2_T_DECL] o_cddip3_out_ia_wdata_part2,
  output reg [`CR_KME_C_CDDIP3_OUT_IA_CONFIG_T_DECL] o_cddip3_out_ia_config,
  output reg [`CR_KME_C_CDDIP3_OUT_IM_CONFIG_T_DECL] o_cddip3_out_im_config,
  output reg [`CR_KME_C_CDDIP3_OUT_IM_CONSUMED_T_DECL] o_cddip3_out_im_read_done,
  output reg [`CR_KME_C_CKV_PART0_T_DECL]       o_ckv_ia_wdata_part0,
  output reg [`CR_KME_C_CKV_PART1_T_DECL]       o_ckv_ia_wdata_part1,
  output reg [`CR_KME_C_CKV_IA_CONFIG_T_DECL]   o_ckv_ia_config,
  output reg [`CR_KME_C_KIM_ENTRY0_T_DECL]      o_kim_ia_wdata_part0,
  output reg [`CR_KME_C_KIM_ENTRY1_T_DECL]      o_kim_ia_wdata_part1,
  output reg [`CR_KME_C_KIM_IA_CONFIG_T_DECL]   o_kim_ia_config,
  output reg [`CR_KME_C_LABEL_METADATA_T_DECL]  o_label0_config,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label0_data7,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label0_data6,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label0_data5,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label0_data4,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label0_data3,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label0_data2,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label0_data1,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label0_data0,
  output reg [`CR_KME_C_LABEL_METADATA_T_DECL]  o_label1_config,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label1_data7,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label1_data6,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label1_data5,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label1_data4,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label1_data3,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label1_data2,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label1_data1,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label1_data0,
  output reg [`CR_KME_C_LABEL_METADATA_T_DECL]  o_label2_config,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label2_data7,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label2_data6,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label2_data5,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label2_data4,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label2_data3,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label2_data2,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label2_data1,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label2_data0,
  output reg [`CR_KME_C_LABEL_METADATA_T_DECL]  o_label3_config,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label3_data7,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label3_data6,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label3_data5,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label3_data4,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label3_data3,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label3_data2,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label3_data1,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label3_data0,
  output reg [`CR_KME_C_LABEL_METADATA_T_DECL]  o_label4_config,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label4_data7,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label4_data6,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label4_data5,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label4_data4,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label4_data3,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label4_data2,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label4_data1,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label4_data0,
  output reg [`CR_KME_C_LABEL_METADATA_T_DECL]  o_label5_config,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label5_data7,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label5_data6,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label5_data5,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label5_data4,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label5_data3,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label5_data2,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label5_data1,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label5_data0,
  output reg [`CR_KME_C_LABEL_METADATA_T_DECL]  o_label6_config,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label6_data7,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label6_data6,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label6_data5,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label6_data4,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label6_data3,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label6_data2,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label6_data1,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label6_data0,
  output reg [`CR_KME_C_LABEL_METADATA_T_DECL]  o_label7_config,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label7_data7,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label7_data6,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label7_data5,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label7_data4,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label7_data3,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label7_data2,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label7_data1,
  output reg [`CR_KME_C_LABEL_DATA_T_DECL]      o_label7_data0,
  output reg [`CR_KME_C_KDF_DRBG_CTRL_T_DECL]   o_kdf_drbg_ctrl,
  output reg [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_31_0,
  output reg [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_63_32,
  output reg [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_95_64,
  output reg [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_127_96,
  output reg [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_159_128,
  output reg [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_191_160,
  output reg [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_223_192,
  output reg [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_255_224,
  output reg [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_0_state_value_31_0,
  output reg [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_0_state_value_63_32,
  output reg [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_0_state_value_95_64,
  output reg [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_0_state_value_127_96,
  output reg [`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_0_T_DECL] o_kdf_drbg_seed_0_reseed_interval_0,
  output reg [`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_1_T_DECL] o_kdf_drbg_seed_0_reseed_interval_1,
  output reg [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_31_0,
  output reg [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_63_32,
  output reg [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_95_64,
  output reg [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_127_96,
  output reg [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_159_128,
  output reg [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_191_160,
  output reg [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_223_192,
  output reg [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_255_224,
  output reg [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_1_state_value_31_0,
  output reg [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_1_state_value_63_32,
  output reg [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_1_state_value_95_64,
  output reg [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_1_state_value_127_96,
  output reg [`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_0_T_DECL] o_kdf_drbg_seed_1_reseed_interval_0,
  output reg [`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_1_T_DECL] o_kdf_drbg_seed_1_reseed_interval_1,
  output reg [`CR_KME_C_INT_STATUS_T_DECL]      o_interrupt_status,
  output reg [`CR_KME_C_INT_MASK_T_DECL]        o_interrupt_mask,
  output reg [`CR_KME_C_STICKY_ENG_BP_T_DECL]   o_engine_sticky_status,
  output reg [`CR_KME_C_BIMC_MONITOR_MASK_T_DECL] o_bimc_monitor_mask,
  output reg [`CR_KME_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_uncorrectable_error_cnt,
  output reg [`CR_KME_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_correctable_error_cnt,
  output reg [`CR_KME_C_BIMC_PARITY_ERROR_CNT_T_DECL] o_bimc_parity_error_cnt,
  output reg [`CR_KME_C_BIMC_GLOBAL_CONFIG_T_DECL] o_bimc_global_config,
  output reg [`CR_KME_C_BIMC_ECCPAR_DEBUG_T_DECL] o_bimc_eccpar_debug,
  output reg [`CR_KME_C_BIMC_CMD2_T_DECL]       o_bimc_cmd2,
  output reg [`CR_KME_C_BIMC_CMD1_T_DECL]       o_bimc_cmd1,
  output reg [`CR_KME_C_BIMC_CMD0_T_DECL]       o_bimc_cmd0,
  output reg [`CR_KME_C_BIMC_RXCMD2_T_DECL]     o_bimc_rxcmd2,
  output reg [`CR_KME_C_BIMC_RXRSP2_T_DECL]     o_bimc_rxrsp2,
  output reg [`CR_KME_C_BIMC_POLLRSP2_T_DECL]   o_bimc_pollrsp2,
  output reg [`CR_KME_C_BIMC_DBGCMD2_T_DECL]    o_bimc_dbgcmd2,
  output reg [`CR_KME_C_IM_CONSUMED_T_DECL]     o_im_consumed,
  output reg [`CR_KME_C_TREADY_OVERRIDE_T_DECL] o_tready_override,
  output reg [`CR_KME_C_SA_CTRL_DEP_T_DECL]     o_regs_sa_ctrl,
  output reg [`CR_KME_C_SA_SNAPSHOT_PART1_T_DECL] o_sa_snapshot_ia_wdata_part0,
  output reg [`CR_KME_C_SA_SNAPSHOT_PART0_T_DECL] o_sa_snapshot_ia_wdata_part1,
  output reg [`CR_KME_C_SA_SNAPSHOT_IA_CONFIG_T_DECL] o_sa_snapshot_ia_config,
  output reg [`CR_KME_C_SA_COUNT_PART1_T_DECL]  o_sa_count_ia_wdata_part0,
  output reg [`CR_KME_C_SA_COUNT_PART0_T_DECL]  o_sa_count_ia_wdata_part1,
  output reg [`CR_KME_C_SA_COUNT_IA_CONFIG_T_DECL] o_sa_count_ia_config,
  output reg [`CR_KME_C_KOP_FIFO_OVERRIDE_T_DECL] o_cceip_encrypt_kop_fifo_override,
  output reg [`CR_KME_C_KOP_FIFO_OVERRIDE_T_DECL] o_cceip_validate_kop_fifo_override,
  output reg [`CR_KME_C_KOP_FIFO_OVERRIDE_T_DECL] o_cddip_decrypt_kop_fifo_override,
  output reg [`CR_KME_C_SA_GLOBAL_CTRL_T_DECL]  o_sa_global_ctrl,
  output reg [`CR_KME_C_SA_CTRL_T_DECL]         o_sa_ctrl_ia_wdata_part0,
  output reg [`CR_KME_C_SA_CTRL_IA_CONFIG_T_DECL] o_sa_ctrl_ia_config,
  output reg [`CR_KME_C_KDF_TEST_KEY_SIZE_T_DECL] o_kdf_test_key_size_config,


  
  input                                         w_load_spare_config,
  input                                         w_load_cceip0_out_ia_wdata_part0,
  input                                         w_load_cceip0_out_ia_wdata_part1,
  input                                         w_load_cceip0_out_ia_wdata_part2,
  input                                         w_load_cceip0_out_ia_config,
  input                                         w_load_cceip0_out_im_config,
  input                                         w_load_cceip0_out_im_read_done,
  input                                         w_load_cceip1_out_ia_wdata_part0,
  input                                         w_load_cceip1_out_ia_wdata_part1,
  input                                         w_load_cceip1_out_ia_wdata_part2,
  input                                         w_load_cceip1_out_ia_config,
  input                                         w_load_cceip1_out_im_config,
  input                                         w_load_cceip1_out_im_read_done,
  input                                         w_load_cceip2_out_ia_wdata_part0,
  input                                         w_load_cceip2_out_ia_wdata_part1,
  input                                         w_load_cceip2_out_ia_wdata_part2,
  input                                         w_load_cceip2_out_ia_config,
  input                                         w_load_cceip2_out_im_config,
  input                                         w_load_cceip2_out_im_read_done,
  input                                         w_load_cceip3_out_ia_wdata_part0,
  input                                         w_load_cceip3_out_ia_wdata_part1,
  input                                         w_load_cceip3_out_ia_wdata_part2,
  input                                         w_load_cceip3_out_ia_config,
  input                                         w_load_cceip3_out_im_config,
  input                                         w_load_cceip3_out_im_read_done,
  input                                         w_load_cddip0_out_ia_wdata_part0,
  input                                         w_load_cddip0_out_ia_wdata_part1,
  input                                         w_load_cddip0_out_ia_wdata_part2,
  input                                         w_load_cddip0_out_ia_config,
  input                                         w_load_cddip0_out_im_config,
  input                                         w_load_cddip0_out_im_read_done,
  input                                         w_load_cddip1_out_ia_wdata_part0,
  input                                         w_load_cddip1_out_ia_wdata_part1,
  input                                         w_load_cddip1_out_ia_wdata_part2,
  input                                         w_load_cddip1_out_ia_config,
  input                                         w_load_cddip1_out_im_config,
  input                                         w_load_cddip1_out_im_read_done,
  input                                         w_load_cddip2_out_ia_wdata_part0,
  input                                         w_load_cddip2_out_ia_wdata_part1,
  input                                         w_load_cddip2_out_ia_wdata_part2,
  input                                         w_load_cddip2_out_ia_config,
  input                                         w_load_cddip2_out_im_config,
  input                                         w_load_cddip2_out_im_read_done,
  input                                         w_load_cddip3_out_ia_wdata_part0,
  input                                         w_load_cddip3_out_ia_wdata_part1,
  input                                         w_load_cddip3_out_ia_wdata_part2,
  input                                         w_load_cddip3_out_ia_config,
  input                                         w_load_cddip3_out_im_config,
  input                                         w_load_cddip3_out_im_read_done,
  input                                         w_load_ckv_ia_wdata_part0,
  input                                         w_load_ckv_ia_wdata_part1,
  input                                         w_load_ckv_ia_config,
  input                                         w_load_kim_ia_wdata_part0,
  input                                         w_load_kim_ia_wdata_part1,
  input                                         w_load_kim_ia_config,
  input                                         w_load_label0_config,
  input                                         w_load_label0_data7,
  input                                         w_load_label0_data6,
  input                                         w_load_label0_data5,
  input                                         w_load_label0_data4,
  input                                         w_load_label0_data3,
  input                                         w_load_label0_data2,
  input                                         w_load_label0_data1,
  input                                         w_load_label0_data0,
  input                                         w_load_label1_config,
  input                                         w_load_label1_data7,
  input                                         w_load_label1_data6,
  input                                         w_load_label1_data5,
  input                                         w_load_label1_data4,
  input                                         w_load_label1_data3,
  input                                         w_load_label1_data2,
  input                                         w_load_label1_data1,
  input                                         w_load_label1_data0,
  input                                         w_load_label2_config,
  input                                         w_load_label2_data7,
  input                                         w_load_label2_data6,
  input                                         w_load_label2_data5,
  input                                         w_load_label2_data4,
  input                                         w_load_label2_data3,
  input                                         w_load_label2_data2,
  input                                         w_load_label2_data1,
  input                                         w_load_label2_data0,
  input                                         w_load_label3_config,
  input                                         w_load_label3_data7,
  input                                         w_load_label3_data6,
  input                                         w_load_label3_data5,
  input                                         w_load_label3_data4,
  input                                         w_load_label3_data3,
  input                                         w_load_label3_data2,
  input                                         w_load_label3_data1,
  input                                         w_load_label3_data0,
  input                                         w_load_label4_config,
  input                                         w_load_label4_data7,
  input                                         w_load_label4_data6,
  input                                         w_load_label4_data5,
  input                                         w_load_label4_data4,
  input                                         w_load_label4_data3,
  input                                         w_load_label4_data2,
  input                                         w_load_label4_data1,
  input                                         w_load_label4_data0,
  input                                         w_load_label5_config,
  input                                         w_load_label5_data7,
  input                                         w_load_label5_data6,
  input                                         w_load_label5_data5,
  input                                         w_load_label5_data4,
  input                                         w_load_label5_data3,
  input                                         w_load_label5_data2,
  input                                         w_load_label5_data1,
  input                                         w_load_label5_data0,
  input                                         w_load_label6_config,
  input                                         w_load_label6_data7,
  input                                         w_load_label6_data6,
  input                                         w_load_label6_data5,
  input                                         w_load_label6_data4,
  input                                         w_load_label6_data3,
  input                                         w_load_label6_data2,
  input                                         w_load_label6_data1,
  input                                         w_load_label6_data0,
  input                                         w_load_label7_config,
  input                                         w_load_label7_data7,
  input                                         w_load_label7_data6,
  input                                         w_load_label7_data5,
  input                                         w_load_label7_data4,
  input                                         w_load_label7_data3,
  input                                         w_load_label7_data2,
  input                                         w_load_label7_data1,
  input                                         w_load_label7_data0,
  input                                         w_load_kdf_drbg_ctrl,
  input                                         w_load_kdf_drbg_seed_0_state_key_31_0,
  input                                         w_load_kdf_drbg_seed_0_state_key_63_32,
  input                                         w_load_kdf_drbg_seed_0_state_key_95_64,
  input                                         w_load_kdf_drbg_seed_0_state_key_127_96,
  input                                         w_load_kdf_drbg_seed_0_state_key_159_128,
  input                                         w_load_kdf_drbg_seed_0_state_key_191_160,
  input                                         w_load_kdf_drbg_seed_0_state_key_223_192,
  input                                         w_load_kdf_drbg_seed_0_state_key_255_224,
  input                                         w_load_kdf_drbg_seed_0_state_value_31_0,
  input                                         w_load_kdf_drbg_seed_0_state_value_63_32,
  input                                         w_load_kdf_drbg_seed_0_state_value_95_64,
  input                                         w_load_kdf_drbg_seed_0_state_value_127_96,
  input                                         w_load_kdf_drbg_seed_0_reseed_interval_0,
  input                                         w_load_kdf_drbg_seed_0_reseed_interval_1,
  input                                         w_load_kdf_drbg_seed_1_state_key_31_0,
  input                                         w_load_kdf_drbg_seed_1_state_key_63_32,
  input                                         w_load_kdf_drbg_seed_1_state_key_95_64,
  input                                         w_load_kdf_drbg_seed_1_state_key_127_96,
  input                                         w_load_kdf_drbg_seed_1_state_key_159_128,
  input                                         w_load_kdf_drbg_seed_1_state_key_191_160,
  input                                         w_load_kdf_drbg_seed_1_state_key_223_192,
  input                                         w_load_kdf_drbg_seed_1_state_key_255_224,
  input                                         w_load_kdf_drbg_seed_1_state_value_31_0,
  input                                         w_load_kdf_drbg_seed_1_state_value_63_32,
  input                                         w_load_kdf_drbg_seed_1_state_value_95_64,
  input                                         w_load_kdf_drbg_seed_1_state_value_127_96,
  input                                         w_load_kdf_drbg_seed_1_reseed_interval_0,
  input                                         w_load_kdf_drbg_seed_1_reseed_interval_1,
  input                                         w_load_interrupt_status,
  input                                         w_load_interrupt_mask,
  input                                         w_load_engine_sticky_status,
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
  input                                         w_load_im_consumed,
  input                                         w_load_tready_override,
  input                                         w_load_regs_sa_ctrl,
  input                                         w_load_sa_snapshot_ia_wdata_part0,
  input                                         w_load_sa_snapshot_ia_wdata_part1,
  input                                         w_load_sa_snapshot_ia_config,
  input                                         w_load_sa_count_ia_wdata_part0,
  input                                         w_load_sa_count_ia_wdata_part1,
  input                                         w_load_sa_count_ia_config,
  input                                         w_load_cceip_encrypt_kop_fifo_override,
  input                                         w_load_cceip_validate_kop_fifo_override,
  input                                         w_load_cddip_decrypt_kop_fifo_override,
  input                                         w_load_sa_global_ctrl,
  input                                         w_load_sa_ctrl_ia_wdata_part0,
  input                                         w_load_sa_ctrl_ia_config,
  input                                         w_load_kdf_test_key_size_config,

  input      [31:0]                             f32_data
  );

  
  

  
  

  
  
  
  always_ff @(posedge clk or negedge i_reset_) begin
    if(~i_reset_) begin
      
      o_spare_config[31:00]                       <= 32'd0; 
      o_cceip0_out_ia_wdata_part0[05:00]          <= 6'd0; 
      o_cceip0_out_ia_wdata_part1[31:00]          <= 32'd0; 
      o_cceip0_out_ia_wdata_part2[31:00]          <= 32'd0; 
      o_cceip0_out_ia_config[08:00]               <= 9'd0; 
      o_cceip0_out_ia_config[12:09]               <= 4'd0; 
      o_cceip0_out_im_config[09:00]               <= 10'd512; 
      o_cceip0_out_im_config[11:10]               <= 2'd3; 
      o_cceip0_out_im_read_done[00:00]            <= 1'd0; 
      o_cceip0_out_im_read_done[01:01]            <= 1'd0; 
      o_cceip1_out_ia_wdata_part0[05:00]          <= 6'd0; 
      o_cceip1_out_ia_wdata_part1[31:00]          <= 32'd0; 
      o_cceip1_out_ia_wdata_part2[31:00]          <= 32'd0; 
      o_cceip1_out_ia_config[08:00]               <= 9'd0; 
      o_cceip1_out_ia_config[12:09]               <= 4'd0; 
      o_cceip1_out_im_config[09:00]               <= 10'd512; 
      o_cceip1_out_im_config[11:10]               <= 2'd3; 
      o_cceip1_out_im_read_done[00:00]            <= 1'd0; 
      o_cceip1_out_im_read_done[01:01]            <= 1'd0; 
      o_cceip2_out_ia_wdata_part0[05:00]          <= 6'd0; 
      o_cceip2_out_ia_wdata_part1[31:00]          <= 32'd0; 
      o_cceip2_out_ia_wdata_part2[31:00]          <= 32'd0; 
      o_cceip2_out_ia_config[08:00]               <= 9'd0; 
      o_cceip2_out_ia_config[12:09]               <= 4'd0; 
      o_cceip2_out_im_config[09:00]               <= 10'd512; 
      o_cceip2_out_im_config[11:10]               <= 2'd3; 
      o_cceip2_out_im_read_done[00:00]            <= 1'd0; 
      o_cceip2_out_im_read_done[01:01]            <= 1'd0; 
      o_cceip3_out_ia_wdata_part0[05:00]          <= 6'd0; 
      o_cceip3_out_ia_wdata_part1[31:00]          <= 32'd0; 
      o_cceip3_out_ia_wdata_part2[31:00]          <= 32'd0; 
      o_cceip3_out_ia_config[08:00]               <= 9'd0; 
      o_cceip3_out_ia_config[12:09]               <= 4'd0; 
      o_cceip3_out_im_config[09:00]               <= 10'd512; 
      o_cceip3_out_im_config[11:10]               <= 2'd3; 
      o_cceip3_out_im_read_done[00:00]            <= 1'd0; 
      o_cceip3_out_im_read_done[01:01]            <= 1'd0; 
      o_cddip0_out_ia_wdata_part0[05:00]          <= 6'd0; 
      o_cddip0_out_ia_wdata_part1[31:00]          <= 32'd0; 
      o_cddip0_out_ia_wdata_part2[31:00]          <= 32'd0; 
      o_cddip0_out_ia_config[08:00]               <= 9'd0; 
      o_cddip0_out_ia_config[12:09]               <= 4'd0; 
      o_cddip0_out_im_config[09:00]               <= 10'd512; 
      o_cddip0_out_im_config[11:10]               <= 2'd3; 
      o_cddip0_out_im_read_done[00:00]            <= 1'd0; 
      o_cddip0_out_im_read_done[01:01]            <= 1'd0; 
      o_cddip1_out_ia_wdata_part0[05:00]          <= 6'd0; 
      o_cddip1_out_ia_wdata_part1[31:00]          <= 32'd0; 
      o_cddip1_out_ia_wdata_part2[31:00]          <= 32'd0; 
      o_cddip1_out_ia_config[08:00]               <= 9'd0; 
      o_cddip1_out_ia_config[12:09]               <= 4'd0; 
      o_cddip1_out_im_config[09:00]               <= 10'd512; 
      o_cddip1_out_im_config[11:10]               <= 2'd3; 
      o_cddip1_out_im_read_done[00:00]            <= 1'd0; 
      o_cddip1_out_im_read_done[01:01]            <= 1'd0; 
      o_cddip2_out_ia_wdata_part0[05:00]          <= 6'd0; 
      o_cddip2_out_ia_wdata_part1[31:00]          <= 32'd0; 
      o_cddip2_out_ia_wdata_part2[31:00]          <= 32'd0; 
      o_cddip2_out_ia_config[08:00]               <= 9'd0; 
      o_cddip2_out_ia_config[12:09]               <= 4'd0; 
      o_cddip2_out_im_config[09:00]               <= 10'd512; 
      o_cddip2_out_im_config[11:10]               <= 2'd3; 
      o_cddip2_out_im_read_done[00:00]            <= 1'd0; 
      o_cddip2_out_im_read_done[01:01]            <= 1'd0; 
      o_cddip3_out_ia_wdata_part0[05:00]          <= 6'd0; 
      o_cddip3_out_ia_wdata_part1[31:00]          <= 32'd0; 
      o_cddip3_out_ia_wdata_part2[31:00]          <= 32'd0; 
      o_cddip3_out_ia_config[08:00]               <= 9'd0; 
      o_cddip3_out_ia_config[12:09]               <= 4'd0; 
      o_cddip3_out_im_config[09:00]               <= 10'd512; 
      o_cddip3_out_im_config[11:10]               <= 2'd3; 
      o_cddip3_out_im_read_done[00:00]            <= 1'd0; 
      o_cddip3_out_im_read_done[01:01]            <= 1'd0; 
      o_ckv_ia_wdata_part0[31:00]                 <= 32'd0; 
      o_ckv_ia_wdata_part1[31:00]                 <= 32'd0; 
      o_ckv_ia_config[14:00]                      <= 15'd0; 
      o_ckv_ia_config[18:15]                      <= 4'd0; 
      o_kim_ia_wdata_part0[14:00]                 <= 15'd0; 
      o_kim_ia_wdata_part0[16:15]                 <= 2'd0; 
      o_kim_ia_wdata_part0[19:17]                 <= 3'd0; 
      o_kim_ia_wdata_part0[20:20]                 <= 1'd0; 
      o_kim_ia_wdata_part1[00:00]                 <= 1'd0; 
      o_kim_ia_wdata_part1[12:01]                 <= 12'd0; 
      o_kim_ia_wdata_part1[16:13]                 <= 4'd0; 
      o_kim_ia_config[13:00]                      <= 14'd0; 
      o_kim_ia_config[17:14]                      <= 4'd0; 
      o_label0_config[07:00]                      <= 8'd0; 
      o_label0_config[08:08]                      <= 1'd1; 
      o_label0_config[14:09]                      <= 6'd0; 
      o_label0_config[15:15]                      <= 1'd0; 
      o_label0_data7[31:00]                       <= 32'd0; 
      o_label0_data6[31:00]                       <= 32'd0; 
      o_label0_data5[31:00]                       <= 32'd0; 
      o_label0_data4[31:00]                       <= 32'd0; 
      o_label0_data3[31:00]                       <= 32'd0; 
      o_label0_data2[31:00]                       <= 32'd0; 
      o_label0_data1[31:00]                       <= 32'd0; 
      o_label0_data0[31:00]                       <= 32'd0; 
      o_label1_config[07:00]                      <= 8'd0; 
      o_label1_config[08:08]                      <= 1'd1; 
      o_label1_config[14:09]                      <= 6'd0; 
      o_label1_config[15:15]                      <= 1'd0; 
      o_label1_data7[31:00]                       <= 32'd0; 
      o_label1_data6[31:00]                       <= 32'd0; 
      o_label1_data5[31:00]                       <= 32'd0; 
      o_label1_data4[31:00]                       <= 32'd0; 
      o_label1_data3[31:00]                       <= 32'd0; 
      o_label1_data2[31:00]                       <= 32'd0; 
      o_label1_data1[31:00]                       <= 32'd0; 
      o_label1_data0[31:00]                       <= 32'd0; 
      o_label2_config[07:00]                      <= 8'd0; 
      o_label2_config[08:08]                      <= 1'd1; 
      o_label2_config[14:09]                      <= 6'd0; 
      o_label2_config[15:15]                      <= 1'd0; 
      o_label2_data7[31:00]                       <= 32'd0; 
      o_label2_data6[31:00]                       <= 32'd0; 
      o_label2_data5[31:00]                       <= 32'd0; 
      o_label2_data4[31:00]                       <= 32'd0; 
      o_label2_data3[31:00]                       <= 32'd0; 
      o_label2_data2[31:00]                       <= 32'd0; 
      o_label2_data1[31:00]                       <= 32'd0; 
      o_label2_data0[31:00]                       <= 32'd0; 
      o_label3_config[07:00]                      <= 8'd0; 
      o_label3_config[08:08]                      <= 1'd1; 
      o_label3_config[14:09]                      <= 6'd0; 
      o_label3_config[15:15]                      <= 1'd0; 
      o_label3_data7[31:00]                       <= 32'd0; 
      o_label3_data6[31:00]                       <= 32'd0; 
      o_label3_data5[31:00]                       <= 32'd0; 
      o_label3_data4[31:00]                       <= 32'd0; 
      o_label3_data3[31:00]                       <= 32'd0; 
      o_label3_data2[31:00]                       <= 32'd0; 
      o_label3_data1[31:00]                       <= 32'd0; 
      o_label3_data0[31:00]                       <= 32'd0; 
      o_label4_config[07:00]                      <= 8'd0; 
      o_label4_config[08:08]                      <= 1'd1; 
      o_label4_config[14:09]                      <= 6'd0; 
      o_label4_config[15:15]                      <= 1'd0; 
      o_label4_data7[31:00]                       <= 32'd0; 
      o_label4_data6[31:00]                       <= 32'd0; 
      o_label4_data5[31:00]                       <= 32'd0; 
      o_label4_data4[31:00]                       <= 32'd0; 
      o_label4_data3[31:00]                       <= 32'd0; 
      o_label4_data2[31:00]                       <= 32'd0; 
      o_label4_data1[31:00]                       <= 32'd0; 
      o_label4_data0[31:00]                       <= 32'd0; 
      o_label5_config[07:00]                      <= 8'd0; 
      o_label5_config[08:08]                      <= 1'd1; 
      o_label5_config[14:09]                      <= 6'd0; 
      o_label5_config[15:15]                      <= 1'd0; 
      o_label5_data7[31:00]                       <= 32'd0; 
      o_label5_data6[31:00]                       <= 32'd0; 
      o_label5_data5[31:00]                       <= 32'd0; 
      o_label5_data4[31:00]                       <= 32'd0; 
      o_label5_data3[31:00]                       <= 32'd0; 
      o_label5_data2[31:00]                       <= 32'd0; 
      o_label5_data1[31:00]                       <= 32'd0; 
      o_label5_data0[31:00]                       <= 32'd0; 
      o_label6_config[07:00]                      <= 8'd0; 
      o_label6_config[08:08]                      <= 1'd1; 
      o_label6_config[14:09]                      <= 6'd0; 
      o_label6_config[15:15]                      <= 1'd0; 
      o_label6_data7[31:00]                       <= 32'd0; 
      o_label6_data6[31:00]                       <= 32'd0; 
      o_label6_data5[31:00]                       <= 32'd0; 
      o_label6_data4[31:00]                       <= 32'd0; 
      o_label6_data3[31:00]                       <= 32'd0; 
      o_label6_data2[31:00]                       <= 32'd0; 
      o_label6_data1[31:00]                       <= 32'd0; 
      o_label6_data0[31:00]                       <= 32'd0; 
      o_label7_config[07:00]                      <= 8'd0; 
      o_label7_config[08:08]                      <= 1'd1; 
      o_label7_config[14:09]                      <= 6'd0; 
      o_label7_config[15:15]                      <= 1'd0; 
      o_label7_data7[31:00]                       <= 32'd0; 
      o_label7_data6[31:00]                       <= 32'd0; 
      o_label7_data5[31:00]                       <= 32'd0; 
      o_label7_data4[31:00]                       <= 32'd0; 
      o_label7_data3[31:00]                       <= 32'd0; 
      o_label7_data2[31:00]                       <= 32'd0; 
      o_label7_data1[31:00]                       <= 32'd0; 
      o_label7_data0[31:00]                       <= 32'd0; 
      o_kdf_drbg_ctrl[01:00]                      <= 2'd0; 
      o_kdf_drbg_seed_0_state_key_31_0[31:00]     <= 32'd0; 
      o_kdf_drbg_seed_0_state_key_63_32[31:00]    <= 32'd0; 
      o_kdf_drbg_seed_0_state_key_95_64[31:00]    <= 32'd0; 
      o_kdf_drbg_seed_0_state_key_127_96[31:00]   <= 32'd0; 
      o_kdf_drbg_seed_0_state_key_159_128[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_0_state_key_191_160[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_0_state_key_223_192[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_0_state_key_255_224[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_0_state_value_31_0[31:00]   <= 32'd0; 
      o_kdf_drbg_seed_0_state_value_63_32[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_0_state_value_95_64[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_0_state_value_127_96[31:00] <= 32'd0; 
      o_kdf_drbg_seed_0_reseed_interval_0[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_0_reseed_interval_1[15:00]  <= 16'd0; 
      o_kdf_drbg_seed_1_state_key_31_0[31:00]     <= 32'd0; 
      o_kdf_drbg_seed_1_state_key_63_32[31:00]    <= 32'd0; 
      o_kdf_drbg_seed_1_state_key_95_64[31:00]    <= 32'd0; 
      o_kdf_drbg_seed_1_state_key_127_96[31:00]   <= 32'd0; 
      o_kdf_drbg_seed_1_state_key_159_128[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_1_state_key_191_160[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_1_state_key_223_192[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_1_state_key_255_224[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_1_state_value_31_0[31:00]   <= 32'd0; 
      o_kdf_drbg_seed_1_state_value_63_32[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_1_state_value_95_64[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_1_state_value_127_96[31:00] <= 32'd0; 
      o_kdf_drbg_seed_1_reseed_interval_0[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_1_reseed_interval_1[15:00]  <= 16'd0; 
      o_interrupt_status[00:00]                   <= 1'd0; 
      o_interrupt_status[01:01]                   <= 1'd0; 
      o_interrupt_status[02:02]                   <= 1'd0; 
      o_interrupt_status[03:03]                   <= 1'd0; 
      o_interrupt_status[04:04]                   <= 1'd0; 
      o_interrupt_mask[00:00]                     <= 1'd0; 
      o_interrupt_mask[01:01]                     <= 1'd0; 
      o_interrupt_mask[02:02]                     <= 1'd0; 
      o_interrupt_mask[03:03]                     <= 1'd0; 
      o_interrupt_mask[04:04]                     <= 1'd0; 
      o_engine_sticky_status[00:00]               <= 1'd0; 
      o_engine_sticky_status[01:01]               <= 1'd0; 
      o_engine_sticky_status[02:02]               <= 1'd0; 
      o_engine_sticky_status[03:03]               <= 1'd0; 
      o_engine_sticky_status[04:04]               <= 1'd0; 
      o_engine_sticky_status[05:05]               <= 1'd0; 
      o_engine_sticky_status[06:06]               <= 1'd0; 
      o_engine_sticky_status[07:07]               <= 1'd0; 
      o_bimc_monitor_mask[00:00]                  <= 1'd0; 
      o_bimc_monitor_mask[01:01]                  <= 1'd0; 
      o_bimc_monitor_mask[02:02]                  <= 1'd0; 
      o_bimc_monitor_mask[03:03]                  <= 1'd0; 
      o_bimc_monitor_mask[04:04]                  <= 1'd0; 
      o_bimc_monitor_mask[05:05]                  <= 1'd0; 
      o_bimc_monitor_mask[06:06]                  <= 1'd0; 
      o_bimc_ecc_uncorrectable_error_cnt[31:00]   <= 32'd0; 
      o_bimc_ecc_correctable_error_cnt[31:00]     <= 32'd0; 
      o_bimc_parity_error_cnt[31:00]              <= 32'd0; 
      o_bimc_global_config[00:00]                 <= 1'd1; 
      o_bimc_global_config[01:01]                 <= 1'd0; 
      o_bimc_global_config[02:02]                 <= 1'd0; 
      o_bimc_global_config[03:03]                 <= 1'd0; 
      o_bimc_global_config[04:04]                 <= 1'd0; 
      o_bimc_global_config[05:05]                 <= 1'd0; 
      o_bimc_global_config[31:06]                 <= 26'd0; 
      o_bimc_eccpar_debug[11:00]                  <= 12'd0; 
      o_bimc_eccpar_debug[15:12]                  <= 4'd0; 
      o_bimc_eccpar_debug[17:16]                  <= 2'd0; 
      o_bimc_eccpar_debug[19:18]                  <= 2'd0; 
      o_bimc_eccpar_debug[21:20]                  <= 2'd0; 
      o_bimc_eccpar_debug[22:22]                  <= 1'd0; 
      o_bimc_eccpar_debug[23:23]                  <= 1'd0; 
      o_bimc_eccpar_debug[27:24]                  <= 4'd0; 
      o_bimc_eccpar_debug[28:28]                  <= 1'd0; 
      o_bimc_cmd2[07:00]                          <= 8'd0; 
      o_bimc_cmd2[08:08]                          <= 1'd0; 
      o_bimc_cmd2[09:09]                          <= 1'd0; 
      o_bimc_cmd2[10:10]                          <= 1'd0; 
      o_bimc_cmd1[15:00]                          <= 16'd0; 
      o_bimc_cmd1[27:16]                          <= 12'd0; 
      o_bimc_cmd1[31:28]                          <= 4'd0; 
      o_bimc_cmd0[31:00]                          <= 32'd0; 
      o_bimc_rxcmd2[07:00]                        <= 8'd0; 
      o_bimc_rxcmd2[08:08]                        <= 1'd0; 
      o_bimc_rxrsp2[07:00]                        <= 8'd0; 
      o_bimc_rxrsp2[08:08]                        <= 1'd0; 
      o_bimc_pollrsp2[07:00]                      <= 8'd0; 
      o_bimc_pollrsp2[08:08]                      <= 1'd0; 
      o_bimc_dbgcmd2[07:00]                       <= 8'd0; 
      o_bimc_dbgcmd2[08:08]                       <= 1'd0; 
      o_im_consumed[00:00]                        <= 1'd0; 
      o_im_consumed[01:01]                        <= 1'd0; 
      o_im_consumed[02:02]                        <= 1'd0; 
      o_im_consumed[03:03]                        <= 1'd0; 
      o_im_consumed[04:04]                        <= 1'd0; 
      o_im_consumed[05:05]                        <= 1'd0; 
      o_im_consumed[06:06]                        <= 1'd0; 
      o_im_consumed[07:07]                        <= 1'd0; 
      o_im_consumed[08:08]                        <= 1'd0; 
      o_im_consumed[09:09]                        <= 1'd0; 
      o_im_consumed[10:10]                        <= 1'd0; 
      o_im_consumed[11:11]                        <= 1'd0; 
      o_im_consumed[12:12]                        <= 1'd0; 
      o_im_consumed[13:13]                        <= 1'd0; 
      o_im_consumed[14:14]                        <= 1'd0; 
      o_im_consumed[15:15]                        <= 1'd0; 
      o_tready_override[00:00]                    <= 1'd0; 
      o_tready_override[01:01]                    <= 1'd0; 
      o_tready_override[02:02]                    <= 1'd0; 
      o_tready_override[03:03]                    <= 1'd0; 
      o_tready_override[04:04]                    <= 1'd0; 
      o_tready_override[05:05]                    <= 1'd0; 
      o_tready_override[06:06]                    <= 1'd0; 
      o_tready_override[07:07]                    <= 1'd0; 
      o_tready_override[08:08]                    <= 1'd0; 
      o_regs_sa_ctrl[00:00]                       <= 1'd0; 
      o_regs_sa_ctrl[01:01]                       <= 1'd0; 
      o_regs_sa_ctrl[07:02]                       <= 6'd0; 
      o_regs_sa_ctrl[12:08]                       <= 5'd0; 
      o_regs_sa_ctrl[31:13]                       <= 19'd0; 
      o_sa_snapshot_ia_wdata_part0[17:00]         <= 18'd0; 
      o_sa_snapshot_ia_wdata_part0[31:18]         <= 14'd0; 
      o_sa_snapshot_ia_wdata_part1[31:00]         <= 32'd0; 
      o_sa_snapshot_ia_config[04:00]              <= 5'd0; 
      o_sa_snapshot_ia_config[08:05]              <= 4'd0; 
      o_sa_count_ia_wdata_part0[17:00]            <= 18'd0; 
      o_sa_count_ia_wdata_part0[31:18]            <= 14'd0; 
      o_sa_count_ia_wdata_part1[31:00]            <= 32'd0; 
      o_sa_count_ia_config[04:00]                 <= 5'd0; 
      o_sa_count_ia_config[08:05]                 <= 4'd0; 
      o_cceip_encrypt_kop_fifo_override[00:00]    <= 1'd0; 
      o_cceip_encrypt_kop_fifo_override[01:01]    <= 1'd0; 
      o_cceip_encrypt_kop_fifo_override[02:02]    <= 1'd0; 
      o_cceip_encrypt_kop_fifo_override[03:03]    <= 1'd0; 
      o_cceip_encrypt_kop_fifo_override[04:04]    <= 1'd0; 
      o_cceip_encrypt_kop_fifo_override[05:05]    <= 1'd0; 
      o_cceip_encrypt_kop_fifo_override[06:06]    <= 1'd0; 
      o_cceip_validate_kop_fifo_override[00:00]   <= 1'd0; 
      o_cceip_validate_kop_fifo_override[01:01]   <= 1'd0; 
      o_cceip_validate_kop_fifo_override[02:02]   <= 1'd0; 
      o_cceip_validate_kop_fifo_override[03:03]   <= 1'd0; 
      o_cceip_validate_kop_fifo_override[04:04]   <= 1'd0; 
      o_cceip_validate_kop_fifo_override[05:05]   <= 1'd0; 
      o_cceip_validate_kop_fifo_override[06:06]   <= 1'd0; 
      o_cddip_decrypt_kop_fifo_override[00:00]    <= 1'd0; 
      o_cddip_decrypt_kop_fifo_override[01:01]    <= 1'd0; 
      o_cddip_decrypt_kop_fifo_override[02:02]    <= 1'd0; 
      o_cddip_decrypt_kop_fifo_override[03:03]    <= 1'd0; 
      o_cddip_decrypt_kop_fifo_override[04:04]    <= 1'd0; 
      o_cddip_decrypt_kop_fifo_override[05:05]    <= 1'd0; 
      o_cddip_decrypt_kop_fifo_override[06:06]    <= 1'd0; 
      o_sa_global_ctrl[00:00]                     <= 1'd0; 
      o_sa_global_ctrl[01:01]                     <= 1'd0; 
      o_sa_global_ctrl[31:02]                     <= 30'd0; 
      o_sa_ctrl_ia_wdata_part0[04:00]             <= 5'd0; 
      o_sa_ctrl_ia_wdata_part0[31:05]             <= 27'd0; 
      o_sa_ctrl_ia_config[04:00]                  <= 5'd0; 
      o_sa_ctrl_ia_config[08:05]                  <= 4'd0; 
      o_kdf_test_key_size_config[31:00]           <= 32'd0; 
    end
    else if(i_sw_init) begin
      
      o_spare_config[31:00]                       <= 32'd0; 
      o_cceip0_out_ia_wdata_part0[05:00]          <= 6'd0; 
      o_cceip0_out_ia_wdata_part1[31:00]          <= 32'd0; 
      o_cceip0_out_ia_wdata_part2[31:00]          <= 32'd0; 
      o_cceip0_out_ia_config[08:00]               <= 9'd0; 
      o_cceip0_out_ia_config[12:09]               <= 4'd0; 
      o_cceip0_out_im_config[09:00]               <= 10'd512; 
      o_cceip0_out_im_config[11:10]               <= 2'd3; 
      o_cceip0_out_im_read_done[00:00]            <= 1'd0; 
      o_cceip0_out_im_read_done[01:01]            <= 1'd0; 
      o_cceip1_out_ia_wdata_part0[05:00]          <= 6'd0; 
      o_cceip1_out_ia_wdata_part1[31:00]          <= 32'd0; 
      o_cceip1_out_ia_wdata_part2[31:00]          <= 32'd0; 
      o_cceip1_out_ia_config[08:00]               <= 9'd0; 
      o_cceip1_out_ia_config[12:09]               <= 4'd0; 
      o_cceip1_out_im_config[09:00]               <= 10'd512; 
      o_cceip1_out_im_config[11:10]               <= 2'd3; 
      o_cceip1_out_im_read_done[00:00]            <= 1'd0; 
      o_cceip1_out_im_read_done[01:01]            <= 1'd0; 
      o_cceip2_out_ia_wdata_part0[05:00]          <= 6'd0; 
      o_cceip2_out_ia_wdata_part1[31:00]          <= 32'd0; 
      o_cceip2_out_ia_wdata_part2[31:00]          <= 32'd0; 
      o_cceip2_out_ia_config[08:00]               <= 9'd0; 
      o_cceip2_out_ia_config[12:09]               <= 4'd0; 
      o_cceip2_out_im_config[09:00]               <= 10'd512; 
      o_cceip2_out_im_config[11:10]               <= 2'd3; 
      o_cceip2_out_im_read_done[00:00]            <= 1'd0; 
      o_cceip2_out_im_read_done[01:01]            <= 1'd0; 
      o_cceip3_out_ia_wdata_part0[05:00]          <= 6'd0; 
      o_cceip3_out_ia_wdata_part1[31:00]          <= 32'd0; 
      o_cceip3_out_ia_wdata_part2[31:00]          <= 32'd0; 
      o_cceip3_out_ia_config[08:00]               <= 9'd0; 
      o_cceip3_out_ia_config[12:09]               <= 4'd0; 
      o_cceip3_out_im_config[09:00]               <= 10'd512; 
      o_cceip3_out_im_config[11:10]               <= 2'd3; 
      o_cceip3_out_im_read_done[00:00]            <= 1'd0; 
      o_cceip3_out_im_read_done[01:01]            <= 1'd0; 
      o_cddip0_out_ia_wdata_part0[05:00]          <= 6'd0; 
      o_cddip0_out_ia_wdata_part1[31:00]          <= 32'd0; 
      o_cddip0_out_ia_wdata_part2[31:00]          <= 32'd0; 
      o_cddip0_out_ia_config[08:00]               <= 9'd0; 
      o_cddip0_out_ia_config[12:09]               <= 4'd0; 
      o_cddip0_out_im_config[09:00]               <= 10'd512; 
      o_cddip0_out_im_config[11:10]               <= 2'd3; 
      o_cddip0_out_im_read_done[00:00]            <= 1'd0; 
      o_cddip0_out_im_read_done[01:01]            <= 1'd0; 
      o_cddip1_out_ia_wdata_part0[05:00]          <= 6'd0; 
      o_cddip1_out_ia_wdata_part1[31:00]          <= 32'd0; 
      o_cddip1_out_ia_wdata_part2[31:00]          <= 32'd0; 
      o_cddip1_out_ia_config[08:00]               <= 9'd0; 
      o_cddip1_out_ia_config[12:09]               <= 4'd0; 
      o_cddip1_out_im_config[09:00]               <= 10'd512; 
      o_cddip1_out_im_config[11:10]               <= 2'd3; 
      o_cddip1_out_im_read_done[00:00]            <= 1'd0; 
      o_cddip1_out_im_read_done[01:01]            <= 1'd0; 
      o_cddip2_out_ia_wdata_part0[05:00]          <= 6'd0; 
      o_cddip2_out_ia_wdata_part1[31:00]          <= 32'd0; 
      o_cddip2_out_ia_wdata_part2[31:00]          <= 32'd0; 
      o_cddip2_out_ia_config[08:00]               <= 9'd0; 
      o_cddip2_out_ia_config[12:09]               <= 4'd0; 
      o_cddip2_out_im_config[09:00]               <= 10'd512; 
      o_cddip2_out_im_config[11:10]               <= 2'd3; 
      o_cddip2_out_im_read_done[00:00]            <= 1'd0; 
      o_cddip2_out_im_read_done[01:01]            <= 1'd0; 
      o_cddip3_out_ia_wdata_part0[05:00]          <= 6'd0; 
      o_cddip3_out_ia_wdata_part1[31:00]          <= 32'd0; 
      o_cddip3_out_ia_wdata_part2[31:00]          <= 32'd0; 
      o_cddip3_out_ia_config[08:00]               <= 9'd0; 
      o_cddip3_out_ia_config[12:09]               <= 4'd0; 
      o_cddip3_out_im_config[09:00]               <= 10'd512; 
      o_cddip3_out_im_config[11:10]               <= 2'd3; 
      o_cddip3_out_im_read_done[00:00]            <= 1'd0; 
      o_cddip3_out_im_read_done[01:01]            <= 1'd0; 
      o_ckv_ia_wdata_part0[31:00]                 <= 32'd0; 
      o_ckv_ia_wdata_part1[31:00]                 <= 32'd0; 
      o_ckv_ia_config[14:00]                      <= 15'd0; 
      o_ckv_ia_config[18:15]                      <= 4'd0; 
      o_kim_ia_wdata_part0[14:00]                 <= 15'd0; 
      o_kim_ia_wdata_part0[16:15]                 <= 2'd0; 
      o_kim_ia_wdata_part0[19:17]                 <= 3'd0; 
      o_kim_ia_wdata_part0[20:20]                 <= 1'd0; 
      o_kim_ia_wdata_part1[00:00]                 <= 1'd0; 
      o_kim_ia_wdata_part1[12:01]                 <= 12'd0; 
      o_kim_ia_wdata_part1[16:13]                 <= 4'd0; 
      o_kim_ia_config[13:00]                      <= 14'd0; 
      o_kim_ia_config[17:14]                      <= 4'd0; 
      o_label0_config[07:00]                      <= 8'd0; 
      o_label0_config[08:08]                      <= 1'd1; 
      o_label0_config[14:09]                      <= 6'd0; 
      o_label0_config[15:15]                      <= 1'd0; 
      o_label0_data7[31:00]                       <= 32'd0; 
      o_label0_data6[31:00]                       <= 32'd0; 
      o_label0_data5[31:00]                       <= 32'd0; 
      o_label0_data4[31:00]                       <= 32'd0; 
      o_label0_data3[31:00]                       <= 32'd0; 
      o_label0_data2[31:00]                       <= 32'd0; 
      o_label0_data1[31:00]                       <= 32'd0; 
      o_label0_data0[31:00]                       <= 32'd0; 
      o_label1_config[07:00]                      <= 8'd0; 
      o_label1_config[08:08]                      <= 1'd1; 
      o_label1_config[14:09]                      <= 6'd0; 
      o_label1_config[15:15]                      <= 1'd0; 
      o_label1_data7[31:00]                       <= 32'd0; 
      o_label1_data6[31:00]                       <= 32'd0; 
      o_label1_data5[31:00]                       <= 32'd0; 
      o_label1_data4[31:00]                       <= 32'd0; 
      o_label1_data3[31:00]                       <= 32'd0; 
      o_label1_data2[31:00]                       <= 32'd0; 
      o_label1_data1[31:00]                       <= 32'd0; 
      o_label1_data0[31:00]                       <= 32'd0; 
      o_label2_config[07:00]                      <= 8'd0; 
      o_label2_config[08:08]                      <= 1'd1; 
      o_label2_config[14:09]                      <= 6'd0; 
      o_label2_config[15:15]                      <= 1'd0; 
      o_label2_data7[31:00]                       <= 32'd0; 
      o_label2_data6[31:00]                       <= 32'd0; 
      o_label2_data5[31:00]                       <= 32'd0; 
      o_label2_data4[31:00]                       <= 32'd0; 
      o_label2_data3[31:00]                       <= 32'd0; 
      o_label2_data2[31:00]                       <= 32'd0; 
      o_label2_data1[31:00]                       <= 32'd0; 
      o_label2_data0[31:00]                       <= 32'd0; 
      o_label3_config[07:00]                      <= 8'd0; 
      o_label3_config[08:08]                      <= 1'd1; 
      o_label3_config[14:09]                      <= 6'd0; 
      o_label3_config[15:15]                      <= 1'd0; 
      o_label3_data7[31:00]                       <= 32'd0; 
      o_label3_data6[31:00]                       <= 32'd0; 
      o_label3_data5[31:00]                       <= 32'd0; 
      o_label3_data4[31:00]                       <= 32'd0; 
      o_label3_data3[31:00]                       <= 32'd0; 
      o_label3_data2[31:00]                       <= 32'd0; 
      o_label3_data1[31:00]                       <= 32'd0; 
      o_label3_data0[31:00]                       <= 32'd0; 
      o_label4_config[07:00]                      <= 8'd0; 
      o_label4_config[08:08]                      <= 1'd1; 
      o_label4_config[14:09]                      <= 6'd0; 
      o_label4_config[15:15]                      <= 1'd0; 
      o_label4_data7[31:00]                       <= 32'd0; 
      o_label4_data6[31:00]                       <= 32'd0; 
      o_label4_data5[31:00]                       <= 32'd0; 
      o_label4_data4[31:00]                       <= 32'd0; 
      o_label4_data3[31:00]                       <= 32'd0; 
      o_label4_data2[31:00]                       <= 32'd0; 
      o_label4_data1[31:00]                       <= 32'd0; 
      o_label4_data0[31:00]                       <= 32'd0; 
      o_label5_config[07:00]                      <= 8'd0; 
      o_label5_config[08:08]                      <= 1'd1; 
      o_label5_config[14:09]                      <= 6'd0; 
      o_label5_config[15:15]                      <= 1'd0; 
      o_label5_data7[31:00]                       <= 32'd0; 
      o_label5_data6[31:00]                       <= 32'd0; 
      o_label5_data5[31:00]                       <= 32'd0; 
      o_label5_data4[31:00]                       <= 32'd0; 
      o_label5_data3[31:00]                       <= 32'd0; 
      o_label5_data2[31:00]                       <= 32'd0; 
      o_label5_data1[31:00]                       <= 32'd0; 
      o_label5_data0[31:00]                       <= 32'd0; 
      o_label6_config[07:00]                      <= 8'd0; 
      o_label6_config[08:08]                      <= 1'd1; 
      o_label6_config[14:09]                      <= 6'd0; 
      o_label6_config[15:15]                      <= 1'd0; 
      o_label6_data7[31:00]                       <= 32'd0; 
      o_label6_data6[31:00]                       <= 32'd0; 
      o_label6_data5[31:00]                       <= 32'd0; 
      o_label6_data4[31:00]                       <= 32'd0; 
      o_label6_data3[31:00]                       <= 32'd0; 
      o_label6_data2[31:00]                       <= 32'd0; 
      o_label6_data1[31:00]                       <= 32'd0; 
      o_label6_data0[31:00]                       <= 32'd0; 
      o_label7_config[07:00]                      <= 8'd0; 
      o_label7_config[08:08]                      <= 1'd1; 
      o_label7_config[14:09]                      <= 6'd0; 
      o_label7_config[15:15]                      <= 1'd0; 
      o_label7_data7[31:00]                       <= 32'd0; 
      o_label7_data6[31:00]                       <= 32'd0; 
      o_label7_data5[31:00]                       <= 32'd0; 
      o_label7_data4[31:00]                       <= 32'd0; 
      o_label7_data3[31:00]                       <= 32'd0; 
      o_label7_data2[31:00]                       <= 32'd0; 
      o_label7_data1[31:00]                       <= 32'd0; 
      o_label7_data0[31:00]                       <= 32'd0; 
      o_kdf_drbg_ctrl[01:00]                      <= 2'd0; 
      o_kdf_drbg_seed_0_state_key_31_0[31:00]     <= 32'd0; 
      o_kdf_drbg_seed_0_state_key_63_32[31:00]    <= 32'd0; 
      o_kdf_drbg_seed_0_state_key_95_64[31:00]    <= 32'd0; 
      o_kdf_drbg_seed_0_state_key_127_96[31:00]   <= 32'd0; 
      o_kdf_drbg_seed_0_state_key_159_128[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_0_state_key_191_160[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_0_state_key_223_192[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_0_state_key_255_224[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_0_state_value_31_0[31:00]   <= 32'd0; 
      o_kdf_drbg_seed_0_state_value_63_32[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_0_state_value_95_64[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_0_state_value_127_96[31:00] <= 32'd0; 
      o_kdf_drbg_seed_0_reseed_interval_0[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_0_reseed_interval_1[15:00]  <= 16'd0; 
      o_kdf_drbg_seed_1_state_key_31_0[31:00]     <= 32'd0; 
      o_kdf_drbg_seed_1_state_key_63_32[31:00]    <= 32'd0; 
      o_kdf_drbg_seed_1_state_key_95_64[31:00]    <= 32'd0; 
      o_kdf_drbg_seed_1_state_key_127_96[31:00]   <= 32'd0; 
      o_kdf_drbg_seed_1_state_key_159_128[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_1_state_key_191_160[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_1_state_key_223_192[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_1_state_key_255_224[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_1_state_value_31_0[31:00]   <= 32'd0; 
      o_kdf_drbg_seed_1_state_value_63_32[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_1_state_value_95_64[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_1_state_value_127_96[31:00] <= 32'd0; 
      o_kdf_drbg_seed_1_reseed_interval_0[31:00]  <= 32'd0; 
      o_kdf_drbg_seed_1_reseed_interval_1[15:00]  <= 16'd0; 
      o_interrupt_status[00:00]                   <= 1'd0; 
      o_interrupt_status[01:01]                   <= 1'd0; 
      o_interrupt_status[02:02]                   <= 1'd0; 
      o_interrupt_status[03:03]                   <= 1'd0; 
      o_interrupt_status[04:04]                   <= 1'd0; 
      o_interrupt_mask[00:00]                     <= 1'd0; 
      o_interrupt_mask[01:01]                     <= 1'd0; 
      o_interrupt_mask[02:02]                     <= 1'd0; 
      o_interrupt_mask[03:03]                     <= 1'd0; 
      o_interrupt_mask[04:04]                     <= 1'd0; 
      o_engine_sticky_status[00:00]               <= 1'd0; 
      o_engine_sticky_status[01:01]               <= 1'd0; 
      o_engine_sticky_status[02:02]               <= 1'd0; 
      o_engine_sticky_status[03:03]               <= 1'd0; 
      o_engine_sticky_status[04:04]               <= 1'd0; 
      o_engine_sticky_status[05:05]               <= 1'd0; 
      o_engine_sticky_status[06:06]               <= 1'd0; 
      o_engine_sticky_status[07:07]               <= 1'd0; 
      o_bimc_monitor_mask[00:00]                  <= 1'd0; 
      o_bimc_monitor_mask[01:01]                  <= 1'd0; 
      o_bimc_monitor_mask[02:02]                  <= 1'd0; 
      o_bimc_monitor_mask[03:03]                  <= 1'd0; 
      o_bimc_monitor_mask[04:04]                  <= 1'd0; 
      o_bimc_monitor_mask[05:05]                  <= 1'd0; 
      o_bimc_monitor_mask[06:06]                  <= 1'd0; 
      o_bimc_ecc_uncorrectable_error_cnt[31:00]   <= 32'd0; 
      o_bimc_ecc_correctable_error_cnt[31:00]     <= 32'd0; 
      o_bimc_parity_error_cnt[31:00]              <= 32'd0; 
      o_bimc_global_config[00:00]                 <= 1'd1; 
      o_bimc_global_config[01:01]                 <= 1'd0; 
      o_bimc_global_config[02:02]                 <= 1'd0; 
      o_bimc_global_config[03:03]                 <= 1'd0; 
      o_bimc_global_config[04:04]                 <= 1'd0; 
      o_bimc_global_config[05:05]                 <= 1'd0; 
      o_bimc_global_config[31:06]                 <= 26'd0; 
      o_bimc_eccpar_debug[11:00]                  <= 12'd0; 
      o_bimc_eccpar_debug[15:12]                  <= 4'd0; 
      o_bimc_eccpar_debug[17:16]                  <= 2'd0; 
      o_bimc_eccpar_debug[19:18]                  <= 2'd0; 
      o_bimc_eccpar_debug[21:20]                  <= 2'd0; 
      o_bimc_eccpar_debug[22:22]                  <= 1'd0; 
      o_bimc_eccpar_debug[23:23]                  <= 1'd0; 
      o_bimc_eccpar_debug[27:24]                  <= 4'd0; 
      o_bimc_eccpar_debug[28:28]                  <= 1'd0; 
      o_bimc_cmd2[07:00]                          <= 8'd0; 
      o_bimc_cmd2[08:08]                          <= 1'd0; 
      o_bimc_cmd2[09:09]                          <= 1'd0; 
      o_bimc_cmd2[10:10]                          <= 1'd0; 
      o_bimc_cmd1[15:00]                          <= 16'd0; 
      o_bimc_cmd1[27:16]                          <= 12'd0; 
      o_bimc_cmd1[31:28]                          <= 4'd0; 
      o_bimc_cmd0[31:00]                          <= 32'd0; 
      o_bimc_rxcmd2[07:00]                        <= 8'd0; 
      o_bimc_rxcmd2[08:08]                        <= 1'd0; 
      o_bimc_rxrsp2[07:00]                        <= 8'd0; 
      o_bimc_rxrsp2[08:08]                        <= 1'd0; 
      o_bimc_pollrsp2[07:00]                      <= 8'd0; 
      o_bimc_pollrsp2[08:08]                      <= 1'd0; 
      o_bimc_dbgcmd2[07:00]                       <= 8'd0; 
      o_bimc_dbgcmd2[08:08]                       <= 1'd0; 
      o_im_consumed[00:00]                        <= 1'd0; 
      o_im_consumed[01:01]                        <= 1'd0; 
      o_im_consumed[02:02]                        <= 1'd0; 
      o_im_consumed[03:03]                        <= 1'd0; 
      o_im_consumed[04:04]                        <= 1'd0; 
      o_im_consumed[05:05]                        <= 1'd0; 
      o_im_consumed[06:06]                        <= 1'd0; 
      o_im_consumed[07:07]                        <= 1'd0; 
      o_im_consumed[08:08]                        <= 1'd0; 
      o_im_consumed[09:09]                        <= 1'd0; 
      o_im_consumed[10:10]                        <= 1'd0; 
      o_im_consumed[11:11]                        <= 1'd0; 
      o_im_consumed[12:12]                        <= 1'd0; 
      o_im_consumed[13:13]                        <= 1'd0; 
      o_im_consumed[14:14]                        <= 1'd0; 
      o_im_consumed[15:15]                        <= 1'd0; 
      o_tready_override[00:00]                    <= 1'd0; 
      o_tready_override[01:01]                    <= 1'd0; 
      o_tready_override[02:02]                    <= 1'd0; 
      o_tready_override[03:03]                    <= 1'd0; 
      o_tready_override[04:04]                    <= 1'd0; 
      o_tready_override[05:05]                    <= 1'd0; 
      o_tready_override[06:06]                    <= 1'd0; 
      o_tready_override[07:07]                    <= 1'd0; 
      o_tready_override[08:08]                    <= 1'd0; 
      o_regs_sa_ctrl[00:00]                       <= 1'd0; 
      o_regs_sa_ctrl[01:01]                       <= 1'd0; 
      o_regs_sa_ctrl[07:02]                       <= 6'd0; 
      o_regs_sa_ctrl[12:08]                       <= 5'd0; 
      o_regs_sa_ctrl[31:13]                       <= 19'd0; 
      o_sa_snapshot_ia_wdata_part0[17:00]         <= 18'd0; 
      o_sa_snapshot_ia_wdata_part0[31:18]         <= 14'd0; 
      o_sa_snapshot_ia_wdata_part1[31:00]         <= 32'd0; 
      o_sa_snapshot_ia_config[04:00]              <= 5'd0; 
      o_sa_snapshot_ia_config[08:05]              <= 4'd0; 
      o_sa_count_ia_wdata_part0[17:00]            <= 18'd0; 
      o_sa_count_ia_wdata_part0[31:18]            <= 14'd0; 
      o_sa_count_ia_wdata_part1[31:00]            <= 32'd0; 
      o_sa_count_ia_config[04:00]                 <= 5'd0; 
      o_sa_count_ia_config[08:05]                 <= 4'd0; 
      o_cceip_encrypt_kop_fifo_override[00:00]    <= 1'd0; 
      o_cceip_encrypt_kop_fifo_override[01:01]    <= 1'd0; 
      o_cceip_encrypt_kop_fifo_override[02:02]    <= 1'd0; 
      o_cceip_encrypt_kop_fifo_override[03:03]    <= 1'd0; 
      o_cceip_encrypt_kop_fifo_override[04:04]    <= 1'd0; 
      o_cceip_encrypt_kop_fifo_override[05:05]    <= 1'd0; 
      o_cceip_encrypt_kop_fifo_override[06:06]    <= 1'd0; 
      o_cceip_validate_kop_fifo_override[00:00]   <= 1'd0; 
      o_cceip_validate_kop_fifo_override[01:01]   <= 1'd0; 
      o_cceip_validate_kop_fifo_override[02:02]   <= 1'd0; 
      o_cceip_validate_kop_fifo_override[03:03]   <= 1'd0; 
      o_cceip_validate_kop_fifo_override[04:04]   <= 1'd0; 
      o_cceip_validate_kop_fifo_override[05:05]   <= 1'd0; 
      o_cceip_validate_kop_fifo_override[06:06]   <= 1'd0; 
      o_cddip_decrypt_kop_fifo_override[00:00]    <= 1'd0; 
      o_cddip_decrypt_kop_fifo_override[01:01]    <= 1'd0; 
      o_cddip_decrypt_kop_fifo_override[02:02]    <= 1'd0; 
      o_cddip_decrypt_kop_fifo_override[03:03]    <= 1'd0; 
      o_cddip_decrypt_kop_fifo_override[04:04]    <= 1'd0; 
      o_cddip_decrypt_kop_fifo_override[05:05]    <= 1'd0; 
      o_cddip_decrypt_kop_fifo_override[06:06]    <= 1'd0; 
      o_sa_global_ctrl[00:00]                     <= 1'd0; 
      o_sa_global_ctrl[01:01]                     <= 1'd0; 
      o_sa_global_ctrl[31:02]                     <= 30'd0; 
      o_sa_ctrl_ia_wdata_part0[04:00]             <= 5'd0; 
      o_sa_ctrl_ia_wdata_part0[31:05]             <= 27'd0; 
      o_sa_ctrl_ia_config[04:00]                  <= 5'd0; 
      o_sa_ctrl_ia_config[08:05]                  <= 4'd0; 
      o_kdf_test_key_size_config[31:00]           <= 32'd0; 
    end
    else begin
      if(w_load_spare_config)                       o_spare_config[31:00]                       <= f32_data[31:00]; 
      if(w_load_cceip0_out_ia_wdata_part0)          o_cceip0_out_ia_wdata_part0[05:00]          <= f32_data[05:00]; 
      if(w_load_cceip0_out_ia_wdata_part1)          o_cceip0_out_ia_wdata_part1[31:00]          <= f32_data[31:00]; 
      if(w_load_cceip0_out_ia_wdata_part2)          o_cceip0_out_ia_wdata_part2[31:00]          <= f32_data[31:00]; 
      if(w_load_cceip0_out_ia_config)               o_cceip0_out_ia_config[08:00]               <= f32_data[08:00]; 
      if(w_load_cceip0_out_ia_config)               o_cceip0_out_ia_config[12:09]               <= f32_data[31:28]; 
      if(w_load_cceip0_out_im_config)               o_cceip0_out_im_config[09:00]               <= f32_data[09:00]; 
      if(w_load_cceip0_out_im_config)               o_cceip0_out_im_config[11:10]               <= f32_data[31:30]; 
      if(w_load_cceip0_out_im_read_done)            o_cceip0_out_im_read_done[00:00]            <= f32_data[30:30]; 
      if(w_load_cceip0_out_im_read_done)            o_cceip0_out_im_read_done[01:01]            <= f32_data[31:31]; 
      if(w_load_cceip1_out_ia_wdata_part0)          o_cceip1_out_ia_wdata_part0[05:00]          <= f32_data[05:00]; 
      if(w_load_cceip1_out_ia_wdata_part1)          o_cceip1_out_ia_wdata_part1[31:00]          <= f32_data[31:00]; 
      if(w_load_cceip1_out_ia_wdata_part2)          o_cceip1_out_ia_wdata_part2[31:00]          <= f32_data[31:00]; 
      if(w_load_cceip1_out_ia_config)               o_cceip1_out_ia_config[08:00]               <= f32_data[08:00]; 
      if(w_load_cceip1_out_ia_config)               o_cceip1_out_ia_config[12:09]               <= f32_data[31:28]; 
      if(w_load_cceip1_out_im_config)               o_cceip1_out_im_config[09:00]               <= f32_data[09:00]; 
      if(w_load_cceip1_out_im_config)               o_cceip1_out_im_config[11:10]               <= f32_data[31:30]; 
      if(w_load_cceip1_out_im_read_done)            o_cceip1_out_im_read_done[00:00]            <= f32_data[30:30]; 
      if(w_load_cceip1_out_im_read_done)            o_cceip1_out_im_read_done[01:01]            <= f32_data[31:31]; 
      if(w_load_cceip2_out_ia_wdata_part0)          o_cceip2_out_ia_wdata_part0[05:00]          <= f32_data[05:00]; 
      if(w_load_cceip2_out_ia_wdata_part1)          o_cceip2_out_ia_wdata_part1[31:00]          <= f32_data[31:00]; 
      if(w_load_cceip2_out_ia_wdata_part2)          o_cceip2_out_ia_wdata_part2[31:00]          <= f32_data[31:00]; 
      if(w_load_cceip2_out_ia_config)               o_cceip2_out_ia_config[08:00]               <= f32_data[08:00]; 
      if(w_load_cceip2_out_ia_config)               o_cceip2_out_ia_config[12:09]               <= f32_data[31:28]; 
      if(w_load_cceip2_out_im_config)               o_cceip2_out_im_config[09:00]               <= f32_data[09:00]; 
      if(w_load_cceip2_out_im_config)               o_cceip2_out_im_config[11:10]               <= f32_data[31:30]; 
      if(w_load_cceip2_out_im_read_done)            o_cceip2_out_im_read_done[00:00]            <= f32_data[30:30]; 
      if(w_load_cceip2_out_im_read_done)            o_cceip2_out_im_read_done[01:01]            <= f32_data[31:31]; 
      if(w_load_cceip3_out_ia_wdata_part0)          o_cceip3_out_ia_wdata_part0[05:00]          <= f32_data[05:00]; 
      if(w_load_cceip3_out_ia_wdata_part1)          o_cceip3_out_ia_wdata_part1[31:00]          <= f32_data[31:00]; 
      if(w_load_cceip3_out_ia_wdata_part2)          o_cceip3_out_ia_wdata_part2[31:00]          <= f32_data[31:00]; 
      if(w_load_cceip3_out_ia_config)               o_cceip3_out_ia_config[08:00]               <= f32_data[08:00]; 
      if(w_load_cceip3_out_ia_config)               o_cceip3_out_ia_config[12:09]               <= f32_data[31:28]; 
      if(w_load_cceip3_out_im_config)               o_cceip3_out_im_config[09:00]               <= f32_data[09:00]; 
      if(w_load_cceip3_out_im_config)               o_cceip3_out_im_config[11:10]               <= f32_data[31:30]; 
      if(w_load_cceip3_out_im_read_done)            o_cceip3_out_im_read_done[00:00]            <= f32_data[30:30]; 
      if(w_load_cceip3_out_im_read_done)            o_cceip3_out_im_read_done[01:01]            <= f32_data[31:31]; 
      if(w_load_cddip0_out_ia_wdata_part0)          o_cddip0_out_ia_wdata_part0[05:00]          <= f32_data[05:00]; 
      if(w_load_cddip0_out_ia_wdata_part1)          o_cddip0_out_ia_wdata_part1[31:00]          <= f32_data[31:00]; 
      if(w_load_cddip0_out_ia_wdata_part2)          o_cddip0_out_ia_wdata_part2[31:00]          <= f32_data[31:00]; 
      if(w_load_cddip0_out_ia_config)               o_cddip0_out_ia_config[08:00]               <= f32_data[08:00]; 
      if(w_load_cddip0_out_ia_config)               o_cddip0_out_ia_config[12:09]               <= f32_data[31:28]; 
      if(w_load_cddip0_out_im_config)               o_cddip0_out_im_config[09:00]               <= f32_data[09:00]; 
      if(w_load_cddip0_out_im_config)               o_cddip0_out_im_config[11:10]               <= f32_data[31:30]; 
      if(w_load_cddip0_out_im_read_done)            o_cddip0_out_im_read_done[00:00]            <= f32_data[30:30]; 
      if(w_load_cddip0_out_im_read_done)            o_cddip0_out_im_read_done[01:01]            <= f32_data[31:31]; 
      if(w_load_cddip1_out_ia_wdata_part0)          o_cddip1_out_ia_wdata_part0[05:00]          <= f32_data[05:00]; 
      if(w_load_cddip1_out_ia_wdata_part1)          o_cddip1_out_ia_wdata_part1[31:00]          <= f32_data[31:00]; 
      if(w_load_cddip1_out_ia_wdata_part2)          o_cddip1_out_ia_wdata_part2[31:00]          <= f32_data[31:00]; 
      if(w_load_cddip1_out_ia_config)               o_cddip1_out_ia_config[08:00]               <= f32_data[08:00]; 
      if(w_load_cddip1_out_ia_config)               o_cddip1_out_ia_config[12:09]               <= f32_data[31:28]; 
      if(w_load_cddip1_out_im_config)               o_cddip1_out_im_config[09:00]               <= f32_data[09:00]; 
      if(w_load_cddip1_out_im_config)               o_cddip1_out_im_config[11:10]               <= f32_data[31:30]; 
      if(w_load_cddip1_out_im_read_done)            o_cddip1_out_im_read_done[00:00]            <= f32_data[30:30]; 
      if(w_load_cddip1_out_im_read_done)            o_cddip1_out_im_read_done[01:01]            <= f32_data[31:31]; 
      if(w_load_cddip2_out_ia_wdata_part0)          o_cddip2_out_ia_wdata_part0[05:00]          <= f32_data[05:00]; 
      if(w_load_cddip2_out_ia_wdata_part1)          o_cddip2_out_ia_wdata_part1[31:00]          <= f32_data[31:00]; 
      if(w_load_cddip2_out_ia_wdata_part2)          o_cddip2_out_ia_wdata_part2[31:00]          <= f32_data[31:00]; 
      if(w_load_cddip2_out_ia_config)               o_cddip2_out_ia_config[08:00]               <= f32_data[08:00]; 
      if(w_load_cddip2_out_ia_config)               o_cddip2_out_ia_config[12:09]               <= f32_data[31:28]; 
      if(w_load_cddip2_out_im_config)               o_cddip2_out_im_config[09:00]               <= f32_data[09:00]; 
      if(w_load_cddip2_out_im_config)               o_cddip2_out_im_config[11:10]               <= f32_data[31:30]; 
      if(w_load_cddip2_out_im_read_done)            o_cddip2_out_im_read_done[00:00]            <= f32_data[30:30]; 
      if(w_load_cddip2_out_im_read_done)            o_cddip2_out_im_read_done[01:01]            <= f32_data[31:31]; 
      if(w_load_cddip3_out_ia_wdata_part0)          o_cddip3_out_ia_wdata_part0[05:00]          <= f32_data[05:00]; 
      if(w_load_cddip3_out_ia_wdata_part1)          o_cddip3_out_ia_wdata_part1[31:00]          <= f32_data[31:00]; 
      if(w_load_cddip3_out_ia_wdata_part2)          o_cddip3_out_ia_wdata_part2[31:00]          <= f32_data[31:00]; 
      if(w_load_cddip3_out_ia_config)               o_cddip3_out_ia_config[08:00]               <= f32_data[08:00]; 
      if(w_load_cddip3_out_ia_config)               o_cddip3_out_ia_config[12:09]               <= f32_data[31:28]; 
      if(w_load_cddip3_out_im_config)               o_cddip3_out_im_config[09:00]               <= f32_data[09:00]; 
      if(w_load_cddip3_out_im_config)               o_cddip3_out_im_config[11:10]               <= f32_data[31:30]; 
      if(w_load_cddip3_out_im_read_done)            o_cddip3_out_im_read_done[00:00]            <= f32_data[30:30]; 
      if(w_load_cddip3_out_im_read_done)            o_cddip3_out_im_read_done[01:01]            <= f32_data[31:31]; 
      if(w_load_ckv_ia_wdata_part0)                 o_ckv_ia_wdata_part0[31:00]                 <= f32_data[31:00]; 
      if(w_load_ckv_ia_wdata_part1)                 o_ckv_ia_wdata_part1[31:00]                 <= f32_data[31:00]; 
      if(w_load_ckv_ia_config)                      o_ckv_ia_config[14:00]                      <= f32_data[14:00]; 
      if(w_load_ckv_ia_config)                      o_ckv_ia_config[18:15]                      <= f32_data[31:28]; 
      if(w_load_kim_ia_wdata_part0)                 o_kim_ia_wdata_part0[14:00]                 <= f32_data[14:00]; 
      if(w_load_kim_ia_wdata_part0)                 o_kim_ia_wdata_part0[16:15]                 <= f32_data[27:26]; 
      if(w_load_kim_ia_wdata_part0)                 o_kim_ia_wdata_part0[19:17]                 <= f32_data[30:28]; 
      if(w_load_kim_ia_wdata_part0)                 o_kim_ia_wdata_part0[20:20]                 <= f32_data[31:31]; 
      if(w_load_kim_ia_wdata_part1)                 o_kim_ia_wdata_part1[00:00]                 <= f32_data[00:00]; 
      if(w_load_kim_ia_wdata_part1)                 o_kim_ia_wdata_part1[12:01]                 <= f32_data[12:01]; 
      if(w_load_kim_ia_wdata_part1)                 o_kim_ia_wdata_part1[16:13]                 <= f32_data[31:28]; 
      if(w_load_kim_ia_config)                      o_kim_ia_config[13:00]                      <= f32_data[13:00]; 
      if(w_load_kim_ia_config)                      o_kim_ia_config[17:14]                      <= f32_data[31:28]; 
      if(w_load_label0_config)                      o_label0_config[07:00]                      <= f32_data[07:00]; 
      if(w_load_label0_config)                      o_label0_config[08:08]                      <= f32_data[08:08]; 
      if(w_load_label0_config)                      o_label0_config[14:09]                      <= f32_data[30:25]; 
      if(w_load_label0_config)                      o_label0_config[15:15]                      <= f32_data[31:31]; 
      if(w_load_label0_data7)                       o_label0_data7[31:00]                       <= f32_data[31:00]; 
      if(w_load_label0_data6)                       o_label0_data6[31:00]                       <= f32_data[31:00]; 
      if(w_load_label0_data5)                       o_label0_data5[31:00]                       <= f32_data[31:00]; 
      if(w_load_label0_data4)                       o_label0_data4[31:00]                       <= f32_data[31:00]; 
      if(w_load_label0_data3)                       o_label0_data3[31:00]                       <= f32_data[31:00]; 
      if(w_load_label0_data2)                       o_label0_data2[31:00]                       <= f32_data[31:00]; 
      if(w_load_label0_data1)                       o_label0_data1[31:00]                       <= f32_data[31:00]; 
      if(w_load_label0_data0)                       o_label0_data0[31:00]                       <= f32_data[31:00]; 
      if(w_load_label1_config)                      o_label1_config[07:00]                      <= f32_data[07:00]; 
      if(w_load_label1_config)                      o_label1_config[08:08]                      <= f32_data[08:08]; 
      if(w_load_label1_config)                      o_label1_config[14:09]                      <= f32_data[30:25]; 
      if(w_load_label1_config)                      o_label1_config[15:15]                      <= f32_data[31:31]; 
      if(w_load_label1_data7)                       o_label1_data7[31:00]                       <= f32_data[31:00]; 
      if(w_load_label1_data6)                       o_label1_data6[31:00]                       <= f32_data[31:00]; 
      if(w_load_label1_data5)                       o_label1_data5[31:00]                       <= f32_data[31:00]; 
      if(w_load_label1_data4)                       o_label1_data4[31:00]                       <= f32_data[31:00]; 
      if(w_load_label1_data3)                       o_label1_data3[31:00]                       <= f32_data[31:00]; 
      if(w_load_label1_data2)                       o_label1_data2[31:00]                       <= f32_data[31:00]; 
      if(w_load_label1_data1)                       o_label1_data1[31:00]                       <= f32_data[31:00]; 
      if(w_load_label1_data0)                       o_label1_data0[31:00]                       <= f32_data[31:00]; 
      if(w_load_label2_config)                      o_label2_config[07:00]                      <= f32_data[07:00]; 
      if(w_load_label2_config)                      o_label2_config[08:08]                      <= f32_data[08:08]; 
      if(w_load_label2_config)                      o_label2_config[14:09]                      <= f32_data[30:25]; 
      if(w_load_label2_config)                      o_label2_config[15:15]                      <= f32_data[31:31]; 
      if(w_load_label2_data7)                       o_label2_data7[31:00]                       <= f32_data[31:00]; 
      if(w_load_label2_data6)                       o_label2_data6[31:00]                       <= f32_data[31:00]; 
      if(w_load_label2_data5)                       o_label2_data5[31:00]                       <= f32_data[31:00]; 
      if(w_load_label2_data4)                       o_label2_data4[31:00]                       <= f32_data[31:00]; 
      if(w_load_label2_data3)                       o_label2_data3[31:00]                       <= f32_data[31:00]; 
      if(w_load_label2_data2)                       o_label2_data2[31:00]                       <= f32_data[31:00]; 
      if(w_load_label2_data1)                       o_label2_data1[31:00]                       <= f32_data[31:00]; 
      if(w_load_label2_data0)                       o_label2_data0[31:00]                       <= f32_data[31:00]; 
      if(w_load_label3_config)                      o_label3_config[07:00]                      <= f32_data[07:00]; 
      if(w_load_label3_config)                      o_label3_config[08:08]                      <= f32_data[08:08]; 
      if(w_load_label3_config)                      o_label3_config[14:09]                      <= f32_data[30:25]; 
      if(w_load_label3_config)                      o_label3_config[15:15]                      <= f32_data[31:31]; 
      if(w_load_label3_data7)                       o_label3_data7[31:00]                       <= f32_data[31:00]; 
      if(w_load_label3_data6)                       o_label3_data6[31:00]                       <= f32_data[31:00]; 
      if(w_load_label3_data5)                       o_label3_data5[31:00]                       <= f32_data[31:00]; 
      if(w_load_label3_data4)                       o_label3_data4[31:00]                       <= f32_data[31:00]; 
      if(w_load_label3_data3)                       o_label3_data3[31:00]                       <= f32_data[31:00]; 
      if(w_load_label3_data2)                       o_label3_data2[31:00]                       <= f32_data[31:00]; 
      if(w_load_label3_data1)                       o_label3_data1[31:00]                       <= f32_data[31:00]; 
      if(w_load_label3_data0)                       o_label3_data0[31:00]                       <= f32_data[31:00]; 
      if(w_load_label4_config)                      o_label4_config[07:00]                      <= f32_data[07:00]; 
      if(w_load_label4_config)                      o_label4_config[08:08]                      <= f32_data[08:08]; 
      if(w_load_label4_config)                      o_label4_config[14:09]                      <= f32_data[30:25]; 
      if(w_load_label4_config)                      o_label4_config[15:15]                      <= f32_data[31:31]; 
      if(w_load_label4_data7)                       o_label4_data7[31:00]                       <= f32_data[31:00]; 
      if(w_load_label4_data6)                       o_label4_data6[31:00]                       <= f32_data[31:00]; 
      if(w_load_label4_data5)                       o_label4_data5[31:00]                       <= f32_data[31:00]; 
      if(w_load_label4_data4)                       o_label4_data4[31:00]                       <= f32_data[31:00]; 
      if(w_load_label4_data3)                       o_label4_data3[31:00]                       <= f32_data[31:00]; 
      if(w_load_label4_data2)                       o_label4_data2[31:00]                       <= f32_data[31:00]; 
      if(w_load_label4_data1)                       o_label4_data1[31:00]                       <= f32_data[31:00]; 
      if(w_load_label4_data0)                       o_label4_data0[31:00]                       <= f32_data[31:00]; 
      if(w_load_label5_config)                      o_label5_config[07:00]                      <= f32_data[07:00]; 
      if(w_load_label5_config)                      o_label5_config[08:08]                      <= f32_data[08:08]; 
      if(w_load_label5_config)                      o_label5_config[14:09]                      <= f32_data[30:25]; 
      if(w_load_label5_config)                      o_label5_config[15:15]                      <= f32_data[31:31]; 
      if(w_load_label5_data7)                       o_label5_data7[31:00]                       <= f32_data[31:00]; 
      if(w_load_label5_data6)                       o_label5_data6[31:00]                       <= f32_data[31:00]; 
      if(w_load_label5_data5)                       o_label5_data5[31:00]                       <= f32_data[31:00]; 
      if(w_load_label5_data4)                       o_label5_data4[31:00]                       <= f32_data[31:00]; 
      if(w_load_label5_data3)                       o_label5_data3[31:00]                       <= f32_data[31:00]; 
      if(w_load_label5_data2)                       o_label5_data2[31:00]                       <= f32_data[31:00]; 
      if(w_load_label5_data1)                       o_label5_data1[31:00]                       <= f32_data[31:00]; 
      if(w_load_label5_data0)                       o_label5_data0[31:00]                       <= f32_data[31:00]; 
      if(w_load_label6_config)                      o_label6_config[07:00]                      <= f32_data[07:00]; 
      if(w_load_label6_config)                      o_label6_config[08:08]                      <= f32_data[08:08]; 
      if(w_load_label6_config)                      o_label6_config[14:09]                      <= f32_data[30:25]; 
      if(w_load_label6_config)                      o_label6_config[15:15]                      <= f32_data[31:31]; 
      if(w_load_label6_data7)                       o_label6_data7[31:00]                       <= f32_data[31:00]; 
      if(w_load_label6_data6)                       o_label6_data6[31:00]                       <= f32_data[31:00]; 
      if(w_load_label6_data5)                       o_label6_data5[31:00]                       <= f32_data[31:00]; 
      if(w_load_label6_data4)                       o_label6_data4[31:00]                       <= f32_data[31:00]; 
      if(w_load_label6_data3)                       o_label6_data3[31:00]                       <= f32_data[31:00]; 
      if(w_load_label6_data2)                       o_label6_data2[31:00]                       <= f32_data[31:00]; 
      if(w_load_label6_data1)                       o_label6_data1[31:00]                       <= f32_data[31:00]; 
      if(w_load_label6_data0)                       o_label6_data0[31:00]                       <= f32_data[31:00]; 
      if(w_load_label7_config)                      o_label7_config[07:00]                      <= f32_data[07:00]; 
      if(w_load_label7_config)                      o_label7_config[08:08]                      <= f32_data[08:08]; 
      if(w_load_label7_config)                      o_label7_config[14:09]                      <= f32_data[30:25]; 
      if(w_load_label7_config)                      o_label7_config[15:15]                      <= f32_data[31:31]; 
      if(w_load_label7_data7)                       o_label7_data7[31:00]                       <= f32_data[31:00]; 
      if(w_load_label7_data6)                       o_label7_data6[31:00]                       <= f32_data[31:00]; 
      if(w_load_label7_data5)                       o_label7_data5[31:00]                       <= f32_data[31:00]; 
      if(w_load_label7_data4)                       o_label7_data4[31:00]                       <= f32_data[31:00]; 
      if(w_load_label7_data3)                       o_label7_data3[31:00]                       <= f32_data[31:00]; 
      if(w_load_label7_data2)                       o_label7_data2[31:00]                       <= f32_data[31:00]; 
      if(w_load_label7_data1)                       o_label7_data1[31:00]                       <= f32_data[31:00]; 
      if(w_load_label7_data0)                       o_label7_data0[31:00]                       <= f32_data[31:00]; 
      if(w_load_kdf_drbg_ctrl)                      o_kdf_drbg_ctrl[01:00]                      <= f32_data[01:00]; 
      if(w_load_kdf_drbg_seed_0_state_key_31_0)     o_kdf_drbg_seed_0_state_key_31_0[31:00]     <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_0_state_key_63_32)    o_kdf_drbg_seed_0_state_key_63_32[31:00]    <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_0_state_key_95_64)    o_kdf_drbg_seed_0_state_key_95_64[31:00]    <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_0_state_key_127_96)   o_kdf_drbg_seed_0_state_key_127_96[31:00]   <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_0_state_key_159_128)  o_kdf_drbg_seed_0_state_key_159_128[31:00]  <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_0_state_key_191_160)  o_kdf_drbg_seed_0_state_key_191_160[31:00]  <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_0_state_key_223_192)  o_kdf_drbg_seed_0_state_key_223_192[31:00]  <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_0_state_key_255_224)  o_kdf_drbg_seed_0_state_key_255_224[31:00]  <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_0_state_value_31_0)   o_kdf_drbg_seed_0_state_value_31_0[31:00]   <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_0_state_value_63_32)  o_kdf_drbg_seed_0_state_value_63_32[31:00]  <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_0_state_value_95_64)  o_kdf_drbg_seed_0_state_value_95_64[31:00]  <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_0_state_value_127_96) o_kdf_drbg_seed_0_state_value_127_96[31:00] <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_0_reseed_interval_0)  o_kdf_drbg_seed_0_reseed_interval_0[31:00]  <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_0_reseed_interval_1)  o_kdf_drbg_seed_0_reseed_interval_1[15:00]  <= f32_data[15:00]; 
      if(w_load_kdf_drbg_seed_1_state_key_31_0)     o_kdf_drbg_seed_1_state_key_31_0[31:00]     <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_1_state_key_63_32)    o_kdf_drbg_seed_1_state_key_63_32[31:00]    <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_1_state_key_95_64)    o_kdf_drbg_seed_1_state_key_95_64[31:00]    <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_1_state_key_127_96)   o_kdf_drbg_seed_1_state_key_127_96[31:00]   <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_1_state_key_159_128)  o_kdf_drbg_seed_1_state_key_159_128[31:00]  <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_1_state_key_191_160)  o_kdf_drbg_seed_1_state_key_191_160[31:00]  <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_1_state_key_223_192)  o_kdf_drbg_seed_1_state_key_223_192[31:00]  <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_1_state_key_255_224)  o_kdf_drbg_seed_1_state_key_255_224[31:00]  <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_1_state_value_31_0)   o_kdf_drbg_seed_1_state_value_31_0[31:00]   <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_1_state_value_63_32)  o_kdf_drbg_seed_1_state_value_63_32[31:00]  <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_1_state_value_95_64)  o_kdf_drbg_seed_1_state_value_95_64[31:00]  <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_1_state_value_127_96) o_kdf_drbg_seed_1_state_value_127_96[31:00] <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_1_reseed_interval_0)  o_kdf_drbg_seed_1_reseed_interval_0[31:00]  <= f32_data[31:00]; 
      if(w_load_kdf_drbg_seed_1_reseed_interval_1)  o_kdf_drbg_seed_1_reseed_interval_1[15:00]  <= f32_data[15:00]; 
      if(w_load_interrupt_status)                   o_interrupt_status[00:00]                   <= f32_data[00:00]; 
      if(w_load_interrupt_status)                   o_interrupt_status[01:01]                   <= f32_data[01:01]; 
      if(w_load_interrupt_status)                   o_interrupt_status[02:02]                   <= f32_data[02:02]; 
      if(w_load_interrupt_status)                   o_interrupt_status[03:03]                   <= f32_data[03:03]; 
      if(w_load_interrupt_status)                   o_interrupt_status[04:04]                   <= f32_data[04:04]; 
      if(w_load_interrupt_mask)                     o_interrupt_mask[00:00]                     <= f32_data[00:00]; 
      if(w_load_interrupt_mask)                     o_interrupt_mask[01:01]                     <= f32_data[01:01]; 
      if(w_load_interrupt_mask)                     o_interrupt_mask[02:02]                     <= f32_data[02:02]; 
      if(w_load_interrupt_mask)                     o_interrupt_mask[03:03]                     <= f32_data[03:03]; 
      if(w_load_interrupt_mask)                     o_interrupt_mask[04:04]                     <= f32_data[04:04]; 
      if(w_load_engine_sticky_status)               o_engine_sticky_status[00:00]               <= f32_data[00:00]; 
      if(w_load_engine_sticky_status)               o_engine_sticky_status[01:01]               <= f32_data[01:01]; 
      if(w_load_engine_sticky_status)               o_engine_sticky_status[02:02]               <= f32_data[02:02]; 
      if(w_load_engine_sticky_status)               o_engine_sticky_status[03:03]               <= f32_data[03:03]; 
      if(w_load_engine_sticky_status)               o_engine_sticky_status[04:04]               <= f32_data[04:04]; 
      if(w_load_engine_sticky_status)               o_engine_sticky_status[05:05]               <= f32_data[05:05]; 
      if(w_load_engine_sticky_status)               o_engine_sticky_status[06:06]               <= f32_data[06:06]; 
      if(w_load_engine_sticky_status)               o_engine_sticky_status[07:07]               <= f32_data[07:07]; 
      if(w_load_bimc_monitor_mask)                  o_bimc_monitor_mask[00:00]                  <= f32_data[00:00]; 
      if(w_load_bimc_monitor_mask)                  o_bimc_monitor_mask[01:01]                  <= f32_data[01:01]; 
      if(w_load_bimc_monitor_mask)                  o_bimc_monitor_mask[02:02]                  <= f32_data[02:02]; 
      if(w_load_bimc_monitor_mask)                  o_bimc_monitor_mask[03:03]                  <= f32_data[03:03]; 
      if(w_load_bimc_monitor_mask)                  o_bimc_monitor_mask[04:04]                  <= f32_data[04:04]; 
      if(w_load_bimc_monitor_mask)                  o_bimc_monitor_mask[05:05]                  <= f32_data[05:05]; 
      if(w_load_bimc_monitor_mask)                  o_bimc_monitor_mask[06:06]                  <= f32_data[06:06]; 
      if(w_load_bimc_ecc_uncorrectable_error_cnt)   o_bimc_ecc_uncorrectable_error_cnt[31:00]   <= f32_data[31:00]; 
      if(w_load_bimc_ecc_correctable_error_cnt)     o_bimc_ecc_correctable_error_cnt[31:00]     <= f32_data[31:00]; 
      if(w_load_bimc_parity_error_cnt)              o_bimc_parity_error_cnt[31:00]              <= f32_data[31:00]; 
      if(w_load_bimc_global_config)                 o_bimc_global_config[00:00]                 <= f32_data[00:00]; 
      if(w_load_bimc_global_config)                 o_bimc_global_config[01:01]                 <= f32_data[01:01]; 
      if(w_load_bimc_global_config)                 o_bimc_global_config[02:02]                 <= f32_data[02:02]; 
      if(w_load_bimc_global_config)                 o_bimc_global_config[03:03]                 <= f32_data[03:03]; 
      if(w_load_bimc_global_config)                 o_bimc_global_config[04:04]                 <= f32_data[04:04]; 
      if(w_load_bimc_global_config)                 o_bimc_global_config[05:05]                 <= f32_data[05:05]; 
      if(w_load_bimc_global_config)                 o_bimc_global_config[31:06]                 <= f32_data[31:06]; 
      if(w_load_bimc_eccpar_debug)                  o_bimc_eccpar_debug[11:00]                  <= f32_data[11:00]; 
      if(w_load_bimc_eccpar_debug)                  o_bimc_eccpar_debug[15:12]                  <= f32_data[15:12]; 
      if(w_load_bimc_eccpar_debug)                  o_bimc_eccpar_debug[17:16]                  <= f32_data[17:16]; 
      if(w_load_bimc_eccpar_debug)                  o_bimc_eccpar_debug[19:18]                  <= f32_data[19:18]; 
      if(w_load_bimc_eccpar_debug)                  o_bimc_eccpar_debug[21:20]                  <= f32_data[21:20]; 
      if(w_load_bimc_eccpar_debug)                  o_bimc_eccpar_debug[22:22]                  <= f32_data[22:22]; 
      if(w_load_bimc_eccpar_debug)                  o_bimc_eccpar_debug[23:23]                  <= f32_data[23:23]; 
      if(w_load_bimc_eccpar_debug)                  o_bimc_eccpar_debug[27:24]                  <= f32_data[27:24]; 
      if(w_load_bimc_eccpar_debug)                  o_bimc_eccpar_debug[28:28]                  <= f32_data[28:28]; 
      if(w_load_bimc_cmd2)                          o_bimc_cmd2[07:00]                          <= f32_data[07:00]; 
      if(w_load_bimc_cmd2)                          o_bimc_cmd2[08:08]                          <= f32_data[08:08]; 
      if(w_load_bimc_cmd2)                          o_bimc_cmd2[09:09]                          <= f32_data[09:09]; 
      if(w_load_bimc_cmd2)                          o_bimc_cmd2[10:10]                          <= f32_data[10:10]; 
      if(w_load_bimc_cmd1)                          o_bimc_cmd1[15:00]                          <= f32_data[15:00]; 
      if(w_load_bimc_cmd1)                          o_bimc_cmd1[27:16]                          <= f32_data[27:16]; 
      if(w_load_bimc_cmd1)                          o_bimc_cmd1[31:28]                          <= f32_data[31:28]; 
      if(w_load_bimc_cmd0)                          o_bimc_cmd0[31:00]                          <= f32_data[31:00]; 
      if(w_load_bimc_rxcmd2)                        o_bimc_rxcmd2[07:00]                        <= f32_data[07:00]; 
      if(w_load_bimc_rxcmd2)                        o_bimc_rxcmd2[08:08]                        <= f32_data[08:08]; 
      if(w_load_bimc_rxrsp2)                        o_bimc_rxrsp2[07:00]                        <= f32_data[07:00]; 
      if(w_load_bimc_rxrsp2)                        o_bimc_rxrsp2[08:08]                        <= f32_data[08:08]; 
      if(w_load_bimc_pollrsp2)                      o_bimc_pollrsp2[07:00]                      <= f32_data[07:00]; 
      if(w_load_bimc_pollrsp2)                      o_bimc_pollrsp2[08:08]                      <= f32_data[08:08]; 
      if(w_load_bimc_dbgcmd2)                       o_bimc_dbgcmd2[07:00]                       <= f32_data[07:00]; 
      if(w_load_bimc_dbgcmd2)                       o_bimc_dbgcmd2[08:08]                       <= f32_data[08:08]; 
      if(w_load_im_consumed)                        o_im_consumed[00:00]                        <= f32_data[00:00]; 
      if(w_load_im_consumed)                        o_im_consumed[01:01]                        <= f32_data[01:01]; 
      if(w_load_im_consumed)                        o_im_consumed[02:02]                        <= f32_data[02:02]; 
      if(w_load_im_consumed)                        o_im_consumed[03:03]                        <= f32_data[03:03]; 
      if(w_load_im_consumed)                        o_im_consumed[04:04]                        <= f32_data[04:04]; 
      if(w_load_im_consumed)                        o_im_consumed[05:05]                        <= f32_data[05:05]; 
      if(w_load_im_consumed)                        o_im_consumed[06:06]                        <= f32_data[06:06]; 
      if(w_load_im_consumed)                        o_im_consumed[07:07]                        <= f32_data[07:07]; 
      if(w_load_im_consumed)                        o_im_consumed[08:08]                        <= f32_data[08:08]; 
      if(w_load_im_consumed)                        o_im_consumed[09:09]                        <= f32_data[09:09]; 
      if(w_load_im_consumed)                        o_im_consumed[10:10]                        <= f32_data[10:10]; 
      if(w_load_im_consumed)                        o_im_consumed[11:11]                        <= f32_data[11:11]; 
      if(w_load_im_consumed)                        o_im_consumed[12:12]                        <= f32_data[12:12]; 
      if(w_load_im_consumed)                        o_im_consumed[13:13]                        <= f32_data[13:13]; 
      if(w_load_im_consumed)                        o_im_consumed[14:14]                        <= f32_data[14:14]; 
      if(w_load_im_consumed)                        o_im_consumed[15:15]                        <= f32_data[15:15]; 
      if(w_load_tready_override)                    o_tready_override[00:00]                    <= f32_data[00:00]; 
      if(w_load_tready_override)                    o_tready_override[01:01]                    <= f32_data[01:01]; 
      if(w_load_tready_override)                    o_tready_override[02:02]                    <= f32_data[02:02]; 
      if(w_load_tready_override)                    o_tready_override[03:03]                    <= f32_data[03:03]; 
      if(w_load_tready_override)                    o_tready_override[04:04]                    <= f32_data[04:04]; 
      if(w_load_tready_override)                    o_tready_override[05:05]                    <= f32_data[05:05]; 
      if(w_load_tready_override)                    o_tready_override[06:06]                    <= f32_data[06:06]; 
      if(w_load_tready_override)                    o_tready_override[07:07]                    <= f32_data[07:07]; 
      if(w_load_tready_override)                    o_tready_override[08:08]                    <= f32_data[08:08]; 
      if(w_load_regs_sa_ctrl)                       o_regs_sa_ctrl[00:00]                       <= f32_data[00:00]; 
      if(w_load_regs_sa_ctrl)                       o_regs_sa_ctrl[01:01]                       <= f32_data[01:01]; 
      if(w_load_regs_sa_ctrl)                       o_regs_sa_ctrl[07:02]                       <= f32_data[07:02]; 
      if(w_load_regs_sa_ctrl)                       o_regs_sa_ctrl[12:08]                       <= f32_data[12:08]; 
      if(w_load_regs_sa_ctrl)                       o_regs_sa_ctrl[31:13]                       <= f32_data[31:13]; 
      if(w_load_sa_snapshot_ia_wdata_part0)         o_sa_snapshot_ia_wdata_part0[17:00]         <= f32_data[17:00]; 
      if(w_load_sa_snapshot_ia_wdata_part0)         o_sa_snapshot_ia_wdata_part0[31:18]         <= f32_data[31:18]; 
      if(w_load_sa_snapshot_ia_wdata_part1)         o_sa_snapshot_ia_wdata_part1[31:00]         <= f32_data[31:00]; 
      if(w_load_sa_snapshot_ia_config)              o_sa_snapshot_ia_config[04:00]              <= f32_data[04:00]; 
      if(w_load_sa_snapshot_ia_config)              o_sa_snapshot_ia_config[08:05]              <= f32_data[31:28]; 
      if(w_load_sa_count_ia_wdata_part0)            o_sa_count_ia_wdata_part0[17:00]            <= f32_data[17:00]; 
      if(w_load_sa_count_ia_wdata_part0)            o_sa_count_ia_wdata_part0[31:18]            <= f32_data[31:18]; 
      if(w_load_sa_count_ia_wdata_part1)            o_sa_count_ia_wdata_part1[31:00]            <= f32_data[31:00]; 
      if(w_load_sa_count_ia_config)                 o_sa_count_ia_config[04:00]                 <= f32_data[04:00]; 
      if(w_load_sa_count_ia_config)                 o_sa_count_ia_config[08:05]                 <= f32_data[31:28]; 
      if(w_load_cceip_encrypt_kop_fifo_override)    o_cceip_encrypt_kop_fifo_override[00:00]    <= f32_data[00:00]; 
      if(w_load_cceip_encrypt_kop_fifo_override)    o_cceip_encrypt_kop_fifo_override[01:01]    <= f32_data[01:01]; 
      if(w_load_cceip_encrypt_kop_fifo_override)    o_cceip_encrypt_kop_fifo_override[02:02]    <= f32_data[02:02]; 
      if(w_load_cceip_encrypt_kop_fifo_override)    o_cceip_encrypt_kop_fifo_override[03:03]    <= f32_data[03:03]; 
      if(w_load_cceip_encrypt_kop_fifo_override)    o_cceip_encrypt_kop_fifo_override[04:04]    <= f32_data[04:04]; 
      if(w_load_cceip_encrypt_kop_fifo_override)    o_cceip_encrypt_kop_fifo_override[05:05]    <= f32_data[05:05]; 
      if(w_load_cceip_encrypt_kop_fifo_override)    o_cceip_encrypt_kop_fifo_override[06:06]    <= f32_data[06:06]; 
      if(w_load_cceip_validate_kop_fifo_override)   o_cceip_validate_kop_fifo_override[00:00]   <= f32_data[00:00]; 
      if(w_load_cceip_validate_kop_fifo_override)   o_cceip_validate_kop_fifo_override[01:01]   <= f32_data[01:01]; 
      if(w_load_cceip_validate_kop_fifo_override)   o_cceip_validate_kop_fifo_override[02:02]   <= f32_data[02:02]; 
      if(w_load_cceip_validate_kop_fifo_override)   o_cceip_validate_kop_fifo_override[03:03]   <= f32_data[03:03]; 
      if(w_load_cceip_validate_kop_fifo_override)   o_cceip_validate_kop_fifo_override[04:04]   <= f32_data[04:04]; 
      if(w_load_cceip_validate_kop_fifo_override)   o_cceip_validate_kop_fifo_override[05:05]   <= f32_data[05:05]; 
      if(w_load_cceip_validate_kop_fifo_override)   o_cceip_validate_kop_fifo_override[06:06]   <= f32_data[06:06]; 
      if(w_load_cddip_decrypt_kop_fifo_override)    o_cddip_decrypt_kop_fifo_override[00:00]    <= f32_data[00:00]; 
      if(w_load_cddip_decrypt_kop_fifo_override)    o_cddip_decrypt_kop_fifo_override[01:01]    <= f32_data[01:01]; 
      if(w_load_cddip_decrypt_kop_fifo_override)    o_cddip_decrypt_kop_fifo_override[02:02]    <= f32_data[02:02]; 
      if(w_load_cddip_decrypt_kop_fifo_override)    o_cddip_decrypt_kop_fifo_override[03:03]    <= f32_data[03:03]; 
      if(w_load_cddip_decrypt_kop_fifo_override)    o_cddip_decrypt_kop_fifo_override[04:04]    <= f32_data[04:04]; 
      if(w_load_cddip_decrypt_kop_fifo_override)    o_cddip_decrypt_kop_fifo_override[05:05]    <= f32_data[05:05]; 
      if(w_load_cddip_decrypt_kop_fifo_override)    o_cddip_decrypt_kop_fifo_override[06:06]    <= f32_data[06:06]; 
      if(w_load_sa_global_ctrl)                     o_sa_global_ctrl[00:00]                     <= f32_data[00:00]; 
      if(w_load_sa_global_ctrl)                     o_sa_global_ctrl[01:01]                     <= f32_data[01:01]; 
      if(w_load_sa_global_ctrl)                     o_sa_global_ctrl[31:02]                     <= f32_data[31:02]; 
      if(w_load_sa_ctrl_ia_wdata_part0)             o_sa_ctrl_ia_wdata_part0[04:00]             <= f32_data[04:00]; 
      if(w_load_sa_ctrl_ia_wdata_part0)             o_sa_ctrl_ia_wdata_part0[31:05]             <= f32_data[31:05]; 
      if(w_load_sa_ctrl_ia_config)                  o_sa_ctrl_ia_config[04:00]                  <= f32_data[04:00]; 
      if(w_load_sa_ctrl_ia_config)                  o_sa_ctrl_ia_config[08:05]                  <= f32_data[31:28]; 
      if(w_load_kdf_test_key_size_config)           o_kdf_test_key_size_config[31:00]           <= f32_data[31:00]; 
    end
  end

  
  
  
  always_ff @(posedge clk) begin
      if(w_load_cceip0_out_ia_wdata_part0)          o_cceip0_out_ia_wdata_part0[13:06]          <= f32_data[13:06]; 
      if(w_load_cceip0_out_ia_wdata_part0)          o_cceip0_out_ia_wdata_part0[14:14]          <= f32_data[14:14]; 
      if(w_load_cceip0_out_ia_wdata_part0)          o_cceip0_out_ia_wdata_part0[22:15]          <= f32_data[22:15]; 
      if(w_load_cceip0_out_ia_wdata_part0)          o_cceip0_out_ia_wdata_part0[30:23]          <= f32_data[30:23]; 
      if(w_load_cceip0_out_ia_wdata_part0)          o_cceip0_out_ia_wdata_part0[31:31]          <= f32_data[31:31]; 
      if(w_load_cceip1_out_ia_wdata_part0)          o_cceip1_out_ia_wdata_part0[13:06]          <= f32_data[13:06]; 
      if(w_load_cceip1_out_ia_wdata_part0)          o_cceip1_out_ia_wdata_part0[14:14]          <= f32_data[14:14]; 
      if(w_load_cceip1_out_ia_wdata_part0)          o_cceip1_out_ia_wdata_part0[22:15]          <= f32_data[22:15]; 
      if(w_load_cceip1_out_ia_wdata_part0)          o_cceip1_out_ia_wdata_part0[30:23]          <= f32_data[30:23]; 
      if(w_load_cceip1_out_ia_wdata_part0)          o_cceip1_out_ia_wdata_part0[31:31]          <= f32_data[31:31]; 
      if(w_load_cceip2_out_ia_wdata_part0)          o_cceip2_out_ia_wdata_part0[13:06]          <= f32_data[13:06]; 
      if(w_load_cceip2_out_ia_wdata_part0)          o_cceip2_out_ia_wdata_part0[14:14]          <= f32_data[14:14]; 
      if(w_load_cceip2_out_ia_wdata_part0)          o_cceip2_out_ia_wdata_part0[22:15]          <= f32_data[22:15]; 
      if(w_load_cceip2_out_ia_wdata_part0)          o_cceip2_out_ia_wdata_part0[30:23]          <= f32_data[30:23]; 
      if(w_load_cceip2_out_ia_wdata_part0)          o_cceip2_out_ia_wdata_part0[31:31]          <= f32_data[31:31]; 
      if(w_load_cceip3_out_ia_wdata_part0)          o_cceip3_out_ia_wdata_part0[13:06]          <= f32_data[13:06]; 
      if(w_load_cceip3_out_ia_wdata_part0)          o_cceip3_out_ia_wdata_part0[14:14]          <= f32_data[14:14]; 
      if(w_load_cceip3_out_ia_wdata_part0)          o_cceip3_out_ia_wdata_part0[22:15]          <= f32_data[22:15]; 
      if(w_load_cceip3_out_ia_wdata_part0)          o_cceip3_out_ia_wdata_part0[30:23]          <= f32_data[30:23]; 
      if(w_load_cceip3_out_ia_wdata_part0)          o_cceip3_out_ia_wdata_part0[31:31]          <= f32_data[31:31]; 
      if(w_load_cddip0_out_ia_wdata_part0)          o_cddip0_out_ia_wdata_part0[13:06]          <= f32_data[13:06]; 
      if(w_load_cddip0_out_ia_wdata_part0)          o_cddip0_out_ia_wdata_part0[14:14]          <= f32_data[14:14]; 
      if(w_load_cddip0_out_ia_wdata_part0)          o_cddip0_out_ia_wdata_part0[22:15]          <= f32_data[22:15]; 
      if(w_load_cddip0_out_ia_wdata_part0)          o_cddip0_out_ia_wdata_part0[30:23]          <= f32_data[30:23]; 
      if(w_load_cddip0_out_ia_wdata_part0)          o_cddip0_out_ia_wdata_part0[31:31]          <= f32_data[31:31]; 
      if(w_load_cddip1_out_ia_wdata_part0)          o_cddip1_out_ia_wdata_part0[13:06]          <= f32_data[13:06]; 
      if(w_load_cddip1_out_ia_wdata_part0)          o_cddip1_out_ia_wdata_part0[14:14]          <= f32_data[14:14]; 
      if(w_load_cddip1_out_ia_wdata_part0)          o_cddip1_out_ia_wdata_part0[22:15]          <= f32_data[22:15]; 
      if(w_load_cddip1_out_ia_wdata_part0)          o_cddip1_out_ia_wdata_part0[30:23]          <= f32_data[30:23]; 
      if(w_load_cddip1_out_ia_wdata_part0)          o_cddip1_out_ia_wdata_part0[31:31]          <= f32_data[31:31]; 
      if(w_load_cddip2_out_ia_wdata_part0)          o_cddip2_out_ia_wdata_part0[13:06]          <= f32_data[13:06]; 
      if(w_load_cddip2_out_ia_wdata_part0)          o_cddip2_out_ia_wdata_part0[14:14]          <= f32_data[14:14]; 
      if(w_load_cddip2_out_ia_wdata_part0)          o_cddip2_out_ia_wdata_part0[22:15]          <= f32_data[22:15]; 
      if(w_load_cddip2_out_ia_wdata_part0)          o_cddip2_out_ia_wdata_part0[30:23]          <= f32_data[30:23]; 
      if(w_load_cddip2_out_ia_wdata_part0)          o_cddip2_out_ia_wdata_part0[31:31]          <= f32_data[31:31]; 
      if(w_load_cddip3_out_ia_wdata_part0)          o_cddip3_out_ia_wdata_part0[13:06]          <= f32_data[13:06]; 
      if(w_load_cddip3_out_ia_wdata_part0)          o_cddip3_out_ia_wdata_part0[14:14]          <= f32_data[14:14]; 
      if(w_load_cddip3_out_ia_wdata_part0)          o_cddip3_out_ia_wdata_part0[22:15]          <= f32_data[22:15]; 
      if(w_load_cddip3_out_ia_wdata_part0)          o_cddip3_out_ia_wdata_part0[30:23]          <= f32_data[30:23]; 
      if(w_load_cddip3_out_ia_wdata_part0)          o_cddip3_out_ia_wdata_part0[31:31]          <= f32_data[31:31]; 
      if(w_load_bimc_rxcmd2)                        o_bimc_rxcmd2[09:09]                        <= f32_data[09:09]; 
      if(w_load_bimc_rxrsp2)                        o_bimc_rxrsp2[09:09]                        <= f32_data[09:09]; 
      if(w_load_bimc_pollrsp2)                      o_bimc_pollrsp2[09:09]                      <= f32_data[09:09]; 
      if(w_load_bimc_dbgcmd2)                       o_bimc_dbgcmd2[09:09]                       <= f32_data[09:09]; 
  end
  

  

endmodule
