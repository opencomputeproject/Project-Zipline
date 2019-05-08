/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/





























module cr_osf_ctl
(
  
  ob_data_fifo_rd, ob_pdt_fifo_rd, ob_fifo_wr, ob_fifo_wdata,
  
  clk, rst_n, ob_data_fifo_rdata, ob_data_fifo_empty,
  ob_pdt_fifo_rdata, ob_pdt_fifo_empty, ob_fifo_full,
  debug_ctl_config
  );
  
`include "cr_structs.sv"
  
  import cr_osfPKG::*;
  import cr_osf_regsPKG::*;

  
  
  
  input                                        clk;
  input                                        rst_n; 
  
  
  
  
  input  axi4s_dp_bus_t                        ob_data_fifo_rdata;
  input                                        ob_data_fifo_empty;
  output reg                                   ob_data_fifo_rd;

  
  
  
  input  axi4s_dp_bus_t                        ob_pdt_fifo_rdata;
  input                                        ob_pdt_fifo_empty;
  output reg                                   ob_pdt_fifo_rd;

  
  
  
  input                                        ob_fifo_full;
  output reg                                   ob_fifo_wr;
  output axi4s_dp_bus_t                        ob_fifo_wdata;

  
  
  
  input  debug_ctl_t                           debug_ctl_config;  

  
  
  
  logic                                      df_debug_sel; 
  tlv_data_word_0_t                          df_tlv_word_0; 
  tlv_rqe_word_0_t                           df_rqe_tlv_word_0;  

  logic                                      pf_debug_sel;   
  tlv_word_0_t                               pf_tlv_word_0; 

  logic                                      ob_pf_rd_sel;
  logic                                      ob_df_rd_sel;
  logic                                      ob_dmux_sel;
  logic                                      df_dat_eot;
  logic                                      pf_eot;
  logic                                      df_sot;
  logic                                      pf_sot;
  osf_ob_st_e                                ob_st_nxt;
  osf_ob_st_e                                ob_st;

  logic                                      df_dat_val;
  logic                                      df_rqe_val;
  logic                                      df_clr;
  logic                                      pf_clr;
  logic                                      simp_cmd;
  logic                                      cmp_cmd;
  logic                                      pf_cqe_eot;
  logic                                      pf_cqe_val;
  logic                                      pf_frmd_eot;
  logic                                      cmp_cmd_last_frame;
  logic                                      pf_frmd_user_null;
  logic                                      pf_frmd_val;
  logic                                      pre_frmd_val;
  logic                                      pf_frmd_word_0;
  
  
  

  
  
  
  
  
  always_comb
  begin
    case (debug_ctl_config.rd_mode)
      2'h0, 2'h3: 
      begin
        pf_debug_sel = 1'b0;
        df_debug_sel = 1'b0;
      end

      2'h1: 
      begin
        pf_debug_sel = 1'b0;
        df_debug_sel = 1'b1;
      end

      2'h2: 
      begin
        pf_debug_sel = 1'b1;
        df_debug_sel = 1'b0;
      end
      endcase
  end


  
  
  
  assign ob_data_fifo_rd    = ob_df_rd_sel ? (!ob_data_fifo_empty && !ob_fifo_full) : 1'b0; 
  assign ob_pdt_fifo_rd     = ob_pf_rd_sel ? (!ob_pdt_fifo_empty && !ob_fifo_full) : 1'b0; 

  assign df_dat_eot         = ob_data_fifo_rdata.tuser[1] && df_dat_val;

  assign pf_cqe_eot         = ob_pdt_fifo_rdata.tuser[1] && pf_cqe_val;
  assign pf_frmd_eot        = ob_pdt_fifo_rdata.tuser[1] && pf_frmd_val;

  assign pf_eot             = ob_pdt_fifo_rdata.tuser[1];
  
  assign df_sot             = ob_data_fifo_rdata.tuser[0];
  assign pf_sot             = ob_pdt_fifo_rdata.tuser[0];

  assign df_tlv_word_0      = ob_data_fifo_rdata.tdata; 
  assign pf_tlv_word_0      = ob_pdt_fifo_rdata.tdata;  
  assign df_rqe_tlv_word_0  = ob_data_fifo_rdata.tdata; 



  assign pf_frmd_word_0     = (

                               (pf_tlv_word_0.tlv_type == FRMD_USER_PI16) ||
                               (pf_tlv_word_0.tlv_type == FRMD_USER_PI64) ||
                               (pf_tlv_word_0.tlv_type == FRMD_USER_VM) ||
                               (pf_tlv_word_0.tlv_type == FRMD_INT_APP) ||
                               (pf_tlv_word_0.tlv_type == FRMD_INT_SIP) ||
                               (pf_tlv_word_0.tlv_type == FRMD_INT_LIP) ||
                               (pf_tlv_word_0.tlv_type == FRMD_INT_VM)  ||
                               (pf_tlv_word_0.tlv_type == FRMD_INT_VM_SHORT));

  
  assign pf_frmd_user_null  = pf_sot && (pf_tlv_word_0.tlv_type == FRMD_USER_NULL);
  
  assign pf_frmd_val        = pre_frmd_val || pf_frmd_user_null;


  
  
  
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  always_comb
  begin

    
    ob_pf_rd_sel  = 1'b0;
    ob_df_rd_sel  = 1'b0;
    ob_dmux_sel   = 1'b0;
    ob_fifo_wr    = 1'b0;
    df_clr        = 1'b0;
    pf_clr        = 1'b0;

    case (ob_st)
      
      
      
      
      
      
      
      
      OSF_OB_DF:
      begin
        ob_df_rd_sel  = !ob_data_fifo_empty ? 1'b1 : 1'b0;

        
        
        if (!ob_data_fifo_empty && !ob_fifo_full && !df_debug_sel && df_dat_eot)
        begin
          ob_fifo_wr  = 1'b1;
          df_clr      = 1'b1;
          ob_st_nxt   = OSF_OB_PF;
        end

        
        
        else 
        begin
          ob_fifo_wr  = (!ob_data_fifo_empty && !ob_fifo_full) ? 1'b1 : 1'b0;
          ob_st_nxt   = OSF_OB_DF;
        end
      end

      
      
      
      
      
      
      
      
      OSF_OB_PF:
      begin
        ob_pf_rd_sel  = 1'b1;  
        ob_dmux_sel   = 1'b1; 

        
        
        
        
        
        
        
        
        
        
          if (!ob_pdt_fifo_empty && !ob_fifo_full && !pf_debug_sel &&
              ((simp_cmd && pf_cqe_eot) ||
               (cmp_cmd && cmp_cmd_last_frame && pf_cqe_eot) ||
               (cmp_cmd && !cmp_cmd_last_frame && pf_frmd_eot)))
          begin
            ob_fifo_wr  = 1'b1;
            pf_clr      = 1'b1;
            ob_st_nxt   = OSF_OB_DF; 
          end

        
        
        else 
        begin
          ob_fifo_wr    = (!ob_pdt_fifo_empty && !ob_fifo_full) ? 1'b1 : 1'b0;
          ob_st_nxt     = OSF_OB_PF;
          ob_pf_rd_sel  = !ob_pdt_fifo_empty  ? 1'b1 : 1'b0;  
        end
      end

      default:
      begin
        ob_st_nxt  = OSF_OB_DF;
      end
    endcase
 

    
    case (ob_dmux_sel) 
      1'b0:
      begin
        ob_fifo_wdata  = ob_data_fifo_rdata;
      end
      1'b1: 
      begin
        ob_fifo_wdata  = ob_pdt_fifo_rdata;
      end
    endcase
 end

  always_ff @(posedge clk or negedge rst_n)
  begin
    if (~rst_n) 
    begin
      ob_st               <= OSF_OB_DF;
      
      
      cmp_cmd <= 0;
      cmp_cmd_last_frame <= 0;
      df_dat_val <= 0;
      df_rqe_val <= 0;
      pf_cqe_val <= 0;
      pre_frmd_val <= 0;
      simp_cmd <= 0;
      
    end
    else
    begin
      ob_st               <= ob_st_nxt;
      
      df_dat_val          <= df_clr ? 1'b0 :
                             (df_sot && !ob_dmux_sel && ob_fifo_wr ? 
                             ((df_tlv_word_0.tlv_type == DATA) || (df_tlv_word_0.tlv_type == DATA_UNK) || (df_tlv_word_0.tlv_type == LZ77)) :
                             df_dat_val);

      df_rqe_val          <= df_clr ? 1'b0 : 
                             (df_sot && !ob_dmux_sel && ob_fifo_wr ? 
                             (df_tlv_word_0.tlv_type == RQE) : df_rqe_val);

      pf_cqe_val          <=  pf_clr ? 1'b0 : 
                              (pf_sot && ob_dmux_sel && ob_fifo_wr ? 
                               (pf_tlv_word_0.tlv_type == CQE) : pf_cqe_val);

      pre_frmd_val        <= pf_clr ? 1'b0 : 
                             (pf_sot && ob_dmux_sel && ob_fifo_wr ? 
                              pf_frmd_word_0 : pre_frmd_val);

      simp_cmd            <= df_sot && !ob_dmux_sel && ob_fifo_wr && (df_tlv_word_0.tlv_type == RQE) ? 
                             (df_rqe_tlv_word_0.frame_size == RQE_SIMPLE) : simp_cmd;

      cmp_cmd             <= df_sot && !ob_dmux_sel && ob_fifo_wr && (df_tlv_word_0.tlv_type == RQE) ?
                             (df_rqe_tlv_word_0.frame_size == RQE_COMPOUND_4K || df_rqe_tlv_word_0.frame_size == RQE_COMPOUND_8K) : 
                             cmp_cmd;

      cmp_cmd_last_frame  <= df_sot && !ob_dmux_sel && ob_fifo_wr && 
                             ((df_tlv_word_0.tlv_type == DATA) || (df_tlv_word_0.tlv_type == DATA_UNK) || (df_tlv_word_0.tlv_type == LZ77)) ?
                             df_tlv_word_0.last_of_command : cmp_cmd_last_frame;


    end
  end

endmodule 










