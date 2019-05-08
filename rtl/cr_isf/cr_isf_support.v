/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/




























module cr_isf_support
(
  
  trigger_hit, ss_rd_ok, debug_trig_cap_hi, debug_trig_cap_lo,
  debug_ss_cap_sb, debug_ss_cap_lo, debug_ss_cap_hi,
  isf_sys_stall_intr, isf_sup_cqe_exit, isf_sup_cqe_rx,
  isf_sup_rqe_rx, mask_debug, axi_slv_rd, isf_fifo_hw_rd,
  isf_fifo_hw_wr, pre_tlvp_fifo_wr, pre_tlvp_fifo_empty_mod,
  isf_stat_events, ovfl_int,
  
  clk, rst_n, ctl_config, debug_ctl_config, system_stall_limit_config,
  debug_trig_mask_hi_config, debug_trig_mask_lo_config,
  debug_trig_match_hi_config, debug_trig_match_lo_config,
  debug_trig_tlv_config, single_step_rd, axi_slv_ob, axi_slv_empty,
  axi_slv_aempty, axi_slv_ovfl, isf_fifo_depth, isf_fifo_in_tvalid,
  pre_tlvp_fifo_afull, pre_tlvp_fifo_empty, pre_tlvp_fifo_rd,
  isf_tlv_mod_ib_in, isf_term_empty, isf_term_tlv, isf_ob_in,
  isf_ob_out, aux_cmd_match0_ev, aux_cmd_match1_ev, aux_cmd_match2_ev,
  aux_cmd_match3_ev, ib_frame_cnt_stb, ib_cmd_cnt_stb
  );
  
