/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_lz77_comp.vh"

module cr_lz77_comp_clt_0
  #(
    parameter TILPC          = `TILES_PER_CLUSTER,
    parameter OFFPT          = `OFFSETS_PER_TILE,
    parameter IN_BYTES       = `IN_BYTES,
    parameter TRUNC_NUM      = `TRUNC_NUM_V3,
    parameter LONGL          = `LONGL_V3,
    parameter MTF_NUM        = `MTF_NUM,
    parameter TILE_MTF_NUM   = `TILE_MTF_NUM
    )
   (
   
   lz77_cluster_shift_data_out, lz77_cluster_shift_data_out_vld,
   lz77_cluster_prefix_data_out, lz77_cluster_prefix_data_vld_out,
   cl_me_offset, cl_me_fwd_therm, cl_me_cont, cl_me_len4_ind,
   cl_me_len5_6_ind, cl_me_truncated, clt0_me_mtf_offset,
   clt0_me_mtf_phase, clt0_me_mtf_fwd_therm,
   
   clk, raw_rst_n, bypass_reset, test_rst_n, lz77_cluster_shift_data,
   lz77_cluster_shift_data_vld, lz77_cluster_prefix_data,
   lz77_cluster_prefix_data_vld, lz77_cluster_data,
   lz77_cluster_data_vld, scramble_enb, shift_en, input_en, prefix_en,
   clr_valid, me_cl_dmw_cont, me_tile_enable, me_cl_max_match_len,
   me_cl_win_size, me_clt0_mtf_list, me_clt0_mtf_list_valid
   );   


   
   localparam LOG_OFFPT      = $clog2(OFFPT);
   localparam LOG_TILPC      = $clog2(TILPC);
   localparam OFFPC          = OFFPT * TILPC;
   localparam LOG_OFFPC      = $clog2(OFFPC);

   
   input                                        clk;
   input 					raw_rst_n;
   input 					bypass_reset;
   input 					test_rst_n;
 
   
   input [IN_BYTES*8-1:0] 			lz77_cluster_shift_data;
   input [IN_BYTES-1:0] 			lz77_cluster_shift_data_vld;
   output reg [IN_BYTES*8-1:0] 			lz77_cluster_shift_data_out;     
   output reg [IN_BYTES-1:0] 			lz77_cluster_shift_data_out_vld;

   
   input [63:0] 				lz77_cluster_prefix_data;
   input [7:0] 					lz77_cluster_prefix_data_vld;
   output reg [63:0] 				lz77_cluster_prefix_data_out;
   output reg [7:0] 				lz77_cluster_prefix_data_vld_out;

   
   input [IN_BYTES*8-1:0] 			lz77_cluster_data;
   input [IN_BYTES-1:0] 			lz77_cluster_data_vld;


   
   
   input                                        scramble_enb;
   input 					shift_en;
   input 					input_en;
   input 					prefix_en;
   input 					clr_valid;

   input [5:0] 					me_cl_dmw_cont;
   input [TILPC-1:0] 				me_tile_enable;
   input [1:0] 					me_cl_max_match_len;
   input [2:0] 					me_cl_win_size;
   
   
   output reg [3:0][LOG_OFFPC -1:0] 		cl_me_offset;
   output reg [3:0][LONGL-1:0] 			cl_me_fwd_therm;
   output reg					cl_me_cont;
   output reg [3:0] 				cl_me_len4_ind;
   output reg [2:0] 				cl_me_len5_6_ind;
   output reg [TRUNC_NUM-1:0] 			cl_me_truncated;  

   
   input [MTF_NUM-1:0][LOG_OFFPT-1:0] 		me_clt0_mtf_list;
   input [MTF_NUM-1:0] 				me_clt0_mtf_list_valid;
   output reg [TILE_MTF_NUM-1:0][LOG_OFFPT-1:0] clt0_me_mtf_offset;
   output reg [TILE_MTF_NUM-1:0][3:0] 		clt0_me_mtf_phase;
   output reg [TILE_MTF_NUM-1:0][11:0] 		clt0_me_mtf_fwd_therm;

`include "cr_lz77_comp_funcs.vh"   

