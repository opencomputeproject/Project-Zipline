/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "messages.vh"
module cr_huf_comp_fifo(
   
   empty, full, used_slots, free_slots, rerr, rdata, underflow,
   overflow, bimc_odat, bimc_osync, ro_uncorrectable_ecc_error,
   
   clk, rst_n, wen, wdata, ren, clear, bimc_iclk, bimc_idat,
   bimc_isync, bimc_rst_n, lvm, mlvm, mrdten, ovstb
   );
   
   parameter DEPTH = 256;
   parameter WIDTH = 56;
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
   logic                   mem_ren;
   logic [`LOG_VEC(DEPTH)] mem_raddr;
   logic [`BIT_VEC(WIDTH)] mem_rdata;

   input logic          bimc_iclk;              
   input logic          bimc_idat;              
   input logic          bimc_isync;             
   input logic          bimc_rst_n;             
   input logic          lvm;                    
   input logic          mlvm;                   
   input logic          mrdten;                 
   input logic          ovstb;
   
   output logic         bimc_odat;              
   output logic         bimc_osync;             
   output logic         ro_uncorrectable_ecc_error;
   
   logic [1:0] 		bankd_sel_a, bankd_sel_b;
   logic [12:0] 	adda, addb;
   

   
   
   always_comb begin
      ro_uncorrectable_ecc_error = 0;
      
      bankd_sel_a                = mem_raddr/5120;
      adda                       = mem_raddr - (bankd_sel_a*5120); 
      bankd_sel_b                = mem_waddr/5120;
      addb                       = mem_waddr - (bankd_sel_b*5120); 
   end
     

   nx_ram_2rw 
     #(.WIDTH(75),
       .DEPTH(20480),
       .IN_FLOP(0),
       .OUT_FLOP(0),
       .RD_LATENCY(1),
       .SPECIALIZE(0))
   mem
     (
      
      .bimc_odat			(bimc_odat),
      .bimc_osync			(bimc_osync),
      .ro_uncorrectable_ecc_error	(),
      .douta				(mem_rdata),		
      .doutb				(),		        
      
      .clk				(clk),		
      .rst_n				(rst_n ),		 
      .ovstb				('0),
      .lvm				('0),
      .mlvm				('0),
      .mrdten				('0),
      .bimc_rst_n			(rst_n),		 
      .bimc_isync			(bimc_isync),
      .bimc_idat			(bimc_idat),
      .bwea				('0), 
      .dina				('0), 
      .adda				(mem_raddr),		 
      .csa				(mem_ren),		 
      .wea				(1'b0),			 
      .bweb				({75{1'b1}}),		 
      .dinb				(mem_wdata),		 
      .addb				(mem_waddr),		 
      .csb				(mem_wen),
      .web				(mem_wen));


   
   
   

   
   cr_huf_comp_fifo_ctrl
     #(.RD_LATENCY                      (RD_LATENCY+IN_FLOP+OUT_FLOP),
       
       
       .DEPTH				(DEPTH),
       .WIDTH				(WIDTH),
       .REN_COMB			(REN_COMB),
       .RDATA_COMB			(RDATA_COMB))
   fifo_ctrl
     (
      
      .mem_wen				(mem_wen),
      .mem_waddr			(mem_waddr[`LOG_VEC(DEPTH)]),
      .mem_wdata			(mem_wdata[`BIT_VEC(WIDTH)]),
      .mem_ren				(mem_ren),
      .mem_raddr			(mem_raddr[`LOG_VEC(DEPTH)]),
      .empty				(empty),
      .full				(full),
      .used_slots			(used_slots[`LOG_VEC(TOTAL_DEPTH+1)]),
      .free_slots			(free_slots[`LOG_VEC(TOTAL_DEPTH+1)]),
      .rerr				(rerr),
      .rdata				(rdata[WIDTH-1:0]),
      .underflow			(underflow),
      .overflow				(overflow),
      
      .clk				(clk),
      .rst_n				(rst_n),
      .mem_rdata			(mem_rdata[`BIT_VEC(WIDTH)]),
      .mem_ecc_error			(ro_uncorrectable_ecc_error), 
      .wen				(wen),
      .wdata				(wdata[`BIT_VEC(WIDTH)]),
      .ren				(ren),
      .clear				(clear));
   

endmodule 







