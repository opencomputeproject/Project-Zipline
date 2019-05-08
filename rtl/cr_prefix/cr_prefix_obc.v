/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/














`include "crPKG.svp"
`include "cr_prefix.vh"

module cr_prefix_obc
  (
  
  obc_bp_tlv_rd, usr_ob_wr, usr_ob_tlv, obc_pf_ren,
  prefix_stat_events,
  
  clk, rst_n, bp_tlv_empty, bp_tlv, usr_ob_full, usr_ob_afull,
  pf_data, pf_empty, pf_aempty
  );
            
`include "cr_structs.sv"
      
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;

  
  
  
  input                       clk;
  input                       rst_n; 
         
  
  
  
  input                       bp_tlv_empty;
  input                       tlvp_if_bus_t bp_tlv;
  output                      obc_bp_tlv_rd;
  
  
  
  
  
  input                       usr_ob_full;
  input                       usr_ob_afull; 
  output logic                usr_ob_wr;
  output tlvp_if_bus_t        usr_ob_tlv;

  
  
  
  input [8:0]                 pf_data;
  input                       pf_empty;
  input                       pf_aempty;
  output logic                obc_pf_ren;

  
  
  
  output logic [`PREFIX_STATS_WIDTH-1:0] prefix_stat_events;

  
  
  
  tlvp_if_bus_t        obc_phd_tlv; 
  tlvp_if_bus_t        obc_pfd_tlv; 
  tlvp_if_bus_t        obc_bp_tlv0;
  tlvp_if_bus_t        obc_bp_tlv0_frmd_word_0;
  
  tlv_word_0_t         obc_bp_tlv0_frmd_word_0_data;
  tlv_cmd_word_1_t     bp_tlv_word_1_data;
  tlv_cmd_word_2_t     bp_tlv_word_2_data;
  
  tlv_word_0_t         obc_phd_tlv_tdata;
  tlv_word_0_t         obc_pfd_tlv_tdata;
  
  logic                obc_bp_tlv0_valid;
  logic                obc_trace_on;
  
   
  logic                obc_prefix_mode_phd ;
  logic                obc_prefix_mode_pfd ;
  logic                obc_insert_prefix;
  
    
  logic [7:0]          obc_pfdcounter;
  logic [7:0]          obc_phdcounter;

  logic [5:0]          obc_ib_prefix_num;
  logic [5:0]          obc_prefix_num;
  logic [5:0]          obc_pf_num;
  logic                obc_pf_num_valid;
  logic                obc_write_prefix;
  logic                obc_pf_num_validp1;
  
  
  logic                obc_busy;
  logic                obc_stall;

  logic                obc_us_busy;
  logic                obc_pf_error;
  logic                obc_us_error0;
  logic                obc_us_error;
  zipline_error_e       obc_error_code;
  
  tlv_ftr_word13_t    obc_ftr_word13;
  tlv_ftr_word13_t    obc_ftr_word13err;
  
  integer                         ii;

   
  
  always_comb begin
    for(ii=0;ii<64;ii=ii+1) begin
      prefix_stat_events[ii] =  obc_trace_on & ~obc_pf_num_valid & obc_pf_num_validp1 & ( obc_pf_num == ii[5:0]);
    end
  end
  
  assign bp_tlv_word_1_data = tlv_cmd_word_1_t'(bp_tlv.tdata);
  assign bp_tlv_word_2_data = tlv_cmd_word_2_t'(bp_tlv.tdata);
  assign obc_bp_tlv0_frmd_word_0_data = tlv_word_0_t'(obc_bp_tlv0_frmd_word_0.tdata);
  
  
  
  
  always_comb begin
    obc_phd_tlv = obc_bp_tlv0_frmd_word_0;
    obc_phd_tlv.insert = 1'b1;
    obc_phd_tlv.typen  = PHD;
    obc_phd_tlv.sot    = (obc_phdcounter == `CR_PREFIX_N_PHD_WORDS); 
    obc_phd_tlv.eot    = (obc_phdcounter == 1); 
    obc_phd_tlv.tuser  = {obc_bp_tlv0_frmd_word_0.tuser[7:2],(obc_phdcounter == 1),(obc_phdcounter == `CR_PREFIX_N_PHD_WORDS)};

  
    obc_phd_tlv_tdata.tlv_bip2      = obc_bp_tlv0_frmd_word_0_data.tlv_bip2;
    obc_phd_tlv_tdata.resv0         = {13'd0,obc_prefix_num};
    obc_phd_tlv_tdata.tlv_frame_num = obc_bp_tlv0_frmd_word_0_data.tlv_frame_num;
    obc_phd_tlv_tdata.resv1         = obc_bp_tlv0_frmd_word_0_data.resv1;
    obc_phd_tlv_tdata.tlv_eng_id    = obc_bp_tlv0_frmd_word_0_data.tlv_eng_id;
    obc_phd_tlv_tdata.tlv_seq_num   = obc_bp_tlv0_frmd_word_0_data.tlv_seq_num;
    obc_phd_tlv_tdata.tlv_len       = (`CR_PREFIX_N_PHD_WORDS * 8) / 4;
    obc_phd_tlv_tdata.tlv_type      = PHD;
  
    obc_phd_tlv.tdata  = obc_phd_tlv_tdata;
    
  end
  
  
  
  
  assign obc_pfd_tlv.insert = 1'b0;
  assign obc_pfd_tlv.ordern = obc_bp_tlv0_frmd_word_0.ordern;
  assign obc_pfd_tlv.typen  = PFD;
  assign obc_pfd_tlv.sot    = (obc_pfdcounter == `CR_PREFIX_N_PFD_WORDS); 
  assign obc_pfd_tlv.eot    = (obc_pfdcounter == 1); 
  assign obc_pfd_tlv.tlast  = obc_bp_tlv0_frmd_word_0.tlast;
  assign obc_pfd_tlv.tid    = obc_bp_tlv0_frmd_word_0.tid;
  assign obc_pfd_tlv.tstrb  = obc_bp_tlv0_frmd_word_0.tstrb;
  assign obc_pfd_tlv.tuser  = {obc_bp_tlv0_frmd_word_0.tuser[7:2],(obc_pfdcounter == 1),(obc_pfdcounter == `CR_PREFIX_N_PFD_WORDS)};
   
  assign obc_pfd_tlv_tdata.tlv_bip2      = obc_bp_tlv0_frmd_word_0_data.tlv_bip2;
  assign obc_pfd_tlv_tdata.resv0         = {13'd0,obc_prefix_num};
  assign obc_pfd_tlv_tdata.tlv_frame_num = obc_bp_tlv0_frmd_word_0_data.tlv_frame_num;
  assign obc_pfd_tlv_tdata.resv1         = obc_bp_tlv0_frmd_word_0_data.resv1;
  assign obc_pfd_tlv_tdata.tlv_eng_id    = obc_bp_tlv0_frmd_word_0_data.tlv_eng_id;
  assign obc_pfd_tlv_tdata.tlv_seq_num   = obc_bp_tlv0_frmd_word_0_data.tlv_seq_num;
  assign obc_pfd_tlv_tdata.tlv_len       = 0;
  assign obc_pfd_tlv_tdata.tlv_type      = PFD;
  
  assign obc_pfd_tlv.tdata  = obc_pfd_tlv_tdata;
                         
  
  
  
  assign obc_ftr_word13 = tlv_ftr_word13_t'(obc_bp_tlv0);
  always @ (*) begin
    obc_ftr_word13err = tlv_ftr_word13_t'(obc_bp_tlv0);
    obc_ftr_word13err.errored_frame_number = obc_bp_tlv0_frmd_word_0_data.tlv_frame_num;
    obc_ftr_word13err.error_code = obc_error_code;
  end
  
  
  
  
  
  assign obc_stall = usr_ob_full | ( usr_ob_afull & usr_ob_wr) | obc_busy | obc_write_prefix;
  assign obc_bp_tlv_rd = ~bp_tlv_empty & ~obc_stall;
  assign obc_pf_ren = ~pf_empty & ~obc_pf_num_valid;
  
  
  
  

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      obc_bp_tlv0       <= 0;
      obc_bp_tlv0_valid <= 1'b0;
      obc_bp_tlv0_frmd_word_0 <= 0;
      
      usr_ob_tlv <= 0;
      usr_ob_wr  <= 1'b0;
      obc_busy   <= 1'b0;
      obc_prefix_mode_phd <= 1'b0;
      obc_prefix_mode_pfd <= 1'b0;
      obc_insert_prefix <= 1'b0;
      
      obc_pfdcounter <= 0;
      obc_phdcounter <= 0;
      obc_us_busy <= 1'b0;
      
      obc_pf_num <= 0;
      obc_pf_num_valid <= 1'b0;
      obc_ib_prefix_num   <= 0;
      obc_prefix_num <= 0;
      obc_write_prefix <= 1'b0;
      
      
      obc_pf_error <= 1'b0;
      obc_us_error0 <= 1'b0;
      obc_us_error <= 1'b0;
      obc_error_code <= NO_ERRORS;
      obc_trace_on <= 1'b0;
      obc_pf_num_validp1 <= 1'b0;
      

    end
    else begin
      obc_pf_num_validp1 <= obc_pf_num_valid;
      
      
      
      
      if(obc_pf_ren) begin
        obc_pf_num_valid <= 1'b1;
        obc_error_code <= zipline_error_e'(pf_data[7:0]);
        if (pf_data[8]) begin 
          obc_pf_error <= 1'b1;
          obc_pf_num <= 0;
        end
        else begin
          obc_pf_error <= 1'b0;
          obc_pf_num <= pf_data[5:0];
        end
      end 
        
      
      
      

      if(obc_bp_tlv_rd) begin
        obc_bp_tlv0 <= bp_tlv;
        obc_us_error <= obc_us_error0;
      end
      if(~obc_stall) begin
        obc_bp_tlv0_valid <= obc_bp_tlv_rd;
      end
      
      if (obc_bp_tlv_rd) begin
        case(bp_tlv.typen)
          CMD:
            begin
              if (bp_tlv.eot) begin 
                
                obc_prefix_mode_phd <= (bp_tlv_word_2_data.xp10_prefix_mode ==PREDET_HUFF);
              
                obc_prefix_mode_pfd <= (bp_tlv_word_2_data.xp10_prefix_mode ==PREDET_HUFF) |
                                       (bp_tlv_word_2_data.xp10_prefix_mode ==PREDEF_PREFIX);
                obc_ib_prefix_num   <= bp_tlv_word_2_data.xp10_user_prefix_size;
                obc_busy <= 1'b0;
              end
              if(~bp_tlv.sot && ~bp_tlv.eot) begin
                obc_trace_on <= bp_tlv_word_1_data.trace;
              end
            end 
          
          FRMD_USER_NULL,
          FRMD_USER_PI16,
          FRMD_USER_PI64,
          FRMD_USER_VM:
            begin
              if (bp_tlv.sot) begin
                
                if(obc_prefix_mode_pfd && (obc_ib_prefix_num != 0)) begin
                  obc_busy <= 1'b0;
                  obc_insert_prefix <= 1'b1;
                  obc_prefix_num <= obc_ib_prefix_num;
                  obc_us_error0 <= 1'b0;
                end
                
                else if(obc_prefix_mode_pfd && obc_pf_num_valid) begin
                  obc_insert_prefix <= (obc_pf_num !=0);
                  obc_prefix_num <=obc_pf_num;
                  obc_pf_num_valid <= 1'b0;
                  obc_us_error0 <= obc_pf_error;
                end
                
                else if (obc_prefix_mode_pfd) begin
                  obc_busy <= 1'b1;
                end
                
                else begin
                  obc_busy <= 1'b0;
                  obc_insert_prefix <= 1'b0;
                  obc_us_error0 <= 1'b0;
                end
              end 
            end
          default:
            begin
              obc_busy <= 1'b0;
            end
        endcase 
      end 
      
      else if (obc_busy) begin
        
        if(obc_prefix_mode_pfd && obc_pf_num_valid ) begin
          obc_busy <= 1'b0;
          obc_insert_prefix <= (obc_pf_num !=0);
          obc_prefix_num <=obc_pf_num;
          obc_pf_num_valid <= 1'b0;
          obc_us_error0 <= obc_pf_error;
        end
        
        else if (obc_prefix_mode_pfd) begin
          obc_busy <= 1'b1;
       end
      end 
      
 
      
      
      
               
      if(obc_bp_tlv0_valid && ~obc_stall) begin
        case(obc_bp_tlv0.typen)
          
          CMD:
            begin
              usr_ob_wr  <= 1'b0;
              usr_ob_tlv <= obc_bp_tlv0;
            end 
          
          FRMD_USER_NULL,
          FRMD_USER_PI16,
          FRMD_USER_PI64,
          FRMD_USER_VM:
            begin
              usr_ob_wr  <= 1'b1;
              usr_ob_tlv <= obc_bp_tlv0;
              usr_ob_tlv.insert <= obc_insert_prefix;
              if(obc_bp_tlv0.sot) begin
                obc_bp_tlv0_frmd_word_0 <= obc_bp_tlv0;
              end
              
              if(obc_bp_tlv0.eot && obc_insert_prefix) begin
                obc_pfdcounter <= `CR_PREFIX_N_PFD_WORDS;
                obc_phdcounter <= `CR_PREFIX_N_PHD_WORDS;
                obc_write_prefix <= 1'b1;
              end
            end
          
          FTR:
            begin
              usr_ob_wr  <= 1'b1;
              usr_ob_tlv <= obc_bp_tlv0;
              
              if(obc_bp_tlv0.eot && (obc_ftr_word13.error_code == 0) && 
                 obc_us_error) 
              begin
                usr_ob_tlv.tdata <= obc_ftr_word13err;
              end
            end
          
          default:
            begin
              obc_pfdcounter <= 0;
              obc_phdcounter <= 0;
              usr_ob_wr <= 1'b1;
              usr_ob_tlv <= obc_bp_tlv0;
            end
        endcase 
      end 
      
      
      
      
      else if(obc_prefix_mode_phd && (obc_phdcounter > 0) && obc_write_prefix) begin
        if(usr_ob_full | ( usr_ob_afull & usr_ob_wr)) begin
          usr_ob_wr <= 1'b0;
        end
        else begin
          obc_phdcounter <= obc_phdcounter - 1'b1;
          obc_us_busy <= 1'b0;
          usr_ob_wr  <= 1'b1;
          usr_ob_tlv <= obc_phd_tlv;
          if(obc_phdcounter != `CR_PREFIX_N_PHD_WORDS) begin
            usr_ob_tlv.tdata <= 0;
          end
        end 
      end 

      
      
      
      else if(obc_prefix_mode_pfd && (obc_pfdcounter > 0) && obc_write_prefix) begin
        if(usr_ob_full | ( usr_ob_afull & usr_ob_wr)) begin
          usr_ob_wr <= 1'b0;
        end
        else begin
          obc_pfdcounter <= obc_pfdcounter - 1'b1;
          obc_us_busy <= 1'b0;
          usr_ob_wr  <= 1'b1;
          usr_ob_tlv <= obc_pfd_tlv;
          obc_write_prefix <= ~obc_pfd_tlv.eot;
          if(obc_pfdcounter != `CR_PREFIX_N_PFD_WORDS) begin
            usr_ob_tlv.tdata <= 0;
          end
        end 
      end
      else begin
        usr_ob_wr <= 1'b0;
      end 
    end 
  end 


  
endmodule 











