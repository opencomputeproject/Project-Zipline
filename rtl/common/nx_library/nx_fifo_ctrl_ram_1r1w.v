/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/








`include "messages.vh"
`include "ccx_std.vh"
module nx_fifo_ctrl_ram_1r1w(
   
   mem_wen, mem_waddr, mem_wdata, mem_ren, mem_raddr, empty, full,
   used_slots, free_slots, rerr, rdata, underflow, overflow,
   
   clk, rst_n, mem_rdata, mem_ecc_error, wen, wdata, ren, clear
   );

   
   parameter DEPTH = 256;
   parameter WIDTH = 55;
   parameter UNDERFLOW_ASSERT = 1; 
   parameter OVERFLOW_ASSERT = 1; 
   parameter RD_LATENCY = 1;

   
   
   
   
   
   
   parameter REN_COMB = 1; 

   
   
   
   
   parameter RDATA_COMB = 1;

   localparam PREFETCH_DEPTH = RD_LATENCY+2-REN_COMB-RDATA_COMB;
   localparam TOTAL_DEPTH = DEPTH+PREFETCH_DEPTH;

   input     clk;
   input     rst_n;

   
   input [`BIT_VEC(WIDTH)]  mem_rdata;
   input                    mem_ecc_error;
   
   output logic                   mem_wen;
   output logic [`LOG_VEC(DEPTH)] mem_waddr;
   output logic [`BIT_VEC(WIDTH)] mem_wdata;
   output logic                   mem_ren;
   output logic [`LOG_VEC(DEPTH)] mem_raddr;
   
   
   input                    wen;
   input [`BIT_VEC(WIDTH)]  wdata;
   input                    ren;
   input                    clear;
   
   output logic             empty;
   output logic             full;
   output logic [`LOG_VEC(TOTAL_DEPTH+1)] used_slots; 
   output logic [`LOG_VEC(TOTAL_DEPTH+1)] free_slots; 
   output logic                                    rerr;
   output logic [WIDTH-1:0]                        rdata;

   output logic                                    underflow;
   output logic                                    overflow;
   
   
   
   
`define DECLARE_FLOP(name) r_``name, c_``name
`define DEFAULT_FLOP(name) c_``name = r_``name
`define UPDATE_FLOP(name) r_``name <= c_``name

   logic [`LOG_VEC(TOTAL_DEPTH+1)]  `DECLARE_FLOP(used_slots);
   logic [`LOG_VEC(TOTAL_DEPTH+1)]  `DECLARE_FLOP(free_slots);
   assign used_slots = r_used_slots;
   assign free_slots = r_free_slots;
   
   
   logic [`BIT_VEC(RD_LATENCY)]              `DECLARE_FLOP(mem_ren_dly);
   logic [`BIT_VEC(PREFETCH_DEPTH)]          `DECLARE_FLOP(mem_prefetch_wptr_dly[`BIT_VEC(RD_LATENCY)]); 
   
   logic [`LOG_VEC(DEPTH)]                   `DECLARE_FLOP(mem_wptr);
   logic [`LOG_VEC(DEPTH)]                   `DECLARE_FLOP(mem_rptr);
   logic                                     `DECLARE_FLOP(mem_empty);
   logic                                     `DECLARE_FLOP(mem_full);
   
   assign mem_waddr = r_mem_wptr;
   assign mem_raddr = r_mem_rptr;
   assign mem_wdata = wdata;
   

   logic [`BIT_VEC(PREFETCH_DEPTH)]          `DECLARE_FLOP(prefetch_wptr); 
   logic [`LOG_VEC(PREFETCH_DEPTH)]          `DECLARE_FLOP(prefetch_rptr);
   logic [`LOG_VEC(PREFETCH_DEPTH+1)]        `DECLARE_FLOP(prefetch_depth);
   logic                                     `DECLARE_FLOP(prefetch_empty);
   logic                                     `DECLARE_FLOP(prefetch_full);

   logic [`BIT_VEC(WIDTH+1)]                   `DECLARE_FLOP(prefetch_data[`BIT_VEC(PREFETCH_DEPTH)]);

   
   logic                                     prefetch_wen;
   logic [`BIT_VEC(PREFETCH_DEPTH)]          prefetch_lden_bypass;
   logic [`BIT_VEC(PREFETCH_DEPTH)]          prefetch_lden_mem;
   
   assign         empty = r_prefetch_empty;
   assign          full = r_mem_full;
   
   always_comb begin
      logic v_prefetch_full;

      c_mem_wptr = r_mem_wptr;
      c_mem_rptr = r_mem_rptr;
      c_mem_empty = r_mem_empty;
      c_mem_full = r_mem_full;

      c_prefetch_wptr = r_prefetch_wptr;
      c_prefetch_rptr = r_prefetch_rptr;
      c_prefetch_depth = r_prefetch_depth;
      c_prefetch_empty = r_prefetch_empty;
      c_prefetch_full = r_prefetch_full;

      c_used_slots = r_used_slots;
      c_free_slots = r_free_slots;

      prefetch_wen = 1'b0;
      prefetch_lden_bypass = '0;
      prefetch_lden_mem = '0;

      
      underflow = 0;
      if (ren) begin
         c_prefetch_full = 1'b0;
         if (!empty) begin
            c_used_slots = r_used_slots - 1;
            c_free_slots = r_free_slots + 1;
            c_prefetch_depth = r_prefetch_depth - 1;
            if (r_prefetch_rptr == (PREFETCH_DEPTH-1))
              c_prefetch_rptr = '0;
            else
              c_prefetch_rptr = r_prefetch_rptr + 1;
            
            if (r_prefetch_depth == 1)
              c_prefetch_empty = 1'b1;
         end 
         else begin
            underflow = 1;
            FIFO_UNDERFLOW: assert #0 (!UNDERFLOW_ASSERT) else `ERROR("fifo underflow");
         end
      end

      if (REN_COMB)  
        v_prefetch_full = c_prefetch_full;
      else
        v_prefetch_full = r_prefetch_full;

      
      
      mem_ren = 1'b0;
      if (!v_prefetch_full && !r_mem_empty) begin
         mem_ren = 1'b1;
         if (r_mem_rptr==(DEPTH-1))
           c_mem_rptr = '0;
         else
           c_mem_rptr = r_mem_rptr+1;
         c_mem_full = 1'b0;
         if (c_mem_rptr == r_mem_wptr)
           c_mem_empty = 1'b1;

         prefetch_wen = 1'b1;
      end 
      
      

      if (r_mem_ren_dly[RD_LATENCY-1])
        prefetch_lden_mem = r_mem_prefetch_wptr_dly[RD_LATENCY-1];

      c_mem_ren_dly = RD_LATENCY'(r_mem_ren_dly << 1) | RD_LATENCY'(mem_ren);
      
      overflow = 0;
      mem_wen = 1'b0;
      if (wen) begin
         if (!r_mem_full) begin
            if (r_mem_empty && !v_prefetch_full) begin
               
               
               prefetch_lden_bypass = r_prefetch_wptr;
               prefetch_wen = 1'b1;
            end
            else begin
               mem_wen = 1'b1;
               if (r_mem_wptr==(DEPTH-1))
                 c_mem_wptr = '0;
               else
                 c_mem_wptr = r_mem_wptr+1;
               c_mem_empty = 1'b0;
               if (c_mem_wptr == c_mem_rptr)
                 c_mem_full = 1'b1;
            end 
            if (ren && !empty) begin
               c_used_slots = r_used_slots;
               c_free_slots = r_free_slots;
            end
            else begin
               c_used_slots = r_used_slots+1;
               c_free_slots = r_free_slots-1;
            end
         end 
         else begin
            overflow = 1;
            FIFO_OVERFLOW: assert #0 (!OVERFLOW_ASSERT) else `ERROR("fifo overflow");
         end 
      end 
      
      if (prefetch_wen) begin
         
         c_prefetch_wptr = PREFETCH_DEPTH'(r_prefetch_wptr << 1) | PREFETCH_DEPTH'(r_prefetch_wptr[PREFETCH_DEPTH-1]);
         c_prefetch_empty = 1'b0;
         if (ren && !empty) begin
            c_prefetch_depth = r_prefetch_depth;
            c_prefetch_full = r_prefetch_full;
         end
         else begin
            if (r_prefetch_depth == (PREFETCH_DEPTH-1))
              c_prefetch_full = 1'b1;
            c_prefetch_depth = r_prefetch_depth + 1;
         end
      end

      c_mem_prefetch_wptr_dly[0] = r_prefetch_wptr;
      for (int ii=1; ii<RD_LATENCY; ii++)
        c_mem_prefetch_wptr_dly[ii] = r_mem_prefetch_wptr_dly[ii-1];
      
      if ((RDATA_COMB!=0) && prefetch_lden_mem[r_prefetch_rptr]) begin 
         {rerr, rdata} = {mem_ecc_error, mem_rdata};
         if (ren)
           prefetch_lden_mem = '0;
      end
      else
        {rerr, rdata} = r_prefetch_data[r_prefetch_rptr]; 
         

         
      c_prefetch_data = r_prefetch_data;
      for (int ii=0; ii<PREFETCH_DEPTH; ii++) begin
         if (prefetch_lden_bypass[ii] || prefetch_lden_mem[ii])
           c_prefetch_data[ii] = ({(WIDTH+1){prefetch_lden_bypass[ii]}} & {1'b0, wdata}) |
                                 ({(WIDTH+1){prefetch_lden_mem[ii]}} & {mem_ecc_error, mem_rdata});
      end      

      if (clear) begin
         c_mem_empty = 1'b1;
         c_prefetch_empty = 1'b1;
         c_prefetch_wptr = PREFETCH_DEPTH'(1);
         c_mem_ren_dly = '0;
         c_used_slots = '0;
         c_free_slots = TOTAL_DEPTH;
         c_mem_full = 1'b0;
         c_mem_rptr = '0;
         c_mem_wptr = '0;
         c_prefetch_depth = '0;
         c_prefetch_full = 1'b0;
         c_prefetch_rptr = '0;
      end
   end

   `ASSERT_PROPERTY($onehot(r_prefetch_wptr)) else `ERROR("r_prefetch_wptr NOT one-hot");

   always@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         r_mem_empty <= 1'b1;
         r_prefetch_empty <= 1'b1;
         r_prefetch_wptr <= PREFETCH_DEPTH'(1);
         r_free_slots <= TOTAL_DEPTH;
         
         
         r_mem_full <= 1'h0;
         r_mem_ren_dly <= 1'h0;
         r_mem_rptr <= 1'h0;
         r_mem_wptr <= 1'h0;
         r_prefetch_depth <= 1'h0;
         r_prefetch_full <= 1'h0;
         r_prefetch_rptr <= 1'h0;
         r_used_slots <= 1'h0;
         
      end
      else begin
         r_mem_ren_dly <= c_mem_ren_dly;

         r_mem_empty <= c_mem_empty;
         r_mem_full <= c_mem_full;
         r_mem_wptr <= c_mem_wptr;
         r_mem_rptr <= c_mem_rptr;

         r_prefetch_empty <= c_prefetch_empty;
         r_prefetch_full <= c_prefetch_full;
         r_prefetch_wptr <= c_prefetch_wptr;
         r_prefetch_rptr <= c_prefetch_rptr;
         r_prefetch_depth <= c_prefetch_depth;

         r_used_slots <= c_used_slots;
         r_free_slots <= c_free_slots;
      end
   end

   
   always@(posedge clk) begin
      r_mem_prefetch_wptr_dly <= c_mem_prefetch_wptr_dly;
      r_prefetch_data <= c_prefetch_data;
   end
   

`undef DECLARE_FLOP
`undef DEFAULT_FLOP
`undef UPDATE_FLOP

endmodule 





