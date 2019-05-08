/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "axi_reg_slice_defs.vh"

module ace_ac_reg_slice(
   
   acreadys, acvalidm, acaddrm, acprotm, acsnoopm,
   
   aclk, aresetn, acvalids, acaddrs, acprots, acsnoops, acreadym
   );

   parameter AC_ADDR_WIDTH = 32;
   parameter HNDSHK_MODE = `AXI_RS_FULL;

   localparam PAYLD_WIDTH = AC_ADDR_WIDTH + 7;

   input aclk;
   input aresetn;

   output                    acvalids;
   input                     acreadys;
   output[AC_ADDR_WIDTH-1:0] acaddrs;
   output[2:0]               acprots;
   output[3:0]               acsnoops; 

   input                      acvalidm;
   output                     acreadym;
   input  [AC_ADDR_WIDTH-1:0] acaddrm;
   input  [2:0]               acprotm;
   input  [3:0]               acsnoopm; 

    
   wire                   valid_src;
   wire                   ready_src;
   wire [PAYLD_WIDTH-1:0] payload_src;
   wire                   valid_dst;
   wire                   ready_dst;                    
   wire [PAYLD_WIDTH-1:0] payload_dst;

   assign valid_src = acvalidm;
   assign payload_src = {acaddrm,
                         acprotm,
                         acsnoopm};

   assign acreadym = ready_src;

   assign acvalids = valid_dst;
   assign {
           acaddrs,
           acprots,
           acsnoops} = payload_dst;

   assign ready_dst = acreadys;

   axi_channel_reg_slice #(.PAYLD_WIDTH(PAYLD_WIDTH), .HNDSHK_MODE(HNDSHK_MODE)) reg_slice
     (
      
      .ready_src                        (ready_src),
      .valid_dst                        (valid_dst),
      .payload_dst                      (payload_dst[PAYLD_WIDTH-1:0]),
      
      .aclk                             (aclk),
      .aresetn                          (aresetn),
      .valid_src                        (valid_src),
      .payload_src                      (payload_src[PAYLD_WIDTH-1:0]),
      .ready_dst                        (ready_dst));
   
endmodule
   