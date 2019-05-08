/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "messages.vh"

module cr_xp10_decomp_unpacker
  (
   
   src_ready, dst_items_avail, dst_data, dst_last,
   
   clk, rst_n, src_items_valid, src_data, src_last, dst_items_consume,
   clear
   );

   parameter IN_ITEMS = 64;
   parameter OUT_ITEMS = 16;
   parameter MAX_CONSUME_ITEMS = 16;
   parameter BITS_PER_ITEM = 1;

   
   
   
   input         clk;
   input         rst_n; 
   
   input [`LOG_VEC(IN_ITEMS+1)]             src_items_valid;
   output logic                             src_ready;
   input [`BIT_VEC(IN_ITEMS*BITS_PER_ITEM)] src_data;
   input                                    src_last;
   
   output logic [`LOG_VEC(OUT_ITEMS+1)]             dst_items_avail;
   input [`LOG_VEC(MAX_CONSUME_ITEMS+1)]            dst_items_consume;
   output logic [`BIT_VEC(OUT_ITEMS*BITS_PER_ITEM)] dst_data;
   output logic                                     dst_last;
   
   input                                            clear;
   
   localparam OUT_WIDTH = OUT_ITEMS*BITS_PER_ITEM;
   localparam SHIFT_ITEMS = MAX_CONSUME_ITEMS+OUT_ITEMS+IN_ITEMS; 
   localparam SHIFT_WIDTH = SHIFT_ITEMS*BITS_PER_ITEM;
   localparam ITEMS_VALID_WIDTH = $clog2(SHIFT_ITEMS+1);
   
   
   
`define DECLARE_RESET_FLOP(name, reset_val) \
   r_``name, c_``name; \
   always_ff@(posedge clk or negedge rst_n)    \
     if (!rst_n) \
       r_``name <= reset_val; \
     else \
       r_``name <= c_``name
`define DECLARE_FLOP(name) \
   r_``name, c_``name; \
   always_ff@(posedge clk) r_``name <= c_``name 
`define DEFAULT_FLOP(name) c_``name = r_``name

   logic [`BIT_VEC(SHIFT_WIDTH)]    `DECLARE_FLOP(shiftreg);
   logic [`LOG_VEC(SHIFT_ITEMS+1)]  `DECLARE_RESET_FLOP(total_items_valid, 0);
   logic [1:0]                      `DECLARE_RESET_FLOP(num_last, 0);
   logic [`LOG_VEC(SHIFT_ITEMS+1)]  `DECLARE_RESET_FLOP(items_valid_till_last[1:0], '{default: 0});
   
   assign dst_data = r_shiftreg[`BIT_VEC(OUT_WIDTH)];
   assign dst_items_avail = (r_items_valid_till_last[0] >= ITEMS_VALID_WIDTH'(OUT_ITEMS)) ? OUT_ITEMS : r_items_valid_till_last[0];
   assign dst_last = (r_num_last != 0) && (r_items_valid_till_last[0] <= ITEMS_VALID_WIDTH'(OUT_ITEMS));
   
   always_comb begin
      `DEFAULT_FLOP(shiftreg);
      `DEFAULT_FLOP(total_items_valid);
      `DEFAULT_FLOP(num_last);
      `DEFAULT_FLOP(items_valid_till_last);


      
      
      

      
      
      

      
      if ((r_total_items_valid + src_items_valid <= SHIFT_ITEMS) && (r_num_last<2))
        src_ready = 1;
      else
        src_ready = 0;

      if ((src_items_valid != 0) && src_ready) begin
         c_total_items_valid  += src_items_valid; 
         c_items_valid_till_last[r_num_last] += src_items_valid; 
         
         if (src_last)
           c_num_last = r_num_last + 1;
      end

      
      
      c_shiftreg = SHIFT_WIDTH'(src_data << (r_total_items_valid*BITS_PER_ITEM)) | SHIFT_WIDTH'(~SHIFT_WIDTH'('1 << (r_total_items_valid*BITS_PER_ITEM)) & r_shiftreg); 
      
      
      
      c_items_valid_till_last[0] -= dst_items_consume; 
      if (dst_items_consume != 0) begin
         if (r_num_last != 0) begin
            if (ITEMS_VALID_WIDTH'(dst_items_consume) == r_items_valid_till_last[0]) begin
               
               c_num_last = c_num_last - 1;
               c_items_valid_till_last[0] = c_items_valid_till_last[1];
               c_items_valid_till_last[1] = 0;
            end
         end
      end

      c_total_items_valid -= dst_items_consume; 

      c_shiftreg >>= dst_items_consume*BITS_PER_ITEM; 
      
      if (clear) begin
         c_total_items_valid = '0;
         c_items_valid_till_last = '{default:0};
         c_num_last = '0;
      end
   end

   `ASSERT_PROPERTY($bits(dst_items_avail)'(dst_items_consume) <= dst_items_avail) else `ERROR("can't consume more items than available: avail=%0d, consume=%0d", dst_items_avail, dst_items_consume);

`undef DECLARE_RESET_FLOP
`undef DECLARE_FLOP
`undef DEFAULT_FLOP


endmodule 


