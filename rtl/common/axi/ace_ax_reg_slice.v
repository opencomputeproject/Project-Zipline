/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "axi_reg_slice_defs.vh"

module ace_ax_reg_slice(
   
   axreadys, axvalidm, axidm, axaddrm, axlenm, axsizem, axburstm,
   axlockm, axcachem, axprotm, axregionm, axqosm, axuserm, axbarm,
   axdomainm, axsnoopm, awuniquem,
   
   aclk, aresetn, axvalids, axids, axaddrs, axlens, axsizes, axbursts,
   axlocks, axcaches, axprots, axregions, axqoss, axusers, axbars,
   axdomains, axsnoops, awuniques, axreadym
   );

   parameter ADDR_WIDTH = 32;
   parameter ID_WIDTH = 4;
   parameter USER_WIDTH = 1;
   parameter HNDSHK_MODE = `AXI_RS_FULL;
   parameter SNOOP_WIDTH = 3;

   localparam PAYLD_WIDTH = ID_WIDTH + ADDR_WIDTH + USER_WIDTH + SNOOP_WIDTH + 34;

   input aclk;
   input aresetn;

   input                  axvalids;
   output                 axreadys;
   input [ID_WIDTH-1:0]   axids;
   input [ADDR_WIDTH-1:0] axaddrs;
   input [7:0]            axlens;
   input [2:0]            axsizes;
   input [1:0]            axbursts;
   input                  axlocks;
   input [3:0]            axcaches;
   input [2:0]            axprots;
   input [3:0]            axregions;
   input [3:0]            axqoss;
   input [USER_WIDTH-1:0] axusers;
   input [1:0]            axbars;
   input [1:0]            axdomains;
   input [SNOOP_WIDTH-1:0] axsnoops; 
   input                  awuniques;



   output                  axvalidm;
   input                   axreadym;
   output [ID_WIDTH-1:0]   axidm;
   output [ADDR_WIDTH-1:0] axaddrm;
   output [7:0]            axlenm;
   output [2:0]            axsizem;
   output [1:0]            axburstm;
   output                  axlockm;
   output [3:0]            axcachem;
   output [2:0]            axprotm;
   output [3:0]            axregionm;
   output [3:0]            axqosm;
   output [USER_WIDTH-1:0] axuserm;
   output [1:0]            axbarm;
   output [1:0]            axdomainm;
   output [SNOOP_WIDTH-1:0] axsnoopm; 
   output                  awuniquem;

    

   wire                   valid_src;
   wire                   ready_src;
   wire [PAYLD_WIDTH-1:0] payload_src;
   wire                   valid_dst;
   wire                   ready_dst;                    
   wire [PAYLD_WIDTH-1:0] payload_dst;


   assign valid_src = axvalids;
   assign payload_src = {axids,
                         axaddrs,
                         axlens,
                         axsizes,
                         axbursts,
                         axlocks,
                         axcaches,
                         axprots,
                         axregions,
                         axqoss,
                         axusers,
                         axbars,
                         axdomains,
                         axsnoops,
                         awuniques};
   assign axreadys = ready_src;

   assign axvalidm = valid_dst;
   assign {axidm,
           axaddrm,
           axlenm,
           axsizem,
           axburstm,
           axlockm,
           axcachem,
           axprotm,
           axregionm,
           axqosm,
           axuserm,
           axbarm,
           axdomainm,
           axsnoopm,
           awuniquem} = payload_dst;
   assign ready_dst = axreadym;

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
   