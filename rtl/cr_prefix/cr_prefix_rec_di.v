/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
















`include "crPKG.svp"
`include "cr_prefix.vh"

module cr_prefix_rec_di 
  (
  
  rec_di_coeff, rec_di_neuron, rec_di_neuron_sign, rec_di_lr0,
  rec_di_lr1, rec_di_ip0, rec_di_ip1, rec_di_datareg, rec_di_rx,
  
  clk, rst_n, fe_ctr_1_ib, fe_ctr_2_ib, fe_ctr_3_ib, fe_ctr_4_ib,
  rec_sat_dout, rec_ct_dout, rec_us_fe_rd, rec_us_halt, rec_us_hold,
  rec_us_run, rec_us_step, rec_us_break, rec_us_x2break, rec_us_iprst,
  rec_us_ir1_opcode, rec_us_ir2_opcode, rec_us_drsel,
  rec_us_ld_lr0, rec_us_ld_lr1, rec_act_result
  );
            
`include "cr_structs.sv"
      
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;

  
  
  
  input                                   clk;
  input                                   rst_n; 

  
  
  
  input logic [511:0]                     fe_ctr_1_ib;
  input logic [511:0]                     fe_ctr_2_ib;
  input logic [511:0]                     fe_ctr_3_ib;
  input logic [511:0]                     fe_ctr_4_ib;
  
  
  
  
  
  
  input [895:0]                           rec_sat_dout;
      
  
  
  
  input rec_ct_t                          rec_ct_dout;
    
  
  
  
  input logic                             rec_us_fe_rd;
  input logic                             rec_us_halt;
  input logic                             rec_us_hold;
  input logic                             rec_us_run;
  input logic                             rec_us_step;
  input logic                             rec_us_break;
  input logic                             rec_us_x2break;
  
  input logic                             rec_us_iprst;
  input opcode_e                          rec_us_ir1_opcode;
  input opcode_e                          rec_us_ir2_opcode;
 
  input logic [1:0]                       rec_us_drsel;
  
  input logic                             rec_us_ld_lr0; 
  input logic                             rec_us_ld_lr1;
                                       
  
  
  
  input logic [`PREFIX_NEURON_WIDTH-1:0]   rec_act_result[`N_PREFIX_NEURONS-1:0]; 
                                      
  
  
  

  output logic [`PREFIX_NEURON_WIDTH-1:0]  rec_di_coeff[`N_PREFIX_NEURONS-1:0]; 
  output logic [`PREFIX_NEURON_WIDTH-1:0]  rec_di_neuron[`N_PREFIX_NEURONS-1:0]; 
  output logic                             rec_di_neuron_sign;
  
  
  
  
  output logic [`PREFIX_NEURON_WIDTH-1:0]  rec_di_lr0[`N_PREFIX_NEURONS-1:0];
  output logic [`PREFIX_NEURON_WIDTH-1:0]  rec_di_lr1[`N_PREFIX_NEURONS-1:0];
  output logic [`PREFIX_NEURON_WIDTH-1:0]  rec_di_ip0[`N_PREFIX_NEURONS-1:0];
  output logic [`PREFIX_NEURON_WIDTH-1:0]  rec_di_ip1[`N_PREFIX_NEURONS-1:0];
  
  output logic [`PREFIX_NEURON_WIDTH-1:0]  rec_di_datareg[`N_PREFIX_NEURONS-1:0];
  output logic [`PREFIX_NEURON_WIDTH-2:0]  rec_di_rx[`N_PREFIX_NEURONS-1:0];

  
  
  logic [`PREFIX_NEURON_WIDTH-1:0]        rec_di_ip0_in[`N_PREFIX_NEURONS-1:0];
  logic [`PREFIX_NEURON_WIDTH-1:0]        rec_di_ip1_in[`N_PREFIX_NEURONS-1:0];
  
  logic [`PREFIX_NEURON_WIDTH-2:0]        rec_di_rx_in[`N_PREFIX_NEURONS-1:0];
  logic [`PREFIX_NEURON_WIDTH-1:0]        rec_di_coeff_in[`N_PREFIX_NEURONS-1:0]; 
  logic [`PREFIX_NEURON_WIDTH-1:0]        rec_di_neuron_in[`N_PREFIX_NEURONS-1:0]; 
  
  
  logic                                   rec_di_datareg_sign ;
  logic                                   rec_di_hold_dly;
  logic [`PREFIX_NEURON_WIDTH-2:0]        rec_di_rx_hold[`N_PREFIX_NEURONS-1:0];
  logic [`PREFIX_NEURON_WIDTH-1:0]        rec_di_coeff_hold[`N_PREFIX_NEURONS-1:0];
  

  

  
  

  
  genvar               i;
  generate
    for(i=0;i<`N_PREFIX_NEURONS/2;i=i+1) begin
      assign rec_di_ip0_in[i]      = fe_ctr_1_ib[((i*8)+7):(i*8)];
      assign rec_di_ip1_in[i]      = fe_ctr_3_ib[((i*8)+7):(i*8)];
    end
    for(i=0;i<`N_PREFIX_NEURONS/2;i=i+1) begin
      assign rec_di_ip0_in[i+64]   = fe_ctr_2_ib[((i*8)+7):(i*8)];
      assign rec_di_ip1_in[i+64]   = fe_ctr_4_ib[((i*8)+7):(i*8)];
    end
  endgenerate
  
  genvar               j;
  generate
    for(j=0;j<`N_PREFIX_NEURONS;j=j+1) begin
      assign rec_di_rx_in[j]     = rec_sat_dout[(j*7)+6:(j*7)];
      assign rec_di_coeff_in[j]  = rec_ct_dout[(j*8)+7:(j*8)];
    end
  endgenerate
  integer k;
  
  always_comb begin
    for(k=0;k<`N_PREFIX_NEURONS;k=k+1) begin
      rec_di_neuron_in[k] = rec_di_datareg[rec_di_rx[k][`PREFIX_NEURON_WIDTH-2:0]];
    end
  end
  
         
  
  
  
  
  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      rec_di_lr0 <= '{default:0};  
      rec_di_lr1 <= '{default:0};  
      rec_di_ip0 <= '{default:0}; 
      rec_di_ip1 <= '{default:0}; 
      
      rec_di_rx <= '{default:0};
      rec_di_datareg <= '{default:0};

      rec_di_coeff <= '{default:0};
      rec_di_neuron <= '{default:0};
        
      rec_di_datareg_sign <= 1'b0;
      rec_di_neuron_sign  <= 1'b0;

      rec_di_hold_dly <= 1'b0;
      rec_di_coeff_hold <= '{default:0};
      rec_di_rx_hold <= '{default:0};
      
      
    end
    else begin
      rec_di_hold_dly <= rec_us_hold;

      if(rec_us_x2break) begin
        rec_di_coeff_hold <= rec_di_coeff_in;
        rec_di_rx_hold <= rec_di_rx_in;
      end
      
      
      
      
      
      if(rec_us_ld_lr0) begin
        rec_di_lr0 <= rec_act_result;
      end
      else if(rec_us_halt) begin
        rec_di_lr0 <= '{default:0};
      end
        
      
      if(rec_us_ld_lr1) begin
        rec_di_lr1 <= rec_act_result;
      end
      else if(rec_us_halt) begin
        rec_di_lr1 <= '{default:0};
      end
      
      
      if(rec_us_fe_rd) begin
        rec_di_ip0 <= rec_di_ip0_in;
      end
      else if(rec_us_iprst) begin
        rec_di_ip0 <= '{default:0};
      end
     
      
      if(rec_us_fe_rd) begin
        rec_di_ip1 <= rec_di_ip1_in;
      end
      else if(rec_us_iprst) begin
        rec_di_ip1 <= '{default:0};
      end

      if(~rec_us_hold) begin    
        
        
        
      
        
        if(rec_us_ir1_opcode==HALT) begin
          rec_di_rx <= '{default:0};
        end
        else if(rec_di_hold_dly) begin
          rec_di_rx <= rec_di_rx_hold;
        end
        else begin
          rec_di_rx <= rec_di_rx_in;
        end
        
        rec_di_datareg_sign <= rec_us_drsel[1];
        
        
        case(rec_us_drsel)
          2'b00: rec_di_datareg <= rec_di_ip0;
          2'b01: rec_di_datareg <= rec_di_ip1;
          2'b10: rec_di_datareg <= rec_di_lr0;
          2'b11: rec_di_datareg <= rec_di_lr1;
        endcase
     
        
        
        


        
        if(rec_us_ir2_opcode==HALT) begin
          rec_di_coeff <= '{default:0};
        end
        else if(rec_us_step) begin
          rec_di_coeff <= rec_di_coeff_hold;
        end
        
        else begin
          rec_di_coeff <= rec_di_coeff_in;
        end
        

        
        rec_di_neuron <= rec_di_neuron_in;
        rec_di_neuron_sign <= rec_di_datareg_sign;
      end 
    end 
  end 
          
endmodule 










