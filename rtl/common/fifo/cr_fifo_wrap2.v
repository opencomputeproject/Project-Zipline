/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/






























`include "ccx_std.vh"
module cr_fifo_wrap2
  
  (
  
  full, afull, rdata, empty, aempty, bimc_odat, bimc_osync,
  ro_uncorrectable_ecc_error,
  
  clk, rst_n, wdata, wen, ren, bimc_idat, bimc_isync, bimc_rst_n
  );
 
  
  
  
  parameter  N_DATA_BITS=64; 
  parameter  N_ENTRIES=8;    
  parameter  N_AFULL_VAL=1;  
  parameter  N_AEMPTY_VAL=1; 
  parameter  USE_RAM=0;      
  
    
  
  
  
  
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
  
  
  
  
  input  logic                bimc_idat;             
  input  logic                bimc_isync;            
  input  logic                bimc_rst_n;            

  output logic                bimc_odat;            
  output logic                bimc_osync;           
  output logic                ro_uncorrectable_ecc_error;

  logic                       afull_r;
  logic                       aempty_r;
  
  localparam IN_FLOP    = 1;
  localparam OUT_FLOP   = 1;  
  localparam RD_LATENCY =1;
  localparam REN_COMB   = 1;
  localparam RDATA_COMB = 1;
  localparam PREFETCH_DEPTH = RD_LATENCY+IN_FLOP+OUT_FLOP+2-REN_COMB-RDATA_COMB;
  
  
  logic [`LOG_VEC(N_ENTRIES+1)] free_slots;     
  logic                 overflow;               
  logic                 rerr;                   
  logic                 underflow;              
  logic [`LOG_VEC(N_ENTRIES+1)] used_slots;     
  
  if(N_ENTRIES == 0) begin: aflags_entries_0
    assign afull = 0;
    assign aempty = 1;
  end
  else begin: aflags_entries_gt0
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
  end 
  
  if(N_ENTRIES == 0) begin: entries_0
    assign full = 0;
    assign empty = 1;

    assign rdata = wdata;
    
    assign bimc_odat = bimc_idat;
    assign bimc_osync = bimc_isync;
    assign ro_uncorrectable_ecc_error = 0;
    
    
  end
  else if (USE_RAM) begin: ram_fifo

      
      
      
      
  
      nx_fifo_ram_1r1w # 
        (
         
       .WIDTH            (N_DATA_BITS),
       .DEPTH            (N_ENTRIES),
       .UNDERFLOW_ASSERT (1),
       .OVERFLOW_ASSERT  (1),
       .SPECIALIZE       (1),
       .IN_FLOP          (IN_FLOP),
       .OUT_FLOP         (OUT_FLOP),
       .RD_LATENCY       (RD_LATENCY)
        )
      u_nx_fifo_ram_1r1w                         
        (
         
         .empty                         (empty),
         .full                          (full),
         .used_slots                    (used_slots[`LOG_VEC(N_ENTRIES+PREFETCH_DEPTH+1)]),
         .free_slots                    (free_slots[`LOG_VEC(N_ENTRIES+PREFETCH_DEPTH+1)]),
         .rerr                          (rerr),
         .rdata                         (rdata[N_DATA_BITS-1:0]),
         .underflow                     (underflow),
         .overflow                      (overflow),
         .bimc_odat                     (bimc_odat),
         .bimc_osync                    (bimc_osync),
         .ro_uncorrectable_ecc_error    (ro_uncorrectable_ecc_error),
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .wen                           (wen),
         .wdata                         (wdata[`BIT_VEC(N_DATA_BITS)]),
         .ren                           (ren),
         .clear                         (1'b0),                  
         .bimc_idat                     (bimc_idat),
         .bimc_isync                    (bimc_isync),
         .bimc_rst_n                    (bimc_rst_n),
         .lvm                           (1'b0),                  
         .mlvm                          (1'b0),                  
         .mrdten                        (1'b0));                         
  end 
  
  else begin: reg_fifo
    
    assign bimc_odat = bimc_idat;
    assign bimc_osync = bimc_isync;
    assign ro_uncorrectable_ecc_error = 0;
    
    
    
    
  
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








