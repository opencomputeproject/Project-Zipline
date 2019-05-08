/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_cceip_64_support.vh"

module cr_cceip_64_support_regfile 

  (
  
  rbus_ring_o, im_consumed_lz77c, im_consumed_lz77d,
  im_consumed_htf_bl, im_consumed_xpc, im_consumed_xpd,
  im_consumed_he_sh, im_consumed_he_lng, im_consumed_he_st_sh,
  im_consumed_he_st_lng, top_bimc_mstr_rst_n, top_bimc_mstr_osync,
  top_bimc_mstr_odat, cceip_int0, cceip_int1, ctl_config, df_mux_sel,
  
  rst_n, clk, rbus_ring_i, cfg_start_addr, cfg_end_addr,
  im_available_lz77c, im_available_lz77d, im_available_htf_bl,
  im_available_xpc, im_available_xpd, im_available_he_lng,
  im_available_he_sh, im_available_he_st_lng, im_available_he_st_sh,
  top_bimc_mstr_idat, top_bimc_mstr_isync, pipe_stat, prefix_int,
  prefix_attach_int, lz77_comp_int, huf_comp_int, xp10_decomp_int,
  crcgc0_int, crcg0_int, crcc0_int, crcc1_int, cg_int, su_int,
  osf_int, isf_int
  );

