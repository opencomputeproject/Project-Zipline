/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



















`include "cr_lz77_comp.vh"
`include "cr_lz77_comp_pkg_include.vh"

module cr_lz77_engine_v3
  #(
    parameter    CLUSTERS       = `CLUSTERS,
    parameter    TILPC          = `TILES_PER_CLUSTER,
    parameter    OFFPT          = `OFFSETS_PER_TILE,
    parameter    IN_BYTES       = `IN_BYTES,
    parameter    TRUNC_NUM      = `TRUNC_NUM_V3,                     
    parameter    LONGL          = `LONGL_V3,
    parameter    MTF_NUM        = `MTF_NUM,
    parameter    TILE_MTF_NUM   = `TILE_MTF_NUM,
    parameter    LOG_WIN_OUT    = 16  
    )
   (
   
   lz77_engine_output_types, lz77_engine_literals,
   lz77_engine_ptr_offset, lz77_engine_ptr_length,
   lz77_engine_last_output, lec_prc_lz_error,
   
   clk, rst_n, raw_rst_n, bypass_reset, test_rst_n, lz77_win_size,
   lz77_dly_match_win, lz77_max_match_len, lz77_isXp9,
   lz77_engine_data, lz77_engine_data_vld, lz77_engine_prefix_data,
   lz77_engine_prefix_data_vld, lz77_engine_last, prc_lec_num_mtf,
   sw_SPARE, prc_lec_count
   );
   
`include "cr_lz77_comp_includes.vh"
`include "cr_lz77_comp_funcs.vh"
   
   localparam    LOG_CLUSTERS           = $clog2(CLUSTERS);
   localparam    OFFPC                  = OFFPT * TILPC;
   localparam    LOG_OFFPC              = $clog2(OFFPC);
   localparam    LOG_OFFPT              = $clog2(OFFPT);
   localparam    LOG_WIN                = LOG_OFFPC + LOG_CLUSTERS;
   
   
   
   input                          clk;
   input                          rst_n;
   input                          raw_rst_n;
   input                          bypass_reset;
   input                          test_rst_n;
   input [2:0]                    lz77_win_size;
   input [1:0]                    lz77_dly_match_win;
   input [1:0]                    lz77_max_match_len;
   input                          lz77_isXp9;
   input [IN_BYTES-1:0][7:0]      lz77_engine_data;
   input [IN_BYTES-1:0]           lz77_engine_data_vld;
   input [7:0][7:0]               lz77_engine_prefix_data;
   input [7:0]                    lz77_engine_prefix_data_vld;
   input                          lz77_engine_last;
   input                          prc_lec_num_mtf;

   input 			  spare_t sw_SPARE;
   input [7:0] 			  prc_lec_count;

   
   
   output [4:0][1:0]              lz77_engine_output_types;
   output [IN_BYTES-1:0][7:0]     lz77_engine_literals;
   output [LOG_WIN_OUT-1:0]       lz77_engine_ptr_offset;
   output [LOG_WIN_OUT-1:0]       lz77_engine_ptr_length;
   output                         lz77_engine_last_output;
   output 			  lec_prc_lz_error;
   

   
   

   genvar 			  e, ii;

   logic [8:0] 			  flush;
   logic [7:0] 			  last;
   logic [7:0] 			  input_en;
   
   logic [3:0][IN_BYTES-1:0][7:0] window_data;
   logic [3:0][IN_BYTES-1:0] 	  window_data_vld;
   logic [3:0][7:0][7:0]	  prefix_data;
   logic [3:0][7:0] 		  prefix_data_vld;
   logic [3:0][IN_BYTES-1:0][7:0] input_data;
   logic [3:0][IN_BYTES-1:0] 	  input_data_vld;
   logic [3:0][IN_BYTES-1:0][7:0] literal_data;
   logic [3:0][IN_BYTES-1:0] 	  literal_data_vld;
   logic 			  shift_en;
   logic  			  prefix_en;
   logic [2:0] 			  prc_me_win_size;
   logic [1:0] 			  prc_me_dly_match_win;
   logic [1:0] 			  prc_me_max_match_len;
   logic 			  prc_me_isXp9;
   logic 			  prc_me_num_mtf;
   logic 			  hold_me_config;
   logic [7:0] 			  seed;
   
   wire [CLUSTERS-1:0][TRUNC_NUM-1:0][LOG_OFFPC-1:0] clt_me_offset;
   wire [CLUSTERS-1:0][TRUNC_NUM-1:0][LONGL-1:0]     clt_me_fwd_therm;
   wire [TILE_MTF_NUM-1:0][LOG_OFFPT-1:0] 	     clt0_me_mtf_offset;
   wire [TILE_MTF_NUM-1:0][TRUNC_NUM-1:0] 	     clt0_me_mtf_phase;
   wire [TILE_MTF_NUM-1:0][11:0] 		     clt0_me_mtf_fwd_therm;
   wire [CLUSTERS-1:0][3:0] 			     clt_me_len4_ind;
   wire [CLUSTERS-1:0][2:0] 			     clt_me_len5_6_ind;
   wire [CLUSTERS-1:0] 				     clt_me_cont;
   wire [CLUSTERS-1:0][TRUNC_NUM-1:0] 		     clt_me_truncated;
   wire [CLUSTERS-1:0][5:0] 			     me_clt_dmw_cont;
   wire [CLUSTERS-1:0][1:0] 			     me_clt_max_match_len;
   wire [CLUSTERS-1:0][2:0] 			     me_clt_win_size;
   wire [MTF_NUM-1:0][LOG_OFFPT-1:0] 		     me_clt0_mtf_list;
   wire [MTF_NUM-1:0] 				     me_clt0_mtf_list_valid;
   wire [CLUSTERS-1:0][IN_BYTES-1:0][7:0]            shift_data;
   wire [CLUSTERS-1:0][IN_BYTES-1:0]                 shift_data_vld ;
   wire [CLUSTERS-1:0][63:0]                         prefix_shift_data;
   wire [CLUSTERS-1:0][7:0] 			     prefix_shift_data_vld;
   wire [CLUSTERS-1:0][TILPC-1:0] 		     me_tile_enable;


   

