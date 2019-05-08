/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "axi_reg_slice_defs.vh"

module ace_cr_reg_slice(
   
   crreadys, crvalidm, crrespm,
   
   aclk, aresetn, crvalids, crresps, crreadym
   );

   parameter HNDSHK_MODE = `AXI_RS_FULL;

   localparam PAYLD_WIDTH = 5;

   input aclk;
   input aresetn;

   input                  crvalids;
   output                 crreadys;
   input [4:0]            crresps;

   output                  crvalidm;
   input                   crreadym;
   output [4:0]            crrespm;

    
   wire                   valid_src;
   wire                   ready_src;
   wire [PAYLD_WIDTH-1:0] payload_src;
   wire                   valid_dst;
   wire                   ready_dst;                    
   wire [PAYLD_WIDTH-1:0] payload_dst;

   assign valid_src = crvalids;
   assign payload_src = crresps;

   assign crreadys = ready_src;

   assign crvalidm = valid_dst;
   assign crrespm = payload_dst;

   assign ready_dst = crreadym;

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
   