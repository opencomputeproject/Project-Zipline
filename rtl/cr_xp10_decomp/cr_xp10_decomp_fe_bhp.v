/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
module cr_xp10_decomp_fe_bhp (
   
   bhp_htf_hdr_dp_valid, bhp_htf_hdr_dp_bus, bhp_htf_hdrinfo_valid,
   bhp_htf_hdrinfo_bus, bhp_htf_status_ready, bhp_lfa_dp_ready,
   bhp_lfa_status_valid, bhp_lfa_status_bus, bhp_lfa_htf_status_valid,
   bhp_lfa_htf_status_bus, bhp_mtf_hdr_valid, bhp_mtf_hdr_bus,
   xp9_blk_stb, xp10_blk_stb, xp10_raw_blk_stb, zlib_blk_stb,
   zlib_raw_blk_stb, gzip_blk_stb, gzip_raw_blk_stb, xp9_crc_err_stb,
   chu4k_raw_stb, chu8k_raw_stb, bhp_lfa_stbl_sent,
   
   clk, rst_n, ovstb, lvm, mlvm, htf_bhp_hdr_dp_ready,
   htf_bhp_hdrinfo_ready, htf_bhp_status_valid, htf_bhp_status_bus,
   lfa_bhp_dp_valid, lfa_bhp_dp_bus, lfa_bhp_align_bits,
   lfa_bhp_sof_valid, lfa_bhp_sof_bus, mtf_bhp_hdr_ready
   );

   import crPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   
   
   
   input                         clk;
   input                         rst_n; 
   
   
   
   
   input                         ovstb;
   input                         lvm;
   input                         mlvm;
   
   
   
   
   output logic                  bhp_htf_hdr_dp_valid;
   output bhp_htf_hdr_dp_bus_t   bhp_htf_hdr_dp_bus;
   input                         htf_bhp_hdr_dp_ready;
   
   
   
   
   output logic                  bhp_htf_hdrinfo_valid;
   output bhp_htf_hdrinfo_bus_t  bhp_htf_hdrinfo_bus;
   input logic                   htf_bhp_hdrinfo_ready;
   
   
   
   
   input logic                   htf_bhp_status_valid;
   input htf_bhp_status_bus_t    htf_bhp_status_bus;
   output logic                  bhp_htf_status_ready;

   
   
   
   input logic                   lfa_bhp_dp_valid;
   input fe_dp_bus_t             lfa_bhp_dp_bus;
   output logic                  bhp_lfa_dp_ready;

   input [5:0]                   lfa_bhp_align_bits;
   
   input logic                   lfa_bhp_sof_valid;
   input fe_sof_bus_t            lfa_bhp_sof_bus;
   
   
   
   
   output logic                  bhp_lfa_status_valid;
   output bhp_lfa_status_bus_t   bhp_lfa_status_bus;

   output logic                  bhp_lfa_htf_status_valid;
   output bhp_lfa_status_bus_t   bhp_lfa_htf_status_bus;

   
   
   
   output logic                  bhp_mtf_hdr_valid;
   output bhp_mtf_hdr_bus_t      bhp_mtf_hdr_bus;
   input                         mtf_bhp_hdr_ready;
   
   output logic                  xp9_blk_stb;
   output logic                  xp10_blk_stb;
   output logic                  xp10_raw_blk_stb;
   output logic                  zlib_blk_stb;
   output logic                  zlib_raw_blk_stb;
   output logic                  gzip_blk_stb;
   output logic                  gzip_raw_blk_stb;
   output logic                  xp9_crc_err_stb;
   output logic                  chu4k_raw_stb;
   output logic                  chu8k_raw_stb;
   output logic                  bhp_lfa_stbl_sent;
   
   logic [2:0]                   cnt;
   logic [9:0]                   stbl_cnt;
   
   cmd_comp_mode_e               r_sof_fmt;
   cmd_comp_mode_e               stbl_r_sof_fmt;
   logic                         r_trace_bit;
   logic                         r_lfa_bhp_dp_valid;
   fe_dp_bus_t                   r_lfa_bhp_dp_bus; 
   fe_dp_bus_t                   r_dp_bus; 
   zipline_error_e                r_sof_error;
   zipline_error_e                hdr_err;
   
   typedef enum logic [3:0]      {IDLE = 0,
                                  FRM_HDR = 1,
                                  BLK_HDR = 2,
                                  FRM_DFLATE = 3,
                                  BLK_DFLATE = 4,
                                  STBL_WAIT = 5,
                                  STBL_HDR = 6,
                                  ERR_HDR = 7,
                                  ERR_STBL_WAIT = 8} frm_state_e;
   
   frm_state_e                   frm_st, r_frm_st;

   logic                         frm_blk_type;
   logic                         frm_last_blk;
   logic [31:0]                  frm_out_size;
   logic [31:0]                  frm_in_size;
   logic                         mtf_done;
   logic                         mtf_len;
   logic                         ptr_len;
   logic                         mtf_last_ptr;
   logic [2:0]                   wsize;
   logic                         r_htf_bhp_hdr_dp_ready;
   
   logic [`AXI_S_DP_DWIDTH-1:0]  mtf_part_word;
   logic                         mtf_part_valid;
   logic                         mtf_res_valid;
   logic                         mtf_present;
   
   logic [$clog2(`MAX_MTF_HDRS_SZ)-1:0] mtf_bits_used;
   logic [$clog2(`MAX_MTF_HDRS_SZ)-1:0] mtf_size;
   logic [`MAX_MTF_HDRS_SZ-1:0]       mtf_hdrs;
   logic                             crc_option;
   logic                             hdr_dp_ready;
   logic                             stbl_dp_ready;
   logic                             r_stbl_dp_ready;
   logic                             set_stbl_last;
   logic                             got_sof;
   logic                             got_eof;
   logic                             r_got_eof;
   
   logic                             xp9_sof;
   logic [31:0]                      xp9_crc_in;
   logic [63:0]                      xp9_crc_data;
   logic [31:0]                      xp9_crc_out;
   logic [31:0]                      xp9_frm_crc;
   logic [31:0]                      xp9_tmp_crc;
   logic [6:0]                       xp9_crc_bits;
   logic                             chk_crc;
   logic                             set_xp9_crc_err;
   logic                             set_xp9_seq_err;

   logic [31:0]                      xp9_seq_num;

   logic                             no_deflate_errors;
   logic                             no_xp9_errors;
   logic                             no_xp10_errors;
   logic                             set_xp10_flg_err;
   logic                             send_xp10_raw;
   logic                             send_deflate_raw;
   logic                             send_raw_info;
   logic                             send_hdrinfo_raw;
   
   logic                             bhp_fifo_empty;
   logic                             bhp_fifo_wr;
   logic                             bhp_fifo_rd;
   fe_dp_bus_t                       bhp_fifo_rbus;
   fe_dp_bus_t                       bhp_fifo_wbus;
   logic [3:0]                       bhp_fifo_used;
   logic                             wait_for_htf_ack;
   logic                             wait_for_bhp_ack;
   logic [22:0]                      hdr_adj_bits;
   
   logic                             htf_fifo_wr;
   logic                             htf_fifo_rd;
   bhp_htf_hdr_dp_bus_t              htf_fifo_wbus;
   bhp_htf_hdr_dp_bus_t              htf_fifo_rbus;
   bhp_htf_hdr_dp_bus_t              r_htf_fifo_rbus;
   logic [3:0]                       htf_fifo_used;
   logic                             htf_fifo_empty;
   
   logic                             r_dp_valid;
   
   logic                             deflate_status_valid;
   logic                             deflate_data_ready;
   logic                             deflate_data_valid;
   logic                             deflate_data_sof;
   logic                             deflate_frm_fmt;
   logic [5:0]                       deflate_align_bits;
   logic                             deflate_data_eof;
   
   htf_fmt_e                         deflate_fmt;
   htf_fmt_e                         r_deflate_fmt;
   logic                             r_deflate_valid;
   logic                             saved_last_blk;
   logic                             send_hdr_info;
   logic [63:0]                      deflate_data_in;

   zipline_error_e                    deflate_errors;
   zipline_error_e                    r_deflate_errors;
   logic                             deflate_blast;
   logic                             r_deflate_blast;
   logic [15:0]                      deflate_len;

   logic [12:0]                      deflate_bits_consumed;
   logic                             set_invalid_hdr;
   logic                             chu_mode;
   logic                             send_chu_raw;
   logic                             r_phd_present;
   
   logic                             xp9_blk;
   logic                             xp10_blk;
   logic                             xp10_raw_blk;
   logic                             gzip_blk;
   logic                             gzip_raw_blk;
   logic                             zlib_blk;
   logic                             zlib_raw_blk;
   logic                             chu4k_blk;
   logic                             chu4k_raw_blk;
   logic                             chu8k_blk;
   logic                             chu8k_raw_blk;
   logic                             xp9_crc_err;
   logic [15:0]                      part_osize;
   logic                             xp10_hdr_blk;
   logic                             xp10_last_blk;
   logic                             xp10_mtf;
   logic                             send_raw;
   logic [31:0]                      cum_size;
   logic                             wait_for_htf_status;
   logic                             hold_mtf_valid;
   
   logic [31:0]                      stbl_frm_out_size;
   logic [31:0]                      stbl_frm_in_size;
   logic                             stbl_crc_option;
   logic                             stbl_frm_last_blk;
   logic                             int_mtf_hdr_valid;
   bhp_mtf_hdr_bus_t                 int_mtf_hdr_bus;
   bhp_mtf_hdr_bus_t                 r_int_mtf_hdr_bus;
   logic                             r_sof_blk;
   
   logic                             r_bhp_lfa_htf_status_valid;
   bhp_lfa_status_bus_t              r_bhp_lfa_htf_status_bus;
   logic                             send_error;
   logic                             rr_sof_blk;
   logic [16:0]                      r_pfx_sz;


   logic [10:0]                      r_tlv_frame_num;
   logic [3:0]                       r_tlv_eng_id;
   logic [7:0]                       r_tlv_seq_num;
   logic [15:0]                      r_rqe_sched_handle;
   logic [63:0]                      nxt_data;
   logic [16:0]                      chu_sz;
   logic                             no_htf_errors;

   logic                             int_bhp_htf_hdrinfo_valid;
   bhp_htf_hdrinfo_bus_t             int_bhp_htf_hdrinfo_bus;

   logic                             hdrinfo_fifo_wr;
   logic                             hdrinfo_fifo_rd;
   bhp_htf_hdrinfo_bus_t             hdrinfo_fifo_rdata;
   bhp_htf_hdrinfo_bus_t             hdrinfo_fifo_wdata;
   logic                             hdrinfo_fifo_empty;
   logic                             clear_hdrinfo;
   logic                             r_clear_hdrinfo;
   logic                             set_wsize_err;
   logic                             hdrinfo_sof_blk;
   logic [12:0]                      xp9_stbl_bits;
   logic [12:0]                      stbl_xp9_stbl_bits;
   logic                             stbl_sz_err;
   logic                             set_mtf_hdr_err;
   logic                             valid_mtf_hdr;
   logic                             r_mtf_res_valid;
   logic                             invalid_sz;
   logic [12:0]                      updated_hdr_size;
   logic                             invalid_cum_sz;
   
   assign bhp_htf_status_ready = 1'b1;     
   assign send_raw_info = ((lfa_bhp_sof_valid && 
                            (lfa_bhp_sof_bus.error == NO_ERRORS) &&
                            (lfa_bhp_sof_bus.sof_fmt == NONE))) ? 1'b1 : 1'b0;
   assign send_xp10_raw = ((r_sof_fmt == XP10) && (frm_blk_type == 1'b0) &&
                           mtf_done && no_xp10_errors) ? 1'b1 : 1'b0;
   assign send_deflate_raw = ((deflate_status_valid && no_deflate_errors &&
                               deflate_fmt == HTF_FMT_RAW) ?
                              2'b1 : 1'b0);
   assign chu_mode = ((r_sof_fmt == CHU4K) || (r_sof_fmt == CHU8K)) ? 
                     1'b1 : 1'b0;
   assign send_chu_raw = (r_lfa_bhp_dp_valid && (frm_st == FRM_HDR) &&
                          r_lfa_bhp_dp_bus.data[`CHU_MODE_BIT] && 
                          (r_lfa_bhp_dp_bus.data[`CHU_PFX_MSB:`CHU_PFX_LSB] == 0));
   assign send_raw = send_raw_info || send_xp10_raw ||
                     send_deflate_raw || send_chu_raw;
   
   assign chu_sz = (r_lfa_bhp_dp_bus.data[`CHU_SZ_MSB:`CHU_SZ_LSB] == 0) ?
                   17'h10000 : {1'b0, r_lfa_bhp_dp_bus.data[`CHU_SZ_MSB:`CHU_SZ_LSB]};
   assign stbl_sz_err = ((stbl_r_sof_fmt == XP9) && htf_bhp_status_valid && 
                         (htf_bhp_status_bus.size != stbl_xp9_stbl_bits)) || invalid_sz;
   
   assign invalid_sz = ((stbl_r_sof_fmt == XP9) || (stbl_r_sof_fmt == XP10) || 
                        (stbl_r_sof_fmt == CHU4K) || (stbl_r_sof_fmt == CHU8K)) &&
                       (htf_bhp_status_valid && (stbl_frm_out_size < {19'b0, htf_bhp_status_bus.size}))
                       ? 1'b1 : 1'b0;
   assign invalid_cum_sz = (mtf_done && ({19'b0, updated_hdr_size} > cum_size) && ((r_sof_fmt == XP10) || r_sof_fmt == XP9));
   
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         r_sof_fmt <= NONE;
         r_sof_error <= NO_ERRORS;
         
         
         hdrinfo_sof_blk <= 0;
         r_htf_bhp_hdr_dp_ready <= 0;
         r_lfa_bhp_dp_bus <= 0;
         r_lfa_bhp_dp_valid <= 0;
         r_mtf_res_valid <= 0;
         r_pfx_sz <= 0;
         r_phd_present <= 0;
         r_rqe_sched_handle <= 0;
         r_sof_blk <= 0;
         r_tlv_eng_id <= 0;
         r_tlv_frame_num <= 0;
         r_tlv_seq_num <= 0;
         r_trace_bit <= 0;
         rr_sof_blk <= 0;
         wait_for_htf_status <= 0;
         xp9_seq_num <= 0;
         
      end
      else begin
         if (lfa_bhp_sof_valid) begin
            r_sof_fmt <= lfa_bhp_sof_bus.sof_fmt;
            r_trace_bit <= lfa_bhp_sof_bus.trace_bit;
            r_phd_present <= lfa_bhp_sof_bus.phd_present;
            r_sof_error <= lfa_bhp_sof_bus.error;
            r_pfx_sz <= lfa_bhp_sof_bus.pfx_sz;
            r_tlv_frame_num <= lfa_bhp_sof_bus.tlv_frame_num;
            r_tlv_eng_id <= lfa_bhp_sof_bus.tlv_eng_id;
            r_tlv_seq_num <= lfa_bhp_sof_bus.tlv_seq_num;
            r_rqe_sched_handle <= lfa_bhp_sof_bus.rqe_sched_handle;
         end
         r_lfa_bhp_dp_valid <= bhp_fifo_rd;
         r_lfa_bhp_dp_bus <= bhp_fifo_rbus;
         r_htf_bhp_hdr_dp_ready <= htf_bhp_hdr_dp_ready;
         r_mtf_res_valid <= mtf_res_valid;
         
         if (lfa_bhp_sof_valid)
           r_sof_blk <= 1'b1;
         else if (bhp_lfa_status_valid)
           r_sof_blk <= 1'b0;
         rr_sof_blk <= r_sof_blk;
         
         if (bhp_htf_hdrinfo_valid)
           hdrinfo_sof_blk <= 1'b0;
         else if (r_sof_blk)
           hdrinfo_sof_blk <= 1'b1;
         
         if (htf_bhp_status_valid)
           wait_for_htf_status <= 1'b0;
         else if (bhp_lfa_stbl_sent)
           wait_for_htf_status <= 1'b1;
         
         if (lfa_bhp_sof_valid)
           xp9_seq_num <= '0;
         else if ((r_sof_fmt == XP9) && (frm_st == BLK_HDR) && (cnt == 3) &&
                  (r_lfa_bhp_dp_valid))
           xp9_seq_num <= xp9_seq_num +1;
      end 
      
   end
   assign send_error = (frm_st == ERR_HDR)  ? 1'b1 : 1'b0;
   assign no_htf_errors = htf_bhp_status_valid ? 
                          ((htf_bhp_status_bus.error == NO_ERRORS) && !stbl_sz_err) : 1'b1;
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         frm_st <= IDLE;
         r_frm_st <= IDLE;
         
      end
      else begin
         r_frm_st <= frm_st;
         
         case (frm_st)
           IDLE : begin
              if (lfa_bhp_sof_valid && lfa_bhp_sof_bus.error != NO_ERRORS)
                frm_st <= ERR_HDR;
              else if (bhp_fifo_rd) begin
                 if ((r_sof_fmt == XP10) && bhp_fifo_rbus.sof)
                   frm_st <= FRM_HDR;
                 else if (chu_mode && bhp_fifo_rbus.sof)
                   frm_st <= FRM_HDR;
                 else if ((r_sof_fmt == XP10) || (r_sof_fmt == XP9))
                   frm_st <= BLK_HDR;
                 else if (((r_sof_fmt == GZIP) || (r_sof_fmt == ZLIB)) &&
                          bhp_fifo_rbus.sof)
                   frm_st <= FRM_DFLATE;
                 else if ((r_sof_fmt == GZIP) || (r_sof_fmt == ZLIB))
                   frm_st <= BLK_DFLATE;
              end
           end 
           FRM_HDR : begin
              if (no_xp10_errors && no_xp9_errors) begin
                 if ((r_sof_fmt == XP10) && bhp_fifo_rd)
                   frm_st <= BLK_HDR;
                 else if (chu_mode) begin
                    if (send_chu_raw)
                      frm_st <= IDLE;
                    else if (wait_for_htf_status && !htf_bhp_status_valid)
                      frm_st <= STBL_WAIT;
                    else if (htf_bhp_status_valid) begin
                       if (no_htf_errors || hdrinfo_sof_blk)
                         frm_st <= STBL_HDR;
                       else
                         frm_st <= IDLE;
                    end
                    else 
                      frm_st <= STBL_HDR;
                 end
              end 
              else 
                frm_st <= ERR_HDR;
           end
           BLK_HDR : begin
              if (no_xp9_errors && no_xp10_errors && no_deflate_errors) begin
                 if (send_xp10_raw)
                   frm_st <= IDLE;
                 else if (mtf_done && ((r_sof_fmt == XP9) || 
                                       (r_sof_fmt == XP10))) begin
                    if (wait_for_htf_status && !htf_bhp_status_valid)
                      frm_st <= STBL_WAIT;
                    else if (htf_bhp_status_valid || r_clear_hdrinfo) begin
                       if ((no_htf_errors || hdrinfo_sof_blk) && !r_clear_hdrinfo)
                         frm_st <= STBL_HDR;
                       else
                         frm_st <= IDLE;
                    end
                    else
                      frm_st <= STBL_HDR;
                 end
              end 
              else 
                frm_st <= ERR_HDR;
           end
           FRM_DFLATE : begin
              if (deflate_status_valid) begin
                 if (no_deflate_errors) begin
                    if (deflate_fmt == HTF_FMT_DEFLATE_DYNAMIC) begin
                       if (wait_for_htf_status && !htf_bhp_status_valid)
                         frm_st <= STBL_WAIT;
                       else if (htf_bhp_status_valid) begin
                          if (no_htf_errors || hdrinfo_sof_blk)
                            frm_st <= STBL_HDR;
                          else
                            frm_st <= IDLE;
                       end
                       else
                         frm_st <= STBL_HDR;
                    end
                    else 
                      frm_st <= IDLE;
                 end
                 else
                   frm_st <= ERR_HDR;
              end
           end
           BLK_DFLATE : begin
              if (deflate_status_valid) begin
                 if (no_deflate_errors) begin
                    if (deflate_fmt == HTF_FMT_DEFLATE_DYNAMIC) 
                       frm_st <= STBL_HDR;
                    else
                      frm_st <= IDLE;
                 end
                 else
                   frm_st <= ERR_HDR;
              end
           end
           STBL_WAIT : begin
              if (htf_bhp_status_valid) begin
                 if (no_htf_errors || hdrinfo_sof_blk)
                   frm_st <= STBL_HDR;
                 else
                   frm_st <= IDLE;
              end
           end
           ERR_STBL_WAIT : begin
              if (htf_bhp_status_valid)
                frm_st <= IDLE;
           end
           STBL_HDR : begin
              if (bhp_lfa_stbl_sent)
                frm_st <= IDLE;
           end
           ERR_HDR : begin
              if ((wait_for_htf_status && !htf_bhp_status_valid) && !hdrinfo_sof_blk)
                frm_st <= ERR_STBL_WAIT;
              else
                frm_st <= IDLE;
           end
           default : frm_st <= IDLE;
         endcase 
      end 
   end 

   always_comb
     begin
        hdr_adj_bits = '0;
        if (rr_sof_blk) begin
           hdr_adj_bits = (r_pfx_sz << 3);
        end
     end 
   

   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         int_bhp_htf_hdrinfo_bus <= '0;
         int_bhp_htf_hdrinfo_bus.fmt <= HTF_FMT_RAW;
         int_bhp_htf_hdrinfo_bus.sub_fmt <= HTF_SUB_FMT_NORMAL_GZIP;
         
         
         crc_option <= 0;
         got_eof <= 0;
         got_sof <= 0;
         int_bhp_htf_hdrinfo_bus.hdr_bits_in <= 0;
         int_bhp_htf_hdrinfo_bus.min_mtf_len <= 0;
         int_bhp_htf_hdrinfo_bus.min_ptr_len <= 0;
         int_bhp_htf_hdrinfo_bus.phd_present <= 0;
         int_bhp_htf_hdrinfo_bus.rqe_sched_handle <= 0;
         int_bhp_htf_hdrinfo_bus.sof_blk <= 0;
         int_bhp_htf_hdrinfo_bus.tlv_eng_id <= 0;
         int_bhp_htf_hdrinfo_bus.tlv_frame_num <= 0;
         int_bhp_htf_hdrinfo_bus.tlv_seq_num <= 0;
         int_bhp_htf_hdrinfo_bus.trace_bit <= 0;
         int_bhp_htf_hdrinfo_bus.winsize <= 0;
         int_bhp_htf_hdrinfo_valid <= 0;
         mtf_len <= 0;
         part_osize <= 0;
         ptr_len <= 0;
         r_got_eof <= 0;
         send_hdrinfo_raw <= 0;
         set_invalid_hdr <= 0;
         set_wsize_err <= 0;
         set_xp10_flg_err <= 0;
         set_xp9_seq_err <= 0;
         wsize <= 0;
         
      end
      else begin
         r_got_eof <= got_eof;
         
         if (bhp_lfa_status_valid)
           got_eof <= 1'b0;
         else if (r_lfa_bhp_dp_valid && r_lfa_bhp_dp_bus.eof)
           got_eof <= 1'b1;
         
         if (frm_st == FRM_HDR) begin
            if ((r_sof_fmt == XP10) && (r_lfa_bhp_dp_valid)) begin
               if (r_lfa_bhp_dp_bus.data[`XP10_WSZ_MSB:`XP10_WSZ_LSB] < 3'b100) begin
                  wsize <= r_lfa_bhp_dp_bus.data[`XP10_WSZ_MSB:`XP10_WSZ_LSB];
                  set_wsize_err <= 1'b0;
               end
               else
                 set_wsize_err <= 1'b1;
               
               ptr_len <= r_lfa_bhp_dp_bus.data[`XP10_PTR_SZ];
               mtf_len <= r_lfa_bhp_dp_bus.data[`XP10_PTR_SZ];

               crc_option <= r_lfa_bhp_dp_bus.data[`XP10_CRC_OPTION];
               part_osize <= r_lfa_bhp_dp_bus.data[`XP10_OSIZE0_MSB:`XP10_OSIZE0_LSB];
               
               set_xp10_flg_err <= r_lfa_bhp_dp_bus.data[`XP10_XTRA_FLG];
               got_sof <= 1'b1;
            end 
            else if (chu_mode) begin
               if (r_lfa_bhp_dp_bus.data[`CHU_WSIZE_SEL])
                 wsize <= 3'b001;
               else
                 wsize <= 3'b000;

               ptr_len <= 1'b0;
               mtf_len <= 1'b0;
            end
         end 
         else if (frm_st == BLK_HDR) begin
            
            
            
            if (((r_sof_fmt == XP9) && (r_lfa_bhp_dp_valid)) && (cnt ==1)) begin
               if (r_lfa_bhp_dp_bus.data[`XP9_WSZ_MSB:`XP9_WSZ_LSB] == 3'b0) begin
                  wsize <= r_lfa_bhp_dp_bus.data[`XP9_WSZ_MSB:`XP9_WSZ_LSB];
                  set_wsize_err <= 1'b0;
               end
               else begin
                  set_wsize_err <= 1'b1;
               end
               ptr_len <= r_lfa_bhp_dp_bus.data[`XP9_PTR_SZ];
               mtf_len <= r_lfa_bhp_dp_bus.data[`XP9_MTF_SZ];
            end
         end
         else begin
            got_sof <= 1'b0;
            if (bhp_lfa_status_valid) begin
               set_xp10_flg_err <= 1'b0;
               set_wsize_err <= 1'b0;
            end
         end
         int_bhp_htf_hdrinfo_bus.tlv_frame_num <= r_tlv_frame_num;
         int_bhp_htf_hdrinfo_bus.tlv_seq_num <= r_tlv_seq_num;
         int_bhp_htf_hdrinfo_bus.tlv_eng_id <= r_tlv_eng_id;
         int_bhp_htf_hdrinfo_bus.rqe_sched_handle <= r_rqe_sched_handle;
         send_hdrinfo_raw <= send_raw || send_chu_raw || send_error;
         
         if (send_hdrinfo_raw)
           begin
              int_bhp_htf_hdrinfo_valid <= 1'b1;
              int_bhp_htf_hdrinfo_bus.fmt <= HTF_FMT_RAW;
              int_bhp_htf_hdrinfo_bus.winsize <= '0;
              int_bhp_htf_hdrinfo_bus.min_ptr_len <= '0;
              int_bhp_htf_hdrinfo_bus.min_mtf_len <= '0;
              int_bhp_htf_hdrinfo_bus.phd_present <= r_phd_present;
              int_bhp_htf_hdrinfo_bus.sof_blk <= r_sof_blk;
              int_bhp_htf_hdrinfo_bus.trace_bit <= r_trace_bit;
              int_bhp_htf_hdrinfo_bus.hdr_bits_in <= bhp_lfa_status_bus.hdr_size + hdr_adj_bits; 
              
           end
         else if (send_hdr_info) begin
            int_bhp_htf_hdrinfo_bus.trace_bit <= r_trace_bit;
            if (r_sof_fmt == XP10) begin
               int_bhp_htf_hdrinfo_valid <= 1'b1;
               int_bhp_htf_hdrinfo_bus.fmt <= HTF_FMT_XP10;
               int_bhp_htf_hdrinfo_bus.sub_fmt <= HTF_SUB_FMT_NORMAL_GZIP;
               int_bhp_htf_hdrinfo_bus.winsize <= wsize;
               int_bhp_htf_hdrinfo_bus.min_ptr_len <= ptr_len;
               int_bhp_htf_hdrinfo_bus.min_mtf_len <= mtf_len;
               int_bhp_htf_hdrinfo_bus.phd_present <= r_phd_present;
               int_bhp_htf_hdrinfo_bus.sof_blk <= r_sof_blk;
               
               int_bhp_htf_hdrinfo_bus.hdr_bits_in <= bhp_lfa_status_bus.hdr_size + hdr_adj_bits; 
            end
            else if (r_sof_fmt == XP9) begin
               int_bhp_htf_hdrinfo_valid <= 1'b1;
               int_bhp_htf_hdrinfo_bus.fmt <= HTF_FMT_XP9;
               int_bhp_htf_hdrinfo_bus.winsize <= wsize;
               int_bhp_htf_hdrinfo_bus.min_ptr_len <= ptr_len;
               int_bhp_htf_hdrinfo_bus.min_mtf_len <= mtf_len;
               int_bhp_htf_hdrinfo_bus.phd_present <= r_phd_present;
               int_bhp_htf_hdrinfo_bus.sof_blk <= r_sof_blk;
               int_bhp_htf_hdrinfo_bus.hdr_bits_in <= {10'b0, bhp_lfa_status_bus.hdr_size};
            end
            else if ((r_sof_fmt == CHU4K) ||(r_sof_fmt == CHU8K)) begin
               int_bhp_htf_hdrinfo_valid <= 1'b1;
               int_bhp_htf_hdrinfo_bus.fmt <= HTF_FMT_XP10;
               if (r_sof_fmt == CHU4K)
                 int_bhp_htf_hdrinfo_bus.sub_fmt <= HTF_SUB_FMT_CHU4K_ZLIB;
               else
                 int_bhp_htf_hdrinfo_bus.sub_fmt <= HTF_SUB_FMT_CHU8K;
               int_bhp_htf_hdrinfo_bus.winsize <= wsize;
               int_bhp_htf_hdrinfo_bus.min_ptr_len <= 1'b1;
               int_bhp_htf_hdrinfo_bus.min_mtf_len <= 1'b0;
               int_bhp_htf_hdrinfo_bus.phd_present <= r_phd_present;
               int_bhp_htf_hdrinfo_bus.sof_blk <= r_sof_blk;
               int_bhp_htf_hdrinfo_bus.hdr_bits_in <= {10'b0, bhp_lfa_status_bus.hdr_size};
            end
            else if (r_deflate_valid) begin
               int_bhp_htf_hdrinfo_valid <= 1'b1;
               int_bhp_htf_hdrinfo_bus.fmt <= r_deflate_fmt;
               if (r_sof_fmt == GZIP)
                 int_bhp_htf_hdrinfo_bus.sub_fmt <= HTF_SUB_FMT_NORMAL_GZIP;
               else
                 int_bhp_htf_hdrinfo_bus.sub_fmt <= HTF_SUB_FMT_CHU4K_ZLIB;
               int_bhp_htf_hdrinfo_bus.winsize <= 3'b0; 
               int_bhp_htf_hdrinfo_bus.min_ptr_len <= 1'b0; 
               int_bhp_htf_hdrinfo_bus.min_mtf_len <= 1'b0; 
               int_bhp_htf_hdrinfo_bus.phd_present <= r_phd_present;
               int_bhp_htf_hdrinfo_bus.sof_blk <= r_sof_blk;
               int_bhp_htf_hdrinfo_bus.hdr_bits_in <= {10'b0, bhp_lfa_status_bus.hdr_size} + hdr_adj_bits; 
            end
            else begin
               int_bhp_htf_hdrinfo_valid <= 1'b0;
               int_bhp_htf_hdrinfo_bus <= '0;
            end
         end 
         else begin
            int_bhp_htf_hdrinfo_valid <= 1'b0;
            int_bhp_htf_hdrinfo_bus <= '0;
         end

         if (bhp_lfa_status_valid)
           set_xp9_seq_err <= 1'b0;
         else if ((r_sof_fmt == XP9) && (r_lfa_bhp_dp_valid)) begin
            if (cnt == 3) begin
               if (r_lfa_bhp_dp_bus.data[31:0] != xp9_seq_num)
                 set_xp9_seq_err <= 1'b1;
               else
                 set_xp9_seq_err <= 1'b0;
            end
         end

         if (bhp_lfa_status_valid)
           set_invalid_hdr <= 1'b0;
         else if ((r_sof_fmt == XP9) && ((r_lfa_bhp_dp_valid) || r_got_eof) 
                  && (frm_st == BLK_HDR)) begin
            if (cnt == 0) begin
               if ((r_lfa_bhp_dp_bus.data[31:0] != 32'd`XPRESS9_ID) || got_eof)
                 set_invalid_hdr <= 1'b1;
            end
            else if ((cnt <= 4) && (r_got_eof || got_eof))
              set_invalid_hdr <= 1'b1;
         end
         else if ((r_sof_fmt == XP10) && ((r_lfa_bhp_dp_valid) || r_got_eof) &&
                  (r_sof_blk)) begin
            if ((cnt < 1) && r_got_eof)
              set_invalid_hdr <= 1'b1;
         end
      end 
   end 

   assign no_deflate_errors = (deflate_errors == NO_ERRORS) ? 1'b1 : 1'b0;
   assign no_xp9_errors = (set_xp9_seq_err || set_xp9_crc_err || set_invalid_hdr || set_wsize_err || set_mtf_hdr_err || invalid_cum_sz) ? 1'b0 : 1'b1;
   assign no_xp10_errors = (set_xp10_flg_err || set_wsize_err || set_mtf_hdr_err || invalid_cum_sz) ? 1'b0 : 1'b1;

   
   assign xp10_hdr_blk = (got_sof) ? r_lfa_bhp_dp_bus.data[13] : r_lfa_bhp_dp_bus.data[29];
   
   assign xp10_last_blk = (got_sof) ? r_lfa_bhp_dp_bus.data[15] : r_lfa_bhp_dp_bus.data[31];
   

   assign xp10_mtf = (got_sof) ? r_lfa_bhp_dp_bus.data[14] : r_lfa_bhp_dp_bus.data[30];
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         r_deflate_fmt <= HTF_FMT_RAW;
         r_deflate_errors <= NO_ERRORS;
         
         
         cnt <= 0;
         cum_size <= 0;
         frm_blk_type <= 0;
         frm_in_size <= 0;
         frm_last_blk <= 0;
         frm_out_size <= 0;
         hdr_dp_ready <= 0;
         mtf_done <= 0;
         mtf_part_valid <= 0;
         mtf_part_word <= 0;
         mtf_present <= 0;
         mtf_size <= 0;
         r_deflate_blast <= 0;
         r_deflate_valid <= 0;
         saved_last_blk <= 0;
         set_mtf_hdr_err <= 0;
         xp9_stbl_bits <= 0;
         
      end
      else begin
         if (bhp_lfa_status_valid)
           saved_last_blk <= bhp_lfa_status_bus.last_blk;

         if (deflate_status_valid) begin
            r_deflate_valid <= 1'b1;
            r_deflate_fmt <= deflate_fmt;
            r_deflate_blast <= deflate_blast;
            r_deflate_errors <= deflate_errors;
         end
         else begin
            r_deflate_valid <= 1'b0;
            r_deflate_fmt <= HTF_FMT_RAW;
         end

         if (bhp_lfa_status_valid)
           set_mtf_hdr_err <= 1'b0;
         else if ((mtf_res_valid && !valid_mtf_hdr) ||
                  (mtf_done && invalid_cum_sz))
           set_mtf_hdr_err <= 1'b1;
         
         if (chu_mode && frm_st == FRM_HDR) begin

            frm_out_size <= {15'b0, chu_sz};
            cum_size <= chu_sz + `CHU_FIXED_HDR_SZ; 
            frm_blk_type <= 1'b0;
            frm_last_blk <= 1'b1;
         end
         else if (frm_st == BLK_HDR) begin
            if (r_lfa_bhp_dp_valid)
              cnt <= cnt + 1;
            
            if (r_sof_fmt == XP10) begin
               if (cnt == 0) begin
                  if (got_sof) begin
                     frm_out_size <= ({r_lfa_bhp_dp_bus.data[`XP10_OSIZE1_MSB:`XP10_OSIZE1_LSB],part_osize} - `XP10_FIXED_BLK_HDR_SZ); 
                     cum_size <= ({r_lfa_bhp_dp_bus.data[`XP10_OSIZE1_MSB:`XP10_OSIZE1_LSB],part_osize} + `XP10_FIXED_FRM_HDR_SZ); 
                  end
                  else begin
                     frm_out_size <= (r_lfa_bhp_dp_bus.data[`XP10_OSIZE1_MSB+16:`XP10_OSIZE1_LSB] - `XP10_FIXED_BLK_HDR_SZ); 
                     cum_size <= (r_lfa_bhp_dp_bus.data[`XP10_OSIZE1_MSB+16:`XP10_OSIZE1_LSB]); 
                  end
                  frm_blk_type <= xp10_hdr_blk; 
                  frm_last_blk <= xp10_last_blk; 
                  if ((xp10_mtf == 1'b0) ||
                      !(xp10_hdr_blk)) begin 
                     mtf_done <= 1'b1;
                     mtf_present <= 1'b0;
                     hdr_dp_ready <= 1'b0;
                     mtf_size <= '0;
                  end
                  else begin
                     if (got_sof) 
                       mtf_part_word <= {16'b0, r_lfa_bhp_dp_bus.data[63:16]};
                     else
                       mtf_part_word <= {32'b0, r_lfa_bhp_dp_bus.data[63:32]};
                     mtf_part_valid <= 1'b1;
                     mtf_present <= 1'b1;
                     mtf_size <= '0;
                  end
               end 
               else if ((cnt == 1) && !mtf_done && !r_got_eof) begin
                  if (got_eof) begin
                     hdr_dp_ready <= 1'b0;
                  end
                    mtf_size <= mtf_bits_used;
               end
               else if (((cnt == 2) || (r_got_eof)) && !mtf_done)  begin
                  mtf_done <= 1'b1;
                  hdr_dp_ready <= 1'b0;
                  frm_out_size <= frm_out_size - mtf_size; 
               end
               else begin
                  mtf_done <= 1'b0;
                  hdr_dp_ready <= 1'b1;

               end 
            end 
            else if (r_sof_fmt == XP9) begin
               frm_last_blk <= 1'b0;
               if (r_lfa_bhp_dp_valid || got_eof) begin
                  if (cnt == 0) begin
                     frm_in_size <= r_lfa_bhp_dp_bus.data[`XP9_ISIZE_MSB:`XP9_ISIZE_LSB];
                  end
                  else if (cnt == 1) begin
                     frm_out_size <= r_lfa_bhp_dp_bus.data[`XP9_OSIZE_MSB:`XP9_OSIZE_LSB] - `XP9_FIXED_HDR_SZ; 
                     cum_size <= r_lfa_bhp_dp_bus.data[`XP9_OSIZE_MSB:`XP9_OSIZE_LSB];
                     xp9_stbl_bits <= (r_lfa_bhp_dp_bus.data[`XP9_STBL_MSB:`XP9_STBL_LSB]);
                  end
                  else if ((cnt == 4) && !(got_eof || r_got_eof)) begin
                     mtf_part_word <= r_lfa_bhp_dp_bus.data;
                     mtf_part_valid <= 1'b1;
                     mtf_present <= 1'b1;
                  end
                  else if ((cnt == 5) && !mtf_done && !r_got_eof) begin
                     if (got_eof) begin
                        hdr_dp_ready <= 1'b0;
                     end
                     mtf_size <= mtf_bits_used;
                  end
                  else if (((cnt == 6) || r_got_eof) && !mtf_done) begin
                     mtf_done <= 1'b1;
                     hdr_dp_ready <= 1'b0;
                     frm_out_size <= frm_out_size - mtf_size; 
                  end
                  else begin
                     mtf_done <= 1'b0;
                     hdr_dp_ready <= 1'b1;

                     mtf_part_valid <= 1'b0;
                  end
               end 
            end 
         end 
         else begin
            mtf_done <= 1'b0;
            mtf_part_valid <= 1'b0;
            hdr_dp_ready <= 1'b1;

            cnt <= '0;
            mtf_present <= 1'b0;
         end
      end 
   end 

   assign bhp_mtf_hdr_bus = (int_mtf_hdr_valid) ? int_mtf_hdr_bus :
                            (hold_mtf_valid ? r_int_mtf_hdr_bus : '0);
   assign bhp_mtf_hdr_valid = int_mtf_hdr_valid || hold_mtf_valid;
   
   assign bhp_lfa_stbl_sent = ((!r_stbl_dp_ready && (frm_st == STBL_HDR)) || 
                               ((frm_st == STBL_HDR) && htf_bhp_status_valid)) ? 1'b1 : 1'b0;
   assign valid_mtf_hdr = (mtf_res_valid) ? ((mtf_hdrs[83:79] <= 5'b10000) && (mtf_hdrs[62:58] <= 5'b10000) &&
                                             (mtf_hdrs[41:37] <= 5'b10000) && (mtf_hdrs[20:16] <= 5'b10000)) : '0;
                                                         
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         hold_mtf_valid <= 0;
         int_mtf_hdr_bus <= 0;
         int_mtf_hdr_bus.exp0 <= 0;
         int_mtf_hdr_bus.exp1 <= 0;
         int_mtf_hdr_bus.exp2 <= 0;
         int_mtf_hdr_bus.exp3 <= 0;
         int_mtf_hdr_bus.format <= 0;
         int_mtf_hdr_bus.offset0 <= 0;
         int_mtf_hdr_bus.offset1 <= 0;
         int_mtf_hdr_bus.offset2 <= 0;
         int_mtf_hdr_bus.offset3 <= 0;
         int_mtf_hdr_bus.present <= 0;
         int_mtf_hdr_bus.ptr_last <= 0;
         int_mtf_hdr_bus.trace_bit <= 0;
         int_mtf_hdr_valid <= 0;
         r_int_mtf_hdr_bus <= 0;
         
      end
      else begin
         if (!mtf_bhp_hdr_ready && int_mtf_hdr_valid)
           r_int_mtf_hdr_bus <= int_mtf_hdr_bus;
         if (mtf_bhp_hdr_ready)
           hold_mtf_valid <= 1'b0;
         else if (int_mtf_hdr_valid)
           hold_mtf_valid <= 1'b1;
         
         if (mtf_res_valid && no_xp9_errors && no_xp10_errors && valid_mtf_hdr &&!r_mtf_res_valid) begin
            int_mtf_hdr_valid <= 1'b1;
            int_mtf_hdr_bus.exp0 <= mtf_hdrs[83:79];
            int_mtf_hdr_bus.offset0 <= mtf_hdrs[78:63];
            int_mtf_hdr_bus.exp1 <= mtf_hdrs[62:58];
            int_mtf_hdr_bus.offset1 <= mtf_hdrs[57:42];
            int_mtf_hdr_bus.exp2 <= mtf_hdrs[41:37];
            int_mtf_hdr_bus.offset2 <= mtf_hdrs[36:21];
            int_mtf_hdr_bus.exp3 <= mtf_hdrs[20:16];
            int_mtf_hdr_bus.offset3 <= mtf_hdrs[15:0];

            int_mtf_hdr_bus.present <= mtf_present;
            int_mtf_hdr_bus.format <= (r_sof_fmt == XP9) ? 1'b0 : 1'b1;
            int_mtf_hdr_bus.ptr_last <= mtf_last_ptr;
            int_mtf_hdr_bus.trace_bit <= r_trace_bit;
         end 
         else if ((mtf_done && !mtf_present && no_xp9_errors && no_xp10_errors) || send_raw || send_error ||
                  (send_hdr_info && 
                   ((r_sof_fmt == ZLIB) || (r_sof_fmt == GZIP) || (chu_mode)))) begin
            int_mtf_hdr_bus.present <= 1'b0;
            int_mtf_hdr_bus.format <= (r_sof_fmt == XP9) ? 1'b0 : 1'b1;
            int_mtf_hdr_valid <= 1'b1;
            int_mtf_hdr_bus.trace_bit <= r_trace_bit;
         end
         else begin
            int_mtf_hdr_valid <= 1'b0;
            int_mtf_hdr_bus <= '0;
         end 
      end 
   end 
   
   
   always_comb
     begin
        mtf_hdrs = '0;
        mtf_bits_used = '0;
        mtf_res_valid = 1'b0;
        mtf_last_ptr = '0;
        nxt_data = '0;

        if (got_eof)
          nxt_data = '0;
        else
          nxt_data = r_lfa_bhp_dp_bus.data;
        
        if ((r_sof_fmt == XP10) && (cnt == 1) && (frm_st == BLK_HDR) && 
            (mtf_part_valid || mtf_done) && ((r_lfa_bhp_dp_valid && !r_got_eof) || (got_eof && !r_got_eof))) begin
           if (got_sof) 
             {mtf_hdrs, mtf_bits_used, mtf_last_ptr} = get_mtf_header_and_numbits
                                                       ({16'b0, nxt_data,mtf_part_word[47:0]},
                                                        r_sof_fmt);
           else
             {mtf_hdrs, mtf_bits_used, mtf_last_ptr} = get_mtf_header_and_numbits
                                                       ({32'b0, nxt_data,mtf_part_word[31:0]},
                                                        r_sof_fmt);
           mtf_res_valid = 1'b1;
        end
        else if ((r_sof_fmt == XP9) && (cnt == 5) && (frm_st == BLK_HDR) && !mtf_done &&
                 ((r_lfa_bhp_dp_valid && !r_got_eof) || (got_eof && !r_got_eof))) begin
           {mtf_hdrs, mtf_bits_used, mtf_last_ptr} = get_mtf_header_and_numbits
                                                     ({nxt_data,mtf_part_word},
                                                      r_sof_fmt);
           mtf_res_valid = 1'b1;
        end
     end 
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         stbl_r_sof_fmt <= NONE;
         
         
         deflate_align_bits <= 0;
         r_dp_bus <= 0;
         r_dp_valid <= 0;
         r_htf_fifo_rbus <= 0;
         r_stbl_dp_ready <= 0;
         set_stbl_last <= 0;
         stbl_crc_option <= 0;
         stbl_dp_ready <= 0;
         stbl_frm_in_size <= 0;
         stbl_frm_last_blk <= 0;
         stbl_frm_out_size <= 0;
         stbl_xp9_stbl_bits <= 0;
         wait_for_htf_ack <= 0;
         
      end
      else begin
         r_stbl_dp_ready <= stbl_dp_ready;
         r_htf_fifo_rbus <= htf_fifo_rbus;
         r_dp_bus <= lfa_bhp_dp_bus;
         r_dp_valid <= (frm_st == STBL_HDR) && lfa_bhp_dp_valid;
         if ((frm_st == IDLE) && bhp_fifo_rd)
           deflate_align_bits <= lfa_bhp_align_bits;
         
         if (htf_bhp_hdr_dp_ready)
           wait_for_htf_ack <= 1'b0;
         else begin
            if (bhp_htf_hdr_dp_valid)
              wait_for_htf_ack <= 1'b1;
         end

         if ((frm_st == STBL_HDR) && (r_frm_st != STBL_HDR)) begin
            stbl_frm_out_size <= frm_out_size;
            stbl_frm_last_blk <= frm_last_blk;
            stbl_frm_in_size <= frm_in_size;
            stbl_crc_option <= crc_option;
            stbl_r_sof_fmt <= r_sof_fmt;
            stbl_xp9_stbl_bits <= xp9_stbl_bits - mtf_size; 
         end
              
         if (frm_st == STBL_HDR) begin
            if (stbl_dp_ready) begin
               if ((lfa_bhp_dp_bus.eof && lfa_bhp_dp_valid) ||
                   (htf_bhp_status_valid)) begin
                  stbl_dp_ready <= 1'b0;
                  set_stbl_last <= 1'b1;
               end
               else begin
                  if (lfa_bhp_dp_valid) begin
                     if (r_sof_fmt == XP10) begin
                        if (stbl_cnt < `XP10_MAX_SBL_TBL_SZ) begin
                           stbl_dp_ready <= 1'b1;
                           set_stbl_last <= 1'b0;
                        end
                        else begin
                           stbl_dp_ready <= 1'b0;
                           set_stbl_last <= 1'b1;
                        end
                     end
                     else if (r_sof_fmt == XP9) begin
                        if (stbl_cnt < `XP9_MAX_SBL_TBL_SZ) begin
                           set_stbl_last <= 1'b0;
                           stbl_dp_ready <= 1'b1;
                        end
                        else begin
                           set_stbl_last <= 1'b1;
                           stbl_dp_ready <= 1'b0;
                        end
                     end 
                     else if ((r_sof_fmt == GZIP) || (r_sof_fmt == ZLIB)) begin
                        if (stbl_cnt < `DFLATE_MAX_SBL_TBL_SZ) begin
                           set_stbl_last <= 1'b0;
                           stbl_dp_ready <= 1'b1;
                        end
                        else begin
                           set_stbl_last <= 1'b1;
                           stbl_dp_ready <= 1'b0;
                        end
                     end
                     else if (chu_mode) begin
                        if (stbl_cnt < `CHU_MAX_SBL_TBL_SZ) begin
                           stbl_dp_ready <= 1'b1;
                           set_stbl_last <= 1'b0;
                        end
                        else begin
                           stbl_dp_ready <= 1'b0;
                           set_stbl_last <= 1'b1;
                        end
                     end
                  end 
               end 
            end 
            else begin
               stbl_dp_ready <= 1'b0;
               set_stbl_last <= 1'b0;
            end 
         end 
         else begin
            stbl_dp_ready <= 1'b1;
            set_stbl_last <= 1'b0;
         end
      end 
   end

   always_comb
     begin
        updated_hdr_size = '0;
        
        if (r_sof_fmt == XP10) begin
           if (got_sof) 
             updated_hdr_size = `XP10_FIXED_HDR_SZ + mtf_size; 
           else
             updated_hdr_size = `XP10_FIXED_BLK_HDR_SZ + mtf_size; 
        end
        else if (r_sof_fmt == XP9)
          updated_hdr_size = `XP9_FIXED_HDR_SZ + mtf_size;
     end 

   always_comb
     begin
        if (r_sof_error != NO_ERRORS)
          hdr_err = r_sof_error;
        else if (set_mtf_hdr_err)
          hdr_err = HD_BHP_ILLEGAL_MTF_SZ;
        else if (set_xp9_seq_err)
          hdr_err = HD_BHP_XP9_HDR_SEQ;
        else if (set_xp9_crc_err)
          hdr_err = HD_BHP_BLK_CRC;
        else if (set_invalid_hdr)
          hdr_err = HD_BHP_HDR_INVALID;
        else if (set_wsize_err)
          hdr_err = HD_BHP_INVALID_WSIZE;
        else if (set_xp10_flg_err)
          hdr_err = HD_BHP_XP10_XTRA_FLAG_PRSNT;
        else if (r_deflate_errors != NO_ERRORS)
          hdr_err = r_deflate_errors;
        else
          hdr_err = NO_ERRORS;
     end 
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         bhp_lfa_status_bus.error <= NO_ERRORS;
         r_bhp_lfa_htf_status_bus.error <= NO_ERRORS;
         r_bhp_lfa_htf_status_bus.error <= NO_ERRORS;
         
         
         bhp_lfa_status_bus <= 0;
         bhp_lfa_status_bus.crc_option <= 0;
         bhp_lfa_status_bus.cum_size <= 0;
         bhp_lfa_status_bus.data_size <= 0;
         bhp_lfa_status_bus.hdr_size <= 0;
         bhp_lfa_status_bus.last_blk <= 0;
         bhp_lfa_status_bus.orig_size <= 0;
         bhp_lfa_status_bus.skip_stbl <= 0;
         bhp_lfa_status_valid <= 0;
         r_bhp_lfa_htf_status_bus <= 0;
         r_bhp_lfa_htf_status_bus.crc_option <= 0;
         r_bhp_lfa_htf_status_bus.data_size <= 0;
         r_bhp_lfa_htf_status_bus.hdr_size <= 0;
         r_bhp_lfa_htf_status_bus.last_blk <= 0;
         r_bhp_lfa_htf_status_bus.orig_size <= 0;
         r_bhp_lfa_htf_status_valid <= 0;
         r_clear_hdrinfo <= 0;
         send_hdr_info <= 0;
         stbl_cnt <= 0;
         
      end
      else begin

         if (bhp_lfa_stbl_sent)
           stbl_cnt <= '0;
         else if ((frm_st == STBL_HDR) && lfa_bhp_dp_valid)
            stbl_cnt <= stbl_cnt + 1;

         if (send_error) begin
            bhp_lfa_status_valid <= 1'b1;
            bhp_lfa_status_bus.cum_size <= '0;
            bhp_lfa_status_bus.hdr_size <= '0;
            bhp_lfa_status_bus.data_size <= '0;
            bhp_lfa_status_bus.orig_size <= '0;
            bhp_lfa_status_bus.skip_stbl <= '0;
            bhp_lfa_status_bus.last_blk <= '0;
            bhp_lfa_status_bus.crc_option <= '0;
            bhp_lfa_status_bus.error <= hdr_err;
         end
         else if (mtf_done && (frm_st == BLK_HDR) && no_xp9_errors && no_xp10_errors) begin
            bhp_lfa_status_valid <= 1'b1;
            if (cum_size > 32'h0fff_ffff)
              bhp_lfa_status_bus.cum_size <= 32'h0fff_ffff;
            else
              bhp_lfa_status_bus.cum_size <= cum_size;
            
            bhp_lfa_status_bus.error <= NO_ERRORS;
            if (!send_xp10_raw)
              send_hdr_info <= 1'b1;
            else
              send_hdr_info <= 1'b0;

            bhp_lfa_status_bus.hdr_size <= updated_hdr_size;
            
            
            
            
            
            
            
            
            
            
            bhp_lfa_status_bus.last_blk <= frm_last_blk;
            
            if ((r_sof_fmt == XP10) && (frm_blk_type == 0)) begin
               bhp_lfa_status_bus.skip_stbl <= 1'b1;
               
               bhp_lfa_status_bus.data_size <= frm_out_size;
            end
            else begin
               bhp_lfa_status_bus.skip_stbl <= 1'b0;
               bhp_lfa_status_bus.data_size <= '0;
            end
            bhp_lfa_status_bus.crc_option <= crc_option;
         end 
         else if (deflate_status_valid && no_deflate_errors) begin
            bhp_lfa_status_valid <= 1'b1;
            if (!send_deflate_raw)
              send_hdr_info <= 1'b1;
            else
              send_hdr_info <= 1'b0;
            bhp_lfa_status_bus.hdr_size <= deflate_bits_consumed;
            bhp_lfa_status_bus.last_blk <= deflate_blast;
            if (deflate_fmt == HTF_FMT_DEFLATE_DYNAMIC) begin
               bhp_lfa_status_bus.skip_stbl <= 1'b0;
               bhp_lfa_status_bus.data_size <= '0;
            end
            else begin
               bhp_lfa_status_bus.skip_stbl <= 1'b1;
               bhp_lfa_status_bus.data_size <= (deflate_len * 8); 
            end
            bhp_lfa_status_bus.crc_option <= 1'b0;
         end 
         else if (chu_mode && (frm_st == FRM_HDR)) begin
            bhp_lfa_status_valid <= 1'b1;
            bhp_lfa_status_bus.hdr_size <= `CHU_FIXED_HDR_SZ;
            bhp_lfa_status_bus.cum_size <= chu_sz + `CHU_FIXED_HDR_SZ; 
            if (send_chu_raw) begin
               bhp_lfa_status_bus.data_size <= chu_sz; 
               bhp_lfa_status_bus.skip_stbl <= 1'b1;
               send_hdr_info <= 1'b0;
            end
            else begin
               bhp_lfa_status_bus.data_size <= '0;
               bhp_lfa_status_bus.skip_stbl <= 1'b0;
               send_hdr_info <= 1'b1;
            end
            bhp_lfa_status_bus.last_blk <= 1'b0;
            bhp_lfa_status_bus.orig_size <= '0;
            bhp_lfa_status_bus.crc_option <= 1'b0;
            bhp_lfa_status_bus.error <= NO_ERRORS;
         end 
         else begin
            bhp_lfa_status_valid <= 1'b0;
            bhp_lfa_status_bus <= '0;
            send_hdr_info <= 1'b0;
         end 
         
         if (htf_bhp_status_valid) begin
            r_bhp_lfa_htf_status_valid <= 1'b1;
            r_bhp_lfa_htf_status_bus.hdr_size <= htf_bhp_status_bus.size;
            if ((stbl_r_sof_fmt == XP9) || (stbl_r_sof_fmt == XP10) || 
                (stbl_r_sof_fmt == CHU4K) || (stbl_r_sof_fmt == CHU8K)) begin
               r_bhp_lfa_htf_status_bus.data_size <= stbl_frm_out_size - htf_bhp_status_bus.size; 
               
               
               
               r_bhp_lfa_htf_status_bus.last_blk <= stbl_frm_last_blk;
            end
            else begin
               r_bhp_lfa_htf_status_bus.data_size <= '0;
               r_bhp_lfa_htf_status_bus.last_blk <= r_deflate_blast;
            end 
               
            if (stbl_r_sof_fmt == XP9) 
              r_bhp_lfa_htf_status_bus.orig_size <= stbl_frm_in_size;
            else
              r_bhp_lfa_htf_status_bus.orig_size <= '0;
            
            if (stbl_r_sof_fmt == XP10)
              r_bhp_lfa_htf_status_bus.crc_option <= stbl_crc_option;
            else
              r_bhp_lfa_htf_status_bus.crc_option <= 1'b0;
            
            if (htf_bhp_status_bus.error != NO_ERRORS)
              r_bhp_lfa_htf_status_bus.error <= htf_bhp_status_bus.error;
            else if (stbl_sz_err)
              r_bhp_lfa_htf_status_bus.error <= HD_BHP_STBL_SIZE_ERR;
            else
              r_bhp_lfa_htf_status_bus.error <= NO_ERRORS;
         end
         else if (bhp_lfa_htf_status_valid) begin
            r_bhp_lfa_htf_status_valid <= 1'b0;
            r_bhp_lfa_htf_status_bus <= '0;
         end
         if (bhp_htf_hdrinfo_valid || lfa_bhp_sof_valid)
           r_clear_hdrinfo <= 1'b0;
         else if (htf_bhp_status_valid && 
                  ((htf_bhp_status_bus.error != NO_ERRORS) || stbl_sz_err)
                  && !r_sof_blk && !rr_sof_blk)
           r_clear_hdrinfo <= 1'b1;
         
      end 
   end 
   
   assign bhp_lfa_htf_status_valid = (r_bhp_lfa_htf_status_valid && !bhp_lfa_status_valid && !bhp_lfa_stbl_sent);
   assign bhp_lfa_htf_status_bus = r_bhp_lfa_htf_status_bus;
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         chk_crc <= 0;
         set_xp9_crc_err <= 0;
         xp9_crc_out <= 0;
         xp9_frm_crc <= 0;
         
      end
      else begin
         if (r_lfa_bhp_dp_valid)
           xp9_crc_out <= xp9_tmp_crc;
         if ((cnt == 3) && (frm_st == BLK_HDR) && (r_sof_fmt == XP9) && r_lfa_bhp_dp_valid) begin
            chk_crc <= 1'b1;
            xp9_frm_crc <= r_lfa_bhp_dp_bus.data[63:32];
         end
         else
           chk_crc <= 1'b0;

         if (bhp_lfa_status_valid)
           set_xp9_crc_err <= 1'b0;
         else if (chk_crc) begin
            if (xp9_crc_in != ~xp9_frm_crc)
              set_xp9_crc_err <= 1'b1;
            else
              set_xp9_crc_err <= 1'b0;
         end
      end
   end
   
   always_comb
     begin
        xp9_sof = 1'b0;
        xp9_crc_data = 64'd0;
        xp9_crc_in = 32'd0;
        xp9_crc_bits = '0;
        if ((r_sof_fmt == XP9) && (frm_st == BLK_HDR)) begin
           xp9_sof = (cnt == 0) ? 1'b1 : 1'b0;
           xp9_crc_in = xp9_crc_out;
           xp9_crc_data = r_lfa_bhp_dp_bus.data;
           xp9_crc_bits = (cnt == 3) ? 7'd32 : 7'd64;
        end
     end 

   cr_xp10_decomp_fe_crc xp9_hdr (.clk (clk),
                                  .rst_n (rst_n),
                                  .sof (xp9_sof),
                                  .crc_in (xp9_crc_in),
                                  .data_in (xp9_crc_data),
                                  .data_sz (xp9_crc_bits),
                                  .crc_out (xp9_tmp_crc));
    
   nx_fifo #(.DEPTH (8), .WIDTH ($bits(fe_dp_bus_t)))
   bhp_fifo (.empty (bhp_fifo_empty),
            .full (),
             .used_slots (bhp_fifo_used),
             .free_slots (),
             .rdata (bhp_fifo_rbus),
             .clk (clk),
             .rst_n (rst_n),
             .wen (bhp_fifo_wr),
             .ren (bhp_fifo_rd),
             .clear (bhp_lfa_status_valid),
             .underflow (),
             .overflow (),
             .wdata (bhp_fifo_wbus));

   
   nx_fifo #(.DEPTH (8), .WIDTH ($bits(bhp_htf_hdr_dp_bus_t)))
   htf_fifo (.empty (htf_fifo_empty),
             .full (),
             .used_slots (htf_fifo_used),
             .free_slots (),
             .rdata (htf_fifo_rbus),
             .clk (clk),
             .rst_n (rst_n),
             .wen (htf_fifo_wr),
             .ren (htf_fifo_rd),
             .clear (bhp_htf_hdr_dp_bus.last && bhp_htf_hdr_dp_valid),
             .underflow (),
             .overflow (),
             .wdata (htf_fifo_wbus));

   assign bhp_fifo_wr = (frm_st != STBL_HDR) && lfa_bhp_dp_valid;
   assign bhp_fifo_wbus = lfa_bhp_dp_bus;
   assign bhp_lfa_dp_ready = (bhp_fifo_used < 4'b0110) && (htf_fifo_used < 4'b0110) 
                              && r_stbl_dp_ready && !send_hdr_info && !hold_mtf_valid && htf_bhp_hdrinfo_ready;

   assign bhp_fifo_rd = (!bhp_fifo_empty && !bhp_lfa_status_valid &&
                         !wait_for_bhp_ack);

   assign wait_for_bhp_ack = (((frm_st == FRM_DFLATE) || (frm_st == BLK_DFLATE) || deflate_status_valid) 
                             && !deflate_data_ready) ? 1'b1 : 1'b0;

   assign deflate_data_valid = ((frm_st == FRM_DFLATE) || (frm_st == BLK_DFLATE)) ?
                               r_lfa_bhp_dp_valid : 1'b0;
   
   assign deflate_data_in = r_lfa_bhp_dp_bus.data;
   assign deflate_data_sof = r_lfa_bhp_dp_bus.sof && (deflate_align_bits == 0);
   assign deflate_data_eof = r_lfa_bhp_dp_bus.eof && r_lfa_bhp_dp_valid;
   
   assign deflate_frm_fmt = (r_sof_fmt == GZIP) ? 1'b1 : 1'b0;

   assign htf_fifo_wr = ((frm_st == STBL_HDR) && (r_dp_valid) && r_stbl_dp_ready) ||
                         ((frm_st == IDLE) && set_stbl_last);
   assign htf_fifo_wbus.data = (r_dp_valid) ? r_dp_bus.data : '0;
   assign htf_fifo_wbus.last = set_stbl_last;
   assign htf_fifo_wbus.trace_bit = r_trace_bit;

   assign htf_fifo_rd = (!htf_fifo_empty && !wait_for_htf_ack) ? 1'b1 : 1'b0;
   assign bhp_htf_hdr_dp_valid = htf_fifo_rd || wait_for_htf_ack;
   
   assign bhp_htf_hdr_dp_bus.data = (htf_fifo_rd) ? htf_fifo_rbus.data :
                                    wait_for_htf_ack ? r_htf_fifo_rbus.data : '0;
   assign bhp_htf_hdr_dp_bus.last = (htf_fifo_rd) ? htf_fifo_rbus.last : 
                                    wait_for_htf_ack ? r_htf_fifo_rbus.last : 1'b0;
   assign bhp_htf_hdr_dp_bus.trace_bit = (htf_fifo_rd) ? htf_fifo_rbus.trace_bit : 
                                         wait_for_htf_ack ? r_htf_fifo_rbus.trace_bit : 1'b0;
   
   cr_xp10_decomp_fe_bhp_dflate dflate_hdr (                                    
                                            
                                            .deflate_status_valid(deflate_status_valid),
                                            .deflate_data_ready (deflate_data_ready),
                                            .deflate_fmt        (deflate_fmt),
                                            .deflate_bits_consumed(deflate_bits_consumed[12:0]),
                                            .deflate_errors     (deflate_errors),
                                            .deflate_blast      (deflate_blast),
                                            .deflate_len        (deflate_len[15:0]),
                                            
                                            .clk                (clk),
                                            .rst_n              (rst_n),
                                            .deflate_data_in    (deflate_data_in[63:0]),
                                            .deflate_data_sof   (deflate_data_sof),
                                            .deflate_data_eof   (deflate_data_eof),
                                            .deflate_data_valid (deflate_data_valid),
                                            .deflate_frm_fmt    (deflate_frm_fmt),
                                            .deflate_align_bits (deflate_align_bits));

   function logic [(`MAX_MTF_HDRS_SZ+$clog2(`MAX_MTF_HDRS_SZ)):0] get_mtf_header_and_numbits;
      input [`AXI_S_DP_DWIDTH*2-1:0]      mtf_word;
      input cmd_comp_mode_e               frm_fmt;
      
      logic [`MTF_EXP_SZ-1:0]             mtf_exp[4];
      logic [`MTF_HDR_SZ-1:0]             mtf_lsb[4];
      logic [$clog2(`MAX_MTF_HDRS_SZ)-1:0] cum_numbits;

      int                                  i;
      logic [((`AXI_S_DP_DWIDTH)+`AXI_S_DP_DWIDTH)-1:0] tmp_word;
      logic [((`AXI_S_DP_DWIDTH)+`AXI_S_DP_DWIDTH)-1:0] new_tmp_word;
      logic                                             is_mtf_last_ptr;
      
      begin
         if (frm_fmt == XP9) begin
            is_mtf_last_ptr = mtf_word[0];
            tmp_word = mtf_word >> 1;
            cum_numbits = 1;
         end
         else begin
            tmp_word = mtf_word;
            cum_numbits = '0;
            is_mtf_last_ptr = 1'b0;
         end
         for (i=0; i < 4; i=i+1) begin
            mtf_exp[i] = tmp_word[`MTF_EXP_SZ-1:0];
            new_tmp_word = tmp_word >> `MTF_EXP_SZ;
            mtf_lsb[i] = get_mtf_lsb(new_tmp_word, mtf_exp[i]);
            tmp_word = new_tmp_word >> mtf_exp[i];
            cum_numbits = cum_numbits + mtf_exp[i] + `MTF_EXP_SZ; 
         end
         get_mtf_header_and_numbits = {mtf_exp[0], mtf_lsb[0],
                                       mtf_exp[1], mtf_lsb[1],
                                       mtf_exp[2], mtf_lsb[2],
                                       mtf_exp[3], mtf_lsb[3],
                                       cum_numbits, is_mtf_last_ptr};
      end
   endfunction 

   function logic [`MTF_HDR_SZ-1:0] get_mtf_lsb;
      input [((`AXI_S_DP_DWIDTH/2)+`AXI_S_DP_DWIDTH)-1:0] new_tmp_word;
      input [`MTF_EXP_SZ-1:0]                             mtf_exp;
      logic [`MTF_HDR_SZ-1:0]                             lsb_word;
      
      begin
         case (mtf_exp) 
            5'd0 : lsb_word = 16'b0;
            5'd1 : lsb_word = {15'b0, new_tmp_word[0]};
            5'd2 : lsb_word = {14'b0, new_tmp_word[1:0]};
            5'd3 : lsb_word = {13'b0, new_tmp_word[2:0]};
            5'd4 : lsb_word = {12'b0, new_tmp_word[3:0]};
            5'd5 : lsb_word = {11'b0, new_tmp_word[4:0]};
            5'd6 : lsb_word = {10'b0, new_tmp_word[5:0]};
            5'd7 : lsb_word = {9'b0, new_tmp_word[6:0]};
            5'd8 : lsb_word = {8'b0, new_tmp_word[7:0]};
            5'd9 : lsb_word = {7'b0, new_tmp_word[8:0]};
            5'd10 : lsb_word = {6'b0, new_tmp_word[9:0]};
            5'd11 : lsb_word = {5'b0, new_tmp_word[10:0]};
            5'd12 : lsb_word = {4'b0, new_tmp_word[11:0]};
            5'd13 : lsb_word = {3'b0, new_tmp_word[12:0]};
            5'd14 : lsb_word = {2'b0, new_tmp_word[13:0]};
            5'd15 : lsb_word = {1'b0, new_tmp_word[14:0]};
            5'd16 : lsb_word = {new_tmp_word[15:0]};
            default : lsb_word = 16'b0;
         endcase
         get_mtf_lsb = lsb_word;
      end
   endfunction 

   
   always_comb
     begin
        xp9_blk = 1'b0;
        xp10_blk = 1'b0;
        xp10_raw_blk = 1'b0;
        gzip_blk = 1'b0;
        gzip_raw_blk = 1'b0;
        zlib_blk = 1'b0;
        zlib_raw_blk =1 'b0;
        chu4k_blk = 1'b0;
        chu4k_raw_blk = 1'b0;
        chu8k_blk = 1'b0;
        chu8k_raw_blk = 1'b0;
        xp9_crc_err = 1'b0;
        
        if (send_chu_raw && r_trace_bit) begin
           if (r_sof_fmt == CHU4K)
             chu4k_raw_blk = 1'b1;
           else
             chu8k_raw_blk = 1'b1;
        end
        else if (send_xp10_raw && r_trace_bit) begin
           xp10_raw_blk = 1'b1;
        end
        else if (send_deflate_raw && r_trace_bit) begin
           if (r_sof_fmt == ZLIB)
             zlib_raw_blk = 1'b1;
           else
             gzip_raw_blk = 1'b1;
        end
        if (send_hdr_info && r_trace_bit) begin
           if (r_sof_fmt == XP9)
             xp9_blk = 1'b1;
           else if (r_sof_fmt == XP10)
             xp10_blk = 1'b1;
           else if (r_sof_fmt == ZLIB)
             zlib_blk = 1'b1;
           else if (r_sof_fmt ==  GZIP)
             gzip_blk = 1'b1;
           else if (r_sof_fmt == CHU4K)
             chu4k_blk = 1'b1;
           else if (r_sof_fmt == CHU8K)
             chu8k_blk = 1'b1;
        end 
        
        if (bhp_lfa_status_valid && set_xp9_crc_err && r_trace_bit)
          xp9_crc_err = 1'b1;
        
        
     end 
        
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         chu4k_raw_stb <= 0;
         chu8k_raw_stb <= 0;
         gzip_blk_stb <= 0;
         gzip_raw_blk_stb <= 0;
         xp10_blk_stb <= 0;
         xp10_raw_blk_stb <= 0;
         xp9_blk_stb <= 0;
         xp9_crc_err_stb <= 0;
         zlib_blk_stb <= 0;
         zlib_raw_blk_stb <= 0;
         
      end
      else  begin
         xp9_blk_stb <= xp9_blk;
         xp10_blk_stb <= xp10_blk;
         xp10_raw_blk_stb <= xp10_raw_blk;
         zlib_blk_stb <= zlib_blk;
         zlib_raw_blk_stb <= zlib_raw_blk;
         gzip_blk_stb <= gzip_blk;
         gzip_raw_blk_stb <= gzip_raw_blk;
         xp9_crc_err_stb <= xp9_crc_err;
         chu4k_raw_stb <= chu4k_raw_blk;
         chu8k_raw_stb <= chu8k_raw_blk;
      end
   end

   assign hdrinfo_fifo_rd = !hdrinfo_fifo_empty &&
                            (!wait_for_htf_status ||
                             (wait_for_htf_status && htf_bhp_status_valid));

   assign bhp_htf_hdrinfo_valid = hdrinfo_fifo_rd;

   assign hdrinfo_fifo_wdata = int_bhp_htf_hdrinfo_bus;
   assign hdrinfo_fifo_wr = int_bhp_htf_hdrinfo_valid;
   assign clear_hdrinfo = (htf_bhp_status_valid && !hdrinfo_sof_blk &&
                           !no_htf_errors);
   always_comb
     begin
        bhp_htf_hdrinfo_bus = hdrinfo_fifo_rdata;
        if (clear_hdrinfo || r_clear_hdrinfo)
          bhp_htf_hdrinfo_bus.fmt = HTF_FMT_RAW;
     end
        
   
   nx_fifo #(.DEPTH (2), .WIDTH ($bits(bhp_htf_hdrinfo_bus_t)))
   hdrinfo_fifo (.empty (hdrinfo_fifo_empty),
            .full (),
             .used_slots (),
             .free_slots (),
             .rdata (hdrinfo_fifo_rdata),
             .clk (clk),
             .rst_n (rst_n),
             .wen (hdrinfo_fifo_wr),
             .ren (hdrinfo_fifo_rd),
             .clear (1'b0),
             .underflow (),
             .overflow (),
             .wdata (hdrinfo_fifo_wdata));
   
   
   hdrinfo_valid_rdy : assert property (@(posedge clk)
             (bhp_htf_hdrinfo_valid |-> htf_bhp_hdrinfo_ready))
     else
       `ERROR("htf_bhp_hdrinfo_ready should never be de-asserted!");

   
   
endmodule 







