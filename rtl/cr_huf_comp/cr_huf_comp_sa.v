/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_huf_comp.vh"
`include "cr_xp10_decomp.vh"

module cr_huf_comp_sa
  (
   
   huf_comp_ob_out, sa_sm_intf, sa_st1_short_read_done,
   sa_st1_long_read_done, sa_st2_short_read_done,
   sa_st2_long_read_done, sa_lut_long_intf, sa_lut_short_intf,
   sa_sq_intf, huf_comp_sch_update, huf_comp_stats,
   fhp_lz_prefix_hdr_valid, fhp_lz_prefix_valid,
   fhp_lz_prefix_hdr_bus, fhp_lz_prefix_dp_bus, sdd_mtf_dp_bus,
   sdd_mtf_dp_valid, be_lz_dp_ready, bhp_mtf_hdr_bus,
   bhp_mtf_hdr_valid, ecc_error_reg, sa_bip2_reg,
   
   clk, rst_n, huf_comp_ob_in, huf_comp_module_id, seq_id_intf_array,
   seq_id_intf_array_vld, st1_sa_long_intf, st1_sa_long_size_rdy,
   st1_sa_long_table_rdy, st1_sa_short_intf, st1_sa_short_size_rdy,
   st1_sa_short_table_rdy, st2_sa_long_intf, st2_sa_long_size_rdy,
   st2_sa_long_table_rdy, st2_sa_short_intf, st2_sa_short_size_rdy,
   st2_sa_short_table_rdy, lut_sa_long_data_val, lut_sa_long_intf,
   lut_sa_long_st_stcl_val, lut_sa_short_data_val, lut_sa_short_intf,
   lut_sa_short_st_stcl_val, sq_sa_intf, sw_xp9_disable_modes,
   sw_xp10_disable_modes, sw_deflate_disable_modes,
   sw_sa_out_tlv_parse_action_0, sw_sa_out_tlv_parse_action_1,
   sw_prefix_adj, sw_gzip_os, su_ready, lz_fhp_prefix_hdr_ready,
   lz_fhp_pre_prefix_ready, lz_fhp_usr_prefix_ready, mtf_sdd_dp_ready,
   lz_be_dp_bus, lz_be_dp_valid, ecc_error
   );
   
`include "cr_structs.sv"
   
   import cr_huf_compPKG::*;
   import cr_huf_comp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   
   
   input                                clk;
   input 			        rst_n;

   
   
   
   input  axi4s_dp_rdy_t                huf_comp_ob_in;
   output axi4s_dp_bus_t                huf_comp_ob_out;
   
   input [`MODULE_ID_WIDTH-1:0] huf_comp_module_id;
   
   
   
   output  s_sa_sm_intf                 sa_sm_intf;
   
   
   
   
   input s_sm_seq_id_intf               seq_id_intf_array[`CREOLE_HC_SEQID_NUM];
   input [`CREOLE_HC_SEQID_NUM-1:0]     seq_id_intf_array_vld;
   
   
   
   
   input s_st_sa_intf	                st1_sa_long_intf;	
   input		                st1_sa_long_size_rdy;	
   input		                st1_sa_long_table_rdy;	
   input s_st_sa_intf	                st1_sa_short_intf;	
   input		                st1_sa_short_size_rdy;	
   input		                st1_sa_short_table_rdy;
	 	
   input s_st_sa_intf	                st2_sa_long_intf;	
   input		                st2_sa_long_size_rdy;	
   input		                st2_sa_long_table_rdy;	
   input s_st_sa_intf	                st2_sa_short_intf;	
   input		                st2_sa_short_size_rdy;	
   input		                st2_sa_short_table_rdy;
	 	
   output logic		                sa_st1_short_read_done;		
   output logic		                sa_st1_long_read_done;
   
   output logic		                sa_st2_short_read_done;		
   output logic		                sa_st2_long_read_done;
   
   
   
   
   input                                lut_sa_long_data_val;	
   input s_lut_sa_intf	                lut_sa_long_intf;       
   input		                lut_sa_long_st_stcl_val;	
   input		                lut_sa_short_data_val;	
   input s_lut_sa_intf	                lut_sa_short_intf;	
   input		                lut_sa_short_st_stcl_val;
   output s_sa_lut_intf	                sa_lut_long_intf;	
   output s_sa_lut_intf	                sa_lut_short_intf;

   
   
   
   input  s_sq_sa_intf                  sq_sa_intf;
   output s_sa_sq_intf                  sa_sq_intf;   
   
   
   
   input  henc_xp9_disable_modes_t      sw_xp9_disable_modes;
   input  henc_xp10_disable_modes_t     sw_xp10_disable_modes;
   input  henc_deflate_disable_modes_t  sw_deflate_disable_modes;
   input [`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_31_0_T_DECL]       sw_sa_out_tlv_parse_action_0;
   input [`CR_HUF_COMP_C_SA_OUT_TLV_PARSE_ACTION_63_32_T_DECL]      sw_sa_out_tlv_parse_action_1;
   input [`CR_HUF_COMP_C_HENC_SCH_UPDATE_PREFIX_ADJ_T_DECL] 	    sw_prefix_adj;
   input [`CR_HUF_COMP_C_HENC_GZIP_OS_T_DECL] 			    sw_gzip_os;
   
   
   
   input 			                su_ready;
   output        sched_update_if_bus_t          huf_comp_sch_update;
   output 	 huf_comp_stats_t               huf_comp_stats;
   
   
   
   
   output logic                                 fhp_lz_prefix_hdr_valid;
   output logic 				fhp_lz_prefix_valid;
   output fhp_lz_prefix_hdr_bus_t               fhp_lz_prefix_hdr_bus;
   output fhp_lz_prefix_dp_bus_t                fhp_lz_prefix_dp_bus;
   input                                        lz_fhp_prefix_hdr_ready;
   input 					lz_fhp_pre_prefix_ready;
   input 					lz_fhp_usr_prefix_ready;
   
   output lz_symbol_bus_t                       sdd_mtf_dp_bus; 
   output logic                                 sdd_mtf_dp_valid; 
   input 					mtf_sdd_dp_ready;
   
   output logic 				be_lz_dp_ready; 
   input  lz_be_dp_bus_t                        lz_be_dp_bus;  
   input                                        lz_be_dp_valid; 

   output bhp_mtf_hdr_bus_t                     bhp_mtf_hdr_bus;
   output logic                                 bhp_mtf_hdr_valid;

   input 					ecc_error;

   
   output 					ecc_error_reg;
   output logic 				sa_bip2_reg;

   
   
   
   
   localparam N_HOLD_DEPTH     = 8;
   localparam N_HOLD_ENC_DEPTH = 8;

   
   
   localparam PACK_IN_W         = (2*`N_EXTRA_BITS_WIDTH)+(5*`N_MAX_ENCODE_WIDTH);
   localparam PACK_OUT_W        = `AXI_S_DP_DWIDTH;
   localparam PACK_ACC_W        = 145+`AXI_S_DP_DWIDTH+6;
   localparam PACK_IN_SZ_W      = $clog2(PACK_IN_W);
   localparam PACK_OUT_SZ_W     = $clog2(PACK_OUT_W);
   localparam PACK_ACC_SZ_W     = $clog2(PACK_ACC_W);   
   localparam PACK_OUT_ARR_SZ   = (PACK_IN_W+PACK_ACC_W)/PACK_OUT_W;
   localparam PACK_OUT_CNT_SZ_W = $clog2(PACK_OUT_ARR_SZ);   
   
   typedef struct 	packed {
      logic 		dis_used;   
      logic 		dis_return; 
      logic [`LOG_VEC(N_HOLD_DEPTH+1)] credit_limit;
   } sw_config_t;
   
   typedef struct 	packed {
      logic 		dis_used;   
      logic 		dis_return; 
      logic [`LOG_VEC(N_HOLD_ENC_DEPTH+1)] credit_limit;
   } sw_config_enc_t;
   
   typedef struct 			   packed {  
      cmd_comp_mode_e     comp_mode;
      cmd_xp10_crc_mode_e xp10_crc;
   } cmd_comp_mode_t; 
   
   
   
   logic		crc_error;		
   logic		data_out_pend;		
   s_symbol_map_intf	df_symbol_map_intf;	
   logic		enc_fifo_empty;		
   logic		lut_long_rd_data_fifo_empty;
   logic		lut_shrt_rd_data_fifo_empty;
   logic		raw_fifo_empty;		
   logic		symbol_holding_fifo_wr_rdy;
   logic		symbol_holding_rd_data_fifo_empty;
   logic		term_aempty;		
   logic		term_empty;		
   logic		tlvp_in_rd;		
   logic		usr_afull;		
   logic		usr_full;		
   
   
   bhp_mtf_hdr_bus_t                     bhp_mtf_hdr_bus_nxt;
   tlvp_if_bus_t	                 term_tlv;    
   e_sa_state           	         state;
   e_sa_state           	         state_reg;
   s_sm_seq_id_intf                      seq_id_intf; 
   lz_symbol_bus_t                       lz_symbol_bus;
   s_lut_long_rd_data_intf 		 lut_sa_long_data;	
   s_lut_shrt_rd_data_intf 		 lut_sa_shrt_data;
   s_symbol_map_intf                     xp_symbol_map_intf, mux_symbol_map_intf;
   tlvp_if_bus_t                         usr_tlv_nxt;
   axi4s_dp_bus_t       	         tlvp_in_data;	
   e_min_enc		                 shrt_sel_comb, long_sel_comb; 
   e_min_enc		                 shrt_sel, long_sel; 
   tlv_word_0_t                          tlv_word_0;       
   tlv_word_0_t                          prefix_wrd_hdr;   
   sw_config_t                           sw_config;
   sw_config_enc_t                       sw_config_enc;
   s_symbol_holding_fifo_intf            symbol_holding_fifo_wr_data_nxt, symbol_holding_fifo_wr_data, symbol_holding_fifo_rd_data;
   s_lut_sa_intf	                 lut_sa_long_intf_reg, lut_sa_short_intf_reg; 
   cmd_comp_mode_t                       comp_mode_lst;
   tlv_ftr_word0_t                       tlv_ftr_word0;
   tlv_ftr_word13_t                      tlv_ftr_word13;
   tlv_data_word_0_t                     tlv_data_word_0;
   tlv_rqe_word_1_t                      tlv_rqe_word_1;   
   tlv_pfd_word0_t                       tlv_pfd_word0;    
   tlv_cmd_word_1_t                      tlv_cmd_word_1;   
   tlv_cmd_word_2_t                      tlv_cmd_word_2;   
   
   
   
   
   
   logic [31:0] 	                               df_frm_raw_byte_count;
   logic [31:0] 	                               df_frm_raw_byte_count_nxt;
   logic 					       cipher_pad, cipher_last;
   logic                                               data_out_eot_enc_reg;
   logic 					       ecc_error_reg, sym_map_error;
   logic 					       wr_more;
   logic 					       eob_raw_done;
   logic 					       eot_raw_done;
   logic 					       eot_enc_done;
   logic [5:0] 					       xp10_user_prefix_size;
   logic [5:0] 					       xp10_user_prefix_size_mask;
   logic 					       prev_mtf_or_ptr;
   logic 					       lut_sa_long_data_val_reg, lut_sa_long_st_stcl_val_reg;	
   logic 					       lut_sa_short_data_val_reg, lut_sa_short_st_stcl_val_reg;   
   logic [`CREOLE_HC_MAX_ENCODE_TOT_WIDTH-1:0] 	       data_out_enc;
   logic [$clog2(`CREOLE_HC_MAX_ENCODE_TOT_WIDTH)-1:0] data_out_size_enc;
   logic 					       data_out_eot_enc;
   logic 					       data_out_eob_enc;   
   logic [63:0] 	                               data_out_raw, data_out_raw_nxt; 
   logic [$clog2(`CREOLE_HC_MAX_ENCODE_TOT_WIDTH)-1:0] data_out_size_raw;
   logic [7:0] 					       data_out_size_raw_pre; 
   logic [7:0] 					       data_out_size_raw_nxt; 
   logic [1:0] 					       data_out_signal_raw;
   logic [1:0] 					       data_out_signal_raw_nxt;
   logic 					       data_out_eot_raw_reg, data_out_eot_raw, data_out_eot_raw_nxt;
   logic 					       data_out_eob_raw, data_out_eob_raw_nxt;   
   logic [`CREOLE_HC_MAX_ENCODE_TOT_WIDTH-1:0] 	       data_out;
   logic [$clog2(`CREOLE_HC_MAX_ENCODE_TOT_WIDTH)-1:0] data_out_size;
   logic 					       data_out_vld;
   logic 					       data_out_eot;
   logic 					       data_out_eob;
   logic 					       trace;
   logic 					       send_raw_eob, send_raw_eob_reg;
   logic 				 stat_update;
   logic 				 prefix_present;
   logic 				 reconstruct_en_reg;
   logic 				 reconstruct_en;   
   logic 				 reconstruct_chu_flush_reg;
   logic 				 reconstruct_chu_flush;   
   logic [16:0] 			 pfx_phd_word0_len;
   logic [6:0] 				 crc_bits_vld;
   logic 				 lut_shrt_rd_data_fifo_aempty, lut_long_rd_data_fifo_aempty, enc_fifo_aempty, raw_fifo_aempty_2, raw_fifo_aempty;
   logic [`CREOLE_HC_HDR_WIDTH*4-1:0]    lut_sa_shrt_rd_data;
   logic 				 lut_sa_shrt_rd_data_wr;
   logic [`CREOLE_HC_HDR_WIDTH-1:0] 	 lut_sa_long_rd_data;
   logic 				 lut_sa_long_rd_data_wr;
   logic [`CREOLE_HC_SEQID_WIDTH-1:0] 	 seq_id;
   logic 				 usr_rdy;            
   logic 				 xfer_rdy;             
   logic 				 tlvp_in_aempty;
   logic 				 tlvp_in_empty;
   logic 				 term_rdy;
   logic 				 lut_long_rd_rdy, lut_shrt_rd_rdy;
   logic 				 term_rd;
   logic 				 usr_wr;
   logic 				 tlvp_out_rd;
   logic [`CREOLE_HC_BITS_WIDTH-1:0] 	 shrt_size_ret;
   logic [`CREOLE_HC_BITS_WIDTH-1:0] 	 shrt_size_sim;
   logic [`CREOLE_HC_BITS_WIDTH-1:0] 	 shrt_size_pre;
   logic [`CREOLE_HC_BITS_WIDTH-1:0] 	 shrt_size_min; 
   logic [`CREOLE_HC_BITS_WIDTH-1:0] 	 shrt_size_min_comb;
   logic [`CREOLE_HC_BITS_WIDTH-1:0] 	 long_size_ret;
   logic [`CREOLE_HC_BITS_WIDTH-1:0] 	 long_size_sim;   
   logic [`CREOLE_HC_BITS_WIDTH-1:0] 	 long_size_pre;
   logic [`CREOLE_HC_BITS_WIDTH-1:0] 	 long_size_min;
   logic [`CREOLE_HC_BITS_WIDTH-1:0] 	 long_size_min_comb;
   logic [32:0] 			 out_size_cmp_adj; 
   logic [31:0] 			 out_size_cmp_reg, out_size_cmp, out_size_raw;
   logic [31:0] 			 out_size_cmp_df_ret;
   logic [31:0] 			 out_size_cmp_df_sim;
   logic 				 prefix_crc_error, prehfd_crc_error;
   logic [16:0] 			 pfx_cnt; 
   logic [31:0] 			 xp10_crc_32;
   logic [63:0] 			 ftr_crc_sel;
   logic [6:0]                           ftr_crc_size;
   logic [31:0] 			 out_size_bytes_pre; 
   logic [23:0] 			 out_size_bytes;
   logic [23:0] 			 out_size_bytes_reg; 
   logic [27:0] 			 out_size_bits;
   logic [27:0] 			 out_size_bits_chu;  
   logic [27:0] 			 out_size_bits_reg;
   logic [27:0] 			 out_size_bits_reg_0;
   logic 		 		 out_raw_sel;			 
   logic 		 		 out_raw_sel_reg;
   logic [`N_WINDOW_WIDTH-1:0] 		 mtf_offset [4];
   logic [`N_WINDOW_WIDTH-1:0] 		 mtf_offset_nxt [4]; 
   logic [5:0] 				 mtf_siz [4];
   logic [144:0] 			 mtf_ofs [4];
   logic [4:0] 				 mtf_exp [4];
   logic [30:0] 			 mtf_lsb [4];
   logic 				 mtf_lsb_en [4];
   logic [144:0] 			 mtf_hdr_calc;
   logic [144:0] 			 mtf_hdr;
   logic [144:0] 			 mtf_hdr_reg;
   logic [7:0] 				 mtf_hdr_size;
   logic [7:0] 				 mtf_hdr_size_reg;
   logic [7:0] 				 mtf_hdr_size_reg_0;
   logic [14:0] 			 symbol_tbl_size;
   logic [12:0] 			 symbol_tbl_size_reg;
   logic 				 is_mtf_hdr_last_ptr;
   logic 				 is_mtf_hdr_last_ptr_nxt;
   logic [7:0] 				 wr_hdr_word_cnt;
   logic [7:0] 				 rd_hdr_word_cnt;
   logic [7:0] 				 hdr_word_cnt_max;
   logic 				 symbol_holding_rd_data_fifo_aempty;
   logic [`LOG_VEC(N_HOLD_DEPTH+1)] 	 symbol_holding_rd_data_fifo_used_slots;
   logic [`LOG_VEC(N_HOLD_DEPTH+1)] 	 lut_long_rd_data_fifo_used_slots;
   logic [`LOG_VEC(N_HOLD_DEPTH+1)] 	 lut_shrt_rd_data_fifo_used_slots;
   logic [`LOG_VEC(N_HOLD_ENC_DEPTH+1)]  enc_fifo_used_slots;
   logic [`LOG_VEC(N_HOLD_ENC_DEPTH+1)]  raw_fifo_used_slots;
   logic 				 enc_fifo_rd_rdy, enc_fifo_wr_rdy;
   logic 				 enc_fifo_rd;
   logic 				 raw_fifo_rd_rdy;
   logic 				 raw_fifo_rd_rdy_wait;
   logic 				 raw_fifo_rd;
   logic 				 lut_sa_long_rd_data_rd;
   logic 				 lut_sa_shrt_rd_data_rd;
   logic [7:0] 				 long_stcl_words;
   logic [5:0] 				 long_stcl_remain_size;
   logic 				 long_stcl_remain;
   logic [7:0] 				 shrt_stcl_words;
   logic [5:0] 				 shrt_stcl_remain_size;
   logic 				 shrt_stcl_remain;
   logic [7:0] 				 long_st_words;
   logic [5:0] 				 long_st_remain_size;
   logic 				 long_st_remain;
   logic [7:0] 				 shrt_st_words;
   logic [5:0] 				 shrt_st_remain_size;
   logic 				 shrt_st_remain;
   logic [5:0] 				 long_stcl_remain_size_reg;
   logic 				 long_stcl_remain_reg;
   logic [5:0] 				 shrt_stcl_remain_size_reg;
   logic [5:0] 				 long_stcl_remain_size_reg_mux;
   logic [5:0] 				 shrt_stcl_remain_size_reg_mux;
   logic 				 shrt_stcl_remain_reg;
   logic [5:0] 				 long_st_remain_size_reg;
   logic 				 long_st_remain_reg;
   logic [5:0] 				 shrt_st_remain_size_reg;
   logic 				 shrt_st_remain_reg;
   logic [7:0] 				 long_stcl_words_reg;
   logic [7:0] 				 long_st_words_reg;
   logic [7:0] 				 shrt_stcl_words_reg;
   logic [7:0] 				 shrt_st_words_reg;
   logic [23:0] 			 raw_byte_count_nxt;
   logic [23:0] 			 raw_byte_count;
   logic [23:0] 			 sch_byte_count;
   logic [23:0] 			 sch_byte_count_final;
   logic [23:0] 			 frm_byte_count;
   logic [23:0] 			 frm_byte_count_nxt;
   logic [23:0] 			 frm_byte_count_cipher_nxt;
   logic [23:0] 			 frm_byte_count_final;
   logic [27:0] 			 frm_bit_count;
   logic [27:0] 			 frm_bit_count_nxt;
   logic [27:0] 			 frm_bit_count_raw_adder;
   logic [27:0] 			 frm_bit_count_raw_adder_pre;
   logic [7:0] 				 long_stcl_words_mux, shrt_stcl_words_mux;
   logic [`N_MAX_MTF_WIDTH-1:0] 	 mtf_num;
   logic [`N_WINDOW_WIDTH-1:0] 		 ofs;
   logic 				 compress_sel_last; 
   logic 				 hold_symb_fifo_wr;
   logic 				 hold_symb_fifo_rd;
   logic 				 eob;
   logic [`N_SHRT_SYM_WIDTH-1:0] 	 shrt_data_addr0, shrt_data_addr1, shrt_data_addr2, shrt_data_addr3;
   logic 				 symbol_holding_rd_data_fifo_rdy, lut_shrt_rd_data_fifo_rdy, lut_long_rd_data_fifo_rdy;
   logic 				 lut_shrt_fifo_credit_used, lut_long_fifo_credit_used;
   logic [63:0] 			 crc_data;
   logic [PACK_IN_W-1:0] 		 pack_data_in;
   logic [PACK_IN_W-1:0] 		 pack_data_in_reg;
   logic [PACK_IN_SZ_W:0] 		 pack_data_in_size;
   logic [PACK_IN_SZ_W:0] 		 pack_data_in_size_reg;
   logic [PACK_OUT_CNT_SZ_W-1:0] 	 pack_data_out_idx;
   logic [PACK_OUT_CNT_SZ_W:0] 		 pack_data_out_cnt;
   logic [PACK_OUT_CNT_SZ_W:0] 		 pack_data_out_cnt_reg;
   logic [PACK_OUT_W-1:0] 		 pack_data_out_reg, pack_data_out;
   logic [PACK_ACC_W-1:0] 		 pack_accum_in;
   logic [PACK_ACC_SZ_W:0] 		 pack_accum_in_size;
   logic [PACK_OUT_W-1:0] 		 pack_accum_out;
   logic [PACK_OUT_SZ_W:0] 		 pack_accum_out_size;
   logic [PACK_OUT_SZ_W:0] 		 pack_accum_out_size_df;   
   logic [PACK_OUT_SZ_W:0] 		 pack_accum_out_size_df_pre;
   logic [PACK_ACC_SZ_W:0] 		 final_size;
   logic [2:0] 				 win_size_out;
   logic [2:0] 				 byte_pad;
   logic [3:0] 				 byte_pad_pre; 
   logic [2:0] 				 byte_pad_msk;
   logic [3:0] 				 byte_pad_df_pre; 
   logic [2:0] 				 byte_pad_df;
   logic [1:0] 				 xp_encode_type_size;
   logic [2:0] 				 xp_encode_type_long;
   logic [2:0] 				 xp_encode_type_shrt;
   logic 				 lz77_rd_done, lz77_wr_done;
   logic 				 st_long_sel, st_long_sel_reg, st_shrt_sel, st_shrt_sel_reg, st_long_err, st_long_err_reg, st_shrt_err, st_shrt_err_reg;
   logic 				 st_long_size_rdy, st_shrt_size_rdy;
   logic 				 st_long_tabl_rdy, st_shrt_tabl_rdy;
   logic [5:0]				 st_long_size_rdy_reg, st_shrt_size_rdy_reg;
   logic [4:0]				 st_long_tabl_rdy_reg, st_shrt_tabl_rdy_reg;
   logic 				 xp9;
   logic 				 xp9_raw;
   logic 				 xp10_raw;
   logic 				 seq_id_vld;
   logic 				 first_xfer_done;
   logic 				 flush_done;
   logic 				 mtf_present;
   logic 				 long_rd_mask;
   logic 				 lut_sa_long_rd_data_rd_masked;
   logic 				 mtf_sdd_dp_ready_delay;
   logic 				 term_rd_mask;
   logic 				 term_rd_masked;
   logic 				 deflate;
   logic 				 chu_mode;
   logic 				 chu_8k;
   logic 				 sch_last;
   logic 				 su_ready_reg;
   logic 				 df_sim_sel;
   logic 				 byte_0_stb;
   logic 				 byte_1_stb;
   logic 				 byte_2_stb;
   logic 				 byte_3_stb;
   logic 				 byte_4_stb;
   logic 				 byte_5_stb;
   logic 				 byte_6_stb;
   logic 				 byte_7_stb;
   logic 				 usr_full_reg;
   logic 				 final_sch_stall;
   logic 				 compound_cmd;
   
   logic [26:0]                          out_size_raw_temp_27b,out_size_bits_temp_27b;
   logic [27:0]                          out_size_raw_temp_28b;
   
   
   always_comb begin

      out_size_raw_temp_27b  = 0; 
      out_size_raw_temp_28b  = 0;
      out_size_bits_temp_27b = 0;
            
      if ((seq_id_intf.xp10_prefix_mode == NO_PREFIX) || (seq_id_intf.xp10_prefix_mode == USER_PREFIX))
	xp10_user_prefix_size_mask = 0;
      else
	xp10_user_prefix_size_mask = xp10_user_prefix_size;
      
      
      pack_accum_out_size_df_pre = pack_accum_out_size + 3; 
      
      if (seq_id_intf.blk_count == 0)
	byte_pad_df_pre   = 5;
      else
	if (pack_accum_out_size_df[2:0] == 0)
	  byte_pad_df_pre = 0;
	else
	  byte_pad_df_pre = (8 - pack_accum_out_size_df[2:0]);
      
      if (pack_accum_out_size[2:0] == 0)
	byte_pad_pre      = 0;
      else
	byte_pad_pre      = (8 - pack_accum_out_size[2:0]);

      byte_pad_msk        = byte_pad_pre[2:0];
      
      df_sim_sel          = 0;
      df_frm_raw_byte_count_nxt = df_frm_raw_byte_count + {8'd0, seq_id_intf.raw_byte_count}; 
      
      long_rd_mask        = 1;
      if ((seq_id_intf.comp_mode == CHU4K) || (seq_id_intf.comp_mode == CHU8K))
	chu_mode          = 1;
      else
	chu_mode          = 0;

      if (seq_id_intf.comp_mode == CHU8K)
	chu_8k            = 1;
      else
	chu_8k            = 0;

      
      if ((seq_id_intf.comp_mode == ZLIB) || (seq_id_intf.comp_mode == GZIP))
	deflate           = 1;
      else
	deflate           = 0;
      
      if (|frm_bit_count[2:0])
	frm_byte_count    = frm_bit_count[27:3] + 1; 
      else
	frm_byte_count    = frm_bit_count[27:3];     

      if (comp_mode_lst.comp_mode == XP10)
	if (comp_mode_lst.xp10_crc == CRC64)
	  frm_byte_count    = frm_byte_count + 14;                       
	else
	  frm_byte_count    = frm_byte_count + 10;                       
      else if (comp_mode_lst.comp_mode == GZIP)
	frm_byte_count      = frm_byte_count + 18;                       
      else if (comp_mode_lst.comp_mode == ZLIB)
	frm_byte_count      = frm_byte_count + 6;                        
	
      frm_bit_count_raw_adder_pre = 0;
      
      if (out_raw_sel_reg) begin
	 if (deflate) begin
	    sch_byte_count               = seq_id_intf.raw_byte_count + 5; 
	    frm_bit_count_raw_adder_pre = 35 + byte_pad_df;
	 end
	 else if (seq_id_intf.comp_mode == XP10)
	    sch_byte_count               = seq_id_intf.raw_byte_count + 4; 
	 else if (chu_mode)
	   sch_byte_count                = seq_id_intf.raw_byte_count + 3; 
	 else
	   sch_byte_count                = seq_id_intf.raw_byte_count;
      end
      else begin
	 sch_byte_count   = out_size_bits_reg[27:3];     
	 if (|out_size_bits_reg[2:0])
	   sch_byte_count = out_size_bits_reg[27:3] + 1; 
      end
	
      if (seq_id_intf.blk_count==0) begin
	 if (seq_id_intf.comp_mode == XP10)
	   sch_byte_count = sch_byte_count + 6;  
	 if (seq_id_intf.comp_mode == GZIP)
	   sch_byte_count = sch_byte_count + 10; 
	 if (seq_id_intf.comp_mode == ZLIB)
	   sch_byte_count = sch_byte_count + 2;  
      end
      if (seq_id_intf.blk_last) begin
	 if (seq_id_intf.comp_mode == XP10) begin  
	    if (seq_id_intf.xp10_crc_mode == CRC64)
	      sch_byte_count = sch_byte_count + 8; 
	    else
	      sch_byte_count = sch_byte_count + 4; 
	 end
	 if (seq_id_intf.comp_mode == GZIP)
	   sch_byte_count = sch_byte_count + 8; 
	 if (seq_id_intf.comp_mode == ZLIB)
	   sch_byte_count = sch_byte_count + 4; 
      end 

      frm_byte_count_final    = frm_byte_count;
      if (cipher_pad && !compound_cmd) begin
	 frm_byte_count_final = frm_byte_count + (16 - frm_byte_count[3:0]);   
	 sch_byte_count_final = 16 - frm_byte_count[3:0];                      
      end
      else  begin
	 sch_byte_count_final = 0;
      end
      
      bhp_mtf_hdr_bus_nxt     = 0;
      pack_data_in            = 0;
      hdr_word_cnt_max        = 0;
      st_long_size_rdy        = 0;
      st_long_tabl_rdy        = 0;
      st_long_sel             = 0;
      st_long_err             = 0;
      st_shrt_size_rdy        = 0;
      st_shrt_tabl_rdy        = 0;
      st_shrt_sel             = 0;
      st_shrt_err             = 0;
      shrt_stcl_words_mux     = 0;
      long_stcl_words_mux     = 0;
      shrt_stcl_remain_size_reg_mux = 0;
      long_stcl_remain_size_reg_mux = 0;
      crc_bits_vld            = 64;
      data_out_size_raw       = 0;
      raw_byte_count_nxt      = 0;
      data_out_eot_raw_nxt    = 0;
      data_out_eob_raw_nxt    = 0;
      data_out_eot_raw        = 0;
      data_out_eob_raw        = 0;
      if (!raw_fifo_empty && (data_out_signal_raw >= 2'b10))
	data_out_eot_raw      = 1;
      if ((raw_byte_count == seq_id_intf.raw_byte_count) && !eot_raw_done)
	data_out_eob_raw     = 1;
      if (!raw_fifo_empty && (data_out_signal_raw_nxt >= 2'b10))
	data_out_eot_raw_nxt = 1;
      if ((raw_byte_count+16 >= {1'b0, seq_id_intf.raw_byte_count}) && !eot_raw_done)
	data_out_eob_raw_nxt = 1;
      
      case (data_out_size_raw_pre)
	8'b00000001: data_out_size_raw = 8;
	8'b00000011: data_out_size_raw = 16;
	8'b00000111: data_out_size_raw = 24;
	8'b00001111: data_out_size_raw = 32;
	8'b00011111: data_out_size_raw = 40;
	8'b00111111: data_out_size_raw = 48;
	8'b01111111: data_out_size_raw = 56;
	8'b11111111: data_out_size_raw = 64;
	default:     data_out_size_raw = 0;
      endcase

      if (data_out_eot_raw || data_out_eot_raw_reg)
	data_out_size_raw = 0;
      
      if (st1_sa_short_size_rdy && (st1_sa_short_intf.size_seq_id == seq_id)) begin
	 st_shrt_size_rdy = 1;
	 st_shrt_err      = st1_sa_short_intf.build_error;
      end
      if (st2_sa_short_size_rdy && (st2_sa_short_intf.size_seq_id == seq_id)) begin
	 st_shrt_size_rdy = 1;
	 st_shrt_sel      = 1;
 	 st_shrt_err      = st2_sa_short_intf.build_error;
     end
      if (st1_sa_long_size_rdy  && (st1_sa_long_intf.size_seq_id == seq_id)) begin
	 st_long_size_rdy = 1;
	 st_long_err      = st1_sa_long_intf.build_error;
      end
      if (st2_sa_long_size_rdy  && (st2_sa_long_intf.size_seq_id == seq_id)) begin
	 st_long_size_rdy = 1;
	 st_long_sel      = 1;
	 st_long_err      = st2_sa_long_intf.build_error;
      end
      if ((st1_sa_short_table_rdy && (st_shrt_sel_reg == 0)) || (st2_sa_short_table_rdy && (st_shrt_sel_reg == 1))) begin
	 st_shrt_tabl_rdy = 1;
      end
      if ((st1_sa_long_table_rdy  && (st_long_sel_reg == 0)) || (st2_sa_long_table_rdy  && (st_long_sel_reg == 1))) begin
	 st_long_tabl_rdy = 1;
      end
      
      
      if (seq_id_intf.lz77_win_size == WIN_4K)
	win_size_out            = 0;
      else if (seq_id_intf.lz77_win_size == WIN_8K)
	win_size_out            = 1;
      else if (seq_id_intf.lz77_win_size == WIN_16K)
	win_size_out            = 2;
      else
	win_size_out            = 3;
      
       if (seq_id_intf.comp_mode == XP9)
	xp9                     = 1;
      else
	xp9                     = 0;
      term_rdy                  = 0;
      usr_rdy                   = 0;
      xfer_rdy                  = 0;
      sw_config.dis_used        = 0;
      sw_config.dis_return      = 0;
      sw_config.credit_limit    = N_HOLD_DEPTH;
      sw_config_enc.dis_used    = 0;
      sw_config_enc.dis_return  = 0;
      sw_config_enc.credit_limit = N_HOLD_ENC_DEPTH;
	    
      
      tlvp_in_aempty            = sq_sa_intf.aempty;
      tlvp_in_empty             = sq_sa_intf.empty;
      tlvp_in_data.tlast        = sq_sa_intf.tlast;
      tlvp_in_data.tdata        = sq_sa_intf.data;
      tlvp_in_data.tvalid       = 1;
      tlvp_in_data.tid          = 0;
      
      tlvp_in_data.tuser        = 0;
      tlvp_in_data.tuser[0]     = sq_sa_intf.sot;
      tlvp_in_data.tuser[1]     = sq_sa_intf.eot;
      tlvp_in_data.tuser[6:2]   = {sq_sa_intf.eob, sq_sa_intf.seq_id};
      case (sq_sa_intf.byte_vld)
	3'd0:tlvp_in_data.tstrb = 8'b00000001;
	3'd1:tlvp_in_data.tstrb = 8'b00000011;
	3'd2:tlvp_in_data.tstrb = 8'b00000111;
	3'd3:tlvp_in_data.tstrb = 8'b00001111;
	3'd4:tlvp_in_data.tstrb = 8'b00011111;
	3'd5:tlvp_in_data.tstrb = 8'b00111111;
	3'd6:tlvp_in_data.tstrb = 8'b01111111;
	3'd7:tlvp_in_data.tstrb = 8'b11111111;
      endcase 
      final_size                = {1'b0, pack_accum_in_size};  
      sa_sq_intf.rd             = tlvp_in_rd;
      mtf_hdr_size              = 21; 
      lut_sa_shrt_rd_data_wr    = 0;
      lut_sa_shrt_rd_data       = 0;
      lut_sa_long_rd_data_wr    = 0;
      lut_sa_long_rd_data       = 0;
      lut_long_rd_data_fifo_rdy = 0;
      lut_shrt_rd_data_fifo_rdy = 0;
      symbol_holding_rd_data_fifo_rdy = 0;
      enc_fifo_rd_rdy           = 0;
      raw_fifo_rd_rdy           = 0;
      raw_fifo_rd_rdy_wait      = 0;
      lz_symbol_bus             = term_tlv.tdata;
      tlv_word_0                = term_tlv.tdata;
      prefix_wrd_hdr            = term_tlv.tdata;
      tlv_ftr_word0             = term_tlv.tdata;
      tlv_ftr_word13            = term_tlv.tdata;
      tlv_pfd_word0             = term_tlv.tdata;
      tlv_cmd_word_1            = term_tlv.tdata;
      tlv_cmd_word_2            = term_tlv.tdata;
      lut_long_fifo_credit_used = sa_lut_long_intf.ret_st_rd  | sa_lut_long_intf.ret_stcl_rd  | sa_lut_long_intf.data_rd;
      lut_shrt_fifo_credit_used = sa_lut_short_intf.ret_st_rd | sa_lut_short_intf.ret_stcl_rd | sa_lut_short_intf.data_rd;
      long_stcl_remain          = |lut_sa_long_intf_reg.ret_stcl_size[5:0];
      long_stcl_remain_size     =  lut_sa_long_intf_reg.ret_stcl_size[5:0];
      long_stcl_words           = {6'd0, (lut_sa_long_intf_reg.ret_stcl_size>>6) + long_stcl_remain}; 
      long_st_remain            = |lut_sa_long_intf_reg.ret_st_size[5:0];
      long_st_remain_size       =  lut_sa_long_intf_reg.ret_st_size[5:0];
      long_st_words             = (lut_sa_long_intf_reg.ret_st_size>>6)   + long_st_remain;
      shrt_stcl_remain          = |lut_sa_short_intf_reg.ret_stcl_size[5:0];
      shrt_stcl_remain_size     =  lut_sa_short_intf_reg.ret_stcl_size[5:0];
      shrt_stcl_words           = {6'd0, (lut_sa_short_intf_reg.ret_stcl_size>>6) + shrt_stcl_remain};  
      shrt_st_remain            = |lut_sa_short_intf_reg.ret_st_size[5:0];
      shrt_st_remain_size       =  lut_sa_short_intf_reg.ret_st_size[5:0];
      shrt_st_words             = (lut_sa_short_intf_reg.ret_st_size>>6)   + shrt_st_remain;
      pack_data_in_size         = 64;
      
      lut_long_rd_data_fifo_aempty       = (lut_long_rd_data_fifo_used_slots       <= 1);
      lut_shrt_rd_data_fifo_aempty       = (lut_shrt_rd_data_fifo_used_slots       <= 1);
      symbol_holding_rd_data_fifo_aempty = (symbol_holding_rd_data_fifo_used_slots <= 1);
      enc_fifo_aempty                    = (enc_fifo_used_slots                    <= 1);
      raw_fifo_aempty                    = (raw_fifo_used_slots                    <= 1);
      raw_fifo_aempty_2                  = (raw_fifo_used_slots                    <= 2);
      
      
      
      if ((!lut_long_rd_data_fifo_aempty) || 
	  (!lut_long_rd_data_fifo_empty &&  lut_long_rd_data_fifo_aempty  && !lut_sa_long_rd_data_rd_masked)) 
	lut_long_rd_data_fifo_rdy = 1;      
      if ((!lut_shrt_rd_data_fifo_aempty) || 
	  (!lut_shrt_rd_data_fifo_empty &&  lut_shrt_rd_data_fifo_aempty  && !lut_sa_shrt_rd_data_rd)) 
	lut_shrt_rd_data_fifo_rdy = 1;      
      if ((!symbol_holding_rd_data_fifo_aempty) || 
	  (!symbol_holding_rd_data_fifo_empty &&  symbol_holding_rd_data_fifo_aempty  && !hold_symb_fifo_rd)) 
	symbol_holding_rd_data_fifo_rdy = 1;
      
      if ((!enc_fifo_aempty) || 
	  (!enc_fifo_empty &&  enc_fifo_aempty  && !enc_fifo_rd)) 
	enc_fifo_rd_rdy = 1;
      if ((!raw_fifo_aempty) || 
	  (!raw_fifo_empty &&  raw_fifo_aempty  && !raw_fifo_rd)) 
	raw_fifo_rd_rdy = 1;
      if ((!raw_fifo_aempty_2) || 
	  (!raw_fifo_empty &&  raw_fifo_aempty_2  && !raw_fifo_rd && (data_out_eot_raw_nxt || data_out_eob_raw_nxt)))
	raw_fifo_rd_rdy_wait = 1;
      
      if (lut_sa_short_st_stcl_val_reg) begin
	 lut_sa_shrt_rd_data_wr = 1;
	 lut_sa_shrt_rd_data    = {192'd0, lut_sa_short_intf_reg.ret_st_stcl_rd_data};
      end      
      else if (lut_sa_short_data_val_reg) begin
	 lut_sa_shrt_rd_data_wr = 1;
	 lut_sa_shrt_rd_data    = {lut_sa_short_intf_reg.rd_data3, lut_sa_short_intf_reg.rd_data2, lut_sa_short_intf_reg.rd_data1, lut_sa_short_intf_reg.rd_data0};
      end
       if (lut_sa_long_st_stcl_val_reg) begin
	 lut_sa_long_rd_data_wr = 1;
	 lut_sa_long_rd_data    = lut_sa_long_intf_reg.ret_st_stcl_rd_data;
      end
      else if (lut_sa_long_data_val_reg) begin
	 lut_sa_long_rd_data_wr = 1;
	 lut_sa_long_rd_data    = lut_sa_long_intf_reg.rd_data0;
      end
	 
      
      for (int i=0; i<4; i++) begin
	 mtf_ofs[i] = 0;
	 mtf_siz[i] = 5;
      end
      for (int i=0; i<4; i++) begin
	 mtf_exp[i]          = {1'd0, floor_log(mtf_offset[i])};
	 mtf_lsb[i]          = mtf_offset[i] - 2**mtf_exp[i];  
	 mtf_lsb_en[i]       = mtf_exp[i] != 0;
	 if (mtf_lsb_en[i])
	   mtf_siz[i]        = mtf_siz[i]   + mtf_exp[i]; 
	 mtf_hdr_size        = mtf_hdr_size + mtf_exp[i]; 
	 if (i!=0)
	   mtf_ofs[i]        = mtf_ofs[i-1] + mtf_siz[i-1]; 
      end
      if (seq_id_intf.comp_mode != XP9) begin
	 mtf_hdr_size        = mtf_hdr_size - 1;
	 if (compress_sel_last || (seq_id_intf.blk_count==0) || chu_mode)
	   mtf_hdr_size      = 0;
      end
     
      mtf_hdr_calc = 0;
      mtf_hdr      = 0;
      for (int i=0; i<4; i++) begin
	 if (mtf_lsb_en[i] == 1) begin
	    mtf_hdr_calc = ({mtf_lsb[i],mtf_exp[i]} << mtf_ofs[i]); 
	    mtf_hdr      = mtf_hdr | mtf_hdr_calc;                  
	 end
	 else begin
	    mtf_hdr_calc = (mtf_exp[i]              << mtf_ofs[i]); 
	    mtf_hdr      = mtf_hdr | mtf_hdr_calc;                  
	 end
      end
      if (seq_id_intf.comp_mode == XP9)
	mtf_hdr = {mtf_hdr[144:0], is_mtf_hdr_last_ptr}; 
      
      bhp_mtf_hdr_bus_nxt.offset0  = mtf_offset[0];
      bhp_mtf_hdr_bus_nxt.offset1  = mtf_offset[1];
      bhp_mtf_hdr_bus_nxt.offset2  = mtf_offset[2];
      bhp_mtf_hdr_bus_nxt.offset3  = mtf_offset[3];
      bhp_mtf_hdr_bus_nxt.exp0     = mtf_exp[0];
      bhp_mtf_hdr_bus_nxt.exp1     = mtf_exp[1];
      bhp_mtf_hdr_bus_nxt.exp2     = mtf_exp[2];
      bhp_mtf_hdr_bus_nxt.exp3     = mtf_exp[3];
      bhp_mtf_hdr_bus_nxt.ptr_last = is_mtf_hdr_last_ptr;      
      if (seq_id_intf.comp_mode == XP9) begin
	 bhp_mtf_hdr_bus_nxt.present = 1'd1;       
	 bhp_mtf_hdr_bus_nxt.format  = 1'd0;
      end
      else begin
	 bhp_mtf_hdr_bus_nxt.present = mtf_present;
	 bhp_mtf_hdr_bus_nxt.format  = 1'd1;
      end
     
      
      
      
      
      if (((seq_id_intf.comp_mode == XP9) && sw_xp9_disable_modes.xp9_disable_sim) || ((seq_id_intf.comp_mode >= XP10) && sw_xp10_disable_modes.xp10_disable_sim))
	shrt_size_sim        = 21'h1fffff;
      else
	shrt_size_sim        = {1'd0, lut_sa_short_intf_reg.sim_size};
      
      if (seq_id_intf.comp_mode == XP9 || (xp10_user_prefix_size == 0) || 
	  ((seq_id_intf.comp_mode >= XP10) && sw_xp10_disable_modes.xp10_disable_pre) || ((seq_id_intf.comp_mode >= XP10) && (seq_id_intf.xp10_prefix_mode != PREDET_HUFF)))
	shrt_size_pre        = 21'h1fffff;
      else
	shrt_size_pre        = {1'd0, lut_sa_short_intf_reg.pre_size};

      if (((seq_id_intf.comp_mode == XP9) && sw_xp9_disable_modes.xp9_disable_ret) || ((seq_id_intf.comp_mode >= XP10) && sw_xp10_disable_modes.xp10_disable_ret) ||
	  st_shrt_err_reg)
	shrt_size_ret        = 21'h1fffff; 
      else
	shrt_size_ret        =        lut_sa_short_intf_reg.ret_size      +
			              lut_sa_short_intf_reg.ret_st_size   +
                                      lut_sa_short_intf_reg.ret_stcl_size ;
      
      
      long_size_sim          = {1'd0, lut_sa_long_intf_reg.sim_size};
      if (seq_id_intf.comp_mode == XP9 || (xp10_user_prefix_size == 0) || 
	  ((seq_id_intf.comp_mode >= XP10) && sw_xp10_disable_modes.xp10_disable_pre) || ((seq_id_intf.comp_mode >= XP10) && (seq_id_intf.xp10_prefix_mode != PREDET_HUFF)))
	long_size_pre        = 21'h1fffff;
      else
	long_size_pre        = {1'd0, lut_sa_long_intf_reg.pre_size};
      if (((seq_id_intf.comp_mode == XP9) && sw_xp9_disable_modes.xp9_disable_ret) || ((seq_id_intf.comp_mode >= XP10) && sw_xp10_disable_modes.xp10_disable_ret) || 
	  st_long_err_reg)
	long_size_ret        = 21'h1fffff;
      else
	long_size_ret        = lut_sa_long_intf_reg.ret_size      +
			       lut_sa_long_intf_reg.ret_st_size   +
		               lut_sa_long_intf_reg.ret_stcl_size ;
      
      
      if (seq_id_intf.comp_mode == XP9)
	symbol_tbl_size      = 15'd6 + {7'd0, mtf_hdr_size};
      else
	symbol_tbl_size      = 15'd4 + {7'd0, mtf_hdr_size};
      if (shrt_sel == RET)
	symbol_tbl_size      = symbol_tbl_size + lut_sa_short_intf_reg.ret_st_size + lut_sa_short_intf_reg.ret_stcl_size; 
      if (long_sel == RET)
	symbol_tbl_size      = symbol_tbl_size + lut_sa_long_intf_reg.ret_st_size  + lut_sa_long_intf_reg.ret_stcl_size;  
      
      out_size_cmp_df_ret    = {12'd0,(17                                  + 
				       lut_sa_short_intf_reg.ret_st_size   + 
				       lut_sa_short_intf_reg.ret_stcl_size + 
				       lut_sa_short_intf_reg.ret_size      + 
				       lut_sa_long_intf_reg.ret_size       + 
				       seq_id_intf.extra_bit_count)};        
      
      out_size_cmp_df_sim    = {12'd0,(3                                   + 
				       lut_sa_short_intf_reg.sim_size      + 
				       lut_sa_long_intf_reg.sim_size       + 
				       seq_id_intf.extra_bit_count)};        
      
      
      
      if (seq_id_intf.comp_mode == XP9)
	out_size_cmp           = {11'b0,(shrt_size_min               + 
					 long_size_min               +
					 seq_id_intf.extra_bit_count +
					 256                         + 
					 21                          + 
					 mtf_exp[0]                  + 
					 mtf_exp[1]                  + 
					 mtf_exp[2]                  + 
					 mtf_exp[3]                  + 
					 6)};                          
      
      else if (seq_id_intf.comp_mode > XP9)
	out_size_cmp           = {11'b0,(shrt_size_min               + 
					 long_size_min               +
					 seq_id_intf.extra_bit_count +
					 mtf_hdr_size                +                           
					 4)};                          
      
      else begin
	 case ({(sw_deflate_disable_modes.df_disable_ret | st_shrt_err_reg),  sw_deflate_disable_modes.df_disable_sim})
	   2'b11:
	     out_size_cmp        = {32{1'b1}};
	   2'b01:
	     out_size_cmp        = out_size_cmp_df_ret;
	   2'b10: begin
	      df_sim_sel         = 1;
	      out_size_cmp       = out_size_cmp_df_sim;
	   end
	   2'b00: begin
	      if ((out_size_cmp_df_sim[31:3] + |out_size_cmp_df_sim[2:0]) <= (out_size_cmp_df_ret[31:3] + |out_size_cmp_df_ret[2:0])) begin
		 df_sim_sel      = 1;
		 out_size_cmp    = out_size_cmp_df_sim;
	      end
	      else
		out_size_cmp     = out_size_cmp_df_ret;
	   end
	 endcase 
      end 
      
      
      
      
      
      if (seq_id_intf.comp_mode >= XP9) begin
	 if (((seq_id_intf.comp_mode == XP9)  && sw_xp9_disable_modes.xp9_disable_raw)     ||
	     ((seq_id_intf.comp_mode == XP9)  && !xp9_raw && (seq_id_intf.blk_count != 0)) ||
	     ((seq_id_intf.comp_mode >= XP10) && sw_xp10_disable_modes.xp10_disable_raw)   ||
	     ((seq_id_intf.comp_mode >  XP10) && (seq_id_intf.chu_comp_thrsh == INF)))
	   out_size_raw       = {32{1'b1}};
	 else
           begin
	      out_size_raw_temp_27b  = seq_id_intf.raw_byte_count << 3; 
	      out_size_raw           = {5'b0,out_size_raw_temp_27b};
	   end
      end
      
      else begin
	 if (sw_deflate_disable_modes.df_disable_raw)
	   out_size_raw       = {32{1'b1}};
	 else
           begin
	      out_size_raw_temp_28b  = (seq_id_intf.raw_byte_count << 3) + 
					32;                               
					
	      out_size_raw           = {4'b0,out_size_raw_temp_28b};
	   end
      end
      
      out_raw_sel        = 0;
      out_size_cmp_adj   = {1'd0, out_size_cmp};
      
      

      
      if (deflate) begin
	 if (({1'b0, out_size_raw[31:3]} + |out_size_raw[2:0]) <= ({1'b0, out_size_cmp_adj[31:3]} + |out_size_cmp_adj[2:0])) begin
	    out_raw_sel  = 1;
	 end
	 else begin
	    out_raw_sel  = 0;
	 end
      end
      else if ((seq_id_intf.comp_mode >  XP10) && (seq_id_intf.chu_comp_thrsh == FRM_LESS_16)) begin
	 if (((out_size_raw - 136) <= out_size_cmp_adj) ||  (out_size_raw < 136)) begin
	    out_raw_sel  = 1;
	 end
      end
      else if (out_size_raw <= out_size_cmp_adj[31:0]) begin
	 out_raw_sel     = 1;
      end
      else begin
	 out_raw_sel     = 0;
      end
      
      
      if (out_raw_sel_reg) begin
	 out_size_bytes_pre   = {9'd0, seq_id_intf.raw_byte_count};      
         out_size_bits_temp_27b = seq_id_intf.raw_byte_count << 3; 
	 out_size_bits        = {1'b0,out_size_bits_temp_27b};
      end
      
      else begin
	 out_size_bits        = out_size_cmp[27:0];
	 if (out_size_cmp[2:0] != 0)
	   out_size_bytes_pre = out_size_cmp/8 + 1;
	 else
	   out_size_bytes_pre = out_size_cmp/8;
      end
      
      out_size_bytes          = out_size_bytes_pre[23:0];

      xp_encode_type_long = XP9_SIM;
      xp_encode_type_shrt = XP9_SIM;
      xp_encode_type_size = 3;   
      
      
      if (seq_id_intf.comp_mode == XP9) begin
	 if (long_sel == RET)
	   xp_encode_type_long = {XP9_RET};
	 if (shrt_sel == RET)
	   xp_encode_type_shrt = {XP9_RET};
      end
      if ((seq_id_intf.comp_mode == XP10) || (seq_id_intf.comp_mode == CHU4K) || (seq_id_intf.comp_mode == CHU8K)) begin
	 xp_encode_type_long = XP10_SIM;
	 xp_encode_type_shrt = XP10_SIM;
	 xp_encode_type_size = 2;
	 if (long_sel == PRE)
	   xp_encode_type_long = {XP10_PRE};
	 else if (long_sel == RET)
	   xp_encode_type_long = {XP10_RET};
	 if (shrt_sel == PRE)
	   xp_encode_type_shrt = {XP10_PRE};
	 else if (shrt_sel == RET)
	   xp_encode_type_shrt = {XP10_RET};
	 
      end
      
      
      
      if ((!term_aempty)                || (!term_empty && term_aempty && !term_rd))
	term_rdy = 1;
      
      if ((!usr_afull)                  || (!usr_full   && usr_afull   && !usr_wr && !enc_fifo_rd && !raw_fifo_rd && (pack_data_out_cnt_reg == 0)))
	usr_rdy  = 1;
      
      if (term_rdy && usr_rdy) begin
	 xfer_rdy = 1'd1;
      end
	 
      usr_tlv_nxt.tuser     = 0;
      usr_tlv_nxt.insert    = 0;
      usr_tlv_nxt.ordern    = term_tlv.ordern;
      usr_tlv_nxt.typen     = term_tlv.typen;
      usr_tlv_nxt.tlast     = term_tlv.tlast;
      usr_tlv_nxt.tuser[0]  = term_tlv.tuser[0];
      usr_tlv_nxt.tuser[1]  = term_tlv.tuser[1];
      usr_tlv_nxt.tstrb     = term_tlv.tstrb;
      usr_tlv_nxt.tdata     = term_tlv.tdata;
      usr_tlv_nxt.tid       = seq_id_intf.tid;
      
      eob                   = term_tlv.tuser[6];
      
      
      
      ftr_crc_sel     = seq_id_intf.raw_crc;
      if (seq_id_intf.comp_mode == ZLIB)
	ftr_crc_sel   = {32'd0, seq_id_intf.raw_crc[7:0], seq_id_intf.raw_crc[15:8], seq_id_intf.raw_crc[23:16], seq_id_intf.raw_crc[31:24]};
      
      
      if (seq_id_intf.comp_mode == XP9) begin
	 ftr_crc_size = 0;
      end
      
      else if (seq_id_intf.comp_mode == GZIP) begin
	 ftr_crc_size = 32;
      end
      
      else if (seq_id_intf.comp_mode == ZLIB) begin
	 ftr_crc_size = 32;
      end
      
      else if (seq_id_intf.xp10_crc_mode == CRC64) begin
	 ftr_crc_size = 64;
      end
      
      else begin
	 ftr_crc_size = 32;
      end
      
      tlv_data_word_0 = term_tlv.tdata;
      tlv_rqe_word_1  = term_tlv.tdata;
      
      if ((state == SA_FRM_IDL) && (term_tlv.typen == LZ77) && (seq_id_intf.comp_mode != NONE)) begin
	 tlv_data_word_0.tlv_type     = tlv_types_e'(DATA_UNK);
	 
	 if ((seq_id_intf.comp_mode == XP9) && out_raw_sel_reg) begin
	    tlv_data_word_0.coding = RAW;
	 end
	 else if (seq_id_intf.comp_mode == CHU4K) begin
	    tlv_data_word_0.coding = XP10CFH4K;
	 end
	 else if (seq_id_intf.comp_mode == CHU8K) begin
	    tlv_data_word_0.coding = XP10CFH8K;
	 end
	 else begin	    
	    tlv_data_word_0.coding = PARSEABLE;
	 end
	 usr_tlv_nxt.tdata         = {get_bip2(tlv_data_word_0),
				      tlv_data_word_0.last_of_command,
				      tlv_data_word_0.resv0,
				      tlv_data_word_0.coding,
				      tlv_data_word_0.tlv_frame_num,
				      tlv_data_word_0.resv1,
				      tlv_data_word_0.tlv_eng_id,
				      tlv_data_word_0.tlv_seq_num,
				      tlv_data_word_0.tlv_len,
				      tlv_data_word_0.tlv_type
				      }; 
      end

      
      if (term_tlv.tuser[0] && (((seq_id_intf.comp_mode == NONE) && (term_tlv.typen == LZ77)) ||  (state == SA_DATA))) begin
	 tlv_data_word_0.tlv_type  = tlv_types_e'(DATA_UNK);
	 tlv_data_word_0.coding    = RAW;
	 usr_tlv_nxt.tdata         = {get_bip2(tlv_data_word_0),
				      tlv_data_word_0.last_of_command,
				      tlv_data_word_0.resv0,
				      tlv_data_word_0.coding,
				      tlv_data_word_0.tlv_frame_num,
				      tlv_data_word_0.resv1,
				      tlv_data_word_0.tlv_eng_id,
				      tlv_data_word_0.tlv_seq_num,
				      tlv_data_word_0.tlv_len,
				      tlv_data_word_0.tlv_type
				      }; 
      end
      
      
      if ((state == SA_XP_HDR) && (seq_id_intf.comp_mode == XP9)) begin
	 usr_tlv_nxt.typen     = tlv_types_e'(DATA_UNK);
	 usr_tlv_nxt.tdata     = pack_data_out_reg;
	 hdr_word_cnt_max      = 6;
	 case (wr_hdr_word_cnt)
	   8'd0: begin
	      pack_data_in      = {110'b0, seq_id_intf.raw_byte_count, 32'd`XPRESS9_ID}; 
	   end
	   8'd1: begin
	      pack_data_in      = {113'b0, 1'd1, seq_id_intf.lz77_min_match_len, 2'd2, 3'd0, symbol_tbl_size_reg, out_size_cmp_reg}; 
	   end
	   8'd2: begin
	      pack_data_in      = {165'b0};
	   end
	   8'd3: begin
	      pack_data_in      = {101'b0, 32'd0, 21'd0, seq_id_intf.blk_count};
	   end
	   8'd4: begin
	      crc_bits_vld      = 32;
	   end
	   default: begin
	      pack_data_in      = {101'b0, ~xp10_crc_32, 21'd0, seq_id_intf.blk_count};
	      crc_bits_vld      = 0;
	   end
	 endcase
      end 
	
	
      if ((state == SA_XP_HDR) && (seq_id_intf.comp_mode == XP10)) begin
	 usr_tlv_nxt.typen  = tlv_types_e'(DATA_UNK);
	 usr_tlv_nxt.tdata  = pack_data_out_reg;
	 pack_data_in_size  = 0;
	 hdr_word_cnt_max   = 1;
	 if (seq_id_intf.blk_count == 0) begin
	    
	    pack_data_in        = {85'd0, seq_id_intf.blk_last, mtf_present, ~out_raw_sel_reg, 1'd0, out_size_bits_reg,  
				   1'd0, ~seq_id_intf.xp10_crc_mode, 2'd0, xp10_user_prefix_size_mask,  
		      		   seq_id_intf.xp10_prefix_mode, seq_id_intf.lz77_min_match_len, win_size_out,
		      		   32'd`XPRESS10_ID};
	    pack_data_in_size   = 80;
	    
	 end
	 
	 else begin
	    pack_data_in         = {133'd0, seq_id_intf.blk_last, mtf_present, ~out_raw_sel_reg, 1'd0, out_size_bits_reg};
	    pack_data_in_size    = 32;
	 end
      end 
      
      if ((state == SA_XP_HDR) && chu_mode) begin
      usr_tlv_nxt.typen     = tlv_types_e'(DATA_UNK);
	 usr_tlv_nxt.tdata  = pack_data_out_reg;
	 hdr_word_cnt_max   = 1;
	 pack_data_in_size  = 24;
	 begin
	    
	    if (out_raw_sel_reg) begin
	       pack_data_in = {141'd0, chu_8k, 1'd1, 6'd0,                       out_size_bits_chu[15:0]};
	    end
	    
	    else begin
	       pack_data_in = {141'd0, chu_8k, 1'd0, xp10_user_prefix_size_mask, out_size_bits_chu[15:0]};
	    end
	 end
      end
      
      
      if (state == SA_DF_HDR) begin
	 usr_tlv_nxt.typen  = tlv_types_e'(DATA_UNK);
	 usr_tlv_nxt.tdata  = pack_data_out_reg;
	 
	 if (seq_id_intf.blk_count == 0) begin
	    if (seq_id_intf.comp_mode == ZLIB) begin
	       if (out_raw_sel_reg) begin
		  
		  
		  pack_data_in        = {146'd0, 2'b00, seq_id_intf.blk_last, 2'h3, 1'h0, 5'h1a, 4'h7, 4'h8}        |   
		         	       ({~out_size_bytes_reg[15:0], out_size_bytes_reg[15:0]} << (byte_pad_df+19)) ;   
	      	  
		  pack_data_in_size   = 51 + byte_pad_df;
	       end
	       else if (shrt_sel == RET) begin
		  
		  pack_data_in        = {132'd0, lut_sa_short_intf_reg.hclen, lut_sa_short_intf_reg.hdist, lut_sa_short_intf_reg.hlit, 2'b10, seq_id_intf.blk_last, 2'h3, 1'h0, 5'h1a, 4'h7, 4'h8};
		  pack_data_in_size   = 33;
	       end
	       else begin
		  
		  pack_data_in        = {146'd0, 2'b01, seq_id_intf.blk_last, 2'h3, 1'h0, 5'h1a, 4'h7, 4'h8};
		  pack_data_in_size   = 19;
	       end
	    end
	    
	    else begin
	       if (out_raw_sel_reg) begin
		  
		  
		  pack_data_in        = {82'd0, 2'b00, seq_id_intf.blk_last, sw_gzip_os, 8'h02, 32'd0, 8'h00, 8'h08, 8'h8b, 8'h1f} | 
					({~out_size_bytes_reg[15:0], out_size_bytes_reg[15:0]} << (byte_pad_df+83));                 
		  
		  pack_data_in_size   = 115 + byte_pad_df;
	       end
	       else if (shrt_sel == RET) begin
		  
		  pack_data_in        = {68'd0, lut_sa_short_intf_reg.hclen, lut_sa_short_intf_reg.hdist, lut_sa_short_intf_reg.hlit, 2'b10, seq_id_intf.blk_last, sw_gzip_os, 8'h02, 32'd0, 8'h00, 8'h08, 8'h8b, 8'h1f};
		  pack_data_in_size   = 97;
	       end
	       else begin
		  
		  pack_data_in        = {82'd0, 2'b01, seq_id_intf.blk_last, sw_gzip_os, 8'h02, 32'd0, 8'h00, 8'h08, 8'h8b, 8'h1f};
		  pack_data_in_size   = 83;
	       end
	    end 
	 end
	 
	 else begin
	    if (out_raw_sel_reg) begin
	       
	       
	       pack_data_in        = {162'd0, 2'b00, seq_id_intf.blk_last}                                         | 
				     ({~out_size_bytes_reg[15:0], out_size_bytes_reg[15:0]} << (byte_pad_df+3))    ; 
	       
	       pack_data_in_size   = 35 + byte_pad_df;
	    end
	    else if (shrt_sel == RET) begin
	       
	       pack_data_in        = {148'd0, lut_sa_short_intf_reg.hclen, lut_sa_short_intf_reg.hdist, lut_sa_short_intf_reg.hlit, 2'b10, seq_id_intf.blk_last};
	       pack_data_in_size   = 17;
	    end
	    else begin
	       
	       pack_data_in        = {162'd0, 2'b01, seq_id_intf.blk_last};
	       pack_data_in_size   = 3;
	    end
	 end
      end
      
      if (state == SA_LONG_TBL_STCL) begin
	 usr_tlv_nxt.typen             = tlv_types_e'(DATA_UNK);
	 usr_tlv_nxt.tdata             = pack_data_out;
	 if (wr_hdr_word_cnt == 0)
	   usr_tlv_nxt.tdata           = pack_data_out_reg;
	 else
	   usr_tlv_nxt.tdata           = pack_data_out;
	 pack_data_in                  = lut_sa_long_data;
	 long_stcl_words_mux           = long_stcl_words;
	 long_stcl_remain_size_reg_mux = long_stcl_remain_size_reg;	 
	 if (long_stcl_words_reg == rd_hdr_word_cnt)
	   pack_data_in_size           = {3'd0, long_stcl_remain_size_reg};
	 if (wr_hdr_word_cnt == 0)
	   pack_data_in_size           = 0;
      end
      if (state == SA_LONG_TBL_ST) begin
	 usr_tlv_nxt.typen             = tlv_types_e'(DATA_UNK);
	 usr_tlv_nxt.tdata             = pack_data_out;
	 pack_data_in                  = lut_sa_long_data;
	 long_stcl_words_mux           = long_st_words;
	 long_stcl_remain_size_reg_mux = long_st_remain_size_reg;	 
	 if ((long_st_words_reg == rd_hdr_word_cnt) && long_st_remain_reg)
	   pack_data_in_size           = {3'd0, long_st_remain_size_reg};			      
      end
      if (state == SA_SHRT_TBL_STCL) begin
	 usr_tlv_nxt.typen             = tlv_types_e'(DATA_UNK);
	 if (wr_hdr_word_cnt == 0)
	   usr_tlv_nxt.tdata           = pack_data_out_reg;
	 else
	   usr_tlv_nxt.tdata           = pack_data_out;
	 pack_data_in                  = {lut_sa_shrt_data};
	 shrt_stcl_words_mux           = shrt_stcl_words;
	 shrt_stcl_remain_size_reg_mux = shrt_stcl_remain_size_reg;
	 if (shrt_stcl_words_reg == rd_hdr_word_cnt)
	   pack_data_in_size           = {3'd0, shrt_stcl_remain_size_reg};
	 if (wr_hdr_word_cnt == 0)
	   pack_data_in_size           = 0;
      end
      if (state == SA_SHRT_TBL_ST) begin
	 usr_tlv_nxt.typen             = tlv_types_e'(DATA_UNK);
	 usr_tlv_nxt.tdata             = pack_data_out;
	 pack_data_in                  = {lut_sa_shrt_data};
	 shrt_stcl_words_mux           = shrt_st_words;
	 shrt_stcl_remain_size_reg_mux = shrt_st_remain_size_reg;
	  if ((shrt_st_words_reg == rd_hdr_word_cnt) && shrt_st_remain_reg)
	   pack_data_in_size           = {3'd0, shrt_st_remain_size_reg};
      end

      if (state == SA_RAW) begin
	 usr_tlv_nxt.typen       = tlv_types_e'(DATA_UNK);
	 usr_tlv_nxt.tdata       = pack_data_out_reg;
	 usr_tlv_nxt.tstrb       = 8'b11111111;
	 pack_data_in            = {101'd0, data_out_raw};
	 if (raw_fifo_rd) begin
	    pack_data_in_size    = {1'd0, data_out_size_raw};
	    raw_byte_count_nxt   = raw_byte_count + data_out_size_raw/8; 
	 end
	 else begin
	    pack_data_in_size    = 0;
	    raw_byte_count_nxt   = raw_byte_count;
	 end  
	 usr_tlv_nxt.tuser[0]    = 0;
	 usr_tlv_nxt.tuser[1]    = 0;
	 usr_tlv_nxt.eot         = 0;
	 
	 if ((data_out_eot_raw || data_out_eot_raw_reg || ((lz_be_dp_bus.data_type[1:0] >= 2'b10) && raw_fifo_empty)) &&
	     (pack_data_out_cnt == 0) && (pack_accum_out_size == 0) && ((seq_id_intf.comp_mode == XP9) || chu_mode)) begin
	    usr_tlv_nxt.tuser[1] = 1;
	    usr_tlv_nxt.eot      = 1;	    
	 end
      end 
      
      
      if (state == SA_LZ77) begin
	 raw_byte_count_nxt      = raw_byte_count;
	 if (raw_fifo_rd) begin
	    raw_byte_count_nxt   = raw_byte_count + data_out_size_raw/8; 
	 end
	 long_rd_mask            = symbol_holding_fifo_rd_data.mux_symbol_map_intf.long_vld;
	 usr_tlv_nxt.typen       = tlv_types_e'(DATA_UNK);
	 usr_tlv_nxt.tdata       = pack_data_out_reg;
	 pack_data_in            = data_out_enc;
	 if (enc_fifo_rd)
	   pack_data_in_size     = {1'd0, data_out_size_enc};
	 else
	   pack_data_in_size     = 0;
	 usr_tlv_nxt.tuser[0]    = 0;
	 usr_tlv_nxt.tuser[1]    = 0;
	 usr_tlv_nxt.eot         = 0;
	 usr_tlv_nxt.tstrb       = 8'b11111111;
	 if ((((data_out_eot_enc && !enc_fifo_empty) || (symbol_holding_rd_data_fifo_empty && enc_fifo_empty && !data_out_pend && eot_enc_done)) && (pack_data_out_cnt == 0) && (pack_accum_out_size == 0)) && 
	     ((seq_id_intf.comp_mode == XP9) || chu_mode)) begin
	    usr_tlv_nxt.tuser[1] = 1;
	    usr_tlv_nxt.eot      = 1;	    
	 end
      end
      
      if (state == SA_LZ77_END) begin
	 usr_tlv_nxt.typen       = tlv_types_e'(DATA_UNK);
	 usr_tlv_nxt.tdata       = pack_data_out_reg;
	 pack_data_in_size       = 0;
	 usr_tlv_nxt.tuser[0]    = 0;
	 if (!wr_more || flush_done) begin
	    usr_tlv_nxt.tuser[1] = 1;
	    usr_tlv_nxt.eot      = 1;
	    if      (final_size ==0)
	      usr_tlv_nxt.tstrb = 8'b11111111;
	    else if (final_size <=8)
	      usr_tlv_nxt.tstrb = 8'b00000001;
	    else if (final_size <=16)
	      usr_tlv_nxt.tstrb = 8'b00000011;
	    else if (final_size <=24)
	      usr_tlv_nxt.tstrb = 8'b00000111;
	    else if (final_size <=32)
	      usr_tlv_nxt.tstrb = 8'b00001111;
	    else if (final_size <=40)
	      usr_tlv_nxt.tstrb = 8'b00011111;
	    else if (final_size <=48)
	      usr_tlv_nxt.tstrb = 8'b00111111;
	    else if (final_size <=56)
	      usr_tlv_nxt.tstrb = 8'b01111111;
	    else
	      usr_tlv_nxt.tstrb = 8'b11111111;
	 end   
      end
      
      if (state == SA_DATA) begin
	 if (term_rd & !term_tlv.tuser[0]) begin
	    raw_byte_count_nxt   = raw_byte_count + term_tlv.tstrb[0] + term_tlv.tstrb[1] + term_tlv.tstrb[2] + term_tlv.tstrb[3] + 
				                    term_tlv.tstrb[4] + term_tlv.tstrb[5] + term_tlv.tstrb[6] + term_tlv.tstrb[7];  
	 end
	 else begin
	    raw_byte_count_nxt   = raw_byte_count;
	 end
      end
      
      frm_bit_count_nxt         = frm_bit_count + (raw_byte_count_nxt<<3);  
      frm_byte_count_nxt        = frm_bit_count_nxt >> 3;                   
      frm_byte_count_cipher_nxt = frm_byte_count_nxt + (16 - frm_byte_count_nxt[3:0]);
      
      if (state == SA_OTHR) begin
	 if (term_tlv.typen == FTR) begin
	    if ((rd_hdr_word_cnt == 0) && xp9_raw) begin
	       tlv_ftr_word0.coding        = RAW;
	       tlv_ftr_word0               = {get_bip2(tlv_ftr_word0),            
					      tlv_ftr_word0.rsvd3,
					      tlv_ftr_word0.gen_frmd_out_type,
					      tlv_ftr_word0.rsvd2,
					      tlv_ftr_word0.raw_data_mac_size,
					      tlv_ftr_word0.enc_cmp_data_mac_size,
					      tlv_ftr_word0.coding,
					      tlv_ftr_word0.rsvd1,
					      tlv_ftr_word0.tlv_frame_num,
					      tlv_ftr_word0.rsvd0,
					      tlv_ftr_word0.tlv_eng_id,
					      tlv_ftr_word0.tlv_seq_num,
					      tlv_ftr_word0.tlv_len,
					      tlv_ftr_word0.tlv_type
					      };                                 
	       usr_tlv_nxt.tdata            = tlv_ftr_word0;
	    end
	    if (rd_hdr_word_cnt == 13) begin
	       tlv_ftr_word13.compressed_length          = frm_byte_count_final;
	       if ((tlv_ftr_word13.error_code == NO_ERRORS) && (ecc_error_reg || prehfd_crc_error || prefix_crc_error || sym_map_error)) begin
		     tlv_ftr_word13.errored_frame_number = huf_comp_sch_update.tlv_frame_num;
		     if (ecc_error_reg)
		       tlv_ftr_word13.error_code         = HE_MEM_ECC;
		     else if (prehfd_crc_error)
		       tlv_ftr_word13.error_code         = HE_PDH_CRC;
		     else if (prefix_crc_error)
		       tlv_ftr_word13.error_code         = HE_PFX_CRC;
		     else if (sym_map_error)
		       tlv_ftr_word13.error_code         = HE_SYM_MAP_ERR;
	       end 
	       usr_tlv_nxt.tdata                         = tlv_ftr_word13;
	    end 
	 end 
      end
      
      if (pack_data_out_cnt_reg != 0) begin
	 pack_data_in       = pack_data_in_reg;
	 pack_data_in_size  = pack_data_in_size_reg;
		    
      end
      
      mux_symbol_map_intf           = df_symbol_map_intf;
      mux_symbol_map_intf.long_vld  = lz_symbol_bus.backref & ~lz_symbol_bus.backref_type;
      if (seq_id_intf.comp_mode > GZIP)
	mux_symbol_map_intf         = xp_symbol_map_intf;
      
      shrt_data_addr0         = {2'd0, lz_symbol_bus.data0};
      shrt_data_addr1         = {2'd0, lz_symbol_bus.data1};
      shrt_data_addr2         = {2'd0, lz_symbol_bus.data2};
      shrt_data_addr3         = {2'd0, lz_symbol_bus.data3};
      ofs                     = 0;
      mtf_num                 = 0;
      is_mtf_hdr_last_ptr_nxt = 0;
      if (lz_symbol_bus.backref) begin
	 case (lz_symbol_bus.backref_lane)
	   2'd0 : begin
	      if (lz_symbol_bus.framing == 4'd1)
		is_mtf_hdr_last_ptr_nxt = 1;
	      shrt_data_addr0           = mux_symbol_map_intf.shrt;
	      ofs                       = {lz_symbol_bus.offset_msb, lz_symbol_bus.data0};
	      mtf_num                   =  lz_symbol_bus.data0[`N_MAX_MTF_WIDTH-1:0] ;
	   end
	   2'd1 : begin
	      if (lz_symbol_bus.framing == 4'd2)
		is_mtf_hdr_last_ptr_nxt = 1;
	      shrt_data_addr1           = mux_symbol_map_intf.shrt;
	      ofs                       = {lz_symbol_bus.offset_msb, lz_symbol_bus.data1};
	      mtf_num                   =  lz_symbol_bus.data1[`N_MAX_MTF_WIDTH-1:0];
	   end
	   2'd2 : begin
	      if (lz_symbol_bus.framing == 4'd3)
		is_mtf_hdr_last_ptr_nxt = 1;
	      shrt_data_addr2           = mux_symbol_map_intf.shrt;
	      ofs                       = {lz_symbol_bus.offset_msb, lz_symbol_bus.data2};
	      mtf_num                   =  lz_symbol_bus.data2[`N_MAX_MTF_WIDTH-1:0];
	   end
	   default : begin
	      if (lz_symbol_bus.framing == 4'd4)
		is_mtf_hdr_last_ptr_nxt = 1;
	      shrt_data_addr3           = mux_symbol_map_intf.shrt;
	      ofs                       = {lz_symbol_bus.offset_msb, lz_symbol_bus.data3};
	      mtf_num                   =  lz_symbol_bus.data3[`N_MAX_MTF_WIDTH-1:0];
	   end
	 endcase
      end
      symbol_holding_fifo_wr_data_nxt.eob                 = eob;
      symbol_holding_fifo_wr_data_nxt.eot                 = term_tlv.tuser[1];
      symbol_holding_fifo_wr_data_nxt.framing             = lz_symbol_bus.framing;
      symbol_holding_fifo_wr_data_nxt.shrt_0              = shrt_data_addr0;
      symbol_holding_fifo_wr_data_nxt.shrt_1              = shrt_data_addr1;
      symbol_holding_fifo_wr_data_nxt.shrt_2              = shrt_data_addr2;
      symbol_holding_fifo_wr_data_nxt.shrt_3              = shrt_data_addr3;
      symbol_holding_fifo_wr_data_nxt.ptr_idx             = lz_symbol_bus.backref_lane;
      symbol_holding_fifo_wr_data_nxt.ptr_en              = lz_symbol_bus.backref;
      symbol_holding_fifo_wr_data_nxt.mux_symbol_map_intf = mux_symbol_map_intf;
      
      if (term_tlv.tuser[1] && deflate) begin
	 symbol_holding_fifo_wr_data_nxt.shrt_0               = 10'd256;
	 symbol_holding_fifo_wr_data_nxt.ptr_en               = 0;
	 symbol_holding_fifo_wr_data_nxt.mux_symbol_map_intf  = 0;
      end
      usr_tlv_nxt.sot                                     = usr_tlv_nxt.tuser[0];
      usr_tlv_nxt.eot                                     = usr_tlv_nxt.tuser[1];
      
      
      
      if ((out_raw_sel_reg && (chu_mode || (seq_id_intf.comp_mode == XP9))) ||
	  
	  (!sw_deflate_disable_modes.df_disable_raw && deflate)             ||
	  
	  (!sw_xp10_disable_modes.xp10_disable_raw  && (seq_id_intf.comp_mode == XP10)))
	reconstruct_en                                    = 1;
      else
	reconstruct_en                                    = 0;

      if (!out_raw_sel_reg && 
	  ((!sw_xp10_disable_modes.xp10_disable_raw  && (chu_mode || ((seq_id_intf.comp_mode == XP10) && seq_id_intf.blk_last))) ||
	   (!sw_deflate_disable_modes.df_disable_raw && deflate && seq_id_intf.blk_last)))
	reconstruct_chu_flush                              = 1;
      else
	reconstruct_chu_flush                              = 0;
      

      
      if (sdd_mtf_dp_valid && !mtf_sdd_dp_ready)
	mtf_sdd_dp_ready_delay                            = 0;
      else
	mtf_sdd_dp_ready_delay                            = 1;

      if (is_mtf_hdr_last_ptr && (lz_symbol_bus.backref_lane == 0))
	prev_mtf_or_ptr                                   = 1;
      else
	prev_mtf_or_ptr                                   = 0;
      if (usr_wr && ((state_reg == SA_RAW)           || (state_reg == SA_LZ77)        || (state_reg == SA_LZ77_END) || (state_reg == SA_LONG_TBL_STCL) || (state_reg == SA_LONG_TBL_ST) ||
		     (state_reg == SA_SHRT_TBL_STCL) || (state_reg == SA_SHRT_TBL_ST) || (state_reg == SA_DF_HDR)   || (state_reg == SA_XP_HDR)        || ((state    == SA_DATA) && !usr_tlv_nxt.sot)))  begin
	 byte_0_stb = usr_tlv_nxt.tstrb[0];
	 byte_1_stb = usr_tlv_nxt.tstrb[1];
	 byte_2_stb = usr_tlv_nxt.tstrb[2];
	 byte_3_stb = usr_tlv_nxt.tstrb[3];
	 byte_4_stb = usr_tlv_nxt.tstrb[4];
	 byte_5_stb = usr_tlv_nxt.tstrb[5];
	 byte_6_stb = usr_tlv_nxt.tstrb[6];
	 byte_7_stb = usr_tlv_nxt.tstrb[7];
      end
      else begin
	 byte_0_stb = 0;
	 byte_1_stb = 0;
	 byte_2_stb = 0;
	 byte_3_stb = 0;
	 byte_4_stb = 0;
	 byte_5_stb = 0;
	 byte_6_stb = 0;
	 byte_7_stb = 0;
      end
   end 

   always_comb begin
      if ((state == SA_RAW) || ((state == SA_LZ77) && reconstruct_en_reg))
	term_rd_mask                = mtf_sdd_dp_ready_delay;
      else
	term_rd_mask                = 1;
      lut_sa_long_rd_data_rd_masked = lut_sa_long_rd_data_rd & long_rd_mask;
      term_rd_masked                = term_rd                & term_rd_mask;
   end
   
   
   always_ff @(negedge rst_n or posedge clk) begin
      if (!rst_n) begin
	 state                       <= SA_IDLE;
	 state_reg                   <= SA_IDLE;
	 for (int i=0; i<4; i++)
	    mtf_offset[i]            <= 0;
	 
	 long_sel <= SIM;
	 shrt_sel <= SIM;
	 comp_mode_lst.comp_mode <= NONE;
	 comp_mode_lst.xp10_crc  <= CRC32;
	 huf_comp_stats          <= 0;
	 
	 
	 bhp_mtf_hdr_bus <= 0;
	 bhp_mtf_hdr_valid <= 0;
	 byte_pad <= 0;
	 byte_pad_df <= 0;
	 cipher_last <= 0;
	 cipher_pad <= 0;
	 compound_cmd <= 0;
	 compress_sel_last <= 0;
	 crc_data <= 0;
	 data_out_eot_enc_reg <= 0;
	 data_out_eot_raw_reg <= 0;
	 df_frm_raw_byte_count <= 0;
	 ecc_error_reg <= 0;
	 enc_fifo_rd <= 0;
	 eob_raw_done <= 0;
	 eot_enc_done <= 0;
	 eot_raw_done <= 0;
	 fhp_lz_prefix_dp_bus.data <= 0;
	 fhp_lz_prefix_dp_bus.last <= 0;
	 fhp_lz_prefix_dp_bus.prefix_type <= 0;
	 fhp_lz_prefix_dp_bus.sof <= 0;
	 fhp_lz_prefix_hdr_bus.data_sz <= 0;
	 fhp_lz_prefix_hdr_bus.prefix_type <= 0;
	 fhp_lz_prefix_hdr_bus.trace_bit <= 0;
	 fhp_lz_prefix_hdr_valid <= 0;
	 fhp_lz_prefix_valid <= 0;
	 final_sch_stall <= 0;
	 first_xfer_done <= 0;
	 flush_done <= 0;
	 frm_bit_count <= 0;
	 frm_bit_count_raw_adder <= 0;
	 hold_symb_fifo_rd <= 0;
	 hold_symb_fifo_wr <= 0;
	 huf_comp_sch_update.basis <= 0;
	 huf_comp_sch_update.bytes_in <= 0;
	 huf_comp_sch_update.bytes_out <= 0;
	 huf_comp_sch_update.last <= 0;
	 huf_comp_sch_update.rqe_sched_handle <= 0;
	 huf_comp_sch_update.tlv_eng_id <= 0;
	 huf_comp_sch_update.tlv_frame_num <= 0;
	 huf_comp_sch_update.tlv_seq_num <= 0;
	 huf_comp_sch_update.valid <= 0;
	 huf_comp_stats.byte_0_stb <= 0;
	 huf_comp_stats.byte_1_stb <= 0;
	 huf_comp_stats.byte_2_stb <= 0;
	 huf_comp_stats.byte_3_stb <= 0;
	 huf_comp_stats.byte_4_stb <= 0;
	 huf_comp_stats.byte_5_stb <= 0;
	 huf_comp_stats.byte_6_stb <= 0;
	 huf_comp_stats.byte_7_stb <= 0;
	 huf_comp_stats.chu4_cmd_stb <= 0;
	 huf_comp_stats.chu4_frm_enc_stb <= 0;
	 huf_comp_stats.chu4_frm_long_pre_stb <= 0;
	 huf_comp_stats.chu4_frm_long_ret_stb <= 0;
	 huf_comp_stats.chu4_frm_long_sim_stb <= 0;
	 huf_comp_stats.chu4_frm_raw_stb <= 0;
	 huf_comp_stats.chu4_frm_shrt_pre_stb <= 0;
	 huf_comp_stats.chu4_frm_shrt_ret_stb <= 0;
	 huf_comp_stats.chu4_frm_shrt_sim_stb <= 0;
	 huf_comp_stats.chu8_cmd_stb <= 0;
	 huf_comp_stats.chu8_frm_enc_stb <= 0;
	 huf_comp_stats.chu8_frm_long_pre_stb <= 0;
	 huf_comp_stats.chu8_frm_long_ret_stb <= 0;
	 huf_comp_stats.chu8_frm_long_sim_stb <= 0;
	 huf_comp_stats.chu8_frm_raw_stb <= 0;
	 huf_comp_stats.chu8_frm_shrt_pre_stb <= 0;
	 huf_comp_stats.chu8_frm_shrt_ret_stb <= 0;
	 huf_comp_stats.chu8_frm_shrt_sim_stb <= 0;
	 huf_comp_stats.df_blk_enc_stb <= 0;
	 huf_comp_stats.df_blk_long_ret_stb <= 0;
	 huf_comp_stats.df_blk_long_sim_stb <= 0;
	 huf_comp_stats.df_blk_raw_stb <= 0;
	 huf_comp_stats.df_blk_shrt_ret_stb <= 0;
	 huf_comp_stats.df_blk_shrt_sim_stb <= 0;
	 huf_comp_stats.df_frm_stb <= 0;
	 huf_comp_stats.encrypt_stall_stb <= 0;
	 huf_comp_stats.long_map_err_stb <= 0;
	 huf_comp_stats.pass_thru_frm_stb <= 0;
	 huf_comp_stats.shrt_map_err_stb <= 0;
	 huf_comp_stats.xp10_blk_enc_stb <= 0;
	 huf_comp_stats.xp10_blk_long_pre_stb <= 0;
	 huf_comp_stats.xp10_blk_long_ret_stb <= 0;
	 huf_comp_stats.xp10_blk_long_sim_stb <= 0;
	 huf_comp_stats.xp10_blk_raw_stb <= 0;
	 huf_comp_stats.xp10_blk_shrt_pre_stb <= 0;
	 huf_comp_stats.xp10_blk_shrt_ret_stb <= 0;
	 huf_comp_stats.xp10_blk_shrt_sim_stb <= 0;
	 huf_comp_stats.xp10_frm_stb <= 0;
	 huf_comp_stats.xp9_blk_enc_stb <= 0;
	 huf_comp_stats.xp9_blk_long_ret_stb <= 0;
	 huf_comp_stats.xp9_blk_long_sim_stb <= 0;
	 huf_comp_stats.xp9_blk_shrt_ret_stb <= 0;
	 huf_comp_stats.xp9_blk_shrt_sim_stb <= 0;
	 huf_comp_stats.xp9_frm_raw_stb <= 0;
	 huf_comp_stats.xp9_frm_stb <= 0;
	 is_mtf_hdr_last_ptr <= 0;
	 long_size_min <= 0;
	 long_st_remain_reg <= 0;
	 long_st_remain_size_reg <= 0;
	 long_st_words_reg <= 0;
	 long_stcl_remain_reg <= 0;
	 long_stcl_remain_size_reg <= 0;
	 long_stcl_words_reg <= 0;
	 lut_sa_long_data_val_reg <= 0;
	 lut_sa_long_intf_reg <= 0;
	 lut_sa_long_rd_data_rd <= 0;
	 lut_sa_long_st_stcl_val_reg <= 0;
	 lut_sa_short_data_val_reg <= 0;
	 lut_sa_short_intf_reg <= 0;
	 lut_sa_short_st_stcl_val_reg <= 0;
	 lut_sa_shrt_rd_data_rd <= 0;
	 lz77_rd_done <= 0;
	 lz77_wr_done <= 0;
	 mtf_hdr_reg <= 0;
	 mtf_hdr_size_reg <= 0;
	 mtf_hdr_size_reg_0 <= 0;
	 mtf_present <= 0;
	 out_raw_sel_reg <= 0;
	 out_size_bits_chu <= 0;
	 out_size_bits_reg <= 0;
	 out_size_bits_reg_0 <= 0;
	 out_size_bytes_reg <= 0;
	 out_size_cmp_reg <= 0;
	 pack_accum_in <= 0;
	 pack_accum_in_size <= 0;
	 pack_accum_out_size_df <= 0;
	 pack_data_in_reg <= 0;
	 pack_data_in_size_reg <= 0;
	 pack_data_out_cnt_reg <= 0;
	 pack_data_out_idx <= 0;
	 pack_data_out_reg <= 0;
	 pfx_cnt <= 0;
	 pfx_phd_word0_len <= 0;
	 prefix_crc_error <= 0;
	 prefix_present <= 0;
	 prehfd_crc_error <= 0;
	 raw_byte_count <= 0;
	 raw_fifo_rd <= 0;
	 rd_hdr_word_cnt <= 0;
	 reconstruct_chu_flush_reg <= 0;
	 reconstruct_en_reg <= 0;
	 sa_bip2_reg <= 0;
	 sa_lut_long_intf.data_addr0 <= 0;
	 sa_lut_long_intf.data_addr1 <= 0;
	 sa_lut_long_intf.data_addr2 <= 0;
	 sa_lut_long_intf.data_addr3 <= 0;
	 sa_lut_long_intf.data_rd <= 0;
	 sa_lut_long_intf.ret_ack <= 0;
	 sa_lut_long_intf.ret_st_addr <= 0;
	 sa_lut_long_intf.ret_st_rd <= 0;
	 sa_lut_long_intf.ret_stcl_addr <= 0;
	 sa_lut_long_intf.ret_stcl_rd <= 0;
	 sa_lut_long_intf.seq_id <= 0;
	 sa_lut_short_intf.data_addr0 <= 0;
	 sa_lut_short_intf.data_addr1 <= 0;
	 sa_lut_short_intf.data_addr2 <= 0;
	 sa_lut_short_intf.data_addr3 <= 0;
	 sa_lut_short_intf.data_rd <= 0;
	 sa_lut_short_intf.ret_ack <= 0;
	 sa_lut_short_intf.ret_st_addr <= 0;
	 sa_lut_short_intf.ret_st_rd <= 0;
	 sa_lut_short_intf.ret_stcl_addr <= 0;
	 sa_lut_short_intf.ret_stcl_rd <= 0;
	 sa_lut_short_intf.seq_id <= 0;
	 sa_sm_intf.seq_id <= 0;
	 sa_sm_intf.vld <= 0;
	 sa_st1_long_read_done <= 0;
	 sa_st1_short_read_done <= 0;
	 sa_st2_long_read_done <= 0;
	 sa_st2_short_read_done <= 0;
	 sch_last <= 0;
	 sdd_mtf_dp_bus <= 0;
	 sdd_mtf_dp_bus.framing <= 0;
	 sdd_mtf_dp_valid <= 0;
	 send_raw_eob <= 0;
	 send_raw_eob_reg <= 0;
	 seq_id <= 0;
	 seq_id_intf <= 0;
	 seq_id_vld <= 0;
	 shrt_size_min <= 0;
	 shrt_st_remain_reg <= 0;
	 shrt_st_remain_size_reg <= 0;
	 shrt_st_words_reg <= 0;
	 shrt_stcl_remain_reg <= 0;
	 shrt_stcl_remain_size_reg <= 0;
	 shrt_stcl_words_reg <= 0;
	 st_long_err_reg <= 0;
	 st_long_sel_reg <= 0;
	 st_long_size_rdy_reg <= 0;
	 st_long_tabl_rdy_reg <= 0;
	 st_shrt_err_reg <= 0;
	 st_shrt_sel_reg <= 0;
	 st_shrt_size_rdy_reg <= 0;
	 st_shrt_tabl_rdy_reg <= 0;
	 stat_update <= 0;
	 su_ready_reg <= 0;
	 sym_map_error <= 0;
	 symbol_holding_fifo_wr_data <= 0;
	 symbol_tbl_size_reg <= 0;
	 term_rd <= 0;
	 tlvp_out_rd <= 0;
	 trace <= 0;
	 usr_full_reg <= 0;
	 usr_wr <= 0;
	 wr_hdr_word_cnt <= 0;
	 wr_more <= 0;
	 xp10_crc_32 <= 0;
	 xp10_raw <= 0;
	 xp10_user_prefix_size <= 0;
	 xp9_raw <= 0;
	 
      end
      else begin
	 state_reg                        <= state;
	 sa_bip2_reg                      <= crc_error;
	 pack_accum_out_size_df           <= pack_accum_out_size_df_pre;
	 usr_full_reg                     <= usr_full;
	 huf_comp_stats                   <= 0;
	 huf_comp_stats.byte_0_stb        <= byte_0_stb;
	 huf_comp_stats.byte_1_stb        <= byte_1_stb;
	 huf_comp_stats.byte_2_stb        <= byte_2_stb;
	 huf_comp_stats.byte_3_stb        <= byte_3_stb;
	 huf_comp_stats.byte_4_stb        <= byte_4_stb;
	 huf_comp_stats.byte_5_stb        <= byte_5_stb;
	 huf_comp_stats.byte_6_stb        <= byte_6_stb;
	 huf_comp_stats.byte_7_stb        <= byte_7_stb;
	 huf_comp_stats.encrypt_stall_stb <= usr_full & ~usr_full_reg;
	 
	 su_ready_reg                   <= su_ready;
	 huf_comp_sch_update.valid      <= 0;
	 sa_lut_long_intf.ret_ack       <= 0;
	 sa_lut_short_intf.ret_ack      <= 0;
	 sa_st1_long_read_done          <= 0;
	 sa_st1_short_read_done         <= 0;
	 sa_st2_long_read_done          <= 0;
	 sa_st2_short_read_done         <= 0;
	 sa_sm_intf.vld                 <= 0;
	 term_rd                        <= 0;
	 sdd_mtf_dp_valid               <= 0;
	 usr_wr                         <= 0;
	 tlvp_out_rd                    <= 0;
	 lut_sa_long_rd_data_rd         <= 0;
	 lut_sa_shrt_rd_data_rd         <= 0;
	 hold_symb_fifo_wr              <= 0;
	 hold_symb_fifo_rd              <= 0;
	 enc_fifo_rd                    <= 0;
	 raw_fifo_rd                    <= 0;
	 sa_lut_long_intf.ret_stcl_rd   <= 0;
	 sa_lut_long_intf.ret_st_rd     <= 0;
	 sa_lut_long_intf.data_rd       <= 0;
	 sa_lut_short_intf.ret_stcl_rd  <= 0;
	 sa_lut_short_intf.ret_st_rd    <= 0;
	 sa_lut_short_intf.data_rd      <= 0;     
	 pack_data_out_reg              <= pack_data_out;
	 lut_sa_long_intf_reg           <= lut_sa_long_intf;
	 lut_sa_short_intf_reg          <= lut_sa_short_intf; 
	 lut_sa_long_data_val_reg       <= lut_sa_long_data_val;
	 lut_sa_long_st_stcl_val_reg    <= lut_sa_long_st_stcl_val;	
	 lut_sa_short_data_val_reg      <= lut_sa_short_data_val;
	 lut_sa_short_st_stcl_val_reg   <= lut_sa_short_st_stcl_val;
	 seq_id_vld                     <= seq_id_intf_array_vld[seq_id]; 
	 if  (!compound_cmd)
	   seq_id_intf                  <= seq_id_intf_array[seq_id];     
	 shrt_size_min                  <= shrt_size_min_comb;
	 long_size_min                  <= long_size_min_comb;
	 if (!deflate) begin
	    shrt_sel                    <= shrt_sel_comb;
	    long_sel                    <= long_sel_comb;
	 end
	 else begin
	    if (df_sim_sel) begin
	       shrt_sel                 <= SIM;
	       long_sel                 <= SIM;
	    end
	    else begin
	       shrt_sel                 <= RET;
	       long_sel                 <= RET;
	    end
	 end 
	 send_raw_eob_reg               <= send_raw_eob;
	 if (send_raw_eob_reg) begin
	    send_raw_eob                <= 0;
	    send_raw_eob_reg            <= 0;
	    sdd_mtf_dp_bus              <= 0;
	    sdd_mtf_dp_bus.framing      <= 4'h8;
	    sdd_mtf_dp_valid            <= 1'd1;
	 end
			  
	 long_stcl_remain_size_reg      <= long_stcl_remain_size;
	 long_stcl_remain_reg           <= long_stcl_remain;
	 shrt_stcl_remain_size_reg      <= shrt_stcl_remain_size;
	 shrt_stcl_remain_reg           <= shrt_stcl_remain;
	 long_st_remain_size_reg        <= long_st_remain_size;
	 long_st_remain_reg             <= long_st_remain;
	 shrt_st_remain_size_reg        <= shrt_st_remain_size;
	 shrt_st_remain_reg             <= shrt_st_remain;
	 symbol_tbl_size_reg            <= symbol_tbl_size[12:0];
	 out_raw_sel_reg                <= out_raw_sel | xp9_raw;
	 long_stcl_words_reg            <= long_stcl_words;
	 long_st_words_reg              <= long_st_words;
	 shrt_stcl_words_reg            <= shrt_stcl_words;
	 shrt_st_words_reg              <= shrt_st_words;
	 st_long_size_rdy_reg           <= {st_long_size_rdy_reg[4:0], st_long_size_rdy};
	 st_shrt_size_rdy_reg           <= {st_shrt_size_rdy_reg[4:0], st_shrt_size_rdy};
	 st_long_tabl_rdy_reg           <= {st_long_tabl_rdy_reg[3:0], st_long_tabl_rdy};
	 st_shrt_tabl_rdy_reg           <= {st_shrt_tabl_rdy_reg[3:0], st_shrt_tabl_rdy};
         byte_pad                       <= byte_pad_msk;
	 raw_byte_count                 <= raw_byte_count_nxt;
	 out_size_bits_reg_0            <= out_size_bits;
	 mtf_hdr_size_reg_0             <= mtf_hdr_size;
	 if (st_shrt_size_rdy_reg[0] && !st_shrt_size_rdy_reg[1]) begin
	    st_shrt_sel_reg                   <= st_shrt_sel;
	    st_shrt_err_reg                   <= st_shrt_err;
	 end
	 if (st_long_size_rdy_reg[0] && !st_long_size_rdy_reg[1]) begin
	    st_long_sel_reg                   <= st_long_sel;
	    st_long_err_reg                   <= st_long_err;
	 end
	 if (ecc_error)
	   ecc_error_reg                <= 1;
	 
	 fhp_lz_prefix_hdr_bus.trace_bit <= trace;
	 
	 
	 bhp_mtf_hdr_valid              <= 1'd0;
	 fhp_lz_prefix_hdr_valid        <= 1'b0;
	 fhp_lz_prefix_dp_bus.data      <= '0;
         fhp_lz_prefix_dp_bus.last      <= 1'b0;
         fhp_lz_prefix_valid            <= 1'b0;
	 stat_update                    <= 1'b0;
	 if (sa_sm_intf.vld) begin
	    sa_lut_long_intf.seq_id  <= seq_id;
	    sa_lut_short_intf.seq_id <= seq_id;
	 end
         if (fhp_lz_prefix_hdr_valid)
           prefix_present                     <= 1'b0;
	 if (stat_update) begin
	    out_size_bytes_reg                <= out_size_bytes;
	    out_size_cmp_reg                  <= out_size_cmp;
	    huf_comp_sch_update.valid         <= 1;
	    huf_comp_sch_update.basis         <= seq_id_intf.raw_byte_count;
	    huf_comp_sch_update.bytes_in      <= seq_id_intf.raw_byte_count;
	    if (((seq_id_intf.blk_count == 0) || chu_mode) && (seq_id_intf.xp10_prefix_mode == PREDET_HUFF) && (xp10_user_prefix_size != 0)) begin
	       if (sw_prefix_adj == 1)
		 huf_comp_sch_update.bytes_in <= seq_id_intf.raw_byte_count+256; 
	       if (sw_prefix_adj == 2)
		 huf_comp_sch_update.bytes_in <= seq_id_intf.raw_byte_count+512; 
	    end
	    if ((seq_id_intf.blk_count == 0) && (seq_id_intf.xp10_prefix_mode == USER_PREFIX)) begin
	       huf_comp_sch_update.bytes_in   <= seq_id_intf.raw_byte_count+{pfx_phd_word0_len,3'b000}+8; 
	       huf_comp_sch_update.basis      <= seq_id_intf.raw_byte_count+{pfx_phd_word0_len,3'b000}+8; 
	    end
	    huf_comp_sch_update.bytes_out     <= sch_byte_count;
	    frm_bit_count_raw_adder           <= frm_bit_count_raw_adder_pre;
	 end
	 
	 case (state)
	   SA_IDLE: begin
	      if (xfer_rdy) begin
		 ecc_error_reg            <= 0;
		 prehfd_crc_error         <= 0;
		 prefix_crc_error         <= 0;
		 sym_map_error            <= 0;
		 xp9_raw                  <= 0;
		 frm_bit_count            <= 0;
		 first_xfer_done          <= 0;
		 pack_accum_in            <= 0;
		 pack_accum_in_size       <= 0;
		 xp10_user_prefix_size    <= 0;
		 state                    <= SA_FRM_IDL;
		 seq_id                   <= term_tlv.tuser[5:2]; 
		 sa_lut_long_intf.seq_id  <= term_tlv.tuser[5:2]; 
		 sa_lut_short_intf.seq_id <= term_tlv.tuser[5:2];
		 pfx_phd_word0_len        <= 0;
		 compress_sel_last        <= 1;
	      end
	   end
	   
	   SA_FRM_IDL: begin
	      st_long_tabl_rdy_reg                       <= 0;
	      st_shrt_tabl_rdy_reg                       <= 0;
	      if (xfer_rdy && (term_tlv.typen != LZ77) && !term_rd) begin
		 term_rd                                 <= 1;
		 usr_wr                                  <= 1;
	      end
	      if (xfer_rdy) begin
		 if (term_tlv.typen == LZ77) begin
		    if (seq_id_vld && (deflate || st_long_size_rdy_reg[5]) && st_shrt_size_rdy_reg[5] && su_ready_reg) begin
		       prehfd_crc_error                     <= seq_id_intf.pdh_crc_err;
		       huf_comp_sch_update.last             <= sch_last & seq_id_intf.blk_last & ~cipher_pad;
		       cipher_last                          <= sch_last & seq_id_intf.blk_last &  cipher_pad;
		       if (!first_xfer_done) begin
			  huf_comp_sch_update.tlv_frame_num <= tlv_data_word_0.tlv_frame_num;
			  huf_comp_sch_update.tlv_seq_num   <= tlv_data_word_0.tlv_seq_num;
			  huf_comp_sch_update.tlv_eng_id    <= tlv_data_word_0.tlv_eng_id;
			  huf_comp_sch_update.last          <= tlv_data_word_0.last_of_command & seq_id_intf.blk_last & ~cipher_pad;
			  cipher_last                       <= tlv_data_word_0.last_of_command & seq_id_intf.blk_last &  cipher_pad;
			  sch_last                          <= tlv_data_word_0.last_of_command;
		       end 	
		       flush_done                        <= 0;
		       first_xfer_done                   <= 1;
		       term_rd                           <= ~first_xfer_done;
		       usr_wr                            <= ~first_xfer_done;
		       stat_update                       <=  first_xfer_done;
		       rd_hdr_word_cnt                   <= 0;
		       wr_hdr_word_cnt                   <= 0;
		       crc_data                          <= 0;
		       xp10_crc_32                       <= {32{1'b1}};
		       if (!first_xfer_done) begin
			  pack_accum_in                  <= 0;
			  pack_accum_in_size             <= 0;
		       end
		       sa_lut_long_intf.seq_id           <= seq_id;
		       sa_lut_short_intf.seq_id          <= seq_id;
		       
		       if (!first_xfer_done) begin
			  reconstruct_en_reg                     <= reconstruct_en;
			  reconstruct_chu_flush_reg              <= reconstruct_chu_flush;
			  fhp_lz_prefix_hdr_valid                <= reconstruct_en || reconstruct_chu_flush;
			  if (prefix_present) begin
			     if (pfx_phd_word0_len <= (`CR_PFX_SIZE)/8) 
			       fhp_lz_prefix_hdr_bus.prefix_type <= 1'b0;
			     else
			       fhp_lz_prefix_hdr_bus.prefix_type <= 1'b1;
			     fhp_lz_prefix_hdr_bus.data_sz       <= (pfx_phd_word0_len)/'d128; 
			  end
			  else begin
			     fhp_lz_prefix_hdr_bus.data_sz       <= '0;
			     fhp_lz_prefix_hdr_bus.prefix_type   <= '0;
			  end
		       end
		       if (reconstruct_chu_flush) begin
			  reconstruct_chu_flush_reg              <= 1;
			  reconstruct_en_reg                     <= 0;
		       end
		       
		       if (seq_id_intf.blk_count == 0) begin
			  is_mtf_hdr_last_ptr            <= 0;
		       end
		       mtf_hdr_size_reg                  <= mtf_hdr_size_reg_0;
		       mtf_hdr_reg                       <= mtf_hdr;
		       bhp_mtf_hdr_bus                   <= bhp_mtf_hdr_bus_nxt;
		       out_size_bits_reg                 <= out_size_bits_reg_0;  
		      
		       if (seq_id_intf.comp_mode == XP10) begin
			  out_size_bits_reg              <= out_size_bits_reg_0 + 32; 
			  if (!out_raw_sel_reg && !compress_sel_last) begin
			     mtf_present                 <= 1;
			  end
			  else begin
			     mtf_present                 <= 0;
			     mtf_hdr_size_reg            <= 0;
			     mtf_hdr_reg                 <= 0;
			     if (!out_raw_sel_reg)
			       out_size_bits_reg         <= out_size_bits_reg_0 + 32 - mtf_hdr_size_reg_0; 
			     else
			       out_size_bits_reg         <= out_size_bits_reg_0 + 32;
			  end
		       end
		       if (chu_mode) begin
			  frm_bit_count                  <= 0;
			  mtf_present                    <= 0;
			  mtf_hdr_size_reg               <= 0;
			  mtf_hdr_reg                    <= 0;
			  if (!out_raw_sel_reg) begin
			     out_size_bits_reg           <= out_size_bits_reg_0 + 24 - mtf_hdr_size_reg_0; 
			     out_size_bits_chu           <= out_size_bits_reg_0      - mtf_hdr_size_reg_0; 
			  end
			  else begin
			     out_size_bits_reg           <= out_size_bits_reg_0 + 24;           
			     
			     out_size_bits_chu           <= out_size_bits_reg_0 & 28'h000_fff8; 
			     
			  end
		       end
			     
		       if (first_xfer_done) begin
			  if (reconstruct_en)
			    bhp_mtf_hdr_valid                        <= 1;
			  if (reconstruct_en_reg)
			    bhp_mtf_hdr_valid                        <= 1;
			  if (reconstruct_chu_flush)
			    bhp_mtf_hdr_valid                        <= 1;
			  if (reconstruct_chu_flush_reg)
			    bhp_mtf_hdr_valid                        <= 1;
			  if (reconstruct_chu_flush) begin
			     send_raw_eob                            <= 1;
			     sdd_mtf_dp_bus                          <= 0;
			     sdd_mtf_dp_bus.framing                  <= 4'hf;
			     sdd_mtf_dp_valid                        <= 1'd1;
			  end
			  if ((seq_id_intf.comp_mode == ZLIB) || (seq_id_intf.comp_mode == GZIP)) begin
			     mtf_present                             <=  0;
			     huf_comp_stats.df_blk_enc_stb           <= ~out_raw_sel_reg;
			     huf_comp_stats.df_blk_raw_stb           <=  out_raw_sel_reg;
			     huf_comp_stats.df_blk_shrt_sim_stb      <= ~out_raw_sel_reg & (shrt_sel == SIM);
			     huf_comp_stats.df_blk_long_sim_stb      <= ~out_raw_sel_reg & (long_sel == SIM);
			     huf_comp_stats.df_blk_shrt_ret_stb      <= ~out_raw_sel_reg & (shrt_sel == RET);
			     huf_comp_stats.df_blk_long_ret_stb      <= ~out_raw_sel_reg & (long_sel == RET);
			     huf_comp_stats.df_frm_stb               <=  seq_id_intf.blk_count == 0;
			     sa_st1_short_read_done                  <= ~st_shrt_sel_reg & out_raw_sel_reg;
			     sa_st2_short_read_done                  <=  st_shrt_sel_reg & out_raw_sel_reg;
			     eob_raw_done                            <=  0;
			     eot_raw_done                            <=  0;
			     byte_pad_df                             <=  byte_pad_df_pre[2:0];
			     state                                   <=  SA_DF_HDR;
			  end
			  else if (out_raw_sel_reg && (seq_id_intf.comp_mode == XP9)) begin
			     sa_st1_long_read_done                   <= ~st_long_sel_reg;
			     sa_st1_short_read_done                  <= ~st_shrt_sel_reg;
			     sa_st2_long_read_done                   <=  st_long_sel_reg;
			     sa_st2_short_read_done                  <=  st_shrt_sel_reg;
			     xp9_raw                                 <=  1;
			     first_xfer_done                         <=  0;
			     eob_raw_done                            <=  0;
			     eot_raw_done                            <=  0;
			     huf_comp_stats.xp9_frm_raw_stb          <=  seq_id_intf.blk_count == 0;
			     huf_comp_stats.xp9_frm_stb              <=  seq_id_intf.blk_count == 0;
			     state                                   <=  SA_RAW;
			  end
			  else if (out_raw_sel_reg) begin
			     sa_st1_long_read_done                   <= ~st_long_sel_reg;
			     sa_st1_short_read_done                  <= ~st_shrt_sel_reg;
			     sa_st2_long_read_done                   <=  st_long_sel_reg;
			     sa_st2_short_read_done                  <=  st_shrt_sel_reg;
			     first_xfer_done                         <=  0;
			     eob_raw_done                            <=  0;
			     eot_raw_done                            <=  0;
			     xp10_raw                                <=  1;
			     compress_sel_last                       <=  0;
			     huf_comp_stats.xp10_blk_raw_stb         <=  (seq_id_intf.comp_mode == XP10);
			     huf_comp_stats.xp10_frm_stb             <=  (seq_id_intf.comp_mode == XP10)  & seq_id_intf.blk_count == 0;
			     huf_comp_stats.chu8_frm_raw_stb         <=  (seq_id_intf.comp_mode == CHU8K);
			     huf_comp_stats.chu8_cmd_stb             <=  (seq_id_intf.comp_mode == CHU8K) & seq_id_intf.blk_count == 0;
			     huf_comp_stats.chu4_frm_raw_stb         <=  (seq_id_intf.comp_mode == CHU4K);
			     huf_comp_stats.chu4_cmd_stb             <=  (seq_id_intf.comp_mode == CHU4K) & seq_id_intf.blk_count == 0;
			     state                                   <=  SA_XP_HDR;
			  end
			  else begin
			     if (seq_id_intf.comp_mode == XP9)
			       bhp_mtf_hdr_valid                     <=  0;
			     eob_raw_done                            <=  0;
			     eot_raw_done                            <=  0;
			     huf_comp_stats.xp9_frm_stb              <=  (seq_id_intf.comp_mode == XP9)   & seq_id_intf.blk_count == 0;
			     huf_comp_stats.xp9_blk_enc_stb          <=  (seq_id_intf.comp_mode == XP9);
			     huf_comp_stats.xp9_blk_shrt_sim_stb     <=  (seq_id_intf.comp_mode == XP9)   & (shrt_sel == SIM);
			     huf_comp_stats.xp9_blk_long_sim_stb     <=  (seq_id_intf.comp_mode == XP9)   & (long_sel == SIM);
			     huf_comp_stats.xp9_blk_shrt_ret_stb     <=  (seq_id_intf.comp_mode == XP9)   & (shrt_sel == RET);
			     huf_comp_stats.xp9_blk_long_ret_stb     <=  (seq_id_intf.comp_mode == XP9)   & (long_sel == RET);			     
			     huf_comp_stats.xp10_blk_shrt_sim_stb    <=  (seq_id_intf.comp_mode == XP10)  & (shrt_sel == SIM);
			     huf_comp_stats.xp10_blk_long_sim_stb    <=  (seq_id_intf.comp_mode == XP10)  & (long_sel == SIM);
			     huf_comp_stats.xp10_blk_shrt_ret_stb    <=  (seq_id_intf.comp_mode == XP10)  & (shrt_sel == RET);
			     huf_comp_stats.xp10_blk_long_ret_stb    <=  (seq_id_intf.comp_mode == XP10)  & (long_sel == RET);
			     huf_comp_stats.xp10_blk_shrt_pre_stb    <=  (seq_id_intf.comp_mode == XP10)  & (shrt_sel == PRE);
			     huf_comp_stats.xp10_blk_long_pre_stb    <=  (seq_id_intf.comp_mode == XP10)  & (long_sel == PRE);
			     huf_comp_stats.xp10_blk_enc_stb         <=  (seq_id_intf.comp_mode == XP10);
			     huf_comp_stats.xp10_frm_stb             <=  (seq_id_intf.comp_mode == XP10)  & seq_id_intf.blk_count == 0;
			     huf_comp_stats.chu8_frm_enc_stb         <=  (seq_id_intf.comp_mode == CHU8K);
			     huf_comp_stats.chu8_cmd_stb             <=  (seq_id_intf.comp_mode == CHU8K) & seq_id_intf.blk_count == 0;
			     huf_comp_stats.chu8_frm_shrt_sim_stb    <=  (seq_id_intf.comp_mode == CHU8K) & (shrt_sel == SIM);
			     huf_comp_stats.chu8_frm_long_sim_stb    <=  (seq_id_intf.comp_mode == CHU8K) & (long_sel == SIM);
			     huf_comp_stats.chu8_frm_shrt_ret_stb    <=  (seq_id_intf.comp_mode == CHU8K) & (shrt_sel == RET);
			     huf_comp_stats.chu8_frm_long_ret_stb    <=  (seq_id_intf.comp_mode == CHU8K) & (long_sel == RET);
			     huf_comp_stats.chu8_frm_shrt_pre_stb    <=  (seq_id_intf.comp_mode == CHU8K) & (shrt_sel == PRE);
			     huf_comp_stats.chu8_frm_long_pre_stb    <=  (seq_id_intf.comp_mode == CHU8K) & (long_sel == PRE);
			     huf_comp_stats.chu4_frm_enc_stb         <=  (seq_id_intf.comp_mode == CHU4K);
			     huf_comp_stats.chu4_cmd_stb             <=  (seq_id_intf.comp_mode == CHU4K) & seq_id_intf.blk_count == 0;
			     huf_comp_stats.chu4_frm_shrt_sim_stb    <=  (seq_id_intf.comp_mode == CHU4K) & (shrt_sel == SIM);
			     huf_comp_stats.chu4_frm_long_sim_stb    <=  (seq_id_intf.comp_mode == CHU4K) & (long_sel == SIM);
			     huf_comp_stats.chu4_frm_shrt_ret_stb    <=  (seq_id_intf.comp_mode == CHU4K) & (shrt_sel == RET);
			     huf_comp_stats.chu4_frm_long_ret_stb    <=  (seq_id_intf.comp_mode == CHU4K) & (long_sel == RET);
			     huf_comp_stats.chu4_frm_shrt_pre_stb    <=  (seq_id_intf.comp_mode == CHU4K) & (shrt_sel == PRE);
			     huf_comp_stats.chu4_frm_long_pre_stb    <=  (seq_id_intf.comp_mode == CHU4K) & (long_sel == PRE);
			     huf_comp_stats.chu4_frm_enc_stb         <=  (seq_id_intf.comp_mode == CHU4K);
			     huf_comp_stats.chu4_cmd_stb             <=  (seq_id_intf.comp_mode == CHU4K) & seq_id_intf.blk_count == 0;			     
			     compress_sel_last                       <=  1;
			     state                                   <=  SA_XP_HDR;
			  end
		       end
		       else begin
			  state                                      <=  SA_FRM_IDL;
		       end 
		    end 
		 end 
		 else if (term_tlv.typen == DATA_UNK) begin
		    if (st_shrt_size_rdy_reg[3] && st_long_size_rdy_reg[3]) begin
		       huf_comp_stats.pass_thru_frm_stb  <= 1;
		       raw_byte_count                    <= 0;
		       huf_comp_sch_update.tlv_frame_num <= tlv_data_word_0.tlv_frame_num;
		       huf_comp_sch_update.tlv_seq_num   <= tlv_data_word_0.tlv_seq_num;
		       huf_comp_sch_update.tlv_eng_id    <= tlv_data_word_0.tlv_eng_id;
		       sch_last                          <= tlv_data_word_0.last_of_command;
		       cipher_last                       <= 0;
		       st_long_sel_reg                   <= st_long_sel;
		       st_shrt_sel_reg                   <= st_shrt_sel;
		       state                             <= SA_DATA;
		    end
		    else begin
		       term_rd                           <= 0;
		       usr_wr                            <= 0;
		       state                             <= SA_FRM_IDL;
		    end 
		 end 
		 else if (term_tlv.typen == PFD) begin
		    xp10_user_prefix_size                <= tlv_pfd_word0.xp10_prefix_sel;           
		    if (tlv_pfd_word0.prefix_src)
		      pfx_phd_word0_len                  <= (((tlv_pfd_word0.xp10_prefix_sel*1024)+1024)/8) ;
		    else
		      pfx_phd_word0_len                  <= (1024/8);                                        
		    prefix_present                       <= 1'b1;
		    flush_done                           <= 0;
		    fhp_lz_prefix_dp_bus.prefix_type     <= tlv_pfd_word0.prefix_src;   
		    pfx_cnt                              <= '0;
		    xp10_crc_32                          <= 32'hffff_ffff;
		    state                                <= SA_PFD;
		 end 
		 else if (term_tlv.typen == FRMD_USER_NULL) begin
		    if (term_rd) begin
		       term_rd                           <= 0;
		       usr_wr                            <= 0;
		    end
		    state                                <= SA_FRM_IDL;
		 end
		 else if (!term_tlv.tuser[1])begin
		    rd_hdr_word_cnt                      <= 0;
		    state                                <= SA_OTHR;   
		 end
		 else begin
		    state                                <= SA_FRM_IDL;
		 end
	      end
	   end
	  
	   
	   SA_DATA: begin
	      if (xfer_rdy && su_ready_reg) begin
		 term_rd                             <= 1;
		 usr_wr                              <= 1;
	      end
	      if (term_rd) begin
		 if (raw_byte_count_nxt == 8192) begin
		    frm_bit_count                    <= frm_bit_count + 65536;  
		    raw_byte_count                   <= 0;
		    huf_comp_sch_update.valid        <= 1;
		    huf_comp_sch_update.last         <= 0;
		    huf_comp_sch_update.bytes_in     <= 24'd8192;
		    huf_comp_sch_update.basis        <= 24'd8192;
		    huf_comp_sch_update.bytes_out    <= 24'd8192;
		 end
		 if (term_tlv.tuser[1]) begin
		    huf_comp_sch_update.valid        <= 1;
		    huf_comp_sch_update.last         <= sch_last;
		    if (cipher_pad) begin
		       huf_comp_sch_update.bytes_in  <= raw_byte_count_nxt;
		       huf_comp_sch_update.basis     <= raw_byte_count_nxt;
		       huf_comp_sch_update.bytes_out <= raw_byte_count_nxt  + (16 - raw_byte_count_nxt[3:0]);   
		       frm_bit_count                 <= frm_byte_count_cipher_nxt << 3;                         
		       if (!compound_cmd)
			 cipher_pad                  <= 0;
		    end
		    else begin
		       huf_comp_sch_update.bytes_in  <= raw_byte_count_nxt;
		       huf_comp_sch_update.basis     <= raw_byte_count_nxt;
		       huf_comp_sch_update.bytes_out <= raw_byte_count_nxt;
		       frm_bit_count                 <= frm_bit_count_nxt;
		    end
		    comp_mode_lst.comp_mode          <= NONE;
		    comp_mode_lst.xp10_crc           <= seq_id_intf.xp10_crc_mode;
		    sa_sm_intf.vld                   <= 1;
		    sa_sm_intf.seq_id                <= seq_id;
		    sa_lut_long_intf.ret_ack         <= 1;
		    sa_lut_short_intf.ret_ack        <= 1;
		    sa_st1_long_read_done            <= ~st_long_sel_reg;
		    sa_st1_short_read_done           <= ~st_shrt_sel_reg;
		    sa_st2_long_read_done            <=  st_long_sel_reg;
		    sa_st2_short_read_done           <=  st_shrt_sel_reg;
		    term_rd                          <= 0;
		    usr_wr                           <= 0;
		    state                            <= SA_FRM_IDL;
		 end
	      end 
	   end 
	   
	   SA_PFD: begin
	      if (xfer_rdy) begin
		 term_rd                         <= 1;
		 usr_wr                          <= 1;
	      end
	      if (term_rd && !term_tlv.tuser[0]) begin
		 xp10_crc_32                        <= crc32_xp(term_tlv.tdata, xp10_crc_32, 64); 
		 if (pfx_cnt < (pfx_phd_word0_len)) begin
		    pfx_cnt                         <= pfx_cnt + 1;
		    fhp_lz_prefix_dp_bus.data       <= term_tlv.tdata;
		    if (pfx_cnt == (pfx_phd_word0_len -1)) begin
                       fhp_lz_prefix_dp_bus.last    <= 1;
		    end
		    else begin
                       fhp_lz_prefix_dp_bus.last     <= 0;
		    end
		    fhp_lz_prefix_valid              <= 1;
		    fhp_lz_prefix_dp_bus.sof         <= ~flush_done;
		    flush_done                       <= 1;
		 end
		 else begin
		    fhp_lz_prefix_valid              <= 0;
		    if (term_tlv.tuser[1]) begin
		       prefix_crc_error              <= (xp10_crc_32 != ~term_tlv.tdata[31:0]);
		       term_rd                       <= 0;
		       usr_wr                        <= 0;
		       state                         <= SA_FRM_IDL;
		    end
		 end
              end 
	   end
	   
	   
	   SA_RAW: begin
	      if (mtf_sdd_dp_ready_delay && !lz77_rd_done) begin
		 first_xfer_done               <= 1;
		 term_rd                       <= 1;
		 if ((eob && !seq_id_intf.blk_last) || term_tlv.tuser[1]) begin
		    term_rd                    <= ~term_rd;
		    lz77_rd_done               <= 1;
		    eob_raw_done               <= term_tlv.tuser[1];
		    eot_raw_done               <= term_tlv.tuser[1];
		 end
	      end
	      
	      if (!term_rd && lz77_rd_done && mtf_sdd_dp_ready_delay && !eob_raw_done) begin
		 eob_raw_done                  <= 1;
		 sdd_mtf_dp_bus                <= 0;
		 sdd_mtf_dp_bus.framing        <= 4'd8;
		 sdd_mtf_dp_valid              <= 1'd1;
	      end
	      if (term_rd) begin
		 
		 if (lz_symbol_bus.backref_type && deflate) begin
		    sdd_mtf_dp_valid           <= 1'd0;
		 end
		 else begin
		    sdd_mtf_dp_bus             <= lz_symbol_bus;
		    sdd_mtf_dp_valid           <= 1'd1;
		 end 
	      end
	      if (term_rd_masked) begin
		 is_mtf_hdr_last_ptr           <= is_mtf_hdr_last_ptr_nxt;
		 if (lz_symbol_bus.backref) begin
		    for (int i=0; i<4; i++) begin
		       mtf_offset[i]              <= mtf_offset_nxt[i];
		    end
		 end
	      end
	      if (!mtf_sdd_dp_ready_delay) begin
		 sdd_mtf_dp_bus                <= sdd_mtf_dp_bus;
		 sdd_mtf_dp_valid              <= 1'd1;
	      end
	      
	      if (xfer_rdy && raw_fifo_rd_rdy_wait) begin 
		 raw_fifo_rd                    <= 1;
	      end
	      if (raw_fifo_rd) begin
		 pack_accum_in                  <= {151'd0, pack_accum_out};
		 pack_accum_in_size             <= {2'd0,   pack_accum_out_size};
		 usr_wr                         <= 1;
		 if (pack_data_out_cnt == 0) begin
		    usr_wr                      <= 0;
		 end
	      end
	      if (data_out_eot_raw || data_out_eot_raw_reg)
		data_out_eot_raw_reg           <= 1;
	      
	      
	      if (xfer_rdy && (data_out_eot_raw || data_out_eot_raw_reg || data_out_eob_raw)) begin
		 if (raw_fifo_rd_rdy)
		 raw_fifo_rd                   <= 1;
		 
		 frm_bit_count                 <= frm_bit_count + raw_byte_count_nxt*8;     
		 
		 if (seq_id_intf.comp_mode == XP10)
		   frm_bit_count               <= frm_bit_count + raw_byte_count_nxt*8 + 32; 
		 else if (chu_mode)
		   frm_bit_count               <= frm_bit_count + raw_byte_count_nxt*8 + 24; 
		 else if (deflate)
		   frm_bit_count               <= frm_bit_count + raw_byte_count_nxt*8 + frm_bit_count_raw_adder; 
		 df_frm_raw_byte_count         <= df_frm_raw_byte_count_nxt;
		 lz77_rd_done                  <= 0;
		 lz77_wr_done                  <= 0;
		 data_out_eot_raw_reg          <= 0;
		 
		 if (data_out_eot_raw || data_out_eot_raw_reg) begin
		    send_raw_eob               <= 1;
		    state                      <= SA_LZ77_END;
		    for (int i=0; i<4; i++) begin
		       mtf_offset[i]           <= 0;
		    end
		    df_frm_raw_byte_count      <= 0;
		    if ((seq_id_intf.comp_mode == XP9) || chu_mode)
		      if (pack_accum_out_size == 0)
			usr_wr                 <= 0;
		      else begin
			 usr_wr                <= 1;
			 wr_more               <= pack_accum_out_size > 64;
		      end
		    else begin
		       flush_done              <= 0;
		       wr_more                 <= 1;
		       usr_wr                  <= 0;
		    end
		    
		    if (seq_id_intf.comp_mode == XP10)  begin
		       
		       
		       
		       pack_accum_in           <= {151'd0, pack_accum_out}    | (215'd0+(ftr_crc_sel << (byte_pad+pack_accum_out_size)));
		       
		       pack_accum_in_size      <= pack_accum_out_size         +  ftr_crc_size +  byte_pad;
		    end
		    if (seq_id_intf.comp_mode == GZIP) begin
		       
		       
		       pack_accum_in           <= {151'd0, pack_accum_out}      | (215'd0+((ftr_crc_sel               << (byte_pad_msk+pack_accum_out_size   )) | 
											   (df_frm_raw_byte_count_nxt << (byte_pad_msk+pack_accum_out_size+32)))) ;
		       
		       pack_accum_in_size      <= pack_accum_out_size           +  32 + ftr_crc_size + byte_pad_msk;
		    end
		    if (seq_id_intf.comp_mode == ZLIB) begin
		       
		       
		       pack_accum_in           <= {151'd0, pack_accum_out}      | (215'd0+(ftr_crc_sel << (byte_pad_msk+pack_accum_out_size)));
		       
		       pack_accum_in_size      <= pack_accum_out_size           +  ftr_crc_size +  byte_pad_msk;
		    end
		 end
		 
		 else begin
		    seq_id                     <= term_tlv.tuser[5:2]; 
		    state                      <= SA_FRM_IDL;
		    comp_mode_lst.comp_mode    <= seq_id_intf.comp_mode;
		    comp_mode_lst.xp10_crc     <= seq_id_intf.xp10_crc_mode;
		    sa_sm_intf.vld             <= 1;
		    sa_sm_intf.seq_id          <= seq_id;
		    sa_lut_long_intf.ret_ack   <= 1;
		    sa_lut_short_intf.ret_ack  <= 1;
		 end		 
	      end 
	   end 	
      
	    
	   
	   
	   SA_DF_HDR: begin
	      if (!flush_done) begin
		 flush_done <= 1;
	      end
	      else begin
		 if (usr_rdy) begin
		    if (pack_data_out_cnt == 0)
		      usr_wr                             <= 0;
		    else
		      usr_wr                             <= 1;
		    pack_accum_in                        <= {151'd0, pack_accum_out};
		    pack_accum_in_size                   <= {2'd0,   pack_accum_out_size};
		    if (out_raw_sel_reg) begin
		       state                             <= SA_RAW;
		    end
		    else if (shrt_sel == RET) begin
		    state                                <= SA_SHRT_TBL_STCL;
		    end
		    else begin
		       sa_st1_short_read_done            <= ~st_shrt_sel_reg;
		       sa_st2_short_read_done            <=  st_shrt_sel_reg;			  
		       state                             <= SA_LZ77;
		    end
		 end 
	      end
	   end
	   SA_XP_HDR: begin
	      if (usr_rdy) begin
		 
		 if (pack_accum_in_size >= 64) begin
		    usr_wr                         <= 1;
		    pack_accum_in                  <= {151'd0, pack_accum_out};
		    pack_accum_in_size             <= {2'd0,   pack_accum_out_size};
		 end
		 else begin
		    wr_hdr_word_cnt                   <= wr_hdr_word_cnt + 1;
		    crc_data                          <= pack_data_in[63:0]; 
		    if ((wr_hdr_word_cnt == 3) || (wr_hdr_word_cnt == 4)) begin
		       xp10_crc_32                    <= crc32_xp(crc_data, xp10_crc_32, crc_bits_vld); 
		    end
		    else begin
                       usr_wr                         <= 1;
		       wr_hdr_word_cnt                <= wr_hdr_word_cnt + 1;
		       if (wr_hdr_word_cnt == 0)
			 xp10_crc_32                  <= 32'hffff_ffff;
		       else
			 xp10_crc_32                  <= crc32_xp(crc_data, xp10_crc_32, crc_bits_vld);
		       pack_accum_in                  <= {151'd0, pack_accum_out};
		       pack_accum_in_size             <= {2'd0,   pack_accum_out_size};
		       
		       if (wr_hdr_word_cnt == (hdr_word_cnt_max-1)) begin
			  flush_done                 <= 0;
			  if (pack_data_out_cnt == 0)
			    usr_wr                   <= 0;
			  wr_hdr_word_cnt            <= 0;
			  rd_hdr_word_cnt            <= 0;
			  if (xp10_raw) begin
			     state                   <= SA_RAW;
			     xp10_raw                <= 0;
			  end
			  else begin
			     if ((shrt_sel == SIM) || (shrt_sel == PRE)) begin
				pack_accum_in_size        <= {1'd0,  pack_accum_out_size + mtf_hdr_size_reg + (2*xp_encode_type_size)}; 
				
				pack_accum_in             <= {151'd0, pack_accum_out}                                               | 
							     (215'd0+(mtf_hdr_reg<<pack_accum_out_size))                            | 
							     (215'd0+(xp_encode_type_shrt<<(pack_accum_out_size+mtf_hdr_size_reg))) |
							     (215'd0+(xp_encode_type_long<<(pack_accum_out_size+mtf_hdr_size_reg+xp_encode_type_size))); 
				
				if ((long_sel == SIM) || (long_sel == PRE)) begin
				   sa_st1_short_read_done <= ~st_shrt_sel_reg;
				   sa_st2_short_read_done <=  st_shrt_sel_reg;
				   sa_st1_long_read_done  <= ~st_long_sel_reg;
				   sa_st2_long_read_done  <=  st_long_sel_reg;
				   state                  <= SA_LZ77;
				end
				else begin
				   sa_st1_short_read_done <= ~st_shrt_sel_reg;
				   sa_st2_short_read_done <=  st_shrt_sel_reg;
				   state                  <= SA_LONG_TBL_STCL;
				   end
			     end
			     else begin
				
				pack_accum_in                <= {151'd0, pack_accum_out}                    | 
								(215'd0+(mtf_hdr_reg<<pack_accum_out_size)) |
								(215'd0+(xp_encode_type_shrt<<(pack_accum_out_size+mtf_hdr_size_reg))); 
				pack_accum_in_size           <= {1'd0, pack_accum_out_size + mtf_hdr_size_reg + xp_encode_type_size};   
				
				pack_data_out_idx            <= 0;
				pack_data_out_cnt_reg        <= 0;
				state                        <= SA_SHRT_TBL_STCL;
			     end
			  end 
		       end
		    end
		 end 
	      end 
	   end
	   SA_LONG_TBL_STCL,
	   SA_LONG_TBL_ST: begin
	      
	      if (!flush_done) begin
		 if (pack_data_out_cnt_reg != 0) begin
		    if (usr_rdy) begin
		       usr_wr                            <= 1;
		       pack_data_out_idx                 <= pack_data_out_idx + 1;
		       if (pack_data_out_idx+1 == pack_data_out_cnt_reg) begin
			  pack_data_out_idx              <= 0;
			  pack_data_out_cnt_reg          <= 0;
			  pack_accum_in                  <= {151'd0, pack_accum_out};
			  pack_accum_in_size             <= {2'd0,   pack_accum_out_size};
			  flush_done                     <= 1;
		       end
		    end 
		 end
		 else if (pack_accum_in_size >= 64)begin
		    if (usr_rdy) begin
		       if (pack_data_out_cnt == 1) begin
			  usr_wr                         <= 1;
			  pack_accum_in                  <= {151'd0, pack_accum_out};
			  pack_accum_in_size             <= {2'd0,   pack_accum_out_size};
			  flush_done                     <= 1;
		       end
		       else begin
			  usr_wr                         <= 1;
			  pack_data_out_idx              <= 1;
			  pack_data_out_cnt_reg          <= pack_data_out_cnt;
			  pack_data_in_reg               <= pack_data_in;   
			  pack_data_in_size_reg          <= pack_data_in_size;
			  pack_accum_in                  <= pack_accum_in;
			  pack_accum_in_size             <= pack_accum_in_size;
		       end
		    end 
		 end
		 else begin
		    flush_done                           <= 1;
		 end
	      end 
	      
	      else if (st_long_tabl_rdy_reg[4]) begin   
                 
		 if ((wr_hdr_word_cnt < long_stcl_words_mux) && lut_long_rd_rdy) begin
		    wr_hdr_word_cnt                   <= wr_hdr_word_cnt + 1;
		    if (state == SA_LONG_TBL_STCL) begin
		       sa_lut_long_intf.ret_stcl_rd   <= 1;
		       sa_lut_long_intf.ret_stcl_addr <= wr_hdr_word_cnt[0];
		    end
		    else begin
		       sa_lut_long_intf.ret_st_rd     <= 1;
		       sa_lut_long_intf.ret_st_addr   <= wr_hdr_word_cnt[6:0];
		    end
		 end
		 
		 if(lut_sa_long_rd_data_rd)	      
                   begin
		      pack_accum_in                 <= {151'd0, pack_accum_out};
		      pack_accum_in_size            <= {2'd0,   pack_accum_out_size};
		   end
		 if (lut_long_rd_data_fifo_rdy && usr_rdy) begin
		    lut_sa_long_rd_data_rd          <= 1;
		    rd_hdr_word_cnt                 <= rd_hdr_word_cnt+1;
		    if((rd_hdr_word_cnt+1 == long_stcl_words_mux) && ((({3'd0, long_stcl_remain_size_reg_mux} + pack_accum_in_size) >= 7'd64) || (long_stcl_remain_size_reg_mux == 0)))
                      usr_wr                        <= 1;
		    else if(rd_hdr_word_cnt+1 == long_stcl_words_mux)
                      usr_wr                        <= 0;
		    else
		      usr_wr                        <= 1;		    		    
		 end 
		 if (rd_hdr_word_cnt == long_stcl_words_mux) begin
		    wr_hdr_word_cnt                <= 0;
		    rd_hdr_word_cnt                <= 0;
		    if (state == SA_LONG_TBL_STCL)
		      state                        <= SA_LONG_TBL_ST;
		    else begin
		       flush_done                  <= 1;
		       state                       <= SA_LZ77;
		       sa_st1_long_read_done       <= ~st_long_sel_reg;
		       sa_st2_long_read_done       <=  st_long_sel_reg;
		       pack_accum_in_size          <= {1'd0,   pack_accum_out_size}; 
		       pack_accum_in               <= {151'd0, pack_accum_out};
		    end
		 end	
	      end
	   end 
	   SA_SHRT_TBL_STCL,
	   SA_SHRT_TBL_ST: begin
	      
	      if (!flush_done) begin
		 if (pack_data_out_cnt_reg != 0) begin
		    if (usr_rdy) begin
		       usr_wr                            <= 1;
		       pack_data_out_idx              <= pack_data_out_idx + 1;
		       if (pack_data_out_idx+1 == pack_data_out_cnt_reg) begin
			  pack_data_out_idx              <= 0;
			  pack_data_out_cnt_reg          <= 0;
			  pack_accum_in                  <= {151'd0, pack_accum_out};
			  pack_accum_in_size             <= {2'd0,   pack_accum_out_size};
			  flush_done                     <= 1;
		       end
		    end
		 end
		 else if (pack_accum_in_size >= 64)begin
		    if (usr_rdy) begin
		       if (pack_data_out_cnt == 1) begin
			  usr_wr                         <= 1;
			  pack_accum_in                  <= {151'd0, pack_accum_out};
			  pack_accum_in_size             <= {2'd0,   pack_accum_out_size};
			  flush_done                     <= 1;
		       end
		       else begin
			  usr_wr                         <= 1;
			  pack_data_out_idx              <= 1;
			  pack_data_out_cnt_reg          <= pack_data_out_cnt;
			  pack_data_in_reg               <= pack_data_in;   
			  pack_data_in_size_reg          <= pack_data_in_size;
			  pack_accum_in                  <= pack_accum_in;
			  pack_accum_in_size             <= pack_accum_in_size;
		       end
		    end
		 end
		 else begin
		    flush_done                           <= 1;
		 end
	      end
	      else begin
		 if (st_shrt_tabl_rdy_reg[4]) begin
		    
		    if ((wr_hdr_word_cnt < shrt_stcl_words_mux) && lut_shrt_rd_rdy) begin
		       wr_hdr_word_cnt                    <= wr_hdr_word_cnt + 1;
		       if (state == SA_SHRT_TBL_STCL) begin
			  sa_lut_short_intf.ret_stcl_rd   <= 1;
			  sa_lut_short_intf.ret_stcl_addr <= wr_hdr_word_cnt[0];
		       end
		       else begin
			  sa_lut_short_intf.ret_st_rd     <= 1;
			  sa_lut_short_intf.ret_st_addr   <= wr_hdr_word_cnt[6:0];
		       end
		      
		    end
		    
		    if(lut_sa_shrt_rd_data_rd)	      
                      begin
			 pack_accum_in                    <= {151'd0, pack_accum_out};
			 pack_accum_in_size               <= {2'd0,   pack_accum_out_size};
		      end
		    if (lut_shrt_rd_data_fifo_rdy && usr_rdy) begin
		       lut_sa_shrt_rd_data_rd             <= 1;		    
		       rd_hdr_word_cnt                    <= rd_hdr_word_cnt+1;
		       if((rd_hdr_word_cnt+1 == shrt_stcl_words_mux) && ((({3'd0, shrt_stcl_remain_size_reg_mux} + pack_accum_in_size) >= 'd64) || (shrt_stcl_remain_size_reg_mux == 0)))
			 usr_wr                           <= 1;
		       else if(rd_hdr_word_cnt+1 == shrt_stcl_words_mux)
			 usr_wr                           <= 0;
		       else
			 usr_wr                           <= 1;
		    end 
		    if (rd_hdr_word_cnt == shrt_stcl_words_mux) begin
		       wr_hdr_word_cnt            <= 0;
		       rd_hdr_word_cnt            <= 0;
		       if (state == SA_SHRT_TBL_STCL) begin
			  state                   <= SA_SHRT_TBL_ST;
		       end
		       else begin
			  flush_done              <= 0;
			  sa_st1_short_read_done  <= ~st_shrt_sel_reg;
			  sa_st2_short_read_done  <=  st_shrt_sel_reg;
			  if ((seq_id_intf.comp_mode == GZIP) || (seq_id_intf.comp_mode == ZLIB))
			    begin
			       state                  <= SA_LZ77;
			       pack_accum_in_size     <= {1'd0,   pack_accum_out_size}; 
			       pack_accum_in          <= {151'd0, pack_accum_out};
			    end
			  else begin
			     
			     pack_accum_in            <= {151'd0, pack_accum_out} | (215'd0 + xp_encode_type_long<<pack_accum_out_size);
			     
			     pack_accum_in_size       <= pack_accum_out_size      + xp_encode_type_size;                     
			     if ((long_sel == SIM) || (long_sel == PRE)) begin
				sa_st1_long_read_done <= ~st_long_sel_reg;
				sa_st2_long_read_done <=  st_long_sel_reg;
				state                 <=  SA_LZ77;
			     end
			     else begin
				state                 <= SA_LONG_TBL_STCL;
			     end
			  end 
		       end
		    end
		 end 
	      end 
	   end
	   
	   
	   
	   
	   SA_LZ77  : begin
	      if (!flush_done) begin
		 if (pack_data_out_cnt_reg != 0) begin
		    if (usr_rdy) begin
		       usr_wr                            <= 1;
		       pack_data_out_idx                 <= pack_data_out_idx + 1;
		       if (pack_data_out_idx+1 == pack_data_out_cnt_reg) begin
			  pack_data_out_idx              <= 0;
			  pack_data_out_cnt_reg          <= 0;
			  pack_accum_in                  <= {151'd0, pack_accum_out};
			  pack_accum_in_size             <= {2'd0,   pack_accum_out_size};
			  flush_done                     <= 1;
		       end
		    end
		 end
		 else if (pack_accum_in_size >= 64)begin
		    if (usr_rdy) begin
		       if (pack_data_out_cnt == 1) begin
			  usr_wr                         <= 1;
			  pack_accum_in                  <= {151'd0, pack_accum_out};
			  pack_accum_in_size             <= {2'd0,   pack_accum_out_size};
			  flush_done                     <= 1;
		       end
		       else begin
			  usr_wr                         <= 1;
			  pack_data_out_idx              <= 1;
			  pack_data_out_cnt_reg          <= pack_data_out_cnt;
			  pack_data_in_reg               <= pack_data_in;   
			  pack_data_in_size_reg          <= pack_data_in_size;
			  pack_accum_in                  <= pack_accum_in;
			  pack_accum_in_size             <= pack_accum_in_size;
		       end
		    end
		 end
		 else begin
		    flush_done                           <= 1;
		 end
	      end
	      else begin
		 
		 
		 raw_fifo_rd                       <= raw_fifo_rd_rdy;
		 if (lut_shrt_rd_rdy && !lz77_rd_done && (!reconstruct_en_reg || (reconstruct_en_reg && mtf_sdd_dp_ready_delay))) begin
		    term_rd                        <= 1;
		 end
		 if (reconstruct_en_reg && lz77_rd_done && mtf_sdd_dp_ready_delay && !eob_raw_done) begin
		    eob_raw_done                   <= 1;
		    sdd_mtf_dp_bus                 <= 0;
		    sdd_mtf_dp_bus.framing         <= 4'd8;
		    sdd_mtf_dp_valid               <= 1'd1;
		 end
		 if (!mtf_sdd_dp_ready_delay) begin
		    sdd_mtf_dp_bus                 <= sdd_mtf_dp_bus;
		    sdd_mtf_dp_valid               <= 1'd1;
		 end	    
		 if (term_rd_masked) begin
		    if (deflate && lz_symbol_bus.backref_type) begin
		       sdd_mtf_dp_valid            <= 1'd0;
		    end
		    else begin
		       sdd_mtf_dp_bus              <= lz_symbol_bus;
		       sdd_mtf_dp_valid            <= reconstruct_en_reg;
		    end
		    if ((eob && !seq_id_intf.blk_last) || term_tlv.tuser[1]) begin
		       term_rd                     <= 0;
		       lz77_rd_done                <= 1; 
		       eot_enc_done                <= term_tlv.tuser[1];
		    end
		    
		    if (symbol_holding_fifo_wr_data_nxt.eot != 1 || deflate) begin
		       sa_lut_short_intf.data_rd   <= 1;
		       if (mux_symbol_map_intf.long_vld)
			 sa_lut_long_intf.data_rd  <= 1;
		    end
		    if (symbol_holding_fifo_wr_data_nxt.eot && deflate)
		      sa_lut_short_intf.data_addr0 <= 10'd256;
		    else
		      sa_lut_short_intf.data_addr0  <= shrt_data_addr0;
		    sa_lut_short_intf.data_addr1    <= shrt_data_addr1;
		    sa_lut_short_intf.data_addr2    <= shrt_data_addr2;
		    sa_lut_short_intf.data_addr3    <= shrt_data_addr3;
		    sa_lut_long_intf.data_addr0     <= {2'd0, mux_symbol_map_intf.long};
		    sa_lut_long_intf.data_addr1     <= {2'd0, mux_symbol_map_intf.long};
		    sa_lut_long_intf.data_addr2     <= {2'd0, mux_symbol_map_intf.long};
		    sa_lut_long_intf.data_addr3     <= {2'd0, mux_symbol_map_intf.long};
		    symbol_holding_fifo_wr_data     <= symbol_holding_fifo_wr_data_nxt;
		    sym_map_error                   <= sym_map_error | (symbol_holding_fifo_wr_data_nxt.mux_symbol_map_intf.map_error_long | symbol_holding_fifo_wr_data_nxt.mux_symbol_map_intf.map_error_shrt);
		    huf_comp_stats.shrt_map_err_stb <= symbol_holding_fifo_wr_data_nxt.mux_symbol_map_intf.map_error_shrt;
		    huf_comp_stats.long_map_err_stb <= symbol_holding_fifo_wr_data_nxt.mux_symbol_map_intf.map_error_long;
		    hold_symb_fifo_wr               <= 1;
		    is_mtf_hdr_last_ptr             <= is_mtf_hdr_last_ptr_nxt;
		    if (lz_symbol_bus.backref) begin
		       for (int i=0; i<4; i++) begin
			  mtf_offset[i]             <= mtf_offset_nxt[i];
		       end
		    end
		 end
		 
		 
		 
		 if ((lut_shrt_rd_data_fifo_rdy || ((symbol_holding_rd_data_fifo_rdy && symbol_holding_fifo_rd_data.eot) && !deflate)) && enc_fifo_wr_rdy)  begin
		    if (!symbol_holding_fifo_rd_data.eot || deflate)
		    lut_sa_shrt_rd_data_rd         <= 1;
		    lut_sa_long_rd_data_rd         <= lut_long_rd_data_fifo_rdy;
		    hold_symb_fifo_rd              <= 1;
		 end
		 
		 
		 if (xfer_rdy && enc_fifo_rd_rdy) begin  
		    enc_fifo_rd                 <= 1;
		 end
		 
		 if (xfer_rdy && pack_data_out_cnt_reg != 0) begin 
		    usr_wr                      <= 1;
		    pack_data_out_idx           <= pack_data_out_idx + 1;
		    enc_fifo_rd                 <= 0;
		    if (pack_data_out_idx+1 == pack_data_out_cnt_reg) begin
		       enc_fifo_rd              <= enc_fifo_rd_rdy;
		       pack_data_out_idx        <= 0;
		       pack_data_out_cnt_reg    <= 0;
		       pack_accum_in            <= {151'd0, pack_accum_out};
		       pack_accum_in_size       <= {2'd0,   pack_accum_out_size};
		    end
		 end
		 if (enc_fifo_rd) begin
		    pack_accum_in                  <= {151'd0, pack_accum_out};
		    pack_accum_in_size             <= {2'd0,   pack_accum_out_size};
		    enc_fifo_rd                    <= xfer_rdy & enc_fifo_rd_rdy; 
		    usr_wr                         <= 1;
		    
		    if (pack_data_out_cnt == 0) begin
		       usr_wr                      <= 0;
		    end
		    
		    else if (pack_data_out_cnt > 1) begin
		       enc_fifo_rd                 <= 0;
		       pack_data_out_idx           <= 1;
		       pack_data_out_cnt_reg       <= pack_data_out_cnt;
		       pack_data_in_reg            <= pack_data_in;   
		       pack_data_in_size_reg       <= pack_data_in_size;
		       pack_accum_in               <= pack_accum_in;
		       pack_accum_in_size          <= pack_accum_in_size;
		    end
		 end
		 
		 if ((pack_data_out_cnt_reg == 0) && ((!enc_fifo_empty && (data_out_eot_enc || data_out_eob_enc)) || lz77_wr_done)) begin
		    if (xfer_rdy && enc_fifo_rd_rdy) 
		      enc_fifo_rd                    <= 1;
		    lz77_wr_done                     <= 1;
		    if (data_out_eot_enc || data_out_eot_enc_reg)
		      data_out_eot_enc_reg           <= 1;
		    
		    if ((pack_data_out_cnt == 0) && !enc_fifo_rd_rdy && (!reconstruct_en_reg  || data_out_eob_raw)) begin
		       frm_bit_count                 <= frm_bit_count  + out_size_bits_reg;             
		       if (seq_id_intf.comp_mode == XP9)
			 frm_bit_count               <= frm_bit_count  + out_size_bits_reg + byte_pad_msk;  
		       df_frm_raw_byte_count         <= df_frm_raw_byte_count_nxt;
		       lz77_rd_done                  <= 0;
		       lz77_wr_done                  <= 0;
		       eot_enc_done                  <= 0;
		       
		       if (data_out_eot_enc || data_out_eot_enc_reg) begin
			  data_out_eot_enc_reg       <= 0;
			  df_frm_raw_byte_count      <= 0;
			  state                      <= SA_LZ77_END;
			  for (int i=0; i<4; i++) begin
			     mtf_offset[i]           <= 0;
			  end
			  if ((seq_id_intf.comp_mode == XP9) || chu_mode)
			    if (pack_accum_out_size == 0)
			      usr_wr                 <= 0;
			    else
			      begin
				 usr_wr              <= 1;
				 wr_more             <= pack_accum_out_size > 64;
			      end
			  else begin
			     flush_done              <= 0;
			     wr_more                 <= 1;
			     usr_wr                  <= 0;
			  end
			  
			  if (seq_id_intf.comp_mode == XP10) begin
			     
			     
			     pack_accum_in           <= {151'd0, pack_accum_out}      | (215'd0+(ftr_crc_sel << (byte_pad+pack_accum_out_size)));
			     
			     pack_accum_in_size      <= pack_accum_out_size           +  ftr_crc_size +  byte_pad;
			  end
			  if (seq_id_intf.comp_mode == GZIP) begin
			     
			     pack_accum_in           <= {151'd0, pack_accum_out}      | (215'd0+((ftr_crc_sel               << (byte_pad_msk+pack_accum_out_size   )) | 
											         (df_frm_raw_byte_count_nxt << (byte_pad_msk+pack_accum_out_size+32)))) ;
			     
			     pack_accum_in_size      <= pack_accum_out_size           +  32 + ftr_crc_size + byte_pad_msk;
			  end
			  if (seq_id_intf.comp_mode == ZLIB) begin
			     
			     pack_accum_in           <= {151'd0, pack_accum_out}      | (215'd0+(ftr_crc_sel << (byte_pad_msk+pack_accum_out_size)));
			     
			     pack_accum_in_size      <= pack_accum_out_size           +  ftr_crc_size +  byte_pad_msk;
			  end	  
		       end
		       
		       else begin
			  crc_data                   <= 0;
			  seq_id                     <= term_tlv.tuser[5:2]; 
			  state                      <= SA_FRM_IDL;
			  
			  if (seq_id_intf.comp_mode == XP9) begin
			     
			     pack_accum_in           <= {151'd0, pack_accum_out} | (215'd0+(8'd0 << (byte_pad_msk+pack_accum_out_size)));  
			     
			     pack_accum_in_size      <= {2'd0, (pack_accum_out_size +  byte_pad_msk)};  
			  end
			  comp_mode_lst.comp_mode    <= seq_id_intf.comp_mode;
			  comp_mode_lst.xp10_crc     <= seq_id_intf.xp10_crc_mode;
			  sa_sm_intf.vld             <= 1;
			  sa_sm_intf.seq_id          <= seq_id;
			  sa_lut_long_intf.ret_ack   <= 1;
			  sa_lut_short_intf.ret_ack  <= 1;
		       end
		    end
		 end 
	      end 
	   end
	   SA_LZ77_END: begin
	      raw_fifo_rd                                   <= raw_fifo_rd_rdy;
	      
	      reconstruct_en_reg                            <= 0;
	      reconstruct_chu_flush_reg                     <= 0;
	      if (usr_rdy) begin
		 if (wr_more) begin
		    if (flush_done) begin
		       comp_mode_lst.comp_mode              <= seq_id_intf.comp_mode;
		       comp_mode_lst.xp10_crc               <= seq_id_intf.xp10_crc_mode;
		       seq_id                               <= term_tlv.tuser[5:2];
		       sa_sm_intf.vld                       <= 1;
		       sa_sm_intf.seq_id                    <= seq_id;
		       sa_lut_long_intf.ret_ack             <= 1;
		       sa_lut_short_intf.ret_ack            <= 1;
		       wr_more                              <= 0;
		       usr_wr                               <= 0;
		       flush_done                           <= 0;
		       state                                <= SA_FRM_IDL;
		    end
		    else begin
		       if (pack_data_out_cnt_reg != 0) begin
			  usr_wr                            <= 1;
			  pack_data_out_idx                 <= pack_data_out_idx + 1;
			  if (pack_data_out_idx+1 == pack_data_out_cnt_reg) begin
			     pack_data_out_idx              <= 0;
			     pack_data_out_cnt_reg          <= 0;
			     pack_accum_in                  <= {151'd0, pack_accum_out};
			     pack_accum_in_size             <= {2'd0,   pack_accum_out_size};
			     flush_done                     <= (pack_accum_out_size == 0);
			  end
		       end 
		       else if (pack_accum_in_size >= 64)begin
			  if (pack_data_out_cnt == 1) begin
			     usr_wr                         <= 1;
			     pack_accum_in                  <= {151'd0, pack_accum_out};
			     pack_accum_in_size             <= {2'd0,   pack_accum_out_size};
			     flush_done                     <= (pack_accum_out_size == 0);
			  end
			  else begin
			     usr_wr                         <= 1;
			     pack_data_out_idx              <= 1;
			     pack_data_out_cnt_reg          <= pack_data_out_cnt;
			     pack_data_in_reg               <= pack_data_in;   
			     pack_data_in_size_reg          <= pack_data_in_size;
			     pack_accum_in                  <= pack_accum_in;
			     pack_accum_in_size             <= pack_accum_in_size;
			  end
		       end 
		       else begin
			  usr_wr                            <= 1;
			  pack_accum_in                     <= {151'd0, pack_accum_out};
			  pack_accum_in_size                <= {2'd0,   pack_accum_out_size};
			  flush_done                        <= 1;			  
		       end
		    end 
		 end 
		 
		 else begin
		    comp_mode_lst.comp_mode                 <= seq_id_intf.comp_mode;
		    comp_mode_lst.xp10_crc                  <= seq_id_intf.xp10_crc_mode;
		    seq_id                                  <= term_tlv.tuser[5:2];
		    sa_sm_intf.vld                          <= 1;
		    sa_sm_intf.seq_id                       <= seq_id;
		    sa_lut_long_intf.ret_ack                <= 1;
		    sa_lut_short_intf.ret_ack               <= 1;
		    state                                   <= SA_FRM_IDL;
		 end
	      end 
	   end
	   
	   SA_OTHR: begin
	      if (final_sch_stall) begin
		  if (su_ready_reg) begin
		     huf_comp_sch_update.valid         <= 1;
		     huf_comp_sch_update.basis         <= 0;
		     huf_comp_sch_update.bytes_in      <= 0;
		     huf_comp_sch_update.bytes_out     <= sch_byte_count_final;
		     huf_comp_sch_update.last          <= cipher_last;
		     cipher_last                       <= 0;
		     final_sch_stall                   <= 0;
		     if (comp_mode_lst.comp_mode == NONE)
		       state                           <= SA_IDLE;
		     else
		       state                           <= SA_FRM_IDL;
		  end
	      end
	      else begin
		 if (xfer_rdy) begin
		    term_rd         <= 1;
		    usr_wr          <= 1;
		    rd_hdr_word_cnt <= rd_hdr_word_cnt + 1;
		 end
		 if (term_rd && (rd_hdr_word_cnt == 1) && (term_tlv.typen == CMD)) begin
		    trace           <= tlv_cmd_word_1.trace;
		    if ((tlv_cmd_word_1.compound_cmd_frm_size == COMPND_4K) || (tlv_cmd_word_1.compound_cmd_frm_size == COMPND_8K))
		      compound_cmd  <= 1;
		    else
		      compound_cmd  <= 0;
		 end 
		 if (term_rd && (rd_hdr_word_cnt == 2) && (term_tlv.typen == CMD)) begin
		    cipher_pad      <= {tlv_cmd_word_2.cipher_pad};
		    if (compound_cmd && (tlv_cmd_word_2.comp_mode == NONE))
		      compound_cmd  <= 1;
		    else
		      compound_cmd  <= 0;
		 end
		 if (term_rd && term_tlv.tuser[1]) begin
		    term_rd         <= 0;
		    usr_wr          <= 0;
		    if (term_tlv.typen == RQE) begin
		       huf_comp_sch_update.rqe_sched_handle  <= tlv_rqe_word_1.scheduler_handle;
		    end
		    if (term_tlv.tlast) begin
		       compound_cmd             <= 0;
		       state                    <= SA_IDLE;
		    end
		    else begin
		       state                    <= SA_FRM_IDL;
		       if (term_tlv.typen == FTR) begin
			  if (comp_mode_lst.comp_mode == NONE)
			    state               <= SA_IDLE;
			  ecc_error_reg         <= 0;
			  prehfd_crc_error      <= 0;
			  prefix_crc_error      <= 0;
			  sym_map_error         <= 0;
			  first_xfer_done       <= 0;
			  xp10_user_prefix_size <= 0;
			  if ((sch_byte_count_final != 0) || cipher_last) begin
			     if (su_ready_reg) begin
				huf_comp_sch_update.valid         <= 1;
				huf_comp_sch_update.basis         <= 0;
				huf_comp_sch_update.bytes_in      <= 0;
				huf_comp_sch_update.bytes_out     <= sch_byte_count_final;
				huf_comp_sch_update.last          <= cipher_last;
				cipher_last                       <= 0;
			     end
			     else begin
				final_sch_stall                   <= 1;
				state                             <= SA_OTHR;
			     end
			  end
		       end
		    end 	 
		 end    
	      end 
	   end
	   default: begin
	      state                          <= SA_IDLE;
	   end
	 endcase 
	 if (!trace) begin
	    huf_comp_stats <= 0;
	 end
      end
   end
   
  
  
   
   
     
   cr_huf_comp_sa_tlvp_top cr_huf_comp_sa_tlvp_top
     (
      
      .tlvp_in_rd			(tlvp_in_rd),
      .term_empty			(term_empty),
      .term_aempty			(term_aempty),
      .term_tlv				(term_tlv),
      .usr_full				(usr_full),
      .usr_afull			(usr_afull),
      .crc_error			(crc_error),
      .axi4s_ob_out			(huf_comp_ob_out),	 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .tlvp_in_aempty			(tlvp_in_aempty),
      .tlvp_in_empty			(tlvp_in_empty),
      .tlvp_in_data			(tlvp_in_data),
      .tlv_parse_action			({sw_sa_out_tlv_parse_action_1,sw_sa_out_tlv_parse_action_0}), 
      .module_id			(huf_comp_module_id),	 
      .term_rd				(term_rd_masked),	 
      .usr_wr				(usr_wr),
      .usr_tlv				(usr_tlv_nxt),		 
      .axi4s_ob_in			(huf_comp_ob_in));	 

  

   `CCX_STD_DECLARE_CRC(crc32_xp,    32'h82f63b78, 32, 64) 
   `CCX_STD_CALC_BIP2(get_bip2, `AXI_S_DP_DWIDTH);         
   cr_huf_comp_min_bits cr_huf_comp_min_bits_shrt (.ret (shrt_size_ret), .pre (shrt_size_pre), .sim (shrt_size_sim), .min_num (shrt_size_min_comb), .min_sel (shrt_sel_comb));
   cr_huf_comp_min_bits cr_huf_comp_min_bits_long (.ret (long_size_ret), .pre (long_size_pre), .sim (long_size_sim), .min_num (long_size_min_comb), .min_sel (long_sel_comb));

   
   
   
   
   nx_fifo
     #(.DEPTH         (N_HOLD_DEPTH),               
       .WIDTH         (`CREOLE_HC_HDR_WIDTH))   
   lut_long_rd_data_fifo
     (
      
      .empty				(lut_long_rd_data_fifo_empty), 
      .full				(),			 
      .underflow			(),			 
      .overflow				(),			 
      .used_slots			(lut_long_rd_data_fifo_used_slots), 
      .free_slots			(),			 
      .rdata				(lut_sa_long_data),	 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .wen				(lut_sa_long_rd_data_wr), 
      .ren				(lut_sa_long_rd_data_rd_masked), 
      .clear				(1'd0),			 
      .wdata				(lut_sa_long_rd_data));	 
   
   
   nx_credit_manager 
     #(.N_MAX_CREDITS                 (N_HOLD_DEPTH),                          
       .N_USED_LAG_CYCLES             (2),     
       .N_MAX_CREDITS_PER_CYCLE       (1)) 
   lut_long_cm
     (
      
      .credit_available			(lut_long_rd_rdy),	 
      .hw_status			(),			 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .sw_init				(1'd0),			 
      .credit_return			(lut_sa_long_rd_data_rd_masked), 
      .credit_used			(lut_long_fifo_credit_used), 
      .sw_config			(sw_config));		 
   
   
   
   
      
   nx_fifo
     #(.DEPTH         (N_HOLD_DEPTH),               
       .WIDTH         (4*`CREOLE_HC_HDR_WIDTH))   
   lut_short_rd_data_fifo
     (
      
      .empty				(lut_shrt_rd_data_fifo_empty), 
      .full				(),			 
      .underflow			(),			 
      .overflow				(),			 
      .used_slots			(lut_shrt_rd_data_fifo_used_slots), 
      .free_slots			(),			 
      .rdata				({lut_sa_shrt_data}),	 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .wen				(lut_sa_shrt_rd_data_wr), 
      .ren				(lut_sa_shrt_rd_data_rd), 
      .clear				(1'd0),			 
      .wdata				(lut_sa_shrt_rd_data));	 
   
   
   nx_credit_manager 
     #(.N_MAX_CREDITS                 (N_HOLD_DEPTH),                          
       .N_USED_LAG_CYCLES             (2),  
       .N_MAX_CREDITS_PER_CYCLE       (1)) 
   lut_shrt_cm
     (
      
      .credit_available			(lut_shrt_rd_rdy),	 
      .hw_status			(),			 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .sw_init				(1'd0),			 
      .credit_return			(lut_sa_shrt_rd_data_rd), 
      .credit_used			(lut_shrt_fifo_credit_used), 
      .sw_config			(sw_config));		 
   
    
   nx_credit_manager 
     #(.N_MAX_CREDITS                 (N_HOLD_DEPTH),                          
       .N_USED_LAG_CYCLES             (1),  
       .N_MAX_CREDITS_PER_CYCLE       (1)) 
   symbol_holding_fifo_cm
     (
      
      .credit_available			(symbol_holding_fifo_wr_rdy), 
      .hw_status			(),			 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .sw_init				(1'd0),			 
      .credit_return			(hold_symb_fifo_rd),	 
      .credit_used			(hold_symb_fifo_wr),	 
      .sw_config			(sw_config));		 

   
   
   
   
   
   
      
   nx_fifo
     #(.DEPTH         (N_HOLD_DEPTH),  
       .WIDTH         (108))   
   symbol_holding_fifo
     (
      
      .empty				(symbol_holding_rd_data_fifo_empty), 
      .full				(),			 
      .underflow			(),			 
      .overflow				(),			 
      .used_slots			(symbol_holding_rd_data_fifo_used_slots), 
      .free_slots			(),			 
      .rdata				(symbol_holding_fifo_rd_data), 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .wen				(hold_symb_fifo_wr),	 
      .ren				(hold_symb_fifo_rd),	 
      .clear				(1'd0),			 
      .wdata				(symbol_holding_fifo_wr_data)); 



   
   
   
   
   nx_credit_manager 
     #(.N_MAX_CREDITS                 (N_HOLD_ENC_DEPTH),                          
       .N_USED_LAG_CYCLES             (4),  
       .N_MAX_CREDITS_PER_CYCLE       (1)) 
   data_out_enc_fifo_cm
     (
      
      .credit_available			(enc_fifo_wr_rdy),	 
      .hw_status			(),			 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .sw_init				(1'd0),			 
      .credit_return			(enc_fifo_rd),		 
      .credit_used			(data_out_vld),		 
      .sw_config			(sw_config_enc));	 
   
   
   
   
   
      
   nx_fifo
     #(.DEPTH         (N_HOLD_ENC_DEPTH),  
       .WIDTH         (175))   
   enc_fifo
     (
      
      .empty				(enc_fifo_empty),	 
      .full				(),			 
      .underflow			(),			 
      .overflow				(),			 
      .used_slots			(enc_fifo_used_slots),	 
      .free_slots			(),			 
      .rdata				({data_out_eob_enc, data_out_eot_enc, data_out_size_enc, data_out_enc}), 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .wen				(data_out_vld),		 
      .ren				(enc_fifo_rd),		 
      .clear				(1'd0),			 
      .wdata				({data_out_eob, data_out_eot, data_out_size, data_out})); 
   
   
   
   
   
   nx_credit_manager 
     #(.N_MAX_CREDITS                 (N_HOLD_ENC_DEPTH),                          
       .N_USED_LAG_CYCLES             (3),  
       .N_MAX_CREDITS_PER_CYCLE       (1)) 
   raw_cm
     (
      
      .credit_available			(be_lz_dp_ready),	 
      .hw_status			(),			 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .sw_init				(1'd0),			 
      .credit_return			(raw_fifo_rd),		 
      .credit_used			(lz_be_dp_valid),	 
      .sw_config			(sw_config_enc));	 
   
   
   
   
   
      
   cr_huf_comp_sm_fifo
     #(.DEPTH         (N_HOLD_ENC_DEPTH),  
       .WIDTH         (74))   
   raw_fifo
     (
      
      .empty				(raw_fifo_empty),	 
      .full				(),			 
      .underflow			(),			 
      .overflow				(),			 
      .used_slots			(raw_fifo_used_slots),	 
      .free_slots			(),			 
      .rdata				({data_out_signal_raw, data_out_size_raw_pre, data_out_raw}), 
      .rdata_nxt			({data_out_signal_raw_nxt, data_out_size_raw_nxt, data_out_raw_nxt}), 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .wen				(lz_be_dp_valid),	 
      .ren				(raw_fifo_rd),		 
      .clear				(1'd0),			 
      .wdata				({lz_be_dp_bus.data_type[1:0], lz_be_dp_bus.bytes_valid[7:0], lz_be_dp_bus.data[63:0]})); 
   
   
   
   function [`N_EXTRA_BITS_LEN_WIDTH-1:0] floor_log;
      input [`N_WINDOW_WIDTH-1:0] value;
      begin
	 floor_log = 0;
	 for (int j=0; j < `N_WINDOW_WIDTH; j=j+1) begin
	    if (value[j] == 1'b1)
	      floor_log = j;
	 end
      end
   endfunction 

   
   
   
   
   nx_bit_pack 
     #(.IN_W   (PACK_IN_W),
       .OUT_W  (PACK_OUT_W), 
       .ACC_W  (PACK_ACC_W))
   axi_bit_pack
     (
      
      .data_out_cnt			(pack_data_out_cnt),	 
      .data_out				(pack_data_out),	 
      .accum_out			(pack_accum_out),	 
      .accum_out_size			(pack_accum_out_size),	 
      
      .data_in				(pack_data_in),		 
      .data_in_size			(pack_data_in_size),	 
      .accum_in				(pack_accum_in),	 
      .accum_in_size			(pack_accum_in_size),	 
      .data_out_index			(pack_data_out_idx));	 
   

   
   
   
   
       
   cr_huf_comp_sm_xp cr_huf_comp_sa_xp
     (
      
      .xp_symbol_map_intf		(xp_symbol_map_intf),
      .mtf_offset_out_0			(mtf_offset_nxt[0]),	 
      .mtf_offset_out_1			(mtf_offset_nxt[1]),	 
      .mtf_offset_out_2			(mtf_offset_nxt[2]),	 
      .mtf_offset_out_3			(mtf_offset_nxt[3]),	 
      
      .xp9				(xp9),
      .min_len				({seq_id_intf.lz77_min_match_len}), 
      .mtf				(lz_symbol_bus.backref_type), 
      .mtf_num				(mtf_num),		 
      .len				(lz_symbol_bus.length),	 
      .ofs				(ofs),			 
      .win_size				({seq_id_intf.lz77_win_size}), 
      .mtf_offset_0			(mtf_offset[0]),	 
      .mtf_offset_1			(mtf_offset[1]),	 
      .mtf_offset_2			(mtf_offset[2]),	 
      .mtf_offset_3			(mtf_offset[3]),	 
      .prev_mtf_or_ptr			(prev_mtf_or_ptr));	 

   
   
   
   
   cr_huf_comp_sm_deflate cr_huf_comp_sm_deflate
     (
      
      .df_symbol_map_intf		(df_symbol_map_intf),
      
      .len				(lz_symbol_bus.length),	 
      .ofs				(ofs[`N_WINDOW_WIDTH-1:0]));
   
   
   
   
   
   cr_huf_comp_sa_enc_func_pipe cr_huf_comp_sa_enc_func_pipe
     (
      
      .data_out				(data_out),		 
      .data_out_size			(data_out_size),	 
      .data_out_eot			(data_out_eot),		 
      .data_out_eob			(data_out_eob),		 
      .data_out_vld			(data_out_vld),		 
      .data_out_pend			(data_out_pend),
      
      .shrt_sel				(shrt_sel),
      .long_sel				(long_sel),
      .comp_mode			({seq_id_intf.comp_mode}), 
      .lz77_win_size			({seq_id_intf.lz77_win_size}), 
      .lut_sa_shrt_data			(lut_sa_shrt_data),
      .lut_sa_long_data			(lut_sa_long_data),
      .symbol_holding_fifo_intf		(symbol_holding_fifo_rd_data), 
      .vld				(hold_symb_fifo_rd),	 
      .clk				(clk),
      .rst_n				(rst_n));

   genvar l,j,k;
   generate
      
      for (l=0; l<8; l++) begin: cover_byte_pad_df_hdr 
         byte_pad_df_hdr_reached_l: `COVER_PROPERTY(byte_pad_df == l); 
      end
      
      for (j=0; j<8; j++) begin: cover_byte_pad_df_ftr 
         byte_pad_df_ftr_reached_j: `COVER_PROPERTY(byte_pad_msk == j); 
      end
      
      for (k=0; k<8; k++) begin: cover_byte_pad_xp_ftr 
         byte_pad_xp_ftr_reached_k: `COVER_PROPERTY(byte_pad == k); 
      end
   endgenerate



   
endmodule 







