/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
















`include "cr_lz77_comp.vh"
`include "ccx_std.vh"

module cr_lz77_comp_lpo_xN_negedge
  #(parameter OFFSETS_PER_LPO = 8)
   (
    
   
   prev_sel_offset, lpo_ti_valid_phase, lpo_ti_fwd_therm,
   lpo_ti_offset, lpo_ti_len4_ind, lpo_ti_len5_6_ind,
   
   clk, input_en, ti_lpo_cont, ti_lpo_cont_r, ti_lpo_dmw_cont,
   prev_sel_offset_bm, best_new_offset, best_new_offset_bm
   );

   input                                      clk;
   
   
   input                                      input_en;
   
   
   input                                      ti_lpo_cont;
   input                                      ti_lpo_cont_r;
   input [3:0]                                ti_lpo_dmw_cont;
   
   output logic [$clog2(OFFSETS_PER_LPO)-1:0] prev_sel_offset;
   input [3:0]                                prev_sel_offset_bm;
   input [$clog2(OFFSETS_PER_LPO)-1:0]        best_new_offset;
   input [3:0]                                best_new_offset_bm;

   
   
   output logic [3:0]                         lpo_ti_valid_phase;  
   output logic [11:0]                        lpo_ti_fwd_therm;    
   output [$clog2(OFFSETS_PER_LPO)-1:0]       lpo_ti_offset;
   output [3:0]                               lpo_ti_len4_ind;
   output [2:0]                               lpo_ti_len5_6_ind;
   
   
