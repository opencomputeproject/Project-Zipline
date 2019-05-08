/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp_sdd_dec_tables (
   
   sdd_htf_busy, ss_bct, ss_bct_valid, ss_sat, ss_slt,
   ss_used_symbols, ll_bct, ll_bct_valid, ll_sat, ll_slt,
   ll_used_symbols, block_fmt, block_min_ptr_len, block_min_mtf_len,
   block_error, sched_info_rdata, decoder_sob_credit_avail,
   
   clk, rst_n, htf_sdd_bct_sat_wen, htf_sdd_bct_sat_type,
   htf_sdd_bct_sat_addr, htf_sdd_bct_valid, htf_sdd_bct_data,
   htf_sdd_sat_data, htf_sdd_ss_slt_wen, htf_sdd_ss_slt_addr,
   htf_sdd_ss_slt_data, htf_sdd_ll_slt_wen, htf_sdd_ll_slt_addr,
   htf_sdd_ll_slt_data, htf_sdd_complete_valid, htf_sdd_complete_fmt,
   htf_sdd_complete_min_ptr_len, htf_sdd_complete_min_mtf_len,
   htf_sdd_complete_sched_info, htf_sdd_complete_error,
   sched_info_ren, decoder_sob_credit_used, decoder_eob_credit_used
   );

   parameter BL_PER_CYCLE = 2;
   parameter FPGA_MOD = 0;
   
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   
   
   
   input         clk;
   input         rst_n; 

   
   
   
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

   
   
   
   input                               htf_sdd_complete_valid;
   input                               htf_fmt_e htf_sdd_complete_fmt;
   input                               htf_sdd_complete_min_ptr_len;
   input                               htf_sdd_complete_min_mtf_len;
   input                               sched_info_t  htf_sdd_complete_sched_info;
   
   
   
   
   
   
   input                               htf_sdd_complete_error;

   output logic                        sdd_htf_busy;

   
   
   
   
   output logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`BIT_VEC(`N_MAX_HUFF_BITS-1)]       ss_bct;
   output logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)]                                     ss_bct_valid;
   output logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] ss_sat;
   output logic [1:0][`BIT_VEC(`N_XP10_64K_SHRT_SYMBOLS)][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] ss_slt;
   output logic [1:0][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS+1)]                                   ss_used_symbols;

   output logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`BIT_VEC(`N_MAX_HUFF_BITS-1)]       ll_bct;
   output logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)]                                     ll_bct_valid;
   output logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)] ll_sat;
   output logic [1:0][`BIT_VEC(`N_XP10_64K_LONG_SYMBOLS)][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)] ll_slt;
   output logic [1:0][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS+1)]                                   ll_used_symbols;

   output                              htf_fmt_e [1:0] block_fmt;
   output logic [1:0]                  block_min_ptr_len;
   output logic [1:0]                  block_min_mtf_len;
   output logic [1:0]                  block_error;

   input                               sched_info_ren;
   output                              sched_info_t sched_info_rdata;

   
   
   
   
   
   
   output logic decoder_sob_credit_avail;
   input  decoder_sob_credit_used;

   
   
   input  decoder_eob_credit_used;
   
   
   
   
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


   logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`BIT_VEC(`N_MAX_HUFF_BITS-1)]       `DECLARE_FLOP(ss_bct);
   logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)]                                     `DECLARE_FLOP(ss_bct_valid);
   logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] `DECLARE_FLOP(ss_sat);
   logic [1:0][`BIT_VEC(`N_XP10_64K_SHRT_SYMBOLS)][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] `DECLARE_FLOP(ss_slt);
   logic [1:0][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS+1)]                                   `DECLARE_FLOP(ss_used_symbols);
   
   logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`BIT_VEC(`N_MAX_HUFF_BITS-1)]       `DECLARE_FLOP(ll_bct);
   logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)]                                     `DECLARE_FLOP(ll_bct_valid);
   logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)] `DECLARE_FLOP(ll_sat);
   logic [1:0][`BIT_VEC(`N_XP10_64K_LONG_SYMBOLS)][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)] `DECLARE_FLOP(ll_slt);
   logic [1:0][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS+1)]                                   `DECLARE_FLOP(ll_used_symbols);

   htf_fmt_e [1:0] `DECLARE_FLOP(block_fmt);
   logic [1:0]                                                                         `DECLARE_FLOP(block_min_ptr_len);
   logic [1:0]                                                                         `DECLARE_FLOP(block_min_mtf_len);
   logic [1:0]                                                                         `DECLARE_FLOP(block_error);

   logic                                                                               bank_wptr; 

   logic htf_credit_full;
   logic decoder_credit_empty;

   logic sched_info_full;

   assign decoder_sob_credit_avail = !decoder_credit_empty;
   
   assign sdd_htf_busy = htf_credit_full || sched_info_full;
   

   
   
   
   
   
   
   
   
   
   
   
   
   
   logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`BIT_VEC(`N_MAX_HUFF_BITS-1)] bct_mask;
   logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)]   ss_sat_mask;
   logic [1:0][`BIT_VEC_BASE(`N_MAX_HUFF_BITS, 1)][`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)]   ll_sat_mask;
   always_comb begin
      for (int i=0; i<2; i++) begin
         for (int j=1; j<=`N_MAX_HUFF_BITS; j++) begin
            bct_mask[i][j]    = (1 << (j-1)) - 1;
            ss_sat_mask[i][j] = (1 << (j-1)) - 1;
            ll_sat_mask[i][j] = (1 << (j-1)) - 1;
         end
      end
   end
   
   assign ss_bct = r_ss_bct & bct_mask;
   assign ss_bct_valid = r_ss_bct_valid;
   assign ss_sat = r_ss_sat & ss_sat_mask;
   assign ss_slt = r_ss_slt;
   assign ss_used_symbols = r_ss_used_symbols;
   assign ll_bct = r_ll_bct & bct_mask;
   assign ll_bct_valid = r_ll_bct_valid;
   assign ll_sat = r_ll_sat & ll_sat_mask;
   assign ll_slt = r_ll_slt;
   assign ll_used_symbols = r_ll_used_symbols;
   

   assign block_fmt = r_block_fmt;
   assign block_min_ptr_len = r_block_min_ptr_len;
   assign block_min_mtf_len = r_block_min_mtf_len;
   assign block_error = r_block_error;

   logic `DECLARE_RESET_FLOP(first_ss_bct, 1);
   logic `DECLARE_RESET_FLOP(first_ll_bct, 1);
   logic `DECLARE_RESET_FLOP(first_ss_slt, 1);
   logic `DECLARE_RESET_FLOP(first_ll_slt, 1);

   always_comb begin
      `DEFAULT_FLOP(ss_bct);
      `DEFAULT_FLOP(ss_bct_valid);
      `DEFAULT_FLOP(ss_sat);
      `DEFAULT_FLOP(ss_slt);
      `DEFAULT_FLOP(ss_used_symbols);
      `DEFAULT_FLOP(first_ss_bct);
      `DEFAULT_FLOP(first_ss_slt);
      `DEFAULT_FLOP(ll_bct);
      `DEFAULT_FLOP(ll_bct_valid);
      `DEFAULT_FLOP(ll_sat);
      `DEFAULT_FLOP(ll_slt);
      `DEFAULT_FLOP(ll_used_symbols);
      `DEFAULT_FLOP(first_ll_bct);
      `DEFAULT_FLOP(first_ll_slt);
      `DEFAULT_FLOP(block_fmt);
      `DEFAULT_FLOP(block_min_ptr_len);
      `DEFAULT_FLOP(block_min_mtf_len);
      `DEFAULT_FLOP(block_error);

      if (htf_sdd_bct_sat_wen) begin
         
         if (htf_sdd_bct_sat_type) begin
            if (c_first_ll_bct) begin
               c_ll_bct_valid[bank_wptr] = '0;
               c_first_ll_bct = 0;
            end
            c_ll_bct[bank_wptr][htf_sdd_bct_sat_addr] = htf_sdd_bct_data;
            c_ll_bct_valid[bank_wptr][htf_sdd_bct_sat_addr] = htf_sdd_bct_valid;
            c_ll_sat[bank_wptr][htf_sdd_bct_sat_addr] = htf_sdd_sat_data[`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)];
         end
         else begin
            if (c_first_ss_bct) begin
               c_ss_bct_valid[bank_wptr] = '0;
               c_first_ss_bct = 0;
            end
            c_ss_bct[bank_wptr][htf_sdd_bct_sat_addr] = htf_sdd_bct_data;
            c_ss_bct_valid[bank_wptr][htf_sdd_bct_sat_addr] = htf_sdd_bct_valid;
            c_ss_sat[bank_wptr][htf_sdd_bct_sat_addr] = htf_sdd_sat_data;
         end
         
      end 

      if (FPGA_MOD!=0) begin 
         for (int i=0; i<2; i++) begin
            c_ss_bct_valid[i] = 27'b100000000;
            c_ss_bct[i] = '0;
            c_ss_sat[i] = '0;
            
            c_ll_bct_valid[i] = 27'b11000000;
            c_ll_bct[i] = '0;
            c_ll_bct[i][8] = 12;
         end
      end

      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      

      for (int i=0; i<BL_PER_CYCLE; i++) begin
         if (htf_sdd_ss_slt_wen[i]) begin
            if (c_first_ss_slt) begin
               c_ss_used_symbols[bank_wptr] = 0;
               c_first_ss_slt = 0;
            end
            c_ss_slt[bank_wptr][htf_sdd_ss_slt_addr[i]] = htf_sdd_ss_slt_data[i]; 
            c_ss_used_symbols[bank_wptr]++;
         end

         if (htf_sdd_ll_slt_wen[i]) begin
            if (c_first_ll_slt) begin
               c_ll_used_symbols[bank_wptr] = 0;
               c_first_ll_slt = 0;
            end
            c_ll_slt[bank_wptr][htf_sdd_ll_slt_addr[i]] = htf_sdd_ll_slt_data[i]; 
            c_ll_used_symbols[bank_wptr]++;
         end
      end

      if (FPGA_MOD!=0) begin 
         for (int i=0; i<2; i++) begin
            c_ss_used_symbols[i] = 512;
            c_ss_slt = '0;
            for (int j=0; j<512; j++) begin
               c_ss_slt[i][j] = j;
            end
            
            c_ll_used_symbols[i] = 244;
            c_ll_slt = '0;
            for (int j=0; j<244; j++) begin
               c_ll_slt[i][j] = j;
            end
         end
      end

      if (htf_sdd_complete_valid) begin
         c_first_ss_bct = 1;
         c_first_ll_bct = 1;
         c_first_ss_slt = 1;
         c_first_ll_slt = 1;

         c_block_fmt[bank_wptr] = htf_sdd_complete_fmt;
         c_block_min_ptr_len[bank_wptr] = htf_sdd_complete_min_ptr_len;
         c_block_min_mtf_len[bank_wptr] = htf_sdd_complete_min_mtf_len;
         c_block_error[bank_wptr] = htf_sdd_complete_error;
      end
        

      
   end

   
   nx_fifo_ctrl
     #(.DEPTH(2))
   u_decoder_credit
     (
      
      .empty                            (decoder_credit_empty),  
      .full                             (),                      
      .used_slots                       (),                      
      .free_slots                       (),                      
      .rptr                             (),                      
      .wptr                             (),                      
      .underflow                        (),                      
      .overflow                         (),                      
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .wen                              (htf_sdd_complete_valid), 
      .ren                              (decoder_sob_credit_used), 
      .clear                            (1'b0));                  
   
   
   nx_fifo_ctrl
     #(.DEPTH(2))
   u_htf_credit
     (
      
      .empty                            (),                      
      .full                             (htf_credit_full),       
      .used_slots                       (),                      
      .free_slots                       (),                      
      .rptr                             (),                      
      .wptr                             (bank_wptr),             
      .underflow                        (),                      
      .overflow                         (),                      
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .wen                              (htf_sdd_complete_valid), 
      .ren                              (decoder_eob_credit_used), 
      .clear                            (1'b0));                  

   

   nx_fifo
     #(.DEPTH(4),
       .WIDTH($bits(sched_info_t)))
   u_sched_info_fifo
     (
      
      .empty                            (),                      
      .full                             (sched_info_full),       
      .underflow                        (),                      
      .overflow                         (),                      
      .used_slots                       (),                      
      .free_slots                       (),                      
      .rdata                            (sched_info_rdata),      
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .wen                              (htf_sdd_complete_valid), 
      .ren                              (sched_info_ren),        
      .clear                            (1'b0),                  
      .wdata                            (htf_sdd_complete_sched_info)); 
   

`undef DECLARE_RESET_FLOP
`undef DECLARE_FLOP
`undef DEFAULT_FLOP

endmodule 







