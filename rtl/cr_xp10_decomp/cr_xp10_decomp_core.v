/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/








`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"
`include "axi_reg_slice_defs.vh"

module cr_xp10_decomp_core 
  #(parameter XP10_DECOMP_STUB=0, FPGA_MOD=0)
   (
   
   xp10_decomp_ib_out, xp10_decomp_ob_out, xp10_decomp_sch_update,
   bimc_odat, bimc_osync, ro_uncorrectable_ecc_error, fe_tlvp_error,
   lz_bytes_decomp, lz_hb_bytes, lz_hb_head_ptr, lz_hb_tail_ptr,
   lz_local_bytes, xp10_decomp_lz77d_stat_events, hufd_stat_events,
   xpd_im_valid, xpd_im_data, htf_bl_im_valid, htf_bl_im_data,
   
   clk, rst_n, lvm, mlvm, ovstb, xp10_decomp_ib_in, xp10_decomp_ob_in,
   sw_TLVP_ACTION_CFG0, sw_TLVP_ACTION_CFG1, su_afull_n, bimc_idat,
   bimc_isync, bimc_rst_n, sw_LZ_BYPASS_CONFIG, sw_IGNORE_CRC_CONFIG,
   xpd_im_ready, htf_bl_im_ready, xp10_decomp_module_id,
   sw_LZ_DECOMP_OLIMIT, cceip_cfg
   );
   
   import crPKG::*;
   import cr_xp10_decompPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   
   
   
   
   input         clk;
   input         rst_n; 

   input logic   lvm;                    
   input logic   mlvm;                   
   input logic   ovstb;                  

   
   
   
   
   input         axi4s_dp_bus_t xp10_decomp_ib_in;
   output        axi4s_dp_rdy_t xp10_decomp_ib_out;

   
   
   
   input         axi4s_dp_rdy_t xp10_decomp_ob_in;
   output        axi4s_dp_bus_t xp10_decomp_ob_out;
   input [31:0]  sw_TLVP_ACTION_CFG0;
   input [31:0]  sw_TLVP_ACTION_CFG1;
   
   
   
   
   output        sched_update_if_bus_t xp10_decomp_sch_update;
   input         su_afull_n;

   
   
   
   input logic   bimc_idat;
   input logic   bimc_isync;
   input logic   bimc_rst_n;
   output logic  bimc_odat;
   output logic  bimc_osync;
   output logic  ro_uncorrectable_ecc_error;
   output logic  fe_tlvp_error;
   
   
   
   

   input         sw_LZ_BYPASS_CONFIG;
   input         sw_IGNORE_CRC_CONFIG;
   output logic [16:0] lz_bytes_decomp;        
   output logic [16:0] lz_hb_bytes;            
   output logic [11:0] lz_hb_head_ptr;         
   output logic [11:0] lz_hb_tail_ptr;         
   output logic [16:0] lz_local_bytes;         
   output [LZ77D_STAT_EVENTS_LIMIT:LZ77D_STAT_EVENTS_BASE] xp10_decomp_lz77d_stat_events;
   output [HUFD_STAT_EVENTS_LIMIT:HUFD_STAT_EVENTS_BASE] hufd_stat_events;

   
   output              xpd_im_valid;
   output              lz_symbol_bus_t xpd_im_data;
   input               xpd_im_ready;

   output              htf_bl_im_valid;
   output              htf_bl_out_t htf_bl_im_data;
   input               htf_bl_im_ready;
   input [`MODULE_ID_WIDTH-1:0] xp10_decomp_module_id;
   input [23:0]                 sw_LZ_DECOMP_OLIMIT;

   input                        cceip_cfg;
   
   logic                        fe_lfa_ro_uncorrectable_ecc_error_a;
   logic                        fe_lfa_ro_uncorrectable_ecc_error_b;
   logic                        hdr_ro_uncorrectable_ecc_error;
   logic                        lz77_hb_ro_uncorrectable_ecc_error_a;
   logic                        lz77_hb_ro_uncorrectable_ecc_error_b;
   logic                        lz77_pfx0_ro_uncorrectable_ecc_error;
   logic                        lz77_pfx1_ro_uncorrectable_ecc_error;
   logic                        lz77_pfx2_ro_uncorrectable_ecc_error;
   logic                        predef_ro_uncorrectable_ecc_error;

   generate if (XP10_DECOMP_STUB == 1) begin : stub
      assign xp10_decomp_ob_out = xp10_decomp_ib_in;
      assign xp10_decomp_ib_out = xp10_decomp_ob_in;
      
      assign bimc_odat = '0;
      assign bimc_osync = '0;
      assign hdr_ro_uncorrectable_ecc_error = '0;
      assign predef_ro_uncorrectable_ecc_error = '0;
      
`include "cr_xp10_decomp_sch_update_stub.v"
      
   end
   else begin : no_stub
 
      
      assign ro_uncorrectable_ecc_error = hdr_ro_uncorrectable_ecc_error ||
                                          predef_ro_uncorrectable_ecc_error ||
                                          lz77_hb_ro_uncorrectable_ecc_error_a ||
                                       lz77_hb_ro_uncorrectable_ecc_error_b ||
                                          lz77_pfx0_ro_uncorrectable_ecc_error ||
                                          lz77_pfx1_ro_uncorrectable_ecc_error ||
                                          lz77_pfx2_ro_uncorrectable_ecc_error ||
                                          fe_lfa_ro_uncorrectable_ecc_error_a ||
                                          fe_lfa_ro_uncorrectable_ecc_error_b;
      
      

      
      

`ifdef SHOULD_BE_EMPTY
      
      
`endif
      
      
      
      logic             _lz_mtf_dp_ready;       
      logic             _mtf_lz_dp_valid;       
      logic             be_fhp_dp_ready;        
      logic             be_lz_dp_ready;         
      bhp_htf_hdr_dp_bus_t bhp_htf_hdr_dp_bus;  
      logic             bhp_htf_hdr_dp_valid;   
      bhp_htf_hdrinfo_bus_t bhp_htf_hdrinfo_bus;
      logic             bhp_htf_hdrinfo_valid;  
      logic             bhp_htf_status_ready;   
      bhp_mtf_hdr_bus_t bhp_mtf_hdr_bus;        
      logic             bhp_mtf_hdr_valid;      
      logic             bimc_fe_odat;           
      logic             bimc_fe_osync;          
      logic             bimc_hufd_odat;         
      logic             bimc_hufd_osync;        
      logic             bimc_lz77_odat;         
      logic             bimc_lz77_osync;        
      fhp_be_dp_bus_t   fhp_be_dp_bus;          
      logic             fhp_be_dp_valid;        
      tlvp_if_bus_t     fhp_be_usr_data;        
      logic             fhp_be_usr_valid;       
      fhp_htf_bl_bus_t  fhp_htf_bl_bus;         
      logic             fhp_htf_bl_valid;       
      lz_symbol_bus_t   fhp_lz_dbg_data_bus;    
      logic             fhp_lz_dbg_data_valid;  
      fhp_lz_prefix_dp_bus_t fhp_lz_prefix_dp_bus;
      fhp_lz_prefix_hdr_bus_t fhp_lz_prefix_hdr_bus;
      logic             fhp_lz_prefix_hdr_valid;
      logic             fhp_lz_prefix_valid;    
      logic             htf_bhp_hdr_dp_ready;   
      logic             htf_bhp_hdrinfo_ready;  
      htf_bhp_status_bus_t htf_bhp_status_bus;  
      logic             htf_bhp_status_valid;   
      logic             htf_fhp_bl_ready;       
      lfa_be_crc_bus_t  lfa_be_crc_bus;         
      logic             lfa_be_crc_valid;       
      lfa_sdd_dp_bus_t  lfa_sdd_dp_bus;         
      logic             lfa_sdd_dp_valid;       
      lz_be_dp_bus_t    lz_be_dp_bus;           
      logic             lz_be_dp_valid;         
      logic             lz_fhp_dbg_data_ready;  
      logic             lz_fhp_pre_prefix_ready;
      logic             lz_fhp_prefix_hdr_ready;
      logic             lz_fhp_usr_prefix_ready;
      logic             lz_mtf_dp_ready;        
      logic             mtf_bhp_hdr_ready;      
      lz_symbol_bus_t   mtf_lz_dp_bus;          
      logic             mtf_lz_dp_valid;        
      logic             mtf_sdd_dp_ready;       
      sdd_lfa_ack_bus_t sdd_lfa_ack_bus;        
      logic             sdd_lfa_ack_valid;      
      logic             sdd_lfa_dp_ready;       
      lz_symbol_bus_t   sdd_mtf_dp_bus;         
      logic             sdd_mtf_dp_valid;       
      

      
      
      logic             bimc_fe_idat;           
      logic             bimc_fe_isync;          
      logic             bimc_hufd_idat;         
      logic             bimc_hufd_isync;        
      logic             bimc_lz77_idat;         
      logic             bimc_lz77_isync;        
      

      
`define __BIMC_CHAIN(src,dst)                                 \
      assign bimc_``dst``_idat  = bimc_``src``_odat; \
      assign bimc_``dst``_isync = bimc_``src``_osync
`define __BIMC_IN(dst) \
      assign bimc_``dst``_idat = bimc_idat; \
      assign bimc_``dst``_isync = bimc_isync
`define __BIMC_OUT(src) \
      assign bimc_odat = bimc_``src``_odat; \
      assign bimc_osync = bimc_``src``_osync
      
      `__BIMC_IN(fe);
      `__BIMC_CHAIN(fe,   hufd);
      `__BIMC_CHAIN(hufd, lz77);
      `__BIMC_OUT(lz77);
      
`undef __BIMC_CHAIN
`undef __BIMC_IN
`undef __BIMC_OUT
      
      
      
      cr_xp10_decomp_fe fe
        (.fe_lfa_ro_uncorrectable_ecc_error_a(fe_lfa_ro_uncorrectable_ecc_error_a), 
         .fe_lfa_ro_uncorrectable_ecc_error_b(fe_lfa_ro_uncorrectable_ecc_error_b),
         .fe_tlvp_error                 (fe_tlvp_error),

         
         
         .bimc_odat                     (bimc_fe_odat),          
         .bimc_osync                    (bimc_fe_osync),         
         .xp10_decomp_ib_out            (xp10_decomp_ib_out),
         .fhp_htf_bl_valid              (fhp_htf_bl_valid),
         .fhp_htf_bl_bus                (fhp_htf_bl_bus),
         .fhp_lz_prefix_hdr_valid       (fhp_lz_prefix_hdr_valid),
         .fhp_lz_prefix_hdr_bus         (fhp_lz_prefix_hdr_bus),
         .fhp_lz_prefix_valid           (fhp_lz_prefix_valid),
         .fhp_lz_prefix_dp_bus          (fhp_lz_prefix_dp_bus),
         .fhp_be_dp_valid               (fhp_be_dp_valid),
         .fhp_be_dp_bus                 (fhp_be_dp_bus),
         .fhp_be_usr_data               (fhp_be_usr_data),
         .fhp_be_usr_valid              (fhp_be_usr_valid),
         .fhp_lz_dbg_data_valid         (fhp_lz_dbg_data_valid),
         .fhp_lz_dbg_data_bus           (fhp_lz_dbg_data_bus),
         .bhp_htf_hdr_dp_valid          (bhp_htf_hdr_dp_valid),
         .bhp_htf_hdr_dp_bus            (bhp_htf_hdr_dp_bus),
         .bhp_htf_hdrinfo_valid         (bhp_htf_hdrinfo_valid),
         .bhp_htf_hdrinfo_bus           (bhp_htf_hdrinfo_bus),
         .bhp_htf_status_ready          (bhp_htf_status_ready),
         .bhp_mtf_hdr_valid             (bhp_mtf_hdr_valid),
         .bhp_mtf_hdr_bus               (bhp_mtf_hdr_bus),
         .lfa_be_crc_valid              (lfa_be_crc_valid),
         .lfa_be_crc_bus                (lfa_be_crc_bus),
         .lfa_sdd_dp_valid              (lfa_sdd_dp_valid),
         .lfa_sdd_dp_bus                (lfa_sdd_dp_bus),
         .chu4k_raw_stb                 (hufd_stat_events[crPKG::HUFD_FE_CHU4K_RAW_TOTAL]), 
         .chu4k_stb                     (hufd_stat_events[crPKG::HUFD_FE_CHU4K_TOTAL]), 
         .chu8k_raw_stb                 (hufd_stat_events[crPKG::HUFD_FE_CHU8K_RAW_TOTAL]), 
         .chu8k_stb                     (hufd_stat_events[crPKG::HUFD_FE_CHU8K_TOTAL]), 
         .fhp_stall_stb                 (hufd_stat_events[crPKG::HUFD_FE_FHP_STALL_TOTAL]), 
         .gzip_blk_stb                  (hufd_stat_events[crPKG::HUFD_FE_GZIP_BLK_TOTAL]), 
         .gzip_frm_stb                  (hufd_stat_events[crPKG::HUFD_FE_GZIP_FRM_TOTAL]), 
         .gzip_raw_blk_stb              (hufd_stat_events[crPKG::HUFD_FE_GZIP_RAW_BLK_TOTAL]), 
         .lfa_stall_stb                 (hufd_stat_events[crPKG::HUFD_FE_LFA_STALL_TOTAL]), 
         .pfx_crc_err_stb               (hufd_stat_events[crPKG::HUFD_FE_PFX_CRC_ERR_TOTAL]), 
         .phd_crc_err_stb               (hufd_stat_events[crPKG::HUFD_FE_PHD_CRC_ERR_TOTAL]), 
         .xp10_blk_stb                  (hufd_stat_events[crPKG::HUFD_FE_XP10_BLK_TOTAL]), 
         .xp10_frm_pdh_stb              (hufd_stat_events[crPKG::HUFD_FE_XP10_FRM_PDH_TOTAL]), 
         .xp10_frm_pfx_stb              (hufd_stat_events[crPKG::HUFD_FE_XP10_FRM_PFX_TOTAL]), 
         .xp10_frm_stb                  (hufd_stat_events[crPKG::HUFD_FE_XP10_FRM_TOTAL]), 
         .xp10_raw_blk_stb              (hufd_stat_events[crPKG::HUFD_FE_XP10_RAW_BLK_TOTAL]), 
         .xp9_blk_stb                   (hufd_stat_events[crPKG::HUFD_FE_XP9_BLK_TOTAL]), 
         .xp9_crc_err_stb               (hufd_stat_events[crPKG::HUFD_FE_XP9_CRC_ERR_TOTAL]), 
         .xp9_frm_stb                   (hufd_stat_events[crPKG::HUFD_FE_XP9_FRM_TOTAL]), 
         .xp9_raw_frm_stb               (hufd_stat_events[crPKG::HUFD_FE_XP9_RAW_FRM_TOTAL]), 
         .zlib_blk_stb                  (hufd_stat_events[crPKG::HUFD_FE_ZLIB_BLK_TOTAL]), 
         .zlib_frm_stb                  (hufd_stat_events[crPKG::HUFD_FE_ZLIB_FRM_TOTAL]), 
         .zlib_raw_blk_stb              (hufd_stat_events[crPKG::HUFD_FE_ZLIB_RAW_BLK_TOTAL]), 
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .ovstb                         (ovstb),
         .lvm                           (lvm),
         .mlvm                          (mlvm),
         .bimc_idat                     (bimc_fe_idat),          
         .bimc_isync                    (bimc_fe_isync),         
         .bimc_rst_n                    (bimc_rst_n),
         .xp10_decomp_ib_in             (xp10_decomp_ib_in),
         .htf_fhp_bl_ready              (htf_fhp_bl_ready),
         .lz_fhp_prefix_hdr_ready       (lz_fhp_prefix_hdr_ready),
         .lz_fhp_pre_prefix_ready       (lz_fhp_pre_prefix_ready),
         .lz_fhp_usr_prefix_ready       (lz_fhp_usr_prefix_ready),
         .be_fhp_dp_ready               (be_fhp_dp_ready),
         .lz_fhp_dbg_data_ready         (lz_fhp_dbg_data_ready),
         .htf_bhp_hdr_dp_ready          (htf_bhp_hdr_dp_ready),
         .htf_bhp_hdrinfo_ready         (htf_bhp_hdrinfo_ready),
         .htf_bhp_status_valid          (htf_bhp_status_valid),
         .htf_bhp_status_bus            (htf_bhp_status_bus),
         .mtf_bhp_hdr_ready             (mtf_bhp_hdr_ready),
         .sdd_lfa_dp_ready              (sdd_lfa_dp_ready),
         .sdd_lfa_ack_valid             (sdd_lfa_ack_valid),
         .sdd_lfa_ack_bus               (sdd_lfa_ack_bus),
         .sw_TLVP_ACTION_CFG0           (sw_TLVP_ACTION_CFG0[31:0]),
         .sw_TLVP_ACTION_CFG1           (sw_TLVP_ACTION_CFG1[31:0]),
         .xp10_decomp_module_id         (xp10_decomp_module_id[`MODULE_ID_WIDTH-1:0]));

        
      cr_xp10_decomp_hufd #(.FPGA_MOD(FPGA_MOD)) hufd
        (.predef_ro_uncorrectable_ecc_error(predef_ro_uncorrectable_ecc_error),
         .hdr_ro_uncorrectable_ecc_error(hdr_ro_uncorrectable_ecc_error),
         
         
         
         .bimc_odat                     (bimc_hufd_odat),        
         .bimc_osync                    (bimc_hufd_osync),       
         .htf_bhp_hdr_dp_ready          (htf_bhp_hdr_dp_ready),
         .htf_bhp_hdrinfo_ready         (htf_bhp_hdrinfo_ready),
         .htf_bhp_status_valid          (htf_bhp_status_valid),
         .htf_bhp_status_bus            (htf_bhp_status_bus),
         .htf_fhp_bl_ready              (htf_fhp_bl_ready),
         .sdd_lfa_dp_ready              (sdd_lfa_dp_ready),
         .sdd_lfa_ack_valid             (sdd_lfa_ack_valid),
         .sdd_lfa_ack_bus               (sdd_lfa_ack_bus),
         .sdd_mtf_dp_valid              (sdd_mtf_dp_valid),
         .sdd_mtf_dp_bus                (sdd_mtf_dp_bus),
         .htf_bl_im_valid               (htf_bl_im_valid),
         .htf_bl_im_data                (htf_bl_im_data),
         .xp10_decomp_sch_update        (xp10_decomp_sch_update),
         .deflate_dynamic_blk_stb       (hufd_stat_events[crPKG::HUFD_HTF_DEFLATE_DYNAMIC_BLK_TOTAL]), 
         .deflate_fixed_blk_stb         (hufd_stat_events[crPKG::HUFD_HTF_DEFLATE_FIXED_BLK_TOTAL]), 
         .hdr_data_stall_stb            (hufd_stat_events[crPKG::HUFD_HTF_HDR_DATA_STALL_TOTAL]), 
         .hdr_info_stall_stb            (hufd_stat_events[crPKG::HUFD_HTF_HDR_INFO_STALL_TOTAL]), 
         .predef_stall_stb              (hufd_stat_events[crPKG::HUFD_HTF_PREDEF_STALL_TOTAL]), 
         .xp10_predef_long_blk_stb      (hufd_stat_events[crPKG::HUFD_HTF_XP10_PREDEF_LONG_BLK_TOTAL]), 
         .xp10_predef_short_blk_stb     (hufd_stat_events[crPKG::HUFD_HTF_XP10_PREDEF_SHORT_BLK_TOTAL]), 
         .xp10_retro_long_blk_stb       (hufd_stat_events[crPKG::HUFD_HTF_XP10_RETRO_LONG_BLK_TOTAL]), 
         .xp10_retro_short_blk_stb      (hufd_stat_events[crPKG::HUFD_HTF_XP10_RETRO_SHORT_BLK_TOTAL]), 
         .xp10_simple_long_blk_stb      (hufd_stat_events[crPKG::HUFD_HTF_XP10_SIMPLE_LONG_BLK_TOTAL]), 
         .xp10_simple_short_blk_stb     (hufd_stat_events[crPKG::HUFD_HTF_XP10_SIMPLE_SHORT_BLK_TOTAL]), 
         .chu4k_predef_long_blk_stb     (hufd_stat_events[crPKG::HUFD_HTF_CHU4K_PREDEF_LONG_BLK_TOTAL]), 
         .chu4k_predef_short_blk_stb    (hufd_stat_events[crPKG::HUFD_HTF_CHU4K_PREDEF_SHORT_BLK_TOTAL]), 
         .chu4k_retro_long_blk_stb      (hufd_stat_events[crPKG::HUFD_HTF_CHU4K_RETRO_LONG_BLK_TOTAL]), 
         .chu4k_retro_short_blk_stb     (hufd_stat_events[crPKG::HUFD_HTF_CHU4K_RETRO_SHORT_BLK_TOTAL]), 
         .chu4k_simple_long_blk_stb     (hufd_stat_events[crPKG::HUFD_HTF_CHU4K_SIMPLE_LONG_BLK_TOTAL]), 
         .chu4k_simple_short_blk_stb    (hufd_stat_events[crPKG::HUFD_HTF_CHU4K_SIMPLE_SHORT_BLK_TOTAL]), 
         .chu8k_predef_long_blk_stb     (hufd_stat_events[crPKG::HUFD_HTF_CHU8K_PREDEF_LONG_BLK_TOTAL]), 
         .chu8k_predef_short_blk_stb    (hufd_stat_events[crPKG::HUFD_HTF_CHU8K_PREDEF_SHORT_BLK_TOTAL]), 
         .chu8k_retro_long_blk_stb      (hufd_stat_events[crPKG::HUFD_HTF_CHU8K_RETRO_LONG_BLK_TOTAL]), 
         .chu8k_retro_short_blk_stb     (hufd_stat_events[crPKG::HUFD_HTF_CHU8K_RETRO_SHORT_BLK_TOTAL]), 
         .chu8k_simple_long_blk_stb     (hufd_stat_events[crPKG::HUFD_HTF_CHU8K_SIMPLE_LONG_BLK_TOTAL]), 
         .chu8k_simple_short_blk_stb    (hufd_stat_events[crPKG::HUFD_HTF_CHU8K_SIMPLE_SHORT_BLK_TOTAL]), 
         .xp9_retro_long_blk_stb        (hufd_stat_events[crPKG::HUFD_HTF_XP9_RETRO_LONG_BLK_TOTAL]), 
         .xp9_retro_short_blk_stb       (hufd_stat_events[crPKG::HUFD_HTF_XP9_RETRO_SHORT_BLK_TOTAL]), 
         .xp9_simple_long_blk_stb       (hufd_stat_events[crPKG::HUFD_HTF_XP9_SIMPLE_LONG_BLK_TOTAL]), 
         .xp9_simple_short_blk_stb      (hufd_stat_events[crPKG::HUFD_HTF_XP9_SIMPLE_SHORT_BLK_TOTAL]), 
         .input_stall_stb               (hufd_stat_events[crPKG::HUFD_SDD_INPUT_STALL_TOTAL]), 
         .buf_full_stall_stb            (hufd_stat_events[crPKG::HUFD_SDD_BUF_FULL_STALL_TOTAL]), 
         .mtf_stb                       (hufd_stat_events[crPKG::HUFD_MTF_0_TOTAL +: 4]), 
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .ovstb                         (ovstb),
         .lvm                           (lvm),
         .mlvm                          (mlvm),
         .bimc_idat                     (bimc_hufd_idat),        
         .bimc_isync                    (bimc_hufd_isync),       
         .bimc_rst_n                    (bimc_rst_n),
         .bhp_htf_hdr_dp_valid          (bhp_htf_hdr_dp_valid),
         .bhp_htf_hdr_dp_bus            (bhp_htf_hdr_dp_bus),
         .bhp_htf_hdrinfo_valid         (bhp_htf_hdrinfo_valid),
         .bhp_htf_hdrinfo_bus           (bhp_htf_hdrinfo_bus),
         .bhp_htf_status_ready          (bhp_htf_status_ready),
         .fhp_htf_bl_valid              (fhp_htf_bl_valid),
         .fhp_htf_bl_bus                (fhp_htf_bl_bus),
         .lfa_sdd_dp_valid              (lfa_sdd_dp_valid),
         .lfa_sdd_dp_bus                (lfa_sdd_dp_bus),
         .mtf_sdd_dp_ready              (mtf_sdd_dp_ready),
         .htf_bl_im_ready               (htf_bl_im_ready),
         .su_afull_n                    (su_afull_n));

      cr_xp10_decomp_mtf 
        #(.SUPPRESS_EOB(1'b1))
      mtf
        (
         
         .mtf_bhp_hdr_ready             (mtf_bhp_hdr_ready),
         .mtf_sdd_dp_ready              (mtf_sdd_dp_ready),
         .mtf_lz_dp_valid               (mtf_lz_dp_valid),
         .mtf_lz_dp_bus                 (mtf_lz_dp_bus),
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .ovstb                         (ovstb),
         .lvm                           (lvm),
         .mlvm                          (mlvm),
         .bhp_mtf_hdr_valid             (bhp_mtf_hdr_valid),
         .bhp_mtf_hdr_bus               (bhp_mtf_hdr_bus),
         .sdd_mtf_dp_valid              (sdd_mtf_dp_valid),
         .sdd_mtf_dp_bus                (sdd_mtf_dp_bus),
         .lz_mtf_dp_ready               (lz_mtf_dp_ready));

      lz_symbol_bus_t _mtf_lz_dp_bus;
      assign _mtf_lz_dp_bus = xpd_im_data;

      
      axi_channel_split_slice
        #(.N_OUTPUTS(2),
          .PAYLD_WIDTH($bits(lz_symbol_bus_t)),
          .HNDSHK_MODE(`AXI_RS_BYPASS))
      u_xpd_split
        (
         
         .ready_src                     (lz_mtf_dp_ready),       
         .valid_dst                     ({xpd_im_valid,  _mtf_lz_dp_valid}), 
         .payload_dst                   (xpd_im_data),           
         
         .aclk                          (clk),                   
         .aresetn                       (rst_n),                 
         .valid_src                     (mtf_lz_dp_valid),       
         .payload_src                   (mtf_lz_dp_bus),         
         .ready_dst                     ({xpd_im_ready, _lz_mtf_dp_ready})); 
      

      
      cr_xp10_decomp_lz77 lz77
        (.lz77_hb_ro_uncorrectable_ecc_error_a(lz77_hb_ro_uncorrectable_ecc_error_a), 
         .lz77_hb_ro_uncorrectable_ecc_error_b(lz77_hb_ro_uncorrectable_ecc_error_b), 
         .lz77_pfx0_ro_uncorrectable_ecc_error(lz77_pfx0_ro_uncorrectable_ecc_error), 
         .lz77_pfx1_ro_uncorrectable_ecc_error(lz77_pfx1_ro_uncorrectable_ecc_error),
         .lz77_pfx2_ro_uncorrectable_ecc_error(lz77_pfx2_ro_uncorrectable_ecc_error), 
         
         
         .bimc_odat                     (bimc_lz77_odat),        
         .bimc_osync                    (bimc_lz77_osync),       
         .lz_fhp_prefix_hdr_ready       (lz_fhp_prefix_hdr_ready),
         .lz_fhp_pre_prefix_ready       (lz_fhp_pre_prefix_ready),
         .lz_fhp_usr_prefix_ready       (lz_fhp_usr_prefix_ready),
         .lz_fhp_dbg_data_ready         (lz_fhp_dbg_data_ready),
         .lz_mtf_dp_ready               (_lz_mtf_dp_ready),      
         .lz_be_dp_valid                (lz_be_dp_valid),
         .lz_be_dp_bus                  (lz_be_dp_bus),
         .lz_bytes_decomp               (lz_bytes_decomp[16:0]),
         .lz_hb_bytes                   (lz_hb_bytes[16:0]),
         .lz_hb_head_ptr                (lz_hb_head_ptr[11:0]),
         .lz_hb_tail_ptr                (lz_hb_tail_ptr[11:0]),
         .lz_local_bytes                (lz_local_bytes[16:0]),
         .xp10_decomp_lz77d_stat_events (xp10_decomp_lz77d_stat_events[LZ77D_STAT_EVENTS_LIMIT:LZ77D_STAT_EVENTS_BASE]),
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .ovstb                         (ovstb),
         .lvm                           (lvm),
         .mlvm                          (mlvm),
         .bimc_idat                     (bimc_lz77_idat),        
         .bimc_isync                    (bimc_lz77_isync),       
         .bimc_rst_n                    (bimc_rst_n),
         .fhp_lz_prefix_hdr_valid       (fhp_lz_prefix_hdr_valid),
         .fhp_lz_prefix_hdr_bus         (fhp_lz_prefix_hdr_bus),
         .fhp_lz_prefix_valid           (fhp_lz_prefix_valid),
         .fhp_lz_prefix_dp_bus          (fhp_lz_prefix_dp_bus),
         .fhp_lz_dbg_data_valid         (fhp_lz_dbg_data_valid),
         .fhp_lz_dbg_data_bus           (fhp_lz_dbg_data_bus),
         .mtf_lz_dp_valid               (_mtf_lz_dp_valid),      
         .mtf_lz_dp_bus                 (_mtf_lz_dp_bus),        
         .be_lz_dp_ready                (be_lz_dp_ready),
         .sw_LZ_BYPASS_CONFIG           (sw_LZ_BYPASS_CONFIG));

      cr_xp10_decomp_be be
        (
         
         .xp10_decomp_ob_out            (xp10_decomp_ob_out),
         .be_fhp_dp_ready               (be_fhp_dp_ready),
         .be_lz_dp_ready                (be_lz_dp_ready),
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .xp10_decomp_ob_in             (xp10_decomp_ob_in),
         .lfa_be_crc_valid              (lfa_be_crc_valid),
         .lfa_be_crc_bus                (lfa_be_crc_bus),
         .fhp_be_dp_valid               (fhp_be_dp_valid),
         .fhp_be_dp_bus                 (fhp_be_dp_bus),
         .fhp_be_usr_data               (fhp_be_usr_data),
         .fhp_be_usr_valid              (fhp_be_usr_valid),
         .lz_be_dp_valid                (lz_be_dp_valid),
         .lz_be_dp_bus                  (lz_be_dp_bus),
         .sw_LZ_BYPASS_CONFIG           (sw_LZ_BYPASS_CONFIG),
         .sw_IGNORE_CRC_CONFIG          (sw_IGNORE_CRC_CONFIG),
         .sw_LZ_DECOMP_OLIMIT           (sw_LZ_DECOMP_OLIMIT[23:0]),
         .cceip_cfg                     (cceip_cfg));

   end 

   endgenerate
endmodule 









