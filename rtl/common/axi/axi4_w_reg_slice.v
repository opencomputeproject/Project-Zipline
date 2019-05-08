/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "axi_reg_slice_defs.vh"

module axi4_w_reg_slice(
   
   wreadys, wvalidm, wdatam, wstrbm, wlastm, wuserm,
   
   aclk, aresetn, wvalids, wdatas, wstrbs, wlasts, wusers, wreadym
   );

   parameter DATA_WIDTH = 32;
   parameter USER_WIDTH = 1;
   parameter HNDSHK_MODE = `AXI_RS_FULL;

   parameter STRB_WIDTH = DATA_WIDTH/8;
   localparam PAYLD_WIDTH = DATA_WIDTH + USER_WIDTH + STRB_WIDTH + 1;

   input aclk;
   input aresetn;

   input                  wvalids;
   output                 wreadys;
   input [DATA_WIDTH-1:0] wdatas;
   input [STRB_WIDTH-1:0] wstrbs;
   input                  wlasts;
   input [USER_WIDTH-1:0] wusers;

   output                  wvalidm;
   input                   wreadym;
   output [DATA_WIDTH-1:0] wdatam;
   output [STRB_WIDTH-1:0] wstrbm;
   output                  wlastm;
   output [USER_WIDTH-1:0] wuserm;


   wire                   valid_src;
   wire                   ready_src;
   wire [PAYLD_WIDTH-1:0] payload_src;
   wire                   valid_dst;
   wire                   ready_dst;                    
   wire [PAYLD_WIDTH-1:0] payload_dst;

   assign valid_src = wvalids;
   assign payload_src = {wdatas,
                         wstrbs,
                         wlasts,
                         wusers};
   assign wreadys = ready_src;

   assign wvalidm = valid_dst;
   assign {wdatam,
           wstrbm,
           wlastm,
           wuserm} = payload_dst;
   assign ready_dst = wreadym;

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
   