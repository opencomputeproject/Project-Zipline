/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "crPKG.svp"
`include "cr_cddip_sa.vh"

module cr_cddip_sa_core
  (
  
  sa_snapshot, sa_count,
  
  clk, rst_n, scan_en, scan_mode, scan_rst_n, isf_stat_events,
  osf_stat_events, xp10_decomp_lz77d_stat_events,
  xp10_decomp_hufd_stat_events, crcc0_stat_events, crcg0_stat_events,
  cg_stat_events, cddip_sa_module_id, regs_sa_snap,
  regs_sa_clear_live, regs_sa_ctrl
  );

`include "cr_structs.sv"

  import crPKG::*;   
  import cr_cddip_saPKG::*;
  import cr_cddip_sa_regsPKG::*;
  
  
  
  input         clk;
  input         rst_n; 

  
  
  
  input         scan_en;
  input         scan_mode;
  input         scan_rst_n;

  
  
  
  input [`ISF_STATS_WIDTH-1:0]            isf_stat_events;
  input osf_stats_t                       osf_stat_events;

  input [`LZ77D_STATS_WIDTH-1:0]          xp10_decomp_lz77d_stat_events;
  input [`HUFD_STATS_WIDTH-1:0]           xp10_decomp_hufd_stat_events;
  input [`CRCGC_STATS_WIDTH-1:0]          crcc0_stat_events;
  input [`CRCGC_STATS_WIDTH-1:0]          crcg0_stat_events;
  input [`CG_STATS_WIDTH-1:0]             cg_stat_events;

  
  
  
  input [`MODULE_ID_WIDTH-1:0]            cddip_sa_module_id;

  
  
  
  input logic                     regs_sa_snap;
  input logic                     regs_sa_clear_live;
  input  sa_ctrl_t                regs_sa_ctrl[63:0];
  output logic [49:0]             sa_snapshot[63:0];
  output logic [49:0]             sa_count[63:0];

  
  
  
  logic [63:0]                    big_stat_events_vec[15:0];
  logic [63:0]                    sa_events[15:0];

  integer       k;
  
  logic                           sa_snap;
  logic                           sa_clear;
  logic                           regs_sa_snap_r;
  logic                           regs_sa_clear_live_r;
    
  
  

  always_comb begin

    big_stat_events_vec[15][63:0] = 64'd0;                                  
    big_stat_events_vec[14][63:0] = isf_stat_events;                        
    big_stat_events_vec[13][63:0] = 64'd0;                                  
    big_stat_events_vec[12][63:0] = 64'd0;                                  
    big_stat_events_vec[11][63:0] = 64'd0;                                  
    big_stat_events_vec[10][63:0] = 64'd0;                                  
    big_stat_events_vec[9][63:0]  = 64'd0;                                  
    big_stat_events_vec[8][63:0]  = osf_stat_events;                        
    big_stat_events_vec[7][63:0]  = 64'h0;                                  
    big_stat_events_vec[6][63:0]  = xp10_decomp_lz77d_stat_events;          
    big_stat_events_vec[5][63:0]  = xp10_decomp_hufd_stat_events;           
    big_stat_events_vec[4][63:0]  = 64'd0;                                  
    big_stat_events_vec[3][63:0]  = 64'd0;                                  
    big_stat_events_vec[2][63:0]  = 64'd0;                                  
    big_stat_events_vec[1][63:0]  = {28'd0,cg_stat_events,crcc0_stat_events,16'd0,crcg0_stat_events};
    big_stat_events_vec[0][63:0]  = 64'h0;                                  
    
  end 
  
  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      for(k=0;k<16;k=k+1) begin
        sa_events[k] <= 64'd0;
      end
    end
    else begin
      sa_events <= big_stat_events_vec;
    end
  end
  
  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      sa_snap <= 1'b0;
      sa_clear <= 1'b0;
      
      regs_sa_snap_r <= 1'b0;
      regs_sa_clear_live_r <= 1'b0;
    end
    else begin
      regs_sa_snap_r <= regs_sa_snap;
      regs_sa_clear_live_r <= regs_sa_clear_live;


      sa_snap <= regs_sa_snap & ~regs_sa_snap_r;
      sa_clear <= regs_sa_clear_live & ~regs_sa_clear_live_r;      
    end
  end  
  
  
  
  
  

  genvar                  i;
  generate 
    for(i=0;i<64;i=i+1) begin:sa_counters
      cr_sa_counter u_cr_sa_counter_i 
          (
           
           .sa_count                    (sa_count[i]),           
           .sa_snapshot                 (sa_snapshot[i]),        
           
           .clk                         (clk),
           .rst_n                       (rst_n),
           .sa_event_sel                (regs_sa_ctrl[i].sa_event_sel), 
           .sa_events                   (sa_events),             
           .sa_clear                    (sa_clear),              
           .sa_snap                     (sa_snap));               
      
    end 
  endgenerate  


endmodule











