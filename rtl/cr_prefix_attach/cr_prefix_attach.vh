/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



















`ifndef __CR_PREFIX_ATTACH_VH
`define __CR_PREFIX_ATTACH_VH


`include "cr_prefix_attach_regs.vh"
`include "cr_prefix_attach_regsPKG.svp"
`include "cr_prefix_attach_regfilePKG.svp"
`include "cr_prefix_attachPKG.svp"

`define MAX(a,b) \
    (((a)>(b))?(a):(b))
`define MIN(a,b) \
    (((a)<(b))?(a):(b))
`define LOG_VEC(a) `MAX(0, ($clog2(a)-1)):0


`endif 



    
