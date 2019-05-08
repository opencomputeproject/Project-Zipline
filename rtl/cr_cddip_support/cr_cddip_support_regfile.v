/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_cddip_support.vh"

module cr_cddip_support_regfile 

  (
  
  rbus_ring_o, im_consumed_lz77d, im_consumed_htf_bl, im_consumed_xpd,
  top_bimc_mstr_rst_n, top_bimc_mstr_osync, top_bimc_mstr_odat,
  pre_cddip_int, ctl_config,
  
  rst_n, clk, cfg_start_addr, cfg_end_addr, rbus_ring_i,
  im_available_lz77d, im_available_htf_bl, im_available_xpd,
  top_bimc_mstr_idat, top_bimc_mstr_isync, pipe_stat,
  prefix_attach_int, xp10_decomp_int, crcg0_int, crcc0_int, cg_int,
  su_int, osf_int, isf_int
  );

`include "cr_structs.sv"
`include "bimc_master.vh"  
  import cr_cddip_supportPKG::*;
  import cr_cddip_support_regfilePKG::*;

  
  output rbus_ring_t           rbus_ring_o;
  output im_consumed_t         im_consumed_lz77d;
  output im_consumed_t         im_consumed_htf_bl;
  output im_consumed_t         im_consumed_xpd;
  output                       top_bimc_mstr_rst_n;  
  output                       top_bimc_mstr_osync;
  output                       top_bimc_mstr_odat;   
  output                       pre_cddip_int;
  output ctl_t                 ctl_config;  

  
  input  		       rst_n;
  input  		       clk;
  input [`N_RBUS_ADDR_BITS-1:0] cfg_start_addr;
  input [`N_RBUS_ADDR_BITS-1:0] cfg_end_addr;
  input                        rbus_ring_t rbus_ring_i;
  input im_available_t         im_available_lz77d;
  input im_available_t         im_available_htf_bl;
  input im_available_t         im_available_xpd;
  input                        top_bimc_mstr_idat;   
  input                        top_bimc_mstr_isync;  
  input pipe_stat_t            pipe_stat;
   
  input tlvp_int_t             prefix_attach_int;
  input generic_int_t          xp10_decomp_int;
  input tlvp_int_t             crcg0_int;
  input tlvp_int_t             crcc0_int;
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
  logic                 i_cddip_int_control_ack;
  logic [`BIT_VEC((`CR_CDDIP_SUPPORT_C_CDDIP_INT_CONTROL_DATA_WIDTH))] i_cddip_int_control_data;
  logic                 locl_ack;               
  logic                 locl_err_ack;           
  logic [31:0]          locl_rd_data;           
  logic                 locl_rd_strb;           
  logic                 locl_wr_strb;           
  logic [`CR_CDDIP_SUPPORT_C_BIMC_CMD0_T_DECL] o_bimc_cmd0;
  logic [`CR_CDDIP_SUPPORT_C_BIMC_CMD1_T_DECL] o_bimc_cmd1;
  logic [`CR_CDDIP_SUPPORT_C_BIMC_CMD2_T_DECL] o_bimc_cmd2;
  logic [`CR_CDDIP_SUPPORT_C_BIMC_DBGCMD2_T_DECL] o_bimc_dbgcmd2;
  logic [`CR_CDDIP_SUPPORT_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_correctable_error_cnt;
  logic [`CR_CDDIP_SUPPORT_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_uncorrectable_error_cnt;
  logic [`CR_CDDIP_SUPPORT_C_BIMC_ECCPAR_DEBUG_T_DECL] o_bimc_eccpar_debug;
  logic [`CR_CDDIP_SUPPORT_C_BIMC_GLOBAL_CONFIG_T_DECL] o_bimc_global_config;
  logic [`CR_CDDIP_SUPPORT_C_BIMC_MONITOR_MASK_T_DECL] o_bimc_monitor_mask;
  logic [`CR_CDDIP_SUPPORT_C_BIMC_PARITY_ERROR_CNT_T_DECL] o_bimc_parity_error_cnt;
  logic [`CR_CDDIP_SUPPORT_C_BIMC_POLLRSP2_T_DECL] o_bimc_pollrsp2;
  logic [`CR_CDDIP_SUPPORT_C_BIMC_RXCMD2_T_DECL] o_bimc_rxcmd2;
  logic [`CR_CDDIP_SUPPORT_C_BIMC_RXRSP2_T_DECL] o_bimc_rxrsp2;
  logic [`CR_CDDIP_SUPPORT_CDDIP_INT_CONTROL_ADDR_DECL] o_cddip_int_control_addr;
  logic [`CR_CDDIP_SUPPORT_C_CDDIP_INT_CONTROL_DATA_DECL] o_cddip_int_control_data;
  logic                 o_cddip_int_control_read;
  logic                 o_cddip_int_control_write;
  logic [`CR_CDDIP_SUPPORT_C_SOFT_RST_T_DECL] o_soft_rst;
  logic                 rd_stb;                 
  logic                 top_bimc_int;           
  logic                 wr_stb;                 
  
  
  logic [`CR_CDDIP_SUPPORT_DECL]    reg_addr;
  logic [`CR_CDDIP_SUPPORT_DECL]    locl_addr;
  logic [`N_RBUS_DATA_BITS-1:0]     locl_wr_data;
  logic [`N_RBUS_DATA_BITS-1:0]     wr_data; 
  spare_t                           spare;    
  logic [20:0]                      cddip_int_stb; 

  logic [`CR_CDDIP_SUPPORT_C_IM_AVAILABLE_T_DECL]  im_available;
  im_available_t im_available_xpd_reg;
  im_available_t im_available_lz77d_reg;
  im_available_t im_available_htf_bl_reg;
   
   
   always_comb begin
     im_available[`CR_CDDIP_SUPPORT_FULL_IM_AVAILABLE_T_HTF_BL_BANK_LO]   = im_available_htf_bl_reg.bank_lo;         
     im_available[`CR_CDDIP_SUPPORT_FULL_IM_AVAILABLE_T_HTF_BL_BANK_HI]   = im_available_htf_bl_reg.bank_hi;         
     im_available[`CR_CDDIP_SUPPORT_FULL_IM_AVAILABLE_T_LZ77_DECOMP_BANK_LO]   = im_available_lz77d_reg.bank_lo;         
     im_available[`CR_CDDIP_SUPPORT_FULL_IM_AVAILABLE_T_LZ77_DECOMP_BANK_HI]   = im_available_lz77d_reg.bank_hi;          
     im_available[`CR_CDDIP_SUPPORT_FULL_IM_AVAILABLE_T_XP10_DECOMP_BANK_LO]      = im_available_xpd_reg.bank_lo;        
     im_available[`CR_CDDIP_SUPPORT_FULL_IM_AVAILABLE_T_XP10_DECOMP_BANK_HI]      = im_available_xpd_reg.bank_hi;        
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

  assign cddip_int_stb  = 
                          {
                           xp10_decomp_int.tlvp_err,
                           xp10_decomp_int.uncor_ecc_err,
                           xp10_decomp_int.bimc_int,
                           top_bimc_int,
                           su_int.uncor_ecc_err,
                           cg_int.tlvp_err,
                           crcc0_int.tlvp_err,
                           crcg0_int.tlvp_err,
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

  
  assign blkid_revid_wire.f.blkid[15:0] = `CR_CDDIP_BLKID;

  genvar                               i;
  
   

  nx_event_interrupt
    #(.N_ADDR_BITS  (`CR_CDDIP_SUPPORT_CDDIP_INT_CONTROL_ADDR_WIDTH),        
      .N_INT_BITS   (`CR_CDDIP_SUPPORT_C_CDDIP_INT_CONTROL_DATA_WIDTH))      
  u_cddip_support_interrupt
   (
    
    .int_data_out                       (i_cddip_int_control_data[`BIT_VEC((`CR_CDDIP_SUPPORT_C_CDDIP_INT_CONTROL_DATA_WIDTH))]), 
    .int_ack                            (i_cddip_int_control_ack), 
    .int_out                            (pre_cddip_int),         
    
    .clk                                (clk),                   
    .rst_n                              (rst_n),                 
    .reg_addr                           (o_cddip_int_control_addr[`BIT_VEC((`CR_CDDIP_SUPPORT_CDDIP_INT_CONTROL_ADDR_WIDTH))]), 
    .rd_stb                             (o_cddip_int_control_read), 
    .wr_stb                             (o_cddip_int_control_write), 
    .int_stb                            (cddip_int_stb[`BIT_VEC((`CR_CDDIP_SUPPORT_C_CDDIP_INT_CONTROL_DATA_WIDTH))]), 
    .int_data_in                        (o_cddip_int_control_data[`BIT_VEC((`CR_CDDIP_SUPPORT_C_CDDIP_INT_CONTROL_DATA_WIDTH))])); 

   

  
  cr_cddip_support_regs u_cr_cddip_support_regs 
  (
   
   
   .o_rd_data                           (locl_rd_data[31:0]),    
   .o_ack                               (locl_ack),              
   .o_err_ack                           (locl_err_ack),          
   .o_spare_config                      (spare),                 
   .o_im_consumed                       (),                      
   .o_soft_rst                          (o_soft_rst[`CR_CDDIP_SUPPORT_C_SOFT_RST_T_DECL]),
   .o_ctl                               (ctl_config),            
   .o_bimc_monitor_mask                 (o_bimc_monitor_mask[`CR_CDDIP_SUPPORT_C_BIMC_MONITOR_MASK_T_DECL]),
   .o_bimc_ecc_uncorrectable_error_cnt  (o_bimc_ecc_uncorrectable_error_cnt[`CR_CDDIP_SUPPORT_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]),
   .o_bimc_ecc_correctable_error_cnt    (o_bimc_ecc_correctable_error_cnt[`CR_CDDIP_SUPPORT_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]),
   .o_bimc_parity_error_cnt             (o_bimc_parity_error_cnt[`CR_CDDIP_SUPPORT_C_BIMC_PARITY_ERROR_CNT_T_DECL]),
   .o_bimc_global_config                (o_bimc_global_config[`CR_CDDIP_SUPPORT_C_BIMC_GLOBAL_CONFIG_T_DECL]),
   .o_bimc_eccpar_debug                 (o_bimc_eccpar_debug[`CR_CDDIP_SUPPORT_C_BIMC_ECCPAR_DEBUG_T_DECL]),
   .o_bimc_cmd2                         (o_bimc_cmd2[`CR_CDDIP_SUPPORT_C_BIMC_CMD2_T_DECL]),
   .o_bimc_cmd1                         (o_bimc_cmd1[`CR_CDDIP_SUPPORT_C_BIMC_CMD1_T_DECL]),
   .o_bimc_cmd0                         (o_bimc_cmd0[`CR_CDDIP_SUPPORT_C_BIMC_CMD0_T_DECL]),
   .o_bimc_rxcmd2                       (o_bimc_rxcmd2[`CR_CDDIP_SUPPORT_C_BIMC_RXCMD2_T_DECL]),
   .o_bimc_rxrsp2                       (o_bimc_rxrsp2[`CR_CDDIP_SUPPORT_C_BIMC_RXRSP2_T_DECL]),
   .o_bimc_pollrsp2                     (o_bimc_pollrsp2[`CR_CDDIP_SUPPORT_C_BIMC_POLLRSP2_T_DECL]),
   .o_bimc_dbgcmd2                      (o_bimc_dbgcmd2[`CR_CDDIP_SUPPORT_C_BIMC_DBGCMD2_T_DECL]),
   .o_cddip_int_control_read            (o_cddip_int_control_read),
   .o_cddip_int_control_write           (o_cddip_int_control_write),
   .o_cddip_int_control_data            (o_cddip_int_control_data[`CR_CDDIP_SUPPORT_C_CDDIP_INT_CONTROL_DATA_DECL]),
   .o_cddip_int_control_addr            (o_cddip_int_control_addr[`CR_CDDIP_SUPPORT_CDDIP_INT_CONTROL_ADDR_DECL]),
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
   .i_im_consumed                       (`CR_CDDIP_SUPPORT_C_IM_CONSUMED_T_WIDTH'd0), 
   .i_soft_rst                          (o_soft_rst),            
   .i_ctl                               (ctl_config),            
   .i_pipe_stat                         (pipe_stat),             
   .i_bimc_monitor                      (i_bimc_monitor[`CR_CDDIP_SUPPORT_C_BIMC_MONITOR_T_DECL]),
   .i_bimc_ecc_uncorrectable_error_cnt  (i_bimc_ecc_uncorrectable_error_cnt[`CR_CDDIP_SUPPORT_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL]),
   .i_bimc_ecc_correctable_error_cnt    (i_bimc_ecc_correctable_error_cnt[`CR_CDDIP_SUPPORT_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL]),
   .i_bimc_parity_error_cnt             (i_bimc_parity_error_cnt[`CR_CDDIP_SUPPORT_C_BIMC_PARITY_ERROR_CNT_T_DECL]),
   .i_bimc_global_config                (i_bimc_global_config[`CR_CDDIP_SUPPORT_C_BIMC_GLOBAL_CONFIG_T_DECL]),
   .i_bimc_memid                        (i_bimc_memid[`CR_CDDIP_SUPPORT_C_BIMC_MEMID_T_DECL]),
   .i_bimc_eccpar_debug                 (i_bimc_eccpar_debug[`CR_CDDIP_SUPPORT_C_BIMC_ECCPAR_DEBUG_T_DECL]),
   .i_bimc_cmd2                         (i_bimc_cmd2[`CR_CDDIP_SUPPORT_C_BIMC_CMD2_T_DECL]),
   .i_bimc_rxcmd2                       (i_bimc_rxcmd2[`CR_CDDIP_SUPPORT_C_BIMC_RXCMD2_T_DECL]),
   .i_bimc_rxcmd1                       (i_bimc_rxcmd1[`CR_CDDIP_SUPPORT_C_BIMC_RXCMD1_T_DECL]),
   .i_bimc_rxcmd0                       (i_bimc_rxcmd0[`CR_CDDIP_SUPPORT_C_BIMC_RXCMD0_T_DECL]),
   .i_bimc_rxrsp2                       (i_bimc_rxrsp2[`CR_CDDIP_SUPPORT_C_BIMC_RXRSP2_T_DECL]),
   .i_bimc_rxrsp1                       (i_bimc_rxrsp1[`CR_CDDIP_SUPPORT_C_BIMC_RXRSP1_T_DECL]),
   .i_bimc_rxrsp0                       (i_bimc_rxrsp0[`CR_CDDIP_SUPPORT_C_BIMC_RXRSP0_T_DECL]),
   .i_bimc_pollrsp2                     (i_bimc_pollrsp2[`CR_CDDIP_SUPPORT_C_BIMC_POLLRSP2_T_DECL]),
   .i_bimc_pollrsp1                     (i_bimc_pollrsp1[`CR_CDDIP_SUPPORT_C_BIMC_POLLRSP1_T_DECL]),
   .i_bimc_pollrsp0                     (i_bimc_pollrsp0[`CR_CDDIP_SUPPORT_C_BIMC_POLLRSP0_T_DECL]),
   .i_bimc_dbgcmd2                      (i_bimc_dbgcmd2[`CR_CDDIP_SUPPORT_C_BIMC_DBGCMD2_T_DECL]),
   .i_bimc_dbgcmd1                      (i_bimc_dbgcmd1[`CR_CDDIP_SUPPORT_C_BIMC_DBGCMD1_T_DECL]),
   .i_bimc_dbgcmd0                      (i_bimc_dbgcmd0[`CR_CDDIP_SUPPORT_C_BIMC_DBGCMD0_T_DECL]),
   .i_cddip_int_control_data            (i_cddip_int_control_data[`CR_CDDIP_SUPPORT_C_CDDIP_INT_CONTROL_DATA_DECL]),
   .i_cddip_int_control_ack             (i_cddip_int_control_ack));


  
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
	 
         
         im_available_htf_bl_reg <= 0;
         im_available_lz77d_reg <= 0;
         im_available_xpd_reg <= 0;
         im_consumed_htf_bl.bank_hi <= 0;
         im_consumed_htf_bl.bank_lo <= 0;
         im_consumed_lz77d.bank_hi <= 0;
         im_consumed_lz77d.bank_lo <= 0;
         im_consumed_xpd.bank_hi <= 0;
         im_consumed_xpd.bank_lo <= 0;
         
      end
      else begin
	im_consumed_xpd.bank_hi   <= 0;
	im_consumed_xpd.bank_lo   <= 0;
	im_consumed_lz77d.bank_hi <= 0;
	im_consumed_lz77d.bank_lo <= 0;
	im_consumed_htf_bl.bank_hi <= 0;
	im_consumed_htf_bl.bank_lo <= 0;
	im_available_htf_bl_reg <= im_available_htf_bl;
	im_available_lz77d_reg    <= im_available_lz77d;
	im_available_xpd_reg      <= im_available_xpd;
	 if (wr_stb && (reg_addr == `CR_CDDIP_SUPPORT_IM_CONSUMED)) begin
	    if (wr_data[`CR_CDDIP_SUPPORT_FULL_IM_CONSUMED_T_HTF_BL_BANK_LO])  im_consumed_htf_bl.bank_lo <= 1'd1;
	    if (wr_data[`CR_CDDIP_SUPPORT_FULL_IM_CONSUMED_T_HTF_BL_BANK_HI])  im_consumed_htf_bl.bank_hi <= 1'd1;
	    if (wr_data[`CR_CDDIP_SUPPORT_FULL_IM_CONSUMED_T_LZ77_DECOMP_BANK_LO])  im_consumed_lz77d.bank_lo <= 1'd1;
	    if (wr_data[`CR_CDDIP_SUPPORT_FULL_IM_CONSUMED_T_LZ77_DECOMP_BANK_HI])  im_consumed_lz77d.bank_hi <= 1'd1;
	    if (wr_data[`CR_CDDIP_SUPPORT_FULL_IM_CONSUMED_T_XP10_DECOMP_BANK_LO])     im_consumed_xpd.bank_lo <= 1'd1;   
	    if (wr_data[`CR_CDDIP_SUPPORT_FULL_IM_CONSUMED_T_XP10_DECOMP_BANK_HI])     im_consumed_xpd.bank_hi <= 1'd1;     
	 end
      end
   end
  
  
  
  nx_rbus_ring 
  #(
    .N_RBUS_ADDR_BITS (`N_RBUS_ADDR_BITS),             
    .N_LOCL_ADDR_BITS (`CR_CDDIP_SUPPORT_WIDTH),       
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










