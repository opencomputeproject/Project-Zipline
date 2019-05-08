/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/









`include "cr_global_params.vh"  

module cr_cceip_64
#(parameter 
  PREFIX_STUB = 0,
  PREFIX_ATTACH_STUB = 0,
  CR_LZ77_COMPRESSOR_STUB = 0,
  LZ77_COMP_SHORT_WINDOW = 0,
  HUF_COMP_STUB = 0,
  XP10_DECOMP_STUB = 0,
  SINGLE_PIPE = 0,
  FPGA_MOD   = 0
  ) 
(
 
  
  ib_tready, ob_tvalid, ob_tlast, ob_tid, ob_tstrb, ob_tuser,
  ob_tdata, sch_update_tvalid, sch_update_tlast, sch_update_tuser,
  sch_update_tdata, apb_prdata, apb_pready, apb_pslverr, cceip_int,
  cceip_idle,
  
  clk, rst_n, scan_en, scan_mode, scan_rst_n, ovstb, lvm, mlvm,
  ib_tvalid, ib_tlast, ib_tid, ib_tstrb, ib_tuser, ib_tdata,
  ob_tready, sch_update_tready, apb_paddr, apb_psel, apb_penable,
  apb_pwrite, apb_pwdata, key_mode, dbg_cmd_disable, xp9_disable
  );

`include "cr_cceip_64_regs.vh"
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

  
  
  
  input                           key_mode;  
  input                           dbg_cmd_disable;
  input                           xp9_disable;
  
  
  
  output                          cceip_int;

  
  
  
  output                          cceip_idle;


  localparam STUB_MODE=1;


  
  
  axi4s_dp_rdy_t        cg_crcc1_ib_out;        
  tlvp_int_t            cg_int;                 
  axi4s_dp_bus_t        cg_osf_ob_out;          
  cg_stats_t            cg_sa_stat_events;      
  axi4s_dp_rdy_t        crcc0_crcg0_ib_out;     
  logic                 crcc0_int;              
  logic [`CRCGC_STATS_WIDTH-1:0] crcc0_sa_stat_events;
  axi4s_dp_bus_t        crcc0_xp10_decomp_ob_out;
  axi4s_dp_bus_t        crcc1_cg_ob_out;        
  logic                 crcc1_int;              
  logic [`CRCGC_STATS_WIDTH-1:0] crcc1_sa_stat_events;
  axi4s_dp_rdy_t        crcc1_xp10_decomp_ib_out;
  axi4s_dp_bus_t        crcg0_df_mux_ob_out;    
  axi4s_dp_rdy_t        crcg0_huf_comp_ib_out;  
  logic                 crcg0_int;              
  logic [`CRCGC_STATS_WIDTH-1:0] crcg0_sa_stat_events;
  logic                 crcgc0_int;             
  axi4s_dp_rdy_t        crcgc0_isf_ib_out;      
  axi4s_dp_bus_t        crcgc0_prefix_ob_out;   
  logic [`CRCGC_STATS_WIDTH-1:0] crcgc0_sa_stat_events;
  axi4s_dp_rdy_t        df_mux_crcc1_ib_out;    
  axi4s_dp_rdy_t        df_mux_crcg0_ib_out;    
  axi4s_dp_bus_t        df_mux_osf_ob_out;      
  logic                 eng_self_test_en;       
  axi4s_dp_bus_t        huf_comp_crcg0_ob_out;  
  generic_int_t         huf_comp_int;           
  axi4s_dp_rdy_t        huf_comp_lz77_comp_ib_out;
  huf_comp_stats_t      huf_comp_sa_stat_events;
  sched_update_if_bus_t huf_comp_su_sch_update; 
  logic [`LZ77D_STATS_WIDTH-1:0] huf_comp_xp10_decomp_lz77d_sa_stat_events;
  im_available_t        im_available_he_lng;    
  im_available_t        im_available_he_sh;     
  im_available_t        im_available_he_st_lng; 
  im_available_t        im_available_he_st_sh;  
  im_available_t        im_available_htf_bl;    
  im_consumed_t         im_consumed_he_lng;     
  im_consumed_t         im_consumed_he_sh;      
  im_consumed_t         im_consumed_he_st_lng;  
  im_consumed_t         im_consumed_he_st_sh;   
  im_consumed_t         im_consumed_htf_bl;     
  im_consumed_t         im_consumed_lz77c;      
  im_consumed_t         im_consumed_lz77d;      
  im_consumed_t         im_consumed_xpc;        
  im_consumed_t         im_consumed_xpd;        
  logic                 isf_bimc_odat;          
  logic                 isf_bimc_osync;         
  axi4s_dp_bus_t        isf_crcgc0_ob_out;      
  axi4s_dp_rdy_t        isf_ib_out;             
  isf_int_t             isf_int;                
  isf_stats_t           isf_sa_stat_events;     
  logic                 isf_sup_cqe_exit;       
  logic                 isf_sup_cqe_rx;         
  logic                 isf_sup_rqe_rx;         
  axi4s_dp_bus_t        lz77_comp_huf_comp_ob_out;
  axi4s_dp_rdy_t        lz77_comp_prefix_attach_ib_out;
  logic [`LZ77C_STATS_WIDTH-1:0] lz77_comp_sa_stat_events;
  logic                 osf_bimc_odat;          
  logic                 osf_bimc_osync;         
  axi4s_dp_rdy_t        osf_cg_ib_out;          
  axi4s_dp_rdy_t        osf_df_mux_ob_in;       
  osf_int_t             osf_int;                
  axi4s_dp_bus_t        osf_ob_out;             
  osf_stats_t           osf_sa_stat_events;     
  logic                 osf_sup_cqe_exit;       
  logic                 prefix_attach_bimc_odat;
  logic                 prefix_attach_bimc_osync;
  logic                 prefix_attach_int;      
  axi4s_dp_bus_t        prefix_attach_lz77_comp_ob_out;
  axi4s_dp_rdy_t        prefix_attach_prefix_ib_out;
  axi4s_dp_rdy_t        prefix_crcgc0_ib_out;   
  axi4s_dp_bus_t        prefix_prefix_attach_ob_out;
  logic [`PREFIX_STATS_WIDTH-1:0] prefix_sa_stat_events;
  logic                 rst_sync_n;             
  axi4s_su_dp_bus_t     sch_update_ob_out;      
  logic                 su_bimc_odat;           
  logic                 su_bimc_osync;          
  ecc_int_t             su_int;                 
  logic                 su_ready;               
  logic                 sup_osf_halt;           
  logic                 top_bimc_mstr_rst_n;    
  axi4s_dp_rdy_t        xp10_decomp_crcc0_ib_out;
  axi4s_dp_bus_t        xp10_decomp_crcc1_ob_out;
  logic [`HUFD_STATS_WIDTH-1:0] xp10_decomp_hufd_sa_stat_events;
  generic_int_t         xp10_decomp_int;        
  logic [`LZ77D_STATS_WIDTH-1:0] xp10_decomp_lz77d_sa_stat_events;
  

  
  
  
  axi4s_dp_bus_t         isf_ib_in; 
  axi4s_dp_rdy_t         osf_ob_in;
  axi4s_dp_rdy_t         sch_update_ob_in;
  axi4s_dp_rdy_t         crcg0_ob_in;
  axi4s_dp_rdy_t         crcc1_ob_in;

  rbus_ring_t            rbus_ring_i[`CR_CCEIP_64_N_BLKS-1:0]; 
  rbus_ring_t            rbus_ring_o[`CR_CCEIP_64_N_BLKS-1:0]; 
  rbus_ring_t            rbus_i;
  rbus_ring_t            rbus_o; 

  im_available_t         im_available_lz77c;   
  im_available_t         im_available_lz77d;   
  im_available_t         im_available_xpd;
  im_available_t         im_available_xpc;

  logic                 top_bimc_mstr_odat;
  logic                 top_bimc_mstr_osync;
  logic                 top_bimc_mstr_idat;
  logic                 top_bimc_mstr_isync;
  logic [2:0]           prefix_int;

  assign isf_ib_in.tvalid        = ib_tvalid & !eng_self_test_en;
  assign isf_ib_in.tlast         = ib_tlast;
  assign isf_ib_in.tid           = ib_tid;
  assign isf_ib_in.tstrb         = ib_tstrb;
  assign isf_ib_in.tuser         = ib_tuser;
  assign isf_ib_in.tdata         = ib_tdata;
  assign ib_tready               = isf_ib_out.tready | eng_self_test_en;

  assign ob_tvalid               = osf_ob_out.tvalid & !eng_self_test_en;
  assign ob_tlast                = osf_ob_out.tlast;
  assign ob_tid                  = osf_ob_out.tid;
  assign ob_tstrb                = osf_ob_out.tstrb;
  assign ob_tuser                = osf_ob_out.tuser;
  assign ob_tdata                = osf_ob_out.tdata;
  assign osf_ob_in.tready        = ob_tready | eng_self_test_en;

  assign sch_update_tvalid       = sch_update_ob_out.tvalid & !eng_self_test_en;
  assign sch_update_tlast        = sch_update_ob_out.tlast;
  assign sch_update_tuser        = sch_update_ob_out.tuser;
  assign sch_update_tdata        = sch_update_ob_out.tdata;
  assign sch_update_ob_in.tready = sch_update_tready | eng_self_test_en;


  logic       lz77_comp_int;
  logic [2:0] prefix_int_pre;
   
  
  always_comb
  for (int j=0; j<`CR_CCEIP_64_N_BLKS; j++) begin
    
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
    
    if (j == `CR_CCEIP_64_N_BLKS-1) begin
      rbus_o.rd_data         = rbus_ring_o[j].rd_data;
      rbus_o.ack             = rbus_ring_o[j].ack;
      rbus_o.rd_strb         = rbus_ring_o[j].rd_strb;
      rbus_o.wr_strb         = rbus_ring_o[j].wr_strb;
      rbus_o.err_ack         = rbus_ring_o[j].err_ack;
    end
  end 

  assign prefix_int[0] = prefix_int_pre[1];
  assign prefix_int[1] = prefix_int_pre[2];
  assign prefix_int[2] = prefix_int_pre[0];
   
  
  
  

   

  cr_rst_sync u_cr_rst_sync_cceip
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

  
  
  

   


  cr_cceip_64_support u_cr_cceip_64_support
  (
   
   
   .top_bimc_mstr_rst_n                 (top_bimc_mstr_rst_n),
   .top_bimc_mstr_osync                 (top_bimc_mstr_osync),
   .top_bimc_mstr_odat                  (top_bimc_mstr_odat),
   .crcg0_ib_out                        (df_mux_crcg0_ib_out),   
   .crcc1_ib_out                        (df_mux_crcc1_ib_out),   
   .rbus_ring_o                         (rbus_ring_o[0]),        
   .df_mux_ob_out                       (df_mux_osf_ob_out),     
   .im_consumed_lz77c                   (im_consumed_lz77c),
   .im_consumed_lz77d                   (im_consumed_lz77d),
   .im_consumed_htf_bl                  (im_consumed_htf_bl),
   .im_consumed_xpc                     (im_consumed_xpc),
   .im_consumed_xpd                     (im_consumed_xpd),
   .im_consumed_he_sh                   (im_consumed_he_sh),
   .im_consumed_he_lng                  (im_consumed_he_lng),
   .im_consumed_he_st_sh                (im_consumed_he_st_sh),
   .im_consumed_he_st_lng               (im_consumed_he_st_lng),
   .cceip_int                           (cceip_int),
   .cceip_idle                          (cceip_idle),
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
   .crcc0_crcg0_ib_out                  (crcc0_crcg0_ib_out),
   .crcg0_ib_in                         (crcg0_df_mux_ob_out),   
   .cg_crcc1_ib_out                     (cg_crcc1_ib_out),
   .crcc1_ib_in                         (crcc1_cg_ob_out),       
   .rbus_ring_i                         (rbus_ring_i[0]),        
   .cfg_start_addr                      (`CCEIP64_SUPPORT_RBUS_START), 
   .cfg_end_addr                        (`CCEIP64_SUPPORT_RBUS_END), 
   .df_mux_ob_in                        (osf_df_mux_ob_in),      
   .im_available_lz77c                  (im_available_lz77c),
   .im_available_lz77d                  (im_available_lz77d),
   .im_available_htf_bl                 (im_available_htf_bl),
   .im_available_xpc                    (im_available_xpc),
   .im_available_xpd                    (im_available_xpd),
   .im_available_he_lng                 (im_available_he_lng),
   .im_available_he_sh                  (im_available_he_sh),
   .im_available_he_st_lng              (im_available_he_st_lng),
   .im_available_he_st_sh               (im_available_he_st_sh),
   .osf_sup_cqe_exit                    (osf_sup_cqe_exit),
   .isf_sup_cqe_exit                    (isf_sup_cqe_exit),
   .isf_sup_cqe_rx                      (isf_sup_cqe_rx),
   .isf_sup_rqe_rx                      (isf_sup_rqe_rx),
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
  
  
  
  

   

  cr_isf u_cr_isf
  (
   
   
   .bimc_odat                           (isf_bimc_odat),         
   .bimc_osync                          (isf_bimc_osync),        
   .isf_ib_out                          (isf_ib_out),            
   .rbus_ring_o                         (rbus_ring_o[1]),        
   .isf_ob_out                          (isf_crcgc0_ob_out),     
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
   .cfg_start_addr                      (`CCEIP64_ISF_RBUS_START), 
   .cfg_end_addr                        (`CCEIP64_ISF_RBUS_END), 
   .isf_ob_in                           (crcgc0_isf_ib_out),     
   .dbg_cmd_disable                     (dbg_cmd_disable),
   .xp9_disable                         (xp9_disable),
   .isf_module_id                       (`MODULE_ID_WIDTH'h0),   
   .cceip_cfg                           (1'b1));                  


  
  
  

   

  cr_crcgc u_cr_crcgc0
  (
   
   
   .crcgc_ib_out                        (crcgc0_isf_ib_out),     
   .rbus_ring_o                         (rbus_ring_o[2]),        
   .crcgc_ob_out                        (crcgc0_prefix_ob_out),  
   .crcgc_stat_events                   (crcgc0_sa_stat_events[`CRCGC_STATS_WIDTH-1:0]), 
   .crcgc_int                           (crcgc0_int),            
   
   .clk                                 (clk),
   .rst_n                               (rst_sync_n),            
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .ext_ib_out                          (1'b1),                  
   .crcgc_ib_in                         (isf_crcgc0_ob_out),     
   .rbus_ring_i                         (rbus_ring_i[2]),        
   .cfg_start_addr                      (`CCEIP64_CRCGC0_RBUS_START), 
   .cfg_end_addr                        (`CCEIP64_CRCGC0_RBUS_END), 
   .crcgc_ob_in                         (prefix_crcgc0_ib_out),  
   .cceip_cfg                           (1'b1),                  
   .crcgc_mode                          (3'h0),                  
   .crcgc_module_id                     (`MODULE_ID_WIDTH'h1));   


  
  
  

   

  cr_prefix #
  (
   .PREFIX_STUB(PREFIX_STUB)
   )
  u_cr_prefix
  (
   
   
   .prefix_ib_out                       (prefix_crcgc0_ib_out),  
   .rbus_ring_o                         (rbus_ring_o[3]),        
   .prefix_ob_out                       (prefix_prefix_attach_ob_out), 
   .prefix_stat_events                  (prefix_sa_stat_events[`PREFIX_STATS_WIDTH-1:0]), 
   .prefix_int                          (prefix_int_pre),        
   
   .clk                                 (clk),
   .rst_n                               (rst_sync_n),            
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .prefix_ib_in                        (crcgc0_prefix_ob_out),  
   .rbus_ring_i                         (rbus_ring_i[3]),        
   .cfg_start_addr                      (`CCEIP64_PREFIX_RBUS_START), 
   .cfg_end_addr                        (`CCEIP64_PREFIX_RBUS_END), 
   .prefix_ob_in                        (prefix_attach_prefix_ib_out), 
   .prefix_module_id                    (`MODULE_ID_WIDTH'h2));   


  
  
  

   

  cr_prefix_attach #
  (
   .PREFIX_ATTACH_STUB(PREFIX_ATTACH_STUB)
   )
  u_cr_prefix_attach
  (
   
   
   .bimc_odat                           (prefix_attach_bimc_odat), 
   .bimc_osync                          (prefix_attach_bimc_osync), 
   .prefix_attach_ib_out                (prefix_attach_prefix_ib_out), 
   .rbus_ring_o                         (rbus_ring_o[4]),        
   .prefix_attach_ob_out                (prefix_attach_lz77_comp_ob_out), 
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
   .prefix_attach_ib_in                 (prefix_prefix_attach_ob_out), 
   .rbus_ring_i                         (rbus_ring_i[4]),        
   .cfg_start_addr                      (`CCEIP64_PREFIX_ATTACH_RBUS_START), 
   .cfg_end_addr                        (`CCEIP64_PREFIX_ATTACH_RBUS_END), 
   .prefix_attach_ob_in                 (lz77_comp_prefix_attach_ib_out), 
   .cceip_cfg                           (1'b1),                  
   .prefix_attach_module_id             (`MODULE_ID_WIDTH'h3));   


  
  
  

   

  cr_lz77_comp
  #(
   .CR_LZ77_COMPRESSOR_STUB(CR_LZ77_COMPRESSOR_STUB),
   .LZ77_COMP_SHORT_WINDOW(LZ77_COMP_SHORT_WINDOW)
   )
  u_cr_lz77_comp
  (
   
   
   .lz77_comp_ib_out                    (lz77_comp_prefix_attach_ib_out), 
   .rbus_ring_o                         (rbus_ring_o[5]),        
   .lz77_comp_ob_out                    (lz77_comp_huf_comp_ob_out), 
   .im_available_lz77c                  (im_available_lz77c),
   .lz77_comp_stat_events               (lz77_comp_sa_stat_events[`LZ77C_STATS_WIDTH-1:0]), 
   .lz77_comp_int                       (lz77_comp_int),
   
   .cfg_start_addr                      (`CCEIP64_LZ77_COMP_RBUS_START), 
   .cfg_end_addr                        (`CCEIP64_LZ77_COMP_RBUS_END), 
   .clk                                 (clk),
   .rst_n                               (rst_sync_n),            
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .lz77_comp_ib_in                     (prefix_attach_lz77_comp_ob_out), 
   .rbus_ring_i                         (rbus_ring_i[5]),        
   .lz77_comp_ob_in                     (huf_comp_lz77_comp_ib_out), 
   .im_consumed_lz77c                   (im_consumed_lz77c),
   .lz77_comp_module_id                 (`MODULE_ID_WIDTH'h4));   


  
  
  

   


  cr_huf_comp #
  (
   .HUF_COMP_STUB(HUF_COMP_STUB),
   .SINGLE_PIPE(SINGLE_PIPE),
   .FPGA_MOD(FPGA_MOD)
   )
  u_cr_huf_comp
  (
   
   
   .huf_comp_ib_out                     (huf_comp_lz77_comp_ib_out), 
   .rbus_ring_o                         (rbus_ring_o[6]),        
   .huf_comp_ob_out                     (huf_comp_crcg0_ob_out), 
   .huf_comp_sch_update                 (huf_comp_su_sch_update), 
   .huf_comp_stat_events                (huf_comp_sa_stat_events), 
   .huf_comp_int                        (huf_comp_int),
   .huf_comp_xp10_decomp_lz77d_stat_events(huf_comp_xp10_decomp_lz77d_sa_stat_events[`LZ77D_STATS_WIDTH-1:0]), 
   .im_available_huf                    (im_available_xpc),      
   .im_available_he_lng                 (im_available_he_lng),
   .im_available_he_sh                  (im_available_he_sh),
   .im_available_he_st_lng              (im_available_he_st_lng),
   .im_available_he_st_sh               (im_available_he_st_sh),
   
   .clk                                 (clk),
   .rst_n                               (rst_sync_n),            
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .huf_comp_ib_in                      (lz77_comp_huf_comp_ob_out), 
   .rbus_ring_i                         (rbus_ring_i[6]),        
   .cfg_start_addr                      (`CCEIP64_HUF_COMP_RBUS_START), 
   .cfg_end_addr                        (`CCEIP64_HUF_COMP_RBUS_END), 
   .huf_comp_ob_in                      (crcg0_huf_comp_ib_out), 
   .huf_comp_in_module_id               (`MODULE_ID_WIDTH'h5),   
   .huf_comp_out_module_id              (`MODULE_ID_WIDTH'h10),  
   .su_ready                            (su_ready),
   .im_consumed_huf                     (im_consumed_xpc),       
   .im_consumed_he_sh                   (im_consumed_he_sh),
   .im_consumed_he_lng                  (im_consumed_he_lng),
   .im_consumed_he_st_sh                (im_consumed_he_st_sh),
   .im_consumed_he_st_lng               (im_consumed_he_st_lng));




   

  cr_crcgc u_cr_crcg0
  (
   
   
   .crcgc_ib_out                        (crcg0_huf_comp_ib_out), 
   .rbus_ring_o                         (rbus_ring_o[7]),        
   .crcgc_ob_out                        (crcg0_df_mux_ob_out),   
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
   .crcgc_ib_in                         (huf_comp_crcg0_ob_out), 
   .rbus_ring_i                         (rbus_ring_i[7]),        
   .cfg_start_addr                      (`CCEIP64_CRCG0_RBUS_START), 
   .cfg_end_addr                        (`CCEIP64_CRCG0_RBUS_END), 
   .crcgc_ob_in                         (crcg0_ob_in),           
   .cceip_cfg                           (1'b1),                  
   .crcgc_mode                          (3'h1),                  
   .crcgc_module_id                     (`MODULE_ID_WIDTH'h7));   


   
   

  assign crcg0_ob_in.tready = crcc0_crcg0_ib_out.tready & df_mux_crcg0_ib_out.tready;

  
  
  
  

   

  cr_crcgc u_cr_crcc0
  (
   
   
   .crcgc_ib_out                        (crcc0_crcg0_ib_out),    
   .rbus_ring_o                         (rbus_ring_o[8]),        
   .crcgc_ob_out                        (crcc0_xp10_decomp_ob_out), 
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
   .ext_ib_out                          (df_mux_crcg0_ib_out),   
   .crcgc_ib_in                         (crcg0_df_mux_ob_out),   
   .rbus_ring_i                         (rbus_ring_i[8]),        
   .cfg_start_addr                      (`CCEIP64_CRCC0_RBUS_START), 
   .cfg_end_addr                        (`CCEIP64_CRCC0_RBUS_END), 
   .crcgc_ob_in                         (xp10_decomp_crcc0_ib_out), 
   .cceip_cfg                           (1'b1),                  
   .crcgc_mode                          (3'h3),                  
   .crcgc_module_id                     (`MODULE_ID_WIDTH'h8));   



  
  
  

   

  cr_xp10_decomp #
  (
   .XP10_DECOMP_STUB(XP10_DECOMP_STUB),
   .FPGA_MOD(FPGA_MOD)
   )
  u_cr_xp10_decomp
  (
   
   
   .xp10_decomp_ib_out                  (xp10_decomp_crcc0_ib_out), 
   .rbus_ring_o                         (rbus_ring_o[9]),        
   .xp10_decomp_ob_out                  (xp10_decomp_crcc1_ob_out), 
   .xp10_decomp_sch_update              (),                      
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
   .xp10_decomp_ib_in                   (crcc0_xp10_decomp_ob_out), 
   .rbus_ring_i                         (rbus_ring_i[9]),        
   .cfg_start_addr                      (`CCEIP64_XP10_DECOMP_RBUS_START), 
   .cfg_end_addr                        (`CCEIP64_XP10_DECOMP_RBUS_END), 
   .xp10_decomp_ob_in                   (crcc1_xp10_decomp_ib_out), 
   .su_afull_n                          (1'b1),                  
   .im_consumed_xpd                     (im_consumed_xpd),
   .im_consumed_lz77d                   (im_consumed_lz77d),
   .im_consumed_htf_bl                  (im_consumed_htf_bl),
   .xp10_decomp_module_id               (`MODULE_ID_WIDTH'ha),   
   .cceip_cfg                           (1'b1));                  


  
  
  

   

  cr_crcgc # 
  (
   .STUB_MODE(STUB_MODE)
   )
  u_cr_crcc1
  (
   
   
   .crcgc_ib_out                        (crcc1_xp10_decomp_ib_out), 
   .rbus_ring_o                         (rbus_ring_o[10]),       
   .crcgc_ob_out                        (crcc1_cg_ob_out),       
   .crcgc_stat_events                   (crcc1_sa_stat_events[`CRCGC_STATS_WIDTH-1:0]), 
   .crcgc_int                           (crcc1_int),             
   
   .clk                                 (clk),
   .rst_n                               (rst_sync_n),            
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .ext_ib_out                          (1'b1),                  
   .crcgc_ib_in                         (xp10_decomp_crcc1_ob_out), 
   .rbus_ring_i                         (rbus_ring_i[10]),       
   .cfg_start_addr                      (`CCEIP64_CRCC1_RBUS_START), 
   .cfg_end_addr                        (`CCEIP64_CRCC1_RBUS_END), 
   .crcgc_ob_in                         (crcc1_ob_in),           
   .cceip_cfg                           (1'b1),                  
   .crcgc_mode                          (3'h2),                  
   .crcgc_module_id                     (`MODULE_ID_WIDTH'hc));   

   
  assign crcc1_ob_in.tready = cg_crcc1_ib_out.tready & df_mux_crcc1_ib_out.tready;

  
  
  

   

  cr_cg #
  (
   .STUB_MODE(STUB_MODE)
   )
  u_cr_cg
  (
   
   
   .cg_ib_out                           (cg_crcc1_ib_out),       
   .rbus_ring_o                         (rbus_ring_o[11]),       
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
   .ext_ib_out                          (df_mux_crcc1_ib_out),   
   .cg_ib_in                            (crcc1_cg_ob_out),       
   .rbus_ring_i                         (rbus_ring_i[11]),       
   .cfg_start_addr                      (`CCEIP64_CG_RBUS_START), 
   .cfg_end_addr                        (`CCEIP64_CG_RBUS_END),  
   .cg_ob_in                            (osf_cg_ib_out),         
   .cg_module_id                        (`MODULE_ID_WIDTH'hd),   
   .cceip_cfg                           (1'b1));                  

  
  
  

   

  cr_osf u_cr_osf
  (
   
   
   .bimc_odat                           (osf_bimc_odat),         
   .bimc_osync                          (osf_bimc_osync),        
   .osf_ib_out                          (osf_df_mux_ob_in),      
   .osf_cg_ib_out                       (osf_cg_ib_out),         
   .rbus_ring_o                         (rbus_ring_o[12]),       
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
   .osf_ib_in                           (df_mux_osf_ob_out),     
   .osf_cg_ib_in                        (cg_osf_ob_out),         
   .ext_ib_out                          (1'b1),                  
   .rbus_ring_i                         (rbus_ring_i[12]),       
   .cfg_start_addr                      (`CCEIP64_OSF_RBUS_START), 
   .cfg_end_addr                        (`CCEIP64_OSF_RBUS_END), 
   .osf_ob_in                           (osf_ob_in),             
   .sup_osf_halt                        (sup_osf_halt),
   .osf_module_id                       (`MODULE_ID_WIDTH'he));   

  
  
  

   

  cr_cceip_64_sa u_cr_cceip_64_sa
  (
   
   
   .rbus_ring_o                         (rbus_ring_o[13]),       
   
   .clk                                 (clk),
   .rst_n                               (rst_sync_n),            
   .scan_en                             (scan_en),
   .scan_mode                           (scan_mode),
   .scan_rst_n                          (scan_rst_n),
   .ovstb                               (ovstb),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .rbus_ring_i                         (rbus_ring_i[13]),       
   .cfg_start_addr                      (`CCEIP64_SA_RBUS_START), 
   .cfg_end_addr                        (`CCEIP64_SA_RBUS_END),  
   .crcc0_stat_events                   (crcc0_sa_stat_events[`CRCGC_STATS_WIDTH-1:0]), 
   .crcc1_stat_events                   (crcc1_sa_stat_events[`CRCGC_STATS_WIDTH-1:0]), 
   .crcg0_stat_events                   (crcg0_sa_stat_events[`CRCGC_STATS_WIDTH-1:0]), 
   .crcgc0_stat_events                  (crcgc0_sa_stat_events[`CRCGC_STATS_WIDTH-1:0]), 
   .cg_stat_events                      (cg_sa_stat_events[`CG_STATS_WIDTH-1:0]), 
   .xp10_decomp_hufd_stat_events        (xp10_decomp_hufd_sa_stat_events[`HUFD_STATS_WIDTH-1:0]), 
   .xp10_decomp_lz77d_stat_events       (xp10_decomp_lz77d_sa_stat_events[`LZ77D_STATS_WIDTH-1:0]), 
   .osf_stat_events                     (osf_sa_stat_events),    
   .huf_comp_stat_events                (huf_comp_sa_stat_events), 
   .lz77_comp_stat_events               (lz77_comp_sa_stat_events[`LZ77C_STATS_WIDTH-1:0]), 
   .prefix_stat_events                  (prefix_sa_stat_events[`PREFIX_STATS_WIDTH-1:0]), 
   .isf_stat_events                     (isf_sa_stat_events[`ISF_STATS_WIDTH-1:0]), 
   .huf_comp_xp10_decomp_lz77d_stat_events(huf_comp_xp10_decomp_lz77d_sa_stat_events[`LZ77D_STATS_WIDTH-1:0]), 
   .cceip_64_sa_module_id               (`MODULE_ID_WIDTH'hf));   


  
  
  

   

  cr_su u_cr_su
  (
   
   
   .bimc_odat                           (su_bimc_odat),          
   .bimc_osync                          (su_bimc_osync),         
   .rbus_ring_o                         (rbus_ring_o[14]),       
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
   .su_in                               (huf_comp_su_sch_update), 
   .rbus_ring_i                         (rbus_ring_i[14]),       
   .cfg_start_addr                      (`CCEIP64_SU_RBUS_START), 
   .cfg_end_addr                        (`CCEIP64_SU_RBUS_END),  
   .su_ob_in                            (sch_update_ob_in));      




  assign top_bimc_mstr_idat  = su_bimc_odat;
  assign top_bimc_mstr_isync = su_bimc_osync;

    
endmodule









