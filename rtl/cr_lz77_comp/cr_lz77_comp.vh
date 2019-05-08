/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`ifndef CR_LZ77_COMP_VH
 `define CR_LZ77_COMP_VH

 `include "cr_lz77_comp_regs.vh"

 `define WIN_TILES           128
 `define OFFSETS_PER_TILE    512
 `define IN_BYTES            4
 `define TRUNC_NUM           3
 `define TRUNC_NUM_V3        4
 `define MTF_NUM             4
 `define TILE_MTF_NUM        20
 `define TILES_PER_CLUSTER   16
 `define CLUSTERS            8

 `define LONGL          `IN_BYTES + 4
 `define LONGL_V3       13
 `define TILE_DEPTH     `OFFSETS_PER_TILE

 `define CR_LZ77_COMP_ERROR `include "cr_lz77_comp_assertion_error.inc"

 `define CR_LZ77_COMP_VIRTUALIZED_LPO
 `define CR_USE_LZ77_COMP_ENGINE_V3
 `define CR_USE_ROSC
 `define LPO_BM_PIPELINE
 `define LPO_X1_BM_PIPELINE
 `define CR_LZ77_TILE_X1_SHIFT_MULT 4
 `define CR_LZ77_TILE_X8_CLT0_SHIFT_MULT 4
 `define CR_LZ77_TILE_X8_SHIFT_MULT 4
 `define CR_LZ77_TILE_X16_SHIFT_MULT 4

 `define ENA_BIMC

`endif
