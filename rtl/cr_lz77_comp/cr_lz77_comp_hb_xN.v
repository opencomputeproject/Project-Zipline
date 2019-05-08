/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


















`include "ccx_std.vh"
`include "cr_lz77_comp.vh"

module cr_lz77_comp_hb_xN
  #(
    parameter IN_BYTES       = `IN_BYTES,
    parameter SHIFT_MULT     = 4,
    parameter TRUNC_NUM      = `TRUNC_NUM_V3,
    parameter LPOS_PER_TILE  = `OFFSETS_PER_TILE/8,
    parameter OFFSETS_PER_LPO = 8,
    parameter FIRST_TILE = 0
    )
   (
    
   
   sdo_valid, sdo, prev_sel_offset_bm, best_new_offset_bm,
   best_new_offset,
   
   clk_hb, clk, rst_n, shift_start_phase, input_data, input_valid,
   scramble_enb, shift_en, sdi_valid, clr_valid, sdi, prev_sel_offset
   );

   localparam OFFSETS_PER_TILE = LPOS_PER_TILE * OFFSETS_PER_LPO;

   localparam LOG_OFFPL = (OFFSETS_PER_LPO<2)?1:$clog2(OFFSETS_PER_LPO);

   input                                    clk_hb;
   input                                    clk;
   input                                    rst_n;

   input [$clog2(SHIFT_MULT)-1:0]           shift_start_phase;
   
   
   input [3:0][7:0] 			    input_data;
   input [3:0]				    input_valid;

   input                                    scramble_enb;
   
   
   input                                    shift_en;
   
   input [IN_BYTES-1:0]                     sdi_valid;
   
   output logic                             sdo_valid;
   input 				    clr_valid;
   
   
   input [IN_BYTES-1:0][7:0] 			    sdi;
   output logic [IN_BYTES-1:0][7:0]                  sdo;

   input [LPOS_PER_TILE-1:0][LOG_OFFPL-1:0] prev_sel_offset;
   
   output logic [LPOS_PER_TILE-1:0][3:0]    prev_sel_offset_bm;
   output logic [LPOS_PER_TILE-1:0][3:0]    best_new_offset_bm;
   output logic [LPOS_PER_TILE-1:0][LOG_OFFPL-1:0] best_new_offset;
   
   
`ifdef SHOULD_BE_EMPTY
   
      
`endif

`include "cr_lz77_comp_funcs.vh"

   
   
   
   
   
   

   `ASSERT_PROPERTY((FIRST_TILE && ((sdi_valid==4'b1110) || (sdi_valid==4'b1100) || (sdi_valid==4'b1000))) || (sdi_valid==0) || (sdi_valid==4'b1111)) else `ERROR("only input to the 1st tile can have partial sdi_valid");
         
   logic [OFFSETS_PER_TILE-1:0][7:0] hb;
   logic [OFFSETS_PER_TILE/IN_BYTES-1:0] hb_valid;

   
   
   
   logic [IN_BYTES-2:0][7:0]             hb_endcap;
   logic                                 hb_valid_endcap;

   
   logic [SHIFT_MULT-1:0][IN_BYTES-1:0]    hb_valid_first;

   logic [OFFSETS_PER_TILE-1:0][IN_BYTES-1:0]            compare_en;

   logic [OFFSETS_PER_TILE-1:0][3:0]                     bm_per_offset_raw;
   logic [OFFSETS_PER_TILE-1:0][3:0]                     bm_per_offset;
   logic [OFFSETS_PER_TILE-1:0][3:0]                     bm_per_offset_therm;
   logic [OFFSETS_PER_TILE-1:0]                          override;

   logic [OFFSETS_PER_TILE-1:0]                          expanded_hb_valid;

   genvar                                                        ii, jj;
   generate
      for (ii=0; ii<OFFSETS_PER_TILE; ii++) begin : expanded_hb_valid_gen
         
         
         if (FIRST_TILE && (ii<(SHIFT_MULT*IN_BYTES))) begin : use_hb_valid_first
            assign expanded_hb_valid[ii] = hb_valid_first[ii/IN_BYTES][ii%IN_BYTES];
         end
         else begin : no_hb_valid_first
            assign expanded_hb_valid[ii] = hb_valid[ii/IN_BYTES];
         end
      end

      logic [SHIFT_MULT-1:0]                                     r_endcap_pos;
      if (SHIFT_MULT==1) begin : shift_mult_1
         assign r_endcap_pos = 1'b1;
      end
      else begin : shift_mult_n
         always_ff@(posedge clk) begin
            if (clr_valid) begin
               logic [SHIFT_MULT-1:0] v_endcap_pos;
               v_endcap_pos = 1 << shift_start_phase;
               r_endcap_pos <= `ROTATE_LEFT(v_endcap_pos, 1);
            end
            else if (shift_en) begin
               r_endcap_pos <= `ROTATE_RIGHT(r_endcap_pos, 1);
            end
         end 
      end

      for (ii=0; ii<OFFSETS_PER_TILE; ii++) begin : bm_per_offset_loop
         for (jj=0; jj<IN_BYTES; jj++) begin : input_byte_loop
            if (((ii+jj)/IN_BYTES != ii/IN_BYTES) && (((ii+jj)%OFFSETS_PER_TILE)/IN_BYTES) < SHIFT_MULT) begin : hb_byte_in_different_group
               assign compare_en[ii][jj] = input_valid[jj] && ((r_endcap_pos[((ii+jj)%OFFSETS_PER_TILE)/IN_BYTES])?hb_valid_endcap:expanded_hb_valid[(ii+jj)%OFFSETS_PER_TILE]);

