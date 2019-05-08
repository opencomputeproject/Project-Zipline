/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


































module cr_tlvp2_dsm
  
  (
  
  tlvp_ib_rd, usr_ib_tlv, usr_ib_empty, usr_ib_aempty, pt_ib_tlv,
  pt_ib_empty, pt_ib_aempty, tlvp_error, tlvp_dsm_bimc_odat,
  tlvp_dsm_bimc_osync, pt_ib_ro_uncorrectable_ecc_error,
  usr_ib_ro_uncorrectable_ecc_error,
  
  clk, rst_n, tlvp_ib_empty, tlvp_ib_aempty, tlvp_ib,
  tlv_parse_action, module_id, usr_ib_rd, pt_ib_rd,
  tlvp_dsm_bimc_idat, tlvp_dsm_bimc_isync, bimc_rst_n
  );

`include "cr_structs.sv"
  
  
  
  
  parameter PT_USE_RAM      = 0;  
  parameter N_PT_ENTRIES    = 16; 
  parameter N_PT_AFULL_VAL  = 3;  
  parameter N_PT_AEMPTY_VAL = 1;  
  
  parameter TM_USE_RAM      = 0;  
  parameter N_TM_ENTRIES    = 16; 
  parameter N_TM_AFULL_VAL  = 3;  
  parameter N_TM_AEMPTY_VAL = 1;  

  
  
  
  localparam N_PT_DATA_BITS = $bits(tlvp_if_bus_t); 
  localparam N_TM_DATA_BITS = $bits(tlvp_if_bus_t);  

  
  
  
  
  input                      clk;
  input                      rst_n; 
     
  
  
  
  input                      tlvp_ib_empty;
  input                      tlvp_ib_aempty;
  input                      axi4s_dp_bus_t tlvp_ib;
  output logic               tlvp_ib_rd; 
  
  
  
  
  input [`TLVP_PA_WIDTH-1:0] tlv_parse_action;
  input         [`MODULE_ID_WIDTH-1:0] module_id;
  
  
  
  
  input                      usr_ib_rd;
  output                     tlvp_if_bus_t usr_ib_tlv;
  output logic               usr_ib_empty;
  output logic               usr_ib_aempty;
   
  
  
  
  input logic                pt_ib_rd;
  output                     tlvp_if_bus_t pt_ib_tlv;
  output logic               pt_ib_empty;
  output logic               pt_ib_aempty;
  
  
  
  
  output logic               tlvp_error;
  
  
  
  input  logic               tlvp_dsm_bimc_idat;             
  input  logic               tlvp_dsm_bimc_isync;            
  input  logic               bimc_rst_n;    

  output logic               tlvp_dsm_bimc_odat;            
  output logic               tlvp_dsm_bimc_osync; 
          
  output logic               pt_ib_ro_uncorrectable_ecc_error;
  output logic               usr_ib_ro_uncorrectable_ecc_error;
             
  

   
  tlvp_if_bus_t         tlvp_id_out;
  tlvp_if_bus_t         tlvp_pt_ib_wdata;  
  tlvp_if_bus_t         tlvp_usr_ib_wdata;
                            
   
  
  
  logic                 pt_ib_afull;            
  logic                 pt_ib_full;             
  logic                 tlvp_id_out_valid;      
  logic                 tlvp_pt_ib_wen;         
  logic                 tlvp_usr_ib_wen;        
  logic                 usr_ib_afull;           
  logic                 usr_ib_bimc_odat;       
  logic                 usr_ib_bimc_osync;      
  logic                 usr_ib_full;            
  
  
  
  
  
  
  
  cr_tlvp_id u_cr_tlvp_id (
                           
                           .tlvp_ib_rd          (tlvp_ib_rd),
                           .tlvp_id_out_valid   (tlvp_id_out_valid),
                           .tlvp_id_out         (tlvp_id_out),
                           .tlvp_error          (tlvp_error),
                           
                           .clk                 (clk),
                           .rst_n               (rst_n),
                           .tlvp_ib_empty       (tlvp_ib_empty),
                           .tlvp_ib_aempty      (tlvp_ib_aempty),
                           .tlvp_ib             (tlvp_ib),
                           .pt_ib_full          (pt_ib_full),
                           .pt_ib_afull         (pt_ib_afull),
                           .usr_ib_full         (usr_ib_full),
                           .usr_ib_afull        (usr_ib_afull),
                           .module_id           (module_id[`MODULE_ID_WIDTH-1:0]));
  
   


  
  
  
  
  cr_tlvp_spl u_cr_tlvp_spl(
                            
                            .tlvp_pt_ib_wen     (tlvp_pt_ib_wen),
                            .tlvp_pt_ib_wdata   (tlvp_pt_ib_wdata),
                            .tlvp_usr_ib_wen    (tlvp_usr_ib_wen),
                            .tlvp_usr_ib_wdata  (tlvp_usr_ib_wdata),
                            
                            .clk                (clk),
                            .rst_n              (rst_n),
                            .tlv_parse_action   (tlv_parse_action[`TLVP_PA_WIDTH-1:0]),
                            .tlvp_id_out_valid  (tlvp_id_out_valid),
                            .tlvp_id_out        (tlvp_id_out));
  

  
  
  
  
  
  cr_fifo_wrap2 # 
    (
     
     .USE_RAM              (PT_USE_RAM),
     .N_DATA_BITS          (N_PT_DATA_BITS),
     .N_ENTRIES            (N_PT_ENTRIES),
     .N_AFULL_VAL          (N_PT_AFULL_VAL),
     .N_AEMPTY_VAL         (N_PT_AEMPTY_VAL))
  u_cr_fifo_wrap2_pt                         
    (
     
     .full                              (pt_ib_full),            
     .afull                             (pt_ib_afull),           
     .rdata                             (pt_ib_tlv),             
     .empty                             (pt_ib_empty),           
     .aempty                            (pt_ib_aempty),          
     .bimc_odat                         (tlvp_dsm_bimc_odat),    
     .bimc_osync                        (tlvp_dsm_bimc_osync),   
     .ro_uncorrectable_ecc_error        (pt_ib_ro_uncorrectable_ecc_error), 
     
     .clk                               (clk),                   
     .rst_n                             (rst_n),                 
     .wdata                             (tlvp_pt_ib_wdata),      
     .wen                               (tlvp_pt_ib_wen),        
     .ren                               (pt_ib_rd),              
     .bimc_idat                         (usr_ib_bimc_odat),      
     .bimc_isync                        (usr_ib_bimc_osync),     
     .bimc_rst_n                        (bimc_rst_n));           

   

  
  
  
  
  
  cr_fifo_wrap2 # 
    (
     
     .USE_RAM              (TM_USE_RAM),
     .N_DATA_BITS          (N_TM_DATA_BITS),
     .N_ENTRIES            (N_TM_ENTRIES),
     .N_AFULL_VAL          (N_TM_AFULL_VAL),
     .N_AEMPTY_VAL         (N_TM_AEMPTY_VAL))
  u_cr_fifo_wrap2_usr_ib                         
    (
     
     .full                              (usr_ib_full),           
     .afull                             (usr_ib_afull),          
     .rdata                             (usr_ib_tlv),            
     .empty                             (usr_ib_empty),          
     .aempty                            (usr_ib_aempty),         
     .bimc_odat                         (usr_ib_bimc_odat),      
     .bimc_osync                        (usr_ib_bimc_osync),     
     .ro_uncorrectable_ecc_error        (usr_ib_ro_uncorrectable_ecc_error), 
     
     .clk                               (clk),                   
     .rst_n                             (rst_n),                 
     .wdata                             (tlvp_usr_ib_wdata),     
     .wen                               (tlvp_usr_ib_wen),       
     .ren                               (usr_ib_rd),             
     .bimc_idat                         (tlvp_dsm_bimc_idat),    
     .bimc_isync                        (tlvp_dsm_bimc_isync),   
     .bimc_rst_n                        (bimc_rst_n));           



endmodule












