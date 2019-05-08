/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
















`include "crPKG.svp"
`include "cr_crcgc.vh"

module cr_crcgc_cts #
(
 parameter  STUB_MODE=0
 ) 
  (
  
  usr_ib_rd, usr_ob_wr, usr_ob_tlv, cts_data_valid,
  cts_data, cts_data_vbytes, cts_crc_init, cts_crc_sof, cts_hb,
  cts_raw_data_cksum_good_se, cts_crc64e_cksum_good_se,
  cts_enc_cmp_data_cksum_good_se, cts_nvme_raw_cksum_good_se,
  cts_raw_data_cksum_err_se, cts_crc64e_cksum_err_se,
  cts_enc_cmp_data_cksum_err_se, cts_nvme_raw_cksum_err_se,
  
  clk, rst_n, cceip_cfg, crcgc_mode, crcgc_module_id, regs_crc_gen_en,
  regs_crc_chk_en, usr_ib_tlv, usr_ib_empty,
  usr_ib_aempty, usr_ob_full, usr_ob_afull, xp10crc64, xp10crc32,
  crc64e, gzipcrc32, crc16t, adler32
  );
            
`include "cr_structs.sv"
      
  import cr_crcgcPKG::*;
  import cr_crcgc_regsPKG::*;

  
  
  
  input                                 clk;
  input                                 rst_n;
  
  
  
  
  input                                 cceip_cfg;
  input [2:0]                           crcgc_mode;
  input [`MODULE_ID_WIDTH-1:0]          crcgc_module_id;
  input                                 regs_crc_gen_en;
  input                                 regs_crc_chk_en;

 
  
  
  
  input  tlvp_if_bus_t                  usr_ib_tlv;
  input  logic                          usr_ib_empty;
  input  logic                          usr_ib_aempty;
  output logic                          usr_ib_rd;
    
  
  
  
  input                                 usr_ob_full;
  input                                 usr_ob_afull;
  output logic                          usr_ob_wr;
  output tlvp_if_bus_t                  usr_ob_tlv;

  
  
  
  
  input [63:0]                          xp10crc64;
  input [31:0]                          xp10crc32;
  input [63:0]                          crc64e;
  input [31:0]                          gzipcrc32;
  input [15:0]                          crc16t;
  input [31:0]                          adler32;
  
  
  
  
  output logic                          cts_data_valid;
  output logic [63:0]                   cts_data;
  output logic [`AXI_S_TSTRB_WIDTH-1:0] cts_data_vbytes;
  output logic                          cts_crc_init;
  output logic                          cts_crc_sof;
  
   
  
  
  
  output logic [95:0]                   cts_hb[7:0];
   
  
  
  
  output logic                          cts_raw_data_cksum_good_se;
  output logic                          cts_crc64e_cksum_good_se;
  output logic                          cts_enc_cmp_data_cksum_good_se ;
  output logic                          cts_nvme_raw_cksum_good_se;
      
  output logic                          cts_raw_data_cksum_err_se;
  output logic                          cts_crc64e_cksum_err_se;
  output logic                          cts_enc_cmp_data_cksum_err_se ;
  output logic                          cts_nvme_raw_cksum_err_se;
     
  
  
  
  logic [6:0]                           cts_cmd_frmd_out_type;
  cmd_md_type_e          cts_cmd_md_type;
  cmd_xp10_crc_mode_e    cts_cmd_xp10_crc_mode;
  cmd_comp_mode_e        cts_cmd_comp_mode;
  tlv_types_e            cts_frmd_type;
  tlv_cmd_word_1_t       cts_cmd_tlv0_word_1;  
  tlv_cmd_word_2_t       cts_cmd_tlv0_word_2;  
  tlvp_if_bus_t          cts_usr_ib_tlv0;
  logic                  cts_usr_ib_tlv0_valid;
  
  cmd_debug_t            cts_dp_debug_cmd;

  logic                  gen_xp10crc64_raw;
  logic                  gen_xp10crc64_enc;
  logic                  chk_xp10crc64_raw;
  logic                  chk_xp10crc64_enc;
  logic                  gen_crc16t;
  logic                  chk_crc16t;
  logic                  gen_crc64e;
  logic                  chk_crc64e;
  logic                  gen_xp10crc32;
  logic                  gen_gzipcrc32;
  logic                  gen_adler32;
   
  logic [13:0]           cts_word_num;
  logic [13:0]           cts_debug_word_num;
  tlv_cmd_word_1_t       cts_cmd_word1;    
  cmd_debug_t            cts_cmd_dp_debug; 
  logic                  cts_corrupt_data;
  
  tlv_word_0_t           cts_tlv0_word_0; 
  logic [63:0]           cts_crc_result;
  logic [7:0]            cts_seq_num;
  logic [10:0]           cts_frame_num;
  logic                  cts_crcc_en;
  logic                  cts_crcc_err;
  logic                  cts_hb_wr;
  logic [2:0]            cts_hb_add;
  logic [95:0]           cts_hb_wrdata;
  logic                  gen_xp10crc64_raw_crcgc0;
  logic                  gen_xp10crc64_raw_crcg0;
  logic                  chk_xp10crc64_raw_crcgc0;
  logic                  chk_xp10crc64_raw_crcc1;
  logic                  gen_xp10crc64_proto;

  logic                  cts_raw_data_cksum_match;
  logic                  cts_enc_cmp_data_cksum_match;
  logic                  cts_nvme_raw_cksum_match;
  logic                  cts_crc64e_cksum_match;
  
  logic                  cts_raw_data_cksum_err;
  logic                  cts_raw_data_cksum_good;
  
  logic                  cts_crc64e_cksum_err;
  logic                  cts_crc64e_cksum_good;
  
  logic                  cts_enc_cmp_data_cksum_err ;
  logic                  cts_enc_cmp_data_cksum_good ;
  
  logic                  cts_nvme_raw_cksum_err;
  logic                  cts_nvme_raw_cksum_good;
  
  zipline_error_e        cts_error_code;
  logic                  cts_dp_cmd_wr;
  tlv_types_e            cts_dp_type;
  logic [63:0]           cts_debuq_word_msk;
  logic                  cts_stall;
 
  logic                  cts_raw_data_cksum_err_r;
  logic                  cts_raw_data_cksum_good_r;
  
  logic                  cts_crc64e_cksum_err_r ;
  logic                  cts_crc64e_cksum_good_r ;
  
  logic                  cts_enc_cmp_data_cksum_err_r;
  logic                  cts_enc_cmp_data_cksum_good_r;
  
  logic                  cts_nvme_raw_cksum_err_r;
  logic                  cts_nvme_raw_cksum_good_r;
     
  logic                  cts_trace_on;
  logic [10:0]           cts_frame_number;
  
   
  tlv_ftr_word5_t        cts_ftr_word5;
  tlv_ftr_word11_t       cts_ftr_word11;
  tlv_ftr_word12_t       cts_ftr_word12;
  tlv_ftr_word13_t       cts_ftr_word13;
  tlv_ftr_word13_t       cts_ftr_word13err;

  logic [13:0]           raw_crc_word_num;
  logic [13:0]           enc_cmp_crc_word_num;
  logic [13:0]           nvme_crc_word_num;
  logic [13:0]           proto_crc_word_num;
  logic [13:0]           enc_crc_word_num;
  
  assign proto_crc_word_num = 14'd6;
  assign enc_crc_word_num   = 14'd11;
  
  
  generate if (STUB_MODE)
    begin
      assign raw_crc_word_num     = 14'd5;
      assign enc_cmp_crc_word_num = 14'd11;
      assign nvme_crc_word_num    = 14'd12;
    end
  else
    begin
      assign raw_crc_word_num     = ((cceip_cfg  && (crcgc_mode == 3'd2)) |  (~cceip_cfg  && (crcgc_mode == 3'd4))) ? 14'd11 : 14'd5;
      assign enc_cmp_crc_word_num = ((cceip_cfg  && (crcgc_mode == 3'd2)) |  (~cceip_cfg  && (crcgc_mode == 3'd4))) ? 14'd17 : 14'd11;
      assign nvme_crc_word_num    = ((cceip_cfg  && (crcgc_mode == 3'd2)) |  (~cceip_cfg  && (crcgc_mode == 3'd4))) ? 14'd18 : 14'd12;
    end
  endgenerate
  
    
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  
  
  
  
  assign gen_xp10crc64_raw_crcgc0 =((cceip_cfg  && (crcgc_mode == 3'd0)) & 
                                   ((cts_frmd_type == FRMD_USER_NULL) | 
                                    (cts_frmd_type == FRMD_USER_PI16) |
                                    ((cts_frmd_type == FRMD_USER_PI64) & (cts_cmd_md_type == NO_CRC )) |
                                    (cts_frmd_type == FRMD_USER_VM) ));
  
  assign gen_xp10crc64_raw_crcg0 =((~cceip_cfg && (crcgc_mode == 3'd4)) & 
                                   (({1'b0,cts_cmd_frmd_out_type} == FRMD_USER_VM) |
                                   (({1'b0,cts_cmd_frmd_out_type} == FRMD_USER_PI64) & (cts_cmd_md_type == CRC_8B_CRC64 ))));
  
  assign gen_xp10crc64_raw = gen_xp10crc64_raw_crcgc0 | gen_xp10crc64_raw_crcg0;

  assign gen_xp10crc64_proto = ((cceip_cfg  && (crcgc_mode == 3'd0)) & 
                                ((cts_cmd_xp10_crc_mode == CRC64) & 
                                 ((cts_cmd_comp_mode == XP10) |
                                  (cts_cmd_comp_mode == CHU4K) |
                                  (cts_cmd_comp_mode == CHU8K))));
  
  assign gen_xp10crc64_enc = (cceip_cfg  && (crcgc_mode == 3'd1));
  
  assign gen_crc16t    = (~cceip_cfg && (crcgc_mode == 3'd4)) & ({1'b0,cts_cmd_frmd_out_type} == FRMD_USER_PI16);
  
  assign gen_crc64e    = (~cceip_cfg && (crcgc_mode == 3'd4)) & ({1'b0,cts_cmd_frmd_out_type} == FRMD_USER_PI64) 
                                                              & (cts_cmd_md_type == CRC_8B_CRC64E);  

  assign gen_xp10crc32 = (cceip_cfg  && (crcgc_mode == 3'd0)) & (cts_cmd_xp10_crc_mode == CRC32) &
                         ((cts_cmd_comp_mode == XP10) |
                          (cts_cmd_comp_mode == CHU4K) |
                          (cts_cmd_comp_mode == CHU8K));
 
  assign gen_gzipcrc32 = (cceip_cfg  && (crcgc_mode == 3'd0)) & (cts_cmd_comp_mode == GZIP); 
  assign gen_adler32   = (cceip_cfg  && (crcgc_mode == 3'd0)) & (cts_cmd_comp_mode == ZLIB);


  
  
  
  assign chk_xp10crc64_raw_crcgc0 = ((cceip_cfg  && (crcgc_mode == 3'd0)) & 
                                    (((cts_frmd_type == FRMD_USER_PI64) & (cts_cmd_md_type == CRC_8B_CRC64)) |
                                     (cts_frmd_type == FRMD_USER_VM) & (~cts_cmd_md_type[1])));
  
  assign chk_xp10crc64_raw_crcc1 =  ((cceip_cfg  && (crcgc_mode == 3'd2)) &
                                    ((cts_frmd_type == FRMD_USER_NULL) |
                                     (cts_frmd_type == FRMD_USER_PI16) | 
                                     ((cts_frmd_type == FRMD_USER_PI64) & (cts_cmd_md_type == CRC_8B_CRC64)) |
                                     (cts_frmd_type == FRMD_USER_VM)));
  
  assign chk_xp10crc64_raw = chk_xp10crc64_raw_crcgc0 | chk_xp10crc64_raw_crcc1;
  
  
  assign chk_xp10crc64_enc = (cceip_cfg  & (crcgc_mode == 3'd3)) |
                             (~cceip_cfg & (crcgc_mode == 3'd3) && 
                             ((cts_frmd_type == FRMD_INT_APP) |
                              (cts_frmd_type == FRMD_INT_SIP) | 
                              (cts_frmd_type == FRMD_INT_LIP) |
                              (cts_frmd_type == FRMD_INT_VM)  |
                              (cts_frmd_type == FRMD_INT_VM_SHORT))) ;

  
  assign chk_crc16t    = (cts_frmd_type == FRMD_USER_PI16) &
                         ((cceip_cfg  && (crcgc_mode == 3'd2)) |
                         (cceip_cfg  && (crcgc_mode == 3'd0))); 

  
  assign chk_crc64e    = ((cts_frmd_type == FRMD_USER_PI64) & (cts_cmd_md_type == CRC_8B_CRC64E)) &
                         ((cceip_cfg  && (crcgc_mode == 3'd2)) |
                         (cceip_cfg  && (crcgc_mode == 3'd0)));
  
  
  assign cts_crcc_en = (chk_xp10crc64_raw | chk_xp10crc64_enc | chk_crc16t | chk_crc64e) & regs_crc_chk_en;
  
 
  assign cts_raw_data_cksum_match     = (cts_ftr_word5.raw_data_cksum == xp10crc64);
  assign cts_enc_cmp_data_cksum_match = (cts_ftr_word11.enc_cmp_data_cksum == xp10crc64);
  assign cts_nvme_raw_cksum_match     = (cts_ftr_word12.nvme_raw_cksum_crc16t == crc16t);
  assign cts_crc64e_cksum_match       = (cts_ftr_word5.raw_data_cksum == crc64e) ;
      
  assign cts_crcc_err = cts_raw_data_cksum_err | 
                        cts_enc_cmp_data_cksum_err | 
                        cts_nvme_raw_cksum_err | 
                        cts_crc64e_cksum_err;
  
  
  always_comb begin
    case ({cceip_cfg,crcgc_mode})
      4'b1011: cts_error_code = CRCC0_CRC_ERROR;  
      4'b1010: cts_error_code = CRCC1_CRC_ERROR;  
      4'b1001: cts_error_code = CRCG0_CRC_ERROR;  
      4'b1000: cts_error_code = CRCGC0_CRC_ERROR; 
      4'b0100: cts_error_code = CRCDG0_CRC_ERROR; 
      4'b0011: cts_error_code = CRCDC0_CRC_ERROR; 
      default: cts_error_code = CRCCG_CRC_ERROR;
    endcase 
  end
  
  
  
  assign cts_ftr_word5 = tlv_ftr_word5_t'(cts_usr_ib_tlv0.tdata);
  assign cts_ftr_word11 = tlv_ftr_word11_t'(cts_usr_ib_tlv0.tdata);
  assign cts_ftr_word12 = tlv_ftr_word12_t'(cts_usr_ib_tlv0.tdata);
  assign cts_ftr_word13 = tlv_ftr_word13_t'(cts_usr_ib_tlv0.tdata);
  always @(*) begin
    cts_ftr_word13err = tlv_ftr_word13_t'(cts_usr_ib_tlv0.tdata);
    cts_ftr_word13err.error_code = cts_error_code;
    cts_ftr_word13err.errored_frame_number = cts_frame_number;
  end
  


   
  assign cts_tlv0_word_0     = tlv_word_0_t'(cts_usr_ib_tlv0);
  assign cts_cmd_tlv0_word_1 = tlv_cmd_word_1_t'(cts_usr_ib_tlv0);
  assign cts_cmd_tlv0_word_2 = tlv_cmd_word_2_t'(cts_usr_ib_tlv0);
  assign cts_cmd_word1       = tlv_cmd_word_1_t'(cts_usr_ib_tlv0.tdata); 
   
  
  
  
  assign cts_dp_cmd_wr = (cts_cmd_word1.debug.tlvp_corrupt==USER) & 
                          (cts_cmd_word1.debug.module_id == crcgc_module_id) &
                          (cts_cmd_word1.debug.cmd_type == DATAPATH_CORRUPT);
  
  assign cts_dp_type = tlv_types_e'({3'd0,cts_dp_debug_cmd.tlv_num});
  
  assign cts_debug_word_num = {4'd0,(cts_dp_debug_cmd.byte_num >> 3)};
  assign cts_debuq_word_msk = cts_dp_debug_cmd.byte_msk << ({cts_dp_debug_cmd.byte_num[2:0],3'b000});
   
  
  
  
  assign cts_stall = usr_ob_afull;   
  assign usr_ib_rd = ~usr_ib_empty & ~cts_stall;
  
  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      
      cts_usr_ib_tlv0 <= 0;
      cts_usr_ib_tlv0_valid <= 1'b0;
            
      cts_data <= 0;
      cts_data_vbytes <= 0;
      cts_data_valid <= 1'b0;
      cts_word_num <= 14'd0;
      cts_crc_init <= 1'b0;
      cts_crc_sof <= 1'b0;
      
      cts_cmd_md_type <= NO_CRC;
      cts_cmd_frmd_out_type <= 0;
      cts_cmd_comp_mode <= NONE;
      cts_cmd_xp10_crc_mode <= CRC32;

      cts_frmd_type <= RQE;
      cts_dp_debug_cmd <= 0;
      
      cts_cmd_dp_debug   <= 0;
      cts_corrupt_data <= 1'b0;
      
      cts_crc_result <= 64'd0;
      cts_seq_num <= 8'd0;
      cts_frame_num <= 11'd0;
      
      usr_ob_wr <= 1'b0;
      usr_ob_tlv <= 0;
      
      cts_frame_number <= 0;
      
      cts_raw_data_cksum_err <= 1'b0;
      cts_raw_data_cksum_good <= 1'b0;
      
      cts_crc64e_cksum_err   <= 1'b0;
      cts_crc64e_cksum_good   <= 1'b0;
      
      cts_enc_cmp_data_cksum_err <= 1'b0;
      cts_enc_cmp_data_cksum_good <= 1'b0;
      
      cts_nvme_raw_cksum_err <= 1'b0;
      cts_nvme_raw_cksum_good <= 1'b0;
      cts_trace_on <= 1'b0;
      
    end
    else begin
      
      
      if(usr_ib_rd) begin
        cts_usr_ib_tlv0     <= usr_ib_tlv;
      end
      
      cts_usr_ib_tlv0_valid <= usr_ib_rd;
      
      
      
      if(usr_ib_rd & usr_ib_tlv.sot) begin
        cts_word_num <= 14'd0;
      end
      else if(usr_ib_rd && ~cts_word_num[13]) begin
        cts_word_num <= cts_word_num + 1'b1;
      end
      
      
      if(cts_usr_ib_tlv0_valid) begin
        case(cts_usr_ib_tlv0.typen)
          CMD:
            begin
              cts_data_valid <= 1'b0;
              cts_data_vbytes <= 0;
              usr_ob_wr <= 1'b0;
              if(cts_word_num == 14'd1) begin
                cts_cmd_md_type <= cts_cmd_tlv0_word_1.md_type;
                cts_cmd_frmd_out_type <= cts_cmd_tlv0_word_1.frmd_out_type;
                cts_trace_on <= cts_cmd_tlv0_word_1.trace;
                
                
                if((cts_cmd_word1.debug.tlvp_corrupt==TLVP) && 
                   (cts_cmd_word1.debug.module_id == crcgc_module_id) &&
                   (cts_cmd_word1.debug.cmd_type == DATAPATH_CORRUPT)) 
                begin
                   cts_dp_debug_cmd <= cts_cmd_word1.debug;
                end
                
                if( cts_dp_cmd_wr &&
                    ((cts_cmd_word1.debug.cmd_mode == SINGLE_ERR) ||
                     (cts_cmd_word1.debug.cmd_mode == CONTINUOUS_ERROR)))
                begin
                  cts_corrupt_data <= 1'b1;
                end
                else if (cts_dp_cmd_wr && (cts_cmd_word1.debug.cmd_mode == STOP)) begin
                   cts_corrupt_data <= 1'b0;
                end
              end 
              
              if(cts_word_num == 14'd2) begin
                cts_cmd_comp_mode     <= cts_cmd_tlv0_word_2.comp_mode;
                cts_cmd_xp10_crc_mode <= cts_cmd_tlv0_word_2.xp10_crc_mode;
              end
            end 
          
          LZ77,
          DATA,
          DATA_UNK:
            begin
              usr_ob_wr       <= 1'b0;
              cts_data_valid  <= ~cts_usr_ib_tlv0.sot;
              cts_crc_init    <= cts_usr_ib_tlv0.sot;
              
              if (cts_usr_ib_tlv0.sot) begin
                cts_seq_num <= cts_tlv0_word_0.tlv_seq_num;
                cts_frame_num <= cts_tlv0_word_0.tlv_frame_num;
                cts_data_vbytes <=  0;
              end
              else begin
                cts_data_vbytes <=  cts_usr_ib_tlv0.tstrb;
              end
              if(cts_word_num == 14'd1) begin
                cts_crc_sof <= 1'b1;
              end
              else begin
                cts_crc_sof <= 1'b0;
              end
              
              
              
              cts_data <= cts_usr_ib_tlv0.tdata;
            end

          FTR:
            begin
              cts_data_valid <= 1'b0;
              cts_data_vbytes <= 0;
              usr_ob_wr <= 1'b1;
         
              
              
              if(cts_usr_ib_tlv0.sot) begin
                cts_frame_number <=  cts_tlv0_word_0.tlv_frame_num;
              end
              
              if((cts_word_num == raw_crc_word_num) && regs_crc_chk_en ) begin
                cts_raw_data_cksum_err <= chk_xp10crc64_raw & ~cts_raw_data_cksum_match;
                cts_raw_data_cksum_good <= chk_xp10crc64_raw & cts_raw_data_cksum_match;
                
                cts_crc64e_cksum_err   <= chk_crc64e        & ~cts_crc64e_cksum_match;
                cts_crc64e_cksum_good   <= chk_crc64e        & cts_crc64e_cksum_match;
              end
              if((cts_word_num == enc_cmp_crc_word_num) && regs_crc_chk_en) begin
                cts_enc_cmp_data_cksum_err <= chk_xp10crc64_enc & ~cts_enc_cmp_data_cksum_match;
                cts_enc_cmp_data_cksum_good <= chk_xp10crc64_enc & cts_enc_cmp_data_cksum_match;
              end
              if((cts_word_num == nvme_crc_word_num) && regs_crc_chk_en) begin
                cts_nvme_raw_cksum_err <= chk_crc16t & ~cts_nvme_raw_cksum_match;
                cts_nvme_raw_cksum_good <= chk_crc16t & cts_nvme_raw_cksum_match;
              end
              
          
              
              usr_ob_tlv <= cts_usr_ib_tlv0;
              
              
              
              
              
              
              
              
              if ((cts_word_num == raw_crc_word_num) && regs_crc_gen_en && gen_xp10crc64_raw)  begin
                usr_ob_tlv.tdata <= xp10crc64;
                cts_crc_result   <= xp10crc64;
              end
              else if((cts_word_num == raw_crc_word_num) && regs_crc_gen_en && gen_crc64e) begin
                usr_ob_tlv.tdata <= crc64e;
                cts_crc_result   <= crc64e;
              end
              else if((cts_word_num == proto_crc_word_num) && regs_crc_gen_en && gen_xp10crc64_proto)  begin
                usr_ob_tlv.tdata <= xp10crc64;
                cts_crc_result   <= xp10crc64;
              end
              else if((cts_word_num == proto_crc_word_num) && regs_crc_gen_en && gen_xp10crc32) begin
                usr_ob_tlv.tdata <= {32'd0,xp10crc32};
                cts_crc_result   <= {32'd0,xp10crc32};
              end
              else if((cts_word_num == proto_crc_word_num) && regs_crc_gen_en && gen_gzipcrc32) begin
                usr_ob_tlv.tdata <= {32'd0,gzipcrc32};
                cts_crc_result   <= {32'd0,gzipcrc32};
              end
              else if((cts_word_num == proto_crc_word_num) && regs_crc_gen_en && gen_adler32) begin
                usr_ob_tlv.tdata <= {32'd0,adler32};
                cts_crc_result   <= {32'd0,adler32};
              end
              else if((cts_word_num == enc_crc_word_num) && regs_crc_gen_en && gen_xp10crc64_enc) begin
                usr_ob_tlv.tdata <= xp10crc64;
                cts_crc_result   <= xp10crc64;
              end
              else if((cts_word_num == nvme_crc_word_num) && regs_crc_gen_en && gen_crc16t) begin 
                usr_ob_tlv.tdata <= {crc16t,cts_ftr_word12.bytes_in,cts_ftr_word12.bytes_out};
                cts_crc_result   <= {48'd0,crc16t};
              end
              
              
              
              else if(cts_usr_ib_tlv0.eot &&(cts_ftr_word13.error_code == 0) && (cts_crcc_err))   begin
                usr_ob_tlv.tdata <= cts_ftr_word13err;
              end
              
              if(cts_usr_ib_tlv0.eot) begin
                cts_raw_data_cksum_err <= 1'b0;
                cts_raw_data_cksum_good <= 1'b0;
                
                cts_crc64e_cksum_err   <= 1'b0;
                cts_crc64e_cksum_good   <= 1'b0;
                
                cts_enc_cmp_data_cksum_err <= 1'b0;
                cts_enc_cmp_data_cksum_good <= 1'b0;
                
                cts_nvme_raw_cksum_err <= 1'b0;
                cts_nvme_raw_cksum_good <= 1'b0;
              end
              
                
            end 

          FRMD_USER_NULL,
          FRMD_USER_PI16,
          FRMD_USER_PI64,
          FRMD_USER_VM,
          FRMD_INT_APP,
          FRMD_INT_SIP,
          FRMD_INT_LIP,
          FRMD_INT_VM,
          FRMD_INT_VM,
          FRMD_INT_VM_SHORT:
            begin
              cts_data_valid <= 1'b0;
              cts_data_vbytes <= 0;
              usr_ob_wr <= 1'b0;
              cts_frmd_type <= cts_usr_ib_tlv0.typen;
            end
          


          default:
            begin
              cts_data_valid <= 1'b0;
              cts_data_vbytes <= 0;
              usr_ob_wr <= 1'b0;
            end
        endcase 
                

        
        
        
        if (cts_corrupt_data && (cts_debug_word_num == cts_word_num) && 
           (cts_usr_ib_tlv0.typen == cts_dp_type)) 
        begin
          cts_data   <= cts_usr_ib_tlv0.tdata ^ cts_debuq_word_msk;
                
          if( cts_dp_debug_cmd.cmd_mode == SINGLE_ERR) begin
            cts_corrupt_data <= 1'b0;
          end
        end
      end 
      
      else begin
        cts_data_valid <= 1'b0;
        cts_data_vbytes <= 0;
        cts_crc_sof <= 1'b0;
        usr_ob_wr <= 1'b0;
      end 
    end 
  end 
  
  
  
  
  assign cts_hb_wr = usr_ob_wr && (usr_ob_tlv.typen == FTR) && usr_ob_tlv.eot;
  
  assign cts_hb_wrdata = {25'd0,cts_hb_wr,cts_crcc_err,cts_crcc_en,cts_frame_num,cts_seq_num,cts_crc_result};
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      for (int i=0; i<8; i++) begin
        cts_hb[i] <= 96'd0;
      end
       cts_hb_add <= 3'd0;
       
    end
    else begin
      if(cts_hb_wr) begin
         cts_hb_add <= cts_hb_add + 1'b1;
         cts_hb[cts_hb_add] <= cts_hb_wrdata;
      end
    end
  end
  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      cts_raw_data_cksum_err_r       <= 1'b0;
      cts_raw_data_cksum_good_r      <= 1'b0;
      cts_raw_data_cksum_err_se      <= 1'b0;
      cts_raw_data_cksum_good_se     <= 1'b0;
      
      cts_crc64e_cksum_err_r         <= 1'b0;
      cts_crc64e_cksum_good_r        <= 1'b0;
      cts_crc64e_cksum_err_se        <= 1'b0;
      cts_crc64e_cksum_good_se       <= 1'b0;
      
      cts_enc_cmp_data_cksum_err_r   <= 1'b0;
      cts_enc_cmp_data_cksum_good_r  <= 1'b0;
      cts_enc_cmp_data_cksum_err_se  <= 1'b0;
      cts_enc_cmp_data_cksum_good_se <= 1'b0;
      
      cts_nvme_raw_cksum_err_r       <= 1'b0;
      cts_nvme_raw_cksum_good_r      <= 1'b0;
      cts_nvme_raw_cksum_err_se      <= 1'b0;
      cts_nvme_raw_cksum_good_se     <= 1'b0;
    end
    else begin
      cts_raw_data_cksum_err_r      <= cts_raw_data_cksum_err;
      cts_raw_data_cksum_good_r     <= cts_raw_data_cksum_good;
      
      cts_crc64e_cksum_err_r        <= cts_crc64e_cksum_err;
      cts_crc64e_cksum_good_r       <= cts_crc64e_cksum_good;
      
      cts_enc_cmp_data_cksum_err_r  <= cts_enc_cmp_data_cksum_err;
      cts_enc_cmp_data_cksum_good_r <= cts_enc_cmp_data_cksum_good;
      
      cts_nvme_raw_cksum_err_r      <= cts_nvme_raw_cksum_err;
      cts_nvme_raw_cksum_good_r     <= cts_nvme_raw_cksum_good;
      
      cts_raw_data_cksum_err_se      <= cts_raw_data_cksum_err  & cts_trace_on & ~cts_raw_data_cksum_err_r;
      cts_raw_data_cksum_good_se     <= cts_raw_data_cksum_good & cts_trace_on & ~cts_raw_data_cksum_good_r;
      
      cts_crc64e_cksum_err_se        <= cts_crc64e_cksum_err & cts_trace_on & ~cts_crc64e_cksum_err_r;
      cts_crc64e_cksum_good_se       <= cts_crc64e_cksum_good & cts_trace_on & ~cts_crc64e_cksum_good_r;
      
      cts_enc_cmp_data_cksum_err_se  <= cts_enc_cmp_data_cksum_err & cts_trace_on & ~cts_enc_cmp_data_cksum_err_r;
      cts_enc_cmp_data_cksum_good_se <= cts_enc_cmp_data_cksum_good & cts_trace_on & ~cts_enc_cmp_data_cksum_good_r;
      
      cts_nvme_raw_cksum_err_se      <= cts_nvme_raw_cksum_err & cts_trace_on & ~cts_nvme_raw_cksum_err_r;
      cts_nvme_raw_cksum_good_se     <= cts_nvme_raw_cksum_good & cts_trace_on & ~cts_nvme_raw_cksum_good_r;
      
    end
  end
       
       
     
       
endmodule 
