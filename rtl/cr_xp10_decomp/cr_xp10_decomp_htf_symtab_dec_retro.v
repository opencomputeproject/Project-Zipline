/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"
`include "messages.vh"

module cr_xp10_decomp_htf_symtab_dec_retro (
   
   o_repeat_count, o_sub_state, o_bl_count, o_bl_index, o_prev_bl,
   o_prev_non_zero_bl, o_state, o_hdr_bits_consume, o_blt_hist_wen,
   o_blt_hist_wdata, o_blt_hist_complete_valid, o_status_valid,
   o_status_bus,
   
   clk, rst_n, small_blt, small_smt, small_svt, fmt, retro_go,
   i_repeat_count, i_sub_state, i_bl_count, i_bl_index, i_prev_bl,
   i_prev_non_zero_bl, i_state, hdr_bits_data
   );
   import crPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;

   parameter BL_PER_CYCLE = 2;

   localparam NUM_SPEC_HUFFMAN = (BL_PER_CYCLE-1)*`N_MAX_SMALL_HUFF_BITS+1;

   input clk;
   input rst_n;

   
   
   
   input [`BIT_VEC(`N_SMALL_SYMBOLS)][`LOG_VEC(`N_MAX_SMALL_HUFF_BITS+1)]   small_blt;
   input [`BIT_VEC(`N_SMALL_SYMBOLS)][`BIT_VEC(`N_MAX_SMALL_HUFF_BITS)]     small_smt;
   input [`BIT_VEC(`N_SMALL_SYMBOLS)][`BIT_VEC(`N_MAX_SMALL_HUFF_BITS)]     small_svt;
   input htf_fmt_e                                                          fmt;

   input retro_go;
   
   input [6:0]                                i_repeat_count;
   input htf_symtab_sub_state_t               i_sub_state;
   input [`LOG_VEC(`N_XP9_SHRT_SYMBOLS+1)]    i_bl_count;
   input [`LOG_VEC(`N_XP9_SHRT_SYMBOLS)]      i_bl_index;
   input [15:0][`LOG_VEC(`N_MAX_HUFF_BITS+1)] i_prev_bl;
   input [`LOG_VEC(`N_MAX_HUFF_BITS+1)]       i_prev_non_zero_bl;
   input htf_symtab_state_t                   i_state;

   output logic [6:0]                                o_repeat_count;
   output htf_symtab_sub_state_t                     o_sub_state;
   output logic [`LOG_VEC(`N_XP9_SHRT_SYMBOLS+1)]    o_bl_count;
   output logic [`LOG_VEC(`N_XP9_SHRT_SYMBOLS)]      o_bl_index;
   output logic [15:0][`LOG_VEC(`N_MAX_HUFF_BITS+1)] o_prev_bl;
   output logic [`LOG_VEC(`N_MAX_HUFF_BITS+1)]       o_prev_non_zero_bl;
   output htf_symtab_state_t                         o_state;

   input [`BIT_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS)]          hdr_bits_data;
   output logic [`LOG_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS+1)] o_hdr_bits_consume;
   
   output logic [`LOG_VEC(BL_PER_CYCLE+1)]                             o_blt_hist_wen;
   output logic [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(`N_MAX_HUFF_BITS+1)] o_blt_hist_wdata;
   output logic                                                        o_blt_hist_complete_valid;
   output logic                                                        o_status_valid;
   output htf_bhp_status_bus_t                                         o_status_bus;


   logic [`BIT_VEC(NUM_SPEC_HUFFMAN)][`LOG_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS+1)] huff_total_length;
   logic [`BIT_VEC(NUM_SPEC_HUFFMAN)][`LOG_VEC(`N_SMALL_SYMBOLS)]         huff_symbol; 
   logic [`BIT_VEC(NUM_SPEC_HUFFMAN)][`BIT_VEC(`N_SMALL_SYMBOLS)]         huff_onehot_symbol; 
   logic [`BIT_VEC(NUM_SPEC_HUFFMAN)]                                     huff_err;
   logic [`BIT_VEC(NUM_SPEC_HUFFMAN)][`LOG_VEC(`N_MAX_HUFF_BITS+1)]       huff_blt_hist_wdata;
   logic [`BIT_VEC(NUM_SPEC_HUFFMAN)][3:0]                                huff_repeat_count;
   htf_symtab_sub_state_t                                                 huff_sub_state[`BIT_VEC(NUM_SPEC_HUFFMAN)];
   logic [`BIT_VEC(NUM_SPEC_HUFFMAN)]                                     huff_status_valid;
   htf_bhp_status_bus_t                                                   huff_status_bus[`BIT_VEC(NUM_SPEC_HUFFMAN)];

   logic [`BIT_VEC(NUM_SPEC_HUFFMAN)][`LOG_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS+1)] extra2_total_length;
   logic [`BIT_VEC(NUM_SPEC_HUFFMAN)][1:0]                                extra2_repeat_count;
   htf_symtab_sub_state_t                                                 extra2_sub_state[`BIT_VEC(NUM_SPEC_HUFFMAN)];
   logic [`BIT_VEC(NUM_SPEC_HUFFMAN)]                                     extra2_status_valid;
   htf_bhp_status_bus_t                                                   extra2_status_bus[`BIT_VEC(NUM_SPEC_HUFFMAN)];

   logic [`BIT_VEC(NUM_SPEC_HUFFMAN)][`LOG_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS+1)] extra3_total_length;
   logic [`BIT_VEC(NUM_SPEC_HUFFMAN)][2:0]                                extra3_repeat_count;
   htf_symtab_sub_state_t                                                 extra3_sub_state[`BIT_VEC(NUM_SPEC_HUFFMAN)];
   logic [`BIT_VEC(NUM_SPEC_HUFFMAN)]                                     extra3_status_valid;
   htf_bhp_status_bus_t                                                   extra3_status_bus[`BIT_VEC(NUM_SPEC_HUFFMAN)];

   logic [`BIT_VEC(NUM_SPEC_HUFFMAN)][`LOG_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS+1)] extra7_total_length;
   logic [`BIT_VEC(NUM_SPEC_HUFFMAN)][6:0]                                extra7_repeat_count;
   htf_symtab_sub_state_t                                                 extra7_sub_state[`BIT_VEC(NUM_SPEC_HUFFMAN)];
   logic [`BIT_VEC(NUM_SPEC_HUFFMAN)]                                     extra7_status_valid;
   htf_bhp_status_bus_t                                                   extra7_status_bus[`BIT_VEC(NUM_SPEC_HUFFMAN)];
   

   cr_xp10_decomp_htf_symtab_dec_retro_huff u_retro_huff
     (
      
      .huff_total_length                (huff_total_length),
      .huff_symbol                      (huff_symbol),
      .huff_onehot_symbol               (huff_onehot_symbol),
      .huff_err                         (huff_err[`BIT_VEC(NUM_SPEC_HUFFMAN)]),
      .huff_blt_hist_wdata              (huff_blt_hist_wdata),
      .huff_repeat_count                (huff_repeat_count),
      .huff_sub_state                   (huff_sub_state),
      
      .small_blt                        (small_blt),
      .small_smt                        (small_smt),
      .small_svt                        (small_svt),
      .fmt                              (fmt),
      .i_bl_index                       (i_bl_index[`LOG_VEC(`N_XP9_SHRT_SYMBOLS)]),
      .i_prev_bl                        (i_prev_bl),
      .i_prev_non_zero_bl               (i_prev_non_zero_bl[`LOG_VEC(`N_MAX_HUFF_BITS+1)]),
      .hdr_bits_data                    (hdr_bits_data[`BIT_VEC(BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS)]));
   


   always_comb begin
      logic                                                   v_stop;

      o_hdr_bits_consume = 0;

      o_repeat_count = i_repeat_count;
      o_sub_state = i_sub_state;
      o_bl_count = i_bl_count;
      o_bl_index = i_bl_index;
      o_prev_bl = i_prev_bl;
      o_prev_non_zero_bl = i_prev_non_zero_bl;
      o_state = i_state;

      o_status_valid = 0;
      o_status_bus = '0;

      o_blt_hist_wen = 0;
      o_blt_hist_wdata = '0;
      o_blt_hist_complete_valid = 0;

      v_stop = 0;

      for (int i=0; i<NUM_SPEC_HUFFMAN; i++) begin
         huff_status_valid[i] = 0;
         extra2_status_valid[i] = 0;
         extra3_status_valid[i] = 0;
         extra7_status_valid[i] = 0;

         huff_status_bus[i] = 0;
         extra2_status_bus[i] = 0;
         extra3_status_bus[i] = 0;
         extra7_status_bus[i] = 0;

         extra2_total_length[i] = i;
         extra3_total_length[i] = i;
         extra7_total_length[i] = i;

         extra2_repeat_count[i] = 0;
         extra3_repeat_count[i] = 0;
         extra7_repeat_count[i] = 0;

         extra2_sub_state[i] = 1 << EXTRA_2;
         extra3_sub_state[i] = 1 << EXTRA_3;
         extra7_sub_state[i] = 1 << EXTRA_7;


         if (huff_err[i]) begin
            huff_status_valid[i] = 1;
            huff_status_bus[i].error = HD_HTF_BAD_HUFFMAN_CODE;
         end
         
         extra2_total_length[i] = $bits(o_hdr_bits_consume)'(i + 2);
         if (i_state[XP_SS_RETRO_DECODE] ||
             i_state[XP_LL_RETRO_DECODE]) begin
            if (hdr_bits_data[i +: 2] == 2'd3) begin
               extra2_repeat_count[i] = 2;
               extra2_sub_state[i] = 1 << EXTRA_3;
            end
            else begin
               extra2_repeat_count[i] = $bits(o_repeat_count)'(hdr_bits_data[i +: 2]);
               extra2_sub_state[i] = 1 << HUFFMAN;
            end
         end 
         else begin
            
            
            
            
            
            
            
            extra2_repeat_count[i] = $bits(o_repeat_count)'(hdr_bits_data[i +: 2]);
            extra2_sub_state[i] = 1 << HUFFMAN;
         end
         
         extra3_total_length[i] = $bits(o_hdr_bits_consume)'(i + 3);
         if (i_state[XP_SS_RETRO_DECODE] ||
             i_state[XP_LL_RETRO_DECODE]) begin
            if (hdr_bits_data[i +: 3] == 3'd7) begin
               extra3_repeat_count[i] = 6;
               extra3_sub_state[i] = 1 << EXTRA_3;
            end
            else begin
               extra3_repeat_count[i] = $bits(o_repeat_count)'(hdr_bits_data[i +: 3]);
               extra3_sub_state[i] = 1 << HUFFMAN;
            end
         end 
         else begin
            
            
            
            
            
            
            
            extra3_repeat_count[i] = $bits(o_repeat_count)'(hdr_bits_data[i +: 3]);
            extra3_sub_state[i] = 1 << HUFFMAN;
         end
      
         
         extra7_total_length[i] = $bits(o_hdr_bits_consume)'(i + 7);
         
         
         
         
         
         
         
         extra7_repeat_count[i] = $bits(o_repeat_count)'(hdr_bits_data[i +: 7]);
         extra7_sub_state[i] = 1 << HUFFMAN;
      end 

      if (retro_go) begin
         for (int i=0; i<BL_PER_CYCLE; i++) begin
            if (!v_stop) begin
               
               
               
               
               logic [3:0] v_inc_count;
               
               
               logic       v_carryout;

               if (o_repeat_count == 0) begin
                  unique case (1'b1)
                    o_sub_state[HUFFMAN]: begin
                       o_status_valid = huff_status_valid[o_hdr_bits_consume]; 
                       o_status_bus = huff_status_bus[o_hdr_bits_consume]; 
                       
                       o_blt_hist_wdata[i] = huff_blt_hist_wdata[o_hdr_bits_consume]; 
                       o_repeat_count = $bits(o_repeat_count)'(huff_repeat_count[o_hdr_bits_consume]); 
                       o_sub_state = huff_sub_state[o_hdr_bits_consume]; 
                       v_stop = huff_err[o_hdr_bits_consume]; 
                       
                       if (i>0) begin
                          if (i_state[XP_SS_RETRO_DECODE] ||
                              i_state[XP_LL_RETRO_DECODE]) begin
                             
                             
                             
                             
                             
                             if (huff_onehot_symbol[o_hdr_bits_consume][28]) begin 
                                
                                o_repeat_count = $bits(o_repeat_count)'(15 - o_bl_index[3:0]);
                             end
                             if (|huff_onehot_symbol[o_hdr_bits_consume][32:30]) begin 
                                
                                
                                o_blt_hist_wdata[i] = '0;
                                o_blt_hist_wdata[i] = {$clog2(`N_MAX_HUFF_BITS+1){huff_onehot_symbol[o_hdr_bits_consume][30]}} & 
                                                      o_prev_non_zero_bl;
                                o_blt_hist_wdata[i] |= {$clog2(`N_MAX_HUFF_BITS+1){huff_onehot_symbol[o_hdr_bits_consume][31]}} & 
                                                       o_prev_bl[15];
                                o_blt_hist_wdata[i] |= {$clog2(`N_MAX_HUFF_BITS+1){huff_onehot_symbol[o_hdr_bits_consume][32]}} & 
                                                       (o_prev_bl[15]+1);
                             end 
                          end 
                          else begin
                             
                             if (huff_onehot_symbol[o_hdr_bits_consume][16]) begin
                                
                                o_blt_hist_wdata[i] = o_prev_bl[0];
                             end
                          end
                       end 
                       o_hdr_bits_consume = huff_total_length[o_hdr_bits_consume]; 
                    end 
                    o_sub_state[EXTRA_2]: begin
                       o_status_valid = extra2_status_valid[o_hdr_bits_consume];
                       o_status_bus = extra2_status_bus[o_hdr_bits_consume];
                       
                       if (i_state[DEFLATE_HLIT_DYNAMIC] || i_state[DEFLATE_HDIST_DYNAMIC])
                         o_blt_hist_wdata[i] = o_prev_bl[0];
                       else
                         o_blt_hist_wdata[i] = 0;
                       o_repeat_count = $bits(o_repeat_count)'(extra2_repeat_count[o_hdr_bits_consume]);
                       o_sub_state = extra2_sub_state[o_hdr_bits_consume];
                       o_hdr_bits_consume = extra2_total_length[o_hdr_bits_consume]; 
                    end 
                    o_sub_state[EXTRA_3]: begin
                       o_status_valid = extra3_status_valid[o_hdr_bits_consume];
                       o_status_bus = extra3_status_bus[o_hdr_bits_consume];
                       o_blt_hist_wdata[i] = 0;
                       o_repeat_count = $bits(o_repeat_count)'(extra3_repeat_count[o_hdr_bits_consume]);
                       o_sub_state = extra3_sub_state[o_hdr_bits_consume];
                       o_hdr_bits_consume = extra3_total_length[o_hdr_bits_consume]; 
                    end 
                    o_sub_state[EXTRA_7]: begin
                       o_status_valid = extra7_status_valid[o_hdr_bits_consume];
                       o_status_bus = extra7_status_bus[o_hdr_bits_consume];
                       o_blt_hist_wdata[i] = 0;
                       o_repeat_count = $bits(o_repeat_count)'(extra7_repeat_count[o_hdr_bits_consume]);
                       o_sub_state = extra7_sub_state[o_hdr_bits_consume];
                       o_hdr_bits_consume = extra7_total_length[o_hdr_bits_consume]; 
                    end 
                  endcase 
               end 
               else begin
                  
                  o_blt_hist_wdata[i] = o_prev_bl[0];
                  o_repeat_count = o_repeat_count - 1;
               end 

               
               if (o_blt_hist_wdata[i] != 0)
                 o_prev_non_zero_bl = o_blt_hist_wdata[i];
               
               if ((i_state[XP_SS_RETRO_DECODE] && ((i_bl_index+i) < `N_XP10_64K_SHRT_SYMBOLS)) ||
                   (i_state[XP_LL_RETRO_DECODE] && ((i_bl_index+i) < `N_XP10_64K_LONG_SYMBOLS)) ||
                   i_state[DEFLATE_HLIT_DYNAMIC] ||
                   i_state[DEFLATE_HDIST_DYNAMIC]) begin
                  o_blt_hist_wen = 1 + i;
                  v_inc_count = 0;
               end
               else begin
                  
                  
                  
                  
                  v_inc_count = o_repeat_count[3:0];
                  o_repeat_count = 0; 
                  
                  if (o_blt_hist_wdata[i] != 0) begin
                     o_status_valid = 1;
                     o_status_bus.error = HD_HTF_XP9_ILLEGAL_NONZERO_BL;
                     v_stop = 1;
                  end
               end 
               {v_carryout, o_bl_count} = o_bl_count - 1 - v_inc_count; 
               o_bl_index += 1 + v_inc_count; 
               o_prev_bl = {o_prev_bl[14:0], o_blt_hist_wdata[i]} << (v_inc_count*$clog2(`N_MAX_HUFF_BITS+1)); 

               if (!v_stop) begin
                  if (v_carryout) begin
                     
                     o_status_valid = 1;
                     o_status_bus.error = HD_HTF_RLE_OVERRUN;
                     o_blt_hist_wen = 0;
                     v_stop = 1;
                  end
                  else if ((o_repeat_count == 0) || i_state[DEFLATE_HLIT_DYNAMIC]) begin
                     if (o_bl_count == 0) begin
                        o_blt_hist_complete_valid = 1;
                        if (i_state[XP_SS_RETRO_DECODE]) begin
                           if (fmt == HTF_FMT_XP9)
                             o_state = 1 << XP9_LL_HEADER;
                           else
                             o_state = 1 << XP10_LL_HEADER;
                        end
                        else if (i_state[DEFLATE_HLIT_DYNAMIC]) begin
                           
                           
                           
                           o_state = 1 << DEFLATE_WAIT_DYNAMIC;
                        end
                        else begin
                           
                           o_status_valid = 1;
                           o_status_bus.error = NO_ERRORS;
                        end 
                        v_stop = 1;
                     end 
                  end 
               end 
            end 
         end 
      end 
   end 

endmodule 







