/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/








`include "cr_lz77_comp.vh"

module cr_lz77_comp_snode
  #(
    parameter   T_WIDTH    = 4,  
    parameter   T_MASK     = 0,  
    parameter   OI_WIDTH   = 1   
    )
   (
   
   therm_out, offset_out,
   
   therm_in_0, therm_in_1, offset_in_0, offset_in_1
   );
   
   localparam  OI_ADJ_W   = (OI_WIDTH == 0) ? 1 : OI_WIDTH;   

   input [T_WIDTH-1:0]       therm_in_0;
   input [T_WIDTH-1:0]       therm_in_1;
   input [OI_ADJ_W-1:0]      offset_in_0;
   input [OI_ADJ_W-1:0]      offset_in_1;
   output reg [T_WIDTH-1:0]  therm_out;
   output [OI_WIDTH:0] 	     offset_out;
   
   localparam  T_MSB = T_WIDTH - T_MASK - 1;
   
   logic 			  sel;

   generate if (OI_WIDTH == 0) begin : zero_oi_width
      assign offset_out = sel ? 1'b1 : 1'b0;
   end
   else begin : nonzero_oi_width
      assign offset_out = sel ? {1'b1, offset_in_1} : {1'b0, offset_in_0};
   end
   endgenerate
   

   always @ (*) begin
      
      therm_out = therm_in_0 | therm_in_1;

      
      
      
      
      
      
      sel = |(~therm_in_0[T_MSB:0] & therm_in_1[T_MSB:0]);

   end

endmodule 







