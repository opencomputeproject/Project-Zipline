/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/















`include "crPKG.svp"
`include "cr_prefix.vh"

module cr_prefix_rec 
  (
  
  rec_psr, rec_debug_status, rec_im_addr, rec_im_cs, rec_us_fe_rd,
  rec_sat_addr, rec_sat_cs, rec_ct_addr, rec_ct_cs,
  rec_us_prefix_valid, rec_us_pf_datain,
  
  clk, rst_n, regs_rec_us_ctrl, regs_rec_debug_control,
  regs_breakpoint_addr, regs_ld_breakpoint, regs_breakpoint_cont,
  regs_breakpoint_step, rec_im_dout, fe_ctr_1_ib, fe_ctr_2_ib,
  fe_ctr_3_ib, fe_ctr_4_ib, fe_ctr_1_ib_empty, fe_ctr_2_ib_empty,
  fe_ctr_3_ib_empty, fe_ctr_4_ib_empty, rec_sat_dout, rec_ct_dout,
  pf_full, pf_afull
  );
            
`include "cr_structs.sv"
     
  import crPKG::*; 
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;

  
  
  
  input                                         clk;
  input                                         rst_n; 
    
  
  
  
  output  psr_t                                 rec_psr[0:426] ;
          
  
  
  
  input prefix_rec_us_ctrl_t                    regs_rec_us_ctrl;

    
  
  
  
  output  prefix_debug_status_t                 rec_debug_status;
  input   prefix_debug_control_t                regs_rec_debug_control;
  input   prefix_breakpoint_addr_t              regs_breakpoint_addr;
  input                                         regs_ld_breakpoint ;
  input                                         regs_breakpoint_cont ;
  input                                         regs_breakpoint_step;
      
  
  
  
  output [`LOG_VEC(`N_PREFIX_IM_ENTRIES)]       rec_im_addr;
  output logic                                  rec_im_cs;
  input                                         rec_inst_t rec_im_dout;

  
  
  
  
  input logic [511:0]                           fe_ctr_1_ib;
  input logic [511:0]                           fe_ctr_2_ib;
  input logic [511:0]                           fe_ctr_3_ib;
  input logic [511:0]                           fe_ctr_4_ib;
  
  input logic                                   fe_ctr_1_ib_empty;
  input logic                                   fe_ctr_2_ib_empty;
  input logic                                   fe_ctr_3_ib_empty;
  input logic                                   fe_ctr_4_ib_empty;

  output logic                                  rec_us_fe_rd;
  
  
  
  output logic [`LOG_VEC(`N_PREFIX_SAT_ENTRIES)] rec_sat_addr;
  output logic                                  rec_sat_cs;
  input  [895:0]                                rec_sat_dout;

      
  
  
  
  output logic [`LOG_VEC(`N_PREFIX_CT_ENTRIES)] rec_ct_addr;
  output logic                                  rec_ct_cs;
  input                                         rec_ct_t rec_ct_dout;

  
  
  
  
  input                                         pf_full;
  input                                         pf_afull;
  output logic                                  rec_us_prefix_valid;  
  output logic [8:0]                            rec_us_pf_datain;
  
  

 
  logic  [`PREFIX_NEURON_WIDTH-1:0]             rec_di_coeff [`N_PREFIX_NEURONS-1:0];
  logic signed [`PREFIX_ACC_WIDTH-1:0]          rec_alu_acc[`N_PREFIX_NEURONS-1:0];
  logic  [`PREFIX_NEURON_WIDTH-1:0]             rec_act_result[`N_PREFIX_NEURONS-1:0];

  opcode_e rec_us_ir0_opcode;
  opcode_e rec_us_ir1_opcode;
  opcode_e rec_us_ir2_opcode;
  opcode_e rec_us_ir3_opcode;
  opcode_e rec_us_ir4_opcode;
  
  assign rec_us_ir0_opcode = opcode_e'(rec_us_ir0.opcode);
  assign rec_us_ir1_opcode = opcode_e'(rec_us_ir1.opcode);
  assign rec_us_ir2_opcode = opcode_e'(rec_us_ir2.opcode);
  assign rec_us_ir3_opcode = opcode_e'(rec_us_ir3.opcode);
  assign rec_us_ir4_opcode = opcode_e'(rec_us_ir4.opcode);
  
  
  
  logic [`PREFIX_NEURON_WIDTH-1:0] rec_di_datareg [`N_PREFIX_NEURONS-1:0];
  logic [`PREFIX_NEURON_WIDTH-1:0] rec_di_ip0 [`N_PREFIX_NEURONS-1:0];
  logic [`PREFIX_NEURON_WIDTH-1:0] rec_di_ip1 [`N_PREFIX_NEURONS-1:0];
  logic [`PREFIX_NEURON_WIDTH-1:0] rec_di_lr0 [`N_PREFIX_NEURONS-1:0];
  logic [`PREFIX_NEURON_WIDTH-1:0] rec_di_lr1 [`N_PREFIX_NEURONS-1:0];
  logic [`PREFIX_NEURON_WIDTH-1:0] rec_di_neuron [`N_PREFIX_NEURONS-1:0];
  logic                 rec_di_neuron_sign;     
  logic [`PREFIX_NEURON_WIDTH-2:0] rec_di_rx [`N_PREFIX_NEURONS-1:0];
  logic [5:0]           rec_do_prefix;          
  logic [`PREFIX_NEURON_WIDTH-1:0] rec_do_sort [7:0];
  logic                 rec_us_break;           
  logic [1:0]           rec_us_drsel;           
  logic                 rec_us_halt;            
  logic                 rec_us_hold;            
  logic                 rec_us_iprst;           
  rec_inst_t            rec_us_ir0;             
  rec_inst_t            rec_us_ir1;             
  rec_inst_t            rec_us_ir2;             
  rec_inst_t            rec_us_ir3;             
  rec_inst_t            rec_us_ir4;             
  rec_inst_t            rec_us_ir5;             
  rec_inst_t            rec_us_ir6;             
  rec_inst_t            rec_us_ir7;             
  logic                 rec_us_ld_lr0;          
  logic                 rec_us_ld_lr1;          
  logic [7:0]           rec_us_neuron_cnt5;     
  logic [127:0]         rec_us_neuron_en3;      
  logic [127:0]         rec_us_neuron_en4;      
  logic [63:0]          rec_us_neuron_en5;      
  logic                 rec_us_run;             
  logic                 rec_us_step;            
  logic signed [7:0]    rec_us_threshold;       
  logic                 rec_us_x2break;         
  
  
  
  
  
  genvar               i;
  generate
    
    for(i=0;i<32;i=i+1) begin
      assign rec_psr[i]  = {rec_di_ip0[(i*4)+3],rec_di_ip0[(i*4)+2],rec_di_ip0[(i*4)+1],rec_di_ip0[(i*4)]}; 
    end
    
    for(i=0;i<32;i=i+1) begin
      assign rec_psr[i+32]  = {rec_di_ip1[(i*4)+3],rec_di_ip1[(i*4)+2],rec_di_ip1[(i*4)+1],rec_di_ip1[(i*4)]}; 
    end
    
    for(i=0;i<32;i=i+1) begin
      assign rec_psr[i+64]  = {rec_di_lr0[(i*4)+3],rec_di_lr0[(i*4)+2],rec_di_lr0[(i*4)+1],rec_di_lr0[(i*4)]}; 
    end
    
    for(i=0;i<32;i=i+1) begin
      assign rec_psr[i+96]  = {rec_di_lr1[(i*4)+3],rec_di_lr1[(i*4)+2],rec_di_lr1[(i*4)+1],rec_di_lr1[(i*4)]}; 
    end  
    
    for(i=0;i<32;i=i+1) begin
      assign rec_psr[i+128]  = {rec_di_datareg[(i*4)+3],rec_di_datareg[(i*4)+2],rec_di_datareg[(i*4)+1],rec_di_datareg[(i*4)]}; 
    end
    
    for(i=0;i<32;i=i+1) begin
      assign rec_psr[i+160]  = {1'b0,rec_di_rx[(i*4)+3],1'b0,rec_di_rx[(i*4)+2],1'b0,rec_di_rx[(i*4)+1],1'b0,rec_di_rx[(i*4)]}; 
    end
    
    for(i=0;i<32;i=i+1) begin
      assign rec_psr[i+192]  = {rec_di_coeff[(i*4)+3],rec_di_coeff[(i*4)+2],rec_di_coeff[(i*4)+1],rec_di_coeff[(i*4)]}; 
    end  
    
    for(i=0;i<32;i=i+1) begin
      assign rec_psr[i+224]  = {rec_di_neuron[(i*4)+3],rec_di_neuron[(i*4)+2],rec_di_neuron[(i*4)+1],rec_di_neuron[(i*4)]}; 
    end  
    
    for(i=0;i<128;i=i+1) begin
      assign rec_psr[i+256]  = {12'd0,rec_alu_acc[i]}; 
    end  
    
    for(i=0;i<32;i=i+1) begin
      assign rec_psr[i+384]  = {rec_act_result[(i*4)+3],rec_act_result[(i*4)+2],rec_act_result[(i*4)+1],rec_act_result[(i*4)]}; 
    end  
    
    for(i=0;i<2;i=i+1) begin
      assign rec_psr[i+416]  = {rec_do_sort[(i*4)+3],rec_do_sort[(i*4)+2],rec_do_sort[(i*4)+1],rec_do_sort[(i*4)]}; 
    end
    
    assign rec_psr[418] = {10'd0,rec_do_prefix,rec_us_neuron_cnt5,rec_im_addr};
    
    assign rec_psr[419] = {8'd0,rec_us_ir0};
    
    assign rec_psr[420] = {8'd0,rec_us_ir1};
    
    assign rec_psr[421] = {8'd0,rec_us_ir2};
    
    assign rec_psr[422] = {8'd0,rec_us_ir3};
    
    assign rec_psr[423] = {8'd0,rec_us_ir4};
    
    assign rec_psr[424] = {8'd0,rec_us_ir5};
    
    assign rec_psr[425] = {8'd0,rec_us_ir6};
    
    assign rec_psr[426] = {8'd0,rec_us_ir7};
    
    
  endgenerate


  
  
  
 
  cr_prefix_rec_us
    u_cr_prefix_rec_us                         
      (
       
       .rec_debug_status                (rec_debug_status),
       .rec_us_fe_rd                    (rec_us_fe_rd),
       .rec_im_addr                     (rec_im_addr[`LOG_VEC(`N_PREFIX_IM_ENTRIES)]),
       .rec_im_cs                       (rec_im_cs),
       .rec_sat_addr                    (rec_sat_addr[`LOG_VEC(`N_PREFIX_SAT_ENTRIES)]),
       .rec_sat_cs                      (rec_sat_cs),
       .rec_ct_addr                     (rec_ct_addr[`LOG_VEC(`N_PREFIX_CT_ENTRIES)]),
       .rec_ct_cs                       (rec_ct_cs),
       .rec_us_prefix_valid             (rec_us_prefix_valid),
       .rec_us_pf_datain                (rec_us_pf_datain[8:0]),
       .rec_us_halt                     (rec_us_halt),
       .rec_us_hold                     (rec_us_hold),
       .rec_us_run                      (rec_us_run),
       .rec_us_step                     (rec_us_step),
       .rec_us_break                    (rec_us_break),
       .rec_us_x2break                  (rec_us_x2break),
       .rec_us_iprst                    (rec_us_iprst),
       .rec_us_drsel                    (rec_us_drsel[1:0]),
       .rec_us_neuron_en3               (rec_us_neuron_en3[127:0]),
       .rec_us_neuron_en4               (rec_us_neuron_en4[127:0]),
       .rec_us_neuron_en5               (rec_us_neuron_en5[63:0]),
       .rec_us_neuron_cnt5              (rec_us_neuron_cnt5[7:0]),
       .rec_us_ld_lr0                   (rec_us_ld_lr0),
       .rec_us_ld_lr1                   (rec_us_ld_lr1),
       .rec_us_threshold                (rec_us_threshold[7:0]),
       .rec_us_ir0                      (rec_us_ir0),
       .rec_us_ir1                      (rec_us_ir1),
       .rec_us_ir2                      (rec_us_ir2),
       .rec_us_ir3                      (rec_us_ir3),
       .rec_us_ir4                      (rec_us_ir4),
       .rec_us_ir5                      (rec_us_ir5),
       .rec_us_ir6                      (rec_us_ir6),
       .rec_us_ir7                      (rec_us_ir7),
       
       .clk                             (clk),
       .rst_n                           (rst_n),
       .regs_rec_us_ctrl                (regs_rec_us_ctrl),
       .regs_rec_debug_control          (regs_rec_debug_control),
       .regs_breakpoint_addr            (regs_breakpoint_addr),
       .regs_ld_breakpoint              (regs_ld_breakpoint),
       .regs_breakpoint_cont            (regs_breakpoint_cont),
       .regs_breakpoint_step            (regs_breakpoint_step),
       .fe_ctr_1_ib_empty               (fe_ctr_1_ib_empty),
       .fe_ctr_2_ib_empty               (fe_ctr_2_ib_empty),
       .fe_ctr_3_ib_empty               (fe_ctr_3_ib_empty),
       .fe_ctr_4_ib_empty               (fe_ctr_4_ib_empty),
       .rec_im_dout                     (rec_im_dout),
       .pf_full                         (pf_full),
       .pf_afull                        (pf_afull),
       .rec_do_prefix                   (rec_do_prefix[5:0]));
  
  
  
  
 
  cr_prefix_rec_di
    u_cr_prefix_rec_di                          
      (
       
       .rec_di_coeff                    (rec_di_coeff),
       .rec_di_neuron                   (rec_di_neuron),
       .rec_di_neuron_sign              (rec_di_neuron_sign),
       .rec_di_lr0                      (rec_di_lr0),
       .rec_di_lr1                      (rec_di_lr1),
       .rec_di_ip0                      (rec_di_ip0),
       .rec_di_ip1                      (rec_di_ip1),
       .rec_di_datareg                  (rec_di_datareg),
       .rec_di_rx                       (rec_di_rx),
       
       .clk                             (clk),
       .rst_n                           (rst_n),
       .fe_ctr_1_ib                     (fe_ctr_1_ib[511:0]),
       .fe_ctr_2_ib                     (fe_ctr_2_ib[511:0]),
       .fe_ctr_3_ib                     (fe_ctr_3_ib[511:0]),
       .fe_ctr_4_ib                     (fe_ctr_4_ib[511:0]),
       .rec_sat_dout                    (rec_sat_dout[895:0]),
       .rec_ct_dout                     (rec_ct_dout),
       .rec_us_fe_rd                    (rec_us_fe_rd),
       .rec_us_halt                     (rec_us_halt),
       .rec_us_hold                     (rec_us_hold),
       .rec_us_run                      (rec_us_run),
       .rec_us_step                     (rec_us_step),
       .rec_us_break                    (rec_us_break),
       .rec_us_x2break                  (rec_us_x2break),
       .rec_us_iprst                    (rec_us_iprst),
       .rec_us_ir1_opcode               (rec_us_ir1_opcode),
       .rec_us_ir2_opcode               (rec_us_ir2_opcode),
       .rec_us_drsel                    (rec_us_drsel[1:0]),
       .rec_us_ld_lr0                   (rec_us_ld_lr0),
       .rec_us_ld_lr1                   (rec_us_ld_lr1),
       .rec_act_result                  (rec_act_result));
  
  
  
  
   
  
  genvar                  k;
  generate 
    for(k=0;k<128;k=k+1) begin: rec_alu
      cr_prefix_rec_alu 
        u_cr_prefix_rec_alu 
        (
         
         .rec_alu_acc                   (rec_alu_acc[k][`PREFIX_ACC_WIDTH-1:0]), 
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .rec_us_hold                   (rec_us_hold),
         .rec_us_ir3_opcode             (rec_us_ir3_opcode),     
         .rec_us_neuron_en3             (rec_us_neuron_en3[k]),  
         .rec_di_coeff                  (rec_di_coeff[k][`PREFIX_NEURON_WIDTH-1:0]), 
         .rec_di_neuron                 (rec_di_neuron[k][`PREFIX_NEURON_WIDTH-1:0]), 
         .rec_di_neuron_sign            (rec_di_neuron_sign));   
    end 
  endgenerate
  
  
  
  
   
  generate 
    for(k=0;k<128;k=k+1) begin: rec_act
      cr_prefix_rec_act 
        u_cr_prefix_rec_act 
        (
         
         .rec_act_result                (rec_act_result[k][`PREFIX_NEURON_WIDTH-1:0]), 
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .rec_us_hold                   (rec_us_hold),
         .rec_us_ir4_opcode             (rec_us_ir4_opcode),     
         .rec_us_ir4_src1               (rec_us_ir4.src1),       
         .rec_us_neuron_en4             (rec_us_neuron_en4[k]),  
         .rec_alu_acc                   (rec_alu_acc[k][`PREFIX_ACC_WIDTH-1:0])); 
    end 
  endgenerate
  
   
  
  
 

  cr_prefix_rec_do
    u_cr_prefix_rec_do
       (
        
        .rec_do_sort                    (rec_do_sort),
        .rec_do_prefix                  (rec_do_prefix[5:0]),
        
        .clk                            (clk),
        .rst_n                          (rst_n),
        .rec_us_hold                    (rec_us_hold),
        .rec_us_threshold               (rec_us_threshold[7:0]),
        .rec_us_neuron_en5              (rec_us_neuron_en5[63:0]),
        .rec_act_result                 (rec_act_result[63:0]));         
   
endmodule 










