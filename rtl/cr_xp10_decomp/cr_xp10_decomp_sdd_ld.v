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
`include "messages.vh"

module cr_xp10_decomp_sdd_ld (
   
   lanes_wf_ready, decoder_sob_credit_used, decoder_eob_credit_used,
   ld_ss_valid, ld_ss_data, ld_bit_buf, buf_full_stall_stb,
   
   clk, rst_n, wf_lanes_valid, wf_lanes_data, wf_lanes_numbits,
   wf_lanes_sob, wf_lanes_eob, wf_lanes_eof, wf_lanes_trace_bit,
   wf_lanes_frame_bytes_in, wf_lanes_last_frame, wf_lanes_errcode,
   ss_bct, ss_bct_valid, ss_sat, ss_slt, ss_used_symbols, ll_bct,
   ll_bct_valid, ll_sat, ll_slt, ll_used_symbols, block_fmt,
   block_min_ptr_len, block_min_mtf_len, block_error,
   decoder_sob_credit_avail, ss_ld_ready, sp_buf_idx
   );

   import crPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;

   
   
   
   input         clk;
   input         rst_n; 
   
   
   
   
   input         wf_lanes_valid;
   input [127:0] wf_lanes_data;
   input [7:0]   wf_lanes_numbits;
   input         wf_lanes_sob;
   input         wf_lanes_eob;
   input         wf_lanes_eof;
   input         wf_lanes_trace_bit;
   input [27:0]  wf_lanes_frame_bytes_in;
   input         wf_lanes_last_frame;
   input zipline_error_e   wf_lanes_errcode;
   output logic  lanes_wf_ready;
   
   
   
   
   input [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`BIT_VEC(`N_MAX_HUFF_BITS-1)] ss_bct;
   input [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)]                                ss_bct_valid;
   input [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)]   ss_sat;
   input [1:0][`BIT_VEC(`N_XP10_64K_SHRT_SYMBOLS)][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)]           ss_slt;
   input [1:0][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS+1)]                                             ss_used_symbols;

   input [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`BIT_VEC(`N_MAX_HUFF_BITS-1)]       ll_bct;
   input [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)]                                ll_bct_valid;
   input [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)]   ll_sat;
   input [1:0][`BIT_VEC(`N_XP10_64K_LONG_SYMBOLS)][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)]   ll_slt;
   input [1:0][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS+1)]                                     ll_used_symbols;

   input htf_fmt_e [1:0] block_fmt;
   input [1:0] block_min_ptr_len;
   input [1:0] block_min_mtf_len;
   input [1:0] block_error;
   

   input decoder_sob_credit_avail;
   output logic decoder_sob_credit_used;
   output logic decoder_eob_credit_used;

   
   
   
   output logic ld_ss_valid;
   output       sdd_ld_pipe_t ld_ss_data;
   input        ss_ld_ready;


   
   
   
   output logic [`BIT_VEC(N_SDD_BIT_BUF_WORDS)][31:0] ld_bit_buf;
   input [`BIT_VEC($clog2(N_SDD_BIT_BUF_WORDS)+1)]    sp_buf_idx;

   output logic                                       buf_full_stall_stb;

   

   
   
   
`define DECLARE_RESET_FLOP(name, reset_val) \
   r_``name, c_``name; \
   always_ff@(posedge clk or negedge rst_n)    \
     if (!rst_n) \
       r_``name <= reset_val; \
     else \
       r_``name <= c_``name
`define DECLARE_FLOP(name) \
   r_``name, c_``name; \
   always_ff@(posedge clk) r_``name <= c_``name 
`define DEFAULT_FLOP(name) c_``name = r_``name
`define DECLARE_RESET_OUT_FLOP(name, reset_val) \
   `DECLARE_RESET_FLOP(name, reset_val); \
   assign name = r_``name

   `DECLARE_HUFFMAN_DECODER_LENGTH(short_hufd_length, `N_MAX_XP_HUFF_BITS, `N_XP10_64K_SHRT_SYMBOLS)
   `DECLARE_HUFFMAN_DECODER_SYMBOL(short_hufd_symbol, `N_XP10_64K_SHRT_SYMBOLS)
   `DECLARE_HUFFMAN_DECODER_LENGTH(long_hufd_length, `N_MAX_XP_HUFF_BITS, `N_XP10_64K_LONG_SYMBOLS)
   `DECLARE_HUFFMAN_DECODER_SYMBOL(long_hufd_symbol, `N_XP10_64K_LONG_SYMBOLS)

   localparam PRE_DECODE_STAGES = 7;

   logic         `DECLARE_RESET_FLOP(s0_table_bank, 1);
   logic [`BIT_VEC($clog2(N_SDD_BIT_BUF_WORDS)+1)] `DECLARE_RESET_FLOP(s1_buf_idx, 0);
   logic [2:0]                           `DECLARE_RESET_FLOP(s2_word_mod_8, 0);        
   logic                                 `DECLARE_RESET_FLOP(s2_credited_eob, 0);
   logic                                 `DECLARE_RESET_OUT_FLOP(buf_full_stall_stb, 0);

   logic [PRE_DECODE_STAGES:1]            pipe_src_valid;
   logic [PRE_DECODE_STAGES:1] pipe_src_ready;
   sdd_ld_pipe_t    pipe_src_data[PRE_DECODE_STAGES:1];

   logic [PRE_DECODE_STAGES:1] pipe_dst_valid;
   logic [PRE_DECODE_STAGES:1] pipe_dst_ready;
   sdd_ld_pipe_t    pipe_dst_data[PRE_DECODE_STAGES:1];

   logic [`BIT_VEC(N_SDD_BIT_BUF_WORDS)][31:0] `DECLARE_FLOP(bit_buf);
   assign ld_bit_buf = r_bit_buf;

   logic                                                                          cover_tables;
   logic [`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`BIT_VEC(`N_MAX_HUFF_BITS-1)]       v_ss_bct;
   logic [`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)]                                     v_ss_bct_valid;
   logic [`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] v_ss_sat;
   logic [`BIT_VEC(`N_XP10_64K_SHRT_SYMBOLS)][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] v_ss_slt;
   logic [`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS+1)]                                   v_ss_used_symbols;

   logic [`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`BIT_VEC(`N_MAX_HUFF_BITS-1)]       v_ll_bct;
   logic [`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)]                                     v_ll_bct_valid;
   logic [`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)] v_ll_sat;
   logic [`BIT_VEC(`N_XP10_64K_LONG_SYMBOLS)][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)] v_ll_slt;
   logic [`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS+1)]                                   v_ll_used_symbols;

   genvar                                                                         ii;
   generate
      for (ii=1; ii<=`N_MAX_HUFF_BITS; ii++) begin
         
         `COVER_PROPERTY(cover_tables |-> v_ss_bct_valid[ii]);
         `COVER_PROPERTY(cover_tables |-> v_ll_bct_valid[ii]);
      end
      for (ii=2; ii<=`N_MAX_HUFF_BITS; ii++)  begin
         
         `COVER_PROPERTY(cover_tables |-> v_ss_bct[ii][ii-2]); 
         `COVER_PROPERTY(cover_tables |-> v_ll_bct[ii][ii-2]);
      end
   endgenerate

   always_comb begin
      integer N;
      logic                                                                          v_block_error;
      logic                                                                          v_ll_bct_valid_is_0;
      logic                                                                          v_fmt_raw;
      logic                                                                          v_fmt_deflate;
      logic                                                                          v_fmt_xp;
      
      `DEFAULT_FLOP(s0_table_bank);
      `DEFAULT_FLOP(s1_buf_idx);
      `DEFAULT_FLOP(s2_word_mod_8);
      `DEFAULT_FLOP(s2_credited_eob);
      `DEFAULT_FLOP(bit_buf);

      c_buf_full_stall_stb = 0;

      
      
      
      
      

      

      N = 1;

      pipe_src_data[N] = '0;
      pipe_src_data[N].meta.data = wf_lanes_data;
      pipe_src_data[N].meta.numbits = wf_lanes_numbits;
      pipe_src_data[N].meta.sob = wf_lanes_sob;
      pipe_src_data[N].meta.eob = wf_lanes_eob;
      pipe_src_data[N].meta.eof = wf_lanes_eof;
      pipe_src_data[N].meta.errcode = wf_lanes_errcode;
      pipe_src_data[N].meta.trace_bit = wf_lanes_trace_bit;
      pipe_src_data[N].meta.frame_bytes_in = wf_lanes_frame_bytes_in;
      pipe_src_data[N].meta.last_frame = wf_lanes_last_frame;

      pipe_src_valid[N] = 0;
      lanes_wf_ready = 0;
      decoder_sob_credit_used = 0;
      if (wf_lanes_valid && (!wf_lanes_sob || decoder_sob_credit_avail)) begin
         pipe_src_valid[N] = 1;
         if (pipe_src_ready[N]) begin
            lanes_wf_ready = 1;
            decoder_sob_credit_used = wf_lanes_sob;
            c_s0_table_bank ^= wf_lanes_sob; 
         end 
         pipe_src_data[N].meta.table_bank = c_s0_table_bank;
         pipe_src_data[N].meta.fmt = block_fmt[c_s0_table_bank];
         pipe_src_data[N].meta.min_ptr_len = block_min_ptr_len[c_s0_table_bank];
         pipe_src_data[N].meta.min_mtf_len = block_min_mtf_len[c_s0_table_bank];

      end 

      v_block_error = block_error[c_s0_table_bank];
      for (int i=0; i<32; i++) begin
         pipe_src_data[N].lane_state[i].sdd_errcode = ILLEGAL_HUFFTREE;
         pipe_src_data[N].lane_state[i].error = v_block_error;
      end


      
      for (int i=2; i<=PRE_DECODE_STAGES; i++) begin
         pipe_src_data[i] = pipe_dst_data[i-1];
         pipe_src_valid[i] = pipe_dst_valid[i-1];
         pipe_dst_ready[i-1] = pipe_src_ready[i];
      end
      pipe_dst_ready[PRE_DECODE_STAGES] = ss_ld_ready;

      
      
      
      
      
      N = 2;

`define IDX_CONVERT(idx) (idx[`BIT_VEC($bits(idx)-1)] + (idx[$bits(idx)-1]?N_SDD_BIT_BUF_WORDS:0))
      if (pipe_src_valid[N]) begin
         
         
         
         integer v_bias;
         if (r_s1_buf_idx < sp_buf_idx)
           v_bias = N_SDD_BIT_BUF_WORDS*2;
         else
           v_bias = 0;
            
         if ((`IDX_CONVERT(r_s1_buf_idx) + 4 + v_bias - `IDX_CONVERT(sp_buf_idx)) > N_SDD_BIT_BUF_WORDS) begin
               pipe_src_valid[N] = 0;
               pipe_dst_ready[N-1] = 0;
               c_buf_full_stall_stb = 1;
         end
      end
`undef IDX_CONVERT

   
      pipe_src_data[N].meta.buf_idx = r_s1_buf_idx;
      
      v_ss_bct = ss_bct[pipe_src_data[N].meta.table_bank];
      v_ss_bct_valid = ss_bct_valid[pipe_src_data[N].meta.table_bank];
      v_ss_sat = ss_sat[pipe_src_data[N].meta.table_bank];
      v_ll_bct = ll_bct[pipe_src_data[N].meta.table_bank];
      v_ll_bct_valid = ll_bct_valid[pipe_src_data[N].meta.table_bank];
      v_ll_sat = ll_sat[pipe_src_data[N].meta.table_bank];

      cover_tables = 0;
      if (pipe_src_valid[N] && pipe_src_ready[N]) begin
         logic [`LOG_VEC(N_SDD_BIT_BUF_WORDS)] v_s1_buf_idx;
         logic [`BIT_VEC(N_SDD_BIT_BUF_WORDS*2)][31:0] v_bit_buf; 
         
         
         
         
         v_s1_buf_idx = r_s1_buf_idx[`LOG_VEC(N_SDD_BIT_BUF_WORDS)];
         v_bit_buf = {2{r_bit_buf}};
         v_bit_buf[v_s1_buf_idx +: 4] = pipe_src_data[N].meta.data; 
         v_bit_buf[v_s1_buf_idx+N_SDD_BIT_BUF_WORDS +: 4] = pipe_src_data[N].meta.data; 
         c_bit_buf = v_bit_buf[N_SDD_BIT_BUF_WORDS +: N_SDD_BIT_BUF_WORDS];
         if (v_s1_buf_idx == (N_SDD_BIT_BUF_WORDS-1)) begin
            c_s1_buf_idx = 0;
            c_s1_buf_idx[$bits(c_s1_buf_idx)-1] = ~r_s1_buf_idx[$bits(c_s1_buf_idx)-1];
         end
         else
           c_s1_buf_idx = r_s1_buf_idx + 1;

         cover_tables = 1;
      end

      v_fmt_raw = pipe_src_data[N].meta.fmt == HTF_FMT_RAW;
      for (int i=0; i<32; i++) begin
         short_hufd_length(pipe_src_data[N].meta.data[i +: `N_MAX_XP_HUFF_BITS], 
                           v_ss_bct,
                           v_ss_bct_valid,
                           v_ss_sat,
                           pipe_src_data[N].lane_state[i].ss_length, 
                           pipe_src_data[N].lane_state[i].ss_base_offset, 
                           pipe_src_data[N].lane_state[i].ss_sat_entry);
         
         long_hufd_length(pipe_src_data[N].meta.data[i +: `N_MAX_XP_HUFF_BITS],
                          v_ll_bct,
                          v_ll_bct_valid,
                          v_ll_sat,
                          pipe_src_data[N].lane_state[i].ll_length,
                          pipe_src_data[N].lane_state[i].ll_base_offset,
                          pipe_src_data[N].lane_state[i].ll_sat_entry);

         if (v_fmt_raw) begin
            
            
            pipe_src_data[N].lane_state[i].ss_base_offset[7:0] = pipe_src_data[N].meta.data[i +: 8];
         end
      end 

      
      
      
      
      
      N = 3;

      pipe_src_data[N].meta.word_mod_8 = r_s2_word_mod_8;
      
      if (pipe_src_valid[N] && pipe_src_ready[N]) begin
         if (pipe_src_data[N].meta.sob) begin
            pipe_src_data[N].meta.word_mod_8 = 0;
            c_s2_word_mod_8 = 0;
         end
         c_s2_word_mod_8++;
      end

      decoder_eob_credit_used = 0;
      if (pipe_src_valid[N] && pipe_src_ready[N]) begin
         if (pipe_src_data[N].meta.sob)
           c_s2_credited_eob = 0;

         if (pipe_src_data[N].meta.eob) begin
            if (!c_s2_credited_eob &&
                (pipe_src_data[N].meta.numbits <= 32)) begin
               
               
               decoder_eob_credit_used = 1;
               c_s2_credited_eob = 1;
            end
         end
      end 

      v_ss_slt = ss_slt[pipe_src_data[N].meta.table_bank];
      v_ss_used_symbols = ss_used_symbols[pipe_src_data[N].meta.table_bank];
      v_ll_slt = ll_slt[pipe_src_data[N].meta.table_bank];
      v_ll_used_symbols = ll_used_symbols[pipe_src_data[N].meta.table_bank];
      v_ll_bct_valid_is_0 = ll_bct_valid[pipe_src_data[N].meta.table_bank] == 0;

      v_fmt_raw = pipe_src_data[N].meta.fmt == HTF_FMT_RAW;
      for (int i=0; i<32; i++) begin
         logic v_ss_error;
         
         short_hufd_symbol(pipe_src_data[N].lane_state[i].ss_base_offset,
                           pipe_src_data[N].lane_state[i].ss_sat_entry,
                           v_ss_slt,
                           v_ss_used_symbols,
                           pipe_src_data[N].lane_state[i].ss_sym,
                           v_ss_error);

         long_hufd_symbol(pipe_src_data[N].lane_state[i].ll_base_offset,
                           pipe_src_data[N].lane_state[i].ll_sat_entry,
                           v_ll_slt,
                           v_ll_used_symbols,
                           pipe_src_data[N].lane_state[i].ll_sym,
                           pipe_src_data[N].lane_state[i].ll_error);

         if (v_ss_error) begin
            if (!pipe_src_data[N].lane_state[i].error)
              pipe_src_data[N].lane_state[i].sdd_errcode = INVALID_SYMBOL;
            pipe_src_data[N].lane_state[i].error = 1;
         end

         if (v_ll_bct_valid_is_0)
           pipe_src_data[N].lane_state[i].ll_error = 1;

         pipe_src_data[N].lane_state[i].aggregate_length = 7'(pipe_src_data[N].lane_state[i].ss_length); 
         

         if (v_fmt_raw) begin
            
            
            
            
            pipe_src_data[N].lane_state[i].ss_sym = 8'(pipe_src_data[N].lane_state[i].ss_base_offset[7:0]); 
            pipe_src_data[N].lane_state[i].ss_length = 8;
            pipe_src_data[N].lane_state[i].aggregate_length = 8;
            
            pipe_src_data[N].lane_state[i].error = 0;
         end 
      end 

      
      
      
      
      
      
      N = 4;

      v_fmt_deflate = pipe_src_data[N].meta.fmt inside {HTF_FMT_DEFLATE_DYNAMIC, HTF_FMT_DEFLATE_FIXED};
      for (int i=0; i<32; i++) begin
         if (pipe_src_data[N].lane_state[i].ss_sym > 256) begin
            if (v_fmt_deflate) begin
               pipe_src_data[N].lane_state[i].ll_exists = 1;
               pipe_src_data[N].lane_state[i].aggregate_length += HLIT_EXTRA_BITS[pipe_src_data[N].lane_state[i].ss_sym[4:0]]; 
            end
            else begin
               
               
               if (pipe_src_data[N].lane_state[i].ss_sym[3:0] == 4'hf)
                 pipe_src_data[N].lane_state[i].ll_exists = 1;
            end
         end

      end 

      
      
      N = 5;

      if (pipe_src_valid[N]) begin
         
         if ((pipe_src_data[N].meta.numbits > 32) && !pipe_src_valid[N-1])  begin
            pipe_src_valid[N] = 0;
            pipe_dst_ready[N-1] = 0;
         end
      end

      begin
         
         
         
         
         
         
         
         
         sdd_ld_lane_state_t [63:0] v_lane_state_arr;
         v_lane_state_arr = {pipe_src_data[N-1].lane_state, pipe_src_data[N].lane_state};
         
         v_lane_state_arr >>= $bits(sdd_ld_lane_state_t); 
         for (int i=0; i<32; i++) begin
            sdd_ld_lane_state_t [27:1] v_local_lane_state_arr;
            sdd_ld_lane_state_t v_lane_state; 

            
            v_local_lane_state_arr = v_lane_state_arr;
            v_lane_state = v_local_lane_state_arr[pipe_src_data[N].lane_state[i].aggregate_length[4:0]]; 
            
            pipe_src_data[N].lane_state[i].ll_sym = v_lane_state.ll_sym;
            pipe_src_data[N].lane_state[i].ll_length = v_lane_state.ll_length;
            pipe_src_data[N].lane_state[i].ll_error = v_lane_state.ll_error;

            v_lane_state_arr >>= $bits(sdd_ld_lane_state_t); 
         end 
      end
         

      
      
      
      
      
      N = 6;

      v_fmt_deflate = pipe_src_data[N].meta.fmt inside {HTF_FMT_DEFLATE_DYNAMIC, HTF_FMT_DEFLATE_FIXED};
      v_fmt_xp = pipe_src_data[N].meta.fmt inside {HTF_FMT_XP9, HTF_FMT_XP10};
      for (int i=0; i<32; i++) begin
         logic [5:0] v_extra_add_term_0;
         logic [4:0] v_extra_sub_term_0;
         logic [7:0] v_extra_add_term_1;
         logic [7:0] v_extra_sub_term_1;
         logic [`LOG_VEC(`N_MAX_HUFF_BITS+1)] v_ll_length;       

         v_extra_add_term_0 = 0;
         v_extra_sub_term_0 = 0;
         v_extra_add_term_1 = 0;
         v_extra_sub_term_1 = 0;

         if (v_fmt_xp) begin
            if (pipe_src_data[N].lane_state[i].ss_sym > 319) begin
               v_extra_add_term_0 = pipe_src_data[N].lane_state[i].ss_sym[9:4];
               v_extra_sub_term_0 = 20;
            end
            if (pipe_src_data[N].lane_state[i].ll_exists && (pipe_src_data[N].lane_state[i].ll_sym > 231)) begin
               v_extra_add_term_1 = pipe_src_data[N].lane_state[i].ll_sym;
               v_extra_sub_term_1 = 232;
            end
         end
         else if (pipe_src_data[N].lane_state[i].ll_exists && v_fmt_deflate)
           v_extra_add_term_0 = HDIST_EXTRA_BITS[pipe_src_data[N].lane_state[i].ll_sym[4:0]];

         if (pipe_src_data[N].lane_state[i].ll_exists)
           v_ll_length = pipe_src_data[N].lane_state[i].ll_length;
         else
           v_ll_length = 0;


         pipe_src_data[N].lane_state[i].aggregate_length += v_extra_add_term_0 - v_extra_sub_term_0 + v_extra_add_term_1 - v_extra_sub_term_1 + v_ll_length; 

         
         if (pipe_src_data[N].lane_state[i].ll_exists && !pipe_src_data[N].lane_state[i].error) begin
            pipe_src_data[N].lane_state[i].error = pipe_src_data[N].lane_state[i].ll_error; 
            pipe_src_data[N].lane_state[i].sdd_errcode = INVALID_SYMBOL;
         end
      end 

      
      

      N = 7;

      v_fmt_deflate = pipe_src_data[N].meta.fmt inside {HTF_FMT_DEFLATE_DYNAMIC, HTF_FMT_DEFLATE_FIXED};
      for (int i=0; i<32; i++) begin
         logic v_eob_sym;

         if (pipe_src_data[N].lane_state[i].ss_sym == 256)
           v_eob_sym = 1;
         else 
           v_eob_sym = 0;
         
         
         if (8'(pipe_src_data[N].lane_state[i].aggregate_length + i) > pipe_src_data[N].meta.numbits) begin
            if (!pipe_src_data[N].lane_state[i].error)
              pipe_src_data[N].lane_state[i].sdd_errcode = END_MISMATCH;
            pipe_src_data[N].lane_state[i].error = 1;
         end
         if (8'(pipe_src_data[N].lane_state[i].aggregate_length + i) == pipe_src_data[N].meta.numbits)
           pipe_src_data[N].lane_state[i].eob = pipe_src_data[N].meta.eob; 

         if (pipe_src_data[N].lane_state[i].eob &&
             (v_fmt_deflate) &&
             !v_eob_sym) begin
            if (!pipe_src_data[N].lane_state[i].error)
              pipe_src_data[N].lane_state[i].sdd_errcode = MISSING_EOB_SYM;
            pipe_src_data[N].lane_state[i].error = 1;
         end

         if (pipe_src_data[N].lane_state[i].ss_sym < 256)
           pipe_src_data[N].lane_state[i].symbol_type = LITERAL;
         else if (v_eob_sym && v_fmt_deflate) begin
            pipe_src_data[N].lane_state[i].symbol_type = EOB;
            pipe_src_data[N].lane_state[i].eob = 1;
         end
         else
           pipe_src_data[N].lane_state[i].symbol_type = MATCH;

         
         pipe_src_data[N].lane_state[i].eob |= pipe_src_data[N].lane_state[i].error; 

         pipe_src_data[N].lane_state[i].end_idx = (pipe_src_data[N].meta.word_mod_8 << 5) + i + pipe_src_data[N].lane_state[i].aggregate_length; 

         
         if (pipe_src_data[N].lane_state[i].eob && (pipe_src_data[N].lane_state[i].end_idx[4:0] != 0)) begin
            pipe_src_data[N].lane_state[i].end_idx = (pipe_src_data[N].lane_state[i].end_idx[7:5] + 1) << 5; 
         end
      end 
   end 

   assign ld_ss_valid = pipe_dst_valid[PRE_DECODE_STAGES];
   assign ld_ss_data = pipe_dst_data[PRE_DECODE_STAGES];

   
   
   
   

   
   localparam int HNDSHK_MODE[1:PRE_DECODE_STAGES] = '{`AXI_RS_FWD, `AXI_RS_FWD, `AXI_RS_FULL, `AXI_RS_FWD, `AXI_RS_FWD, `AXI_RS_FWD, `AXI_RS_FULL}; 

   generate

      for (ii=1; ii<=PRE_DECODE_STAGES; ii++) begin : reg_slices
         axi_channel_reg_slice
              #(.PAYLD_WIDTH($bits(sdd_ld_pipe_t)),
                .HNDSHK_MODE(HNDSHK_MODE[ii]))
         u_reg_slice
              (.aclk (clk),
               .aresetn (rst_n),
               .valid_src (pipe_src_valid[ii]), 
               .ready_src (pipe_src_ready[ii]),
               .payload_src (pipe_src_data[ii]),
               .valid_dst (pipe_dst_valid[ii]),
               .ready_dst (pipe_dst_ready[ii]),
               .payload_dst (pipe_dst_data[ii]));
      end 

   endgenerate

`undef DECLARE_RESET_FLOP
`undef DECLARE_FLOP
`undef DEFAULT_FLOP   

endmodule 








