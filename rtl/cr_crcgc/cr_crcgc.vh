/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



















`ifndef __CR_CRCGC_VH
`define __CR_CRCGC_VH


`include "cr_crcgc_regs.vh"
`include "cr_crcgc_regsPKG.svp"
`include "cr_crcgc_regfilePKG.svp"
`include "cr_crcgcPKG.svp"

`define MAX(a,b) \
    (((a)>(b))?(a):(b))
`define MIN(a,b) \
    (((a)<(b))?(a):(b))
`define LOG_VEC(a) `MAX(0, ($clog2(a)-1)):0

`endif 



    
