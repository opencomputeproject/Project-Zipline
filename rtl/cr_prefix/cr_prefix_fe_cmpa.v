/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

















`include "crPKG.svp"
`include "cr_prefix.vh"
module cr_prefix_fe_cmpa 
  (
  
  cmp_r, char_valid_r,
  
  clk, rst_n, char_in, char_valid, match_val, cmp_type
  );
  
`include "cr_structs.sv"
      
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;
 

  
  
  
  input              clk;
  input              rst_n; 
 
  
  
  
  input [7:0]        char_in;
  input              char_valid;

  
  
  
  input [7:0]        match_val ;
  input [1:0]        cmp_type ;
                                       
                                    
  
  
  
  output logic       cmp_r;
  output logic       char_valid_r;
  
  
  
  

  logic              cmp;
   
  logic              eq;
  logic              gt;
  
  prefix_compare_type_e              cmp_type_e;
  
  assign  cmp_type_e = prefix_compare_type_e'(cmp_type);
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  
  
  
  assign eq = (char_in == match_val) & char_valid;
  assign gt = (char_in >  match_val) & char_valid;
   
  
  
  
  
  
  
  

  always_comb begin
    case (cmp_type_e)
      EQ: begin 
        cmp = eq;
      end
      GTEQ: begin 
        cmp = gt | eq;
      end
      LT: begin 
        cmp = ~gt & ~eq;
      end
      EQOP: begin 
       cmp = eq;
      end
    endcase 
  end 


  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      cmp_r <= 1'b0;
      char_valid_r <= 1'b0;
    end
    else begin
      cmp_r <= cmp;
      char_valid_r <= char_valid;
   end
  end

endmodule 