`ifdef CR_LZ77_COMP_VIRTUALIZED_LPO

   
   
   

   
   cr_lz77_comp_clt_0
     #(
       .TILPC          (TILPC),
       .OFFPT          (OFFPT),
       .IN_BYTES       (IN_BYTES),
       .TRUNC_NUM      (TRUNC_NUM),
       .LONGL          (LONGL),
       .MTF_NUM        (MTF_NUM),
       .TILE_MTF_NUM   (TILE_MTF_NUM)
       )
   clt_0
     (
      
      .lz77_cluster_shift_data_out      (shift_data[0]),         
      .lz77_cluster_shift_data_out_vld  (shift_data_vld[0]),     
      .lz77_cluster_prefix_data_out     (prefix_shift_data[0]),  
      .lz77_cluster_prefix_data_vld_out (prefix_shift_data_vld[0]), 
      .cl_me_offset                     (clt_me_offset[0]),      
      .cl_me_fwd_therm                  (clt_me_fwd_therm[0]),   
      .cl_me_cont                       (clt_me_cont[0]),        
      .cl_me_len4_ind                   (clt_me_len4_ind[0]),    
      .cl_me_len5_6_ind                 (clt_me_len5_6_ind[0]),  
      .cl_me_truncated                  (clt_me_truncated[0]),   
      .clt0_me_mtf_offset               (clt0_me_mtf_offset),    
      .clt0_me_mtf_phase                (clt0_me_mtf_phase),     
      .clt0_me_mtf_fwd_therm            (clt0_me_mtf_fwd_therm), 
      
      .clk                              (clk),
      .raw_rst_n                        (raw_rst_n),
      .bypass_reset                     (bypass_reset),
      .test_rst_n                       (test_rst_n),
      .lz77_cluster_shift_data          (window_data[1]),        
      .lz77_cluster_shift_data_vld      (window_data_vld[1]),    
      .lz77_cluster_prefix_data         (prefix_data[0]),        
      .lz77_cluster_prefix_data_vld     (prefix_data_vld[0]),    
      .lz77_cluster_data                (input_data[0]),         
      .lz77_cluster_data_vld            (input_data_vld[0]),     
      .scramble_enb                     (sw_SPARE.f.spare[1]),   
      .shift_en                         (shift_en),              
      .input_en                         (input_en[0]),           
      .prefix_en                        (prefix_en),             
      .clr_valid                        (last[0]),               
      .me_cl_dmw_cont                   (me_clt_dmw_cont[0]),    
      .me_tile_enable                   (me_tile_enable[0]),     
      .me_cl_max_match_len              (me_clt_max_match_len[0]), 
      .me_cl_win_size                   (me_clt_win_size[0]),    
      .me_clt0_mtf_list                 (me_clt0_mtf_list),      
      .me_clt0_mtf_list_valid           (me_clt0_mtf_list_valid)); 


   logic [CLUSTERS-1:0][IN_BYTES-1:0][7:0]           scrambled_input_data;

   assign scrambled_input_data[0] = input_data[0];

   generate
      for (e=1; e<CLUSTERS; e++) begin: scramble_cluster_loop
         for (ii=0; ii<IN_BYTES; ii++) begin: scramble_byte_loop
            always_comb begin
               logic [7:0] scrambled_byte;
               scrambled_byte = scrambled_input_data[e-1][ii];
               for (int i=0; i<TILPC; i++)
                 scrambled_byte = byte_scramble(scrambled_byte);
               scrambled_input_data[e][ii] = scrambled_byte;
            end
         end
      end
   endgenerate

   
   cr_lz77_comp_clt_x8
     #(
       .TILPC          (TILPC),
       .OFFPT          (OFFPT),
       .IN_BYTES       (IN_BYTES),
       .TRUNC_NUM      (TRUNC_NUM),
       .LONGL          (LONGL)
       )
   clt_x8
     (
      
      .lz77_cluster_shift_data_out      (shift_data[1]),         
      .lz77_cluster_shift_data_out_vld  (shift_data_vld[1]),     
      .lz77_cluster_prefix_data_out     (prefix_shift_data[1]),  
      .lz77_cluster_prefix_data_vld_out (prefix_shift_data_vld[1]), 
      .cl_me_offset                     (clt_me_offset[1]),      
      .cl_me_fwd_therm                  (clt_me_fwd_therm[1]),   
      .cl_me_cont                       (clt_me_cont[1]),        
      .cl_me_len4_ind                   (clt_me_len4_ind[1]),    
      .cl_me_len5_6_ind                 (clt_me_len5_6_ind[1]),  
      .cl_me_truncated                  (clt_me_truncated[1]),   
      
      .clk                              (clk),
      .raw_rst_n                        (raw_rst_n),
      .bypass_reset                     (bypass_reset),
      .test_rst_n                       (test_rst_n),
      .lz77_cluster_shift_data          (shift_data[0]),         
      .lz77_cluster_shift_data_vld      (shift_data_vld[0]),     
      .lz77_cluster_prefix_data         (prefix_shift_data[0]),  
      .lz77_cluster_prefix_data_vld     (prefix_shift_data_vld[0]), 
      .lz77_cluster_data                (sw_SPARE.f.spare[1] ? input_data[0] : scrambled_input_data[1]), 
      .lz77_cluster_data_vld            (input_data_vld[0]),     
      .scramble_enb                     (sw_SPARE.f.spare[1]),   
      .shift_en                         (shift_en),              
      .input_en                         (input_en[0]),           
      .prefix_en                        (prefix_en),             
      .clr_valid                        (last[0]),               
      .me_cl_dmw_cont                   (me_clt_dmw_cont[1]),    
      .me_tile_enable                   (me_tile_enable[1]),     
      .me_cl_max_match_len              (me_clt_max_match_len[1]), 
      .me_cl_win_size                   (me_clt_win_size[1]));    


   
   generate 
      for(e=2; e<CLUSTERS; e=e+1) begin  : gen_cluster

 	 cr_lz77_comp_clt_x16
 	    #(
 	      .TILPC          (TILPC),
 	      .OFFPT          (OFFPT),
 	      .IN_BYTES       (IN_BYTES),
 	      .TRUNC_NUM      (TRUNC_NUM),
 	      .LONGL          (LONGL)
 	      )
 	 clt_x16
 	    (
             
             .lz77_cluster_shift_data_out(shift_data[e]),        
             .lz77_cluster_shift_data_out_vld(shift_data_vld[e]), 
             .lz77_cluster_prefix_data_out(prefix_shift_data[e]), 
             .lz77_cluster_prefix_data_vld_out(prefix_shift_data_vld[e]), 
             .cl_me_offset              (clt_me_offset[e]),      
             .cl_me_fwd_therm           (clt_me_fwd_therm[e]),   
             .cl_me_cont                (clt_me_cont[e]),        
             .cl_me_len4_ind            (clt_me_len4_ind[e]),    
             .cl_me_len5_6_ind          (clt_me_len5_6_ind[e]),  
             .cl_me_truncated           (clt_me_truncated[e]),   
             
             .clk                       (clk),
             .raw_rst_n                 (raw_rst_n),
             .bypass_reset              (bypass_reset),
             .test_rst_n                (test_rst_n),
             .lz77_cluster_shift_data   (shift_data[e-1]),       
             .lz77_cluster_shift_data_vld(shift_data_vld[e-1]),  
             .lz77_cluster_prefix_data  (prefix_shift_data[e-1]), 
             .lz77_cluster_prefix_data_vld(prefix_shift_data_vld[e-1]), 
             .lz77_cluster_data         (sw_SPARE.f.spare[1] ? input_data[0] : scrambled_input_data[e]), 
             .lz77_cluster_data_vld     (input_data_vld[0]),     
             .scramble_enb              (sw_SPARE.f.spare[1]),   
             .shift_en                  (shift_en),              
             .input_en                  (input_en[0]),           
             .prefix_en                 (prefix_en),             
             .clr_valid                 (last[0]),               
             .me_cl_dmw_cont            (me_clt_dmw_cont[e]),    
             .me_tile_enable            (me_tile_enable[e]),     
             .me_cl_max_match_len       (me_clt_max_match_len[e]), 
             .me_cl_win_size            (me_clt_win_size[e]));    

      end
   endgenerate

`else
   
   
   
   


   
   generate 
      for(e=1; e<CLUSTERS; e=e+1) begin  : gen_cluster










      end
   endgenerate

