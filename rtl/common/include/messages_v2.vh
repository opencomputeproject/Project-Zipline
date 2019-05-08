/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/





























































`ifndef MESSAGES_V2_VH
  `define MESSAGES_V2_VH

  `ifdef SYNTHESIS
    `define FATAL   $display
    `define ERROR   $display
    `define WARN    $display
    `define INFO    $display
    `define STATUS  $display
    `define DEBUG   $display
    `define BUG     $display
  `elsif SPYGLASS
    `define FATAL   $display
    `define ERROR   $display
    `define WARN    $display
    `define INFO    $display
    `define STATUS  $display
    `define DEBUG   $display
    `define BUG     $display
  `elsif USE_MESSAGES_PLI
    `include "sformatf_macro.vh"



    `define FATAL(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
$fatal("%s", `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15))
    `define ERROR(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
$error("%s", `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15))
    `define WARN(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
$warn("%s", `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15))
    `define INFO(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
$info("%s", `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15))
    `define STATUS(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
$status("%s", `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15))
    `define DEBUG(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
$debug("%s", `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15))
    `define BUG(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
$bug("%s", `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15))
    `define SUMMARY $summary

  `elsif USE_MESSAGES_UVM

   `include "messages_uvm.vh"

   `define SUMMARY $summary

  `else



    `include "sformatf_macro.vh"

    `ifndef FATAL
      `define FATAL(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
$fatal(1, `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15))
    `endif
    `ifndef ERROR
      `define ERROR $error
    `endif
    `ifndef WARN
      `define WARN if (!$test$plusargs("warn_off")) $warning
    `endif
    `ifndef INFO
      `define INFO if (!$test$plusargs("info_off")) $info
    `endif
    `ifndef STATUS
      `define STATUS(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
$info("STATUS: %s", `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15))
    `endif
    `ifndef DEBUG
      `define DEBUG(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
if ($test$plusargs("debug_on")) $info("DEBUG: %s", `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15))
    `endif
    `ifndef BUG
      `define BUG(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
$info("BUG: %s", `_SFORMATF(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15))
    `endif
  `endif 

  `ifndef SUMMARY
    `define SUMMARY do begin bit nothing; nothing=0; end while(0)
  `endif

  `ifndef ENTER
    `define ENTER `STATUS("Entering %m")
  `endif

  `ifndef LEAVE
    `define LEAVE `STATUS("Exiting %m")
  `endif

`endif 



       