`ifdef SHOULD_BE_EMPTY
   
   
`endif

   logic [TILPC-1:0]                    me_tile_enable_r;
   logic                                shift_en_r;
   logic                                prefix_en_r;
   logic                                clr_valid_r;
   logic [IN_BYTES-1:0]                 lz77_cluster_data_vld_r;
   logic [IN_BYTES*8-1:0]               lz77_cluster_data_r;
   logic [IN_BYTES*2-1:0]               lz77_cluster_prefix_data_vld_r;
   logic [IN_BYTES*2*8-1:0]             lz77_cluster_prefix_data_r;

   logic                                                           scramble_enb_r;

   logic [5:0]                          me_cl_dmw_cont_r;
   
   logic [TRUNC_NUM-1:0][TILPC-1:0][LONGL-1:0] 			   ti_longest_therm_in;
   logic [TRUNC_NUM-1:0][TILPC-1:0][LOG_OFFPT-1:0]     	           ti_first_offset_in;
   logic [TRUNC_NUM-1:0][LONGL-1:0] 				   cl_longest_therm_out;
   logic [TRUNC_NUM-1:0][LOG_OFFPC-1:0] 			   cl_first_offset_out;
   
   logic [TILPC-1:0] [31:0] 					   tile_prefix_data;
   logic [TILPC-1:0] [3:0] 					   tile_prefix_data_vld;

   logic [TILPC-1:0] [31:0] 					   shift_data;
   logic [TILPC-1:0] [3:0] 					   shift_data_vld;

   logic [TILPC-1:0] [31:0] 					   shift_data_posedge;
   logic [TILPC-1:0] [3:0] 					   shift_data_vld_posedge;
   
   logic [3:0] 							   len4_ind;
   logic [2:0] 							   len5_6_ind;
   logic [3:0] 							   cont_phases_r;
   logic [3:0] 							   cont_phases_2r;
   logic [5:0] 							   cluster_cont_phases;
   logic [3:0] 							   cluster_cont_valid_phases;
   logic [3:0] 							   ongoing_cont_r;
	    
   
   logic [3:0] 							   cl_ti_cont_phases;
   logic [3:0] 							   cl_ti_ongoing_cont_phases;
   
   logic [TILPC-1:0][TRUNC_NUM-1:0][LONGL-1:0] 			   ti_cl_fwd_therm;
   logic [TILPC-1:0][TRUNC_NUM-1:0][LOG_OFFPT-1:0] 		   ti_cl_offset;
   logic [TILPC-1:0][3:0] 					   ti_cl_len4_ind;
   logic [TILPC-1:0][2:0] 					   ti_cl_len5_6_ind;
   logic [2:0]                                                     input_en_r;
   logic 							   cl_ti_force_done;
   logic [LONGL-1:0] 						   ph4_mask;
   logic [LONGL-1:0] 						   ph3_mask;
   logic [LONGL-1:0] 						   ph2_mask;
   logic [LONGL-1:0] 						   ph1_mask;
   logic [16:0] 						   max_match_len;
   logic [16:0] 						   ph4_len;
   logic [16:0] 						   ph3_len;
   logic [16:0] 						   ph2_len;
   logic [16:0] 						   ph1_len;
   logic [16:0] 						   ph4_count;
   logic [16:0] 						   ph3_count;
   logic [16:0] 						   ph2_count;
   logic [16:0] 						   ph1_count;
   logic 							   force_done_r;
   logic [16:0] 						   ph4_initial_value;
   logic [16:0] 						   ph3_initial_value;
   logic [16:0] 						   ph2_initial_value;
   logic [16:0] 						   ph1_initial_value;
   logic [5:0] 							   clt_dmw;
   logic [5:0]							   clt_dmw_r;
   logic 							   ph4_is_in_dmw;
   logic 							   ph3_is_in_dmw;
   logic 							   ph2_is_in_dmw;
   logic 							   ph1_is_in_dmw;

   wire                                                            clt_rst_n;
   wire [TILPC-1:0]                                                rst_n;

   
   wire [5:0] 							   cl_ti_dmw_cont = me_cl_dmw_cont;

   always @ (*) begin
      
      tile_prefix_data[0]     = lz77_cluster_prefix_data_r[31:0];
      tile_prefix_data_vld[0] = lz77_cluster_prefix_data_vld_r[3:0];
      for (int j=0; j<IN_BYTES; j++)
        tile_prefix_data[1][j*8 +: 8]     = scramble_enb_r ? lz77_cluster_prefix_data_r[32+j*8 +: 8] : byte_scramble(lz77_cluster_prefix_data_r[32+j*8 +: 8]);
      tile_prefix_data_vld[1] = lz77_cluster_prefix_data_vld_r[7:4];
      
      for(int i=2; i<TILPC; i=i+1) begin
         for (int j=0; j<IN_BYTES; j++)
	   tile_prefix_data[i][j*8 +: 8]     = scramble_enb_r ? shift_data[i-2][j*8 +: 8] : byte_scramble(shift_data[i-2][j*8 +: 8]);
	 tile_prefix_data_vld[i] = shift_data_vld[i-2];
      end

      lz77_cluster_shift_data_out      = shift_data_posedge[TILPC-1];
      lz77_cluster_shift_data_out_vld  = shift_data_vld_posedge[TILPC-1];
      for (int j=0; j<IN_BYTES; j++) begin
         
         lz77_cluster_prefix_data_out[32+j*8 +:8] = shift_data[TILPC-1][j*8 +: 8];
         lz77_cluster_prefix_data_out[j*8 +: 8]   = scramble_enb_r ? shift_data[TILPC-2][j*8 +: 8] : byte_scramble(shift_data[TILPC-2][j*8 +: 8]);
      end
      lz77_cluster_prefix_data_vld_out = {shift_data_vld[TILPC-1], shift_data_vld[TILPC-2]};
      

      
      len4_ind   = 4'd0 ;
      len5_6_ind = 3'd0;
      
      for (int tile=0; tile<TILPC; tile=tile+1) begin
	 len4_ind   = len4_ind   | ti_cl_len4_ind  [tile];
	 len5_6_ind = len5_6_ind | ti_cl_len5_6_ind[tile];	 
      end
      
      cl_ti_cont_phases[3] = cl_longest_therm_out[3][LONGL-1];
      cl_ti_cont_phases[2] = cl_longest_therm_out[2][LONGL-1];
      cl_ti_cont_phases[1] = cl_longest_therm_out[1][LONGL-1];
      cl_ti_cont_phases[0] = cl_longest_therm_out[0][LONGL-1];
      
      cl_ti_ongoing_cont_phases[3] = cl_longest_therm_out[3][LONGL-1];
      cl_ti_ongoing_cont_phases[2] = cl_longest_therm_out[2][LONGL-1];
      cl_ti_ongoing_cont_phases[1] = cl_longest_therm_out[1][LONGL-1];
      cl_ti_ongoing_cont_phases[0] = cl_longest_therm_out[0][LONGL-1];
      
      cluster_cont_phases = {cont_phases_2r[3:0],cont_phases_r[3:2]};
      
      
      
      
      
      clt_dmw = (me_cl_dmw_cont_r == 6'b0) ? 
		clt_dmw_r :
		me_cl_dmw_cont_r;
      
      ph4_is_in_dmw = clt_dmw[5] || clt_dmw[1];
      ph3_is_in_dmw = clt_dmw[4] || clt_dmw[0];
      ph2_is_in_dmw = clt_dmw[3];
      ph1_is_in_dmw = clt_dmw[2];


      
      
      

      
      if (me_cl_dmw_cont_r[5]) begin
	 ph4_initial_value = 17'd24;
      end
      else if (me_cl_dmw_cont_r[1]) begin
	 ph4_initial_value = 17'd20;
      end
      else begin
	 ph4_initial_value = 17'd0;
      end
      
      
      if (me_cl_dmw_cont_r[4]) begin
	 ph3_initial_value = 17'd23;
      end
      else if (me_cl_dmw_cont_r[0]) begin
	 ph3_initial_value = 17'd19;
      end
      else begin
	 ph3_initial_value = 17'd0;
      end
      
      
      if (me_cl_dmw_cont_r[3]) begin
	 ph2_initial_value = 17'd22;
      end
      else begin
	 ph2_initial_value = 17'd0;
      end
      
      
      if (me_cl_dmw_cont_r[2]) begin
	 ph1_initial_value = 17'd21;
      end
      else begin
	 ph1_initial_value = 17'd0;
      end

      
      if (|me_cl_dmw_cont_r) begin
	 ph4_len = ph4_initial_value;
	 ph3_len = ph3_initial_value;
	 ph2_len = ph2_initial_value;
	 ph1_len = ph1_initial_value;
      end
      else begin
	 ph4_len = ph4_count;
	 ph3_len = ph3_count;
	 ph2_len = ph2_count;
	 ph1_len = ph1_count;
      end 
      

      
      
      
      
      
      
      
      ph4_mask = {LONGL{1'b1}};
      ph3_mask = {LONGL{1'b1}};
      ph2_mask = {LONGL{1'b1}};
      ph1_mask = {LONGL{1'b1}};
      if (|ph4_len) begin
	 for (int i=0; i<10; i=i+1) begin
	    ph4_mask[(LONGL-1) - i] = (max_match_len >= (ph4_len - i) );
	 end
      end
      if (|ph3_len) begin
	 for (int i=0; i<9; i=i+1) begin
	    ph3_mask[(LONGL-1) - i] = (max_match_len >= (ph3_len - i) );
	 end
      end
      if (|ph2_len) begin
	 for (int i=0; i<8; i=i+1) begin
	    ph2_mask[(LONGL-1) - i] = (max_match_len >= (ph2_len - i) );
	 end
      end
      if (|ph1_len) begin
	 for (int i=0; i<8; i=i+1) begin
	    ph1_mask[(LONGL-1) - i] = (max_match_len >= (ph1_len - i) );
	 end
      end

      
      
      
      cl_ti_force_done = ( (max_match_len < ph4_len) || !ph4_is_in_dmw ) &&
			 ( (max_match_len < ph3_len) || !ph3_is_in_dmw ) &&
			 ( (max_match_len < ph2_len) || !ph2_is_in_dmw ) &&
			 ( (max_match_len < ph1_len) || !ph1_is_in_dmw );

   end 

   
   always_ff@(posedge clk) begin
      for (int tile_index=0; tile_index<TILPC; tile_index++) begin
         shift_data_posedge[tile_index] <= shift_data[tile_index];
         shift_data_vld_posedge[tile_index] <= shift_data_vld[tile_index];
      end
      me_tile_enable_r <= me_tile_enable;
      shift_en_r <= shift_en;
      prefix_en_r <= prefix_en;
      clr_valid_r <= clr_valid;
      lz77_cluster_data_vld_r <= lz77_cluster_data_vld;
      lz77_cluster_data_r <= lz77_cluster_data;
      lz77_cluster_prefix_data_vld_r <= lz77_cluster_prefix_data_vld;
      lz77_cluster_prefix_data_r <= lz77_cluster_prefix_data;
   end
   
  

   always @ (posedge clk or negedge clt_rst_n) begin
      if (!clt_rst_n) begin
	 cl_me_cont          <= 1'h0;
	 cl_me_fwd_therm     <= {4{{LONGL{1'b0}}}};
	 cl_me_len4_ind      <= 4'h0;
	 cl_me_len5_6_ind    <= 3'h0;
	 cl_me_offset        <= {(1+(LOG_OFFPT-1)){1'b0}};
	 cont_phases_r       <= 4'h0;
	 cont_phases_2r      <= 4'h0;
	 me_cl_dmw_cont_r    <= 6'h0;
	 input_en_r          <= 3'b0;
	 cluster_cont_valid_phases <= 4'b0;
	 ongoing_cont_r      <= 4'h0;

	 max_match_len       <= 17'b0;
	 ph4_count           <= 17'b0;
	 ph3_count           <= 17'b0;
	 ph2_count           <= 17'b0;
	 ph1_count           <= 17'b0;
	 force_done_r        <= 1'b0;
	 clt_dmw_r           <= 6'b0;
  	 cl_me_truncated     <= {TRUNC_NUM{1'b0}};

         scramble_enb_r      <= 1'b0;
	 
      end
      else begin 
         scramble_enb_r <= scramble_enb;

	 
         input_en_r        <= {input_en_r[1:0], input_en};

	 case (me_cl_max_match_len)
	   2'b01 : max_match_len <= 17'h00102;  
	   2'b10 : max_match_len <= 17'h00012;  
	   2'b11 : max_match_len <= 17'h00040;  
	   default : begin                      
	      case (me_cl_win_size)
		3'd0    : max_match_len <= 17'h00200; 
		3'd1    : max_match_len <= 17'h01000; 
		3'd2    : max_match_len <= 17'h02000; 
		3'd3    : max_match_len <= 17'h04000; 
		3'd4    : max_match_len <= 17'h08000; 
		default : max_match_len <= 17'h0ffff; 
	      endcase 
	   end
	 endcase 

	 if (input_en_r[2]) begin
	    cont_phases_r    <= cl_ti_cont_phases;
	    cont_phases_2r   <= cont_phases_r;
	    me_cl_dmw_cont_r <= me_cl_dmw_cont;
	    ongoing_cont_r   <= cl_ti_ongoing_cont_phases;
	    force_done_r     <= cl_ti_force_done;
	    clt_dmw_r        <= clt_dmw;
    
	    
	    
	    
	    
	    
	    cl_me_cont <= (
			   
			   
			   (  ( cluster_cont_phases > me_cl_dmw_cont_r) && |me_cl_dmw_cont_r) ||
			   
			   ( |( cluster_cont_phases & me_cl_dmw_cont_r) && |me_cl_dmw_cont_r) ||
			   
			   ( |(cluster_cont_valid_phases & ongoing_cont_r) &&
			     cl_me_cont && !force_done_r)
			   );
	    
	    
	    if (|me_cl_dmw_cont_r) begin
	       if ( cluster_cont_phases > me_cl_dmw_cont_r) begin
		  cluster_cont_valid_phases <= me_cl_dmw_cont_r[5:2] | {me_cl_dmw_cont_r[1:0],2'b0};
	       end
	       else begin
		  cluster_cont_valid_phases <= (cluster_cont_phases[5:2] & me_cl_dmw_cont_r[5:2]) |
					       ({cluster_cont_phases[1:0],2'b0} & {me_cl_dmw_cont_r[1:0],2'b0});
	       end
	    end

	    cl_me_offset       <= cl_first_offset_out;
  	    cl_me_fwd_therm[3] <= cl_longest_therm_out[3] & ph4_mask;
  	    cl_me_fwd_therm[2] <= cl_longest_therm_out[2] & ph3_mask;
  	    cl_me_fwd_therm[1] <= cl_longest_therm_out[1] & ph2_mask;
  	    cl_me_fwd_therm[0] <= cl_longest_therm_out[0] & ph1_mask;
	       
 	    cl_me_len4_ind    <= len4_ind;
 	    cl_me_len5_6_ind  <= len5_6_ind;

	    
	    
	    
	    
	    

	    
	    if (me_cl_dmw_cont_r[5] || me_cl_dmw_cont_r[1]) begin
	       ph4_count <= ph4_initial_value + 4;
	    end
	    else if ( ( ph4_count != 17'b0 ) &&
		      ( !cl_ti_force_done ) &&
		      ( |(cluster_cont_valid_phases & ongoing_cont_r) && cl_me_cont )
		      ) begin
	       ph4_count <= ph4_count + 4;
	    end
	    else begin
	       ph4_count <= 17'b0;
	    end
	    
	    
	    if (me_cl_dmw_cont_r[4] || me_cl_dmw_cont_r[0]) begin
	       ph3_count <= ph3_initial_value + 4;
	    end
	    else if ( ( ph3_count != 17'b0 ) &&
		      ( !cl_ti_force_done ) &&
		      ( |(cluster_cont_valid_phases & ongoing_cont_r) && cl_me_cont )
		      ) begin
	       ph3_count <= ph3_count + 4;
	    end
	    else begin
	       ph3_count <= 17'b0;
	    end
	    
	    
	    if (me_cl_dmw_cont_r[3]) begin
	       ph2_count <= ph2_initial_value + 4;
	    end
	    else if ( ( ph2_count != 17'b0 ) &&
		      ( !cl_ti_force_done ) &&
		      ( |(cluster_cont_valid_phases & ongoing_cont_r) && cl_me_cont )
		      ) begin
	       ph2_count <= ph2_count + 4;
	    end
	    else begin
	       ph2_count <= 17'b0;
	    end
	    
	    
	    if (me_cl_dmw_cont_r[2]) begin
	       ph1_count <= ph1_initial_value + 4;
	    end
	    else if ( ( ph1_count != 17'b0 ) &&
		      ( !cl_ti_force_done ) &&
		      ( |(cluster_cont_valid_phases & ongoing_cont_r) && cl_me_cont )
		      ) begin
	       ph1_count <= ph1_count + 4;
	    end
	    else begin
	       ph1_count <= 17'b0;
	    end
	    
	    
	    
	    
	    
	    
	    
	    
	    
  	    cl_me_truncated[3] <= |(cl_longest_therm_out[3] & ~ph4_mask);
  	    cl_me_truncated[2] <= |(cl_longest_therm_out[2] & ~ph3_mask);
  	    cl_me_truncated[1] <= |(cl_longest_therm_out[1] & ~ph2_mask);
  	    cl_me_truncated[0] <= |(cl_longest_therm_out[0] & ~ph1_mask);
	    
	 end 

      end 
   end 
   

   logic [$clog2(`CR_LZ77_TILE_X1_SHIFT_MULT)-1:0] tile_x1_shift_start_phase;
   logic [$clog2(`CR_LZ77_TILE_X8_CLT0_SHIFT_MULT)-1:0] tile_x8_shift_start_phase;

   cr_rst_sync tile_x1_rst
     (
      .clk           (clk),
      .async_rst_n   (clt_rst_n),
      .bypass_reset  (bypass_reset),
      .test_rst_n    (test_rst_n),
      .rst_n         (rst_n[0])
      ); 
   

   cr_lz77_comp_tile_x1
     #(
       .TILE_DEPTH(OFFPT),
       .IN_BYTES  (IN_BYTES),
       .TRUNC_NUM (TRUNC_NUM),
       .MTF_NUM   (MTF_NUM),
       .LONGL     (LONGL),
       .FIRST_TILE (1)
       )
   tile_x1
     (
      .clk                           (clk),
      .rst_n                         (rst_n[0]),
      .shift_start_phase             ($bits(tile_x1_shift_start_phase)'
				      (0)),
      .scramble_enb                  (scramble_enb_r),
      .shift_en                      (shift_en_r),
      .input_en                      (input_en_r[0]),
      .prefix_en                     (prefix_en_r),
      .me_tile_enable                (me_tile_enable_r[0]),

      .cl_ti_clr_valid               (clr_valid_r),
      
      .lz77_tile_shift_data          (lz77_cluster_shift_data), 
      .lz77_tile_shift_data_vld      (lz77_cluster_shift_data_vld), 
      .lz77_tile_shift_data_out      (shift_data[0]), 
      .lz77_tile_shift_data_out_vld  (shift_data_vld[0]), 
      
      .lz77_tile_prefix_data         (tile_prefix_data[0]),
      .lz77_tile_prefix_data_vld     (tile_prefix_data_vld[0]),
      
      .lz77_tile_data                (lz77_cluster_data_r[IN_BYTES*8-1:0]), 
      .lz77_tile_data_vld            (lz77_cluster_data_vld_r[IN_BYTES-1:0]),
      
      .cl_ti_cont_phases             (cl_ti_cont_phases),
      .cl_ti_ongoing_cont_phases     (cl_ti_ongoing_cont_phases),
      .cl_ti_dmw_cont                (cl_ti_dmw_cont),
      .cl_ti_force_done              (cl_ti_force_done),
      .ti_cl_fwd_therm               (ti_cl_fwd_therm[0]),
      .ti_cl_offset                  (ti_cl_offset[0]),
      .ti_cl_len4_ind                (ti_cl_len4_ind[0]),
      .ti_cl_len5_6_ind              (ti_cl_len5_6_ind[0]),
      
      
      .me_cl_mtf_list                (me_clt0_mtf_list),
      .me_cl_mtf_list_valid          (me_clt0_mtf_list_valid),
      .clt0_me_mtf_offset            (clt0_me_mtf_offset),
      .clt0_me_mtf_phase             (clt0_me_mtf_phase),
      .clt0_me_mtf_fwd_therm         (clt0_me_mtf_fwd_therm),
      .ph4_mask                      (ph4_mask),
      .ph3_mask                      (ph3_mask),
      .ph2_mask                      (ph2_mask),
      .ph1_mask                      (ph1_mask)
      
      );      


   logic [TILPC-1:0][IN_BYTES-1:0][7:0]                    scrambled_cluster_data;

   assign scrambled_cluster_data[0] = lz77_cluster_data_r;
   
   genvar                                               tile_index, ii;
   
   generate 
      
      for(tile_index = 1; 
	  tile_index < TILPC; 
	  tile_index = tile_index + 1) begin : gen_tile_x8

         for (ii=0; ii<IN_BYTES; ii++) begin: scrable_data_loop
            assign scrambled_cluster_data[tile_index][ii] = byte_scramble(scrambled_cluster_data[tile_index-1][ii]);
         end

         cr_rst_sync tile_rst
           (
            .clk           (clk),
            .async_rst_n   (clt_rst_n),
            .bypass_reset  (bypass_reset),
            .test_rst_n    (test_rst_n),
            .rst_n         (rst_n[tile_index])
            ); 
         
         if ((tile_index%2)==0) begin : posedge_tile

	    cr_lz77_comp_tile_x8 
	      #(
	        .TILE_DEPTH(OFFPT / 8),
	        .IN_BYTES  (IN_BYTES),
	        .TRUNC_NUM (TRUNC_NUM)
	        )
	    tile_x8
	      (
               .clk                           (clk),
               .shift_start_phase             ($bits(tile_x8_shift_start_phase)'
					       ((tile_index>>1)%`CR_LZ77_TILE_X8_CLT0_SHIFT_MULT)),
               .rst_n                         (rst_n[tile_index]),
               .scramble_enb                  (scramble_enb_r),
	       .shift_en                      (shift_en_r),
               .input_en                      (input_en_r[0]),
               .prefix_en                     (prefix_en_r),
	       .me_tile_enable                (me_tile_enable_r[tile_index]),
	       .cl_ti_clr_valid               (clr_valid_r),
	       
               .lz77_tile_shift_data          (shift_data_posedge[tile_index-1]), 
               .lz77_tile_shift_data_vld      (shift_data_vld_posedge[tile_index-1]), 
	       .lz77_tile_shift_data_out      (shift_data[tile_index]), 
               .lz77_tile_shift_data_out_vld  (shift_data_vld[tile_index]), 
	       
               .lz77_tile_prefix_data         (tile_prefix_data[tile_index]),
               .lz77_tile_prefix_data_vld     (tile_prefix_data_vld[tile_index]),
	       
               .lz77_tile_data                (scramble_enb_r ? lz77_cluster_data_r[IN_BYTES*8-1:0] : scrambled_cluster_data[tile_index]), 
               .lz77_tile_data_vld            (lz77_cluster_data_vld_r[IN_BYTES-1:0]),
	       
 	       .cl_ti_cont_phases             (cl_ti_cont_phases),
 	       .cl_ti_ongoing_cont_phases     (cl_ti_ongoing_cont_phases),
  	       .cl_ti_dmw_cont                (cl_ti_dmw_cont),
	       .cl_ti_force_done              (cl_ti_force_done),
	       .ti_cl_fwd_therm               (ti_cl_fwd_therm[tile_index]),
	       .ti_cl_offset                  (ti_cl_offset[tile_index]),
	       .ti_cl_len4_ind                (ti_cl_len4_ind[tile_index]),
	       .ti_cl_len5_6_ind              (ti_cl_len5_6_ind[tile_index])
	       );
         end 
         else begin : negedge_tile
	    cr_lz77_comp_tile_x8_negedge 
	      #(
	        .TILE_DEPTH(OFFPT / 8),
	        .IN_BYTES  (IN_BYTES),
	        .TRUNC_NUM (TRUNC_NUM)
	        )
	    tile_x8
	      (
               .clk                           (clk),
               .shift_start_phase             ($bits(tile_x8_shift_start_phase)'
					       ((tile_index>>1)%`CR_LZ77_TILE_X8_CLT0_SHIFT_MULT)),
               .rst_n                         (rst_n[tile_index]),
               .scramble_enb                  (scramble_enb_r),
	       .shift_en                      (shift_en_r),
               .input_en                      (input_en_r[0]),
               .prefix_en                     (prefix_en_r),
	       .me_tile_enable                (me_tile_enable_r[tile_index]),
	       .cl_ti_clr_valid               (clr_valid_r),
	       
               .lz77_tile_shift_data          (shift_data[tile_index-1]), 
               .lz77_tile_shift_data_vld      (shift_data_vld[tile_index-1]), 
	       .lz77_tile_shift_data_out      (shift_data[tile_index]), 
               .lz77_tile_shift_data_out_vld  (shift_data_vld[tile_index]), 
	       
               .lz77_tile_prefix_data         (tile_prefix_data[tile_index]),
               .lz77_tile_prefix_data_vld     (tile_prefix_data_vld[tile_index]),
	       
               .lz77_tile_data                (scramble_enb_r ? lz77_cluster_data_r[IN_BYTES*8-1:0] : scrambled_cluster_data[tile_index]), 
               .lz77_tile_data_vld            (lz77_cluster_data_vld_r[IN_BYTES-1:0]),
	       
 	       .cl_ti_cont_phases             (cl_ti_cont_phases),
 	       .cl_ti_ongoing_cont_phases     (cl_ti_ongoing_cont_phases),
  	       .cl_ti_dmw_cont                (cl_ti_dmw_cont),
	       .cl_ti_force_done              (cl_ti_force_done),
	       .ti_cl_fwd_therm               (ti_cl_fwd_therm[tile_index]),
	       .ti_cl_offset                  (ti_cl_offset[tile_index]),
	       .ti_cl_len4_ind                (ti_cl_len4_ind[tile_index]),
	       .ti_cl_len5_6_ind              (ti_cl_len5_6_ind[tile_index])
	       );
            
         end
      end 

   endgenerate
   
      
   
   
   
   
  
			
   always @ (*) begin
      for (int phase=0; phase<TRUNC_NUM; phase=phase+1) begin
	 for (int tile=0; tile<TILPC; tile=tile+1) begin
	    ti_longest_therm_in[phase][tile] = ti_cl_fwd_therm[tile][phase];
	    ti_first_offset_in [phase][tile] = ti_cl_offset   [tile][phase];
	 end
      end
   end
   
   
    
 

   genvar phase_num;
   
   generate 
      
      
      
      
      
      for (phase_num=0; phase_num<TRUNC_NUM; phase_num=phase_num+1) 
	 begin : gen_match_stree
	    cr_lz77_comp_stree
	      #(
	
		.OFFSETS   (TILPC),
		.T_WIDTH   (LONGL),
		.T_MASK    (1),
		.OI_WIDTH  (LOG_OFFPT)
		)
	    cluster_longest_match_stree
	      (
	       .therm_in   (ti_longest_therm_in[phase_num]),
	       .offset_in  (ti_first_offset_in[phase_num]),
	       .therm_out  (cl_longest_therm_out[phase_num]),
	       .offset_out (cl_first_offset_out[phase_num])
	       );
	    
	 end 
   endgenerate


   

   cr_rst_sync cluster_rst
     (
      .clk           (clk),
      .async_rst_n   (raw_rst_n),
      .bypass_reset  (bypass_reset),
      .test_rst_n    (test_rst_n),
      .rst_n         (clt_rst_n)
      ); 

endmodule 

