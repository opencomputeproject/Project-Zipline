/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_global_params.vh"
`include "cr_native_types.svh"

`include "cr_error_codes.svh"




typedef struct packed {
  logic                          tvalid;
  logic                          tlast;
  logic [`AXI_S_TID_WIDTH-1:0]   tid;
  logic [`AXI_S_TSTRB_WIDTH-1:0] tstrb;
  logic [`AXI_S_USER_WIDTH-1:0]  tuser;
  logic [`AXI_S_DP_DWIDTH-1:0]   tdata;
} axi4s_dp_bus_t;


typedef struct packed {
  logic        tready;
} axi4s_dp_rdy_t;


typedef struct packed {
  logic [`N_RBUS_ADDR_BITS-1:0] addr;
  logic                         wr_strb;
  logic [`N_RBUS_DATA_BITS-1:0] wr_data;
  logic                         rd_strb;
} rbus_in_t;


typedef struct packed {
  logic [`N_RBUS_DATA_BITS-1:0] rd_data;
  logic                         ack;
  logic                         err_ack;
} rbus_out_t;


typedef struct packed {
  logic [`N_RBUS_ADDR_BITS-1:0] addr;  
  logic                         wr_strb;
  logic [`N_RBUS_DATA_BITS-1:0] wr_data;
  logic                         rd_strb;
  logic [`N_RBUS_DATA_BITS-1:0] rd_data;
  logic                         ack;    
  logic                         err_ack;
} rbus_ring_t;


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



