/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



















`include "ccx_std.vh"
`include "messages.vh"

module nx_srfram_channelized 
  #(parameter
	WIDTH      = 64 ,
	DEPTH      = 256,
	SPECIALIZE = 1,
	LATCH      = 0,
    RD_FLOP    = 1,
    WR_FLOP    = 1
    ) 
   (input logic              rst_rclk_n,
    input logic 		   rst_wclk_n,
    input logic 		   rclk ,
    input logic 		   wclk ,
`ifdef ENA_BIMC
    input logic 		   lvm, 
    input logic 		   mlvm, 
    input logic 		   mrdten,
    input logic 		   bimc_rst_n,
    input logic 		   bimc_isync,
    input logic 		   bimc_idat ,
    output logic 		   bimc_odat ,
    output logic 		   bimc_osync,
    output logic                   ro_uncorrectable_ecc_error,		   
`endif

    input logic 		   ar_valid,
    output logic 		   ar_ready,
    input logic [`LOG_VEC(DEPTH)]  ar_addr,

    output logic 		   r_valid,
    input logic 		   r_ready,
    output logic [`BIT_VEC(WIDTH)] r_data,

    input logic 		   aw_valid,
    output logic 		   aw_ready,
    input logic [`LOG_VEC(DEPTH)]  aw_addr,
    input logic [`BIT_VEC(WIDTH)]  aw_data,
    input logic [`BIT_VEC(WIDTH)]  aw_bwe,

    output logic 		   b_valid,
    input logic 		   b_ready);

   logic                   reb;
   logic [`LOG_VEC(DEPTH)] ra;     
   logic [`BIT_VEC(WIDTH)] dout;
   logic                   web;
   logic [`LOG_VEC(DEPTH)] wa;
   logic [`BIT_VEC(WIDTH)] din;
   logic [`BIT_VEC(WIDTH)] bwe;

   

   logic [(RD_FLOP?1:0):0]             r_rd_val, c_rd_val;

   assign ra = ar_addr;

   generate
      if (RD_FLOP>0) begin: with_rd_flop
         logic [`BIT_VEC(WIDTH)] r_rd_data, c_rd_data;
         

         assign r_valid = r_rd_val[1];
         assign r_data = r_rd_data;

         always_comb begin
            c_rd_val = r_rd_val;
            c_rd_data = r_rd_data;
            
            reb = 1'b1;
            ar_ready = 1'b0;
            if (r_rd_val[1] && r_ready) begin
               c_rd_val[1] = 1'b0;
            end
            
            if (r_rd_val[0] && !c_rd_val[1]) begin
               c_rd_val[0] = 1'b0;
               c_rd_val[1] = 1'b1;
               c_rd_data = dout;
            end
            
            if (ar_valid && !c_rd_val[0]) begin
               reb = 1'b0;
               ar_ready = 1'b1;
               c_rd_val[0] = 1'b1;
            end
         end 

         
         always_ff@(posedge rclk) begin
            r_rd_data <= c_rd_data;
         end
         

      end 
      else begin: no_rd_flop

         always_comb begin
            c_rd_val = r_rd_val;

            reb = 1'b1;
            ar_ready = 1'b0;
            if (r_rd_val[0] && r_ready) begin
               c_rd_val = 1'b0;
            end

            if (ar_valid && !c_rd_val[0]) begin
               reb = 1'b0;
               ar_ready = 1'b1;
               c_rd_val = 1'b1;
            end
         end 

      end
   endgenerate

   always_ff@(posedge rclk or negedge rst_rclk_n) begin
      if (!rst_rclk_n) begin
         r_rd_val <= '0;
      end
      else begin
         r_rd_val <= c_rd_val;
      end
   end
   
   

   logic [(WR_FLOP?1:0):0]             r_wr_val, c_wr_val;

   generate
      if (WR_FLOP>0) begin: with_wr_flop
         logic [`LOG_VEC(DEPTH)] r_wr_addr, c_wr_addr;
         logic [`BIT_VEC(WIDTH)] r_wr_data, c_wr_data;
         logic [`BIT_VEC(WIDTH)] r_wr_bwe, c_wr_bwe;
         
         assign b_valid = r_wr_val[1];
         assign din = r_wr_data;
         assign wa = r_wr_addr;
         assign bwe = r_wr_bwe;

         always_comb begin
            c_wr_val = r_wr_val;
            c_wr_data = r_wr_data;
            c_wr_addr = r_wr_addr;
            c_wr_bwe = r_wr_bwe;
            
            web = 1'b1;
            aw_ready = 1'b0;
            if (r_wr_val[1] && b_ready) begin
               c_wr_val[1] = 1'b0;
            end
            
            if (r_wr_val[0] && !c_wr_val[1]) begin
               c_wr_val[0] = 1'b0;
               c_wr_val[1] = 1'b1;
               web = 1'b0;
            end
            
            if (aw_valid && !c_wr_val[0]) begin
               aw_ready = 1'b1;
               c_wr_val[0] = 1'b1;
               c_wr_data = aw_data;
               c_wr_addr = aw_addr;
               c_wr_bwe = aw_bwe;
            end
         end 

         
         always_ff@(posedge wclk) begin
            r_wr_data <= c_wr_data;
            r_wr_addr <= c_wr_addr;
            r_wr_bwe <= c_wr_bwe;
         end
         

      end 
      else begin: no_wr_flop
         
         always_comb begin
            c_wr_val = r_wr_val;
            
            web = 1'b1;
            aw_ready = 1'b0;
            if (r_wr_val[0] && b_ready) begin
               c_wr_val = 1'b0;
            end

            if (aw_valid && !c_wr_val[0]) begin
               web = 1'b0;
               aw_ready = 1'b1;
               c_wr_val = 1'b1;
            end
         end 

      end
   endgenerate

   always_ff@(posedge wclk or negedge rst_wclk_n) begin
      if (!rst_wclk_n) begin
         r_wr_val <= '0;
      end
      else begin
         r_wr_val <= c_wr_val;
      end
   end

   nx_srfram #(.WIDTH(WIDTH),
               .DEPTH(DEPTH),
               .SPECIALIZE(SPECIALIZE),
               .LATCH(LATCH)) nx_srfram
     (.rst_n (rst_rclk_n),
      .*);
                           
endmodule : nx_srfram_channelized








