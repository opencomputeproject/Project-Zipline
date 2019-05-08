/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


module cr_rst_sync
  (
   input           clk,                    
   input           async_rst_n,            
   input           bypass_reset,           
   input           test_rst_n,             
   output          rst_n                   
   ); 

   wire            sync_rst_n;
   wire            dual_rank_rst_n;

   assign  dual_rank_rst_n = (bypass_reset && test_rst_n) || async_rst_n;

   cr_dual_rank_synchronizer #(.WIDTH(1),.RESET_VAL(0)) reset_synchronizer
     (
      .clk      (clk),
      .rst_n    (dual_rank_rst_n),
      .din      (1'b1),
      .dout     (sync_rst_n)
      );
   
   assign rst_n = (bypass_reset && test_rst_n) || sync_rst_n;


endmodule 
