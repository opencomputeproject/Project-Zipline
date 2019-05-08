/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


















`include "crPKG.svp"
`include "cr_prefix.vh"

module cr_prefix_fe_grp 
  (
  
  fe_ctr_1k, fe_ctr_2k, fe_ctr_3k, fe_ctr_4k,
  
  clk, rst_n, fe_config, fe_ctlr_eodb, fe_sel_1k, fe_char_in,
  fe_char_vbytes
  );
            
`include "cr_structs.sv"
      
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;

 
 
 
  input                clk;
  input                rst_n; 
        
 
 
 
  input                feature_t fe_config[63:0];
        
 
 
 
  input logic          fe_ctlr_eodb;
  input [1:0]          fe_sel_1k;
  input [63:0]         fe_char_in;
  input [7:0]          fe_char_vbytes;
  
 
 
 
  output logic [127:0] fe_ctr_1k; 
  output logic [127:0] fe_ctr_2k; 
  output logic [127:0] fe_ctr_3k; 
  output logic [127:0] fe_ctr_4k;

  
  logic [7:0]          fe_prior_in[3:0];
  
  
  logic [7:0]          fe_prior_out[3:0];
  

  genvar               j;
  
  
  

  assign fe_prior_in[0]  = 8'd0;
  generate
    for(j=1;j<16;j=j+1) begin
      assign fe_prior_in[j]  = {fe_prior_out[j-1][6:0], fe_prior_out[j-1][7]};
    end
  endgenerate
  
  
 
  
  
  
  
  
  genvar                  i;
  generate 
    for(i=0;i<16;i=i+1) begin
      
      cr_prefix_fe_ctr u_cr_prefix_fe_ctr_i
        (
         
         
         .fe_ctr_1k                     (fe_ctr_1k[(i*8)+7:i*8]), 
         .fe_ctr_2k                     (fe_ctr_2k[(i*8)+7:i*8]), 
         .fe_ctr_3k                     (fe_ctr_3k[(i*8)+7:i*8]), 
         .fe_ctr_4k                     (fe_ctr_4k[(i*8)+7:i*8]), 
         .fe_prior_out                  (fe_prior_out[i]),       
         
         .clk                           (clk),                   
         .rst_n                         (rst_n),                 
         .fe_config                     (fe_config[(i*4)+3:(i*4)]), 
         .fe_prior_in                   (fe_prior_in[i]),        
         .fe_ctlr_eodb                  (fe_ctlr_eodb),
         .fe_sel_1k                     (fe_sel_1k),             
         .fe_char_in                    (fe_char_in),            
         .fe_char_vbytes                (fe_char_vbytes));       
      end 
  endgenerate



 
endmodule 











