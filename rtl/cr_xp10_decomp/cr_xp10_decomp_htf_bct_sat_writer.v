/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp_htf_bct_sat_writer (
   
   bct_sat_wen, bct_sat_addr, bct_sat_last, bct_valid, bct_data,
   sat_data, bct_sat_error,
   
   clk, rst_n, hist_complete, hist_depth, histogram
   );

   parameter MAX_DEPTH = 27;
   parameter WIDTH = 10;
   
   
   
   input         clk;
   input         rst_n; 

   input                                                hist_complete;
   input [`LOG_VEC(MAX_DEPTH+1)]                        hist_depth;
   input [`BIT_VEC_BASE(MAX_DEPTH, 1)][`BIT_VEC(WIDTH)] histogram;
   
   
   
   
   output logic                         bct_sat_wen;
   output logic [`LOG_VEC(MAX_DEPTH+1)] bct_sat_addr;
   output logic                         bct_sat_last;
   output logic                         bct_valid;
   output logic [`BIT_VEC(MAX_DEPTH-1)] bct_data;
   output logic [`BIT_VEC(WIDTH)]       sat_data;
   
   output logic                         bct_sat_error;

   
   
   
   
   
`define DECLARE_FLOP(name) r_``name, c_``name
`define DEFAULT_FLOP(name) c_``name = r_``name
`define UPDATE_FLOP(name) r_``name <= c_``name

   enum logic {IDLE=0, WRITE=1}  `DECLARE_FLOP(state);
   logic [`LOG_VEC(MAX_DEPTH+1)] `DECLARE_FLOP(index);
   logic [`BIT_VEC(MAX_DEPTH)]   `DECLARE_FLOP(prev_bct);
   logic [`BIT_VEC(WIDTH)]       `DECLARE_FLOP(prev_sat);

   logic [`BIT_VEC(MAX_DEPTH+1)][`BIT_VEC(WIDTH)] histogram_0base;
   assign histogram_0base = {histogram, {WIDTH{1'b0}}};

   always_comb begin
      `DEFAULT_FLOP(state);
      `DEFAULT_FLOP(index);
      `DEFAULT_FLOP(prev_bct);
      `DEFAULT_FLOP(prev_sat);

      bct_sat_wen = 0;
      bct_valid = 0;
      bct_sat_addr = r_index;
      bct_sat_last = 0;
      bct_sat_error = 0;
      case (r_state)
        IDLE: begin
           if (hist_complete) begin
              c_state = WRITE;
              c_index = 1;
              c_prev_bct = 0;
              c_prev_sat = 0;
           end
        end
        WRITE: begin
           bct_sat_wen = 1;
           
           bct_valid = histogram_0base[r_index] != 0;
           c_prev_bct = MAX_DEPTH'({r_prev_bct, 1'b0} + {histogram_0base[r_index-1], 1'b0});
           c_prev_sat = WIDTH'(r_prev_sat + histogram_0base[r_index-1]);
           if (bct_valid && |((MAX_DEPTH+1)'(({r_prev_bct, 1'b0} + {histogram_0base[r_index-1], 1'b0} + histogram_0base[r_index] - 1) >> r_index))) begin
              
              bct_sat_error = 1;
              c_state = IDLE;
           end
           

           c_index = r_index+1;
           if (r_index==hist_depth) begin
              bct_sat_last = 1;
              c_state = IDLE;
           end
        end
      endcase 

      bct_data = c_prev_bct[MAX_DEPTH-1:1];
      sat_data = c_prev_sat;
   end

   always_ff@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         r_state <= IDLE;
         r_index <= 1;
         r_prev_bct <= 0;
         r_prev_sat <= 0;
      end
      else begin
         `UPDATE_FLOP(state);
         `UPDATE_FLOP(index);
         `UPDATE_FLOP(prev_bct);
         `UPDATE_FLOP(prev_sat);
      end
   end

`undef DECLARE_FLOP
`undef DEFAULT_FLOP
`undef UPDATE_FLOP

endmodule 







