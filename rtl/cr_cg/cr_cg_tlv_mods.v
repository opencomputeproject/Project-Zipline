/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/








































module cr_cg_tlv_mods #
(
 parameter  STUB_MODE=0
 )

(
  
  cg_ib_out, cg_ob_out, cg_int, cg_stat_events,
  
  clk, rst_n, cg_tlv_parse_action_0, cg_tlv_parse_action_1,
  debug_ctl_config, cg_ib_in, cg_ob_in, cg_module_id, cceip_cfg
  );
  
`include "cr_structs.sv"
  
  import cr_cgPKG::*;
  import cr_cg_regsPKG::*;

  
  
  
  input                                 clk;
  input                                 rst_n; 
  
  
  
  
  input  cg_tlv_parse_action_31_0_t     cg_tlv_parse_action_0;
  input  cg_tlv_parse_action_63_32_t    cg_tlv_parse_action_1;
  input  debug_ctl_t                    debug_ctl_config;

  
  
  
  input  axi4s_dp_bus_t                 cg_ib_in;
  output axi4s_dp_rdy_t                 cg_ib_out;

  
  
  
  input  axi4s_dp_rdy_t                 cg_ob_in;
  output axi4s_dp_bus_t                 cg_ob_out;

  
  
  
  output tlvp_int_t                     cg_int;

  
  
  
  output cg_stats_t                     cg_stat_events;

  
  
  
  input  [`MODULE_ID_WIDTH-1:0]         cg_module_id;
  input                                 cceip_cfg;
  
  
  

  logic                                 cg_term_empty;
  logic                                 cg_term_rd;
  logic                                 cg_user_full;
  logic                                 cg_user_afull;
  logic                                 cg_user_wr;
  logic                                 cg_term_rd_rdy;
  logic                                 cg_user_wr_rdy;
  logic [4:0]                           ix_nxt;
  logic [4:0]                           ix;
  logic                                 tgen_user_wr_nxt;
  logic                                 tgen_user_wr;
  logic                                 tlvp_err;
  integer                               j;
  integer                               i0;
  integer                               i1;
  integer                               i2;
  integer                               i3;
  integer                               i4;
  integer                               i5;
  integer                               i6;
  integer                               i7;
  integer                               i8;
  integer                               i9;
  integer                               i10;
  integer                               i11;
  integer                               i12;
  integer                               i13;
  integer                               i14;
  integer                               i15;
  integer                               i16;
  integer                               i17;
  integer                               i18;
  integer                               i19;

  cg_tlv_mod_out_sel_e                  out_sel;
  cg_tlv_mod_out_sel_e                  out_sel_nxt;
  cg_user_xfr_st_e                      cg_user_xfr_st;
  cg_user_xfr_st_e                      cg_user_xfr_st_nxt;

  tlv_ftr_word0_t                       ftr_w0_fmt; 
  tlv_ftr_word13_t                      ftr_w19_fmt; 
  tlv_ftr_word13_t                      ftr_w19_live_fmt; 
  tlv_types_e                           frmd_out_type;
  tlv_types_e                           adj_frmd_out_type;
  tlv_ftr_word12_t                      ftr_w18_fmt; 
  ftr_error_t                           ftr_err_save; 
  tlv_cqe_word1_t                       cqe_w1_fmt;   
  tlv_cqe_word1_t                       cqe_w1_fin; 
  tlvp_if_bus_t                         cqe_tlv_w0_reg;
  tlvp_if_bus_t                         cqe_tlv_w0_reg_mod;
  tlvp_if_bus_t                         cqe_tlv_w1_reg;
  tlvp_if_bus_t                         cqe_tlv_fin_w1;
  tlvp_if_bus_t                         stats_tlv_w0;
  tlvp_if_bus_t                         stats_tlv_fin_w1;
  tlvp_if_bus_t                         stats_tlv_fin_w2;
  tlvp_if_bus_t                         cg_user_tlv;
  tlvp_if_bus_t                         cg_term_tlv;
  tlvp_if_bus_t                         ftr_tlv_w0_reg;
  tlvp_if_bus_t                         tgen_out_nxt;
  tlvp_if_bus_t                         tgen_out;
  cg_tgen_st_e                          tgen_st;
  cg_tgen_st_e                          tgen_st_nxt;
  tlv_cmd_word_1_t                      cmd_tlv_tdata_w1;  
  tlv_word_0_t                          stats_tlv_tdata_w0;
  tlv_stats_word1_t                     stats_fin_w1;
  tlv_stats_word2_t                     stats_fin_w2;

  logic [`TLV_LEN_WIDTH-1:0]            frmd_len_mux; 
  logic                                 start_fgen_pulse;
  logic                                 start_new_cmd_pulse;
  logic                                 stats_w0_ld;
  logic                                 stats_w1_ld;
  logic                                 stats_w2_ld;
  logic                                 cqe_w0_ld;
  logic                                 cqe_w1_ld;
  logic [`N_FTR_WORDS_EXP-1:0]          cg_ftr_ld;
  logic [`N_FTR_WORDS_EXP-1:0]          cg_ftr_val;
  logic [1:0]                           guid_bip2;
  logic [1:0]                           frmd_bip2;
  logic                                 start_new_cmd;
  logic                                 start_fgen;
  logic                                 start_new_cmd_clr_nxt;
  logic                                 start_new_cmd_clr;
  logic                                 start_fgen_clr;
  logic                                 user_vm_nxt;
  logic                                 frmd_vm_nxt;
  logic                                 frmd_vm_short_nxt;
  logic                                 user_vm;
  logic                                 frmd_vm;
  logic                                 frmd_vm_short;
  logic [63:0]                          cg_ftr_reg[`N_FTR_WORDS_EXP-1:0];
  logic                                 start_new_cmd_hld;
  logic                                 start_fgen_hld;
  logic                                 cqe_w0_val;
  logic                                 cqe_w1_val;
  logic                                 stats_val_clr;
  logic                                 stats_val_clr_nxt;
  logic                                 cg_val_clr;
  logic                                 tgen_idle;
  logic                                 tgen_idle_nxt;
  logic                                 tgen_cmd_end;
  logic                                 tgen_cmd_end_nxt;
  logic [24:0]                          ftr_agg_bytes_in;  
  logic [24:0]                          ftr_agg_bytes_out;
  logic                                 ftr_err_clr;
  logic                                 ftr_err_clr_nxt;
  logic                                 new_cmd_nxt;
  logic                                 new_cmd;
  logic                                 gen_guid_ld;
  logic                                 gen_guid;
  logic                                 stats_en;
  logic                                 frmd_out_type_undef;
  logic                                 cqe_sys_err;
  logic                                 cqe_eng_err;
  logic [7:0]                           cqe_eng_err_cmp;
  logic [7:0]                           cqe_eng_err_mask;
  logic                                 cqe_eng_err_match;



  
  
  
  `CCX_STD_CALC_BIP2(get_bip2, `AXI_S_DP_DWIDTH);  
  
  
  
  
  assign cg_int.tlvp_err  = tlvp_err;

  
  
  
  

  cr_tlvp_axi_in_axi_out_top # 
  
   (
    .N_AXIS_ENTRIES          (8),
    .N_AXIS_AFULL_VAL        (3),
    .N_AXIS_AEMPTY_VAL       (1),
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
    .N_UF_AFULL_VAL          (3),
    .N_UF_AEMPTY_VAL         (1))
  u_cr_cg_tlvp
  (
   
   
   .axi4s_ib_out                        (cg_ib_out),             
   .term_empty                          (cg_term_empty),         
   .term_aempty                         (),                      
   .term_tlv                            (cg_term_tlv),           
   .usr_full                            (cg_user_full),          
   .usr_afull                           (cg_user_afull),         
   .bip2_error                          (tlvp_err),              
   .axi4s_ob_out                        (cg_ob_out),             
   
   .clk                                 (clk),
   .rst_n                               (rst_n),
   .tlv_parse_action                    ({cg_tlv_parse_action_1,cg_tlv_parse_action_0}), 
   .axi4s_ib_in                         (cg_ib_in),              
   .term_rd                             (cg_term_rd),            
   .usr_wr                              (cg_user_wr),            
   .usr_tlv                             (cg_user_tlv),           
   .axi4s_ob_in                         (cg_ob_in),              
   .module_id                           (cg_module_id[`MODULE_ID_WIDTH-1:0])); 

  
  
  
  
  assign cmd_tlv_tdata_w1  = cg_term_tlv.tdata;

  assign cg_user_wr        = tgen_user_wr; 
  assign cg_term_rd_rdy    = !cg_term_empty;
  assign cg_user_wr_rdy    = !cg_user_afull;

  
  
 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  always_comb
  begin
    
    cg_term_rd           = 1'b0;
    ix_nxt               = ix;
    start_fgen_pulse     = 1'b0;
    start_new_cmd_pulse  = 1'b0;
    stats_w0_ld          = 1'b0;
    stats_w1_ld          = 1'b0;
    stats_w2_ld          = 1'b0;
    cqe_w0_ld            = 1'b0;
    cqe_w1_ld            = 1'b0;
    cg_ftr_ld            = 23'h0;
    cg_val_clr           = 1'b0;
    new_cmd_nxt          = 1'b0;
    gen_guid_ld          = 1'b0;

    case (cg_user_xfr_st)
      
      
      
      CG_UXFR_IDLE:
      begin
        if (cg_term_rd_rdy && cg_term_tlv.sot && (cg_term_tlv.typen == RQE)) 
        begin
          cg_term_rd          = 1'b1;
          cg_user_xfr_st_nxt  = CG_UXFR_RQE_W0;
        end
        
        else 
        begin
          cg_term_rd          = cg_term_rd_rdy ? 1'b1 : 1'b0;
          cg_user_xfr_st_nxt  = CG_UXFR_IDLE;
        end
      end

      
      CG_UXFR_RQE_W0:
      begin
        if (cg_term_rd_rdy && cg_term_tlv.sot && (cg_term_tlv.typen == CMD)) 
        begin
          cg_term_rd          = 1'b1;
          cg_user_xfr_st_nxt  = CG_UXFR_CMD_W0;
        end
        
        else 
        begin
          cg_term_rd          = cg_term_rd_rdy ? 1'b1 : 1'b0;
          cg_user_xfr_st_nxt  = CG_UXFR_RQE_W0;
        end
      end

       
      CG_UXFR_CMD_W0:
      begin
        if (cg_term_rd_rdy && (cg_term_tlv.typen == CMD))  
        begin
          cg_term_rd          = 1'b1;
          gen_guid_ld         = 1'b1;
          cg_user_xfr_st_nxt  = CG_UXFR_CMD_W1;
        end
        else
        begin
          cg_user_xfr_st_nxt  = CG_UXFR_CMD_W0;
        end
      end

      
      
      
      
      
      
      
      CG_UXFR_CMD_W1:
      begin
        if (cg_term_rd_rdy && cg_term_tlv.sot && (cg_term_tlv.typen == FTR)) 
        begin
          cg_val_clr          = 1'b1;  
          new_cmd_nxt         = 1'b1; 
          cg_user_xfr_st_nxt  = CG_UXFR_FIRST_FTR_W0;
        end
        
        else 
        begin
          cg_term_rd          = cg_term_rd_rdy ? 1'b1 : 1'b0;
          cg_user_xfr_st_nxt  = CG_UXFR_CMD_W1;
        end
      end

      
      
      
      
      
      
      
      
      CG_UXFR_FIRST_FTR_W0:
      begin
        cg_term_rd           = 1'b1;
        cg_ftr_ld[0]         = 1'b1;
        ix_nxt               = 5'h1;
        start_fgen_pulse     = 1'b1;  
        start_new_cmd_pulse  = 1'b1;
        cg_user_xfr_st_nxt   = CG_UXFR_FTR;
      end

      
      
      
      
      
      CG_UXFR_FTR_W0:
      begin
        cg_term_rd           = 1'b1;
        cg_ftr_ld[0]         = 1'b1;
        ix_nxt               = 5'h1;
        start_fgen_pulse     = 1'b1;  
        cg_user_xfr_st_nxt   = CG_UXFR_FTR;
      end

      
      
      CG_UXFR_FTR:
      begin
        if (cg_term_rd_rdy) 
        begin
          cg_term_rd          = 1'b1;
          cg_ftr_ld[ix]       = 1'b1;  
          ix_nxt              = ix + 5'h1;
          cg_user_xfr_st_nxt  = cg_term_tlv.eot ? CG_UXFR_FTR_DONE : CG_UXFR_FTR;
        end
        else
        begin
          ix_nxt              = ix;
          cg_user_xfr_st_nxt  = CG_UXFR_FTR;
        end
      end

      
      
      
      
      
      CG_UXFR_FTR_DONE:
      begin
        
        if (cg_term_rd_rdy && cg_term_tlv.sot && (cg_term_tlv.typen == CQE)) 
        begin
          ix_nxt              = 5'h0;
          cqe_w0_ld           = 1'b1; 
          cg_term_rd          = 1'b1;
          cg_user_xfr_st_nxt  = CG_UXFR_CQE_W0;
        end
        
        
        
        
        else if (cg_term_rd_rdy && cg_term_tlv.sot && (cg_term_tlv.typen == FTR)) 
        begin
          cg_val_clr          = tgen_idle ? 1'b1           : 1'b0;
          cg_user_xfr_st_nxt  = tgen_idle ? CG_UXFR_FTR_W0 : CG_UXFR_FTR_DONE;
        end

        
        
        else 
        begin
          cg_term_rd          = cg_term_rd_rdy ? 1'b1 : 1'b0; 
          cg_user_xfr_st_nxt  = CG_UXFR_FTR_DONE;
        end
      end

      CG_UXFR_CQE_W0:
      begin
        ix_nxt  = 5'h0;

        
        
        
        if (cg_term_rd_rdy)
        begin
          cqe_w1_ld           = 1'b1;
          cg_term_rd          = 1'b1;
          cg_user_xfr_st_nxt  = tgen_cmd_end ? CG_UXFR_IDLE : CG_UXFR_WAIT;
        end
        else
        begin
          cg_user_xfr_st_nxt  = CG_UXFR_CQE_W0;
        end
      end

      
      
      CG_UXFR_WAIT:
      begin
        cg_user_xfr_st_nxt  = tgen_cmd_end ? CG_UXFR_IDLE : CG_UXFR_WAIT;
      end

      default:
      begin
        ix_nxt              = 5'h0;
        cg_user_xfr_st_nxt  = CG_UXFR_IDLE;
      end
    endcase
  end


  
  
  
  
  
  
  assign ftr_w0_fmt        = cg_ftr_reg[i0];
  assign ftr_w19_fmt       = cg_ftr_reg[i19];
  assign ftr_w19_live_fmt  = cg_term_tlv.tdata;
  assign ftr_w18_fmt       = cg_term_tlv.tdata;
  assign frmd_out_type     = tlv_types_e'(ftr_w0_fmt.gen_frmd_out_type);
  
    
  assign guid_bip2  = get_bip2
                      (
                       {
                        2'b0,
                        19'h0,
                        ftr_w0_fmt.tlv_frame_num,
                        ftr_w0_fmt.rsvd0,
                        ftr_w0_fmt.tlv_eng_id,
                        ftr_w0_fmt.tlv_seq_num,
                        `CG_GUID_LEN,
                        GUID    
                        }
                       ); 


  assign frmd_bip2  = get_bip2 
                      (
                       {
                        2'b0,
                        19'h0,
                        ftr_w0_fmt.tlv_frame_num,
                        ftr_w0_fmt.rsvd0,
                        ftr_w0_fmt.tlv_eng_id,
                        ftr_w0_fmt.tlv_seq_num,
                        frmd_len_mux,  
                        adj_frmd_out_type 
                        }
                       );


    
  assign start_new_cmd  = start_new_cmd_pulse || start_new_cmd_hld;
  assign start_fgen     = start_fgen_pulse    || start_fgen_hld;

  
  
  assign frmd_out_type_undef  =
                               !( 
                                  (frmd_out_type == FRMD_USER_NULL) ||
                                  (frmd_out_type == FRMD_USER_PI16) ||
                                  (frmd_out_type == FRMD_USER_PI64) ||
                                  (frmd_out_type == FRMD_USER_VM) ||
                                  (frmd_out_type == FRMD_INT_APP) ||
                                  (frmd_out_type == FRMD_INT_SIP) ||
                                  (frmd_out_type == FRMD_INT_LIP) ||
                                  (frmd_out_type == FRMD_INT_VM)   ||
                                  (frmd_out_type == FRMD_INT_VM_SHORT) 
                                  );
  
  assign adj_frmd_out_type    = !frmd_out_type_undef ? frmd_out_type : 
                                (cceip_cfg ? FRMD_INT_APP : FRMD_USER_NULL);


  
  always_comb
  begin
    case (adj_frmd_out_type)
      FRMD_USER_PI16    : frmd_len_mux  = `TLV_LEN_WIDTH'(4); 
      FRMD_USER_PI64    : frmd_len_mux  = `TLV_LEN_WIDTH'(4);
      FRMD_USER_VM      : frmd_len_mux  = `TLV_LEN_WIDTH'(16);
      FRMD_INT_APP      : frmd_len_mux  = `TLV_LEN_WIDTH'(13);
      FRMD_INT_SIP      : frmd_len_mux  = `TLV_LEN_WIDTH'(7);
      FRMD_INT_LIP      : frmd_len_mux  = `TLV_LEN_WIDTH'(13);
      FRMD_INT_VM       : frmd_len_mux  = `TLV_LEN_WIDTH'(25);
      FRMD_INT_VM_SHORT : frmd_len_mux  = `TLV_LEN_WIDTH'(19);
      default           : frmd_len_mux  = `TLV_LEN_WIDTH'(2); 
    endcase
  end

  
  
  
  generate if (STUB_MODE)
  begin
    assign    i0 = 0;
    assign    i1 = 0;
    assign    i2 = 0;
    assign    i3 = 0;
    assign    i4 = 0;
    assign    i5 = 19;
    assign    i6 = 19;
    assign    i7 = 7-6;
    assign    i8 = 8-6;
    assign    i9 = 9-6;
    assign    i10 = 10-6;
    assign    i11 = 11-6;
    assign    i12 = 12-6;
    assign    i13 = 13-6;
    assign    i14 = 14-6;
    assign    i15 = 15-6;
    assign    i16 = 16-6;
    assign    i17 = 17-6;
    assign    i18 = 18-6;
    assign    i19 = 19-6;
    end
  else
  begin
    assign    i0 = 0;
    assign    i1 = 1;
    assign    i2 = 2;
    assign    i3 = 3;
    assign    i4 = 4;
    assign    i5 = 5;
    assign    i6 = 6;
    assign    i7 = 7;
    assign    i8 = 8;
    assign    i9 = 9;
    assign    i10 = 10;
    assign    i11 = 11;
    assign    i12 = 12;
    assign    i13 = 13;
    assign    i14 = 14;
    assign    i15 = 15;
    assign    i16 = 16;
    assign    i17 = 17;
    assign    i18 = 18;
    assign    i19 = 19;
  end
  endgenerate

  always_comb
  begin
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    tgen_user_wr_nxt         = 1'b0; 
    start_new_cmd_clr_nxt    = 1'b0;
    start_fgen_clr           = 1'b0;
    tgen_out_nxt.insert      = 1'b0;
    tgen_out_nxt.ordern      = tgen_out.ordern;
    tgen_out_nxt.typen       = ftr_tlv_w0_reg.typen; 
    tgen_out_nxt.sot         = 1'b0;
    tgen_out_nxt.eot         = 1'b0;
    tgen_out_nxt.tlast       = 1'b0;
    tgen_out_nxt.tid         = ftr_tlv_w0_reg.tid;
    tgen_out_nxt.tstrb       = 8'hff;
    tgen_out_nxt.tuser       = `AXI_S_USER_WIDTH'(0);
    tgen_out_nxt.tdata       = 64'h0;
    user_vm_nxt              = user_vm;    
    frmd_vm_nxt              = frmd_vm;    
    frmd_vm_short_nxt        = frmd_vm_short;    
    out_sel_nxt              = out_sel;
    tgen_idle_nxt            = 1'b0;
    tgen_cmd_end_nxt         = 1'b0;
    stats_val_clr_nxt        = 1'b0;
    ftr_err_clr_nxt          = 1'b0;

    case (tgen_st)
      
      CG_TGEN_IDLE:
      begin
        out_sel_nxt = CG_SEL_FGEN;

        
        
        
        
        if (start_new_cmd && cg_user_wr_rdy && gen_guid && cg_ftr_val[i0])  
        begin
          tgen_out_nxt.tdata     = {
                                    guid_bip2,           
                                    19'h0,
                                    ftr_w0_fmt.tlv_frame_num,
                                    ftr_w0_fmt.rsvd0,
                                    ftr_w0_fmt.tlv_eng_id,
                                    ftr_w0_fmt.tlv_seq_num,
                                    `CG_GUID_LEN,
                                    GUID 
                                    }; 

          tgen_out_nxt.sot       = 1'b1;
          tgen_out_nxt.tuser     = `AXI_S_USER_WIDTH'(1);
          tgen_out_nxt.ordern    = `TLVP_ORD_NUM_WIDTH'(1);
          tgen_user_wr_nxt       = 1'b1;
          start_new_cmd_clr_nxt  = 1'b1;
          user_vm_nxt            = 1'b0;    
          frmd_vm_nxt            = 1'b0;    
          frmd_vm_short_nxt      = 1'b0;    
          
          tgen_st_nxt            = CG_GGEN_W0;
        end
        else if (start_new_cmd && !gen_guid)
        begin
          tgen_out_nxt.ordern    = `TLVP_ORD_NUM_WIDTH'(1);
          start_new_cmd_clr_nxt  = 1'b1;
          user_vm_nxt            = 1'b0;    
          frmd_vm_nxt            = 1'b0;    
          frmd_vm_short_nxt      = 1'b0;    
          tgen_st_nxt            = CG_FIRST_FRMD;
        end
        else
        begin
          
          
          
          
          
          
          tgen_idle_nxt  = cg_user_wr_rdy ? 1'b1 : 1'b0;
 
          
          
          
          
          tgen_cmd_end_nxt  = start_new_cmd ? 1'b0 : 1'b1;
          tgen_st_nxt       = CG_TGEN_IDLE;
        end
      end


      
      
      
      

      
      CG_GGEN_W0: 
      begin
        if (cg_user_wr_rdy && cg_ftr_val[i1])
        begin
          tgen_out_nxt.tdata   = cg_ftr_reg[i1];
          tgen_user_wr_nxt     = 1'b1;
          tgen_st_nxt          = CG_GGEN_W1;
        end
        else
        begin
          tgen_st_nxt  = CG_GGEN_W0;
        end
      end

      
      CG_GGEN_W1: 
      begin
        if (cg_user_wr_rdy && cg_ftr_val[i2])
        begin
          tgen_out_nxt.tdata   = cg_ftr_reg[i2];
          tgen_user_wr_nxt     = 1'b1;
          tgen_st_nxt          = CG_GGEN_W2;
        end
        else
        begin
          tgen_st_nxt  = CG_GGEN_W1;
        end
      end

      
      CG_GGEN_W2: 
      begin
        if (cg_user_wr_rdy && cg_ftr_val[i3])
        begin
          tgen_out_nxt.tdata   = cg_ftr_reg[i3];
          tgen_user_wr_nxt     = 1'b1;
          tgen_st_nxt          = CG_GGEN_W3;
        end
        else
        begin
          tgen_st_nxt  = CG_GGEN_W2; 
        end
      end

      
      
      
      CG_GGEN_W3: 
      begin
        if (cg_user_wr_rdy && cg_ftr_val[i4])
        begin
          tgen_out_nxt.tdata   = cg_ftr_reg[i4];
          tgen_user_wr_nxt     = 1'b1;
          tgen_out_nxt.eot     = 1'b1;
          tgen_out_nxt.tuser   = `AXI_S_USER_WIDTH'(2);
          tgen_st_nxt          = CG_FIRST_FRMD; 
        end
        else
        begin
          tgen_st_nxt  = CG_GGEN_W3;
        end
      end

      CG_FIRST_FRMD:
      begin
        out_sel_nxt = CG_SEL_FGEN;

        
        
        if (start_fgen && cg_user_wr_rdy)
        begin
          tgen_out_nxt.tdata  = {
                                 frmd_bip2,
                                 19'h0,
                                 ftr_w0_fmt.tlv_frame_num,
                                 ftr_w0_fmt.rsvd0,
                                 ftr_w0_fmt.tlv_eng_id,
                                 ftr_w0_fmt.tlv_seq_num,
                                 frmd_len_mux,  
                                 adj_frmd_out_type 
                                 }; 

          tgen_out_nxt.sot     = 1'b1;
          tgen_out_nxt.tuser   = `AXI_S_USER_WIDTH'(1);

          
          
          tgen_out_nxt.ordern  = gen_guid ? tgen_out.ordern + `TLVP_ORD_NUM_WIDTH'(1) : 
                                 `TLVP_ORD_NUM_WIDTH'(1);

          tgen_user_wr_nxt     = 1'b1;
          start_fgen_clr       = 1'b1;
          user_vm_nxt          = 1'b0;    
          frmd_vm_nxt          = 1'b0;    
          frmd_vm_short_nxt    = 1'b0;    

          
          case (adj_frmd_out_type)
            FRMD_INT_APP,
          FRMD_INT_SIP,
          FRMD_INT_LIP: tgen_st_nxt  = CG_FGEN_INT_W0;

            FRMD_INT_VM:    
            begin
              frmd_vm_nxt  = 1'b1;    
              tgen_st_nxt  = CG_FGEN_INT_W0;
            end

            FRMD_INT_VM_SHORT:    
            begin
              frmd_vm_short_nxt  = 1'b1;    
              tgen_st_nxt        = CG_FGEN_INT_W0; 
            end

            FRMD_USER_PI16: tgen_st_nxt  = CG_FGEN_USER_PI16_W0;
            FRMD_USER_PI64: tgen_st_nxt  = CG_FGEN_USER_PI64_W0;

            FRMD_USER_VM:   
            begin
              user_vm_nxt  = 1'b1;    
              tgen_st_nxt  = CG_FGEN_USER_VM_W0;
            end

            FRMD_USER_NULL:        
            begin
              tgen_out_nxt.eot    = 1'b1;
              tgen_out_nxt.tuser  = `AXI_S_USER_WIDTH'(3);
              tgen_st_nxt         = CG_END_FRMD; 
            end

            default:        
            begin
              tgen_out_nxt.eot         = 1'b1;
              tgen_out_nxt.tuser       = `AXI_S_USER_WIDTH'(3);
              tgen_st_nxt              = CG_END_FRMD; 
            end
          endcase
        end
        else
        begin
          tgen_st_nxt  = CG_FIRST_FRMD;
        end
      end

      
      
      
      
      
      CG_END_FRMD:
      begin
        out_sel_nxt = CG_SEL_FGEN;

        

        
        
        
        
        
        if (cqe_w0_val && cg_user_wr_rdy && !start_fgen) 
        begin
          out_sel_nxt          = CG_SEL_STATS_W0;
          tgen_out_nxt.ordern  = tgen_out.ordern + `TLVP_ORD_NUM_WIDTH'(1);
          tgen_user_wr_nxt     = 1'b1;
          tgen_st_nxt          = CG_SGEN_W0;
        end

        
        
        else if (start_fgen && cg_user_wr_rdy && cg_ftr_val[i0]) 
        begin
          tgen_out_nxt.tdata  = {
                                 frmd_bip2,
                                 19'h0,
                                 ftr_w0_fmt.tlv_frame_num,
                                 ftr_w0_fmt.rsvd0,
                                 ftr_w0_fmt.tlv_eng_id,
                                 ftr_w0_fmt.tlv_seq_num,
                                 frmd_len_mux,  
                                 adj_frmd_out_type
                                 }; 

          tgen_out_nxt.sot     = 1'b1;
          tgen_out_nxt.tuser   = `AXI_S_USER_WIDTH'(1);
          tgen_out_nxt.ordern  = tgen_out.ordern + `TLVP_ORD_NUM_WIDTH'(1);
          tgen_user_wr_nxt     = 1'b1;
          start_fgen_clr       = 1'b1;
          user_vm_nxt          = 1'b0;    
          frmd_vm_nxt          = 1'b0;    
          frmd_vm_short_nxt    = 1'b0;    

          
          case (adj_frmd_out_type)
            FRMD_INT_APP,
            FRMD_INT_SIP,
            FRMD_INT_LIP:  tgen_st_nxt  = CG_FGEN_INT_W0; 

            FRMD_INT_VM:    
            begin
              frmd_vm_nxt  = 1'b1;    
              tgen_st_nxt  = CG_FGEN_INT_W0;
            end

            FRMD_INT_VM_SHORT:    
            begin
              frmd_vm_short_nxt  = 1'b1;    
              tgen_st_nxt        = CG_FGEN_INT_W0; 
            end

            FRMD_USER_PI16: tgen_st_nxt  = CG_FGEN_USER_PI16_W0;
            FRMD_USER_PI64: tgen_st_nxt  = CG_FGEN_USER_PI64_W0;

            FRMD_USER_VM:   
            begin
             user_vm_nxt  = 1'b1;    
             tgen_st_nxt  = CG_FGEN_USER_VM_W0;
            end

            FRMD_USER_NULL:        
            begin
              tgen_out_nxt.eot    = 1'b1;
              tgen_out_nxt.tuser  = `AXI_S_USER_WIDTH'(3);
              tgen_idle_nxt       = 1'b1;
              tgen_st_nxt         = CG_END_FRMD; 
            end

            default:        
            begin
              tgen_out_nxt.eot         = 1'b1;
              tgen_out_nxt.tuser       = `AXI_S_USER_WIDTH'(3);
              tgen_idle_nxt            = 1'b1;
              tgen_st_nxt              = CG_END_FRMD; 
            end
          endcase
        end
        else
        begin
          
          
          
          
          tgen_idle_nxt  = cg_user_wr_rdy ? 1'b1 : 1'b0;
          tgen_st_nxt    = CG_END_FRMD;
        end
      end

      
      
      
      
      
      
      
      
      
      
      
      
      CG_FGEN_INT_LAST: 
      begin
        out_sel_nxt = CG_SEL_FGEN;

        if (cg_user_wr_rdy && cg_ftr_val[i19]) 
        begin
          tgen_user_wr_nxt    = 1'b1;
          tgen_idle_nxt       = 1'b1;
          tgen_out_nxt.eot    = 1'b1;
          tgen_out_nxt.tstrb  = 8'hf;
          tgen_out_nxt.tuser  = `AXI_S_USER_WIDTH'(2);
          tgen_st_nxt         = CG_END_FRMD; 
          tgen_out_nxt.tdata  = {32'h0, 6'h0, ftr_w0_fmt.coding, ftr_w19_fmt.compressed_length}; 
        end
        else
        begin
          tgen_st_nxt  = CG_FGEN_INT_LAST;
        end
      end

      
      CG_FGEN_INT_W0: 
      begin
        if (cg_user_wr_rdy && cg_ftr_val[i17])  
        begin
          tgen_out_nxt.tdata  = cg_ftr_reg[i17]; 
          tgen_user_wr_nxt    = 1'b1;
          tgen_st_nxt         = CG_FGEN_INT_W1; 
        end
        else
        begin
          tgen_st_nxt  = CG_FGEN_INT_W0;
        end
      end

      
      
      CG_FGEN_INT_W1: 
      begin
        if (cg_user_wr_rdy)  
        begin
          tgen_user_wr_nxt  = 1'b1;

          case (adj_frmd_out_type)
            
            FRMD_INT_APP:
            begin
              tgen_out_nxt.tdata  = cg_ftr_reg[i13];
              tgen_st_nxt         = CG_FGEN_EMAC_0; 
            end
            
            FRMD_INT_SIP:
            begin
              tgen_out_nxt.tdata   = cg_ftr_reg[i7];  
              tgen_st_nxt          = CG_FGEN_INT_LAST; 
            end
            
            FRMD_INT_LIP:
            begin
              tgen_out_nxt.tdata  = cg_ftr_reg[i7];
              tgen_st_nxt         = CG_FGEN_RMAC_0; 
            end

            
            FRMD_INT_VM_SHORT:
            begin
              tgen_out_nxt.tdata   = cg_ftr_reg[i13];
              frmd_vm_short_nxt    = 1'b1;    
              tgen_st_nxt          = CG_FGEN_EMAC_0; 
            end

            
            
            FRMD_INT_VM:
            begin
              tgen_out_nxt.tdata  = cg_ftr_reg[i13]; 
              frmd_vm_nxt         = 1'b1;    
              tgen_st_nxt         = CG_FGEN_EMAC_0;
            end

            default:
            begin
              tgen_out_nxt.tdata   = cg_ftr_reg[i7];  
              tgen_st_nxt          = CG_FGEN_INT_LAST; 
            end

          endcase
          end
        else
        begin
          tgen_st_nxt  = CG_FGEN_INT_W1;
        end
      end


      
      
      

      
      
      CG_FGEN_EMAC_0: 
      begin
        if (cg_user_wr_rdy)  
        begin
          tgen_out_nxt.tdata  = cg_ftr_reg[i14]; 
          tgen_user_wr_nxt    = 1'b1;
          tgen_st_nxt         = (frmd_vm || frmd_vm_short) ? CG_FGEN_EMAC_1 : CG_FGEN_EMAC2IV;
        end
        else
        begin
          tgen_st_nxt  = CG_FGEN_EMAC_0;
        end
      end

      
      
      CG_FGEN_EMAC_1: 
      begin
        if (cg_user_wr_rdy)  
        begin
          tgen_out_nxt.tdata  = cg_ftr_reg[i15]; 
          tgen_user_wr_nxt    = 1'b1;
          tgen_st_nxt         = CG_FGEN_EMAC_2; 
        end
        else
        begin
          tgen_st_nxt  = CG_FGEN_EMAC_1;
        end
      end

      
      CG_FGEN_EMAC_2: 
      begin
        if (cg_user_wr_rdy)  
        begin
          tgen_out_nxt.tdata  = cg_ftr_reg[i16]; 
          tgen_user_wr_nxt    = 1'b1;
          tgen_st_nxt         = (frmd_vm || frmd_vm_short) ? CG_FGEN_X2RMAC : CG_FGEN_EMAC2IV; 
        end
        else
        begin
          tgen_st_nxt  = CG_FGEN_EMAC_2;
        end
      end

      
      
      

      
      CG_FGEN_EMAC2IV: 
      begin
        if (cg_user_wr_rdy)  
        begin
          tgen_out_nxt.tdata  = cg_ftr_reg[i5];
          tgen_user_wr_nxt    = 1'b1;
          tgen_st_nxt         = CG_FGEN_IV_0;
        end
        else
        begin
          tgen_st_nxt  = CG_FGEN_EMAC2IV;
        end
      end

      
      CG_FGEN_IV_0: 
      begin
        if (cg_user_wr_rdy)  
        begin
          tgen_out_nxt.tdata   = cg_ftr_reg[i6]; 
          tgen_user_wr_nxt     = 1'b1;
          tgen_st_nxt          = CG_FGEN_INT_LAST; 
        end
        else
        begin
          tgen_st_nxt  = CG_FGEN_IV_0;
        end
      end

      
      
      

      
      
      CG_FGEN_X2RMAC: 
      begin
        if (cg_user_wr_rdy)  
        begin
          tgen_out_nxt.tdata  = cg_ftr_reg[i7]; 
          tgen_user_wr_nxt    = 1'b1;
          tgen_st_nxt         = frmd_vm_short ? CG_FGEN_EMAC2IV : CG_FGEN_RMAC_0; 
        end
        else
        begin
          tgen_st_nxt  = CG_FGEN_X2RMAC;
        end
      end

      
      CG_FGEN_RMAC_0: 
      begin
        if (cg_user_wr_rdy)  
        begin
          tgen_out_nxt.tdata  = cg_ftr_reg[i8]; 
          tgen_user_wr_nxt    = 1'b1;
          tgen_st_nxt         = CG_FGEN_RMAC_1; 
        end
        else
        begin
          tgen_st_nxt  = CG_FGEN_RMAC_0;
        end
      end

      
      
      CG_FGEN_RMAC_1: 
      begin
        if (cg_user_wr_rdy)  
        begin
          tgen_out_nxt.tdata  = cg_ftr_reg[i9]; 
          tgen_user_wr_nxt    = 1'b1;
          tgen_st_nxt         = CG_FGEN_RMAC_2; 
        end
        else
        begin
          tgen_st_nxt  = CG_FGEN_RMAC_1;
        end
      end

      
      CG_FGEN_RMAC_2: 
      begin
        if (cg_user_wr_rdy)  
        begin
          tgen_out_nxt.tdata   = cg_ftr_reg[i10]; 
          tgen_user_wr_nxt     = 1'b1;
          tgen_out_nxt.eot     = user_vm ? 1'b1                  : 1'b0; 
          tgen_out_nxt.tuser   = user_vm ? `AXI_S_USER_WIDTH'(2) : `AXI_S_USER_WIDTH'(0);
          tgen_st_nxt          = frmd_vm ? CG_FGEN_EMAC2IV : 
                                 (user_vm ?  CG_END_FRMD  : CG_FGEN_INT_LAST); 
        end
        else
        begin
          tgen_st_nxt  = CG_FGEN_RMAC_2;
        end
      end

      
      
      
      
      
      

      
      
      
      CG_FGEN_USER_PI16_W0: 
      begin
        if (cg_user_wr_rdy && cg_ftr_val[i18]) 
        begin
          tgen_out_nxt.tdata   = {48'h0,cg_ftr_reg[i18][63:48]};
          tgen_user_wr_nxt     = 1'b1;
          tgen_out_nxt.eot     = 1'b1;
          tgen_out_nxt.tuser   = `AXI_S_USER_WIDTH'(2);
          tgen_idle_nxt        = 1'b1;
          tgen_st_nxt          = CG_END_FRMD; 
        end
        else
        begin
          tgen_st_nxt  = CG_FGEN_USER_PI16_W0;
        end
      end

      
      
      CG_FGEN_USER_PI64_W0: 
      begin
        if (cg_user_wr_rdy && cg_ftr_val[i11]) 
        begin
          tgen_out_nxt.tdata   = cg_ftr_reg[i11]; 
          tgen_user_wr_nxt     = 1'b1;
          tgen_out_nxt.eot     = 1'b1;
          tgen_out_nxt.tuser   = `AXI_S_USER_WIDTH'(2);
          tgen_idle_nxt        = 1'b1;
          tgen_st_nxt          = CG_END_FRMD; 
        end
        else
        begin
          tgen_st_nxt  = CG_FGEN_USER_PI64_W0;
        end
      end

      
      
      
      
      
      CG_FGEN_USER_VM_W0: 
      begin
        if (cg_user_wr_rdy && cg_ftr_val[i5]) 
        begin
          tgen_out_nxt.tdata  = cg_ftr_reg[i5]; 
          tgen_user_wr_nxt    = 1'b1;
          tgen_st_nxt         = CG_FGEN_USER_VM_W1;
        end
        else
        begin
          tgen_st_nxt  = CG_FGEN_USER_VM_W0;
        end
      end

      
      
      
      
      CG_FGEN_USER_VM_W1: 
      begin
        if (cg_user_wr_rdy && cg_ftr_val[i6]) 
        begin
          tgen_out_nxt.tdata  = cg_ftr_reg[i6];
          tgen_user_wr_nxt    = 1'b1;
          tgen_st_nxt         = CG_FGEN_USER_VM_W2;
        end
        else
        begin
          tgen_st_nxt  = CG_FGEN_USER_VM_W1;
        end
      end

      
      
      
      CG_FGEN_USER_VM_W2: 
      begin
        if (cg_user_wr_rdy && cg_ftr_val[i11]) 
        begin
          tgen_out_nxt.tdata  = cg_ftr_reg[i11]; 
          tgen_user_wr_nxt    = 1'b1;
          tgen_st_nxt         = CG_FGEN_X2RMAC; 
        end
        else
        begin
          tgen_st_nxt  = CG_FGEN_USER_VM_W2;
        end
      end

      
      
      
      
      CG_SGEN_W0:
      begin
        if (cg_user_wr_rdy) 
        begin
          out_sel_nxt        = CG_SEL_STATS_W1;
          tgen_user_wr_nxt   = 1'b1;
          tgen_st_nxt        = CG_SGEN_W1; 
        end
        else
        begin
          tgen_st_nxt  = CG_SGEN_W0;
        end
      end

      
      
      
      CG_SGEN_W1:
      begin
        if (cg_user_wr_rdy && cqe_w1_val)
        begin
          out_sel_nxt          = CG_SEL_STATS_W2;  
          stats_val_clr_nxt    = 1'b1;
          tgen_user_wr_nxt     = 1'b1;
          tgen_st_nxt          = CG_SGEN_W2; 
        end
        else
        begin
          tgen_st_nxt  = CG_SGEN_W1;
        end
      end

     
      CG_SGEN_W2:
      begin
        if (cg_user_wr_rdy)
        begin
          out_sel_nxt          = CG_SEL_CQE_W0;  
          tgen_out_nxt.ordern  = tgen_out.ordern + `TLVP_ORD_NUM_WIDTH'(1);
          tgen_user_wr_nxt     = 1'b1;
          tgen_st_nxt          = CG_CGEN_W0; 
        end
        else
        begin
          tgen_st_nxt  = CG_SGEN_W2;
        end
      end

      
      
      
      CG_CGEN_W0:
      begin
        if (cg_user_wr_rdy)
        begin
          out_sel_nxt       = CG_SEL_CQE_W1; 
          ftr_err_clr_nxt   = 1'b1;
          tgen_user_wr_nxt  = 1'b1;
          tgen_idle_nxt     = 1'b1;
          tgen_cmd_end_nxt  = 1'b1;
          tgen_st_nxt       = CG_TGEN_IDLE; 
        end
        else
        begin
          tgen_st_nxt  = CG_CGEN_W0;
        end
      end

      default: 
      begin
        tgen_st_nxt  = CG_TGEN_IDLE;
      end
    endcase
  end

  
  
  
  
  
  assign    stats_tlv_tdata_w0.tlv_type       = STAT; 
  assign    stats_tlv_tdata_w0.tlv_len        = `TLV_LEN_WIDTH'(6); 
  assign    stats_tlv_tdata_w0.tlv_eng_id     = ftr_w0_fmt.tlv_eng_id;
  assign    stats_tlv_tdata_w0.tlv_seq_num    = ftr_w0_fmt.tlv_seq_num;
  assign    stats_tlv_tdata_w0.tlv_frame_num  = ftr_w0_fmt.tlv_frame_num;
  assign    stats_tlv_tdata_w0.resv0          = 19'h0;
  assign    stats_tlv_tdata_w0.resv1          = 4'h0;


  assign    stats_tlv_tdata_w0.tlv_bip2 = get_bip2                      
                                          (
                                           {
                                            2'b0,
                                            19'h0,
                                            ftr_w0_fmt.tlv_frame_num,
                                            4'h0,
                                            ftr_w0_fmt.tlv_eng_id,
                                            ftr_w0_fmt.tlv_seq_num,
                                             `TLV_LEN_WIDTH'(6),
                                            STAT
                                            }
                                           ); 

  assign    stats_tlv_w0  =
                           {
                            1'b1,                       
                            tgen_out.ordern,            
                            STAT,                       
                            1'b1,                       
                            1'b0,                       
                            1'b0,                       
                            ftr_tlv_w0_reg.tid,         
                            8'hff,                      
                            8'h1,                       
                            stats_tlv_tdata_w0             
                            };


  assign    stats_fin_w1.rsvd1     = 8'h0;
  assign    stats_fin_w1.bytes_in  = ftr_agg_bytes_in[23:0];
  assign    stats_fin_w1.rsvd0     = 8'h0;
  assign    stats_fin_w1.bytes_out = ftr_agg_bytes_out[23:0];
 
  assign    stats_tlv_fin_w1 = {
                                1'b1,                       
                                tgen_out.ordern,            
                                STAT,                       
                                1'b0,                       
                                1'b0,                       
                                1'b0,                       
                                ftr_tlv_w0_reg.tid,         
                                8'hff,                      
                                8'h0,                       
                                stats_fin_w1             
                                };

  
  assign    stats_fin_w2.rsvd1        = 31'h0;
  assign    stats_fin_w2.frame_error  = (cqe_w1_fin.status_code != 8'h0) ? 1'b1 : 1'b0;
  assign    stats_fin_w2.rsvd0        = 8'h0;
  assign    stats_fin_w2.latency      = 24'h0;

  assign    stats_tlv_fin_w2 = {
                                1'b1,                       
                                tgen_out.ordern,            
                                STAT,                       
                                1'b0,                       
                                1'b1,                       
                                1'b0,                       
                                ftr_tlv_w0_reg.tid,         
                                8'hff,                      
                                8'h2,                       
                                stats_fin_w2             
                                };

  
  assign    cqe_tlv_w0_reg_mod  = {
                                   1'b1,                   
                                   tgen_out.ordern, 
                                   cqe_tlv_w0_reg.typen,
                                   cqe_tlv_w0_reg.sot,
                                   cqe_tlv_w0_reg.eot,
                                   cqe_tlv_w0_reg.tlast,
                                   cqe_tlv_w0_reg.tid,
                                   cqe_tlv_w0_reg.tstrb,
                                   cqe_tlv_w0_reg.tuser,
                                   cqe_tlv_w0_reg.tdata 
                                   };

  assign    cqe_w1_fmt        = cqe_tlv_w1_reg.tdata; 

  
  
  
  
  
  
  
  
  always_comb
  begin
    
    if ((cqe_w1_fmt.status_code == 8'h0) && (ftr_err_save.error_code == 8'h0))
    begin
      cqe_w1_fin.status_code  = 8'h0; 
      cqe_w1_fin.error_code   = 8'h0;
   end
    
    else if ((cqe_w1_fmt.status_code == 8'h0) && (ftr_err_save.error_code != 8'h0))
    begin
      cqe_w1_fin.status_code  = 8'd199;
      cqe_w1_fin.error_code   = ftr_err_save.error_code;
    end
    
    else
    begin
      cqe_w1_fin.status_code  = cqe_w1_fmt.status_code;
      cqe_w1_fin.error_code   = 8'h0;
    end
  end

  
  
  assign    cqe_w1_fin.do_not_resend         = cqe_w1_fmt.do_not_resend;
  assign    cqe_w1_fin.vf_valid              = cqe_w1_fmt.vf_valid;
  assign    cqe_w1_fin.rsvd0                 = cqe_w1_fmt.rsvd0;

  
  assign    cqe_w1_fin.errored_frame_number  = {1'b0,ftr_err_save.errored_frame_number[10:0]}; 

  assign    cqe_w1_fin.status_code_type      = cqe_w1_fmt.status_code_type;
  assign    cqe_w1_fin.stat_cts              = cqe_w1_fmt.stat_cts;
  assign    cqe_w1_fin.pf_number             = cqe_w1_fmt.pf_number;
  assign    cqe_w1_fin.vf_number             = cqe_w1_fmt.vf_number;


  assign    cqe_tlv_fin_w1    = {
                                 1'b0,                   
                                 tgen_out.ordern,
                                 cqe_tlv_w1_reg.typen,
                                 cqe_tlv_w1_reg.sot,
                                 cqe_tlv_w1_reg.eot,
                                 cqe_tlv_w1_reg.tlast,
                                 cqe_tlv_w1_reg.tid,
                                 cqe_tlv_w1_reg.tstrb,
                                 cqe_tlv_w1_reg.tuser,
                                 cqe_w1_fin
                                 };


  
  
  assign cqe_sys_err = (cqe_w1_fin.status_code != 8'd199) && (cqe_w1_fin.status_code != 8'h0);

  
  assign cqe_eng_err = (cqe_w1_fin.status_code == 8'd199);

  
  
  
  assign cqe_eng_err_cmp       = cqe_w1_fin.status_code ^ debug_ctl_config.eng_err_code_match;
  assign cqe_eng_err_mask      = cqe_eng_err_cmp        & debug_ctl_config.eng_err_code_mask;
  assign cqe_eng_err_match     = cqe_eng_err_mask == 8'h0;


  
  
  
  
  
  
  
  
  
  
  always_comb
  begin
    case (out_sel) 
      CG_SEL_STATS_W0:  cg_user_tlv  = stats_tlv_w0;
      CG_SEL_STATS_W1:  cg_user_tlv  = stats_tlv_fin_w1;
      CG_SEL_STATS_W2:  cg_user_tlv  = stats_tlv_fin_w2;
      CG_SEL_CQE_W0:    cg_user_tlv  = cqe_tlv_w0_reg_mod;
      CG_SEL_CQE_W1:    cg_user_tlv  = cqe_tlv_fin_w1; 

      
      
      default:          cg_user_tlv  = tgen_out;
    endcase
  end

  
  
  
  
  always_ff @(posedge clk or negedge rst_n)
  begin
    if (~rst_n) 
    begin
      tgen_out          <= {$bits(tlvp_if_bus_t){1'b0}};
      tgen_st           <= CG_TGEN_IDLE;
      cg_user_xfr_st    <= CG_UXFR_IDLE;
      out_sel           <= cg_tlv_mod_out_sel_e'(1'b0);
      ftr_err_save.error_code <= NO_ERRORS;
      ftr_err_save.errored_frame_number <= 0;

     
     
     cg_stat_events.cqe_eng_err <= 0;
     cg_stat_events.cqe_err_sel <= 0;
     cg_stat_events.cqe_out <= 0;
     cg_stat_events.cqe_sys_err <= 0;
     cqe_tlv_w0_reg <= 0;
     cqe_tlv_w1_reg <= 0;
     cqe_w0_val <= 0;
     cqe_w1_val <= 0;
     frmd_vm <= 0;
     frmd_vm_short <= 0;
     ftr_agg_bytes_in <= 0;
     ftr_agg_bytes_out <= 0;
     ftr_err_clr <= 0;
     ftr_tlv_w0_reg <= 0;
     ix <= 0;
     new_cmd <= 0;
     start_fgen_hld <= 0;
     start_new_cmd_clr <= 0;
     start_new_cmd_hld <= 0;
     stats_en <= 0;
     stats_val_clr <= 0;
     tgen_cmd_end <= 0;
     tgen_idle <= 0;
     tgen_user_wr <= 0;
     user_vm <= 0;
     
    end
    else  
    begin
      cg_user_xfr_st    <= cg_user_xfr_st_nxt;
      ix                <= ix_nxt;
      tgen_out          <= tgen_out_nxt;
      tgen_st           <= tgen_st_nxt;
      user_vm           <= user_vm_nxt;
      frmd_vm           <= frmd_vm_nxt;
      frmd_vm_short     <= frmd_vm_short_nxt;
      tgen_user_wr      <= tgen_user_wr_nxt;
      start_new_cmd_clr <= start_new_cmd_clr_nxt;
      out_sel           <= out_sel_nxt;
      stats_val_clr     <= stats_val_clr_nxt; 
      tgen_idle         <= tgen_idle_nxt;
      tgen_cmd_end      <= tgen_cmd_end_nxt;
      ftr_err_clr       <= ftr_err_clr_nxt;
      new_cmd           <= new_cmd_nxt;
      start_new_cmd_hld <= start_new_cmd_clr ? 1'b0 : (start_new_cmd_pulse ? 1'b1 : start_new_cmd_hld);
      start_fgen_hld    <= start_fgen_clr    ? 1'b0 : (start_fgen_pulse    ? 1'b1 : start_fgen_hld);


      ftr_tlv_w0_reg    <= cg_ftr_ld[i0]  ? cg_term_tlv : ftr_tlv_w0_reg;
      cqe_tlv_w0_reg    <= cqe_w0_ld     ? cg_term_tlv : cqe_tlv_w0_reg;
      cqe_tlv_w1_reg    <= cqe_w1_ld     ? cg_term_tlv : cqe_tlv_w1_reg;
      stats_en          <= gen_guid_ld   ? cmd_tlv_tdata_w1.trace : stats_en;

      cqe_w0_val        <= cg_val_clr    ? 1'b0        : (cqe_w0_ld   ? 1'b1 : cqe_w0_val);
      cqe_w1_val        <= cg_val_clr    ? 1'b0        : (cqe_w1_ld   ? 1'b1 : cqe_w1_val);

      
      
      
      
      ftr_agg_bytes_in  <= stats_val_clr  ? 25'h0 : 
                           (cg_ftr_ld[i18] ? ftr_w18_fmt.bytes_in + ftr_agg_bytes_in[23:0] : ftr_agg_bytes_in);

      
      
      if (cceip_cfg)
      begin
        ftr_agg_bytes_out <= stats_val_clr  ? 25'h0 : 
                             (cg_ftr_ld[i19] ? ftr_w19_live_fmt.compressed_length + ftr_agg_bytes_out[23:0] : ftr_agg_bytes_out);
      end
      else
      begin
        ftr_agg_bytes_out <= stats_val_clr  ? 25'h0 : 
                             (cg_ftr_ld[i18] ? ftr_w18_fmt.bytes_out + ftr_agg_bytes_out[23:0] : ftr_agg_bytes_out);
      end

      
      
      
      
      
      
      if (ftr_err_clr) 
      begin
        ftr_err_save.error_code           <= NO_ERRORS;
        ftr_err_save.errored_frame_number <= 11'h0;
      end
      
      
      else if (cg_ftr_ld[i19] && (ftr_err_save.error_code == 8'h0) && (ftr_w19_live_fmt.error_code != 8'h0))
      begin
        ftr_err_save.error_code           <= ftr_w19_live_fmt.error_code;
        ftr_err_save.errored_frame_number <= ftr_w19_live_fmt.errored_frame_number;
      end
      
      
      else if (cg_ftr_ld[i19] && (ftr_err_save.error_code == 8'h0) &&  
               (ftr_w19_live_fmt.error_code == 8'h0) && frmd_out_type_undef)
      begin
        ftr_err_save.error_code           <= CG_UNDEF_FRMD_OUT;
        ftr_err_save.errored_frame_number <= ftr_w0_fmt.tlv_frame_num;
      end

      
      
      cg_stat_events.cqe_out     <= stats_en && ftr_err_clr;
      cg_stat_events.cqe_eng_err <= stats_en && cqe_eng_err && ftr_err_clr;
      cg_stat_events.cqe_sys_err <= stats_en && cqe_sys_err && ftr_err_clr;
      cg_stat_events.cqe_err_sel <= stats_en && cqe_eng_err && cqe_eng_err_match && ftr_err_clr;
    end
  end




  generate if (STUB_MODE)
  begin
    always_ff @(posedge clk or negedge rst_n)
    begin
      if (~rst_n) 
      begin
        gen_guid <= 1'b0;

        for (j=0; j<`N_FTR_WORDS_EXP; j=j+1) 
        begin
          cg_ftr_reg[j] <= 64'h0;
          cg_ftr_val[j] <= 1'b0;
        end
      end
      else
      begin
        
        
        for (j=0; j<`N_FTR_WORDS_EXP-6; j=j+1)
        begin
          cg_ftr_reg[j]   <= cg_ftr_ld[j] ? cg_term_tlv.tdata : cg_ftr_reg[j];
          cg_ftr_val[j]   <= cg_val_clr  ? 1'b0 : 
                             (cg_ftr_ld[j] ? 1'b1 :  cg_ftr_val[j]);
        end

        
        cg_ftr_val[14] <= 1'b1;
        cg_ftr_val[15] <= 1'b1;
        cg_ftr_val[16] <= 1'b1;
        cg_ftr_val[17] <= 1'b1;
        cg_ftr_val[18] <= 1'b1;
        cg_ftr_val[19] <= 1'b1;

        cg_ftr_reg[14] <= 64'h0;
        cg_ftr_reg[15] <= 64'h0;
        cg_ftr_reg[16] <= 64'h0;
        cg_ftr_reg[17] <= 64'h0;
        cg_ftr_reg[18] <= 64'h0;
        cg_ftr_reg[19] <= 64'h0;

        
        gen_guid       <= 1'b0;


      end
    end
  end
  else
  begin
    always_ff @(posedge clk or negedge rst_n)
    begin
      if (~rst_n) 
      begin
        gen_guid       <= 1'b0;

        for (j=0; j<`N_FTR_WORDS_EXP; j=j+1) 
        begin
          cg_ftr_reg[j] <= 64'h0;
          cg_ftr_val[j] <= 1'b0;
        end
      end
      else
      begin
        for (j=0; j<`N_FTR_WORDS_EXP; j=j+1)
        begin
          cg_ftr_reg[j]   <= cg_ftr_ld[j] ? cg_term_tlv.tdata : cg_ftr_reg[j];
          cg_ftr_val[j]   <= cg_val_clr  ? 1'b0 : 
                             (cg_ftr_ld[j] ? 1'b1 :  cg_ftr_val[j]);
        end
        
        gen_guid          <= gen_guid_ld ? (cmd_tlv_tdata_w1.dst_guid_present & cceip_cfg) : gen_guid; 
      end
    end
  end
  endgenerate


endmodule 










