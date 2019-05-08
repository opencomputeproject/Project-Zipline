/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


























`include "ccx_std.vh"
module cr_cdc_fifo_wrap1
  
  (
   
   full, afull, rdata, empty, aempty,
   
   wclk, wrst_n, rclk, rrst_n, wdata, wen, ren
   );
   
   
   
   
   parameter  N_DATA_BITS=64; 
   parameter  N_ENTRIES=8;    
   parameter  N_AFULL_VAL=1;  
   parameter  N_AEMPTY_VAL=1; 
   parameter TYPE=0; 
   
   
   
   
   
   
`include "cr_structs.sv"
   
   
   
   input                       wclk;
   input                       wrst_n;
   input                       rclk;
   input                       rrst_n;
   
   
   
   
   input [N_DATA_BITS-1:0]     wdata;
   input                       wen;
   output                      full; 
   output                      afull; 
   
   
   
   
   output [N_DATA_BITS-1:0]    rdata;
   input                       ren;
   output                      empty; 
   output                      aempty; 

   logic                       afull_r;
   logic                       aempty_r;
   
   
   
   logic [`LOG_VEC(N_ENTRIES+1)] free_slots;    
   logic                overflow;               
   logic                underflow;              
   logic [`LOG_VEC(N_ENTRIES+1)] used_slots;    
   

   if(N_ENTRIES == 0) begin: entries_0
      assign full = 0;
      assign afull = 0;
      assign aempty = 1;
      assign empty = 1;

      assign rdata = wdata;
      
   end
   else begin : entires_gt0
      assign afull = free_slots <= N_AFULL_VAL;
      assign aempty = used_slots <= N_AEMPTY_VAL;
   
   
   
   
   
   nx_cdc_fifo # 
     (
      
      .WIDTH            (N_DATA_BITS),
      .DEPTH            (N_ENTRIES),
      .TYPE             (TYPE),
      .UNDERFLOW_ASSERT (1),
      .OVERFLOW_ASSERT  (1)
      )
      u_nx_cdc_fifo                         
        (
         
         .free_slots                       (free_slots[`LOG_VEC(N_ENTRIES+1)]),
         .full                             (full),
         .overflow                         (overflow),
         .rdata                            (rdata[`BIT_VEC(N_DATA_BITS)]),
         .empty                            (empty),
         .used_slots                       (used_slots[`LOG_VEC(N_ENTRIES+1)]),
         .underflow                        (underflow),
         
         .wclk                             (wclk),
         .wrst_n                           (wrst_n),
         .rclk                             (rclk),
         .rrst_n                           (rrst_n),
         .wen                              (wen),
         .wdata                            (wdata[`BIT_VEC(N_DATA_BITS)]),
         .ren                              (ren));
end 
   
endmodule








