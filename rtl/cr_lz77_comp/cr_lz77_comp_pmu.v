/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_lz77_comp_pkg_include.vh"

module cr_lz77_comp_pmu
  (
   
   lob_events,
   
   clk, rst_n, pac_exg_data, pac_exg_val, exg_pmu_bypass_stb,
   exg_pmu_eof_stb, exg_pmu_enable_stats
   );

`include "cr_lz77_comp_includes.vh"

   input                        clk;
   input 			rst_n; 

   input 			packer_symbol_bus_t pac_exg_data;
   input 			pac_exg_val;

   input  			exg_pmu_bypass_stb;
   input  			exg_pmu_eof_stb;
   input 			exg_pmu_enable_stats;

   output 			lob_events_t lob_events;

   
   
   
   
   


   lz_symbol_bus_t lz77_frame_data;

   assign lz77_frame_data = pac_exg_data.lz77_frame_data;

   always @ (posedge clk or negedge rst_n) begin
      if (!rst_n) begin
	 lob_events <= {$bits(lob_events_t){1'b0}};
      end else begin
	 lob_events <= {$bits(lob_events_t){1'b0}};
	 if (exg_pmu_enable_stats) begin
	    if (pac_exg_val) begin
	       lob_events.one_lit_ev      <= lits(lz77_frame_data, 1);
	       lob_events.two_lit_ev      <= lits(lz77_frame_data, 2);
	       lob_events.three_lit_ev    <= lits(lz77_frame_data, 3);
	       lob_events.four_lit_ev     <= lits(lz77_frame_data, 4);
	       lob_events.ptr_ev          <= ptrs(lz77_frame_data, PTR);
	       lob_events.mtf_ev          <= ptrs(lz77_frame_data, MTF);
	       lob_events.run_3_ev        <= runs(lz77_frame_data, 3,   3);
	       lob_events.run_4_ev        <= runs(lz77_frame_data, 4,   4);
	       lob_events.run_5_ev        <= runs(lz77_frame_data, 5,   5);
	       lob_events.run_6_ev        <= runs(lz77_frame_data, 6,   6);
	       lob_events.run_7_ev        <= runs(lz77_frame_data, 7,   7);
	       lob_events.run_8_ev        <= runs(lz77_frame_data, 8,   8);
	       lob_events.run_9_ev        <= runs(lz77_frame_data, 9,   9);
	       lob_events.run_10_ev       <= runs(lz77_frame_data, 10,  10);
	       lob_events.run_11_31_ev    <= runs(lz77_frame_data, 11,  31);
	       lob_events.run_32_63_ev    <= runs(lz77_frame_data, 32,  63);
	       lob_events.run_64_127_ev   <= runs(lz77_frame_data, 64,  127);
	       lob_events.run_128_255_ev  <= runs(lz77_frame_data, 128, 255);
	       lob_events.run_256_nup_ev  <= runs(lz77_frame_data, 256, 0);
	       lob_events.mtf_0_ev        <= mtfs(lz77_frame_data, 0);
	       lob_events.mtf_1_ev        <= mtfs(lz77_frame_data, 1);
	       lob_events.mtf_2_ev        <= mtfs(lz77_frame_data, 2);
	       lob_events.mtf_3_ev        <= mtfs(lz77_frame_data, 3);
	    end 
	    lob_events.bypass_ev <= exg_pmu_bypass_stb;
	    lob_events.eof_ev <= exg_pmu_eof_stb;
	 end 
      end 
   end 
   
      
   function logic lits(lz_symbol_bus_t frame, logic [3:0] num_lits);
      logic r;
      r = ( !frame.backref && (frame.framing == num_lits)     ) ||
	  ( frame.backref  && (frame.framing == (num_lits+1)) );
      return r;
   endfunction 
   
   function logic ptrs(lz_symbol_bus_t frame, lz77_symbol_type_e ptype);
      logic r;
      r = ( frame.backref && !frame.backref_type && (ptype == PTR) ) ||
	  ( frame.backref &&  frame.backref_type && (ptype == MTF) );
      return r;
   endfunction 
   
   function logic runs(lz_symbol_bus_t frame, int lo, int hi);
      logic r;
      r = ( frame.backref && (frame.length >= lo) && (frame.length <= hi) ) ||
	  ( frame.backref && (frame.length >= lo) && (hi == 0)            );
      return r;
   endfunction 
   
   function logic mtfs(lz_symbol_bus_t frame, int m);
      logic r;
      case (frame.backref_lane)
	0 : r = ( frame.backref && frame.backref_type && (frame.data0 == m) );
	1 : r = ( frame.backref && frame.backref_type && (frame.data1 == m) );
	2 : r = ( frame.backref && frame.backref_type && (frame.data2 == m) );
	3 : r = ( frame.backref && frame.backref_type && (frame.data3 == m) );
      endcase 
      return r;
   endfunction 
   
endmodule 









