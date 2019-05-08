/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
module nx_rbus_retime
  (
   
   rrb_blkret_addr, rrb_blkret_rd_stb, rrb_blkret_wr_data,
   rrb_blkret_wr_stb, blk_rrb_ack, blk_rrb_err_ack, blk_rrb_rd_data,
   blk_rrb_intr, blk_rrb_ecc_error,
   
   clk, rst_n, rrb_blk_addr, rrb_blk_rd_stb, rrb_blk_wr_data,
   rrb_blk_wr_stb, blkret_rrb_ack, blkret_rrb_err_ack,
   blkret_rrb_rd_data, blkret_rrb_intr, blkret_rrb_ecc_error
   );

  



  
   
   input                clk  ;
   input 		rst_n;
   
   input [15:0] 	rrb_blk_addr   ;
   input 		rrb_blk_rd_stb ;
   input [31:0] 	rrb_blk_wr_data;
   input 		rrb_blk_wr_stb ;
   
   input  		blkret_rrb_ack;
   input  		blkret_rrb_err_ack;
   input  [31:0] 	blkret_rrb_rd_data;
   input  		blkret_rrb_intr;
   input  		blkret_rrb_ecc_error;
   
   output logic [15:0] 	rrb_blkret_addr   ;
   output logic 	rrb_blkret_rd_stb ;
   output logic [31:0] 	rrb_blkret_wr_data;
   output logic 	rrb_blkret_wr_stb ;
   
   output logic 	blk_rrb_ack;
   output logic 	blk_rrb_err_ack;
   output logic [31:0] 	blk_rrb_rd_data;
   output logic 	blk_rrb_intr;
   output logic 	blk_rrb_ecc_error;
   
   
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
	 rrb_blkret_addr      <= 0;
	 rrb_blkret_rd_stb    <= 0;
	 rrb_blkret_wr_data   <= 0;
	 rrb_blkret_wr_stb    <= 0;
	 blk_rrb_ack          <= 0;
	 blk_rrb_err_ack      <= 0;
	 blk_rrb_rd_data      <= 0;
	 blk_rrb_intr         <= 0;
	 blk_rrb_ecc_error    <= 0;
      end
      else begin
	 rrb_blkret_addr      <= rrb_blk_addr;
	 rrb_blkret_rd_stb    <= rrb_blk_rd_stb;
	 rrb_blkret_wr_data   <= rrb_blk_wr_data;
	 rrb_blkret_wr_stb    <= rrb_blk_wr_stb;
	 blk_rrb_ack          <= blkret_rrb_ack;
	 blk_rrb_err_ack      <= blkret_rrb_err_ack;
	 blk_rrb_rd_data      <= blkret_rrb_rd_data;
	 blk_rrb_intr         <= blkret_rrb_intr;
	 blk_rrb_ecc_error    <= blkret_rrb_ecc_error;
      end
   end
   
endmodule : nx_rbus_retime