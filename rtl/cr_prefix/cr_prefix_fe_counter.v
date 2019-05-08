/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

















`include "crPKG.svp"
`include "cr_prefix.vh"

module cr_prefix_fe_counter
  (
  
  fe_counter_1, fe_counter_2, fe_counter_3, fe_counter_4,
  
  clk, rst_n, fe_char_in, fe_char_vbytes, fe_blk_sel, ibc_ctr_reload,
  fe_config_1, fe_config_2, fe_config_3, fe_config_4
  );
             
`include "cr_structs.sv"
      
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;

  
  
  
  input               clk;
  input               rst_n; 
 
  
  
  
  input [63:0]        fe_char_in;
  input [7:0]         fe_char_vbytes;
  input [1:0]         fe_blk_sel;
  input logic         ibc_ctr_reload;

  
  
  
  input  feature_t    fe_config_1;
  input  feature_t    fe_config_2;
  input  feature_t    fe_config_3;
  input  feature_t    fe_config_4;
  
                                    
  
  
  
  output logic [7:0] fe_counter_1;
  output logic [7:0] fe_counter_2;
  output logic [7:0] fe_counter_3;
  output logic [7:0] fe_counter_4;
  
  
  
  feature_t          fe_config_mx;  
  logic [3:0]        fe_counter_match_sum;
  logic [8:0]        fe_counter_out;
  
  logic [7:0]        prior_in_a;
  logic [7:0]        prior_in_b;
  logic [7:0]        prior_in_c;
  logic [7:0]        prior_in_d;
   
  logic [7:0]        prior_out_a;
  logic [7:0]        prior_out_b;
  logic [7:0]        prior_out_c;
  logic [7:0]        prior_out_d;

  logic              prior_out_a_7_delay;
  logic              prior_out_b_7_delay;
  logic              prior_out_c_7_delay;
  logic              fe_char_valid0_r;
  
  logic [8:0]        wd_counter;
  
 
  
  assign prior_in_a[0] = 8'd0;
  assign prior_in_b[0] = prior_out_a_7_delay;
  assign prior_in_c[0] = prior_out_b_7_delay;
  assign prior_in_d[0] = prior_out_c_7_delay;
  
  assign prior_in_a[1] = 8'd0;
  assign prior_in_b[1] = prior_out_a[0];
  assign prior_in_c[1] = prior_out_b[0];
  assign prior_in_d[1] = prior_out_c[0];
  
  
  assign prior_in_a[2] = 8'd0;
  assign prior_in_b[2] = prior_out_a[1];
  assign prior_in_c[2] = prior_out_b[1];
  assign prior_in_d[2] = prior_out_c[1];
  
  
  assign prior_in_a[3] = 8'd0;
  assign prior_in_b[3] = prior_out_a[2];
  assign prior_in_c[3] = prior_out_b[2];
  assign prior_in_d[3] = prior_out_c[2];
  
  
  assign prior_in_a[4] = 8'd0;
  assign prior_in_b[4] = prior_out_a[3];
  assign prior_in_c[4] = prior_out_b[3];
  assign prior_in_d[4] = prior_out_c[3];

  
  assign prior_in_a[5] = 8'd0;
  assign prior_in_b[5] = prior_out_a[4];
  assign prior_in_c[5] = prior_out_b[4];
  assign prior_in_d[5] = prior_out_c[4];

  
  assign prior_in_a[6] = 8'd0;
  assign prior_in_b[6] = prior_out_a[5];
  assign prior_in_c[6] = prior_out_b[5];
  assign prior_in_d[6] = prior_out_c[5];

  
  assign prior_in_a[7] = 8'd0;
  assign prior_in_b[7] = prior_out_a[6];
  assign prior_in_c[7] = prior_out_b[6];
  assign prior_in_d[7] = prior_out_c[6];

  
  
  
  
  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      prior_out_a_7_delay <= 1'b0;
      prior_out_b_7_delay <= 1'b0;
      prior_out_c_7_delay <= 1'b0;
      fe_char_valid0_r <= 1'b0;
    end
    else begin
      fe_char_valid0_r <= fe_char_vbytes[0];
      
      if(ibc_ctr_reload) begin
        prior_out_a_7_delay <= 1'b0;
        prior_out_b_7_delay <= 1'b0;
        prior_out_c_7_delay <= 1'b0;
      end
      
      else if(fe_char_valid0_r) begin
        prior_out_a_7_delay <= prior_out_a[7];
        prior_out_b_7_delay <= prior_out_b[7];
        prior_out_c_7_delay <= prior_out_c[7];
      end
    end
  end 
  
 
  
  
  
  always @(*) begin
    case (fe_blk_sel)
      2'b00: fe_config_mx = fe_config_1;
      2'b01: fe_config_mx = fe_config_2;
      2'b10: fe_config_mx = fe_config_3;
      default: fe_config_mx = fe_config_4;
    endcase 
  end


  
  
  
  
  
  
  genvar            i;
  generate 
    for(i=0;i<8;i=i+1) begin:fe_cmpx4
       cr_prefix_fe_cmpx4 u_fe_cmpx4_i 
        (
         
         .prior_out_a                   (prior_out_a[i]),        
         .prior_out_b                   (prior_out_b[i]),        
         .prior_out_c                   (prior_out_c[i]),        
         .prior_out_d                   (prior_out_d[i]),        
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .prior_in_a                    (prior_in_a[i]),         
         .prior_in_b                    (prior_in_b[i]),         
         .prior_in_c                    (prior_in_c[i]),         
         .prior_in_d                    (prior_in_d[i]),         
         .char_in                       (fe_char_in[(i*8)+7:i*8]), 
         .char_valid                    (fe_char_vbytes[i]),     
         .use_prior_a                   (fe_config_mx.use_prior_a), 
         .no_delay_a                    (fe_config_mx.no_delay_a), 
         .match_val_a                   (fe_config_mx.match_val_a), 
         .cmp_type_a                    (fe_config_mx.cmp_type_a), 
         .use_prior_b                   (fe_config_mx.use_prior_b), 
         .no_delay_b                    (fe_config_mx.no_delay_b), 
         .match_val_b                   (fe_config_mx.match_val_b), 
         .cmp_type_b                    (fe_config_mx.cmp_type_b), 
         .use_prior_c                   (fe_config_mx.use_prior_c), 
         .no_delay_c                    (fe_config_mx.no_delay_c), 
         .match_val_c                   (fe_config_mx.match_val_c), 
         .cmp_type_c                    (fe_config_mx.cmp_type_c), 
         .use_prior_d                   (fe_config_mx.use_prior_d), 
         .no_delay_d                    (fe_config_mx.no_delay_d), 
         .match_val_d                   (fe_config_mx.match_val_d), 
         .cmp_type_d                    (fe_config_mx.cmp_type_d)); 
    end 
  endgenerate
  
  
  
  assign fe_counter_match_sum = prior_out_d[7] +
                            prior_out_d[6] +
                            prior_out_d[5] +
                            prior_out_d[4] +
                            prior_out_d[3] +
                            prior_out_d[2] +
                            prior_out_d[1] +
                            prior_out_d[0];
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      fe_counter_out <= 9'd0;
      fe_counter_1 <= 8'd0;
      fe_counter_2 <= 8'd0;
      fe_counter_3 <= 8'd0;
      fe_counter_4 <= 8'd0;
      wd_counter <= 9'd0;
      
      end
    else begin
      if(ibc_ctr_reload) begin
        fe_counter_out <= 8'd0;
        
        if(fe_counter_out[8]) begin  
          case (fe_blk_sel) 
            2'b00:begin
               fe_counter_1 <= 8'hff;
               fe_counter_2 <= 8'd0;
               fe_counter_3 <= 8'd0;
               fe_counter_4 <= 8'd0;
            end
            2'b01:   fe_counter_2 <= 8'hff;
            2'b10:   fe_counter_3 <= 8'hff;
            default: fe_counter_4 <= 8'hff;
          endcase 
        end
        else begin   
          case (fe_blk_sel) 
            2'b00:begin
               fe_counter_1 <= fe_counter_out[7:0];
               fe_counter_2 <= 8'd0;
               fe_counter_3 <= 8'd0;
               fe_counter_4 <= 8'd0;
            end
            2'b01:     fe_counter_2 <= fe_counter_out[7:0];
            2'b10:     fe_counter_3 <= fe_counter_out[7:0];
            default:   fe_counter_4 <= fe_counter_out[7:0];
          endcase 
        end
      end
      else if(~fe_counter_out[8]) begin
       fe_counter_out <= fe_counter_out[7:0] + fe_counter_match_sum;
      end
      
      if(ibc_ctr_reload) begin
        wd_counter <= 8'd0;
      end
      else if(~wd_counter[8])begin
        wd_counter <= wd_counter [7:0]+ (|fe_char_vbytes);
      end
      
 
    end 
  end 
 

  
//synopsys translate_off
  covergroup cov_prefix_feature_ctr_grp @(posedge clk);
    cov_feature_ctr: coverpoint fe_counter_match_sum{
      bins ZERO = {0};
      bins MID[] = {[1:7]};
      bins MAX = {8};
    }
  endgroup 

  cov_prefix_feature_ctr_grp cov_prefix_feature_ctr_grp_inst = new();
//synopsys translate_on   
  

endmodule 










