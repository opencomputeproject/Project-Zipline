/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

module cr_crc16t  
  (
   crc,
   
   clk, rst_n, data_in, data_valid, data_vbytes, enable, init_value,
   init
   );
`include "ccx_std.vh"
   
   localparam N_CRC_WIDTH = 16;   
   localparam N_DATA_WIDTH = 64;
   localparam N_VBYTES_WIDTH = N_DATA_WIDTH/8;
   localparam POLYNOMIAL = 16'hEDD1;

   
   input                              clk;
   input                              rst_n; 
   
   
   input logic [N_DATA_WIDTH-1:0]     data_in;
   input logic                        data_valid;
   input logic [N_VBYTES_WIDTH-1:0]   data_vbytes; 
   
   
   input logic                        enable;
   input logic [N_CRC_WIDTH-1:0]      init_value;
   input logic                        init;
   
   
   output logic [N_CRC_WIDTH-1:0]     crc;

   
   `CCX_STD_DECLARE_CRC(mycrc, POLYNOMIAL, N_CRC_WIDTH,N_DATA_WIDTH );
   
 
   logic [N_CRC_WIDTH-1:0]            crc_r;
   logic [$clog2(N_DATA_WIDTH+1)-1:0] data_vbits;
   
   
   always_comb begin
      if (enable) begin
         crc = {<<{crc_r}};
      end
      else begin
         crc = {N_CRC_WIDTH{1'b0}};
   end
   end
   
   
   always_comb begin
      data_vbits = 0;
      for (int i=0; i<N_VBYTES_WIDTH; i++)
        data_vbits += data_vbytes[i] * 8;
   end 

   always@(posedge clk or negedge rst_n) begin
      if (!rst_n)
        crc_r <= {N_CRC_WIDTH{1'b0}};
      else begin
         if (init) begin
            crc_r <= init_value;
         end
         else if (data_valid) begin
            crc_r <= mycrc({<<8{{<<{data_in}}}}, crc_r, data_vbits);
         end
      end
   end
  
endmodule 











