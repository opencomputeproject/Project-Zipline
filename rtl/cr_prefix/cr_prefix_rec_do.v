/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
















`include "crPKG.svp"
`include "cr_prefix.vh"

module cr_prefix_rec_do 
  (
  
  rec_do_sort, rec_do_prefix,
  
  clk, rst_n, rec_us_hold, rec_us_threshold, rec_us_neuron_en5,
  rec_act_result
  );
            
`include "cr_structs.sv"
      
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;

  
  
  
  input                                    clk;
  input                                    rst_n; 
 
  
  
  
  input                                    rec_us_hold;
  input signed [7:0]                       rec_us_threshold;
                                      
  
  
  
  input [63:0]                            rec_us_neuron_en5;
                                         
  
  
  
  input logic [`PREFIX_NEURON_WIDTH-1:0]  rec_act_result[63:0]; 
                                          
  
  
  
  output logic [`PREFIX_NEURON_WIDTH-1:0] rec_do_sort[7:0];
                                
  
  
  
  output logic [5:0]                      rec_do_prefix;
  
  
  integer                                i;
  integer                                j;
  integer                                k;

                                                  
  
  
  typedef struct packed {
    logic [5:0] index;
    logic signed [7:0] value;
  } neuron_sort_t;
  

  
   
  neuron_sort_t rec_do_sort32_in[63:0];
  neuron_sort_t rec_do_sort16_in[31:0];
  neuron_sort_t rec_do_sort8_in[15:0];
  neuron_sort_t rec_do_sort4_in[7:0];
  neuron_sort_t rec_do_sort2_in[3:0];
  neuron_sort_t rec_do_sort1_in[1:0];
  
  neuron_sort_t rec_do_sort32_result[31:0];
  neuron_sort_t rec_do_sort16_result[15:0];
  neuron_sort_t rec_do_sort8_result[7:0];
  neuron_sort_t rec_do_sort4_result[3:0];
  neuron_sort_t rec_do_sort2_result[1:0];
  neuron_sort_t rec_do_sort1_result;
  
            

  
  
  
  
  function  neuron_sort_t COMP2;
    input neuron_sort_t right;
    input neuron_sort_t left;

    begin:comp2_func
      if(left.value > right.value) begin
          COMP2 = left;
      end
      else begin
          COMP2 = right;
      end
    end
  endfunction 
  
  
  
  
  
  
  always_comb begin
    for(k=0;k<64;k=k+1) begin
      rec_do_sort32_in[k].index  = k;
      if(rec_us_neuron_en5[k]) begin
        rec_do_sort32_in[k].value = signed'(rec_act_result[k]);
      end
      else begin
        rec_do_sort32_in[k].value = -128;
      end
    end
  end
  
  always_comb begin
    rec_do_sort16_in = rec_do_sort32_result;
    rec_do_sort8_in  = rec_do_sort16_result;
    
    rec_do_sort2_in  = rec_do_sort4_result;
    rec_do_sort1_in  = rec_do_sort2_result;
 

    
    for(j=0;j<8;j=j+1) begin   
      rec_do_sort[j] = rec_do_sort4_in[j].value;
    end
    
  end
   
  
  always_comb begin

    
    
    
    for(i=0;i<32;i=i+1) begin
      rec_do_sort32_result[i]  = COMP2(rec_do_sort32_in[i*2], rec_do_sort32_in[(i*2)+1]);
    end
    
    
    
    for(i=0;i<16;i=i+1) begin
      rec_do_sort16_result[i]  = COMP2(rec_do_sort16_in[i*2], rec_do_sort16_in[(i*2)+1]);
    end
    
    
    
    for(i=0;i<8;i=i+1) begin
      rec_do_sort8_result[i]  = COMP2(rec_do_sort8_in[i*2], rec_do_sort8_in[(i*2)+1]);
    end
    
    
    
    for(i=0;i<4;i=i+1) begin
      rec_do_sort4_result[i]  = COMP2(rec_do_sort4_in[i*2], rec_do_sort4_in[(i*2)+1]);
    end
    
    
    
    for(i=0;i<2;i=i+1) begin
      rec_do_sort2_result[i]  = COMP2(rec_do_sort2_in[i*2], rec_do_sort2_in[(i*2)+1]);
    end
    
    
    
    rec_do_sort1_result  = COMP2(rec_do_sort1_in[0], rec_do_sort1_in[1]); 
  end

  
    

    






        

  
  
  
  
  
  
  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      rec_do_sort4_in <= '{default:0};
      rec_do_prefix <= 0;
 
    end
    else begin
    
    
    
      rec_do_sort4_in <= rec_do_sort8_result;
    
    
    
    
    if(rec_do_sort1_result.value >= rec_us_threshold) begin  
      rec_do_prefix <= rec_do_sort1_result.index;
    end
    else begin
      rec_do_prefix <= 0;
    end
      
  
    end 
  end 


  
  
  
 //synopsys translate_off 
  covergroup cov_sort_result_grp @(posedge clk); 
    cov_sort: coverpoint rec_do_sort1_result.value{
      bins MIN = {-128};
      bins MID = {[-127:126]};
      bins MAX = {127};
    }
    cov_threshold: coverpoint rec_us_threshold{
      bins MIN = {-128};
      bins MID = {[-127:126]};
      bins MAX = {127};
    }

    
    cov_sort_w_thresh: cross cov_threshold, cov_sort;
  endgroup 

  cov_sort_result_grp cov_sort_result_grp_inst = new();
  
//synopsys translate_on  
  
        
endmodule 










