/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/












































module cr_osf_core 
  (
  
  bimc_odat, bimc_osync, osf_ib_out, osf_cg_ib_out, osf_ob_out,
  osf_stat_events, osf_sup_cqe_exit, osf_int, data_fifo_debug_stat,
  osf_data_fifo_ia_rdata, osf_data_fifo_ia_status,
  osf_data_fifo_ia_capability, osf_data_fifo_fifo_status_0,
  osf_data_fifo_fifo_status_1, pdt_fifo_debug_stat,
  osf_pdt_fifo_ia_rdata, osf_pdt_fifo_ia_status,
  osf_pdt_fifo_ia_capability, osf_pdt_fifo_fifo_status_0,
  osf_pdt_fifo_fifo_status_1, ob_bytes_cnt_stb, ob_bytes_cnt_amt,
  ob_frame_cnt_stb,
  
  clk, rst_n, scan_en, scan_mode, scan_rst_n, ovstb, lvm, mlvm,
  bimc_rst_n, bimc_isync, bimc_idat, osf_ib_in, osf_cg_ib_in,
  ext_ib_out, osf_ob_in, sup_osf_halt, osf_data_fifo_ia_wdata,
  osf_data_fifo_ia_config, data_fifo_debug_ctl_config,
  data_fifo_single_step_rd, osf_pdt_fifo_ia_wdata,
  osf_pdt_fifo_ia_config, pdt_fifo_debug_ctl_config,
  pdt_fifo_single_step_rd, debug_ctl_config, osf_tlv_parse_action_0,
  osf_tlv_parse_action_1, reg_addr, wr_stb, osf_module_id
  );
   	    
