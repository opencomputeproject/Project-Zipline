/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/














module cr_axi4s_mstr_su
  
  (
  
  axi4s_mstr_rd, axi4s_ob_out,
  
  clk, rst_n, axi4s_in, axi4s_in_empty, axi4s_in_aempty, axi4s_ob_in
  );

`include "cr_structs.sv"
  
  
  
  
    
  
  
  
  
  
  
  
  input                         clk;
  input                         rst_n; 
    
  
  
  
  input  axi4s_su_dp_bus_t      axi4s_in;
  input                         axi4s_in_empty;
  input                         axi4s_in_aempty;
  output                        axi4s_mstr_rd;
  
  
  
  
  input  axi4s_dp_rdy_t         axi4s_ob_in;
  output axi4s_su_dp_bus_t      axi4s_ob_out;
  
  
  
  
  
  
  
  
  
  
  
  assign axi4s_mstr_rd = ~axi4s_in_empty & (~axi4s_ob_out.tvalid | (axi4s_ob_out.tvalid & axi4s_ob_in.tready));
 
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) 
      begin
        axi4s_ob_out <= '{default:0};
        
      end
    else 
      begin
        if(axi4s_mstr_rd) begin
          axi4s_ob_out <= axi4s_in;
        end
        
        
        
        else if(axi4s_ob_out.tvalid & axi4s_ob_in.tready) begin
          axi4s_ob_out <= '{default:0};
        end
      end
   end
  
 


endmodule












