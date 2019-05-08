/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


module axi_channel_split_slice(
   
   ready_src, valid_dst, payload_dst,
   
   aclk, aresetn, valid_src, payload_src, ready_dst
   );

   parameter N_OUTPUTS = 2;
   parameter PAYLD_WIDTH = 8;
   parameter HNDSHK_MODE = `AXI_RS_FULL;
   parameter BITS_PER_CHUNK = 8;   

   input aclk;
   input aresetn;

   input                  valid_src;
   input [PAYLD_WIDTH-1:0] payload_src;
   output                 ready_src;
   
   output [N_OUTPUTS-1:0] valid_dst;
   output [PAYLD_WIDTH-1:0] payload_dst;
   input [N_OUTPUTS-1:0]    ready_dst;
   
   logic                    valid_int;
   logic                   ready_int;

   

   axi_channel_reg_slice
     #(
       
       .PAYLD_WIDTH                     (PAYLD_WIDTH),
       .HNDSHK_MODE                     (HNDSHK_MODE),
       .BITS_PER_CHUNK                  (BITS_PER_CHUNK))
   u_reg_slice
     (
      
      .ready_src                        (ready_src),
      .valid_dst                        (valid_int),             
      .payload_dst                      (payload_dst[PAYLD_WIDTH-1:0]),
      
      .aclk                             (aclk),
      .aresetn                          (aresetn),
      .valid_src                        (valid_src),
      .payload_src                      (payload_src[PAYLD_WIDTH-1:0]),
      .ready_dst                        (ready_int));             


   
   axi_hndshk_split
     #(.N_OUTPUTS(N_OUTPUTS))
   u_hndshk_split
     (
      
      .ready_src                        (ready_int),             
      .valid_dst                        (valid_dst[N_OUTPUTS-1:0]),
      
      .aclk                             (aclk),
      .aresetn                          (aresetn),
      .valid_src                        (valid_int),             
      .ready_dst                        (ready_dst[N_OUTPUTS-1:0]));
     

endmodule 

