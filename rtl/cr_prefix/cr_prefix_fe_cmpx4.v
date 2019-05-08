/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

















`include "crPKG.svp"
`include "cr_prefix.vh"

module cr_prefix_fe_cmpx4 
  (
  
  prior_out_a, prior_out_b, prior_out_c, prior_out_d,
  
  clk, rst_n, prior_in_a, prior_in_b, prior_in_c, prior_in_d, char_in,
  char_valid, use_prior_a, no_delay_a, match_val_a, cmp_type_a,
  use_prior_b, no_delay_b, match_val_b, cmp_type_b, use_prior_c,
  no_delay_c, match_val_c, cmp_type_c, use_prior_d, no_delay_d,
  match_val_d, cmp_type_d
  );
 
`include "cr_structs.sv"
      
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;

  
  
  
  input              clk;
  input              rst_n; 
 
  
  
  
  input              prior_in_a;
  input              prior_in_b;
  input              prior_in_c;
  input              prior_in_d;
  input [7:0]        char_in;
  input              char_valid;

  
  
  
  input              use_prior_a;
  input              no_delay_a;
  input [7:0]        match_val_a ;
  input [1:0]        cmp_type_a ;
  
  input              use_prior_b;
  input              no_delay_b;
  input [7:0]        match_val_b ;
  input [1:0]        cmp_type_b ;
  
  input              use_prior_c;
  input              no_delay_c;
  input [7:0]        match_val_c ;
  input [1:0]        cmp_type_c ;
  
  input              use_prior_d;
  input              no_delay_d;
  input [7:0]        match_val_d ;
  input [1:0]        cmp_type_d ;
   
                                    
  
  
  
  output logic       prior_out_a;
  output logic       prior_out_b;
  output logic       prior_out_c;
  output logic       prior_out_d;
  
  
  

  logic              prior_in_no_delay_a;
  logic              prior_in_no_delay_b;
  logic              prior_in_no_delay_c;
  logic              prior_in_no_delay_d;
  logic              a_char_r;
  logic              a_char_valid_r;
  
  
  

  
  assign prior_in_no_delay_a = 1'b0;
  assign prior_in_no_delay_b = prior_out_a;
  assign prior_in_no_delay_c = prior_out_b;
  assign prior_in_no_delay_d = prior_out_c;
  assign prior_out_a = a_char_r & a_char_valid_r;
  
  
  

   cr_prefix_fe_cmpa cr_prefix_fe_cmp_a 
     (
      
      .cmp_r                            (a_char_r),              
      .char_valid_r                     (a_char_valid_r),        
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .char_in                          (char_in[7:0]),
      .char_valid                       (char_valid),
      .match_val                        (match_val_a),           
      .cmp_type                         (cmp_type_a));           
 
  

   cr_prefix_fe_cmp cr_prefix_fe_cmp_b 
     (
      
      .prior_out                        (prior_out_b),           
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .prior_in                         (prior_in_b),            
      .prior_in_no_delay                (prior_in_no_delay_b),   
      .char_in                          (char_in[7:0]),
      .char_valid                       (char_valid),
      .use_prior                        (use_prior_b),           
      .no_delay                         (no_delay_a),            
      .match_val                        (match_val_b),           
      .cmp_type                         (cmp_type_b));           

  
  

   cr_prefix_fe_cmp cr_prefix_fe_cmp_c 
     (
      
      .prior_out                        (prior_out_c),           
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .prior_in                         (prior_in_c),            
      .prior_in_no_delay                (prior_in_no_delay_c),   
      .char_in                          (char_in[7:0]),
      .char_valid                       (char_valid),
      .use_prior                        (use_prior_c),           
      .no_delay                         (no_delay_b),            
      .match_val                        (match_val_c),           
      .cmp_type                         (cmp_type_c));           
  

  
  

   cr_prefix_fe_cmp cr_prefix_fe_cmp_d 
     (
      
      .prior_out                        (prior_out_d),           
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .prior_in                         (prior_in_d),            
      .prior_in_no_delay                (prior_in_no_delay_d),   
      .char_in                          (char_in[7:0]),
      .char_valid                       (char_valid),
      .use_prior                        (use_prior_d),           
      .no_delay                         (no_delay_c),            
      .match_val                        (match_val_d),           
      .cmp_type                         (cmp_type_d));           

   

   wire [2:0]        use_prior = {use_prior_b, use_prior_c, use_prior_d}; 
   wire [3:0]        no_delay = {no_delay_a, no_delay_b, no_delay_c, no_delay_d};

//synopsys translate_off
   covergroup cov_prefix_feature_config_grp @(posedge char_valid);
      cov_use_prior: coverpoint use_prior{
	 bins SET1 = {0,1};
	 bins SET2 = {2,3};
	 bins SET3 = {4,5};
	 bins SET4 = {6,7};
      } 
      cov_no_delay: coverpoint no_delay{
	 bins SET1 = {0,1,2,3};
	 bins SET2 = {4,5,6,7};
	 bins SET3 = {8,9,10,11};
	 bins SET4 = {12,13,14,15};
      }      
      cov_cmp_type_a: coverpoint cmp_type_a{
	 bins NORMAL_CMP_TYPE = {0,1,2};
	 bins EQUAL_OR_PASS_TYPE = {3};
      }
      cov_cmp_type_b: coverpoint cmp_type_b{
	 bins NORMAL_CMP_TYPE = {0,1,2};
	 bins EQUAL_OR_PASS_TYPE = {3};
      }
      cov_cmp_type_c: coverpoint cmp_type_c{
	 bins NORMAL_CMP_TYPE = {0,1,2};
	 bins EQUAL_OR_PASS_TYPE = {3};
      }
      cov_cmp_type_d: coverpoint cmp_type_d{
	 bins NORMAL_CMP_TYPE = {0,1,2};
	 bins EQUAL_OR_PASS_TYPE = {3};
      }      
      cov_match_val_a: coverpoint match_val_a;
      cov_match_val_b: coverpoint match_val_b; 
      cov_match_val_c: coverpoint match_val_c; 
      cov_match_val_d: coverpoint match_val_d; 

      
      CRS_FEATURE_CONFIG_A: cross cov_use_prior, cov_no_delay, cov_cmp_type_a;
      CRS_FEATURE_CONFIG_B: cross cov_use_prior, cov_no_delay, cov_cmp_type_b;
      CRS_FEATURE_CONFIG_C: cross cov_use_prior, cov_no_delay, cov_cmp_type_c;
      CRS_FEATURE_CONFIG_D: cross cov_use_prior, cov_no_delay, cov_cmp_type_d;

   endgroup 

   
   cov_prefix_feature_config_grp cov_prefix_feature_config_grp_inst = new();
//synopsys translate_on 

endmodule
    








