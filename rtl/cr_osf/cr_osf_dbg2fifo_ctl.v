/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/






















module cr_osf_dbg2fifo_ctl
(
  
  tlvp_ob_rd, pdt_axi_slv_rd, osf_dbg_data_fifo_hw_rd,
  osf_dbg_data_fifo_hw_wr, osf_dbg_pdt_fifo_hw_rd,
  osf_dbg_pdt_fifo_hw_wr, ob_data_fifo_wr, ob_pdt_fifo_wr,
  
  clk, rst_n, data_fifo_debug_ctl_config, pdt_fifo_debug_ctl_config,
  data_fifo_single_step_rd, pdt_fifo_single_step_rd, tlvp_ob_aempty,
  tlvp_ob_empty, pdt_axi_slv_aempty, pdt_axi_slv_empty,
  osf_dbg_data_fifo_depth, osf_dbg_data_fifo_rdata_adj,
  osf_dbg_pdt_fifo_depth, ob_data_fifo_afull, ob_pdt_fifo_afull
  );
  
`include "cr_structs.sv"
  
  import cr_osfPKG::*;
  import cr_osf_regsPKG::*;

  
  
  
  input                                        clk;
  input                                        rst_n; 
  
  
  
  
  input  data_fifo_debug_ctl_t                 data_fifo_debug_ctl_config;  
  input  pdt_fifo_debug_ctl_t                  pdt_fifo_debug_ctl_config;  
  input                                        data_fifo_single_step_rd;
  input                                        pdt_fifo_single_step_rd;

  
  
  
  input                                        tlvp_ob_aempty;
  input                                        tlvp_ob_empty;
  output                                       tlvp_ob_rd; 

  
  
  
  
  input                                        pdt_axi_slv_aempty;
  input                                        pdt_axi_slv_empty;
  output                                       pdt_axi_slv_rd; 

  
  
  
  input  [`LOG_VEC(`OSF_DATA_FIFO_ENTRIES+1)]  osf_dbg_data_fifo_depth;
  input  axi4s_dp_bus_t                        osf_dbg_data_fifo_rdata_adj; 
  output reg                                   osf_dbg_data_fifo_hw_rd;
  output reg                                   osf_dbg_data_fifo_hw_wr;

  
  
  
  input [`LOG_VEC(`OSF_PDT_FIFO_ENTRIES+1)]    osf_dbg_pdt_fifo_depth;
  output reg                                   osf_dbg_pdt_fifo_hw_rd;
  output reg                                   osf_dbg_pdt_fifo_hw_wr;

  
  
  
  input                                        ob_data_fifo_afull;
  output reg                                   ob_data_fifo_wr;

  
  
  
  input                                        ob_pdt_fifo_afull;
  output reg                                   ob_pdt_fifo_wr;

  
  
  
  logic                                        df_dbg_empty_mod;
  logic                                        osf_dbg_data_fifo_aempty;
  logic                                        osf_dbg_data_fifo_empty;
  logic                                        osf_dbg_data_fifo_full;

  logic                                        pf_dbg_empty_mod;
  logic                                        osf_dbg_pdt_fifo_aempty; 
  logic                                        osf_dbg_pdt_fifo_empty;
  logic                                        osf_dbg_pdt_fifo_full;

  logic                                        df_dbg_rd;
  logic                                        pf_dbg_rd;

  logic                                        ob_data_fifo_wr_nxt;
  logic                                        ob_pdt_fifo_wr_nxt;


  
  
  

  
  
  
  assign osf_dbg_data_fifo_aempty  = osf_dbg_data_fifo_depth <= 1;

  
  assign osf_dbg_data_fifo_empty   = osf_dbg_data_fifo_depth == 0;

  
  assign osf_dbg_data_fifo_full    = osf_dbg_data_fifo_depth >= `OSF_DATA_FIFO_ENTRIES-2;

  assign tlvp_ob_rd                = osf_dbg_data_fifo_hw_wr;

  assign osf_dbg_pdt_fifo_aempty   = osf_dbg_pdt_fifo_depth <= 1;

  
  assign osf_dbg_pdt_fifo_empty    = osf_dbg_pdt_fifo_depth == 0;
  
  
  assign osf_dbg_pdt_fifo_full     = osf_dbg_pdt_fifo_depth >= `OSF_PDT_FIFO_ENTRIES-2;

  assign pdt_axi_slv_rd            = osf_dbg_pdt_fifo_hw_wr;

  
  assign df_dbg_rd                 = !df_dbg_empty_mod && !ob_data_fifo_afull; 
  assign pf_dbg_rd                 = !pf_dbg_empty_mod && !ob_pdt_fifo_afull;

  
  
  
  
  
  
  assign ob_data_fifo_wr_nxt       = osf_dbg_data_fifo_hw_rd && !ob_data_fifo_afull; 
  assign ob_pdt_fifo_wr_nxt        = osf_dbg_pdt_fifo_hw_rd  && !ob_pdt_fifo_afull;


  
  
  

  

  cr_osf_debug_ctl u_osf_data_fifo_debug_ctl
  (
  
   
   .fifo_hw_rd                          (osf_dbg_data_fifo_hw_rd), 
   .fifo_hw_wr                          (osf_dbg_data_fifo_hw_wr), 
   .fifo_empty_mod                      (df_dbg_empty_mod),      
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .fifo_debug_mode                     (data_fifo_debug_ctl_config.debug_mode), 
   .single_step_rd                      (data_fifo_single_step_rd), 
   .fifo_empty                          (osf_dbg_data_fifo_empty), 
   .fifo_full                           (osf_dbg_data_fifo_full), 
   .ob_rd_ok                            (df_dbg_rd),             
   .src_empty                           (tlvp_ob_empty));         


  
  
  

  

  cr_osf_debug_ctl u_osf_pdt_fifo_debug_ctl
  (
  
   
   .fifo_hw_rd                          (osf_dbg_pdt_fifo_hw_rd), 
   .fifo_hw_wr                          (osf_dbg_pdt_fifo_hw_wr), 
   .fifo_empty_mod                      (pf_dbg_empty_mod),      
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .fifo_debug_mode                     (pdt_fifo_debug_ctl_config.debug_mode), 
   .single_step_rd                      (pdt_fifo_single_step_rd), 
   .fifo_empty                          (osf_dbg_pdt_fifo_empty), 
   .fifo_full                           (osf_dbg_pdt_fifo_full), 
   .ob_rd_ok                            (pf_dbg_rd),             
   .src_empty                           (pdt_axi_slv_empty));     



  
  
  
  always_ff @(posedge clk or negedge rst_n)
  begin
    if (~rst_n) 
    begin
      
      
      ob_data_fifo_wr <= 0;
      ob_pdt_fifo_wr <= 0;
      
    end
    else
    begin
      ob_data_fifo_wr              <= ob_data_fifo_wr_nxt;
      ob_pdt_fifo_wr               <= ob_pdt_fifo_wr_nxt;
    end
  end


endmodule 










