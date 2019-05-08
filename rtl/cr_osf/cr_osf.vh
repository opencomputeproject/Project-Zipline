/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



















`ifndef __CR_OSF_VH
`define __CR_OSF_VH


`include "cr_osf_regs.vh"
`include "cr_osf_regsPKG.svp"
`include "cr_osf_regfilePKG.svp"
`include "cr_osfPKG.svp"

`define MAX(a,b) \
    (((a)>(b))?(a):(b))
`define MIN(a,b) \
    (((a)<(b))?(a):(b))
`define LOG_VEC(a) `MAX(0, ($clog2(a)-1)):0

`define LAT_TMR_WIDTH 40

`endif 



    
