/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "axi_reg_slice_defs.vh"

module axi_b_reg_slice(
   
   bvalids, bids, bresps, busers, breadym,
   
   aclk, aresetn, breadys, bvalidm, bidm, brespm, buserm
   );

   parameter ID_WIDTH = 4;
   parameter USER_WIDTH = 1;
   parameter HNDSHK_MODE = `AXI_RS_FULL;

   localparam PAYLD_WIDTH = ID_WIDTH + USER_WIDTH + 2;

   input aclk;
   input aresetn;

   output                  bvalids;
   input                 breadys;
   output [ID_WIDTH-1:0]   bids;
   output [1:0]            bresps;
   output [USER_WIDTH-1:0] busers;

   input                  bvalidm;
   output                   breadym;
   input [ID_WIDTH-1:0]   bidm;
   input [1:0]            brespm;
   input [USER_WIDTH-1:0] buserm;


   wire                   valid_src;
   wire                   ready_src;
   wire [PAYLD_WIDTH-1:0] payload_src;
   wire                     valid_dst;
   wire                     ready_dst;                    
   wire [PAYLD_WIDTH-1:0] payload_dst;

   assign valid_src = bvalidm;
   assign breadym = ready_src;
   assign payload_src = {bidm,
                         brespm,
                         buserm};

   assign bvalids = valid_dst;
   assign ready_dst = breadys;
   assign {bids,
           bresps,
           busers} = payload_dst;

   
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
   