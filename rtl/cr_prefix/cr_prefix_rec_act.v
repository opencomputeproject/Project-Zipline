/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


















`include "crPKG.svp"
`include "cr_prefix.vh"

module cr_prefix_rec_act 
  (
  
  rec_act_result,
  
  clk, rst_n, rec_us_hold, rec_us_ir4_opcode,
  rec_us_ir4_src1, rec_us_neuron_en4, rec_alu_acc
  );
            
`include "cr_structs.sv"
      
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;

  
  
  
  input                                   clk;
  input                                   rst_n; 
 
  
  
  
  input                                   rec_us_hold;
  input opcode_e                          rec_us_ir4_opcode;
  input [7:0]                             rec_us_ir4_src1;
  input                                   rec_us_neuron_en4;
                                       
  
  
  
  input logic signed [`PREFIX_ACC_WIDTH-1:0]     rec_alu_acc;
 
  
  
  
  output logic [`PREFIX_NEURON_WIDTH-1:0] rec_act_result;  

  

  

  logic signed [11:0]           rec_act_shiftsat12;
  logic signed [7:0]            rec_act_shiftsat8;
  logic [11:0]                  rec_act_abs;
  logic [7:0]                   rec_act_relu;
  logic [7:0]                   rec_act_sigmoid_result;
  logic [7:0]                   rec_act_sigmoid;
  
  

  
  
  
  
  function signed [11:0] ShiftSat12;
    input signed [19:0]                  alu_acc;
    input [3:0]                          shift_by;
    logic signed [19:0]                  shifted;
    
    begin:ss12
      shifted = alu_acc >>> shift_by; 
      
      if(shifted[19]) begin
        ShiftSat12 = ~&shifted[18:11] ? 12'h800 : shifted[11:0] ;
      end
      
      else begin
        ShiftSat12 = |shifted[18:11] ? 12'h7ff : shifted[11:0];
      end
    end
  endfunction 
           
  
  
  
  function signed [7:0] ShiftSat8;
    input signed [19:0]                alu_acc;
    input [3:0]                        shift_by;
    logic signed [19:0]                shifted;
    
    begin:ss8
      shifted = alu_acc >>> shift_by; 
      
      if(alu_acc[19]) begin
        ShiftSat8 = ~&shifted[18:7] ? 8'h80 : shifted[7:0] ;
      end
      
      else begin
        ShiftSat8 = |shifted[18:7] ? 8'h7f : shifted[7:0];
      end
    end 
  endfunction 
         
  
  
  
  function logic [7:0] RELU_ACT;
    input signed [7:0] alu_acc;

    begin:relu_func                       
      if (alu_acc < 0) begin
        RELU_ACT = 8'd0;
      end
      else begin
        RELU_ACT = alu_acc[7:0];
      end
    end
  endfunction
      
  
  
  
  function logic [7:0] SIGMOID_ACT;
    input [11:0] abs_value;

    begin:sigmoid_func
      
      if(abs_value < 32) begin
        SIGMOID_ACT = abs_value[7:0];
      end
      else if(abs_value < 64) begin
        SIGMOID_ACT = abs_value[8:1] + 8'h10;
      end
      else if(abs_value < 128) begin
        SIGMOID_ACT = abs_value[9:2] + 8'h20;
      end
      else if(abs_value < 256) begin
        SIGMOID_ACT = abs_value[10:3] + 8'h30;
      end
      else if(abs_value < 512) begin
        SIGMOID_ACT = abs_value[11:4] + 8'h40;
      end
      else if(abs_value < 1024) begin
        SIGMOID_ACT = {1'b0,abs_value[11:5]} + 8'h50;
      end
      else begin
        SIGMOID_ACT = {2'b00,abs_value[11:6]} + 8'h60;
      end
    end 
  endfunction 

          
  always_comb begin  
    rec_act_shiftsat8  = ShiftSat8(rec_alu_acc,rec_us_ir4_src1); 
    rec_act_relu       = RELU_ACT(rec_act_shiftsat8);
    
    rec_act_shiftsat12 = ShiftSat12(rec_alu_acc,rec_us_ir4_src1);
    rec_act_abs = rec_act_shiftsat12[11] ? (~rec_act_shiftsat12[11:0] + 1'b1): rec_act_shiftsat12[11:0];
    rec_act_sigmoid_result = SIGMOID_ACT(rec_act_abs) ;
    rec_act_sigmoid = rec_act_shiftsat12[11] ? (~rec_act_sigmoid_result[7:0] + 1'b1):rec_act_sigmoid_result[7:0];
  end
  
         
  
  
  
  
  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      rec_act_result <= '{default:0};
    end
    else begin
      if(~rec_us_hold) begin
        if(~rec_us_neuron_en4) begin
          rec_act_result <= '{default:0};
        end
        else begin
          
          
          
          if(rec_us_ir4_opcode ==HALT) begin
            rec_act_result <= '{default:0};
          end
          else if((rec_us_ir4_opcode == RELUS) || (rec_us_ir4_opcode == RELUP)) begin
            rec_act_result<= rec_act_relu;
          end
          else if ((rec_us_ir4_opcode == SIGMOIDS) || (rec_us_ir4_opcode == SIGMOIDP)) begin
            rec_act_result<= rec_act_sigmoid;
          end
        end 
      end 
    end 
  end 
  

  
  
  

  wire relu_instr, sigmoid_instr;

  assign relu_instr = (rec_us_ir4_opcode == RELUP) ? 1'b1 : 1'b0;
  assign sigmoid_instr = (rec_us_ir4_opcode == SIGMOIDP) ? 1'b1 : 1'b0;
//synopsys translate_off
  covergroup cov_relu_act_grp @(posedge relu_instr);    
    cov_acc_result: coverpoint rec_alu_acc{
      bins MIN = {-524288};
      bins MID = {[-524287:524286]};
      bins MAX = {524287}; 
    }
    
    cov_shift_cnt: coverpoint rec_us_ir4_src1{
       bins MIN = {0};
       bins MID = {[1:7]};
       bins MAX = {8};
       bins other = default;
     }    
    
    cov_shift_cnt_w_acc: cross cov_shift_cnt, cov_acc_result;
  endgroup 

  covergroup cov_sigmoid_act_grp @(posedge sigmoid_instr);    
    cov_acc_result: coverpoint rec_alu_acc {
      bins MIN = {-524288};
      bins MID = {[-524287:524286]};
      bins MAX = {524287}; 
    }
    
    cov_shift_cnt: coverpoint rec_us_ir4_src1{
       bins MIN = {0};
       bins MID = {[1:7]};
       bins MAX = {8};
       bins other = default;
     }    
    
    cov_shift_cnt_w_acc: cross cov_shift_cnt, cov_acc_result;
  endgroup

   
  cov_relu_act_grp cov_relu_act_grp_inst = new();
  cov_sigmoid_act_grp cov_sigmoid_act_grp_inst = new();
   
//synopsys translate_on
  
  
  
        
endmodule 










