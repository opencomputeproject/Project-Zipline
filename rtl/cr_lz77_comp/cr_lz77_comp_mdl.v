/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/















`include "cr_lz77_comp.vh"
`include "cr_lz77_comp_pkg_include.vh"

module cr_lz77_comp_mdl
  #(
    parameter TILPC          = `TILES_PER_CLUSTER,
    parameter OFFPT          = `OFFSETS_PER_TILE,
    parameter CLUSTERS       = `CLUSTERS,
    parameter TRUNC_NUM      = `TRUNC_NUM_V3,
    parameter LONGL          = `LONGL_V3,
    parameter MTF_NUM        = `MTF_NUM,
    parameter MSM_MSB        = 0
    )
   (
   
   mdl_tuple, mdl_f, mdl_previous_tuple, mdl_previous_is_2_back,
   mdl_current_tuple_wins, mdl_ptr_length, mdl_ptr_offset,
   mdl_ptr_is_mtf, mdl_mtf_idx, mdl_previous_ptr_length,
   mdl_previous_ptr_offset, mdl_previous_ptr_is_mtf,
   mdl_previous_mtf_idx, mdl_winning_phase,
   mdl_previous_winning_phase, clt_offset_winner, winning_mtf_sel,
   mdl_valid_run,
   
   clk, rst_n, cif_offset, cif_fwd_therm, cif_truncated,
   cif_mtf_offset, cif_mtf_phase, cif_mtf_fwd_therm, msm_state,
   me_dly_match_win, msm_dmw, mob_input_en, msm_save_tuple_c,
   msm_update_saved_tuple_c, msm_clear_saved_tuple_c,
   msm_continuing_c, msm_um2_um1_to_cont_c
   );
   
