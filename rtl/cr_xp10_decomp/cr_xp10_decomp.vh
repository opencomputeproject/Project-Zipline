/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



















`ifndef __CR_XP10_DECOMP_VH
`define __CR_XP10_DECOMP_VH

`include "cr_global_params.vh"
`include "crPKG.svp"
`include "cr_xp10_decomp_regs.vh"
`include "cr_xp10_decomp_regsPKG.svp"
`include "cr_xp10_decomp_regfilePKG.svp"
`include "cr_xp10_decompPKG.svp"


`define XP10_WINDOW_SIZE_SEL_DECODE(window_size_sel) ((window_size_sel==0) ? (2**12) : \
                                                      (window_size_sel==1) ? (2**13) : \
                                                      (window_size_sel==2) ? (2**14) : \
                                                      (window_size_sel==3) ? (2**16) : \
                                                      (window_size_sel==4) ? (2**18) : \
                                                      (window_size_sel==5) ? (2**20) : \
                                                      (window_size_sel==6) ? (2**22) : \
                                                      (window_size_sel==7) ? (2**24) : \
                                                      -1)

`define XP10_MAX_WINDOW_SIZE_SEL 3
                                              
`define N_HTF_HDR_FIFO_DEPTH (($bits(crPKG::xp9_symbol_encode_e)*2 + \
                               (`N_SMALL_SYMBOLS*$clog2(`N_MAX_SMALL_HUFF_BITS+1))*2 + \
                               (`N_XP9_SHRT_SYMBOLS+`N_XP9_LONG_SYMBOLS)*`N_MAX_SMALL_HUFF_BITS + \
                               `AXI_S_DP_DWIDTH-1)/`AXI_S_DP_DWIDTH)


`define LZ77_MAX_WINDOW_SZ 4096
`define LFA_MEM_SZ 1024
`define LFA_MEM_AEMPTY 8
`define LFA_MEM_AFULL `LFA_MEM_SZ - `LFA_MEM_AEMPTY
`define CR_LZ_PRFX_SZ 64
`define CR_XP10_PHD_SZ 65                                                                       

`define XP9_MAX_SBL_TBL_SZ 108
`define XP9_FIXED_HDR_SZ 256
`define XP9_ISIZE_LSB 32
`define XP9_ISIZE_MSB 63
`define XP9_OSIZE_LSB 0
`define XP9_OSIZE_MSB 31
`define XP9_STBL_LSB 32
`define XP9_STBL_MSB 44
`define XP9_WSZ_LSB 45
`define XP9_WSZ_MSB 47
`define XP9_MTF_SEL_LSB 48
`define XP9_MTF_SEL_MSB 49                                                      
`define XP9_PTR_SZ 50
`define XP9_MTF_SZ 51

`define MTF_EXP_SZ 5
`define MTF_HDR_SZ 16
`define MAX_MTF_HDRS_SZ 84


`define XP10_FIXED_FRM_HDR_SZ 48
`define XP10_FIXED_BLK_HDR_SZ 32
`define XP10_FIXED_HDR_SZ 80
`define XP10_MAX_SBL_TBL_SZ 108
`define XP10_ID_MSB 31
`define XP10_ID_LSB 0
`define XP10_WSZ_MSB 34
`define XP10_WSZ_LSB 32
`define XP10_PTR_SZ 35
`define XP10_MODE_LSB 36
`define XP10_MODE_MSB 37                                                                       
`define XP10_CRC_OPTION 46
`define XP10_XTRA_FLG 47                                               
`define XP10_BLK_TYPE 13
`define XP10_MTF_PRSNT 14
`define XP10_LAST_BLK 15
`define XP10_OSIZE0_MSB 63
`define XP10_OSIZE0_LSB 48
`define XP10_OSIZE1_MSB 11
`define XP10_OSIZE1_LSB 0
`define CR_PFX_SIZE 1032
`define CR_DFLATE_ID1 31
`define CR_DFLATE_ID2 139
`define CR_DFLATE_CM_FMT  8   



`define CHU_WSIZE_SEL 23
`define CHU_MODE_BIT 22
`define CHU_PFX_MSB 21
`define CHU_PFX_LSB 16
`define CHU_SZ_MSB 15
`define CHU_SZ_LSB 0
                                                                       
`define CHU_MAX_SBL_TBL_SZ 108
`define CHU_FIXED_HDR_SZ 24
                  
`define DFLATE_MAX_SBL_TBL_SZ 40
                                                     
