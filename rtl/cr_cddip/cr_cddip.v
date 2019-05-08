/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/









`include "cr_global_params.vh"  

module cr_cddip
#(parameter 
  PREFIX_ATTACH_STUB = 0,
  XP10_DECOMP_STUB = 0,
  FPGA_MOD           = 0

  
  ) 
(
 
  
  ib_tready, ob_tvalid, ob_tlast, ob_tid, ob_tstrb, ob_tuser,
  ob_tdata, sch_update_tvalid, sch_update_tlast, sch_update_tuser,
  sch_update_tdata, apb_prdata, apb_pready, apb_pslverr, cddip_int,
  cddip_idle,
  
  clk, rst_n, scan_en, scan_mode, scan_rst_n, ovstb, lvm, mlvm,
  ib_tvalid, ib_tlast, ib_tid, ib_tstrb, ib_tuser, ib_tdata,
  ob_tready, sch_update_tready, apb_paddr, apb_psel, apb_penable,
  apb_pwrite, apb_pwdata, dbg_cmd_disable, xp9_disable
  );

`include "cr_cddip_regs.vh"
`include "cr_structs.sv"

  
  
  
  input                           clk;
  input                           rst_n; 

  
  
  
  input                           scan_en;
  input                           scan_mode;
  input                           scan_rst_n;

  
  
  
  input                           ovstb;
  input                           lvm;
  input                           mlvm;
  


  
  
  
  input                           ib_tvalid;
  input                           ib_tlast;
  input [`AXI_S_TID_WIDTH-1:0]    ib_tid;
  input [`AXI_S_TSTRB_WIDTH-1:0]  ib_tstrb;
  input [`AXI_S_USER_WIDTH-1:0]   ib_tuser;
  input [`AXI_S_DP_DWIDTH-1:0]    ib_tdata;
  output                          ib_tready;

  
  
  
  output                          ob_tvalid;
  output                          ob_tlast;
  output [`AXI_S_TID_WIDTH-1:0]   ob_tid;
  output [`AXI_S_TSTRB_WIDTH-1:0] ob_tstrb;
  output [`AXI_S_USER_WIDTH-1:0]  ob_tuser;
  output [`AXI_S_DP_DWIDTH-1:0]   ob_tdata;
  input                           ob_tready;

  
  
  
  output                          sch_update_tvalid;
  output                          sch_update_tlast;
  output [1:0]                    sch_update_tuser;
  output [7:0]                    sch_update_tdata;
  input                           sch_update_tready;

  
  
  
  input  [`N_RBUS_ADDR_BITS-1:0]  apb_paddr;
  input                           apb_psel;
  input                           apb_penable;
  input                           apb_pwrite;
  input  [`N_RBUS_DATA_BITS-1:0]  apb_pwdata;  
  output [`N_RBUS_DATA_BITS-1:0]  apb_prdata;
  output                          apb_pready;                      
  output                          apb_pslverr;                     

  
  
  
  input                           dbg_cmd_disable;
  input                           xp9_disable;

  
  
  
  output                          cddip_int;

  
  
  
  output                          cddip_idle;

  localparam STUB_MODE=1;

  
  
  axi4s_dp_rdy_t        cg_crcg0_ib_out;        
  tlvp_int_t            cg_int;                 
  axi4s_dp_bus_t        cg_osf_ob_out;          
  cg_stats_t            cg_sa_stat_events;      
  logic                 crcc0_int;              
  axi4s_dp_rdy_t        crcc0_isf_ib_out;       
  axi4s_dp_bus_t        crcc0_prefix_attach_ob_out;
  logic [`CRCGC_STATS_WIDTH-1:0] crcc0_sa_stat_events;
  logic                 crcg0_int;              
  axi4s_dp_bus_t        crcg0_ob_out;           
  logic [`CRCGC_STATS_WIDTH-1:0] crcg0_sa_stat_events;
  axi4s_dp_rdy_t        crcg0_xp10_decomp_ib_out;
  logic                 eng_self_test_en;       
  im_available_t        im_available_htf_bl;    
  im_consumed_t         im_consumed_htf_bl;     
  im_consumed_t         im_consumed_lz77d;      
  im_consumed_t         im_consumed_xpd;        
  logic                 isf_bimc_odat;          
  logic                 isf_bimc_osync;         
  axi4s_dp_bus_t        isf_crcc0_ob_out;       
  axi4s_dp_rdy_t        isf_ib_out;             
  isf_int_t             isf_int;                
  isf_stats_t           isf_sa_stat_events;     
  logic                 isf_sup_cqe_exit;       
  logic                 isf_sup_cqe_rx;         
  logic                 isf_sup_rqe_rx;         
  logic                 osf_bimc_odat;          
  logic                 osf_bimc_osync;         
  axi4s_dp_rdy_t        osf_cg_ib_out;          
  axi4s_dp_rdy_t        osf_crcg0_ib_out;       
  osf_int_t             osf_int;                
  axi4s_dp_bus_t        osf_ob_out;             
  osf_stats_t           osf_sa_stat_events;     
  logic                 osf_sup_cqe_exit;       
  logic                 prefix_attach_bimc_odat;
  logic                 prefix_attach_bimc_osync;
  axi4s_dp_rdy_t        prefix_attach_crcc0_ib_out;
  logic                 prefix_attach_int;      
  axi4s_dp_bus_t        prefix_attach_xp10_decomp_ob_out;
  logic                 rst_sync_n;             
  axi4s_su_dp_bus_t     sch_update_ob_out;      
  logic                 su_bimc_odat;           
  logic                 su_bimc_osync;          
  ecc_int_t             su_int;                 
  logic                 su_ready;               
  logic                 sup_osf_halt;           
  logic                 top_bimc_mstr_rst_n;    
  axi4s_dp_bus_t        xp10_decomp_crcg0_ob_out;
  logic [`HUFD_STATS_WIDTH-1:0] xp10_decomp_hufd_sa_stat_events;
  generic_int_t         xp10_decomp_int;        
  logic [`LZ77D_STATS_WIDTH-1:0] xp10_decomp_lz77d_sa_stat_events;
  axi4s_dp_rdy_t        xp10_decomp_prefix_attach_ib_out;
  sched_update_if_bus_t xp10_decomp_su_sch_update;
  

  
  
  
  axi4s_dp_bus_t         isf_ib_in; 
  axi4s_dp_rdy_t         osf_ob_in;
  axi4s_dp_rdy_t         crcg0_ob_in;
  axi4s_dp_rdy_t         sch_update_ob_in;

  rbus_ring_t            rbus_ring_i[`CR_CDDIP_N_BLKS-1:0]; 
  rbus_ring_t            rbus_ring_o[`CR_CDDIP_N_BLKS-1:0]; 
  rbus_ring_t            rbus_i;
  rbus_ring_t            rbus_o; 

  im_available_t         im_available_lz77d;   
  im_available_t         im_available_xpd;

  logic                  top_bimc_mstr_odat;
  logic                  top_bimc_mstr_osync;
  logic                  top_bimc_mstr_idat;
  logic                  top_bimc_mstr_isync;

  assign isf_ib_in.tvalid         = ib_tvalid & !eng_self_test_en;
  assign isf_ib_in.tlast          = ib_tlast;
  assign isf_ib_in.tid            = ib_tid;
  assign isf_ib_in.tstrb          = ib_tstrb;
  assign isf_ib_in.tuser          = ib_tuser;
  assign isf_ib_in.tdata          = ib_tdata;
  assign ib_tready                = isf_ib_out.tready | eng_self_test_en;

  assign ob_tvalid                = osf_ob_out.tvalid & !eng_self_test_en;
  assign ob_tlast                 = osf_ob_out.tlast;
  assign ob_tid                   = osf_ob_out.tid;
  assign ob_tstrb                 = osf_ob_out.tstrb;
  assign ob_tuser                 = osf_ob_out.tuser;
  assign ob_tdata                 = osf_ob_out.tdata;
  assign osf_ob_in.tready         = ob_tready | eng_self_test_en;

  assign sch_update_tvalid       = sch_update_ob_out.tvalid & !eng_self_test_en;
  assign sch_update_tlast        = sch_update_ob_out.tlast;
  assign sch_update_tuser        = sch_update_ob_out.tuser;
  assign sch_update_tdata        = sch_update_ob_out.tdata;
  assign sch_update_ob_in.tready = sch_update_tready | eng_self_test_en;

    
  always_comb
  for (int j=0; j<`CR_CDDIP_N_BLKS; j++) begin
    
    if (j==0) begin
      rbus_ring_i[j]         = 0;
      rbus_ring_i[j].addr    = rbus_i.addr;  
      rbus_ring_i[j].wr_strb = rbus_i.wr_strb;
      rbus_ring_i[j].wr_data = rbus_i.wr_data;
      rbus_ring_i[j].rd_strb = rbus_i.rd_strb;  
    end
    
    else begin
      rbus_ring_i[j]         = rbus_ring_o[j-1];
    end 
    
    if (j == `CR_CDDIP_N_BLKS-1) begin
      rbus_o.rd_data         = rbus_ring_o[j].rd_data;
      rbus_o.ack             = rbus_ring_o[j].ack;
      rbus_o.rd_strb         = rbus_ring_o[j].rd_strb;
      rbus_o.wr_strb         = rbus_ring_o[j].wr_strb;
      rbus_o.err_ack         = rbus_ring_o[j].err_ack;
    end
  end 

  
  
  

   

  cr_rst_sync u_cr_rst_sync_cddip
     (
      
      .rst_n                            (rst_sync_n),            
      
      .clk                              (clk),
      .async_rst_n                      (rst_n),                 
      .bypass_reset                     (scan_mode),             
      .test_rst_n                       (scan_rst_n));            


  
  
  

  
  
  
  nx_rbus_apb 
  #(.N_RBUS_ADDR_BITS(`N_RBUS_ADDR_BITS),  
    .N_RBUS_DATA_BITS(`N_RBUS_DATA_BITS))  
  u_nx_rbus_apb 
  (
   
   
   .rbus_addr_o                         (rbus_i.addr),           
   .rbus_wr_strb_o                      (rbus_i.wr_strb),        
   .rbus_wr_data_o                      (rbus_i.wr_data),        
   .rbus_rd_strb_o                      (rbus_i.rd_strb),        
   .apb_prdata                          (apb_prdata),            
   .apb_pready                          (apb_pready),
   .apb_pslverr                         (apb_pslverr),
   
   .clk                                 (clk),
   .rst_n                               (rst_sync_n),            
   .rbus_rd_data_i                      (rbus_o.rd_data),        
   .rbus_ack_i                          (rbus_o.ack),            
   .rbus_err_ack_i                      (rbus_o.err_ack),        
   .rbus_wr_strb_i                      (rbus_o.wr_strb),        
   .rbus_rd_strb_i                      (rbus_o.rd_strb),        
   .apb_paddr                           (apb_paddr),             
   .apb_psel                            (apb_psel),
   .apb_penable                         (apb_penable),
   .apb_pwrite                          (apb_pwrite),
   .apb_pwdata                          (apb_pwdata));            

  
  
  

   

  cr_cddip_support u_cr_cddip_support
  (
   
   
   .top_bimc_mstr_rst_n                 (top_bimc_mstr_rst_n),
   .top_bimc_mstr_osync                 (top_bimc_mstr_osync),
   .top_bimc_mstr_odat                  (top_bimc_mstr_odat),
   .rbus_ring_o                         (rbus_ring_o[0]),        
   .im_consumed_htf_bl                  (im_consumed_htf_bl),
   .im_consumed_lz77d                   (im_consumed_lz77d),
   .im_consumed_xpd                     (im_consumed_xpd),
   .cddip_int                           (cddip_int),
   .cddip_idle                          (cddip_idle),
   .sup_osf_halt                        (sup_osf_halt),
   
   .clk                                 (clk),
   .rst_n                               (rst_sync_n),            
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .top_bimc_mstr_idat                  (top_bimc_mstr_idat),
   .top_bimc_mstr_isync                 (top_bimc_mstr_isync),
   .rbus_ring_i                         (rbus_ring_i[0]),        
   .cfg_start_addr                      (`CDDIP_SUPPORT_RBUS_START), 
   .cfg_end_addr                        (`CDDIP_SUPPORT_RBUS_END), 
   .im_available_htf_bl                 (im_available_htf_bl),
   .im_available_lz77d                  (im_available_lz77d),
   .im_available_xpd                    (im_available_xpd),
   .osf_sup_cqe_exit                    (osf_sup_cqe_exit),
   .isf_sup_cqe_exit                    (isf_sup_cqe_exit),
   .isf_sup_cqe_rx                      (isf_sup_cqe_rx),
   .isf_sup_rqe_rx                      (isf_sup_rqe_rx),
   .prefix_attach_int                   (prefix_attach_int),
   .xp10_decomp_int                     (xp10_decomp_int),
   .crcg0_int                           (crcg0_int),
   .crcc0_int                           (crcc0_int),
   .cg_int                              (cg_int),
   .su_int                              (su_int),
   .osf_int                             (osf_int),
   .isf_int                             (isf_int));
  
  
  
  

   

  cr_isf u_cr_isf
  (
   
   
   .bimc_odat                           (isf_bimc_odat),         
   .bimc_osync                          (isf_bimc_osync),        
   .isf_ib_out                          (isf_ib_out),            
   .rbus_ring_o                         (rbus_ring_o[1]),        
   .isf_ob_out                          (isf_crcc0_ob_out),      
   .isf_stat_events                     (isf_sa_stat_events),    
   .isf_int                             (isf_int),
   .isf_sup_cqe_exit                    (isf_sup_cqe_exit),
   .isf_sup_cqe_rx                      (isf_sup_cqe_rx),
   .isf_sup_rqe_rx                      (isf_sup_rqe_rx),
   
   .clk                                 (clk),
   .rst_n                               (rst_sync_n),            
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .bimc_rst_n                          (top_bimc_mstr_rst_n),   
   .bimc_isync                          (top_bimc_mstr_osync),   
   .bimc_idat                           (top_bimc_mstr_odat),    
   .isf_ib_in                           (isf_ib_in),             
   .rbus_ring_i                         (rbus_ring_i[1]),        
   .cfg_start_addr                      (`CDDIP_ISF_RBUS_START), 
   .cfg_end_addr                        (`CDDIP_ISF_RBUS_END),   
   .isf_ob_in                           (crcc0_isf_ib_out),      
   .dbg_cmd_disable                     (dbg_cmd_disable),
   .xp9_disable                         (xp9_disable),
   .isf_module_id                       (`MODULE_ID_WIDTH'h0),   
   .cceip_cfg                           (1'b0));                  


  
  
  

   

  cr_crcgc u_cr_crcc0
  (
   
   
   .crcgc_ib_out                        (crcc0_isf_ib_out),      
   .rbus_ring_o                         (rbus_ring_o[2]),        
   .crcgc_ob_out                        (crcc0_prefix_attach_ob_out), 
   .crcgc_stat_events                   (crcc0_sa_stat_events[`CRCGC_STATS_WIDTH-1:0]), 
   .crcgc_int                           (crcc0_int),             
   
   .clk                                 (clk),
   .rst_n                               (rst_sync_n),            
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .ext_ib_out                          (1'b1),                  
   .crcgc_ib_in                         (isf_crcc0_ob_out),      
   .rbus_ring_i                         (rbus_ring_i[2]),        
   .cfg_start_addr                      (`CDDIP_CRCC0_RBUS_START), 
   .cfg_end_addr                        (`CDDIP_CRCC0_RBUS_END), 
   .crcgc_ob_in                         (prefix_attach_crcc0_ib_out), 
   .cceip_cfg                           (1'b0),                  
   .crcgc_mode                          (3'h3),                  
   .crcgc_module_id                     (`MODULE_ID_WIDTH'h1));   


  
  
  

   

  cr_prefix_attach #
  (
   .PREFIX_ATTACH_STUB(PREFIX_ATTACH_STUB)
   )
  u_cr_prefix_attach
  (
   
   
   .bimc_odat                           (prefix_attach_bimc_odat), 
   .bimc_osync                          (prefix_attach_bimc_osync), 
   .prefix_attach_ib_out                (prefix_attach_crcc0_ib_out), 
   .rbus_ring_o                         (rbus_ring_o[3]),        
   .prefix_attach_ob_out                (prefix_attach_xp10_decomp_ob_out), 
   .prefix_attach_int                   (prefix_attach_int),
   
   .clk                                 (clk),
   .rst_n                               (rst_sync_n),            
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .bimc_rst_n                          (top_bimc_mstr_rst_n),   
   .bimc_idat                           (isf_bimc_odat),         
   .bimc_isync                          (isf_bimc_osync),        
   .prefix_attach_ib_in                 (crcc0_prefix_attach_ob_out), 
   .rbus_ring_i                         (rbus_ring_i[3]),        
   .cfg_start_addr                      (`CDDIP_PREFIX_ATTACH_RBUS_START), 
   .cfg_end_addr                        (`CDDIP_PREFIX_ATTACH_RBUS_END), 
   .prefix_attach_ob_in                 (xp10_decomp_prefix_attach_ib_out), 
   .cceip_cfg                           (1'b0),                  
   .prefix_attach_module_id             (`MODULE_ID_WIDTH'h2));   


  
  
  

   

  cr_xp10_decomp #
  (
   .XP10_DECOMP_STUB(XP10_DECOMP_STUB),   
   .FPGA_MOD(FPGA_MOD)

   )
  u_cr_xp10_decomp
  (
   
   
   .xp10_decomp_ib_out                  (xp10_decomp_prefix_attach_ib_out), 
   .rbus_ring_o                         (rbus_ring_o[4]),        
   .xp10_decomp_ob_out                  (xp10_decomp_crcg0_ob_out), 
   .xp10_decomp_sch_update              (xp10_decomp_su_sch_update), 
   .im_available_xpd                    (im_available_xpd),
   .im_available_lz77d                  (im_available_lz77d),
   .im_available_htf_bl                 (im_available_htf_bl),
   .xp10_decomp_hufd_stat_events        (xp10_decomp_hufd_sa_stat_events[`HUFD_STATS_WIDTH-1:0]), 
   .xp10_decomp_lz77d_stat_events       (xp10_decomp_lz77d_sa_stat_events[`LZ77D_STATS_WIDTH-1:0]), 
   .xp10_decomp_int                     (xp10_decomp_int),
   
   .clk                                 (clk),
   .rst_n                               (rst_sync_n),            
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .xp10_decomp_ib_in                   (prefix_attach_xp10_decomp_ob_out), 
   .rbus_ring_i                         (rbus_ring_i[4]),        
   .cfg_start_addr                      (`CDDIP_XP10_DECOMP_RBUS_START), 
   .cfg_end_addr                        (`CDDIP_XP10_DECOMP_RBUS_END), 
   .xp10_decomp_ob_in                   (crcg0_xp10_decomp_ib_out), 
   .su_afull_n                          (su_ready),              
   .im_consumed_xpd                     (im_consumed_xpd),
   .im_consumed_lz77d                   (im_consumed_lz77d),
   .im_consumed_htf_bl                  (im_consumed_htf_bl),
   .xp10_decomp_module_id               (`MODULE_ID_WIDTH'h4),   
   .cceip_cfg                           (1'b0));                  



  
  
  
  

   

  cr_crcgc #
  (
   .STUB_MODE(STUB_MODE)
   )
  u_cr_crcg0
  (
   
   
   .crcgc_ib_out                        (crcg0_xp10_decomp_ib_out), 
   .rbus_ring_o                         (rbus_ring_o[5]),        
   .crcgc_ob_out                        (crcg0_ob_out),          
   .crcgc_stat_events                   (crcg0_sa_stat_events[`CRCGC_STATS_WIDTH-1:0]), 
   .crcgc_int                           (crcg0_int),             
   
   .clk                                 (clk),
   .rst_n                               (rst_sync_n),            
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .ext_ib_out                          (1'b1),                  
   .crcgc_ib_in                         (xp10_decomp_crcg0_ob_out), 
   .rbus_ring_i                         (rbus_ring_i[5]),        
   .cfg_start_addr                      (`CDDIP_CRCG0_RBUS_START), 
   .cfg_end_addr                        (`CDDIP_CRCG0_RBUS_END), 
   .crcgc_ob_in                         (crcg0_ob_in),           
   .cceip_cfg                           (1'b0),                  
   .crcgc_mode                          (3'h4),                  
   .crcgc_module_id                     (`MODULE_ID_WIDTH'h6));   

   
  assign crcg0_ob_in.tready = cg_crcg0_ib_out.tready & osf_crcg0_ib_out.tready;

  
  
  

   

  cr_cg #
  (
   .STUB_MODE(STUB_MODE)
   )
  u_cr_cg
  (
   
   
   .cg_ib_out                           (cg_crcg0_ib_out),       
   .rbus_ring_o                         (rbus_ring_o[6]),        
   .cg_ob_out                           (cg_osf_ob_out),         
   .cg_stat_events                      (cg_sa_stat_events),     
   .cg_int                              (cg_int),
   
   .clk                                 (clk),
   .rst_n                               (rst_sync_n),            
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .ext_ib_out                          (osf_crcg0_ib_out),      
   .cg_ib_in                            (crcg0_ob_out),          
   .rbus_ring_i                         (rbus_ring_i[6]),        
   .cfg_start_addr                      (`CDDIP_CG_RBUS_START),  
   .cfg_end_addr                        (`CDDIP_CG_RBUS_END),    
   .cg_ob_in                            (osf_cg_ib_out),         
   .cg_module_id                        (`MODULE_ID_WIDTH'h7),   
   .cceip_cfg                           (1'b0));                  

  
  
  

   

  cr_osf u_cr_osf
  (
   
   
   .bimc_odat                           (osf_bimc_odat),         
   .bimc_osync                          (osf_bimc_osync),        
   .osf_ib_out                          (osf_crcg0_ib_out),      
   .osf_cg_ib_out                       (osf_cg_ib_out),         
   .rbus_ring_o                         (rbus_ring_o[7]),        
   .osf_ob_out                          (osf_ob_out),            
   .osf_stat_events                     (osf_sa_stat_events),    
   .osf_sup_cqe_exit                    (osf_sup_cqe_exit),
   .osf_int                             (osf_int),
   .eng_self_test_en                    (eng_self_test_en),
   
   .clk                                 (clk),
   .rst_n                               (rst_sync_n),            
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .bimc_rst_n                          (top_bimc_mstr_rst_n),   
   .bimc_isync                          (prefix_attach_bimc_osync), 
   .bimc_idat                           (prefix_attach_bimc_odat), 
   .osf_ib_in                           (crcg0_ob_out),          
   .osf_cg_ib_in                        (cg_osf_ob_out),         
   .ext_ib_out                          (cg_crcg0_ib_out),       
   .rbus_ring_i                         (rbus_ring_i[7]),        
   .cfg_start_addr                      (`CDDIP_OSF_RBUS_START), 
   .cfg_end_addr                        (`CDDIP_OSF_RBUS_END),   
   .osf_ob_in                           (osf_ob_in),             
   .sup_osf_halt                        (sup_osf_halt),
   .osf_module_id                       (`MODULE_ID_WIDTH'h8));   

  
  
  

   

  cr_cddip_sa u_cr_cddip_sa
  (
   
   
   .rbus_ring_o                         (rbus_ring_o[8]),        
   
   .clk                                 (clk),
   .rst_n                               (rst_sync_n),            
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .rbus_ring_i                         (rbus_ring_i[8]),        
   .cfg_start_addr                      (`CDDIP_SA_RBUS_START),  
   .cfg_end_addr                        (`CDDIP_SA_RBUS_END),    
   .isf_stat_events                     (isf_sa_stat_events[`ISF_STATS_WIDTH-1:0]), 
   .osf_stat_events                     (osf_sa_stat_events),    
   .xp10_decomp_lz77d_stat_events       (xp10_decomp_lz77d_sa_stat_events[`LZ77D_STATS_WIDTH-1:0]), 
   .xp10_decomp_hufd_stat_events        (xp10_decomp_hufd_sa_stat_events[`HUFD_STATS_WIDTH-1:0]), 
   .crcc0_stat_events                   (crcc0_sa_stat_events[`CRCGC_STATS_WIDTH-1:0]), 
   .crcg0_stat_events                   (crcg0_sa_stat_events[`CRCGC_STATS_WIDTH-1:0]), 
   .cg_stat_events                      (cg_sa_stat_events[`CG_STATS_WIDTH-1:0]), 
   .cddip_sa_module_id                  (`MODULE_ID_WIDTH'h9));   


  
  
  

   

  cr_su u_cr_su
  (
   
   
   .bimc_odat                           (su_bimc_odat),          
   .bimc_osync                          (su_bimc_osync),         
   .rbus_ring_o                         (rbus_ring_o[9]),        
   .su_ready                            (su_ready),
   .su_ob_out                           (sch_update_ob_out),     
   .su_int                              (su_int),
   
   .clk                                 (clk),
   .rst_n                               (rst_sync_n),            
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .bimc_rst_n                          (top_bimc_mstr_rst_n),   
   .bimc_isync                          (osf_bimc_osync),        
   .bimc_idat                           (osf_bimc_odat),         
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .su_in                               (xp10_decomp_su_sch_update), 
   .rbus_ring_i                         (rbus_ring_i[9]),        
   .cfg_start_addr                      (`CDDIP_SU_RBUS_START),  
   .cfg_end_addr                        (`CDDIP_SU_RBUS_END),    
   .su_ob_in                            (sch_update_ob_in));      

  
  assign top_bimc_mstr_idat  = su_bimc_odat;
  assign top_bimc_mstr_isync = su_bimc_osync;

   
endmodule









