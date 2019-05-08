// *************************************************************************
//
// Copyright © Microsoft Corporation. All rights reserved.
// Copyright © Broadcom Inc. All rights reserved.
// Licensed under the MIT License.
//
// *************************************************************************
//
//------------------------------------------------------------------------------
`include "cr_global_params.vh"
`include "cr_native_types.svh"

`include "cr_error_codes.svh"


//Structs for AXI4S Data Path Interfaces
typedef struct packed {
  logic                          tvalid;
  logic                          tlast;
  logic [`AXI_S_TID_WIDTH-1:0]   tid;
  logic [`AXI_S_TSTRB_WIDTH-1:0] tstrb;
  logic [`AXI_S_USER_WIDTH-1:0]  tuser;
  logic [`AXI_S_DP_DWIDTH-1:0]   tdata;
} axi4s_dp_bus_t;

// Slave inputs
typedef struct packed {
  logic        tready;
} axi4s_dp_rdy_t;

// For rbus top level input
typedef struct packed {
  logic [`N_RBUS_ADDR_BITS-1:0] addr;
  logic                         wr_strb;
  logic [`N_RBUS_DATA_BITS-1:0] wr_data;
  logic                         rd_strb;
} rbus_in_t;

// For rbus top level output
typedef struct packed {
  logic [`N_RBUS_DATA_BITS-1:0] rd_data;
  logic                         ack;
  logic                         err_ack;
} rbus_out_t;

// For rbus ring network
typedef struct packed {
  logic [`N_RBUS_ADDR_BITS-1:0] addr;  
  logic                         wr_strb;
  logic [`N_RBUS_DATA_BITS-1:0] wr_data;
  logic                         rd_strb;
  logic [`N_RBUS_DATA_BITS-1:0] rd_data;
  logic                         ack;    
  logic                         err_ack;
} rbus_ring_t;

// For rbus ring network
typedef struct packed {
  logic [`N_KME_RBUS_ADDR_BITS-1:0] addr;  
  logic                         wr_strb;
  logic [`N_RBUS_DATA_BITS-1:0] wr_data;
  logic                         rd_strb;
  logic [`N_RBUS_DATA_BITS-1:0] rd_data;
  logic                         ack;    
  logic                         err_ack;
} kme_rbus_ring_t;

// Interface monitor structures
typedef struct packed {
   logic                          eob;
   logic [`AXI_S_TSTRB_WIDTH-1:0] bytes_vld;
   logic [22:0]                   im_meta;                     
} im_desc_t;

typedef struct packed {
   logic [`AXI_S_DP_DWIDTH-1:0]  data;
} im_data_t;

typedef struct packed {
   im_data_t data;
   im_desc_t desc;
} im_din_t;
   
typedef struct packed {
   logic                         bank_hi;   
   logic                         bank_lo;         
} im_available_t;

typedef struct packed {
   logic                         bank_hi;   
   logic                         bank_lo;         
} im_consumed_t;

//Frame Latency Interface
typedef struct packed {
  logic                           valid;
  logic [`TLV_SEQ_NUM_WIDTH-1:0]  seq_num;
} frame_latency_if_bus_t;

// Scheduler Update Interface
typedef struct packed {
  logic                         valid;
  logic [15:0]                  rqe_sched_handle;
  logic                         last;
  logic [10:0]                  tlv_frame_num;
  logic [3:0]                   tlv_eng_id;
  logic [7:0]                   tlv_seq_num;
  logic [`SU_BYTES_WIDTH-1:0]   bytes_in;
  logic [`SU_BYTES_WIDTH-1:0]   bytes_out;
  logic [`SU_BYTES_WIDTH-1:0]   basis;
} sched_update_if_bus_t;


