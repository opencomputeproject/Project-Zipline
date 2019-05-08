/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

































module nx_dpram
   (
   
   douta, doutb,
   
   clka, clkb, bwea, bweb, dina, dinb, adda, addb, csa, csb, wea, web
   );

   parameter DW        = 64;         
   parameter AW        = 8;          
   parameter NW        = (1 << AW);  
   
   input                  clka; 
   input 		  clkb; 
   
   input [DW-1:0] 	  bwea; 
   input [DW-1:0] 	  bweb; 
   input [DW-1:0] 	  dina; 
   input [DW-1:0] 	  dinb; 
   input [AW-1:0] 	  adda; 
   input [AW-1:0] 	  addb; 
   input 		  csa; 
   input 		  csb; 
   input 		  wea; 
   input 		  web;
   
   output [DW-1:0] 	  douta; 
   output [DW-1:0] 	  doutb; 
   
   
   reg [AW-1:0]    adda_r; 
   reg [AW-1:0]    addb_r; 

`ifdef SYNTH
 `define MEM mem
   reg [DW-1:0]    mem[NW-1:0];
`else
   
   
   
 `define MEM ram.array
   an_array #(DW, NW) ram ();
`endif
   
   always @(posedge clka) begin
      if (csa && !wea) 
	 adda_r <= adda;
      else
	 adda_r <= {AW{1'bx}};
	 
      if (csa && wea) 
	 `MEM[adda] <= `MEM[adda] & ~bwea | dina & bwea;
   end 

   wire [DW-1:0] douta = `MEM[adda_r]; 
   
   always @(posedge clkb) begin
      if (csb && !web) 
	 addb_r <= addb;
      else
	 addb_r <= {AW{1'bx}};
      
      if (csb && web) 
	 `MEM[addb] <= `MEM[addb] & ~bweb | dinb & bweb;
   end 

   wire [DW-1:0] doutb = `MEM[addb_r]; 
   
endmodule 

