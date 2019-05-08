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

module cr_xp10_decomp_sdd_sp (
   
   sp_ss_ready, sdd_mtf_dp_valid, sdd_mtf_dp_bus, sp_buf_idx, mtf_stb,
   sched_info_ren, xp10_decomp_sch_update,
   
   clk, rst_n, ss_sp_valid, ss_sp_data, mtf_sdd_dp_ready, ld_bit_buf,
   sched_info_rdata, su_afull_n
   );

   import crPKG::*;
   
   
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   
   
   
   input         clk;
   input         rst_n;    
   
   
   
   input         ss_sp_valid;
   input         sdd_ss_pipe_t ss_sp_data;
   output logic  sp_ss_ready;

   
   
   
   output logic  sdd_mtf_dp_valid;
   
   output        lz_symbol_bus_t sdd_mtf_dp_bus;
   input         mtf_sdd_dp_ready;

   
   
   
   input [`BIT_VEC(N_SDD_BIT_BUF_WORDS)][31:0] ld_bit_buf;
   output [`BIT_VEC($clog2(N_SDD_BIT_BUF_WORDS)+1)] sp_buf_idx;

   
   output logic [3:0]                          mtf_stb;

   
   
   
   output logic                                sched_info_ren;
   input                                       sched_info_t sched_info_rdata;

   
   
   
   output                               sched_update_if_bus_t xp10_decomp_sch_update;
   input                                su_afull_n;
   
   


   
   
   
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
`define DECLARE_RESET_OUT_FLOP(name, reset_val) \
   `DECLARE_RESET_FLOP(name, reset_val); \
   assign name = r_``name

   
   
   logic sdd_1_lit_stb;
   logic sdd_2_lit_stb;
   logic sdd_3_lit_stb;
   logic sdd_4_lit_stb;
   logic sdd_1_mtf_stb;
   logic sdd_1_mtf_1_lit_stb;
   logic sdd_1_mtf_2_lit_stb;
   logic sdd_1_mtf_3_lit_stb;
   logic sdd_1_ptr_stb;
   logic sdd_1_ptr_1_lit_stb;
   logic sdd_1_ptr_2_lit_stb;
   logic sdd_1_ptr_3_lit_stb;
   logic [`BIT_VEC(`N_XP10_64K_SHRT_SYMBOLS)] xp_short_stb;
   logic [`BIT_VEC(`N_XP10_64K_LONG_SYMBOLS)] xp_long_stb;
   logic [`BIT_VEC(`N_LENLIT_SYMBOLS-2)]      deflate_lenlit_stb; 
   logic [`BIT_VEC(`N_DIST_SYMBOLS)]          deflate_dist_stb;
   

   logic [3:0]  `DECLARE_RESET_OUT_FLOP(mtf_stb, 0);
   logic [`BIT_VEC($clog2(N_SDD_BIT_BUF_WORDS)+1)] `DECLARE_RESET_OUT_FLOP(sp_buf_idx, 0);


   logic [2:0]                           packer_src_items_valid;
   sdd_ss_partial_symbol_t [5:0]         packer_src_data;
   logic                                 packer_src_ready;
   
   logic [2:0]                           packer_dst_items_avail;
   logic [2:0]                           packer_dst_items_consume;
   sdd_ss_partial_symbol_t [4:0]         packer_dst_data; 

   typedef struct packed {
      zipline_error_e errcode;
      logic [27:0] frame_bytes_in;
      logic        last_frame;
   } eof_fifo_t;

   logic [`BIT_VEC(`SU_BYTES_WIDTH+3)]    `DECLARE_RESET_FLOP(frame_bits_in, 0);
   logic [`BIT_VEC(`SU_BYTES_WIDTH+3)]    `DECLARE_RESET_FLOP(bits_in, 0);
   logic [`BIT_VEC(`SU_BYTES_WIDTH)]      `DECLARE_RESET_FLOP(bytes_out, 0);
   logic                                  `DECLARE_RESET_FLOP(at_least_1_byte_out, 0);
   sched_update_if_bus_t `DECLARE_RESET_OUT_FLOP(xp10_decomp_sch_update, 0);
   sched_update_if_bus_t `DECLARE_RESET_FLOP(last_sch_update, 0);
   logic           `DECLARE_RESET_FLOP(su_afull_n, 0);

   logic      eof_fifo_full;
   logic      eof_fifo_ren;
   logic      eof_fifo_wen;
   eof_fifo_t eof_fifo_wdata;
   eof_fifo_t eof_fifo_rdata;

         

   logic [`BIT_VEC(N_SDD_BIT_BUF_WORDS*2*32)]    bit_buf;
   assign bit_buf = {2{ld_bit_buf}};
   

   
   always_comb begin
      logic [2:0] v_symbol_count;
      logic       v_found_eob;

      packer_src_items_valid = 0;
      packer_src_data = '0;
      packer_src_data[3:0] = ss_sp_data.symbols;

      eof_fifo_wen = 0;
      eof_fifo_wdata = 0;
      eof_fifo_wdata.errcode = NO_ERRORS;

      v_symbol_count = 0;
      v_found_eob = 0;

      for (int i=0; i<4; i++) begin
         v_symbol_count += ss_sp_data.valid_symbols[i]; 
         if (ss_sp_data.valid_symbols[i] && (ss_sp_data.symbols[i].symbol_type == EOB))
           v_found_eob = 1;
      end
      
      if (ss_sp_data.eob && !v_found_eob) begin
         packer_src_data[v_symbol_count].symbol_type = EOB; 
         packer_src_data[v_symbol_count].aggregate_length = 0; 
         v_symbol_count++;
      end

      if (ss_sp_data.eof) begin
         packer_src_data[v_symbol_count].symbol_type = EOF; 
         packer_src_data[v_symbol_count].aggregate_length = 0; 
         v_symbol_count++;
      end

      sp_ss_ready = 0;

      if (ss_sp_valid && (!ss_sp_data.eof || !eof_fifo_full)) begin
         assert #0 ((ss_sp_data.valid_symbols!=0) || ss_sp_data.eob || ss_sp_data.eof) else `ERROR("packer shouldn't get anything if there are no symbols");
         
         packer_src_items_valid = v_symbol_count;
         if (packer_src_ready) begin
            sp_ss_ready = 1;

            
            eof_fifo_wen = ss_sp_data.eof;
            eof_fifo_wdata.frame_bytes_in = ss_sp_data.frame_bytes_in;
            eof_fifo_wdata.last_frame = ss_sp_data.last_frame;
            assert #0 (ss_sp_data.err || (ss_sp_data.eof_errcode == NO_ERRORS)) else `ERROR("eof_errcode and err flag are inconsistent");
            if (ss_sp_data.err) begin
               if (ss_sp_data.eof_errcode == NO_ERRORS) begin
                  case (ss_sp_data.sdd_errcode)
                    INVALID_SYMBOL: eof_fifo_wdata.errcode = HD_SDD_INVALID_SYMBOL;
                    END_MISMATCH: eof_fifo_wdata.errcode = HD_SDD_END_MISMATCH;
                    MISSING_EOB_SYM: eof_fifo_wdata.errcode = HD_SDD_MISSING_EOB_SYM;
                    ILLEGAL_HUFFTREE: eof_fifo_wdata.errcode = HD_HTF_ILLEGAL_HUFFTREE;
                  endcase
               end
               else
                 eof_fifo_wdata.errcode = ss_sp_data.eof_errcode; 
            end 
         end 
      end 
   end 

   typedef struct packed {
      logic       update_buf_idx;
      logic [`BIT_VEC($clog2(N_SDD_BIT_BUF_WORDS)+1)] end_buf_idx;           
      logic [8:0] consumed_bits;                                             
      logic       eob;                                                       
      logic       eof;                                                       
      htf_fmt_e fmt;                                                         
      logic       min_ptr_len;                                               
      logic       min_mtf_len;                                               
      logic       trace_bit;                                                 
      zipline_error_e errcode;                                                
      logic [2:0] symbol_count;                                              
      logic       backref;                                                   
      logic       backref_type;                                              
      logic [`BIT_VEC($clog2(N_SDD_BIT_BUF_WORDS*32)+1)] backref_idx;        
      logic [1:0] backref_lane;                                              
      logic [15:0] backref_extra_length;                                     
      logic [7:0]  backref_distance_msb;                                     
      logic [3:0][`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] ss_sym;                
      logic [`LOG_VEC(`N_MAX_HUFF_BITS+1)]            ss_length;             
      logic                                           ll_exists;             
      logic [`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)]      ll_sym;                
      logic [`LOG_VEC(`N_XP10_64K_LONG_SYMBOLS)]      ll_length;             
      logic [6:0]                                     aggregate_length;      
      logic [3:0]                                     extra_length_bits;     
      logic [3:0]                                     extra_distance_bits;   
      logic [`BIT_VEC(`N_MAX_HUFF_BITS*2+30)]         aggregate_symbol_bits; 
      logic [8:0]                                     base_length;           
   } sdd_sp_pipe_t;

   localparam POST_PACKER_STAGES = 3;

   logic [POST_PACKER_STAGES:1] pipe_src_valid;
   logic [POST_PACKER_STAGES:1] pipe_src_ready;
   sdd_sp_pipe_t    pipe_src_data[POST_PACKER_STAGES:1];

   logic [POST_PACKER_STAGES:1] pipe_dst_valid;
   logic [POST_PACKER_STAGES:1] pipe_dst_ready;
   sdd_sp_pipe_t    pipe_dst_data[POST_PACKER_STAGES:1]; 

   logic         outreg_valid;
   lz_symbol_bus_t outreg_bus;
   
   logic         outreg_ready;

   always_comb begin
      logic [`LOG_VEC(`N_XP10_64K_SHRT_SYMBOLS)] v_ss_sym;
      integer N;
      logic [5:0] v_extra_length_shift;
      logic [3:0] v_dst_items_avail_bitmap;
      logic       v_found_backref;
      logic       v_stop;
      logic       v_inc_symbol;
      logic       v_consume_symbol;
      logic       v_consume_bits;
      logic [1:0] v_min_len_base;
      logic       v_min_len_add;
      logic       v_dst_items_nsym;

      `DEFAULT_FLOP(frame_bits_in);
      `DEFAULT_FLOP(bits_in);
      `DEFAULT_FLOP(bytes_out);
      `DEFAULT_FLOP(at_least_1_byte_out);
      `DEFAULT_FLOP(last_sch_update);
      `DEFAULT_FLOP(sp_buf_idx);

      c_xp10_decomp_sch_update = 0;
      c_su_afull_n = su_afull_n;

      v_inc_symbol = 0;
      v_min_len_base = 0;
      v_min_len_add = 0;

      
      

      N = 1;

      packer_dst_items_consume = 0;
      pipe_src_valid[N] = 0;
      pipe_src_data[N] = '0;

      pipe_src_data[N].fmt = packer_dst_data[0].fmt;
      pipe_src_data[N].min_ptr_len = packer_dst_data[0].min_ptr_len;
      pipe_src_data[N].min_mtf_len = packer_dst_data[0].min_mtf_len;
      pipe_src_data[N].trace_bit = packer_dst_data[0].trace_bit;
      
      v_dst_items_avail_bitmap = ~('1 << packer_dst_items_avail);
      v_dst_items_nsym = 0;
      for (int i=0; i<3; i++)
        v_dst_items_nsym |= v_dst_items_avail_bitmap[i] && !(packer_dst_data[i].symbol_type inside {LITERAL, MATCH}); 
      
      if ((packer_dst_items_avail >= 4) || v_dst_items_nsym) begin
         v_found_backref = 0;
         v_stop = 0;
         for (int i=0; i<4; i++) begin
            v_inc_symbol = 0;
            v_consume_symbol = 0;
            v_consume_bits = 0;
            if (v_dst_items_avail_bitmap[i] && !v_stop) begin
               pipe_src_valid[N] = 1;
               
               case (packer_dst_data[i].symbol_type)
                 BUF_IDX_ADV: begin
                    v_consume_symbol = 1;
                    v_stop = 1;
                 end
                 EOB: begin
                    pipe_src_data[N].eob = 1;

                    v_consume_bits = 1;
                    v_consume_symbol = 1;
                    v_stop = 1;
                 end
                 EOF: begin
                    pipe_src_data[N].eof = 1;
                    v_consume_symbol = 1;
                    v_stop = 1;
                 end
                 MATCH: begin
                    if (v_found_backref) 
                      v_stop = 1;
                    else begin
                       v_found_backref = 1;
                       pipe_src_data[N].backref = 1;
                       pipe_src_data[N].backref_lane = i;
                       pipe_src_data[N].backref_idx =  packer_dst_data[i].start_idx;
                       pipe_src_data[N].aggregate_length = packer_dst_data[i].aggregate_length;
                       pipe_src_data[N].ss_sym[i] = packer_dst_data[i].ss_sym;
                       pipe_src_data[N].ss_length = packer_dst_data[i].ss_length;
                       pipe_src_data[N].ll_exists = packer_dst_data[i].ll_exists;
                       pipe_src_data[N].ll_sym = packer_dst_data[i].ll_sym;
                       
                       v_consume_bits = 1;
                       v_inc_symbol = 1;
                       v_consume_symbol = 1;
                    end
                 end 
                 LITERAL: begin
                    pipe_src_data[N].ss_sym[i] = packer_dst_data[i].ss_sym;

                    v_consume_bits = 1;
                    v_inc_symbol = 1;
                    v_consume_symbol = 1;
                 end
               endcase 
               
               packer_dst_items_consume +=  v_consume_symbol; 
               
               pipe_src_data[N].symbol_count += v_inc_symbol; 

               
               
               
               if (v_consume_symbol && (packer_dst_data[i].aggregate_length != 0)) begin
                  pipe_src_data[N].update_buf_idx = 1;
                  if ((packer_dst_data[i].start_idx[`LOG_VEC(N_SDD_BIT_BUF_WORDS*32)] + packer_dst_data[i].aggregate_length) < (N_SDD_BIT_BUF_WORDS*32))
                    pipe_src_data[N].end_buf_idx  = ((packer_dst_data[i].start_idx[`LOG_VEC(N_SDD_BIT_BUF_WORDS*32)] + packer_dst_data[i].aggregate_length) >> 5) | (packer_dst_data[i].start_idx[$clog2(N_SDD_BIT_BUF_WORDS*32)] << $clog2(N_SDD_BIT_BUF_WORDS));
                  else
                    pipe_src_data[N].end_buf_idx = ((packer_dst_data[i].start_idx[`LOG_VEC(N_SDD_BIT_BUF_WORDS*32)] + packer_dst_data[i].aggregate_length - (N_SDD_BIT_BUF_WORDS*32)) >> 5) | (~packer_dst_data[i].start_idx[$clog2(N_SDD_BIT_BUF_WORDS*32)] << $clog2(N_SDD_BIT_BUF_WORDS));
                  
               end

               if (v_consume_bits)
                 pipe_src_data[N].consumed_bits += packer_dst_data[i].aggregate_length; 
            end 
         end 
      end 

      
      if ((packer_dst_items_avail == 5) && 
          (pipe_src_data[N].symbol_count == 4) &&
          (packer_dst_data[4].symbol_type == EOB)) begin
         pipe_src_data[N].eob = 1;
         pipe_src_data[N].consumed_bits += packer_dst_data[4].aggregate_length; 
         packer_dst_items_consume = 5;
      end

      if (!pipe_src_ready[N]) begin
         
         packer_dst_items_consume = 0;
      end

      for (int i=2; i<=POST_PACKER_STAGES; i++) begin
         pipe_src_data[i] = pipe_dst_data[i-1];
         pipe_src_valid[i] = pipe_dst_valid[i-1];
         pipe_dst_ready[i-1] = pipe_src_ready[i];
      end

      
      
      

      N = 2;

      v_ss_sym = pipe_src_data[N].ss_sym[pipe_src_data[N].backref_lane];

      if (pipe_src_data[N].fmt inside {HTF_FMT_DEFLATE_DYNAMIC, HTF_FMT_DEFLATE_FIXED}) begin
         pipe_src_data[N].extra_distance_bits = HDIST_EXTRA_BITS[pipe_src_data[N].ll_sym[4:0]];
         pipe_src_data[N].extra_length_bits = 4'(HLIT_EXTRA_BITS[v_ss_sym[4:0]]);
      end
      else begin
         
         if (v_ss_sym > 319) begin
            pipe_src_data[N].extra_distance_bits = 4'(v_ss_sym[9:4] - 20);
         end
         else if (v_ss_sym > 255)
           pipe_src_data[N].backref_type = 1; 

         
         if (pipe_src_data[N].ll_exists && pipe_src_data[N].ll_sym > 231)
           pipe_src_data[N].extra_length_bits = 4'(pipe_src_data[N].ll_sym - 232);
      end 

      
      pipe_src_data[N].ll_length = pipe_src_data[N].aggregate_length - pipe_src_data[N].extra_length_bits - pipe_src_data[N].extra_distance_bits - pipe_src_data[N].ss_length;
      
      
      pipe_src_data[N].aggregate_symbol_bits = bit_buf[pipe_src_data[N].backref_idx[`LOG_VEC(N_SDD_BIT_BUF_WORDS*32)] +: (`N_MAX_HUFF_BITS*2+30)]; 

      if (pipe_src_valid[N] && pipe_src_ready[N] && pipe_src_data[N].update_buf_idx)
        c_sp_buf_idx = pipe_src_data[N].end_buf_idx;

      
      
      
      

      N = 3;

      sdd_1_lit_stb = 0;
      sdd_2_lit_stb = 0;
      sdd_3_lit_stb = 0;
      sdd_4_lit_stb = 0;
      sdd_1_mtf_stb = 0;
      sdd_1_mtf_1_lit_stb = 0;
      sdd_1_mtf_2_lit_stb = 0;
      sdd_1_mtf_3_lit_stb = 0;
      sdd_1_ptr_stb = 0;
      sdd_1_ptr_1_lit_stb = 0;
      sdd_1_ptr_2_lit_stb = 0;
      sdd_1_ptr_3_lit_stb = 0;
      xp_short_stb = 0;
      xp_long_stb = 0;
      deflate_lenlit_stb = 0;
      deflate_dist_stb = 0;
      c_mtf_stb = 0;

      if (pipe_src_valid[N] && !pipe_src_data[N].eof && !pipe_src_data[N].eob && (pipe_src_data[N].symbol_count==0)) begin
         pipe_src_valid[N] = 0;
         pipe_dst_ready[N-1] = 1;
      end

      if (pipe_src_valid[N] && pipe_src_ready[N]) begin
         if (pipe_src_data[N].symbol_count != 0) begin
            logic [2:0][4:1] v_event_stbs;
            logic [1:0] v_group;
            
            if (pipe_src_data[N].backref) begin
               if (pipe_src_data[N].backref_type)
                 v_group = 2;
               else
                 v_group = 1;
            end
            else
              v_group = 0;

            v_event_stbs = '0;
            v_event_stbs[v_group][pipe_src_data[N].symbol_count] = 1; 
            
            {sdd_1_mtf_3_lit_stb,
             sdd_1_mtf_2_lit_stb,
             sdd_1_mtf_1_lit_stb,
             sdd_1_mtf_stb,
             sdd_1_ptr_3_lit_stb,
             sdd_1_ptr_2_lit_stb,
             sdd_1_ptr_1_lit_stb,
             sdd_1_ptr_stb,
             sdd_4_lit_stb,
             sdd_3_lit_stb,
             sdd_2_lit_stb,
             sdd_1_lit_stb} = v_event_stbs;

            if (pipe_src_data[N].fmt inside {HTF_FMT_XP9, HTF_FMT_XP10}) begin
               for (int i=0; (i<4) && (i<pipe_src_data[N].symbol_count); i++)
                 xp_short_stb[pipe_src_data[N].ss_sym[i]] = 1;
               if (pipe_src_data[N].ll_exists)
                 xp_long_stb[pipe_src_data[N].ll_sym] = 1;
            end
            else if (pipe_src_data[N].fmt inside {HTF_FMT_DEFLATE_FIXED, HTF_FMT_DEFLATE_DYNAMIC}) begin
               for (int i=0; (i<4) && (i<pipe_src_data[N].symbol_count); i++)
                 deflate_lenlit_stb[pipe_src_data[N].ss_sym[i]] = 1;
               if (pipe_src_data[N].ll_exists)
                 deflate_dist_stb[pipe_src_data[N].ll_sym] = 1;
            end
         
            if (pipe_src_data[N].backref) begin
               if (pipe_src_data[N].backref_type && pipe_src_data[N].trace_bit) begin
                  c_mtf_stb[pipe_src_data[N].ss_sym[pipe_src_data[N].backref_lane][5:4]] = 1;
               end
            end
         end 
      end 

      if (pipe_src_data[N].fmt inside {HTF_FMT_DEFLATE_DYNAMIC, HTF_FMT_DEFLATE_FIXED}) begin
         
         v_extra_length_shift = 6'(pipe_src_data[N].ss_length);
      end
      else begin
         
         v_extra_length_shift = 6'(pipe_src_data[N].ss_length + pipe_src_data[N].ll_length);
      end

      if (pipe_src_data[N].extra_length_bits != 0) begin
         pipe_src_data[N].backref_extra_length
           = (16'(pipe_src_data[N].aggregate_symbol_bits >> v_extra_length_shift) &
              16'(~('1 << pipe_src_data[N].extra_length_bits))) | 
             16'(1 << pipe_src_data[N].extra_length_bits);
      end

      if (pipe_src_data[N].backref) begin
         logic [15:0]                               v_distance;

         v_ss_sym = pipe_src_data[N].ss_sym[pipe_src_data[N].backref_lane];

         v_distance = 0;
         if (pipe_src_data[N].fmt inside {HTF_FMT_DEFLATE_DYNAMIC, HTF_FMT_DEFLATE_FIXED}) begin
            pipe_src_data[N].base_length = HLIT_BASE_LENGTH[v_ss_sym[4:0]];
            v_distance = 16'(HDIST_BASE_DISTANCE[pipe_src_data[N].ll_sym[4:0]]);
         end
         else begin
            
            if (!pipe_src_data[N].ll_exists) begin
               
               pipe_src_data[N].base_length = 9'(v_ss_sym[3:0]);
            end
            else if (pipe_src_data[N].extra_length_bits != 0) begin
               
               pipe_src_data[N].base_length = 246;
            end
            else begin
               
               pipe_src_data[N].base_length = 9'(pipe_src_data[N].ll_sym + 15);
            end
         end

         
         if (pipe_src_data[N].backref_type) begin
            
            pipe_src_data[N].ss_sym[pipe_src_data[N].backref_lane] = 8'(v_ss_sym[5:4]);
         end
         else begin
            
            
            v_distance += ((pipe_src_data[N].aggregate_symbol_bits >> (pipe_src_data[N].ss_length + pipe_src_data[N].ll_length + pipe_src_data[N].extra_length_bits)) & ~('1 << pipe_src_data[N].extra_distance_bits)) | (1  << pipe_src_data[N].extra_distance_bits); 
            
            {pipe_src_data[N].backref_distance_msb, 
             pipe_src_data[N].ss_sym[pipe_src_data[N].backref_lane][7:0]} = v_distance;
         end 
         
         
      end 

      

      outreg_valid = 0;
      
      outreg_bus = '0;
      eof_fifo_ren = 0;
      sched_info_ren = 0;
      pipe_dst_ready[POST_PACKER_STAGES] = 0;

      if (pipe_dst_valid[POST_PACKER_STAGES] &&
          (r_su_afull_n || (!pipe_dst_data[POST_PACKER_STAGES].eob && !pipe_dst_data[POST_PACKER_STAGES].eof)) &&
          (!pipe_dst_data[POST_PACKER_STAGES].eob || (pipe_dst_data[POST_PACKER_STAGES].symbol_count!=0) || r_at_least_1_byte_out || pipe_src_valid[POST_PACKER_STAGES])) begin
         logic v_extra_byte;
         v_extra_byte = 0;

         
         
         
         


         outreg_valid = 1;

         if (pipe_dst_data[POST_PACKER_STAGES].eof) begin
            logic [31:0] v_data_bits;
            outreg_bus.framing = 4'hf;
            v_data_bits = 0;
            v_data_bits[`BIT_VEC($bits(zipline_error_e))] = $bits(zipline_error_e)'(eof_fifo_rdata.errcode);
            {outreg_bus.data3,
             outreg_bus.data2,
             outreg_bus.data1,
             outreg_bus.data0} = v_data_bits;
         end
         else begin
            outreg_bus.framing[3] = pipe_dst_data[POST_PACKER_STAGES].eob;

            outreg_bus.framing[2:0] = pipe_dst_data[POST_PACKER_STAGES].symbol_count;


            outreg_bus.data0 = pipe_dst_data[POST_PACKER_STAGES].ss_sym[0][7:0];            
            outreg_bus.data1 = pipe_dst_data[POST_PACKER_STAGES].ss_sym[1][7:0];            
            outreg_bus.data2 = pipe_dst_data[POST_PACKER_STAGES].ss_sym[2][7:0];            
            outreg_bus.data3 = pipe_dst_data[POST_PACKER_STAGES].ss_sym[3][7:0];

            outreg_bus.backref = pipe_dst_data[POST_PACKER_STAGES].backref;
            outreg_bus.backref_type = pipe_dst_data[POST_PACKER_STAGES].backref_type;
            outreg_bus.backref_lane = pipe_dst_data[POST_PACKER_STAGES].backref_lane;
            outreg_bus.offset_msb = pipe_dst_data[POST_PACKER_STAGES].backref_distance_msb;

            if (outreg_bus.backref) begin
               if (pipe_dst_data[POST_PACKER_STAGES].fmt inside {HTF_FMT_DEFLATE_DYNAMIC, HTF_FMT_DEFLATE_FIXED}) begin
                  v_min_len_base = 0;
                  v_min_len_add = 0;
               end
               else if ((pipe_dst_data[POST_PACKER_STAGES].fmt == HTF_FMT_XP9) && outreg_bus.backref_type) begin
                  
                  v_min_len_base = 2;
                  v_min_len_add = pipe_dst_data[POST_PACKER_STAGES].min_mtf_len;
               end
               else begin
                  v_min_len_base = 3;
                  v_min_len_add = pipe_dst_data[POST_PACKER_STAGES].min_ptr_len;
               end

               outreg_bus.length = 16'(pipe_dst_data[POST_PACKER_STAGES].backref_extra_length +
                                       pipe_dst_data[POST_PACKER_STAGES].base_length +
                                       v_min_len_base + v_min_len_add);
            end 

            if (pipe_dst_data[POST_PACKER_STAGES].eob && (pipe_dst_data[POST_PACKER_STAGES].symbol_count==0) && !r_at_least_1_byte_out) begin
               assert #0 (pipe_dst_valid[POST_PACKER_STAGES-1]) else `ERROR("can't emit EOB with no symbols until we know what the next transfer is");
               outreg_bus = '0;
               outreg_bus.framing[3] = 1;

               if (pipe_src_data[POST_PACKER_STAGES].eof) begin
                  
                  outreg_bus.framing[3:0] = 4'b1001;
                  v_extra_byte = 1;
               end
            end

         end
         
         if (outreg_ready) begin

            pipe_dst_ready[POST_PACKER_STAGES] = 1;

            if (pipe_dst_data[POST_PACKER_STAGES].eof)
              eof_fifo_ren = 1;

            
            c_bits_in += pipe_dst_data[POST_PACKER_STAGES].consumed_bits + (pipe_dst_data[POST_PACKER_STAGES].eob ? sched_info_rdata.hdr_bits_in : 0); 
            
            c_frame_bits_in += pipe_dst_data[POST_PACKER_STAGES].consumed_bits + (pipe_dst_data[POST_PACKER_STAGES].eob ? sched_info_rdata.hdr_bits_in : 0); 
            
            c_bytes_out += pipe_dst_data[POST_PACKER_STAGES].symbol_count + v_extra_byte - 1 + 
                           (pipe_dst_data[POST_PACKER_STAGES].backref ? pipe_dst_data[POST_PACKER_STAGES].backref_extra_length : 1) +
                           (pipe_dst_data[POST_PACKER_STAGES].backref ? pipe_dst_data[POST_PACKER_STAGES].base_length : 0) +
                           v_min_len_base + v_min_len_add;
            
            assert #0 (!pipe_dst_data[POST_PACKER_STAGES].eob || !pipe_dst_data[POST_PACKER_STAGES].eof) else `ERROR("can't get EOB and EOF during same symbol bus beat");

            c_at_least_1_byte_out |= |pipe_dst_data[POST_PACKER_STAGES].symbol_count; 
            
            if (pipe_dst_data[POST_PACKER_STAGES].eob) begin
               
               c_xp10_decomp_sch_update.valid = 1;
               
               c_xp10_decomp_sch_update.bytes_in = `SU_BYTES_WIDTH'(c_bits_in >> 3);
               c_bits_in[$bits(c_bits_in)-1:3] = 0;

               c_xp10_decomp_sch_update.basis = c_xp10_decomp_sch_update.bytes_in;
               c_xp10_decomp_sch_update.bytes_out = c_bytes_out;
               c_bytes_out = 0;

               c_xp10_decomp_sch_update.rqe_sched_handle = sched_info_rdata.rqe_sched_handle;
               c_xp10_decomp_sch_update.tlv_frame_num = sched_info_rdata.tlv_frame_num;
               c_xp10_decomp_sch_update.tlv_eng_id = sched_info_rdata.tlv_eng_id;
               c_xp10_decomp_sch_update.tlv_seq_num = sched_info_rdata.tlv_seq_num;

               sched_info_ren = 1;

               
               c_last_sch_update = c_xp10_decomp_sch_update;
            end
            
            if (pipe_dst_data[POST_PACKER_STAGES].eof) begin
               logic [28:0] v_tmp; 
               c_at_least_1_byte_out = 0;

               
               c_xp10_decomp_sch_update = r_last_sch_update;
               c_xp10_decomp_sch_update.bytes_in = 0;
               c_xp10_decomp_sch_update.bytes_out = 0;
               v_tmp = eof_fifo_rdata.frame_bytes_in - (r_frame_bits_in>>3);
               
               
               
               if (v_tmp[28])
                 c_xp10_decomp_sch_update.bytes_out = `SU_BYTES_WIDTH'(28'(r_frame_bits_in>>3) - eof_fifo_rdata.frame_bytes_in);
               else
                 c_xp10_decomp_sch_update.bytes_in = v_tmp[`BIT_VEC(`SU_BYTES_WIDTH)];
               
               assert #0 ((eof_fifo_rdata.errcode != NO_ERRORS) || ((eof_fifo_rdata.frame_bytes_in - (r_frame_bits_in>>3)) < (1<<`SU_BYTES_WIDTH))) else `ERROR("EOF frame_bytes_in (%0d) is too large. SDD total (%0d)", eof_fifo_rdata.frame_bytes_in, r_frame_bits_in>>3);
               assert #0 ((eof_fifo_rdata.errcode != NO_ERRORS) || (eof_fifo_rdata.frame_bytes_in >= (r_frame_bits_in>>3))) else `ERROR("EOF_frame_bytes_in (%0d) should NOT be less than SDD total (%0d)", eof_fifo_rdata.frame_bytes_in, r_frame_bits_in>>3);

               c_xp10_decomp_sch_update.basis = c_xp10_decomp_sch_update.bytes_in;
               c_xp10_decomp_sch_update.last = eof_fifo_rdata.last_frame;

               if ((c_xp10_decomp_sch_update.bytes_out==0) && (c_xp10_decomp_sch_update.bytes_in==0) && !eof_fifo_rdata.last_frame) begin
                  
                  c_xp10_decomp_sch_update.valid = 0;
               end

               c_frame_bits_in = 0;
               c_bits_in = 0;
            end
         end

      end 
   end 

   
   nx_fifo
     #(.DEPTH(4),
       .WIDTH($bits(eof_fifo_t)),
       .OVERFLOW_ASSERT(0),
       .UNDERFLOW_ASSERT(1))
   u_eof_fifo
     (
      
      .empty                            (),                      
      .full                             (eof_fifo_full),         
      .underflow                        (),                      
      .overflow                         (),                      
      .used_slots                       (),                      
      .free_slots                       (),                      
      .rdata                            (eof_fifo_rdata),        
      
      .clk                              (clk),                   
      .rst_n                            (rst_n),                 
      .wen                              (eof_fifo_wen),          
      .ren                              (eof_fifo_ren),          
      .clear                            (1'b0),                  
      .wdata                            (eof_fifo_wdata));        

   
   cr_xp10_decomp_unpacker
     #(.IN_ITEMS(6),
       .OUT_ITEMS(5),
       .MAX_CONSUME_ITEMS(5),
       .BITS_PER_ITEM($bits(sdd_ss_partial_symbol_t)))
   u_packer
     (
      
      .src_ready                        (packer_src_ready),      
      .dst_items_avail                  (packer_dst_items_avail), 
      .dst_data                         (packer_dst_data),       
      .dst_last                         (),                      
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .src_items_valid                  (packer_src_items_valid), 
      .src_data                         (packer_src_data),       
      .src_last                         ({1{1'b0}}),             
      .dst_items_consume                (packer_dst_items_consume), 
      .clear                            (1'b0));                  


   
   localparam int HNDSHK_MODE[1:POST_PACKER_STAGES] = '{default: `AXI_RS_FWD};

   genvar ii;
   generate

      for (ii=1; ii<=POST_PACKER_STAGES; ii++) begin : reg_slices
         axi_channel_reg_slice
              #(.PAYLD_WIDTH($bits(sdd_sp_pipe_t)),
                .HNDSHK_MODE(HNDSHK_MODE[ii]))
         u_reg_slice
              (.aclk (clk),
               .aresetn (rst_n),
               .valid_src (pipe_src_valid[ii]),
               .ready_src (pipe_src_ready[ii]),
               .payload_src (pipe_src_data[ii]),
               .valid_dst (pipe_dst_valid[ii]),
               .ready_dst (pipe_dst_ready[ii]),
               .payload_dst (pipe_dst_data[ii]));
      end 

   endgenerate


   

   axi_channel_reg_slice
     #(.PAYLD_WIDTH($bits(lz_symbol_bus_t)),
       .HNDSHK_MODE(`AXI_RS_FULL))
   u_outreg
     (
      
      .ready_src                        (outreg_ready),          
      .valid_dst                        (sdd_mtf_dp_valid),      
      .payload_dst                      (sdd_mtf_dp_bus),        
      
      .aclk                             (clk),                   
      .aresetn                          (rst_n),                 
      .valid_src                        (outreg_valid),          
      .payload_src                      (outreg_bus),            
      .ready_dst                        (mtf_sdd_dp_ready));      

   SDD_1_LIT: `COVER_PROPERTY(sdd_1_lit_stb);
   SDD_2_LIT: `COVER_PROPERTY(sdd_2_lit_stb);
   SDD_3_LIT: `COVER_PROPERTY(sdd_3_lit_stb);
   SDD_4_LIT: `COVER_PROPERTY(sdd_4_lit_stb);
   SDD_1_MTF: `COVER_PROPERTY(sdd_1_mtf_stb);
   SDD_1_MTF_1_LIT: `COVER_PROPERTY(sdd_1_mtf_1_lit_stb);
   SDD_1_MTF_2_LIT: `COVER_PROPERTY(sdd_1_mtf_2_lit_stb);
   SDD_1_MTF_3_LIT: `COVER_PROPERTY(sdd_1_mtf_3_lit_stb);
   SDD_1_PTR: `COVER_PROPERTY(sdd_1_ptr_stb);
   SDD_1_PTR_1_LIT: `COVER_PROPERTY(sdd_1_ptr_1_lit_stb);
   SDD_1_PTR_2_LIT: `COVER_PROPERTY(sdd_1_ptr_2_lit_stb);
   SDD_1_PTR_3_LIT: `COVER_PROPERTY(sdd_1_ptr_3_lit_stb);
   genvar i;
   generate
      for (i=0; i<$bits(xp_short_stb); i++)
	XP_SHORT: `COVER_PROPERTY(xp_short_stb[i]);

      for (i=0; i<$bits(xp_long_stb); i++)
	XP_LONG: `COVER_PROPERTY(xp_long_stb[i]);

      for (i=0; i<$bits(deflate_lenlit_stb); i++)
	DEFLATE_LENLIT: `COVER_PROPERTY(deflate_lenlit_stb[i]);

      for (i=0; i<$bits(deflate_dist_stb); i++)
	DEFLATE_DISTANCE: `COVER_PROPERTY(deflate_dist_stb[i]);
   endgenerate

`undef DECLARE_RESET_FLOP
`undef DECLARE_FLOP
`undef DEFAULT_FLOP   
`undef DECLARE_RESET_OUT_FLOP

endmodule 







