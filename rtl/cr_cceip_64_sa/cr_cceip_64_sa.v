/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_cceip_64_sa.vh"
`include "crPKG.svp"

module cr_cceip_64_sa

  (
  
  rbus_ring_o,
  
  clk, rst_n, scan_en, scan_mode, scan_rst_n, ovstb, lvm, mlvm,
  rbus_ring_i, cfg_start_addr, cfg_end_addr, crcc0_stat_events,
  crcc1_stat_events, crcg0_stat_events, crcgc0_stat_events,
  cg_stat_events, xp10_decomp_hufd_stat_events,
  xp10_decomp_lz77d_stat_events, osf_stat_events,
  huf_comp_stat_events, lz77_comp_stat_events, prefix_stat_events,
  isf_stat_events, huf_comp_xp10_decomp_lz77d_stat_events,
  cceip_64_sa_module_id
  );

`include "cr_structs.sv"

  import cr_cceip_64_saPKG::*;
  import cr_cceip_64_sa_regsPKG::*;
  
  
  
  input         clk;
  input         rst_n; 

  
  
  
  input         scan_en;
  input         scan_mode;
  input         scan_rst_n;

  
  
  
  input         ovstb;
  input         lvm;
  input         mlvm;

  
  
  
  input         rbus_ring_t rbus_ring_i;
  output        rbus_ring_t rbus_ring_o;
   input [`N_RBUS_ADDR_BITS-1:0] cfg_start_addr;
   input [`N_RBUS_ADDR_BITS-1:0] cfg_end_addr;

   
  
  
  
  input [`CRCGC_STATS_WIDTH-1:0]  crcc0_stat_events;
  input [`CRCGC_STATS_WIDTH-1:0]  crcc1_stat_events;
  input [`CRCGC_STATS_WIDTH-1:0]  crcg0_stat_events;
  input [`CRCGC_STATS_WIDTH-1:0]  crcgc0_stat_events;
  input [`CG_STATS_WIDTH-1:0]     cg_stat_events;
  
  input [`HUFD_STATS_WIDTH-1:0]   xp10_decomp_hufd_stat_events;
  input [`LZ77D_STATS_WIDTH-1:0]  xp10_decomp_lz77d_stat_events;
  input osf_stats_t               osf_stat_events;
  input huf_comp_stats_t          huf_comp_stat_events;
  input [`LZ77C_STATS_WIDTH-1:0]  lz77_comp_stat_events;
  input [`PREFIX_STATS_WIDTH-1:0] prefix_stat_events;
  input [`ISF_STATS_WIDTH-1:0]    isf_stat_events;
  input [`LZ77D_STATS_WIDTH-1:0]  huf_comp_xp10_decomp_lz77d_stat_events;
  
  
  
  input [`MODULE_ID_WIDTH-1:0]            cceip_64_sa_module_id;


  logic [49:0]             sa_snapshot[0:63];
  logic [49:0]             sa_count[0:63];
  logic                    regs_sa_clear_live;   
  sa_ctrl_t                regs_sa_ctrl [0:63];  
  logic                    regs_sa_snap;       
  
  
  

  cr_cceip_64_sa_core u_cr_cceip_64_sa_core
  (
   
   
   .sa_snapshot                         (sa_snapshot),
   .sa_count                            (sa_count),
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .crcc0_stat_events                   (crcc0_stat_events[`CRCGC_STATS_WIDTH-1:0]),
   .crcc1_stat_events                   (crcc1_stat_events[`CRCGC_STATS_WIDTH-1:0]),
   .crcg0_stat_events                   (crcg0_stat_events[`CRCGC_STATS_WIDTH-1:0]),
   .crcgc0_stat_events                  (crcgc0_stat_events[`CRCGC_STATS_WIDTH-1:0]),
   .cg_stat_events                      (cg_stat_events[`CG_STATS_WIDTH-1:0]),
   .xp10_decomp_hufd_stat_events        (xp10_decomp_hufd_stat_events[`HUFD_STATS_WIDTH-1:0]),
   .xp10_decomp_lz77d_stat_events       (xp10_decomp_lz77d_stat_events[`LZ77D_STATS_WIDTH-1:0]),
   .osf_stat_events                     (osf_stat_events),
   .huf_comp_stat_events                (huf_comp_stat_events),
   .lz77_comp_stat_events               (lz77_comp_stat_events[`LZ77C_STATS_WIDTH-1:0]),
   .prefix_stat_events                  (prefix_stat_events[`PREFIX_STATS_WIDTH-1:0]),
   .isf_stat_events                     (isf_stat_events[`ISF_STATS_WIDTH-1:0]),
   .huf_comp_xp10_decomp_lz77d_stat_events(huf_comp_xp10_decomp_lz77d_stat_events[`LZ77D_STATS_WIDTH-1:0]),
   .cceip_64_sa_module_id               (cceip_64_sa_module_id[`MODULE_ID_WIDTH-1:0]),
   .regs_sa_snap                        (regs_sa_snap),
   .regs_sa_clear_live                  (regs_sa_clear_live),
   .regs_sa_ctrl                        (regs_sa_ctrl));

  cr_cceip_64_sa_regfile

  u_cr_cceip_64_sa_regfile 
  (
   
   
   .rbus_ring_o                         (rbus_ring_o),
   .regs_sa_snap                        (regs_sa_snap),
   .regs_sa_clear_live                  (regs_sa_clear_live),
   .regs_sa_ctrl                        (regs_sa_ctrl),
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .rbus_ring_i                         (rbus_ring_i),
   .cfg_start_addr                      (cfg_start_addr[`N_RBUS_ADDR_BITS-1:0]),
   .cfg_end_addr                        (cfg_end_addr[`N_RBUS_ADDR_BITS-1:0]),
   .sa_snapshot                         (sa_snapshot),
   .sa_count                            (sa_count));
  
endmodule











