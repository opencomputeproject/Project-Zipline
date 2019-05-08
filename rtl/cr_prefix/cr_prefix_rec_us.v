/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
















`include "crPKG.svp"
`include "cr_prefix.vh"

module cr_prefix_rec_us 
  (
  
  rec_debug_status, rec_us_fe_rd, rec_im_addr, rec_im_cs,
  rec_sat_addr, rec_sat_cs, rec_ct_addr, rec_ct_cs,
  rec_us_prefix_valid, rec_us_pf_datain, rec_us_halt, rec_us_hold,
  rec_us_run, rec_us_step, rec_us_break, rec_us_x2break, rec_us_iprst,
  rec_us_drsel, rec_us_neuron_en3, rec_us_neuron_en4,
  rec_us_neuron_en5, rec_us_neuron_cnt5, rec_us_ld_lr0, rec_us_ld_lr1,
  rec_us_threshold, rec_us_ir0, rec_us_ir1, rec_us_ir2, rec_us_ir3,
  rec_us_ir4, rec_us_ir5, rec_us_ir6, rec_us_ir7,
  
  clk, rst_n, regs_rec_us_ctrl, regs_rec_debug_control,
  regs_breakpoint_addr, regs_ld_breakpoint, regs_breakpoint_cont,
  regs_breakpoint_step, fe_ctr_1_ib_empty, fe_ctr_2_ib_empty,
  fe_ctr_3_ib_empty, fe_ctr_4_ib_empty, rec_im_dout, pf_full,
  pf_afull, rec_do_prefix
  );
            
