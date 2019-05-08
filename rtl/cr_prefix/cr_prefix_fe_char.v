/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

















`include "crPKG.svp"
`include "cr_prefix.vh"

module cr_prefix_fe_char 
  (
  
  fe_char_match,
  
  clk, rst_n, fe_config, fe_prior_in, fe_char_in, fe_char_valid
  );
            
`include "cr_structs.sv"
      
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;

  
  
  
  input            clk;
  input            rst_n; 
        
  
  
  
  input  feature_t fe_config;
       
  
  
  
  input            fe_prior_in;
  input [7:0]      fe_char_in;
  input            fe_char_valid;
    
  
  
  
  output logic     fe_char_match;

  
  
  
    
  logic            eq;
  logic            gt;
  logic            fe_char_cmp;
  
  assign fe_char_match = fe_char_cmp & ~(fe_config.use_prior & ~fe_prior_in);
 
  assign eq = (fe_char_in == fe_config.match_val);
  assign gt = (fe_char_in >  fe_config.match_val);
  

  
  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        fe_char_cmp = 1'b0;
    end
    else begin
      if(fe_char_valid) begin
        case (fe_config.cmp_type)
          00: begin 
            fe_char_cmp <= ~gt;
          end
          01: begin 
            fe_char_cmp <= ~gt & eq;
          end
          10: begin 
            fe_char_cmp <= gt & ~eq;
          end
          default: begin 
            fe_char_cmp <= gt | eq;
          end
        endcase 
      end 
      else begin
        fe_char_cmp = 1'b0;
      end 
   end
  end

endmodule 










