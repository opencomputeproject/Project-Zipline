/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










`include "cr_structs.sv"


typedef struct packed {
    logic  [0:0] valid;
    logic  [2:0] label_index;
    logic  [1:0] ckv_length;
    logic [14:0] ckv_pointer;
    logic  [3:0] pf_num;
    logic [11:0] vf_num;
    logic  [0:0] vf_valid;
} kim_entry_t;

typedef struct packed {
    logic    [0:0] guid_size;
    logic    [5:0] label_size;
    logic  [255:0] label;
    logic    [0:0] delimiter_valid;
    logic    [7:0] delimiter;
} label_t;

typedef struct packed {
    logic    [0:0] valid;
    logic    [2:0] label_index;
    logic    [0:0] pf_num;
    logic    [0:0] vf_valid;
    logic    [8:0] vf_num;
    logic  [511:0] ckv_key;
} kim_ckv_resp_t;

typedef enum logic [3:0] {
    KME_WORD0        = 4'd0,
    KME_DEBUG_KEYHDR = 4'd1,
    KME_IVTWEAK      = 4'd2,
    KME_GUID         = 4'd3,
    KME_KIM          = 4'd4,
    KME_DEK_CKV0     = 4'd5,
    KME_DEK_CKV1     = 4'd6,
    KME_DAK_CKV      = 4'd7,
    KME_EIV          = 4'd8,
    KME_DEK0         = 4'd9,
    KME_DEK1         = 4'd10,
    KME_ETAG         = 4'd11,
    KME_AIV          = 4'd12,
    KME_DAK          = 4'd13,
    KME_ATAG         = 4'd14,
    KME_ERROR        = 4'd15
} kme_internal_id;

typedef enum logic [5:0] {
    IDX_KME_WORD0        = 6'd0,
    IDX_KME_DEBUG_KEYHDR = 6'd1,
    IDX_KME_GUID         = 6'd2,
    IDX_KME_IVTWEAK      = 6'd6,
    IDX_KME_KIM          = 6'd8,
    IDX_KME_DEK_CKV0     = 6'd10,
    IDX_KME_DEK_CKV1     = 6'd14,
    IDX_KME_DAK_CKV      = 6'd18,
    IDX_KME_EIV          = 6'd22,
    IDX_KME_DEK0         = 6'd24,
    IDX_KME_DEK1         = 6'd28,
    IDX_KME_ETAG         = 6'd32,
    IDX_KME_AIV          = 6'd34,
    IDX_KME_DAK          = 6'd36,
    IDX_KME_ATAG         = 6'd40,
    IDX_KME_ERROR        = 6'd42
} kme_internal_idx;

typedef struct packed {
    logic   [0:0]   sot;   
    logic   [0:0]   eoi;   
    logic   [0:0]   eot;   
    kme_internal_id id;    
    logic  [63:0]   tdata; 
} kme_internal_t;

typedef struct packed {
   logic [1:0]     tlv_bip2;
   logic [12:0]    resv0;
   logic [0:0]     kdf_dek_iter;
   logic [0:0]     keyless_algos;
   logic [0:0]     needs_dek;
   logic [0:0]     needs_dak;
   aux_key_type_e  key_type;
   logic [10:0]    tlv_frame_num;
   logic [3:0]     tlv_eng_id;
   logic [7:0]     tlv_seq_num;
   logic [7:0]     tlv_len;
   tlv_types_e     tlv_type;
} kme_internal_word_0_t;

typedef struct packed {
    kim_entry_t     dek_kim_entry;
    logic  [5:0]    unused;
    logic  [0:0]    missing_iv;
    logic  [0:0]    missing_guid;
    logic  [0:0]    validate_dek;
    logic  [0:0]    vf_valid;
    logic  [3:0]    pf_num;
    logic [11:0]    vf_num;
} kme_internal_word_8_t;

typedef struct packed {
    kim_entry_t     dak_kim_entry;
    logic  [7:0]    unused;
    logic  [0:0]    validate_dak;
    logic  [0:0]    vf_valid;
    logic  [3:0]    pf_num;
    logic [11:0]    vf_num;
} kme_internal_word_9_t;

typedef struct packed {
    logic  [0:0]    corrupt_crc32;
    logic [46:0]    unused;
    zipline_error_e  error_code;
} kme_internal_word_42_t;


typedef enum logic [2:0] {
    PT_CKV              = 3'd0,
    PT_KEY_BLOB         = 3'd1,
    DECRYPT_DEK256      = 3'd2,
    DECRYPT_DEK512      = 3'd3,
    DECRYPT_DAK         = 3'd4,
    DECRYPT_DEK256_COMB = 3'd5,
    DECRYPT_DEK512_COMB = 3'd6,
    DECRYPT_DAK_COMB    = 3'd7
} gcm_op_e;

typedef struct packed {
    logic    [255:0] key0;
    logic    [255:0] key1;
    logic     [95:0] iv;
    gcm_op_e         op;
} gcm_cmd_t;

typedef struct packed {
    logic [0:0] tag_mismatch;
} gcm_status_t;

typedef struct packed {
    logic [0:0] combo_mode;
} keyfilter_cmd_t;

typedef struct packed {
    logic  [0:0]    kdf_dek_iter;
    logic  [0:0]    combo_mode;
    aux_key_op_e    dek_key_op;
    aux_key_op_e    dak_key_op;
} kdf_cmd_t;

typedef struct packed {
    logic   [0:0] combo_mode;
    logic   [0:0] skip;
    logic [255:0] guid;
    logic   [2:0] label_index;
    logic   [1:0] num_iter;
} kdfstream_cmd_t;


