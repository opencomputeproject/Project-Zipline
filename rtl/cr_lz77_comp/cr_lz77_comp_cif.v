/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/








`include "cr_lz77_comp.vh"
`include "cr_lz77_comp_pkg_include.vh"

module cr_lz77_comp_cif
  #(
    parameter TILPC          = `TILES_PER_CLUSTER,
    parameter OFFPT          = `OFFSETS_PER_TILE,
    parameter CLUSTERS       = `CLUSTERS,
    parameter TRUNC_NUM      = `TRUNC_NUM_V3,
    parameter LONGL          = `LONGL_V3,
    parameter MTF_NUM        = `MTF_NUM,
    parameter TILE_MTF_NUM   = `TILE_MTF_NUM,
    parameter MSM_MSB        = 0
    )
   (
   
   cif_offset, cif_fwd_therm, cif_truncated, cif_len4_ind,
   cif_len5_6_ind, cif_mtf_offset, cif_mtf_phase, cif_mtf_fwd_therm,
   cif_mim1_flag, me_clt0_mtf_list, me_clt0_mtf_list_valid,
   
   clk, rst_n, clt_me_offset, clt_me_fwd_therm, clt_me_truncated,
   clt0_me_mtf_offset, clt0_me_mtf_phase, clt0_me_mtf_fwd_therm,
   msm_emit_ptr_c, msm_emit_previous_ptr_c, msm_emit_lit_c,
   mdl_ptr_offset, mdl_ptr_is_mtf, mdl_mtf_idx,
   mdl_previous_ptr_offset, mdl_previous_ptr_is_mtf,
   mdl_previous_mtf_idx, mob_done, mob_input_en, me_num_mtf,
   mdl_winning_phase, mdl_previous_winning_phase, me_isXp9,
   clt_me_len4_ind, clt_me_len5_6_ind, clt_me_cont, msm_state,
   clt_offset_winner, winning_mtf_sel, mdl_current_tuple_wins,
   mdl_valid_run, mdl_f
   );
   
`include "cr_lz77_comp_includes.vh"

   localparam OFFPC     = OFFPT * TILPC;            
   localparam OFFPE     = OFFPT * TILPC * CLUSTERS; 
   localparam LOG_OFFPC = $clog2(OFFPC);
   localparam LOG_OFFPE = $clog2(OFFPE);
   localparam LOG_OFFPT = $clog2(OFFPT);

   
   
   
   localparam POTENTIAL_MTF_NUM = (TRUNC_NUM * CLUSTERS) + TILE_MTF_NUM;
   

   
   
   
   input 	     clk;
   input 	     rst_n;
   
   
   input [CLUSTERS-1:0][TRUNC_NUM-1:0][LOG_OFFPC-1:0]    clt_me_offset;
   input [CLUSTERS-1:0][TRUNC_NUM-1:0][LONGL-1:0] 	 clt_me_fwd_therm;
   input [CLUSTERS-1:0][TRUNC_NUM-1:0] 			 clt_me_truncated;

   
   input [TILE_MTF_NUM-1:0][LOG_OFFPT-1:0] 		 clt0_me_mtf_offset;
   input [TILE_MTF_NUM-1:0][TRUNC_NUM-1:0] 		 clt0_me_mtf_phase;
   input [TILE_MTF_NUM-1:0][11:0] 			 clt0_me_mtf_fwd_therm;

   
   input 						 msm_emit_ptr_c;
   input 						 msm_emit_previous_ptr_c;
   input [5:0] 						 msm_emit_lit_c;

   input [LOG_OFFPE-1:0] 				 mdl_ptr_offset; 
   input 						 mdl_ptr_is_mtf; 
   input [LOG_OFFPE-1:0] 				 mdl_mtf_idx; 
   input [LOG_OFFPE-1:0] 				 mdl_previous_ptr_offset; 
   input 						 mdl_previous_ptr_is_mtf; 
   input [LOG_OFFPE-1:0] 				 mdl_previous_mtf_idx;

   input  						 mob_done;
   input  						 mob_input_en;
   input 						 me_num_mtf;
   input [TRUNC_NUM-1:0] 				 mdl_winning_phase;
   input [TRUNC_NUM-1:0] 				 mdl_previous_winning_phase;
   input 						 me_isXp9;

   
   
   input [CLUSTERS-1:0][3:0] 				 clt_me_len4_ind;

   
   
   
   
   
   input [CLUSTERS-1:0][2:0] 				 clt_me_len5_6_ind;

   
   
   input [CLUSTERS-1:0] 				 clt_me_cont;

   
   input [MSM_MSB:0] 					 msm_state;


   
   output [TRUNC_NUM-1:0][LOG_OFFPE-1:0] 		 cif_offset;
   output [TRUNC_NUM-1:0][LONGL-1:0] 			 cif_fwd_therm;
   output reg [TRUNC_NUM-1:0] 				 cif_truncated;

   
   output reg [3:0] 					 cif_len4_ind;
   output reg [2:0] 					 cif_len5_6_ind;
   
   
   output reg [MTF_NUM-1:0][LOG_OFFPE-1:0] 		 cif_mtf_offset;
   output reg [MTF_NUM-1:0][TRUNC_NUM-1:0] 		 cif_mtf_phase;
   output reg [MTF_NUM-1:0][11:0] 			 cif_mtf_fwd_therm;
   output reg 						 cif_mim1_flag;
   
   
   output reg [MTF_NUM-1:0][LOG_OFFPT-1:0] 		 me_clt0_mtf_list;
   output reg [MTF_NUM-1:0] 				 me_clt0_mtf_list_valid;

   input [LOG_OFFPE-1:0] 				 clt_offset_winner;
   input 						 winning_mtf_sel;
   input 						 mdl_current_tuple_wins;

   input 						 mdl_valid_run;
   input [3:0] 						 mdl_f;
   

   
   
   
   
   

   logic [CLUSTERS-1:0][TRUNC_NUM-1:0][LONGL-1:0] 	 fwd_therm_gated;
   logic [CLUSTERS-1:0][TRUNC_NUM-1:0] 			 clt_me_truncated_gated;

   
   logic [TILE_MTF_NUM-1:0][TRUNC_NUM-1:0] 		 clt0_mtf_phase_gated;
   logic [TILE_MTF_NUM-1:0][11:0] 			 clt0_mtf_fwd_therm_gated;

   
   logic [TRUNC_NUM-1:0][CLUSTERS-1:0][LONGL-1:0] 	 stree_therm_in;
   logic [TRUNC_NUM-1:0][CLUSTERS-1:0][LOG_OFFPC-1:0]    stree_offset_in;

   logic 						 me_cont;

   
   logic [MTF_NUM-1:0][LOG_OFFPE-1:0] 			 global_mtf_list;
   logic [MTF_NUM-1:0][LOG_OFFPE-1:0] 			 global_mtf_list_int;
   logic [MTF_NUM-1:0][LOG_OFFPE-1:0] 			 global_mtf_list_int_r;

   logic [MTF_NUM-1:0][LOG_OFFPT-1:0] 			 clt0_mtf_list_int;
   logic [MTF_NUM-1:0][LOG_OFFPT-1:0] 			 clt0_mtf_list_int_r;

   logic [MTF_NUM-1:0][LOG_OFFPE-1:0] 			 next_global_mtf_list;
   logic [MTF_NUM-1:0][LOG_OFFPT-1:0] 			 next_me_clt0_mtf_list;
   logic 						 revert_mtf_list;

   logic [MTF_NUM-1:0][LOG_OFFPE-1:0] 			 mtf_list_A; 
   logic [MTF_NUM-1:0][LOG_OFFPE-1:0] 			 mtf_list_B; 
   logic [MTF_NUM-1:0][LOG_OFFPE-1:0] 			 mtf_list_C; 

   logic [MTF_NUM-1:0][LOG_OFFPE-1:0] 			 mtf_list_c0_A; 
   logic [MTF_NUM-1:0][LOG_OFFPE-1:0] 			 mtf_list_c0_B; 
   logic [MTF_NUM-1:0][LOG_OFFPE-1:0] 			 mtf_list_c0_C; 
   logic [MTF_NUM-1:0] 					 mtf_is_in_tile_0;

   logic 						 clr_mtf_list;
   logic 						 emit_any_ptr;
   logic 						 update_mtf_list;

   logic [POTENTIAL_MTF_NUM-1:0][LOG_OFFPE-1:0] 	 potential_mtf_offset;
   logic [POTENTIAL_MTF_NUM-1:0][TRUNC_NUM-1:0] 	 potential_mtf_phase;
   logic [POTENTIAL_MTF_NUM-1:0][11:0] 			 potential_mtf_fwd_therm;
   logic [MTF_NUM-1:0][POTENTIAL_MTF_NUM-1:0] 		 mtf_potential_match;
      
   logic [MTF_NUM-1:0][POTENTIAL_MTF_NUM-1:0][TRUNC_NUM-1:0] mtf_compared_phase;
   logic [MTF_NUM-1:0][POTENTIAL_MTF_NUM-1:0][11:0] 	     mtf_compared_fwd_therm;
   
   logic [3:0] 						   len4_ind;
   logic [2:0] 						   len5_6_ind;

   logic [MTF_NUM-1:0] 					   mtf_idx_masked;
   logic 						   mtf_idx_mask_flag;
   logic 						   clr_mtf_idx_mask_flag;
   logic [TRUNC_NUM-1:0] 				   mtf_0_phase;
   logic [TRUNC_NUM-1:0] 				   truncated_phase;
   logic [TRUNC_NUM-1:0] 				   truncated_phase_r;
   logic 						   winning_phase_was_truncated;
   logic 						   mim1_flag;

   int 							   idx;
   int 							   c_idx;
   int 							   p_idx;

   logic 						 msm_emit_ptr_c_int;
   logic 						 msm_emit_previous_ptr_c_int;
   logic [5:0] 						 msm_emit_lit_c_int;
   logic [LOG_OFFPE-1:0] 				 mdl_ptr_offset_int; 
   logic 						 mdl_ptr_is_mtf_int; 
   logic [LOG_OFFPE-1:0] 				 mdl_previous_ptr_offset_int; 
   logic 						 mdl_previous_ptr_is_mtf_int; 
   logic [TRUNC_NUM-1:0] 				 mdl_winning_phase_int;
   logic [TRUNC_NUM-1:0] 				 mdl_previous_winning_phase_int;
   
  
   always @ (*) begin

      
      me_clt0_mtf_list_valid = {MTF_NUM{1'b1}};

      msm_emit_ptr_c_int             = msm_emit_ptr_c;
      msm_emit_previous_ptr_c_int    = msm_emit_previous_ptr_c;
      msm_emit_lit_c_int             = msm_emit_lit_c;
      mdl_ptr_offset_int             = mdl_ptr_offset; 
      mdl_ptr_is_mtf_int             = mdl_ptr_is_mtf; 
      mdl_previous_ptr_offset_int    = mdl_previous_ptr_offset;
      mdl_previous_ptr_is_mtf_int    = mdl_previous_ptr_is_mtf;
      mdl_winning_phase_int          = mdl_winning_phase;
      mdl_previous_winning_phase_int = mdl_previous_winning_phase;

      
      
      

      
      
      me_cont = |clt_me_cont;

      
      
      for (int c=0; c<CLUSTERS; c=c+1) begin
	 if (me_cont && !clt_me_cont[c]) begin
	    fwd_therm_gated[c]        = {TRUNC_NUM{{LONGL{1'b0}}}};
	 end 
	 else begin
	    fwd_therm_gated[c]   = clt_me_fwd_therm[c];
	 end
	 if (clt_me_cont[c]) begin
	    clt_me_truncated_gated[c] = clt_me_truncated[c];
	 end
	 else begin
	    clt_me_truncated_gated[c] = {TRUNC_NUM{1'b0}};
	 end
      end 
      
      for (int i=0; i<TILE_MTF_NUM; i=i+1) begin
	 if (me_cont && !clt_me_cont[0]) begin
	    clt0_mtf_phase_gated[i]     = 4'b0;
	    clt0_mtf_fwd_therm_gated[i] = 12'b0;
	 end
	 else begin
	    clt0_mtf_phase_gated[i]     = clt0_me_mtf_phase[i];
	    clt0_mtf_fwd_therm_gated[i] = clt0_me_mtf_fwd_therm[i];
	 end
      end 
	 

      
      
      for (int p=0; p<TRUNC_NUM; p=p+1) begin
	 for (int c=0; c<CLUSTERS; c=c+1) begin
	    stree_therm_in[p][c] = fwd_therm_gated[c][p];
	    stree_offset_in[p][c] = clt_me_offset[c][p];
	 end
      end


      
      
      
      len4_ind = 4'b0;
      for (int i=0; i<CLUSTERS; i=i+1) begin
	 len4_ind = len4_ind | clt_me_len4_ind[i];
      end
      len5_6_ind = 3'b0;
      for (int i=0; i<CLUSTERS; i=i+1) begin
	 len5_6_ind = len5_6_ind | clt_me_len5_6_ind[i];
      end


      if (msm_state[UM2] || msm_state[UM1]) begin
	 global_mtf_list = global_mtf_list_int_r;
	 me_clt0_mtf_list = clt0_mtf_list_int_r;
      end
      else begin
	 global_mtf_list = global_mtf_list_int;
	 me_clt0_mtf_list = clt0_mtf_list_int;
      end


      
      
      
      emit_any_ptr = msm_emit_ptr_c_int || msm_emit_previous_ptr_c_int;

      mtf_0_phase = 4'b0;
      for (int i=0; i<POTENTIAL_MTF_NUM; i=i+1) begin
	 if ( 
	      
	      (|potential_mtf_phase[i]) &&
	      
	      (potential_mtf_offset[i] == global_mtf_list[0])
	      ) begin
	    mtf_0_phase |= potential_mtf_phase[i];
	 end
      end 

      
      mtf_idx_masked[3:0] = 4'b0;
      clr_mtf_idx_mask_flag = 1'b0;
      if ( (msm_state[U0] && (|mtf_0_phase[1:0]) ) ||
	   (msm_state[U1] && (|mtf_0_phase[0]) )
	   ) begin
	 
	 clr_mtf_idx_mask_flag = 1'b1;
      end
      else begin
	 mtf_idx_masked[0] = mtf_idx_mask_flag;
      end

      
      
      

      
      

      
      
      idx = 0;
      c_idx = 0;
      p_idx = 0;
      for (int i=0; i<POTENTIAL_MTF_NUM; i=i+1) begin
	 if (i<TILE_MTF_NUM) begin
	    
	    potential_mtf_offset[i]     = { {(LOG_OFFPE-LOG_OFFPT){1'b0}},
					    clt0_me_mtf_offset[i] 
					    };
	    potential_mtf_phase[i]      = clt0_mtf_phase_gated[i];
	    potential_mtf_fwd_therm[i]  = clt0_mtf_fwd_therm_gated[i];
	 end
	 else begin
	    
	    potential_mtf_offset[i]     = { c_idx[2:0],
					    clt_me_offset[c_idx][p_idx]
					    };

	    
	    
	    if (fwd_therm_gated[c_idx][p_idx][12] == 1'b0) begin
	       potential_mtf_phase[i]      = fwd_therm_gated[c_idx][p_idx][0] << p_idx; 
	       potential_mtf_fwd_therm[i]  = fwd_therm_gated[c_idx][p_idx][11:1];
	    end
	    else begin
	       potential_mtf_phase[i]      = {TRUNC_NUM{1'b0}};
	       potential_mtf_fwd_therm[i]  = 12'b0;
	    end

	    idx   = idx + 1;
	    c_idx = idx >> 2;  
	    p_idx = idx % 4;   
	 
	 end 

      end 
      

      
      for (int i=0; i<MTF_NUM; i=i+1) begin
	 mtf_potential_match[i] = {POTENTIAL_MTF_NUM{1'b0}};
	 for (int j=0; j<POTENTIAL_MTF_NUM; j=j+1) begin
	    if ( 
		 
		 !mtf_idx_masked[i] &&
		 
		 (|potential_mtf_phase[j]) &&
		 
		 (potential_mtf_offset[j] == global_mtf_list[i])
		 ) begin
	       mtf_potential_match[i][j] = 1'b1;
	    end
	 end 
      end 
      
      
      for (int i=0; i<MTF_NUM; i=i+1) begin
	 for (int j=0; j<POTENTIAL_MTF_NUM; j=j+1) begin
	    mtf_compared_phase[i][j]     = potential_mtf_phase[j] & {TRUNC_NUM{mtf_potential_match[i][j]}};
	    mtf_compared_fwd_therm[i][j] = potential_mtf_fwd_therm[j] & {12{mtf_potential_match[i][j]}};
	 end
      end
		
      
      cif_mtf_phase     = {MTF_NUM{{TRUNC_NUM{1'b0}}}};
      cif_mtf_fwd_therm = {MTF_NUM{12'b0}};
      for (int i=0; i<MTF_NUM; i=i+1) begin
	 for (int j=0; j<POTENTIAL_MTF_NUM; j=j+1) begin
	    cif_mtf_phase[i]     = cif_mtf_phase[i]     | mtf_compared_phase[i][j];
	    cif_mtf_fwd_therm[i] = cif_mtf_fwd_therm[i] | mtf_compared_fwd_therm[i][j];
	 end
      end

      cif_mtf_offset = global_mtf_list;


      
      truncated_phase = {TRUNC_NUM{1'b0}};
      for (int i=0; i<CLUSTERS; i=i+1) begin
	 truncated_phase = truncated_phase | clt_me_truncated_gated[i];
      end

      if (msm_emit_ptr_c_int) begin
	 winning_phase_was_truncated = |(mdl_winning_phase_int & truncated_phase);
      end
      else if (msm_emit_previous_ptr_c_int) begin
	 winning_phase_was_truncated = |(mdl_previous_winning_phase_int & truncated_phase_r);
      end
      else begin
	 winning_phase_was_truncated = 1'b0;
      end

      cif_truncated = {TRUNC_NUM{1'b0}};
      for (int c=0; c<CLUSTERS; c+=1) begin
	 cif_truncated |= clt_me_truncated_gated[c];
      end


      
      
      

      
      mtf_list_A[0] = clt_offset_winner;
      mtf_list_A[1] = global_mtf_list[0];
      mtf_list_A[2] = global_mtf_list[1];
      mtf_list_A[3] = global_mtf_list[2];

      
      mtf_list_B[0] = global_mtf_list[mdl_mtf_idx[1:0]];

      mtf_list_B[1] = (mdl_mtf_idx[1:0] < 2'd1) ? 
		       global_mtf_list[1] :
		       global_mtf_list[0];
      
      mtf_list_B[2] = (mdl_mtf_idx[1:0] < 2'd2) ? 
		       global_mtf_list[2] :
		       global_mtf_list[1];
      
      mtf_list_B[3] = (mdl_mtf_idx[1:0] < 2'd3) ? 
		       global_mtf_list[3] :
		       global_mtf_list[2];

      
      if (mdl_previous_ptr_is_mtf) begin
	 
	 mtf_list_C[0] = global_mtf_list[mdl_previous_mtf_idx[1:0]];
	 
	 mtf_list_C[1] = (mdl_previous_mtf_idx[1:0] < 2'd1) ? 
			  global_mtf_list[1] :
			  global_mtf_list[0];
	 
	 mtf_list_C[2] = (mdl_previous_mtf_idx[1:0] < 2'd2) ? 
			  global_mtf_list[2] :
			  global_mtf_list[1];
	 
	 mtf_list_C[3] = (mdl_previous_mtf_idx[1:0] < 2'd3) ? 
			  global_mtf_list[3] :
			  global_mtf_list[2];
      end 
      else begin
	 
	 mtf_list_C[0] = mdl_previous_ptr_offset;
	 mtf_list_C[1] = global_mtf_list[0];
	 mtf_list_C[2] = global_mtf_list[1];
	 mtf_list_C[3] = global_mtf_list[2];
      end 


      
      
      
      

      
      
      
      mtf_is_in_tile_0 = {MTF_NUM{1'b0}};
      for (int i=0; i<MTF_NUM; i+=1) begin
	 if (global_mtf_list[i] < OFFPT)
	   mtf_is_in_tile_0[i] = 1'b1;
      end

      
      mtf_list_c0_A[0] = (clt_offset_winner < OFFPT) ? 
			  clt_offset_winner : {LOG_OFFPE{1'b0}};

      mtf_list_c0_A[1] = global_mtf_list[0] & {LOG_OFFPE{mtf_is_in_tile_0[0]}};
      mtf_list_c0_A[2] = global_mtf_list[1] & {LOG_OFFPE{mtf_is_in_tile_0[1]}};
      mtf_list_c0_A[3] = global_mtf_list[2] & {LOG_OFFPE{mtf_is_in_tile_0[2]}};

      
      mtf_list_c0_B[0] = (global_mtf_list[mdl_mtf_idx[1:0]] < OFFPT) ?
			  global_mtf_list[mdl_mtf_idx[1:0]] : 
			  {LOG_OFFPE{1'b0}};
      

      mtf_list_c0_B[1] = (mdl_mtf_idx[1:0] < 2'd1) ? 
			  (global_mtf_list[1] & {LOG_OFFPE{mtf_is_in_tile_0[1]}}) :
			  (global_mtf_list[0] & {LOG_OFFPE{mtf_is_in_tile_0[0]}});

      
      mtf_list_c0_B[2] = (mdl_mtf_idx[1:0] < 2'd2) ? 
			  (global_mtf_list[2] & {LOG_OFFPE{mtf_is_in_tile_0[2]}}) :
			  (global_mtf_list[1] & {LOG_OFFPE{mtf_is_in_tile_0[1]}});
      
      
      mtf_list_c0_B[3] = (mdl_mtf_idx[1:0] < 2'd3) ? 
			  (global_mtf_list[3] & {LOG_OFFPE{mtf_is_in_tile_0[3]}}) :
			  (global_mtf_list[2] & {LOG_OFFPE{mtf_is_in_tile_0[2]}});
      

      
      
      if (mdl_previous_ptr_is_mtf) begin
	 
	 mtf_list_c0_C[0] =  (global_mtf_list[mdl_previous_mtf_idx[1:0]] < OFFPT) ?
			      global_mtf_list[mdl_previous_mtf_idx[1:0]] :
			      {LOG_OFFPE{1'b0}};
	 
	 mtf_list_c0_C[1] = (mdl_previous_mtf_idx[1:0] < 2'd1) ? 
			     (global_mtf_list[1] & {LOG_OFFPE{mtf_is_in_tile_0[1]}}) :
			     (global_mtf_list[0] & {LOG_OFFPE{mtf_is_in_tile_0[0]}});
	 
	 
	 mtf_list_c0_C[2] = (mdl_previous_mtf_idx[1:0] < 2'd2) ? 
			     (global_mtf_list[2] & {LOG_OFFPE{mtf_is_in_tile_0[2]}}) :
			     (global_mtf_list[1] & {LOG_OFFPE{mtf_is_in_tile_0[1]}});
	 
	 mtf_list_c0_C[3] = (mdl_previous_mtf_idx[1:0] < 2'd3) ? 
			     (global_mtf_list[3] & {LOG_OFFPE{mtf_is_in_tile_0[3]}}) :
			     (global_mtf_list[2] & {LOG_OFFPE{mtf_is_in_tile_0[2]}});
      end 
      else begin
	 
	 mtf_list_c0_C[0] = (mdl_previous_ptr_offset < OFFPT) ? 
			     mdl_previous_ptr_offset : {LOG_OFFPE{1'b0}};
	 mtf_list_c0_C[1] = global_mtf_list[0] & {LOG_OFFPE{mtf_is_in_tile_0[0]}};
	 mtf_list_c0_C[2] = global_mtf_list[1] & {LOG_OFFPE{mtf_is_in_tile_0[1]}};
	 mtf_list_c0_C[3] = global_mtf_list[2] & {LOG_OFFPE{mtf_is_in_tile_0[2]}};
      end 

      
      
      
      
      
      
      
      
      
      
      
      revert_mtf_list = (msm_state[UM2] || msm_state[UM1]) && (|mdl_f);
      if (revert_mtf_list) begin
	 next_global_mtf_list = global_mtf_list_int_r;
	 next_me_clt0_mtf_list = clt0_mtf_list_int_r;
      end
      else begin
	 unique case ({mdl_current_tuple_wins,winning_mtf_sel})
	   2'b00, 2'b01 : begin
	      
	      next_global_mtf_list = mtf_list_C;
	      for (int i=0; i<MTF_NUM; i+=1) begin
		 next_me_clt0_mtf_list[i] = mtf_list_c0_C[i][LOG_OFFPT-1:0];
	      end
	   end
	   2'b10 : begin
	      
	      next_global_mtf_list = mtf_list_A; 
	      for (int i=0; i<MTF_NUM; i+=1) begin
		 next_me_clt0_mtf_list[i] = mtf_list_c0_A[i][LOG_OFFPT-1:0];
	      end
	   end
	   2'b11 : begin
	      
	      next_global_mtf_list = mtf_list_B; 
	      for (int i=0; i<MTF_NUM; i+=1) begin
		 next_me_clt0_mtf_list[i] = mtf_list_c0_B[i][LOG_OFFPT-1:0];
	      end
	   end
	 endcase 
      end 
      


      
      
      
      
      
      update_mtf_list = ( mdl_valid_run && 
			  (mdl_f == 4'b0) &&
			  ( msm_state[U0]    ||
			    msm_state[U1]    ||
			    msm_state[U2]    ||
			    msm_state[U3]    ||
			    msm_state[UM1]   ||
			    msm_state[UM2]   ||
			    msm_state[UM8]   ||
			    msm_state[UM4_1] ||
			    msm_state[UM4_2] ||
			    msm_state[C4]    ||
			    msm_state[UM7]   ||
			    msm_state[UM3]   ||
			    msm_state[C3]    ||
			    msm_state[UM6]   ||
			    msm_state[C2]    ||
			    msm_state[UM5]   ||
			    msm_state[C1] )
			  ) ||
			revert_mtf_list;


      
      
      
      if (emit_any_ptr && (|msm_emit_lit_c_int)) begin
	 cif_mim1_flag = 1'b0;
      end
      else begin
	 cif_mim1_flag = mim1_flag;
      end

   end 
   

   always @ (posedge clk or negedge rst_n) begin
      if (!rst_n) begin
	 clr_mtf_list           <= 1'b0;
	 cif_len4_ind           <= 4'b0;
	 cif_len5_6_ind         <= 3'b0;
	 mim1_flag              <= 1'b0;
	 mtf_idx_mask_flag      <= 1'b0;
	 truncated_phase_r      <= {TRUNC_NUM{1'b0}};

 	 global_mtf_list_int   <= {4{{LOG_OFFPE{1'b0}}}};
 	 clt0_mtf_list_int     <= {4{{LOG_OFFPT{1'b0}}}};
	 global_mtf_list_int_r <= {4{{LOG_OFFPE{1'b0}}}};
	 clt0_mtf_list_int_r   <= {4{{LOG_OFFPT{1'b0}}}};

      end
      else begin

	 if (mob_input_en) begin

	    clr_mtf_list <= mob_done;

	    cif_len4_ind   <= len4_ind;
	    cif_len5_6_ind <= len5_6_ind;

	    truncated_phase_r <= truncated_phase;

	    
	    
	    
	    if ( !me_num_mtf || clr_mtf_list ) begin
 	       global_mtf_list_int <= {4{{LOG_OFFPE{1'b0}}}};
 	       clt0_mtf_list_int   <= {4{{LOG_OFFPT{1'b0}}}};
	    end
	    else if (update_mtf_list) begin
	       global_mtf_list_int <= next_global_mtf_list;
	       clt0_mtf_list_int   <= next_me_clt0_mtf_list;
	    end 

	    global_mtf_list_int_r <= global_mtf_list_int;
	    clt0_mtf_list_int_r   <= clt0_mtf_list_int;



	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    

	    
	    if ( !me_num_mtf || clr_mtf_list || !me_isXp9) begin
	       mim1_flag <= 1'b0;
	    end
	    else if (emit_any_ptr) begin
	       mim1_flag <= 1'b1;
	    end
	    else if (|msm_emit_lit_c_int) begin
	       mim1_flag <= 1'b0;
	    end
	 
	    
	    if ( !me_num_mtf || clr_mtf_list || !me_isXp9 || clr_mtf_idx_mask_flag) begin
	       mtf_idx_mask_flag <= 1'b0;
	    end
	    else if (emit_any_ptr) begin
	       if (winning_phase_was_truncated) begin
		  mtf_idx_mask_flag <= 1'b1;
	       end
	       else begin
		  mtf_idx_mask_flag <= 1'b0;
	       end
	    end
	    else if (|msm_emit_lit_c_int) begin
		  mtf_idx_mask_flag <= 1'b0;
	    end

	 end 
      end
   end
   



   
   
   
   
   
   
   
   
   
   

   cr_lz77_comp_stree
     #(
       .GROUP_NUM (TRUNC_NUM),
       .OFFSETS   (CLUSTERS),
       .T_WIDTH   (LONGL),
       .T_MASK    (1),
       .OI_WIDTH  (LOG_OFFPC)
       )
   match_longest_stree
     (
      .therm_in   (stree_therm_in),
      .offset_in  (stree_offset_in),
      .therm_out  (cif_fwd_therm),
      .offset_out (cif_offset)
      );
   
endmodule 












































