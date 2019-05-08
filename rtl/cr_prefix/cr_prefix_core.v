/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/




























`include "crPKG.svp"
`include "cr_prefix.vh"

module cr_prefix_core 
  #(parameter PREFIX_STUB=0)
  (
  
  prefix_ib_out, prefix_ob_out, feature_ctr, rec_im_addr, rec_im_cs,
  rec_sat_addr, rec_sat_cs, rec_ct_addr, rec_ct_cs, rec_debug_status,
  rec_psr, tlvp_bimc_odat, tlvp_bimc_osync,
  pt_ib_ro_uncorrectable_ecc_error, usr_ib_ro_uncorrectable_ecc_error,
  tlvp_ob_ro_uncorrectable_ecc_error,
  usr_ob_ro_uncorrectable_ecc_error, prefix_stat_events, tlvp_error,
  
  clk, rst_n, prefix_ib_in, prefix_ob_in, rec_im_dout, rec_im_yield,
  rec_sat_dout, rec_ct_dout, regs_rec_debug_control,
  regs_breakpoint_addr, regs_ld_breakpoint, regs_breakpoint_cont,
  regs_breakpoint_step, prefix_module_id, fe_config,
  tlv_parse_action_1, tlv_parse_action_0, regs_rec_us_ctrl,
  tlvp_bimc_idat, tlvp_bimc_isync, bimc_rst_n
  );
            
  import crPKG::*;    
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;
  
  
  
  

  parameter PT_USE_RAM        = 1;  
  parameter N_PT_ENTRIES      = 512; 
  parameter N_PT_AFULL_VAL    = 3;  
  parameter N_PT_AEMPTY_VAL   = 1;  
  
  parameter N_UF_ENTRIES      = 32; 
  parameter N_UF_AFULL_VAL    = 2;  
  parameter N_UF_AEMPTY_VAL   = 1;  
  
  
  
  localparam N_BP_DATA_BITS = $bits(tlvp_if_bus_t);
  localparam N_BP_ENTRIES      = 32; 
  localparam N_BP_AFULL_VAL    = 2;  
  localparam N_BP_AEMPTY_VAL   = 1;  
  
  localparam N_FE_DATA_BITS = 512;
  localparam N_FE_ENTRIES      = 4; 
  localparam N_FE_AFULL_VAL    = 1;  
  localparam N_FE_AEMPTY_VAL   = 1;  
  
  localparam N_PF_DATA_BITS = 9;
  localparam N_PF_ENTRIES      = 2; 
  localparam N_PF_AFULL_VAL    = 1;  
  localparam N_PF_AEMPTY_VAL   = 1;  
   

  
  
  
  input                                         clk;
  input                                         rst_n; 
        
  
  
  
  input  axi4s_dp_bus_t                        prefix_ib_in;
  output axi4s_dp_rdy_t                        prefix_ib_out;

  
  
  
  input  axi4s_dp_rdy_t                         prefix_ob_in;
  output axi4s_dp_bus_t                         prefix_ob_out;

  
  
  
  output feature_ctr_t                          feature_ctr[0:`N_PREFIX_FEATURES-1];
  
   
  
  
  output logic [`LOG_VEC(`N_PREFIX_IM_ENTRIES)] rec_im_addr;
  output logic                                  rec_im_cs;
  input                                         rec_inst_t rec_im_dout;
  input logic                                   rec_im_yield;
       
  
  
  
  output logic [`LOG_VEC(`N_PREFIX_SAT_ENTRIES)] rec_sat_addr;
  output logic                                  rec_sat_cs;
  input  [895:0]                                rec_sat_dout;

      
  
  
  
  output logic [`LOG_VEC(`N_PREFIX_CT_ENTRIES)] rec_ct_addr;
  output logic                                  rec_ct_cs;
  input  rec_ct_t                               rec_ct_dout;
  
    
  
  
  
  output  prefix_debug_status_t                   rec_debug_status;
  input   prefix_debug_control_t                  regs_rec_debug_control;
  input   prefix_breakpoint_addr_t                regs_breakpoint_addr;
  input                                           regs_ld_breakpoint ;
  input                                           regs_breakpoint_cont ;
  input                                           regs_breakpoint_step;
 
    
  
  
  
  input [`MODULE_ID_WIDTH-1:0]                    prefix_module_id;
     
  
  
  
  output  psr_t                                   rec_psr[0:426] ;
  
  
  
  
  input feature_t                                         fe_config[0:`N_PREFIX_FEATURES-1];
  input [`CR_PREFIX_C_REGS_TLV_PARSE_ACTION_63_32_T_DECL] tlv_parse_action_1;
  input [`CR_PREFIX_C_REGS_TLV_PARSE_ACTION_31_0_T_DECL]  tlv_parse_action_0;
  input  prefix_rec_us_ctrl_t                             regs_rec_us_ctrl;
  
  
  
  
  
  input  logic                    tlvp_bimc_idat;             
  input  logic                    tlvp_bimc_isync;            
  input  logic                    bimc_rst_n;    

  output logic                    tlvp_bimc_odat;            
  output logic                    tlvp_bimc_osync;  
         
  output logic                    pt_ib_ro_uncorrectable_ecc_error;
  output logic                    usr_ib_ro_uncorrectable_ecc_error;
  output logic                    tlvp_ob_ro_uncorrectable_ecc_error;
  output logic                    usr_ob_ro_uncorrectable_ecc_error;
  
  
  
  
  output logic [`PREFIX_STATS_WIDTH-1:0] prefix_stat_events;
  output logic                           tlvp_error;
  
            
 
  tlvp_if_bus_t                   usr_ib_tlv;
  tlvp_if_bus_t                   usr_ob_tlv;
  tlvp_if_bus_t                   ibc_data_tlv; 
  tlvp_if_bus_t                   ibc_bp_tlv;
  tlvp_if_bus_t                   bp_tlv;
  
  logic [511:0]                   fe_ctr_1_ib;
  logic [511:0]                   fe_ctr_2_ib;
  logic [511:0]                   fe_ctr_3_ib;
  logic [511:0]                   fe_ctr_4_ib;
  logic [8:0]                     pf_data;
  
  
  logic                 bp_tlv_aempty;          
  logic                 bp_tlv_afull;           
  logic                 bp_tlv_empty;           
  logic                 bp_tlv_full;            
  logic [(`N_PREFIX_FEATURE_CTR*8)-1:0] fe_ctr_1;
  logic                 fe_ctr_1_ib_aempty;     
  logic                 fe_ctr_1_ib_afull;      
  logic                 fe_ctr_1_ib_empty;      
  logic                 fe_ctr_1_ib_full;       
  logic [(`N_PREFIX_FEATURE_CTR*8)-1:0] fe_ctr_2;
  logic                 fe_ctr_2_ib_aempty;     
  logic                 fe_ctr_2_ib_afull;      
  logic                 fe_ctr_2_ib_empty;      
  logic                 fe_ctr_2_ib_full;       
  logic [(`N_PREFIX_FEATURE_CTR*8)-1:0] fe_ctr_3;
  logic                 fe_ctr_3_ib_aempty;     
  logic                 fe_ctr_3_ib_afull;      
  logic                 fe_ctr_3_ib_empty;      
  logic                 fe_ctr_3_ib_full;       
  logic [(`N_PREFIX_FEATURE_CTR*8)-1:0] fe_ctr_4;
  logic                 fe_ctr_4_ib_aempty;     
  logic                 fe_ctr_4_ib_afull;      
  logic                 fe_ctr_4_ib_empty;      
  logic                 fe_ctr_4_ib_full;       
  logic [1:0]           ibc_blk_sel;            
  logic                 ibc_bp_tlv_valid;       
  logic                 ibc_ctr_1_wr;           
  logic                 ibc_ctr_2_wr;           
  logic                 ibc_ctr_3_wr;           
  logic                 ibc_ctr_4_wr;           
  logic                 ibc_ctr_reload;         
  logic [7:0]           ibc_data_vbytes;        
  logic                 obc_bp_tlv_rd;          
  logic                 obc_pf_ren;             
  logic                 pf_aempty;              
  logic                 pf_afull;               
  logic                 pf_empty;               
  logic                 pf_full;                
  logic                 rec_us_fe_rd;           
  logic [8:0]           rec_us_pf_datain;       
  logic                 rec_us_prefix_valid;    
  logic                 usr_ib_aempty;          
  logic                 usr_ib_empty;           
  logic                 usr_ib_rd;              
  logic                 usr_ob_afull;           
  logic                 usr_ob_full;            
  logic                 usr_ob_wr;              
  
  



  
  generate if (PREFIX_STUB == 1)
  begin : prefix_stub_core

  assign prefix_ib_out.tready = prefix_ob_in.tready;
 
  always_comb
   begin
      prefix_ob_out.tvalid = prefix_ib_in.tvalid;
      prefix_ob_out.tlast  = prefix_ib_in.tlast;
      prefix_ob_out.tid    = prefix_ib_in.tid;
      prefix_ob_out.tstrb  = prefix_ib_in.tstrb;   
      prefix_ob_out.tuser  = prefix_ib_in.tuser;  
      prefix_ob_out.tdata  = prefix_ib_in.tdata;

     rec_im_addr <= 0;
     rec_im_cs <= 1'b0;
     rec_sat_addr <= 0;
     rec_sat_cs <= 1'b0;
     rec_ct_addr <= 0;
     rec_ct_cs  <= 1'b0;
   end

  end
  
  else
   begin: prefix_core


  
  
  
  
  

  cr_tlvp2_top #
    (
     .PT_USE_RAM                        (PT_USE_RAM),
     .N_PT_ENTRIES                      (N_PT_ENTRIES),
     .N_PT_AFULL_VAL                    (N_PT_AFULL_VAL),
     .N_PT_AEMPTY_VAL                   (N_PT_AEMPTY_VAL),
     .N_UF_ENTRIES                      (N_UF_ENTRIES),
     .N_UF_AFULL_VAL                    (N_UF_AFULL_VAL),
     .N_UF_AEMPTY_VAL                   (N_UF_AEMPTY_VAL)) 
    u_cr_tlvp2_top  
    (
     
     .axi4s_ib_out                      (prefix_ib_out),         
     .usr_ib_empty                      (usr_ib_empty),
     .usr_ib_aempty                     (usr_ib_aempty),
     .usr_ib_tlv                        (usr_ib_tlv),
     .usr_ob_full                       (usr_ob_full),
     .usr_ob_afull                      (usr_ob_afull),
     .tlvp_error                        (tlvp_error),
     .axi4s_ob_out                      (prefix_ob_out),         
     .bimc_odat                         (tlvp_bimc_odat),        
     .bimc_osync                        (tlvp_bimc_osync),       
     .pt_ib_ro_uncorrectable_ecc_error  (pt_ib_ro_uncorrectable_ecc_error),
     .usr_ib_ro_uncorrectable_ecc_error (usr_ib_ro_uncorrectable_ecc_error),
     .tlvp_ob_ro_uncorrectable_ecc_error(tlvp_ob_ro_uncorrectable_ecc_error),
     .usr_ob_ro_uncorrectable_ecc_error (usr_ob_ro_uncorrectable_ecc_error),
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .axi4s_ib_in                       (prefix_ib_in),          
     .tlv_parse_action                  ({tlv_parse_action_1,tlv_parse_action_0}), 
     .module_id                         (prefix_module_id),      
     .usr_ib_rd                         (usr_ib_rd),
     .usr_ob_wr                         (usr_ob_wr),
     .usr_ob_tlv                        (usr_ob_tlv),
     .axi4s_ob_in                       (prefix_ob_in),          
     .bimc_idat                         (tlvp_bimc_idat),        
     .bimc_isync                        (tlvp_bimc_isync),       
     .bimc_rst_n                        (bimc_rst_n));
  
  
  
  
  
  

  cr_prefix_ibc 
  u_cr_prefix_ibc  
    (
     
     .usr_ib_rd                         (usr_ib_rd),
     .ibc_bp_tlv                        (ibc_bp_tlv),
     .ibc_bp_tlv_valid                  (ibc_bp_tlv_valid),
     .ibc_data_tlv                      (ibc_data_tlv),
     .ibc_data_vbytes                   (ibc_data_vbytes[7:0]),
     .ibc_blk_sel                       (ibc_blk_sel[1:0]),
     .ibc_ctr_reload                    (ibc_ctr_reload),
     .ibc_ctr_1_wr                      (ibc_ctr_1_wr),
     .ibc_ctr_2_wr                      (ibc_ctr_2_wr),
     .ibc_ctr_3_wr                      (ibc_ctr_3_wr),
     .ibc_ctr_4_wr                      (ibc_ctr_4_wr),
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .usr_ib_empty                      (usr_ib_empty),
     .usr_ib_aempty                     (usr_ib_aempty),
     .usr_ib_tlv                        (usr_ib_tlv),
     .bp_tlv_full                       (bp_tlv_full),
     .bp_tlv_afull                      (bp_tlv_afull),
     .fe_ctr_1_ib_full                  (fe_ctr_1_ib_full),
     .fe_ctr_1_ib_afull                 (fe_ctr_1_ib_afull),
     .fe_ctr_2_ib_full                  (fe_ctr_2_ib_full),
     .fe_ctr_2_ib_afull                 (fe_ctr_2_ib_afull),
     .fe_ctr_3_ib_full                  (fe_ctr_3_ib_full),
     .fe_ctr_3_ib_afull                 (fe_ctr_3_ib_afull),
     .fe_ctr_4_ib_full                  (fe_ctr_4_ib_full),
     .fe_ctr_4_ib_afull                 (fe_ctr_4_ib_afull));
  
  
  
  
  
  

  cr_prefix_obc 
  u_cr_prefix_obc  
    (
     
     .obc_bp_tlv_rd                     (obc_bp_tlv_rd),
     .usr_ob_wr                         (usr_ob_wr),
     .usr_ob_tlv                        (usr_ob_tlv),
     .obc_pf_ren                        (obc_pf_ren),
     .prefix_stat_events                (prefix_stat_events[`PREFIX_STATS_WIDTH-1:0]),
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .bp_tlv_empty                      (bp_tlv_empty),
     .bp_tlv                            (bp_tlv),
     .usr_ob_full                       (usr_ob_full),
     .usr_ob_afull                      (usr_ob_afull),
     .pf_data                           (pf_data[8:0]),
     .pf_empty                          (pf_empty),
     .pf_aempty                         (pf_aempty));
  
  
  
  
  

  cr_prefix_fe 
  u_cr_prefix_fe  
    (
     
     .feature_ctr                       (feature_ctr),
     .fe_ctr_1                          (fe_ctr_1[(`N_PREFIX_FEATURE_CTR*8)-1:0]),
     .fe_ctr_2                          (fe_ctr_2[(`N_PREFIX_FEATURE_CTR*8)-1:0]),
     .fe_ctr_3                          (fe_ctr_3[(`N_PREFIX_FEATURE_CTR*8)-1:0]),
     .fe_ctr_4                          (fe_ctr_4[(`N_PREFIX_FEATURE_CTR*8)-1:0]),
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .fe_config                         (fe_config),
     .ibc_data_tlv_tdata                (ibc_data_tlv.tdata),    
     .ibc_data_vbytes                   (ibc_data_vbytes[7:0]),
     .ibc_blk_sel                       (ibc_blk_sel[1:0]),
     .ibc_ctr_reload                    (ibc_ctr_reload));

  
  
  
  
  
  cr_fifo_wrap1 # 
    (
     
     .N_DATA_BITS          (N_BP_DATA_BITS),
     .N_ENTRIES            (N_BP_ENTRIES),
     .N_AFULL_VAL          (N_BP_AFULL_VAL),
     .N_AEMPTY_VAL         (N_BP_AEMPTY_VAL))
  u_cr_fifo_wrap1_bp                         
    (
     
     .full                              (bp_tlv_full),           
     .afull                             (bp_tlv_afull),          
     .rdata                             (bp_tlv),                
     .empty                             (bp_tlv_empty),          
     .aempty                            (bp_tlv_aempty),         
     
     .clk                               (clk),                   
     .rst_n                             (rst_n),                 
     .wdata                             (ibc_bp_tlv),            
     .wen                               (ibc_bp_tlv_valid),      
     .ren                               (obc_bp_tlv_rd));        
  
  
  
  
  
  
  cr_fifo_wrap1 # 
    (
     
     .N_DATA_BITS          (N_FE_DATA_BITS),
     .N_ENTRIES            (N_FE_ENTRIES),
     .N_AFULL_VAL          (N_FE_AFULL_VAL),
     .N_AEMPTY_VAL         (N_FE_AEMPTY_VAL))
  u_cr_fifo_wrap1_fe_ctr_1k                         
    (
     
     .full                              (fe_ctr_1_ib_full),      
     .afull                             (fe_ctr_1_ib_afull),     
     .rdata                             (fe_ctr_1_ib),           
     .empty                             (fe_ctr_1_ib_empty),     
     .aempty                            (fe_ctr_1_ib_aempty),    
     
     .clk                               (clk),                   
     .rst_n                             (rst_n),                 
     .wdata                             (fe_ctr_1),              
     .wen                               (ibc_ctr_1_wr),          
     .ren                               (rec_us_fe_rd));                 
  
  
  
  
  
  
  cr_fifo_wrap1 # 
    (
     
     .N_DATA_BITS          (N_FE_DATA_BITS),
     .N_ENTRIES            (N_FE_ENTRIES),
     .N_AFULL_VAL          (N_FE_AFULL_VAL),
     .N_AEMPTY_VAL         (N_FE_AEMPTY_VAL))
  u_cr_fifo_wrap1_fe_ctr_2k                         
    (
     
     .full                              (fe_ctr_2_ib_full),      
     .afull                             (fe_ctr_2_ib_afull),     
     .rdata                             (fe_ctr_2_ib),           
     .empty                             (fe_ctr_2_ib_empty),     
     .aempty                            (fe_ctr_2_ib_aempty),    
     
     .clk                               (clk),                   
     .rst_n                             (rst_n),                 
     .wdata                             (fe_ctr_2),              
     .wen                               (ibc_ctr_2_wr),          
     .ren                               (rec_us_fe_rd));                 
  
  
  
  
  
  
  cr_fifo_wrap1 # 
    (
     
     .N_DATA_BITS          (N_FE_DATA_BITS),
     .N_ENTRIES            (N_FE_ENTRIES),
     .N_AFULL_VAL          (N_FE_AFULL_VAL),
     .N_AEMPTY_VAL         (N_FE_AEMPTY_VAL))
  u_cr_fifo_wrap1_fe_ctr_3k                         
    (
     
     .full                              (fe_ctr_3_ib_full),      
     .afull                             (fe_ctr_3_ib_afull),     
     .rdata                             (fe_ctr_3_ib),           
     .empty                             (fe_ctr_3_ib_empty),     
     .aempty                            (fe_ctr_3_ib_aempty),    
     
     .clk                               (clk),                   
     .rst_n                             (rst_n),                 
     .wdata                             (fe_ctr_3),              
     .wen                               (ibc_ctr_3_wr),          
     .ren                               (rec_us_fe_rd));                 
  
  
  
  
  
  
  cr_fifo_wrap1 # 
    (
     
     .N_DATA_BITS          (N_FE_DATA_BITS),
     .N_ENTRIES            (N_FE_ENTRIES),
     .N_AFULL_VAL          (N_FE_AFULL_VAL),
     .N_AEMPTY_VAL         (N_FE_AEMPTY_VAL))
  u_cr_fifo_wrap1_fe_ctr_4k                         
    (
     
     .full                              (fe_ctr_4_ib_full),      
     .afull                             (fe_ctr_4_ib_afull),     
     .rdata                             (fe_ctr_4_ib),           
     .empty                             (fe_ctr_4_ib_empty),     
     .aempty                            (fe_ctr_4_ib_aempty),    
     
     .clk                               (clk),                   
     .rst_n                             (rst_n),                 
     .wdata                             (fe_ctr_4),              
     .wen                               (ibc_ctr_4_wr),          
     .ren                               (rec_us_fe_rd));                 
  
  
  
  
 
  cr_prefix_rec
    u_cr_prefix_rec                         
    (
     
     .rec_psr                           (rec_psr),
     .rec_debug_status                  (rec_debug_status),
     .rec_im_addr                       (rec_im_addr[`LOG_VEC(`N_PREFIX_IM_ENTRIES)]),
     .rec_im_cs                         (rec_im_cs),
     .rec_us_fe_rd                      (rec_us_fe_rd),
     .rec_sat_addr                      (rec_sat_addr[`LOG_VEC(`N_PREFIX_SAT_ENTRIES)]),
     .rec_sat_cs                        (rec_sat_cs),
     .rec_ct_addr                       (rec_ct_addr[`LOG_VEC(`N_PREFIX_CT_ENTRIES)]),
     .rec_ct_cs                         (rec_ct_cs),
     .rec_us_prefix_valid               (rec_us_prefix_valid),
     .rec_us_pf_datain                  (rec_us_pf_datain[8:0]),
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .regs_rec_us_ctrl                  (regs_rec_us_ctrl),
     .regs_rec_debug_control            (regs_rec_debug_control),
     .regs_breakpoint_addr              (regs_breakpoint_addr),
     .regs_ld_breakpoint                (regs_ld_breakpoint),
     .regs_breakpoint_cont              (regs_breakpoint_cont),
     .regs_breakpoint_step              (regs_breakpoint_step),
     .rec_im_dout                       (rec_im_dout),
     .fe_ctr_1_ib                       (fe_ctr_1_ib[511:0]),
     .fe_ctr_2_ib                       (fe_ctr_2_ib[511:0]),
     .fe_ctr_3_ib                       (fe_ctr_3_ib[511:0]),
     .fe_ctr_4_ib                       (fe_ctr_4_ib[511:0]),
     .fe_ctr_1_ib_empty                 (fe_ctr_1_ib_empty),
     .fe_ctr_2_ib_empty                 (fe_ctr_2_ib_empty),
     .fe_ctr_3_ib_empty                 (fe_ctr_3_ib_empty),
     .fe_ctr_4_ib_empty                 (fe_ctr_4_ib_empty),
     .rec_sat_dout                      (rec_sat_dout[895:0]),
     .rec_ct_dout                       (rec_ct_dout),
     .pf_full                           (pf_full),
     .pf_afull                          (pf_afull));
 
  
  
  
  
  
  cr_fifo_wrap1 # 
    (
     
     .N_DATA_BITS          (N_PF_DATA_BITS),
     .N_ENTRIES            (N_PF_ENTRIES),
     .N_AFULL_VAL          (N_PF_AFULL_VAL),
     .N_AEMPTY_VAL         (N_PF_AEMPTY_VAL))
  u_cr_fifo_wrap1_pf                         
    (
     
     .full                              (pf_full),               
     .afull                             (pf_afull),              
     .rdata                             (pf_data),               
     .empty                             (pf_empty),              
     .aempty                            (pf_aempty),             
     
     .clk                               (clk),                   
     .rst_n                             (rst_n),                 
     .wdata                             (rec_us_pf_datain),      
     .wen                               (rec_us_prefix_valid),   
     .ren                               (obc_pf_ren));           
   
end 
endgenerate
      
endmodule 










