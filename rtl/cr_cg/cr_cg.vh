/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



















`ifndef __CR_CG_VH
`define __CR_CG_VH


`include "cr_cg_regs.vh"
`include "cr_cg_regsPKG.svp"
`include "cr_cg_regfilePKG.svp"
`include "cr_cgPKG.svp"

`define MAX(a,b) \
    (((a)>(b))?(a):(b))
`define MIN(a,b) \
    (((a)<(b))?(a):(b))
`define LOG_VEC(a) `MAX(0, ($clog2(a)-1)):0

`define CG_GUID_LEN 8'd10



`endif 



    
