/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










`ifndef __CR_KME_VH
`define __CR_KME_VH


`include "cr_kme_regs.vh"
`include "cr_kme_regsPKG.svp"
`include "cr_kme_regfilePKG.svp"
`include "cr_kmePKG.svp"

`define MAX(a,b) \
    (((a)>(b))?(a):(b))
`define MIN(a,b) \
    (((a)<(b))?(a):(b))
`define LOG_VEC(a) `MAX(0, ($clog2(a)-1)):0


`endif 



    
