// *************************************************************************
//
// Copyright © Microsoft Corporation. All rights reserved.
// Copyright © Broadcom Inc. All rights reserved.
// Licensed under the MIT License.
//
// *************************************************************************
module cr_mux_32 (o,i0_0,i0_1,i0_2,i1_0,i1_1);
   output o;
   input  i0_0,i0_1,i0_2,i1_0,i1_1;
   
   wire   t0 = i0_0 & i0_1  & i0_2;
   wire   t1 = i1_0 & i1_1;
   wire   0  = t0 | t1;

endmodule