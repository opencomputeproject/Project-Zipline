/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













module cr_xp10_decomp_lz77_if (
   
   lz_mtf_dp_ready, if_ep_sym, if_ep_sym_valid, lane_lit_stb, ptr_stb,
   frm_in_stb, frm_out_stb, lz77_stall_stb,
   
   clk, rst_n, mtf_lz_dp_bus, mtf_lz_dp_valid, ep_if_entry_done,
   sw_LZ_BYPASS_CONFIG, ep_if_load_trace_bit, ep_if_trace_bit
   );
   import crPKG::lz_symbol_bus_t;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   input                   clk;
   input                   rst_n;
   
   input lz_symbol_bus_t   mtf_lz_dp_bus;
   input                   mtf_lz_dp_valid;
   output logic            lz_mtf_dp_ready;

   input                   ep_if_entry_done;

   output sym_t            if_ep_sym;
   output                  if_ep_sym_valid;
   input                   sw_LZ_BYPASS_CONFIG;

   output logic [3:0]      lane_lit_stb;
   output logic            ptr_stb;
   output logic            frm_in_stb;
   input                   ep_if_load_trace_bit;
   input                   ep_if_trace_bit;
   output logic            frm_out_stb;
   output logic            lz77_stall_stb;
   
   lz77_t                  sym[4];
   logic                   sym_valid;
   logic                   eof;
   logic [31:0]            eof_err_code;
   
   lz_symbol_bus_t        if_wr_data;
   lz_symbol_bus_t        if_rd_data;
   logic                  if_wr;
   logic                  if_rd;
   logic [7:0]            lane_data[4];
   logic [4:0]            sym_val;
   logic [1:0]            ptr_lane;
   logic                  if_empty;
   logic [5:0]            if_used;

   logic                  ptr_valid;
   
   logic                  empty[4];
   sym_t                  rd_data[4];
   sym_t                  wr_data[4];
   logic                  wr[4];
   logic                  rd[4];
   logic [4:0]            free_slots[4];
   logic                  space_avail;

   logic [1:0]            fifo_i;
   logic [1:0]            cur_index;
   logic                  p_valid;
   logic [2:0]            lit_cnt;
   logic [31:0]           lit_data;
   logic                  ptr_i;
   logic [1:0]            rd_idx;
   logic                  read_fifo;
   logic                  fifo_avail;
   logic                  frame_ready;
   logic                  valid_rdy;
   logic                  r_trace_bit;
   logic                  saved_trace_bit;
   logic                  eob;

   logic                  int_ptr_stb;
   logic                  int_frm_in_stb;
   logic                  int_frame_ready;
   logic                  int_frm_out_stb;
   logic [3:0]            int_lane_lit_stb;   
   assign valid_rdy = mtf_lz_dp_valid;
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         if_wr <= 0;
         if_wr_data.backref <= 0;
         if_wr_data.backref_lane <= 0;
         if_wr_data.backref_type <= 0;
         if_wr_data.data0 <= 0;
         if_wr_data.data1 <= 0;
         if_wr_data.data2 <= 0;
         if_wr_data.data3 <= 0;
         if_wr_data.framing <= 0;
         if_wr_data.length <= 0;
         if_wr_data.offset_msb <= 0;
         
      end
      else begin
         if (valid_rdy) begin
            if_wr_data.framing <= mtf_lz_dp_bus.framing;
            if_wr_data.data0 <= mtf_lz_dp_bus.data0;
            if_wr_data.data1 <= mtf_lz_dp_bus.data1;
            if_wr_data.data2 <= mtf_lz_dp_bus.data2;
            if_wr_data.data3 <= mtf_lz_dp_bus.data3;
            if_wr_data.offset_msb <= mtf_lz_dp_bus.offset_msb;
            if_wr_data.length <= mtf_lz_dp_bus.length;
            if (sw_LZ_BYPASS_CONFIG) begin
               if_wr_data.backref <= 1'b0;
               if_wr_data.backref_type <= 1'b0;
               if_wr_data.backref_lane <= 2'b0;
            end
            else begin
               if_wr_data.backref <= mtf_lz_dp_bus.backref;
               if_wr_data.backref_type <= mtf_lz_dp_bus.backref_type;
               if_wr_data.backref_lane <= mtf_lz_dp_bus.backref_lane;
            end 
            if_wr <= valid_rdy;
         end
         else begin
            if_wr <= 1'b0;
         end
      end
   end

   
   assign lz_mtf_dp_ready = (if_used > 6'h1c) ? 1'b0 : 1'b1;
   assign space_avail = (free_slots[0] > 5'd1) &&
                        (free_slots[1] > 5'd1) &&
                        (free_slots[2] > 5'd1) &&
                        (free_slots[3] > 5'd1);
   
                        
   always_comb
     begin
        if (!if_empty && space_avail)
          if_rd = 1'b1;
        else
          if_rd = 1'b0;
        
        case (if_rd_data.framing)
          4'b0000 : sym_val = 5'b00000;
          4'b0001 : sym_val = 5'b00001;
          4'b0010 : sym_val = 5'b00011;
          4'b0011 : sym_val = 5'b00111;
          4'b0100 : sym_val = 5'b01111;
          4'b1000 : sym_val = 5'b10000;
          4'b1111 : sym_val = 5'b10001;
          default : sym_val = 5'b00000;
        endcase 

        ptr_lane = if_rd_data.backref_lane;
        lane_data[0] = if_rd_data.data0;
        lane_data[1] = if_rd_data.data1;
        lane_data[2] = if_rd_data.data2;
        lane_data[3] = if_rd_data.data3;
     end 
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         sym[0] <= '0;
         sym[1] <= '0;
         sym[2] <= '0;
         sym[3] <= '0;
         eof <= 0;
         eof_err_code <= 0;
         sym_valid <= 0;
         ptr_valid <= 0;
         cur_index <= 2'b0;
         eob <= 1'b0;
      end
      else begin
         cur_index <= fifo_i;
         if (if_rd) begin
            ptr_valid <= if_rd_data.backref;
            if ((if_rd_data.framing > 4'b0000) &&
                (if_rd_data.framing <= 4'b0100))
              sym_valid <= 1'b1;
            else
              sym_valid <= 1'b0;
            if (sym_val < 5'b10000) begin
               for (int i=0; i < 4; i=i+1) begin
                  if (sym_val[i]) begin
                     if ((if_rd_data.backref) && (ptr_lane == i)) begin
                        sym[i].ptr_valid <= 1'b1;
                        sym[i].ptr_offset <= {if_rd_data.offset_msb, 
                                              lane_data[i]};
                        sym[i].ptr_length <= if_rd_data.length;
                        sym[i].lit_valid <= 1'b0;
                        sym[i].lit_data <= '0;
                     end
                     else begin
                        sym[i].lit_valid <= 1'b1;
                        sym[i].lit_data <= lane_data[i];
                        sym[i].ptr_valid <= 1'b0;
                     end
                  end 
                  else begin
                     sym[i].lit_valid <= 1'b0;
                     sym[i].ptr_valid <= 1'b0;
                  end
               end 
            end
            else if (sym_val[4]) begin
               if (sym_val[0]) begin 
                  eof <= 1'b1;
                  eob <= 1'b0;
                  eof_err_code <= {lane_data[3],lane_data[2],
                                   lane_data[1],lane_data[0]};
               end
               else begin
                  eof <= 1'b0;
                  eob <= 1'b1;
               end
            end
            else begin
               eof <= 1'b0;
               eob <= 1'b0;
               eof_err_code <= '0;
            end
         end 
         else begin
            sym_valid <= 1'b0;
            eof <= 1'b0;
            eob <= 1'b0;
            eof_err_code <= '0;
            ptr_valid <= 1'b0;
         end
      end 
   end 

   always_comb
     begin
        fifo_i = cur_index;
        wr[0] = 1'b0;
        wr[1] = 1'b0;
        wr[2] = 1'b0;
        wr[3] = 1'b0;
        wr_data[0] = '0;
        wr_data[1] = '0;
        wr_data[2] = '0;
        wr_data[3] = '0;
        ptr_i = 0;
        
        p_valid = 1'b0;
        lit_cnt = 3'b0;
        lit_data = '0;
        
        if (sym_valid) begin
           
           for (int j=0; j < 4; j++) begin
              if (sym[j].lit_valid && !p_valid) begin
                 lit_data[lit_cnt*8+:8] = sym[j].lit_data; 
                 lit_cnt++;
              end
              else if (sym[j].ptr_valid) begin
                 p_valid = 1'b1;
              end
           end
           if (lit_cnt > 0) begin
              wr_data[fifo_i].lit_valid = 1'b1;
              wr_data[fifo_i].ptr_valid = 1'b0;
              wr_data[fifo_i].eof_valid = 1'b0;
              wr_data[fifo_i].eob_valid = 1'b0;
              wr_data[fifo_i].lit_cnt = lit_cnt;
              wr_data[fifo_i].data = lit_data;
              wr[fifo_i] = 1'b1;
              fifo_i++;
           end
           if (p_valid) begin
              ptr_i = 0;
              lit_cnt = '0;
              for (int j=0; j < 4; j++) begin
                 if (sym[j].ptr_valid) begin
                    wr[fifo_i] = 1'b1;
                    wr_data[fifo_i].lit_valid = 1'b0;
                    wr_data[fifo_i].ptr_valid = 1'b1;
                    wr_data[fifo_i].eof_valid = 1'b0;
                    wr_data[fifo_i].eob_valid = 1'b0;
                    wr_data[fifo_i].lit_cnt = '0;
                    wr_data[fifo_i].data = {sym[j].ptr_offset, sym[j].ptr_length};
                    fifo_i++;
                    ptr_i = 1'b1;
                 end
                 if (ptr_i) begin
                    if (sym[j].lit_valid) begin
                       lit_data[lit_cnt*8+:8] = sym[j].lit_data; 
                       lit_cnt++;
                    end
                 end
              end
              if (lit_cnt > 0) begin
                 wr_data[fifo_i].lit_cnt = lit_cnt;
                 wr_data[fifo_i].data = lit_data;
                 wr_data[fifo_i].lit_valid = 1'b1;
                 wr_data[fifo_i].ptr_valid = 1'b0;
                 wr_data[fifo_i].eof_valid = 1'b0;
                 wr_data[fifo_i].eob_valid = 1'b0;
                 wr[fifo_i] = 1'b1;
                 fifo_i++;
              end
           end 
        end 
        else begin
           if (eof == 1'b1) begin
              wr_data[fifo_i].lit_valid = 1'b0;
              wr_data[fifo_i].ptr_valid = 1'b0;
              wr_data[fifo_i].eof_valid = 1'b1;
              wr_data[fifo_i].eob_valid = 1'b0;
              wr_data[fifo_i].lit_cnt = '0;
              wr_data[fifo_i].data = eof_err_code;
              wr[fifo_i] = 1'b1;
              fifo_i++;
           end
           else if (eob == 1'b1) begin
              wr_data[fifo_i].eob_valid = 1'b1;
              wr_data[fifo_i].lit_valid = 1'b0;
              wr_data[fifo_i].ptr_valid = 1'b0;
              wr_data[fifo_i].eof_valid = 1'b0;
              wr_data[fifo_i].lit_cnt = '0;
              wr_data[fifo_i].data = eof_err_code;
              wr[fifo_i] = 1'b1;
              fifo_i++;
           end
        end 
     end 

   nx_fifo #(.DEPTH (32), .WIDTH ($bits(lz_symbol_bus_t)))
   if_fifo (.empty (if_empty),
            .full (),
            .used_slots (if_used),
            .free_slots (),
            .rdata (if_rd_data),
            .clk (clk),
            .rst_n (rst_n),
            .wen (if_wr),
            .ren (if_rd),
            .clear (1'b0),
            .underflow (),
            .overflow (),
            .wdata (if_wr_data));

   genvar ii;
   generate
      for (ii=0; ii < 4; ii=ii+1)
        begin : fifo_loop
           nx_fifo #(.DEPTH (16), .WIDTH ($bits(sym_t)))
           fifo_inst (.empty (empty[ii]),
                   .full (),
                   .used_slots (),
                   .free_slots (free_slots[ii]),
                   .rdata (rd_data[ii]),
                   .clk (clk),
                   .rst_n (rst_n),
                   .wen (wr[ii]),
                   .ren (rd[ii]),
                   .clear (1'b0),
                   .underflow (),
                   .overflow (),
                   .wdata (wr_data[ii]));
        end 
      endgenerate
   assign fifo_avail = !empty[0] || !empty[1] || !empty[2] || !empty[3];
   
   always_comb
     begin
        rd[0] = 1'b0;
        rd[1] = 1'b0;
        rd[2] = 1'b0;
        rd[3] = 1'b0;
        read_fifo = 1'b0;
        if (ep_if_entry_done && fifo_avail) begin
           rd[rd_idx] = 1'b1;
           read_fifo = 1'b1;
        end
     end

   assign if_ep_sym = rd_data[rd_idx];
   assign if_ep_sym_valid = rd[rd_idx];
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         rd_idx <= 0;
         
      end
      else begin
         if (read_fifo)
           rd_idx <= rd_idx +1;
      end
   end

   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         for (int jj=0; jj < 4; jj++) begin
            lane_lit_stb[jj] <= 0;
         end
         frame_ready <= 1'b1;
         frm_in_stb <= 0;
         frm_out_stb <= 0;
         lz77_stall_stb <= 0;
         ptr_stb <= 0;
         r_trace_bit <= 0;
         saved_trace_bit <= 0;
      end
      else begin
         lane_lit_stb[0] <= int_lane_lit_stb[0];
         lane_lit_stb[1] <= int_lane_lit_stb[1];
         lane_lit_stb[2] <= int_lane_lit_stb[2];
         lane_lit_stb[3] <= int_lane_lit_stb[3];

         if (ep_if_load_trace_bit) begin
            saved_trace_bit <= ep_if_trace_bit;
         end
         
         if (frame_ready && ep_if_load_trace_bit)
           r_trace_bit <= ep_if_trace_bit;
         else if (frame_ready)
           r_trace_bit <= saved_trace_bit;

         if (!lz_mtf_dp_ready && r_trace_bit)
           lz77_stall_stb <= 1'b1;
         else
           lz77_stall_stb <= 1'b0;

         frm_in_stb <= int_frm_in_stb;

         if (int_frame_ready)
           frame_ready <= 1'b1;
         else if (int_frm_in_stb)
           frame_ready <= 1'b0;
         
         frm_out_stb <= int_frm_out_stb;

         ptr_stb <= int_ptr_stb;

      end 
   end 

   always_comb
     begin
        int_ptr_stb = 1'b0;
        int_frm_in_stb = 1'b0;
        int_frame_ready = 1'b0;
        int_frm_out_stb = 1'b0;
        int_lane_lit_stb[0] = 1'b0;
        int_lane_lit_stb[1] = 1'b0;
        int_lane_lit_stb[2] = 1'b0;
        int_lane_lit_stb[3] = 1'b0;
        for (int kk=0; kk < 4; kk++) begin
           if (rd[kk] == 1'b1) begin
              if (rd_data[kk].lit_valid && r_trace_bit)
                case (rd_data[kk].lit_cnt)
                  3'b100: begin
                     int_lane_lit_stb[3] = 1'b1;
                  end
                  3'b011 : begin
                     int_lane_lit_stb[2] = 1'b1;
                  end
                  3'b010: begin
                     int_lane_lit_stb[1] = 1'b1;
                  end
                  3'b001 : begin
                     int_lane_lit_stb[0] = 1'b1;
                  end
                  default : begin
                     int_lane_lit_stb[0] = 1'b0;
                     int_lane_lit_stb[1] = 1'b0;
                     int_lane_lit_stb[2] = 1'b0;
                     int_lane_lit_stb[3] = 1'b0;
                  end
                endcase 
           end 
           
           if (rd[kk] && rd_data[kk].ptr_valid && r_trace_bit && !int_ptr_stb)
             int_ptr_stb = 1'b1;
           
           if (frame_ready && rd[kk] && r_trace_bit && !int_frm_in_stb)
             int_frm_in_stb = 1'b1;

           if (rd[kk] && rd_data[kk].eof_valid && !int_frame_ready)
             int_frame_ready = 1'b1;
           
           if (rd[kk] && rd_data[kk].eof_valid && r_trace_bit && !int_frm_out_stb)
             int_frm_out_stb = 1'b1;
        end 
     end 

   
   genvar k;
   for (k=0; k < 4; k++) begin
      `COVER_PROPERTY(if_wr_data.backref && (if_wr_data.backref_lane == k) && (if_wr_data.framing == 4'b0001));
      `COVER_PROPERTY(if_wr_data.backref && (if_wr_data.backref_lane == k) && (if_wr_data.framing == 4'b0010));
      `COVER_PROPERTY(if_wr_data.backref && (if_wr_data.backref_lane == k) && (if_wr_data.framing == 4'b0011));
      `COVER_PROPERTY(if_wr_data.backref && (if_wr_data.backref_lane == k) && (if_wr_data.framing == 4'b0100));
      `COVER_PROPERTY(!if_wr_data.backref && (if_wr_data.framing == 4'b0001));
      `COVER_PROPERTY(!if_wr_data.backref && (if_wr_data.framing == 4'b0010));
      `COVER_PROPERTY(!if_wr_data.backref && (if_wr_data.framing == 4'b0011));
      `COVER_PROPERTY(!if_wr_data.backref && (if_wr_data.framing == 4'b0100));
   end
   
      
   
endmodule 