`include "cr_structs.sv"   
`include "bimc_master.vh"   
  import cr_cceip_64_supportPKG::*;
  import cr_cceip_64_support_regfilePKG::*;
  
  
  output rbus_ring_t           rbus_ring_o;
  output im_consumed_t         im_consumed_lz77c;
  output im_consumed_t         im_consumed_lz77d;
  output im_consumed_t         im_consumed_htf_bl;
  output im_consumed_t         im_consumed_xpc;
  output im_consumed_t         im_consumed_xpd;
  output im_consumed_t         im_consumed_he_sh;
  output im_consumed_t         im_consumed_he_lng;
  output im_consumed_t         im_consumed_he_st_sh;
  output im_consumed_t         im_consumed_he_st_lng;
  output logic                 top_bimc_mstr_rst_n;  
  output logic                 top_bimc_mstr_osync;
  output logic                 top_bimc_mstr_odat;   
  output                       cceip_int0;
  output                       cceip_int1;
  output ctl_t                 ctl_config;  
  output [`CR_CCEIP_64_SUPPORT_DF_MUX_CTRL_T_DF_MUX_SEL_DECL]  df_mux_sel;  
  
  input logic 		       rst_n;
  input logic 		       clk;
  input rbus_ring_t            rbus_ring_i;
    input [`N_RBUS_ADDR_BITS-1:0]       cfg_start_addr;
   input [`N_RBUS_ADDR_BITS-1:0]       cfg_end_addr;
  input im_available_t         im_available_lz77c;
  input im_available_t         im_available_lz77d;
  input im_available_t         im_available_htf_bl;
  input im_available_t         im_available_xpc;
  input im_available_t         im_available_xpd;
  input im_available_t         im_available_he_lng;
  input im_available_t         im_available_he_sh;
  input im_available_t         im_available_he_st_lng;
  input im_available_t         im_available_he_st_sh;
  input                        top_bimc_mstr_idat;   
  input                        top_bimc_mstr_isync;
  input pipe_stat_t            pipe_stat;
   
  input generic_int_t          prefix_int;
  input tlvp_int_t             prefix_attach_int;
  input tlvp_int_t             lz77_comp_int;
  input generic_int_t          huf_comp_int;
  input generic_int_t          xp10_decomp_int;
  input tlvp_int_t             crcgc0_int;
  input tlvp_int_t             crcg0_int;
  input tlvp_int_t             crcc0_int;
  input tlvp_int_t             crcc1_int;
  input tlvp_int_t             cg_int;
  input ecc_int_t              su_int;
  input osf_int_t              osf_int;
  input isf_int_t              isf_int;

  
  
  logic                 bimc_ecc_error;         
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
  logic                 i_cceip_int0_int_control_ack;
  logic [`BIT_VEC((`CR_CCEIP_64_SUPPORT_C_CCEIP_INT0_INT_CONTROL_DATA_WIDTH))] i_cceip_int0_int_control_data;
  logic                 i_cceip_int1_int_control_ack;
  logic [`BIT_VEC((`CR_CCEIP_64_SUPPORT_C_CCEIP_INT1_INT_CONTROL_DATA_WIDTH))] i_cceip_int1_int_control_data;
  logic                 locl_ack;               
  logic                 locl_err_ack;           
  logic [31:0]          locl_rd_data;           
  logic                 locl_rd_strb;           
  logic                 locl_wr_strb;           
  logic [`CR_CCEIP_64_SUPPORT_C_BIMC_CMD0_T_DECL] o_bimc_cmd0;
  logic [`CR_CCEIP_64_SUPPORT_C_BIMC_CMD1_T_DECL] o_bimc_cmd1;
  logic [`CR_CCEIP_64_SUPPORT_C_BIMC_CMD2_T_DECL] o_bimc_cmd2;
  logic [`CR_CCEIP_64_SUPPORT_C_BIMC_DBGCMD2_T_DECL] o_bimc_dbgcmd2;
  logic [`CR_CCEIP_64_SUPPORT_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_correctable_error_cnt;
  logic [`CR_CCEIP_64_SUPPORT_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_uncorrectable_error_cnt;
  logic [`CR_CCEIP_64_SUPPORT_C_BIMC_ECCPAR_DEBUG_T_DECL] o_bimc_eccpar_debug;
  logic [`CR_CCEIP_64_SUPPORT_C_BIMC_GLOBAL_CONFIG_T_DECL] o_bimc_global_config;
  logic [`CR_CCEIP_64_SUPPORT_C_BIMC_MONITOR_MASK_T_DECL] o_bimc_monitor_mask;
  logic [`CR_CCEIP_64_SUPPORT_C_BIMC_PARITY_ERROR_CNT_T_DECL] o_bimc_parity_error_cnt;
  logic [`CR_CCEIP_64_SUPPORT_C_BIMC_POLLRSP2_T_DECL] o_bimc_pollrsp2;
  logic [`CR_CCEIP_64_SUPPORT_C_BIMC_RXCMD2_T_DECL] o_bimc_rxcmd2;
  logic [`CR_CCEIP_64_SUPPORT_C_BIMC_RXRSP2_T_DECL] o_bimc_rxrsp2;
  logic [`CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_CONTROL_ADDR_DECL] o_cceip_int0_int_control_addr;
  logic [`CR_CCEIP_64_SUPPORT_C_CCEIP_INT0_INT_CONTROL_DATA_DECL] o_cceip_int0_int_control_data;
  logic                 o_cceip_int0_int_control_read;
  logic                 o_cceip_int0_int_control_write;
  logic [`CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_CONTROL_ADDR_DECL] o_cceip_int1_int_control_addr;
  logic [`CR_CCEIP_64_SUPPORT_C_CCEIP_INT1_INT_CONTROL_DATA_DECL] o_cceip_int1_int_control_data;
  logic                 o_cceip_int1_int_control_read;
  logic                 o_cceip_int1_int_control_write;
  logic [`CR_CCEIP_64_SUPPORT_C_DF_MUX_CTRL_T_DECL] o_df_mux_ctrl;
  logic [`CR_CCEIP_64_SUPPORT_C_SOFT_RST_T_DECL] o_soft_rst;
  logic                 rd_stb;                 
  logic                 top_bimc_int;           
  logic                 wr_stb;                 
  
  
  logic [`CR_CCEIP_64_SUPPORT_DECL]   reg_addr;		
  logic [`CR_CCEIP_64_SUPPORT_DECL]   locl_addr;
  logic [`N_RBUS_DATA_BITS-1:0]       locl_wr_data;
  logic [`N_RBUS_DATA_BITS-1:0]       wr_data; 
  logic [23:0]                        cceip_int0_stb; 
  logic [9:0]                         cceip_int1_stb; 
  logic [`CR_CCEIP_64_SUPPORT_C_IM_AVAILABLE_T_DECL]  im_available;

  spare_t         spare;    
  im_available_t im_available_xpc_reg;
  im_available_t im_available_xpd_reg;
  im_available_t im_available_lz77c_reg;
  im_available_t im_available_lz77d_reg;
  im_available_t im_available_htf_bl_reg;
  im_available_t im_available_he_lng_reg;
  im_available_t im_available_he_sh_reg;
  im_available_t im_available_he_st_lng_reg;
  im_available_t im_available_he_st_sh_reg;
  
   
   
   always_comb begin
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_XP10_DECOMP_BANK_LO]      = im_available_xpd_reg.bank_lo;        
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_XP10_DECOMP_BANK_HI]      = im_available_xpd_reg.bank_hi;        
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_LZ77_DECOMP_BANK_LO]      = im_available_lz77d_reg.bank_lo;         
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_LZ77_DECOMP_BANK_HI]      = im_available_lz77d_reg.bank_hi;          
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_HTF_BL_BANK_LO]           = im_available_htf_bl_reg.bank_lo; 
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_HTF_BL_BANK_HI]           = im_available_htf_bl_reg.bank_hi; 
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_XP10_COMP_BANK_LO]        = im_available_xpc_reg.bank_lo;         
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_XP10_COMP_BANK_HI]        = im_available_xpc_reg.bank_hi;          
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_LZ77_COMP_BANK_LO]        = im_available_lz77c_reg.bank_lo;         
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_LZ77_COMP_BANK_HI]        = im_available_lz77c_reg.bank_hi;          
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_HE_SH_BL_BANK_LO]         = im_available_he_sh_reg.bank_lo;         
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_HE_SH_BL_BANK_HI]         = im_available_he_sh_reg.bank_hi;
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_HE_LNG_BL_BANK_LO]        = im_available_he_lng_reg.bank_lo;         
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_HE_LNG_BL_BANK_HI]        = im_available_he_lng_reg.bank_hi;
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_HE_ST_SH_BL_BANK_LO]      = im_available_he_st_sh_reg.bank_lo;         
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_HE_ST_SH_BL_BANK_HI]      = im_available_he_st_sh_reg.bank_hi;
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_HE_ST_LNG_BL_BANK_LO]     = im_available_he_st_lng_reg.bank_lo;         
     im_available[`CR_CCEIP_64_SUPPORT_FULL_IM_AVAILABLE_T_HE_ST_LNG_BL_BANK_HI]     = im_available_he_st_lng_reg.bank_hi;
               
   end
  
  
  blkid_revid_t blkid_revid_wire;
  
  
  CR_TIE_CELL revid_wire_15 (.ob(blkid_revid_wire.f.revid[15]), .o());
  CR_TIE_CELL revid_wire_14 (.ob(blkid_revid_wire.f.revid[14]), .o());
  CR_TIE_CELL revid_wire_13 (.ob(blkid_revid_wire.f.revid[13]), .o());
  CR_TIE_CELL revid_wire_12 (.ob(blkid_revid_wire.f.revid[12]), .o());

  CR_TIE_CELL revid_wire_11 (.ob(blkid_revid_wire.f.revid[11]), .o());
  CR_TIE_CELL revid_wire_10 (.ob(blkid_revid_wire.f.revid[10]), .o());
  CR_TIE_CELL revid_wire_9 (.ob(blkid_revid_wire.f.revid[9]), .o());
  CR_TIE_CELL revid_wire_8 (.ob(blkid_revid_wire.f.revid[8]), .o());
  
  CR_TIE_CELL revid_wire_7 (.ob(blkid_revid_wire.f.revid[7]), .o());
  CR_TIE_CELL revid_wire_6 (.ob(blkid_revid_wire.f.revid[6]), .o());
  CR_TIE_CELL revid_wire_5 (.ob(blkid_revid_wire.f.revid[5]), .o());
  CR_TIE_CELL revid_wire_4 (.ob(blkid_revid_wire.f.revid[4]), .o());

  CR_TIE_CELL revid_wire_3 (.ob(blkid_revid_wire.f.revid[3]), .o());
  CR_TIE_CELL revid_wire_2 (.ob(blkid_revid_wire.f.revid[2]), .o());
  CR_TIE_CELL revid_wire_1 (.ob(blkid_revid_wire.f.revid[1]), .o());
  CR_TIE_CELL revid_wire_0 (.ob(blkid_revid_wire.f.revid[0]), .o());



  assign cceip_int0_stb  = 
                           {
                            top_bimc_int,
                            su_int.uncor_ecc_err,
                            cg_int.tlvp_err,
                            crcc1_int.tlvp_err,
                            crcc0_int.tlvp_err,
                            crcg0_int.tlvp_err,
                            crcgc0_int.tlvp_err,
                            1'b0,
                            1'b0,
                            1'b0,
                            1'b0,
                            1'b0,
                            1'b0,
                            1'b0,
                            1'b0,
                            1'b0,
                            prefix_attach_int.tlvp_err,
                            osf_int.tlvp_err,
                            osf_int.uncor_ecc_err,
                            isf_int.sys_stall,        
                            isf_int.ovfl,
                            isf_int.prot_err,
                            isf_int.tlvp_int,
                            isf_int.uncor_ecc_err
                            };


  assign cceip_int1_stb  = 
                           {
                            xp10_decomp_int.tlvp_err,
                            xp10_decomp_int.uncor_ecc_err,
                            xp10_decomp_int.bimc_int,

                            huf_comp_int.tlvp_err,
                            huf_comp_int.uncor_ecc_err,
                            huf_comp_int.bimc_int,

                            lz77_comp_int.tlvp_err,

                            prefix_int.tlvp_err,
                            prefix_int.uncor_ecc_err,
                            prefix_int.bimc_int
                            };

  
  assign blkid_revid_wire.f.blkid[15:0] = `CR_CCEIP_64_BLKID;


  
  assign df_mux_sel = o_df_mux_ctrl[`CR_CCEIP_64_SUPPORT_C_DF_MUX_CTRL_T_DF_MUX_SEL];

  genvar                               i;
  
   


  nx_event_interrupt
    #(.N_ADDR_BITS  (`CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_CONTROL_ADDR_WIDTH),        
      .N_INT_BITS   (`CR_CCEIP_64_SUPPORT_C_CCEIP_INT0_INT_CONTROL_DATA_WIDTH))      
  u_cceip_support_interrupt0
   (
    
    .int_data_out                       (i_cceip_int0_int_control_data[`BIT_VEC((`CR_CCEIP_64_SUPPORT_C_CCEIP_INT0_INT_CONTROL_DATA_WIDTH))]), 
    .int_ack                            (i_cceip_int0_int_control_ack), 
    .int_out                            (cceip_int0),            
    
    .clk                                (clk),                   
    .rst_n                              (rst_n),                 
    .reg_addr                           (o_cceip_int0_int_control_addr[`BIT_VEC((`CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_CONTROL_ADDR_WIDTH))]), 
    .rd_stb                             (o_cceip_int0_int_control_read), 
    .wr_stb                             (o_cceip_int0_int_control_write), 
    .int_stb                            (cceip_int0_stb[`BIT_VEC((`CR_CCEIP_64_SUPPORT_C_CCEIP_INT0_INT_CONTROL_DATA_WIDTH))]), 
    .int_data_in                        (o_cceip_int0_int_control_data[`BIT_VEC((`CR_CCEIP_64_SUPPORT_C_CCEIP_INT0_INT_CONTROL_DATA_WIDTH))])); 

   


  nx_event_interrupt
    #(.N_ADDR_BITS  (`CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_CONTROL_ADDR_WIDTH),        
      .N_INT_BITS   (`CR_CCEIP_64_SUPPORT_C_CCEIP_INT1_INT_CONTROL_DATA_WIDTH))      
  u_cceip_support_interrupt1
  (
   
   
   .int_data_out                        (i_cceip_int1_int_control_data[`BIT_VEC((`CR_CCEIP_64_SUPPORT_C_CCEIP_INT1_INT_CONTROL_DATA_WIDTH))]), 
   .int_ack                             (i_cceip_int1_int_control_ack), 
   .int_out                             (cceip_int1),            
   
   .clk                                 (clk),                   
   .rst_n                               (rst_n),                 
   .reg_addr                            (o_cceip_int1_int_control_addr[`BIT_VEC((`CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_CONTROL_ADDR_WIDTH))]), 
   .rd_stb                              (o_cceip_int1_int_control_read), 
   .wr_stb                              (o_cceip_int1_int_control_write), 
   .int_stb                             (cceip_int1_stb[`BIT_VEC((`CR_CCEIP_64_SUPPORT_C_CCEIP_INT1_INT_CONTROL_DATA_WIDTH))]), 
   .int_data_in                         (o_cceip_int1_int_control_data[`BIT_VEC((`CR_CCEIP_64_SUPPORT_C_CCEIP_INT1_INT_CONTROL_DATA_WIDTH))])); 

  



  
  cr_cceip_64_support_regs u_cr_cceip_64_support_regs 
  (
   
   
   .o_rd_data                           (locl_rd_data[31:0]),    
   .o_ack                               (locl_ack),              
   .o_err_ack                           (locl_err_ack),          
   .o_spare_config                      (spare),                 
   .o_im_consumed                       (),                      
   .o_soft_rst                          (o_soft_rst[`CR_CCEIP_64_SUPPORT_C_SOFT_RST_T_DECL]),
   .o_ctl                               (ctl_config),            
   .o_df_mux_ctrl                       (o_df_mux_ctrl[`CR_CCEIP_64_SUPPORT_C_DF_MUX_CTRL_T_DECL]),
   .o_bimc_monitor_mask                 (o_bimc_monitor_mask[`CR_CCEIP_64_SUPPORT_C_BIMC_MONITOR_MASK_T_DECL]),
   .o_bimc_ecc_uncorrectable_error_cnt  (o_bimc_ecc_uncorrectable_error_cnt[`CR_CCEIP_64_SUPPORT_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]),
   .o_bimc_ecc_correctable_error_cnt    (o_bimc_ecc_correctable_error_cnt[`CR_CCEIP_64_SUPPORT_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]),
   .o_bimc_parity_error_cnt             (o_bimc_parity_error_cnt[`CR_CCEIP_64_SUPPORT_C_BIMC_PARITY_ERROR_CNT_T_DECL]),
   .o_bimc_global_config                (o_bimc_global_config[`CR_CCEIP_64_SUPPORT_C_BIMC_GLOBAL_CONFIG_T_DECL]),
   .o_bimc_eccpar_debug                 (o_bimc_eccpar_debug[`CR_CCEIP_64_SUPPORT_C_BIMC_ECCPAR_DEBUG_T_DECL]),
   .o_bimc_cmd2                         (o_bimc_cmd2[`CR_CCEIP_64_SUPPORT_C_BIMC_CMD2_T_DECL]),
   .o_bimc_cmd1                         (o_bimc_cmd1[`CR_CCEIP_64_SUPPORT_C_BIMC_CMD1_T_DECL]),
   .o_bimc_cmd0                         (o_bimc_cmd0[`CR_CCEIP_64_SUPPORT_C_BIMC_CMD0_T_DECL]),
   .o_bimc_rxcmd2                       (o_bimc_rxcmd2[`CR_CCEIP_64_SUPPORT_C_BIMC_RXCMD2_T_DECL]),
   .o_bimc_rxrsp2                       (o_bimc_rxrsp2[`CR_CCEIP_64_SUPPORT_C_BIMC_RXRSP2_T_DECL]),
   .o_bimc_pollrsp2                     (o_bimc_pollrsp2[`CR_CCEIP_64_SUPPORT_C_BIMC_POLLRSP2_T_DECL]),
   .o_bimc_dbgcmd2                      (o_bimc_dbgcmd2[`CR_CCEIP_64_SUPPORT_C_BIMC_DBGCMD2_T_DECL]),
   .o_cceip_int0_int_control_read       (o_cceip_int0_int_control_read),
   .o_cceip_int0_int_control_write      (o_cceip_int0_int_control_write),
   .o_cceip_int0_int_control_data       (o_cceip_int0_int_control_data[`CR_CCEIP_64_SUPPORT_C_CCEIP_INT0_INT_CONTROL_DATA_DECL]),
   .o_cceip_int0_int_control_addr       (o_cceip_int0_int_control_addr[`CR_CCEIP_64_SUPPORT_CCEIP_INT0_INT_CONTROL_ADDR_DECL]),
   .o_cceip_int1_int_control_read       (o_cceip_int1_int_control_read),
   .o_cceip_int1_int_control_write      (o_cceip_int1_int_control_write),
   .o_cceip_int1_int_control_data       (o_cceip_int1_int_control_data[`CR_CCEIP_64_SUPPORT_C_CCEIP_INT1_INT_CONTROL_DATA_DECL]),
   .o_cceip_int1_int_control_addr       (o_cceip_int1_int_control_addr[`CR_CCEIP_64_SUPPORT_CCEIP_INT1_INT_CONTROL_ADDR_DECL]),
   .o_reg_written                       (wr_stb),                
   .o_reg_read                          (rd_stb),                
   .o_reg_wr_data                       (wr_data),               
   .o_reg_addr                          (reg_addr),              
   
   .clk                                 (clk),
   .i_reset_                            (rst_n),                 
   .i_sw_init                           (1'd0),                  
   .i_addr                              (locl_addr),             
   .i_wr_strb                           (locl_wr_strb),          
   .i_wr_data                           (locl_wr_data),          
   .i_rd_strb                           (locl_rd_strb),          
   .i_blkid_revid_config                (blkid_revid_wire),      
   .i_spare_config                      (spare),                 
   .i_im_available                      (im_available),          
   .i_im_consumed                       (`CR_CCEIP_64_SUPPORT_C_IM_CONSUMED_T_WIDTH'd0), 
   .i_soft_rst                          (o_soft_rst),            
   .i_ctl                               (ctl_config),            
   .i_df_mux_ctrl                       (o_df_mux_ctrl),         
   .i_pipe_stat                         (pipe_stat),             
   .i_bimc_monitor                      (i_bimc_monitor[`CR_CCEIP_64_SUPPORT_C_BIMC_MONITOR_T_DECL]),
   .i_bimc_ecc_uncorrectable_error_cnt  (i_bimc_ecc_uncorrectable_error_cnt[`CR_CCEIP_64_SUPPORT_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]),
   .i_bimc_ecc_correctable_error_cnt    (i_bimc_ecc_correctable_error_cnt[`CR_CCEIP_64_SUPPORT_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]),
   .i_bimc_parity_error_cnt             (i_bimc_parity_error_cnt[`CR_CCEIP_64_SUPPORT_C_BIMC_PARITY_ERROR_CNT_T_DECL]),
   .i_bimc_global_config                (i_bimc_global_config[`CR_CCEIP_64_SUPPORT_C_BIMC_GLOBAL_CONFIG_T_DECL]),
   .i_bimc_memid                        (i_bimc_memid[`CR_CCEIP_64_SUPPORT_C_BIMC_MEMID_T_DECL]),
   .i_bimc_eccpar_debug                 (i_bimc_eccpar_debug[`CR_CCEIP_64_SUPPORT_C_BIMC_ECCPAR_DEBUG_T_DECL]),
   .i_bimc_cmd2                         (i_bimc_cmd2[`CR_CCEIP_64_SUPPORT_C_BIMC_CMD2_T_DECL]),
   .i_bimc_rxcmd2                       (i_bimc_rxcmd2[`CR_CCEIP_64_SUPPORT_C_BIMC_RXCMD2_T_DECL]),
   .i_bimc_rxcmd1                       (i_bimc_rxcmd1[`CR_CCEIP_64_SUPPORT_C_BIMC_RXCMD1_T_DECL]),
   .i_bimc_rxcmd0                       (i_bimc_rxcmd0[`CR_CCEIP_64_SUPPORT_C_BIMC_RXCMD0_T_DECL]),
   .i_bimc_rxrsp2                       (i_bimc_rxrsp2[`CR_CCEIP_64_SUPPORT_C_BIMC_RXRSP2_T_DECL]),
   .i_bimc_rxrsp1                       (i_bimc_rxrsp1[`CR_CCEIP_64_SUPPORT_C_BIMC_RXRSP1_T_DECL]),
   .i_bimc_rxrsp0                       (i_bimc_rxrsp0[`CR_CCEIP_64_SUPPORT_C_BIMC_RXRSP0_T_DECL]),
   .i_bimc_pollrsp2                     (i_bimc_pollrsp2[`CR_CCEIP_64_SUPPORT_C_BIMC_POLLRSP2_T_DECL]),
   .i_bimc_pollrsp1                     (i_bimc_pollrsp1[`CR_CCEIP_64_SUPPORT_C_BIMC_POLLRSP1_T_DECL]),
   .i_bimc_pollrsp0                     (i_bimc_pollrsp0[`CR_CCEIP_64_SUPPORT_C_BIMC_POLLRSP0_T_DECL]),
   .i_bimc_dbgcmd2                      (i_bimc_dbgcmd2[`CR_CCEIP_64_SUPPORT_C_BIMC_DBGCMD2_T_DECL]),
   .i_bimc_dbgcmd1                      (i_bimc_dbgcmd1[`CR_CCEIP_64_SUPPORT_C_BIMC_DBGCMD1_T_DECL]),
   .i_bimc_dbgcmd0                      (i_bimc_dbgcmd0[`CR_CCEIP_64_SUPPORT_C_BIMC_DBGCMD0_T_DECL]),
   .i_cceip_int0_int_control_data       (i_cceip_int0_int_control_data[`CR_CCEIP_64_SUPPORT_C_CCEIP_INT0_INT_CONTROL_DATA_DECL]),
   .i_cceip_int0_int_control_ack        (i_cceip_int0_int_control_ack),
   .i_cceip_int1_int_control_data       (i_cceip_int1_int_control_data[`CR_CCEIP_64_SUPPORT_C_CCEIP_INT1_INT_CONTROL_DATA_DECL]),
   .i_cceip_int1_int_control_ack        (i_cceip_int1_int_control_ack));

   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
	 
         
         im_available_he_lng_reg <= 0;
         im_available_he_sh_reg <= 0;
         im_available_he_st_lng_reg <= 0;
         im_available_he_st_sh_reg <= 0;
         im_available_htf_bl_reg <= 0;
         im_available_lz77c_reg <= 0;
         im_available_lz77d_reg <= 0;
         im_available_xpc_reg <= 0;
         im_available_xpd_reg <= 0;
         im_consumed_he_lng.bank_hi <= 0;
         im_consumed_he_lng.bank_lo <= 0;
         im_consumed_he_sh.bank_hi <= 0;
         im_consumed_he_sh.bank_lo <= 0;
         im_consumed_he_st_lng.bank_hi <= 0;
         im_consumed_he_st_lng.bank_lo <= 0;
         im_consumed_he_st_sh.bank_hi <= 0;
         im_consumed_he_st_sh.bank_lo <= 0;
         im_consumed_htf_bl.bank_hi <= 0;
         im_consumed_htf_bl.bank_lo <= 0;
         im_consumed_lz77c.bank_hi <= 0;
         im_consumed_lz77c.bank_lo <= 0;
         im_consumed_lz77d.bank_hi <= 0;
         im_consumed_lz77d.bank_lo <= 0;
         im_consumed_xpc.bank_hi <= 0;
         im_consumed_xpc.bank_lo <= 0;
         im_consumed_xpd.bank_hi <= 0;
         im_consumed_xpd.bank_lo <= 0;
         
      end
      else begin
	 im_consumed_lz77c.bank_hi <= 0;
	 im_consumed_lz77c.bank_lo <= 0;
	 im_consumed_lz77d.bank_hi <= 0;
	 im_consumed_lz77d.bank_lo <= 0;
	 im_consumed_htf_bl.bank_lo <= 0;
	 im_consumed_htf_bl.bank_hi <= 0;
	 im_consumed_xpc.bank_hi <= 0;
	 im_consumed_xpc.bank_lo <= 0;
	 im_consumed_xpd.bank_hi <= 0;
	 im_consumed_xpd.bank_lo <= 0;
	 im_consumed_he_sh.bank_hi <= 0;
	 im_consumed_he_sh.bank_lo <= 0;
         im_consumed_he_lng.bank_hi <= 0;
	 im_consumed_he_lng.bank_lo <= 0;
         im_consumed_he_st_sh.bank_hi <= 0;
	 im_consumed_he_st_sh.bank_lo <= 0;
         im_consumed_he_st_lng.bank_hi <= 0;
	 im_consumed_he_st_lng.bank_lo <= 0;
	 
	 im_available_lz77c_reg <= im_available_lz77c;
	 im_available_lz77d_reg <= im_available_lz77d;
	 im_available_htf_bl_reg <= im_available_htf_bl;
	 im_available_xpc_reg <= im_available_xpc;
	 im_available_xpd_reg <= im_available_xpd;
	 im_available_he_sh_reg <= im_available_he_sh;
	 im_available_he_lng_reg <= im_available_he_lng;
	 im_available_he_st_sh_reg <= im_available_he_st_sh;
	 im_available_he_st_lng_reg <= im_available_he_st_lng;
	 if (wr_stb && (reg_addr == `CR_CCEIP_64_SUPPORT_IM_CONSUMED)) begin
	    if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_LZ77_COMP_BANK_LO])       im_consumed_lz77c.bank_lo <= 1'd1;
	    if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_LZ77_COMP_BANK_HI])       im_consumed_lz77c.bank_hi <= 1'd1;
	    if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_LZ77_DECOMP_BANK_LO])     im_consumed_lz77d.bank_lo <= 1'd1;
	    if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_LZ77_DECOMP_BANK_HI])     im_consumed_lz77d.bank_hi <= 1'd1;
	    if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_HTF_BL_BANK_LO])          im_consumed_htf_bl.bank_lo <= 1'd1; 
	    if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_HTF_BL_BANK_HI])          im_consumed_htf_bl.bank_hi <= 1'd1; 
	    if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_XP10_DECOMP_BANK_LO])     im_consumed_xpd.bank_lo <= 1'd1;   
	    if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_XP10_DECOMP_BANK_HI])     im_consumed_xpd.bank_hi <= 1'd1;     
	    if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_XP10_COMP_BANK_LO])       im_consumed_xpc.bank_lo <= 1'd1;        
	    if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_XP10_COMP_BANK_HI])       im_consumed_xpc.bank_hi <= 1'd1;        
            if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_HE_SH_BL_BANK_LO])        im_consumed_he_sh.bank_lo <= 1'd1;        
	    if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_HE_SH_BL_BANK_HI])        im_consumed_he_sh.bank_hi <= 1'd1; 
            if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_HE_LNG_BL_BANK_LO])       im_consumed_he_lng.bank_lo <= 1'd1;        
	    if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_HE_LNG_BL_BANK_HI])       im_consumed_he_lng.bank_hi <= 1'd1; 
            if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_HE_ST_SH_BL_BANK_LO])     im_consumed_he_st_sh.bank_lo <= 1'd1;        
	    if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_HE_ST_SH_BL_BANK_HI])     im_consumed_he_st_sh.bank_hi <= 1'd1; 
            if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_HE_ST_LNG_BL_BANK_LO])    im_consumed_he_st_lng.bank_lo <= 1'd1;        
	    if (wr_data[`CR_CCEIP_64_SUPPORT_FULL_IM_CONSUMED_T_HE_ST_LNG_BL_BANK_HI])    im_consumed_he_st_lng.bank_hi <= 1'd1;                   
	 end
      end
   end
   
  
  
  nx_rbus_ring 
  #(
    .N_RBUS_ADDR_BITS (`N_RBUS_ADDR_BITS),             
    .N_LOCL_ADDR_BITS (`CR_CCEIP_64_SUPPORT_WIDTH),           
    .N_RBUS_DATA_BITS (`N_RBUS_DATA_BITS))             
  u_nx_rbus_ring 
  (.*,
   
   .rbus_addr_o                         (rbus_ring_o.addr),      
   .rbus_wr_strb_o                      (rbus_ring_o.wr_strb),   
   .rbus_wr_data_o                      (rbus_ring_o.wr_data),   
   .rbus_rd_strb_o                      (rbus_ring_o.rd_strb),   
   .locl_addr_o                         (locl_addr),             
   .locl_wr_strb_o                      (locl_wr_strb),          
   .locl_wr_data_o                      (locl_wr_data),          
   .locl_rd_strb_o                      (locl_rd_strb),          
   .rbus_rd_data_o                      (rbus_ring_o.rd_data),   
   .rbus_ack_o                          (rbus_ring_o.ack),       
   .rbus_err_ack_o                      (rbus_ring_o.err_ack),   
   
   .rbus_addr_i                         (rbus_ring_i.addr),      
   .rbus_wr_strb_i                      (rbus_ring_i.wr_strb),   
   .rbus_wr_data_i                      (rbus_ring_i.wr_data),   
   .rbus_rd_strb_i                      (rbus_ring_i.rd_strb),   
   .rbus_rd_data_i                      (rbus_ring_i.rd_data),   
   .rbus_ack_i                          (rbus_ring_i.ack),       
   .rbus_err_ack_i                      (rbus_ring_i.err_ack),   
   .locl_rd_data_i                      (locl_rd_data),          
   .locl_ack_i                          (locl_ack),              
   .locl_err_ack_i                      (locl_err_ack));          


  
   
   bimc_master bimc_master   
   (
    
    .bimc_ecc_error                     (bimc_ecc_error),
    .bimc_interrupt                     (top_bimc_int),          
    .bimc_odat                          (top_bimc_mstr_odat),    
    .bimc_rst_n                         (top_bimc_mstr_rst_n),   
    .bimc_osync                         (top_bimc_mstr_osync),   
    .i_bimc_monitor                     (i_bimc_monitor[`CR_C_BIMC_MONITOR_T_DECL]),
    .i_bimc_ecc_uncorrectable_error_cnt (i_bimc_ecc_uncorrectable_error_cnt[`CR_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]),
    .i_bimc_ecc_correctable_error_cnt   (i_bimc_ecc_correctable_error_cnt[`CR_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]),
    .i_bimc_parity_error_cnt            (i_bimc_parity_error_cnt[`CR_C_BIMC_PARITY_ERROR_CNT_T_DECL]),
    .i_bimc_global_config               (i_bimc_global_config[`CR_C_BIMC_GLOBAL_CONFIG_T_DECL]),
    .i_bimc_memid                       (i_bimc_memid[`CR_C_BIMC_MEMID_T_DECL]),
    .i_bimc_eccpar_debug                (i_bimc_eccpar_debug[`CR_C_BIMC_ECCPAR_DEBUG_T_DECL]),
    .i_bimc_cmd2                        (i_bimc_cmd2[`CR_C_BIMC_CMD2_T_DECL]),
    .i_bimc_rxcmd2                      (i_bimc_rxcmd2[`CR_C_BIMC_RXCMD2_T_DECL]),
    .i_bimc_rxcmd1                      (i_bimc_rxcmd1[`CR_C_BIMC_RXCMD1_T_DECL]),
    .i_bimc_rxcmd0                      (i_bimc_rxcmd0[`CR_C_BIMC_RXCMD0_T_DECL]),
    .i_bimc_rxrsp2                      (i_bimc_rxrsp2[`CR_C_BIMC_RXRSP2_T_DECL]),
    .i_bimc_rxrsp1                      (i_bimc_rxrsp1[`CR_C_BIMC_RXRSP1_T_DECL]),
    .i_bimc_rxrsp0                      (i_bimc_rxrsp0[`CR_C_BIMC_RXRSP0_T_DECL]),
    .i_bimc_pollrsp2                    (i_bimc_pollrsp2[`CR_C_BIMC_POLLRSP2_T_DECL]),
    .i_bimc_pollrsp1                    (i_bimc_pollrsp1[`CR_C_BIMC_POLLRSP1_T_DECL]),
    .i_bimc_pollrsp0                    (i_bimc_pollrsp0[`CR_C_BIMC_POLLRSP0_T_DECL]),
    .i_bimc_dbgcmd2                     (i_bimc_dbgcmd2[`CR_C_BIMC_DBGCMD2_T_DECL]),
    .i_bimc_dbgcmd1                     (i_bimc_dbgcmd1[`CR_C_BIMC_DBGCMD1_T_DECL]),
    .i_bimc_dbgcmd0                     (i_bimc_dbgcmd0[`CR_C_BIMC_DBGCMD0_T_DECL]),
    
    .clk                                (clk),
    .rst_n                              (rst_n),
    .bimc_idat                          (top_bimc_mstr_idat),    
    .bimc_isync                         (top_bimc_mstr_isync),   
    .o_bimc_monitor_mask                (o_bimc_monitor_mask[`CR_C_BIMC_MONITOR_MASK_T_DECL]),
    .o_bimc_ecc_uncorrectable_error_cnt (o_bimc_ecc_uncorrectable_error_cnt[`CR_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]),
    .o_bimc_ecc_correctable_error_cnt   (o_bimc_ecc_correctable_error_cnt[`CR_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]),
    .o_bimc_parity_error_cnt            (o_bimc_parity_error_cnt[`CR_C_BIMC_PARITY_ERROR_CNT_T_DECL]),
    .o_bimc_global_config               (o_bimc_global_config[`CR_C_BIMC_GLOBAL_CONFIG_T_DECL]),
    .o_bimc_eccpar_debug                (o_bimc_eccpar_debug[`CR_C_BIMC_ECCPAR_DEBUG_T_DECL]),
    .o_bimc_cmd2                        (o_bimc_cmd2[`CR_C_BIMC_CMD2_T_DECL]),
    .o_bimc_cmd1                        (o_bimc_cmd1[`CR_C_BIMC_CMD1_T_DECL]),
    .o_bimc_cmd0                        (o_bimc_cmd0[`CR_C_BIMC_CMD0_T_DECL]),
    .o_bimc_rxcmd2                      (o_bimc_rxcmd2[`CR_C_BIMC_RXCMD2_T_DECL]),
    .o_bimc_rxrsp2                      (o_bimc_rxrsp2[`CR_C_BIMC_RXRSP2_T_DECL]),
    .o_bimc_pollrsp2                    (o_bimc_pollrsp2[`CR_C_BIMC_POLLRSP2_T_DECL]),
    .o_bimc_dbgcmd2                     (o_bimc_dbgcmd2[`CR_C_BIMC_DBGCMD2_T_DECL]));


endmodule 











