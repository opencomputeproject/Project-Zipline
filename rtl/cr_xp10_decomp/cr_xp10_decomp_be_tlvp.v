/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











module cr_xp10_decomp_be_tlvp (
   
   xp10_decomp_ob_out, pt_ob_rd, lz_data_full, lz_data_afull,
   
   clk, rst_n, xp10_decomp_ob_in, pt_ob_empty, pt_ob_aempty,
   pt_ob_tlv, lz_data_wr, lz_data_tlv
   );

   import crPKG::*;
   import cr_xp10_decompPKG::*;
   import cr_xp10_decomp_regsPKG::*;

   
   
   
   input                         clk;
   input                         rst_n;

   output  axi4s_dp_bus_t        xp10_decomp_ob_out;
   input                         xp10_decomp_ob_in;

   
   output logic                  pt_ob_rd;
   input                         pt_ob_empty;
   input                         pt_ob_aempty;
   input  tlvp_if_bus_t          pt_ob_tlv;

   
   output logic                  lz_data_full;
   output logic                  lz_data_afull;
   input                         lz_data_wr;
   input  tlvp_if_bus_t          lz_data_tlv;
   
   
   
   axi4s_dp_bus_t       axi4s_in;               
   logic                axi4s_in_aempty;        
   logic                axi4s_in_empty;         
   logic                axi4s_mstr_rd;          
   
    parameter N_UF_ENTRIES    = 16; 
  parameter N_UF_AFULL_VAL  = 4;  
  parameter N_UF_AEMPTY_VAL = 2;  
  
  parameter N_OF_ENTRIES    = 16; 
  parameter N_OF_AFULL_VAL  = 4;  
  parameter N_OF_AEMPTY_VAL = 2;  
  
   
   cr_tlvp_rsm # (
                  .N_UF_ENTRIES            (N_UF_ENTRIES),
                  .N_UF_AFULL_VAL          (N_UF_AFULL_VAL),
                  .N_UF_AEMPTY_VAL         (N_UF_AEMPTY_VAL),
                  .N_OF_ENTRIES            (N_OF_ENTRIES),
                  .N_OF_AFULL_VAL          (N_OF_AFULL_VAL),
                  .N_OF_AEMPTY_VAL         (N_OF_AEMPTY_VAL))
                  rsm_inst (
                            
                            .pt_ob_rd           (pt_ob_rd),
                            .usr_ob_full        (lz_data_full),  
                            .usr_ob_afull       (lz_data_afull), 
                            .tlvp_ob_empty      (axi4s_in_empty), 
                            .tlvp_ob_aempty     (axi4s_in_aempty), 
                            .tlvp_ob            (axi4s_in),      
                            
                            .clk                (clk),
                            .rst_n              (rst_n),
                            .pt_ob_empty        (pt_ob_empty),
                            .pt_ob_aempty       (pt_ob_aempty),
                            .pt_ob_tlv          (pt_ob_tlv),
                            .usr_ob_wr          (lz_data_wr),    
                            .usr_ob_tlv         (lz_data_tlv),   
                            .tlvp_ob_rd         (axi4s_mstr_rd)); 
   

   cr_axi4s_mstr axi_mstr (
                           
                           .axi4s_mstr_rd       (axi4s_mstr_rd), 
                           .axi4s_ob_out        (xp10_decomp_ob_out), 
                           
                           .clk                 (clk),
                           .rst_n               (rst_n),
                           .axi4s_in            (axi4s_in),
                           .axi4s_in_empty      (axi4s_in_empty),
                           .axi4s_in_aempty     (axi4s_in_aempty),
                           .axi4s_ob_in         (xp10_decomp_ob_in)); 
   
endmodule 








