/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
module cr_xp10_decomp_fe_tlvp (
   
   xp10_decomp_ib_out, fhp_tlvp_pt_tlv, fhp_tlvp_pt_empty,
   fhp_tlvp_usr_empty, fhp_tlvp_usr_tlv, fe_tlvp_error,
   
   clk, rst_n, xp10_decomp_ib_in, fhp_tlvp_pt_rd, fhp_tlvp_usr_rd,
   sw_TLVP_ACTION_CFG0, sw_TLVP_ACTION_CFG1, xp10_decomp_module_id
   );

   import crPKG::*;
   import cr_xp10_decompPKG::*;
   import cr_xp10_decomp_regsPKG::*;

   
   
   
   input         clk;
   input         rst_n;
   
   
   
   
   input         axi4s_dp_bus_t xp10_decomp_ib_in;
   output        axi4s_dp_rdy_t xp10_decomp_ib_out;           
   input         fhp_tlvp_pt_rd;
   output        tlvp_if_bus_t     fhp_tlvp_pt_tlv;
   output        fhp_tlvp_pt_empty;
   
   input         fhp_tlvp_usr_rd;
   output        fhp_tlvp_usr_empty;
   output        tlvp_if_bus_t      fhp_tlvp_usr_tlv;

   input [31:0]  sw_TLVP_ACTION_CFG0;
   input [31:0]  sw_TLVP_ACTION_CFG1;
   
   input [`MODULE_ID_WIDTH-1:0] xp10_decomp_module_id;

   output                       fe_tlvp_error;
   
   parameter    N_AXIS_ENTRIES = 16,
     N_AXIS_AFULL_VAL = 4;
      
   
   logic                axi4s_slv_aempty;       
   logic                axi4s_slv_empty;        
   axi4s_dp_bus_t       axi4s_slv_out;          
   logic                tlvp_ib_rd;             
   

  
  
  
  
  
  cr_axi4s_slv # 
    (
     
     .N_ENTRIES                        (N_AXIS_ENTRIES),
     .N_AFULL_VAL                      (N_AXIS_AFULL_VAL))
   axi_in                         
     (
      
      .axi4s_ib_out                     (xp10_decomp_ib_out),    
      .axi4s_slv_out                    (axi4s_slv_out),
      .axi4s_slv_empty                  (axi4s_slv_empty),
      .axi4s_slv_aempty                 (axi4s_slv_aempty),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .axi4s_ib_in                      (xp10_decomp_ib_in),     
      .axi4s_slv_rd                     (tlvp_ib_rd));           


   parameter N_PT_ENTRIES = 16,
     N_PT_AFULL_VAL = 4,
     N_PT_AEMPTY_VAL = 2,
     N_TM_ENTRIES = 16,
     N_TM_AFULL_VAL = 4,
     N_TM_AEMPTY_VAL = 2;
   
   
  
   cr_tlvp_dsm #
     (
      
      .N_PT_ENTRIES            (N_PT_ENTRIES),
      .N_PT_AFULL_VAL          (N_PT_AFULL_VAL),
      .N_PT_AEMPTY_VAL         (N_PT_AEMPTY_VAL),
      .N_TM_ENTRIES            (N_TM_ENTRIES),
      .N_TM_AFULL_VAL          (N_TM_AFULL_VAL),
      .N_TM_AEMPTY_VAL         (N_TM_AEMPTY_VAL))
   tlvp_dsm 
     (.tlvp_error                       (fe_tlvp_error),
      
      
      .tlvp_ib_rd                       (tlvp_ib_rd),
      .usr_ib_tlv                       (fhp_tlvp_usr_tlv),      
      .usr_ib_empty                     (fhp_tlvp_usr_empty),    
      .usr_ib_aempty                    (),                      
      .pt_ib_tlv                        (fhp_tlvp_pt_tlv),       
      .pt_ib_empty                      (fhp_tlvp_pt_empty),     
      .pt_ib_aempty                     (),                      
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .tlvp_ib_empty                    (axi4s_slv_empty),       
      .tlvp_ib_aempty                   (axi4s_slv_aempty),      
      .tlvp_ib                          (axi4s_slv_out),         
      .tlv_parse_action                 ({sw_TLVP_ACTION_CFG1, sw_TLVP_ACTION_CFG0}), 
      .module_id                        (xp10_decomp_module_id), 
      .usr_ib_rd                        (fhp_tlvp_usr_rd),       
      .pt_ib_rd                         (fhp_tlvp_pt_rd));       

      
   
endmodule 








