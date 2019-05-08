/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "messages.vh"
module cr_huf_comp_sm_fifo (
   
   empty, full, underflow, overflow, used_slots, free_slots, rdata, rdata_nxt,
   
   clk, rst_n, wen, ren, clear, wdata
   );


   
   parameter DEPTH = 6;
   parameter WIDTH = 55;
   parameter DATA_RESET = 0;
   parameter UNDERFLOW_ASSERT = 1;
   parameter OVERFLOW_ASSERT = 1;

   input     clk;
   input     rst_n;

   
   input     wen;
   input     ren;
   input     clear;
   input [WIDTH-1:0] wdata;

   output            empty;
   output            full;

   output logic      underflow;
   output logic      overflow;
   
   output [`LOG_VEC(DEPTH+1)] used_slots; 
   output [`LOG_VEC(DEPTH+1)] free_slots; 

   output [WIDTH-1:0]         rdata;
   output [WIDTH-1:0]         rdata_nxt;

   generate
      if (DEPTH==1) begin: depth_1
         reg c_full;
         reg r_full;
         reg [WIDTH-1:0] c_data;
         reg [WIDTH-1:0] r_data;
         reg [WIDTH-1:0] r_data_nxt;

         assign full = r_full;
         assign empty = !r_full;
         assign used_slots = r_full;
         assign free_slots = !r_full;
         assign rdata = r_data;
	 assign rdata_nxt = r_data_nxt;

         always_comb begin
            c_full = r_full;
            c_data = r_data;

            if (ren) begin
               if (empty) begin
                  underflow = 1;
                  FIFO_UNDERFLOW: assert #0 (!UNDERFLOW_ASSERT) else `ERROR("fifo underflow");
               end
               c_full = 1'b0;
            end
            
            if (wen) begin
               if (!c_full) begin
                  c_full = 1'b1;
                  c_data = wdata;
               end
               else begin
                  overflow = 1;
                  FIFO_OVERFLOW: assert #0 (!OVERFLOW_ASSERT) else `ERROR("fifo overflow");
               end
            end
         end 

         always@(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
               
               
               r_full <= 1'h0;
               
            end
            else begin
               r_full <= c_full;
            end
         end

         if (DATA_RESET==1) begin
            always@(posedge clk or negedge rst_n) begin
               if (!rst_n) begin
                  
                  
                  
                  r_data <= {WIDTH{1'b0}};
                  
                  
               end
               else begin
                  r_data <= c_data;
               end 
            end 
         end
         else begin
            always@(posedge clk) begin
               r_data <= c_data; 
            end 
         end 

      end
      else begin: depth_n

         wire [`LOG_VEC(DEPTH)] rptr;
         reg [`LOG_VEC(DEPTH)] 	rptr_nxt;
         wire [`LOG_VEC(DEPTH)] wptr;
	 
	 always_comb begin
	    if (rptr == DEPTH-1)
	      rptr_nxt = 0;
	    else
	      rptr_nxt = rptr+1;
	 end
	 
         reg [WIDTH-1:0]      r_data[DEPTH-1:0];

         nx_fifo_ctrl 
           #(
             
             .DEPTH                     (DEPTH),
             .OVERFLOW_ASSERT           (OVERFLOW_ASSERT),
             .UNDERFLOW_ASSERT          (UNDERFLOW_ASSERT))
         fifo_ctrl
           (
            
            .empty                      (empty),
            .full                       (full),
            .used_slots                 (used_slots[`LOG_VEC(DEPTH+1)]),
            .free_slots                 (free_slots[`LOG_VEC(DEPTH+1)]),
            .rptr                       (rptr[`LOG_VEC(DEPTH)]),
            .wptr                       (wptr[`LOG_VEC(DEPTH)]),
            .underflow                  (underflow),
            .overflow                   (overflow),
            
            .clk                        (clk),
            .rst_n                      (rst_n),
            .wen                        (wen),
            .ren                        (ren),
            .clear                      (clear));

         assign rdata     = r_data[rptr];   
         assign rdata_nxt = r_data[rptr_nxt]; 

         if (DATA_RESET==1) begin
            always@(posedge clk or negedge rst_n) begin
               if (!rst_n) begin
                  for (int i=0; i<DEPTH; i++)
                    r_data[i] <= {WIDTH{1'b0}}; 
               end
               else begin
                  if (wen && !full)
		    
		    
                    r_data[wptr] <= wdata; 
               end
            end
         end 
         else begin
            always@(posedge clk) begin
               if (wen && !full)
                 r_data[wptr] <= wdata; 
            end
         end 
      end 
   endgenerate

endmodule 




