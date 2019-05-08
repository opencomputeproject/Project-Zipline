/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


















`include "crPKG.svp"
`include "cr_prefix_attach.vh"

module cr_prefix_attach_pac 
  (
  
  pac_stall, pac_phd_check_valid_ack, pac_pfd_check_valid_ack,
  pac_usr_ob_wr, pac_usr_ob_tlv,
  
  clk, rst_n, cceip_cfg, pfd_mem_dout, phd_mem_dout,
  ibp_ld_phd_crc_addr, ibp_ld_pfd_crc_addr, ibp_tlv, ibp_tlv_valid,
  ibp_insert_phd_req, ibp_insert_pfd_req, ibp_insert_true,
  pmc_phd_crc_error, pmc_pfd_crc_error, pmc_phd_check_valid,
  pmc_pfd_check_valid, pmc_phd_crc_valid, pmc_pfd_crc_valid,
  pmc_phd_crc, pmc_pfd_crc, usr_ob_full, usr_ob_afull
  );
            
`include "cr_structs.sv"
      
  import cr_prefix_attachPKG::*;
  import cr_prefix_attach_regsPKG::*;

  
  
  
  input                clk;
  input                rst_n; 
        
  
  
  
  input                cceip_cfg;

  
  
  
  input  pfd_t         pfd_mem_dout;
  
  
  
  
  input  phd_t         phd_mem_dout;

  
  
  
  input logic          ibp_ld_phd_crc_addr;
  input logic          ibp_ld_pfd_crc_addr;
  
  
  input  tlvp_if_bus_t ibp_tlv;
  input  logic         ibp_tlv_valid;
  input  logic         ibp_insert_phd_req;
  input  logic         ibp_insert_pfd_req;
  input logic          ibp_insert_true;
  output logic         pac_stall;
  
  
  
  
  input logic         pmc_phd_crc_error;
  input logic         pmc_pfd_crc_error;
  input logic         pmc_phd_check_valid;
  input logic         pmc_pfd_check_valid;
  
  input logic         pmc_phd_crc_valid;
  input logic         pmc_pfd_crc_valid;
  input logic [31:0]  pmc_phd_crc;
  input logic [31:0]  pmc_pfd_crc;
  
  output logic        pac_phd_check_valid_ack;
  output logic        pac_pfd_check_valid_ack;
  
  

  
  
  
  input                usr_ob_full;
  input                usr_ob_afull; 
  output logic         pac_usr_ob_wr;
  output tlvp_if_bus_t pac_usr_ob_tlv;


  
  tlvp_if_bus_t        pac_tlv_dunk_w0;
  tlvp_if_bus_t        pac_tlv_dunk_w1;
  tlvp_if_bus_t        pac_ibp_tlv_ftr_word_0;
  tlv_word_0_t         pac_ibp_tlv_ftr_word_0_data;
  
  logic                pac_dunk_w0_valid;
  logic                pac_dunk_w1_valid;
  
  
  tlv_word_0_t         pac_phd_tlv_tdata;
  tlv_cmd_word_2_t     pac_ibp_tlv_word_2_data;
  tlv_ftr_word13_t     pac_ftr_word13;
  tlv_ftr_word13_t     pac_ftr_word13err;
  
  logic                pac_error;
  logic [3:0]          pac_word_num;
  logic                pac_phd_error;
  logic                pac_pfd_error;
  

  
  assign pac_ibp_tlv_word_2_data = tlv_cmd_word_2_t'(ibp_tlv.tdata);
  assign pac_ibp_tlv_ftr_word_0_data = tlv_word_0_t'(pac_ibp_tlv_ftr_word_0.tdata);
  
  
  
  
  always_comb begin
    pac_phd_tlv_tdata = ibp_tlv.tdata;
    pac_phd_tlv_tdata.resv0         = 0;
  end
  
 
  
  
  
  assign pac_ftr_word13 = tlv_ftr_word13_t'(ibp_tlv.tdata);
 
  always @ (*) begin
    pac_ftr_word13err = tlv_ftr_word13_t'(ibp_tlv.tdata);
    pac_ftr_word13err.errored_frame_number = pac_ibp_tlv_ftr_word_0_data.tlv_frame_num;
    
    if(pac_phd_error) begin
      pac_ftr_word13err.error_code = PREFIX_ATTACH_PHD_CRC_ERROR;
    end
    else if (pac_pfd_error) begin
      pac_ftr_word13err.error_code = PREFIX_ATTACH_PFD_CRC_ERROR;
    end
    else begin
      pac_ftr_word13err.error_code = NO_ERRORS;
    end
  end 
  
  assign pac_error = pac_phd_error | pac_pfd_error;
  
  
  
  assign pac_stall = (ibp_tlv_valid & (ibp_tlv.typen==DATA_UNK) & (pac_word_num==4'd1)) |
                            pac_dunk_w1_valid; 

  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      pac_usr_ob_tlv     <= 0;
      pac_usr_ob_wr      <= 1'b0;
      pac_tlv_dunk_w0  <= 0;
      pac_tlv_dunk_w1  <= 0;
      pac_dunk_w0_valid <= 1'b0;
      pac_dunk_w1_valid <= 1'b0;
      pac_word_num <= 4'd0;
      pac_ibp_tlv_ftr_word_0 <= 0;
      pac_phd_check_valid_ack <= 1'b0;
      pac_phd_error <= 1'b0;
      pac_pfd_check_valid_ack <= 1'b0;
      pac_pfd_error <= 1'b0;
      
    end
    else begin 
      
      
      
      if(ibp_tlv_valid & ibp_tlv.eot) begin
        pac_word_num <= 4'd0;
      end
      else if(ibp_tlv_valid && ~pac_word_num[3]) begin
        pac_word_num <= pac_word_num + 1'b1;
      end
  
      
      
      
      if(pmc_phd_check_valid) begin
        pac_phd_error <= pmc_phd_crc_error;
        pac_phd_check_valid_ack <= 1'b1;
      end
      else if(pac_usr_ob_wr && (pac_usr_ob_tlv.typen==FTR) &&pac_usr_ob_tlv.eot) begin
        pac_phd_error <= 1'b0;
      end
      else begin
        pac_phd_check_valid_ack <= 1'b0;
      end
      
      if(pmc_pfd_check_valid) begin
        pac_pfd_error <= pmc_pfd_crc_error;
        pac_pfd_check_valid_ack <= 1'b1;
      end
      else if(pac_usr_ob_wr && (pac_usr_ob_tlv.typen==FTR) &&pac_usr_ob_tlv.eot) begin
        pac_pfd_error <= 1'b0;
      end
      else begin
        pac_pfd_check_valid_ack <= 1'b0;
      end
        
  
      
      
      
      if(pac_dunk_w0_valid & ibp_tlv_valid & ~ibp_insert_true) begin
        pac_usr_ob_wr <= 1'b1;
        pac_usr_ob_tlv <= pac_tlv_dunk_w0;
        pac_dunk_w0_valid <= 1'b0;
        pac_dunk_w1_valid <= 1'b1;
      end
      else if(pac_dunk_w0_valid & pac_dunk_w1_valid & ~ibp_insert_true) begin
        pac_usr_ob_wr <= 1'b1;
        pac_usr_ob_tlv <= pac_tlv_dunk_w0;
        pac_dunk_w0_valid <= 1'b0;
      end
      else if( pac_dunk_w1_valid & ~ibp_insert_true) begin
        pac_usr_ob_wr <= 1'b1;
        pac_usr_ob_tlv <= ibp_tlv;
        pac_dunk_w1_valid <= 1'b0;
      end
      
      else if(ibp_tlv_valid) begin
        case(ibp_tlv.typen)
          CMD:
            begin
              pac_usr_ob_wr <= 1'b0;
            end
          
          PHD:
            begin
              pac_usr_ob_wr <= 1'b1;
              if(ibp_insert_phd_req) begin
                if(ibp_tlv.sot) begin
                  pac_usr_ob_tlv <= ibp_tlv;
                  pac_usr_ob_tlv.tdata <= pac_phd_tlv_tdata;
                end
                else if(ibp_tlv.eot) begin
                  pac_usr_ob_tlv <= ibp_tlv;
                  pac_usr_ob_tlv.tdata <= {32'd0,pmc_phd_crc};
                end
                else begin
                  pac_usr_ob_tlv <= ibp_tlv;
                  pac_usr_ob_tlv.tdata <= phd_mem_dout;
                end
              end 
             
              else begin 
                  pac_usr_ob_tlv <= ibp_tlv; 
              end 
            end 
          
          PFD:
            begin
              pac_usr_ob_wr <= 1'b1;
              if(ibp_insert_pfd_req) begin
                if(ibp_tlv.sot) begin
                  pac_usr_ob_tlv <= ibp_tlv;
                end
                else if(ibp_tlv.eot) begin
                  pac_usr_ob_tlv <= ibp_tlv;
                  pac_usr_ob_tlv.tdata <= {32'd0,pmc_pfd_crc};
                end
                else begin
                  pac_usr_ob_tlv <= ibp_tlv;
                  pac_usr_ob_tlv.tdata <= pfd_mem_dout;
                end
              end 
              else begin
                pac_usr_ob_tlv <= ibp_tlv;
              end 
            end 
          
          DATA_UNK:
            begin
              if(ibp_tlv.sot & ~ibp_tlv.eot) begin
                pac_usr_ob_wr  <= 1'b0;
                pac_tlv_dunk_w0 <=ibp_tlv;
                pac_dunk_w0_valid <= 1'b1;
              end
              else if (pac_word_num==4'd1) begin
                pac_dunk_w1_valid <= 1'b1;
              end
              else begin
                pac_usr_ob_wr  <= 1'b1;
                pac_usr_ob_tlv <= ibp_tlv;
              end
              
            end 
          
          FTR:
            begin
              pac_usr_ob_wr  <= 1'b1;
              pac_usr_ob_tlv <= ibp_tlv;
              
              if(ibp_tlv.sot) begin
                pac_ibp_tlv_ftr_word_0 <= ibp_tlv;
              end
              
              if(ibp_tlv.eot && (pac_ftr_word13.error_code == 0) && 
                 pac_error) 
              begin
                pac_usr_ob_tlv.tdata <= pac_ftr_word13err;
              end
              
            end 
          default:
            begin
              pac_usr_ob_tlv <= ibp_tlv;
              pac_usr_ob_wr <= 1'b1;
            end
        endcase 
      end 
      else begin
        pac_usr_ob_wr <= 1'b0;
      end 
    end 
  end 
  
  

endmodule 









