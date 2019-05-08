/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp_htf_blt (
   
   blt, blt_depth,
   
   clk, rst_n, blt_wdata, blt_wen, blt_start
   );

   parameter DEPTH = 576;
   parameter WIDTH = 5;
   parameter NUM_WR_PORTS = 2;
   parameter CLEAR_ON_FIRST_WRITE = 0;

   
   
   
   input         clk;
   input         rst_n; 

   input [`BIT_VEC(NUM_WR_PORTS)][`BIT_VEC(WIDTH)] blt_wdata;
   input [`LOG_VEC(NUM_WR_PORTS+1)]                blt_wen;
   input                   blt_start;
   
   output logic [`BIT_VEC(DEPTH)][`BIT_VEC(WIDTH)] blt;
   output logic [`LOG_VEC(DEPTH+1)]                blt_depth;

   logic [`LOG_VEC(DEPTH)]                         r_count, c_count;
   logic [`LOG_VEC(DEPTH+1)]                       r_blt_depth, c_blt_depth;
   
   logic [`BIT_VEC(((DEPTH+NUM_WR_PORTS-1)/NUM_WR_PORTS)*NUM_WR_PORTS)][`BIT_VEC(WIDTH)] r_blt, c_blt;

   assign blt = r_blt[`BIT_VEC(DEPTH)];
   assign blt_depth = r_blt_depth;

   `ASSERT_PROPERTY(blt_wen <= NUM_WR_PORTS) else `ERROR("can't write more than %0d bit lengths per cycle", NUM_WR_PORTS);


   always_comb begin
      logic [`BIT_VEC(NUM_WR_PORTS)] v_blt_wen_mask;
      logic [`LOG_VEC(DEPTH+1)]      v_next_count;

      c_blt = r_blt;
      c_count = r_count;
      c_blt_depth = r_blt_depth;

      if (blt_start) begin
         c_count = 0;
         if (CLEAR_ON_FIRST_WRITE!=0) 
           c_blt = '0;
      end

      v_blt_wen_mask = ~('1 << blt_wen);
      for (int i=0; i<NUM_WR_PORTS; i++) begin
         if (v_blt_wen_mask[i])
           c_blt[c_count + i] = blt_wdata[i]; 
      end

      v_next_count = (DEPTH+1)'(c_count + blt_wen);
      c_count = v_next_count;

      if (blt_wen != 0)
        c_blt_depth = v_next_count;
   end 

   always_ff@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         r_count <= 0;
         r_blt_depth <= 0;
      end
      else begin
         r_count <= c_count;
         r_blt_depth <= c_blt_depth;
      end
   end

   always_ff@(posedge clk) begin
      r_blt <= c_blt; 
   end

endmodule 








