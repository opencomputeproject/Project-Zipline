/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

















`include "crPKG.svp"
`include "cr_prefix.vh"

module cr_prefix_fe 
  (
  
  feature_ctr, fe_ctr_1, fe_ctr_2, fe_ctr_3, fe_ctr_4,
  
  clk, rst_n, fe_config, ibc_data_tlv_tdata, ibc_data_vbytes,
  ibc_blk_sel, ibc_ctr_reload
  );
            
`include "cr_structs.sv"
      
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;

  
  
  
  input                                          clk;
  input                                          rst_n; 
        
  
  
  
  input feature_t                                fe_config[0:`N_PREFIX_FEATURES-1];
  
        
  
  
  
  input  [`AXI_S_DP_DWIDTH-1:0]                  ibc_data_tlv_tdata;
  input  [7:0]                                   ibc_data_vbytes;
  input  [1:0]                                   ibc_blk_sel;
  input                                          ibc_ctr_reload;
  
    
  
  
  
  output feature_ctr_t                           feature_ctr[0:`N_PREFIX_FEATURES-1];
  output logic [(`N_PREFIX_FEATURE_CTR * 8)-1:0] fe_ctr_1;
  output logic [(`N_PREFIX_FEATURE_CTR * 8)-1:0] fe_ctr_2;
  output logic [(`N_PREFIX_FEATURE_CTR * 8)-1:0] fe_ctr_3;
  output logic [(`N_PREFIX_FEATURE_CTR * 8)-1:0] fe_ctr_4;


  

 
  logic [7:0]          fe_counter_1[`N_PREFIX_FEATURE_CTR-1:0]; 
  logic [7:0]          fe_counter_2[`N_PREFIX_FEATURE_CTR-1:0]; 
  logic [7:0]          fe_counter_3[`N_PREFIX_FEATURE_CTR-1:0]; 
  logic [7:0]          fe_counter_4[`N_PREFIX_FEATURE_CTR-1:0];  
  
  
  
  genvar               j;
  generate
    for(j=0;j<64;j=j+1) begin
      assign feature_ctr[j]  = fe_counter_1[j];
    end
    for(j=64;j<128;j=j+1) begin
      assign feature_ctr[j]  = fe_counter_2[j-64];
    end
    for(j=128;j<192;j=j+1) begin
      assign feature_ctr[j]  = fe_counter_3[j-128];
    end
    for(j=192;j<256;j=j+1) begin
      assign feature_ctr[j]  = fe_counter_4[j-192];
    end
  endgenerate


  genvar               i;
  generate
    for(i=0;i<`N_PREFIX_FEATURE_CTR;i=i+1) begin
      assign fe_ctr_1[(i*8)+7:i*8] = fe_counter_1[i][7:0];
      assign fe_ctr_2[(i*8)+7:i*8] = fe_counter_2[i][7:0];
      assign fe_ctr_3[(i*8)+7:i*8] = fe_counter_3[i][7:0];
      assign fe_ctr_4[(i*8)+7:i*8] = fe_counter_4[i][7:0];
    end
  endgenerate
  
  
  


  

  
  
  
  

  genvar                  k;
  generate 
    for(k=0;k<`N_PREFIX_FEATURE_CTR;k=k+1) begin : fe_counters
      cr_prefix_fe_counter u_cr_prefix_fe_counter_k
        (
         
         
         .fe_counter_1                  (fe_counter_1[k][7:0]),  
         .fe_counter_2                  (fe_counter_2[k][7:0]),  
         .fe_counter_3                  (fe_counter_3[k][7:0]),  
         .fe_counter_4                  (fe_counter_4[k][7:0]),  
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .fe_char_in                    (ibc_data_tlv_tdata),    
         .fe_char_vbytes                (ibc_data_vbytes),       
         .fe_blk_sel                    (ibc_blk_sel),           
         .ibc_ctr_reload                (ibc_ctr_reload),        
         .fe_config_1                   (fe_config[k]),          
         .fe_config_2                   (fe_config[k + 64]),     
         .fe_config_3                   (fe_config[k + 128]),    
         .fe_config_4                   (fe_config[k + 192]));   
    end 
  endgenerate
        
endmodule 











