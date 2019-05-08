/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_osf.vh"

module cr_osf_regfile 

  (
  
  rbus_ring_o, osf_data_fifo_ia_wdata, osf_data_fifo_ia_config,
  osf_pdt_fifo_ia_wdata, osf_pdt_fifo_ia_config, reg_addr, wr_stb,
  data_fifo_single_step_rd, pdt_fifo_single_step_rd,
  data_fifo_debug_ctl_config, pdt_fifo_debug_ctl_config,
  osf_tlv_parse_action_0, osf_tlv_parse_action_1, debug_ctl_config,
  
  cfg_start_addr, cfg_end_addr, rst_n, clk, rbus_ring_i,
  osf_data_fifo_ia_rdata, osf_data_fifo_ia_status,
  osf_data_fifo_ia_capability, osf_data_fifo_fifo_status_0,
  osf_data_fifo_fifo_status_1, osf_pdt_fifo_ia_rdata,
  osf_pdt_fifo_ia_status, osf_pdt_fifo_ia_capability,
  osf_pdt_fifo_fifo_status_0, osf_pdt_fifo_fifo_status_1,
  data_fifo_debug_stat, pdt_fifo_debug_stat, ob_bytes_cnt_stb,
  ob_bytes_cnt_amt, ob_frame_cnt_stb
  );

