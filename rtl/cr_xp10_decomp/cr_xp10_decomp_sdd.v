/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp_sdd (
   
   sdd_lfa_dp_ready, sdd_lfa_ack_valid, sdd_lfa_ack_bus,
   sdd_mtf_dp_valid, sdd_mtf_dp_bus, xp10_decomp_sch_update,
   sdd_htf_busy, input_stall_stb, buf_full_stall_stb, mtf_stb,
   
   clk, rst_n, lfa_sdd_dp_valid, lfa_sdd_dp_bus, mtf_sdd_dp_ready,
   htf_sdd_bct_sat_wen, htf_sdd_bct_sat_type, htf_sdd_bct_sat_addr,
   htf_sdd_bct_valid, htf_sdd_bct_data, htf_sdd_sat_data,
   htf_sdd_ss_slt_wen, htf_sdd_ss_slt_addr, htf_sdd_ss_slt_data,
   htf_sdd_ll_slt_wen, htf_sdd_ll_slt_addr, htf_sdd_ll_slt_data,
   su_afull_n, htf_sdd_complete_valid, htf_sdd_complete_fmt,
   htf_sdd_complete_min_ptr_len, htf_sdd_complete_min_mtf_len,
   htf_sdd_complete_sched_info, htf_sdd_complete_error
   );

   parameter BL_PER_CYCLE=2;
   parameter FPGA_MOD=0;

   import crPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   
   
   
   input         clk;
   input         rst_n; 
   
   
   
   

   
   
   
   input logic   lfa_sdd_dp_valid;
   input         lfa_sdd_dp_bus_t lfa_sdd_dp_bus;
   output        sdd_lfa_dp_ready;

   
   
   
   output logic  sdd_lfa_ack_valid;
   output        sdd_lfa_ack_bus_t sdd_lfa_ack_bus;

   
   
   
   output logic sdd_mtf_dp_valid;
   output       lz_symbol_bus_t sdd_mtf_dp_bus;
   input logic  mtf_sdd_dp_ready;

   
   
   
   input                             htf_sdd_bct_sat_wen;
   input                             htf_sdd_bct_sat_type;
   input [`LOG_VEC(`N_MAX_HUFF_BITS+1)] htf_sdd_bct_sat_addr;
   input                             htf_sdd_bct_valid;
   input [`N_MAX_HUFF_BITS-2:0]         htf_sdd_bct_data;
   input [`LOG_VEC(`N_MAX_SUPPORTED_SYMBOLS)]     htf_sdd_sat_data;
   
   
   
   

   input [`BIT_VEC(BL_PER_CYCLE)] htf_sdd_ss_slt_wen;
   input [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] htf_sdd_ss_slt_addr;
   input [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] htf_sdd_ss_slt_data;

   input [`BIT_VEC(BL_PER_CYCLE)] htf_sdd_ll_slt_wen;
   input [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)] htf_sdd_ll_slt_addr;
   input [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)] htf_sdd_ll_slt_data;

   
   
   
   output        sched_update_if_bus_t xp10_decomp_sch_update;
   input         su_afull_n;

   
   
   
   input                               htf_sdd_complete_valid;
   input                               htf_fmt_e htf_sdd_complete_fmt;
   input                               htf_sdd_complete_min_ptr_len;
   input                               htf_sdd_complete_min_mtf_len;
   input                               sched_info_t htf_sdd_complete_sched_info;
   
   
   
   
   
   
   input                               htf_sdd_complete_error;

   output logic                        sdd_htf_busy;

   
   output logic                        input_stall_stb;
   output logic                        buf_full_stall_stb;
   output logic [3:0]                  mtf_stb;

   
`ifdef SHOULD_BE_EMPTY
   
   
`endif

   
   
   logic [1:0]          block_error;            
   htf_fmt_e [1:0]      block_fmt;              
   logic [1:0]          block_min_mtf_len;      
   logic [1:0]          block_min_ptr_len;      
   logic                decoder_eob_credit_used;
   logic                decoder_sob_credit_avail;
   logic                decoder_sob_credit_used;
   logic                lanes_wf_ready;         
   logic [`BIT_VEC(N_SDD_BIT_BUF_WORDS)] [31:0] ld_bit_buf;
   sdd_ld_pipe_t        ld_ss_data;             
   logic                ld_ss_valid;            
   logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS,1)] [`BIT_VEC(`N_MAX_HUFF_BITS-1)] ll_bct;
   logic [1:0] [`BIT_VEC_BASE(`N_MAX_HUFF_BITS,1)] ll_bct_valid;
   logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS,1)] [`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)] ll_sat;
   logic [1:0][`BIT_VEC(`N_XP10_64K_LONG_SYMBOLS)] [`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)] ll_slt;
   logic [1:0] [`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS+1)] ll_used_symbols;
   sched_info_t         sched_info_rdata;       
   logic                sched_info_ren;         
   logic [`BIT_VEC($clog2(N_SDD_BIT_BUF_WORDS)+1)] sp_buf_idx;
   logic                sp_ss_ready;            
   logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS,1)] [`BIT_VEC(`N_MAX_HUFF_BITS-1)] ss_bct;
   logic [1:0] [`BIT_VEC_BASE(`N_MAX_HUFF_BITS,1)] ss_bct_valid;
   logic                ss_ld_ready;            
   logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS,1)] [`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] ss_sat;
   logic [1:0][`BIT_VEC(`N_XP10_64K_SHRT_SYMBOLS)] [`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] ss_slt;
   sdd_ss_pipe_t        ss_sp_data;             
   logic                ss_sp_valid;            
   logic [1:0] [`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS+1)] ss_used_symbols;
   logic [127:0]        wf_lanes_data;          
   logic                wf_lanes_eob;           
   logic                wf_lanes_eof;           
   zipline_error_e       wf_lanes_errcode;       
   logic [27:0]         wf_lanes_frame_bytes_in;
   logic                wf_lanes_last_frame;    
   logic [7:0]          wf_lanes_numbits;       
   logic                wf_lanes_sob;           
   logic                wf_lanes_trace_bit;     
   logic                wf_lanes_valid;         
   

   cr_xp10_decomp_sdd_dec_tables
     #(.BL_PER_CYCLE(BL_PER_CYCLE),
       .FPGA_MOD(FPGA_MOD))
   u_dec_tables
     (
      
      .sdd_htf_busy                     (sdd_htf_busy),
      .ss_bct                           (ss_bct),
      .ss_bct_valid                     (ss_bct_valid),
      .ss_sat                           (ss_sat),
      .ss_slt                           (ss_slt),
      .ss_used_symbols                  (ss_used_symbols),
      .ll_bct                           (ll_bct),
      .ll_bct_valid                     (ll_bct_valid),
      .ll_sat                           (ll_sat),
      .ll_slt                           (ll_slt),
      .ll_used_symbols                  (ll_used_symbols),
      .block_fmt                        (block_fmt[1:0]),
      .block_min_ptr_len                (block_min_ptr_len[1:0]),
      .block_min_mtf_len                (block_min_mtf_len[1:0]),
      .block_error                      (block_error[1:0]),
      .sched_info_rdata                 (sched_info_rdata),
      .decoder_sob_credit_avail         (decoder_sob_credit_avail),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
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
      .htf_sdd_complete_valid           (htf_sdd_complete_valid),
      .htf_sdd_complete_fmt             (htf_sdd_complete_fmt),
      .htf_sdd_complete_min_ptr_len     (htf_sdd_complete_min_ptr_len),
      .htf_sdd_complete_min_mtf_len     (htf_sdd_complete_min_mtf_len),
      .htf_sdd_complete_sched_info      (htf_sdd_complete_sched_info),
      .htf_sdd_complete_error           (htf_sdd_complete_error),
      .sched_info_ren                   (sched_info_ren),
      .decoder_sob_credit_used          (decoder_sob_credit_used),
      .decoder_eob_credit_used          (decoder_eob_credit_used));
   
   cr_xp10_decomp_sdd_wf u_wf
     (
      
      .sdd_lfa_dp_ready                 (sdd_lfa_dp_ready),
      .wf_lanes_valid                   (wf_lanes_valid),
      .wf_lanes_data                    (wf_lanes_data[127:0]),
      .wf_lanes_numbits                 (wf_lanes_numbits[7:0]),
      .wf_lanes_sob                     (wf_lanes_sob),
      .wf_lanes_eob                     (wf_lanes_eob),
      .wf_lanes_eof                     (wf_lanes_eof),
      .wf_lanes_trace_bit               (wf_lanes_trace_bit),
      .wf_lanes_frame_bytes_in          (wf_lanes_frame_bytes_in[27:0]),
      .wf_lanes_last_frame              (wf_lanes_last_frame),
      .wf_lanes_errcode                 (wf_lanes_errcode),
      .input_stall_stb                  (input_stall_stb),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .lfa_sdd_dp_valid                 (lfa_sdd_dp_valid),
      .lfa_sdd_dp_bus                   (lfa_sdd_dp_bus),
      .lanes_wf_ready                   (lanes_wf_ready));

   cr_xp10_decomp_sdd_ld u_ld
     (
      
      .lanes_wf_ready                   (lanes_wf_ready),
      .decoder_sob_credit_used          (decoder_sob_credit_used),
      .decoder_eob_credit_used          (decoder_eob_credit_used),
      .ld_ss_valid                      (ld_ss_valid),
      .ld_ss_data                       (ld_ss_data),
      .ld_bit_buf                       (ld_bit_buf),
      .buf_full_stall_stb               (buf_full_stall_stb),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .wf_lanes_valid                   (wf_lanes_valid),
      .wf_lanes_data                    (wf_lanes_data[127:0]),
      .wf_lanes_numbits                 (wf_lanes_numbits[7:0]),
      .wf_lanes_sob                     (wf_lanes_sob),
      .wf_lanes_eob                     (wf_lanes_eob),
      .wf_lanes_eof                     (wf_lanes_eof),
      .wf_lanes_trace_bit               (wf_lanes_trace_bit),
      .wf_lanes_frame_bytes_in          (wf_lanes_frame_bytes_in[27:0]),
      .wf_lanes_last_frame              (wf_lanes_last_frame),
      .wf_lanes_errcode                 (wf_lanes_errcode),
      .ss_bct                           (ss_bct),
      .ss_bct_valid                     (ss_bct_valid),
      .ss_sat                           (ss_sat),
      .ss_slt                           (ss_slt),
      .ss_used_symbols                  (ss_used_symbols),
      .ll_bct                           (ll_bct),
      .ll_bct_valid                     (ll_bct_valid),
      .ll_sat                           (ll_sat),
      .ll_slt                           (ll_slt),
      .ll_used_symbols                  (ll_used_symbols),
      .block_fmt                        (block_fmt[1:0]),
      .block_min_ptr_len                (block_min_ptr_len[1:0]),
      .block_min_mtf_len                (block_min_mtf_len[1:0]),
      .block_error                      (block_error[1:0]),
      .decoder_sob_credit_avail         (decoder_sob_credit_avail),
      .ss_ld_ready                      (ss_ld_ready),
      .sp_buf_idx                       (sp_buf_idx[`BIT_VEC($clog2(N_SDD_BIT_BUF_WORDS)+1)]));

   cr_xp10_decomp_sdd_ss u_ss
     (
      
      .ss_ld_ready                      (ss_ld_ready),
      .ss_sp_valid                      (ss_sp_valid),
      .ss_sp_data                       (ss_sp_data),
      .sdd_lfa_ack_valid                (sdd_lfa_ack_valid),
      .sdd_lfa_ack_bus                  (sdd_lfa_ack_bus),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .ld_ss_valid                      (ld_ss_valid),
      .ld_ss_data                       (ld_ss_data),
      .sp_ss_ready                      (sp_ss_ready));

   cr_xp10_decomp_sdd_sp u_sp
     (
      
      .sp_ss_ready                      (sp_ss_ready),
      .sdd_mtf_dp_valid                 (sdd_mtf_dp_valid),
      .sdd_mtf_dp_bus                   (sdd_mtf_dp_bus),
      .sp_buf_idx                       (sp_buf_idx[`BIT_VEC($clog2(N_SDD_BIT_BUF_WORDS)+1)]),
      .mtf_stb                          (mtf_stb[3:0]),
      .sched_info_ren                   (sched_info_ren),
      .xp10_decomp_sch_update           (xp10_decomp_sch_update),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .ss_sp_valid                      (ss_sp_valid),
      .ss_sp_data                       (ss_sp_data),
      .mtf_sdd_dp_ready                 (mtf_sdd_dp_ready),
      .ld_bit_buf                       (ld_bit_buf),
      .sched_info_rdata                 (sched_info_rdata),
      .su_afull_n                       (su_afull_n));

endmodule 







