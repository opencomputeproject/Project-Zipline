
/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/












`include "cr_lz77_comp_pkg_include.vh"
`include "messages.vh"
`include "ccx_std.vh"

module cr_lz77_comp_prc
  (
   
   prc_prs_rd, prc_lec_min_match_len, prc_lec_max_match_len,
   prc_lec_dly_match_win, prc_lec_win_size, prc_lec_num_mtf,
   prc_lec_min_mtf_len, prc_lec_isXp9, prc_lec_sample_data,
   prc_lec_sample_data_vld, prc_lec_prefix_data,
   prc_lec_prefix_data_vld, prc_lec_sample_eot, prc_lec_count,
   prc_lob_valid, prc_lob_tlv_if, prc_lob_is_compressed,
   prc_lob_enable_stats, sw_LZ77_COMP_DEBUG_STATUS, prc_debug,
   lz77_clk_en, throttled_frame_ev,
   
   clk, rst_n, prs_prc_empty, prs_prc_aempty, prs_prc_tlv_if,
   lob_prc_full, lob_prc_credit, sw_COMPRESSION_CFG,
   sw_POWER_CREDIT_BURST, sw_TLV_PARSE_ACTION, lec_prc_lz_error,
   lz77_comp_module_id, debug_status_read
   );
 
 
   
`include "cr_lz77_comp_includes.vh"

   
   
   
   input                   clk;
   input                   rst_n; 
   
   
   
   
   output                  prc_prs_rd;
   input                   prs_prc_empty;
   input                   prs_prc_aempty;
   input                   tlvp_if_bus_t  prs_prc_tlv_if;
   
   
   
   
   output                  prc_lec_min_match_len;
   output [1:0]            prc_lec_max_match_len;
   output [1:0]            prc_lec_dly_match_win;
   output [2:0]            prc_lec_win_size;
   output                  prc_lec_num_mtf;
   output                  prc_lec_min_mtf_len;
   output 		   prc_lec_isXp9;
   output logic [31:0]     prc_lec_sample_data;
   output logic  [3:0]     prc_lec_sample_data_vld;
   output logic  [63:0]    prc_lec_prefix_data;
   output logic  [7:0]     prc_lec_prefix_data_vld;
   output logic            prc_lec_sample_eot;
   output logic  [7:0]     prc_lec_count;
   
   
   
   
   input                   lob_prc_full;    
   input                   lob_prc_credit;  
   output                  prc_lob_valid;
   output                  tlvp_if_bus_t prc_lob_tlv_if;
   
   
   
   output                  prc_lob_is_compressed;
   
   
   output 		   prc_lob_enable_stats;
   
   
   
   
   
   
   input                   compression_cfg_t         sw_COMPRESSION_CFG;
   input                   power_credit_burst_t      sw_POWER_CREDIT_BURST;
   input                   tlv_parse_action_t        sw_TLV_PARSE_ACTION;
   output                  lz77_comp_debug_status_t  sw_LZ77_COMP_DEBUG_STATUS;
   input 		   lec_prc_lz_error;
   
   
   
   output                  prc_debug;
   input [`MODULE_ID_WIDTH-1:0] lz77_comp_module_id;

   input                        debug_status_read;
   output logic                 lz77_clk_en;
   output logic                 throttled_frame_ev;
   
   
   
   
   
   
   
   
   
   
   
   
   localparam WORD_ZERO_ST      = 3'd0;
   localparam CMD_TLV_ST        = 3'd1;
   localparam PREFIX_DATA_ST    = 3'd2;
   localparam COMP_DATA_1_ST    = 3'd3;
   localparam COMP_DATA_2_ST    = 3'd4;
   localparam FOOTER_TLV_ST     = 3'd5;
   localparam BYPASS_TLV_ST     = 3'd6;

   localparam  XP10_CRC_POLYNOMIAL = 32'h82F63B78;
   
 

   
   
   
   logic [5:0]                  bypass_q_credit;
   cr_lz77_compPKG::tlv_parse_action_e           tlv_action;
   cr_lz77_compPKG::tlv_parse_action_e           tlv_action_r1;
   logic                        compress_enable;
   logic 			stats_enable;
   tlv_cmd_word_1_t             tlv_cmd_word_1;
   tlv_cmd_word_2_t             tlv_cmd_word_2;
   tlv_cmd_word_2_t             cmd_w2;
   logic                        min_mtf_len;
   logic                        num_mtf;
   logic 			isXp9;

   typedef struct packed {
      logic       is_prefix;
      union packed {
         logic [7:0] prefix_data_vld;
         struct packed {
            logic [2:0] reserved;
            logic       eot;
            logic [3:0] data_vld;
         } sample;
      } u;
      logic [63:0] data;
      logic [4:0]  byte_count;
   } prc_lec_fifo_t;

   logic        prc_lec_fifo_wen;
   logic        prc_lec_fifo_ren;
   prc_lec_fifo_t prc_lec_fifo_wdata;
   prc_lec_fifo_t prc_lec_fifo_rdata;
   logic        prc_lec_fifo_full;
   logic        prc_lec_fifo_empty;

   logic        i_have_credit;

   logic [63:0]                 lec_bswp_data;
   logic [7:0]                  lec_bswp_tstrb;
   logic [31:0]                 sample_data;
   logic [3:0]                  sample_data_vld;

   logic [63:0]                 prefix_data;
   logic [7:0]                  prefix_data_vld;
   logic                        prc_lob_valid_c;
   logic                        prc_prs_rd_c;
   logic                        capture_tlv_action_c;
   logic                        prc_lob_is_compressed_c;
   logic 			prc_lob_enable_stats_c;
   logic                        capture_cmd_word_1_c;
   logic                        cmd_word_1_done;
   logic                        capture_cmd_word_2_c;
   logic                        load_prefix_data_c;
   logic 			update_crc_c;
   logic 			verify_crc_c;
   logic                        sel_next_4B_data_c;
   logic                        lec_data_strb_c;
   logic                        lec_eot_c;
   logic [2:0]                  prc_st_c;
   logic [2:0]                  prc_st;
   logic [31:0] 		crc;
   logic 			verify_crc;
   logic 			check_cfg_c;
   logic 			update_foot_errors_c;
   logic 			clear_foot_errors_c;
   logic 			capture_frame_num_c;
   logic 			check_cfg;
   logic 			check_cfg_r;
   logic 			check_compression_config;
   logic [10:0] 		command_frame_num;
   logic [10:0] 		prefix_frame_num;
   logic [10:0] 		data_frame_num;
   logic 			prefix_crc_error;
   logic 			bad_comp_alg;
   logic 			bad_win_size;
   logic 			bad_max_len;
   logic 			bad_dmw_size;
   logic 			lz_error;
   tlv_ftr_word13_t             current_footer_word13;
   tlv_ftr_word13_t             updated_footer_word13;
   tlv_word_0_t                 tlv_word_0;
   tlvp_if_bus_t                updated_footer_tlv;

   logic [31:0]                 c_prc_lec_sample_data, r_prc_lec_sample_data;
   logic [3:0]                  c_prc_lec_sample_data_vld, r_prc_lec_sample_data_vld;
   logic [63:0]                 c_prc_lec_prefix_data, r_prc_lec_prefix_data;
   logic [7:0]                  c_prc_lec_prefix_data_vld, r_prc_lec_prefix_data_vld;
   logic                        c_prc_lec_sample_eot, r_prc_lec_sample_eot;
   logic 			lec_prc_lz_error_r;
   

   
   
   
   assign prc_prs_rd = prc_prs_rd_c;

   assign prc_lec_min_match_len = cmd_w2.lz77_min_match_len;
   assign prc_lec_max_match_len = cmd_w2.lz77_max_symb_len;
   assign prc_lec_dly_match_win = cmd_w2.lz77_dly_match_win;
   assign prc_lec_win_size = cmd_w2.lz77_win_size;
   assign prc_lec_num_mtf = num_mtf;
   assign prc_lec_min_mtf_len = min_mtf_len;
   assign prc_lec_isXp9 = isXp9;

   assign prc_lob_valid = prc_lob_valid_c;

   assign prc_lob_tlv_if = update_foot_errors_c ?  
			   updated_footer_tlv :
			   prs_prc_tlv_if;

   assign current_footer_word13 = tlv_ftr_word13_t'(prs_prc_tlv_if.tdata);
   assign tlv_word_0 = tlv_word_0_t'(prs_prc_tlv_if.tdata);

   assign prc_lob_is_compressed = prc_lob_is_compressed_c;
   assign prc_lob_enable_stats = prc_lob_enable_stats_c;

         
   assign sw_LZ77_COMP_DEBUG_STATUS.f.lz77_max_symb_len = cmd_w2.lz77_max_symb_len;
   assign sw_LZ77_COMP_DEBUG_STATUS.f.lz77_min_match_len = cmd_w2.lz77_min_match_len;
   assign sw_LZ77_COMP_DEBUG_STATUS.f.lz77_dly_match_win = cmd_w2.lz77_dly_match_win;
   assign sw_LZ77_COMP_DEBUG_STATUS.f.lz77_win_size = cmd_w2.lz77_win_size;
   assign sw_LZ77_COMP_DEBUG_STATUS.f.comp_mode = cmd_w2.comp_mode;
   
   assign prc_debug = 1'b0; 
   
   

   assign check_compression_config = check_cfg & !check_cfg_r;
   


   always @ (*) begin
      i_have_credit = |bypass_q_credit;

      
      
      tlv_action = get_tlv_action(prs_prc_tlv_if.typen);

      
      
      
      
      for (int i=0; i<8; i++) begin
         lec_bswp_data[(63-(i*8)) -: 8] = prs_prc_tlv_if.tdata[(7+(i*8)) -: 8];
         lec_bswp_tstrb[7-i] = prs_prc_tlv_if.tstrb[i];
      end

        
      sample_data = sel_next_4B_data_c ?
                    lec_bswp_data[31 -: 32] :
                    lec_bswp_data[63 -: 32];

      sample_data_vld = sel_next_4B_data_c ?
                        lec_bswp_tstrb[3 -: 4] :
                        lec_bswp_tstrb[7 -: 4];

      prefix_data = lec_bswp_data;
      prefix_data_vld = lec_bswp_tstrb;

      tlv_cmd_word_1 = tlv_cmd_word_1_t'(prs_prc_tlv_if.tdata);
      tlv_cmd_word_2 = tlv_cmd_word_2_t'(prs_prc_tlv_if.tdata);

      updated_footer_tlv = prs_prc_tlv_if;
      updated_footer_tlv.tdata = updated_footer_word13;

   end

   always @ (posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         bypass_q_credit           <= 6'd32;
         compress_enable           <= 1'b0;
	 stats_enable              <= 1'b0;
         cmd_w2                    <= {$bits(tlv_cmd_word_2_t){1'b0}};
         min_mtf_len               <= 1'b0;
         num_mtf                   <= 1'b0;
	 isXp9                     <= 1'b0;
         tlv_action_r1             <= cr_lz77_compPKG::MODIFY;
         prc_st                    <= WORD_ZERO_ST;
	 verify_crc                <= 1'b0;
	 crc                       <= 32'hffff_ffff;
	 check_cfg                 <= 1'b0;
	 check_cfg_r               <= 1'b0;
	 command_frame_num         <= 11'b0;
	 prefix_frame_num          <= 11'b0;
	 data_frame_num            <= 11'b0;
	 prefix_crc_error          <= 1'b0;
	 bad_comp_alg              <= 1'b0;
	 bad_win_size              <= 1'b0;
	 bad_max_len               <= 1'b0;
	 bad_dmw_size              <= 1'b0;
	 lz_error                  <= 1'b0;
	 updated_footer_word13     <= {$bits(tlv_ftr_word13_t){1'b0}};
         cmd_word_1_done           <= 1'b0;
	 lec_prc_lz_error_r        <= 1'b0;
	 prc_lec_count             <= 8'b0;

      end else begin

	 prc_lec_count <= prc_lec_count + 1;

         
         if (prc_lob_valid_c ^ lob_prc_credit) begin
            if (prc_lob_valid_c)  
              bypass_q_credit <= bypass_q_credit - 1;
            else
              bypass_q_credit <= bypass_q_credit + 1;
	 end
	 
         if (capture_tlv_action_c)
           tlv_action_r1 <= tlv_action; 

         if (capture_cmd_word_1_c) begin
            cmd_word_1_done <= 1'b1;
	    stats_enable <= tlv_cmd_word_1.trace;
	 end

         if (capture_cmd_word_2_c) begin
            cmd_word_1_done <= 1'b0;
            cmd_w2 <= tlv_cmd_word_2;
            compress_enable <= (tlv_cmd_word_2.comp_mode != cr_lz77_compPKG::NONE) & ~(tlv_cmd_word_2.comp_mode > cr_lz77_compPKG::CHU8K);
	    bad_comp_alg    <= (tlv_cmd_word_2.comp_mode >  cr_lz77_compPKG::CHU8K);
	 end
	    
         
         if ((!sw_COMPRESSION_CFG.f.mtf_en) ||
             (cmd_w2.comp_mode == cr_lz77_compPKG::ZLIB) ||
             (cmd_w2.comp_mode == cr_lz77_compPKG::GZIP)
             )
           num_mtf <= 1'b0;  
         else
           num_mtf <= 1'b1;  
         
	 isXp9 <= (cmd_w2.comp_mode == cr_lz77_compPKG::XP9);

         if (cmd_w2.comp_mode == cr_lz77_compPKG::XP9) begin
            
            min_mtf_len <= 1'b0;
	 end
         else begin
            
            min_mtf_len <= cmd_w2.lz77_min_match_len;
         end

         prc_st <= prc_st_c;

	 
	 verify_crc <= verify_crc_c;
	 if (verify_crc)
	   crc <= 32'hffff_ffff;  
	 else if (update_crc_c)
	   crc <= crc32(prs_prc_tlv_if.tdata, crc, 7'd64);

	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 

	 
	 check_cfg      <= check_cfg_c;
	 check_cfg_r    <= check_cfg;
	 lec_prc_lz_error_r <= lec_prc_lz_error;


	 
	 if (clear_foot_errors_c) begin
	    
	    bad_comp_alg <= 1'b0;
	    bad_win_size <= 1'b0;
	    bad_max_len  <= 1'b0;
	    bad_dmw_size <= 1'b0;
	    prefix_crc_error <= 1'b0;
	    lz_error     <= 1'b0;
	 end
	 else begin
	    if (check_compression_config) begin
	       
	       
	       bad_win_size <= check_win_size(cmd_w2.comp_mode,
					      cmd_w2.lz77_win_size);
	       
	       bad_max_len  <= check_max_len(cmd_w2.comp_mode,
					     cmd_w2.lz77_max_symb_len);
	       
	       bad_dmw_size <= ( cmd_w2.lz77_dly_match_win == cr_lz77_compPKG::RSV_DLY ) ||
			       ( 
				 ( (cmd_w2.comp_mode == cr_lz77_compPKG::ZLIB) || 
				   (cmd_w2.comp_mode == cr_lz77_compPKG::GZIP) ) &&
				 (cmd_w2.lz77_dly_match_win != cr_lz77_compPKG::CHAR_1)
				 );
	    end 
	    if (lec_prc_lz_error && !lec_prc_lz_error_r) begin
	       lz_error <= 1'b1;
	    end
	    if (verify_crc_c) begin
	       prefix_crc_error <= (crc != ~prs_prc_tlv_if.tdata[31:0]);
	    end
	 end 
	 
	 if (capture_frame_num_c) begin
	    if (prs_prc_tlv_if.typen == CMD)
	      command_frame_num <= tlv_word_0.tlv_frame_num;
	    if (prs_prc_tlv_if.typen == PFD)
	      prefix_frame_num <= tlv_word_0.tlv_frame_num;
	    if (
		prs_prc_tlv_if.typen == DATA ||
		prs_prc_tlv_if.typen == DATA_UNK
		)
	      data_frame_num <= tlv_word_0.tlv_frame_num;
	 end

	 case (1'b1)
	   prefix_crc_error : begin
	      updated_footer_word13.error_code <= LZ77_COMP_PREFIX_CRC_ERROR;
	      updated_footer_word13.errored_frame_number <= {21'b0,prefix_frame_num};
	   end
	   bad_comp_alg : begin
	      updated_footer_word13.error_code <= LZ77_COMP_INVALID_COMP_ALG;
	      updated_footer_word13.errored_frame_number <= {21'b0,command_frame_num};
	   end
	   bad_win_size : begin
	      updated_footer_word13.error_code <= LZ77_COMP_INVALID_WIN_SIZE;
	      updated_footer_word13.errored_frame_number <= {21'b0,command_frame_num};
	   end
	   bad_max_len : begin
	      updated_footer_word13.error_code <= LZ77_COMP_INVALID_MAX_LEN;
	      updated_footer_word13.errored_frame_number <= {21'b0,command_frame_num};
	   end
	   bad_dmw_size : begin
	      updated_footer_word13.error_code <= LZ77_COMP_INVALID_DMW_SIZE;
	      updated_footer_word13.errored_frame_number <= {21'b0,command_frame_num};
	   end
	   lz_error : begin
	      updated_footer_word13.error_code <= LZ77_COMP_LZ_ERROR;
	      updated_footer_word13.errored_frame_number <= {21'b0,data_frame_num};
	   end
	   default : begin
	      updated_footer_word13 <= {$bits(tlv_ftr_word13_t){1'b0}};
	   end
	 endcase 

      end 
   end 

   logic [3:0] qual_sample_data_vld;
   logic [7:0] qual_prefix_data_vld;

   

   logic [16:0] r_active_lpos, c_active_lpos;
   logic [32:0] r_power_credit_count, c_power_credit_count;
   logic        r_lz77_clk_en, c_lz77_clk_en;
   logic        r_prc_lec_fifo_wen;
   logic        r_in_command, c_in_command;
   logic        r_sticky_throttle_active, c_sticky_throttle_active;
   logic        r_throttle_active, c_throttle_active;
   logic        r_throttled_frame_ev, c_throttled_frame_ev;
   logic [16:0] r_eot_dly;

   logic [16:0] decoded_win_size;
   always_comb begin
      case (prc_lec_win_size)
        0: decoded_win_size = 1 << 9;
        1: decoded_win_size = 1 << 12;
        2: decoded_win_size = 1 << 13;
        3: decoded_win_size = 1 << 14;
        4: decoded_win_size = 1 << 15;
        default: decoded_win_size = 1 << 16;
      endcase
   end
   
   `ASSERT_PROPERTY((qual_sample_data_vld==0) || (qual_prefix_data_vld==0)) else `ERROR("sample and prefix data transfer cannot be simultaneous");

   always_comb begin
      
      logic [7:0] v_byte_strbs;
      logic [4:0] v_byte_count;
      
      
      qual_sample_data_vld = sample_data_vld & {4{lec_data_strb_c}};
      qual_prefix_data_vld = prefix_data_vld & {8{load_prefix_data_c}};

      v_byte_strbs = {4'b0, qual_sample_data_vld} | qual_prefix_data_vld;
      v_byte_count = 0;
      
      for (int i=0; i<8; i++)
        v_byte_count += v_byte_strbs[i]; 
      

      prc_lec_fifo_wen = 0;
      prc_lec_fifo_wdata = 0;
      if (qual_sample_data_vld != 0) begin
         prc_lec_fifo_wen = 1'b1;
         
         prc_lec_fifo_wdata.is_prefix = 0;
         prc_lec_fifo_wdata.u.sample.eot = lec_eot_c;         
         prc_lec_fifo_wdata.u.sample.data_vld = qual_sample_data_vld;
         prc_lec_fifo_wdata.data[31:0] = sample_data;
         prc_lec_fifo_wdata.byte_count = v_byte_count;
      end
      else begin
         prc_lec_fifo_wen = qual_prefix_data_vld != 0;
         
         prc_lec_fifo_wdata.is_prefix = 1;
         prc_lec_fifo_wdata.u.prefix_data_vld = qual_prefix_data_vld;
         prc_lec_fifo_wdata.data = prefix_data;
         prc_lec_fifo_wdata.byte_count = v_byte_count;
      end 

      
      prc_lec_fifo_ren = 0;
      c_prc_lec_sample_data_vld = 0;
      c_prc_lec_prefix_data_vld = 0;
      c_prc_lec_sample_eot = 0;
      c_prc_lec_sample_data = prc_lec_fifo_rdata.data[31:0];
      c_prc_lec_prefix_data = prc_lec_fifo_rdata.data;

      c_active_lpos = r_active_lpos;
      c_in_command = r_in_command;
      c_power_credit_count = r_power_credit_count;
      c_lz77_clk_en = 0;
      c_sticky_throttle_active = r_sticky_throttle_active;
      c_throttle_active = r_throttle_active;
      c_throttled_frame_ev = 0;

      if (debug_status_read)
        c_sticky_throttle_active = 0;

      if (!prc_lec_fifo_empty && !lob_prc_full && (r_eot_dly==0) &&
          (signed'(r_power_credit_count) + signed'({1'b0, sw_COMPRESSION_CFG.f.power_credit_per_clock}) >= 34'sd0)) begin
         
         c_lz77_clk_en = 1;
         prc_lec_fifo_ren = 1;
         if (prc_lec_fifo_rdata.is_prefix) begin
            
            c_prc_lec_prefix_data_vld = prc_lec_fifo_rdata.u.prefix_data_vld;
         end
         else begin
            
            c_prc_lec_sample_data_vld = prc_lec_fifo_rdata.u.sample.data_vld;
            c_prc_lec_sample_eot = prc_lec_fifo_rdata.u.sample.eot;
         end

         if (!r_in_command)
           c_active_lpos = 0;

         
         if (c_active_lpos + prc_lec_fifo_rdata.byte_count > 18'(decoded_win_size)) begin
            if (signed'(r_power_credit_count) + signed'({1'b0, sw_COMPRESSION_CFG.f.power_credit_per_clock}) - signed'({1'b0, decoded_win_size}) > signed'({2'b0, sw_POWER_CREDIT_BURST}))
              c_power_credit_count = 33'(sw_POWER_CREDIT_BURST);
            else
              c_power_credit_count = 33'(r_power_credit_count + sw_COMPRESSION_CFG.f.power_credit_per_clock - decoded_win_size); 
            c_active_lpos = decoded_win_size;
         end
         else begin
            if (signed'(r_power_credit_count) + signed'({1'b0, sw_COMPRESSION_CFG.f.power_credit_per_clock}) - signed'({1'b0, c_active_lpos}) - signed'({1'b0, prc_lec_fifo_rdata.byte_count}) > signed'({2'b0, sw_POWER_CREDIT_BURST}))
              c_power_credit_count = 33'(sw_POWER_CREDIT_BURST);
            else
              c_power_credit_count = 33'(r_power_credit_count + sw_COMPRESSION_CFG.f.power_credit_per_clock - c_active_lpos - prc_lec_fifo_rdata.byte_count); 
            
            c_active_lpos = 17'(c_active_lpos + prc_lec_fifo_rdata.byte_count); 
         end 

         if (!prc_lec_fifo_rdata.is_prefix && prc_lec_fifo_rdata.u.sample.eot) begin
            c_in_command = 0;
            c_power_credit_count = 0;
            c_throttle_active = 0;
         end
         else
           c_in_command = 1;
      end 
      else if (r_eot_dly!=0) begin
         
         c_lz77_clk_en = 1;
      end
      else if (r_in_command) begin
         if (!prc_lec_fifo_empty && !lob_prc_full) begin
            
            if (!r_throttle_active)
              c_throttled_frame_ev = 1;
            c_throttle_active = 1;
            c_sticky_throttle_active = 1;
         end

         
         if (signed'(r_power_credit_count) + signed'({1'b0, sw_COMPRESSION_CFG.f.power_credit_per_clock}) > signed'({2'b0, sw_POWER_CREDIT_BURST}))
           c_power_credit_count = 33'(sw_POWER_CREDIT_BURST);
         else
           c_power_credit_count = 33'(r_power_credit_count + sw_COMPRESSION_CFG.f.power_credit_per_clock); 
      end
   end

   logic [3:0] r_startup_lz77_clk_cnt;
   

   assign lz77_clk_en = r_lz77_clk_en || (r_startup_lz77_clk_cnt != 0);

   always_ff@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         r_lz77_clk_en <= 1;
         r_startup_lz77_clk_cnt <= '1;
         
         
         prc_lec_prefix_data <= 0;
         prc_lec_prefix_data_vld <= 0;
         prc_lec_sample_data <= 0;
         prc_lec_sample_data_vld <= 0;
         prc_lec_sample_eot <= 0;
         r_active_lpos <= 0;
         r_eot_dly <= 0;
         r_in_command <= 0;
         r_power_credit_count <= 0;
         r_prc_lec_fifo_wen <= 0;
         r_prc_lec_prefix_data <= 0;
         r_prc_lec_prefix_data_vld <= 0;
         r_prc_lec_sample_data <= 0;
         r_prc_lec_sample_data_vld <= 0;
         r_prc_lec_sample_eot <= 0;
         r_sticky_throttle_active <= 0;
         r_throttle_active <= 0;
         r_throttled_frame_ev <= 0;
         
      end
      else begin
         if (r_startup_lz77_clk_cnt != 0)
           r_startup_lz77_clk_cnt <= r_startup_lz77_clk_cnt - 1;
         r_active_lpos <= c_active_lpos;
         r_power_credit_count <= c_power_credit_count;
         r_lz77_clk_en <= c_lz77_clk_en;
         r_prc_lec_fifo_wen <= prc_lec_fifo_wen;
         r_in_command <= c_in_command;
         r_sticky_throttle_active <= c_sticky_throttle_active;
         r_throttle_active <= c_throttle_active;
         r_throttled_frame_ev <= c_throttled_frame_ev;
         r_eot_dly <= {r_eot_dly[$bits(r_eot_dly)-2:0], c_prc_lec_sample_eot && c_lz77_clk_en};

         r_prc_lec_sample_data <= c_prc_lec_sample_data;
         r_prc_lec_sample_data_vld <= c_prc_lec_sample_data_vld;
         r_prc_lec_prefix_data <= c_prc_lec_prefix_data;
         r_prc_lec_prefix_data_vld <= c_prc_lec_prefix_data_vld;
         r_prc_lec_sample_eot <= c_prc_lec_sample_eot;

         if (r_lz77_clk_en) begin
            prc_lec_sample_data <= r_prc_lec_sample_data;
            prc_lec_sample_data_vld <= r_prc_lec_sample_data_vld;
            prc_lec_prefix_data <= r_prc_lec_prefix_data;
            prc_lec_prefix_data_vld <= r_prc_lec_prefix_data_vld;
            prc_lec_sample_eot <= r_prc_lec_sample_eot;
         end
      end
   end

   assign throttled_frame_ev = r_throttled_frame_ev;
   assign sw_LZ77_COMP_DEBUG_STATUS.f.live_throttle_active = r_throttle_active;
   assign sw_LZ77_COMP_DEBUG_STATUS.f.sticky_throttle_active = r_sticky_throttle_active;

   nx_fifo #(.DEPTH(2), .WIDTH(78)) prc_lec_fifo
     (.clk (clk),
      .rst_n(rst_n),
      .wen (prc_lec_fifo_wen),
      .ren (prc_lec_fifo_ren),
      .wdata (prc_lec_fifo_wdata),
      .rdata (prc_lec_fifo_rdata),
      .empty (prc_lec_fifo_empty),
      .full (prc_lec_fifo_full),
      .clear (1'b0),
      .used_slots (),
      .free_slots (),
      .underflow (),
      .overflow ());

   always @ (*) begin

      
      prc_lob_valid_c           = 1'b0;
      prc_prs_rd_c              = 1'b0;
      capture_tlv_action_c      = 1'b0;
      prc_lob_is_compressed_c   = 1'b0;
      prc_lob_enable_stats_c    = 1'b0;
      capture_cmd_word_1_c      = 1'b0;
      capture_cmd_word_2_c      = 1'b0;
      load_prefix_data_c        = 1'b0;
      update_crc_c              = 1'b0;
      verify_crc_c              = 1'b0;
      sel_next_4B_data_c        = 1'b0;
      lec_data_strb_c           = 1'b0;
      lec_eot_c                 = 1'b0;
      check_cfg_c               = 1'b0;
      update_foot_errors_c      = 1'b0;
      clear_foot_errors_c       = 1'b0;
      capture_frame_num_c       = 1'b0;
      prc_st_c                  = prc_st;
      
      case (prc_st)
         
        
        
        WORD_ZERO_ST: begin

           capture_tlv_action_c = 1'b1;

           if (!prs_prc_empty) begin

              if (
                  (tlv_action != cr_lz77_compPKG::MODIFY) ||
                  ((tlv_action == cr_lz77_compPKG::MODIFY) && i_have_credit)
                  ) begin
                 prc_prs_rd_c = 1'b1;
		 capture_frame_num_c = 1'b1;

                 
                 if (!prs_prc_tlv_if.eot)
                   case (prs_prc_tlv_if.typen)
                     CMD:        prc_st_c = CMD_TLV_ST;
                     PFD:        prc_st_c = PREFIX_DATA_ST;
                     DATA,
		       DATA_UNK: prc_st_c = COMP_DATA_1_ST;
                     FTR:        prc_st_c = FOOTER_TLV_ST;
                     default:    prc_st_c = BYPASS_TLV_ST;
                   endcase 

              end 
              
              if ((tlv_action == cr_lz77_compPKG::MODIFY) && i_have_credit) begin
                 prc_lob_valid_c = 1'b1; 

                 
                 
                 
                 if ( (prs_prc_tlv_if.typen == DATA) || 
		      (prs_prc_tlv_if.typen == DATA_UNK) ) begin

                    if (compress_enable)
		      prc_lob_is_compressed_c = 1'b1;

		    if (stats_enable)
		      prc_lob_enable_stats_c = 1'b1;
		 end

	      end 
              
           end 
        end 
        
        CMD_TLV_ST : begin
           if (!prs_prc_empty) begin
              
              if (
                  (tlv_action_r1 != cr_lz77_compPKG::MODIFY) ||
                  ((tlv_action_r1 == cr_lz77_compPKG::MODIFY) && i_have_credit)
                  ) begin
                 prc_prs_rd_c = 1'b1;

                 
		 
                 if (!cmd_word_1_done)
		   capture_cmd_word_1_c = 1'b1;
		 else
		   capture_cmd_word_2_c = 1'b1;

                 
                 if (prs_prc_tlv_if.eot)
                   prc_st_c = WORD_ZERO_ST;
		  
              end 

              if ((tlv_action_r1 == cr_lz77_compPKG::MODIFY) && i_have_credit) begin
                 
                 prc_lob_valid_c = 1'b1; 
              end
           end 
        end 
        
        PREFIX_DATA_ST : begin
           if (!prs_prc_empty && !prc_lec_fifo_full) begin
              
              if (
                  (tlv_action_r1 != cr_lz77_compPKG::MODIFY) ||
                  ((tlv_action_r1 == cr_lz77_compPKG::MODIFY) && i_have_credit)
                  ) begin
                 prc_prs_rd_c = 1'b1;
                 
                 
                 
                 load_prefix_data_c = ~prs_prc_tlv_if.eot;  
		 update_crc_c = 1'b1;
                 
                 
                 if (prs_prc_tlv_if.eot) begin
		    verify_crc_c = 1'b1;
                    prc_st_c = WORD_ZERO_ST;
		 end
		 
              end 
              
              if ((tlv_action_r1 == cr_lz77_compPKG::MODIFY) && i_have_credit) begin
                 
                 prc_lob_valid_c = 1'b1; 
              end
           end 
        end 

        COMP_DATA_1_ST : begin
           if (!prs_prc_empty) begin
              if (tlv_action_r1 != cr_lz77_compPKG::MODIFY) begin
                 
                 prc_prs_rd_c = 1'b1;
                 if (prs_prc_tlv_if.eot)
                   prc_st_c = WORD_ZERO_ST;
              end else begin
                 if (compress_enable) begin
                    
                    if (!prc_lec_fifo_full) begin
                       lec_data_strb_c = 1'b1;
                       if (|prs_prc_tlv_if.tstrb[7:4]) begin
                          prc_st_c = COMP_DATA_2_ST;
                       end else begin
                          
                          prc_prs_rd_c = 1'b1;
                          lec_eot_c = 1'b1;
                          prc_st_c = WORD_ZERO_ST;
                       end
                    end 
		    check_cfg_c = 1'b1;
                 end else begin
                    
                    if (i_have_credit) begin
                       prc_lob_valid_c = 1'b1;
                       prc_prs_rd_c = 1'b1;
                       if (prs_prc_tlv_if.eot)
                         prc_st_c = WORD_ZERO_ST;
                    end
                 end 
              end 
           end 
        end 
        
        COMP_DATA_2_ST : begin
           
           if (!prc_lec_fifo_full) begin
              sel_next_4B_data_c = 1'b1;
              lec_data_strb_c = 1'b1;
              prc_prs_rd_c = 1'b1;
              if (prs_prc_tlv_if.eot) begin
                 lec_eot_c = 1'b1;
                 prc_st_c = WORD_ZERO_ST;
              end else begin
                 prc_st_c = COMP_DATA_1_ST;
              end
           end 
        end

        FOOTER_TLV_ST : begin
           
           
           
           if (!prs_prc_empty) begin
              if (tlv_action_r1 != cr_lz77_compPKG::MODIFY) begin
                 
                 prc_prs_rd_c = 1'b1;
                 if (prs_prc_tlv_if.eot)
                   prc_st_c = WORD_ZERO_ST;
              end else begin
                 
                 if (i_have_credit) begin
                    prc_lob_valid_c = 1'b1;
                    prc_prs_rd_c = 1'b1;
                    if (prs_prc_tlv_if.eot) begin
                       prc_st_c = WORD_ZERO_ST;
		       clear_foot_errors_c = 1'b1;
		       if ( (updated_footer_word13.error_code != NO_ERRORS) 
			    &&  (current_footer_word13.error_code == NO_ERRORS) 
			    )
			 update_foot_errors_c = 1'b1;
		    end
                 end
              end 
           end 
        end 
        
        default: begin 
           if (!prs_prc_empty) begin
              if (tlv_action_r1 != cr_lz77_compPKG::MODIFY) begin
                 
                 prc_prs_rd_c = 1'b1;
                 if (prs_prc_tlv_if.eot)
                   prc_st_c = WORD_ZERO_ST;
              end else begin
                 
                 if (i_have_credit) begin
                    prc_lob_valid_c = 1'b1;
                    prc_prs_rd_c = 1'b1;
                    if (prs_prc_tlv_if.eot)
                      prc_st_c = WORD_ZERO_ST;
                 end
              end 
           end 
        end 

      endcase 
   end 
   


   
   
   
   function cr_lz77_compPKG::tlv_parse_action_e get_tlv_action(tlv_types_e typen);
      cr_lz77_compPKG::tlv_parse_action_e  _action;
      
      
      
      
      
      
      
      
      
      case(typen)
	8'd0:    _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(0  * 2) +: 2]);
	8'd1:    _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(1  * 2) +: 2]);
	8'd2:    _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(2  * 2) +: 2]);
	8'd3:    _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(3  * 2) +: 2]);
	8'd4:    _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(4  * 2) +: 2]);
	8'd5:    _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(5  * 2) +: 2]);
	8'd6:    _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(6  * 2) +: 2]);
	8'd7:    _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(7  * 2) +: 2]);
	8'd8:    _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(8  * 2) +: 2]);
	8'd9:    _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(9  * 2) +: 2]);
	8'd10:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(10 * 2) +: 2]);
	8'd11:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(11 * 2) +: 2]);
	8'd12:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(12 * 2) +: 2]);
	8'd13:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(13 * 2) +: 2]);
	8'd14:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(14 * 2) +: 2]);
	8'd15:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(15 * 2) +: 2]);
	8'd16:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(16 * 2) +: 2]);
	8'd17:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(17 * 2) +: 2]);
	8'd18:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(18 * 2) +: 2]);
	8'd19:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(19 * 2) +: 2]);
	8'd20:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(20 * 2) +: 2]);
	8'd21:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(21 * 2) +: 2]);
	8'd22:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(22 * 2) +: 2]);
	8'd23:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(23 * 2) +: 2]);
	8'd24:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(24 * 2) +: 2]);
	8'd25:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(25 * 2) +: 2]);
	8'd26:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(26 * 2) +: 2]);
	8'd27:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(27 * 2) +: 2]);
	8'd28:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(28 * 2) +: 2]);
	8'd29:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(29 * 2) +: 2]);
	8'd30:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(30 * 2) +: 2]);
	8'd31:   _action = cr_lz77_compPKG::tlv_parse_action_e'(sw_TLV_PARSE_ACTION[(31 * 2) +: 2]);
        default: _action = cr_lz77_compPKG::DELETE;
      endcase 
      return _action;
   endfunction 
   
   function logic check_win_size(cr_lz77_compPKG::cmd_comp_mode_e comp_mode,
				 cr_lz77_compPKG::cmd_lz77_win_size_e win_size);
      logic _error_;
      
      if (win_size == cr_lz77_compPKG::WIN_32B) 
	_error_ = 1'b0;
      else if (win_size > cr_lz77_compPKG::WIN_64K)
	_error_ = 1'b1;
      else
	case (comp_mode)
	  cr_lz77_compPKG::NONE:       _error_ = 1'b0;
	  cr_lz77_compPKG::ZLIB,
	    cr_lz77_compPKG::GZIP:     _error_ = (win_size != 
						  cr_lz77_compPKG::WIN_32K);
	  cr_lz77_compPKG::XP9:        _error_ = (win_size != 
						  cr_lz77_compPKG::WIN_64K);
	  cr_lz77_compPKG::CHU4K:      _error_ = (win_size != 
						  cr_lz77_compPKG::WIN_4K);
	  cr_lz77_compPKG::CHU8K:      _error_ = (win_size != 
						  cr_lz77_compPKG::WIN_8K);
 	  cr_lz77_compPKG::XP10:       _error_ = (win_size == 
 						  cr_lz77_compPKG::WIN_32K);
	  
	  default:                     _error_ = 1'b0; 
	endcase 
      return _error_;
   endfunction 
   
   function logic check_max_len(cr_lz77_compPKG::cmd_comp_mode_e comp_mode,
				cr_lz77_compPKG::cmd_lz77_max_symb_len_e max_len);
      logic _error_;

      if ( (max_len == cr_lz77_compPKG::MIN_MTCH_14) || 
	   (max_len == cr_lz77_compPKG::LEN_64B) )
	_error_ = 1'b0;
      else
	case (comp_mode)
	  cr_lz77_compPKG::ZLIB,
	  cr_lz77_compPKG::GZIP:  _error_ = (max_len == 
					     cr_lz77_compPKG::LEN_LZ77_WIN);
	  default :   _error_ = (max_len == cr_lz77_compPKG::LEN_256B);
	endcase 
      return _error_;
   endfunction 

   
   
   
   
   
   
   
   
   

   
   `CCX_STD_DECLARE_CRC(crc32, 32'd`XP10CRC32_POLYNOMIAL, 32,        64        );

   
   

endmodule 
































































