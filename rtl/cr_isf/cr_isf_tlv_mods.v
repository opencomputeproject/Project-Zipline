/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/





























module cr_isf_tlv_mods
(
  
  ib_bytes_cnt_stb, ib_bytes_cnt_amt, ib_frame_cnt_stb,
  ib_cmd_cnt_stb, isf_fifo_tlvp_rd, isf_tlv_mod_ob_out,
  isf_term_empty, isf_term_tlv, aux_cmd_match0_ev, aux_cmd_match1_ev,
  aux_cmd_match2_ev, aux_cmd_match3_ev, tlvp_error, ib_prot_error,
  
  clk, rst_n, isf_tlv_parse_action_0, isf_tlv_parse_action_1,
  trace_ctl_en_config, trace_ctl_limits_config, ctl_config,
  aux_cmd_ev_mask_val_0_comp_config,
  aux_cmd_ev_mask_val_0_crypto_config,
  aux_cmd_ev_mask_val_1_comp_config,
  aux_cmd_ev_mask_val_1_crypto_config,
  aux_cmd_ev_mask_val_2_comp_config,
  aux_cmd_ev_mask_val_2_crypto_config,
  aux_cmd_ev_mask_val_3_comp_config,
  aux_cmd_ev_mask_val_3_crypto_config,
  aux_cmd_ev_match_val_0_comp_config,
  aux_cmd_ev_match_val_0_crypto_config,
  aux_cmd_ev_match_val_1_comp_config,
  aux_cmd_ev_match_val_1_crypto_config,
  aux_cmd_ev_match_val_2_comp_config,
  aux_cmd_ev_match_val_2_crypto_config,
  aux_cmd_ev_match_val_3_comp_config,
  aux_cmd_ev_match_val_3_crypto_config, isf_tlv_mod_ib_in,
  isf_tlv_mod_ob_in, isf_fifo_empty, isf_fifo_aempty, dbg_cmd_disable,
  xp9_disable, isf_module_id, cceip_cfg
  );
  
