/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
module nx_sync_flop(
   
   dout,
   
   clk, rst_n, din
   );

   parameter WIDTH = 1;
   parameter RANKS = 1;
   parameter RESET_VAL = 0;

   input clk;
   input rst_n;

   input [WIDTH-1:0] din;
   output [WIDTH-1:0] dout;
   
   generate
      if (RANKS==0) begin : nosync
         assign dout = din;
      end
      else if (RANKS==1) begin : single_rank
	 logic dout;
         always_ff@(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
               dout <= RESET_VAL;
            end
            else begin
               dout <= din;
            end
         end
      end
      else begin : dual_rank
         cr_dual_rank_synchronizer #(.WIDTH(WIDTH), .RESET_VAL(RESET_VAL)) sync
           (.clk (clk),
            .rst_n (rst_n),
            .din (din),
            .dout (dout));
      end
   endgenerate

endmodule 

   
