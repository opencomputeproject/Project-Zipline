/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

















`include "crPKG.svp"
`include "cr_prefix.vh"

module cr_prefix_fe_ctr 
  (
  
  fe_ctr_1k, fe_ctr_2k, fe_ctr_3k, fe_ctr_4k, fe_prior_out,
  
  clk, rst_n, fe_config, fe_prior_in, fe_ctlr_eodb, fe_sel_1k,
  fe_char_in, fe_char_vbytes
  );
            
`include "cr_structs.sv"
      
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;

 
 
 
  input              clk;
  input              rst_n; 
        
 
 
 
  input feature_t    fe_config[3:0];
        
 
 
 
  input [7:0]        fe_prior_in;
  input logic        fe_ctlr_eodb;
  input [1:0]        fe_sel_1k;
  input [63:0]       fe_char_in;
  input [7:0]        fe_char_vbytes;
    
 
 
 
  output logic [7:0] fe_ctr_1k;   
  output logic [7:0] fe_ctr_2k;
  output logic [7:0] fe_ctr_3k;
  output logic [7:0] fe_ctr_4k;
  output logic [7:0] fe_prior_out;

  
   
  
  feature_t          fe_config_mx;
  
  logic [7:0]        fe_char_match;
  logic [3:0]        fe_ctr_match_sum;
  logic [7:0]        fe_ctr_out; 
  
  
  always @(*) begin
    case (fe_sel_1k)
      000: fe_config_mx = fe_config[0];
      001: fe_config_mx = fe_config[1];
      010: fe_config_mx = fe_config[2];
      default: fe_config_mx = fe_config[3];
    endcase 
  end

  
  
  
  
  genvar            i;
  generate 
    for(i=0;i<8;i=i+1) begin
      assign fe_prior_out[i] = fe_char_match[i];
      
      cr_prefix_fe_char u_cr_prefix_fe_char_i
        (
        
         
         .fe_char_match                 (fe_char_match[i]),      
         
         .clk                           (clk),                   
         .rst_n                         (rst_n),                 
         .fe_config                     (fe_config_mx),          
         .fe_prior_in                   (fe_prior_in[i]),        
         .fe_char_in                    (fe_char_in[(i*8)+7:i*8]), 
         .fe_char_valid                 (fe_char_vbytes[i]));    
    end 
  endgenerate

  
  
  assign fe_ctr_match_sum = fe_char_match[7] +
                            fe_char_match[6] +
                            fe_char_match[5] +
                            fe_char_match[4] +
                            fe_char_match[3] +
                            fe_char_match[2] +
                            fe_char_match[1] +
                            fe_char_match[0];
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      fe_ctr_out <= 8'd0;
      fe_ctr_1k <= 8'd0;
      fe_ctr_2k <= 8'd0;
      fe_ctr_3k <= 8'd0;
      fe_ctr_4k <= 8'd0;
      end
    else begin
      if(fe_ctlr_eodb) begin
        fe_ctr_out <= 8'd0;
        case (fe_sel_1k) 
          000:     fe_ctr_1k <= fe_ctr_out;
          001:     fe_ctr_2k <= fe_ctr_out;
          010:     fe_ctr_3k <= fe_ctr_out;
          default: fe_ctr_4k <= fe_ctr_out;
        endcase 
      end
      else if(fe_ctr_out != 8'hff) begin
       fe_ctr_out <= fe_ctr_out + fe_ctr_match_sum;
      end
 
    end 
  end
  
endmodule 










