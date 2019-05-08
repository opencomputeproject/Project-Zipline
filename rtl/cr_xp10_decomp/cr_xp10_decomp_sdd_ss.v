/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"
`include "axi_reg_slice_defs.vh"
`include "messages.vh"

module cr_xp10_decomp_sdd_ss (
   
   ss_ld_ready, ss_sp_valid, ss_sp_data, sdd_lfa_ack_valid,
   sdd_lfa_ack_bus,
   
   clk, rst_n, ld_ss_valid, ld_ss_data, sp_ss_ready
   );

   import crPKG::*;
   
   
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   
   
   
   input         clk;
   input         rst_n; 
   
   
   
   
   input         ld_ss_valid;
   input         sdd_ld_pipe_t ld_ss_data;
   output logic  ss_ld_ready;

   
   
   
   output logic  ss_sp_valid;
   output        sdd_ss_pipe_t ss_sp_data;
   input         sp_ss_ready;
   
   
   
   
   output logic  sdd_lfa_ack_valid;
   output        sdd_lfa_ack_bus_t sdd_lfa_ack_bus;

   

   
   
   
`define DECLARE_RESET_FLOP(name, reset_val) \
   r_``name, c_``name; \
   always_ff@(posedge clk or negedge rst_n)    \
     if (!rst_n) \
       r_``name <= reset_val; \
     else \
       r_``name <= c_``name
`define DECLARE_FLOP(name) \
   r_``name, c_``name; \
   always_ff@(posedge clk) r_``name <= c_``name 
