/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
module cr_xp10_decomp_fe_data_aligner (
   
   align_rdata, align_rd, align_pre_eof, align_afull,
   
   clk, rst_n, align_wdata, align_wr, align_offset, align_ack,
   align_clear
   );

   import crPKG::*;
   import cr_xp10_decompPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   
   input                      clk;
   input                      rst_n;
   input fe_dp_bus_t          align_wdata;
   input                      align_wr;
   input [$clog2(`AXI_S_DP_DWIDTH)-1:0] align_offset;

   output fe_dp_bus_t         align_rdata;
   output logic               align_rd;
   output logic               align_pre_eof;
   output logic               align_afull;
   
   input                      align_ack;
   
   input                      align_clear;
   
   logic                      fifo_rd;
   logic                      fifo_empty;
   logic [3:0]                fifo_used;
   logic                      tgl;
   fe_dp_bus_t                cur_data;
   fe_dp_bus_t                prev_data;
   fe_dp_bus_t                fifo_rdata;
   logic                      r_fifo_rd;
   logic                      r_align_rd;
   
   logic                      r_eof;

   logic                      r_eob;
   logic [2:0]                new_bytes_valid;

   logic [6:0]                prev_bits_valid;
   logic [6:0]                cur_bits_valid;
   logic [2:0]                eof_bytes_valid;
   
   assign fifo_rd = (!fifo_empty) && align_ack && !align_clear;
   assign align_afull = (fifo_used > 4'b0101) ? 1'b1 : 1'b0;
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         r_align_rd <= 0;
         r_eob <= 0;
         r_eof <= 0;
         r_fifo_rd <= 0;
         
      end
      else begin
         r_align_rd <= align_rd;
         if (fifo_rd)
           r_fifo_rd <= fifo_rd;
         
         if (align_clear) begin
            r_eof <= 1'b0;
            r_eob <= 1'b0;
         end
         else if (fifo_rd) begin
            r_eof <= fifo_rdata.eof;
            r_eob <= fifo_rdata.eob;
         end
      end 
   end 

   always_comb
     begin

        cur_bits_valid = (cur_data.bytes_valid == 3'b000) ? 7'd64 :    
                         (cur_data.bytes_valid * 8);                   
        prev_bits_valid = (prev_data.bytes_valid == 3'b000) ? 7'd64 :   
                         (prev_data.bytes_valid * 8);                 
        new_bytes_valid = '0;
        
        if (prev_data.bytes_valid == 3'b000) begin
           if (cur_data.bytes_valid == 3'b000)
             new_bytes_valid = 3'b0;
           else if (cur_bits_valid >= align_offset)   
             new_bytes_valid = 3'b0;
           else
             new_bytes_valid = (7 + (64 - align_offset) + cur_bits_valid)/8;   
        end

        eof_bytes_valid = (7 + (prev_bits_valid - align_offset))/8; 
     end 
   
                                   
   always_comb
     begin
        if ((fifo_rd && ((align_offset == 0)))) begin
           align_rdata.data = align_data({`AXI_S_DP_DWIDTH{1'b0}},
                                         fifo_rdata.data,
                                         align_offset);
           align_rd = 1'b1;
           align_rdata.eof = fifo_rdata.eof;
           align_rdata.eob = fifo_rdata.eob;
           align_rdata.sof = fifo_rdata.sof;
           align_rdata.bytes_valid = fifo_rdata.bytes_valid;
           align_pre_eof = fifo_rdata.eof;
        end
        else if (fifo_rd && tgl) begin
           align_rdata.data = align_data(cur_data.data,
                                         prev_data.data,
                                         align_offset);
           align_rd = 1'b1;
           if ((new_bytes_valid != 0) ||
               ((new_bytes_valid == 0) && ({1'b0, align_offset} >= cur_bits_valid)))
             align_rdata.eof = cur_data.eof;
           else
             align_rdata.eof = prev_data.eof;
           align_pre_eof = cur_data.eof;
           align_rdata.eob = 1'b0;
           align_rdata.sof = prev_data.sof;
           align_rdata.bytes_valid = new_bytes_valid;
        end
        else if ((r_eof || r_eob) && r_fifo_rd && (align_offset !=0) && 
                 align_ack && !align_clear) begin
           align_rdata.data = align_data({`AXI_S_DP_DWIDTH{1'b0}},
                                          prev_data.data,
                                          align_offset);
           align_rdata.eof = r_eof;
           align_rdata.eob = r_eob;
           align_rdata.sof = prev_data.sof;
           align_pre_eof = r_eof;
           align_rdata.bytes_valid = eof_bytes_valid;
           align_rd = 1'b1;
        end
        else begin
           align_rd = 1'b0;
           align_rdata = '0;
           align_rdata.eof = 1'b0;
           align_rdata.eob = 1'b0;
           align_rdata.sof = 1'b0;
           align_pre_eof = 1'b0;
           align_rdata.bytes_valid = '0;
        end 
     end 
   

   assign cur_data = fifo_rdata;
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         prev_data <= 0;
         tgl <= 0;
         
      end
      else begin
         if (align_clear)
           tgl <= 1'b0;
         else if (fifo_rd) begin
            tgl <= 1'b1;
         end
         if (align_clear)
           prev_data <= '0;
         else if (fifo_rd)
           prev_data <= cur_data;
      end
   end 

   nx_fifo #(.DEPTH (8), .WIDTH ($bits(fe_dp_bus_t)))
   if_fifo (.empty (fifo_empty),
            .full (),
            .used_slots (fifo_used),
            .free_slots (),
            .rdata (fifo_rdata),
            .clk (clk),
            .rst_n (rst_n),
            .wen (align_wr),
            .ren (fifo_rd),
            .clear (align_clear),
            .underflow (),
            .overflow (),
            .wdata (align_wdata));
   
   
endmodule 