`endif

   
   
   
    
    cr_lz77_comp_match
      #(
        .TILPC          (TILPC),
        .OFFPT          (OFFPT),
        .IN_BYTES       (IN_BYTES),
        .CLUSTERS       (CLUSTERS),
        .TRUNC_NUM      (TRUNC_NUM),
        .LONGL          (LONGL)
        )
    match
      (
`ifdef LPO_BM_PIPELINE
       .me_last                         (last[1]),
       .me_literal_data                 (literal_data[1]),
       .me_literal_data_valid           (literal_data_vld[1]),
`else
       .me_last                         (last[0]),
       .me_literal_data                 (literal_data[0]),
       .me_literal_data_valid           (literal_data_vld[0]),
`endif       
       
       
       .me_clt_dmw_cont                 (me_clt_dmw_cont),
       .me_clt0_mtf_list                (me_clt0_mtf_list),
       .me_clt0_mtf_list_valid          (me_clt0_mtf_list_valid[MTF_NUM-1:0]),
       .me_tile_enable                  (me_tile_enable),
       .me_clt_max_match_len            (me_clt_max_match_len),
       .me_clt_win_size                 (me_clt_win_size),
       .me_output_type                  (lz77_engine_output_types), 
       .me_literal                      (lz77_engine_literals),  
       .me_ptr_length                   (lz77_engine_ptr_length), 
       .me_ptr_offset                   (lz77_engine_ptr_offset), 
       .me_last_output                  (lz77_engine_last_output), 
       .lec_prc_lz_error                (lec_prc_lz_error),
       
       .clk                             (clk),
       .rst_n                           (rst_n),
       .clt_me_offset                   (clt_me_offset),
       .clt_me_fwd_therm                (clt_me_fwd_therm),
       .clt_me_truncated                (clt_me_truncated),
       .clt0_me_mtf_offset              (clt0_me_mtf_offset),
       .clt0_me_mtf_phase               (clt0_me_mtf_phase),
       .clt0_me_mtf_fwd_therm           (clt0_me_mtf_fwd_therm),
       .clt_me_len4_ind                 (clt_me_len4_ind),
       .clt_me_len5_6_ind               (clt_me_len5_6_ind),
       .clt_me_cont                     (clt_me_cont[CLUSTERS-1:0]),
       .me_win_size                     (prc_me_win_size),       
       .me_dly_match_win                (prc_me_dly_match_win),  
       .me_max_match_len                (prc_me_max_match_len),  
       .me_isXp9                        (prc_me_isXp9),          
       .me_num_mtf                      (prc_me_num_mtf));        
    

   
   
   
   logic [7:0][7:0] crc_data;

   always_comb begin
      for (int i=0; i<8; i++) begin
         crc_data[i] = crc8(lz77_engine_prefix_data[i], seed, 4'd8);
      end
   end

   always@(posedge clk or negedge rst_n) begin
      if(~rst_n) begin

	 flush            <= 8'b0;
	 last             <= 8'b0;
	 input_en         <= 8'b0;

	 for (int i=0; i<4; i=i+1) begin
	    window_data[i]      <= 32'b0;
	    window_data_vld[i]  <= 4'b0;
	    prefix_data[i]      <= 64'b0;
	    prefix_data_vld[i]  <= 8'b0;
	    input_data[i]       <= 32'b0;
	    input_data_vld[i]   <= 4'b0;
	    literal_data[i]     <= 32'b0;
	    literal_data_vld[i] <= 4'b0;
	    
	    
	 end

	 prc_me_win_size       <= 3'b0;
	 prc_me_dly_match_win  <= 2'b0;
	 prc_me_max_match_len  <= 2'b0;
	 prc_me_isXp9          <= 1'b0;
	 prc_me_num_mtf        <= 1'b0;
	 hold_me_config        <= 1'b0;
	 seed                  <= 8'b0;

      end
      else begin

	 
	 if (|lz77_engine_data_vld)
	   hold_me_config  <= 1'b1;
	 else if (lz77_engine_last_output)
	   hold_me_config  <= 1'b0;
	 
	 if ( last[0] )
	   seed <= prc_lec_count;

	 if (!hold_me_config) begin
	    prc_me_win_size       <= lz77_win_size;
	    prc_me_dly_match_win  <= lz77_dly_match_win;
	    prc_me_max_match_len  <= lz77_max_match_len;
	    prc_me_isXp9          <= lz77_isXp9;
	    prc_me_num_mtf        <= prc_lec_num_mtf;
	 end

	 
	 for (int i=0; i<4; i+=1) begin
	    
	    if (sw_SPARE.f.spare[0]) begin
	       window_data[0][i] <= lz77_engine_data[i];
	       input_data[0][i]  <= lz77_engine_data[i];
	    end
	    else begin
               logic [7:0] v_crc;
	       window_data[0][i] <= crc_data[i];
	       input_data[0][i]  <= crc_data[i];
	    end
	    
	    literal_data[0][i]  <= lz77_engine_data[i];

	 end
	 
	 for (int i=0; i<8; i+=1) begin
	    if (sw_SPARE.f.spare[0]) begin
	       prefix_data[0][i] <= lz77_engine_prefix_data[i];
	    end
	    else begin
	       prefix_data[0][i] <= crc_data[i];
	    end
	 end
	 

	 window_data_vld[0]    <= lz77_engine_data_vld;
	 prefix_data_vld[0]    <= lz77_engine_prefix_data_vld;
	 input_data_vld[0]     <= lz77_engine_data_vld;
	 literal_data_vld[0]   <= lz77_engine_data_vld;
	 
	 input_en[0]           <= |lz77_engine_data_vld || flush[3]; 
	 
	 last[0]               <= lz77_engine_last;

	 window_data[3:1]      <= window_data[2:0];
	 window_data_vld[3:1]  <= window_data_vld[2:0];
	 prefix_data[3:1]      <= prefix_data[2:0];
	 prefix_data_vld[3:1]  <= prefix_data_vld[2:0];
	 input_data[3:1]       <= input_data[2:0];
	 literal_data[3:1]     <= literal_data[2:0];
	 input_data_vld[3:1]   <= input_data_vld[2:0];
	 literal_data_vld[3:1] <= literal_data_vld[2:0];
	 
	 

	 input_en[7:1]         <= input_en[6:0];
	 last[7:1]             <= last[6:0];

	 if (lz77_engine_last)
	   flush <= 8'hff;
	 else
	   flush <= {flush[6:0],1'b0};

      end
   end

   assign shift_en = |lz77_engine_data_vld;
   assign prefix_en = |lz77_engine_prefix_data_vld;

   
   `CCX_STD_DECLARE_CRC(crc8, 8'h9b,      8,         8         );

endmodule 







