/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_huf_comp.vh"

module cr_huf_comp_example_top
  (
   
   is_sc_long_rd, is_sc_short_rd, lut_sa_long_data_val,
   lut_sa_long_intf, lut_sa_long_st_val, lut_sa_long_stcl_val,
   lut_sa_short_data_val, lut_sa_short_intf, lut_sa_short_st_val,
   lut_sa_short_stcl_val, st_sa_long_intf, st_sa_long_size_rdy,
   st_sa_long_table_rdy, st_sa_short_intf, st_sa_short_size_rdy,
   st_sa_short_table_rdy, long_ht1_dbg_cntr_rebuild,
   long_ht1_dbg_cntr_rebuild_failed, long_ht1_hdr_seq_id,
   long_ht2_dbg_cntr_rebuild, long_ht2_dbg_cntr_rebuild_failed,
   long_ht2_hdr_seq_id, long_hw1_hdr_seq_id, long_hw1_ph_intf,
   long_hw2_hdr_seq_id, long_hw2_ph_intf, long_is_hdr_seq_id,
   long_st1_hdr_seq_id, long_st2_hdr_seq_id,
   short_ht1_dbg_cntr_rebuild, short_ht1_dbg_cntr_rebuild_failed,
   short_ht1_hdr_seq_id, short_ht2_dbg_cntr_rebuild,
   short_ht2_dbg_cntr_rebuild_failed, short_ht2_hdr_seq_id,
   short_hw1_hdr_seq_id, short_hw1_ph_intf, short_hw2_hdr_seq_id,
   short_hw2_ph_intf, short_is_hdr_seq_id, short_st1_hdr_seq_id,
   short_st2_hdr_seq_id,
   
   clk, rst_n, sc_is_long_intf, sc_is_long_vld, sc_is_short_intf,
   sc_is_short_vld, sa_lut_long_intf, sa_lut_short_intf,
   sa_st_short_intf, sa_st_short_read_done, sa_st_long_intf,
   sa_st_long_read_done, ph_long_hw1_intf, ph_long_hw1_val,
   ph_long_hw2_intf, ph_long_hw2_val, ph_short_hw1_intf,
   ph_short_hw1_val, ph_short_hw2_intf, ph_short_hw2_val,
   hdr_long_ht1_type, hdr_long_ht2_type, hdr_long_hw1_type,
   hdr_long_hw2_type, hdr_long_is_sob, hdr_long_st1_type,
   hdr_long_st2_type, hdr_short_ht1_type, hdr_short_ht2_type,
   hdr_short_hw1_type, hdr_short_hw2_type, hdr_short_is_sob,
   hdr_short_st1_type, hdr_short_st2_type, sw_long_ht1_force_rebuild,
   sw_long_ht1_max_code_length, sw_long_ht1_max_rebuild_limit,
   sw_long_ht2_force_rebuild, sw_long_ht2_max_code_length,
   sw_long_ht2_max_rebuild_limit, sw_short_ht1_force_rebuild,
   sw_short_ht1_max_code_length, sw_short_ht1_max_rebuild_limit,
   sw_short_ht2_force_rebuild, sw_short_ht2_max_code_length,
   sw_short_ht2_max_rebuild_limit
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

   input		clk;
   input		rst_n;			
   input s_sc_is_long_intf sc_is_long_intf;	
   input		sc_is_long_vld;		
   input s_sc_is_short_intf sc_is_short_intf;	
   input [3:0]		sc_is_short_vld;	
   input s_sa_lut_intf	sa_lut_long_intf;	
   input s_sa_lut_intf	sa_lut_short_intf;	
   input s_sa_st_intf	sa_st_short_intf;	
   input		sa_st_short_read_done;	
   input s_sa_st_intf	sa_st_long_intf;	
   input		sa_st_long_read_done;	
   input s_ph_hw_intf	ph_long_hw1_intf;	
   input		ph_long_hw1_val;	
   input s_ph_hw_intf	ph_long_hw2_intf;	
   input		ph_long_hw2_val;	
   input s_ph_hw_intf	ph_short_hw1_intf;	
   input		ph_short_hw1_val;	
   input s_ph_hw_intf	ph_short_hw2_intf;	
   input		ph_short_hw2_val;	
   input		hdr_long_ht1_type;	
   input		hdr_long_ht2_type;	
   input		hdr_long_hw1_type;	
   input		hdr_long_hw2_type;	
   input		hdr_long_is_sob;	
   input [2:0]		hdr_long_st1_type;	
   input [2:0]		hdr_long_st2_type;	
   input		hdr_short_ht1_type;	
   input		hdr_short_ht2_type;	
   input		hdr_short_hw1_type;	
   input		hdr_short_hw2_type;	
   input		hdr_short_is_sob;	
   input [2:0]		hdr_short_st1_type;	
   input [2:0]		hdr_short_st2_type;	
   input		sw_long_ht1_force_rebuild;
   input [4:0]		sw_long_ht1_max_code_length;
   input [9:0]		sw_long_ht1_max_rebuild_limit;
   input		sw_long_ht2_force_rebuild;
   input [4:0]		sw_long_ht2_max_code_length;
   input [9:0]		sw_long_ht2_max_rebuild_limit;
   input		sw_short_ht1_force_rebuild;
   input [4:0]		sw_short_ht1_max_code_length;
   input [9:0]		sw_short_ht1_max_rebuild_limit;
   input		sw_short_ht2_force_rebuild;
   input [4:0]		sw_short_ht2_max_code_length;
   input [9:0]		sw_short_ht2_max_rebuild_limit;

   output		is_sc_long_rd;		
   output		is_sc_short_rd;		
   output		lut_sa_long_data_val;	
   output s_lut_sa_intf	lut_sa_long_intf;	
   output		lut_sa_long_st_val;	
   output		lut_sa_long_stcl_val;	
   output		lut_sa_short_data_val;	
   output s_lut_sa_intf	lut_sa_short_intf;	
   output		lut_sa_short_st_val;	
   output		lut_sa_short_stcl_val;	
   output s_st_sa_intf	st_sa_long_intf;	
   output		st_sa_long_size_rdy;	
   output		st_sa_long_table_rdy;	
   output s_st_sa_intf	st_sa_short_intf;	
   output		st_sa_short_size_rdy;	
   output		st_sa_short_table_rdy;	
   output		long_ht1_dbg_cntr_rebuild;
   output		long_ht1_dbg_cntr_rebuild_failed;
   output [`CREOLE_HC_SEQID_WIDTH-1:0] long_ht1_hdr_seq_id;
   output		long_ht2_dbg_cntr_rebuild;
   output		long_ht2_dbg_cntr_rebuild_failed;
   output [`CREOLE_HC_SEQID_WIDTH-1:0] long_ht2_hdr_seq_id;
   output [`CREOLE_HC_SEQID_WIDTH-1:0] long_hw1_hdr_seq_id;
   output s_hw_ph_intf	long_hw1_ph_intf;	
   output [`CREOLE_HC_SEQID_WIDTH-1:0] long_hw2_hdr_seq_id;
   output s_hw_ph_intf	long_hw2_ph_intf;	
   output [`CREOLE_HC_SEQID_WIDTH-1:0] long_is_hdr_seq_id;
   output [`CREOLE_HC_SEQID_WIDTH-1:0] long_st1_hdr_seq_id;
   output [`CREOLE_HC_SEQID_WIDTH-1:0] long_st2_hdr_seq_id;
   output		short_ht1_dbg_cntr_rebuild;
   output		short_ht1_dbg_cntr_rebuild_failed;
   output [`CREOLE_HC_SEQID_WIDTH-1:0] short_ht1_hdr_seq_id;
   output		short_ht2_dbg_cntr_rebuild;
   output		short_ht2_dbg_cntr_rebuild_failed;
   output [`CREOLE_HC_SEQID_WIDTH-1:0] short_ht2_hdr_seq_id;
   output [`CREOLE_HC_SEQID_WIDTH-1:0] short_hw1_hdr_seq_id;
   output s_hw_ph_intf	short_hw1_ph_intf;	
   output [`CREOLE_HC_SEQID_WIDTH-1:0] short_hw2_hdr_seq_id;
   output s_hw_ph_intf	short_hw2_ph_intf;	
   output [`CREOLE_HC_SEQID_WIDTH-1:0] short_is_hdr_seq_id;
   output [`CREOLE_HC_SEQID_WIDTH-1:0] short_st1_hdr_seq_id;
   output [`CREOLE_HC_SEQID_WIDTH-1:0] short_st2_hdr_seq_id;
 
  `ifdef THESE_AUTOS_SHOULD_BE_EMPTY
   
   
  `endif

 
 
 s_ht_hw_long_intf	ht1_hw1_long_intf;	
 s_ht_hw_short_intf	ht1_hw1_short_intf;	
 s_ht_hw_long_intf	ht2_hw2_long_intf;	
 s_ht_hw_short_intf	ht2_hw2_short_intf;	
 wire			ht_is_long_not_ready;	
 wire			ht_is_short_not_ready;	
 s_hw_ht_long_intf	hw1_ht1_long_intf;	
 wire			hw1_ht1_long_not_ready;	
 s_hw_ht_short_intf	hw1_ht1_short_intf;	
 wire			hw1_ht1_short_not_ready;
 s_hw_long_hw_short_intf hw1_long_hw_short_intf;
 wire [1:0]		hw1_long_hw_short_val;	
 s_hw_lut_intf		hw1_lut1_long_intf;	
 wire			hw1_lut1_long_wr;	
 s_hw_lut_intf		hw1_lut1_short_intf;	
 wire			hw1_lut1_short_wr;	
 s_hw_short_hw_long_intf hw1_short_hw_long_intf;
 wire			hw1_short_hw_long_ready;
 s_hw_st_intf		hw1_st1_long_intf;	
 wire [1:0]		hw1_st1_long_val;	
 s_hw_st_intf		hw1_st1_short_intf;	
 wire [1:0]		hw1_st1_short_val;	
 s_hw_ht_long_intf	hw2_ht2_long_intf;	
 wire			hw2_ht2_long_not_ready;	
 s_hw_ht_short_intf	hw2_ht2_short_intf;	
 wire			hw2_ht2_short_not_ready;
 s_hw_long_hw_short_intf hw2_long_hw_short_intf;
 wire [1:0]		hw2_long_hw_short_val;	
 s_hw_lut_intf		hw2_lut2_long_intf;	
 wire			hw2_lut2_long_wr;	
 s_hw_lut_intf		hw2_lut2_short_intf;	
 wire			hw2_lut2_short_wr;	
 s_hw_short_hw_long_intf hw2_short_hw_long_intf;
 wire			hw2_short_hw_long_ready;
 s_hw_st_intf		hw2_st2_long_intf;	
 wire [1:0]		hw2_st2_long_val;	
 s_hw_st_intf		hw2_st2_short_intf;	
 wire [1:0]		hw2_st2_short_val;	
 s_is_ht_long_intf	is_ht_long_intf;	
 s_is_ht_short_intf	is_ht_short_intf;	
 wire			lut1_hw1_long_full;	
 wire			lut1_hw1_short_full;	
 wire			lut1_st1_long_full;	
 wire			lut1_st1_short_full;	
 wire			lut2_hw2_long_full;	
 wire			lut2_hw2_short_full;	
 wire			lut2_st2_long_full;	
 wire			lut2_st2_short_full;	
 wire			st1_hw1_long_not_ready;	
 wire			st1_hw1_short_not_ready;
 s_st_lut_intf		st1_lut1_long_intf;	
 wire			st1_lut1_long_wr;	
 s_st_lut_intf		st1_lut1_short_intf;	
 wire			st1_lut1_short_wr;	
 wire			st2_hw2_long_not_ready;	
 wire			st2_hw2_short_not_ready;
 s_st_lut_intf		st2_lut2_long_intf;	
 wire			st2_lut2_long_wr;	
 s_st_lut_intf		st2_lut2_short_intf;	
 wire			st2_lut2_short_wr;	
 
 
 
 

   


   
   
 
 
 

  
 cr_huf_comp_is_short is_short(
			       
			       .is_sc_short_rd	(is_sc_short_rd),
			       .is_ht_short_intf(is_ht_short_intf),
			       .short_is_hdr_seq_id(short_is_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
			       
			       .clk		(clk),
			       .rst_n		(rst_n),
			       .sc_is_short_vld	(sc_is_short_vld[3:0]),
			       .sc_is_short_intf(sc_is_short_intf),
			       .ht_is_short_not_ready(ht_is_short_not_ready),
			       .hdr_short_is_sob(hdr_short_is_sob));
  
 cr_huf_comp_is_long is_long(
			     
			     .is_sc_long_rd	(is_sc_long_rd),
			     .is_ht_long_intf	(is_ht_long_intf),
			     .long_is_hdr_seq_id(long_is_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
			     
			     .clk		(clk),
			     .rst_n		(rst_n),
			     .sc_is_long_vld	(sc_is_long_vld),
			     .sc_is_long_intf	(sc_is_long_intf),
			     .ht_is_long_not_ready(ht_is_long_not_ready),
			     .hdr_long_is_sob	(hdr_long_is_sob)); 
   
 cr_huf_comp_htb_short tb_short(
				
				.ht_is_short_not_ready(ht_is_short_not_ready),
				.ht1_hw1_short_intf(ht1_hw1_short_intf),
				.ht2_hw2_short_intf(ht2_hw2_short_intf),
				.short_ht1_hdr_seq_id(short_ht1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
				.short_ht2_hdr_seq_id(short_ht2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
				.short_ht1_dbg_cntr_rebuild(short_ht1_dbg_cntr_rebuild),
				.short_ht1_dbg_cntr_rebuild_failed(short_ht1_dbg_cntr_rebuild_failed),
				.short_ht2_dbg_cntr_rebuild(short_ht2_dbg_cntr_rebuild),
				.short_ht2_dbg_cntr_rebuild_failed(short_ht2_dbg_cntr_rebuild_failed),
				
				.clk		(clk),
				.rst_n		(rst_n),
				.is_ht_short_intf(is_ht_short_intf),
				.hw1_ht1_short_not_ready(hw1_ht1_short_not_ready),
				.hw1_ht1_short_intf(hw1_ht1_short_intf),
				.hw2_ht2_short_not_ready(hw2_ht2_short_not_ready),
				.hw2_ht2_short_intf(hw2_ht2_short_intf),
				.hdr_short_ht1_type(hdr_short_ht1_type),
				.hdr_short_ht2_type(hdr_short_ht2_type),
				.sw_short_ht1_max_code_length(sw_short_ht1_max_code_length[4:0]),
				.sw_short_ht1_max_rebuild_limit(sw_short_ht1_max_rebuild_limit[9:0]),
				.sw_short_ht1_force_rebuild(sw_short_ht1_force_rebuild),
				.sw_short_ht2_max_code_length(sw_short_ht2_max_code_length[4:0]),
				.sw_short_ht2_max_rebuild_limit(sw_short_ht2_max_rebuild_limit[9:0]),
				.sw_short_ht2_force_rebuild(sw_short_ht2_force_rebuild));
 
 cr_huf_comp_htb_long tb_long(
			      
			      .ht_is_long_not_ready(ht_is_long_not_ready),
			      .ht1_hw1_long_intf(ht1_hw1_long_intf),
			      .ht2_hw2_long_intf(ht2_hw2_long_intf),
			      .long_ht1_hdr_seq_id(long_ht1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
			      .long_ht2_hdr_seq_id(long_ht2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
			      .long_ht1_dbg_cntr_rebuild(long_ht1_dbg_cntr_rebuild),
			      .long_ht1_dbg_cntr_rebuild_failed(long_ht1_dbg_cntr_rebuild_failed),
			      .long_ht2_dbg_cntr_rebuild(long_ht2_dbg_cntr_rebuild),
			      .long_ht2_dbg_cntr_rebuild_failed(long_ht2_dbg_cntr_rebuild_failed),
			      
			      .clk		(clk),
			      .rst_n		(rst_n),
			      .is_ht_long_intf	(is_ht_long_intf),
			      .hw1_ht1_long_not_ready(hw1_ht1_long_not_ready),
			      .hw1_ht1_long_intf(hw1_ht1_long_intf),
			      .hw2_ht2_long_not_ready(hw2_ht2_long_not_ready),
			      .hw2_ht2_long_intf(hw2_ht2_long_intf),
			      .hdr_long_ht1_type(hdr_long_ht1_type),
			      .hdr_long_ht2_type(hdr_long_ht2_type),
			      .sw_long_ht1_max_code_length(sw_long_ht1_max_code_length[4:0]),
			      .sw_long_ht1_max_rebuild_limit(sw_long_ht1_max_rebuild_limit[9:0]),
			      .sw_long_ht1_force_rebuild(sw_long_ht1_force_rebuild),
			      .sw_long_ht2_max_code_length(sw_long_ht2_max_code_length[4:0]),
			      .sw_long_ht2_max_rebuild_limit(sw_long_ht2_max_rebuild_limit[9:0]),
			      .sw_long_ht2_force_rebuild(sw_long_ht2_force_rebuild));
 
 cr_huf_comp_htw_short tw_short(
				
				.hw1_ht1_short_not_ready(hw1_ht1_short_not_ready),
				.hw1_ht1_short_intf(hw1_ht1_short_intf),
				.hw2_ht2_short_not_ready(hw2_ht2_short_not_ready),
				.hw2_ht2_short_intf(hw2_ht2_short_intf),
				.hw1_short_hw_long_ready(hw1_short_hw_long_ready),
				.hw1_short_hw_long_intf(hw1_short_hw_long_intf),
				.hw2_short_hw_long_ready(hw2_short_hw_long_ready),
				.hw2_short_hw_long_intf(hw2_short_hw_long_intf),
				.hw1_lut1_short_wr(hw1_lut1_short_wr),
				.hw1_lut1_short_intf(hw1_lut1_short_intf),
				.hw2_lut2_short_wr(hw2_lut2_short_wr),
				.hw2_lut2_short_intf(hw2_lut2_short_intf),
				.short_hw1_ph_intf(short_hw1_ph_intf),
				.short_hw2_ph_intf(short_hw2_ph_intf),
				.hw1_st1_short_val(hw1_st1_short_val[1:0]),
				.hw1_st1_short_intf(hw1_st1_short_intf),
				.hw2_st2_short_val(hw2_st2_short_val[1:0]),
				.hw2_st2_short_intf(hw2_st2_short_intf),
				.short_hw1_hdr_seq_id(short_hw1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
				.short_hw2_hdr_seq_id(short_hw2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
				
				.clk		(clk),
				.rst_n		(rst_n),
				.ht1_hw1_short_intf(ht1_hw1_short_intf),
				.ht2_hw2_short_intf(ht2_hw2_short_intf),
				.hw1_long_hw_short_val(hw1_long_hw_short_val[1:0]),
				.hw1_long_hw_short_intf(hw1_long_hw_short_intf),
				.hw2_long_hw_short_val(hw2_long_hw_short_val[1:0]),
				.hw2_long_hw_short_intf(hw2_long_hw_short_intf),
				.lut1_hw1_short_full(lut1_hw1_short_full),
				.lut2_hw2_short_full(lut2_hw2_short_full),
				.ph_short_hw1_val(ph_short_hw1_val),
				.ph_short_hw1_intf(ph_short_hw1_intf),
				.ph_short_hw2_val(ph_short_hw2_val),
				.ph_short_hw2_intf(ph_short_hw2_intf),
				.st1_hw1_short_not_ready(st1_hw1_short_not_ready),
				.st2_hw2_short_not_ready(st2_hw2_short_not_ready),
				.hdr_short_hw1_type(hdr_short_hw1_type),
				.hdr_short_hw2_type(hdr_short_hw2_type));
 
 cr_huf_comp_htw_long tw_long(
			      
			      .hw1_ht1_long_not_ready(hw1_ht1_long_not_ready),
			      .hw1_ht1_long_intf(hw1_ht1_long_intf),
			      .hw2_ht2_long_not_ready(hw2_ht2_long_not_ready),
			      .hw2_ht2_long_intf(hw2_ht2_long_intf),
			      .hw1_long_hw_short_val(hw1_long_hw_short_val[1:0]),
			      .hw1_long_hw_short_intf(hw1_long_hw_short_intf),
			      .hw2_long_hw_short_val(hw2_long_hw_short_val[1:0]),
			      .hw2_long_hw_short_intf(hw2_long_hw_short_intf),
			      .hw1_lut1_long_wr	(hw1_lut1_long_wr),
			      .hw1_lut1_long_intf(hw1_lut1_long_intf),
			      .hw2_lut2_long_wr	(hw2_lut2_long_wr),
			      .hw2_lut2_long_intf(hw2_lut2_long_intf),
			      .long_hw1_ph_intf	(long_hw1_ph_intf),
			      .long_hw2_ph_intf	(long_hw2_ph_intf),
			      .hw1_st1_long_val	(hw1_st1_long_val[1:0]),
			      .hw1_st1_long_intf(hw1_st1_long_intf),
			      .hw2_st2_long_val	(hw2_st2_long_val[1:0]),
			      .hw2_st2_long_intf(hw2_st2_long_intf),
			      .long_hw1_hdr_seq_id(long_hw1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
			      .long_hw2_hdr_seq_id(long_hw2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
			      
			      .clk		(clk),
			      .rst_n		(rst_n),
			      .ht1_hw1_long_intf(ht1_hw1_long_intf),
			      .ht2_hw2_long_intf(ht2_hw2_long_intf),
			      .hw1_short_hw_long_ready(hw1_short_hw_long_ready),
			      .hw1_short_hw_long_intf(hw1_short_hw_long_intf),
			      .hw2_short_hw_long_ready(hw2_short_hw_long_ready),
			      .hw2_short_hw_long_intf(hw2_short_hw_long_intf),
			      .lut1_hw1_long_full(lut1_hw1_long_full),
			      .lut2_hw2_long_full(lut2_hw2_long_full),
			      .ph_long_hw1_val	(ph_long_hw1_val),
			      .ph_long_hw1_intf	(ph_long_hw1_intf),
			      .ph_long_hw2_val	(ph_long_hw2_val),
			      .ph_long_hw2_intf	(ph_long_hw2_intf),
			      .st1_hw1_long_not_ready(st1_hw1_long_not_ready),
			      .st2_hw2_long_not_ready(st2_hw2_long_not_ready),
			      .hdr_long_hw1_type(hdr_long_hw1_type),
			      .hdr_long_hw2_type(hdr_long_hw2_type));
 
 cr_huf_comp_st_short st_short(
			       
			       .st1_hw1_short_not_ready(st1_hw1_short_not_ready),
			       .st2_hw2_short_not_ready(st2_hw2_short_not_ready),
			       .st1_lut1_short_wr(st1_lut1_short_wr),
			       .st1_lut1_short_intf(st1_lut1_short_intf),
			       .st2_lut2_short_wr(st2_lut2_short_wr),
			       .st2_lut2_short_intf(st2_lut2_short_intf),
			       .st_sa_short_size_rdy(st_sa_short_size_rdy),
			       .st_sa_short_table_rdy(st_sa_short_table_rdy),
			       .st_sa_short_intf(st_sa_short_intf),
			       .short_st1_hdr_seq_id(short_st1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
			       .short_st2_hdr_seq_id(short_st2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
			       
			       .clk		(clk),
			       .rst_n		(rst_n),
			       .hw1_st1_short_val(hw1_st1_short_val[1:0]),
			       .hw1_st1_short_intf(hw1_st1_short_intf),
			       .hw2_st2_short_val(hw2_st2_short_val[1:0]),
			       .hw2_st2_short_intf(hw2_st2_short_intf),
			       .lut1_st1_short_full(lut1_st1_short_full),
			       .lut2_st2_short_full(lut2_st2_short_full),
			       .sa_st_short_read_done(sa_st_short_read_done),
			       .sa_st_short_intf(sa_st_short_intf),
			       .hdr_short_st1_type(hdr_short_st1_type[2:0]),
			       .hdr_short_st2_type(hdr_short_st2_type[2:0]));
 
 cr_huf_comp_st_long st_long(
			     
			     .st1_hw1_long_not_ready(st1_hw1_long_not_ready),
			     .st2_hw2_long_not_ready(st2_hw2_long_not_ready),
			     .st1_lut1_long_wr	(st1_lut1_long_wr),
			     .st1_lut1_long_intf(st1_lut1_long_intf),
			     .st2_lut2_long_wr	(st2_lut2_long_wr),
			     .st2_lut2_long_intf(st2_lut2_long_intf),
			     .st_sa_long_size_rdy(st_sa_long_size_rdy),
			     .st_sa_long_table_rdy(st_sa_long_table_rdy),
			     .st_sa_long_intf	(st_sa_long_intf),
			     .long_st1_hdr_seq_id(long_st1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
			     .long_st2_hdr_seq_id(long_st2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
			     
			     .clk		(clk),
			     .rst_n		(rst_n),
			     .hw1_st1_long_val	(hw1_st1_long_val[1:0]),
			     .hw1_st1_long_intf	(hw1_st1_long_intf),
			     .hw2_st2_long_val	(hw2_st2_long_val[1:0]),
			     .hw2_st2_long_intf	(hw2_st2_long_intf),
			     .lut1_st1_long_full(lut1_st1_long_full),
			     .lut2_st2_long_full(lut2_st2_long_full),
			     .sa_st_long_read_done(sa_st_long_read_done),
			     .sa_st_long_intf	(sa_st_long_intf),
			     .hdr_long_st1_type	(hdr_long_st1_type[2:0]),
			     .hdr_long_st2_type	(hdr_long_st2_type[2:0]));
 
 cr_huf_comp_lut_short lut_short(
				 
				 .lut1_hw1_short_full	(lut1_hw1_short_full),
				 .lut2_hw2_short_full	(lut2_hw2_short_full),
				 .lut1_st1_short_full	(lut1_st1_short_full),
				 .lut2_st2_short_full	(lut2_st2_short_full),
				 .lut_sa_short_stcl_val	(lut_sa_short_stcl_val),
				 .lut_sa_short_st_val	(lut_sa_short_st_val),
				 .lut_sa_short_data_val	(lut_sa_short_data_val),
				 .lut_sa_short_intf	(lut_sa_short_intf),
				 
				 .clk			(clk),
				 .rst_n			(rst_n),
				 .hw1_lut1_short_wr	(hw1_lut1_short_wr),
				 .hw1_lut1_short_intf	(hw1_lut1_short_intf),
				 .hw2_lut2_short_wr	(hw2_lut2_short_wr),
				 .hw2_lut2_short_intf	(hw2_lut2_short_intf),
				 .st1_lut1_short_wr	(st1_lut1_short_wr),
				 .st1_lut1_short_intf	(st1_lut1_short_intf),
				 .st2_lut2_short_wr	(st2_lut2_short_wr),
				 .st2_lut2_short_intf	(st2_lut2_short_intf),
				 .sa_lut_short_intf	(sa_lut_short_intf));
 
 cr_huf_comp_lut_long lut_long(
			       
			       .lut1_hw1_long_full(lut1_hw1_long_full),
			       .lut2_hw2_long_full(lut2_hw2_long_full),
			       .lut1_st1_long_full(lut1_st1_long_full),
			       .lut2_st2_long_full(lut2_st2_long_full),
			       .lut_sa_long_stcl_val(lut_sa_long_stcl_val),
			       .lut_sa_long_st_val(lut_sa_long_st_val),
			       .lut_sa_long_data_val(lut_sa_long_data_val),
			       .lut_sa_long_intf(lut_sa_long_intf),
			       
			       .clk		(clk),
			       .rst_n		(rst_n),
			       .hw1_lut1_long_wr(hw1_lut1_long_wr),
			       .hw1_lut1_long_intf(hw1_lut1_long_intf),
			       .hw2_lut2_long_wr(hw2_lut2_long_wr),
			       .hw2_lut2_long_intf(hw2_lut2_long_intf),
			       .st1_lut1_long_wr(st1_lut1_long_wr),
			       .st1_lut1_long_intf(st1_lut1_long_intf),
			       .st2_lut2_long_wr(st2_lut2_long_wr),
			       .st2_lut2_long_intf(st2_lut2_long_intf),
			       .sa_lut_long_intf(sa_lut_long_intf));
   
endmodule 








