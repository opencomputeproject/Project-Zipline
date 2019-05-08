/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

`include "cr_lz77_comp.vh"

function logic[4:0] 
  run_length (input [3:0] phase,
	      input [11:0] fwd_therm
	      );
   logic [15:0]            sum_terms;
   for (int i=0; i<12; i++)
     sum_terms[i] = fwd_therm[i];
   for (int i=12; i<16; i++)
     sum_terms[i] = |(phase>>(i-12));

   run_length = 0;
   for (int i=0; i<16; i++) begin
      run_length += sum_terms[i];
   end
   return run_length;
endfunction 




   
function logic[18:0] 
  shift_therm (
	       input [11:0] fwd_therm,
	       integer 	    shift
	       );
   logic [18:0] 	   shifted_therm;

   shifted_therm = {7'b0,fwd_therm};
   shifted_therm = ~shifted_therm;
   shifted_therm = shifted_therm << shift;
   shifted_therm = ~shifted_therm;

   return shifted_therm;
endfunction 
   
















































































































function logic[18:0] 
  expanded_fwd_therm (
		      input 	   is_mtf,
		      input [3:0]  phase,
		      input [11:0] fwd_therm
		      );
   
   logic [18:0] 		  exp_fwd_therm;
   integer 			  s;
   
   unique case (1'b1)
     phase[0] : begin 
	
	
        if (is_mtf)
          exp_fwd_therm = {fwd_therm,{4{1'b1}}};
        else
          exp_fwd_therm = {fwd_therm,1'b1};
     end 
     
     phase[1] : begin 
	
	
        if (is_mtf)
          exp_fwd_therm = {fwd_therm,{5{1'b1}}};
        else
          exp_fwd_therm = {fwd_therm,{2{1'b1}}};
     end 
     
     phase[2] : begin 
	
	
        if (is_mtf)
          exp_fwd_therm = {fwd_therm,{6{1'b1}}};
        else
          exp_fwd_therm = {fwd_therm,{3{1'b1}}};
     end 
     
     phase[3] : begin 
	
	
        if (is_mtf)
          exp_fwd_therm = {fwd_therm,{7{1'b1}}};
        else
          exp_fwd_therm = {fwd_therm,{4{1'b1}}};
     end 
     
     default : begin 
 	exp_fwd_therm = 19'b0;
     end

   endcase 

   return exp_fwd_therm;
endfunction 

function logic [7:0] byte_scramble(input [7:0] in);
   byte_scramble = 8'((in << 1) ^ 2) | 8'(^(in & 8'hb8));
endfunction 

