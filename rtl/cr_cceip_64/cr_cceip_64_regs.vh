/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`ifdef CR_CCEIP_64_REGS_VH
`else
`define CR_CCEIP_64_REGS_VH






`define CR_CCEIP_64_RBUS_WIDTH 20
`define CR_CCEIP_64_RBUS_DECL  19:0

`define CCEIP64_SUPPORT_RBUS_START       20'h00000
`define CCEIP64_SUPPORT_RBUS_END         20'h0009f

`define CCEIP64_ISF_RBUS_START           20'h10000
`define CCEIP64_ISF_RBUS_END             20'h100d7

`define CCEIP64_CRCGC0_RBUS_START        20'h20000
`define CCEIP64_CRCGC0_RBUS_END          20'h2007f

`define CCEIP64_PREFIX_RBUS_START        20'h30000
`define CCEIP64_PREFIX_RBUS_END          20'h302ff

`define CCEIP64_PREFIX_ATTACH_RBUS_START 20'h40000
`define CCEIP64_PREFIX_ATTACH_RBUS_END   20'h4005f

`define CCEIP64_LZ77_COMP_RBUS_START     20'h50000
`define CCEIP64_LZ77_COMP_RBUS_END       20'h5004b

`define CCEIP64_HUF_COMP_RBUS_START      20'h60000
`define CCEIP64_HUF_COMP_RBUS_END        20'h601eb

`define CCEIP64_CRCG0_RBUS_START         20'h80000
`define CCEIP64_CRCG0_RBUS_END           20'h8007f

`define CCEIP64_CRCC0_RBUS_START         20'h90000
`define CCEIP64_CRCC0_RBUS_END           20'h9007f

`define CCEIP64_XP10_DECOMP_RBUS_START   20'hb0000
`define CCEIP64_XP10_DECOMP_RBUS_END     20'hb0123

`define CCEIP64_CRCC1_RBUS_START         20'hd0000
`define CCEIP64_CRCC1_RBUS_END           20'hd007f

`define CCEIP64_CG_RBUS_START            20'he0000
`define CCEIP64_CG_RBUS_END              20'he0017

`define CCEIP64_OSF_RBUS_START           20'hf0000
`define CCEIP64_OSF_RBUS_END             20'hf00af

`define CCEIP64_SA_RBUS_START            20'hf4000
`define CCEIP64_SA_RBUS_END              20'hf4057

`define CCEIP64_SU_RBUS_START            20'hf8000
`define CCEIP64_SU_RBUS_END              20'hf8097

`endif
