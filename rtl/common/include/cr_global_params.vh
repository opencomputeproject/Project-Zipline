/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



`ifndef CR_GLOBAL_PARAMS_VH
`define CR_GLOBAL_PARAMS_VH

`define N_RBUS_ADDR_BITS        20
`define N_KME_RBUS_ADDR_BITS    16
`define N_RBUS_DATA_BITS        32
`define CR_CDDIP_N_BLKS         10
`define CR_CCEIP_64_N_BLKS      15
`define CR_CCEIP_16_N_BLKS      9
`define AXI_S_DP_DWIDTH         64
`define AXI_S_STAT_DWIDTH       32
`define AXI_S_SCH_DWIDTH        32
`define AXI_S_CPL_DWIDTH        32

`define AXI_S_TID_WIDTH         1
`define AXI_S_USER_WIDTH        8
`define AXI_S_KEEP_WIDTH        8
`define AXI_S_TSTRB_WIDTH       8

`define AXI_S_TOTAL_WIDTH       82

`define N_AXI_IM_ENTRIES        512
`define N_AXI_IM_DECS_WIDTH     32
`define N_AXI_IM_DATA_WIDTH     64
`define N_AXI_IM_WIDTH          96

`define N_MAX_WINDOW_BYTES      65536
`define N_WINDOW_WIDTH          16
`define N_EXTRA_BITS_WIDTH      15
`define N_EXTRA_BITS_TOT_WIDTH  18
`define N_EXTRA_BITS_LEN_WIDTH  4
`define N_MAX_ENCODE_WIDTH      27

`define N_MAX_BUFFER_SIZE       8388609
`define N_MAX_BUFFER_SIZE_WIDTH 24
`define N_RAW_SIZE_WIDTH        24

`define N_XP9_SHRT_SYMBOLS      704
`define N_XP9_LONG_SYMBOLS      256
`define N_XP10_64K_SHRT_SYMBOLS 576
`define N_XP10_64K_LONG_SYMBOLS 248
`define N_XP10_16K_SHRT_SYMBOLS 544
`define N_XP10_16K_LONG_SYMBOLS 246
`define N_XP10_8K_SHRT_SYMBOLS  528
`define N_XP10_8K_LONG_SYMBOLS  245
`define N_XP10_4K_SHRT_SYMBOLS  512
`define N_XP10_4K_LONG_SYMBOLS  244
`define N_SHRT_SYM_WIDTH        10
`define N_LONG_SYM_WIDTH        8
`define N_LENLIT_SYMBOLS        288
`define N_DIST_SYMBOLS          30
`define N_SMALL_SYMBOLS         33
`define N_CODELEN_SYMBOLS       19
`define N_MAX_XP_HUFF_BITS      27
`define N_MAX_DEFLATE_HUFF_BITS 15
`define N_MAX_SMALL_HUFF_BITS   8
`define N_MAX_CODELEN_HUFF_BITS 7
`define N_MAX_SUPPORTED_SYMBOLS 576
`define N_MAX_HUFF_BITS         27
`define N_HTF_BL_OUT_ENTRIES    226


`define N_MAX_MTF               4
`define N_MAX_MTF_WIDTH         2
`define N_MAX_NGRAM             4
`define N_MAX_NGRAM_WIDTH       3

`define N_HUFF_SQ_DEPTH         20480
`define N_HUFF_SQ_ADDR_WIDTH    15

`define XPRESS9_ID              1317459754
`define XPRESS10_ID             3225019664

`define CR_CCEIP_16_BLKID       52758
`define CR_CCEIP_64_BLKID       52836
`define CR_CDDIP_BLKID          52580

`define FRAME_ID_WIDTH          64
`define MODULE_ID_WIDTH         5
`define SU_BYTES_WIDTH          24

`define PREFIX_STATS_WIDTH      64
`define LZ77C_STATS_WIDTH       64
`define HUFE_STATS_WIDTH        32
`define CRYPTO_STATS_WIDTH      32
`define LZ77D_STATS_WIDTH       64
`define HUFD_STATS_WIDTH        64
`define CRCGC_STATS_WIDTH       8
`define ISF_STATS_WIDTH         64
`define OSF_STATS_WIDTH         16
`define CG_STATS_WIDTH          4

`define TLVP_SEQ_NUM_WIDTH      13
`define TLVP_ORD_NUM_WIDTH      13
`define TLVP_TYP_NUM_WIDTH      8
`define TLVP_PA_WIDTH           64

`define TLV_FRAME_NUM_WIDTH     11

`define N_PREFIX_FEATURES       256
`define N_PREFIX_FEATURE_CTR    64

`define N_PREFIX_IM_ENTRIES     256
`define N_PREFIX_SAT_ENTRIES    128
`define N_PREFIX_CT_ENTRIES     128
`define CR_PREFIX_N_NEURONS     128
`define CR_PREFIX_NEURON_WIDTH  7
`define CR_PREFIX_PFD_ENTRIES   8192
`define CR_PREFIX_PHD_ENTRIES   4096
`define CR_PREFIX_N_PHD_WORDS   67
`define CR_PREFIX_N_PFD_WORDS   130

`define ISF_FIFO_ENTRIES        1024
`define ISF_FIFO_WIDTH          92

`define OSF_DATA_FIFO_ENTRIES   512
`define OSF_DATA_FIFO_WIDTH     92

`define OSF_PDT_FIFO_ENTRIES    256
`define OSF_PDT_FIFO_WIDTH      92

`define SU_FIFO_ENTRIES         64

`define TLV_LEN_WIDTH           8
`define N_FTR_WORDS             14
`define N_FTR_WORDS_EXP         20

`define TLV_LATENCY_WIDTH       16
`define TLV_SEQ_NUM_WIDTH       8

`define AXI_S_TID_PAD_WIDTH     8


`define XP10CRC64_POLYNOMIAL    11127430586519243189
`define XP10CRC64_INIT          18446744073709551615

`define XP10CRC32_POLYNOMIAL    2197175160
`define XP10CRC32_INIT          4294967295

`define CRC64E_POLYNOMIAL       4823603603198064275
`define CRC64E_INIT             18446744073709551615

`define GZIPCRC32_POLYNOMIAL    3988292384
`define GZIPCRC32_INIT          4294967295

`define CRC16T_POLYNOMIAL       35767
`define CRC16T_INIT             65535

`endif
