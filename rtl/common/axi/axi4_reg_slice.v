/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "axi_reg_slice_defs.vh"

module axi4_reg_slice(
   
   awreadys, awvalidm, awidm, awaddrm, awlenm, awsizem, awburstm,
   awlockm, awcachem, awprotm, awregionm, awqosm, awuserm, arreadys,
   arvalidm, aridm, araddrm, arlenm, arsizem, arburstm, arlockm,
   arcachem, arprotm, arregionm, arqosm, aruserm, wreadys, wvalidm,
   wdatam, wstrbm, wlastm, wuserm, rvalids, rids, rdatas, rresps,
   rlasts, rusers, rreadym, bvalids, bids, bresps, busers, breadym,
   
   aclk, aresetn, awvalids, awids, awaddrs, awlens, awsizes, awbursts,
   awlocks, awcaches, awprots, awregions, awqoss, awusers, awreadym,
   arvalids, arids, araddrs, arlens, arsizes, arbursts, arlocks,
   arcaches, arprots, arregions, arqoss, arusers, arreadym, wvalids,
   wdatas, wstrbs, wlasts, wusers, wreadym, rreadys, rvalidm, ridm,
   rdatam, rrespm, rlastm, ruserm, breadys, bvalidm, bidm, brespm,
   buserm
   );

   parameter ADDR_WIDTH = 32;
   parameter DATA_WIDTH = 32;
   parameter ID_WIDTH = 4;
   parameter AW_USER_WIDTH = 1;
   parameter AW_HNDSHK_MODE = `AXI_RS_FULL;
   parameter AR_USER_WIDTH = 1;
   parameter AR_HNDSHK_MODE = `AXI_RS_FULL;
   parameter W_USER_WIDTH = 1;
   parameter W_HNDSHK_MODE = `AXI_RS_FULL;
   parameter R_USER_WIDTH = 1;
   parameter R_HNDSHK_MODE = `AXI_RS_FULL;
   parameter B_USER_WIDTH = 1;
   parameter B_HNDSHK_MODE = `AXI_RS_FULL;

   parameter STRB_WIDTH = DATA_WIDTH/8;

   input aclk; 
   input aresetn;

   input                  awvalids;
   output                 awreadys;
   input [ID_WIDTH-1:0]   awids;
   input [ADDR_WIDTH-1:0] awaddrs;
   input [7:0]            awlens;
   input [2:0]            awsizes;
   input [1:0]            awbursts;
   input                  awlocks;
   input [3:0]            awcaches;
   input [2:0]            awprots;
   input [3:0]            awregions;
   input [3:0]            awqoss;
   input [AW_USER_WIDTH-1:0] awusers;

   output                  awvalidm;
   input                   awreadym;
   output [ID_WIDTH-1:0]   awidm;
   output [ADDR_WIDTH-1:0] awaddrm;
   output [7:0]            awlenm;
   output [2:0]            awsizem;
   output [1:0]            awburstm;
   output                  awlockm;
   output [3:0]            awcachem;
   output [2:0]            awprotm;
   output [3:0]            awregionm;
   output [3:0]            awqosm;
   output [AW_USER_WIDTH-1:0] awuserm;

   input                  arvalids;
   output                 arreadys;
   input [ID_WIDTH-1:0]   arids;
   input [ADDR_WIDTH-1:0] araddrs;
   input [7:0]            arlens;
   input [2:0]            arsizes;
   input [1:0]            arbursts;
   input                  arlocks;
   input [3:0]            arcaches;
   input [2:0]            arprots;
   input [3:0]            arregions;
   input [3:0]            arqoss;
   input [AR_USER_WIDTH-1:0] arusers;

   output                  arvalidm;
   input                   arreadym;
   output [ID_WIDTH-1:0]   aridm;
   output [ADDR_WIDTH-1:0] araddrm;
   output [7:0]            arlenm;
   output [2:0]            arsizem;
   output [1:0]            arburstm;
   output                  arlockm;
   output [3:0]            arcachem;
   output [2:0]            arprotm;
   output [3:0]            arregionm;
   output [3:0]            arqosm;
   output [AR_USER_WIDTH-1:0] aruserm;

   input                  wvalids;
   output                 wreadys;
   input [DATA_WIDTH-1:0] wdatas;
   input [STRB_WIDTH-1:0] wstrbs;
   input                  wlasts;
   input [W_USER_WIDTH-1:0] wusers;

   output                  wvalidm;
   input                   wreadym;
   output [DATA_WIDTH-1:0] wdatam;
   output [STRB_WIDTH-1:0] wstrbm;
   output                  wlastm;
   output [W_USER_WIDTH-1:0] wuserm;

   output                  rvalids;
   input                 rreadys;
   output [ID_WIDTH-1:0]   rids;
   output [DATA_WIDTH-1:0] rdatas;
   output [1:0]            rresps;
   output                  rlasts;
   output [R_USER_WIDTH-1:0] rusers;

   input                  rvalidm;
   output                   rreadym;
   input [ID_WIDTH-1:0]   ridm;
   input [DATA_WIDTH-1:0] rdatam;
   input [1:0]            rrespm;
   input                  rlastm;
   input [R_USER_WIDTH-1:0] ruserm;

   output                 bvalids;
   input                 breadys;
   output [ID_WIDTH-1:0]   bids;
   output [1:0]            bresps;
   output [B_USER_WIDTH-1:0] busers;

   input                  bvalidm;
   output                   breadym;
   input [ID_WIDTH-1:0]   bidm;
   input [1:0]            brespm;
   input [B_USER_WIDTH-1:0] buserm;

   
   axi4_ax_reg_slice #(.ADDR_WIDTH(ADDR_WIDTH), .ID_WIDTH(ID_WIDTH), .USER_WIDTH(AW_USER_WIDTH), .HNDSHK_MODE(AW_HNDSHK_MODE)) aw_reg_slice
     (
      
      .axreadys                         (awreadys),              
      .axvalidm                         (awvalidm),              
      .axidm                            (awidm[ID_WIDTH-1:0]),   
      .axaddrm                          (awaddrm[ADDR_WIDTH-1:0]), 
      .axlenm                           (awlenm[7:0]),           
      .axsizem                          (awsizem[2:0]),          
      .axburstm                         (awburstm[1:0]),         
      .axlockm                          (awlockm),               
      .axcachem                         (awcachem[3:0]),         
      .axprotm                          (awprotm[2:0]),          
      .axregionm                        (awregionm[3:0]),        
      .axqosm                           (awqosm[3:0]),           
      .axuserm                          (awuserm[AW_USER_WIDTH-1:0]), 
      
      .aclk                             (aclk),
      .aresetn                          (aresetn),
      .axvalids                         (awvalids),              
      .axids                            (awids[ID_WIDTH-1:0]),   
      .axaddrs                          (awaddrs[ADDR_WIDTH-1:0]), 
      .axlens                           (awlens[7:0]),           
      .axsizes                          (awsizes[2:0]),          
      .axbursts                         (awbursts[1:0]),         
      .axlocks                          (awlocks),               
      .axcaches                         (awcaches[3:0]),         
      .axprots                          (awprots[2:0]),          
      .axregions                        (awregions[3:0]),        
      .axqoss                           (awqoss[3:0]),           
      .axusers                          (awusers[AW_USER_WIDTH-1:0]), 
      .axreadym                         (awreadym));              

   
   axi4_ax_reg_slice #(.ADDR_WIDTH(ADDR_WIDTH), .ID_WIDTH(ID_WIDTH), .USER_WIDTH(AR_USER_WIDTH), .HNDSHK_MODE(AR_HNDSHK_MODE)) ar_reg_slice
     (
      
      .axreadys                         (arreadys),              
      .axvalidm                         (arvalidm),              
      .axidm                            (aridm[ID_WIDTH-1:0]),   
      .axaddrm                          (araddrm[ADDR_WIDTH-1:0]), 
      .axlenm                           (arlenm[7:0]),           
      .axsizem                          (arsizem[2:0]),          
      .axburstm                         (arburstm[1:0]),         
      .axlockm                          (arlockm),               
      .axcachem                         (arcachem[3:0]),         
      .axprotm                          (arprotm[2:0]),          
      .axregionm                        (arregionm[3:0]),        
      .axqosm                           (arqosm[3:0]),           
      .axuserm                          (aruserm[AR_USER_WIDTH-1:0]), 
      
      .aclk                             (aclk),
      .aresetn                          (aresetn),
      .axvalids                         (arvalids),              
      .axids                            (arids[ID_WIDTH-1:0]),   
      .axaddrs                          (araddrs[ADDR_WIDTH-1:0]), 
      .axlens                           (arlens[7:0]),           
      .axsizes                          (arsizes[2:0]),          
      .axbursts                         (arbursts[1:0]),         
      .axlocks                          (arlocks),               
      .axcaches                         (arcaches[3:0]),         
      .axprots                          (arprots[2:0]),          
      .axregions                        (arregions[3:0]),        
      .axqoss                           (arqoss[3:0]),           
      .axusers                          (arusers[AR_USER_WIDTH-1:0]), 
      .axreadym                         (arreadym));              

   axi4_w_reg_slice #(.DATA_WIDTH(DATA_WIDTH), .USER_WIDTH(W_USER_WIDTH), .HNDSHK_MODE(W_HNDSHK_MODE)) w_reg_slice
     (
      
      .wreadys                          (wreadys),
      .wvalidm                          (wvalidm),
      .wdatam                           (wdatam[DATA_WIDTH-1:0]),
      .wstrbm                           (wstrbm[STRB_WIDTH-1:0]),
      .wlastm                           (wlastm),
      .wuserm                           (wuserm[W_USER_WIDTH-1:0]),
      
      .aclk                             (aclk),
      .aresetn                          (aresetn),
      .wvalids                          (wvalids),
      .wdatas                           (wdatas[DATA_WIDTH-1:0]),
      .wstrbs                           (wstrbs[STRB_WIDTH-1:0]),
      .wlasts                           (wlasts),
      .wusers                           (wusers[W_USER_WIDTH-1:0]),
      .wreadym                          (wreadym));

   axi_r_reg_slice #(.DATA_WIDTH(DATA_WIDTH), .ID_WIDTH(ID_WIDTH), .USER_WIDTH(R_USER_WIDTH), .HNDSHK_MODE(R_HNDSHK_MODE)) r_reg_slice
     (
      
      .rvalids                          (rvalids),
      .rids                             (rids[ID_WIDTH-1:0]),
      .rdatas                           (rdatas[DATA_WIDTH-1:0]),
      .rresps                           (rresps[1:0]),
      .rlasts                           (rlasts),
      .rusers                           (rusers[R_USER_WIDTH-1:0]),
      .rreadym                          (rreadym),
      
      .aclk                             (aclk),
      .aresetn                          (aresetn),
      .rreadys                          (rreadys),
      .rvalidm                          (rvalidm),
      .ridm                             (ridm[ID_WIDTH-1:0]),
      .rdatam                           (rdatam[DATA_WIDTH-1:0]),
      .rrespm                           (rrespm[1:0]),
      .rlastm                           (rlastm),
      .ruserm                           (ruserm[R_USER_WIDTH-1:0]));

   axi_b_reg_slice #(.ID_WIDTH(ID_WIDTH), .USER_WIDTH(B_USER_WIDTH), .HNDSHK_MODE(B_HNDSHK_MODE)) b_reg_slice
     (
      
      .bvalids                          (bvalids),
      .bids                             (bids[ID_WIDTH-1:0]),
      .bresps                           (bresps[1:0]),
      .busers                           (busers[B_USER_WIDTH-1:0]),
      .breadym                          (breadym),
      
      .aclk                             (aclk),
      .aresetn                          (aresetn),
      .breadys                          (breadys),
      .bvalidm                          (bvalidm),
      .bidm                             (bidm[ID_WIDTH-1:0]),
      .brespm                           (brespm[1:0]),
      .buserm                           (buserm[B_USER_WIDTH-1:0]));
   
endmodule
   