`define DEFAULT_FLOP(name) c_``name = r_``name

   typedef enum  logic [1:0] {NORMAL, DEFLATE_EOB, ERROR} selector_state_e;
   selector_state_e `DECLARE_RESET_FLOP(selector_state, NORMAL); 
   logic [`BIT_VEC(8)] `DECLARE_RESET_FLOP(selector_idx_mod_256, 0);
   sdd_error_e    `DECLARE_RESET_FLOP(selector_errcode, INVALID_SYMBOL);

   logic          `DECLARE_RESET_FLOP(sent_eob, 0);
   logic          `DECLARE_RESET_FLOP(sent_eof, 0);
   logic          `DECLARE_RESET_FLOP(sent_sob, 0);
   
   logic          `DECLARE_RESET_FLOP(selector_reg_valid, 0);
   sdd_ld_pipe_t  `DECLARE_FLOP(selector_reg);


   logic          pipe_src_valid;
   logic          pipe_src_ready;
   sdd_ss_pipe_t  pipe_src_data;
   
   logic          pipe_dst_valid;
   logic          pipe_dst_ready;
   sdd_ss_pipe_t  pipe_dst_data;

   

   always_comb begin
      `DEFAULT_FLOP(selector_idx_mod_256);
      `DEFAULT_FLOP(selector_state);
      `DEFAULT_FLOP(selector_errcode);
      `DEFAULT_FLOP(selector_reg);
      `DEFAULT_FLOP(selector_reg_valid);
      `DEFAULT_FLOP(sent_eob);
      `DEFAULT_FLOP(sent_eof);
      `DEFAULT_FLOP(sent_sob);

      ss_ld_ready = 0;
      pipe_src_valid = 0;
      pipe_src_data = '0;

      pipe_src_data.frame_bytes_in = r_selector_reg.meta.frame_bytes_in;
      pipe_src_data.last_frame = r_selector_reg.meta.last_frame;

      
      for (int i=0; i<4; i++) begin
         pipe_src_data.symbols[i].fmt = r_selector_reg.meta.fmt;
         pipe_src_data.symbols[i].min_ptr_len = r_selector_reg.meta.min_ptr_len;
         pipe_src_data.symbols[i].min_mtf_len = r_selector_reg.meta.min_mtf_len;
         pipe_src_data.symbols[i].trace_bit = r_selector_reg.meta.trace_bit;
      end

      if (r_selector_reg_valid) begin
         if (r_sent_eob ||
             (r_selector_state != NORMAL) ||
             (r_selector_reg.meta.numbits == 0)) begin
            
            
            
            
            
            
            
            
            
            c_selector_reg_valid = 0;

            if (r_selector_reg.meta.eob && !r_sent_eob) begin
               pipe_src_valid = 1;
               pipe_src_data.eob = 1;
               c_sent_eob = 1;
            end
            
         end 
         else if (r_selector_idx_mod_256[7:5] != r_selector_reg.meta.word_mod_8) begin
            
            c_selector_reg_valid = 0;
         end
         else if ((r_selector_reg.meta.numbits <= 32) || ld_ss_valid) begin
            
            sdd_ld_lane_state_t [31:0] v_lanes;
            logic [31:0][`BIT_VEC($clog2(N_SDD_BIT_BUF_WORDS*32)+1)] v_start_idxs;
            logic [6:0]                                              v_total_length;
            logic [31:0]                                             v_window;
            logic [4:0]                                              v_idx_mod_32;
            logic                                                    v_terminate;
            
            v_window = ('1 << r_selector_idx_mod_256[4:0]);

            
            for (int i=0; i<32; i++) begin
               if (v_window[i]) begin
                  v_lanes[i] = r_selector_reg.lane_state[i];
                  v_start_idxs[i] = {r_selector_reg.meta.buf_idx, i[4:0]}; 
               end
               else begin
                  v_lanes[i] = ld_ss_data.lane_state[i];
                  v_start_idxs[i] = {ld_ss_data.meta.buf_idx, i[4:0]}; 
               end
            end

            
            
            
            
            

            v_total_length = 0;

            v_terminate = 0;

            v_idx_mod_32 = r_selector_idx_mod_256[4:0];

            for (int i=0; i<4; i++) begin
               sdd_ld_lane_state_t v_lane; 

               if (i==0)
                 v_lane = r_selector_reg.lane_state[v_idx_mod_32];
               else
                 v_lane = v_lanes[v_idx_mod_32];

               pipe_src_data.symbols[i].ss_length = v_lane.ss_length;
               pipe_src_data.symbols[i].ss_sym = v_lane.ss_sym;
               pipe_src_data.symbols[i].ll_exists = v_lane.ll_exists;
               pipe_src_data.symbols[i].ll_sym = v_lane.ll_sym;
               pipe_src_data.symbols[i].aggregate_length = v_lane.aggregate_length;
               pipe_src_data.symbols[i].start_idx = v_start_idxs[v_idx_mod_32];
               pipe_src_data.symbols[i].symbol_type = v_lane.symbol_type;

               v_idx_mod_32 = v_lane.end_idx[4:0];

               if (!v_terminate) begin
                  c_selector_idx_mod_256 = v_lane.end_idx;

                  pipe_src_data.eob = v_lane.eob;
                  pipe_src_data.err = v_lane.error;
                  pipe_src_data.valid_symbols[i] = !v_lane.error;
                  c_selector_errcode = v_lane.sdd_errcode;
                  pipe_src_data.sdd_errcode = v_lane.sdd_errcode;
                  
                  if (v_lane.error)
                    c_selector_state = ERROR;
                  else if(v_lane.symbol_type == EOB)
                    c_selector_state = DEFLATE_EOB;
                  
                  v_terminate = v_lane.eob;
               end

               
               if (v_lane.aggregate_length[6:5] != 0)
                 v_terminate = 1;
               
               v_total_length += v_lane.aggregate_length[4:0]; 
               if (v_total_length[5])
                 v_terminate = 1;
            end 

            c_sent_eob = pipe_src_data.eob;

            pipe_src_valid = 1;

            if ((c_selector_idx_mod_256[7:5] != r_selector_idx_mod_256[7:5]) ||
                pipe_src_data.eob)
              c_selector_reg_valid = 0;

         end 


         
         if (r_selector_reg.meta.eof && !c_sent_eof &&
             ((r_selector_reg.meta.errcode != NO_ERRORS) || c_sent_eob)) begin
            c_selector_reg_valid = 0;

            pipe_src_valid = 1;
            c_sent_eof = 1;
            pipe_src_data.eof = 1;
            if ((r_selector_reg.meta.errcode != NO_ERRORS) || (r_selector_state == ERROR))
              pipe_src_data.err = 1;
            
            pipe_src_data.eof_errcode = r_selector_reg.meta.errcode;
            pipe_src_data.sdd_errcode = c_selector_errcode;
            
            if (!c_sent_eob) begin
               c_sent_eob = 1;
               pipe_src_data.eob = 1;
            end
         end 

         
         
         
         if ((c_sent_eob || r_selector_state!=NORMAL) && !c_selector_reg_valid && (pipe_src_data.valid_symbols==0)) begin
            pipe_src_valid = 1;
            pipe_src_data.valid_symbols = 1;
            pipe_src_data.symbols[0].symbol_type = BUF_IDX_ADV;
            pipe_src_data.symbols[0].start_idx = r_selector_reg.meta.buf_idx << 5;
            pipe_src_data.symbols[0].aggregate_length = 32;
            c_selector_idx_mod_256 = (r_selector_reg.meta.word_mod_8 + 1) << 5;
         end

         
         assert #0 (!pipe_src_valid || (pipe_src_data.valid_symbols != 0) || pipe_src_data.eob || pipe_src_data.eof) else `ERROR("should have consumed at least 1 symbol or generate eob/eof");

         
         if (pipe_src_valid) begin
            if (r_selector_reg.meta.sob && !r_sent_sob) begin
               pipe_src_data.sob = 1;
               c_sent_sob = 1;
            end
         end

         if (pipe_src_valid) begin
            if (pipe_src_data.eob) begin
               c_sent_sob = 0;
            end
         end

      end 

      
      if (pipe_src_valid && !pipe_src_ready) begin
         
         `DEFAULT_FLOP(selector_idx_mod_256);
         `DEFAULT_FLOP(selector_state);
         `DEFAULT_FLOP(selector_errcode);
         `DEFAULT_FLOP(selector_reg);
         `DEFAULT_FLOP(selector_reg_valid);
         `DEFAULT_FLOP(sent_eob);
         `DEFAULT_FLOP(sent_eof);
         `DEFAULT_FLOP(sent_sob);
      end

      
      ss_ld_ready = 0;
      if (ld_ss_valid && !c_selector_reg_valid) begin
         c_selector_reg_valid = 1;
         c_selector_reg = ld_ss_data;
         ss_ld_ready = 1;
         
         if (ld_ss_data.meta.sob) begin
            if (c_sent_eof || (r_selector_state == DEFLATE_EOB)) begin 
               c_selector_state = NORMAL;
            end

            
            c_selector_idx_mod_256 = ld_ss_data.meta.word_mod_8 << 5;
            c_sent_eob = 0;
            c_sent_eof = 0;
         end
      end

   end 

   logic `DECLARE_RESET_FLOP(sdd_lfa_ack_valid, 0);
   sdd_lfa_ack_bus_t `DECLARE_RESET_FLOP(sdd_lfa_ack_bus, '0);
   logic `DECLARE_RESET_FLOP(sent_eob_ack, 0);
   assign sdd_lfa_ack_valid = r_sdd_lfa_ack_valid;
   assign sdd_lfa_ack_bus = r_sdd_lfa_ack_bus;

   
   always_comb begin
      c_sdd_lfa_ack_valid = 0;
      `DEFAULT_FLOP(sdd_lfa_ack_bus);
      `DEFAULT_FLOP(sent_eob_ack);

      pipe_dst_ready = 0;

      ss_sp_valid = 0;
      ss_sp_data = pipe_dst_data;

      if (pipe_dst_valid) begin
         ss_sp_valid = 1;

         if (pipe_dst_data.sob)
           c_sent_eob_ack = 0;

         if (sp_ss_ready) begin

            c_sdd_lfa_ack_bus.numbits = 0;
            for (int i=0; i<4; i++)
               c_sdd_lfa_ack_bus.numbits += {7{pipe_dst_data.valid_symbols[i] && (pipe_dst_data.symbols[i].symbol_type != BUF_IDX_ADV)}} & pipe_dst_data.symbols[i].aggregate_length; 
            
            c_sdd_lfa_ack_bus.eob = pipe_dst_data.eob;
            c_sdd_lfa_ack_bus.err = pipe_dst_data.err;

            pipe_dst_ready = 1;

            
            if (!c_sent_eob_ack) begin
               if ((pipe_dst_data.symbols[0].fmt inside {HTF_FMT_DEFLATE_DYNAMIC, HTF_FMT_DEFLATE_FIXED}) &&
                   (pipe_dst_data.eob || pipe_dst_data.err || (c_sdd_lfa_ack_bus.numbits != 0)) &&
                   !pipe_dst_data.eof)
                 c_sdd_lfa_ack_valid = 1;
            end

            c_sent_eob_ack = pipe_dst_data.eob;

         end 

      end 
   end 

   axi_channel_reg_slice
     #(.PAYLD_WIDTH($bits(sdd_ss_pipe_t)),
       .HNDSHK_MODE(`AXI_RS_FWD))
   u_reg_slice
     (.aclk (clk),
      .aresetn (rst_n),
      .valid_src(pipe_src_valid),
      .ready_src(pipe_src_ready),
      .payload_src(pipe_src_data),
      .valid_dst(pipe_dst_valid),
      .ready_dst(pipe_dst_ready),
      .payload_dst(pipe_dst_data));
   
`undef DECLARE_RESET_FLOP
`undef DECLARE_FLOP
`undef DEFAULT_FLOP   

endmodule 







