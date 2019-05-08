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
`include "axi_reg_slice_defs.vh"

module cr_xp10_decomp_htf_symtab_dec (
   
   htf_bhp_hdrinfo_ready, htf_bhp_status_valid, htf_bhp_status_bus,
   hdr_bits_consume, hdr_clear, predef_bl_req_valid, predef_bl_req_ll,
   predef_bl_req_num_bl, predef_bl_rsp_bits_consume, predef_bl_done,
   blt_hist_wen, blt_hist_wdata, blt_hist_complete_valid,
   blt_hist_start_valid, blt_hist_complete_fmt,
   blt_hist_complete_min_ptr_len, blt_hist_complete_min_mtf_len,
   blt_hist_complete_total_bit_count, blt_hist_complete_sched_info,
   blt_hist_complete_error, htf_bl_im_valid, htf_bl_im_data,
   xp9_simple_short_blk_stb, xp9_retro_short_blk_stb,
   xp9_simple_long_blk_stb, xp9_retro_long_blk_stb,
   xp10_simple_short_blk_stb, xp10_retro_short_blk_stb,
   xp10_predef_short_blk_stb, xp10_simple_long_blk_stb,
   xp10_retro_long_blk_stb, xp10_predef_long_blk_stb,
   chu4k_simple_short_blk_stb, chu4k_retro_short_blk_stb,
   chu4k_predef_short_blk_stb, chu4k_simple_long_blk_stb,
   chu4k_retro_long_blk_stb, chu4k_predef_long_blk_stb,
   chu8k_simple_short_blk_stb, chu8k_retro_short_blk_stb,
   chu8k_predef_short_blk_stb, chu8k_simple_long_blk_stb,
   chu8k_retro_long_blk_stb, chu8k_predef_long_blk_stb,
   deflate_dynamic_blk_stb, deflate_fixed_blk_stb, hdr_info_stall_stb,
   
   clk, rst_n, bhp_htf_hdrinfo_valid, bhp_htf_hdrinfo_bus,
   bhp_htf_status_ready, hdr_bits_avail, hdr_bits_data, hdr_bits_last,
   hdr_bits_err, predef_bl_req_ready, predef_bl_rsp_bits_avail,
   predef_bl_rsp_bits_data, blt_hist_busy, htf_bl_im_ready
   );

   parameter DP_WIDTH = 64; 
   parameter BL_PER_CYCLE = 2;
   parameter SMALL_BL_PER_CYCLE = 2;

   localparam XP_BL_WIDTH = $clog2(`N_MAX_XP_HUFF_BITS);
   localparam MAX_BL_PER_CYCLE = `MAX(BL_PER_CYCLE, SMALL_BL_PER_CYCLE);

   import crPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;

`ifndef SYNTHESIS
   initial begin
      if (XP_BL_WIDTH*BL_PER_CYCLE > DP_WIDTH)
        `FATAL("can't sustain %0d pre-defined bit-lengths per cycle with %0d-bit data path", XP_BL_WIDTH, DP_WIDTH);
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

   
   
   
   input [`LOG_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS+1)] hdr_bits_avail;
   input [`BIT_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS)]   hdr_bits_data;
   input                                                   hdr_bits_last;
   input                                                   hdr_bits_err;
   output logic [`LOG_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS+1)] hdr_bits_consume;
   
   output logic                        hdr_clear;   

   
   
   
   output logic  predef_bl_req_valid; 
   output logic  predef_bl_req_ll; 
                                   
   output logic [9:0] predef_bl_req_num_bl;

   input         predef_bl_req_ready;
   
   input [`LOG_VEC(BL_PER_CYCLE*$clog2(`N_MAX_HUFF_BITS+1)+1)]        predef_bl_rsp_bits_avail;
   input [`BIT_VEC(BL_PER_CYCLE*$clog2(`N_MAX_HUFF_BITS+1))]          predef_bl_rsp_bits_data;
   output logic [`LOG_VEC(BL_PER_CYCLE*$clog2(`N_MAX_HUFF_BITS+1)+1)] predef_bl_rsp_bits_consume;
   
   output logic  predef_bl_done; 

   
   
   
   
   
   
   
   output logic [`LOG_VEC(BL_PER_CYCLE+1)] blt_hist_wen;
   output logic [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(`N_MAX_HUFF_BITS+1)] blt_hist_wdata;

   
   
   
   
   
   output logic                              blt_hist_complete_valid;
   output logic                              blt_hist_start_valid;
   output                                    htf_fmt_e blt_hist_complete_fmt;
   output logic                              blt_hist_complete_min_ptr_len;
   output logic                              blt_hist_complete_min_mtf_len;
   output logic [`LOG_VEC(`N_HTF_HDR_FIFO_DEPTH*`AXI_S_DP_DWIDTH+1)] blt_hist_complete_total_bit_count;
   output                                    sched_info_t blt_hist_complete_sched_info;
   output logic                              blt_hist_complete_error;

   
   input                                     blt_hist_busy;

   
   
   
   output logic htf_bl_im_valid;
   output       htf_bl_out_t htf_bl_im_data;
   input        htf_bl_im_ready;

   
   
   
   output logic xp9_simple_short_blk_stb;
   output logic xp9_retro_short_blk_stb;
   output logic xp9_simple_long_blk_stb;
   output logic xp9_retro_long_blk_stb;

   output logic xp10_simple_short_blk_stb;
   output logic xp10_retro_short_blk_stb;
   output logic xp10_predef_short_blk_stb;
   output logic xp10_simple_long_blk_stb;
   output logic xp10_retro_long_blk_stb;
   output logic xp10_predef_long_blk_stb;

   output logic chu4k_simple_short_blk_stb;
   output logic chu4k_retro_short_blk_stb;
   output logic chu4k_predef_short_blk_stb;
   output logic chu4k_simple_long_blk_stb;
   output logic chu4k_retro_long_blk_stb;
   output logic chu4k_predef_long_blk_stb;

   output logic chu8k_simple_short_blk_stb;
   output logic chu8k_retro_short_blk_stb;
   output logic chu8k_predef_short_blk_stb;
   output logic chu8k_simple_long_blk_stb;
   output logic chu8k_retro_long_blk_stb;
   output logic chu8k_predef_long_blk_stb;

   output logic deflate_dynamic_blk_stb;

   output logic deflate_fixed_blk_stb;
   output logic hdr_info_stall_stb;

   
   
   
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

   logic [`LOG_VEC(BL_PER_CYCLE+1)]          `DECLARE_RESET_OUT_FLOP(blt_hist_wen, 0);
   logic [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(`N_MAX_HUFF_BITS+1)] `DECLARE_RESET_OUT_FLOP(blt_hist_wdata, 0);

   logic                              `DECLARE_RESET_OUT_FLOP(blt_hist_complete_valid, 0);
   logic                              `DECLARE_RESET_OUT_FLOP(blt_hist_start_valid, 0);
   htf_fmt_e                          `DECLARE_RESET_OUT_FLOP(blt_hist_complete_fmt, HTF_FMT_XP9);
   logic                              `DECLARE_RESET_OUT_FLOP(blt_hist_complete_min_ptr_len, 0);
   logic                              `DECLARE_RESET_OUT_FLOP(blt_hist_complete_min_mtf_len, 0);
   logic [`LOG_VEC(`N_HTF_HDR_FIFO_DEPTH*`AXI_S_DP_DWIDTH+1)] `DECLARE_RESET_OUT_FLOP(blt_hist_complete_total_bit_count, 0);
   sched_info_t                       `DECLARE_RESET_OUT_FLOP(blt_hist_complete_sched_info, '0);
   logic                              `DECLARE_RESET_OUT_FLOP(blt_hist_complete_error, 0);
   
   logic [`BIT_VEC(`N_SMALL_SYMBOLS)][`LOG_VEC(`N_MAX_SMALL_HUFF_BITS+1)]   small_blt;
   logic [`BIT_VEC(`N_SMALL_SYMBOLS)][`BIT_VEC(`N_MAX_SMALL_HUFF_BITS)]     small_smt;
   logic [`BIT_VEC(`N_SMALL_SYMBOLS)][`BIT_VEC(`N_MAX_SMALL_HUFF_BITS)]     small_svt;
   logic                                                                    small_tables_done;
   logic                                                                    small_tables_error;
   
   logic                                                                    `DECLARE_RESET_FLOP(small_blt_hist_complete_valid, 0);
   logic                                                                    `DECLARE_RESET_FLOP(small_blt_hist_start_valid, 0);
   logic                                                                    small_blt_hist_complete_deflate;
   logic [`LOG_VEC(SMALL_BL_PER_CYCLE+1)]                                   `DECLARE_RESET_FLOP(small_blt_hist_wen, 0);
   logic [`BIT_VEC(SMALL_BL_PER_CYCLE)][`LOG_VEC(`N_MAX_SMALL_HUFF_BITS+1)] `DECLARE_RESET_FLOP(small_blt_hist_wdata, '0);
   logic [`BIT_VEC(5)]                                                              `DECLARE_RESET_FLOP(hclen, 0);
   logic [`BIT_VEC(6)]                                                              `DECLARE_RESET_FLOP(hdist, 0);
   logic [`BIT_VEC(9)]                                                              `DECLARE_RESET_FLOP(hlit, 0);

   
   logic [`BIT_VEC(`N_CODELEN_SYMBOLS*3*2)]                                         `DECLARE_FLOP(codelen_data);
   logic [`BIT_VEC(`N_CODELEN_SYMBOLS)][`LOG_VEC(`N_MAX_CODELEN_HUFF_BITS+1)]       reordered_codelen_data;

   logic [`LOG_VEC(`N_HTF_HDR_FIFO_DEPTH*`AXI_S_DP_DWIDTH+1)]               `DECLARE_RESET_FLOP(total_bit_count, 0);
   logic                                                                    `DECLARE_RESET_FLOP(status_valid, 0);
   logic                                                                    `DECLARE_RESET_FLOP(status_valid_dly, 0);
   htf_bhp_status_bus_t                                                     `DECLARE_RESET_FLOP(status_bus, '0);
   bhp_htf_hdrinfo_bus_t                                                    `DECLARE_RESET_FLOP(hdrinfo, '0);
   logic                                                                    `DECLARE_RESET_FLOP(prev_frame_phd, 0);
   logic [`LOG_VEC(`N_MAX_SMALL_HUFF_BITS+1)]                               `DECLARE_RESET_FLOP(prev_small_bl, 0);
   logic [`LOG_VEC(`N_XP9_SHRT_SYMBOLS+1)]                                  `DECLARE_RESET_FLOP(bl_count, 0);
   logic [`LOG_VEC(`N_XP9_SHRT_SYMBOLS)]                                    `DECLARE_RESET_FLOP(bl_index, 0);
   logic [15:0][`LOG_VEC(`N_MAX_HUFF_BITS+1)]                               `DECLARE_RESET_FLOP(prev_bl, 0);
   logic [`LOG_VEC(`N_MAX_HUFF_BITS+1)]                                     `DECLARE_RESET_FLOP(prev_non_zero_bl, 8);

   
   assign small_blt_hist_complete_deflate = r_hdrinfo.fmt inside {HTF_FMT_DEFLATE_DYNAMIC, HTF_FMT_DEFLATE_FIXED};

   
   
   typedef struct packed {
      logic [`LOG_VEC(MAX_BL_PER_CYCLE+1)] count; 
      logic [`BIT_VEC(MAX_BL_PER_CYCLE)][`LOG_VEC(`N_MAX_HUFF_BITS+1)] bl; 
      logic                                                            eot;
      logic                                                            eob;
      logic                                                            err;
      logic                                                            null_bl;
   } bl_fifo_t;

   logic                                                                    bl_fifo_wen;
   bl_fifo_t                                                                bl_fifo_wdata;
   logic                                                                    bl_fifo_afull;
   logic [`BIT_VEC(2)]                                                      bl_fifo_free_slots;
   logic                                                                    bl_fifo_empty;
   bl_fifo_t                                                                bl_fifo_rdata;

   logic [`LOG_VEC(MAX_BL_PER_CYCLE+1)]                                     bl_unpacker_src_items_valid;
   logic                                                                    bl_unpacker_src_ready;
   bl_fifo_t [`BIT_VEC(MAX_BL_PER_CYCLE)]                                   bl_unpacker_src_data;
   logic                                                                    bl_unpacker_src_last;
   logic [`LOG_VEC(9+1)]                                                    bl_unpacker_dst_items_avail;
   logic [`LOG_VEC(9+1)]                                                    bl_unpacker_dst_items_consume;
   bl_fifo_t [`BIT_VEC(9)]                                                  bl_unpacker_dst_data; 
   logic                                                                    bl_unpacker_dst_last;

   
   
   
   

   
   logic [1:0]                                                              `DECLARE_RESET_FLOP(section_num, 0);
   logic [3:0][`LOG_VEC(`N_MAX_HUFF_BITS+1)]                                `DECLARE_RESET_FLOP(section_bl, 0);
   
   logic [2:0][`LOG_VEC(`N_MAX_SUPPORTED_SYMBOLS)]                               `DECLARE_RESET_FLOP(section_end_idx, 0);
   
   htf_symtab_state_t `DECLARE_RESET_FLOP(state, 1 << SYMTAB_IDLE);
   htf_symtab_state_e decoded_state;
   always_comb begin
      for (int i=0; i<$bits(r_state); i++) begin
         if (r_state[i])
           decoded_state = htf_symtab_state_e'(i);
      end
   end
   htf_symtab_sub_state_t `DECLARE_RESET_FLOP(sub_state, 1 << HUFFMAN);
   htf_symtab_sub_state_e decoded_sub_state;
   always_comb begin
      for (int i=0; i<$bits(r_sub_state); i++) begin
         if (r_sub_state[i])
           decoded_sub_state = htf_symtab_sub_state_e'(i);
      end
   end
   logic [6:0] `DECLARE_RESET_FLOP(repeat_count, 0);
   

   
   logic `DECLARE_RESET_OUT_FLOP(xp9_simple_short_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(xp9_retro_short_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(xp9_simple_long_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(xp9_retro_long_blk_stb, 0);

   logic `DECLARE_RESET_OUT_FLOP(xp10_simple_short_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(xp10_retro_short_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(xp10_predef_short_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(xp10_simple_long_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(xp10_retro_long_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(xp10_predef_long_blk_stb, 0);

   logic `DECLARE_RESET_OUT_FLOP(chu4k_simple_short_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(chu4k_retro_short_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(chu4k_predef_short_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(chu4k_simple_long_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(chu4k_retro_long_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(chu4k_predef_long_blk_stb, 0);

   logic `DECLARE_RESET_OUT_FLOP(chu8k_simple_short_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(chu8k_retro_short_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(chu8k_predef_short_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(chu8k_simple_long_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(chu8k_retro_long_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(chu8k_predef_long_blk_stb, 0);

   logic `DECLARE_RESET_OUT_FLOP(deflate_dynamic_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(deflate_fixed_blk_stb, 0);
   logic `DECLARE_RESET_OUT_FLOP(hdr_info_stall_stb, 0);

   logic                hdrinfo_valid;
   bhp_htf_hdrinfo_bus_t hdrinfo_bus;
   logic                hdrinfo_ready;
   axi_channel_reg_slice
     #(.PAYLD_WIDTH($bits(bhp_htf_hdrinfo_bus_t)),
       .HNDSHK_MODE(`AXI_RS_FULL))
   u_hdrinfo_reg_slice
     (.aclk (clk),
      .aresetn (rst_n),
      .valid_src (bhp_htf_hdrinfo_valid),
      .payload_src (bhp_htf_hdrinfo_bus),
      .ready_src (htf_bhp_hdrinfo_ready),
      .valid_dst (hdrinfo_valid),
      .payload_dst (hdrinfo_bus),
      .ready_dst (hdrinfo_ready));

   logic                status_valid;
   htf_bhp_status_bus_t status_bus;
   logic                status_ready;
   axi_channel_reg_slice
     #(.PAYLD_WIDTH($bits(htf_bhp_status_bus_t)),
       .HNDSHK_MODE(`AXI_RS_REV))
   u_status_reg_slice
     (.aclk (clk),
      .aresetn (rst_n),
      .valid_dst (htf_bhp_status_valid),
      .payload_dst (htf_bhp_status_bus),
      .ready_dst (bhp_htf_status_ready),
      .valid_src (status_valid),
      .payload_src (status_bus),
      .ready_src (status_ready));

   assign status_valid = r_status_valid;
   assign status_bus = r_status_bus;

   logic        im_valid;
   htf_bl_out_t im_data;
   logic        im_ready;
   axi_channel_reg_slice
     #(.PAYLD_WIDTH($bits(htf_bl_out_t)),
       .HNDSHK_MODE(`AXI_RS_FULL))
   u_im_reg_slice
     (.aclk (clk),
      .aresetn (rst_n),
      .valid_dst (htf_bl_im_valid),
      .payload_dst (htf_bl_im_data),
      .ready_dst (htf_bl_im_ready),
      .valid_src (im_valid),
      .payload_src (im_data),
      .ready_src (im_ready));

   logic [6:0]                                retro_repeat_count;
   htf_symtab_sub_state_t                     retro_sub_state;
   logic [`LOG_VEC(`N_XP9_SHRT_SYMBOLS+1)]    retro_bl_count;
   logic [`LOG_VEC(`N_XP9_SHRT_SYMBOLS)]      retro_bl_index;
   logic [15:0][`LOG_VEC(`N_MAX_HUFF_BITS+1)] retro_prev_bl;
   logic [`LOG_VEC(`N_MAX_HUFF_BITS+1)]       retro_prev_non_zero_bl;
   htf_symtab_state_t                         retro_state;
   logic [`LOG_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS+1)] retro_hdr_bits_consume;
   logic [`LOG_VEC(BL_PER_CYCLE+1)]                        retro_blt_hist_wen;
   logic [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(`N_MAX_HUFF_BITS+1)] retro_blt_hist_wdata;
   logic                                                        retro_blt_hist_complete_valid;
   logic                                                        retro_status_valid;
   htf_bhp_status_bus_t                                         retro_status_bus;

   logic                                                        retro_go;

   
   cr_xp10_decomp_htf_symtab_dec_retro
     #(.BL_PER_CYCLE(BL_PER_CYCLE))
   u_retro
     (
      
      .o_repeat_count                   (retro_repeat_count),    
      .o_sub_state                      (retro_sub_state),       
      .o_bl_count                       (retro_bl_count),        
      .o_bl_index                       (retro_bl_index),        
      .o_prev_bl                        (retro_prev_bl),         
      .o_prev_non_zero_bl               (retro_prev_non_zero_bl), 
      .o_state                          (retro_state),           
      .o_hdr_bits_consume               (retro_hdr_bits_consume), 
      .o_blt_hist_wen                   (retro_blt_hist_wen),    
      .o_blt_hist_wdata                 (retro_blt_hist_wdata),  
      .o_blt_hist_complete_valid        (retro_blt_hist_complete_valid), 
      .o_status_valid                   (retro_status_valid),    
      .o_status_bus                     (retro_status_bus),      
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .small_blt                        (small_blt),
      .small_smt                        (small_smt),
      .small_svt                        (small_svt),
      .fmt                              (r_hdrinfo.fmt),         
      .retro_go                         (retro_go),
      .i_repeat_count                   (r_repeat_count),        
      .i_sub_state                      (r_sub_state),           
      .i_bl_count                       (r_bl_count),            
      .i_bl_index                       (r_bl_index),            
      .i_prev_bl                        (r_prev_bl),             
      .i_prev_non_zero_bl               (r_prev_non_zero_bl),    
      .i_state                          (r_state),               
      .hdr_bits_data                    (hdr_bits_data[`BIT_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS)]));

   
   
   
   
   always_comb begin
      
      reordered_codelen_data = r_codelen_data[`BIT_VEC($bits(reordered_codelen_data))];
      
      reordered_codelen_data = {reordered_codelen_data[2],
                                reordered_codelen_data[1],
                                reordered_codelen_data[0],
                                reordered_codelen_data[18],
                                reordered_codelen_data[16],
                                reordered_codelen_data[14],
                                reordered_codelen_data[12],
                                reordered_codelen_data[10],
                                reordered_codelen_data[8],
                                reordered_codelen_data[6],
                                reordered_codelen_data[4],
                                reordered_codelen_data[5],
                                reordered_codelen_data[7],
                                reordered_codelen_data[9],
                                reordered_codelen_data[11],
                                reordered_codelen_data[13],
                                reordered_codelen_data[15],
                                reordered_codelen_data[17],
                                reordered_codelen_data[3]};
      
   end

   always_comb begin
      logic v_bits_avail;

      `DEFAULT_FLOP(state);
      `DEFAULT_FLOP(total_bit_count);
      `DEFAULT_FLOP(status_valid);
      `DEFAULT_FLOP(status_bus);
      `DEFAULT_FLOP(bl_count);
      `DEFAULT_FLOP(bl_index);
      `DEFAULT_FLOP(hdrinfo);
      `DEFAULT_FLOP(prev_frame_phd);
      `DEFAULT_FLOP(prev_small_bl);
      `DEFAULT_FLOP(sub_state);
      `DEFAULT_FLOP(repeat_count);
      `DEFAULT_FLOP(prev_bl);
      `DEFAULT_FLOP(prev_non_zero_bl);
      `DEFAULT_FLOP(blt_hist_wdata);
      `DEFAULT_FLOP(blt_hist_complete_fmt);
      `DEFAULT_FLOP(blt_hist_complete_min_ptr_len);
      `DEFAULT_FLOP(blt_hist_complete_min_mtf_len);
      `DEFAULT_FLOP(blt_hist_complete_sched_info);
      `DEFAULT_FLOP(blt_hist_complete_total_bit_count);
      `DEFAULT_FLOP(blt_hist_complete_error);
      `DEFAULT_FLOP(section_num);
      `DEFAULT_FLOP(section_bl);
      `DEFAULT_FLOP(section_end_idx);
      `DEFAULT_FLOP(hclen);
      `DEFAULT_FLOP(hdist);
      `DEFAULT_FLOP(hlit);
      `DEFAULT_FLOP(codelen_data);

      c_xp9_simple_short_blk_stb = 0;
      c_xp9_retro_short_blk_stb = 0;
      c_xp9_simple_long_blk_stb = 0;
      c_xp9_retro_long_blk_stb = 0;

      c_xp10_simple_short_blk_stb = 0;
      c_xp10_retro_short_blk_stb = 0;
      c_xp10_predef_short_blk_stb = 0;
      c_xp10_simple_long_blk_stb = 0;
      c_xp10_retro_long_blk_stb = 0;
      c_xp10_predef_long_blk_stb = 0;

      c_chu4k_simple_short_blk_stb = 0;
      c_chu4k_retro_short_blk_stb = 0;
      c_chu4k_predef_short_blk_stb = 0;
      c_chu4k_simple_long_blk_stb = 0;
      c_chu4k_retro_long_blk_stb = 0;
      c_chu4k_predef_long_blk_stb = 0;

      c_chu8k_simple_short_blk_stb = 0;
      c_chu8k_retro_short_blk_stb = 0;
      c_chu8k_predef_short_blk_stb = 0;
      c_chu8k_simple_long_blk_stb = 0;
      c_chu8k_retro_long_blk_stb = 0;
      c_chu8k_predef_long_blk_stb = 0;

      c_deflate_dynamic_blk_stb = 0;
      c_deflate_fixed_blk_stb = 0;
      c_hdr_info_stall_stb = 0;

      c_status_valid_dly = r_status_valid;

      hdrinfo_ready = 0;
      hdr_bits_consume = 0;
      predef_bl_rsp_bits_consume = 0;
      predef_bl_done = 0;
      c_blt_hist_wen = 0;
      c_blt_hist_complete_valid = 0;
      c_blt_hist_start_valid = 0;

      predef_bl_req_valid = 0;
      predef_bl_req_ll = 0;
      predef_bl_req_num_bl = 0;

      hdr_clear = 0;

      c_small_blt_hist_complete_valid = 0;
      c_small_blt_hist_start_valid = 0;
      c_small_blt_hist_wen = 0;
      c_small_blt_hist_wdata = {SMALL_BL_PER_CYCLE{r_prev_small_bl}};

      retro_go = 0;

      
      
      
      if ((hdr_bits_avail == $bits(hdr_bits_data)) || hdr_bits_last)
        v_bits_avail = 1;
      else
        v_bits_avail = 0;

      
      
      
      
      if (!bl_fifo_afull) begin
         unique case (1'b1)
           r_state[WAIT_FOR_STATUS_READY]: begin
              if (status_ready) begin
                 c_status_valid = 0;
                 
                 
                 hdr_clear = 1;
                 if (r_status_bus.error != NO_ERRORS)
                   c_state = 1 << STATUS_ERROR;
                 else
                   c_state = 1 << SYMTAB_IDLE;
              end
           end 
           r_state[STATUS_ERROR]: begin
              if (!blt_hist_busy && small_tables_done) begin
                 c_blt_hist_complete_valid = 1;
                 c_state = 1 << SYMTAB_IDLE;
              end
           end
           r_state[SYMTAB_IDLE]: begin
              if (hdrinfo_valid) begin
                 c_hdrinfo = hdrinfo_bus;
                 hdrinfo_ready = 1;
                 c_total_bit_count = 0;
                 c_status_bus.error = NO_ERRORS;
                 case (hdrinfo_bus.fmt)
                   HTF_FMT_XP10: begin
                      c_state = 1 << XP10_SS_HEADER;
                   end
                   HTF_FMT_XP9: begin
                      c_state = 1 << XP9_SS_HEADER;
                   end
                   HTF_FMT_RAW: begin
                      c_state = 1 << RAW_BLOCK;
                   end
                   HTF_FMT_DEFLATE_DYNAMIC: begin
                      c_state = 1 << DEFLATE_HEADER;
                      c_deflate_dynamic_blk_stb = hdrinfo_bus.trace_bit;
                   end
                   default: begin 
                      c_state = 1 << DEFLATE_HLIT_FIXED;
                      c_deflate_fixed_blk_stb = hdrinfo_bus.trace_bit;
                      c_bl_index = 0;
                      c_bl_count = `N_LENLIT_SYMBOLS;
                      c_section_bl[0] = 8;
                      c_section_bl[1] = 9;
                      c_section_bl[2] = 7;
                      c_section_bl[3] = 8;
                      c_section_end_idx[0] = 143;
                      c_section_end_idx[1] = 255;
                      c_section_end_idx[2] = 279;
                      c_section_num = 0;
                   end
                 endcase 

                 if (hdrinfo_bus.sof_blk) begin
                    if (r_prev_frame_phd)
                      predef_bl_done = 1;
                    c_prev_frame_phd = hdrinfo_bus.phd_present;
                 end
              end 
           end 
           r_state[RAW_BLOCK]: begin
              if (!blt_hist_busy) begin
                 c_blt_hist_complete_valid = 1;
                 
                 c_state = 1 << SYMTAB_IDLE;
              end
           end
           r_state[DEFLATE_HEADER]: begin
              if (v_bits_avail) begin
                 c_hlit = hdr_bits_data[4:0] + 257;
                 c_hdist = hdr_bits_data[9:5] + 1;
                 c_hclen = hdr_bits_data[13:10] + 4;
                 hdr_bits_consume = 14;
                 c_state = 1 << DEFLATE_GET_CODELEN;
                 
                 c_bl_count = c_hclen * $clog2(`N_MAX_CODELEN_HUFF_BITS+1); 
                 c_bl_index = 0;
                 c_codelen_data = '0;
              end 
           end 
           r_state[DEFLATE_GET_CODELEN]: begin
              if (v_bits_avail) begin
                 
                 if (r_bl_count < $bits(hdr_bits_data))
                   hdr_bits_consume = $bits(hdr_bits_consume)'(r_bl_count);
                 else
                   hdr_bits_consume = hdr_bits_avail;
                 
                 c_codelen_data[r_bl_index[`LOG_VEC(`N_CODELEN_SYMBOLS*3)] +: $bits(hdr_bits_data)] = hdr_bits_data & $bits(hdr_bits_data)'( ~('1 << hdr_bits_consume)); 
                 
                 c_bl_index = $bits(r_bl_index)'(r_bl_index + hdr_bits_consume);
                 c_bl_count = $bits(r_bl_count)'(r_bl_count - hdr_bits_consume);
                 if (c_bl_count == 0) begin
                    c_state = 1 << DEFLATE_WRITE_CODELEN;
                    c_bl_index = 0;
                    c_bl_count = $bits(r_bl_count)'(`N_CODELEN_SYMBOLS);
                 end
              end 
           end 
           r_state[DEFLATE_WRITE_CODELEN]: begin
              for (int i=0; i<SMALL_BL_PER_CYCLE; i++) begin
                 if (r_bl_count > i) begin
                    c_small_blt_hist_wen++;
                    c_small_blt_hist_wdata[i] = $bits(r_prev_small_bl)'(reordered_codelen_data[c_bl_index]); 
                    c_bl_count--;
                    c_bl_index++;
                 end
              end
              if (c_bl_count == 0) begin
                 
                 c_small_blt_hist_complete_valid = 1;
                 c_sub_state = 1 << HUFFMAN;
                 c_bl_index = 0;
                 c_prev_non_zero_bl = 0;
                 c_repeat_count = 0;
                 c_bl_count = $bits(r_bl_count)'(r_hlit);
                 c_state = 1 << DEFLATE_HLIT_DYNAMIC;
              end 
           end
           r_state[XP9_SS_HEADER], r_state[XP9_LL_HEADER]: begin
              if (v_bits_avail) begin
                 hdr_bits_consume = $bits(xp9_symbol_encode_e);
                 c_bl_index = 0;
                 case (xp9_symbol_encode_e'(hdr_bits_data[`BIT_VEC($bits(xp9_symbol_encode_e))]))
                   XP9_RETROSPECTIVE: begin
                      if (r_state[XP9_SS_HEADER]) begin
                         c_state = 1 << XP_SS_DELTA_DECODE;
                         c_xp9_retro_short_blk_stb = r_hdrinfo.trace_bit;
                      end
                      else begin
                         c_state = 1 << XP_LL_DELTA_DECODE;
                         c_xp9_retro_long_blk_stb = r_hdrinfo.trace_bit;
                      end
                      c_prev_small_bl = 4;
                      c_bl_count = `N_SMALL_SYMBOLS;
                   end
                   XP9_SIMPLE: begin
                      assert #0 (r_hdrinfo.winsize == 0) else `ERROR("received hdrinfo with illegal xp9 winsize");
                      
                      c_section_num = 0;
                      if (r_state[XP9_SS_HEADER]) begin
                         c_state = 1 << XP_SS_SIMPLE;
                         c_bl_count = `N_XP10_64K_SHRT_SYMBOLS;
                         c_section_bl[0] = 9;
                         c_section_bl[1] = 10;
                         c_section_end_idx[0] = 319;
                         c_xp9_simple_short_blk_stb = r_hdrinfo.trace_bit;
                      end
                      else begin
                         c_state = 1 << XP_LL_SIMPLE;
                         c_bl_count = `N_XP10_64K_LONG_SYMBOLS;
                         c_section_bl[0] = 8;
                         c_section_bl[1] = 9;
                         c_section_end_idx[0] = 255;
                         c_xp9_simple_long_blk_stb = r_hdrinfo.trace_bit;
                      end
                   end
                   default: begin
                      c_status_valid = 1;
                      c_status_bus.error = HD_HTF_XP9_RESERVED_SYMBOL_TABLE_ENCODING;
                   end
                 endcase
              end 
           end 
           r_state[XP10_SS_HEADER], r_state[XP10_LL_HEADER]: begin
              if (v_bits_avail) begin
                 hdr_bits_consume = $bits(xp10_symbol_encode_e);
                 c_bl_index = 0;
                 case (xp10_symbol_encode_e'(hdr_bits_data[`BIT_VEC($bits(xp10_symbol_encode_e))]))
                   XP10_PREDEFINED: begin
                      if (!r_prev_frame_phd) begin
                         c_status_valid = 1;
                         c_status_bus.error = HD_HTF_XP10_PREDEF_SYMBOL_TABLE_ENCODING;
                      end
                      else begin
                         predef_bl_req_valid = 1;
                         predef_bl_req_ll = r_state[XP10_LL_HEADER];
                         
                         if (r_state[XP10_SS_HEADER]) begin
                            case (r_hdrinfo.winsize)
                              0: predef_bl_req_num_bl = `N_XP10_4K_SHRT_SYMBOLS;
                              1: predef_bl_req_num_bl = `N_XP10_8K_SHRT_SYMBOLS;
                              2: predef_bl_req_num_bl = `N_XP10_16K_SHRT_SYMBOLS;
                              3: predef_bl_req_num_bl = `N_XP10_64K_SHRT_SYMBOLS;
                              default: begin
                                 `ERROR("received hdrinfo with illegal winsize");
                              end
                            endcase
                         end
                         else begin
                            case (r_hdrinfo.winsize)
                              0: predef_bl_req_num_bl = `N_XP10_4K_LONG_SYMBOLS;
                              1: predef_bl_req_num_bl = `N_XP10_8K_LONG_SYMBOLS;
                              2: predef_bl_req_num_bl = `N_XP10_16K_LONG_SYMBOLS;
                              3: predef_bl_req_num_bl = `N_XP10_64K_LONG_SYMBOLS;
                              default: begin
                                 `ERROR("received hdrinfo with illegal winsize");
                              end
                            endcase
                         end
                         
                         if (predef_bl_req_ready) begin
                            if (r_state[XP10_SS_HEADER]) begin
                               c_state = 1 << SS_PREDEF;
                               c_bl_count = predef_bl_req_num_bl;
                               if (r_hdrinfo.sub_fmt == HTF_SUB_FMT_NORMAL_GZIP)
                                 c_xp10_predef_short_blk_stb = r_hdrinfo.trace_bit;
                               else if (r_hdrinfo.sub_fmt == HTF_SUB_FMT_CHU4K_ZLIB)
                                 c_chu4k_predef_short_blk_stb = r_hdrinfo.trace_bit;
                               else
                                 c_chu8k_predef_short_blk_stb = r_hdrinfo.trace_bit;
                            end
                            else begin
                               c_state = 1 << LL_PREDEF;
                               c_bl_count = predef_bl_req_num_bl;
                               if (r_hdrinfo.sub_fmt == HTF_SUB_FMT_NORMAL_GZIP)
                                 c_xp10_predef_long_blk_stb = r_hdrinfo.trace_bit;
                               else if (r_hdrinfo.sub_fmt == HTF_SUB_FMT_CHU4K_ZLIB)
                                 c_chu4k_predef_long_blk_stb = r_hdrinfo.trace_bit;
                               else
                                 c_chu8k_predef_long_blk_stb = r_hdrinfo.trace_bit;
                            end
                         end 
                      end 
                   end 
                   XP10_RETROSPECTIVE: begin
                      if (r_state[XP10_SS_HEADER]) begin
                         c_state = 1 << XP_SS_DELTA_DECODE;
                         if (r_hdrinfo.sub_fmt == HTF_SUB_FMT_NORMAL_GZIP)
                           c_xp10_retro_short_blk_stb = r_hdrinfo.trace_bit;
                         else if (r_hdrinfo.sub_fmt == HTF_SUB_FMT_CHU4K_ZLIB)
                           c_chu4k_retro_short_blk_stb = r_hdrinfo.trace_bit;
                         else
                           c_chu8k_retro_short_blk_stb = r_hdrinfo.trace_bit;
                      end
                      else begin
                         c_state = 1 << XP_LL_DELTA_DECODE;
                         if (r_hdrinfo.sub_fmt == HTF_SUB_FMT_NORMAL_GZIP)
                           c_xp10_retro_long_blk_stb = r_hdrinfo.trace_bit;
                         else if (r_hdrinfo.sub_fmt == HTF_SUB_FMT_CHU4K_ZLIB)
                           c_chu4k_retro_long_blk_stb = r_hdrinfo.trace_bit;
                         else
                           c_chu8k_retro_long_blk_stb = r_hdrinfo.trace_bit;
                      end
                      c_prev_small_bl = 4;
                      c_bl_count = `N_SMALL_SYMBOLS;
                   end
                   XP10_SIMPLE: begin
                      logic [`LOG_VEC(`N_XP9_SHRT_SYMBOLS+1)] v_shrt_bl_count;
                      logic [`LOG_VEC(`N_XP9_LONG_SYMBOLS+1)] v_long_bl_count;
                      logic [`LOG_VEC(`N_MAX_HUFF_BITS+1)]    v_shrt_simple_bl;
                      logic [`LOG_VEC(`N_MAX_SUPPORTED_SYMBOLS)] v_shrt_simple_split_index;
                      logic [`LOG_VEC(`N_MAX_HUFF_BITS+1)]       v_long_simple_bl;
                      logic [`LOG_VEC(`N_MAX_SUPPORTED_SYMBOLS)] v_long_simple_split_index;
                      case (r_hdrinfo.winsize)
                        0: begin
                           v_shrt_bl_count            = `N_XP10_4K_SHRT_SYMBOLS;
                           v_shrt_simple_bl           = 9;
                           v_shrt_simple_split_index  = 511;
                           v_long_bl_count            = `N_XP10_4K_LONG_SYMBOLS;
                           v_long_simple_bl           = 7;
                           v_long_simple_split_index  = 11;
                        end
                        1: begin
                           v_shrt_bl_count            = `N_XP10_8K_SHRT_SYMBOLS;
                           v_shrt_simple_bl           = 9;
                           v_shrt_simple_split_index  = 495;
                           v_long_bl_count            = `N_XP10_8K_LONG_SYMBOLS;
                           v_long_simple_bl           = 7;
                           v_long_simple_split_index  = 10;
                        end
                        2: begin
                           v_shrt_bl_count            = `N_XP10_16K_SHRT_SYMBOLS;
                           v_shrt_simple_bl           = 9;
                           v_shrt_simple_split_index  = 479;
                           v_long_bl_count            = `N_XP10_16K_LONG_SYMBOLS;
                           v_long_simple_bl           = 7;
                           v_long_simple_split_index  = 9;
                        end
                        default: begin
                           assert #0 (r_hdrinfo.winsize==3) else `ERROR("received hdrinfo with illegal xp10 winsize");
                           v_shrt_bl_count            = `N_XP10_64K_SHRT_SYMBOLS;
                           v_shrt_simple_bl           = 9;
                           v_shrt_simple_split_index  = 447;
                           v_long_bl_count            = `N_XP10_64K_LONG_SYMBOLS;
                           v_long_simple_bl           = 7;
                           v_long_simple_split_index  = 7;
                        end
                      endcase 
                      c_section_num = 0;
                      if (r_state[XP10_SS_HEADER]) begin
                         c_state = 1 << XP_SS_SIMPLE;
                         c_bl_count = v_shrt_bl_count;
                         c_section_bl[0] = v_shrt_simple_bl;
                         c_section_bl[1] = v_shrt_simple_bl + 1;
                         c_section_end_idx[0] = v_shrt_simple_split_index;
                         if (r_hdrinfo.sub_fmt == HTF_SUB_FMT_NORMAL_GZIP)
                           c_xp10_simple_short_blk_stb = r_hdrinfo.trace_bit;
                         else if (r_hdrinfo.sub_fmt == HTF_SUB_FMT_CHU4K_ZLIB)
                           c_chu4k_simple_short_blk_stb = r_hdrinfo.trace_bit;
                         else
                           c_chu8k_simple_short_blk_stb = r_hdrinfo.trace_bit;
                      end
                      else begin
                         c_state = 1 << XP_LL_SIMPLE;
                         c_bl_count = $bits(r_bl_count)'(v_long_bl_count);
                         c_section_bl[0] = v_long_simple_bl;
                         c_section_bl[1] = v_long_simple_bl + 1;
                         c_section_end_idx[0] = v_long_simple_split_index;
                         if (r_hdrinfo.sub_fmt == HTF_SUB_FMT_NORMAL_GZIP)
                           c_xp10_simple_long_blk_stb = r_hdrinfo.trace_bit;
                         else if (r_hdrinfo.sub_fmt == HTF_SUB_FMT_CHU4K_ZLIB)
                           c_chu4k_simple_long_blk_stb = r_hdrinfo.trace_bit;
                         else
                           c_chu8k_simple_long_blk_stb = r_hdrinfo.trace_bit;
                      end
                   end
                   default: begin
                      c_status_valid = 1;
                      c_status_bus.error = HD_HTF_XP10_RESERVED_SYMBOL_TABLE_ENCODING;
                   end
                 endcase
              end 
           end 
           r_state[SS_PREDEF], r_state[LL_PREDEF]: begin
              if ((predef_bl_rsp_bits_avail!=0) &&
                  !blt_hist_busy) begin
                 c_blt_hist_wen = ($bits(r_blt_hist_wen))'(`MIN(r_bl_count, BL_PER_CYCLE));
                 predef_bl_rsp_bits_consume = XP_BL_WIDTH*BL_PER_CYCLE; 
                 for (int i=0; i<BL_PER_CYCLE; i++)
                   c_blt_hist_wdata[i] = { << {predef_bl_rsp_bits_data[i*XP_BL_WIDTH +: XP_BL_WIDTH]}};  
                 
                 c_bl_count = $bits(r_bl_count)'(r_bl_count - BL_PER_CYCLE); 
                 c_bl_index = $bits(r_bl_count)'(r_bl_index + BL_PER_CYCLE); 
                 if (r_bl_count <= BL_PER_CYCLE) begin
                    c_blt_hist_complete_valid = 1;
                    predef_bl_rsp_bits_consume = predef_bl_rsp_bits_avail; 
                    if (r_state[SS_PREDEF]) begin
                       c_state = 1 << XP10_LL_HEADER;
                    end
                    else begin
                       c_status_valid = 1;
                       c_status_bus.error = NO_ERRORS;
                    end
                    
                 end 
              end 
           end 
           r_state[XP_SS_DELTA_DECODE], r_state[XP_LL_DELTA_DECODE]: begin
              if (v_bits_avail) begin
                 logic [`LOG_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS+1)] v_hdr_bits_avail;
                 logic [`BIT_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS)]   v_hdr_bits_data;

                 v_hdr_bits_avail = hdr_bits_avail;
                 v_hdr_bits_data = hdr_bits_data;
                 hdr_bits_consume = 0;
                 
                 
                 
                 
                 for (int i=0; i<SMALL_BL_PER_CYCLE; i++) begin
                    if (r_bl_count > i) begin
                       if (v_hdr_bits_data[0] == 0) begin
                          c_small_blt_hist_wdata[i] = c_prev_small_bl;
                          hdr_bits_consume++; 
                          v_hdr_bits_avail--; 
                          v_hdr_bits_data >>= 1; 
                       end
                       else begin
                          if ({1'b0, v_hdr_bits_data[3:1]} < c_prev_small_bl)
                            c_small_blt_hist_wdata[i] = {1'b0, v_hdr_bits_data[3:1]};
                          else
                            c_small_blt_hist_wdata[i] = v_hdr_bits_data[3:1]+1;
                          c_prev_small_bl = c_small_blt_hist_wdata[i];
                          hdr_bits_consume += 4; 
                          v_hdr_bits_avail -= 4; 
                          v_hdr_bits_data >>= 4; 
                       end 
                       c_small_blt_hist_wen++;
                       c_bl_count--;
                       c_bl_index++;
                    end 
                 end 
                 if (c_bl_count == 0) begin
                    
                    c_small_blt_hist_complete_valid = 1;
                    c_sub_state = 1 << HUFFMAN;
                    c_bl_index = 0;
                    c_prev_non_zero_bl = 8;
                    c_repeat_count = 0;
                    if (r_state[XP_SS_DELTA_DECODE]) begin
                       c_state = 1 << XP_SS_RETRO_DECODE;
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
                       c_state = 1 << XP_LL_RETRO_DECODE;
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
           end 
           r_state[XP_SS_RETRO_DECODE], r_state[XP_LL_RETRO_DECODE], r_state[DEFLATE_HLIT_DYNAMIC], r_state[DEFLATE_HDIST_DYNAMIC]: begin
              if (small_tables_done) begin
                 if (small_tables_error) begin
                    c_status_valid = 1;
                    c_status_bus.error = HD_HTF_ILLEGAL_SMALL_HUFFTREE;
                 end
                 else if (!blt_hist_busy && v_bits_avail) begin
                    retro_go = 1; 
                    
                    c_repeat_count = retro_repeat_count;
                    c_sub_state = retro_sub_state;
                    c_bl_count = retro_bl_count;
                    c_bl_index = retro_bl_index;
                    c_prev_bl = retro_prev_bl;
                    c_prev_non_zero_bl = retro_prev_non_zero_bl;
                    c_state = retro_state;
                    
                    c_status_valid = retro_status_valid;
                    c_status_bus = retro_status_bus;

                    c_blt_hist_wen = retro_blt_hist_wen;
                    c_blt_hist_wdata = retro_blt_hist_wdata;
                    c_blt_hist_complete_valid = retro_blt_hist_complete_valid;
                    
                    hdr_bits_consume = retro_hdr_bits_consume;
                 end 
              end 
           end 
           r_state[XP_SS_SIMPLE], r_state[XP_LL_SIMPLE], r_state[DEFLATE_HLIT_FIXED], r_state[DEFLATE_HDIST_FIXED]: begin
              
              if (!blt_hist_busy) begin
                 c_blt_hist_wen =  ($bits(r_blt_hist_wen))'(`MIN(r_bl_count, BL_PER_CYCLE));
                 for (int i=0; i<BL_PER_CYCLE; i++) begin
                    c_blt_hist_wdata[i] = c_section_bl[c_section_num];
                    if ((c_section_num != 3) && (c_bl_index == c_section_end_idx[c_section_num])) 
                      c_section_num++;
                    c_bl_index++;
                 end
                 
                 c_bl_count = $bits(r_bl_count)'(r_bl_count - BL_PER_CYCLE);
                 if (r_bl_count <= BL_PER_CYCLE) begin
                    c_blt_hist_complete_valid = 1;
                    if (r_state[XP_SS_SIMPLE]) begin
                       if (r_hdrinfo.fmt == HTF_FMT_XP9)
                         c_state = 1 << XP9_LL_HEADER;
                       else
                         c_state = 1 << XP10_LL_HEADER;
                    end
                    else if (r_state[XP_LL_SIMPLE]) begin
                       c_status_valid = 1;
                       c_status_bus.error = NO_ERRORS;
                    end
                    else if (r_state[DEFLATE_HLIT_FIXED]) begin
                       c_state = 1 << DEFLATE_WAIT_FIXED;
                    end
                    else begin 
                       
                       c_state = 1 << SYMTAB_IDLE;
                    end
                 end 
              end 
           end 
           r_state[DEFLATE_WAIT_DYNAMIC]: begin
              c_state = 1 << DEFLATE_HDIST_DYNAMIC;
              c_bl_index = 0;
              c_bl_count = $bits(r_bl_count)'(r_hdist);
              
              
           end
           r_state[DEFLATE_WAIT_FIXED]: begin
              c_state = 1 << DEFLATE_HDIST_FIXED;
              c_bl_index = 0;
              c_bl_count = `N_DIST_SYMBOLS;
              c_section_bl[0] = 5;
              c_section_end_idx[0] = `N_DIST_SYMBOLS-1;
              c_section_num = 0;
           end
         endcase 
      end 

      if (hdr_bits_err) begin
         
         c_status_valid = 1;
         c_status_bus.error = HD_HTF_HDR_UNDERRUN;
         
         
         c_blt_hist_complete_valid = 0;
      end

      if ((c_blt_hist_wen != 0) && (r_bl_index == 0)) begin
         c_blt_hist_start_valid = 1;
      end

      if ((c_small_blt_hist_wen != 0) && (r_bl_index == 0)) begin
         c_small_blt_hist_start_valid = 1;
      end

      c_total_bit_count = $bits(r_total_bit_count)'(c_total_bit_count + hdr_bits_consume); 
      c_status_bus.size = c_total_bit_count;
      if (c_status_valid && !r_status_valid) begin
         c_state = 1 << WAIT_FOR_STATUS_READY;
      end 

      if (c_blt_hist_complete_valid) begin
         c_blt_hist_complete_fmt = r_hdrinfo.fmt;
         c_blt_hist_complete_min_ptr_len = r_hdrinfo.min_ptr_len;
         c_blt_hist_complete_min_mtf_len = r_hdrinfo.min_mtf_len;
         c_blt_hist_complete_total_bit_count = c_total_bit_count;
         c_blt_hist_complete_sched_info.hdr_bits_in = r_hdrinfo.hdr_bits_in;
         c_blt_hist_complete_sched_info.rqe_sched_handle = r_hdrinfo.rqe_sched_handle;
         c_blt_hist_complete_sched_info.tlv_frame_num = r_hdrinfo.tlv_frame_num;
         c_blt_hist_complete_sched_info.tlv_eng_id = r_hdrinfo.tlv_eng_id;
         c_blt_hist_complete_sched_info.tlv_seq_num = r_hdrinfo.tlv_seq_num;
         c_blt_hist_complete_error = c_status_bus.error != NO_ERRORS;
      end

      c_hdr_info_stall_stb = hdrinfo_valid && !hdrinfo_ready && hdrinfo_bus.trace_bit;

   end 

   

   cr_xp10_decomp_htf_small_tables
     #(.SMALL_BL_PER_CYCLE(SMALL_BL_PER_CYCLE))
   u_small_tables
     (
      
      .small_blt                        (small_blt),
      .small_smt                        (small_smt),
      .small_svt                        (small_svt),
      .small_tables_done                (small_tables_done),
      .small_tables_error               (small_tables_error),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .small_blt_hist_start_valid       (c_small_blt_hist_start_valid), 
      .small_blt_hist_complete_valid    (c_small_blt_hist_complete_valid), 
      .small_blt_hist_complete_deflate  (small_blt_hist_complete_deflate),
      .small_blt_hist_wen               (c_small_blt_hist_wen),  
      .small_blt_hist_wdata             (c_small_blt_hist_wdata)); 



   
   

   
   
   assign bl_fifo_afull = (bl_fifo_free_slots == 0) || ((bl_fifo_free_slots == 1) && bl_fifo_wen);

   `ASSERT_PROPERTY((r_blt_hist_wen==0) || (r_small_blt_hist_wen==0)) else `ERROR("can't generate small and regular BLT entry on the same cycle");


   always_comb begin
      bl_fifo_wen = 0;
      bl_fifo_wdata = '0;
      bl_fifo_wdata.count = r_blt_hist_wen | r_small_blt_hist_wen;
      if ((bl_fifo_wdata.count != 0) || 
          ((r_hdrinfo.fmt != HTF_FMT_RAW) && r_blt_hist_complete_valid)) begin
         bl_fifo_wen = 1;
         bl_fifo_wdata.eot = r_blt_hist_complete_valid || r_small_blt_hist_complete_valid;
         bl_fifo_wdata.eob = r_state[SYMTAB_IDLE] || r_state[WAIT_FOR_STATUS_READY];
         bl_fifo_wdata.err = bl_fifo_wdata.eob && (r_status_bus.error != NO_ERRORS);
         bl_fifo_wdata.null_bl = bl_fifo_wdata.count == 0;
      end

      if (r_blt_hist_wen != 0) begin
         for (int i=0; i<BL_PER_CYCLE; i++)
           bl_fifo_wdata.bl[i] = r_blt_hist_wdata[i];
      end
      else if (r_small_blt_hist_wen != 0) begin
         for (int i=0; i<SMALL_BL_PER_CYCLE; i++)
           bl_fifo_wdata.bl[i] = r_small_blt_hist_wdata[i]; 
      end
   end

   
   nx_fifo
     #(.DEPTH(3),
       .WIDTH($bits(bl_fifo_t)))
   u_bl_fifo
     (
      
      .empty                            (bl_fifo_empty),         
      .full                             (),                      
      .underflow                        (),                      
      .overflow                         (),                      
      .used_slots                       (),                      
      .free_slots                       (bl_fifo_free_slots),    
      .rdata                            (bl_fifo_rdata),         
      
      .clk                              (clk),                   
      .rst_n                            (rst_n),                 
      .wen                              (bl_fifo_wen),           
      .ren                              (!bl_fifo_empty && bl_unpacker_src_ready), 
      .clear                            ({1{1'b0}}),             
      .wdata                            (bl_fifo_wdata));         

   

   
   

   always_comb begin
      

      bl_unpacker_src_items_valid = 0;
      bl_unpacker_src_last = 0;
      bl_unpacker_src_data = '0;
      for (int i=0; i<MAX_BL_PER_CYCLE; i++) begin
         
         
         
         bl_unpacker_src_data[i].bl[0] = bl_fifo_rdata.bl[i];
         bl_unpacker_src_data[i].eot = bl_fifo_rdata.eot;
         bl_unpacker_src_data[i].eob = bl_fifo_rdata.eob;
         bl_unpacker_src_data[i].err = bl_fifo_rdata.err;
         bl_unpacker_src_data[i].null_bl = bl_fifo_rdata.null_bl;
      end

      if (!bl_fifo_empty) begin
         if (bl_fifo_rdata.count == 0) begin
            
            
            assert #0 (bl_fifo_rdata.err || (bl_fifo_rdata.null_bl && bl_fifo_rdata.eot)) else `ERROR("if count==0, then either an error must have been encountered, OR this is the terminal entry for an XP9 bl table");
            bl_unpacker_src_items_valid = 1;
         end
         else
           bl_unpacker_src_items_valid = bl_fifo_rdata.count;

         if (bl_fifo_rdata.eot || bl_fifo_rdata.eob)
           bl_unpacker_src_last = 1;
      end 


      
      bl_unpacker_dst_items_consume = 0;
      im_valid = 0;
      im_data = '0;

      if ((bl_unpacker_dst_items_avail == 9) ||
          ((bl_unpacker_dst_items_avail != 0) && bl_unpacker_dst_last)) begin
         logic [7:0] v_bl_mask;
         im_valid = 1;

         v_bl_mask = ~('1 << bl_unpacker_dst_items_avail);
         
         if (bl_unpacker_dst_data[bl_unpacker_dst_items_avail-1].null_bl) 
           bl_unpacker_dst_items_consume = bl_unpacker_dst_items_avail;
         else
           bl_unpacker_dst_items_consume = `MIN(8, bl_unpacker_dst_items_avail);

         im_data.eob = bl_unpacker_dst_data[bl_unpacker_dst_items_consume-1].eob;
         im_data.eot = bl_unpacker_dst_data[bl_unpacker_dst_items_consume-1].eot;
         im_data.err = bl_unpacker_dst_data[bl_unpacker_dst_items_consume-1].err;
         if (v_bl_mask[0])
           im_data.bl0 = 8'(bl_unpacker_dst_data[0].bl[0]);
         if (v_bl_mask[1])
           im_data.bl1 = 8'(bl_unpacker_dst_data[1].bl[0]);
         if (v_bl_mask[2])
           im_data.bl2 = 8'(bl_unpacker_dst_data[2].bl[0]);
         if (v_bl_mask[3])
           im_data.bl3 = 8'(bl_unpacker_dst_data[3].bl[0]);
         if (v_bl_mask[4])
           im_data.bl4 = 8'(bl_unpacker_dst_data[4].bl[0]);
         if (v_bl_mask[5])
           im_data.bl5 = 8'(bl_unpacker_dst_data[5].bl[0]);
         if (v_bl_mask[6])
           im_data.bl6 = 8'(bl_unpacker_dst_data[6].bl[0]);
         if (v_bl_mask[7])
           im_data.bl7 = 8'(bl_unpacker_dst_data[7].bl[0]);

         if (!im_ready)
           bl_unpacker_dst_items_consume = 0;
      end

   end

   cr_xp10_decomp_unpacker
     #(.IN_ITEMS(MAX_BL_PER_CYCLE),
       .OUT_ITEMS(9),
       .MAX_CONSUME_ITEMS(9),
       .BITS_PER_ITEM($bits(bl_fifo_t)))
   u_bl_unpacker
     (
      
      .src_ready                        (bl_unpacker_src_ready), 
      .dst_items_avail                  (bl_unpacker_dst_items_avail), 
      .dst_data                         (bl_unpacker_dst_data),  
      .dst_last                         (bl_unpacker_dst_last),  
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .src_items_valid                  (bl_unpacker_src_items_valid), 
      .src_data                         (bl_unpacker_src_data),  
      .src_last                         (bl_unpacker_src_last),  
      .dst_items_consume                (bl_unpacker_dst_items_consume), 
      .clear                            (1'b0));                  
                                         

`undef DECLARE_RESET_FLOP
`undef DECLARE_FLOP
`undef DEFAULT_FLOP
`undef DECLARE_RESET_OUT_FLOP

endmodule 







