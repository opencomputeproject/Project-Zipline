/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/




















module cr_xp10_decomp_lz77_ep (
   
   ep_ag_hb_rd, ep_ag_hb_num_words, ep_ag_hb_1st_rd, ep_bm_lit_valid,
   ep_bm_num_lit, ep_bm_lit_data, ep_bm_ptr_valid, ep_bm_lwrd_valid,
   ep_bm_from_offset, ep_bm_to_offset, ep_bm_lwl, ep_bm_copy_valid,
   ep_bm_copy_offset, ep_bm_copy_length, ep_bm_eof,
   ep_bm_eof_err_code, ep_bm_eob, ep_if_entry_done, ep_ag_eof,
   ep_if_load_trace_bit, ep_if_trace_bit, ptr_256_stb, ptr_128_stb,
   ptr_64_stb, ptr_32_stb, ptr_11_stb, ptr_10_stb, ptr_9_stb,
   ptr_8_stb, ptr_7_stb, ptr_6_stb, ptr_5_stb, ptr_4_stb, ptr_3_stb,
   lz_bytes_decomp, lz_local_bytes, lz_hb_bytes,
   
   clk, rst_n, if_ep_sym, if_ep_sym_valid, ag_ep_head_moved,
   ag_ep_hb_wr, bm_ep_copy_done, pl_ep_prefix_load, pl_ep_prefix_cnt,
   pl_ep_trace_bit, bm_ep_pause
   );
   import crPKG::*;   
   import cr_xp10_decompPKG::*;
   
   input                  clk;
   input                  rst_n;
   
   input  sym_t           if_ep_sym;
   input                  if_ep_sym_valid;
   
   output logic           ep_ag_hb_rd;
   output logic [11:0]    ep_ag_hb_num_words;
   output logic           ep_ag_hb_1st_rd;
   
   input                  ag_ep_head_moved;
   input                  ag_ep_hb_wr;

   output logic           ep_bm_lit_valid;
   output logic [1:0]     ep_bm_num_lit;
   output logic [31:0]    ep_bm_lit_data;

   
   output logic           ep_bm_ptr_valid;
   output logic           ep_bm_lwrd_valid;
   output logic [3:0]     ep_bm_from_offset;
   output logic [3:0]     ep_bm_to_offset;
   output logic [5:0]     ep_bm_lwl;

   
   output logic           ep_bm_copy_valid;
   output logic [4:0]     ep_bm_copy_offset;
   output logic [15:0]    ep_bm_copy_length;
   input                  bm_ep_copy_done;

   output  logic          ep_bm_eof;
   output logic [31:0]    ep_bm_eof_err_code;
   output logic           ep_bm_eob;
   
   output logic           ep_if_entry_done;
   output logic           ep_ag_eof;
   
   input                  pl_ep_prefix_load;
   input [16:0]           pl_ep_prefix_cnt;
   input                  pl_ep_trace_bit;
   
   input                  bm_ep_pause;
   output logic           ep_if_load_trace_bit;
   output logic           ep_if_trace_bit;
   
   output logic           ptr_256_stb;
   output logic           ptr_128_stb;
   output logic           ptr_64_stb;
   output logic           ptr_32_stb;
   output logic           ptr_11_stb;
   output logic           ptr_10_stb;
   output logic           ptr_9_stb;
   output logic           ptr_8_stb;
   output logic           ptr_7_stb;
   output logic           ptr_6_stb;
   output logic           ptr_5_stb;
   output logic           ptr_4_stb;
   output logic           ptr_3_stb;

   output logic [16:0]    lz_bytes_decomp;
   output logic [16:0]    lz_local_bytes;
   output logic [16:0]    lz_hb_bytes;
   
   logic [2:0]            lit_cnt;
   logic [31:0]           lit_data;
   logic                  lit_valid;
   logic [15:0]           ptr_offset;
   logic [15:0]           ptr_length;
   logic [15:0]           r_ptr_offset;
   logic [15:0]           r_ptr_length;
   logic                  ptr_valid;
   
   logic [16:0]           cur_pos;
   logic [16:0]           cur_pos_ag;
   logic [16:0]           cur_pos_cur;
   logic [16:0]           his_buf_cnt;
   logic [16:0]           his_buf_cur;

   logic [16:0]           curr_offset;
   logic [16:0]           tmp_ag;
   logic [16:0]           tmp_pause;
   logic [16:0]           tmp_curr;
   logic [16:0]           ptr_bytes;
   logic                  r_hb_read;
   logic                  r_last_word_rd;

   logic                  copy_in_pgrss;
   logic                  ptr_in_pgrss;

   logic                  copy_valid;
   logic [15:0]           copy_length;
   logic [4:0]           copy_offset;
   logic                 r_copy_valid;
   logic [15:0]          r_copy_length;
   logic [4:0]           r_copy_offset;

   logic [15:0]           bytes_to_read_from_hb;
   logic [11:0]           words_to_read_from_hb;
   logic [15:0]           updated_len;
   logic [15:0]           cur_cnt;
   logic                  mod_valid;
   logic                  hb_read;
   logic                  last_word_rd;
   logic [4:0]            hb_bytes;
   logic [4:0]            mod_bytes;
   logic [4:0]            tmp_mod_bytes;
   logic [3:0]            from_offset;
   logic [3:0]            to_offset;
   logic [15:0]           tmp_len;
   logic                  copy_after_hb_read;
   
   logic                  r_copy_after_hb_read;

   logic [3:0]            r_from_offset;
   logic [3:0]            r_to_offset;

   logic [15:0]           curr_len;
   logic [16:0]           bytes_offset_to_read;
   logic                  ptr_done;
   logic                  first_read;
   logic                  r_ep_pause;
   logic                  ep_pause;
   logic                  hb_wr_wait;
   logic                  r_ep_eof;
   logic                  r_ep_eob;
   logic [31:0]           r_ep_eof_err_code;
   logic                  ready_to_read;

   logic                  r_lit_valid;
   logic [31:0]           r_lit_data;
   logic [2:0]            r_lit_cnt;

   logic                  eof_valid;
   logic                  eob_valid;
   logic [31:0]           eof_err_code;
   sym_t                  saved_sym;
   sym_t                  cur_sym;
   sym_t                  nxt_sym;
   logic                  saved_sym_valid;
   logic                  nxt_sym_valid;
   logic                  cur_sym_valid;
   logic                  cp_after_ptr;
   logic [15:0]           cp_after_ptr_len;
   logic [15:0]           curr_cp_len;
   logic                  r_copy_in_pgrss;
   logic [17:0]           tmp_bytes_his;
   logic [16:0]           tmp_bytes_lwl; 
   logic [4:0]            off_adj;
   logic [4:0]            tmp_off;
   logic                  set_offset_err;
   logic                  r_offset_err;

   logic                  ptr_256;
   logic                  ptr_128;
   logic                  ptr_64;
   logic                  ptr_32;
   logic                  ptr_11;
   logic                  ptr_10;
   logic                  ptr_9;
   logic                  ptr_8;
   logic                  ptr_7;
   logic                  ptr_6;
   logic                  ptr_5;
   logic                  ptr_4;
   logic                  ptr_3;
   logic                  r_trace_bit;
   

 
   assign ptr_done = (hb_read || last_word_rd) ? 
                     ((updated_len == 0) ? 1'b1 : 1'b0) : 1'b1;
   assign first_read = (ptr_valid && hb_read) ||
                       (ptr_valid && !hb_read && last_word_rd);

   assign ep_ag_eof = ep_bm_eof;
   assign ep_pause = bm_ep_pause || hb_wr_wait;
   
   assign hb_wr_wait = ((cur_pos - his_buf_cnt) > 6'd63) ? 1'b1 : 1'b0;

   assign cp_after_ptr = r_copy_after_hb_read && (curr_len == 0) && 
                         !r_last_word_rd &&
                         !r_hb_read && !ep_pause;
   assign cp_after_ptr_len =  (r_ptr_length - r_ptr_offset); 
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         ep_if_load_trace_bit <= 0;
         ep_if_trace_bit <= 0;
         r_offset_err <= 0;
         r_trace_bit <= 0;
         ready_to_read <= 0;
         
      end
      else begin
         if (eof_valid)
           ready_to_read <= 1'b0;
         else if (pl_ep_prefix_load)
           ready_to_read <= 1'b1;

         if (ep_bm_eof)
           r_offset_err <= 1'b0;
         else if (set_offset_err)
           r_offset_err <= 1'b1;

         if (pl_ep_prefix_load) begin
            r_trace_bit <= pl_ep_trace_bit;
            ep_if_load_trace_bit <= 1'b1;
            ep_if_trace_bit <= pl_ep_trace_bit;
         end
         else begin
            ep_if_load_trace_bit <= 1'b0;
            ep_if_trace_bit <= 1'b0;
         end
         
      end
   end
   
   
   
   always_comb
   begin
      lit_cnt = 0;
      lit_data = '0;
      ptr_offset = '0;
      ptr_length = '0;
      ptr_valid = 1'b0;
      lit_valid = 1'b0;
      cur_sym_valid = 1'b0;
      nxt_sym_valid = 1'b0;
      cur_sym = '0;
      nxt_sym = '0;
      eof_valid = 1'b0;
      eob_valid = 1'b0;
      eof_err_code = '0;
      
      if (if_ep_sym_valid || saved_sym_valid) begin
         if (if_ep_sym_valid) begin
            if (ep_pause || ptr_in_pgrss || copy_in_pgrss) begin
               nxt_sym_valid = 1'b1;
               nxt_sym = if_ep_sym;
            end
            else begin
               cur_sym_valid = 1'b1;
               cur_sym = if_ep_sym;
            end
         end
         else if (saved_sym_valid) begin
            if (!ep_pause && !ptr_in_pgrss && !copy_in_pgrss) begin
               cur_sym_valid = 1'b1;
               cur_sym = saved_sym;
               nxt_sym_valid = 1'b0;
               nxt_sym = '0;
            end
            else begin
               nxt_sym_valid = 1'b1;
               nxt_sym = saved_sym;
            end
         end
      end 
   
      if (cur_sym_valid) begin
         if (cur_sym.lit_valid) begin
            lit_valid = 1'b1;
            lit_data = cur_sym.data;
            lit_cnt = cur_sym.lit_cnt;
         end
         else if (cur_sym.ptr_valid) begin
            ptr_valid = 1'b1;
            ptr_length = cur_sym.data[15:0];
            ptr_offset = cur_sym.data[31:16];
         end
         else if (cur_sym.eof_valid) begin
            eof_valid =1'b1;
            eof_err_code = cur_sym.data;
         end
         else if (cur_sym.eob_valid) begin
            eob_valid = 1'b1;
         end
      end 
   end 
            

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         ep_ag_hb_1st_rd <= 0;
         ep_ag_hb_num_words <= 0;
         ep_ag_hb_rd <= 0;
         ep_bm_copy_length <= 0;
         ep_bm_copy_offset <= 0;
         ep_bm_copy_valid <= 0;
         ep_bm_from_offset <= 0;
         ep_bm_lit_data <= 0;
         ep_bm_lit_valid <= 0;
         ep_bm_lwl <= 0;
         ep_bm_lwrd_valid <= 0;
         ep_bm_num_lit <= 0;
         ep_bm_ptr_valid <= 0;
         ep_bm_to_offset <= 0;
         ep_if_entry_done <= 0;
         r_copy_length <= 0;
         r_copy_offset <= 0;
         r_copy_valid <= 0;
         r_lit_cnt <= 0;
         r_lit_data <= 0;
         r_lit_valid <= 0;
         saved_sym <= 0;
         saved_sym_valid <= 0;
         
      end
      else begin
         if (nxt_sym_valid) begin
            saved_sym_valid <= 1'b1;
            saved_sym <= nxt_sym;
         end
         else begin
            saved_sym_valid <= 1'b0;
            saved_sym <= '0;
         end
         ep_if_entry_done <= ptr_done &&
                             !eof_valid && !eob_valid && 
                             !copy_after_hb_read && !copy_in_pgrss && 
                             !r_copy_after_hb_read && !ep_pause &&
                             !nxt_sym_valid && ready_to_read;
         

         r_copy_valid <= copy_valid;
         r_copy_offset <= copy_offset;
         r_copy_length <= copy_length;

         r_lit_valid <= lit_valid;
         r_lit_data <= lit_data;
         r_lit_cnt <= lit_cnt;

         if (r_lit_valid) begin
            ep_bm_lit_valid <= 1'b1;
            ep_bm_lit_data <= r_lit_data;
            ep_bm_num_lit <= r_lit_cnt; 
         end
         else begin
            ep_bm_lit_valid <= 1'b0;
            ep_bm_lit_data <= '0;
            ep_bm_num_lit <= '0;
         end
         
         ep_bm_from_offset <= r_from_offset;
         ep_bm_to_offset <= r_to_offset;
         ep_bm_ptr_valid <= r_hb_read;
         
         if (r_copy_valid) begin
            ep_bm_copy_valid <= r_copy_valid;
            ep_bm_copy_length <= r_copy_length;
            ep_bm_copy_offset <= r_copy_offset;
         end
         else if (cp_after_ptr) begin
            ep_bm_copy_valid <= 1'b1;
            ep_bm_copy_length <= cp_after_ptr_len;
            ep_bm_copy_offset <= r_ptr_offset[4:0];
         end
         else begin
            ep_bm_copy_valid <= 1'b0;
            ep_bm_copy_length <= '0;
            ep_bm_copy_offset <= '0;
         end

         ep_bm_lwrd_valid <= r_last_word_rd && !r_ep_pause;
         if (r_last_word_rd && !r_ep_pause)
           ep_bm_lwl <= (cur_pos - curr_offset); 
         else
           ep_bm_lwl <= '0;
         
         if (hb_read) begin
            ep_ag_hb_rd <= 1'b1;
            
            ep_ag_hb_num_words <= words_to_read_from_hb + ag_ep_hb_wr; 
            ep_ag_hb_1st_rd <= ptr_valid;
         end
         else begin
            ep_ag_hb_rd <= 1'b0;
            ep_ag_hb_num_words <= '0;
            ep_ag_hb_1st_rd <= 1'b0;
         end 
      end
   end
   
   
   
   
   
   
   always_comb
     begin
        copy_valid = 1'b0;
        bytes_offset_to_read = '0;
        bytes_to_read_from_hb = '0;
        words_to_read_from_hb = '0;
        copy_length = '0;
        copy_offset = '0;
        last_word_rd = 1'b0;
        hb_read = 1'b0;
        set_offset_err = 1'b0;
        tmp_bytes_his = '0;
        tmp_bytes_lwl = '0;
        mod_valid = 1'b0;
        if (ptr_valid) begin
           if (cur_pos < {1'b0, ptr_offset}) begin
             
              set_offset_err = 1'b1;
              copy_valid = 1'b1;
              copy_length = ptr_length;
              copy_offset = '0;
           end
           else begin
              bytes_offset_to_read = cur_pos - ptr_offset; 
              tmp_bytes_his = his_buf_cnt - (cur_pos - ptr_offset); 
              tmp_bytes_lwl = (cur_pos - his_buf_cnt) - ptr_offset; 
              if (!tmp_bytes_his[17] && !(tmp_bytes_his == 0)) begin
                 bytes_to_read_from_hb = tmp_bytes_his[15:0];
                 mod_valid = (bytes_to_read_from_hb % 16) > 0 ? 1'b1 : 1'b0;
                 hb_read = 1'b1;
                 words_to_read_from_hb = (bytes_to_read_from_hb)/16 + mod_valid; 
              end
              else begin
                 hb_read = 1'b0;
                 if ((ptr_offset <= 5'd16)) begin
                    copy_valid = 1'b1;
                    copy_length = ptr_length;
                    copy_offset = ptr_offset[4:0];
                 end
                 else begin
                    last_word_rd = 1'b1;
                    bytes_to_read_from_hb = tmp_bytes_lwl[15:0];
                 end
              end 
           end 
        end 
        else if ((curr_len > 0) && !ep_pause) begin
           if ((curr_offset < his_buf_cnt) && !r_last_word_rd) begin
              hb_read = 1'b1;
              last_word_rd = 1'b0;
           end
           else begin
            hb_read = 1'b0;
            last_word_rd = 1'b1;
         end
        end
     end 

   
   
   
   always_comb
     begin
        hb_bytes = '0;
        from_offset = '0;
        to_offset = '0;
        copy_after_hb_read = 1'b0;
        
        if (first_read) begin
           if ((ptr_length > ptr_offset) && (ptr_offset <= 16)) begin
              tmp_len = ptr_offset;
              copy_after_hb_read = 1'b1;
           end
           else
             tmp_len = ptr_length;
        end
        else
          tmp_len = curr_len;

        mod_bytes = (bytes_to_read_from_hb % 16);
        tmp_mod_bytes = (mod_bytes == 0) ? 5'd16 : mod_bytes;
        off_adj = 5'd16 - mod_bytes; 
        tmp_off = '0;
        
        if (hb_read || last_word_rd) begin
           if (first_read) begin
              if (hb_read)
                from_offset = off_adj[3:0];
              else
                from_offset = mod_bytes[3:0];
           end
           else
             from_offset = 4'd0;

           tmp_off = 5'd16 - from_offset;
           
           if (tmp_len > tmp_off) 
             to_offset = 4'd15;
           else
             to_offset = (from_offset + tmp_len) -1; 

           if (first_read) begin
              if (tmp_len > ({11'b0, tmp_off})) begin
                 if (hb_read)
                   hb_bytes = tmp_mod_bytes;
                 else
                   hb_bytes = off_adj;
              end
              else begin
                   hb_bytes = tmp_len[4:0];
              end
           end 
           else begin
              if (tmp_len > 5'd16)
                hb_bytes = 5'd16;
              else
                hb_bytes = tmp_len[4:0];
           end 
             

        end 
        
        updated_len = tmp_len - hb_bytes; 
        
        if (copy_valid)
          cur_cnt = copy_length;
        else if (cp_after_ptr)
          cur_cnt = cp_after_ptr_len;
        else if (lit_valid)
          cur_cnt = {13'b0, lit_cnt}; 
        else
          cur_cnt = {11'b0, hb_bytes};
        
     end 

   assign ptr_bytes = (first_read) ? bytes_offset_to_read : curr_offset;
   assign tmp_ag = ptr_bytes + hb_bytes - 5'd16; 
   assign tmp_pause = ptr_bytes - 5'd16; 
   assign tmp_curr = ptr_bytes + hb_bytes; 

   assign cur_pos_ag = cur_pos + cur_cnt - 5'd16; 
   assign cur_pos_cur = cur_pos + cur_cnt; 


   assign his_buf_cur  = his_buf_cnt + 5'd16; 
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         copy_in_pgrss <= 0;
         curr_cp_len <= 0;
         curr_len <= 0;
         curr_offset <= 0;
         ptr_in_pgrss <= 0;
         r_copy_after_hb_read <= 0;
         r_copy_in_pgrss <= 0;
         r_ep_pause <= 0;
         r_from_offset <= 0;
         r_hb_read <= 0;
         r_last_word_rd <= 0;
         r_ptr_length <= 0;
         r_ptr_offset <= 0;
         r_to_offset <= 0;
         
      end
      else begin
         r_ep_pause <= ep_pause && !ptr_valid;
         
         if (!ep_pause || ptr_valid)
           r_last_word_rd <= last_word_rd;
         
         r_from_offset <= from_offset;
         r_to_offset <= to_offset;
         r_hb_read <= hb_read;
         
         if (copy_after_hb_read) begin
            r_copy_after_hb_read <= copy_after_hb_read;
            r_ptr_offset <= ptr_offset;
            r_ptr_length <= ptr_length;
         end
         else if (r_copy_after_hb_read && (curr_len == 0) && !r_hb_read && !r_last_word_rd && !ep_pause) begin
            r_copy_after_hb_read <= 1'b0;
            r_ptr_offset <= '0;
            r_ptr_length <= '0;
         end
         if (ep_bm_eof) begin
            curr_len <= '0;
            ptr_in_pgrss <= 1'b0;
         end
         else if ((hb_read || last_word_rd)) begin
            curr_len <= updated_len;
            ptr_in_pgrss <= ((updated_len > 0) || r_copy_after_hb_read) ?  1'b1 : 1'b0;
         end
         else if (!ep_pause) begin
            ptr_in_pgrss <= 1'b0;
            curr_len <= '0;
         end
         r_copy_in_pgrss <= copy_in_pgrss;
         
         if (ep_bm_eof) begin
            curr_cp_len <= '0;
            copy_in_pgrss <= 1'b0;
         end
         else if (copy_in_pgrss && !bm_ep_pause) begin
            if (curr_cp_len > 5'd16) begin
               curr_cp_len <= curr_cp_len - 5'd16; 
            end
            else if (!bm_ep_pause) begin
               curr_cp_len <= '0;
               copy_in_pgrss <= 1'b0;
            end
         end
         else if (copy_valid || cp_after_ptr) begin
            if ((copy_valid && copy_length > 16) || 
                (cp_after_ptr && cp_after_ptr_len > 16)) begin
               copy_in_pgrss <= 1'b1;
            end
            else
              copy_in_pgrss <= 1'b0;
            
            if (copy_valid) begin
               curr_cp_len <= copy_length;
            end
            else begin
               if (cp_after_ptr) begin
                  curr_cp_len <= cp_after_ptr_len;
               end
            end 
         end
         
         if (ep_bm_eof)
           curr_offset <= '0;
         else if (ptr_valid || hb_read || last_word_rd) begin
            if (ag_ep_head_moved)
              curr_offset <= tmp_ag;
            else
              curr_offset <= tmp_curr;
         end
         else if (ptr_in_pgrss) begin
            if (ag_ep_head_moved)
              curr_offset <= tmp_pause;
         end

      end 
   end 

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         cur_pos <= 0;
         ep_bm_eob <= 0;
         ep_bm_eof <= 0;
         ep_bm_eof_err_code <= 0;
         his_buf_cnt <= 0;
         r_ep_eob <= 0;
         r_ep_eof <= 0;
         r_ep_eof_err_code <= 0;
         
      end
      else begin
         ep_bm_eof <= r_ep_eof && !(ep_bm_ptr_valid || ep_bm_lit_valid ||
                                    ep_bm_copy_valid);
         ep_bm_eob <= r_ep_eob && !(ep_bm_ptr_valid || ep_bm_lit_valid ||
                                    ep_bm_copy_valid);
         
         if (r_ep_eof_err_code == '0) begin
            if (r_offset_err)
              ep_bm_eof_err_code <= HD_LZ_HBIF_SOFT_OFLOW;
            else
              ep_bm_eof_err_code <= r_ep_eof_err_code;
         end
         else
           ep_bm_eof_err_code <= r_ep_eof_err_code;
         
         if (eof_valid || eob_valid) begin
            if (eob_valid)
              r_ep_eob <= 1'b1;
            else begin
               r_ep_eof <= 1'b1;
               r_ep_eof_err_code <= eof_err_code;
            end
         end
         else if (!(ep_bm_ptr_valid || ep_bm_lit_valid ||
                    ep_bm_copy_valid) && (r_ep_eof || r_ep_eob)) begin
            r_ep_eof <= 1'b0;
            r_ep_eob <= 1'b0;
            r_ep_eof_err_code <= '0;
         end
         
         if (ep_bm_eof) begin 
            cur_pos <= {1'b0, cur_cnt}; 
            his_buf_cnt <= '0;
         end
         else begin
            if (pl_ep_prefix_load) begin 
               cur_pos <= pl_ep_prefix_cnt; 
               his_buf_cnt <= pl_ep_prefix_cnt;
            end
            else begin
               if (ag_ep_hb_wr && !ag_ep_head_moved) begin
                  his_buf_cnt <= his_buf_cur;
               end
               
               
               

 
               
               if (ag_ep_head_moved) 
                 cur_pos <= cur_pos_ag;
               else
                 cur_pos <= cur_pos_cur;
            end 
         end 
      end 
   end 

   
   always_comb
     begin
        ptr_256 = 1'b0;
        ptr_128 = 1'b0;
        ptr_64 = 1'b0;
        ptr_32 = 1'b0;
        ptr_11 = 1'b0;
        ptr_10 = 1'b0;
        ptr_9 = 1'b0;
        ptr_8 = 1'b0;
        ptr_7 = 1'b0;
        ptr_6 = 1'b0;
        ptr_5 = 1'b0;
        ptr_4 = 1'b0;
        ptr_3 = 1'b0;

        if (ptr_valid && r_trace_bit) begin
           if (ptr_length > 16'd255)
             ptr_256 = 1'b1;
           else if (ptr_length > 16'd127)
             ptr_128 = 1'b1;
           else if (ptr_length > 16'd63)
             ptr_64 = 1'b1;
           else if (ptr_length > 16'd31)
             ptr_32 = 1'b1;
           else if (ptr_length > 16'd10)
             ptr_11 = 1'b1;
           else if (ptr_length == 16'd10)
             ptr_10 = 1'b1;
           else if (ptr_length == 16'd9)
             ptr_9 = 1'b1;
           else if (ptr_length == 16'd8)
             ptr_8 = 1'b1;
           else if (ptr_length == 16'd7)
             ptr_7 = 1'b1;
           else if (ptr_length == 16'd6)
             ptr_6 = 1'b1;
           else if (ptr_length == 16'd5)
             ptr_5 = 1'b1;
           else if (ptr_length == 16'd4)
             ptr_4 = 1'b1;
           else if (ptr_length == 16'd3)
             ptr_3 = 1'b1;
        end 
     end 
   
       
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         ptr_10_stb <= 0;
         ptr_11_stb <= 0;
         ptr_128_stb <= 0;
         ptr_256_stb <= 0;
         ptr_32_stb <= 0;
         ptr_3_stb <= 0;
         ptr_4_stb <= 0;
         ptr_5_stb <= 0;
         ptr_64_stb <= 0;
         ptr_6_stb <= 0;
         ptr_7_stb <= 0;
         ptr_8_stb <= 0;
         ptr_9_stb <= 0;
         
      end
      else begin
         ptr_256_stb <= ptr_256;
         ptr_128_stb <= ptr_128;
         ptr_64_stb <= ptr_64;
         ptr_32_stb <= ptr_32;
         ptr_11_stb <= ptr_11;
         ptr_10_stb <= ptr_10;
         ptr_9_stb <= ptr_9;
         ptr_8_stb <= ptr_8;
         ptr_7_stb <= ptr_7;
         ptr_6_stb <= ptr_6;
         ptr_5_stb <= ptr_5;
         ptr_4_stb <= ptr_4;
         ptr_3_stb <= ptr_3;
      end 
   end 

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         lz_bytes_decomp <= 0;
         lz_hb_bytes <= 0;
         lz_local_bytes <= 0;
         
      end
      else begin
         lz_bytes_decomp <= cur_pos;
         lz_local_bytes <= (cur_pos - his_buf_cnt); 
         lz_hb_bytes <= his_buf_cnt;
      end
   end

   
   genvar k, l;
   generate
      for (k=0; k < 1; k++) begin
         for (l=k; l < 16; l++) begin
            `COVER_PROPERTY(ep_bm_ptr_valid && (ep_bm_from_offset == k) && (ep_bm_to_offset ==l));
         end
      end
   endgenerate
   `COVER_PROPERTY(ep_bm_ptr_valid && (ep_bm_from_offset == 0) && (ep_bm_to_offset ==0));
   `COVER_PROPERTY(ep_bm_ptr_valid && (ep_bm_from_offset == 15) && (ep_bm_to_offset ==15));

   
   
   genvar kk, ll;
   generate
      for (kk=1; kk < 16; kk++) begin
         for (ll=kk+2; ll < 16; ll++) begin
            `COVER_PROPERTY(ep_bm_ptr_valid && (ep_bm_from_offset == kk) && (ep_bm_to_offset ==ll));
         end
      end
   endgenerate
   
   
endmodule 







