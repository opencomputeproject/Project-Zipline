/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/












`include "cr_huf_comp.vh"
module cr_huf_comp_sm_xp
  (
   
   xp_symbol_map_intf, mtf_offset_out_0, mtf_offset_out_1,
   mtf_offset_out_2, mtf_offset_out_3,
   
   xp9, min_len, mtf, mtf_num, len, ofs, win_size, mtf_offset_0,
   mtf_offset_1, mtf_offset_2, mtf_offset_3, prev_mtf_or_ptr
   );
   
   import cr_huf_compPKG::*;
   
   input                                         xp9;
   input                                         min_len;
   input 					 mtf;
   input [`N_MAX_MTF_WIDTH-1:0] 		 mtf_num;
   input [`N_WINDOW_WIDTH-1:0] 			 len;
   input [`N_WINDOW_WIDTH-1:0] 			 ofs;
   input [3:0]                                   win_size;
   input [`N_WINDOW_WIDTH-1:0]                   mtf_offset_0;
   input [`N_WINDOW_WIDTH-1:0] 			 mtf_offset_1;
   input [`N_WINDOW_WIDTH-1:0] 			 mtf_offset_2;
   input [`N_WINDOW_WIDTH-1:0] 			 mtf_offset_3;
   input 					 prev_mtf_or_ptr;
   
   output s_symbol_map_intf                      xp_symbol_map_intf;
   output logic [`N_WINDOW_WIDTH-1:0] 		 mtf_offset_out_0;
   output logic [`N_WINDOW_WIDTH-1:0] 		 mtf_offset_out_1;
   output logic [`N_WINDOW_WIDTH-1:0] 		 mtf_offset_out_2;
   output logic [`N_WINDOW_WIDTH-1:0] 		 mtf_offset_out_3;
   
   logic [`N_SHRT_SYM_WIDTH-1:0] 		 shrt_base;
   logic [`N_WINDOW_WIDTH-1:0] 			 len_adj;     
   
   logic [`N_WINDOW_WIDTH-1:0] 			 mtf_ofs_nxt [0:3];
   logic [`N_MAX_NGRAM_WIDTH-1:0] 		 min_len_val;
   logic [`N_WINDOW_WIDTH-1:0] 			 compare_val_lo;
   logic [`N_WINDOW_WIDTH-1:0] 			 compare_val_hi;
   logic [16:0] 				 ofs_xtr_bits_pre; 
   logic [16:0] 				 shrt_pre;         
   logic [16:0] 				 long_pre;         
   logic [16:0] 				 len_adj_pre;      
   logic [16:0] 				 len_xtr_bits_pre; 
   logic [`N_MAX_MTF_WIDTH-1:0] 		 mtf_num_mod;
   logic [`N_WINDOW_WIDTH-1:0] 			 ofs_mod;
   
   typedef struct packed {
      cmd_lz77_win_size_e size;
   } win_size_t;
   
   typedef struct 	packed {
      cmd_lz77_min_match_len_e len;
   } min_len_t;

   min_len_t  min_len_mod;   
   win_size_t win_size_mod;
   
   always_comb begin
      if (mtf && xp9)
	min_len_mod                          = CHAR_3;
      else
	min_len_mod                          = {min_len};
      win_size_mod                           = {win_size};
      xp_symbol_map_intf.ofs_xtr_bits_len    = mtf ? 0 : floor_log(ofs);
      xp_symbol_map_intf.ofs_xtr_bits        = 0;
      xp_symbol_map_intf.len_xtr_bits_len    = 0;
      xp_symbol_map_intf.len_xtr_bits        = 0;
      xp_symbol_map_intf.long                = 0;
      xp_symbol_map_intf.long_vld            = 0;
      shrt_base                              = mtf ? {1'd0, (10'd256 + (mtf_num*16))} : 10'd320; 
      xp_symbol_map_intf.map_error_long      = 0;
      xp_symbol_map_intf.map_error_shrt      = 0;
      len_adj_pre                            = 0; 
      ofs_xtr_bits_pre                       = 0;
      min_len_val                            = 4;
      long_pre                               = 0;
      len_adj                                = 0;
      len_xtr_bits_pre                       = 0;
 
      
      if (min_len_mod.len == CHAR_3)
	min_len_val                          = 3;
      
      if (xp_symbol_map_intf.ofs_xtr_bits_len == 0) begin
	 xp_symbol_map_intf.ofs_xtr_bits     = 0;
      end
      else begin
	 ofs_xtr_bits_pre                    = ofs -  (2**xp_symbol_map_intf.ofs_xtr_bits_len); 
	 xp_symbol_map_intf.ofs_xtr_bits     = ofs_xtr_bits_pre[14:0];
      end
      
      compare_val_lo = min_len_val + 15;
      compare_val_hi = min_len_val + 248;
      if (len < compare_val_lo) begin
	 shrt_pre                            = shrt_base + xp_symbol_map_intf.ofs_xtr_bits_len*16 + (len - min_len_val);
	 xp_symbol_map_intf.shrt             = shrt_pre[9:0];
      end
      
      else if (len < compare_val_hi) begin
	 shrt_pre                            = {6'b0, shrt_base + (xp_symbol_map_intf.ofs_xtr_bits_len*16) + 15}; 
	 xp_symbol_map_intf.shrt             = shrt_pre[9:0];
	 long_pre                            = len - 15 - min_len_val;
	 xp_symbol_map_intf.long             = long_pre[7:0];
	 xp_symbol_map_intf.long_vld         = 1;
      end
      
      else begin
	 shrt_pre                            = {6'b0, shrt_base + (xp_symbol_map_intf.ofs_xtr_bits_len*16) + 15}; 
	 xp_symbol_map_intf.shrt             = shrt_pre[9:0];
	 len_adj_pre                         = len - 246 - min_len_val;
	 len_adj                             = len_adj_pre[15:0];
	 xp_symbol_map_intf.len_xtr_bits_len = floor_log(len_adj);
	 long_pre                            = 232 + xp_symbol_map_intf.len_xtr_bits_len;
	 xp_symbol_map_intf.long             = long_pre[7:0];
	 xp_symbol_map_intf.long_vld         = 1;
	 len_xtr_bits_pre                    = len_adj - (2**xp_symbol_map_intf.len_xtr_bits_len); 
	 xp_symbol_map_intf.len_xtr_bits     = len_xtr_bits_pre[14:0];
      end
      
      
      if (win_size_mod.size == WIN_4K) begin
	 if (xp_symbol_map_intf.long > `CREOLE_HC_MAX_LONG_4K) begin
	    xp_symbol_map_intf.map_error_long  = 1;
	    xp_symbol_map_intf.long            = `CREOLE_HC_MAX_LONG_4K;
	 end
	 if (xp_symbol_map_intf.shrt > `CREOLE_HC_MAX_SHORT_4K) begin
	    xp_symbol_map_intf.map_error_shrt  = 1;
	    xp_symbol_map_intf.shrt            = `CREOLE_HC_MAX_SHORT_4K;
	 end
      end
      
      else if (win_size_mod.size == WIN_8K) begin
	 if (xp_symbol_map_intf.long > `CREOLE_HC_MAX_LONG_8K) begin
	    xp_symbol_map_intf.map_error_long  = 1;
	    xp_symbol_map_intf.long            = `CREOLE_HC_MAX_LONG_8K;
	 end
	 if (xp_symbol_map_intf.shrt > `CREOLE_HC_MAX_SHORT_8K) begin
	    xp_symbol_map_intf.map_error_shrt  = 1;
	    xp_symbol_map_intf.shrt            = `CREOLE_HC_MAX_SHORT_8K;
	 end
      end
      
      else if (win_size_mod.size == WIN_16K) begin
	 if (xp_symbol_map_intf.long > `CREOLE_HC_MAX_LONG_16K) begin
	    xp_symbol_map_intf.map_error_long  = 1;
	    xp_symbol_map_intf.long            = `CREOLE_HC_MAX_LONG_16K;
	 end
	 if (xp_symbol_map_intf.shrt > `CREOLE_HC_MAX_SHORT_16K) begin
	    xp_symbol_map_intf.map_error_shrt  = 1;
	    xp_symbol_map_intf.shrt            = `CREOLE_HC_MAX_SHORT_16K;
	 end
      end
      
      else begin
	 if (xp_symbol_map_intf.long > `CREOLE_HC_MAX_LONG_64K) begin
	    
	    xp_symbol_map_intf.map_error_long  = 1;
	    xp_symbol_map_intf.long            = `CREOLE_HC_MAX_LONG_64K;
	    
	 end
	 if (xp_symbol_map_intf.shrt > `CREOLE_HC_MAX_SHORT_64K) begin
	    
	    xp_symbol_map_intf.map_error_shrt  = 1;
	    xp_symbol_map_intf.shrt            = `CREOLE_HC_MAX_SHORT_64K;
	    
	 end
      end
   end

   
   always_comb begin
      
      mtf_ofs_nxt[0] =  mtf_offset_0;
      mtf_ofs_nxt[1] =  mtf_offset_1;
      mtf_ofs_nxt[2] =  mtf_offset_2;
      mtf_ofs_nxt[3] =  mtf_offset_3;
      mtf_num_mod    =  mtf_num;
      ofs_mod        =  mtf_ofs_nxt[mtf_num];
      
      if (prev_mtf_or_ptr && xp9 && mtf) begin
	 mtf_num_mod = mtf_num + 1;
	 ofs_mod     = mtf_ofs_nxt[mtf_num_mod];
      end
      
      if (mtf) begin
	 mtf_offset_out_0      = ofs_mod;
	 case (mtf_num_mod)
	   2'd0: begin
	      mtf_offset_out_1 = mtf_offset_1;
	      mtf_offset_out_2 = mtf_offset_2;
	      mtf_offset_out_3 = mtf_offset_3;
	   end
	   2'd1: begin
	      mtf_offset_out_1 = mtf_offset_0;
	      mtf_offset_out_2 = mtf_offset_2;
	      mtf_offset_out_3 = mtf_offset_3;
	   end
	   2'd2: begin
	      mtf_offset_out_1 = mtf_offset_0;
	      mtf_offset_out_2 = mtf_offset_1;
	      mtf_offset_out_3 = mtf_offset_3;
	   end
	   default: begin
	      mtf_offset_out_1 = mtf_offset_0;
	      mtf_offset_out_2 = mtf_offset_1;
	      mtf_offset_out_3 = mtf_offset_2;
	   end
	 endcase
      end 
      else begin
	 
	 for (int i=3; i > 0; i=i-1) begin
	    mtf_ofs_nxt[i] = mtf_ofs_nxt[i-1];
	 end
	 mtf_ofs_nxt[0]   = ofs;
	 mtf_offset_out_0 = mtf_ofs_nxt[0];
	 mtf_offset_out_1 = mtf_ofs_nxt[1];
	 mtf_offset_out_2 = mtf_ofs_nxt[2];
	 mtf_offset_out_3 = mtf_ofs_nxt[3];
      end 
   end
   
   
   
   
   function [`N_EXTRA_BITS_LEN_WIDTH-1:0] floor_log;
      input [`N_WINDOW_WIDTH-1:0] value;
      begin
	 floor_log = 0;
	 for (int j=0; j < `N_WINDOW_WIDTH; j=j+1) begin
	    if (value[j] == 1'b1)
	      floor_log = j;
	 end
      end
   endfunction 
   
endmodule 









