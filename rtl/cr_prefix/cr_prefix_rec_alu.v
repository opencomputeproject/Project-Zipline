/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


















`include "crPKG.svp"
`include "cr_prefix.vh"

module cr_prefix_rec_alu 
  (
  
  rec_alu_acc,
  
  clk, rst_n, rec_us_hold, rec_us_ir3_opcode,
  rec_us_neuron_en3, rec_di_coeff, rec_di_neuron, rec_di_neuron_sign
  );
            
`include "cr_structs.sv"
      
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;

  
  
  
  input                                  clk;
  input                                  rst_n; 
 
  
  
  
  input                                  rec_us_hold;
  input opcode_e                         rec_us_ir3_opcode;
  input                                  rec_us_neuron_en3;
                                       
  
  
  
  output logic signed [`PREFIX_ACC_WIDTH-1:0]   rec_alu_acc;
                                      
  
  
  
  input logic [`PREFIX_NEURON_WIDTH-1:0] rec_di_coeff; 
  input logic [`PREFIX_NEURON_WIDTH-1:0] rec_di_neuron;
  input logic                            rec_di_neuron_sign;
  

  
  
  logic signed [8:0]           rec_alu_opa;
  logic signed [8:0]           rec_alu_opb;
  logic signed [19:0]          rec_alu_mult;
  logic signed [20:0]          rec_alu_mac_raw;
  logic signed [19:0]          rec_alu_mac;

  
  

  
  always_comb begin
    
    rec_alu_opa = {{2{rec_di_coeff[7]}},rec_di_coeff[6:0]};
    
    if(rec_di_neuron_sign) begin
      rec_alu_opb = {{2{rec_di_neuron[7]}},rec_di_neuron[6:0]};
    end
    else begin
      rec_alu_opb = {1'b0,rec_di_neuron};
    end
    
   
    rec_alu_mult = rec_alu_opa * rec_alu_opb;
    rec_alu_mac_raw  =  rec_alu_mult + rec_alu_acc;
    
    
    if(rec_alu_mac_raw[20:19] == 2'b01) begin
      rec_alu_mac = 20'h7ffff;
    end
    else if(rec_alu_mac_raw[20:19] == 2'b10) begin
       rec_alu_mac = 20'h80000;
    end
    else begin
      rec_alu_mac = rec_alu_mac_raw[19:0];
    end
  end 
 

  
  
  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      rec_alu_acc <= '{default:0}; 
    end
    else begin
      if(~rec_us_hold) begin
        
        
        
        if(~rec_us_neuron_en3) begin
          rec_alu_acc <= '{default:0};
        end
        else begin
          case(rec_us_ir3_opcode)
            HALT: begin
              rec_alu_acc <= '{default:0};
            end
           
            
            LOAD: begin
              rec_alu_acc <= {{(`PREFIX_ACC_WIDTH-`PREFIX_NEURON_WIDTH+1){rec_di_coeff[7]}},rec_di_coeff[6:0]};
            end
        
            MAC: begin
              rec_alu_acc <= rec_alu_mac;
            end
          
            default: begin
              rec_alu_acc <= rec_alu_acc;
            end
          endcase 
        end 
      end 
    end 
  end 
  

  

  wire mac_instr;

  assign mac_instr = (rec_us_ir3_opcode == MAC) ? 1'b1 : 1'b0;
//synopsys translate_off
  covergroup cov_mac_result_grp @(negedge mac_instr);    
    cov_max_result: coverpoint rec_alu_acc{
      bins MIN = {-524288};
      bins MID = {[-524287:524286]};
      bins MAX = {524287}; 
    }
  endgroup 

  cov_mac_result_grp cov_mac_result_grp_inst = new();
//synopsys translate_on   
  
      
endmodule 










