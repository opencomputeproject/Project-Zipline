/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp_htf_array_inc (
   
   array,
   
   clk, rst_n, preload_en, preload_data, inc_onehot
   );

   parameter RANGE_BASE = 1;
   parameter DEPTH = 27;
   parameter WIDTH = 10;
   parameter NUM_INC_PORTS = 2;
   
   
   
   
   input         clk;
   input         rst_n; 

   
   
   
   input logic [`BIT_VEC_BASE(DEPTH, RANGE_BASE)] preload_en;
   input logic [`BIT_VEC(WIDTH)]                  preload_data;      
   input logic [`BIT_VEC_BASE(DEPTH, RANGE_BASE)] inc_onehot[`BIT_VEC(NUM_INC_PORTS)];

   
   
   
   output logic [`BIT_VEC_BASE(DEPTH, RANGE_BASE)][`BIT_VEC(WIDTH)] array;
   
   

   
   
   
   
`define DECLARE_FLOP(name) r_``name, c_``name
`define DEFAULT_FLOP(name) c_``name = r_``name
`define UPDATE_FLOP(name) r_``name <= c_``name

   logic [`BIT_VEC_BASE(DEPTH, RANGE_BASE)][`BIT_VEC(WIDTH)]        `DECLARE_FLOP(array);
   assign array = r_array;
   
   always_comb begin
      `DEFAULT_FLOP(array);

      for (int j=RANGE_BASE; j<(DEPTH+RANGE_BASE); j++) begin
         
         if (preload_en[j])
           c_array[j] = preload_data;
         for (int i=0; i<NUM_INC_PORTS; i++) begin
            c_array[j] += WIDTH'(inc_onehot[i][j]); 
         end
      end
   end
   
   always_ff@(posedge clk) begin
      `UPDATE_FLOP(array); 
   end

`undef DECLARE_FLOP
`undef DEFAULT_FLOP
`undef UPDATE_FLOP

endmodule 







