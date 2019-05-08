/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/









`ifndef __CR_ISF_VH
`define __CR_ISF_VH


`include "cr_isf_regs.vh"
`include "cr_isf_regsPKG.svp"
`include "cr_isf_regfilePKG.svp"


`define MAX(a,b) \
    (((a)>(b))?(a):(b))
`define MIN(a,b) \
    (((a)<(b))?(a):(b))
`define LOG_VEC(a) `MAX(0, ($clog2(a)-1)):0

`include "cr_isfPKG.svp"

`endif 



    