`include "cr_structs.sv"
      
  import cr_osfPKG::*;
  import cr_osf_regsPKG::*;

  
  
  
  input                                   clk;
  input                                   rst_n; 
	
  
  
  
  input                                   scan_en;
  input                                   scan_mode;
  input                                   scan_rst_n;

  
  
  
  input                                   ovstb;
  input                                   lvm;
  input                                   mlvm;

  
  
  
  input                                   bimc_rst_n;
  input                                   bimc_isync;
  input                                   bimc_idat;
  output                                  bimc_odat;
  output                                  bimc_osync;

  
  
  
  input  axi4s_dp_bus_t                   osf_ib_in;
  output axi4s_dp_rdy_t                   osf_ib_out;

  
  
  
  input  axi4s_dp_bus_t                   osf_cg_ib_in;
  output axi4s_dp_rdy_t                   osf_cg_ib_out;
  
  
  
  
  
  
  input axi4s_dp_rdy_t                    ext_ib_out;  

 
 
 
  input  axi4s_dp_rdy_t                   osf_ob_in;
  output axi4s_dp_bus_t                   osf_ob_out;

  
  
  
  output osf_stats_t                      osf_stat_events;

  
  
  
  output reg                              osf_sup_cqe_exit;
  output osf_int_t                        osf_int;
  input                                   sup_osf_halt;

  
  
  
  output data_fifo_debug_stat_t           data_fifo_debug_stat;
  output osf_data_fifo_t                  osf_data_fifo_ia_rdata;
  output osf_data_fifo_ia_status_t        osf_data_fifo_ia_status;
  output osf_data_fifo_ia_capability_t    osf_data_fifo_ia_capability;
  output osf_data_fifo_fifo_status_0_t    osf_data_fifo_fifo_status_0;
  output osf_data_fifo_fifo_status_1_t    osf_data_fifo_fifo_status_1;
  input  osf_data_fifo_t                  osf_data_fifo_ia_wdata;
  input  osf_data_fifo_ia_config_t        osf_data_fifo_ia_config;
  input  data_fifo_debug_ctl_t            data_fifo_debug_ctl_config;
  input                                   data_fifo_single_step_rd;

  output pdt_fifo_debug_stat_t            pdt_fifo_debug_stat;
  output osf_pdt_fifo_t                   osf_pdt_fifo_ia_rdata;
  output osf_pdt_fifo_ia_status_t         osf_pdt_fifo_ia_status;
  output osf_pdt_fifo_ia_capability_t     osf_pdt_fifo_ia_capability;
  output osf_pdt_fifo_fifo_status_0_t     osf_pdt_fifo_fifo_status_0;
  output osf_pdt_fifo_fifo_status_1_t     osf_pdt_fifo_fifo_status_1;
  input  osf_pdt_fifo_t                   osf_pdt_fifo_ia_wdata;
  input  osf_pdt_fifo_ia_config_t         osf_pdt_fifo_ia_config;
  input  pdt_fifo_debug_ctl_t             pdt_fifo_debug_ctl_config;
  input                                   pdt_fifo_single_step_rd;
  output                                  ob_bytes_cnt_stb;
  output [3:0]                            ob_bytes_cnt_amt;
  output                                  ob_frame_cnt_stb;

  input  debug_ctl_t                      debug_ctl_config;
  input  osf_tlv_parse_action_31_0_t      osf_tlv_parse_action_0;
  input  osf_tlv_parse_action_63_32_t     osf_tlv_parse_action_1;
  input  [`CR_OSF_DECL]                   reg_addr;
  input                                   wr_stb;

  
  
  
  input [`MODULE_ID_WIDTH-1:0]            osf_module_id;

  
  
  wire                  data_fifo_bimc_odat;    
  wire                  data_fifo_bimc_osync;   
  logic [15:0]          data_fifo_capability_lst;
  wire                  ob_data_fifo_aempty;    
  wire                  ob_data_fifo_afull;     
  wire                  ob_data_fifo_empty;     
  wire                  ob_data_fifo_full;      
  wire                  ob_data_fifo_rd;        
  wire [($bits(axi4s_dp_bus_t))-1:0] ob_data_fifo_rdata;
  wire                  ob_data_fifo_wr;        
  axi4s_dp_bus_t        ob_fifo_wdata;          
  wire                  ob_fifo_wr;             
  wire                  ob_pdt_fifo_aempty;     
  wire                  ob_pdt_fifo_afull;      
  wire                  ob_pdt_fifo_empty;      
  wire                  ob_pdt_fifo_full;       
  wire                  ob_pdt_fifo_rd;         
  wire [($bits(axi4s_dp_bus_t))-1:0] ob_pdt_fifo_rdata;
  wire                  ob_pdt_fifo_wr;         
  wire [`LOG_VEC((`OSF_DATA_FIFO_ENTRIES)+1)] osf_dbg_data_fifo_depth;
  wire                  osf_dbg_data_fifo_hw_rd;
  wire                  osf_dbg_data_fifo_hw_wr;
  wire [`LOG_VEC((`OSF_PDT_FIFO_ENTRIES)+1)] osf_dbg_pdt_fifo_depth;
  wire                  osf_dbg_pdt_fifo_hw_rd; 
  wire                  osf_dbg_pdt_fifo_hw_wr; 
  wire                  pdt_axi_slv_aempty;     
  wire                  pdt_axi_slv_empty;      
  wire                  pdt_axi_slv_rd;         
  logic [15:0]          pdt_fifo_capability_lst;
  axi4s_dp_bus_t        tlvp_ob;                
  logic                 tlvp_ob_aempty;         
  logic                 tlvp_ob_empty;          
  wire                  tlvp_ob_rd;             
  logic                 tlvp_term_empty;        
  

  
  logic                               tlvp_term_rd;
  logic                               ob_fifo_empty_mod;
  logic [(`OSF_DATA_FIFO_WIDTH)-1:0]  osf_dbg_data_fifo_wdata;  
  logic [(`OSF_DATA_FIFO_WIDTH)-1:0]  osf_dbg_data_fifo_rdata;     
  logic [(`OSF_DATA_FIFO_WIDTH)-1:0]  osf_data_fifo_sw_wdata;  
  logic [(`OSF_DATA_FIFO_WIDTH)-1:0]  osf_data_fifo_sw_rdata;  


  logic [(`OSF_PDT_FIFO_WIDTH)-1:0]   osf_dbg_pdt_fifo_wdata;
  logic [(`OSF_PDT_FIFO_WIDTH)-1:0]   osf_dbg_pdt_fifo_rdata;    
  logic [(`OSF_PDT_FIFO_WIDTH)-1:0]   osf_pdt_fifo_sw_wdata;
  logic [(`OSF_PDT_FIFO_WIDTH)-1:0]   osf_pdt_fifo_sw_rdata; 

  axi4s_dp_bus_t                      pdt_slv_ob;
  axi4s_dp_bus_t                      osf_ib_in_mod;
  logic                               axi_mstr_rd;
  logic                               tlvp_err;
  logic                               data_fifo_uncor_ecc_error;
  logic                               pdt_fifo_uncor_ecc_error;
  logic                               ob_fifo_full;
  logic                               ob_fifo_afull;
  logic [($bits(axi4s_dp_bus_t))-1:0] ob_fifo_rdata;
  logic [($bits(axi4s_dp_bus_t))-1:0] ob_fifo_rdata_lat;
  logic                               ob_fifo_empty;
  logic                               ob_fifo_aempty;
  axi4s_dp_bus_t                      osf_dbg_data_fifo_rdata_adj;  
  axi4s_dp_bus_t                      osf_dbg_pdt_fifo_rdata_adj;   

  
  
  
  assign osf_int.tlvp_err       = tlvp_err;
  assign osf_int.uncor_ecc_err  = data_fifo_uncor_ecc_error || pdt_fifo_uncor_ecc_error;

  
  
  

  
  
  

  assign tlvp_term_rd = !tlvp_term_empty;

  
  
  
  
  
  
  
  
  always_comb
  begin
    osf_ib_in_mod.tvalid     = ext_ib_out.tready ? osf_ib_in.tvalid : 1'b0; 
    osf_ib_in_mod.tlast      = osf_ib_in.tlast;
    osf_ib_in_mod.tid        = osf_ib_in.tid;
    osf_ib_in_mod.tstrb      = osf_ib_in.tstrb;   
    osf_ib_in_mod.tuser      = osf_ib_in.tuser;  
    osf_ib_in_mod.tdata      = osf_ib_in.tdata;  
  end


  

cr_tlvp_axi_in_top 

#(
  .N_AXIS_ENTRIES          (8),
  .N_AXIS_AFULL_VAL        (3),
  .N_AXIS_AEMPTY_VAL       (1),
  .N_PT_ENTRIES            (8),
  .N_PT_AFULL_VAL          (3),
  .N_PT_AEMPTY_VAL         (1),
  .N_TM_ENTRIES            (8),
  .N_TM_AFULL_VAL          (3),
  .N_TM_AEMPTY_VAL         (1),
  .N_OF_ENTRIES            (16),
  .N_OF_AFULL_VAL          (3),
  .N_OF_AEMPTY_VAL         (1),
  .N_UF_ENTRIES            (0), 
  .N_UF_AFULL_VAL          (0),
  .N_UF_AEMPTY_VAL         (0))
  u_cr_osf_tlvp
  (
   
   
   .axi4s_ib_out                        (osf_ib_out),            
   .term_empty                          (tlvp_term_empty),       
   .term_aempty                         (),                      
   .term_tlv                            (),                      
   .usr_full                            (),                      
   .usr_afull                           (),                      
   .tlvp_ob_empty                       (tlvp_ob_empty),         
   .tlvp_ob_aempty                      (tlvp_ob_aempty),        
   .tlvp_ob                             (tlvp_ob),               
   .bip2_error                          (tlvp_err),              
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .tlv_parse_action                    ({osf_tlv_parse_action_1,osf_tlv_parse_action_0}), 
   .axi4s_ib_in                         (osf_ib_in_mod),         
   .term_rd                             (tlvp_term_rd),          
   .usr_wr                              (1'b0),                  
   .usr_tlv                             ({$bits(tlvp_if_bus_t){1'b0}}), 
   .tlvp_ob_rd                          (tlvp_ob_rd),            
   .module_id                           (osf_module_id));         


  
  assign osf_data_fifo_ia_capability.ack_error      = data_fifo_capability_lst[15];
  assign osf_data_fifo_ia_capability.sim_tmo        = data_fifo_capability_lst[14];
  assign osf_data_fifo_ia_capability.reserved_op    = data_fifo_capability_lst[13:10];
  assign osf_data_fifo_ia_capability.compare        = data_fifo_capability_lst[9];
  assign osf_data_fifo_ia_capability.set_init_start = data_fifo_capability_lst[8];
  assign osf_data_fifo_ia_capability.initialize_inc = data_fifo_capability_lst[7];
  assign osf_data_fifo_ia_capability.initialize     = data_fifo_capability_lst[6];
  assign osf_data_fifo_ia_capability.reset          = data_fifo_capability_lst[5];
  assign osf_data_fifo_ia_capability.disabled       = data_fifo_capability_lst[4];
  assign osf_data_fifo_ia_capability.enable         = data_fifo_capability_lst[3];
  assign osf_data_fifo_ia_capability.write          = data_fifo_capability_lst[2];
  assign osf_data_fifo_ia_capability.read           = data_fifo_capability_lst[1];
  assign osf_data_fifo_ia_capability.nop            = data_fifo_capability_lst[0];

  
  

  assign osf_dbg_data_fifo_wdata = {{(`OSF_DATA_FIFO_WIDTH-($bits(axi4s_dp_bus_t)))+1{1'b0}},  
                                    tlvp_ob.tid, tlvp_ob.tstrb,
                                    tlvp_ob.tuser, tlvp_ob.tlast, tlvp_ob.tdata}; 

  
  assign osf_data_fifo_sw_wdata  = {{(`ISF_FIFO_WIDTH-($bits(axi4s_dp_bus_t)))+1{1'b0}},
                                    osf_data_fifo_ia_wdata.tid, osf_data_fifo_ia_wdata.tstrb,
                                    osf_data_fifo_ia_wdata.tuser, osf_data_fifo_ia_wdata.tlast,
                                    osf_data_fifo_ia_wdata.tdata_hi, osf_data_fifo_ia_wdata.tdata_lo};

  
  
  assign     {osf_dbg_data_fifo_rdata_adj.tid,
              osf_dbg_data_fifo_rdata_adj.tstrb,
              osf_dbg_data_fifo_rdata_adj.tuser,
              osf_dbg_data_fifo_rdata_adj.tlast,
              osf_dbg_data_fifo_rdata_adj.tdata}   = osf_dbg_data_fifo_rdata[$bits(axi4s_dp_bus_t)-2:0];

  assign     osf_dbg_data_fifo_rdata_adj.tvalid = 1'b1;

  
  
  assign    {osf_data_fifo_ia_rdata.tid,
             osf_data_fifo_ia_rdata.tstrb,
             osf_data_fifo_ia_rdata.tuser,
             osf_data_fifo_ia_rdata.tlast,
             osf_data_fifo_ia_rdata.tdata_hi,
             osf_data_fifo_ia_rdata.tdata_lo}  = osf_data_fifo_sw_rdata[$bits(axi4s_dp_bus_t)-2:0];

  assign     osf_data_fifo_ia_rdata.spare      = 3'h0;

  
  
  
   

  nx_fifo_1r1w_indirect_access_debug
  #(
    .CMND_ADDRESS (`CR_OSF_OSF_DATA_FIFO_IA_CONFIG),       
    .STAT_ADDRESS (`CR_OSF_OSF_DATA_FIFO_IA_STATUS),       
    .FSTAT_ADDRESS (`CR_OSF_OSF_DATA_FIFO_FIFO_STATUS_0),  
    .ALIGNMENT (2),                                        
    .N_TIMER_BITS (6),                                     
    .N_REG_ADDR_BITS (`CR_OSF_WIDTH),                      
    .N_DATA_BITS (`OSF_DATA_FIFO_WIDTH),                   
    .N_ENTRIES (`OSF_DATA_FIFO_ENTRIES),                   
    .N_INIT_INC_BITS (0),                                  
    .SPECIALIZE (1),                                       
    .OUT_FLOP (1))                                         
  u_osf_dbg_data_fifo
  (
   
   
   .rd_data                             (osf_dbg_data_fifo_rdata[(`OSF_DATA_FIFO_WIDTH)-1:0]), 
   .xxx_fifo_empty                      (),                      
   .full                                (),                      
   .fifo_depth                          (osf_dbg_data_fifo_depth[`LOG_VEC((`OSF_DATA_FIFO_ENTRIES)+1)]), 
   .bimc_odat                           (data_fifo_bimc_odat),   
   .bimc_osync                          (data_fifo_bimc_osync),  
   .ro_uncorrectable_ecc_error          (data_fifo_uncor_ecc_error), 
   .stat_code                           (osf_data_fifo_ia_status.code), 
   .stat_datawords                      (osf_data_fifo_ia_status.datawords), 
   .stat_addr                           (osf_data_fifo_ia_status.addr), 
   .capability_lst                      (data_fifo_capability_lst[15:0]), 
   .capability_type                     (osf_data_fifo_ia_capability.mem_type), 
   .rd_dat                              (osf_data_fifo_sw_rdata), 
   .fifo_status_0                       (osf_data_fifo_fifo_status_0), 
   .fifo_status_1                       (osf_data_fifo_fifo_status_1), 
   
   .wr_data                             (osf_dbg_data_fifo_wdata[(`OSF_DATA_FIFO_WIDTH)-1:0]), 
   .wr                                  (osf_dbg_data_fifo_hw_wr), 
   .rd                                  (osf_dbg_data_fifo_hw_rd), 
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .bimc_idat                           (bimc_idat),
   .bimc_rst_n                          (bimc_rst_n),
   .bimc_isync                          (bimc_isync),
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .mrdten                              (1'd0),                  
   .reg_addr                            (reg_addr[`BIT_VEC((`CR_OSF_WIDTH))]),
   .cmnd_op                             (osf_data_fifo_ia_config.op), 
   .cmnd_addr                           (osf_data_fifo_ia_config.addr), 
   .wr_stb                              (wr_stb),
   .wr_dat                              (osf_data_fifo_sw_wdata), 
   .load_dbg_values                     (data_fifo_debug_ctl_config.load_dbg_values), 
   .dbg_wr_pointer                      (data_fifo_debug_ctl_config.dbg_wr_pointer[`LOG_VEC((`OSF_DATA_FIFO_ENTRIES))]), 
   .dbg_fifo_depth                      (data_fifo_debug_ctl_config.dbg_fifo_depth[`LOG_VEC((`OSF_DATA_FIFO_ENTRIES)+1)]), 
   .force_sw_access                     (data_fifo_debug_ctl_config.force_sw_access)); 


  
  
  

  
  assign osf_pdt_fifo_ia_capability.ack_error      = pdt_fifo_capability_lst[15];
  assign osf_pdt_fifo_ia_capability.sim_tmo        = pdt_fifo_capability_lst[14];
  assign osf_pdt_fifo_ia_capability.reserved_op    = pdt_fifo_capability_lst[13:10];
  assign osf_pdt_fifo_ia_capability.compare        = pdt_fifo_capability_lst[9];
  assign osf_pdt_fifo_ia_capability.set_init_start = pdt_fifo_capability_lst[8];
  assign osf_pdt_fifo_ia_capability.initialize_inc = pdt_fifo_capability_lst[7];
  assign osf_pdt_fifo_ia_capability.initialize     = pdt_fifo_capability_lst[6];
  assign osf_pdt_fifo_ia_capability.reset          = pdt_fifo_capability_lst[5];
  assign osf_pdt_fifo_ia_capability.disabled       = pdt_fifo_capability_lst[4];
  assign osf_pdt_fifo_ia_capability.enable         = pdt_fifo_capability_lst[3];
  assign osf_pdt_fifo_ia_capability.write          = pdt_fifo_capability_lst[2];
  assign osf_pdt_fifo_ia_capability.read           = pdt_fifo_capability_lst[1];
  assign osf_pdt_fifo_ia_capability.nop            = pdt_fifo_capability_lst[0];

  

  
  
  


  assign data_fifo_debug_stat.data_pipe_fifo_full = ob_data_fifo_afull;

  cr_fifo_wrap1 
  #(
    .N_DATA_BITS ($bits(axi4s_dp_bus_t)),   
    .N_ENTRIES (16),                        
    .N_AFULL_VAL (3),                       
    .N_AEMPTY_VAL (1))                      
  u_osf_data_fifo
  (
   
   
   .full                                (ob_data_fifo_full),     
   .afull                               (ob_data_fifo_afull),    
   .rdata                               (ob_data_fifo_rdata[($bits(axi4s_dp_bus_t))-1:0]), 
   .empty                               (ob_data_fifo_empty),    
   .aempty                              (ob_data_fifo_aempty),   
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .wdata                               (osf_dbg_data_fifo_rdata_adj[($bits(axi4s_dp_bus_t))-1:0]), 
   .wen                                 (ob_data_fifo_wr),       
   .ren                                 (ob_data_fifo_rd));       

  
  
  
  
  


  cr_axi4s_slv
  #(
    .N_ENTRIES (16),
    .N_AFULL_VAL (3),
    .N_AEMPTY_VAL (1)
    )
  u_pdt_fifo_axi4s_slv
  (
   
   
   .axi4s_ib_out                        (osf_cg_ib_out),         
   .axi4s_slv_out                       (pdt_slv_ob),            
   .axi4s_slv_empty                     (pdt_axi_slv_empty),     
   .axi4s_slv_aempty                    (pdt_axi_slv_aempty),    
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .axi4s_ib_in                         (osf_cg_ib_in),          
   .axi4s_slv_rd                        (pdt_axi_slv_rd));        


  
  
  

  
  

  assign osf_dbg_pdt_fifo_wdata = {{(`OSF_PDT_FIFO_WIDTH-($bits(axi4s_dp_bus_t)))+1{1'b0}}, 
                                   pdt_slv_ob.tid, pdt_slv_ob.tstrb,
                                   pdt_slv_ob.tuser, pdt_slv_ob.tlast, pdt_slv_ob.tdata}; 


  
  assign osf_pdt_fifo_sw_wdata  = {{(`ISF_FIFO_WIDTH-($bits(axi4s_dp_bus_t)))+1{1'b0}},
                                    osf_pdt_fifo_ia_wdata.tid, osf_pdt_fifo_ia_wdata.tstrb,
                                    osf_pdt_fifo_ia_wdata.tuser, osf_pdt_fifo_ia_wdata.tlast,
                                    osf_pdt_fifo_ia_wdata.tdata_hi, osf_pdt_fifo_ia_wdata.tdata_lo};

  
  
    assign   {osf_dbg_pdt_fifo_rdata_adj.tid,
              osf_dbg_pdt_fifo_rdata_adj.tstrb,
              osf_dbg_pdt_fifo_rdata_adj.tuser,
              osf_dbg_pdt_fifo_rdata_adj.tlast,
              osf_dbg_pdt_fifo_rdata_adj.tdata}  = osf_dbg_pdt_fifo_rdata[$bits(axi4s_dp_bus_t)-2:0];

  assign     osf_dbg_pdt_fifo_rdata_adj.tvalid = 1'b1;

  
  
  assign    {osf_pdt_fifo_ia_rdata.tid,
             osf_pdt_fifo_ia_rdata.tstrb,
             osf_pdt_fifo_ia_rdata.tuser,
             osf_pdt_fifo_ia_rdata.tlast,
             osf_pdt_fifo_ia_rdata.tdata_hi,
             osf_pdt_fifo_ia_rdata.tdata_lo}  = osf_pdt_fifo_sw_rdata[$bits(axi4s_dp_bus_t)-2:0];

  assign     osf_pdt_fifo_ia_rdata.spare      = 3'h0;

   

  nx_fifo_1r1w_indirect_access_debug
  #(
    .CMND_ADDRESS (`CR_OSF_OSF_PDT_FIFO_IA_CONFIG),       
    .STAT_ADDRESS (`CR_OSF_OSF_PDT_FIFO_IA_STATUS),       
    .FSTAT_ADDRESS (`CR_OSF_OSF_PDT_FIFO_FIFO_STATUS_0),  
    .ALIGNMENT (2),                                       
    .N_TIMER_BITS (6),                                    
    .N_REG_ADDR_BITS (`CR_OSF_WIDTH),                     
    .N_DATA_BITS (`OSF_PDT_FIFO_WIDTH),                   
    .N_ENTRIES (`OSF_PDT_FIFO_ENTRIES),                   
    .N_INIT_INC_BITS (0),                                 
    .SPECIALIZE (1),                                      
    .OUT_FLOP (1))                                        
  u_osf_dbg_pdt_fifo
  (

   
   .rd_data                             (osf_dbg_pdt_fifo_rdata[(`OSF_PDT_FIFO_WIDTH)-1:0]), 
   .xxx_fifo_empty                      (),                      
   .full                                (),                      
   .fifo_depth                          (osf_dbg_pdt_fifo_depth[`LOG_VEC((`OSF_PDT_FIFO_ENTRIES)+1)]), 
   .bimc_odat                           (bimc_odat),             
   .bimc_osync                          (bimc_osync),            
   .ro_uncorrectable_ecc_error          (pdt_fifo_uncor_ecc_error), 
   .stat_code                           (osf_pdt_fifo_ia_status.code), 
   .stat_datawords                      (osf_pdt_fifo_ia_status.datawords), 
   .stat_addr                           (osf_pdt_fifo_ia_status.addr), 
   .capability_lst                      (pdt_fifo_capability_lst[15:0]), 
   .capability_type                     (osf_pdt_fifo_ia_capability.mem_type), 
   .rd_dat                              (osf_pdt_fifo_sw_rdata), 
   .fifo_status_0                       (osf_pdt_fifo_fifo_status_0), 
   .fifo_status_1                       (osf_pdt_fifo_fifo_status_1), 
   
   .wr_data                             (osf_dbg_pdt_fifo_wdata[(`OSF_PDT_FIFO_WIDTH)-1:0]), 
   .wr                                  (osf_dbg_pdt_fifo_hw_wr), 
   .rd                                  (osf_dbg_pdt_fifo_hw_rd), 
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .bimc_idat                           (data_fifo_bimc_odat),   
   .bimc_rst_n                          (bimc_rst_n),
   .bimc_isync                          (data_fifo_bimc_osync),  
   .lvm                                 (lvm),
   .mlvm                                (mlvm),
   .mrdten                              (1'd0),                  
   .reg_addr                            (reg_addr[`BIT_VEC((`CR_OSF_WIDTH))]),
   .cmnd_op                             (osf_pdt_fifo_ia_config.op), 
   .cmnd_addr                           (osf_pdt_fifo_ia_config.addr), 
   .wr_stb                              (wr_stb),
   .wr_dat                              (osf_pdt_fifo_sw_wdata), 
   .load_dbg_values                     (pdt_fifo_debug_ctl_config.load_dbg_values), 
   .dbg_wr_pointer                      (pdt_fifo_debug_ctl_config.dbg_wr_pointer[`LOG_VEC((`OSF_PDT_FIFO_ENTRIES))]), 
   .dbg_fifo_depth                      (pdt_fifo_debug_ctl_config.dbg_fifo_depth[`LOG_VEC((`OSF_PDT_FIFO_ENTRIES)+1)]), 
   .force_sw_access                     (pdt_fifo_debug_ctl_config.force_sw_access)); 


  
  
  



  assign pdt_fifo_debug_stat.pdt_pipe_fifo_full = ob_pdt_fifo_afull;

  cr_fifo_wrap1 
  #(
    .N_DATA_BITS ($bits(axi4s_dp_bus_t)),    
    .N_ENTRIES (16),                     
    .N_AFULL_VAL (3),                    
    .N_AEMPTY_VAL (1))                   
  u_osf_pdt_fifo
  (
   
   
   .full                                (ob_pdt_fifo_full),      
   .afull                               (ob_pdt_fifo_afull),     
   .rdata                               (ob_pdt_fifo_rdata[($bits(axi4s_dp_bus_t))-1:0]), 
   .empty                               (ob_pdt_fifo_empty),     
   .aempty                              (ob_pdt_fifo_aempty),    
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .wdata                               (osf_dbg_pdt_fifo_rdata_adj[($bits(axi4s_dp_bus_t))-1:0]), 
   .wen                                 (ob_pdt_fifo_wr),        
   .ren                                 (ob_pdt_fifo_rd));        


  
  
  
  

  cr_osf_dbg2fifo_ctl u_cr_osf_dbg2fifo_ctl
  (
   
   .tlvp_ob_rd                          (tlvp_ob_rd),
   .pdt_axi_slv_rd                      (pdt_axi_slv_rd),
   .osf_dbg_data_fifo_hw_rd             (osf_dbg_data_fifo_hw_rd),
   .osf_dbg_data_fifo_hw_wr             (osf_dbg_data_fifo_hw_wr),
   .osf_dbg_pdt_fifo_hw_rd              (osf_dbg_pdt_fifo_hw_rd),
   .osf_dbg_pdt_fifo_hw_wr              (osf_dbg_pdt_fifo_hw_wr),
   .ob_data_fifo_wr                     (ob_data_fifo_wr),
   .ob_pdt_fifo_wr                      (ob_pdt_fifo_wr),
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .data_fifo_debug_ctl_config          (data_fifo_debug_ctl_config),
   .pdt_fifo_debug_ctl_config           (pdt_fifo_debug_ctl_config),
   .data_fifo_single_step_rd            (data_fifo_single_step_rd),
   .pdt_fifo_single_step_rd             (pdt_fifo_single_step_rd),
   .tlvp_ob_aempty                      (tlvp_ob_aempty),
   .tlvp_ob_empty                       (tlvp_ob_empty),
   .pdt_axi_slv_aempty                  (pdt_axi_slv_aempty),
   .pdt_axi_slv_empty                   (pdt_axi_slv_empty),
   .osf_dbg_data_fifo_depth             (osf_dbg_data_fifo_depth[`LOG_VEC(`OSF_DATA_FIFO_ENTRIES+1)]),
   .osf_dbg_data_fifo_rdata_adj         (osf_dbg_data_fifo_rdata_adj),
   .osf_dbg_pdt_fifo_depth              (osf_dbg_pdt_fifo_depth[`LOG_VEC(`OSF_PDT_FIFO_ENTRIES+1)]),
   .ob_data_fifo_afull                  (ob_data_fifo_afull),
   .ob_pdt_fifo_afull                   (ob_pdt_fifo_afull));


  
  
  
  


  cr_osf_ctl u_cr_osf_ctl
  (
   
   .ob_data_fifo_rd                     (ob_data_fifo_rd),
   .ob_pdt_fifo_rd                      (ob_pdt_fifo_rd),
   .ob_fifo_wr                          (ob_fifo_wr),
   .ob_fifo_wdata                       (ob_fifo_wdata),
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .ob_data_fifo_rdata                  (ob_data_fifo_rdata),
   .ob_data_fifo_empty                  (ob_data_fifo_empty),
   .ob_pdt_fifo_rdata                   (ob_pdt_fifo_rdata),
   .ob_pdt_fifo_empty                   (ob_pdt_fifo_empty),
   .ob_fifo_full                        (ob_fifo_full),
   .debug_ctl_config                    (debug_ctl_config));


  
  
  




  cr_fifo_wrap1 
  #(
    .N_DATA_BITS ($bits(axi4s_dp_bus_t)),    

    .N_ENTRIES (16),                     
    .N_AFULL_VAL (3),                    
    .N_AEMPTY_VAL (1))                   
  u_osf_ob_fifo
  (
   
   
   .full                                (ob_fifo_full),          
   .afull                               (ob_fifo_afull),         
   .rdata                               (ob_fifo_rdata[($bits(axi4s_dp_bus_t))-1:0]), 
   .empty                               (ob_fifo_empty),         
   .aempty                              (ob_fifo_aempty),        
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .wdata                               (ob_fifo_wdata[($bits(axi4s_dp_bus_t))-1:0]), 
   .wen                                 (ob_fifo_wr),            
   .ren                                 (axi_mstr_rd));           


  
  
  

   

  cr_osf_latency u_cr_osf_latency
  (
   
   
   .axi4s_out                           (ob_fifo_rdata_lat),     
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .axi4s_in                            (ob_fifo_rdata),         
   .axi4s_mstr_rd                       (axi_mstr_rd));           


  
  
  

  
  
  
  
  
  
  assign ob_fifo_empty_mod  = debug_ctl_config.force_ob_bp || sup_osf_halt || ob_fifo_empty;
  
  

  cr_axi4s_mstr u_osf_axi4s_mstr
  (
   
   
   .axi4s_mstr_rd                       (axi_mstr_rd),           
   .axi4s_ob_out                        (osf_ob_out),            
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .axi4s_in                            (ob_fifo_rdata_lat),     
   .axi4s_in_empty                      (ob_fifo_empty_mod),     
   .axi4s_in_aempty                     (ob_fifo_aempty),        
   .axi4s_ob_in                         (osf_ob_in));             

  
  
  
  
  
  cr_osf_support u_cr_osf_support
  (
   
   
   .osf_stat_events                     (osf_stat_events),
   .osf_sup_cqe_exit                    (osf_sup_cqe_exit),
   .ob_bytes_cnt_stb                    (ob_bytes_cnt_stb),
   .ob_bytes_cnt_amt                    (ob_bytes_cnt_amt[3:0]),
   .ob_frame_cnt_stb                    (ob_frame_cnt_stb),
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .osf_ib_in                           (osf_ib_in_mod),         
   .osf_ib_out                          (osf_ib_out),
   .osf_cg_ib_in                        (osf_cg_ib_in),
   .osf_cg_ib_out                       (osf_cg_ib_out),
   .ob_out                              (ob_fifo_rdata_lat),     
   .ob_fifo_empty                       (ob_fifo_empty_mod),     
   .axi_mstr_rd                         (axi_mstr_rd),
   .debug_ctl_config                    (debug_ctl_config));

   
endmodule 









