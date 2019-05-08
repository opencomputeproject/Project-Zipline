/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/














module cr_xp10_decomp_lz77_bm (
   
   bm_ep_copy_done, bm_do_odd_word, bm_do_odd_valid, bm_do_odd_type,
   bm_do_odd_bytes_valid, bm_do_even_word, bm_do_even_valid,
   bm_do_even_type, bm_do_even_bytes_valid, bm_ep_pause,
   
   clk, rst_n, ep_bm_lit_valid, ep_bm_num_lit, ep_bm_lit_data,
   ep_bm_ptr_valid, ep_bm_from_offset, ep_bm_to_offset, ag_bm_hb_data,
   ep_bm_lwrd_valid, ep_bm_lwl, ep_bm_copy_valid, ep_bm_copy_offset,
   ep_bm_copy_length, ep_bm_eof, ep_bm_eof_err_code, ep_bm_eob,
   do_bm_pause
   );
   import crPKG::lz_symbol_bus_t;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   input                   clk;
   input                   rst_n;
   
   
   input                   ep_bm_lit_valid;
   input [1:0]             ep_bm_num_lit;
   input [31:0]            ep_bm_lit_data;

   
   input                   ep_bm_ptr_valid;
   input [3:0]             ep_bm_from_offset;
   input [3:0]             ep_bm_to_offset;
   input [127:0]           ag_bm_hb_data;
   input                   ep_bm_lwrd_valid;
   input [5:0]             ep_bm_lwl;
   
   
   input                   ep_bm_copy_valid;
   input [4:0]             ep_bm_copy_offset;
   input [15:0]            ep_bm_copy_length;
   output logic            bm_ep_copy_done;

   input                   ep_bm_eof;
   input [31:0]            ep_bm_eof_err_code;
   input                   ep_bm_eob;
   
   
   output logic [63:0]     bm_do_odd_word;
   output logic            bm_do_odd_valid;
   output logic [1:0]      bm_do_odd_type;
   output logic [2:0]      bm_do_odd_bytes_valid;
   
   output logic [63:0]     bm_do_even_word;
   output logic            bm_do_even_valid;
   output logic [1:0]      bm_do_even_type;
   output logic [2:0]      bm_do_even_bytes_valid;

   input                   do_bm_pause;
   output                  bm_ep_pause;
   
   logic                   last_sent;
   logic                   word0_valid;
   logic [63:0]            word0;
   logic                   word1_valid;
   logic [63:0]            word1;
   logic                   saved_valid;
   logic [63:0]            saved_word;
   logic [63:0]            next_word;
   logic [2:0]             next_cnt;

   logic [4:0]             vld_cnt;
   logic [2:0]             saved_cnt;
   logic [127:0]           new_word;
   logic [127:0]           word_to_send;
   logic [4:0]             word_cnt;
   
   logic [127:0]           prev_word;

   logic [2:0]             total_lit;

   logic [63:0]            part_word;
   logic                   part_word_valid;
   logic [63:0]            saved_part_word;
   logic                   saved_part_word_valid;

   logic [127:0]           hb_word;
   logic                   hb_word_valid;
   logic [127:0]           cur_hb_word;
   logic                   cur_hb_word_valid;
   logic [127:0]           prev_hb_word;
   logic                   prev_hb_word_valid;
   logic [127:0]           p_prev_hb_word;
   logic                   p_prev_hb_word_valid;

   logic [127:0]           lwlrd_word;

   logic [3:0]             from_offset;
   logic [127:0]           word_in;
   
   logic [15:0]            r_cp_length;
   logic [15:0]            cp_length;
   logic                   in_copy;

   logic [4:0]             new_cp_cnt;
   logic [191:0]           new_cp_word;

   logic [127:0]           cp_bytes;
   logic [127:0]           cp_c_bytes;
   logic [4:0]             cp_bytes_offset;

   logic [4:0]             cp_word_cnt;
   logic [127:0]           cp_word;
   logic [4:0]             cp_offset;

   logic [15:0]            to_copy;
   logic [15:0]            l_cnt;
   logic [3:0]             saved_part_cnt;
   logic [3:0]             local_saved_cnt;

   logic                   r_bm_eof;
   logic [31:0]            r_bm_eof_err_code;
   logic                   r_bm_eob;
   
   logic                   bm_lit_valid;
   logic [1:0]             bm_num_lit;
   logic [31:0]            bm_lit_data;

   
   logic                   bm_ptr_valid;
   logic [3:0]             bm_from_offset;
   logic [3:0]             bm_to_offset;
   logic [127:0]           bm_hb_data;
   logic                   bm_lwrd_valid;
   logic [5:0]             bm_lwl;
   
   
   logic                   bm_copy_valid;
   logic [4:0]             bm_copy_offset;
   logic [15:0]            bm_copy_length;

   logic                   bm_eof;
   logic                   bm_eob;
   
   logic [31:0]            bm_eof_err_code;
   logic                   r_do_bm_pause;
   

 
   assign bm_ep_copy_done = (!in_copy && (!bm_copy_valid && !ep_bm_copy_valid));
   
   assign bm_ep_pause = do_bm_pause;
   
   
   
   
   always_comb
     begin
        vld_cnt = '0;
        new_word = '0;
        from_offset = '0;
        word_in = '0;
        cp_bytes_offset = '0;
        cp_bytes = '0;
        cp_c_bytes = '0;
        cp_word_cnt = '0;
        
        
        total_lit = (bm_num_lit == 2'b00) ? 3'b100 : {1'b0, bm_num_lit};
        if (bm_lit_valid) begin
           vld_cnt = {2'b0, total_lit};
           word_in = {96'b0, bm_lit_data};
           from_offset = 4'h0;
        end
        
        else if (bm_ptr_valid || bm_lwrd_valid) begin
           vld_cnt = (bm_to_offset - bm_from_offset) +1;
           if (bm_ptr_valid)
             word_in = bm_hb_data;
           else         
             word_in = lwlrd_word;
           from_offset = bm_from_offset;
        end
        else if (bm_copy_valid) begin
           {cp_bytes_offset, cp_bytes} = get_copy_bytes(new_cp_word, new_cp_cnt,
                                                        prev_word, 
                                                        bm_copy_offset,
                                                        bm_copy_length);
           {cp_word_cnt, cp_c_bytes} = copy_into_new_word(cp_bytes, 
                                                          '0,
                                                          bm_copy_length);
           vld_cnt = cp_word_cnt;
           word_in = cp_c_bytes;
           from_offset = 4'b0;
        end
        
        else if (in_copy && !r_do_bm_pause) begin
           {cp_word_cnt, cp_c_bytes} = copy_into_new_word(cp_word, 
                                                          cp_offset,
                                                          cp_length);
           vld_cnt = cp_word_cnt;
           word_in = cp_c_bytes;
           from_offset = 4'b0;
        end
        new_word = get_bytes_from_word(word_in,
                                       from_offset,         
                                       vld_cnt);

     end 

   always_comb
     begin
        new_cp_cnt = '0;
        new_cp_word = '0;
        {new_cp_cnt, new_cp_word} = pack_saved_and_current(word_to_send,
                                                           word_cnt,
                                                           saved_word,
                                                           saved_cnt);

        
        {word0, word0_valid, word1, word1_valid, next_word, next_cnt} =
               pack_into_8_bytes(new_cp_word, new_cp_cnt);


           
     end 

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         cp_length <= 16'h0;
         cp_offset <= 5'h0;
         cp_word <= 128'h0;
         r_do_bm_pause <= 1'h0;
         word_cnt <= 5'h0;
         word_to_send <= 128'h0;
         
      end
      else begin
         word_to_send <= new_word;
         word_cnt <= vld_cnt;
         r_do_bm_pause <= do_bm_pause;
         
         if (bm_copy_valid) begin
            
            
            cp_word <= cp_bytes;
            if (bm_copy_length > 5'd16)
              cp_length <= bm_copy_length - 5'd16; 
            else
              cp_length <= '0;
            
            cp_offset <= cp_bytes_offset;
         end
         else if (in_copy && !r_do_bm_pause) begin
            cp_word <= cp_c_bytes;
            if (cp_length > 5'd16)
              cp_length <= cp_length - 5'd16; 
            else
              cp_length <= '0;
            
         end
      end 
   end 
   
   assign l_cnt = (bm_copy_valid) ? bm_copy_length : r_cp_length;
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         in_copy <= 1'h0;
         r_bm_eob <= 1'h0;
         r_bm_eof <= 1'h0;
         r_bm_eof_err_code <= 32'h0;
         r_cp_length <= 16'h0;
         to_copy <= 16'h0;
         
      end
      else begin
         r_bm_eof <= bm_eof;
         r_bm_eof_err_code <= bm_eof_err_code;
         r_bm_eob <= bm_eob;
         
         if (bm_copy_valid && (bm_copy_length > 5'd16))
           in_copy <= 1'b1;
         else if ((to_copy <= 5'd16) && !r_do_bm_pause)
           in_copy <= 1'b0;

         
         if (bm_copy_valid && (bm_copy_length > 5'd16))
           to_copy <= bm_copy_length - 5'd16; 
         else if (!r_do_bm_pause) begin
            if (to_copy > 5'd16)
              to_copy <= to_copy - 5'd16 ; 
            else
              to_copy <= '0;
         end
         
         if (bm_copy_valid || (in_copy && !r_do_bm_pause)) begin
            if (l_cnt > 5'd16) 
              r_cp_length <= (l_cnt - 5'd16); 
            else
              r_cp_length <= '0;
         end
      end
   end

   assign saved_part_cnt = (saved_part_word_valid) ? 4'd8 : 4'd0;
   assign local_saved_cnt = saved_part_cnt + new_cp_cnt[3:0]; 
   
   
   
   
   
   
   
   
   always_comb
     begin
        lwlrd_word = '0;
        if ((bm_lwl <= {1'b0, new_cp_cnt}) && (new_cp_cnt < 5'd16))
          lwlrd_word = {new_cp_word[127:0]};
        else if (bm_lwl < 16) begin
           if (bm_lwl <= ({2'b0, local_saved_cnt}))
             lwlrd_word = {saved_word, saved_part_word}; 

  
           else
             lwlrd_word = {cur_hb_word};
        end
        else if (bm_lwl < 32) begin
           if (bm_lwl <= (local_saved_cnt + 16)) begin 
              if (hb_word_valid)
                lwlrd_word = hb_word;
              else
                lwlrd_word = cur_hb_word;
           end
           else if (hb_word_valid)
             lwlrd_word = cur_hb_word;
           else
             lwlrd_word = prev_hb_word;
        end
        else if (bm_lwl < 48) begin
           if (bm_lwl <= (local_saved_cnt + 32)) begin
              if (hb_word_valid)
                lwlrd_word = cur_hb_word;
              else
                lwlrd_word = prev_hb_word;
           end
           else if (hb_word_valid)
             lwlrd_word = prev_hb_word;
           else
             lwlrd_word = p_prev_hb_word;
        end
        else begin
           if (bm_lwl <= (local_saved_cnt + 48)) begin
              if (hb_word_valid) 
                 lwlrd_word = prev_hb_word;
              else
                lwlrd_word = p_prev_hb_word;
           end
           else 
             lwlrd_word = p_prev_hb_word;
        end
     end 
   
   
   
   
   function logic [132:0] copy_into_new_word;
      input [127:0] copy_bytes;
      input [4:0]   copy_offset;
      input [15:0]  copy_length;

      logic [4:0]   f_to_copy;

      logic [127:0] tmp_wd;
      logic [127:0] mask_word;
      logic [127:0] tmp_copy_word;
      logic [4:0]   m_cnt;
      logic [127:0] tmp_copy_bytes;
      
      begin
         
         if (|copy_length[15:4]) f_to_copy = 5'd16;
         else f_to_copy = copy_length[4:0];

         
         
         
         tmp_copy_bytes = copy_bytes >> (copy_offset*8);
         
          case (copy_offset)
            5'b00000 : tmp_wd = copy_bytes;
            5'b00001 : tmp_wd = {tmp_copy_bytes[7:0], tmp_copy_bytes[119:0]};
            5'b00010 : tmp_wd = {tmp_copy_bytes[15:0], tmp_copy_bytes[111:0]};
            5'b00011 : tmp_wd = {tmp_copy_bytes[23:0], tmp_copy_bytes[103:0]};
            5'b00100 : tmp_wd = {tmp_copy_bytes[31:0], tmp_copy_bytes[95:0]};
            5'b00101 : tmp_wd = {tmp_copy_bytes[39:0], tmp_copy_bytes[87:0]};
            5'b00110 : tmp_wd = {tmp_copy_bytes[47:0], tmp_copy_bytes[79:0]};
            5'b00111 : tmp_wd = {tmp_copy_bytes[55:0], tmp_copy_bytes[71:0]};
            5'b01000 : tmp_wd = {tmp_copy_bytes[63:0], tmp_copy_bytes[63:0]};
            5'b01001 : tmp_wd = {tmp_copy_bytes[71:0], tmp_copy_bytes[55:0]};
            5'b01010 : tmp_wd = {tmp_copy_bytes[79:0], tmp_copy_bytes[47:0]};
            5'b01011 : tmp_wd = {tmp_copy_bytes[87:0], tmp_copy_bytes[39:0]};
            5'b01100 : tmp_wd = {tmp_copy_bytes[95:0], tmp_copy_bytes[31:0]};
            5'b01101 : tmp_wd = {tmp_copy_bytes[103:0], tmp_copy_bytes[23:0]};
            5'b01110 : tmp_wd = {tmp_copy_bytes[111:0], tmp_copy_bytes[15:0]};
            5'b01111 : tmp_wd = {tmp_copy_bytes[119:0], tmp_copy_bytes[7:0]};
            default : tmp_wd = tmp_copy_bytes;
          endcase
           
         m_cnt = 16 - f_to_copy; 
         
         mask_word = {128{1'b1}} >> (m_cnt *8);
         tmp_copy_word = (tmp_wd & mask_word);
         
         copy_into_new_word = {f_to_copy, tmp_copy_word};
      end
   endfunction 
   
   
   
   function logic [127:0] get_bytes_from_word;
      input [127:0] word;
      input [3:0]   from_off;
      input [4:0]   t_cnt;
      logic [127:0] local_word;
      logic [127:0] mask_word;
      logic [127:0] tmp_word;
      
      logic [4:0]   m_cnt;
      
      begin

         local_word = 128'b0;
         tmp_word = word >> (from_off *8);
         m_cnt = 16 - t_cnt; 
         
         mask_word = {128{1'b1}} >> (m_cnt *8);
         local_word = (tmp_word & mask_word);
         
         get_bytes_from_word = local_word;
      end
   endfunction 

   
   
   
   function logic [132:0] get_copy_bytes;
      input [191:0] cur_word;
      input [4:0]   cur_word_cnt;
      input [127:0] prev_word;
      input [4:0]   offset;
      input [15:0]  length;
      
      logic [4:0]   prev_cnt;
      logic [3:0]   prev_offset;
      logic [127:0] new_prev_word;
      logic [4:0]   f_cp_byte_cnt;
      logic [127:0] f_cp_bytes;
      logic [127:0] new_cur_word;
      logic [4:0]   cur_offset;
      logic [127:0] tmp_wd;
      logic [4:0]   o_i;
      logic [191:0] tmp_cur_word;
      
      begin
         f_cp_byte_cnt = '0;
         f_cp_bytes = '0;
         prev_offset = '0;
         new_prev_word = '0;
         new_cur_word = '0;
         cur_offset = '0;
         prev_cnt = '0;
         
         if (offset > cur_word_cnt) begin
            
            prev_cnt = offset - cur_word_cnt; 
            prev_offset = 5'd16 - prev_cnt; 
            new_prev_word = get_bytes_from_word(prev_word, prev_offset, prev_cnt);
            new_cur_word = cur_word << (prev_cnt * 8); 
            f_cp_bytes = new_prev_word | new_cur_word;
            if (length < {11'b0, offset})
              f_cp_byte_cnt = length[4:0];
            else
              f_cp_byte_cnt = offset;
         end
         else begin
            cur_offset = cur_word_cnt - offset; 
            tmp_cur_word = cur_word >> (cur_offset *8);
            cur_offset = 0;
            new_cur_word = get_bytes_from_word(tmp_cur_word, cur_offset, offset);
            f_cp_bytes = new_cur_word;
            if (length < {11'b0, offset})
              f_cp_byte_cnt = length[4:0];
            else
              f_cp_byte_cnt = offset;
         end 
         
         {o_i, tmp_wd} = fill_cp_bytes_in_word(f_cp_byte_cnt, f_cp_bytes);

         get_copy_bytes = {o_i, tmp_wd};
      end
      
   endfunction 

   
   function logic [132:0] fill_cp_bytes_in_word;
      input [4:0] f_cp_byte_cnt;
      input [127:0] f_cp_bytes;
      logic [4:0]   o_i; 
      logic [127:0] tmp_wd;
      begin
         case (f_cp_byte_cnt)
           5'b00001 : begin
              tmp_wd = {16{f_cp_bytes[7:0]}};
              o_i = 5'b0;
           end
           5'b00010 : begin
              tmp_wd = {8{f_cp_bytes[15:0]}};
              o_i = 5'b0;
           end
           5'b00011 : begin
              tmp_wd = {f_cp_bytes[7:0],{5{f_cp_bytes[23:0]}}};
              o_i = 5'b00001;
           end
           5'b00100 : begin
              tmp_wd = {4{f_cp_bytes[31:0]}};
              o_i = 5'b0;
           end
           5'b00101 : begin
              tmp_wd = {f_cp_bytes[7:0],{3{f_cp_bytes[39:0]}}};
              o_i = 5'b00001;
           end
           5'b00110 : begin
              tmp_wd = {f_cp_bytes[31:0],{2{f_cp_bytes[47:0]}}};
              o_i = 5'b00100;
           end
           5'b00111 : begin
              tmp_wd = {f_cp_bytes[15:0],{2{f_cp_bytes[55:0]}}};
              o_i = 5'b00010;
           end
           5'b01000 : begin
              tmp_wd = {2{f_cp_bytes[63:0]}};
              o_i = 5'b0;
           end
           5'b01001 : begin
              tmp_wd = {f_cp_bytes[55:0],{1{f_cp_bytes[71:0]}}};
              o_i = 5'b00111;
           end
           5'b01010 : begin
              tmp_wd = {f_cp_bytes[47:0],{1{f_cp_bytes[79:0]}}};
              o_i = 5'b00110;
           end
           5'b01011 : begin
              tmp_wd = {f_cp_bytes[39:0],{1{f_cp_bytes[87:0]}}};
              o_i = 5'b00101;
           end
           5'b01100 : begin
              tmp_wd = {f_cp_bytes[31:0],{1{f_cp_bytes[95:0]}}};
              o_i = 5'b00100;
           end
           5'b01101 : begin
              tmp_wd = {f_cp_bytes[23:0],{1{f_cp_bytes[103:0]}}};
              o_i = 5'b00011;
           end
           5'b01110 : begin
              tmp_wd = {f_cp_bytes[15:0],{1{f_cp_bytes[111:0]}}};
              o_i = 5'b00010;
           end
           5'b01111 : begin
              tmp_wd = {f_cp_bytes[7:0],{1{f_cp_bytes[119:0]}}};
              o_i = 5'b00001;
           end
           5'b10000 : begin
              tmp_wd = {1{f_cp_bytes[127:0]}};
              o_i = 5'b00000;
           end
           default : begin
              tmp_wd = 128'b0;
              o_i = '0;
           end
         endcase 
         fill_cp_bytes_in_word = {o_i, tmp_wd};
         
      end
   endfunction 
   

   
   
   
   
   

   function logic [196:0] pack_into_8_bytes;
      input [191:0] local_word;
      input [4:0]   l_cur_cnt;
      
      logic [63:0]  f_word;
      logic [63:0]  s_word;
      logic [63:0]  n_word;
      logic [2:0]   n_word_cnt;
      
      logic [4:0]   l_cur_cnt;
      logic         s_word_valid;
      logic         f_word_valid;
      logic         n_word_valid;
      
   begin

      f_word = local_word[63:0];
      s_word = local_word[127:64];
      f_word_valid = 1'b0;
      s_word_valid = 1'b0;
      n_word_valid = 1'b0;
      n_word_cnt = '0;
      n_word = '0;

      if (l_cur_cnt[4]) begin
         f_word_valid = 1'b1;
         s_word_valid = 1'b1;
         n_word_valid = 1'b1;
         n_word_cnt = l_cur_cnt[2:0];
      end
      else if (l_cur_cnt[3]) begin
         f_word_valid = 1'b1;
         n_word_valid = 1'b1;
         s_word_valid = 1'b0;
         n_word_cnt = l_cur_cnt[2:0];
      end
      else begin
         n_word_valid = 1'b1;
         n_word_cnt = l_cur_cnt[2:0];
      end

      if (f_word_valid && s_word_valid)
        n_word = local_word[191:128];
      else if (f_word_valid)
        n_word = local_word[127:64];
      else
        n_word = local_word[63:0];
      

      pack_into_8_bytes = {f_word, f_word_valid,
                           s_word, s_word_valid,
                           n_word, n_word_cnt};
   end
   endfunction 

   function logic [196:0] pack_saved_and_current;
      input [127:0] cur_word;
      input [4:0]   cur_cnt;
      input [63:0]  sav_word;
      input [3:0]   sav_cnt;
      logic [191:0] lword;
      logic [191:0] lword1;
      logic [191:0] local_word;
      logic [4:0]   l_cur_cnt;
      
      begin
         lword1 = {128'b0, sav_word};
         lword = cur_word << (sav_cnt *8); 
         local_word = lword | lword1;
         l_cur_cnt = cur_cnt + sav_cnt; 
         pack_saved_and_current = {l_cur_cnt, local_word};
      end
   endfunction 

   function logic [196:0] pack_saved_and_current_to_copy;
      input [127:0] cur_word;
      input [4:0]   cur_cnt;
      input [191:0] prev_word;
      input [4:0]   prev_cnt;

      logic [191:0] lword;
      logic [191:0] lword1;
      logic [191:0] local_word;
      logic [4:0]   l_cur_cnt;
      logic [4:0]   s_cnt;
      logic [4:0]   shift_cnt;
      
      begin
         if (prev_cnt[4]) begin
            s_cnt = cur_cnt;
            shift_cnt = 5'd16 - cur_cnt; 
         end
         else begin
            s_cnt = 0;
            shift_cnt = prev_cnt;
         end

         lword1 = prev_word >> (s_cnt * 8);
         lword = cur_word << (shift_cnt *8); 
         local_word = lword | lword1;
         l_cur_cnt = shift_cnt + cur_cnt; 
         pack_saved_and_current_to_copy = {l_cur_cnt, local_word};
      end
   endfunction 
   
   
   

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         bm_do_even_bytes_valid <= 3'h0;
         bm_do_even_type <= 2'h0;
         bm_do_even_valid <= 1'h0;
         bm_do_even_word <= 64'h0;
         bm_do_odd_bytes_valid <= 3'h0;
         bm_do_odd_type <= 2'h0;
         bm_do_odd_valid <= 1'h0;
         bm_do_odd_word <= 64'h0;
         last_sent <= 1'h0;
         saved_cnt <= 3'h0;
         saved_valid <= 1'h0;
         saved_word <= 64'h0;
         
      end
      else begin
         bm_do_even_valid <= 1'b0;
         bm_do_odd_valid <= 1'b0;
         saved_valid <= 1'b0;
         if (word0_valid || word1_valid) begin
            if (word0_valid) begin
               if (last_sent) begin
                  bm_do_even_word <= word0;
                  bm_do_even_type <= 2'b01;
                  bm_do_even_bytes_valid <= 3'b000;
                  bm_do_even_valid <= 1'b1;
               end
               else begin
                  bm_do_odd_word <= word0;
                  bm_do_odd_type <= 2'b01;
                  bm_do_odd_bytes_valid <= 3'b000;
                  bm_do_odd_valid <= 1'b1;
               end
            end
            if (word1_valid) begin
               if (last_sent) begin
                  bm_do_odd_word <= word1;
                  bm_do_odd_type <= 2'b01;
                  bm_do_odd_bytes_valid <= 3'b000;
                  bm_do_odd_valid <= 1'b1;
               end
               else begin
                  bm_do_even_word <= word1;
                  bm_do_even_type <= 2'b01;
                  bm_do_even_bytes_valid <= 3'b0;
                  bm_do_even_valid <= 1'b1;
               end
            end 
         end 
         else if (r_bm_eob) begin
            if (saved_cnt > 0) begin
               if (last_sent) begin
                  bm_do_even_word <= saved_word;
                  bm_do_even_type <= 2'b00;
                  bm_do_even_bytes_valid <= saved_cnt;
                  bm_do_even_valid <= 1'b1;
               end
               else begin
                  bm_do_odd_word <= saved_word;
                  bm_do_odd_type <= 2'b00;
                  bm_do_odd_bytes_valid <= saved_cnt;
                  bm_do_odd_valid <= 1'b1;
                  bm_do_even_word <= '0;
                  bm_do_even_type <= 2'b00;
                  bm_do_even_bytes_valid <= '0;
                  bm_do_even_valid <= 1'b1;
               end
            end
         end 
         else if (r_bm_eof) begin
            if (saved_cnt > 0) begin 
               if (last_sent) begin
                  bm_do_even_word <= saved_word;
                  bm_do_even_type <= 2'b01;
                  bm_do_even_bytes_valid <= saved_cnt;
                  bm_do_even_valid <= 1'b1;
                  bm_do_odd_word <= {32'b0, r_bm_eof_err_code};
                  if (r_bm_eof_err_code == 0)
                    bm_do_odd_type <= 2'b10;
                  else
                    bm_do_odd_type <= 2'b11;
                  bm_do_odd_bytes_valid <= 3'b000;
                  bm_do_odd_valid <= 1'b1;
               end
               else begin
                  bm_do_odd_word <= saved_word;
                  bm_do_odd_type <= 2'b01;
                  bm_do_odd_bytes_valid <= saved_cnt;
                  bm_do_odd_valid <= 1'b1;
                  bm_do_even_word <= {32'b0, r_bm_eof_err_code};
                  if (r_bm_eof_err_code == 0)
                    bm_do_even_type <= 2'b10;
                  else
                    bm_do_even_type <= 2'b11;
                  bm_do_even_bytes_valid <= 3'b000;
                  bm_do_even_valid <= 1'b1;               
               end 
            end 
            else begin
               if (last_sent) begin
                  bm_do_even_word <= {32'b0, r_bm_eof_err_code};
                  if (r_bm_eof_err_code == 0)
                    bm_do_even_type <= 2'b10;
                  else
                    bm_do_even_type <= 2'b11;
                  bm_do_even_bytes_valid <= 3'b000;
                  bm_do_even_valid <= 1'b1;
               end
               else begin
                  bm_do_odd_word <= {32'b0, r_bm_eof_err_code};
                  if (r_bm_eof_err_code == 0)
                    bm_do_odd_type <= 2'b10;
                  else
                    bm_do_odd_type <= 2'b11;
                  bm_do_odd_bytes_valid <= 3'b000;
                  bm_do_odd_valid <= 1'b1;
               end 
            end 
         end 
         else begin
            bm_do_even_valid <= 1'b0;
            bm_do_odd_valid <= 1'b0;
         end 

         if (r_bm_eof)
           last_sent <= 1'b0;
         else if (r_bm_eob)
           last_sent <= last_sent;
         else if ((word0_valid && !word1_valid))
           last_sent <= !last_sent;

         if (r_bm_eof || (next_cnt == 0)) begin
            saved_word <= '0;
            saved_valid <= 1'b0;
            saved_cnt <= '0;
         end
         else if (next_cnt > 0) begin
            saved_word <= next_word;
            saved_valid <= 1'b1;
            saved_cnt <= next_cnt;
         end
      end 
   end 
   

   
   
   always_comb
   begin
      part_word_valid = 1'b0;
      hb_word_valid = 1'b0;
      hb_word = '0;
      part_word = '0;
      
      if (word0_valid && word1_valid) begin
         if (last_sent) begin
            part_word = word1;
            part_word_valid = 1'b1;
            hb_word = {word0, saved_part_word};
            hb_word_valid = 1'b1;
         end
         else begin
            hb_word = {word1, word0};
            hb_word_valid = 1'b1;
         end
      end
      else if (word0_valid) begin
         if (saved_part_word_valid) begin
            hb_word = {word0, saved_part_word};
            hb_word_valid = 1'b1;
         end
         else begin
            part_word = word0;
            part_word_valid = 1'b1;
         end
      end

   end 

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         cur_hb_word <= 128'h0;
         cur_hb_word_valid <= 1'h0;
         p_prev_hb_word <= 128'h0;
         p_prev_hb_word_valid <= 1'h0;
         prev_hb_word <= 128'h0;
         prev_hb_word_valid <= 1'h0;
         saved_part_word <= 64'h0;
         saved_part_word_valid <= 1'h0;
         
      end
      else begin
         if (r_bm_eof) begin
            prev_hb_word_valid <= 1'b0;
            p_prev_hb_word_valid <= 1'b0;
            saved_part_word_valid <= 1'b0;
            cur_hb_word_valid <= 1'b0;
            prev_hb_word <= '0;
            p_prev_hb_word <= '0;
            cur_hb_word <= '0;
            saved_part_word <= '0;
         end
         else begin
            if (part_word_valid && hb_word_valid) begin
               cur_hb_word <= hb_word;
               cur_hb_word_valid <= 1'b1;
               saved_part_word <= part_word;
               saved_part_word_valid <= 1'b1;
               if (cur_hb_word_valid) begin
                  prev_hb_word <= cur_hb_word;
                  prev_hb_word_valid <= 1'b1;
               end
               if (prev_hb_word_valid) begin
                  p_prev_hb_word <= prev_hb_word;
                  p_prev_hb_word_valid <= 1'b1;
               end
            end
            else if (part_word_valid) begin
               saved_part_word <= part_word;
               saved_part_word_valid <= 1'b1;
            end
            else if (hb_word_valid) begin
               saved_part_word_valid <= 1'b0;
               saved_part_word <= '0;
               cur_hb_word <= hb_word;
               cur_hb_word_valid <= 1'b1;
               if (cur_hb_word_valid) begin
                  prev_hb_word <= cur_hb_word;
                  prev_hb_word_valid <= 1'b1;
               end
               if (prev_hb_word_valid) begin
                  p_prev_hb_word <= prev_hb_word;
                  p_prev_hb_word_valid <= 1'b1;
               end
            end
         end
      end 
   end 

   always_comb
   begin
      if (saved_part_word_valid) begin
         if (!cur_hb_word_valid)
           prev_word = {saved_part_word, 64'b0};
         else begin
            prev_word = {saved_part_word, cur_hb_word[127:64]};
         end
      end
      else begin
         prev_word = {cur_hb_word};
      end
   end 

   assign bm_hb_data = ag_bm_hb_data;

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         bm_copy_length <= 16'h0;
         bm_copy_offset <= 5'h0;
         bm_copy_valid <= 1'h0;
         bm_eob <= 1'h0;
         bm_eof <= 1'h0;
         bm_eof_err_code <= 32'h0;
         bm_from_offset <= 4'h0;
         bm_lit_data <= 32'h0;
         bm_lit_valid <= 1'h0;
         bm_lwl <= 6'h0;
         bm_lwrd_valid <= 1'h0;
         bm_num_lit <= 2'h0;
         bm_ptr_valid <= 1'h0;
         bm_to_offset <= 4'h0;
         
      end
      else begin
         bm_lit_valid <= ep_bm_lit_valid;
         bm_num_lit <= ep_bm_num_lit;
         bm_lit_data <= ep_bm_lit_data;
         
         bm_ptr_valid <= ep_bm_ptr_valid;
         bm_from_offset <= ep_bm_from_offset;
         bm_to_offset <= ep_bm_to_offset;
         bm_lwrd_valid <= ep_bm_lwrd_valid;
         bm_lwl <= ep_bm_lwl;
         bm_copy_valid <= ep_bm_copy_valid;
         bm_copy_offset <= ep_bm_copy_offset;
         bm_copy_length <= ep_bm_copy_length;
         
         bm_eof <= ep_bm_eof;
         bm_eof_err_code <= ep_bm_eof_err_code;

         bm_eob <= ep_bm_eob;
         
      end 
   end 
   
endmodule 


