/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "axi_reg_slice_defs.vh"

module ace_r_reg_slice(
   
   rvalids, rids, rdatas, rresps, rlasts, rusers, rreadym,
   
   aclk, aresetn, rreadys, rvalidm, ridm, rdatam, rrespm, rlastm,
   ruserm
   );

   parameter DATA_WIDTH = 32;
   parameter ID_WIDTH = 4;
   parameter USER_WIDTH = 1;
   parameter HNDSHK_MODE = `AXI_RS_FULL;

   localparam PAYLD_WIDTH = ID_WIDTH + DATA_WIDTH + USER_WIDTH + 5;

   input aclk;
   input aresetn;

   output                  rvalids;
   input                   rreadys;
   output [ID_WIDTH-1:0]   rids;
   output [DATA_WIDTH-1:0] rdatas;
   output [3:0]            rresps;
   output                  rlasts;
   output [USER_WIDTH-1:0] rusers;
   
   input                   rvalidm;
   output                  rreadym;
   input [ID_WIDTH-1:0]    ridm;
   input [DATA_WIDTH-1:0]  rdatam;
   input [3:0]             rrespm;
   input                   rlastm;
   input [USER_WIDTH-1:0]  ruserm;
   
   wire                    valid_src;
   wire                    ready_src;
   wire [PAYLD_WIDTH-1:0]  payload_src;
   wire                    valid_dst;
   wire                    ready_dst;                    
   wire [PAYLD_WIDTH-1:0]  payload_dst;
   
   assign valid_src = rvalidm;
   assign rreadym = ready_src;
   assign payload_src = {ridm,
                      rdatam,
                      rrespm,
                      rlastm,
                      ruserm};

   assign rvalids = valid_dst;
   assign ready_dst = rreadys;
   assign {rids,
           rdatas,
           rresps,
           rlasts,
           rusers} = payload_dst;

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
   