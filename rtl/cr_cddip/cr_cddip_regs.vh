/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`ifdef CR_CDDIP_REGS_VH
`else
`define CR_CDDIP_REGS_VH






`define CR_CDDIP_RBUS_WIDTH 20
`define CR_CDDIP_RBUS_DECL  19:0

`define CDDIP_SUPPORT_RBUS_START       20'h00000
`define CDDIP_SUPPORT_RBUS_END         20'h0008b

`define CDDIP_ISF_RBUS_START           20'h10000
`define CDDIP_ISF_RBUS_END             20'h100d7

`define CDDIP_CRCC0_RBUS_START         20'h20000
`define CDDIP_CRCC0_RBUS_END           20'h2007f

`define CDDIP_PREFIX_ATTACH_RBUS_START 20'h40000
`define CDDIP_PREFIX_ATTACH_RBUS_END   20'h4005f

`define CDDIP_XP10_DECOMP_RBUS_START   20'h50000
`define CDDIP_XP10_DECOMP_RBUS_END     20'h50123

`define CDDIP_CRCG0_RBUS_START         20'h70000
`define CDDIP_CRCG0_RBUS_END           20'h7007f

`define CDDIP_CG_RBUS_START            20'h80000
`define CDDIP_CG_RBUS_END              20'h80017

`define CDDIP_OSF_RBUS_START           20'h90000
`define CDDIP_OSF_RBUS_END             20'h900af

`define CDDIP_SA_RBUS_START            20'ha0000
`define CDDIP_SA_RBUS_END              20'ha0057

`define CDDIP_SU_RBUS_START            20'hb0000
`define CDDIP_SU_RBUS_END              20'hb0097

`endif