`ifdef SHOULD_BE_EMPTY
   
      
`endif

   localparam LOG_OFFPL = $clog2(OFFSETS_PER_LPO);

   
   
   
   
   
   
   
   
   typedef enum 			    logic[1:0] {
							ONGOING_NEW    = 2'b00,
							ENTERING_CONT  = 2'b10,
							ONGOING_CONT   = 2'b11,
							ENTERING_NEW   = 2'b01
							} lpo_state_t;
   lpo_state_t state;
   
   logic [3:0][LOG_OFFPL-1:0]               offset_sel;
   logic [LOG_OFFPL-1:0]                    c_offset_sel_0;
   logic [LOG_OFFPL-1:0]                    offset_sel_negedge;
   logic [11:0] 			    bm_this_offset;
   logic [11:0] 			    bm_this_group;
   logic [3:0]                              c_bm_this_group;
   logic [3:0]                              bm_this_group_negedge;
   logic [1:0] 				    bkwd_from12_phase;
   logic [1:0] 				    next_bkwd_from12_phase;
   logic [1:0] 				    bkwd_from12_quads;
   logic [1:0] 				    next_bkwd_from12_quads;
   logic [3:0] 				    lpo_phase;
   logic 				    phase_is_zero;
   logic 				    phase_is_q1;
   logic 				    phase_is_q2;
   logic 				    phase_is_q3;
   logic 				    bkwd_from12_phase_3or2;
   
   

   


   
   
   

   assign lpo_ti_len4_ind[3]   =  (&bm_this_group[7:4]);   
   assign lpo_ti_len4_ind[2]   =  (&bm_this_group[6:3]) && (offset_sel[1] == offset_sel[0]);
   assign lpo_ti_len4_ind[1]   =  (&bm_this_group[5:2]) && (offset_sel[1] == offset_sel[0]);
   assign lpo_ti_len4_ind[0]   =  (&bm_this_group[4:1]) && (offset_sel[1] == offset_sel[0]);
   assign lpo_ti_len5_6_ind[2] =  (&bm_this_group[7:2]) && (offset_sel[1] == offset_sel[0]);  
   assign lpo_ti_len5_6_ind[1] =  (&bm_this_group[7:3]) && (offset_sel[1] == offset_sel[0]);  
   assign lpo_ti_len5_6_ind[0] =  (&bm_this_group[6:2]) && (offset_sel[1] == offset_sel[0]);  

   assign lpo_ti_offset = offset_sel[3];

   assign prev_sel_offset = offset_sel_negedge;

   always_ff@(posedge clk) begin
      if (input_en) begin
         
         
         
         bm_this_group[11:4] <= bm_this_group[7:0];
         offset_sel[3] <= offset_sel[2];
         offset_sel[2] <= offset_sel[1];
         offset_sel[1] <= offset_sel[0];
      end
   end

   always_comb begin
      
      if ( 
	   
	   &{bm_this_group_negedge[0 +: 3], prev_sel_offset_bm[3 -: 1]} ||
	   &{bm_this_group_negedge[0 +: 2], prev_sel_offset_bm[3 -: 2]} ||
	   &{bm_this_group_negedge[0 +: 1], prev_sel_offset_bm[3 -: 3]}
	   ) begin
         
         c_offset_sel_0 = offset_sel[0];
         c_bm_this_group = prev_sel_offset_bm;
      end
      else begin
         c_offset_sel_0 = best_new_offset;
         c_bm_this_group = best_new_offset_bm;
      end 
   end 

   always_ff@(negedge clk) begin
      offset_sel_negedge <= c_offset_sel_0;
      bm_this_group_negedge <= c_bm_this_group;
   end

   always_ff@(posedge clk) begin
      offset_sel[0] <= offset_sel_negedge;
      bm_this_group[3:0] <= bm_this_group_negedge;
   end
   
   always_comb begin
      
      
      
      
      
      bm_this_offset[11:8] = (offset_sel[3] == offset_sel[2]) ? 
			     bm_this_group[11:8] : 4'b0;
      
      bm_this_offset[7:4]  = ((offset_sel[3] == offset_sel[2]) &&
			      (offset_sel[2] == offset_sel[1])) ? 
			     bm_this_group[7:4] : 4'b0;
      
      
      bm_this_offset[3:0]  = ((offset_sel[3] == offset_sel[2]) &&
			      (offset_sel[2] == offset_sel[1]) && 
			      (offset_sel[1] == offset_sel[0])) ? 
			     bm_this_group[3:0] : 4'b0;

   end 

   fwd_therm_gen u_fwd_therm_gen (.bm_this_offset(bm_this_offset), .fwd_therm(lpo_ti_fwd_therm));
   
   always_comb begin
      phase_is_zero = 1'b0;
      phase_is_q1   = 1'b0;
      phase_is_q2   = 1'b0;
      phase_is_q3   = 1'b0;
      if ({bkwd_from12_quads,bkwd_from12_phase} == 4'b0)
	phase_is_zero = 1'b1;
      else if ({bkwd_from12_quads,bkwd_from12_phase} < 5)
	phase_is_q1 = 1'b1;
      else if ({bkwd_from12_quads,bkwd_from12_phase} < 9)
	phase_is_q2 = 1'b1;
      else
	phase_is_q3 = 1'b1;


      bkwd_from12_phase_3or2 = (bkwd_from12_phase == 2'd3) || 
			       (bkwd_from12_phase == 2'd2);

      
      
      
      
      state = lpo_state_t'({ti_lpo_cont, ti_lpo_cont_r});
      
      
      next_bkwd_from12_quads = 2'd0;
      next_bkwd_from12_phase = 2'd0;

      case (bkwd_from12_phase)
	2'b01 : lpo_phase = 4'b0001;
	2'b10 : lpo_phase = 4'b0010;
	2'b11 : lpo_phase = 4'b0100;
	2'b00 : lpo_phase = 4'b1000;
      endcase 
      
      case (state)
	
        ONGOING_NEW : begin
	   
	   
	   
	   if (phase_is_zero) begin
	      lpo_phase = 4'b0000;
	   end
	   else if (|bkwd_from12_quads) begin
	     lpo_phase = 4'b1000;
	   end

	   if (phase_is_zero) begin
	      next_bkwd_from12_phase = phase_based_on_11to8(bm_this_group[11:8]);
	      next_bkwd_from12_quads = quad_based_on_11to8(bm_this_group[11:8]);
	   end
	   
	   
	   
	   else if (phase_is_q1) begin
	      if (lpo_ti_fwd_therm[11]) begin
		 
		 next_bkwd_from12_phase = bkwd_from12_phase;     
		 next_bkwd_from12_quads = bkwd_from12_quads + 1; 
	      end
	      else begin
		 next_bkwd_from12_phase = phase_based_on_11to8(bm_this_group[11:8]);
		 next_bkwd_from12_quads = quad_based_on_11to8(bm_this_group[11:8]);
	      end
	   end 
 	   
 	   
 	   
 	   else if (phase_is_q2) begin
 	      next_bkwd_from12_phase = bkwd_from12_phase;     
 	      next_bkwd_from12_quads = bkwd_from12_quads + 1; 
 	   end
 	   
 	   
 	   
 	   else begin
	      if (&bm_this_offset[7:4]) begin
 		 next_bkwd_from12_phase = 2'b00;             
 		 next_bkwd_from12_quads = 2'd3;              
	      end
	      else begin
		 next_bkwd_from12_phase = phase_based_on_11to8(bm_this_group[11:8]);
		 next_bkwd_from12_quads = quad_based_on_11to8(bm_this_group[11:8]);
	      end
 	   end
	end 
	

        ENTERING_CONT : begin
	   if (phase_is_zero || phase_is_q1) begin
	      
	      lpo_phase              = 4'b0000;
	      next_bkwd_from12_phase = phase_based_on_11to8(bm_this_group[11:8]);
	      next_bkwd_from12_quads = quad_based_on_11to8(bm_this_group[11:8]);
	   end
	   else begin

	     case (1'b1)

	       
	       
	       
	       
	       ti_lpo_dmw_cont[3]: begin
		  if (
		      (bkwd_from12_quads == 2'd3) ||
		      ((bkwd_from12_quads == 2'd2) && (bkwd_from12_phase_3or2))
		      ) begin
		     
		     next_bkwd_from12_quads = bkwd_from12_quads;
		     next_bkwd_from12_phase = bkwd_from12_phase;
		  end
		  else begin
		     
		     
		     lpo_phase              = 4'b0000;
		     next_bkwd_from12_phase = phase_based_on_11to8(bm_this_group[11:8]);
		     next_bkwd_from12_quads = quad_based_on_11to8(bm_this_group[11:8]);
		  end
	       end
	       
	       
	       
	       
	       
	       ti_lpo_dmw_cont[2]: begin
		  if (bkwd_from12_quads == 3) begin
		     
		     lpo_phase = 4'b0100;
		     next_bkwd_from12_phase = 2'd3;
		     next_bkwd_from12_quads = 2'd2;
		  end
		  else if ((bkwd_from12_quads == 2) && (|bkwd_from12_phase)) begin
		     
		     next_bkwd_from12_quads = bkwd_from12_quads;
		     next_bkwd_from12_phase = bkwd_from12_phase;
		  end
		  else begin
		     
		     lpo_phase              = 4'b0000;
		     next_bkwd_from12_phase = phase_based_on_11to8(bm_this_group[11:8]);
		     next_bkwd_from12_quads = quad_based_on_11to8(bm_this_group[11:8]);
		  end 
	       end 

	       
	       
	       
	       
	       ti_lpo_dmw_cont[1]: begin
		  if ( (bkwd_from12_quads == 2'd3) ||
		       ((bkwd_from12_quads == 2'd2) && (bkwd_from12_phase == 2'd3))
		       ) begin
		     
		     lpo_phase = 4'b0010;
		     next_bkwd_from12_phase = 2'd2;
		     next_bkwd_from12_quads = 2'd2;
		  end
		  else if (bkwd_from12_quads == 2) begin
		     
		     next_bkwd_from12_quads = bkwd_from12_quads;
		     next_bkwd_from12_phase = bkwd_from12_phase;
		  end
		  else begin
		     
		     lpo_phase              = 4'b0000;
		     next_bkwd_from12_phase = phase_based_on_11to8(bm_this_group[11:8]);
		     next_bkwd_from12_quads = quad_based_on_11to8(bm_this_group[11:8]);
		  end 
	       end 
	       
	       
	       
	       
	       
	       
	       ti_lpo_dmw_cont[0]: begin     
		  if (bkwd_from12_quads == 2'd3) begin
		     
		     lpo_phase = 4'b0001;
		     next_bkwd_from12_phase = 2'd1;
		     next_bkwd_from12_quads = 2'd2;
		  end
		  else if ((bkwd_from12_quads == 2'd2) && bkwd_from12_phase_3or2) begin
		     
		     lpo_phase = 4'b0001;
		     next_bkwd_from12_phase = 2'd1;
		     
		     next_bkwd_from12_quads = bkwd_from12_quads;
		  end
		  else if ((bkwd_from12_quads == 2'd2) ||
			   (bkwd_from12_quads == 2'd1) && (bkwd_from12_phase == 2'd3)
			   ) begin
		     
		     next_bkwd_from12_quads = bkwd_from12_quads;
		     next_bkwd_from12_phase = bkwd_from12_phase;
		  end
		  else begin
		     
		     lpo_phase              = 4'b0000;
		     next_bkwd_from12_phase = phase_based_on_11to8(bm_this_group[11:8]);
		     next_bkwd_from12_quads = quad_based_on_11to8(bm_this_group[11:8]);
		  end 
	       end 

	       default : begin 
 		  `CR_LZ77_COMP_ERROR; 
	       end
	     endcase 
	   end 
	end 
	
        ONGOING_CONT : begin
	   if (phase_is_q2 || phase_is_q3) begin
	      if (lpo_ti_fwd_therm[8]) begin
		 
		 next_bkwd_from12_quads = bkwd_from12_quads;
		 next_bkwd_from12_phase = bkwd_from12_phase;
	      end
	      else begin
		 
		 next_bkwd_from12_phase = phase_based_on_11to8(bm_this_group[11:8]);
		 next_bkwd_from12_quads = quad_based_on_11to8(bm_this_group[11:8]);
	      end 
	   end 
	   else begin
	      
	      lpo_phase = 4'b0000;
	      next_bkwd_from12_phase = phase_based_on_11to8(bm_this_group[11:8]);
	      next_bkwd_from12_quads = quad_based_on_11to8(bm_this_group[11:8]);
	   end 
	end 

	ENTERING_NEW : begin
	   if (phase_is_q3 || phase_is_q2) begin
	      if (lpo_ti_fwd_therm[11]) begin
		 
		 
		 
		 next_bkwd_from12_phase = 2'd0;
		 next_bkwd_from12_quads = 2'd2;
		 lpo_phase = 4'b1000;
	      end
	      else begin
		 
		 
		 lpo_phase = 4'b1000;
		 next_bkwd_from12_phase = phase_based_on_11to8(bm_this_group[11:8]);
		 next_bkwd_from12_quads = quad_based_on_11to8(bm_this_group[11:8]);
	      end 
	   end 
	   else if (phase_is_q1) begin
	      if (lpo_ti_fwd_therm[11]) begin
		 
		 
		 next_bkwd_from12_phase = bkwd_from12_phase;     
		 next_bkwd_from12_quads = bkwd_from12_quads + 1; 
	      end
	      else begin
		 
		 next_bkwd_from12_phase = phase_based_on_11to8(bm_this_group[11:8]);
		 next_bkwd_from12_quads = quad_based_on_11to8(bm_this_group[11:8]);
	      end 
	   end 
	   else begin
	      
	      lpo_phase = 4'b0000;
	      next_bkwd_from12_phase = phase_based_on_11to8(bm_this_group[11:8]);
	      next_bkwd_from12_quads = quad_based_on_11to8(bm_this_group[11:8]);
	   end 

	end 

      endcase 
      
      

      lpo_ti_valid_phase = lpo_phase;

   end 

      
   always_ff @ (posedge clk) begin
      if (input_en) begin
	 bkwd_from12_quads <= next_bkwd_from12_quads;
         bkwd_from12_phase <= next_bkwd_from12_phase;
      end
   end



   
   
   
   function logic [1:0] 
     phase_based_on_11to8 (input [3:0] bm_11to8);
      logic [1:0] phase;
      casez (bm_11to8)
	4'b1111: phase = 2'b00; 
	4'b0111: phase = 2'b11; 
	4'b?011: phase = 2'b10; 
	4'b??01: phase = 2'b01; 
	default: phase = 2'b00; 
      endcase 
      return phase;
   endfunction 
   

   function logic [1:0]
     quad_based_on_11to8 (input [3:0] bm_11to8);
      logic [1:0] quad;
      quad = &bm_11to8 ? 2'd1 : 2'd0;
      return quad;
   endfunction 

   
endmodule 

module fwd_therm_gen(bm_this_offset, fwd_therm);

   input [11:0] bm_this_offset;
   output [11:0] fwd_therm;
   
   
   assign fwd_therm = {&bm_this_offset[11 -: 12],
		       &bm_this_offset[11 -: 11],
		       &bm_this_offset[11 -: 10],
		       &bm_this_offset[11 -: 9],
		       &bm_this_offset[11 -: 8],
		       &bm_this_offset[11 -: 7],
		       &bm_this_offset[11 -: 6],
		       &bm_this_offset[11 -: 5],
		       &bm_this_offset[11 -: 4],
		       &bm_this_offset[11 -: 3],
		       &bm_this_offset[11 -: 2],
		       &bm_this_offset[11 -: 1]};

endmodule 