typedef struct packed {
  logic                           valid;
  logic [`TLV_SEQ_NUM_WIDTH-1:0]  seq_num;
} frame_latency_if_bus_t;



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
 


typedef struct  packed {
   logic [ 3:0]       pf_number;
   logic [11:0]       vf_number;
   logic [15:0]       scheduler_handle;
   logic [31:0]       src_data_len;
} tlv_rqe_word_1_t;


typedef struct packed { 
   tlvp_corrupt_e     tlvp_corrupt;
   cmd_mode_e         cmd_mode;
   logic [4:0]        module_id;  
   cmd_type_e         cmd_type;
   logic [4:0]        tlv_num;
   logic [9:0]        byte_num;
   logic [7:0]        byte_msk;
} cmd_debug_t;


typedef struct packed {
   logic [0:0]        rsvd;
   logic [10:0]       on_count;
   logic [10:0]       off_count;
} bp_debug_t;



typedef struct  packed {
   cmd_debug_t                  debug;             
   logic                        trace;             
   logic                        dst_guid_present;  
   logic [6:0]                  frmd_out_type;     
   cmd_md_op_e                  md_op;             
   cmd_md_type_e                md_type;           
   logic [6:0]                  frmd_in_type;      
   logic [5:0]                  frmd_in_aux;       
   cmd_frmd_crc_in_e            frmd_crc_in;       
   cmd_guid_present_e           src_guid_present;  
   cmd_compound_cmd_frm_size_e  compound_cmd_frm_size; 
} tlv_cmd_word_1_t;


typedef struct  packed {   
   logic                       rsvd2;                  
   logic [5:0]                 rsvd3;                 
   logic [1:0]                 rsvd1;                 
   logic                       cipher_pad;             
   logic [1:0]                 rsvd9;                 
   logic [7:0]                 rsvd8;                 
   logic [3:0]                 rsvd6;                 
   logic [3:0]                 rsvd4;                 
   logic [3:0]                 rsvd5;                 
   logic [7:0]                 rsvd0;                 
   cmd_chu_comp_thrsh_e        chu_comp_thrsh;        
   cmd_xp10_crc_mode_e         xp10_crc_mode;         
   logic [5:0]                 xp10_user_prefix_size; 
   cmd_xp10_prefix_mode_e      xp10_prefix_mode;      
   cmd_lz77_max_symb_len_e     lz77_max_symb_len;     
   cmd_lz77_min_match_len_e    lz77_min_match_len;    
   cmd_lz77_dly_match_win_e    lz77_dly_match_win;    
   cmd_lz77_win_size_e         lz77_win_size;         
   cmd_comp_mode_e             comp_mode;             
} tlv_cmd_word_2_t;




typedef struct packed { 
   logic [63:6] rsvd;
   logic [5:0] xp10_prefix_sel;
} tlv_phd_word1_t;



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


typedef struct packed { 
   logic [63:6] rsvd;
   logic [5:0] xp10_prefix_sel;
} tlv_pfd_word1_t;



typedef struct packed { 
   logic [63:0] guid;
} tlv_guid_word1_t;



typedef struct packed { 
   logic [63:0] guid;
} tlv_guid_word2_t;




typedef struct packed { 
   logic [63:0] guid;
} tlv_guid_word3_t;



typedef struct packed { 
   logic [63:0] guid;
} tlv_guid_word4_t;



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
 


typedef struct packed { 
   logic [63:0]     raw_data_mac;
} tlv_ftr_word1_t;


typedef struct packed { 
   logic [63:0]     raw_data_mac;
} tlv_ftr_word2_t;


typedef struct packed { 
   logic [63:0]     raw_data_mac;
} tlv_ftr_word3_t;


typedef struct packed { 
   logic [63:0]     raw_data_mac;
} tlv_ftr_word4_t;



typedef struct packed { 
   logic [63:0]     raw_data_cksum;
} tlv_ftr_word5_t;



typedef struct packed { 
  logic [63:0]      raw_data_cksum_protocol;
} tlv_ftr_word6_t;


typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;
} tlv_ftr_word7_t;


typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;
} tlv_ftr_word8_t;


typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;
} tlv_ftr_word9_t;


typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;
} tlv_ftr_word10_t;


typedef struct packed { 
   logic [63:0]     enc_cmp_data_cksum;
} tlv_ftr_word11_t;


typedef struct packed { 
   logic [15:0]     nvme_raw_cksum_crc16t;
   logic [23:0]     bytes_in;
   logic [23:0]     bytes_out;  
} tlv_ftr_word12_t;



typedef struct packed { 
   logic [19:0]     rsvd1;  
   logic [23:0]     compressed_length;  
   huff_error_e   error_code;
   logic            rsvd0;  
   logic [10:0]     errored_frame_number;
} tlv_ftr_word13_t;






typedef struct packed { 
   logic [63:0] guid;
} tlv_ftr_guid_word0_t;


typedef struct packed { 
   logic [63:0] guid;
} tlv_ftr_guid_word1_t;


typedef struct packed { 
   logic [63:0] guid;
} tlv_ftr_guid_word2_t;


typedef struct packed { 
   logic [63:0] guid;
} tlv_ftr_guid_word3_t;


typedef struct packed {  
   logic [31:0] rsvd;
   logic [31:0] iv;
} tlv_ftr_iv_word0_t;


typedef struct packed { 
   logic [63:0] iv;
} tlv_ftr_iv_word1_t;



typedef struct packed { 
   logic [ 7:0]                       rsvd1;
   logic [23:0]                       bytes_in;
   logic [ 7:0]                       rsvd0;
   logic [23:0]                       bytes_out;  
} tlv_stats_word1_t;


typedef struct packed { 
   logic [30:0]                       rsvd1;
   logic                              frame_error;
   logic [ 7:0]                       rsvd0;
   logic [23:0]                       latency;  
} tlv_stats_word2_t;




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





typedef struct packed { 
   logic [47:0]     rsvd;
   logic [15:0]     nvme_raw_cksum_crc16t;
} fmd_user_pi16_word1_t;




typedef struct packed { 
   logic [63:0]     raw_data_cksum;
} fmd_user_pi64_word1_t;




typedef struct packed { 
   logic [63:0]     ivtweak;
} fmd_user_vm_word1_t;


typedef struct packed { 
   logic [63:0]     ivtweak;
} fmd_user_vm_word2_t;


typedef struct packed { 
   logic [63:0]     raw_data_cksum;
} fmd_user_vm_word3_t;



typedef struct packed { 
   logic [63:0]     raw_data_mac;
} fmd_user_vm_word4_t;



typedef struct packed { 
   logic [63:0]     raw_data_mac;
} fmd_user_vm_word5_t;



typedef struct packed { 
   logic [63:0]     raw_data_mac;
} fmd_user_vm_word6_t;



typedef struct packed { 
   logic [63:0]     raw_data_mac;
} fmd_user_vm_word7_t;




typedef struct packed { 
   logic [31:0]     rsvd;
   logic [5:0]      rsvd0;   
   frmd_coding_e    coding;
   logic [23:0]     compressed_length;
} fmd_int_app_word6_t;



typedef struct packed { 
   logic [63:0]     enc_cmp_data_cksum;  
} fmd_int_app_word1_t;



typedef struct packed { 
 logic [63:0] enc_cmp_mac;
} fmd_int_app_word2_t;



typedef struct packed { 
 logic [63:0] enc_cmp_mac;
} fmd_int_app_word3_t;
 

typedef struct packed { 
 logic [63:0] ivtweak;
} fmd_int_app_word4_t;


typedef struct packed { 
  logic [31:0] rsvd;
  logic [31:0] ivtweak;
} fmd_int_app_word5_t;


typedef struct packed { 
   logic [31:0]     rsvd;
   logic [5:0]      rsvd0;   
   frmd_coding_e    coding;
   logic [23:0]     compressed_length;
} fmd_int_sip_word3_t;



typedef struct packed { 
   logic [63:0]     enc_cmp_data_cksum;  
} fmd_int_sip_word1_t;




typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_sip_word2_t;



typedef struct packed { 
   logic [31:0]     rsvd;
   logic [5:0]      rsvd0;   
   frmd_coding_e    coding;
   logic [23:0]     compressed_length;
} fmd_int_lip_word6_t;



typedef struct packed { 
   logic [63:0]     enc_cmp_data_cksum;  
} fmd_int_lip_word1_t;




typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_lip_word2_t;




typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_lip_word3_t;



typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_lip_word4_t;



typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_lip_word5_t;



typedef struct packed { 
   logic [31:0]     rsvd;
   logic [5:0]      rsvd0;   
   frmd_coding_e    coding;
   logic [23:0]     compressed_length;    
} fmd_int_vm_word12_t;



typedef struct packed { 
   logic [63:0]     enc_cmp_data_cksum;  
} fmd_int_vm_word1_t;



typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;  
} fmd_int_vm_word2_t;



typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;  
} fmd_int_vm_word3_t;



typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;  
} fmd_int_vm_word4_t;



typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;  
} fmd_int_vm_word5_t;



typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_vm_word6_t;



typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_vm_word7_t;



typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_vm_word8_t;


typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_vm_word9_t;



typedef struct packed { 
  logic [63:0]      ivtweak;
} fmd_int_vm_word10_t;



typedef struct packed { 
  logic [63:0]      ivtweak;           
} fmd_int_vm_word11_t;



typedef struct packed { 
   logic [31:0]     rsvd;
   logic [5:0]      rsvd0;   
   frmd_coding_e    coding;
   logic [23:0]     compressed_length;    
} fmd_int_vm_short_word9_t;



typedef struct packed { 
   logic [63:0]     enc_cmp_data_cksum;  
} fmd_int_vm_short_word1_t;



typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;  
} fmd_int_vm_short_word2_t;


typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;  
} fmd_int_vm_short_word3_t;


typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;  
} fmd_int_vm_short_word4_t;


typedef struct packed { 
   logic [63:0]     enc_cmp_data_mac;  
} fmd_int_vm_short_word5_t;


typedef struct packed { 
   logic [63:0]     raw_data_mac;  
} fmd_int_vm_short_word6_t;


typedef struct packed { 
  logic [63:0]      ivtweak;
} fmd_int_vm_short_word7_t;


typedef struct packed { 
  logic [63:0]      ivtweak;
} fmd_int_vm_short_word8_t;



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


   typedef struct                     packed {
      logic [17:0]                    count_part1;              
      logic [31:0]                    count_part0;              
   } counter_50_t;



typedef struct  packed {
  logic         cqe_out;
  logic         cqe_sys_err;
  logic         cqe_err_sel;
  logic         cqe_eng_err;
} cg_stats_t;


typedef struct  packed {
  logic [59:0]  rsvd;
  logic         ob_stall;
  logic         ob_sys_bp;
  logic         pdt_fifo_stall;
  logic         dat_fifo_stall;
} osf_stats_t;


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
  logic            tvalid;
  logic            tlast;
  logic [1:0]      tuser;
  logic [7:0]      tdata;
} axi4s_su_dp_bus_t;




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



typedef struct packed { 
   huff_error_e   error_code;
   logic [10:0]     errored_frame_number;
} ftr_error_t;

