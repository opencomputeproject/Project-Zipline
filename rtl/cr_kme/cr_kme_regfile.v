/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/









 
module cr_kme_regfile 

   (
  
  suppress_key_tlvs, kme_interrupt, rbus_ring_o, kme_cceip0_ob_out,
  kme_cceip0_ob_in_mod, kme_cceip1_ob_out, kme_cceip1_ob_in_mod,
  kme_cceip2_ob_out, kme_cceip2_ob_in_mod, kme_cceip3_ob_out,
  kme_cceip3_ob_in_mod, kme_cddip0_ob_out, kme_cddip0_ob_in_mod,
  kme_cddip1_ob_out, kme_cddip1_ob_in_mod, kme_cddip2_ob_out,
  kme_cddip2_ob_in_mod, kme_cddip3_ob_out, kme_cddip3_ob_in_mod,
  ckv_dout, ckv_mbe, kim_dout, kim_mbe, bimc_rst_n,
  cceip_encrypt_bimc_isync, cceip_encrypt_bimc_idat,
  cceip_validate_bimc_isync, cceip_validate_bimc_idat,
  cddip_decrypt_bimc_isync, cddip_decrypt_bimc_idat, axi_bimc_isync,
  axi_bimc_idat, labels, seed0_valid, seed0_internal_state_key,
  seed0_internal_state_value, seed0_reseed_interval, seed1_valid,
  seed1_internal_state_key, seed1_internal_state_value,
  seed1_reseed_interval, tready_override,
  cceip_encrypt_kop_fifo_override, cceip_validate_kop_fifo_override,
  cddip_decrypt_kop_fifo_override, manual_txc,
  always_validate_kim_ref, kdf_test_mode_en, kdf_test_key_size,
  sa_global_ctrl, sa_ctrl, debug_kme_ib_tvalid, debug_kme_ib_tlast,
  debug_kme_ib_tid, debug_kme_ib_tstrb, debug_kme_ib_tuser,
  debug_kme_ib_tdata,
  
  clk, rst_n, ovstb, lvm, mlvm, rbus_ring_i, cfg_start_addr,
  cfg_end_addr, kme_cceip0_ob_out_pre, kme_cceip0_ob_in,
  kme_cceip1_ob_out_pre, kme_cceip1_ob_in, kme_cceip2_ob_out_pre,
  kme_cceip2_ob_in, kme_cceip3_ob_out_pre, kme_cceip3_ob_in,
  kme_cddip0_ob_out_pre, kme_cddip0_ob_in, kme_cddip1_ob_out_pre,
  kme_cddip1_ob_in, kme_cddip2_ob_out_pre, kme_cddip2_ob_in,
  kme_cddip3_ob_out_pre, kme_cddip3_ob_in, ckv_rd, ckv_addr, kim_rd,
  kim_addr, cceip_encrypt_bimc_osync, cceip_encrypt_bimc_odat,
  cceip_encrypt_mbe, cceip_validate_bimc_osync,
  cceip_validate_bimc_odat, cceip_validate_mbe,
  cddip_decrypt_bimc_osync, cddip_decrypt_bimc_odat,
  cddip_decrypt_mbe, axi_bimc_osync, axi_bimc_odat, axi_mbe,
  seed0_invalidate, seed1_invalidate, set_txc_bp_int,
  set_gcm_tag_fail_int, set_key_tlv_miscmp_int,
  set_tlv_bip2_error_int, set_rsm_is_backpressuring, idle_components,
  sa_snapshot, sa_count, debug_kme_ib_tready
  );

    `include "cr_kme_body_param.v"
    `include "bimc_master.vh"   

    
    
    
    input   clk;
    input   rst_n;
    output  suppress_key_tlvs;

    
    
    
    output kme_interrupt;

    
    
    
    input   ovstb;
    input   lvm;
    input   mlvm;

    
    
    
    input   kme_rbus_ring_t     rbus_ring_i;
    output  kme_rbus_ring_t     rbus_ring_o;
    input [`N_KME_RBUS_ADDR_BITS-1:0] cfg_start_addr;
    input [`N_KME_RBUS_ADDR_BITS-1:0] cfg_end_addr;

   
    
    
    
    input   axi4s_dp_bus_t  kme_cceip0_ob_out_pre;
    input   axi4s_dp_rdy_t  kme_cceip0_ob_in;
    output  axi4s_dp_bus_t  kme_cceip0_ob_out;
    output  axi4s_dp_rdy_t  kme_cceip0_ob_in_mod;

    input   axi4s_dp_bus_t  kme_cceip1_ob_out_pre;
    input   axi4s_dp_rdy_t  kme_cceip1_ob_in;
    output  axi4s_dp_bus_t  kme_cceip1_ob_out;
    output  axi4s_dp_rdy_t  kme_cceip1_ob_in_mod;
    
    input   axi4s_dp_bus_t  kme_cceip2_ob_out_pre;
    input   axi4s_dp_rdy_t  kme_cceip2_ob_in;
    output  axi4s_dp_bus_t  kme_cceip2_ob_out;
    output  axi4s_dp_rdy_t  kme_cceip2_ob_in_mod;

    input   axi4s_dp_bus_t  kme_cceip3_ob_out_pre;
    input   axi4s_dp_rdy_t  kme_cceip3_ob_in;
    output  axi4s_dp_bus_t  kme_cceip3_ob_out;
    output  axi4s_dp_rdy_t  kme_cceip3_ob_in_mod;


    
    
    
    input   axi4s_dp_bus_t  kme_cddip0_ob_out_pre;
    input   axi4s_dp_rdy_t  kme_cddip0_ob_in;
    output  axi4s_dp_bus_t  kme_cddip0_ob_out;
    output  axi4s_dp_rdy_t  kme_cddip0_ob_in_mod;

    input   axi4s_dp_bus_t  kme_cddip1_ob_out_pre;
    input   axi4s_dp_rdy_t  kme_cddip1_ob_in;
    output  axi4s_dp_bus_t  kme_cddip1_ob_out;
    output  axi4s_dp_rdy_t  kme_cddip1_ob_in_mod;

    input   axi4s_dp_bus_t  kme_cddip2_ob_out_pre;
    input   axi4s_dp_rdy_t  kme_cddip2_ob_in;
    output  axi4s_dp_bus_t  kme_cddip2_ob_out;
    output  axi4s_dp_rdy_t  kme_cddip2_ob_in_mod;

    input   axi4s_dp_bus_t  kme_cddip3_ob_out_pre;
    input   axi4s_dp_rdy_t  kme_cddip3_ob_in;
    output  axi4s_dp_bus_t  kme_cddip3_ob_out;
    output  axi4s_dp_rdy_t  kme_cddip3_ob_in_mod;

    
    
    
    input                               ckv_rd;
    input   [`LOG_VEC(CKV_NUM_ENTRIES)] ckv_addr;
    output  [`BIT_VEC(CKV_DATA_WIDTH)]  ckv_dout;
    output                              ckv_mbe;

    
    
    
    input                               kim_rd;
    input  [`LOG_VEC(KIM_NUM_ENTRIES)]  kim_addr;
    output kim_entry_t                  kim_dout;
    output                              kim_mbe;

    
    
    
    output bimc_rst_n;

    
    
    
    input   cceip_encrypt_bimc_osync;
    input   cceip_encrypt_bimc_odat;
    output  cceip_encrypt_bimc_isync;
    output  cceip_encrypt_bimc_idat;
    input   cceip_encrypt_mbe;

    
    
    
    input   cceip_validate_bimc_osync;
    input   cceip_validate_bimc_odat;
    output  cceip_validate_bimc_isync;
    output  cceip_validate_bimc_idat;
    input   cceip_validate_mbe;

    
    
    
    input   cddip_decrypt_bimc_osync;
    input   cddip_decrypt_bimc_odat;
    output  cddip_decrypt_bimc_isync;
    output  cddip_decrypt_bimc_idat;
    input   cddip_decrypt_mbe;

    
    
    
    input   axi_bimc_osync;
    input   axi_bimc_odat;
    output  axi_bimc_isync;
    output  axi_bimc_idat;
    input   axi_mbe;

    
    
    
    output label_t [7:0] labels;

    
    
    
    output                  seed0_valid;
    output  [255:0]         seed0_internal_state_key;
    output  [127:0]         seed0_internal_state_value;
    output   [47:0]         seed0_reseed_interval;
    output                  seed1_valid;
    output  [255:0]         seed1_internal_state_key;
    output  [127:0]         seed1_internal_state_value;
    output   [47:0]         seed1_reseed_interval;

    
    
    
    input seed0_invalidate;
    input seed1_invalidate;

    
    
    
    input set_txc_bp_int;
    input set_gcm_tag_fail_int;
    input set_key_tlv_miscmp_int;
    input set_tlv_bip2_error_int;

    
    
    
    input  [7:0]                set_rsm_is_backpressuring;
    output tready_override_t    tready_override;
    output kop_fifo_override_t  cceip_encrypt_kop_fifo_override;
    output kop_fifo_override_t  cceip_validate_kop_fifo_override;
    output kop_fifo_override_t  cddip_decrypt_kop_fifo_override;
    input  idle_t               idle_components;
    output                      manual_txc;
    output                      always_validate_kim_ref;
    output                      kdf_test_mode_en;
    output [31:0]               kdf_test_key_size;


    
    
    
    output sa_global_ctrl_t sa_global_ctrl;
    output sa_ctrl_t        sa_ctrl[31:0];
    input  sa_snapshot_t    sa_snapshot[31:0];
    input  sa_count_t       sa_count[31:0];

    
    
    
    output                          debug_kme_ib_tvalid;
    output                          debug_kme_ib_tlast;
    output [`AXI_S_TID_WIDTH-1:0]   debug_kme_ib_tid;
    output [`AXI_S_TSTRB_WIDTH-1:0] debug_kme_ib_tstrb;
    output [`AXI_S_USER_WIDTH-1:0]  debug_kme_ib_tuser;
    output [`AXI_S_DP_DWIDTH-1:0]   debug_kme_ib_tdata;
    input                           debug_kme_ib_tready;




    

    `ifdef SHOULD_BE_EMPTY
        
        
    `endif




          
               
    
    
    logic               axi_term_bimc_idat;     
    logic               axi_term_bimc_isync;    
    logic [`CR_C_BIMC_CMD2_T_DECL] bimc_cmd2;   
    logic [`CR_C_BIMC_DBGCMD0_T_DECL] bimc_dbgcmd0;
    logic [`CR_C_BIMC_DBGCMD1_T_DECL] bimc_dbgcmd1;
    logic [`CR_C_BIMC_DBGCMD2_T_DECL] bimc_dbgcmd2;
    logic [`CR_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] bimc_ecc_correctable_error_cnt;
    logic [`CR_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] bimc_ecc_uncorrectable_error_cnt;
    logic [`CR_C_BIMC_ECCPAR_DEBUG_T_DECL] bimc_eccpar_debug;
    logic [`CR_C_BIMC_GLOBAL_CONFIG_T_DECL] bimc_global_config;
    logic               bimc_interrupt;         
    logic [`CR_C_BIMC_MEMID_T_DECL] bimc_memid; 
    logic [`CR_C_BIMC_MONITOR_T_DECL] bimc_monitor;
    logic [`CR_C_BIMC_PARITY_ERROR_CNT_T_DECL] bimc_parity_error_cnt;
    logic [`CR_C_BIMC_POLLRSP0_T_DECL] bimc_pollrsp0;
    logic [`CR_C_BIMC_POLLRSP1_T_DECL] bimc_pollrsp1;
    logic [`CR_C_BIMC_POLLRSP2_T_DECL] bimc_pollrsp2;
    logic [`CR_C_BIMC_RXCMD0_T_DECL] bimc_rxcmd0;
    logic [`CR_C_BIMC_RXCMD1_T_DECL] bimc_rxcmd1;
    logic [`CR_C_BIMC_RXCMD2_T_DECL] bimc_rxcmd2;
    logic [`CR_C_BIMC_RXRSP0_T_DECL] bimc_rxrsp0;
    logic [`CR_C_BIMC_RXRSP1_T_DECL] bimc_rxrsp1;
    logic [`CR_C_BIMC_RXRSP2_T_DECL] bimc_rxrsp2;
    logic               cceip0_im_rdy;          
    logic               cceip0_ism_bimc_idat;   
    logic               cceip0_ism_bimc_isync;  
    logic               cceip0_ism_mbe;         
    logic               cceip1_im_rdy;          
    logic               cceip1_ism_idat;        
    logic               cceip1_ism_isync;       
    logic               cceip1_ism_mbe;         
    logic               cceip2_im_rdy;          
    logic               cceip2_ism_idat;        
    logic               cceip2_ism_isync;       
    logic               cceip2_ism_mbe;         
    logic               cceip3_im_rdy;          
    logic               cceip3_ism_idat;        
    logic               cceip3_ism_isync;       
    logic               cceip3_ism_mbe;         
    logic               cddip0_im_rdy;          
    logic               cddip0_ism_idat;        
    logic               cddip0_ism_isync;       
    logic               cddip0_ism_mbe;         
    logic               cddip1_im_rdy;          
    logic               cddip1_ism_idat;        
    logic               cddip1_ism_isync;       
    logic               cddip1_ism_mbe;         
    logic               cddip2_im_rdy;          
    logic               cddip2_ism_idat;        
    logic               cddip2_ism_isync;       
    logic               cddip2_ism_mbe;         
    logic               cddip3_im_rdy;          
    logic               cddip3_ism_idat;        
    logic               cddip3_ism_isync;       
    logic               cddip3_ism_mbe;         
    logic               cddip3_ism_odat;        
    logic               cddip3_ism_osync;       
    logic               ckv_bimc_idat;          
    logic               ckv_bimc_isync;         
    logic [15:0]        ckv_capability_lst;     
    logic [3:0]         ckv_capability_type;    
    logic [`LOG_VEC(CKV_NUM_ENTRIES)] ckv_cmnd_addr;
    logic [3:0]         ckv_cmnd_op;            
    ckv_ia_capability_t ckv_ia_capability;      
    logic [`CR_KME_C_CKV_PART0_T_DECL] ckv_ia_rdata_part0;
    logic [`CR_KME_C_CKV_PART1_T_DECL] ckv_ia_rdata_part1;
    ckv_ia_status_t     ckv_ia_status;          
    logic [`BIT_VEC(CKV_DATA_WIDTH)] ckv_rd_dat;
    logic [`LOG_VEC(CKV_NUM_ENTRIES)] ckv_stat_addr;
    logic [2:0]         ckv_stat_code;          
    logic [`BIT_VEC(5)] ckv_stat_datawords;     
    logic [`BIT_VEC(CKV_DATA_WIDTH)] ckv_wr_dat;
    logic               disable_ckv_kim_ism_reads;
    logic [`CR_KME_C_STICKY_ENG_BP_T_DECL] engine_sticky_status;
    logic [`CR_KME_C_INT_STATUS_T_DECL] interrupt_status;
    logic [`CR_KME_C_KDF_DRBG_CTRL_T_DECL] kdf_drbg_ctrl;
    logic               kim_bimc_idat;          
    logic               kim_bimc_isync;         
    logic [15:0]        kim_capability_lst;     
    logic [3:0]         kim_capability_type;    
    logic [`LOG_VEC(KIM_NUM_ENTRIES)] kim_cmnd_addr;
    logic [3:0]         kim_cmnd_op;            
    kim_ia_capability_t kim_ia_capability;      
    logic [`CR_KME_C_KIM_ENTRY0_T_DECL] kim_ia_rdata_part0;
    logic [`CR_KME_C_KIM_ENTRY1_T_DECL] kim_ia_rdata_part1;
    kim_ia_status_t     kim_ia_status;          
    logic [`BIT_VEC(KIM_DATA_WIDTH)] kim_rd_dat;
    logic [`LOG_VEC(KIM_NUM_ENTRIES)] kim_stat_addr;
    logic [2:0]         kim_stat_code;          
    logic [`BIT_VEC(5)] kim_stat_datawords;     
    logic [`BIT_VEC(KIM_DATA_WIDTH)] kim_wr_dat;
    logic               locl_ack;               
    logic               locl_err_ack;           
    logic [31:0]        locl_rd_data;           
    logic               locl_rd_strb;           
    logic               locl_wr_strb;           
    logic [`CR_KME_C_BIMC_CMD0_T_DECL] o_bimc_cmd0;
    logic [`CR_KME_C_BIMC_CMD1_T_DECL] o_bimc_cmd1;
    logic [`CR_KME_C_BIMC_CMD2_T_DECL] o_bimc_cmd2;
    logic [`CR_KME_C_BIMC_DBGCMD2_T_DECL] o_bimc_dbgcmd2;
    logic [`CR_KME_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_correctable_error_cnt;
    logic [`CR_KME_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_uncorrectable_error_cnt;
    logic [`CR_KME_C_BIMC_ECCPAR_DEBUG_T_DECL] o_bimc_eccpar_debug;
    logic [`CR_KME_C_BIMC_GLOBAL_CONFIG_T_DECL] o_bimc_global_config;
    logic [`CR_KME_C_BIMC_MONITOR_MASK_T_DECL] o_bimc_monitor_mask;
    logic [`CR_KME_C_BIMC_PARITY_ERROR_CNT_T_DECL] o_bimc_parity_error_cnt;
    logic [`CR_KME_C_BIMC_POLLRSP2_T_DECL] o_bimc_pollrsp2;
    logic [`CR_KME_C_BIMC_RXCMD2_T_DECL] o_bimc_rxcmd2;
    logic [`CR_KME_C_BIMC_RXRSP2_T_DECL] o_bimc_rxrsp2;
    logic [`CR_KME_C_CKV_IA_CONFIG_T_DECL] o_ckv_ia_config;
    logic [`CR_KME_C_CKV_PART0_T_DECL] o_ckv_ia_wdata_part0;
    logic [`CR_KME_C_CKV_PART1_T_DECL] o_ckv_ia_wdata_part1;
    logic               o_disable_ckv_kim_ism_reads;
    logic [`CR_KME_C_STICKY_ENG_BP_T_DECL] o_engine_sticky_status;
    logic [`CR_KME_C_INT_MASK_T_DECL] o_interrupt_mask;
    logic [`CR_KME_C_KDF_DRBG_CTRL_T_DECL] o_kdf_drbg_ctrl;
    logic [`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_0_T_DECL] o_kdf_drbg_seed_0_reseed_interval_0;
    logic [`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_1_T_DECL] o_kdf_drbg_seed_0_reseed_interval_1;
    logic [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_127_96;
    logic [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_159_128;
    logic [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_191_160;
    logic [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_223_192;
    logic [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_255_224;
    logic [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_31_0;
    logic [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_63_32;
    logic [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_0_state_key_95_64;
    logic [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_0_state_value_127_96;
    logic [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_0_state_value_31_0;
    logic [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_0_state_value_63_32;
    logic [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_0_state_value_95_64;
    logic [`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_0_T_DECL] o_kdf_drbg_seed_1_reseed_interval_0;
    logic [`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_1_T_DECL] o_kdf_drbg_seed_1_reseed_interval_1;
    logic [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_127_96;
    logic [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_159_128;
    logic [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_191_160;
    logic [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_223_192;
    logic [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_255_224;
    logic [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_31_0;
    logic [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_63_32;
    logic [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL] o_kdf_drbg_seed_1_state_key_95_64;
    logic [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_1_state_value_127_96;
    logic [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_1_state_value_31_0;
    logic [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_1_state_value_63_32;
    logic [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL] o_kdf_drbg_seed_1_state_value_95_64;
    logic [`CR_KME_C_KIM_IA_CONFIG_T_DECL] o_kim_ia_config;
    logic [`CR_KME_C_KIM_ENTRY0_T_DECL] o_kim_ia_wdata_part0;
    logic [`CR_KME_C_KIM_ENTRY1_T_DECL] o_kim_ia_wdata_part1;
    logic               o_send_kme_ib_beat;     
    logic               o_tready_override_val;  
    logic [`CR_KME_C_SA_CTRL_DEP_T_DECL] regs_sa_ctrl;
    logic               send_kme_ib_beat;       
    logic               set_drbg_expired_int;   
    logic [31:0]        wr_data;                
    logic               wr_stb;                 
    
    
    logic [`CR_KME_DECL]            reg_addr;
    logic [`CR_KME_DECL]            locl_addr;
    logic [`N_RBUS_DATA_BITS-1:0]   locl_wr_data;
    spare_t                         spare; 
    
    cceip0_out_t                    cceip0_out_ia_wdata;
    cceip0_out_ia_config_t          cceip0_out_ia_config;
    cceip0_out_t                    cceip0_out_ia_rdata;
    cceip0_out_ia_status_t          cceip0_out_ia_status;
    cceip0_out_ia_capability_t      cceip0_out_ia_capability;   
    cceip0_out_im_status_t          cceip0_out_im_status;
    cceip0_out_im_config_t          cceip0_out_im_config;

    cddip0_out_t                    cddip0_out_ia_wdata;
    cddip0_out_ia_config_t          cddip0_out_ia_config;
    cddip0_out_t                    cddip0_out_ia_rdata;
    cddip0_out_ia_status_t          cddip0_out_ia_status;
    cddip0_out_ia_capability_t      cddip0_out_ia_capability;   
    cddip0_out_im_status_t          cddip0_out_im_status;
    cddip0_out_im_config_t          cddip0_out_im_config;
     
    cceip1_out_t                    cceip1_out_ia_wdata;
    cceip1_out_ia_config_t          cceip1_out_ia_config;
    cceip1_out_t                    cceip1_out_ia_rdata;
    cceip1_out_ia_status_t          cceip1_out_ia_status;
    cceip1_out_ia_capability_t      cceip1_out_ia_capability;   
    cceip1_out_im_status_t          cceip1_out_im_status;
    cceip1_out_im_config_t          cceip1_out_im_config;

    cddip1_out_t                    cddip1_out_ia_wdata;
    cddip1_out_ia_config_t          cddip1_out_ia_config;
    cddip1_out_t                    cddip1_out_ia_rdata;
    cddip1_out_ia_status_t          cddip1_out_ia_status;
    cddip1_out_ia_capability_t      cddip1_out_ia_capability;   
    cddip1_out_im_status_t          cddip1_out_im_status;
    cddip1_out_im_config_t          cddip1_out_im_config;
     
    cceip2_out_t                    cceip2_out_ia_wdata;
    cceip2_out_ia_config_t          cceip2_out_ia_config;
    cceip2_out_t                    cceip2_out_ia_rdata;
    cceip2_out_ia_status_t          cceip2_out_ia_status;
    cceip2_out_ia_capability_t      cceip2_out_ia_capability;   
    cceip2_out_im_status_t          cceip2_out_im_status;
    cceip2_out_im_config_t          cceip2_out_im_config;

    cddip2_out_t                    cddip2_out_ia_wdata;
    cddip2_out_ia_config_t          cddip2_out_ia_config;
    cddip2_out_t                    cddip2_out_ia_rdata;
    cddip2_out_ia_status_t          cddip2_out_ia_status;
    cddip2_out_ia_capability_t      cddip2_out_ia_capability;   
    cddip2_out_im_status_t          cddip2_out_im_status;
    cddip2_out_im_config_t          cddip2_out_im_config;
     
    cceip3_out_t                    cceip3_out_ia_wdata;
    cceip3_out_ia_config_t          cceip3_out_ia_config;
    cceip3_out_t                    cceip3_out_ia_rdata;
    cceip3_out_ia_status_t          cceip3_out_ia_status;
    cceip3_out_ia_capability_t      cceip3_out_ia_capability;   
    cceip3_out_im_status_t          cceip3_out_im_status;
    cceip3_out_im_config_t          cceip3_out_im_config;

    cddip3_out_t                    cddip3_out_ia_wdata;
    cddip3_out_ia_config_t          cddip3_out_ia_config;
    cddip3_out_t                    cddip3_out_ia_rdata;
    cddip3_out_ia_status_t          cddip3_out_ia_status;
    cddip3_out_ia_capability_t      cddip3_out_ia_capability;   
    cddip3_out_im_status_t          cddip3_out_im_status;
    cddip3_out_im_config_t          cddip3_out_im_config;

    sa_snapshot_t                   sa_snapshot_ia_wdata;
    sa_snapshot_t                   sa_snapshot_ia_rdata;  
    sa_snapshot_ia_config_t         sa_snapshot_ia_config;  
    sa_snapshot_ia_status_t         sa_snapshot_ia_status;  
    sa_snapshot_ia_capability_t     sa_snapshot_ia_capability;

    sa_count_t                      sa_count_ia_wdata;
    sa_count_t                      sa_count_ia_rdata;  
    sa_count_ia_config_t            sa_count_ia_config;  
    sa_count_ia_status_t            sa_count_ia_status;  
    sa_count_ia_capability_t        sa_count_ia_capability;     

    sa_ctrl_t                       sa_ctrl_ia_wdata;
    sa_ctrl_t                       sa_ctrl_ia_rdata;  
    sa_ctrl_ia_config_t             sa_ctrl_ia_config;  
    sa_ctrl_ia_status_t             sa_ctrl_ia_status;  
    sa_ctrl_ia_capability_t         sa_ctrl_ia_capability;     
    sa_ctrl_t                       sa_ctrl_rst_dat[31:0];

    im_din_t                        cceip0_im_din;
    logic                           cceip0_im_vld;
    im_din_t                        cddip0_im_din;
    logic                           cddip0_im_vld;   
    im_din_t                        cceip1_im_din;
    logic                           cceip1_im_vld;
    im_din_t                        cddip1_im_din;
    logic                           cddip1_im_vld;   
    im_din_t                        cceip2_im_din;
    logic                           cceip2_im_vld;
    im_din_t                        cddip2_im_din;
    logic                           cddip2_im_vld;   
    im_din_t                        cceip3_im_din;
    logic                           cceip3_im_vld;
    im_din_t                        cddip3_im_din;
    logic                           cddip3_im_vld;
 
    logic [`CR_KME_C_IM_AVAILABLE_T_DECL] im_available;
   
    im_consumed_t                   im_consumed_kme_cceip0;
    im_available_t                  im_available_kme_cceip0;
    im_consumed_t                   im_consumed_kme_cddip0;
    im_available_t                  im_available_kme_cddip0;
    im_consumed_t                   im_consumed_kme_cceip1;
    im_available_t                  im_available_kme_cceip1;
    im_consumed_t                   im_consumed_kme_cddip1;
    im_available_t                  im_available_kme_cddip1;
    im_consumed_t                   im_consumed_kme_cceip2;
    im_available_t                  im_available_kme_cceip2;
    im_consumed_t                   im_consumed_kme_cddip2;
    im_available_t                  im_available_kme_cddip2;
    im_consumed_t                   im_consumed_kme_cceip3;
    im_available_t                  im_available_kme_cceip3;
    im_consumed_t                   im_consumed_kme_cddip3;
    im_available_t                  im_available_kme_cddip3;
   
    axi4s_dp_bus_t                  kme_cceip0_ob_out_post;
    axi4s_dp_bus_t                  kme_cceip1_ob_out_post;
    axi4s_dp_bus_t                  kme_cceip2_ob_out_post;
    axi4s_dp_bus_t                  kme_cceip3_ob_out_post;
    axi4s_dp_bus_t                  kme_cddip0_ob_out_post;
    axi4s_dp_bus_t                  kme_cddip1_ob_out_post;
    axi4s_dp_bus_t                  kme_cddip2_ob_out_post;
    axi4s_dp_bus_t                  kme_cddip3_ob_out_post;

    logic [`CR_KME_C_BLKID_REVID_T_DECL] blkid_revid_config;
   
    
    always_comb begin
       cceip0_im_din.desc.eob             = kme_cceip0_ob_out_pre.tuser[1];
       cceip0_im_din.desc.bytes_vld       = kme_cceip0_ob_out_pre.tstrb;  
       cceip0_im_din.desc.im_meta[22:15]  = 8'd0;
       cceip0_im_din.desc.im_meta[14]     = kme_cceip0_ob_out_pre.tid;
       cceip0_im_din.desc.im_meta[13:6]   = kme_cceip0_ob_out_pre.tuser;
       cceip0_im_din.desc.im_meta[5:0]    = 6'd0;                     
       cceip0_im_din.data                 = kme_cceip0_ob_out_pre.tdata;
       
       cceip1_im_din.desc.eob             = kme_cceip1_ob_out_pre.tuser[1];
       cceip1_im_din.desc.bytes_vld       = kme_cceip1_ob_out_pre.tstrb;  
       cceip1_im_din.desc.im_meta[22:15]  = 8'd0;
       cceip1_im_din.desc.im_meta[14]     = kme_cceip1_ob_out_pre.tid;
       cceip1_im_din.desc.im_meta[13:6]   = kme_cceip1_ob_out_pre.tuser;
       cceip1_im_din.desc.im_meta[5:0]    = 6'd0;                     
       cceip1_im_din.data                 = kme_cceip1_ob_out_pre.tdata;
       
       cceip2_im_din.desc.eob             = kme_cceip2_ob_out_pre.tuser[1];
       cceip2_im_din.desc.bytes_vld       = kme_cceip2_ob_out_pre.tstrb;  
       cceip2_im_din.desc.im_meta[22:15]  = 8'd0;
       cceip2_im_din.desc.im_meta[14]     = kme_cceip2_ob_out_pre.tid;
       cceip2_im_din.desc.im_meta[13:6]   = kme_cceip2_ob_out_pre.tuser;
       cceip2_im_din.desc.im_meta[5:0]    = 6'd0;                     
       cceip2_im_din.data                 = kme_cceip2_ob_out_pre.tdata;
       
       cceip3_im_din.desc.eob             = kme_cceip3_ob_out_pre.tuser[1];
       cceip3_im_din.desc.bytes_vld       = kme_cceip3_ob_out_pre.tstrb;  
       cceip3_im_din.desc.im_meta[22:15]  = 8'd0;
       cceip3_im_din.desc.im_meta[14]     = kme_cceip3_ob_out_pre.tid;
       cceip3_im_din.desc.im_meta[13:6]   = kme_cceip3_ob_out_pre.tuser;
       cceip3_im_din.desc.im_meta[5:0]    = 6'd0;                     
       cceip3_im_din.data                 = kme_cceip3_ob_out_pre.tdata;
       
       cddip0_im_din.desc.eob             = kme_cddip0_ob_out_pre.tuser[1];
       cddip0_im_din.desc.bytes_vld       = kme_cddip0_ob_out_pre.tstrb;  
       cddip0_im_din.desc.im_meta[22:15]  = 8'd0;
       cddip0_im_din.desc.im_meta[14]     = kme_cddip0_ob_out_pre.tid;
       cddip0_im_din.desc.im_meta[13:6]   = kme_cddip0_ob_out_pre.tuser;
       cddip0_im_din.desc.im_meta[5:0]    = 6'd0;                     
       cddip0_im_din.data                 = kme_cddip0_ob_out_pre.tdata;
       
       cddip1_im_din.desc.eob             = kme_cddip1_ob_out_pre.tuser[1];
       cddip1_im_din.desc.bytes_vld       = kme_cddip1_ob_out_pre.tstrb;  
       cddip1_im_din.desc.im_meta[22:15]  = 8'd0;
       cddip1_im_din.desc.im_meta[14]     = kme_cddip1_ob_out_pre.tid;
       cddip1_im_din.desc.im_meta[13:6]   = kme_cddip1_ob_out_pre.tuser;
       cddip1_im_din.desc.im_meta[5:0]    = 6'd0;                     
       cddip1_im_din.data                 = kme_cddip1_ob_out_pre.tdata;
       
       cddip2_im_din.desc.eob             = kme_cddip2_ob_out_pre.tuser[1];
       cddip2_im_din.desc.bytes_vld       = kme_cddip2_ob_out_pre.tstrb;  
       cddip2_im_din.desc.im_meta[22:15]  = 8'd0;
       cddip2_im_din.desc.im_meta[14]     = kme_cddip2_ob_out_pre.tid;
       cddip2_im_din.desc.im_meta[13:6]   = kme_cddip2_ob_out_pre.tuser;
       cddip2_im_din.desc.im_meta[5:0]    = 6'd0;                     
       cddip2_im_din.data                 = kme_cddip2_ob_out_pre.tdata;
       
       cddip3_im_din.desc.eob             = kme_cddip3_ob_out_pre.tuser[1];
       cddip3_im_din.desc.bytes_vld       = kme_cddip3_ob_out_pre.tstrb;  
       cddip3_im_din.desc.im_meta[22:15]  = 8'd0;
       cddip3_im_din.desc.im_meta[14]     = kme_cddip3_ob_out_pre.tid;
       cddip3_im_din.desc.im_meta[13:6]   = kme_cddip3_ob_out_pre.tuser;
       cddip3_im_din.desc.im_meta[5:0]    = 6'd0;                     
       cddip3_im_din.data                 = kme_cddip3_ob_out_pre.tdata;
    end 
    
    
    
    
    
    

    
    revid_t revid_wire;
      
    CR_TIE_CELL revid_wire_0 (.ob(revid_wire.f.revid[0]), .o());
    CR_TIE_CELL revid_wire_1 (.ob(revid_wire.f.revid[1]), .o());
    CR_TIE_CELL revid_wire_2 (.ob(revid_wire.f.revid[2]), .o());
    CR_TIE_CELL revid_wire_3 (.ob(revid_wire.f.revid[3]), .o());
    CR_TIE_CELL revid_wire_4 (.ob(revid_wire.f.revid[4]), .o());
    CR_TIE_CELL revid_wire_5 (.ob(revid_wire.f.revid[5]), .o());
    CR_TIE_CELL revid_wire_6 (.ob(revid_wire.f.revid[6]), .o());
    CR_TIE_CELL revid_wire_7 (.ob(revid_wire.f.revid[7]), .o());

   always_comb
     blkid_revid_config                = {16'hcf00, 8'd0, revid_wire}; 
    
    

    
    cr_kme_regs
    u_cr_kme_regs (
                   
                   .o_rd_data           (locl_rd_data[31:0]),    
                   .o_ack               (locl_ack),              
                   .o_err_ack           (locl_err_ack),          
                   .o_spare_config      ({spare.f.spare[31:7], kdf_test_mode_en, always_validate_kim_ref, manual_txc, spare.f.spare[3], o_tready_override_val, o_disable_ckv_kim_ism_reads, o_send_kme_ib_beat}), 
                   .o_cceip0_out_ia_wdata_part0(cceip0_out_ia_wdata.r.part0), 
                   .o_cceip0_out_ia_wdata_part1(cceip0_out_ia_wdata.r.part1), 
                   .o_cceip0_out_ia_wdata_part2(cceip0_out_ia_wdata.r.part2), 
                   .o_cceip0_out_ia_config(cceip0_out_ia_config), 
                   .o_cceip0_out_im_config(cceip0_out_im_config), 
                   .o_cceip0_out_im_read_done(),                 
                   .o_cceip1_out_ia_wdata_part0(cceip1_out_ia_wdata.r.part0), 
                   .o_cceip1_out_ia_wdata_part1(cceip1_out_ia_wdata.r.part1), 
                   .o_cceip1_out_ia_wdata_part2(cceip1_out_ia_wdata.r.part2), 
                   .o_cceip1_out_ia_config(cceip1_out_ia_config), 
                   .o_cceip1_out_im_config(cceip1_out_im_config), 
                   .o_cceip1_out_im_read_done(),                 
                   .o_cceip2_out_ia_wdata_part0(cceip2_out_ia_wdata.r.part0), 
                   .o_cceip2_out_ia_wdata_part1(cceip2_out_ia_wdata.r.part1), 
                   .o_cceip2_out_ia_wdata_part2(cceip2_out_ia_wdata.r.part2), 
                   .o_cceip2_out_ia_config(cceip2_out_ia_config), 
                   .o_cceip2_out_im_config(cceip2_out_im_config), 
                   .o_cceip2_out_im_read_done(),                 
                   .o_cceip3_out_ia_wdata_part0(cceip3_out_ia_wdata.r.part0), 
                   .o_cceip3_out_ia_wdata_part1(cceip3_out_ia_wdata.r.part1), 
                   .o_cceip3_out_ia_wdata_part2(cceip3_out_ia_wdata.r.part2), 
                   .o_cceip3_out_ia_config(cceip3_out_ia_config), 
                   .o_cceip3_out_im_config(cceip3_out_im_config), 
                   .o_cceip3_out_im_read_done(),                 
                   .o_cddip0_out_ia_wdata_part0(cddip0_out_ia_wdata.r.part0), 
                   .o_cddip0_out_ia_wdata_part1(cddip0_out_ia_wdata.r.part1), 
                   .o_cddip0_out_ia_wdata_part2(cddip0_out_ia_wdata.r.part2), 
                   .o_cddip0_out_ia_config(cddip0_out_ia_config), 
                   .o_cddip0_out_im_config(cddip0_out_im_config), 
                   .o_cddip0_out_im_read_done(),                 
                   .o_cddip1_out_ia_wdata_part0(cddip1_out_ia_wdata.r.part0), 
                   .o_cddip1_out_ia_wdata_part1(cddip1_out_ia_wdata.r.part1), 
                   .o_cddip1_out_ia_wdata_part2(cddip1_out_ia_wdata.r.part2), 
                   .o_cddip1_out_ia_config(cddip1_out_ia_config), 
                   .o_cddip1_out_im_config(cddip1_out_im_config), 
                   .o_cddip1_out_im_read_done(),                 
                   .o_cddip2_out_ia_wdata_part0(cddip2_out_ia_wdata.r.part0), 
                   .o_cddip2_out_ia_wdata_part1(cddip2_out_ia_wdata.r.part1), 
                   .o_cddip2_out_ia_wdata_part2(cddip2_out_ia_wdata.r.part2), 
                   .o_cddip2_out_ia_config(cddip2_out_ia_config), 
                   .o_cddip2_out_im_config(cddip2_out_im_config), 
                   .o_cddip2_out_im_read_done(),                 
                   .o_cddip3_out_ia_wdata_part0(cddip3_out_ia_wdata.r.part0), 
                   .o_cddip3_out_ia_wdata_part1(cddip3_out_ia_wdata.r.part1), 
                   .o_cddip3_out_ia_wdata_part2(cddip3_out_ia_wdata.r.part2), 
                   .o_cddip3_out_ia_config(cddip3_out_ia_config), 
                   .o_cddip3_out_im_config(cddip3_out_im_config), 
                   .o_cddip3_out_im_read_done(),                 
                   .o_ckv_ia_wdata_part0(o_ckv_ia_wdata_part0[`CR_KME_C_CKV_PART0_T_DECL]),
                   .o_ckv_ia_wdata_part1(o_ckv_ia_wdata_part1[`CR_KME_C_CKV_PART1_T_DECL]),
                   .o_ckv_ia_config     (o_ckv_ia_config[`CR_KME_C_CKV_IA_CONFIG_T_DECL]),
                   .o_kim_ia_wdata_part0(o_kim_ia_wdata_part0[`CR_KME_C_KIM_ENTRY0_T_DECL]),
                   .o_kim_ia_wdata_part1(o_kim_ia_wdata_part1[`CR_KME_C_KIM_ENTRY1_T_DECL]),
                   .o_kim_ia_config     (o_kim_ia_config[`CR_KME_C_KIM_IA_CONFIG_T_DECL]),
                   .o_label0_config     ({labels[0].guid_size, labels[0].label_size, labels[0].delimiter_valid, labels[0].delimiter}), 
                   .o_label0_data7      (labels[0].label[255:224]), 
                   .o_label0_data6      (labels[0].label[223:192]), 
                   .o_label0_data5      (labels[0].label[191:160]), 
                   .o_label0_data4      (labels[0].label[159:128]), 
                   .o_label0_data3      (labels[0].label[127:96]), 
                   .o_label0_data2      (labels[0].label[95:64]), 
                   .o_label0_data1      (labels[0].label[63:32]), 
                   .o_label0_data0      (labels[0].label[31:0]), 
                   .o_label1_config     ({labels[1].guid_size, labels[1].label_size, labels[1].delimiter_valid, labels[1].delimiter}), 
                   .o_label1_data7      (labels[1].label[255:224]), 
                   .o_label1_data6      (labels[1].label[223:192]), 
                   .o_label1_data5      (labels[1].label[191:160]), 
                   .o_label1_data4      (labels[1].label[159:128]), 
                   .o_label1_data3      (labels[1].label[127:96]), 
                   .o_label1_data2      (labels[1].label[95:64]), 
                   .o_label1_data1      (labels[1].label[63:32]), 
                   .o_label1_data0      (labels[1].label[31:0]), 
                   .o_label2_config     ({labels[2].guid_size, labels[2].label_size, labels[2].delimiter_valid, labels[2].delimiter}), 
                   .o_label2_data7      (labels[2].label[255:224]), 
                   .o_label2_data6      (labels[2].label[223:192]), 
                   .o_label2_data5      (labels[2].label[191:160]), 
                   .o_label2_data4      (labels[2].label[159:128]), 
                   .o_label2_data3      (labels[2].label[127:96]), 
                   .o_label2_data2      (labels[2].label[95:64]), 
                   .o_label2_data1      (labels[2].label[63:32]), 
                   .o_label2_data0      (labels[2].label[31:0]), 
                   .o_label3_config     ({labels[3].guid_size, labels[3].label_size, labels[3].delimiter_valid, labels[3].delimiter}), 
                   .o_label3_data7      (labels[3].label[255:224]), 
                   .o_label3_data6      (labels[3].label[223:192]), 
                   .o_label3_data5      (labels[3].label[191:160]), 
                   .o_label3_data4      (labels[3].label[159:128]), 
                   .o_label3_data3      (labels[3].label[127:96]), 
                   .o_label3_data2      (labels[3].label[95:64]), 
                   .o_label3_data1      (labels[3].label[63:32]), 
                   .o_label3_data0      (labels[3].label[31:0]), 
                   .o_label4_config     ({labels[4].guid_size, labels[4].label_size, labels[4].delimiter_valid, labels[4].delimiter}), 
                   .o_label4_data7      (labels[4].label[255:224]), 
                   .o_label4_data6      (labels[4].label[223:192]), 
                   .o_label4_data5      (labels[4].label[191:160]), 
                   .o_label4_data4      (labels[4].label[159:128]), 
                   .o_label4_data3      (labels[4].label[127:96]), 
                   .o_label4_data2      (labels[4].label[95:64]), 
                   .o_label4_data1      (labels[4].label[63:32]), 
                   .o_label4_data0      (labels[4].label[31:0]), 
                   .o_label5_config     ({labels[5].guid_size, labels[5].label_size, labels[5].delimiter_valid, labels[5].delimiter}), 
                   .o_label5_data7      (labels[5].label[255:224]), 
                   .o_label5_data6      (labels[5].label[223:192]), 
                   .o_label5_data5      (labels[5].label[191:160]), 
                   .o_label5_data4      (labels[5].label[159:128]), 
                   .o_label5_data3      (labels[5].label[127:96]), 
                   .o_label5_data2      (labels[5].label[95:64]), 
                   .o_label5_data1      (labels[5].label[63:32]), 
                   .o_label5_data0      (labels[5].label[31:0]), 
                   .o_label6_config     ({labels[6].guid_size, labels[6].label_size, labels[6].delimiter_valid, labels[6].delimiter}), 
                   .o_label6_data7      (labels[6].label[255:224]), 
                   .o_label6_data6      (labels[6].label[223:192]), 
                   .o_label6_data5      (labels[6].label[191:160]), 
                   .o_label6_data4      (labels[6].label[159:128]), 
                   .o_label6_data3      (labels[6].label[127:96]), 
                   .o_label6_data2      (labels[6].label[95:64]), 
                   .o_label6_data1      (labels[6].label[63:32]), 
                   .o_label6_data0      (labels[6].label[31:0]), 
                   .o_label7_config     ({labels[7].guid_size, labels[7].label_size, labels[7].delimiter_valid, labels[7].delimiter}), 
                   .o_label7_data7      (labels[7].label[255:224]), 
                   .o_label7_data6      (labels[7].label[223:192]), 
                   .o_label7_data5      (labels[7].label[191:160]), 
                   .o_label7_data4      (labels[7].label[159:128]), 
                   .o_label7_data3      (labels[7].label[127:96]), 
                   .o_label7_data2      (labels[7].label[95:64]), 
                   .o_label7_data1      (labels[7].label[63:32]), 
                   .o_label7_data0      (labels[7].label[31:0]), 
                   .o_kdf_drbg_ctrl     (o_kdf_drbg_ctrl[`CR_KME_C_KDF_DRBG_CTRL_T_DECL]),
                   .o_kdf_drbg_seed_0_state_key_31_0(o_kdf_drbg_seed_0_state_key_31_0[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                   .o_kdf_drbg_seed_0_state_key_63_32(o_kdf_drbg_seed_0_state_key_63_32[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                   .o_kdf_drbg_seed_0_state_key_95_64(o_kdf_drbg_seed_0_state_key_95_64[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                   .o_kdf_drbg_seed_0_state_key_127_96(o_kdf_drbg_seed_0_state_key_127_96[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                   .o_kdf_drbg_seed_0_state_key_159_128(o_kdf_drbg_seed_0_state_key_159_128[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                   .o_kdf_drbg_seed_0_state_key_191_160(o_kdf_drbg_seed_0_state_key_191_160[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                   .o_kdf_drbg_seed_0_state_key_223_192(o_kdf_drbg_seed_0_state_key_223_192[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                   .o_kdf_drbg_seed_0_state_key_255_224(o_kdf_drbg_seed_0_state_key_255_224[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                   .o_kdf_drbg_seed_0_state_value_31_0(o_kdf_drbg_seed_0_state_value_31_0[`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]),
                   .o_kdf_drbg_seed_0_state_value_63_32(o_kdf_drbg_seed_0_state_value_63_32[`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]),
                   .o_kdf_drbg_seed_0_state_value_95_64(o_kdf_drbg_seed_0_state_value_95_64[`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]),
                   .o_kdf_drbg_seed_0_state_value_127_96(o_kdf_drbg_seed_0_state_value_127_96[`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]),
                   .o_kdf_drbg_seed_0_reseed_interval_0(o_kdf_drbg_seed_0_reseed_interval_0[`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_0_T_DECL]),
                   .o_kdf_drbg_seed_0_reseed_interval_1(o_kdf_drbg_seed_0_reseed_interval_1[`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_1_T_DECL]),
                   .o_kdf_drbg_seed_1_state_key_31_0(o_kdf_drbg_seed_1_state_key_31_0[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                   .o_kdf_drbg_seed_1_state_key_63_32(o_kdf_drbg_seed_1_state_key_63_32[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                   .o_kdf_drbg_seed_1_state_key_95_64(o_kdf_drbg_seed_1_state_key_95_64[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                   .o_kdf_drbg_seed_1_state_key_127_96(o_kdf_drbg_seed_1_state_key_127_96[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                   .o_kdf_drbg_seed_1_state_key_159_128(o_kdf_drbg_seed_1_state_key_159_128[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                   .o_kdf_drbg_seed_1_state_key_191_160(o_kdf_drbg_seed_1_state_key_191_160[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                   .o_kdf_drbg_seed_1_state_key_223_192(o_kdf_drbg_seed_1_state_key_223_192[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                   .o_kdf_drbg_seed_1_state_key_255_224(o_kdf_drbg_seed_1_state_key_255_224[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                   .o_kdf_drbg_seed_1_state_value_31_0(o_kdf_drbg_seed_1_state_value_31_0[`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]),
                   .o_kdf_drbg_seed_1_state_value_63_32(o_kdf_drbg_seed_1_state_value_63_32[`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]),
                   .o_kdf_drbg_seed_1_state_value_95_64(o_kdf_drbg_seed_1_state_value_95_64[`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]),
                   .o_kdf_drbg_seed_1_state_value_127_96(o_kdf_drbg_seed_1_state_value_127_96[`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]),
                   .o_kdf_drbg_seed_1_reseed_interval_0(o_kdf_drbg_seed_1_reseed_interval_0[`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_0_T_DECL]),
                   .o_kdf_drbg_seed_1_reseed_interval_1(o_kdf_drbg_seed_1_reseed_interval_1[`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_1_T_DECL]),
                   .o_interrupt_status  (),                      
                   .o_interrupt_mask    (o_interrupt_mask[`CR_KME_C_INT_MASK_T_DECL]),
                   .o_engine_sticky_status(o_engine_sticky_status[`CR_KME_C_STICKY_ENG_BP_T_DECL]),
                   .o_bimc_monitor_mask (o_bimc_monitor_mask[`CR_KME_C_BIMC_MONITOR_MASK_T_DECL]),
                   .o_bimc_ecc_uncorrectable_error_cnt(o_bimc_ecc_uncorrectable_error_cnt[`CR_KME_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]),
                   .o_bimc_ecc_correctable_error_cnt(o_bimc_ecc_correctable_error_cnt[`CR_KME_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]),
                   .o_bimc_parity_error_cnt(o_bimc_parity_error_cnt[`CR_KME_C_BIMC_PARITY_ERROR_CNT_T_DECL]),
                   .o_bimc_global_config(o_bimc_global_config[`CR_KME_C_BIMC_GLOBAL_CONFIG_T_DECL]),
                   .o_bimc_eccpar_debug (o_bimc_eccpar_debug[`CR_KME_C_BIMC_ECCPAR_DEBUG_T_DECL]),
                   .o_bimc_cmd2         (o_bimc_cmd2[`CR_KME_C_BIMC_CMD2_T_DECL]),
                   .o_bimc_cmd1         (o_bimc_cmd1[`CR_KME_C_BIMC_CMD1_T_DECL]),
                   .o_bimc_cmd0         (o_bimc_cmd0[`CR_KME_C_BIMC_CMD0_T_DECL]),
                   .o_bimc_rxcmd2       (o_bimc_rxcmd2[`CR_KME_C_BIMC_RXCMD2_T_DECL]),
                   .o_bimc_rxrsp2       (o_bimc_rxrsp2[`CR_KME_C_BIMC_RXRSP2_T_DECL]),
                   .o_bimc_pollrsp2     (o_bimc_pollrsp2[`CR_KME_C_BIMC_POLLRSP2_T_DECL]),
                   .o_bimc_dbgcmd2      (o_bimc_dbgcmd2[`CR_KME_C_BIMC_DBGCMD2_T_DECL]),
                   .o_im_consumed       (),                      
                   .o_tready_override   (tready_override),       
                   .o_regs_sa_ctrl      (regs_sa_ctrl[`CR_KME_C_SA_CTRL_DEP_T_DECL]), 
                   .o_sa_snapshot_ia_wdata_part0(sa_snapshot_ia_wdata.r.part0), 
                   .o_sa_snapshot_ia_wdata_part1(sa_snapshot_ia_wdata.r.part1), 
                   .o_sa_snapshot_ia_config(sa_snapshot_ia_config), 
                   .o_sa_count_ia_wdata_part0(sa_count_ia_wdata.r.part0), 
                   .o_sa_count_ia_wdata_part1(sa_count_ia_wdata.r.part1), 
                   .o_sa_count_ia_config(sa_count_ia_config),    
                   .o_cceip_encrypt_kop_fifo_override(cceip_encrypt_kop_fifo_override), 
                   .o_cceip_validate_kop_fifo_override(cceip_validate_kop_fifo_override), 
                   .o_cddip_decrypt_kop_fifo_override(cddip_decrypt_kop_fifo_override), 
                   .o_sa_global_ctrl    (sa_global_ctrl),        
                   .o_sa_ctrl_ia_wdata_part0(sa_ctrl_ia_wdata.r.part0), 
                   .o_sa_ctrl_ia_config (sa_ctrl_ia_config),     
                   .o_kdf_test_key_size_config(kdf_test_key_size[`CR_KME_C_KDF_TEST_KEY_SIZE_T_DECL]), 
                   .o_reg_written       (wr_stb),                
                   .o_reg_read          (),                      
                   .o_reg_wr_data       (wr_data[31:0]),         
                   .o_reg_addr          (reg_addr),              
                   
                   .clk                 (clk),
                   .i_reset_            (rst_n),                 
                   .i_sw_init           (1'd0),                  
                   .i_addr              (locl_addr),             
                   .i_wr_strb           (locl_wr_strb),          
                   .i_wr_data           (locl_wr_data),          
                   .i_rd_strb           (locl_rd_strb),          
                   .i_blkid_revid_config(blkid_revid_config),    
                   .i_revision_config   (revid_wire),            
                   .i_spare_config      ({spare.f.spare[31:7], kdf_test_mode_en,always_validate_kim_ref, manual_txc, spare.f.spare[3], o_tready_override_val, disable_ckv_kim_ism_reads, send_kme_ib_beat}), 
                   .i_cceip0_out_ia_capability(cceip0_out_ia_capability[`CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_DECL]), 
                   .i_cceip0_out_ia_status(cceip0_out_ia_status[`CR_KME_C_CCEIP0_OUT_IA_STATUS_T_DECL]), 
                   .i_cceip0_out_ia_rdata_part0((disable_ckv_kim_ism_reads) ? 32'b0 : cceip0_out_ia_rdata.r.part0), 
                   .i_cceip0_out_ia_rdata_part1((disable_ckv_kim_ism_reads) ? 32'b0 : cceip0_out_ia_rdata.r.part1), 
                   .i_cceip0_out_ia_rdata_part2((disable_ckv_kim_ism_reads) ? 32'b0 : cceip0_out_ia_rdata.r.part2), 
                   .i_cceip0_out_im_status(cceip0_out_im_status[`CR_KME_C_CCEIP0_OUT_IM_STATUS_T_DECL]), 
                   .i_cceip0_out_im_read_done(2'd0),             
                   .i_cceip1_out_ia_capability(cceip1_out_ia_capability[`CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_DECL]), 
                   .i_cceip1_out_ia_status(cceip1_out_ia_status[`CR_KME_C_CCEIP1_OUT_IA_STATUS_T_DECL]), 
                   .i_cceip1_out_ia_rdata_part0((disable_ckv_kim_ism_reads) ? 32'b0 : cceip1_out_ia_rdata.r.part0), 
                   .i_cceip1_out_ia_rdata_part1((disable_ckv_kim_ism_reads) ? 32'b0 : cceip1_out_ia_rdata.r.part1), 
                   .i_cceip1_out_ia_rdata_part2((disable_ckv_kim_ism_reads) ? 32'b0 : cceip1_out_ia_rdata.r.part2), 
                   .i_cceip1_out_im_status(cceip1_out_im_status[`CR_KME_C_CCEIP1_OUT_IM_STATUS_T_DECL]), 
                   .i_cceip1_out_im_read_done(2'd0),             
                   .i_cceip2_out_ia_capability(cceip2_out_ia_capability[`CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_DECL]), 
                   .i_cceip2_out_ia_status(cceip2_out_ia_status[`CR_KME_C_CCEIP2_OUT_IA_STATUS_T_DECL]), 
                   .i_cceip2_out_ia_rdata_part0((disable_ckv_kim_ism_reads) ? 32'b0 : cceip2_out_ia_rdata.r.part0), 
                   .i_cceip2_out_ia_rdata_part1((disable_ckv_kim_ism_reads) ? 32'b0 : cceip2_out_ia_rdata.r.part1), 
                   .i_cceip2_out_ia_rdata_part2((disable_ckv_kim_ism_reads) ? 32'b0 : cceip2_out_ia_rdata.r.part2), 
                   .i_cceip2_out_im_status(cceip2_out_im_status[`CR_KME_C_CCEIP2_OUT_IM_STATUS_T_DECL]), 
                   .i_cceip2_out_im_read_done(2'd0),             
                   .i_cceip3_out_ia_capability(cceip3_out_ia_capability[`CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_DECL]), 
                   .i_cceip3_out_ia_status(cceip3_out_ia_status[`CR_KME_C_CCEIP3_OUT_IA_STATUS_T_DECL]), 
                   .i_cceip3_out_ia_rdata_part0((disable_ckv_kim_ism_reads) ? 32'b0 : cceip3_out_ia_rdata.r.part0), 
                   .i_cceip3_out_ia_rdata_part1((disable_ckv_kim_ism_reads) ? 32'b0 : cceip3_out_ia_rdata.r.part1), 
                   .i_cceip3_out_ia_rdata_part2((disable_ckv_kim_ism_reads) ? 32'b0 : cceip3_out_ia_rdata.r.part2), 
                   .i_cceip3_out_im_status(cceip3_out_im_status[`CR_KME_C_CCEIP3_OUT_IM_STATUS_T_DECL]), 
                   .i_cceip3_out_im_read_done(2'd0),             
                   .i_cddip0_out_ia_capability(cddip0_out_ia_capability[`CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_DECL]), 
                   .i_cddip0_out_ia_status(cddip0_out_ia_status[`CR_KME_C_CDDIP0_OUT_IA_STATUS_T_DECL]), 
                   .i_cddip0_out_ia_rdata_part0((disable_ckv_kim_ism_reads) ? 32'b0 : cddip0_out_ia_rdata.r.part0), 
                   .i_cddip0_out_ia_rdata_part1((disable_ckv_kim_ism_reads) ? 32'b0 : cddip0_out_ia_rdata.r.part1), 
                   .i_cddip0_out_ia_rdata_part2((disable_ckv_kim_ism_reads) ? 32'b0 : cddip0_out_ia_rdata.r.part2), 
                   .i_cddip0_out_im_status(cddip0_out_im_status[`CR_KME_C_CDDIP0_OUT_IM_STATUS_T_DECL]), 
                   .i_cddip0_out_im_read_done(2'd0),             
                   .i_cddip1_out_ia_capability(cddip1_out_ia_capability[`CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_DECL]), 
                   .i_cddip1_out_ia_status(cddip1_out_ia_status[`CR_KME_C_CDDIP1_OUT_IA_STATUS_T_DECL]), 
                   .i_cddip1_out_ia_rdata_part0((disable_ckv_kim_ism_reads) ? 32'b0 : cddip1_out_ia_rdata.r.part0), 
                   .i_cddip1_out_ia_rdata_part1((disable_ckv_kim_ism_reads) ? 32'b0 : cddip1_out_ia_rdata.r.part1), 
                   .i_cddip1_out_ia_rdata_part2((disable_ckv_kim_ism_reads) ? 32'b0 : cddip1_out_ia_rdata.r.part2), 
                   .i_cddip1_out_im_status(cddip1_out_im_status[`CR_KME_C_CDDIP1_OUT_IM_STATUS_T_DECL]), 
                   .i_cddip1_out_im_read_done(2'd0),             
                   .i_cddip2_out_ia_capability(cddip2_out_ia_capability[`CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_DECL]), 
                   .i_cddip2_out_ia_status(cddip2_out_ia_status[`CR_KME_C_CDDIP2_OUT_IA_STATUS_T_DECL]), 
                   .i_cddip2_out_ia_rdata_part0((disable_ckv_kim_ism_reads) ? 32'b0 : cddip2_out_ia_rdata.r.part0), 
                   .i_cddip2_out_ia_rdata_part1((disable_ckv_kim_ism_reads) ? 32'b0 : cddip2_out_ia_rdata.r.part1), 
                   .i_cddip2_out_ia_rdata_part2((disable_ckv_kim_ism_reads) ? 32'b0 : cddip2_out_ia_rdata.r.part2), 
                   .i_cddip2_out_im_status(cddip2_out_im_status[`CR_KME_C_CDDIP2_OUT_IM_STATUS_T_DECL]), 
                   .i_cddip2_out_im_read_done(2'd0),             
                   .i_cddip3_out_ia_capability(cddip3_out_ia_capability[`CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_DECL]), 
                   .i_cddip3_out_ia_status(cddip3_out_ia_status[`CR_KME_C_CDDIP3_OUT_IA_STATUS_T_DECL]), 
                   .i_cddip3_out_ia_rdata_part0((disable_ckv_kim_ism_reads) ? 32'b0 : cddip3_out_ia_rdata.r.part0), 
                   .i_cddip3_out_ia_rdata_part1((disable_ckv_kim_ism_reads) ? 32'b0 : cddip3_out_ia_rdata.r.part1), 
                   .i_cddip3_out_ia_rdata_part2((disable_ckv_kim_ism_reads) ? 32'b0 : cddip3_out_ia_rdata.r.part2), 
                   .i_cddip3_out_im_status(cddip3_out_im_status[`CR_KME_C_CDDIP3_OUT_IM_STATUS_T_DECL]), 
                   .i_cddip3_out_im_read_done(2'd0),             
                   .i_ckv_ia_capability (ckv_ia_capability[`CR_KME_C_CKV_IA_CAPABILITY_T_DECL]), 
                   .i_ckv_ia_status     (ckv_ia_status[`CR_KME_C_CKV_IA_STATUS_T_DECL]), 
                   .i_ckv_ia_rdata_part0(ckv_ia_rdata_part0[`CR_KME_C_CKV_PART0_T_DECL]), 
                   .i_ckv_ia_rdata_part1(ckv_ia_rdata_part1[`CR_KME_C_CKV_PART1_T_DECL]), 
                   .i_kim_ia_capability (kim_ia_capability[`CR_KME_C_KIM_IA_CAPABILITY_T_DECL]), 
                   .i_kim_ia_status     (kim_ia_status[`CR_KME_C_KIM_IA_STATUS_T_DECL]), 
                   .i_kim_ia_rdata_part0(kim_ia_rdata_part0[`CR_KME_C_KIM_ENTRY0_T_DECL]), 
                   .i_kim_ia_rdata_part1(kim_ia_rdata_part1[`CR_KME_C_KIM_ENTRY1_T_DECL]), 
                   .i_kdf_drbg_ctrl     (kdf_drbg_ctrl[`CR_KME_C_KDF_DRBG_CTRL_T_DECL]), 
                   .i_interrupt_status  (interrupt_status[`CR_KME_C_INT_STATUS_T_DECL]), 
                   .i_engine_sticky_status(engine_sticky_status[`CR_KME_C_STICKY_ENG_BP_T_DECL]), 
                   .i_bimc_monitor      (bimc_monitor[`CR_KME_C_BIMC_MONITOR_T_DECL]), 
                   .i_bimc_ecc_uncorrectable_error_cnt(bimc_ecc_uncorrectable_error_cnt[`CR_KME_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]), 
                   .i_bimc_ecc_correctable_error_cnt(bimc_ecc_correctable_error_cnt[`CR_KME_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]), 
                   .i_bimc_parity_error_cnt(bimc_parity_error_cnt[`CR_KME_C_BIMC_PARITY_ERROR_CNT_T_DECL]), 
                   .i_bimc_global_config(bimc_global_config[`CR_KME_C_BIMC_GLOBAL_CONFIG_T_DECL]), 
                   .i_bimc_memid        (bimc_memid[`CR_KME_C_BIMC_MEMID_T_DECL]), 
                   .i_bimc_eccpar_debug (bimc_eccpar_debug[`CR_KME_C_BIMC_ECCPAR_DEBUG_T_DECL]), 
                   .i_bimc_cmd2         (bimc_cmd2[`CR_KME_C_BIMC_CMD2_T_DECL]), 
                   .i_bimc_rxcmd2       (bimc_rxcmd2[`CR_KME_C_BIMC_RXCMD2_T_DECL]), 
                   .i_bimc_rxcmd1       (bimc_rxcmd1[`CR_KME_C_BIMC_RXCMD1_T_DECL]), 
                   .i_bimc_rxcmd0       (bimc_rxcmd0[`CR_KME_C_BIMC_RXCMD0_T_DECL]), 
                   .i_bimc_rxrsp2       (bimc_rxrsp2[`CR_KME_C_BIMC_RXRSP2_T_DECL]), 
                   .i_bimc_rxrsp1       (bimc_rxrsp1[`CR_KME_C_BIMC_RXRSP1_T_DECL]), 
                   .i_bimc_rxrsp0       (bimc_rxrsp0[`CR_KME_C_BIMC_RXRSP0_T_DECL]), 
                   .i_bimc_pollrsp2     (bimc_pollrsp2[`CR_KME_C_BIMC_POLLRSP2_T_DECL]), 
                   .i_bimc_pollrsp1     (bimc_pollrsp1[`CR_KME_C_BIMC_POLLRSP1_T_DECL]), 
                   .i_bimc_pollrsp0     (bimc_pollrsp0[`CR_KME_C_BIMC_POLLRSP0_T_DECL]), 
                   .i_bimc_dbgcmd2      (bimc_dbgcmd2[`CR_KME_C_BIMC_DBGCMD2_T_DECL]), 
                   .i_bimc_dbgcmd1      (bimc_dbgcmd1[`CR_KME_C_BIMC_DBGCMD1_T_DECL]), 
                   .i_bimc_dbgcmd0      (bimc_dbgcmd0[`CR_KME_C_BIMC_DBGCMD0_T_DECL]), 
                   .i_im_available      (im_available[`CR_KME_C_IM_AVAILABLE_T_DECL]), 
                   .i_im_consumed       (`CR_KME_C_IM_AVAILABLE_T_WIDTH'd0), 
                   .i_tready_override   (tready_override[`CR_KME_C_TREADY_OVERRIDE_T_DECL]), 
                   .i_regs_sa_ctrl      (regs_sa_ctrl[`CR_KME_C_SA_CTRL_DEP_T_DECL]), 
                   .i_sa_snapshot_ia_capability(sa_snapshot_ia_capability[`CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_DECL]), 
                   .i_sa_snapshot_ia_status(sa_snapshot_ia_status[`CR_KME_C_SA_SNAPSHOT_IA_STATUS_T_DECL]), 
                   .i_sa_snapshot_ia_rdata_part0(sa_snapshot_ia_rdata.r.part0), 
                   .i_sa_snapshot_ia_rdata_part1(sa_snapshot_ia_rdata.r.part1), 
                   .i_sa_count_ia_capability(sa_count_ia_capability[`CR_KME_C_SA_COUNT_IA_CAPABILITY_T_DECL]), 
                   .i_sa_count_ia_status(sa_count_ia_status[`CR_KME_C_SA_COUNT_IA_STATUS_T_DECL]), 
                   .i_sa_count_ia_rdata_part0(sa_count_ia_rdata.r.part0), 
                   .i_sa_count_ia_rdata_part1(sa_count_ia_rdata.r.part1), 
                   .i_idle_components   (idle_components[`CR_KME_C_IDLE_T_DECL]), 
                   .i_sa_global_ctrl    (sa_global_ctrl[`CR_KME_C_SA_GLOBAL_CTRL_T_DECL]), 
                   .i_sa_ctrl_ia_capability(sa_ctrl_ia_capability[`CR_KME_C_SA_CTRL_IA_CAPABILITY_T_DECL]), 
                   .i_sa_ctrl_ia_status (sa_ctrl_ia_status[`CR_KME_C_SA_CTRL_IA_STATUS_T_DECL]), 
                   .i_sa_ctrl_ia_rdata_part0(sa_ctrl_ia_rdata.r.part0)); 

    
    
    

    nx_rbus_ring #
    (
     
        .N_RBUS_ADDR_BITS (`N_KME_RBUS_ADDR_BITS),  
        .N_LOCL_ADDR_BITS (`CR_KME_WIDTH),      
        .N_RBUS_DATA_BITS (`N_RBUS_DATA_BITS)   
    )
    u_nx_rbus_ring (
                    
                    .rbus_addr_o        (rbus_ring_o.addr),      
                    .rbus_wr_strb_o     (rbus_ring_o.wr_strb),   
                    .rbus_wr_data_o     (rbus_ring_o.wr_data),   
                    .rbus_rd_strb_o     (rbus_ring_o.rd_strb),   
                    .locl_addr_o        (locl_addr),             
                    .locl_wr_strb_o     (locl_wr_strb),          
                    .locl_wr_data_o     (locl_wr_data),          
                    .locl_rd_strb_o     (locl_rd_strb),          
                    .rbus_rd_data_o     (rbus_ring_o.rd_data),   
                    .rbus_ack_o         (rbus_ring_o.ack),       
                    .rbus_err_ack_o     (rbus_ring_o.err_ack),   
                    
                    .clk                (clk),
                    .rst_n              (rst_n),
                    .cfg_start_addr     (cfg_start_addr[`N_KME_RBUS_ADDR_BITS-1:0]), 
                    .cfg_end_addr       (cfg_end_addr[`N_KME_RBUS_ADDR_BITS-1:0]), 
                    .rbus_addr_i        (rbus_ring_i.addr),      
                    .rbus_wr_strb_i     (rbus_ring_i.wr_strb),   
                    .rbus_wr_data_i     (rbus_ring_i.wr_data),   
                    .rbus_rd_strb_i     (rbus_ring_i.rd_strb),   
                    .rbus_rd_data_i     (rbus_ring_i.rd_data),   
                    .rbus_ack_i         (rbus_ring_i.ack),       
                    .rbus_err_ack_i     (rbus_ring_i.err_ack),   
                    .locl_rd_data_i     (locl_rd_data),          
                    .locl_ack_i         (locl_ack),              
                    .locl_err_ack_i     (locl_err_ack));          


    nx_interface_monitor_pipe
    nx_interface_monitor_pipe_cceip0 
    (
        
        .ob_in_mod  (kme_cceip0_ob_in_mod), 
        .ob_out     (kme_cceip0_ob_out_post), 
        .im_vld     (cceip0_im_vld),
        
        .clk        (clk),
        .rst_n      (rst_n),
        .ob_out_pre (kme_cceip0_ob_out_pre), 
        .ob_in      ((tready_override.f.engine_0_tready_override) ? o_tready_override_val : kme_cceip0_ob_in), 
        .im_rdy     (cceip0_im_rdy)
    );
   
    nx_interface_monitor_pipe
    nx_interface_monitor_pipe_cceip1 
    (
        
        .ob_in_mod  (kme_cceip1_ob_in_mod), 
        .ob_out     (kme_cceip1_ob_out_post), 
        .im_vld     (cceip1_im_vld),
        
        .clk        (clk),
        .rst_n      (rst_n),
        .ob_out_pre (kme_cceip1_ob_out_pre), 
        .ob_in      ((tready_override.f.engine_1_tready_override) ? o_tready_override_val : kme_cceip1_ob_in),  
        .im_rdy     (cceip1_im_rdy)
    );
   
    nx_interface_monitor_pipe
    nx_interface_monitor_pipe_cceip2 
    (
        
        .ob_in_mod  (kme_cceip2_ob_in_mod), 
        .ob_out     (kme_cceip2_ob_out_post), 
        .im_vld     (cceip2_im_vld),
        
        .clk        (clk),
        .rst_n      (rst_n),
        .ob_out_pre (kme_cceip2_ob_out_pre), 
        .ob_in      ((tready_override.f.engine_2_tready_override) ? o_tready_override_val : kme_cceip2_ob_in),  
        .im_rdy     (cceip2_im_rdy)
    );
   
    nx_interface_monitor_pipe
    nx_interface_monitor_pipe_cceip3 
    (
        
        .ob_in_mod  (kme_cceip3_ob_in_mod), 
        .ob_out     (kme_cceip3_ob_out_post), 
        .im_vld     (cceip3_im_vld),
        
        .clk        (clk),
        .rst_n      (rst_n),
        .ob_out_pre (kme_cceip3_ob_out_pre), 
        .ob_in      ((tready_override.f.engine_3_tready_override) ? o_tready_override_val : kme_cceip3_ob_in),  
        .im_rdy     (cceip3_im_rdy)
    );
    
    nx_interface_monitor_pipe
    nx_interface_monitor_pipe_cddip0 
    (
        
        .ob_in_mod  (kme_cddip0_ob_in_mod), 
        .ob_out     (kme_cddip0_ob_out_post), 
        .im_vld     (cddip0_im_vld),
        
        .clk        (clk),
        .rst_n      (rst_n),
        .ob_out_pre (kme_cddip0_ob_out_pre), 
        .ob_in      ((tready_override.f.engine_4_tready_override) ? o_tready_override_val : kme_cddip0_ob_in),  
        .im_rdy     (cddip0_im_rdy)
    );
    
    nx_interface_monitor_pipe
    nx_interface_monitor_pipe_cddip1 
    (
        
        .ob_in_mod  (kme_cddip1_ob_in_mod), 
        .ob_out     (kme_cddip1_ob_out_post), 
        .im_vld     (cddip1_im_vld),
        
        .clk        (clk),
        .rst_n      (rst_n),
        .ob_out_pre (kme_cddip1_ob_out_pre), 
        .ob_in      ((tready_override.f.engine_5_tready_override) ? o_tready_override_val : kme_cddip1_ob_in),  
        .im_rdy     (cddip1_im_rdy)
    );
    
    nx_interface_monitor_pipe
    nx_interface_monitor_pipe_cddip2
    (
        
        .ob_in_mod  (kme_cddip2_ob_in_mod), 
        .ob_out     (kme_cddip2_ob_out_post), 
        .im_vld     (cddip2_im_vld),
        
        .clk        (clk),
        .rst_n      (rst_n),
        .ob_out_pre (kme_cddip2_ob_out_pre), 
        .ob_in      ((tready_override.f.engine_6_tready_override) ? o_tready_override_val : kme_cddip2_ob_in),  
        .im_rdy     (cddip2_im_rdy)
    );
    
    nx_interface_monitor_pipe
    nx_interface_monitor_pipe_cddip3 
    (
        
        .ob_in_mod  (kme_cddip3_ob_in_mod), 
        .ob_out     (kme_cddip3_ob_out_post), 
        .im_vld     (cddip3_im_vld),
        
        .clk        (clk),
        .rst_n      (rst_n),
        .ob_out_pre (kme_cddip3_ob_out_pre), 
        .ob_in      ((tready_override.f.engine_7_tready_override) ? o_tready_override_val : kme_cddip3_ob_in),  
        .im_rdy     (cddip3_im_rdy)
    );
    
     
    

    nx_interface_monitor #
    (
        .IN_FLIGHT       (5),                               
        .CMND_ADDRESS    (`CR_KME_CCEIP0_OUT_IA_CONFIG),    
        .STAT_ADDRESS    (`CR_KME_CCEIP0_OUT_IA_STATUS),    
        .IMRD_ADDRESS    (`CR_KME_CCEIP0_OUT_IM_READ_DONE), 
        .N_REG_ADDR_BITS (`CR_KME_WIDTH),                   
        .N_DATA_BITS     (`N_AXI_IM_WIDTH),                 
        .N_ENTRIES       (`N_AXI_IM_ENTRIES),               
        .SPECIALIZE      (1)                                
    )
    u_nx_interface_monitor_cceip0 (
                                   
                                   .stat_code           ({cceip0_out_ia_status.f.code}), 
                                   .stat_datawords      (cceip0_out_ia_status.f.datawords), 
                                   .stat_addr           (cceip0_out_ia_status.f.addr), 
                                   .capability_lst      (cceip0_out_ia_capability.r.part0[15:0]), 
                                   .capability_type     (cceip0_out_ia_capability.f.mem_type), 
                                   .rd_dat              (cceip0_out_ia_rdata), 
                                   .bimc_odat           (cceip1_ism_idat), 
                                   .bimc_osync          (cceip1_ism_isync), 
                                   .ro_uncorrectable_ecc_error(cceip0_ism_mbe), 
                                   .im_rdy              (cceip0_im_rdy), 
                                   .im_available        (im_available_kme_cceip0), 
                                   .im_status           (cceip0_out_im_status), 
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .reg_addr            (reg_addr),      
                                   .cmnd_op             (cceip0_out_ia_config.f.op), 
                                   .cmnd_addr           (cceip0_out_ia_config.f.addr), 
                                   .wr_stb              (wr_stb),
                                   .wr_dat              (cceip0_out_ia_wdata), 
                                   .ovstb               (ovstb),
                                   .lvm                 (lvm),
                                   .mlvm                (mlvm),
                                   .mrdten              (1'd0),          
                                   .bimc_rst_n          (bimc_rst_n),
                                   .bimc_isync          (cceip0_ism_bimc_isync), 
                                   .bimc_idat           (cceip0_ism_bimc_idat), 
                                   .im_din              (cceip0_im_din), 
                                   .im_vld              (cceip0_im_vld), 
                                   .im_consumed         (im_consumed_kme_cceip0), 
                                   .im_config           (cceip0_out_im_config)); 

    
    

    nx_interface_monitor #
    (
        .IN_FLIGHT       (5),                               
        .CMND_ADDRESS    (`CR_KME_CCEIP1_OUT_IA_CONFIG),    
        .STAT_ADDRESS    (`CR_KME_CCEIP1_OUT_IA_STATUS),    
        .IMRD_ADDRESS    (`CR_KME_CCEIP1_OUT_IM_READ_DONE), 
        .N_REG_ADDR_BITS (`CR_KME_WIDTH),                   
        .N_DATA_BITS     (`N_AXI_IM_WIDTH),                 
        .N_ENTRIES       (`N_AXI_IM_ENTRIES),               
        .SPECIALIZE      (1)                                
    )
    u_nx_interface_monitor_cceip1 (
                                   
                                   .stat_code           ({cceip1_out_ia_status.f.code}), 
                                   .stat_datawords      (cceip1_out_ia_status.f.datawords), 
                                   .stat_addr           (cceip1_out_ia_status.f.addr), 
                                   .capability_lst      (cceip1_out_ia_capability.r.part0[15:0]), 
                                   .capability_type     (cceip1_out_ia_capability.f.mem_type), 
                                   .rd_dat              (cceip1_out_ia_rdata), 
                                   .bimc_odat           (cceip2_ism_idat), 
                                   .bimc_osync          (cceip2_ism_isync), 
                                   .ro_uncorrectable_ecc_error(cceip1_ism_mbe), 
                                   .im_rdy              (cceip1_im_rdy), 
                                   .im_available        (im_available_kme_cceip1), 
                                   .im_status           (cceip1_out_im_status), 
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .reg_addr            (reg_addr),      
                                   .cmnd_op             (cceip1_out_ia_config.f.op), 
                                   .cmnd_addr           (cceip1_out_ia_config.f.addr), 
                                   .wr_stb              (wr_stb),
                                   .wr_dat              (cceip1_out_ia_wdata), 
                                   .ovstb               (ovstb),
                                   .lvm                 (lvm),
                                   .mlvm                (mlvm),
                                   .mrdten              (1'd0),          
                                   .bimc_rst_n          (bimc_rst_n),
                                   .bimc_isync          (cceip1_ism_isync), 
                                   .bimc_idat           (cceip1_ism_idat), 
                                   .im_din              (cceip1_im_din), 
                                   .im_vld              (cceip1_im_vld), 
                                   .im_consumed         (im_consumed_kme_cceip1), 
                                   .im_config           (cceip1_out_im_config)); 

     
    

    nx_interface_monitor #
    (
        .IN_FLIGHT       (5),                               
        .CMND_ADDRESS    (`CR_KME_CCEIP2_OUT_IA_CONFIG),    
        .STAT_ADDRESS    (`CR_KME_CCEIP2_OUT_IA_STATUS),    
        .IMRD_ADDRESS    (`CR_KME_CCEIP2_OUT_IM_READ_DONE), 
        .N_REG_ADDR_BITS (`CR_KME_WIDTH),                   
        .N_DATA_BITS     (`N_AXI_IM_WIDTH),                 
        .N_ENTRIES       (`N_AXI_IM_ENTRIES),               
        .SPECIALIZE      (1)                                
    )
    u_nx_interface_monitor_cceip2 (
                                   
                                   .stat_code           ({cceip2_out_ia_status.f.code}), 
                                   .stat_datawords      (cceip2_out_ia_status.f.datawords), 
                                   .stat_addr           (cceip2_out_ia_status.f.addr), 
                                   .capability_lst      (cceip2_out_ia_capability.r.part0[15:0]), 
                                   .capability_type     (cceip2_out_ia_capability.f.mem_type), 
                                   .rd_dat              (cceip2_out_ia_rdata), 
                                   .bimc_odat           (cceip3_ism_idat), 
                                   .bimc_osync          (cceip3_ism_isync), 
                                   .ro_uncorrectable_ecc_error(cceip2_ism_mbe), 
                                   .im_rdy              (cceip2_im_rdy), 
                                   .im_available        (im_available_kme_cceip2), 
                                   .im_status           (cceip2_out_im_status), 
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .reg_addr            (reg_addr),      
                                   .cmnd_op             (cceip2_out_ia_config.f.op), 
                                   .cmnd_addr           (cceip2_out_ia_config.f.addr), 
                                   .wr_stb              (wr_stb),
                                   .wr_dat              (cceip2_out_ia_wdata), 
                                   .ovstb               (ovstb),
                                   .lvm                 (lvm),
                                   .mlvm                (mlvm),
                                   .mrdten              (1'd0),          
                                   .bimc_rst_n          (bimc_rst_n),
                                   .bimc_isync          (cceip2_ism_isync), 
                                   .bimc_idat           (cceip2_ism_idat), 
                                   .im_din              (cceip2_im_din), 
                                   .im_vld              (cceip2_im_vld), 
                                   .im_consumed         (im_consumed_kme_cceip2), 
                                   .im_config           (cceip2_out_im_config)); 

     
    

    nx_interface_monitor #
    (
        .IN_FLIGHT       (5),                               
        .CMND_ADDRESS    (`CR_KME_CCEIP3_OUT_IA_CONFIG),    
        .STAT_ADDRESS    (`CR_KME_CCEIP3_OUT_IA_STATUS),    
        .IMRD_ADDRESS    (`CR_KME_CCEIP3_OUT_IM_READ_DONE), 
        .N_REG_ADDR_BITS (`CR_KME_WIDTH),                   
        .N_DATA_BITS     (`N_AXI_IM_WIDTH),                 
        .N_ENTRIES       (`N_AXI_IM_ENTRIES),               
        .SPECIALIZE      (1)                                
    )
    u_nx_interface_monitor_cceip3 (
                                   
                                   .stat_code           ({cceip3_out_ia_status.f.code}), 
                                   .stat_datawords      (cceip3_out_ia_status.f.datawords), 
                                   .stat_addr           (cceip3_out_ia_status.f.addr), 
                                   .capability_lst      (cceip3_out_ia_capability.r.part0[15:0]), 
                                   .capability_type     (cceip3_out_ia_capability.f.mem_type), 
                                   .rd_dat              (cceip3_out_ia_rdata), 
                                   .bimc_odat           (cddip0_ism_idat), 
                                   .bimc_osync          (cddip0_ism_isync), 
                                   .ro_uncorrectable_ecc_error(cceip3_ism_mbe), 
                                   .im_rdy              (cceip3_im_rdy), 
                                   .im_available        (im_available_kme_cceip3), 
                                   .im_status           (cceip3_out_im_status), 
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .reg_addr            (reg_addr),      
                                   .cmnd_op             (cceip3_out_ia_config.f.op), 
                                   .cmnd_addr           (cceip3_out_ia_config.f.addr), 
                                   .wr_stb              (wr_stb),
                                   .wr_dat              (cceip3_out_ia_wdata), 
                                   .ovstb               (ovstb),
                                   .lvm                 (lvm),
                                   .mlvm                (mlvm),
                                   .mrdten              (1'd0),          
                                   .bimc_rst_n          (bimc_rst_n),
                                   .bimc_isync          (cceip3_ism_isync), 
                                   .bimc_idat           (cceip3_ism_idat), 
                                   .im_din              (cceip3_im_din), 
                                   .im_vld              (cceip3_im_vld), 
                                   .im_consumed         (im_consumed_kme_cceip3), 
                                   .im_config           (cceip3_out_im_config)); 



    
    
    nx_interface_monitor #
    (
        .IN_FLIGHT       (5),                               
        .CMND_ADDRESS    (`CR_KME_CDDIP0_OUT_IA_CONFIG),    
        .STAT_ADDRESS    (`CR_KME_CDDIP0_OUT_IA_STATUS),    
        .IMRD_ADDRESS    (`CR_KME_CDDIP0_OUT_IM_READ_DONE), 
        .N_REG_ADDR_BITS (`CR_KME_WIDTH),                   
        .N_DATA_BITS     (`N_AXI_IM_WIDTH),                 
        .N_ENTRIES       (`N_AXI_IM_ENTRIES),               
        .SPECIALIZE      (1)                                
    )
    u_nx_interface_monitor_cddip0 (
                                   
                                   .stat_code           ({cddip0_out_ia_status.f.code}), 
                                   .stat_datawords      (cddip0_out_ia_status.f.datawords), 
                                   .stat_addr           (cddip0_out_ia_status.f.addr), 
                                   .capability_lst      (cddip0_out_ia_capability.r.part0[15:0]), 
                                   .capability_type     (cddip0_out_ia_capability.f.mem_type), 
                                   .rd_dat              (cddip0_out_ia_rdata), 
                                   .bimc_odat           (cddip1_ism_idat), 
                                   .bimc_osync          (cddip1_ism_isync), 
                                   .ro_uncorrectable_ecc_error(cddip0_ism_mbe), 
                                   .im_rdy              (cddip0_im_rdy), 
                                   .im_available        (im_available_kme_cddip0), 
                                   .im_status           (cddip0_out_im_status), 
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .reg_addr            (reg_addr),      
                                   .cmnd_op             (cddip0_out_ia_config.f.op), 
                                   .cmnd_addr           (cddip0_out_ia_config.f.addr), 
                                   .wr_stb              (wr_stb),
                                   .wr_dat              (cddip0_out_ia_wdata), 
                                   .ovstb               (ovstb),
                                   .lvm                 (lvm),
                                   .mlvm                (mlvm),
                                   .mrdten              (1'd0),          
                                   .bimc_rst_n          (bimc_rst_n),
                                   .bimc_isync          (cddip0_ism_isync), 
                                   .bimc_idat           (cddip0_ism_idat), 
                                   .im_din              (cddip0_im_din), 
                                   .im_vld              (cddip0_im_vld), 
                                   .im_consumed         (im_consumed_kme_cddip0), 
                                   .im_config           (cddip0_out_im_config)); 

    
    
    nx_interface_monitor #
    (
        .IN_FLIGHT       (5),                               
        .CMND_ADDRESS    (`CR_KME_CDDIP1_OUT_IA_CONFIG),    
        .STAT_ADDRESS    (`CR_KME_CDDIP1_OUT_IA_STATUS),    
        .IMRD_ADDRESS    (`CR_KME_CDDIP1_OUT_IM_READ_DONE), 
        .N_REG_ADDR_BITS (`CR_KME_WIDTH),                   
        .N_DATA_BITS     (`N_AXI_IM_WIDTH),                 
        .N_ENTRIES       (`N_AXI_IM_ENTRIES),               
        .SPECIALIZE      (1)                                
    )
    u_nx_interface_monitor_cddip1 (
                                   
                                   .stat_code           ({cddip1_out_ia_status.f.code}), 
                                   .stat_datawords      (cddip1_out_ia_status.f.datawords), 
                                   .stat_addr           (cddip1_out_ia_status.f.addr), 
                                   .capability_lst      (cddip1_out_ia_capability.r.part0[15:0]), 
                                   .capability_type     (cddip1_out_ia_capability.f.mem_type), 
                                   .rd_dat              (cddip1_out_ia_rdata), 
                                   .bimc_odat           (cddip2_ism_idat), 
                                   .bimc_osync          (cddip2_ism_isync), 
                                   .ro_uncorrectable_ecc_error(cddip1_ism_mbe), 
                                   .im_rdy              (cddip1_im_rdy), 
                                   .im_available        (im_available_kme_cddip1), 
                                   .im_status           (cddip1_out_im_status), 
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .reg_addr            (reg_addr),      
                                   .cmnd_op             (cddip1_out_ia_config.f.op), 
                                   .cmnd_addr           (cddip1_out_ia_config.f.addr), 
                                   .wr_stb              (wr_stb),
                                   .wr_dat              (cddip1_out_ia_wdata), 
                                   .ovstb               (ovstb),
                                   .lvm                 (lvm),
                                   .mlvm                (mlvm),
                                   .mrdten              (1'd0),          
                                   .bimc_rst_n          (bimc_rst_n),
                                   .bimc_isync          (cddip1_ism_isync), 
                                   .bimc_idat           (cddip1_ism_idat), 
                                   .im_din              (cddip1_im_din), 
                                   .im_vld              (cddip1_im_vld), 
                                   .im_consumed         (im_consumed_kme_cddip1), 
                                   .im_config           (cddip1_out_im_config)); 
   
    
    
    nx_interface_monitor #
    (
        .IN_FLIGHT       (5),                               
        .CMND_ADDRESS    (`CR_KME_CDDIP2_OUT_IA_CONFIG),    
        .STAT_ADDRESS    (`CR_KME_CDDIP2_OUT_IA_STATUS),    
        .IMRD_ADDRESS    (`CR_KME_CDDIP2_OUT_IM_READ_DONE), 
        .N_REG_ADDR_BITS (`CR_KME_WIDTH),                   
        .N_DATA_BITS     (`N_AXI_IM_WIDTH),                 
        .N_ENTRIES       (`N_AXI_IM_ENTRIES),               
        .SPECIALIZE      (1)                                
    )
    u_nx_interface_monitor_cddip2 (
                                   
                                   .stat_code           ({cddip2_out_ia_status.f.code}), 
                                   .stat_datawords      (cddip2_out_ia_status.f.datawords), 
                                   .stat_addr           (cddip2_out_ia_status.f.addr), 
                                   .capability_lst      (cddip2_out_ia_capability.r.part0[15:0]), 
                                   .capability_type     (cddip2_out_ia_capability.f.mem_type), 
                                   .rd_dat              (cddip2_out_ia_rdata), 
                                   .bimc_odat           (cddip3_ism_idat), 
                                   .bimc_osync          (cddip3_ism_isync), 
                                   .ro_uncorrectable_ecc_error(cddip2_ism_mbe), 
                                   .im_rdy              (cddip2_im_rdy), 
                                   .im_available        (im_available_kme_cddip2), 
                                   .im_status           (cddip2_out_im_status), 
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .reg_addr            (reg_addr),      
                                   .cmnd_op             (cddip2_out_ia_config.f.op), 
                                   .cmnd_addr           (cddip2_out_ia_config.f.addr), 
                                   .wr_stb              (wr_stb),
                                   .wr_dat              (cddip2_out_ia_wdata), 
                                   .ovstb               (ovstb),
                                   .lvm                 (lvm),
                                   .mlvm                (mlvm),
                                   .mrdten              (1'd0),          
                                   .bimc_rst_n          (bimc_rst_n),
                                   .bimc_isync          (cddip2_ism_isync), 
                                   .bimc_idat           (cddip2_ism_idat), 
                                   .im_din              (cddip2_im_din), 
                                   .im_vld              (cddip2_im_vld), 
                                   .im_consumed         (im_consumed_kme_cddip2), 
                                   .im_config           (cddip2_out_im_config)); 
   
    
    
    nx_interface_monitor #
    (
        .IN_FLIGHT       (5),                               
        .CMND_ADDRESS    (`CR_KME_CDDIP3_OUT_IA_CONFIG),    
        .STAT_ADDRESS    (`CR_KME_CDDIP3_OUT_IA_STATUS),    
        .IMRD_ADDRESS    (`CR_KME_CDDIP3_OUT_IM_READ_DONE), 
        .N_REG_ADDR_BITS (`CR_KME_WIDTH),                   
        .N_DATA_BITS     (`N_AXI_IM_WIDTH),                 
        .N_ENTRIES       (`N_AXI_IM_ENTRIES),               
        .SPECIALIZE      (1)                                
    )
    u_nx_interface_monitor_cddip3 (
                                   
                                   .stat_code           ({cddip3_out_ia_status.f.code}), 
                                   .stat_datawords      (cddip3_out_ia_status.f.datawords), 
                                   .stat_addr           (cddip3_out_ia_status.f.addr), 
                                   .capability_lst      (cddip3_out_ia_capability.r.part0[15:0]), 
                                   .capability_type     (cddip3_out_ia_capability.f.mem_type), 
                                   .rd_dat              (cddip3_out_ia_rdata), 
                                   .bimc_odat           (cddip3_ism_odat), 
                                   .bimc_osync          (cddip3_ism_osync), 
                                   .ro_uncorrectable_ecc_error(cddip3_ism_mbe), 
                                   .im_rdy              (cddip3_im_rdy), 
                                   .im_available        (im_available_kme_cddip3), 
                                   .im_status           (cddip3_out_im_status), 
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .reg_addr            (reg_addr),      
                                   .cmnd_op             (cddip3_out_ia_config.f.op), 
                                   .cmnd_addr           (cddip3_out_ia_config.f.addr), 
                                   .wr_stb              (wr_stb),
                                   .wr_dat              (cddip3_out_ia_wdata), 
                                   .ovstb               (ovstb),
                                   .lvm                 (lvm),
                                   .mlvm                (mlvm),
                                   .mrdten              (1'd0),          
                                   .bimc_rst_n          (bimc_rst_n),
                                   .bimc_isync          (cddip3_ism_isync), 
                                   .bimc_idat           (cddip3_ism_idat), 
                                   .im_din              (cddip3_im_din), 
                                   .im_vld              (cddip3_im_vld), 
                                   .im_consumed         (im_consumed_kme_cddip3), 
                                   .im_config           (cddip3_out_im_config)); 

    

    cr_kme_regfile_glue
    regfile_glue (
                  
                  .ckv_cmnd_op          (ckv_cmnd_op[3:0]),
                  .ckv_cmnd_addr        (ckv_cmnd_addr[`LOG_VEC(CKV_NUM_ENTRIES)]),
                  .ckv_wr_dat           (ckv_wr_dat[`BIT_VEC(CKV_DATA_WIDTH)]),
                  .ckv_ia_capability    (ckv_ia_capability),
                  .ckv_ia_rdata_part0   (ckv_ia_rdata_part0[`CR_KME_C_CKV_PART0_T_DECL]),
                  .ckv_ia_rdata_part1   (ckv_ia_rdata_part1[`CR_KME_C_CKV_PART1_T_DECL]),
                  .ckv_ia_status        (ckv_ia_status),
                  .kim_cmnd_op          (kim_cmnd_op[3:0]),
                  .kim_cmnd_addr        (kim_cmnd_addr[`LOG_VEC(KIM_NUM_ENTRIES)]),
                  .kim_wr_dat           (kim_wr_dat[`BIT_VEC(KIM_DATA_WIDTH)]),
                  .kim_ia_capability    (kim_ia_capability),
                  .kim_ia_rdata_part0   (kim_ia_rdata_part0[`CR_KME_C_KIM_ENTRY0_T_DECL]),
                  .kim_ia_rdata_part1   (kim_ia_rdata_part1[`CR_KME_C_KIM_ENTRY1_T_DECL]),
                  .kim_ia_status        (kim_ia_status),
                  .engine_sticky_status (engine_sticky_status[`CR_KME_C_STICKY_ENG_BP_T_DECL]),
                  .disable_ckv_kim_ism_reads(disable_ckv_kim_ism_reads),
                  .send_kme_ib_beat     (send_kme_ib_beat),
                  .debug_kme_ib_tvalid  (debug_kme_ib_tvalid),
                  .debug_kme_ib_tlast   (debug_kme_ib_tlast),
                  .debug_kme_ib_tid     (debug_kme_ib_tid[`AXI_S_TID_WIDTH-1:0]),
                  .debug_kme_ib_tstrb   (debug_kme_ib_tstrb[`AXI_S_TSTRB_WIDTH-1:0]),
                  .debug_kme_ib_tuser   (debug_kme_ib_tuser[`AXI_S_USER_WIDTH-1:0]),
                  .debug_kme_ib_tdata   (debug_kme_ib_tdata[`AXI_S_DP_DWIDTH-1:0]),
                  .kme_cceip0_ob_out    (kme_cceip0_ob_out),
                  .kme_cceip1_ob_out    (kme_cceip1_ob_out),
                  .kme_cceip2_ob_out    (kme_cceip2_ob_out),
                  .kme_cceip3_ob_out    (kme_cceip3_ob_out),
                  .kme_cddip0_ob_out    (kme_cddip0_ob_out),
                  .kme_cddip1_ob_out    (kme_cddip1_ob_out),
                  .kme_cddip2_ob_out    (kme_cddip2_ob_out),
                  .kme_cddip3_ob_out    (kme_cddip3_ob_out),
                  .cceip_encrypt_bimc_isync(cceip_encrypt_bimc_isync),
                  .cceip_encrypt_bimc_idat(cceip_encrypt_bimc_idat),
                  .cceip_validate_bimc_isync(cceip_validate_bimc_isync),
                  .cceip_validate_bimc_idat(cceip_validate_bimc_idat),
                  .cddip_decrypt_bimc_isync(cddip_decrypt_bimc_isync),
                  .cddip_decrypt_bimc_idat(cddip_decrypt_bimc_idat),
                  .axi_bimc_isync       (axi_bimc_isync),
                  .axi_bimc_idat        (axi_bimc_idat),
                  .axi_term_bimc_isync  (axi_term_bimc_isync),
                  .axi_term_bimc_idat   (axi_term_bimc_idat),
                  
                  .clk                  (clk),
                  .rst_n                (rst_n),
                  .ckv_stat_code        (ckv_stat_code[2:0]),
                  .ckv_stat_datawords   (ckv_stat_datawords[4:0]),
                  .ckv_stat_addr        (ckv_stat_addr[`LOG_VEC(CKV_NUM_ENTRIES)]),
                  .ckv_capability_type  (ckv_capability_type[3:0]),
                  .ckv_capability_lst   (ckv_capability_lst[15:0]),
                  .ckv_rd_dat           (ckv_rd_dat[`BIT_VEC(CKV_DATA_WIDTH)]),
                  .o_ckv_ia_config      (o_ckv_ia_config),
                  .o_ckv_ia_wdata_part0 (o_ckv_ia_wdata_part0[`CR_KME_C_CKV_PART0_T_DECL]),
                  .o_ckv_ia_wdata_part1 (o_ckv_ia_wdata_part1[`CR_KME_C_CKV_PART1_T_DECL]),
                  .kim_stat_code        (kim_stat_code[2:0]),
                  .kim_stat_datawords   (kim_stat_datawords[4:0]),
                  .kim_stat_addr        (kim_stat_addr[`LOG_VEC(KIM_NUM_ENTRIES)]),
                  .kim_capability_type  (kim_capability_type[3:0]),
                  .kim_capability_lst   (kim_capability_lst[15:0]),
                  .kim_rd_dat           (kim_rd_dat[`BIT_VEC(KIM_DATA_WIDTH)]),
                  .o_kim_ia_config      (o_kim_ia_config),
                  .o_kim_ia_wdata_part0 (o_kim_ia_wdata_part0[`CR_KME_C_KIM_ENTRY0_T_DECL]),
                  .o_kim_ia_wdata_part1 (o_kim_ia_wdata_part1[`CR_KME_C_KIM_ENTRY1_T_DECL]),
                  .set_rsm_is_backpressuring(set_rsm_is_backpressuring[7:0]),
                  .wr_stb               (wr_stb),
                  .wr_data              (wr_data[31:0]),
                  .reg_addr             (reg_addr[`CR_KME_DECL]),
                  .o_engine_sticky_status(o_engine_sticky_status[`CR_KME_C_STICKY_ENG_BP_T_DECL]),
                  .o_disable_ckv_kim_ism_reads(o_disable_ckv_kim_ism_reads),
                  .o_send_kme_ib_beat   (o_send_kme_ib_beat),
                  .cceip0_out_ia_wdata  (cceip0_out_ia_wdata),
                  .debug_kme_ib_tready  (debug_kme_ib_tready),
                  .tready_override      (tready_override),
                  .kme_cceip0_ob_out_post(kme_cceip0_ob_out_post),
                  .kme_cceip1_ob_out_post(kme_cceip1_ob_out_post),
                  .kme_cceip2_ob_out_post(kme_cceip2_ob_out_post),
                  .kme_cceip3_ob_out_post(kme_cceip3_ob_out_post),
                  .kme_cddip0_ob_out_post(kme_cddip0_ob_out_post),
                  .kme_cddip1_ob_out_post(kme_cddip1_ob_out_post),
                  .kme_cddip2_ob_out_post(kme_cddip2_ob_out_post),
                  .kme_cddip3_ob_out_post(kme_cddip3_ob_out_post),
                  .cddip3_ism_osync     (cddip3_ism_osync),
                  .cddip3_ism_odat      (cddip3_ism_odat),
                  .cceip_encrypt_bimc_osync(cceip_encrypt_bimc_osync),
                  .cceip_encrypt_bimc_odat(cceip_encrypt_bimc_odat),
                  .cceip_validate_bimc_osync(cceip_validate_bimc_osync),
                  .cceip_validate_bimc_odat(cceip_validate_bimc_odat),
                  .cddip_decrypt_bimc_osync(cddip_decrypt_bimc_osync),
                  .cddip_decrypt_bimc_odat(cddip_decrypt_bimc_odat),
                  .axi_bimc_osync       (axi_bimc_osync),
                  .axi_bimc_odat        (axi_bimc_odat));

    

    nx_ram_1rw_indirect_access #
    (
        .CMND_ADDRESS       (`CR_KME_CKV_IA_CONFIG),
        .STAT_ADDRESS       (`CR_KME_CKV_IA_STATUS),
        .N_REG_ADDR_BITS    (`CR_KME_WIDTH),
        .N_DATA_BITS        (CKV_DATA_WIDTH),
        .N_ENTRIES          (CKV_NUM_ENTRIES),
        .SPECIALIZE         (1),
        .IN_FLOP            (1)
    )
    ckv_indirect_access(
                        
                        .stat_code      (ckv_stat_code[2:0]),    
                        .stat_datawords (ckv_stat_datawords[`BIT_VEC(5)]), 
                        .stat_addr      (ckv_stat_addr[`LOG_VEC(CKV_NUM_ENTRIES)]), 
                        .capability_lst (ckv_capability_lst[15:0]), 
                        .capability_type(ckv_capability_type[3:0]), 
                        .rd_dat         (ckv_rd_dat[`BIT_VEC(CKV_DATA_WIDTH)]), 
                        .bimc_odat      (cceip0_ism_bimc_idat),  
                        .bimc_osync     (cceip0_ism_bimc_isync), 
                        .ro_uncorrectable_ecc_error(ckv_mbe),    
                        .hw_dout        (ckv_dout),              
                        .hw_yield       (),                      
                        
                        .clk            (clk),                   
                        .rst_n          (rst_n),                 
                        .reg_addr       (reg_addr),              
                        .cmnd_op        (ckv_cmnd_op[3:0]),      
                        .cmnd_addr      (ckv_cmnd_addr[`LOG_VEC(CKV_NUM_ENTRIES)]), 
                        .wr_stb         (wr_stb),
                        .wr_dat         (ckv_wr_dat[`BIT_VEC(CKV_DATA_WIDTH)]), 
                        .ovstb          (ovstb),
                        .lvm            (lvm),
                        .mlvm           (mlvm),
                        .mrdten         ({1{1'b0}}),             
                        .bimc_rst_n     (bimc_rst_n),
                        .bimc_isync     (ckv_bimc_isync),        
                        .bimc_idat      (ckv_bimc_idat),         
                        .hw_add         (ckv_addr),              
                        .hw_we          ({1{1'b0}}),             
                        .hw_bwe         ('0),                    
                        .hw_cs          (ckv_rd),                
                        .hw_din         ('0));                    


    

    nx_ram_1rw_indirect_access #
    (
        .CMND_ADDRESS       (`CR_KME_KIM_IA_CONFIG),
        .STAT_ADDRESS       (`CR_KME_KIM_IA_STATUS),
        .N_REG_ADDR_BITS    (`CR_KME_WIDTH),
        .N_DATA_BITS        (KIM_DATA_WIDTH),
        .N_ENTRIES          (KIM_NUM_ENTRIES),
        .SPECIALIZE         (1),
        .IN_FLOP            (1)
    )
    kim_indirect_access (
                         
                         .stat_code             (kim_stat_code[2:0]), 
                         .stat_datawords        (kim_stat_datawords[`BIT_VEC(5)]), 
                         .stat_addr             (kim_stat_addr[`LOG_VEC(KIM_NUM_ENTRIES)]), 
                         .capability_lst        (kim_capability_lst[15:0]), 
                         .capability_type       (kim_capability_type[3:0]), 
                         .rd_dat                (kim_rd_dat[`BIT_VEC(KIM_DATA_WIDTH)]), 
                         .bimc_odat             (ckv_bimc_idat), 
                         .bimc_osync            (ckv_bimc_isync), 
                         .ro_uncorrectable_ecc_error(kim_mbe),   
                         .hw_dout               (kim_dout),      
                         .hw_yield              (),              
                         
                         .clk                   (clk),           
                         .rst_n                 (rst_n),         
                         .reg_addr              (reg_addr),      
                         .cmnd_op               (kim_cmnd_op[3:0]), 
                         .cmnd_addr             (kim_cmnd_addr[`LOG_VEC(KIM_NUM_ENTRIES)]), 
                         .wr_stb                (wr_stb),
                         .wr_dat                (kim_wr_dat[`BIT_VEC(KIM_DATA_WIDTH)]), 
                         .ovstb                 (ovstb),
                         .lvm                   (lvm),
                         .mlvm                  (mlvm),
                         .mrdten                ({1{1'b0}}),     
                         .bimc_rst_n            (bimc_rst_n),
                         .bimc_isync            (kim_bimc_isync), 
                         .bimc_idat             (kim_bimc_idat), 
                         .hw_add                (kim_addr),      
                         .hw_we                 ({1{1'b0}}),     
                         .hw_bwe                ('0),            
                         .hw_cs                 (kim_rd),        
                         .hw_din                ('0));            


    

    cr_kme_drbg_reggen
    drbg_register_gen (
                       
                       .set_drbg_expired_int(set_drbg_expired_int),
                       .kdf_drbg_ctrl   (kdf_drbg_ctrl[`CR_KME_C_KDF_DRBG_CTRL_T_DECL]),
                       .seed0_valid     (seed0_valid),
                       .seed0_internal_state_key(seed0_internal_state_key[255:0]),
                       .seed0_internal_state_value(seed0_internal_state_value[127:0]),
                       .seed0_reseed_interval(seed0_reseed_interval[47:0]),
                       .seed1_valid     (seed1_valid),
                       .seed1_internal_state_key(seed1_internal_state_key[255:0]),
                       .seed1_internal_state_value(seed1_internal_state_value[127:0]),
                       .seed1_reseed_interval(seed1_reseed_interval[47:0]),
                       
                       .clk             (clk),
                       .rst_n           (rst_n),
                       .wr_stb          (wr_stb),
                       .wr_data         (wr_data[31:0]),
                       .reg_addr        (reg_addr[`CR_KME_DECL]),
                       .o_kdf_drbg_ctrl (o_kdf_drbg_ctrl[`CR_KME_C_KDF_DRBG_CTRL_T_DECL]),
                       .o_kdf_drbg_seed_0_reseed_interval_0(o_kdf_drbg_seed_0_reseed_interval_0[`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_0_T_DECL]),
                       .o_kdf_drbg_seed_0_reseed_interval_1(o_kdf_drbg_seed_0_reseed_interval_1[`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_1_T_DECL]),
                       .o_kdf_drbg_seed_0_state_key_127_96(o_kdf_drbg_seed_0_state_key_127_96[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                       .o_kdf_drbg_seed_0_state_key_159_128(o_kdf_drbg_seed_0_state_key_159_128[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                       .o_kdf_drbg_seed_0_state_key_191_160(o_kdf_drbg_seed_0_state_key_191_160[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                       .o_kdf_drbg_seed_0_state_key_223_192(o_kdf_drbg_seed_0_state_key_223_192[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                       .o_kdf_drbg_seed_0_state_key_255_224(o_kdf_drbg_seed_0_state_key_255_224[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                       .o_kdf_drbg_seed_0_state_key_31_0(o_kdf_drbg_seed_0_state_key_31_0[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                       .o_kdf_drbg_seed_0_state_key_63_32(o_kdf_drbg_seed_0_state_key_63_32[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                       .o_kdf_drbg_seed_0_state_key_95_64(o_kdf_drbg_seed_0_state_key_95_64[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                       .o_kdf_drbg_seed_0_state_value_127_96(o_kdf_drbg_seed_0_state_value_127_96[`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]),
                       .o_kdf_drbg_seed_0_state_value_31_0(o_kdf_drbg_seed_0_state_value_31_0[`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]),
                       .o_kdf_drbg_seed_0_state_value_63_32(o_kdf_drbg_seed_0_state_value_63_32[`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]),
                       .o_kdf_drbg_seed_0_state_value_95_64(o_kdf_drbg_seed_0_state_value_95_64[`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]),
                       .o_kdf_drbg_seed_1_reseed_interval_0(o_kdf_drbg_seed_1_reseed_interval_0[`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_0_T_DECL]),
                       .o_kdf_drbg_seed_1_reseed_interval_1(o_kdf_drbg_seed_1_reseed_interval_1[`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_1_T_DECL]),
                       .o_kdf_drbg_seed_1_state_key_127_96(o_kdf_drbg_seed_1_state_key_127_96[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                       .o_kdf_drbg_seed_1_state_key_159_128(o_kdf_drbg_seed_1_state_key_159_128[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                       .o_kdf_drbg_seed_1_state_key_191_160(o_kdf_drbg_seed_1_state_key_191_160[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                       .o_kdf_drbg_seed_1_state_key_223_192(o_kdf_drbg_seed_1_state_key_223_192[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                       .o_kdf_drbg_seed_1_state_key_255_224(o_kdf_drbg_seed_1_state_key_255_224[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                       .o_kdf_drbg_seed_1_state_key_31_0(o_kdf_drbg_seed_1_state_key_31_0[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                       .o_kdf_drbg_seed_1_state_key_63_32(o_kdf_drbg_seed_1_state_key_63_32[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                       .o_kdf_drbg_seed_1_state_key_95_64(o_kdf_drbg_seed_1_state_key_95_64[`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]),
                       .o_kdf_drbg_seed_1_state_value_127_96(o_kdf_drbg_seed_1_state_value_127_96[`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]),
                       .o_kdf_drbg_seed_1_state_value_31_0(o_kdf_drbg_seed_1_state_value_31_0[`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]),
                       .o_kdf_drbg_seed_1_state_value_63_32(o_kdf_drbg_seed_1_state_value_63_32[`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]),
                       .o_kdf_drbg_seed_1_state_value_95_64(o_kdf_drbg_seed_1_state_value_95_64[`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]),
                       .seed0_invalidate(seed0_invalidate),
                       .seed1_invalidate(seed1_invalidate));

    
    bimc_master
    bimc_master (
                 
                 .bimc_ecc_error        (),                      
                 .bimc_interrupt        (bimc_interrupt),        
                 .bimc_odat             (kim_bimc_idat),         
                 .bimc_rst_n            (bimc_rst_n),
                 .bimc_osync            (kim_bimc_isync),        
                 .i_bimc_monitor        (bimc_monitor[`CR_C_BIMC_MONITOR_T_DECL]), 
                 .i_bimc_ecc_uncorrectable_error_cnt(bimc_ecc_uncorrectable_error_cnt[`CR_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]), 
                 .i_bimc_ecc_correctable_error_cnt(bimc_ecc_correctable_error_cnt[`CR_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]), 
                 .i_bimc_parity_error_cnt(bimc_parity_error_cnt[`CR_C_BIMC_PARITY_ERROR_CNT_T_DECL]), 
                 .i_bimc_global_config  (bimc_global_config[`CR_C_BIMC_GLOBAL_CONFIG_T_DECL]), 
                 .i_bimc_memid          (bimc_memid[`CR_C_BIMC_MEMID_T_DECL]), 
                 .i_bimc_eccpar_debug   (bimc_eccpar_debug[`CR_C_BIMC_ECCPAR_DEBUG_T_DECL]), 
                 .i_bimc_cmd2           (bimc_cmd2[`CR_C_BIMC_CMD2_T_DECL]), 
                 .i_bimc_rxcmd2         (bimc_rxcmd2[`CR_C_BIMC_RXCMD2_T_DECL]), 
                 .i_bimc_rxcmd1         (bimc_rxcmd1[`CR_C_BIMC_RXCMD1_T_DECL]), 
                 .i_bimc_rxcmd0         (bimc_rxcmd0[`CR_C_BIMC_RXCMD0_T_DECL]), 
                 .i_bimc_rxrsp2         (bimc_rxrsp2[`CR_C_BIMC_RXRSP2_T_DECL]), 
                 .i_bimc_rxrsp1         (bimc_rxrsp1[`CR_C_BIMC_RXRSP1_T_DECL]), 
                 .i_bimc_rxrsp0         (bimc_rxrsp0[`CR_C_BIMC_RXRSP0_T_DECL]), 
                 .i_bimc_pollrsp2       (bimc_pollrsp2[`CR_C_BIMC_POLLRSP2_T_DECL]), 
                 .i_bimc_pollrsp1       (bimc_pollrsp1[`CR_C_BIMC_POLLRSP1_T_DECL]), 
                 .i_bimc_pollrsp0       (bimc_pollrsp0[`CR_C_BIMC_POLLRSP0_T_DECL]), 
                 .i_bimc_dbgcmd2        (bimc_dbgcmd2[`CR_C_BIMC_DBGCMD2_T_DECL]), 
                 .i_bimc_dbgcmd1        (bimc_dbgcmd1[`CR_C_BIMC_DBGCMD1_T_DECL]), 
                 .i_bimc_dbgcmd0        (bimc_dbgcmd0[`CR_C_BIMC_DBGCMD0_T_DECL]), 
                 
                 .clk                   (clk),
                 .rst_n                 (rst_n),
                 .bimc_idat             (axi_term_bimc_idat),    
                 .bimc_isync            (axi_term_bimc_isync),   
                 .o_bimc_monitor_mask   (o_bimc_monitor_mask[`CR_C_BIMC_MONITOR_MASK_T_DECL]),
                 .o_bimc_ecc_uncorrectable_error_cnt(o_bimc_ecc_uncorrectable_error_cnt[`CR_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]),
                 .o_bimc_ecc_correctable_error_cnt(o_bimc_ecc_correctable_error_cnt[`CR_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]),
                 .o_bimc_parity_error_cnt(o_bimc_parity_error_cnt[`CR_C_BIMC_PARITY_ERROR_CNT_T_DECL]),
                 .o_bimc_global_config  (o_bimc_global_config[`CR_C_BIMC_GLOBAL_CONFIG_T_DECL]),
                 .o_bimc_eccpar_debug   (o_bimc_eccpar_debug[`CR_C_BIMC_ECCPAR_DEBUG_T_DECL]),
                 .o_bimc_cmd2           (o_bimc_cmd2[`CR_C_BIMC_CMD2_T_DECL]),
                 .o_bimc_cmd1           (o_bimc_cmd1[`CR_C_BIMC_CMD1_T_DECL]),
                 .o_bimc_cmd0           (o_bimc_cmd0[`CR_C_BIMC_CMD0_T_DECL]),
                 .o_bimc_rxcmd2         (o_bimc_rxcmd2[`CR_C_BIMC_RXCMD2_T_DECL]),
                 .o_bimc_rxrsp2         (o_bimc_rxrsp2[`CR_C_BIMC_RXRSP2_T_DECL]),
                 .o_bimc_pollrsp2       (o_bimc_pollrsp2[`CR_C_BIMC_POLLRSP2_T_DECL]),
                 .o_bimc_dbgcmd2        (o_bimc_dbgcmd2[`CR_C_BIMC_DBGCMD2_T_DECL]));
   
    

    cr_kme_int_handler
    int_handler (
                 
                 .kme_interrupt         (kme_interrupt),
                 .interrupt_status      (interrupt_status[`CR_KME_C_INT_STATUS_T_DECL]),
                 .suppress_key_tlvs     (suppress_key_tlvs),
                 
                 .clk                   (clk),
                 .rst_n                 (rst_n),
                 .set_drbg_expired_int  (set_drbg_expired_int),
                 .set_txc_bp_int        (set_txc_bp_int),
                 .set_gcm_tag_fail_int  (set_gcm_tag_fail_int),
                 .set_key_tlv_miscmp_int(set_key_tlv_miscmp_int),
                 .set_tlv_bip2_error_int(set_tlv_bip2_error_int),
                 .cceip0_ism_mbe        (cceip0_ism_mbe),
                 .cceip1_ism_mbe        (cceip1_ism_mbe),
                 .cceip2_ism_mbe        (cceip2_ism_mbe),
                 .cceip3_ism_mbe        (cceip3_ism_mbe),
                 .cddip0_ism_mbe        (cddip0_ism_mbe),
                 .cddip1_ism_mbe        (cddip1_ism_mbe),
                 .cddip2_ism_mbe        (cddip2_ism_mbe),
                 .cddip3_ism_mbe        (cddip3_ism_mbe),
                 .kim_mbe               (kim_mbe),
                 .ckv_mbe               (ckv_mbe),
                 .cceip_encrypt_mbe     (cceip_encrypt_mbe),
                 .cceip_validate_mbe    (cceip_validate_mbe),
                 .cddip_decrypt_mbe     (cddip_decrypt_mbe),
                 .axi_mbe               (axi_mbe),
                 .bimc_interrupt        (bimc_interrupt),
                 .wr_stb                (wr_stb),
                 .wr_data               (wr_data[31:0]),
                 .reg_addr              (reg_addr[`CR_KME_DECL]),
                 .o_interrupt_mask      (o_interrupt_mask[`CR_KME_C_INT_MASK_T_DECL]));

    
    
    
    

     nx_roreg_indirect_access # (
                                 
                                 .CMND_ADDRESS          (`CR_KME_SA_SNAPSHOT_IA_CONFIG), 
                                 .STAT_ADDRESS          (`CR_KME_SA_SNAPSHOT_IA_STATUS), 
                                 .ALIGNMENT             (2),             
                                 .N_DATA_BITS           ($bits(sa_snapshot_t)), 
                                 .N_REG_ADDR_BITS       (`CR_KME_WIDTH), 
                                 .N_ENTRIES             (32))            
     u_SA_SNAPSHOT (
                    
                    .stat_code          (sa_snapshot_ia_status.f.code), 
                    .stat_datawords     (sa_snapshot_ia_status.f.datawords), 
                    .stat_addr          (sa_snapshot_ia_status.f.addr), 
                    .capability_lst     (sa_snapshot_ia_capability.r.part0[15:0]), 
                    .capability_type    (sa_snapshot_ia_capability.f.mem_type), 
                    .rd_dat             (sa_snapshot_ia_rdata),  
                    
                    .clk                (clk),
                    .rst_n              (rst_n),
                    .addr               (reg_addr),              
                    .cmnd_op            (sa_snapshot_ia_config.f.op), 
                    .cmnd_addr          (sa_snapshot_ia_config.f.addr), 
                    .wr_stb             (wr_stb),
                    .wr_dat             (sa_snapshot_ia_wdata),  
                    .mem_a              (sa_snapshot));           

     nx_roreg_indirect_access # (
                                 
                                 .CMND_ADDRESS          (`CR_KME_SA_COUNT_IA_CONFIG), 
                                 .STAT_ADDRESS          (`CR_KME_SA_COUNT_IA_STATUS), 
                                 .ALIGNMENT             (2),             
                                 .N_DATA_BITS           ($bits(sa_count_t)), 
                                 .N_REG_ADDR_BITS       (`CR_KME_WIDTH), 
                                 .N_ENTRIES             (32))            
     u_SA_COUNT (
                 
                 .stat_code             (sa_count_ia_status.f.code), 
                 .stat_datawords        (sa_count_ia_status.f.datawords), 
                 .stat_addr             (sa_count_ia_status.f.addr), 
                 .capability_lst        (sa_count_ia_capability.r.part0[15:0]), 
                 .capability_type       (sa_count_ia_capability.f.mem_type), 
                 .rd_dat                (sa_count_ia_rdata),     
                 
                 .clk                   (clk),
                 .rst_n                 (rst_n),
                 .addr                  (reg_addr),              
                 .cmnd_op               (sa_count_ia_config.f.op), 
                 .cmnd_addr             (sa_count_ia_config.f.addr), 
                 .wr_stb                (wr_stb),
                 .wr_dat                (sa_count_ia_wdata),     
                 .mem_a                 (sa_count));              

     nx_reg_indirect_access # (
                               
                               .CMND_ADDRESS    (`CR_KME_SA_CTRL_IA_CONFIG), 
                               .STAT_ADDRESS    (`CR_KME_SA_CTRL_IA_STATUS), 
                               .ALIGNMENT       (2),             
                               .N_DATA_BITS     ($bits(sa_ctrl_t)), 
                               .N_REG_ADDR_BITS (`CR_KME_WIDTH), 
                               .N_ENTRIES       (32))            
     u_SA_CTRL (
                
                .stat_code              (sa_ctrl_ia_status.f.code), 
                .stat_datawords         (sa_ctrl_ia_status.f.datawords), 
                .stat_addr              (sa_ctrl_ia_status.f.addr), 
                .capability_lst         (sa_ctrl_ia_capability.r.part0[15:0]), 
                .capability_type        (sa_ctrl_ia_capability.f.mem_type), 
                .rd_dat                 (sa_ctrl_ia_rdata),      
                .mem_a                  (sa_ctrl),               
                
                .clk                    (clk),
                .rst_n                  (rst_n),
                .addr                   (reg_addr),              
                .cmnd_op                (sa_ctrl_ia_config.f.op), 
                .cmnd_addr              (sa_ctrl_ia_config.f.addr), 
                .wr_stb                 (wr_stb),
                .wr_dat                 (sa_ctrl_ia_wdata),      
                .rst_dat                (sa_ctrl_rst_dat));       

    
    
    
    always_comb begin
        integer ii;

        for (ii=0; ii<32; ii++) begin
            sa_ctrl_rst_dat[ii] = sa_ctrl_t_reset;
        end
   end


    
    always_comb begin
       im_available[`CR_KME_C_IM_AVAILABLE_T_CCEIP0_BANK_LO] =  im_available_kme_cceip0.bank_lo;
       im_available[`CR_KME_C_IM_AVAILABLE_T_CDDIP0_BANK_LO] =  im_available_kme_cddip0.bank_lo;
       im_available[`CR_KME_C_IM_AVAILABLE_T_CCEIP1_BANK_LO] =  im_available_kme_cceip1.bank_lo;
       im_available[`CR_KME_C_IM_AVAILABLE_T_CDDIP1_BANK_LO] =  im_available_kme_cddip1.bank_lo;
       im_available[`CR_KME_C_IM_AVAILABLE_T_CCEIP2_BANK_LO] =  im_available_kme_cceip2.bank_lo;
       im_available[`CR_KME_C_IM_AVAILABLE_T_CDDIP2_BANK_LO] =  im_available_kme_cddip2.bank_lo;
       im_available[`CR_KME_C_IM_AVAILABLE_T_CCEIP3_BANK_LO] =  im_available_kme_cceip3.bank_lo;
       im_available[`CR_KME_C_IM_AVAILABLE_T_CDDIP3_BANK_LO] =  im_available_kme_cddip3.bank_lo;
       
       im_available[`CR_KME_C_IM_AVAILABLE_T_CCEIP0_BANK_HI] =  im_available_kme_cceip0.bank_hi;
       im_available[`CR_KME_C_IM_AVAILABLE_T_CDDIP0_BANK_HI] =  im_available_kme_cddip0.bank_hi;
       im_available[`CR_KME_C_IM_AVAILABLE_T_CCEIP1_BANK_HI] =  im_available_kme_cceip1.bank_hi;
       im_available[`CR_KME_C_IM_AVAILABLE_T_CDDIP1_BANK_HI] =  im_available_kme_cddip1.bank_hi;
       im_available[`CR_KME_C_IM_AVAILABLE_T_CCEIP2_BANK_HI] =  im_available_kme_cceip2.bank_hi;
       im_available[`CR_KME_C_IM_AVAILABLE_T_CDDIP2_BANK_HI] =  im_available_kme_cddip2.bank_hi;
       im_available[`CR_KME_C_IM_AVAILABLE_T_CCEIP3_BANK_HI] =  im_available_kme_cceip3.bank_hi;
       im_available[`CR_KME_C_IM_AVAILABLE_T_CDDIP3_BANK_HI] =  im_available_kme_cddip3.bank_hi;
    end
       
       
    
    always_ff @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
      
      
      im_consumed_kme_cceip0.bank_hi <= 0;
      im_consumed_kme_cceip0.bank_lo <= 0;
      im_consumed_kme_cceip1.bank_hi <= 0;
      im_consumed_kme_cceip1.bank_lo <= 0;
      im_consumed_kme_cceip2.bank_hi <= 0;
      im_consumed_kme_cceip2.bank_lo <= 0;
      im_consumed_kme_cceip3.bank_hi <= 0;
      im_consumed_kme_cceip3.bank_lo <= 0;
      im_consumed_kme_cddip0.bank_hi <= 0;
      im_consumed_kme_cddip0.bank_lo <= 0;
      im_consumed_kme_cddip1.bank_hi <= 0;
      im_consumed_kme_cddip1.bank_lo <= 0;
      im_consumed_kme_cddip2.bank_hi <= 0;
      im_consumed_kme_cddip2.bank_lo <= 0;
      im_consumed_kme_cddip3.bank_hi <= 0;
      im_consumed_kme_cddip3.bank_lo <= 0;
      
       end
       else begin
      im_consumed_kme_cceip0.bank_lo <= 0;
      im_consumed_kme_cddip0.bank_lo <= 0;
      im_consumed_kme_cceip1.bank_lo <= 0;
      im_consumed_kme_cddip1.bank_lo <= 0;
      im_consumed_kme_cceip2.bank_lo <= 0;
      im_consumed_kme_cddip2.bank_lo <= 0;
      im_consumed_kme_cceip3.bank_lo <= 0;
      im_consumed_kme_cddip3.bank_lo <= 0;	 
      im_consumed_kme_cceip0.bank_hi <= 0;
      im_consumed_kme_cddip0.bank_hi <= 0;
      im_consumed_kme_cceip1.bank_hi <= 0;
      im_consumed_kme_cddip1.bank_hi <= 0;
      im_consumed_kme_cceip2.bank_hi <= 0;
      im_consumed_kme_cddip2.bank_hi <= 0;
      im_consumed_kme_cceip3.bank_hi <= 0;
      im_consumed_kme_cddip3.bank_hi <= 0;	 
      if (wr_stb && (reg_addr == `CR_KME_IM_CONSUMED)) begin
         if (wr_data[`CR_KME_C_IM_CONSUMED_T_CCEIP0_BANK_LO])       im_consumed_kme_cceip0.bank_lo <= 1;
         if (wr_data[`CR_KME_C_IM_CONSUMED_T_CCEIP1_BANK_LO])       im_consumed_kme_cceip1.bank_lo <= 1;
         if (wr_data[`CR_KME_C_IM_CONSUMED_T_CCEIP2_BANK_LO])       im_consumed_kme_cceip2.bank_lo <= 1;
         if (wr_data[`CR_KME_C_IM_CONSUMED_T_CCEIP3_BANK_LO])       im_consumed_kme_cceip3.bank_lo <= 1;
         if (wr_data[`CR_KME_C_IM_CONSUMED_T_CCEIP0_BANK_HI])       im_consumed_kme_cceip0.bank_hi <= 1;
         if (wr_data[`CR_KME_C_IM_CONSUMED_T_CCEIP1_BANK_HI])       im_consumed_kme_cceip1.bank_hi <= 1;
         if (wr_data[`CR_KME_C_IM_CONSUMED_T_CCEIP2_BANK_HI])       im_consumed_kme_cceip2.bank_hi <= 1;
         if (wr_data[`CR_KME_C_IM_CONSUMED_T_CCEIP3_BANK_HI])       im_consumed_kme_cceip3.bank_hi <= 1;	    
         if (wr_data[`CR_KME_C_IM_CONSUMED_T_CDDIP0_BANK_LO])       im_consumed_kme_cddip0.bank_lo <= 1;
         if (wr_data[`CR_KME_C_IM_CONSUMED_T_CDDIP1_BANK_LO])       im_consumed_kme_cddip1.bank_lo <= 1;
         if (wr_data[`CR_KME_C_IM_CONSUMED_T_CDDIP2_BANK_LO])       im_consumed_kme_cddip2.bank_lo <= 1;
         if (wr_data[`CR_KME_C_IM_CONSUMED_T_CDDIP3_BANK_LO])       im_consumed_kme_cddip3.bank_lo <= 1;
         if (wr_data[`CR_KME_C_IM_CONSUMED_T_CDDIP0_BANK_HI])       im_consumed_kme_cddip0.bank_hi <= 1;
         if (wr_data[`CR_KME_C_IM_CONSUMED_T_CDDIP1_BANK_HI])       im_consumed_kme_cddip1.bank_hi <= 1;
         if (wr_data[`CR_KME_C_IM_CONSUMED_T_CDDIP2_BANK_HI])       im_consumed_kme_cddip2.bank_hi <= 1;
         if (wr_data[`CR_KME_C_IM_CONSUMED_T_CDDIP3_BANK_HI])       im_consumed_kme_cddip3.bank_hi <= 1;	                      
      end
       end
    end
   

endmodule 










