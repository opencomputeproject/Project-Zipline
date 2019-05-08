/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"
`include "axi_reg_slice_defs.vh"

module cr_xp10_decomp_sdd_wf (
   
   sdd_lfa_dp_ready, wf_lanes_valid, wf_lanes_data, wf_lanes_numbits,
   wf_lanes_sob, wf_lanes_eob, wf_lanes_eof, wf_lanes_trace_bit,
   wf_lanes_frame_bytes_in, wf_lanes_last_frame, wf_lanes_errcode,
   input_stall_stb,
   
   clk, rst_n, lfa_sdd_dp_valid, lfa_sdd_dp_bus, lanes_wf_ready
   );

   import crPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   
   
   
   input         clk;
   input         rst_n; 
   
   
   
   
   input   lfa_sdd_dp_valid;
   input   lfa_sdd_dp_bus_t lfa_sdd_dp_bus;
   output logic sdd_lfa_dp_ready;
   
   
   
   
   output logic  wf_lanes_valid;
   output logic [127:0] wf_lanes_data;
   output logic [7:0]   wf_lanes_numbits;
   output logic         wf_lanes_sob;
   output logic         wf_lanes_eob;
   output logic         wf_lanes_eof;
   output logic         wf_lanes_trace_bit;
   output logic [27:0]  wf_lanes_frame_bytes_in;
   output logic         wf_lanes_last_frame;
   output               zipline_error_e  wf_lanes_errcode;
   input                lanes_wf_ready;

   
   output logic input_stall_stb;

   
   logic            dp_valid;
   lfa_sdd_dp_bus_t dp_bus;
   logic            dp_ready;
   axi_channel_reg_slice
     #(.PAYLD_WIDTH($bits(lfa_sdd_dp_bus_t)),
       .HNDSHK_MODE(`AXI_RS_FULL))
   u_reg_slice
     (.aclk (clk),
      .aresetn (rst_n),
      .valid_src (lfa_sdd_dp_valid),
      .payload_src (lfa_sdd_dp_bus),
      .ready_src (sdd_lfa_dp_ready),
      .valid_dst (dp_valid),
      .payload_dst (dp_bus),
      .ready_dst (dp_ready));

   logic [1:0]    unpacker_src_items_valid;
   lfa_sdd_dp_bus_t [1:0] unpacker_src_data;
   logic          unpacker_src_last;
   logic          unpacker_src_ready;

   logic [2:0]    unpacker_dst_items_avail;
   lfa_sdd_dp_bus_t [3:0] unpacker_dst_data; 
   logic          unpacker_dst_last;
   logic          unpacker_dst_items_consume;

   logic        r_input_stall_stb;
   assign input_stall_stb = r_input_stall_stb;
   always@(posedge clk or negedge rst_n) begin
      if (!rst_n)
        r_input_stall_stb <= 0;
      else
        r_input_stall_stb <= dp_valid && !dp_ready && dp_bus.trace_bit;
   end

   always_comb begin
      unpacker_src_items_valid = 0;
      unpacker_src_last = 0;
      dp_ready = 0;

      unpacker_src_data = '0;
      
      {unpacker_src_data[1].data[31:0], unpacker_src_data[0].data[31:0]} = dp_bus.data;
      unpacker_src_data[0].numbits = 32;
      unpacker_src_data[1].numbits = 7'(dp_bus.numbits-32);
      unpacker_src_data[0].sob = dp_bus.sob;
      unpacker_src_data[1].eob = dp_bus.eob;
      unpacker_src_data[1].eof = dp_bus.eof;
      unpacker_src_data[1].error = dp_bus.error;
      unpacker_src_data[0].trace_bit = dp_bus.trace_bit;
      unpacker_src_data[1].trace_bit = dp_bus.trace_bit;
      unpacker_src_data[0].frame_bytes_in = dp_bus.frame_bytes_in;
      unpacker_src_data[0].last_frame = dp_bus.last_frame;
      unpacker_src_data[1].frame_bytes_in = dp_bus.frame_bytes_in;
      unpacker_src_data[1].last_frame = dp_bus.last_frame;

      
      unpacker_src_last = dp_bus.eob || dp_bus.eof;

      if (dp_valid) begin
         if (dp_bus.numbits > 32) begin
            unpacker_src_items_valid = 2;
         end
         else begin
            
            unpacker_src_items_valid = 1;
            unpacker_src_data[0].numbits = dp_bus.numbits;
            unpacker_src_data[0].sob = dp_bus.sob;
            unpacker_src_data[0].eob = dp_bus.eob;
            unpacker_src_data[0].eof = dp_bus.eof;
            unpacker_src_data[0].error = dp_bus.error;
         end 
         if (unpacker_src_ready)
           dp_ready = 1;
      end
   end

   always_comb begin
      unpacker_dst_items_consume = 0;

      wf_lanes_valid = 0;
      wf_lanes_data = {unpacker_dst_data[3].data[31:0],
                       unpacker_dst_data[2].data[31:0],
                       unpacker_dst_data[1].data[31:0],
                       unpacker_dst_data[0].data[31:0]};
      wf_lanes_numbits = 8'((unpacker_dst_items_avail-1)*32 + unpacker_dst_data[unpacker_dst_items_avail-1].numbits); 
      wf_lanes_sob = unpacker_dst_data[0].sob;
      wf_lanes_eob = unpacker_dst_data[unpacker_dst_items_avail-1].eob; 
      wf_lanes_eof = unpacker_dst_data[unpacker_dst_items_avail-1].eof; 
      wf_lanes_errcode = unpacker_dst_data[unpacker_dst_items_avail-1].error; 
      wf_lanes_trace_bit = unpacker_dst_data[0].trace_bit;
      wf_lanes_frame_bytes_in = unpacker_dst_data[unpacker_dst_items_avail-1].frame_bytes_in; 
      wf_lanes_last_frame = unpacker_dst_data[unpacker_dst_items_avail-1].last_frame; 

      if ((unpacker_dst_items_avail == 4) || ((unpacker_dst_items_avail != 0) && unpacker_dst_last)) begin
         
         
         wf_lanes_valid = 1;
         if (lanes_wf_ready) begin
            
            unpacker_dst_items_consume = 1;
         end
      end 
   end 

   `ASSERT_PROPERTY(wf_lanes_valid |-> ((unpacker_dst_data[0].numbits == 32) || wf_lanes_eob || wf_lanes_eof)) else `ERROR("numbits can only be < 32 for eob/eof");
   `ASSERT_PROPERTY(unpacker_dst_items_avail > 1 |-> !unpacker_dst_data[1].sob) else `ERROR("not expecting SOB for 2nd word");
   `ASSERT_PROPERTY(unpacker_dst_items_avail > 2 |-> !unpacker_dst_data[2].sob) else `ERROR("not expecting SOB for 3rd word");
   `ASSERT_PROPERTY(unpacker_dst_items_avail > 3 |-> !unpacker_dst_data[3].sob) else `ERROR("not expecting SOB for 4th word");

   


   cr_xp10_decomp_unpacker
     #(.IN_ITEMS(2),
       .OUT_ITEMS(4),
       .MAX_CONSUME_ITEMS(1),
       .BITS_PER_ITEM($bits(lfa_sdd_dp_bus_t)))
   u_bff
     (
      
      .src_ready                        (unpacker_src_ready),    
      .dst_items_avail                  (unpacker_dst_items_avail), 
      .dst_data                         (unpacker_dst_data),     
      .dst_last                         (unpacker_dst_last),     
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .src_items_valid                  (unpacker_src_items_valid), 
      .src_data                         (unpacker_src_data),     
      .src_last                         (unpacker_src_last),     
      .dst_items_consume                (unpacker_dst_items_consume), 
      .clear                            (1'b0));                  

endmodule 