// TLV Parser Interface
typedef struct packed {
  logic                           insert;
  logic [`TLVP_ORD_NUM_WIDTH-1:0] ordern;
  tlv_types_e                     typen;
  logic                           sot;
  logic                           eot;
  logic                           tlast;
  logic [`AXI_S_TID_WIDTH-1:0]    tid;
  logic [`AXI_S_TSTRB_WIDTH-1:0]  tstrb;
  logic [`AXI_S_USER_WIDTH-1:0]   tuser;
  logic [`AXI_S_DP_DWIDTH-1:0]    tdata;
} tlvp_if_bus_t;

// LZ77 to Huffman Compress interface
typedef struct  packed {
   logic [3:0]  framing;
   logic [7:0]  data0;
   logic [7:0]  data1;
   logic [7:0]  data2;
   logic [7:0]  data3;
   logic        backref;
   logic        backref_type;
   logic [1:0]  backref_lane;
   logic [7:0]  offset_msb;
   logic [15:0] length;
} lz_symbol_bus_t;

// TLV word 0, common to all TLV types       
typedef struct  packed {
   logic [ 1:0]      tlv_bip2;
   logic [18:0]      resv0;
   logic [10:0]      tlv_frame_num;
   logic [ 3:0]      resv1;
   logic [ 3:0]      tlv_eng_id;
   logic [ 7:0]      tlv_seq_num;       
   logic [ 7:0]      tlv_len;
   tlv_types_e       tlv_type;
} tlv_word_0_t;
 
// TLV word 0 for RQE TLV                    
typedef struct  packed {
   logic [1:0]      tlv_bip2;
   logic            no_data;
   logic            aux_frmd_crc;
   rqe_frame_size_e frame_size;
   logic            vf_valid;
   rqe_trace_e      trace;
   logic [10:0]     unused;
   logic [10:0]     tlv_frame_num;
   logic [3:0]      resv0;
   logic [3:0]      tlv_eng_id;
   logic [7:0]      tlv_seq_num;
   logic [7:0]      tlv_len;
   tlv_types_e      tlv_type;
} tlv_rqe_word_0_t;
 
// TLV word 0 for data unknown TLV            
typedef struct  packed {
   logic [1:0]      tlv_bip2;
   logic            last_of_command;   
   logic [15:0]     resv0;
   frmd_coding_e    coding;      
   logic [10:0]     tlv_frame_num;
   logic [3:0]      resv1;
   logic [3:0]      tlv_eng_id;
   logic [7:0]      tlv_seq_num;        
   logic [7:0]      tlv_len;     
   tlv_types_e      tlv_type;
} tlv_data_word_0_t;
 

// RQE TLV word 1                          
typedef struct  packed {
   logic [ 3:0]       pf_number;
   logic [11:0]       vf_number;
   logic [15:0]       scheduler_handle;
   logic [31:0]       src_data_len;
} tlv_rqe_word_1_t;

//Struct for CMD.debug field
typedef struct packed { 
   tlvp_corrupt_e     tlvp_corrupt;
   cmd_mode_e         cmd_mode;
   logic [4:0]        module_id;  
   cmd_type_e         cmd_type;
   logic [4:0]        tlv_num;
   logic [9:0]        byte_num;
   logic [7:0]        byte_msk;
} cmd_debug_t;

//Struct for backpressure debug field
typedef struct packed {
   logic [0:0]        rsvd;
   logic [10:0]       on_count;
   logic [10:0]       off_count;
} bp_debug_t;


// CMD TLV word 1                                 
typedef struct  packed {
   cmd_debug_t                  debug;             // 32
   logic                        trace;             // 1    
   logic                        dst_guid_present;  // 1    
   logic [6:0]                  frmd_out_type;     // 7    
   cmd_md_op_e                  md_op;             // 2 
   cmd_md_type_e                md_type;           // 2 
   logic [6:0]                  frmd_in_type;      // 7 
   logic [5:0]                  frmd_in_aux;       // 6
   cmd_frmd_crc_in_e            frmd_crc_in;       // 1 
   cmd_guid_present_e           src_guid_present;  // 1  
   cmd_compound_cmd_frm_size_e  compound_cmd_frm_size; // 4
} tlv_cmd_word_1_t;

// CMD TLV word 2
typedef struct  packed {   
   logic                       rsvd2;                 // 1 
   aux_key_type_e              key_type;              // 6
   logic [1:0]                 rsvd1;                 // 2
   cmd_cipher_pad_e            cipher_pad;            // 1 
   cmd_iv_op_e                 iv_op;                 // 2
   logic [7:0]                 aad_len;               // 8
   cmd_cipher_op_e             cipher_op;             // 4
   cmd_auth_op_e               auth_op;               // 4
   cmd_auth_op_e               raw_auth_op;           // 4
   logic [7:0]                 rsvd0;                 // 8
   cmd_chu_comp_thrsh_e        chu_comp_thrsh;        // 2
   cmd_xp10_crc_mode_e         xp10_crc_mode;         // 1
   logic [5:0]                 xp10_user_prefix_size; // 6
   cmd_xp10_prefix_mode_e      xp10_prefix_mode;      // 2
   cmd_lz77_max_symb_len_e     lz77_max_symb_len;     // 2
   cmd_lz77_min_match_len_e    lz77_min_match_len;    // 1
   cmd_lz77_dly_match_win_e    lz77_dly_match_win;    // 2
   cmd_lz77_win_size_e         lz77_win_size;         // 4
   cmd_comp_mode_e             comp_mode;             // 4
} tlv_cmd_word_2_t;


// KEY TLV word 1
typedef struct packed { 
   logic [63:0] guid;
} tlv_key_word1_t;

// KEY TLV word 2
typedef struct packed { 
   logic [63:0] guid;
} tlv_key_word2_t;


// KEY TLV word 3
typedef struct packed { 
   logic [63:0] guid;
} tlv_key_word3_t;

// KEY TLV word 4
typedef struct packed { 
   logic [63:0] guid;
} tlv_key_word4_t;


// KEY TLV word 5
typedef struct packed { 
   logic [63:0] ivtweak;
} tlv_key_word5_t;


// KEY TLV word 6
typedef struct packed { 
   logic [63:0] ivtweak;
} tlv_key_word6_t;


// KEY TLV word 7
typedef struct packed { 
   logic [63:0] dek;
} tlv_key_word7_t;


// KEY TLV word 8
typedef struct packed { 
   logic [63:0] dek;
} tlv_key_word8_t;


// KEY TLV word 9
typedef struct packed { 
   logic [63:0] dek;
} tlv_key_word9_t;


// KEY TLV word 10
typedef struct packed { 
   logic [63:0] dek;
} tlv_key_word10_t;


// KEY TLV word 11
typedef struct packed { 
   logic [63:0] dek;
} tlv_key_word11_t;


// KEY TLV word 12
typedef struct packed { 
   logic [63:0] dek;
} tlv_key_word12_t;


// KEY TLV word 13
typedef struct packed { 
   logic [63:0] dek;
} tlv_key_word13_t;



// KEY TLV word 14
typedef struct packed { 
   logic [63:0] dek;
} tlv_key_word14_t;


// KEY TLV word 15
typedef struct packed { 
   logic [63:0] dak;
} tlv_key_word15_t;


// KEY TLV word 16
typedef struct packed { 
   logic [63:0] dak;
} tlv_key_word16_t;

// KEY TLV word 17
typedef struct packed { 
   logic [63:0] dak;
} tlv_key_word17_t;


// KEY TLV word 18
typedef struct packed { 
   logic [63:0] dak;
} tlv_key_word18_t;

// KEY TLV word 19
typedef struct packed { 
   logic   [55:0]   rsvd;
   zipline_error_e   kme_errors;
} tlv_key_word19_t;

// KEY TLV word 20
typedef struct packed { 
   logic [31:0] rsvd;
   logic [31:0] crc32;
} tlv_key_word20_t;



// Predetermined Huffman TLV Word 1
typedef struct packed { 
   logic [63:6] rsvd;
   logic [5:0] xp10_prefix_sel;
} tlv_phd_word1_t;

// Prefix Data TLV word 0
typedef struct  packed {
   logic [1:0]      tlv_bip2;
   logic [11:0]     resv0;
   logic            prefix_src;
   logic [5:0]      xp10_prefix_sel;
   logic [10:0]     tlv_frame_num;
   logic [3:0]      resv1;
   logic [3:0]      tlv_eng_id;
   logic [7:0]      tlv_seq_num;
   logic [7:0]      tlv_len;
   tlv_types_e      tlv_type;
} tlv_pfd_word0_t;

// Prefix TLV Word 1  
typedef struct packed { 
   logic [63:6] rsvd;
   logic [5:0] xp10_prefix_sel;
} tlv_pfd_word1_t;


//GUID TLV word 1
typedef struct packed { 
   logic [63:0] guid;
} tlv_guid_word1_t;


//GUID TLV word 2
typedef struct packed { 
   logic [63:0] guid;
} tlv_guid_word2_t;



//GUID TLV word 3
typedef struct packed { 
   logic [63:0] guid;
} tlv_guid_word3_t;


//GUID TLV word 4
typedef struct packed { 
   logic [63:0] guid;
} tlv_guid_word4_t;


//FOOTER TLV word 0
typedef struct  packed {
   logic [1:0]      tlv_bip2;
   logic [1:0]      rsvd3;
   logic [7:0]      gen_frmd_out_type;
   logic [1:0]      rsvd2;  
   frmd_mac_size_e  raw_data_mac_size;  
   frmd_mac_size_e  enc_cmp_data_mac_size;
   frmd_coding_e    coding;
   logic            rsvd1;  
   logic [10:0]     tlv_frame_num;
   logic [3:0]      rsvd0;
   logic [3:0]      tlv_eng_id;
   logic [7:0]      tlv_seq_num;
   logic [7:0]      tlv_len;
   tlv_types_e      tlv_type;
} tlv_ftr_word0_t;
 

//FOOTER TLV word 1
typedef struct packed { 
   logic [63:0]     raw_data_mac;
} tlv_ftr_word1_t;

//FOOTER TLV word 2
typedef struct packed { 
   logic [63:0]     raw_data_mac;
} tlv_ftr_word2_t;

//FOOTER TLV word 3 
typedef struct packed { 
   logic [63:0]     raw_data_mac;
} tlv_ftr_word3_t;

//FOOTER TLV word 4 
typedef struct packed { 
   logic [63:0]     raw_data_mac;
} tlv_ftr_word4_t;


//FOOTER TLV word 5 
typedef struct packed { 
   logic [63:0]     raw_data_cksum;
} tlv_ftr_word5_t;


//FOOTER TLV word 6 
typedef struct packed { 
  logic [63:0]      raw_data_cksum_protocol;
} tlv_ftr_word6_t;

//FOOTER TLV word 7 
typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;
} tlv_ftr_word7_t;

//FOOTER TLV word 8 
typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;
} tlv_ftr_word8_t;

//FOOTER TLV word 9 
typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;
} tlv_ftr_word9_t;

//FOOTER TLV word 10
typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;
} tlv_ftr_word10_t;

//FOOTER TLV word 11
typedef struct packed { 
   logic [63:0]     enc_cmp_data_cksum;
} tlv_ftr_word11_t;

//FOOTER TLV word 12
typedef struct packed { 
   logic [15:0]     nvme_raw_cksum_crc16t;
   logic [23:0]     bytes_in;
   logic [23:0]     bytes_out;  
} tlv_ftr_word12_t;


//FOOTER TLV word 13
typedef struct packed { 
   logic [19:0]     rsvd1;  
   logic [23:0]     compressed_length;  
   zipline_error_e   error_code;
   logic            rsvd0;  
   logic [10:0]     errored_frame_number;
} tlv_ftr_word13_t;


//FOOTER TLV GUID word 0
typedef struct packed { 
   logic [63:0] guid;
} tlv_ftr_guid_word0_t;

//FOOTER TLV GUID word 1
typedef struct packed { 
   logic [63:0] guid;
} tlv_ftr_guid_word1_t;

//FOOTER TLV GUID word 2
typedef struct packed { 
   logic [63:0] guid;
} tlv_ftr_guid_word2_t;

//FOOTER TLV GUID word 3
typedef struct packed { 
   logic [63:0] guid;
} tlv_ftr_guid_word3_t;

//FOOTER TLV IV word 0
typedef struct packed {  
   logic [31:0] rsvd;
   logic [31:0] iv;
} tlv_ftr_iv_word0_t;

//FOOTER TLV IV word 1
typedef struct packed { 
   logic [63:0] iv;
} tlv_ftr_iv_word1_t;


//STATS TLV word1                            
typedef struct packed { 
   logic [ 7:0]                       rsvd1;
   logic [23:0]                       bytes_in;
   logic [ 7:0]                       rsvd0;
   logic [23:0]                       bytes_out;  
} tlv_stats_word1_t;

//STATS TLV word2                            
typedef struct packed { 
   logic [30:0]                       rsvd1;
   logic                              frame_error;
   logic [ 7:0]                       rsvd0;
   logic [23:0]                       latency;  
} tlv_stats_word2_t;



//CQE TLV word1                             
typedef struct packed { 
   logic [ 7:0]  status_code; 
   logic         do_not_resend; 
   logic         vf_valid; 
   logic [ 1:0]  rsvd0;
   logic [ 7:0]  error_code;
   logic [11:0]  errored_frame_number;
   logic [ 2:0]  status_code_type; 
   logic [12:0]  stat_cts;
   logic [ 3:0]  pf_number; 
   logic [11:0]  vf_number; 
} tlv_cqe_word1_t;




//FRMD_USER_PI16 TLV Word1                    
typedef struct packed { 
   logic [47:0]     rsvd;
   logic [15:0]     nvme_raw_cksum_crc16t;
} fmd_user_pi16_word1_t;



//FRMD_USER_PI64 TLV Word1                 
typedef struct packed { 
   logic [63:0]     raw_data_cksum;
} fmd_user_pi64_word1_t;



//FRMD_USER_VM TLV Word1                    
typedef struct packed { 
   logic [63:0]     ivtweak;
} fmd_user_vm_word1_t;

//FRMD_USER_VM TLV Word2                    
typedef struct packed { 
   logic [63:0]     ivtweak;
} fmd_user_vm_word2_t;

//FRMD_USER_VM TLV Word3                     
typedef struct packed { 
   logic [63:0]     raw_data_cksum;
} fmd_user_vm_word3_t;


//FRMD_USER_VM TLV Word4                    
typedef struct packed { 
   logic [63:0]     raw_data_mac;
} fmd_user_vm_word4_t;


//FRMD_USER_VM TLV Word5                    
typedef struct packed { 
   logic [63:0]     raw_data_mac;
} fmd_user_vm_word5_t;


//FRMD_USER_VM TLV Word6                    
typedef struct packed { 
   logic [63:0]     raw_data_mac;
} fmd_user_vm_word6_t;


//FRMD_USER_VM TLV Word7                    
typedef struct packed { 
   logic [63:0]     raw_data_mac;
} fmd_user_vm_word7_t;



//FRMD_INT_APP Word7                        
typedef struct packed { 
   logic [31:0]     rsvd;
   logic [5:0]      rsvd0;   
   frmd_coding_e    coding;
   logic [23:0]     compressed_length;
} fmd_int_app_word6_t;


//FRMD_INT_APP Word1                        
typedef struct packed { 
   logic [63:0]     enc_cmp_data_cksum;  
} fmd_int_app_word1_t;


//FRMD_INT_APP Word2                        
typedef struct packed { 
 logic [63:0] enc_cmp_mac;
} fmd_int_app_word2_t;


//FRMD_INT_APP Word3                        
typedef struct packed { 
 logic [63:0] enc_cmp_mac;
} fmd_int_app_word3_t;
 
//FRMD_INT_APP Word4                        
typedef struct packed { 
 logic [63:0] ivtweak;
} fmd_int_app_word4_t;

//FRMD_INT_APP Word5                        
typedef struct packed { 
  logic [31:0] rsvd;
  logic [31:0] ivtweak;
} fmd_int_app_word5_t;

//FRMD_INT_SIP Word3                        
typedef struct packed { 
   logic [31:0]     rsvd;
   logic [5:0]      rsvd0;   
   frmd_coding_e    coding;
   logic [23:0]     compressed_length;
} fmd_int_sip_word3_t;


//FRMD_INT_SIP Word1                        
typedef struct packed { 
   logic [63:0]     enc_cmp_data_cksum;  
} fmd_int_sip_word1_t;



//FRMD_INT_SIP Word2                        
typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_sip_word2_t;


//FRMD_INT_LIP Word6                           
typedef struct packed { 
   logic [31:0]     rsvd;
   logic [5:0]      rsvd0;   
   frmd_coding_e    coding;
   logic [23:0]     compressed_length;
} fmd_int_lip_word6_t;


//FRMD_INT_LIP Word1                            
typedef struct packed { 
   logic [63:0]     enc_cmp_data_cksum;  
} fmd_int_lip_word1_t;



//FRMD_INT_LIP Word2                             
typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_lip_word2_t;



//FRMD_INT_LIP Word3                            
typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_lip_word3_t;


//FRMD_INT_LIP Word4                            
typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_lip_word4_t;


//FRMD_INT_LIP Word5                            
typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_lip_word5_t;


//FRMD_INT_VM Word12                        
typedef struct packed { 
   logic [31:0]     rsvd;
   logic [5:0]      rsvd0;   
   frmd_coding_e    coding;
   logic [23:0]     compressed_length;    
} fmd_int_vm_word12_t;


//FRMD_INT_VM Word1                        
typedef struct packed { 
   logic [63:0]     enc_cmp_data_cksum;  
} fmd_int_vm_word1_t;


//FRMD_INT_VM Word2                         
typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;  
} fmd_int_vm_word2_t;


//FRMD_INT_VM Word3
typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;  
} fmd_int_vm_word3_t;


//FRMD_INT_VM Word4
typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;  
} fmd_int_vm_word4_t;


//FRMD_INT_VM Word5
typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;  
} fmd_int_vm_word5_t;


//FRMD_INT_VM Word6                         
typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_vm_word6_t;


//FRMD_INT_VM Word7
typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_vm_word7_t;


//FRMD_INT_VM Word8
typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_vm_word8_t;

//FRMD_INT_VM Word9
typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_vm_word9_t;


//FRMD_INT_VM Word10                         
typedef struct packed { 
  logic [63:0]      ivtweak;
} fmd_int_vm_word10_t;


//FRMD_INT_VM Word11                          
typedef struct packed { 
  logic [63:0]      ivtweak;           
} fmd_int_vm_word11_t;


//FRMD_INT_VM_SHORT Word9
typedef struct packed { 
   logic [31:0]     rsvd;
   logic [5:0]      rsvd0;   
   frmd_coding_e    coding;
   logic [23:0]     compressed_length;    
} fmd_int_vm_short_word9_t;


//FRMD_INT_VM_SHORT Word1
typedef struct packed { 
   logic [63:0]     enc_cmp_data_cksum;  
} fmd_int_vm_short_word1_t;


//FRMD_INT_VM_SHORT Word2
typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;  
} fmd_int_vm_short_word2_t;

//FRMD_INT_VM_SHORT Word3
typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;  
} fmd_int_vm_short_word3_t;

//FRMD_INT_VM_SHORT Word4
typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;  
} fmd_int_vm_short_word4_t;

//FRMD_INT_VM_SHORT Word5
typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;  
} fmd_int_vm_short_word5_t;

//FRMD_INT_VM_SHORT Word6
typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_vm_short_word6_t;

//FRMD_INT_VM_SHORT Word7
typedef struct packed { 
  logic [63:0]      ivtweak;
} fmd_int_vm_short_word7_t;

//FRMD_INT_VM_SHORT Word8
typedef struct packed { 
  logic [63:0]      ivtweak;
} fmd_int_vm_short_word8_t;


// Symbol mapper to sequence ID array interface data fields
typedef struct packed {
   logic                                 predet_mem_mask;
   logic [3:0]                           predet_mem_id;
   cmd_comp_mode_e                       comp_mode;
   cmd_lz77_win_size_e                   lz77_win_size;
   cmd_lz77_min_match_len_e              lz77_min_match_len;
   cmd_xp10_prefix_mode_e                xp10_prefix_mode;
   logic [5:0]                           xp10_user_prefix_size;
   cmd_xp10_crc_mode_e                   xp10_crc_mode;
   cmd_chu_comp_thrsh_e                  chu_comp_thrsh;
   logic [`AXI_S_TID_WIDTH-1:0]          tid;
   logic [`AXI_S_USER_WIDTH-1:0]         tuser;
   logic [`N_RAW_SIZE_WIDTH-1:0]         raw_byte_count;
   logic [`N_EXTRA_BITS_TOT_WIDTH-1:0]   extra_bit_count;
   logic [10:0]                          blk_count;
   logic                                 blk_last;
   logic                                 pdh_crc_err;
   logic [63:0]                          raw_crc;
} s_sm_seq_id_intf;

typedef struct packed {
   cmd_comp_mode_e                       comp_mode;
   cmd_lz77_win_size_e                   lz77_win_size;
   cmd_xp10_prefix_mode_e                xp10_prefix_mode;
} s_seq_id_type_intf;

// Struct for 50-bit counters to map to 32-bit reads
   typedef struct                     packed {
      logic [17:0]                    count_part1;              // [49:32]
      logic [31:0]                    count_part0;              // [31:0]
   } counter_50_t;


// CG Stat Event Struct
typedef struct  packed {
  logic         cqe_out;
  logic         cqe_sys_err;
  logic         cqe_err_sel;
  logic         cqe_eng_err;
} cg_stats_t;

// OSF Stat Event Struct
typedef struct  packed {
  logic [59:0]  rsvd;
  logic         ob_stall;
  logic         ob_sys_bp;
  logic         pdt_fifo_stall;
  logic         dat_fifo_stall;
} osf_stats_t;

// ISF Stat Event Struct
typedef struct  packed {
  logic [54:0]  rsvd;
  logic         aux_cmd_match3;
  logic         aux_cmd_match2;
  logic         aux_cmd_match1;
  logic         aux_cmd_match0;
  logic         ob_sys_bp;
  logic         ib_sys_stall;
  logic         ib_stall;
  logic         ib_frame;
  logic         ib_cmd;
} isf_stats_t;

typedef struct packed {
   logic [9:0] huff_comp_rsvd;
   logic       lz77_stall_stb;
   logic       encrypt_stall_stb;
   logic       byte_7_stb;
   logic       byte_6_stb;
   logic       byte_5_stb;
   logic       byte_4_stb;
   logic       byte_3_stb;
   logic       byte_2_stb;
   logic       byte_1_stb;
   logic       byte_0_stb;
   logic       pass_thru_frm_stb;
   logic       df_frm_stb;
   logic       df_blk_long_ret_stb;
   logic       df_blk_shrt_ret_stb;
   logic       df_blk_long_sim_stb;
   logic       df_blk_shrt_sim_stb;
   logic       df_blk_raw_stb;
   logic       df_blk_enc_stb;
   logic       chu4_cmd_stb;    
   logic       chu4_frm_long_pre_stb;   
   logic       chu4_frm_shrt_pre_stb;
   logic       chu4_frm_long_ret_stb;
   logic       chu4_frm_shrt_ret_stb;
   logic       chu4_frm_long_sim_stb;
   logic       chu4_frm_shrt_sim_stb;
   logic       chu4_frm_enc_stb;
   logic       chu4_frm_raw_stb;
   logic       chu8_cmd_stb;
   logic       chu8_frm_long_pre_stb;   
   logic       chu8_frm_shrt_pre_stb;
   logic       chu8_frm_long_ret_stb;
   logic       chu8_frm_shrt_ret_stb;
   logic       chu8_frm_long_sim_stb;
   logic       chu8_frm_shrt_sim_stb;
   logic       chu8_frm_enc_stb;
   logic       chu8_frm_raw_stb;
   logic       xp10_frm_stb;
   logic       xp10_blk_long_pre_stb;
   logic       xp10_blk_shrt_pre_stb;
   logic       xp10_blk_long_ret_stb;
   logic       xp10_blk_shrt_ret_stb;
   logic       xp10_blk_long_sim_stb;
   logic       xp10_blk_shrt_sim_stb;
   logic       xp10_blk_raw_stb;
   logic       xp10_blk_enc_stb;
   logic       xp9_blk_long_ret_stb;
   logic       xp9_blk_shrt_ret_stb;
   logic       xp9_blk_long_sim_stb;
   logic       xp9_blk_shrt_sim_stb;
   logic       xp9_frm_stb;
   logic       xp9_frm_raw_stb;
   logic       xp9_blk_enc_stb;
   logic       long_map_err_stb;
   logic       shrt_map_err_stb;
} huf_comp_stats_t;

typedef struct packed {
    logic [48:0] unused;
    logic  [0:0] cipher_aes_gcm; 
    logic  [0:0] cipher_aes_xts; 
    logic  [0:0] cipher_aes_xex; 
    logic  [0:0] cipher_nop; 
    logic  [0:0] auth_aes_gmac; 
    logic  [0:0] auth_sha256; 
    logic  [0:0] auth_sha256_hmac; 
    logic  [0:0] auth_nop; 
    logic  [0:0] gcm_tag_fail; 
    logic  [0:0] gmac_tag_fail; 
    logic  [0:0] sha256_tag_fail; 
    logic  [0:0] hmac_sha256_tag_fail;
    logic  [0:0] seq_id_mismatch; 
    logic  [0:0] eng_id_mismatch;
    logic  [0:0] reserved;
} crypto_stats_t;

typedef struct packed {
    aux_key_op_e    dak_key_op;
    logic [13:0]    dak_key_ref;
    aux_kdf_mode_e  kdf_mode;
    aux_key_op_e    dek_key_op;
    logic [13:0]    dek_key_ref;
} aux_key_ctrl_t;


//Structs for Scheduler Update AXI4S Bus
typedef struct packed {
  logic            tvalid;
  logic            tlast;
  logic [1:0]      tuser;
  logic [7:0]      tdata;
} axi4s_su_dp_bus_t;


//Structs for interrupts

typedef struct packed {
  logic        tlvp_err;
  logic        uncor_ecc_err;
  logic        bimc_int;
} generic_int_t;

typedef struct packed {
  logic        uncor_ecc_err;
} ecc_int_t;

typedef struct packed {
  logic        tlvp_err;
} tlvp_int_t;

typedef struct packed {
  logic        bimc_err;
} bimc_int_t;

typedef struct packed {
  logic        seed_expire;
  logic        id_mismatch;
  logic        tlvp_err;
  logic        uncor_ecc_err;
} crypto_int_t;

typedef struct packed {
  logic        id_mismatch;
  logic        tlvp_err;
} crypto_ckmic_int_t;

typedef struct packed {
  logic        tlvp_err;
  logic        uncor_ecc_err;
} osf_int_t;

typedef struct packed {
  logic        sys_stall;        
  logic        ovfl;
  logic        prot_err;
  logic        tlvp_int;
  logic        uncor_ecc_err;
} isf_int_t;

typedef struct packed {
  logic        tlvp_err;
  logic        uncor_ecc_err;
} prefix_attach_int_t;


// Footer Error Struct
typedef struct packed { 
   zipline_error_e   error_code;
   logic [10:0]     errored_frame_number;
} ftr_error_t;

