/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"
`include "messages.vh"

module cr_xp10_decomp_htf_symtab_dec_pipeline_UNUSED (
   
   htf_bhp_hdrinfo_ready, htf_bhp_status_valid, htf_bhp_status_bus,
   hdr_bits_ready, hdr_clear, predef_bl_req_valid, predef_bl_req_ll,
   predef_bl_rsp_bits_ready, predef_bl_done, blt_hist_wen,
   blt_hist_wdata, blt_hist_complete_valid, blt_hist_complete_fmt,
   blt_hist_complete_min_ptr_len, blt_hist_complete_min_mtf_len,
   blt_hist_complete_error,
   
   clk, rst_n, bhp_htf_hdrinfo_valid, bhp_htf_hdrinfo_bus,
   bhp_htf_status_ready, hdr_bits_valid, hdr_bits_data, hdr_bits_last,
   hdr_bits_err, predef_bl_req_ready, predef_bl_req_error,
   predef_bl_rsp_bits_valid, predef_bl_rsp_bits_data,
   predef_bl_rsp_bits_err, blt_hist_busy
   );

   parameter DP_WIDTH = 64;
   parameter BL_PER_CYCLE = 2;
   parameter NUM_PREDEF_SS_BL = `N_XP10_64K_SHRT_SYMBOLS;
   parameter NUM_PREDEF_LL_BL = `N_XP10_64K_LONG_SYMBOLS;
   parameter SMALL_BL_PER_CYCLE = 2;

   localparam XP_BL_WIDTH = $clog2(`N_MAX_XP_HUFF_BITS);

   import crPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;

`ifndef SYNTHESIS
   initial begin
      if (XP_BL_WIDTH*BL_PER_CYCLE > DP_WIDTH)
        `FATAL("can't sustain %0d pre-defined bit-lengths per cycle with %0d-bit data path", XP_BL_WIDTH, DP_WIDTH);
      if (NUM_PREDEF_LL_BL%BL_PER_CYCLE != 0)
        `FATAL("can't handle NUM_PREDEF_LL_BL=%0d that is not a multiple of BL_PER_CYCLE=%0d", NUM_PREDEF_LL_BL, BL_PER_CYCLE);
      if (NUM_PREDEF_SS_BL%BL_PER_CYCLE != 0)
        `FATAL("can't handle NUM_PREDEF_SS_BL=%0d that is not a multiple of BL_PER_CYCLE=%0d", NUM_PREDEF_SS_BL, BL_PER_CYCLE);
   end
