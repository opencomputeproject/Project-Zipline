/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_huf_comp_reconstruct (
   
   bimc_odat, bimc_osync, lz_fhp_prefix_hdr_ready,
   lz_fhp_pre_prefix_ready, lz_fhp_usr_prefix_ready,
   lz_fhp_dbg_data_ready, lz_mtf_dp_ready, lz_be_dp_valid,
   lz_be_dp_bus, lz_bytes_decomp, lz_hb_bytes, lz_hb_head_ptr,
   lz_hb_tail_ptr, lz_local_bytes, xp10_decomp_lz77d_stat_events,
   lz77_hb_ro_uncorrectable_ecc_error_a,
   lz77_hb_ro_uncorrectable_ecc_error_b,
   lz77_pfx0_ro_uncorrectable_ecc_error,
   lz77_pfx1_ro_uncorrectable_ecc_error,
   
   clk, rst_n, ovstb, lvm, mlvm, bimc_idat, bimc_isync, bimc_rst_n,
   fhp_lz_prefix_hdr_valid, fhp_lz_prefix_hdr_bus,
   fhp_lz_prefix_valid, fhp_lz_prefix_dp_bus, fhp_lz_dbg_data_valid,
   fhp_lz_dbg_data_bus, mtf_lz_dp_valid, mtf_lz_dp_bus,
   be_lz_dp_ready, sw_LZ_BYPASS_CONFIG
   );

   import crPKG::lz_symbol_bus_t;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   
   
   
   input         clk;
   input         rst_n; 
   
   
   
   
   input         ovstb;
   input         lvm;
   input         mlvm;
   
   input         bimc_idat;
   input         bimc_isync;
   input         bimc_rst_n;
   output logic  bimc_odat;
   output logic  bimc_osync;
   
   
   
   input         fhp_lz_prefix_hdr_valid;
   input         fhp_lz_prefix_hdr_bus_t fhp_lz_prefix_hdr_bus;
   output        lz_fhp_prefix_hdr_ready;

   
   
   
   input         fhp_lz_prefix_valid;
   input         fhp_lz_prefix_dp_bus_t fhp_lz_prefix_dp_bus;
   output  logic lz_fhp_pre_prefix_ready;
   output  logic lz_fhp_usr_prefix_ready;
   
   
   
   
   input         fhp_lz_dbg_data_valid;
   input         lz_symbol_bus_t fhp_lz_dbg_data_bus;
   output        lz_fhp_dbg_data_ready;

   
   
   
   input         mtf_lz_dp_valid;
   input         lz_symbol_bus_t mtf_lz_dp_bus;
   output        lz_mtf_dp_ready;
   
   
   
   
   output        lz_be_dp_valid;
   output        lz_be_dp_bus_t lz_be_dp_bus;
   input         be_lz_dp_ready;

   input         sw_LZ_BYPASS_CONFIG;

   output logic [16:0] lz_bytes_decomp; 
   output logic [16:0] lz_hb_bytes;     
   output logic [11:0] lz_hb_head_ptr;  
   output logic [11:0] lz_hb_tail_ptr;  
   output logic [16:0] lz_local_bytes;   
   output logic [`LZ77D_STATS_WIDTH-1:0] xp10_decomp_lz77d_stat_events;
   
   output logic lz77_hb_ro_uncorrectable_ecc_error_a;
   output logic lz77_hb_ro_uncorrectable_ecc_error_b;
   output logic lz77_pfx0_ro_uncorrectable_ecc_error;
   output logic lz77_pfx1_ro_uncorrectable_ecc_error;

   

`ifndef RECONSTRUCT_BB

   logic [LZ77D_STAT_EVENTS_LIMIT:LZ77D_STAT_EVENTS_BASE] _xp10_decomp_lz77d_stat_events;
   logic lz77_pfx1_ro_uncorrectable_ecc_error_pre, lz77_pfx2_ro_uncorrectable_ecc_error_pre;

   assign lz77_pfx1_ro_uncorrectable_ecc_error = lz77_pfx1_ro_uncorrectable_ecc_error_pre | lz77_pfx2_ro_uncorrectable_ecc_error_pre;
   assign xp10_decomp_lz77d_stat_events = 64'(_xp10_decomp_lz77d_stat_events);

   
   cr_xp10_decomp_lz77 cr_xp10_decomp_lz77
     (
      
      .bimc_odat			(bimc_odat),
      .bimc_osync			(bimc_osync),
      .lz_fhp_prefix_hdr_ready		(lz_fhp_prefix_hdr_ready),
      .lz_fhp_pre_prefix_ready		(lz_fhp_pre_prefix_ready),
      .lz_fhp_usr_prefix_ready		(lz_fhp_usr_prefix_ready),
      .lz_fhp_dbg_data_ready		(lz_fhp_dbg_data_ready),
      .lz_mtf_dp_ready			(lz_mtf_dp_ready),
      .lz_be_dp_valid			(lz_be_dp_valid),
      .lz_be_dp_bus			(lz_be_dp_bus),
      .lz_bytes_decomp			(lz_bytes_decomp[16:0]),
      .lz_hb_bytes			(lz_hb_bytes[16:0]),
      .lz_hb_head_ptr			(lz_hb_head_ptr[11:0]),
      .lz_hb_tail_ptr			(lz_hb_tail_ptr[11:0]),
      .lz_local_bytes			(lz_local_bytes[16:0]),
      .xp10_decomp_lz77d_stat_events	(_xp10_decomp_lz77d_stat_events[LZ77D_STAT_EVENTS_LIMIT:LZ77D_STAT_EVENTS_BASE]), 
      .lz77_hb_ro_uncorrectable_ecc_error_a(lz77_hb_ro_uncorrectable_ecc_error_a),
      .lz77_hb_ro_uncorrectable_ecc_error_b(lz77_hb_ro_uncorrectable_ecc_error_b),
      .lz77_pfx0_ro_uncorrectable_ecc_error(lz77_pfx0_ro_uncorrectable_ecc_error),
      .lz77_pfx1_ro_uncorrectable_ecc_error(lz77_pfx1_ro_uncorrectable_ecc_error_pre), 
      .lz77_pfx2_ro_uncorrectable_ecc_error(lz77_pfx2_ro_uncorrectable_ecc_error_pre), 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .ovstb				(ovstb),
      .lvm				(lvm),
      .mlvm				(mlvm),
      .bimc_idat			(bimc_idat),
      .bimc_isync			(bimc_isync),
      .bimc_rst_n			(bimc_rst_n),
      .fhp_lz_prefix_hdr_valid		(fhp_lz_prefix_hdr_valid),
      .fhp_lz_prefix_hdr_bus		(fhp_lz_prefix_hdr_bus),
      .fhp_lz_prefix_valid		(fhp_lz_prefix_valid),
      .fhp_lz_prefix_dp_bus		(fhp_lz_prefix_dp_bus),
      .fhp_lz_dbg_data_valid		(fhp_lz_dbg_data_valid),
      .fhp_lz_dbg_data_bus		(fhp_lz_dbg_data_bus),
      .mtf_lz_dp_valid			(mtf_lz_dp_valid),
      .mtf_lz_dp_bus			(mtf_lz_dp_bus),
      .be_lz_dp_ready			(be_lz_dp_ready),
      .sw_LZ_BYPASS_CONFIG		(sw_LZ_BYPASS_CONFIG));
   
`endif 
   
endmodule 







