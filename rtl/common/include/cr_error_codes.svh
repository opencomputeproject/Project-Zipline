// *************************************************************************
//
// Copyright © Microsoft Corporation. All rights reserved.
// Copyright © Broadcom Inc. All rights reserved.
// Licensed under the MIT License.
//
// *************************************************************************


typedef enum logic [7:0]
        {NO_ERRORS=0,
         
         //ISF, OSF:
         

         //CRC Checker/Generator
         //
         //                     cceip  cceip   cceip    cceip   cddip   cddip
         //                     crcc0  crcc1   crcg0   crcgc0   crcg0   crcc0
         //                    ------  -----  ------  -------  ------  ------
         // cceip_cfg               1      1       1        1       0       0
         // crcgc_mode              3      2       1        0       4       3
         // ERROR_CODE hex       0x33   0x34    0x35     0x36    0x37    x038
         //            int         51     52      53       54      55      56 
         //
         CRCCG_CRC_ERROR  = 50,
         CRCC0_CRC_ERROR  = 51,
         CRCC1_CRC_ERROR  = 52,
         CRCG0_CRC_ERROR  = 53,
         CRCGC0_CRC_ERROR = 54,
         CRCDG0_CRC_ERROR = 55,
         CRCDC0_CRC_ERROR = 56,
         
         
         //Prefix Errors
         PREFIX_PC_OVERRUN_ERROR    = 150,
         PREFIX_NUM_WR_ERROR        = 151,
         PREFIX_ILLEGAL_OPCODE      = 152,
         PREFIX_REC_US_SW_EN_ERROR  = 153,

         
         
         //Prefix Attach Errors
         PREFIX_ATTACH_PHD_CRC_ERROR = 155,
         PREFIX_ATTACH_PFD_CRC_ERROR = 156,
         

         
         //LZ77 Compressor

         LZ77_COMP_PREFIX_CRC_ERROR     = 64,
         LZ77_COMP_INVALID_COMP_ALG     = 65,
         LZ77_COMP_INVALID_WIN_SIZE     = 66,
         LZ77_COMP_INVALID_MIN_LEN      = 67,
         LZ77_COMP_INVALID_NUM_MTF      = 68,
         LZ77_COMP_INVALID_MAX_LEN      = 69,
         LZ77_COMP_INVALID_DMW_SIZE     = 70,
         LZ77_COMP_LZ_ERROR             = 71,
         
         
         //Huffman Encoder
         HE_MEM_ECC                     = 80,
         HE_PDH_CRC                     = 81,
         HE_PFX_CRC                     = 82,
         HE_SYM_MAP_ERR                 = 83,
         
         
         //Crypto Encrypt
         CRYPTO_ENC_DRNG_HEALTH_FAIL = 108,
	 CRYPTO_ENC_AAD_LEN_ERROR = 107,
         CRYPTO_ENC_XTS_LEN_ERROR = 106,
         CRYPTO_ENC_MAL_CMD = 105,
         CRYPTO_ENC_KEY_TLV_CRC_ERROR = 104,
         CRYPTO_ENC_INVALID_ENGINE_ID = 103,
         CRYPTO_ENC_INVALID_SEQNUM = 102,
         CRYPTO_ENC_IV_MISSING = 101,
         CRYPTO_ENC_SEED_EXPIRED = 100,

         //Crypto Decrypt/Validate
         CRYPTO_DEC_AAD_LEN_ERROR = 118,
         CRYPTO_DEC_XTS_LEN_ERROR = 117,
         CRYPTO_DEC_MAL_CMD = 116,
         CRYPTO_DEC_KEY_TLV_CRC_ERROR = 115,
         CRYPTO_DEC_INVALID_ENGINE_ID = 114,
         CRYPTO_DEC_INVALID_SEQNUM = 113,
         CRYPTO_DEC_IV_MISSING = 112,
         CRYPTO_DEC_TAG_MISCOMPARE = 110,

         //Crypto Integrity Gen/Check
         CRYPTO_INT_KEY_TLV_CRC_ERROR = 123,
         CRYPTO_INT_INVALID_ENGINE_ID = 122,
         CRYPTO_INT_INVALID_SEQNUM = 121,
         CRYPTO_INT_TAG_MISCOMPARE = 120,

         //KME
         KME_DAK_INV_KIM = 130,
         KME_DAK_PF_VF_VAL_ERR = 131,
         KME_DEK_INV_KIM = 132,
         KME_DEK_PF_VF_VAL_ERR = 133,
         KME_SEED_EXPIRED = 134,
         KME_DEK_GCM_TAG_FAIL = 135,
         KME_DAK_GCM_TAG_FAIL = 136,
         KME_ECC_FAIL = 137,
         KME_UNSUPPORTED_KEY_TYPE = 138,
         KME_DEK_ILLEGAL_KEK_USAGE = 139,
         KME_DAK_ILLEGAL_KEK_USAGE = 140,
         KME_DRNG_HEALTH_FAIL = 141,

         //Huffman Decoder
         HD_MEM_ECC=1,
         
         HD_FHP_PFX_CRC=2,
         HD_FHP_PFX_DATA_ABSENT=3,
         HD_FHP_PHD_CRC=4,
         HD_FHP_BAD_FORMAT=5,

         HD_BHP_INVALID_WSIZE=6,
         HD_BHP_BLK_CRC=7,
         HD_BHP_HDR_INVALID=8,
         HD_BHP_XP9_HDR_SEQ=9,
         HD_BHP_XP10_XTRA_FLAG_PRSNT=10,
         HD_BHP_ZLIB_FDICT_PRSNT=11,
         HD_BHP_GZ_CM_NOT_DEFLATE=12,
         HD_BHP_ZLIB_CINFO_RANGE=13,
         HD_BHP_ZLIB_FCHECK=14,
         HD_BHP_DFLATE_LEN_CHECK = 15,
         HD_LFA_REWIND_FAIL=16,
         HD_LFA_PREMATURE_EOF = 17,
         HD_LFA_LATE_EOF = 18,
         HD_LFA_MISSING_EOF = 19,

         HD_HTF_XP9_RESERVED_SYMBOL_TABLE_ENCODING=20,
         HD_HTF_XP10_RESERVED_SYMBOL_TABLE_ENCODING=21,
         HD_HTF_XP10_PREDEF_SYMBOL_TABLE_ENCODING=22,
         HD_HTF_XP9_ILLEGAL_NONZERO_BL=23,
         HD_HTF_RLE_OVERRUN=24,
         HD_HTF_BAD_HUFFMAN_CODE=25,
         HD_HTF_ILLEGAL_SMALL_HUFFTREE=26,
         HD_HTF_ILLEGAL_HUFFTREE=27,
         HD_HTF_HDR_UNDERRUN=28,
         HD_BHP_STBL_SIZE_ERR=29,
         HD_SDD_INVALID_SYMBOL=32,
         HD_SDD_END_MISMATCH=33,
         HD_SDD_MISSING_EOB_SYM=34,
         HD_MTF_XP9_MTF3_AFTER_BACKREF=35,
         HD_MTF_XP10_MISSING_MTF=36,

         HD_BHP_ILLEGAL_MTF_SZ=37,
         //LZ77 Decompressor
         HD_LZ_HBIF_SOFT_OFLOW=38,
         HD_BE_FRM_CRC=39,
         HD_BE_OLIMIT=40,
         HD_BE_SZ_MISMATCH=41,
         
         //Completion Generator
         CG_UNDEF_FRMD_OUT = 170,

         //ISF
         ISF_PREFIX_ERR = 180,

         //TLV Parser
         TLVP_BIP2_ERROR = 255
       
  

         } zipline_error_e;

