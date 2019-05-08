/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/






















`include "messages.vh"
`include "ccx_std.vh"
module nx_event_interrupt
  #(parameter 
    N_ADDR_BITS=16,       
    N_INT_BITS=16)        
   (input logic                         clk,
    input logic                         rst_n,
    input logic [`BIT_VEC(N_ADDR_BITS)] reg_addr,
    input logic                         rd_stb,
    input logic                         wr_stb,
    input logic [`BIT_VEC(N_INT_BITS)]  int_stb,
    input logic [`BIT_VEC(N_INT_BITS)]  int_data_in,
    output logic [`BIT_VEC(N_INT_BITS)] int_data_out,
    output logic                        int_ack,
    output logic                        int_out);
   
   logic [`BIT_VEC(N_INT_BITS)]         int_raw_reg;
   logic [`BIT_VEC(N_INT_BITS)]         int_mask_reg;

   
   
   localparam INT_RAW    = 2'h0;
   localparam INT_STAT   = 2'h1;
   localparam INT_MASK   = 2'h2;
   

 
   wire [`BIT_VEC(N_ADDR_BITS)] rw_id        =  reg_addr;
   
   wire                         selected     = (reg_addr <= INT_MASK);
   wire                         wr_stb_valid = (wr_stb && selected);
   
   wire [`BIT_VEC(N_INT_BITS)]  wr1tc_valid  =  {N_INT_BITS{wr_stb_valid & (rw_id == INT_RAW)}} & int_data_in;
   
   assign int_ack = rd_stb | wr_stb;
   
   
`ifndef SYNTHESIS
   initial begin : parameter_check

      assert(N_INT_BITS > 0) else
        `ERROR("Number of interrupt bits must be greater than zero");
      
   end : parameter_check
`endif

   always @(*)
     case (rw_id)
       INT_RAW:  int_data_out = int_raw_reg;
       INT_STAT: int_data_out = int_raw_reg & int_mask_reg;
       INT_MASK: int_data_out = int_mask_reg;
       default:  int_data_out = int_mask_reg;
     endcase
      
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         int_raw_reg   <= 0;
         int_mask_reg  <= 0;
         int_out       <= 0;
      end
      else begin
         int_out <= |(int_mask_reg & int_raw_reg);
         
         if (wr_stb_valid && (rw_id == INT_MASK))
           int_mask_reg <= int_data_in;
         
         for (int i=0; i<N_INT_BITS; i++) begin
            if (int_stb[i])
              int_raw_reg[i] <= 1;
            else if (wr1tc_valid[i])
              int_raw_reg[i] <= 0;
         end
      end 
   end
   

   
endmodule 






