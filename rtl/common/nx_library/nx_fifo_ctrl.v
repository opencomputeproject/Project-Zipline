/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "messages.vh"
`include "ccx_std.vh"

module nx_fifo_ctrl(
   
   empty, full, used_slots, free_slots, rptr, wptr, underflow,
   overflow,
   
   clk, rst_n, wen, ren, clear
   );

   
   parameter DEPTH = 6;
   parameter OVERFLOW_ASSERT = 1; 
   parameter UNDERFLOW_ASSERT = 1; 

   input     clk;
   input     rst_n;

   
   input     wen;
   input     ren;
   input     clear;

   output    empty;
   output    full;
   
   output [`LOG_VEC(DEPTH+1)] used_slots; 
   output [`LOG_VEC(DEPTH+1)] free_slots; 

   output [`LOG_VEC(DEPTH)]     rptr;
   output [`LOG_VEC(DEPTH)]     wptr;

   output logic               underflow;
   output logic               overflow;

   logic r_empty, c_empty;
   logic r_full, c_full;
   logic [`LOG_VEC(DEPTH+1)] r_used_slots, c_used_slots;
   logic [`LOG_VEC(DEPTH+1)] r_free_slots, c_free_slots;
   logic [`LOG_VEC(DEPTH)]     r_rptr, c_rptr;
   logic [`LOG_VEC(DEPTH)]     r_wptr, c_wptr;
   assign empty = r_empty;
   assign full = r_full;
   assign used_slots = r_used_slots;
   assign free_slots = r_free_slots;
   assign rptr = r_rptr;
   assign wptr = r_wptr;
         
   always_comb begin
      c_empty = r_empty;
      c_full = r_full;
      c_used_slots = r_used_slots;
      c_free_slots = r_free_slots;
      c_rptr = r_rptr;
      c_wptr = r_wptr;

      overflow = 0;
      underflow = 0;

      if (ren) begin
         
         c_full = 1'b0; 
         if (!empty) begin
            c_used_slots = r_used_slots - 1;
            c_free_slots = r_free_slots + 1;
            if (r_rptr == (DEPTH-1))
              c_rptr = '0;
            else
              c_rptr = r_rptr + 1;
            if (c_used_slots == '0) 
              c_empty = 1'b1; 
         end 
         else begin
            FIFO_UNDERFLOW: assert #0 (!UNDERFLOW_ASSERT) else `ERROR("fifo underflow"); 
            underflow = 1;
         end
      end
      
      if (wen) begin
         
         c_empty = 1'b0;
         if (!full) begin
            if (ren && !empty) begin
               c_used_slots = r_used_slots;
               c_free_slots = r_free_slots;
            end
            else begin
               c_used_slots = r_used_slots + 1;
               c_free_slots = r_free_slots - 1;
            end
            if (r_wptr == (DEPTH-1))
              c_wptr = '0;
            else
              c_wptr = r_wptr + 1;
            if (c_free_slots == '0) 
              c_full = 1'b1;
         end 
         else begin
            FIFO_OVERFLOW: assert #0 (!OVERFLOW_ASSERT) else `ERROR("fifo overflow");
            overflow = 1;
         end
      end 

      if (clear) begin
         c_empty = 1'b1;
         c_full = 1'b0;
         c_free_slots = DEPTH;
         c_used_slots = '0;
         c_rptr = '0;
         c_wptr = '0;
      end
   end 

   always@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         r_empty <= 1'b1;
         r_free_slots <= DEPTH;
         
         
         r_full <= 1'h0;
         r_rptr <= '0;
         r_used_slots <= '0;
         r_wptr <= '0;
         
      end
      else begin
         r_empty <= c_empty;
         r_full <= c_full;
         r_used_slots <= c_used_slots;
         r_free_slots <= c_free_slots;
         r_rptr <= c_rptr;
         r_wptr <= c_wptr;
      end
   end 

   genvar i;
   generate
      
      
      for (i=0; i<DEPTH; i+=(DEPTH-i+1)/2) begin: cover_depth 
         fifo_entries_reached_i: `COVER_PROPERTY(r_used_slots == i); 
      end
   endgenerate
   fifo_entries_reached_DEPTH: `COVER_PROPERTY(r_used_slots == DEPTH); 

endmodule 



