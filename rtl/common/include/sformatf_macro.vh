/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`ifndef _SFORMATF_MACRO_VH
`define _SFORMATF_MACRO_VH

`define _DELIM
`define _SFORMATF(p0, p1=ELIM, p2=ELIM, p3=ELIM, p4=ELIM, p5=ELIM, p6=ELIM, p7=ELIM, p8=ELIM, p9=ELIM, p10=ELIM, p11=ELIM, p12=ELIM, p13=ELIM, p14=ELIM, p15=ELIM) \
`ifdef _D``p1 \
$sformatf(p0) \
`elsif _D``p2 \
$sformatf(p0, p1) \
`elsif _D``p3 \
$sformatf(p0, p1, p2) \
`elsif _D``p4 \
$sformatf(p0, p1, p2, p3) \
`elsif _D``p5 \
$sformatf(p0, p1, p2, p3, p4) \
`elsif _D``p6 \
$sformatf(p0, p1, p2, p3, p4, p5) \
`elsif _D``p7 \
$sformatf(p0, p1, p2, p3, p4, p5, p6) \
`elsif _D``p8 \
$sformatf(p0, p1, p2, p3, p4, p5, p6, p7) \
`elsif _D``p9 \
$sformatf(p0, p1, p2, p3, p4, p5, p6, p7, p8) \
`elsif _D``p10 \
$sformatf(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9) \
`elsif _D``p11 \
$sformatf(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10) \
`elsif _D``p12 \
$sformatf(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11) \
`elsif _D``p13 \
$sformatf(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12) \
`elsif _D``p14 \
$sformatf(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13) \
`elsif _D``p15 \
$sformatf(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14) \
`else \
$sformatf(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15) \
`endif

`endif 
