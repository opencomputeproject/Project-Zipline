/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



















`include "ccx_std.vh"
module cr_fifo_wrap3
  
  (
  
  full, afull, rdata, empty, aempty, overflow,
  
  clk, rst_n, wdata, wen, ren
  );
  
  
  
  
  parameter  N_DATA_BITS=64; 
  parameter  N_ENTRIES=8;    
  parameter  N_AFULL_VAL=1;  
  parameter  N_AEMPTY_VAL=1; 
  
    
  
  
  
  
`include "cr_structs.sv"
  
  
  
  input                       clk;
  input                       rst_n;
  
  
  
  
  input [N_DATA_BITS-1:0]     wdata;
  input                       wen;
  output                      full; 
  output                      afull; 
 
  
  
  
  output [N_DATA_BITS-1:0]    rdata;
  input                       ren;
  output                      empty; 
  output                      aempty; 

  
  
  
  output                      overflow;
  

  logic                       afull_r;
  logic                       aempty_r;
  
  
  
  logic [`LOG_VEC(N_ENTRIES+1)] free_slots;     
  logic                 underflow;              
  logic [`LOG_VEC(N_ENTRIES+1)] used_slots;     
  

  if(N_ENTRIES == 0) begin: entries_0
    assign full = 0;
    assign afull = 0;
    assign aempty = 1;
    assign empty = 1;

    assign rdata = wdata;
    
  end
  else begin : entires_gt0
    assign afull = afull_r;
    assign aempty = aempty_r;
    
    
    always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
        afull_r <= 1'b0;
        aempty_r <= 1'b1;
      end
      else begin
        if((free_slots <= N_AFULL_VAL) | ((free_slots == N_AFULL_VAL + 1) & wen & ~ren)) begin
         afull_r <= 1'b1;
        end
        else begin
          afull_r <= 1'b0;
        end
        if((used_slots <= N_AEMPTY_VAL) | ((used_slots == N_AEMPTY_VAL + 1) & ~wen & ren)) begin
          aempty_r <= 1'b1;
        end
        else begin
          aempty_r <= 1'b0;
        end
      end 
    end 
  
    
    
    
    
  
    nx_fifo # 
      (
       
       .WIDTH            (N_DATA_BITS),
       .DEPTH            (N_ENTRIES),
       .DATA_RESET       (1),
       .UNDERFLOW_ASSERT (1),
       .OVERFLOW_ASSERT  (1)
       )
    u_nx_fifo                         
      (
       
       .empty                           (empty),
       .full                            (full),
       .underflow                       (underflow),
       .overflow                        (overflow),
       .used_slots                      (used_slots[`LOG_VEC(N_ENTRIES+1)]),
       .free_slots                      (free_slots[`LOG_VEC(N_ENTRIES+1)]),
       .rdata                           (rdata[N_DATA_BITS-1:0]),
       
       .clk                             (clk),
       .rst_n                           (rst_n),
       .wen                             (wen),
       .ren                             (ren),
       .clear                           (1'b0),                  
       .wdata                           (wdata[N_DATA_BITS-1:0]));
  end 
  
endmodule








