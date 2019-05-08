/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
































`include "ccx_std.vh"


module cr_tlvp2_rsm
  
  (
  
  pt_ob_rd, usr_ob_full, usr_ob_afull, tlvp_ob_empty, tlvp_ob_aempty,
  tlvp_ob, tlvp_rsm_bimc_odat, tlvp_rsm_bimc_osync,
  tlvp_ob_ro_uncorrectable_ecc_error,
  usr_ob_ro_uncorrectable_ecc_error,
  
  clk, rst_n, pt_ob_empty, pt_ob_aempty, pt_ob_tlv, usr_ob_wr,
  usr_ob_tlv, tlvp_ob_rd, tlvp_rsm_bimc_idat, tlvp_rsm_bimc_isync,
  bimc_rst_n
  );

`include "cr_structs.sv"
  
  
  
  
  parameter UF_USE_RAM      = 0;  
  parameter N_UF_ENTRIES    = 16; 
  parameter N_UF_AFULL_VAL  = 1;  
  parameter N_UF_AEMPTY_VAL = 1;  
  
  parameter OF_USE_RAM      = 0;  
  parameter N_OF_ENTRIES    = 16; 
  parameter N_OF_AFULL_VAL  = 4;  
  parameter N_OF_AEMPTY_VAL = 1;  
  
  
  
  
  parameter N_UF_DATA_BITS  = $bits(tlvp_if_bus_t); 
  parameter N_OF_DATA_BITS  = $bits(axi4s_dp_bus_t);
  
  
  
  
  input                           clk;
  input                           rst_n; 
     
  
  
  
  input                           pt_ob_empty;
  input                           pt_ob_aempty;
  input  tlvp_if_bus_t            pt_ob_tlv;
  output logic                    pt_ob_rd;
     
  
  
  
  input                           usr_ob_wr;
  input  tlvp_if_bus_t            usr_ob_tlv;
  output logic                    usr_ob_full;
  output logic                    usr_ob_afull;
  
  
  
  
  input                           tlvp_ob_rd;
  output logic                    tlvp_ob_empty;
  output logic                    tlvp_ob_aempty;
  output axi4s_dp_bus_t           tlvp_ob;
  
  
  
  
  input  logic                    tlvp_rsm_bimc_idat;             
  input  logic                    tlvp_rsm_bimc_isync;            
  input  logic                    bimc_rst_n;    

  output logic                    tlvp_rsm_bimc_odat;            
  output logic                    tlvp_rsm_bimc_osync;
           
  output logic                    tlvp_ob_ro_uncorrectable_ecc_error;          
  output logic                    usr_ob_ro_uncorrectable_ecc_error;
           
          

  

  tlvp_if_bus_t                   tlvp_rsm_usr_ob_rdata;
  axi4s_dp_bus_t                  tlvp_rsm_ob_wdata;
  
  
  
  logic                 tlvp_ob_afull;          
  logic                 tlvp_ob_full;           
  logic                 tlvp_rsm_ob_wen;        
  logic                 tlvp_rsm_usr_ob_ren;    
  logic                 usr_ob_aempty;          
  logic                 usr_ob_bimc_odat;       
  logic                 usr_ob_bimc_osync;      
  logic                 usr_ob_empty;           
  
  
  
  
  
  
  
  cr_tlvp2_rsm_core
  u_cr_tlvp2_rsm_core                         
    (
     
     .pt_ob_rd                          (pt_ob_rd),
     .tlvp_rsm_usr_ob_ren               (tlvp_rsm_usr_ob_ren),
     .tlvp_rsm_ob_wen                   (tlvp_rsm_ob_wen),
     .tlvp_rsm_ob_wdata                 (tlvp_rsm_ob_wdata),
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .pt_ob_empty                       (pt_ob_empty),
     .pt_ob_aempty                      (pt_ob_aempty),
     .pt_ob_tlv                         (pt_ob_tlv),
     .tlvp_rsm_usr_ob_rdata             (tlvp_rsm_usr_ob_rdata),
     .usr_ob_empty                      (usr_ob_empty),
     .usr_ob_aempty                     (usr_ob_aempty),
     .tlvp_ob_full                      (tlvp_ob_full),
     .tlvp_ob_afull                     (tlvp_ob_afull));
  

   
  
  
  
  
  
  cr_fifo_wrap2 # 
    (
     
     .USE_RAM             (OF_USE_RAM),
     .N_DATA_BITS         (N_OF_DATA_BITS),
     .N_ENTRIES           (N_OF_ENTRIES),
     .N_AFULL_VAL         (N_OF_AFULL_VAL),
     .N_AEMPTY_VAL        (N_OF_AEMPTY_VAL))
  u_cr_fifo_wrap2_tob                         
    (
     
     .full                              (tlvp_ob_full),          
     .afull                             (tlvp_ob_afull),         
     .rdata                             (tlvp_ob),               
     .empty                             (tlvp_ob_empty),         
     .aempty                            (tlvp_ob_aempty),        
     .bimc_odat                         (tlvp_rsm_bimc_odat),    
     .bimc_osync                        (tlvp_rsm_bimc_osync),   
     .ro_uncorrectable_ecc_error        (tlvp_ob_ro_uncorrectable_ecc_error), 
     
     .clk                               (clk),                   
     .rst_n                             (rst_n),                 
     .wdata                             (tlvp_rsm_ob_wdata),     
     .wen                               (tlvp_rsm_ob_wen),       
     .ren                               (tlvp_ob_rd),            
     .bimc_idat                         (usr_ob_bimc_odat),      
     .bimc_isync                        (usr_ob_bimc_osync),     
     .bimc_rst_n                        (bimc_rst_n));           

  
  
  
  
  
  
  cr_fifo_wrap2 # 
    (
     
     .USE_RAM             (UF_USE_RAM),
     .N_DATA_BITS         (N_UF_DATA_BITS),
     .N_ENTRIES           (N_UF_ENTRIES),
     .N_AFULL_VAL         (N_UF_AFULL_VAL),
     .N_AEMPTY_VAL        (N_UF_AEMPTY_VAL))
  u_cr_fifo_wrap2_uobf                         
    (
     
     .full                              (usr_ob_full),           
     .afull                             (usr_ob_afull),          
     .rdata                             (tlvp_rsm_usr_ob_rdata), 
     .empty                             (usr_ob_empty),          
     .aempty                            (usr_ob_aempty),         
     .bimc_odat                         (usr_ob_bimc_odat),      
     .bimc_osync                        (usr_ob_bimc_osync),     
     .ro_uncorrectable_ecc_error        (usr_ob_ro_uncorrectable_ecc_error), 
     
     .clk                               (clk),                   
     .rst_n                             (rst_n),                 
     .wdata                             (usr_ob_tlv),            
     .wen                               (usr_ob_wr),             
     .ren                               (tlvp_rsm_usr_ob_ren),   
     .bimc_idat                         (tlvp_rsm_bimc_idat),    
     .bimc_isync                        (tlvp_rsm_bimc_isync),   
     .bimc_rst_n                        (bimc_rst_n));           
  
endmodule












