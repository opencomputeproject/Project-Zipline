/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

















`include "crPKG.svp"
`include "cr_prefix.vh"
module cr_prefix_fe_cmp 
  (
  
  prior_out,
  
  clk, rst_n, prior_in, prior_in_no_delay, char_in, char_valid,
  use_prior, no_delay, match_val, cmp_type
  );
`include "cr_structs.sv"
      
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;
 

  
  
  
  input              clk;
  input              rst_n; 
 
  
  
  
  input              prior_in;
  input              prior_in_no_delay;
  input [7:0]        char_in;
  input              char_valid;

  
  
  
  input              use_prior;
  input              no_delay;
  input [7:0]        match_val ;
  input [1:0]        cmp_type ;
                                       
                                    
  
  
  
  output logic       prior_out;
  
  
  

  logic              cmp_r;
   
  logic              char_valid_r;
  logic              prior_in_mx;
  logic              prior_mx;
  logic              prior_or_cmp;
  logic              prior_and_cmp;
  
  prefix_compare_type_e              cmp_type_e;
  
  assign  cmp_type_e = prefix_compare_type_e'(cmp_type);
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  

  always_comb begin
    prior_in_mx = no_delay ? prior_in_no_delay : prior_in;
    prior_or_cmp  = prior_in_mx | cmp_r;
    prior_and_cmp = prior_in_mx & cmp_r;
    prior_mx  = (cmp_type_e == EQOP) ? prior_or_cmp : prior_and_cmp;
    
    if (use_prior) begin
      prior_out = prior_mx & char_valid_r;
    end
    else   begin
      prior_out = cmp_r & char_valid_r; 
    end
    
  end 
  
  

   cr_prefix_fe_cmpa u_cr_prefix_fe_cmpa 
     (
      
      .cmp_r                            (cmp_r),                 
      .char_valid_r                     (char_valid_r),          
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .char_in                          (char_in[7:0]),
      .char_valid                       (char_valid),
      .match_val                        (match_val),             
      .cmp_type                         (cmp_type));             
  

endmodule 