`include "cr_structs.sv"
  import cr_isfPKG::*;
  import cr_isf_regsPKG::*;

  
  
  
  input                                    clk;
  input                                    rst_n; 
  
  
  
  
  input  isf_tlv_parse_action_31_0_t       isf_tlv_parse_action_0;
  input  isf_tlv_parse_action_63_32_t      isf_tlv_parse_action_1;
  input  trace_ctl_en_t                    trace_ctl_en_config;
  input  trace_ctl_limits_t                trace_ctl_limits_config; 
  input  ctl_t                             ctl_config;    
  input  aux_cmd_ev_mask_val_0_comp_t      aux_cmd_ev_mask_val_0_comp_config;
  input  aux_cmd_ev_mask_val_0_crypto_t    aux_cmd_ev_mask_val_0_crypto_config;
  input  aux_cmd_ev_mask_val_1_comp_t      aux_cmd_ev_mask_val_1_comp_config;
  input  aux_cmd_ev_mask_val_1_crypto_t    aux_cmd_ev_mask_val_1_crypto_config;
  input  aux_cmd_ev_mask_val_2_comp_t      aux_cmd_ev_mask_val_2_comp_config;
  input  aux_cmd_ev_mask_val_2_crypto_t    aux_cmd_ev_mask_val_2_crypto_config;
  input  aux_cmd_ev_mask_val_3_comp_t      aux_cmd_ev_mask_val_3_comp_config;
  input  aux_cmd_ev_mask_val_3_crypto_t    aux_cmd_ev_mask_val_3_crypto_config;
  input  aux_cmd_ev_match_val_0_comp_t     aux_cmd_ev_match_val_0_comp_config;
  input  aux_cmd_ev_match_val_0_crypto_t   aux_cmd_ev_match_val_0_crypto_config;
  input  aux_cmd_ev_match_val_1_comp_t     aux_cmd_ev_match_val_1_comp_config;
  input  aux_cmd_ev_match_val_1_crypto_t   aux_cmd_ev_match_val_1_crypto_config;
  input  aux_cmd_ev_match_val_2_comp_t     aux_cmd_ev_match_val_2_comp_config;
  input  aux_cmd_ev_match_val_2_crypto_t   aux_cmd_ev_match_val_2_crypto_config;
  input  aux_cmd_ev_match_val_3_comp_t     aux_cmd_ev_match_val_3_comp_config;
  input  aux_cmd_ev_match_val_3_crypto_t   aux_cmd_ev_match_val_3_crypto_config;
  output reg                               ib_bytes_cnt_stb;
  output reg [3:0]                         ib_bytes_cnt_amt;
  output reg                               ib_frame_cnt_stb;
  output reg                               ib_cmd_cnt_stb;

  
  
  
  input  axi4s_dp_bus_t                    isf_tlv_mod_ib_in;
  output                                   isf_fifo_tlvp_rd;

  
  
  
  input  axi4s_dp_rdy_t                    isf_tlv_mod_ob_in;
  output axi4s_dp_bus_t                    isf_tlv_mod_ob_out;

  
  
  
  input                                    isf_fifo_empty;
  input                                    isf_fifo_aempty;

  
  
  
  output                                   isf_term_empty;
  output  tlvp_if_bus_t                    isf_term_tlv;

  
  
  
  output reg                               aux_cmd_match0_ev;  
  output reg                               aux_cmd_match1_ev;  
  output reg                               aux_cmd_match2_ev;  
  output reg                               aux_cmd_match3_ev;  

  
  
  
  output                                   tlvp_error;
  output reg                               ib_prot_error;

  
  
  
  input                                    dbg_cmd_disable;
  input                                    xp9_disable;

  
  
  
  input  [`MODULE_ID_WIDTH-1:0]            isf_module_id;
  input                                    cceip_cfg;

  
  
  
  logic                                    prefix_mode_ok;
  logic                                    isf_term_aempty;
  logic                                    isf_term_rd;
  logic                                    isf_user_afull;
  logic                                    isf_user_full;
  logic                                    isf_user_wr;
  logic                                    xfr_user_wr;
  logic                                    isf_term_rd_rdy;
  logic                                    isf_user_wr_rdy;
  logic                                    xfr_rdy;
  logic [4:0]                              ix_nxt;
  logic                                    start_footer;
  logic                                    start_footer_pulse_nxt;
  logic                                    start_footer_pulse;
  logic                                    user_prefix_ld_nxt;
  logic                                    footer_done_clr_nxt;
  logic                                    start_footer_clr_nxt;
  logic                                    isf_term_tlv_frmd;
  logic [4:0]                              ix;
  logic                                    isf_data_w0_ld;
  logic [1:0]                              isf_rqe_ld;
  logic [1:0]                              isf_cqe_ld;
  logic                                    user_prefix_ld;
  logic [2:0]                              isf_cmd_ld;  
  logic [12:0]                             isf_frmd_ld;
  logic                                    footer_done_clr;
  logic                                    start_footer_clr;
  logic [5:0]                              cmd_xp10_user_prefix_size_reg;
  logic [18:0]                             user_prefix_tlv_bytes; 
  logic [14:0]                             user_prefix_tlv_adj_beats;  
  logic [13:0]                             user_prefix_cnt;
  logic                                    user_prefix_eot;
  logic                                    user_prefix_sot;
  logic                                    user_prefix_sot_nxt;
  logic                                    user_prefix_cnt_en;
  logic                                    user_prefix_ld_save;
  logic                                    footer_done_hld;
  logic                                    start_footer_hld;
  logic                                    isf_cmd_debug_trace;
  logic [1:0]                              footer_bip2;
  logic [3:0]                              rqe_frame_size_reg;
  logic                                    rqe_simple_frame_size;
  logic [`TLV_LEN_WIDTH-1:0]               frmd_len_mux; 
  logic [`TLV_LEN_WIDTH-1:0]               footer_len; 
  logic [`AXI_S_DP_DWIDTH-1:0]             prefix_err_cqe;
  logic [`AXI_S_DP_DWIDTH-1:0]             err_cqe;
  logic [`AXI_S_DP_DWIDTH-1:0]             footer_raw_mac0;
  logic [`AXI_S_DP_DWIDTH-1:0]             footer_raw_mac1;
  logic [`AXI_S_DP_DWIDTH-1:0]             footer_raw_mac2;
  logic [`AXI_S_DP_DWIDTH-1:0]             footer_raw_mac3;
  logic [`AXI_S_DP_DWIDTH-1:0]             footer_raw_cksum;
  logic [`AXI_S_DP_DWIDTH-1:0]             footer_enc_mac0;
  logic [`AXI_S_DP_DWIDTH-1:0]             footer_enc_mac1;
  logic [`AXI_S_DP_DWIDTH-1:0]             footer_enc_mac2;
  logic [`AXI_S_DP_DWIDTH-1:0]             footer_enc_mac3;
  logic [`AXI_S_DP_DWIDTH-1:0]             footer_enc_cksum;
  logic [15:0]                             footer_nvme_raw_cksum_crc16t;
  logic [23:0]                             footer_comp_len;
  logic                                    fgen_user_wr;
  logic                                    footer_done_pulse;
  logic [`AXI_S_DP_DWIDTH-1:0]             isf_frmd_reg [12:0];
  logic                                    user_prefix_vld_reg;
  integer                                  k, j;
  logic [`TLVP_ORD_NUM_WIDTH-1:0]          tlv_mod_ordern;
  logic [`TLVP_ORD_NUM_WIDTH:0]            tlv_mod_ordern_cqe;  
  logic [`TLVP_ORD_NUM_WIDTH-1:0]          data_tlv_ordern;
  logic                                    ib_bytes_cnt_stb_nxt;
  logic [3:0]                              ib_bytes_cnt_amt_nxt;
  logic                                    ib_frame_cnt_stb_nxt;
  logic                                    ib_cmd_cnt_stb_nxt;
  logic                                    prefix_err_nxt;
  logic                                    prefix_err;
  logic                                    prefix_err_ld;
  logic [10:0]                             prefix_err_frame;
  logic                                    comp_match0;
  logic                                    comp_match1;
  logic                                    comp_match2;
  logic                                    comp_match3;
  logic                                    crypto_match0;
  logic                                    crypto_match1;
  logic                                    crypto_match2;
  logic                                    crypto_match3;
  logic                                    ib_prot_error_nxt;
  logic [15:0]                             rqe_que_grp_reg;
  logic                                    queue_ok;
  logic [24:0]                             bytes_in_cnt;   
  logic                                    bytes_in_cnt_clr;
  logic                                    bytes_in_cnt_en;
  logic                                    cmd_stats_en;
  logic [1:0]                              frmd_w0_adj_bip2; 
  logic                                    chu_mismatch0;
  logic                                    chu_mismatch1;
  logic                                    tag_no_chk;
  cmd_xp10_prefix_mode_e                   xp10_prefix_mode_mod;
  cmd_comp_mode_e                          cmd_comp_mode_reg;
  tlv_types_e                              cmd_frmd_out_type_reg;
  tlv_mod_out_sel_e                        out_sel;
  fmd_int_sip_word3_t                      frmd_int_tdata_w3;  
  fmd_int_vm_short_word9_t                 frmd_int_tdata_w9; 
  fmd_int_lip_word6_t                      frmd_int_tdata_w6_lip; 
  fmd_int_app_word6_t                      frmd_int_tdata_w6_app; 
  fmd_int_vm_word12_t                      frmd_int_tdata_w12; 
  frmd_mac_size_e                          footer_enc_mac_size;
  frmd_mac_size_e                          footer_raw_mac_size;
  frmd_coding_e                            footer_coding;
  frmd_coding_e                            user_footer_coding;
  isf_fgen_st_e                            fgen_st;
  isf_fgen_st_e                            fgen_st_nxt;
  isf_user_xfr_st_e                        isf_user_xfr_st;
  isf_user_xfr_st_e                        isf_user_xfr_st_nxt;
  rqe_trace_e                              rqe_trace_reg;
  tlv_cmd_word_1_t                         cmd_tlv_tdata_w1;
  tlv_cmd_word_2_t                         cmd_tlv_tdata_w2;
  tlv_rqe_word_0_t                         rqe_tlv_tdata_w0;  
  tlv_rqe_word_1_t                         rqe_tlv_tdata_w1;  
  tlv_cmd_word_1_t                         cmd_tlv_tdata_w1_out;
  tlv_cmd_word_2_t                         cmd_tlv_tdata_w2_out;
  tlv_data_word_0_t                        data_tlv_tdata_w0_reg; 
  tlv_word_0_t                             tlv_word_0;  
  tlv_word_0_t                             frmd_w0_adj_tdata; 
  tlv_word_0_t                             data_word_0; 
  tlv_word_0_t                             frmd_tdata_w0; 
  tlv_pfd_word0_t                          user_prefix_tlv_tdata_w0;
  tlvp_if_bus_t                            cqe_tlv_w0_reg;
  tlvp_if_bus_t                            cqe_tlv_w1_reg;
  tlvp_if_bus_t                            data_tlv_w0_reg;
  tlvp_if_bus_t                            cmd_tlv_w1;
  tlvp_if_bus_t                            cmd_tlv_w2;
  tlvp_if_bus_t                            data_adj_w0;
  tlvp_if_bus_t                            data_err_w0;
  tlvp_if_bus_t                            data_err_eot;
  tlvp_if_bus_t                            frmd_w0_adj; 
  tlvp_if_bus_t                            user_vm_w2;
  tlvp_if_bus_t                            fgen;
  tlvp_if_bus_t                            isf_term_tlv_mod;
  tlvp_if_bus_t                            isf_term_tlv_cqe;
  tlvp_if_bus_t                            isf_user_tlv;
  tlvp_if_bus_t                            data_tlv_all;
  tlvp_if_bus_t                            user_prefix_tlv_data;
  tlvp_if_bus_t                            user_prefix_tlv_w0;
  tlvp_if_bus_t                            user_prefix_tlv_eot;
  tlvp_if_bus_t                            user_prefix_err_pad;
  tlvp_if_bus_t                            user_prefix_err_pad_eot;



  
  logic                                    isf_user_xfr_stall_nxt;
  logic                                    isf_user_xfr_stall;

  
  
  
   `CCX_STD_CALC_BIP2(get_bip2, `AXI_S_DP_DWIDTH);  
  
  
  
  

  

  cr_tlvp_axi_out_top #
     
  (
   .N_PT_ENTRIES            (0),
   .N_PT_AFULL_VAL          (0),
   .N_PT_AEMPTY_VAL         (0),
   .N_TM_ENTRIES            (8),
   .N_TM_AFULL_VAL          (3),
   .N_TM_AEMPTY_VAL         (1),
   .N_OF_ENTRIES            (16),
   .N_OF_AFULL_VAL          (8),
   .N_OF_AEMPTY_VAL         (1),
   .N_UF_ENTRIES            (8), 
   .N_UF_AFULL_VAL          (2),
   .N_UF_AEMPTY_VAL         (1))
  u_cr_isf_tlvp
  (
   
   
   .tlvp_in_rd                          (isf_fifo_tlvp_rd),      
   .term_empty                          (isf_term_empty),        
   .term_aempty                         (isf_term_aempty),       
   .term_tlv                            (isf_term_tlv),          
   .usr_full                            (isf_user_full),         
   .usr_afull                           (isf_user_afull),        
   .crc_error                           (tlvp_error),            
   .axi4s_ob_out                        (isf_tlv_mod_ob_out),    
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .tlvp_in_aempty                      (isf_fifo_aempty),       
   .tlvp_in_empty                       (isf_fifo_empty),        
   .tlvp_in_data                        (isf_tlv_mod_ib_in),     
   .tlv_parse_action                    ({isf_tlv_parse_action_1,isf_tlv_parse_action_0}), 
   .term_rd                             (isf_term_rd),           
   .usr_wr                              (isf_user_wr),           
   .usr_tlv                             (isf_user_tlv),          
   .axi4s_ob_in                         (isf_tlv_mod_ob_in),     
   .module_id                           (isf_module_id[`MODULE_ID_WIDTH-1:0])); 

  
  
  
  assign isf_user_wr      = xfr_user_wr || fgen_user_wr; 
  assign isf_term_rd_rdy  = !isf_term_empty;
  assign isf_user_wr_rdy  = !isf_user_full;
  assign xfr_rdy          = isf_term_rd_rdy && isf_user_wr_rdy;

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  always_comb
  begin
    
    out_sel                                  = ISF_SEL_LIVE;
    isf_term_rd                              = 1'b0;
    xfr_user_wr                              = 1'b0;
    ix_nxt                                   = ix;
    isf_data_w0_ld                           = 1'b0;
    start_footer_pulse_nxt                   = 1'b0;
    isf_rqe_ld                               = 1'b0; 
    isf_cqe_ld                               = 2'b0;
    user_prefix_ld_nxt                       = 1'b0;
    user_prefix_sot_nxt                      = 1'b0;
    isf_cmd_ld                               = 3'h0; 
    isf_frmd_ld                              = 4'h0; 
    footer_done_clr_nxt                      = 1'b0;
    isf_user_xfr_stall_nxt                   = 1'b0;
    ib_bytes_cnt_stb_nxt                     = 1'b0;
    ib_frame_cnt_stb_nxt                     = 1'b0;
    ib_cmd_cnt_stb_nxt                       = 1'b0;
    prefix_err_nxt                           = prefix_err; 
    prefix_err_ld                            = 1'b0;
    ib_prot_error_nxt                        = 1'b0;
    bytes_in_cnt_clr                         = 1'b0;
    bytes_in_cnt_en                          = 1'b0;

    
    isf_term_tlv_frmd  = (isf_term_tlv.typen == FRMD_USER_NULL) ||
                         (isf_term_tlv.typen == FRMD_USER_PI16) ||
                         (isf_term_tlv.typen == FRMD_USER_PI64) ||
                         (isf_term_tlv.typen == FRMD_USER_VM) ||
                         (isf_term_tlv.typen == FRMD_INT_APP) ||
                         (isf_term_tlv.typen == FRMD_INT_SIP) ||
                         (isf_term_tlv.typen == FRMD_INT_LIP) ||
                         (isf_term_tlv.typen == FRMD_INT_VM)   ||
                         (isf_term_tlv.typen == FRMD_INT_VM_SHORT) ;
                           
    case (isf_user_xfr_st)
      
      
      
      
      
      
      
      UXFR_IDLE:
      begin
        out_sel  = ISF_SEL_LIVE;

        if (xfr_rdy && (isf_term_tlv.typen == RQE) && isf_term_tlv.sot) 
        begin
          isf_term_rd          = 1'b1;
          xfr_user_wr          = 1'b1;
          isf_rqe_ld[0]        = 1'b1;
          isf_user_xfr_st_nxt  = UXFR_RQE_W0;
        end
        
        
        
        
        
        
        else if (xfr_rdy)
        begin
          isf_term_rd          = 1'b1;
          ib_prot_error_nxt    = 1'b1;
          isf_user_xfr_st_nxt  = UXFR_PROT_ERR;
        end
        else
        begin
          isf_user_xfr_st_nxt  = UXFR_IDLE;
        end
      end

      
      
      
      UXFR_RQE_W0:
      begin
        out_sel  = ISF_SEL_LIVE;

        if (xfr_rdy)
        begin
          isf_term_rd          = 1'b1;
          xfr_user_wr          = 1'b1;
          isf_rqe_ld[1]        = 1'b1;
          ix_nxt               = 5'h0;
          isf_user_xfr_st_nxt  = UXFR_CMD_SOT;
        end
        else
        begin
          isf_user_xfr_st_nxt  = UXFR_RQE_W0;
        end
      end

      
      
      UXFR_CMD_SOT:
      begin
        out_sel  = ISF_SEL_LIVE;

        if (xfr_rdy && (isf_term_tlv.typen == CMD) && isf_term_tlv.sot) 
        begin
          isf_term_rd          = 1'b1;
          xfr_user_wr          = 1'b1;
          isf_cmd_ld[ix]       = 1'b1;  
          ix_nxt               = 5'h1; 
          isf_user_xfr_st_nxt  = UXFR_CMD;
        end
        
        else if (xfr_rdy)
        begin
          isf_term_rd          = 1'b1;
          ib_prot_error_nxt    = 1'b1;
          isf_user_xfr_st_nxt  = UXFR_PROT_ERR;
        end
        else
        begin
          ix_nxt               = ix;
          isf_user_xfr_st_nxt  = UXFR_CMD_SOT;
        end
      end

      
      
      
      
      UXFR_CMD:
      begin
        if (xfr_rdy) 
        begin
          isf_term_rd          = 1'b1;
          xfr_user_wr          = 1'b1;
          isf_cmd_ld[ix]       = 1'b1;  
          
          ib_cmd_cnt_stb_nxt   = (ix == 5'h2) && cmd_stats_en ? 1'b1 : 1'b0;  

          ix_nxt               = isf_term_tlv.eot ? 5'h0 : ix+1; 
          out_sel              = (ix == 5'h1) ? ISF_SEL_CMD_W1 : ISF_SEL_CMD_W2;
          isf_user_xfr_st_nxt  = isf_term_tlv.eot ? UXFR_FRMD_SOT : UXFR_CMD;
        end
        else
        begin
          out_sel              = ISF_SEL_LIVE;
          ix_nxt               = ix;
          isf_user_xfr_st_nxt  = UXFR_CMD;
        end
      end

      
      
      UXFR_FRMD_SOT: 
      begin
        out_sel  = ISF_SEL_FRMD_W0;

        if (xfr_rdy && isf_term_tlv_frmd && isf_term_tlv.sot)
        begin
          isf_term_rd          = 1'b1;
          xfr_user_wr          = 1'b1;
          isf_frmd_ld[0]       = 1'b1;  
          
          ix_nxt               = isf_term_tlv.eot ? 5'h0 : ix+1; 
          isf_user_xfr_st_nxt  = isf_term_tlv.eot ? UXFR_DATA_SOT : UXFR_FRMD;
        end
        
        else if (xfr_rdy)
        begin
          isf_term_rd          = 1'b1;
          ib_prot_error_nxt    = 1'b1;
          isf_user_xfr_st_nxt  = UXFR_PROT_ERR;
        end
        else
        begin
          ix_nxt               = ix;
          isf_user_xfr_st_nxt  = UXFR_FRMD_SOT;
        end
      end

      UXFR_FRMD: 
      begin
        out_sel  = ISF_SEL_LIVE;

       if (xfr_rdy && isf_term_tlv_frmd)  
        begin
          isf_term_rd          = 1'b1;

          isf_frmd_ld[ix]      = 1'b1;  
          ix_nxt               = isf_term_tlv.eot ? 5'h0 : ix+1; 
          isf_user_xfr_st_nxt  = isf_term_tlv.eot ? UXFR_DATA_SOT : UXFR_FRMD;

          
          
          
          case (frmd_tdata_w0.tlv_type) 

            
            
            FRMD_USER_VM:  
            begin
              xfr_user_wr  = (ix <= 2)  ? 1'b1 : 1'b0; 
              out_sel      = (ix == 2 ) ? ISF_SEL_USER_VM : ISF_SEL_LIVE; 
            end

            FRMD_INT_APP:      xfr_user_wr  = (ix <= 3) ? 1'b0 : 1'b1; 
            FRMD_INT_SIP:      xfr_user_wr  = (ix <= 2) ? 1'b0 : 1'b1; 
            FRMD_INT_LIP:      xfr_user_wr  = (ix <= 5) ? 1'b0 : 1'b1;
            FRMD_INT_VM:       xfr_user_wr  = (ix <= 9) ? 1'b0 : 1'b1;
            FRMD_INT_VM_SHORT: xfr_user_wr  = (ix <= 6) ? 1'b0 : 1'b1;
            
            default:           xfr_user_wr  = 1'b1; 
          endcase
        end
        else
        begin
          ix_nxt               = ix;
          isf_user_xfr_st_nxt  = UXFR_FRMD;
        end
      end

      
      
      
      UXFR_DATA_SOT:
      begin
        isf_data_w0_ld  = (((isf_term_tlv.typen == DATA) || (isf_term_tlv.typen == DATA_UNK) || (isf_term_tlv.typen == LZ77)) && 
                           (!isf_user_xfr_stall || (isf_user_xfr_stall && xfr_rdy))) ? 1'b1 : 1'b0;

        
        
        if (xfr_rdy && isf_term_tlv.sot &&
        ((isf_term_tlv.typen == DATA) || (isf_term_tlv.typen == DATA_UNK) || (isf_term_tlv.typen == LZ77)))
        begin
          isf_term_rd          = 1'b1;
          xfr_user_wr          = 1'b1;
          ix_nxt               = 5'h0; 
          ib_frame_cnt_stb_nxt = cmd_stats_en ? 1'b1 : 1'b0;
          bytes_in_cnt_clr     = 1'b1;
          user_prefix_sot_nxt  = user_prefix_vld_reg ? 1'b1               : 1'b0;
          user_prefix_ld_nxt   = user_prefix_vld_reg ? 1'b1               : 1'b0;
          out_sel              = user_prefix_vld_reg ? ISF_SEL_PREFIX_SOT : ISF_SEL_DATA;
          isf_user_xfr_st_nxt  = user_prefix_vld_reg ? UXFR_PREFIX : UXFR_DATA;
        end
        
        
        else if (xfr_rdy && isf_term_tlv.sot && 
        ((isf_term_tlv.typen == KEY) || (isf_term_tlv.typen == PHD) || (isf_term_tlv.typen == PFD)))
        begin
          out_sel              = ISF_SEL_LIVE;
          isf_term_rd          = 1'b1;
          xfr_user_wr          = 1'b1;
          isf_user_xfr_st_nxt  = UXFR_BYP; 
        end
        
        else if (xfr_rdy)
        begin
          isf_term_rd          = 1'b1;
          ib_prot_error_nxt    = 1'b1;
          isf_user_xfr_st_nxt  = UXFR_PROT_ERR;
        end
        else
        begin
          out_sel                 = ISF_SEL_LIVE;
          isf_user_xfr_stall_nxt  = 1'b1;
          ix_nxt                  = 5'h0;
          isf_user_xfr_st_nxt     = UXFR_DATA_SOT;
        end
      end

      
      
      
      
      UXFR_BYP:
      begin
        out_sel  = ISF_SEL_LIVE;

       if (xfr_rdy)  
        begin
          isf_term_rd          = 1'b1;
          xfr_user_wr          = 1'b1;
          isf_user_xfr_st_nxt  = isf_term_tlv.eot ? UXFR_DATA_SOT : UXFR_BYP;
        end
        else
        begin
          isf_user_xfr_st_nxt  = UXFR_BYP;
        end
      end

      
      
      UXFR_DATA:
      begin
        ix_nxt  = 5'h0; 

        if (isf_term_tlv.eot && xfr_rdy)  
        begin
          out_sel                 = ISF_SEL_DATA;
          xfr_user_wr             = 1'b1;
          isf_term_rd             = 1'b1;
          start_footer_pulse_nxt  = 1'b1;  
          ib_bytes_cnt_stb_nxt    = 1'b1;
          bytes_in_cnt_en         = 1'b1;
          isf_user_xfr_st_nxt     = UXFR_POST_DATA_RD;
        end
        else if (xfr_rdy)  
        begin
          isf_term_rd          = 1'b1;
          xfr_user_wr          = 1'b1;
          out_sel              = ISF_SEL_DATA;
          ib_bytes_cnt_stb_nxt = 1'b1;
          bytes_in_cnt_en      = 1'b1;
          isf_user_xfr_st_nxt  = UXFR_DATA;
        end
        else
        begin
          out_sel              = ISF_SEL_DATA;
          isf_user_xfr_st_nxt  = UXFR_DATA;
        end
      end

      
      
      
      
      
      
      UXFR_POST_DATA_RD:
      begin
        ix_nxt  = 5'h0;
        
        
        
        
        
        
        
        if (xfr_rdy && footer_done_hld && isf_term_tlv_frmd && isf_term_tlv.sot)  
        begin
          isf_term_rd          = 1'b1;
          xfr_user_wr          = 1'b1;
          out_sel              = ISF_SEL_FRMD_W0;
          isf_frmd_ld[0]       = 1'b1;
          footer_done_clr_nxt  = 1'b1;
          ix_nxt               = isf_term_tlv.eot ? 5'h0 : 5'h1;
          isf_user_xfr_st_nxt  = isf_term_tlv.eot ? UXFR_DATA_SOT : UXFR_FRMD;
        end
        
        
        
        else if (isf_term_rd_rdy && (isf_term_tlv.typen == CQE) && isf_term_tlv.sot)
        begin
          isf_term_rd          = 1'b1;
          isf_cqe_ld[0]        = 1'b1; 
          ix_nxt               = 1'b1;
          out_sel              = ISF_SEL_FOOTER;
          isf_user_xfr_st_nxt  = UXFR_RD_CQE_WAIT;
        end
        
        else if (xfr_rdy && footer_done_hld)
        begin
          isf_term_rd          = 1'b1;
          ib_prot_error_nxt    = 1'b1;
          isf_user_xfr_st_nxt  = UXFR_PROT_ERR;
        end
        else
        begin
          ix_nxt               = 1'b0;
          out_sel              = ISF_SEL_FOOTER;
          isf_user_xfr_st_nxt  = UXFR_POST_DATA_RD;
        end
      end

      
      
      
      
      UXFR_RD_CQE_WAIT:
      begin
        out_sel  = ISF_SEL_FOOTER;
        ix_nxt   = 5'h0;
        
        if (isf_term_rd_rdy)
        begin
          isf_cqe_ld[1]        = 1'b1;
          isf_user_xfr_st_nxt  = UXFR_WAIT_FOOTER;
        end
        else
        begin
          isf_user_xfr_st_nxt  = UXFR_RD_CQE_WAIT;
        end
      end

      
      
      
      UXFR_WAIT_FOOTER:
      begin
        if (footer_done_hld && isf_user_wr_rdy)
        begin
          out_sel              = ISF_SEL_CQE_W0;
          xfr_user_wr          = 1'b1;
          isf_term_rd          = isf_term_rd_rdy ? 1'b1 : 1'b0; 
          footer_done_clr_nxt  = 1'b1;
          isf_user_xfr_st_nxt  = UXFR_CQE_W1;
        end
        else
        begin
          out_sel              = ISF_SEL_FOOTER;
          isf_user_xfr_st_nxt  = UXFR_WAIT_FOOTER;
        end
      end

      
      UXFR_CQE_W1:
      begin
        out_sel  = ISF_SEL_CQE_W1;

       if (isf_user_wr_rdy)
        begin
          xfr_user_wr          = 1'b1;
          prefix_err_nxt       = 1'b0;
          isf_user_xfr_st_nxt  = UXFR_IDLE; 
        end
        else
        begin
          isf_user_xfr_st_nxt  = UXFR_CQE_W1;
        end
      end

      
      
      
      
      
      
      
      
      UXFR_PREFIX:
      begin
        if (xfr_rdy && !isf_term_tlv.eot)  
        begin
          isf_term_rd           = 1'b1;
          xfr_user_wr           = 1'b1;
          ib_bytes_cnt_stb_nxt  = 1'b1;
          bytes_in_cnt_en       = 1'b1;
          ix_nxt                = 5'h0; 
          out_sel               = user_prefix_eot ? ISF_SEL_PREFIX_EOT : ISF_SEL_PREFIX_DATA; 
          isf_user_xfr_st_nxt   = user_prefix_eot ? UXFR_DATA_ADJ_W0   : UXFR_PREFIX;
        end
        
        else if (xfr_rdy && isf_term_tlv.eot)  
        begin
          isf_term_rd           = 1'b1;
          xfr_user_wr           = 1'b1;
          ib_bytes_cnt_stb_nxt  = 1'b1;
          bytes_in_cnt_en       = 1'b1;
          ix_nxt                = 5'h0;
	  out_sel               = user_prefix_eot ? ISF_SEL_PREFIX_EOT : ISF_SEL_PREFIX_ERR_PAD;  
          isf_user_xfr_st_nxt   = user_prefix_eot ? UXFR_DATA_ERR_W0   : UXFR_PREFIX_LEN_ERR;     
        end
        else
        begin
          out_sel              = ISF_SEL_PREFIX_DATA; 
          ix_nxt               = 5'h0;
          isf_user_xfr_st_nxt  = UXFR_PREFIX;
        end
      end

      
      UXFR_DATA_ADJ_W0:  
      begin
        out_sel  = ISF_SEL_DATA_ADJ_W0;

        if (isf_user_wr_rdy)  
        begin
          xfr_user_wr          = 1'b1;
          ix_nxt               = 5'h0; 
          isf_user_xfr_st_nxt  = UXFR_DATA;
        end
        else
        begin
          ix_nxt               = 5'h0;
          isf_user_xfr_st_nxt  = UXFR_DATA_ADJ_W0;
        end
      end

      
      
      UXFR_PREFIX_LEN_ERR:
      begin
        if (xfr_rdy && isf_user_wr_rdy)  
        begin
          xfr_user_wr          = 1'b1;
          ix_nxt               = 5'h0; 
          out_sel              = user_prefix_eot ? ISF_SEL_PREFIX_ERR_EOT : ISF_SEL_PREFIX_ERR_PAD; 
          isf_user_xfr_st_nxt  = user_prefix_eot ? UXFR_DATA_ERR_W0       : UXFR_PREFIX_LEN_ERR;
        end
        else
        begin
          out_sel              = ISF_SEL_PREFIX_ERR_PAD; 
          ix_nxt               = 5'h0;
          isf_user_xfr_st_nxt  = UXFR_PREFIX_LEN_ERR;
        end
      end

      
      
      UXFR_DATA_ERR_W0:  
      begin
        out_sel  = ISF_SEL_DATA_ERR_W0;

        if (isf_user_wr_rdy)  
        begin
          xfr_user_wr          = 1'b1;
          ix_nxt               = 5'h0;
          prefix_err_nxt       = 1'b1;
          prefix_err_ld        = 1'b1;
          isf_user_xfr_st_nxt  = UXFR_DATA_ERR_EOT;  
        end
        else
        begin
          ix_nxt               = 5'h0;
          isf_user_xfr_st_nxt  = UXFR_DATA_ERR_W0;
        end
      end

      
      
      UXFR_DATA_ERR_EOT:  
      begin
        out_sel  = ISF_SEL_DATA_ERR_EOT;

        if (isf_user_wr_rdy)  
        begin
          xfr_user_wr             = 1'b1;
          ix_nxt                  = 5'h0;
	  start_footer_pulse_nxt  = 1'b1;  
          isf_user_xfr_st_nxt     = UXFR_POST_DATA_RD;  
        end
        else
        begin
          ix_nxt               = 5'h0;
          isf_user_xfr_st_nxt  = UXFR_DATA_ERR_EOT;
        end
      end

      
      
     UXFR_PROT_ERR:
      begin
        isf_user_xfr_st_nxt  = UXFR_PROT_ERR;
      end

      default:
      begin
        out_sel              = ISF_SEL_LIVE;
        ix_nxt               = 5'h0;
        isf_user_xfr_st_nxt  = UXFR_IDLE;
      end
    endcase
  end

  
  assign cmd_tlv_tdata_w1       = isf_term_tlv.tdata;
  assign cmd_tlv_tdata_w2       = isf_term_tlv.tdata;
  assign rqe_tlv_tdata_w0       = isf_term_tlv.tdata;
  assign rqe_tlv_tdata_w1       = isf_term_tlv.tdata;
  assign data_word_0            = isf_term_tlv.tdata;
  assign tlv_word_0             = isf_term_tlv.tdata;
  assign data_tlv_tdata_w0_reg  = data_tlv_w0_reg.tdata;

  
  
  
  
  assign tlv_mod_ordern         = user_prefix_vld_reg ? 
                                  isf_term_tlv.ordern + `TLVP_ORD_NUM_WIDTH'h1 : 
                                  isf_term_tlv.ordern;


  assign isf_term_tlv_mod       = {
                                   1'b1,
                                   tlv_mod_ordern,
                                   isf_term_tlv.typen, 
                                   isf_term_tlv.sot,    
                                   isf_term_tlv.eot, 
                                   isf_term_tlv.tlast, 
                                   isf_term_tlv.tid, 
                                   isf_term_tlv.tstrb, 
                                   isf_term_tlv.tuser,
                                   isf_term_tlv.tdata
                                   };


  
  
  
  
  assign tlv_mod_ordern_cqe     = user_prefix_vld_reg ? 
                                  isf_term_tlv.ordern + `TLVP_ORD_NUM_WIDTH'h2 : 
                                  isf_term_tlv.ordern + `TLVP_ORD_NUM_WIDTH'h1;


  assign isf_term_tlv_cqe       = {
                                   1'b1,
                                   tlv_mod_ordern_cqe[`TLVP_ORD_NUM_WIDTH-1:0],
                                   isf_term_tlv.typen, 
                                   isf_term_tlv.sot,    
                                   isf_term_tlv.eot, 
                                   isf_term_tlv.tlast, 
                                   isf_term_tlv.tid, 
                                   isf_term_tlv.tstrb, 
                                   isf_term_tlv.tuser,
                                   isf_term_tlv.tdata
                                   };

  
  
  

  assign ib_bytes_cnt_amt_nxt  = isf_term_tlv.tstrb[7] + isf_term_tlv.tstrb[6] + 
                                 isf_term_tlv.tstrb[5] + isf_term_tlv.tstrb[4] + 
                                 isf_term_tlv.tstrb[3] + isf_term_tlv.tstrb[2] +
                                 isf_term_tlv.tstrb[1] + isf_term_tlv.tstrb[0];

  
  assign prefix_mode_ok = (cmd_tlv_tdata_w2.comp_mode == XP10) ||
                          (cmd_tlv_tdata_w2.comp_mode == CHU4K) ||
                          (cmd_tlv_tdata_w2.comp_mode == CHU8K);

  
  assign xp10_prefix_mode_mod  = (!cceip_cfg || prefix_mode_ok) ? cmd_tlv_tdata_w2.xp10_prefix_mode : NO_PREFIX;


  always_ff @(posedge clk or negedge rst_n)  
  begin
    if (~rst_n) 
    begin
      for (j=0; j<=12; j=j+1)
      begin
        isf_frmd_reg[j] <= 64'h0;
      end

      cmd_comp_mode_reg             <= cmd_comp_mode_e'(0);
      cmd_frmd_out_type_reg         <= tlv_types_e'(0);
      isf_user_xfr_st               <= UXFR_IDLE;

      rqe_trace_reg                 <= rqe_trace_e'(0);
      rqe_frame_size_reg            <= 4'b0;
      tag_no_chk                    <= 1'b0;
      
      
      aux_cmd_match0_ev <= 0;
      aux_cmd_match1_ev <= 0;
      aux_cmd_match2_ev <= 0;
      aux_cmd_match3_ev <= 0;
      bytes_in_cnt <= 0;
      cmd_stats_en <= 0;
      cmd_xp10_user_prefix_size_reg <= 0;
      cqe_tlv_w0_reg <= 0;
      cqe_tlv_w1_reg <= 0;
      data_tlv_w0_reg <= 0;
      footer_done_clr <= 0;
      footer_done_hld <= 0;
      ib_bytes_cnt_amt <= 0;
      ib_bytes_cnt_stb <= 0;
      ib_cmd_cnt_stb <= 0;
      ib_frame_cnt_stb <= 0;
      ib_prot_error <= 0;
      isf_user_xfr_stall <= 0;
      ix <= 0;
      prefix_err <= 0;
      prefix_err_frame <= 0;
      rqe_que_grp_reg <= 0;
      start_footer_pulse <= 0;
      user_prefix_cnt <= 0;
      user_prefix_cnt_en <= 0;
      user_prefix_eot <= 0;
      user_prefix_ld <= 0;
      user_prefix_ld_save <= 0;
      user_prefix_sot <= 0;
      user_prefix_vld_reg <= 0;
      
    end
    else
    begin
      start_footer_pulse            <= start_footer_pulse_nxt;
      isf_user_xfr_stall            <= isf_user_xfr_stall_nxt;
      ix                            <= ix_nxt;
      isf_user_xfr_st               <= isf_user_xfr_st_nxt;
      user_prefix_sot               <= user_prefix_sot_nxt;
      prefix_err                    <= prefix_err_nxt;
      prefix_err_frame              <= prefix_err_ld  ? data_tlv_tdata_w0_reg.tlv_frame_num : prefix_err_frame;
      rqe_trace_reg                 <= isf_rqe_ld[0]  ? rqe_tlv_tdata_w0.trace : rqe_trace_reg; 
      rqe_frame_size_reg            <= isf_rqe_ld[0]  ? rqe_tlv_tdata_w0.frame_size : rqe_frame_size_reg;
      rqe_que_grp_reg               <= isf_rqe_ld[1]  ? rqe_tlv_tdata_w1.scheduler_handle : rqe_que_grp_reg; 
      cmd_frmd_out_type_reg         <= isf_cmd_ld[1]  ? tlv_types_e'({1'b0,cmd_tlv_tdata_w1.frmd_out_type}) : cmd_frmd_out_type_reg;
      cmd_stats_en                  <= isf_cmd_ld[1]  ? isf_cmd_debug_trace : cmd_stats_en; 

      user_prefix_vld_reg           <= isf_cmd_ld[2]  ? (xp10_prefix_mode_mod == USER_PREFIX) : user_prefix_vld_reg;
      cmd_xp10_user_prefix_size_reg <= isf_cmd_ld[2]  ? cmd_tlv_tdata_w2.xp10_user_prefix_size : cmd_xp10_user_prefix_size_reg;
      cmd_comp_mode_reg             <= isf_cmd_ld[2]  ? cmd_tlv_tdata_w2_out.comp_mode : cmd_comp_mode_reg;  
      cqe_tlv_w0_reg                <= isf_cqe_ld[0]  ? isf_term_tlv_cqe : cqe_tlv_w0_reg;
      cqe_tlv_w1_reg                <= isf_cqe_ld[1]  ? isf_term_tlv_cqe : cqe_tlv_w1_reg;
      data_tlv_w0_reg               <= isf_data_w0_ld ? isf_term_tlv_mod : data_tlv_w0_reg;

      ib_prot_error                 <= ib_prot_error_nxt;

      
      aux_cmd_match0_ev             <= cmd_stats_en && isf_cmd_ld[2] && ctl_config.aux_cmd_match0_en ? 
                                       comp_match0 && crypto_match0 : 1'b0;

      aux_cmd_match1_ev             <= cmd_stats_en && isf_cmd_ld[2] && ctl_config.aux_cmd_match1_en ? 
                                       comp_match1 && crypto_match1 : 1'b0;

      aux_cmd_match2_ev             <= cmd_stats_en && isf_cmd_ld[2] && ctl_config.aux_cmd_match2_en ? 
                                       comp_match2 && crypto_match2 : 1'b0;

      aux_cmd_match3_ev             <= cmd_stats_en && isf_cmd_ld[2] && ctl_config.aux_cmd_match3_en ? 
                                       comp_match3 && crypto_match3 : 1'b0;

      for (k=0; k<=12; k=k+1)
      begin
        isf_frmd_reg[k] <= isf_frmd_ld[k] ? isf_term_tlv.tdata : isf_frmd_reg[k];
      end

      
      
      user_prefix_ld          <= user_prefix_ld_nxt;

      if (user_prefix_ld)
      begin
        user_prefix_cnt     <= user_prefix_tlv_adj_beats[13:0];
        user_prefix_eot     <= 1'b0;
        user_prefix_cnt_en  <= isf_user_wr ? 1'b1 : 1'b0;
        user_prefix_ld_save <= 1'b1;
      end
      
      
      
      else if (isf_user_wr && user_prefix_ld_save && !user_prefix_cnt_en)
      begin
        user_prefix_cnt_en  <= 1'b1;
      end
      else if (isf_user_wr && user_prefix_cnt_en)
      begin
        user_prefix_cnt     <= user_prefix_cnt - 14'h1;
        user_prefix_eot     <= (user_prefix_cnt == 14'h1) ? 1'b1 : 1'b0;
        user_prefix_cnt_en  <= user_prefix_eot ? 1'b0 : 1'b1;
        user_prefix_ld_save <= 1'b0;
      end

      
      if (bytes_in_cnt_clr)
      begin
        bytes_in_cnt <= 25'h0;
      end
      else if (bytes_in_cnt_en)
      begin
        bytes_in_cnt <= bytes_in_cnt[23:0] + {20'h0, ib_bytes_cnt_amt_nxt};
      end

      
      
      footer_done_clr       <= footer_done_clr_nxt; 
      footer_done_hld       <= footer_done_clr ? 1'b0 : (footer_done_pulse ? 1'b1 : footer_done_hld);

      
      ib_bytes_cnt_stb      <= ib_bytes_cnt_stb_nxt;
      ib_frame_cnt_stb      <= ib_frame_cnt_stb_nxt;
      ib_cmd_cnt_stb        <= ib_cmd_cnt_stb_nxt;
      ib_bytes_cnt_amt      <= ib_bytes_cnt_stb_nxt ? ib_bytes_cnt_amt_nxt : ib_bytes_cnt_amt; 

      
      
      tag_no_chk            <= (out_sel == ISF_SEL_CMD_W1) ? cmd_tlv_tdata_w1_out.md_type[0] : tag_no_chk;
    end
  end

  
  
  
  
  
  
  
  
  
  
  
  

  
  
  
  assign user_prefix_tlv_bytes  = ({1'b0,cmd_xp10_user_prefix_size_reg} + 7'h1)*11'd1024 + 18'd16;  

    

  always_comb
  begin
    
    user_prefix_tlv_tdata_w0[63:62]           = 2'b0; 
    user_prefix_tlv_tdata_w0.resv1            = 12'b0; 
    user_prefix_tlv_tdata_w0.resv0            = 4'b0; 
    user_prefix_tlv_tdata_w0.tlv_type         = PFD; 

    
    
    user_prefix_tlv_tdata_w0.tlv_len          = `TLV_LEN_WIDTH'd0;

    user_prefix_tlv_tdata_w0.tlv_eng_id       = data_word_0.tlv_eng_id;
    user_prefix_tlv_tdata_w0.tlv_seq_num      = data_word_0.tlv_seq_num;
    user_prefix_tlv_tdata_w0.tlv_frame_num    = data_word_0.tlv_frame_num;
    
    
    
    user_prefix_tlv_tdata_w0.prefix_src       = 1'b1;
    user_prefix_tlv_tdata_w0.xp10_prefix_sel  = cmd_xp10_user_prefix_size_reg;
    
    user_prefix_tlv_tdata_w0.tlv_bip2         = get_bip2(user_prefix_tlv_tdata_w0);

    
    
    user_prefix_tlv_adj_beats                 = user_prefix_tlv_bytes[16:3] - 14'h3;  

    
    user_prefix_tlv_w0 = {
                          1'b1,                   
                          isf_term_tlv.ordern,    
                          frmd_tdata_w0.tlv_type, 
                          isf_term_tlv.sot,       
                          isf_term_tlv.eot, 
                          isf_term_tlv.tlast, 
                          isf_term_tlv.tid, 
                          isf_term_tlv.tstrb, 
                          isf_term_tlv.tuser,
                          user_prefix_tlv_tdata_w0
                          }; 

    
    user_prefix_tlv_data = {
                            1'b1,                   
                            isf_term_tlv.ordern,    
                            frmd_tdata_w0.tlv_type, 
                            isf_term_tlv.sot,    
                            isf_term_tlv.eot, 
                            isf_term_tlv.tlast, 
                            isf_term_tlv.tid, 
                            isf_term_tlv.tstrb, 
                            isf_term_tlv.tuser,
                            isf_term_tlv.tdata
                            }; 

    
    user_prefix_tlv_eot = {
                           1'b1,                   
                           isf_term_tlv.ordern,    
                           frmd_tdata_w0.tlv_type, 
                           1'b0,                   
                           1'b1,                   
                           1'b0,                   
                           isf_term_tlv.tid,       
                           8'hff,                  
                           8'h2,                   
                           isf_term_tlv.tdata   
                           }; 

    
    
    user_prefix_err_pad = {
                           1'b1,   
                           data_tlv_w0_reg.ordern, 
                           frmd_tdata_w0.tlv_type, 
                           1'b0,   
                           1'b0,   
                           1'b0,   
                           1'b0,   
                           8'hff,  
                           8'h0,   
                           64'h0   
                           };

    
    
    user_prefix_err_pad_eot = {
                               1'b1,   
                               data_tlv_w0_reg.ordern, 
                               frmd_tdata_w0.tlv_type, 
                               1'b0,   
                               1'b1,   
                               1'b0,   
                               1'b0,   
                               8'hff,  
                               8'h2,   
                               64'h0   
                               };


    
    
    data_adj_w0 = {
                   data_tlv_w0_reg.insert,  
                   data_tlv_w0_reg.ordern,  
                   data_tlv_w0_reg.typen, 
                   data_tlv_w0_reg.sot,
                   data_tlv_w0_reg.eot, 
                   data_tlv_w0_reg.tlast, 
                   data_tlv_w0_reg.tid, 
                   data_tlv_w0_reg.tstrb, 
                   data_tlv_w0_reg.tuser, 
                   data_tlv_w0_reg.tdata
                   };

    
    data_err_w0 = {
                   1'b1,   
                   data_tlv_w0_reg.ordern, 
                   data_tlv_w0_reg.typen, 
                   1'b1,   
                   1'b0,   
                   1'b0,   
                   1'b0,   
                   8'hff,  
                   8'h1,   
                   data_tlv_w0_reg.tdata
                   };

    
    
    data_err_eot = {
                   1'b1,   
                   data_tlv_w0_reg.ordern, 
                   data_tlv_w0_reg.typen, 
                   1'b0,   
                   1'b1,   
                   1'b0,   
                   1'b0,   
                   8'hff,  
                   8'h2,   
                   64'h0   
                   };
  end

  
  
  

  
  
  
  assign data_tlv_ordern  = user_prefix_vld_reg ? data_tlv_w0_reg.ordern : isf_term_tlv.ordern;

  assign data_tlv_all     =
                           {
                            1'b1,                
                            data_tlv_ordern,
                            isf_term_tlv.typen, 
                            isf_term_tlv.sot, 
                            isf_term_tlv.eot, 
                            isf_term_tlv.tlast, 
                            isf_term_tlv.tid, 
                            isf_term_tlv.tstrb, 
                            isf_term_tlv.tuser,
                            isf_term_tlv.tdata
                            };

  
  

  assign rqe_simple_frame_size = (rqe_frame_size_reg == RQE_SIMPLE);

  assign chu_mismatch0  = rqe_simple_frame_size &&
                         ((cmd_tlv_tdata_w2.comp_mode == CHU4K) || (cmd_tlv_tdata_w2.comp_mode == CHU8K));


  
  
  assign chu_mismatch1  = !rqe_simple_frame_size &&
                          !((cmd_tlv_tdata_w2.comp_mode == CHU4K) || (cmd_tlv_tdata_w2.comp_mode == CHU8K) || (cmd_tlv_tdata_w2.comp_mode == NONE));


  always_comb
  begin
    
    
    

    
    queue_ok  = (rqe_que_grp_reg >= trace_ctl_limits_config.sch_hndl_lo_limit) &&
                (rqe_que_grp_reg <= trace_ctl_limits_config.sch_hndl_hi_limit);


    
    
    
    
    
    if (trace_ctl_en_config.sch_hndl_rng_match_en)
    begin
      isf_cmd_debug_trace  = queue_ok || rqe_trace_reg;
    end
    
    
    else
    begin
      isf_cmd_debug_trace  = rqe_trace_reg;
    end

    cmd_tlv_tdata_w1_out.trace                  = isf_cmd_debug_trace; 

    
    cmd_tlv_tdata_w1_out.debug                  = dbg_cmd_disable ? {$bits(cmd_debug_t){1'b0}} : 
                                                  cmd_tlv_tdata_w1.debug;

    cmd_tlv_tdata_w1_out.frmd_out_type          = cmd_tlv_tdata_w1.frmd_out_type; 
    cmd_tlv_tdata_w1_out.dst_guid_present       = cmd_tlv_tdata_w1.dst_guid_present; 
    cmd_tlv_tdata_w1_out.md_op                  = cmd_tlv_tdata_w1.md_op; 
    cmd_tlv_tdata_w1_out.md_type                = cmd_tlv_tdata_w1.md_type;
    cmd_tlv_tdata_w1_out.frmd_in_type           = cmd_tlv_tdata_w1.frmd_in_type; 
    cmd_tlv_tdata_w1_out.frmd_in_aux            = cmd_tlv_tdata_w1.frmd_in_aux; 
    cmd_tlv_tdata_w1_out.frmd_crc_in            = cmd_tlv_tdata_w1.frmd_crc_in;
    cmd_tlv_tdata_w1_out.src_guid_present       = cmd_tlv_tdata_w1.src_guid_present; 
    cmd_tlv_tdata_w1_out.compound_cmd_frm_size  = cmd_tlv_tdata_w1.compound_cmd_frm_size; 


    
    
    cmd_tlv_tdata_w2_out.rsvd2                  = cmd_tlv_tdata_w2.rsvd2;
    cmd_tlv_tdata_w2_out.key_type               = cmd_tlv_tdata_w2.key_type;
    cmd_tlv_tdata_w2_out.rsvd1                  = cmd_tlv_tdata_w2.rsvd1;
    cmd_tlv_tdata_w2_out.cipher_pad             = cmd_tlv_tdata_w2.cipher_pad;
    cmd_tlv_tdata_w2_out.iv_op                  = cmd_tlv_tdata_w2.iv_op;
    cmd_tlv_tdata_w2_out.aad_len                = cmd_tlv_tdata_w2.aad_len;
    cmd_tlv_tdata_w2_out.cipher_op              = cmd_tlv_tdata_w2.cipher_op;
    cmd_tlv_tdata_w2_out.auth_op                = cmd_tlv_tdata_w2.auth_op;
    cmd_tlv_tdata_w2_out.raw_auth_op            = cmd_tlv_tdata_w2.raw_auth_op;
    cmd_tlv_tdata_w2_out.rsvd0                  = cmd_tlv_tdata_w2.rsvd0;
    cmd_tlv_tdata_w2_out.chu_comp_thrsh         = cmd_tlv_tdata_w2.chu_comp_thrsh;
    cmd_tlv_tdata_w2_out.xp10_crc_mode          = cmd_tlv_tdata_w2.xp10_crc_mode;
    cmd_tlv_tdata_w2_out.xp10_user_prefix_size  = cmd_tlv_tdata_w2.xp10_user_prefix_size;

    
    
    cmd_tlv_tdata_w2_out.xp10_prefix_mode       = (!cceip_cfg || prefix_mode_ok) ? 
                                                  cmd_tlv_tdata_w2.xp10_prefix_mode : NO_PREFIX;

    cmd_tlv_tdata_w2_out.lz77_max_symb_len      = cmd_tlv_tdata_w2.lz77_max_symb_len;
    cmd_tlv_tdata_w2_out.lz77_min_match_len     = cmd_tlv_tdata_w2.lz77_min_match_len;
    cmd_tlv_tdata_w2_out.lz77_dly_match_win     = cmd_tlv_tdata_w2.lz77_dly_match_win;
    cmd_tlv_tdata_w2_out.lz77_win_size          = cmd_tlv_tdata_w2.lz77_win_size;


    cmd_tlv_tdata_w2_out.comp_mode              = chu_mismatch0  ? XP10 : 
                                                  (chu_mismatch1 ? cmd_comp_mode_e'(rqe_frame_size_reg)   :
                                                  ((cceip_cfg && xp9_disable && (cmd_tlv_tdata_w2.comp_mode == XP9)) ? NONE :  
                                                   cmd_tlv_tdata_w2.comp_mode));


    
    cmd_tlv_w1  = 
                  {
                   isf_term_tlv.insert, 
                   isf_term_tlv.ordern, 
                   isf_term_tlv.typen, 
                   isf_term_tlv.sot, 
                   isf_term_tlv.eot, 
                   isf_term_tlv.tlast, 
                   isf_term_tlv.tid, 
                   isf_term_tlv.tstrb, 
                   isf_term_tlv.tuser,
                   cmd_tlv_tdata_w1_out
                   };

    
    cmd_tlv_w2  = 
                  {
                   isf_term_tlv.insert, 
                   isf_term_tlv.ordern, 
                   isf_term_tlv.typen, 
                   isf_term_tlv.sot, 
                   isf_term_tlv.eot, 
                   isf_term_tlv.tlast, 
                   isf_term_tlv.tid, 
                   isf_term_tlv.tstrb, 
                   isf_term_tlv.tuser,
                   cmd_tlv_tdata_w2_out
                   };


    
    
    
    case (isf_term_tlv.typen) 
      FRMD_USER_PI16    : frmd_len_mux  = `TLV_LEN_WIDTH'(4); 
      FRMD_USER_PI64    : frmd_len_mux  = `TLV_LEN_WIDTH'(4);
      FRMD_USER_VM      : frmd_len_mux  = `TLV_LEN_WIDTH'(6);
      FRMD_INT_APP      : frmd_len_mux  = `TLV_LEN_WIDTH'(7);
      FRMD_INT_SIP      : frmd_len_mux  = `TLV_LEN_WIDTH'(3); 
      FRMD_INT_LIP      : frmd_len_mux  = `TLV_LEN_WIDTH'(3);
      FRMD_INT_VM       : frmd_len_mux  = `TLV_LEN_WIDTH'(7);
      FRMD_INT_VM_SHORT : frmd_len_mux  = `TLV_LEN_WIDTH'(7);
      default           : frmd_len_mux  = `TLV_LEN_WIDTH'(2); 
    endcase

    frmd_w0_adj_bip2  = get_bip2
                           (
                            {
                             2'b0,
                             tlv_word_0.resv0,
                             tlv_word_0.tlv_frame_num,
                             tlv_word_0.resv1,
                             tlv_word_0.tlv_eng_id,
                             tlv_word_0.tlv_seq_num,
                             frmd_len_mux,
                             tlv_word_0.tlv_type
                             }
                            );                          

    frmd_w0_adj_tdata  = {
                          frmd_w0_adj_bip2,
                          tlv_word_0.resv0,
                          tlv_word_0.tlv_frame_num,
                          tlv_word_0.resv1,
                          tlv_word_0.tlv_eng_id,
                          tlv_word_0.tlv_seq_num,
                          frmd_len_mux,
                          tlv_word_0.tlv_type
                          };

    frmd_w0_adj  = 
                  {
                   isf_term_tlv.insert, 
                   isf_term_tlv.ordern, 
                   isf_term_tlv.typen, 
                   isf_term_tlv.sot, 
                   isf_term_tlv.eot, 
                   isf_term_tlv.tlast, 
                   isf_term_tlv.tid, 
                   isf_term_tlv.tstrb, 
                   isf_term_tlv.tuser,
                   frmd_w0_adj_tdata
                   };

    
    
    
    
    user_vm_w2  = 
                  {
                   isf_term_tlv.insert, 
                   isf_term_tlv.ordern, 
                   isf_term_tlv.typen, 
                   isf_term_tlv.sot, 
                   1'b1, 
                   isf_term_tlv.tlast, 
                   isf_term_tlv.tid, 
                   isf_term_tlv.tstrb, 
                   8'h2,
                   isf_term_tlv.tdata
                   };
  end

  
  
  
  always_comb
  begin
    case (out_sel) 
      ISF_SEL_CMD_W1:          isf_user_tlv  = cmd_tlv_w1;   
      ISF_SEL_CMD_W2:          isf_user_tlv  = cmd_tlv_w2;   
      ISF_SEL_PREFIX_SOT:      isf_user_tlv  = user_prefix_tlv_w0;
      ISF_SEL_PREFIX_DATA:     isf_user_tlv  = user_prefix_tlv_data;
      ISF_SEL_PREFIX_EOT:      isf_user_tlv  = user_prefix_tlv_eot;
      ISF_SEL_DATA_ADJ_W0:     isf_user_tlv  = data_adj_w0;  
      ISF_SEL_FOOTER:          isf_user_tlv  = fgen;   
      ISF_SEL_CQE_W0:          isf_user_tlv  = cqe_tlv_w0_reg;
      ISF_SEL_CQE_W1:          isf_user_tlv  = cqe_tlv_w1_reg;
      ISF_SEL_DATA:            isf_user_tlv  = data_tlv_all;
      ISF_SEL_PREFIX_ERR_PAD:  isf_user_tlv  = user_prefix_err_pad;       
      ISF_SEL_PREFIX_ERR_EOT:  isf_user_tlv  = user_prefix_err_pad_eot;   
      ISF_SEL_DATA_ERR_W0:     isf_user_tlv  = data_err_w0;
      ISF_SEL_DATA_ERR_EOT:    isf_user_tlv  = data_err_eot;
      ISF_SEL_FRMD_W0 :        isf_user_tlv  = frmd_w0_adj;
      ISF_SEL_USER_VM :        isf_user_tlv  = user_vm_w2;
      
      
      default:                  isf_user_tlv  = isf_term_tlv;
    endcase
  end


  
  
  

  assign  comp_match0    = mask_match 
                           (
                            isf_term_tlv.tdata[31:0],
                            aux_cmd_ev_match_val_0_comp_config,
                            aux_cmd_ev_mask_val_0_comp_config
                            );

  assign  crypto_match0  = mask_match 
                           (
                            isf_term_tlv.tdata[63:32],
                            aux_cmd_ev_match_val_0_crypto_config,
                            aux_cmd_ev_mask_val_0_crypto_config
                            );

  assign  comp_match1    = mask_match 
                           (
                            isf_term_tlv.tdata[31:0],
                            aux_cmd_ev_match_val_1_comp_config,
                            aux_cmd_ev_mask_val_1_comp_config
                            );

  assign  crypto_match1  = mask_match 
                           (
                            isf_term_tlv.tdata[63:32],
                            aux_cmd_ev_match_val_1_crypto_config,
                            aux_cmd_ev_mask_val_1_crypto_config
                            );

  assign  comp_match2    = mask_match 
                           (
                            isf_term_tlv.tdata[31:0],
                            aux_cmd_ev_match_val_2_comp_config,
                            aux_cmd_ev_mask_val_2_comp_config
                            );

  assign  crypto_match2  = mask_match 
                           (
                            isf_term_tlv.tdata[63:32],
                            aux_cmd_ev_match_val_2_crypto_config,
                            aux_cmd_ev_mask_val_2_crypto_config
                            );

  assign  comp_match3    = mask_match 
                           (
                            isf_term_tlv.tdata[31:0],
                            aux_cmd_ev_match_val_3_comp_config,
                            aux_cmd_ev_mask_val_3_comp_config
                            );

  assign  crypto_match3  = mask_match 
                           (
                            isf_term_tlv.tdata[63:32],
                            aux_cmd_ev_match_val_3_crypto_config,
                            aux_cmd_ev_mask_val_3_crypto_config
                            );



  
  
  
  
  
  
  
  
  
  assign frmd_tdata_w0          = isf_frmd_reg[0];
  assign frmd_int_tdata_w3      = isf_frmd_reg[3];  
  assign frmd_int_tdata_w9      = isf_frmd_reg[9];  
  assign frmd_int_tdata_w6_lip  = isf_frmd_reg[6];  
  assign frmd_int_tdata_w6_app  = isf_frmd_reg[6];  
  assign frmd_int_tdata_w12     = isf_frmd_reg[12]; 

  always_comb
  begin
    
    
    
    case (frmd_tdata_w0.tlv_type)
      FRMD_USER_NULL: 
      begin
        footer_len                    = `TLV_LEN_WIDTH'd28;
        footer_raw_mac_size           = DIGEST_0b;
        footer_enc_mac_size           = DIGEST_0b;
        footer_coding                 = user_footer_coding;
        footer_raw_mac0               = 64'h0;
        footer_raw_mac1               = 64'h0;
        footer_raw_mac2               = 64'h0;
        footer_raw_mac3               = 64'h0;
        footer_raw_cksum              = 64'h0;
        footer_enc_mac0               = 64'h0;
        footer_enc_mac1               = 64'h0;
        footer_enc_mac2               = 64'h0;
        footer_enc_mac3               = 64'h0;
        footer_enc_cksum              = 64'h0;
        footer_nvme_raw_cksum_crc16t  = 16'h0;
        footer_comp_len               = 24'h0;
      end

      FRMD_USER_PI16: 
      begin
        footer_len                    = `TLV_LEN_WIDTH'd28;
        footer_raw_mac_size           = DIGEST_0b;
        footer_enc_mac_size           = DIGEST_0b;
        footer_coding                 = user_footer_coding;
        footer_raw_mac0               = 64'h0;
        footer_raw_mac1               = 64'h0;
        footer_raw_mac2               = 64'h0;
        footer_raw_mac3               = 64'h0;
        footer_raw_cksum              = 64'h0;
        footer_enc_mac0               = 64'h0;
        footer_enc_mac1               = 64'h0;
        footer_enc_mac2               = 64'h0;
        footer_enc_mac3               = 64'h0;
        footer_enc_cksum              = 64'h0;
        footer_nvme_raw_cksum_crc16t  = isf_frmd_reg[1][15:0];
        footer_comp_len               = 24'h0;
      end

      FRMD_USER_PI64: 
      begin
        footer_len                    = `TLV_LEN_WIDTH'd28;
        footer_raw_mac_size           = DIGEST_0b;
        footer_enc_mac_size           = DIGEST_0b;
        footer_coding                 = user_footer_coding;
        footer_raw_mac0               = 64'h0;
        footer_raw_mac1               = 64'h0;
        footer_raw_mac2               = 64'h0;
        footer_raw_mac3               = 64'h0;
        footer_raw_cksum              = isf_frmd_reg[1];
        footer_enc_mac0               = 64'h0;
        footer_enc_mac1               = 64'h0;
        footer_enc_mac2               = 64'h0;
        footer_enc_mac3               = 64'h0;
        footer_enc_cksum              = 64'h0;
        footer_nvme_raw_cksum_crc16t  = 16'h0;
        footer_comp_len               = 24'h0;
      end

      FRMD_USER_VM: 
      begin
        footer_len                    = `TLV_LEN_WIDTH'd28;
        footer_raw_mac_size           = (tag_no_chk && cceip_cfg) ? DIGEST_0b : DIGEST_256b;
        footer_enc_mac_size           = DIGEST_0b;
        footer_coding                 = user_footer_coding;
        footer_raw_mac0               = isf_frmd_reg[4];
        footer_raw_mac1               = isf_frmd_reg[5];
        footer_raw_mac2               = isf_frmd_reg[6];
        footer_raw_mac3               = isf_frmd_reg[7];
        footer_raw_cksum              = isf_frmd_reg[3];
        footer_enc_mac0               = 64'h0;
        footer_enc_mac1               = 64'h0;
        footer_enc_mac2               = 64'h0;
        footer_enc_mac3               = 64'h0;
        footer_enc_cksum              = 64'h0;
        footer_nvme_raw_cksum_crc16t  = 16'h0;
        footer_comp_len               = 24'h0;
      end

      FRMD_INT_APP: 
      begin
        footer_len                    = `TLV_LEN_WIDTH'd28;
        footer_raw_mac_size           = DIGEST_0b;
        footer_enc_mac_size           = DIGEST_128b;
        footer_coding                 = frmd_int_tdata_w6_app.coding; 
        footer_raw_mac0               = 64'h0;
        footer_raw_mac1               = 64'h0;
        footer_raw_mac2               = 64'h0;
        footer_raw_mac3               = 64'h0;
        footer_raw_cksum              = 64'h0;
        footer_enc_mac0               = isf_frmd_reg[2];
        footer_enc_mac1               = isf_frmd_reg[3];
        footer_enc_mac2               = 64'h0;
        footer_enc_mac3               = 64'h0;
        footer_enc_cksum              = isf_frmd_reg[1];
        footer_nvme_raw_cksum_crc16t  = 16'h0;
        footer_comp_len               = frmd_int_tdata_w6_app.compressed_length;  
      end

      FRMD_INT_SIP: 
      begin
        footer_len                    = `TLV_LEN_WIDTH'd28;
        footer_raw_mac_size           = DIGEST_64b;
        footer_enc_mac_size           = DIGEST_0b;
        footer_coding                 = frmd_int_tdata_w3.coding;
        footer_raw_mac0               = isf_frmd_reg[2];
        footer_raw_mac1               = 64'h0;
        footer_raw_mac2               = 64'h0;
        footer_raw_mac3               = 64'h0;
        footer_raw_cksum              = 64'h0;
        footer_enc_mac0               = 64'h0;
        footer_enc_mac1               = 64'h0;
        footer_enc_mac2               = 64'h0;
        footer_enc_mac3               = 64'h0;
        footer_enc_cksum              = isf_frmd_reg[1];
        footer_nvme_raw_cksum_crc16t  = 16'h0;
        footer_comp_len               = frmd_int_tdata_w3.compressed_length ;
      end

      FRMD_INT_LIP: 
      begin
        footer_len                    = `TLV_LEN_WIDTH'd28;
        footer_raw_mac_size           = DIGEST_256b;
        footer_enc_mac_size           = DIGEST_0b;
        footer_coding                 = frmd_int_tdata_w6_lip.coding ;
        footer_raw_mac0               = isf_frmd_reg[2];
        footer_raw_mac1               = isf_frmd_reg[3];
        footer_raw_mac2               = isf_frmd_reg[4];
        footer_raw_mac3               = isf_frmd_reg[5];
        footer_raw_cksum              = 64'h0;
        footer_enc_mac0               = 64'h0;
        footer_enc_mac1               = 64'h0;
        footer_enc_mac2               = 64'h0;
        footer_enc_mac3               = 64'h0;
        footer_enc_cksum              = isf_frmd_reg[1];
        footer_nvme_raw_cksum_crc16t  = 16'h0;
        footer_comp_len               = frmd_int_tdata_w6_lip.compressed_length;
      end

      FRMD_INT_VM: 
      begin
        footer_len                    = `TLV_LEN_WIDTH'd28;
        footer_raw_mac_size           = DIGEST_256b;
        footer_enc_mac_size           = DIGEST_256b;
        footer_coding                 = frmd_int_tdata_w12.coding ;
        footer_raw_mac0               = isf_frmd_reg[6];
        footer_raw_mac1               = isf_frmd_reg[7];
        footer_raw_mac2               = isf_frmd_reg[8];
        footer_raw_mac3               = isf_frmd_reg[9];
        footer_raw_cksum              = 64'h0;
        footer_enc_mac0               = isf_frmd_reg[2];
        footer_enc_mac1               = isf_frmd_reg[3];
        footer_enc_mac2               = isf_frmd_reg[4];
        footer_enc_mac3               = isf_frmd_reg[5];
        footer_enc_cksum              = isf_frmd_reg[1];
        footer_nvme_raw_cksum_crc16t  = 16'h0;
        footer_comp_len               = frmd_int_tdata_w12.compressed_length;
      end

      FRMD_INT_VM_SHORT: 
      begin
        footer_len                    = `TLV_LEN_WIDTH'd28;
        footer_raw_mac_size           = DIGEST_64b;
        footer_enc_mac_size           = DIGEST_256b;
        footer_coding                 = frmd_int_tdata_w9.coding ;
        footer_raw_mac0               = isf_frmd_reg[6];
        footer_raw_mac1               = 64'h0;
        footer_raw_mac2               = 64'h0;
        footer_raw_mac3               = 64'h0;
        footer_raw_cksum              = 64'h0;
        footer_enc_mac0               = isf_frmd_reg[2];
        footer_enc_mac1               = isf_frmd_reg[3];
        footer_enc_mac2               = isf_frmd_reg[4];
        footer_enc_mac3               = isf_frmd_reg[5];
        footer_enc_cksum              = isf_frmd_reg[1];
        footer_nvme_raw_cksum_crc16t  = 16'h0;
        footer_comp_len               = frmd_int_tdata_w9.compressed_length;
      end

      default: 
      begin
        footer_len                    = `TLV_LEN_WIDTH'd28;
        footer_raw_mac_size           = DIGEST_64b;  
        footer_enc_mac_size           = DIGEST_64b;
        footer_coding                 = RAW;
        footer_raw_mac0               = 64'h0;
        footer_raw_mac1               = 64'h0;
        footer_raw_mac2               = 64'h0;
        footer_raw_mac3               = 64'h0;
        footer_raw_cksum              = 64'h0;
        footer_enc_mac0               = 64'h0;
        footer_enc_mac1               = 64'h0;
        footer_enc_mac2               = 64'h0;
        footer_enc_mac3               = 64'h0;
        footer_enc_cksum              = 64'h0;
        footer_nvme_raw_cksum_crc16t  = 16'h0;
        footer_comp_len               = 24'h0;
      end
    endcase
    
    case (cmd_comp_mode_reg)
      ZLIB    : user_footer_coding  = PARSEABLE; 
      GZIP    : user_footer_coding  = PARSEABLE;
      XP9     : user_footer_coding  = PARSEABLE;
      XP10    : user_footer_coding  = PARSEABLE;
      CHU4K   : user_footer_coding  = XP10CFH4K;
      CHU8K   : user_footer_coding  = XP10CFH8K;
      default : user_footer_coding  = RAW;  
    endcase

    
    footer_bip2  = get_bip2(
                            {
                             2'b0,
                             {2'b0, cmd_frmd_out_type_reg, 2'b0, footer_raw_mac_size, footer_enc_mac_size, footer_coding, 1'b0},
                             frmd_tdata_w0.tlv_frame_num,
                             frmd_tdata_w0.resv1,
                             frmd_tdata_w0.tlv_eng_id,
                             frmd_tdata_w0.tlv_seq_num,
                             footer_len, 
                             FTR
                             }
                            ); 

    
    
    
    
    
    
    
    
    
    fgen_user_wr          = 1'b0;
    footer_done_pulse     = 1'b0;
    start_footer_clr_nxt  = 1'b0;
    fgen.insert           = 1'b1;
    fgen.ordern           = data_tlv_w0_reg.ordern + `TLVP_ORD_NUM_WIDTH'h1;   
    fgen.typen            = data_tlv_w0_reg.typen;
    fgen.sot              = 1'b0;
    fgen.eot              = 1'b0;
    fgen.tlast            = 1'b0;
    fgen.tid              = data_tlv_w0_reg.tid;
    fgen.tstrb            = data_tlv_w0_reg.tstrb;
    fgen.tuser            = `AXI_S_USER_WIDTH'(0);
    fgen.tdata            = 64'h0;     

    prefix_err_cqe         = {20'h0, footer_comp_len, ISF_PREFIX_ERR, 1'b0, prefix_err_frame};
    err_cqe                = {20'h0, footer_comp_len, 20'h0};         

    
    start_footer          = start_footer_pulse || start_footer_hld;

    case (fgen_st)
      
      FGEN_IDLE:
      begin
        if (start_footer && isf_user_wr_rdy)
        begin
          fgen.tdata  = {
                         footer_bip2,
                         {2'b0, cmd_frmd_out_type_reg, 2'b0, footer_raw_mac_size, footer_enc_mac_size, footer_coding, 1'b0},
                         frmd_tdata_w0.tlv_frame_num,
                         frmd_tdata_w0.resv1,
                         frmd_tdata_w0.tlv_eng_id,
                         frmd_tdata_w0.tlv_seq_num,
                         footer_len,
                         FTR 
                         }; 

          fgen.sot              = 1'b1;
          fgen.tuser            = `AXI_S_USER_WIDTH'(1);
          fgen_user_wr          = 1'b1;
          start_footer_clr_nxt  = 1'b1;
          fgen_st_nxt           = FGEN_W1;
        end
        else
        begin
          fgen_st_nxt  = FGEN_IDLE;
        end
      end

      
      FGEN_W1: 
      begin
        if (isf_user_wr_rdy)
        begin
          fgen.tdata    = footer_raw_mac0;
          fgen_user_wr  = 1'b1;
          fgen_st_nxt   = FGEN_W2;
        end
        else
        begin
          fgen_st_nxt  = FGEN_W1;
        end
      end

     
      FGEN_W2: 
      begin
        if (isf_user_wr_rdy)
        begin
          fgen.tdata    = footer_raw_mac1;
          fgen_user_wr  = 1'b1;
          fgen_st_nxt   = FGEN_W3;
        end
        else
        begin
          fgen_st_nxt  = FGEN_W2;
        end
      end

     
      FGEN_W3:   
      begin
        if (isf_user_wr_rdy)
        begin
          fgen.tdata    = footer_raw_mac2;
          fgen_user_wr  = 1'b1;
          fgen_st_nxt   = FGEN_W4;
        end
        else
        begin
          fgen_st_nxt  = FGEN_W3;
        end
      end

     
      FGEN_W4: 
      begin
        if (isf_user_wr_rdy)
        begin
          fgen.tdata    = footer_raw_mac3;
          fgen_user_wr  = 1'b1;
          fgen_st_nxt   = FGEN_W5;
        end
        else
        begin
          fgen_st_nxt  = FGEN_W4;
        end
      end

     
      FGEN_W5: 
      begin
        if (isf_user_wr_rdy)
        begin
          fgen.tdata    = footer_raw_cksum;
          fgen_user_wr  = 1'b1;
          fgen_st_nxt   = FGEN_W6;
        end
        else
        begin
          fgen_st_nxt  = FGEN_W5;
        end
      end

     
      FGEN_W6: 
      begin
        if (isf_user_wr_rdy)
        begin
          fgen.tdata    = 64'h0;
          fgen_user_wr  = 1'b1;
          fgen_st_nxt   = FGEN_W7;
        end
        else
        begin
          fgen_st_nxt  = FGEN_W6;
        end
      end

      
      FGEN_W7: 
      begin
        if (isf_user_wr_rdy)
        begin
          fgen.tdata    = footer_enc_mac0;
          fgen_user_wr  = 1'b1;
          fgen_st_nxt   = FGEN_W8;
        end
        else
        begin
          fgen_st_nxt  = FGEN_W7;
        end
      end

     
      FGEN_W8: 
      begin
        if (isf_user_wr_rdy)
        begin
          fgen.tdata    = footer_enc_mac1;
          fgen_user_wr  = 1'b1;
          fgen_st_nxt   = FGEN_W9;
        end
        else
        begin
          fgen_st_nxt  = FGEN_W8;
        end
      end

     
      FGEN_W9: 
      begin
        if (isf_user_wr_rdy)
        begin
          fgen.tdata    = footer_enc_mac2;
          fgen_user_wr  = 1'b1;
          fgen_st_nxt   = FGEN_W10;
        end
        else
        begin
          fgen_st_nxt  = FGEN_W9;
        end
      end

     
      FGEN_W10: 
      begin
        if (isf_user_wr_rdy)
        begin
          fgen.tdata    = footer_enc_mac3;
          fgen_user_wr  = 1'b1;
          fgen_st_nxt   = FGEN_W11;
        end
        else
        begin
          fgen_st_nxt  = FGEN_W10;
        end
      end

     
      FGEN_W11: 
      begin
        if (isf_user_wr_rdy)
        begin
          fgen.tdata    = footer_enc_cksum;
          fgen_user_wr  = 1'b1;
          fgen_st_nxt   = FGEN_W12;
        end
        else
        begin
          fgen_st_nxt  = FGEN_W11;
        end
      end
 
      
      FGEN_W12: 
      begin
        if (isf_user_wr_rdy)
        begin
          fgen.tdata    = {footer_nvme_raw_cksum_crc16t, bytes_in_cnt[23:0], 24'h0};  
          fgen_user_wr  = 1'b1;
          fgen_st_nxt   = FGEN_W13;
        end
        else
        begin
          fgen_st_nxt  = FGEN_W12;
        end
      end

      
      
      FGEN_W13: 
      begin
        if (isf_user_wr_rdy)
        begin
          fgen.tdata         = prefix_err  ? prefix_err_cqe : err_cqe;
          fgen_user_wr       = 1'b1;
          fgen.eot           = 1'b1;
          fgen.tuser         = `AXI_S_USER_WIDTH'(2);
          footer_done_pulse  = 1'b1;
          fgen_st_nxt        = FGEN_IDLE;
        end
        else
        begin
          fgen_st_nxt  = FGEN_W13;
        end
      end

      default: 
      begin
        fgen.tdata   = 64'h0;
        fgen_st_nxt  = FGEN_IDLE;
      end
    endcase
  end

  
  always_ff @(posedge clk or negedge rst_n)
  begin
    if (~rst_n) 
    begin
      fgen_st          <= FGEN_IDLE;
      start_footer_clr <= 1'b0;
      start_footer_hld <= 1'b0;
     
    end
    else
    begin
      fgen_st          <= fgen_st_nxt;

      
      
      start_footer_clr <= start_footer_clr_nxt; 
      start_footer_hld <= start_footer_clr ? 1'b0 : (start_footer_pulse ? 1'b1 : start_footer_hld);
    end
  end

  
  
  

  
  
  
  
  
  
  
  
  
  
  
  function mask_match;
    input [31:0] tdata;
    input [31:0] match_val;
    input [31:0] mask_val;

    reg [31:0]   cmp_val;
    reg [31:0]   cmp_mask_val;

    begin
      cmp_val       = tdata ^ match_val;
      cmp_mask_val  = cmp_val & mask_val;
      mask_match    = cmp_mask_val == 32'h0;
    end
endfunction

endmodule 










