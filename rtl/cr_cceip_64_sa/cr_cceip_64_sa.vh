/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



















`ifndef __CR_CCEIP_64_SA_VH
`define __CR_CCEIP_64_SA_VH


`include "cr_cceip_64_sa_regs.vh"
`include "cr_cceip_64_sa_regsPKG.svp"
`include "cr_cceip_64_sa_regfilePKG.svp"
`include "cr_cceip_64_saPKG.svp"

`define MAX(a,b) \
    (((a)>(b))?(a):(b))
`define MIN(a,b) \
    (((a)<(b))?(a):(b))
`define LOG_VEC(a) `MAX(0, ($clog2(a)-1)):0


`endif 



    
