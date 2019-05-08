/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_huf_comp.vh"

module cr_huf_comp_min_bits
  (
   
   min_num, min_sel,
   
   ret, pre, sim
   );
   
`include "cr_structs.sv"
   
   import cr_huf_compPKG::*;
   import cr_huf_comp_regsPKG::*;
   
   input [`CREOLE_HC_BITS_WIDTH-1:0]         ret;
   input [`CREOLE_HC_BITS_WIDTH-1:0] 	     pre;
   input [`CREOLE_HC_BITS_WIDTH-1:0] 	     sim;
   output logic [`CREOLE_HC_BITS_WIDTH-1:0]  min_num;
   output e_min_enc 		             min_sel;
   
   always_comb
     begin
	min_num = 0;
	min_sel = RET;
	if ((ret < pre) && (ret < sim)) begin
	   min_num = ret;
	   min_sel = RET;
	end
	else if (pre < sim) begin
	   min_num = pre;
	   min_sel = PRE;
	end
	else begin
	   min_num = sim;
	   min_sel = SIM;
	end
     end
   
endmodule 










