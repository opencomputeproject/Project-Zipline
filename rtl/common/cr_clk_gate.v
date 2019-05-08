/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



module cr_clk_gate 
  (o,
   i0,
   i1,
   phi);

   output logic o;
   input 	i0;
   input 	i1;
   input 	phi;
   
   logic 	clk_en;
   logic 	latched_clk_en;
   
   always_comb begin
   
      clk_en = i0 | i1;
      
      if (phi == 1'b0)
	latched_clk_en = clk_en;
      else
	latched_clk_en = latched_clk_en;
      
      o = latched_clk_en & phi;
      
   end
   
endmodule