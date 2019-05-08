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

module cr_xp10_decomp_htf_symtab_dec_retro_huff (
   
   huff_total_length, huff_symbol, huff_onehot_symbol, huff_err,
   huff_blt_hist_wdata, huff_repeat_count, huff_sub_state,
   
   small_blt, small_smt, small_svt, fmt, i_bl_index, i_prev_bl,
   i_prev_non_zero_bl, hdr_bits_data
   );
   import crPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;

   parameter BL_PER_CYCLE = 2;

   localparam NUM_SPEC_HUFFMAN = (BL_PER_CYCLE-1)*`N_MAX_SMALL_HUFF_BITS+1;

   
   
   
   input [`BIT_VEC(`N_SMALL_SYMBOLS)][`LOG_VEC(`N_MAX_SMALL_HUFF_BITS+1)]   small_blt;
   input [`BIT_VEC(`N_SMALL_SYMBOLS)][`BIT_VEC(`N_MAX_SMALL_HUFF_BITS)]     small_smt;
   input [`BIT_VEC(`N_SMALL_SYMBOLS)][`BIT_VEC(`N_MAX_SMALL_HUFF_BITS)]     small_svt;
   input htf_fmt_e                                                          fmt;
   input [`LOG_VEC(`N_XP9_SHRT_SYMBOLS)] i_bl_index; 
   input [15:0][`LOG_VEC(`N_MAX_HUFF_BITS+1)] i_prev_bl; 
   input [`LOG_VEC(`N_MAX_HUFF_BITS+1)]       i_prev_non_zero_bl;
   input [`BIT_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS)]          hdr_bits_data;
   
   `DECLARE_SMALL_HUFFMAN_DECODER(huffman_decoder, `N_MAX_SMALL_HUFF_BITS, `N_SMALL_SYMBOLS)

   output logic [`BIT_VEC(NUM_SPEC_HUFFMAN)][`LOG_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS+1)] huff_total_length;
   output logic [`BIT_VEC(NUM_SPEC_HUFFMAN)][`LOG_VEC(`N_SMALL_SYMBOLS)]         huff_symbol;
   output logic [`BIT_VEC(NUM_SPEC_HUFFMAN)][`BIT_VEC(`N_SMALL_SYMBOLS)]         huff_onehot_symbol;
   output logic [`BIT_VEC(NUM_SPEC_HUFFMAN)]                                     huff_err;
   output logic [`BIT_VEC(NUM_SPEC_HUFFMAN)][`LOG_VEC(`N_MAX_HUFF_BITS+1)]       huff_blt_hist_wdata;
   output logic [`BIT_VEC(NUM_SPEC_HUFFMAN)][3:0]                                huff_repeat_count;
   output htf_symtab_sub_state_t                                                 huff_sub_state[`BIT_VEC(NUM_SPEC_HUFFMAN)];

   logic [`BIT_VEC(NUM_SPEC_HUFFMAN)][`LOG_VEC(`N_MAX_SMALL_HUFF_BITS+1)] huff_length;

   always_comb begin
      
      
      
      
      
      
      
      logic [`LOG_VEC(`N_MAX_HUFF_BITS+1)]       v_bl_constants[`BIT_VEC(`N_SMALL_SYMBOLS)];
      logic [3:0]                                v_repeat_constants[`BIT_VEC(`N_SMALL_SYMBOLS)];
      htf_symtab_sub_state_t                                v_sub_state_constants[`BIT_VEC(`N_SMALL_SYMBOLS)];
      
      
      v_bl_constants = '{default: 0};
      v_repeat_constants = '{default: 0};
      v_sub_state_constants = '{default: 1 << HUFFMAN};

      if (fmt == HTF_FMT_DEFLATE_DYNAMIC) begin
         for (int j=0; j<16; j++) begin
            v_bl_constants[j] = j;
         end

         
         
         v_repeat_constants[16] = 1;
         v_bl_constants[16] = i_prev_bl[0];
         v_sub_state_constants[16] = 1 << EXTRA_2;
         
         
         
         v_repeat_constants[17] = 1;
         v_sub_state_constants[17] = 1 << EXTRA_3;
         
         
         
         v_repeat_constants[18] = 9;
         v_sub_state_constants[18] = 1 << EXTRA_7;
      end
      else begin
         for (int j=0; j<28; j++) begin
            v_bl_constants[j] = j;
         end

         
         v_repeat_constants[28] = 15 - i_bl_index[3:0];
         
         
         v_repeat_constants[29] = 3;
         v_sub_state_constants[29] = 1 << EXTRA_2;
         
         
         v_bl_constants[30] = i_prev_non_zero_bl;
         
         
         v_bl_constants[31] = i_prev_bl[15];
         
         
         v_bl_constants[32] = i_prev_bl[15]+1;
      end 
      
      huff_blt_hist_wdata = '0;
      huff_repeat_count = '0;
      huff_sub_state = '{default: 0};
      for (int i=0; i<NUM_SPEC_HUFFMAN; i++) begin
         huffman_decoder(hdr_bits_data[i +: `N_MAX_SMALL_HUFF_BITS],
                         small_blt,
                         small_smt,
                         small_svt,
                         huff_length[i],
                         huff_symbol[i], 
                         huff_onehot_symbol[i],
                         huff_err[i]);
         huff_total_length[i] = huff_length[i] + i;
         for (int j=0; j<`N_SMALL_SYMBOLS; j++) begin
            if (huff_onehot_symbol[i][j]) begin
               huff_blt_hist_wdata[i] |= v_bl_constants[j]; 
               huff_repeat_count[i] |= v_repeat_constants[j]; 
               huff_sub_state[i] = htf_symtab_sub_state_t'($bits(htf_symtab_sub_state_t)'(huff_sub_state[i]) | $bits(htf_symtab_sub_state_t)'(v_sub_state_constants[j])); 
            end
         end
      end 
   end 

endmodule 







