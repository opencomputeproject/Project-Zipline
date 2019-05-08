/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
















`include "cr_huf_comp.vh"

module cr_huf_comp_sa_enc_func_pipe
   (
   
   data_out, data_out_size, data_out_eot, data_out_eob, data_out_vld,
   data_out_pend,
   
   shrt_sel, long_sel, comp_mode, lz77_win_size, lut_sa_shrt_data,
   lut_sa_long_data, symbol_holding_fifo_intf, vld, clk, rst_n
   );

   import cr_huf_compPKG::*;
   
   
   input e_min_enc                                              shrt_sel;
   input e_min_enc                                              long_sel;
   input [3:0]                                                  comp_mode;
   input [3:0]                                                  lz77_win_size;
   input s_lut_shrt_rd_data_intf                                lut_sa_shrt_data;
   input s_lut_long_rd_data_intf                                lut_sa_long_data;
   input s_symbol_holding_fifo_intf                             symbol_holding_fifo_intf; 
   input                                                        vld;
   input                                                        clk;
   input 							rst_n;
   
   
   
   
   output logic [`CREOLE_HC_MAX_ENCODE_TOT_WIDTH-1:0] 		data_out;
   output logic [$clog2(`CREOLE_HC_MAX_ENCODE_TOT_WIDTH)-1:0] 	data_out_size;
   output logic                                                 data_out_eot;
   output logic                                                 data_out_eob;
   output logic 						data_out_vld;
   output logic                                                 data_out_pend;
   
   


   typedef struct packed {
      cmd_lz77_win_size_e size;
   } win_size_t;
   
   typedef struct packed {
      cmd_comp_mode_e mode;
   } comp_mode_t;

   comp_mode_t comp_mode_mod;
   win_size_t  win_size_mod;

   
   
   logic [`N_MAX_ENCODE_WIDTH-1:0]            shrt_lo_max;
   logic [$clog2(`N_MAX_ENCODE_WIDTH)-1:0]    shrt_lo_size;
   logic [`N_MAX_ENCODE_WIDTH-1:0]            shrt_hi_max;
   logic [$clog2(`N_MAX_ENCODE_WIDTH)-1:0]    shrt_hi_size;
   logic [`N_MAX_ENCODE_WIDTH-1:0]            shrt_hi1_max;
   logic [$clog2(`N_MAX_ENCODE_WIDTH)-1:0]    shrt_hi1_size;
   logic [$clog2(`N_MAX_ENCODE_WIDTH)-1:0]    shrt_hi2_size;
   logic [`N_MAX_ENCODE_WIDTH-1:0] 	      long_lo_max;
   logic [$clog2(`N_MAX_ENCODE_WIDTH)-1:0]    long_lo_size;
   logic [$clog2(`N_MAX_ENCODE_WIDTH)-1:0]    long_hi_size;
   logic [`CREOLE_HC_MAX_SHORT_PER_XFER-1:0]  shrt_vld;
   logic 				      long_vld;
   
   
   logic [`N_MAX_ENCODE_WIDTH-1:0] 	      sim_shrt_arr [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [`N_MAX_ENCODE_WIDTH-1:0] 	      sim_long;
   logic [$clog2(`N_MAX_ENCODE_WIDTH)-1:0]    sim_shrt_size_arr [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [$clog2(`N_MAX_ENCODE_WIDTH)-1:0]    sim_long_size;

   logic [`N_MAX_ENCODE_WIDTH-1:0] 	      ret_shrt_arr [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [`N_MAX_ENCODE_WIDTH-1:0] 	      ret_long;
   logic [$clog2(`N_MAX_ENCODE_WIDTH)-1:0]    ret_shrt_size_arr [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [$clog2(`N_MAX_ENCODE_WIDTH)-1:0]    ret_long_size;

   logic [`N_MAX_ENCODE_WIDTH-1:0] 	      pre_shrt_arr [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [`N_MAX_ENCODE_WIDTH-1:0] 	      pre_long;
   logic [$clog2(`N_MAX_ENCODE_WIDTH)-1:0]    pre_shrt_size_arr [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [$clog2(`N_MAX_ENCODE_WIDTH)-1:0]    pre_long_size;

   logic 				      deflate;
 
   
   logic [$clog2(`N_MAX_ENCODE_WIDTH)-1:0] 			long_size_arr [`CREOLE_HC_MAX_SHORT_PER_XFER]; 
   logic [$clog2(`N_MAX_ENCODE_WIDTH)-1:0] 			long_size_arr_r1 [`CREOLE_HC_MAX_SHORT_PER_XFER]; 
   logic [`N_EXTRA_BITS_LEN_WIDTH-1:0] 				extr_len_size_arr [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [`N_EXTRA_BITS_LEN_WIDTH-1:0] 				extr_len_size_arr_r1 [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [`N_EXTRA_BITS_LEN_WIDTH-1:0] 				extr_ofs_size_arr [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [`N_EXTRA_BITS_LEN_WIDTH-1:0] 				extr_ofs_size_arr_r1 [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [$clog2(`CREOLE_HC_MAX_ENCODE_TOT_WIDTH)-1:0] 		shrt_size_offset_arr [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [$clog2(`CREOLE_HC_MAX_ENCODE_TOT_WIDTH)-1:0] 		shrt_size_offset_arr_r1 [`CREOLE_HC_MAX_SHORT_PER_XFER];  
   logic [$clog2(`CREOLE_HC_MAX_ENCODE_TOT_WIDTH)-1:0] 		long_size_offset_arr [`CREOLE_HC_MAX_SHORT_PER_XFER];     
   logic [$clog2(`CREOLE_HC_MAX_ENCODE_TOT_WIDTH)-1:0] 		long_size_offset_arr_r1 [`CREOLE_HC_MAX_SHORT_PER_XFER];      
   logic [$clog2(`CREOLE_HC_MAX_ENCODE_TOT_WIDTH)-1:0] 		extr_len_size_offset_arr [`CREOLE_HC_MAX_SHORT_PER_XFER]; 
   logic [$clog2(`CREOLE_HC_MAX_ENCODE_TOT_WIDTH)-1:0] 		extr_len_size_offset_arr_r1 [`CREOLE_HC_MAX_SHORT_PER_XFER];    
   logic [$clog2(`CREOLE_HC_MAX_ENCODE_TOT_WIDTH)-1:0] 		extr_ofs_size_offset_arr [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [$clog2(`CREOLE_HC_MAX_ENCODE_TOT_WIDTH)-1:0] 		extr_ofs_size_offset_arr_r1 [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic 							data_out_eot_r1;
   logic 							data_out_eob_r1;
   logic 							data_out_vld_r1;
   logic 							data_out_eot_r2;
   logic 							data_out_eob_r2;
   logic 							data_out_vld_r2;

   logic 							data_out_pend_r1;
   logic 							data_out_pend_r2;
   
   
   
   logic [`N_MAX_ENCODE_WIDTH-1:0] 				temp_shrt_arr [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [`N_MAX_ENCODE_WIDTH-1:0] 				temp_long;
   
   s_enc_func_in_intf                                           enc_func_in_intf;
   s_enc_func_in_intf                                           enc_func_in_intf_r1; 
   
   logic [`CREOLE_HC_MAX_ENCODE_TOT_WIDTH-1:0] 			data_out_shrt [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [`CREOLE_HC_MAX_ENCODE_TOT_WIDTH-1:0] 			data_out_long [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [`CREOLE_HC_MAX_ENCODE_TOT_WIDTH-1:0] 			data_out_len [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [`CREOLE_HC_MAX_ENCODE_TOT_WIDTH-1:0] 			data_out_ofs [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [`CREOLE_HC_MAX_ENCODE_TOT_WIDTH-1:0] 			data_out_shrt_r1 [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [`CREOLE_HC_MAX_ENCODE_TOT_WIDTH-1:0] 			data_out_long_r1 [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [`CREOLE_HC_MAX_ENCODE_TOT_WIDTH-1:0] 			data_out_len_r1 [`CREOLE_HC_MAX_SHORT_PER_XFER];
   logic [`CREOLE_HC_MAX_ENCODE_TOT_WIDTH-1:0] 			data_out_ofs_r1 [`CREOLE_HC_MAX_SHORT_PER_XFER];
   
   logic [$clog2(`CREOLE_HC_MAX_ENCODE_TOT_WIDTH)-1:0] 		data_out_size_p0, data_out_size_r1, data_out_size_r2;
   
   always_comb begin
     
      
      for (int i=0; i<`CREOLE_HC_MAX_SHORT_PER_XFER; i++) begin
	 temp_shrt_arr[i]                    = 0;
	 enc_func_in_intf.shrt_size_arr[i]   = 0;
	 enc_func_in_intf.shrt_arr[i]        = 0;
      end
      enc_func_in_intf.long          = 0;
      enc_func_in_intf.extr_len      = 0;
      enc_func_in_intf.extr_ofs      = 0;
      comp_mode_mod                  = {comp_mode};
      win_size_mod                   = {lz77_win_size};
      enc_func_in_intf.extr_len_size = symbol_holding_fifo_intf.mux_symbol_map_intf.len_xtr_bits_len;
      enc_func_in_intf.extr_ofs_size = symbol_holding_fifo_intf.mux_symbol_map_intf.ofs_xtr_bits_len;
      enc_func_in_intf.ptr_idx       = symbol_holding_fifo_intf.ptr_idx;
      enc_func_in_intf.ptr_en        = symbol_holding_fifo_intf.ptr_en;
      enc_func_in_intf.extr_len      = symbol_holding_fifo_intf.mux_symbol_map_intf.len_xtr_bits;
      enc_func_in_intf.extr_ofs      = symbol_holding_fifo_intf.mux_symbol_map_intf.ofs_xtr_bits;

       if ((comp_mode_mod.mode == GZIP) || (comp_mode_mod.mode == ZLIB))
	deflate = 1;
      else
	deflate = 0;
      
      
      shrt_hi_max   = 1024;
      shrt_hi1_max  = 1024;
      shrt_hi1_size = 8;
      shrt_hi2_size = 8;
      
      if (deflate) begin
	 shrt_lo_max   = 143;
	 shrt_lo_size  = 8;
	 shrt_hi_max   = 255;
	 shrt_hi_size  = 9;
	 shrt_hi1_max  = 279;
	 shrt_hi1_size = 7;
	 shrt_hi2_size = 8;	 
	 long_lo_max   = 255;
	 long_lo_size  = 5;
	 long_hi_size  = 5;
      end
      else if (comp_mode_mod.mode == XP9) begin
	 shrt_lo_max  = 319;
	 shrt_lo_size = 9;
	 shrt_hi_size = 10;	 
	 long_lo_max  = 255;
	 long_lo_size = 8;
	 long_hi_size = 8;
      end
      else begin
	 if (win_size_mod.size == WIN_64K) begin
	    shrt_lo_max  = 447;
	    shrt_lo_size = 9;
	    shrt_hi_size = 10;
	    long_lo_max  = 7;
	    long_lo_size = 7;
	    long_hi_size = 8;
	 end
	 else if (win_size_mod.size == WIN_16K) begin
	    shrt_lo_max  = 479;
	    shrt_lo_size = 9;
	    shrt_hi_size = 10;
	    long_lo_max  = 9;
	    long_lo_size = 7;
	    long_hi_size = 8;
	 end
	 else if (win_size_mod.size == WIN_8K) begin
	    shrt_lo_max  = 495;
	    shrt_lo_size = 9;
	    shrt_hi_size = 10;
	    long_lo_max  = 10;
	    long_lo_size = 7;
	    long_hi_size = 8;
	 end
	 else begin
	    shrt_lo_max  = 511;
	    shrt_lo_size = 9;
	    shrt_hi_size = 9;
	    long_lo_max  = 11;
	    long_lo_size = 7;
	    long_hi_size = 8;
	 end 
      end
      case (symbol_holding_fifo_intf.framing)
	4'd0:    shrt_vld = 4'b0000;
	4'd1:    shrt_vld = 4'b0001;
	4'd2:    shrt_vld = 4'b0011;
	4'd3:    shrt_vld = 4'b0111;
	4'd4:    shrt_vld = 4'b1111;
	4'd15: begin
	   if (deflate)
	         shrt_vld = 4'b0001;
	   else
	         shrt_vld = 4'b0000;
	end
	default: shrt_vld = 4'b0000;
      endcase 
      long_vld            = symbol_holding_fifo_intf.mux_symbol_map_intf.long_vld;
      
      sim_shrt_arr[0]      = {{17{1'd0}}, symbol_holding_fifo_intf.shrt_0};
      sim_shrt_arr[1]      = {{17{1'd0}}, symbol_holding_fifo_intf.shrt_1};
      sim_shrt_arr[2]      = {{17{1'd0}}, symbol_holding_fifo_intf.shrt_2};
      sim_shrt_arr[3]      = {{17{1'd0}}, symbol_holding_fifo_intf.shrt_3};
      if (symbol_holding_fifo_intf.mux_symbol_map_intf.long > long_lo_max[7:0])
	sim_long           = {{19{1'd0}}, symbol_holding_fifo_intf.mux_symbol_map_intf.long} + long_lo_max + 1; 
      else
	sim_long           = {{19{1'd0}}, symbol_holding_fifo_intf.mux_symbol_map_intf.long};
	
      ret_shrt_arr[0]      = lut_sa_shrt_data.rd_data0.ret_code;
      ret_shrt_arr[1]      = lut_sa_shrt_data.rd_data1.ret_code;
      ret_shrt_arr[2]      = lut_sa_shrt_data.rd_data2.ret_code;
      ret_shrt_arr[3]      = lut_sa_shrt_data.rd_data3.ret_code;      
      ret_shrt_size_arr[0] = lut_sa_shrt_data.rd_data0.ret_code_size;
      ret_shrt_size_arr[1] = lut_sa_shrt_data.rd_data1.ret_code_size;
      ret_shrt_size_arr[2] = lut_sa_shrt_data.rd_data2.ret_code_size;
      ret_shrt_size_arr[3] = lut_sa_shrt_data.rd_data3.ret_code_size;
      ret_long             = lut_sa_long_data.rd_data0.ret_code;
      ret_long_size        = lut_sa_long_data.rd_data0.ret_code_size;        
      
      pre_shrt_arr[0]      = lut_sa_shrt_data.rd_data0.pre_code;
      pre_shrt_arr[1]      = lut_sa_shrt_data.rd_data1.pre_code;
      pre_shrt_arr[2]      = lut_sa_shrt_data.rd_data2.pre_code;
      pre_shrt_arr[3]      = lut_sa_shrt_data.rd_data3.pre_code;      
      pre_shrt_size_arr[0] = lut_sa_shrt_data.rd_data0.pre_code_size;
      pre_shrt_size_arr[1] = lut_sa_shrt_data.rd_data1.pre_code_size;
      pre_shrt_size_arr[2] = lut_sa_shrt_data.rd_data2.pre_code_size;
      pre_shrt_size_arr[3] = lut_sa_shrt_data.rd_data3.pre_code_size;
      pre_long             = lut_sa_long_data.rd_data0.pre_code;
      pre_long_size        = lut_sa_long_data.rd_data0.pre_code_size;        
      
      
      for (int i=0; i<`CREOLE_HC_MAX_SHORT_PER_XFER; i++) begin
	 sim_shrt_size_arr[i] = 0;
      end
      sim_long_size           = 0;
      
      for (int i=0; i<`CREOLE_HC_MAX_SHORT_PER_XFER; i++) begin
	 if (sim_shrt_arr[i] <= shrt_lo_max)
	   sim_shrt_size_arr[i] = shrt_lo_size;
	 else if (sim_shrt_arr[i] <= shrt_hi_max)
	   sim_shrt_size_arr[i] = shrt_hi_size;
	 else if (sim_shrt_arr[i] <= shrt_hi1_max)
	   sim_shrt_size_arr[i] = shrt_hi1_size;
	 else
	   sim_shrt_size_arr[i] = shrt_hi2_size;
      end
      if (sim_long <= long_lo_max)
	sim_long_size   = long_lo_size;
      else
	sim_long_size   = long_hi_size;
      
      case (shrt_sel)
	SIM:
	  begin
	     if (deflate) begin
		for (int i=0; i<`CREOLE_HC_MAX_SHORT_PER_XFER; i++) begin
		   if (sim_shrt_arr[i] > shrt_hi1_max)
		     temp_shrt_arr[i]                = sim_shrt_arr[i] - 88;  
		   else if (sim_shrt_arr[i] > shrt_hi_max)
		     temp_shrt_arr[i]                = sim_shrt_arr[i] - 256; 
		   else if (sim_shrt_arr[i] > shrt_lo_max)
		     temp_shrt_arr[i]                = sim_shrt_arr[i] + 256; 
		   else
		     temp_shrt_arr[i]                = sim_shrt_arr[i] + 48;  
		   enc_func_in_intf.shrt_size_arr[i] = sim_shrt_size_arr[i];
		end
	     end
	     else begin
		for (int i=0; i<`CREOLE_HC_MAX_SHORT_PER_XFER; i++) begin
		   if (sim_shrt_arr[i] > shrt_lo_max)
		     temp_shrt_arr[i]                = sim_shrt_arr[i] + shrt_lo_max + 1; 
		   else
		     temp_shrt_arr[i]                = sim_shrt_arr[i];
		   enc_func_in_intf.shrt_size_arr[i] = sim_shrt_size_arr[i];
		end
	     end 
	  end
	RET:
	  for (int i=0; i<`CREOLE_HC_MAX_SHORT_PER_XFER; i++) begin
	     temp_shrt_arr[i]                  = ret_shrt_arr[i];
	     enc_func_in_intf.shrt_size_arr[i] = ret_shrt_size_arr[i];
	  end
	
	default:
	  for (int i=0; i<`CREOLE_HC_MAX_SHORT_PER_XFER; i++) begin
	     temp_shrt_arr[i]                  = pre_shrt_arr[i];
	     enc_func_in_intf.shrt_size_arr[i] = pre_shrt_size_arr[i];
	  end
      endcase 
      
      case (long_sel)
	SIM:
	  begin
	     temp_long                         = sim_long;
       	     enc_func_in_intf.long_size        = sim_long_size;			       
	  end
	RET:
	  begin
	     temp_long                         = ret_long;
       	     enc_func_in_intf.long_size        = ret_long_size;			       
	  end
	
	default:
	  begin
	     temp_long                         = pre_long;
       	     enc_func_in_intf.long_size        = pre_long_size;			       
	  end
      endcase
      

      
      for (int i=0; i<`CREOLE_HC_MAX_SHORT_PER_XFER; i++) begin
	 for (int j=0; j<`N_MAX_ENCODE_WIDTH; j++)
	   if (j < enc_func_in_intf.shrt_size_arr[i])
	     enc_func_in_intf.shrt_arr[i][j] = temp_shrt_arr[i][enc_func_in_intf.shrt_size_arr[i]-1-j]; 
      end
      
      for (int j=0; j<`N_MAX_ENCODE_WIDTH; j++)
	if (j < enc_func_in_intf.long_size)
	  enc_func_in_intf.long[j] = temp_long[enc_func_in_intf.long_size-1-j];  
       	
      
      for (int i=0; i<`CREOLE_HC_MAX_SHORT_PER_XFER; i++) begin
	 if (shrt_vld[i] == 0)
	   enc_func_in_intf.shrt_size_arr[i]   = 0;
      end
      if (long_vld == 0)
	enc_func_in_intf.long_size             = 0;

      
      for (int i=0; i < `CREOLE_HC_MAX_SHORT_PER_XFER; i=i+1) begin
	 data_out_shrt[i]            = 0;
	 data_out_long[i]            = 0;
	 data_out_len[i]             = 0;
	 data_out_ofs[i]             = 0;	 
	 long_size_arr[i]            = 0;
	 extr_len_size_arr[i]        = 0;
	 extr_ofs_size_arr[i]        = 0;
	 shrt_size_offset_arr[i]     = 0;
	 long_size_offset_arr[i]     = 0;
	 extr_len_size_offset_arr[i] = 0;
	 extr_ofs_size_offset_arr[i] = 0;
      end 
      
      
      for (int i=0; i < `CREOLE_HC_MAX_SHORT_PER_XFER; i=i+1) begin
	 if (enc_func_in_intf.ptr_en && (enc_func_in_intf.ptr_idx == i)) begin
	    long_size_arr[i]     = enc_func_in_intf.long_size;
	    extr_len_size_arr[i] = enc_func_in_intf.extr_len_size;
	    extr_ofs_size_arr[i] = enc_func_in_intf.extr_ofs_size;
	 end
      end
      
      
      
      
      if (deflate) begin
	 for (int i=0; i < `CREOLE_HC_MAX_SHORT_PER_XFER; i=i+1) begin
	    if (i != 0)
	      shrt_size_offset_arr[i]   = extr_ofs_size_offset_arr[i-1] + extr_ofs_size_arr[i-1];
	    extr_len_size_offset_arr[i] = shrt_size_offset_arr[i]       + enc_func_in_intf.shrt_size_arr[i];
	    long_size_offset_arr[i]     = extr_len_size_offset_arr[i]   + extr_len_size_arr[i];
	    extr_ofs_size_offset_arr[i] = long_size_offset_arr[i]       + long_size_arr[i]; 
	 end
      end
      
      else begin
	 for (int i=0; i < `CREOLE_HC_MAX_SHORT_PER_XFER; i=i+1) begin
	    if (i != 0)
	      shrt_size_offset_arr[i]   = extr_ofs_size_offset_arr[i-1] + extr_ofs_size_arr[i-1];
	    long_size_offset_arr[i]     = shrt_size_offset_arr[i]       + enc_func_in_intf.shrt_size_arr[i];
	    extr_len_size_offset_arr[i] = long_size_offset_arr[i]       + long_size_arr[i];
	    extr_ofs_size_offset_arr[i] = extr_len_size_offset_arr[i]   + extr_len_size_arr[i];
	 end
      end
      
      data_out_size_p0               = extr_ofs_size_offset_arr[`CREOLE_HC_MAX_SHORT_PER_XFER-1] + 
				       extr_ofs_size_arr[`CREOLE_HC_MAX_SHORT_PER_XFER-1];
      
      
      
      
      

      
      
       for (int i=0; i < `CREOLE_HC_MAX_SHORT_PER_XFER; i=i+1) begin
	 if (enc_func_in_intf_r1.shrt_size_arr[i] != 0)
	   data_out_shrt[i] = enc_func_in_intf_r1.shrt_arr[i] << shrt_size_offset_arr_r1[i]; 
	  
	 if (long_size_arr_r1[i] != 0)
	   data_out_long[i] = enc_func_in_intf_r1.long        << long_size_offset_arr_r1[i]; 
	  
	 if (extr_len_size_arr_r1[i] != 0)
	   data_out_len[i]  = enc_func_in_intf_r1.extr_len    << extr_len_size_offset_arr_r1[i]; 
	  
	 if (extr_ofs_size_arr_r1[i] != 0)
	   data_out_ofs[i]  = enc_func_in_intf_r1.extr_ofs    << extr_ofs_size_offset_arr_r1[i];  
       end
      
       
   end 

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
	 for (int i=0; i < `CREOLE_HC_MAX_SHORT_PER_XFER; i=i+1) begin
	    long_size_arr_r1[i]            <= 0;
	    extr_len_size_arr_r1[i]        <= 0;
	    extr_ofs_size_arr_r1[i]        <= 0;
	    long_size_offset_arr_r1[i]     <= 0;
	    extr_len_size_offset_arr_r1[i] <= 0;
	    extr_ofs_size_offset_arr_r1[i] <= 0;
	    shrt_size_offset_arr_r1[i]     <= 0;
	    data_out_len_r1[i]             <= 0;
	    data_out_long_r1[i]            <= 0;
	    data_out_ofs_r1[i]             <= 0;
	    data_out_shrt_r1[i]            <= 0;
	 end
	 
	 
	 
	 data_out <= 0;
	 data_out_eob <= 0;
	 data_out_eob_r1 <= 0;
	 data_out_eob_r2 <= 0;
	 data_out_eot <= 0;
	 data_out_eot_r1 <= 0;
	 data_out_eot_r2 <= 0;
	 data_out_pend <= 0;
	 data_out_pend_r1 <= 0;
	 data_out_pend_r2 <= 0;
	 data_out_size <= 0;
	 data_out_size_r1 <= 0;
	 data_out_size_r2 <= 0;
	 data_out_vld <= 0;
	 data_out_vld_r1 <= 0;
	 data_out_vld_r2 <= 0;
	 enc_func_in_intf_r1 <= 0;
	 
      end
      else begin
	 
	 data_out                   <= data_out_shrt_r1[0] | data_out_shrt_r1[1] | data_out_shrt_r1[2] | data_out_shrt_r1[3] |
	                               data_out_long_r1[0] | data_out_long_r1[1] | data_out_long_r1[2] | data_out_long_r1[3] |
	                               data_out_len_r1[0]  | data_out_len_r1[1]  | data_out_len_r1[2]  | data_out_len_r1[3]  |
	                               data_out_ofs_r1[0]  | data_out_ofs_r1[1]  | data_out_ofs_r1[2]  | data_out_ofs_r1[3]  ;

	 
	 data_out_shrt_r1           <= data_out_shrt;
	 data_out_long_r1           <= data_out_long;
	 data_out_len_r1            <= data_out_len;
	 data_out_ofs_r1            <= data_out_ofs;
	 
	 data_out_size_r1           <= data_out_size_p0;
	 data_out_size_r2           <= data_out_size_r1;
	 data_out_size              <= data_out_size_r2;
	 
	 data_out_vld_r1            <= vld;
	 data_out_vld_r2            <= data_out_vld_r1;
	 data_out_vld               <= data_out_vld_r2;

	 data_out_pend_r1           <= vld & !symbol_holding_fifo_intf.eot;
	 data_out_pend_r2           <= data_out_pend_r1;
	 data_out_pend              <= (vld & !symbol_holding_fifo_intf.eot) | data_out_pend_r1 | data_out_pend_r2;
	 
	 
	 
	 data_out_eob_r1            <= symbol_holding_fifo_intf.eob;
	 data_out_eob_r2            <= data_out_eob_r1;
	 data_out_eob               <= data_out_eob_r2;
	 
	 data_out_eot_r1            <= symbol_holding_fifo_intf.eot;
	 data_out_eot_r2            <= data_out_eot_r1;
	 data_out_eot               <= data_out_eot_r2;
	 
	 enc_func_in_intf_r1         <= enc_func_in_intf;
	 long_size_arr_r1            <= long_size_arr;	 
	 extr_len_size_arr_r1        <= extr_len_size_arr;	 
	 extr_ofs_size_arr_r1        <= extr_ofs_size_arr;	 
	 long_size_offset_arr_r1     <= long_size_offset_arr;	 
	 extr_len_size_offset_arr_r1 <= extr_len_size_offset_arr;	 
	 extr_ofs_size_offset_arr_r1 <= extr_ofs_size_offset_arr;
	 shrt_size_offset_arr_r1     <= shrt_size_offset_arr;
	 
	 
	 
      end 
   end
   
  
   
endmodule 







