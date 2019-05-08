/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "messages.vh"
module nx_fifo_ram_1r1w(
   
   empty, full, used_slots, free_slots, rerr, rdata, underflow,
   overflow, bimc_odat, bimc_osync, ro_uncorrectable_ecc_error,
   
   clk, rst_n, wen, wdata, ren, clear, bimc_idat, bimc_isync,
   bimc_rst_n, lvm, mlvm, mrdten
   );
   
   parameter DEPTH = 256;
   parameter WIDTH = 55;
   parameter UNDERFLOW_ASSERT = 1;
   parameter OVERFLOW_ASSERT = 1;
   parameter SPECIALIZE = 0;
   parameter IN_FLOP = 0;
   parameter OUT_FLOP = 0;
   parameter RD_LATENCY = 1;

   
   
   
   
   
   
   parameter REN_COMB = 1; 

   
   
   
   
   parameter RDATA_COMB = 1;

   localparam PREFETCH_DEPTH = RD_LATENCY+IN_FLOP+OUT_FLOP+2-REN_COMB-RDATA_COMB;
   localparam TOTAL_DEPTH = DEPTH+PREFETCH_DEPTH;

   input     clk;
   input     rst_n;

   
   input                    wen;
   input [`BIT_VEC(WIDTH)]  wdata;
   input                    ren;
   input                    clear;
   
   output logic             empty;
   output logic             full;
   output logic [`LOG_VEC(DEPTH+PREFETCH_DEPTH+1)] used_slots; 
   output logic [`LOG_VEC(DEPTH+PREFETCH_DEPTH+1)] free_slots; 
   output logic                                    rerr;
   output logic [WIDTH-1:0]                        rdata;

   output logic                                    underflow;
   output logic                                    overflow;


   logic                   mem_wen;
   logic [`LOG_VEC(DEPTH)] mem_waddr;
   logic [`BIT_VEC(WIDTH)] mem_wdata;
   logic                   mem_ren, _mem_ren;
   logic [`LOG_VEC(DEPTH)] mem_raddr, _mem_raddr;
   logic [`BIT_VEC(WIDTH)] mem_rdata;

   input logic          bimc_idat;              
   input logic          bimc_isync;             
   input logic          bimc_rst_n;             
   input logic          lvm;                    
   input logic          mlvm;                   
   input logic          mrdten;                 

   output logic         bimc_odat;              
   output logic         bimc_osync;             
   output logic         ro_uncorrectable_ecc_error;

   
   
   
   
   generate
      if (IN_FLOP) begin
         always_ff@(posedge clk or negedge rst_n) begin
            if (!rst_n)
              _mem_ren <= 0;
            else
              _mem_ren <= mem_ren;
         end
         always_ff@(posedge clk)
           _mem_raddr <= mem_raddr; 
      end
      else begin
         assign _mem_ren = mem_ren;
         assign _mem_raddr = mem_raddr;
      end
   endgenerate

   

    nx_ram_1r1w
     #(.BWEWIDTH(WIDTH),
       
       
       .WIDTH                           (WIDTH),
       .DEPTH                           (DEPTH),
       .SPECIALIZE                      (SPECIALIZE),
       .IN_FLOP                         (IN_FLOP),
       .OUT_FLOP                        (OUT_FLOP),
       .RD_LATENCY                      (RD_LATENCY),
       .WRITETHROUGH                    (0))                     
   ram
     (
      
      .bimc_odat                        (bimc_odat),
      .bimc_osync                       (bimc_osync),
      .ro_uncorrectable_ecc_error       (ro_uncorrectable_ecc_error),
      .dout                             (mem_rdata),             
      
      .rst_n                            (rst_n),
      .clk                              (clk),
      .lvm                              (lvm),
      .mlvm                             (mlvm),
      .mrdten                           (mrdten),
      .bimc_rst_n                       (bimc_rst_n),
      .bimc_isync                       (bimc_isync),
      .bimc_idat                        (bimc_idat),
      .reb                              (!_mem_ren),             
      .ra                               (_mem_raddr),            
      .web                              (!mem_wen),              
      .wa                               (mem_waddr),             
      .din                              (mem_wdata),             
      .bwe                              ({WIDTH{1'b1}}));         

   
   nx_fifo_ctrl_ram_1r1w 
     #(.RD_LATENCY                      (RD_LATENCY+IN_FLOP+OUT_FLOP),
       
       
       .DEPTH                           (DEPTH),
       .WIDTH                           (WIDTH),
       .UNDERFLOW_ASSERT                (UNDERFLOW_ASSERT),
       .OVERFLOW_ASSERT                 (OVERFLOW_ASSERT),
       .REN_COMB                        (REN_COMB),
       .RDATA_COMB                      (RDATA_COMB))
   fifo_ctrl
     (
      
      .mem_wen                          (mem_wen),
      .mem_waddr                        (mem_waddr[`LOG_VEC(DEPTH)]),
      .mem_wdata                        (mem_wdata[`BIT_VEC(WIDTH)]),
      .mem_ren                          (mem_ren),
      .mem_raddr                        (mem_raddr[`LOG_VEC(DEPTH)]),
      .empty                            (empty),
      .full                             (full),
      .used_slots                       (used_slots[`LOG_VEC(TOTAL_DEPTH+1)]),
      .free_slots                       (free_slots[`LOG_VEC(TOTAL_DEPTH+1)]),
      .rerr                             (rerr),
      .rdata                            (rdata[WIDTH-1:0]),
      .underflow                        (underflow),
      .overflow                         (overflow),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .mem_rdata                        (mem_rdata[`BIT_VEC(WIDTH)]),
      .mem_ecc_error                    (ro_uncorrectable_ecc_error), 
      .wen                              (wen),
      .wdata                            (wdata[`BIT_VEC(WIDTH)]),
      .ren                              (ren),
      .clear                            (clear));
   

endmodule 
