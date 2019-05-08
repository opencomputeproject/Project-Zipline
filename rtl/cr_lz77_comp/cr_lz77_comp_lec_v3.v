/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_lz77_comp.vh"
`include "cr_lz77_comp_pkg_include.vh"

module cr_lz77_comp_lec_v3
  #(
    parameter LZ77_COMP_SHORT_WINDOW = 0     
    
    )
  (
   
   lec_lob_type, lec_lob_literal, lec_lob_type1_offset,
   lec_lob_type1_length, lec_lob_type0_offset, lec_lob_comp_eot,
   lec_prc_lz_error,
   
   clk, rst_n, raw_rst_n, bypass_reset, test_rst_n,
   prc_lec_min_match_len, prc_lec_max_match_len,
   prc_lec_dly_match_win, prc_lec_win_size, prc_lec_num_mtf,
   prc_lec_min_mtf_len, prc_lec_isXp9, prc_lec_sample_data,
   prc_lec_sample_data_vld, prc_lec_prefix_data,
   prc_lec_prefix_data_vld, prc_lec_sample_eot, sw_SPARE,
   prc_lec_count
   );


`include "cr_lz77_comp_includes.vh"

   
   
   

   
   input 	     clk;

   
   input 	     rst_n;
   input 	     raw_rst_n;

   
   input 	     bypass_reset;
   input 	     test_rst_n;
   
   
   
   
   input 	     prc_lec_min_match_len;

   
   
   
   
   
   input [1:0] 	     prc_lec_max_match_len;
   
   
   
   
   
   
   input [1:0] 	     prc_lec_dly_match_win;

   
   
   
   
   
   
   
   input [2:0] 	     prc_lec_win_size;

   
   
   
   input 	     prc_lec_num_mtf;

   
   
   
   input 	     prc_lec_min_mtf_len;

   
   input 	     prc_lec_isXp9;


   
   
   
   input [4*8-1:0]   prc_lec_sample_data;
   input [3:0] 	     prc_lec_sample_data_vld;

   
   
   
   input [8*8-1:0]   prc_lec_prefix_data;
   input [7:0] 	     prc_lec_prefix_data_vld;

   
   
   
   
   input 	     prc_lec_sample_eot;

   input 	     spare_t sw_SPARE;

   input [7:0] 	     prc_lec_count;

   
   
   

   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   output [4:0][1:0] lec_lob_type;
   
   
   output [3:0][7:0] lec_lob_literal;

   
   output [15:0]     lec_lob_type1_offset;
   output [15:0]     lec_lob_type1_length;
   output [15:0]     lec_lob_type0_offset;
   
   
   
   output 	     lec_lob_comp_eot;

   
   output 	     lec_prc_lz_error;
 	     
   
   
   
   
   


   

   logic [31:0]      lz77_engine_data;
   logic [3:0]       lz77_engine_data_vld;
   logic [63:0]      lz77_engine_prefix_data;
   logic [7:0]       lz77_engine_prefix_data_vld;
   logic             lz77_engine_last;

`ifdef ADD_INPUT_DELAY
   always_ff@(posedge clk) begin
      lz77_engine_data <= prc_lec_sample_data;
      lz77_engine_data_vld <= prc_lec_sample_data_vld;
      lz77_engine_prefix_data <= prc_lec_prefix_data;
      lz77_engine_prefix_data_vld <= prc_lec_prefix_data_vld;
      lz77_engine_last <= prc_lec_sample_eot;
   end
`else
      assign lz77_engine_data = prc_lec_sample_data;
      assign lz77_engine_data_vld = prc_lec_sample_data_vld;
      assign lz77_engine_prefix_data = prc_lec_prefix_data;
      assign lz77_engine_prefix_data_vld = prc_lec_prefix_data_vld;
      assign lz77_engine_last = prc_lec_sample_eot;