`include "cr_structs.sv"   
  import cr_osfPKG::*;
  import cr_osf_regfilePKG::*;

   input [`N_RBUS_ADDR_BITS-1:0]       cfg_start_addr;
   input [`N_RBUS_ADDR_BITS-1:0]       cfg_end_addr;
   
  
  output 			       rbus_ring_t                     rbus_ring_o;
  
  output                               osf_data_fifo_t                 osf_data_fifo_ia_wdata;
  output                               osf_data_fifo_ia_config_t       osf_data_fifo_ia_config;
  output                               osf_pdt_fifo_t                  osf_pdt_fifo_ia_wdata;
  output                               osf_pdt_fifo_ia_config_t        osf_pdt_fifo_ia_config;
  output [`CR_OSF_DECL]                reg_addr;
  output                               wr_stb;  
  output reg                                                           data_fifo_single_step_rd;
  output reg                                                           pdt_fifo_single_step_rd;
  output                               data_fifo_debug_ctl_t           data_fifo_debug_ctl_config;
  output                               pdt_fifo_debug_ctl_t            pdt_fifo_debug_ctl_config;
  output                               osf_tlv_parse_action_31_0_t     osf_tlv_parse_action_0;
  output                               osf_tlv_parse_action_63_32_t    osf_tlv_parse_action_1;
  output                               debug_ctl_t                     debug_ctl_config;
  
  input logic 			                                       rst_n;
  input logic 			                                       clk;
  input 			       rbus_ring_t                     rbus_ring_i;
  
  input                                osf_data_fifo_t                 osf_data_fifo_ia_rdata;
  input                                osf_data_fifo_ia_status_t       osf_data_fifo_ia_status;
  input                                osf_data_fifo_ia_capability_t   osf_data_fifo_ia_capability;
  input                                osf_data_fifo_fifo_status_0_t   osf_data_fifo_fifo_status_0;
  input                                osf_data_fifo_fifo_status_1_t   osf_data_fifo_fifo_status_1;

  input                                osf_pdt_fifo_t                  osf_pdt_fifo_ia_rdata;
  input                                osf_pdt_fifo_ia_status_t        osf_pdt_fifo_ia_status;
  input                                osf_pdt_fifo_ia_capability_t    osf_pdt_fifo_ia_capability;
  input                                osf_pdt_fifo_fifo_status_0_t    osf_pdt_fifo_fifo_status_0;
  input                                osf_pdt_fifo_fifo_status_1_t    osf_pdt_fifo_fifo_status_1;

  input                                data_fifo_debug_stat_t          data_fifo_debug_stat;
  input                                pdt_fifo_debug_stat_t           pdt_fifo_debug_stat;  

  
  input                                ob_bytes_cnt_stb;
  input [3:0]                          ob_bytes_cnt_amt;  
  input                                ob_frame_cnt_stb;

  
  
  logic                 locl_ack;               
  logic                 locl_err_ack;           
  logic [31:0]          locl_rd_data;           
  logic                 locl_rd_strb;           
  logic                 locl_wr_strb;           
  logic                 ob_agg_data_bytes_global_config;
  logic                 ob_agg_frame_global_config;
  logic                 rd_stb;                 
  
  
  logic [`CR_OSF_DECL]                 locl_addr;
  logic [`N_RBUS_DATA_BITS-1:0]        locl_wr_data;
  
  
  counter_50_t          ob_agg_bytes_cnt[1];  
  counter_50_t          ob_agg_frame_cnt[1];  
  spare_t               spare; 
  
  
  
  

  
  revid_t revid_wire;
  
  CR_TIE_CELL revid_wire_0 (.ob(revid_wire.f.revid[0]), .o());
  CR_TIE_CELL revid_wire_1 (.ob(revid_wire.f.revid[1]), .o());
  CR_TIE_CELL revid_wire_2 (.ob(revid_wire.f.revid[2]), .o());
  CR_TIE_CELL revid_wire_3 (.ob(revid_wire.f.revid[3]), .o());
  CR_TIE_CELL revid_wire_4 (.ob(revid_wire.f.revid[4]), .o());
  CR_TIE_CELL revid_wire_5 (.ob(revid_wire.f.revid[5]), .o());
  CR_TIE_CELL revid_wire_6 (.ob(revid_wire.f.revid[6]), .o());
  CR_TIE_CELL revid_wire_7 (.ob(revid_wire.f.revid[7]), .o());
  
  
  
  genvar                               i;
  



  nx_event_counter_array_wide 
  #(.GLBL_RD_ADDRESS      (`CR_OSF_OB_AGG_DATA_BYTES_GLOBAL_READ),           
    .BASE_ADDRESS         (`CR_OSF_OB_AGG_DATA_BYTES_0_COUNT_PART0_A),       
    .ALIGNMENT            (2),                                               
    .N_ADDR_BITS          (`CR_OSF_WIDTH),                                   
    .N_REG_BITS           (32),                                              
    .N_COUNTERS           (1),                                               
    .N_COUNT_BY_BITS      (4),                                               
    .N_COUNTER_BITS       (50))                                              
  u_ob_agg_data_bytes_cntr
  (
   
   .clk            (clk),
   .rst_n          (rst_n),
   .reg_addr       (reg_addr), 
   .counter_config (ob_agg_data_bytes_global_config),
   .rd_stb         (rd_stb), 
   .wr_stb         (wr_stb), 
   .reg_data       (32'd0), 
   .count_stb      (ob_bytes_cnt_stb), 
   .count_by       (ob_bytes_cnt_amt), 
   .count_id       (1'b0),
   
   .counter_a      (ob_agg_bytes_cnt)); 




  nx_event_counter_array_wide 
  #(.GLBL_RD_ADDRESS      (`CR_OSF_OB_AGG_FRAME_GLOBAL_READ),                
    .BASE_ADDRESS         (`CR_OSF_OB_AGG_FRAME_0_COUNT_PART0_A),            
    .ALIGNMENT            (2),                                               
    .N_ADDR_BITS          (`CR_OSF_WIDTH),                                   
    .N_REG_BITS           (32),                                              
    .N_COUNTERS           (1),                                               
    .N_COUNT_BY_BITS      (1),                                               
    .N_COUNTER_BITS       (50))                                              
  u_ob_agg_frame_cntr
  (
   
   .clk            (clk),
   .rst_n          (rst_n),
   .reg_addr       (reg_addr), 
   .counter_config (ob_agg_frame_global_config),
   .rd_stb         (rd_stb),
   .wr_stb         (wr_stb),
   .reg_data       (32'd0),
   .count_stb      (ob_frame_cnt_stb), 
   .count_by       (1'b1), 
   .count_id       (1'b0),
   
   .counter_a      (ob_agg_frame_cnt)); 

  
  
  cr_osf_regs u_cr_osf_regs (
                             
                             .o_rd_data         (locl_rd_data[31:0]), 
                             .o_ack             (locl_ack),      
                             .o_err_ack         (locl_err_ack),  
                             .o_spare_config    (spare),         
                             .o_osf_tlv_parse_action_0(osf_tlv_parse_action_0), 
                             .o_osf_tlv_parse_action_1(osf_tlv_parse_action_1), 
                             .o_debug_ctl_config(debug_ctl_config), 
                             .o_data_fifo_debug_ctl_config(data_fifo_debug_ctl_config), 
                             .o_data_fifo_debug_ss_ctl_config(), 
                             .o_pdt_fifo_debug_ctl_config(pdt_fifo_debug_ctl_config), 
                             .o_pdt_fifo_debug_ss_ctl_config(),  
                             .o_osf_data_fifo_ia_wdata_part0(osf_data_fifo_ia_wdata.r.part0), 
                             .o_osf_data_fifo_ia_wdata_part1(osf_data_fifo_ia_wdata.r.part1), 
                             .o_osf_data_fifo_ia_wdata_part2(osf_data_fifo_ia_wdata.r.part2), 
                             .o_osf_data_fifo_ia_config(osf_data_fifo_ia_config), 
                             .o_osf_pdt_fifo_ia_wdata_part0(osf_pdt_fifo_ia_wdata.r.part0), 
                             .o_osf_pdt_fifo_ia_wdata_part1(osf_pdt_fifo_ia_wdata.r.part1), 
                             .o_osf_pdt_fifo_ia_wdata_part2(osf_pdt_fifo_ia_wdata.r.part2), 
                             .o_osf_pdt_fifo_ia_config(osf_pdt_fifo_ia_config), 
                             .o_ob_agg_data_bytes_global_config(ob_agg_data_bytes_global_config), 
                             .o_ob_agg_frame_global_config(ob_agg_frame_global_config), 
                             .o_reg_written     (wr_stb),        
                             .o_reg_read        (rd_stb),        
                             .o_reg_wr_data     (),              
                             .o_reg_addr        (reg_addr[`CR_OSF_DECL]), 
                             
                             .clk               (clk),
                             .i_reset_          (rst_n),         
                             .i_sw_init         (1'd0),          
                             .i_addr            (locl_addr),     
                             .i_wr_strb         (locl_wr_strb),  
                             .i_wr_data         (locl_wr_data),  
                             .i_rd_strb         (locl_rd_strb),  
                             .i_revision_config (revid_wire),    
                             .i_spare_config    (spare),         
                             .i_data_fifo_debug_stat(data_fifo_debug_stat), 
                             .i_pdt_fifo_debug_stat(pdt_fifo_debug_stat), 
                             .i_osf_data_fifo_ia_capability(osf_data_fifo_ia_capability), 
                             .i_osf_data_fifo_ia_status(osf_data_fifo_ia_status), 
                             .i_osf_data_fifo_ia_rdata_part0(osf_data_fifo_ia_rdata.r.part0), 
                             .i_osf_data_fifo_ia_rdata_part1(osf_data_fifo_ia_rdata.r.part1), 
                             .i_osf_data_fifo_ia_rdata_part2(osf_data_fifo_ia_rdata.r.part2), 
                             .i_osf_data_fifo_fifo_status_0(osf_data_fifo_fifo_status_0), 
                             .i_osf_data_fifo_fifo_status_1(osf_data_fifo_fifo_status_1), 
                             .i_osf_pdt_fifo_ia_capability(osf_pdt_fifo_ia_capability), 
                             .i_osf_pdt_fifo_ia_status(osf_pdt_fifo_ia_status), 
                             .i_osf_pdt_fifo_ia_rdata_part0(osf_pdt_fifo_ia_rdata.r.part0), 
                             .i_osf_pdt_fifo_ia_rdata_part1(osf_pdt_fifo_ia_rdata.r.part1), 
                             .i_osf_pdt_fifo_ia_rdata_part2(osf_pdt_fifo_ia_rdata.r.part2), 
                             .i_osf_pdt_fifo_fifo_status_0(osf_pdt_fifo_fifo_status_0), 
                             .i_osf_pdt_fifo_fifo_status_1(osf_pdt_fifo_fifo_status_1), 
                             .i_ob_agg_data_bytes_0_count_part0_a(ob_agg_bytes_cnt[0].count_part0), 
                             .i_ob_agg_data_bytes_0_count_part1_a(ob_agg_bytes_cnt[0].count_part1), 
                             .i_ob_agg_data_bytes_global_read(1'b0), 
                             .i_ob_agg_frame_0_count_part0_a(ob_agg_frame_cnt[0].count_part0), 
                             .i_ob_agg_frame_0_count_part1_a(ob_agg_frame_cnt[0].count_part1), 
                             .i_ob_agg_frame_global_read(1'b0));  

  
  
  
  nx_rbus_ring 
  #(
    .N_RBUS_ADDR_BITS (`N_RBUS_ADDR_BITS),             
    .N_LOCL_ADDR_BITS (`CR_OSF_WIDTH),           
    .N_RBUS_DATA_BITS (`N_RBUS_DATA_BITS))             
  u_nx_rbus_ring 
  (.*,
   
   .rbus_addr_o                         (rbus_ring_o.addr),      
   .rbus_wr_strb_o                      (rbus_ring_o.wr_strb),   
   .rbus_wr_data_o                      (rbus_ring_o.wr_data),   
   .rbus_rd_strb_o                      (rbus_ring_o.rd_strb),   
   .locl_addr_o                         (locl_addr),             
   .locl_wr_strb_o                      (locl_wr_strb),          
   .locl_wr_data_o                      (locl_wr_data),          
   .locl_rd_strb_o                      (locl_rd_strb),          
   .rbus_rd_data_o                      (rbus_ring_o.rd_data),   
   .rbus_ack_o                          (rbus_ring_o.ack),       
   .rbus_err_ack_o                      (rbus_ring_o.err_ack),   
   
   .rbus_addr_i                         (rbus_ring_i.addr),      
   .rbus_wr_strb_i                      (rbus_ring_i.wr_strb),   
   .rbus_wr_data_i                      (rbus_ring_i.wr_data),   
   .rbus_rd_strb_i                      (rbus_ring_i.rd_strb),   
   .rbus_rd_data_i                      (rbus_ring_i.rd_data),   
   .rbus_ack_i                          (rbus_ring_i.ack),       
   .rbus_err_ack_i                      (rbus_ring_i.err_ack),   
   .locl_rd_data_i                      (locl_rd_data),          
   .locl_ack_i                          (locl_ack),              
   .locl_err_ack_i                      (locl_err_ack));          


  
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) 
      begin
	
        
        data_fifo_single_step_rd <= 0;
        pdt_fifo_single_step_rd <= 0;
        
      end
      else
      begin
        data_fifo_single_step_rd <= wr_stb && (reg_addr == `CR_OSF_DATA_FIFO_DEBUG_SS_CTL_CONFIG);
        pdt_fifo_single_step_rd  <= wr_stb && (reg_addr == `CR_OSF_PDT_FIFO_DEBUG_SS_CTL_CONFIG);
      end
   end


  
endmodule 










