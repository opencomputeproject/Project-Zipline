/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/















`include "cr_lz77_comp.vh"

module cr_lz77_comp_stree 
  #(
    parameter  GROUP_NUM  = 1,  
    parameter  OFFSETS    = 2,  
    parameter  T_WIDTH    = 4,  
    parameter  T_MASK     = 0,  
    parameter  OI_WIDTH   = 1   
    )
   (
   
   therm_out, offset_out,
   
   therm_in, offset_in
   );
   
   localparam LEVELS    = $clog2(OFFSETS);
   localparam OI_ADJ_W  = (OI_WIDTH == 0) ? 1 : OI_WIDTH;

   
   localparam OO_WIDTH  = LEVELS + OI_WIDTH;              


   input [GROUP_NUM-1:0][OFFSETS-1:0][T_WIDTH-1:0]  therm_in;
   input [GROUP_NUM-1:0][OFFSETS-1:0][OI_ADJ_W-1:0] offset_in;
   output [GROUP_NUM-1:0][T_WIDTH-1:0] 		    therm_out;
   output [GROUP_NUM-1:0][OO_WIDTH-1:0] 	    offset_out;
   
   
   genvar 			      lvl, n, grp;

   logic [GROUP_NUM-1:0][LEVELS-1:0][(OFFSETS/2)-1:0][OO_WIDTH-1:0] offset;
   logic [GROUP_NUM-1:0][LEVELS-1:0][(OFFSETS/2)-1:0][T_WIDTH-1:0]  therm;
   

   generate
      for (grp = 0; grp < GROUP_NUM; grp = grp + 1) begin : gen_grp_out
	 assign therm_out[grp] = therm[grp][LEVELS-1][0];
	 assign offset_out[grp] = offset[grp][LEVELS-1][0];
      end
   endgenerate
   

   
   generate
      for (grp = 0; grp < GROUP_NUM; grp = grp + 1) begin : gen_grp_lvl_0
	 for (n = 0; n < OFFSETS; n = n + 2) begin : gen_lvl_0
	    cr_lz77_comp_snode
		  #(
		    .T_WIDTH(T_WIDTH),
		    .T_MASK(T_MASK),
		    .OI_WIDTH(OI_WIDTH)
		    )
	    snode_0
		  (
		   .therm_in_0      (therm_in[grp][n]),
		   .therm_in_1      (therm_in[grp][n+1]),
		   .offset_in_0     (offset_in[grp][n]),
		   .offset_in_1     (offset_in[grp][n+1]),
		   .therm_out       (therm[grp][0][n/2]),
		   .offset_out      (offset[grp][0][n/2][OI_WIDTH:0])
		   );
	 end 
      end 
   endgenerate
   

   generate
      for (grp = 0; grp < GROUP_NUM; grp = grp + 1) begin : gen_grp

	 for (lvl = 1; lvl < LEVELS; lvl = lvl + 1) begin : gen_lvl
	    
	    for (n = 0; n < OFFSETS>>lvl; n = n + 2) begin : gen_n
	       
	       cr_lz77_comp_snode
		     #(
		       .T_WIDTH(T_WIDTH),
		       .T_MASK(T_MASK),
		       .OI_WIDTH(OI_WIDTH+lvl)
		       )
	       snode
		     (
		      .therm_in_0      (therm[grp][lvl-1][n]),
		      .therm_in_1      (therm[grp][lvl-1][n+1]),
		      .offset_in_0     (offset[grp][lvl-1][n][OI_WIDTH+lvl-1:0]),
		      .offset_in_1     (offset[grp][lvl-1][n+1][OI_WIDTH+lvl-1:0]),
		      .therm_out       (therm[grp][lvl][n/2]),
		      .offset_out      (offset[grp][lvl][n/2][OI_WIDTH+lvl:0])
		      );
	       
	    end 
	 end 
      end 
   endgenerate
   
endmodule 