`include "cr_structs.sv"
  
  import cr_isfPKG::*;
  import cr_isf_regsPKG::*;

  
  
  
  input                                   clk;
  input                                   rst_n; 
  
  
  
  
  input  ctl_t                            ctl_config;
  input  debug_ctl_t                      debug_ctl_config; 
  input  system_stall_limit_t             system_stall_limit_config;
  input  debug_trig_mask_hi_t             debug_trig_mask_hi_config;
  input  debug_trig_mask_lo_t             debug_trig_mask_lo_config;
  input  debug_trig_match_hi_t            debug_trig_match_hi_config;
  input  debug_trig_match_lo_t            debug_trig_match_lo_config;
  input  debug_trig_tlv_t                 debug_trig_tlv_config;
  input                                   single_step_rd;
  output reg                              trigger_hit;
  output reg                              ss_rd_ok;
  output debug_trig_cap_hi_t              debug_trig_cap_hi;
  output debug_trig_cap_lo_t              debug_trig_cap_lo;
  output debug_ss_cap_sb_t                debug_ss_cap_sb;  
  output debug_ss_cap_lo_t                debug_ss_cap_lo;  
  output debug_ss_cap_hi_t                debug_ss_cap_hi;  

  
  
  
  output reg                              isf_sys_stall_intr;
  output reg                              isf_sup_cqe_exit;
  output reg                              isf_sup_cqe_rx;
  output reg                              isf_sup_rqe_rx;
  output                                  mask_debug;

  
  
  
  input  axi4s_dp_bus_t                   axi_slv_ob; 
  input                                   axi_slv_empty;
  input                                   axi_slv_aempty;
  input                                   axi_slv_ovfl;
  output                                  axi_slv_rd;  

  
  
  
  input [`LOG_VEC(`ISF_FIFO_ENTRIES+1)]   isf_fifo_depth;
  input                                   isf_fifo_in_tvalid;

  output reg                              isf_fifo_hw_rd;
  output reg                              isf_fifo_hw_wr;

  
  
  
  input                                   pre_tlvp_fifo_afull;  
  input                                   pre_tlvp_fifo_empty;
  input                                   pre_tlvp_fifo_rd;
  input axi4s_dp_bus_t                    isf_tlv_mod_ib_in;  
  output reg                              pre_tlvp_fifo_wr;

  
  
  
  output reg                              pre_tlvp_fifo_empty_mod;

  
  
  
  input                                   isf_term_empty;
  input  tlvp_if_bus_t                    isf_term_tlv; 

 
 
 
  input  axi4s_dp_rdy_t                   isf_ob_in;
  input  axi4s_dp_bus_t                   isf_ob_out; 

  
  
  
  input                                   aux_cmd_match0_ev;  
  input                                   aux_cmd_match1_ev;  
  input                                   aux_cmd_match2_ev;  
  input                                   aux_cmd_match3_ev;  
  input                                   ib_frame_cnt_stb;
  input                                   ib_cmd_cnt_stb;
  output isf_stats_t                      isf_stat_events;

  
  
  
  output reg                              ovfl_int;

  
  
  
  typedef enum                logic [2:0] {ISF_DEBUG_NORMAL, ISF_DEBUG_BLK_RDWR, ISF_DEBUG_BLK_RD,
                                           ISF_DEBUG_SS, ISF_DEBUG_TRIG_FREEZE} isf_debug_mode_e;
  
  typedef enum                logic       {ISF_FULL_IDLE_ST, ISF_FULL_BP_ST} isf_fifo_full_st_e;

  
  
  
  isf_debug_mode_e                      debug_mode;
  isf_fifo_full_st_e                    isf_fifo_full_st;
  tlv_word_0_t                          isf_ib_tlv_word0; 
  tlv_word_0_t                          isf_ob_tlv_word0; 
  tlv_word_0_t                          trig_tlv_word0; 
  isf_ib_par_st_e                       isf_ib_par_st; 
  isf_ob_par_st_e                       isf_ob_par_st; 
  isf_trig_frz_st_e                     isf_trig_frz_st_nxt;
  isf_trig_frz_st_e                     isf_trig_frz_st;
  sys_stall_st_e                        sys_stall_st;
  logic [6:0]                           use_wmark;
  logic [6:0]                           req_wmark;
  logic [2:0]                           use_wmark_sel;
  logic [2:0]                           req_wmark_sel;
  logic                                 use_wmark_hit;
  logic                                 req_wmark_hit;
  logic                                 isf_fifo_hw_rd_pre;
  logic [`LOG_VEC(`ISF_FIFO_ENTRIES+1)] use_wmark_depth;
  logic [`LOG_VEC(`ISF_FIFO_ENTRIES+1)] req_wmark_depth;
  logic                                 isf_fifo_empty;
  logic [31:0]                          sys_stall_cnt;
  logic [31:0]                          sys_stall_limit;
  logic                                 stall_limit_hit;
  logic                                 sys_stall_en;
  logic                                 isf_fifo_full;
  logic                                 isf_fifo_empty_mod;
  logic                                 ib_cmd_active;                                 
  logic                                 axi_slv_ovfl_d0;
  logic                                 tlv_word_cnt_en;
  logic                                 tlv_word_cnt_clr;
  logic                                 trigger_hit_nxt;
  logic                                 tlv_match;
  logic                                 trig_match;
  logic                                 tlv_word_cnt_match;
  logic                                 trig_word_ld;

  logic                                 tlv_word_num0;                                 
  logic [20:0]                          tlv_word_cnt;
  logic [`AXI_S_DP_DWIDTH-1:0]          trig_cmp;
  logic [`AXI_S_DP_DWIDTH-1:0]          trig_mask;
  logic [`AXI_S_DP_DWIDTH-1:0]          trig_word_hld;
  logic                                 pre_tlvp_fifo_rd_d0;
  logic                                 force_ib_bp;


   
  
  assign use_wmark_sel             = ctl_config.use_wmark_sel;
  assign req_wmark_sel             = ctl_config.req_wmark_sel;
  assign debug_mode                = isf_debug_mode_e'(debug_ctl_config.debug_mode);
  assign force_ib_bp               = debug_ctl_config.force_ib_bp;
  assign mask_debug                = (isf_ib_par_st == ISF_IB_CMD_PAR_FOUND);
   

  
  
  assign isf_fifo_hw_rd_pre = !isf_fifo_empty_mod && !pre_tlvp_fifo_afull;

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  
  always_comb
  begin
    case (use_wmark_sel)
      3'h0: use_wmark = 7'd8;
      3'h1: use_wmark = 7'd16;
      3'h2: use_wmark = 7'd24;
      3'h3: use_wmark = 7'd32;
      3'h4: use_wmark = 7'd40;
      3'h5: use_wmark = 7'd48;
      3'h6: use_wmark = 7'd56;
      3'h7: use_wmark = 7'd64;
    endcase
  end

  always_comb
  begin
    case (req_wmark_sel)
      3'h0: req_wmark = 7'd8;
      3'h1: req_wmark = 7'd16;
      3'h2: req_wmark = 7'd24;
      3'h3: req_wmark = 7'd32;
      3'h4: req_wmark = 7'd40;
      3'h5: req_wmark = 7'd48;
      3'h6: req_wmark = 7'd56;
      3'h7: req_wmark = 7'd64;
    endcase
  end

  
  assign use_wmark_depth = `ISF_FIFO_ENTRIES - use_wmark; 
  assign req_wmark_depth = `ISF_FIFO_ENTRIES - (use_wmark + req_wmark);

  
  assign use_wmark_hit  = isf_fifo_depth >= use_wmark_depth;
  assign req_wmark_hit  = isf_fifo_depth <= req_wmark_depth;

  
  assign isf_fifo_empty = isf_fifo_depth == ($clog2(`ISF_FIFO_ENTRIES))'(0);
                          
  
  always_ff @(posedge clk or negedge rst_n)
  begin
    if (~rst_n) 
    begin
      isf_fifo_full    <= 1'b0;  
      isf_fifo_full_st <= ISF_FULL_IDLE_ST;
      
    end
    else
    begin
      case (isf_fifo_full_st)
        
        
        ISF_FULL_IDLE_ST:
        begin
          if (use_wmark_hit)
          begin
            isf_fifo_full    <= 1'b1;
            isf_fifo_full_st <= ISF_FULL_BP_ST;
          end
          else
          begin
            isf_fifo_full    <= 1'b0;
            isf_fifo_full_st <= ISF_FULL_IDLE_ST;
          end
        end

        
        
        ISF_FULL_BP_ST:
        begin
          if (req_wmark_hit)
          begin
            isf_fifo_full    <= 1'b0;
            isf_fifo_full_st <= ISF_FULL_IDLE_ST;
          end
          else
          begin
            isf_fifo_full    <= 1'b1;
            isf_fifo_full_st <= ISF_FULL_BP_ST;
          end
        end

        default:
        begin
          isf_fifo_full    <= 1'b0;
          isf_fifo_full_st <= ISF_FULL_IDLE_ST;
        end
      endcase
    end
  end

  
  
  
  
  
  
  
  
  
  
  
  
  

  assign axi_slv_rd  = isf_fifo_hw_wr;  

  always_comb
  begin
    case (debug_mode)
      
      
      
      
      ISF_DEBUG_NORMAL:
      begin
        isf_fifo_hw_rd      = isf_fifo_hw_rd_pre; 
        isf_fifo_empty_mod  = isf_fifo_empty; 
        isf_fifo_hw_wr      = !axi_slv_empty && !isf_fifo_full && !force_ib_bp;
      end

      
      
      
      
      ISF_DEBUG_BLK_RDWR:
      begin
        isf_fifo_hw_rd            = 1'b0;
        isf_fifo_empty_mod        = 1'b1; 
        isf_fifo_hw_wr            = 1'b0;
      end

      
      
      
      ISF_DEBUG_BLK_RD:
      begin
        isf_fifo_hw_rd      = 1'b0;
        isf_fifo_empty_mod  = 1'b1; 
        isf_fifo_hw_wr      = !axi_slv_empty && !isf_fifo_full;
      end

      
      
      
      default:
      begin
        isf_fifo_hw_rd      = isf_fifo_hw_rd_pre; 
        isf_fifo_empty_mod  = isf_fifo_empty; 
        isf_fifo_hw_wr      = !axi_slv_empty && !isf_fifo_full;
      end
    endcase
  end

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  assign tlv_word_num0       = debug_trig_tlv_config.tlv_word_num == 21'h0;
  assign tlv_word_cnt_match  = tlv_word_cnt == debug_trig_tlv_config.tlv_word_num;

  assign trig_tlv_word0      = isf_tlv_mod_ib_in.tdata;

  
  
  assign tlv_match   = pre_tlvp_fifo_rd_d0 &&  
                       isf_tlv_mod_ib_in.tuser[0] && 
                       (trig_tlv_word0.tlv_type == debug_trig_tlv_config.tlv_type);


  
  
  assign trig_cmp    = {debug_trig_match_hi_config.match_val, debug_trig_match_lo_config.match_val} ^
                       isf_tlv_mod_ib_in.tdata;
  
  assign trig_mask   = {debug_trig_mask_hi_config.mask_val, debug_trig_mask_lo_config.mask_val} &
                       trig_cmp;

  assign trig_match  = trig_mask == 64'h0;
  
  assign debug_trig_cap_lo.trig_val = trig_word_hld[31:0];
  assign debug_trig_cap_hi.trig_val = trig_word_hld[63:32];

  
  
  always_comb
  begin
    
    if (debug_mode == ISF_DEBUG_TRIG_FREEZE)
    begin
      pre_tlvp_fifo_empty_mod = trigger_hit_nxt ? 1'b1 : pre_tlvp_fifo_empty;
    end
    
    
    else if (debug_mode == ISF_DEBUG_SS)
    begin
      pre_tlvp_fifo_empty_mod = single_step_rd ? pre_tlvp_fifo_empty : 1'b1;
    end
    
    
    else
    begin
      pre_tlvp_fifo_empty_mod = pre_tlvp_fifo_empty;
    end
  end

  
  
  
  always_comb
  begin
    
    tlv_word_cnt_en   = 1'b0;   
    tlv_word_cnt_clr  = 1'b0;
    trigger_hit_nxt   = 1'b0;
    trig_word_ld      = 1'b0;

     case (isf_trig_frz_st)
      
      
      ISF_TF_IDLE:
      begin
        
        
        if ((debug_mode == ISF_DEBUG_TRIG_FREEZE) && pre_tlvp_fifo_rd_d0 && 
            tlv_match && !tlv_word_num0)
        begin
          tlv_word_cnt_en      = 1'b1;
          isf_trig_frz_st_nxt  = ISF_TF_CNT;
        end 

        
        
        
        
        
        else if ((debug_mode == ISF_DEBUG_TRIG_FREEZE) && pre_tlvp_fifo_rd_d0 && 
                 tlv_match && tlv_word_num0 && trig_match)
        begin
          trig_word_ld         = 1'b1;
          trigger_hit_nxt      = 1'b1;
          isf_trig_frz_st_nxt  = ISF_TF_HIT;
        end 
        else
        begin
          isf_trig_frz_st_nxt  = ISF_TF_IDLE;
        end
      end

      
      
      
      ISF_TF_CNT:
      begin
        
        
        
        
        
        if (pre_tlvp_fifo_rd_d0 && tlv_word_cnt_match && trig_match)
        begin
          tlv_word_cnt_clr     = 1'b1;
          trig_word_ld         = 1'b1;
          trigger_hit_nxt      = 1'b1;
          isf_trig_frz_st_nxt  = ISF_TF_HIT;
        end 
        
        
        
        else if (pre_tlvp_fifo_rd_d0 && tlv_word_cnt_match && !trig_match)
        begin
          tlv_word_cnt_clr     = 1'b1;
          isf_trig_frz_st_nxt  = ISF_TF_IDLE;
        end 
        else
        begin
          tlv_word_cnt_en      = pre_tlvp_fifo_rd_d0  ? 1'b1 : 1'b0;
          isf_trig_frz_st_nxt  = ISF_TF_CNT;
        end
      end

      
      
      ISF_TF_HIT:
      begin
        if (debug_mode != ISF_DEBUG_TRIG_FREEZE)   
        begin
          isf_trig_frz_st_nxt  = ISF_TF_IDLE;
        end 
        else
        begin
          trigger_hit_nxt      = 1'b1;
          isf_trig_frz_st_nxt  = ISF_TF_HIT;
        end
      end

      default: isf_trig_frz_st_nxt  = ISF_TF_IDLE;
    endcase
  end

  always_ff  @(posedge clk or negedge rst_n)
  begin
    if (~rst_n) 
    begin
      isf_trig_frz_st <= ISF_TF_IDLE;
      trig_word_hld   <= 0;
      
      
      debug_ss_cap_hi.ss_rd_val <= 0;
      debug_ss_cap_lo.ss_rd_val <= 0;
      debug_ss_cap_sb <= 0;
      ss_rd_ok <= 0;
      tlv_word_cnt <= 0;
      trigger_hit <= 0;
      
    end
    else
    begin
      isf_trig_frz_st <= isf_trig_frz_st_nxt;
      trigger_hit     <= trigger_hit_nxt;

      tlv_word_cnt    <= tlv_word_cnt_clr ? 21'h0 : 
                          tlv_word_cnt_en ? tlv_word_cnt + 21'h1 : tlv_word_cnt;



      
      trig_word_hld <= trig_word_ld ? isf_tlv_mod_ib_in.tdata : trig_word_hld;

      
      if (single_step_rd && pre_tlvp_fifo_rd)

      begin
        debug_ss_cap_lo.ss_rd_val <= isf_tlv_mod_ib_in.tdata[31:0];
        debug_ss_cap_hi.ss_rd_val <= isf_tlv_mod_ib_in.tdata[63:32];
        debug_ss_cap_sb           <= {
                                      2'b0,
                                      isf_tlv_mod_ib_in.tlast,
                                      isf_tlv_mod_ib_in.tstrb,
                                      8'h0,
                                      isf_tlv_mod_ib_in.tid,
                                      isf_tlv_mod_ib_in.tuser
                                      };
      end

      
      
      ss_rd_ok      <= single_step_rd ? pre_tlvp_fifo_rd : ss_rd_ok;
    end
  end


  
  
  
  
  
  
  
  

  always_ff @(posedge clk or negedge rst_n)
  begin
    if (~rst_n) 
    begin
      
      
      pre_tlvp_fifo_rd_d0 <= 0;
      pre_tlvp_fifo_wr <= 0;
      
    end
    else
    begin
      pre_tlvp_fifo_wr    <= isf_fifo_hw_rd && !pre_tlvp_fifo_afull;
      pre_tlvp_fifo_rd_d0 <= pre_tlvp_fifo_rd;
    end
  end

  
  
  
  
  
  
  
  
  assign sys_stall_limit  = system_stall_limit_config.limit;
  assign sys_stall_en     = ctl_config.sys_stall_en;

  
  assign stall_limit_hit  = (sys_stall_cnt == sys_stall_limit); 

  always_ff @(posedge clk or negedge rst_n)
  begin
    if (~rst_n) 
    begin
      sys_stall_st <= SYS_STALL_IDLE;
      
      
      isf_sys_stall_intr <= 0;
      sys_stall_cnt <= 0;
      
    end
    else
    begin
      
      isf_sys_stall_intr <= 1'b0;

      case (sys_stall_st)
        
        
        SYS_STALL_IDLE:
        begin
          if (isf_ob_out.tvalid && !isf_ob_in.tready && sys_stall_en) 
          begin
            sys_stall_cnt <= 32'h1;
            sys_stall_st  <= SYS_STALL_CNT;
          end
          else
          begin
            sys_stall_cnt <= 32'h0;
            sys_stall_st  <= SYS_STALL_IDLE;
          end
        end

        
        
        SYS_STALL_CNT:
        begin
          if (stall_limit_hit)
          begin
            sys_stall_cnt      <= 32'h0;
            isf_sys_stall_intr <= 1'b1;
            sys_stall_st       <= SYS_STALL_IDLE;
          end
          else if (isf_ob_out.tvalid && !isf_ob_in.tready && sys_stall_en)
          begin
            sys_stall_cnt <= sys_stall_cnt + 32'h1;
            sys_stall_st  <= SYS_STALL_CNT;
          end
          else
          begin
            sys_stall_cnt <= 32'h0;
            sys_stall_st  <= SYS_STALL_IDLE;
          end
        end
      endcase
    end
  end


  
  
  
  

  assign isf_ib_tlv_word0      = axi_slv_ob.tdata;
  assign isf_ob_tlv_word0      = isf_ob_out.tdata;

  assign isf_stat_events.rsvd  = 55'h0;

  always_ff @(posedge clk or negedge rst_n)
  begin
    if (~rst_n) 
    begin
      isf_ib_par_st                  <= ISF_IB_PAR_IDLE;
      isf_ob_par_st                  <= ISF_OB_PAR_IDLE;
      isf_stat_events.ib_stall       <= 1'b0;
      isf_stat_events.ib_sys_stall   <= 1'b0;
      isf_stat_events.ob_sys_bp      <= 1'b0;
      isf_stat_events.aux_cmd_match0 <= 1'b0;
      isf_stat_events.aux_cmd_match1 <= 1'b0;
      isf_stat_events.aux_cmd_match2 <= 1'b0;
      isf_stat_events.aux_cmd_match3 <= 1'b0;
      isf_stat_events.ib_frame       <= 1'b0;
      isf_stat_events.ib_cmd         <= 1'b0;
      ib_cmd_active                  <= 1'b0;
      isf_sup_cqe_exit               <= 1'b0;
      isf_sup_cqe_rx                 <= 1'b0;
      isf_sup_rqe_rx                 <= 1'b0;
      axi_slv_ovfl_d0                <= 1'b0;
      ovfl_int                       <= 1'b0;
    end
    else
    begin
      isf_stat_events.ib_stall       <= !axi_slv_empty && !axi_slv_rd; 
      isf_stat_events.ib_sys_stall   <= axi_slv_empty && ib_cmd_active; 
      isf_stat_events.ob_sys_bp      <= isf_ob_out.tvalid && !isf_ob_in.tready;
      isf_stat_events.aux_cmd_match0 <= aux_cmd_match0_ev;
      isf_stat_events.aux_cmd_match1 <= aux_cmd_match1_ev;
      isf_stat_events.aux_cmd_match2 <= aux_cmd_match2_ev;
      isf_stat_events.aux_cmd_match3 <= aux_cmd_match3_ev;
      isf_stat_events.ib_frame       <= ib_frame_cnt_stb;
      isf_stat_events.ib_cmd         <= ib_cmd_cnt_stb;

      
      
      
      
      case (isf_ib_par_st)
        
        
        ISF_IB_PAR_IDLE:
        begin
          isf_sup_cqe_rx <= 1'b0;

          if (axi_slv_ob.tuser[0] && (isf_ib_tlv_word0.tlv_type == RQE) && 
              axi_slv_rd && axi_slv_ob.tvalid)
          begin
            isf_sup_rqe_rx         <= 1'b1;
            ib_cmd_active          <= 1'b1;
            isf_ib_par_st          <= ISF_IB_RQE_PAR_FOUND;
          end
          else
          begin
            isf_sup_rqe_rx         <= 1'b0;  
            ib_cmd_active          <= 1'b0;
            isf_ib_par_st          <= ISF_IB_PAR_IDLE;
          end
        end

        
        
        ISF_IB_RQE_PAR_FOUND:
        begin
          isf_sup_rqe_rx         <= 1'b0;  
          ib_cmd_active          <= 1'b1;

          if (axi_slv_ob.tuser[0] && (isf_ib_tlv_word0.tlv_type == CQE) && 
              axi_slv_rd && axi_slv_ob.tvalid)
          begin
            isf_sup_cqe_rx <= 1'b1;
            isf_ib_par_st  <= ISF_IB_CQE_PAR_FOUND;
          end
          else if (axi_slv_ob.tuser[0] && (isf_ib_tlv_word0.tlv_type == CMD) && 
		   axi_slv_rd && axi_slv_ob.tvalid) 
          begin
            isf_sup_cqe_rx <= 1'b0;
            isf_ib_par_st  <= ISF_IB_CMD_PAR_FOUND;
          end
	  else 
          begin
            isf_sup_cqe_rx <= 1'b0;
            isf_ib_par_st  <= ISF_IB_RQE_PAR_FOUND;
          end
        end 

        
	ISF_IB_CMD_PAR_FOUND:
        begin
          ib_cmd_active    <= 1'b1;

	  if (axi_slv_rd && axi_slv_ob.tvalid) 
          begin
            isf_ib_par_st  <= ISF_IB_RQE_PAR_FOUND;
          end
          else
          begin
            isf_ib_par_st  <= ISF_IB_CMD_PAR_FOUND;
          end
	end
	

        
        ISF_IB_CQE_PAR_FOUND:
        begin
          isf_sup_rqe_rx          <= 1'b0;  
          isf_sup_cqe_rx          <= 1'b0;  

          if (axi_slv_ob.tuser[1] && 
              axi_slv_rd && axi_slv_ob.tvalid)
          begin
            ib_cmd_active  <= 1'b0;
            isf_ib_par_st  <= ISF_IB_PAR_IDLE;
          end
          else
          begin
            ib_cmd_active  <= 1'b1;
            isf_ib_par_st  <= ISF_IB_CQE_PAR_FOUND;
          end
        end

        default:
        begin
          isf_sup_rqe_rx         <= 1'b0;  
          isf_sup_cqe_rx         <= 1'b0;  
          ib_cmd_active          <= 1'b0;
          isf_ib_par_st          <= ISF_IB_PAR_IDLE;
        end
      endcase

      
      
      
      
      case (isf_ob_par_st)
        
        
        ISF_OB_PAR_IDLE:
        begin
          isf_sup_cqe_exit <= 1'b0;

          if (isf_ob_out.tuser[0] && (isf_ob_tlv_word0.tlv_type == CQE) && 
              isf_ob_in.tready && isf_ob_out.tvalid)
          begin
            isf_ob_par_st <= ISF_OB_CQE_PAR_FOUND;
          end
          else
          begin
            isf_ob_par_st <= ISF_OB_PAR_IDLE;
          end
        end

        
        ISF_OB_CQE_PAR_FOUND:
        begin

          if (isf_ob_out.tuser[1] && 
              isf_ob_in.tready && isf_ob_out.tvalid)
          begin
            isf_sup_cqe_exit <= 1'b1;
            isf_ob_par_st    <= ISF_OB_PAR_IDLE;
          end
          else
          begin
            isf_sup_cqe_exit <= 1'b0;
            isf_ob_par_st    <= ISF_OB_CQE_PAR_FOUND;
          end
        end
      endcase

      
      
      
      
      axi_slv_ovfl_d0 <= axi_slv_ovfl;
      ovfl_int        <= axi_slv_ovfl && !axi_slv_ovfl_d0;
    end
  end

endmodule 












