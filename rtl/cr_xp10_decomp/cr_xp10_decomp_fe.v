/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp_fe (
   
   bimc_odat, bimc_osync, xp10_decomp_ib_out, fhp_htf_bl_valid,
   fhp_htf_bl_bus, fhp_lz_prefix_hdr_valid, fhp_lz_prefix_hdr_bus,
   fhp_lz_prefix_valid, fhp_lz_prefix_dp_bus, fhp_be_dp_valid,
   fhp_be_dp_bus, fhp_be_usr_data, fhp_be_usr_valid,
   fhp_lz_dbg_data_valid, fhp_lz_dbg_data_bus, bhp_htf_hdr_dp_valid,
   bhp_htf_hdr_dp_bus, bhp_htf_hdrinfo_valid, bhp_htf_hdrinfo_bus,
   bhp_htf_status_ready, bhp_mtf_hdr_valid, bhp_mtf_hdr_bus,
   lfa_be_crc_valid, lfa_be_crc_bus, lfa_sdd_dp_valid, lfa_sdd_dp_bus,
   fe_lfa_ro_uncorrectable_ecc_error_a,
   fe_lfa_ro_uncorrectable_ecc_error_b, fe_tlvp_error, chu4k_raw_stb,
   chu4k_stb, chu8k_raw_stb, chu8k_stb, fhp_stall_stb, gzip_blk_stb,
   gzip_frm_stb, gzip_raw_blk_stb, lfa_stall_stb, pfx_crc_err_stb,
   phd_crc_err_stb, xp10_blk_stb, xp10_frm_pdh_stb, xp10_frm_pfx_stb,
   xp10_frm_stb, xp10_raw_blk_stb, xp9_blk_stb, xp9_crc_err_stb,
   xp9_frm_stb, xp9_raw_frm_stb, zlib_blk_stb, zlib_frm_stb,
   zlib_raw_blk_stb,
   
   clk, rst_n, ovstb, lvm, mlvm, bimc_idat, bimc_isync, bimc_rst_n,
   xp10_decomp_ib_in, htf_fhp_bl_ready, lz_fhp_prefix_hdr_ready,
   lz_fhp_pre_prefix_ready, lz_fhp_usr_prefix_ready, be_fhp_dp_ready,
   lz_fhp_dbg_data_ready, htf_bhp_hdr_dp_ready, htf_bhp_hdrinfo_ready,
   htf_bhp_status_valid, htf_bhp_status_bus, mtf_bhp_hdr_ready,
   sdd_lfa_dp_ready, sdd_lfa_ack_valid, sdd_lfa_ack_bus,
   sw_TLVP_ACTION_CFG0, sw_TLVP_ACTION_CFG1, xp10_decomp_module_id
   );

   import crPKG::*;
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
   
   
   
   input         axi4s_dp_bus_t xp10_decomp_ib_in;
   output        axi4s_dp_rdy_t xp10_decomp_ib_out;
   
   
   
   
   output        fhp_htf_bl_valid;
   output        fhp_htf_bl_bus_t fhp_htf_bl_bus;
   input         htf_fhp_bl_ready;
   
   
   
   
   output        fhp_lz_prefix_hdr_valid;
   output        fhp_lz_prefix_hdr_bus_t fhp_lz_prefix_hdr_bus;
   input         lz_fhp_prefix_hdr_ready;
   
   
   
   
   output        fhp_lz_prefix_valid;
   output        fhp_lz_prefix_dp_bus_t fhp_lz_prefix_dp_bus;
   input         lz_fhp_pre_prefix_ready;
   input         lz_fhp_usr_prefix_ready;
   
   
   
   
   output        fhp_be_dp_valid;
   output        fhp_be_dp_bus_t fhp_be_dp_bus;
   input         be_fhp_dp_ready;
   
   output        tlvp_if_bus_t fhp_be_usr_data;
   output        fhp_be_usr_valid;
   
   
   
   
   output        fhp_lz_dbg_data_valid;
   output        lz_symbol_bus_t fhp_lz_dbg_data_bus;
   input         lz_fhp_dbg_data_ready;
   
   
   
   
   output        bhp_htf_hdr_dp_valid;
   output        bhp_htf_hdr_dp_bus_t bhp_htf_hdr_dp_bus;
   input         htf_bhp_hdr_dp_ready;
   
   
   
   
   output        bhp_htf_hdrinfo_valid;
   output        bhp_htf_hdrinfo_bus_t   bhp_htf_hdrinfo_bus;
   input         htf_bhp_hdrinfo_ready;
   
   
   
   
   input         htf_bhp_status_valid;
   input         htf_bhp_status_bus_t htf_bhp_status_bus;
   output        bhp_htf_status_ready;
   
   
   
   
   output        bhp_mtf_hdr_valid;
   output        bhp_mtf_hdr_bus_t bhp_mtf_hdr_bus;
   input         mtf_bhp_hdr_ready;
   
   
   
   
   output        lfa_be_crc_valid;
   output        lfa_be_crc_bus_t lfa_be_crc_bus;
   
   
   
   
   output        lfa_sdd_dp_valid;
   output        lfa_sdd_dp_bus_t lfa_sdd_dp_bus;
   input         sdd_lfa_dp_ready;
   
   
   
   
   input         sdd_lfa_ack_valid;
   input         sdd_lfa_ack_bus_t sdd_lfa_ack_bus;

   input [31:0]  sw_TLVP_ACTION_CFG0;     
   input [31:0]  sw_TLVP_ACTION_CFG1;     
   input [`MODULE_ID_WIDTH-1:0]    xp10_decomp_module_id;

   


   output logic                   fe_lfa_ro_uncorrectable_ecc_error_a;
   output logic                   fe_lfa_ro_uncorrectable_ecc_error_b;
   output logic                   fe_tlvp_error;


   output logic                   chu4k_raw_stb;          
   output logic                   chu4k_stb;              
   output logic                   chu8k_raw_stb;          
   output logic                   chu8k_stb;              
   output logic                   fhp_stall_stb;          
   output logic                   gzip_blk_stb;           
   output logic                   gzip_frm_stb;           
   output logic                   gzip_raw_blk_stb;       
   output logic                   lfa_stall_stb;          
   output logic                   pfx_crc_err_stb;        
   output logic                   phd_crc_err_stb;        
   output logic                   xp10_blk_stb;           
   output logic                   xp10_frm_pdh_stb;       
   output logic                   xp10_frm_pfx_stb;       
   output logic                   xp10_frm_stb;           
   output logic                   xp10_raw_blk_stb;       
   output logic                   xp9_blk_stb;            
   output logic                   xp9_crc_err_stb;        
   output logic                   xp9_frm_stb;            
   output logic                   xp9_raw_frm_stb;        
   output logic                   zlib_blk_stb;           
   output logic                   zlib_frm_stb;           
   output logic                   zlib_raw_blk_stb;       



logic                   bhp_lfa_dp_ready;       
bhp_lfa_status_bus_t    bhp_lfa_htf_status_bus; 
logic                   bhp_lfa_htf_status_valid;
bhp_lfa_status_bus_t    bhp_lfa_status_bus;     
logic                   bhp_lfa_status_valid;   
logic                   bhp_lfa_stbl_sent;      
logic                   fhp_lfa_clear_sof_fifo; 
fe_dp_bus_t             fhp_lfa_dp_bus;         
logic                   fhp_lfa_dp_valid;       
fe_eof_bus_t            fhp_lfa_eof_bus;        
fe_sof_bus_t            fhp_lfa_sof_bus;        
logic                   fhp_lfa_sof_valid;      
logic                   fhp_tlvp_pt_empty;      
logic                   fhp_tlvp_pt_rd;         
tlvp_if_bus_t           fhp_tlvp_pt_tlv;        
logic                   fhp_tlvp_usr_empty;     
logic                   fhp_tlvp_usr_rd;        
tlvp_if_bus_t           fhp_tlvp_usr_tlv;       
logic [5:0]             lfa_bhp_align_bits;     
fe_dp_bus_t             lfa_bhp_dp_bus;         
logic                   lfa_bhp_dp_valid;       
fe_sof_bus_t            lfa_bhp_sof_bus;        
logic                   lfa_bhp_sof_valid;      
logic                   lfa_fhp_dp_ready;       
logic                   lfa_fhp_sof_ready;      


   
   cr_xp10_decomp_fe_fhp fhp_inst (
                                   
                                   .fhp_tlvp_pt_rd      (fhp_tlvp_pt_rd),
                                   .fhp_tlvp_usr_rd     (fhp_tlvp_usr_rd),
                                   .fhp_htf_bl_bus      (fhp_htf_bl_bus),
                                   .fhp_htf_bl_valid    (fhp_htf_bl_valid),
                                   .fhp_lz_prefix_hdr_valid(fhp_lz_prefix_hdr_valid),
                                   .fhp_lz_prefix_hdr_bus(fhp_lz_prefix_hdr_bus),
                                   .fhp_lz_prefix_valid (fhp_lz_prefix_valid),
                                   .fhp_lz_prefix_dp_bus(fhp_lz_prefix_dp_bus),
                                   .fhp_be_dp_valid     (fhp_be_dp_valid),
                                   .fhp_be_dp_bus       (fhp_be_dp_bus),
                                   .fhp_lz_dbg_data_valid(fhp_lz_dbg_data_valid),
                                   .fhp_lz_dbg_data_bus (fhp_lz_dbg_data_bus),
                                   .fhp_lfa_sof_valid   (fhp_lfa_sof_valid),
                                   .fhp_lfa_sof_bus     (fhp_lfa_sof_bus),
                                   .fhp_lfa_clear_sof_fifo(fhp_lfa_clear_sof_fifo),
                                   .fhp_lfa_dp_bus      (fhp_lfa_dp_bus),
                                   .fhp_lfa_dp_valid    (fhp_lfa_dp_valid),
                                   .fhp_lfa_eof_bus     (fhp_lfa_eof_bus),
                                   .fhp_be_usr_data     (fhp_be_usr_data),
                                   .fhp_be_usr_valid    (fhp_be_usr_valid),
                                   .xp9_frm_stb         (xp9_frm_stb),
                                   .xp10_frm_stb        (xp10_frm_stb),
                                   .xp9_raw_frm_stb     (xp9_raw_frm_stb),
                                   .gzip_frm_stb        (gzip_frm_stb),
                                   .zlib_frm_stb        (zlib_frm_stb),
                                   .chu4k_stb           (chu4k_stb),
                                   .chu8k_stb           (chu8k_stb),
                                   .pfx_crc_err_stb     (pfx_crc_err_stb),
                                   .phd_crc_err_stb     (phd_crc_err_stb),
                                   .xp10_frm_pfx_stb    (xp10_frm_pfx_stb),
                                   .xp10_frm_pdh_stb    (xp10_frm_pdh_stb),
                                   .fhp_stall_stb       (fhp_stall_stb),
                                   .lfa_stall_stb       (lfa_stall_stb),
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .fhp_tlvp_pt_tlv     (fhp_tlvp_pt_tlv),
                                   .fhp_tlvp_pt_empty   (fhp_tlvp_pt_empty),
                                   .fhp_tlvp_usr_empty  (fhp_tlvp_usr_empty),
                                   .fhp_tlvp_usr_tlv    (fhp_tlvp_usr_tlv),
                                   .htf_fhp_bl_ready    (htf_fhp_bl_ready),
                                   .lz_fhp_prefix_hdr_ready(lz_fhp_prefix_hdr_ready),
                                   .lz_fhp_pre_prefix_ready(lz_fhp_pre_prefix_ready),
                                   .lz_fhp_usr_prefix_ready(lz_fhp_usr_prefix_ready),
                                   .be_fhp_dp_ready     (be_fhp_dp_ready),
                                   .lz_fhp_dbg_data_ready(lz_fhp_dbg_data_ready),
                                   .lfa_fhp_sof_ready   (lfa_fhp_sof_ready),
                                   .lfa_fhp_dp_ready    (lfa_fhp_dp_ready));

   cr_xp10_decomp_fe_lfa lfa_inst (
                                   
                                   .bimc_odat           (bimc_odat),
                                   .bimc_osync          (bimc_osync),
                                   .lfa_sdd_dp_valid    (lfa_sdd_dp_valid),
                                   .lfa_sdd_dp_bus      (lfa_sdd_dp_bus),
                                   .lfa_fhp_sof_ready   (lfa_fhp_sof_ready),
                                   .lfa_fhp_dp_ready    (lfa_fhp_dp_ready),
                                   .lfa_bhp_dp_bus      (lfa_bhp_dp_bus),
                                   .lfa_bhp_dp_valid    (lfa_bhp_dp_valid),
                                   .lfa_bhp_align_bits  (lfa_bhp_align_bits[5:0]),
                                   .lfa_bhp_sof_valid   (lfa_bhp_sof_valid),
                                   .lfa_bhp_sof_bus     (lfa_bhp_sof_bus),
                                   .lfa_be_crc_valid    (lfa_be_crc_valid),
                                   .lfa_be_crc_bus      (lfa_be_crc_bus),
                                   .fe_lfa_ro_uncorrectable_ecc_error_a(fe_lfa_ro_uncorrectable_ecc_error_a),
                                   .fe_lfa_ro_uncorrectable_ecc_error_b(fe_lfa_ro_uncorrectable_ecc_error_b),
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .ovstb               (ovstb),
                                   .lvm                 (lvm),
                                   .mlvm                (mlvm),
                                   .bimc_idat           (bimc_idat),
                                   .bimc_isync          (bimc_isync),
                                   .bimc_rst_n          (bimc_rst_n),
                                   .sdd_lfa_dp_ready    (sdd_lfa_dp_ready),
                                   .sdd_lfa_ack_valid   (sdd_lfa_ack_valid),
                                   .sdd_lfa_ack_bus     (sdd_lfa_ack_bus),
                                   .fhp_lfa_sof_valid   (fhp_lfa_sof_valid),
                                   .fhp_lfa_sof_bus     (fhp_lfa_sof_bus),
                                   .fhp_lfa_clear_sof_fifo(fhp_lfa_clear_sof_fifo),
                                   .fhp_lfa_dp_bus      (fhp_lfa_dp_bus),
                                   .fhp_lfa_dp_valid    (fhp_lfa_dp_valid),
                                   .fhp_lfa_eof_bus     (fhp_lfa_eof_bus),
                                   .bhp_lfa_dp_ready    (bhp_lfa_dp_ready),
                                   .bhp_lfa_status_valid(bhp_lfa_status_valid),
                                   .bhp_lfa_status_bus  (bhp_lfa_status_bus),
                                   .bhp_lfa_stbl_sent   (bhp_lfa_stbl_sent),
                                   .bhp_lfa_htf_status_valid(bhp_lfa_htf_status_valid),
                                   .bhp_lfa_htf_status_bus(bhp_lfa_htf_status_bus));

   cr_xp10_decomp_fe_bhp bhp_inst (
                                   
                                   .bhp_htf_hdr_dp_valid(bhp_htf_hdr_dp_valid),
                                   .bhp_htf_hdr_dp_bus  (bhp_htf_hdr_dp_bus),
                                   .bhp_htf_hdrinfo_valid(bhp_htf_hdrinfo_valid),
                                   .bhp_htf_hdrinfo_bus (bhp_htf_hdrinfo_bus),
                                   .bhp_htf_status_ready(bhp_htf_status_ready),
                                   .bhp_lfa_dp_ready    (bhp_lfa_dp_ready),
                                   .bhp_lfa_status_valid(bhp_lfa_status_valid),
                                   .bhp_lfa_status_bus  (bhp_lfa_status_bus),
                                   .bhp_lfa_htf_status_valid(bhp_lfa_htf_status_valid),
                                   .bhp_lfa_htf_status_bus(bhp_lfa_htf_status_bus),
                                   .bhp_mtf_hdr_valid   (bhp_mtf_hdr_valid),
                                   .bhp_mtf_hdr_bus     (bhp_mtf_hdr_bus),
                                   .xp9_blk_stb         (xp9_blk_stb),
                                   .xp10_blk_stb        (xp10_blk_stb),
                                   .xp10_raw_blk_stb    (xp10_raw_blk_stb),
                                   .zlib_blk_stb        (zlib_blk_stb),
                                   .zlib_raw_blk_stb    (zlib_raw_blk_stb),
                                   .gzip_blk_stb        (gzip_blk_stb),
                                   .gzip_raw_blk_stb    (gzip_raw_blk_stb),
                                   .xp9_crc_err_stb     (xp9_crc_err_stb),
                                   .chu4k_raw_stb       (chu4k_raw_stb),
                                   .chu8k_raw_stb       (chu8k_raw_stb),
                                   .bhp_lfa_stbl_sent   (bhp_lfa_stbl_sent),
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .ovstb               (ovstb),
                                   .lvm                 (lvm),
                                   .mlvm                (mlvm),
                                   .htf_bhp_hdr_dp_ready(htf_bhp_hdr_dp_ready),
                                   .htf_bhp_hdrinfo_ready(htf_bhp_hdrinfo_ready),
                                   .htf_bhp_status_valid(htf_bhp_status_valid),
                                   .htf_bhp_status_bus  (htf_bhp_status_bus),
                                   .lfa_bhp_dp_valid    (lfa_bhp_dp_valid),
                                   .lfa_bhp_dp_bus      (lfa_bhp_dp_bus),
                                   .lfa_bhp_align_bits  (lfa_bhp_align_bits[5:0]),
                                   .lfa_bhp_sof_valid   (lfa_bhp_sof_valid),
                                   .lfa_bhp_sof_bus     (lfa_bhp_sof_bus),
                                   .mtf_bhp_hdr_ready   (mtf_bhp_hdr_ready));
   

   cr_xp10_decomp_fe_tlvp tlvp_inst (
                                     
                                     .xp10_decomp_ib_out(xp10_decomp_ib_out),
                                     .fhp_tlvp_pt_tlv   (fhp_tlvp_pt_tlv),
                                     .fhp_tlvp_pt_empty (fhp_tlvp_pt_empty),
                                     .fhp_tlvp_usr_empty(fhp_tlvp_usr_empty),
                                     .fhp_tlvp_usr_tlv  (fhp_tlvp_usr_tlv),
                                     .fe_tlvp_error     (fe_tlvp_error),
                                     
                                     .clk               (clk),
                                     .rst_n             (rst_n),
                                     .xp10_decomp_ib_in (xp10_decomp_ib_in),
                                     .fhp_tlvp_pt_rd    (fhp_tlvp_pt_rd),
                                     .fhp_tlvp_usr_rd   (fhp_tlvp_usr_rd),
                                     .sw_TLVP_ACTION_CFG0(sw_TLVP_ACTION_CFG0[31:0]),
                                     .sw_TLVP_ACTION_CFG1(sw_TLVP_ACTION_CFG1[31:0]),
                                     .xp10_decomp_module_id(xp10_decomp_module_id[`MODULE_ID_WIDTH-1:0]));
   
endmodule 







