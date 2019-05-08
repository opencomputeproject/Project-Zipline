/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



















`ifndef __CR_CDDIP_SUPPORT_VH
`define __CR_CDDIP_SUPPORT_VH


`include "cr_cddip_support_regs.vh"
`include "cr_cddip_support_regsPKG.svp"
`include "cr_cddip_support_regfilePKG.svp"
`include "cr_cddip_supportPKG.svp"

`define MAX(a,b) \
    (((a)>(b))?(a):(b))
`define MIN(a,b) \
    (((a)<(b))?(a):(b))
`define LOG_VEC(a) `MAX(0, ($clog2(a)-1)):0


`endif 



    
