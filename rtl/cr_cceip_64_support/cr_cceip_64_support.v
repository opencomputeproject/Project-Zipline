/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_cceip_64_support.vh"

module cr_cceip_64_support

  (
  
  top_bimc_mstr_rst_n, top_bimc_mstr_osync, top_bimc_mstr_odat,
  crcg0_ib_out, crcc1_ib_out, rbus_ring_o, df_mux_ob_out,
  im_consumed_lz77c, im_consumed_lz77d, im_consumed_htf_bl,
  im_consumed_xpc, im_consumed_xpd, im_consumed_he_sh,
  im_consumed_he_lng, im_consumed_he_st_sh, im_consumed_he_st_lng,
  cceip_int, cceip_idle, sup_osf_halt,
  
  clk, rst_n, scan_en, scan_mode, scan_rst_n, ovstb, lvm, mlvm,
  top_bimc_mstr_idat, top_bimc_mstr_isync, crcc0_crcg0_ib_out,
  crcg0_ib_in, cg_crcc1_ib_out, crcc1_ib_in, rbus_ring_i,
  cfg_start_addr, cfg_end_addr, df_mux_ob_in, im_available_lz77c,
  im_available_lz77d, im_available_htf_bl, im_available_xpc,
  im_available_xpd, im_available_he_lng, im_available_he_sh,
  im_available_he_st_lng, im_available_he_st_sh, osf_sup_cqe_exit,
  isf_sup_cqe_exit, isf_sup_cqe_rx, isf_sup_rqe_rx, prefix_int,
  prefix_attach_int, lz77_comp_int, huf_comp_int, xp10_decomp_int,
  crcgc0_int, crcg0_int, crcc0_int, crcc1_int, cg_int, su_int,
  osf_int, isf_int
  );

