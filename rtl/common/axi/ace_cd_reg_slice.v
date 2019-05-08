/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "axi_reg_slice_defs.vh"

module ace_cd_reg_slice(
   
   cdreadys, cdvalidm, cddatam, cdlastm,
   
   aclk, aresetn, cdvalids, cddatas, cdlasts, cdreadym
   );

   parameter CD_DATA_WIDTH = 32;
   parameter HNDSHK_MODE = `AXI_RS_FULL;

   localparam PAYLD_WIDTH = CD_DATA_WIDTH + 1;

   input aclk;
   input aresetn;

   input                     cdvalids;
   output                    cdreadys;
   input [CD_DATA_WIDTH-1:0] cddatas;
   input                     cdlasts; 

   output                     cdvalidm;
   input                      cdreadym;
   output [CD_DATA_WIDTH-1:0] cddatam;
   output                     cdlastm; 

    
   wire                   valid_src;
   wire                   ready_src;
   wire [PAYLD_WIDTH-1:0] payload_src;
   wire                   valid_dst;
   wire                   ready_dst;                    
   wire [PAYLD_WIDTH-1:0] payload_dst;

   assign valid_src = cdvalids;
   assign payload_src = {cddatas,
                         cdlasts};

   assign cdreadys = ready_src;

   assign cdvalidm = valid_dst;
   assign {cddatam,
           cdlastm} = payload_dst;

   assign ready_dst = cdreadym;

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
   