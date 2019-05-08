/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
module cr_dual_rank_synchronizer (clk, rst_n, din, dout);

parameter WIDTH = 1;
parameter RESET_VAL = 0;

   input  clk;
   input  rst_n;
   input  din;
   output dout;
   
  assign dout = rst_n;

endmodule
