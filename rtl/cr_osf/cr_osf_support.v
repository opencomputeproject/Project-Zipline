/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



















module cr_osf_support
(
  
  osf_stat_events, osf_sup_cqe_exit, ob_bytes_cnt_stb,
  ob_bytes_cnt_amt, ob_frame_cnt_stb,
  
  clk, rst_n, osf_ib_in, osf_ib_out, osf_cg_ib_in, osf_cg_ib_out,
  ob_out, ob_fifo_empty, axi_mstr_rd, debug_ctl_config
  );
  
`include "cr_structs.sv"
  
  import cr_osfPKG::*;
  import cr_osf_regsPKG::*;

  
  
  
  input                                   clk;
  input                                   rst_n; 
  
  
  
  
  input  axi4s_dp_bus_t                   osf_ib_in; 
  input  axi4s_dp_rdy_t                   osf_ib_out;

  
  
  
  input  axi4s_dp_bus_t                   osf_cg_ib_in; 
  input  axi4s_dp_rdy_t                   osf_cg_ib_out;
  
 
 
 
  input  axi4s_dp_bus_t                   ob_out; 
  input                                   ob_fifo_empty;
  input                                   axi_mstr_rd;

  
  
  
  output osf_stats_t                      osf_stat_events;

  
  
  
  output reg                              osf_sup_cqe_exit;

  
  
  
  input  debug_ctl_t                      debug_ctl_config; 

  output reg                              ob_bytes_cnt_stb;
  output reg [3:0]                        ob_bytes_cnt_amt;
  output reg                              ob_frame_cnt_stb;

  
  
  
  logic                                   ob_cmd_active;
  logic [3:0]                             ob_out_bytes_valid;

  cqe_par_st_e                            cqe_par_st;
  osf_ob_par_st_e                         osf_ob_par_st;
  osf_ob_data_par_st_e                    osf_ob_data_par_st;
  tlv_word_0_t                            ob_tlv_word0;  
  
  
  

  
  assign ob_tlv_word0   = ob_out.tdata;

  
  assign osf_stat_events.rsvd  = 60'h0;

  
  assign ob_out_bytes_valid  = ob_out.tstrb[7] + ob_out.tstrb[6] + 
                               ob_out.tstrb[5] + ob_out.tstrb[4] + 
                               ob_out.tstrb[3] + ob_out.tstrb[2] +
                               ob_out.tstrb[1] + ob_out.tstrb[0];

  always_ff @(posedge clk or negedge rst_n)
  begin
    if (~rst_n) 
    begin
      osf_stat_events.dat_fifo_stall <= 1'b0;
      osf_stat_events.pdt_fifo_stall <= 1'b0;
      osf_stat_events.ob_sys_bp      <= 1'b0;
      osf_stat_events.ob_stall       <= 1'b0;
      osf_sup_cqe_exit               <= 1'b0;
      ob_cmd_active                  <= 1'b0;
      ob_bytes_cnt_stb               <= 1'b0;
      ob_bytes_cnt_amt               <= 3'h0;
      ob_frame_cnt_stb               <= 1'b0;
      cqe_par_st                     <= CQE_PAR_IDLE;
      osf_ob_par_st                  <= OSF_OB_PAR_IDLE;
      osf_ob_data_par_st             <= OSF_OB_DATA_PAR_IDLE;
    end
    else
    begin
      
      
      
      osf_stat_events.dat_fifo_stall <= osf_ib_in.tvalid && !osf_ib_out.tready;

      
      
      osf_stat_events.pdt_fifo_stall <= osf_cg_ib_in.tvalid && !osf_cg_ib_out.tready;

      
      osf_stat_events.ob_stall       <= ob_fifo_empty && ob_cmd_active;

      
      
      osf_stat_events.ob_sys_bp      <= !ob_fifo_empty  && !axi_mstr_rd;

      
      
      
      
      case (cqe_par_st)
        
        
        CQE_PAR_IDLE:
        begin
          osf_sup_cqe_exit            <= 1'b0;

          if (ob_out.tuser[0] && (ob_tlv_word0.tlv_type == CQE) && axi_mstr_rd)
          begin
            cqe_par_st <= CQE_PAR_FOUND;
          end
          else
          begin
            cqe_par_st <= CQE_PAR_IDLE;
          end
        end

        
        CQE_PAR_FOUND:
        begin
          if (ob_out.tuser[1] && axi_mstr_rd)
          begin
            osf_sup_cqe_exit            <= 1'b1;
            cqe_par_st                  <= CQE_PAR_IDLE;
          end
          else
          begin
            cqe_par_st <= CQE_PAR_FOUND;
          end
        end
      endcase

      
      
      
      
      
      case (osf_ob_par_st)
        
        
        OSF_OB_PAR_IDLE:
        begin
          if (ob_out.tuser[0] && (ob_tlv_word0.tlv_type == RQE) && axi_mstr_rd)
          begin
            ob_cmd_active <= 1'b1;
            osf_ob_par_st <= OSF_OB_RQE_PAR_FOUND;
          end
          else
          begin
            ob_cmd_active <= 1'b0;
            osf_ob_par_st <= OSF_OB_PAR_IDLE;
          end
        end

        
        OSF_OB_RQE_PAR_FOUND:
        begin
          ob_cmd_active          <= 1'b1;

          if (ob_out.tuser[0] && (ob_tlv_word0.tlv_type == CQE) && axi_mstr_rd)
          begin
            osf_ob_par_st <= OSF_OB_CQE_PAR_FOUND;
          end
          else
          begin
            osf_ob_par_st <= OSF_OB_RQE_PAR_FOUND;
          end
        end

        
        OSF_OB_CQE_PAR_FOUND:
        begin
          if (ob_out.tuser[1] && axi_mstr_rd)
          begin
            ob_cmd_active <= 1'b0;
            osf_ob_par_st <= OSF_OB_PAR_IDLE;
          end
          else
          begin
            ob_cmd_active <= 1'b1;
            osf_ob_par_st <= OSF_OB_CQE_PAR_FOUND;
          end
        end

        default:
        begin
          ob_cmd_active <= 1'b0;
          osf_ob_par_st <= OSF_OB_PAR_IDLE;
        end
      endcase


      
      
      
      
      case (osf_ob_data_par_st)
        
        
        
        OSF_OB_DATA_PAR_IDLE:
        begin
          ob_bytes_cnt_stb   <= 1'b0;

          if (ob_out.tuser[0] && ((ob_tlv_word0.tlv_type == DATA) || (ob_tlv_word0.tlv_type == DATA_UNK)) && axi_mstr_rd)
          begin
            ob_frame_cnt_stb   <= 1'b1;
            osf_ob_data_par_st <= OSF_OB_DATA_PAR_FOUND;
          end
          else
          begin
            osf_ob_data_par_st <= OSF_OB_DATA_PAR_IDLE;
          end
        end

        
        OSF_OB_DATA_PAR_FOUND:
        begin
          ob_frame_cnt_stb <= 1'b0;

          if (ob_out.tuser[1] && axi_mstr_rd)
          begin
            ob_bytes_cnt_stb   <= 1'b1;
            ob_bytes_cnt_amt   <= ob_out_bytes_valid;
            osf_ob_data_par_st <= OSF_OB_DATA_PAR_IDLE;
          end
          else if (axi_mstr_rd)
          begin
            ob_bytes_cnt_stb   <= 1'b1;
            ob_bytes_cnt_amt   <= ob_out_bytes_valid;
            osf_ob_data_par_st <= OSF_OB_DATA_PAR_FOUND;
          end
          else
          begin
            ob_bytes_cnt_stb   <= 1'b0;
            osf_ob_data_par_st <= OSF_OB_DATA_PAR_FOUND;
          end
        end
      endcase
    end
  end

endmodule 












