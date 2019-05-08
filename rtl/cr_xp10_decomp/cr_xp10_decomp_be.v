/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp_be (
   
   xp10_decomp_ob_out, be_fhp_dp_ready, be_lz_dp_ready,
   
   clk, rst_n, xp10_decomp_ob_in, lfa_be_crc_valid, lfa_be_crc_bus,
   fhp_be_dp_valid, fhp_be_dp_bus, fhp_be_usr_data, fhp_be_usr_valid,
   lz_be_dp_valid, lz_be_dp_bus, sw_LZ_BYPASS_CONFIG,
   sw_IGNORE_CRC_CONFIG, sw_LZ_DECOMP_OLIMIT, cceip_cfg
   );

   import crPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   
   
   
   input         clk;
   input         rst_n;
   
   
   
   
   input         axi4s_dp_rdy_t xp10_decomp_ob_in;
   output        axi4s_dp_bus_t xp10_decomp_ob_out;

   
   
   
   input         lfa_be_crc_valid;
   input         lfa_be_crc_bus_t lfa_be_crc_bus;

   
   
   
   input         fhp_be_dp_valid;
   input         fhp_be_dp_bus_t fhp_be_dp_bus;
   output        be_fhp_dp_ready;

   input         tlvp_if_bus_t  fhp_be_usr_data;
   input         fhp_be_usr_valid;
   
   
   
   
   input         lz_be_dp_valid;
   input         lz_be_dp_bus_t lz_be_dp_bus;
   output        be_lz_dp_ready;

   input         sw_LZ_BYPASS_CONFIG;
   input         sw_IGNORE_CRC_CONFIG;
   
   input [23:0]  sw_LZ_DECOMP_OLIMIT;

   input         cceip_cfg;
   
   
   
   
   logic                lz_data_afull;          
   logic                lz_data_full;           
   tlvp_if_bus_t        lz_data_tlv;            
   logic                lz_data_wr;             
   logic                pt_ob_aempty;           
   logic                pt_ob_empty;            
   logic                pt_ob_rd;               
   tlvp_if_bus_t        pt_ob_tlv;              
   
   
   cr_xp10_decomp_be_fifos be_fifos (
                                     
                                     .be_fhp_dp_ready   (be_fhp_dp_ready),
                                     .be_lz_dp_ready    (be_lz_dp_ready),
                                     .pt_ob_empty       (pt_ob_empty),
                                     .pt_ob_aempty      (pt_ob_aempty),
                                     .pt_ob_tlv         (pt_ob_tlv),
                                     .lz_data_wr        (lz_data_wr),
                                     .lz_data_tlv       (lz_data_tlv),
                                     
                                     .clk               (clk),
                                     .rst_n             (rst_n),
                                     .fhp_be_dp_valid   (fhp_be_dp_valid),
                                     .fhp_be_dp_bus     (fhp_be_dp_bus),
                                     .fhp_be_usr_data   (fhp_be_usr_data),
                                     .fhp_be_usr_valid  (fhp_be_usr_valid),
                                     .lz_be_dp_valid    (lz_be_dp_valid),
                                     .lz_be_dp_bus      (lz_be_dp_bus),
                                     .lfa_be_crc_bus    (lfa_be_crc_bus),
                                     .lfa_be_crc_valid  (lfa_be_crc_valid),
                                     .pt_ob_rd          (pt_ob_rd),
                                     .lz_data_full      (lz_data_full),
                                     .lz_data_afull     (lz_data_afull),
                                     .sw_LZ_BYPASS_CONFIG(sw_LZ_BYPASS_CONFIG),
                                     .sw_IGNORE_CRC_CONFIG(sw_IGNORE_CRC_CONFIG),
                                     .sw_LZ_DECOMP_OLIMIT(sw_LZ_DECOMP_OLIMIT[23:0]),
                                     .cceip_cfg         (cceip_cfg));

   cr_xp10_decomp_be_tlvp tlvp_inst (
                                     
                                     .xp10_decomp_ob_out(xp10_decomp_ob_out),
                                     .pt_ob_rd          (pt_ob_rd),
                                     .lz_data_full      (lz_data_full),
                                     .lz_data_afull     (lz_data_afull),
                                     
                                     .clk               (clk),
                                     .rst_n             (rst_n),
                                     .xp10_decomp_ob_in (xp10_decomp_ob_in),
                                     .pt_ob_empty       (pt_ob_empty),
                                     .pt_ob_aempty      (pt_ob_aempty),
                                     .pt_ob_tlv         (pt_ob_tlv),
                                     .lz_data_wr        (lz_data_wr),
                                     .lz_data_tlv       (lz_data_tlv));
   
   
endmodule 