`endif
   
   
   
   
   input         clk;
   input         rst_n;

   
   
   
   input logic   bhp_htf_hdrinfo_valid;
   input         bhp_htf_hdrinfo_bus_t bhp_htf_hdrinfo_bus;
   output logic  htf_bhp_hdrinfo_ready;
   
   
   
   
   output logic  htf_bhp_status_valid;
   output        htf_bhp_status_bus_t htf_bhp_status_bus;
   input logic   bhp_htf_status_ready;

   
   
   
   input [`LOG_VEC(DP_WIDTH+1)]        hdr_bits_valid;
   input [`BIT_VEC(DP_WIDTH)]          hdr_bits_data;
   input                               hdr_bits_last;
   input                               hdr_bits_err;
   output logic [`LOG_VEC(DP_WIDTH+1)] hdr_bits_ready;

   output logic                        hdr_clear;   

   
   
   
   output logic  predef_bl_req_valid; 
   output logic  predef_bl_req_ll; 
                                   
   input         predef_bl_req_ready;
   input         predef_bl_req_error;
   
   input [`LOG_VEC(DP_WIDTH+1)]        predef_bl_rsp_bits_valid;
   input [`BIT_VEC(DP_WIDTH)]          predef_bl_rsp_bits_data;
   input                               predef_bl_rsp_bits_err;
   output logic [`LOG_VEC(DP_WIDTH+1)] predef_bl_rsp_bits_ready;

   output logic  predef_bl_done; 

   
   
   
   
   
   
   
   output logic [`LOG_VEC(BL_PER_CYCLE+1)] blt_hist_wen;
   output logic [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(`N_MAX_HUFF_BITS+1)] blt_hist_wdata;

   
   
   
   
   
   output logic                              blt_hist_complete_valid;
   output                                    htf_fmt_e blt_hist_complete_fmt;
   output logic                              blt_hist_complete_min_ptr_len;
   output logic                              blt_hist_complete_min_mtf_len;
   output logic                              blt_hist_complete_error;

   
   input                                     blt_hist_busy;
   
   
   
   
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


   logic [`BIT_VEC_BASE(`N_MAX_SMALL_HUFF_BITS,1)][`BIT_VEC(`N_MAX_SMALL_HUFF_BITS-1)] small_bct;
   logic [`BIT_VEC_BASE(`N_MAX_SMALL_HUFF_BITS,1)]                                     small_bct_valid;
   logic [`BIT_VEC_BASE(`N_MAX_SMALL_HUFF_BITS,1)][`LOG_VEC(`N_SMALL_SYMBOLS)]         small_sat;
   logic [`BIT_VEC(`N_SMALL_SYMBOLS)][`LOG_VEC(`N_SMALL_SYMBOLS)]                      small_slt;
   logic [`LOG_VEC(`N_SMALL_SYMBOLS+1)]                                                small_used_symbols;
   logic                                                                               small_tables_done;
   logic                                                                               small_tables_error;

   logic                                                                               small_blt_hist_complete_valid;
   logic                                                                               small_blt_hist_complete_deflate;
   logic [3:0]                                                                         small_blt_hist_complete_deflate_hclen;
   logic [`LOG_VEC(SMALL_BL_PER_CYCLE+1)]                                              small_blt_hist_wen;
   logic [`BIT_VEC(SMALL_BL_PER_CYCLE)][`LOG_VEC(`N_MAX_SMALL_HUFF_BITS+1)]            small_blt_hist_wdata;


   logic [`LOG_VEC(`N_HTF_HDR_FIFO_DEPTH*`AXI_S_DP_DWIDTH+1)]                          `DECLARE_RESET_FLOP(total_bit_count, 0);
   logic                                                                               `DECLARE_RESET_FLOP(htf_bhp_status_valid, 0);
   htf_bhp_status_bus_t                                                                `DECLARE_RESET_FLOP(htf_bhp_status_bus, '0);
   bhp_htf_hdrinfo_bus_t                                                               `DECLARE_RESET_FLOP(hdrinfo, '0);
   logic [`LOG_VEC(`N_MAX_SMALL_HUFF_BITS+1)]                                          `DECLARE_RESET_FLOP(prev_small_bl, 0);
   logic [`LOG_VEC(`N_XP9_SHRT_SYMBOLS+1)]                                             `DECLARE_RESET_FLOP(bl_count, 0);
   logic [`LOG_VEC(`N_XP9_SHRT_SYMBOLS)]                                               `DECLARE_RESET_FLOP(bl_index, 0);
   logic [15:0][`LOG_VEC(`N_MAX_HUFF_BITS+1)]                                          `DECLARE_RESET_FLOP(prev_bl, 0);
   
   enum                                                                                logic [3:0] {IDLE,
                     XP9_SS_HEADER,
                     XP10_SS_HEADER,
                     XP_SS_DELTA_DECODE,
                     XP_SS_RETRO_DECODE,
                     XP_SS_SIMPLE,
                     SS_PREDEF,
                     XP9_LL_HEADER,
                     XP10_LL_HEADER,
                     XP_LL_DELTA_DECODE,
                     XP_LL_RETRO_DECODE,
                     XP_LL_SIMPLE,
                     LL_PREDEF,
                     WAIT_FOR_STATUS_READY} `DECLARE_RESET_FLOP(state, IDLE);

   parameter DECODER_SLICES = BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS;

   typedef enum logic [1:0] {HUFFMAN,
                             EXTRA_2,
                             EXTRA_3,
                             EXTRA_7} sub_state_t;
   sub_state_t `DECLARE_RESET_FLOP(sub_state, HUFFMAN);
   logic [3:0] `DECLARE_RESET_FLOP(repeat_count, 0);
   logic       `DECLARE_RESET_FLOP(got_hdr_bits_last, 0);
   logic [`LOG_VEC(DECODER_SLICES*2+1)] `DECLARE_RESET_FLOP(decoded_bit_count, 0);
   

   assign htf_bhp_status_valid = r_htf_bhp_status_valid;
   assign htf_bhp_status_bus = r_htf_bhp_status_bus;

   `DECLARE_HUFFMAN_DECODER(huffman_decoder, `N_MAX_SMALL_HUFF_BITS, `N_SMALL_SYMBOLS);

   localparam SMALL_SYMBOL_WIDTH = $clog2(`N_SMALL_SYMBOLS);

   typedef struct packed {
      logic [`LOG_VEC(`N_MAX_SMALL_HUFF_BITS+1)] length;
      logic [`LOG_VEC(`N_SMALL_SYMBOLS)]         base_offset;
      logic                                      databit;
   } decode_pre_t;

   typedef struct packed {
      logic [`LOG_VEC(`N_MAX_SMALL_HUFF_BITS+1)] length;
      logic [`LOG_VEC(`N_SMALL_SYMBOLS)] symbol;
      logic                              error;
      logic                              databit;
   } decode_post_t;

   logic [`LOG_VEC(DECODER_SLICES+1)]    decoder_unpacker_src_items_valid;
   decode_pre_t [`BIT_VEC(DECODER_SLICES)]   decoder_unpacker_src_data;
   logic                                 decoder_unpacker_src_last;
   logic                                 decoder_unpacker_src_ready;
   logic [`LOG_VEC(DECODER_SLICES+1)]    decoder_unpacker_dst_items_valid;
   decode_pre_t [`BIT_VEC(DECODER_SLICES)]   decoder_unpacker_dst_data;
   logic                                 decoder_unpacker_dst_last;
   logic                                 decoder_unpacker_dst_error;
   logic [`LOG_VEC(DECODER_SLICES+1)]    decoder_unpacker_dst_items_ready;

   
   logic [`BIT_VEC(DP_WIDTH)]            muxed_hdr_bits_data;
   logic [`LOG_VEC(DP_WIDTH+1)]          muxed_hdr_bits_valid;

   
   always_comb begin
      if (r_state inside {XP9_LL_HEADER, XP10_LL_HEADER, XP_LL_RETRO_DECODE}) begin
         logic [`BIT_VEC(DECODER_SLICES)] v_decoder_databits;
         for (int j=0; j<DECODER_SLICES; j++)
           v_decoder_databits[j] = decoder_unpacker_dst_data[j].databit;
         
         if (r_decoded_bit_count >= DECODER_SLICES) begin
            
            
            
            muxed_hdr_bits_valid = DECODER_SLICES;
            muxed_hdr_bits_data = v_decoder_databits;
         end
         else begin
            
            logic [`BIT_VEC(DP_WIDTH)] v_mask;
            v_mask = ~('1 << r_decoded_bit_count);
            muxed_hdr_bits_valid = `MIN(DP_WIDTH, hdr_bits_valid + r_decoded_bit_count);
            muxed_hdr_bits_data = {v_decoder_databits & v_mask} | (hdr_bits_data << r_decoded_bit_count);
         end
      end
      else begin
         muxed_hdr_bits_valid = hdr_bits_valid;
         muxed_hdr_bits_data = hdr_bits_data;
      end
   end



   logic [`BIT_VEC(DECODER_SLICES+`N_MAX_SMALL_HUFF_BITS-1)] v_bits_valid_mask;
   assign v_bits_valid_mask = ~('1 << muxed_hdr_bits_valid);
   assign decoder_unpacker_src_last = hdr_bits_last && (muxed_hdr_bits_valid <= DECODER_SLICES);

   
   generate
      genvar                             i;
      for (i=0; i<DECODER_SLICES; i++) begin
         always_comb begin
            huffman_decoder_LENGTH(muxed_hdr_bits_data[i +: `N_MAX_SMALL_HUFF_BITS],
                                   small_bct, 
                                   small_bct_valid & v_bits_valid_mask[i +: `N_MAX_SMALL_HUFF_BITS],
                                   decoder_unpacker_src_data[i].length,
                                   decoder_unpacker_src_data[i].base_offset);
            decoder_unpacker_src_data[i].databit = muxed_hdr_bits_data[i];
         end 
      end 
   endgenerate

   

   cr_xp10_decomp_unpacker
     #(.ITEMS(DECODER_SLICES),
       .BITS_PER_ITEM($bits(decode_pre_t)),
       .WIDTH(DECODER_SLICES*$bits(decode_pre_t)))
   u_decoder_unpacker
     (
      
      .src_ready                        (decoder_unpacker_src_ready), 
      .dst_items_valid                  (decoder_unpacker_dst_items_valid), 
      .dst_data                         (decoder_unpacker_dst_data), 
      .dst_last                         (decoder_unpacker_dst_last), 
      .dst_error                        (decoder_unpacker_dst_error), 
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .src_items_valid                  (decoder_unpacker_src_items_valid), 
      .src_data                         (decoder_unpacker_src_data), 
      .src_last                         (decoder_unpacker_src_last), 
      .src_error                        (hdr_bits_err),          
      .dst_items_ready                  (decoder_unpacker_dst_items_ready), 
      .clear                            (hdr_clear));             


   always_comb begin
      `DEFAULT_FLOP(state);
      `DEFAULT_FLOP(total_bit_count);
      `DEFAULT_FLOP(htf_bhp_status_valid);
      `DEFAULT_FLOP(htf_bhp_status_bus);
      `DEFAULT_FLOP(bl_count);
      `DEFAULT_FLOP(bl_index);
      `DEFAULT_FLOP(hdrinfo);
      `DEFAULT_FLOP(prev_small_bl);
      `DEFAULT_FLOP(sub_state);
      `DEFAULT_FLOP(repeat_count);
      `DEFAULT_FLOP(prev_bl);
      `DEFAULT_FLOP(got_hdr_bits_last);
      `DEFAULT_FLOP(decoded_bit_count);

      htf_bhp_hdrinfo_ready = 0;
      hdr_bits_ready = 0;
      predef_bl_rsp_bits_ready = 0;
      predef_bl_done = 0;
      blt_hist_wen = 0;
      
      for (int i=0; i<BL_PER_CYCLE; i++)
        blt_hist_wdata[i] = { << {predef_bl_rsp_bits_data[i*XP_BL_WIDTH +: XP_BL_WIDTH]}};  
      blt_hist_complete_valid = 0;
      blt_hist_complete_fmt = r_hdrinfo.fmt;
      blt_hist_complete_min_ptr_len = r_hdrinfo.min_ptr_len;
      blt_hist_complete_min_mtf_len = r_hdrinfo.min_mtf_len;
      blt_hist_complete_error = 0;

      predef_bl_req_valid = 0;
      predef_bl_req_ll = 0;

      hdr_clear = 0;

      small_blt_hist_complete_valid = 0;
      small_blt_hist_complete_deflate = 0;
      small_blt_hist_complete_deflate_hclen = 0;
      small_blt_hist_wen = 0;
      small_blt_hist_wdata = {SMALL_BL_PER_CYCLE{r_prev_small_bl}};

      decoder_unpacker_dst_items_ready = 0;
      decoder_unpacker_src_items_valid = 0;

      case (r_state)
        WAIT_FOR_STATUS_READY: begin
           if (bhp_htf_status_ready) begin
              c_htf_bhp_status_valid = 0;
              hdr_clear = 1;
              if (r_hdrinfo.predef_last)
                predef_bl_done = 1;
              c_state = IDLE;
           end
        end
        IDLE: begin
           if (bhp_htf_hdrinfo_valid) begin
              c_hdrinfo = bhp_htf_hdrinfo_bus;
              htf_bhp_hdrinfo_ready = 1;
              c_total_bit_count = 0;
              c_decoded_bit_count = 0;
              case (bhp_htf_hdrinfo_bus.fmt)
                HTF_FMT_XP10: begin
                   c_state = XP10_SS_HEADER;
                end
                HTF_FMT_XP9: begin
                   c_state = XP9_SS_HEADER;
                end
                default: begin
                   
                end
              endcase
           end
        end 
        XP9_SS_HEADER, XP9_LL_HEADER: begin
           if (|muxed_hdr_bits_valid && hdr_bits_err) begin
              c_htf_bhp_status_valid = 1;
              c_htf_bhp_status_bus.error = HTF_ERROR_HDR_ECC;
           end
           else if (muxed_hdr_bits_valid > $bits(xp9_symbol_encode_e)) begin
              hdr_bits_ready = $bits(xp9_symbol_encode_e);
              case (xp9_symbol_encode_e'(muxed_hdr_bits_data[`BIT_VEC($bits(xp9_symbol_encode_e))]))
                XP9_RETROSPECTIVE: begin
                   if (r_state == XP9_SS_HEADER)
                     c_state = XP_SS_DELTA_DECODE;
                   else
                     c_state = XP_LL_DELTA_DECODE;
                   c_prev_small_bl = 4;
                   c_bl_count = `N_SMALL_SYMBOLS;
                end
                XP9_SIMPLE: begin
                   assert #0 (r_hdrinfo.winsize == 0) else `ERROR("received hdrinfo with illegal xp9 winsize");                   
                   if (r_state == XP9_SS_HEADER) begin
                      c_state = XP_SS_SIMPLE;
                      c_bl_count = `N_XP9_SHRT_SYMBOLS;
                   end
                   else begin
                      c_state = XP_LL_SIMPLE;
                      c_bl_count = `N_XP9_LONG_SYMBOLS;
                   end
                end
                default: begin
                   c_htf_bhp_status_valid = 1;
                   c_htf_bhp_status_bus.error = HTF_ERROR_INVALID_SYMBOL_TABLE_ENCODING;
                end
              endcase
           end 
           else if (hdr_bits_last) begin
              c_htf_bhp_status_valid = 1;
              c_htf_bhp_status_bus.error = HTF_ERROR_EARLY_LAST;
           end
        end
        XP10_SS_HEADER, XP10_LL_HEADER: begin
           if (|muxed_hdr_bits_valid && hdr_bits_err) begin
              c_htf_bhp_status_valid = 1;
              c_htf_bhp_status_bus.error = HTF_ERROR_HDR_ECC;
           end
           else if (muxed_hdr_bits_valid > $bits(xp10_symbol_encode_e)) begin
              hdr_bits_ready = $bits(xp10_symbol_encode_e);
              case (xp10_symbol_encode_e'(muxed_hdr_bits_data[`BIT_VEC($bits(xp10_symbol_encode_e))]))
                XP10_PREDEFINED: begin
                   predef_bl_req_valid = 1;
                   predef_bl_req_ll = r_state == XP10_LL_HEADER;

                   if (predef_bl_req_ready) begin
                      if (predef_bl_req_error) begin
                         c_htf_bhp_status_valid = 1;
                         c_htf_bhp_status_bus.error = HTF_ERROR_INVALID_SYMBOL_TABLE_ENCODING;
                      end
                      else if (r_state == XP10_SS_HEADER) begin
                         c_state = SS_PREDEF;
                         c_bl_count = NUM_PREDEF_SS_BL;
                      end
                      else begin
                         c_state = LL_PREDEF;
                         c_bl_count = NUM_PREDEF_LL_BL;
                      end
                   end
                end 
                XP10_RETROSPECTIVE: begin
                   if (r_state == XP10_SS_HEADER)
                     c_state = XP_SS_DELTA_DECODE;
                   else
                     c_state = XP_LL_DELTA_DECODE;
                   c_prev_small_bl = 4;
                   c_bl_count = `N_SMALL_SYMBOLS;
                end
                XP10_SIMPLE: begin
                   logic [`LOG_VEC(`N_XP9_SHRT_SYMBOLS+1)] v_shrt_bl_count;
                   logic [`LOG_VEC(`N_XP9_SHRT_SYMBOLS+1)] v_long_bl_count;
                   case (r_hdrinfo.winsize)
                     0: begin
                        v_shrt_bl_count = `N_XP10_4K_SHRT_SYMBOLS;
                        v_long_bl_count = `N_XP10_4K_LONG_SYMBOLS;
                     end
                     1: begin
                        v_shrt_bl_count = `N_XP10_8K_SHRT_SYMBOLS;
                        v_long_bl_count = `N_XP10_8K_LONG_SYMBOLS;
                     end
                     2: begin
                        v_shrt_bl_count = `N_XP10_16K_SHRT_SYMBOLS;
                        v_long_bl_count = `N_XP10_16K_LONG_SYMBOLS;
                     end
                     3: begin
                        v_shrt_bl_count = `N_XP10_64K_SHRT_SYMBOLS;
                        v_long_bl_count = `N_XP10_64K_LONG_SYMBOLS;
                     end
                     default: begin
                        v_shrt_bl_count = 0;
                        v_long_bl_count = 0;
                        `ERROR("received hdrinfo with illegal xp10 winsize");
                     end
                   endcase 
                   if (r_state == XP10_SS_HEADER) begin
                      c_state = XP_SS_SIMPLE;
                      c_bl_count = v_shrt_bl_count;
                   end 
                   else begin
                      c_state = XP_LL_SIMPLE;
                      c_bl_count = v_long_bl_count;
                   end
                end
                default: begin
                   c_htf_bhp_status_valid = 1;
                   c_htf_bhp_status_bus.error = HTF_ERROR_INVALID_SYMBOL_TABLE_ENCODING;
                end
              endcase
           end 
           else if (hdr_bits_last) begin
              c_htf_bhp_status_valid = 1;
              c_htf_bhp_status_bus.error = HTF_ERROR_EARLY_LAST;
           end
        end 
        SS_PREDEF, LL_PREDEF: begin
           if (|predef_bl_rsp_bits_valid) begin
              if (predef_bl_rsp_bits_err) begin
                 c_htf_bhp_status_valid = 1;
                 c_htf_bhp_status_bus.error = HTF_ERROR_PREDEF_ECC;
              end
              else if (!blt_hist_busy) begin
                 predef_bl_rsp_bits_ready = XP_BL_WIDTH*BL_PER_CYCLE;
                 blt_hist_wen = 2;
                 c_bl_count = r_bl_count - BL_PER_CYCLE;
                 if (r_bl_count == BL_PER_CYCLE) begin
                    blt_hist_complete_valid = 1;
                    predef_bl_rsp_bits_ready = predef_bl_rsp_bits_valid; 
                    if (r_state == SS_PREDEF) begin
                       c_state = XP10_LL_HEADER;
                    end
                    else begin
                       c_htf_bhp_status_valid = 1;
                       c_htf_bhp_status_bus.error = NO_ERRORS;
                    end
                 end
              end
           end
        end 
        XP_SS_DELTA_DECODE, XP_LL_DELTA_DECODE: begin
           logic [`LOG_VEC(DP_WIDTH+1)] v_hdr_bits_valid;
           logic [`BIT_VEC(DP_WIDTH)]   v_hdr_bits_data;

           v_hdr_bits_valid = muxed_hdr_bits_valid;
           v_hdr_bits_data = muxed_hdr_bits_data;
           hdr_bits_ready = 0;
           
           
           
           
           for (int i=0; i<SMALL_BL_PER_CYCLE; i++) begin
              if (r_bl_count > i) begin
                 if (|v_hdr_bits_valid) begin
                    if (hdr_bits_err) begin
                       c_htf_bhp_status_valid = 1;
                       c_htf_bhp_status_bus.error = HTF_ERROR_HDR_ECC;
                       break;
                    end
                    if (v_hdr_bits_data[0] == 0) begin
                       small_blt_hist_wdata[i] = c_prev_small_bl;
                       hdr_bits_ready++;
                       v_hdr_bits_valid--;
                       v_hdr_bits_data >>= 1;
                    end
                    else if (v_hdr_bits_valid > 3) begin
                       if ({1'b0, v_hdr_bits_data[3:1]} < c_prev_small_bl)
                         small_blt_hist_wdata[i] = {1'b0, v_hdr_bits_data[3:1]};
                       else
                         small_blt_hist_wdata[i] = v_hdr_bits_data[3:1]+1;
                       c_prev_small_bl = small_blt_hist_wdata[i];
                       hdr_bits_ready += 4;
                       v_hdr_bits_valid -= 4;
                       v_hdr_bits_data >>= 4;
                    end 
                    else if (hdr_bits_last) begin
                       c_htf_bhp_status_valid = 1;
                       c_htf_bhp_status_bus.error = HTF_ERROR_EARLY_LAST;
                       break;
                    end
                    else begin
                       break;
                    end
                    c_got_hdr_bits_last = hdr_bits_last;
                    small_blt_hist_wen++;
                    c_bl_count--;
                 end 
                 else if (c_got_hdr_bits_last) begin
                    c_htf_bhp_status_valid = 1;
                    c_htf_bhp_status_bus.error = HTF_ERROR_EARLY_LAST;
                    break;
                 end
              end 
           end 
           if (c_bl_count == 0) begin
              
              small_blt_hist_complete_valid = 1;
              small_blt_hist_complete_deflate = 0;
              c_sub_state = HUFFMAN;
              c_bl_index = 0;
              if (r_state == XP_SS_DELTA_DECODE) begin
                 c_state = XP_SS_RETRO_DECODE;
                 if (r_hdrinfo.fmt == HTF_FMT_XP9)
                   c_bl_count = `N_XP9_SHRT_SYMBOLS;
                 else begin
                    case (r_hdrinfo.winsize)
                      0: c_bl_count = `N_XP10_4K_SHRT_SYMBOLS;
                      1: c_bl_count = `N_XP10_8K_SHRT_SYMBOLS;
                      2: c_bl_count = `N_XP10_16K_SHRT_SYMBOLS;
                      3: c_bl_count = `N_XP10_64K_SHRT_SYMBOLS;
                      default: begin
                         `ERROR("received hdrinfo with illegal winsize");
                      end
                    endcase
                 end
              end
              else begin
                 c_state = XP_LL_RETRO_DECODE;
                 if (r_hdrinfo.fmt == HTF_FMT_XP9)
                   c_bl_count = `N_XP9_LONG_SYMBOLS;
                 else begin
                    case (r_hdrinfo.winsize)
                      0: c_bl_count = `N_XP10_4K_LONG_SYMBOLS;
                      1: c_bl_count = `N_XP10_8K_LONG_SYMBOLS;
                      2: c_bl_count = `N_XP10_16K_LONG_SYMBOLS;
                      3: c_bl_count = `N_XP10_64K_LONG_SYMBOLS;
                      default: begin
                         `ERROR("received hdrinfo with illegal winsize");
                      end
                    endcase
                 end
              end
           end
        end 
        XP_SS_RETRO_DECODE, XP_LL_RETRO_DECODE: begin
           if (small_tables_done) begin
              if (small_tables_error) begin
                 c_htf_bhp_status_valid = 1;
                 c_htf_bhp_status_bus.error = HTF_ERROR_ILLEGAL_SMALL_HUFFTREE;
              end
              else begin
                 logic [`LOG_VEC(DECODER_SLICES+1)]  v_decoder_items_valid;
                 decode_post_t [`BIT_VEC(DECODER_SLICES)] v_decoder_data;

                 
                 
                 
                 
                 logic [`LOG_VEC(`N_MAX_SMALL_HUFF_BITS+1)] v_length[BL_PER_CYCLE:1];
                 logic                                      v_early_last_err[BL_PER_CYCLE:1];
                 logic                                      v_inc[BL_PER_CYCLE:1];

                 
                 
                 logic [3:0]                                v_repeat_count[BL_PER_CYCLE:0];
                 sub_state_t                                v_sub_state[BL_PER_CYCLE:0];
                 logic [`LOG_VEC(`N_XP9_SHRT_SYMBOLS+1)]    v_bl_count[BL_PER_CYCLE:0];
                 logic [`LOG_VEC(`N_XP9_SHRT_SYMBOLS)]      v_bl_index[BL_PER_CYCLE:0];
                 logic [15:0][`LOG_VEC(`N_MAX_HUFF_BITS+1)] v_prev_bl[BL_PER_CYCLE:0];

                 v_decoder_items_valid = decoder_unpacker_dst_items_valid;

                 for (int i=0; i<DECODER_SLICES; i++) begin
                    v_decoder_data[i].length = decoder_unpacker_dst_data[i].length;
                    v_decoder_data[i].databit = decoder_unpacker_dst_data[i].databit;
                    huffman_decoder_SYMBOL(decoder_unpacker_dst_data[i].length,
                                           decoder_unpacker_dst_data[i].base_offset,
                                           small_sat,
                                           small_slt,
                                           small_used_symbols,
                                           v_decoder_data[i].symbol,
                                           v_decoder_data[i].error);
                 end
                 
                 v_repeat_count = '{default: r_repeat_count};
                 v_sub_state = '{default: r_sub_state};
                 v_bl_count = '{default: r_bl_count};
                 v_bl_index = '{default: r_bl_index};
                 v_prev_bl = '{default: r_prev_bl};
                 
                 
                 if ((muxed_hdr_bits_valid >= DECODER_SLICES) ||
                     (|muxed_hdr_bits_valid && hdr_bits_last)) begin
                    decoder_unpacker_src_items_valid = `MIN(muxed_hdr_bits_valid, DECODER_SLICES);
                    if (decoder_unpacker_src_ready) begin
                       hdr_bits_ready = decoder_unpacker_src_items_valid;

                       
                       
                       
                       
                       
                       if (r_state == XP_SS_RETRO_DECODE)
                         c_decoded_bit_count = r_decoded_bit_count + decoder_unpacker_src_items_valid;
                    end
                 end


                 for (int i=0; i<BL_PER_CYCLE; i++) begin
                    logic [`BIT_VEC(DECODER_SLICES)] v_decoder_databits;
                    for (int j=0; j<DECODER_SLICES; j++)
                      v_decoder_databits[j] = v_decoder_data[j].databit;

                    v_early_last_err[i+1] = 0;
                    v_length[i+1] = 0;
                    v_inc[i+1] = 0;
                    if (v_repeat_count[i] == 0) begin
                       case (v_sub_state[i])
                         HUFFMAN: begin
                            if ((decoder_unpacker_dst_items_valid >= DECODER_SLICES) ||
                                (|decoder_unpacker_dst_items_valid && decoder_unpacker_dst_last)) begin
                               if (decoder_unpacker_dst_error) begin
                                  c_htf_bhp_status_valid = 1;
                                  c_htf_bhp_status_bus.error = HTF_ERROR_HDR_ECC;
                                  break;
                               end
                               else begin
                                  v_length[i+1] = v_decoder_data[0].length;
                                  if (!v_decoder_data[0].error) begin
                                     if (v_decoder_data[0].symbol == SMALL_SYMBOL_WIDTH'(28)) begin
                                        blt_hist_wdata[i] = '0;
                                        v_repeat_count[i+1] = 15 - v_bl_index[i][3:0];
                                     end
                                     else if (v_decoder_data[0].symbol == SMALL_SYMBOL_WIDTH'(29)) begin
                                        blt_hist_wdata[i] = '0;
                                        v_repeat_count[i+1] = 3;
                                        v_sub_state[i+1] = EXTRA_2;
                                     end
                                     else if (v_decoder_data[0].symbol == SMALL_SYMBOL_WIDTH'(30)) begin
                                        blt_hist_wdata[i] = v_prev_bl[i][0];
                                     end
                                     else if (v_decoder_data[0].symbol == SMALL_SYMBOL_WIDTH'(31)) begin
                                        blt_hist_wdata[i] = v_prev_bl[i][15];
                                     end
                                     else if (v_decoder_data[0].symbol == SMALL_SYMBOL_WIDTH'(32)) begin
                                        blt_hist_wdata[i] = v_prev_bl[i][15]+1;
                                     end
                                     else begin
                                        assert #0 (v_decoder_data[0].symbol < 33) else `ERROR("can't get small symbol greater than 32");
                                        blt_hist_wdata[i] = v_decoder_data[0].symbol[4:0];
                                     end
                                     
                                     v_inc[i+1] = 1;
                                  end 
                               end 
                            end 
                         end 
                         EXTRA_2: begin
                            if (v_decoder_items_valid >= 2) begin
                               v_inc[i+1] = 1;
                               v_length[i+1] = 2;
                               blt_hist_wdata[i] = '0;
                               if (v_decoder_databits[1:0] == 2'd3) begin
                                  v_repeat_count[i+1] = 2;
                                  v_sub_state[i+1] = EXTRA_3;
                               end
                               else begin
                                  v_repeat_count[i+1] = v_decoder_databits[1:0];
                                  v_sub_state[i+1] = HUFFMAN;
                               end
                            end
                            else if (|v_decoder_items_valid && decoder_unpacker_dst_last) begin
                               v_early_last_err[i+1] = 1;
                            end
                         end 
                         EXTRA_3: begin
                            if (v_decoder_items_valid >= 3) begin
                               v_inc[i+1] = 1;
                               v_length[i+1] = 3;
                               blt_hist_wdata[i] = '0;
                               if (v_decoder_databits[2:0] == 3'd7) begin
                                  v_repeat_count[i+1] = 6;
                                  v_sub_state[i+1] = EXTRA_3;
                               end
                               else begin
                                  v_repeat_count[i+1] = v_decoder_databits[2:0];
                                  v_sub_state[i+1] = HUFFMAN;
                               end
                            end
                            else if (|v_decoder_items_valid && decoder_unpacker_dst_last) begin
                               v_early_last_err[i+1] = 1;
                            end
                         end 
                         default: begin
                            
                         end
                       endcase 
                       if (!v_inc[i+1] && c_got_hdr_bits_last)
                         v_early_last_err[i+1] = 1;
                    end 
                    else begin
                       v_inc[i+1] = 1;
                       blt_hist_wdata[i] = v_prev_bl[i][0];
                       v_repeat_count[i+1] = v_repeat_count[i] - 1;
                    end 
                    if (v_decoder_data[0].error || v_early_last_err[i+1]) begin
                       c_htf_bhp_status_valid = 1;
                       if (v_decoder_data[0].error)
                         c_htf_bhp_status_bus.error = HTF_ERROR_BAD_HUFFMAN_CODE;
                       else
                         c_htf_bhp_status_bus.error = HTF_ERROR_EARLY_LAST;
                       break;
                    end
                    else if (v_inc[i+1]) begin
                       logic [3:0] v_inc_count;
                       logic       v_carryout;

                       decoder_unpacker_dst_items_ready += v_length[i+1];
                       v_decoder_items_valid -= v_length[i+1];
                       v_decoder_data >>= v_length[i+1]*$bits(decode_post_t);
                       if (((r_state == XP_SS_RETRO_DECODE) &&
                            (v_bl_index[i] < `N_XP10_64K_SHRT_SYMBOLS)) ||
                           ((r_state == XP_LL_RETRO_DECODE) &&
                            (v_bl_index[i] < `N_XP10_64K_LONG_SYMBOLS))) begin
                          blt_hist_wen++;
                          v_inc_count = 0;
                       end
                       else begin
                          
                          
                          
                          v_inc_count = v_repeat_count[i+1];
                          v_repeat_count[i+1] = 0;
                          if (blt_hist_wdata[i] != 0) begin
                             c_htf_bhp_status_valid = 1;
                             if (r_state == XP_SS_RETRO_DECODE)
                               c_htf_bhp_status_bus.error = HTF_ERROR_ILLEGAL_SYMBOL_TABLE_SHORT;
                             else
                               c_htf_bhp_status_bus.error = HTF_ERROR_ILLEGAL_SYMBOL_TABLE_LONG;
                          end
                       end 
                       {v_carryout, v_bl_count[i+1]} = v_bl_count[i] - 1 - v_inc_count;
                       v_bl_index[i+1] = v_bl_index[i] + 1 + v_inc_count;
                       v_prev_bl[i+1] = {v_prev_bl[i][14:0], blt_hist_wdata[i]} << (v_inc_count*$clog2(`N_MAX_HUFF_BITS+1));

                       if (v_carryout) begin
                          
                          c_htf_bhp_status_valid = 1;
                          if (r_state == XP_SS_RETRO_DECODE)
                            c_htf_bhp_status_bus.error = HTF_ERROR_ILLEGAL_SYMBOL_TABLE_SHORT;
                          else
                            c_htf_bhp_status_bus.error = HTF_ERROR_ILLEGAL_SYMBOL_TABLE_LONG;
                       end
                       else if (v_bl_count[i+1] == 0) begin
                          if (r_state == XP_SS_RETRO_DECODE) begin
                             blt_hist_complete_valid = 1;
                             if (r_hdrinfo.fmt == HTF_FMT_XP9)
                               c_state = XP9_LL_HEADER;
                             else
                               c_state = XP10_LL_HEADER;
                          end
                          else begin
                             
                             c_htf_bhp_status_valid = 1;
                             c_htf_bhp_status_bus.error = NO_ERRORS;
                             blt_hist_complete_valid = 1;
                          end
                          break;
                       end
                    end
                 end 
                 c_repeat_count = v_repeat_count[BL_PER_CYCLE];
                 c_sub_state = v_sub_state[BL_PER_CYCLE];
                 c_bl_count = v_bl_count[BL_PER_CYCLE];
                 c_bl_index = v_bl_index[BL_PER_CYCLE];
                 c_prev_bl = v_prev_bl[BL_PER_CYCLE];
              end 
           end 
        end 
        default:  begin
           
           
           
           
           
           
        end
      endcase 

      
      if (r_state inside {XP9_LL_HEADER, XP10_LL_HEADER, XP_LL_RETRO_DECODE}) begin
         if (hdr_bits_ready < $bits(hdr_bits_ready)'(decoder_unpacker_dst_items_valid)) begin
            decoder_unpacker_dst_items_ready = hdr_bits_ready;
            hdr_bits_ready = 0;
         end
         else begin
            decoder_unpacker_dst_items_ready = decoder_unpacker_dst_items_valid;
            hdr_bits_ready = hdr_bits_ready - decoder_unpacker_dst_items_valid;
         end
      end

      
      
      if (c_decoded_bit_count != 0)
        c_decoded_bit_count -= decoder_unpacker_dst_items_ready;

      if (r_state inside {XP_SS_RETRO_DECODE,
                          XP_LL_RETRO_DECODE})
        c_total_bit_count =  r_total_bit_count + decoder_unpacker_dst_items_ready;
      else
        c_total_bit_count = r_total_bit_count + hdr_bits_ready;
      c_htf_bhp_status_bus.size = c_total_bit_count;
      if (c_htf_bhp_status_valid && !r_htf_bhp_status_valid) begin
         if ((c_htf_bhp_status_bus.error != NO_ERRORS) &&
                                            ((r_state == XP9_LL_HEADER) ||
                                             (r_state == XP10_LL_HEADER) ||
                                             (r_state == XP_LL_DELTA_DECODE) ||
                                             (r_state == XP_LL_RETRO_DECODE) ||
                                             (r_state == LL_PREDEF))) begin
            
            
            
            blt_hist_complete_valid = 1;            
            blt_hist_complete_error = 1;
         end 
         c_state = WAIT_FOR_STATUS_READY;
      end 
   end 

   `ASSERT_PROPERTY((32)'(decoder_unpacker_dst_items_valid) >= `MIN(r_decoded_bit_count, DECODER_SLICES)) else `ERROR("r_decoded_bit_count has become out-of-sync with decoder_unpacker");
   
   

   cr_xp10_decomp_htf_small_tables
     #(.SMALL_BL_PER_CYCLE(SMALL_BL_PER_CYCLE))
   u_small_tables
     (
      
      .small_bct                        (small_bct),
      .small_bct_valid                  (small_bct_valid[`BIT_VEC_BASE(`N_MAX_SMALL_HUFF_BITS,1)]),
      .small_sat                        (small_sat),
      .small_slt                        (small_slt),
      .small_used_symbols               (small_used_symbols[`LOG_VEC(`N_SMALL_SYMBOLS+1)]),
      .small_tables_done                (small_tables_done),
      .small_tables_error               (small_tables_error),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .small_blt_hist_complete_valid    (small_blt_hist_complete_valid),
      .small_blt_hist_complete_deflate  (small_blt_hist_complete_deflate),
      .small_blt_hist_complete_deflate_hclen(small_blt_hist_complete_deflate_hclen[3:0]),
      .small_blt_hist_wen               (small_blt_hist_wen[`LOG_VEC(SMALL_BL_PER_CYCLE+1)]),
      .small_blt_hist_wdata             (small_blt_hist_wdata));


   
`undef DECLARE_RESET_FLOP
`undef DECLARE_FLOP
`undef DEFAULT_FLOP

endmodule 







    