`include "cr_lz77_comp_includes.vh"
`include "cr_lz77_comp_funcs.vh"

   localparam OFFPC     = OFFPT * TILPC;            
   localparam OFFPE     = OFFPT * TILPC * CLUSTERS; 
   localparam LOG_OFFPC = $clog2(OFFPC);
   localparam LOG_OFFPE = $clog2(OFFPE);
   
   
   
   
   input 	                              clk;
   input 				      rst_n;
   
   
   input [TRUNC_NUM-1:0][LOG_OFFPE-1:0]       cif_offset;
   input [TRUNC_NUM-1:0][LONGL-1:0] 	      cif_fwd_therm;
   input [TRUNC_NUM-1:0] 		      cif_truncated;
   
   
   input [MTF_NUM-1:0][LOG_OFFPE-1:0] 	      cif_mtf_offset;
   input [MTF_NUM-1:0][TRUNC_NUM-1:0] 	      cif_mtf_phase;
   input [MTF_NUM-1:0][11:0] 		      cif_mtf_fwd_therm;

   input [MSM_MSB:0] 			      msm_state;
   input [1:0] 				      me_dly_match_win;
   input [5:0] 				      msm_dmw;

   input 				      mob_input_en;
   input 				      msm_save_tuple_c;
   input 				      msm_update_saved_tuple_c;
   input 				      msm_clear_saved_tuple_c;
   input 				      msm_continuing_c;
   input 				      msm_um2_um1_to_cont_c;

   
   
   

   
   output 				      match_tuple_t mdl_tuple;
   output reg [3:0] 			      mdl_f;
   output  				      match_tuple_t mdl_previous_tuple;
   output reg 				      mdl_previous_is_2_back;
   output reg 				      mdl_current_tuple_wins;

   
   output reg [LOG_OFFPE-1:0] 		      mdl_ptr_length; 
   output reg [LOG_OFFPE-1:0] 		      mdl_ptr_offset; 
   output reg  				      mdl_ptr_is_mtf; 
   output reg [LOG_OFFPE-1:0] 		      mdl_mtf_idx; 

   output reg [LOG_OFFPE-1:0] 		      mdl_previous_ptr_length; 
   output reg [LOG_OFFPE-1:0] 		      mdl_previous_ptr_offset; 
   output reg				      mdl_previous_ptr_is_mtf; 
   output reg [LOG_OFFPE-1:0] 		      mdl_previous_mtf_idx;

   
   output reg [TRUNC_NUM-1:0] 		      mdl_winning_phase;
   output reg [TRUNC_NUM-1:0] 		      mdl_previous_winning_phase;
   
   output reg [LOG_OFFPE-1:0] 		      clt_offset_winner;
   output reg 				      winning_mtf_sel;
   output reg 				      mdl_valid_run;

   
   
   
   
   

   logic [3:0] 				      pval;
   logic 				      previous_is_UM1;
   logic 				      previous_is_UM2;
   logic [5:0] 				      msm_dmw_r;

   logic [TRUNC_NUM-1:0][18:0] 		      clt_full_fwd_therm;
   logic [MTF_NUM-1:0][18:0] 		      mtf_full_fwd_therm;
   logic [MTF_NUM-1:0][12:0] 		      mtf_stree_therm_in;
   logic [12:0] 			      mtf_stree_therm_out;

   logic 				      clt_sel_3;
   logic 				      clt_sel_1;
   logic 				      clt_sel_2_1;
   logic [1:0] 				      mtf_sel;
   

   logic [18:0] 			      clt_full_fwd_therm_4_3;
   logic [3:0] 				      clt_phase_4_3;
   logic [LOG_OFFPE-1:0] 		      clt_offset_4_3;
   logic [18:0] 			      clt_full_fwd_therm_2_1;
   logic [3:0] 				      clt_phase_2_1;
   logic [LOG_OFFPE-1:0] 		      clt_offset_2_1;
   
   logic [18:0] 			      clt_full_fwd_therm_winner;
   logic [3:0] 				      clt_phase_winner;
   logic [18:0] 			      mtf_full_fwd_therm_winner;
   logic [18:0] 			      winning_full_fwd_therm;
   logic [18:0] 			      previous_full_fwd_therm;
   logic [18:0] 			      previous_full_fwd_therm_muxed;
   logic 				      msm_um2_um1_to_cont_reg;
   logic [18:0] 			      previous_full_fwd_therm_adjusted;
   logic [1:0] 				      mdl_previous_age;

   logic [MTF_NUM-1:0][LOG_OFFPE-1:0] 	      mtf_idx; 

   logic [TRUNC_NUM-1:0][TRUNC_NUM-1:0]       clt_phase_A;
   logic [TRUNC_NUM-1:0][TRUNC_NUM-1:0]       clt_phase_B;
   logic [TRUNC_NUM-1:0][TRUNC_NUM-1:0]       clt_phase_C;
   logic [TRUNC_NUM-1:0][TRUNC_NUM-1:0]       clt_phase_D;
   logic [TRUNC_NUM-1:0][11:0] 		      clt_fwd_therm;

   logic [MTF_NUM-1:0][TRUNC_NUM-1:0] 	      mtf_phase_A;
   logic [MTF_NUM-1:0][TRUNC_NUM-1:0] 	      mtf_phase_B;
   logic [MTF_NUM-1:0][TRUNC_NUM-1:0] 	      mtf_phase_C;
   logic [MTF_NUM-1:0][TRUNC_NUM-1:0] 	      mtf_phase_D;
   
   logic [TRUNC_NUM-1:0] 		      winning_phase;
   logic [11:0] 			      winning_fwd_therm;
   logic 				      winning_is_mtf;
   logic 				      mtf_winner_beat_previous;
   int 					      current_mtf_idx;
   logic 				      cluster_winner_beats_previous;
   logic [TRUNC_NUM-1:0] 		      not_truncated;
			      

   always @ (posedge clk or negedge rst_n) begin
      if (!rst_n) begin

         mdl_previous_tuple       <= {$bits(match_tuple_t){1'b0}};
 	 mdl_previous_ptr_length  <= {LOG_OFFPE{1'b0}};
 	 mdl_previous_ptr_offset  <= {LOG_OFFPE{1'b0}};
 	 mdl_previous_mtf_idx     <= {LOG_OFFPE{1'b0}};
	 previous_full_fwd_therm  <= 19'b0;
	 mdl_previous_age         <= 2'b00;
	 previous_is_UM1          <= 1'b0;
	 previous_is_UM2          <= 1'b0;
	 msm_dmw_r                <= 6'b0;
	 msm_um2_um1_to_cont_reg  <= 1'b0;
	 not_truncated            <= {TRUNC_NUM{1'b0}};

      end else begin

	 if (mob_input_en) begin

	    not_truncated <= ~cif_truncated;
	    msm_dmw_r <= msm_dmw;

	    previous_is_UM1 <= msm_state[UM1];
	    previous_is_UM2 <= msm_state[UM2];

	    if (msm_clear_saved_tuple_c) begin
	       mdl_previous_tuple       <= {$bits(match_tuple_t){1'b0}};
 	       mdl_previous_ptr_length  <= {LOG_OFFPE{1'b0}};
 	       mdl_previous_ptr_offset  <= {LOG_OFFPE{1'b0}};
 	       mdl_previous_mtf_idx     <= {LOG_OFFPE{1'b0}};
	       previous_full_fwd_therm  <= 19'b0;
	       msm_um2_um1_to_cont_reg  <= 1'b0;
	    end
	    else if ( (msm_save_tuple_c ) ||
		      (msm_update_saved_tuple_c && mdl_current_tuple_wins)
		      ) begin
               mdl_previous_tuple   <= mdl_tuple;
	       
 	       mdl_previous_ptr_length <= mdl_ptr_length;
	       
 	       mdl_previous_ptr_offset <= mdl_ptr_offset;

 	       mdl_previous_mtf_idx    <= mdl_mtf_idx;

	       previous_full_fwd_therm <= winning_full_fwd_therm;
 	       msm_um2_um1_to_cont_reg  <= msm_um2_um1_to_cont_c;
	       
	       mdl_previous_age <= 2'b01;

	    end 
	    else begin
	       if (!msm_um2_um1_to_cont_c) begin
		  
		  if (|mdl_previous_ptr_length[4:2]) begin
		     mdl_previous_ptr_length <= mdl_previous_ptr_length - 4;
		  end
		  else begin
		     mdl_previous_ptr_length <= {LOG_OFFPE{1'b0}};
		  end
	       end

	       
	       
	       previous_full_fwd_therm <= previous_full_fwd_therm >> 4;
	       
	       mdl_previous_age <= {mdl_previous_age[0], 1'b0};

	       if (mdl_previous_is_2_back) begin
		  
		  mdl_previous_tuple       <= {$bits(match_tuple_t){1'b0}};
 		  mdl_previous_ptr_length  <= {LOG_OFFPE{1'b0}};
 		  mdl_previous_ptr_offset  <= {LOG_OFFPE{1'b0}};
 		  mdl_previous_mtf_idx     <= {LOG_OFFPE{1'b0}};
		  previous_full_fwd_therm  <= 19'b0;
	       end 
	    end 
	 end 

      end 
   end 


   always @ (*) begin

      mdl_previous_is_2_back = mdl_previous_age[1];

      
      
      
      
      
      mtf_idx[0] = { {(LOG_OFFPE-2){1'b0}}, 2'b00 };
		  
      mtf_idx[1] = { {(LOG_OFFPE-2){1'b0}}, 2'b01 };
      mtf_idx[2] = { {(LOG_OFFPE-2){1'b0}}, 2'b10 }; 
      mtf_idx[3] = { {(LOG_OFFPE-2){1'b0}}, 2'b11 };
 		  

      mdl_previous_ptr_is_mtf = mdl_previous_tuple.is_mtf;


      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      

     
      
      for (int i=0; i<TRUNC_NUM; i=i+1) begin
	 clt_phase_A[i]    = {TRUNC_NUM{1'b0}};
	 clt_phase_A[i][i] = cif_fwd_therm[i][0];
	 mtf_phase_A[i]    = cif_mtf_phase[i];
      end
      for (int i=0; i<TRUNC_NUM; i=i+1) begin
	 clt_phase_B[i] = {TRUNC_NUM{1'b0}};
	 clt_phase_C[i] = {TRUNC_NUM{1'b0}};
	 clt_phase_D[i] = {TRUNC_NUM{1'b0}};
	 mtf_phase_B[i] = {TRUNC_NUM{1'b0}};
	 mtf_phase_C[i] = {TRUNC_NUM{1'b0}};
	 mtf_phase_D[i] = {TRUNC_NUM{1'b0}};
      end
      
      
      for (int i=0; i<TRUNC_NUM; i=i+1) begin
	 clt_fwd_therm[i] = cif_fwd_therm[i][12:1];
      end
      
      
      for (int i=0; i<TRUNC_NUM; i=i+1) begin
	 clt_phase_B[i] = adjust_phase(clt_phase_A[i],
				       msm_state,
				       msm_dmw_r);
      end
      for (int i=0; i<MTF_NUM; i=i+1) begin
	 mtf_phase_B[i] = adjust_phase(mtf_phase_A[i],
				       msm_state,
				       msm_dmw_r);
      end
      
      
      
      for (int i=0; i<TRUNC_NUM; i=i+1) begin
	 logic ok;
	 ok = check_min_length(clt_phase_B[i],
			       clt_fwd_therm[i],
			       msm_state,
			       1'b0  
			       );
	 if (!ok) begin
	    clt_phase_C[i] = 4'b0;
	 end
	 else begin
	    clt_phase_C[i] = clt_phase_B[i];
	 end
      end

      for (int i=0; i<MTF_NUM; i=i+1) begin
	 logic ok;
	 ok = check_min_length(mtf_phase_B[i],
			       cif_mtf_fwd_therm[i],
			       msm_state,
			       1'b1  
			       );
	 if (!ok) begin
	    mtf_phase_C[i] = 4'b0;
	 end
	 else begin
	    mtf_phase_C[i] = mtf_phase_B[i];
	 end
      end

      
      
      
      unique case (1'b1)
	msm_state[U0] : begin
	   pval = msm_dmw[5:2];
	end 
	msm_state[U1] : begin
	   pval = msm_dmw[5:2];
	end 
	msm_state[U2] : begin
	   pval = msm_dmw[5:2];
	end 
	msm_state[U3] : begin
	   pval = msm_dmw[5:2];
	end 
	msm_state[UM1] : begin
	   pval = {msm_dmw[1:0],2'b0};
	end 
	msm_state[UM2] : begin
	   pval = {msm_dmw[1:0],2'b0};
	end 
	msm_state[UM1D], msm_state[UM2D] : begin
	   pval = {msm_dmw[1:0],2'b0};
	end
 	
 	default : begin
 	   pval = (msm_dmw[5:2] | {msm_dmw[1:0],2'b0}) & not_truncated;
 	end
      endcase 

	
      
      for (int i=0; i<TRUNC_NUM; i=i+1) begin
	 if ( ~|(clt_phase_C[i] & pval) ) begin
	    clt_phase_D[i] = 4'b0;
	 end else begin
	   clt_phase_D[i] = clt_phase_C[i];
	 end
      end
      for (int i=0; i<MTF_NUM; i=i+1) begin
	 if ( ~|(mtf_phase_C[i] & pval) ) begin
	    mtf_phase_D[i] = 4'b0;
	 end else begin
	   mtf_phase_D[i] = mtf_phase_C[i];
	 end
      end
      
      
      mdl_valid_run = |{clt_phase_D[0], mtf_phase_D[0],
			clt_phase_D[1], mtf_phase_D[1],
			clt_phase_D[2], mtf_phase_D[2],
			clt_phase_D[3], mtf_phase_D[3]};

      
      mdl_f = 4'b0;
      for (int i=0; i<TRUNC_NUM; i=i+1) begin
	 
	 
	 if (clt_fwd_therm[i][11]) begin
	    for (int p=0; p<TRUNC_NUM; p=p+1) begin
	       if (clt_phase_D[i][p])
		 mdl_f[p] = 1'b1;
	    end
	 end
      end      
      for (int i=0; i<MTF_NUM; i=i+1) begin
	 
	 
	 if (cif_mtf_fwd_therm[i][11]) begin
	    
	    
	    for (int p=0; p<TRUNC_NUM; p=p+1) begin
	       if (mtf_phase_D[i][p])
		 mdl_f[p] = 1'b1;
	    end
	 end
      end      


      
      for (int i=0; i<TRUNC_NUM; i=i+1) begin
	 clt_full_fwd_therm[i] = expanded_fwd_therm(1'b0,  
						    clt_phase_D[i],
						    clt_fwd_therm[i]);
	 
	 
	 
	 
	 if ( msm_continuing_c && 
 	      (msm_dmw[5:4] == 2'b00) &&
 	      (clt_phase_D[i][FOUR] || clt_phase_D[i][THREE])
 	      ) begin
 	    clt_full_fwd_therm[i] = clt_full_fwd_therm[i] >> 4;
	 end
      end
      
      for (int i=0; i<MTF_NUM; i=i+1) begin
	 mtf_full_fwd_therm[i] = expanded_fwd_therm(1'b1,  
						    mtf_phase_D[i],
						    cif_mtf_fwd_therm[i]);

	 
	 
	 
	 if ( msm_continuing_c && 
 	      (msm_dmw[5:4] == 2'b00) &&
 	      (mtf_phase_D[i][FOUR] || mtf_phase_D[i][THREE])
 	      ) begin
 	    mtf_full_fwd_therm[i] = mtf_full_fwd_therm[i] >> 4;
	 end
      end

      for (int i=0; i<MTF_NUM; i+=1) begin
	 mtf_stree_therm_in[i] = mtf_full_fwd_therm[i][18:6];
      end

      mtf_full_fwd_therm_winner = {mtf_stree_therm_out, {6{mtf_stree_therm_out[0]}}};



      
      clt_sel_3 = select_therm(clt_full_fwd_therm[FOUR],  
			       clt_phase_D[FOUR],
			       cif_offset[FOUR],
			       1'b0, 
			       0,    

 			       clt_full_fwd_therm[THREE], 
			       clt_phase_D[THREE], 
			       cif_offset[THREE],         
			       1'b0, 
			       0,    
			       msm_dmw
			       );
      
      
      clt_sel_1 = select_therm(clt_full_fwd_therm[TWO], 
			       clt_phase_D[TWO],
			       cif_offset[TWO],         
			       1'b0, 
			       0, 

 			       clt_full_fwd_therm[ONE], 
			       clt_phase_D[ONE],
			       cif_offset[ONE],         
			       1'b0, 
			       0, 
			       msm_dmw
			       );
      
      
      clt_full_fwd_therm_4_3  = clt_sel_3 ? 
		       clt_full_fwd_therm[THREE] : 
		       clt_full_fwd_therm[FOUR];
      
      clt_phase_4_3  = clt_sel_3 ? 
		       clt_phase_D[THREE] :
		       clt_phase_D[FOUR];
      
      clt_offset_4_3 = clt_sel_3 ? 
		       cif_offset[THREE] : 
		       cif_offset[FOUR];


      
      clt_full_fwd_therm_2_1  = clt_sel_1 ? 
		       clt_full_fwd_therm[ONE] : 
		       clt_full_fwd_therm[TWO];
      
      clt_phase_2_1  = clt_sel_1 ? 
		       clt_phase_D[ONE] : 
		       clt_phase_D[TWO];
      
      clt_offset_2_1 = clt_sel_1 ? 
		       cif_offset[ONE] : 
		       cif_offset[TWO];
      

      
      clt_sel_2_1 = select_therm(clt_full_fwd_therm_4_3,  
				 clt_phase_4_3,
				 clt_offset_4_3, 
				 1'b0, 
				 0,    

 				 clt_full_fwd_therm_2_1,  
				 clt_phase_2_1,
				 clt_offset_2_1, 
				 1'b0, 
				 0,    
				 msm_dmw
				 );
      
      
      clt_full_fwd_therm_winner = clt_sel_2_1 ?
			 clt_full_fwd_therm_2_1 :
			 clt_full_fwd_therm_4_3;
      
      clt_phase_winner = clt_sel_2_1 ?
			 clt_phase_2_1 :
			 clt_phase_4_3;
      
      clt_offset_winner = clt_sel_2_1 ?
			  clt_offset_2_1 :
			  clt_offset_4_3;
      
      
      winning_mtf_sel = select_therm(clt_full_fwd_therm_winner,  
				     4'b0,              
				     {LOG_OFFPE{1'b0}}, 
				     1'b0,              
				     0,                 
				     
 				     mtf_full_fwd_therm_winner, 
				     4'b0,              
				     {LOG_OFFPE{1'b0}}, 
				     1'b1,              
				     0,                 
				     6'b0               
				     );
      
      
      winning_full_fwd_therm = winning_mtf_sel ?
			       mtf_full_fwd_therm_winner :
			       clt_full_fwd_therm_winner;
      
      if (winning_mtf_sel) begin
	 winning_is_mtf = 1'b1;
	 case (mtf_sel)
	   2'b00 : begin
 	      winning_phase     = mtf_phase_D[ONE];
 	      winning_fwd_therm = cif_mtf_fwd_therm[ONE];
	      mdl_ptr_offset    = cif_mtf_offset[ONE];
	   end
	   2'b01 : begin
 	      winning_phase     = mtf_phase_D[TWO];
 	      winning_fwd_therm = cif_mtf_fwd_therm[TWO];
	      mdl_ptr_offset    = cif_mtf_offset[TWO];
	   end
	   2'b10 : begin
 	      winning_phase     = mtf_phase_D[THREE];
 	      winning_fwd_therm = cif_mtf_fwd_therm[THREE];
	      mdl_ptr_offset    = cif_mtf_offset[THREE];
	   end
	   default : begin 
 	      winning_phase     = mtf_phase_D[FOUR];
 	      winning_fwd_therm = cif_mtf_fwd_therm[FOUR];
	      mdl_ptr_offset    = cif_mtf_offset[FOUR];
	   end
	 endcase 

      end 
      else begin
	 winning_is_mtf = 1'b0;
	 if (clt_sel_2_1) begin
	    winning_phase = clt_sel_1 ?
			    clt_phase_D[ONE] :
			    clt_phase_D[TWO];

	    winning_fwd_therm = clt_sel_1 ?
				clt_fwd_therm[ONE] :
				clt_fwd_therm[TWO];

 	    mdl_ptr_offset = clt_sel_1 ? 
			     cif_offset[ONE] : 
			     cif_offset[TWO];
	 end
	 else begin
	    winning_phase = clt_sel_3 ?
			    clt_phase_D[THREE] :
			    clt_phase_D[FOUR];

	    winning_fwd_therm = clt_sel_3 ?
				clt_fwd_therm[THREE] :
				clt_fwd_therm[FOUR];

 	    mdl_ptr_offset = clt_sel_3 ? 
			     cif_offset[THREE] : 
			     cif_offset[FOUR];
	 end 

      end 
      

      mdl_mtf_idx = { {(LOG_OFFPE-2){1'b0}}, mtf_sel };


      
      

      previous_full_fwd_therm_muxed = msm_um2_um1_to_cont_reg ? 
				      previous_full_fwd_therm >> 4 :
				      previous_full_fwd_therm;
      
      
      previous_full_fwd_therm_adjusted = msm_continuing_c ? 
					 previous_full_fwd_therm_muxed >> 4 :
					 previous_full_fwd_therm_muxed;
      

      
      cluster_winner_beats_previous = select_therm(previous_full_fwd_therm_adjusted,
 						   mdl_previous_tuple.phase,
 						   mdl_previous_ptr_offset,
 						   mdl_previous_ptr_is_mtf,
 						   0,                 

						   clt_full_fwd_therm_winner,  
						   clt_phase_winner,
						   clt_offset_winner, 
						   1'b0,              
						   0,                 

						   
 						   msm_dmw
 						   );
				     

      
      current_mtf_idx = int'(mtf_sel);
      mtf_winner_beat_previous = select_therm(previous_full_fwd_therm_adjusted,
					      4'b0,              
 					      {LOG_OFFPE{1'b0}}, 
 					      mdl_previous_ptr_is_mtf,
 					      mdl_previous_mtf_idx,

					      mtf_full_fwd_therm_winner, 
					      4'b0,              
					      {LOG_OFFPE{1'b0}}, 
					      1'b1,              
					      current_mtf_idx,   
					      
 					      6'b0               
 					      );

      mdl_current_tuple_wins = cluster_winner_beats_previous || 
			       mtf_winner_beat_previous ||
			       msm_state[U0] ||
			       msm_state[U1] ||
			       msm_state[U2] ||
			       msm_state[U3];
			       
 

      
      
      
      
      
      mdl_ptr_length = {LOG_OFFPE{1'b0}};

      mdl_ptr_length[4:0] = run_length(winning_phase,
				       winning_fwd_therm);

      mdl_ptr_is_mtf = winning_is_mtf;

      mdl_winning_phase = winning_phase;
      mdl_previous_winning_phase = mdl_previous_tuple.phase;
      

      mdl_tuple.is_mtf    = winning_is_mtf; 
      mdl_tuple.phase     = winning_phase; 
      mdl_tuple.fwd_therm = winning_fwd_therm;
      
   end 


   
   
   
   
   
   function logic
     check_min_length (
			 logic [3:0] 	   phase,
			 logic [11:0] 	   fwd_therm,
			 logic [MSM_MSB:0] state,
			 logic 		   is_mtf
		       );

      logic 				   length_ok;
      
      length_ok = 1'b0;
      
      unique case (1'b1)
	phase[ONE] : begin
	   if (fwd_therm[2])
	     length_ok = 1'b1;
	end
	phase[TWO] : begin
	   if (fwd_therm[1])
	     length_ok = 1'b1;
	end
	phase[THREE] : begin
	   
	   if (fwd_therm[1])
	     length_ok = 1'b1;
	   else if (fwd_therm[0])
	     if (!state[UM1] || is_mtf)
	       length_ok = 1'b1;
	end
	phase[FOUR] : begin
	   
	   if (fwd_therm[0])
	     length_ok = 1'b1;
	   else if ((!state[UM1] && !state[UM2]) || is_mtf)
	     length_ok = 1'b1;
	end
	default : length_ok = 1'b0;  
      endcase 

      return length_ok;
   endfunction 
   
   
   
   
   
   
   function logic [3:0] 
     adjust_phase (
		   input [3:0] 	     phase,
		   input [MSM_MSB:0] state,
		   input [5:0] 	     um2_um1_dmw
		   );
      
      logic [3:0] 		     new_phase;
      
      new_phase = 4'b0000;
      
      unique case (1'b1)
	state[U1] : begin
	   unique case (1'b1)
	     phase[FOUR] : new_phase[THREE] = 1'b1;
	     default     : new_phase = phase;
	   endcase 
	end
	state[U2] : begin
	   unique case (1'b1)
	     phase[FOUR]  : new_phase[TWO] = 1'b1;
	     phase[THREE] : new_phase[TWO] = 1'b1;
	     default      : new_phase = phase;
	   endcase 
	end
	state[U3] : begin
	   unique case (1'b1)
	     phase[FOUR]  : new_phase[ONE] = 1'b1;
	     phase[THREE] : new_phase[ONE] = 1'b1;
	     phase[TWO]   : new_phase[ONE] = 1'b1;
	     default      : new_phase = phase;
	   endcase 
	end
 	state[UM1] : begin
 	   unique case (1'b1)
 	     phase[TWO], phase[ONE] : new_phase = 4'b0;
	     phase[THREE]  : begin
		if (um2_um1_dmw[0])
		  
		  new_phase = phase;
		else
		  
		  new_phase = 4'b0;
	     end
	     phase[FOUR]  : begin
		if (um2_um1_dmw[1])
		  
		  new_phase = phase;
		else
		  
		  new_phase = 4'b0;
	     end
 	     default                : new_phase = phase;
 	   endcase 
 	end 
	state[UM2] : begin
	   unique case (1'b1)
	     phase[THREE], 
		    phase[TWO],
		    phase[ONE] : new_phase = 4'b0;
	     phase[FOUR]  : begin
		if (um2_um1_dmw[1])
		  
		  new_phase = phase;
		else
		  
		  new_phase = 4'b0;
	     end
	     default           : new_phase = phase;
	   endcase 
	end 
	default : begin 
	   new_phase = phase;
	end
      endcase 
      
      return new_phase;
   endfunction 
   
   function logic 
     select_therm (
		   input [18:0] 	 therm_A,
		   input [3:0] 		 phase_A,
		   input [LOG_OFFPE-1:0] offset_A,
		   input 		 is_mtf_A,
		   int 			 mtf_index_A,

		   input [18:0] 	 therm_B,
		   input [3:0] 		 phase_B,
		   input [LOG_OFFPE-1:0] offset_B,
		   input 		 is_mtf_B,
		   int 			 mtf_index_B,

		   input [5:0] 		 dmw
		   );

      logic 				 sel; 
      logic 				 equal_len_sel;
      logic 				 not_equal_len_sel;

      if (is_mtf_A ^ is_mtf_B) begin
	 
	 equal_len_sel = is_mtf_A ? 0 : 1;  
      end
      else if (is_mtf_A && is_mtf_B) begin
	 
	 equal_len_sel = (mtf_index_A <= mtf_index_B) ? 0 : 1;
      end 
      else if (phase_A == phase_B) begin
	 
	 equal_len_sel = (offset_A <= offset_B) ? 0 : 1;
      end
      else if (&dmw[2:1]) begin
	 
	 
	 case (1'b1)
	   (phase_A[TWO])   : equal_len_sel = 1'b0;
	   (phase_B[TWO])   : equal_len_sel = 1'b1;
	   (phase_A[ONE])   : equal_len_sel = 1'b0;
	   (phase_B[ONE])   : equal_len_sel = 1'b1;
	   (phase_A[FOUR])  : equal_len_sel = 1'b0;
	   (phase_B[FOUR])  : equal_len_sel = 1'b1;
	   (phase_A[THREE]) : equal_len_sel = 1'b0;
	   default          : equal_len_sel = 1'b1; 
	 endcase 
      end 
      else begin
	 
	 
	 case (1'b1)
	   (phase_A[FOUR])  : equal_len_sel = 1'b0;
	   (phase_B[FOUR])  : equal_len_sel = 1'b1;
	   (phase_A[THREE]) : equal_len_sel = 1'b0;
	   (phase_B[THREE]) : equal_len_sel = 1'b1;
	   (phase_A[TWO])   : equal_len_sel = 1'b0;
	   (phase_B[TWO])   : equal_len_sel = 1'b1;
	   (phase_A[ONE])   : equal_len_sel = 1'b0;
	   default          : equal_len_sel = 1'b1; 
	 endcase 
      end 

      
      not_equal_len_sel = |(~therm_A & therm_B);

      if (therm_A == therm_B)
	sel = equal_len_sel;
      else
	sel = not_equal_len_sel;

      return sel;
   endfunction 
   


   cr_lz77_comp_stree
     #(
       .GROUP_NUM (1),
       .OFFSETS   (4),
       .T_WIDTH   (13),
       .T_MASK    (0),
       .OI_WIDTH  (0)
       )
   match_longest_stree
     (
      .therm_in   (mtf_stree_therm_in),
      .offset_in  (4'b0),
      .therm_out  (mtf_stree_therm_out),
      .offset_out (mtf_sel)
      );


endmodule 