`define DECLARE_HUFFMAN_DECODER_LENGTH(NAME, MAX_BIT_LENGTH, NUM_SYMBOLS) \
`CCX_STD_DECLARE_PRICOD(NAME``_PRICOD, MAX_BIT_LENGTH) \
function void NAME \
   (input logic [`BIT_VEC(MAX_BIT_LENGTH)]                                    bit_stream, \
    input logic [`BIT_VEC_BASE(MAX_BIT_LENGTH,1)][`BIT_VEC(MAX_BIT_LENGTH-1)] bct, \
    input logic [`BIT_VEC_BASE(MAX_BIT_LENGTH,1)]                             bct_valid, \
    input logic [`BIT_VEC_BASE(MAX_BIT_LENGTH,1)][`LOG_VEC(NUM_SYMBOLS)]      sat, \
    output logic [`LOG_VEC(MAX_BIT_LENGTH+1)]                                 length, \
    output logic [`LOG_VEC(NUM_SYMBOLS)]                                      base_offset,\
    output logic [`LOG_VEC(NUM_SYMBOLS)]                                      sat_entry); \
   logic [`BIT_VEC(MAX_BIT_LENGTH)] reversed_bit_stream; \
   logic [`BIT_VEC(MAX_BIT_LENGTH+1)] candidate_minus_base[`BIT_VEC_BASE(MAX_BIT_LENGTH,1)];  \
   logic [`BIT_VEC_BASE(MAX_BIT_LENGTH,1)]            candidate_gte_base; \
   logic [`BIT_VEC_BASE(MAX_BIT_LENGTH,1)]            length_pricod; \
   base_offset = 0; \
   sat_entry = 0; \
   length = 0; \
   reversed_bit_stream = { << {bit_stream} }; \
   for (int i=1; i<=MAX_BIT_LENGTH; i++) begin \
      logic [`BIT_VEC(MAX_BIT_LENGTH)] mask; \
      mask = ~('1 << i); \
       \
       \
       \
      candidate_minus_base[i] = ((reversed_bit_stream>>(MAX_BIT_LENGTH-i)) & mask) - ({bct[i], 1'b0} & mask); \
      candidate_gte_base[i] = ~candidate_minus_base[i][MAX_BIT_LENGTH]; \
   end \
   length_pricod = NAME``_PRICOD(candidate_gte_base & bct_valid); \
   for (int i=1; i<=MAX_BIT_LENGTH; i++) begin \
      base_offset |= candidate_minus_base[i][`LOG_VEC(NUM_SYMBOLS)] & {$clog2(NUM_SYMBOLS){length_pricod[i]}};  \
      sat_entry |= sat[i] & {$clog2(NUM_SYMBOLS){length_pricod[i]}};  \
      length |= i & {$clog2(MAX_BIT_LENGTH+1){length_pricod[i]}};  \
   end \
endfunction : NAME

`define DECLARE_HUFFMAN_DECODER_SYMBOL(NAME, NUM_SYMBOLS) \
function void NAME \
   (input logic [`LOG_VEC(NUM_SYMBOLS)]                                       base_offset, \
    input logic [`LOG_VEC(NUM_SYMBOLS)]                                       sat_entry, \
    input logic [`BIT_VEC(NUM_SYMBOLS)][`LOG_VEC(NUM_SYMBOLS)]                slt, \
    input logic [`LOG_VEC(NUM_SYMBOLS+1)]                                     used_symbols, \
    output logic [`LOG_VEC(NUM_SYMBOLS)]                                      symbol, \
    output logic                                                              error); \
   logic [`LOG_VEC(NUM_SYMBOLS)] slt_offset; \
   slt_offset = $bits(slt_offset)'(sat_entry+base_offset);  \
   symbol = slt[slt_offset];  \
   if (($bits(sat_entry)+1)'(sat_entry + base_offset) >= ($bits(sat_entry)+1)'(used_symbols)) \
     error = 1; \
   else \
     error = 0; \
endfunction : NAME

