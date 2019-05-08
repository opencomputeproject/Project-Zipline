/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`ifndef MESSAGES_UVM_VH
  `define MESSAGES_UVM_VH

  `include "uvm_macros.svh"
import uvm_pkg::*;

`include "sformatf_macro.vh"

`define FATAL(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
do `uvm_fatal("DUT_FATAL", $sformatf("(%m) %s", `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15))) while(0)

`define ERROR(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
do `uvm_error("DUT_ERROR", $sformatf("(%m) %s", `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15))) while(0)

`define WARN(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
do `uvm_warning("DUT_WARN", $sformatf("(%m) %s", `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15))) while(0)

`define INFO(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
do `uvm_info("DUT_INFO", $sformatf("(%m) %s", `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15)), UVM_MEDIUM) while(0)

`define STATUS(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
do `uvm_info("DUT_STATUS", $sformatf("(%m) %s", `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15)), UVM_MEDIUM) while(0)

`define DEBUG(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
do `uvm_info("DUT_DEBUG", $sformatf("(%m) %s", `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15)), UVM_DEBUG) while(0)

`define BUG(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
do `uvm_info("DUT_BUG", $sformatf("(%m) %s", `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15)), UVM_NONE) while(0)


`endif 
