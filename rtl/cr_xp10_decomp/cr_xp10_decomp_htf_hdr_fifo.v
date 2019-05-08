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

module cr_xp10_decomp_htf_hdr_fifo (
   
   bimc_odat, bimc_osync, hdr_ro_uncorrectable_ecc_error,
   htf_bhp_hdr_dp_ready, hdr_bits_avail, hdr_bits_data, hdr_bits_last,
   hdr_bits_err, hdr_data_stall_stb,
   
   clk, rst_n, ovstb, lvm, mlvm, bimc_rst_n, bimc_isync, bimc_idat,
   bhp_htf_hdr_dp_valid, bhp_htf_hdr_dp_bus, hdr_bits_consume,
   hdr_clear
   );

   parameter DP_WIDTH = 64;
   parameter MAX_HDR_BITS_PER_CYCLE = 16;

   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;

   
   
   
   input         clk;
   input         rst_n;

   
   
   
   input         ovstb;
   input         lvm;
   input         mlvm;

   
   
   
   input         bimc_rst_n;
   input         bimc_isync;
   input         bimc_idat;
   output        bimc_odat;
   output        bimc_osync;

   output logic  hdr_ro_uncorrectable_ecc_error;

   
   
   
   input logic   bhp_htf_hdr_dp_valid;
   input         bhp_htf_hdr_dp_bus_t bhp_htf_hdr_dp_bus;
   output logic  htf_bhp_hdr_dp_ready;

   
   
   
   output logic [`LOG_VEC(MAX_HDR_BITS_PER_CYCLE+1)] hdr_bits_avail;
   output logic [`BIT_VEC(MAX_HDR_BITS_PER_CYCLE)]   hdr_bits_data;
   output logic                        hdr_bits_last;
   output logic                        hdr_bits_err;
   input [`LOG_VEC(MAX_HDR_BITS_PER_CYCLE+1)]        hdr_bits_consume;

   input                               hdr_clear;

   
   
   
   output logic                        hdr_data_stall_stb;

   

   
   
   
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
`define DECLARE_RESET_OUT_FLOP(name, reset_val) \
   `DECLARE_RESET_FLOP(name, reset_val); \
   assign name = r_``name

   

   logic                hdr_dp_valid;
   bhp_htf_hdr_dp_bus_t hdr_dp_bus;
   logic                hdr_dp_ready;
   axi_channel_reg_slice
     #(.PAYLD_WIDTH($bits(bhp_htf_hdr_dp_bus_t)),
       .HNDSHK_MODE(`AXI_RS_FULL))
   u_reg_slice
     (.aclk (clk),
      .aresetn (rst_n),
      .valid_src (bhp_htf_hdr_dp_valid),
      .payload_src (bhp_htf_hdr_dp_bus),
      .ready_src (htf_bhp_hdr_dp_ready),
      .valid_dst (hdr_dp_valid),
      .payload_dst (hdr_dp_bus),
      .ready_dst (hdr_dp_ready));


   logic                      hdr_fifo_wen;
   logic                      hdr_fifo_full;
   logic                      hdr_fifo_ren;
   logic                      hdr_fifo_empty;
   logic                      hdr_fifo_clear;
   logic [`BIT_VEC(DP_WIDTH)] hdr_fifo_rdata;
   logic                      ro_uncorrectable_ecc_error;

   logic [`LOG_VEC(DP_WIDTH+1)]    hdr_unpacker_src_items_valid;
   logic [`BIT_VEC(DP_WIDTH)]      hdr_unpacker_src_data;
   logic                           hdr_unpacker_src_last;
   logic                           hdr_unpacker_src_ready;
   logic                           hdr_unpacker_dst_last;
   logic [`LOG_VEC(MAX_HDR_BITS_PER_CYCLE+1)] hdr_unpacker_dst_items_consume;
   
   logic                           `DECLARE_RESET_FLOP(got_last, 0);
   logic                           `DECLARE_RESET_FLOP(got_clear, 0);
   logic                           `DECLARE_RESET_FLOP(hdr_bits_last_prev, 0);

   logic                           `DECLARE_RESET_OUT_FLOP(hdr_ro_uncorrectable_ecc_error, 0);
   assign c_hdr_ro_uncorrectable_ecc_error = ro_uncorrectable_ecc_error;

   logic                `DECLARE_RESET_OUT_FLOP(hdr_data_stall_stb, 0);

   always_comb begin
      `DEFAULT_FLOP(got_last);
      `DEFAULT_FLOP(got_clear);
      `DEFAULT_FLOP(hdr_bits_last_prev);

      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      hdr_fifo_wen = 0;
      hdr_dp_ready = 0;
      if (hdr_dp_valid && !hdr_fifo_full && !r_got_last) begin
         hdr_dp_ready = 1;
         hdr_fifo_wen = !r_got_clear;
         if (hdr_dp_bus.last) begin
            c_got_last = !r_got_clear;
            c_got_clear = 0;
         end
      end
      
      
      
      hdr_unpacker_src_items_valid = 0;
      hdr_fifo_ren = 0;
      if (!hdr_fifo_empty) begin
         hdr_unpacker_src_items_valid = DP_WIDTH;
         if (hdr_unpacker_src_ready) begin
            hdr_fifo_ren = 1;
         end
      end

      hdr_fifo_clear = 0;
      if (hdr_clear) begin
         hdr_fifo_clear = 1;
         c_got_clear = !c_got_last;
         c_got_last = 0;
      end

      c_hdr_data_stall_stb = hdr_dp_valid && !hdr_dp_ready && hdr_dp_bus.trace_bit;

      
      if (hdr_bits_consume > hdr_bits_avail) begin
         hdr_unpacker_dst_items_consume = hdr_bits_avail;
         hdr_bits_err = 1;
      end
      else begin
         hdr_unpacker_dst_items_consume = hdr_bits_consume;
         hdr_bits_err = 0;
      end

      
      
      if (hdr_unpacker_dst_last) begin
         hdr_bits_last = 1;
         c_hdr_bits_last_prev = 1;
      end
      else if (hdr_bits_avail == 0) begin
         hdr_bits_last = r_hdr_bits_last_prev;
      end
      else begin
         hdr_bits_last = 0;
         c_hdr_bits_last_prev = 0;
      end

      
      
      if (hdr_clear)
        c_hdr_bits_last_prev = 0;
      
   end

   
   nx_fifo_ram_1r1w
     #(.DEPTH(`N_HTF_HDR_FIFO_DEPTH),
       .WIDTH(`AXI_S_DP_DWIDTH+1),
       .SPECIALIZE(1),
       .IN_FLOP(1),
       .OUT_FLOP(1),
       .RD_LATENCY(1),
       .OVERFLOW_ASSERT(0),
       .UNDERFLOW_ASSERT(0))
   u_hdr_fifo
     (
      
      .empty                            (hdr_fifo_empty),        
      .full                             (hdr_fifo_full),         
      .used_slots                       (),                      
      .free_slots                       (),                      
      .rerr                             (),                      
      .rdata                            ({hdr_unpacker_src_last, hdr_fifo_rdata}), 
      .underflow                        (),                      
      .overflow                         (),                      
      .bimc_odat                        (bimc_odat),
      .bimc_osync                       (bimc_osync),
      .ro_uncorrectable_ecc_error       (ro_uncorrectable_ecc_error), 
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .wen                              (hdr_fifo_wen),          
      .wdata                            ({hdr_dp_bus.last, hdr_dp_bus.data}), 
      .ren                              (hdr_fifo_ren),          
      .clear                            (hdr_fifo_clear),        
      .bimc_idat                        (bimc_idat),
      .bimc_isync                       (bimc_isync),
      .bimc_rst_n                       (bimc_rst_n),
      .lvm                              (lvm),
      .mlvm                             (mlvm),
      .mrdten                           (1'b0));                  

   assign hdr_unpacker_src_data = (hdr_unpacker_src_items_valid == 0) ? 0 : hdr_fifo_rdata;

   

   cr_xp10_decomp_unpacker
     #(.IN_ITEMS(DP_WIDTH),
       .OUT_ITEMS(MAX_HDR_BITS_PER_CYCLE),
       .MAX_CONSUME_ITEMS(MAX_HDR_BITS_PER_CYCLE),
       .BITS_PER_ITEM(1))
   u_hdr_unpacker
     (
      
      .src_ready                        (hdr_unpacker_src_ready), 
      .dst_items_avail                  (hdr_bits_avail[`LOG_VEC(MAX_HDR_BITS_PER_CYCLE+1)]), 
      .dst_data                         (hdr_bits_data[`BIT_VEC(MAX_HDR_BITS_PER_CYCLE*1)]), 
      .dst_last                         (hdr_unpacker_dst_last), 
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .src_items_valid                  (hdr_unpacker_src_items_valid), 
      .src_data                         (hdr_unpacker_src_data[`BIT_VEC(DP_WIDTH*1)]), 
      .src_last                         (hdr_unpacker_src_last), 
      .dst_items_consume                (hdr_unpacker_dst_items_consume), 
      .clear                            (hdr_clear));             

`undef DECLARE_FLOP
`undef DECLARE_RESET_FLOP
`undef DECLARE_RESET_OUT_FLOP
`undef DEFAULT_FLOP

endmodule 









