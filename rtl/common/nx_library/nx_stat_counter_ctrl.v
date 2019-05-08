/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "messages.vh"
`include "nx_stat_counter.svp"

module nx_stat_counter_ctrl
  (
   
   req_ready, rsp_valid, rsp_data, rsp_id, ar_valid, ar_addr, r_ready,
   aw_valid, aw_addr, aw_data, b_ready,
   
   clk, rst_n, req_valid, req_addr, req_data, req_id, req_op,
   rsp_ready, ar_ready, r_valid, r_data, aw_ready, b_valid
   );
   import nx_stat_counter::*;
   
   
   
   parameter integer N_COUNTERS_PER_ENTRY = 2;
   
   
   parameter integer COUNTER_LSB_OFFSET[N_COUNTERS_PER_ENTRY:0] = '{70, 32, 0};
   
   parameter integer COUNTER_ADD_WIDTH[N_COUNTERS_PER_ENTRY-1:0] = '{14, 1};
   parameter N_ENTRIES = 1024;
   parameter N_OUTSTANDING_RMW = 4;
   parameter ID_WIDTH = 1;

   localparam TOTAL_WIDTH = COUNTER_LSB_OFFSET[N_COUNTERS_PER_ENTRY];


   input logic             clk;
   input logic             rst_n;

   
   input logic                                  req_valid;
   output logic                                 req_ready;
   input logic [`LOG_VEC(N_ENTRIES)]            req_addr;
   input logic [`BIT_VEC(TOTAL_WIDTH)]          req_data;
   input logic [`BIT_VEC(ID_WIDTH)]             req_id;
   input                                        counter_op_e req_op;
   
   
   output logic                                 rsp_valid;
   input logic                                  rsp_ready;
   output logic [`BIT_VEC(TOTAL_WIDTH)]         rsp_data;
   output logic [`BIT_VEC(ID_WIDTH)]            rsp_id;

   
   output logic                                 ar_valid;
   input logic                                  ar_ready;
   output logic [`LOG_VEC(N_ENTRIES)]           ar_addr;
   
   
   input logic                                  r_valid;
   output logic                                 r_ready;
   input logic [`BIT_VEC(TOTAL_WIDTH)]          r_data;

   
   output logic                                 aw_valid;
   input logic                                  aw_ready;
   output logic [`LOG_VEC(N_ENTRIES)]           aw_addr;
   output logic [`BIT_VEC(TOTAL_WIDTH)]         aw_data;

   
   input logic                                  b_valid;
   output logic                                 b_ready;


   
   typedef struct packed {
      counter_op_e                          op;
      logic [`BIT_VEC(ID_WIDTH)]            id;
      logic [`LOG_VEC(N_ENTRIES)]           addr;
      logic [`BIT_VEC(TOTAL_WIDTH)]         req_data;
      logic [`BIT_VEC(TOTAL_WIDTH)]         data;
      logic [`BIT_VEC(N_OUTSTANDING_RMW)]   match;
      logic                                 update_done;
   } scoreboard_t;

   reg [`BIT_VEC(N_OUTSTANDING_RMW)]          r_sb_val, c_sb_val;
   scoreboard_t r_sb[`BIT_VEC(N_OUTSTANDING_RMW)], c_sb[`BIT_VEC(N_OUTSTANDING_RMW)];
   reg [`LOG_VEC(N_OUTSTANDING_RMW)]          r_sb_upd_ptr, c_sb_upd_ptr;
   reg                                      r_write_done, c_write_done;
   reg                                      r_rsp_done, c_rsp_done;

   reg [`BIT_VEC(TOTAL_WIDTH)]             effective_rdata;
   reg [`BIT_VEC(TOTAL_WIDTH)]             update_data;
   reg [`BIT_VEC(TOTAL_WIDTH)]             count_update_data;

   reg                                     sb_wen;
   reg                                     sb_ren;
   wire                                    sb_full;
   wire [`LOG_VEC(N_OUTSTANDING_RMW)] sb_rptr;
   wire [`LOG_VEC(N_OUTSTANDING_RMW)] sb_wptr;

   
   
   
   
   
   

   fifo_ctrl #(.DEPTH(N_OUTSTANDING_RMW)) sb_ctrl
     (
      
      .empty                            (),                      
      .next_empty                       (),                      
      .full                             (sb_full),               
      .next_full                        (),                      
      .used_slots                       (),                      
      .next_used_slots                  (),                      
      .free_slots                       (),                      
      .next_free_slots                  (),                      
      .rptr                             (sb_rptr),               
      .next_rptr                        (),                      
      .wptr                             (sb_wptr),               
      .next_wptr                        (),                      
      
      .clk                              (clk),                   
      .rst_n                            (rst_n),                 
      .wen                              (sb_wen),                
      .ren                              (sb_ren));                
    
   
   
   assign ar_addr = req_addr;
   
   assign aw_addr = r_sb[r_sb_upd_ptr]     .addr;
   assign aw_data = update_data;

   assign rsp_data = effective_rdata;
   assign rsp_id = r_sb[r_sb_upd_ptr].id;

   always_comb begin
      reg v_update_sb;
      reg [`BIT_VEC(N_OUTSTANDING_RMW)] v_match;
      
      
      c_sb_val = r_sb_val;
      c_sb = r_sb;
      c_sb_upd_ptr = r_sb_upd_ptr;
      c_write_done = r_write_done;
      c_rsp_done = r_rsp_done;

      
      

      
      sb_ren = 1'b0;
      b_ready = 1'b0;
      if (r_sb_val[sb_rptr] && r_sb[sb_rptr].update_done) begin
         if ((r_sb[sb_rptr].op == READ) || b_valid) begin
            sb_ren = 1'b1;
            c_sb_val[sb_rptr] = 1'b0;
            b_ready = b_valid;
         end
      end

      
      

      
      
      
      effective_rdata = '0;
      if (r_sb[r_sb_upd_ptr].match == '0)
        effective_rdata = r_data;
      else begin
         for (int i=0; i<N_OUTSTANDING_RMW; i++) begin
            effective_rdata |= {TOTAL_WIDTH{r_sb[r_sb_upd_ptr].match[i]}} & r_sb[i].data; 
         end
      end
      
      case (r_sb[r_sb_upd_ptr].op)
        READ: begin
           update_data = effective_rdata;
        end
        READ_CLEAR: begin
           update_data = '0;
        end
        WRITE: begin
           update_data = r_sb[r_sb_upd_ptr].req_data;
        end
        COUNT: begin
           update_data = count_update_data;
        end
      endcase

      v_update_sb = 1'b0;
      aw_valid = 1'b0;
      rsp_valid = 1'b0;
      r_ready = 1'b0;
      if (r_sb_val[r_sb_upd_ptr]) begin
         if (r_sb[r_sb_upd_ptr].op == WRITE) begin
            if (!r_write_done) begin
               aw_valid = 1'b1;
               if (aw_ready)
                 c_write_done = 1'b1;
            end

            if (!r_rsp_done) begin
               rsp_valid = 1'b1;
               if (rsp_ready)
                 c_rsp_done = 1'b1;
            end

            if (c_write_done && c_rsp_done) begin
               v_update_sb = 1'b1;
               c_write_done = 1'b0;
               c_rsp_done = 1'b0;
            end
         end
         else if ((r_sb[r_sb_upd_ptr].match != '0) || r_valid) begin
            if (r_sb[r_sb_upd_ptr].op == READ) begin
               rsp_valid = 1'b1;
               if (rsp_ready) begin
                  v_update_sb = 1'b1;
                  r_ready = r_sb[r_sb_upd_ptr].match == '0;
               end
            end
            else begin
               if (!r_write_done) begin
                  aw_valid = 1'b1;
                  if (aw_ready)
                    c_write_done = 1'b1;
               end
               
               if (!r_rsp_done) begin
                  rsp_valid = 1'b1;
                  if (rsp_ready)
                    c_rsp_done = 1'b1;
               end
               
               if (c_write_done && c_rsp_done) begin
                  v_update_sb = 1'b1;
                  r_ready = r_sb[r_sb_upd_ptr].match == '0;
                  c_write_done = 1'b0;
                  c_rsp_done = 1'b0;
               end
            end
         end
      end
      
      
      if (v_update_sb) begin
         c_sb[r_sb_upd_ptr].data = update_data;
         c_sb[r_sb_upd_ptr].update_done = 1'b1;
         if (r_sb_upd_ptr == (N_OUTSTANDING_RMW-1))
           c_sb_upd_ptr = '0;
         else
           c_sb_upd_ptr = r_sb_upd_ptr + 1;
      end

      
      

      ar_valid = 1'b0;
      req_ready = 1'b0;
      v_match = '0;
      if (req_valid && (!sb_full || sb_ren)) begin
         if (req_op != WRITE) begin
            
            
            
            for (int i=0; i<N_OUTSTANDING_RMW; i++) begin
               if (c_sb_val[i] && (r_sb[i].op!=READ)) begin
                  if (r_sb[i].addr == req_addr) begin
                     v_match[i] = 1'b1;
                  end
               end
            end
         
            
            
            
            v_match = `ROTATE_RIGHT(v_match, sb_wptr); 
            
            
            for (int i=0; i<N_OUTSTANDING_RMW; i++) begin
               if (v_match[i])
                 v_match &= N_OUTSTANDING_RMW'(~((1<<i)-1)); 
            end
            
            
            v_match = `ROTATE_LEFT(v_match, sb_wptr);  

            if (v_match == '0) begin
               
               ar_valid = 1'b1;
               if (ar_ready)
                 req_ready = 1'b1;
            end
            else begin
               
               req_ready = 1'b1;
            end
         end
         else
           req_ready = 1'b1;
      end

      
      sb_wen = 1'b0;
      if (req_valid & req_ready) begin

         sb_wen = 1'b1;

         assert #0 (!c_sb_val[sb_wptr]) else `ERROR("we should NEVER overwrite a valid scoreboard entry");

         c_sb[sb_wptr].op = req_op;
         c_sb[sb_wptr].id = req_id;
         c_sb[sb_wptr].addr = req_addr;
         c_sb[sb_wptr].req_data = req_data;
         c_sb[sb_wptr].update_done = 1'b0;
         
         c_sb_val[sb_wptr] = 1'b1;
         
         c_sb[sb_wptr].match = v_match; 
      end
      
      

   end 

   generate
      genvar i;
      for (i=0; i<N_COUNTERS_PER_ENTRY; i++) begin
         always_comb begin
            reg v_carry;
            {v_carry, count_update_data[COUNTER_LSB_OFFSET[i] +: (COUNTER_LSB_OFFSET[i+1]-COUNTER_LSB_OFFSET[i])]} = effective_rdata[COUNTER_LSB_OFFSET[i] +: (COUNTER_LSB_OFFSET[i+1]-COUNTER_LSB_OFFSET[i])] + r_sb[r_sb_upd_ptr].req_data[COUNTER_LSB_OFFSET[i] +: COUNTER_ADD_WIDTH[i]];
            if (v_carry) begin
               count_update_data[COUNTER_LSB_OFFSET[i] +: (COUNTER_LSB_OFFSET[i+1]-COUNTER_LSB_OFFSET[i])] = '1;
            end
         end
      end
`ifndef SYNTHESIS
      for (i=0; i<N_OUTSTANDING_RMW; i++) begin
         `COVER_PROPERTY(sb_wen && c_sb[sb_wptr].match[i]);
      end
`endif
   endgenerate

   always_ff@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         r_rsp_done <= 0;
         r_sb_upd_ptr <= 0;
         r_sb_val <= 0;
         r_write_done <= 0;
         
      end
      else begin
         r_sb_val <= c_sb_val;
         r_sb_upd_ptr <= c_sb_upd_ptr;
         r_write_done <= c_write_done;
         r_rsp_done <= c_rsp_done;
      end
   end

   
   always_ff@(posedge clk) begin
      r_sb <= c_sb;
   end
   
   

endmodule 







