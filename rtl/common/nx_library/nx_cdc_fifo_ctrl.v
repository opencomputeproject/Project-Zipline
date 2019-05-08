/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "messages.vh"
`include "ccx_std.vh"
`include "nx_cdc_fifo_typePKG.svp"

module nx_cdc_fifo_ctrl(
   
   free_slots, full, overflow, empty, used_slots, underflow, rptr,
   wptr,
   
   wclk, wrst_n, rclk, rrst_n, wen, ren
   );

   import nx_cdc_fifo_typePKG::*;

   
   parameter DEPTH = 6;
   parameter OVERFLOW_ASSERT = 1; 
   parameter UNDERFLOW_ASSERT = 1; 
   
   
   
   
   
   
   parameter TYPE = SYNC;

   input     wclk;
   input     wrst_n;

   input     rclk;
   input     rrst_n;

   
   input                            wen;
   output logic [`LOG_VEC(DEPTH+1)] free_slots; 
   output logic                     full;
   output logic                     overflow;

   
   input                            ren;
   output logic                     empty;
   output logic [`LOG_VEC(DEPTH+1)] used_slots; 
   output logic                     underflow;

   output logic [`LOG_VEC(DEPTH)]     rptr;
   output logic [`LOG_VEC(DEPTH)]     wptr;

   localparam LOG_DEPTH = $clog2(DEPTH);

   
   initial begin
      if ((TYPE==ASYNC) && (2**LOG_DEPTH != DEPTH))
        `FATAL("can't support non-power-of-2 for async FIFO");
   end
   


   
   
   
   

   

   logic [`BIT_VEC(LOG_DEPTH+1)] c_wptr, r_wptr;
   logic [`BIT_VEC(LOG_DEPTH+1)]  wptr_sync;

   
   logic [`BIT_VEC(LOG_DEPTH+1)]  c_rptr, r_rptr;
   logic [`BIT_VEC(LOG_DEPTH+1)]  rptr_sync;

   function [`BIT_VEC(LOG_DEPTH+1)] binary_to_gray;
      input [`BIT_VEC(LOG_DEPTH+1)] binary;
      begin
         binary_to_gray = binary ^ (binary >> 1); 
      end
   endfunction
   
   function [`BIT_VEC(LOG_DEPTH+1)] gray_to_binary;
      input [`BIT_VEC(LOG_DEPTH+1)] gray;
      int                  shift;
      begin
         gray_to_binary = gray;
         for (shift=1; shift < (LOG_DEPTH+1); shift*=2)
           gray_to_binary ^= gray_to_binary >> shift; 
      end
   endfunction

   

   
   
   
   
   
   
   
   
   
   localparam WSYNC_RANKS  = (TYPE == SYNC) ? 0 :
                             (TYPE == SYNC_1_N) ? 1 :
                             (TYPE == SYNC_M_1) ? 0 :
                             (TYPE == SYNC_M_N) ? 1 :
                             2;

   nx_sync_flop #(.WIDTH(LOG_DEPTH+1), .RANKS(WSYNC_RANKS), .RESET_VAL(0)) rptr_synchrnonizer
     (.clk (wclk),
      .rst_n (wrst_n),
      .din (r_rptr),
      .dout (rptr_sync));


`define PTR_CONVERT(ptr) (ptr[`BIT_VEC($bits(ptr)-1)] + (ptr[$bits(ptr)-1]?DEPTH:0))
   always_comb begin
      logic [`BIT_VEC(LOG_DEPTH+1)] v_rptr_sync_bin;

      if (TYPE==ASYNC) begin 
         c_wptr = gray_to_binary(r_wptr);
         v_rptr_sync_bin = gray_to_binary(rptr_sync);
      end
      else begin
         c_wptr = r_wptr;
         v_rptr_sync_bin = rptr_sync;
      end
      
      wptr = c_wptr[`LOG_VEC(DEPTH)];
      
      if (v_rptr_sync_bin == (c_wptr^{1'b1, {LOG_DEPTH{1'b0}}}))
        full = 1'b1;
      else
        full = 1'b0;

      if (c_wptr < v_rptr_sync_bin)
        free_slots = `PTR_CONVERT(v_rptr_sync_bin) - `PTR_CONVERT(c_wptr) - DEPTH;
      else
        free_slots = `PTR_CONVERT(v_rptr_sync_bin) - `PTR_CONVERT(c_wptr) + DEPTH;

      overflow = 0;
      if (wen) begin
         if (!full) begin
            if (c_wptr[`BIT_VEC(LOG_DEPTH)] == (DEPTH-1))
              c_wptr = {~c_wptr[LOG_DEPTH], {LOG_DEPTH{1'b0}}}; 
            else
              c_wptr++;
         end
         else begin
            FIFO_OVERFLOW: assert #0 (!OVERFLOW_ASSERT) else `ERROR("fifo overflow");
            overflow = 1;
         end
      end
      if (TYPE==ASYNC) 
        c_wptr = binary_to_gray(c_wptr);
   end

   always@(posedge wclk or negedge wrst_n) begin
      if (!wrst_n) begin
         r_wptr <= 0;
      end
      else begin
         r_wptr <= c_wptr;
      end
   end

   
   
   
   
   
   
   
   
   
   
   
   localparam RSYNC_RANKS  = (TYPE == SYNC) ? 0 :
                             (TYPE == SYNC_1_N) ? 0 :
                             (TYPE == SYNC_M_1) ? 1 :
                             (TYPE == SYNC_M_N) ? 1 :
                             2;

   
   nx_sync_flop #(.WIDTH(LOG_DEPTH+1), .RANKS(RSYNC_RANKS), .RESET_VAL(0)) wptr_synchrnonizer
     (.clk (rclk),
      .rst_n (rrst_n),
      .din (r_wptr),
      .dout (wptr_sync));


   always_comb begin
      logic [`BIT_VEC(LOG_DEPTH+1)] v_wptr_sync_bin;

      if (TYPE==ASYNC) begin 
         c_rptr = gray_to_binary(r_rptr);
         v_wptr_sync_bin = gray_to_binary(wptr_sync);
      end
      else begin
         c_rptr = r_rptr;
         v_wptr_sync_bin = wptr_sync;
      end

      rptr = c_rptr[`LOG_VEC(DEPTH)];
      
      if (v_wptr_sync_bin == c_rptr)
        empty = 1'b1;
      else
        empty = 1'b0;

      if (v_wptr_sync_bin < c_rptr)
        used_slots = `PTR_CONVERT(v_wptr_sync_bin) - `PTR_CONVERT(c_rptr) + 2*DEPTH;
      else
        used_slots = `PTR_CONVERT(v_wptr_sync_bin) - `PTR_CONVERT(c_rptr);

      underflow = 0;
      if (ren) begin
         if (!empty) begin
            if (c_rptr[`BIT_VEC(LOG_DEPTH)] == (DEPTH-1))
              c_rptr = {~c_rptr[LOG_DEPTH], {LOG_DEPTH{1'b0}}}; 
            else
              c_rptr++;
         end
         else begin
            FIFO_UNDERFLOW: assert #0 (!UNDERFLOW_ASSERT) else `ERROR("fifo underflow");
            underflow = 1;
         end
      end 
      if (TYPE==ASYNC) 
        c_rptr = binary_to_gray(c_rptr);
   end

`undef PTR_CONVERT

   always@(posedge rclk or negedge rrst_n) begin
      if (!rrst_n) begin
         r_rptr <= 0;
      end
      else begin
         r_rptr <= c_rptr;
      end
   end

endmodule 


