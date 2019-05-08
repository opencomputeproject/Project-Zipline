/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp_hufd
  #(parameter FPGA_MOD=0)
   (
   
   bimc_odat, bimc_osync, predef_ro_uncorrectable_ecc_error,
   hdr_ro_uncorrectable_ecc_error, htf_bhp_hdr_dp_ready,
   htf_bhp_hdrinfo_ready, htf_bhp_status_valid, htf_bhp_status_bus,
   htf_fhp_bl_ready, sdd_lfa_dp_ready, sdd_lfa_ack_valid,
   sdd_lfa_ack_bus, sdd_mtf_dp_valid, sdd_mtf_dp_bus, htf_bl_im_valid,
   htf_bl_im_data, xp10_decomp_sch_update, deflate_dynamic_blk_stb,
   deflate_fixed_blk_stb, hdr_data_stall_stb, hdr_info_stall_stb,
   predef_stall_stb, xp10_predef_long_blk_stb,
   xp10_predef_short_blk_stb, xp10_retro_long_blk_stb,
   xp10_retro_short_blk_stb, xp10_simple_long_blk_stb,
   xp10_simple_short_blk_stb, chu4k_predef_long_blk_stb,
   chu4k_predef_short_blk_stb, chu4k_retro_long_blk_stb,
   chu4k_retro_short_blk_stb, chu4k_simple_long_blk_stb,
   chu4k_simple_short_blk_stb, chu8k_predef_long_blk_stb,
   chu8k_predef_short_blk_stb, chu8k_retro_long_blk_stb,
   chu8k_retro_short_blk_stb, chu8k_simple_long_blk_stb,
   chu8k_simple_short_blk_stb, xp9_retro_long_blk_stb,
   xp9_retro_short_blk_stb, xp9_simple_long_blk_stb,
   xp9_simple_short_blk_stb, input_stall_stb, buf_full_stall_stb,
   mtf_stb,
   
   clk, rst_n, ovstb, lvm, mlvm, bimc_idat, bimc_isync, bimc_rst_n,
   bhp_htf_hdr_dp_valid, bhp_htf_hdr_dp_bus, bhp_htf_hdrinfo_valid,
   bhp_htf_hdrinfo_bus, bhp_htf_status_ready, fhp_htf_bl_valid,
   fhp_htf_bl_bus, lfa_sdd_dp_valid, lfa_sdd_dp_bus, mtf_sdd_dp_ready,
   htf_bl_im_ready, su_afull_n
   );
   
   import crPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   
   
   
   input         clk;
   input         rst_n; 
  
    
   
   
   input         ovstb;
   input         lvm;
   input         mlvm;

   input         bimc_idat;
   input         bimc_isync;
   input         bimc_rst_n;
   output logic  bimc_odat;
   output logic  bimc_osync;
   output logic  predef_ro_uncorrectable_ecc_error;
   output logic  hdr_ro_uncorrectable_ecc_error;

   
   
   
   input logic   bhp_htf_hdr_dp_valid;
   input         bhp_htf_hdr_dp_bus_t bhp_htf_hdr_dp_bus;
   output logic  htf_bhp_hdr_dp_ready;
   
   
   
   
   input logic   bhp_htf_hdrinfo_valid;
   input         bhp_htf_hdrinfo_bus_t bhp_htf_hdrinfo_bus;
   output logic  htf_bhp_hdrinfo_ready;
   
   
   
   
   output logic  htf_bhp_status_valid;
   output        htf_bhp_status_bus_t htf_bhp_status_bus;
   input logic   bhp_htf_status_ready;

   
   
   
   input logic   fhp_htf_bl_valid;
   input         fhp_htf_bl_bus_t fhp_htf_bl_bus;
   output logic  htf_fhp_bl_ready;

   
   
   
   input logic   lfa_sdd_dp_valid;
   input         lfa_sdd_dp_bus_t lfa_sdd_dp_bus;
   output        sdd_lfa_dp_ready;

   
   
   
   output logic  sdd_lfa_ack_valid;
   output        sdd_lfa_ack_bus_t sdd_lfa_ack_bus;

   
   
   
   output logic sdd_mtf_dp_valid;
   output       lz_symbol_bus_t sdd_mtf_dp_bus;
   input logic  mtf_sdd_dp_ready;

   
   
   
   output logic htf_bl_im_valid;
   output       htf_bl_out_t htf_bl_im_data;
   input        htf_bl_im_ready;

   
   
   
   output        sched_update_if_bus_t xp10_decomp_sch_update;
   input         su_afull_n;

   
   output logic  deflate_dynamic_blk_stb;
   output logic  deflate_fixed_blk_stb;
   output logic  hdr_data_stall_stb;
   output logic  hdr_info_stall_stb;
   output logic  predef_stall_stb;

   output logic  xp10_predef_long_blk_stb;
   output logic  xp10_predef_short_blk_stb;
   output logic  xp10_retro_long_blk_stb;
   output logic  xp10_retro_short_blk_stb;
   output logic  xp10_simple_long_blk_stb;
   output logic  xp10_simple_short_blk_stb;

   output logic  chu4k_predef_long_blk_stb;
   output logic  chu4k_predef_short_blk_stb;
   output logic  chu4k_retro_long_blk_stb;
   output logic  chu4k_retro_short_blk_stb;
   output logic  chu4k_simple_long_blk_stb;
   output logic  chu4k_simple_short_blk_stb;

   output logic  chu8k_predef_long_blk_stb;
   output logic  chu8k_predef_short_blk_stb;
   output logic  chu8k_retro_long_blk_stb;
   output logic  chu8k_retro_short_blk_stb;
   output logic  chu8k_simple_long_blk_stb;
   output logic  chu8k_simple_short_blk_stb;

   output logic  xp9_retro_long_blk_stb;
   output logic  xp9_retro_short_blk_stb;
   output logic  xp9_simple_long_blk_stb;
   output logic  xp9_simple_short_blk_stb;
   output logic  input_stall_stb;
   output logic                        buf_full_stall_stb;
   output logic [3:0]                  mtf_stb;

   `ifdef SHOULD_BE_EMPTY
   
   
   `endif

   
   
   logic [`N_MAX_HUFF_BITS-2:0] htf_sdd_bct_data;
   logic [`LOG_VEC(`N_MAX_HUFF_BITS+1)] htf_sdd_bct_sat_addr;
   logic                htf_sdd_bct_sat_type;   
   logic                htf_sdd_bct_sat_wen;    
   logic                htf_sdd_bct_valid;      
   logic                htf_sdd_complete_error; 
   htf_fmt_e            htf_sdd_complete_fmt;   
   logic                htf_sdd_complete_min_mtf_len;
   logic                htf_sdd_complete_min_ptr_len;
   sched_info_t         htf_sdd_complete_sched_info;
   logic                htf_sdd_complete_valid; 
   logic [`BIT_VEC(2)] [`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)] htf_sdd_ll_slt_addr;
   logic [`BIT_VEC(2)] [`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)] htf_sdd_ll_slt_data;
   logic [`BIT_VEC(2)]  htf_sdd_ll_slt_wen;     
   logic [`LOG_VEC(`N_MAX_SUPPORTED_SYMBOLS)] htf_sdd_sat_data;
   logic [`BIT_VEC(2)] [`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] htf_sdd_ss_slt_addr;
   logic [`BIT_VEC(2)] [`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] htf_sdd_ss_slt_data;
   logic [`BIT_VEC(2)]  htf_sdd_ss_slt_wen;     
   logic                sdd_htf_busy;           
   

   

   cr_xp10_decomp_htf
     #(.BL_PER_CYCLE(2))
   htf
     (
      
      .bimc_odat                        (bimc_odat),
      .bimc_osync                       (bimc_osync),
      .predef_ro_uncorrectable_ecc_error(predef_ro_uncorrectable_ecc_error),
      .hdr_ro_uncorrectable_ecc_error   (hdr_ro_uncorrectable_ecc_error),
      .htf_bhp_hdr_dp_ready             (htf_bhp_hdr_dp_ready),
      .htf_bhp_hdrinfo_ready            (htf_bhp_hdrinfo_ready),
      .htf_bhp_status_valid             (htf_bhp_status_valid),
      .htf_bhp_status_bus               (htf_bhp_status_bus),
      .htf_fhp_bl_ready                 (htf_fhp_bl_ready),
      .htf_sdd_bct_sat_wen              (htf_sdd_bct_sat_wen),
      .htf_sdd_bct_sat_type             (htf_sdd_bct_sat_type),
      .htf_sdd_bct_sat_addr             (htf_sdd_bct_sat_addr[`LOG_VEC(`N_MAX_HUFF_BITS+1)]),
      .htf_sdd_bct_valid                (htf_sdd_bct_valid),
      .htf_sdd_bct_data                 (htf_sdd_bct_data[`N_MAX_HUFF_BITS-2:0]),
      .htf_sdd_sat_data                 (htf_sdd_sat_data[`LOG_VEC(`N_MAX_SUPPORTED_SYMBOLS)]),
      .htf_sdd_ss_slt_wen               (htf_sdd_ss_slt_wen[`BIT_VEC(2)]),
      .htf_sdd_ss_slt_addr              (htf_sdd_ss_slt_addr),
      .htf_sdd_ss_slt_data              (htf_sdd_ss_slt_data),
      .htf_sdd_ll_slt_wen               (htf_sdd_ll_slt_wen[`BIT_VEC(2)]),
      .htf_sdd_ll_slt_addr              (htf_sdd_ll_slt_addr),
      .htf_sdd_ll_slt_data              (htf_sdd_ll_slt_data),
      .htf_sdd_complete_valid           (htf_sdd_complete_valid),
      .htf_sdd_complete_fmt             (htf_sdd_complete_fmt),
      .htf_sdd_complete_min_ptr_len     (htf_sdd_complete_min_ptr_len),
      .htf_sdd_complete_min_mtf_len     (htf_sdd_complete_min_mtf_len),
      .htf_sdd_complete_sched_info      (htf_sdd_complete_sched_info),
      .htf_sdd_complete_error           (htf_sdd_complete_error),
      .htf_bl_im_valid                  (htf_bl_im_valid),
      .htf_bl_im_data                   (htf_bl_im_data),
      .deflate_dynamic_blk_stb          (deflate_dynamic_blk_stb),
      .deflate_fixed_blk_stb            (deflate_fixed_blk_stb),
      .hdr_data_stall_stb               (hdr_data_stall_stb),
      .hdr_info_stall_stb               (hdr_info_stall_stb),
      .predef_stall_stb                 (predef_stall_stb),
      .xp10_predef_long_blk_stb         (xp10_predef_long_blk_stb),
      .xp10_predef_short_blk_stb        (xp10_predef_short_blk_stb),
      .xp10_retro_long_blk_stb          (xp10_retro_long_blk_stb),
      .xp10_retro_short_blk_stb         (xp10_retro_short_blk_stb),
      .xp10_simple_long_blk_stb         (xp10_simple_long_blk_stb),
      .xp10_simple_short_blk_stb        (xp10_simple_short_blk_stb),
      .chu4k_predef_long_blk_stb        (chu4k_predef_long_blk_stb),
      .chu4k_predef_short_blk_stb       (chu4k_predef_short_blk_stb),
      .chu4k_retro_long_blk_stb         (chu4k_retro_long_blk_stb),
      .chu4k_retro_short_blk_stb        (chu4k_retro_short_blk_stb),
      .chu4k_simple_long_blk_stb        (chu4k_simple_long_blk_stb),
      .chu4k_simple_short_blk_stb       (chu4k_simple_short_blk_stb),
      .chu8k_predef_long_blk_stb        (chu8k_predef_long_blk_stb),
      .chu8k_predef_short_blk_stb       (chu8k_predef_short_blk_stb),
      .chu8k_retro_long_blk_stb         (chu8k_retro_long_blk_stb),
      .chu8k_retro_short_blk_stb        (chu8k_retro_short_blk_stb),
      .chu8k_simple_long_blk_stb        (chu8k_simple_long_blk_stb),
      .chu8k_simple_short_blk_stb       (chu8k_simple_short_blk_stb),
      .xp9_retro_long_blk_stb           (xp9_retro_long_blk_stb),
      .xp9_retro_short_blk_stb          (xp9_retro_short_blk_stb),
      .xp9_simple_long_blk_stb          (xp9_simple_long_blk_stb),
      .xp9_simple_short_blk_stb         (xp9_simple_short_blk_stb),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .ovstb                            (ovstb),
      .lvm                              (lvm),
      .mlvm                             (mlvm),
      .bimc_idat                        (bimc_idat),
      .bimc_isync                       (bimc_isync),
      .bimc_rst_n                       (bimc_rst_n),
      .bhp_htf_hdr_dp_valid             (bhp_htf_hdr_dp_valid),
      .bhp_htf_hdr_dp_bus               (bhp_htf_hdr_dp_bus),
      .bhp_htf_hdrinfo_valid            (bhp_htf_hdrinfo_valid),
      .bhp_htf_hdrinfo_bus              (bhp_htf_hdrinfo_bus),
      .bhp_htf_status_ready             (bhp_htf_status_ready),
      .fhp_htf_bl_valid                 (fhp_htf_bl_valid),
      .fhp_htf_bl_bus                   (fhp_htf_bl_bus),
      .sdd_htf_busy                     (sdd_htf_busy),
      .htf_bl_im_ready                  (htf_bl_im_ready));

   

   cr_xp10_decomp_sdd
     #(.BL_PER_CYCLE(2),
       .FPGA_MOD(FPGA_MOD))
   sdd
     (
      
      .sdd_lfa_dp_ready                 (sdd_lfa_dp_ready),
      .sdd_lfa_ack_valid                (sdd_lfa_ack_valid),
      .sdd_lfa_ack_bus                  (sdd_lfa_ack_bus),
      .sdd_mtf_dp_valid                 (sdd_mtf_dp_valid),
      .sdd_mtf_dp_bus                   (sdd_mtf_dp_bus),
      .xp10_decomp_sch_update           (xp10_decomp_sch_update),
      .sdd_htf_busy                     (sdd_htf_busy),
      .input_stall_stb                  (input_stall_stb),
      .buf_full_stall_stb               (buf_full_stall_stb),
      .mtf_stb                          (mtf_stb[3:0]),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .lfa_sdd_dp_valid                 (lfa_sdd_dp_valid),
      .lfa_sdd_dp_bus                   (lfa_sdd_dp_bus),
      .mtf_sdd_dp_ready                 (mtf_sdd_dp_ready),
      .htf_sdd_bct_sat_wen              (htf_sdd_bct_sat_wen),
      .htf_sdd_bct_sat_type             (htf_sdd_bct_sat_type),
      .htf_sdd_bct_sat_addr             (htf_sdd_bct_sat_addr[`LOG_VEC(`N_MAX_HUFF_BITS+1)]),
      .htf_sdd_bct_valid                (htf_sdd_bct_valid),
      .htf_sdd_bct_data                 (htf_sdd_bct_data[`N_MAX_HUFF_BITS-2:0]),
      .htf_sdd_sat_data                 (htf_sdd_sat_data[`LOG_VEC(`N_MAX_SUPPORTED_SYMBOLS)]),
      .htf_sdd_ss_slt_wen               (htf_sdd_ss_slt_wen[`BIT_VEC(2)]),
      .htf_sdd_ss_slt_addr              (htf_sdd_ss_slt_addr),
      .htf_sdd_ss_slt_data              (htf_sdd_ss_slt_data),
      .htf_sdd_ll_slt_wen               (htf_sdd_ll_slt_wen[`BIT_VEC(2)]),
      .htf_sdd_ll_slt_addr              (htf_sdd_ll_slt_addr),
      .htf_sdd_ll_slt_data              (htf_sdd_ll_slt_data),
      .su_afull_n                       (su_afull_n),
      .htf_sdd_complete_valid           (htf_sdd_complete_valid),
      .htf_sdd_complete_fmt             (htf_sdd_complete_fmt),
      .htf_sdd_complete_min_ptr_len     (htf_sdd_complete_min_ptr_len),
      .htf_sdd_complete_min_mtf_len     (htf_sdd_complete_min_mtf_len),
      .htf_sdd_complete_sched_info      (htf_sdd_complete_sched_info),
      .htf_sdd_complete_error           (htf_sdd_complete_error));

endmodule 







