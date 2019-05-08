/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/








 
module cr_isf_regfile 

   (
   
   rbus_ring_o, isf_fifo_ia_wdata, isf_fifo_ia_config, reg_addr,
   wr_stb, single_step_rd, isf_tlv_parse_action_0,
   isf_tlv_parse_action_1, debug_ctl_config, trace_ctl_en_config,
   trace_ctl_limits_config, ctl_config, system_stall_limit_config,
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
   aux_cmd_ev_match_val_3_crypto_config, debug_trig_mask_hi_config,
   debug_trig_mask_lo_config, debug_trig_match_hi_config,
   debug_trig_match_lo_config, debug_trig_tlv_config,
   
   rst_n, clk, rbus_ring_i, cfg_start_addr, cfg_end_addr,
   isf_fifo_ia_rdata, isf_fifo_ia_status, isf_fifo_ia_capability,
   isf_fifo_fifo_status_0, isf_fifo_fifo_status_1, debug_stat,
   debug_trig_cap_hi, debug_trig_cap_lo, debug_ss_cap_sb,
   debug_ss_cap_lo, debug_ss_cap_hi, ib_bytes_cnt_stb,
   ib_bytes_cnt_amt
   );

`include "cr_structs.sv"   


 import cr_isfPKG::*;
 import cr_isf_regfilePKG::*;
   
  
  output 			       rbus_ring_t                      rbus_ring_o;
  
  output                               isf_fifo_t                       isf_fifo_ia_wdata;
  output                               isf_fifo_ia_config_t             isf_fifo_ia_config;
  output [`CR_ISF_DECL]                                                 reg_addr;
  output                                                                wr_stb;  
  output reg                                                            single_step_rd;
  output                               isf_tlv_parse_action_31_0_t      isf_tlv_parse_action_0;
  output                               isf_tlv_parse_action_63_32_t     isf_tlv_parse_action_1;
  output                               debug_ctl_t                      debug_ctl_config;
  output 			       trace_ctl_en_t                   trace_ctl_en_config;
  output 			       trace_ctl_limits_t               trace_ctl_limits_config;   
  output                               ctl_t                            ctl_config;
  output                               system_stall_limit_t             system_stall_limit_config;
  output                               aux_cmd_ev_mask_val_0_comp_t     aux_cmd_ev_mask_val_0_comp_config;
  output                               aux_cmd_ev_mask_val_0_crypto_t   aux_cmd_ev_mask_val_0_crypto_config;
  output                               aux_cmd_ev_mask_val_1_comp_t     aux_cmd_ev_mask_val_1_comp_config;
  output                               aux_cmd_ev_mask_val_1_crypto_t   aux_cmd_ev_mask_val_1_crypto_config;
  output                               aux_cmd_ev_mask_val_2_comp_t     aux_cmd_ev_mask_val_2_comp_config;
  output                               aux_cmd_ev_mask_val_2_crypto_t   aux_cmd_ev_mask_val_2_crypto_config;
  output                               aux_cmd_ev_mask_val_3_comp_t     aux_cmd_ev_mask_val_3_comp_config;
  output                               aux_cmd_ev_mask_val_3_crypto_t   aux_cmd_ev_mask_val_3_crypto_config;
  output                               aux_cmd_ev_match_val_0_comp_t    aux_cmd_ev_match_val_0_comp_config;
  output                               aux_cmd_ev_match_val_0_crypto_t  aux_cmd_ev_match_val_0_crypto_config;
  output                               aux_cmd_ev_match_val_1_comp_t    aux_cmd_ev_match_val_1_comp_config;
  output                               aux_cmd_ev_match_val_1_crypto_t  aux_cmd_ev_match_val_1_crypto_config;
  output                               aux_cmd_ev_match_val_2_comp_t    aux_cmd_ev_match_val_2_comp_config;
  output                               aux_cmd_ev_match_val_2_crypto_t  aux_cmd_ev_match_val_2_crypto_config;
  output                               aux_cmd_ev_match_val_3_comp_t    aux_cmd_ev_match_val_3_comp_config;
  output                               aux_cmd_ev_match_val_3_crypto_t  aux_cmd_ev_match_val_3_crypto_config;
  output                               debug_trig_mask_hi_t             debug_trig_mask_hi_config;
  output                               debug_trig_mask_lo_t             debug_trig_mask_lo_config;
  output                               debug_trig_match_hi_t            debug_trig_match_hi_config;
  output                               debug_trig_match_lo_t            debug_trig_match_lo_config;
  output                               debug_trig_tlv_t                 debug_trig_tlv_config;
  
  
  input logic                          rst_n;
  input logic                          clk;
  input                                rbus_ring_t rbus_ring_i;
   
  input [`N_RBUS_ADDR_BITS-1:0]        cfg_start_addr;
  input [`N_RBUS_ADDR_BITS-1:0]        cfg_end_addr;
   
  
  input                                isf_fifo_t                  isf_fifo_ia_rdata;
  input                                isf_fifo_ia_status_t        isf_fifo_ia_status;
  input                                isf_fifo_ia_capability_t    isf_fifo_ia_capability;
  input                                isf_fifo_fifo_status_0_t    isf_fifo_fifo_status_0;
  input                                isf_fifo_fifo_status_1_t    isf_fifo_fifo_status_1;
  input                                debug_stat_t                debug_stat;
  input                                debug_trig_cap_hi_t         debug_trig_cap_hi;
  input                                debug_trig_cap_lo_t         debug_trig_cap_lo;
  input                                debug_ss_cap_sb_t           debug_ss_cap_sb;  
  input                                debug_ss_cap_lo_t           debug_ss_cap_lo;  
  input                                debug_ss_cap_hi_t           debug_ss_cap_hi;  

  
  input                                ib_bytes_cnt_stb;
  input [3:0]                          ib_bytes_cnt_amt;  

   
   
   logic		ib_agg_data_bytes_global_config;
   logic		locl_ack;		
   logic		locl_err_ack;		
   logic [31:0]		locl_rd_data;		
   logic		locl_rd_strb;		
   logic		locl_wr_strb;		
   logic		rd_stb;			
   
   
   logic [`CR_ISF_DECL]             locl_addr;
   logic [`N_RBUS_DATA_BITS-1:0]    locl_wr_data;
   spare_t                          spare; 
   
   
   counter_50_t                     ib_agg_bytes_cnt[1];  

   
   
   

   
   revid_t revid_wire;
     
   CR_TIE_CELL revid_wire_0 (.ob(revid_wire.f.revid[0]), .o());
   CR_TIE_CELL revid_wire_1 (.ob(revid_wire.f.revid[1]), .o());
   CR_TIE_CELL revid_wire_2 (.ob(revid_wire.f.revid[2]), .o());
   CR_TIE_CELL revid_wire_3 (.ob(revid_wire.f.revid[3]), .o());
   CR_TIE_CELL revid_wire_4 (.ob(revid_wire.f.revid[4]), .o());
   CR_TIE_CELL revid_wire_5 (.ob(revid_wire.f.revid[5]), .o());
   CR_TIE_CELL revid_wire_6 (.ob(revid_wire.f.revid[6]), .o());
   CR_TIE_CELL revid_wire_7 (.ob(revid_wire.f.revid[7]), .o());
   
   
   
   genvar              i;
   



  nx_event_counter_array_wide 
  #(.GLBL_RD_ADDRESS      (`CR_ISF_IB_AGG_DATA_BYTES_GLOBAL_READ),           
    .BASE_ADDRESS         (`CR_ISF_IB_AGG_DATA_BYTES_0_COUNT_PART0_A),       
    .ALIGNMENT            (2),                                               
    .N_ADDR_BITS          (`CR_ISF_WIDTH),                                   
    .N_REG_BITS           (32),                                              
    .N_COUNTERS           (1),                                               
    .N_COUNT_BY_BITS      (4),                                               
    .N_COUNTER_BITS       (50))                                              
  u_ib_agg_data_bytes_cntr
  (
   
   .clk            (clk),
   .rst_n          (rst_n),
   .reg_addr       (reg_addr), 
   .counter_config (ib_agg_data_bytes_global_config),
   .rd_stb         (rd_stb), 
   .wr_stb         (wr_stb), 
   .reg_data       (32'd0), 
   .count_stb      (ib_bytes_cnt_stb), 
   .count_by       (ib_bytes_cnt_amt), 
   .count_id       (1'b0),
   
   .counter_a      (ib_agg_bytes_cnt)); 


   

   
   cr_isf_regs u_cr_isf_regs 
   (
    
    
    .o_rd_data				(locl_rd_data[31:0]),	 
    .o_ack				(locl_ack),		 
    .o_err_ack				(locl_err_ack),		 
    .o_spare_config			(spare),		 
    .o_isf_tlv_parse_action_0		(isf_tlv_parse_action_0), 
    .o_isf_tlv_parse_action_1		(isf_tlv_parse_action_1), 
    .o_ctl_config			(ctl_config),		 
    .o_system_stall_limit_config	(system_stall_limit_config), 
    .o_debug_ctl_config			(debug_ctl_config),	 
    .o_debug_ss_ctl_config		(),			 
    .o_debug_trig_tlv_config		(debug_trig_tlv_config), 
    .o_debug_trig_match_lo_config	(debug_trig_match_lo_config), 
    .o_debug_trig_match_hi_config	(debug_trig_match_hi_config), 
    .o_debug_trig_mask_lo_config	(debug_trig_mask_lo_config), 
    .o_debug_trig_mask_hi_config	(debug_trig_mask_hi_config), 
    .o_trace_ctl_en_config		(trace_ctl_en_config),	 
    .o_trace_ctl_limits_config		(trace_ctl_limits_config), 
    .o_aux_cmd_ev_match_val_0_comp_config(aux_cmd_ev_match_val_0_comp_config), 
    .o_aux_cmd_ev_match_val_0_crypto_config(aux_cmd_ev_match_val_0_crypto_config), 
    .o_aux_cmd_ev_mask_val_0_comp_config(aux_cmd_ev_mask_val_0_comp_config), 
    .o_aux_cmd_ev_mask_val_0_crypto_config(aux_cmd_ev_mask_val_0_crypto_config), 
    .o_aux_cmd_ev_match_val_1_comp_config(aux_cmd_ev_match_val_1_comp_config), 
    .o_aux_cmd_ev_match_val_1_crypto_config(aux_cmd_ev_match_val_1_crypto_config), 
    .o_aux_cmd_ev_mask_val_1_comp_config(aux_cmd_ev_mask_val_1_comp_config), 
    .o_aux_cmd_ev_mask_val_1_crypto_config(aux_cmd_ev_mask_val_1_crypto_config), 
    .o_aux_cmd_ev_match_val_2_comp_config(aux_cmd_ev_match_val_2_comp_config), 
    .o_aux_cmd_ev_match_val_2_crypto_config(aux_cmd_ev_match_val_2_crypto_config), 
    .o_aux_cmd_ev_mask_val_2_comp_config(aux_cmd_ev_mask_val_2_comp_config), 
    .o_aux_cmd_ev_mask_val_2_crypto_config(aux_cmd_ev_mask_val_2_crypto_config), 
    .o_aux_cmd_ev_match_val_3_comp_config(aux_cmd_ev_match_val_3_comp_config), 
    .o_aux_cmd_ev_match_val_3_crypto_config(aux_cmd_ev_match_val_3_crypto_config), 
    .o_aux_cmd_ev_mask_val_3_comp_config(aux_cmd_ev_mask_val_3_comp_config), 
    .o_aux_cmd_ev_mask_val_3_crypto_config(aux_cmd_ev_mask_val_3_crypto_config), 
    .o_isf_fifo_ia_wdata_part0		(isf_fifo_ia_wdata.r.part0), 
    .o_isf_fifo_ia_wdata_part1		(isf_fifo_ia_wdata.r.part1), 
    .o_isf_fifo_ia_wdata_part2		(isf_fifo_ia_wdata.r.part2), 
    .o_isf_fifo_ia_config		(isf_fifo_ia_config),	 
    .o_ib_agg_data_bytes_global_config	(ib_agg_data_bytes_global_config), 
    .o_reg_written			(wr_stb),		 
    .o_reg_read				(rd_stb),		 
    .o_reg_wr_data			(),			 
    .o_reg_addr				(reg_addr[`CR_ISF_DECL]), 
    
    .clk				(clk),
    .i_reset_				(rst_n),		 
    .i_sw_init				(1'd0),			 
    .i_addr				(locl_addr),		 
    .i_wr_strb				(locl_wr_strb),		 
    .i_wr_data				(locl_wr_data),		 
    .i_rd_strb				(locl_rd_strb),		 
    .i_revision_config			(revid_wire),		 
    .i_spare_config			(spare),		 
    .i_debug_stat			(debug_stat),		 
    .i_debug_trig_cap_lo		(debug_trig_cap_lo),	 
    .i_debug_trig_cap_hi		(debug_trig_cap_hi),	 
    .i_debug_ss_cap_sb			(debug_ss_cap_sb),	 
    .i_debug_ss_cap_lo			(debug_ss_cap_lo),	 
    .i_debug_ss_cap_hi			(debug_ss_cap_hi),	 
    .i_isf_fifo_ia_capability		(isf_fifo_ia_capability), 
    .i_isf_fifo_ia_status		(isf_fifo_ia_status),	 
    .i_isf_fifo_ia_rdata_part0		(isf_fifo_ia_rdata.r.part0), 
    .i_isf_fifo_ia_rdata_part1		(isf_fifo_ia_rdata.r.part1), 
    .i_isf_fifo_ia_rdata_part2		(isf_fifo_ia_rdata.r.part2), 
    .i_isf_fifo_fifo_status_0		(isf_fifo_fifo_status_0), 
    .i_isf_fifo_fifo_status_1		(isf_fifo_fifo_status_1), 
    .i_ib_agg_data_bytes_0_count_part0_a(ib_agg_bytes_cnt[0].count_part0), 
    .i_ib_agg_data_bytes_0_count_part1_a(ib_agg_bytes_cnt[0].count_part1), 
    .i_ib_agg_data_bytes_global_read	(1'b0));			 

   
   
   
   nx_rbus_ring 
     #(
       .N_RBUS_ADDR_BITS (`N_RBUS_ADDR_BITS),             
       .N_LOCL_ADDR_BITS (`CR_ISF_WIDTH),           
       .N_RBUS_DATA_BITS (`N_RBUS_DATA_BITS))             
   u_nx_rbus_ring 
     (.*,
      
      .rbus_addr_o			(rbus_ring_o.addr),	 
      .rbus_wr_strb_o			(rbus_ring_o.wr_strb),	 
      .rbus_wr_data_o			(rbus_ring_o.wr_data),	 
      .rbus_rd_strb_o			(rbus_ring_o.rd_strb),	 
      .locl_addr_o			(locl_addr),		 
      .locl_wr_strb_o			(locl_wr_strb),		 
      .locl_wr_data_o			(locl_wr_data),		 
      .locl_rd_strb_o			(locl_rd_strb),		 
      .rbus_rd_data_o			(rbus_ring_o.rd_data),	 
      .rbus_ack_o			(rbus_ring_o.ack),	 
      .rbus_err_ack_o			(rbus_ring_o.err_ack),	 
      
      .rbus_addr_i			(rbus_ring_i.addr),	 
      .rbus_wr_strb_i			(rbus_ring_i.wr_strb),	 
      .rbus_wr_data_i			(rbus_ring_i.wr_data),	 
      .rbus_rd_strb_i			(rbus_ring_i.rd_strb),	 
      .rbus_rd_data_i			(rbus_ring_i.rd_data),	 
      .rbus_ack_i			(rbus_ring_i.ack),	 
      .rbus_err_ack_i			(rbus_ring_i.err_ack),	 
      .locl_rd_data_i			(locl_rd_data),		 
      .locl_ack_i			(locl_ack),		 
      .locl_err_ack_i			(locl_err_ack));		 


  
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) 
      begin
	
	
	single_step_rd <= 0;
	
      end
      else
      begin
        single_step_rd <= wr_stb && (reg_addr == `CR_ISF_DEBUG_SS_CTL_CONFIG);
      end
   end


endmodule 