`include "cr_structs.sv"
`include "ccx_std.vh"

  import cr_cceip_64_supportPKG::*;

  import cr_cceip_64_support_regsPKG::*;
  
  
  
  input                        clk;
  input                        rst_n; 

  
  
  
  input                        scan_en;
  input                        scan_mode;
  input                        scan_rst_n;

  
  
  
  input                        ovstb;
  input                        lvm;
  input                        mlvm;

  
  
  
  input                        top_bimc_mstr_idat;
  input                        top_bimc_mstr_isync;
  output                       top_bimc_mstr_rst_n;
  output                       top_bimc_mstr_osync;
  output                       top_bimc_mstr_odat;
 
  
  
  
  input  axi4s_dp_rdy_t        crcc0_crcg0_ib_out;
  input  axi4s_dp_bus_t        crcg0_ib_in;
  output axi4s_dp_rdy_t        crcg0_ib_out;

  input  axi4s_dp_rdy_t        cg_crcc1_ib_out;
  input  axi4s_dp_bus_t        crcc1_ib_in;
  output axi4s_dp_rdy_t        crcc1_ib_out;

  
  
  
  input  rbus_ring_t            rbus_ring_i;
  output rbus_ring_t            rbus_ring_o;
  input [`N_RBUS_ADDR_BITS-1:0] cfg_start_addr;
  input [`N_RBUS_ADDR_BITS-1:0] cfg_end_addr;
  
  
  
  input  axi4s_dp_rdy_t         df_mux_ob_in;
  output axi4s_dp_bus_t         df_mux_ob_out;

  
  
  
  input  im_available_t         im_available_lz77c;
  input  im_available_t         im_available_lz77d;
  input  im_available_t         im_available_htf_bl;
  input  im_available_t         im_available_xpc;
  input  im_available_t         im_available_xpd;
  input  im_available_t         im_available_he_lng;
  input  im_available_t         im_available_he_sh;
  input  im_available_t         im_available_he_st_lng;
  input  im_available_t         im_available_he_st_sh;
  output im_consumed_t          im_consumed_lz77c;
  output im_consumed_t          im_consumed_lz77d;
  output im_consumed_t          im_consumed_htf_bl;
  output im_consumed_t          im_consumed_xpc;
  output im_consumed_t          im_consumed_xpd;
  output im_consumed_t          im_consumed_he_sh;
  output im_consumed_t          im_consumed_he_lng;
  output im_consumed_t          im_consumed_he_st_sh;
  output im_consumed_t          im_consumed_he_st_lng;
  
  
  
  
  input                         osf_sup_cqe_exit;
  input                         isf_sup_cqe_exit;
  input                         isf_sup_cqe_rx;
  input                         isf_sup_rqe_rx;

  
  
  
  output reg                    cceip_int;

  input  generic_int_t          prefix_int;
  input  tlvp_int_t             prefix_attach_int;
  input  tlvp_int_t             lz77_comp_int;
  input  generic_int_t          huf_comp_int;
  input  generic_int_t          xp10_decomp_int;
  input  tlvp_int_t             crcgc0_int;
  input  tlvp_int_t             crcg0_int;
  input  tlvp_int_t             crcc0_int;
  input  tlvp_int_t             crcc1_int;
  input  tlvp_int_t             cg_int;
  input  ecc_int_t              su_int;
  input  osf_int_t              osf_int;
  input  isf_int_t              isf_int;

  
  
  
  output reg                    cceip_idle;

  
  
  
  output reg                    sup_osf_halt;

  
  
  logic                 cceip_int0;             
  logic                 cceip_int1;             
  ctl_t                 ctl_config;             
  logic [`CR_CCEIP_64_SUPPORT_DF_MUX_CTRL_T_DF_MUX_SEL_DECL] df_mux_sel;
  

  
  pipe_stat_t     pipe_stat;

  cr_cceip_64_support_core u_cr_cceip_64_support_core
  (
   
   
   .crcg0_ib_out                        (crcg0_ib_out),
   .crcc1_ib_out                        (crcc1_ib_out),
   .df_mux_ob_out                       (df_mux_ob_out),
   .pipe_stat                           (pipe_stat),
   .cceip_int                           (cceip_int),
   .cceip_idle                          (cceip_idle),
   .sup_osf_halt                        (sup_osf_halt),
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .crcc0_crcg0_ib_out                  (crcc0_crcg0_ib_out),
   .crcg0_ib_in                         (crcg0_ib_in),
   .cg_crcc1_ib_out                     (cg_crcc1_ib_out),
   .crcc1_ib_in                         (crcc1_ib_in),
   .df_mux_sel                          (df_mux_sel[`CR_CCEIP_64_SUPPORT_DF_MUX_CTRL_T_DF_MUX_SEL_DECL]),
   .df_mux_ob_in                        (df_mux_ob_in),
   .osf_sup_cqe_exit                    (osf_sup_cqe_exit),
   .isf_sup_cqe_exit                    (isf_sup_cqe_exit),
   .isf_sup_cqe_rx                      (isf_sup_cqe_rx),
   .isf_sup_rqe_rx                      (isf_sup_rqe_rx),
   .cceip_int0                          (cceip_int0),
   .cceip_int1                          (cceip_int1));

  cr_cceip_64_support_regfile
 
  u_cr_cceip_64_support_regfile 
  (
   
   
   .rbus_ring_o                         (rbus_ring_o),
   .im_consumed_lz77c                   (im_consumed_lz77c),
   .im_consumed_lz77d                   (im_consumed_lz77d),
   .im_consumed_htf_bl                  (im_consumed_htf_bl),
   .im_consumed_xpc                     (im_consumed_xpc),
   .im_consumed_xpd                     (im_consumed_xpd),
   .im_consumed_he_sh                   (im_consumed_he_sh),
   .im_consumed_he_lng                  (im_consumed_he_lng),
   .im_consumed_he_st_sh                (im_consumed_he_st_sh),
   .im_consumed_he_st_lng               (im_consumed_he_st_lng),
   .top_bimc_mstr_rst_n                 (top_bimc_mstr_rst_n),
   .top_bimc_mstr_osync                 (top_bimc_mstr_osync),
   .top_bimc_mstr_odat                  (top_bimc_mstr_odat),
   .cceip_int0                          (cceip_int0),
   .cceip_int1                          (cceip_int1),
   .ctl_config                          (ctl_config),
   .df_mux_sel                          (df_mux_sel[`CR_CCEIP_64_SUPPORT_DF_MUX_CTRL_T_DF_MUX_SEL_DECL]),
   
   .rst_n                               (rst_n),
   .clk                                 (clk),
   .rbus_ring_i                         (rbus_ring_i),
   .cfg_start_addr                      (cfg_start_addr[`N_RBUS_ADDR_BITS-1:0]),
   .cfg_end_addr                        (cfg_end_addr[`N_RBUS_ADDR_BITS-1:0]),
   .im_available_lz77c                  (im_available_lz77c),
   .im_available_lz77d                  (im_available_lz77d),
   .im_available_htf_bl                 (im_available_htf_bl),
   .im_available_xpc                    (im_available_xpc),
   .im_available_xpd                    (im_available_xpd),
   .im_available_he_lng                 (im_available_he_lng),
   .im_available_he_sh                  (im_available_he_sh),
   .im_available_he_st_lng              (im_available_he_st_lng),
   .im_available_he_st_sh               (im_available_he_st_sh),
   .top_bimc_mstr_idat                  (top_bimc_mstr_idat),
   .top_bimc_mstr_isync                 (top_bimc_mstr_isync),
   .pipe_stat                           (pipe_stat),
   .prefix_int                          (prefix_int),
   .prefix_attach_int                   (prefix_attach_int),
   .lz77_comp_int                       (lz77_comp_int),
   .huf_comp_int                        (huf_comp_int),
   .xp10_decomp_int                     (xp10_decomp_int),
   .crcgc0_int                          (crcgc0_int),
   .crcg0_int                           (crcg0_int),
   .crcc0_int                           (crcc0_int),
   .crcc1_int                           (crcc1_int),
   .cg_int                              (cg_int),
   .su_int                              (su_int),
   .osf_int                             (osf_int),
   .isf_int                             (isf_int));
  
endmodule












