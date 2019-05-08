/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

















module cr_xp10_decomp_be_fifos (
   
   be_fhp_dp_ready, be_lz_dp_ready, pt_ob_empty, pt_ob_aempty,
   pt_ob_tlv, lz_data_wr, lz_data_tlv,
   
   clk, rst_n, fhp_be_dp_valid, fhp_be_dp_bus, fhp_be_usr_data,
   fhp_be_usr_valid, lz_be_dp_valid, lz_be_dp_bus, lfa_be_crc_bus,
   lfa_be_crc_valid, pt_ob_rd, lz_data_full, lz_data_afull,
   sw_LZ_BYPASS_CONFIG, sw_IGNORE_CRC_CONFIG, sw_LZ_DECOMP_OLIMIT,
   cceip_cfg
   );
   import crPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   
   input                  clk;
   input                  rst_n;
   
   input                  fhp_be_dp_valid;
   input fhp_be_dp_bus_t  fhp_be_dp_bus;
   output                 be_fhp_dp_ready;

   input tlvp_if_bus_t    fhp_be_usr_data;
   input                  fhp_be_usr_valid;
   
   
   
   
   input                  lz_be_dp_valid;
   input lz_be_dp_bus_t   lz_be_dp_bus;
   output                 be_lz_dp_ready;
   
   input                  lfa_be_crc_bus_t lfa_be_crc_bus;
   input                  lfa_be_crc_valid;
    
   input                  pt_ob_rd;
   output logic           pt_ob_empty;
   output logic           pt_ob_aempty;
   output tlvp_if_bus_t   pt_ob_tlv;

   
   input                  lz_data_full;
   input                  lz_data_afull;
   output logic           lz_data_wr;
   output  tlvp_if_bus_t  lz_data_tlv;

   input                  sw_LZ_BYPASS_CONFIG;
   input                  sw_IGNORE_CRC_CONFIG;
   
   input [23:0]           sw_LZ_DECOMP_OLIMIT;
   input                  cceip_cfg;
   
   logic                  lz_fifo_wr;
   logic                  lz_fifo_rd;
   logic                  r_lz_fifo_rd;
   lz_be_dp_bus_t         lz_fifo_wdata;
   lz_be_dp_bus_t         lz_fifo_rdata;
   lz_be_dp_bus_t         r_lz_fifo_rdata;
   logic                  lz_fifo_empty;

   logic [5:0]            lz_fifo_used;
   logic [7:0]            pt_ob_used;
   logic [3:0]            usr_hdr_used; 

   logic                  cur_eof;
   logic                  r_cur_eof;
   logic                  pt_cur_eof;
   logic                  next_eof;
   logic                  sent_eof;
   logic                  usr_hdr_rd;
   tlvp_if_bus_t          usr_hdr_rdata;   
   tlvp_if_bus_t          r_usr_hdr_rdata; 
   logic                  lz_fifo_full;
   
   logic                  pt_ob_wr;
   tlvp_if_bus_t          pt_ob_wdata;
   logic                  usr_ftr_empty;
   logic [6:0]            usr_ftr_used;
   tlvp_if_bus_t          usr_ftr_rdata;
   logic                  usr_ftr_wr;
   logic                  usr_ftr_rd;
   tlvp_if_bus_t          usr_ftr_wdata;
   logic                  ok_to_read;
   zipline_error_e         lz_err_code;
   tlvp_if_bus_t          usr_ftr_mod_tlv;
   logic [5:0]            ftr_cnt;
   
   tlvp_if_bus_t          usr_data_tlv;
   logic                  usr_data_valid;
   logic [23:0]           lz_frm_bcnt;
   logic                  frm_size_err;
   logic                  frm_crc_err;
   logic                  crc_error;
   logic                  size_error;
   logic                  olimit_size_err;
   logic                  usr_hdr_empty;
   tlv_ftr_word12_t       ftr_wrd_12;
   tlv_ftr_word13_t       ftr_wrd_13;
   
   tlv_word_0_t           usr_word_0;
   tlv_word_0_t           r_usr_word_0;
   logic                  lz_crc_rd;
   lz_be_dp_bus_t         lz_crc_rdata;
   
   `CCX_STD_CALC_BIP2(get_bip2, `AXI_S_DP_DWIDTH); 
   
   assign lz_fifo_wr = lz_be_dp_valid && !lz_fifo_full;
   assign lz_fifo_wdata = lz_be_dp_bus;
   
   
   assign be_lz_dp_ready = (lz_fifo_used < 6'b011100) ? 1'b1 : 1'b0;
   assign be_fhp_dp_ready = ((pt_ob_used < 8'b0110_1110) &&
                             (usr_ftr_used < 7'b0111010) && !lz_data_afull) ? 1'b1 : 1'b0;

   assign lz_crc_rd = lz_fifo_rd;
   assign lz_crc_rdata = (lz_fifo_rd) ? lz_fifo_rdata : '0;
   
   always_comb
     begin
        if (!lz_fifo_empty && !lz_data_afull &&!cur_eof && ok_to_read) begin
           if (sent_eof) begin
              usr_hdr_rd = 1'b1;
              lz_fifo_rd = 1'b1;
           end
           else begin
              usr_hdr_rd = 1'b0;
              lz_fifo_rd = 1'b1;
           end
        end
        else begin
           usr_hdr_rd = 1'b0;
           lz_fifo_rd = 1'b0;
        end 
        
        if ((cur_eof || pt_cur_eof || !ok_to_read) && !lz_data_afull &&!usr_ftr_empty)
          usr_ftr_rd = 1'b1;
        else
          usr_ftr_rd = 1'b0;
        
     end 
   
   
   
   assign cur_eof = (r_lz_fifo_rd && !sent_eof && 
                     ((r_lz_fifo_rdata.data_type == 2'b10) ||
                     (r_lz_fifo_rdata.data_type == 2'b11))) ? 1'b1 : 1'b0;
   assign pt_cur_eof = (fhp_be_dp_valid && 
                        ((fhp_be_dp_bus.data.typen == DATA) || 
                         (fhp_be_dp_bus.data.typen == DATA_UNK) ||
                         (fhp_be_dp_bus.data.typen == LZ77))
                        && fhp_be_dp_bus.data.eot) ? 1'b1 : 1'b0;
   
   assign next_eof = (lz_fifo_rd && ((lz_fifo_rdata.data_type == 2'b10) ||
                     (lz_fifo_rdata.data_type == 2'b11))) ? 1'b1 : 1'b0;

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         sent_eof <= 1;
         ok_to_read <= 1'b1;
         
         
         frm_crc_err <= 0;
         frm_size_err <= 0;
         olimit_size_err <= 0;
         r_lz_fifo_rd <= 0;
         r_lz_fifo_rdata <= 0;
         r_usr_hdr_rdata <= 0;
         
      end
      else begin
         if (cur_eof || pt_cur_eof)
           sent_eof <= 1'b1;
         else if (usr_hdr_rd)
           sent_eof <= 1'b0;
         if (usr_hdr_rd) 
           r_usr_hdr_rdata <= usr_hdr_rdata;
         if (lz_fifo_rd)
           r_lz_fifo_rdata <= lz_fifo_rdata;
         if (lz_fifo_rd)
           r_lz_fifo_rd <= 1'b1;

         if (cur_eof || pt_cur_eof) 
           ok_to_read <= 1'b0;
         else if (usr_ftr_rd && usr_ftr_rdata.eot == 1'b1)
           ok_to_read <= 1'b1;

         if (r_cur_eof) begin
            frm_crc_err <= crc_error;
            frm_size_err <= size_error;
            if (sw_LZ_DECOMP_OLIMIT < lz_frm_bcnt)
              olimit_size_err <= 1'b1;
            else
              olimit_size_err <= 1'b0;
         end

      end
   end
   
   always_comb
     begin
        if (sent_eof && usr_hdr_rd) begin
           usr_data_tlv.sot = 1'b1;
           usr_data_tlv.eot = next_eof;
           usr_data_tlv.tdata = usr_hdr_rdata.tdata;
           usr_data_tlv.tdata[63:62] = 2'b0; 
           usr_data_tlv.tdata[15:8] = '0; 
           usr_data_tlv.tdata[7:0] = DATA_UNK; 
           usr_data_tlv.tdata[63:62] = get_bip2(usr_data_tlv.tdata);
           usr_data_tlv.insert = usr_hdr_rdata.insert;
           usr_data_tlv.ordern = usr_hdr_rdata.ordern;
           usr_data_tlv.typen = DATA_UNK; 
           usr_data_tlv.tlast = 1'b0;
           usr_data_tlv.tid = usr_hdr_rdata.tid;
           usr_data_tlv.tuser[0] = 1'b1;
           usr_data_tlv.tuser[1] = next_eof;
           usr_data_tlv.tuser[7:2] = '0;
           usr_data_tlv.tstrb = 8'hff;
           usr_data_valid = 1'b1;
        end 
        else if (r_lz_fifo_rd && lz_fifo_rd && !cur_eof) begin
           usr_data_tlv.sot = 1'b0;
           usr_data_tlv.eot = next_eof;
           usr_data_tlv.tdata = r_lz_fifo_rdata.data;
           usr_data_tlv.insert = r_usr_hdr_rdata.insert;
           usr_data_tlv.ordern = r_usr_hdr_rdata.ordern;
           usr_data_tlv.typen = DATA_UNK; 
           usr_data_tlv.tlast = 1'b0;
           usr_data_tlv.tid = r_usr_hdr_rdata.tid;
           usr_data_tlv.tuser[0] = 1'b0;
           usr_data_tlv.tuser[1] = next_eof;
           usr_data_tlv.tuser[7:2] = '0;
           usr_data_tlv.tstrb = r_lz_fifo_rdata.bytes_valid;
           usr_data_valid = 1'b1;
        end 
        else begin
           usr_data_valid = 1'b0;
           usr_data_tlv = '0;
        end
     end 

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         lz_err_code <= NO_ERRORS;

         
         
         ftr_cnt <= 0;
         pt_ob_wdata <= 0;
         pt_ob_wr <= 0;
         r_cur_eof <= 0;
         r_usr_word_0 <= 0;
         usr_ftr_wdata <= 0;
         usr_ftr_wr <= 0;
         usr_word_0 <= 0;
         
      end
      else begin
         if (usr_hdr_rd)
           usr_word_0 <= usr_hdr_rdata.tdata;
         if (cur_eof || pt_cur_eof)
           r_usr_word_0 <= usr_word_0;
         
         if (fhp_be_dp_valid) begin
            if (fhp_be_dp_bus.data.typen == FTR) begin
               usr_ftr_wr <= 1'b1;
               pt_ob_wr <= 1'b0;
               usr_ftr_wdata <= fhp_be_dp_bus.data;
            end
            else begin
               pt_ob_wr <= 1'b1;
               usr_ftr_wr <= 1'b0;
               pt_ob_wdata <= fhp_be_dp_bus.data;
            end
         end 
         else begin
            pt_ob_wr <= 1'b0;
            usr_ftr_wr <= 1'b0;
         end
         
         if (usr_ftr_rdata.eot && usr_ftr_rd)
           ftr_cnt <= '0;
         else if (usr_ftr_rd) 
           ftr_cnt <= ftr_cnt + 1;
         if (cur_eof)
           lz_err_code <= zipline_error_e'(r_lz_fifo_rdata.data[15:0]);

         r_cur_eof <= cur_eof;
         
      end 
   end 

   assign lz_data_wr = (usr_data_valid || usr_ftr_rd);
   assign lz_data_tlv = (usr_data_valid) ? usr_data_tlv : usr_ftr_mod_tlv;

   always_comb
     begin
        usr_ftr_mod_tlv = usr_ftr_rdata;
        ftr_wrd_12 = usr_ftr_mod_tlv.tdata;
        ftr_wrd_13 = usr_ftr_mod_tlv.tdata;
        
        if ((ftr_cnt == 6'd12) && !cceip_cfg) begin
           ftr_wrd_12.bytes_out = lz_frm_bcnt;

           usr_ftr_mod_tlv.tdata = ftr_wrd_12;
        end
        else if (ftr_cnt == 6'd13) begin
           if (ftr_wrd_13.error_code == NO_ERRORS) begin
              if (lz_err_code != NO_ERRORS) 
                ftr_wrd_13.error_code = lz_err_code;
              else if (frm_crc_err && !(sw_LZ_BYPASS_CONFIG || sw_IGNORE_CRC_CONFIG))
                ftr_wrd_13.error_code = HD_BE_FRM_CRC;
              else if (frm_size_err && !sw_LZ_BYPASS_CONFIG)
                ftr_wrd_13.error_code = HD_BE_SZ_MISMATCH; 
              else if (olimit_size_err && !sw_LZ_BYPASS_CONFIG)
                ftr_wrd_13.error_code = HD_BE_OLIMIT;
              else
                ftr_wrd_13.error_code = NO_ERRORS;
              
              if (ftr_wrd_13.error_code != NO_ERRORS)
                ftr_wrd_13.errored_frame_number = r_usr_word_0.tlv_frame_num;
           end
           usr_ftr_mod_tlv.tdata = ftr_wrd_13;
        end
        
     end 
   
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         lz_frm_bcnt <= 0;
         
      end
      else begin
         if (usr_data_tlv.sot && usr_data_valid) begin
            lz_frm_bcnt <= '0;
         end
         else begin
            if (usr_data_valid) begin
               case (usr_data_tlv.tstrb)
                 8'h01 :   lz_frm_bcnt <= lz_frm_bcnt + 8'd1; 
                 8'h03 :   lz_frm_bcnt <= lz_frm_bcnt + 8'd2; 
                 8'h07 :   lz_frm_bcnt <= lz_frm_bcnt + 8'd3; 
                 8'h0f :   lz_frm_bcnt <= lz_frm_bcnt + 8'd4; 
                 8'h1f :   lz_frm_bcnt <= lz_frm_bcnt + 8'd5; 
                 8'h3f :   lz_frm_bcnt <= lz_frm_bcnt + 8'd6; 
                 8'h7f :   lz_frm_bcnt <= lz_frm_bcnt + 8'd7; 
                 8'hff :   lz_frm_bcnt <= lz_frm_bcnt + 8'd8; 
                 default : lz_frm_bcnt <= lz_frm_bcnt;
               endcase 
            end 
         end 
      end 
   end 
   
   
   nx_fifo #(.DEPTH (32), .WIDTH ($bits(lz_be_dp_bus_t)))
   lz_fifo (.empty (lz_fifo_empty),
            .full (lz_fifo_full),
            .used_slots (lz_fifo_used),
            .free_slots (),
            .rdata (lz_fifo_rdata),
            .clk (clk),
            .rst_n (rst_n),
            .wen (lz_fifo_wr),
            .ren (lz_fifo_rd),
            .clear (1'b0),
            .underflow (),
            .overflow (),
            .wdata (lz_fifo_wdata));

   assign pt_ob_aempty = (pt_ob_used < 8'b00000011) ? 1'b1 : 1'b0;
   
   
   nx_fifo #(.DEPTH (128), .WIDTH ($bits(tlvp_if_bus_t)))
   pt_fifo (.empty (pt_ob_empty),
            .full (),
            .used_slots (pt_ob_used),
            .free_slots (),
            .rdata (pt_ob_tlv),
            .clk (clk),
            .rst_n (rst_n),
            .wen (pt_ob_wr),
            .ren (pt_ob_rd),
            .clear (1'b0),
            .underflow (),
            .overflow (),
            .wdata (pt_ob_wdata));

   
   nx_fifo #(.DEPTH (8), .WIDTH ($bits(tlvp_if_bus_t)))
   usr_fifo (.empty (usr_hdr_empty),
            .full (),
            .used_slots (usr_hdr_used),
            .free_slots (),
            .rdata (usr_hdr_rdata),
            .clk (clk),
            .rst_n (rst_n),
            .wen (fhp_be_usr_valid),
            .ren (usr_hdr_rd),
            .clear (1'b0),
            .underflow (),
            .overflow (),
            .wdata (fhp_be_usr_data));

   
   nx_fifo #(.DEPTH (64), .WIDTH ($bits(tlvp_if_bus_t)))
   usr_ftf (.empty (usr_ftr_empty),
            .full (),
            .used_slots (usr_ftr_used),
            .free_slots (),
            .rdata (usr_ftr_rdata),
            .clk (clk),
            .rst_n (rst_n),
            .wen (usr_ftr_wr),
            .ren (usr_ftr_rd),
            .clear (1'b0),
            .underflow (),
            .overflow (),
            .wdata (usr_ftr_wdata));
   
   cr_xp10_decomp_be_frm_chk frm_chk_inst (
                                           
                                           .size_error          (size_error),
                                           .crc_error           (crc_error),
                                           
                                           .clk                 (clk),
                                           .rst_n               (rst_n),
                                           .lfa_be_crc_bus      (lfa_be_crc_bus),
                                           .lfa_be_crc_valid    (lfa_be_crc_valid),
                                           .lz_be_dp_bus        (lz_crc_rdata),
                                           .lz_be_dp_valid      (lz_crc_rd));
   
endmodule 








             