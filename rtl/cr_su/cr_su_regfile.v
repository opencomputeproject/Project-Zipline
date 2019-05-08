/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_su.vh"
 
module cr_su_regfile 

   (
   
   rbus_ring_o, dbg_config,
   
   rst_n, clk, rbus_ring_i, cfg_start_addr, cfg_end_addr, hb_sup,
   su_hb, su_agg_cnt_stb
   );

`include "cr_structs.sv"   
  import cr_suPKG::*;
  import cr_su_regfilePKG::*;
  
  
  output rbus_ring_t       rbus_ring_o;
  
  output dbg_t             dbg_config;
  
  input                    rst_n;
  input                    clk;
  input  rbus_ring_t       rbus_ring_i;

   input [`N_RBUS_ADDR_BITS-1:0] cfg_start_addr;
   input [`N_RBUS_ADDR_BITS-1:0] cfg_end_addr;
   
  
  input hb_sup_t           hb_sup;
  input [107:0]            su_hb[7:0];

  
  input                    su_agg_cnt_stb;
  
  
  
  logic			locl_ack;		
  logic			locl_err_ack;		
  logic [31:0]		locl_rd_data;		
  logic			locl_rd_strb;		
  logic			locl_wr_strb;		
  logic			rd_stb;			
  logic [`CR_SU_DECL]	reg_addr;		
  logic			wr_stb;			
  
  
  logic [`CR_SU_DECL]                  locl_addr;
  logic [`N_RBUS_DATA_BITS-1:0]        locl_wr_data;
  spare_t                              spare; 
  agg_su_counter_t                     agg_su_count[1];

  logic [23:0]                         history_buffer_part0_0;
  logic [23:0]                         history_buffer_part1_0;
  logic [31:0]                         history_buffer_part2_0;
  logic [27:0]                         history_buffer_part3_0;

  logic [23:0]                         history_buffer_part0_1;
  logic [23:0]                         history_buffer_part1_1;
  logic [31:0]                         history_buffer_part2_1;
  logic [27:0]                         history_buffer_part3_1;

  logic [23:0]                         history_buffer_part0_2;
  logic [23:0]                         history_buffer_part1_2;
  logic [31:0]                         history_buffer_part2_2;
  logic [27:0]                         history_buffer_part3_2;

  logic [23:0]                         history_buffer_part0_3;
  logic [23:0]                         history_buffer_part1_3;
  logic [31:0]                         history_buffer_part2_3;
  logic [27:0]                         history_buffer_part3_3;

  logic [23:0]                         history_buffer_part0_4;
  logic [23:0]                         history_buffer_part1_4;
  logic [31:0]                         history_buffer_part2_4;
  logic [27:0]                         history_buffer_part3_4;

  logic [23:0]                         history_buffer_part0_5;
  logic [23:0]                         history_buffer_part1_5;
  logic [31:0]                         history_buffer_part2_5;
  logic [27:0]                         history_buffer_part3_5;

  logic [23:0]                         history_buffer_part0_6;
  logic [23:0]                         history_buffer_part1_6;
  logic [31:0]                         history_buffer_part2_6;
  logic [27:0]                         history_buffer_part3_6;

  logic [23:0]                         history_buffer_part0_7;
  logic [23:0]                         history_buffer_part1_7;
  logic [31:0]                         history_buffer_part2_7;
  logic [27:0]                         history_buffer_part3_7;


  assign history_buffer_part0_0 = su_hb[0][23:0];
  assign history_buffer_part1_0 = su_hb[0][47:24];
  assign history_buffer_part2_0 = su_hb[0][79:48];
  assign history_buffer_part3_0 = su_hb[0][107:80];
  
  assign history_buffer_part0_1 = su_hb[1][23:0]; 
  assign history_buffer_part1_1 = su_hb[1][47:24];
  assign history_buffer_part2_1 = su_hb[1][79:48];
  assign history_buffer_part3_1 = su_hb[1][107:80];
  
  assign history_buffer_part0_2 = su_hb[2][23:0]; 
  assign history_buffer_part1_2 = su_hb[2][47:24];
  assign history_buffer_part2_2 = su_hb[2][79:48];
  assign history_buffer_part3_2 = su_hb[2][107:80];
  
  assign history_buffer_part0_3 = su_hb[3][23:0]; 
  assign history_buffer_part1_3 = su_hb[3][47:24];
  assign history_buffer_part2_3 = su_hb[3][79:48];
  assign history_buffer_part3_3 = su_hb[3][107:80];
  
  assign history_buffer_part0_4 = su_hb[4][23:0]; 
  assign history_buffer_part1_4 = su_hb[4][47:24];
  assign history_buffer_part2_4 = su_hb[4][79:48];
  assign history_buffer_part3_4 = su_hb[4][107:80];
  
  assign history_buffer_part0_5 = su_hb[5][23:0]; 
  assign history_buffer_part1_5 = su_hb[5][47:24];
  assign history_buffer_part2_5 = su_hb[5][79:48];
  assign history_buffer_part3_5 = su_hb[5][107:80];
  
  assign history_buffer_part0_6 = su_hb[6][23:0]; 
  assign history_buffer_part1_6 = su_hb[6][47:24];
  assign history_buffer_part2_6 = su_hb[6][79:48];
  assign history_buffer_part3_6 = su_hb[6][107:80];
  
  assign history_buffer_part0_7 = su_hb[7][23:0]; 
  assign history_buffer_part1_7 = su_hb[7][47:24];
  assign history_buffer_part2_7 = su_hb[7][79:48];
  assign history_buffer_part3_7 = su_hb[7][107:80];
  
   
   

   
   revid_t revid_wire;
     
   CR_TIE_CELL revid_wire_0 (.ob(revid_wire.f.revid[0]), .o());
   CR_TIE_CELL revid_wire_1 (.ob(revid_wire.f.revid[1]), .o());
   CR_TIE_CELL revid_wire_2 (.ob(revid_wire.f.revid[2]), .o());
   CR_TIE_CELL revid_wire_3 (.ob(revid_wire.f.revid[3]), .o());
   CR_TIE_CELL revid_wire_4 (.ob(revid_wire.f.revid[4]), .o());
   CR_TIE_CELL revid_wire_5 (.ob(revid_wire.f.revid[5]), .o());
   CR_TIE_CELL revid_wire_6 (.ob(revid_wire.f.revid[6]), .o());
   CR_TIE_CELL revid_wire_7 (.ob(revid_wire.f.revid[7]), .o());
   
   
   

   
   
   cr_su_regs u_cr_su_regs (
			    
			    .o_rd_data		(locl_rd_data[31:0]), 
			    .o_ack		(locl_ack),	 
			    .o_err_ack		(locl_err_ack),	 
			    .o_spare_config	(spare),	 
			    .o_dbg_config	(dbg_config[`CR_SU_C_DBG_T_DECL]), 
			    .o_reg_written	(wr_stb),	 
			    .o_reg_read		(rd_stb),	 
			    .o_reg_wr_data	(),		 
			    .o_reg_addr		(reg_addr[`CR_SU_DECL]), 
			    
			    .clk		(clk),
			    .i_reset_		(rst_n),	 
			    .i_sw_init		(1'd0),		 
			    .i_addr		(locl_addr),	 
			    .i_wr_strb		(locl_wr_strb),	 
			    .i_wr_data		(locl_wr_data),	 
			    .i_rd_strb		(locl_rd_strb),	 
			    .i_revision_config	(revid_wire),	 
			    .i_spare_config	(spare),	 
			    .i_hb_sup		(hb_sup),	 
			    .i_history_buffer_part0_0(history_buffer_part0_0), 
			    .i_history_buffer_part1_0(history_buffer_part1_0), 
			    .i_history_buffer_part2_0(history_buffer_part2_0), 
			    .i_history_buffer_part3_0(history_buffer_part3_0), 
			    .i_history_buffer_part0_1(history_buffer_part0_1), 
			    .i_history_buffer_part1_1(history_buffer_part1_1), 
			    .i_history_buffer_part2_1(history_buffer_part2_1), 
			    .i_history_buffer_part3_1(history_buffer_part3_1), 
			    .i_history_buffer_part0_2(history_buffer_part0_2), 
			    .i_history_buffer_part1_2(history_buffer_part1_2), 
			    .i_history_buffer_part2_2(history_buffer_part2_2), 
			    .i_history_buffer_part3_2(history_buffer_part3_2), 
			    .i_history_buffer_part0_3(history_buffer_part0_3), 
			    .i_history_buffer_part1_3(history_buffer_part1_3), 
			    .i_history_buffer_part2_3(history_buffer_part2_3), 
			    .i_history_buffer_part3_3(history_buffer_part3_3), 
			    .i_history_buffer_part0_4(history_buffer_part0_4), 
			    .i_history_buffer_part1_4(history_buffer_part1_4), 
			    .i_history_buffer_part2_4(history_buffer_part2_4), 
			    .i_history_buffer_part3_4(history_buffer_part3_4), 
			    .i_history_buffer_part0_5(history_buffer_part0_5), 
			    .i_history_buffer_part1_5(history_buffer_part1_5), 
			    .i_history_buffer_part2_5(history_buffer_part2_5), 
			    .i_history_buffer_part3_5(history_buffer_part3_5), 
			    .i_history_buffer_part0_6(history_buffer_part0_6), 
			    .i_history_buffer_part1_6(history_buffer_part1_6), 
			    .i_history_buffer_part2_6(history_buffer_part2_6), 
			    .i_history_buffer_part3_6(history_buffer_part3_6), 
			    .i_history_buffer_part0_7(history_buffer_part0_7), 
			    .i_history_buffer_part1_7(history_buffer_part1_7), 
			    .i_history_buffer_part2_7(history_buffer_part2_7), 
			    .i_history_buffer_part3_7(history_buffer_part3_7), 
			    .i_agg_su_count_a	(agg_su_count[0].f.count)); 

   
   
   
   nx_rbus_ring 
     #(
       .N_RBUS_ADDR_BITS (`N_RBUS_ADDR_BITS),             
       .N_LOCL_ADDR_BITS (`CR_SU_WIDTH),           
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

   

  nx_event_counter_array
  #(
    
    .BASE_ADDRESS			(`CR_SU_AGG_SU_COUNT_A), 
    .ALIGNMENT				(2),			 
    .N_ADDR_BITS			(`CR_SU_WIDTH),		 
    .N_COUNTERS				(1),			 
    .N_COUNT_BY_BITS			(1),			 
    .N_COUNTER_BITS			(`CR_SU_C_AGG_SU_COUNTER_T_WIDTH)) 
  u_agg_su_cntr
  (
   
   .counter_a				(agg_su_count),		 
   
   .clk					(clk),
   .rst_n				(rst_n),
   .reg_addr				(reg_addr[`BIT_VEC((`CR_SU_WIDTH))]),
   .counter_config			(1'b0),			 
   .rd_stb				(rd_stb),
   .wr_stb				(1'b0),			 
   .reg_data				(`CR_SU_C_AGG_SU_COUNTER_T_WIDTH'd0), 
   .count_stb				(su_agg_cnt_stb),	 
   .count_by				(1'b1),			 
   .count_id				(1'b0));			 

   
endmodule 










