/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


























module cr_xp10_decomp_lz77_do (
   
   do_bm_pause, lz_be_dp_valid, lz_be_dp_bus, do_ag_hb_wdata,
   do_ag_hb_wr,
   
   clk, rst_n, bm_do_odd_word, bm_do_odd_valid, bm_do_odd_type,
   bm_do_odd_bytes_valid, bm_do_even_word, bm_do_even_valid,
   bm_do_even_type, bm_do_even_bytes_valid, be_lz_dp_ready
   );

   import cr_xp10_decompPKG::*;
   
   input                   clk;
   input                   rst_n;

   input [63:0]            bm_do_odd_word;
   input                   bm_do_odd_valid;
   input [1:0]             bm_do_odd_type;
   input [2:0]             bm_do_odd_bytes_valid;
   
   input [63:0]            bm_do_even_word;
   input                   bm_do_even_valid;
   input [1:0]             bm_do_even_type;
   input [2:0]             bm_do_even_bytes_valid;

   output logic            do_bm_pause;
   output logic            lz_be_dp_valid;
   
   output                  lz_be_dp_bus_t lz_be_dp_bus;
   input                   be_lz_dp_ready;

   output logic [127:0]    do_ag_hb_wdata;
   output logic            do_ag_hb_wr;
   
   logic                   odd_sent;
   logic                   fifos_ready;

   logic                   odd_rd;
   logic                   even_rd;
   logic [68:0]            out_data;
   logic                   hb_rd;
   logic                   hb_empty;
   logic [63:0]            hb_rd_data;
   logic [63:0]            hb_wr_data;
   logic                   hb_wr;
   logic                   odd_wr;
   logic [68:0]            odd_wdata;
   logic [68:0]            odd_rdata;
   logic                   even_wr;
   logic [68:0]            even_wdata;
   logic [68:0]            even_rdata;
   logic                   odd_empty;
   logic                   even_empty;
   logic [4:0]             odd_used;
   logic [4:0]             even_used;
   logic                   rd_valid;
   logic [68:0]            rd_data;
   logic                   odd_eof;
   logic                   ag_hb_wr;
   logic                   sent_eob;
   logic [3:0]             bytes_shift;
   
   
   
   assign fifos_ready = (odd_used < 5'b01100) && (even_used < 5'b01100);
   
   always_comb
     begin
        lz_be_dp_bus = '0;
        if (lz_be_dp_valid) begin
           lz_be_dp_bus.data = out_data[63:0];
           lz_be_dp_bus.data_type = out_data[65:64];
           case (out_data[68:66])
             3'b000 : lz_be_dp_bus.bytes_valid = 8'b1111_1111;
             3'b001 : lz_be_dp_bus.bytes_valid = 8'b0000_0001;
             3'b010 : lz_be_dp_bus.bytes_valid = 8'b0000_0011;
             3'b011 : lz_be_dp_bus.bytes_valid = 8'b0000_0111;
             3'b100 : lz_be_dp_bus.bytes_valid = 8'b0000_1111;
             3'b101 : lz_be_dp_bus.bytes_valid = 8'b0001_1111;
             3'b110 : lz_be_dp_bus.bytes_valid = 8'b0011_1111;
             3'b111 : lz_be_dp_bus.bytes_valid = 8'b0111_1111;
             default : lz_be_dp_bus.bytes_valid = 8'b0;
           endcase 
        end 
     end
   
   assign odd_eof = (bm_do_odd_valid && ((bm_do_odd_type == 2'b10) ||
                                         (bm_do_odd_type == 2'b11))) ? 
                    1'b1 : 1'b0;
   assign do_ag_hb_wr = ag_hb_wr && !odd_eof;
   
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         ag_hb_wr <= 0;
         do_ag_hb_wdata <= 0;
         do_bm_pause <= 0;
         
      end
      else begin
         do_bm_pause <= !be_lz_dp_ready || !fifos_ready;

         if (bm_do_even_valid && (bm_do_even_type == 2'b01)) begin
            if (!hb_empty && !odd_eof) begin
               do_ag_hb_wdata <= {bm_do_even_word, hb_rd_data};
               ag_hb_wr <= 1'b1;
            end
            else if (bm_do_odd_valid && !odd_eof) begin
               do_ag_hb_wdata <= {bm_do_even_word, bm_do_odd_word};
               ag_hb_wr <= 1'b1;
            end
            else begin
               ag_hb_wr <= 1'b0;
               
            end
         end 
         else begin
            ag_hb_wr <= 1'b0;
            do_ag_hb_wdata <= '0;
         end
      end 
   end 
   
   always_comb
     begin
        hb_wr_data = '0;
        hb_wr = 1'b0;
        if (bm_do_odd_valid && (bm_do_odd_type == 2'b01)) begin
           if (!hb_empty || !bm_do_even_valid) begin
              hb_wr_data = bm_do_odd_word;
              hb_wr = 1'b1;
           end
        end
        
        if (bm_do_even_valid && !hb_empty && (bm_do_even_type != 2'b00))
          hb_rd = 1'b1;
        else
          hb_rd = 1'b0;
        
        odd_wr = bm_do_odd_valid;
        odd_wdata = {bm_do_odd_bytes_valid, bm_do_odd_type, bm_do_odd_word};
        even_wr = bm_do_even_valid;
        even_wdata = {bm_do_even_bytes_valid, bm_do_even_type, bm_do_even_word};
        odd_rd = 1'b0;
        even_rd = 1'b0;
        if (!odd_sent && !odd_empty && be_lz_dp_ready)
          odd_rd = 1'b1;
        else if (odd_sent && !even_empty && be_lz_dp_ready)
          even_rd = 1'b1;
     end
   
   nx_fifo #(.DEPTH (2), .WIDTH (64))
   hb_fifo (.empty (hb_empty),
            .full (),
            .used_slots (),
            .free_slots (),
            .rdata (hb_rd_data),
            .clk (clk),
            .rst_n (rst_n),
            .wen (hb_wr),
            .ren (hb_rd),
            .clear (1'b0),
            .underflow (),
            .overflow (),
            .wdata (hb_wr_data));

   assign rd_valid = odd_rd || even_rd;
   assign rd_data = (odd_rd) ? odd_rdata : even_rdata;
   
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         bytes_shift <= 0;
         lz_be_dp_valid <= 0;
         odd_sent <= 0;
         out_data <= 0;
         sent_eob <= 0;
         
      end
      else begin
         if (odd_rd || even_rd) begin
            if ((rd_data[68:66] == 3'b000) && (rd_data[65:64] == 2'b00))
              lz_be_dp_valid <= 1'b0;
            else
              lz_be_dp_valid <= 1'b1;
         end
         else
           lz_be_dp_valid <= 1'b0;
         

         if (rd_valid && ((rd_data[65:64] == 2'b10) ||
                          (rd_data[65:64] == 2'b11))) begin
            odd_sent <= 1'b0;
         end
         else begin
            if (odd_rd && (odd_rdata[65:64] != 2'b00))
              odd_sent <= 1'b1;
            else if (even_rd && (even_rdata[65:64] != 2'b00))
              odd_sent <= 1'b0;
         end

         if (sent_eob) begin
            out_data[63:0] <= rd_data[63:0] >> bytes_shift*8;
            out_data[65:64] <= rd_data[65:64];
            out_data[68:66] <= {1'b1, rd_data[68:66]} - bytes_shift; 
         end
         else
           out_data <= rd_data;
         
         if ((odd_rd || even_rd) && rd_data[65:64] == 2'b00 &&
             (rd_data[68:66] != 3'b000)) begin
            sent_eob <= 1'b1;
            bytes_shift <= {1'b0, rd_data[68:66]};
         end
         else if ((odd_rd || even_rd) && rd_data[65:64] != 2'b00) begin
            sent_eob <= 1'b0;
            bytes_shift <= '0;
         end
             
      end 
   end 
   
   
   nx_fifo #(.DEPTH (16), .WIDTH (69))
   outfifo_odd (.empty (odd_empty),
                .full (),
                .used_slots (odd_used),
                .free_slots (),
                .rdata (odd_rdata),
                .clk (clk),
                .rst_n (rst_n),
                .wen (odd_wr),
                .ren (odd_rd),
                .clear (1'b0),
                .underflow (),
                .overflow (),
                .wdata (odd_wdata));
   

   nx_fifo #(.DEPTH (16), .WIDTH (69))
   outfifo_even (.empty (even_empty),
                 .full (),
                 .used_slots (even_used),
                 .free_slots (),
                 .rdata (even_rdata),
                 .clk (clk),
                 .rst_n (rst_n),
                 .wen (even_wr),
                 .ren (even_rd),
                 .clear (1'b0),
                 .underflow (),
                 .overflow (),
                 .wdata (even_wdata));
   
endmodule 






