/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


















`include "crPKG.svp"
`include "cr_prefix_attach.vh"

module cr_prefix_attach_pti 
  (
  
  pti_insert_phd_inwrk, pti_insert_pfd_inwrk, pti_insert_pfd_ack,
  pti_usr_ob_sel, pti_usr_ob_wr, pti_usr_ob_tlv,
  
  clk, rst_n, cceip_cfg, ibp_insert_phd_req, ibp_insert_pfd_req,
  ibp_tlv, ibp_tlv_valid, ibp_prefix_num, pfd_mem_dout, phd_mem_dout,
  pmc_phd_crc, pmc_pfd_crc, pmc_phd_eot, pmc_pfd_eot,
  pmc_phd_dout_valid, pmc_pfd_dout_valid
  );
            
`include "cr_structs.sv"
      
  import cr_prefix_attachPKG::*;
  import cr_prefix_attach_regsPKG::*;

  
  
  
  input                clk;
  input                rst_n; 
        
  
  
  
  input                cceip_cfg;
  
  
  
  
  input                ibp_insert_phd_req;
  input                ibp_insert_pfd_req;
  
  input  tlvp_if_bus_t ibp_tlv;
  input                ibp_tlv_valid;
  input logic [5:0]    ibp_prefix_num;

  output logic         pti_insert_phd_inwrk;
  output logic         pti_insert_pfd_inwrk;
  output logic         pti_insert_pfd_ack;
 
  
  
  
  input  pfd_t         pfd_mem_dout;
  
  
  
  
  input  phd_t         phd_mem_dout;
  
  
  
  
  input logic [31:0]   pmc_phd_crc;
  input logic [31:0]   pmc_pfd_crc;
  input logic          pmc_phd_eot;
  input logic          pmc_pfd_eot;
  input logic          pmc_phd_dout_valid;
  input logic          pmc_pfd_dout_valid;

  
  
  
  
  output logic         pti_usr_ob_sel;
  output logic         pti_usr_ob_wr;
  output tlvp_if_bus_t pti_usr_ob_tlv;
  


  
  logic                pti_insert_phd_ack;
  
  
  tlv_word_0_t         pti_ibp_tlv_tdata;
  tlv_word_0_t         pti_phd_tlv_tdata;
  tlv_word_0_t         pti_pfd_tlv_tdata;
  tlv_data_word_0_t    pti_ibp_tlv_word0_data;
  
  assign pti_ibp_tlv_tdata = tlv_word_0_t'(ibp_tlv.tdata);
  
  
  
  
  
  always@ (*) begin
    if(ibp_tlv_valid && ibp_tlv.sot && (ibp_tlv.typen==DATA_UNK)) begin
     pti_phd_tlv_tdata               = pti_ibp_tlv_tdata;
     pti_phd_tlv_tdata.resv0         = 0;
     pti_phd_tlv_tdata.tlv_frame_num = pti_ibp_tlv_tdata.tlv_frame_num;
     pti_phd_tlv_tdata.resv1         = pti_ibp_tlv_tdata.resv1;
     pti_phd_tlv_tdata.tlv_eng_id    = pti_ibp_tlv_tdata.tlv_eng_id ;
     pti_phd_tlv_tdata.tlv_seq_num   = pti_ibp_tlv_tdata.tlv_seq_num;
     pti_phd_tlv_tdata.tlv_len       = (`CR_PREFIX_N_PHD_WORDS * 8) / 4;
     pti_phd_tlv_tdata.tlv_type      = PHD;
    
     pti_pfd_tlv_tdata               = pti_ibp_tlv_tdata;
     pti_pfd_tlv_tdata.resv0         = {13'd0,ibp_prefix_num};
     pti_pfd_tlv_tdata.tlv_frame_num = pti_ibp_tlv_tdata.tlv_frame_num;
     pti_pfd_tlv_tdata.resv1         = pti_ibp_tlv_tdata.resv1;
     pti_pfd_tlv_tdata.tlv_eng_id    = pti_ibp_tlv_tdata.tlv_eng_id ;
     pti_pfd_tlv_tdata.tlv_seq_num   = pti_ibp_tlv_tdata.tlv_seq_num;
     pti_pfd_tlv_tdata.tlv_len       = 0;
     pti_pfd_tlv_tdata.tlv_type      = PFD;
    end
    else begin
     pti_phd_tlv_tdata               = pti_ibp_tlv_word0_data;
     pti_phd_tlv_tdata.resv0         = 0;
     pti_phd_tlv_tdata.tlv_frame_num = pti_ibp_tlv_word0_data.tlv_frame_num;
     pti_phd_tlv_tdata.resv1         = pti_ibp_tlv_word0_data.resv1;
     pti_phd_tlv_tdata.tlv_eng_id    = pti_ibp_tlv_word0_data.tlv_eng_id ;
     pti_phd_tlv_tdata.tlv_seq_num   = pti_ibp_tlv_word0_data.tlv_seq_num;
     pti_phd_tlv_tdata.tlv_len       = (`CR_PREFIX_N_PHD_WORDS * 8) / 4;
     pti_phd_tlv_tdata.tlv_type      = PHD;
    
     pti_pfd_tlv_tdata               = pti_ibp_tlv_word0_data;
     pti_pfd_tlv_tdata.resv0         = {13'd0,ibp_prefix_num};
     pti_pfd_tlv_tdata.tlv_frame_num = pti_ibp_tlv_word0_data.tlv_frame_num;
     pti_pfd_tlv_tdata.resv1         = pti_ibp_tlv_word0_data.resv1;
     pti_pfd_tlv_tdata.tlv_eng_id    = pti_ibp_tlv_word0_data.tlv_eng_id ;
     pti_pfd_tlv_tdata.tlv_seq_num   = pti_ibp_tlv_word0_data.tlv_seq_num;
     pti_pfd_tlv_tdata.tlv_len       = 0;
     pti_pfd_tlv_tdata.tlv_type      = PFD;
    end 
    
  end
  
 
  
  
  
  
  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      pti_usr_ob_tlv     <= 0;
      pti_usr_ob_wr      <= 1'b0;
      pti_usr_ob_sel     <= 1'b0;
      pti_insert_phd_inwrk <= 1'b0;
      pti_insert_pfd_inwrk <= 1'b0;
      pti_insert_phd_ack <= 1'b0;
      pti_insert_pfd_ack <= 1'b0;
      pti_ibp_tlv_word0_data <= 0;

    end 
    else begin

      
      
      
      
      if(ibp_tlv_valid && ibp_tlv.sot && (ibp_tlv.typen==DATA_UNK)) begin
        pti_ibp_tlv_word0_data <= ibp_tlv.tdata;
      end
      
      
      
      
      if(ibp_insert_phd_req && ~pti_insert_phd_ack) begin
        pti_usr_ob_tlv <= ibp_tlv;
        pti_usr_ob_tlv.insert <= 1'b1;
        pti_usr_ob_tlv.typen  <= PHD;
         
        if(~pti_insert_phd_inwrk) begin
          pti_usr_ob_sel <= ~cceip_cfg;
          pti_usr_ob_wr  <= ~cceip_cfg;
          pti_insert_phd_inwrk  <= 1'b1;
          pti_usr_ob_tlv.sot    <= 1'b1;
          pti_usr_ob_tlv.eot    <= 1'b0;
          pti_usr_ob_tlv.tuser  <= 8'd1;
          pti_usr_ob_tlv.tdata  <= pti_phd_tlv_tdata;
        end
        else if(pmc_phd_eot) begin
          pti_usr_ob_sel <= ~cceip_cfg;
          pti_usr_ob_wr  <= ~cceip_cfg;
          pti_insert_phd_inwrk  <= 1'b0;
          pti_insert_phd_ack    <= ~cceip_cfg;
          pti_usr_ob_tlv.sot    <= 1'b0;
          pti_usr_ob_tlv.eot    <= 1'b1;
          pti_usr_ob_tlv.tuser  <= 8'd2;
          pti_usr_ob_tlv.tdata  <= {32'd0,pmc_phd_crc};
        end
        else if(pmc_phd_dout_valid )begin
          pti_usr_ob_sel <= ~cceip_cfg;
          pti_usr_ob_wr  <= ~cceip_cfg;
          pti_usr_ob_tlv.sot    <= 1'b0;
          pti_usr_ob_tlv.eot    <= 1'b0;
          pti_usr_ob_tlv.tuser  <= 8'd0;
          pti_usr_ob_tlv.tdata  <= phd_mem_dout;
        end 
        else begin
          pti_usr_ob_wr  <= 1'b0;
        end
      end 
      
      
      
      
      else if(ibp_insert_pfd_req && ~pti_insert_pfd_ack) begin
        pti_usr_ob_tlv <= ibp_tlv;
        pti_usr_ob_tlv.insert <= 1'b1;
        pti_usr_ob_tlv.typen  <= PFD;
          
        if(~pti_insert_pfd_inwrk) begin
          pti_usr_ob_sel <= ~cceip_cfg;
          pti_usr_ob_wr  <= ~cceip_cfg;
          pti_insert_pfd_inwrk  <= 1'b1;
          pti_usr_ob_tlv.sot    <= 1'b1;
          pti_usr_ob_tlv.eot    <= 1'b0;
          pti_usr_ob_tlv.tuser  <= 8'd1;
          pti_usr_ob_tlv.tdata  <= pti_pfd_tlv_tdata;
        end
        else if(pmc_pfd_eot) begin
          pti_usr_ob_sel <= ~cceip_cfg;
          pti_usr_ob_wr  <= ~cceip_cfg;
          pti_insert_pfd_inwrk <= 1'b0;
          pti_insert_pfd_ack    <= ~cceip_cfg;
          pti_usr_ob_tlv.sot    <= 1'b0;
          pti_usr_ob_tlv.eot    <= 1'b1;
          pti_usr_ob_tlv.tuser  <= 8'd2;
          pti_usr_ob_tlv.tdata  <= {32'd0,pmc_pfd_crc};
        end
        else if(pmc_pfd_dout_valid)begin
          pti_usr_ob_sel <= ~cceip_cfg;
          pti_usr_ob_wr  <= ~cceip_cfg;
          pti_usr_ob_tlv.sot    <= 1'b0;
          pti_usr_ob_tlv.eot    <= 1'b0;
          pti_usr_ob_tlv.tuser  <= 8'd0;
          pti_usr_ob_tlv.tdata  <= pfd_mem_dout;
        end
        else begin
          pti_usr_ob_wr  <= 1'b0;
        end
      end 
      else if (~ibp_insert_pfd_req) begin
        pti_insert_phd_ack <= 1'b0;
        pti_insert_pfd_ack <= 1'b0;
      end
      else begin
        pti_usr_ob_sel <= 1'b0;
        pti_usr_ob_wr  <= 1'b0;
      end
    end 
  end 
  
    
  

endmodule 









