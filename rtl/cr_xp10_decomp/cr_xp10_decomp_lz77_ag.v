/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
module cr_xp10_decomp_lz77_ag (
   
   ag_ep_head_moved, ag_ep_hb_wr, ag_hb_wr, ag_hb_waddr, ag_hb_wdata,
   ag_hb_rd, ag_hb_raddr, ag_bm_hb_data, ag_hb_eof, ag_pl_eof,
   lz_hb_tail_ptr, lz_hb_head_ptr,
   
   clk, rst_n, ep_ag_hb_rd, ep_ag_hb_1st_rd, ep_ag_hb_num_words,
   do_ag_hb_wr, do_ag_hb_wdata, hb_ag_rdata, ep_ag_eof,
   pl_ag_load_tail, pl_ag_tail_ptr
   );

   input                   clk;
   input                   rst_n;
   
   input                   ep_ag_hb_rd;
   input                   ep_ag_hb_1st_rd;
   input [11:0]            ep_ag_hb_num_words;

   input                   do_ag_hb_wr;
   input [127:0]           do_ag_hb_wdata;
   
   output  logic           ag_ep_head_moved;
   
   output logic            ag_ep_hb_wr;
   output logic            ag_hb_wr;
   output logic [11:0]     ag_hb_waddr;
   output logic [127:0]    ag_hb_wdata;
   
   output logic            ag_hb_rd;
   output logic [11:0]     ag_hb_raddr;
   input [127:0]           hb_ag_rdata;
   
   output logic [127:0]    ag_bm_hb_data; 
   input                   ep_ag_eof;
   output logic            ag_hb_eof;
   output logic            ag_pl_eof;

   input                   pl_ag_load_tail;
   input [12:0]            pl_ag_tail_ptr;

   output logic [11:0]     lz_hb_tail_ptr;
   output logic [11:0]     lz_hb_head_ptr;
   
   logic [11:0]            tail_ptr;
   logic [11:0]            head_ptr;
   
   logic [11:0]            base_addr;
   logic [11:0]            curr_addr;
   logic [11:0]            prev_addr;
   logic [12:0]            window_sz;
   logic                   r_ep_ag_eof;
   logic                   rr_ep_ag_eof;
   
   
   assign ag_hb_rd = ep_ag_hb_rd;
   assign ag_hb_raddr = curr_addr;
   assign ag_bm_hb_data = hb_ag_rdata;

   assign ag_hb_wr = do_ag_hb_wr && !ep_ag_eof && !r_ep_ag_eof && !rr_ep_ag_eof;
   assign ag_ep_hb_wr = ag_hb_wr;
   assign ag_hb_wdata = do_ag_hb_wdata;
   assign ag_hb_waddr = tail_ptr;

   assign ag_hb_eof = rr_ep_ag_eof;
   assign ag_pl_eof = ag_hb_eof;
   
   
   
   always_comb
     begin
        base_addr = '0;
        if (ep_ag_hb_rd) begin
           if (ep_ag_hb_1st_rd) begin

 
                 base_addr = (tail_ptr - ep_ag_hb_num_words); 

   
     
       
           end
        end 
     end 

   
   
   
   always_comb
     begin
        curr_addr = '0;
        if (ep_ag_hb_1st_rd) begin
           curr_addr = base_addr;
        end
        else if (ag_hb_rd) begin
           curr_addr = prev_addr + 1;
        end
     end

   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         prev_addr <= 12'h0;
         r_ep_ag_eof <= 1'h0;
         rr_ep_ag_eof <= 1'h0;
         
      end
      else begin
         if (ag_hb_rd)
           prev_addr <= curr_addr;
         r_ep_ag_eof <= ep_ag_eof;
         rr_ep_ag_eof <= r_ep_ag_eof;
         
      end
   end 

   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         tail_ptr <= 12'h0;
         
      end
      else begin
         if (ep_ag_eof)
           tail_ptr <= '0;
         else if (pl_ag_load_tail)
           tail_ptr <= pl_ag_tail_ptr[11:0];
         else if (ag_ep_hb_wr) begin
            tail_ptr <= tail_ptr +1;
         end
      end
   end

   assign ag_ep_head_moved = ((window_sz == `LZ77_MAX_WINDOW_SZ) &&
                              ag_ep_hb_wr) ||
                             (pl_ag_load_tail && pl_ag_tail_ptr[12]) ? 
                             1'b1 : 1'b0;
   
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         head_ptr <= 12'h0;
         window_sz <= 13'h0;
         
      end
      else begin
         if (ep_ag_eof) 
           window_sz <= '0;
         else begin
            if (window_sz < `LZ77_MAX_WINDOW_SZ) begin
               if ((tail_ptr == 12'hfff) && ag_ep_hb_wr)
                 window_sz <= 13'h1000;
               else if (ag_ep_hb_wr)
                 window_sz <= (tail_ptr - head_ptr) +1;
               else if (pl_ag_load_tail && pl_ag_tail_ptr[12])
                 window_sz <= 13'h1000;
            end
         end
         if (ep_ag_eof) begin
            head_ptr <= '0;
         end
         else if ((window_sz == `LZ77_MAX_WINDOW_SZ) && ag_ep_hb_wr) begin
            head_ptr <= head_ptr +1;
         end
      end
   end 

   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         lz_hb_head_ptr <= 12'h0;
         lz_hb_tail_ptr <= 12'h0;
         
      end
      else begin
         lz_hb_tail_ptr <= tail_ptr;
         lz_hb_head_ptr <= head_ptr;
      end
   end
   
endmodule 