`ifdef CASCADE_COMPARE
               bm_phase_compare u_cmp (.input_data(input_data[jj]), 
                                       .hb((r_endcap_pos[((ii+jj)%OFFSETS_PER_TILE)/IN_BYTES])?hb_endcap[(ii+jj)%IN_BYTES]:hb[(ii+jj)%OFFSETS_PER_TILE]),
                                       .compare_en((jj==0)?1'b1:(bm_per_offset_raw[ii][jj-1] || override[ii])),
                                       .bm_phase(bm_per_offset_raw[ii][jj]));
`else
               assign bm_per_offset_raw[ii][jj] = input_data[jj] == ((r_endcap_pos[((ii+jj)%OFFSETS_PER_TILE)/IN_BYTES])?hb_endcap[(ii+jj)%IN_BYTES]:hb[(ii+jj)%OFFSETS_PER_TILE]);
`endif
            end
            else begin : hb_bytes_in_same_group
               assign compare_en[ii][jj] = input_valid[jj] && hb_valid[(ii+jj)/IN_BYTES];
               
               assign bm_per_offset_raw[ii][jj] = input_data[jj] == hb[ii+jj];
            end
         end 
         
         assign bm_per_offset[ii] = bm_per_offset_raw[ii] & compare_en[ii];
         
         assign bm_per_offset_therm[ii][0] = bm_per_offset[ii][0];
         
         for (jj=1; jj<4; jj++) begin : bm_per_offset_therm_loop
            assign bm_per_offset_therm[ii][jj] = bm_per_offset[ii][jj] && bm_per_offset_therm[ii][jj-1];
         end
      end 
   endgenerate

   localparam OUTER_STREE_OFFSETS = `MIN(IN_BYTES, OFFSETS_PER_LPO);
   localparam OUTER_STREE_GROUPS = OFFSETS_PER_TILE/OUTER_STREE_OFFSETS;
   localparam INNER_STREE_OFFSETS = OFFSETS_PER_LPO/OUTER_STREE_OFFSETS;
   localparam LOG_OUTER_STREE_OFFSETS = (OUTER_STREE_OFFSETS<2)?1:$clog2(OUTER_STREE_OFFSETS);

   logic [OUTER_STREE_GROUPS-1:0][OUTER_STREE_OFFSETS-1:0][3:0] outer_stree_therm_in;
   logic [OUTER_STREE_GROUPS-1:0][3:0]                          outer_stree_therm_out;
   logic [OUTER_STREE_GROUPS-1:0][LOG_OUTER_STREE_OFFSETS-1:0]  outer_stree_offset_out;
   
   assign outer_stree_therm_in = bm_per_offset_therm;

   generate
      if (OFFSETS_PER_LPO > 1) begin : outer_stree_gen
         cr_lz77_comp_stree
           #(
             .GROUP_NUM(OUTER_STREE_GROUPS),
             .OFFSETS(OUTER_STREE_OFFSETS),
             .T_WIDTH(4),
             .T_MASK(0),
             .OI_WIDTH(0))
         outer_stree
           (
            .therm_in (outer_stree_therm_in[OUTER_STREE_GROUPS-1:0]),
            .offset_in ({OUTER_STREE_GROUPS*OUTER_STREE_OFFSETS{1'b0}}),
            .therm_out (outer_stree_therm_out[OUTER_STREE_GROUPS-1:0]),
            .offset_out (outer_stree_offset_out[OUTER_STREE_GROUPS-1:0])
            );
      end 
      else begin : no_outer_stree
         assign outer_stree_therm_out = '0;
         assign outer_stree_offset_out = '0;
      end
   endgenerate
         
   logic [LPOS_PER_TILE-1:0][INNER_STREE_OFFSETS-1:0][3:0]                         inner_stree_therm_in;
   logic [LPOS_PER_TILE-1:0][INNER_STREE_OFFSETS-1:0][LOG_OUTER_STREE_OFFSETS-1:0] inner_stree_offset_in;

   

   logic [IN_BYTES-1:0][7:0]                                                       sdo_raw;

   generate
      if (SHIFT_MULT>1) begin : fractional_clocking_mux
         logic [$clog2(SHIFT_MULT)-1:0]                                            r_clock_count;
         logic [$clog2(SHIFT_MULT)-1:0] r_clock_count_dly;

         always_ff@(posedge clk) begin
            if (clr_valid) begin 
               r_clock_count <= shift_start_phase;
               r_clock_count_dly <= 0;
            end
            else if (shift_en) begin
               if (r_clock_count == 0)
                 r_clock_count <= SHIFT_MULT-1;
               else
                 r_clock_count <= r_clock_count-1;
               r_clock_count_dly <= r_clock_count;
            end
         end 

         assign inner_stree_therm_in = `ROTATE_RIGHT(outer_stree_therm_out, r_clock_count_dly*IN_BYTES*IN_BYTES/OUTER_STREE_OFFSETS);
         assign inner_stree_offset_in = `ROTATE_RIGHT(outer_stree_offset_out, r_clock_count_dly*LOG_OUTER_STREE_OFFSETS*IN_BYTES/OUTER_STREE_OFFSETS);


         logic [OFFSETS_PER_TILE-1:0][7:0] rotated_hb;
         assign rotated_hb = `ROTATE_LEFT(hb, SHIFT_MULT*IN_BYTES*8);

         logic clk_hb_shift_en, clk_hb_shift;
         assign clk_hb_shift_en = shift_en && (sdi_valid!=0) && (r_clock_count == (SHIFT_MULT-1));
         cr_clk_gate dont_touch_clk_gate_hb_shift  ( .i0(1'b0), .i1(clk_hb_shift_en), .phi(clk_hb), .o(clk_hb_shift) );
         
         always_ff@(posedge clk_hb_shift) begin
            hb[OFFSETS_PER_TILE-1:SHIFT_MULT*IN_BYTES] <= rotated_hb[OFFSETS_PER_TILE-1:SHIFT_MULT*IN_BYTES];
            hb[SHIFT_MULT*IN_BYTES-1:(SHIFT_MULT-1)*IN_BYTES] <= sdi;
         end

         logic clk_hb_endcap_en, clk_hb_endcap;
         assign clk_hb_endcap_en = shift_en && (sdi_valid!=0);
         cr_clk_gate dont_touch_clk_gate_hb_endcap  ( .i0(1'b0), .i1(clk_hb_endcap_en), .phi(clk_hb), .o(clk_hb_endcap) );

         always_ff@(posedge clk_hb_endcap) begin
            if (r_clock_count == (SHIFT_MULT-1)) begin
               hb_endcap <= rotated_hb[SHIFT_MULT*IN_BYTES-2:SHIFT_MULT*IN_BYTES-IN_BYTES];
               sdo_raw = rotated_hb[(SHIFT_MULT-1)*IN_BYTES-1:(SHIFT_MULT-2)*IN_BYTES];
            end
            else begin
               logic [2*OFFSETS_PER_TILE*8-1:0] v_flat_hb;
               v_flat_hb = {2{hb}};
               hb_endcap <= v_flat_hb[r_clock_count*IN_BYTES*8 +: IN_BYTES*8];               
               sdo_raw = v_flat_hb[OFFSETS_PER_TILE*8-1+r_clock_count*IN_BYTES*8 -: IN_BYTES*8];
            end
            for (int i=0; i<IN_BYTES; i++) begin
               sdo[i] <= scramble_enb ? sdo_raw[i] : byte_scramble(sdo_raw[i]);
            end
         end

         logic [SHIFT_MULT-2:0] clk_hb_lower_en, clk_hb_lower;
         for (ii=0; ii<(SHIFT_MULT-1); ii++) begin : clk_hb_lower_en_loop
            assign clk_hb_lower_en[ii] = shift_en && (sdi_valid!=0) && ((r_clock_count == ii) || (r_clock_count == (SHIFT_MULT-1)));
            cr_clk_gate dont_touch_clk_gate_hb_lower  ( .i0(1'b0), .i1(clk_hb_lower_en[ii]), .phi(clk_hb), .o(clk_hb_lower[ii]) );

            always_ff@(posedge clk_hb_lower[ii]) begin
               if (r_clock_count == (SHIFT_MULT-1))
                 hb[ii*IN_BYTES +: IN_BYTES] <= rotated_hb[ii*IN_BYTES +: IN_BYTES];
               else
                 hb[ii*IN_BYTES +: IN_BYTES] <= sdi;
            end
         end

         always_ff@(posedge clk) begin
            if (clr_valid) begin
               hb_valid <= 0;
               hb_valid_endcap <= 0;
               hb_valid_first <= 0;
               sdo_valid <= 0;
            end
            else if (shift_en) begin
               if (r_clock_count == (SHIFT_MULT-1)) begin
                  logic [OFFSETS_PER_TILE/IN_BYTES-1:0] v_hb_valid;
                  
                  v_hb_valid = `ROTATE_LEFT(hb_valid, SHIFT_MULT);
                  hb_valid <= v_hb_valid;
                  
                  
                  for (int i=0; i<SHIFT_MULT; i++) begin
                     hb_valid_first[i] <= {IN_BYTES{v_hb_valid[i]}};
                  end
                  
                  hb_valid_endcap <= v_hb_valid[SHIFT_MULT-1];
                  
                  sdo_valid <= v_hb_valid[SHIFT_MULT-2];
               end 
               else begin
                  logic [2*OFFSETS_PER_TILE/IN_BYTES-1:0] v_hb_valid;
                  v_hb_valid = {2{hb_valid}};
                  sdo_valid <= v_hb_valid[OFFSETS_PER_TILE/IN_BYTES-1+r_clock_count];

                  hb_valid_endcap <= v_hb_valid[r_clock_count];
               end
               hb_valid[r_clock_count] <= sdi_valid!=0;
               hb_valid_first[r_clock_count] <= sdi_valid;
               assert ((sdi_valid=='1) || (hb_valid_first[r_clock_count_dly]==0) || (hb_valid_first[r_clock_count_dly]=='1)) else `ERROR("can't get partial sdi_valid following a previous partial sdi_valid");
            end 
         end 

         
         logic [2*OFFSETS_PER_TILE-1:0][3:0]   premux_bm_per_offset;
         assign premux_bm_per_offset = {2{bm_per_offset}};
         for (ii=0; ii<LPOS_PER_TILE; ii++) begin : prev_sel_offset_bm_loop
            assign prev_sel_offset_bm[ii] = premux_bm_per_offset[ii*OFFSETS_PER_LPO+r_clock_count_dly*IN_BYTES+prev_sel_offset[ii]];
         end

`ifdef CASCADE_COMPARE
         always_comb begin
            logic [2*OFFSETS_PER_TILE-1:0] v_override;
            v_override = '0;
            for (int i=0; i<LPOS_PER_TILE; i++) begin
               v_override[i*OFFSETS_PER_LPO+r_clock_count_dly*IN_BYTES+prev_sel_offset[i]] = 1'b1;
            end
            override = v_override[OFFSETS_PER_TILE-1:0] | v_override[OFFSETS_PER_TILE +: OFFSETS_PER_TILE];
         end
`else
         assign override = '1;
`endif

      end 
      else begin : no_fractional_clocking_mux

         assign inner_stree_therm_in = outer_stree_therm_out;
         assign inner_stree_offset_in = outer_stree_offset_out;
         

         always_ff @ (posedge clk_hb) begin
            if (shift_en && (sdi_valid!=0))
              {hb_endcap, hb} <= {hb[OFFSETS_PER_TILE-2:0], sdi};
         end
         
         always_ff @(posedge clk) begin
            if (clr_valid) begin
	       hb_valid <= 0;
               hb_valid_endcap <= 0;
               hb_valid_first <= 0;
            end
            else if (shift_en) begin
	       
               {hb_valid_endcap, hb_valid} <= {hb_valid, sdi_valid!=0};
               hb_valid_first <= sdi_valid;
               assert ((sdi_valid=='1) || (hb_valid_first==0) || (hb_valid_first=='1)) else `ERROR("can't get partial sdi_valid following a previous partial sdi_valid");
            end
         end

         assign sdo_valid = hb_valid[OFFSETS_PER_TILE/IN_BYTES-1];
         assign sdo_raw       = hb[OFFSETS_PER_TILE-1:OFFSETS_PER_TILE-IN_BYTES];
         for (ii=0; ii<IN_BYTES; ii++) begin: sdo_scramble_loop
            assign sdo[ii] = scramble_enb ? sdo_raw[ii] : byte_scramble(sdo_raw[ii]);
         end

         for (ii=0; ii<LPOS_PER_TILE; ii++) begin : prev_sel_offset_bm_loop
            assign prev_sel_offset_bm[ii] = bm_per_offset[ii*OFFSETS_PER_LPO+prev_sel_offset[ii]];
         end
         

`ifdef CASCADE_COMPARE
         always_comb begin
            for (int i=0; i<LPOS_PER_TILE; i++) begin
               override[i*OFFSETS_PER_LPO+prev_sel_offset[i]] = 1'b1;
            end
         end
`else
         assign override = '1;
`endif
         
      end 

      
   endgenerate

   generate
      if (OFFSETS_PER_LPO > 1) begin: inner_stree_gen
         cr_lz77_comp_stree
           #(
             .GROUP_NUM(LPOS_PER_TILE),
             .OFFSETS(INNER_STREE_OFFSETS),
             .T_WIDTH(4),
             .T_MASK(0),
             .OI_WIDTH(LOG_OUTER_STREE_OFFSETS)
             )
         inner_stree
           (
            .therm_in (inner_stree_therm_in),
            .offset_in (inner_stree_offset_in),
            .therm_out (best_new_offset_bm),
            .offset_out (best_new_offset)
            );
      end 
      else begin : no_inner_stree
         assign best_new_offset = '0;
         assign best_new_offset_bm = '0;
      end
   endgenerate


endmodule 

module bm_phase_compare(input_data, hb, compare_en, bm_phase);
   input [7:0] input_data;
   input [7:0] hb;
   input       compare_en;
   output wire bm_phase;
   

`ifdef FAST_RTL_NO_GATES

   assign bm_phase = (input_data == hb) && compare_en;

`else

   wire [7:0]  n;
   wire [7:0]  x;
   
   
   
   
   
   assign n = ~(input_data | hb);
   
   
   cr_mux_32 dont_touch_a032_0   (.i0_0(input_data[0]),.i0_1(hb[0]),.i0_2(compare_en),.i1_0(n[0]),.i1_1(compare_en), .o(x[0]));
   cr_mux_32 dont_touch_a032_1   (.i0_0(input_data[1]),.i0_1(hb[1]),.i0_2(compare_en),.i1_0(n[1]),.i1_1(compare_en), .o(x[1]));
   cr_mux_32 dont_touch_a032_2   (.i0_0(input_data[2]),.i0_1(hb[2]),.i0_2(compare_en),.i1_0(n[2]),.i1_1(compare_en), .o(x[2]));
   cr_mux_32 dont_touch_a032_3   (.i0_0(input_data[3]),.i0_1(hb[3]),.i0_2(compare_en),.i1_0(n[3]),.i1_1(compare_en), .o(x[3]));
   cr_mux_32 dont_touch_a032_4   (.i0_0(input_data[4]),.i0_1(hb[4]),.i0_2(compare_en),.i1_0(n[4]),.i1_1(compare_en), .o(x[4]));
   cr_mux_32 dont_touch_a032_5   (.i0_0(input_data[5]),.i0_1(hb[5]),.i0_2(compare_en),.i1_0(n[5]),.i1_1(compare_en), .o(x[5]));
   cr_mux_32 dont_touch_a032_6   (.i0_0(input_data[6]),.i0_1(hb[6]),.i0_2(compare_en),.i1_0(n[6]),.i1_1(compare_en), .o(x[6]));
   cr_mux_32 dont_touch_a032_7   (.i0_0(input_data[7]),.i0_1(hb[7]),.i0_2(compare_en),.i1_0(n[7]),.i1_1(compare_en), .o(x[7]));
   
   

   assign bm_phase = &x;

`endif
endmodule 