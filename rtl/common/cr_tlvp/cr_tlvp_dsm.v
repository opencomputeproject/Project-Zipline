/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


































module cr_tlvp_dsm
  
  (
  
  tlvp_ib_rd, usr_ib_tlv, usr_ib_empty, usr_ib_aempty, pt_ib_tlv,
  pt_ib_empty, pt_ib_aempty, tlvp_error,
  
  clk, rst_n, tlvp_ib_empty, tlvp_ib_aempty, tlvp_ib,
  tlv_parse_action, module_id, usr_ib_rd, pt_ib_rd
  );

`include "cr_structs.sv"
  
  
  
  
  parameter N_PT_ENTRIES    = 16; 
  parameter N_PT_AFULL_VAL  = 3;  
  parameter N_PT_AEMPTY_VAL = 1;  
  
  parameter N_TM_ENTRIES    = 16; 
  parameter N_TM_AFULL_VAL  = 3;  
  parameter N_TM_AEMPTY_VAL = 1;  

  
  
  
  localparam N_PT_DATA_BITS = $bits(tlvp_if_bus_t); 
  localparam N_TM_DATA_BITS = $bits(tlvp_if_bus_t);  

  
  
  
  
  input                      clk;
  input                      rst_n; 
     
  
  
  
  input                      tlvp_ib_empty;
  input                      tlvp_ib_aempty;
  input  axi4s_dp_bus_t      tlvp_ib;
  output logic               tlvp_ib_rd;  
  
  
  
  
  input [`TLVP_PA_WIDTH-1:0]   tlv_parse_action;
  input [`MODULE_ID_WIDTH-1:0] module_id;
  
  
  
  
  input                      usr_ib_rd;
  output tlvp_if_bus_t       usr_ib_tlv;
  output logic               usr_ib_empty;
  output logic               usr_ib_aempty;
   
  
  
  
  input  logic               pt_ib_rd;
  output tlvp_if_bus_t       pt_ib_tlv;
  output logic               pt_ib_empty;
  output logic               pt_ib_aempty;
  
  
  
  
  output logic               tlvp_error;
  
  

   
  tlvp_if_bus_t         tlvp_id_out;
  tlvp_if_bus_t         tlvp_pt_ib_wdata;  
  tlvp_if_bus_t         tlvp_usr_ib_wdata;
                            
   
  
  
  logic                 pt_ib_afull;            
  logic                 pt_ib_full;             
  logic                 tlvp_id_out_valid;      
  logic                 tlvp_pt_ib_wen;         
  logic                 tlvp_usr_ib_wen;        
  logic                 usr_ib_afull;           
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
  

  
  
  
  
  
  cr_fifo_wrap1 # 
    (
     
     .N_DATA_BITS          (N_PT_DATA_BITS),
     .N_ENTRIES            (N_PT_ENTRIES),
     .N_AFULL_VAL          (N_PT_AFULL_VAL),
     .N_AEMPTY_VAL         (N_PT_AEMPTY_VAL))
  u_cr_fifo_wrap1_pt                         
    (
     
     .full                              (pt_ib_full),            
     .afull                             (pt_ib_afull),           
     .rdata                             (pt_ib_tlv),             
     .empty                             (pt_ib_empty),           
     .aempty                            (pt_ib_aempty),          
     
     .clk                               (clk),                   
     .rst_n                             (rst_n),                 
     .wdata                             (tlvp_pt_ib_wdata),      
     .wen                               (tlvp_pt_ib_wen),        
     .ren                               (pt_ib_rd));             

   

  
  
  
  
  
  cr_fifo_wrap1 # 
    (
     
     .N_DATA_BITS          (N_TM_DATA_BITS),
     .N_ENTRIES            (N_TM_ENTRIES),
     .N_AFULL_VAL          (N_TM_AFULL_VAL),
     .N_AEMPTY_VAL         (N_TM_AEMPTY_VAL))
  u_cr_fifo_wrap1_usr_ib                         
    (
     
     .full                              (usr_ib_full),           
     .afull                             (usr_ib_afull),          
     .rdata                             (usr_ib_tlv),            
     .empty                             (usr_ib_empty),          
     .aempty                            (usr_ib_aempty),         
     
     .clk                               (clk),                   
     .rst_n                             (rst_n),                 
     .wdata                             (tlvp_usr_ib_wdata),     
     .wen                               (tlvp_usr_ib_wen),       
     .ren                               (usr_ib_rd));            



endmodule












