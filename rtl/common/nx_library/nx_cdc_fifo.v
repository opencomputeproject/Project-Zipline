/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "nx_cdc_fifo_typePKG.svp"

module nx_cdc_fifo(
   
   free_slots, full, overflow, rdata, empty, used_slots, underflow,
   
   wclk, wrst_n, rclk, rrst_n, wen, wdata, ren
   );

   import nx_cdc_fifo_typePKG::*;

   parameter WIDTH=64;
   parameter DEPTH=16; 
   parameter OVERFLOW_ASSERT = 1; 
   parameter UNDERFLOW_ASSERT = 1; 
   
   
   
   
   
   
   
   parameter TYPE = SYNC;

   input     wclk;
   input     wrst_n;

   input     rclk;
   input     rrst_n;

   
   input                            wen;
   input [`BIT_VEC(WIDTH)]          wdata;
   output logic [`LOG_VEC(DEPTH+1)] free_slots; 
   output logic                     full;
   output logic                     overflow;

   
   input                            ren;
   output logic [`BIT_VEC(WIDTH)]   rdata;
   output logic                     empty;
   output logic [`LOG_VEC(DEPTH+1)] used_slots; 
   output logic                     underflow;

   logic [`LOG_VEC(DEPTH)]          rptr;
   logic [`LOG_VEC(DEPTH)]          wptr;

   nx_cdc_fifo_ctrl #(.DEPTH(DEPTH), .TYPE(TYPE), .OVERFLOW_ASSERT(OVERFLOW_ASSERT), .UNDERFLOW_ASSERT(UNDERFLOW_ASSERT)) 
   fifo_ctrl(
             
             .free_slots                (free_slots[`LOG_VEC(DEPTH+1)]),
             .full                      (full),
             .overflow                  (overflow),
             .empty                     (empty),
             .used_slots                (used_slots[`LOG_VEC(DEPTH+1)]),
             .underflow                 (underflow),
             .rptr                      (rptr[`LOG_VEC(DEPTH)]),
             .wptr                      (wptr[`LOG_VEC(DEPTH)]),
             
             .wclk                      (wclk),
             .wrst_n                    (wrst_n),
             .rclk                      (rclk),
             .rrst_n                    (rrst_n),
             .wen                       (wen),
             .ren                       (ren));
   
   

   logic [`BIT_VEC(DEPTH)][`BIT_VEC(WIDTH)] r_data;
   
   always@(posedge wclk) begin
      if (wen)
        r_data[wptr] <= wdata; 
   end
   
   

   
   
   assign rdata = empty ? 0 : r_data[rptr];
         
endmodule 
