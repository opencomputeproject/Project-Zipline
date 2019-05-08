/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/















`include "cr_lz77_comp.vh"
`include "cr_lz77_comp_pkg_include.vh"

module cr_lz77_comp_msm
  #(
    parameter TILPC          = `TILES_PER_CLUSTER,
    parameter OFFPT          = `OFFSETS_PER_TILE,
    parameter CLUSTERS       = `CLUSTERS,
    parameter MSM_MSB        = 0
    )
   (
   
   msm_state, msm_emit_ptr, msm_emit_lit, msm_force_emit_lit,
   msm_global_count, msm_adjust_gc, msm_emit_previous_ptr,
   me_clt_dmw_cont, me_clt_max_match_len, me_clt_win_size,
   msm_emit_ptr_c, msm_emit_previous_ptr_c, msm_emit_lit_c,
   msm_save_tuple_c, msm_update_saved_tuple_c,
   msm_clear_saved_tuple_c, msm_shift_lits_c, msm_continuing_c,
   msm_continuing, msm_um2_um1_to_cont_c, msm_dmw, lec_prc_lz_error,
   
   clk, rst_n, mdl_tuple, cif_len4_ind, cif_len5_6_ind, mdl_f,
   mob_input_en, mob_done, mob_go, me_dly_match_win, me_max_match_len,
   me_win_size, mdl_previous_tuple, mdl_previous_is_2_back,
   mdl_current_tuple_wins
   );
   
`include "cr_lz77_comp_includes.vh"
`include "cr_lz77_comp_funcs.vh"

   localparam OFFPE     = OFFPT * TILPC * CLUSTERS; 
   localparam LOG_OFFPE = $clog2(OFFPE);


   
   
   
   input      	                      clk;
   input 			      rst_n;

   input 			      match_tuple_t mdl_tuple;

   input [3:0] 			      cif_len4_ind;
   input [2:0] 			      cif_len5_6_ind;
   input [3:0] 			      mdl_f;

   input 			      mob_input_en;
   input 			      mob_done;
   input 			      mob_go;
   input [1:0] 			      me_dly_match_win;
   input [1:0] 			      me_max_match_len; 
   input [2:0] 			      me_win_size;
   
   input 			      match_tuple_t mdl_previous_tuple;
   input 			      mdl_previous_is_2_back;
   input 			      mdl_current_tuple_wins;


   
   
   
   output reg [MSM_MSB:0] 	      msm_state;
   output reg 			      msm_emit_ptr;
   output reg [5:0] 		      msm_emit_lit;
   output reg 			      msm_force_emit_lit;
   output reg [LOG_OFFPE-1:0] 	      msm_global_count;
   output reg 			      msm_adjust_gc;
   output reg 			      msm_emit_previous_ptr;
   output reg [CLUSTERS-1:0][5:0]     me_clt_dmw_cont;
   output reg [CLUSTERS-1:0][1:0]     me_clt_max_match_len;
   output reg [CLUSTERS-1:0][2:0]     me_clt_win_size;
   
   
   output reg 			      msm_emit_ptr_c;
   output reg 			      msm_emit_previous_ptr_c;
   output reg [5:0] 		      msm_emit_lit_c;

   
   output reg 			      msm_save_tuple_c;
   output reg			      msm_update_saved_tuple_c;
   output reg 			      msm_clear_saved_tuple_c;
   output reg 			      msm_shift_lits_c;

   
   
   output reg 			      msm_continuing_c;
   output reg 			      msm_continuing;

   
   
   
   output reg 			      msm_um2_um1_to_cont_c;
   
   
   output reg [5:0] 		      msm_dmw;

   
   output reg 			      lec_prc_lz_error;
   

   
   
   
   
   
   
   
   logic [MSM_MSB:0] 		      msm_state_c;

   logic [MSM_MSB:0] 		      um1_next_state_hedge;
   logic [3:0] 			      um1_next_dmw_hedge;
   logic [MSM_MSB:0] 		      um2_next_state_hedge;
   logic [3:0]			      um2_next_dmw_hedge;

   logic 			      clr_global_count_c;
   logic 			      inc_global_count_c;
   logic [3:0] 			      dmw_cont;
   logic [3:0] 			      dmw_cont_mask_c;
   logic 			      msm_adjust_gc_c;
   logic 			      lz_error_c;

   
   
   
   
   logic [CLUSTERS:0][5:0] 	      dmw_cont_reg;
   logic [5:0] 			      dmw_cont_reg_r;
 			      


   always @ (posedge clk or negedge rst_n) begin
      if (!rst_n) begin
	 msm_emit_ptr             <= 1'b0;
	 msm_emit_lit             <= 6'b0;
	 msm_force_emit_lit       <= 1'b0;
	 msm_global_count         <= {LOG_OFFPE{1'b0}};
	 msm_adjust_gc            <= 1'b0;
	 msm_continuing           <= 1'b0;
	 msm_emit_previous_ptr    <= 1'b0;
	 dmw_cont_reg             <= {(CLUSTERS+1){6'b0}};

	 msm_state                <= {(MSM_MSB+1){1'b0}};
	 um1_next_state_hedge     <= {(MSM_MSB+1){1'b0}};
	 um1_next_dmw_hedge       <= 4'b0;
	 um2_next_state_hedge     <= {(MSM_MSB+1){1'b0}};
	 um2_next_dmw_hedge       <= 4'b0;

	 msm_state[MSM_IDLE]      <= 1'b1;
	 um1_next_state_hedge[U0] <= 1'b1;
	 um2_next_state_hedge[U0] <= 1'b1;
	 
	 dmw_cont_reg_r           <= 6'b0;

	 for (int i=0; i<(CLUSTERS); i=i+1) begin
	    me_clt_max_match_len[i] <= 2'b0;
	    me_clt_win_size[i]      <= 3'b0;
	 end

	 lec_prc_lz_error           <= 1'b0;
      end 
      else begin

	 if (mob_done) begin
	    msm_state                <= {(MSM_MSB+1){1'b0}};
	    msm_state[MSM_IDLE]      <= 1'b1;
	 end
	 else if (mob_input_en) begin
	    msm_state             <= msm_state_c;
	 end
	 
	 for (int i=0; i<(CLUSTERS); i=i+1) begin
	    me_clt_max_match_len[i] <= me_max_match_len;
	    me_clt_win_size[i]      <= me_win_size;
	 end

	 if (mob_input_en) begin

	    if (|dmw_cont_reg[CLUSTERS]) begin
	       dmw_cont_reg_r           <= dmw_cont_reg[CLUSTERS];
	    end

	    if (clr_global_count_c)
	      msm_global_count <= {LOG_OFFPE{1'b0}};
	    else if (inc_global_count_c)
	      msm_global_count <= msm_global_count + 4;  
	 

	    msm_emit_ptr          <= msm_emit_ptr_c;
	    msm_emit_lit          <= msm_emit_lit_c;

	    msm_emit_previous_ptr <= msm_emit_previous_ptr_c;
	    msm_adjust_gc         <= msm_adjust_gc_c;
	    msm_continuing        <= msm_continuing_c;
	    lec_prc_lz_error      <= lz_error_c;
	    
	    
	    
	    
	    msm_force_emit_lit    <= lz_error_c && !lec_prc_lz_error;

	    for (int i=0; i<(CLUSTERS+1); i=i+1) begin
	       casez(dmw_cont)
		 4'b1??? : begin
		    case (me_dly_match_win)
		      2'b00:   dmw_cont_reg[i] <= 6'b1000_00;
		      2'b01:   dmw_cont_reg[i] <= 6'b1100_00;
		      default: dmw_cont_reg[i] <= 6'b1110_00;
		    endcase 
		 end
		 4'b01?? : begin
		    case (me_dly_match_win)
		      2'b00:   dmw_cont_reg[i] <= 6'b0100_00;
		      2'b01:   dmw_cont_reg[i] <= 6'b0110_00;
		      default: dmw_cont_reg[i] <= 6'b0111_00;
		    endcase 
		 end
		 4'b001? : begin
		    case (me_dly_match_win)
		      2'b00:   dmw_cont_reg[i] <= 6'b0010_00;
		      2'b01:   dmw_cont_reg[i] <= 6'b0011_00;
		      default: dmw_cont_reg[i] <= 6'b0011_10;
		    endcase 
		 end
		 4'b0001 : begin
		    case (me_dly_match_win)
		      2'b00:   dmw_cont_reg[i] <= 6'b0001_00;
		      2'b01:   dmw_cont_reg[i] <= 6'b0001_10;
		      default: dmw_cont_reg[i] <= 6'b0001_11;
		    endcase 
		 end
		 default : begin
		    dmw_cont_reg[i] <= 6'b0;
		 end
	       endcase 

	    end 
	    

	    
	    
	    um1_next_dmw_hedge <= 4'b0000;
	    um1_next_state_hedge <= {(MSM_MSB+1){1'b0}};
            unique case (2'b01)
	      
              {mdl_tuple.fwd_therm[3], 1'b1}: begin
		 um1_next_dmw_hedge <= 4'b1111;
		 um1_next_state_hedge[U0] <= 1'b1;
              end
	      
              mdl_tuple.fwd_therm[4-:2]: begin
		 um1_next_dmw_hedge <= 4'b1111;
		 um1_next_state_hedge[U0] <= 1'b1;
	      end
              mdl_tuple.fwd_therm[5-:2]: begin
	         
		 um1_next_dmw_hedge <= 4'b0111;
		 um1_next_state_hedge[U1] <= 1'b1;
	      end
              mdl_tuple.fwd_therm[6-:2]: begin
	         
		 um1_next_dmw_hedge <= 4'b0011;
		 um1_next_state_hedge[U2] <= 1'b1;
	      end
	      mdl_tuple.fwd_therm[7-:2]: begin
	         
		 um1_next_dmw_hedge <= 4'b0001;
		 um1_next_state_hedge[U3] <= 1'b1;
	      end
              
              mdl_tuple.fwd_therm[8-:2]: begin
	         
		 um1_next_state_hedge[U4] <= 1'b1;
	      end
              mdl_tuple.fwd_therm[9-:2]: begin
		 
		 um1_next_state_hedge[U5] <= 1'b1;
	      end
              mdl_tuple.fwd_therm[10-:2]: begin
		 
		 um1_next_state_hedge[U6] <= 1'b1;
	      end
              mdl_tuple.fwd_therm[11-:2]: begin
		 
		 um1_next_state_hedge[U7] <= 1'b1;
	      end
              default: begin
		 
                 um1_next_state_hedge[U0] <= 1'b1;
              end
	    endcase 

	    
	    
	    um2_next_dmw_hedge <= 4'b0000;
	    um2_next_state_hedge <= {(MSM_MSB+1){1'b0}};
	    unique case (2'b01)
	      
              mdl_tuple.fwd_therm[3-:2]: begin
		 um2_next_dmw_hedge <= 4'b1111;
		 um2_next_state_hedge[U0] <= 1'b1;
	      end
	      
              mdl_tuple.fwd_therm[4-:2]: begin
		 
		 um2_next_dmw_hedge <= 4'b1111;
		 um2_next_state_hedge[U0] <= 1'b1;
	      end
	      mdl_tuple.fwd_therm[5-:2]: begin
                 
		 um2_next_dmw_hedge <= 4'b0111;
		 um2_next_state_hedge[U1] <= 1'b1;
	      end
              mdl_tuple.fwd_therm[6-:2]: begin
	         
		 um2_next_dmw_hedge <= 4'b0011;
		 um2_next_state_hedge[U2] <= 1'b1;
	      end
              mdl_tuple.fwd_therm[7-:2]: begin
	         
	         um2_next_dmw_hedge <= 4'b0001;
	         um2_next_state_hedge[U3] <= 1'b1;
	      end
	      
              mdl_tuple.fwd_therm[8-:2]: begin
		 
		 um2_next_state_hedge[U4] <= 1'b1;
	      end
              mdl_tuple.fwd_therm[9-:2]: begin
		 
		 um2_next_state_hedge[U5] <= 1'b1;
	      end
              mdl_tuple.fwd_therm[10-:2]: begin
		 
		 um2_next_state_hedge[U6] <= 1'b1;
	      end
              mdl_tuple.fwd_therm[11-:2]: begin
	         
		 um2_next_state_hedge[U7] <= 1'b1;
	      end
	      default : begin
		 
		 um2_next_state_hedge[U0] <= 1'b1;
	      end
	    endcase 

	 end 
	 
      end 
   end 
   


   always @ (*) begin

      dmw_cont = dmw_cont_mask_c & cif_len4_ind;
      
      for (int i=0; i<CLUSTERS; i=i+1) begin
	 me_clt_dmw_cont[i] = dmw_cont_reg[i];
      end
	 
      msm_dmw = (dmw_cont_reg[CLUSTERS] == 6'b0) ? 
		dmw_cont_reg_r :
		dmw_cont_reg[CLUSTERS];
      
      

      
      
      

      
      msm_state_c                     = {(MSM_MSB+1){1'b0}};
      msm_emit_ptr_c                  = 1'b0;
      msm_emit_lit_c                  = 6'b00_0000;
      msm_emit_previous_ptr_c         = 1'b0;
      clr_global_count_c              = 1'b0;
      inc_global_count_c              = 1'b0;
      dmw_cont_mask_c                 = 4'b0;
      msm_save_tuple_c                = 1'b0;
      msm_update_saved_tuple_c        = 1'b0;
      msm_clear_saved_tuple_c         = 1'b0;
      msm_shift_lits_c                = 1'b0;
      msm_continuing_c                = 1'b0;
      msm_adjust_gc_c                 = 1'b0;
      msm_um2_um1_to_cont_c           = 1'b0;
      lz_error_c                      = 1'b0;


      unique case (1'b1)
	
	msm_state[MSM_IDLE] : begin
	   dmw_cont_mask_c = 4'b1111;
	   if (mob_go) begin
	      msm_state_c[U0] = 1'b1;
	   end
	   else begin
	      msm_state_c[MSM_IDLE] = 1'b1;
	   end
	end

	msm_state[U0] : begin

	   msm_shift_lits_c   = 1'b1;
	   clr_global_count_c = 1'b1;
	   unique case (1'b1)
	     
	     mdl_tuple.phase[FOUR] : begin

		unique case (2'b01)
		  
                  {mdl_tuple.fwd_therm[0], 1'b1}: begin
		     
		     msm_emit_ptr_c = 1'b1;
		     dmw_cont_mask_c = 4'b1111;
		     msm_state_c[U0] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[1-:2]: begin
		     
		     msm_emit_ptr_c = 1'b1;
		     dmw_cont_mask_c = 4'b0111;
		     msm_state_c[U1] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[2-:2]: begin
		     
		     msm_emit_ptr_c = 1'b1;
		     dmw_cont_mask_c = 4'b0011;
		     msm_state_c[U2] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[3-:2]: begin
		     
		     msm_emit_ptr_c = 1'b1;
		     dmw_cont_mask_c = 4'b0001;
		     msm_state_c[U3] = 1'b1;
		  end
		  
                  mdl_tuple.fwd_therm[4-:2]: begin
		     
		     msm_emit_ptr_c = 1'b1;
		     msm_state_c[U4] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[5-:2]: begin
		     
		     msm_emit_ptr_c = 1'b1;
		     msm_state_c[U5] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[6-:2]: begin
		     
		     msm_emit_ptr_c = 1'b1;
		     msm_state_c[U6] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[7-:2]: begin
		     
		     if (mdl_f[TWO]) begin
			
			
			
			
			
			msm_clear_saved_tuple_c = 1'b1;
			msm_emit_lit_c          = 6'b00_1100;
			msm_state_c[UM2D]       = 1'b1;
		     end
		     else begin
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U7] = 1'b1;
		     end 
		  end
		  
                  mdl_tuple.fwd_therm[8-:2]: begin
		     
		     if (mdl_f[TWO] || mdl_f[THREE]) begin
			
			
			
			msm_save_tuple_c   = 1'b1;
			msm_state_c[UM4D] = 1'b1;
		     end
		     else begin
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U8] = 1'b1;
		     end
		  end 
                  mdl_tuple.fwd_therm[9-:2]: begin
		     
		     if (mdl_f[TWO] || mdl_f[THREE] || mdl_f[FOUR]) begin
			
			
			
			msm_save_tuple_c   = 1'b1;
			msm_state_c[UM4D] = 1'b1;
		     end
		     else begin
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U9] = 1'b1;
		     end
		  end 
                  mdl_tuple.fwd_therm[10-:2]: begin
		     
		     if (mdl_f[TWO] || mdl_f[THREE] || mdl_f[FOUR]) begin
			
			
			
			msm_save_tuple_c   = 1'b1;
			msm_state_c[UM4D] = 1'b1;
		     end
		     else begin
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U10] = 1'b1;
		     end
		  end 
                  mdl_tuple.fwd_therm[11-:2]: begin
		     
		     if (mdl_f[TWO] || mdl_f[THREE] || mdl_f[FOUR]) begin
			
			
			msm_save_tuple_c   = 1'b1;
			msm_state_c[UM4D] = 1'b1;
		     end
		     else begin
			     msm_emit_ptr_c = 1'b1;
			msm_state_c[U11] = 1'b1;
		     end
		  end 
                  {1'b0, mdl_tuple.fwd_therm[11]}: begin
		     
		     
		     msm_clear_saved_tuple_c = 1'b1;
		     msm_state_c[UM4D] = 1'b1;
		  end
                endcase 
	     end 

		  
	     mdl_tuple.phase[THREE] : begin

		unique case (2'b01)
                  
                  {mdl_tuple.fwd_therm[0], 1'b1}: begin 
		     msm_emit_ptr_c = 1'b1;
		     msm_emit_lit_c = 6'b00_1000;
		     msm_state_c[LZ_ERROR] = 1'b1;
 		     `CR_LZ77_COMP_ERROR;
 		  end
                  mdl_tuple.fwd_therm[1-:2]: begin
		     
		     msm_emit_ptr_c = 1'b1;
		     msm_emit_lit_c = 6'b00_1000;
		     dmw_cont_mask_c = 4'b0111;
		     msm_state_c[U1] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[2-:2]: begin
		     
		     msm_emit_ptr_c = 1'b1;
		     msm_emit_lit_c = 6'b00_1000;
		     dmw_cont_mask_c = 4'b0011;
		     msm_state_c[U2] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[3-:2]: begin
		     
		     msm_emit_ptr_c = 1'b1;
		     msm_emit_lit_c = 6'b00_1000;
		     dmw_cont_mask_c = 4'b0001;
		     msm_state_c[U3] = 1'b1;
		  end
		  
                  mdl_tuple.fwd_therm[4-:2]: begin
		     
		     msm_emit_lit_c = 6'b00_1000;
		     msm_emit_ptr_c = 1'b1;
		     msm_state_c[U4] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[5-:2]: begin
		     
		     msm_emit_lit_c = 6'b00_1000;
		     msm_emit_ptr_c = 1'b1;
		     msm_state_c[U5] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[6-:2]: begin
		     
		     msm_emit_lit_c = 6'b00_1000;
		     msm_emit_ptr_c = 1'b1;
		     msm_state_c[U6] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[7-:2]: begin
		     
		     msm_emit_lit_c = 6'b00_1000;
		     if (mdl_f[ONE]) begin
			
			
			
			
			
			
			msm_clear_saved_tuple_c = 1'b1;
			msm_emit_lit_c          = 6'b00_1110;
			msm_state_c[UM1D]       = 1'b1;
		     end
		     else begin
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U7] = 1'b1;
		     end 
		  end
                  
                  mdl_tuple.fwd_therm[8-:2]: begin
                     
		     msm_emit_lit_c = 6'b00_1000;
		     if (mdl_f[ONE] || mdl_f[TWO]) begin
			
			
			
			msm_save_tuple_c  = 1'b1;
			msm_state_c[UM3D] = 1'b1;
		     end
		     else begin
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U8] = 1'b1;
		     end
		     
		  end
                  mdl_tuple.fwd_therm[9-:2]: begin
                     
		     msm_emit_lit_c = 6'b00_1000;
		     if (mdl_f[ONE] || mdl_f[TWO] || mdl_f[THREE]) begin
			
			msm_save_tuple_c  = 1'b1;
			msm_state_c[UM3D] = 1'b1;
		     end
		     else begin
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U9] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[10-:2]: begin
                     
		     if (mdl_f[FOUR]) begin
			
			msm_save_tuple_c  = 1'b1;
			msm_state_c[UM4D] = 1'b1;
		     end
		     else if (mdl_f[THREE] || mdl_f[TWO] || mdl_f[ONE]) begin
			msm_emit_lit_c = 6'b00_1000;
			msm_save_tuple_c  = 1'b1;
			msm_state_c[UM3D] = 1'b1;
		     end
		     else begin
			msm_emit_lit_c = 6'b00_1000;
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U10] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[11-:2]: begin
                     
		     if (mdl_f[FOUR]) begin
			msm_save_tuple_c  = 1'b1;
			msm_state_c[UM4D] = 1'b1;
		     end
		     else if (mdl_f[THREE] || mdl_f[TWO] || mdl_f[ONE]) begin
			msm_emit_lit_c = 6'b00_1000;
			msm_save_tuple_c  = 1'b1;
			msm_state_c[UM3D] = 1'b1;
		     end
		     else begin
			msm_emit_lit_c = 6'b00_1000;
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U11] = 1'b1;
		     end
		  end
                  {1'b0, mdl_tuple.fwd_therm[11]}: begin
                     
		     msm_clear_saved_tuple_c  = 1'b1;
		     if (mdl_f[FOUR]) begin
			msm_state_c[UM4D] = 1'b1;
		     end
		     else begin
			msm_emit_lit_c = 6'b00_1000;
			msm_state_c[UM3D] = 1'b1;
		     end
		  end 
                endcase 
             end 

	     mdl_tuple.phase[TWO] : begin
		
		unique case (2'b01)
                  mdl_tuple.fwd_therm[2-:2]: begin
                     
 		     msm_emit_lit_c   = 6'b00_1100;
		     if (cif_len5_6_ind[1] && msm_dmw[1]) begin
			
			
			dmw_cont_mask_c = 4'b0000;
                        
			msm_clear_saved_tuple_c = 1'b1;
			msm_state_c[UM2] = 1'b1;
		     end
		     else begin
			dmw_cont_mask_c = 4'b0011;
			msm_state_c[U2] = 1'b1;
			msm_emit_ptr_c = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[3-:2]: begin
                     
 		     msm_emit_lit_c   = 6'b00_1100;
		     if (cif_len5_6_ind[2] && msm_dmw[1]) begin
			
			
			dmw_cont_mask_c = 4'b0000;
                        
			msm_clear_saved_tuple_c = 1'b1;
			msm_state_c[UM2] = 1'b1;
		     end
		     else begin
			dmw_cont_mask_c = 4'b0001;
			msm_state_c[U3] = 1'b1;
			msm_emit_ptr_c = 1'b1;
		     end
		  end
                  
                  {mdl_tuple.fwd_therm[7],mdl_tuple.fwd_therm[3]}: begin
 		     msm_emit_lit_c = 6'b00_1100;
		     msm_save_tuple_c = 1'b1;
		     msm_state_c[UM2] = 1'b1;
		  end
                  
                  mdl_tuple.fwd_therm[8-:2]: begin
                     
 		     msm_emit_lit_c = 6'b00_1100;
		     msm_save_tuple_c  = 1'b1;
		     if (mdl_f[ONE]) begin
			msm_state_c[UM2D] = 1'b1;
		     end
		     else begin
			msm_state_c[UM2] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[9-:2]: begin
                     
 		     msm_emit_lit_c = 6'b00_1100;
		     msm_save_tuple_c  = 1'b1;
		     if (mdl_f[ONE] || mdl_f[TWO]) begin
			msm_state_c[UM2D] = 1'b1;
		     end
		     else begin
			msm_state_c[UM2] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[10-:2]: begin
                     
		     msm_save_tuple_c  = 1'b1;
		     if (mdl_f[THREE]) begin
 			msm_emit_lit_c = 6'b00_1000;
			msm_state_c[UM3D] = 1'b1;
		     end
		     else if (mdl_f[ONE] || mdl_f[TWO]) begin
 			msm_emit_lit_c = 6'b00_1100;
			msm_state_c[UM2D] = 1'b1;
		     end
		     else begin
 			msm_emit_lit_c = 6'b00_1100;
			msm_state_c[UM2] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[11-:2]: begin
                     
		     msm_save_tuple_c  = 1'b1;
		     if (mdl_f[FOUR]) begin
			msm_state_c[UM4D] = 1'b1;
		     end
		     else if (mdl_f[THREE]) begin
 			msm_emit_lit_c = 6'b00_1000;
			msm_state_c[UM3D] = 1'b1;
		     end
		     else if (mdl_f[ONE] || mdl_f[TWO]) begin
 			msm_emit_lit_c = 6'b00_1100;
			msm_state_c[UM2D] = 1'b1;
		     end
		     else begin
 			msm_emit_lit_c = 6'b00_1100;
			msm_state_c[UM2] = 1'b1;
		     end
		  end 
                  {1'b0, mdl_tuple.fwd_therm[11]}: begin
                     
		     msm_clear_saved_tuple_c  = 1'b1;
		     if (mdl_f[FOUR]) begin
			msm_state_c[UM4D] = 1'b1;
		     end
		     else if (mdl_f[THREE]) begin
 			msm_emit_lit_c = 6'b00_1000;
			msm_state_c[UM3D] = 1'b1;
		     end
		     else begin
 			msm_emit_lit_c = 6'b00_1100;
			msm_state_c[UM2D] = 1'b1;
		     end
		  end 
 		  default : begin 
 		     msm_emit_lit_c   = 6'b00_1100;
		     msm_state_c[LZ_ERROR] = 1'b1;
 		     `CR_LZ77_COMP_ERROR;
 		  end
		endcase 
	     end 
	     mdl_tuple.phase[ONE] : begin
		unique case (2'b01)
		  
                  {mdl_tuple.fwd_therm[3], 1'b1}: begin
 		     msm_emit_lit_c = 6'b00_1110;
                     
		     if ( (cif_len5_6_ind[1] && msm_dmw[1]) || 
			  (cif_len5_6_ind[0] && msm_dmw[0]) ) begin
			
			
			dmw_cont_mask_c = 4'b0000;
			msm_clear_saved_tuple_c = 1'b1;
			msm_state_c[UM1] = 1'b1;
		     end
		     else begin
			dmw_cont_mask_c = 4'b0001;
			msm_state_c[U3] = 1'b1;
			msm_emit_ptr_c = 1'b1;
		     end
		  end
		  
		  
                  {mdl_tuple.fwd_therm[7], mdl_tuple.fwd_therm[3]}: begin
 		     msm_emit_lit_c = 6'b00_1110;
		     msm_save_tuple_c = 1'b1;
		     msm_state_c[UM1] = 1'b1;
		  end
	          
                  mdl_tuple.fwd_therm[8-:2]: begin
                     
 		     msm_emit_lit_c = 6'b00_1110;
		     msm_save_tuple_c = 1'b1;
		     msm_state_c[UM1] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[9-:2]: begin
                     
                     msm_emit_lit_c = 6'b00_1110;
                     msm_save_tuple_c = 1'b1;
                     if (mdl_f[ONE]) begin
                        msm_state_c[UM1D] = 1'b1;
                     end
		     else begin
			msm_state_c[UM1] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[10-:2]: begin
                     
		     msm_save_tuple_c = 1'b1;
		     if (mdl_f[TWO]) begin
 			msm_emit_lit_c = 6'b00_1100;
			msm_state_c[UM2D] = 1'b1;
		     end
		     else if (mdl_f[ONE]) begin
 			msm_emit_lit_c = 6'b00_1110;
			msm_state_c[UM1D] = 1'b1;
		     end
		     else begin
 			msm_emit_lit_c = 6'b00_1110;
			msm_state_c[UM1] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[11-:2]: begin
                     
		     msm_save_tuple_c = 1'b1;
		     if (mdl_f[THREE]) begin
 			msm_emit_lit_c = 6'b00_1000;
			msm_state_c[UM3D] = 1'b1;
		     end
		     else if (mdl_f[TWO]) begin
 			msm_emit_lit_c = 6'b00_1100;
			msm_state_c[UM2D] = 1'b1;
		     end
		     else if (mdl_f[ONE]) begin
 			msm_emit_lit_c = 6'b00_1110;
			msm_state_c[UM1D] = 1'b1;
		     end
		     else begin
 			msm_emit_lit_c = 6'b00_1110;
			msm_state_c[UM1] = 1'b1;
		     end
		  end 
                  {1'b0, mdl_tuple.fwd_therm[11]}: begin
                     
		     msm_clear_saved_tuple_c = 1'b1;
		     if (mdl_f[THREE]) begin
 			msm_emit_lit_c = 6'b00_1000;
			msm_state_c[UM3D] = 1'b1;
		     end
		     else if (mdl_f[TWO]) begin
 			msm_emit_lit_c = 6'b00_1100;
			msm_state_c[UM2D] = 1'b1;
		     end
		     else begin
 			msm_emit_lit_c = 6'b00_1110;
			msm_state_c[UM1D] = 1'b1;
		     end
		  end
 		  default : begin 
		     msm_state_c[LZ_ERROR] = 1'b1;
 		     `CR_LZ77_COMP_ERROR;
 		  end
                endcase 
	     end 
	     
	     (mdl_tuple.phase == 4'b0) : begin
		msm_emit_lit_c = 6'b00_1111;
		dmw_cont_mask_c = 4'b1111;
		msm_state_c[U0] = 1'b1;
	     end

 	     default : begin 
		msm_state_c[LZ_ERROR] = 1'b1;
 		`CR_LZ77_COMP_ERROR;
 	     end
	   endcase 
	end 
	

	msm_state[U1] : begin
	   
	   msm_shift_lits_c   = 1'b1;
	   clr_global_count_c = 1'b1;
	   unique case (1'b1)
	     
	     mdl_tuple.phase[THREE] : begin
		
		unique case (2'b01)
		  
 		  {mdl_tuple.fwd_therm[0], 1'b1} : begin 
		     msm_state_c[LZ_ERROR] = 1'b1;
 		     `CR_LZ77_COMP_ERROR;
 		  end
                  mdl_tuple.fwd_therm[1-:2]: begin
                     
		     msm_emit_ptr_c = 1'b1;
		     dmw_cont_mask_c = 4'b0111;
		     msm_state_c[U1] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[2-:2]: begin
                     
		     msm_emit_ptr_c = 1'b1;
		     dmw_cont_mask_c = 4'b0011;
		     msm_state_c[U2] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[3-:2]: begin
                     
		     msm_emit_ptr_c = 1'b1;
		     dmw_cont_mask_c = 4'b0001;
		     msm_state_c[U3] = 1'b1;
		  end
		  
                  mdl_tuple.fwd_therm[4-:2]: begin
                     
		     msm_emit_ptr_c = 1'b1;
		     msm_state_c[U4] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[5-:2]: begin
                     
		     msm_emit_ptr_c = 1'b1;
		     msm_state_c[U5] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[6-:2]: begin
                     
		     msm_emit_ptr_c = 1'b1;
		     msm_state_c[U6] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[7-:2]: begin
                     
		     if (mdl_f[ONE]) begin
			
			
			
			
			
			msm_clear_saved_tuple_c = 1'b1;
			msm_emit_lit_c          = 6'b00_0110;
			msm_state_c[UM1D]       = 1'b1;
		     end
		     else begin
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U7] = 1'b1;
		     end
		  end
		  
                  mdl_tuple.fwd_therm[8-:2]: begin
                     
		     if (mdl_f[ONE] || mdl_f[TWO]) begin
			msm_save_tuple_c  = 1'b1;
			msm_state_c[UM3D] = 1'b1;
		     end
		     else begin
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U8] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[9-:2]: begin
                     
		     if (mdl_f[ONE] || mdl_f[TWO] || mdl_f[THREE]) begin
			msm_save_tuple_c  = 1'b1;
			msm_state_c[UM3D] = 1'b1;
		     end
		     else begin
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U9] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[10-:2]: begin
                     
		     if (mdl_f[ONE] || mdl_f[TWO] || mdl_f[THREE]) begin
			msm_save_tuple_c  = 1'b1;
			msm_state_c[UM3D] = 1'b1;
		     end
		     else begin
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U10] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[11-:2]: begin
                     
		     if (mdl_f[ONE] || mdl_f[TWO] || mdl_f[THREE]) begin
			msm_save_tuple_c  = 1'b1;
			msm_state_c[UM3D] = 1'b1;
		     end
		     else begin
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U11] = 1'b1;
		     end
		  end
                  {1'b0, mdl_tuple.fwd_therm[11]}: begin
                     
		     msm_clear_saved_tuple_c  = 1'b1;
		     msm_state_c[UM3D] = 1'b1;
		  end
 		  default : begin 
		     msm_state_c[LZ_ERROR] = 1'b1;
 		     `CR_LZ77_COMP_ERROR;
 		  end
                endcase 
	     end 
	     
	     mdl_tuple.phase[TWO] : begin
		unique case (2'b01)
		  
 		  {mdl_tuple.fwd_therm[1], 1'b1} : begin 
 		     msm_emit_lit_c = 6'b00_0100;
		     msm_state_c[LZ_ERROR] = 1'b1;
 		     `CR_LZ77_COMP_ERROR;
 		  end
                  mdl_tuple.fwd_therm[2-:2]: begin
                     
 		     msm_emit_lit_c = 6'b00_0100;
		     if (cif_len5_6_ind[1] && msm_dmw[1]) begin
			
			
			dmw_cont_mask_c = 4'b0000;
			msm_clear_saved_tuple_c = 1'b1;
 			msm_state_c[UM2] = 1'b1;
		     end
		     else begin
			dmw_cont_mask_c = 4'b0011;
			msm_state_c[U2] = 1'b1;
			msm_emit_ptr_c = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[3-:2]: begin
                     
 		     msm_emit_lit_c = 6'b00_0100;
		     if (cif_len5_6_ind[2] && msm_dmw[1]) begin
			
			
			dmw_cont_mask_c = 4'b0000;
			msm_clear_saved_tuple_c = 1'b1;
			msm_state_c[UM2] = 1'b1;
		     end
		     else begin
			dmw_cont_mask_c = 4'b0001;
			msm_state_c[U3] = 1'b1;
			msm_emit_ptr_c = 1'b1;
		     end
		  end
		  
                  {mdl_tuple.fwd_therm[7], mdl_tuple.fwd_therm[3]}: begin
 		     msm_emit_lit_c = 6'b00_0100;
		     msm_save_tuple_c = 1'b1;
		     msm_state_c[UM2] = 1'b1;
		  end
		  
                  mdl_tuple.fwd_therm[8-:2]: begin
                     
 		     msm_emit_lit_c = 6'b00_0100;
		     msm_save_tuple_c = 1'b1;
		     if (mdl_f[ONE]) begin
			msm_state_c[UM2D] = 1'b1;
		     end
		     else begin
			msm_state_c[UM2] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[9-:2]: begin
                     
 		     msm_emit_lit_c = 6'b00_0100;
		     msm_save_tuple_c = 1'b1;
		     if (mdl_f[ONE] || mdl_f[TWO]) begin
			msm_state_c[UM2D] = 1'b1;
		     end
		     else begin
			msm_state_c[UM2] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[10-:2]: begin
                     
		     msm_save_tuple_c = 1'b1;
		     if (mdl_f[THREE]) begin
			msm_state_c[UM3D] = 1'b1;
		     end
		     else if (mdl_f[ONE] || mdl_f[TWO]) begin
 			msm_emit_lit_c = 6'b00_0100;
			msm_state_c[UM2D] = 1'b1;
		     end
		     else begin
 			msm_emit_lit_c = 6'b00_0100;
			msm_state_c[UM2] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[11-:2]: begin
                     
		     msm_save_tuple_c = 1'b1;
		     if (mdl_f[THREE]) begin
			msm_state_c[UM3D] = 1'b1;
		     end
		     else if (mdl_f[ONE] || mdl_f[TWO]) begin
 			msm_emit_lit_c = 6'b00_0100;
			msm_state_c[UM2D] = 1'b1;
		     end
		     else begin
 			msm_emit_lit_c = 6'b00_0100;
			msm_state_c[UM2] = 1'b1;
		     end
		  end 
                  {1'b0, mdl_tuple.fwd_therm[11]}: begin
                     
		     msm_clear_saved_tuple_c = 1'b1;
		     if (mdl_f[THREE]) begin
			msm_state_c[UM3D] = 1'b1;
		     end
		     else begin
 			msm_emit_lit_c = 6'b00_0100;
			msm_state_c[UM2D] = 1'b1;
		     end
		  end
 		  default : begin 
		     msm_state_c[LZ_ERROR] = 1'b1;
 		     `CR_LZ77_COMP_ERROR;
 		  end
                endcase 
	     end 
	     
	     mdl_tuple.phase[ONE] : begin
		unique case (2'b01)
		  
		  {mdl_tuple.fwd_therm[3], 1'b1}: begin
 		     msm_emit_lit_c = 6'b00_0110;
		     if ( (cif_len5_6_ind[1] && msm_dmw[1]) || 
		          (cif_len5_6_ind[0] && msm_dmw[0]) ) begin
		        
		        
		        dmw_cont_mask_c = 4'b0000;
		        msm_clear_saved_tuple_c = 1'b1;
		        msm_state_c[UM1] = 1'b1;
		     end
		     else begin
		        dmw_cont_mask_c = 4'b0001;
		        msm_state_c[U3] = 1'b1;
		        msm_emit_ptr_c = 1'b1;
		     end 
                  end 
		  
                  {mdl_tuple.fwd_therm[7], mdl_tuple[3]}: begin
 		     msm_emit_lit_c = 6'b00_0110;
		     msm_save_tuple_c = 1'b1;
		     msm_state_c[UM1] = 1'b1;
		  end
		  
                  mdl_tuple.fwd_therm[8-:2]: begin
                     
 		     msm_emit_lit_c = 6'b00_0110;
		     msm_save_tuple_c = 1'b1;
		     msm_state_c[UM1] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[9-:2]: begin
                     
 		     msm_emit_lit_c = 6'b00_0110;
		     msm_save_tuple_c = 1'b1;
		     if (mdl_f[ONE]) begin
			msm_state_c[UM1D] = 1'b1;
		     end
		     else begin
			msm_state_c[UM1] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[10-:2]: begin
                     
		     msm_save_tuple_c = 1'b1;
		     if (mdl_f[TWO]) begin
 			msm_emit_lit_c = 6'b00_0100;
			msm_state_c[UM2D] = 1'b1;
		     end
		     else if (mdl_f[ONE]) begin
 			msm_emit_lit_c = 6'b00_0110;
			msm_state_c[UM1D] = 1'b1;
		     end
		     else begin
 			msm_emit_lit_c = 6'b00_0110;
			msm_state_c[UM1] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[11-:2]: begin
                     
		     msm_save_tuple_c = 1'b1;
		     if (mdl_f[THREE]) begin
			msm_state_c[UM3D] = 1'b1;
		     end
		     else if (mdl_f[TWO]) begin
 			msm_emit_lit_c = 6'b00_0100;
			msm_state_c[UM2D] = 1'b1;
		     end
		     else if (mdl_f[ONE]) begin
 			msm_emit_lit_c = 6'b00_0110;
			msm_state_c[UM1D] = 1'b1;
		     end
		     else begin
 			msm_emit_lit_c = 6'b00_0110;
			msm_state_c[UM1] = 1'b1;
		     end
		  end 
                  {1'b0, mdl_tuple.fwd_therm[11]}: begin
                     
		     msm_clear_saved_tuple_c = 1'b1;
		     if (mdl_f[THREE]) begin
			msm_state_c[UM3D] = 1'b1;
		     end
		     else if (mdl_f[TWO]) begin
 			msm_emit_lit_c = 6'b00_0100;
			msm_state_c[UM2D] = 1'b1;
		     end
		     else begin
 			msm_emit_lit_c = 6'b00_0110;
			msm_state_c[UM1D] = 1'b1;
		     end
		  end
 		  default : begin 
		     msm_state_c[LZ_ERROR] = 1'b1;
 		     `CR_LZ77_COMP_ERROR;
 		  end
                endcase 
             end 
	
	     (mdl_tuple.phase == 4'b0) : begin
		msm_emit_lit_c = 6'b00_0111;
		dmw_cont_mask_c = 4'b1111;
		msm_state_c[U0] = 1'b1;
	     end

 	     default : begin 
		msm_state_c[LZ_ERROR] = 1'b1;
 		`CR_LZ77_COMP_ERROR;
 	     end
	   endcase 
	end 


	msm_state[U2] : begin

	   msm_shift_lits_c   = 1'b1;
	   clr_global_count_c = 1'b1;
	   unique case (1'b1)
	     
	     mdl_tuple.phase[TWO] : begin

		unique case (2'b01)
		  
                  mdl_tuple.fwd_therm[2-:2]: begin
                     
		     if (cif_len5_6_ind[1] && msm_dmw[1]) begin
			
			
			dmw_cont_mask_c = 4'b0000;
			msm_clear_saved_tuple_c = 1'b1;
 			msm_state_c[UM2] = 1'b1;
		     end
		     else begin
			dmw_cont_mask_c = 4'b0011;
			msm_state_c[U2] = 1'b1;
			msm_emit_ptr_c = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[3-:2]: begin
                     
		     if (cif_len5_6_ind[2] && msm_dmw[1]) begin
			
			
			dmw_cont_mask_c = 4'b0000;
			msm_clear_saved_tuple_c = 1'b1;
 			msm_state_c[UM2] = 1'b1;
		     end
		     else begin
			dmw_cont_mask_c = 4'b0001;
			msm_state_c[U3] = 1'b1;
			msm_emit_ptr_c = 1'b1;
		     end
		  end
		  
                  {mdl_tuple.fwd_therm[7], mdl_tuple.fwd_therm[3]}: begin
		     msm_save_tuple_c = 1'b1;
		     msm_state_c[UM2] = 1'b1;
		  end
		  
                  mdl_tuple.fwd_therm[8-:2]: begin
                     
		     msm_save_tuple_c = 1'b1;
		     if (mdl_f[ONE]) begin
			msm_state_c[UM2D] = 1'b1;
		     end
		     else begin
			msm_state_c[UM2] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[9-:2]: begin
                     
		     msm_save_tuple_c = 1'b1;
		     if (mdl_f[ONE] || mdl_f[TWO]) begin
			msm_state_c[UM2D] = 1'b1;
		     end
		     else begin
			msm_state_c[UM2] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[10-:2]: begin
                     
		     msm_save_tuple_c = 1'b1;
		     if (mdl_f[ONE] || mdl_f[TWO]) begin
			msm_state_c[UM2D] = 1'b1;
		     end
		     else begin
			msm_state_c[UM2] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[11-:2]: begin
                     
		     msm_save_tuple_c = 1'b1;
		     if (mdl_f[ONE] || mdl_f[TWO]) begin
			msm_state_c[UM2D] = 1'b1;
		     end
		     else begin
			msm_state_c[UM2] = 1'b1;
		     end
		  end 
                  {1'b0, mdl_tuple.fwd_therm[11]}: begin
                     
		     msm_clear_saved_tuple_c = 1'b1;
		     msm_state_c[UM2D] = 1'b1;
		  end
 		  default : begin 
		     msm_state_c[LZ_ERROR] = 1'b1;
 		     `CR_LZ77_COMP_ERROR;
 		  end
                endcase 
	     end 

	     mdl_tuple.phase[ONE] : begin
		unique case (2'b01)
		  
                  {mdl_tuple.fwd_therm[3], 1'b1}: begin
 		     msm_emit_lit_c = 6'b00_0010;
		     if ( (cif_len5_6_ind[1] && msm_dmw[1]) || 
			  (cif_len5_6_ind[0] && msm_dmw[0]) ) begin
			
			
			dmw_cont_mask_c = 4'b0000;
			msm_clear_saved_tuple_c = 1'b1;
			msm_state_c[UM1] = 1'b1;
		     end
		     else begin
			dmw_cont_mask_c = 4'b0001;
			msm_state_c[U3] = 1'b1;
			msm_emit_ptr_c = 1'b1;
		     end
		  end 
		  
                  {mdl_tuple.fwd_therm[7], mdl_tuple.fwd_therm[3]}: begin
 		     msm_emit_lit_c = 6'b00_0010;
		     msm_save_tuple_c = 1'b1;
		     msm_state_c[UM1] = 1'b1;
		  end
		  
                  mdl_tuple.fwd_therm[8-:2]: begin
                     
 		     msm_emit_lit_c = 6'b00_0010;
		     msm_save_tuple_c = 1'b1;
		     msm_state_c[UM1] = 1'b1;
		  end
                  mdl_tuple.fwd_therm[9-:2]: begin
                     
 		     msm_emit_lit_c = 6'b00_0010;
		     msm_save_tuple_c = 1'b1;
		     if (mdl_f[ONE]) begin
			msm_state_c[UM1D] = 1'b1;
		     end
		     else begin
			msm_state_c[UM1] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[10-:2]: begin
                     
		     msm_save_tuple_c = 1'b1;
		     if (mdl_f[TWO]) begin
			msm_state_c[UM2D] = 1'b1;
		     end
		     else if (mdl_f[ONE]) begin
 			msm_emit_lit_c = 6'b00_0010;
			msm_state_c[UM1D] = 1'b1;
		     end
		     else begin
 			msm_emit_lit_c = 6'b00_0010;
			msm_state_c[UM1] = 1'b1;
		     end
		  end
                  mdl_tuple.fwd_therm[11-:2]: begin
                     
		     msm_save_tuple_c = 1'b1;
		     if (mdl_f[TWO]) begin
			msm_state_c[UM2D] = 1'b1;
		     end
		     else if (mdl_f[ONE]) begin
 			msm_emit_lit_c = 6'b00_0010;
			msm_state_c[UM1D] = 1'b1;
		     end
		     else begin
 			msm_emit_lit_c = 6'b00_0010;
			msm_state_c[UM1] = 1'b1;
		     end
		  end 
                  {1'b0, mdl_tuple.fwd_therm[11]}: begin
                     
		     msm_clear_saved_tuple_c = 1'b1;
		     if (mdl_f[TWO]) begin
			msm_state_c[UM2D] = 1'b1;
		     end
		     else begin
 			msm_emit_lit_c = 6'b00_0010;
			msm_state_c[UM1D] = 1'b1;
		     end
		  end
 		  default : begin 
		     msm_state_c[LZ_ERROR] = 1'b1;
 		     `CR_LZ77_COMP_ERROR;
 		  end
		endcase 
	     end 

	     (mdl_tuple.phase == 4'b0) : begin
		msm_emit_lit_c = 6'b00_0011;
		dmw_cont_mask_c = 4'b1111;
		msm_state_c[U0] = 1'b1;
	     end

 	     default : begin 
		msm_state_c[LZ_ERROR] = 1'b1;
 		`CR_LZ77_COMP_ERROR;
 	     end
	   endcase 
	end 
	
	msm_state[U3] : begin

	   msm_shift_lits_c   = 1'b1;
	   clr_global_count_c = 1'b1;
	   unique case (1'b1)
	     mdl_tuple.phase[ONE] : begin
                
		unique case (2'b01)
		  
                  {mdl_tuple.fwd_therm[3], 1'b1}: begin
		     if ( (cif_len5_6_ind[1] && msm_dmw[1]) || 
			  (cif_len5_6_ind[0] && msm_dmw[0]) ) begin
			
			
			dmw_cont_mask_c = 4'b0000;
			msm_clear_saved_tuple_c = 1'b1;
			msm_state_c[UM1] = 1'b1;
		     end
		     else begin
			dmw_cont_mask_c = 4'b0001;
			msm_state_c[U3] = 1'b1;
			msm_emit_ptr_c = 1'b1;
		     end
		  end
		  
                  {mdl_tuple.fwd_therm[7], mdl_tuple.fwd_therm[3]}: begin
		     msm_save_tuple_c = 1'b1;
		     msm_state_c[UM1] = 1'b1;
		  end
		  
                  mdl_tuple.fwd_therm[8-:2]: begin
                     
		     msm_save_tuple_c = 1'b1;
		     msm_state_c[UM1] = 1'b1;
		  end
                  {mdl_tuple.fwd_therm[11],mdl_tuple.fwd_therm[8]}: begin
                     
                     
                     
		     msm_save_tuple_c = 1'b1;
		     if (mdl_f[ONE]) begin
			msm_state_c[UM1D] = 1'b1;
		     end
		     else begin
			msm_state_c[UM1] = 1'b1;
		     end
		  end
                  {1'b0, mdl_tuple.fwd_therm[11]}: begin
                     
		     msm_clear_saved_tuple_c = 1'b1;
		     msm_state_c[UM1D] = 1'b1;
		  end
 		  default : begin 
		     msm_state_c[LZ_ERROR] = 1'b1;
 		     `CR_LZ77_COMP_ERROR;
 		  end
                endcase 
             end 

	     (mdl_tuple.phase == 4'b0) : begin
		msm_emit_lit_c = 6'b00_0001;
		dmw_cont_mask_c = 4'b1111;
		msm_state_c[U0] = 1'b1;
	     end
 	     default : begin 
		msm_state_c[LZ_ERROR] = 1'b1;
 		`CR_LZ77_COMP_ERROR;
 	     end
	   endcase 
	end 
	

	msm_state[UM1] : begin

	   msm_shift_lits_c         = 1'b1;
	   clr_global_count_c       = 1'b1;
	   unique case (1'b1)

	     mdl_tuple.phase[FOUR] : begin

		if (mdl_current_tuple_wins) begin

		   unique case (2'b01)
		     
                     {mdl_tuple.fwd_therm[0], 1'b1}: begin
                        
			msm_emit_lit_c = 6'b01_0000;
			msm_emit_ptr_c = 1'b1;
			dmw_cont_mask_c = 4'b1111;
			msm_state_c[U0] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[1-:2]: begin
                        
			msm_emit_lit_c = 6'b01_0000;
			msm_emit_ptr_c = 1'b1;
			dmw_cont_mask_c = 4'b0111;
			msm_state_c[U1] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[2-:2]: begin
                        
			msm_emit_lit_c = 6'b01_0000;
			msm_emit_ptr_c = 1'b1;
			dmw_cont_mask_c = 4'b0011;
			msm_state_c[U2] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[3-:2]: begin
                        
			msm_emit_lit_c = 6'b01_0000;
			msm_emit_ptr_c = 1'b1;
			dmw_cont_mask_c = 4'b0001;
			msm_state_c[U3] = 1'b1;
		     end
		     
                     mdl_tuple.fwd_therm[4-:2]: begin
                        
			msm_emit_lit_c = 6'b01_0000;
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U4] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[5-:2]: begin
                        
			msm_emit_lit_c = 6'b01_0000;
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U5] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[6-:2]: begin
                        
			msm_emit_lit_c = 6'b01_0000;
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U6] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[7-:2]: begin
                        
			msm_emit_lit_c = 6'b01_0000;
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U7] = 1'b1;
		     end
		     
                     mdl_tuple.fwd_therm[8-:2]: begin
                        
			if (mdl_f[THREE]) begin
			   msm_update_saved_tuple_c = 1'b1;
			   msm_um2_um1_to_cont_c = 1'b1;
			   msm_state_c[UM4_1] = 1'b1;
			end
			else begin
			   msm_emit_lit_c = 6'b01_0000;
			   msm_emit_ptr_c = 1'b1;
			   msm_state_c[U8] = 1'b1;
			end
		     end
                     mdl_tuple.fwd_therm[9-:2]: begin
                        
			if (mdl_f[THREE] || mdl_f[FOUR]) begin
			   msm_update_saved_tuple_c = 1'b1;
			   msm_um2_um1_to_cont_c = 1'b1;
			   msm_state_c[UM4_1] = 1'b1;
			end
			else begin
			   msm_emit_lit_c = 6'b01_0000;
			   msm_emit_ptr_c = 1'b1;
			   msm_state_c[U9] = 1'b1;
			end
		     end
                     mdl_tuple.fwd_therm[10-:2]: begin
                        
			if (mdl_f[THREE] || mdl_f[FOUR]) begin
			   msm_update_saved_tuple_c = 1'b1;
			   msm_um2_um1_to_cont_c = 1'b1;
			   msm_state_c[UM4_1] = 1'b1;
			end
			else begin
			   msm_emit_lit_c = 6'b01_0000;
			   msm_emit_ptr_c = 1'b1;
			   msm_state_c[U10] = 1'b1;
			end
		     end
                     mdl_tuple.fwd_therm[11-:2]: begin
                        
			if (mdl_f[THREE] || mdl_f[FOUR]) begin
			   msm_update_saved_tuple_c = 1'b1;
			   msm_um2_um1_to_cont_c = 1'b1;
			   msm_state_c[UM4_1] = 1'b1;
			end
			else begin
			   msm_emit_lit_c = 6'b01_0000;
			   msm_emit_ptr_c = 1'b1;
			   msm_state_c[U11] = 1'b1;
			end
		     end
                     {1'b0, mdl_tuple.fwd_therm[11]}: begin
                        
			msm_um2_um1_to_cont_c = 1'b1;
			msm_state_c[UM4_1] = 1'b1;
			msm_clear_saved_tuple_c = 1'b1;
		     end
 		     default : begin 
			msm_state_c[LZ_ERROR] = 1'b1;
 			`CR_LZ77_COMP_ERROR;
 		     end
                   endcase 
                end 
		else begin 
		   if (mdl_f[THREE]) begin
		      
		      
		      
		      
		      
		      
		      
		      msm_um2_um1_to_cont_c = 1'b1;
		      msm_state_c[UM3] = 1'b1;
		   end
		   else begin		   
		      
		      
		      msm_emit_previous_ptr_c  = 1'b1;
		      msm_state_c = um1_next_state_hedge;
		      dmw_cont_mask_c = um1_next_dmw_hedge;
		   end 
		end 
	     end 
	     

	     mdl_tuple.phase[THREE] : begin

		if (mdl_current_tuple_wins) begin

		   unique case (2'b01)
		     
 		     {mdl_tuple.fwd_therm[0], 1'b1} : begin 
			msm_emit_lit_c = 6'b01_1000;
			msm_emit_ptr_c = 1'b1;
			msm_state_c[LZ_ERROR] = 1'b1;
 			`CR_LZ77_COMP_ERROR;
 		     end
                     mdl_tuple.fwd_therm[1-:2]: begin
                        
			msm_emit_lit_c = 6'b01_1000;
			msm_emit_ptr_c = 1'b1;
			dmw_cont_mask_c = 4'b0111;
			msm_state_c[U1] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[2-:2]: begin
                        
			msm_emit_lit_c = 6'b01_1000;
			msm_emit_ptr_c = 1'b1;
			dmw_cont_mask_c = 4'b0011;
			msm_state_c[U2] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[3-:2]: begin
                        
			msm_emit_lit_c = 6'b01_1000;
			msm_emit_ptr_c = 1'b1;
			dmw_cont_mask_c = 4'b0001;
			msm_state_c[U3] = 1'b1;
		     end
		     
                     mdl_tuple.fwd_therm[4-:2]: begin
                        
			msm_emit_lit_c = 6'b01_1000;
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U4] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[5-:2]: begin
                        
			msm_emit_lit_c = 6'b01_1000;
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U5] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[6-:2]: begin
                        
			msm_emit_lit_c = 6'b01_1000;
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U6] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[7-:2]: begin
                        
			msm_emit_lit_c = 6'b01_1000;
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U7] = 1'b1;
		     end
		     
                     mdl_tuple.fwd_therm[8-:2]: begin
                        
			msm_emit_lit_c = 6'b01_1000;
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U8] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[9-:2]: begin
                        
			
			if (mdl_f[THREE]) begin
			   msm_update_saved_tuple_c = 1'b1;
			   msm_um2_um1_to_cont_c = 1'b1;
			   msm_state_c[UM3] = 1'b1;
			end
			else begin
			   msm_emit_lit_c = 6'b01_1000;
			   msm_emit_ptr_c = 1'b1;
			   msm_state_c[U9] = 1'b1;
			end
		     end
                     mdl_tuple.fwd_therm[10-:2]: begin
                        
			if (mdl_f[FOUR]) begin
			   msm_update_saved_tuple_c = 1'b1;
			   msm_um2_um1_to_cont_c = 1'b1;
			   msm_state_c[UM4_1] = 1'b1;
			end
			else if (mdl_f[THREE]) begin
			   msm_update_saved_tuple_c = 1'b1;
			   msm_um2_um1_to_cont_c = 1'b1;
			   msm_state_c[UM3] = 1'b1;
			end
			else begin
			   msm_emit_lit_c = 6'b01_1000;
			   msm_emit_ptr_c = 1'b1;
			   msm_state_c[U10] = 1'b1;
			end
		     end
                     mdl_tuple.fwd_therm[11-:2]: begin
                        
			if (mdl_f[FOUR]) begin
			   msm_update_saved_tuple_c = 1'b1;
			   msm_um2_um1_to_cont_c = 1'b1;
			   msm_state_c[UM4_1] = 1'b1;
			end
			else if (mdl_f[THREE]) begin
			   msm_update_saved_tuple_c = 1'b1;
			   msm_um2_um1_to_cont_c = 1'b1;
			   msm_state_c[UM3] = 1'b1;
			end
			else begin
			   msm_emit_lit_c = 6'b01_1000;
			   msm_emit_ptr_c = 1'b1;
			   msm_state_c[U11] = 1'b1;
			end
		     end
                     {1'b0, mdl_tuple.fwd_therm[11]}: begin
                        
			if (mdl_f[FOUR]) begin
			   msm_clear_saved_tuple_c = 1'b1;
			   msm_um2_um1_to_cont_c = 1'b1;
			   msm_state_c[UM4_1] = 1'b1;
			end
			else begin
			   msm_um2_um1_to_cont_c = 1'b1;
			   msm_state_c[UM3] = 1'b1;
			end
		     end
 		     default : begin 
			msm_state_c[LZ_ERROR] = 1'b1;
 			`CR_LZ77_COMP_ERROR;
 		     end
		   endcase 
                end 
		else begin 
		   if (mdl_f[THREE]) begin
		      
		      
		      
		      
		      
		      
		      
		      msm_um2_um1_to_cont_c = 1'b1;
		      msm_state_c[UM3] = 1'b1;
		   end 
		   else begin
		      
		      msm_emit_previous_ptr_c  = 1'b1;
		      msm_state_c = um1_next_state_hedge;
		      dmw_cont_mask_c = um1_next_dmw_hedge;
		   end 
		end 
	     end 
	     
	     (mdl_tuple.phase == 4'b0) : begin
		
		msm_emit_previous_ptr_c  = 1'b1;
		msm_state_c = um1_next_state_hedge;
		dmw_cont_mask_c = um1_next_dmw_hedge;
	     end 

 	     default : begin 
		msm_state_c[LZ_ERROR] = 1'b1;
 		`CR_LZ77_COMP_ERROR;
 	     end
	   endcase 
	end 
	

	msm_state[UM2] : begin

	   msm_shift_lits_c         = 1'b1;
	   clr_global_count_c       = 1'b1;
	   unique case (1'b1)

	     mdl_tuple.phase[FOUR] : begin

		if (mdl_current_tuple_wins) begin

		   unique case (2'b01)
		     
                     {mdl_tuple.fwd_therm[0], 1'b1}: begin
                        
			msm_emit_lit_c = 6'b11_0000;
			msm_emit_ptr_c = 1'b1;
			dmw_cont_mask_c = 4'b1111;
			msm_state_c[U0] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[1-:2]: begin
                        
			msm_emit_lit_c = 6'b11_0000;
			msm_emit_ptr_c = 1'b1;
			dmw_cont_mask_c = 4'b0111;
			msm_state_c[U1] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[2-:2]: begin
                        
			msm_emit_lit_c = 6'b11_0000;
			msm_emit_ptr_c = 1'b1;
			dmw_cont_mask_c = 4'b0011;
			msm_state_c[U2] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[3-:2]: begin
                        
			msm_emit_lit_c = 6'b11_0000;
			msm_emit_ptr_c = 1'b1;
			dmw_cont_mask_c = 4'b0001;
			msm_state_c[U3] = 1'b1;
		     end
		     
                     mdl_tuple.fwd_therm[4-:2]: begin
                        
			msm_emit_lit_c = 6'b11_0000;
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U4] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[5-:2]: begin
                        
			msm_emit_lit_c = 6'b11_0000;
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U5] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[6-:2]: begin
                        
			msm_emit_lit_c = 6'b11_0000;
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U6] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[7-:2]: begin
                        
			msm_emit_lit_c = 6'b11_0000;
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U7] = 1'b1;
		     end
		     
                     mdl_tuple.fwd_therm[8-:2]: begin
                        
			msm_emit_lit_c = 6'b11_0000;
			msm_emit_ptr_c = 1'b1;
			msm_state_c[U8] = 1'b1;
		     end
                     mdl_tuple.fwd_therm[9-:2]: begin
                        
			if (mdl_f[FOUR]) begin
			   msm_update_saved_tuple_c = 1'b1;
			   msm_um2_um1_to_cont_c = 1'b1;
			   msm_state_c[UM4_2] = 1'b1;
			end
			else begin
			   msm_emit_lit_c = 6'b11_0000;
			   msm_emit_ptr_c = 1'b1;
			   msm_state_c[U9] = 1'b1;
			end
		     end
                     mdl_tuple.fwd_therm[10-:2]: begin
                        
			if (mdl_f[FOUR]) begin
			   msm_update_saved_tuple_c = 1'b1;
			   msm_um2_um1_to_cont_c = 1'b1;
			   msm_state_c[UM4_2] = 1'b1;
			end
			else begin
			   msm_emit_lit_c = 6'b11_0000;
			   msm_emit_ptr_c = 1'b1;
			   msm_state_c[U10] = 1'b1;
			end
		     end
                     mdl_tuple.fwd_therm[11-:2]: begin
                        
			if (mdl_f[FOUR]) begin
			   msm_update_saved_tuple_c = 1'b1;
			   msm_um2_um1_to_cont_c = 1'b1;
			   msm_state_c[UM4_2] = 1'b1;
			end
			else begin
			   msm_emit_lit_c = 6'b11_0000;
			   msm_emit_ptr_c = 1'b1;
			   msm_state_c[U11] = 1'b1;
			end
		     end
                     {1'b0, mdl_tuple.fwd_therm[11]}: begin
                        
			
			
			
			
			
			msm_um2_um1_to_cont_c = 1'b1;
			msm_state_c[UM4_2] = 1'b1;
		     end
 		     default : begin 
			msm_state_c[LZ_ERROR] = 1'b1;
 			`CR_LZ77_COMP_ERROR;
 		     end
                   endcase 
                end 
		else begin 
		   if (mdl_f[FOUR]) begin
		      
		      
		      
		      
		      
		      
		      
		      msm_um2_um1_to_cont_c = 1'b1;
		      msm_state_c[UM4_2] = 1'b1;
		   end
		   else begin		   
		      
		      
		      msm_emit_previous_ptr_c  = 1'b1;
		      msm_state_c = um2_next_state_hedge;
		      dmw_cont_mask_c = um2_next_dmw_hedge;
		   end 
		end 

	     end 
	     
	     (mdl_tuple.phase == 4'b0) : begin
		
		msm_emit_previous_ptr_c  = 1'b1;
		dmw_cont_mask_c = um2_next_dmw_hedge;
		msm_state_c = um2_next_state_hedge;
	     end 
 	     default : begin 
		msm_state_c[LZ_ERROR] = 1'b1;
 		`CR_LZ77_COMP_ERROR;
 	     end
	   endcase 
	end 
	
	msm_state[U4] : begin
	   msm_shift_lits_c = 1'b1;
	   dmw_cont_mask_c = 4'b1111;
	   msm_state_c[U0]  = 1'b1;
	end
	
	msm_state[U5] : begin
	   msm_shift_lits_c = 1'b1;
	   dmw_cont_mask_c = 4'b0111;
	   msm_state_c[U1]  = 1'b1;
	end
	
	msm_state[U6] : begin
	   msm_shift_lits_c = 1'b1;
	   dmw_cont_mask_c = 4'b0011;
	   msm_state_c[U2]  = 1'b1;
	end
	
	msm_state[U7] : begin
	   msm_shift_lits_c = 1'b1;
	   dmw_cont_mask_c = 4'b0001;
	   msm_state_c[U3]  = 1'b1;
	end
	
	msm_state[U8] : begin
	   msm_shift_lits_c = 1'b1;
	   msm_state_c[U4]  = 1'b1;
	end
	
	msm_state[U9] : begin
	   msm_shift_lits_c = 1'b1;
	   msm_state_c[U5]  = 1'b1;
	end
	
	msm_state[U10] : begin
	   msm_shift_lits_c = 1'b1;
	   msm_state_c[U6]  = 1'b1;
	end
	
	msm_state[U11] : begin
	   msm_shift_lits_c = 1'b1;
	   msm_state_c[U7]  = 1'b1;
	end
	
	msm_state[UM4D] : begin
	   msm_continuing_c   = 1'b1;
	   inc_global_count_c = 1'b1;
	   msm_state_c[UM8]   = 1'b1;
	end

	
 	msm_state[UM8] : begin
 	   inc_global_count_c       = 1'b1;
	   msm_continuing_c         = 1'b1;

	   if (!mdl_tuple.fwd_therm[11]) begin
	      
	      msm_update_saved_tuple_c = 1'b1;
	   end

	   if (mdl_f[FOUR] || mdl_f[THREE] || mdl_f[TWO]) begin
	      
	      
	      
	      msm_state_c[C4] = 1'b1;
	   end
	   else begin
	      
	      
	      
	      if (mdl_current_tuple_wins) begin
		 if (mdl_tuple.phase[THREE]) begin
		    msm_emit_lit_c = 6'b00_1000;
		 end
		 if (mdl_tuple.phase[TWO]) begin
		    msm_emit_lit_c = 6'b00_1100;
		 end
		 msm_emit_ptr_c = 1'b1;
		 unique case (1'b1)

		   
		   
		   mdl_tuple.phase[FOUR],mdl_tuple.phase[THREE],mdl_tuple.phase[TWO] : begin
		      unique case (2'b01)
			
                        mdl_tuple.fwd_therm[4-:2]: begin
                           
			   msm_state_c[U4] = 1'b1;
			end
                        mdl_tuple.fwd_therm[5-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_tuple.fwd_therm[6-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_tuple.fwd_therm[7-:2]: begin
                           
			   msm_state_c[U7] = 1'b1;
			end
			
                        mdl_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U8] = 1'b1;
			end
                        mdl_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U9] = 1'b1;
			end
                        mdl_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U10] = 1'b1;
			end
                        mdl_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U11] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
                      endcase 
                   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
		   end
		 endcase 
	      end 
	      else begin
		 unique case (1'b1)

		   mdl_previous_tuple.phase[FOUR] : begin
		      unique case (2'b01)
			
			   
                        mdl_previous_tuple.fwd_therm[8-:2]: begin
                           
			   msm_emit_previous_ptr_c = 1'b1;
			   dmw_cont_mask_c = 4'b1111;
			   msm_state_c[U0] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
			   msm_emit_previous_ptr_c = 1'b1;
			   dmw_cont_mask_c = 4'b0111;
			   msm_state_c[U1] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   msm_emit_previous_ptr_c = 1'b1;
			   dmw_cont_mask_c = 4'b0011;
			   msm_state_c[U2] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   msm_emit_previous_ptr_c = 1'b1;
			   dmw_cont_mask_c = 4'b0001;
			   msm_state_c[U3] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
                      endcase 
                   end
		   mdl_previous_tuple.phase[THREE] : begin
		      msm_emit_lit_c = 6'b00_1000;
		      msm_emit_previous_ptr_c = 1'b1;
		      unique case (2'b01)
			
			
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   dmw_cont_mask_c = 4'b0011;
			   msm_state_c[U2] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   dmw_cont_mask_c = 4'b0001;
			   msm_state_c[U3] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 

		   mdl_previous_tuple.phase[TWO] : begin
                      if (mdl_previous_tuple.fwd_therm[11-:2] == 2'b01) begin
			 msm_emit_lit_c = 6'b00_1100;
			 msm_emit_previous_ptr_c = 1'b1;
			 dmw_cont_mask_c = 4'b0001;
			 msm_state_c[U3] = 1'b1;
		      end
		      else begin
			 msm_state_c[LZ_ERROR] = 1'b1;
 			 `CR_LZ77_COMP_ERROR;
 		      end
		   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
 		   end
		 endcase 
	      end 
	   end 
	end 
	
        
 	msm_state[UM4_1] : begin
 	   inc_global_count_c       = 1'b1;
	   msm_continuing_c         = 1'b1;

	   if (!mdl_tuple.fwd_therm[11]) begin
	      
	      msm_update_saved_tuple_c = 1'b1;
	   end

	   if (mdl_f[FOUR] || mdl_f[THREE]) begin
	      
	      
	      
	      msm_emit_lit_c = 6'b01_0000;
	      msm_state_c[C4] = 1'b1;
	   end
	   else begin
	      
	      
	      
	      if (mdl_current_tuple_wins) begin
		 if (mdl_tuple.phase[FOUR]) begin
		    msm_emit_lit_c = 6'b01_0000;
		 end
		 if (mdl_tuple.phase[THREE]) begin
		    msm_emit_lit_c = 6'b01_1000;
		 end
		 msm_emit_ptr_c = 1'b1;
		 unique case (1'b1)
		   
		   
		   mdl_tuple.phase[FOUR],mdl_tuple.phase[THREE] : begin
		      unique case (2'b01)
			
                        mdl_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U8] = 1'b1;
			end
                        mdl_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U9] = 1'b1;
			end
                        mdl_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U10] = 1'b1;
			end
                        mdl_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U11] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
                   end
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
 		   end
		 endcase 
	      end 
	      else begin
		 msm_emit_previous_ptr_c = 1'b1;
		 unique case (1'b1)
		   mdl_previous_tuple.phase[FOUR] : begin
		      msm_emit_lit_c = 6'b01_0000;
		      unique case (2'b01)
			{mdl_previous_tuple.fwd_therm[0],1'b1},mdl_previous_tuple.fwd_therm[4-:2],mdl_previous_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U4] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[1-:2],mdl_previous_tuple.fwd_therm[5-:2],mdl_previous_tuple.fwd_therm[9-:2]: begin
			   
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[2-:2],mdl_previous_tuple.fwd_therm[6-:2],mdl_previous_tuple.fwd_therm[10-:2]: begin
			
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[3-:2],mdl_previous_tuple.fwd_therm[7-:2],mdl_previous_tuple.fwd_therm[11-:2]: begin
			   
			   msm_state_c[U7] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
		   mdl_previous_tuple.phase[THREE] : begin
		      msm_emit_lit_c = 6'b01_1000;
		      unique case (2'b01)
                        mdl_previous_tuple.fwd_therm[2-:2],mdl_previous_tuple.fwd_therm[6-:2],mdl_previous_tuple.fwd_therm[10-:2]: begin
			   
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[3-:2],mdl_previous_tuple.fwd_therm[7-:2],mdl_previous_tuple.fwd_therm[11-:2]: begin
			   
			   msm_state_c[U7] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
 		   end
		 endcase 
	      end 
	   end 
	end 
		   

 	msm_state[UM4_2] : begin
 	   inc_global_count_c       = 1'b1;
	   msm_continuing_c         = 1'b1;

	   if (!mdl_tuple.fwd_therm[11]) begin
	      
	      msm_update_saved_tuple_c = 1'b1;
	   end

	   if (mdl_f[FOUR]) begin
	      
	      
	      
	      msm_emit_lit_c = 6'b11_0000;
	      msm_state_c[C4] = 1'b1;
	   end
	   else begin
	      
	      
	      
	      if (mdl_current_tuple_wins) begin
		 msm_emit_ptr_c = 1'b1;
		 msm_emit_lit_c = 6'b11_0000;
		 unique case (1'b1)
		   mdl_tuple.phase[FOUR] : begin
		      unique case (2'b01)
                        
                        mdl_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U8] = 1'b1;
			end
                        mdl_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U9] = 1'b1;
			end
                        mdl_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U10] = 1'b1;
			end
                        mdl_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U11] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
 		   end
		 endcase 
	      end 
	      else begin
		 msm_emit_previous_ptr_c = 1'b1;
		 unique case (1'b1)
		   mdl_previous_tuple.phase[FOUR] : begin
		      msm_emit_lit_c = 6'b11_0000;
		      unique case (2'b01)
                        mdl_previous_tuple[1-:2],mdl_previous_tuple[5-:2],mdl_previous_tuple[9-:2]: begin
			   
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_previous_tuple[2-:2],mdl_previous_tuple[6-:2],mdl_previous_tuple[10-:2]: begin
			   
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple[3-:2],mdl_previous_tuple[7-:2],mdl_previous_tuple[11-:2]: begin
			   
			   msm_state_c[U7] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
		   mdl_previous_tuple.phase[TWO] : begin
		      
		      
                      if (mdl_previous_tuple.fwd_therm[11-:2] == 2'b01) begin
			 dmw_cont_mask_c = 4'b0001;
			 msm_state_c[U3] = 1'b1;
		      end
		      else begin
			 msm_state_c[LZ_ERROR] = 1'b1;
 			 `CR_LZ77_COMP_ERROR;
 		      end
		   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
 		   end
		 endcase 
	      end 
	   end 
	end 
	
        
	msm_state[C4] : begin
 	   inc_global_count_c       = 1'b1;
	   msm_continuing_c         = 1'b1;

	   if (!mdl_tuple.fwd_therm[11]) begin
	      
	      msm_update_saved_tuple_c = 1'b1;
	   end

	   if (mdl_f[FOUR] || mdl_f[THREE] || mdl_f[TWO]) begin
	      
	      
	      
	      msm_state_c[C4] = 1'b1;
	   end
	   else begin
	      
	      
	      
	      if (mdl_current_tuple_wins) begin
		 if (mdl_tuple.phase[THREE]) begin
		    msm_emit_lit_c = 6'b00_1000;
		 end
		 if (mdl_tuple.phase[TWO]) begin
		    msm_emit_lit_c = 6'b00_1100;
		 end
		 msm_emit_ptr_c = 1'b1;
		 unique case (1'b1)
		   
		   
		   mdl_tuple.phase[FOUR],mdl_tuple.phase[THREE],mdl_tuple.phase[TWO] : begin
		      unique case (2'b01)
			
                        mdl_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U8] = 1'b1;
			end
                        mdl_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U9] = 1'b1;
			end
                        mdl_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U10] = 1'b1;
			end
                        mdl_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U11] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
                   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
		   end
		 endcase 
	      end 
	      else begin
		 
		 msm_emit_previous_ptr_c = 1'b1;
		 unique case (1'b1)
		   mdl_previous_tuple.phase[FOUR] : begin
                      unique case (2'b01)
		        
		        mdl_previous_tuple.fwd_therm[7-:2]: begin
			   dmw_cont_mask_c = 4'b0001;
			   msm_state_c[U3] = 1'b1;
			end
			
                        mdl_previous_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U4] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   if (mdl_previous_is_2_back) begin
			      dmw_cont_mask_c = 4'b0001;
			      msm_state_c[U3] = 1'b1;
			   end
			   else begin
			      msm_state_c[U7] = 1'b1;
				end
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
		   mdl_previous_tuple.phase[THREE] : begin
		      msm_emit_lit_c = 6'b00_1000;
                      unique case (2'b01)
		        
                        mdl_previous_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U4] = 1'b1;
		        end
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
		           msm_state_c[U5] = 1'b1;
		        end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
		           msm_state_c[U6] = 1'b1;
		        end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
		           msm_state_c[U7] = 1'b1;
		        end
 		        default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
		   mdl_previous_tuple.phase[TWO] : begin
		      msm_emit_lit_c = 6'b00_1100;
		      unique case (2'b01)
			
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U7] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
 		   end
		 endcase 
	      end 
	   end 
	end 

	msm_state[UM3D] : begin
	   msm_continuing_c         = 1'b1;
	   inc_global_count_c       = 1'b1;
	   msm_state_c[UM7]         = 1'b1;
	end


	msm_state[UM7] : begin
 	   inc_global_count_c  = 1'b1;
	   msm_continuing_c         = 1'b1;

	   if (!mdl_tuple.fwd_therm[11]) begin
	      
	      msm_update_saved_tuple_c = 1'b1;
	   end

	   if (mdl_f[THREE] || mdl_f[TWO] || mdl_f[ONE]) begin
	      
	      
	      
	      msm_state_c[C3] = 1'b1;
	   end
	   else begin
	      
	      
	      
	      if (mdl_current_tuple_wins) begin

		 if (mdl_tuple.phase[TWO]) begin
		    msm_emit_lit_c = 6'b00_0100;
		 end
		 if (mdl_tuple.phase[ONE]) begin
		    msm_emit_lit_c = 6'b00_0110;
		 end
		 msm_emit_ptr_c = 1'b1;
		 
		 unique case (1'b1)

		   
		   
		   mdl_tuple.phase[THREE],mdl_tuple.phase[TWO],mdl_tuple.phase[ONE] : begin
		      unique case (2'b01)
			
                        mdl_tuple.fwd_therm[4-:2]: begin
                           
			   msm_state_c[U4] = 1'b1;
			end
                        mdl_tuple.fwd_therm[5-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_tuple.fwd_therm[6-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_tuple.fwd_therm[7-:2]: begin
                           
			   msm_state_c[U7] = 1'b1;
			end
			
                        mdl_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U8] = 1'b1;
			end
                        mdl_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U9] = 1'b1;
			end
                        mdl_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U10] = 1'b1;
			end
                        mdl_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U11] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
                   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
 		   end
		 endcase 
	      end 
	      else begin
		 unique case (1'b1)
                   
		   mdl_previous_tuple.phase[THREE] : begin
		      unique case (2'b01)
			
			   
                        mdl_previous_tuple.fwd_therm[8-:2]: begin
                           
			   msm_emit_previous_ptr_c = 1'b1;
			   dmw_cont_mask_c = 4'b1111;
			   msm_state_c[U0] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
			   msm_emit_previous_ptr_c = 1'b1;
			   dmw_cont_mask_c = 4'b0111;
			   msm_state_c[U1] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   msm_emit_previous_ptr_c = 1'b1;
			   dmw_cont_mask_c = 4'b0011;
			   msm_state_c[U2] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   msm_emit_previous_ptr_c = 1'b1;
			   dmw_cont_mask_c = 4'b0001;
			   msm_state_c[U3] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
		   mdl_previous_tuple.phase[TWO] : begin
		      msm_emit_lit_c = 6'b00_0100;
		      msm_emit_previous_ptr_c = 1'b1;
		      unique case (2'b01)
			
			
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   dmw_cont_mask_c = 4'b0011;
			   msm_state_c[U2] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   dmw_cont_mask_c = 4'b0001;
			   msm_state_c[U3] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
		   mdl_previous_tuple.phase[ONE] : begin
                      if (mdl_previous_tuple[11-:2] == 2'b01) begin
			 msm_emit_lit_c = 6'b00_0110;
			 msm_emit_previous_ptr_c = 1'b1;
			 dmw_cont_mask_c = 4'b0001;
			 msm_state_c[U3] = 1'b1;
		      end
		      else begin
			 msm_state_c[LZ_ERROR] = 1'b1;
 			 `CR_LZ77_COMP_ERROR;
		      end
		   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
 		   end
		 endcase 
	      end 
	   end 
	end 
        
        
	msm_state[UM3] : begin
 	   inc_global_count_c       = 1'b1;
	   msm_continuing_c         = 1'b1;

	   if (!mdl_tuple.fwd_therm[11]) begin
	      
	      msm_update_saved_tuple_c = 1'b1;
	   end

	   if (mdl_f[THREE]) begin
	      
	      
	      
	      msm_emit_lit_c = 6'b01_1000;
	      msm_state_c[C3] = 1'b1;
	   end
	   else begin
	      
	      
	      
	      if (mdl_current_tuple_wins) begin
		 msm_emit_ptr_c = 1'b1;
		 unique case (1'b1)
		   mdl_tuple.phase[THREE] : begin
		      msm_emit_lit_c = 6'b01_1000;
		      unique case (2'b01)
			
                        mdl_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U8] = 1'b1;
			end
                        mdl_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U9] = 1'b1;
			end
                        mdl_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U10] = 1'b1;
			end
                        mdl_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U11] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
                   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
 		   end
		 endcase 
	      end 
	      else begin
		 msm_emit_previous_ptr_c = 1'b1;
		 unique case (1'b1)
		   mdl_previous_tuple.phase[THREE] : begin
		      msm_emit_lit_c = 6'b01_1000;
		      unique case (2'b01)
                        mdl_previous_tuple.fwd_therm[1-:2],mdl_previous_tuple[5-:2],mdl_previous_tuple[9-:2]: begin
			   
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[2-:2],mdl_previous_tuple[6-:2],mdl_previous_tuple[10-:2]: begin
			   
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[3-:2],mdl_previous_tuple[7-:2],mdl_previous_tuple[11-:2]: begin
			   
			   msm_state_c[U7] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
		   mdl_previous_tuple.phase[ONE] : begin
                      if (mdl_previous_tuple.fwd_therm[11-:2] == 2'b01) begin
			 dmw_cont_mask_c = 4'b0001;
			 msm_state_c[U3] = 1'b1;
		      end
		      else begin
			 msm_state_c[LZ_ERROR] = 1'b1;
 			 `CR_LZ77_COMP_ERROR;
 		      end 
		   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
 		   end
		 endcase 
	      end 
	   end 
	end 
	

	msm_state[C3] : begin
 	   inc_global_count_c       = 1'b1;
	   msm_continuing_c         = 1'b1;

	   if (!mdl_tuple.fwd_therm[11]) begin
	      
	      msm_update_saved_tuple_c = 1'b1;
	   end

	   if (mdl_f[THREE] || mdl_f[TWO] || mdl_f[ONE]) begin
	      
	      
	      
	      msm_state_c[C3] = 1'b1;
	   end
	   else begin
	      
	      
	      

	      if (mdl_current_tuple_wins) begin

		 if (mdl_tuple.phase[TWO]) begin
		    msm_emit_lit_c = 6'b00_0100;
		 end
		 if (mdl_tuple.phase[ONE]) begin
		    msm_emit_lit_c = 6'b00_0110;
		 end
		 msm_emit_ptr_c = 1'b1;
		 
		 unique case (1'b1)
		   
		   
		   mdl_tuple.phase[THREE],mdl_tuple.phase[TWO],mdl_tuple.phase[ONE] : begin
		      unique case (2'b01)
			
                        mdl_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U8] = 1'b1;
			end
                        mdl_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U9] = 1'b1;
			end
                        mdl_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U10] = 1'b1;
			end
                        mdl_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U11] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
 		   end
		 endcase 
	      end 
	      else begin
		 
		 msm_emit_previous_ptr_c = 1'b1;
		 unique case (1'b1)
		   mdl_previous_tuple.phase[THREE] : begin
		      unique case (2'b01)
			
			mdl_previous_tuple.fwd_therm[7-:2]: begin
			   dmw_cont_mask_c = 4'b0001;
			   msm_state_c[U3] = 1'b1;
			end
			
                        mdl_previous_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U4] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   if (mdl_previous_is_2_back) begin
			      dmw_cont_mask_c = 4'b0001;
			      msm_state_c[U3] = 1'b1;
			   end
			   else begin
			      msm_state_c[U7] = 1'b1;
			   end
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
		   mdl_previous_tuple.phase[TWO] : begin
		      msm_emit_lit_c = 6'b00_0100;
		      unique case (2'b01)
			
                        mdl_previous_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U4] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U7] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
		   mdl_previous_tuple.phase[ONE] : begin
		      msm_emit_lit_c = 6'b00_0110;
		      unique case (2'b01)
			
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U7] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
 		   end
		 endcase 
	      end 
	   end 
	end 
        
        
	msm_state[UM2D] : begin
	   msm_shift_lits_c         = 1'b1;
	   inc_global_count_c       = 1'b1;
	   msm_continuing_c         = 1'b1;
	   msm_state_c[UM6]         = 1'b1;

	   
	   unique case (1'b1)
	     mdl_tuple.phase[FOUR] : begin
		if (msm_dmw[1]) begin 
                   if ({mdl_tuple.fwd_therm[11],mdl_tuple.fwd_therm[5]} == 2'b01) begin
                      
                      
                      
                      
                      
                      
                      msm_update_saved_tuple_c = 1'b1;
                   end
                   else begin
                      msm_update_saved_tuple_c = 1'b0;  
		   end 
		end 
	     end 
	     default : msm_update_saved_tuple_c = 1'b0;  
	   endcase 
	end 


 	msm_state[UM6] : begin
 	   inc_global_count_c       = 1'b1;
	   msm_continuing_c         = 1'b1;

	   if (!mdl_tuple.fwd_therm[11]) begin
	      
	      msm_update_saved_tuple_c = 1'b1;
	   end

	   if (mdl_f[FOUR] || mdl_f[TWO] || mdl_f[ONE]) begin
	      
	      
	      
	      msm_state_c[C2] = 1'b1;
	   end
	   else begin
	      
	      
	      
	      if (mdl_current_tuple_wins) begin
		 
		 if (mdl_tuple.phase[ONE]) begin
		    msm_emit_lit_c = 6'b10_0000;
		 end
		 if (mdl_tuple.phase[FOUR]) begin
		    msm_adjust_gc_c = 1'b1;
		    msm_emit_lit_c = 6'b11_0000;
		 end
		 msm_emit_ptr_c = 1'b1;
		 
		 unique case (1'b1)

		   
		   
		   mdl_tuple.phase[TWO],mdl_tuple.phase[ONE] : begin
                      unique case (2'b01)
			
                        mdl_tuple.fwd_therm[4-:2]: begin
                           
			   msm_state_c[U4] = 1'b1;
			end
                        mdl_tuple.fwd_therm[5-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_tuple.fwd_therm[6-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_tuple.fwd_therm[7-:2]: begin
                           
			   msm_state_c[U7] = 1'b1;
			end
			
                        mdl_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U8] = 1'b1;
			end
                        mdl_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U9] = 1'b1;
			end
                        mdl_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U10] = 1'b1;
			end
                        mdl_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U11] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
                   end 
		   mdl_tuple.phase[FOUR] : begin
		      unique case (2'b01)
			
                        mdl_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U8] = 1'b1;
			end
                        mdl_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U9] = 1'b1;
			end
                        mdl_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U10] = 1'b1;
			end
                        mdl_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U11] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
		   end
		 endcase 
	      end 
	      else begin
		 
		 msm_emit_previous_ptr_c = 1'b1;
                 
		 unique case (1'b1)
		   
		   mdl_previous_tuple.phase[TWO] : begin
                      unique case (2'b01)
		        
			
                        mdl_previous_tuple.fwd_therm[8-:2]: begin
                           
			   dmw_cont_mask_c = 4'b1111;
			   msm_state_c[U0] = 1'b1;
		        end
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
		           dmw_cont_mask_c = 4'b0111;
		           msm_state_c[U1] = 1'b1;
		        end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
		           dmw_cont_mask_c = 4'b0011;
		           msm_state_c[U2] = 1'b1;
		        end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
		           dmw_cont_mask_c = 4'b0001;
		           msm_state_c[U3] = 1'b1;
		        end
 		        default : begin 
		           msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
		   mdl_previous_tuple.phase[ONE] : begin
		      msm_emit_lit_c = 6'b10_0000;
		      unique case (2'b01)
			
			
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   dmw_cont_mask_c = 4'b0011;
			   msm_state_c[U2] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   dmw_cont_mask_c = 4'b0001;
			   msm_state_c[U3] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 

		   mdl_previous_tuple.phase[FOUR] : begin
		      msm_emit_lit_c = 6'b11_0000;
		      msm_adjust_gc_c = 1'b1;
		      unique case (2'b01)
			
                        mdl_previous_tuple.fwd_therm[6-:2]: begin
                           
			   dmw_cont_mask_c = 4'b0011;
			   msm_state_c[U2] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[7-:2]: begin
                           
			   dmw_cont_mask_c = 4'b0001;
			   msm_state_c[U3] = 1'b1;
			end
			
                        mdl_previous_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U4] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U7] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
 		   end
		 endcase 
	      end 
	   end 
	end 


	msm_state[C2] : begin
 	   inc_global_count_c       = 1'b1;
	   msm_continuing_c         = 1'b1;

	   if (!mdl_tuple.fwd_therm[11]) begin
	      
	      msm_update_saved_tuple_c = 1'b1;
	   end

	   if (mdl_f[TWO] || mdl_f[ONE] || mdl_f[FOUR]) begin
	      
	      
	      
	      msm_state_c[C2] = 1'b1;
	   end
	   else begin
	      
	      
	      

	      if (mdl_current_tuple_wins) begin

		 if (mdl_tuple.phase[ONE]) begin
		    msm_emit_lit_c = 6'b10_0000;
		 end
		 if (mdl_tuple.phase[FOUR]) begin
		    msm_emit_lit_c = 6'b11_0000;
		    msm_adjust_gc_c = 1'b1;
		 end
		 msm_emit_ptr_c = 1'b1;
		 
		 unique case (1'b1)
		   
		   
		   mdl_tuple.phase[TWO],mdl_tuple.phase[ONE],mdl_tuple.phase[FOUR] : begin
		      unique case (2'b01)
			
                        mdl_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U8] = 1'b1;
			end
                        mdl_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U9] = 1'b1;
			end
                        mdl_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U10] = 1'b1;
			end
                        mdl_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U11] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
 		   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
		   end
		 endcase 
	      end 
	      else begin
		 msm_emit_previous_ptr_c = 1'b1;

		 unique case (1'b1)
		   mdl_previous_tuple.phase[TWO] : begin
		      unique case (2'b01)
			
			mdl_previous_tuple.fwd_therm[7-:2]: begin
			   dmw_cont_mask_c = 4'b0001;
			   msm_state_c[U3] = 1'b1;
			end
			
                        mdl_previous_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U4] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   if (mdl_previous_is_2_back) begin
			      dmw_cont_mask_c = 4'b0001;
			      msm_state_c[U3] = 1'b1;
			   end
			   else begin
			      msm_state_c[U7] = 1'b1;
			   end
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
		   mdl_previous_tuple.phase[ONE] : begin
		      msm_emit_lit_c = 6'b10_0000;
		      unique case (2'b01)
			
                        mdl_previous_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U4] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U7] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
		   mdl_previous_tuple.phase[FOUR] : begin
		      msm_emit_lit_c = 6'b11_0000;
		      msm_adjust_gc_c = 1'b1;
		      unique case (2'b01)
			
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U7] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
 		   end
		 endcase 
	      end 
	   end 
	end 

	msm_state[UM1D] : begin
	   msm_shift_lits_c         = 1'b1;
	   inc_global_count_c       = 1'b1;
	   msm_continuing_c         = 1'b1;
	   msm_state_c[UM5]         = 1'b1;


	   
	   unique case (1'b1)
	     mdl_tuple.phase[FOUR] : begin
		if (msm_dmw[1]) begin 
		   if ({mdl_tuple.fwd_therm[11],mdl_tuple.fwd_therm[5]} == 2'b01) begin
                      
                      
                      
                      
                      
                      
		      msm_update_saved_tuple_c = 1'b1;
                   end
                   else begin
		      msm_update_saved_tuple_c = 1'b0;  
		   end 
                end 
	     end 
	     mdl_tuple.phase[THREE] : begin
		if (msm_dmw[0]) begin 
                   if ({mdl_tuple.fwd_therm[11],mdl_tuple.fwd_therm[6]} == 2'b01) begin
                     
                     
                     
                     
                     
		      msm_update_saved_tuple_c = 1'b1;
                   end
                   else begin
                      msm_update_saved_tuple_c = 1'b0;  
                   end 
		end 
             end 
	     default : msm_update_saved_tuple_c = 1'b0;  
	   endcase 
	end 
	

 	msm_state[UM5] : begin
 	   inc_global_count_c       = 1'b1;
	   msm_continuing_c         = 1'b1;

	   if (!mdl_tuple.fwd_therm[11]) begin
	      
	      msm_update_saved_tuple_c = 1'b1;
	   end

	   if (mdl_f[ONE] || mdl_f[FOUR] || mdl_f[THREE]) begin
	      
	      
	      
	      msm_state_c[C1] = 1'b1;
	   end
	   else begin
	      
	      
	      

	      if (mdl_current_tuple_wins) begin

		 if (mdl_tuple.phase[FOUR]) begin
		    msm_emit_lit_c = 6'b01_0000;
		    msm_adjust_gc_c = 1'b1;
		 end
		 if (mdl_tuple.phase[THREE]) begin
		    msm_emit_lit_c = 6'b01_1000;
		    msm_adjust_gc_c = 1'b1;
		 end
		 msm_emit_ptr_c = 1'b1;
		 
		 unique case (1'b1)

		   mdl_tuple.phase[ONE] : begin
		      unique case (2'b01)
			
                        mdl_tuple.fwd_therm[4-:2]: begin
                           
			   msm_state_c[U4] = 1'b1;
			end
                        mdl_tuple.fwd_therm[5-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_tuple.fwd_therm[6-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_tuple.fwd_therm[7-:2]: begin
                           
			   msm_state_c[U7] = 1'b1;
			end
			
                        mdl_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U8] = 1'b1;
			end
                        mdl_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U9] = 1'b1;
			end
                        mdl_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U10] = 1'b1;
			end
                        mdl_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U11] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
                   end 
		   
		   
		   mdl_tuple.phase[FOUR],mdl_tuple.phase[THREE] : begin
                      unique case (2'b01)
		        
                        mdl_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U8] = 1'b1;
		        end
                        mdl_tuple.fwd_therm[9-:2]: begin
                           
		           msm_state_c[U9] = 1'b1;
		        end
                        mdl_tuple.fwd_therm[10-:2]: begin
                           
		           msm_state_c[U10] = 1'b1;
		        end
                        mdl_tuple.fwd_therm[11-:2]: begin
                           
		           msm_state_c[U11] = 1'b1;
		        end
 		        default : begin 
		           msm_state_c[LZ_ERROR] = 1'b1;
 		           `CR_LZ77_COMP_ERROR;
 		        end
		      endcase 
                   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
		   end
		 endcase 
	      end 
	      else begin

		 msm_emit_previous_ptr_c = 1'b1;

		 unique case (1'b1)
		   mdl_previous_tuple.phase[ONE] : begin
		      unique case (2'b01)
			
			
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
			   dmw_cont_mask_c = 4'b0111;
			   msm_state_c[U1] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   dmw_cont_mask_c = 4'b0011;
			   msm_state_c[U2] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   dmw_cont_mask_c = 4'b0001;
			   msm_state_c[U3] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
		   mdl_previous_tuple.phase[FOUR] : begin
		      msm_emit_lit_c = 6'b01_0000;
		      msm_adjust_gc_c = 1'b1;
		      unique case (2'b01)
			
                        mdl_previous_tuple.fwd_therm[6-:2]: begin
                           
			   dmw_cont_mask_c = 4'b0011;
			   msm_state_c[U2] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[7-:2]: begin
                           
			   dmw_cont_mask_c = 4'b0001;
			   msm_state_c[U3] = 1'b1;
			end
			
                        mdl_previous_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U4] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U7] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
		   mdl_previous_tuple.phase[THREE] : begin
		      msm_emit_lit_c = 6'b01_1000;
		      msm_adjust_gc_c = 1'b1;
		      unique case (2'b01)
			
                        mdl_previous_tuple.fwd_therm[7-:2]: begin
                           
			   dmw_cont_mask_c = 4'b0001;
			   msm_state_c[U3] = 1'b1;
                        end
			
                        mdl_previous_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U4] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U7] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
                   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
		   end
		 endcase 
	      end 
	   end 
	end 
		   

		   
	msm_state[C1] : begin
 	   inc_global_count_c       = 1'b1;
	   msm_continuing_c         = 1'b1;

	   if (!mdl_tuple.fwd_therm[11]) begin
	      
	      msm_update_saved_tuple_c = 1'b1;
	   end

	   if (mdl_f[ONE] || mdl_f[FOUR] || mdl_f[THREE]) begin
	      
	      
	      
	      msm_state_c[C1] = 1'b1;
	   end
	   else begin
	      
	      
	      

	      if (mdl_current_tuple_wins) begin

		 if (mdl_tuple.phase[FOUR]) begin
		    msm_emit_lit_c  = 6'b01_0000;
		    msm_adjust_gc_c = 1'b1;
		 end
		 if (mdl_tuple.phase[THREE]) begin
		    msm_emit_lit_c  = 6'b01_1000;
		    msm_adjust_gc_c = 1'b1;
		 end
		 msm_emit_ptr_c = 1'b1;
		 
		 unique case (1'b1)
		   
		   
		   mdl_tuple.phase[ONE],mdl_tuple.phase[FOUR],mdl_tuple.phase[THREE] : begin
		      unique case (2'b01)
			
                        mdl_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U8] = 1'b1;
			end
                        mdl_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U9] = 1'b1;
			end
                        mdl_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U10] = 1'b1;
			end
                        mdl_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U11] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
                   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
		   end
		 endcase 
	      end 
	      else begin
		 
		 msm_emit_previous_ptr_c = 1'b1;

		 unique case (1'b1)
		   mdl_previous_tuple.phase[ONE] : begin
		      unique case (2'b01)
			
			mdl_previous_tuple.fwd_therm[7-:2]: begin
			   dmw_cont_mask_c = 4'b0001;
			   msm_state_c[U3] = 1'b1;
			end
			
                        mdl_previous_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U4] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   if (mdl_previous_is_2_back) begin
			      dmw_cont_mask_c = 4'b0001;
			      msm_state_c[U3] = 1'b1;
			   end
			   else begin
			      msm_state_c[U7] = 1'b1;
			   end
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 

		   mdl_previous_tuple.phase[FOUR] : begin
		      msm_emit_lit_c = 6'b01_0000;
		      msm_adjust_gc_c = 1'b1;
		      unique case (2'b01)
			
                        mdl_previous_tuple.fwd_therm[8-:2]: begin
                           
			   msm_state_c[U4] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U7] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 

		   mdl_previous_tuple.phase[THREE] : begin
		      msm_emit_lit_c = 6'b01_1000;
		      msm_adjust_gc_c = 1'b1;
		      unique case (2'b01)
			
                        mdl_previous_tuple.fwd_therm[9-:2]: begin
                           
			   msm_state_c[U5] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[10-:2]: begin
                           
			   msm_state_c[U6] = 1'b1;
			end
                        mdl_previous_tuple.fwd_therm[11-:2]: begin
                           
			   msm_state_c[U7] = 1'b1;
			end
 			default : begin 
			   msm_state_c[LZ_ERROR] = 1'b1;
 			   `CR_LZ77_COMP_ERROR;
 			end
		      endcase 
		   end 
 		   default : begin 
		      msm_state_c[LZ_ERROR] = 1'b1;
 		      `CR_LZ77_COMP_ERROR;
 		   end
		 endcase 
	      end 
	   end 
	end 
	
 	default : begin 
	   msm_state_c[LZ_ERROR] = 1'b1;
 	   `CR_LZ77_COMP_ERROR;
	   lz_error_c = 1'b1;
	end

      endcase 

   end 
   
   
   
   

   typedef struct {
      logic [8*8:1] phase;
      logic [8*8:1] fwd_therm;
      } tuple_string_t;
   
   msm_states_e   state_enum;
   tuple_string_t msm_tuple;
   tuple_string_t msm_previous_tuple;

   always @ (*) begin
      case (1'b1)
	msm_state[MSM_IDLE] : state_enum = MSM_IDLE;
	msm_state[U0]       : state_enum = U0;
	msm_state[U1]       : state_enum = U1;
	msm_state[U2]       : state_enum = U2;
	msm_state[U3]       : state_enum = U3;
	msm_state[UM1]      : state_enum = UM1;
	msm_state[UM2]      : state_enum = UM2;
	msm_state[U4]       : state_enum = U4;
	msm_state[U5]       : state_enum = U5;
	msm_state[U6]       : state_enum = U6;
	msm_state[U7]       : state_enum = U7;
	msm_state[U8]       : state_enum = U8;
	msm_state[U9]       : state_enum = U9;
	msm_state[U10]      : state_enum = U10;
	msm_state[U11]      : state_enum = U11;
	msm_state[UM4D]     : state_enum = UM4D;
	msm_state[UM4_1]    : state_enum = UM4_1;
	msm_state[UM4_2]    : state_enum = UM4_2;
	msm_state[UM8]      : state_enum = UM8;
	msm_state[C4]       : state_enum = C4;
	msm_state[UM3D]     : state_enum = UM3D;
	msm_state[UM3]      : state_enum = UM3;
	msm_state[UM7]      : state_enum = UM7;
	msm_state[C3]       : state_enum = C3;
	msm_state[UM2D]     : state_enum = UM2D;
	msm_state[UM6]      : state_enum = UM6;
	msm_state[C2]       : state_enum = C2;
	msm_state[UM1D]     : state_enum = UM1D;
	msm_state[UM5]      : state_enum = UM5;
	msm_state[C1]       : state_enum = C1;
	msm_state[LZ_ERROR] : state_enum = LZ_ERROR;
	default        : begin
	   if ((rst_n != 1'bx) && (rst_n != 1'b0)) begin
	      assert #0 (0)
		$display("NEVER HERE!"); 
	      else
		$error("LZ77_COMP_ERROR at time %0t", $time);
	   end
	end
      endcase 

      case (1'b1)
	mdl_tuple.phase == 4'b0 : msm_tuple.phase = "ZERO";
	mdl_tuple.phase[ONE]    : msm_tuple.phase = "ONE";
	mdl_tuple.phase[TWO]    : msm_tuple.phase = "TWO";
	mdl_tuple.phase[THREE]  : msm_tuple.phase = "THREE";
	mdl_tuple.phase[FOUR]   : msm_tuple.phase = "FOUR";
	default : msm_tuple.phase = "ERROR";
      endcase 
      case (1'b1)
	mdl_tuple.fwd_therm == 12'b000000000000 : msm_tuple.fwd_therm = "ZERO";
	mdl_tuple.fwd_therm == 12'b000000000001 : msm_tuple.fwd_therm = "ONE";
	mdl_tuple.fwd_therm == 12'b000000000011 : msm_tuple.fwd_therm = "TWO";
	mdl_tuple.fwd_therm == 12'b000000000111 : msm_tuple.fwd_therm = "THREE";
	mdl_tuple.fwd_therm == 12'b000000001111 : msm_tuple.fwd_therm = "FOUR";
	mdl_tuple.fwd_therm == 12'b000000011111 : msm_tuple.fwd_therm = "FIVE";
	mdl_tuple.fwd_therm == 12'b000000111111 : msm_tuple.fwd_therm = "SIX";
	mdl_tuple.fwd_therm == 12'b000001111111 : msm_tuple.fwd_therm = "SEVEN";
	mdl_tuple.fwd_therm == 12'b000011111111 : msm_tuple.fwd_therm = "EIGHT";
	mdl_tuple.fwd_therm == 12'b000111111111 : msm_tuple.fwd_therm = "NINE";
	mdl_tuple.fwd_therm == 12'b001111111111 : msm_tuple.fwd_therm = "TEN";
	mdl_tuple.fwd_therm == 12'b011111111111 : msm_tuple.fwd_therm = "ELEVEN";
	mdl_tuple.fwd_therm == 12'b111111111111 : msm_tuple.fwd_therm = "TWELVE";
	default : msm_tuple.fwd_therm = "ERROR";
      endcase


      case (1'b1)
	mdl_previous_tuple.phase == 4'b0 : msm_previous_tuple.phase = "ZERO";
	mdl_previous_tuple.phase[ONE]    : msm_previous_tuple.phase = "ONE";
	mdl_previous_tuple.phase[TWO]    : msm_previous_tuple.phase = "TWO";
	mdl_previous_tuple.phase[THREE]  : msm_previous_tuple.phase = "THREE";
	mdl_previous_tuple.phase[FOUR]   : msm_previous_tuple.phase = "FOUR";
	default : msm_previous_tuple.phase = "ERROR";
      endcase 
      case (1'b1)
	mdl_previous_tuple.fwd_therm == 12'b000000000000 : msm_previous_tuple.fwd_therm = "ZERO";
	mdl_previous_tuple.fwd_therm == 12'b000000000001 : msm_previous_tuple.fwd_therm = "ONE";
	mdl_previous_tuple.fwd_therm == 12'b000000000011 : msm_previous_tuple.fwd_therm = "TWO";
	mdl_previous_tuple.fwd_therm == 12'b000000000111 : msm_previous_tuple.fwd_therm = "THREE";
	mdl_previous_tuple.fwd_therm == 12'b000000001111 : msm_previous_tuple.fwd_therm = "FOUR";
	mdl_previous_tuple.fwd_therm == 12'b000000011111 : msm_previous_tuple.fwd_therm = "FIVE";
	mdl_previous_tuple.fwd_therm == 12'b000000111111 : msm_previous_tuple.fwd_therm = "SIX";
	mdl_previous_tuple.fwd_therm == 12'b000001111111 : msm_previous_tuple.fwd_therm = "SEVEN";
	mdl_previous_tuple.fwd_therm == 12'b000011111111 : msm_previous_tuple.fwd_therm = "EIGHT";
	mdl_previous_tuple.fwd_therm == 12'b000111111111 : msm_previous_tuple.fwd_therm = "NINE";
	mdl_previous_tuple.fwd_therm == 12'b001111111111 : msm_previous_tuple.fwd_therm = "TEN";
	mdl_previous_tuple.fwd_therm == 12'b011111111111 : msm_previous_tuple.fwd_therm = "ELEVEN";
	mdl_previous_tuple.fwd_therm == 12'b111111111111 : msm_previous_tuple.fwd_therm = "TWELVE";
	default : msm_previous_tuple.fwd_therm = "ERROR";
      endcase

   end
   


endmodule 




































































































