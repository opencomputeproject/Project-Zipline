/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
module cr_xp10_decomp_fe_bhp_dflate (
   
   deflate_status_valid, deflate_data_ready, deflate_fmt,
   deflate_bits_consumed, deflate_errors, deflate_blast, deflate_len,
   
   clk, rst_n, deflate_data_in, deflate_data_sof, deflate_data_valid,
   deflate_frm_fmt, deflate_align_bits, deflate_data_eof
   );
   import crPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   input                     clk;
   input                     rst_n;
   input [63:0]              deflate_data_in;
   input                     deflate_data_sof;
   input                     deflate_data_valid;
   input                     deflate_frm_fmt; 
   input [5:0]               deflate_align_bits;
   input                     deflate_data_eof;
   
   output logic              deflate_status_valid;
   output logic              deflate_data_ready;
   
   output htf_fmt_e          deflate_fmt;
   output logic [12:0]       deflate_bits_consumed;
   output zipline_error_e     deflate_errors;
   output logic              deflate_blast;
   output logic [15:0]       deflate_len;
   
   logic [63:0]              hdr_data;
   logic [63:0]              tmp_hdr_data; 
   logic [63:0]              data_in;
   logic                     data_valid;
   
   logic [63:0]              r_deflate_data_in;
   logic [63:0]              nxt_data_in;
   logic                     nxt_data_valid;
   
   logic [6:0]               r_bits_used;
   logic                     fcrc;
   logic                     fextra;
   logic                     fname;
   logic                     fcomment;
   logic [6:0]               bits_used;
   logic [15:0]              xlen;
   logic [15:0]              r_xlen;
   logic [15:0]              u_xlen;
   logic                     u_fname;
   logic                     r_fname;
   logic                     u_fcomment;
   logic                     r_fcomment;
   logic [5:0]               crc_len;
   logic [5:0]               u_crc_len;
   logic [5:0]               r_crc_len;
   logic                     u_blast_val;
   logic                     r_blast_val;
   logic                     u_blast;
   logic                     r_blast;
   logic                     u_dfmt1;
   logic                     r_dfmt1;
   logic                     u_dfmt2;
   logic                     r_dfmt2;
   logic                     all_valid;
   logic                     u_dfmt1_val;
   logic                     u_dfmt2_val;
   logic                     r_dfmt2_val;
   
   logic                     r_dfmt1_val;
   logic                     id_err;
   logic                     cm_err;
   logic                     xlen_wrd;
   logic                     crc_wrd;
   
   logic                     r_fcrc;
   logic                     r_fextra;
   htf_fmt_e                 tmp_dfmt_fmt;
   logic                     len_done;
   logic [31:0]              u_len;
   logic [31:0]              r_len;
   logic [5:0]               r_len_bits;
   logic [5:0]               u_len_bits;
   logic                     done;
   logic [7:0]               cmf;
   logic [7:0]               flg;
   logic                     fcheck_err;
   logic                     cinfo_err;
   
   logic                     r_deflate_data_ready;
   logic [2:0]               pad_bits;
   
   typedef enum logic [2:0] {DEFLATE_IDLE=0,
                             XLEN_ST =1,
                             FNAME_ST=2,
                             FCOMMENT_ST=3,
                             FCRC_ST=4,
                             FMT_ST=5,
                             LEN_ST=6} deflate_st_e;
   deflate_st_e              nxt_st;
                        
   logic                     dict_prsnt;
   logic                     hdr_sof_valid;
   logic                     any_errors;
   logic                     r_deflate_valid;
   logic                     zlib_len_err;
   logic                     all_bits_consumed;
   logic                     runt_err;
   logic                     r_eof;
   logic                     data_eof;
   logic                     got_eof;
   logic                     nxt_data_eof;
   logic                     got_xlen_wrd;
   logic                     max_sz_err;
   
   logic [7:0]               frm_cnt;
   
   assign hdr_data = (r_deflate_valid) ? 
                                r_deflate_data_in : data_in;
   assign got_eof = (r_deflate_valid) ? r_eof : data_eof;
   
   assign data_valid = (((deflate_data_valid || nxt_data_valid) && 
                       (r_deflate_data_ready || hdr_sof_valid)) || r_deflate_valid) 
                       && !deflate_status_valid ? 1'b1 : 1'b0;
   assign data_in = data_valid ? 
                    (nxt_data_valid ? nxt_data_in : deflate_data_in) : '0;
   assign data_eof = data_valid ?
                    (nxt_data_valid ? nxt_data_eof : deflate_data_eof) : '0;
   
   assign deflate_data_ready = ((bits_used == 7'd64) || 
                                (!data_valid && ((nxt_st != DEFLATE_IDLE))) ||
                                (nxt_st == DEFLATE_IDLE)) ? 1'b1 : 1'b0;
   assign all_valid = (u_blast_val && u_dfmt1_val && u_dfmt2_val);
   assign hdr_sof_valid = deflate_data_valid && deflate_data_sof;
   assign pad_bits = 4'b1000 - ((deflate_align_bits+3) % 8); 
   assign all_bits_consumed = (bits_used == 7'd64);
   assign runt_err = (all_bits_consumed && got_eof && !done);
   assign max_sz_err = (frm_cnt == 8'h80) && deflate_data_valid && !deflate_data_eof;
   always_comb
     begin
        u_blast_val = r_blast_val;
        u_dfmt1_val = r_dfmt1_val;
        u_dfmt2_val = r_dfmt2_val;
        u_blast = r_blast;
        u_dfmt1 = r_dfmt1;
        u_dfmt2 = r_dfmt2;
        bits_used = 0;
        xlen = '0;
        u_fname = '0;
        u_fcomment = '0;
        crc_len = '0;
        u_crc_len = '0;
        cm_err = 1'b0;
        id_err = 1'b0;
        fcrc = 1'b0;
        fextra = 1'b0;
        fcomment = 1'b0;
        fname = 1'b0;
        u_xlen = '0;
        done = 1'b0;
        dict_prsnt= 0;
        len_done = 1'b0;
        u_len_bits = '0;
        u_len = '0;
        fcheck_err = 1'b0;
        cinfo_err = 1'b0;
        cmf = '0;
        flg = '0;
        tmp_hdr_data = '0;
        zlib_len_err = 1'b0;
        got_xlen_wrd = 1'b0;
        case (nxt_st) 
          DEFLATE_IDLE : begin
             if (hdr_sof_valid) begin
                if (deflate_frm_fmt) begin 
                   if ((hdr_data[7:0] != `CR_DFLATE_ID1) ||
                       (hdr_data[15:8] != `CR_DFLATE_ID2))
                     id_err = 1'b1;
                   if ((hdr_data[23:16] != `CR_DFLATE_CM_FMT))
                     cm_err = 1'b1;
                   
                   fcrc = hdr_data[25];
                   fextra = hdr_data[26];
                   fname = hdr_data[27];
                   fcomment = hdr_data[28];
                   bits_used = 7'd64;
                end 
                else begin
                   
                   done = 1'b1;
                   cmf = hdr_data[7:0];
                   flg = hdr_data[15:8];
                   {u_dfmt2, u_dfmt1} = hdr_data[18:17];
                   u_blast = hdr_data[16];
                   bits_used = 7'd19;
                   
                   
                   
                   if ({u_dfmt2, u_dfmt1} == 2'b00) begin
                      u_len[15:0] = hdr_data[39:24];
                      u_len[31:16] = hdr_data[55:40];
                      bits_used = 7'd56;
                   end
                   if (({cmf, flg} % 5'd31) > 0)
                     fcheck_err = 1'b1;
                   if (hdr_data[3:0] != 4'd8) 
                     cm_err = 1'b1;
                   if (hdr_data[7:4] != 4'd7)
                     cinfo_err = 1'b1;
                   if (hdr_data[13])
                     dict_prsnt = 1'b1;
                end 
             end 
             else if (data_valid) begin
                done = 1'b1;
                u_blast = hdr_data[0];
                u_dfmt1 = hdr_data[1];
                u_dfmt2 = hdr_data[2];
                bits_used = 7'd3;
                
                
                if ({u_dfmt2, u_dfmt1} == 2'b00) begin
                   bits_used = 7'd3 + pad_bits; 
                   tmp_hdr_data = (hdr_data >> bits_used);
                   u_len[15:0] = tmp_hdr_data[15:0];
                   u_len[31:16] = tmp_hdr_data[31:16];
                   if (u_len[15:0] != ~u_len[31:16])
                     zlib_len_err = 1'b1;
                   bits_used = 7'd35 + pad_bits;
                end
             end 
          end 
          XLEN_ST : begin
             if (xlen_wrd) begin
                if (data_valid) begin
                   xlen = hdr_data[31:16];
                   got_xlen_wrd = 1'b1;
                   {bits_used, u_xlen} = examine_xlen_field(xlen_wrd, xlen);
                end
                else begin
                   bits_used = '0;
                   u_xlen = 15'h00ff;
                end
             end
             else begin
                if (data_valid) begin
                   xlen = r_xlen;
                   {bits_used, u_xlen} = examine_xlen_field(xlen_wrd, xlen);
                end
                else begin
                   bits_used = r_bits_used;
                   u_xlen = r_xlen;
                end
             end
          end
          FNAME_ST : begin
             if (data_valid) 
               {bits_used, u_fname} = examine_0_term_field(r_bits_used, hdr_data);
             else begin
                bits_used = r_bits_used;
                u_fname = 1'b0;
             end
          end
          FCOMMENT_ST : begin
             if (data_valid)
               {bits_used, u_fcomment} = examine_0_term_field(r_bits_used, hdr_data);
             else begin
                bits_used = r_bits_used;
                u_fcomment = 1'b0;
             end
          end
          FCRC_ST : begin
             if (crc_wrd)
               crc_len = 5'd16;
             else
               crc_len = r_crc_len;
             if (data_valid)
               {bits_used, u_crc_len} = examine_crc_field(r_bits_used, crc_len);
             else begin
                bits_used = r_bits_used;
                u_crc_len = crc_len;
             end
          end
          FMT_ST : begin
             if (data_valid) begin
                {bits_used, u_blast_val, u_blast, u_dfmt1_val, u_dfmt1, u_dfmt2_val, u_dfmt2} = examine_fmt_fields(r_bits_used, hdr_data, r_blast_val, r_dfmt1_val, r_dfmt2_val);
             end
             else begin
                bits_used = r_bits_used;
                u_blast_val = 1'b0;
                u_dfmt1_val = 1'b0;
                u_dfmt2_val = 1'b0;
             end
             done = all_valid && !({u_dfmt2, u_dfmt1} == 2'b00);
          end
          LEN_ST : begin
             if (data_valid)
               {bits_used, len_done, u_len_bits, u_len} = examine_len_fields(r_bits_used, hdr_data, r_len_bits, r_len);
             else begin
                bits_used = r_bits_used;
                len_done = 1'b0;
                u_len_bits = r_len_bits;
                u_len = r_len;
             end
             done = len_done;
          end
          default : begin
             bits_used = '0;
          end
        endcase 
        
        case ({u_dfmt2, u_dfmt1})
          2'b00 : tmp_dfmt_fmt = HTF_FMT_RAW;
          2'b01 : tmp_dfmt_fmt = HTF_FMT_DEFLATE_FIXED;
          2'b10 : tmp_dfmt_fmt = HTF_FMT_DEFLATE_DYNAMIC;
          2'b11 : tmp_dfmt_fmt = HTF_FMT_RAW;
        endcase

     end 
   assign any_errors = cm_err || id_err || dict_prsnt || cinfo_err ||
                       fcheck_err || runt_err || max_sz_err;
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         nxt_st <= DEFLATE_IDLE;
         
         
         crc_wrd <= 0;
         xlen_wrd <= 0;
         
      end
      else begin
         if (fextra) xlen_wrd <= 1'b1;
         else if (data_valid) xlen_wrd <= 1'b0;
         case (nxt_st)
           DEFLATE_IDLE : begin
              if (data_valid) begin
                 if (any_errors || done) nxt_st <= DEFLATE_IDLE;
                 else if (all_bits_consumed && got_eof) nxt_st <= DEFLATE_IDLE;
                 else if (fextra) nxt_st <= XLEN_ST;
                 else if (fname) nxt_st <= FNAME_ST;
                 else if (fcomment) nxt_st <= FCOMMENT_ST;
                 else if (fcrc) begin
                    nxt_st <= FCRC_ST;
                    crc_wrd <= 1'b1;
                 end
                 else nxt_st <= FMT_ST;
              end
           end
           XLEN_ST : begin
              if ((all_bits_consumed && got_eof) || runt_err || max_sz_err) nxt_st <= DEFLATE_IDLE;
              else if (u_xlen == 0) begin
                 if (r_fname) nxt_st <= FNAME_ST;
                 else if (r_fcomment) nxt_st <= FCOMMENT_ST;
                 else if (r_fcrc) begin
                    nxt_st <= FCRC_ST;
                    crc_wrd <= 1'b1;
                 end
                 else nxt_st <= FMT_ST;
              end
              else
                nxt_st <= XLEN_ST;
           end
           FNAME_ST : begin
              if ((all_bits_consumed && got_eof) || runt_err || max_sz_err) nxt_st <= DEFLATE_IDLE;
              else if (!u_fname)
                nxt_st <= FNAME_ST;
              else begin
                 if (r_fcomment) nxt_st <= FCOMMENT_ST;
                 else if (r_fcrc) begin
                    nxt_st <= FCRC_ST;
                    crc_wrd <= 1'b1;
                 end
                 else nxt_st <= FMT_ST;
              end
           end
           FCOMMENT_ST : begin
              if ((all_bits_consumed && got_eof) || runt_err || max_sz_err) nxt_st <= DEFLATE_IDLE;
              else if (!u_fcomment)
                nxt_st <= FCOMMENT_ST;
              else begin
                 if (r_fcrc) begin
                    nxt_st <= FCRC_ST;
                    crc_wrd <= 1'b1;
                 end
                 else nxt_st <= FMT_ST;
              end
           end
           FCRC_ST : begin
              crc_wrd <= 1'b0;
              if ((all_bits_consumed && got_eof) || runt_err || max_sz_err) nxt_st <= DEFLATE_IDLE;
              else if (u_crc_len == 0)
                nxt_st <= FMT_ST;
              else
                nxt_st <= FCRC_ST;
           end
           FMT_ST : begin
              if (u_blast_val && u_dfmt1_val && u_dfmt2_val) begin
                 if ((all_bits_consumed && got_eof) || runt_err || max_sz_err) nxt_st <= DEFLATE_IDLE;                       
                 else if (!u_dfmt1 && !u_dfmt2) 
                   nxt_st <= LEN_ST;
                 else
                   nxt_st <= DEFLATE_IDLE;
              end
           end
           LEN_ST : begin
              if (len_done)
                nxt_st <= DEFLATE_IDLE;
              else if ((all_bits_consumed && got_eof) || runt_err || max_sz_err) nxt_st <= DEFLATE_IDLE; 
           end
           default : begin
              nxt_st <= DEFLATE_IDLE;
           end
         endcase 
      end 
   end 

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         deflate_fmt <= HTF_FMT_RAW;
         deflate_errors <= NO_ERRORS;
         
         
         deflate_bits_consumed <= 0;
         deflate_blast <= 0;
         deflate_len <= 0;
         deflate_status_valid <= 0;
         frm_cnt <= 0;
         nxt_data_eof <= 0;
         nxt_data_in <= 0;
         nxt_data_valid <= 0;
         r_bits_used <= 0;
         r_blast <= 0;
         r_blast_val <= 0;
         r_crc_len <= 0;
         r_deflate_data_in <= 0;
         r_deflate_data_ready <= 0;
         r_deflate_valid <= 0;
         r_dfmt1 <= 0;
         r_dfmt1_val <= 0;
         r_dfmt2 <= 0;
         r_dfmt2_val <= 0;
         r_eof <= 0;
         r_fcomment <= 0;
         r_fcrc <= 0;
         r_fextra <= 0;
         r_fname <= 0;
         r_len <= 0;
         r_len_bits <= 0;
         r_xlen <= 0;
         
      end
      else begin
         if (done || deflate_status_valid || runt_err || max_sz_err || 
             ((r_deflate_valid && (bits_used == 7'd64) && 
               !deflate_data_valid))) begin
            r_deflate_data_in <= '0;
            r_deflate_valid <= 1'b0;
            r_eof <= 1'b0;
         end
         else if (deflate_data_valid) begin
            if (((bits_used != 7'd64) && !done) ||
                ((bits_used == 7'd64) && r_deflate_valid)) begin
               r_deflate_data_in <= deflate_data_in;
               r_deflate_valid <= 1'b1;
               r_eof <= deflate_data_eof;
            end
            else begin
               r_deflate_data_in <= '0;
               r_deflate_valid <= 1'b0;
               r_eof <= 1'b0;
            end
         end

         r_deflate_data_ready <= deflate_data_ready;
         
         if (!r_deflate_data_ready && deflate_data_valid) begin
            nxt_data_valid <= 1'b1;
            nxt_data_in <= deflate_data_in;
            nxt_data_eof <= deflate_data_eof;
         end
         else if (deflate_data_ready || done || runt_err || max_sz_err) begin
            nxt_data_valid <= 1'b0;
            nxt_data_eof <= 1'b0;
         end
         
         if (deflate_status_valid)
           r_bits_used <= '0;
         else if (deflate_data_valid && deflate_data_sof)
           r_bits_used <= 7'd16;
         else if (bits_used == 7'd64)
           r_bits_used <= '0;
         else
           r_bits_used <= bits_used;
         
         if (nxt_st == DEFLATE_IDLE) begin
            r_fcrc <= fcrc;
            r_fextra <= fextra;
            r_fname <= fname;
            r_fcomment <= fcomment;
         end
         if (deflate_status_valid)
           r_xlen <= '0;
         else if (nxt_st == XLEN_ST)
           r_xlen <= u_xlen;

         if (deflate_status_valid)
           r_crc_len <= '0;
         else if (nxt_st == FCRC_ST)
           r_crc_len <= u_crc_len;

         if ((nxt_st == DEFLATE_IDLE) || done || runt_err || max_sz_err) begin
            r_blast <= '0;
            r_blast_val <= '0;
            r_dfmt1 <= '0;
            r_dfmt1_val <= '0;
            r_dfmt2 <= '0;
            r_dfmt2_val <= '0;
         end
         else if (nxt_st == FMT_ST) begin
            if (u_blast_val)
              r_blast <= u_blast;
            if (u_dfmt1_val)
              r_dfmt1 <= u_dfmt1;
            if (u_dfmt2_val)
              r_dfmt2 <= u_dfmt2;
            r_blast_val <= u_blast_val;
            r_dfmt1_val <= u_dfmt1_val;
            r_dfmt2_val <= u_dfmt2_val;
         end 

         if (deflate_status_valid) begin
            r_len_bits <= '0;
            r_len <= '0;
         end
         else if (nxt_st == LEN_ST) begin
            if (len_done) begin
               r_len <= '0;
               r_len_bits <= '0;
            end
            else begin
               r_len <= u_len;
               r_len_bits <= u_len_bits;
            end
         end

         if (deflate_status_valid)
           deflate_bits_consumed <= '0;
         else if (deflate_data_valid && deflate_data_sof) begin
            deflate_bits_consumed <= bits_used; 
         end
         else begin
            
            if (bits_used == 7'd64)
              deflate_bits_consumed <= deflate_bits_consumed + 7'd64;
            else if (done)
              deflate_bits_consumed <= deflate_bits_consumed + bits_used;
            else if (runt_err || max_sz_err)
              deflate_bits_consumed <= '0;
            
         end        

         if ((hdr_sof_valid && any_errors) || runt_err || max_sz_err) begin
            deflate_fmt <= HTF_FMT_RAW;
            if (cm_err)
              deflate_errors <= HD_BHP_GZ_CM_NOT_DEFLATE ;
            else if (cinfo_err)
              deflate_errors <= HD_BHP_ZLIB_CINFO_RANGE;
            else if (fcheck_err)
              deflate_errors <= HD_BHP_ZLIB_FCHECK;
            else if (id_err || runt_err || max_sz_err)
              deflate_errors <= HD_BHP_HDR_INVALID;
            else if ({u_dfmt2, u_dfmt1} == 2'b11)
              deflate_errors <= HD_BHP_HDR_INVALID;
            else if (dict_prsnt)
              deflate_errors <= HD_BHP_ZLIB_FDICT_PRSNT;
            else if (zlib_len_err) begin
               deflate_errors <= HD_BHP_DFLATE_LEN_CHECK;
            end
            deflate_status_valid <= 1'b1;
         end 
         else if (done) begin
            deflate_status_valid <= 1'b1;
            deflate_fmt <= tmp_dfmt_fmt;
            if ({u_dfmt2, u_dfmt1} == 2'b11)
              deflate_errors <= HD_BHP_HDR_INVALID;
            else if (!u_dfmt2 && !u_dfmt1) begin
               if (u_len[15:0] != ~u_len[31:16])
                 deflate_errors <= HD_BHP_DFLATE_LEN_CHECK;
               else
                 deflate_errors <= NO_ERRORS;
            end
            else 
              deflate_errors <= NO_ERRORS;
            deflate_blast <= u_blast;
            deflate_len <= u_len[15:0];
         end 
         else begin
            deflate_status_valid <= 1'b0;
            deflate_fmt <= HTF_FMT_RAW; 
            deflate_errors <= NO_ERRORS;
            deflate_blast <= '0;
            deflate_len <= '0;
         end 

         if (deflate_status_valid)
           frm_cnt <= '0;
         else if (deflate_data_valid)
           frm_cnt <= frm_cnt + 1;


      end 
   end 

   function logic [7:0] examine_0_term_field;
      input [6:0] bits_consumed;
      input [63:0] data_in;
      
      logic [63:0] t_r_data;
      logic [6:0]  inv_bits;
      logic [63:0] t_mask;
      logic [63:0] tt_r_data;
      int          i;
      logic [5:0]  term_i;
      logic        fname_done;
      logic [6:0]  b_used;
      
      begin
         t_r_data = data_in >> bits_consumed;
         inv_bits = 64 - bits_consumed; 
         t_mask = 64'hffff_ffff_ffff_ffff << inv_bits;
         tt_r_data = t_r_data | t_mask;
         term_i = '0;
         fname_done = 0;
         if (&tt_r_data) 
           b_used = 64;
         else begin
            for (i=0; i < 8; i=i+1) begin
               if (tt_r_data[i*8 +:8] == 8'b0) begin
                  if (!fname_done) begin
                     term_i = i;
                     fname_done = 1;
                  end
               end
            end
            term_i = term_i+1;
            
            if (!fname_done)
              b_used = 7'd64;
            else
              b_used = bits_consumed + term_i*8; 
         end 
         examine_0_term_field = {b_used, fname_done};
      end
   endfunction 

   
   function logic [22:0] examine_xlen_field;
      input xlen_wrd;
      input [15:0] r_xlen;
      logic [7:0]  tmp_xlen;
      logic [15:0] f_xlen;
      logic [15:0] f_xlen_6;
      logic [15:0] f_xlen_8;
      logic [6:0]  bits_consumed;
      begin
         tmp_xlen = r_xlen[3:0] * 8; 
         f_xlen_6 = r_xlen - 4'd4;
         f_xlen_8 = r_xlen - 4'd8;
         f_xlen = 0;
         if (xlen_wrd) begin
            if (r_xlen > 4) begin
               f_xlen = f_xlen_6;
               bits_consumed = 7'd64;
            end
            else begin
               f_xlen = 0;
               bits_consumed = 32 + tmp_xlen;
            end
         end
         else begin
            if (r_xlen > 8) begin
               f_xlen = f_xlen_8;
               bits_consumed = 7'd64;
            end
            else begin
               f_xlen = 0;
               bits_consumed = tmp_xlen;
            end
         end 
         examine_xlen_field = {bits_consumed, f_xlen};
      end
   endfunction 
   
            
   function logic [12:0] examine_fmt_fields;
      input [6:0]  bits_consumed;
      input [63:0] r_data;
      input        blast_val;
      input        dfmt1_val;
      input        dfmt2_val;
      
      logic [6:0]  bits_avail;
      logic        f_blast_val;
      logic        f_dfmt1_val;
      logic        f_dfmt2_val;

      logic        f_blast;
      logic        f_dfmt1;
      logic        f_dfmt2;
      
      logic        dfmt1;
      logic        dfmt2;
      logic        blast;
      logic [6:0]  b_used;
      
      begin
         bits_avail = 64 - bits_consumed; 
         b_used = bits_consumed;
         f_blast_val = blast_val;
         f_dfmt1_val = dfmt1_val;
         f_dfmt2_val = dfmt2_val;
         f_blast = 1'b0;
         f_dfmt1 = 1'b0;
         f_dfmt2 = 1'b0;
         
         blast =1'b0;
         dfmt1 = 1'b0;
         dfmt2 = 1'b0;
         
         if (!f_blast_val && (bits_avail > 0)) begin
            f_blast = r_data[b_used]; 
            b_used++;
            f_blast_val = 1'b1;
            bits_avail--;
         end
         if (f_blast_val && !f_dfmt1_val && (bits_avail > 0)) begin
            f_dfmt1 = r_data[b_used]; 
            f_dfmt1_val = 1'b1;
            b_used++;
            bits_avail--;
         end
         if (f_dfmt1_val && !f_dfmt2_val && (bits_avail > 0)) begin
            f_dfmt2 = r_data[b_used]; 
            f_dfmt2_val = 1'b1;
            b_used++;
         end
         examine_fmt_fields = {b_used, f_blast_val, f_blast, f_dfmt1_val, f_dfmt1, f_dfmt2_val, f_dfmt2};
         
      end
   endfunction 

   
   function logic [12:0] examine_crc_field;
      input [6:0] bits_consumed;
      input [5:0] r_crc_len;
      logic [6:0] bits_avail;
      logic [5:0] f_crc_len;
      logic [6:0] b_used;
      begin
         b_used = bits_consumed;
         bits_avail = 64 - bits_consumed; 
         if (bits_avail > {1'b0,r_crc_len}) begin
            b_used = bits_consumed + r_crc_len; 
            f_crc_len = 0;
         end
         else begin
            b_used = bits_consumed + bits_avail; 
            f_crc_len = 16 - bits_avail;
         end
         examine_crc_field = {b_used, f_crc_len};
      end
   endfunction 
   
   
   function logic [45:0] examine_len_fields;
      input [6:0] bits_consumed;
      input [63:0] hdr_data;
      input [5:0] len_bits;
      input [31:0] r_len;
      
      logic [6:0]  b_used;
      logic [6:0]  new_b_used;
      logic [5:0]  f_len_bits;
      logic [31:0] f_len;
      logic        f_len_done;
      logic [6:0]  bits_avail;
      logic [63:0] r_hdr_data; 
      logic [63:0] r1_hdr_data; 
      logic [31:0] r2_hdr_data; 
      begin
         
         
         
         if ((len_bits == 0) && (bits_consumed > 0))
           b_used = bits_consumed + 5; 
         else
           b_used = bits_consumed;
         
         bits_avail = 64 - b_used; 
         r_hdr_data = hdr_data >> b_used;
         r1_hdr_data = r_hdr_data << len_bits;
         r2_hdr_data = r_len | r1_hdr_data[31:0];
         
         if ((len_bits + bits_avail) < 6'd32) begin
            f_len_bits = bits_avail[5:0];
            f_len_done = 1'b0;
            new_b_used = 7'd64;
         end
         else begin
            f_len_bits = 6'd32;
            new_b_used = b_used + (f_len_bits - len_bits); 
            f_len_done = 1'b1;
         end
         f_len = r2_hdr_data;

         examine_len_fields = {new_b_used, f_len_done, f_len_bits, f_len};
      end
   endfunction 
   
endmodule 








