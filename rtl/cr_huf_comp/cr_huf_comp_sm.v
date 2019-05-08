/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_huf_comp.vh"

module cr_huf_comp_sm
  (
   
   huf_comp_ib_out, sm_sq_intf, sm_seq_id_wr_intf, sm_seq_id_intf,
   sm_sc_shrt_intf, sm_sc_long_intf, sm_predet_mem_shrt_intf,
   sm_predet_mem_long_intf, lz77_stall_stb, sm_bip2_reg,
   
   clk, rst_n, huf_comp_ib_in, huf_comp_module_id, sq_sm_intf,
   sc_sm_shrt_intf, sc_sm_long_intf, sa_sm_intf,
   sw_henc_huff_win_size_in_entries, sw_henc_xp9_first_blk_thrsh,
   sw_sm_in_tlv_parse_action_0, sw_sm_in_tlv_parse_action_1
   );
   
`include "cr_structs.sv"
   
   import cr_huf_compPKG::*;
   import cr_huf_comp_regsPKG::*;
   
   
   
   input                               clk;
   input 			       rst_n;

   
   
   
   input  axi4s_dp_bus_t               huf_comp_ib_in;
   output axi4s_dp_rdy_t               huf_comp_ib_out;
   
   input [`MODULE_ID_WIDTH-1:0] huf_comp_module_id;
   
   
   
   input  s_sq_sm_intf                 sq_sm_intf;             
   output s_sm_sq_intf                 sm_sq_intf;

   
   
   
   output s_sm_seq_id_wr_intf          sm_seq_id_wr_intf;
   output s_sm_seq_id_intf             sm_seq_id_intf;

   
   
   
   input  s_sc_sm_shrt_intf            sc_sm_shrt_intf;
   input  s_sc_sm_long_intf            sc_sm_long_intf;
   output s_sm_sc_shrt_intf            sm_sc_shrt_intf;
   output s_sm_sc_long_intf            sm_sc_long_intf;
   
   
   
   
   output s_sm_predet_mem_intf         sm_predet_mem_shrt_intf;
   output s_sm_predet_mem_intf         sm_predet_mem_long_intf;

   
   
   
   input  s_sa_sm_intf                 sa_sm_intf;

   output logic                        lz77_stall_stb;

   output logic                        sm_bip2_reg;
   
   
   
   
   input [`CR_HUF_COMP_C_HENC_HUFF_WIN_SIZE_IN_ENTRIES_T_DECL] sw_henc_huff_win_size_in_entries;
   input [`CR_HUF_COMP_C_HENC_EX9_FIRST_BLK_THRESH_T_DECL]     sw_henc_xp9_first_blk_thrsh;      
   input [`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_31_0_T_DECL] sw_sm_in_tlv_parse_action_0;
   input [`CR_HUF_COMP_C_SM_IN_TLV_PARSE_ACTION_63_32_T_DECL] sw_sm_in_tlv_parse_action_1;
   
   
   logic		crc_error;		
   logic		term_empty;		
   logic		term_full;		
   logic		tlvp_out_aempty;	
   logic		tlvp_out_empty;		
   logic		usr_afull;		
   logic		usr_full;		
   
   axi4s_dp_bus_t	                        tlvp_out;      
   tlvp_if_bus_t	                        term_tlv_pre;  
   tlvp_if_bus_t	                        term_tlv_nxt;  
   tlvp_if_bus_t	                        term_tlv;      
   s_symbol_map_intf                            df_symbol_map_intf;
   s_symbol_map_intf                            xp_symbol_map_intf;
   s_symbol_map_intf                            mux_symbol_map_intf; 
   logic 		                        deflate;
   logic 		                        chu_mode;
   logic [`CREOLE_HC_SEQID_NUM-1:0]             seq_id_active;                   
   logic [`CREOLE_HC_SEQID_WIDTH-1:0] 		seq_id;
   logic [`CREOLE_HC_SEQID_WIDTH-1:0] 		seq_id_nxt;
   logic [`CREOLE_HC_SEQID_WIDTH-1:0] 		seq_id_lst;
   logic [4:0] 					tlv_word_count;     
   logic [4:0] 					tlv_word_count_nxt; 
   logic 					term_rdy;
   logic 					usr_wr;
   logic 					usr_wr_lz77;
   logic 					usr_wr_mux;
   logic 					term_rd;
   logic 					xfer_rdy;
   logic 					tlvp_out_rd;
   logic 					first_xfer_done;
   logic 					sm_block_stall;
   logic [`N_MAX_MTF_WIDTH-1:0] 		mtf_num;
   logic [`N_WINDOW_WIDTH-1:0] 			ofs;
   logic [`N_RAW_SIZE_WIDTH:0] 			raw_byte_count_nxt_pre;  
   logic [`N_RAW_SIZE_WIDTH-1:0] 		raw_byte_count_nxt;
   logic [`N_RAW_SIZE_WIDTH-1:0] 		raw_byte_count_lst;
   logic [`CREOLE_HC_SYM_ENTRY_CNT_WIDTH-1:0] 	sym_entry_count;
   logic [`CREOLE_HC_SYM_ENTRY_CNT_WIDTH-1:0] 	sym_entry_count_nxt;
   logic [`N_EXTRA_BITS_TOT_WIDTH:0] 		extra_bit_count_nxt_pre; 
   logic [`N_EXTRA_BITS_TOT_WIDTH-1:0] 		extra_bit_count_nxt;
   logic [`N_EXTRA_BITS_TOT_WIDTH-1:0] 		extra_bit_count_lst;
   logic [($clog2((`AXI_S_DP_DWIDTH+`CREOLE_HC_PHT_WIDTH)/`CREOLE_HC_PHT_WIDTH)):0]   pdh_data_out_cnt;
   logic [`CREOLE_HC_PHT_WIDTH-1:0]		pdh_data_out ;  
   logic [`CREOLE_HC_PHT_WIDTH-1:0] 		pdh_accum_out;
   logic [`AXI_S_DP_DWIDTH-1:0] 		pdh_data_in;
   logic [`AXI_S_DP_DWIDTH-1:0] 		pdh_data_in_reg;
   logic [($clog2(`AXI_S_DP_DWIDTH)):0] 	pdh_accum_out_size; 
   logic [`AXI_S_DP_DWIDTH-1:0] 		pdh_accum_in;
   logic [($clog2(`AXI_S_DP_DWIDTH)):0] 	pdh_accum_in_size; 
   logic 					pdh_wr;
   logic [`CREOLE_HC_PHT_ADDR_WIDTH:0] 		pdh_addr;
   logic [`CREOLE_HC_PHT_ADDR_WIDTH:0] 		pdh_addr_out;
   logic [`CREOLE_HC_PHT_WIDTH-1:0] 		pdh_data;
   logic [`CREOLE_HC_SEQID_WIDTH-1:0] 		predet_mem_id, predet_mem_id_nxt;
   logic [31:0] 				crc32_pdh;
   logic [3:0] 					byte_vld_pre; 
   logic 					xp9;
   logic 					insert_df_eob;
   logic 					inc_blk_count;
   logic [3:0] 					term_used_slots;
   logic [3:0] 					term_free_slots;
   logic 					term_aempty_pre;
   logic 					term_empty_pre;
   logic 					term_rd_pre;
   logic 					term_afull, term_aempty;
   logic 					seq_id_check;
   logic 					pdh_accum_wr;
   logic 					inc_predet_mem_id;
   logic 					stall_eob;
   logic 					eob;
   logic 					eof;
   logic 					term_empty_reg;
   logic 					trace;
   logic 					compound_cmd;

   logic 					sc_sm_shrt_intf_rdy;
   
   
   e_sm_state           			state;
   tlv_cmd_word_2_t     			tlv_cmd_word_2; 
   tlvp_if_bus_t				usr_tlv_nxt;
   tlvp_if_bus_t				usr_tlv_nxt_mux;
   tlvp_if_bus_t				usr_tlv_nxt_reg;
   lz_symbol_bus_t                              lz_symbol_bus;
   lz_symbol_bus_t                              lz_symbol_bus_df_eob;
   s_sm_sc_long_intf                            sm_sc_long_intf_nxt;
   s_sm_sc_shrt_intf                            sm_sc_shrt_intf_nxt;
   s_sm_sc_shrt_intf                            sm_sc_shrt_intf_df_eob;
   s_sm_seq_id_intf                             sm_seq_id_intf_nxt;
   tlv_cmd_word_1_t                             tlv_cmd_word_1;  
   tlv_data_word_0_t                            tlv_data_word_0;
   
   always_comb begin
      usr_wr_mux                                  = usr_wr | usr_wr_lz77;
      lz_symbol_bus_df_eob                        = 0;
      lz_symbol_bus_df_eob.framing                = 1;
      lz_symbol_bus_df_eob.length                 = 16'hffff;
      lz_symbol_bus_df_eob.offset_msb             = 8'hff;
      lz_symbol_bus_df_eob.data0                  = 8'hff;
      lz_symbol_bus_df_eob.backref                = 1;
      lz_symbol_bus_df_eob.backref_type           = 1;
      sm_sc_shrt_intf_df_eob                      = 0;
      sm_sc_shrt_intf_df_eob.wr                   = 1;
      sm_sc_shrt_intf_df_eob.vld                  = 4'b0001;
      sm_sc_shrt_intf_df_eob.shrt0                = 256;
      sm_sc_shrt_intf_df_eob.seq_id               = seq_id_lst;
      sm_sc_shrt_intf_df_eob.eob                  = END_BLK;
      
      if ((sm_seq_id_intf.comp_mode == ZLIB) || (sm_seq_id_intf.comp_mode == GZIP))
	deflate                                   = 1;
      else
	deflate                                   = 0;
      
      if ((sm_seq_id_intf.comp_mode == CHU4K) || (sm_seq_id_intf.comp_mode == CHU8K))
	chu_mode                                  = 1;
      else
	chu_mode                                  = 0;
       
      if ((seq_id + 1) == `CREOLE_HC_SEQID_NUM)
	seq_id_nxt                                = 0;
      else
	seq_id_nxt                                = seq_id + 1;

      if ((predet_mem_id + 1) == `CREOLE_HC_SEQID_NUM)
	predet_mem_id_nxt                         = 0;
      else
	predet_mem_id_nxt                         = predet_mem_id + 1;

      
      
      if (sm_seq_id_wr_intf.vld) begin
	 raw_byte_count_lst                       = 0;
	 extra_bit_count_lst                      = 0;  
      end
      else begin
	 raw_byte_count_lst                       = sm_seq_id_intf.raw_byte_count;
	 extra_bit_count_lst                      = sm_seq_id_intf.extra_bit_count; 
      end
      extra_bit_count_nxt                         = 0;
      sym_entry_count_nxt                         = 0;
      sm_sc_long_intf_nxt                         = 0;
      tlv_cmd_word_2                              = term_tlv.tdata;
      tlv_data_word_0                             = term_tlv.tdata;
      mux_symbol_map_intf                         = df_symbol_map_intf;
      mux_symbol_map_intf.long_vld                = lz_symbol_bus.backref;
      sm_seq_id_intf_nxt.predet_mem_mask          = 0;
      sm_seq_id_intf_nxt.predet_mem_id            = predet_mem_id;
      sm_seq_id_intf_nxt.comp_mode                = cmd_comp_mode_e'(tlv_cmd_word_2.comp_mode);
      sm_seq_id_intf_nxt.lz77_win_size            = cmd_lz77_win_size_e'(tlv_cmd_word_2.lz77_win_size);
      sm_seq_id_intf_nxt.lz77_min_match_len       = cmd_lz77_min_match_len_e'(tlv_cmd_word_2.lz77_min_match_len);
      sm_seq_id_intf_nxt.xp10_prefix_mode         = cmd_xp10_prefix_mode_e'(tlv_cmd_word_2.xp10_prefix_mode);
      sm_seq_id_intf_nxt.xp10_user_prefix_size    = tlv_cmd_word_2.xp10_user_prefix_size;
      sm_seq_id_intf_nxt.xp10_crc_mode            = cmd_xp10_crc_mode_e'(tlv_cmd_word_2.xp10_crc_mode);
      sm_seq_id_intf_nxt.chu_comp_thrsh           = cmd_chu_comp_thrsh_e'(tlv_cmd_word_2.chu_comp_thrsh);
      sm_seq_id_intf_nxt.tid                      = term_tlv.tid;
      sm_seq_id_intf_nxt.tuser                    = term_tlv.tuser;
      sm_seq_id_intf_nxt.raw_byte_count           = 0;
      sm_seq_id_intf_nxt.extra_bit_count          = 0;
      sm_seq_id_intf_nxt.blk_count                = 0;
      sm_seq_id_intf_nxt.blk_last                 = 0;
      sm_seq_id_intf_nxt.pdh_crc_err              = sm_seq_id_intf.pdh_crc_err;
      sm_seq_id_intf_nxt.raw_crc                  = sm_seq_id_intf.raw_crc;
      lz_symbol_bus                               = term_tlv.tdata;
      tlv_cmd_word_1                              = term_tlv.tdata;
      usr_tlv_nxt                                 = term_tlv;
      sm_sq_intf.data                             = tlvp_out.tdata;
      sm_sq_intf.tlast                            = tlvp_out.tlast;
      sm_sq_intf.seq_id                           = tlvp_out.tuser[5:2];
      sm_sq_intf.eob                              = tlvp_out.tuser[6];
      sm_sq_intf.sot                              = tlvp_out.tuser[0];
      sm_sq_intf.eot                              = tlvp_out.tuser[1];
      byte_vld_pre                                = (tlvp_out.tstrb[7] + tlvp_out.tstrb[6] + tlvp_out.tstrb[5] + tlvp_out.tstrb[4]  +
	                                             tlvp_out.tstrb[3] + tlvp_out.tstrb[2] + tlvp_out.tstrb[1] + tlvp_out.tstrb[0]) -1;
      sm_sq_intf.byte_vld                         = byte_vld_pre[2:0];
      if (pdh_wr & (pdh_addr_out <= `CREOLE_HC_LAST_SHORT_PDH))
	sm_predet_mem_shrt_intf.wr                = 1;
      else
	sm_predet_mem_shrt_intf.wr                = 0;
      sm_predet_mem_shrt_intf.mem_id              = predet_mem_id;
      sm_predet_mem_shrt_intf.addr                = pdh_addr_out[5:0];
      sm_predet_mem_shrt_intf.data                = pdh_data;
      if (pdh_wr && (pdh_addr_out >  `CREOLE_HC_LAST_SHORT_PDH) && (pdh_addr_out <= `CREOLE_HC_LAST_LONG_PDH))
	sm_predet_mem_long_intf.wr                = 1;
      else
	sm_predet_mem_long_intf.wr                = 0;
      sm_predet_mem_long_intf.mem_id              = predet_mem_id;
      sm_predet_mem_long_intf.addr                = pdh_addr_out - (`CREOLE_HC_LAST_SHORT_PDH +1);
      sm_predet_mem_long_intf.data                = pdh_data; 
      if (pdh_accum_wr)
	pdh_data_in                               = pdh_data_in_reg;
      else
	pdh_data_in                               = term_tlv.tdata;
      term_rdy                                    = 0;
      xfer_rdy                                    = 0;      
      if (sm_seq_id_intf.comp_mode == XP9)
	xp9                                       = 1;
      else
	xp9                                       = 0;
      sm_sc_shrt_intf_nxt.shrt0                   = {2'd0, lz_symbol_bus.data0};
      sm_sc_shrt_intf_nxt.shrt1                   = {2'd0, lz_symbol_bus.data1};
      sm_sc_shrt_intf_nxt.shrt2                   = {2'd0, lz_symbol_bus.data2};
      sm_sc_shrt_intf_nxt.shrt3                   = {2'd0, lz_symbol_bus.data3};
      raw_byte_count_nxt_pre                      = {1'd0, raw_byte_count_lst};
      raw_byte_count_nxt                          = raw_byte_count_nxt_pre[`N_RAW_SIZE_WIDTH-1:0];
      extra_bit_count_nxt_pre                     = {1'd0, extra_bit_count_lst};
      tlv_word_count_nxt                          = tlv_word_count;
      sm_sc_shrt_intf_nxt.vld                     = 0;
      sm_sc_shrt_intf_nxt.wr                      = 1;
      sm_sc_shrt_intf_nxt.seq_id                  = seq_id;
      sm_sc_long_intf_nxt.vld                     = 0;
      sm_sc_long_intf_nxt.wr                      = 1;
      sm_sc_long_intf_nxt.seq_id                  = seq_id;
      sm_sc_shrt_intf_nxt.eob                     = MIDDLE;
      sm_sc_long_intf_nxt.eob                     = MIDDLE;
      usr_tlv_nxt.tuser[6:2]                      = {1'd0, seq_id};
      
     
      
      term_aempty                                 = (term_used_slots <= 1);
      term_afull                                  = (term_free_slots <= 1);
      sc_sm_shrt_intf_rdy                         = sc_sm_shrt_intf.rdy & ~((state == SM_FRM_IDL) & ((term_tlv.typen == PHD) | (term_tlv.typen == FRMD_USER_NULL)) & sm_block_stall & seq_id_active[seq_id]);
      
      
      
      if ((!term_aempty)                || (!term_empty && term_aempty && !term_rd))
	term_rdy    = 1;
      if (term_rdy && sq_sm_intf.rdy && sc_sm_shrt_intf_rdy && sc_sm_long_intf.rdy && (!usr_afull || (!usr_full && usr_afull && !usr_wr_mux))) begin
	 xfer_rdy   = 1'd1;
	 
      end

      if (term_rd) begin
	 tlv_word_count_nxt   = tlv_word_count + 1;
      end
      
      if (sm_seq_id_intf.comp_mode > GZIP) begin
	 mux_symbol_map_intf  = xp_symbol_map_intf;
      end
      
      case (lz_symbol_bus.backref_lane)
	2'd0 : begin
	   ofs     = {lz_symbol_bus.offset_msb, lz_symbol_bus.data0};
	   mtf_num =  lz_symbol_bus.data0[`N_MAX_MTF_WIDTH-1:0] ;
	end
	2'd1 : begin
	   ofs     = {lz_symbol_bus.offset_msb, lz_symbol_bus.data1};
	   mtf_num =  lz_symbol_bus.data1[`N_MAX_MTF_WIDTH-1:0];
	end
	2'd2 : begin
	   ofs     = {lz_symbol_bus.offset_msb, lz_symbol_bus.data2};
	   mtf_num =  lz_symbol_bus.data2[`N_MAX_MTF_WIDTH-1:0];
	end
	default : begin
	   ofs     = {lz_symbol_bus.offset_msb, lz_symbol_bus.data3};
	   mtf_num =  lz_symbol_bus.data3[`N_MAX_MTF_WIDTH-1:0];
	end
      endcase       
      
      case (state)
	SM_IDLE:  usr_tlv_nxt.tuser[6:2] = {1'd0, seq_id}; 
	SM_DATA:  begin
	   sm_sc_shrt_intf_nxt.eob = PASS_THRU;
	   sm_sc_long_intf_nxt.eob = PASS_THRU;
	   if (term_tlv.tuser[1]) begin
	      usr_tlv_nxt.tuser[6:2] = {1'd1, seq_id}; 
	   end
	end
	
	SM_LZ77: begin
	   sym_entry_count_nxt      = sym_entry_count + 1;
	   
	   if (term_tlv.tuser[1]) begin
	      usr_tlv_nxt.tuser[6:2]                = {1'd1, seq_id}; 
	      sm_sc_shrt_intf_nxt.eob               = END_FRM;
	      sm_sc_long_intf_nxt.eob               = END_FRM;
	   end
	   
	   else begin
	      case (lz_symbol_bus.framing) 
		4'd1:     sm_sc_shrt_intf_nxt.vld  = 4'b0001;
		4'd2:     sm_sc_shrt_intf_nxt.vld  = 4'b0011;
		4'd3:     sm_sc_shrt_intf_nxt.vld  = 4'b0111;
		4'd4:     sm_sc_shrt_intf_nxt.vld  = 4'b1111;
		default:  sm_sc_shrt_intf_nxt.vld  = 4'b0000;
	      endcase
	      
	      if (!lz_symbol_bus.backref) begin
		 raw_byte_count_nxt_pre   = raw_byte_count_lst   + lz_symbol_bus.framing;
	      end
	      
	      else begin
		 raw_byte_count_nxt_pre   = raw_byte_count_lst   + lz_symbol_bus.framing - 1 + lz_symbol_bus.length;
		 extra_bit_count_nxt_pre  = extra_bit_count_lst  + mux_symbol_map_intf.len_xtr_bits_len + mux_symbol_map_intf.ofs_xtr_bits_len;
		 case (lz_symbol_bus.backref_lane)
		   2'd0: sm_sc_shrt_intf_nxt.shrt0  = mux_symbol_map_intf.shrt;
		   2'd1: sm_sc_shrt_intf_nxt.shrt1  = mux_symbol_map_intf.shrt;
		   2'd2: sm_sc_shrt_intf_nxt.shrt2  = mux_symbol_map_intf.shrt;
		   2'd3: sm_sc_shrt_intf_nxt.shrt3  = mux_symbol_map_intf.shrt;
		 endcase 
		 sm_sc_long_intf_nxt.vld            = mux_symbol_map_intf.long_vld;
		 sm_sc_long_intf_nxt.wr             = mux_symbol_map_intf.long_vld;
		 sm_sc_long_intf_nxt.long           = mux_symbol_map_intf.long;
	      end
	      raw_byte_count_nxt                    = raw_byte_count_nxt_pre[`N_RAW_SIZE_WIDTH-1:0];
	      
	      
	      if ((((sm_seq_id_intf.comp_mode == XP9)  && (sm_seq_id_intf.blk_count == 0) && (raw_byte_count_nxt >= {1'b0, sw_henc_xp9_first_blk_thrsh})  && !inc_blk_count)                                             ||
		   
		   ((sm_seq_id_intf.comp_mode == XP9)  && ((sm_seq_id_intf.blk_count >  0) || (inc_blk_count)) && ((sym_entry_count_nxt > sw_henc_huff_win_size_in_entries) || (sw_henc_huff_win_size_in_entries == 1))) ||
		   
		   (((sm_seq_id_intf.comp_mode == XP10) || (sm_seq_id_intf.comp_mode == ZLIB) || (sm_seq_id_intf.comp_mode == GZIP))  &&
		    ((sym_entry_count_nxt > sw_henc_huff_win_size_in_entries) ||  (sw_henc_huff_win_size_in_entries == 1))))          &&
		  
		  (term_tlv_nxt.tuser[1] != 1)) begin
		 sm_sc_long_intf_nxt.eob = END_BLK;
		 sm_sc_shrt_intf_nxt.eob = END_BLK;
		 sm_sc_long_intf_nxt.wr  = 1;       
		 sym_entry_count_nxt     = 0;
		 usr_tlv_nxt.tuser[6:2]  = {~deflate, seq_id}; 
	      end      
	   end
	   if (term_rd) begin
	      extra_bit_count_nxt        = extra_bit_count_nxt_pre[`N_EXTRA_BITS_TOT_WIDTH-1:0];
	   end
	   else begin
	      extra_bit_count_nxt        = extra_bit_count_lst;
	      raw_byte_count_nxt         = raw_byte_count_lst;
	   end
	   if (insert_df_eob) begin
	      usr_tlv_nxt.tuser[6:2]     = {1'b1, seq_id_lst};
	      usr_tlv_nxt.tdata          = lz_symbol_bus_df_eob;
	   end
	end 
	
	
	default: usr_tlv_nxt.tuser[6:2]  = {1'd0, seq_id}; 
      endcase 

      
      if ((sm_sc_shrt_intf.eob == END_BLK) && (sm_sc_shrt_intf_nxt.eob != END_FRM))
	stall_eob = 1;
      else
	stall_eob = 0;
      
      if (sm_sc_shrt_intf_nxt.eob == END_BLK)
	eob = 1;
      else
	eob = 0;
      if (sm_sc_shrt_intf_nxt.eob == END_FRM)
	eof = 1;
      else
	eof = 0;

      if (usr_wr_lz77)
	usr_tlv_nxt_mux = usr_tlv_nxt_reg;
      else
	usr_tlv_nxt_mux = usr_tlv_nxt;
   
   end

   
   always_ff @(negedge rst_n or posedge clk) begin
      if (!rst_n) begin
	 state                             <= SM_IDLE;
	 sm_sc_long_intf.eob               <= e_pipe_eob'(MIDDLE);
	 sm_sc_shrt_intf.eob               <= e_pipe_eob'(MIDDLE);
	 sm_seq_id_intf.chu_comp_thrsh     <= cmd_chu_comp_thrsh_e'(FRM);
	 sm_seq_id_intf.comp_mode          <= cmd_comp_mode_e'(NONE);
	 sm_seq_id_intf.lz77_min_match_len <= cmd_lz77_min_match_len_e'(CHAR_4);
	 sm_seq_id_intf.lz77_win_size      <= cmd_lz77_win_size_e'(WIN_64K);
	 sm_seq_id_intf.xp10_crc_mode      <= cmd_xp10_crc_mode_e'(CRC32);
	 sm_seq_id_intf.xp10_prefix_mode   <= cmd_xp10_prefix_mode_e'(NO_PREFIX);
	 sm_seq_id_intf.blk_count          <= 0;
	 sm_seq_id_intf.extra_bit_count    <= 0;
	 sm_seq_id_intf.predet_mem_id      <= 0;
	 sm_seq_id_intf.predet_mem_mask    <= 0;
	 sm_seq_id_intf.raw_byte_count     <= 0;
	 sm_seq_id_intf.tid                <= 0;
	 sm_seq_id_intf.tuser              <= 0;
	 sm_seq_id_intf.pdh_crc_err        <= 0;
	 
	 
	 compound_cmd <= 0;
	 crc32_pdh <= 0;
	 first_xfer_done <= 0;
	 inc_blk_count <= 0;
	 inc_predet_mem_id <= 0;
	 insert_df_eob <= 0;
	 lz77_stall_stb <= 0;
	 pdh_accum_in <= 0;
	 pdh_accum_in_size <= 0;
	 pdh_accum_wr <= 0;
	 pdh_addr <= 0;
	 pdh_addr_out <= 0;
	 pdh_data <= 0;
	 pdh_data_in_reg <= 0;
	 pdh_wr <= 0;
	 predet_mem_id <= 0;
	 seq_id <= 0;
	 seq_id_active <= 0;
	 seq_id_check <= 0;
	 seq_id_lst <= 0;
	 sm_bip2_reg <= 0;
	 sm_block_stall <= 0;
	 sm_sc_long_intf <= 0;
	 sm_sc_long_intf.wr <= 0;
	 sm_sc_shrt_intf <= 0;
	 sm_sc_shrt_intf.shrt0 <= 0;
	 sm_sc_shrt_intf.vld <= 0;
	 sm_sc_shrt_intf.wr <= 0;
	 sm_seq_id_intf <= 0;
	 sm_seq_id_intf.blk_last <= 0;
	 sm_seq_id_intf.raw_crc <= 0;
	 sm_seq_id_wr_intf.seq_id <= 0;
	 sm_seq_id_wr_intf.vld <= 0;
	 sm_seq_id_wr_intf.vld_crc <= 0;
	 sm_sq_intf.wr <= 0;
	 sym_entry_count <= 0;
	 term_empty_reg <= 0;
	 term_rd <= 0;
	 term_rd_pre <= 0;
	 tlv_word_count <= 0;
	 tlvp_out_rd <= 0;
	 trace <= 0;
	 usr_tlv_nxt_reg <= 0;
	 usr_tlv_nxt_reg.tuser <= 0;
	 usr_wr <= 0;
	 usr_wr_lz77 <= 0;
	 
      end
      else begin
	 sm_bip2_reg               <= crc_error;
	 sm_sc_shrt_intf.wr        <= 0;
	 sm_sc_long_intf.wr        <= 0;
	 tlvp_out_rd               <= 0;
	 term_rd                   <= 0;
	 usr_wr                    <= 0;
	 usr_wr_lz77               <= 0;
	 sm_sq_intf.wr             <= 0;
	 sm_seq_id_wr_intf.vld     <= 0;
	 sm_seq_id_wr_intf.vld_crc <= 0;
	 pdh_wr                    <= 0;
	 inc_blk_count             <= 0;
	 inc_predet_mem_id         <= 0;
	 if (inc_predet_mem_id)
	   predet_mem_id           <= predet_mem_id_nxt;
	 if ((!term_aempty_pre || (!term_empty_pre && term_aempty_pre && !term_rd_pre)) &&
	     (!term_afull      || (!term_full      && term_afull      && !term_rd_pre)))
	   term_rd_pre             <= 1;
	 else
	   term_rd_pre             <= 0;
	 if (inc_blk_count) begin
	    sm_seq_id_intf.blk_count       <= sm_seq_id_intf.blk_count+1;
	 end
	 if (sm_seq_id_wr_intf.vld) begin
	    sm_seq_id_intf.raw_byte_count  <= raw_byte_count_nxt;
	    sm_seq_id_intf.extra_bit_count <= extra_bit_count_nxt;
	 end
	 
	 if (sq_sm_intf.rdy && 
	       (!tlvp_out_aempty  || 
	       (!tlvp_out_empty &&  tlvp_out_aempty && !tlvp_out_rd))) begin
	    tlvp_out_rd         <= 1;
	    sm_sq_intf.wr       <= 1;
	 end
	 
	 if (sa_sm_intf.vld) begin
	    seq_id_active[sa_sm_intf.seq_id] <= 1'd0;                            
	 end
	 case (state)
	   SM_IDLE: begin
	      first_xfer_done                       <= 0;
	      if (!seq_id_check) begin
		 seq_id_check                       <= 1;
		 if (!seq_id_active[seq_id]) begin                             
		    seq_id_active[seq_id]           <= 1;                      
		    sm_block_stall                  <= 0;
		 end
		 else
		   sm_block_stall                   <= 1;
	      end
	      if (xfer_rdy) begin
		 term_rd                            <= 1;
		 usr_wr                             <= 1;
	      end
	      if (term_rd) begin
		 sm_seq_id_intf.blk_count           <= 0;
		 sm_seq_id_intf.raw_byte_count      <= 0;
		 sm_seq_id_intf.extra_bit_count     <= 0;
		 sm_seq_id_intf.pdh_crc_err         <= 0;
		 sym_entry_count                    <= 1;
		 sm_sc_long_intf.eob                <= e_pipe_eob'(MIDDLE);
		 sm_sc_shrt_intf.eob                <= e_pipe_eob'(MIDDLE);
		 if (term_tlv.tuser[0]) begin
		    if (!term_tlv.tuser[1])
		      state <= SM_OTHR;
		    else
		      state <= SM_IDLE;
		 end
	      end
	   end 
	  
	   
	   SM_FRM_IDL: begin
	      first_xfer_done     <= 0;
	      if (xfer_rdy) begin
		 tlv_word_count   <= 1;
		 term_rd          <= 1;
		 usr_wr           <= 1;
	      end
	      if (term_rd) begin
		 if (term_tlv.tuser[0]) begin
		    if (!term_tlv.tuser[1]) begin
		       case (term_tlv.typen)
			 CMD: begin
			    state <= SM_CMD;
			    if (sm_block_stall) begin
			       term_rd  <= 0;
			       usr_wr   <= 0;
			    end
			 end
			 FTR:  state    <= SM_FTR;
			 LZ77: begin
			    state       <= SM_LZ77;
			    term_rd     <= 0;
			    usr_wr      <= 0;
			 end
			 DATA_UNK,
			 DATA: begin
			    state       <= SM_DATA;
			    if (tlv_data_word_0.last_of_command)
			      compound_cmd <= 0;
			 end
			 PHD: begin
			    crc32_pdh   <= 32'hffffffff;
			    state       <= SM_PHD;
			 end   
			 default: state <= SM_OTHR;
		       endcase
		    end 
		 end
	      end 
	   end
	   
	   SM_DATA: begin
	      if (sm_block_stall) begin
		 if (!seq_id_active[seq_id]) begin                         
		    sm_block_stall               <= 0;
		    seq_id_active[seq_id]        <= 1;               
		 end
	      end
	      else begin
		 if (xfer_rdy) begin
		    term_rd                      <= 1;
		    usr_wr                       <= 1;
		 end		 
		 if (term_rd) begin
		    if (!first_xfer_done) begin
		       first_xfer_done           <= 1;
		       sm_sc_shrt_intf           <= sm_sc_shrt_intf_nxt;
		       sm_sc_long_intf           <= sm_sc_long_intf_nxt;
		       sm_seq_id_wr_intf.vld     <= 1;
		       sm_seq_id_wr_intf.seq_id  <= seq_id;
		    end
		    if (term_tlv.tuser[1]) begin
		       term_rd                   <= 0;
		       usr_wr                    <= 0;
		       seq_id                    <= seq_id_nxt;
		       state                     <= SM_FRM_IDL;
		       if (compound_cmd) begin
			  if (seq_id_active[seq_id_nxt]) begin            
			     sm_block_stall            <= 1;
			     term_rd                   <= 0;
			  end
			  else begin
			     seq_id_active[seq_id_nxt] <= 1;
			  end
		       end
		    end
		 end
	      end 
	   end
	   
	   SM_LZ77: begin
	      term_empty_reg                              <= term_empty;
	      lz77_stall_stb                              <= term_empty & ~term_empty_reg & trace;
	      
	      if (sm_block_stall) begin
		 if (!seq_id_active[seq_id]) begin                                     
		    sm_block_stall                        <= 0;
		    seq_id_active[seq_id]                 <= 1;                        
		 end
	      end
	      else begin
		 if (xfer_rdy && (term_used_slots > 2)) begin
		    term_rd                               <= ~term_aempty;
		    if (insert_df_eob) begin
		       insert_df_eob                      <= 0;
		       sm_sc_shrt_intf                    <= sm_sc_shrt_intf_df_eob;
		       usr_wr_lz77                        <= 1;
		       usr_tlv_nxt_reg                    <= usr_tlv_nxt;
		    end
		 end
		 if (!insert_df_eob) begin
		    if (term_rd) begin
		       sm_sc_shrt_intf                    <= sm_sc_shrt_intf_nxt;
		       sm_sc_long_intf                    <= sm_sc_long_intf_nxt;
		       sym_entry_count                    <= sym_entry_count_nxt;
		       sm_seq_id_intf.raw_byte_count      <= raw_byte_count_nxt;
		       sm_seq_id_intf.extra_bit_count     <= extra_bit_count_nxt;
		       usr_wr_lz77                        <= 1;
		       usr_tlv_nxt_reg                    <= usr_tlv_nxt;
		    end
		    if (term_rd && !term_tlv.tuser[0]) begin
		       if (eob || eof) begin
			  sm_seq_id_wr_intf.vld           <= 1;
			  sm_seq_id_wr_intf.seq_id        <= seq_id;
			  inc_blk_count                   <= 1;
			  seq_id                          <= seq_id_nxt;
			  if (eob && deflate)
			    begin
			       insert_df_eob              <= 1;
			       term_rd                    <= 0;
			       seq_id_lst                 <= seq_id;
			       sm_sc_shrt_intf.eob        <= MIDDLE;
			       usr_tlv_nxt_reg.tuser[6]   <= 0;
			    end
			  if (eob || (eof && chu_mode)) begin
			     sym_entry_count              <= 1;
			     if (seq_id_active[seq_id_nxt]) begin            
				sm_block_stall            <= 1;
				term_rd                   <= 0;
			     end
			     else begin
				seq_id_active[seq_id_nxt] <= 1;
			     end
			  end
			  if (eof) begin
			     term_rd                      <= 0;
			     sm_seq_id_intf.blk_last      <= 1'd1;
			     state                        <= SM_FRM_IDL;
			     if (deflate) begin
				sm_sc_shrt_intf.vld       <= 4'b0001;
				sm_sc_shrt_intf.shrt0     <= 10'd256;
			     end
			  end
		       end
		    end 
		 end 
	      end 
	   end 
	   
	   
	   SM_CMD: begin
	      if (sm_block_stall) begin
		 if (!seq_id_active[seq_id]) begin
		    sm_block_stall               <= 0;
		    seq_id_active[seq_id]        <= 1;
		 end
	      end
	      else begin
		 if (xfer_rdy) begin
		    term_rd                      <= 1;
		    usr_wr                       <= 1;
		 end
		 if (term_rd) begin
		    if (!term_tlv.tuser[0])
		      tlv_word_count             <= tlv_word_count_nxt;
		    if (tlv_word_count == 5'd1) begin
		       trace                     <= tlv_cmd_word_1.trace;
		       if ((tlv_cmd_word_1.compound_cmd_frm_size == COMPND_4K) || (tlv_cmd_word_1.compound_cmd_frm_size == COMPND_8K))
			 compound_cmd            <= 1;
		       else
			 compound_cmd            <= 0;
		    end
		    if (tlv_word_count == 5'd2) begin
		       term_rd                   <= 0;
		       usr_wr                    <= 0;
		       state                     <= SM_FRM_IDL;
		       sm_seq_id_intf            <= sm_seq_id_intf_nxt;
		       sm_seq_id_wr_intf.vld     <= 1;
		       sm_seq_id_wr_intf.seq_id  <= seq_id;
		       if (compound_cmd && (tlv_cmd_word_2.comp_mode == NONE))
			 compound_cmd            <= 1;
		       else
			 compound_cmd            <= 0;
		    end     
		 end 
	      end 
	   end
	   
	   SM_FTR: begin
	      if (xfer_rdy) begin
		 term_rd                   <= 1;
		 usr_wr                    <= 1;
	      end
	      if (term_rd) begin
		 if (!term_tlv.tuser[0])
		   tlv_word_count          <= tlv_word_count_nxt;
		 if (term_tlv.tuser[1]) begin
		    term_rd                   <= 0;
		    usr_wr                    <= 0;	 
		    state                     <= SM_FRM_IDL;
		 end
		 if (tlv_word_count == 5'd6) begin
		    sm_seq_id_wr_intf.vld_crc      <= 1;
		    sm_seq_id_intf.raw_crc         <= term_tlv.tdata;
		    sm_seq_id_intf.predet_mem_mask <= 0;
		    sm_seq_id_intf.pdh_crc_err     <= 0;
		 end     
	      end
	   end
	   
	   SM_PHD: begin
	      if (xfer_rdy) begin
		 term_rd               <= 1;
		 usr_wr                <= 1;
	      end
	      pdh_data                 <= pdh_data_out;
	      
	      if (pdh_accum_wr && xfer_rdy) begin
		 pdh_wr                <= 1;
		 pdh_addr              <= pdh_addr + 1;
		 pdh_addr_out          <= pdh_addr;
		 pdh_accum_in          <= {4'd0, pdh_accum_out};
		 pdh_accum_in_size     <= pdh_accum_out_size;
		 crc32_pdh             <= crc32(pdh_data_in, crc32_pdh, 64);
		 pdh_accum_wr          <= 0;
	      end
	      if (term_rd && !term_tlv.tuser[0]) begin
		 crc32_pdh             <= crc32(pdh_data_in, crc32_pdh, 64);
		 pdh_addr              <= pdh_addr + 1;
		 pdh_addr_out          <= pdh_addr;
		 pdh_accum_in          <= {4'd0, pdh_accum_out};
		 pdh_accum_in_size     <= pdh_accum_out_size;
		 pdh_wr                <= 1;
		 
		 if (pdh_data_out_cnt > 1) begin
		    pdh_data_in_reg    <= term_tlv.tdata;
		    term_rd            <= 0;
		    usr_wr             <= 0;
		    pdh_accum_in       <= pdh_accum_in;
		    pdh_accum_in_size  <= pdh_accum_in_size;
		    crc32_pdh          <= crc32_pdh;
		    pdh_accum_wr       <= 1;
		 end
		 if (term_tlv.tuser[1]) begin
		    if (crc32_pdh != ~pdh_data_in[31:0])
		      sm_seq_id_intf.pdh_crc_err <= 1;
		    else
		      sm_seq_id_intf.pdh_crc_err <= 0;
		    sm_seq_id_intf.predet_mem_id       <= predet_mem_id;
		    sm_seq_id_intf.predet_mem_mask     <= 1;
		    inc_predet_mem_id                  <= 1;
		    pdh_wr                             <= 1;
		    pdh_addr                           <= 0;
		    pdh_addr_out                       <= pdh_addr;
		    pdh_accum_in                       <= 0;
		    pdh_accum_in_size                  <= 0;
		    term_rd                            <= 0;
		    usr_wr                             <= 0;
		    state                              <= SM_FRM_IDL;
		 end
	      end 
	   end
	   
	   SM_OTHR: begin
	      if (xfer_rdy) begin
		 term_rd            <= 1;
		 usr_wr             <= 1;
	      end
	      if (term_rd) begin
		 if (term_tlv.tuser[1]) begin
		    term_rd         <= 0;
		    usr_wr          <= 0;
		    if (term_tlv.tlast) begin
		       seq_id_check <= chu_mode;
		       state        <= SM_IDLE;
		    end
		    else
		      state         <= SM_FRM_IDL;
		 end
	      end 
	   end
	   default: begin
	      seq_id_check    <= 0;
	      state           <= SM_IDLE;
	   end
	   
	 endcase
      end 
   end
   
   
   
   
   
     
   cr_huf_comp_sm_tlvp_top cr_huf_comp_sm_tlvp_top
     (
      
      .axi4s_ib_out			(huf_comp_ib_out),	 
      .term_empty			(term_empty_pre),	 
      .term_aempty			(term_aempty_pre),	 
      .term_tlv				(term_tlv_pre),		 
      .usr_full				(usr_full),
      .usr_afull			(usr_afull),
      .crc_error			(crc_error),
      .tlvp_out				(tlvp_out),
      .tlvp_out_aempty			(tlvp_out_aempty),
      .tlvp_out_empty			(tlvp_out_empty),
      
      .clk				(clk),
      .rst_n				(rst_n),
      .axi4s_ib_in			(huf_comp_ib_in),	 
      .module_id			(huf_comp_module_id),	 
      .tlv_parse_action			({sw_sm_in_tlv_parse_action_1,sw_sm_in_tlv_parse_action_0}), 
      .term_rd				(term_rd_pre),		 
      .usr_wr				(usr_wr_mux),		 
      .usr_tlv				(usr_tlv_nxt_mux),	 
      .tlvp_out_rd			(tlvp_out_rd));

   
   
   cr_huf_comp_sm_fifo
     #(.DEPTH (8),
       .WIDTH (106))
   cr_huf_comp_sm_fifo
     (
      
      .empty				(term_empty),		 
      .full				(term_full),		 
      .underflow			(),			 
      .overflow				(),			 
      .used_slots			(term_used_slots),	 
      .free_slots			(term_free_slots),	 
      .rdata				(term_tlv),		 
      .rdata_nxt			(term_tlv_nxt),		 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .wen				(term_rd_pre),		 
      .ren				(term_rd),		 
      .clear				(1'd0),			 
      .wdata				(term_tlv_pre));		 
   

   
   
   
   
   cr_huf_comp_sm_deflate cr_huf_comp_sm_deflate
     (
      
      .df_symbol_map_intf		(df_symbol_map_intf),	 
      
      .len				(lz_symbol_bus.length),	 
      .ofs				(ofs[`N_WINDOW_WIDTH-1:0]));
   
   
   
   
   
   cr_huf_comp_sm_xp cr_huf_comp_sm_xp
     (
      
      .xp_symbol_map_intf		(xp_symbol_map_intf),	 
      .mtf_offset_out_0			(),			 
      .mtf_offset_out_1			(),			 
      .mtf_offset_out_2			(),			 
      .mtf_offset_out_3			(),			 
      
      .xp9				(xp9),
      .min_len				({sm_seq_id_intf.lz77_min_match_len}), 
      .mtf				(lz_symbol_bus.backref_type), 
      .mtf_num				(mtf_num),		 
      .len				(lz_symbol_bus.length),	 
      .ofs				(ofs),			 
      .win_size				({sm_seq_id_intf.lz77_win_size}), 
      .mtf_offset_0			(16'd0),		 
      .mtf_offset_1			(16'd0),		 
      .mtf_offset_2			(16'd0),		 
      .mtf_offset_3			(16'd0),		 
      .prev_mtf_or_ptr			(1'd0));			 

   
   
   
   
   nx_bit_pack 
     #(.IN_W   (`AXI_S_DP_DWIDTH),
       .OUT_W  (`CREOLE_HC_PHT_WIDTH), 
       .ACC_W  (`AXI_S_DP_DWIDTH))
   ph_bit_pack
     (
      
      .data_out_cnt			(pdh_data_out_cnt),	 
      .data_out				(pdh_data_out),		 
      .accum_out			(pdh_accum_out),	 
      .accum_out_size			(pdh_accum_out_size),	 
      
      .data_in				(pdh_data_in),		 
      .data_in_size			(7'd64),		 
      .accum_in				(pdh_accum_in),		 
      .accum_in_size			(pdh_accum_in_size),	 
      .data_out_index			(pdh_accum_wr));		 
   
   `CCX_STD_DECLARE_CRC(crc32, 32'h82f63b78, 32, 64)  
   
endmodule 








