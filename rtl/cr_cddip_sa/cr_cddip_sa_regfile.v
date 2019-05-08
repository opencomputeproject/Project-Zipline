/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_cddip_sa.vh"
 
module cr_cddip_sa_regfile 
 
   (
  
  rbus_ring_o, regs_sa_snap, regs_sa_clear_live, regs_sa_ctrl,
  
  clk, rst_n, rbus_ring_i, cfg_start_addr, cfg_end_addr, sa_snapshot,
  sa_count
  );

`include "ccx_std.vh" 
`include "cr_structs.sv"   
   import cr_cddip_saPKG::*;
   import cr_cddip_sa_regfilePKG::*;
   
  
  
  
  input logic          clk;
  input logic          rst_n;
  
  
  
  
  input  rbus_ring_t   rbus_ring_i;
  output rbus_ring_t   rbus_ring_o;
   input [`N_RBUS_ADDR_BITS-1:0] cfg_start_addr;
   input [`N_RBUS_ADDR_BITS-1:0] cfg_end_addr;
   
  
  
  
  output logic         regs_sa_snap;
  output logic         regs_sa_clear_live;
  
  output sa_ctrl_t     regs_sa_ctrl[63:0];
  input  [49:0]        sa_snapshot[63:0];
  input  [49:0]        sa_count[63:0];
  

   
   
   logic                locl_ack;               
   logic                locl_err_ack;           
   logic [31:0]         locl_rd_data;           
   logic                locl_rd_strb;           
   logic                locl_wr_strb;           
   logic                rd_stb;                 
   logic                wr_stb;                 
   
   
   logic [`CR_CDDIP_SA_DECL]       reg_addr;
   logic [`CR_CDDIP_SA_DECL]       locl_addr;
   logic [`N_RBUS_DATA_BITS-1:0]   locl_wr_data;
   spare_t                         spare; 

  sa_global_ctrl_t                sa_global_ctrl;
  
  assign regs_sa_snap = sa_global_ctrl.f.sa_snap;
  assign regs_sa_clear_live = sa_global_ctrl.f.sa_clear_live;
  
   
  sa_ctrl_t                       sa_ctrl_rst_dat[63:0];
  sa_ctrl_t                       sa_ctrl_ia_wdata;
  sa_ctrl_t                       sa_ctrl_ia_rdata; 
  sa_ctrl_ia_config_t             sa_ctrl_ia_config;  
  sa_ctrl_ia_status_t             sa_ctrl_ia_status;  
  sa_ctrl_ia_capability_t         sa_ctrl_ia_capability;  
   
   sa_snapshot_t                   sa_snapshot_ia_wdata;
   sa_snapshot_t                   sa_snapshot_ia_rdata;  
   sa_snapshot_ia_config_t         sa_snapshot_ia_config;  
   sa_snapshot_ia_status_t         sa_snapshot_ia_status;  
   sa_snapshot_ia_capability_t     sa_snapshot_ia_capability;
   assign sa_snapshot_ia_rdata.f.unused = 0;

   
   sa_count_t                   sa_count_ia_wdata;
   sa_count_t                   sa_count_ia_rdata;  
   sa_count_ia_config_t         sa_count_ia_config;  
   sa_count_ia_status_t         sa_count_ia_status;  
   sa_count_ia_capability_t     sa_count_ia_capability; 
   assign sa_count_ia_rdata.f.unused = 0;      
   
   
   

   
   revid_t revid_wire;
     
   CR_TIE_CELL revid_wire_0 (.ob(revid_wire.f.revid[0]), .o());
   CR_TIE_CELL revid_wire_1 (.ob(revid_wire.f.revid[1]), .o());
   CR_TIE_CELL revid_wire_2 (.ob(revid_wire.f.revid[2]), .o());
   CR_TIE_CELL revid_wire_3 (.ob(revid_wire.f.revid[3]), .o());
   CR_TIE_CELL revid_wire_4 (.ob(revid_wire.f.revid[4]), .o());
   CR_TIE_CELL revid_wire_5 (.ob(revid_wire.f.revid[5]), .o());
   CR_TIE_CELL revid_wire_6 (.ob(revid_wire.f.revid[6]), .o());
   CR_TIE_CELL revid_wire_7 (.ob(revid_wire.f.revid[7]), .o());
   
   
   
   genvar              i;
  
  
  
   always_comb begin
      integer ii;

      for (ii=0; ii<64; ii++) begin
        sa_ctrl_rst_dat[ii] = sa_ctrl_t_reset;
      end
   end
   
  

   nx_reg_indirect_access
       #(
         
         .CMND_ADDRESS                  (`CR_CDDIP_SA_SA_CTRL_IA_CONFIG), 
         .STAT_ADDRESS                  (`CR_CDDIP_SA_SA_CTRL_IA_STATUS), 
         .ALIGNMENT                     (2),                     
         .N_DATA_BITS                   (32),                    
         .N_REG_ADDR_BITS               (`CR_CDDIP_SA_WIDTH),    
         .N_ENTRIES                     (64))                    
      SA_CTRL
        (
         
         .stat_code                     (sa_ctrl_ia_status.f.code), 
         .stat_datawords                (sa_ctrl_ia_status.f.datawords), 
         .stat_addr                     (sa_ctrl_ia_status.f.addr), 
         .capability_lst                (sa_ctrl_ia_capability.r.part0[15:0]), 
         .capability_type               (sa_ctrl_ia_capability.f.mem_type), 
         .rd_dat                        (sa_ctrl_ia_rdata),      
         .mem_a                         (regs_sa_ctrl),          
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .addr                          (reg_addr),              
         .cmnd_op                       (sa_ctrl_ia_config.f.op), 
         .cmnd_addr                     (sa_ctrl_ia_config.f.addr), 
         .wr_stb                        (wr_stb),
         .wr_dat                        (sa_ctrl_ia_wdata),      
         .rst_dat                       (sa_ctrl_rst_dat));      

  
  
  
  
   

   nx_roreg_indirect_access
       #(
         
         .CMND_ADDRESS                  (`CR_CDDIP_SA_SA_SNAPSHOT_IA_CONFIG), 
         .STAT_ADDRESS                  (`CR_CDDIP_SA_SA_SNAPSHOT_IA_STATUS), 
         .ALIGNMENT                     (2),                     
         .N_DATA_BITS                   (50),                    
         .N_REG_ADDR_BITS               (`CR_CDDIP_SA_WIDTH),    
         .N_ENTRIES                     (64))                    
      SA_SNAPSHOTR
        (
         
         .stat_code                     (sa_snapshot_ia_status.f.code), 
         .stat_datawords                (sa_snapshot_ia_status.f.datawords), 
         .stat_addr                     (sa_snapshot_ia_status.f.addr), 
         .capability_lst                (sa_snapshot_ia_capability.r.part0[15:0]), 
         .capability_type               (sa_snapshot_ia_capability.f.mem_type), 
         .rd_dat                        ({sa_snapshot_ia_rdata.f.upper,sa_snapshot_ia_rdata.f.lower}), 
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .addr                          (reg_addr),              
         .cmnd_op                       (sa_snapshot_ia_config.f.op), 
         .cmnd_addr                     (sa_snapshot_ia_config.f.addr), 
         .wr_stb                        (wr_stb),
         .wr_dat                        ({sa_snapshot_ia_wdata.f.upper,sa_snapshot_ia_wdata.f.lower}), 
         .mem_a                         (sa_snapshot));          

   
  
  
   

   nx_roreg_indirect_access
       #(
         
         .CMND_ADDRESS                  (`CR_CDDIP_SA_SA_COUNT_IA_CONFIG), 
         .STAT_ADDRESS                  (`CR_CDDIP_SA_SA_COUNT_IA_STATUS), 
         .ALIGNMENT                     (2),                     
         .N_DATA_BITS                   (50),                    
         .N_REG_ADDR_BITS               (`CR_CDDIP_SA_WIDTH),    
         .N_ENTRIES                     (64))                    
      SA_COUNTR
        (
         
         .stat_code                     (sa_count_ia_status.f.code), 
         .stat_datawords                (sa_count_ia_status.f.datawords), 
         .stat_addr                     (sa_count_ia_status.f.addr), 
         .capability_lst                (sa_count_ia_capability.r.part0[15:0]), 
         .capability_type               (sa_count_ia_capability.f.mem_type), 
         .rd_dat                        ({sa_count_ia_rdata.f.upper,sa_count_ia_rdata.f.lower}), 
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .addr                          (reg_addr),              
         .cmnd_op                       (sa_count_ia_config.f.op), 
         .cmnd_addr                     (sa_count_ia_config.f.addr), 
         .wr_stb                        (wr_stb),
         .wr_dat                        ({sa_count_ia_wdata.f.upper,sa_count_ia_wdata.f.lower}), 
         .mem_a                         (sa_count));             
  

   
   
   cr_cddip_sa_regs u_cr_cddip_sa_regs (
                                        
                                        .o_rd_data      (locl_rd_data[31:0]), 
                                        .o_ack          (locl_ack),      
                                        .o_err_ack      (locl_err_ack),  
                                        .o_spare_config (spare),         
                                        .o_sa_global_ctrl(sa_global_ctrl), 
                                        .o_sa_ctrl_ia_wdata_part0(sa_ctrl_ia_wdata.r.part0), 
                                        .o_sa_ctrl_ia_config(sa_ctrl_ia_config), 
                                        .o_sa_snapshot_ia_wdata_part0(sa_snapshot_ia_wdata.r.part0), 
                                        .o_sa_snapshot_ia_wdata_part1(sa_snapshot_ia_wdata.r.part1), 
                                        .o_sa_snapshot_ia_config(sa_snapshot_ia_config), 
                                        .o_sa_count_ia_wdata_part0(sa_count_ia_wdata.r.part0), 
                                        .o_sa_count_ia_wdata_part1(sa_count_ia_wdata.r.part1), 
                                        .o_sa_count_ia_config(sa_count_ia_config), 
                                        .o_reg_written  (wr_stb),        
                                        .o_reg_read     (rd_stb),        
                                        .o_reg_wr_data  (),              
                                        .o_reg_addr     (reg_addr),      
                                        
                                        .clk            (clk),
                                        .i_reset_       (rst_n),         
                                        .i_sw_init      (1'd0),          
                                        .i_addr         (locl_addr),     
                                        .i_wr_strb      (locl_wr_strb),  
                                        .i_wr_data      (locl_wr_data),  
                                        .i_rd_strb      (locl_rd_strb),  
                                        .i_revision_config(revid_wire),  
                                        .i_spare_config (spare),         
                                        .i_sa_global_ctrl(sa_global_ctrl), 
                                        .i_sa_ctrl_ia_capability(sa_ctrl_ia_capability), 
                                        .i_sa_ctrl_ia_status(sa_ctrl_ia_status), 
                                        .i_sa_ctrl_ia_rdata_part0(sa_ctrl_ia_rdata.r.part0), 
                                        .i_sa_snapshot_ia_capability(sa_snapshot_ia_capability), 
                                        .i_sa_snapshot_ia_status(sa_snapshot_ia_status), 
                                        .i_sa_snapshot_ia_rdata_part0(sa_snapshot_ia_rdata.r.part0), 
                                        .i_sa_snapshot_ia_rdata_part1(sa_snapshot_ia_rdata.r.part1), 
                                        .i_sa_count_ia_capability(sa_count_ia_capability), 
                                        .i_sa_count_ia_status(sa_count_ia_status), 
                                        .i_sa_count_ia_rdata_part0(sa_count_ia_rdata.r.part0), 
                                        .i_sa_count_ia_rdata_part1(sa_count_ia_rdata.r.part1)); 

   
   
   
   nx_rbus_ring 
     #(
       .N_RBUS_ADDR_BITS (`N_RBUS_ADDR_BITS),             
       .N_LOCL_ADDR_BITS (`CR_CDDIP_SA_WIDTH),           
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


   
endmodule 










