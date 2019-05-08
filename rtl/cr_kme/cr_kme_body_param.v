/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










`include "cr_kme_functions.v"
`include "cr_kme_structs.v"

import cr_kmePKG::*;
import cr_kme_regfilePKG::*;

localparam CKV_NUM_ENTRIES = 32768;
localparam CKV_DATA_WIDTH  = $bits(ckv_t);

localparam KIM_NUM_ENTRIES = 16384;
localparam KIM_DATA_WIDTH  = $bits(kim_entry_t);

