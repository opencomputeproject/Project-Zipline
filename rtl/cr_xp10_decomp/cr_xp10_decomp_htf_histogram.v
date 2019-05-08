/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp_htf_histogram (
   
   histogram,
   
   clk, rst_n, hist_waddr, hist_inc, hist_start
   );

   parameter DEPTH = 27;
   parameter WIDTH = 10;
   parameter NUM_INC_PORTS = 2;

   
   
   
   input         clk;
   input         rst_n; 
   
   input [`BIT_VEC(NUM_INC_PORTS)][`LOG_VEC(DEPTH+1)] hist_waddr;
   input [`LOG_VEC(NUM_INC_PORTS+1)]                  hist_inc;
   input                                              hist_start;

   output logic [`BIT_VEC_BASE(DEPTH, 1)][`BIT_VEC(WIDTH)] histogram;
   
   logic [`BIT_VEC_BASE(DEPTH, 1)] inc_onehot[`BIT_VEC(NUM_INC_PORTS)];

   `ASSERT_PROPERTY(hist_inc <= NUM_INC_PORTS) else `ERROR("can't increment more than %0d histogram entries per cycle", NUM_INC_PORTS);
   always_comb begin
      logic [`BIT_VEC(NUM_INC_PORTS)] v_hist_inc_therm;
      v_hist_inc_therm = ~({NUM_INC_PORTS{1'b1}} << hist_inc);
      
      for (int i=0; i<NUM_INC_PORTS; i++) begin
         inc_onehot[i] = '0;
         if (hist_waddr[i] != 0)
           inc_onehot[i][hist_waddr[i]] = v_hist_inc_therm[i]; 
      end
   end
   
   
   cr_xp10_decomp_htf_array_inc
     #(.DEPTH(DEPTH),
       .RANGE_BASE(1),
       .WIDTH(WIDTH),
       .NUM_INC_PORTS(NUM_INC_PORTS))
   u_histogram_array
     (
      
      .array                            (histogram),             
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .preload_en                       ({DEPTH{hist_start}}),   
      .preload_data                     ({WIDTH{1'b0}}),         
      .inc_onehot                       (inc_onehot));
              

endmodule 







