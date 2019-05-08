/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
module cr_xp10_decomp_be_frm_chk (
   
   size_error, crc_error,
   
   clk, rst_n, lfa_be_crc_bus, lfa_be_crc_valid, lz_be_dp_bus,
   lz_be_dp_valid
   );

   import crPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;

   input                  clk;
   input                  rst_n;
   input lfa_be_crc_bus_t lfa_be_crc_bus;
   input                  lfa_be_crc_valid;

   input lz_be_dp_bus_t   lz_be_dp_bus;
   input                  lz_be_dp_valid;

   output logic           size_error;
   output logic           crc_error;

   lz_be_dp_bus_t         r_lz_bus;
   logic                  r_lz_valid;

   logic                  fifo_rd;
   lfa_be_crc_bus_t       fifo_rdata;
   logic [31:0]           r_fifo_rdata;
   logic [3:0]            fifo_used; 
   logic                  fifo_empty;

   logic [31:0]           frm_bcnt;
   logic [3:0]            bcnt;

   logic                  check_isize;
   logic                  check_c4k;
   logic                  check_c8k;
   
   logic                  check_crc_32;
   logic                  check_crc_64;
   logic                  check_adler;
   logic                  check_gzip_crc_32;
   
   logic [31:0]           crc_32_out;
   logic [63:0]           crc_64_out;
   logic [31:0]           gzip_crc_32_out;
   logic [31:0]           crc_32_in;
   logic [31:0]           gzip_crc_32_in;
   logic [63:0]           crc_64_in;
   logic [6:0]            crc_bits_valid;
   logic [7:0]            crc_bytes_valid;
   logic [7:0]            r_crc_bytes_valid;
   logic [31:0]           tmp_32_out;
   logic [31:0]           gzip_tmp_32_out;
   logic [63:0]           tmp_64_out;
   logic [63:0]           crc_data;
   logic                  crc_sof;
   logic                  got_eop;

   logic [31:0]           nxt_adler32;
   logic [31:0]           r_nxt_adler32;

   logic                  r_check_adler;
   logic                  crc_crc_error;
   logic                  adler_crc_error;
   
    `CCX_STD_DECLARE_CRC(crc32, 32'h82f63b78, 32, 64) 
    `CCX_STD_DECLARE_CRC(gzip_crc32, 32'hedb88320, 32, 64) 
    `CCX_STD_DECLARE_CRC(crc64, 64'h9a6c9329ac4bc9b5, 64, 64) 
   
   
   assign tmp_32_out = crc32(crc_data, crc_32_in, crc_bits_valid);
   assign crc_32_in = (crc_sof) ? 32'hffff_ffff : crc_32_out;
   
   assign gzip_tmp_32_out = gzip_crc32(crc_data, gzip_crc_32_in, crc_bits_valid);
   assign gzip_crc_32_in = (crc_sof) ? 32'hffff_ffff : gzip_crc_32_out;
   
   assign tmp_64_out = crc64(crc_data, crc_64_in, crc_bits_valid);
   assign crc_64_in = (crc_sof) ? 64'hffff_ffff_ffff_ffff : crc_64_out;   

   assign crc_bits_valid = bcnt * 8;
   assign crc_bytes_valid = (r_lz_bus.data_type == 2'b01) ? 
                            r_lz_bus.bytes_valid : '0;

   cr_adler adler_inst (.clk (clk),
                        .rst_n (rst_n),
                        .sof (crc_sof),
                        .data_in (crc_data),
                        .bytes_valid (crc_bytes_valid),
                        .adler_out (nxt_adler32));
   
   always_comb
     begin
        if (r_lz_valid) begin
           case (r_lz_bus.bytes_valid)
             8'b00000001 : bcnt = 4'h1;
             8'b00000011 : bcnt = 4'h2;
             8'b00000111 : bcnt = 4'h3;
             8'b00001111 : bcnt = 4'h4;
             8'b00011111 : bcnt = 4'h5;
             8'b00111111 : bcnt = 4'h6;
             8'b01111111 : bcnt = 4'h7;
             8'b11111111 : bcnt = 4'h8;
             default : bcnt = 4'b0;
           endcase 
        end 
        else begin
           bcnt = 4'b0;
        end 

        check_isize = 1'b0;
        check_c4k = 1'b0;
        check_c8k = 1'b0;
        check_adler = 1'b0;
        check_crc_32 = 1'b0;
        check_crc_64 = 1'b0;
        check_gzip_crc_32 = 1'b0;
        
        if (fifo_rd) begin
           case (fifo_rdata.crc_frm_fmt)
             3'b000 : begin 
                check_isize = 1'b1;
             end
             3'b001 : begin 
                check_crc_32 = 1'b1;
             end
             3'b010 : begin 
                check_crc_64 = 1'b1;
             end
             3'b011 : begin 
                check_adler = 1'b1;
             end
             3'b100 : begin 
                check_isize = 1'b1;
                check_gzip_crc_32 = 1'b1;
             end
             3'b110 : begin 
                check_c4k = 1'b1;
                check_crc_32 = 1'b0;
                check_crc_64 = 1'b0;
             end
             3'b111 : begin 
                check_c8k = 1'b1;
                check_crc_32 = 1'b0;
                check_crc_64 = 1'b0;
             end
             default : begin
                check_isize = 1'b0;
                check_c4k = 1'b0;
                check_c8k = 1'b0;
                check_crc_32 = 1'b0;
                check_crc_64 = 1'b0;
             end
           endcase 
        end 
     end 
   
   assign crc_data = r_lz_bus.data;
   assign fifo_rd = (r_lz_valid && (r_lz_bus.data_type != 2'b01) &&
                     !fifo_empty) ? 1'b1 : 1'b0;

   always_comb
     begin
        adler_crc_error = 1'b0;
        if (r_check_adler) begin
           if (r_fifo_rdata != reverse_bytes(r_nxt_adler32))
             adler_crc_error = 1'b1;
           else
             adler_crc_error = 1'b0;
        end
     end

   assign crc_error = (r_check_adler) ? adler_crc_error : crc_crc_error;
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         got_eop <= 1'b1;
         
         
         crc_32_out <= 0;
         crc_64_out <= 0;
         crc_sof <= 0;
         frm_bcnt <= 0;
         gzip_crc_32_out <= 0;
         r_check_adler <= 0;
         r_crc_bytes_valid <= 0;
         r_fifo_rdata <= 0;
         r_lz_bus <= 0;
         r_lz_valid <= 0;
         r_nxt_adler32 <= 0;
         
      end
      else begin
         if (r_lz_valid) begin
            crc_32_out <= tmp_32_out;
            crc_64_out <= tmp_64_out;
            gzip_crc_32_out <= gzip_tmp_32_out;
         end
         if (lz_be_dp_valid) begin
            crc_sof <= got_eop;
            got_eop <= (lz_be_dp_bus.data_type != 2'b01) ? 1'b1 : 1'b0;
         end
         
         r_lz_valid <= lz_be_dp_valid;
         r_lz_bus <= lz_be_dp_bus;
         if (r_lz_valid) begin
            if (r_lz_bus.data_type != 2'b01) begin
               frm_bcnt <= '0;
            end
            else begin
               frm_bcnt <= frm_bcnt + bcnt; 
            end
         end
         r_check_adler <= check_adler;
         r_fifo_rdata <= fifo_rdata.data[31:0];
         r_crc_bytes_valid <= crc_bytes_valid;
         if (r_crc_bytes_valid != 0)
           r_nxt_adler32 <= nxt_adler32;
         
      end 
   end 


   
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         crc_crc_error <= 0;
         size_error <= 0;
         
      end
      else begin
         if (check_isize) begin
            if (frm_bcnt != fifo_rdata.isize)
              size_error <= 1'b1;
            else
              size_error <= 1'b0;
         end
         else if (check_c4k) begin
            if (frm_bcnt > 13'd4096)
              size_error <= 1'b1;
            else
              size_error <= 1'b0;
         end
         else if (check_c8k) begin
            if (frm_bcnt > 14'd8192)
              size_error <= 1'b1;
            else
              size_error <= 1'b0;
         end
         else begin
            size_error <= 1'b0;
         end
         
         if (check_crc_32) begin
            if (fifo_rdata.data[31:0] != ~crc_32_in)
              crc_crc_error <= 1'b1;
            
            else
              crc_crc_error <= 1'b0;
         end
         else if (check_gzip_crc_32) begin
            if (fifo_rdata.data[31:0] != ~gzip_crc_32_in)
              crc_crc_error <= 1'b1;
            else
              crc_crc_error <= 1'b0;
         end
         else if (check_crc_64) begin
            if (fifo_rdata.data != ~crc_64_in)
              crc_crc_error <= 1'b1;
            else
              crc_crc_error <= 1'b0;
         end
         else begin
            crc_crc_error <= 1'b0;
         end
      end
   end
   
   
    
   nx_fifo #(.DEPTH (8), .WIDTH ($bits(lfa_be_crc_bus_t)))
   usr_fifo (.empty (fifo_empty),
            .full (),
            .used_slots (fifo_used),
            .free_slots (),
            .rdata (fifo_rdata),
            .clk (clk),
            .rst_n (rst_n),
            .wen (lfa_be_crc_valid),
            .ren (fifo_rd),
            .clear (1'b0),
            .underflow (),
            .overflow (),
            .wdata (lfa_be_crc_bus));

   function logic [31:0] reverse_bytes;
      input [31:0] in_crc;
      logic [31:0] out_crc;
      begin
         out_crc[31:24] = in_crc[7:0];
         out_crc[23:16] = in_crc[15:8];
         out_crc[15:8] = in_crc[23:16];
         out_crc[7:0] = in_crc[31:24];
         reverse_bytes = out_crc;
      end
   endfunction 
   
endmodule 








