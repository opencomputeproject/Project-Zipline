/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
module cr_xp10_decomp_fe_fhp(
   
   fhp_tlvp_pt_rd, fhp_tlvp_usr_rd, fhp_htf_bl_bus, fhp_htf_bl_valid,
   fhp_lz_prefix_hdr_valid, fhp_lz_prefix_hdr_bus,
   fhp_lz_prefix_valid, fhp_lz_prefix_dp_bus, fhp_be_dp_valid,
   fhp_be_dp_bus, fhp_lz_dbg_data_valid, fhp_lz_dbg_data_bus,
   fhp_lfa_sof_valid, fhp_lfa_sof_bus, fhp_lfa_clear_sof_fifo,
   fhp_lfa_dp_bus, fhp_lfa_dp_valid, fhp_lfa_eof_bus, fhp_be_usr_data,
   fhp_be_usr_valid, xp9_frm_stb, xp10_frm_stb, xp9_raw_frm_stb,
   gzip_frm_stb, zlib_frm_stb, chu4k_stb, chu8k_stb, pfx_crc_err_stb,
   phd_crc_err_stb, xp10_frm_pfx_stb, xp10_frm_pdh_stb, fhp_stall_stb,
   lfa_stall_stb,
   
   clk, rst_n, fhp_tlvp_pt_tlv, fhp_tlvp_pt_empty, fhp_tlvp_usr_empty,
   fhp_tlvp_usr_tlv, htf_fhp_bl_ready, lz_fhp_prefix_hdr_ready,
   lz_fhp_pre_prefix_ready, lz_fhp_usr_prefix_ready, be_fhp_dp_ready,
   lz_fhp_dbg_data_ready, lfa_fhp_sof_ready, lfa_fhp_dp_ready
   );
   
   import crPKG::*;
   import cr_xp10_decompPKG::*;
   import cr_xp10_decomp_regsPKG::*;

   input                           clk;
   input                           rst_n;
   
   output logic                    fhp_tlvp_pt_rd;
   input  tlvp_if_bus_t            fhp_tlvp_pt_tlv;
   input                           fhp_tlvp_pt_empty;
   
   output logic                    fhp_tlvp_usr_rd;
   input                           fhp_tlvp_usr_empty;
   input tlvp_if_bus_t             fhp_tlvp_usr_tlv;

   output fhp_htf_bl_bus_t         fhp_htf_bl_bus;
   output logic                    fhp_htf_bl_valid;
   input                           htf_fhp_bl_ready;
   
   output logic                    fhp_lz_prefix_hdr_valid;
   output fhp_lz_prefix_hdr_bus_t  fhp_lz_prefix_hdr_bus;
   input                           lz_fhp_prefix_hdr_ready;
   
   output  logic                   fhp_lz_prefix_valid;
   output fhp_lz_prefix_dp_bus_t   fhp_lz_prefix_dp_bus;
   input                           lz_fhp_pre_prefix_ready;
   input                           lz_fhp_usr_prefix_ready;
   
   output logic                    fhp_be_dp_valid;
   output fhp_be_dp_bus_t          fhp_be_dp_bus;
   input                           be_fhp_dp_ready;
   
   output  logic                   fhp_lz_dbg_data_valid;
   output lz_symbol_bus_t          fhp_lz_dbg_data_bus;
   input                           lz_fhp_dbg_data_ready;

   output   logic                  fhp_lfa_sof_valid;
   output fe_sof_bus_t             fhp_lfa_sof_bus;
   input                           lfa_fhp_sof_ready;
   output logic                    fhp_lfa_clear_sof_fifo;
   
   output fe_dp_bus_t              fhp_lfa_dp_bus;
   output logic                    fhp_lfa_dp_valid;
   input                           lfa_fhp_dp_ready;
   output fe_eof_bus_t             fhp_lfa_eof_bus;
   
   output tlvp_if_bus_t            fhp_be_usr_data;
   output logic                    fhp_be_usr_valid;

   output logic                    xp9_frm_stb;
   output logic                    xp10_frm_stb;
   output logic                    xp9_raw_frm_stb;
   output logic                    gzip_frm_stb;
   output logic                    zlib_frm_stb;
   output logic                    chu4k_stb;
   output logic                    chu8k_stb;
   output logic                    pfx_crc_err_stb;
   output logic                    phd_crc_err_stb;
   output logic                    xp10_frm_pfx_stb;
   output logic                    xp10_frm_pdh_stb;
   output logic                    fhp_stall_stb;
   output logic                    lfa_stall_stb;
   
   tlvp_if_bus_t                   r_usr_tlv;
   tlvp_if_bus_t                   r_pt_tlv;

   logic                           r_fhp_tlvp_pt_rd;
   logic                           r_fhp_tlvp_usr_rd;
   
   logic                           data_tlv;
   logic                           got_data;
   logic                           trace_bit;
   tlv_cmd_word_1_t                cmd_tlv_wd1; 

   logic [3:0]                     frmd_coding_location;
   
   typedef enum                    logic [2:0] {in_INACTIVE=0, 
                                                in_LZDBG=1, 
                                                in_DATA=2,
                                                in_FRMD=3,
                                                in_PFD=4, 
                                                in_PHD=5,
                                                in_RQE=6,
                                                in_CMD=7} usr_state_e;

   usr_state_e                    usr_state;

   logic                           r1_usr_eot;
   logic                           r1_pt_eot;
   logic [3:0]                     cnt;
   logic [1:0]                     rqe_cnt;
   logic                           data_sof;
   logic [16:0]                    pfx_phd_word0_len;
   tlv_word_0_t                    prefix_wrd_hdr; 
   tlv_word_0_t                    prefix_wrd_hdr_1; 
   logic                           prefix_present;
   logic                           set_prefix_sof;

   logic                           prefix_ready;
   logic                           dbg_ready;
   logic                           dp_ready;
   logic                           usr_prefix;
   logic                           got_usr_prefix;
   logic                           r_got_usr_prefix;
   frmd_coding_e                   frm_fmt;
   frmd_coding_e                   data_frm_fmt;
   
   fmd_int_app_word6_t             frmd_coding_word;     
   logic                           first_beat;
   logic [16:0]                    pfx_cnt;
   logic [31:0]                    prefix_crc_word;
   logic [31:0]                    phd_crc_word;

   logic                           pfx_phd_crc_sof;
   logic [31:0]                    pfx_phd_crc_in;
   logic [31:0]                    pfx_phd_crc_out;
   logic [63:0]                    pfx_phd_crc_data;
   logic                           chk_pfx_crc;
   logic                           chk_phd_crc;
   logic                           set_pfx_crc_error;
   logic                           set_phd_crc_error;
   logic                           r_set_pfx_crc_error;
   logic                           r_set_phd_crc_error;
   logic                           phd_sof;
   logic                           phd_sof_wrd;
   
   zipline_error_e                  pfx_phd_error;
   
   logic                           xp9_frm;
   logic                           xp10_frm;
   logic                           gzip_frm;
   logic                           zlib_frm;
   logic                           chu4k;
   logic                           chu8k;
   logic                           xp9_raw;
   logic [1:0]                     pt_cnt;
   logic                           got_phd_tlv;

   fhp_htf_bl_bus_t                int_htf_bl_bus;
   logic                           int_htf_bl_valid;
   logic                           wait_for_bl_ack;
   fhp_htf_bl_bus_t                bl_fifo_rbus;
   fhp_htf_bl_bus_t                r_bl_fifo_rbus;
   logic                           bl_fifo_rdy;
   logic                           bl_fifo_rd;
   logic [3:0]                     bl_fifo_used;
   logic                           bl_fifo_empty;
   logic                           bl_ready;
   logic [10:0]                    tlv_frame_num;
   logic [3:0]                     tlv_eng_id ;
   logic [7:0]                     tlv_seq_num;
   logic [15:0]                    rqe_sched_handle;
   logic [27:0]                    frm_bytes;
   logic [2:0]                     eot_bytes_valid;
   logic                           last_of_command;
   
   logic                           sent_eof;
   logic                           sent_bl_eof;
   
   logic [31:0]                    pfx_crc;
   logic [31:0]                    phd_crc;
   
   logic                           sent_phd_last;
   logic                           sent_pfx_last;
   logic                           got_pfx_crc;
   logic                           got_phd_crc;
   logic                           got_prefix;
   logic                           r_hdr_valid;
   logic                           ok_to_read_pt;
   
   tlv_pfd_word0_t                 pfx_word0; 
   tlv_pfd_word0_t                 r_pfx_word0; 
   
   tlv_data_word_0_t unk_word0; 
   assign unk_word0 = r_usr_tlv.tdata;
   
   assign pfx_phd_crc_sof = (fhp_lz_prefix_valid) ? fhp_lz_prefix_dp_bus.sof :
                        phd_sof;
   assign pfx_phd_crc_data = (fhp_lz_prefix_valid) ? fhp_lz_prefix_dp_bus.data :
                             fhp_htf_bl_bus.data;
   assign chk_pfx_crc = got_pfx_crc && sent_pfx_last;
   assign chk_phd_crc = got_phd_crc && sent_phd_last;
   
   assign prefix_wrd_hdr = fhp_tlvp_usr_tlv.tdata;
   assign prefix_wrd_hdr_1 = r_usr_tlv;
   
   assign pfx_word0 = fhp_tlvp_usr_tlv.tdata;
   assign r_pfx_word0 = r_usr_tlv.tdata;
   
   assign dbg_ready = (usr_state == in_LZDBG) ? lz_fhp_dbg_data_ready : 1'b1;
   assign dp_ready = (usr_state == in_DATA) ? lfa_fhp_dp_ready : 1'b1;
   assign got_usr_prefix = (pfx_word0.tlv_type == PFD) && 
                           fhp_tlvp_usr_rd &&
                           (pfx_word0.prefix_src) &&
                           fhp_tlvp_usr_tlv.sot;
   assign got_prefix = (pfx_word0.tlv_type == PFD) && 
                       fhp_tlvp_usr_rd &&
                       fhp_tlvp_usr_tlv.sot;
   
   assign cmd_tlv_wd1 = r_usr_tlv;
   assign bl_ready = (usr_state == in_PHD) ? bl_fifo_rdy : 1'b1;
   assign bl_fifo_rdy = (bl_fifo_used < 4'b0100) ? 1'b1 : 1'b0;

   assign fhp_htf_bl_valid = (bl_fifo_rd || wait_for_bl_ack);
   
   assign fhp_htf_bl_bus = (bl_fifo_rd) ? bl_fifo_rbus : 
                           wait_for_bl_ack ? r_bl_fifo_rbus : '0;
   assign bl_fifo_rd = (!bl_fifo_empty && !wait_for_bl_ack) ? 1'b1 : 1'b0;

   
   always_comb
     begin
        if (!fhp_tlvp_pt_empty && be_fhp_dp_ready) begin 
           fhp_tlvp_pt_rd = 1'b1;
        end
        else begin
           fhp_tlvp_pt_rd = 1'b0;
        end
        if (!fhp_tlvp_usr_empty && dbg_ready &&
            prefix_ready && dp_ready && bl_ready && !sent_bl_eof &&
           !sent_eof) begin

 
           fhp_tlvp_usr_rd = 1'b1;
        end
        else begin
           fhp_tlvp_usr_rd = 1'b0;
        end
     end 
      
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         data_frm_fmt <= PARSEABLE;
         
         
         data_sof <= 0;
         prefix_ready <= 0;
         r_got_usr_prefix <= 0;
         r_pt_tlv <= 0;
         r_usr_tlv <= 0;
         sent_bl_eof <= 0;
         sent_eof <= 0;
         
      end
      else begin
         r_usr_tlv <= fhp_tlvp_usr_tlv;
         r_pt_tlv <= fhp_tlvp_pt_tlv;
         if (got_prefix)
           r_got_usr_prefix <= got_usr_prefix;
         
         if (r_fhp_tlvp_usr_rd) begin
            if (r_usr_tlv.sot) begin
               data_sof <= 1'b1;
               data_frm_fmt <= frmd_coding_e'(2'(unk_word0.coding) | 2'(frm_fmt));
            end
            else
              data_sof <= 1'b0;
         end
         if (got_usr_prefix || got_prefix)
           prefix_ready <= lz_fhp_pre_prefix_ready;
         else if (usr_state == in_PFD) begin
            if (usr_prefix || r_got_usr_prefix) begin
               if (pfx_cnt < 16'd127)
                 prefix_ready <= lz_fhp_pre_prefix_ready;
               else
                 prefix_ready <= lz_fhp_usr_prefix_ready;
            end
            else
              prefix_ready <= lz_fhp_pre_prefix_ready;
         end
         else
           prefix_ready <= 1'b1;

         if (fhp_tlvp_usr_rd && fhp_tlvp_usr_tlv.eot && (usr_state == in_PHD) &&
 (pfx_cnt == 7'd64))
           sent_bl_eof <= 1'b1;
         else if (fhp_htf_bl_valid && fhp_htf_bl_bus.last)
           sent_bl_eof <= 1'b0;
         

         if (fhp_tlvp_usr_rd && fhp_tlvp_usr_tlv.eot && ((usr_state == in_DATA) ||
                                                         (usr_state == in_LZDBG)))
           sent_eof <= 1'b1;
         else if (lz_fhp_prefix_hdr_ready && !(r_hdr_valid || fhp_lz_prefix_hdr_valid))
           sent_eof <= 1'b0;
      end 
   end 
   
   assign frmd_coding_word = r_usr_tlv;   
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         frm_fmt <= PARSEABLE;
         ok_to_read_pt <= 1'b1;
         
         
         cnt <= 0;
         rqe_cnt <= 0;
         rqe_sched_handle <= 0;
         
      end
      else begin
         if (usr_state == in_FRMD) begin
            
            if (fhp_tlvp_usr_rd && (cnt < 4'd15))          
              cnt <= cnt + 1;
            if (r_fhp_tlvp_usr_rd && (cnt == frmd_coding_location)) begin
               frm_fmt <= frmd_coding_word.coding ;         
            end
         end
         else if (fhp_lfa_sof_valid)
           begin
              cnt <= '0;
              frm_fmt <= PARSEABLE;
           end
         if (usr_state == in_RQE) begin
            if (fhp_tlvp_usr_rd) begin
               if (rqe_cnt < 2'b11) 
                 rqe_cnt <= rqe_cnt + 1;
            end
            if (r_fhp_tlvp_usr_rd && (rqe_cnt == 2'b01))
              rqe_sched_handle <= r_usr_tlv.tdata[47:32];
         end
         else
            rqe_cnt <= '0;

      end 
   end 
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         fhp_be_dp_bus.data <= 0;
         fhp_be_dp_bus.data_type <= 0;
         fhp_be_dp_valid <= 0;
         r_fhp_tlvp_pt_rd <= 0;
         
      end
      else begin
         r_fhp_tlvp_pt_rd <= fhp_tlvp_pt_rd;
         
         if (r_fhp_tlvp_pt_rd) begin
            fhp_be_dp_valid <= 1'b1;
            if (!got_data) begin
               
               fhp_be_dp_bus.data <= r_pt_tlv;
               fhp_be_dp_bus.data_type <= 1'b0;
            end
           else begin
              
              fhp_be_dp_bus.data <= r_pt_tlv;
              fhp_be_dp_bus.data_type <= 1'b1;
           end 
         end 
         else begin
            fhp_be_dp_valid <= 1'b0;
            fhp_be_dp_bus.data <= '0;
            fhp_be_dp_bus.data_type <= 1'b0;
         end 
      end 
       
    end 
   
   assign data_tlv = ((fhp_tlvp_usr_tlv.typen == DATA) ||
                      (fhp_tlvp_usr_tlv.typen == LZ77) ||
                      (fhp_tlvp_usr_tlv.typen == DATA_UNK))
                      &&
                     fhp_tlvp_usr_tlv.sot;
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         usr_state <= in_INACTIVE;
         
         
         frmd_coding_location <= 0;
         got_data <= 0;
         r1_pt_eot <= 0;
         r1_usr_eot <= 0;
         r_fhp_tlvp_usr_rd <= 0;
         
      end
      else begin
         if ((usr_state == in_FRMD) && (cnt == '0)) 
           got_data <= 1'b0; 
         else if (data_tlv) got_data <= 1'b1;
         r1_usr_eot <= fhp_tlvp_usr_rd && fhp_tlvp_usr_tlv.eot;
         r1_pt_eot <= fhp_tlvp_pt_rd && fhp_tlvp_pt_tlv.eot;
         r_fhp_tlvp_usr_rd <= fhp_tlvp_usr_rd;
         
         
         if (fhp_tlvp_usr_rd) begin
            if (fhp_tlvp_usr_tlv.sot) begin
               if (fhp_tlvp_usr_tlv.typen == PHD) 
                 usr_state <= in_PHD;
               else if (fhp_tlvp_usr_tlv.typen == PFD)
                 usr_state <= in_PFD;
               else if ((fhp_tlvp_usr_tlv.typen == FRMD_INT_APP) ||
                        (fhp_tlvp_usr_tlv.typen == FRMD_INT_VM) ||
                        (fhp_tlvp_usr_tlv.typen == FRMD_INT_SIP) ||
                        (fhp_tlvp_usr_tlv.typen == FRMD_INT_LIP) ||
                        (fhp_tlvp_usr_tlv.typen == FRMD_INT_VM_SHORT))
                 begin
                    usr_state <= in_FRMD;
                    case (fhp_tlvp_usr_tlv.typen)                      
                      FRMD_INT_APP : frmd_coding_location <=  3;
                      FRMD_INT_VM  : frmd_coding_location <= 3;
                      FRMD_INT_SIP : frmd_coding_location <=  1;
                      FRMD_INT_LIP : frmd_coding_location <=  1;
                      FRMD_INT_VM_SHORT : frmd_coding_location <= 3;
                      default: frmd_coding_location <= 1;
                    endcase
                 end
               else if ((fhp_tlvp_usr_tlv.typen == DATA) ||
                        (fhp_tlvp_usr_tlv.typen == DATA_UNK))
                 usr_state <= in_DATA;
               else if (fhp_tlvp_usr_tlv.typen == LZ77)
                 usr_state <= in_LZDBG;
               else if (fhp_tlvp_usr_tlv.typen == CMD)
                 usr_state <= in_CMD;
               else if (fhp_tlvp_usr_tlv.typen == RQE)
                 usr_state <= in_RQE;
               else
                 usr_state <= in_INACTIVE;
            end 
         end 
         else begin
            if (r1_usr_eot)
              usr_state <= in_INACTIVE;
         end 

      end 
   end 

   assign phd_sof = phd_sof_wrd && fhp_htf_bl_valid;
   
   
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         pt_cnt <= 0;
         trace_bit <= 0;
         
      end
      else begin
         if (usr_state == in_CMD) begin
            if (r_fhp_tlvp_usr_rd) begin
               pt_cnt <= pt_cnt +1;
            end
         end
         else begin
            pt_cnt <= '0;
         end
         if (pt_cnt == 2'b01) begin
            if (r_fhp_tlvp_usr_rd) begin
               trace_bit <= cmd_tlv_wd1.trace;
            end
         end
      end
   end
   
   assign eot_bytes_valid = (convert_tstrb_2_bytes_valid(r_usr_tlv.tstrb));
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         fhp_be_usr_data <= 0;
         fhp_be_usr_valid <= 0;
         fhp_lfa_clear_sof_fifo <= 0;
         fhp_lfa_dp_bus <= 0;
         fhp_lfa_dp_bus.bytes_valid <= 0;
         fhp_lfa_dp_bus.data <= 0;
         fhp_lfa_dp_bus.eob <= 0;
         fhp_lfa_dp_bus.eof <= 0;
         fhp_lfa_dp_bus.sof <= 0;
         fhp_lfa_dp_valid <= 0;
         fhp_lfa_eof_bus.frm_bytes <= 0;
         fhp_lfa_eof_bus.last <= 0;
         fhp_lz_dbg_data_bus <= 0;
         fhp_lz_dbg_data_valid <= 0;
         fhp_lz_prefix_dp_bus.data <= 0;
         fhp_lz_prefix_dp_bus.last <= 0;
         fhp_lz_prefix_dp_bus.prefix_type <= 0;
         fhp_lz_prefix_dp_bus.sof <= 0;
         fhp_lz_prefix_hdr_bus.data_sz <= 0;
         fhp_lz_prefix_hdr_bus.prefix_type <= 0;
         fhp_lz_prefix_hdr_bus.trace_bit <= 0;
         fhp_lz_prefix_hdr_valid <= 0;
         fhp_lz_prefix_valid <= 0;
         first_beat <= 0;
         frm_bytes <= 0;
         got_pfx_crc <= 0;
         got_phd_crc <= 0;
         got_phd_tlv <= 0;
         int_htf_bl_bus.data <= 0;
         int_htf_bl_bus.last <= 0;
         int_htf_bl_bus.trace_bit <= 0;
         int_htf_bl_valid <= 0;
         last_of_command <= 0;
         pfx_cnt <= 0;
         pfx_phd_word0_len <= 0;
         phd_crc_word <= 0;
         prefix_crc_word <= 0;
         prefix_present <= 0;
         r_hdr_valid <= 0;
         set_prefix_sof <= 0;
         tlv_eng_id <= 0;
         tlv_frame_num <= 0;
         tlv_seq_num <= 0;
         usr_prefix <= 0;
         
      end
      else begin
         r_hdr_valid <= fhp_lz_prefix_hdr_valid;
         
         if ((usr_state == in_PHD) && r_fhp_tlvp_usr_rd && r_usr_tlv.sot)
           got_phd_tlv <= 1'b1;
         else if (fhp_lfa_sof_valid)
           got_phd_tlv <= 1'b0;
         
         
         if (usr_state == in_PHD) begin
            if (r_fhp_tlvp_usr_rd && r_usr_tlv.sot) begin
               pfx_phd_word0_len <= `CR_XP10_PHD_SZ; 
               pfx_cnt <= '0;
               got_phd_crc <= 1'b0;
            end
            else if ((r_fhp_tlvp_usr_rd) && (pfx_cnt < pfx_phd_word0_len)) begin
               pfx_cnt <= pfx_cnt + 1;
               
               int_htf_bl_bus.data <= r_usr_tlv.tdata;
               int_htf_bl_bus.trace_bit <= trace_bit;
               
               if (pfx_cnt == (pfx_phd_word0_len -1)) 
                 int_htf_bl_bus.last <= 1'b1;
               else
                 int_htf_bl_bus.last <= 1'b0;
               int_htf_bl_valid <= 1'b1;
            end
            else begin
               int_htf_bl_valid <= 1'b0;
               if (r_usr_tlv.eot && r_fhp_tlvp_usr_rd) begin
                  phd_crc_word <= r_usr_tlv.tdata[31:0];
                  pfx_cnt <= '0;
                  got_phd_crc <= 1'b1;
               end
            end 
         end 
         else begin
            int_htf_bl_bus.data <= '0;
            int_htf_bl_bus.last <= 1'b0;
            int_htf_bl_valid <= 1'b0;
            if (chk_phd_crc)
              got_phd_crc <= 1'b0;
         end
         
         if (usr_state == in_PFD) begin
            if (r_fhp_tlvp_usr_rd && r_usr_tlv.sot) begin
               
               if (r_pfx_word0.prefix_src)
                 pfx_phd_word0_len <= ((r_pfx_word0.xp10_prefix_sel+1) << 7); 
               else
                 pfx_phd_word0_len <= 16'd128; 
               
               prefix_present <= 1'b1;
               set_prefix_sof <= 1'b1;
               usr_prefix <= r_got_usr_prefix;
               pfx_cnt <= '0;
               got_pfx_crc <= 1'b0;
            end
            else if ((r_fhp_tlvp_usr_rd) && (pfx_cnt < (pfx_phd_word0_len))) begin
               pfx_cnt <= pfx_cnt + 1;
               fhp_lz_prefix_dp_bus.data <= r_usr_tlv.tdata;
               if (pfx_cnt == (pfx_phd_word0_len -1)) begin
                  fhp_lz_prefix_dp_bus.last <= 1'b1;
               end
               else begin
                  fhp_lz_prefix_dp_bus.last <= 1'b0;
               end
               fhp_lz_prefix_valid <= 1'b1;
               fhp_lz_prefix_dp_bus.sof <= set_prefix_sof;
               fhp_lz_prefix_dp_bus.prefix_type <= usr_prefix;
               set_prefix_sof <= 1'b0;
            end
            else begin
               fhp_lz_prefix_valid <= 1'b0;
               if (r_usr_tlv.eot && r_fhp_tlvp_usr_rd) begin
                  prefix_crc_word <= r_usr_tlv.tdata[31:0];
                  got_pfx_crc <= 1'b1;
                  pfx_cnt <= '0;
               end
            end
         end 
         else begin
            fhp_lz_prefix_dp_bus.data <= '0;
            fhp_lz_prefix_dp_bus.last <= 1'b0;
            fhp_lz_prefix_valid <= 1'b0;
            set_prefix_sof <= 1'b0;
            if (chk_pfx_crc)
              got_pfx_crc <= 1'b0;
            if (fhp_lfa_sof_valid || fhp_lfa_clear_sof_fifo) begin
               usr_prefix <= 1'b0;
               prefix_present <= 1'b0;
            end
         end
         
         
         if ((usr_state == in_LZDBG) ||
             (usr_state == in_DATA)) begin
            if (r_fhp_tlvp_usr_rd && (r_usr_tlv.sot)) begin
               fhp_be_usr_data <= r_usr_tlv;
               fhp_be_usr_valid <= 1'b1;
               fhp_lz_prefix_hdr_valid <= 1'b1;
               fhp_lz_prefix_hdr_bus.trace_bit <= trace_bit;
               tlv_frame_num <= unk_word0.tlv_frame_num;
               tlv_eng_id <= unk_word0.tlv_eng_id;
               tlv_seq_num <= unk_word0.tlv_seq_num;
               last_of_command <= unk_word0.last_of_command;
               
               if (usr_state == in_LZDBG)
                 fhp_lfa_clear_sof_fifo <= 1'b1;
               first_beat <= 1'b1;
                if (prefix_present) begin
                  if (pfx_phd_word0_len == 16'd128) 
                    fhp_lz_prefix_hdr_bus.prefix_type <= 1'b0;
                  else
                    fhp_lz_prefix_hdr_bus.prefix_type <= 1'b1;
                   
                  fhp_lz_prefix_hdr_bus.data_sz <= (pfx_phd_word0_len)/'d128; 
               end
                else begin
                   fhp_lz_prefix_hdr_bus.data_sz <= '0;
                   fhp_lz_prefix_hdr_bus.prefix_type <= '0;
                end
            end
            else begin
               fhp_be_usr_data <= '0;
               if (r_fhp_tlvp_usr_rd)
                 first_beat <= 1'b0;
               fhp_be_usr_valid <= 1'b0;
               fhp_lz_prefix_hdr_valid <= 1'b0;
               fhp_lfa_clear_sof_fifo <= 1'b0;
            end
         end 
         else begin
            fhp_be_usr_data <= '0;
            fhp_be_usr_valid <= 1'b0;
            fhp_lfa_clear_sof_fifo <= 1'b0;
            fhp_lz_prefix_hdr_valid <= 1'b0;
            first_beat <= 1'b0;
            last_of_command <= 1'b0;
            
         end 
         
         if (usr_state == in_LZDBG) begin
            
            if (r_fhp_tlvp_usr_rd && !r_usr_tlv.sot) begin
               fhp_lz_dbg_data_bus <= func_map_tlv_to_lz(r_usr_tlv);
               fhp_lz_dbg_data_valid <= 1'b1;
            end
            else begin
               fhp_lz_dbg_data_bus <= '0;
               fhp_lz_dbg_data_valid <= 1'b0;
            end
         end
         else begin
            fhp_lz_dbg_data_bus <= '0;
            fhp_lz_dbg_data_valid <= 1'b0;
         end 
         
         
         if (usr_state == in_DATA) begin
            if (r_fhp_tlvp_usr_rd && !r_usr_tlv.sot) begin
               fhp_lfa_dp_bus.data <= r_usr_tlv.tdata;
               fhp_lfa_dp_valid <= 1'b1;
               fhp_lfa_dp_bus.sof <= data_sof;
               fhp_lfa_dp_bus.eof <= r_usr_tlv.eot;
               if (r_usr_tlv.eot) begin
                  if (eot_bytes_valid == 3'b000)
                    fhp_lfa_eof_bus.frm_bytes <= frm_bytes + 4'h8; 
                  else
                    fhp_lfa_eof_bus.frm_bytes <= eot_bytes_valid + frm_bytes; 
                  
                  frm_bytes <= '0;
                  fhp_lfa_eof_bus.last <= last_of_command;
               end
               else begin
                  fhp_lfa_eof_bus.frm_bytes <= '0;
                  frm_bytes <= frm_bytes + 4'd8; 
                  fhp_lfa_eof_bus.last <= 1'b0;
               end
               fhp_lfa_dp_bus.eob <= 1'b0;
               fhp_lfa_dp_bus.bytes_valid <= eot_bytes_valid;
            end 
            else begin
               if (r_fhp_tlvp_usr_rd && r_usr_tlv.sot && usr_prefix) begin
                  frm_bytes <= (pfx_phd_word0_len << 3) + 8; 
               end          
               fhp_lfa_dp_bus <= '0;
               fhp_lfa_dp_valid <= 1'b0;
            end
         end
         else begin
            fhp_lfa_dp_bus <= '0;
            fhp_lfa_dp_valid <= 1'b0;
         end
      end 
   end 

   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         fhp_lfa_sof_bus.sof_fmt <= NONE;
         fhp_lfa_sof_bus.error <= NO_ERRORS;
         
         
         fhp_lfa_sof_bus.pfx_sz <= 0;
         fhp_lfa_sof_bus.phd_present <= 0;
         fhp_lfa_sof_bus.rqe_sched_handle <= 0;
         fhp_lfa_sof_bus.tlv_eng_id <= 0;
         fhp_lfa_sof_bus.tlv_frame_num <= 0;
         fhp_lfa_sof_bus.tlv_seq_num <= 0;
         fhp_lfa_sof_bus.trace_bit <= 0;
         fhp_lfa_sof_valid <= 0;
         
      end
      else begin
         if (usr_state == in_DATA) begin
            if (r_fhp_tlvp_usr_rd && !r_usr_tlv.sot && first_beat) begin
               fhp_lfa_sof_bus.trace_bit <= trace_bit;
               fhp_lfa_sof_bus.phd_present <= got_phd_tlv;
               fhp_lfa_sof_bus.tlv_frame_num <= tlv_frame_num;
               fhp_lfa_sof_bus.tlv_eng_id <= tlv_eng_id;
               fhp_lfa_sof_bus.tlv_seq_num <= tlv_seq_num;
               fhp_lfa_sof_bus.rqe_sched_handle <= rqe_sched_handle;
                if (fhp_lz_prefix_hdr_bus.data_sz > 0)
                 fhp_lfa_sof_bus.pfx_sz <= frm_bytes;
               else
                 fhp_lfa_sof_bus.pfx_sz <= '0;
               if (data_frm_fmt == PARSEABLE) begin
                  if (r_usr_tlv.tdata[31:0] == 32'd`XPRESS9_ID) begin
                     fhp_lfa_sof_bus.sof_fmt <= XP9;
                     fhp_lfa_sof_bus.error <= NO_ERRORS;
                  end
                  else if (r_usr_tlv.tdata[31:0] == 32'd`XPRESS10_ID) begin
                     fhp_lfa_sof_bus.sof_fmt <= XP10;
                     if (!prefix_present && 
                         ((r_usr_tlv.tdata[37:36] != 2'b00) && (r_usr_tlv.tdata[43:38] != '0))) begin
                        if (pfx_phd_error == NO_ERRORS)
                          fhp_lfa_sof_bus.error <= HD_FHP_PFX_DATA_ABSENT;
                        else
                          fhp_lfa_sof_bus.error <= pfx_phd_error; 
                     end
                     else
                       fhp_lfa_sof_bus.error <= pfx_phd_error; 
                  end 
                  else if ((r_usr_tlv.tdata[7:0] == 8'd`CR_DFLATE_ID1) &&
                           (r_usr_tlv.tdata[15:8] == 8'd`CR_DFLATE_ID2)) begin
                     fhp_lfa_sof_bus.sof_fmt <= GZIP;
                  end
                  else if (r_usr_tlv.tdata[3:0] == 4'd8) begin
                     fhp_lfa_sof_bus.sof_fmt <= ZLIB;
                  end
                  else begin 
                     fhp_lfa_sof_bus.sof_fmt <= NONE;
                     fhp_lfa_sof_bus.error <= HD_FHP_BAD_FORMAT;
                  end
               end
               else if (data_frm_fmt == RAW) begin
                  fhp_lfa_sof_bus.sof_fmt <= NONE;
                  fhp_lfa_sof_bus.error <= NO_ERRORS;
               end
               else if (data_frm_fmt == XP10CFH4K) begin
                  fhp_lfa_sof_bus.sof_fmt <= CHU4K;
                  if (!prefix_present && (r_usr_tlv.tdata[`CHU_PFX_MSB:`CHU_PFX_LSB] !=0)) begin
                     if (pfx_phd_error == NO_ERRORS)
                       fhp_lfa_sof_bus.error <= HD_FHP_PFX_DATA_ABSENT;
                     else
                       fhp_lfa_sof_bus.error <= pfx_phd_error; 
                  end
                  else
                    fhp_lfa_sof_bus.error <= pfx_phd_error;
               end
               else if (data_frm_fmt == XP10CFH8K) begin
                  fhp_lfa_sof_bus.sof_fmt <= CHU8K;
                  if (!prefix_present && (r_usr_tlv.tdata[`CHU_PFX_MSB:`CHU_PFX_LSB] !=0)) begin
                     if (pfx_phd_error == NO_ERRORS)
                       fhp_lfa_sof_bus.error <= HD_FHP_PFX_DATA_ABSENT;
                     else
                       fhp_lfa_sof_bus.error <= pfx_phd_error; 
                  end
                  else
                    fhp_lfa_sof_bus.error <= pfx_phd_error;
               end
               fhp_lfa_sof_valid <= 1'b1;
            end 
            else begin
               fhp_lfa_sof_valid <= 1'b0;
               fhp_lfa_sof_bus.sof_fmt <= NONE;
               fhp_lfa_sof_bus.error <= NO_ERRORS;
            end
         end 
         else begin
            fhp_lfa_sof_valid <= 1'b0;
            fhp_lfa_sof_bus.sof_fmt <= NONE;
            fhp_lfa_sof_bus.error <= NO_ERRORS;
         end 
      end 
   end 
   
   function lz_symbol_bus_t func_map_tlv_to_lz;
      input tlvp_if_bus_t tlv_in;
      lz_symbol_bus_t lz_out;
      begin
         lz_out.length       = tlv_in.tdata[15:0];
         lz_out.offset_msb   = tlv_in.tdata[23:16];
         lz_out.backref_lane = tlv_in.tdata[25:24];
         lz_out.backref_type = tlv_in.tdata[26];
         lz_out.backref      = tlv_in.tdata[27];
         lz_out.data3        = tlv_in.tdata[35:28];
         lz_out.data2        = tlv_in.tdata[43:36];
         lz_out.data1        = tlv_in.tdata[51:44];
         lz_out.data0        = tlv_in.tdata[59:52];
         lz_out.framing      = tlv_in.tdata[63:60];
         func_map_tlv_to_lz = lz_out;
      end
   endfunction 

   assign pfx_phd_error = (set_pfx_crc_error ? HD_FHP_PFX_CRC :
                           (set_phd_crc_error ? HD_FHP_PHD_CRC : NO_ERRORS));
   
   cr_xp10_decomp_fe_crc crc_chks (.clk (clk),
                                   .rst_n (rst_n),
                                   .sof(pfx_phd_crc_sof),
                                   .crc_in (pfx_phd_crc_in),
                                   .data_in (pfx_phd_crc_data),
                                   .data_sz (7'd64),
                                   .crc_out (pfx_phd_crc_out));

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         phd_sof_wrd <= 1'b1;
         
         
         pfx_crc <= 0;
         pfx_phd_crc_in <= 0;
         phd_crc <= 0;
         r_set_pfx_crc_error <= 0;
         r_set_phd_crc_error <= 0;
         sent_pfx_last <= 0;
         sent_phd_last <= 0;
         set_pfx_crc_error <= 0;
         set_phd_crc_error <= 0;
         
      end
      else begin
         r_set_pfx_crc_error <= set_pfx_crc_error;
         r_set_phd_crc_error <= set_phd_crc_error;
         if (fhp_htf_bl_valid && fhp_htf_bl_bus.last)
           phd_sof_wrd <= 1'b1;
         else if (fhp_htf_bl_valid)
           phd_sof_wrd <= 1'b0;

         pfx_phd_crc_in <= (fhp_lz_prefix_valid || (fhp_htf_bl_valid && htf_fhp_bl_ready)) ? 
                           pfx_phd_crc_out : pfx_phd_crc_in;
         
         if (fhp_lz_prefix_valid && fhp_lz_prefix_dp_bus.last) begin
            sent_pfx_last <= 1'b1;
            pfx_crc <= pfx_phd_crc_out;
         end
         else if (chk_pfx_crc) begin
            sent_pfx_last <= 1'b0;
            pfx_crc <= '0;
         end
         
         if (fhp_htf_bl_valid && fhp_htf_bl_bus.last) begin
            sent_phd_last <= 1'b1;
            phd_crc <= pfx_phd_crc_out;
         end
         else if (chk_phd_crc) begin
            sent_phd_last <= 1'b0;
            phd_crc <= '0;
         end

         


         if (fhp_lfa_sof_valid) begin
            set_pfx_crc_error <= 1'b0;
         end
         else if (chk_pfx_crc) begin               
            if (prefix_crc_word != switch_crc_bytes(pfx_crc)) begin
               set_pfx_crc_error <= 1'b1;
            end
         end
         if (fhp_lfa_sof_valid) begin
            set_phd_crc_error <= 1'b0;
         end
         else if (chk_phd_crc) begin
            if (phd_crc_word != switch_crc_bytes(phd_crc)) begin
               set_phd_crc_error <= 1'b1;
            end
         end
      end
   end 

   function logic [31:0] switch_crc_bytes;
      input [31:0] crc_in;
      begin
         switch_crc_bytes = ~crc_in;
      end
   endfunction 


   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         chu4k_stb <= 0;
         chu8k_stb <= 0;
         fhp_stall_stb <= 0;
         gzip_frm_stb <= 0;
         lfa_stall_stb <= 0;
         pfx_crc_err_stb <= 0;
         phd_crc_err_stb <= 0;
         xp10_frm_pdh_stb <= 0;
         xp10_frm_pfx_stb <= 0;
         xp10_frm_stb <= 0;
         xp9_frm_stb <= 0;
         xp9_raw_frm_stb <= 0;
         zlib_frm_stb <= 0;
         
      end
      else begin
         if (fhp_lfa_sof_valid && trace_bit) begin
            xp9_frm_stb <= xp9_frm;
            xp10_frm_stb <= xp10_frm;
            xp9_raw_frm_stb <= xp9_raw;
            gzip_frm_stb <= gzip_frm;
            zlib_frm_stb <= zlib_frm;
            chu4k_stb <= chu4k;
            chu8k_stb <= chu8k;
         end
         else begin
            xp9_frm_stb <= 1'b0;
            xp10_frm_stb <= 1'b0;
            xp9_raw_frm_stb <= 1'b0;
            gzip_frm_stb <= 1'b0;
            zlib_frm_stb <= 1'b0;
            chu4k_stb <= 1'b0;
            chu8k_stb <= 1'b0;
         end 

         if (set_pfx_crc_error && !r_set_pfx_crc_error && trace_bit)
           pfx_crc_err_stb <= 1'b1;
         else
           pfx_crc_err_stb <= 1'b0;

         if (set_phd_crc_error && !r_set_phd_crc_error && trace_bit)
           phd_crc_err_stb <= 1'b1;
         else
           phd_crc_err_stb <= 1'b0;
         
         if (fhp_tlvp_usr_rd && trace_bit) begin
            if (fhp_tlvp_usr_tlv.sot) begin
               if (fhp_tlvp_usr_tlv.typen == PHD) begin
                  xp10_frm_pdh_stb <= 1'b1;
                  xp10_frm_pfx_stb <= 1'b0;
               end
               else if (fhp_tlvp_usr_tlv.typen == PFD) begin
                  xp10_frm_pdh_stb <= 1'b0;
                  xp10_frm_pfx_stb <= 1'b1;
               end
            end
            else begin
               xp10_frm_pdh_stb <= 1'b0;
               xp10_frm_pfx_stb <= 1'b0;
            end
         end 
         else begin
            xp10_frm_pdh_stb <= 1'b0;
            xp10_frm_pfx_stb <= 1'b0;
         end 

         if ((!fhp_tlvp_pt_empty && !fhp_tlvp_pt_rd && trace_bit) ||
             (!fhp_tlvp_usr_empty && !fhp_tlvp_usr_rd && trace_bit))
           fhp_stall_stb <= 1'b1;
         else
           fhp_stall_stb <= 1'b0;

         if (!fhp_tlvp_usr_empty && !lfa_fhp_dp_ready && trace_bit)
           lfa_stall_stb <= 1'b1;
         else
           lfa_stall_stb <= 1'b0;
      end
   end
   
   
   always_comb
     begin
        xp9_frm = 1'b0;
        xp10_frm = 1'b0;
        gzip_frm = 1'b0;
        zlib_frm = 1'b0;
        chu4k = 1'b0;
        chu8k = 1'b0;
        xp9_raw = 1'b0;
        if (fhp_lfa_sof_valid && trace_bit) begin
           case (fhp_lfa_sof_bus.sof_fmt)
             NONE : xp9_raw = 1'b1;
             XP9 : xp9_frm = 1'b1;
             XP10 : xp10_frm = 1'b1;
             GZIP: gzip_frm = 1'b1;
             ZLIB: zlib_frm = 1'b1;
             CHU4K : chu4k = 1'b1;
             CHU8K : chu8k = 1'b1;
             default : xp9_raw = 1'b0;
           endcase 
        end 
     end
      

   function logic [2:0] convert_tstrb_2_bytes_valid;
      input [7:0] tstrb;
      logic [2:0] bvalid;

      begin
         case (tstrb)
           8'b00000000 : bvalid = 3'b000;
           8'b00000001 : bvalid = 3'b001;
           8'b00000011 : bvalid = 3'b010;
           8'b00000111 : bvalid = 3'b011;
           8'b00001111 : bvalid = 3'b100;
           8'b00011111 : bvalid = 3'b101;
           8'b00111111 : bvalid = 3'b110;
           8'b01111111 : bvalid = 3'b111;
           8'b11111111 : bvalid = 3'b000;
           default : bvalid = 4'b0;
         endcase 
         convert_tstrb_2_bytes_valid = bvalid;
      end
   endfunction 

   
   nx_fifo #(.DEPTH (8), .WIDTH ($bits(fhp_htf_bl_bus_t)))
   bl_fifo (.empty (bl_fifo_empty),
             .full (),
             .used_slots (bl_fifo_used),
             .free_slots (),
             .rdata (bl_fifo_rbus),
             .clk (clk),
             .rst_n (rst_n),
             .wen (int_htf_bl_valid),
             .ren (bl_fifo_rd),
             .clear (1'b0),
             .underflow (),
             .overflow (),
             .wdata (int_htf_bl_bus));

   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         r_bl_fifo_rbus <= 0;
         wait_for_bl_ack <= 0;
         
      end
      else begin
         if (bl_fifo_rd)
           r_bl_fifo_rbus <= bl_fifo_rbus;
         
         if (htf_fhp_bl_ready)
           wait_for_bl_ack <= 1'b0;
         else if (fhp_htf_bl_valid)
           wait_for_bl_ack <= 1'b1;
      end
   end 
   
endmodule 








