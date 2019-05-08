/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



















module nx_bit_pack #(IN_W   = 256, OUT_W  = 64, ACC_W  = 64)
   (
   
   data_out_cnt, data_out, accum_out, accum_out_size,
   
   data_in, data_in_size, accum_in, accum_in_size, data_out_index
   );
   
   localparam IN_SZ_W      = $clog2(IN_W);
   localparam OUT_SZ_W     = $clog2(OUT_W);
   localparam ACC_SZ_W     = $clog2(ACC_W);   
   localparam OUT_ARR_SZ   = (IN_W+ACC_W)/OUT_W;
   localparam OUT_CNT_SZ_W = $clog2(OUT_ARR_SZ);
   
   input [IN_W-1:0]                 data_in;
   input [IN_SZ_W:0] 		    data_in_size;
   input [ACC_W-1:0] 		    accum_in;
   input [ACC_SZ_W:0] 	            accum_in_size;
   input [OUT_CNT_SZ_W-1:0] 	    data_out_index;
   
   
   output logic [OUT_CNT_SZ_W:0]    data_out_cnt;
   output logic [OUT_W-1:0] 	    data_out;  
   output logic [OUT_W-1:0] 	    accum_out;
   output logic [OUT_SZ_W:0] 	    accum_out_size;
   
   logic [IN_SZ_W+1:0] 		    size_tot;
   logic [IN_W+ACC_W-1:0] 	    accum_tot; 
   logic [OUT_W-1:0] 		    data_out_arr [OUT_ARR_SZ];  

   always_comb begin
      for (int i=0; i<OUT_ARR_SZ; i++)
	data_out_arr[i] = 0;
      data_out          = 0;
      size_tot          = 0;
      accum_tot         = 0;
      data_out_cnt      = 0;
      accum_out_size    = 0;
      accum_out         = 0;
      
      size_tot       = accum_in_size + data_in_size;
      accum_tot      = (accum_in&((2**accum_in_size)-1)) | ((data_in&((2**data_in_size)-1)) << accum_in_size);	 
      data_out_cnt   = size_tot/OUT_W;                    
      accum_out_size = size_tot - data_out_cnt*OUT_W;     
      accum_out      = accum_tot >> (data_out_cnt*OUT_W); 
      for (int i=0; i < OUT_ARR_SZ; i++) begin
	 data_out_arr[i] = accum_tot >> (i*OUT_W);        
      end
      
      if (data_out_cnt == 0)
	 data_out_arr[0] = accum_out;
      data_out  = data_out_arr[data_out_index];           
      
   end
endmodule