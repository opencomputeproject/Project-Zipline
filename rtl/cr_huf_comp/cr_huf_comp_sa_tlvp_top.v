/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/























module cr_huf_comp_sa_tlvp_top 
  (
   
   tlvp_in_rd, term_empty, term_aempty, term_tlv, usr_full, usr_afull,
   crc_error, axi4s_ob_out,
   
   clk, rst_n, tlvp_in_aempty, tlvp_in_empty, tlvp_in_data,
   tlv_parse_action, module_id, term_rd, usr_wr, usr_tlv, axi4s_ob_in
   );
            
`include "cr_structs.sv"
  
  
  
  
  parameter N_PT_ENTRIES      = 16; 
  parameter N_PT_AFULL_VAL    = 3;  
  parameter N_PT_AEMPTY_VAL   = 1;  
  
  parameter N_TM_ENTRIES      = 16; 
  parameter N_TM_AFULL_VAL    = 3;  
  parameter N_TM_AEMPTY_VAL   = 1;  

  parameter N_UF_ENTRIES      = 16; 
  parameter N_UF_AFULL_VAL    = 3;  
  parameter N_UF_AEMPTY_VAL   = 1;  
  
  parameter N_OF_ENTRIES      = 16; 
  parameter N_OF_AFULL_VAL    = 3;  
  parameter N_OF_AEMPTY_VAL   = 1;  
    
  
  
  
     

  
  
  
  input                  clk;
  input                  rst_n; 
 
  
  
  
  input logic 	        tlvp_in_aempty;      
  input logic 	        tlvp_in_empty;        
  input axi4s_dp_bus_t  tlvp_in_data;          
  output logic          tlvp_in_rd;
   
  
  
  
  input [63:0]          tlv_parse_action;
   
  input [`MODULE_ID_WIDTH-1:0] module_id;
   
  
  
  
  input                 term_rd;
  output logic          term_empty;
  output logic          term_aempty;
  output tlvp_if_bus_t  term_tlv;
  
  
  
  
  input                 usr_wr;
  input  tlvp_if_bus_t  usr_tlv;
  output logic          usr_full;
  output logic          usr_afull;
   
  
  
  
  output logic          crc_error;

  
  
  
  input  axi4s_dp_rdy_t axi4s_ob_in;
  output axi4s_dp_bus_t axi4s_ob_out;

  
  
  
  axi4s_dp_bus_t	tlvp_ob;		
  logic			tlvp_ob_aempty;		
  logic			tlvp_ob_empty;		
  logic			tlvp_ob_rd;		
  

    
  
  
  
  
  
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
     
     .tlvp_ib_rd			(tlvp_in_rd),		 
     .usr_ib_empty			(term_empty),		 
     .usr_ib_aempty			(term_aempty),		 
     .usr_ib_tlv			(term_tlv),		 
     .usr_ob_full			(usr_full),		 
     .usr_ob_afull			(usr_afull),		 
     .tlvp_ob_empty			(tlvp_ob_empty),
     .tlvp_ob_aempty			(tlvp_ob_aempty),
     .tlvp_ob				(tlvp_ob),
     .tlvp_error			(crc_error),		 
     
     .clk				(clk),
     .rst_n				(rst_n),
     .tlvp_ib_empty			(tlvp_in_empty),	 
     .tlvp_ib_aempty			(tlvp_in_aempty),	 
     .tlvp_ib				(tlvp_in_data),		 
     .tlv_parse_action			(tlv_parse_action[`TLVP_PA_WIDTH-1:0]),
     .module_id				(module_id[`MODULE_ID_WIDTH-1:0]),
     .usr_ib_rd				(term_rd),		 
     .usr_ob_wr				(usr_wr),		 
     .usr_ob_tlv			(usr_tlv),		 
     .tlvp_ob_rd			(tlvp_ob_rd));

  
  
  
  
  
  
  cr_axi4s_mstr u_cr_axi4s_mstr                         
    (
     
     .axi4s_mstr_rd			(tlvp_ob_rd),		 
     .axi4s_ob_out			(axi4s_ob_out),		 
     
     .clk				(clk),
     .rst_n				(rst_n),
     .axi4s_in				(tlvp_ob),		 
     .axi4s_in_empty			(tlvp_ob_empty),	 
     .axi4s_in_aempty			(tlvp_ob_aempty),	 
     .axi4s_ob_in			(axi4s_ob_in));		 

  


       
endmodule 









