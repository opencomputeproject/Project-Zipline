/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



















`ifndef __CR_CDDIP_SA_VH
`define __CR_CDDIP_SA_VH


`include "cr_cddip_sa_regs.vh"
`include "cr_cddip_sa_regsPKG.svp"
`include "cr_cddip_sa_regfilePKG.svp"
`include "cr_cddip_saPKG.svp"

`define MAX(a,b) \
    (((a)>(b))?(a):(b))
`define MIN(a,b) \
    (((a)<(b))?(a):(b))
`define LOG_VEC(a) `MAX(0, ($clog2(a)-1)):0


`endif 



    
