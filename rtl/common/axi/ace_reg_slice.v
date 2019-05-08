/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "axi_reg_slice_defs.vh"
`include "ace_reg_slice_defs.vh"

module ace_reg_slice
(
   
   awreadys, awvalidm, awidm, awaddrm, awlenm, awsizem, awburstm,
   awlockm, awcachem, awprotm, awregionm, awqosm, awuserm, awbarm,
   awdomainm, awsnoopm, awuniquem, arreadys, arvalidm, aridm, araddrm,
   arlenm, arsizem, arburstm, arlockm, arcachem, arprotm, arregionm,
   arqosm, aruserm, arbarm, ardomainm, arsnoopm, wreadys, wvalidm,
   wdatam, wstrbm, wlastm, wuserm, rvalids, rids, rdatas, rresps,
   rlasts, rusers, rreadym, bvalids, bids, bresps, busers, breadym,
   acaddrm, acprotm, acreadys, acsnoopm, acvalidm, cddatam, cdlastm,
   cdreadys, cdvalidm, crreadys, crrespm, crvalidm,
   
   aclk, aresetn, awvalids, awids, awaddrs, awlens, awsizes, awbursts,
   awlocks, awcaches, awprots, awregions, awqoss, awusers, awbars,
   awdomains, awsnoops, awuniques, awreadym, arvalids, arids, araddrs,
   arlens, arsizes, arbursts, arlocks, arcaches, arprots, arregions,
   arqoss, arusers, arbars, ardomains, arsnoops, arreadym, wvalids,
   wdatas, wstrbs, wlasts, wusers, wreadym, rreadys, rvalidm, ridm,
   rdatam, rrespm, rlastm, ruserm, breadys, bvalidm, bidm, brespm,
   buserm, acaddrs, acprots, acreadym, acsnoops, acvalids, cddatas,
   cdlasts, cdreadym, cdvalids, crreadym, crresps, crvalids, racks,
   wacks, rackm, wackm
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
  parameter AC_ADDR_WIDTH = 32;
  parameter AC_HNDSHK_MODE = `AXI_RS_FULL;
  parameter CR_HNDSHK_MODE = `AXI_RS_FULL;
  parameter CD_DATA_WIDTH = 32;
  parameter CD_HNDSHK_MODE = `AXI_RS_FULL;
  parameter WACK_REG       = `ACE_RACK_WACK_REG;
  parameter RACK_REG       = `ACE_RACK_WACK_REG;
  parameter STRB_WIDTH = DATA_WIDTH/8;

  input     aclk; 
  input     aresetn;

  input     awvalids;
  output    awreadys;
  input [ID_WIDTH-1:0] awids;
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
  
  input [1:0]               awbars;                 
  input [1:0]               awdomains;              
  input [2:0]               awsnoops;               
  input                     awuniques;              

  output                    awvalidm;
  input                     awreadym;
  output [ID_WIDTH-1:0]     awidm;
  output [ADDR_WIDTH-1:0]   awaddrm;
  output [7:0]              awlenm;
  output [2:0]              awsizem;
  output [1:0]              awburstm;
  output                    awlockm;
  output [3:0]              awcachem;
  output [2:0]              awprotm;
  output [3:0]              awregionm;
  output [3:0]              awqosm;
  output [AW_USER_WIDTH-1:0] awuserm;
  
  output [1:0]               awbarm;
  output [1:0]               awdomainm;
  output [2:0]               awsnoopm;
  output                     awuniquem;

  input                      arvalids;
  output                     arreadys;
  input [ID_WIDTH-1:0]       arids;
  input [ADDR_WIDTH-1:0]     araddrs;
  input [7:0]                arlens;
  input [2:0]                arsizes;
  input [1:0]                arbursts;
  input                      arlocks;
  input [3:0]                arcaches;
  input [2:0]                arprots;
  input [3:0]                arregions;
  input [3:0]                arqoss;
  input [AR_USER_WIDTH-1:0]  arusers;
  input [1:0]                arbars;
  input [1:0]                ardomains;
  input [3:0]                arsnoops;

  output                     arvalidm;
  input                      arreadym;
  output [ID_WIDTH-1:0]      aridm;
  output [ADDR_WIDTH-1:0]    araddrm;
  output [7:0]               arlenm;
  output [2:0]               arsizem;
  output [1:0]               arburstm;
  output                     arlockm;
  output [3:0]               arcachem;
  output [2:0]               arprotm;
  output [3:0]               arregionm;
  output [3:0]               arqosm;
  output [AR_USER_WIDTH-1:0] aruserm;
  
  output [1:0]               arbarm;
  output [1:0]               ardomainm;
  output [3:0]               arsnoopm;

  input                      wvalids;
  output                     wreadys;
  input [DATA_WIDTH-1:0]     wdatas;
  input [STRB_WIDTH-1:0]     wstrbs;
  input                      wlasts;
  input [W_USER_WIDTH-1:0]   wusers;

  output                     wvalidm;
  input                      wreadym;
  output [DATA_WIDTH-1:0]    wdatam;
  output [STRB_WIDTH-1:0]    wstrbm;
  output                     wlastm;
  output [W_USER_WIDTH-1:0]  wuserm;

  output                     rvalids;
  input                      rreadys;
  output [ID_WIDTH-1:0]      rids;
  output [DATA_WIDTH-1:0]    rdatas;
  output [3:0]               rresps;
  output                     rlasts;
  output [R_USER_WIDTH-1:0]  rusers;

  input                      rvalidm;
  output                     rreadym;
  input [ID_WIDTH-1:0]       ridm;
  input [DATA_WIDTH-1:0]     rdatam;
  input [3:0]                rrespm;
  input                      rlastm;
  input [R_USER_WIDTH-1:0]   ruserm;

  output                     bvalids;
  input                      breadys;
  output [ID_WIDTH-1:0]      bids;
  output [1:0]               bresps;
  output [B_USER_WIDTH-1:0]  busers;

  input                      bvalidm;
  output                     breadym;
  input [ID_WIDTH-1:0]       bidm;
  input [1:0]                brespm;
  input [B_USER_WIDTH-1:0]   buserm;

  
  output [AC_ADDR_WIDTH-1:0] acaddrs;
  output [2:0]               acprots;
  output                     acreadym;
  output [3:0]               acsnoops;
  output                     acvalids;

  input  [AC_ADDR_WIDTH-1:0] acaddrm;
  input  [2:0]               acprotm;
  input                      acreadys;
  input  [3:0]               acsnoopm;
  input                      acvalidm;

  input [CD_DATA_WIDTH-1:0]  cddatas;
  input                      cdlasts;
  input                      cdreadym;
  input                      cdvalids;

  output [CD_DATA_WIDTH-1:0] cddatam;
  output                     cdlastm;
  output                     cdreadys;
  output                     cdvalidm;

  input                      crreadym;
  input [4:0]                crresps;
  input                      crvalids;
  
  output                     crreadys;
  output [4:0]               crrespm;
  output                     crvalidm;

  input                      racks;
  input                      wacks;

  output                     rackm;
  output                     wackm;

  

  
  
  
  
  ace_ax_reg_slice #(.ADDR_WIDTH(ADDR_WIDTH), .ID_WIDTH(ID_WIDTH), .USER_WIDTH(AW_USER_WIDTH), .HNDSHK_MODE(AW_HNDSHK_MODE), .SNOOP_WIDTH(3)) aw_reg_slice
  (
   
   .axreadys                            (awreadys),              
   .axvalidm                            (awvalidm),              
   .axidm                               (awidm[ID_WIDTH-1:0]),   
   .axaddrm                             (awaddrm[ADDR_WIDTH-1:0]), 
   .axlenm                              (awlenm[7:0]),           
   .axsizem                             (awsizem[2:0]),          
   .axburstm                            (awburstm[1:0]),         
   .axlockm                             (awlockm),               
   .axcachem                            (awcachem[3:0]),         
   .axprotm                             (awprotm[2:0]),          
   .axregionm                           (awregionm[3:0]),        
   .axqosm                              (awqosm[3:0]),           
   .axuserm                             (awuserm[AW_USER_WIDTH-1:0]), 
   .axbarm                              (awbarm[1:0]),           
   .axdomainm                           (awdomainm[1:0]),        
   .axsnoopm                            (awsnoopm[2:0]),         
   .awuniquem                           (awuniquem),
   
   .aclk                                (aclk),
   .aresetn                             (aresetn),
   .axvalids                            (awvalids),              
   .axids                               (awids[ID_WIDTH-1:0]),   
   .axaddrs                             (awaddrs[ADDR_WIDTH-1:0]), 
   .axlens                              (awlens[7:0]),           
   .axsizes                             (awsizes[2:0]),          
   .axbursts                            (awbursts[1:0]),         
   .axlocks                             (awlocks),               
   .axcaches                            (awcaches[3:0]),         
   .axprots                             (awprots[2:0]),          
   .axregions                           (awregions[3:0]),        
   .axqoss                              (awqoss[3:0]),           
   .axusers                             (awusers[AW_USER_WIDTH-1:0]), 
   .axbars                              (awbars[1:0]),           
   .axdomains                           (awdomains[1:0]),        
   .axsnoops                            (awsnoops[2:0]),         
   .awuniques                           (awuniques),
   .axreadym                            (awreadym));              


  
  
  
  
  ace_ax_reg_slice #(.ADDR_WIDTH(ADDR_WIDTH), .ID_WIDTH(ID_WIDTH), .USER_WIDTH(AR_USER_WIDTH), .HNDSHK_MODE(AR_HNDSHK_MODE), .SNOOP_WIDTH(4)) ar_reg_slice
  (
   
   .axreadys                            (arreadys),              
   .axvalidm                            (arvalidm),              
   .axidm                               (aridm[ID_WIDTH-1:0]),   
   .axaddrm                             (araddrm[ADDR_WIDTH-1:0]), 
   .axlenm                              (arlenm[7:0]),           
   .axsizem                             (arsizem[2:0]),          
   .axburstm                            (arburstm[1:0]),         
   .axlockm                             (arlockm),               
   .axcachem                            (arcachem[3:0]),         
   .axprotm                             (arprotm[2:0]),          
   .axregionm                           (arregionm[3:0]),        
   .axqosm                              (arqosm[3:0]),           
   .axuserm                             (aruserm[AR_USER_WIDTH-1:0]), 
   .axbarm                              (arbarm[1:0]),           
   .axdomainm                           (ardomainm[1:0]),        
   .axsnoopm                            (arsnoopm[3:0]),         
   .awuniquem                           (),                      
   
   .aclk                                (aclk),
   .aresetn                             (aresetn),
   .axvalids                            (arvalids),              
   .axids                               (arids[ID_WIDTH-1:0]),   
   .axaddrs                             (araddrs[ADDR_WIDTH-1:0]), 
   .axlens                              (arlens[7:0]),           
   .axsizes                             (arsizes[2:0]),          
   .axbursts                            (arbursts[1:0]),         
   .axlocks                             (arlocks),               
   .axcaches                            (arcaches[3:0]),         
   .axprots                             (arprots[2:0]),          
   .axregions                           (arregions[3:0]),        
   .axqoss                              (arqoss[3:0]),           
   .axusers                             (arusers[AR_USER_WIDTH-1:0]), 
   .axbars                              (arbars[1:0]),           
   .axdomains                           (ardomains[1:0]),        
   .axsnoops                            (arsnoops[3:0]),         
   .awuniques                           ({1{1'b0}}),             
   .axreadym                            (arreadym));              

  
  
  
  axi4_w_reg_slice #(.DATA_WIDTH(DATA_WIDTH), .USER_WIDTH(W_USER_WIDTH), .HNDSHK_MODE(W_HNDSHK_MODE)) w_reg_slice
  (
   
   .wreadys                             (wreadys),
   .wvalidm                             (wvalidm),
   .wdatam                              (wdatam[DATA_WIDTH-1:0]),
   .wstrbm                              (wstrbm[STRB_WIDTH-1:0]),
   .wlastm                              (wlastm),
   .wuserm                              (wuserm[W_USER_WIDTH-1:0]),
   
   .aclk                                (aclk),
   .aresetn                             (aresetn),
   .wvalids                             (wvalids),
   .wdatas                              (wdatas[DATA_WIDTH-1:0]),
   .wstrbs                              (wstrbs[STRB_WIDTH-1:0]),
   .wlasts                              (wlasts),
   .wusers                              (wusers[W_USER_WIDTH-1:0]),
   .wreadym                             (wreadym));

  
  
  
  ace_r_reg_slice #(.DATA_WIDTH(DATA_WIDTH), .ID_WIDTH(ID_WIDTH), .USER_WIDTH(R_USER_WIDTH), .HNDSHK_MODE(R_HNDSHK_MODE)) r_reg_slice
  (
   
   .rvalids                             (rvalids),
   .rids                                (rids[ID_WIDTH-1:0]),
   .rdatas                              (rdatas[DATA_WIDTH-1:0]),
   .rresps                              (rresps[3:0]),
   .rlasts                              (rlasts),
   .rusers                              (rusers[R_USER_WIDTH-1:0]),
   .rreadym                             (rreadym),
   
   .aclk                                (aclk),
   .aresetn                             (aresetn),
   .rreadys                             (rreadys),
   .rvalidm                             (rvalidm),
   .ridm                                (ridm[ID_WIDTH-1:0]),
   .rdatam                              (rdatam[DATA_WIDTH-1:0]),
   .rrespm                              (rrespm[3:0]),
   .rlastm                              (rlastm),
   .ruserm                              (ruserm[R_USER_WIDTH-1:0]));

  
  
  
  axi_b_reg_slice #(.ID_WIDTH(ID_WIDTH), .USER_WIDTH(B_USER_WIDTH), .HNDSHK_MODE(B_HNDSHK_MODE)) b_reg_slice
  (
   
   .bvalids                             (bvalids),
   .bids                                (bids[ID_WIDTH-1:0]),
   .bresps                              (bresps[1:0]),
   .busers                              (busers[B_USER_WIDTH-1:0]),
   .breadym                             (breadym),
   
   .aclk                                (aclk),
   .aresetn                             (aresetn),
   .breadys                             (breadys),
   .bvalidm                             (bvalidm),
   .bidm                                (bidm[ID_WIDTH-1:0]),
   .brespm                              (brespm[1:0]),
   .buserm                              (buserm[B_USER_WIDTH-1:0]));
  


  
  
  
  ace_ac_reg_slice #(.AC_ADDR_WIDTH(AC_ADDR_WIDTH), .HNDSHK_MODE(AC_HNDSHK_MODE)) ac_reg_slice
  (
   
   .acreadys                            (acreadys),
   .acvalidm                            (acvalidm),
   .acaddrm                             (acaddrm[AC_ADDR_WIDTH-1:0]),
   .acprotm                             (acprotm[2:0]),
   .acsnoopm                            (acsnoopm[3:0]),
   
   .aclk                                (aclk),
   .aresetn                             (aresetn),
   .acvalids                            (acvalids),
   .acaddrs                             (acaddrs[AC_ADDR_WIDTH-1:0]),
   .acprots                             (acprots[2:0]),
   .acsnoops                            (acsnoops[3:0]),
   .acreadym                            (acreadym));

  
  
  
  ace_cr_reg_slice #(.HNDSHK_MODE(CR_HNDSHK_MODE)) cr_reg_slice
  (
   
   .crreadys                            (crreadys),
   .crvalidm                            (crvalidm),
   .crrespm                             (crrespm[4:0]),
   
   .aclk                                (aclk),
   .aresetn                             (aresetn),
   .crvalids                            (crvalids),
   .crresps                             (crresps[4:0]),
   .crreadym                            (crreadym));


  
  
  
  ace_cd_reg_slice #(.CD_DATA_WIDTH(CD_DATA_WIDTH), .HNDSHK_MODE(CD_HNDSHK_MODE)) cd_reg_slice
  (
   
   .cdreadys                            (cdreadys),
   .cdvalidm                            (cdvalidm),
   .cddatam                             (cddatam[CD_DATA_WIDTH-1:0]),
   .cdlastm                             (cdlastm),
   
   .aclk                                (aclk),
   .aresetn                             (aresetn),
   .cdvalids                            (cdvalids),
   .cddatas                             (cddatas[CD_DATA_WIDTH-1:0]),
   .cdlasts                             (cdlasts),
   .cdreadym                            (cdreadym));


  
  
  

  generate
    reg                      r_racks;
    if (RACK_REG == `ACE_RACK_WACK_REG) begin: rack_register
      always_ff@(posedge aclk or negedge aresetn) begin
        if (!aresetn)
        
        
        r_racks <= 1'h0;
        
        else
        r_racks <= racks;
      end
      assign rackm = r_racks;
    end
    else begin: rack_bypass
      assign rackm = racks;
    end
  endgenerate


  
  
  
  generate
    reg      r_wacks;
    if (WACK_REG == `ACE_RACK_WACK_REG) begin: wack_register
      always_ff@(posedge aclk or negedge aresetn) begin
        if (!aresetn)
        
        
        r_wacks <= 1'h0;
        
        else
        r_wacks <= wacks;
      end
      assign wackm = r_wacks;
    end
    else begin: wack_bypass
      assign wackm = wacks;
    end
  endgenerate


endmodule
