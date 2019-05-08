/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/








module cr_xp10_decomp_regfile 

   (
   
   rbus_ring_o, xp10_decomp_ob_out, xp10_decomp_ob_in_mod,
   im_available_xpd, im_available_lz77d, im_available_htf_bl,
   sw_TLVP_ACTION_CFG0, sw_TLVP_ACTION_CFG1, bimc_odat, bimc_osync,
   bimc_rst_n, bimc_ecc_error, bimc_interrupt, sw_LZ_BYPASS_CONFIG,
   sw_IGNORE_CRC_CONFIG, xpd_im_ready, htf_bl_im_ready,
   sw_LZ_DECOMP_OLIMIT,
   
   rst_n, clk, rbus_ring_i, cfg_start_addr, cfg_end_addr,
   xp10_decomp_ob_out_pre, xp10_decomp_ob_in, im_consumed_xpd,
   im_consumed_lz77d, im_consumed_htf_bl, bimc_idat, bimc_isync,
   xpd_im_valid, xpd_im_data, htf_bl_im_valid, htf_bl_im_data,
   lz_bytes_decomp, lz_hb_bytes, lz_local_bytes, lz_hb_tail_ptr,
   lz_hb_head_ptr
   );

`include "bimc_master.vh"
   import crPKG::*;
   import cr_xp10_decompPKG::*;
   import cr_xp10_decomp_regfilePKG::*;
   
   
   output                              rbus_ring_t rbus_ring_o;
   
   input logic                         rst_n;
   input logic                         clk;
   input                               rbus_ring_t rbus_ring_i;

   input [`N_RBUS_ADDR_BITS-1:0]       cfg_start_addr;
   input [`N_RBUS_ADDR_BITS-1:0]       cfg_end_addr;
  
   
   input                               axi4s_dp_bus_t xp10_decomp_ob_out_pre;
   output                              axi4s_dp_bus_t xp10_decomp_ob_out;
   input                               axi4s_dp_rdy_t xp10_decomp_ob_in;
   output                              axi4s_dp_rdy_t xp10_decomp_ob_in_mod;

   input                               im_consumed_t  im_consumed_xpd;
   output                              im_available_t im_available_xpd;
   input                               im_consumed_t im_consumed_lz77d;
   output                              im_available_t  im_available_lz77d;
   input                               im_consumed_t im_consumed_htf_bl;
   output                              im_available_t im_available_htf_bl;
   output logic [31:0]                 sw_TLVP_ACTION_CFG0;
   output logic [31:0]                 sw_TLVP_ACTION_CFG1;
   
   output logic                        bimc_odat;
   output logic                        bimc_osync;
   output logic                        bimc_rst_n;
   input                               bimc_idat;
   input                               bimc_isync;
   output logic                        bimc_ecc_error;
   output logic                        bimc_interrupt;
   
   output logic                        sw_LZ_BYPASS_CONFIG;     
   output logic                        sw_IGNORE_CRC_CONFIG;

   input                               xpd_im_valid;
   input                               lz_symbol_bus_t xpd_im_data;
   output                              xpd_im_ready;

   input                               htf_bl_im_valid;
   input                               htf_bl_out_t htf_bl_im_data;
   output                              htf_bl_im_ready;
   
   input [16:0]                        lz_bytes_decomp;
   input [16:0]                        lz_hb_bytes;
   input [16:0]                        lz_local_bytes;
   input [11:0]                        lz_hb_tail_ptr;
   input [11:0]                        lz_hb_head_ptr;
   output [23:0]                       sw_LZ_DECOMP_OLIMIT;     


   
   
   logic                bimc_htf_bl_im_odat;    
   logic                bimc_htf_bl_im_osync;   
   logic                bimc_lz77d_im_odat;     
   logic                bimc_lz77d_im_osync;    
   logic                bimc_master_odat;       
   logic                bimc_master_osync;      
   logic                bimc_xpd_im_odat;       
   logic                bimc_xpd_im_osync;      
   logic [`CR_C_BIMC_CMD2_T_DECL] i_bimc_cmd2;  
   logic [`CR_C_BIMC_DBGCMD0_T_DECL] i_bimc_dbgcmd0;
   logic [`CR_C_BIMC_DBGCMD1_T_DECL] i_bimc_dbgcmd1;
   logic [`CR_C_BIMC_DBGCMD2_T_DECL] i_bimc_dbgcmd2;
   logic [`CR_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_correctable_error_cnt;
   logic [`CR_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_uncorrectable_error_cnt;
   logic [`CR_C_BIMC_ECCPAR_DEBUG_T_DECL] i_bimc_eccpar_debug;
   logic [`CR_C_BIMC_GLOBAL_CONFIG_T_DECL] i_bimc_global_config;
   logic [`CR_C_BIMC_MEMID_T_DECL] i_bimc_memid;
   logic [`CR_C_BIMC_MONITOR_T_DECL] i_bimc_monitor;
   logic [`CR_C_BIMC_PARITY_ERROR_CNT_T_DECL] i_bimc_parity_error_cnt;
   logic [`CR_C_BIMC_POLLRSP0_T_DECL] i_bimc_pollrsp0;
   logic [`CR_C_BIMC_POLLRSP1_T_DECL] i_bimc_pollrsp1;
   logic [`CR_C_BIMC_POLLRSP2_T_DECL] i_bimc_pollrsp2;
   logic [`CR_C_BIMC_RXCMD0_T_DECL] i_bimc_rxcmd0;
   logic [`CR_C_BIMC_RXCMD1_T_DECL] i_bimc_rxcmd1;
   logic [`CR_C_BIMC_RXCMD2_T_DECL] i_bimc_rxcmd2;
   logic [`CR_C_BIMC_RXRSP0_T_DECL] i_bimc_rxrsp0;
   logic [`CR_C_BIMC_RXRSP1_T_DECL] i_bimc_rxrsp1;
   logic [`CR_C_BIMC_RXRSP2_T_DECL] i_bimc_rxrsp2;
   logic                im_rdy_lz77d;           
   logic                im_vld_lz77d;           
   logic                locl_ack;               
   logic                locl_err_ack;           
   logic [31:0]         locl_rd_data;           
   logic                locl_rd_strb;           
   logic                locl_wr_strb;           
   logic [`CR_XP10_DECOMP_C_BIMC_CMD0_T_DECL] o_bimc_cmd0;
   logic [`CR_XP10_DECOMP_C_BIMC_CMD1_T_DECL] o_bimc_cmd1;
   logic [`CR_XP10_DECOMP_C_BIMC_CMD2_T_DECL] o_bimc_cmd2;
   logic [`CR_XP10_DECOMP_C_BIMC_DBGCMD2_T_DECL] o_bimc_dbgcmd2;
   logic [`CR_XP10_DECOMP_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_correctable_error_cnt;
   logic [`CR_XP10_DECOMP_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_uncorrectable_error_cnt;
   logic [`CR_XP10_DECOMP_C_BIMC_ECCPAR_DEBUG_T_DECL] o_bimc_eccpar_debug;
   logic [`CR_XP10_DECOMP_C_BIMC_GLOBAL_CONFIG_T_DECL] o_bimc_global_config;
   logic [`CR_XP10_DECOMP_C_BIMC_MONITOR_MASK_T_DECL] o_bimc_monitor_mask;
   logic [`CR_XP10_DECOMP_C_BIMC_PARITY_ERROR_CNT_T_DECL] o_bimc_parity_error_cnt;
   logic [`CR_XP10_DECOMP_C_BIMC_POLLRSP2_T_DECL] o_bimc_pollrsp2;
   logic [`CR_XP10_DECOMP_C_BIMC_RXCMD2_T_DECL] o_bimc_rxcmd2;
   logic [`CR_XP10_DECOMP_C_BIMC_RXRSP2_T_DECL] o_bimc_rxrsp2;
   logic                rd_stb;                 
   logic                wr_stb;                 
   

   
   
   logic                bimc_htf_bl_im_idat;    
   logic                bimc_htf_bl_im_isync;   
   logic                bimc_lz77d_im_idat;     
   logic                bimc_lz77d_im_isync;    
   logic                bimc_master_idat;       
   logic                bimc_master_isync;      
   logic                bimc_xpd_im_idat;       
   logic                bimc_xpd_im_isync;      
   

   
`define __BIMC_CHAIN(src,dst)                                 \
   assign bimc_``dst``_idat  = bimc_``src``_odat; \
   assign bimc_``dst``_isync = bimc_``src``_osync
`define __BIMC_IN(dst) \
   assign bimc_``dst``_idat = bimc_idat; \
   assign bimc_``dst``_isync = bimc_isync
`define __BIMC_OUT(src) \
   assign bimc_odat = bimc_``src``_odat; \
   assign bimc_osync = bimc_``src``_osync
   
   `__BIMC_CHAIN(master, lz77d_im);
   `__BIMC_CHAIN(lz77d_im, xpd_im);
   `__BIMC_CHAIN(xpd_im, htf_bl_im);
   `__BIMC_OUT(htf_bl_im);
   `__BIMC_IN(master);
   
`undef __BIMC_CHAIN
`undef __BIMC_IN
`undef __BIMC_OUT
   

   logic [`CR_XP10_DECOMP_DECL]      reg_addr;          
   logic [`CR_XP10_DECOMP_DECL]       locl_addr;
   logic [`N_RBUS_DATA_BITS-1:0]     locl_wr_data;
   spare_t                           spare;    
   
   lz77d_out_t                  lz77d_out_ia_wdata;
   lz77d_out_ia_config_t        lz77d_out_ia_config;
   lz77d_out_t                  lz77d_out_ia_rdata;
   lz77d_out_ia_status_t        lz77d_out_ia_status;
   lz77d_out_ia_capability_t    lz77d_out_ia_capability;
   
   lz77d_out_im_status_t         lz77d_out_im_status;
   lz77d_out_im_config_t         lz77d_out_im_config;

   xpd_out_t                  xpd_out_ia_wdata;
   xpd_out_ia_config_t        xpd_out_ia_config;
   xpd_out_t                  xpd_out_ia_rdata;
   xpd_out_ia_status_t        xpd_out_ia_status;
   xpd_out_ia_capability_t    xpd_out_ia_capability;
   
   xpd_out_im_status_t         xpd_out_im_status;
   xpd_out_im_config_t         xpd_out_im_config;

   htf_bl_out_t                  htf_bl_out_ia_wdata;
   htf_bl_out_ia_config_t        htf_bl_out_ia_config;
   htf_bl_out_t                  htf_bl_out_ia_rdata;
   htf_bl_out_ia_status_t        htf_bl_out_ia_status;
   htf_bl_out_ia_capability_t    htf_bl_out_ia_capability;
   
   htf_bl_out_im_status_t         htf_bl_out_im_status;
   htf_bl_out_im_config_t         htf_bl_out_im_config;

      
   im_din_t                       im_din_lz77d;
   im_din_t im_din_xpd;

   
   always_comb begin
      im_din_lz77d.desc.eob             = xp10_decomp_ob_out_pre.tlast; 
      im_din_lz77d.desc.bytes_vld       = xp10_decomp_ob_out_pre.tstrb; 
      im_din_lz77d.desc.im_meta[22:15]  = 8'd0;
      im_din_lz77d.desc.im_meta[14]     = xp10_decomp_ob_out_pre.tid;
      im_din_lz77d.desc.im_meta[13:6]   = xp10_decomp_ob_out_pre.tuser;
      im_din_lz77d.desc.im_meta[5:0]    = 6'd0;                     
      im_din_lz77d.data                 = xp10_decomp_ob_out_pre.tdata;

      im_din_xpd = '0;
      im_din_xpd.desc.eob = xpd_im_data.framing==4'hf;
      im_din_xpd.data = xpd_im_data;

   end 
   
   
   

   nx_interface_monitor_pipe u_lz77d_im_pipe
     (
      
      .ob_in_mod                        (xp10_decomp_ob_in_mod), 
      .ob_out                           (xp10_decomp_ob_out),    
      .im_vld                           (im_vld_lz77d),          
      
      .clk                              (clk),                   
      .rst_n                            (rst_n),                 
      .ob_out_pre                       (xp10_decomp_ob_out_pre), 
      .ob_in                            (xp10_decomp_ob_in),     
      .im_rdy                           (im_rdy_lz77d));          
   
   
   
   

   
   revid_t revid_wire;
     
   CR_TIE_CELL revid_wire_0 (.ob(revid_wire.f.revid[0]), .o());
   CR_TIE_CELL revid_wire_1 (.ob(revid_wire.f.revid[1]), .o());
   CR_TIE_CELL revid_wire_2 (.ob(revid_wire.f.revid[2]), .o());
   CR_TIE_CELL revid_wire_3 (.ob(revid_wire.f.revid[3]), .o());
   CR_TIE_CELL revid_wire_4 (.ob(revid_wire.f.revid[4]), .o());
   CR_TIE_CELL revid_wire_5 (.ob(revid_wire.f.revid[5]), .o());
   CR_TIE_CELL revid_wire_6 (.ob(revid_wire.f.revid[6]), .o());
   CR_TIE_CELL revid_wire_7 (.ob(revid_wire.f.revid[7]), .o());

   
   bimc_master bimc_master
     (
      
      .bimc_ecc_error                   (bimc_ecc_error),        
      .bimc_interrupt                   (bimc_interrupt),        
      .bimc_odat                        (bimc_master_odat),      
      .bimc_rst_n                       (bimc_rst_n),
      .bimc_osync                       (bimc_master_osync),     
      .i_bimc_monitor                   (i_bimc_monitor[`CR_C_BIMC_MONITOR_T_DECL]),
      .i_bimc_ecc_uncorrectable_error_cnt(i_bimc_ecc_uncorrectable_error_cnt[`CR_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]),
      .i_bimc_ecc_correctable_error_cnt (i_bimc_ecc_correctable_error_cnt[`CR_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]),
      .i_bimc_parity_error_cnt          (i_bimc_parity_error_cnt[`CR_C_BIMC_PARITY_ERROR_CNT_T_DECL]),
      .i_bimc_global_config             (i_bimc_global_config[`CR_C_BIMC_GLOBAL_CONFIG_T_DECL]),
      .i_bimc_memid                     (i_bimc_memid[`CR_C_BIMC_MEMID_T_DECL]),
      .i_bimc_eccpar_debug              (i_bimc_eccpar_debug[`CR_C_BIMC_ECCPAR_DEBUG_T_DECL]),
      .i_bimc_cmd2                      (i_bimc_cmd2[`CR_C_BIMC_CMD2_T_DECL]),
      .i_bimc_rxcmd2                    (i_bimc_rxcmd2[`CR_C_BIMC_RXCMD2_T_DECL]),
      .i_bimc_rxcmd1                    (i_bimc_rxcmd1[`CR_C_BIMC_RXCMD1_T_DECL]),
      .i_bimc_rxcmd0                    (i_bimc_rxcmd0[`CR_C_BIMC_RXCMD0_T_DECL]),
      .i_bimc_rxrsp2                    (i_bimc_rxrsp2[`CR_C_BIMC_RXRSP2_T_DECL]),
      .i_bimc_rxrsp1                    (i_bimc_rxrsp1[`CR_C_BIMC_RXRSP1_T_DECL]),
      .i_bimc_rxrsp0                    (i_bimc_rxrsp0[`CR_C_BIMC_RXRSP0_T_DECL]),
      .i_bimc_pollrsp2                  (i_bimc_pollrsp2[`CR_C_BIMC_POLLRSP2_T_DECL]),
      .i_bimc_pollrsp1                  (i_bimc_pollrsp1[`CR_C_BIMC_POLLRSP1_T_DECL]),
      .i_bimc_pollrsp0                  (i_bimc_pollrsp0[`CR_C_BIMC_POLLRSP0_T_DECL]),
      .i_bimc_dbgcmd2                   (i_bimc_dbgcmd2[`CR_C_BIMC_DBGCMD2_T_DECL]),
      .i_bimc_dbgcmd1                   (i_bimc_dbgcmd1[`CR_C_BIMC_DBGCMD1_T_DECL]),
      .i_bimc_dbgcmd0                   (i_bimc_dbgcmd0[`CR_C_BIMC_DBGCMD0_T_DECL]),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .bimc_idat                        (bimc_master_idat),      
      .bimc_isync                       (bimc_master_isync),     
      .o_bimc_monitor_mask              (o_bimc_monitor_mask[`CR_C_BIMC_MONITOR_MASK_T_DECL]),
      .o_bimc_ecc_uncorrectable_error_cnt(o_bimc_ecc_uncorrectable_error_cnt[`CR_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]),
      .o_bimc_ecc_correctable_error_cnt (o_bimc_ecc_correctable_error_cnt[`CR_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]),
      .o_bimc_parity_error_cnt          (o_bimc_parity_error_cnt[`CR_C_BIMC_PARITY_ERROR_CNT_T_DECL]),
      .o_bimc_global_config             (o_bimc_global_config[`CR_C_BIMC_GLOBAL_CONFIG_T_DECL]),
      .o_bimc_eccpar_debug              (o_bimc_eccpar_debug[`CR_C_BIMC_ECCPAR_DEBUG_T_DECL]),
      .o_bimc_cmd2                      (o_bimc_cmd2[`CR_C_BIMC_CMD2_T_DECL]),
      .o_bimc_cmd1                      (o_bimc_cmd1[`CR_C_BIMC_CMD1_T_DECL]),
      .o_bimc_cmd0                      (o_bimc_cmd0[`CR_C_BIMC_CMD0_T_DECL]),
      .o_bimc_rxcmd2                    (o_bimc_rxcmd2[`CR_C_BIMC_RXCMD2_T_DECL]),
      .o_bimc_rxrsp2                    (o_bimc_rxrsp2[`CR_C_BIMC_RXRSP2_T_DECL]),
      .o_bimc_pollrsp2                  (o_bimc_pollrsp2[`CR_C_BIMC_POLLRSP2_T_DECL]),
      .o_bimc_dbgcmd2                   (o_bimc_dbgcmd2[`CR_C_BIMC_DBGCMD2_T_DECL]));
   
   genvar              i;
   
   
   
   cr_xp10_decomp_regs u_cr_xp10_decomp_regs (
                                              
                                              .o_rd_data        (locl_rd_data[31:0]), 
                                              .o_ack            (locl_ack),      
                                              .o_err_ack        (locl_err_ack),  
                                              .o_spare_config   (spare),         
                                              .o_lz_bypass_config(sw_LZ_BYPASS_CONFIG), 
                                              .o_ignore_crc_config(sw_IGNORE_CRC_CONFIG), 
                                              .o_lz_decomp_olimit(sw_LZ_DECOMP_OLIMIT), 
                                              .o_decomp_dp_tlv_parse_action_0(sw_TLVP_ACTION_CFG0), 
                                              .o_decomp_dp_tlv_parse_action_1(sw_TLVP_ACTION_CFG1), 
                                              .o_lz77d_out_ia_wdata_part0(lz77d_out_ia_wdata.r.part0), 
                                              .o_lz77d_out_ia_wdata_part1(lz77d_out_ia_wdata.r.part1), 
                                              .o_lz77d_out_ia_wdata_part2(lz77d_out_ia_wdata.r.part2), 
                                              .o_lz77d_out_ia_config(lz77d_out_ia_config), 
                                              .o_lz77d_out_im_config(lz77d_out_im_config), 
                                              .o_lz77d_out_im_read_done(),       
                                              .o_xpd_out_ia_wdata_part0(xpd_out_ia_wdata.r.part0), 
                                              .o_xpd_out_ia_wdata_part1(xpd_out_ia_wdata.r.part1), 
                                              .o_xpd_out_ia_wdata_part2(xpd_out_ia_wdata.r.part2), 
                                              .o_xpd_out_ia_config(xpd_out_ia_config), 
                                              .o_xpd_out_im_config(xpd_out_im_config), 
                                              .o_xpd_out_im_read_done(),         
                                              .o_htf_bl_out_ia_wdata_part0(htf_bl_out_ia_wdata.r.part0), 
                                              .o_htf_bl_out_ia_wdata_part1(htf_bl_out_ia_wdata.r.part1), 
                                              .o_htf_bl_out_ia_wdata_part2(htf_bl_out_ia_wdata.r.part2), 
                                              .o_htf_bl_out_ia_config(htf_bl_out_ia_config), 
                                              .o_htf_bl_out_im_config(htf_bl_out_im_config), 
                                              .o_htf_bl_out_im_read_done(),      
                                              .o_bimc_monitor_mask(o_bimc_monitor_mask[`CR_XP10_DECOMP_C_BIMC_MONITOR_MASK_T_DECL]), 
                                              .o_bimc_ecc_uncorrectable_error_cnt(o_bimc_ecc_uncorrectable_error_cnt[`CR_XP10_DECOMP_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]), 
                                              .o_bimc_ecc_correctable_error_cnt(o_bimc_ecc_correctable_error_cnt[`CR_XP10_DECOMP_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]), 
                                              .o_bimc_parity_error_cnt(o_bimc_parity_error_cnt[`CR_XP10_DECOMP_C_BIMC_PARITY_ERROR_CNT_T_DECL]), 
                                              .o_bimc_global_config(o_bimc_global_config[`CR_XP10_DECOMP_C_BIMC_GLOBAL_CONFIG_T_DECL]), 
                                              .o_bimc_eccpar_debug(o_bimc_eccpar_debug[`CR_XP10_DECOMP_C_BIMC_ECCPAR_DEBUG_T_DECL]), 
                                              .o_bimc_cmd2      (o_bimc_cmd2[`CR_XP10_DECOMP_C_BIMC_CMD2_T_DECL]), 
                                              .o_bimc_cmd1      (o_bimc_cmd1[`CR_XP10_DECOMP_C_BIMC_CMD1_T_DECL]), 
                                              .o_bimc_cmd0      (o_bimc_cmd0[`CR_XP10_DECOMP_C_BIMC_CMD0_T_DECL]), 
                                              .o_bimc_rxcmd2    (o_bimc_rxcmd2[`CR_XP10_DECOMP_C_BIMC_RXCMD2_T_DECL]), 
                                              .o_bimc_rxrsp2    (o_bimc_rxrsp2[`CR_XP10_DECOMP_C_BIMC_RXRSP2_T_DECL]), 
                                              .o_bimc_pollrsp2  (o_bimc_pollrsp2[`CR_XP10_DECOMP_C_BIMC_POLLRSP2_T_DECL]), 
                                              .o_bimc_dbgcmd2   (o_bimc_dbgcmd2[`CR_XP10_DECOMP_C_BIMC_DBGCMD2_T_DECL]), 
                                              .o_reg_written    (wr_stb),        
                                              .o_reg_read       (rd_stb),        
                                              .o_reg_wr_data    (),              
                                              .o_reg_addr       (reg_addr),      
                                              
                                              .clk              (clk),
                                              .i_reset_         (rst_n),         
                                              .i_sw_init        (1'd0),          
                                              .i_addr           (locl_addr),     
                                              .i_wr_strb        (locl_wr_strb),  
                                              .i_wr_data        (locl_wr_data),  
                                              .i_rd_strb        (locl_rd_strb),  
                                              .i_revision_config(revid_wire),    
                                              .i_spare_config   (spare),         
                                              .i_lz_bytes_decomp(lz_bytes_decomp), 
                                              .i_lz_hb_bytes    (lz_hb_bytes),   
                                              .i_lz_local_bytes (lz_local_bytes), 
                                              .i_lz_hb_tail_ptr (lz_hb_tail_ptr), 
                                              .i_lz_hb_head_ptr (lz_hb_head_ptr), 
                                              .i_lz77d_out_ia_capability(lz77d_out_ia_capability), 
                                              .i_lz77d_out_ia_status(lz77d_out_ia_status), 
                                              .i_lz77d_out_ia_rdata_part0(lz77d_out_ia_rdata.r.part0), 
                                              .i_lz77d_out_ia_rdata_part1(lz77d_out_ia_rdata.r.part1), 
                                              .i_lz77d_out_ia_rdata_part2(lz77d_out_ia_rdata.r.part2), 
                                              .i_lz77d_out_im_status(lz77d_out_im_status), 
                                              .i_lz77d_out_im_read_done(2'd0),   
                                              .i_xpd_out_ia_capability(xpd_out_ia_capability), 
                                              .i_xpd_out_ia_status(xpd_out_ia_status), 
                                              .i_xpd_out_ia_rdata_part0(xpd_out_ia_rdata.r.part0), 
                                              .i_xpd_out_ia_rdata_part1(xpd_out_ia_rdata.r.part1), 
                                              .i_xpd_out_ia_rdata_part2(xpd_out_ia_rdata.r.part2), 
                                              .i_xpd_out_im_status(xpd_out_im_status), 
                                              .i_xpd_out_im_read_done(2'd0),     
                                              .i_htf_bl_out_ia_capability(htf_bl_out_ia_capability), 
                                              .i_htf_bl_out_ia_status(htf_bl_out_ia_status), 
                                              .i_htf_bl_out_ia_rdata_part0(htf_bl_out_ia_rdata.r.part0), 
                                              .i_htf_bl_out_ia_rdata_part1(htf_bl_out_ia_rdata.r.part1), 
                                              .i_htf_bl_out_ia_rdata_part2(htf_bl_out_ia_rdata.r.part2), 
                                              .i_htf_bl_out_im_status(htf_bl_out_im_status), 
                                              .i_htf_bl_out_im_read_done(2'd0),  
                                              .i_bimc_monitor   (i_bimc_monitor[`CR_XP10_DECOMP_C_BIMC_MONITOR_T_DECL]), 
                                              .i_bimc_ecc_uncorrectable_error_cnt(i_bimc_ecc_uncorrectable_error_cnt[`CR_XP10_DECOMP_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]), 
                                              .i_bimc_ecc_correctable_error_cnt(i_bimc_ecc_correctable_error_cnt[`CR_XP10_DECOMP_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]), 
                                              .i_bimc_parity_error_cnt(i_bimc_parity_error_cnt[`CR_XP10_DECOMP_C_BIMC_PARITY_ERROR_CNT_T_DECL]), 
                                              .i_bimc_global_config(i_bimc_global_config[`CR_XP10_DECOMP_C_BIMC_GLOBAL_CONFIG_T_DECL]), 
                                              .i_bimc_memid     (i_bimc_memid[`CR_XP10_DECOMP_C_BIMC_MEMID_T_DECL]), 
                                              .i_bimc_eccpar_debug(i_bimc_eccpar_debug[`CR_XP10_DECOMP_C_BIMC_ECCPAR_DEBUG_T_DECL]), 
                                              .i_bimc_cmd2      (i_bimc_cmd2[`CR_XP10_DECOMP_C_BIMC_CMD2_T_DECL]), 
                                              .i_bimc_rxcmd2    (i_bimc_rxcmd2[`CR_XP10_DECOMP_C_BIMC_RXCMD2_T_DECL]), 
                                              .i_bimc_rxcmd1    (i_bimc_rxcmd1[`CR_XP10_DECOMP_C_BIMC_RXCMD1_T_DECL]), 
                                              .i_bimc_rxcmd0    (i_bimc_rxcmd0[`CR_XP10_DECOMP_C_BIMC_RXCMD0_T_DECL]), 
                                              .i_bimc_rxrsp2    (i_bimc_rxrsp2[`CR_XP10_DECOMP_C_BIMC_RXRSP2_T_DECL]), 
                                              .i_bimc_rxrsp1    (i_bimc_rxrsp1[`CR_XP10_DECOMP_C_BIMC_RXRSP1_T_DECL]), 
                                              .i_bimc_rxrsp0    (i_bimc_rxrsp0[`CR_XP10_DECOMP_C_BIMC_RXRSP0_T_DECL]), 
                                              .i_bimc_pollrsp2  (i_bimc_pollrsp2[`CR_XP10_DECOMP_C_BIMC_POLLRSP2_T_DECL]), 
                                              .i_bimc_pollrsp1  (i_bimc_pollrsp1[`CR_XP10_DECOMP_C_BIMC_POLLRSP1_T_DECL]), 
                                              .i_bimc_pollrsp0  (i_bimc_pollrsp0[`CR_XP10_DECOMP_C_BIMC_POLLRSP0_T_DECL]), 
                                              .i_bimc_dbgcmd2   (i_bimc_dbgcmd2[`CR_XP10_DECOMP_C_BIMC_DBGCMD2_T_DECL]), 
                                              .i_bimc_dbgcmd1   (i_bimc_dbgcmd1[`CR_XP10_DECOMP_C_BIMC_DBGCMD1_T_DECL]), 
                                              .i_bimc_dbgcmd0   (i_bimc_dbgcmd0[`CR_XP10_DECOMP_C_BIMC_DBGCMD0_T_DECL])); 

   
   
   
   nx_rbus_ring 
     #(
       .N_RBUS_ADDR_BITS (`N_RBUS_ADDR_BITS),             
       .N_LOCL_ADDR_BITS (`CR_XP10_DECOMP_WIDTH),           
       .N_RBUS_DATA_BITS (`N_RBUS_DATA_BITS))             
   u_nx_rbus_ring 
     (.*,
      
      .rbus_addr_o                      (rbus_ring_o.addr),      
      .rbus_wr_strb_o                   (rbus_ring_o.wr_strb),   
      .rbus_wr_data_o                   (rbus_ring_o.wr_data),   
      .rbus_rd_strb_o                   (rbus_ring_o.rd_strb),   
      .locl_addr_o                      (locl_addr),             
      .locl_wr_strb_o                   (locl_wr_strb),          
      .locl_wr_data_o                   (locl_wr_data),          
      .locl_rd_strb_o                   (locl_rd_strb),          
      .rbus_rd_data_o                   (rbus_ring_o.rd_data),   
      .rbus_ack_o                       (rbus_ring_o.ack),       
      .rbus_err_ack_o                   (rbus_ring_o.err_ack),   
      
      .rbus_addr_i                      (rbus_ring_i.addr),      
      .rbus_wr_strb_i                   (rbus_ring_i.wr_strb),   
      .rbus_wr_data_i                   (rbus_ring_i.wr_data),   
      .rbus_rd_strb_i                   (rbus_ring_i.rd_strb),   
      .rbus_rd_data_i                   (rbus_ring_i.rd_data),   
      .rbus_ack_i                       (rbus_ring_i.ack),       
      .rbus_err_ack_i                   (rbus_ring_i.err_ack),   
      .locl_rd_data_i                   (locl_rd_data),          
      .locl_ack_i                       (locl_ack),              
      .locl_err_ack_i                   (locl_err_ack));          


   
   
   nx_interface_monitor
     #(.IN_FLIGHT       (5),                                  
       .CMND_ADDRESS    (`CR_XP10_DECOMP_LZ77D_OUT_IA_CONFIG),        
       .STAT_ADDRESS    (`CR_XP10_DECOMP_LZ77D_OUT_IA_STATUS),        
       .IMRD_ADDRESS    (`CR_XP10_DECOMP_LZ77D_OUT_IM_READ_DONE),     
       .N_REG_ADDR_BITS (`CR_XP10_DECOMP_WIDTH),                
       .N_DATA_BITS     (`N_AXI_IM_WIDTH),                        
       .N_ENTRIES       (`N_AXI_IM_ENTRIES),                      
       .SPECIALIZE      (1))                                  
   u_lz77d_im
     (
      
      .stat_code                        ({lz77d_out_ia_status.f.code}), 
      .stat_datawords                   (lz77d_out_ia_status.f.datawords), 
      .stat_addr                        (lz77d_out_ia_status.f.addr), 
      .capability_lst                   (lz77d_out_ia_capability.r.part0[15:0]), 
      .capability_type                  (lz77d_out_ia_capability.f.mem_type), 
      .rd_dat                           (lz77d_out_ia_rdata),    
      .bimc_odat                        (bimc_lz77d_im_odat),    
      .bimc_osync                       (bimc_lz77d_im_osync),   
      .ro_uncorrectable_ecc_error       (),                      
      .im_rdy                           (im_rdy_lz77d),          
      .im_available                     (im_available_lz77d),    
      .im_status                        (lz77d_out_im_status),   
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .reg_addr                         (reg_addr),              
      .cmnd_op                          (lz77d_out_ia_config.f.op), 
      .cmnd_addr                        (lz77d_out_ia_config.f.addr), 
      .wr_stb                           (wr_stb),
      .wr_dat                           (lz77d_out_ia_wdata),    
      .ovstb                            (1'd1),                  
      .lvm                              (1'd0),                  
      .mlvm                             (1'd0),                  
      .mrdten                           (1'd0),                  
      .bimc_rst_n                       (bimc_rst_n),
      .bimc_isync                       (bimc_lz77d_im_isync),   
      .bimc_idat                        (bimc_lz77d_im_idat),    
      .im_din                           (im_din_lz77d),          
      .im_vld                           (im_vld_lz77d),          
      .im_consumed                      (im_consumed_lz77d),     
      .im_config                        (lz77d_out_im_config));   

   
   

   localparam cr_xp10_decomp_regsPKG::xpd_out_t XPD_RAM_MASK = '{unused: '0, default: '1};

   nx_interface_monitor 
     #(.IN_FLIGHT       (5),                                  
       .CMND_ADDRESS    (`CR_XP10_DECOMP_XPD_OUT_IA_CONFIG),        
       .STAT_ADDRESS    (`CR_XP10_DECOMP_XPD_OUT_IA_STATUS),        
       .IMRD_ADDRESS    (`CR_XP10_DECOMP_XPD_OUT_IM_READ_DONE),     
       .N_REG_ADDR_BITS (`CR_XP10_DECOMP_WIDTH),                
       .N_DATA_BITS     (`N_AXI_IM_WIDTH),                        
       .N_ENTRIES       (`N_AXI_IM_ENTRIES),                      
       .RAM_MASK (XPD_RAM_MASK),
       .SPECIALIZE      (1))                                  
   u_xpd_im
     (
      
      .stat_code                        ({xpd_out_ia_status.f.code}), 
      .stat_datawords                   (xpd_out_ia_status.f.datawords), 
      .stat_addr                        (xpd_out_ia_status.f.addr), 
      .capability_lst                   (xpd_out_ia_capability.r.part0[15:0]), 
      .capability_type                  (xpd_out_ia_capability.f.mem_type), 
      .rd_dat                           (xpd_out_ia_rdata),      
      .bimc_odat                        (bimc_xpd_im_odat),      
      .bimc_osync                       (bimc_xpd_im_osync),     
      .ro_uncorrectable_ecc_error       (),                      
      .im_rdy                           (xpd_im_ready),          
      .im_available                     (im_available_xpd),      
      .im_status                        (xpd_out_im_status),     
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .reg_addr                         (reg_addr),              
      .cmnd_op                          (xpd_out_ia_config.f.op), 
      .cmnd_addr                        (xpd_out_ia_config.f.addr), 
      .wr_stb                           (wr_stb),
      .wr_dat                           (xpd_out_ia_wdata),      
      .ovstb                            (1'd1),                  
      .lvm                              (1'd0),                  
      .mlvm                             (1'd0),                  
      .mrdten                           (1'd0),                  
      .bimc_rst_n                       (bimc_rst_n),
      .bimc_isync                       (bimc_xpd_im_isync),     
      .bimc_idat                        (bimc_xpd_im_idat),      
      .im_din                           (im_din_xpd),            
      .im_vld                           (xpd_im_valid),          
      .im_consumed                      (im_consumed_xpd),       
      .im_config                        (xpd_out_im_config));     

   
   

   localparam cr_xp10_decomp_regsPKG::htf_bl_out_t HTF_BL_RAM_MASK = '{unused: '0, eot: 1'b1, err: 1'b1, eob: 1'b1, default: 8'h1f};

   nx_interface_monitor 
     #(.IN_FLIGHT       (5),                                  
       .CMND_ADDRESS    (`CR_XP10_DECOMP_HTF_BL_OUT_IA_CONFIG),        
       .STAT_ADDRESS    (`CR_XP10_DECOMP_HTF_BL_OUT_IA_STATUS),        
       .IMRD_ADDRESS    (`CR_XP10_DECOMP_HTF_BL_OUT_IM_READ_DONE),     
       .N_REG_ADDR_BITS (`CR_XP10_DECOMP_WIDTH),                
       .N_DATA_BITS     (`N_AXI_IM_WIDTH),                        
       .N_ENTRIES       (`N_HTF_BL_OUT_ENTRIES),                      
       .RAM_MASK (HTF_BL_RAM_MASK),
       .SPECIALIZE      (1))                                  
   u_htf_bl_im
     (
      
      .stat_code                        ({htf_bl_out_ia_status.f.code}), 
      .stat_datawords                   (htf_bl_out_ia_status.f.datawords), 
      .stat_addr                        (htf_bl_out_ia_status.f.addr), 
      .capability_lst                   (htf_bl_out_ia_capability.r.part0[15:0]), 
      .capability_type                  (htf_bl_out_ia_capability.f.mem_type), 
      .rd_dat                           (htf_bl_out_ia_rdata),   
      .bimc_odat                        (bimc_htf_bl_im_odat),   
      .bimc_osync                       (bimc_htf_bl_im_osync),  
      .ro_uncorrectable_ecc_error       (),                      
      .im_rdy                           (htf_bl_im_ready),       
      .im_available                     (im_available_htf_bl),   
      .im_status                        (htf_bl_out_im_status),  
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .reg_addr                         (reg_addr),              
      .cmnd_op                          (htf_bl_out_ia_config.f.op), 
      .cmnd_addr                        (htf_bl_out_ia_config.f.addr), 
      .wr_stb                           (wr_stb),
      .wr_dat                           (htf_bl_out_ia_wdata),   
      .ovstb                            (1'd1),                  
      .lvm                              (1'd0),                  
      .mlvm                             (1'd0),                  
      .mrdten                           (1'd0),                  
      .bimc_rst_n                       (bimc_rst_n),
      .bimc_isync                       (bimc_htf_bl_im_isync),  
      .bimc_idat                        (bimc_htf_bl_im_idat),   
      .im_din                           (htf_bl_im_data),        
      .im_vld                           (htf_bl_im_valid),       
      .im_consumed                      (im_consumed_htf_bl),    
      .im_config                        (htf_bl_out_im_config));  
   
   
endmodule 