`include "cr_structs.sv"
      
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;

  
  
  
  input                                         clk;
  input                                         rst_n; 
                 
  
  
  
  input prefix_rec_us_ctrl_t                    regs_rec_us_ctrl;
    
  
  
  
  output  prefix_debug_status_t                 rec_debug_status;
  input   prefix_debug_control_t                regs_rec_debug_control;
  input   prefix_breakpoint_addr_t              regs_breakpoint_addr;
  input                                         regs_ld_breakpoint ;
  input                                         regs_breakpoint_cont ;
  input                                         regs_breakpoint_step;
 
  
  
  
  input  logic                                  fe_ctr_1_ib_empty;
  input  logic                                  fe_ctr_2_ib_empty;
  input  logic                                  fe_ctr_3_ib_empty;
  input  logic                                  fe_ctr_4_ib_empty;
  output logic                                  rec_us_fe_rd;   
    
  
  
  
  output logic [`LOG_VEC(`N_PREFIX_IM_ENTRIES)] rec_im_addr;
  output logic                                  rec_im_cs;
  input  rec_inst_t                             rec_im_dout;

  
  
  
  output logic [`LOG_VEC(`N_PREFIX_SAT_ENTRIES)] rec_sat_addr;
  output logic                                   rec_sat_cs;
      
  
  
  
  output logic [`LOG_VEC(`N_PREFIX_CT_ENTRIES)] rec_ct_addr;
  output logic                                  rec_ct_cs;
      
  
  
  
  input                                         pf_full;
  input                                         pf_afull;
  input [5:0]                                   rec_do_prefix;
  output logic                                  rec_us_prefix_valid;  
  output logic [8:0]                            rec_us_pf_datain;
                                     
  
  
  
  
  output logic                                  rec_us_halt;
  output logic                                  rec_us_hold;
  output logic                                  rec_us_run;
  output logic                                  rec_us_step;
  output logic                                  rec_us_break;
  output logic                                  rec_us_x2break;
  
  output logic                                  rec_us_iprst;
  output logic [1:0]                            rec_us_drsel;
  output logic [127:0]                          rec_us_neuron_en3;
  output logic [127:0]                          rec_us_neuron_en4;
  output logic [63:0]                           rec_us_neuron_en5;
  output logic [7:0]                            rec_us_neuron_cnt5;
  output logic                                  rec_us_ld_lr0;
  output logic                                  rec_us_ld_lr1;
  
  output logic signed [7:0]                     rec_us_threshold;
  
  output rec_inst_t                             rec_us_ir0;
  output rec_inst_t                             rec_us_ir1;
  output rec_inst_t                             rec_us_ir2;
  output rec_inst_t                             rec_us_ir3;
  output rec_inst_t                             rec_us_ir4;
  output rec_inst_t                             rec_us_ir5;
  output rec_inst_t                             rec_us_ir6;
  output rec_inst_t                             rec_us_ir7;
  
  
  
  

  rec_inst_t                                    rec_us_ir0_hold;
  logic [`LOG_VEC(`N_PREFIX_IM_ENTRIES)]        rec_us_break_addr;
  logic                                         rec_us_break_armed;
  logic                                         rec_us_break_armed_en;
  logic                                         rec_us_break_trigd;
  logic                                         rec_us_breakpoint_cont ;
  logic                                         rec_us_breakpoint_en;
  logic                                         rec_us_breakpoint_step; 
  logic                                         rec_us_breakpoint_steped; 
  logic                                         rec_us_error;
  logic                                         rec_us_fe_avail;
  logic                                         rec_us_ip_valid ;
  logic                                         rec_us_ld_breakpoint  ;
  logic                                         rec_us_lock;
  logic [`LOG_VEC(`N_PREFIX_IM_ENTRIES)]        rec_us_pc;
  logic [7:0]                                   rec_us_pc_error;
  logic                                         rec_us_prefix_wr_opcode;
  logic                                         rec_us_prefix_written;
  logic                                         rec_us_prefix_writtenp1;
  logic                                         rec_us_regs_breakpoint_cont;
  logic                                         rec_us_regs_breakpoint_step ;
  logic                                         rec_us_regs_ld_breakpoint ;
  logic                                         rec_us_sw_en;
  logic [7:0]                                   rec_us_sw_en_error;
  logic [7:0]                                   rec_us_neuron_cnt3;
  logic [7:0]                                   rec_us_neuron_cnt4;
  logic [`LOG_VEC(`N_PREFIX_IM_ENTRIES)]        rec_us_next_pc;
  logic [7:0]                                   rec_us_opcode_error;
  logic                                         rec_us_unlock_written;
  logic [7:0]                                   rec_us_wr_prefix_error;
  logic                                         rec_us_hold_dly;
  

  
  enum                          { IDLE,
                                  RUN,
                                  WAIT,
                                  BREAK,
                                  STEP} current_state, next_state;

   
  
  zipline_error_e                                rec_us_error_code;
  
  opcode_e rec_im_dout_opcode;
  opcode_e rec_us_ir0_opcode;
  opcode_e rec_us_ir1_opcode;
  assign rec_im_dout_opcode = opcode_e'(rec_im_dout.opcode);
  assign rec_us_ir0_opcode = opcode_e'(rec_us_ir0.opcode);
  assign rec_us_ir1_opcode = opcode_e'(rec_us_ir1.opcode);
  assign rec_us_error_code = zipline_error_e'(rec_us_pf_datain[7:0]);
  
  
 
  assign rec_im_addr = rec_us_pc;
  assign rec_im_cs = regs_rec_us_ctrl.rec_us_sw_en;
  assign rec_sat_cs = regs_rec_us_ctrl.rec_us_sw_en;
  assign rec_ct_cs = regs_rec_us_ctrl.rec_us_sw_en;

  assign rec_debug_status.rec_us_break_armed = rec_us_break_armed;
  assign rec_debug_status.rec_us_break_triggered = rec_us_break_trigd;
  assign rec_debug_status.rec_us_pc = rec_us_pc;
  assign rec_debug_status.resvd = 0;

  assign rec_us_breakpoint_en =  regs_rec_debug_control.rec_us_breakpoint_en;
  

  
  
  
  genvar                                        i;
  generate
    for(i=0;i<128;i=i+1) begin
      assign rec_us_neuron_en3[i] = (rec_us_neuron_cnt3 >i);
    end
  endgenerate 
  
  generate
    for(i=0;i<128;i=i+1) begin
      assign rec_us_neuron_en4[i] = (rec_us_neuron_cnt4 >i);
    end
  endgenerate
  
  generate
    for(i=0;i<64;i=i+1) begin
      assign rec_us_neuron_en5[i] = (rec_us_neuron_cnt5 >i);
    end
  endgenerate
  
  assign rec_us_error =  rec_us_pc_error[0] | 
                         rec_us_wr_prefix_error[0] |
                         rec_us_sw_en_error[0] |
                         rec_us_opcode_error[0];
  
 
  assign rec_us_fe_avail = ~fe_ctr_4_ib_empty &  ~fe_ctr_3_ib_empty & 
                           ~fe_ctr_2_ib_empty &  ~fe_ctr_1_ib_empty;

  assign rec_us_sw_en = regs_rec_us_ctrl.rec_us_sw_en;
  
  assign rec_us_fe_rd = rec_us_fe_avail & ~pf_full & ~rec_us_ip_valid;

  
  
  
  
  
  
  
  
  
  
  always @ *
    begin
      rec_us_break_armed_en = rec_us_break_armed & rec_us_breakpoint_en;
      
      next_state = IDLE;
      case (current_state)
        IDLE:
          begin
            if(rec_us_ip_valid) begin
              if(rec_us_break_armed_en && (rec_us_break_addr == rec_us_pc)) begin
                next_state = BREAK;
              end
              else if (rec_us_break_armed_en && (rec_us_break_addr == rec_us_next_pc)) begin
                next_state = STEP;
              end
              else begin
                next_state = RUN;
              end
            end
            else begin
              next_state = IDLE;
            end
          end 
        
        RUN: 
          begin
            if(rec_us_error || (rec_im_dout.opcode == HALT))  begin
              next_state = IDLE;
            end
            else if (rec_im_dout.opcode == HOLD) begin
              next_state = WAIT;
            end
            else if((rec_us_break_armed_en & (rec_us_break_addr == rec_us_next_pc)) | rec_us_breakpoint_steped) begin
              next_state = BREAK;
              end
            else begin
              next_state = RUN;
            end
          end
        WAIT:
          begin
            if(rec_us_fe_rd || rec_us_ip_valid) begin
              next_state = IDLE;
            end
            else begin
              next_state = WAIT;
            end
          end
        BREAK:
          begin
            if(rec_us_breakpoint_cont | ~rec_us_breakpoint_en) begin
              next_state = RUN;
             end
            else if(rec_us_breakpoint_step) begin
              next_state = STEP;
            end
            else begin
              next_state = BREAK;
            end
          end
        STEP:
          begin
              next_state = BREAK;
          end
        
        default:
          begin
              next_state = IDLE;
          end
      endcase 
    end 
  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) 
      begin
        current_state <= IDLE;
      end
    else
      begin
        current_state <= next_state;
      end
  end

  assign rec_us_next_pc = rec_us_pc + 1'b1;
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      rec_us_pc <= 0;
      rec_us_ip_valid <= 1'b0;
      
      rec_us_halt <= 1'b0;
      rec_us_hold  <= 1'b0;
      rec_us_run   <= 1'b0;
      rec_us_break <= 1'b0;
      rec_us_step  <= 1'b0;
      rec_us_x2break <= 1'b0;
      
      rec_us_lock <= 1'b0;
      rec_us_unlock_written <= 1'b0;
      rec_us_iprst     <= 1'b0;
      rec_us_break_armed <= 1'b0;
      rec_us_break_trigd <= 1'b0;
      
      rec_us_break_addr  <= 0;
      
      rec_us_regs_ld_breakpoint   <= 1'b0; 
      rec_us_regs_breakpoint_cont <= 1'b0; 
      rec_us_regs_breakpoint_step <= 1'b0;  

      rec_us_ld_breakpoint        <= 1'b0;   
      rec_us_breakpoint_cont      <= 1'b0; 
      rec_us_breakpoint_step      <= 1'b0;
      rec_us_breakpoint_steped      <= 1'b0;
     
    end
    else begin
      
      
      
      
      
      
      
      rec_us_regs_ld_breakpoint   <= rec_us_breakpoint_en & regs_ld_breakpoint;
      rec_us_regs_breakpoint_cont <= rec_us_breakpoint_en & regs_breakpoint_cont;
      rec_us_regs_breakpoint_step <= rec_us_breakpoint_en & regs_breakpoint_step;
      
      rec_us_ld_breakpoint   <= ~rec_us_regs_ld_breakpoint & regs_ld_breakpoint;
      rec_us_breakpoint_cont <= ~rec_us_regs_breakpoint_cont & regs_breakpoint_cont;
      rec_us_breakpoint_step <= ~rec_us_regs_breakpoint_step & regs_breakpoint_step;
      rec_us_breakpoint_steped <= rec_us_breakpoint_step;
      
      if(rec_us_ld_breakpoint) begin
        rec_us_break_addr <= regs_breakpoint_addr.rec_us_break_addr;
      end
      
      rec_us_run   <= (next_state==RUN);
      rec_us_break <= (next_state==BREAK);
      rec_us_step  <= (next_state==STEP);
      
      rec_us_x2break <= (current_state!=BREAK) & (next_state==BREAK);
        
      case(next_state)
        IDLE:
          begin 
            rec_us_pc <= 0;
            rec_us_halt <= 1'b1;
            rec_us_hold <= 1'b0;
            
            if(rec_us_fe_rd) begin
              rec_us_ip_valid <= 1'b1;
            end
            else if (rec_us_lock && (rec_us_error || (rec_im_dout.opcode == HALT))) begin
              rec_us_ip_valid <= 1'b0;
            end
            
            if(rec_us_fe_rd | rec_us_ip_valid) begin
              rec_us_lock <= 1'b1;
            end
            else if (rec_us_error || (rec_im_dout.opcode == HALT)) begin
              rec_us_lock <= 1'b0;
            end
            
            rec_us_unlock_written <= 1'b0;
            rec_us_iprst   <=  ~rec_us_fe_rd & ~rec_us_ip_valid ;
            
            if(rec_us_ld_breakpoint) begin
              rec_us_break_armed <= 1'b1;
              rec_us_break_trigd <= 1'b0;
            end
          end 
        RUN,
        STEP:
          begin
            rec_us_pc <= rec_us_next_pc;
            rec_us_halt <= 1'b0;
            rec_us_hold <= 1'b0;
            
            rec_us_iprst <= 1'b0;
            if((rec_us_ir0.opcode == UNLOCK) && ~rec_us_unlock_written) begin
              rec_us_lock  <= 1'b0;
              rec_us_ip_valid <= 1'b0;
              rec_us_unlock_written <= 1'b1; 
            end
            else if(rec_us_fe_rd) begin
              rec_us_ip_valid <= 1'b1;
            end
            
            rec_us_break_trigd <= 1'b0;
            if(rec_us_breakpoint_cont) begin
              rec_us_break_armed <= 1'b1;
            end
          end
        WAIT:
          begin
            rec_us_pc <= 0;
            rec_us_halt <= 1'b0;
            rec_us_hold <= 1'b1;
            
            rec_us_iprst <= 1'b0;
            
            

            if(rec_us_fe_rd) begin
              rec_us_ip_valid <= 1'b1;
            end
            else if (rec_us_lock) begin
              rec_us_ip_valid <= 1'b0;
            end
            
            rec_us_lock <= rec_us_fe_rd;
            
            
            rec_us_unlock_written <= 1'b0;
            
          end 
        BREAK:
          begin 
            rec_us_pc <= rec_us_pc;
            rec_us_halt <= 1'b0;
            rec_us_hold <= 1'b1;
            
            rec_us_iprst <= 1'b0;
            
            rec_us_break_trigd <= 1'b1;
            if(rec_us_breakpoint_cont) begin
              rec_us_break_armed <= 1'b1;
            end
            else begin
              rec_us_break_armed <= 1'b0;
            end
          end
        default:
          begin
            rec_us_pc <= 0;
            rec_us_hold <= 1'b0;
          end
      endcase 
    end 
  end 

    
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
    
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      rec_us_ir0 <= 0;
      rec_us_ir0_hold <= 0;
      rec_us_ir1 <= 0;
      rec_us_ir2 <= 0;
      rec_us_ir3 <= 0;
      rec_us_ir4 <= 0;
      rec_us_ir5 <= 0;
      rec_us_ir6 <= 0;
      rec_us_ir7 <= 0;
      
      rec_us_drsel <= 2'd0;
      rec_sat_addr <= 0;
      rec_ct_addr <= 0;
      
      rec_us_neuron_cnt3 <= 8'd128;
      rec_us_neuron_cnt4 <= 8'd128; 
      rec_us_neuron_cnt5 <= 8'd128;      
      
      rec_us_ld_lr0 <= 1'b0;
      rec_us_ld_lr1 <= 1'b0;
      rec_us_threshold <= 0;
      
      rec_us_prefix_valid <= 1'b0; 
      rec_us_pf_datain <= 9'd0;
      rec_us_prefix_written <= 1'b0;
      rec_us_prefix_writtenp1 <= 1'b0;
      rec_us_pc_error     <= 8'd0;
      rec_us_sw_en_error  <= 8'd0;
      rec_us_opcode_error <= 8'd0;
      rec_us_wr_prefix_error <= 8'd0;
      rec_us_prefix_wr_opcode <= 1'b0;
      rec_us_hold_dly <= 1'b0;
      
    end
    else begin
      
      
      if(rec_us_halt) begin
        rec_us_pc_error[0]     <= 1'd0;
        rec_us_sw_en_error[0]  <= 1'd0;
        rec_us_opcode_error[0] <= 1'd0;
        rec_us_wr_prefix_error[0] <= 1'd0;
        rec_us_prefix_wr_opcode <= 1'b0;
        rec_us_pc_error[7:1]        <= rec_us_pc_error[6:0];
        rec_us_sw_en_error[7:1]     <= rec_us_sw_en_error[6:0];
        rec_us_opcode_error[7:1]    <= rec_us_opcode_error[6:0];
        rec_us_wr_prefix_error[7:1] <= rec_us_wr_prefix_error[6:0];
      end 
      else if(rec_us_run || rec_us_step) begin
        
        rec_us_pc_error[0]     <= (rec_us_pc > 8'hfe);
        rec_us_sw_en_error[0]  <= ~rec_us_sw_en;
        rec_us_opcode_error[0] <= (rec_us_ir0.opcode > 4'ha);
       
        if((rec_us_ir0.opcode == RELUP) || (rec_us_ir0.opcode == SIGMOIDP)) begin
          rec_us_prefix_wr_opcode <= 1'b1;
          rec_us_wr_prefix_error[0] <=rec_us_prefix_wr_opcode;
        end
        else if(~rec_us_prefix_wr_opcode && ((next_state==IDLE) || (next_state==WAIT))) begin
          rec_us_prefix_wr_opcode <= 1'b1;
          rec_us_wr_prefix_error[0] <= 1'b1;
        end
       
        rec_us_pc_error[7:1]        <= rec_us_pc_error[6:0];
        rec_us_sw_en_error[7:1]     <= rec_us_sw_en_error[6:0];
        rec_us_opcode_error[7:1]    <= rec_us_opcode_error[6:0];
        rec_us_wr_prefix_error[7:1] <= rec_us_wr_prefix_error[6:0];
      end 
                    
      
      rec_us_prefix_writtenp1 <=  rec_us_prefix_written;
      rec_us_prefix_valid <= rec_us_prefix_written & ~rec_us_prefix_writtenp1;
      
      

      rec_us_hold_dly <= rec_us_hold;
      if(rec_us_x2break | rec_us_halt) begin
        rec_us_ir0_hold <= rec_im_dout;
      end
     
      
      
      
      
      if(rec_us_step) begin
        rec_us_ir0 <= rec_us_ir0_hold;
      end
      else if(rec_us_halt)  begin
        rec_us_ir0.rsvd   <= 0;
        rec_us_ir0.opcode <= HALT;
        rec_us_ir0.src1   <= 0;
        rec_us_ir0.src2   <= 0;
        rec_us_ir0.src3   <= 0;
        rec_us_ir0.src4   <= 0;
      end
      else if (rec_us_run) begin
        rec_us_ir0 <= rec_im_dout;
      end
        
      if(rec_im_dout.opcode == MAC) begin
        rec_sat_addr  <= rec_im_dout.src2[6:0];
      end
      
      if(~rec_us_hold) begin
          
        
        
        
        rec_us_ir1      <= rec_us_ir0;
          
        if(rec_us_ir0.opcode == MAC) begin
          rec_us_drsel <= {rec_us_ir0.src3,rec_us_ir0.src4};
        end
        
        if ((rec_us_ir0.opcode == MAC) || (rec_us_ir0.opcode == LOAD)) begin
          rec_ct_addr <= rec_us_ir0.src1[6:0];
        end
        
        
        
        
        rec_us_ir2 <= rec_us_ir1;
      
        
        
        
        rec_us_ir3 <= rec_us_ir2;
        
        if (rec_us_ir2.opcode == SETNCNT) begin
          rec_us_neuron_cnt3 <= rec_us_ir2.src1;
        end
        else if (rec_us_ir2.opcode == HALT) begin
          rec_us_neuron_cnt3 <= 8'd128;
        end
                 
 
        
        
        
        rec_us_ir4 <= rec_us_ir3;
        rec_us_neuron_cnt4 <= rec_us_neuron_cnt3;
        
        
        
        
        rec_us_ir5 <= rec_us_ir4;
        rec_us_neuron_cnt5 <= rec_us_neuron_cnt4;
        
        if ((rec_us_ir4.opcode ==RELUS) || (rec_us_ir4.opcode ==SIGMOIDS)) begin
          rec_us_ld_lr0 <= ~rec_us_ir4.src4;
          rec_us_ld_lr1 <=  rec_us_ir4.src4;
        end
        else begin
          rec_us_ld_lr0 <= 1'b0;
          rec_us_ld_lr1 <= 1'b0;
        end

        
        
        
        rec_us_ir6 <= rec_us_ir5;
        if ((rec_us_ir5.opcode ==RELUP) || (rec_us_ir5.opcode ==SIGMOIDP)) begin
          rec_us_threshold <= signed'(rec_us_ir5.src2);
        end
        
       
        
        
        
        rec_us_ir7 <= rec_us_ir6;
        
        
        
        
        
        
        if(~rec_us_prefix_written && rec_us_pc_error[7]) begin
          rec_us_prefix_written <= ~rec_us_prefix_written;
          rec_us_pf_datain <= {1'b1,PREFIX_PC_OVERRUN_ERROR};
        end
        else if(~rec_us_prefix_written && rec_us_sw_en_error[7]) begin
          rec_us_prefix_written <= ~rec_us_prefix_written;
          rec_us_pf_datain <= {1'b1,PREFIX_REC_US_SW_EN_ERROR};
        end 
        else if(~rec_us_prefix_written && rec_us_opcode_error[7]) begin
          rec_us_prefix_written <= ~rec_us_prefix_written;
          rec_us_pf_datain <= {1'b1,PREFIX_ILLEGAL_OPCODE};
        end
        else if(~rec_us_prefix_written && rec_us_wr_prefix_error[7]) begin
          rec_us_prefix_written <= ~rec_us_prefix_written;
          rec_us_pf_datain <= {1'b1,PREFIX_NUM_WR_ERROR};
        end
        else if(~rec_us_prefix_written && ((rec_us_ir7.opcode == RELUP) || (rec_us_ir7.opcode == SIGMOIDP))) begin
          rec_us_prefix_written <= ~rec_us_prefix_written;
          rec_us_pf_datain <= {3'd0,rec_do_prefix};
        end
        else if(rec_us_ir7.opcode == HALT) begin
          rec_us_prefix_written <= 1'b0;
        end 
      end 
    end 
  end 
  

  
  
  
  opcode_e rec_im_dout1_opcode;
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      rec_im_dout1_opcode <= opcode_e'(0);
    end
    else begin
      rec_im_dout1_opcode <= rec_im_dout_opcode;
    end
  end
  
//synopsys translate_off  
      
  covergroup cov_prefix_rec_grp @(posedge clk);    
    cov_im_opcode: coverpoint rec_im_dout_opcode{
      bins VALID_OPCODE[] = {[0:10]};
      bins INVALID_OPCODE = default;
    } 
    cov_im_opcode_unarray_ignore_nop: coverpoint rec_im_dout_opcode{
      bins VALID_OPCODE = {[1:10]};
      bins INVALID_OPCODE = default;
    }          
    cov_im_opcode1: coverpoint rec_im_dout1_opcode{
      bins VALID_OPCODE[] = {[0:10]};
      bins INVALID_OPCODE = default;
    }       
    cov_opcode: coverpoint rec_us_ir0.opcode{
      bins VALID_OPCODE[] = {[0:10]};
      bins INVALID_OPCODE = default;
    }   
    cov_opcode1: coverpoint rec_us_ir1.opcode{
      bins VALID_OPCODE1[] = {[2:9]};
      bins INVALID_OPCODE1 = default;
    } 
    cov_src1: coverpoint  rec_us_ir0.src1{
       bins SRC1_MIN = {0};
       bins SRC1_MID1 = {[1:8]};
       bins SRC1_MID2 = {[9:126]};
       bins SRC1_MAX = {127};
       bins INVALID_VALS = default;
    }    
    cov_src2_unsign: coverpoint  rec_us_ir0.src2{
       bins SRC2_MIN = {0};
       bins SRC2_MID = {[1:126]};
       bins SRC2_MAX = {127};
       bins INVALID_SRC2_UNSIGN = default;
    }
    cov_src2_sign: coverpoint  rec_us_ir0.src2{
       bins SRC2_MAX_NEG = {128};       
       bins SRC2_MID_POS = {[0:126]};
       bins SRC2_MAX_POS = {127};
       bins SRC2_MID_NEG = {[129:255]};
    } 
    cov_src3: coverpoint  rec_us_ir0.src3;
    cov_src4: coverpoint  rec_us_ir0.src4;
    
    cov_op_relu_store: cross cov_opcode, cov_src1, cov_src4{
      ignore_bins NOT_RELU_STORE = binsof(cov_opcode) intersect {[0:2],[4:10]} ;
      ignore_bins NOT_RELU_SHIFTCNT = binsof(cov_src1) intersect{[9:255]};
    }
    cov_op_sigmoid_store: cross cov_opcode, cov_src1, cov_src4{
      ignore_bins NOT_SIGMOID_STORE = binsof(cov_opcode) intersect {[0:3],[5:10]} ;
      ignore_bins NOT_SIGMOID_SHIFTCNT = binsof(cov_src1) intersect{[9:255]};
    }
    cov_op_relu_prefix: cross cov_opcode, cov_src1, cov_src2_sign{
      ignore_bins NOT_RELU_PREFIX = binsof(cov_opcode) intersect {[0:5],[7:10]} ;
      ignore_bins NOT_RELU_SHIFTCNT = binsof(cov_src1) intersect{[9:255]};
    }
    cov_op_sigmoid_prefix: cross cov_opcode, cov_src1, cov_src2_sign{
      ignore_bins NOT_SIGMOID_PREFIX = binsof(cov_opcode) intersect {[0:6],[8:10]} ;
      ignore_bins NOT_SIGMOID_SHIFTCNT = binsof(cov_src1) intersect{[9:255]};
    }
    cov_op_load: cross cov_opcode, cov_src1{
      ignore_bins NOT_LOAD = binsof(cov_opcode) intersect {[0:7],[9:10]} ;
      ignore_bins NOT_CPTR = binsof(cov_src1) intersect{[128:255]};       
    }
    cov_op_mac: cross cov_opcode, cov_src1, cov_src2_unsign, cov_src3, cov_src4{
       ignore_bins NOT_MAC = binsof(cov_opcode) intersect {[0:8],10} ;
       ignore_bins NOT_MAC_SRC1_MAX = binsof(cov_src1) intersect {[128:255]};
       ignore_bins NOT_MAC_SRC2_MAX = binsof(cov_src2_unsign) intersect {[128:255]};
    }
    cov_op_setneuroncnt: cross cov_opcode, cov_src1{
      ignore_bins NOT_SET_NEURON_CNT = binsof(cov_opcode) intersect {[0:4],[6:10]};
    }
    cov_op_after_halt: cross cov_im_opcode_unarray_ignore_nop, cov_im_opcode1{
      ignore_bins NOT_HALT = binsof(cov_im_opcode1) intersect {0,[2:10]};
    }
    cov_op_unlock_after_hold: cross cov_im_opcode, cov_im_opcode1{
      ignore_bins NOT_HOLD = binsof(cov_im_opcode1) intersect {[0:9]};
      ignore_bins NOT_UNLOCK = binsof(cov_im_opcode) intersect {[0:1],[3:10]};
    }
  endgroup 

  logic [$clog2($bits(rec_us_neuron_en4)+1)-1:0] inner_ncnt;
  int iidx = 0;

  always_comb begin
    inner_ncnt = '0;  
    foreach(rec_us_neuron_en4[iidx]) begin
      inner_ncnt += rec_us_neuron_en4[iidx];
    end
  end

  covergroup cov_neuron_cnt_inner_layer_grp @(posedge clk);
    cov_neuron_icnt: coverpoint inner_ncnt{
      bins MIN = {1};
      bins MID = {2,63};
      bins MID2 = {64,127};
      bins MAX = {128};
    }
  endgroup 
  
  logic [$clog2($bits(rec_us_neuron_en5)+1)-1:0] outer_ncnt;
  int idx = 0;

  always_comb begin
    outer_ncnt = '0;  
    foreach(rec_us_neuron_en5[idx]) begin
      outer_ncnt += rec_us_neuron_en5[idx];
    end
  end

  covergroup cov_neuron_cnt_outer_layer_grp @(posedge clk);
    cov_neuron_ocnt: coverpoint outer_ncnt{
      bins MIN = {1};
      bins MID = {2,31};
      bins MID2 = {32,63};
      bins MAX = {64};
    }
  endgroup

   cov_prefix_rec_grp cov_prefix_rec_grp_inst                          = new();
   cov_neuron_cnt_outer_layer_grp cov_neuron_cnt_outer_layer_grp_inst  = new();
   cov_neuron_cnt_inner_layer_grp cov_neuron_cnt_inner_layer_grp_inst  = new();
 
 
//synopsys translate_on
  
  
        
endmodule 










