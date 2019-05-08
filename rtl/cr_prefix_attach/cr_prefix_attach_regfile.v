/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







module cr_prefix_attach_regfile 
 
   (
  
  rbus_ring_o, cceip_tlv_parse_action_0, cceip_tlv_parse_action_1,
  cddip_tlv_parse_action_0, cddip_tlv_parse_action_1, pfd_mem_dout,
  pfd_mem_yield, phd_mem_dout, phd_mem_yield, bimc_odat, bimc_osync,
  
  rst_n, clk, rbus_ring_i, cfg_start_addr, cfg_end_addr, pfd_mem_addr,
  pfd_mem_cs, phd_mem_addr, phd_mem_cs, bimc_rst_n, bimc_idat,
  bimc_isync
  );

`include "cr_structs.sv"   
   import cr_prefix_attachPKG::*;
   import cr_prefix_attach_regfilePKG::*;

    
   input logic                         rst_n;
   input logic                         clk;
   input                               rbus_ring_t rbus_ring_i;
   input [`N_RBUS_ADDR_BITS-1:0]       cfg_start_addr;
   input [`N_RBUS_ADDR_BITS-1:0]       cfg_end_addr;
  
   
   output                              rbus_ring_t rbus_ring_o;

    
  
  
  
   output [`CR_PREFIX_ATTACH_C_REGS_CCEIP_TLV_PARSE_ACTION_31_0_T_DECL]  cceip_tlv_parse_action_0;
   output [`CR_PREFIX_ATTACH_C_REGS_CCEIP_TLV_PARSE_ACTION_63_32_T_DECL] cceip_tlv_parse_action_1;
   output [`CR_PREFIX_ATTACH_C_REGS_CDDIP_TLV_PARSE_ACTION_31_0_T_DECL]  cddip_tlv_parse_action_0;
   output [`CR_PREFIX_ATTACH_C_REGS_CDDIP_TLV_PARSE_ACTION_63_32_T_DECL] cddip_tlv_parse_action_1;
        
  
  
  
  input  [`LOG_VEC(`CR_PREFIX_PFD_ENTRIES)] pfd_mem_addr;
  input  logic                              pfd_mem_cs;
  output pfd_t                              pfd_mem_dout;
  output logic                              pfd_mem_yield;
  
  
  
  
  input  [`LOG_VEC(`CR_PREFIX_PHD_ENTRIES)] phd_mem_addr;
  input  logic                              phd_mem_cs;
  output phd_t                              phd_mem_dout;
  output logic                              phd_mem_yield;
    
  
  
  
  input                                     bimc_rst_n;        
  input                                     bimc_idat;       
  input                                     bimc_isync;      
    
  output logic                              bimc_odat;       
  output logic                              bimc_osync;

typedef enum
               {I_PFDMEM,
                I_PHDMEM,
                N_BIMC_SLAVES} slave_e;
  
 
   logic [`CR_PREFIX_ATTACH_DECL]  reg_addr; 
   logic [`CR_PREFIX_ATTACH_DECL]  locl_addr;
   logic [`N_RBUS_DATA_BITS-1:0]   locl_wr_data; 
   spare_t                         spare;
  
  logic                            pfdmem_bimc_idat;
  logic                            pfdmem_bimc_isync;
  logic                            pfdmem_bimc_odat;
  logic                            pfdmem_bimc_osync;
  logic                            phdmem_bimc_idat;
  logic                            phdmem_bimc_isync;
  logic                            phdmem_bimc_odat;
  logic                            phdmem_bimc_osync;
    logic                                                           regs_enable_ftr_error ;
  
   
   pfd_t                  pfdmem_ia_wdata;
   pfd_t                  pfdmem_ia_rdata;  
   pfdmem_ia_config_t     pfdmem_ia_config;  
   pfdmem_ia_status_t     pfdmem_ia_status;  
   pfdmem_ia_capability_t pfdmem_ia_capability;
  
  
  
   
   phd_t                  phdmem_ia_wdata;
   phd_t                  phdmem_ia_rdata;  
   phdmem_ia_config_t     phdmem_ia_config;  
   phdmem_ia_status_t     phdmem_ia_status;  
   phdmem_ia_capability_t phdmem_ia_capability;
  
   prefix_attach_error_control_t regs_error_control;
  
  pfd_t                              pfd_mem_dout_pre;
  phd_t                              phd_mem_dout_pre;
  
   
   
   logic                locl_ack;               
   logic                locl_err_ack;           
   logic [31:0]         locl_rd_data;           
   logic                locl_rd_strb;           
   logic                locl_wr_strb;           
   logic                rd_stb;                 
   logic                wr_stb;                 
   
   
   
   
   
   

   
   revid_t revid_wire;
     
   CR_TIE_CELL revid_wire_0 (.ob(revid_wire.f.revid[0]), .o());
   CR_TIE_CELL revid_wire_1 (.ob(revid_wire.f.revid[1]), .o());
   CR_TIE_CELL revid_wire_2 (.ob(revid_wire.f.revid[2]), .o());
   CR_TIE_CELL revid_wire_3 (.ob(revid_wire.f.revid[3]), .o());
   CR_TIE_CELL revid_wire_4 (.ob(revid_wire.f.revid[4]), .o());
   CR_TIE_CELL revid_wire_5 (.ob(revid_wire.f.revid[5]), .o());
   CR_TIE_CELL revid_wire_6 (.ob(revid_wire.f.revid[6]), .o());
   CR_TIE_CELL revid_wire_7 (.ob(revid_wire.f.revid[7]), .o());
   

  always_comb begin   

    pfdmem_bimc_idat  =  bimc_idat;
    pfdmem_bimc_isync =  bimc_isync;

    phdmem_bimc_idat  = pfdmem_bimc_odat;
    phdmem_bimc_isync = pfdmem_bimc_osync;

    bimc_odat         = phdmem_bimc_odat;
    bimc_osync        = phdmem_bimc_osync;
    regs_enable_ftr_error = regs_error_control.f.enable_ftr_error;
    
   end 

   always_ff @(posedge clk) begin
      pfd_mem_dout <= pfd_mem_dout_pre;
      phd_mem_dout <= phd_mem_dout_pre;
   end


  
  
  
  
  
   nx_ram_1rw_indirect_access  
    #(
      
      .CMND_ADDRESS                     (`CR_PREFIX_ATTACH_PFDMEM_IA_CONFIG), 
      .STAT_ADDRESS                     (`CR_PREFIX_ATTACH_PFDMEM_IA_STATUS), 
      .ALIGNMENT                        (2),                     
      .N_TIMER_BITS                     (6),                     
      .N_REG_ADDR_BITS                  (`CR_PREFIX_ATTACH_WIDTH), 
      .N_DATA_BITS                      ($bits(phd_t)),          
      .N_ENTRIES                        (`CR_PREFIX_PFD_ENTRIES), 
      .N_INIT_INC_BITS                  (0),                     
      .SPECIALIZE                       (1),                     
      .IN_FLOP                          (1),                     
      .OUT_FLOP                         (0),                     
      .RD_LATENCY                       (1),                     
      .RESET_DATA                       (pfd_t_reset))           
  PFDMEM                         
    (
     
     .stat_code                         (pfdmem_ia_status.f.code), 
     .stat_datawords                    (pfdmem_ia_status.f.datawords), 
     .stat_addr                         (pfdmem_ia_status.f.addr), 
     .capability_lst                    (pfdmem_ia_capability.r.part0[15:0]), 
     .capability_type                   ({pfdmem_ia_capability.f.mem_type}), 
     .rd_dat                            (pfdmem_ia_rdata),       
     .bimc_odat                         (pfdmem_bimc_odat),      
     .bimc_osync                        (pfdmem_bimc_osync),     
     .ro_uncorrectable_ecc_error        (),                      
     .hw_dout                           (pfd_mem_dout_pre),          
     .hw_yield                          (pfd_mem_yield),         
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .reg_addr                          (reg_addr),              
     .cmnd_op                           (pfdmem_ia_config.f.op), 
     .cmnd_addr                         (pfdmem_ia_config.f.addr), 
     .wr_stb                            (wr_stb),                
     .wr_dat                            (pfdmem_ia_wdata),       
     .ovstb                             (1'b1),                  
     .lvm                               (1'b0),                  
     .mlvm                              (1'b0),                  
     .mrdten                            (1'b0),                  
     .bimc_rst_n                        (bimc_rst_n),            
     .bimc_isync                        (pfdmem_bimc_isync),     
     .bimc_idat                         (pfdmem_bimc_idat),      
     .hw_add                            (pfd_mem_addr),          
     .hw_we                             (1'b0),                  
     .hw_bwe                            ({$bits(pfd_t){1'b1}}),  
     .hw_cs                             (pfd_mem_cs),            
     .hw_din                            ({$bits(pfd_t){1'b0}}));         
 
  
  
  
  
  
   nx_ram_1rw_indirect_access  
    #(
      
      .CMND_ADDRESS                     (`CR_PREFIX_ATTACH_PHDMEM_IA_CONFIG), 
      .STAT_ADDRESS                     (`CR_PREFIX_ATTACH_PHDMEM_IA_STATUS), 
      .ALIGNMENT                        (2),                     
      .N_TIMER_BITS                     (6),                     
      .N_REG_ADDR_BITS                  (`CR_PREFIX_ATTACH_WIDTH), 
      .N_DATA_BITS                      ($bits(phd_t)),          
      .N_ENTRIES                        (`CR_PREFIX_PHD_ENTRIES), 
      .N_INIT_INC_BITS                  (0),                     
      .SPECIALIZE                       (1),                     
      .IN_FLOP                          (1),                     
      .OUT_FLOP                         (0),                     
      .RD_LATENCY                       (1),                     
      .RESET_DATA                       (phd_t_reset))           
  PHDMEM                         
    (
     
     .stat_code                         (phdmem_ia_status.f.code), 
     .stat_datawords                    (phdmem_ia_status.f.datawords), 
     .stat_addr                         (phdmem_ia_status.f.addr), 
     .capability_lst                    (phdmem_ia_capability.r.part0[15:0]), 
     .capability_type                   ({phdmem_ia_capability.f.mem_type}), 
     .rd_dat                            (phdmem_ia_rdata),       
     .bimc_odat                         (phdmem_bimc_odat),      
     .bimc_osync                        (phdmem_bimc_osync),     
     .ro_uncorrectable_ecc_error        (),                      
     .hw_dout                           (phd_mem_dout_pre),          
     .hw_yield                          (phd_mem_yield),         
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .reg_addr                          (reg_addr),              
     .cmnd_op                           (phdmem_ia_config.f.op), 
     .cmnd_addr                         (phdmem_ia_config.f.addr), 
     .wr_stb                            (wr_stb),                
     .wr_dat                            (phdmem_ia_wdata),       
     .ovstb                             (1'b1),                  
     .lvm                               (1'b0),                  
     .mlvm                              (1'b0),                  
     .mrdten                            (1'b0),                  
     .bimc_rst_n                        (bimc_rst_n),            
     .bimc_isync                        (phdmem_bimc_isync),     
     .bimc_idat                         (phdmem_bimc_idat),      
     .hw_add                            (phd_mem_addr),          
     .hw_we                             (1'b0),                  
     .hw_bwe                            ({$bits(phd_t){1'b1}}),  
     .hw_cs                             (phd_mem_cs),            
     .hw_din                            ({$bits(phd_t){1'b0}}));         


  
   
   
   cr_prefix_attach_regs u_cr_prefix_attach_regs 
     (
      
      .o_rd_data                        (locl_rd_data[31:0]),    
      .o_ack                            (locl_ack),              
      .o_err_ack                        (locl_err_ack),          
      .o_spare_config                   (spare),                 
      .o_regs_cceip_tlv_parse_action_0  (cceip_tlv_parse_action_0), 
      .o_regs_cceip_tlv_parse_action_1  (cceip_tlv_parse_action_1), 
      .o_pfdmem_ia_wdata_part0          (pfdmem_ia_wdata.r.part0), 
      .o_pfdmem_ia_wdata_part1          (pfdmem_ia_wdata.r.part1), 
      .o_pfdmem_ia_config               (pfdmem_ia_config),      
      .o_phdmem_ia_wdata_part0          (phdmem_ia_wdata.r.part0), 
      .o_phdmem_ia_wdata_part1          (phdmem_ia_wdata.r.part1), 
      .o_phdmem_ia_config               (phdmem_ia_config),      
      .o_regs_error_control             (regs_error_control),    
      .o_regs_cddip_tlv_parse_action_0  (cddip_tlv_parse_action_0), 
      .o_regs_cddip_tlv_parse_action_1  (cddip_tlv_parse_action_1), 
      .o_reg_written                    (wr_stb),                
      .o_reg_read                       (rd_stb),                
      .o_reg_wr_data                    (),                      
      .o_reg_addr                       (reg_addr),              
      
      .clk                              (clk),
      .i_reset_                         (rst_n),                 
      .i_sw_init                        (1'd0),                  
      .i_addr                           (locl_addr),             
      .i_wr_strb                        (locl_wr_strb),          
      .i_wr_data                        (locl_wr_data),          
      .i_rd_strb                        (locl_rd_strb),          
      .i_revision_config                (revid_wire),            
      .i_spare_config                   (spare),                 
      .i_pfdmem_ia_capability           (pfdmem_ia_capability),  
      .i_pfdmem_ia_status               (pfdmem_ia_status),      
      .i_pfdmem_ia_rdata_part0          (pfdmem_ia_rdata.r.part0), 
      .i_pfdmem_ia_rdata_part1          (pfdmem_ia_rdata.r.part1), 
      .i_phdmem_ia_capability           (phdmem_ia_capability),  
      .i_phdmem_ia_status               (phdmem_ia_status),      
      .i_phdmem_ia_rdata_part0          (phdmem_ia_rdata.r.part0), 
      .i_phdmem_ia_rdata_part1          (phdmem_ia_rdata.r.part1), 
      .i_regs_error_control             (regs_error_control));   

   
   
   
   nx_rbus_ring 
     #(
       .N_RBUS_ADDR_BITS (`N_RBUS_ADDR_BITS),             
       .N_LOCL_ADDR_BITS (`CR_PREFIX_ATTACH_WIDTH),           
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










