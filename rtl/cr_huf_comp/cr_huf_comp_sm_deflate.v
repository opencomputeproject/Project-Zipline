/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_huf_comp.vh"
module cr_huf_comp_sm_deflate
  (
   
   df_symbol_map_intf,
   
   len, ofs
   );
   	    
   import cr_huf_compPKG::*;

   input [`N_WINDOW_WIDTH-1:0] 			 len;
   input [`N_WINDOW_WIDTH-1:0] 			 ofs;
   output s_symbol_map_intf                      df_symbol_map_intf;

   logic [`N_WINDOW_WIDTH-1:0] compare_val_lo;
   logic [`N_WINDOW_WIDTH-1:0] compare_val_hi;
   logic [16:0] 	       shrt_pre; 
   logic [15:0] 	       long_pre; 
   
   
   always_comb begin
      df_symbol_map_intf                      = 0;
      shrt_pre                                = 0;
      long_pre                                = 0;
      compare_val_lo                          = 0;
      compare_val_hi                          = 0;
      
      
      
      
     
      if ((len == 16'hffff) && (ofs == 16'hffff)) begin
	 df_symbol_map_intf.shrt              = 256;
	 df_symbol_map_intf.map_error_shrt    = 0;
      end
      
      else if (len == 258) begin
	 df_symbol_map_intf.shrt              = 285;
      end
      
      else if (len >= 3   && len <=  10) begin
	 shrt_pre                             = 256 + len - 2;
	 df_symbol_map_intf.shrt              = shrt_pre[9:0];
      end
      
      else begin
	 for (int i=1; i < 6; i=i+1) begin
	    compare_val_lo = ((2**(i+2))+3);
	    compare_val_hi = ((2**(i+3))+2);
	    if (len >=  compare_val_lo && len <= compare_val_hi) begin
	       shrt_pre                             = 256 + (len - ((2**(i+2))+3))/(2**i) + (((i-1)*4)+9); 
	       df_symbol_map_intf.shrt              = shrt_pre[9:0];
	       df_symbol_map_intf.len_xtr_bits_len  = i;
	       df_symbol_map_intf.len_xtr_bits      =       (len - ((2**(i+2))+3))%(2**i);                 
	    end
	 end
      end 
       
      if ((len > `CREOLE_HC_MAX_LEN_DF) && (len != 16'hffff)) begin
	 df_symbol_map_intf.map_error_shrt    = 1;
	 df_symbol_map_intf.shrt              = 285;
      end
      
      
      
      
      
      if (ofs == 16'hffff) begin
	 df_symbol_map_intf.map_error_long    = 0;
      end
      
      else if (ofs >= 1 && ofs <= 4) begin
	 long_pre                             = ofs -1;
	 df_symbol_map_intf.long              = long_pre[7:0];
      end
      
      else begin
	 for (int i=1; i<14; i=i+1) begin
	    compare_val_lo = (2**(i+1))+1;
	    compare_val_hi = (2**(i+2));
	    if (ofs >= compare_val_lo && ofs <= compare_val_hi) begin
	       long_pre                             = ((i*2)+2) + ((ofs - (((2**i)*2)+1))/(2**i)); 
	       df_symbol_map_intf.long              = long_pre[7:0];
	       df_symbol_map_intf.ofs_xtr_bits_len  = i;
	       df_symbol_map_intf.ofs_xtr_bits      =             ((ofs - (((2**i)*2)+1))%(2**i)); 
	    end
	 end
      end 
      
      if ((ofs > `CREOLE_HC_MAX_DST_DF) && (ofs != 16'hffff))  begin
	 df_symbol_map_intf.long              = 29;
	 df_symbol_map_intf.ofs_xtr_bits_len  = 0;
	 df_symbol_map_intf.ofs_xtr_bits      = 0;
	 df_symbol_map_intf.map_error_long    = 1;
      end
      
   end
   

   
endmodule








