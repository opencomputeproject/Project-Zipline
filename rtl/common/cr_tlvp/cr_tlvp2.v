/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


































module cr_tlvp2
  
  (
  
  tlvp_ib_rd, usr_ib_empty, usr_ib_aempty, usr_ib_tlv, usr_ob_full,
  usr_ob_afull, tlvp_ob_empty, tlvp_ob_aempty, tlvp_ob, tlvp_error,
  bimc_odat, bimc_osync, pt_ib_ro_uncorrectable_ecc_error,
  usr_ib_ro_uncorrectable_ecc_error,
  tlvp_ob_ro_uncorrectable_ecc_error,
  usr_ob_ro_uncorrectable_ecc_error,
  
  clk, rst_n, tlvp_ib_empty, tlvp_ib_aempty, tlvp_ib,
  tlv_parse_action, module_id, usr_ib_rd, usr_ob_wr, usr_ob_tlv,
  tlvp_ob_rd, bimc_idat, bimc_isync, bimc_rst_n
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

  parameter UF_USE_RAM      = 0;  
  parameter N_UF_ENTRIES    = 16; 
  parameter N_UF_AFULL_VAL  = 2;  
  parameter N_UF_AEMPTY_VAL = 1;  
 
  parameter OF_USE_RAM      = 0;  
  parameter N_OF_ENTRIES    = 16; 
  parameter N_OF_AFULL_VAL  = 4;  
  parameter N_OF_AEMPTY_VAL = 1;  
    
  
  
  

  
  
  
  
  input                      clk;
  input                      rst_n; 
     
  
  
  
  input                      tlvp_ib_empty;
  input                      tlvp_ib_aempty;
  input                      axi4s_dp_bus_t tlvp_ib;
  output logic               tlvp_ib_rd; 
  
  
  
  
  input [`TLVP_PA_WIDTH-1:0] tlv_parse_action;
  input [`MODULE_ID_WIDTH-1:0] module_id;
 
  
  
  
  input                      usr_ib_rd;
  output logic               usr_ib_empty;
  output logic               usr_ib_aempty;
  output                     tlvp_if_bus_t usr_ib_tlv;
  
  
  
  
  input                      usr_ob_wr;
  input                      tlvp_if_bus_t usr_ob_tlv;
  output logic               usr_ob_full;
  output logic               usr_ob_afull;
  
  
  
  
  input                      tlvp_ob_rd;
  output logic               tlvp_ob_empty;
  output logic               tlvp_ob_aempty;
  output                     axi4s_dp_bus_t tlvp_ob;
  
  
  
  
  output logic               tlvp_error;

  
  
  
  input  logic               bimc_idat;             
  input  logic               bimc_isync;            
  input  logic               bimc_rst_n;    

  output logic               bimc_odat;            
  output logic               bimc_osync;  
         
  output logic               pt_ib_ro_uncorrectable_ecc_error;
  output logic               usr_ib_ro_uncorrectable_ecc_error;
  output logic               tlvp_ob_ro_uncorrectable_ecc_error;
  output logic               usr_ob_ro_uncorrectable_ecc_error;
              
 
  

  
                              
   
  
  
  logic                 pt_ib_aempty;           
  logic                 pt_ib_empty;            
  tlvp_if_bus_t         pt_ib_tlv;              
  logic                 pt_ob_rd;               
  logic                 tlvp_dsm_bimc_odat;     
  logic                 tlvp_dsm_bimc_osync;    
  
  
  
  
  
  
  
  cr_tlvp2_dsm  #
     (
     
     .PT_USE_RAM              (PT_USE_RAM),
     .N_PT_ENTRIES            (N_PT_ENTRIES),
     .N_PT_AFULL_VAL          (N_PT_AFULL_VAL),
     .N_PT_AEMPTY_VAL         (N_PT_AEMPTY_VAL),
     .TM_USE_RAM              (TM_USE_RAM),
     .N_TM_ENTRIES            (N_TM_ENTRIES),
     .N_TM_AFULL_VAL          (N_TM_AFULL_VAL),
     .N_TM_AEMPTY_VAL         (N_TM_AEMPTY_VAL))
  u_cr_tlvp2_dsm 
    (
     
     .tlvp_ib_rd                        (tlvp_ib_rd),
     .usr_ib_tlv                        (usr_ib_tlv),
     .usr_ib_empty                      (usr_ib_empty),
     .usr_ib_aempty                     (usr_ib_aempty),
     .pt_ib_tlv                         (pt_ib_tlv),
     .pt_ib_empty                       (pt_ib_empty),
     .pt_ib_aempty                      (pt_ib_aempty),
     .tlvp_error                        (tlvp_error),
     .tlvp_dsm_bimc_odat                (tlvp_dsm_bimc_odat),    
     .tlvp_dsm_bimc_osync               (tlvp_dsm_bimc_osync),   
     .pt_ib_ro_uncorrectable_ecc_error  (pt_ib_ro_uncorrectable_ecc_error),
     .usr_ib_ro_uncorrectable_ecc_error (usr_ib_ro_uncorrectable_ecc_error),
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .tlvp_ib_empty                     (tlvp_ib_empty),
     .tlvp_ib_aempty                    (tlvp_ib_aempty),
     .tlvp_ib                           (tlvp_ib),
     .tlv_parse_action                  (tlv_parse_action[`TLVP_PA_WIDTH-1:0]),
     .module_id                         (module_id[`MODULE_ID_WIDTH-1:0]),
     .usr_ib_rd                         (usr_ib_rd),
     .pt_ib_rd                          (pt_ob_rd),              
     .tlvp_dsm_bimc_idat                (bimc_idat),             
     .tlvp_dsm_bimc_isync               (bimc_isync),            
     .bimc_rst_n                        (bimc_rst_n));
  
 
  
  
  
  
  cr_tlvp2_rsm #
     (
     
     .OF_USE_RAM              (OF_USE_RAM),
     .N_OF_ENTRIES            (N_OF_ENTRIES),
     .N_OF_AFULL_VAL          (N_OF_AFULL_VAL),
     .N_OF_AEMPTY_VAL         (N_OF_AEMPTY_VAL),
     .UF_USE_RAM              (UF_USE_RAM),
     .N_UF_ENTRIES            (N_UF_ENTRIES),
     .N_UF_AFULL_VAL          (N_UF_AFULL_VAL),
     .N_UF_AEMPTY_VAL         (N_UF_AEMPTY_VAL))
  u_cr_tlvp2_rsm
    (
     
     .pt_ob_rd                          (pt_ob_rd),
     .usr_ob_full                       (usr_ob_full),
     .usr_ob_afull                      (usr_ob_afull),
     .tlvp_ob_empty                     (tlvp_ob_empty),
     .tlvp_ob_aempty                    (tlvp_ob_aempty),
     .tlvp_ob                           (tlvp_ob),
     .tlvp_rsm_bimc_odat                (bimc_odat),             
     .tlvp_rsm_bimc_osync               (bimc_osync),            
     .tlvp_ob_ro_uncorrectable_ecc_error(tlvp_ob_ro_uncorrectable_ecc_error),
     .usr_ob_ro_uncorrectable_ecc_error (usr_ob_ro_uncorrectable_ecc_error),
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .pt_ob_empty                       (pt_ib_empty),           
     .pt_ob_aempty                      (pt_ib_aempty),          
     .pt_ob_tlv                         (pt_ib_tlv),             
     .usr_ob_wr                         (usr_ob_wr),
     .usr_ob_tlv                        (usr_ob_tlv),
     .tlvp_ob_rd                        (tlvp_ob_rd),
     .tlvp_rsm_bimc_idat                (tlvp_dsm_bimc_odat),    
     .tlvp_rsm_bimc_isync               (tlvp_dsm_bimc_osync),   
     .bimc_rst_n                        (bimc_rst_n));
  

endmodule












