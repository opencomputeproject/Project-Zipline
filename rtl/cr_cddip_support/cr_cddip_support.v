/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_cddip_support.vh"

module cr_cddip_support

  (
  
  top_bimc_mstr_rst_n, top_bimc_mstr_osync, top_bimc_mstr_odat,
  rbus_ring_o, im_consumed_htf_bl, im_consumed_lz77d, im_consumed_xpd,
  cddip_int, cddip_idle, sup_osf_halt,
  
  clk, rst_n, scan_en, scan_mode, scan_rst_n, ovstb, lvm, mlvm,
  top_bimc_mstr_idat, top_bimc_mstr_isync, rbus_ring_i,
  cfg_start_addr, cfg_end_addr, im_available_htf_bl,
  im_available_lz77d, im_available_xpd, osf_sup_cqe_exit,
  isf_sup_cqe_exit, isf_sup_cqe_rx, isf_sup_rqe_rx, prefix_attach_int,
  xp10_decomp_int, crcg0_int, crcc0_int, cg_int, su_int, osf_int,
  isf_int
  );

`include "cr_structs.sv"
`include "ccx_std.vh"


  import cr_cddip_supportPKG::*;
  import cr_cddip_support_regsPKG::*;
  
  
  
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
 
   
  
  
  input  rbus_ring_t           rbus_ring_i;
  output rbus_ring_t           rbus_ring_o;
   input [`N_RBUS_ADDR_BITS-1:0] cfg_start_addr;
   input [`N_RBUS_ADDR_BITS-1:0] cfg_end_addr;

  
  
  
  input  im_available_t        im_available_htf_bl;
  input  im_available_t        im_available_lz77d;
  input  im_available_t        im_available_xpd;
  output im_consumed_t         im_consumed_htf_bl;
  output im_consumed_t         im_consumed_lz77d;
  output im_consumed_t         im_consumed_xpd;
  
  
  
  input                        osf_sup_cqe_exit;
  input                        isf_sup_cqe_exit;
  input                        isf_sup_cqe_rx;
  input                        isf_sup_rqe_rx;

  
  
  
  output                       cddip_int;

  input  tlvp_int_t            prefix_attach_int;
  input  generic_int_t         xp10_decomp_int;
  input  tlvp_int_t            crcg0_int;
  input  tlvp_int_t            crcc0_int;
  input  tlvp_int_t            cg_int;
  input  ecc_int_t             su_int;
  input  osf_int_t             osf_int;
  input  isf_int_t             isf_int;

  
  
  
  output reg                   cddip_idle;

  
  
  
  output reg                   sup_osf_halt;

  
  
  ctl_t                 ctl_config;             
  logic                 pre_cddip_int;          
  

  
  pipe_stat_t     pipe_stat;

  cr_cddip_support_core u_cr_cddip_support_core
  (
   
   
   .pipe_stat                           (pipe_stat),
   .cddip_int                           (cddip_int),
   .cddip_idle                          (cddip_idle),
   .sup_osf_halt                        (sup_osf_halt),
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .osf_sup_cqe_exit                    (osf_sup_cqe_exit),
   .isf_sup_cqe_exit                    (isf_sup_cqe_exit),
   .isf_sup_cqe_rx                      (isf_sup_cqe_rx),
   .isf_sup_rqe_rx                      (isf_sup_rqe_rx),
   .pre_cddip_int                       (pre_cddip_int));


  cr_cddip_support_regfile
    
  u_cr_cddip_support_regfile 
  (
   
   
   .rbus_ring_o                         (rbus_ring_o),
   .im_consumed_lz77d                   (im_consumed_lz77d),
   .im_consumed_htf_bl                  (im_consumed_htf_bl),
   .im_consumed_xpd                     (im_consumed_xpd),
   .top_bimc_mstr_rst_n                 (top_bimc_mstr_rst_n),
   .top_bimc_mstr_osync                 (top_bimc_mstr_osync),
   .top_bimc_mstr_odat                  (top_bimc_mstr_odat),
   .pre_cddip_int                       (pre_cddip_int),
   .ctl_config                          (ctl_config),
   
   .rst_n                               (rst_n),
   .clk                                 (clk),
   .cfg_start_addr                      (cfg_start_addr[`N_RBUS_ADDR_BITS-1:0]),
   .cfg_end_addr                        (cfg_end_addr[`N_RBUS_ADDR_BITS-1:0]),
   .rbus_ring_i                         (rbus_ring_i),
   .im_available_lz77d                  (im_available_lz77d),
   .im_available_htf_bl                 (im_available_htf_bl),
   .im_available_xpd                    (im_available_xpd),
   .top_bimc_mstr_idat                  (top_bimc_mstr_idat),
   .top_bimc_mstr_isync                 (top_bimc_mstr_isync),
   .pipe_stat                           (pipe_stat),
   .prefix_attach_int                   (prefix_attach_int),
   .xp10_decomp_int                     (xp10_decomp_int),
   .crcg0_int                           (crcg0_int),
   .crcc0_int                           (crcc0_int),
   .cg_int                              (cg_int),
   .su_int                              (su_int),
   .osf_int                             (osf_int),
   .isf_int                             (isf_int));
  
endmodule












