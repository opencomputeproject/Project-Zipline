/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp_fe_lfa (
   
   bimc_odat, bimc_osync, lfa_sdd_dp_valid, lfa_sdd_dp_bus,
   lfa_fhp_sof_ready, lfa_fhp_dp_ready, lfa_bhp_dp_bus,
   lfa_bhp_dp_valid, lfa_bhp_align_bits, lfa_bhp_sof_valid,
   lfa_bhp_sof_bus, lfa_be_crc_valid, lfa_be_crc_bus,
   fe_lfa_ro_uncorrectable_ecc_error_a,
   fe_lfa_ro_uncorrectable_ecc_error_b,
   
   clk, rst_n, ovstb, lvm, mlvm, bimc_idat, bimc_isync, bimc_rst_n,
   sdd_lfa_dp_ready, sdd_lfa_ack_valid, sdd_lfa_ack_bus,
   fhp_lfa_sof_valid, fhp_lfa_sof_bus, fhp_lfa_clear_sof_fifo,
   fhp_lfa_dp_bus, fhp_lfa_dp_valid, fhp_lfa_eof_bus,
   bhp_lfa_dp_ready, bhp_lfa_status_valid, bhp_lfa_status_bus,
   bhp_lfa_stbl_sent, bhp_lfa_htf_status_valid,
   bhp_lfa_htf_status_bus
   );

   import crPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   
   
   
   input                          clk;
   input                          rst_n; 
   
   
   
   
   input                          ovstb;
   input                          lvm;
   input                          mlvm;
   
   input                          bimc_idat;
   input                          bimc_isync;
   input                          bimc_rst_n;
   output logic                   bimc_odat;
   output logic                   bimc_osync;
   
   
   
   output logic                   lfa_sdd_dp_valid;
   output lfa_sdd_dp_bus_t        lfa_sdd_dp_bus;
   input                          sdd_lfa_dp_ready;

   
   
   
   input logic                    sdd_lfa_ack_valid;
   input sdd_lfa_ack_bus_t        sdd_lfa_ack_bus;

   
   input logic                    fhp_lfa_sof_valid;
   input fe_sof_bus_t             fhp_lfa_sof_bus;
   output logic                   lfa_fhp_sof_ready;
   input                          fhp_lfa_clear_sof_fifo;
   
   input fe_dp_bus_t              fhp_lfa_dp_bus;
   input logic                    fhp_lfa_dp_valid;
   output logic                   lfa_fhp_dp_ready;
   input fe_eof_bus_t             fhp_lfa_eof_bus;
   
   
   
   output fe_dp_bus_t             lfa_bhp_dp_bus;
   output logic                   lfa_bhp_dp_valid;
   input                          bhp_lfa_dp_ready;
   output logic [5:0]             lfa_bhp_align_bits;
   
   output logic                   lfa_bhp_sof_valid;
   output fe_sof_bus_t            lfa_bhp_sof_bus;
   
   
   
   
   input logic                    bhp_lfa_status_valid;
   input bhp_lfa_status_bus_t     bhp_lfa_status_bus; 
   input                          bhp_lfa_stbl_sent;
   input logic                    bhp_lfa_htf_status_valid;
   input bhp_lfa_status_bus_t     bhp_lfa_htf_status_bus; 

   output logic                   lfa_be_crc_valid;
   output lfa_be_crc_bus_t        lfa_be_crc_bus;

   output logic                   fe_lfa_ro_uncorrectable_ecc_error_a;
   output logic                   fe_lfa_ro_uncorrectable_ecc_error_b;
   
   logic                          sof_fifo_wr;
   sof_fifo_t                     sof_fifo_wdata;
   logic                          sof_fifo_rd;
   sof_fifo_t                     sof_fifo_rdata;
   cmd_comp_mode_e                hdr_fmt;
   
   logic                          sof_fifo_empty;

   logic                          wait_for_eof;
   logic                          deflate_data_frm;
   logic                          nxt_deflate_data_frm;
   logic                          deflate_hdr_frm;
   logic                          chu_hdr_frm;
   logic                          chu_frm;
   
   logic [9:0]                    start_addr;
   logic [9:0]                    r_start_addr;
   logic [2:0]                    sof_fifo_used;
   logic                          set_sob;
   logic [27:0]                   eof_frm_bytes;
   logic                          eof_last;
   logic [27:0]                   cur_frm_bytes;
   logic                          cur_last;
   logic [27:0]                   nxt_frm_bytes;
   logic                          nxt_frm_last;
   logic                          last_blk_eob;
   fe_dp_bus_t                    int_lfa_bhp_dp_bus;
   fe_dp_bus_t                    lfa_bhp_dummy_bus;
   logic                          r_deflate_start_hdr;
   
   typedef enum  logic [2:0] {HDR_IDLE_ST = 0,
                              RAW_DATA_ST = 1,
                              HDR_ST = 2,
                              HDR_WAIT_ST = 3,
                              HDR_STBL_ST = 4,
                              HDR_DUMMY_ST = 5} hdr_state_e;
   
   hdr_state_e                        p_hdr_st;

   typedef enum logic [2:0] {STBL_IDLE_ST =0,
                             STBL_ST =1,
                             STBL_WAIT_ST = 2} stbl_state_e;

   stbl_state_e p_stbl_st;
   
   
   typedef enum logic [3:0] {DATA_IDLE_ST = 0, 
                             DATA_ST = 1,
                             DFLATE_EOB_ST = 2,
                             DFLATE_EOF_WAIT_ST = 3,
                             DFLATE_EOF_ST = 4,
                             CRC_ST = 5,
                             ERR_ST = 6,
                             ERR_WAIT_ST = 7,
                             ERR_DUMMY_ST = 8} data_state_e;
   data_state_e                        p_data_st;
   
   logic                          hdr_align_clear;
   logic [5:0]                    new_hdr_align_bits;
   logic [9:0]                    new_hdr_ptr;
   logic [5:0]                    new_data_align_bits;
   logic [9:0]                    new_data_ptr;
   logic [25:0]                   words_to_send;
   
   logic [9:0]                    hdr_head_ptr;
   logic [9:0]                    head_ptr;
   logic [9:0]                    stbl_hdr_head_ptr;
   logic [9:0]                    hdr_tail_ptr;
   logic [9:0]                    hdr_hdr_tail_ptr;
   logic [5:0]                    hdr_align;
   logic [5:0]                    hdr_stbl_align;
   logic [9:0]                    nxt_data_ptr;
   logic [5:0]                    nxt_data_align;
   logic                          nxt_data_valid;
   logic [31:0]                   nxt_data_bits;
   logic [25:0]                   nxt_words_to_send;
   logic [25:0]                   nxt_cnt;
   logic [9:0]                    nxt_nxt_data_ptr;
   logic [5:0]                    nxt_nxt_data_align;
   logic                          nxt_nxt_data_valid;
   logic [31:0]                   nxt_nxt_data_bits;
   logic [25:0]                   nxt_nxt_words_to_send;
   logic [9:0]                    data_tail_ptr;
   logic                          wait_for_eob;
   logic                          lfa_hdr_rd;

   logic [31:0]                   data_size;
   logic [7:0]                    ack_bits;
   logic [31:0]                   r_isize;
   logic [31:0]                   cur_isize;
   logic [31:0]                   f_isize;
   logic [31:0]                   next_isize;
   logic                          n_valid;
   logic                          f_valid;
   
   logic [31:0]                   crc_size;
   logic [9:0]                    cur_data_ptr;
   logic [9:0]                    l_cur_data_ptr;
   logic [9:0]                    lfa_raddr;
   logic                          lfa_rd;
   logic                          lfa_data_rd;
   logic                          nxt_data_trace;
   logic                          nxt_nxt_data_trace;
   logic                          new_data_trace;
   
   fe_dp_bus_t                    lfa_rdata;
   fe_dp_bus_t                    lfa_wdata;
   fe_dp_bus_t                    align_wdata;
   
   logic                          r_lfa_hdr_rd;
   logic                          r_lfa_data_rd;
   logic                          rr_lfa_hdr_rd;
   logic                          rr_lfa_data_rd;
   logic                          r_lfa_rd;
   logic                          rr_lfa_rd;
   logic                          lfa_data_rd_valid;
   
   logic [25:0]                   data_cnt;
   logic [25:0]                   tmp_data_cnt;
   logic [31:0]                   cum_data_cnt;
   logic                          got_eob;
   logic                          r_got_eob;
   logic [5:0]                    data_align;
   logic                          lfa_empty;

   logic [9:0]                    lfa_waddr;

   logic                          lfa_rd_ack;
   logic [9:0]                    lfa_rd_ack_addr;
   logic                          lfa_avail;
   logic                          r_last_blk;
   logic                          r_crc_option;
   
   logic                          sent_eob;
   logic [63:0]                   crc_data;
   logic                          crc_data_valid;

   logic [5:0]                    crc_align;
   logic [9:0]                    crc_tail_ptr;
   logic [5:0]                    new_crc_align_bits;
   logic [9:0]                    new_crc_ptr;
   logic [5:0]                    new_stbl_align_bits;
   logic [9:0]                    new_stbl_ptr;
   logic [9:0]                    stbl_head_ptr;
   logic [9:0]                    data_stbl_head_ptr;
   logic [9:0]                    stbl_tail_ptr;
   logic [5:0]                    stbl_align;
   
   logic [5:0]                    data_stbl_align;
   logic [1:0]                    crc_cnt;
   logic                          lfa_crc_rd;
   logic [63:0]                   first_crc_word;
   logic                          r_lfa_crc_rd;
   logic                          rr_lfa_crc_rd;
   lfa_sdd_dp_bus_t               err_sdd_bus; 
   logic                          tmp_sdd_valid;
   logic                          data_ack;
   logic                          set_eob;
   logic                          set_eof;
   logic                          crc_present;
   cmd_comp_mode_e                cur_data_fmt;
   cmd_comp_mode_e                new_data_fmt;
   cmd_comp_mode_e                nxt_data_fmt;
   cmd_comp_mode_e                nxt_nxt_data_fmt;
   cmd_comp_mode_e                cur_hdr_fmt;
   cmd_comp_mode_e                cur_stbl_fmt;
   cmd_comp_mode_e                new_stbl_fmt;
   
   logic [2:0]                    crc_frm_fmt;
   lfa_sdd_dp_bus_t               sdd_fifo_wbus;
   lfa_sdd_dp_bus_t               sdd_fifo_rbus;
   logic                          sdd_fifo_wr;
   logic                          sdd_fifo_rd;
   logic                          sdd_fifo_empty;
   logic [3:0]                    sdd_fifo_used;
   logic                          lfa_wr;
   logic                          sdd_fifo_ready;
   logic                          wait_for_sdd_ack;
   logic                          data_align_pre_eof;
   lfa_sdd_dp_bus_t               r_lfa_sdd_dp_bus;
   logic                          start_data;
   logic                          r_start_data;
   
   logic                          align_hdr_full;
   logic                          align_data_full;
   logic                          sdd_fifo_clear;
   
   fe_dp_bus_t                    tmp_sdd_bus;
   logic                          byte_align;
   logic                          hdr_byte_align;
   logic                          raw_frame_valid;
   logic                          lfa_rd_avail;
   logic                          hdr_clear;

   logic                          ack_64;
   logic                          r_hdr_align_clear;

   logic                          deflate_raw;
   logic                          nxt_deflate_raw;
   logic                          cur_deflate_raw;
   
   logic                          nxt_nxt_deflate_raw;
   logic [7:0]                    prev_cur_bits;
   logic                          data_ptr_valid;
   logic                          stbl_data_valid;
   logic                          hdr_valid;
   logic                          nxt_hdr_valid;
   logic                          nxt_stbl_valid;
   logic                          nxt_sof_blk;
   logic                          nxt_nxt_sof_blk;
   logic                          new_sof_blk;
   
   logic                          eof_fifo_empty;

   eof_fifo_t                     eof_fifo_rdata;
   eof_fifo_t                     eof_fifo_wdata;
   
   logic [9:0]                    cur_eof_addr;
   logic                          eof_ack;
   logic                          hdr_eof;
   logic                          bhp_status_error;
   logic                          bhp_htf_status_error;
   zipline_error_e                 new_data_err;
   zipline_error_e                 nxt_data_err;
   zipline_error_e                 nxt_nxt_data_err;
   zipline_error_e                 dflate_err;
   
   logic                          xp_frm;
   logic                          raw_frm;
   logic                          nxt_last_blk;
   logic                          nxt_crc_option;
   logic                          nxt_nxt_last_blk;
   logic                          nxt_nxt_crc_option;
   zipline_error_e                 r_sof_error;
   zipline_error_e                 cur_eof_err;
   zipline_error_e                 eof_err;
   logic [6:0]                    raw_data_size;
   logic [6:0]                    numbits_err;
   logic                          set_err_numbits;
   
   logic [9:0]                    eof_addr;
   logic [9:0]                    eof_check;
   logic                          cur_eof_valid;
   logic                          last_rd;
   logic                          one_after_last_rd;
   logic                          trace;
   logic                          cur_hdr_trace;
   logic                          cur_stbl_trace;
   logic                          cur_data_trace;
   logic [9:0]                    nxt_eof_addr;
   logic                          nxt_eof_valid;
   
   logic [31:0]                   new_data_size;
   logic                          new_crc_option;
   logic                          new_last_blk;
   logic [25:0]                   f_cum_size;
   logic                          f_cum_valid;
   logic [25:0]                   s_cum_size;
   logic                          s_cum_valid ;
   
   logic [31:0]                   cum_size;
   logic                          r_sof_trace;
   logic                          nxt_none_fmt;

   logic                          start_hdr;
   logic                          r_start_hdr;
   logic                          start_stbl;
   logic                          eof_hdr_wrd;
   logic                          r_eof_hdr_wrd;
   logic                          rr_eof_hdr_wrd;
   logic                          deflate_eob_eof;
   logic                          clear_sdd;
   logic                          eof_rd;
   logic                          sdd_ack_err;
   logic                          r_sdd_ack_err;
   logic                          all_idle;
   logic                          sent_eof_eob;
   logic                          set_missing_eof_err;
   logic                          rewind_err;
   logic                          rewind_ack_err;
   logic [10:0]                   chk_eof_addr;
   logic                          eof_ack_valid;
   logic                          eob_word_rd;
   logic                          set_sob_eob;
   logic                          set_sob_eob_eof;
   logic                          r_set_sob_eob_eof;
   logic [31:0]                   sdd_ack_cnt;
   logic                          data_eof_cnt;
   logic                          xp_hdr_frm;
   logic                          xp_frm_last_blk;
   logic                          bhp_dp_valid;

   logic                          xp9_first_word;
   logic                          xp10_first_word;
   logic                          first_word_rd;
   logic                          err_eof;
   logic                          xp_eof_clear;
   logic                          hdr_wr;
   logic                          xp9_hdr_eof;
   logic                          xp10_hdr_eof;
   logic                          xp9_eof_hdr_wrd;
   logic                          xp10_eof_hdr_wrd;
   logic                          new_stbl_last;
   logic                          stbl_last_blk;
   logic                          xp9_frm;
   logic                          xp10_frm;
   logic                          xp9_hdr_frm;
   logic                          xp10_hdr_frm;
   logic                          r_rewind_ack_err;
   logic                          last_eof_rd;
   logic                          r_last_eof_rd;
   logic                          pre_last_eof_rd;
   logic                          last_hdr_eof_rd;
   logic                          first_sof_rd;
   logic                          xp10_crc_mode;
   logic                          xp10_runt_blk;
   logic                          deflate_runt_blk;
   logic [6:0]                    blk_hdr_bits;

   logic [6:0]                    xp10_min_sz;
   logic                          runt_blk_valid;
   logic                          pre_runt_err;
   
   logic                          at_eof;
   logic                          xp9_last_blk;
   logic                          set_xp9_last_blk;
   logic                          xp9_stbl_last;
   logic                          runt_err;
   logic [3:0]                    a_bytes;
   logic                          r_sof_blk;
   logic                          stbl_sof_blk;

   logic                          nxt_error_valid;
   logic                          in_last_blk;
   logic                          blk_eob;
   logic                          xp_chu_raw_eob;
   logic                          abort_stbl;
   logic                          abort_frm_early;
   logic                          late_eof_frm;
   logic                          data_cnt_eof_valid;
   logic                          sent_last_eob;
   logic                          rd_data_valid;
   logic                          abort_premature_frm;
   logic                          new_hdr_valid_sof;
   logic                          new_hdr_valid_eof;
   logic                          new_stbl_valid_sof;
   logic                          new_stbl_valid_eof;
   logic                          invalid_hdr_addr;
   logic                          invalid_stbl_addr;
   logic [9:0]                    cur_hdr_ptr;
   logic [9:0]                    cur_stbl_ptr;
   logic [9:0]                    r_lfa_ack_addr;
   logic                          dflate_late_eof;
   logic                          large_data_frm;
   logic                          lfa_sdd_sent_eof;
   logic                          r_lfa_sdd_sent_eof;
   logic                          ack_addr_ok;
   logic [9:0]                    crc_eof_addr;
   logic                          crc_addr_in_range;
   logic                          late_eof_numbits;
   logic [6:0]                    tmp_sdd_bits;
   logic [6:0]                    sdd_data_size;
   logic                          pre_eof_err;
   logic                          wait_for_eof_fifo_rd_ack;
   logic                          cur_sdd_blk;
   
   assign lfa_data_rd_valid = lfa_data_rd && lfa_rd_avail;
   assign lfa_sdd_sent_eof = (lfa_sdd_dp_valid && lfa_sdd_dp_bus.eob && 
                              deflate_data_frm && !cur_deflate_raw && sent_eof_eob) ? 1'b1 : 1'b0;
   
   assign lfa_fhp_dp_ready = lfa_avail;
   
   assign xp_eof_clear = ((p_hdr_st == HDR_ST) && 
                          (xp10_runt_blk ||
                          (abort_frm_early && r_start_hdr && !r_sof_blk && !f_cum_valid) ||
                          (at_eof && xp9_hdr_frm) ||  
                          (r_start_hdr && xp10_hdr_frm && stbl_last_blk))); 
   
   assign at_eof = (r_start_hdr && (p_hdr_st == HDR_ST) && invalid_hdr_addr) ||
                   (r_start_hdr && xp9_hdr_frm && (p_hdr_st == HDR_ST) &&
                    ((eof_hdr_wrd && rr_lfa_hdr_rd) ||
                    (!eof_fifo_empty && 
                     ((eof_fifo_rdata.eof_addr == hdr_head_ptr) ||
                      (hdr_head_ptr == 10'(eof_fifo_rdata.eof_addr +1))))));
   
   assign prev_cur_bits = ack_bits + sdd_lfa_ack_bus.numbits; 

   assign sdd_fifo_wr = ((((p_data_st == ERR_ST) || (p_data_st == ERR_DUMMY_ST)) ? 1'b1 : rd_data_valid) || 
                         ((p_data_st == DFLATE_EOB_ST)&& !cur_deflate_raw && !sent_eof_eob) ||
                         ((p_data_st == DFLATE_EOF_ST) && !(cur_deflate_raw)) ||
                         (set_sob_eob && !in_last_blk) || set_sob_eob_eof);
   
   assign sdd_fifo_wbus.data = (p_data_st == ERR_ST) ? err_sdd_bus.data :
                                tmp_sdd_bus.data;

   assign sdd_fifo_wbus.eof = ((p_data_st == ERR_ST) || set_sob_eob_eof || 
                               (p_data_st == DFLATE_EOF_ST) && !cur_deflate_raw)  ? 
                              1'b1 : set_eof;
   assign sdd_fifo_wbus.sob = (((p_data_st == ERR_ST) && !r_sdd_ack_err) ||
                               (p_data_st == ERR_DUMMY_ST)) ? 
                              1'b1 : set_sob;
   assign sdd_fifo_wbus.eob = (((p_data_st == ERR_ST) && !sent_eof_eob) ||
                               (p_data_st == ERR_DUMMY_ST) ||
                               ((p_data_st == DFLATE_EOB_ST) && !sent_eof_eob) ||
                               ((p_data_st == DFLATE_EOF_ST) && !sent_eof_eob) ||
                               (tmp_sdd_bus.eof && (cur_data_fmt == NONE))) ? 
                              1'b1 : set_eob;
   assign sdd_fifo_wbus.numbits = (set_err_numbits ? numbits_err :
                                  ((((xp_frm || chu_frm || 
                                  (deflate_data_frm && cur_deflate_raw))) && 
                                  (data_size < `AXI_S_DP_DWIDTH)) ? 
                                   sdd_data_size[6:0] : 
                                  (raw_frm  ? raw_data_size :
                                   deflate_data_frm ? tmp_sdd_bits :
                                   `AXI_S_DP_DWIDTH)));
   
   assign numbits_err = (late_eof_frm && !(p_data_st == DFLATE_EOF_ST) ||
                         late_eof_numbits) ? `AXI_S_DP_DWIDTH : '0;
   
   assign late_eof_numbits = (in_last_blk && (xp_frm || chu_frm || cur_deflate_raw) && 
                              (data_size < `AXI_S_DP_DWIDTH) && !set_eob) ? 1'b1 : 1'b0;
   
   assign set_err_numbits = ((p_data_st == ERR_ST) || deflate_eob_eof ||
                             (p_data_st == ERR_DUMMY_ST) || late_eof_frm ||
                             late_eof_numbits);
   
   assign sdd_fifo_wbus.error = (p_data_st == ERR_ST) ? err_sdd_bus.error :
                                (p_data_st == DFLATE_EOF_ST) ? dflate_err : 
                                  set_eof ? eof_err : NO_ERRORS;

   assign dflate_err = (rewind_err) ? HD_LFA_REWIND_FAIL : err_sdd_bus.error;
   
   assign sdd_fifo_wbus.frame_bytes_in = (sdd_fifo_wbus.eof) ? eof_frm_bytes : '0;
   assign sdd_fifo_wbus.last_frame = (sdd_fifo_wbus.eof) ? eof_last : 1'b0;
   
   assign eof_err = (cur_eof_err != NO_ERRORS) ? cur_eof_err : 
                    (set_missing_eof_err ? HD_LFA_MISSING_EOF : 
                     (pre_eof_err ? HD_LFA_PREMATURE_EOF : NO_ERRORS));
   
  
   
      
   assign sdd_fifo_wbus.trace_bit = cur_data_trace;
   
   assign set_eob = (((p_data_st == DATA_ST) && xp_chu_raw_eob) || 
                     ((tmp_sdd_bus.eof && deflate_data_frm && 
                       (r_last_blk || r_last_eof_rd)) || set_sob_eob )) ? 
                    1'b1 : 1'b0;
   assign set_missing_eof_err = set_eof && !r_last_blk && (cur_data_fmt == XP10);
   assign set_eof = ((set_eob && (((r_last_blk) && xp10_frm) || 
                                  (cur_deflate_raw && r_last_blk) ||
                                  (chu_frm) || abort_frm_early ||
                                  (xp9_frm && xp9_last_blk))) ||
                     (tmp_sdd_bus.eof & !chu_frm && !xp_frm && 
                      !deflate_data_frm))
                     && sdd_fifo_wr;
   assign sdd_fifo_rd = (!wait_for_sdd_ack && !sdd_fifo_empty) ? 1'b1 : 1'b0;
   assign sdd_fifo_ready = (sdd_fifo_used < 4'b0101) ? 1'b1 : 1'b0;
   
   assign lfa_sdd_dp_valid = ((sdd_fifo_rd && !clear_sdd) || wait_for_sdd_ack);
   assign lfa_sdd_dp_bus = (sdd_fifo_rd && !clear_sdd) ? sdd_fifo_rbus : 
                           (wait_for_sdd_ack) ? r_lfa_sdd_dp_bus : 0;
   
   assign start_data = ((p_data_st == DATA_IDLE_ST) && nxt_data_valid) ? 
                       1'b1 : 1'b0;
   assign start_hdr = ((p_hdr_st == HDR_IDLE_ST) && nxt_hdr_valid) ? 1'b1 : 1'b0;
   
   assign xp_frm = ((cur_data_fmt == XP9) || (cur_data_fmt == XP10));
   assign xp_hdr_frm = ((cur_hdr_fmt == XP9) || (cur_hdr_fmt == XP10));
   
   assign raw_frm = (cur_data_fmt == NONE) ? 1'b1 : 1'b0;

   assign xp9_frm = (cur_data_fmt == XP9);
   assign xp10_frm = (cur_data_fmt == XP10);

   assign xp9_hdr_frm = (cur_hdr_fmt == XP9);
   assign xp10_hdr_frm = (cur_hdr_fmt == XP10);
   
   assign deflate_eob_eof = ((p_data_st == DFLATE_EOB_ST) ||
                             (p_data_st == DFLATE_EOF_ST));

   assign all_idle = ((p_hdr_st == HDR_IDLE_ST) && (p_stbl_st == STBL_IDLE_ST) 
                      && (p_data_st == DATA_IDLE_ST) && !nxt_data_valid &&
                      !nxt_hdr_valid && bhp_lfa_dp_ready);
   assign nxt_error_valid = ((nxt_data_valid && nxt_data_err != NO_ERRORS) ||
                             runt_err || abort_frm_early || abort_stbl ||
                             late_eof_frm ||
                             (p_data_st == ERR_WAIT_ST) ||
                             (p_data_st == ERR_ST) ||
                             (p_data_st == ERR_DUMMY_ST));
   
   
   assign raw_data_size = ((tmp_sdd_bus.bytes_valid == 3'b0) ? 7'd64 :
                           (tmp_sdd_bus.bytes_valid * 8));

   

   assign chk_eof_addr = (((eof_fifo_rdata.eof_addr == 10'h000) || 
                           (eof_fifo_rdata.eof_addr == 10'h001)) &&
                          ((new_crc_ptr == 10'h3fe) || new_crc_ptr == 10'h3ff))
     ? {1'b1, eof_fifo_rdata.eof_addr} : {1'b0, eof_fifo_rdata.eof_addr};

   assign rewind_err = (r_rewind_ack_err ||
                       (deflate_data_frm && (p_data_st == DFLATE_EOF_ST)) && 
                       !eof_fifo_empty && 
                       ({1'b0,new_crc_ptr} > chk_eof_addr));

   assign rewind_ack_err = (deflate_data_frm && 
                            ((p_data_st == DFLATE_EOF_ST) ||
                             (p_data_st == DFLATE_EOB_ST) || 
                             (p_data_st == DATA_ST)) &&
                            (cur_data_ptr == eof_addr) && !eof_fifo_empty);
   assign in_last_blk = ((p_data_st == DATA_ST) && 
                        ((r_last_blk && cur_deflate_raw) ||
                         (r_last_blk && xp10_frm) ||
                         (xp9_last_blk && xp9_frm) ||
                         (chu_frm) || abort_frm_early));
   assign last_blk_eob = ((p_data_st == DATA_ST) && in_last_blk &&
                          (xp_frm || chu_frm || cur_deflate_raw) &&
                          (data_size <= `AXI_S_DP_DWIDTH) && 
                          (r_last_eof_rd ||
                           (tmp_sdd_bus.eof && tmp_sdd_valid) ||
                           (data_align_pre_eof && tmp_sdd_valid)) ||
                          (abort_frm_early));
   
   assign blk_eob = ((p_data_st == DATA_ST) && 
                     (data_size <= `AXI_S_DP_DWIDTH) && 
                     (xp_frm || chu_frm || cur_deflate_raw)) ? 1'b1 : 1'b0;

   assign xp_chu_raw_eob = (in_last_blk) ? last_blk_eob : blk_eob;
   
   assign data_cnt_eof_valid = (data_cnt < 10'h3ff) ? 1'b1 : 1'b0;

   assign tmp_sdd_bits = (tmp_sdd_bus.bytes_valid == 3'b000) ? 7'd64 : 
                         (tmp_sdd_bus.bytes_valid * 8); 
   assign sdd_data_size = (pre_eof_err) ? tmp_sdd_bits : data_size[6:0];
   
   assign pre_eof_err = ((({25'b0, tmp_sdd_bits} < data_size)) || 
                         (chu_frm && ({25'b0, tmp_sdd_bits} > (data_size + 14)))) ? 1'b1 : 1'b0; 

   
   
   assign wait_for_eof_fifo_rd_ack = ((xp_frm || chu_frm) && in_last_blk) ?
                             !cur_eof_valid : 1'b0;
   

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         lfa_be_crc_bus.crc_frm_fmt <= 0;
         lfa_be_crc_bus.data <= 0;
         lfa_be_crc_bus.isize <= 0;
         lfa_be_crc_valid <= 0;
         lfa_wdata <= 0;
         lfa_wr <= 0;
         sdd_ack_cnt <= 0;
         
      end
      else begin
         lfa_be_crc_valid <= crc_data_valid;
         lfa_be_crc_bus.crc_frm_fmt <= crc_frm_fmt;
         lfa_be_crc_bus.data <= crc_data;
         if (crc_frm_fmt == 3'b100) 
           lfa_be_crc_bus.isize <= crc_data[63:32];
         else
           lfa_be_crc_bus.isize <= crc_size;
         lfa_wdata <= fhp_lfa_dp_bus;
         lfa_wr <= fhp_lfa_dp_valid;

         
         if (sdd_lfa_ack_valid) 
           sdd_ack_cnt <= sdd_ack_cnt + sdd_lfa_ack_bus.numbits; 
         else if (lfa_sdd_dp_bus.eof && lfa_sdd_dp_valid)
           sdd_ack_cnt <= '0;
      end
   end 
   
   
   
   
   

   assign nxt_cnt = (nxt_data_valid) ? nxt_words_to_send : '0;
   assign tmp_data_cnt = (p_data_st == DATA_ST) ? data_cnt : '0;
   assign cum_data_cnt = cum_size + tmp_data_cnt + nxt_cnt; 
   assign cum_size = (f_cum_valid) ?                 
                     (f_cum_size + s_cum_size) : '0; 

   assign nxt_none_fmt = (((!sof_fifo_empty && 
                           sof_fifo_rdata.sof_data.sof_fmt == NONE) && 
                          ((cum_data_cnt > 0) || (p_stbl_st == STBL_WAIT_ST))) ||
                          (p_hdr_st == RAW_DATA_ST) || (nxt_data_valid && nxt_data_fmt == NONE) ||
                         ((p_data_st == DATA_ST) && (raw_frm))) ?
                          1'b1 : 1'b0;

   always_comb
     begin
        sof_fifo_wr = fhp_lfa_sof_valid;
        sof_fifo_wdata.sof_data = fhp_lfa_sof_bus;
        sof_fifo_wdata.addr = lfa_waddr;
        
        
        sof_fifo_rd = (deflate_hdr_frm) ? (all_idle && !sof_fifo_empty && !nxt_error_valid) :
                      (p_hdr_st == HDR_IDLE_ST) && !s_cum_valid &&
                      (cum_data_cnt < 16'd256) && !bhp_lfa_htf_status_valid &&
                      !sof_fifo_empty && !lfa_empty && !nxt_hdr_valid &&
                      !hdr_valid && !nxt_nxt_data_valid && !nxt_none_fmt &&
                      !nxt_error_valid && bhp_lfa_dp_ready;
        
        start_addr = sof_fifo_rdata.addr;
        hdr_fmt = sof_fifo_rdata.sof_data.sof_fmt;
        trace = sof_fifo_rdata.sof_data.trace_bit;
        
        lfa_fhp_sof_ready = (sof_fifo_used < 3'b100) ? 1'b1 : 1'b0;
     end 

   assign deflate_data_frm = ((cur_data_fmt == ZLIB) ||
                              (cur_data_fmt == GZIP)) ? 1'b1 : 1'b0;
   assign nxt_deflate_data_frm = ((nxt_data_fmt == ZLIB) ||
                              (nxt_data_fmt == GZIP)) ? 1'b1 : 1'b0;
   assign deflate_hdr_frm = ((cur_hdr_fmt == ZLIB) ||
                             (cur_hdr_fmt == GZIP)) ? 1'b1 : 1'b0;
   assign chu_hdr_frm = ((cur_hdr_fmt == CHU4K) || (cur_hdr_fmt == CHU8K)) ? 1'b1 : 1'b0;
   assign chu_frm = ((cur_data_fmt == CHU4K) || (cur_data_fmt == CHU8K)) ? 1'b1 : 1'b0;


   
   always_comb
     begin
        new_hdr_valid_sof = 1'b1;
        new_hdr_valid_eof = 1'b1;

        cur_hdr_ptr = (deflate_hdr_frm) ? l_cur_data_ptr : 
                      (large_data_frm || cur_sdd_blk) ? r_lfa_ack_addr : hdr_hdr_tail_ptr;
        head_ptr = (p_data_st == DFLATE_EOB_ST) ? new_hdr_ptr : hdr_head_ptr;
        eof_check = eof_fifo_rdata.eof_addr;
         if (!sof_fifo_empty) begin
           if (cur_hdr_ptr < sof_fifo_rdata.addr) begin
              if ((head_ptr < sof_fifo_rdata.addr) &&
                  (head_ptr >= cur_hdr_ptr))
                new_hdr_valid_sof = 1'b1;
              else
                new_hdr_valid_sof = 1'b0;
           end
           else begin
              if ((head_ptr < sof_fifo_rdata.addr) ||
                  (head_ptr >= cur_hdr_ptr))
                new_hdr_valid_sof = 1'b1;
              else
                new_hdr_valid_sof = 1'b0;
           end
        end 

        if ((xp_frm || chu_frm) && (!cur_eof_valid ||
                                    (cur_eof_valid && nxt_data_valid))) 
          new_hdr_valid_eof = 1'b1;
        else if (!eof_fifo_empty) begin
           if (cur_hdr_ptr <= eof_check) begin
              if (head_ptr > eof_check)
                new_hdr_valid_eof = 1'b0;
              else
                new_hdr_valid_eof = 1'b1;
           end
           else begin
              if ((head_ptr <= eof_check) ||
                  (head_ptr >= cur_hdr_ptr))
                new_hdr_valid_eof = 1'b1;
              else
                new_hdr_valid_eof = 1'b0;
           end
        end 
        
        
        invalid_hdr_addr = ((p_data_st == DFLATE_EOB_ST) || r_start_hdr) &&
                           (!new_hdr_valid_sof || !new_hdr_valid_eof);
        
     end 

   
   
   
   always_comb
     begin
        new_stbl_valid_sof = 1'b1;
        new_stbl_valid_eof = 1'b1;
        
        cur_stbl_ptr = stbl_hdr_head_ptr;
        
        if (!sof_fifo_empty) begin
           if (cur_stbl_ptr < sof_fifo_rdata.addr) begin
              if ((stbl_tail_ptr < sof_fifo_rdata.addr) &&
                  (stbl_tail_ptr >= cur_stbl_ptr))
                new_stbl_valid_sof = 1'b1;
              else
                new_stbl_valid_sof = 1'b0;
           end
           else begin
              if ((stbl_tail_ptr < sof_fifo_rdata.addr) ||
                  (stbl_tail_ptr >= cur_stbl_ptr))
                new_stbl_valid_sof = 1'b1;
              else
                new_stbl_valid_sof = 1'b0;
           end
        end 

        if ((xp_frm || chu_frm) && (!cur_eof_valid ||
                                    (cur_eof_valid && nxt_data_valid)))
          new_stbl_valid_eof = 1'b1;
        else if (!eof_fifo_empty) begin
           if (cur_stbl_ptr <= eof_fifo_rdata.eof_addr) begin
              if (stbl_tail_ptr > (eof_fifo_rdata.eof_addr))
                new_stbl_valid_eof = 1'b0;
              else
                new_stbl_valid_eof = 1'b1;
           end
           else begin
              if ((stbl_tail_ptr <= eof_fifo_rdata.eof_addr) ||
                  (stbl_tail_ptr >= cur_stbl_ptr))
                new_stbl_valid_eof = 1'b1;
              else
                new_stbl_valid_eof = 1'b0;
           end
        end 
        
        invalid_stbl_addr = start_stbl && (!new_stbl_valid_sof || !new_stbl_valid_eof);
     end 
   
   
   
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         cur_hdr_fmt <= NONE;
         
         
         cur_hdr_trace <= 0;
         lfa_bhp_sof_bus <= 0;
         lfa_bhp_sof_valid <= 0;
         r_lfa_ack_addr <= 0;
         
      end
      else begin
         if (sof_fifo_rd) begin
            lfa_bhp_sof_valid <= 1'b1;
            lfa_bhp_sof_bus <= sof_fifo_rdata.sof_data;
            cur_hdr_fmt <= hdr_fmt;
            cur_hdr_trace <= trace;
         end
         else begin
            lfa_bhp_sof_valid <= 1'b0;
         end
         if (lfa_rd_ack)
           r_lfa_ack_addr <= lfa_rd_ack_addr;
      end 
   end 

   

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         p_hdr_st <= HDR_IDLE_ST;
         
      end
      else begin
         case (p_hdr_st)
           HDR_IDLE_ST : begin
              if (sof_fifo_rd) begin
                 if (hdr_fmt == NONE)
                   p_hdr_st <= RAW_DATA_ST;
                 else
                   p_hdr_st <= HDR_ST;
              end
              else if (nxt_nxt_data_valid || abort_frm_early || wait_for_eof_fifo_rd_ack || !bhp_lfa_dp_ready || start_data)
                p_hdr_st <= HDR_IDLE_ST;
              else if (nxt_hdr_valid && ((xp_hdr_frm) || deflate_hdr_frm) && !(bhp_htf_status_error && !r_sof_blk)) begin
                 if ((cum_data_cnt > 16'd512) || s_cum_valid) begin
                    p_hdr_st <= HDR_IDLE_ST;
                 end
                 else if (cum_data_cnt < 16'd512) begin
                    p_hdr_st <= HDR_ST;
                 end
                 else if (deflate_data_frm)
                   p_hdr_st <= HDR_ST;
              end
           end
           RAW_DATA_ST : begin
              p_hdr_st <= HDR_IDLE_ST; 
           end
           HDR_ST : begin
              if ((eof_hdr_wrd && rr_lfa_hdr_rd) ||
                  (xp_eof_clear && stbl_last_blk) ||
                  (abort_frm_early && r_start_hdr && !r_sof_blk && !f_cum_valid))
                p_hdr_st <= HDR_IDLE_ST;
              else if ((xp_eof_clear && xp10_runt_blk) || (deflate_runt_blk))
                p_hdr_st <= HDR_DUMMY_ST;
              else begin
                 if (r_start_hdr && (invalid_hdr_addr || (bhp_htf_status_error && !r_sof_blk)))
                   p_hdr_st <= HDR_IDLE_ST;
                 else if (bhp_lfa_status_valid) begin
                    if (bhp_lfa_status_bus.error != NO_ERRORS)
                      p_hdr_st <= HDR_IDLE_ST;
                    else if (bhp_lfa_status_bus.skip_stbl) 
                      p_hdr_st <= HDR_IDLE_ST;
                    else
                      p_hdr_st <= HDR_WAIT_ST;
                 end
              end
           end 
           HDR_WAIT_ST: begin
              if ((bhp_htf_status_error && !r_sof_blk) || abort_stbl)
                p_hdr_st <= HDR_IDLE_ST;
              else if (p_stbl_st != STBL_WAIT_ST) begin
                 p_hdr_st <= HDR_STBL_ST;
              end
           end 
           HDR_STBL_ST : begin
              if (invalid_stbl_addr)
                p_hdr_st <= HDR_DUMMY_ST;
              else if (bhp_lfa_stbl_sent)
                p_hdr_st <= HDR_IDLE_ST;
           end
           HDR_DUMMY_ST : begin
              p_hdr_st <= HDR_IDLE_ST;
           end
           default : p_hdr_st <= HDR_IDLE_ST;
         endcase 
      end 
   end 
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         p_stbl_st <= STBL_IDLE_ST;
      end
      else begin
         case (p_stbl_st)
           STBL_IDLE_ST : begin
              if (nxt_stbl_valid && !abort_stbl)
                p_stbl_st <= STBL_ST;
           end
           STBL_ST: begin
              if (bhp_lfa_htf_status_valid) 
                p_stbl_st <= STBL_IDLE_ST;
              else if (bhp_lfa_stbl_sent)
                p_stbl_st <= STBL_WAIT_ST;
           end
           STBL_WAIT_ST : begin
              if (bhp_lfa_htf_status_valid) begin
                 p_stbl_st <= STBL_IDLE_ST;
              end
           end 
           default : p_stbl_st <= STBL_IDLE_ST;
         endcase 
      end 
   end 

   assign err_eof = (!eof_fifo_empty && ((data_tail_ptr == eof_addr) ||
                                         (data_tail_ptr == eof_addr+1)));

   assign abort_premature_frm = ((nxt_data_ptr == 10'(eof_fifo_rdata.eof_addr+1)) &&
                                 !eof_fifo_empty && start_data);

   assign ack_addr_ok = ((cur_data_ptr == eof_addr) ||
                         (10'(cur_data_ptr+1) == eof_addr) ||
                         (10'(cur_data_ptr+2) == eof_addr) ||
                         (10'(cur_data_ptr+3) == eof_addr) ||
                         (ack_64 && (10'(cur_data_ptr+4) == eof_addr))) ? 1'b1 : 1'b0;
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         p_data_st <= DATA_IDLE_ST;
         
      end
      else begin
         case (p_data_st)
           DATA_IDLE_ST : begin
              if ((nxt_data_valid && !abort_stbl) ||
                  (abort_stbl && (p_hdr_st == HDR_IDLE_ST))) begin
                 if (abort_premature_frm)
                   p_data_st <= ERR_ST;
                 else if (nxt_data_err != NO_ERRORS) begin
                    if ((nxt_nxt_data_valid && !nxt_nxt_sof_blk) || abort_stbl)
                      p_data_st <= ERR_DUMMY_ST;
                    else
                      p_data_st <= ERR_WAIT_ST;
                 end
                 else
                   p_data_st <= DATA_ST;
              end 
           end
           DATA_ST: begin
              if ((cur_data_fmt == ZLIB) || (cur_data_fmt == GZIP)) begin
                 if (sdd_lfa_ack_valid && (sdd_lfa_ack_bus.eob ||
                                           sdd_lfa_ack_bus.err)) begin
                    if (sdd_lfa_ack_bus.err) begin
                       if (ack_addr_ok && sent_eof_eob)
                         p_data_st <= ERR_ST;
                       else
                         p_data_st <= ERR_WAIT_ST;
                    end
                    else if (r_last_blk)  begin
                       if (sent_eof_eob && ack_addr_ok)
                         p_data_st <= DFLATE_EOF_ST;
                       else
                         p_data_st <= DFLATE_EOF_WAIT_ST;
                    end
                    else
                      p_data_st <= DFLATE_EOB_ST;
                 end
                 else if (got_eob && cur_deflate_raw) begin
                    if (cur_deflate_raw && abort_frm_early)
                      p_data_st <= CRC_ST;
                    else if (r_last_blk)
                      p_data_st <= DFLATE_EOF_ST;
                    else
                      p_data_st <= DFLATE_EOB_ST;
                 end
              end
              else if (got_eob) begin
                 if(set_eof)
                   p_data_st <= CRC_ST;
                 else
                   p_data_st <= DATA_IDLE_ST;
              end
              else if (set_sob_eob)
                p_data_st <= ERR_WAIT_ST;
              
           end
           CRC_ST : begin
              if (crc_cnt == 2)
                p_data_st <= DATA_IDLE_ST;
           end
           DFLATE_EOB_ST : begin
              if (invalid_hdr_addr) 
                p_data_st <= DFLATE_EOF_ST;

              else
                p_data_st <= DATA_IDLE_ST;
           end
           DFLATE_EOF_WAIT_ST : begin
              if ((!eof_fifo_empty && lfa_data_rd_valid && 
                  (data_tail_ptr == eof_fifo_rdata.eof_addr)))
                p_data_st <= DFLATE_EOF_ST;
           end
           DFLATE_EOF_ST : begin
              p_data_st <= CRC_ST;
           end
           ERR_DUMMY_ST : begin
              p_data_st <= ERR_WAIT_ST;
           end
           ERR_WAIT_ST : begin
              if (err_eof) begin
                 p_data_st <= ERR_ST;
              end
           end
           ERR_ST : begin
                p_data_st <= DATA_IDLE_ST;
           end
           default : begin
              p_data_st <= DATA_IDLE_ST;
           end
         endcase 
      end 
   end 
   
   assign data_ack = (((p_data_st == DATA_ST) && !in_last_blk) ||
                     ((p_data_st == DATA_ST) && in_last_blk && 
                      (!last_rd || sent_last_eob || (last_rd && align_data_full)))) ? 1'b1 : 1'b0;

   assign raw_frame_valid = (sof_fifo_rd && (hdr_fmt == NONE)) ? 1'b1 : 1'b0;

   assign bhp_status_error = (bhp_lfa_status_valid &&
                              bhp_lfa_status_bus.error != NO_ERRORS) ? 
                             1'b1 : 1'b0;
   assign bhp_htf_status_error = (bhp_lfa_htf_status_valid &&
                                 bhp_lfa_htf_status_bus.error != NO_ERRORS) ? 
                                    1'b1 : 1'b0;
   
   always_comb
     begin
        hdr_align_clear = 1'b0;
        new_stbl_align_bits = '0;
        new_stbl_ptr = '0;
        new_data_align_bits = '0;
        new_data_ptr = '0;
        words_to_send = '0;
        hdr_byte_align = 1'b0;
        data_ptr_valid = 1'b0;
        stbl_data_valid = 1'b0;
        new_stbl_last = 1'b0;
        
        deflate_raw = 1'b0;
        new_data_err = NO_ERRORS;
        new_data_size = '0;
        new_last_blk = 1'b0;
        new_crc_option = 1'b0;
        new_data_fmt = NONE;
        new_data_trace = 1'b0;
        new_stbl_fmt = NONE;
        new_sof_blk = 1'b0;
        
        if (p_hdr_st == RAW_DATA_ST) begin
           new_data_align_bits = '0;
           new_data_ptr = r_start_addr;
           data_ptr_valid = 1'b1;
           new_data_err = r_sof_error;
           new_data_fmt = NONE;
           new_data_trace = r_sof_trace;
 
           
           
        end
        else if (((p_hdr_st == HDR_ST) &&
                 (bhp_lfa_status_valid)) || (bhp_lfa_status_valid && runt_err)) begin
           
           
           hdr_align_clear = 1'b1;
           
           {new_stbl_align_bits, new_stbl_ptr} = get_alignment_n_new_ptr
                                                 (bhp_lfa_status_bus.hdr_size,
                                                  hdr_head_ptr,
                                                  hdr_align,
                                                  hdr_byte_align);
           new_stbl_fmt = cur_hdr_fmt;
           new_stbl_last = bhp_lfa_status_bus.last_blk;
           stbl_data_valid = 1'b1;
           new_sof_blk = r_sof_blk;
           if ((bhp_lfa_status_bus.skip_stbl) ||
               (bhp_status_error) || runt_err) begin
              data_ptr_valid = 1'b1;
              new_data_align_bits = new_stbl_align_bits;
              new_data_ptr = new_stbl_ptr;
              if (runt_err)
                new_data_err = HD_LFA_MISSING_EOF;
              else
                new_data_err = bhp_lfa_status_bus.error;
              new_data_size = bhp_lfa_status_bus.data_size;
              new_last_blk = bhp_lfa_status_bus.last_blk;
              new_crc_option = bhp_lfa_status_bus.crc_option;
              new_data_fmt = cur_hdr_fmt;
              new_data_trace = cur_hdr_trace;
              
              if (deflate_hdr_frm && (new_data_size > 0))
                deflate_raw = 1'b1;
              words_to_send= get_words_to_send(bhp_lfa_status_bus.data_size,
                                               new_data_align_bits);
              stbl_data_valid = 1'b0;
           end
        end
        else if (((p_stbl_st == STBL_WAIT_ST) || (p_stbl_st == STBL_ST)) &&
                 (bhp_lfa_htf_status_valid)) begin

           data_ptr_valid = 1'b1;
           new_data_err = bhp_lfa_htf_status_bus.error;
           new_data_size = bhp_lfa_htf_status_bus.data_size;
           new_sof_blk = stbl_sof_blk;
           
           if (cur_stbl_fmt == XP9)
             new_last_blk = xp9_stbl_last;
           else
             new_last_blk = bhp_lfa_htf_status_bus.last_blk;
           new_crc_option = bhp_lfa_htf_status_bus.crc_option;
           {new_data_align_bits, new_data_ptr} = get_alignment_n_new_ptr
                                                 (bhp_lfa_htf_status_bus.hdr_size,
                                                  data_stbl_head_ptr,
                                                  data_stbl_align,
                                                  hdr_byte_align);
           new_data_fmt = cur_stbl_fmt;
           new_data_trace = cur_stbl_trace;
           if (bhp_htf_status_error) 
              
             
             new_data_ptr = data_stbl_head_ptr;
           
           words_to_send= get_words_to_send(bhp_lfa_htf_status_bus.data_size,
                                                  new_data_align_bits);
        end 
     end 

   always_comb
     begin
        new_crc_align_bits = '0;
        new_crc_ptr = '0;
        new_hdr_align_bits = '0;
        new_hdr_ptr = '0;
        byte_align = 1'b0;
        lfa_rd_ack = 1'b0;
        lfa_rd_ack_addr = '0;
        hdr_valid = 1'b0;
        l_cur_data_ptr = '0;
        
        if (ack_64) l_cur_data_ptr = cur_data_ptr + 1;
           else l_cur_data_ptr = cur_data_ptr;

        if (p_data_st == DATA_IDLE_ST) begin
           if (nxt_data_valid) begin
              lfa_rd_ack_addr = nxt_data_ptr;
              lfa_rd_ack = 1'b1;
           end
        end 
        
        if ((p_hdr_st == HDR_ST) &&
            (bhp_lfa_status_valid) && !deflate_hdr_frm && !chu_hdr_frm) begin
           if (cur_hdr_fmt == XP9)
             byte_align = 1'b1;
           {new_hdr_align_bits, new_hdr_ptr} = get_alignment_n_new_ptr
                                               (bhp_lfa_status_bus.cum_size,
                                                hdr_head_ptr,
                                                hdr_align,
                                                byte_align);
           
           hdr_valid = 1'b1;
        end
        
        if (p_data_st == DATA_ST) begin
           if (got_eob && !deflate_data_frm) begin
              if ((cur_data_fmt == XP9) ||
                  (r_last_blk))
                byte_align = 1'b1;
              if (r_last_blk) begin
                 {new_crc_align_bits, new_crc_ptr} = get_alignment_n_new_ptr
                                                     (sdd_fifo_wbus.numbits,
                                                      cur_data_ptr,
                                                      data_align,
                                                      byte_align);
                 if (sdd_fifo_wbus.error == NO_ERRORS)
                   lfa_rd_ack_addr = new_crc_ptr;
                 else
                   lfa_rd_ack_addr = eof_addr;
                 
                 lfa_rd_ack = 1'b1;
              end 
           end 
           else if (!deflate_data_frm) begin
              lfa_rd_ack = sdd_fifo_wr;
              lfa_rd_ack_addr = cur_data_ptr;
           end
           else if (deflate_data_frm && ack_64) begin
              lfa_rd_ack_addr = cur_data_ptr;
              lfa_rd_ack = 1'b1;
           end
        end 
        else if (p_data_st == DFLATE_EOB_ST) begin
           {new_hdr_align_bits, new_hdr_ptr} = get_alignment_n_new_ptr
                                               (ack_bits,
                                                l_cur_data_ptr,
                                                data_align,
                                                byte_align);
           if (invalid_hdr_addr) begin
              hdr_valid = 1'b0;
              lfa_rd_ack_addr = new_hdr_ptr -1;
           end
           else begin
              hdr_valid = 1'b1;
              lfa_rd_ack_addr = new_hdr_ptr;
           end
           lfa_rd_ack = 1'b1;
        end
        else if (p_data_st == DFLATE_EOF_ST) begin
           byte_align = 1'b1;
              {new_crc_align_bits, new_crc_ptr} = get_alignment_n_new_ptr
                                                  (ack_bits,
                                                  l_cur_data_ptr,
                                                   data_align,
                                                   byte_align);
           hdr_valid = 1'b0;
           if (late_eof_frm)
             lfa_rd_ack = 1'b0;
           else
             lfa_rd_ack = 1'b1;

           if (sdd_fifo_wbus.error == NO_ERRORS)
             lfa_rd_ack_addr = new_crc_ptr;
           else
             lfa_rd_ack_addr = eof_addr;

        end
        else if (p_data_st == ERR_WAIT_ST) begin 
           if (abort_premature_frm) 
             lfa_rd_ack_addr = data_tail_ptr -1 ;
           else
             lfa_rd_ack_addr = data_tail_ptr;
           lfa_rd_ack = 1'b1;
        end
        else if (p_data_st == DFLATE_EOF_WAIT_ST) begin
           lfa_rd_ack_addr = data_tail_ptr;
           lfa_rd_ack = 1'b1;
        end
     end 

   function logic [25:0] get_words_to_send;
      input [31:0] data_size;
      input [5:0]  align_bits;
      logic [5:0]  mod_bits;
      logic        mod_val;
      logic        mod_size;
      logic [5:0]  n_align_bits;
      logic [27:0] int_data_size;
      
      begin
         if (data_size > 31'h0fff_ffff)
           int_data_size = 31'h0fff_ffff; 
         else
           int_data_size = data_size[27:0];
         
         mod_bits = int_data_size % `AXI_S_DP_DWIDTH; 
         n_align_bits = `AXI_S_DP_DWIDTH - align_bits;
         
         if (mod_bits > 0)
           mod_size = 1'b1;
         else
           mod_size = 1'b0;
         
         if ((n_align_bits != 0) && 
             ((mod_bits > n_align_bits) || (mod_bits == 0)))
           mod_val = 1'b1;
         else
           mod_val = 1'b0;
         if (int_data_size == 0)
           get_words_to_send = '0;
         else
           get_words_to_send = int_data_size/`AXI_S_DP_DWIDTH + mod_val + mod_size; 

      end
   endfunction 


   
   
   assign xp10_hdr_eof = (r_last_blk && !eof_fifo_empty && xp10_frm);
   assign xp9_hdr_eof = ((set_xp9_last_blk || xp9_last_blk) && 
                         !eof_fifo_empty && xp9_frm);
   
   assign hdr_eof = (p_data_st == DATA_ST )  && (xp10_hdr_eof || xp9_hdr_eof || chu_frm);
   
   assign data_eof_cnt = (!eof_fifo_empty && lfa_data_rd_valid && !one_after_last_rd && data_cnt_eof_valid &&
                          ((10'(lfa_raddr + data_cnt) == 10'(eof_fifo_rdata.eof_addr)) ||
                           (10'(lfa_raddr + data_cnt) == 10'(eof_fifo_rdata.eof_addr-1)) ||
                           (10'(lfa_raddr + data_cnt) == 10'(eof_fifo_rdata.eof_addr+1)))) ? 1'b1 : 1'b0; 
   
   assign eof_addr = (cur_eof_valid) ? cur_eof_addr : eof_fifo_rdata.eof_addr;
   assign eof_frm_bytes = (cur_eof_valid) ? cur_frm_bytes : eof_fifo_rdata.frm_bytes;
   assign eof_last = (cur_eof_valid) ? cur_last : eof_fifo_rdata.last;

   assign xp_frm_last_blk =  (hdr_eof && !eof_rd && data_eof_cnt);
   assign set_xp9_last_blk = ((p_hdr_st == HDR_ST) && xp9_hdr_frm && at_eof &&
                              (p_stbl_st == STBL_IDLE_ST) && 
                              (!nxt_data_valid || (start_data && nxt_data_valid)));
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         cur_data_fmt <= NONE;
         nxt_data_fmt <= NONE;
         nxt_nxt_data_fmt <= NONE;
         cur_stbl_fmt <= NONE;
         r_sof_error <= NO_ERRORS;
         cur_eof_err <= NO_ERRORS;
         nxt_data_err <= NO_ERRORS;
         nxt_nxt_data_err <= NO_ERRORS;
         
         
         abort_stbl <= 0;
         ack_64 <= 0;
         ack_bits <= 0;
         crc_align <= 0;
         crc_present <= 0;
         crc_tail_ptr <= 0;
         cur_data_ptr <= 0;
         cur_data_trace <= 0;
         cur_deflate_raw <= 0;
         cur_sdd_blk <= 0;
         cur_stbl_trace <= 0;
         data_align <= 0;
         data_stbl_align <= 0;
         data_stbl_head_ptr <= 0;
         data_tail_ptr <= 0;
         eof_ack <= 0;
         eof_ack_valid <= 0;
         f_cum_size <= 0;
         f_cum_valid <= 0;
         hdr_align <= 0;
         hdr_hdr_tail_ptr <= 0;
         hdr_head_ptr <= 0;
         hdr_tail_ptr <= 0;
         last_rd <= 0;
         lfa_bhp_align_bits <= 0;
         nxt_crc_option <= 0;
         nxt_data_align <= 0;
         nxt_data_bits <= 0;
         nxt_data_ptr <= 0;
         nxt_data_trace <= 0;
         nxt_data_valid <= 0;
         nxt_deflate_raw <= 0;
         nxt_hdr_valid <= 0;
         nxt_last_blk <= 0;
         nxt_nxt_crc_option <= 0;
         nxt_nxt_data_align <= 0;
         nxt_nxt_data_bits <= 0;
         nxt_nxt_data_ptr <= 0;
         nxt_nxt_data_trace <= 0;
         nxt_nxt_data_valid <= 0;
         nxt_nxt_deflate_raw <= 0;
         nxt_nxt_last_blk <= 0;
         nxt_nxt_sof_blk <= 0;
         nxt_nxt_words_to_send <= 0;
         nxt_sof_blk <= 0;
         nxt_stbl_valid <= 0;
         nxt_words_to_send <= 0;
         one_after_last_rd <= 0;
         r_hdr_align_clear <= 0;
         r_lfa_sdd_dp_bus <= 0;
         r_rewind_ack_err <= 0;
         r_sdd_ack_err <= 0;
         r_sof_trace <= 0;
         r_start_addr <= 0;
         s_cum_size <= 0;
         s_cum_valid <= 0;
         stbl_align <= 0;
         stbl_hdr_head_ptr <= 0;
         stbl_head_ptr <= 0;
         stbl_last_blk <= 0;
         stbl_sof_blk <= 0;
         stbl_tail_ptr <= 0;
         xp9_stbl_last <= 0;
         
      end
      else begin
         r_hdr_align_clear <= hdr_align_clear || bhp_lfa_stbl_sent;
         r_lfa_sdd_dp_bus <= lfa_sdd_dp_bus;
         r_start_addr <= start_addr;
         r_sof_error <= sof_fifo_rdata.sof_data.error;
         r_sof_trace <= sof_fifo_rdata.sof_data.trace_bit;
         if (sdd_lfa_ack_valid && sdd_lfa_ack_bus.err)
           r_sdd_ack_err <= 1'b1;
         else if ((p_data_st == ERR_ST) || (p_data_st == DATA_IDLE_ST))
           r_sdd_ack_err <= 1'b0;
         
         if (bhp_lfa_stbl_sent) begin
            data_stbl_head_ptr <= stbl_head_ptr;
            data_stbl_align <= stbl_align;
            cur_stbl_fmt <= cur_hdr_fmt;
            cur_stbl_trace <= cur_hdr_trace;
         end

         if (bhp_lfa_stbl_sent)
           stbl_sof_blk <= r_sof_blk;
         else if (bhp_lfa_htf_status_valid)
           stbl_sof_blk <= 1'b0;
         
         if (hdr_valid) begin
            if (bhp_status_error ||
                (bhp_htf_status_error && !r_sof_blk))
              nxt_hdr_valid <= 1'b0;
            else
              nxt_hdr_valid <= 1'b1;
         end
         else if (((p_hdr_st == HDR_ST)  || abort_stbl || 
                   (bhp_htf_status_error && !r_sof_blk && !(nxt_nxt_data_valid && nxt_nxt_sof_blk)) ||
                   (((abort_frm_early && !r_sof_blk && !f_cum_valid) ||
                     (abort_premature_frm && !r_sof_blk && !s_cum_valid)) &&
                    !(r_last_blk || xp9_last_blk || chu_frm)) ||
              ((p_hdr_st == HDR_IDLE_ST) && set_eof && set_missing_eof_err && !r_sof_blk && !f_cum_valid)))
           nxt_hdr_valid <= 1'b0;
         
         eof_ack <= (xp_frm_last_blk && !cur_eof_valid) ||
                    ((p_data_st == ERR_WAIT_ST) && 
                     xp_frm && err_eof && !eof_fifo_empty && !eof_rd) ||
                    ((raw_frm || deflate_data_frm) && sdd_fifo_wbus.eof) ||
                    ((xp_frm || chu_frm) && set_sob_eob_eof);
                  
         if (lfa_sdd_dp_bus.eof && lfa_sdd_dp_valid)
           eof_ack_valid <= 1'b0;
         else if (eof_ack)
           eof_ack_valid <= 1'b1;
         
         if (xp_frm || chu_frm || (deflate_data_frm && cur_deflate_raw)) begin
            if (sdd_fifo_wr && (sdd_fifo_wbus.eof ||
                                sdd_fifo_wbus.eob)) begin
               one_after_last_rd <= 1'b0;
               last_rd <= 1'b0;
            end
            else begin
               if (lfa_data_rd_valid &&  (data_cnt == 0) && 
                   !raw_frm && !one_after_last_rd)
                 last_rd <= 1'b1;
               if (last_rd && lfa_data_rd_valid &&  
                   (data_cnt == 0) && !raw_frm) begin
                  one_after_last_rd <= 1'b1;
                  last_rd <= 1'b0;
               end
            end
         end 
         
         if (xp_frm || chu_frm || cur_deflate_raw) begin
            if (sdd_fifo_wbus.eof && sdd_fifo_wr)
              cur_eof_err <= NO_ERRORS;
            else begin
               if ((p_data_st == DATA_ST) && 
                   (((data_cnt == 0) && lfa_data_rd_valid && in_last_blk && last_rd) || last_eof_rd || late_eof_frm)) begin
                  
                  
                  if ((lfa_data_rd_valid && (data_cnt == 0) && (xp_frm || cur_deflate_raw || chu_frm) && last_rd) ||
                      late_eof_frm) begin
                     if (!eof_fifo_empty || cur_eof_valid) begin
                        if (((lfa_raddr == eof_addr) || (lfa_raddr == 10'(eof_addr-1))) && !late_eof_frm)
                          cur_eof_err <= NO_ERRORS;
                        else
                          cur_eof_err <= HD_LFA_LATE_EOF;
                     end
                     else if (late_eof_frm) begin
                        cur_eof_err <= HD_LFA_LATE_EOF;
                     end
                  end 
                  
                  if (((data_cnt > 0) && last_eof_rd ) ||
                      (last_eof_rd && !last_rd && !cur_deflate_raw && 
                       !(set_xp9_last_blk || xp9_last_blk || r_last_blk || chu_frm) && (data_cnt ==0)))
                    cur_eof_err <= HD_LFA_PREMATURE_EOF; 
                  
               end 
            end 
         end 
         else begin
            cur_eof_err <= NO_ERRORS;
         end

         lfa_bhp_align_bits <= hdr_stbl_align;

         if ((p_data_st == ERR_ST) && !data_ptr_valid) begin
            if (!nxt_sof_blk)
              nxt_data_valid <= 1'b0;
         end
         else if (data_ptr_valid) begin
            if (((p_stbl_st == STBL_WAIT_ST) && bhp_lfa_status_valid &&
                 ((bhp_lfa_status_bus.skip_stbl) || (bhp_lfa_status_bus.error != NO_ERRORS) || runt_err))
                 || (nxt_data_valid && !start_data) || 
                (p_hdr_st == RAW_DATA_ST)) begin
               nxt_nxt_sof_blk <= new_sof_blk;
               nxt_nxt_data_ptr <= new_data_ptr;
               nxt_nxt_data_align <= new_data_align_bits;
               nxt_nxt_words_to_send <= words_to_send;
               nxt_nxt_deflate_raw <= deflate_raw;
               nxt_nxt_data_bits <= new_data_size;
               nxt_nxt_data_err <= new_data_err;
               nxt_nxt_last_blk <= new_last_blk;
               nxt_nxt_crc_option <= new_crc_option;
               nxt_nxt_data_fmt <= new_data_fmt;
               nxt_nxt_data_trace <= new_data_trace;
               nxt_nxt_data_valid <= 1'b1;
            end 
            else begin
               nxt_sof_blk <= new_sof_blk;
               nxt_data_ptr <= new_data_ptr;
               nxt_data_align <= new_data_align_bits;
               nxt_words_to_send <= words_to_send;
               nxt_deflate_raw <= deflate_raw;
               nxt_data_bits <= new_data_size;
               nxt_data_err <= new_data_err;
               nxt_last_blk <= new_last_blk;
               nxt_crc_option <= new_crc_option;
               nxt_data_fmt <= new_data_fmt;
               nxt_data_trace <= new_data_trace;
               nxt_data_valid <= 1'b1;
            end 
         end 
         else if ((p_data_st == DATA_IDLE_ST) || 
                  ((p_data_st == DATA_ST) && (cur_data_fmt == NONE))) begin
            if (nxt_nxt_data_valid && (p_stbl_st == STBL_IDLE_ST)) begin
               nxt_sof_blk <= nxt_nxt_sof_blk;
               nxt_data_ptr <= nxt_nxt_data_ptr;
               nxt_data_align <= nxt_nxt_data_align;
               nxt_words_to_send <= nxt_nxt_words_to_send;
               nxt_deflate_raw <= nxt_nxt_deflate_raw;
               nxt_data_bits <= nxt_nxt_data_bits;
               nxt_data_err <= nxt_nxt_data_err;
               nxt_last_blk <= nxt_nxt_last_blk;
               nxt_crc_option <= nxt_nxt_crc_option;
               nxt_data_fmt <= nxt_nxt_data_fmt;
               nxt_data_trace <= nxt_nxt_data_trace;
               nxt_nxt_data_valid <= 1'b0;
               nxt_data_valid <= 1'b1;
            end 
            else
              nxt_data_valid <= 1'b0;
         end 
         else if ((p_data_st == DFLATE_EOB_ST) ||  (p_data_st == DFLATE_EOF_ST)) begin
            nxt_deflate_raw <= 1'b0;
         end
         
         if (stbl_data_valid)
           nxt_stbl_valid <= 1'b1;
         else if ((p_stbl_st == STBL_IDLE_ST) || (bhp_htf_status_error && !r_sof_blk))
           nxt_stbl_valid <= 1'b0;

         if ((nxt_stbl_valid || ((p_hdr_st == HDR_ST) && !r_start_hdr)) && bhp_htf_status_error && !r_sof_blk)
           abort_stbl <= 1'b1;
         else if ((p_hdr_st == HDR_IDLE_ST) && (p_data_st == DATA_IDLE_ST))
           abort_stbl <= 1'b0;
         
         if (start_data) begin
            data_align <= nxt_data_align;
            cur_data_fmt <= nxt_data_fmt;
            cur_data_trace <= nxt_data_trace;
            cur_deflate_raw <= nxt_deflate_raw;
            if ((nxt_data_fmt == XP10) || nxt_deflate_data_frm)
              crc_present <= 1'b1;
            else
              crc_present <= 1'b0;
         end 
         else if (p_data_st == DATA_IDLE_ST)
           cur_data_fmt <= NONE;
         
         if (start_data)
           data_tail_ptr <= nxt_data_ptr;
         else if (sdd_lfa_ack_valid && sdd_lfa_ack_bus.err && deflate_data_frm)
           data_tail_ptr <= cur_data_ptr+1;
         else if (sdd_lfa_ack_valid && sdd_lfa_ack_bus.eob && r_last_blk && !(sent_eof_eob && ack_addr_ok))
           data_tail_ptr <= cur_data_ptr;
         else if (invalid_hdr_addr && deflate_data_frm)
           data_tail_ptr <= cur_data_ptr;
         else if (lfa_data_rd_valid)
           data_tail_ptr <= data_tail_ptr + 1;

         if (start_hdr) begin
            if (!f_cum_valid)
              cur_sdd_blk <= 1'b1;
            else
              cur_sdd_blk <= 1'b0;
         end
         
         
         if (sof_fifo_rd) begin
            hdr_head_ptr <= sof_fifo_rdata.addr;
            hdr_tail_ptr <= sof_fifo_rdata.addr;
            hdr_hdr_tail_ptr <= sof_fifo_rdata.addr;
            hdr_align <= '0;
         end
         else if ((p_hdr_st == HDR_ST) || 
                  (p_data_st == DFLATE_EOB_ST)) begin
            if (hdr_valid) begin
               hdr_head_ptr <= new_hdr_ptr;
               hdr_tail_ptr <= new_hdr_ptr;
               hdr_align <= new_hdr_align_bits;
               hdr_hdr_tail_ptr <= hdr_head_ptr;
               
            end
            else if (lfa_hdr_rd && lfa_rd_avail) begin
               hdr_tail_ptr <= hdr_tail_ptr + 1;
            end
         end 
         
         if (p_data_st == ERR_DUMMY_ST) begin
            f_cum_size <= 1'b0;
            f_cum_valid <= 1'b0;
            s_cum_size <= 1'b0;
            s_cum_valid <= 1'b0;
         end
         else if (hdr_valid || (chu_hdr_frm && bhp_lfa_status_valid)) begin
            if (start_data) begin
               if (abort_stbl || ((nxt_data_err != NO_ERRORS) && !r_sof_blk)) begin
                  if ((nxt_nxt_data_valid && nxt_nxt_sof_blk)
                      || (s_cum_valid && (r_sof_blk || stbl_sof_blk))) begin
                     f_cum_size <= s_cum_size;
                     f_cum_valid <= 1'b1;
                     s_cum_size <= '0;
                     s_cum_valid <= 1'b0;
                  end
                  else begin
                     f_cum_size <= '0;
                     f_cum_valid <= 1'b0;
                     s_cum_size <= '0;
                     s_cum_valid <= 1'b0;
                  end
               end 
               else if (!s_cum_valid) begin
                  f_cum_size <= bhp_lfa_status_bus.cum_size/64;
                  f_cum_valid <= 1'b1;
               end
               else begin
                  f_cum_size <= s_cum_size;
                  s_cum_size <= bhp_lfa_status_bus.cum_size/64;
               end
            end
            else begin
               if (f_cum_valid) begin
                  s_cum_size <= bhp_lfa_status_bus.cum_size/64;
                  s_cum_valid <= 1'b1;
               end
               else begin
                  f_cum_size <= bhp_lfa_status_bus.cum_size/64;
                  f_cum_valid <= 1'b1;
               end
            end
         end
         
         else if (start_data) begin
            if (f_cum_valid) begin
               if (abort_stbl || ((nxt_data_err != NO_ERRORS))) begin
                  if ((nxt_nxt_data_valid && nxt_nxt_sof_blk) ||
                      (s_cum_valid && (r_sof_blk || stbl_sof_blk))) begin
                     f_cum_size <= s_cum_size;
                     f_cum_valid <= 1'b1;
                     s_cum_size <= '0;
                     s_cum_valid <= 1'b0;
                  end
                  else begin
                     f_cum_size <= '0;
                     f_cum_valid <= 1'b0;
                     s_cum_size <= '0;
                  end
               end 
               else if (!s_cum_valid)
                 f_cum_valid <= 1'b0;
               else begin
                  f_cum_size <= s_cum_size;
                  s_cum_size <= '0;
                  s_cum_valid <= 1'b0;
                  f_cum_valid <= 1'b1;
               end
            end 
         end 
         

         if (sof_fifo_rd)
           stbl_last_blk <= 1'b0;
         else if ((bhp_lfa_status_valid && bhp_lfa_status_bus.skip_stbl) ||
             stbl_data_valid)
           stbl_last_blk <= new_stbl_last;

         if (start_data && (nxt_data_fmt == XP9))
           xp9_stbl_last <= 1'b0;
         else if (xp9_hdr_frm && at_eof && (p_hdr_st == HDR_ST) && 
                  ((p_stbl_st == STBL_WAIT_ST) || 
                   ((p_stbl_st == STBL_IDLE_ST) && nxt_data_valid)))
           xp9_stbl_last <= 1'b1;

         if (stbl_data_valid) begin
            if (bhp_lfa_status_bus.error == NO_ERRORS) begin
               stbl_head_ptr <= new_stbl_ptr;
               stbl_tail_ptr <= new_stbl_ptr;
               stbl_align <= new_stbl_align_bits;
               if (deflate_hdr_frm && !r_sof_blk)
                 stbl_hdr_head_ptr <= l_cur_data_ptr;
               else
                 stbl_hdr_head_ptr <= hdr_head_ptr;
            end 
         end
         else if (lfa_hdr_rd && lfa_rd_avail && (p_hdr_st == HDR_STBL_ST)) begin
            stbl_tail_ptr <= stbl_tail_ptr + 1;
         end
         
         
         if (start_data) begin
            cur_data_ptr <= nxt_data_ptr;
         end

  
         else if ((sdd_fifo_wr && !deflate_data_frm) ||
                  (deflate_data_frm && ack_64 && !rewind_ack_err))
           cur_data_ptr <= cur_data_ptr + 1;

         if (start_data)
           r_rewind_ack_err <= 1'b0;
         else if (deflate_data_frm && ack_64 && rewind_ack_err)
           r_rewind_ack_err <= 1'b1;
         
         if (p_data_st == DATA_ST) begin
            if (got_eob) begin
               if(r_last_blk) begin
                  crc_tail_ptr <= new_crc_ptr;
                  crc_align <= new_crc_align_bits;
               end
            end
         end
         else if (p_data_st == DFLATE_EOF_ST) begin
            crc_tail_ptr <= new_crc_ptr;
            crc_align <= new_crc_align_bits;
         end
         else if (lfa_crc_rd && lfa_rd_avail)
           crc_tail_ptr <= crc_tail_ptr + 1;

         if ((p_data_st == DFLATE_EOB_ST) ||
             (p_data_st == DFLATE_EOF_ST) ||
             (p_data_st == ERR_ST) ||
             (deflate_data_frm && sdd_fifo_wbus.eof && sdd_fifo_wr && 
              (sdd_fifo_wbus.error != NO_ERRORS))) begin
            ack_bits <= '0;
            ack_64 <= 1'b0;
         end
         else if (cur_deflate_raw && deflate_data_frm && sdd_fifo_wr) begin
            if (sdd_fifo_wbus.numbits == 7'd64) begin
               ack_bits <= '0;
               ack_64 <= 1'b1;
            end
            else begin
               ack_bits <= {1'b0, sdd_fifo_wbus.numbits};
               ack_64 <= 1'b0;
            end
         end
         else if (sdd_lfa_ack_valid) begin
            if (prev_cur_bits > 7'd64) begin
               ack_bits <= prev_cur_bits - 7'd64; 
               ack_64 <= 1'b1;
            end
            else begin
               ack_bits <= prev_cur_bits;
               ack_64 <= 1'b0;
            end
                     end

         else
           ack_64 <= 1'b0;
         
      end 
   end 

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         crc_eof_addr <= 0;
         cur_eof_addr <= 0;
         cur_eof_valid <= 0;
         cur_frm_bytes <= 0;
         cur_last <= 0;
         nxt_eof_addr <= 0;
         nxt_eof_valid <= 0;
         nxt_frm_bytes <= 0;
         nxt_frm_last <= 0;
         
      end
      else begin
         if ((sdd_fifo_wr && sdd_fifo_wbus.eof) || (eof_rd && p_data_st != ERR_ST)) begin
            if (nxt_eof_valid) begin
               cur_eof_addr <= nxt_eof_addr;
               cur_frm_bytes <= nxt_frm_bytes;
               cur_last <= nxt_frm_last;
               cur_eof_valid <= 1'b1;
            end
            else if (eof_rd && !r_set_sob_eob_eof && (cur_data_fmt != NONE) 
                && (!deflate_data_frm) &&
                ((!(sdd_fifo_wr && sdd_fifo_wbus.eof) && !cur_eof_valid))) begin
               
               cur_eof_addr <= eof_fifo_rdata.eof_addr;
               cur_eof_valid <= 1'b1;
               cur_frm_bytes <= eof_fifo_rdata.frm_bytes;
               cur_last <= eof_fifo_rdata.last;
               cur_eof_valid <= 1'b1;
            end
            else if (sdd_fifo_wr && sdd_fifo_wbus.eof)
              cur_eof_valid <= 1'b0;
            
            if (cur_eof_valid) begin
               if (eof_rd && (cur_data_fmt != NONE) && 
                   (!deflate_data_frm) && 
                   !(sdd_fifo_wr && sdd_fifo_wbus.eof))  begin
                  nxt_eof_addr <= eof_fifo_rdata.eof_addr;
                  nxt_eof_valid <= 1'b1;
                  nxt_frm_bytes <= eof_fifo_rdata.frm_bytes;
                  nxt_frm_last <= eof_fifo_rdata.last;
                  nxt_eof_valid <= 1'b1;
               end
               else begin
                  nxt_eof_valid <= 1'b0;
               end
            end
         end 

         if (sdd_fifo_wr && sdd_fifo_wbus.eof)
           crc_eof_addr <= eof_addr;
         
      end 
   end 
   
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         data_size <= 0;
         r_crc_option <= 0;
         r_last_blk <= 0;
         r_sof_blk <= 0;
         wait_for_eob <= 0;
         wait_for_eof <= 0;
         xp10_crc_mode <= 0;
         xp9_last_blk <= 0;
         
      end
      else begin
         
         if (got_eob)
           wait_for_eob <= 1'b0;
         else if (start_data)
           wait_for_eob <= 1'b1;

         if (sof_fifo_rd)
           wait_for_eof <= 1'b1;
         else if (set_eof)
           wait_for_eof <= 1'b0;

         if (sof_fifo_rd)
           xp10_crc_mode <= 1'b0;
         else if ((cur_hdr_fmt == XP10) && bhp_lfa_status_valid)
           xp10_crc_mode <= bhp_lfa_status_bus.crc_option;

         if (set_xp9_last_blk)
           xp9_last_blk <= 1'b1;
         else if (start_data) begin
            if (nxt_data_fmt == XP9)
              xp9_last_blk <= nxt_last_blk || xp9_stbl_last;
            else
              xp9_last_blk <= 1'b0;
         end
                  
         
         if ((p_data_st == DATA_IDLE_ST) && nxt_data_valid) begin
            r_last_blk <= nxt_last_blk;
            data_size <= nxt_data_bits;
            r_crc_option <= nxt_crc_option;
         end
         else if ((p_data_st == DATA_ST) && sdd_fifo_wr) begin
            if (data_size > `AXI_S_DP_DWIDTH)
              data_size <= data_size - `AXI_S_DP_DWIDTH; 
            else
              data_size <= '0;
         end

         if (sof_fifo_rd)
           r_sof_blk <= 1'b1;
         else if ((bhp_lfa_status_valid && 
                   (bhp_lfa_status_bus.skip_stbl ||
                    bhp_lfa_status_bus.error != NO_ERRORS)) || 
                  bhp_lfa_stbl_sent)
           r_sof_blk <= 1'b0;
         
      end 
   end 

   assign crc_addr_in_range = ((crc_tail_ptr == crc_eof_addr) ||
                               (crc_tail_ptr == (10'(crc_eof_addr -1)))) ? 1'b1 : 1'b0;
   
   
   
   always_comb
     begin
        if ((p_data_st == ERR_WAIT_ST) || (p_data_st == DFLATE_EOF_WAIT_ST)) begin
           lfa_data_rd = 1'b1;
           lfa_hdr_rd = 1'b0;
           lfa_crc_rd = 1'b0;
        end
        else if ((p_data_st  == DATA_ST)  && !align_data_full &&
                 wait_for_eob && !sent_eob && 
                 ((!one_after_last_rd && !in_last_blk) ||
                  (!r_last_eof_rd && in_last_blk))) begin
           if (deflate_data_frm && r_last_eof_rd) begin
              lfa_data_rd = 1'b0;
              lfa_hdr_rd = 1'b0;
              lfa_crc_rd = 1'b0;
           end
           else begin
              lfa_data_rd = 1'b1;
              lfa_hdr_rd = 1'b0;
              lfa_crc_rd = 1'b0;
           end
        end
        else if ((p_data_st == CRC_ST)  && crc_present && crc_addr_in_range) begin
           lfa_crc_rd = 1'b1;
           lfa_data_rd = 1'b0;
           lfa_hdr_rd = 1'b0;
        end
        else if (((p_hdr_st == HDR_ST) || (p_hdr_st == HDR_STBL_ST)) &&
                 !bhp_lfa_status_valid &&
                 bhp_lfa_dp_ready && !align_hdr_full && !last_hdr_eof_rd
                 && !first_sof_rd) begin
           lfa_hdr_rd = 1'b1;
           lfa_data_rd = 1'b0;
           lfa_crc_rd = 1'b0;
        end
        else begin
           lfa_hdr_rd = 1'b0;
           lfa_data_rd = 1'b0;
           lfa_crc_rd = 1'b0;
        end

        if (lfa_hdr_rd) begin
           if (p_hdr_st == HDR_ST)
             lfa_raddr = hdr_tail_ptr;
           else
             lfa_raddr = stbl_tail_ptr;
        end
        else if (lfa_data_rd)
          lfa_raddr = data_tail_ptr;
        else if (lfa_crc_rd)
          lfa_raddr = crc_tail_ptr;
        else
         lfa_raddr = hdr_tail_ptr;
        
        lfa_rd = lfa_hdr_rd || lfa_data_rd || lfa_crc_rd;
        
     end

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         crc_cnt <= 0;
         crc_data <= 0;
         crc_data_valid <= 0;
         crc_frm_fmt <= 0;
         first_crc_word <= 0;
         
      end
      else begin
         if (p_data_st == CRC_ST)  begin
            crc_cnt <= crc_cnt + 1;
            if (crc_present) begin
               if (rr_lfa_crc_rd) begin
                  if (crc_cnt == 2)
                    first_crc_word <= lfa_rdata.data;
               end
            end
         end

         if (p_data_st == ERR_ST) begin
            crc_data_valid <= 1'b1;
            crc_frm_fmt <= '0;
            crc_cnt <= '0;
            crc_data <= '0;
         end
         else if (crc_cnt == 2'd3) begin
            crc_data_valid <= 1'b1;
            crc_frm_fmt <= get_crc_frm_fmt(cur_data_fmt, r_crc_option);
            crc_cnt <= 2'b0;
            if (crc_present) begin
               crc_data <= align_data(lfa_rdata.data,
                                      first_crc_word,
                                      crc_align);
            end
            else begin
               crc_data <= '0;
            end 
         end
         else begin
            crc_data_valid <= 1'b0;
            crc_data <= '0;
         end
      end
   end

   always_comb
     begin
        last_eof_rd = 1'b0;
        pre_last_eof_rd = 1'b0;
        if ((!eof_fifo_empty || cur_eof_valid) && lfa_data_rd_valid) begin
           if (lfa_raddr == eof_addr)
             last_eof_rd = 1'b1;
           else if (lfa_raddr == 10'(eof_addr -1))
             pre_last_eof_rd = 1'b1;
        end
     end
   
   
   
   assign dflate_late_eof = (p_data_st == DFLATE_EOF_WAIT_ST) ?
                            (!eof_fifo_empty && 
                             (eof_fifo_rdata.eof_addr != data_tail_ptr) ||
                             (eof_fifo_rdata.eof_addr != (data_tail_ptr+1))) : 1'b0;
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         err_sdd_bus.error <= NO_ERRORS;
         
         
         err_sdd_bus.data <= 0;
         
      end
      else begin
         if (sdd_fifo_wr && sdd_fifo_wbus.eof) begin
            err_sdd_bus.data <= '0;
            err_sdd_bus.error <= NO_ERRORS;
         end
         else if ((p_data_st == DATA_IDLE_ST) && nxt_data_valid && 
             (nxt_data_err != NO_ERRORS)) begin
            err_sdd_bus.data <= '0;
            err_sdd_bus.error <= nxt_data_err;
         end
         else if (bhp_lfa_status_valid) begin
            if (bhp_lfa_status_bus.error != NO_ERRORS) begin
               err_sdd_bus.data <= '0;
               err_sdd_bus.error <= bhp_lfa_status_bus.error;
            end
         end
         else if (bhp_lfa_htf_status_valid) begin
            if (bhp_lfa_htf_status_bus.error != NO_ERRORS) begin
               err_sdd_bus.data <= '0;
               err_sdd_bus.error <= bhp_lfa_htf_status_bus.error;
            end
         end
         else if (abort_premature_frm || (deflate_hdr_frm && invalid_hdr_addr))
           err_sdd_bus.error <= HD_LFA_PREMATURE_EOF;
         else if (dflate_late_eof)
           err_sdd_bus.error <= HD_LFA_LATE_EOF;
      end 
   end 
   
   assign xp9_first_word = rr_lfa_hdr_rd && r_start_hdr &&  (cur_hdr_fmt == XP9);
   assign xp10_first_word = rr_lfa_hdr_rd && first_word_rd && (cur_hdr_fmt == XP10);
   assign pre_runt_err = ((nxt_data_valid && !nxt_sof_blk && nxt_data_err == HD_LFA_MISSING_EOF) ||
                          (data_ptr_valid && !f_cum_valid && !nxt_data_valid && !new_sof_blk && (new_data_err == HD_LFA_MISSING_EOF)) ||
                          ((runt_err || xp10_runt_blk)
                           && !f_cum_valid && !s_cum_valid && !r_sof_blk));
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         abort_frm_early <= 0;
         crc_size <= 0;
         cur_isize <= 0;
         data_cnt <= 0;
         eob_word_rd <= 0;
         f_isize <= 0;
         f_valid <= 0;
         first_sof_rd <= 0;
         large_data_frm <= 0;
         last_hdr_eof_rd <= 0;
         late_eof_frm <= 0;
         n_valid <= 0;
         next_isize <= 0;
         r_deflate_start_hdr <= 0;
         r_eof_hdr_wrd <= 0;
         r_got_eob <= 0;
         r_isize <= 0;
         r_last_eof_rd <= 0;
         r_lfa_crc_rd <= 0;
         r_lfa_data_rd <= 0;
         r_lfa_hdr_rd <= 0;
         r_lfa_rd <= 0;
         r_lfa_sdd_sent_eof <= 0;
         r_set_sob_eob_eof <= 0;
         r_start_data <= 0;
         r_start_hdr <= 0;
         rr_eof_hdr_wrd <= 0;
         rr_lfa_crc_rd <= 0;
         rr_lfa_data_rd <= 0;
         rr_lfa_hdr_rd <= 0;
         rr_lfa_rd <= 0;
         sdd_fifo_clear <= 0;
         sent_eob <= 0;
         sent_eof_eob <= 0;
         sent_last_eob <= 0;
         set_sob <= 0;
         set_sob_eob <= 0;
         set_sob_eob_eof <= 0;
         start_stbl <= 0;
         wait_for_sdd_ack <= 0;
         
       end
       else begin
          r_lfa_hdr_rd <= lfa_hdr_rd && lfa_rd_avail && !bhp_lfa_stbl_sent &&
                          !bhp_lfa_status_valid;
          r_lfa_data_rd <= lfa_data_rd_valid && ((p_data_st != ERR_WAIT_ST) &&
                                                 (p_data_st != DFLATE_EOF_WAIT_ST));
          r_lfa_crc_rd <= lfa_crc_rd && lfa_rd_avail;

          rr_lfa_hdr_rd <= r_lfa_hdr_rd;
          rr_lfa_data_rd <= r_lfa_data_rd;
          rr_lfa_crc_rd <= r_lfa_crc_rd;

          r_lfa_rd <= lfa_rd;
          rr_lfa_rd <= r_lfa_rd;

          if (!sof_fifo_empty && lfa_hdr_rd && lfa_rd_avail &&
              (10'(lfa_raddr+1) == sof_fifo_rdata.addr))
            first_sof_rd <= 1'b1;
          else if ((p_hdr_st != HDR_ST) || (p_hdr_st != HDR_STBL_ST))
            first_sof_rd <= 1'b0;

          if ((p_hdr_st == HDR_WAIT_ST) && (p_stbl_st != STBL_WAIT_ST))
            start_stbl <= 1'b1;
          else if (lfa_hdr_rd && lfa_rd_avail)
            start_stbl <= 1'b0;

          if (last_eof_rd)
            r_last_eof_rd <= 1'b1;
          else if (p_data_st == DATA_IDLE_ST)
            r_last_eof_rd <= 1'b0;

          if ((xp_frm || chu_frm || cur_deflate_raw) && !runt_blk_valid &&
              !pre_runt_err && 
              ((last_eof_rd && (data_cnt > 0)) ||
               (last_eof_rd && (data_cnt == 0) && !last_rd && !cur_deflate_raw && !(set_xp9_last_blk || xp9_last_blk || r_last_blk || chu_frm))))
            abort_frm_early <= 1'b1;
          else if (sdd_fifo_wr && sdd_fifo_wbus.eof)
            abort_frm_early <= 1'b0;

          if ((((xp9_frm && (set_xp9_last_blk || xp9_last_blk)) 
              || chu_frm) && last_rd && !(last_eof_rd || r_last_eof_rd)) ||
              (one_after_last_rd && lfa_data_rd_valid && (xp10_frm || cur_deflate_raw))
              || dflate_late_eof || (set_sob_eob && !set_sob_eob_eof && in_last_blk))
            late_eof_frm <= 1'b1;
          else if (sdd_fifo_wr && sdd_fifo_wbus.eof)
            late_eof_frm <= 1'b0;
          
          r_got_eob <= got_eob;
          r_eof_hdr_wrd <= (eof_hdr_wrd && rr_lfa_hdr_rd) ||
                           (xp_eof_clear) ||
                           (r_start_hdr && (invalid_hdr_addr || (bhp_htf_status_error && !r_sof_blk)));
          
          rr_eof_hdr_wrd <= r_eof_hdr_wrd;

          if ((!eof_fifo_empty || cur_eof_valid) && 
               (lfa_raddr == eof_addr) && lfa_rd_avail && lfa_hdr_rd)
             last_hdr_eof_rd <= 1'b1;
           else if ((p_hdr_st == HDR_IDLE_ST) || (p_hdr_st == HDR_WAIT_ST))
             last_hdr_eof_rd <= 1'b0;

          if (start_hdr && !deflate_hdr_frm)
            r_start_hdr <= 1'b1;
          else if (((p_hdr_st == HDR_IDLE_ST) && !start_hdr) ||
                   (rr_lfa_hdr_rd && !xp_hdr_frm) ||
                   (rr_lfa_hdr_rd && 
                    (xp9_first_word || xp10_first_word || eof_hdr_wrd)))
            r_start_hdr <= 1'b0;

          if (start_hdr && deflate_hdr_frm)
            r_deflate_start_hdr <= 1'b1;
          else if (rr_lfa_hdr_rd)
            r_deflate_start_hdr <= 1'b0;
          
          if (sdd_fifo_wr && sdd_fifo_wbus.eob)
            sdd_fifo_clear <= 1'b1;
          else
            sdd_fifo_clear <= 1'b0;

          if (bhp_lfa_htf_status_valid && (cur_stbl_fmt == XP9)) begin
             if (start_data)
               cur_isize <= f_isize;
             if (f_valid && !start_data) begin
                next_isize <= bhp_lfa_htf_status_bus.orig_size;
                n_valid <= 1'b1;
             end
             else begin
                f_valid <= 1'b1;
                f_isize <= bhp_lfa_htf_status_bus.orig_size;
             end
          end
          else if (start_data) begin
             cur_isize <= f_isize;
             if (n_valid) begin
                f_isize <= next_isize;
                n_valid <= 1'b0;
             end
             else begin
                f_valid <= 1'b0;
                n_valid <= 1'b0;
             end
          end

          if (((p_data_st == CRC_ST) && (crc_cnt == 2)) ||
              (p_data_st == ERR_ST)) begin
             r_isize <= '0;
             if (p_data_st == ERR_ST)
               crc_size <= '0;
             else
               crc_size <= r_isize;
          end
          else if (r_start_data) begin 
             r_isize <= r_isize + cur_isize; 
          end
          r_start_data <= start_data;
          
          if (r_start_data) begin
             if (data_cnt > 512)
               large_data_frm <= 1'b1;
             else
               large_data_frm <= 1'b0;
          end
          else if (p_data_st != DATA_ST)
            large_data_frm <= 1'b0;
          
          if ((start_data && !nxt_deflate_data_frm) ||
              (start_data && nxt_deflate_raw && nxt_deflate_data_frm)) begin
             if ((nxt_words_to_send == 0) && (nxt_data_fmt != NONE) &&
                 (nxt_data_err == NO_ERRORS)) begin
                if ((nxt_data_ptr == eof_addr) && !eof_fifo_empty) begin
                   set_sob_eob_eof <= 1'b1;
                   set_sob_eob <= 1'b1;
                end
                else begin
                   set_sob_eob <= 1'b1;
                   set_sob_eob_eof <= 1'b0;
                end
                data_cnt <= '0;
             end 
             else begin
                if (nxt_words_to_send !=0)
                  data_cnt <= nxt_words_to_send-1;
                else
                  data_cnt <= '0;
             end 
          end
          else if (lfa_data_rd_valid && (data_cnt > 0)) begin
             set_sob_eob <= 1'b0;
             set_sob_eob_eof <= 1'b0;
             data_cnt <= data_cnt - 1;
          end
          else begin
             set_sob_eob <= 1'b0;
             set_sob_eob_eof <= 1'b0;
          end

          r_set_sob_eob_eof <= set_sob_eob_eof;
          
          if (((data_cnt == 0) && !in_last_blk && lfa_data_rd_valid) || 
              (in_last_blk && (last_eof_rd || pre_last_eof_rd)))
            eob_word_rd <= 1'b1;
          else
            eob_word_rd <= 1'b0;
          
          
          if (start_data)
            set_sob <= 1'b1;
          else if (tmp_sdd_valid)
            set_sob <= 1'b0;

          if ((p_data_st == DATA_ST) && (data_cnt == 0) && eob_word_rd &&
              (!deflate_data_frm || (deflate_data_frm && cur_deflate_raw))
              && r_lfa_data_rd && !raw_frm)
            sent_eob <= 1'b1;
          else
            sent_eob <= 1'b0;

          if (sdd_fifo_wbus.eob && sdd_fifo_wr)
            sent_last_eob <= 1'b0;
          else if (last_rd && sent_eob)
            sent_last_eob <= 1'b1;
          
          if ((p_data_st == DFLATE_EOB_ST) || (p_data_st == DFLATE_EOF_ST) ||
              (p_data_st == DATA_IDLE_ST) || (clear_sdd && !(lfa_sdd_sent_eof || r_lfa_sdd_sent_eof)))
            sent_eof_eob <= 1'b0;
          else if ((sdd_fifo_wbus.eob && sdd_fifo_wr && 
                    !sdd_fifo_wbus.eof && deflate_data_frm  
                   && (p_data_st == DATA_ST)) || (sent_eob))
            sent_eof_eob <= 1'b1;

          if ((p_data_st == DFLATE_EOB_ST) || (p_data_st == DFLATE_EOF_ST) ||
              (p_data_st == ERR_ST))
            r_lfa_sdd_sent_eof <= 1'b0;
          else if (lfa_sdd_sent_eof)
            r_lfa_sdd_sent_eof <= 1'b1;

          
          if (sdd_lfa_dp_ready)
            wait_for_sdd_ack <= 1'b0;
          else begin
             if (lfa_sdd_dp_valid) begin
                wait_for_sdd_ack <= 1'b1;
             end
          end
       end 
    end 
   assign a_bytes = (align_wdata.bytes_valid == 3'b0) ? 
                    4'b1000 : {1'b0, align_wdata.bytes_valid};
   
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         blk_hdr_bits <= 0;
         deflate_runt_blk <= 0;
         first_word_rd <= 0;
         runt_blk_valid <= 0;
         runt_err <= 0;
         xp10_runt_blk <= 0;
         
      end
      else begin
         if ((r_start_hdr || r_deflate_start_hdr) && rr_lfa_hdr_rd) begin
            first_word_rd <= 1'b1;
            blk_hdr_bits <= 7'd64 - hdr_align;
            if (cur_hdr_fmt == XP10) begin
               if (hdr_wr && align_wdata.eof && !first_word_rd) begin
                  if ({2'b0,hdr_align} < (a_bytes * 8)) begin
                     if (((a_bytes * 8) - hdr_align) < {1'b0,xp10_min_sz})
                       xp10_runt_blk <= 1'b1;
                     else
                       xp10_runt_blk <= 1'b0;
                  end
                  else
                    xp10_runt_blk <= 1'b1;
               end
               else if (hdr_wr && align_wdata.eof && first_word_rd) begin
                  if ((blk_hdr_bits + a_bytes * 8) < {1'b0, xp10_min_sz})
                    xp10_runt_blk <= 1'b1;
                  else
                    xp10_runt_blk <= 1'b0;
               end
               else begin
                  xp10_runt_blk <= 1'b0;
               end
            end 
            else if ((cur_hdr_fmt == ZLIB) || (cur_hdr_fmt == GZIP)) 
              begin
                 if (hdr_wr && align_wdata.eof) begin
                    if ((7'd64 - hdr_align) < 2'b11) 
                      deflate_runt_blk <= 1'b1;
                    else
                      deflate_runt_blk <= 1'b0;
                 end
                 else
                   deflate_runt_blk <= 1'b0;
              end
         end 
         else if (p_hdr_st == HDR_IDLE_ST) begin
            xp10_runt_blk <= 1'b0;
            first_word_rd <= 1'b0;
            deflate_runt_blk <= 1'b0;
         end 
         
         if (bhp_lfa_status_valid)
           runt_err <= 1'b0;
         else if ((xp10_runt_blk ||  deflate_runt_blk) && (p_hdr_st == HDR_DUMMY_ST))
           runt_err <= 1'b1;

         if (pre_runt_err)
           runt_blk_valid <= 1'b1;
         else if (sdd_fifo_wbus.eof && sdd_fifo_wr)
           runt_blk_valid <= 1'b0;

      end 
   end 
   

   assign xp10_min_sz = (xp10_crc_mode) ? 7'd64 : 7'd96;

   assign align_wdata.eob = (rr_lfa_hdr_rd) ? 1'b0 : sent_eob;
   assign align_wdata.eof = rr_lfa_rd ? lfa_rdata.eof : 1'b0;
   assign align_wdata.data = rr_lfa_rd ? lfa_rdata.data : '0;
   assign align_wdata.sof = rr_lfa_rd ? lfa_rdata.sof : '0;
   assign align_wdata.bytes_valid = lfa_rdata.bytes_valid;
   
   assign got_eob = ((p_data_st == DATA_ST) && (sdd_fifo_wbus.eob == 1'b1) &&
                         (sdd_fifo_wr));

   assign hdr_clear = hdr_align_clear || r_hdr_align_clear || bhp_lfa_stbl_sent || r_eof_hdr_wrd || 
                      rr_eof_hdr_wrd || xp_eof_clear || (r_start_hdr && (bhp_htf_status_error && !r_sof_blk));

   
   assign hdr_stbl_align = (p_hdr_st == HDR_ST) ? hdr_align : stbl_align;

   assign eof_hdr_wrd = xp9_eof_hdr_wrd || xp10_eof_hdr_wrd;
   assign xp9_eof_hdr_wrd = align_wdata.eof && r_start_hdr && (cur_hdr_fmt == XP9);
   assign xp10_eof_hdr_wrd = (align_wdata.eof && r_start_hdr && stbl_last_blk)
                              && (cur_hdr_fmt == XP10);
   
   assign clear_sdd = sdd_lfa_ack_valid && sdd_lfa_ack_bus.eob;
   
   assign sdd_ack_err = sdd_lfa_ack_valid && sdd_lfa_ack_bus.err;
   assign lfa_bhp_dp_valid = (bhp_dp_valid && !(eof_hdr_wrd && rr_lfa_hdr_rd))
                             || (p_hdr_st == HDR_DUMMY_ST);
   assign lfa_bhp_dp_bus = (p_hdr_st == HDR_DUMMY_ST) ? lfa_bhp_dummy_bus :
                           int_lfa_bhp_dp_bus;
   
   assign lfa_bhp_dummy_bus.data = 64'b0;
   assign lfa_bhp_dummy_bus.eof = 1'b1;
   assign lfa_bhp_dummy_bus.sof = 1'b0;
   assign lfa_bhp_dummy_bus.eob = 1'b0;
   assign lfa_bhp_dummy_bus.bytes_valid = 3'b0;
   
   assign hdr_wr = rr_lfa_hdr_rd && !eof_hdr_wrd && !xp_eof_clear;
   
    
   cr_xp10_decomp_fe_data_aligner hdr_inst (
                                     
                                     .align_rdata        (int_lfa_bhp_dp_bus),
                                     .align_rd           (bhp_dp_valid),
                                     
                                     .clk                (clk),
                                     .rst_n              (rst_n),
                                     .align_wdata        (align_wdata),
                                     .align_wr           (hdr_wr),
                                     .align_afull        (align_hdr_full),
                                     .align_offset       (hdr_stbl_align),
                                     .align_ack          (bhp_lfa_dp_ready),
                                     .align_pre_eof      (),
                                     .align_clear        (hdr_clear));

   assign rd_data_valid = tmp_sdd_valid && !sdd_fifo_clear;
   
   cr_xp10_decomp_fe_data_aligner data_inst (
                                     
                                     .align_rdata       (tmp_sdd_bus),
                                     .align_rd          (tmp_sdd_valid),
                                   
                                     .clk               (clk),
                                     .rst_n             (rst_n),
                                     .align_wdata       (align_wdata),
                                     .align_wr          (rr_lfa_data_rd && wait_for_eob),
                                     .align_afull       (align_data_full),
                                     .align_offset      (data_align),
                                     .align_ack         ((data_ack && sdd_fifo_ready)),
                                     .align_pre_eof     (data_align_pre_eof),
                                     .align_clear       (sdd_fifo_clear));


   
   nx_fifo #(.DEPTH (4), .WIDTH ($bits(sof_fifo_t)))
   sof_fifo (.empty (sof_fifo_empty),
            .full (),
            .used_slots (sof_fifo_used),
            .free_slots (),
            .rdata (sof_fifo_rdata),
            .clk (clk),
            .rst_n (rst_n),
            .wen (sof_fifo_wr),
            .ren (sof_fifo_rd),
            .clear (fhp_lfa_clear_sof_fifo),
            .underflow (),
            .overflow (),
            .wdata (sof_fifo_wdata));

   
    
     
     
     
      
   
   assign eof_rd = (!eof_fifo_empty && 
                    ((eof_ack) ||
                     (!cur_eof_valid && sdd_fifo_wr && !set_sob_eob_eof && 
                      (sdd_fifo_wbus.eof) &&
                      (xp_frm || chu_frm))));
   
   assign eof_fifo_wdata.eof_addr = lfa_waddr;
   assign eof_fifo_wdata.frm_bytes = fhp_lfa_eof_bus.frm_bytes;
   assign eof_fifo_wdata.last = fhp_lfa_eof_bus.last;
   
   
   nx_fifo #(.DEPTH (4), .WIDTH ($bits(eof_fifo_t)))
   eof_fifo (.empty (eof_fifo_empty),
            .full (),
            .used_slots (),
            .free_slots (),
            .rdata (eof_fifo_rdata),
            .clk (clk),
            .rst_n (rst_n),
            .wen ((lfa_wdata.eof && lfa_wr)),
            .ren (eof_rd),
            .clear (fhp_lfa_clear_sof_fifo),
            .underflow (),
            .overflow (),
            .wdata (eof_fifo_wdata));
   
   
   nx_fifo #(.DEPTH (8), .WIDTH ($bits(lfa_sdd_dp_bus_t)))
   sdd_fifo (.empty (sdd_fifo_empty),
            .full (),
            .used_slots (sdd_fifo_used),
            .free_slots (),
            .rdata (sdd_fifo_rbus),
            .clk (clk),
            .rst_n (rst_n),
            .wen (sdd_fifo_wr),
            .ren (sdd_fifo_rd),
            .clear (clear_sdd),
            .underflow (),
            .overflow (),
            .wdata (sdd_fifo_wbus));
   
   cr_xp10_decomp_fe_lfa_fifo lfa_inst (.clk (clk),
                                        .rst_n (rst_n),
                                        .ovstb (ovstb),
                                        .lvm (lvm),
                                        .mlvm (mlvm),
                                        .bimc_idat (bimc_idat),
                                        .bimc_isync (bimc_isync),
                                        .bimc_rst_n (bimc_rst_n),
                                        .bimc_odat (bimc_odat),
                                        .bimc_osync (bimc_osync),
                                        .fe_lfa_ro_uncorrectable_ecc_error_a(fe_lfa_ro_uncorrectable_ecc_error_a),
                                        .fe_lfa_ro_uncorrectable_ecc_error_b(fe_lfa_ro_uncorrectable_ecc_error_b),
                                        .wdata (lfa_wdata),
                                        .wr (lfa_wr),
                                        .waddr (lfa_waddr),
                                        .rd (lfa_rd),
                                        .raddr (lfa_raddr),
                                        .rdata (lfa_rdata),
                                        .empty (lfa_empty),
                                        .avail (lfa_avail),
                                        .rd_avail (lfa_rd_avail),
                                        .rd_ack (lfa_rd_ack),
                                        .rd_ack_addr(lfa_rd_ack_addr));
   
   function logic [15:0] get_alignment_n_new_ptr;
      input [31:0] hd_size;
      input [9:0]  hd_ptr;
      input [5:0]  hd_align_bits;
      input        byte_align;
      
      logic [9:0]  new_ptr;
      logic [31:0] tmp_size;
      logic [5:0]  mod_bits;
      logic        mod_size;
      logic [15:0] words_consumed;
      logic [2:0]  pad_bytes;
      logic [31:0] new_size;
      
      begin
         
         tmp_size = hd_size + hd_align_bits;  
         if (byte_align)
           pad_bytes = (8 - (tmp_size % 8)); 
         else
           pad_bytes = '0;
         new_size = tmp_size + pad_bytes; 
         
         mod_bits = new_size % `AXI_S_DP_DWIDTH;
         mod_size = (mod_bits > 0) ? 1'b1 : 1'b0;
         words_consumed = (new_size/`AXI_S_DP_DWIDTH);
         new_ptr = hd_ptr + words_consumed;
         get_alignment_n_new_ptr = {mod_bits, new_ptr};
      end
   endfunction 
   
   
   function logic [2:0] get_crc_frm_fmt;
      input cmd_comp_mode_e frm_fmt;
      input crc_option;
      begin
         case (frm_fmt) 
            XP9 : get_crc_frm_fmt = 3'b0;
            XP10 : begin 
               if (crc_option)
                 get_crc_frm_fmt = 3'b001;
               else
                 get_crc_frm_fmt = 3'b010;
            end
           ZLIB : get_crc_frm_fmt = 3'b011;
           GZIP : get_crc_frm_fmt = 3'b100;
           CHU4K : get_crc_frm_fmt = 3'b110;
           CHU8K : get_crc_frm_fmt = 3'b111;
           default : get_crc_frm_fmt = 3'b101;
         endcase 
      end
   endfunction 
   
endmodule 







