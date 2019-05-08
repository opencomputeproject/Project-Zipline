/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







































`include "ccx_std.vh"
`include "messages.vh"

module nx_lfsr
  #(parameter WIDTH=32,
    parameter [`BIT_VEC(WIDTH)] RESET={WIDTH{1'b1}},
    parameter [`BIT_VEC(WIDTH)] POLY='h0,
    parameter TEST=0)
   (input 		           clk,
    input 			   rst_n,
    input 			   enable,
    output logic [`BIT_VEC(WIDTH)] state);

   
   
   localparam [31:0] MAXIMAL_LENGTH_POLYS[33] 
     = {'h00000000,  
	'h00000000,  
	'h00000003,  
	'h00000006,  
	'h0000000C,  
	'h00000014,  
	'h00000030,  
	'h00000060,  
	'h000000B8,  
	'h00000110,  
	'h00000240,  
	'h00000500,  
	'h00000E08,  
	'h00001C80,  
	'h00003802,  
	'h00006000,  
	'h0000D008,  
	'h00012000,  
	'h00020400,  
	'h00072000,  
	'h00090000,  
	'h00140000,  
	'h00300000,  
	'h00420000,  
	'h00E10000,  
	'h01200000,  
	'h02000023,  
	'h04000013,  
	'h09000000,  
	'h14000000,  
	'h20000029,  
	'h48000000,  
	'h80200003}; 

   localparam [`BIT_VEC(WIDTH)] MY_POLY
     = ((POLY==0 && 
	 WIDTH<$size(MAXIMAL_LENGTH_POLYS)) ?
	MAXIMAL_LENGTH_POLYS[WIDTH] :
	POLY);
   
`ifndef SYNTHESIS
   initial begin : param_check

      if (RESET == 0)
	`FATAL("RESET value of zero will not lead to a functioning LFSR");

      if (MY_POLY == 0)
	`FATAL("POLY value of zero will not lead to a functioning LFSR");

      if (!MY_POLY[WIDTH-1])
	`FATAL("%db POLY value (%x) should have msb set", WIDTH, MY_POLY);
      
      if (WIDTH < 2)
	`FATAL("WIDTH less than two isn't particularly useful");

      if (TEST) begin
	 bit [`BIT_VEC(WIDTH)] period, state;

	 if (WIDTH>=30) begin
	    `WARN({"THIS EXHAUSTIVE POLYNOMIAL TEST WILL TAKE A LONG TIME!! ",
		   "SET TEST PARAMETER TO ZERO WHEN SATISFIED. ESTIMATE %d ",
		   "SECONDS TO COMPLETE. "}, 30.0*(1<<(WIDTH-30)));
	 end
	 
	 state = 1;
	 for (period=1; period<{WIDTH{1'b1}}; period++) begin
	    state = lfsr(state, MY_POLY);
	    if (state == 1)
	      `FATAL({"Selected polynomial does not provide for a maximal ",
		      "length LFSR, period is %x"}, period);
	 end
	   `INFO("Polynomial is maximal");
      end

   end : param_check
`endif

   function [`BIT_VEC(WIDTH)] lfsr (input [`BIT_VEC(WIDTH)] prev, poly);
      
      return ((prev >> 1) ^ {WIDTH{prev[0]}} & poly);
   endfunction : lfsr
   
   always @(posedge clk or negedge rst_n)
     if (!rst_n) 
	state <= RESET;
     else if (enable) 
	state <= lfsr(state, MY_POLY);

endmodule : nx_lfsr
