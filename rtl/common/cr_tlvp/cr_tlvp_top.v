/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/






























module cr_tlvp_top 
  (

  
  axi4s_ib_out, usr_ib_empty, usr_ib_aempty, usr_ib_tlv, usr_ob_full,
  usr_ob_afull, tlvp_error, axi4s_ob_out,
  
  clk, rst_n, axi4s_ib_in, tlv_parse_action, module_id, usr_ib_rd,
  usr_ob_wr, usr_ob_tlv, axi4s_ob_in
  );
            
`include "cr_structs.sv"
  
  
  
  
  parameter N_AXIS_ENTRIES    = 16; 
  parameter N_AXIS_AFULL_VAL  = 1;  
  parameter N_AXIS_AEMPTY_VAL = 1;  
  
  parameter N_PT_ENTRIES      = 16; 
  parameter N_PT_AFULL_VAL    = 3;  
  parameter N_PT_AEMPTY_VAL   = 1;  
  
  parameter N_TM_ENTRIES      = 16; 
  parameter N_TM_AFULL_VAL    = 3;  
  parameter N_TM_AEMPTY_VAL   = 1;  

  parameter N_UF_ENTRIES      = 16; 
  parameter N_UF_AFULL_VAL    = 2;  
  parameter N_UF_AEMPTY_VAL   = 1;  
  
  parameter N_OF_ENTRIES      = 16; 
  parameter N_OF_AFULL_VAL    = 4;  
  parameter N_OF_AEMPTY_VAL   = 1;  
    
  
  
  
     

  
  
  
  input                      clk;
  input                      rst_n; 
 
  
  
  
  input                      axi4s_dp_bus_t axi4s_ib_in;
  output                     axi4s_dp_rdy_t axi4s_ib_out;

  
  
  
  input [`TLVP_PA_WIDTH-1:0]   tlv_parse_action;
  input [`MODULE_ID_WIDTH-1:0] module_id;
  
  
  
  
  input                      usr_ib_rd;
  output logic               usr_ib_empty;
  output logic               usr_ib_aempty;
  output                     tlvp_if_bus_t usr_ib_tlv;
  
  
  
  
  input                      usr_ob_wr;
  input                      tlvp_if_bus_t usr_ob_tlv;
  output logic               usr_ob_full;
  output logic               usr_ob_afull;
   
  
  
  
  output logic               tlvp_error;

  
  
  
  input                      axi4s_dp_rdy_t axi4s_ob_in;
  output                     axi4s_dp_bus_t axi4s_ob_out;

  
  
  
  logic                 axi4s_slv_aempty;       
  logic                 axi4s_slv_empty;        
  axi4s_dp_bus_t        axi4s_slv_out;          
  logic                 tlvp_ib_rd;             
  axi4s_dp_bus_t        tlvp_ob;                
  logic                 tlvp_ob_aempty;         
  logic                 tlvp_ob_empty;          
  logic                 tlvp_ob_rd;             
  

  
   
  
  
  
  
  
  cr_axi4s_slv # 
    (
     
     .N_ENTRIES                        (N_AXIS_ENTRIES),
     .N_AFULL_VAL                      (N_AXIS_AFULL_VAL),
     .N_AEMPTY_VAL                     (N_AXIS_AEMPTY_VAL))
  u_cr_axi4s_slave                       
    (
     
     .axi4s_ib_out                      (axi4s_ib_out),          
     .axi4s_slv_out                     (axi4s_slv_out),
     .axi4s_slv_empty                   (axi4s_slv_empty),
     .axi4s_slv_aempty                  (axi4s_slv_aempty),
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .axi4s_ib_in                       (axi4s_ib_in),           
     .axi4s_slv_rd                      (tlvp_ib_rd));           

    
  
  
  
  
  
  cr_tlvp # 
    (
     
     .N_PT_ENTRIES            (N_PT_ENTRIES),
     .N_PT_AFULL_VAL          (N_PT_AFULL_VAL),
     .N_PT_AEMPTY_VAL         (N_PT_AEMPTY_VAL),
     .N_TM_ENTRIES            (N_TM_ENTRIES),
     .N_TM_AFULL_VAL          (N_TM_AFULL_VAL),
     .N_TM_AEMPTY_VAL         (N_TM_AEMPTY_VAL),
     .N_OF_ENTRIES            (N_OF_ENTRIES),
     .N_OF_AFULL_VAL          (N_OF_AFULL_VAL),
     .N_OF_AEMPTY_VAL         (N_OF_AEMPTY_VAL),
     .N_UF_ENTRIES            (N_UF_ENTRIES),
     .N_UF_AFULL_VAL          (N_UF_AFULL_VAL),
     .N_UF_AEMPTY_VAL         (N_UF_AEMPTY_VAL))
  u_cr_tlvp                         
    (
     
     .tlvp_ib_rd                        (tlvp_ib_rd),
     .usr_ib_empty                      (usr_ib_empty),
     .usr_ib_aempty                     (usr_ib_aempty),
     .usr_ib_tlv                        (usr_ib_tlv),
     .usr_ob_full                       (usr_ob_full),
     .usr_ob_afull                      (usr_ob_afull),
     .tlvp_ob_empty                     (tlvp_ob_empty),
     .tlvp_ob_aempty                    (tlvp_ob_aempty),
     .tlvp_ob                           (tlvp_ob),
     .tlvp_error                        (tlvp_error),
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .tlvp_ib_empty                     (axi4s_slv_empty),       
     .tlvp_ib_aempty                    (axi4s_slv_aempty),      
     .tlvp_ib                           (axi4s_slv_out),         
     .tlv_parse_action                  (tlv_parse_action[`TLVP_PA_WIDTH-1:0]),
     .module_id                         (module_id[`MODULE_ID_WIDTH-1:0]),
     .usr_ib_rd                         (usr_ib_rd),
     .usr_ob_wr                         (usr_ob_wr),
     .usr_ob_tlv                        (usr_ob_tlv),
     .tlvp_ob_rd                        (tlvp_ob_rd));

  
  
  
  
  
  
  cr_axi4s_mstr u_cr_axi4s_mstr                         
    (
     
     .axi4s_mstr_rd                     (tlvp_ob_rd),            
     .axi4s_ob_out                      (axi4s_ob_out),          
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .axi4s_in                          (tlvp_ob),               
     .axi4s_in_empty                    (tlvp_ob_empty),         
     .axi4s_in_aempty                   (tlvp_ob_aempty),        
     .axi4s_ob_in                       (axi4s_ob_in));          

  


       
endmodule 









