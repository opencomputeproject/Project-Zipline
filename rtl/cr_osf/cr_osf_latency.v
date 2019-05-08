/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


















module cr_osf_latency
(
  
  axi4s_out,
  
  clk, rst_n, axi4s_in, axi4s_mstr_rd
  );
  
`include "cr_structs.sv"
  
  import cr_osfPKG::*;
  import cr_osf_regsPKG::*;

  
  
  
  input                                 clk;
  input                                 rst_n; 
  
  
  
  
  input  axi4s_dp_bus_t                 axi4s_in;
  input                                 axi4s_mstr_rd;
  output axi4s_dp_bus_t                 axi4s_out; 

  
  
  

  

  osf_lat_ctl_st_e                      osf_lat_ctl_st;
  osf_lat_ctl_st_e                      osf_lat_ctl_st_nxt;
  tlv_stats_word2_t                     stats_w2_in; 
  tlv_stats_word2_t                     stats_w2_out;
  tlv_word_0_t                          axi4s_in_w0; 

  logic                                 axi4s_in_sot;
  logic                                 axi4s_in_eot;
  logic                                 lat_out_sel;
  logic                                 lat_cnt_en;
  logic                                 lat_cnt_clr;
  logic                                 osf_frmd_tlv_type;
  logic [23:0]                          latency_cnt;
  logic [23:0]                          latency_cnt_adj;
  

  
  
  
  assign stats_w2_in              = axi4s_in.tdata;
  assign axi4s_in_w0              = axi4s_in.tdata;
  assign axi4s_in_sot             = (axi4s_in.tuser == 8'h1);
  assign axi4s_in_eot             = (axi4s_in.tuser == 8'h2);

  assign osf_frmd_tlv_type        = (axi4s_in_w0.tlv_type == FRMD_USER_NULL) ||
                                    (axi4s_in_w0.tlv_type == FRMD_USER_PI16) ||
                                    (axi4s_in_w0.tlv_type == FRMD_USER_PI64) ||
                                    (axi4s_in_w0.tlv_type == FRMD_USER_VM) ||
                                    (axi4s_in_w0.tlv_type == FRMD_INT_APP) ||
                                    (axi4s_in_w0.tlv_type == FRMD_INT_SIP) ||
                                    (axi4s_in_w0.tlv_type == FRMD_INT_LIP) ||
                                    (axi4s_in_w0.tlv_type == FRMD_INT_VM)   ||
                                    (axi4s_in_w0.tlv_type == FRMD_INT_VM_SHORT) ;

  


  
  
  
  
  
  
  
  
  always_comb
  begin
    
    lat_out_sel  = 1'b0;
    lat_cnt_en   = 1'b0;
    lat_cnt_clr  = 1'b0;

    case (osf_lat_ctl_st)

      
      
      OSF_LAT_CTL_IDLE: 
      begin
        
        if (axi4s_mstr_rd && (axi4s_in_w0.tlv_type == RQE) && axi4s_in_sot)
        begin
          lat_cnt_en          = 1'b1;
          osf_lat_ctl_st_nxt  = OSF_LAT_CTL_WAIT;
        end
        else
        begin
          lat_cnt_clr         = 1'b1;
          osf_lat_ctl_st_nxt  = OSF_LAT_CTL_IDLE;
        end
      end

      
      OSF_LAT_CTL_WAIT: 
      begin
        if (axi4s_mstr_rd && (axi4s_in_w0.tlv_type == STAT) && axi4s_in_sot)
        begin
          lat_cnt_en          = 1'b1;
          osf_lat_ctl_st_nxt  = OSF_LAT_CTL_STAT;
        end
        else
        begin
          lat_cnt_en          = 1'b1;
          osf_lat_ctl_st_nxt  = OSF_LAT_CTL_WAIT;
        end
      end

      
      
      
      
      OSF_LAT_CTL_STAT: 
      begin
        if (axi4s_mstr_rd)
        begin
          lat_cnt_en          = 1'b1;
          osf_lat_ctl_st_nxt  = OSF_LAT_CTL_INSERT;
        end
        else
        begin
          lat_cnt_en          = 1'b1;
          osf_lat_ctl_st_nxt  = OSF_LAT_CTL_IDLE;
        end
      end

      
      
      OSF_LAT_CTL_INSERT: 
      begin
        lat_out_sel  = 1'b1;

        if (axi4s_mstr_rd)
        begin
          osf_lat_ctl_st_nxt  = OSF_LAT_CTL_IDLE;
        end
        else
        begin
          lat_cnt_en          = 1'b1;
          lat_out_sel         = 1'b1;
          osf_lat_ctl_st_nxt  = OSF_LAT_CTL_INSERT;
        end
      end

      default: osf_lat_ctl_st_nxt  = OSF_LAT_CTL_IDLE;
    endcase
  end

  
  
  
  

  
  assign latency_cnt_adj  = latency_cnt + 24'h1; 

  always_comb
  begin

    axi4s_out.tvalid  = axi4s_in.tvalid;
    axi4s_out.tlast   = axi4s_in.tlast;
    axi4s_out.tid     = axi4s_in.tid;
    axi4s_out.tstrb   = axi4s_in.tstrb;   
    axi4s_out.tuser   = axi4s_in.tuser;  

    stats_w2_out      = {
                         stats_w2_in.rsvd1,
                         stats_w2_in.frame_error,
                         stats_w2_in.rsvd0,
                         latency_cnt_adj   
                         };

    axi4s_out.tdata  = lat_out_sel ? stats_w2_out : axi4s_in.tdata;
  end

  
  
  
  always_ff @(posedge clk or negedge rst_n)
  begin
    if (~rst_n) 
    begin
      osf_lat_ctl_st <= OSF_LAT_CTL_IDLE;
      
      
      latency_cnt <= 0;
      
    end
    else  
    begin
      osf_lat_ctl_st <= osf_lat_ctl_st_nxt;

      latency_cnt    <= lat_cnt_clr ? 24'h0 : 
                        lat_cnt_en ? latency_cnt + 24'h1 : 
                        latency_cnt;
    end
  end

endmodule 