`endif
`ifdef CR_USE_LZ77_COMP_ENGINE_V3
    cr_lz77_engine_v3
   lz77_engine
     (
      
      .lz77_engine_output_types         (lec_lob_type[4:0]),     
      .lz77_engine_literals             (lec_lob_literal[3:0]),  
      .lz77_engine_ptr_offset           (lec_lob_type1_offset[15:0]), 
      .lz77_engine_ptr_length           (lec_lob_type1_length[15:0]), 
      .lz77_engine_last_output          (lec_lob_comp_eot),      
      .lec_prc_lz_error                 (lec_prc_lz_error),

      
      .clk                              (clk),                   
      .rst_n                            (rst_n),                 
      .raw_rst_n                        (raw_rst_n),             
      .bypass_reset                     (bypass_reset),          
      .test_rst_n                       (test_rst_n),            
      .lz77_win_size                    (prc_lec_win_size[2:0]), 
      .lz77_dly_match_win               (prc_lec_dly_match_win[1:0]), 
      .lz77_max_match_len               (prc_lec_max_match_len[1:0]), 
      .lz77_isXp9                       (prc_lec_isXp9),         
      .lz77_engine_data                 (lz77_engine_data), 
      .lz77_engine_data_vld             (lz77_engine_data_vld), 
      .lz77_engine_prefix_data          (lz77_engine_prefix_data), 
      .lz77_engine_prefix_data_vld      (lz77_engine_prefix_data_vld), 
      .lz77_engine_last                 (lz77_engine_last),    
      .prc_lec_num_mtf                  (prc_lec_num_mtf),
      .sw_SPARE                         (sw_SPARE),
      .prc_lec_count                    (prc_lec_count));


      assign lec_lob_type0_offset = 16'b0;
`else
    cr_lz77_engine_v2 
      #(
 	.CLUSTERS ((LZ77_COMP_SHORT_WINDOW == 0) ? `CLUSTERS : 4),
 	.TILPC    ((LZ77_COMP_SHORT_WINDOW == 0) ? `TILES_PER_CLUSTER : 4),
        .OFFPT    ((LZ77_COMP_SHORT_WINDOW == 0) ? `OFFSETS_PER_TILE : 256)
   	)
   lz77_engine
     (
      
      .lz77_engine_output_types         (lec_lob_type[4:0]),     
      .lz77_engine_literals             (lec_lob_literal[3:0]),  
      .lz77_engine_1st_ptr_offset       (lec_lob_type1_offset[15:0]), 
      .lz77_engine_1st_ptr_length       (lec_lob_type1_length[15:0]), 
      .lz77_engine_2nd_ptr_offset       (lec_lob_type0_offset[15:0]), 
      .lz77_engine_last_output          (lec_lob_comp_eot),      
      
      .clk                              (clk),                   
      .rst_n                            (rst_n),                 
      .raw_rst_n                        (raw_rst_n),             
      .bypass_reset                     (bypass_reset),          
      .test_rst_n                       (test_rst_n),            
      .lz77_win_size                    ({1'b0,prc_lec_win_size[2:0]}), 
      .lz77_dly_match_win               (prc_lec_dly_match_win[1:0]), 
      .lz77_min_match_len               (prc_lec_min_match_len), 
      .lz77_max_match_len               ({1'b0,prc_lec_max_match_len[1:0]}), 
      .lz77_min_mtf_len                 (prc_lec_min_mtf_len),   
      .lz77_isXp9                       (prc_lec_isXp9),         
      .lz77_engine_data                 (prc_lec_sample_data[31:0]), 
      .lz77_engine_data_vld             (prc_lec_sample_data_vld[3:0]), 
      .lz77_engine_prefix_data          (prc_lec_prefix_data[63:0]), 
      .lz77_engine_prefix_data_vld      (prc_lec_prefix_data_vld[7:0]), 
      .lz77_engine_last                 (prc_lec_sample_eot),    
      .prc_lec_num_mtf                  (prc_lec_num_mtf));
`endif
   
endmodule 








