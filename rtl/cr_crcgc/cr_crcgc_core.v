/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

















`include "cr_crcgc.vh"

module cr_crcgc_core #
(
 parameter  STUB_MODE=0
 ) 
  (
  
  crcgc_ib_out, crcgc_ob_out, cts_hb, crcgc_stat_events, tlvp_error,
  
  clk, rst_n, ext_ib_out, crcgc_ib_in, crcgc_ob_in, cceip_cfg,
  crcgc_mode, crcgc_module_id, tlv_parse_action_1, tlv_parse_action_0,
  regs_crc_gen_en, regs_crc_chk_en
  );
            
`include "cr_structs.sv"
      
  import cr_crcgcPKG::*;
  import cr_crcgc_regsPKG::*;

  
  
  
  
  parameter N_UF_ENTRIES      = 16; 
  parameter N_UF_AFULL_VAL    = 2;  
  parameter N_UF_AEMPTY_VAL   = 1;  
    
  
  
  

  
  
  
  
  input                                                 clk;
  input                                                 rst_n; 
        
  
  
  
  
  input   axi4s_dp_rdy_t                                ext_ib_out;  
  input   axi4s_dp_bus_t                                crcgc_ib_in;
  output  axi4s_dp_rdy_t                                crcgc_ib_out;

  
  
  
  input  axi4s_dp_rdy_t                                  crcgc_ob_in;
  output axi4s_dp_bus_t                                  crcgc_ob_out;

  
  
  
  input                                                  cceip_cfg;
  input [2:0]                                            crcgc_mode;
  input [`MODULE_ID_WIDTH-1:0]                           crcgc_module_id;
  
  
  
  
  input [`CR_CRCGC_C_REGS_TLV_PARSE_ACTION_63_32_T_DECL] tlv_parse_action_1;
  input [`CR_CRCGC_C_REGS_TLV_PARSE_ACTION_31_0_T_DECL]  tlv_parse_action_0;
  input                                 regs_crc_gen_en;
  input                                 regs_crc_chk_en;
  
  
  
  
  output logic [95:0]                                    cts_hb[7:0];

  
  
  
  output logic [`CRCGC_STATS_WIDTH-1:0]                  crcgc_stat_events;

  
  
  
  output logic                                           tlvp_error;
  
  
  
  

  logic                                                  crcgc_xp10crc64_en;
  logic                                                  crcgc_crc16t_en;
  logic                                                  crcgc_crc64e_en;
  logic                                                  crcgc_xp10crc32_en;
  logic                                                  crcgc_gzipcrc32_en;
  logic                                                  crcgc_adler32_en;

  logic [63:0]                                           xp10crc64;
  logic [31:0]                                           xp10crc32;
  logic [63:0]                                           crc64e;
  logic [31:0]                                           gzipcrc32;
  logic [15:0]                                           crc16t;
  logic [31:0]                                           adler32;
  logic [31:0]                                           nxt_adler32;
  logic                                                  cts_data_valid1;
  
  
  
  

  
  assign crcgc_xp10crc64_en = 1'b1;
  
  assign crcgc_crc16t_en = (~cceip_cfg & (crcgc_mode == 4)) |
                           (cceip_cfg  & (crcgc_mode == 2)) |
                           (cceip_cfg  & (crcgc_mode == 0));
  
  assign crcgc_crc64e_en = (~cceip_cfg & (crcgc_mode == 4)) |
                           (cceip_cfg  & (crcgc_mode == 2)) |
                           (cceip_cfg  & (crcgc_mode == 0)); 

  assign crcgc_xp10crc32_en = cceip_cfg  & (crcgc_mode == 0);
  assign crcgc_gzipcrc32_en = cceip_cfg  & (crcgc_mode == 0);
  assign crcgc_adler32_en   = cceip_cfg  & (crcgc_mode == 0);
  
                           
  tlvp_if_bus_t        usr_ib_tlv;
  tlvp_if_bus_t        usr_ob_tlv;
  axi4s_dp_bus_t       crcgc_ib_in_i;
  
  
  
  logic                 cts_crc64e_cksum_err_se;
  logic                 cts_crc64e_cksum_good_se;
  logic                 cts_crc_init;           
  logic                 cts_crc_sof;            
  logic [63:0]          cts_data;               
  logic                 cts_data_valid;         
  logic [`AXI_S_TSTRB_WIDTH-1:0] cts_data_vbytes;
  logic                 cts_enc_cmp_data_cksum_err_se;
  logic                 cts_enc_cmp_data_cksum_good_se;
  logic                 cts_nvme_raw_cksum_err_se;
  logic                 cts_nvme_raw_cksum_good_se;
  logic                 cts_raw_data_cksum_err_se;
  logic                 cts_raw_data_cksum_good_se;
  logic                 usr_ib_aempty;          
  logic                 usr_ib_empty;           
  logic                 usr_ib_rd;              
  logic                 usr_ob_afull;           
  logic                 usr_ob_full;            
  logic                 usr_ob_wr;              
  
  
  
  
  
   always_comb begin
    crcgc_stat_events[7] = cts_nvme_raw_cksum_err_se;
    crcgc_stat_events[6] = cts_nvme_raw_cksum_good_se;
     
    crcgc_stat_events[5] = cts_enc_cmp_data_cksum_err_se;
    crcgc_stat_events[4] = cts_enc_cmp_data_cksum_good_se;
     
    crcgc_stat_events[3] = cts_crc64e_cksum_err_se;
    crcgc_stat_events[2] = cts_crc64e_cksum_good_se;
     
    crcgc_stat_events[1] = cts_raw_data_cksum_err_se;
    crcgc_stat_events[0] = cts_raw_data_cksum_good_se;
  end
   
  always_comb
    begin
      
      
      crcgc_ib_in_i.tvalid = ext_ib_out.tready & crcgc_ib_in.tvalid ;
      crcgc_ib_in_i.tlast  = crcgc_ib_in.tlast;
      crcgc_ib_in_i.tid    = crcgc_ib_in.tid;
      crcgc_ib_in_i.tstrb  = crcgc_ib_in.tstrb;   
      crcgc_ib_in_i.tuser  = crcgc_ib_in.tuser;  
      crcgc_ib_in_i.tdata  = crcgc_ib_in.tdata;  
    end 

  
  
  
  

  cr_tlvp_top #
    (
     .N_UF_ENTRIES                      (N_UF_ENTRIES),
     .N_UF_AFULL_VAL                    (N_UF_AFULL_VAL),
     .N_UF_AEMPTY_VAL                   (N_UF_AEMPTY_VAL))
      u_cr_tlvp_top  
    (
     
     .axi4s_ib_out                      (crcgc_ib_out),          
     .usr_ib_empty                      (usr_ib_empty),
     .usr_ib_aempty                     (usr_ib_aempty),
     .usr_ib_tlv                        (usr_ib_tlv),
     .usr_ob_full                       (usr_ob_full),
     .usr_ob_afull                      (usr_ob_afull),
     .tlvp_error                        (tlvp_error),
     .axi4s_ob_out                      (crcgc_ob_out),          
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .axi4s_ib_in                       (crcgc_ib_in_i),         
     .tlv_parse_action                  ({tlv_parse_action_1,tlv_parse_action_0}), 
     .module_id                         (crcgc_module_id),       
     .usr_ib_rd                         (usr_ib_rd),
     .usr_ob_wr                         (usr_ob_wr),
     .usr_ob_tlv                        (usr_ob_tlv),
     .axi4s_ob_in                       (crcgc_ob_in));          


  
  
  
  

  cr_crcgc_cts  #
  (
   .STUB_MODE (STUB_MODE)
   )
  u_cr_crcgc_cts  
    (
     
     .usr_ib_rd                         (usr_ib_rd),
     .usr_ob_wr                         (usr_ob_wr),
     .usr_ob_tlv                        (usr_ob_tlv),
     .cts_data_valid                    (cts_data_valid),
     .cts_data                          (cts_data[63:0]),
     .cts_data_vbytes                   (cts_data_vbytes[`AXI_S_TSTRB_WIDTH-1:0]),
     .cts_crc_init                      (cts_crc_init),
     .cts_crc_sof                       (cts_crc_sof),
     .cts_hb                            (cts_hb),
     .cts_raw_data_cksum_good_se        (cts_raw_data_cksum_good_se),
     .cts_crc64e_cksum_good_se          (cts_crc64e_cksum_good_se),
     .cts_enc_cmp_data_cksum_good_se    (cts_enc_cmp_data_cksum_good_se),
     .cts_nvme_raw_cksum_good_se        (cts_nvme_raw_cksum_good_se),
     .cts_raw_data_cksum_err_se         (cts_raw_data_cksum_err_se),
     .cts_crc64e_cksum_err_se           (cts_crc64e_cksum_err_se),
     .cts_enc_cmp_data_cksum_err_se     (cts_enc_cmp_data_cksum_err_se),
     .cts_nvme_raw_cksum_err_se         (cts_nvme_raw_cksum_err_se),
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .cceip_cfg                         (cceip_cfg),
     .crcgc_mode                        (crcgc_mode[2:0]),
     .crcgc_module_id                   (crcgc_module_id[`MODULE_ID_WIDTH-1:0]),
     .regs_crc_gen_en                   (regs_crc_gen_en),
     .regs_crc_chk_en                   (regs_crc_chk_en),
     .usr_ib_tlv                        (usr_ib_tlv),
     .usr_ib_empty                      (usr_ib_empty),
     .usr_ib_aempty                     (usr_ib_aempty),
     .usr_ob_full                       (usr_ob_full),
     .usr_ob_afull                      (usr_ob_afull),
     .xp10crc64                         (xp10crc64[63:0]),
     .xp10crc32                         (xp10crc32[31:0]),
     .crc64e                            (crc64e[63:0]),
     .gzipcrc32                         (gzipcrc32[31:0]),
     .crc16t                            (crc16t[15:0]),
     .adler32                           (adler32[31:0]));


 
  
  
  

  

  cr_crc # 
    (
     
     .POLYNOMIAL                        (64'd`XP10CRC64_POLYNOMIAL), 
     .N_CRC_WIDTH                       (64),                    
     .N_DATA_WIDTH                      (64))                    
    u_xp10crc64  
    (
     
     .crc                               (xp10crc64),             
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .data_in                           (cts_data),              
     .data_valid                        (cts_data_valid),        
     .data_vbytes                       (cts_data_vbytes),       
     .enable                            (1'b1),                  
     .init_value                        (64'd`XP10CRC64_INIT),   
     .init                              (cts_crc_init));                 
  
  
  
  

  

  cr_crc # 
    (
     
     .POLYNOMIAL                        (32'd`XP10CRC32_POLYNOMIAL), 
     .N_CRC_WIDTH                       (32),                    
     .N_DATA_WIDTH                      (64))                    
    u_xp10crc32 
    (
     
     .crc                               (xp10crc32),             
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .data_in                           (cts_data),              
     .data_valid                        (cts_data_valid),        
     .data_vbytes                       (cts_data_vbytes),       
     .enable                            (crcgc_xp10crc32_en),    
     .init_value                        (32'd`XP10CRC32_INIT),   
     .init                              (cts_crc_init));                 
  
  
  
  
  

  

  cr_crc # 
    (
     
     .POLYNOMIAL                        (64'd`CRC64E_POLYNOMIAL), 
     .N_CRC_WIDTH                       (64),                    
     .N_DATA_WIDTH                      (64))                    
    u_crc64e 
    (
     
     .crc                               (crc64e),                
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .data_in                           (cts_data),              
     .data_valid                        (cts_data_valid),        
     .data_vbytes                       (cts_data_vbytes),       
     .enable                            (crcgc_crc64e_en),       
     .init_value                        (64'd`CRC64E_INIT),      
     .init                              (cts_crc_init));                 
  
  
  
  
  

  cr_crc # 
    (
     
     .POLYNOMIAL                        (32'd`GZIPCRC32_POLYNOMIAL), 
     .N_CRC_WIDTH                       (32),                    
     .N_DATA_WIDTH                      (64))                    
    u_gzipcrc32 
    (
     
     .crc                               (gzipcrc32),             
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .data_in                           (cts_data),              
     .data_valid                        (cts_data_valid),        
     .data_vbytes                       (cts_data_vbytes),       
     .enable                            (crcgc_gzipcrc32_en),    
     .init_value                        (32'd`GZIPCRC32_INIT),   
     .init                              (cts_crc_init));                 
  
  
  
  
  

  cr_crc16t
    u_crc16t 
    (
     
     .crc                               (crc16t),                
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .data_in                           (cts_data),              
     .data_valid                        (cts_data_valid),        
     .data_vbytes                       (cts_data_vbytes),       
     .enable                            (crcgc_crc16t_en),       
     .init_value                        (16'd`CRC16T_INIT),      
     .init                              (cts_crc_init));                 
  
  
  
  
  

  cr_adler
    u_adler 
    (
     
     .adler_out                         (nxt_adler32),           
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .data_in                           (cts_data),              
     .bytes_valid                       (cts_data_vbytes),       
     .sof                               (cts_crc_sof));          
 
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      adler32 <= 0;
      cts_data_valid1 <= 1'b0;
    end
    else begin
      cts_data_valid1 <= cts_data_valid;
      if(cts_data_valid1) begin
        adler32 <= nxt_adler32;
      end
    end
  end
  
    
endmodule 