`define DECLARE_HUFFMAN_DECODER(NAME, MAX_BIT_LENGTH, NUM_SYMBOLS) \
`DECLARE_HUFFMAN_DECODER_LENGTH(NAME``_LENGTH, MAX_BIT_LENGTH, NUM_SYMBOLS) \
`DECLARE_HUFFMAN_DECODER_SYMBOL(NAME``_SYMBOL, MAX_BIT_LENGTH, NUM_SYMBOLS) \
function void NAME \
   (input logic [`BIT_VEC(MAX_BIT_LENGTH)]                                    bit_stream, \
    input logic [`BIT_VEC_BASE(MAX_BIT_LENGTH,1)][`BIT_VEC(MAX_BIT_LENGTH-1)] bct, \
    input logic [`BIT_VEC_BASE(MAX_BIT_LENGTH,1)]                             bct_valid, \
    input logic [`BIT_VEC_BASE(MAX_BIT_LENGTH,1)][`LOG_VEC(NUM_SYMBOLS)]      sat, \
    input logic [`BIT_VEC(NUM_SYMBOLS)][`LOG_VEC(NUM_SYMBOLS)]                slt, \
    input logic [`LOG_VEC(NUM_SYMBOLS+1)]                                     used_symbols, \
    output logic [`LOG_VEC(MAX_BIT_LENGTH+1)]                                 length, \
    output logic [`LOG_VEC(NUM_SYMBOLS)]                                      symbol, \
    output logic                                                              error); \
   logic [`LOG_VEC(NUM_SYMBOLS)]      base_offset; \
   logic [`LOG_VEC(NUM_SYMBOLS)]      sat_entry; \
   NAME``_LENGTH(bit_stream, bct, bct_valid, sat, length, base_offset, sat_entry); \
   NAME``_SYMBOL(base_offset, sat_entry, slt, used_symbols, symbol, error); \
endfunction : NAME

`define DECLARE_SMALL_HUFFMAN_DECODER(NAME, MAX_BIT_LENGTH, NUM_SYMBOLS) \
function void NAME \
   (input logic [`BIT_VEC(MAX_BIT_LENGTH)]                                    bit_stream, \
    input logic [`BIT_VEC(NUM_SYMBOLS)][`LOG_VEC(MAX_BIT_LENGTH+1)]           blt, \
    input logic [`BIT_VEC(NUM_SYMBOLS)][`BIT_VEC(MAX_BIT_LENGTH)]             smt, \
    input logic [`BIT_VEC(NUM_SYMBOLS)][`BIT_VEC(MAX_BIT_LENGTH)]             svt, \
    output logic [`LOG_VEC(MAX_BIT_LENGTH+1)]                                 length, \
    output logic [`LOG_VEC(NUM_SYMBOLS)]                                      symbol, \
    output logic [`BIT_VEC(NUM_SYMBOLS)]                                      onehot_symbol, \
    output logic                                                              error); \
   length = '0; \
   symbol = '0; \
   onehot_symbol = '0; \
   error = 1; \
   for (int i=0; i<NUM_SYMBOLS; i++) begin \
      if ((bit_stream & smt[i]) == svt[i]) begin \
         length |= blt[i];  \
         symbol |= i;  \
         onehot_symbol[i] = 1; \
         error = 0; \
      end \
   end \
endfunction : NAME

`endif 




    
