/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp_htf (
   
   bimc_odat, bimc_osync, predef_ro_uncorrectable_ecc_error,
   hdr_ro_uncorrectable_ecc_error, htf_bhp_hdr_dp_ready,
   htf_bhp_hdrinfo_ready, htf_bhp_status_valid, htf_bhp_status_bus,
   htf_fhp_bl_ready, htf_sdd_bct_sat_wen, htf_sdd_bct_sat_type,
   htf_sdd_bct_sat_addr, htf_sdd_bct_valid, htf_sdd_bct_data,
   htf_sdd_sat_data, htf_sdd_ss_slt_wen, htf_sdd_ss_slt_addr,
   htf_sdd_ss_slt_data, htf_sdd_ll_slt_wen, htf_sdd_ll_slt_addr,
   htf_sdd_ll_slt_data, htf_sdd_complete_valid, htf_sdd_complete_fmt,
   htf_sdd_complete_min_ptr_len, htf_sdd_complete_min_mtf_len,
   htf_sdd_complete_sched_info, htf_sdd_complete_error,
   htf_bl_im_valid, htf_bl_im_data, deflate_dynamic_blk_stb,
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
   xp9_simple_short_blk_stb,
   
   clk, rst_n, ovstb, lvm, mlvm, bimc_idat, bimc_isync, bimc_rst_n,
   bhp_htf_hdr_dp_valid, bhp_htf_hdr_dp_bus, bhp_htf_hdrinfo_valid,
   bhp_htf_hdrinfo_bus, bhp_htf_status_ready, fhp_htf_bl_valid,
   fhp_htf_bl_bus, sdd_htf_busy, htf_bl_im_ready
   );

   parameter BL_PER_CYCLE = 2;
   
   import crPKG::lz_symbol_bus_t;
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

   
   
   
   output logic                             htf_sdd_bct_sat_wen;
   output logic                             htf_sdd_bct_sat_type;
   output logic [`LOG_VEC(`N_MAX_HUFF_BITS+1)] htf_sdd_bct_sat_addr;
   output logic                             htf_sdd_bct_valid;
   output logic [`N_MAX_HUFF_BITS-2:0]         htf_sdd_bct_data;
   output logic [`LOG_VEC(`N_MAX_SUPPORTED_SYMBOLS)]     htf_sdd_sat_data;
   
   
   
   

   output logic [`BIT_VEC(BL_PER_CYCLE)] htf_sdd_ss_slt_wen;
   output logic [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] htf_sdd_ss_slt_addr;
   output logic [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] htf_sdd_ss_slt_data;

   output logic [`BIT_VEC(BL_PER_CYCLE)] htf_sdd_ll_slt_wen;
   output logic [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)] htf_sdd_ll_slt_addr;
   output logic [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)] htf_sdd_ll_slt_data;

   
   
   
   output logic                               htf_sdd_complete_valid;
   output                                     htf_fmt_e htf_sdd_complete_fmt;
   output                                     htf_sdd_complete_min_ptr_len;
   output                                     htf_sdd_complete_min_mtf_len;
   output                                     sched_info_t htf_sdd_complete_sched_info;
   
   
   
   
   
   
   output                                     htf_sdd_complete_error;

   input                                      sdd_htf_busy;

   
   
   
   output logic htf_bl_im_valid;
   output       htf_bl_out_t htf_bl_im_data;
   input        htf_bl_im_ready;

   
   output logic deflate_dynamic_blk_stb;
   output logic deflate_fixed_blk_stb;
   output logic hdr_data_stall_stb;
   output logic hdr_info_stall_stb;
   output logic predef_stall_stb;
   output logic xp10_predef_long_blk_stb;
   output logic xp10_predef_short_blk_stb;
   output logic xp10_retro_long_blk_stb;
   output logic xp10_retro_short_blk_stb;
   output logic xp10_simple_long_blk_stb;
   output logic xp10_simple_short_blk_stb;

   output logic chu4k_predef_long_blk_stb;
   output logic chu4k_predef_short_blk_stb;
   output logic chu4k_retro_long_blk_stb;
   output logic chu4k_retro_short_blk_stb;
   output logic chu4k_simple_long_blk_stb;
   output logic chu4k_simple_short_blk_stb;

   output logic chu8k_predef_long_blk_stb;
   output logic chu8k_predef_short_blk_stb;
   output logic chu8k_retro_long_blk_stb;
   output logic chu8k_retro_short_blk_stb;
   output logic chu8k_simple_long_blk_stb;
   output logic chu8k_simple_short_blk_stb;

   output logic xp9_retro_long_blk_stb;
   output logic xp9_retro_short_blk_stb;
   output logic xp9_simple_long_blk_stb;
   output logic xp9_simple_short_blk_stb;

`ifdef SHOULD_BE_EMPTY
   
   
`endif

   
   
   logic [`BIT_VEC((`N_XP10_64K_SHRT_SYMBOLS))] [`BIT_VEC(($clog2(`N_MAX_HUFF_BITS+1)))] blt;
   logic [`LOG_VEC((`N_XP10_64K_SHRT_SYMBOLS)+1)] blt_depth;
   logic                blt_hist_busy;          
   logic                blt_hist_complete_error;
   htf_fmt_e            blt_hist_complete_fmt;  
   logic                blt_hist_complete_min_mtf_len;
   logic                blt_hist_complete_min_ptr_len;
   sched_info_t         blt_hist_complete_sched_info;
   logic [`LOG_VEC(`N_HTF_HDR_FIFO_DEPTH*`AXI_S_DP_DWIDTH+1)] blt_hist_complete_total_bit_count;
   logic                blt_hist_complete_valid;
   logic                blt_hist_start_valid;   
   logic [`BIT_VEC(BL_PER_CYCLE)] [`LOG_VEC(`N_MAX_HUFF_BITS+1)] blt_hist_wdata;
   logic [`LOG_VEC(BL_PER_CYCLE+1)] blt_hist_wen;
   logic                chain_bimc_dat;         
   logic                chain_bimc_sync;        
   logic [`LOG_VEC((BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS)+1)] hdr_bits_avail;
   logic [`LOG_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS+1)] hdr_bits_consume;
   logic [`BIT_VEC((BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS))] hdr_bits_data;
   logic                hdr_bits_err;           
   logic                hdr_bits_last;          
   logic                hdr_clear;              
   logic [`BIT_VEC_BASE((`N_MAX_HUFF_BITS),1)] [`BIT_VEC(($clog2(`N_XP10_64K_SHRT_SYMBOLS+1)))] histogram;
   logic                predef_bl_done;         
   logic                predef_bl_req_ll;       
   logic [9:0]          predef_bl_req_num_bl;   
   logic                predef_bl_req_ready;    
   logic                predef_bl_req_valid;    
   logic [`LOG_VEC((BL_PER_CYCLE*$clog2(`N_MAX_HUFF_BITS+1))+1)] predef_bl_rsp_bits_avail;
   logic [`LOG_VEC(BL_PER_CYCLE*$clog2(`N_MAX_HUFF_BITS+1)+1)] predef_bl_rsp_bits_consume;
   logic [`BIT_VEC((BL_PER_CYCLE*$clog2(`N_MAX_HUFF_BITS+1)))] predef_bl_rsp_bits_data;
   


   

   cr_xp10_decomp_htf_predef_buf 
     #(.DP_WIDTH(`AXI_S_DP_DWIDTH),
       .MAX_RSP_BITS_PER_CYCLE(BL_PER_CYCLE*$clog2(`N_MAX_HUFF_BITS+1)))
   u_predef_buf
     (
      
      .bimc_odat                        (chain_bimc_dat),        
      .bimc_osync                       (chain_bimc_sync),       
      .predef_ro_uncorrectable_ecc_error(predef_ro_uncorrectable_ecc_error),
      .htf_fhp_bl_ready                 (htf_fhp_bl_ready),
      .predef_bl_req_ready              (predef_bl_req_ready),
      .predef_bl_rsp_bits_avail         (predef_bl_rsp_bits_avail[`LOG_VEC((BL_PER_CYCLE*$clog2(`N_MAX_HUFF_BITS+1))+1)]),
      .predef_bl_rsp_bits_data          (predef_bl_rsp_bits_data[`BIT_VEC((BL_PER_CYCLE*$clog2(`N_MAX_HUFF_BITS+1)))]),
      .predef_stall_stb                 (predef_stall_stb),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .ovstb                            (ovstb),
      .lvm                              (lvm),
      .mlvm                             (mlvm),
      .bimc_idat                        (bimc_idat),
      .bimc_isync                       (bimc_isync),
      .bimc_rst_n                       (bimc_rst_n),
      .fhp_htf_bl_valid                 (fhp_htf_bl_valid),
      .fhp_htf_bl_bus                   (fhp_htf_bl_bus),
      .predef_bl_req_valid              (predef_bl_req_valid),
      .predef_bl_req_ll                 (predef_bl_req_ll),
      .predef_bl_req_num_bl             (predef_bl_req_num_bl[9:0]),
      .predef_bl_rsp_bits_consume       (predef_bl_rsp_bits_consume[`LOG_VEC((BL_PER_CYCLE*$clog2(`N_MAX_HUFF_BITS+1))+1)]),
      .predef_bl_done                   (predef_bl_done));
       
   
   cr_xp10_decomp_htf_hdr_fifo
     #(.DP_WIDTH(`AXI_S_DP_DWIDTH),
       .MAX_HDR_BITS_PER_CYCLE(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS))
   u_hdr_fifo
     (
      
      .bimc_odat                        (bimc_odat),
      .bimc_osync                       (bimc_osync),
      .hdr_ro_uncorrectable_ecc_error   (hdr_ro_uncorrectable_ecc_error),
      .htf_bhp_hdr_dp_ready             (htf_bhp_hdr_dp_ready),
      .hdr_bits_avail                   (hdr_bits_avail[`LOG_VEC((BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS)+1)]),
      .hdr_bits_data                    (hdr_bits_data[`BIT_VEC((BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS))]),
      .hdr_bits_last                    (hdr_bits_last),
      .hdr_bits_err                     (hdr_bits_err),
      .hdr_data_stall_stb               (hdr_data_stall_stb),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .ovstb                            (ovstb),
      .lvm                              (lvm),
      .mlvm                             (mlvm),
      .bimc_rst_n                       (bimc_rst_n),
      .bimc_isync                       (chain_bimc_sync),       
      .bimc_idat                        (chain_bimc_dat),        
      .bhp_htf_hdr_dp_valid             (bhp_htf_hdr_dp_valid),
      .bhp_htf_hdr_dp_bus               (bhp_htf_hdr_dp_bus),
      .hdr_bits_consume                 (hdr_bits_consume[`LOG_VEC((BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS)+1)]),
      .hdr_clear                        (hdr_clear));

   cr_xp10_decomp_htf_symtab_dec
     #(.DP_WIDTH(`AXI_S_DP_DWIDTH),
       .BL_PER_CYCLE(BL_PER_CYCLE))
   u_symtab_dec
     (
      
      .htf_bhp_hdrinfo_ready            (htf_bhp_hdrinfo_ready),
      .htf_bhp_status_valid             (htf_bhp_status_valid),
      .htf_bhp_status_bus               (htf_bhp_status_bus),
      .hdr_bits_consume                 (hdr_bits_consume[`LOG_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS+1)]),
      .hdr_clear                        (hdr_clear),
      .predef_bl_req_valid              (predef_bl_req_valid),
      .predef_bl_req_ll                 (predef_bl_req_ll),
      .predef_bl_req_num_bl             (predef_bl_req_num_bl[9:0]),
      .predef_bl_rsp_bits_consume       (predef_bl_rsp_bits_consume[`LOG_VEC(BL_PER_CYCLE*$clog2(`N_MAX_HUFF_BITS+1)+1)]),
      .predef_bl_done                   (predef_bl_done),
      .blt_hist_wen                     (blt_hist_wen[`LOG_VEC(BL_PER_CYCLE+1)]),
      .blt_hist_wdata                   (blt_hist_wdata),
      .blt_hist_complete_valid          (blt_hist_complete_valid),
      .blt_hist_start_valid             (blt_hist_start_valid),
      .blt_hist_complete_fmt            (blt_hist_complete_fmt),
      .blt_hist_complete_min_ptr_len    (blt_hist_complete_min_ptr_len),
      .blt_hist_complete_min_mtf_len    (blt_hist_complete_min_mtf_len),
      .blt_hist_complete_total_bit_count(blt_hist_complete_total_bit_count[`LOG_VEC(`N_HTF_HDR_FIFO_DEPTH*`AXI_S_DP_DWIDTH+1)]),
      .blt_hist_complete_sched_info     (blt_hist_complete_sched_info),
      .blt_hist_complete_error          (blt_hist_complete_error),
      .htf_bl_im_valid                  (htf_bl_im_valid),
      .htf_bl_im_data                   (htf_bl_im_data),
      .xp9_simple_short_blk_stb         (xp9_simple_short_blk_stb),
      .xp9_retro_short_blk_stb          (xp9_retro_short_blk_stb),
      .xp9_simple_long_blk_stb          (xp9_simple_long_blk_stb),
      .xp9_retro_long_blk_stb           (xp9_retro_long_blk_stb),
      .xp10_simple_short_blk_stb        (xp10_simple_short_blk_stb),
      .xp10_retro_short_blk_stb         (xp10_retro_short_blk_stb),
      .xp10_predef_short_blk_stb        (xp10_predef_short_blk_stb),
      .xp10_simple_long_blk_stb         (xp10_simple_long_blk_stb),
      .xp10_retro_long_blk_stb          (xp10_retro_long_blk_stb),
      .xp10_predef_long_blk_stb         (xp10_predef_long_blk_stb),
      .chu4k_simple_short_blk_stb       (chu4k_simple_short_blk_stb),
      .chu4k_retro_short_blk_stb        (chu4k_retro_short_blk_stb),
      .chu4k_predef_short_blk_stb       (chu4k_predef_short_blk_stb),
      .chu4k_simple_long_blk_stb        (chu4k_simple_long_blk_stb),
      .chu4k_retro_long_blk_stb         (chu4k_retro_long_blk_stb),
      .chu4k_predef_long_blk_stb        (chu4k_predef_long_blk_stb),
      .chu8k_simple_short_blk_stb       (chu8k_simple_short_blk_stb),
      .chu8k_retro_short_blk_stb        (chu8k_retro_short_blk_stb),
      .chu8k_predef_short_blk_stb       (chu8k_predef_short_blk_stb),
      .chu8k_simple_long_blk_stb        (chu8k_simple_long_blk_stb),
      .chu8k_retro_long_blk_stb         (chu8k_retro_long_blk_stb),
      .chu8k_predef_long_blk_stb        (chu8k_predef_long_blk_stb),
      .deflate_dynamic_blk_stb          (deflate_dynamic_blk_stb),
      .deflate_fixed_blk_stb            (deflate_fixed_blk_stb),
      .hdr_info_stall_stb               (hdr_info_stall_stb),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .bhp_htf_hdrinfo_valid            (bhp_htf_hdrinfo_valid),
      .bhp_htf_hdrinfo_bus              (bhp_htf_hdrinfo_bus),
      .bhp_htf_status_ready             (bhp_htf_status_ready),
      .hdr_bits_avail                   (hdr_bits_avail[`LOG_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS+1)]),
      .hdr_bits_data                    (hdr_bits_data[`BIT_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS)]),
      .hdr_bits_last                    (hdr_bits_last),
      .hdr_bits_err                     (hdr_bits_err),
      .predef_bl_req_ready              (predef_bl_req_ready),
      .predef_bl_rsp_bits_avail         (predef_bl_rsp_bits_avail[`LOG_VEC(BL_PER_CYCLE*$clog2(`N_MAX_HUFF_BITS+1)+1)]),
      .predef_bl_rsp_bits_data          (predef_bl_rsp_bits_data[`BIT_VEC(BL_PER_CYCLE*$clog2(`N_MAX_HUFF_BITS+1))]),
      .blt_hist_busy                    (blt_hist_busy),
      .htf_bl_im_ready                  (htf_bl_im_ready));


   
   cr_xp10_decomp_htf_histogram
     #(.DEPTH(`N_MAX_HUFF_BITS),
       .WIDTH($clog2(`N_XP10_64K_SHRT_SYMBOLS+1)),
       .NUM_INC_PORTS(BL_PER_CYCLE))
   u_histogram
     (
      
      .histogram                        (histogram),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .hist_waddr                       (blt_hist_wdata),        
      .hist_inc                         (blt_hist_wen),          
      .hist_start                       (blt_hist_start_valid));  

   
   cr_xp10_decomp_htf_blt
     #(.DEPTH(`N_XP10_64K_SHRT_SYMBOLS),
       .WIDTH($clog2(`N_MAX_HUFF_BITS+1)),
       .NUM_WR_PORTS(BL_PER_CYCLE))
   u_blt
     (
      
      .blt                              (blt),
      .blt_depth                        (blt_depth[`LOG_VEC((`N_XP10_64K_SHRT_SYMBOLS)+1)]),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .blt_wdata                        (blt_hist_wdata),        
      .blt_wen                          (blt_hist_wen),          
      .blt_start                        (blt_hist_start_valid));  
   
   cr_xp10_decomp_htf_table_writer
     #(.BL_PER_CYCLE(BL_PER_CYCLE))
   u_table_writer
     (
      
      .blt_hist_busy                    (blt_hist_busy),
      .htf_sdd_complete_valid           (htf_sdd_complete_valid),
      .htf_sdd_complete_fmt             (htf_sdd_complete_fmt),
      .htf_sdd_complete_min_ptr_len     (htf_sdd_complete_min_ptr_len),
      .htf_sdd_complete_min_mtf_len     (htf_sdd_complete_min_mtf_len),
      .htf_sdd_complete_sched_info      (htf_sdd_complete_sched_info),
      .htf_sdd_complete_error           (htf_sdd_complete_error),
      .htf_sdd_bct_sat_wen              (htf_sdd_bct_sat_wen),
      .htf_sdd_bct_sat_type             (htf_sdd_bct_sat_type),
      .htf_sdd_bct_sat_addr             (htf_sdd_bct_sat_addr[`LOG_VEC(`N_MAX_HUFF_BITS+1)]),
      .htf_sdd_bct_valid                (htf_sdd_bct_valid),
      .htf_sdd_bct_data                 (htf_sdd_bct_data[`N_MAX_HUFF_BITS-2:0]),
      .htf_sdd_sat_data                 (htf_sdd_sat_data[`LOG_VEC(`N_MAX_SUPPORTED_SYMBOLS)]),
      .htf_sdd_ss_slt_wen               (htf_sdd_ss_slt_wen[`BIT_VEC(BL_PER_CYCLE)]),
      .htf_sdd_ss_slt_addr              (htf_sdd_ss_slt_addr),
      .htf_sdd_ss_slt_data              (htf_sdd_ss_slt_data),
      .htf_sdd_ll_slt_wen               (htf_sdd_ll_slt_wen[`BIT_VEC(BL_PER_CYCLE)]),
      .htf_sdd_ll_slt_addr              (htf_sdd_ll_slt_addr),
      .htf_sdd_ll_slt_data              (htf_sdd_ll_slt_data),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .blt_hist_complete_valid          (blt_hist_complete_valid),
      .blt_hist_complete_fmt            (blt_hist_complete_fmt),
      .blt_hist_complete_min_ptr_len    (blt_hist_complete_min_ptr_len),
      .blt_hist_complete_min_mtf_len    (blt_hist_complete_min_mtf_len),
      .blt_hist_complete_total_bit_count(blt_hist_complete_total_bit_count[`LOG_VEC(`N_HTF_HDR_FIFO_DEPTH*`AXI_S_DP_DWIDTH+1)]),
      .blt_hist_complete_sched_info     (blt_hist_complete_sched_info),
      .blt_hist_complete_error          (blt_hist_complete_error),
      .histogram                        (histogram),
      .blt                              (blt),
      .blt_depth                        (blt_depth[`LOG_VEC(`N_MAX_SUPPORTED_SYMBOLS)]),
      .sdd_htf_busy                     (sdd_htf_busy));
   

endmodule 







