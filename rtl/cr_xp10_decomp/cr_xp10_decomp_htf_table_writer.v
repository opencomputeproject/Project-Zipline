/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp_htf_table_writer (
   
   blt_hist_busy, htf_sdd_complete_valid, htf_sdd_complete_fmt,
   htf_sdd_complete_min_ptr_len, htf_sdd_complete_min_mtf_len,
   htf_sdd_complete_sched_info, htf_sdd_complete_error,
   htf_sdd_bct_sat_wen, htf_sdd_bct_sat_type, htf_sdd_bct_sat_addr,
   htf_sdd_bct_valid, htf_sdd_bct_data, htf_sdd_sat_data,
   htf_sdd_ss_slt_wen, htf_sdd_ss_slt_addr, htf_sdd_ss_slt_data,
   htf_sdd_ll_slt_wen, htf_sdd_ll_slt_addr, htf_sdd_ll_slt_data,
   
   clk, rst_n, blt_hist_complete_valid, blt_hist_complete_fmt,
   blt_hist_complete_min_ptr_len, blt_hist_complete_min_mtf_len,
   blt_hist_complete_total_bit_count, blt_hist_complete_sched_info,
   blt_hist_complete_error, histogram, blt, blt_depth, sdd_htf_busy
   );

   parameter BL_PER_CYCLE = 2;

   import crPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;

   
   
   
   input         clk;
   input         rst_n;

   
   
   
   
   
   input         blt_hist_complete_valid;
   input         htf_fmt_e blt_hist_complete_fmt;
   input         blt_hist_complete_min_ptr_len;
   input         blt_hist_complete_min_mtf_len;
   input [`LOG_VEC(`N_HTF_HDR_FIFO_DEPTH*`AXI_S_DP_DWIDTH+1)] blt_hist_complete_total_bit_count;
   input         sched_info_t blt_hist_complete_sched_info;
   input         blt_hist_complete_error;
   output logic  blt_hist_busy;

   input [`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`BIT_VEC($clog2(`N_MAX_SUPPORTED_SYMBOLS))] histogram;
   input [`BIT_VEC(`N_MAX_SUPPORTED_SYMBOLS)][`LOG_VEC(`N_MAX_HUFF_BITS+1)]               blt;
   input [`LOG_VEC(`N_MAX_SUPPORTED_SYMBOLS)]                                             blt_depth;
   
   
   
   
   output logic                               htf_sdd_complete_valid;
   output                                     htf_fmt_e htf_sdd_complete_fmt;
   output logic                               htf_sdd_complete_min_ptr_len;
   output logic                               htf_sdd_complete_min_mtf_len;
   output                                     sched_info_t htf_sdd_complete_sched_info;
   
   
   
   
   
   
   output logic                               htf_sdd_complete_error;
   
   input                                      sdd_htf_busy;
   
   
   
   
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

   logic                               `DECLARE_RESET_OUT_FLOP(htf_sdd_complete_valid, '0);
   htf_fmt_e                           `DECLARE_RESET_OUT_FLOP(htf_sdd_complete_fmt, HTF_FMT_XP10);
   logic                               `DECLARE_RESET_OUT_FLOP(htf_sdd_complete_min_ptr_len, '0);
   logic                               `DECLARE_RESET_OUT_FLOP(htf_sdd_complete_min_mtf_len, '0);
   sched_info_t                        `DECLARE_RESET_OUT_FLOP(htf_sdd_complete_sched_info, '0);
   logic                               `DECLARE_RESET_OUT_FLOP(htf_sdd_complete_error, '0);

   logic                             `DECLARE_RESET_OUT_FLOP(htf_sdd_bct_sat_wen, '0);
   logic                             `DECLARE_RESET_OUT_FLOP(htf_sdd_bct_sat_type, '0);
   logic [`LOG_VEC(`N_MAX_HUFF_BITS+1)] `DECLARE_RESET_OUT_FLOP(htf_sdd_bct_sat_addr, '0);
   logic                             `DECLARE_RESET_OUT_FLOP(htf_sdd_bct_valid, '0);
   logic [`N_MAX_HUFF_BITS-2:0]         `DECLARE_RESET_OUT_FLOP(htf_sdd_bct_data, '0);
   logic [`LOG_VEC(`N_MAX_SUPPORTED_SYMBOLS)]     `DECLARE_RESET_OUT_FLOP(htf_sdd_sat_data, '0);
   
   logic [`BIT_VEC(BL_PER_CYCLE)] `DECLARE_RESET_OUT_FLOP(htf_sdd_ss_slt_wen, '0);
   logic [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] `DECLARE_RESET_OUT_FLOP(htf_sdd_ss_slt_addr, '0);
   logic [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] `DECLARE_RESET_OUT_FLOP(htf_sdd_ss_slt_data, '0);

   logic [`BIT_VEC(BL_PER_CYCLE)] `DECLARE_RESET_OUT_FLOP(htf_sdd_ll_slt_wen, '0);
   logic [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)] `DECLARE_RESET_OUT_FLOP(htf_sdd_ll_slt_addr, '0);
   logic [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)] `DECLARE_RESET_OUT_FLOP(htf_sdd_ll_slt_data, '0);

   logic                                                                          hist_complete;
   logic                                                                          ss_pointer_wen;
   logic                                                                          ss_pointer_complete;
   logic                                                                          ll_pointer_wen;
   logic                                                                          ll_pointer_complete;
   logic                                                                          slt_abort;
   logic                                                                          ss_slt_last;
   logic                                                                          ll_slt_last;                                                                         
   logic                                                                          bct_sat_last;
   logic                                                                          bct_sat_error;
   logic [`LOG_VEC(`N_MAX_HUFF_BITS+1)]                                           hist_depth;
   
   enum logic [2:0] {WAIT_FOR_SS_BLT_HIST_COMPLETE=0,
                     SS_BCT_SAT=1,
                     WAIT_FOR_LL_BLT_HIST_COMPLETE=2,
                     LL_BCT_SAT=3,
                     WAIT_FOR_SLT_LAST=4,
                     RAW_COMPLETE=5} `DECLARE_RESET_FLOP(state, WAIT_FOR_SS_BLT_HIST_COMPLETE);

   logic `DECLARE_RESET_FLOP(blt_hist_busy, '0);
   logic `DECLARE_RESET_FLOP(error, '0);
   logic `DECLARE_RESET_FLOP(blt_hist_complete_valid, '0);
   logic `DECLARE_RESET_FLOP(ss_slt_last, '0);
   logic `DECLARE_RESET_FLOP(ll_slt_last, '0);
   logic `DECLARE_RESET_FLOP(at_least_1_bct_valid, 0);
   logic [`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS+1)] `DECLARE_RESET_FLOP(ss_blt_depth, '0);
   logic [`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS+1)] `DECLARE_RESET_FLOP(ll_blt_depth, '0);
   
   assign blt_hist_busy = r_blt_hist_busy;

   `ASSERT_PROPERTY(r_blt_hist_complete_valid -> !blt_hist_complete_valid) else `ERROR("can't get another blt_hist_complete_valid indication without servicing the prior one!");

   always_comb begin
      `DEFAULT_FLOP(state);
      `DEFAULT_FLOP(blt_hist_busy);
      `DEFAULT_FLOP(error);
      `DEFAULT_FLOP(blt_hist_complete_valid);
      `DEFAULT_FLOP(htf_sdd_complete_fmt);
      `DEFAULT_FLOP(htf_sdd_complete_min_ptr_len);
      `DEFAULT_FLOP(htf_sdd_complete_min_mtf_len);
      `DEFAULT_FLOP(htf_sdd_complete_sched_info);
      `DEFAULT_FLOP(ss_slt_last);
      `DEFAULT_FLOP(ll_slt_last);
      `DEFAULT_FLOP(ss_blt_depth);
      `DEFAULT_FLOP(ll_blt_depth);
      `DEFAULT_FLOP(at_least_1_bct_valid);

      hist_complete = 0;
      c_htf_sdd_bct_sat_type = 0;
      ss_pointer_wen = 0;
      ll_pointer_wen = 0;
      ss_pointer_complete = 0;
      ll_pointer_complete = 0;
      slt_abort = 0;
      c_htf_sdd_complete_valid = 0;
      c_htf_sdd_complete_error = 0;

      c_blt_hist_complete_valid = r_blt_hist_complete_valid || blt_hist_complete_valid;

      c_ss_slt_last = r_ss_slt_last || ss_slt_last;
      c_ll_slt_last = r_ll_slt_last || ll_slt_last;

      if (blt_hist_complete_valid) begin
         assert #0 (!r_blt_hist_busy) else `ERROR("can't complete a new blt/hist while busy");
         c_blt_hist_busy = 1'b1;
      end

      case (r_state)
        WAIT_FOR_SS_BLT_HIST_COMPLETE: begin
           if (c_blt_hist_complete_valid && !sdd_htf_busy && !r_htf_sdd_complete_valid) begin
              c_blt_hist_complete_valid = 0;
              c_htf_sdd_complete_fmt = blt_hist_complete_fmt;
              c_htf_sdd_complete_min_ptr_len = blt_hist_complete_min_ptr_len;
              c_htf_sdd_complete_min_mtf_len = blt_hist_complete_min_mtf_len;
              c_htf_sdd_complete_sched_info = blt_hist_complete_sched_info;
              c_htf_sdd_complete_sched_info.hdr_bits_in += blt_hist_complete_total_bit_count; 
              c_error = 0;
              if (blt_hist_complete_error) begin
                 c_blt_hist_busy = 0;
                 c_htf_sdd_complete_valid = 1;
                 c_htf_sdd_complete_error = 1;
              end
              else if (blt_hist_complete_fmt == HTF_FMT_RAW) begin
                 c_state = RAW_COMPLETE;
              end
              else begin
                 hist_complete = 1;
                 c_state = SS_BCT_SAT;
                 c_at_least_1_bct_valid = 0;
              end
           end
        end 
        SS_BCT_SAT, LL_BCT_SAT: begin
           if (c_htf_sdd_bct_sat_wen) begin
              c_at_least_1_bct_valid |= c_htf_sdd_bct_valid; 
              if (bct_sat_last || bct_sat_error) begin
                 c_blt_hist_busy = 0;
                 c_error = r_error | bct_sat_error;
                 slt_abort = c_error;
                 if (r_state == SS_BCT_SAT) begin
                    
                    
                    c_state = WAIT_FOR_LL_BLT_HIST_COMPLETE;
                    ss_pointer_complete = 1;
                    c_ss_slt_last = 0;
                    if (!c_at_least_1_bct_valid) begin
                       c_error = 1;
                       slt_abort = 1;
                    end
                 end
                 else begin
                    ll_pointer_complete = 1;
                    c_state = WAIT_FOR_SLT_LAST;
                    c_ll_slt_last = 0;
                 end
              end
           end

           if (r_state == LL_BCT_SAT) begin
              c_htf_sdd_bct_sat_type = 1;
              ll_pointer_wen = c_htf_sdd_bct_sat_wen;
              c_ll_blt_depth = $bits(r_ll_blt_depth)'(blt_depth);
           end
           else begin
              ss_pointer_wen = c_htf_sdd_bct_sat_wen;
              c_ss_blt_depth = blt_depth;
           end
        end 
        WAIT_FOR_LL_BLT_HIST_COMPLETE: begin
           if (c_blt_hist_complete_valid) begin
              c_blt_hist_complete_valid = 0;
              c_htf_sdd_complete_sched_info = blt_hist_complete_sched_info;
              c_htf_sdd_complete_sched_info.hdr_bits_in += blt_hist_complete_total_bit_count; 
              if (blt_hist_complete_error || r_error) begin
                 slt_abort = 1;
                 c_blt_hist_busy = 0;
                 c_htf_sdd_complete_valid = 1;
                 c_htf_sdd_complete_error = 1;
                 c_state = WAIT_FOR_SS_BLT_HIST_COMPLETE;
              end
              else begin
                 hist_complete = 1;
                 c_state = LL_BCT_SAT;
                 c_at_least_1_bct_valid = 0;
              end
           end
        end 
        WAIT_FOR_SLT_LAST: begin
           if (r_error || (c_ss_slt_last && c_ll_slt_last)) begin
              c_htf_sdd_complete_valid = 1;
              c_htf_sdd_complete_error = r_error;
              c_state = WAIT_FOR_SS_BLT_HIST_COMPLETE;
           end
        end
        RAW_COMPLETE: begin
           c_htf_sdd_complete_valid = 1;
           c_htf_sdd_complete_error = 0;
           c_state = WAIT_FOR_SS_BLT_HIST_COMPLETE;
           c_blt_hist_busy = 0;
        end
      endcase 

      case (r_htf_sdd_complete_fmt)
        HTF_FMT_XP10, HTF_FMT_XP9: begin
           hist_depth = `N_MAX_XP_HUFF_BITS;
        end
        default: begin
           hist_depth = `N_MAX_DEFLATE_HUFF_BITS;
        end
      endcase 

   end
               
   

   cr_xp10_decomp_htf_bct_sat_writer
     #(.MAX_DEPTH(`N_MAX_HUFF_BITS),
       .WIDTH($clog2(`N_MAX_SUPPORTED_SYMBOLS+1)))
   bct_sat_writer
     (
      
      .bct_sat_wen                      (c_htf_sdd_bct_sat_wen), 
      .bct_sat_addr                     (c_htf_sdd_bct_sat_addr[`LOG_VEC((`N_MAX_HUFF_BITS)+1)]), 
      .bct_sat_last                     (bct_sat_last),          
      .bct_valid                        (c_htf_sdd_bct_valid),   
      .bct_data                         (c_htf_sdd_bct_data[`BIT_VEC((`N_MAX_HUFF_BITS)-1)]), 
      .sat_data                         (c_htf_sdd_sat_data[`BIT_VEC(($clog2(`N_MAX_SUPPORTED_SYMBOLS+1)))]), 
      .bct_sat_error                    (bct_sat_error),         
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .hist_complete                    (hist_complete),
      .hist_depth                       (hist_depth[`LOG_VEC((`N_MAX_HUFF_BITS)+1)]),
      .histogram                        (histogram));

   logic [`BIT_VEC(`N_XP10_64K_SHRT_SYMBOLS)][`LOG_VEC(`N_MAX_HUFF_BITS+1)] ss_blt;
   logic [`BIT_VEC(`N_XP10_64K_LONG_SYMBOLS)][`LOG_VEC(`N_MAX_HUFF_BITS+1)] ll_blt;

   assign ss_blt = blt;
   always_comb begin
      for (int i=0; i<`N_XP10_64K_LONG_SYMBOLS; i++)
        ll_blt[i] = blt[i];
   end

   

   

   cr_xp10_decomp_htf_slt_writer
     #(.MAX_BLT_DEPTH(`N_XP10_64K_SHRT_SYMBOLS), 
       .MAX_POINTER_DEPTH(`N_MAX_HUFF_BITS),
       .BL_PER_CYCLE(BL_PER_CYCLE))
   u_ss_slt_writer
     (
      
      .slt_wen                          (c_htf_sdd_ss_slt_wen),  
      .slt_addr                         (c_htf_sdd_ss_slt_addr), 
      .slt_data                         (c_htf_sdd_ss_slt_data), 
      .slt_last                         (ss_slt_last),           
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .pointer_wen                      (ss_pointer_wen),        
      .pointer_addr                     (c_htf_sdd_bct_sat_addr[`LOG_VEC((`N_MAX_HUFF_BITS)+1)]), 
      .pointer_data                     (c_htf_sdd_sat_data[`LOG_VEC((`N_XP10_64K_SHRT_SYMBOLS))]), 
      .pointer_complete                 (ss_pointer_complete),   
      .blt_depth                        (r_ss_blt_depth[`LOG_VEC((`N_XP10_64K_SHRT_SYMBOLS)+1)]), 
      .blt                              (ss_blt),                
      .abort                            (slt_abort));             

   

   cr_xp10_decomp_htf_slt_writer
     #(.MAX_BLT_DEPTH(`N_XP10_64K_LONG_SYMBOLS), 
       .MAX_POINTER_DEPTH(`N_MAX_HUFF_BITS),
       .BL_PER_CYCLE(BL_PER_CYCLE))
   u_ll_slt_writer
     (
      
      .slt_wen                          (c_htf_sdd_ll_slt_wen),  
      .slt_addr                         (c_htf_sdd_ll_slt_addr), 
      .slt_data                         (c_htf_sdd_ll_slt_data), 
      .slt_last                         (ll_slt_last),           
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .pointer_wen                      (ll_pointer_wen),        
      .pointer_addr                     (c_htf_sdd_bct_sat_addr[`LOG_VEC((`N_MAX_HUFF_BITS)+1)]), 
      .pointer_data                     (c_htf_sdd_sat_data[`LOG_VEC((`N_XP10_64K_LONG_SYMBOLS))]), 
      .pointer_complete                 (ll_pointer_complete),   
      .blt_depth                        (r_ll_blt_depth[`LOG_VEC((`N_XP10_64K_LONG_SYMBOLS)+1)]), 
      .blt                              (ll_blt),                
      .abort                            (slt_abort));             
   


`undef DECLARE_FLOP
`undef DECLARE_RESET_FLOP
`undef DEFAULT_FLOP
`undef DECLARE_RESET_OUT_FLOP

endmodule 







