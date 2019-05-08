/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



















`ifndef __CR_PREFIX_VH
`define __CR_PREFIX_VH


`include "cr_prefix_regs.vh"
`include "cr_prefix_regsPKG.svp"
`include "cr_prefix_regfilePKG.svp"
`include "cr_prefixPKG.svp"

`define MAX(a,b) \
    (((a)>(b))?(a):(b))
`define MIN(a,b) \
    (((a)<(b))?(a):(b))
`define LOG_VEC(a) `MAX(0, ($clog2(a)-1)):0

`define PREFIX_NEURON_WIDTH  8
`define N_PREFIX_NEURONS     128
`define PREFIX_ACC_WIDTH     20  
`define MAX_PREFIX_NUM       63 
`endif 



    
  