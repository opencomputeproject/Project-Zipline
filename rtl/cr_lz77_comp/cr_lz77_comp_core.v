/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "ccx_std.vh"
`include "crPKG.svp"
`include "cr_lz77_comp_pkg_include.vh"

module cr_lz77_comp_core
  #(
    parameter CR_LZ77_COMPRESSOR_STUB = 0,
    parameter LZ77_COMP_SHORT_WINDOW  = 0     
    )
   (
   
   lz77_comp_ib_out, lz77_comp_ob_out, sw_LZ77_COMP_DEBUG_STATUS,
   lz77_comp_stat_events, lz77_comp_int,
   
   clk, rst_n, raw_rst_n, bypass_reset, test_rst_n, lz77_comp_ib_in,
   lz77_comp_ob_in, sw_TLV_PARSE_ACTION, sw_COMPRESSION_CFG,
   sw_POWER_CREDIT_BURST, lz77_comp_module_id, debug_status_read,
   sw_SPARE
   );

   
`include "cr_lz77_comp_includes.vh"

   import crPKG::LZ77C_eof_FRAME;
   import crPKG::LZ77C_throttled_FRAME;

   
   
   
   input         clk;
   input         rst_n;
   input         raw_rst_n;
   input 	 bypass_reset;
   input 	 test_rst_n;
   
   
   
   
   input 	 axi4s_dp_bus_t lz77_comp_ib_in;
   output 	 axi4s_dp_rdy_t lz77_comp_ib_out;
   
   
   
   
   input 	 axi4s_dp_rdy_t lz77_comp_ob_in;
   output 	 axi4s_dp_bus_t lz77_comp_ob_out;
   
   
   
   
   input 	 tlv_parse_action_t sw_TLV_PARSE_ACTION;
   input 	 compression_cfg_t sw_COMPRESSION_CFG;
   input         power_credit_burst_t sw_POWER_CREDIT_BURST;
   output 	 lz77_comp_debug_status_t sw_LZ77_COMP_DEBUG_STATUS;
   output logic [`LZ77C_STATS_WIDTH-1:0] lz77_comp_stat_events;
   input [`MODULE_ID_WIDTH-1:0]    lz77_comp_module_id;
   input                           debug_status_read;
   
   output 			   tlvp_int_t lz77_comp_int;
   input 			   spare_t       sw_SPARE;
   


   
   
   
   
   
   
   
   
   
   


   generate if (CR_LZ77_COMPRESSOR_STUB == 1)
     begin : lz77_stub
	always_comb
	  begin
	     lz77_comp_ob_out.tvalid = lz77_comp_ib_in.tvalid;
	     lz77_comp_ob_out.tlast  = lz77_comp_ib_in.tlast;
	     lz77_comp_ob_out.tid    = lz77_comp_ib_in.tid;
	     lz77_comp_ob_out.tstrb  = lz77_comp_ib_in.tstrb;   
	     lz77_comp_ob_out.tuser  = lz77_comp_ib_in.tuser;  
	     lz77_comp_ob_out.tdata  = lz77_comp_ib_in.tdata;  
	     lz77_comp_ib_out.tready = lz77_comp_ob_in.tready;
	  end
     end
      
   else
     begin : lz77_core
	
	
	
	

	


	wire [3:0] [7:0]	lec_lob_literal;
	wire [4:0] [1:0] 	lec_lob_type;
	wire [15:0] 		lec_lob_type1_length;
	wire [15:0] 		lec_lob_type1_offset;
	wire [15:0] 		lec_lob_type0_offset;
	wire			lob_prc_credit;
	tlvp_if_bus_t	lob_prs_tlv_if;
	wire			lob_prs_wr;
	wire [1:0] 		prc_lec_dly_match_win;
	wire [1:0] 		prc_lec_max_match_len;
	wire			prc_lec_min_match_len;
	wire			prc_lec_min_mtf_len;
	wire			prc_lec_num_mtf;
	wire [63:0] 		prc_lec_prefix_data;
	wire [7:0] 		prc_lec_prefix_data_vld;
	wire [31:0] 		prc_lec_sample_data;
	wire [3:0] 		prc_lec_sample_data_vld;
	wire [2:0] 		prc_lec_win_size;
	wire			prc_lob_is_compressed;
        wire 			prc_lob_enable_stats;
	tlvp_if_bus_t	prc_lob_tlv_if;
	wire			prc_lob_valid;
	wire			prc_prs_rd;
	wire 			prs_lob_afull;
	wire 			prs_lob_full;
	wire 			prs_prc_aempty;
	wire 			prs_prc_empty;
	wire			prc_debug;
	tlvp_if_bus_t	prs_prc_tlv_if;
	wire 			lec_lob_comp_eot;
	wire 			lob_prc_full;
	wire 			prc_lec_sample_eot;
	wire 			prc_lec_isXp9;
	wire [7:0] 		prc_lec_count;
        
	
        
        wire            lec_prc_lz_error;       
        lob_events_t    lob_events;             
        wire            lz77_clk;               
        logic           lz77_clk_en;            
        logic           throttled_frame_ev;     
        

        logic           force_lz77_clk_en;
`ifdef FORCE_LZ77_CLK_EN
        assign force_lz77_clk_en = 1;
`else
        assign force_lz77_clk_en = 0;
`endif

        
        cr_clk_gate u_lz77_clk_gate
          (
           
           .o                           (lz77_clk),              
           
           .i0                          (1'b0),                  
           .i1                          (lz77_clk_en || force_lz77_clk_en), 
           .phi                         (clk));                   

        always_comb begin
           lz77_comp_stat_events = lob_events;
           lz77_comp_stat_events[LZ77C_throttled_FRAME-LZ77C_eof_FRAME] = throttled_frame_ev;
        end

	
	
	
	

	
	cr_tlvp_top prs
	  (
           
           .axi4s_ib_out                (lz77_comp_ib_out),      
           .usr_ib_empty                (prs_prc_empty),         
           .usr_ib_aempty               (prs_prc_aempty),        
           .usr_ib_tlv                  (prs_prc_tlv_if),        
           .usr_ob_full                 (prs_lob_full),          
           .usr_ob_afull                (prs_lob_afull),         
           .tlvp_error                  (lz77_comp_int),         
           .axi4s_ob_out                (lz77_comp_ob_out),      
           
           .clk                         (clk),
           .rst_n                       (rst_n),
           .axi4s_ib_in                 (lz77_comp_ib_in),       
           .tlv_parse_action            (sw_TLV_PARSE_ACTION),   
           .module_id                   (lz77_comp_module_id[`MODULE_ID_WIDTH-1:0]), 
           .usr_ib_rd                   (prc_prs_rd),            
           .usr_ob_wr                   (lob_prs_wr),            
           .usr_ob_tlv                  (lob_prs_tlv_if),        
           .axi4s_ob_in                 (lz77_comp_ob_in));       

	
	
	
	cr_lz77_comp_prc prc
	  (
           
	   .prc_lec_count               (prc_lec_count),
           .prc_prs_rd                  (prc_prs_rd),
           .prc_lec_min_match_len       (prc_lec_min_match_len),
           .prc_lec_max_match_len       (prc_lec_max_match_len[1:0]),
           .prc_lec_dly_match_win       (prc_lec_dly_match_win[1:0]),
           .prc_lec_win_size            (prc_lec_win_size[2:0]),
           .prc_lec_num_mtf             (prc_lec_num_mtf),
           .prc_lec_min_mtf_len         (prc_lec_min_mtf_len),
           .prc_lec_isXp9               (prc_lec_isXp9),
           .prc_lec_sample_data         (prc_lec_sample_data[31:0]),
           .prc_lec_sample_data_vld     (prc_lec_sample_data_vld[3:0]),
           .prc_lec_prefix_data         (prc_lec_prefix_data[63:0]),
           .prc_lec_prefix_data_vld     (prc_lec_prefix_data_vld[7:0]),
           .prc_lec_sample_eot          (prc_lec_sample_eot),
           .prc_lob_valid               (prc_lob_valid),
           .prc_lob_tlv_if              (prc_lob_tlv_if),
           .prc_lob_is_compressed       (prc_lob_is_compressed),
           .prc_lob_enable_stats        (prc_lob_enable_stats),
           .sw_LZ77_COMP_DEBUG_STATUS   (sw_LZ77_COMP_DEBUG_STATUS),
           .prc_debug                   (prc_debug),
           .lz77_clk_en                 (lz77_clk_en),
           .throttled_frame_ev          (throttled_frame_ev),
           
           .clk                         (clk),
           .rst_n                       (rst_n),
           .prs_prc_empty               (prs_prc_empty),
           .prs_prc_aempty              (prs_prc_aempty),
           .prs_prc_tlv_if              (prs_prc_tlv_if),
           .lob_prc_full                (lob_prc_full),
           .lob_prc_credit              (lob_prc_credit),
           .sw_COMPRESSION_CFG          (sw_COMPRESSION_CFG),
           .sw_POWER_CREDIT_BURST       (sw_POWER_CREDIT_BURST),
           .sw_TLV_PARSE_ACTION         (sw_TLV_PARSE_ACTION),
           .lec_prc_lz_error            (lec_prc_lz_error),
           .lz77_comp_module_id         (lz77_comp_module_id[`MODULE_ID_WIDTH-1:0]),
           .debug_status_read           (debug_status_read));
	
	
	
	
          


	cr_lz77_comp_lec_v3



 	  #(
	    .LZ77_COMP_SHORT_WINDOW(LZ77_COMP_SHORT_WINDOW)
	    )
	lec 
	  (
           
           .lec_lob_type                (lec_lob_type),
           .lec_lob_literal             (lec_lob_literal),
           .lec_lob_type1_offset        (lec_lob_type1_offset[15:0]),
           .lec_lob_type1_length        (lec_lob_type1_length[15:0]),
           .lec_lob_type0_offset        (lec_lob_type0_offset[15:0]),
           .lec_lob_comp_eot            (lec_lob_comp_eot),
           .lec_prc_lz_error            (lec_prc_lz_error),
           
           .clk                         (lz77_clk),              
           .rst_n                       (rst_n),
           .raw_rst_n                   (raw_rst_n),
           .bypass_reset                (bypass_reset),
           .test_rst_n                  (test_rst_n),
           .prc_lec_min_match_len       (prc_lec_min_match_len),
           .prc_lec_max_match_len       (prc_lec_max_match_len[1:0]),
           .prc_lec_dly_match_win       (prc_lec_dly_match_win[1:0]),
           .prc_lec_win_size            (prc_lec_win_size[2:0]),
           .prc_lec_num_mtf             (prc_lec_num_mtf),
           .prc_lec_min_mtf_len         (prc_lec_min_mtf_len),
           .prc_lec_isXp9               (prc_lec_isXp9),
           .prc_lec_sample_data         (prc_lec_sample_data[31:0]),
           .prc_lec_sample_data_vld     (prc_lec_sample_data_vld[3:0]),
           .prc_lec_prefix_data         (prc_lec_prefix_data[63:0]),
           .prc_lec_prefix_data_vld     (prc_lec_prefix_data_vld[7:0]),
           .prc_lec_sample_eot          (prc_lec_sample_eot),
           .sw_SPARE                    (sw_SPARE),
	   .prc_lec_count               (prc_lec_count));
	
	
	
	
	

	cr_lz77_comp_lob_v3



	  lob 
	  (
           
           .lob_prc_full                (lob_prc_full),
           .lob_prc_credit              (lob_prc_credit),
           .lob_prs_wr                  (lob_prs_wr),
           .lob_prs_tlv_if              (lob_prs_tlv_if),
           .lob_events                  (lob_events),
           
           .clk                         (clk),
           .lz77_clk                    (lz77_clk),
           .rst_n                       (rst_n),
           .prc_lob_valid               (prc_lob_valid),
           .prc_lob_tlv_if              (prc_lob_tlv_if),
           .prc_lob_is_compressed       (prc_lob_is_compressed),
           .prc_lob_enable_stats        (prc_lob_enable_stats),
           .lec_lob_type                (lec_lob_type),
           .lec_lob_literal             (lec_lob_literal),
           .lec_lob_type1_offset        (lec_lob_type1_offset[15:0]),
           .lec_lob_type1_length        (lec_lob_type1_length[15:0]),
           .lec_lob_type0_offset        (lec_lob_type0_offset[15:0]),
           .lec_lob_comp_eot            (lec_lob_comp_eot),
           .prs_lob_full                (prs_lob_full),
           .prs_lob_afull               (prs_lob_afull),
           .prc_debug                   (prc_debug));


     end
   endgenerate
endmodule 










