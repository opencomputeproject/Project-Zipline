/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
module cr_xp10_decomp_fe_crc (
   
   crc_out,
   
   clk, rst_n, sof, crc_in, data_in, data_sz
   );

   import crPKG::*;
   import cr_xp10_decompPKG::*;
   import cr_xp10_decomp_regsPKG::*;

   input clk;
   input rst_n;
   input sof;
   input [31:0] crc_in;
   input [63:0] data_in;
   input [6:0]  data_sz;
   
   output logic [31:0] crc_out;

   logic [31:0]        tmp_crc_in;
   
  `CCX_STD_DECLARE_CRC(crc32, 32'h82f63b78, 32, 64) 
   
   always_comb
     begin
        if (sof) 
          tmp_crc_in = 32'hffff_ffff;
        else
          tmp_crc_in = crc_in;
        
        crc_out = crc32(data_in, tmp_crc_in, data_sz);
        
     end 

   
endmodule 

