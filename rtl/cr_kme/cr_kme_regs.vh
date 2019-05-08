/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



`ifndef CR_KME_REGS_VH
`define CR_KME_REGS_VH

`define CR_KME_DIGEST_3FE7A8A8BB9DF2AAEF69F2383C0979F7 1



`define CR_KME_PKT_HDR_E_DECL   1:0
`define CR_KME_PKT_HDR_E_WIDTH  2
  `define CR_KME_PKT_HDR_E_ENET  (2'h 0)
  `define CR_KME_PKT_HDR_E_IPV4  (2'h 1)
  `define CR_KME_PKT_HDR_E_IPV6  (2'h 2)
  `define CR_KME_PKT_HDR_E_MPLS  (2'h 3)

`define CR_KME_CMD_COMPOUND_CMD_FRM_SIZE_E_DECL   3:0
`define CR_KME_CMD_COMPOUND_CMD_FRM_SIZE_E_WIDTH  4
  `define CR_KME_CMD_COMPOUND_CMD_FRM_SIZE_E_CMD_SIMPLE  (4'h 0)
  `define CR_KME_CMD_COMPOUND_CMD_FRM_SIZE_E_COMPND_4K   (4'h 5)
  `define CR_KME_CMD_COMPOUND_CMD_FRM_SIZE_E_COMPND_8K   (4'h 6)
  `define CR_KME_CMD_COMPOUND_CMD_FRM_SIZE_E_COMPND_RSV  (4'h f)

`define CR_KME_CMD_GUID_PRESENT_E_DECL   0:0
`define CR_KME_CMD_GUID_PRESENT_E_WIDTH  1
  `define CR_KME_CMD_GUID_PRESENT_E_GUID_NOT_PRESENT  (1'h 0)
  `define CR_KME_CMD_GUID_PRESENT_E_GUID_PRESENT      (1'h 1)

`define CR_KME_CMD_FRMD_CRC_IN_E_DECL   0:0
`define CR_KME_CMD_FRMD_CRC_IN_E_WIDTH  1
  `define CR_KME_CMD_FRMD_CRC_IN_E_CRC_NOT_PRESENT  (1'h 0)
  `define CR_KME_CMD_FRMD_CRC_IN_E_CRC_PRESENT      (1'h 1)

`define CR_KME_CCEIP_CMD_FRMD_IN_TYPE_E_DECL   6:0
`define CR_KME_CCEIP_CMD_FRMD_IN_TYPE_E_WIDTH  7
  `define CR_KME_CCEIP_CMD_FRMD_IN_TYPE_E_CCEIP_FRMD_USER_NULL  (7'h b)
  `define CR_KME_CCEIP_CMD_FRMD_IN_TYPE_E_CCEIP_FRMD_USER_PI16  (7'h c)
  `define CR_KME_CCEIP_CMD_FRMD_IN_TYPE_E_CCEIP_FRMD_USER_PI64  (7'h d)
  `define CR_KME_CCEIP_CMD_FRMD_IN_TYPE_E_CCEIP_FRMD_USER_VM    (7'h e)
  `define CR_KME_CCEIP_CMD_FRMD_IN_TYPE_E_CCEIP_TYPE_IN_RSV     (7'h 7f)

`define CR_KME_CDDIP_CMD_FRMD_IN_TYPE_E_DECL   6:0
`define CR_KME_CDDIP_CMD_FRMD_IN_TYPE_E_WIDTH  7
  `define CR_KME_CDDIP_CMD_FRMD_IN_TYPE_E_CDDIP_FRMD_INT_APP       (7'h f)
  `define CR_KME_CDDIP_CMD_FRMD_IN_TYPE_E_CDDIP_FRMD_INT_SIP       (7'h 10)
  `define CR_KME_CDDIP_CMD_FRMD_IN_TYPE_E_CDDIP_FRMD_INT_LIP       (7'h 11)
  `define CR_KME_CDDIP_CMD_FRMD_IN_TYPE_E_CDDIP_FRMD_INT_VM        (7'h 12)
  `define CR_KME_CDDIP_CMD_FRMD_IN_TYPE_E_CDDIP_FRMD_INT_VM_SHORT  (7'h 16)
  `define CR_KME_CDDIP_CMD_FRMD_IN_TYPE_E_CDDIP_TYPE_IN_RSV        (7'h 7f)

`define CR_KME_CCEIP_CMD_FRMD_OUT_TYPE_E_DECL   6:0
`define CR_KME_CCEIP_CMD_FRMD_OUT_TYPE_E_WIDTH  7
  `define CR_KME_CCEIP_CMD_FRMD_OUT_TYPE_E_CCEIP_FRMD_INT_APP       (7'h f)
  `define CR_KME_CCEIP_CMD_FRMD_OUT_TYPE_E_CCEIP_FRMD_INT_SIP       (7'h 10)
  `define CR_KME_CCEIP_CMD_FRMD_OUT_TYPE_E_CCEIP_FRMD_INT_LIP       (7'h 11)
  `define CR_KME_CCEIP_CMD_FRMD_OUT_TYPE_E_CCEIP_FRMD_INT_VM        (7'h 12)
  `define CR_KME_CCEIP_CMD_FRMD_OUT_TYPE_E_CCEIP_FRMD_INT_VM_SHORT  (7'h 16)
  `define CR_KME_CCEIP_CMD_FRMD_OUT_TYPE_E_CCEIP_TYPE_OUT_RSV       (7'h 7f)

`define CR_KME_CDDIP_CMD_FRMD_OUT_TYPE_E_DECL   6:0
`define CR_KME_CDDIP_CMD_FRMD_OUT_TYPE_E_WIDTH  7
  `define CR_KME_CDDIP_CMD_FRMD_OUT_TYPE_E_CDDIP_FRMD_USER_NULL  (7'h b)
  `define CR_KME_CDDIP_CMD_FRMD_OUT_TYPE_E_CDDIP_FRMD_USER_PI16  (7'h c)
  `define CR_KME_CDDIP_CMD_FRMD_OUT_TYPE_E_CDDIP_FRMD_USER_PI64  (7'h d)
  `define CR_KME_CDDIP_CMD_FRMD_OUT_TYPE_E_CDDIP_FRMD_USER_VM    (7'h e)
  `define CR_KME_CDDIP_CMD_FRMD_OUT_TYPE_E_CDDIP_TYPE_OUT_RSV    (7'h 7f)

`define CR_KME_CMD_FRMD_OUT_CRC_E_DECL   0:0
`define CR_KME_CMD_FRMD_OUT_CRC_E_WIDTH  1
  `define CR_KME_CMD_FRMD_OUT_CRC_E_NOT_GEN  (1'h 0)
  `define CR_KME_CMD_FRMD_OUT_CRC_E_GEN      (1'h 1)

`define CR_KME_CMD_FRMD_OUT_CRC_TYPE_E_DECL   1:0
`define CR_KME_CMD_FRMD_OUT_CRC_TYPE_E_WIDTH  2
  `define CR_KME_CMD_FRMD_OUT_CRC_TYPE_E_FRMD_T10_DIX  (2'h 0)
  `define CR_KME_CMD_FRMD_OUT_CRC_TYPE_E_FRMD_CRC64    (2'h 1)
  `define CR_KME_CMD_FRMD_OUT_CRC_TYPE_E_FRMD_CRC64E   (2'h 2)
  `define CR_KME_CMD_FRMD_OUT_CRC_TYPE_E_FRMD_CRC_RSV  (2'h 3)

`define CR_KME_CMD_MD_TYPE_E_DECL   1:0
`define CR_KME_CMD_MD_TYPE_E_WIDTH  2
  `define CR_KME_CMD_MD_TYPE_E_NO_CRC         (2'h 0)
  `define CR_KME_CMD_MD_TYPE_E_CRC_8B_CRC64   (2'h 1)
  `define CR_KME_CMD_MD_TYPE_E_CRC_8B_CRC64E  (2'h 2)
  `define CR_KME_CMD_MD_TYPE_E_MD_TYPE_RSV    (2'h 3)

`define CR_KME_CMD_MD_OP_E_DECL   1:0
`define CR_KME_CMD_MD_OP_E_WIDTH  2
  `define CR_KME_CMD_MD_OP_E_CRC_GEN_VERIFY  (2'h 0)
  `define CR_KME_CMD_MD_OP_E_CRC_RSV1        (2'h 1)
  `define CR_KME_CMD_MD_OP_E_CRC_RSV2        (2'h 2)
  `define CR_KME_CMD_MD_OP_E_CRC_RSV3        (2'h 3)

`define CR_KME_CMD_FRMD_RAW_MAC_SEL_E_DECL   0:0
`define CR_KME_CMD_FRMD_RAW_MAC_SEL_E_WIDTH  1
  `define CR_KME_CMD_FRMD_RAW_MAC_SEL_E_FRMD_MAC_NOP  (1'h 0)
  `define CR_KME_CMD_FRMD_RAW_MAC_SEL_E_FRMD_MAC_CAL  (1'h 1)

`define CR_KME_CMD_CHU_APPEND_E_DECL   0:0
`define CR_KME_CMD_CHU_APPEND_E_WIDTH  1
  `define CR_KME_CMD_CHU_APPEND_E_CHU_NORMAL  (1'h 0)
  `define CR_KME_CMD_CHU_APPEND_E_CHU_APPEND  (1'h 1)

`define CR_KME_CMD_COMP_MODE_E_DECL   3:0
`define CR_KME_CMD_COMP_MODE_E_WIDTH  4
  `define CR_KME_CMD_COMP_MODE_E_NONE      (4'h 0)
  `define CR_KME_CMD_COMP_MODE_E_ZLIB      (4'h 1)
  `define CR_KME_CMD_COMP_MODE_E_GZIP      (4'h 2)
  `define CR_KME_CMD_COMP_MODE_E_XP9       (4'h 3)
  `define CR_KME_CMD_COMP_MODE_E_XP10      (4'h 4)
  `define CR_KME_CMD_COMP_MODE_E_CHU4K     (4'h 5)
  `define CR_KME_CMD_COMP_MODE_E_CHU8K     (4'h 6)
  `define CR_KME_CMD_COMP_MODE_E_RSV_MODE  (4'h f)

`define CR_KME_CMD_LZ77_WIN_SIZE_E_DECL   3:0
`define CR_KME_CMD_LZ77_WIN_SIZE_E_WIDTH  4
  `define CR_KME_CMD_LZ77_WIN_SIZE_E_WIN_32B  (4'h 0)
  `define CR_KME_CMD_LZ77_WIN_SIZE_E_WIN_4K   (4'h 1)
  `define CR_KME_CMD_LZ77_WIN_SIZE_E_WIN_8K   (4'h 2)
  `define CR_KME_CMD_LZ77_WIN_SIZE_E_WIN_16K  (4'h 3)
  `define CR_KME_CMD_LZ77_WIN_SIZE_E_WIN_32K  (4'h 4)
  `define CR_KME_CMD_LZ77_WIN_SIZE_E_WIN_64K  (4'h 5)
  `define CR_KME_CMD_LZ77_WIN_SIZE_E_RSV_WIN  (4'h f)

`define CR_KME_CMD_LZ77_DLY_MATCH_WIN_E_DECL   1:0
`define CR_KME_CMD_LZ77_DLY_MATCH_WIN_E_WIDTH  2
  `define CR_KME_CMD_LZ77_DLY_MATCH_WIN_E_NO_MATCH  (2'h 0)
  `define CR_KME_CMD_LZ77_DLY_MATCH_WIN_E_CHAR_1    (2'h 1)
  `define CR_KME_CMD_LZ77_DLY_MATCH_WIN_E_CHAR_2    (2'h 2)
  `define CR_KME_CMD_LZ77_DLY_MATCH_WIN_E_RSV_DLY   (2'h 3)

`define CR_KME_CMD_LZ77_MIN_MATCH_LEN_E_DECL   0:0
`define CR_KME_CMD_LZ77_MIN_MATCH_LEN_E_WIDTH  1
  `define CR_KME_CMD_LZ77_MIN_MATCH_LEN_E_CHAR_3  (1'h 0)
  `define CR_KME_CMD_LZ77_MIN_MATCH_LEN_E_CHAR_4  (1'h 1)

`define CR_KME_CMD_LZ77_MAX_SYMB_LEN_E_DECL   1:0
`define CR_KME_CMD_LZ77_MAX_SYMB_LEN_E_WIDTH  2
  `define CR_KME_CMD_LZ77_MAX_SYMB_LEN_E_LEN_LZ77_WIN  (2'h 0)
  `define CR_KME_CMD_LZ77_MAX_SYMB_LEN_E_LEN_256B      (2'h 1)
  `define CR_KME_CMD_LZ77_MAX_SYMB_LEN_E_MIN_MTCH_14   (2'h 2)
  `define CR_KME_CMD_LZ77_MAX_SYMB_LEN_E_LEN_64B       (2'h 3)

`define CR_KME_CMD_XP10_PREFIX_MODE_E_DECL   1:0
`define CR_KME_CMD_XP10_PREFIX_MODE_E_WIDTH  2
  `define CR_KME_CMD_XP10_PREFIX_MODE_E_NO_PREFIX      (2'h 0)
  `define CR_KME_CMD_XP10_PREFIX_MODE_E_USER_PREFIX    (2'h 1)
  `define CR_KME_CMD_XP10_PREFIX_MODE_E_PREDEF_PREFIX  (2'h 2)
  `define CR_KME_CMD_XP10_PREFIX_MODE_E_PREDET_HUFF    (2'h 3)

`define CR_KME_CMD_XP10_CRC_MODE_E_DECL   0:0
`define CR_KME_CMD_XP10_CRC_MODE_E_WIDTH  1
  `define CR_KME_CMD_XP10_CRC_MODE_E_CRC32  (1'h 0)
  `define CR_KME_CMD_XP10_CRC_MODE_E_CRC64  (1'h 1)

`define CR_KME_CMD_CHU_COMP_THRSH_E_DECL   1:0
`define CR_KME_CMD_CHU_COMP_THRSH_E_WIDTH  2
  `define CR_KME_CMD_CHU_COMP_THRSH_E_FRM          (2'h 0)
  `define CR_KME_CMD_CHU_COMP_THRSH_E_FRM_LESS_16  (2'h 1)
  `define CR_KME_CMD_CHU_COMP_THRSH_E_INF          (2'h 2)
  `define CR_KME_CMD_CHU_COMP_THRSH_E_RSV_THRSH    (2'h 3)

`define CR_KME_CMD_CIPHER_MODE_E_DECL   0:0
`define CR_KME_CMD_CIPHER_MODE_E_WIDTH  1
  `define CR_KME_CMD_CIPHER_MODE_E_NO_CIPHER  (1'h 0)
  `define CR_KME_CMD_CIPHER_MODE_E_CIPHER     (1'h 1)

`define CR_KME_CMD_AUTH_OP_E_DECL   3:0
`define CR_KME_CMD_AUTH_OP_E_WIDTH  4
  `define CR_KME_CMD_AUTH_OP_E_AUTH_NULL  (4'h 0)
  `define CR_KME_CMD_AUTH_OP_E_SHA2       (4'h 1)
  `define CR_KME_CMD_AUTH_OP_E_HMAC_SHA2  (4'h 2)
  `define CR_KME_CMD_AUTH_OP_E_AUTH_RSVD  (4'h f)

`define CR_KME_CMD_CIPHER_OP_E_DECL   3:0
`define CR_KME_CMD_CIPHER_OP_E_WIDTH  4
  `define CR_KME_CMD_CIPHER_OP_E_CPH_NULL     (4'h 0)
  `define CR_KME_CMD_CIPHER_OP_E_AES_GCM      (4'h 1)
  `define CR_KME_CMD_CIPHER_OP_E_AES_XTS_XEX  (4'h 2)
  `define CR_KME_CMD_CIPHER_OP_E_AES_GMAC     (4'h 3)
  `define CR_KME_CMD_CIPHER_OP_E_CPH_RSVD     (4'h f)

`define CR_KME_CMD_IV_SRC_E_DECL   1:0
`define CR_KME_CMD_IV_SRC_E_WIDTH  2
  `define CR_KME_CMD_IV_SRC_E_IV_NONE      (2'h 0)
  `define CR_KME_CMD_IV_SRC_E_IV_AUX_CMD   (2'h 1)
  `define CR_KME_CMD_IV_SRC_E_IV_KEYS      (2'h 2)
  `define CR_KME_CMD_IV_SRC_E_IV_AUX_FRMD  (2'h 3)

`define CR_KME_CMD_IV_OP_E_DECL   1:0
`define CR_KME_CMD_IV_OP_E_WIDTH  2
  `define CR_KME_CMD_IV_OP_E_IV_SRC  (2'h 0)
  `define CR_KME_CMD_IV_OP_E_IV_RND  (2'h 1)
  `define CR_KME_CMD_IV_OP_E_IV_INC  (2'h 2)
  `define CR_KME_CMD_IV_OP_E_IV_RSV  (2'h 3)

`define CR_KME_CMD_CIPHER_PAD_E_DECL   0:0
`define CR_KME_CMD_CIPHER_PAD_E_WIDTH  1
  `define CR_KME_CMD_CIPHER_PAD_E_NO_PAD   (1'h 0)
  `define CR_KME_CMD_CIPHER_PAD_E_PAD_16B  (1'h 1)

`define CR_KME_CMD_DIGEST_SIZE_E_DECL   0:0
`define CR_KME_CMD_DIGEST_SIZE_E_WIDTH  1
  `define CR_KME_CMD_DIGEST_SIZE_E_DGST_256  (1'h 0)
  `define CR_KME_CMD_DIGEST_SIZE_E_DGST_64   (1'h 1)

`define CR_KME_RQE_FRAME_TYPE_E_DECL   0:0
`define CR_KME_RQE_FRAME_TYPE_E_WIDTH  1
  `define CR_KME_RQE_FRAME_TYPE_E_SIMPLE    (1'h 0)
  `define CR_KME_RQE_FRAME_TYPE_E_COMPOUND  (1'h 1)

`define CR_KME_RQE_TRACE_E_DECL   0:0
`define CR_KME_RQE_TRACE_E_WIDTH  1
  `define CR_KME_RQE_TRACE_E_TRACE_OFF  (1'h 0)
  `define CR_KME_RQE_TRACE_E_TRACE_ON   (1'h 1)

`define CR_KME_RQE_FRAME_SIZE_E_DECL   3:0
`define CR_KME_RQE_FRAME_SIZE_E_WIDTH  4
  `define CR_KME_RQE_FRAME_SIZE_E_RQE_SIMPLE          (4'h 0)
  `define CR_KME_RQE_FRAME_SIZE_E_RQE_COMPOUND_4K     (4'h 5)
  `define CR_KME_RQE_FRAME_SIZE_E_RQE_COMPOUND_8K     (4'h 6)
  `define CR_KME_RQE_FRAME_SIZE_E_RQE_RSV_FRAME_SIZE  (4'h f)

`define CR_KME_FRMD_CODING_E_DECL   1:0
`define CR_KME_FRMD_CODING_E_WIDTH  2
  `define CR_KME_FRMD_CODING_E_RAW        (2'h 1)
  `define CR_KME_FRMD_CODING_E_PARSEABLE  (2'h 0)
  `define CR_KME_FRMD_CODING_E_XP10CFH4K  (2'h 2)
  `define CR_KME_FRMD_CODING_E_XP10CFH8K  (2'h 3)

`define CR_KME_FRMD_MAC_SIZE_E_DECL   1:0
`define CR_KME_FRMD_MAC_SIZE_E_WIDTH  2
  `define CR_KME_FRMD_MAC_SIZE_E_DIGEST_64B   (2'h 0)
  `define CR_KME_FRMD_MAC_SIZE_E_DIGEST_128B  (2'h 1)
  `define CR_KME_FRMD_MAC_SIZE_E_DIGEST_256B  (2'h 2)
  `define CR_KME_FRMD_MAC_SIZE_E_DIGEST_0B    (2'h 3)

`define CR_KME_TLV_TYPES_E_DECL   7:0
`define CR_KME_TLV_TYPES_E_WIDTH  8
  `define CR_KME_TLV_TYPES_E_RQE                (8'h 0)
  `define CR_KME_TLV_TYPES_E_CMD                (8'h 1)
  `define CR_KME_TLV_TYPES_E_KEY                (8'h 2)
  `define CR_KME_TLV_TYPES_E_PHD                (8'h 3)
  `define CR_KME_TLV_TYPES_E_PFD                (8'h 4)
  `define CR_KME_TLV_TYPES_E_DATA               (8'h 13)
  `define CR_KME_TLV_TYPES_E_FTR                (8'h 6)
  `define CR_KME_TLV_TYPES_E_LZ77               (8'h 7)
  `define CR_KME_TLV_TYPES_E_STAT               (8'h 8)
  `define CR_KME_TLV_TYPES_E_CQE                (8'h 9)
  `define CR_KME_TLV_TYPES_E_GUID               (8'h a)
  `define CR_KME_TLV_TYPES_E_FRMD_USER_NULL     (8'h b)
  `define CR_KME_TLV_TYPES_E_FRMD_USER_PI16     (8'h c)
  `define CR_KME_TLV_TYPES_E_FRMD_USER_PI64     (8'h d)
  `define CR_KME_TLV_TYPES_E_FRMD_USER_VM       (8'h e)
  `define CR_KME_TLV_TYPES_E_FRMD_INT_APP       (8'h f)
  `define CR_KME_TLV_TYPES_E_FRMD_INT_SIP       (8'h 10)
  `define CR_KME_TLV_TYPES_E_FRMD_INT_LIP       (8'h 11)
  `define CR_KME_TLV_TYPES_E_FRMD_INT_VM        (8'h 12)
  `define CR_KME_TLV_TYPES_E_FRMD_INT_VM_SHORT  (8'h 16)
  `define CR_KME_TLV_TYPES_E_DATA_UNK           (8'h 5)
  `define CR_KME_TLV_TYPES_E_CR_IV              (8'h 14)
  `define CR_KME_TLV_TYPES_E_AUX_CMD            (8'h 15)
  `define CR_KME_TLV_TYPES_E_AUX_CMD_IV         (8'h 17)
  `define CR_KME_TLV_TYPES_E_AUX_CMD_GUID       (8'h 18)
  `define CR_KME_TLV_TYPES_E_AUX_CMD_GUID_IV    (8'h 19)
  `define CR_KME_TLV_TYPES_E_SCH                (8'h 1a)
  `define CR_KME_TLV_TYPES_E_RSV_TLV            (8'h ff)

`define CR_KME_TLV_PARSE_ACTION_E_DECL   1:0
`define CR_KME_TLV_PARSE_ACTION_E_WIDTH  2
  `define CR_KME_TLV_PARSE_ACTION_E_REP     (2'h 0)
  `define CR_KME_TLV_PARSE_ACTION_E_PASS    (2'h 1)
  `define CR_KME_TLV_PARSE_ACTION_E_MODIFY  (2'h 2)
  `define CR_KME_TLV_PARSE_ACTION_E_DELETE  (2'h 3)

`define CR_KME_TLVP_CORRUPT_E_DECL   0:0
`define CR_KME_TLVP_CORRUPT_E_WIDTH  1
  `define CR_KME_TLVP_CORRUPT_E_USER  (1'h 0)
  `define CR_KME_TLVP_CORRUPT_E_TLVP  (1'h 1)

`define CR_KME_CMD_TYPE_E_DECL   0:0
`define CR_KME_CMD_TYPE_E_WIDTH  1
  `define CR_KME_CMD_TYPE_E_DATAPATH_CORRUPT  (1'h 0)
  `define CR_KME_CMD_TYPE_E_FUNCTIONAL_ERROR  (1'h 1)

`define CR_KME_CMD_MODE_E_DECL   1:0
`define CR_KME_CMD_MODE_E_WIDTH  2
  `define CR_KME_CMD_MODE_E_SINGLE_ERR        (2'h 0)
  `define CR_KME_CMD_MODE_E_CONTINUOUS_ERROR  (2'h 1)
  `define CR_KME_CMD_MODE_E_STOP              (2'h 2)
  `define CR_KME_CMD_MODE_E_EOT               (2'h 3)

`define CR_KME_AUX_KEY_TYPE_E_DECL   5:0
`define CR_KME_AUX_KEY_TYPE_E_WIDTH  6
  `define CR_KME_AUX_KEY_TYPE_E_NO_AUX_KEY           (6'h 0)
  `define CR_KME_AUX_KEY_TYPE_E_AUX_KEY_ONLY         (6'h 1)
  `define CR_KME_AUX_KEY_TYPE_E_DEK256               (6'h 2)
  `define CR_KME_AUX_KEY_TYPE_E_DEK512               (6'h 3)
  `define CR_KME_AUX_KEY_TYPE_E_DAK                  (6'h 4)
  `define CR_KME_AUX_KEY_TYPE_E_DEK256_DAK           (6'h 5)
  `define CR_KME_AUX_KEY_TYPE_E_DEK512_DAK           (6'h 6)
  `define CR_KME_AUX_KEY_TYPE_E_ENC_DEK256           (6'h 7)
  `define CR_KME_AUX_KEY_TYPE_E_ENC_DEK512           (6'h 8)
  `define CR_KME_AUX_KEY_TYPE_E_ENC_DAK              (6'h 9)
  `define CR_KME_AUX_KEY_TYPE_E_ENC_DEK256_DAK       (6'h a)
  `define CR_KME_AUX_KEY_TYPE_E_ENC_DEK512_DAK       (6'h b)
  `define CR_KME_AUX_KEY_TYPE_E_ENC_DEK256_DAK_COMB  (6'h c)
  `define CR_KME_AUX_KEY_TYPE_E_ENC_DEK512_DAK_COMB  (6'h d)
  `define CR_KME_AUX_KEY_TYPE_E_KEY_TYPE_RSV         (6'h 3f)

`define CR_KME_AUX_KEY_OP_E_DECL   0:0
`define CR_KME_AUX_KEY_OP_E_WIDTH  1
  `define CR_KME_AUX_KEY_OP_E_NOOP  (1'h 0)
  `define CR_KME_AUX_KEY_OP_E_KDF   (1'h 1)

`define CR_KME_AUX_KDF_MODE_E_DECL   1:0
`define CR_KME_AUX_KDF_MODE_E_WIDTH  2
  `define CR_KME_AUX_KDF_MODE_E_KDF_MODE_GUID        (2'h 0)
  `define CR_KME_AUX_KDF_MODE_E_KDF_MODE_RGUID       (2'h 1)
  `define CR_KME_AUX_KDF_MODE_E_KDF_MODE_COMB_GUID   (2'h 2)
  `define CR_KME_AUX_KDF_MODE_E_KDF_MODE_COMB_RGUID  (2'h 3)

`define CR_KME_CCEIP_STATS_E_DECL   9:0
`define CR_KME_CCEIP_STATS_E_WIDTH  10
  `define CR_KME_CCEIP_STATS_E_CKMIC_IV_MISMATCH_FRAME                   (10'h 0)
  `define CR_KME_CCEIP_STATS_E_CKMIC_ENGINE_ID_MISMATCH_FRAME            (10'h 1)
  `define CR_KME_CCEIP_STATS_E_CKMIC_SEQ_ID_MISMATCH_FRAME               (10'h 2)
  `define CR_KME_CCEIP_STATS_E_CKMIC_HMAC_SHA256_TAG_FAIL_FRAME          (10'h 3)
  `define CR_KME_CCEIP_STATS_E_CKMIC_SHA256_TAG_FAIL_FRAME               (10'h 4)
  `define CR_KME_CCEIP_STATS_E_CKMIC_GMAC_TAG_FAIL_FRAME                 (10'h 5)
  `define CR_KME_CCEIP_STATS_E_CKMIC_GCM_TAG_FAIL_FRAME                  (10'h 6)
  `define CR_KME_CCEIP_STATS_E_CKMIC_AUTH_NOP_FRAME                      (10'h 7)
  `define CR_KME_CCEIP_STATS_E_CKMIC_AUTH_HMAC_SHA256_FRAME              (10'h 8)
  `define CR_KME_CCEIP_STATS_E_CKMIC_AUTH_SHA256_FRAME                   (10'h 9)
  `define CR_KME_CCEIP_STATS_E_CKMIC_AUTH_AES_GMAC_FRAME                 (10'h a)
  `define CR_KME_CCEIP_STATS_E_CKMIC_CIPH_NOP_FRAME                      (10'h b)
  `define CR_KME_CCEIP_STATS_E_CKMIC_CIPH_AES_XEX_FRAME                  (10'h c)
  `define CR_KME_CCEIP_STATS_E_CKMIC_CIPH_AES_XTS_FRAME                  (10'h d)
  `define CR_KME_CCEIP_STATS_E_CKMIC_CIPH_AES_GCM_FRAME                  (10'h e)
  `define CR_KME_CCEIP_STATS_E_CG_CQE_OUTPUT_COMMAND                     (10'h 63)
  `define CR_KME_CCEIP_STATS_E_CG_SYSTEM_ERROR_COMMAND                   (10'h 62)
  `define CR_KME_CCEIP_STATS_E_CG_SELECT_ENGINE_ERROR_COMMAND            (10'h 61)
  `define CR_KME_CCEIP_STATS_E_CG_ENGINE_ERROR_COMMAND                   (10'h 60)
  `define CR_KME_CCEIP_STATS_E_CRCC0_NVME_CHSUM_ERROR_TOTAL              (10'h 5f)
  `define CR_KME_CCEIP_STATS_E_CRCC0_NVME_CHSUM_GOOD_TOTAL               (10'h 5e)
  `define CR_KME_CCEIP_STATS_E_CRCC0_ENC_CHSUM_ERROR_TOTAL               (10'h 5d)
  `define CR_KME_CCEIP_STATS_E_CRCC0_ENC_CHSUM_GOOD_TOTAL                (10'h 5c)
  `define CR_KME_CCEIP_STATS_E_CRCC0_CRC64E_CHSUM_ERROR_TOTAL            (10'h 5b)
  `define CR_KME_CCEIP_STATS_E_CRCC0_CRC64E_CHSUM_GOOD_TOTAL             (10'h 5a)
  `define CR_KME_CCEIP_STATS_E_CRCC0_RAW_CHSUM_ERROR_TOTAL               (10'h 59)
  `define CR_KME_CCEIP_STATS_E_CRCC0_RAW_CHSUM_GOOD_TOTAL                (10'h 58)
  `define CR_KME_CCEIP_STATS_E_CRCC1_NVME_CHSUM_ERROR_TOTAL              (10'h 57)
  `define CR_KME_CCEIP_STATS_E_CRCC1_NVME_CHSUM_GOOD_TOTAL               (10'h 56)
  `define CR_KME_CCEIP_STATS_E_CRCC1_ENC_CHSUM_ERROR_TOTAL               (10'h 55)
  `define CR_KME_CCEIP_STATS_E_CRCC1_ENC_CHSUM_GOOD_TOTAL                (10'h 54)
  `define CR_KME_CCEIP_STATS_E_CRCC1_CRC64E_CHSUM_ERROR_TOTAL            (10'h 53)
  `define CR_KME_CCEIP_STATS_E_CRCC1_CRC64E_CHSUM_GOOD_TOTAL             (10'h 52)
  `define CR_KME_CCEIP_STATS_E_CRCC1_RAW_CHSUM_ERROR_TOTAL               (10'h 51)
  `define CR_KME_CCEIP_STATS_E_CRCC1_RAW_CHSUM_GOOD_TOTAL                (10'h 50)
  `define CR_KME_CCEIP_STATS_E_CRCGC0_NVME_CHSUM_ERROR_TOTAL             (10'h 4f)
  `define CR_KME_CCEIP_STATS_E_CRCGC0_NVME_CHSUM_GOOD_TOTAL              (10'h 4e)
  `define CR_KME_CCEIP_STATS_E_CRCGC0_ENC_CHSUM_ERROR_TOTAL              (10'h 4d)
  `define CR_KME_CCEIP_STATS_E_CRCGC0_ENC_CHSUM_GOOD_TOTAL               (10'h 4c)
  `define CR_KME_CCEIP_STATS_E_CRCGC0_CRC64E_CHSUM_ERROR_TOTAL           (10'h 4b)
  `define CR_KME_CCEIP_STATS_E_CRCGC0_CRC64E_CHSUM_GOOD_TOTAL            (10'h 4a)
  `define CR_KME_CCEIP_STATS_E_CRCGC0_RAW_CHSUM_ERROR_TOTAL              (10'h 49)
  `define CR_KME_CCEIP_STATS_E_CRCGC0_RAW_CHSUM_GOOD_TOTAL               (10'h 48)
  `define CR_KME_CCEIP_STATS_E_CRCG0_NVME_CHSUM_ERROR_TOTAL              (10'h 47)
  `define CR_KME_CCEIP_STATS_E_CRCG0_NVME_CHSUM_GOOD_TOTAL               (10'h 46)
  `define CR_KME_CCEIP_STATS_E_CRCG0_ENC_CHSUM_ERROR_TOTAL               (10'h 45)
  `define CR_KME_CCEIP_STATS_E_CRCG0_ENC_CHSUM_GOOD_TOTAL                (10'h 44)
  `define CR_KME_CCEIP_STATS_E_CRCG0_CRC64E_CHSUM_ERROR_TOTAL            (10'h 43)
  `define CR_KME_CCEIP_STATS_E_CRCG0_CRC64E_CHSUM_GOOD_TOTAL             (10'h 42)
  `define CR_KME_CCEIP_STATS_E_CRCG0_RAW_CHSUM_ERROR_TOTAL               (10'h 41)
  `define CR_KME_CCEIP_STATS_E_CRCG0_RAW_CHSUM_GOOD_TOTAL                (10'h 40)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_XP9_FRM_TOTAL                     (10'h 140)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_XP9_BLK_TOTAL                     (10'h 141)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_XP9_RAW_FRM_TOTAL                 (10'h 142)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_XP10_FRM_TOTAL                    (10'h 143)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_XP10_FRM_PFX_TOTAL                (10'h 144)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_XP10_FRM_PDH_TOTAL                (10'h 145)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_XP10_BLK_TOTAL                    (10'h 146)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_XP10_RAW_BLK_TOTAL                (10'h 147)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_GZIP_FRM_TOTAL                    (10'h 148)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_GZIP_BLK_TOTAL                    (10'h 149)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_GZIP_RAW_BLK_TOTAL                (10'h 14a)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_ZLIB_FRM_TOTAL                    (10'h 14b)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_ZLIB_BLK_TOTAL                    (10'h 14c)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_ZLIB_RAW_BLK_TOTAL                (10'h 14d)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_CHU4K_TOTAL                       (10'h 14e)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_CHU8K_TOTAL                       (10'h 14f)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_CHU4K_RAW_TOTAL                   (10'h 150)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_CHU8K_RAW_TOTAL                   (10'h 151)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_PFX_CRC_ERR_TOTAL                 (10'h 152)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_PHD_CRC_ERR_TOTAL                 (10'h 153)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_XP9_CRC_ERR_TOTAL                 (10'h 154)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_XP9_SIMPLE_SHORT_BLK_TOTAL       (10'h 155)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_XP9_RETRO_SHORT_BLK_TOTAL        (10'h 156)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_XP9_SIMPLE_LONG_BLK_TOTAL        (10'h 157)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_XP9_RETRO_LONG_BLK_TOTAL         (10'h 158)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_XP10_SIMPLE_SHORT_BLK_TOTAL      (10'h 159)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_XP10_RETRO_SHORT_BLK_TOTAL       (10'h 15a)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_XP10_PREDEF_SHORT_BLK_TOTAL      (10'h 15b)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_XP10_SIMPLE_LONG_BLK_TOTAL       (10'h 15c)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_XP10_RETRO_LONG_BLK_TOTAL        (10'h 15d)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_XP10_PREDEF_LONG_BLK_TOTAL       (10'h 15e)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_CHU4K_SIMPLE_SHORT_BLK_TOTAL     (10'h 15f)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_CHU4K_RETRO_SHORT_BLK_TOTAL      (10'h 160)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_CHU4K_PREDEF_SHORT_BLK_TOTAL     (10'h 161)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_CHU4K_SIMPLE_LONG_BLK_TOTAL      (10'h 162)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_CHU4K_RETRO_LONG_BLK_TOTAL       (10'h 163)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_CHU4K_PREDEF_LONG_BLK_TOTAL      (10'h 164)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_CHU8K_SIMPLE_SHORT_BLK_TOTAL     (10'h 165)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_CHU8K_RETRO_SHORT_BLK_TOTAL      (10'h 166)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_CHU8K_PREDEF_SHORT_BLK_TOTAL     (10'h 167)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_CHU8K_SIMPLE_LONG_BLK_TOTAL      (10'h 168)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_CHU8K_RETRO_LONG_BLK_TOTAL       (10'h 169)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_CHU8K_PREDEF_LONG_BLK_TOTAL      (10'h 16a)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_DEFLATE_DYNAMIC_BLK_TOTAL        (10'h 16b)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_DEFLATE_FIXED_BLK_TOTAL          (10'h 16c)
  `define CR_KME_CCEIP_STATS_E_HUFD_MTF_0_TOTAL                          (10'h 16d)
  `define CR_KME_CCEIP_STATS_E_HUFD_MTF_1_TOTAL                          (10'h 16e)
  `define CR_KME_CCEIP_STATS_E_HUFD_MTF_2_TOTAL                          (10'h 16f)
  `define CR_KME_CCEIP_STATS_E_HUFD_MTF_3_TOTAL                          (10'h 170)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_FHP_STALL_TOTAL                   (10'h 171)
  `define CR_KME_CCEIP_STATS_E_HUFD_FE_LFA_STALL_TOTAL                   (10'h 172)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_PREDEF_STALL_TOTAL               (10'h 173)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_HDR_DATA_STALL_TOTAL             (10'h 174)
  `define CR_KME_CCEIP_STATS_E_HUFD_HTF_HDR_INFO_STALL_TOTAL             (10'h 175)
  `define CR_KME_CCEIP_STATS_E_HUFD_SDD_INPUT_STALL_TOTAL                (10'h 176)
  `define CR_KME_CCEIP_STATS_E_HUFD_SDD_BUF_FULL_STALL_TOTAL             (10'h 177)
  `define CR_KME_CCEIP_STATS_E_LZ77D_PTR_LEN_256_TOTAL                   (10'h 180)
  `define CR_KME_CCEIP_STATS_E_LZ77D_PTR_LEN_128_TOTAL                   (10'h 181)
  `define CR_KME_CCEIP_STATS_E_LZ77D_PTR_LEN_64_TOTAL                    (10'h 182)
  `define CR_KME_CCEIP_STATS_E_LZ77D_PTR_LEN_32_TOTAL                    (10'h 183)
  `define CR_KME_CCEIP_STATS_E_LZ77D_PTR_LEN_11_TOTAL                    (10'h 184)
  `define CR_KME_CCEIP_STATS_E_LZ77D_PTR_LEN_10_TOTAL                    (10'h 185)
  `define CR_KME_CCEIP_STATS_E_LZ77D_PTR_LEN_9_TOTAL                     (10'h 186)
  `define CR_KME_CCEIP_STATS_E_LZ77D_PTR_LEN_8_TOTAL                     (10'h 187)
  `define CR_KME_CCEIP_STATS_E_LZ77D_PTR_LEN_7_TOTAL                     (10'h 188)
  `define CR_KME_CCEIP_STATS_E_LZ77D_PTR_LEN_6_TOTAL                     (10'h 189)
  `define CR_KME_CCEIP_STATS_E_LZ77D_PTR_LEN_5_TOTAL                     (10'h 18a)
  `define CR_KME_CCEIP_STATS_E_LZ77D_PTR_LEN_4_TOTAL                     (10'h 18b)
  `define CR_KME_CCEIP_STATS_E_LZ77D_PTR_LEN_3_TOTAL                     (10'h 18c)
  `define CR_KME_CCEIP_STATS_E_LZ77D_LANE_1_LITERALS_TOTAL               (10'h 18d)
  `define CR_KME_CCEIP_STATS_E_LZ77D_LANE_2_LITERALS_TOTAL               (10'h 18e)
  `define CR_KME_CCEIP_STATS_E_LZ77D_LANE_3_LITERALS_TOTAL               (10'h 18f)
  `define CR_KME_CCEIP_STATS_E_LZ77D_LANE_4_LITERALS_TOTAL               (10'h 190)
  `define CR_KME_CCEIP_STATS_E_LZ77D_PTRS_TOTAL                          (10'h 191)
  `define CR_KME_CCEIP_STATS_E_LZ77D_FRM_IN_TOTAL                        (10'h 192)
  `define CR_KME_CCEIP_STATS_E_LZ77D_FRM_OUT_TOTAL                       (10'h 193)
  `define CR_KME_CCEIP_STATS_E_LZ77D_STALL_TOTAL                         (10'h 194)
  `define CR_KME_CCEIP_STATS_E_DECRYPT_IV_MISMATCH_FRAME                 (10'h 1c0)
  `define CR_KME_CCEIP_STATS_E_DECRYPT_ENGINE_ID_MISMATCH_FRAME          (10'h 1c1)
  `define CR_KME_CCEIP_STATS_E_DECRYPT_SEQ_ID_MISMATCH_FRAME             (10'h 1c2)
  `define CR_KME_CCEIP_STATS_E_DECRYPT_HMAC_SHA256_TAG_FAIL_FRAME        (10'h 1c3)
  `define CR_KME_CCEIP_STATS_E_DECRYPT_SHA256_TAG_FAIL_FRAME             (10'h 1c4)
  `define CR_KME_CCEIP_STATS_E_DECRYPT_GMAC_TAG_FAIL_FRAME               (10'h 1c5)
  `define CR_KME_CCEIP_STATS_E_DECRYPT_GCM_TAG_FAIL_FRAME                (10'h 1c6)
  `define CR_KME_CCEIP_STATS_E_DECRYPT_AUTH_NOP_FRAME                    (10'h 1c7)
  `define CR_KME_CCEIP_STATS_E_DECRYPT_AUTH_HMAC_SHA256_FRAME            (10'h 1c8)
  `define CR_KME_CCEIP_STATS_E_DECRYPT_AUTH_SHA256_FRAME                 (10'h 1c9)
  `define CR_KME_CCEIP_STATS_E_DECRYPT_AUTH_AES_GMAC_FRAME               (10'h 1ca)
  `define CR_KME_CCEIP_STATS_E_DECRYPT_CIPH_NOP_FRAME                    (10'h 1cb)
  `define CR_KME_CCEIP_STATS_E_DECRYPT_CIPH_AES_XEX_FRAME                (10'h 1cc)
  `define CR_KME_CCEIP_STATS_E_DECRYPT_CIPH_AES_XTS_FRAME                (10'h 1cd)
  `define CR_KME_CCEIP_STATS_E_DECRYPT_CIPH_AES_GCM_FRAME                (10'h 1ce)
  `define CR_KME_CCEIP_STATS_E_OSF_DATA_INPUT_STALL_TOTAL                (10'h 200)
  `define CR_KME_CCEIP_STATS_E_OSF_CG_INPUT_STALL_TOTAL                  (10'h 201)
  `define CR_KME_CCEIP_STATS_E_OSF_OUTPUT_BACKPRESSURE_TOTAL             (10'h 202)
  `define CR_KME_CCEIP_STATS_E_OSF_OUTPUT_STALL_TOTAL                    (10'h 203)
  `define CR_KME_CCEIP_STATS_E_ENCRYPT_IV_MISMATCH_FRAME                 (10'h 240)
  `define CR_KME_CCEIP_STATS_E_ENCRYPT_ENGINE_ID_MISMATCH_FRAME          (10'h 241)
  `define CR_KME_CCEIP_STATS_E_ENCRYPT_SEQ_ID_MISMATCH_FRAME             (10'h 242)
  `define CR_KME_CCEIP_STATS_E_ENCRYPT_HMAC_SHA256_TAG_FAIL_FRAME        (10'h 243)
  `define CR_KME_CCEIP_STATS_E_ENCRYPT_SHA256_TAG_FAIL_FRAME             (10'h 244)
  `define CR_KME_CCEIP_STATS_E_ENCRYPT_GMAC_TAG_FAIL_FRAME               (10'h 245)
  `define CR_KME_CCEIP_STATS_E_ENCRYPT_GCM_TAG_FAIL_FRAME                (10'h 246)
  `define CR_KME_CCEIP_STATS_E_ENCRYPT_AUTH_NOP_FRAME                    (10'h 247)
  `define CR_KME_CCEIP_STATS_E_ENCRYPT_AUTH_HMAC_SHA256_FRAME            (10'h 248)
  `define CR_KME_CCEIP_STATS_E_ENCRYPT_AUTH_SHA256_FRAME                 (10'h 249)
  `define CR_KME_CCEIP_STATS_E_ENCRYPT_AUTH_AES_GMAC_FRAME               (10'h 24a)
  `define CR_KME_CCEIP_STATS_E_ENCRYPT_CIPH_NOP_FRAME                    (10'h 24b)
  `define CR_KME_CCEIP_STATS_E_ENCRYPT_CIPH_AES_XEX_FRAME                (10'h 24c)
  `define CR_KME_CCEIP_STATS_E_ENCRYPT_CIPH_AES_XTS_FRAME                (10'h 24d)
  `define CR_KME_CCEIP_STATS_E_ENCRYPT_CIPH_AES_GCM_FRAME                (10'h 24e)
  `define CR_KME_CCEIP_STATS_E_SHORT_MAP_ERR_TOTAL                       (10'h 280)
  `define CR_KME_CCEIP_STATS_E_LONG_MAP_ERR_TOTAL                        (10'h 281)
  `define CR_KME_CCEIP_STATS_E_XP9_BLK_COMP_TOTAL                        (10'h 282)
  `define CR_KME_CCEIP_STATS_E_XP9_FRM_RAW_TOTAL                         (10'h 283)
  `define CR_KME_CCEIP_STATS_E_XP9_FRM_TOTAL                             (10'h 284)
  `define CR_KME_CCEIP_STATS_E_XP9_BLK_SHORT_SIM_TOTAL                   (10'h 285)
  `define CR_KME_CCEIP_STATS_E_XP9_BLK_LONG_SIM_TOTAL                    (10'h 286)
  `define CR_KME_CCEIP_STATS_E_XP9_BLK_SHORT_RET_TOTAL                   (10'h 287)
  `define CR_KME_CCEIP_STATS_E_XP9_BLK_LONG_RET_TOTAL                    (10'h 288)
  `define CR_KME_CCEIP_STATS_E_XP10_BLK_COMP_TOTAL                       (10'h 289)
  `define CR_KME_CCEIP_STATS_E_XP10_BLK_RAW_TOTAL                        (10'h 28a)
  `define CR_KME_CCEIP_STATS_E_XP10_BLK_SHORT_SIM_TOTAL                  (10'h 28b)
  `define CR_KME_CCEIP_STATS_E_XP10_BLK_LONG_SIM_TOTAL                   (10'h 28c)
  `define CR_KME_CCEIP_STATS_E_XP10_BLK_SHORT_RET_TOTAL                  (10'h 28d)
  `define CR_KME_CCEIP_STATS_E_XP10_BLK_LONG_RET_TOTAL                   (10'h 28e)
  `define CR_KME_CCEIP_STATS_E_XP10_BLK_SHORT_PRE_TOTAL                  (10'h 28f)
  `define CR_KME_CCEIP_STATS_E_XP10_BLK_LONG_PRE_TOTAL                   (10'h 290)
  `define CR_KME_CCEIP_STATS_E_XP10_FRM_TOTAL                            (10'h 291)
  `define CR_KME_CCEIP_STATS_E_CHU8_FRM_RAW_TOTAL                        (10'h 292)
  `define CR_KME_CCEIP_STATS_E_CHU8_FRM_COMP_TOTAL                       (10'h 293)
  `define CR_KME_CCEIP_STATS_E_CHU8_FRM_SHORT_SIM_TOTAL                  (10'h 294)
  `define CR_KME_CCEIP_STATS_E_CHU8_FRM_LONG_SIM_TOTAL                   (10'h 295)
  `define CR_KME_CCEIP_STATS_E_CHU8_FRM_SHORT_RET_TOTAL                  (10'h 296)
  `define CR_KME_CCEIP_STATS_E_CHU8_FRM_LONG_RET_TOTAL                   (10'h 297)
  `define CR_KME_CCEIP_STATS_E_CHU8_FRM_SHORT_PRE_TOTAL                  (10'h 298)
  `define CR_KME_CCEIP_STATS_E_CHU8_FRM_LONG_PRE_TOTAL                   (10'h 299)
  `define CR_KME_CCEIP_STATS_E_CHU8_CMD_TOTAL                            (10'h 29a)
  `define CR_KME_CCEIP_STATS_E_CHU4_FRM_RAW_TOTAL                        (10'h 29b)
  `define CR_KME_CCEIP_STATS_E_CHU4_FRM_COMP_TOTAL                       (10'h 29c)
  `define CR_KME_CCEIP_STATS_E_CHU4_FRM_SHORT_SIM_TOTAL                  (10'h 29d)
  `define CR_KME_CCEIP_STATS_E_CHU4_FRM_LONG_SIM_TOTAL                   (10'h 29e)
  `define CR_KME_CCEIP_STATS_E_CHU4_FRM_SHORT_RET_TOTAL                  (10'h 29f)
  `define CR_KME_CCEIP_STATS_E_CHU4_FRM_LONG_RET_TOTAL                   (10'h 2a0)
  `define CR_KME_CCEIP_STATS_E_CHU4_FRM_SHORT_PRE_TOTAL                  (10'h 2a1)
  `define CR_KME_CCEIP_STATS_E_CHU4_FRM_LONG_PRE_TOTAL                   (10'h 2a2)
  `define CR_KME_CCEIP_STATS_E_CHU4_CMD_TOTAL                            (10'h 2a3)
  `define CR_KME_CCEIP_STATS_E_DF_BLK_COMP_TOTAL                         (10'h 2a4)
  `define CR_KME_CCEIP_STATS_E_DF_BLK_RAW_TOTAL                          (10'h 2a5)
  `define CR_KME_CCEIP_STATS_E_DF_BLK_SHORT_SIM_TOTAL                    (10'h 2a6)
  `define CR_KME_CCEIP_STATS_E_DF_BLK_LONG_SIM_TOTAL                     (10'h 2a7)
  `define CR_KME_CCEIP_STATS_E_DF_BLK_SHORT_RET_TOTAL                    (10'h 2a8)
  `define CR_KME_CCEIP_STATS_E_DF_BLK_LONG_RET_TOTAL                     (10'h 2a9)
  `define CR_KME_CCEIP_STATS_E_DF_FRM_TOTAL                              (10'h 2aa)
  `define CR_KME_CCEIP_STATS_E_PASS_THRU_FRM_TOTAL                       (10'h 2ab)
  `define CR_KME_CCEIP_STATS_E_BYTE_0_TOTAL                              (10'h 2ac)
  `define CR_KME_CCEIP_STATS_E_BYTE_1_TOTAL                              (10'h 2ad)
  `define CR_KME_CCEIP_STATS_E_BYTE_2_TOTAL                              (10'h 2ae)
  `define CR_KME_CCEIP_STATS_E_BYTE_3_TOTAL                              (10'h 2af)
  `define CR_KME_CCEIP_STATS_E_BYTE_4_TOTAL                              (10'h 2b0)
  `define CR_KME_CCEIP_STATS_E_BYTE_5_TOTAL                              (10'h 2b1)
  `define CR_KME_CCEIP_STATS_E_BYTE_6_TOTAL                              (10'h 2b2)
  `define CR_KME_CCEIP_STATS_E_BYTE_7_TOTAL                              (10'h 2b3)
  `define CR_KME_CCEIP_STATS_E_ENCRYPT_STALL_TOTAL                       (10'h 2b4)
  `define CR_KME_CCEIP_STATS_E_LZ77_STALL_TOTAL                          (10'h 2b5)
  `define CR_KME_CCEIP_STATS_E_LZ77C_EOF_FRAME                           (10'h 2c0)
  `define CR_KME_CCEIP_STATS_E_LZ77C_BYPASS_FRAME                        (10'h 2c1)
  `define CR_KME_CCEIP_STATS_E_LZ77C_MTF_3_TOTAL                         (10'h 2c2)
  `define CR_KME_CCEIP_STATS_E_LZ77C_MTF_2_TOTAL                         (10'h 2c3)
  `define CR_KME_CCEIP_STATS_E_LZ77C_MTF_1_TOTAL                         (10'h 2c4)
  `define CR_KME_CCEIP_STATS_E_LZ77C_MTF_0_TOTAL                         (10'h 2c5)
  `define CR_KME_CCEIP_STATS_E_LZ77C_RUN_256_NUP_TOTAL                   (10'h 2c6)
  `define CR_KME_CCEIP_STATS_E_LZ77C_RUN_128_255_TOTAL                   (10'h 2c7)
  `define CR_KME_CCEIP_STATS_E_LZ77C_RUN_64_127_TOTAL                    (10'h 2c8)
  `define CR_KME_CCEIP_STATS_E_LZ77C_RUN_32_63_TOTAL                     (10'h 2c9)
  `define CR_KME_CCEIP_STATS_E_LZ77C_RUN_11_31_TOTAL                     (10'h 2ca)
  `define CR_KME_CCEIP_STATS_E_LZ77C_RUN_10_TOTAL                        (10'h 2cb)
  `define CR_KME_CCEIP_STATS_E_LZ77C_RUN_9_TOTAL                         (10'h 2cc)
  `define CR_KME_CCEIP_STATS_E_LZ77C_RUN_8_TOTAL                         (10'h 2cd)
  `define CR_KME_CCEIP_STATS_E_LZ77C_RUN_7_TOTAL                         (10'h 2ce)
  `define CR_KME_CCEIP_STATS_E_LZ77C_RUN_6_TOTAL                         (10'h 2cf)
  `define CR_KME_CCEIP_STATS_E_LZ77C_RUN_5_TOTAL                         (10'h 2d0)
  `define CR_KME_CCEIP_STATS_E_LZ77C_RUN_4_TOTAL                         (10'h 2d1)
  `define CR_KME_CCEIP_STATS_E_LZ77C_RUN_3_TOTAL                         (10'h 2d2)
  `define CR_KME_CCEIP_STATS_E_LZ77C_MTF_TOTAL                           (10'h 2d3)
  `define CR_KME_CCEIP_STATS_E_LZ77C_PTR_TOTAL                           (10'h 2d4)
  `define CR_KME_CCEIP_STATS_E_LZ77C_FOUR_LIT_TOTAL                      (10'h 2d5)
  `define CR_KME_CCEIP_STATS_E_LZ77C_THREE_LIT_TOTAL                     (10'h 2d6)
  `define CR_KME_CCEIP_STATS_E_LZ77C_TWO_LIT_TOTAL                       (10'h 2d7)
  `define CR_KME_CCEIP_STATS_E_LZ77C_ONE_LIT_TOTAL                       (10'h 2d8)
  `define CR_KME_CCEIP_STATS_E_LZ77C_THROTTLED_FRAME                     (10'h 2d9)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_0_TOTAL                        (10'h 340)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_1_TOTAL                        (10'h 341)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_2_TOTAL                        (10'h 342)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_3_TOTAL                        (10'h 343)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_4_TOTAL                        (10'h 344)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_5_TOTAL                        (10'h 345)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_6_TOTAL                        (10'h 346)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_7_TOTAL                        (10'h 347)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_8_TOTAL                        (10'h 348)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_9_TOTAL                        (10'h 349)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_10_TOTAL                       (10'h 34a)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_11_TOTAL                       (10'h 34b)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_12_TOTAL                       (10'h 34c)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_13_TOTAL                       (10'h 34d)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_14_TOTAL                       (10'h 34e)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_15_TOTAL                       (10'h 34f)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_16_TOTAL                       (10'h 350)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_17_TOTAL                       (10'h 351)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_18_TOTAL                       (10'h 352)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_19_TOTAL                       (10'h 353)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_20_TOTAL                       (10'h 354)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_21_TOTAL                       (10'h 355)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_22_TOTAL                       (10'h 356)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_23_TOTAL                       (10'h 357)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_24_TOTAL                       (10'h 358)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_25_TOTAL                       (10'h 359)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_26_TOTAL                       (10'h 35a)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_27_TOTAL                       (10'h 35b)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_28_TOTAL                       (10'h 35c)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_29_TOTAL                       (10'h 35d)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_30_TOTAL                       (10'h 35e)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_31_TOTAL                       (10'h 35f)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_32_TOTAL                       (10'h 360)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_33_TOTAL                       (10'h 361)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_34_TOTAL                       (10'h 362)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_35_TOTAL                       (10'h 363)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_36_TOTAL                       (10'h 364)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_37_TOTAL                       (10'h 365)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_38_TOTAL                       (10'h 366)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_39_TOTAL                       (10'h 367)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_40_TOTAL                       (10'h 368)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_41_TOTAL                       (10'h 369)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_42_TOTAL                       (10'h 36a)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_43_TOTAL                       (10'h 36b)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_44_TOTAL                       (10'h 36c)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_45_TOTAL                       (10'h 36d)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_46_TOTAL                       (10'h 36e)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_47_TOTAL                       (10'h 36f)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_48_TOTAL                       (10'h 370)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_49_TOTAL                       (10'h 371)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_50_TOTAL                       (10'h 372)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_51_TOTAL                       (10'h 373)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_52_TOTAL                       (10'h 374)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_53_TOTAL                       (10'h 375)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_54_TOTAL                       (10'h 376)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_55_TOTAL                       (10'h 377)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_56_TOTAL                       (10'h 378)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_57_TOTAL                       (10'h 379)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_58_TOTAL                       (10'h 37a)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_59_TOTAL                       (10'h 37b)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_60_TOTAL                       (10'h 37c)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_61_TOTAL                       (10'h 37d)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_62_TOTAL                       (10'h 37e)
  `define CR_KME_CCEIP_STATS_E_PREFIX_NUM_63_TOTAL                       (10'h 37f)
  `define CR_KME_CCEIP_STATS_E_ISF_INPUT_COMMANDS                        (10'h 380)
  `define CR_KME_CCEIP_STATS_E_ISF_INPUT_FRAMES                          (10'h 381)
  `define CR_KME_CCEIP_STATS_E_ISF_INPUT_STALL_TOTAL                     (10'h 382)
  `define CR_KME_CCEIP_STATS_E_ISF_INPUT_SYSTEM_STALL_TOTAL              (10'h 383)
  `define CR_KME_CCEIP_STATS_E_ISF_OUTPUT_BACKPRESSURE_TOTAL             (10'h 384)
  `define CR_KME_CCEIP_STATS_E_ISF_AUX_CMD_COMPRESS_CTL_MATCH_COMMAND_0  (10'h 385)
  `define CR_KME_CCEIP_STATS_E_ISF_AUX_CMD_COMPRESS_CTL_MATCH_COMMAND_1  (10'h 386)
  `define CR_KME_CCEIP_STATS_E_ISF_AUX_CMD_COMPRESS_CTL_MATCH_COMMAND_2  (10'h 387)
  `define CR_KME_CCEIP_STATS_E_ISF_AUX_CMD_COMPRESS_CTL_MATCH_COMMAND_3  (10'h 388)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_PTR_LEN_256_TOTAL          (10'h 3c0)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_PTR_LEN_128_TOTAL          (10'h 3c1)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_PTR_LEN_64_TOTAL           (10'h 3c2)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_PTR_LEN_32_TOTAL           (10'h 3c3)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_PTR_LEN_11_TOTAL           (10'h 3c4)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_PTR_LEN_10_TOTAL           (10'h 3c5)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_PTR_LEN_9_TOTAL            (10'h 3c6)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_PTR_LEN_8_TOTAL            (10'h 3c7)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_PTR_LEN_7_TOTAL            (10'h 3c8)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_PTR_LEN_6_TOTAL            (10'h 3c9)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_PTR_LEN_5_TOTAL            (10'h 3ca)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_PTR_LEN_4_TOTAL            (10'h 3cb)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_PTR_LEN_3_TOTAL            (10'h 3cc)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_LANE_4_LITERALS_TOTAL      (10'h 3cd)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_LANE_3_LITERALS_TOTAL      (10'h 3ce)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_LANE_2_LITERALS_TOTAL      (10'h 3cf)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_LANE_1_LITERALS_TOTAL      (10'h 3d0)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_PTRS_TOTAL                 (10'h 3d1)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_FRM_IN_TOTAL               (10'h 3d2)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_FRM_OUT_TOTAL              (10'h 3d3)
  `define CR_KME_CCEIP_STATS_E_HUF_COMP_LZ77D_STALL_STB_TOTAL            (10'h 3d4)
  `define CR_KME_CCEIP_STATS_E_CCEIP_STATS_RESERVED                      (10'h 3ff)

`define CR_KME_IA_OPERATION_E_DECL   3:0
`define CR_KME_IA_OPERATION_E_WIDTH  4
  `define CR_KME_IA_OPERATION_E_NOP             (4'h 0)
  `define CR_KME_IA_OPERATION_E_READ            (4'h 1)
  `define CR_KME_IA_OPERATION_E_WRITE           (4'h 2)
  `define CR_KME_IA_OPERATION_E_ENABLE          (4'h 3)
  `define CR_KME_IA_OPERATION_E_DISABLED        (4'h 4)
  `define CR_KME_IA_OPERATION_E_RESET           (4'h 5)
  `define CR_KME_IA_OPERATION_E_INITIALIZE      (4'h 6)
  `define CR_KME_IA_OPERATION_E_INITIALIZE_INC  (4'h 7)
  `define CR_KME_IA_OPERATION_E_SET_INI_START   (4'h 8)
  `define CR_KME_IA_OPERATION_E_COMPARE         (4'h 9)
  `define CR_KME_IA_OPERATION_E_SIM_TMO         (4'h e)
  `define CR_KME_IA_OPERATION_E_ACK_ERROR       (4'h f)

`define CR_KME_IA_STATUS_E_DECL   2:0
`define CR_KME_IA_STATUS_E_WIDTH  3
  `define CR_KME_IA_STATUS_E_READY  (3'h 0)
  `define CR_KME_IA_STATUS_E_BUSY   (3'h 1)
  `define CR_KME_IA_STATUS_E_TMO    (3'h 2)
  `define CR_KME_IA_STATUS_E_OVR    (3'h 3)
  `define CR_KME_IA_STATUS_E_NXM    (3'h 4)
  `define CR_KME_IA_STATUS_E_UOP    (3'h 5)
  `define CR_KME_IA_STATUS_E_PDN    (3'h 7)

`define CR_KME_MEM_TYPE_E_DECL   3:0
`define CR_KME_MEM_TYPE_E_WIDTH  4
  `define CR_KME_MEM_TYPE_E_SPRAM        (4'h 0)
  `define CR_KME_MEM_TYPE_E_SRFRAM       (4'h 1)
  `define CR_KME_MEM_TYPE_E_REG          (4'h 2)
  `define CR_KME_MEM_TYPE_E_TCAM         (4'h 3)
  `define CR_KME_MEM_TYPE_E_MEM_TYPE_4   (4'h 4)
  `define CR_KME_MEM_TYPE_E_MEM_TYPE_5   (4'h 5)
  `define CR_KME_MEM_TYPE_E_MEM_TYPE_6   (4'h 6)
  `define CR_KME_MEM_TYPE_E_MEM_TYPE_7   (4'h 7)
  `define CR_KME_MEM_TYPE_E_MEM_TYPE_8   (4'h 8)
  `define CR_KME_MEM_TYPE_E_MEM_TYPE_9   (4'h 9)
  `define CR_KME_MEM_TYPE_E_MEM_TYPE_10  (4'h a)
  `define CR_KME_MEM_TYPE_E_MEM_TYPE_11  (4'h b)
  `define CR_KME_MEM_TYPE_E_MEM_TYPE_12  (4'h c)
  `define CR_KME_MEM_TYPE_E_MEM_TYPE_13  (4'h d)
  `define CR_KME_MEM_TYPE_E_MEM_TYPE_14  (4'h e)
  `define CR_KME_MEM_TYPE_E_MEM_TYPE_15  (4'h f)

`define CR_KME_IM_MODE_E_DECL   1:0
`define CR_KME_IM_MODE_E_WIDTH  2
  `define CR_KME_IM_MODE_E_START       (2'h 0)
  `define CR_KME_IM_MODE_E_END         (2'h 1)
  `define CR_KME_IM_MODE_E_CONTINUOUS  (2'h 2)
  `define CR_KME_IM_MODE_E_OFF         (2'h 3)



`define CR_KME_BLKID_REVID_T_DECL   31:0
`define CR_KME_BLKID_REVID_T_WIDTH  32
  `define CR_KME_BLKID_REVID_T_DEFAULT  (32'h cf000000)

`define CR_KME_BLKID_REVID_T_REVID_DECL   15:0
`define CR_KME_BLKID_REVID_T_REVID_WIDTH  16
  `define CR_KME_BLKID_REVID_T_REVID_DEFAULT  (16'h 0)

`define CR_KME_BLKID_REVID_T_BLKID_DECL   15:0
`define CR_KME_BLKID_REVID_T_BLKID_WIDTH  16
  `define CR_KME_BLKID_REVID_T_BLKID_DEFAULT  (16'h cf00)

`define CR_KME_FULL_BLKID_REVID_T_DECL   31:0
`define CR_KME_FULL_BLKID_REVID_T_WIDTH  32
  `define CR_KME_FULL_BLKID_REVID_T_REVID  15:00
  `define CR_KME_FULL_BLKID_REVID_T_BLKID  31:16

`define CR_KME_C_BLKID_REVID_T_DECL   31:0
`define CR_KME_C_BLKID_REVID_T_WIDTH  32
  `define CR_KME_C_BLKID_REVID_T_REVID  15:00
  `define CR_KME_C_BLKID_REVID_T_BLKID  31:16

`define CR_KME_REVID_T_DECL   31:0
`define CR_KME_REVID_T_WIDTH  32
  `define CR_KME_REVID_T_DEFAULT  (32'h 0)

`define CR_KME_REVID_T_REVID_DECL   7:0
`define CR_KME_REVID_T_REVID_WIDTH  8
  `define CR_KME_REVID_T_REVID_DEFAULT  (8'h 0)

`define CR_KME_FULL_REVID_T_DECL   31:0
`define CR_KME_FULL_REVID_T_WIDTH  32
  `define CR_KME_FULL_REVID_T_REVID      7:0
  `define CR_KME_FULL_REVID_T_RESERVED0  31:8

`define CR_KME_C_REVID_T_DECL   7:0
`define CR_KME_C_REVID_T_WIDTH  8
  `define CR_KME_C_REVID_T_REVID  7:0

`define CR_KME_SPARE_T_DECL   31:0
`define CR_KME_SPARE_T_WIDTH  32
  `define CR_KME_SPARE_T_DEFAULT  (32'h 0)

`define CR_KME_SPARE_T_SPARE_DECL   31:0
`define CR_KME_SPARE_T_SPARE_WIDTH  32
  `define CR_KME_SPARE_T_SPARE_DEFAULT  (32'h 0)

`define CR_KME_FULL_SPARE_T_DECL   31:0
`define CR_KME_FULL_SPARE_T_WIDTH  32
  `define CR_KME_FULL_SPARE_T_SPARE  31:00

`define CR_KME_C_SPARE_T_DECL   31:0
`define CR_KME_C_SPARE_T_WIDTH  32
  `define CR_KME_C_SPARE_T_SPARE  31:00

`define CR_KME_CCEIP0_OUT_PART0_T_DECL   31:0
`define CR_KME_CCEIP0_OUT_PART0_T_WIDTH  32
  `define CR_KME_CCEIP0_OUT_PART0_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP0_OUT_PART0_T_UNUSED0_DECL   5:0
`define CR_KME_CCEIP0_OUT_PART0_T_UNUSED0_WIDTH  6
  `define CR_KME_CCEIP0_OUT_PART0_T_UNUSED0_DEFAULT  (6'h 0)

`define CR_KME_CCEIP0_OUT_PART0_T_TUSER_DECL   7:0
`define CR_KME_CCEIP0_OUT_PART0_T_TUSER_WIDTH  8

`define CR_KME_CCEIP0_OUT_PART0_T_TID_DECL   0:0
`define CR_KME_CCEIP0_OUT_PART0_T_TID_WIDTH  1

`define CR_KME_CCEIP0_OUT_PART0_T_UNUSED1_DECL   7:0
`define CR_KME_CCEIP0_OUT_PART0_T_UNUSED1_WIDTH  8

`define CR_KME_CCEIP0_OUT_PART0_T_BYTES_VLD_DECL   7:0
`define CR_KME_CCEIP0_OUT_PART0_T_BYTES_VLD_WIDTH  8

`define CR_KME_CCEIP0_OUT_PART0_T_EOB_DECL   0:0
`define CR_KME_CCEIP0_OUT_PART0_T_EOB_WIDTH  1

`define CR_KME_FULL_CCEIP0_OUT_PART0_T_DECL   31:0
`define CR_KME_FULL_CCEIP0_OUT_PART0_T_WIDTH  32
  `define CR_KME_FULL_CCEIP0_OUT_PART0_T_UNUSED0    05:00
  `define CR_KME_FULL_CCEIP0_OUT_PART0_T_TUSER      13:06
  `define CR_KME_FULL_CCEIP0_OUT_PART0_T_TID        14
  `define CR_KME_FULL_CCEIP0_OUT_PART0_T_UNUSED1    22:15
  `define CR_KME_FULL_CCEIP0_OUT_PART0_T_BYTES_VLD  30:23
  `define CR_KME_FULL_CCEIP0_OUT_PART0_T_EOB        31

`define CR_KME_C_CCEIP0_OUT_PART0_T_DECL   31:0
`define CR_KME_C_CCEIP0_OUT_PART0_T_WIDTH  32
  `define CR_KME_C_CCEIP0_OUT_PART0_T_UNUSED0    05:00
  `define CR_KME_C_CCEIP0_OUT_PART0_T_TUSER      13:06
  `define CR_KME_C_CCEIP0_OUT_PART0_T_TID        14
  `define CR_KME_C_CCEIP0_OUT_PART0_T_UNUSED1    22:15
  `define CR_KME_C_CCEIP0_OUT_PART0_T_BYTES_VLD  30:23
  `define CR_KME_C_CCEIP0_OUT_PART0_T_EOB        31

`define CR_KME_CCEIP0_OUT_PART1_T_DECL   31:0
`define CR_KME_CCEIP0_OUT_PART1_T_WIDTH  32
  `define CR_KME_CCEIP0_OUT_PART1_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP0_OUT_PART1_T_TDATA_LO_DECL   31:0
`define CR_KME_CCEIP0_OUT_PART1_T_TDATA_LO_WIDTH  32
  `define CR_KME_CCEIP0_OUT_PART1_T_TDATA_LO_DEFAULT  (32'h 0)

`define CR_KME_FULL_CCEIP0_OUT_PART1_T_DECL   31:0
`define CR_KME_FULL_CCEIP0_OUT_PART1_T_WIDTH  32
  `define CR_KME_FULL_CCEIP0_OUT_PART1_T_TDATA_LO  31:00

`define CR_KME_C_CCEIP0_OUT_PART1_T_DECL   31:0
`define CR_KME_C_CCEIP0_OUT_PART1_T_WIDTH  32
  `define CR_KME_C_CCEIP0_OUT_PART1_T_TDATA_LO  31:00

`define CR_KME_CCEIP0_OUT_PART2_T_DECL   31:0
`define CR_KME_CCEIP0_OUT_PART2_T_WIDTH  32
  `define CR_KME_CCEIP0_OUT_PART2_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP0_OUT_PART2_T_TDATA_HI_DECL   31:0
`define CR_KME_CCEIP0_OUT_PART2_T_TDATA_HI_WIDTH  32
  `define CR_KME_CCEIP0_OUT_PART2_T_TDATA_HI_DEFAULT  (32'h 0)

`define CR_KME_FULL_CCEIP0_OUT_PART2_T_DECL   31:0
`define CR_KME_FULL_CCEIP0_OUT_PART2_T_WIDTH  32
  `define CR_KME_FULL_CCEIP0_OUT_PART2_T_TDATA_HI  31:00

`define CR_KME_C_CCEIP0_OUT_PART2_T_DECL   31:0
`define CR_KME_C_CCEIP0_OUT_PART2_T_WIDTH  32
  `define CR_KME_C_CCEIP0_OUT_PART2_T_TDATA_HI  31:00

`define CR_KME_CCEIP0_OUT_IA_CONFIG_T_DECL   31:0
`define CR_KME_CCEIP0_OUT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_CCEIP0_OUT_IA_CONFIG_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP0_OUT_IA_CONFIG_T_ADDR_DECL   8:0
`define CR_KME_CCEIP0_OUT_IA_CONFIG_T_ADDR_WIDTH  9
  `define CR_KME_CCEIP0_OUT_IA_CONFIG_T_ADDR_DEFAULT  (9'h 0)

`define CR_KME_CCEIP0_OUT_IA_CONFIG_T_OP_DECL   3:0
`define CR_KME_CCEIP0_OUT_IA_CONFIG_T_OP_WIDTH  4
  `define CR_KME_CCEIP0_OUT_IA_CONFIG_T_OP_DEFAULT  (4'h 0)

`define CR_KME_FULL_CCEIP0_OUT_IA_CONFIG_T_DECL   31:0
`define CR_KME_FULL_CCEIP0_OUT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_CCEIP0_OUT_IA_CONFIG_T_ADDR       08:00
  `define CR_KME_FULL_CCEIP0_OUT_IA_CONFIG_T_RESERVED0  27:09
  `define CR_KME_FULL_CCEIP0_OUT_IA_CONFIG_T_OP         31:28

`define CR_KME_C_CCEIP0_OUT_IA_CONFIG_T_DECL   12:0
`define CR_KME_C_CCEIP0_OUT_IA_CONFIG_T_WIDTH  13
  `define CR_KME_C_CCEIP0_OUT_IA_CONFIG_T_ADDR  08:00
  `define CR_KME_C_CCEIP0_OUT_IA_CONFIG_T_OP    12:09

`define CR_KME_CCEIP0_OUT_IA_STATUS_T_DECL   31:0
`define CR_KME_CCEIP0_OUT_IA_STATUS_T_WIDTH  32
  `define CR_KME_CCEIP0_OUT_IA_STATUS_T_DEFAULT  (32'h 20001ff)

`define CR_KME_CCEIP0_OUT_IA_STATUS_T_ADDR_DECL   8:0
`define CR_KME_CCEIP0_OUT_IA_STATUS_T_ADDR_WIDTH  9
  `define CR_KME_CCEIP0_OUT_IA_STATUS_T_ADDR_DEFAULT  (9'h 1ff)

`define CR_KME_CCEIP0_OUT_IA_STATUS_T_DATAWORDS_DECL   4:0
`define CR_KME_CCEIP0_OUT_IA_STATUS_T_DATAWORDS_WIDTH  5
  `define CR_KME_CCEIP0_OUT_IA_STATUS_T_DATAWORDS_DEFAULT  (5'h 2)

`define CR_KME_CCEIP0_OUT_IA_STATUS_T_CODE_DECL   2:0
`define CR_KME_CCEIP0_OUT_IA_STATUS_T_CODE_WIDTH  3
  `define CR_KME_CCEIP0_OUT_IA_STATUS_T_CODE_DEFAULT  (3'h 0)

`define CR_KME_FULL_CCEIP0_OUT_IA_STATUS_T_DECL   31:0
`define CR_KME_FULL_CCEIP0_OUT_IA_STATUS_T_WIDTH  32
  `define CR_KME_FULL_CCEIP0_OUT_IA_STATUS_T_ADDR       08:00
  `define CR_KME_FULL_CCEIP0_OUT_IA_STATUS_T_RESERVED0  23:09
  `define CR_KME_FULL_CCEIP0_OUT_IA_STATUS_T_DATAWORDS  28:24
  `define CR_KME_FULL_CCEIP0_OUT_IA_STATUS_T_CODE       31:29

`define CR_KME_C_CCEIP0_OUT_IA_STATUS_T_DECL   16:0
`define CR_KME_C_CCEIP0_OUT_IA_STATUS_T_WIDTH  17
  `define CR_KME_C_CCEIP0_OUT_IA_STATUS_T_ADDR       08:00
  `define CR_KME_C_CCEIP0_OUT_IA_STATUS_T_DATAWORDS  13:09
  `define CR_KME_C_CCEIP0_OUT_IA_STATUS_T_CODE       16:14

`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_DEFAULT  (32'b xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)

`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_NOP_DECL   0:0
`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_NOP_WIDTH  1

`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_READ_DECL   0:0
`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_READ_WIDTH  1

`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_WRITE_DECL   0:0
`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_WRITE_WIDTH  1

`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_ENABLE_DECL   0:0
`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_ENABLE_WIDTH  1

`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_DISABLED_DECL   0:0
`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_DISABLED_WIDTH  1

`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_RESET_DECL   0:0
`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_RESET_WIDTH  1

`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_INITIALIZE_DECL   0:0
`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_INITIALIZE_WIDTH  1

`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_INITIALIZE_INC_DECL   0:0
`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_INITIALIZE_INC_WIDTH  1

`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_SET_INIT_START_DECL   0:0
`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_SET_INIT_START_WIDTH  1

`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_COMPARE_DECL   0:0
`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_COMPARE_WIDTH  1

`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_RESERVED_OP_DECL   3:0
`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_RESERVED_OP_WIDTH  4

`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_SIM_TMO_DECL   0:0
`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_SIM_TMO_WIDTH  1

`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_ACK_ERROR_DECL   0:0
`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_ACK_ERROR_WIDTH  1

`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_MEM_TYPE_DECL   3:0
`define CR_KME_CCEIP0_OUT_IA_CAPABILITY_T_MEM_TYPE_WIDTH  4

`define CR_KME_FULL_CCEIP0_OUT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_FULL_CCEIP0_OUT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_FULL_CCEIP0_OUT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_FULL_CCEIP0_OUT_IA_CAPABILITY_T_READ            01
  `define CR_KME_FULL_CCEIP0_OUT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_FULL_CCEIP0_OUT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_FULL_CCEIP0_OUT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_FULL_CCEIP0_OUT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_FULL_CCEIP0_OUT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_FULL_CCEIP0_OUT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_FULL_CCEIP0_OUT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_FULL_CCEIP0_OUT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_FULL_CCEIP0_OUT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_FULL_CCEIP0_OUT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_FULL_CCEIP0_OUT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_FULL_CCEIP0_OUT_IA_CAPABILITY_T_RESERVED0       27:16
  `define CR_KME_FULL_CCEIP0_OUT_IA_CAPABILITY_T_MEM_TYPE        31:28

`define CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_DECL   19:0
`define CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_WIDTH  20
  `define CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_READ            01
  `define CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_C_CCEIP0_OUT_IA_CAPABILITY_T_MEM_TYPE        19:16

`define CR_KME_CCEIP0_OUT_IM_CONFIG_T_DECL   31:0
`define CR_KME_CCEIP0_OUT_IM_CONFIG_T_WIDTH  32
  `define CR_KME_CCEIP0_OUT_IM_CONFIG_T_DEFAULT  (32'h c0000200)

`define CR_KME_CCEIP0_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_DECL   9:0
`define CR_KME_CCEIP0_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_WIDTH  10
  `define CR_KME_CCEIP0_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_DEFAULT  (10'h 200)

`define CR_KME_CCEIP0_OUT_IM_CONFIG_T_MODE_DECL   1:0
`define CR_KME_CCEIP0_OUT_IM_CONFIG_T_MODE_WIDTH  2
  `define CR_KME_CCEIP0_OUT_IM_CONFIG_T_MODE_DEFAULT  (2'h 3)

`define CR_KME_FULL_CCEIP0_OUT_IM_CONFIG_T_DECL   31:0
`define CR_KME_FULL_CCEIP0_OUT_IM_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_CCEIP0_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG  09:00
  `define CR_KME_FULL_CCEIP0_OUT_IM_CONFIG_T_RESERVED0         29:10
  `define CR_KME_FULL_CCEIP0_OUT_IM_CONFIG_T_MODE              31:30

`define CR_KME_C_CCEIP0_OUT_IM_CONFIG_T_DECL   11:0
`define CR_KME_C_CCEIP0_OUT_IM_CONFIG_T_WIDTH  12
  `define CR_KME_C_CCEIP0_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG  09:00
  `define CR_KME_C_CCEIP0_OUT_IM_CONFIG_T_MODE              11:10

`define CR_KME_CCEIP0_OUT_IM_STATUS_T_DECL   31:0
`define CR_KME_CCEIP0_OUT_IM_STATUS_T_WIDTH  32
  `define CR_KME_CCEIP0_OUT_IM_STATUS_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP0_OUT_IM_STATUS_T_WR_POINTER_DECL   8:0
`define CR_KME_CCEIP0_OUT_IM_STATUS_T_WR_POINTER_WIDTH  9
  `define CR_KME_CCEIP0_OUT_IM_STATUS_T_WR_POINTER_DEFAULT  (9'h 0)

`define CR_KME_CCEIP0_OUT_IM_STATUS_T_OVERFLOW_DECL   0:0
`define CR_KME_CCEIP0_OUT_IM_STATUS_T_OVERFLOW_WIDTH  1
  `define CR_KME_CCEIP0_OUT_IM_STATUS_T_OVERFLOW_DEFAULT  (1'h 0)

`define CR_KME_CCEIP0_OUT_IM_STATUS_T_BANK_LO_DECL   0:0
`define CR_KME_CCEIP0_OUT_IM_STATUS_T_BANK_LO_WIDTH  1
  `define CR_KME_CCEIP0_OUT_IM_STATUS_T_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_CCEIP0_OUT_IM_STATUS_T_BANK_HI_DECL   0:0
`define CR_KME_CCEIP0_OUT_IM_STATUS_T_BANK_HI_WIDTH  1
  `define CR_KME_CCEIP0_OUT_IM_STATUS_T_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_CCEIP0_OUT_IM_STATUS_T_DECL   31:0
`define CR_KME_FULL_CCEIP0_OUT_IM_STATUS_T_WIDTH  32
  `define CR_KME_FULL_CCEIP0_OUT_IM_STATUS_T_WR_POINTER  08:00
  `define CR_KME_FULL_CCEIP0_OUT_IM_STATUS_T_RESERVED0   28:09
  `define CR_KME_FULL_CCEIP0_OUT_IM_STATUS_T_OVERFLOW    29
  `define CR_KME_FULL_CCEIP0_OUT_IM_STATUS_T_BANK_LO     30
  `define CR_KME_FULL_CCEIP0_OUT_IM_STATUS_T_BANK_HI     31

`define CR_KME_C_CCEIP0_OUT_IM_STATUS_T_DECL   11:0
`define CR_KME_C_CCEIP0_OUT_IM_STATUS_T_WIDTH  12
  `define CR_KME_C_CCEIP0_OUT_IM_STATUS_T_WR_POINTER  08:00
  `define CR_KME_C_CCEIP0_OUT_IM_STATUS_T_OVERFLOW    09
  `define CR_KME_C_CCEIP0_OUT_IM_STATUS_T_BANK_LO     10
  `define CR_KME_C_CCEIP0_OUT_IM_STATUS_T_BANK_HI     11

`define CR_KME_CCEIP0_OUT_IM_CONSUMED_T_DECL   31:0
`define CR_KME_CCEIP0_OUT_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_CCEIP0_OUT_IM_CONSUMED_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP0_OUT_IM_CONSUMED_T_BANK_LO_DECL   0:0
`define CR_KME_CCEIP0_OUT_IM_CONSUMED_T_BANK_LO_WIDTH  1
  `define CR_KME_CCEIP0_OUT_IM_CONSUMED_T_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_CCEIP0_OUT_IM_CONSUMED_T_BANK_HI_DECL   0:0
`define CR_KME_CCEIP0_OUT_IM_CONSUMED_T_BANK_HI_WIDTH  1
  `define CR_KME_CCEIP0_OUT_IM_CONSUMED_T_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_CCEIP0_OUT_IM_CONSUMED_T_DECL   31:0
`define CR_KME_FULL_CCEIP0_OUT_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_FULL_CCEIP0_OUT_IM_CONSUMED_T_RESERVED0  29:0
  `define CR_KME_FULL_CCEIP0_OUT_IM_CONSUMED_T_BANK_LO    30
  `define CR_KME_FULL_CCEIP0_OUT_IM_CONSUMED_T_BANK_HI    31

`define CR_KME_C_CCEIP0_OUT_IM_CONSUMED_T_DECL   1:0
`define CR_KME_C_CCEIP0_OUT_IM_CONSUMED_T_WIDTH  2
  `define CR_KME_C_CCEIP0_OUT_IM_CONSUMED_T_BANK_LO  0
  `define CR_KME_C_CCEIP0_OUT_IM_CONSUMED_T_BANK_HI  1

`define CR_KME_CCEIP1_OUT_PART0_T_DECL   31:0
`define CR_KME_CCEIP1_OUT_PART0_T_WIDTH  32
  `define CR_KME_CCEIP1_OUT_PART0_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP1_OUT_PART0_T_UNUSED0_DECL   5:0
`define CR_KME_CCEIP1_OUT_PART0_T_UNUSED0_WIDTH  6
  `define CR_KME_CCEIP1_OUT_PART0_T_UNUSED0_DEFAULT  (6'h 0)

`define CR_KME_CCEIP1_OUT_PART0_T_TUSER_DECL   7:0
`define CR_KME_CCEIP1_OUT_PART0_T_TUSER_WIDTH  8

`define CR_KME_CCEIP1_OUT_PART0_T_TID_DECL   0:0
`define CR_KME_CCEIP1_OUT_PART0_T_TID_WIDTH  1

`define CR_KME_CCEIP1_OUT_PART0_T_UNUSED1_DECL   7:0
`define CR_KME_CCEIP1_OUT_PART0_T_UNUSED1_WIDTH  8

`define CR_KME_CCEIP1_OUT_PART0_T_BYTES_VLD_DECL   7:0
`define CR_KME_CCEIP1_OUT_PART0_T_BYTES_VLD_WIDTH  8

`define CR_KME_CCEIP1_OUT_PART0_T_EOB_DECL   0:0
`define CR_KME_CCEIP1_OUT_PART0_T_EOB_WIDTH  1

`define CR_KME_FULL_CCEIP1_OUT_PART0_T_DECL   31:0
`define CR_KME_FULL_CCEIP1_OUT_PART0_T_WIDTH  32
  `define CR_KME_FULL_CCEIP1_OUT_PART0_T_UNUSED0    05:00
  `define CR_KME_FULL_CCEIP1_OUT_PART0_T_TUSER      13:06
  `define CR_KME_FULL_CCEIP1_OUT_PART0_T_TID        14
  `define CR_KME_FULL_CCEIP1_OUT_PART0_T_UNUSED1    22:15
  `define CR_KME_FULL_CCEIP1_OUT_PART0_T_BYTES_VLD  30:23
  `define CR_KME_FULL_CCEIP1_OUT_PART0_T_EOB        31

`define CR_KME_C_CCEIP1_OUT_PART0_T_DECL   31:0
`define CR_KME_C_CCEIP1_OUT_PART0_T_WIDTH  32
  `define CR_KME_C_CCEIP1_OUT_PART0_T_UNUSED0    05:00
  `define CR_KME_C_CCEIP1_OUT_PART0_T_TUSER      13:06
  `define CR_KME_C_CCEIP1_OUT_PART0_T_TID        14
  `define CR_KME_C_CCEIP1_OUT_PART0_T_UNUSED1    22:15
  `define CR_KME_C_CCEIP1_OUT_PART0_T_BYTES_VLD  30:23
  `define CR_KME_C_CCEIP1_OUT_PART0_T_EOB        31

`define CR_KME_CCEIP1_OUT_PART1_T_DECL   31:0
`define CR_KME_CCEIP1_OUT_PART1_T_WIDTH  32
  `define CR_KME_CCEIP1_OUT_PART1_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP1_OUT_PART1_T_TDATA_LO_DECL   31:0
`define CR_KME_CCEIP1_OUT_PART1_T_TDATA_LO_WIDTH  32
  `define CR_KME_CCEIP1_OUT_PART1_T_TDATA_LO_DEFAULT  (32'h 0)

`define CR_KME_FULL_CCEIP1_OUT_PART1_T_DECL   31:0
`define CR_KME_FULL_CCEIP1_OUT_PART1_T_WIDTH  32
  `define CR_KME_FULL_CCEIP1_OUT_PART1_T_TDATA_LO  31:00

`define CR_KME_C_CCEIP1_OUT_PART1_T_DECL   31:0
`define CR_KME_C_CCEIP1_OUT_PART1_T_WIDTH  32
  `define CR_KME_C_CCEIP1_OUT_PART1_T_TDATA_LO  31:00

`define CR_KME_CCEIP1_OUT_PART2_T_DECL   31:0
`define CR_KME_CCEIP1_OUT_PART2_T_WIDTH  32
  `define CR_KME_CCEIP1_OUT_PART2_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP1_OUT_PART2_T_TDATA_HI_DECL   31:0
`define CR_KME_CCEIP1_OUT_PART2_T_TDATA_HI_WIDTH  32
  `define CR_KME_CCEIP1_OUT_PART2_T_TDATA_HI_DEFAULT  (32'h 0)

`define CR_KME_FULL_CCEIP1_OUT_PART2_T_DECL   31:0
`define CR_KME_FULL_CCEIP1_OUT_PART2_T_WIDTH  32
  `define CR_KME_FULL_CCEIP1_OUT_PART2_T_TDATA_HI  31:00

`define CR_KME_C_CCEIP1_OUT_PART2_T_DECL   31:0
`define CR_KME_C_CCEIP1_OUT_PART2_T_WIDTH  32
  `define CR_KME_C_CCEIP1_OUT_PART2_T_TDATA_HI  31:00

`define CR_KME_CCEIP1_OUT_IA_CONFIG_T_DECL   31:0
`define CR_KME_CCEIP1_OUT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_CCEIP1_OUT_IA_CONFIG_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP1_OUT_IA_CONFIG_T_ADDR_DECL   8:0
`define CR_KME_CCEIP1_OUT_IA_CONFIG_T_ADDR_WIDTH  9
  `define CR_KME_CCEIP1_OUT_IA_CONFIG_T_ADDR_DEFAULT  (9'h 0)

`define CR_KME_CCEIP1_OUT_IA_CONFIG_T_OP_DECL   3:0
`define CR_KME_CCEIP1_OUT_IA_CONFIG_T_OP_WIDTH  4
  `define CR_KME_CCEIP1_OUT_IA_CONFIG_T_OP_DEFAULT  (4'h 0)

`define CR_KME_FULL_CCEIP1_OUT_IA_CONFIG_T_DECL   31:0
`define CR_KME_FULL_CCEIP1_OUT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_CCEIP1_OUT_IA_CONFIG_T_ADDR       08:00
  `define CR_KME_FULL_CCEIP1_OUT_IA_CONFIG_T_RESERVED0  27:09
  `define CR_KME_FULL_CCEIP1_OUT_IA_CONFIG_T_OP         31:28

`define CR_KME_C_CCEIP1_OUT_IA_CONFIG_T_DECL   12:0
`define CR_KME_C_CCEIP1_OUT_IA_CONFIG_T_WIDTH  13
  `define CR_KME_C_CCEIP1_OUT_IA_CONFIG_T_ADDR  08:00
  `define CR_KME_C_CCEIP1_OUT_IA_CONFIG_T_OP    12:09

`define CR_KME_CCEIP1_OUT_IA_STATUS_T_DECL   31:0
`define CR_KME_CCEIP1_OUT_IA_STATUS_T_WIDTH  32
  `define CR_KME_CCEIP1_OUT_IA_STATUS_T_DEFAULT  (32'h 20001ff)

`define CR_KME_CCEIP1_OUT_IA_STATUS_T_ADDR_DECL   8:0
`define CR_KME_CCEIP1_OUT_IA_STATUS_T_ADDR_WIDTH  9
  `define CR_KME_CCEIP1_OUT_IA_STATUS_T_ADDR_DEFAULT  (9'h 1ff)

`define CR_KME_CCEIP1_OUT_IA_STATUS_T_DATAWORDS_DECL   4:0
`define CR_KME_CCEIP1_OUT_IA_STATUS_T_DATAWORDS_WIDTH  5
  `define CR_KME_CCEIP1_OUT_IA_STATUS_T_DATAWORDS_DEFAULT  (5'h 2)

`define CR_KME_CCEIP1_OUT_IA_STATUS_T_CODE_DECL   2:0
`define CR_KME_CCEIP1_OUT_IA_STATUS_T_CODE_WIDTH  3
  `define CR_KME_CCEIP1_OUT_IA_STATUS_T_CODE_DEFAULT  (3'h 0)

`define CR_KME_FULL_CCEIP1_OUT_IA_STATUS_T_DECL   31:0
`define CR_KME_FULL_CCEIP1_OUT_IA_STATUS_T_WIDTH  32
  `define CR_KME_FULL_CCEIP1_OUT_IA_STATUS_T_ADDR       08:00
  `define CR_KME_FULL_CCEIP1_OUT_IA_STATUS_T_RESERVED0  23:09
  `define CR_KME_FULL_CCEIP1_OUT_IA_STATUS_T_DATAWORDS  28:24
  `define CR_KME_FULL_CCEIP1_OUT_IA_STATUS_T_CODE       31:29

`define CR_KME_C_CCEIP1_OUT_IA_STATUS_T_DECL   16:0
`define CR_KME_C_CCEIP1_OUT_IA_STATUS_T_WIDTH  17
  `define CR_KME_C_CCEIP1_OUT_IA_STATUS_T_ADDR       08:00
  `define CR_KME_C_CCEIP1_OUT_IA_STATUS_T_DATAWORDS  13:09
  `define CR_KME_C_CCEIP1_OUT_IA_STATUS_T_CODE       16:14

`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_DEFAULT  (32'b xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)

`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_NOP_DECL   0:0
`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_NOP_WIDTH  1

`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_READ_DECL   0:0
`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_READ_WIDTH  1

`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_WRITE_DECL   0:0
`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_WRITE_WIDTH  1

`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_ENABLE_DECL   0:0
`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_ENABLE_WIDTH  1

`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_DISABLED_DECL   0:0
`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_DISABLED_WIDTH  1

`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_RESET_DECL   0:0
`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_RESET_WIDTH  1

`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_INITIALIZE_DECL   0:0
`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_INITIALIZE_WIDTH  1

`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_INITIALIZE_INC_DECL   0:0
`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_INITIALIZE_INC_WIDTH  1

`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_SET_INIT_START_DECL   0:0
`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_SET_INIT_START_WIDTH  1

`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_COMPARE_DECL   0:0
`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_COMPARE_WIDTH  1

`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_RESERVED_OP_DECL   3:0
`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_RESERVED_OP_WIDTH  4

`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_SIM_TMO_DECL   0:0
`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_SIM_TMO_WIDTH  1

`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_ACK_ERROR_DECL   0:0
`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_ACK_ERROR_WIDTH  1

`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_MEM_TYPE_DECL   3:0
`define CR_KME_CCEIP1_OUT_IA_CAPABILITY_T_MEM_TYPE_WIDTH  4

`define CR_KME_FULL_CCEIP1_OUT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_FULL_CCEIP1_OUT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_FULL_CCEIP1_OUT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_FULL_CCEIP1_OUT_IA_CAPABILITY_T_READ            01
  `define CR_KME_FULL_CCEIP1_OUT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_FULL_CCEIP1_OUT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_FULL_CCEIP1_OUT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_FULL_CCEIP1_OUT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_FULL_CCEIP1_OUT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_FULL_CCEIP1_OUT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_FULL_CCEIP1_OUT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_FULL_CCEIP1_OUT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_FULL_CCEIP1_OUT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_FULL_CCEIP1_OUT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_FULL_CCEIP1_OUT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_FULL_CCEIP1_OUT_IA_CAPABILITY_T_RESERVED0       27:16
  `define CR_KME_FULL_CCEIP1_OUT_IA_CAPABILITY_T_MEM_TYPE        31:28

`define CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_DECL   19:0
`define CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_WIDTH  20
  `define CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_READ            01
  `define CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_C_CCEIP1_OUT_IA_CAPABILITY_T_MEM_TYPE        19:16

`define CR_KME_CCEIP1_OUT_IM_CONFIG_T_DECL   31:0
`define CR_KME_CCEIP1_OUT_IM_CONFIG_T_WIDTH  32
  `define CR_KME_CCEIP1_OUT_IM_CONFIG_T_DEFAULT  (32'h c0000200)

`define CR_KME_CCEIP1_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_DECL   9:0
`define CR_KME_CCEIP1_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_WIDTH  10
  `define CR_KME_CCEIP1_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_DEFAULT  (10'h 200)

`define CR_KME_CCEIP1_OUT_IM_CONFIG_T_MODE_DECL   1:0
`define CR_KME_CCEIP1_OUT_IM_CONFIG_T_MODE_WIDTH  2
  `define CR_KME_CCEIP1_OUT_IM_CONFIG_T_MODE_DEFAULT  (2'h 3)

`define CR_KME_FULL_CCEIP1_OUT_IM_CONFIG_T_DECL   31:0
`define CR_KME_FULL_CCEIP1_OUT_IM_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_CCEIP1_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG  09:00
  `define CR_KME_FULL_CCEIP1_OUT_IM_CONFIG_T_RESERVED0         29:10
  `define CR_KME_FULL_CCEIP1_OUT_IM_CONFIG_T_MODE              31:30

`define CR_KME_C_CCEIP1_OUT_IM_CONFIG_T_DECL   11:0
`define CR_KME_C_CCEIP1_OUT_IM_CONFIG_T_WIDTH  12
  `define CR_KME_C_CCEIP1_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG  09:00
  `define CR_KME_C_CCEIP1_OUT_IM_CONFIG_T_MODE              11:10

`define CR_KME_CCEIP1_OUT_IM_STATUS_T_DECL   31:0
`define CR_KME_CCEIP1_OUT_IM_STATUS_T_WIDTH  32
  `define CR_KME_CCEIP1_OUT_IM_STATUS_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP1_OUT_IM_STATUS_T_WR_POINTER_DECL   8:0
`define CR_KME_CCEIP1_OUT_IM_STATUS_T_WR_POINTER_WIDTH  9
  `define CR_KME_CCEIP1_OUT_IM_STATUS_T_WR_POINTER_DEFAULT  (9'h 0)

`define CR_KME_CCEIP1_OUT_IM_STATUS_T_OVERFLOW_DECL   0:0
`define CR_KME_CCEIP1_OUT_IM_STATUS_T_OVERFLOW_WIDTH  1
  `define CR_KME_CCEIP1_OUT_IM_STATUS_T_OVERFLOW_DEFAULT  (1'h 0)

`define CR_KME_CCEIP1_OUT_IM_STATUS_T_BANK_LO_DECL   0:0
`define CR_KME_CCEIP1_OUT_IM_STATUS_T_BANK_LO_WIDTH  1
  `define CR_KME_CCEIP1_OUT_IM_STATUS_T_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_CCEIP1_OUT_IM_STATUS_T_BANK_HI_DECL   0:0
`define CR_KME_CCEIP1_OUT_IM_STATUS_T_BANK_HI_WIDTH  1
  `define CR_KME_CCEIP1_OUT_IM_STATUS_T_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_CCEIP1_OUT_IM_STATUS_T_DECL   31:0
`define CR_KME_FULL_CCEIP1_OUT_IM_STATUS_T_WIDTH  32
  `define CR_KME_FULL_CCEIP1_OUT_IM_STATUS_T_WR_POINTER  08:00
  `define CR_KME_FULL_CCEIP1_OUT_IM_STATUS_T_RESERVED0   28:09
  `define CR_KME_FULL_CCEIP1_OUT_IM_STATUS_T_OVERFLOW    29
  `define CR_KME_FULL_CCEIP1_OUT_IM_STATUS_T_BANK_LO     30
  `define CR_KME_FULL_CCEIP1_OUT_IM_STATUS_T_BANK_HI     31

`define CR_KME_C_CCEIP1_OUT_IM_STATUS_T_DECL   11:0
`define CR_KME_C_CCEIP1_OUT_IM_STATUS_T_WIDTH  12
  `define CR_KME_C_CCEIP1_OUT_IM_STATUS_T_WR_POINTER  08:00
  `define CR_KME_C_CCEIP1_OUT_IM_STATUS_T_OVERFLOW    09
  `define CR_KME_C_CCEIP1_OUT_IM_STATUS_T_BANK_LO     10
  `define CR_KME_C_CCEIP1_OUT_IM_STATUS_T_BANK_HI     11

`define CR_KME_CCEIP1_OUT_IM_CONSUMED_T_DECL   31:0
`define CR_KME_CCEIP1_OUT_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_CCEIP1_OUT_IM_CONSUMED_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP1_OUT_IM_CONSUMED_T_BANK_LO_DECL   0:0
`define CR_KME_CCEIP1_OUT_IM_CONSUMED_T_BANK_LO_WIDTH  1
  `define CR_KME_CCEIP1_OUT_IM_CONSUMED_T_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_CCEIP1_OUT_IM_CONSUMED_T_BANK_HI_DECL   0:0
`define CR_KME_CCEIP1_OUT_IM_CONSUMED_T_BANK_HI_WIDTH  1
  `define CR_KME_CCEIP1_OUT_IM_CONSUMED_T_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_CCEIP1_OUT_IM_CONSUMED_T_DECL   31:0
`define CR_KME_FULL_CCEIP1_OUT_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_FULL_CCEIP1_OUT_IM_CONSUMED_T_RESERVED0  29:0
  `define CR_KME_FULL_CCEIP1_OUT_IM_CONSUMED_T_BANK_LO    30
  `define CR_KME_FULL_CCEIP1_OUT_IM_CONSUMED_T_BANK_HI    31

`define CR_KME_C_CCEIP1_OUT_IM_CONSUMED_T_DECL   1:0
`define CR_KME_C_CCEIP1_OUT_IM_CONSUMED_T_WIDTH  2
  `define CR_KME_C_CCEIP1_OUT_IM_CONSUMED_T_BANK_LO  0
  `define CR_KME_C_CCEIP1_OUT_IM_CONSUMED_T_BANK_HI  1

`define CR_KME_CCEIP2_OUT_PART0_T_DECL   31:0
`define CR_KME_CCEIP2_OUT_PART0_T_WIDTH  32
  `define CR_KME_CCEIP2_OUT_PART0_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP2_OUT_PART0_T_UNUSED0_DECL   5:0
`define CR_KME_CCEIP2_OUT_PART0_T_UNUSED0_WIDTH  6
  `define CR_KME_CCEIP2_OUT_PART0_T_UNUSED0_DEFAULT  (6'h 0)

`define CR_KME_CCEIP2_OUT_PART0_T_TUSER_DECL   7:0
`define CR_KME_CCEIP2_OUT_PART0_T_TUSER_WIDTH  8

`define CR_KME_CCEIP2_OUT_PART0_T_TID_DECL   0:0
`define CR_KME_CCEIP2_OUT_PART0_T_TID_WIDTH  1

`define CR_KME_CCEIP2_OUT_PART0_T_UNUSED1_DECL   7:0
`define CR_KME_CCEIP2_OUT_PART0_T_UNUSED1_WIDTH  8

`define CR_KME_CCEIP2_OUT_PART0_T_BYTES_VLD_DECL   7:0
`define CR_KME_CCEIP2_OUT_PART0_T_BYTES_VLD_WIDTH  8

`define CR_KME_CCEIP2_OUT_PART0_T_EOB_DECL   0:0
`define CR_KME_CCEIP2_OUT_PART0_T_EOB_WIDTH  1

`define CR_KME_FULL_CCEIP2_OUT_PART0_T_DECL   31:0
`define CR_KME_FULL_CCEIP2_OUT_PART0_T_WIDTH  32
  `define CR_KME_FULL_CCEIP2_OUT_PART0_T_UNUSED0    05:00
  `define CR_KME_FULL_CCEIP2_OUT_PART0_T_TUSER      13:06
  `define CR_KME_FULL_CCEIP2_OUT_PART0_T_TID        14
  `define CR_KME_FULL_CCEIP2_OUT_PART0_T_UNUSED1    22:15
  `define CR_KME_FULL_CCEIP2_OUT_PART0_T_BYTES_VLD  30:23
  `define CR_KME_FULL_CCEIP2_OUT_PART0_T_EOB        31

`define CR_KME_C_CCEIP2_OUT_PART0_T_DECL   31:0
`define CR_KME_C_CCEIP2_OUT_PART0_T_WIDTH  32
  `define CR_KME_C_CCEIP2_OUT_PART0_T_UNUSED0    05:00
  `define CR_KME_C_CCEIP2_OUT_PART0_T_TUSER      13:06
  `define CR_KME_C_CCEIP2_OUT_PART0_T_TID        14
  `define CR_KME_C_CCEIP2_OUT_PART0_T_UNUSED1    22:15
  `define CR_KME_C_CCEIP2_OUT_PART0_T_BYTES_VLD  30:23
  `define CR_KME_C_CCEIP2_OUT_PART0_T_EOB        31

`define CR_KME_CCEIP2_OUT_PART1_T_DECL   31:0
`define CR_KME_CCEIP2_OUT_PART1_T_WIDTH  32
  `define CR_KME_CCEIP2_OUT_PART1_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP2_OUT_PART1_T_TDATA_LO_DECL   31:0
`define CR_KME_CCEIP2_OUT_PART1_T_TDATA_LO_WIDTH  32
  `define CR_KME_CCEIP2_OUT_PART1_T_TDATA_LO_DEFAULT  (32'h 0)

`define CR_KME_FULL_CCEIP2_OUT_PART1_T_DECL   31:0
`define CR_KME_FULL_CCEIP2_OUT_PART1_T_WIDTH  32
  `define CR_KME_FULL_CCEIP2_OUT_PART1_T_TDATA_LO  31:00

`define CR_KME_C_CCEIP2_OUT_PART1_T_DECL   31:0
`define CR_KME_C_CCEIP2_OUT_PART1_T_WIDTH  32
  `define CR_KME_C_CCEIP2_OUT_PART1_T_TDATA_LO  31:00

`define CR_KME_CCEIP2_OUT_PART2_T_DECL   31:0
`define CR_KME_CCEIP2_OUT_PART2_T_WIDTH  32
  `define CR_KME_CCEIP2_OUT_PART2_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP2_OUT_PART2_T_TDATA_HI_DECL   31:0
`define CR_KME_CCEIP2_OUT_PART2_T_TDATA_HI_WIDTH  32
  `define CR_KME_CCEIP2_OUT_PART2_T_TDATA_HI_DEFAULT  (32'h 0)

`define CR_KME_FULL_CCEIP2_OUT_PART2_T_DECL   31:0
`define CR_KME_FULL_CCEIP2_OUT_PART2_T_WIDTH  32
  `define CR_KME_FULL_CCEIP2_OUT_PART2_T_TDATA_HI  31:00

`define CR_KME_C_CCEIP2_OUT_PART2_T_DECL   31:0
`define CR_KME_C_CCEIP2_OUT_PART2_T_WIDTH  32
  `define CR_KME_C_CCEIP2_OUT_PART2_T_TDATA_HI  31:00

`define CR_KME_CCEIP2_OUT_IA_CONFIG_T_DECL   31:0
`define CR_KME_CCEIP2_OUT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_CCEIP2_OUT_IA_CONFIG_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP2_OUT_IA_CONFIG_T_ADDR_DECL   8:0
`define CR_KME_CCEIP2_OUT_IA_CONFIG_T_ADDR_WIDTH  9
  `define CR_KME_CCEIP2_OUT_IA_CONFIG_T_ADDR_DEFAULT  (9'h 0)

`define CR_KME_CCEIP2_OUT_IA_CONFIG_T_OP_DECL   3:0
`define CR_KME_CCEIP2_OUT_IA_CONFIG_T_OP_WIDTH  4
  `define CR_KME_CCEIP2_OUT_IA_CONFIG_T_OP_DEFAULT  (4'h 0)

`define CR_KME_FULL_CCEIP2_OUT_IA_CONFIG_T_DECL   31:0
`define CR_KME_FULL_CCEIP2_OUT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_CCEIP2_OUT_IA_CONFIG_T_ADDR       08:00
  `define CR_KME_FULL_CCEIP2_OUT_IA_CONFIG_T_RESERVED0  27:09
  `define CR_KME_FULL_CCEIP2_OUT_IA_CONFIG_T_OP         31:28

`define CR_KME_C_CCEIP2_OUT_IA_CONFIG_T_DECL   12:0
`define CR_KME_C_CCEIP2_OUT_IA_CONFIG_T_WIDTH  13
  `define CR_KME_C_CCEIP2_OUT_IA_CONFIG_T_ADDR  08:00
  `define CR_KME_C_CCEIP2_OUT_IA_CONFIG_T_OP    12:09

`define CR_KME_CCEIP2_OUT_IA_STATUS_T_DECL   31:0
`define CR_KME_CCEIP2_OUT_IA_STATUS_T_WIDTH  32
  `define CR_KME_CCEIP2_OUT_IA_STATUS_T_DEFAULT  (32'h 20001ff)

`define CR_KME_CCEIP2_OUT_IA_STATUS_T_ADDR_DECL   8:0
`define CR_KME_CCEIP2_OUT_IA_STATUS_T_ADDR_WIDTH  9
  `define CR_KME_CCEIP2_OUT_IA_STATUS_T_ADDR_DEFAULT  (9'h 1ff)

`define CR_KME_CCEIP2_OUT_IA_STATUS_T_DATAWORDS_DECL   4:0
`define CR_KME_CCEIP2_OUT_IA_STATUS_T_DATAWORDS_WIDTH  5
  `define CR_KME_CCEIP2_OUT_IA_STATUS_T_DATAWORDS_DEFAULT  (5'h 2)

`define CR_KME_CCEIP2_OUT_IA_STATUS_T_CODE_DECL   2:0
`define CR_KME_CCEIP2_OUT_IA_STATUS_T_CODE_WIDTH  3
  `define CR_KME_CCEIP2_OUT_IA_STATUS_T_CODE_DEFAULT  (3'h 0)

`define CR_KME_FULL_CCEIP2_OUT_IA_STATUS_T_DECL   31:0
`define CR_KME_FULL_CCEIP2_OUT_IA_STATUS_T_WIDTH  32
  `define CR_KME_FULL_CCEIP2_OUT_IA_STATUS_T_ADDR       08:00
  `define CR_KME_FULL_CCEIP2_OUT_IA_STATUS_T_RESERVED0  23:09
  `define CR_KME_FULL_CCEIP2_OUT_IA_STATUS_T_DATAWORDS  28:24
  `define CR_KME_FULL_CCEIP2_OUT_IA_STATUS_T_CODE       31:29

`define CR_KME_C_CCEIP2_OUT_IA_STATUS_T_DECL   16:0
`define CR_KME_C_CCEIP2_OUT_IA_STATUS_T_WIDTH  17
  `define CR_KME_C_CCEIP2_OUT_IA_STATUS_T_ADDR       08:00
  `define CR_KME_C_CCEIP2_OUT_IA_STATUS_T_DATAWORDS  13:09
  `define CR_KME_C_CCEIP2_OUT_IA_STATUS_T_CODE       16:14

`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_DEFAULT  (32'b xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)

`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_NOP_DECL   0:0
`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_NOP_WIDTH  1

`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_READ_DECL   0:0
`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_READ_WIDTH  1

`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_WRITE_DECL   0:0
`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_WRITE_WIDTH  1

`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_ENABLE_DECL   0:0
`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_ENABLE_WIDTH  1

`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_DISABLED_DECL   0:0
`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_DISABLED_WIDTH  1

`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_RESET_DECL   0:0
`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_RESET_WIDTH  1

`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_INITIALIZE_DECL   0:0
`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_INITIALIZE_WIDTH  1

`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_INITIALIZE_INC_DECL   0:0
`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_INITIALIZE_INC_WIDTH  1

`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_SET_INIT_START_DECL   0:0
`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_SET_INIT_START_WIDTH  1

`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_COMPARE_DECL   0:0
`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_COMPARE_WIDTH  1

`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_RESERVED_OP_DECL   3:0
`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_RESERVED_OP_WIDTH  4

`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_SIM_TMO_DECL   0:0
`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_SIM_TMO_WIDTH  1

`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_ACK_ERROR_DECL   0:0
`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_ACK_ERROR_WIDTH  1

`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_MEM_TYPE_DECL   3:0
`define CR_KME_CCEIP2_OUT_IA_CAPABILITY_T_MEM_TYPE_WIDTH  4

`define CR_KME_FULL_CCEIP2_OUT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_FULL_CCEIP2_OUT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_FULL_CCEIP2_OUT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_FULL_CCEIP2_OUT_IA_CAPABILITY_T_READ            01
  `define CR_KME_FULL_CCEIP2_OUT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_FULL_CCEIP2_OUT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_FULL_CCEIP2_OUT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_FULL_CCEIP2_OUT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_FULL_CCEIP2_OUT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_FULL_CCEIP2_OUT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_FULL_CCEIP2_OUT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_FULL_CCEIP2_OUT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_FULL_CCEIP2_OUT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_FULL_CCEIP2_OUT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_FULL_CCEIP2_OUT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_FULL_CCEIP2_OUT_IA_CAPABILITY_T_RESERVED0       27:16
  `define CR_KME_FULL_CCEIP2_OUT_IA_CAPABILITY_T_MEM_TYPE        31:28

`define CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_DECL   19:0
`define CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_WIDTH  20
  `define CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_READ            01
  `define CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_C_CCEIP2_OUT_IA_CAPABILITY_T_MEM_TYPE        19:16

`define CR_KME_CCEIP2_OUT_IM_CONFIG_T_DECL   31:0
`define CR_KME_CCEIP2_OUT_IM_CONFIG_T_WIDTH  32
  `define CR_KME_CCEIP2_OUT_IM_CONFIG_T_DEFAULT  (32'h c0000200)

`define CR_KME_CCEIP2_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_DECL   9:0
`define CR_KME_CCEIP2_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_WIDTH  10
  `define CR_KME_CCEIP2_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_DEFAULT  (10'h 200)

`define CR_KME_CCEIP2_OUT_IM_CONFIG_T_MODE_DECL   1:0
`define CR_KME_CCEIP2_OUT_IM_CONFIG_T_MODE_WIDTH  2
  `define CR_KME_CCEIP2_OUT_IM_CONFIG_T_MODE_DEFAULT  (2'h 3)

`define CR_KME_FULL_CCEIP2_OUT_IM_CONFIG_T_DECL   31:0
`define CR_KME_FULL_CCEIP2_OUT_IM_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_CCEIP2_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG  09:00
  `define CR_KME_FULL_CCEIP2_OUT_IM_CONFIG_T_RESERVED0         29:10
  `define CR_KME_FULL_CCEIP2_OUT_IM_CONFIG_T_MODE              31:30

`define CR_KME_C_CCEIP2_OUT_IM_CONFIG_T_DECL   11:0
`define CR_KME_C_CCEIP2_OUT_IM_CONFIG_T_WIDTH  12
  `define CR_KME_C_CCEIP2_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG  09:00
  `define CR_KME_C_CCEIP2_OUT_IM_CONFIG_T_MODE              11:10

`define CR_KME_CCEIP2_OUT_IM_STATUS_T_DECL   31:0
`define CR_KME_CCEIP2_OUT_IM_STATUS_T_WIDTH  32
  `define CR_KME_CCEIP2_OUT_IM_STATUS_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP2_OUT_IM_STATUS_T_WR_POINTER_DECL   8:0
`define CR_KME_CCEIP2_OUT_IM_STATUS_T_WR_POINTER_WIDTH  9
  `define CR_KME_CCEIP2_OUT_IM_STATUS_T_WR_POINTER_DEFAULT  (9'h 0)

`define CR_KME_CCEIP2_OUT_IM_STATUS_T_OVERFLOW_DECL   0:0
`define CR_KME_CCEIP2_OUT_IM_STATUS_T_OVERFLOW_WIDTH  1
  `define CR_KME_CCEIP2_OUT_IM_STATUS_T_OVERFLOW_DEFAULT  (1'h 0)

`define CR_KME_CCEIP2_OUT_IM_STATUS_T_BANK_LO_DECL   0:0
`define CR_KME_CCEIP2_OUT_IM_STATUS_T_BANK_LO_WIDTH  1
  `define CR_KME_CCEIP2_OUT_IM_STATUS_T_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_CCEIP2_OUT_IM_STATUS_T_BANK_HI_DECL   0:0
`define CR_KME_CCEIP2_OUT_IM_STATUS_T_BANK_HI_WIDTH  1
  `define CR_KME_CCEIP2_OUT_IM_STATUS_T_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_CCEIP2_OUT_IM_STATUS_T_DECL   31:0
`define CR_KME_FULL_CCEIP2_OUT_IM_STATUS_T_WIDTH  32
  `define CR_KME_FULL_CCEIP2_OUT_IM_STATUS_T_WR_POINTER  08:00
  `define CR_KME_FULL_CCEIP2_OUT_IM_STATUS_T_RESERVED0   28:09
  `define CR_KME_FULL_CCEIP2_OUT_IM_STATUS_T_OVERFLOW    29
  `define CR_KME_FULL_CCEIP2_OUT_IM_STATUS_T_BANK_LO     30
  `define CR_KME_FULL_CCEIP2_OUT_IM_STATUS_T_BANK_HI     31

`define CR_KME_C_CCEIP2_OUT_IM_STATUS_T_DECL   11:0
`define CR_KME_C_CCEIP2_OUT_IM_STATUS_T_WIDTH  12
  `define CR_KME_C_CCEIP2_OUT_IM_STATUS_T_WR_POINTER  08:00
  `define CR_KME_C_CCEIP2_OUT_IM_STATUS_T_OVERFLOW    09
  `define CR_KME_C_CCEIP2_OUT_IM_STATUS_T_BANK_LO     10
  `define CR_KME_C_CCEIP2_OUT_IM_STATUS_T_BANK_HI     11

`define CR_KME_CCEIP2_OUT_IM_CONSUMED_T_DECL   31:0
`define CR_KME_CCEIP2_OUT_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_CCEIP2_OUT_IM_CONSUMED_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP2_OUT_IM_CONSUMED_T_BANK_LO_DECL   0:0
`define CR_KME_CCEIP2_OUT_IM_CONSUMED_T_BANK_LO_WIDTH  1
  `define CR_KME_CCEIP2_OUT_IM_CONSUMED_T_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_CCEIP2_OUT_IM_CONSUMED_T_BANK_HI_DECL   0:0
`define CR_KME_CCEIP2_OUT_IM_CONSUMED_T_BANK_HI_WIDTH  1
  `define CR_KME_CCEIP2_OUT_IM_CONSUMED_T_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_CCEIP2_OUT_IM_CONSUMED_T_DECL   31:0
`define CR_KME_FULL_CCEIP2_OUT_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_FULL_CCEIP2_OUT_IM_CONSUMED_T_RESERVED0  29:0
  `define CR_KME_FULL_CCEIP2_OUT_IM_CONSUMED_T_BANK_LO    30
  `define CR_KME_FULL_CCEIP2_OUT_IM_CONSUMED_T_BANK_HI    31

`define CR_KME_C_CCEIP2_OUT_IM_CONSUMED_T_DECL   1:0
`define CR_KME_C_CCEIP2_OUT_IM_CONSUMED_T_WIDTH  2
  `define CR_KME_C_CCEIP2_OUT_IM_CONSUMED_T_BANK_LO  0
  `define CR_KME_C_CCEIP2_OUT_IM_CONSUMED_T_BANK_HI  1

`define CR_KME_CCEIP3_OUT_PART0_T_DECL   31:0
`define CR_KME_CCEIP3_OUT_PART0_T_WIDTH  32
  `define CR_KME_CCEIP3_OUT_PART0_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP3_OUT_PART0_T_UNUSED0_DECL   5:0
`define CR_KME_CCEIP3_OUT_PART0_T_UNUSED0_WIDTH  6
  `define CR_KME_CCEIP3_OUT_PART0_T_UNUSED0_DEFAULT  (6'h 0)

`define CR_KME_CCEIP3_OUT_PART0_T_TUSER_DECL   7:0
`define CR_KME_CCEIP3_OUT_PART0_T_TUSER_WIDTH  8

`define CR_KME_CCEIP3_OUT_PART0_T_TID_DECL   0:0
`define CR_KME_CCEIP3_OUT_PART0_T_TID_WIDTH  1

`define CR_KME_CCEIP3_OUT_PART0_T_UNUSED1_DECL   7:0
`define CR_KME_CCEIP3_OUT_PART0_T_UNUSED1_WIDTH  8

`define CR_KME_CCEIP3_OUT_PART0_T_BYTES_VLD_DECL   7:0
`define CR_KME_CCEIP3_OUT_PART0_T_BYTES_VLD_WIDTH  8

`define CR_KME_CCEIP3_OUT_PART0_T_EOB_DECL   0:0
`define CR_KME_CCEIP3_OUT_PART0_T_EOB_WIDTH  1

`define CR_KME_FULL_CCEIP3_OUT_PART0_T_DECL   31:0
`define CR_KME_FULL_CCEIP3_OUT_PART0_T_WIDTH  32
  `define CR_KME_FULL_CCEIP3_OUT_PART0_T_UNUSED0    05:00
  `define CR_KME_FULL_CCEIP3_OUT_PART0_T_TUSER      13:06
  `define CR_KME_FULL_CCEIP3_OUT_PART0_T_TID        14
  `define CR_KME_FULL_CCEIP3_OUT_PART0_T_UNUSED1    22:15
  `define CR_KME_FULL_CCEIP3_OUT_PART0_T_BYTES_VLD  30:23
  `define CR_KME_FULL_CCEIP3_OUT_PART0_T_EOB        31

`define CR_KME_C_CCEIP3_OUT_PART0_T_DECL   31:0
`define CR_KME_C_CCEIP3_OUT_PART0_T_WIDTH  32
  `define CR_KME_C_CCEIP3_OUT_PART0_T_UNUSED0    05:00
  `define CR_KME_C_CCEIP3_OUT_PART0_T_TUSER      13:06
  `define CR_KME_C_CCEIP3_OUT_PART0_T_TID        14
  `define CR_KME_C_CCEIP3_OUT_PART0_T_UNUSED1    22:15
  `define CR_KME_C_CCEIP3_OUT_PART0_T_BYTES_VLD  30:23
  `define CR_KME_C_CCEIP3_OUT_PART0_T_EOB        31

`define CR_KME_CCEIP3_OUT_PART1_T_DECL   31:0
`define CR_KME_CCEIP3_OUT_PART1_T_WIDTH  32
  `define CR_KME_CCEIP3_OUT_PART1_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP3_OUT_PART1_T_TDATA_LO_DECL   31:0
`define CR_KME_CCEIP3_OUT_PART1_T_TDATA_LO_WIDTH  32
  `define CR_KME_CCEIP3_OUT_PART1_T_TDATA_LO_DEFAULT  (32'h 0)

`define CR_KME_FULL_CCEIP3_OUT_PART1_T_DECL   31:0
`define CR_KME_FULL_CCEIP3_OUT_PART1_T_WIDTH  32
  `define CR_KME_FULL_CCEIP3_OUT_PART1_T_TDATA_LO  31:00

`define CR_KME_C_CCEIP3_OUT_PART1_T_DECL   31:0
`define CR_KME_C_CCEIP3_OUT_PART1_T_WIDTH  32
  `define CR_KME_C_CCEIP3_OUT_PART1_T_TDATA_LO  31:00

`define CR_KME_CCEIP3_OUT_PART2_T_DECL   31:0
`define CR_KME_CCEIP3_OUT_PART2_T_WIDTH  32
  `define CR_KME_CCEIP3_OUT_PART2_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP3_OUT_PART2_T_TDATA_HI_DECL   31:0
`define CR_KME_CCEIP3_OUT_PART2_T_TDATA_HI_WIDTH  32
  `define CR_KME_CCEIP3_OUT_PART2_T_TDATA_HI_DEFAULT  (32'h 0)

`define CR_KME_FULL_CCEIP3_OUT_PART2_T_DECL   31:0
`define CR_KME_FULL_CCEIP3_OUT_PART2_T_WIDTH  32
  `define CR_KME_FULL_CCEIP3_OUT_PART2_T_TDATA_HI  31:00

`define CR_KME_C_CCEIP3_OUT_PART2_T_DECL   31:0
`define CR_KME_C_CCEIP3_OUT_PART2_T_WIDTH  32
  `define CR_KME_C_CCEIP3_OUT_PART2_T_TDATA_HI  31:00

`define CR_KME_CCEIP3_OUT_IA_CONFIG_T_DECL   31:0
`define CR_KME_CCEIP3_OUT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_CCEIP3_OUT_IA_CONFIG_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP3_OUT_IA_CONFIG_T_ADDR_DECL   8:0
`define CR_KME_CCEIP3_OUT_IA_CONFIG_T_ADDR_WIDTH  9
  `define CR_KME_CCEIP3_OUT_IA_CONFIG_T_ADDR_DEFAULT  (9'h 0)

`define CR_KME_CCEIP3_OUT_IA_CONFIG_T_OP_DECL   3:0
`define CR_KME_CCEIP3_OUT_IA_CONFIG_T_OP_WIDTH  4
  `define CR_KME_CCEIP3_OUT_IA_CONFIG_T_OP_DEFAULT  (4'h 0)

`define CR_KME_FULL_CCEIP3_OUT_IA_CONFIG_T_DECL   31:0
`define CR_KME_FULL_CCEIP3_OUT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_CCEIP3_OUT_IA_CONFIG_T_ADDR       08:00
  `define CR_KME_FULL_CCEIP3_OUT_IA_CONFIG_T_RESERVED0  27:09
  `define CR_KME_FULL_CCEIP3_OUT_IA_CONFIG_T_OP         31:28

`define CR_KME_C_CCEIP3_OUT_IA_CONFIG_T_DECL   12:0
`define CR_KME_C_CCEIP3_OUT_IA_CONFIG_T_WIDTH  13
  `define CR_KME_C_CCEIP3_OUT_IA_CONFIG_T_ADDR  08:00
  `define CR_KME_C_CCEIP3_OUT_IA_CONFIG_T_OP    12:09

`define CR_KME_CCEIP3_OUT_IA_STATUS_T_DECL   31:0
`define CR_KME_CCEIP3_OUT_IA_STATUS_T_WIDTH  32
  `define CR_KME_CCEIP3_OUT_IA_STATUS_T_DEFAULT  (32'h 20001ff)

`define CR_KME_CCEIP3_OUT_IA_STATUS_T_ADDR_DECL   8:0
`define CR_KME_CCEIP3_OUT_IA_STATUS_T_ADDR_WIDTH  9
  `define CR_KME_CCEIP3_OUT_IA_STATUS_T_ADDR_DEFAULT  (9'h 1ff)

`define CR_KME_CCEIP3_OUT_IA_STATUS_T_DATAWORDS_DECL   4:0
`define CR_KME_CCEIP3_OUT_IA_STATUS_T_DATAWORDS_WIDTH  5
  `define CR_KME_CCEIP3_OUT_IA_STATUS_T_DATAWORDS_DEFAULT  (5'h 2)

`define CR_KME_CCEIP3_OUT_IA_STATUS_T_CODE_DECL   2:0
`define CR_KME_CCEIP3_OUT_IA_STATUS_T_CODE_WIDTH  3
  `define CR_KME_CCEIP3_OUT_IA_STATUS_T_CODE_DEFAULT  (3'h 0)

`define CR_KME_FULL_CCEIP3_OUT_IA_STATUS_T_DECL   31:0
`define CR_KME_FULL_CCEIP3_OUT_IA_STATUS_T_WIDTH  32
  `define CR_KME_FULL_CCEIP3_OUT_IA_STATUS_T_ADDR       08:00
  `define CR_KME_FULL_CCEIP3_OUT_IA_STATUS_T_RESERVED0  23:09
  `define CR_KME_FULL_CCEIP3_OUT_IA_STATUS_T_DATAWORDS  28:24
  `define CR_KME_FULL_CCEIP3_OUT_IA_STATUS_T_CODE       31:29

`define CR_KME_C_CCEIP3_OUT_IA_STATUS_T_DECL   16:0
`define CR_KME_C_CCEIP3_OUT_IA_STATUS_T_WIDTH  17
  `define CR_KME_C_CCEIP3_OUT_IA_STATUS_T_ADDR       08:00
  `define CR_KME_C_CCEIP3_OUT_IA_STATUS_T_DATAWORDS  13:09
  `define CR_KME_C_CCEIP3_OUT_IA_STATUS_T_CODE       16:14

`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_DEFAULT  (32'b xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)

`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_NOP_DECL   0:0
`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_NOP_WIDTH  1

`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_READ_DECL   0:0
`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_READ_WIDTH  1

`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_WRITE_DECL   0:0
`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_WRITE_WIDTH  1

`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_ENABLE_DECL   0:0
`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_ENABLE_WIDTH  1

`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_DISABLED_DECL   0:0
`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_DISABLED_WIDTH  1

`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_RESET_DECL   0:0
`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_RESET_WIDTH  1

`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_INITIALIZE_DECL   0:0
`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_INITIALIZE_WIDTH  1

`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_INITIALIZE_INC_DECL   0:0
`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_INITIALIZE_INC_WIDTH  1

`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_SET_INIT_START_DECL   0:0
`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_SET_INIT_START_WIDTH  1

`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_COMPARE_DECL   0:0
`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_COMPARE_WIDTH  1

`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_RESERVED_OP_DECL   3:0
`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_RESERVED_OP_WIDTH  4

`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_SIM_TMO_DECL   0:0
`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_SIM_TMO_WIDTH  1

`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_ACK_ERROR_DECL   0:0
`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_ACK_ERROR_WIDTH  1

`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_MEM_TYPE_DECL   3:0
`define CR_KME_CCEIP3_OUT_IA_CAPABILITY_T_MEM_TYPE_WIDTH  4

`define CR_KME_FULL_CCEIP3_OUT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_FULL_CCEIP3_OUT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_FULL_CCEIP3_OUT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_FULL_CCEIP3_OUT_IA_CAPABILITY_T_READ            01
  `define CR_KME_FULL_CCEIP3_OUT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_FULL_CCEIP3_OUT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_FULL_CCEIP3_OUT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_FULL_CCEIP3_OUT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_FULL_CCEIP3_OUT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_FULL_CCEIP3_OUT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_FULL_CCEIP3_OUT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_FULL_CCEIP3_OUT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_FULL_CCEIP3_OUT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_FULL_CCEIP3_OUT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_FULL_CCEIP3_OUT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_FULL_CCEIP3_OUT_IA_CAPABILITY_T_RESERVED0       27:16
  `define CR_KME_FULL_CCEIP3_OUT_IA_CAPABILITY_T_MEM_TYPE        31:28

`define CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_DECL   19:0
`define CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_WIDTH  20
  `define CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_READ            01
  `define CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_C_CCEIP3_OUT_IA_CAPABILITY_T_MEM_TYPE        19:16

`define CR_KME_CCEIP3_OUT_IM_CONFIG_T_DECL   31:0
`define CR_KME_CCEIP3_OUT_IM_CONFIG_T_WIDTH  32
  `define CR_KME_CCEIP3_OUT_IM_CONFIG_T_DEFAULT  (32'h c0000200)

`define CR_KME_CCEIP3_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_DECL   9:0
`define CR_KME_CCEIP3_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_WIDTH  10
  `define CR_KME_CCEIP3_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_DEFAULT  (10'h 200)

`define CR_KME_CCEIP3_OUT_IM_CONFIG_T_MODE_DECL   1:0
`define CR_KME_CCEIP3_OUT_IM_CONFIG_T_MODE_WIDTH  2
  `define CR_KME_CCEIP3_OUT_IM_CONFIG_T_MODE_DEFAULT  (2'h 3)

`define CR_KME_FULL_CCEIP3_OUT_IM_CONFIG_T_DECL   31:0
`define CR_KME_FULL_CCEIP3_OUT_IM_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_CCEIP3_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG  09:00
  `define CR_KME_FULL_CCEIP3_OUT_IM_CONFIG_T_RESERVED0         29:10
  `define CR_KME_FULL_CCEIP3_OUT_IM_CONFIG_T_MODE              31:30

`define CR_KME_C_CCEIP3_OUT_IM_CONFIG_T_DECL   11:0
`define CR_KME_C_CCEIP3_OUT_IM_CONFIG_T_WIDTH  12
  `define CR_KME_C_CCEIP3_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG  09:00
  `define CR_KME_C_CCEIP3_OUT_IM_CONFIG_T_MODE              11:10

`define CR_KME_CCEIP3_OUT_IM_STATUS_T_DECL   31:0
`define CR_KME_CCEIP3_OUT_IM_STATUS_T_WIDTH  32
  `define CR_KME_CCEIP3_OUT_IM_STATUS_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP3_OUT_IM_STATUS_T_WR_POINTER_DECL   8:0
`define CR_KME_CCEIP3_OUT_IM_STATUS_T_WR_POINTER_WIDTH  9
  `define CR_KME_CCEIP3_OUT_IM_STATUS_T_WR_POINTER_DEFAULT  (9'h 0)

`define CR_KME_CCEIP3_OUT_IM_STATUS_T_OVERFLOW_DECL   0:0
`define CR_KME_CCEIP3_OUT_IM_STATUS_T_OVERFLOW_WIDTH  1
  `define CR_KME_CCEIP3_OUT_IM_STATUS_T_OVERFLOW_DEFAULT  (1'h 0)

`define CR_KME_CCEIP3_OUT_IM_STATUS_T_BANK_LO_DECL   0:0
`define CR_KME_CCEIP3_OUT_IM_STATUS_T_BANK_LO_WIDTH  1
  `define CR_KME_CCEIP3_OUT_IM_STATUS_T_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_CCEIP3_OUT_IM_STATUS_T_BANK_HI_DECL   0:0
`define CR_KME_CCEIP3_OUT_IM_STATUS_T_BANK_HI_WIDTH  1
  `define CR_KME_CCEIP3_OUT_IM_STATUS_T_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_CCEIP3_OUT_IM_STATUS_T_DECL   31:0
`define CR_KME_FULL_CCEIP3_OUT_IM_STATUS_T_WIDTH  32
  `define CR_KME_FULL_CCEIP3_OUT_IM_STATUS_T_WR_POINTER  08:00
  `define CR_KME_FULL_CCEIP3_OUT_IM_STATUS_T_RESERVED0   28:09
  `define CR_KME_FULL_CCEIP3_OUT_IM_STATUS_T_OVERFLOW    29
  `define CR_KME_FULL_CCEIP3_OUT_IM_STATUS_T_BANK_LO     30
  `define CR_KME_FULL_CCEIP3_OUT_IM_STATUS_T_BANK_HI     31

`define CR_KME_C_CCEIP3_OUT_IM_STATUS_T_DECL   11:0
`define CR_KME_C_CCEIP3_OUT_IM_STATUS_T_WIDTH  12
  `define CR_KME_C_CCEIP3_OUT_IM_STATUS_T_WR_POINTER  08:00
  `define CR_KME_C_CCEIP3_OUT_IM_STATUS_T_OVERFLOW    09
  `define CR_KME_C_CCEIP3_OUT_IM_STATUS_T_BANK_LO     10
  `define CR_KME_C_CCEIP3_OUT_IM_STATUS_T_BANK_HI     11

`define CR_KME_CCEIP3_OUT_IM_CONSUMED_T_DECL   31:0
`define CR_KME_CCEIP3_OUT_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_CCEIP3_OUT_IM_CONSUMED_T_DEFAULT  (32'h 0)

`define CR_KME_CCEIP3_OUT_IM_CONSUMED_T_BANK_LO_DECL   0:0
`define CR_KME_CCEIP3_OUT_IM_CONSUMED_T_BANK_LO_WIDTH  1
  `define CR_KME_CCEIP3_OUT_IM_CONSUMED_T_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_CCEIP3_OUT_IM_CONSUMED_T_BANK_HI_DECL   0:0
`define CR_KME_CCEIP3_OUT_IM_CONSUMED_T_BANK_HI_WIDTH  1
  `define CR_KME_CCEIP3_OUT_IM_CONSUMED_T_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_CCEIP3_OUT_IM_CONSUMED_T_DECL   31:0
`define CR_KME_FULL_CCEIP3_OUT_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_FULL_CCEIP3_OUT_IM_CONSUMED_T_RESERVED0  29:0
  `define CR_KME_FULL_CCEIP3_OUT_IM_CONSUMED_T_BANK_LO    30
  `define CR_KME_FULL_CCEIP3_OUT_IM_CONSUMED_T_BANK_HI    31

`define CR_KME_C_CCEIP3_OUT_IM_CONSUMED_T_DECL   1:0
`define CR_KME_C_CCEIP3_OUT_IM_CONSUMED_T_WIDTH  2
  `define CR_KME_C_CCEIP3_OUT_IM_CONSUMED_T_BANK_LO  0
  `define CR_KME_C_CCEIP3_OUT_IM_CONSUMED_T_BANK_HI  1

`define CR_KME_CDDIP0_OUT_PART0_T_DECL   31:0
`define CR_KME_CDDIP0_OUT_PART0_T_WIDTH  32
  `define CR_KME_CDDIP0_OUT_PART0_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP0_OUT_PART0_T_UNUSED0_DECL   5:0
`define CR_KME_CDDIP0_OUT_PART0_T_UNUSED0_WIDTH  6
  `define CR_KME_CDDIP0_OUT_PART0_T_UNUSED0_DEFAULT  (6'h 0)

`define CR_KME_CDDIP0_OUT_PART0_T_TUSER_DECL   7:0
`define CR_KME_CDDIP0_OUT_PART0_T_TUSER_WIDTH  8

`define CR_KME_CDDIP0_OUT_PART0_T_TID_DECL   0:0
`define CR_KME_CDDIP0_OUT_PART0_T_TID_WIDTH  1

`define CR_KME_CDDIP0_OUT_PART0_T_UNUSED1_DECL   7:0
`define CR_KME_CDDIP0_OUT_PART0_T_UNUSED1_WIDTH  8

`define CR_KME_CDDIP0_OUT_PART0_T_BYTES_VLD_DECL   7:0
`define CR_KME_CDDIP0_OUT_PART0_T_BYTES_VLD_WIDTH  8

`define CR_KME_CDDIP0_OUT_PART0_T_EOB_DECL   0:0
`define CR_KME_CDDIP0_OUT_PART0_T_EOB_WIDTH  1

`define CR_KME_FULL_CDDIP0_OUT_PART0_T_DECL   31:0
`define CR_KME_FULL_CDDIP0_OUT_PART0_T_WIDTH  32
  `define CR_KME_FULL_CDDIP0_OUT_PART0_T_UNUSED0    05:00
  `define CR_KME_FULL_CDDIP0_OUT_PART0_T_TUSER      13:06
  `define CR_KME_FULL_CDDIP0_OUT_PART0_T_TID        14
  `define CR_KME_FULL_CDDIP0_OUT_PART0_T_UNUSED1    22:15
  `define CR_KME_FULL_CDDIP0_OUT_PART0_T_BYTES_VLD  30:23
  `define CR_KME_FULL_CDDIP0_OUT_PART0_T_EOB        31

`define CR_KME_C_CDDIP0_OUT_PART0_T_DECL   31:0
`define CR_KME_C_CDDIP0_OUT_PART0_T_WIDTH  32
  `define CR_KME_C_CDDIP0_OUT_PART0_T_UNUSED0    05:00
  `define CR_KME_C_CDDIP0_OUT_PART0_T_TUSER      13:06
  `define CR_KME_C_CDDIP0_OUT_PART0_T_TID        14
  `define CR_KME_C_CDDIP0_OUT_PART0_T_UNUSED1    22:15
  `define CR_KME_C_CDDIP0_OUT_PART0_T_BYTES_VLD  30:23
  `define CR_KME_C_CDDIP0_OUT_PART0_T_EOB        31

`define CR_KME_CDDIP0_OUT_PART1_T_DECL   31:0
`define CR_KME_CDDIP0_OUT_PART1_T_WIDTH  32
  `define CR_KME_CDDIP0_OUT_PART1_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP0_OUT_PART1_T_TDATA_LO_DECL   31:0
`define CR_KME_CDDIP0_OUT_PART1_T_TDATA_LO_WIDTH  32
  `define CR_KME_CDDIP0_OUT_PART1_T_TDATA_LO_DEFAULT  (32'h 0)

`define CR_KME_FULL_CDDIP0_OUT_PART1_T_DECL   31:0
`define CR_KME_FULL_CDDIP0_OUT_PART1_T_WIDTH  32
  `define CR_KME_FULL_CDDIP0_OUT_PART1_T_TDATA_LO  31:00

`define CR_KME_C_CDDIP0_OUT_PART1_T_DECL   31:0
`define CR_KME_C_CDDIP0_OUT_PART1_T_WIDTH  32
  `define CR_KME_C_CDDIP0_OUT_PART1_T_TDATA_LO  31:00

`define CR_KME_CDDIP0_OUT_PART2_T_DECL   31:0
`define CR_KME_CDDIP0_OUT_PART2_T_WIDTH  32
  `define CR_KME_CDDIP0_OUT_PART2_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP0_OUT_PART2_T_TDATA_HI_DECL   31:0
`define CR_KME_CDDIP0_OUT_PART2_T_TDATA_HI_WIDTH  32
  `define CR_KME_CDDIP0_OUT_PART2_T_TDATA_HI_DEFAULT  (32'h 0)

`define CR_KME_FULL_CDDIP0_OUT_PART2_T_DECL   31:0
`define CR_KME_FULL_CDDIP0_OUT_PART2_T_WIDTH  32
  `define CR_KME_FULL_CDDIP0_OUT_PART2_T_TDATA_HI  31:00

`define CR_KME_C_CDDIP0_OUT_PART2_T_DECL   31:0
`define CR_KME_C_CDDIP0_OUT_PART2_T_WIDTH  32
  `define CR_KME_C_CDDIP0_OUT_PART2_T_TDATA_HI  31:00

`define CR_KME_CDDIP0_OUT_IA_CONFIG_T_DECL   31:0
`define CR_KME_CDDIP0_OUT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_CDDIP0_OUT_IA_CONFIG_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP0_OUT_IA_CONFIG_T_ADDR_DECL   8:0
`define CR_KME_CDDIP0_OUT_IA_CONFIG_T_ADDR_WIDTH  9
  `define CR_KME_CDDIP0_OUT_IA_CONFIG_T_ADDR_DEFAULT  (9'h 0)

`define CR_KME_CDDIP0_OUT_IA_CONFIG_T_OP_DECL   3:0
`define CR_KME_CDDIP0_OUT_IA_CONFIG_T_OP_WIDTH  4
  `define CR_KME_CDDIP0_OUT_IA_CONFIG_T_OP_DEFAULT  (4'h 0)

`define CR_KME_FULL_CDDIP0_OUT_IA_CONFIG_T_DECL   31:0
`define CR_KME_FULL_CDDIP0_OUT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_CDDIP0_OUT_IA_CONFIG_T_ADDR       08:00
  `define CR_KME_FULL_CDDIP0_OUT_IA_CONFIG_T_RESERVED0  27:09
  `define CR_KME_FULL_CDDIP0_OUT_IA_CONFIG_T_OP         31:28

`define CR_KME_C_CDDIP0_OUT_IA_CONFIG_T_DECL   12:0
`define CR_KME_C_CDDIP0_OUT_IA_CONFIG_T_WIDTH  13
  `define CR_KME_C_CDDIP0_OUT_IA_CONFIG_T_ADDR  08:00
  `define CR_KME_C_CDDIP0_OUT_IA_CONFIG_T_OP    12:09

`define CR_KME_CDDIP0_OUT_IA_STATUS_T_DECL   31:0
`define CR_KME_CDDIP0_OUT_IA_STATUS_T_WIDTH  32
  `define CR_KME_CDDIP0_OUT_IA_STATUS_T_DEFAULT  (32'h 20001ff)

`define CR_KME_CDDIP0_OUT_IA_STATUS_T_ADDR_DECL   8:0
`define CR_KME_CDDIP0_OUT_IA_STATUS_T_ADDR_WIDTH  9
  `define CR_KME_CDDIP0_OUT_IA_STATUS_T_ADDR_DEFAULT  (9'h 1ff)

`define CR_KME_CDDIP0_OUT_IA_STATUS_T_DATAWORDS_DECL   4:0
`define CR_KME_CDDIP0_OUT_IA_STATUS_T_DATAWORDS_WIDTH  5
  `define CR_KME_CDDIP0_OUT_IA_STATUS_T_DATAWORDS_DEFAULT  (5'h 2)

`define CR_KME_CDDIP0_OUT_IA_STATUS_T_CODE_DECL   2:0
`define CR_KME_CDDIP0_OUT_IA_STATUS_T_CODE_WIDTH  3
  `define CR_KME_CDDIP0_OUT_IA_STATUS_T_CODE_DEFAULT  (3'h 0)

`define CR_KME_FULL_CDDIP0_OUT_IA_STATUS_T_DECL   31:0
`define CR_KME_FULL_CDDIP0_OUT_IA_STATUS_T_WIDTH  32
  `define CR_KME_FULL_CDDIP0_OUT_IA_STATUS_T_ADDR       08:00
  `define CR_KME_FULL_CDDIP0_OUT_IA_STATUS_T_RESERVED0  23:09
  `define CR_KME_FULL_CDDIP0_OUT_IA_STATUS_T_DATAWORDS  28:24
  `define CR_KME_FULL_CDDIP0_OUT_IA_STATUS_T_CODE       31:29

`define CR_KME_C_CDDIP0_OUT_IA_STATUS_T_DECL   16:0
`define CR_KME_C_CDDIP0_OUT_IA_STATUS_T_WIDTH  17
  `define CR_KME_C_CDDIP0_OUT_IA_STATUS_T_ADDR       08:00
  `define CR_KME_C_CDDIP0_OUT_IA_STATUS_T_DATAWORDS  13:09
  `define CR_KME_C_CDDIP0_OUT_IA_STATUS_T_CODE       16:14

`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_DEFAULT  (32'b xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)

`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_NOP_DECL   0:0
`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_NOP_WIDTH  1

`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_READ_DECL   0:0
`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_READ_WIDTH  1

`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_WRITE_DECL   0:0
`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_WRITE_WIDTH  1

`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_ENABLE_DECL   0:0
`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_ENABLE_WIDTH  1

`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_DISABLED_DECL   0:0
`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_DISABLED_WIDTH  1

`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_RESET_DECL   0:0
`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_RESET_WIDTH  1

`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_INITIALIZE_DECL   0:0
`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_INITIALIZE_WIDTH  1

`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_INITIALIZE_INC_DECL   0:0
`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_INITIALIZE_INC_WIDTH  1

`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_SET_INIT_START_DECL   0:0
`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_SET_INIT_START_WIDTH  1

`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_COMPARE_DECL   0:0
`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_COMPARE_WIDTH  1

`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_RESERVED_OP_DECL   3:0
`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_RESERVED_OP_WIDTH  4

`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_SIM_TMO_DECL   0:0
`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_SIM_TMO_WIDTH  1

`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_ACK_ERROR_DECL   0:0
`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_ACK_ERROR_WIDTH  1

`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_MEM_TYPE_DECL   3:0
`define CR_KME_CDDIP0_OUT_IA_CAPABILITY_T_MEM_TYPE_WIDTH  4

`define CR_KME_FULL_CDDIP0_OUT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_FULL_CDDIP0_OUT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_FULL_CDDIP0_OUT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_FULL_CDDIP0_OUT_IA_CAPABILITY_T_READ            01
  `define CR_KME_FULL_CDDIP0_OUT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_FULL_CDDIP0_OUT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_FULL_CDDIP0_OUT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_FULL_CDDIP0_OUT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_FULL_CDDIP0_OUT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_FULL_CDDIP0_OUT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_FULL_CDDIP0_OUT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_FULL_CDDIP0_OUT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_FULL_CDDIP0_OUT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_FULL_CDDIP0_OUT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_FULL_CDDIP0_OUT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_FULL_CDDIP0_OUT_IA_CAPABILITY_T_RESERVED0       27:16
  `define CR_KME_FULL_CDDIP0_OUT_IA_CAPABILITY_T_MEM_TYPE        31:28

`define CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_DECL   19:0
`define CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_WIDTH  20
  `define CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_READ            01
  `define CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_C_CDDIP0_OUT_IA_CAPABILITY_T_MEM_TYPE        19:16

`define CR_KME_CDDIP0_OUT_IM_CONFIG_T_DECL   31:0
`define CR_KME_CDDIP0_OUT_IM_CONFIG_T_WIDTH  32
  `define CR_KME_CDDIP0_OUT_IM_CONFIG_T_DEFAULT  (32'h c0000200)

`define CR_KME_CDDIP0_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_DECL   9:0
`define CR_KME_CDDIP0_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_WIDTH  10
  `define CR_KME_CDDIP0_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_DEFAULT  (10'h 200)

`define CR_KME_CDDIP0_OUT_IM_CONFIG_T_MODE_DECL   1:0
`define CR_KME_CDDIP0_OUT_IM_CONFIG_T_MODE_WIDTH  2
  `define CR_KME_CDDIP0_OUT_IM_CONFIG_T_MODE_DEFAULT  (2'h 3)

`define CR_KME_FULL_CDDIP0_OUT_IM_CONFIG_T_DECL   31:0
`define CR_KME_FULL_CDDIP0_OUT_IM_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_CDDIP0_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG  09:00
  `define CR_KME_FULL_CDDIP0_OUT_IM_CONFIG_T_RESERVED0         29:10
  `define CR_KME_FULL_CDDIP0_OUT_IM_CONFIG_T_MODE              31:30

`define CR_KME_C_CDDIP0_OUT_IM_CONFIG_T_DECL   11:0
`define CR_KME_C_CDDIP0_OUT_IM_CONFIG_T_WIDTH  12
  `define CR_KME_C_CDDIP0_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG  09:00
  `define CR_KME_C_CDDIP0_OUT_IM_CONFIG_T_MODE              11:10

`define CR_KME_CDDIP0_OUT_IM_STATUS_T_DECL   31:0
`define CR_KME_CDDIP0_OUT_IM_STATUS_T_WIDTH  32
  `define CR_KME_CDDIP0_OUT_IM_STATUS_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP0_OUT_IM_STATUS_T_WR_POINTER_DECL   8:0
`define CR_KME_CDDIP0_OUT_IM_STATUS_T_WR_POINTER_WIDTH  9
  `define CR_KME_CDDIP0_OUT_IM_STATUS_T_WR_POINTER_DEFAULT  (9'h 0)

`define CR_KME_CDDIP0_OUT_IM_STATUS_T_OVERFLOW_DECL   0:0
`define CR_KME_CDDIP0_OUT_IM_STATUS_T_OVERFLOW_WIDTH  1
  `define CR_KME_CDDIP0_OUT_IM_STATUS_T_OVERFLOW_DEFAULT  (1'h 0)

`define CR_KME_CDDIP0_OUT_IM_STATUS_T_BANK_LO_DECL   0:0
`define CR_KME_CDDIP0_OUT_IM_STATUS_T_BANK_LO_WIDTH  1
  `define CR_KME_CDDIP0_OUT_IM_STATUS_T_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_CDDIP0_OUT_IM_STATUS_T_BANK_HI_DECL   0:0
`define CR_KME_CDDIP0_OUT_IM_STATUS_T_BANK_HI_WIDTH  1
  `define CR_KME_CDDIP0_OUT_IM_STATUS_T_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_CDDIP0_OUT_IM_STATUS_T_DECL   31:0
`define CR_KME_FULL_CDDIP0_OUT_IM_STATUS_T_WIDTH  32
  `define CR_KME_FULL_CDDIP0_OUT_IM_STATUS_T_WR_POINTER  08:00
  `define CR_KME_FULL_CDDIP0_OUT_IM_STATUS_T_RESERVED0   28:09
  `define CR_KME_FULL_CDDIP0_OUT_IM_STATUS_T_OVERFLOW    29
  `define CR_KME_FULL_CDDIP0_OUT_IM_STATUS_T_BANK_LO     30
  `define CR_KME_FULL_CDDIP0_OUT_IM_STATUS_T_BANK_HI     31

`define CR_KME_C_CDDIP0_OUT_IM_STATUS_T_DECL   11:0
`define CR_KME_C_CDDIP0_OUT_IM_STATUS_T_WIDTH  12
  `define CR_KME_C_CDDIP0_OUT_IM_STATUS_T_WR_POINTER  08:00
  `define CR_KME_C_CDDIP0_OUT_IM_STATUS_T_OVERFLOW    09
  `define CR_KME_C_CDDIP0_OUT_IM_STATUS_T_BANK_LO     10
  `define CR_KME_C_CDDIP0_OUT_IM_STATUS_T_BANK_HI     11

`define CR_KME_CDDIP0_OUT_IM_CONSUMED_T_DECL   31:0
`define CR_KME_CDDIP0_OUT_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_CDDIP0_OUT_IM_CONSUMED_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP0_OUT_IM_CONSUMED_T_BANK_LO_DECL   0:0
`define CR_KME_CDDIP0_OUT_IM_CONSUMED_T_BANK_LO_WIDTH  1
  `define CR_KME_CDDIP0_OUT_IM_CONSUMED_T_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_CDDIP0_OUT_IM_CONSUMED_T_BANK_HI_DECL   0:0
`define CR_KME_CDDIP0_OUT_IM_CONSUMED_T_BANK_HI_WIDTH  1
  `define CR_KME_CDDIP0_OUT_IM_CONSUMED_T_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_CDDIP0_OUT_IM_CONSUMED_T_DECL   31:0
`define CR_KME_FULL_CDDIP0_OUT_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_FULL_CDDIP0_OUT_IM_CONSUMED_T_RESERVED0  29:0
  `define CR_KME_FULL_CDDIP0_OUT_IM_CONSUMED_T_BANK_LO    30
  `define CR_KME_FULL_CDDIP0_OUT_IM_CONSUMED_T_BANK_HI    31

`define CR_KME_C_CDDIP0_OUT_IM_CONSUMED_T_DECL   1:0
`define CR_KME_C_CDDIP0_OUT_IM_CONSUMED_T_WIDTH  2
  `define CR_KME_C_CDDIP0_OUT_IM_CONSUMED_T_BANK_LO  0
  `define CR_KME_C_CDDIP0_OUT_IM_CONSUMED_T_BANK_HI  1

`define CR_KME_CDDIP1_OUT_PART0_T_DECL   31:0
`define CR_KME_CDDIP1_OUT_PART0_T_WIDTH  32
  `define CR_KME_CDDIP1_OUT_PART0_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP1_OUT_PART0_T_UNUSED0_DECL   5:0
`define CR_KME_CDDIP1_OUT_PART0_T_UNUSED0_WIDTH  6
  `define CR_KME_CDDIP1_OUT_PART0_T_UNUSED0_DEFAULT  (6'h 0)

`define CR_KME_CDDIP1_OUT_PART0_T_TUSER_DECL   7:0
`define CR_KME_CDDIP1_OUT_PART0_T_TUSER_WIDTH  8

`define CR_KME_CDDIP1_OUT_PART0_T_TID_DECL   0:0
`define CR_KME_CDDIP1_OUT_PART0_T_TID_WIDTH  1

`define CR_KME_CDDIP1_OUT_PART0_T_UNUSED1_DECL   7:0
`define CR_KME_CDDIP1_OUT_PART0_T_UNUSED1_WIDTH  8

`define CR_KME_CDDIP1_OUT_PART0_T_BYTES_VLD_DECL   7:0
`define CR_KME_CDDIP1_OUT_PART0_T_BYTES_VLD_WIDTH  8

`define CR_KME_CDDIP1_OUT_PART0_T_EOB_DECL   0:0
`define CR_KME_CDDIP1_OUT_PART0_T_EOB_WIDTH  1

`define CR_KME_FULL_CDDIP1_OUT_PART0_T_DECL   31:0
`define CR_KME_FULL_CDDIP1_OUT_PART0_T_WIDTH  32
  `define CR_KME_FULL_CDDIP1_OUT_PART0_T_UNUSED0    05:00
  `define CR_KME_FULL_CDDIP1_OUT_PART0_T_TUSER      13:06
  `define CR_KME_FULL_CDDIP1_OUT_PART0_T_TID        14
  `define CR_KME_FULL_CDDIP1_OUT_PART0_T_UNUSED1    22:15
  `define CR_KME_FULL_CDDIP1_OUT_PART0_T_BYTES_VLD  30:23
  `define CR_KME_FULL_CDDIP1_OUT_PART0_T_EOB        31

`define CR_KME_C_CDDIP1_OUT_PART0_T_DECL   31:0
`define CR_KME_C_CDDIP1_OUT_PART0_T_WIDTH  32
  `define CR_KME_C_CDDIP1_OUT_PART0_T_UNUSED0    05:00
  `define CR_KME_C_CDDIP1_OUT_PART0_T_TUSER      13:06
  `define CR_KME_C_CDDIP1_OUT_PART0_T_TID        14
  `define CR_KME_C_CDDIP1_OUT_PART0_T_UNUSED1    22:15
  `define CR_KME_C_CDDIP1_OUT_PART0_T_BYTES_VLD  30:23
  `define CR_KME_C_CDDIP1_OUT_PART0_T_EOB        31

`define CR_KME_CDDIP1_OUT_PART1_T_DECL   31:0
`define CR_KME_CDDIP1_OUT_PART1_T_WIDTH  32
  `define CR_KME_CDDIP1_OUT_PART1_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP1_OUT_PART1_T_TDATA_LO_DECL   31:0
`define CR_KME_CDDIP1_OUT_PART1_T_TDATA_LO_WIDTH  32
  `define CR_KME_CDDIP1_OUT_PART1_T_TDATA_LO_DEFAULT  (32'h 0)

`define CR_KME_FULL_CDDIP1_OUT_PART1_T_DECL   31:0
`define CR_KME_FULL_CDDIP1_OUT_PART1_T_WIDTH  32
  `define CR_KME_FULL_CDDIP1_OUT_PART1_T_TDATA_LO  31:00

`define CR_KME_C_CDDIP1_OUT_PART1_T_DECL   31:0
`define CR_KME_C_CDDIP1_OUT_PART1_T_WIDTH  32
  `define CR_KME_C_CDDIP1_OUT_PART1_T_TDATA_LO  31:00

`define CR_KME_CDDIP1_OUT_PART2_T_DECL   31:0
`define CR_KME_CDDIP1_OUT_PART2_T_WIDTH  32
  `define CR_KME_CDDIP1_OUT_PART2_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP1_OUT_PART2_T_TDATA_HI_DECL   31:0
`define CR_KME_CDDIP1_OUT_PART2_T_TDATA_HI_WIDTH  32
  `define CR_KME_CDDIP1_OUT_PART2_T_TDATA_HI_DEFAULT  (32'h 0)

`define CR_KME_FULL_CDDIP1_OUT_PART2_T_DECL   31:0
`define CR_KME_FULL_CDDIP1_OUT_PART2_T_WIDTH  32
  `define CR_KME_FULL_CDDIP1_OUT_PART2_T_TDATA_HI  31:00

`define CR_KME_C_CDDIP1_OUT_PART2_T_DECL   31:0
`define CR_KME_C_CDDIP1_OUT_PART2_T_WIDTH  32
  `define CR_KME_C_CDDIP1_OUT_PART2_T_TDATA_HI  31:00

`define CR_KME_CDDIP1_OUT_IA_CONFIG_T_DECL   31:0
`define CR_KME_CDDIP1_OUT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_CDDIP1_OUT_IA_CONFIG_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP1_OUT_IA_CONFIG_T_ADDR_DECL   8:0
`define CR_KME_CDDIP1_OUT_IA_CONFIG_T_ADDR_WIDTH  9
  `define CR_KME_CDDIP1_OUT_IA_CONFIG_T_ADDR_DEFAULT  (9'h 0)

`define CR_KME_CDDIP1_OUT_IA_CONFIG_T_OP_DECL   3:0
`define CR_KME_CDDIP1_OUT_IA_CONFIG_T_OP_WIDTH  4
  `define CR_KME_CDDIP1_OUT_IA_CONFIG_T_OP_DEFAULT  (4'h 0)

`define CR_KME_FULL_CDDIP1_OUT_IA_CONFIG_T_DECL   31:0
`define CR_KME_FULL_CDDIP1_OUT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_CDDIP1_OUT_IA_CONFIG_T_ADDR       08:00
  `define CR_KME_FULL_CDDIP1_OUT_IA_CONFIG_T_RESERVED0  27:09
  `define CR_KME_FULL_CDDIP1_OUT_IA_CONFIG_T_OP         31:28

`define CR_KME_C_CDDIP1_OUT_IA_CONFIG_T_DECL   12:0
`define CR_KME_C_CDDIP1_OUT_IA_CONFIG_T_WIDTH  13
  `define CR_KME_C_CDDIP1_OUT_IA_CONFIG_T_ADDR  08:00
  `define CR_KME_C_CDDIP1_OUT_IA_CONFIG_T_OP    12:09

`define CR_KME_CDDIP1_OUT_IA_STATUS_T_DECL   31:0
`define CR_KME_CDDIP1_OUT_IA_STATUS_T_WIDTH  32
  `define CR_KME_CDDIP1_OUT_IA_STATUS_T_DEFAULT  (32'h 20001ff)

`define CR_KME_CDDIP1_OUT_IA_STATUS_T_ADDR_DECL   8:0
`define CR_KME_CDDIP1_OUT_IA_STATUS_T_ADDR_WIDTH  9
  `define CR_KME_CDDIP1_OUT_IA_STATUS_T_ADDR_DEFAULT  (9'h 1ff)

`define CR_KME_CDDIP1_OUT_IA_STATUS_T_DATAWORDS_DECL   4:0
`define CR_KME_CDDIP1_OUT_IA_STATUS_T_DATAWORDS_WIDTH  5
  `define CR_KME_CDDIP1_OUT_IA_STATUS_T_DATAWORDS_DEFAULT  (5'h 2)

`define CR_KME_CDDIP1_OUT_IA_STATUS_T_CODE_DECL   2:0
`define CR_KME_CDDIP1_OUT_IA_STATUS_T_CODE_WIDTH  3
  `define CR_KME_CDDIP1_OUT_IA_STATUS_T_CODE_DEFAULT  (3'h 0)

`define CR_KME_FULL_CDDIP1_OUT_IA_STATUS_T_DECL   31:0
`define CR_KME_FULL_CDDIP1_OUT_IA_STATUS_T_WIDTH  32
  `define CR_KME_FULL_CDDIP1_OUT_IA_STATUS_T_ADDR       08:00
  `define CR_KME_FULL_CDDIP1_OUT_IA_STATUS_T_RESERVED0  23:09
  `define CR_KME_FULL_CDDIP1_OUT_IA_STATUS_T_DATAWORDS  28:24
  `define CR_KME_FULL_CDDIP1_OUT_IA_STATUS_T_CODE       31:29

`define CR_KME_C_CDDIP1_OUT_IA_STATUS_T_DECL   16:0
`define CR_KME_C_CDDIP1_OUT_IA_STATUS_T_WIDTH  17
  `define CR_KME_C_CDDIP1_OUT_IA_STATUS_T_ADDR       08:00
  `define CR_KME_C_CDDIP1_OUT_IA_STATUS_T_DATAWORDS  13:09
  `define CR_KME_C_CDDIP1_OUT_IA_STATUS_T_CODE       16:14

`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_DEFAULT  (32'b xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)

`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_NOP_DECL   0:0
`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_NOP_WIDTH  1

`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_READ_DECL   0:0
`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_READ_WIDTH  1

`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_WRITE_DECL   0:0
`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_WRITE_WIDTH  1

`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_ENABLE_DECL   0:0
`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_ENABLE_WIDTH  1

`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_DISABLED_DECL   0:0
`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_DISABLED_WIDTH  1

`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_RESET_DECL   0:0
`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_RESET_WIDTH  1

`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_INITIALIZE_DECL   0:0
`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_INITIALIZE_WIDTH  1

`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_INITIALIZE_INC_DECL   0:0
`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_INITIALIZE_INC_WIDTH  1

`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_SET_INIT_START_DECL   0:0
`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_SET_INIT_START_WIDTH  1

`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_COMPARE_DECL   0:0
`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_COMPARE_WIDTH  1

`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_RESERVED_OP_DECL   3:0
`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_RESERVED_OP_WIDTH  4

`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_SIM_TMO_DECL   0:0
`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_SIM_TMO_WIDTH  1

`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_ACK_ERROR_DECL   0:0
`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_ACK_ERROR_WIDTH  1

`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_MEM_TYPE_DECL   3:0
`define CR_KME_CDDIP1_OUT_IA_CAPABILITY_T_MEM_TYPE_WIDTH  4

`define CR_KME_FULL_CDDIP1_OUT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_FULL_CDDIP1_OUT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_FULL_CDDIP1_OUT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_FULL_CDDIP1_OUT_IA_CAPABILITY_T_READ            01
  `define CR_KME_FULL_CDDIP1_OUT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_FULL_CDDIP1_OUT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_FULL_CDDIP1_OUT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_FULL_CDDIP1_OUT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_FULL_CDDIP1_OUT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_FULL_CDDIP1_OUT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_FULL_CDDIP1_OUT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_FULL_CDDIP1_OUT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_FULL_CDDIP1_OUT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_FULL_CDDIP1_OUT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_FULL_CDDIP1_OUT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_FULL_CDDIP1_OUT_IA_CAPABILITY_T_RESERVED0       27:16
  `define CR_KME_FULL_CDDIP1_OUT_IA_CAPABILITY_T_MEM_TYPE        31:28

`define CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_DECL   19:0
`define CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_WIDTH  20
  `define CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_READ            01
  `define CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_C_CDDIP1_OUT_IA_CAPABILITY_T_MEM_TYPE        19:16

`define CR_KME_CDDIP1_OUT_IM_CONFIG_T_DECL   31:0
`define CR_KME_CDDIP1_OUT_IM_CONFIG_T_WIDTH  32
  `define CR_KME_CDDIP1_OUT_IM_CONFIG_T_DEFAULT  (32'h c0000200)

`define CR_KME_CDDIP1_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_DECL   9:0
`define CR_KME_CDDIP1_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_WIDTH  10
  `define CR_KME_CDDIP1_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_DEFAULT  (10'h 200)

`define CR_KME_CDDIP1_OUT_IM_CONFIG_T_MODE_DECL   1:0
`define CR_KME_CDDIP1_OUT_IM_CONFIG_T_MODE_WIDTH  2
  `define CR_KME_CDDIP1_OUT_IM_CONFIG_T_MODE_DEFAULT  (2'h 3)

`define CR_KME_FULL_CDDIP1_OUT_IM_CONFIG_T_DECL   31:0
`define CR_KME_FULL_CDDIP1_OUT_IM_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_CDDIP1_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG  09:00
  `define CR_KME_FULL_CDDIP1_OUT_IM_CONFIG_T_RESERVED0         29:10
  `define CR_KME_FULL_CDDIP1_OUT_IM_CONFIG_T_MODE              31:30

`define CR_KME_C_CDDIP1_OUT_IM_CONFIG_T_DECL   11:0
`define CR_KME_C_CDDIP1_OUT_IM_CONFIG_T_WIDTH  12
  `define CR_KME_C_CDDIP1_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG  09:00
  `define CR_KME_C_CDDIP1_OUT_IM_CONFIG_T_MODE              11:10

`define CR_KME_CDDIP1_OUT_IM_STATUS_T_DECL   31:0
`define CR_KME_CDDIP1_OUT_IM_STATUS_T_WIDTH  32
  `define CR_KME_CDDIP1_OUT_IM_STATUS_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP1_OUT_IM_STATUS_T_WR_POINTER_DECL   8:0
`define CR_KME_CDDIP1_OUT_IM_STATUS_T_WR_POINTER_WIDTH  9
  `define CR_KME_CDDIP1_OUT_IM_STATUS_T_WR_POINTER_DEFAULT  (9'h 0)

`define CR_KME_CDDIP1_OUT_IM_STATUS_T_OVERFLOW_DECL   0:0
`define CR_KME_CDDIP1_OUT_IM_STATUS_T_OVERFLOW_WIDTH  1
  `define CR_KME_CDDIP1_OUT_IM_STATUS_T_OVERFLOW_DEFAULT  (1'h 0)

`define CR_KME_CDDIP1_OUT_IM_STATUS_T_BANK_LO_DECL   0:0
`define CR_KME_CDDIP1_OUT_IM_STATUS_T_BANK_LO_WIDTH  1
  `define CR_KME_CDDIP1_OUT_IM_STATUS_T_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_CDDIP1_OUT_IM_STATUS_T_BANK_HI_DECL   0:0
`define CR_KME_CDDIP1_OUT_IM_STATUS_T_BANK_HI_WIDTH  1
  `define CR_KME_CDDIP1_OUT_IM_STATUS_T_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_CDDIP1_OUT_IM_STATUS_T_DECL   31:0
`define CR_KME_FULL_CDDIP1_OUT_IM_STATUS_T_WIDTH  32
  `define CR_KME_FULL_CDDIP1_OUT_IM_STATUS_T_WR_POINTER  08:00
  `define CR_KME_FULL_CDDIP1_OUT_IM_STATUS_T_RESERVED0   28:09
  `define CR_KME_FULL_CDDIP1_OUT_IM_STATUS_T_OVERFLOW    29
  `define CR_KME_FULL_CDDIP1_OUT_IM_STATUS_T_BANK_LO     30
  `define CR_KME_FULL_CDDIP1_OUT_IM_STATUS_T_BANK_HI     31

`define CR_KME_C_CDDIP1_OUT_IM_STATUS_T_DECL   11:0
`define CR_KME_C_CDDIP1_OUT_IM_STATUS_T_WIDTH  12
  `define CR_KME_C_CDDIP1_OUT_IM_STATUS_T_WR_POINTER  08:00
  `define CR_KME_C_CDDIP1_OUT_IM_STATUS_T_OVERFLOW    09
  `define CR_KME_C_CDDIP1_OUT_IM_STATUS_T_BANK_LO     10
  `define CR_KME_C_CDDIP1_OUT_IM_STATUS_T_BANK_HI     11

`define CR_KME_CDDIP1_OUT_IM_CONSUMED_T_DECL   31:0
`define CR_KME_CDDIP1_OUT_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_CDDIP1_OUT_IM_CONSUMED_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP1_OUT_IM_CONSUMED_T_BANK_LO_DECL   0:0
`define CR_KME_CDDIP1_OUT_IM_CONSUMED_T_BANK_LO_WIDTH  1
  `define CR_KME_CDDIP1_OUT_IM_CONSUMED_T_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_CDDIP1_OUT_IM_CONSUMED_T_BANK_HI_DECL   0:0
`define CR_KME_CDDIP1_OUT_IM_CONSUMED_T_BANK_HI_WIDTH  1
  `define CR_KME_CDDIP1_OUT_IM_CONSUMED_T_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_CDDIP1_OUT_IM_CONSUMED_T_DECL   31:0
`define CR_KME_FULL_CDDIP1_OUT_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_FULL_CDDIP1_OUT_IM_CONSUMED_T_RESERVED0  29:0
  `define CR_KME_FULL_CDDIP1_OUT_IM_CONSUMED_T_BANK_LO    30
  `define CR_KME_FULL_CDDIP1_OUT_IM_CONSUMED_T_BANK_HI    31

`define CR_KME_C_CDDIP1_OUT_IM_CONSUMED_T_DECL   1:0
`define CR_KME_C_CDDIP1_OUT_IM_CONSUMED_T_WIDTH  2
  `define CR_KME_C_CDDIP1_OUT_IM_CONSUMED_T_BANK_LO  0
  `define CR_KME_C_CDDIP1_OUT_IM_CONSUMED_T_BANK_HI  1

`define CR_KME_CDDIP2_OUT_PART0_T_DECL   31:0
`define CR_KME_CDDIP2_OUT_PART0_T_WIDTH  32
  `define CR_KME_CDDIP2_OUT_PART0_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP2_OUT_PART0_T_UNUSED0_DECL   5:0
`define CR_KME_CDDIP2_OUT_PART0_T_UNUSED0_WIDTH  6
  `define CR_KME_CDDIP2_OUT_PART0_T_UNUSED0_DEFAULT  (6'h 0)

`define CR_KME_CDDIP2_OUT_PART0_T_TUSER_DECL   7:0
`define CR_KME_CDDIP2_OUT_PART0_T_TUSER_WIDTH  8

`define CR_KME_CDDIP2_OUT_PART0_T_TID_DECL   0:0
`define CR_KME_CDDIP2_OUT_PART0_T_TID_WIDTH  1

`define CR_KME_CDDIP2_OUT_PART0_T_UNUSED1_DECL   7:0
`define CR_KME_CDDIP2_OUT_PART0_T_UNUSED1_WIDTH  8

`define CR_KME_CDDIP2_OUT_PART0_T_BYTES_VLD_DECL   7:0
`define CR_KME_CDDIP2_OUT_PART0_T_BYTES_VLD_WIDTH  8

`define CR_KME_CDDIP2_OUT_PART0_T_EOB_DECL   0:0
`define CR_KME_CDDIP2_OUT_PART0_T_EOB_WIDTH  1

`define CR_KME_FULL_CDDIP2_OUT_PART0_T_DECL   31:0
`define CR_KME_FULL_CDDIP2_OUT_PART0_T_WIDTH  32
  `define CR_KME_FULL_CDDIP2_OUT_PART0_T_UNUSED0    05:00
  `define CR_KME_FULL_CDDIP2_OUT_PART0_T_TUSER      13:06
  `define CR_KME_FULL_CDDIP2_OUT_PART0_T_TID        14
  `define CR_KME_FULL_CDDIP2_OUT_PART0_T_UNUSED1    22:15
  `define CR_KME_FULL_CDDIP2_OUT_PART0_T_BYTES_VLD  30:23
  `define CR_KME_FULL_CDDIP2_OUT_PART0_T_EOB        31

`define CR_KME_C_CDDIP2_OUT_PART0_T_DECL   31:0
`define CR_KME_C_CDDIP2_OUT_PART0_T_WIDTH  32
  `define CR_KME_C_CDDIP2_OUT_PART0_T_UNUSED0    05:00
  `define CR_KME_C_CDDIP2_OUT_PART0_T_TUSER      13:06
  `define CR_KME_C_CDDIP2_OUT_PART0_T_TID        14
  `define CR_KME_C_CDDIP2_OUT_PART0_T_UNUSED1    22:15
  `define CR_KME_C_CDDIP2_OUT_PART0_T_BYTES_VLD  30:23
  `define CR_KME_C_CDDIP2_OUT_PART0_T_EOB        31

`define CR_KME_CDDIP2_OUT_PART1_T_DECL   31:0
`define CR_KME_CDDIP2_OUT_PART1_T_WIDTH  32
  `define CR_KME_CDDIP2_OUT_PART1_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP2_OUT_PART1_T_TDATA_LO_DECL   31:0
`define CR_KME_CDDIP2_OUT_PART1_T_TDATA_LO_WIDTH  32
  `define CR_KME_CDDIP2_OUT_PART1_T_TDATA_LO_DEFAULT  (32'h 0)

`define CR_KME_FULL_CDDIP2_OUT_PART1_T_DECL   31:0
`define CR_KME_FULL_CDDIP2_OUT_PART1_T_WIDTH  32
  `define CR_KME_FULL_CDDIP2_OUT_PART1_T_TDATA_LO  31:00

`define CR_KME_C_CDDIP2_OUT_PART1_T_DECL   31:0
`define CR_KME_C_CDDIP2_OUT_PART1_T_WIDTH  32
  `define CR_KME_C_CDDIP2_OUT_PART1_T_TDATA_LO  31:00

`define CR_KME_CDDIP2_OUT_PART2_T_DECL   31:0
`define CR_KME_CDDIP2_OUT_PART2_T_WIDTH  32
  `define CR_KME_CDDIP2_OUT_PART2_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP2_OUT_PART2_T_TDATA_HI_DECL   31:0
`define CR_KME_CDDIP2_OUT_PART2_T_TDATA_HI_WIDTH  32
  `define CR_KME_CDDIP2_OUT_PART2_T_TDATA_HI_DEFAULT  (32'h 0)

`define CR_KME_FULL_CDDIP2_OUT_PART2_T_DECL   31:0
`define CR_KME_FULL_CDDIP2_OUT_PART2_T_WIDTH  32
  `define CR_KME_FULL_CDDIP2_OUT_PART2_T_TDATA_HI  31:00

`define CR_KME_C_CDDIP2_OUT_PART2_T_DECL   31:0
`define CR_KME_C_CDDIP2_OUT_PART2_T_WIDTH  32
  `define CR_KME_C_CDDIP2_OUT_PART2_T_TDATA_HI  31:00

`define CR_KME_CDDIP2_OUT_IA_CONFIG_T_DECL   31:0
`define CR_KME_CDDIP2_OUT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_CDDIP2_OUT_IA_CONFIG_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP2_OUT_IA_CONFIG_T_ADDR_DECL   8:0
`define CR_KME_CDDIP2_OUT_IA_CONFIG_T_ADDR_WIDTH  9
  `define CR_KME_CDDIP2_OUT_IA_CONFIG_T_ADDR_DEFAULT  (9'h 0)

`define CR_KME_CDDIP2_OUT_IA_CONFIG_T_OP_DECL   3:0
`define CR_KME_CDDIP2_OUT_IA_CONFIG_T_OP_WIDTH  4
  `define CR_KME_CDDIP2_OUT_IA_CONFIG_T_OP_DEFAULT  (4'h 0)

`define CR_KME_FULL_CDDIP2_OUT_IA_CONFIG_T_DECL   31:0
`define CR_KME_FULL_CDDIP2_OUT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_CDDIP2_OUT_IA_CONFIG_T_ADDR       08:00
  `define CR_KME_FULL_CDDIP2_OUT_IA_CONFIG_T_RESERVED0  27:09
  `define CR_KME_FULL_CDDIP2_OUT_IA_CONFIG_T_OP         31:28

`define CR_KME_C_CDDIP2_OUT_IA_CONFIG_T_DECL   12:0
`define CR_KME_C_CDDIP2_OUT_IA_CONFIG_T_WIDTH  13
  `define CR_KME_C_CDDIP2_OUT_IA_CONFIG_T_ADDR  08:00
  `define CR_KME_C_CDDIP2_OUT_IA_CONFIG_T_OP    12:09

`define CR_KME_CDDIP2_OUT_IA_STATUS_T_DECL   31:0
`define CR_KME_CDDIP2_OUT_IA_STATUS_T_WIDTH  32
  `define CR_KME_CDDIP2_OUT_IA_STATUS_T_DEFAULT  (32'h 20001ff)

`define CR_KME_CDDIP2_OUT_IA_STATUS_T_ADDR_DECL   8:0
`define CR_KME_CDDIP2_OUT_IA_STATUS_T_ADDR_WIDTH  9
  `define CR_KME_CDDIP2_OUT_IA_STATUS_T_ADDR_DEFAULT  (9'h 1ff)

`define CR_KME_CDDIP2_OUT_IA_STATUS_T_DATAWORDS_DECL   4:0
`define CR_KME_CDDIP2_OUT_IA_STATUS_T_DATAWORDS_WIDTH  5
  `define CR_KME_CDDIP2_OUT_IA_STATUS_T_DATAWORDS_DEFAULT  (5'h 2)

`define CR_KME_CDDIP2_OUT_IA_STATUS_T_CODE_DECL   2:0
`define CR_KME_CDDIP2_OUT_IA_STATUS_T_CODE_WIDTH  3
  `define CR_KME_CDDIP2_OUT_IA_STATUS_T_CODE_DEFAULT  (3'h 0)

`define CR_KME_FULL_CDDIP2_OUT_IA_STATUS_T_DECL   31:0
`define CR_KME_FULL_CDDIP2_OUT_IA_STATUS_T_WIDTH  32
  `define CR_KME_FULL_CDDIP2_OUT_IA_STATUS_T_ADDR       08:00
  `define CR_KME_FULL_CDDIP2_OUT_IA_STATUS_T_RESERVED0  23:09
  `define CR_KME_FULL_CDDIP2_OUT_IA_STATUS_T_DATAWORDS  28:24
  `define CR_KME_FULL_CDDIP2_OUT_IA_STATUS_T_CODE       31:29

`define CR_KME_C_CDDIP2_OUT_IA_STATUS_T_DECL   16:0
`define CR_KME_C_CDDIP2_OUT_IA_STATUS_T_WIDTH  17
  `define CR_KME_C_CDDIP2_OUT_IA_STATUS_T_ADDR       08:00
  `define CR_KME_C_CDDIP2_OUT_IA_STATUS_T_DATAWORDS  13:09
  `define CR_KME_C_CDDIP2_OUT_IA_STATUS_T_CODE       16:14

`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_DEFAULT  (32'b xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)

`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_NOP_DECL   0:0
`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_NOP_WIDTH  1

`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_READ_DECL   0:0
`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_READ_WIDTH  1

`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_WRITE_DECL   0:0
`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_WRITE_WIDTH  1

`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_ENABLE_DECL   0:0
`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_ENABLE_WIDTH  1

`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_DISABLED_DECL   0:0
`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_DISABLED_WIDTH  1

`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_RESET_DECL   0:0
`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_RESET_WIDTH  1

`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_INITIALIZE_DECL   0:0
`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_INITIALIZE_WIDTH  1

`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_INITIALIZE_INC_DECL   0:0
`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_INITIALIZE_INC_WIDTH  1

`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_SET_INIT_START_DECL   0:0
`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_SET_INIT_START_WIDTH  1

`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_COMPARE_DECL   0:0
`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_COMPARE_WIDTH  1

`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_RESERVED_OP_DECL   3:0
`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_RESERVED_OP_WIDTH  4

`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_SIM_TMO_DECL   0:0
`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_SIM_TMO_WIDTH  1

`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_ACK_ERROR_DECL   0:0
`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_ACK_ERROR_WIDTH  1

`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_MEM_TYPE_DECL   3:0
`define CR_KME_CDDIP2_OUT_IA_CAPABILITY_T_MEM_TYPE_WIDTH  4

`define CR_KME_FULL_CDDIP2_OUT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_FULL_CDDIP2_OUT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_FULL_CDDIP2_OUT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_FULL_CDDIP2_OUT_IA_CAPABILITY_T_READ            01
  `define CR_KME_FULL_CDDIP2_OUT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_FULL_CDDIP2_OUT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_FULL_CDDIP2_OUT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_FULL_CDDIP2_OUT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_FULL_CDDIP2_OUT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_FULL_CDDIP2_OUT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_FULL_CDDIP2_OUT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_FULL_CDDIP2_OUT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_FULL_CDDIP2_OUT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_FULL_CDDIP2_OUT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_FULL_CDDIP2_OUT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_FULL_CDDIP2_OUT_IA_CAPABILITY_T_RESERVED0       27:16
  `define CR_KME_FULL_CDDIP2_OUT_IA_CAPABILITY_T_MEM_TYPE        31:28

`define CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_DECL   19:0
`define CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_WIDTH  20
  `define CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_READ            01
  `define CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_C_CDDIP2_OUT_IA_CAPABILITY_T_MEM_TYPE        19:16

`define CR_KME_CDDIP2_OUT_IM_CONFIG_T_DECL   31:0
`define CR_KME_CDDIP2_OUT_IM_CONFIG_T_WIDTH  32
  `define CR_KME_CDDIP2_OUT_IM_CONFIG_T_DEFAULT  (32'h c0000200)

`define CR_KME_CDDIP2_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_DECL   9:0
`define CR_KME_CDDIP2_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_WIDTH  10
  `define CR_KME_CDDIP2_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_DEFAULT  (10'h 200)

`define CR_KME_CDDIP2_OUT_IM_CONFIG_T_MODE_DECL   1:0
`define CR_KME_CDDIP2_OUT_IM_CONFIG_T_MODE_WIDTH  2
  `define CR_KME_CDDIP2_OUT_IM_CONFIG_T_MODE_DEFAULT  (2'h 3)

`define CR_KME_FULL_CDDIP2_OUT_IM_CONFIG_T_DECL   31:0
`define CR_KME_FULL_CDDIP2_OUT_IM_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_CDDIP2_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG  09:00
  `define CR_KME_FULL_CDDIP2_OUT_IM_CONFIG_T_RESERVED0         29:10
  `define CR_KME_FULL_CDDIP2_OUT_IM_CONFIG_T_MODE              31:30

`define CR_KME_C_CDDIP2_OUT_IM_CONFIG_T_DECL   11:0
`define CR_KME_C_CDDIP2_OUT_IM_CONFIG_T_WIDTH  12
  `define CR_KME_C_CDDIP2_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG  09:00
  `define CR_KME_C_CDDIP2_OUT_IM_CONFIG_T_MODE              11:10

`define CR_KME_CDDIP2_OUT_IM_STATUS_T_DECL   31:0
`define CR_KME_CDDIP2_OUT_IM_STATUS_T_WIDTH  32
  `define CR_KME_CDDIP2_OUT_IM_STATUS_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP2_OUT_IM_STATUS_T_WR_POINTER_DECL   8:0
`define CR_KME_CDDIP2_OUT_IM_STATUS_T_WR_POINTER_WIDTH  9
  `define CR_KME_CDDIP2_OUT_IM_STATUS_T_WR_POINTER_DEFAULT  (9'h 0)

`define CR_KME_CDDIP2_OUT_IM_STATUS_T_OVERFLOW_DECL   0:0
`define CR_KME_CDDIP2_OUT_IM_STATUS_T_OVERFLOW_WIDTH  1
  `define CR_KME_CDDIP2_OUT_IM_STATUS_T_OVERFLOW_DEFAULT  (1'h 0)

`define CR_KME_CDDIP2_OUT_IM_STATUS_T_BANK_LO_DECL   0:0
`define CR_KME_CDDIP2_OUT_IM_STATUS_T_BANK_LO_WIDTH  1
  `define CR_KME_CDDIP2_OUT_IM_STATUS_T_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_CDDIP2_OUT_IM_STATUS_T_BANK_HI_DECL   0:0
`define CR_KME_CDDIP2_OUT_IM_STATUS_T_BANK_HI_WIDTH  1
  `define CR_KME_CDDIP2_OUT_IM_STATUS_T_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_CDDIP2_OUT_IM_STATUS_T_DECL   31:0
`define CR_KME_FULL_CDDIP2_OUT_IM_STATUS_T_WIDTH  32
  `define CR_KME_FULL_CDDIP2_OUT_IM_STATUS_T_WR_POINTER  08:00
  `define CR_KME_FULL_CDDIP2_OUT_IM_STATUS_T_RESERVED0   28:09
  `define CR_KME_FULL_CDDIP2_OUT_IM_STATUS_T_OVERFLOW    29
  `define CR_KME_FULL_CDDIP2_OUT_IM_STATUS_T_BANK_LO     30
  `define CR_KME_FULL_CDDIP2_OUT_IM_STATUS_T_BANK_HI     31

`define CR_KME_C_CDDIP2_OUT_IM_STATUS_T_DECL   11:0
`define CR_KME_C_CDDIP2_OUT_IM_STATUS_T_WIDTH  12
  `define CR_KME_C_CDDIP2_OUT_IM_STATUS_T_WR_POINTER  08:00
  `define CR_KME_C_CDDIP2_OUT_IM_STATUS_T_OVERFLOW    09
  `define CR_KME_C_CDDIP2_OUT_IM_STATUS_T_BANK_LO     10
  `define CR_KME_C_CDDIP2_OUT_IM_STATUS_T_BANK_HI     11

`define CR_KME_CDDIP2_OUT_IM_CONSUMED_T_DECL   31:0
`define CR_KME_CDDIP2_OUT_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_CDDIP2_OUT_IM_CONSUMED_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP2_OUT_IM_CONSUMED_T_BANK_LO_DECL   0:0
`define CR_KME_CDDIP2_OUT_IM_CONSUMED_T_BANK_LO_WIDTH  1
  `define CR_KME_CDDIP2_OUT_IM_CONSUMED_T_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_CDDIP2_OUT_IM_CONSUMED_T_BANK_HI_DECL   0:0
`define CR_KME_CDDIP2_OUT_IM_CONSUMED_T_BANK_HI_WIDTH  1
  `define CR_KME_CDDIP2_OUT_IM_CONSUMED_T_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_CDDIP2_OUT_IM_CONSUMED_T_DECL   31:0
`define CR_KME_FULL_CDDIP2_OUT_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_FULL_CDDIP2_OUT_IM_CONSUMED_T_RESERVED0  29:0
  `define CR_KME_FULL_CDDIP2_OUT_IM_CONSUMED_T_BANK_LO    30
  `define CR_KME_FULL_CDDIP2_OUT_IM_CONSUMED_T_BANK_HI    31

`define CR_KME_C_CDDIP2_OUT_IM_CONSUMED_T_DECL   1:0
`define CR_KME_C_CDDIP2_OUT_IM_CONSUMED_T_WIDTH  2
  `define CR_KME_C_CDDIP2_OUT_IM_CONSUMED_T_BANK_LO  0
  `define CR_KME_C_CDDIP2_OUT_IM_CONSUMED_T_BANK_HI  1

`define CR_KME_CDDIP3_OUT_PART0_T_DECL   31:0
`define CR_KME_CDDIP3_OUT_PART0_T_WIDTH  32
  `define CR_KME_CDDIP3_OUT_PART0_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP3_OUT_PART0_T_UNUSED0_DECL   5:0
`define CR_KME_CDDIP3_OUT_PART0_T_UNUSED0_WIDTH  6
  `define CR_KME_CDDIP3_OUT_PART0_T_UNUSED0_DEFAULT  (6'h 0)

`define CR_KME_CDDIP3_OUT_PART0_T_TUSER_DECL   7:0
`define CR_KME_CDDIP3_OUT_PART0_T_TUSER_WIDTH  8

`define CR_KME_CDDIP3_OUT_PART0_T_TID_DECL   0:0
`define CR_KME_CDDIP3_OUT_PART0_T_TID_WIDTH  1

`define CR_KME_CDDIP3_OUT_PART0_T_UNUSED1_DECL   7:0
`define CR_KME_CDDIP3_OUT_PART0_T_UNUSED1_WIDTH  8

`define CR_KME_CDDIP3_OUT_PART0_T_BYTES_VLD_DECL   7:0
`define CR_KME_CDDIP3_OUT_PART0_T_BYTES_VLD_WIDTH  8

`define CR_KME_CDDIP3_OUT_PART0_T_EOB_DECL   0:0
`define CR_KME_CDDIP3_OUT_PART0_T_EOB_WIDTH  1

`define CR_KME_FULL_CDDIP3_OUT_PART0_T_DECL   31:0
`define CR_KME_FULL_CDDIP3_OUT_PART0_T_WIDTH  32
  `define CR_KME_FULL_CDDIP3_OUT_PART0_T_UNUSED0    05:00
  `define CR_KME_FULL_CDDIP3_OUT_PART0_T_TUSER      13:06
  `define CR_KME_FULL_CDDIP3_OUT_PART0_T_TID        14
  `define CR_KME_FULL_CDDIP3_OUT_PART0_T_UNUSED1    22:15
  `define CR_KME_FULL_CDDIP3_OUT_PART0_T_BYTES_VLD  30:23
  `define CR_KME_FULL_CDDIP3_OUT_PART0_T_EOB        31

`define CR_KME_C_CDDIP3_OUT_PART0_T_DECL   31:0
`define CR_KME_C_CDDIP3_OUT_PART0_T_WIDTH  32
  `define CR_KME_C_CDDIP3_OUT_PART0_T_UNUSED0    05:00
  `define CR_KME_C_CDDIP3_OUT_PART0_T_TUSER      13:06
  `define CR_KME_C_CDDIP3_OUT_PART0_T_TID        14
  `define CR_KME_C_CDDIP3_OUT_PART0_T_UNUSED1    22:15
  `define CR_KME_C_CDDIP3_OUT_PART0_T_BYTES_VLD  30:23
  `define CR_KME_C_CDDIP3_OUT_PART0_T_EOB        31

`define CR_KME_CDDIP3_OUT_PART1_T_DECL   31:0
`define CR_KME_CDDIP3_OUT_PART1_T_WIDTH  32
  `define CR_KME_CDDIP3_OUT_PART1_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP3_OUT_PART1_T_TDATA_LO_DECL   31:0
`define CR_KME_CDDIP3_OUT_PART1_T_TDATA_LO_WIDTH  32
  `define CR_KME_CDDIP3_OUT_PART1_T_TDATA_LO_DEFAULT  (32'h 0)

`define CR_KME_FULL_CDDIP3_OUT_PART1_T_DECL   31:0
`define CR_KME_FULL_CDDIP3_OUT_PART1_T_WIDTH  32
  `define CR_KME_FULL_CDDIP3_OUT_PART1_T_TDATA_LO  31:00

`define CR_KME_C_CDDIP3_OUT_PART1_T_DECL   31:0
`define CR_KME_C_CDDIP3_OUT_PART1_T_WIDTH  32
  `define CR_KME_C_CDDIP3_OUT_PART1_T_TDATA_LO  31:00

`define CR_KME_CDDIP3_OUT_PART2_T_DECL   31:0
`define CR_KME_CDDIP3_OUT_PART2_T_WIDTH  32
  `define CR_KME_CDDIP3_OUT_PART2_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP3_OUT_PART2_T_TDATA_HI_DECL   31:0
`define CR_KME_CDDIP3_OUT_PART2_T_TDATA_HI_WIDTH  32
  `define CR_KME_CDDIP3_OUT_PART2_T_TDATA_HI_DEFAULT  (32'h 0)

`define CR_KME_FULL_CDDIP3_OUT_PART2_T_DECL   31:0
`define CR_KME_FULL_CDDIP3_OUT_PART2_T_WIDTH  32
  `define CR_KME_FULL_CDDIP3_OUT_PART2_T_TDATA_HI  31:00

`define CR_KME_C_CDDIP3_OUT_PART2_T_DECL   31:0
`define CR_KME_C_CDDIP3_OUT_PART2_T_WIDTH  32
  `define CR_KME_C_CDDIP3_OUT_PART2_T_TDATA_HI  31:00

`define CR_KME_CDDIP3_OUT_IA_CONFIG_T_DECL   31:0
`define CR_KME_CDDIP3_OUT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_CDDIP3_OUT_IA_CONFIG_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP3_OUT_IA_CONFIG_T_ADDR_DECL   8:0
`define CR_KME_CDDIP3_OUT_IA_CONFIG_T_ADDR_WIDTH  9
  `define CR_KME_CDDIP3_OUT_IA_CONFIG_T_ADDR_DEFAULT  (9'h 0)

`define CR_KME_CDDIP3_OUT_IA_CONFIG_T_OP_DECL   3:0
`define CR_KME_CDDIP3_OUT_IA_CONFIG_T_OP_WIDTH  4
  `define CR_KME_CDDIP3_OUT_IA_CONFIG_T_OP_DEFAULT  (4'h 0)

`define CR_KME_FULL_CDDIP3_OUT_IA_CONFIG_T_DECL   31:0
`define CR_KME_FULL_CDDIP3_OUT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_CDDIP3_OUT_IA_CONFIG_T_ADDR       08:00
  `define CR_KME_FULL_CDDIP3_OUT_IA_CONFIG_T_RESERVED0  27:09
  `define CR_KME_FULL_CDDIP3_OUT_IA_CONFIG_T_OP         31:28

`define CR_KME_C_CDDIP3_OUT_IA_CONFIG_T_DECL   12:0
`define CR_KME_C_CDDIP3_OUT_IA_CONFIG_T_WIDTH  13
  `define CR_KME_C_CDDIP3_OUT_IA_CONFIG_T_ADDR  08:00
  `define CR_KME_C_CDDIP3_OUT_IA_CONFIG_T_OP    12:09

`define CR_KME_CDDIP3_OUT_IA_STATUS_T_DECL   31:0
`define CR_KME_CDDIP3_OUT_IA_STATUS_T_WIDTH  32
  `define CR_KME_CDDIP3_OUT_IA_STATUS_T_DEFAULT  (32'h 20001ff)

`define CR_KME_CDDIP3_OUT_IA_STATUS_T_ADDR_DECL   8:0
`define CR_KME_CDDIP3_OUT_IA_STATUS_T_ADDR_WIDTH  9
  `define CR_KME_CDDIP3_OUT_IA_STATUS_T_ADDR_DEFAULT  (9'h 1ff)

`define CR_KME_CDDIP3_OUT_IA_STATUS_T_DATAWORDS_DECL   4:0
`define CR_KME_CDDIP3_OUT_IA_STATUS_T_DATAWORDS_WIDTH  5
  `define CR_KME_CDDIP3_OUT_IA_STATUS_T_DATAWORDS_DEFAULT  (5'h 2)

`define CR_KME_CDDIP3_OUT_IA_STATUS_T_CODE_DECL   2:0
`define CR_KME_CDDIP3_OUT_IA_STATUS_T_CODE_WIDTH  3
  `define CR_KME_CDDIP3_OUT_IA_STATUS_T_CODE_DEFAULT  (3'h 0)

`define CR_KME_FULL_CDDIP3_OUT_IA_STATUS_T_DECL   31:0
`define CR_KME_FULL_CDDIP3_OUT_IA_STATUS_T_WIDTH  32
  `define CR_KME_FULL_CDDIP3_OUT_IA_STATUS_T_ADDR       08:00
  `define CR_KME_FULL_CDDIP3_OUT_IA_STATUS_T_RESERVED0  23:09
  `define CR_KME_FULL_CDDIP3_OUT_IA_STATUS_T_DATAWORDS  28:24
  `define CR_KME_FULL_CDDIP3_OUT_IA_STATUS_T_CODE       31:29

`define CR_KME_C_CDDIP3_OUT_IA_STATUS_T_DECL   16:0
`define CR_KME_C_CDDIP3_OUT_IA_STATUS_T_WIDTH  17
  `define CR_KME_C_CDDIP3_OUT_IA_STATUS_T_ADDR       08:00
  `define CR_KME_C_CDDIP3_OUT_IA_STATUS_T_DATAWORDS  13:09
  `define CR_KME_C_CDDIP3_OUT_IA_STATUS_T_CODE       16:14

`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_DEFAULT  (32'b xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)

`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_NOP_DECL   0:0
`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_NOP_WIDTH  1

`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_READ_DECL   0:0
`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_READ_WIDTH  1

`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_WRITE_DECL   0:0
`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_WRITE_WIDTH  1

`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_ENABLE_DECL   0:0
`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_ENABLE_WIDTH  1

`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_DISABLED_DECL   0:0
`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_DISABLED_WIDTH  1

`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_RESET_DECL   0:0
`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_RESET_WIDTH  1

`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_INITIALIZE_DECL   0:0
`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_INITIALIZE_WIDTH  1

`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_INITIALIZE_INC_DECL   0:0
`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_INITIALIZE_INC_WIDTH  1

`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_SET_INIT_START_DECL   0:0
`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_SET_INIT_START_WIDTH  1

`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_COMPARE_DECL   0:0
`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_COMPARE_WIDTH  1

`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_RESERVED_OP_DECL   3:0
`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_RESERVED_OP_WIDTH  4

`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_SIM_TMO_DECL   0:0
`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_SIM_TMO_WIDTH  1

`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_ACK_ERROR_DECL   0:0
`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_ACK_ERROR_WIDTH  1

`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_MEM_TYPE_DECL   3:0
`define CR_KME_CDDIP3_OUT_IA_CAPABILITY_T_MEM_TYPE_WIDTH  4

`define CR_KME_FULL_CDDIP3_OUT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_FULL_CDDIP3_OUT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_FULL_CDDIP3_OUT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_FULL_CDDIP3_OUT_IA_CAPABILITY_T_READ            01
  `define CR_KME_FULL_CDDIP3_OUT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_FULL_CDDIP3_OUT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_FULL_CDDIP3_OUT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_FULL_CDDIP3_OUT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_FULL_CDDIP3_OUT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_FULL_CDDIP3_OUT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_FULL_CDDIP3_OUT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_FULL_CDDIP3_OUT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_FULL_CDDIP3_OUT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_FULL_CDDIP3_OUT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_FULL_CDDIP3_OUT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_FULL_CDDIP3_OUT_IA_CAPABILITY_T_RESERVED0       27:16
  `define CR_KME_FULL_CDDIP3_OUT_IA_CAPABILITY_T_MEM_TYPE        31:28

`define CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_DECL   19:0
`define CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_WIDTH  20
  `define CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_READ            01
  `define CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_C_CDDIP3_OUT_IA_CAPABILITY_T_MEM_TYPE        19:16

`define CR_KME_CDDIP3_OUT_IM_CONFIG_T_DECL   31:0
`define CR_KME_CDDIP3_OUT_IM_CONFIG_T_WIDTH  32
  `define CR_KME_CDDIP3_OUT_IM_CONFIG_T_DEFAULT  (32'h c0000200)

`define CR_KME_CDDIP3_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_DECL   9:0
`define CR_KME_CDDIP3_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_WIDTH  10
  `define CR_KME_CDDIP3_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG_DEFAULT  (10'h 200)

`define CR_KME_CDDIP3_OUT_IM_CONFIG_T_MODE_DECL   1:0
`define CR_KME_CDDIP3_OUT_IM_CONFIG_T_MODE_WIDTH  2
  `define CR_KME_CDDIP3_OUT_IM_CONFIG_T_MODE_DEFAULT  (2'h 3)

`define CR_KME_FULL_CDDIP3_OUT_IM_CONFIG_T_DECL   31:0
`define CR_KME_FULL_CDDIP3_OUT_IM_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_CDDIP3_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG  09:00
  `define CR_KME_FULL_CDDIP3_OUT_IM_CONFIG_T_RESERVED0         29:10
  `define CR_KME_FULL_CDDIP3_OUT_IM_CONFIG_T_MODE              31:30

`define CR_KME_C_CDDIP3_OUT_IM_CONFIG_T_DECL   11:0
`define CR_KME_C_CDDIP3_OUT_IM_CONFIG_T_WIDTH  12
  `define CR_KME_C_CDDIP3_OUT_IM_CONFIG_T_WR_CREDIT_CONFIG  09:00
  `define CR_KME_C_CDDIP3_OUT_IM_CONFIG_T_MODE              11:10

`define CR_KME_CDDIP3_OUT_IM_STATUS_T_DECL   31:0
`define CR_KME_CDDIP3_OUT_IM_STATUS_T_WIDTH  32
  `define CR_KME_CDDIP3_OUT_IM_STATUS_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP3_OUT_IM_STATUS_T_WR_POINTER_DECL   8:0
`define CR_KME_CDDIP3_OUT_IM_STATUS_T_WR_POINTER_WIDTH  9
  `define CR_KME_CDDIP3_OUT_IM_STATUS_T_WR_POINTER_DEFAULT  (9'h 0)

`define CR_KME_CDDIP3_OUT_IM_STATUS_T_OVERFLOW_DECL   0:0
`define CR_KME_CDDIP3_OUT_IM_STATUS_T_OVERFLOW_WIDTH  1
  `define CR_KME_CDDIP3_OUT_IM_STATUS_T_OVERFLOW_DEFAULT  (1'h 0)

`define CR_KME_CDDIP3_OUT_IM_STATUS_T_BANK_LO_DECL   0:0
`define CR_KME_CDDIP3_OUT_IM_STATUS_T_BANK_LO_WIDTH  1
  `define CR_KME_CDDIP3_OUT_IM_STATUS_T_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_CDDIP3_OUT_IM_STATUS_T_BANK_HI_DECL   0:0
`define CR_KME_CDDIP3_OUT_IM_STATUS_T_BANK_HI_WIDTH  1
  `define CR_KME_CDDIP3_OUT_IM_STATUS_T_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_CDDIP3_OUT_IM_STATUS_T_DECL   31:0
`define CR_KME_FULL_CDDIP3_OUT_IM_STATUS_T_WIDTH  32
  `define CR_KME_FULL_CDDIP3_OUT_IM_STATUS_T_WR_POINTER  08:00
  `define CR_KME_FULL_CDDIP3_OUT_IM_STATUS_T_RESERVED0   28:09
  `define CR_KME_FULL_CDDIP3_OUT_IM_STATUS_T_OVERFLOW    29
  `define CR_KME_FULL_CDDIP3_OUT_IM_STATUS_T_BANK_LO     30
  `define CR_KME_FULL_CDDIP3_OUT_IM_STATUS_T_BANK_HI     31

`define CR_KME_C_CDDIP3_OUT_IM_STATUS_T_DECL   11:0
`define CR_KME_C_CDDIP3_OUT_IM_STATUS_T_WIDTH  12
  `define CR_KME_C_CDDIP3_OUT_IM_STATUS_T_WR_POINTER  08:00
  `define CR_KME_C_CDDIP3_OUT_IM_STATUS_T_OVERFLOW    09
  `define CR_KME_C_CDDIP3_OUT_IM_STATUS_T_BANK_LO     10
  `define CR_KME_C_CDDIP3_OUT_IM_STATUS_T_BANK_HI     11

`define CR_KME_CDDIP3_OUT_IM_CONSUMED_T_DECL   31:0
`define CR_KME_CDDIP3_OUT_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_CDDIP3_OUT_IM_CONSUMED_T_DEFAULT  (32'h 0)

`define CR_KME_CDDIP3_OUT_IM_CONSUMED_T_BANK_LO_DECL   0:0
`define CR_KME_CDDIP3_OUT_IM_CONSUMED_T_BANK_LO_WIDTH  1
  `define CR_KME_CDDIP3_OUT_IM_CONSUMED_T_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_CDDIP3_OUT_IM_CONSUMED_T_BANK_HI_DECL   0:0
`define CR_KME_CDDIP3_OUT_IM_CONSUMED_T_BANK_HI_WIDTH  1
  `define CR_KME_CDDIP3_OUT_IM_CONSUMED_T_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_CDDIP3_OUT_IM_CONSUMED_T_DECL   31:0
`define CR_KME_FULL_CDDIP3_OUT_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_FULL_CDDIP3_OUT_IM_CONSUMED_T_RESERVED0  29:0
  `define CR_KME_FULL_CDDIP3_OUT_IM_CONSUMED_T_BANK_LO    30
  `define CR_KME_FULL_CDDIP3_OUT_IM_CONSUMED_T_BANK_HI    31

`define CR_KME_C_CDDIP3_OUT_IM_CONSUMED_T_DECL   1:0
`define CR_KME_C_CDDIP3_OUT_IM_CONSUMED_T_WIDTH  2
  `define CR_KME_C_CDDIP3_OUT_IM_CONSUMED_T_BANK_LO  0
  `define CR_KME_C_CDDIP3_OUT_IM_CONSUMED_T_BANK_HI  1

`define CR_KME_CKV_PART1_T_DECL   31:0
`define CR_KME_CKV_PART1_T_WIDTH  32
  `define CR_KME_CKV_PART1_T_DEFAULT  (32'h 0)

`define CR_KME_CKV_PART1_T_KEY1_DECL   31:0
`define CR_KME_CKV_PART1_T_KEY1_WIDTH  32
  `define CR_KME_CKV_PART1_T_KEY1_DEFAULT  (32'h 0)

`define CR_KME_FULL_CKV_PART1_T_DECL   31:0
`define CR_KME_FULL_CKV_PART1_T_WIDTH  32
  `define CR_KME_FULL_CKV_PART1_T_KEY1  31:00

`define CR_KME_C_CKV_PART1_T_DECL   31:0
`define CR_KME_C_CKV_PART1_T_WIDTH  32
  `define CR_KME_C_CKV_PART1_T_KEY1  31:00

`define CR_KME_CKV_PART0_T_DECL   31:0
`define CR_KME_CKV_PART0_T_WIDTH  32
  `define CR_KME_CKV_PART0_T_DEFAULT  (32'h 0)

`define CR_KME_CKV_PART0_T_KEY0_DECL   31:0
`define CR_KME_CKV_PART0_T_KEY0_WIDTH  32
  `define CR_KME_CKV_PART0_T_KEY0_DEFAULT  (32'h 0)

`define CR_KME_FULL_CKV_PART0_T_DECL   31:0
`define CR_KME_FULL_CKV_PART0_T_WIDTH  32
  `define CR_KME_FULL_CKV_PART0_T_KEY0  31:00

`define CR_KME_C_CKV_PART0_T_DECL   31:0
`define CR_KME_C_CKV_PART0_T_WIDTH  32
  `define CR_KME_C_CKV_PART0_T_KEY0  31:00

`define CR_KME_CKV_IA_CONFIG_T_DECL   31:0
`define CR_KME_CKV_IA_CONFIG_T_WIDTH  32
  `define CR_KME_CKV_IA_CONFIG_T_DEFAULT  (32'h 0)

`define CR_KME_CKV_IA_CONFIG_T_ADDR_DECL   14:0
`define CR_KME_CKV_IA_CONFIG_T_ADDR_WIDTH  15
  `define CR_KME_CKV_IA_CONFIG_T_ADDR_DEFAULT  (15'h 0)

`define CR_KME_CKV_IA_CONFIG_T_OP_DECL   3:0
`define CR_KME_CKV_IA_CONFIG_T_OP_WIDTH  4
  `define CR_KME_CKV_IA_CONFIG_T_OP_DEFAULT  (4'h 0)

`define CR_KME_FULL_CKV_IA_CONFIG_T_DECL   31:0
`define CR_KME_FULL_CKV_IA_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_CKV_IA_CONFIG_T_ADDR       14:00
  `define CR_KME_FULL_CKV_IA_CONFIG_T_RESERVED0  27:15
  `define CR_KME_FULL_CKV_IA_CONFIG_T_OP         31:28

`define CR_KME_C_CKV_IA_CONFIG_T_DECL   18:0
`define CR_KME_C_CKV_IA_CONFIG_T_WIDTH  19
  `define CR_KME_C_CKV_IA_CONFIG_T_ADDR  14:00
  `define CR_KME_C_CKV_IA_CONFIG_T_OP    18:15

`define CR_KME_CKV_IA_STATUS_T_DECL   31:0
`define CR_KME_CKV_IA_STATUS_T_WIDTH  32
  `define CR_KME_CKV_IA_STATUS_T_DEFAULT  (32'h e1000000)

`define CR_KME_CKV_IA_STATUS_T_ADDR_DECL   14:0
`define CR_KME_CKV_IA_STATUS_T_ADDR_WIDTH  15
  `define CR_KME_CKV_IA_STATUS_T_ADDR_DEFAULT  (15'h 0)

`define CR_KME_CKV_IA_STATUS_T_DATAWORDS_DECL   4:0
`define CR_KME_CKV_IA_STATUS_T_DATAWORDS_WIDTH  5
  `define CR_KME_CKV_IA_STATUS_T_DATAWORDS_DEFAULT  (5'h 1)

`define CR_KME_CKV_IA_STATUS_T_CODE_DECL   2:0
`define CR_KME_CKV_IA_STATUS_T_CODE_WIDTH  3
  `define CR_KME_CKV_IA_STATUS_T_CODE_DEFAULT  (3'h 7)

`define CR_KME_FULL_CKV_IA_STATUS_T_DECL   31:0
`define CR_KME_FULL_CKV_IA_STATUS_T_WIDTH  32
  `define CR_KME_FULL_CKV_IA_STATUS_T_ADDR       14:00
  `define CR_KME_FULL_CKV_IA_STATUS_T_RESERVED0  23:15
  `define CR_KME_FULL_CKV_IA_STATUS_T_DATAWORDS  28:24
  `define CR_KME_FULL_CKV_IA_STATUS_T_CODE       31:29

`define CR_KME_C_CKV_IA_STATUS_T_DECL   22:0
`define CR_KME_C_CKV_IA_STATUS_T_WIDTH  23
  `define CR_KME_C_CKV_IA_STATUS_T_ADDR       14:00
  `define CR_KME_C_CKV_IA_STATUS_T_DATAWORDS  19:15
  `define CR_KME_C_CKV_IA_STATUS_T_CODE       22:20

`define CR_KME_CKV_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_CKV_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_CKV_IA_CAPABILITY_T_DEFAULT  (32'b xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)

`define CR_KME_CKV_IA_CAPABILITY_T_NOP_DECL   0:0
`define CR_KME_CKV_IA_CAPABILITY_T_NOP_WIDTH  1

`define CR_KME_CKV_IA_CAPABILITY_T_READ_DECL   0:0
`define CR_KME_CKV_IA_CAPABILITY_T_READ_WIDTH  1

`define CR_KME_CKV_IA_CAPABILITY_T_WRITE_DECL   0:0
`define CR_KME_CKV_IA_CAPABILITY_T_WRITE_WIDTH  1

`define CR_KME_CKV_IA_CAPABILITY_T_ENABLE_DECL   0:0
`define CR_KME_CKV_IA_CAPABILITY_T_ENABLE_WIDTH  1

`define CR_KME_CKV_IA_CAPABILITY_T_DISABLED_DECL   0:0
`define CR_KME_CKV_IA_CAPABILITY_T_DISABLED_WIDTH  1

`define CR_KME_CKV_IA_CAPABILITY_T_RESET_DECL   0:0
`define CR_KME_CKV_IA_CAPABILITY_T_RESET_WIDTH  1

`define CR_KME_CKV_IA_CAPABILITY_T_INITIALIZE_DECL   0:0
`define CR_KME_CKV_IA_CAPABILITY_T_INITIALIZE_WIDTH  1

`define CR_KME_CKV_IA_CAPABILITY_T_INITIALIZE_INC_DECL   0:0
`define CR_KME_CKV_IA_CAPABILITY_T_INITIALIZE_INC_WIDTH  1

`define CR_KME_CKV_IA_CAPABILITY_T_SET_INIT_START_DECL   0:0
`define CR_KME_CKV_IA_CAPABILITY_T_SET_INIT_START_WIDTH  1

`define CR_KME_CKV_IA_CAPABILITY_T_COMPARE_DECL   0:0
`define CR_KME_CKV_IA_CAPABILITY_T_COMPARE_WIDTH  1

`define CR_KME_CKV_IA_CAPABILITY_T_RESERVED_OP_DECL   3:0
`define CR_KME_CKV_IA_CAPABILITY_T_RESERVED_OP_WIDTH  4

`define CR_KME_CKV_IA_CAPABILITY_T_SIM_TMO_DECL   0:0
`define CR_KME_CKV_IA_CAPABILITY_T_SIM_TMO_WIDTH  1

`define CR_KME_CKV_IA_CAPABILITY_T_ACK_ERROR_DECL   0:0
`define CR_KME_CKV_IA_CAPABILITY_T_ACK_ERROR_WIDTH  1

`define CR_KME_CKV_IA_CAPABILITY_T_MEM_TYPE_DECL   3:0
`define CR_KME_CKV_IA_CAPABILITY_T_MEM_TYPE_WIDTH  4

`define CR_KME_FULL_CKV_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_FULL_CKV_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_FULL_CKV_IA_CAPABILITY_T_NOP             00
  `define CR_KME_FULL_CKV_IA_CAPABILITY_T_READ            01
  `define CR_KME_FULL_CKV_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_FULL_CKV_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_FULL_CKV_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_FULL_CKV_IA_CAPABILITY_T_RESET           05
  `define CR_KME_FULL_CKV_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_FULL_CKV_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_FULL_CKV_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_FULL_CKV_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_FULL_CKV_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_FULL_CKV_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_FULL_CKV_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_FULL_CKV_IA_CAPABILITY_T_RESERVED0       27:16
  `define CR_KME_FULL_CKV_IA_CAPABILITY_T_MEM_TYPE        31:28

`define CR_KME_C_CKV_IA_CAPABILITY_T_DECL   19:0
`define CR_KME_C_CKV_IA_CAPABILITY_T_WIDTH  20
  `define CR_KME_C_CKV_IA_CAPABILITY_T_NOP             00
  `define CR_KME_C_CKV_IA_CAPABILITY_T_READ            01
  `define CR_KME_C_CKV_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_C_CKV_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_C_CKV_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_C_CKV_IA_CAPABILITY_T_RESET           05
  `define CR_KME_C_CKV_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_C_CKV_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_C_CKV_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_C_CKV_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_C_CKV_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_C_CKV_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_C_CKV_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_C_CKV_IA_CAPABILITY_T_MEM_TYPE        19:16

`define CR_KME_KIM_ENTRY0_T_DECL   31:0
`define CR_KME_KIM_ENTRY0_T_WIDTH  32
  `define CR_KME_KIM_ENTRY0_T_DEFAULT  (32'h 0)

`define CR_KME_KIM_ENTRY0_T_CKV_POINTER_DECL   14:0
`define CR_KME_KIM_ENTRY0_T_CKV_POINTER_WIDTH  15
  `define CR_KME_KIM_ENTRY0_T_CKV_POINTER_DEFAULT  (15'h 0)

`define CR_KME_KIM_ENTRY0_T_CKV_LENGTH_DECL   1:0
`define CR_KME_KIM_ENTRY0_T_CKV_LENGTH_WIDTH  2
  `define CR_KME_KIM_ENTRY0_T_CKV_LENGTH_DEFAULT  (2'h 0)

`define CR_KME_KIM_ENTRY0_T_LABEL_INDEX_DECL   2:0
`define CR_KME_KIM_ENTRY0_T_LABEL_INDEX_WIDTH  3
  `define CR_KME_KIM_ENTRY0_T_LABEL_INDEX_DEFAULT  (3'h 0)

`define CR_KME_KIM_ENTRY0_T_VALID_DECL   0:0
`define CR_KME_KIM_ENTRY0_T_VALID_WIDTH  1
  `define CR_KME_KIM_ENTRY0_T_VALID_DEFAULT  (1'h 0)

`define CR_KME_FULL_KIM_ENTRY0_T_DECL   31:0
`define CR_KME_FULL_KIM_ENTRY0_T_WIDTH  32
  `define CR_KME_FULL_KIM_ENTRY0_T_CKV_POINTER  14:00
  `define CR_KME_FULL_KIM_ENTRY0_T_RESERVED0    25:15
  `define CR_KME_FULL_KIM_ENTRY0_T_CKV_LENGTH   27:26
  `define CR_KME_FULL_KIM_ENTRY0_T_LABEL_INDEX  30:28
  `define CR_KME_FULL_KIM_ENTRY0_T_VALID        31

`define CR_KME_C_KIM_ENTRY0_T_DECL   20:0
`define CR_KME_C_KIM_ENTRY0_T_WIDTH  21
  `define CR_KME_C_KIM_ENTRY0_T_CKV_POINTER  14:00
  `define CR_KME_C_KIM_ENTRY0_T_CKV_LENGTH   16:15
  `define CR_KME_C_KIM_ENTRY0_T_LABEL_INDEX  19:17
  `define CR_KME_C_KIM_ENTRY0_T_VALID        20

`define CR_KME_KIM_ENTRY1_T_DECL   31:0
`define CR_KME_KIM_ENTRY1_T_WIDTH  32
  `define CR_KME_KIM_ENTRY1_T_DEFAULT  (32'h 0)

`define CR_KME_KIM_ENTRY1_T_VF_VALID_DECL   0:0
`define CR_KME_KIM_ENTRY1_T_VF_VALID_WIDTH  1
  `define CR_KME_KIM_ENTRY1_T_VF_VALID_DEFAULT  (1'h 0)

`define CR_KME_KIM_ENTRY1_T_VF_NUM_DECL   11:0
`define CR_KME_KIM_ENTRY1_T_VF_NUM_WIDTH  12
  `define CR_KME_KIM_ENTRY1_T_VF_NUM_DEFAULT  (12'h 0)

`define CR_KME_KIM_ENTRY1_T_PF_NUM_DECL   3:0
`define CR_KME_KIM_ENTRY1_T_PF_NUM_WIDTH  4
  `define CR_KME_KIM_ENTRY1_T_PF_NUM_DEFAULT  (4'h 0)

`define CR_KME_FULL_KIM_ENTRY1_T_DECL   31:0
`define CR_KME_FULL_KIM_ENTRY1_T_WIDTH  32
  `define CR_KME_FULL_KIM_ENTRY1_T_VF_VALID   00
  `define CR_KME_FULL_KIM_ENTRY1_T_VF_NUM     12:01
  `define CR_KME_FULL_KIM_ENTRY1_T_RESERVED0  27:13
  `define CR_KME_FULL_KIM_ENTRY1_T_PF_NUM     31:28

`define CR_KME_C_KIM_ENTRY1_T_DECL   16:0
`define CR_KME_C_KIM_ENTRY1_T_WIDTH  17
  `define CR_KME_C_KIM_ENTRY1_T_VF_VALID  00
  `define CR_KME_C_KIM_ENTRY1_T_VF_NUM    12:01
  `define CR_KME_C_KIM_ENTRY1_T_PF_NUM    16:13

`define CR_KME_KIM_IA_CONFIG_T_DECL   31:0
`define CR_KME_KIM_IA_CONFIG_T_WIDTH  32
  `define CR_KME_KIM_IA_CONFIG_T_DEFAULT  (32'h 0)

`define CR_KME_KIM_IA_CONFIG_T_ADDR_DECL   13:0
`define CR_KME_KIM_IA_CONFIG_T_ADDR_WIDTH  14
  `define CR_KME_KIM_IA_CONFIG_T_ADDR_DEFAULT  (14'h 0)

`define CR_KME_KIM_IA_CONFIG_T_OP_DECL   3:0
`define CR_KME_KIM_IA_CONFIG_T_OP_WIDTH  4
  `define CR_KME_KIM_IA_CONFIG_T_OP_DEFAULT  (4'h 0)

`define CR_KME_FULL_KIM_IA_CONFIG_T_DECL   31:0
`define CR_KME_FULL_KIM_IA_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_KIM_IA_CONFIG_T_ADDR       13:00
  `define CR_KME_FULL_KIM_IA_CONFIG_T_RESERVED0  27:14
  `define CR_KME_FULL_KIM_IA_CONFIG_T_OP         31:28

`define CR_KME_C_KIM_IA_CONFIG_T_DECL   17:0
`define CR_KME_C_KIM_IA_CONFIG_T_WIDTH  18
  `define CR_KME_C_KIM_IA_CONFIG_T_ADDR  13:00
  `define CR_KME_C_KIM_IA_CONFIG_T_OP    17:14

`define CR_KME_KIM_IA_STATUS_T_DECL   31:0
`define CR_KME_KIM_IA_STATUS_T_WIDTH  32
  `define CR_KME_KIM_IA_STATUS_T_DEFAULT  (32'h e0000000)

`define CR_KME_KIM_IA_STATUS_T_ADDR_DECL   13:0
`define CR_KME_KIM_IA_STATUS_T_ADDR_WIDTH  14
  `define CR_KME_KIM_IA_STATUS_T_ADDR_DEFAULT  (14'h 0)

`define CR_KME_KIM_IA_STATUS_T_DATAWORDS_DECL   4:0
`define CR_KME_KIM_IA_STATUS_T_DATAWORDS_WIDTH  5
  `define CR_KME_KIM_IA_STATUS_T_DATAWORDS_DEFAULT  (5'h 0)

`define CR_KME_KIM_IA_STATUS_T_CODE_DECL   2:0
`define CR_KME_KIM_IA_STATUS_T_CODE_WIDTH  3
  `define CR_KME_KIM_IA_STATUS_T_CODE_DEFAULT  (3'h 7)

`define CR_KME_FULL_KIM_IA_STATUS_T_DECL   31:0
`define CR_KME_FULL_KIM_IA_STATUS_T_WIDTH  32
  `define CR_KME_FULL_KIM_IA_STATUS_T_ADDR       13:00
  `define CR_KME_FULL_KIM_IA_STATUS_T_RESERVED0  23:14
  `define CR_KME_FULL_KIM_IA_STATUS_T_DATAWORDS  28:24
  `define CR_KME_FULL_KIM_IA_STATUS_T_CODE       31:29

`define CR_KME_C_KIM_IA_STATUS_T_DECL   21:0
`define CR_KME_C_KIM_IA_STATUS_T_WIDTH  22
  `define CR_KME_C_KIM_IA_STATUS_T_ADDR       13:00
  `define CR_KME_C_KIM_IA_STATUS_T_DATAWORDS  18:14
  `define CR_KME_C_KIM_IA_STATUS_T_CODE       21:19

`define CR_KME_KIM_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_KIM_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_KIM_IA_CAPABILITY_T_DEFAULT  (32'b xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)

`define CR_KME_KIM_IA_CAPABILITY_T_NOP_DECL   0:0
`define CR_KME_KIM_IA_CAPABILITY_T_NOP_WIDTH  1

`define CR_KME_KIM_IA_CAPABILITY_T_READ_DECL   0:0
`define CR_KME_KIM_IA_CAPABILITY_T_READ_WIDTH  1

`define CR_KME_KIM_IA_CAPABILITY_T_WRITE_DECL   0:0
`define CR_KME_KIM_IA_CAPABILITY_T_WRITE_WIDTH  1

`define CR_KME_KIM_IA_CAPABILITY_T_ENABLE_DECL   0:0
`define CR_KME_KIM_IA_CAPABILITY_T_ENABLE_WIDTH  1

`define CR_KME_KIM_IA_CAPABILITY_T_DISABLED_DECL   0:0
`define CR_KME_KIM_IA_CAPABILITY_T_DISABLED_WIDTH  1

`define CR_KME_KIM_IA_CAPABILITY_T_RESET_DECL   0:0
`define CR_KME_KIM_IA_CAPABILITY_T_RESET_WIDTH  1

`define CR_KME_KIM_IA_CAPABILITY_T_INITIALIZE_DECL   0:0
`define CR_KME_KIM_IA_CAPABILITY_T_INITIALIZE_WIDTH  1

`define CR_KME_KIM_IA_CAPABILITY_T_INITIALIZE_INC_DECL   0:0
`define CR_KME_KIM_IA_CAPABILITY_T_INITIALIZE_INC_WIDTH  1

`define CR_KME_KIM_IA_CAPABILITY_T_SET_INIT_START_DECL   0:0
`define CR_KME_KIM_IA_CAPABILITY_T_SET_INIT_START_WIDTH  1

`define CR_KME_KIM_IA_CAPABILITY_T_COMPARE_DECL   0:0
`define CR_KME_KIM_IA_CAPABILITY_T_COMPARE_WIDTH  1

`define CR_KME_KIM_IA_CAPABILITY_T_RESERVED_OP_DECL   3:0
`define CR_KME_KIM_IA_CAPABILITY_T_RESERVED_OP_WIDTH  4

`define CR_KME_KIM_IA_CAPABILITY_T_SIM_TMO_DECL   0:0
`define CR_KME_KIM_IA_CAPABILITY_T_SIM_TMO_WIDTH  1

`define CR_KME_KIM_IA_CAPABILITY_T_ACK_ERROR_DECL   0:0
`define CR_KME_KIM_IA_CAPABILITY_T_ACK_ERROR_WIDTH  1

`define CR_KME_KIM_IA_CAPABILITY_T_MEM_TYPE_DECL   3:0
`define CR_KME_KIM_IA_CAPABILITY_T_MEM_TYPE_WIDTH  4

`define CR_KME_FULL_KIM_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_FULL_KIM_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_FULL_KIM_IA_CAPABILITY_T_NOP             00
  `define CR_KME_FULL_KIM_IA_CAPABILITY_T_READ            01
  `define CR_KME_FULL_KIM_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_FULL_KIM_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_FULL_KIM_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_FULL_KIM_IA_CAPABILITY_T_RESET           05
  `define CR_KME_FULL_KIM_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_FULL_KIM_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_FULL_KIM_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_FULL_KIM_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_FULL_KIM_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_FULL_KIM_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_FULL_KIM_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_FULL_KIM_IA_CAPABILITY_T_RESERVED0       27:16
  `define CR_KME_FULL_KIM_IA_CAPABILITY_T_MEM_TYPE        31:28

`define CR_KME_C_KIM_IA_CAPABILITY_T_DECL   19:0
`define CR_KME_C_KIM_IA_CAPABILITY_T_WIDTH  20
  `define CR_KME_C_KIM_IA_CAPABILITY_T_NOP             00
  `define CR_KME_C_KIM_IA_CAPABILITY_T_READ            01
  `define CR_KME_C_KIM_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_C_KIM_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_C_KIM_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_C_KIM_IA_CAPABILITY_T_RESET           05
  `define CR_KME_C_KIM_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_C_KIM_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_C_KIM_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_C_KIM_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_C_KIM_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_C_KIM_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_C_KIM_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_C_KIM_IA_CAPABILITY_T_MEM_TYPE        19:16

`define CR_KME_LABEL_METADATA_T_DECL   31:0
`define CR_KME_LABEL_METADATA_T_WIDTH  32
  `define CR_KME_LABEL_METADATA_T_DEFAULT  (32'h 100)

`define CR_KME_LABEL_METADATA_T_LABEL_DELIMITER_DECL   7:0
`define CR_KME_LABEL_METADATA_T_LABEL_DELIMITER_WIDTH  8
  `define CR_KME_LABEL_METADATA_T_LABEL_DELIMITER_DEFAULT  (8'h 0)

`define CR_KME_LABEL_METADATA_T_LABEL_DELIMITER_VALID_DECL   0:0
`define CR_KME_LABEL_METADATA_T_LABEL_DELIMITER_VALID_WIDTH  1
  `define CR_KME_LABEL_METADATA_T_LABEL_DELIMITER_VALID_DEFAULT  (1'h 1)

`define CR_KME_LABEL_METADATA_T_LABEL_SIZE_DECL   5:0
`define CR_KME_LABEL_METADATA_T_LABEL_SIZE_WIDTH  6
  `define CR_KME_LABEL_METADATA_T_LABEL_SIZE_DEFAULT  (6'h 0)

`define CR_KME_LABEL_METADATA_T_LABEL_GUID_SIZE_DECL   0:0
`define CR_KME_LABEL_METADATA_T_LABEL_GUID_SIZE_WIDTH  1
  `define CR_KME_LABEL_METADATA_T_LABEL_GUID_SIZE_DEFAULT  (1'h 0)

`define CR_KME_FULL_LABEL_METADATA_T_DECL   31:0
`define CR_KME_FULL_LABEL_METADATA_T_WIDTH  32
  `define CR_KME_FULL_LABEL_METADATA_T_LABEL_DELIMITER        07:00
  `define CR_KME_FULL_LABEL_METADATA_T_LABEL_DELIMITER_VALID  08
  `define CR_KME_FULL_LABEL_METADATA_T_RESERVED0              24:09
  `define CR_KME_FULL_LABEL_METADATA_T_LABEL_SIZE             30:25
  `define CR_KME_FULL_LABEL_METADATA_T_LABEL_GUID_SIZE        31

`define CR_KME_C_LABEL_METADATA_T_DECL   15:0
`define CR_KME_C_LABEL_METADATA_T_WIDTH  16
  `define CR_KME_C_LABEL_METADATA_T_LABEL_DELIMITER        07:00
  `define CR_KME_C_LABEL_METADATA_T_LABEL_DELIMITER_VALID  08
  `define CR_KME_C_LABEL_METADATA_T_LABEL_SIZE             14:09
  `define CR_KME_C_LABEL_METADATA_T_LABEL_GUID_SIZE        15

`define CR_KME_LABEL_DATA_T_DECL   31:0
`define CR_KME_LABEL_DATA_T_WIDTH  32
  `define CR_KME_LABEL_DATA_T_DEFAULT  (32'h 0)

`define CR_KME_LABEL_DATA_T_LABEL_DATA_DECL   31:0
`define CR_KME_LABEL_DATA_T_LABEL_DATA_WIDTH  32
  `define CR_KME_LABEL_DATA_T_LABEL_DATA_DEFAULT  (32'h 0)

`define CR_KME_FULL_LABEL_DATA_T_DECL   31:0
`define CR_KME_FULL_LABEL_DATA_T_WIDTH  32
  `define CR_KME_FULL_LABEL_DATA_T_LABEL_DATA  31:00

`define CR_KME_C_LABEL_DATA_T_DECL   31:0
`define CR_KME_C_LABEL_DATA_T_WIDTH  32
  `define CR_KME_C_LABEL_DATA_T_LABEL_DATA  31:00

`define CR_KME_INT_STATUS_T_DECL   31:0
`define CR_KME_INT_STATUS_T_WIDTH  32
  `define CR_KME_INT_STATUS_T_DEFAULT  (32'h 0)

`define CR_KME_INT_STATUS_T_DRBG_SEED_EXPIRED_DECL   0:0
`define CR_KME_INT_STATUS_T_DRBG_SEED_EXPIRED_WIDTH  1
  `define CR_KME_INT_STATUS_T_DRBG_SEED_EXPIRED_DEFAULT  (1'h 0)

`define CR_KME_INT_STATUS_T_ECC_MBE_DECL   0:0
`define CR_KME_INT_STATUS_T_ECC_MBE_WIDTH  1
  `define CR_KME_INT_STATUS_T_ECC_MBE_DEFAULT  (1'h 0)

`define CR_KME_INT_STATUS_T_TXC_BP_DECL   0:0
`define CR_KME_INT_STATUS_T_TXC_BP_WIDTH  1
  `define CR_KME_INT_STATUS_T_TXC_BP_DEFAULT  (1'h 0)

`define CR_KME_INT_STATUS_T_GCM_TAG_FAIL_DECL   0:0
`define CR_KME_INT_STATUS_T_GCM_TAG_FAIL_WIDTH  1
  `define CR_KME_INT_STATUS_T_GCM_TAG_FAIL_DEFAULT  (1'h 0)

`define CR_KME_INT_STATUS_T_TLV_MISCOMP_DECL   0:0
`define CR_KME_INT_STATUS_T_TLV_MISCOMP_WIDTH  1
  `define CR_KME_INT_STATUS_T_TLV_MISCOMP_DEFAULT  (1'h 0)

`define CR_KME_FULL_INT_STATUS_T_DECL   31:0
`define CR_KME_FULL_INT_STATUS_T_WIDTH  32
  `define CR_KME_FULL_INT_STATUS_T_DRBG_SEED_EXPIRED  0
  `define CR_KME_FULL_INT_STATUS_T_ECC_MBE            1
  `define CR_KME_FULL_INT_STATUS_T_TXC_BP             2
  `define CR_KME_FULL_INT_STATUS_T_GCM_TAG_FAIL       3
  `define CR_KME_FULL_INT_STATUS_T_TLV_MISCOMP        4
  `define CR_KME_FULL_INT_STATUS_T_RESERVED0          31:5

`define CR_KME_C_INT_STATUS_T_DECL   4:0
`define CR_KME_C_INT_STATUS_T_WIDTH  5
  `define CR_KME_C_INT_STATUS_T_DRBG_SEED_EXPIRED  0
  `define CR_KME_C_INT_STATUS_T_ECC_MBE            1
  `define CR_KME_C_INT_STATUS_T_TXC_BP             2
  `define CR_KME_C_INT_STATUS_T_GCM_TAG_FAIL       3
  `define CR_KME_C_INT_STATUS_T_TLV_MISCOMP        4

`define CR_KME_INT_MASK_T_DECL   31:0
`define CR_KME_INT_MASK_T_WIDTH  32
  `define CR_KME_INT_MASK_T_DEFAULT  (32'h 0)

`define CR_KME_INT_MASK_T_DRBG_SEED_EXPIRED_DECL   0:0
`define CR_KME_INT_MASK_T_DRBG_SEED_EXPIRED_WIDTH  1
  `define CR_KME_INT_MASK_T_DRBG_SEED_EXPIRED_DEFAULT  (1'h 0)

`define CR_KME_INT_MASK_T_ECC_MBE_DECL   0:0
`define CR_KME_INT_MASK_T_ECC_MBE_WIDTH  1
  `define CR_KME_INT_MASK_T_ECC_MBE_DEFAULT  (1'h 0)

`define CR_KME_INT_MASK_T_TXC_BP_DECL   0:0
`define CR_KME_INT_MASK_T_TXC_BP_WIDTH  1
  `define CR_KME_INT_MASK_T_TXC_BP_DEFAULT  (1'h 0)

`define CR_KME_INT_MASK_T_GCM_TAG_FAIL_DECL   0:0
`define CR_KME_INT_MASK_T_GCM_TAG_FAIL_WIDTH  1
  `define CR_KME_INT_MASK_T_GCM_TAG_FAIL_DEFAULT  (1'h 0)

`define CR_KME_INT_MASK_T_TLV_MISCOMP_DECL   0:0
`define CR_KME_INT_MASK_T_TLV_MISCOMP_WIDTH  1
  `define CR_KME_INT_MASK_T_TLV_MISCOMP_DEFAULT  (1'h 0)

`define CR_KME_FULL_INT_MASK_T_DECL   31:0
`define CR_KME_FULL_INT_MASK_T_WIDTH  32
  `define CR_KME_FULL_INT_MASK_T_DRBG_SEED_EXPIRED  0
  `define CR_KME_FULL_INT_MASK_T_ECC_MBE            1
  `define CR_KME_FULL_INT_MASK_T_TXC_BP             2
  `define CR_KME_FULL_INT_MASK_T_GCM_TAG_FAIL       3
  `define CR_KME_FULL_INT_MASK_T_TLV_MISCOMP        4
  `define CR_KME_FULL_INT_MASK_T_RESERVED0          31:5

`define CR_KME_C_INT_MASK_T_DECL   4:0
`define CR_KME_C_INT_MASK_T_WIDTH  5
  `define CR_KME_C_INT_MASK_T_DRBG_SEED_EXPIRED  0
  `define CR_KME_C_INT_MASK_T_ECC_MBE            1
  `define CR_KME_C_INT_MASK_T_TXC_BP             2
  `define CR_KME_C_INT_MASK_T_GCM_TAG_FAIL       3
  `define CR_KME_C_INT_MASK_T_TLV_MISCOMP        4

`define CR_KME_STICKY_ENG_BP_T_DECL   31:0
`define CR_KME_STICKY_ENG_BP_T_WIDTH  32
  `define CR_KME_STICKY_ENG_BP_T_DEFAULT  (32'h 0)

`define CR_KME_STICKY_ENG_BP_T_ENGINE_0_BP_DECL   0:0
`define CR_KME_STICKY_ENG_BP_T_ENGINE_0_BP_WIDTH  1
  `define CR_KME_STICKY_ENG_BP_T_ENGINE_0_BP_DEFAULT  (1'h 0)

`define CR_KME_STICKY_ENG_BP_T_ENGINE_1_BP_DECL   0:0
`define CR_KME_STICKY_ENG_BP_T_ENGINE_1_BP_WIDTH  1
  `define CR_KME_STICKY_ENG_BP_T_ENGINE_1_BP_DEFAULT  (1'h 0)

`define CR_KME_STICKY_ENG_BP_T_ENGINE_2_BP_DECL   0:0
`define CR_KME_STICKY_ENG_BP_T_ENGINE_2_BP_WIDTH  1
  `define CR_KME_STICKY_ENG_BP_T_ENGINE_2_BP_DEFAULT  (1'h 0)

`define CR_KME_STICKY_ENG_BP_T_ENGINE_3_BP_DECL   0:0
`define CR_KME_STICKY_ENG_BP_T_ENGINE_3_BP_WIDTH  1
  `define CR_KME_STICKY_ENG_BP_T_ENGINE_3_BP_DEFAULT  (1'h 0)

`define CR_KME_STICKY_ENG_BP_T_ENGINE_4_BP_DECL   0:0
`define CR_KME_STICKY_ENG_BP_T_ENGINE_4_BP_WIDTH  1
  `define CR_KME_STICKY_ENG_BP_T_ENGINE_4_BP_DEFAULT  (1'h 0)

`define CR_KME_STICKY_ENG_BP_T_ENGINE_5_BP_DECL   0:0
`define CR_KME_STICKY_ENG_BP_T_ENGINE_5_BP_WIDTH  1
  `define CR_KME_STICKY_ENG_BP_T_ENGINE_5_BP_DEFAULT  (1'h 0)

`define CR_KME_STICKY_ENG_BP_T_ENGINE_6_BP_DECL   0:0
`define CR_KME_STICKY_ENG_BP_T_ENGINE_6_BP_WIDTH  1
  `define CR_KME_STICKY_ENG_BP_T_ENGINE_6_BP_DEFAULT  (1'h 0)

`define CR_KME_STICKY_ENG_BP_T_ENGINE_7_BP_DECL   0:0
`define CR_KME_STICKY_ENG_BP_T_ENGINE_7_BP_WIDTH  1
  `define CR_KME_STICKY_ENG_BP_T_ENGINE_7_BP_DEFAULT  (1'h 0)

`define CR_KME_FULL_STICKY_ENG_BP_T_DECL   31:0
`define CR_KME_FULL_STICKY_ENG_BP_T_WIDTH  32
  `define CR_KME_FULL_STICKY_ENG_BP_T_ENGINE_0_BP  0
  `define CR_KME_FULL_STICKY_ENG_BP_T_ENGINE_1_BP  1
  `define CR_KME_FULL_STICKY_ENG_BP_T_ENGINE_2_BP  2
  `define CR_KME_FULL_STICKY_ENG_BP_T_ENGINE_3_BP  3
  `define CR_KME_FULL_STICKY_ENG_BP_T_ENGINE_4_BP  4
  `define CR_KME_FULL_STICKY_ENG_BP_T_ENGINE_5_BP  5
  `define CR_KME_FULL_STICKY_ENG_BP_T_ENGINE_6_BP  6
  `define CR_KME_FULL_STICKY_ENG_BP_T_ENGINE_7_BP  7
  `define CR_KME_FULL_STICKY_ENG_BP_T_RESERVED0    31:8

`define CR_KME_C_STICKY_ENG_BP_T_DECL   7:0
`define CR_KME_C_STICKY_ENG_BP_T_WIDTH  8
  `define CR_KME_C_STICKY_ENG_BP_T_ENGINE_0_BP  0
  `define CR_KME_C_STICKY_ENG_BP_T_ENGINE_1_BP  1
  `define CR_KME_C_STICKY_ENG_BP_T_ENGINE_2_BP  2
  `define CR_KME_C_STICKY_ENG_BP_T_ENGINE_3_BP  3
  `define CR_KME_C_STICKY_ENG_BP_T_ENGINE_4_BP  4
  `define CR_KME_C_STICKY_ENG_BP_T_ENGINE_5_BP  5
  `define CR_KME_C_STICKY_ENG_BP_T_ENGINE_6_BP  6
  `define CR_KME_C_STICKY_ENG_BP_T_ENGINE_7_BP  7

`define CR_KME_TREADY_OVERRIDE_T_DECL   31:0
`define CR_KME_TREADY_OVERRIDE_T_WIDTH  32
  `define CR_KME_TREADY_OVERRIDE_T_DEFAULT  (32'h 0)

`define CR_KME_TREADY_OVERRIDE_T_ENGINE_0_TREADY_OVERRIDE_DECL   0:0
`define CR_KME_TREADY_OVERRIDE_T_ENGINE_0_TREADY_OVERRIDE_WIDTH  1
  `define CR_KME_TREADY_OVERRIDE_T_ENGINE_0_TREADY_OVERRIDE_DEFAULT  (1'h 0)

`define CR_KME_TREADY_OVERRIDE_T_ENGINE_1_TREADY_OVERRIDE_DECL   0:0
`define CR_KME_TREADY_OVERRIDE_T_ENGINE_1_TREADY_OVERRIDE_WIDTH  1
  `define CR_KME_TREADY_OVERRIDE_T_ENGINE_1_TREADY_OVERRIDE_DEFAULT  (1'h 0)

`define CR_KME_TREADY_OVERRIDE_T_ENGINE_2_TREADY_OVERRIDE_DECL   0:0
`define CR_KME_TREADY_OVERRIDE_T_ENGINE_2_TREADY_OVERRIDE_WIDTH  1
  `define CR_KME_TREADY_OVERRIDE_T_ENGINE_2_TREADY_OVERRIDE_DEFAULT  (1'h 0)

`define CR_KME_TREADY_OVERRIDE_T_ENGINE_3_TREADY_OVERRIDE_DECL   0:0
`define CR_KME_TREADY_OVERRIDE_T_ENGINE_3_TREADY_OVERRIDE_WIDTH  1
  `define CR_KME_TREADY_OVERRIDE_T_ENGINE_3_TREADY_OVERRIDE_DEFAULT  (1'h 0)

`define CR_KME_TREADY_OVERRIDE_T_ENGINE_4_TREADY_OVERRIDE_DECL   0:0
`define CR_KME_TREADY_OVERRIDE_T_ENGINE_4_TREADY_OVERRIDE_WIDTH  1
  `define CR_KME_TREADY_OVERRIDE_T_ENGINE_4_TREADY_OVERRIDE_DEFAULT  (1'h 0)

`define CR_KME_TREADY_OVERRIDE_T_ENGINE_5_TREADY_OVERRIDE_DECL   0:0
`define CR_KME_TREADY_OVERRIDE_T_ENGINE_5_TREADY_OVERRIDE_WIDTH  1
  `define CR_KME_TREADY_OVERRIDE_T_ENGINE_5_TREADY_OVERRIDE_DEFAULT  (1'h 0)

`define CR_KME_TREADY_OVERRIDE_T_ENGINE_6_TREADY_OVERRIDE_DECL   0:0
`define CR_KME_TREADY_OVERRIDE_T_ENGINE_6_TREADY_OVERRIDE_WIDTH  1
  `define CR_KME_TREADY_OVERRIDE_T_ENGINE_6_TREADY_OVERRIDE_DEFAULT  (1'h 0)

`define CR_KME_TREADY_OVERRIDE_T_ENGINE_7_TREADY_OVERRIDE_DECL   0:0
`define CR_KME_TREADY_OVERRIDE_T_ENGINE_7_TREADY_OVERRIDE_WIDTH  1
  `define CR_KME_TREADY_OVERRIDE_T_ENGINE_7_TREADY_OVERRIDE_DEFAULT  (1'h 0)

`define CR_KME_TREADY_OVERRIDE_T_TXC_TREADY_OVERRIDE_DECL   0:0
`define CR_KME_TREADY_OVERRIDE_T_TXC_TREADY_OVERRIDE_WIDTH  1
  `define CR_KME_TREADY_OVERRIDE_T_TXC_TREADY_OVERRIDE_DEFAULT  (1'h 0)

`define CR_KME_FULL_TREADY_OVERRIDE_T_DECL   31:0
`define CR_KME_FULL_TREADY_OVERRIDE_T_WIDTH  32
  `define CR_KME_FULL_TREADY_OVERRIDE_T_ENGINE_0_TREADY_OVERRIDE  0
  `define CR_KME_FULL_TREADY_OVERRIDE_T_ENGINE_1_TREADY_OVERRIDE  1
  `define CR_KME_FULL_TREADY_OVERRIDE_T_ENGINE_2_TREADY_OVERRIDE  2
  `define CR_KME_FULL_TREADY_OVERRIDE_T_ENGINE_3_TREADY_OVERRIDE  3
  `define CR_KME_FULL_TREADY_OVERRIDE_T_ENGINE_4_TREADY_OVERRIDE  4
  `define CR_KME_FULL_TREADY_OVERRIDE_T_ENGINE_5_TREADY_OVERRIDE  5
  `define CR_KME_FULL_TREADY_OVERRIDE_T_ENGINE_6_TREADY_OVERRIDE  6
  `define CR_KME_FULL_TREADY_OVERRIDE_T_ENGINE_7_TREADY_OVERRIDE  7
  `define CR_KME_FULL_TREADY_OVERRIDE_T_TXC_TREADY_OVERRIDE       8
  `define CR_KME_FULL_TREADY_OVERRIDE_T_RESERVED0                 31:9

`define CR_KME_C_TREADY_OVERRIDE_T_DECL   8:0
`define CR_KME_C_TREADY_OVERRIDE_T_WIDTH  9
  `define CR_KME_C_TREADY_OVERRIDE_T_ENGINE_0_TREADY_OVERRIDE  0
  `define CR_KME_C_TREADY_OVERRIDE_T_ENGINE_1_TREADY_OVERRIDE  1
  `define CR_KME_C_TREADY_OVERRIDE_T_ENGINE_2_TREADY_OVERRIDE  2
  `define CR_KME_C_TREADY_OVERRIDE_T_ENGINE_3_TREADY_OVERRIDE  3
  `define CR_KME_C_TREADY_OVERRIDE_T_ENGINE_4_TREADY_OVERRIDE  4
  `define CR_KME_C_TREADY_OVERRIDE_T_ENGINE_5_TREADY_OVERRIDE  5
  `define CR_KME_C_TREADY_OVERRIDE_T_ENGINE_6_TREADY_OVERRIDE  6
  `define CR_KME_C_TREADY_OVERRIDE_T_ENGINE_7_TREADY_OVERRIDE  7
  `define CR_KME_C_TREADY_OVERRIDE_T_TXC_TREADY_OVERRIDE       8

`define CR_KME_KDF_DRBG_STATE_KEY_T_DECL   31:0
`define CR_KME_KDF_DRBG_STATE_KEY_T_WIDTH  32
  `define CR_KME_KDF_DRBG_STATE_KEY_T_DEFAULT  (32'h 0)

`define CR_KME_KDF_DRBG_STATE_KEY_T_KEY_DECL   31:0
`define CR_KME_KDF_DRBG_STATE_KEY_T_KEY_WIDTH  32
  `define CR_KME_KDF_DRBG_STATE_KEY_T_KEY_DEFAULT  (32'h 0)

`define CR_KME_FULL_KDF_DRBG_STATE_KEY_T_DECL   31:0
`define CR_KME_FULL_KDF_DRBG_STATE_KEY_T_WIDTH  32
  `define CR_KME_FULL_KDF_DRBG_STATE_KEY_T_KEY  31:00

`define CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL   31:0
`define CR_KME_C_KDF_DRBG_STATE_KEY_T_WIDTH  32
  `define CR_KME_C_KDF_DRBG_STATE_KEY_T_KEY  31:00

`define CR_KME_KDF_DRBG_STATE_VALUE_T_DECL   31:0
`define CR_KME_KDF_DRBG_STATE_VALUE_T_WIDTH  32
  `define CR_KME_KDF_DRBG_STATE_VALUE_T_DEFAULT  (32'h 0)

`define CR_KME_KDF_DRBG_STATE_VALUE_T_VALUE_DECL   31:0
`define CR_KME_KDF_DRBG_STATE_VALUE_T_VALUE_WIDTH  32
  `define CR_KME_KDF_DRBG_STATE_VALUE_T_VALUE_DEFAULT  (32'h 0)

`define CR_KME_FULL_KDF_DRBG_STATE_VALUE_T_DECL   31:0
`define CR_KME_FULL_KDF_DRBG_STATE_VALUE_T_WIDTH  32
  `define CR_KME_FULL_KDF_DRBG_STATE_VALUE_T_VALUE  31:00

`define CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL   31:0
`define CR_KME_C_KDF_DRBG_STATE_VALUE_T_WIDTH  32
  `define CR_KME_C_KDF_DRBG_STATE_VALUE_T_VALUE  31:00

`define CR_KME_KDF_DRBG_RESEED_INTERVAL_1_T_DECL   31:0
`define CR_KME_KDF_DRBG_RESEED_INTERVAL_1_T_WIDTH  32
  `define CR_KME_KDF_DRBG_RESEED_INTERVAL_1_T_DEFAULT  (32'h 0)

`define CR_KME_KDF_DRBG_RESEED_INTERVAL_1_T_EXPIRE_VAL_DECL   15:0
`define CR_KME_KDF_DRBG_RESEED_INTERVAL_1_T_EXPIRE_VAL_WIDTH  16
  `define CR_KME_KDF_DRBG_RESEED_INTERVAL_1_T_EXPIRE_VAL_DEFAULT  (16'h 0)

`define CR_KME_FULL_KDF_DRBG_RESEED_INTERVAL_1_T_DECL   31:0
`define CR_KME_FULL_KDF_DRBG_RESEED_INTERVAL_1_T_WIDTH  32
  `define CR_KME_FULL_KDF_DRBG_RESEED_INTERVAL_1_T_EXPIRE_VAL  15:00
  `define CR_KME_FULL_KDF_DRBG_RESEED_INTERVAL_1_T_RESERVED0   31:16

`define CR_KME_C_KDF_DRBG_RESEED_INTERVAL_1_T_DECL   15:0
`define CR_KME_C_KDF_DRBG_RESEED_INTERVAL_1_T_WIDTH  16
  `define CR_KME_C_KDF_DRBG_RESEED_INTERVAL_1_T_EXPIRE_VAL  15:00

`define CR_KME_KDF_DRBG_RESEED_INTERVAL_0_T_DECL   31:0
`define CR_KME_KDF_DRBG_RESEED_INTERVAL_0_T_WIDTH  32
  `define CR_KME_KDF_DRBG_RESEED_INTERVAL_0_T_DEFAULT  (32'h 0)

`define CR_KME_KDF_DRBG_RESEED_INTERVAL_0_T_EXPIRE_VAL_DECL   31:0
`define CR_KME_KDF_DRBG_RESEED_INTERVAL_0_T_EXPIRE_VAL_WIDTH  32
  `define CR_KME_KDF_DRBG_RESEED_INTERVAL_0_T_EXPIRE_VAL_DEFAULT  (32'h 0)

`define CR_KME_FULL_KDF_DRBG_RESEED_INTERVAL_0_T_DECL   31:0
`define CR_KME_FULL_KDF_DRBG_RESEED_INTERVAL_0_T_WIDTH  32
  `define CR_KME_FULL_KDF_DRBG_RESEED_INTERVAL_0_T_EXPIRE_VAL  31:00

`define CR_KME_C_KDF_DRBG_RESEED_INTERVAL_0_T_DECL   31:0
`define CR_KME_C_KDF_DRBG_RESEED_INTERVAL_0_T_WIDTH  32
  `define CR_KME_C_KDF_DRBG_RESEED_INTERVAL_0_T_EXPIRE_VAL  31:00

`define CR_KME_KDF_DRBG_CTRL_T_DECL   31:0
`define CR_KME_KDF_DRBG_CTRL_T_WIDTH  32
  `define CR_KME_KDF_DRBG_CTRL_T_DEFAULT  (32'h 0)

`define CR_KME_KDF_DRBG_CTRL_T_VALID_DECL   1:0
`define CR_KME_KDF_DRBG_CTRL_T_VALID_WIDTH  2
  `define CR_KME_KDF_DRBG_CTRL_T_VALID_DEFAULT  (2'h 0)

`define CR_KME_FULL_KDF_DRBG_CTRL_T_DECL   31:0
`define CR_KME_FULL_KDF_DRBG_CTRL_T_WIDTH  32
  `define CR_KME_FULL_KDF_DRBG_CTRL_T_VALID      1:0
  `define CR_KME_FULL_KDF_DRBG_CTRL_T_RESERVED0  31:2

`define CR_KME_C_KDF_DRBG_CTRL_T_DECL   1:0
`define CR_KME_C_KDF_DRBG_CTRL_T_WIDTH  2
  `define CR_KME_C_KDF_DRBG_CTRL_T_VALID  1:0

`define CR_KME_BIMC_MONITOR_T_DECL   31:0
`define CR_KME_BIMC_MONITOR_T_WIDTH  32
  `define CR_KME_BIMC_MONITOR_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_MONITOR_T_UNCORRECTABLE_ECC_ERROR_DECL   0:0
`define CR_KME_BIMC_MONITOR_T_UNCORRECTABLE_ECC_ERROR_WIDTH  1
  `define CR_KME_BIMC_MONITOR_T_UNCORRECTABLE_ECC_ERROR_DEFAULT  (1'h 0)

`define CR_KME_BIMC_MONITOR_T_CORRECTABLE_ECC_ERROR_DECL   0:0
`define CR_KME_BIMC_MONITOR_T_CORRECTABLE_ECC_ERROR_WIDTH  1
  `define CR_KME_BIMC_MONITOR_T_CORRECTABLE_ECC_ERROR_DEFAULT  (1'h 0)

`define CR_KME_BIMC_MONITOR_T_PARITY_ERROR_DECL   0:0
`define CR_KME_BIMC_MONITOR_T_PARITY_ERROR_WIDTH  1
  `define CR_KME_BIMC_MONITOR_T_PARITY_ERROR_DEFAULT  (1'h 0)

`define CR_KME_BIMC_MONITOR_T_RESERVE_DECL   0:0
`define CR_KME_BIMC_MONITOR_T_RESERVE_WIDTH  1
  `define CR_KME_BIMC_MONITOR_T_RESERVE_DEFAULT  (1'h 0)

`define CR_KME_BIMC_MONITOR_T_BIMC_CHAIN_RCV_ERROR_DECL   0:0
`define CR_KME_BIMC_MONITOR_T_BIMC_CHAIN_RCV_ERROR_WIDTH  1
  `define CR_KME_BIMC_MONITOR_T_BIMC_CHAIN_RCV_ERROR_DEFAULT  (1'h 0)

`define CR_KME_BIMC_MONITOR_T_RCV_INVALID_OPCODE_DECL   0:0
`define CR_KME_BIMC_MONITOR_T_RCV_INVALID_OPCODE_WIDTH  1
  `define CR_KME_BIMC_MONITOR_T_RCV_INVALID_OPCODE_DEFAULT  (1'h 0)

`define CR_KME_BIMC_MONITOR_T_UNANSWERED_READ_DECL   0:0
`define CR_KME_BIMC_MONITOR_T_UNANSWERED_READ_WIDTH  1
  `define CR_KME_BIMC_MONITOR_T_UNANSWERED_READ_DEFAULT  (1'h 0)

`define CR_KME_FULL_BIMC_MONITOR_T_DECL   31:0
`define CR_KME_FULL_BIMC_MONITOR_T_WIDTH  32
  `define CR_KME_FULL_BIMC_MONITOR_T_UNCORRECTABLE_ECC_ERROR  0
  `define CR_KME_FULL_BIMC_MONITOR_T_CORRECTABLE_ECC_ERROR    1
  `define CR_KME_FULL_BIMC_MONITOR_T_PARITY_ERROR             2
  `define CR_KME_FULL_BIMC_MONITOR_T_RESERVE                  3
  `define CR_KME_FULL_BIMC_MONITOR_T_BIMC_CHAIN_RCV_ERROR     4
  `define CR_KME_FULL_BIMC_MONITOR_T_RCV_INVALID_OPCODE       5
  `define CR_KME_FULL_BIMC_MONITOR_T_UNANSWERED_READ          6
  `define CR_KME_FULL_BIMC_MONITOR_T_RESERVED0                31:7

`define CR_KME_C_BIMC_MONITOR_T_DECL   6:0
`define CR_KME_C_BIMC_MONITOR_T_WIDTH  7
  `define CR_KME_C_BIMC_MONITOR_T_UNCORRECTABLE_ECC_ERROR  0
  `define CR_KME_C_BIMC_MONITOR_T_CORRECTABLE_ECC_ERROR    1
  `define CR_KME_C_BIMC_MONITOR_T_PARITY_ERROR             2
  `define CR_KME_C_BIMC_MONITOR_T_RESERVE                  3
  `define CR_KME_C_BIMC_MONITOR_T_BIMC_CHAIN_RCV_ERROR     4
  `define CR_KME_C_BIMC_MONITOR_T_RCV_INVALID_OPCODE       5
  `define CR_KME_C_BIMC_MONITOR_T_UNANSWERED_READ          6

`define CR_KME_BIMC_MONITOR_MASK_T_DECL   31:0
`define CR_KME_BIMC_MONITOR_MASK_T_WIDTH  32
  `define CR_KME_BIMC_MONITOR_MASK_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_MONITOR_MASK_T_UNCORRECTABLE_ECC_ERROR_ENABLE_DECL   0:0
`define CR_KME_BIMC_MONITOR_MASK_T_UNCORRECTABLE_ECC_ERROR_ENABLE_WIDTH  1
  `define CR_KME_BIMC_MONITOR_MASK_T_UNCORRECTABLE_ECC_ERROR_ENABLE_DEFAULT  (1'h 0)

`define CR_KME_BIMC_MONITOR_MASK_T_CORRECTABLE_ECC_ERROR_ENABLE_DECL   0:0
`define CR_KME_BIMC_MONITOR_MASK_T_CORRECTABLE_ECC_ERROR_ENABLE_WIDTH  1
  `define CR_KME_BIMC_MONITOR_MASK_T_CORRECTABLE_ECC_ERROR_ENABLE_DEFAULT  (1'h 0)

`define CR_KME_BIMC_MONITOR_MASK_T_PARITY_ERROR_ENABLE_DECL   0:0
`define CR_KME_BIMC_MONITOR_MASK_T_PARITY_ERROR_ENABLE_WIDTH  1
  `define CR_KME_BIMC_MONITOR_MASK_T_PARITY_ERROR_ENABLE_DEFAULT  (1'h 0)

`define CR_KME_BIMC_MONITOR_MASK_T_RESERVE_DECL   0:0
`define CR_KME_BIMC_MONITOR_MASK_T_RESERVE_WIDTH  1
  `define CR_KME_BIMC_MONITOR_MASK_T_RESERVE_DEFAULT  (1'h 0)

`define CR_KME_BIMC_MONITOR_MASK_T_BIMC_CHAIN_RCV_ERROR_ENABLE_DECL   0:0
`define CR_KME_BIMC_MONITOR_MASK_T_BIMC_CHAIN_RCV_ERROR_ENABLE_WIDTH  1
  `define CR_KME_BIMC_MONITOR_MASK_T_BIMC_CHAIN_RCV_ERROR_ENABLE_DEFAULT  (1'h 0)

`define CR_KME_BIMC_MONITOR_MASK_T_RCV_INVALID_OPCODE_DECL   0:0
`define CR_KME_BIMC_MONITOR_MASK_T_RCV_INVALID_OPCODE_WIDTH  1
  `define CR_KME_BIMC_MONITOR_MASK_T_RCV_INVALID_OPCODE_DEFAULT  (1'h 0)

`define CR_KME_BIMC_MONITOR_MASK_T_UNANSWERED_READ_DECL   0:0
`define CR_KME_BIMC_MONITOR_MASK_T_UNANSWERED_READ_WIDTH  1
  `define CR_KME_BIMC_MONITOR_MASK_T_UNANSWERED_READ_DEFAULT  (1'h 0)

`define CR_KME_FULL_BIMC_MONITOR_MASK_T_DECL   31:0
`define CR_KME_FULL_BIMC_MONITOR_MASK_T_WIDTH  32
  `define CR_KME_FULL_BIMC_MONITOR_MASK_T_UNCORRECTABLE_ECC_ERROR_ENABLE  0
  `define CR_KME_FULL_BIMC_MONITOR_MASK_T_CORRECTABLE_ECC_ERROR_ENABLE    1
  `define CR_KME_FULL_BIMC_MONITOR_MASK_T_PARITY_ERROR_ENABLE             2
  `define CR_KME_FULL_BIMC_MONITOR_MASK_T_RESERVE                         3
  `define CR_KME_FULL_BIMC_MONITOR_MASK_T_BIMC_CHAIN_RCV_ERROR_ENABLE     4
  `define CR_KME_FULL_BIMC_MONITOR_MASK_T_RCV_INVALID_OPCODE              5
  `define CR_KME_FULL_BIMC_MONITOR_MASK_T_UNANSWERED_READ                 6
  `define CR_KME_FULL_BIMC_MONITOR_MASK_T_RESERVED0                       31:7

`define CR_KME_C_BIMC_MONITOR_MASK_T_DECL   6:0
`define CR_KME_C_BIMC_MONITOR_MASK_T_WIDTH  7
  `define CR_KME_C_BIMC_MONITOR_MASK_T_UNCORRECTABLE_ECC_ERROR_ENABLE  0
  `define CR_KME_C_BIMC_MONITOR_MASK_T_CORRECTABLE_ECC_ERROR_ENABLE    1
  `define CR_KME_C_BIMC_MONITOR_MASK_T_PARITY_ERROR_ENABLE             2
  `define CR_KME_C_BIMC_MONITOR_MASK_T_RESERVE                         3
  `define CR_KME_C_BIMC_MONITOR_MASK_T_BIMC_CHAIN_RCV_ERROR_ENABLE     4
  `define CR_KME_C_BIMC_MONITOR_MASK_T_RCV_INVALID_OPCODE              5
  `define CR_KME_C_BIMC_MONITOR_MASK_T_UNANSWERED_READ                 6

`define CR_KME_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL   31:0
`define CR_KME_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_WIDTH  32
  `define CR_KME_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_UNCORRECTABLE_ECC_DECL   31:0
`define CR_KME_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_UNCORRECTABLE_ECC_WIDTH  32
  `define CR_KME_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_UNCORRECTABLE_ECC_DEFAULT  (32'h 0)

`define CR_KME_FULL_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL   31:0
`define CR_KME_FULL_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_WIDTH  32
  `define CR_KME_FULL_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_UNCORRECTABLE_ECC  31:00

`define CR_KME_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL   31:0
`define CR_KME_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_WIDTH  32
  `define CR_KME_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_UNCORRECTABLE_ECC  31:00

`define CR_KME_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL   31:0
`define CR_KME_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_WIDTH  32
  `define CR_KME_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_CORRECTABLE_ECC_DECL   31:0
`define CR_KME_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_CORRECTABLE_ECC_WIDTH  32
  `define CR_KME_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_CORRECTABLE_ECC_DEFAULT  (32'h 0)

`define CR_KME_FULL_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL   31:0
`define CR_KME_FULL_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_WIDTH  32
  `define CR_KME_FULL_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_CORRECTABLE_ECC  31:00

`define CR_KME_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL   31:0
`define CR_KME_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_WIDTH  32
  `define CR_KME_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_CORRECTABLE_ECC  31:00

`define CR_KME_BIMC_PARITY_ERROR_CNT_T_DECL   31:0
`define CR_KME_BIMC_PARITY_ERROR_CNT_T_WIDTH  32
  `define CR_KME_BIMC_PARITY_ERROR_CNT_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_PARITY_ERROR_CNT_T_PARITY_ERRORS_DECL   31:0
`define CR_KME_BIMC_PARITY_ERROR_CNT_T_PARITY_ERRORS_WIDTH  32
  `define CR_KME_BIMC_PARITY_ERROR_CNT_T_PARITY_ERRORS_DEFAULT  (32'h 0)

`define CR_KME_FULL_BIMC_PARITY_ERROR_CNT_T_DECL   31:0
`define CR_KME_FULL_BIMC_PARITY_ERROR_CNT_T_WIDTH  32
  `define CR_KME_FULL_BIMC_PARITY_ERROR_CNT_T_PARITY_ERRORS  31:00

`define CR_KME_C_BIMC_PARITY_ERROR_CNT_T_DECL   31:0
`define CR_KME_C_BIMC_PARITY_ERROR_CNT_T_WIDTH  32
  `define CR_KME_C_BIMC_PARITY_ERROR_CNT_T_PARITY_ERRORS  31:00

`define CR_KME_BIMC_GLOBAL_CONFIG_T_DECL   31:0
`define CR_KME_BIMC_GLOBAL_CONFIG_T_WIDTH  32
  `define CR_KME_BIMC_GLOBAL_CONFIG_T_DEFAULT  (32'h 1)

`define CR_KME_BIMC_GLOBAL_CONFIG_T_SOFT_RESET_DECL   0:0
`define CR_KME_BIMC_GLOBAL_CONFIG_T_SOFT_RESET_WIDTH  1
  `define CR_KME_BIMC_GLOBAL_CONFIG_T_SOFT_RESET_DEFAULT  (1'h 1)

`define CR_KME_BIMC_GLOBAL_CONFIG_T_RESERVE_DECL   0:0
`define CR_KME_BIMC_GLOBAL_CONFIG_T_RESERVE_WIDTH  1
  `define CR_KME_BIMC_GLOBAL_CONFIG_T_RESERVE_DEFAULT  (1'h 0)

`define CR_KME_BIMC_GLOBAL_CONFIG_T_BIMC_MEM_INIT_DONE_DECL   0:0
`define CR_KME_BIMC_GLOBAL_CONFIG_T_BIMC_MEM_INIT_DONE_WIDTH  1
  `define CR_KME_BIMC_GLOBAL_CONFIG_T_BIMC_MEM_INIT_DONE_DEFAULT  (1'h 0)

`define CR_KME_BIMC_GLOBAL_CONFIG_T_MEM_WR_INIT_DECL   0:0
`define CR_KME_BIMC_GLOBAL_CONFIG_T_MEM_WR_INIT_WIDTH  1
  `define CR_KME_BIMC_GLOBAL_CONFIG_T_MEM_WR_INIT_DEFAULT  (1'h 0)

`define CR_KME_BIMC_GLOBAL_CONFIG_T_POLL_ECC_PAR_ERROR_DECL   0:0
`define CR_KME_BIMC_GLOBAL_CONFIG_T_POLL_ECC_PAR_ERROR_WIDTH  1
  `define CR_KME_BIMC_GLOBAL_CONFIG_T_POLL_ECC_PAR_ERROR_DEFAULT  (1'h 0)

`define CR_KME_BIMC_GLOBAL_CONFIG_T_DEBUG_WRITE_EN_DECL   0:0
`define CR_KME_BIMC_GLOBAL_CONFIG_T_DEBUG_WRITE_EN_WIDTH  1
  `define CR_KME_BIMC_GLOBAL_CONFIG_T_DEBUG_WRITE_EN_DEFAULT  (1'h 0)

`define CR_KME_BIMC_GLOBAL_CONFIG_T_POLL_ECC_PAR_TIMER_DECL   25:0
`define CR_KME_BIMC_GLOBAL_CONFIG_T_POLL_ECC_PAR_TIMER_WIDTH  26
  `define CR_KME_BIMC_GLOBAL_CONFIG_T_POLL_ECC_PAR_TIMER_DEFAULT  (26'h 0)

`define CR_KME_FULL_BIMC_GLOBAL_CONFIG_T_DECL   31:0
`define CR_KME_FULL_BIMC_GLOBAL_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_BIMC_GLOBAL_CONFIG_T_SOFT_RESET          00
  `define CR_KME_FULL_BIMC_GLOBAL_CONFIG_T_RESERVE             01
  `define CR_KME_FULL_BIMC_GLOBAL_CONFIG_T_BIMC_MEM_INIT_DONE  02
  `define CR_KME_FULL_BIMC_GLOBAL_CONFIG_T_MEM_WR_INIT         03
  `define CR_KME_FULL_BIMC_GLOBAL_CONFIG_T_POLL_ECC_PAR_ERROR  04
  `define CR_KME_FULL_BIMC_GLOBAL_CONFIG_T_DEBUG_WRITE_EN      05
  `define CR_KME_FULL_BIMC_GLOBAL_CONFIG_T_POLL_ECC_PAR_TIMER  31:06

`define CR_KME_C_BIMC_GLOBAL_CONFIG_T_DECL   31:0
`define CR_KME_C_BIMC_GLOBAL_CONFIG_T_WIDTH  32
  `define CR_KME_C_BIMC_GLOBAL_CONFIG_T_SOFT_RESET          00
  `define CR_KME_C_BIMC_GLOBAL_CONFIG_T_RESERVE             01
  `define CR_KME_C_BIMC_GLOBAL_CONFIG_T_BIMC_MEM_INIT_DONE  02
  `define CR_KME_C_BIMC_GLOBAL_CONFIG_T_MEM_WR_INIT         03
  `define CR_KME_C_BIMC_GLOBAL_CONFIG_T_POLL_ECC_PAR_ERROR  04
  `define CR_KME_C_BIMC_GLOBAL_CONFIG_T_DEBUG_WRITE_EN      05
  `define CR_KME_C_BIMC_GLOBAL_CONFIG_T_POLL_ECC_PAR_TIMER  31:06

`define CR_KME_BIMC_MEMID_T_DECL   31:0
`define CR_KME_BIMC_MEMID_T_WIDTH  32
  `define CR_KME_BIMC_MEMID_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_MEMID_T_MAX_MEMID_DECL   11:0
`define CR_KME_BIMC_MEMID_T_MAX_MEMID_WIDTH  12
  `define CR_KME_BIMC_MEMID_T_MAX_MEMID_DEFAULT  (12'h 0)

`define CR_KME_FULL_BIMC_MEMID_T_DECL   31:0
`define CR_KME_FULL_BIMC_MEMID_T_WIDTH  32
  `define CR_KME_FULL_BIMC_MEMID_T_MAX_MEMID  11:00
  `define CR_KME_FULL_BIMC_MEMID_T_RESERVED0  31:12

`define CR_KME_C_BIMC_MEMID_T_DECL   11:0
`define CR_KME_C_BIMC_MEMID_T_WIDTH  12
  `define CR_KME_C_BIMC_MEMID_T_MAX_MEMID  11:00

`define CR_KME_BIMC_ECCPAR_DEBUG_T_DECL   31:0
`define CR_KME_BIMC_ECCPAR_DEBUG_T_WIDTH  32
  `define CR_KME_BIMC_ECCPAR_DEBUG_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_ECCPAR_DEBUG_T_MEMADDR_DECL   11:0
`define CR_KME_BIMC_ECCPAR_DEBUG_T_MEMADDR_WIDTH  12
  `define CR_KME_BIMC_ECCPAR_DEBUG_T_MEMADDR_DEFAULT  (12'h 0)

`define CR_KME_BIMC_ECCPAR_DEBUG_T_MEMTYPE_DECL   3:0
`define CR_KME_BIMC_ECCPAR_DEBUG_T_MEMTYPE_WIDTH  4
  `define CR_KME_BIMC_ECCPAR_DEBUG_T_MEMTYPE_DEFAULT  (4'h 0)

`define CR_KME_BIMC_ECCPAR_DEBUG_T_ECCPAR_CORRUPT_DECL   1:0
`define CR_KME_BIMC_ECCPAR_DEBUG_T_ECCPAR_CORRUPT_WIDTH  2
  `define CR_KME_BIMC_ECCPAR_DEBUG_T_ECCPAR_CORRUPT_DEFAULT  (2'h 0)

`define CR_KME_BIMC_ECCPAR_DEBUG_T_RESERVE_DECL   1:0
`define CR_KME_BIMC_ECCPAR_DEBUG_T_RESERVE_WIDTH  2
  `define CR_KME_BIMC_ECCPAR_DEBUG_T_RESERVE_DEFAULT  (2'h 0)

`define CR_KME_BIMC_ECCPAR_DEBUG_T_ECCPAR_DISABLE_DECL   1:0
`define CR_KME_BIMC_ECCPAR_DEBUG_T_ECCPAR_DISABLE_WIDTH  2
  `define CR_KME_BIMC_ECCPAR_DEBUG_T_ECCPAR_DISABLE_DEFAULT  (2'h 0)

`define CR_KME_BIMC_ECCPAR_DEBUG_T_SEND_DECL   0:0
`define CR_KME_BIMC_ECCPAR_DEBUG_T_SEND_WIDTH  1
  `define CR_KME_BIMC_ECCPAR_DEBUG_T_SEND_DEFAULT  (1'h 0)

`define CR_KME_BIMC_ECCPAR_DEBUG_T_SENT_DECL   0:0
`define CR_KME_BIMC_ECCPAR_DEBUG_T_SENT_WIDTH  1
  `define CR_KME_BIMC_ECCPAR_DEBUG_T_SENT_DEFAULT  (1'h 0)

`define CR_KME_BIMC_ECCPAR_DEBUG_T_JABBER_OFF_DECL   3:0
`define CR_KME_BIMC_ECCPAR_DEBUG_T_JABBER_OFF_WIDTH  4
  `define CR_KME_BIMC_ECCPAR_DEBUG_T_JABBER_OFF_DEFAULT  (4'h 0)

`define CR_KME_BIMC_ECCPAR_DEBUG_T_ACK_DECL   0:0
`define CR_KME_BIMC_ECCPAR_DEBUG_T_ACK_WIDTH  1
  `define CR_KME_BIMC_ECCPAR_DEBUG_T_ACK_DEFAULT  (1'h 0)

`define CR_KME_FULL_BIMC_ECCPAR_DEBUG_T_DECL   31:0
`define CR_KME_FULL_BIMC_ECCPAR_DEBUG_T_WIDTH  32
  `define CR_KME_FULL_BIMC_ECCPAR_DEBUG_T_MEMADDR         11:00
  `define CR_KME_FULL_BIMC_ECCPAR_DEBUG_T_MEMTYPE         15:12
  `define CR_KME_FULL_BIMC_ECCPAR_DEBUG_T_ECCPAR_CORRUPT  17:16
  `define CR_KME_FULL_BIMC_ECCPAR_DEBUG_T_RESERVE         19:18
  `define CR_KME_FULL_BIMC_ECCPAR_DEBUG_T_ECCPAR_DISABLE  21:20
  `define CR_KME_FULL_BIMC_ECCPAR_DEBUG_T_SEND            22
  `define CR_KME_FULL_BIMC_ECCPAR_DEBUG_T_SENT            23
  `define CR_KME_FULL_BIMC_ECCPAR_DEBUG_T_JABBER_OFF      27:24
  `define CR_KME_FULL_BIMC_ECCPAR_DEBUG_T_ACK             28
  `define CR_KME_FULL_BIMC_ECCPAR_DEBUG_T_RESERVED0       31:29

`define CR_KME_C_BIMC_ECCPAR_DEBUG_T_DECL   28:0
`define CR_KME_C_BIMC_ECCPAR_DEBUG_T_WIDTH  29
  `define CR_KME_C_BIMC_ECCPAR_DEBUG_T_MEMADDR         11:00
  `define CR_KME_C_BIMC_ECCPAR_DEBUG_T_MEMTYPE         15:12
  `define CR_KME_C_BIMC_ECCPAR_DEBUG_T_ECCPAR_CORRUPT  17:16
  `define CR_KME_C_BIMC_ECCPAR_DEBUG_T_RESERVE         19:18
  `define CR_KME_C_BIMC_ECCPAR_DEBUG_T_ECCPAR_DISABLE  21:20
  `define CR_KME_C_BIMC_ECCPAR_DEBUG_T_SEND            22
  `define CR_KME_C_BIMC_ECCPAR_DEBUG_T_SENT            23
  `define CR_KME_C_BIMC_ECCPAR_DEBUG_T_JABBER_OFF      27:24
  `define CR_KME_C_BIMC_ECCPAR_DEBUG_T_ACK             28

`define CR_KME_BIMC_CMD2_T_DECL   31:0
`define CR_KME_BIMC_CMD2_T_WIDTH  32
  `define CR_KME_BIMC_CMD2_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_CMD2_T_OPCODE_DECL   7:0
`define CR_KME_BIMC_CMD2_T_OPCODE_WIDTH  8
  `define CR_KME_BIMC_CMD2_T_OPCODE_DEFAULT  (8'h 0)

`define CR_KME_BIMC_CMD2_T_SEND_DECL   0:0
`define CR_KME_BIMC_CMD2_T_SEND_WIDTH  1
  `define CR_KME_BIMC_CMD2_T_SEND_DEFAULT  (1'h 0)

`define CR_KME_BIMC_CMD2_T_SENT_DECL   0:0
`define CR_KME_BIMC_CMD2_T_SENT_WIDTH  1
  `define CR_KME_BIMC_CMD2_T_SENT_DEFAULT  (1'h 0)

`define CR_KME_BIMC_CMD2_T_ACK_DECL   0:0
`define CR_KME_BIMC_CMD2_T_ACK_WIDTH  1
  `define CR_KME_BIMC_CMD2_T_ACK_DEFAULT  (1'h 0)

`define CR_KME_FULL_BIMC_CMD2_T_DECL   31:0
`define CR_KME_FULL_BIMC_CMD2_T_WIDTH  32
  `define CR_KME_FULL_BIMC_CMD2_T_OPCODE     07:00
  `define CR_KME_FULL_BIMC_CMD2_T_SEND       08
  `define CR_KME_FULL_BIMC_CMD2_T_SENT       09
  `define CR_KME_FULL_BIMC_CMD2_T_ACK        10
  `define CR_KME_FULL_BIMC_CMD2_T_RESERVED0  31:11

`define CR_KME_C_BIMC_CMD2_T_DECL   10:0
`define CR_KME_C_BIMC_CMD2_T_WIDTH  11
  `define CR_KME_C_BIMC_CMD2_T_OPCODE  07:00
  `define CR_KME_C_BIMC_CMD2_T_SEND    08
  `define CR_KME_C_BIMC_CMD2_T_SENT    09
  `define CR_KME_C_BIMC_CMD2_T_ACK     10

`define CR_KME_BIMC_CMD1_T_DECL   31:0
`define CR_KME_BIMC_CMD1_T_WIDTH  32
  `define CR_KME_BIMC_CMD1_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_CMD1_T_ADDR_DECL   15:0
`define CR_KME_BIMC_CMD1_T_ADDR_WIDTH  16
  `define CR_KME_BIMC_CMD1_T_ADDR_DEFAULT  (16'h 0)

`define CR_KME_BIMC_CMD1_T_MEM_DECL   11:0
`define CR_KME_BIMC_CMD1_T_MEM_WIDTH  12
  `define CR_KME_BIMC_CMD1_T_MEM_DEFAULT  (12'h 0)

`define CR_KME_BIMC_CMD1_T_MEMTYPE_DECL   3:0
`define CR_KME_BIMC_CMD1_T_MEMTYPE_WIDTH  4
  `define CR_KME_BIMC_CMD1_T_MEMTYPE_DEFAULT  (4'h 0)

`define CR_KME_FULL_BIMC_CMD1_T_DECL   31:0
`define CR_KME_FULL_BIMC_CMD1_T_WIDTH  32
  `define CR_KME_FULL_BIMC_CMD1_T_ADDR     15:00
  `define CR_KME_FULL_BIMC_CMD1_T_MEM      27:16
  `define CR_KME_FULL_BIMC_CMD1_T_MEMTYPE  31:28

`define CR_KME_C_BIMC_CMD1_T_DECL   31:0
`define CR_KME_C_BIMC_CMD1_T_WIDTH  32
  `define CR_KME_C_BIMC_CMD1_T_ADDR     15:00
  `define CR_KME_C_BIMC_CMD1_T_MEM      27:16
  `define CR_KME_C_BIMC_CMD1_T_MEMTYPE  31:28

`define CR_KME_BIMC_CMD0_T_DECL   31:0
`define CR_KME_BIMC_CMD0_T_WIDTH  32
  `define CR_KME_BIMC_CMD0_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_CMD0_T_DATA_DECL   31:0
`define CR_KME_BIMC_CMD0_T_DATA_WIDTH  32
  `define CR_KME_BIMC_CMD0_T_DATA_DEFAULT  (32'h 0)

`define CR_KME_FULL_BIMC_CMD0_T_DECL   31:0
`define CR_KME_FULL_BIMC_CMD0_T_WIDTH  32
  `define CR_KME_FULL_BIMC_CMD0_T_DATA  31:00

`define CR_KME_C_BIMC_CMD0_T_DECL   31:0
`define CR_KME_C_BIMC_CMD0_T_WIDTH  32
  `define CR_KME_C_BIMC_CMD0_T_DATA  31:00

`define CR_KME_BIMC_RXCMD2_T_DECL   31:0
`define CR_KME_BIMC_RXCMD2_T_WIDTH  32
  `define CR_KME_BIMC_RXCMD2_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_RXCMD2_T_OPCODE_DECL   7:0
`define CR_KME_BIMC_RXCMD2_T_OPCODE_WIDTH  8
  `define CR_KME_BIMC_RXCMD2_T_OPCODE_DEFAULT  (8'h 0)

`define CR_KME_BIMC_RXCMD2_T_RXFLAG_DECL   0:0
`define CR_KME_BIMC_RXCMD2_T_RXFLAG_WIDTH  1
  `define CR_KME_BIMC_RXCMD2_T_RXFLAG_DEFAULT  (1'h 0)

`define CR_KME_BIMC_RXCMD2_T_ACK_DECL   0:0
`define CR_KME_BIMC_RXCMD2_T_ACK_WIDTH  1

`define CR_KME_FULL_BIMC_RXCMD2_T_DECL   31:0
`define CR_KME_FULL_BIMC_RXCMD2_T_WIDTH  32
  `define CR_KME_FULL_BIMC_RXCMD2_T_OPCODE     7:0
  `define CR_KME_FULL_BIMC_RXCMD2_T_RXFLAG     8
  `define CR_KME_FULL_BIMC_RXCMD2_T_ACK        9
  `define CR_KME_FULL_BIMC_RXCMD2_T_RESERVED0  31:10

`define CR_KME_C_BIMC_RXCMD2_T_DECL   9:0
`define CR_KME_C_BIMC_RXCMD2_T_WIDTH  10
  `define CR_KME_C_BIMC_RXCMD2_T_OPCODE  7:0
  `define CR_KME_C_BIMC_RXCMD2_T_RXFLAG  8
  `define CR_KME_C_BIMC_RXCMD2_T_ACK     9

`define CR_KME_BIMC_RXCMD1_T_DECL   31:0
`define CR_KME_BIMC_RXCMD1_T_WIDTH  32
  `define CR_KME_BIMC_RXCMD1_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_RXCMD1_T_ADDR_DECL   15:0
`define CR_KME_BIMC_RXCMD1_T_ADDR_WIDTH  16
  `define CR_KME_BIMC_RXCMD1_T_ADDR_DEFAULT  (16'h 0)

`define CR_KME_BIMC_RXCMD1_T_MEM_DECL   11:0
`define CR_KME_BIMC_RXCMD1_T_MEM_WIDTH  12
  `define CR_KME_BIMC_RXCMD1_T_MEM_DEFAULT  (12'h 0)

`define CR_KME_BIMC_RXCMD1_T_MEMTYPE_DECL   3:0
`define CR_KME_BIMC_RXCMD1_T_MEMTYPE_WIDTH  4
  `define CR_KME_BIMC_RXCMD1_T_MEMTYPE_DEFAULT  (4'h 0)

`define CR_KME_FULL_BIMC_RXCMD1_T_DECL   31:0
`define CR_KME_FULL_BIMC_RXCMD1_T_WIDTH  32
  `define CR_KME_FULL_BIMC_RXCMD1_T_ADDR     15:00
  `define CR_KME_FULL_BIMC_RXCMD1_T_MEM      27:16
  `define CR_KME_FULL_BIMC_RXCMD1_T_MEMTYPE  31:28

`define CR_KME_C_BIMC_RXCMD1_T_DECL   31:0
`define CR_KME_C_BIMC_RXCMD1_T_WIDTH  32
  `define CR_KME_C_BIMC_RXCMD1_T_ADDR     15:00
  `define CR_KME_C_BIMC_RXCMD1_T_MEM      27:16
  `define CR_KME_C_BIMC_RXCMD1_T_MEMTYPE  31:28

`define CR_KME_BIMC_RXCMD0_T_DECL   31:0
`define CR_KME_BIMC_RXCMD0_T_WIDTH  32
  `define CR_KME_BIMC_RXCMD0_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_RXCMD0_T_DATA_DECL   31:0
`define CR_KME_BIMC_RXCMD0_T_DATA_WIDTH  32
  `define CR_KME_BIMC_RXCMD0_T_DATA_DEFAULT  (32'h 0)

`define CR_KME_FULL_BIMC_RXCMD0_T_DECL   31:0
`define CR_KME_FULL_BIMC_RXCMD0_T_WIDTH  32
  `define CR_KME_FULL_BIMC_RXCMD0_T_DATA  31:00

`define CR_KME_C_BIMC_RXCMD0_T_DECL   31:0
`define CR_KME_C_BIMC_RXCMD0_T_WIDTH  32
  `define CR_KME_C_BIMC_RXCMD0_T_DATA  31:00

`define CR_KME_BIMC_RXRSP2_T_DECL   31:0
`define CR_KME_BIMC_RXRSP2_T_WIDTH  32
  `define CR_KME_BIMC_RXRSP2_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_RXRSP2_T_DATA_DECL   7:0
`define CR_KME_BIMC_RXRSP2_T_DATA_WIDTH  8
  `define CR_KME_BIMC_RXRSP2_T_DATA_DEFAULT  (8'h 0)

`define CR_KME_BIMC_RXRSP2_T_RXFLAG_DECL   0:0
`define CR_KME_BIMC_RXRSP2_T_RXFLAG_WIDTH  1
  `define CR_KME_BIMC_RXRSP2_T_RXFLAG_DEFAULT  (1'h 0)

`define CR_KME_BIMC_RXRSP2_T_ACK_DECL   0:0
`define CR_KME_BIMC_RXRSP2_T_ACK_WIDTH  1

`define CR_KME_FULL_BIMC_RXRSP2_T_DECL   31:0
`define CR_KME_FULL_BIMC_RXRSP2_T_WIDTH  32
  `define CR_KME_FULL_BIMC_RXRSP2_T_DATA       7:0
  `define CR_KME_FULL_BIMC_RXRSP2_T_RXFLAG     8
  `define CR_KME_FULL_BIMC_RXRSP2_T_ACK        9
  `define CR_KME_FULL_BIMC_RXRSP2_T_RESERVED0  31:10

`define CR_KME_C_BIMC_RXRSP2_T_DECL   9:0
`define CR_KME_C_BIMC_RXRSP2_T_WIDTH  10
  `define CR_KME_C_BIMC_RXRSP2_T_DATA    7:0
  `define CR_KME_C_BIMC_RXRSP2_T_RXFLAG  8
  `define CR_KME_C_BIMC_RXRSP2_T_ACK     9

`define CR_KME_BIMC_RXRSP1_T_DECL   31:0
`define CR_KME_BIMC_RXRSP1_T_WIDTH  32
  `define CR_KME_BIMC_RXRSP1_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_RXRSP1_T_DATA_DECL   31:0
`define CR_KME_BIMC_RXRSP1_T_DATA_WIDTH  32
  `define CR_KME_BIMC_RXRSP1_T_DATA_DEFAULT  (32'h 0)

`define CR_KME_FULL_BIMC_RXRSP1_T_DECL   31:0
`define CR_KME_FULL_BIMC_RXRSP1_T_WIDTH  32
  `define CR_KME_FULL_BIMC_RXRSP1_T_DATA  31:00

`define CR_KME_C_BIMC_RXRSP1_T_DECL   31:0
`define CR_KME_C_BIMC_RXRSP1_T_WIDTH  32
  `define CR_KME_C_BIMC_RXRSP1_T_DATA  31:00

`define CR_KME_BIMC_RXRSP0_T_DECL   31:0
`define CR_KME_BIMC_RXRSP0_T_WIDTH  32
  `define CR_KME_BIMC_RXRSP0_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_RXRSP0_T_DATA_DECL   31:0
`define CR_KME_BIMC_RXRSP0_T_DATA_WIDTH  32
  `define CR_KME_BIMC_RXRSP0_T_DATA_DEFAULT  (32'h 0)

`define CR_KME_FULL_BIMC_RXRSP0_T_DECL   31:0
`define CR_KME_FULL_BIMC_RXRSP0_T_WIDTH  32
  `define CR_KME_FULL_BIMC_RXRSP0_T_DATA  31:00

`define CR_KME_C_BIMC_RXRSP0_T_DECL   31:0
`define CR_KME_C_BIMC_RXRSP0_T_WIDTH  32
  `define CR_KME_C_BIMC_RXRSP0_T_DATA  31:00

`define CR_KME_BIMC_POLLRSP2_T_DECL   31:0
`define CR_KME_BIMC_POLLRSP2_T_WIDTH  32
  `define CR_KME_BIMC_POLLRSP2_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_POLLRSP2_T_DATA_DECL   7:0
`define CR_KME_BIMC_POLLRSP2_T_DATA_WIDTH  8
  `define CR_KME_BIMC_POLLRSP2_T_DATA_DEFAULT  (8'h 0)

`define CR_KME_BIMC_POLLRSP2_T_RXFLAG_DECL   0:0
`define CR_KME_BIMC_POLLRSP2_T_RXFLAG_WIDTH  1
  `define CR_KME_BIMC_POLLRSP2_T_RXFLAG_DEFAULT  (1'h 0)

`define CR_KME_BIMC_POLLRSP2_T_ACK_DECL   0:0
`define CR_KME_BIMC_POLLRSP2_T_ACK_WIDTH  1

`define CR_KME_FULL_BIMC_POLLRSP2_T_DECL   31:0
`define CR_KME_FULL_BIMC_POLLRSP2_T_WIDTH  32
  `define CR_KME_FULL_BIMC_POLLRSP2_T_DATA       7:0
  `define CR_KME_FULL_BIMC_POLLRSP2_T_RXFLAG     8
  `define CR_KME_FULL_BIMC_POLLRSP2_T_ACK        9
  `define CR_KME_FULL_BIMC_POLLRSP2_T_RESERVED0  31:10

`define CR_KME_C_BIMC_POLLRSP2_T_DECL   9:0
`define CR_KME_C_BIMC_POLLRSP2_T_WIDTH  10
  `define CR_KME_C_BIMC_POLLRSP2_T_DATA    7:0
  `define CR_KME_C_BIMC_POLLRSP2_T_RXFLAG  8
  `define CR_KME_C_BIMC_POLLRSP2_T_ACK     9

`define CR_KME_BIMC_POLLRSP1_T_DECL   31:0
`define CR_KME_BIMC_POLLRSP1_T_WIDTH  32
  `define CR_KME_BIMC_POLLRSP1_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_POLLRSP1_T_DATA_DECL   31:0
`define CR_KME_BIMC_POLLRSP1_T_DATA_WIDTH  32
  `define CR_KME_BIMC_POLLRSP1_T_DATA_DEFAULT  (32'h 0)

`define CR_KME_FULL_BIMC_POLLRSP1_T_DECL   31:0
`define CR_KME_FULL_BIMC_POLLRSP1_T_WIDTH  32
  `define CR_KME_FULL_BIMC_POLLRSP1_T_DATA  31:00

`define CR_KME_C_BIMC_POLLRSP1_T_DECL   31:0
`define CR_KME_C_BIMC_POLLRSP1_T_WIDTH  32
  `define CR_KME_C_BIMC_POLLRSP1_T_DATA  31:00

`define CR_KME_BIMC_POLLRSP0_T_DECL   31:0
`define CR_KME_BIMC_POLLRSP0_T_WIDTH  32
  `define CR_KME_BIMC_POLLRSP0_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_POLLRSP0_T_DATA_DECL   31:0
`define CR_KME_BIMC_POLLRSP0_T_DATA_WIDTH  32
  `define CR_KME_BIMC_POLLRSP0_T_DATA_DEFAULT  (32'h 0)

`define CR_KME_FULL_BIMC_POLLRSP0_T_DECL   31:0
`define CR_KME_FULL_BIMC_POLLRSP0_T_WIDTH  32
  `define CR_KME_FULL_BIMC_POLLRSP0_T_DATA  31:00

`define CR_KME_C_BIMC_POLLRSP0_T_DECL   31:0
`define CR_KME_C_BIMC_POLLRSP0_T_WIDTH  32
  `define CR_KME_C_BIMC_POLLRSP0_T_DATA  31:00

`define CR_KME_BIMC_DBGCMD2_T_DECL   31:0
`define CR_KME_BIMC_DBGCMD2_T_WIDTH  32
  `define CR_KME_BIMC_DBGCMD2_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_DBGCMD2_T_OPCODE_DECL   7:0
`define CR_KME_BIMC_DBGCMD2_T_OPCODE_WIDTH  8
  `define CR_KME_BIMC_DBGCMD2_T_OPCODE_DEFAULT  (8'h 0)

`define CR_KME_BIMC_DBGCMD2_T_RXFLAG_DECL   0:0
`define CR_KME_BIMC_DBGCMD2_T_RXFLAG_WIDTH  1
  `define CR_KME_BIMC_DBGCMD2_T_RXFLAG_DEFAULT  (1'h 0)

`define CR_KME_BIMC_DBGCMD2_T_ACK_DECL   0:0
`define CR_KME_BIMC_DBGCMD2_T_ACK_WIDTH  1

`define CR_KME_FULL_BIMC_DBGCMD2_T_DECL   31:0
`define CR_KME_FULL_BIMC_DBGCMD2_T_WIDTH  32
  `define CR_KME_FULL_BIMC_DBGCMD2_T_OPCODE     7:0
  `define CR_KME_FULL_BIMC_DBGCMD2_T_RXFLAG     8
  `define CR_KME_FULL_BIMC_DBGCMD2_T_ACK        9
  `define CR_KME_FULL_BIMC_DBGCMD2_T_RESERVED0  31:10

`define CR_KME_C_BIMC_DBGCMD2_T_DECL   9:0
`define CR_KME_C_BIMC_DBGCMD2_T_WIDTH  10
  `define CR_KME_C_BIMC_DBGCMD2_T_OPCODE  7:0
  `define CR_KME_C_BIMC_DBGCMD2_T_RXFLAG  8
  `define CR_KME_C_BIMC_DBGCMD2_T_ACK     9

`define CR_KME_BIMC_DBGCMD1_T_DECL   31:0
`define CR_KME_BIMC_DBGCMD1_T_WIDTH  32
  `define CR_KME_BIMC_DBGCMD1_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_DBGCMD1_T_ADDR_DECL   15:0
`define CR_KME_BIMC_DBGCMD1_T_ADDR_WIDTH  16
  `define CR_KME_BIMC_DBGCMD1_T_ADDR_DEFAULT  (16'h 0)

`define CR_KME_BIMC_DBGCMD1_T_MEM_DECL   11:0
`define CR_KME_BIMC_DBGCMD1_T_MEM_WIDTH  12
  `define CR_KME_BIMC_DBGCMD1_T_MEM_DEFAULT  (12'h 0)

`define CR_KME_BIMC_DBGCMD1_T_MEMTYPE_DECL   3:0
`define CR_KME_BIMC_DBGCMD1_T_MEMTYPE_WIDTH  4
  `define CR_KME_BIMC_DBGCMD1_T_MEMTYPE_DEFAULT  (4'h 0)

`define CR_KME_FULL_BIMC_DBGCMD1_T_DECL   31:0
`define CR_KME_FULL_BIMC_DBGCMD1_T_WIDTH  32
  `define CR_KME_FULL_BIMC_DBGCMD1_T_ADDR     15:00
  `define CR_KME_FULL_BIMC_DBGCMD1_T_MEM      27:16
  `define CR_KME_FULL_BIMC_DBGCMD1_T_MEMTYPE  31:28

`define CR_KME_C_BIMC_DBGCMD1_T_DECL   31:0
`define CR_KME_C_BIMC_DBGCMD1_T_WIDTH  32
  `define CR_KME_C_BIMC_DBGCMD1_T_ADDR     15:00
  `define CR_KME_C_BIMC_DBGCMD1_T_MEM      27:16
  `define CR_KME_C_BIMC_DBGCMD1_T_MEMTYPE  31:28

`define CR_KME_BIMC_DBGCMD0_T_DECL   31:0
`define CR_KME_BIMC_DBGCMD0_T_WIDTH  32
  `define CR_KME_BIMC_DBGCMD0_T_DEFAULT  (32'h 0)

`define CR_KME_BIMC_DBGCMD0_T_DATA_DECL   31:0
`define CR_KME_BIMC_DBGCMD0_T_DATA_WIDTH  32
  `define CR_KME_BIMC_DBGCMD0_T_DATA_DEFAULT  (32'h 0)

`define CR_KME_FULL_BIMC_DBGCMD0_T_DECL   31:0
`define CR_KME_FULL_BIMC_DBGCMD0_T_WIDTH  32
  `define CR_KME_FULL_BIMC_DBGCMD0_T_DATA  31:00

`define CR_KME_C_BIMC_DBGCMD0_T_DECL   31:0
`define CR_KME_C_BIMC_DBGCMD0_T_WIDTH  32
  `define CR_KME_C_BIMC_DBGCMD0_T_DATA  31:00

`define CR_KME_IM_AVAILABLE_T_DECL   31:0
`define CR_KME_IM_AVAILABLE_T_WIDTH  32
  `define CR_KME_IM_AVAILABLE_T_DEFAULT  (32'h 0)

`define CR_KME_IM_AVAILABLE_T_CCEIP0_BANK_LO_DECL   0:0
`define CR_KME_IM_AVAILABLE_T_CCEIP0_BANK_LO_WIDTH  1
  `define CR_KME_IM_AVAILABLE_T_CCEIP0_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_IM_AVAILABLE_T_CCEIP0_BANK_HI_DECL   0:0
`define CR_KME_IM_AVAILABLE_T_CCEIP0_BANK_HI_WIDTH  1
  `define CR_KME_IM_AVAILABLE_T_CCEIP0_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_IM_AVAILABLE_T_CCEIP1_BANK_LO_DECL   0:0
`define CR_KME_IM_AVAILABLE_T_CCEIP1_BANK_LO_WIDTH  1
  `define CR_KME_IM_AVAILABLE_T_CCEIP1_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_IM_AVAILABLE_T_CCEIP1_BANK_HI_DECL   0:0
`define CR_KME_IM_AVAILABLE_T_CCEIP1_BANK_HI_WIDTH  1
  `define CR_KME_IM_AVAILABLE_T_CCEIP1_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_IM_AVAILABLE_T_CCEIP2_BANK_LO_DECL   0:0
`define CR_KME_IM_AVAILABLE_T_CCEIP2_BANK_LO_WIDTH  1
  `define CR_KME_IM_AVAILABLE_T_CCEIP2_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_IM_AVAILABLE_T_CCEIP2_BANK_HI_DECL   0:0
`define CR_KME_IM_AVAILABLE_T_CCEIP2_BANK_HI_WIDTH  1
  `define CR_KME_IM_AVAILABLE_T_CCEIP2_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_IM_AVAILABLE_T_CCEIP3_BANK_LO_DECL   0:0
`define CR_KME_IM_AVAILABLE_T_CCEIP3_BANK_LO_WIDTH  1
  `define CR_KME_IM_AVAILABLE_T_CCEIP3_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_IM_AVAILABLE_T_CCEIP3_BANK_HI_DECL   0:0
`define CR_KME_IM_AVAILABLE_T_CCEIP3_BANK_HI_WIDTH  1
  `define CR_KME_IM_AVAILABLE_T_CCEIP3_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_IM_AVAILABLE_T_CDDIP0_BANK_LO_DECL   0:0
`define CR_KME_IM_AVAILABLE_T_CDDIP0_BANK_LO_WIDTH  1
  `define CR_KME_IM_AVAILABLE_T_CDDIP0_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_IM_AVAILABLE_T_CDDIP0_BANK_HI_DECL   0:0
`define CR_KME_IM_AVAILABLE_T_CDDIP0_BANK_HI_WIDTH  1
  `define CR_KME_IM_AVAILABLE_T_CDDIP0_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_IM_AVAILABLE_T_CDDIP1_BANK_LO_DECL   0:0
`define CR_KME_IM_AVAILABLE_T_CDDIP1_BANK_LO_WIDTH  1
  `define CR_KME_IM_AVAILABLE_T_CDDIP1_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_IM_AVAILABLE_T_CDDIP1_BANK_HI_DECL   0:0
`define CR_KME_IM_AVAILABLE_T_CDDIP1_BANK_HI_WIDTH  1
  `define CR_KME_IM_AVAILABLE_T_CDDIP1_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_IM_AVAILABLE_T_CDDIP2_BANK_LO_DECL   0:0
`define CR_KME_IM_AVAILABLE_T_CDDIP2_BANK_LO_WIDTH  1
  `define CR_KME_IM_AVAILABLE_T_CDDIP2_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_IM_AVAILABLE_T_CDDIP2_BANK_HI_DECL   0:0
`define CR_KME_IM_AVAILABLE_T_CDDIP2_BANK_HI_WIDTH  1
  `define CR_KME_IM_AVAILABLE_T_CDDIP2_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_IM_AVAILABLE_T_CDDIP3_BANK_LO_DECL   0:0
`define CR_KME_IM_AVAILABLE_T_CDDIP3_BANK_LO_WIDTH  1
  `define CR_KME_IM_AVAILABLE_T_CDDIP3_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_IM_AVAILABLE_T_CDDIP3_BANK_HI_DECL   0:0
`define CR_KME_IM_AVAILABLE_T_CDDIP3_BANK_HI_WIDTH  1
  `define CR_KME_IM_AVAILABLE_T_CDDIP3_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_IM_AVAILABLE_T_DECL   31:0
`define CR_KME_FULL_IM_AVAILABLE_T_WIDTH  32
  `define CR_KME_FULL_IM_AVAILABLE_T_CCEIP0_BANK_LO  00
  `define CR_KME_FULL_IM_AVAILABLE_T_CCEIP0_BANK_HI  01
  `define CR_KME_FULL_IM_AVAILABLE_T_CCEIP1_BANK_LO  02
  `define CR_KME_FULL_IM_AVAILABLE_T_CCEIP1_BANK_HI  03
  `define CR_KME_FULL_IM_AVAILABLE_T_CCEIP2_BANK_LO  04
  `define CR_KME_FULL_IM_AVAILABLE_T_CCEIP2_BANK_HI  05
  `define CR_KME_FULL_IM_AVAILABLE_T_CCEIP3_BANK_LO  06
  `define CR_KME_FULL_IM_AVAILABLE_T_CCEIP3_BANK_HI  07
  `define CR_KME_FULL_IM_AVAILABLE_T_CDDIP0_BANK_LO  08
  `define CR_KME_FULL_IM_AVAILABLE_T_CDDIP0_BANK_HI  09
  `define CR_KME_FULL_IM_AVAILABLE_T_CDDIP1_BANK_LO  10
  `define CR_KME_FULL_IM_AVAILABLE_T_CDDIP1_BANK_HI  11
  `define CR_KME_FULL_IM_AVAILABLE_T_CDDIP2_BANK_LO  12
  `define CR_KME_FULL_IM_AVAILABLE_T_CDDIP2_BANK_HI  13
  `define CR_KME_FULL_IM_AVAILABLE_T_CDDIP3_BANK_LO  14
  `define CR_KME_FULL_IM_AVAILABLE_T_CDDIP3_BANK_HI  15
  `define CR_KME_FULL_IM_AVAILABLE_T_RESERVED0       31:16

`define CR_KME_C_IM_AVAILABLE_T_DECL   15:0
`define CR_KME_C_IM_AVAILABLE_T_WIDTH  16
  `define CR_KME_C_IM_AVAILABLE_T_CCEIP0_BANK_LO  00
  `define CR_KME_C_IM_AVAILABLE_T_CCEIP0_BANK_HI  01
  `define CR_KME_C_IM_AVAILABLE_T_CCEIP1_BANK_LO  02
  `define CR_KME_C_IM_AVAILABLE_T_CCEIP1_BANK_HI  03
  `define CR_KME_C_IM_AVAILABLE_T_CCEIP2_BANK_LO  04
  `define CR_KME_C_IM_AVAILABLE_T_CCEIP2_BANK_HI  05
  `define CR_KME_C_IM_AVAILABLE_T_CCEIP3_BANK_LO  06
  `define CR_KME_C_IM_AVAILABLE_T_CCEIP3_BANK_HI  07
  `define CR_KME_C_IM_AVAILABLE_T_CDDIP0_BANK_LO  08
  `define CR_KME_C_IM_AVAILABLE_T_CDDIP0_BANK_HI  09
  `define CR_KME_C_IM_AVAILABLE_T_CDDIP1_BANK_LO  10
  `define CR_KME_C_IM_AVAILABLE_T_CDDIP1_BANK_HI  11
  `define CR_KME_C_IM_AVAILABLE_T_CDDIP2_BANK_LO  12
  `define CR_KME_C_IM_AVAILABLE_T_CDDIP2_BANK_HI  13
  `define CR_KME_C_IM_AVAILABLE_T_CDDIP3_BANK_LO  14
  `define CR_KME_C_IM_AVAILABLE_T_CDDIP3_BANK_HI  15

`define CR_KME_IM_CONSUMED_T_DECL   31:0
`define CR_KME_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_IM_CONSUMED_T_DEFAULT  (32'h 0)

`define CR_KME_IM_CONSUMED_T_CCEIP0_BANK_LO_DECL   0:0
`define CR_KME_IM_CONSUMED_T_CCEIP0_BANK_LO_WIDTH  1
  `define CR_KME_IM_CONSUMED_T_CCEIP0_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_IM_CONSUMED_T_CCEIP0_BANK_HI_DECL   0:0
`define CR_KME_IM_CONSUMED_T_CCEIP0_BANK_HI_WIDTH  1
  `define CR_KME_IM_CONSUMED_T_CCEIP0_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_IM_CONSUMED_T_CCEIP1_BANK_LO_DECL   0:0
`define CR_KME_IM_CONSUMED_T_CCEIP1_BANK_LO_WIDTH  1
  `define CR_KME_IM_CONSUMED_T_CCEIP1_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_IM_CONSUMED_T_CCEIP1_BANK_HI_DECL   0:0
`define CR_KME_IM_CONSUMED_T_CCEIP1_BANK_HI_WIDTH  1
  `define CR_KME_IM_CONSUMED_T_CCEIP1_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_IM_CONSUMED_T_CCEIP2_BANK_LO_DECL   0:0
`define CR_KME_IM_CONSUMED_T_CCEIP2_BANK_LO_WIDTH  1
  `define CR_KME_IM_CONSUMED_T_CCEIP2_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_IM_CONSUMED_T_CCEIP2_BANK_HI_DECL   0:0
`define CR_KME_IM_CONSUMED_T_CCEIP2_BANK_HI_WIDTH  1
  `define CR_KME_IM_CONSUMED_T_CCEIP2_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_IM_CONSUMED_T_CCEIP3_BANK_LO_DECL   0:0
`define CR_KME_IM_CONSUMED_T_CCEIP3_BANK_LO_WIDTH  1
  `define CR_KME_IM_CONSUMED_T_CCEIP3_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_IM_CONSUMED_T_CCEIP3_BANK_HI_DECL   0:0
`define CR_KME_IM_CONSUMED_T_CCEIP3_BANK_HI_WIDTH  1
  `define CR_KME_IM_CONSUMED_T_CCEIP3_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_IM_CONSUMED_T_CDDIP0_BANK_LO_DECL   0:0
`define CR_KME_IM_CONSUMED_T_CDDIP0_BANK_LO_WIDTH  1
  `define CR_KME_IM_CONSUMED_T_CDDIP0_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_IM_CONSUMED_T_CDDIP0_BANK_HI_DECL   0:0
`define CR_KME_IM_CONSUMED_T_CDDIP0_BANK_HI_WIDTH  1
  `define CR_KME_IM_CONSUMED_T_CDDIP0_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_IM_CONSUMED_T_CDDIP1_BANK_LO_DECL   0:0
`define CR_KME_IM_CONSUMED_T_CDDIP1_BANK_LO_WIDTH  1
  `define CR_KME_IM_CONSUMED_T_CDDIP1_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_IM_CONSUMED_T_CDDIP1_BANK_HI_DECL   0:0
`define CR_KME_IM_CONSUMED_T_CDDIP1_BANK_HI_WIDTH  1
  `define CR_KME_IM_CONSUMED_T_CDDIP1_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_IM_CONSUMED_T_CDDIP2_BANK_LO_DECL   0:0
`define CR_KME_IM_CONSUMED_T_CDDIP2_BANK_LO_WIDTH  1
  `define CR_KME_IM_CONSUMED_T_CDDIP2_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_IM_CONSUMED_T_CDDIP2_BANK_HI_DECL   0:0
`define CR_KME_IM_CONSUMED_T_CDDIP2_BANK_HI_WIDTH  1
  `define CR_KME_IM_CONSUMED_T_CDDIP2_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_IM_CONSUMED_T_CDDIP3_BANK_LO_DECL   0:0
`define CR_KME_IM_CONSUMED_T_CDDIP3_BANK_LO_WIDTH  1
  `define CR_KME_IM_CONSUMED_T_CDDIP3_BANK_LO_DEFAULT  (1'h 0)

`define CR_KME_IM_CONSUMED_T_CDDIP3_BANK_HI_DECL   0:0
`define CR_KME_IM_CONSUMED_T_CDDIP3_BANK_HI_WIDTH  1
  `define CR_KME_IM_CONSUMED_T_CDDIP3_BANK_HI_DEFAULT  (1'h 0)

`define CR_KME_FULL_IM_CONSUMED_T_DECL   31:0
`define CR_KME_FULL_IM_CONSUMED_T_WIDTH  32
  `define CR_KME_FULL_IM_CONSUMED_T_CCEIP0_BANK_LO  00
  `define CR_KME_FULL_IM_CONSUMED_T_CCEIP0_BANK_HI  01
  `define CR_KME_FULL_IM_CONSUMED_T_CCEIP1_BANK_LO  02
  `define CR_KME_FULL_IM_CONSUMED_T_CCEIP1_BANK_HI  03
  `define CR_KME_FULL_IM_CONSUMED_T_CCEIP2_BANK_LO  04
  `define CR_KME_FULL_IM_CONSUMED_T_CCEIP2_BANK_HI  05
  `define CR_KME_FULL_IM_CONSUMED_T_CCEIP3_BANK_LO  06
  `define CR_KME_FULL_IM_CONSUMED_T_CCEIP3_BANK_HI  07
  `define CR_KME_FULL_IM_CONSUMED_T_CDDIP0_BANK_LO  08
  `define CR_KME_FULL_IM_CONSUMED_T_CDDIP0_BANK_HI  09
  `define CR_KME_FULL_IM_CONSUMED_T_CDDIP1_BANK_LO  10
  `define CR_KME_FULL_IM_CONSUMED_T_CDDIP1_BANK_HI  11
  `define CR_KME_FULL_IM_CONSUMED_T_CDDIP2_BANK_LO  12
  `define CR_KME_FULL_IM_CONSUMED_T_CDDIP2_BANK_HI  13
  `define CR_KME_FULL_IM_CONSUMED_T_CDDIP3_BANK_LO  14
  `define CR_KME_FULL_IM_CONSUMED_T_CDDIP3_BANK_HI  15
  `define CR_KME_FULL_IM_CONSUMED_T_RESERVED0       31:16

`define CR_KME_C_IM_CONSUMED_T_DECL   15:0
`define CR_KME_C_IM_CONSUMED_T_WIDTH  16
  `define CR_KME_C_IM_CONSUMED_T_CCEIP0_BANK_LO  00
  `define CR_KME_C_IM_CONSUMED_T_CCEIP0_BANK_HI  01
  `define CR_KME_C_IM_CONSUMED_T_CCEIP1_BANK_LO  02
  `define CR_KME_C_IM_CONSUMED_T_CCEIP1_BANK_HI  03
  `define CR_KME_C_IM_CONSUMED_T_CCEIP2_BANK_LO  04
  `define CR_KME_C_IM_CONSUMED_T_CCEIP2_BANK_HI  05
  `define CR_KME_C_IM_CONSUMED_T_CCEIP3_BANK_LO  06
  `define CR_KME_C_IM_CONSUMED_T_CCEIP3_BANK_HI  07
  `define CR_KME_C_IM_CONSUMED_T_CDDIP0_BANK_LO  08
  `define CR_KME_C_IM_CONSUMED_T_CDDIP0_BANK_HI  09
  `define CR_KME_C_IM_CONSUMED_T_CDDIP1_BANK_LO  10
  `define CR_KME_C_IM_CONSUMED_T_CDDIP1_BANK_HI  11
  `define CR_KME_C_IM_CONSUMED_T_CDDIP2_BANK_LO  12
  `define CR_KME_C_IM_CONSUMED_T_CDDIP2_BANK_HI  13
  `define CR_KME_C_IM_CONSUMED_T_CDDIP3_BANK_LO  14
  `define CR_KME_C_IM_CONSUMED_T_CDDIP3_BANK_HI  15

`define CR_KME_SA_CTRL_DEP_T_DECL   31:0
`define CR_KME_SA_CTRL_DEP_T_WIDTH  32
  `define CR_KME_SA_CTRL_DEP_T_DEFAULT  (32'h 0)

`define CR_KME_SA_CTRL_DEP_T_SA_CLEAR_LIVE_DECL   0:0
`define CR_KME_SA_CTRL_DEP_T_SA_CLEAR_LIVE_WIDTH  1
  `define CR_KME_SA_CTRL_DEP_T_SA_CLEAR_LIVE_DEFAULT  (1'h 0)

`define CR_KME_SA_CTRL_DEP_T_SA_SNAP_DECL   0:0
`define CR_KME_SA_CTRL_DEP_T_SA_SNAP_WIDTH  1
  `define CR_KME_SA_CTRL_DEP_T_SA_SNAP_DEFAULT  (1'h 0)

`define CR_KME_SA_CTRL_DEP_T_SA_CTRL_SPARE1_DECL   5:0
`define CR_KME_SA_CTRL_DEP_T_SA_CTRL_SPARE1_WIDTH  6
  `define CR_KME_SA_CTRL_DEP_T_SA_CTRL_SPARE1_DEFAULT  (6'h 0)

`define CR_KME_SA_CTRL_DEP_T_SA_EVENT_SEL_DECL   4:0
`define CR_KME_SA_CTRL_DEP_T_SA_EVENT_SEL_WIDTH  5
  `define CR_KME_SA_CTRL_DEP_T_SA_EVENT_SEL_DEFAULT  (5'h 0)

`define CR_KME_SA_CTRL_DEP_T_SA_CTRL_SPARE2_DECL   18:0
`define CR_KME_SA_CTRL_DEP_T_SA_CTRL_SPARE2_WIDTH  19
  `define CR_KME_SA_CTRL_DEP_T_SA_CTRL_SPARE2_DEFAULT  (19'h 0)

`define CR_KME_FULL_SA_CTRL_DEP_T_DECL   31:0
`define CR_KME_FULL_SA_CTRL_DEP_T_WIDTH  32
  `define CR_KME_FULL_SA_CTRL_DEP_T_SA_CLEAR_LIVE   00
  `define CR_KME_FULL_SA_CTRL_DEP_T_SA_SNAP         01
  `define CR_KME_FULL_SA_CTRL_DEP_T_SA_CTRL_SPARE1  07:02
  `define CR_KME_FULL_SA_CTRL_DEP_T_SA_EVENT_SEL    12:08
  `define CR_KME_FULL_SA_CTRL_DEP_T_SA_CTRL_SPARE2  31:13

`define CR_KME_C_SA_CTRL_DEP_T_DECL   31:0
`define CR_KME_C_SA_CTRL_DEP_T_WIDTH  32
  `define CR_KME_C_SA_CTRL_DEP_T_SA_CLEAR_LIVE   00
  `define CR_KME_C_SA_CTRL_DEP_T_SA_SNAP         01
  `define CR_KME_C_SA_CTRL_DEP_T_SA_CTRL_SPARE1  07:02
  `define CR_KME_C_SA_CTRL_DEP_T_SA_EVENT_SEL    12:08
  `define CR_KME_C_SA_CTRL_DEP_T_SA_CTRL_SPARE2  31:13

`define CR_KME_SA_SNAPSHOT_PART1_T_DECL   31:0
`define CR_KME_SA_SNAPSHOT_PART1_T_WIDTH  32
  `define CR_KME_SA_SNAPSHOT_PART1_T_DEFAULT  (32'h 0)

`define CR_KME_SA_SNAPSHOT_PART1_T_UPPER_DECL   17:0
`define CR_KME_SA_SNAPSHOT_PART1_T_UPPER_WIDTH  18
  `define CR_KME_SA_SNAPSHOT_PART1_T_UPPER_DEFAULT  (18'h 0)

`define CR_KME_SA_SNAPSHOT_PART1_T_UNUSED_DECL   13:0
`define CR_KME_SA_SNAPSHOT_PART1_T_UNUSED_WIDTH  14
  `define CR_KME_SA_SNAPSHOT_PART1_T_UNUSED_DEFAULT  (14'h 0)

`define CR_KME_FULL_SA_SNAPSHOT_PART1_T_DECL   31:0
`define CR_KME_FULL_SA_SNAPSHOT_PART1_T_WIDTH  32
  `define CR_KME_FULL_SA_SNAPSHOT_PART1_T_UPPER   17:00
  `define CR_KME_FULL_SA_SNAPSHOT_PART1_T_UNUSED  31:18

`define CR_KME_C_SA_SNAPSHOT_PART1_T_DECL   31:0
`define CR_KME_C_SA_SNAPSHOT_PART1_T_WIDTH  32
  `define CR_KME_C_SA_SNAPSHOT_PART1_T_UPPER   17:00
  `define CR_KME_C_SA_SNAPSHOT_PART1_T_UNUSED  31:18

`define CR_KME_SA_SNAPSHOT_PART0_T_DECL   31:0
`define CR_KME_SA_SNAPSHOT_PART0_T_WIDTH  32
  `define CR_KME_SA_SNAPSHOT_PART0_T_DEFAULT  (32'h 0)

`define CR_KME_SA_SNAPSHOT_PART0_T_LOWER_DECL   31:0
`define CR_KME_SA_SNAPSHOT_PART0_T_LOWER_WIDTH  32
  `define CR_KME_SA_SNAPSHOT_PART0_T_LOWER_DEFAULT  (32'h 0)

`define CR_KME_FULL_SA_SNAPSHOT_PART0_T_DECL   31:0
`define CR_KME_FULL_SA_SNAPSHOT_PART0_T_WIDTH  32
  `define CR_KME_FULL_SA_SNAPSHOT_PART0_T_LOWER  31:00

`define CR_KME_C_SA_SNAPSHOT_PART0_T_DECL   31:0
`define CR_KME_C_SA_SNAPSHOT_PART0_T_WIDTH  32
  `define CR_KME_C_SA_SNAPSHOT_PART0_T_LOWER  31:00

`define CR_KME_SA_SNAPSHOT_IA_CONFIG_T_DECL   31:0
`define CR_KME_SA_SNAPSHOT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_SA_SNAPSHOT_IA_CONFIG_T_DEFAULT  (32'h 0)

`define CR_KME_SA_SNAPSHOT_IA_CONFIG_T_ADDR_DECL   4:0
`define CR_KME_SA_SNAPSHOT_IA_CONFIG_T_ADDR_WIDTH  5
  `define CR_KME_SA_SNAPSHOT_IA_CONFIG_T_ADDR_DEFAULT  (5'h 0)

`define CR_KME_SA_SNAPSHOT_IA_CONFIG_T_OP_DECL   3:0
`define CR_KME_SA_SNAPSHOT_IA_CONFIG_T_OP_WIDTH  4
  `define CR_KME_SA_SNAPSHOT_IA_CONFIG_T_OP_DEFAULT  (4'h 0)

`define CR_KME_FULL_SA_SNAPSHOT_IA_CONFIG_T_DECL   31:0
`define CR_KME_FULL_SA_SNAPSHOT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CONFIG_T_ADDR       04:00
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CONFIG_T_RESERVED0  27:05
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CONFIG_T_OP         31:28

`define CR_KME_C_SA_SNAPSHOT_IA_CONFIG_T_DECL   8:0
`define CR_KME_C_SA_SNAPSHOT_IA_CONFIG_T_WIDTH  9
  `define CR_KME_C_SA_SNAPSHOT_IA_CONFIG_T_ADDR  04:00
  `define CR_KME_C_SA_SNAPSHOT_IA_CONFIG_T_OP    08:05

`define CR_KME_SA_SNAPSHOT_IA_STATUS_T_DECL   31:0
`define CR_KME_SA_SNAPSHOT_IA_STATUS_T_WIDTH  32
  `define CR_KME_SA_SNAPSHOT_IA_STATUS_T_DEFAULT  (32'h 100001f)

`define CR_KME_SA_SNAPSHOT_IA_STATUS_T_ADDR_DECL   4:0
`define CR_KME_SA_SNAPSHOT_IA_STATUS_T_ADDR_WIDTH  5
  `define CR_KME_SA_SNAPSHOT_IA_STATUS_T_ADDR_DEFAULT  (5'h 1f)

`define CR_KME_SA_SNAPSHOT_IA_STATUS_T_DATAWORDS_DECL   4:0
`define CR_KME_SA_SNAPSHOT_IA_STATUS_T_DATAWORDS_WIDTH  5
  `define CR_KME_SA_SNAPSHOT_IA_STATUS_T_DATAWORDS_DEFAULT  (5'h 1)

`define CR_KME_SA_SNAPSHOT_IA_STATUS_T_CODE_DECL   2:0
`define CR_KME_SA_SNAPSHOT_IA_STATUS_T_CODE_WIDTH  3
  `define CR_KME_SA_SNAPSHOT_IA_STATUS_T_CODE_DEFAULT  (3'h 0)

`define CR_KME_FULL_SA_SNAPSHOT_IA_STATUS_T_DECL   31:0
`define CR_KME_FULL_SA_SNAPSHOT_IA_STATUS_T_WIDTH  32
  `define CR_KME_FULL_SA_SNAPSHOT_IA_STATUS_T_ADDR       04:00
  `define CR_KME_FULL_SA_SNAPSHOT_IA_STATUS_T_RESERVED0  23:05
  `define CR_KME_FULL_SA_SNAPSHOT_IA_STATUS_T_DATAWORDS  28:24
  `define CR_KME_FULL_SA_SNAPSHOT_IA_STATUS_T_CODE       31:29

`define CR_KME_C_SA_SNAPSHOT_IA_STATUS_T_DECL   12:0
`define CR_KME_C_SA_SNAPSHOT_IA_STATUS_T_WIDTH  13
  `define CR_KME_C_SA_SNAPSHOT_IA_STATUS_T_ADDR       04:00
  `define CR_KME_C_SA_SNAPSHOT_IA_STATUS_T_DATAWORDS  09:05
  `define CR_KME_C_SA_SNAPSHOT_IA_STATUS_T_CODE       12:10

`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_DEFAULT  (32'b xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)

`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_NOP_DECL   0:0
`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_NOP_WIDTH  1

`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_READ_DECL   0:0
`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_READ_WIDTH  1

`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_WRITE_DECL   0:0
`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_WRITE_WIDTH  1

`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_ENABLE_DECL   0:0
`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_ENABLE_WIDTH  1

`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_DISABLED_DECL   0:0
`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_DISABLED_WIDTH  1

`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_RESET_DECL   0:0
`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_RESET_WIDTH  1

`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_INITIALIZE_DECL   0:0
`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_INITIALIZE_WIDTH  1

`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_INITIALIZE_INC_DECL   0:0
`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_INITIALIZE_INC_WIDTH  1

`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_SET_INIT_START_DECL   0:0
`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_SET_INIT_START_WIDTH  1

`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_COMPARE_DECL   0:0
`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_COMPARE_WIDTH  1

`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_RESERVED_OP_DECL   3:0
`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_RESERVED_OP_WIDTH  4

`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_SIM_TMO_DECL   0:0
`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_SIM_TMO_WIDTH  1

`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_ACK_ERROR_DECL   0:0
`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_ACK_ERROR_WIDTH  1

`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_MEM_TYPE_DECL   3:0
`define CR_KME_SA_SNAPSHOT_IA_CAPABILITY_T_MEM_TYPE_WIDTH  4

`define CR_KME_FULL_SA_SNAPSHOT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_FULL_SA_SNAPSHOT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CAPABILITY_T_READ            01
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CAPABILITY_T_RESERVED0       27:16
  `define CR_KME_FULL_SA_SNAPSHOT_IA_CAPABILITY_T_MEM_TYPE        31:28

`define CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_DECL   19:0
`define CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_WIDTH  20
  `define CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_READ            01
  `define CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_C_SA_SNAPSHOT_IA_CAPABILITY_T_MEM_TYPE        19:16

`define CR_KME_SA_COUNT_PART1_T_DECL   31:0
`define CR_KME_SA_COUNT_PART1_T_WIDTH  32
  `define CR_KME_SA_COUNT_PART1_T_DEFAULT  (32'h 0)

`define CR_KME_SA_COUNT_PART1_T_UPPER_DECL   17:0
`define CR_KME_SA_COUNT_PART1_T_UPPER_WIDTH  18
  `define CR_KME_SA_COUNT_PART1_T_UPPER_DEFAULT  (18'h 0)

`define CR_KME_SA_COUNT_PART1_T_UNUSED_DECL   13:0
`define CR_KME_SA_COUNT_PART1_T_UNUSED_WIDTH  14
  `define CR_KME_SA_COUNT_PART1_T_UNUSED_DEFAULT  (14'h 0)

`define CR_KME_FULL_SA_COUNT_PART1_T_DECL   31:0
`define CR_KME_FULL_SA_COUNT_PART1_T_WIDTH  32
  `define CR_KME_FULL_SA_COUNT_PART1_T_UPPER   17:00
  `define CR_KME_FULL_SA_COUNT_PART1_T_UNUSED  31:18

`define CR_KME_C_SA_COUNT_PART1_T_DECL   31:0
`define CR_KME_C_SA_COUNT_PART1_T_WIDTH  32
  `define CR_KME_C_SA_COUNT_PART1_T_UPPER   17:00
  `define CR_KME_C_SA_COUNT_PART1_T_UNUSED  31:18

`define CR_KME_SA_COUNT_PART0_T_DECL   31:0
`define CR_KME_SA_COUNT_PART0_T_WIDTH  32
  `define CR_KME_SA_COUNT_PART0_T_DEFAULT  (32'h 0)

`define CR_KME_SA_COUNT_PART0_T_LOWER_DECL   31:0
`define CR_KME_SA_COUNT_PART0_T_LOWER_WIDTH  32
  `define CR_KME_SA_COUNT_PART0_T_LOWER_DEFAULT  (32'h 0)

`define CR_KME_FULL_SA_COUNT_PART0_T_DECL   31:0
`define CR_KME_FULL_SA_COUNT_PART0_T_WIDTH  32
  `define CR_KME_FULL_SA_COUNT_PART0_T_LOWER  31:00

`define CR_KME_C_SA_COUNT_PART0_T_DECL   31:0
`define CR_KME_C_SA_COUNT_PART0_T_WIDTH  32
  `define CR_KME_C_SA_COUNT_PART0_T_LOWER  31:00

`define CR_KME_SA_GLOBAL_CTRL_T_DECL   31:0
`define CR_KME_SA_GLOBAL_CTRL_T_WIDTH  32
  `define CR_KME_SA_GLOBAL_CTRL_T_DEFAULT  (32'h 0)

`define CR_KME_SA_GLOBAL_CTRL_T_SA_CLEAR_LIVE_DECL   0:0
`define CR_KME_SA_GLOBAL_CTRL_T_SA_CLEAR_LIVE_WIDTH  1
  `define CR_KME_SA_GLOBAL_CTRL_T_SA_CLEAR_LIVE_DEFAULT  (1'h 0)

`define CR_KME_SA_GLOBAL_CTRL_T_SA_SNAP_DECL   0:0
`define CR_KME_SA_GLOBAL_CTRL_T_SA_SNAP_WIDTH  1
  `define CR_KME_SA_GLOBAL_CTRL_T_SA_SNAP_DEFAULT  (1'h 0)

`define CR_KME_SA_GLOBAL_CTRL_T_SPARE_DECL   29:0
`define CR_KME_SA_GLOBAL_CTRL_T_SPARE_WIDTH  30
  `define CR_KME_SA_GLOBAL_CTRL_T_SPARE_DEFAULT  (30'h 0)

`define CR_KME_FULL_SA_GLOBAL_CTRL_T_DECL   31:0
`define CR_KME_FULL_SA_GLOBAL_CTRL_T_WIDTH  32
  `define CR_KME_FULL_SA_GLOBAL_CTRL_T_SA_CLEAR_LIVE  00
  `define CR_KME_FULL_SA_GLOBAL_CTRL_T_SA_SNAP        01
  `define CR_KME_FULL_SA_GLOBAL_CTRL_T_SPARE          31:02

`define CR_KME_C_SA_GLOBAL_CTRL_T_DECL   31:0
`define CR_KME_C_SA_GLOBAL_CTRL_T_WIDTH  32
  `define CR_KME_C_SA_GLOBAL_CTRL_T_SA_CLEAR_LIVE  00
  `define CR_KME_C_SA_GLOBAL_CTRL_T_SA_SNAP        01
  `define CR_KME_C_SA_GLOBAL_CTRL_T_SPARE          31:02

`define CR_KME_SA_CTRL_T_DECL   31:0
`define CR_KME_SA_CTRL_T_WIDTH  32
  `define CR_KME_SA_CTRL_T_DEFAULT  (32'h 0)

`define CR_KME_SA_CTRL_T_SA_EVENT_SEL_DECL   4:0
`define CR_KME_SA_CTRL_T_SA_EVENT_SEL_WIDTH  5
  `define CR_KME_SA_CTRL_T_SA_EVENT_SEL_DEFAULT  (5'h 0)

`define CR_KME_SA_CTRL_T_SPARE_DECL   26:0
`define CR_KME_SA_CTRL_T_SPARE_WIDTH  27
  `define CR_KME_SA_CTRL_T_SPARE_DEFAULT  (27'h 0)

`define CR_KME_FULL_SA_CTRL_T_DECL   31:0
`define CR_KME_FULL_SA_CTRL_T_WIDTH  32
  `define CR_KME_FULL_SA_CTRL_T_SA_EVENT_SEL  04:00
  `define CR_KME_FULL_SA_CTRL_T_SPARE         31:05

`define CR_KME_C_SA_CTRL_T_DECL   31:0
`define CR_KME_C_SA_CTRL_T_WIDTH  32
  `define CR_KME_C_SA_CTRL_T_SA_EVENT_SEL  04:00
  `define CR_KME_C_SA_CTRL_T_SPARE         31:05

`define CR_KME_SA_CTRL_IA_CONFIG_T_DECL   31:0
`define CR_KME_SA_CTRL_IA_CONFIG_T_WIDTH  32
  `define CR_KME_SA_CTRL_IA_CONFIG_T_DEFAULT  (32'h 0)

`define CR_KME_SA_CTRL_IA_CONFIG_T_ADDR_DECL   4:0
`define CR_KME_SA_CTRL_IA_CONFIG_T_ADDR_WIDTH  5
  `define CR_KME_SA_CTRL_IA_CONFIG_T_ADDR_DEFAULT  (5'h 0)

`define CR_KME_SA_CTRL_IA_CONFIG_T_OP_DECL   3:0
`define CR_KME_SA_CTRL_IA_CONFIG_T_OP_WIDTH  4
  `define CR_KME_SA_CTRL_IA_CONFIG_T_OP_DEFAULT  (4'h 0)

`define CR_KME_FULL_SA_CTRL_IA_CONFIG_T_DECL   31:0
`define CR_KME_FULL_SA_CTRL_IA_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_SA_CTRL_IA_CONFIG_T_ADDR       04:00
  `define CR_KME_FULL_SA_CTRL_IA_CONFIG_T_RESERVED0  27:05
  `define CR_KME_FULL_SA_CTRL_IA_CONFIG_T_OP         31:28

`define CR_KME_C_SA_CTRL_IA_CONFIG_T_DECL   8:0
`define CR_KME_C_SA_CTRL_IA_CONFIG_T_WIDTH  9
  `define CR_KME_C_SA_CTRL_IA_CONFIG_T_ADDR  04:00
  `define CR_KME_C_SA_CTRL_IA_CONFIG_T_OP    08:05

`define CR_KME_SA_CTRL_IA_STATUS_T_DECL   31:0
`define CR_KME_SA_CTRL_IA_STATUS_T_WIDTH  32
  `define CR_KME_SA_CTRL_IA_STATUS_T_DEFAULT  (32'h 1f)

`define CR_KME_SA_CTRL_IA_STATUS_T_ADDR_DECL   4:0
`define CR_KME_SA_CTRL_IA_STATUS_T_ADDR_WIDTH  5
  `define CR_KME_SA_CTRL_IA_STATUS_T_ADDR_DEFAULT  (5'h 1f)

`define CR_KME_SA_CTRL_IA_STATUS_T_DATAWORDS_DECL   4:0
`define CR_KME_SA_CTRL_IA_STATUS_T_DATAWORDS_WIDTH  5
  `define CR_KME_SA_CTRL_IA_STATUS_T_DATAWORDS_DEFAULT  (5'h 0)

`define CR_KME_SA_CTRL_IA_STATUS_T_CODE_DECL   2:0
`define CR_KME_SA_CTRL_IA_STATUS_T_CODE_WIDTH  3
  `define CR_KME_SA_CTRL_IA_STATUS_T_CODE_DEFAULT  (3'h 0)

`define CR_KME_FULL_SA_CTRL_IA_STATUS_T_DECL   31:0
`define CR_KME_FULL_SA_CTRL_IA_STATUS_T_WIDTH  32
  `define CR_KME_FULL_SA_CTRL_IA_STATUS_T_ADDR       04:00
  `define CR_KME_FULL_SA_CTRL_IA_STATUS_T_RESERVED0  23:05
  `define CR_KME_FULL_SA_CTRL_IA_STATUS_T_DATAWORDS  28:24
  `define CR_KME_FULL_SA_CTRL_IA_STATUS_T_CODE       31:29

`define CR_KME_C_SA_CTRL_IA_STATUS_T_DECL   12:0
`define CR_KME_C_SA_CTRL_IA_STATUS_T_WIDTH  13
  `define CR_KME_C_SA_CTRL_IA_STATUS_T_ADDR       04:00
  `define CR_KME_C_SA_CTRL_IA_STATUS_T_DATAWORDS  09:05
  `define CR_KME_C_SA_CTRL_IA_STATUS_T_CODE       12:10

`define CR_KME_SA_CTRL_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_SA_CTRL_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_SA_CTRL_IA_CAPABILITY_T_DEFAULT  (32'b xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)

`define CR_KME_SA_CTRL_IA_CAPABILITY_T_NOP_DECL   0:0
`define CR_KME_SA_CTRL_IA_CAPABILITY_T_NOP_WIDTH  1

`define CR_KME_SA_CTRL_IA_CAPABILITY_T_READ_DECL   0:0
`define CR_KME_SA_CTRL_IA_CAPABILITY_T_READ_WIDTH  1

`define CR_KME_SA_CTRL_IA_CAPABILITY_T_WRITE_DECL   0:0
`define CR_KME_SA_CTRL_IA_CAPABILITY_T_WRITE_WIDTH  1

`define CR_KME_SA_CTRL_IA_CAPABILITY_T_ENABLE_DECL   0:0
`define CR_KME_SA_CTRL_IA_CAPABILITY_T_ENABLE_WIDTH  1

`define CR_KME_SA_CTRL_IA_CAPABILITY_T_DISABLED_DECL   0:0
`define CR_KME_SA_CTRL_IA_CAPABILITY_T_DISABLED_WIDTH  1

`define CR_KME_SA_CTRL_IA_CAPABILITY_T_RESET_DECL   0:0
`define CR_KME_SA_CTRL_IA_CAPABILITY_T_RESET_WIDTH  1

`define CR_KME_SA_CTRL_IA_CAPABILITY_T_INITIALIZE_DECL   0:0
`define CR_KME_SA_CTRL_IA_CAPABILITY_T_INITIALIZE_WIDTH  1

`define CR_KME_SA_CTRL_IA_CAPABILITY_T_INITIALIZE_INC_DECL   0:0
`define CR_KME_SA_CTRL_IA_CAPABILITY_T_INITIALIZE_INC_WIDTH  1

`define CR_KME_SA_CTRL_IA_CAPABILITY_T_SET_INIT_START_DECL   0:0
`define CR_KME_SA_CTRL_IA_CAPABILITY_T_SET_INIT_START_WIDTH  1

`define CR_KME_SA_CTRL_IA_CAPABILITY_T_COMPARE_DECL   0:0
`define CR_KME_SA_CTRL_IA_CAPABILITY_T_COMPARE_WIDTH  1

`define CR_KME_SA_CTRL_IA_CAPABILITY_T_RESERVED_OP_DECL   3:0
`define CR_KME_SA_CTRL_IA_CAPABILITY_T_RESERVED_OP_WIDTH  4

`define CR_KME_SA_CTRL_IA_CAPABILITY_T_SIM_TMO_DECL   0:0
`define CR_KME_SA_CTRL_IA_CAPABILITY_T_SIM_TMO_WIDTH  1

`define CR_KME_SA_CTRL_IA_CAPABILITY_T_ACK_ERROR_DECL   0:0
`define CR_KME_SA_CTRL_IA_CAPABILITY_T_ACK_ERROR_WIDTH  1

`define CR_KME_SA_CTRL_IA_CAPABILITY_T_MEM_TYPE_DECL   3:0
`define CR_KME_SA_CTRL_IA_CAPABILITY_T_MEM_TYPE_WIDTH  4

`define CR_KME_FULL_SA_CTRL_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_FULL_SA_CTRL_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_FULL_SA_CTRL_IA_CAPABILITY_T_NOP             00
  `define CR_KME_FULL_SA_CTRL_IA_CAPABILITY_T_READ            01
  `define CR_KME_FULL_SA_CTRL_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_FULL_SA_CTRL_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_FULL_SA_CTRL_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_FULL_SA_CTRL_IA_CAPABILITY_T_RESET           05
  `define CR_KME_FULL_SA_CTRL_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_FULL_SA_CTRL_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_FULL_SA_CTRL_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_FULL_SA_CTRL_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_FULL_SA_CTRL_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_FULL_SA_CTRL_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_FULL_SA_CTRL_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_FULL_SA_CTRL_IA_CAPABILITY_T_RESERVED0       27:16
  `define CR_KME_FULL_SA_CTRL_IA_CAPABILITY_T_MEM_TYPE        31:28

`define CR_KME_C_SA_CTRL_IA_CAPABILITY_T_DECL   19:0
`define CR_KME_C_SA_CTRL_IA_CAPABILITY_T_WIDTH  20
  `define CR_KME_C_SA_CTRL_IA_CAPABILITY_T_NOP             00
  `define CR_KME_C_SA_CTRL_IA_CAPABILITY_T_READ            01
  `define CR_KME_C_SA_CTRL_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_C_SA_CTRL_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_C_SA_CTRL_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_C_SA_CTRL_IA_CAPABILITY_T_RESET           05
  `define CR_KME_C_SA_CTRL_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_C_SA_CTRL_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_C_SA_CTRL_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_C_SA_CTRL_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_C_SA_CTRL_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_C_SA_CTRL_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_C_SA_CTRL_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_C_SA_CTRL_IA_CAPABILITY_T_MEM_TYPE        19:16

`define CR_KME_IDLE_T_DECL   31:0
`define CR_KME_IDLE_T_WIDTH  32
  `define CR_KME_IDLE_T_DEFAULT  (32'h 0)

`define CR_KME_IDLE_T_KME_SLV_EMPTY_DECL   0:0
`define CR_KME_IDLE_T_KME_SLV_EMPTY_WIDTH  1
  `define CR_KME_IDLE_T_KME_SLV_EMPTY_DEFAULT  (1'h 0)

`define CR_KME_IDLE_T_DRNG_IDLE_DECL   0:0
`define CR_KME_IDLE_T_DRNG_IDLE_WIDTH  1
  `define CR_KME_IDLE_T_DRNG_IDLE_DEFAULT  (1'h 0)

`define CR_KME_IDLE_T_TLV_PARSER_IDLE_DECL   0:0
`define CR_KME_IDLE_T_TLV_PARSER_IDLE_WIDTH  1
  `define CR_KME_IDLE_T_TLV_PARSER_IDLE_DEFAULT  (1'h 0)

`define CR_KME_IDLE_T_NO_KEY_TLV_IN_FLIGHT_DECL   0:0
`define CR_KME_IDLE_T_NO_KEY_TLV_IN_FLIGHT_WIDTH  1
  `define CR_KME_IDLE_T_NO_KEY_TLV_IN_FLIGHT_DEFAULT  (1'h 0)

`define CR_KME_IDLE_T_CCEIP3_KEY_TLV_RSM_IDLE_DECL   0:0
`define CR_KME_IDLE_T_CCEIP3_KEY_TLV_RSM_IDLE_WIDTH  1
  `define CR_KME_IDLE_T_CCEIP3_KEY_TLV_RSM_IDLE_DEFAULT  (1'h 0)

`define CR_KME_IDLE_T_CCEIP2_KEY_TLV_RSM_IDLE_DECL   0:0
`define CR_KME_IDLE_T_CCEIP2_KEY_TLV_RSM_IDLE_WIDTH  1
  `define CR_KME_IDLE_T_CCEIP2_KEY_TLV_RSM_IDLE_DEFAULT  (1'h 0)

`define CR_KME_IDLE_T_CCEIP1_KEY_TLV_RSM_IDLE_DECL   0:0
`define CR_KME_IDLE_T_CCEIP1_KEY_TLV_RSM_IDLE_WIDTH  1
  `define CR_KME_IDLE_T_CCEIP1_KEY_TLV_RSM_IDLE_DEFAULT  (1'h 0)

`define CR_KME_IDLE_T_CCEIP0_KEY_TLV_RSM_IDLE_DECL   0:0
`define CR_KME_IDLE_T_CCEIP0_KEY_TLV_RSM_IDLE_WIDTH  1
  `define CR_KME_IDLE_T_CCEIP0_KEY_TLV_RSM_IDLE_DEFAULT  (1'h 0)

`define CR_KME_IDLE_T_CDDIP3_KEY_TLV_RSM_IDLE_DECL   0:0
`define CR_KME_IDLE_T_CDDIP3_KEY_TLV_RSM_IDLE_WIDTH  1
  `define CR_KME_IDLE_T_CDDIP3_KEY_TLV_RSM_IDLE_DEFAULT  (1'h 0)

`define CR_KME_IDLE_T_CDDIP2_KEY_TLV_RSM_IDLE_DECL   0:0
`define CR_KME_IDLE_T_CDDIP2_KEY_TLV_RSM_IDLE_WIDTH  1
  `define CR_KME_IDLE_T_CDDIP2_KEY_TLV_RSM_IDLE_DEFAULT  (1'h 0)

`define CR_KME_IDLE_T_CDDIP1_KEY_TLV_RSM_IDLE_DECL   0:0
`define CR_KME_IDLE_T_CDDIP1_KEY_TLV_RSM_IDLE_WIDTH  1
  `define CR_KME_IDLE_T_CDDIP1_KEY_TLV_RSM_IDLE_DEFAULT  (1'h 0)

`define CR_KME_IDLE_T_CDDIP0_KEY_TLV_RSM_IDLE_DECL   0:0
`define CR_KME_IDLE_T_CDDIP0_KEY_TLV_RSM_IDLE_WIDTH  1
  `define CR_KME_IDLE_T_CDDIP0_KEY_TLV_RSM_IDLE_DEFAULT  (1'h 0)

`define CR_KME_IDLE_T_NUM_KEY_TLVS_IN_FLIGHT_DECL   19:0
`define CR_KME_IDLE_T_NUM_KEY_TLVS_IN_FLIGHT_WIDTH  20

`define CR_KME_FULL_IDLE_T_DECL   31:0
`define CR_KME_FULL_IDLE_T_WIDTH  32
  `define CR_KME_FULL_IDLE_T_KME_SLV_EMPTY            00
  `define CR_KME_FULL_IDLE_T_DRNG_IDLE                01
  `define CR_KME_FULL_IDLE_T_TLV_PARSER_IDLE          02
  `define CR_KME_FULL_IDLE_T_NO_KEY_TLV_IN_FLIGHT     03
  `define CR_KME_FULL_IDLE_T_CCEIP3_KEY_TLV_RSM_IDLE  04
  `define CR_KME_FULL_IDLE_T_CCEIP2_KEY_TLV_RSM_IDLE  05
  `define CR_KME_FULL_IDLE_T_CCEIP1_KEY_TLV_RSM_IDLE  06
  `define CR_KME_FULL_IDLE_T_CCEIP0_KEY_TLV_RSM_IDLE  07
  `define CR_KME_FULL_IDLE_T_CDDIP3_KEY_TLV_RSM_IDLE  08
  `define CR_KME_FULL_IDLE_T_CDDIP2_KEY_TLV_RSM_IDLE  09
  `define CR_KME_FULL_IDLE_T_CDDIP1_KEY_TLV_RSM_IDLE  10
  `define CR_KME_FULL_IDLE_T_CDDIP0_KEY_TLV_RSM_IDLE  11
  `define CR_KME_FULL_IDLE_T_NUM_KEY_TLVS_IN_FLIGHT   31:12

`define CR_KME_C_IDLE_T_DECL   31:0
`define CR_KME_C_IDLE_T_WIDTH  32
  `define CR_KME_C_IDLE_T_KME_SLV_EMPTY            00
  `define CR_KME_C_IDLE_T_DRNG_IDLE                01
  `define CR_KME_C_IDLE_T_TLV_PARSER_IDLE          02
  `define CR_KME_C_IDLE_T_NO_KEY_TLV_IN_FLIGHT     03
  `define CR_KME_C_IDLE_T_CCEIP3_KEY_TLV_RSM_IDLE  04
  `define CR_KME_C_IDLE_T_CCEIP2_KEY_TLV_RSM_IDLE  05
  `define CR_KME_C_IDLE_T_CCEIP1_KEY_TLV_RSM_IDLE  06
  `define CR_KME_C_IDLE_T_CCEIP0_KEY_TLV_RSM_IDLE  07
  `define CR_KME_C_IDLE_T_CDDIP3_KEY_TLV_RSM_IDLE  08
  `define CR_KME_C_IDLE_T_CDDIP2_KEY_TLV_RSM_IDLE  09
  `define CR_KME_C_IDLE_T_CDDIP1_KEY_TLV_RSM_IDLE  10
  `define CR_KME_C_IDLE_T_CDDIP0_KEY_TLV_RSM_IDLE  11
  `define CR_KME_C_IDLE_T_NUM_KEY_TLVS_IN_FLIGHT   31:12

`define CR_KME_KOP_FIFO_OVERRIDE_T_DECL   31:0
`define CR_KME_KOP_FIFO_OVERRIDE_T_WIDTH  32
  `define CR_KME_KOP_FIFO_OVERRIDE_T_DEFAULT  (32'h 0)

`define CR_KME_KOP_FIFO_OVERRIDE_T_GCM_CMD_FIFO_DECL   0:0
`define CR_KME_KOP_FIFO_OVERRIDE_T_GCM_CMD_FIFO_WIDTH  1
  `define CR_KME_KOP_FIFO_OVERRIDE_T_GCM_CMD_FIFO_DEFAULT  (1'h 0)

`define CR_KME_KOP_FIFO_OVERRIDE_T_GCM_TAG_DATA_FIFO_DECL   0:0
`define CR_KME_KOP_FIFO_OVERRIDE_T_GCM_TAG_DATA_FIFO_WIDTH  1
  `define CR_KME_KOP_FIFO_OVERRIDE_T_GCM_TAG_DATA_FIFO_DEFAULT  (1'h 0)

`define CR_KME_KOP_FIFO_OVERRIDE_T_KEYFILTER_CMD_FIFO_DECL   0:0
`define CR_KME_KOP_FIFO_OVERRIDE_T_KEYFILTER_CMD_FIFO_WIDTH  1
  `define CR_KME_KOP_FIFO_OVERRIDE_T_KEYFILTER_CMD_FIFO_DEFAULT  (1'h 0)

`define CR_KME_KOP_FIFO_OVERRIDE_T_KDFSTREAM_CMD_FIFO_DECL   0:0
`define CR_KME_KOP_FIFO_OVERRIDE_T_KDFSTREAM_CMD_FIFO_WIDTH  1
  `define CR_KME_KOP_FIFO_OVERRIDE_T_KDFSTREAM_CMD_FIFO_DEFAULT  (1'h 0)

`define CR_KME_KOP_FIFO_OVERRIDE_T_KDF_CMD_FIFO_DECL   0:0
`define CR_KME_KOP_FIFO_OVERRIDE_T_KDF_CMD_FIFO_WIDTH  1
  `define CR_KME_KOP_FIFO_OVERRIDE_T_KDF_CMD_FIFO_DEFAULT  (1'h 0)

`define CR_KME_KOP_FIFO_OVERRIDE_T_TLV_SB_DATA_FIFO_DECL   0:0
`define CR_KME_KOP_FIFO_OVERRIDE_T_TLV_SB_DATA_FIFO_WIDTH  1
  `define CR_KME_KOP_FIFO_OVERRIDE_T_TLV_SB_DATA_FIFO_DEFAULT  (1'h 0)

`define CR_KME_KOP_FIFO_OVERRIDE_T_GCM_STATUS_DATA_FIFO_DECL   0:0
`define CR_KME_KOP_FIFO_OVERRIDE_T_GCM_STATUS_DATA_FIFO_WIDTH  1
  `define CR_KME_KOP_FIFO_OVERRIDE_T_GCM_STATUS_DATA_FIFO_DEFAULT  (1'h 0)

`define CR_KME_FULL_KOP_FIFO_OVERRIDE_T_DECL   31:0
`define CR_KME_FULL_KOP_FIFO_OVERRIDE_T_WIDTH  32
  `define CR_KME_FULL_KOP_FIFO_OVERRIDE_T_GCM_CMD_FIFO          0
  `define CR_KME_FULL_KOP_FIFO_OVERRIDE_T_GCM_TAG_DATA_FIFO     1
  `define CR_KME_FULL_KOP_FIFO_OVERRIDE_T_KEYFILTER_CMD_FIFO    2
  `define CR_KME_FULL_KOP_FIFO_OVERRIDE_T_KDFSTREAM_CMD_FIFO    3
  `define CR_KME_FULL_KOP_FIFO_OVERRIDE_T_KDF_CMD_FIFO          4
  `define CR_KME_FULL_KOP_FIFO_OVERRIDE_T_TLV_SB_DATA_FIFO      5
  `define CR_KME_FULL_KOP_FIFO_OVERRIDE_T_GCM_STATUS_DATA_FIFO  6
  `define CR_KME_FULL_KOP_FIFO_OVERRIDE_T_RESERVED0             31:7

`define CR_KME_C_KOP_FIFO_OVERRIDE_T_DECL   6:0
`define CR_KME_C_KOP_FIFO_OVERRIDE_T_WIDTH  7
  `define CR_KME_C_KOP_FIFO_OVERRIDE_T_GCM_CMD_FIFO          0
  `define CR_KME_C_KOP_FIFO_OVERRIDE_T_GCM_TAG_DATA_FIFO     1
  `define CR_KME_C_KOP_FIFO_OVERRIDE_T_KEYFILTER_CMD_FIFO    2
  `define CR_KME_C_KOP_FIFO_OVERRIDE_T_KDFSTREAM_CMD_FIFO    3
  `define CR_KME_C_KOP_FIFO_OVERRIDE_T_KDF_CMD_FIFO          4
  `define CR_KME_C_KOP_FIFO_OVERRIDE_T_TLV_SB_DATA_FIFO      5
  `define CR_KME_C_KOP_FIFO_OVERRIDE_T_GCM_STATUS_DATA_FIFO  6

`define CR_KME_SA_COUNT_IA_CONFIG_T_DECL   31:0
`define CR_KME_SA_COUNT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_SA_COUNT_IA_CONFIG_T_DEFAULT  (32'h 0)

`define CR_KME_SA_COUNT_IA_CONFIG_T_ADDR_DECL   4:0
`define CR_KME_SA_COUNT_IA_CONFIG_T_ADDR_WIDTH  5
  `define CR_KME_SA_COUNT_IA_CONFIG_T_ADDR_DEFAULT  (5'h 0)

`define CR_KME_SA_COUNT_IA_CONFIG_T_OP_DECL   3:0
`define CR_KME_SA_COUNT_IA_CONFIG_T_OP_WIDTH  4
  `define CR_KME_SA_COUNT_IA_CONFIG_T_OP_DEFAULT  (4'h 0)

`define CR_KME_FULL_SA_COUNT_IA_CONFIG_T_DECL   31:0
`define CR_KME_FULL_SA_COUNT_IA_CONFIG_T_WIDTH  32
  `define CR_KME_FULL_SA_COUNT_IA_CONFIG_T_ADDR       04:00
  `define CR_KME_FULL_SA_COUNT_IA_CONFIG_T_RESERVED0  27:05
  `define CR_KME_FULL_SA_COUNT_IA_CONFIG_T_OP         31:28

`define CR_KME_C_SA_COUNT_IA_CONFIG_T_DECL   8:0
`define CR_KME_C_SA_COUNT_IA_CONFIG_T_WIDTH  9
  `define CR_KME_C_SA_COUNT_IA_CONFIG_T_ADDR  04:00
  `define CR_KME_C_SA_COUNT_IA_CONFIG_T_OP    08:05

`define CR_KME_SA_COUNT_IA_STATUS_T_DECL   31:0
`define CR_KME_SA_COUNT_IA_STATUS_T_WIDTH  32
  `define CR_KME_SA_COUNT_IA_STATUS_T_DEFAULT  (32'h 100001f)

`define CR_KME_SA_COUNT_IA_STATUS_T_ADDR_DECL   4:0
`define CR_KME_SA_COUNT_IA_STATUS_T_ADDR_WIDTH  5
  `define CR_KME_SA_COUNT_IA_STATUS_T_ADDR_DEFAULT  (5'h 1f)

`define CR_KME_SA_COUNT_IA_STATUS_T_DATAWORDS_DECL   4:0
`define CR_KME_SA_COUNT_IA_STATUS_T_DATAWORDS_WIDTH  5
  `define CR_KME_SA_COUNT_IA_STATUS_T_DATAWORDS_DEFAULT  (5'h 1)

`define CR_KME_SA_COUNT_IA_STATUS_T_CODE_DECL   2:0
`define CR_KME_SA_COUNT_IA_STATUS_T_CODE_WIDTH  3
  `define CR_KME_SA_COUNT_IA_STATUS_T_CODE_DEFAULT  (3'h 0)

`define CR_KME_FULL_SA_COUNT_IA_STATUS_T_DECL   31:0
`define CR_KME_FULL_SA_COUNT_IA_STATUS_T_WIDTH  32
  `define CR_KME_FULL_SA_COUNT_IA_STATUS_T_ADDR       04:00
  `define CR_KME_FULL_SA_COUNT_IA_STATUS_T_RESERVED0  23:05
  `define CR_KME_FULL_SA_COUNT_IA_STATUS_T_DATAWORDS  28:24
  `define CR_KME_FULL_SA_COUNT_IA_STATUS_T_CODE       31:29

`define CR_KME_C_SA_COUNT_IA_STATUS_T_DECL   12:0
`define CR_KME_C_SA_COUNT_IA_STATUS_T_WIDTH  13
  `define CR_KME_C_SA_COUNT_IA_STATUS_T_ADDR       04:00
  `define CR_KME_C_SA_COUNT_IA_STATUS_T_DATAWORDS  09:05
  `define CR_KME_C_SA_COUNT_IA_STATUS_T_CODE       12:10

`define CR_KME_SA_COUNT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_SA_COUNT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_SA_COUNT_IA_CAPABILITY_T_DEFAULT  (32'b xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)

`define CR_KME_SA_COUNT_IA_CAPABILITY_T_NOP_DECL   0:0
`define CR_KME_SA_COUNT_IA_CAPABILITY_T_NOP_WIDTH  1

`define CR_KME_SA_COUNT_IA_CAPABILITY_T_READ_DECL   0:0
`define CR_KME_SA_COUNT_IA_CAPABILITY_T_READ_WIDTH  1

`define CR_KME_SA_COUNT_IA_CAPABILITY_T_WRITE_DECL   0:0
`define CR_KME_SA_COUNT_IA_CAPABILITY_T_WRITE_WIDTH  1

`define CR_KME_SA_COUNT_IA_CAPABILITY_T_ENABLE_DECL   0:0
`define CR_KME_SA_COUNT_IA_CAPABILITY_T_ENABLE_WIDTH  1

`define CR_KME_SA_COUNT_IA_CAPABILITY_T_DISABLED_DECL   0:0
`define CR_KME_SA_COUNT_IA_CAPABILITY_T_DISABLED_WIDTH  1

`define CR_KME_SA_COUNT_IA_CAPABILITY_T_RESET_DECL   0:0
`define CR_KME_SA_COUNT_IA_CAPABILITY_T_RESET_WIDTH  1

`define CR_KME_SA_COUNT_IA_CAPABILITY_T_INITIALIZE_DECL   0:0
`define CR_KME_SA_COUNT_IA_CAPABILITY_T_INITIALIZE_WIDTH  1

`define CR_KME_SA_COUNT_IA_CAPABILITY_T_INITIALIZE_INC_DECL   0:0
`define CR_KME_SA_COUNT_IA_CAPABILITY_T_INITIALIZE_INC_WIDTH  1

`define CR_KME_SA_COUNT_IA_CAPABILITY_T_SET_INIT_START_DECL   0:0
`define CR_KME_SA_COUNT_IA_CAPABILITY_T_SET_INIT_START_WIDTH  1

`define CR_KME_SA_COUNT_IA_CAPABILITY_T_COMPARE_DECL   0:0
`define CR_KME_SA_COUNT_IA_CAPABILITY_T_COMPARE_WIDTH  1

`define CR_KME_SA_COUNT_IA_CAPABILITY_T_RESERVED_OP_DECL   3:0
`define CR_KME_SA_COUNT_IA_CAPABILITY_T_RESERVED_OP_WIDTH  4

`define CR_KME_SA_COUNT_IA_CAPABILITY_T_SIM_TMO_DECL   0:0
`define CR_KME_SA_COUNT_IA_CAPABILITY_T_SIM_TMO_WIDTH  1

`define CR_KME_SA_COUNT_IA_CAPABILITY_T_ACK_ERROR_DECL   0:0
`define CR_KME_SA_COUNT_IA_CAPABILITY_T_ACK_ERROR_WIDTH  1

`define CR_KME_SA_COUNT_IA_CAPABILITY_T_MEM_TYPE_DECL   3:0
`define CR_KME_SA_COUNT_IA_CAPABILITY_T_MEM_TYPE_WIDTH  4

`define CR_KME_FULL_SA_COUNT_IA_CAPABILITY_T_DECL   31:0
`define CR_KME_FULL_SA_COUNT_IA_CAPABILITY_T_WIDTH  32
  `define CR_KME_FULL_SA_COUNT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_FULL_SA_COUNT_IA_CAPABILITY_T_READ            01
  `define CR_KME_FULL_SA_COUNT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_FULL_SA_COUNT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_FULL_SA_COUNT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_FULL_SA_COUNT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_FULL_SA_COUNT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_FULL_SA_COUNT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_FULL_SA_COUNT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_FULL_SA_COUNT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_FULL_SA_COUNT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_FULL_SA_COUNT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_FULL_SA_COUNT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_FULL_SA_COUNT_IA_CAPABILITY_T_RESERVED0       27:16
  `define CR_KME_FULL_SA_COUNT_IA_CAPABILITY_T_MEM_TYPE        31:28

`define CR_KME_C_SA_COUNT_IA_CAPABILITY_T_DECL   19:0
`define CR_KME_C_SA_COUNT_IA_CAPABILITY_T_WIDTH  20
  `define CR_KME_C_SA_COUNT_IA_CAPABILITY_T_NOP             00
  `define CR_KME_C_SA_COUNT_IA_CAPABILITY_T_READ            01
  `define CR_KME_C_SA_COUNT_IA_CAPABILITY_T_WRITE           02
  `define CR_KME_C_SA_COUNT_IA_CAPABILITY_T_ENABLE          03
  `define CR_KME_C_SA_COUNT_IA_CAPABILITY_T_DISABLED        04
  `define CR_KME_C_SA_COUNT_IA_CAPABILITY_T_RESET           05
  `define CR_KME_C_SA_COUNT_IA_CAPABILITY_T_INITIALIZE      06
  `define CR_KME_C_SA_COUNT_IA_CAPABILITY_T_INITIALIZE_INC  07
  `define CR_KME_C_SA_COUNT_IA_CAPABILITY_T_SET_INIT_START  08
  `define CR_KME_C_SA_COUNT_IA_CAPABILITY_T_COMPARE         09
  `define CR_KME_C_SA_COUNT_IA_CAPABILITY_T_RESERVED_OP     13:10
  `define CR_KME_C_SA_COUNT_IA_CAPABILITY_T_SIM_TMO         14
  `define CR_KME_C_SA_COUNT_IA_CAPABILITY_T_ACK_ERROR       15
  `define CR_KME_C_SA_COUNT_IA_CAPABILITY_T_MEM_TYPE        19:16

`define CR_KME_KDF_TEST_KEY_SIZE_T_DECL   31:0
`define CR_KME_KDF_TEST_KEY_SIZE_T_WIDTH  32
  `define CR_KME_KDF_TEST_KEY_SIZE_T_DEFAULT  (32'h 0)

`define CR_KME_KDF_TEST_KEY_SIZE_T_KEY_SIZE_DECL   31:0
`define CR_KME_KDF_TEST_KEY_SIZE_T_KEY_SIZE_WIDTH  32
  `define CR_KME_KDF_TEST_KEY_SIZE_T_KEY_SIZE_DEFAULT  (32'h 0)

`define CR_KME_FULL_KDF_TEST_KEY_SIZE_T_DECL   31:0
`define CR_KME_FULL_KDF_TEST_KEY_SIZE_T_WIDTH  32
  `define CR_KME_FULL_KDF_TEST_KEY_SIZE_T_KEY_SIZE  31:00

`define CR_KME_C_KDF_TEST_KEY_SIZE_T_DECL   31:0
`define CR_KME_C_KDF_TEST_KEY_SIZE_T_WIDTH  32
  `define CR_KME_C_KDF_TEST_KEY_SIZE_T_KEY_SIZE  31:00



`define CR_KME_NUMREG 269

`define CR_KME_MAXREG 1116

`define CR_KME_DECL   10:0
`define CR_KME_WIDTH  11
  `define CR_KME_BLKID_REVID_CONFIG                  (11'h 0)
  `define CR_KME_REVISION_CONFIG                     (11'h 4)
  `define CR_KME_SPARE_CONFIG                        (11'h 8)
  `define CR_KME_CCEIP0_OUT_IA_CAPABILITY            (11'h c)
  `define CR_KME_CCEIP0_OUT_IA_STATUS                (11'h 10)
  `define CR_KME_CCEIP0_OUT_IA_WDATA_PART0           (11'h 14)
  `define CR_KME_CCEIP0_OUT_IA_WDATA_PART1           (11'h 18)
  `define CR_KME_CCEIP0_OUT_IA_WDATA_PART2           (11'h 1c)
  `define CR_KME_CCEIP0_OUT_IA_CONFIG                (11'h 20)
  `define CR_KME_CCEIP0_OUT_IA_RDATA_PART0           (11'h 24)
  `define CR_KME_CCEIP0_OUT_IA_RDATA_PART1           (11'h 28)
  `define CR_KME_CCEIP0_OUT_IA_RDATA_PART2           (11'h 2c)
  `define CR_KME_CCEIP0_OUT_IM_CONFIG                (11'h 30)
  `define CR_KME_CCEIP0_OUT_IM_STATUS                (11'h 34)
  `define CR_KME_CCEIP0_OUT_IM_READ_DONE             (11'h 38)
  `define CR_KME_CCEIP1_OUT_IA_CAPABILITY            (11'h 3c)
  `define CR_KME_CCEIP1_OUT_IA_STATUS                (11'h 40)
  `define CR_KME_CCEIP1_OUT_IA_WDATA_PART0           (11'h 44)
  `define CR_KME_CCEIP1_OUT_IA_WDATA_PART1           (11'h 48)
  `define CR_KME_CCEIP1_OUT_IA_WDATA_PART2           (11'h 4c)
  `define CR_KME_CCEIP1_OUT_IA_CONFIG                (11'h 50)
  `define CR_KME_CCEIP1_OUT_IA_RDATA_PART0           (11'h 54)
  `define CR_KME_CCEIP1_OUT_IA_RDATA_PART1           (11'h 58)
  `define CR_KME_CCEIP1_OUT_IA_RDATA_PART2           (11'h 5c)
  `define CR_KME_CCEIP1_OUT_IM_CONFIG                (11'h 60)
  `define CR_KME_CCEIP1_OUT_IM_STATUS                (11'h 64)
  `define CR_KME_CCEIP1_OUT_IM_READ_DONE             (11'h 68)
  `define CR_KME_CCEIP2_OUT_IA_CAPABILITY            (11'h 6c)
  `define CR_KME_CCEIP2_OUT_IA_STATUS                (11'h 70)
  `define CR_KME_CCEIP2_OUT_IA_WDATA_PART0           (11'h 74)
  `define CR_KME_CCEIP2_OUT_IA_WDATA_PART1           (11'h 78)
  `define CR_KME_CCEIP2_OUT_IA_WDATA_PART2           (11'h 7c)
  `define CR_KME_CCEIP2_OUT_IA_CONFIG                (11'h 80)
  `define CR_KME_CCEIP2_OUT_IA_RDATA_PART0           (11'h 84)
  `define CR_KME_CCEIP2_OUT_IA_RDATA_PART1           (11'h 88)
  `define CR_KME_CCEIP2_OUT_IA_RDATA_PART2           (11'h 8c)
  `define CR_KME_CCEIP2_OUT_IM_CONFIG                (11'h 90)
  `define CR_KME_CCEIP2_OUT_IM_STATUS                (11'h 94)
  `define CR_KME_CCEIP2_OUT_IM_READ_DONE             (11'h 98)
  `define CR_KME_CCEIP3_OUT_IA_CAPABILITY            (11'h 9c)
  `define CR_KME_CCEIP3_OUT_IA_STATUS                (11'h a0)
  `define CR_KME_CCEIP3_OUT_IA_WDATA_PART0           (11'h a4)
  `define CR_KME_CCEIP3_OUT_IA_WDATA_PART1           (11'h a8)
  `define CR_KME_CCEIP3_OUT_IA_WDATA_PART2           (11'h ac)
  `define CR_KME_CCEIP3_OUT_IA_CONFIG                (11'h b0)
  `define CR_KME_CCEIP3_OUT_IA_RDATA_PART0           (11'h b4)
  `define CR_KME_CCEIP3_OUT_IA_RDATA_PART1           (11'h b8)
  `define CR_KME_CCEIP3_OUT_IA_RDATA_PART2           (11'h bc)
  `define CR_KME_CCEIP3_OUT_IM_CONFIG                (11'h c0)
  `define CR_KME_CCEIP3_OUT_IM_STATUS                (11'h c4)
  `define CR_KME_CCEIP3_OUT_IM_READ_DONE             (11'h c8)
  `define CR_KME_CDDIP0_OUT_IA_CAPABILITY            (11'h cc)
  `define CR_KME_CDDIP0_OUT_IA_STATUS                (11'h d0)
  `define CR_KME_CDDIP0_OUT_IA_WDATA_PART0           (11'h d4)
  `define CR_KME_CDDIP0_OUT_IA_WDATA_PART1           (11'h d8)
  `define CR_KME_CDDIP0_OUT_IA_WDATA_PART2           (11'h dc)
  `define CR_KME_CDDIP0_OUT_IA_CONFIG                (11'h e0)
  `define CR_KME_CDDIP0_OUT_IA_RDATA_PART0           (11'h e4)
  `define CR_KME_CDDIP0_OUT_IA_RDATA_PART1           (11'h e8)
  `define CR_KME_CDDIP0_OUT_IA_RDATA_PART2           (11'h ec)
  `define CR_KME_CDDIP0_OUT_IM_CONFIG                (11'h f0)
  `define CR_KME_CDDIP0_OUT_IM_STATUS                (11'h f4)
  `define CR_KME_CDDIP0_OUT_IM_READ_DONE             (11'h f8)
  `define CR_KME_CDDIP1_OUT_IA_CAPABILITY            (11'h fc)
  `define CR_KME_CDDIP1_OUT_IA_STATUS                (11'h 100)
  `define CR_KME_CDDIP1_OUT_IA_WDATA_PART0           (11'h 104)
  `define CR_KME_CDDIP1_OUT_IA_WDATA_PART1           (11'h 108)
  `define CR_KME_CDDIP1_OUT_IA_WDATA_PART2           (11'h 10c)
  `define CR_KME_CDDIP1_OUT_IA_CONFIG                (11'h 110)
  `define CR_KME_CDDIP1_OUT_IA_RDATA_PART0           (11'h 114)
  `define CR_KME_CDDIP1_OUT_IA_RDATA_PART1           (11'h 118)
  `define CR_KME_CDDIP1_OUT_IA_RDATA_PART2           (11'h 11c)
  `define CR_KME_CDDIP1_OUT_IM_CONFIG                (11'h 120)
  `define CR_KME_CDDIP1_OUT_IM_STATUS                (11'h 124)
  `define CR_KME_CDDIP1_OUT_IM_READ_DONE             (11'h 128)
  `define CR_KME_CDDIP2_OUT_IA_CAPABILITY            (11'h 12c)
  `define CR_KME_CDDIP2_OUT_IA_STATUS                (11'h 130)
  `define CR_KME_CDDIP2_OUT_IA_WDATA_PART0           (11'h 134)
  `define CR_KME_CDDIP2_OUT_IA_WDATA_PART1           (11'h 138)
  `define CR_KME_CDDIP2_OUT_IA_WDATA_PART2           (11'h 13c)
  `define CR_KME_CDDIP2_OUT_IA_CONFIG                (11'h 140)
  `define CR_KME_CDDIP2_OUT_IA_RDATA_PART0           (11'h 144)
  `define CR_KME_CDDIP2_OUT_IA_RDATA_PART1           (11'h 148)
  `define CR_KME_CDDIP2_OUT_IA_RDATA_PART2           (11'h 14c)
  `define CR_KME_CDDIP2_OUT_IM_CONFIG                (11'h 150)
  `define CR_KME_CDDIP2_OUT_IM_STATUS                (11'h 154)
  `define CR_KME_CDDIP2_OUT_IM_READ_DONE             (11'h 158)
  `define CR_KME_CDDIP3_OUT_IA_CAPABILITY            (11'h 15c)
  `define CR_KME_CDDIP3_OUT_IA_STATUS                (11'h 160)
  `define CR_KME_CDDIP3_OUT_IA_WDATA_PART0           (11'h 164)
  `define CR_KME_CDDIP3_OUT_IA_WDATA_PART1           (11'h 168)
  `define CR_KME_CDDIP3_OUT_IA_WDATA_PART2           (11'h 16c)
  `define CR_KME_CDDIP3_OUT_IA_CONFIG                (11'h 170)
  `define CR_KME_CDDIP3_OUT_IA_RDATA_PART0           (11'h 174)
  `define CR_KME_CDDIP3_OUT_IA_RDATA_PART1           (11'h 178)
  `define CR_KME_CDDIP3_OUT_IA_RDATA_PART2           (11'h 17c)
  `define CR_KME_CDDIP3_OUT_IM_CONFIG                (11'h 180)
  `define CR_KME_CDDIP3_OUT_IM_STATUS                (11'h 184)
  `define CR_KME_CDDIP3_OUT_IM_READ_DONE             (11'h 188)
  `define CR_KME_CKV_IA_CAPABILITY                   (11'h 18c)
  `define CR_KME_CKV_IA_STATUS                       (11'h 190)
  `define CR_KME_CKV_IA_WDATA_PART0                  (11'h 194)
  `define CR_KME_CKV_IA_WDATA_PART1                  (11'h 198)
  `define CR_KME_CKV_IA_CONFIG                       (11'h 19c)
  `define CR_KME_CKV_IA_RDATA_PART0                  (11'h 1a0)
  `define CR_KME_CKV_IA_RDATA_PART1                  (11'h 1a4)
  `define CR_KME_KIM_IA_CAPABILITY                   (11'h 1a8)
  `define CR_KME_KIM_IA_STATUS                       (11'h 1ac)
  `define CR_KME_KIM_IA_WDATA_PART0                  (11'h 1b0)
  `define CR_KME_KIM_IA_WDATA_PART1                  (11'h 1b4)
  `define CR_KME_KIM_IA_CONFIG                       (11'h 1b8)
  `define CR_KME_KIM_IA_RDATA_PART0                  (11'h 1bc)
  `define CR_KME_KIM_IA_RDATA_PART1                  (11'h 1c0)
  `define CR_KME_LABEL0_CONFIG                       (11'h 1c8)
  `define CR_KME_LABEL0_DATA7                        (11'h 1cc)
  `define CR_KME_LABEL0_DATA6                        (11'h 1d0)
  `define CR_KME_LABEL0_DATA5                        (11'h 1d4)
  `define CR_KME_LABEL0_DATA4                        (11'h 1d8)
  `define CR_KME_LABEL0_DATA3                        (11'h 1dc)
  `define CR_KME_LABEL0_DATA2                        (11'h 1e0)
  `define CR_KME_LABEL0_DATA1                        (11'h 1e4)
  `define CR_KME_LABEL0_DATA0                        (11'h 1e8)
  `define CR_KME_LABEL1_CONFIG                       (11'h 1f0)
  `define CR_KME_LABEL1_DATA7                        (11'h 1f4)
  `define CR_KME_LABEL1_DATA6                        (11'h 1f8)
  `define CR_KME_LABEL1_DATA5                        (11'h 1fc)
  `define CR_KME_LABEL1_DATA4                        (11'h 200)
  `define CR_KME_LABEL1_DATA3                        (11'h 204)
  `define CR_KME_LABEL1_DATA2                        (11'h 208)
  `define CR_KME_LABEL1_DATA1                        (11'h 20c)
  `define CR_KME_LABEL1_DATA0                        (11'h 210)
  `define CR_KME_LABEL2_CONFIG                       (11'h 218)
  `define CR_KME_LABEL2_DATA7                        (11'h 21c)
  `define CR_KME_LABEL2_DATA6                        (11'h 220)
  `define CR_KME_LABEL2_DATA5                        (11'h 224)
  `define CR_KME_LABEL2_DATA4                        (11'h 228)
  `define CR_KME_LABEL2_DATA3                        (11'h 22c)
  `define CR_KME_LABEL2_DATA2                        (11'h 230)
  `define CR_KME_LABEL2_DATA1                        (11'h 234)
  `define CR_KME_LABEL2_DATA0                        (11'h 238)
  `define CR_KME_LABEL3_CONFIG                       (11'h 240)
  `define CR_KME_LABEL3_DATA7                        (11'h 244)
  `define CR_KME_LABEL3_DATA6                        (11'h 248)
  `define CR_KME_LABEL3_DATA5                        (11'h 24c)
  `define CR_KME_LABEL3_DATA4                        (11'h 250)
  `define CR_KME_LABEL3_DATA3                        (11'h 254)
  `define CR_KME_LABEL3_DATA2                        (11'h 258)
  `define CR_KME_LABEL3_DATA1                        (11'h 25c)
  `define CR_KME_LABEL3_DATA0                        (11'h 260)
  `define CR_KME_LABEL4_CONFIG                       (11'h 268)
  `define CR_KME_LABEL4_DATA7                        (11'h 26c)
  `define CR_KME_LABEL4_DATA6                        (11'h 270)
  `define CR_KME_LABEL4_DATA5                        (11'h 274)
  `define CR_KME_LABEL4_DATA4                        (11'h 278)
  `define CR_KME_LABEL4_DATA3                        (11'h 27c)
  `define CR_KME_LABEL4_DATA2                        (11'h 280)
  `define CR_KME_LABEL4_DATA1                        (11'h 284)
  `define CR_KME_LABEL4_DATA0                        (11'h 288)
  `define CR_KME_LABEL5_CONFIG                       (11'h 290)
  `define CR_KME_LABEL5_DATA7                        (11'h 294)
  `define CR_KME_LABEL5_DATA6                        (11'h 298)
  `define CR_KME_LABEL5_DATA5                        (11'h 29c)
  `define CR_KME_LABEL5_DATA4                        (11'h 2a0)
  `define CR_KME_LABEL5_DATA3                        (11'h 2a4)
  `define CR_KME_LABEL5_DATA2                        (11'h 2a8)
  `define CR_KME_LABEL5_DATA1                        (11'h 2ac)
  `define CR_KME_LABEL5_DATA0                        (11'h 2b0)
  `define CR_KME_LABEL6_CONFIG                       (11'h 2b8)
  `define CR_KME_LABEL6_DATA7                        (11'h 2bc)
  `define CR_KME_LABEL6_DATA6                        (11'h 2c0)
  `define CR_KME_LABEL6_DATA5                        (11'h 2c4)
  `define CR_KME_LABEL6_DATA4                        (11'h 2c8)
  `define CR_KME_LABEL6_DATA3                        (11'h 2cc)
  `define CR_KME_LABEL6_DATA2                        (11'h 2d0)
  `define CR_KME_LABEL6_DATA1                        (11'h 2d4)
  `define CR_KME_LABEL6_DATA0                        (11'h 2d8)
  `define CR_KME_LABEL7_CONFIG                       (11'h 2e0)
  `define CR_KME_LABEL7_DATA7                        (11'h 2e4)
  `define CR_KME_LABEL7_DATA6                        (11'h 2e8)
  `define CR_KME_LABEL7_DATA5                        (11'h 2ec)
  `define CR_KME_LABEL7_DATA4                        (11'h 2f0)
  `define CR_KME_LABEL7_DATA3                        (11'h 2f4)
  `define CR_KME_LABEL7_DATA2                        (11'h 2f8)
  `define CR_KME_LABEL7_DATA1                        (11'h 2fc)
  `define CR_KME_LABEL7_DATA0                        (11'h 300)
  `define CR_KME_KDF_DRBG_CTRL                       (11'h 308)
  `define CR_KME_KDF_DRBG_SEED_0_STATE_KEY_31_0      (11'h 30c)
  `define CR_KME_KDF_DRBG_SEED_0_STATE_KEY_63_32     (11'h 310)
  `define CR_KME_KDF_DRBG_SEED_0_STATE_KEY_95_64     (11'h 314)
  `define CR_KME_KDF_DRBG_SEED_0_STATE_KEY_127_96    (11'h 318)
  `define CR_KME_KDF_DRBG_SEED_0_STATE_KEY_159_128   (11'h 31c)
  `define CR_KME_KDF_DRBG_SEED_0_STATE_KEY_191_160   (11'h 320)
  `define CR_KME_KDF_DRBG_SEED_0_STATE_KEY_223_192   (11'h 324)
  `define CR_KME_KDF_DRBG_SEED_0_STATE_KEY_255_224   (11'h 328)
  `define CR_KME_KDF_DRBG_SEED_0_STATE_VALUE_31_0    (11'h 32c)
  `define CR_KME_KDF_DRBG_SEED_0_STATE_VALUE_63_32   (11'h 330)
  `define CR_KME_KDF_DRBG_SEED_0_STATE_VALUE_95_64   (11'h 334)
  `define CR_KME_KDF_DRBG_SEED_0_STATE_VALUE_127_96  (11'h 338)
  `define CR_KME_KDF_DRBG_SEED_0_RESEED_INTERVAL_0   (11'h 33c)
  `define CR_KME_KDF_DRBG_SEED_0_RESEED_INTERVAL_1   (11'h 340)
  `define CR_KME_KDF_DRBG_SEED_1_STATE_KEY_31_0      (11'h 344)
  `define CR_KME_KDF_DRBG_SEED_1_STATE_KEY_63_32     (11'h 348)
  `define CR_KME_KDF_DRBG_SEED_1_STATE_KEY_95_64     (11'h 34c)
  `define CR_KME_KDF_DRBG_SEED_1_STATE_KEY_127_96    (11'h 350)
  `define CR_KME_KDF_DRBG_SEED_1_STATE_KEY_159_128   (11'h 354)
  `define CR_KME_KDF_DRBG_SEED_1_STATE_KEY_191_160   (11'h 358)
  `define CR_KME_KDF_DRBG_SEED_1_STATE_KEY_223_192   (11'h 35c)
  `define CR_KME_KDF_DRBG_SEED_1_STATE_KEY_255_224   (11'h 360)
  `define CR_KME_KDF_DRBG_SEED_1_STATE_VALUE_31_0    (11'h 364)
  `define CR_KME_KDF_DRBG_SEED_1_STATE_VALUE_63_32   (11'h 368)
  `define CR_KME_KDF_DRBG_SEED_1_STATE_VALUE_95_64   (11'h 36c)
  `define CR_KME_KDF_DRBG_SEED_1_STATE_VALUE_127_96  (11'h 370)
  `define CR_KME_KDF_DRBG_SEED_1_RESEED_INTERVAL_0   (11'h 374)
  `define CR_KME_KDF_DRBG_SEED_1_RESEED_INTERVAL_1   (11'h 378)
  `define CR_KME_INTERRUPT_STATUS                    (11'h 37c)
  `define CR_KME_INTERRUPT_MASK                      (11'h 380)
  `define CR_KME_ENGINE_STICKY_STATUS                (11'h 384)
  `define CR_KME_BIMC_MONITOR                        (11'h 38c)
  `define CR_KME_BIMC_MONITOR_MASK                   (11'h 390)
  `define CR_KME_BIMC_ECC_UNCORRECTABLE_ERROR_CNT    (11'h 394)
  `define CR_KME_BIMC_ECC_CORRECTABLE_ERROR_CNT      (11'h 398)
  `define CR_KME_BIMC_PARITY_ERROR_CNT               (11'h 39c)
  `define CR_KME_BIMC_GLOBAL_CONFIG                  (11'h 3a0)
  `define CR_KME_BIMC_MEMID                          (11'h 3a4)
  `define CR_KME_BIMC_ECCPAR_DEBUG                   (11'h 3a8)
  `define CR_KME_BIMC_CMD2                           (11'h 3ac)
  `define CR_KME_BIMC_CMD1                           (11'h 3b0)
  `define CR_KME_BIMC_CMD0                           (11'h 3b4)
  `define CR_KME_BIMC_RXCMD2                         (11'h 3b8)
  `define CR_KME_BIMC_RXCMD1                         (11'h 3bc)
  `define CR_KME_BIMC_RXCMD0                         (11'h 3c0)
  `define CR_KME_BIMC_RXRSP2                         (11'h 3c4)
  `define CR_KME_BIMC_RXRSP1                         (11'h 3c8)
  `define CR_KME_BIMC_RXRSP0                         (11'h 3cc)
  `define CR_KME_BIMC_POLLRSP2                       (11'h 3d0)
  `define CR_KME_BIMC_POLLRSP1                       (11'h 3d4)
  `define CR_KME_BIMC_POLLRSP0                       (11'h 3d8)
  `define CR_KME_BIMC_DBGCMD2                        (11'h 3dc)
  `define CR_KME_BIMC_DBGCMD1                        (11'h 3e0)
  `define CR_KME_BIMC_DBGCMD0                        (11'h 3e4)
  `define CR_KME_IM_AVAILABLE                        (11'h 3ec)
  `define CR_KME_IM_CONSUMED                         (11'h 3f0)
  `define CR_KME_TREADY_OVERRIDE                     (11'h 3f4)
  `define CR_KME_REGS_SA_CTRL                        (11'h 3f8)
  `define CR_KME_SA_SNAPSHOT_IA_CAPABILITY           (11'h 3fc)
  `define CR_KME_SA_SNAPSHOT_IA_STATUS               (11'h 400)
  `define CR_KME_SA_SNAPSHOT_IA_WDATA_PART0          (11'h 404)
  `define CR_KME_SA_SNAPSHOT_IA_WDATA_PART1          (11'h 408)
  `define CR_KME_SA_SNAPSHOT_IA_CONFIG               (11'h 40c)
  `define CR_KME_SA_SNAPSHOT_IA_RDATA_PART0          (11'h 410)
  `define CR_KME_SA_SNAPSHOT_IA_RDATA_PART1          (11'h 414)
  `define CR_KME_SA_COUNT_IA_CAPABILITY              (11'h 418)
  `define CR_KME_SA_COUNT_IA_STATUS                  (11'h 41c)
  `define CR_KME_SA_COUNT_IA_WDATA_PART0             (11'h 420)
  `define CR_KME_SA_COUNT_IA_WDATA_PART1             (11'h 424)
  `define CR_KME_SA_COUNT_IA_CONFIG                  (11'h 428)
  `define CR_KME_SA_COUNT_IA_RDATA_PART0             (11'h 42c)
  `define CR_KME_SA_COUNT_IA_RDATA_PART1             (11'h 430)
  `define CR_KME_IDLE_COMPONENTS                     (11'h 434)
  `define CR_KME_CCEIP_ENCRYPT_KOP_FIFO_OVERRIDE     (11'h 438)
  `define CR_KME_CCEIP_VALIDATE_KOP_FIFO_OVERRIDE    (11'h 43c)
  `define CR_KME_CDDIP_DECRYPT_KOP_FIFO_OVERRIDE     (11'h 440)
  `define CR_KME_SA_GLOBAL_CTRL                      (11'h 444)
  `define CR_KME_SA_CTRL_IA_CAPABILITY               (11'h 448)
  `define CR_KME_SA_CTRL_IA_STATUS                   (11'h 44c)
  `define CR_KME_SA_CTRL_IA_WDATA_PART0              (11'h 450)
  `define CR_KME_SA_CTRL_IA_CONFIG                   (11'h 454)
  `define CR_KME_SA_CTRL_IA_RDATA_PART0              (11'h 458)
  `define CR_KME_KDF_TEST_KEY_SIZE_CONFIG            (11'h 45c)

`endif
