/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/








module cr_huf_comp_encoder_engine
  #(parameter
    SINGLE_PIPE          = 0,
    FPGA_MOD             = 0 
   )
  (
   
   hw1_lut1_long_intf, hw1_lut1_long_wr, hw1_lut1_short_intf,
   hw1_lut1_short_wr, hw2_lut2_long_intf, hw2_lut2_long_wr,
   hw2_lut2_short_intf, hw2_lut2_short_wr, is_sc_long_rd,
   is_sc_short_rd, long_bl_ism_data, long_bl_ism_vld,
   long_ht_dbg_cntr_rebuild, long_ht_dbg_cntr_rebuild_failed,
   long_ht_dbg_cntr_rebuild_cnt, long_ht_dbg_cntr_rebuild_failed_cnt,
   long_ht1_hdr_seq_id, long_ht2_hdr_seq_id, long_hw1_hdr_seq_id,
   long_hw1_ph_intf, long_hw2_hdr_seq_id, long_hw2_ph_intf,
   long_st_dbg_cntr_rebuild, long_st_dbg_cntr_rebuild_failed,
   long_st_dbg_cntr_rebuild_cnt, long_st_dbg_cntr_rebuild_failed_cnt,
   short_bl_ism_data, short_bl_ism_vld, short_ht_dbg_cntr_rebuild,
   short_ht_dbg_cntr_rebuild_failed, short_ht_dbg_cntr_rebuild_cnt,
   short_ht_dbg_cntr_rebuild_failed_cnt, short_ht1_hdr_seq_id,
   short_ht2_hdr_seq_id, short_hw1_hdr_seq_id, short_hw1_ph_intf,
   short_hw2_hdr_seq_id, short_hw2_ph_intf, short_st_dbg_cntr_rebuild,
   short_st_dbg_cntr_rebuild_failed, short_st_dbg_cntr_rebuild_cnt,
   short_st_dbg_cntr_rebuild_failed_cnt, st1_lut1_long_intf,
   st1_lut1_long_wr, st1_lut1_short_intf, st1_lut1_short_wr,
   st1_sa_long_intf, st1_sa_long_size_rdy_pre,
   st1_sa_long_table_rdy_pre, st1_sa_short_intf,
   st1_sa_short_size_rdy_pre, st1_sa_short_table_rdy_pre,
   st2_lut2_long_intf, st2_lut2_long_wr, st2_lut2_short_intf,
   st2_lut2_short_wr, st2_sa_long_intf, st2_sa_long_size_rdy_pre,
   st2_sa_long_table_rdy_pre, st2_sa_short_intf,
   st2_sa_short_size_rdy_pre, st2_sa_short_table_rdy_pre,
   st_long_bl_ism_data, st_long_bl_ism_vld, st_short_bl_ism_data,
   st_short_bl_ism_vld, ee_ecc_error, ee_bimc_odat, ee_bimc_osync,
   
   clk, hdr_long_ht1_type, hdr_long_ht2_type, hdr_long_hw1_type,
   hdr_long_hw2_type, hdr_short_ht1_type, hdr_short_ht2_type,
   hdr_short_hw1_type, hdr_short_hw2_type, long_ism_rdy,
   lut1_hw1_long_full, lut1_hw1_short_full, lut1_st1_long_full,
   lut1_st1_short_full, lut2_hw2_long_full, lut2_hw2_short_full,
   lut2_st2_long_full, lut2_st2_short_full, mrdten, ph_long_hw1_intf,
   ph_long_hw1_val, ph_long_hw2_intf, ph_long_hw2_val,
   ph_short_hw1_intf, ph_short_hw1_val, ph_short_hw2_intf,
   ph_short_hw2_val, rst_n, sa_st1_long_read_done,
   sa_st1_short_read_done, sa_st2_long_read_done,
   sa_st2_short_read_done, sc_is_long_intf, sc_is_long_vld,
   sc_is_short_intf, sc_is_short_vld, short_ism_rdy, st_long_ism_rdy,
   st_short_ism_rdy, sw_disable_sub_pipe, lvm, mlvm, ovstb,
   ee_bimc_rst_n, ee_bimc_isync, ee_bimc_idat, sw_short_ht_config,
   sw_long_ht_config, sw_st_short_ht_config, sw_st_long_ht_config,
   sw_debug_control, sw_force_block_stall
   );
   
`include "cr_structs.sv"
   
   import cr_huf_compPKG::*;
   import cr_huf_comp_regsPKG::*;

   input logic		clk;			
   input s_seq_id_type_intf hdr_long_ht1_type;
   input s_seq_id_type_intf hdr_long_ht2_type;
   input s_seq_id_type_intf hdr_long_hw1_type;
   input s_seq_id_type_intf hdr_long_hw2_type;
   input s_seq_id_type_intf hdr_short_ht1_type;
   input s_seq_id_type_intf hdr_short_ht2_type;
   input s_seq_id_type_intf hdr_short_hw1_type;
   input s_seq_id_type_intf hdr_short_hw2_type;
   input logic		long_ism_rdy;		
   input logic		lut1_hw1_long_full;	
   input logic		lut1_hw1_short_full;	
   input logic		lut1_st1_long_full;	
   input logic		lut1_st1_short_full;	
   input logic		lut2_hw2_long_full;	
   input logic		lut2_hw2_short_full;	
   input logic		lut2_st2_long_full;	
   input logic		lut2_st2_short_full;	
   input logic		mrdten;			
   input s_ph_hw_intf	ph_long_hw1_intf;	
   input logic		ph_long_hw1_val;	
   input s_ph_hw_intf	ph_long_hw2_intf;	
   input logic		ph_long_hw2_val;	
   input s_ph_hw_intf	ph_short_hw1_intf;	
   input logic		ph_short_hw1_val;	
   input s_ph_hw_intf	ph_short_hw2_intf;	
   input logic		ph_short_hw2_val;	
   input logic		rst_n;			
   input logic		sa_st1_long_read_done;	
   input logic		sa_st1_short_read_done;	
   input logic		sa_st2_long_read_done;	
   input logic		sa_st2_short_read_done;	
   input s_sc_is_long_intf sc_is_long_intf;	
   input logic		sc_is_long_vld;		
   input s_sc_is_short_intf sc_is_short_intf;	
   input logic [3:0]	sc_is_short_vld;	
   input logic		short_ism_rdy;		
   input logic		st_long_ism_rdy;	
   input logic		st_short_ism_rdy;	
   input henc_disable_sub_pipe_t sw_disable_sub_pipe;

   output s_hw_lut_intf	hw1_lut1_long_intf;	
   output logic		hw1_lut1_long_wr;	
   output s_hw_lut_intf	hw1_lut1_short_intf;	
   output logic		hw1_lut1_short_wr;	
   output s_hw_lut_intf	hw2_lut2_long_intf;	
   output logic		hw2_lut2_long_wr;	
   output s_hw_lut_intf	hw2_lut2_short_intf;	
   output logic		hw2_lut2_short_wr;	
   output logic		is_sc_long_rd;		
   output logic		is_sc_short_rd;		
   output lng_bl_t	long_bl_ism_data;	
   output logic		long_bl_ism_vld;	
   output logic		long_ht_dbg_cntr_rebuild;
   output logic		long_ht_dbg_cntr_rebuild_failed;
   output logic	[1:0]	long_ht_dbg_cntr_rebuild_cnt;
   output logic	[1:0]	long_ht_dbg_cntr_rebuild_failed_cnt;
   output logic [`CREOLE_HC_SEQID_WIDTH-1:0] long_ht1_hdr_seq_id;
   output logic [`CREOLE_HC_SEQID_WIDTH-1:0] long_ht2_hdr_seq_id;
   output logic [`CREOLE_HC_SEQID_WIDTH-1:0] long_hw1_hdr_seq_id;
   output s_hw_ph_intf	long_hw1_ph_intf;	
   output logic [`CREOLE_HC_SEQID_WIDTH-1:0] long_hw2_hdr_seq_id;
   output s_hw_ph_intf	long_hw2_ph_intf;	
   output logic		long_st_dbg_cntr_rebuild;
   output logic		long_st_dbg_cntr_rebuild_failed;
   output logic	[1:0]	long_st_dbg_cntr_rebuild_cnt;
   output logic	[1:0]	long_st_dbg_cntr_rebuild_failed_cnt;
   output sh_bl_t	short_bl_ism_data;	
   output logic		short_bl_ism_vld;	
   output logic		short_ht_dbg_cntr_rebuild;
   output logic		short_ht_dbg_cntr_rebuild_failed;
   output logic	[1:0]	short_ht_dbg_cntr_rebuild_cnt;
   output logic	[1:0]	short_ht_dbg_cntr_rebuild_failed_cnt;
   output logic [`CREOLE_HC_SEQID_WIDTH-1:0] short_ht1_hdr_seq_id;
   output logic [`CREOLE_HC_SEQID_WIDTH-1:0] short_ht2_hdr_seq_id;
   output logic [`CREOLE_HC_SEQID_WIDTH-1:0] short_hw1_hdr_seq_id;
   output s_hw_ph_intf	short_hw1_ph_intf;	
   output logic [`CREOLE_HC_SEQID_WIDTH-1:0] short_hw2_hdr_seq_id;
   output s_hw_ph_intf	short_hw2_ph_intf;	
   output logic		short_st_dbg_cntr_rebuild;
   output logic		short_st_dbg_cntr_rebuild_failed;
   output logic	[1:0]	short_st_dbg_cntr_rebuild_cnt;
   output logic	[1:0]	short_st_dbg_cntr_rebuild_failed_cnt;
   output s_st_lut_intf	st1_lut1_long_intf;	
   output logic		st1_lut1_long_wr;	
   output s_st_lut_intf	st1_lut1_short_intf;	
   output logic		st1_lut1_short_wr;	
   output s_st_sa_intf	st1_sa_long_intf;	
   output logic		st1_sa_long_size_rdy_pre;
   output logic		st1_sa_long_table_rdy_pre;
   output s_st_sa_intf	st1_sa_short_intf;	
   output logic		st1_sa_short_size_rdy_pre;
   output logic		st1_sa_short_table_rdy_pre;
   output s_st_lut_intf	st2_lut2_long_intf;	
   output logic		st2_lut2_long_wr;	
   output s_st_lut_intf	st2_lut2_short_intf;	
   output logic		st2_lut2_short_wr;	
   output s_st_sa_intf	st2_sa_long_intf;	
   output logic		st2_sa_long_size_rdy_pre;
   output logic		st2_sa_long_table_rdy_pre;
   output s_st_sa_intf	st2_sa_short_intf;	
   output logic		st2_sa_short_size_rdy_pre;
   output logic		st2_sa_short_table_rdy_pre;
   output st_lng_bl_t	st_long_bl_ism_data;	
   output logic		st_long_bl_ism_vld;	
   output st_sh_bl_t	st_short_bl_ism_data;	
   output logic		st_short_bl_ism_vld;	
   output logic         ee_ecc_error;

   input 					lvm;
   input 					mlvm;
   input 					ovstb;
   input 					ee_bimc_rst_n;
   input 					ee_bimc_isync;
   input 					ee_bimc_idat;
   input ht_config_t                            sw_short_ht_config;
   input ht_config_t                            sw_long_ht_config;
   input small_ht_config_t                      sw_st_short_ht_config;
   input small_ht_config_t                      sw_st_long_ht_config;
   input henc_debug_cntrl_t                     sw_debug_control;
   input henc_force_block_stall_t               sw_force_block_stall;
   
   output logic 				ee_bimc_odat;   
   output logic 				ee_bimc_osync;

   

   logic		htb_long_bimc_idat;
   logic		htb_long_bimc_isync;
   logic		htb_short_bimc_idat;
   logic		htb_short_bimc_isync;
   logic		st_long_bimc_idat;
   logic		st_long_bimc_isync;
   logic		st_short_bimc_idat;
   logic		st_short_bimc_isync;

   logic		htb_long_bimc_odat;
   logic		htb_long_bimc_osync;
   logic		htb_short_bimc_odat;	
   logic		htb_short_bimc_osync;
   logic		st_long_bimc_odat;
   logic		st_long_bimc_osync;
   logic		st_short_bimc_odat;
   logic		st_short_bimc_osync;

   logic                ht_is_short_not_ready;   
   logic                ht_is_long_not_ready;         
   logic                hw1_ht1_long_not_ready;   
   logic                hw2_ht2_long_not_ready;
   logic                hw1_ht1_short_not_ready;   
   logic                hw2_ht2_short_not_ready;      
   logic                st1_hw1_short_not_ready;   
   logic                st2_hw2_short_not_ready;   
   logic                st1_hw1_long_not_ready;   
   logic                st2_hw2_long_not_ready;

   logic		lut1_hw1_long_full_r;
   logic		lut1_hw1_short_full_r;
   logic		lut1_st1_long_full_r;
   logic		lut1_st1_short_full_r;
   logic		lut2_hw2_long_full_r;
   logic		lut2_hw2_short_full_r;
   logic		lut2_st2_long_full_r;
   logic		lut2_st2_short_full_r;
   s_seq_id_type_intf   hdr_long_ht1_type_r;
   s_seq_id_type_intf   hdr_long_ht2_type_r;
   s_seq_id_type_intf   hdr_long_hw1_type_r;
   s_seq_id_type_intf   hdr_long_hw2_type_r;
   s_seq_id_type_intf   hdr_short_ht1_type_r;
   s_seq_id_type_intf   hdr_short_ht2_type_r;
   s_seq_id_type_intf   hdr_short_hw1_type_r;
   s_seq_id_type_intf   hdr_short_hw2_type_r;
   logic		long_ism_rdy_r;
   logic		short_ism_rdy_r;	
   logic		st_long_ism_rdy_r;
   logic		st_short_ism_rdy_r;
   logic		sa_st1_long_read_done_r;
   logic		sa_st1_short_read_done_r;
   logic		sa_st2_long_read_done_r;
   logic		sa_st2_short_read_done_r;
   henc_disable_sub_pipe_t sw_disable_sub_pipe_r;
   ht_config_t          sw_short_ht_config_r;
   ht_config_t          sw_long_ht_config_r;
   small_ht_config_t    sw_st_short_ht_config_r;
   small_ht_config_t    sw_st_long_ht_config_r;
   henc_debug_cntrl_t   sw_debug_control_r;
   henc_force_block_stall_t sw_force_block_stall_r;
   

   
`ifndef ENCODER_ENGINE_BB
   
   
   
   logic [1:0]		ht1_hw1_long_freq_val;	
   s_ht_hw_long_intf	ht1_hw1_long_intf;	
   logic [1:0]		ht1_hw1_short_freq_val;	
   s_ht_hw_short_intf	ht1_hw1_short_intf;	
   logic [1:0]		ht2_hw2_long_freq_val;	
   s_ht_hw_long_intf	ht2_hw2_long_intf;	
   logic [1:0]		ht2_hw2_short_freq_val;	
   s_ht_hw_short_intf	ht2_hw2_short_intf;	
   logic		ht_is_long_not_ready_pre;
   logic		ht_is_short_not_ready_pre;
   logic		htb_long_ecc_error;	
   logic		htb_short_ecc_error;	
   s_hw_ht_long_intf	hw1_ht1_long_intf;	
   logic		hw1_ht1_long_not_ready_pre;
   s_hw_ht_short_intf	hw1_ht1_short_intf;	
   logic		hw1_ht1_short_not_ready_pre;
   s_hw_long_hw_short_intf hw1_long_hw_short_intf;
   logic [1:0]		hw1_long_hw_short_val;	
   s_hw_short_hw_long_intf hw1_short_hw_long_intf;
   logic		hw1_short_hw_long_ready;
   s_long_hw_st_intf	hw1_st1_long_intf;	
   s_short_hw_st_intf	hw1_st1_short_intf;	
   s_hw_ht_long_intf	hw2_ht2_long_intf;	
   logic		hw2_ht2_long_not_ready_pre;
   s_hw_ht_short_intf	hw2_ht2_short_intf;	
   logic		hw2_ht2_short_not_ready_pre;
   s_hw_long_hw_short_intf hw2_long_hw_short_intf;
   logic [1:0]		hw2_long_hw_short_val;	
   s_hw_short_hw_long_intf hw2_short_hw_long_intf;
   logic		hw2_short_hw_long_ready;
   s_long_hw_st_intf	hw2_st2_long_intf;	
   s_short_hw_st_intf	hw2_st2_short_intf;	
   s_is_ht_long_intf	is_ht_long_intf;	
   s_is_ht_short_intf	is_ht_short_intf;	
   logic		long_ht1_dbg_cntr_rebuild;
   logic		long_ht1_dbg_cntr_rebuild_failed;
   logic		long_ht2_dbg_cntr_rebuild;
   logic		long_ht2_dbg_cntr_rebuild_failed;
   logic		long_st1_dbg_cntr_rebuild;
   logic		long_st1_dbg_cntr_rebuild_failed;
   logic		long_st2_dbg_cntr_rebuild;
   logic		long_st2_dbg_cntr_rebuild_failed;
   logic		short_ht1_dbg_cntr_rebuild;
   logic		short_ht1_dbg_cntr_rebuild_failed;
   logic		short_ht2_dbg_cntr_rebuild;
   logic		short_ht2_dbg_cntr_rebuild_failed;
   logic		short_st1_dbg_cntr_rebuild;
   logic		short_st1_dbg_cntr_rebuild_failed;
   logic		short_st2_dbg_cntr_rebuild;
   logic		short_st2_dbg_cntr_rebuild_failed;
   logic		st1_hw1_long_not_ready_pre;
   logic		st1_hw1_short_not_ready_pre;
   logic		st2_hw2_long_not_ready_pre;
   logic		st2_hw2_short_not_ready_pre;
   

  generate 
  if (FPGA_MOD==1) 

    begin  : simple_only_enabled

    logic [`CREOLE_HC_LONG_DAT_WIDTH-2:0] hw1_lut1_long_intf_addr;

       always_ff @(posedge clk or negedge rst_n)
       begin
       if (~rst_n) 
         begin
	    
	    
	    hdr_long_hw1_type_r <= 0;
	    hdr_short_hw1_type_r <= 0;
	    
	 end
       else
	 begin
	    hdr_short_hw1_type_r		<= hdr_short_hw1_type;
	    hdr_long_hw1_type_r			<= hdr_long_hw1_type;
	 end
       end 
       
       always_comb
	 begin

   hw1_lut1_long_intf.wr_data=0;
   hw1_lut1_long_intf.ret_size=0;
   hw1_lut1_long_intf.pre_size=0;
   hw1_lut1_long_intf.addr[8:`CREOLE_HC_LONG_DAT_WIDTH-1]=0;
   hw1_lut1_long_intf.addr[`CREOLE_HC_LONG_DAT_WIDTH-2:0] = hw1_lut1_long_intf_addr;
	    
   hw1_lut1_short_intf.wr_data=0;
   hw1_lut1_short_intf.ret_size=0;
   hw1_lut1_short_intf.pre_size=0;

   hw2_lut2_long_intf=0;
   hw2_lut2_long_wr=0;
   hw2_lut2_short_intf=0;
   hw2_lut2_short_wr=0;

   long_bl_ism_data=0;
   long_bl_ism_vld=0;
   long_ht_dbg_cntr_rebuild=0;
   long_ht_dbg_cntr_rebuild_failed=0;
   long_ht_dbg_cntr_rebuild_cnt=0;
   long_ht_dbg_cntr_rebuild_failed_cnt=0;
   long_ht1_hdr_seq_id=0;
   long_ht2_hdr_seq_id=0;

   long_hw1_ph_intf=0;
   long_hw2_hdr_seq_id=0;
   long_hw2_ph_intf=0;
   long_st_dbg_cntr_rebuild=0;
   long_st_dbg_cntr_rebuild_failed=0;
   long_st_dbg_cntr_rebuild_cnt=0;
   long_st_dbg_cntr_rebuild_failed_cnt=0;
   short_bl_ism_data=0;
   short_bl_ism_vld=0;
   short_ht_dbg_cntr_rebuild=0;
   short_ht_dbg_cntr_rebuild_failed=0;
   short_ht_dbg_cntr_rebuild_cnt=0;
   short_ht_dbg_cntr_rebuild_failed_cnt=0;
   short_ht1_hdr_seq_id=0;
   short_ht2_hdr_seq_id=0;

   short_hw1_ph_intf=0;
   short_hw2_hdr_seq_id=0;
   short_hw2_ph_intf=0;
   short_st_dbg_cntr_rebuild=0;
   short_st_dbg_cntr_rebuild_failed=0;
   short_st_dbg_cntr_rebuild_cnt=0;
   short_st_dbg_cntr_rebuild_failed_cnt=0;
   st1_lut1_long_intf=0;
   st1_lut1_long_wr=0;
   st1_lut1_short_intf=0;
   st1_lut1_short_wr=0;
   st1_sa_long_intf.build_error=0;

   st1_sa_long_table_rdy_pre=0;
   st1_sa_short_intf.build_error=0;

   st1_sa_short_table_rdy_pre=0;
   st2_lut2_long_intf=0;
   st2_lut2_long_wr=0;
   st2_lut2_short_intf=0;
   st2_lut2_short_wr=0;
   st2_sa_long_intf=0;
   st2_sa_long_size_rdy_pre=0;
   st2_sa_long_table_rdy_pre=0;
   st2_sa_short_intf=0;
   st2_sa_short_size_rdy_pre=0;
   st2_sa_short_table_rdy_pre=0;
   st_long_bl_ism_data=0;
   st_long_bl_ism_vld=0;
   st_short_bl_ism_data=0;
   st_short_bl_ism_vld=0;
   ee_ecc_error=0;
   ee_bimc_odat=ee_bimc_idat;   
   ee_bimc_osync=ee_bimc_isync;
	    
	    
	 end 
       

        
        cr_huf_comp_sim_is 
         #(
         .DAT_WIDTH        (`CREOLE_HC_SHORT_DAT_WIDTH),        
         .CNT_WIDTH        (`CREOLE_HC_SHORT_CNT_WIDTH),        
         .MAX_NUM_SYM_USED (`CREOLE_HC_SHORT_NUM_MAX_SYM_USED), 
	 .SHORT            (1)
	 )
	is_short(
		 
		 .is_sc_rd		(is_sc_short_rd),	 
		 .hw_lut_wr		(hw1_lut1_short_wr),	 
		 .hw_lut_wr_done	(hw1_lut1_short_intf.wr_done), 
		 .hw_lut_wr_val		(hw1_lut1_short_intf.wr_val), 
		 .hw_lut_wr_addr	(hw1_lut1_short_intf.addr), 
		 .hw_lut_sizes_val	(hw1_lut1_short_intf.sizes_val), 
		 .hw_lut_sim_size	(hw1_lut1_short_intf.sim_size), 
		 .hw_lut_seq_id		(hw1_lut1_short_intf.seq_id), 
		 .st_sa_size_rdy	(st1_sa_short_size_rdy_pre), 
		 .st_sa_size_seq_id	(st1_sa_short_intf.size_seq_id), 
		 .st_sa_eob		(st1_sa_short_intf.eob), 
		 .hw_hdr_seq_id		(short_hw1_hdr_seq_id),	 
		 
		 .clk			(clk),
		 .rst_n			(rst_n),
		 .sc_is_vld		(sc_is_short_vld),	 
		 .sc_is_sym0		(sc_is_short_intf.short0), 
		 .sc_is_sym1		(sc_is_short_intf.short1), 
		 .sc_is_sym2		(sc_is_short_intf.short2), 
		 .sc_is_sym3		(sc_is_short_intf.short3), 
		 .sc_is_cnt0		(sc_is_short_intf.cnt0), 
		 .sc_is_cnt1		(sc_is_short_intf.cnt1), 
		 .sc_is_cnt2		(sc_is_short_intf.cnt2), 
		 .sc_is_cnt3		(sc_is_short_intf.cnt3), 
		 .sc_is_seq_id		(sc_is_short_intf.seq_id), 
		 .sc_is_eob		(sc_is_short_intf.eob),	 
		 .sa_st_read_done	( sa_st1_short_read_done), 
		 .hdr_hw_type		(hdr_short_hw1_type_r));	 

        
        cr_huf_comp_sim_is 
        #(
          .DAT_WIDTH        (`CREOLE_HC_LONG_DAT_WIDTH),        
          .CNT_WIDTH        (`CREOLE_HC_LONG_CNT_WIDTH),        
          .MAX_NUM_SYM_USED (`CREOLE_HC_LONG_NUM_MAX_SYM_USED), 
	  .SHORT            (0)
        )
        is_long(
		
		.is_sc_rd		(is_sc_long_rd),	 
		.hw_lut_wr		(hw1_lut1_long_wr),	 
		.hw_lut_wr_done		(hw1_lut1_long_intf.wr_done), 
		.hw_lut_wr_val		(hw1_lut1_long_intf.wr_val), 
		.hw_lut_wr_addr		(hw1_lut1_long_intf_addr), 
		.hw_lut_sizes_val	(hw1_lut1_long_intf.sizes_val), 
		.hw_lut_sim_size	(hw1_lut1_long_intf.sim_size), 
		.hw_lut_seq_id		(hw1_lut1_long_intf.seq_id), 
		.st_sa_size_rdy		(st1_sa_long_size_rdy_pre), 
		.st_sa_size_seq_id	(st1_sa_long_intf.size_seq_id), 
		.st_sa_eob		(st1_sa_long_intf.eob),	 
		.hw_hdr_seq_id		(long_hw1_hdr_seq_id),	 
		
		.clk			(clk),
		.rst_n			(rst_n),
		.sc_is_vld		({3'b0,sc_is_long_vld}), 
		.sc_is_sym0		(sc_is_long_intf.long),	 
		.sc_is_sym1		(`CREOLE_HC_LONG_DAT_WIDTH'b0), 
		.sc_is_sym2		(`CREOLE_HC_LONG_DAT_WIDTH'b0), 
		.sc_is_sym3		(`CREOLE_HC_LONG_DAT_WIDTH'b0), 
		.sc_is_cnt0		(sc_is_long_intf.cnt),	 
		.sc_is_cnt1		(`CREOLE_HC_LONG_CNT_WIDTH'b0), 
		.sc_is_cnt2		(`CREOLE_HC_LONG_CNT_WIDTH'b0), 
		.sc_is_cnt3		(`CREOLE_HC_LONG_CNT_WIDTH'b0), 
		.sc_is_seq_id		(sc_is_long_intf.seq_id), 
		.sc_is_eob		(sc_is_long_intf.eob),	 
		.sa_st_read_done	( sa_st1_long_read_done), 
		.hdr_hw_type		(hdr_long_hw1_type_r));	 
       
    end
     
  else 
    begin : all_enabled
    
   
always_ff @(posedge clk or negedge rst_n)
begin
  if (~rst_n) 
  begin
    
    
    ee_ecc_error <= 0;
    hdr_long_ht1_type_r <= 0;
    hdr_long_ht2_type_r <= 0;
    hdr_long_hw1_type_r <= 0;
    hdr_long_hw2_type_r <= 0;
    hdr_short_ht1_type_r <= 0;
    hdr_short_ht2_type_r <= 0;
    hdr_short_hw1_type_r <= 0;
    hdr_short_hw2_type_r <= 0;
    long_ht_dbg_cntr_rebuild <= 0;
    long_ht_dbg_cntr_rebuild_cnt <= 0;
    long_ht_dbg_cntr_rebuild_failed <= 0;
    long_ht_dbg_cntr_rebuild_failed_cnt <= 0;
    long_ism_rdy_r <= 0;
    long_st_dbg_cntr_rebuild <= 0;
    long_st_dbg_cntr_rebuild_cnt <= 0;
    long_st_dbg_cntr_rebuild_failed <= 0;
    long_st_dbg_cntr_rebuild_failed_cnt <= 0;
    lut1_hw1_long_full_r <= 0;
    lut1_hw1_short_full_r <= 0;
    lut1_st1_long_full_r <= 0;
    lut1_st1_short_full_r <= 0;
    lut2_hw2_long_full_r <= 0;
    lut2_hw2_short_full_r <= 0;
    lut2_st2_long_full_r <= 0;
    lut2_st2_short_full_r <= 0;
    sa_st1_long_read_done_r <= 0;
    sa_st1_short_read_done_r <= 0;
    sa_st2_long_read_done_r <= 0;
    sa_st2_short_read_done_r <= 0;
    short_ht_dbg_cntr_rebuild <= 0;
    short_ht_dbg_cntr_rebuild_cnt <= 0;
    short_ht_dbg_cntr_rebuild_failed <= 0;
    short_ht_dbg_cntr_rebuild_failed_cnt <= 0;
    short_ism_rdy_r <= 0;
    short_st_dbg_cntr_rebuild <= 0;
    short_st_dbg_cntr_rebuild_cnt <= 0;
    short_st_dbg_cntr_rebuild_failed <= 0;
    short_st_dbg_cntr_rebuild_failed_cnt <= 0;
    st_long_ism_rdy_r <= 0;
    st_short_ism_rdy_r <= 0;
    sw_debug_control_r <= 0;
    sw_disable_sub_pipe_r <= 0;
    sw_force_block_stall_r <= 0;
    sw_long_ht_config_r <= 0;
    sw_short_ht_config_r <= 0;
    sw_st_long_ht_config_r <= 0;
    sw_st_short_ht_config_r <= 0;
    
  end
  else
    begin
       lut1_hw1_long_full_r			<= lut1_hw1_long_full;
       lut1_hw1_short_full_r			<= lut1_hw1_short_full;
       lut1_st1_long_full_r			<= lut1_st1_long_full;
       lut1_st1_short_full_r			<= lut1_st1_short_full;
       lut2_hw2_long_full_r			<= lut2_hw2_long_full;
       lut2_hw2_short_full_r			<= lut2_hw2_short_full;
       lut2_st2_long_full_r			<= lut2_st2_long_full;
       lut2_st2_short_full_r			<= lut2_st2_short_full;
       hdr_long_ht1_type_r			<= hdr_long_ht1_type;
       hdr_long_ht2_type_r			<= hdr_long_ht2_type;
       hdr_long_hw1_type_r			<= hdr_long_hw1_type;
       hdr_long_hw2_type_r			<= hdr_long_hw2_type;
       hdr_short_ht1_type_r			<= hdr_short_ht1_type;
       hdr_short_ht2_type_r			<= hdr_short_ht2_type;
       hdr_short_hw1_type_r			<= hdr_short_hw1_type;
       hdr_short_hw2_type_r			<= hdr_short_hw2_type;
       long_ism_rdy_r				<= long_ism_rdy;
       short_ism_rdy_r				<= short_ism_rdy;	
       st_long_ism_rdy_r			<= st_long_ism_rdy;
       st_short_ism_rdy_r			<= st_short_ism_rdy;
       sa_st1_long_read_done_r			<= sa_st1_long_read_done;
       sa_st1_short_read_done_r			<= sa_st1_short_read_done;
       sa_st2_long_read_done_r			<= sa_st2_long_read_done;
       sa_st2_short_read_done_r			<= sa_st2_short_read_done;
       sw_disable_sub_pipe_r			<= sw_disable_sub_pipe;
       sw_short_ht_config_r			<= sw_short_ht_config;
       sw_long_ht_config_r			<= sw_long_ht_config;
       sw_st_short_ht_config_r			<= sw_st_short_ht_config;
       sw_st_long_ht_config_r			<= sw_st_long_ht_config;
       sw_debug_control_r			<= sw_debug_control;
       sw_force_block_stall_r			<= sw_force_block_stall;

       short_ht_dbg_cntr_rebuild		<= short_ht1_dbg_cntr_rebuild | short_ht2_dbg_cntr_rebuild;
       short_ht_dbg_cntr_rebuild_cnt		<= (short_ht1_dbg_cntr_rebuild && short_ht2_dbg_cntr_rebuild) ? 2'd2 : 2'd1;
       long_ht_dbg_cntr_rebuild			<= long_ht1_dbg_cntr_rebuild | long_ht2_dbg_cntr_rebuild;
       long_ht_dbg_cntr_rebuild_cnt		<= (long_ht1_dbg_cntr_rebuild && long_ht2_dbg_cntr_rebuild) ? 2'd2 : 2'd1;
       short_st_dbg_cntr_rebuild		<= short_st1_dbg_cntr_rebuild | short_st2_dbg_cntr_rebuild;
       short_st_dbg_cntr_rebuild_cnt		<= (short_st1_dbg_cntr_rebuild && short_st2_dbg_cntr_rebuild) ? 2'd2 : 2'd1;
       long_st_dbg_cntr_rebuild			<= long_st1_dbg_cntr_rebuild | long_st2_dbg_cntr_rebuild;
       long_st_dbg_cntr_rebuild_cnt		<= (long_st1_dbg_cntr_rebuild && long_st2_dbg_cntr_rebuild) ? 2'd2 : 2'd1;

       short_ht_dbg_cntr_rebuild_failed		<= short_ht1_dbg_cntr_rebuild_failed | short_ht2_dbg_cntr_rebuild_failed;
       short_ht_dbg_cntr_rebuild_failed_cnt	<= (short_ht1_dbg_cntr_rebuild_failed && short_ht2_dbg_cntr_rebuild_failed) ? 2'd2 : 2'd1;
       long_ht_dbg_cntr_rebuild_failed		<= long_ht1_dbg_cntr_rebuild_failed | long_ht2_dbg_cntr_rebuild_failed;
       long_ht_dbg_cntr_rebuild_failed_cnt	<= (long_ht1_dbg_cntr_rebuild_failed && long_ht2_dbg_cntr_rebuild_failed) ? 2'd2 : 2'd1;
       short_st_dbg_cntr_rebuild_failed		<= short_st1_dbg_cntr_rebuild_failed | short_st2_dbg_cntr_rebuild_failed;
       short_st_dbg_cntr_rebuild_failed_cnt	<= (short_st1_dbg_cntr_rebuild_failed && short_st2_dbg_cntr_rebuild_failed) ? 2'd2 : 2'd1;
       long_st_dbg_cntr_rebuild_failed		<= long_st1_dbg_cntr_rebuild_failed | long_st2_dbg_cntr_rebuild_failed;
       long_st_dbg_cntr_rebuild_failed_cnt	<= (long_st1_dbg_cntr_rebuild_failed && long_st2_dbg_cntr_rebuild_failed) ? 2'd2 : 2'd1;
       
       ee_ecc_error                             <=  htb_long_ecc_error | htb_short_ecc_error;
       
    end 
end 

  always_comb
  begin
      ht_is_short_not_ready    = ht_is_short_not_ready_pre   |     sw_force_block_stall_r.tb_is_stall;   
      ht_is_long_not_ready     = ht_is_long_not_ready_pre    |     sw_force_block_stall_r.tb_is_stall;         
      hw1_ht1_long_not_ready   = hw1_ht1_long_not_ready_pre  |     sw_force_block_stall_r.tw_tb_stall;   
      hw2_ht2_long_not_ready   = hw2_ht2_long_not_ready_pre  |     sw_force_block_stall_r.tw_tb_stall;
      hw1_ht1_short_not_ready  = hw1_ht1_short_not_ready_pre |     sw_force_block_stall_r.tw_tb_stall;   
      hw2_ht2_short_not_ready  = hw2_ht2_short_not_ready_pre |     sw_force_block_stall_r.tw_tb_stall;      
      st1_hw1_short_not_ready  = st1_hw1_short_not_ready_pre |     sw_force_block_stall_r.st_tw_stall;   
      st2_hw2_short_not_ready  = st2_hw2_short_not_ready_pre |     sw_force_block_stall_r.st_tw_stall;   
      st1_hw1_long_not_ready   = st1_hw1_long_not_ready_pre  |     sw_force_block_stall_r.st_tw_stall;   
      st2_hw2_long_not_ready   = st2_hw2_long_not_ready_pre  |     sw_force_block_stall_r.st_tw_stall;        
     
      htb_short_bimc_idat	 = ee_bimc_idat; 
      htb_short_bimc_isync	 = ee_bimc_isync;
      htb_long_bimc_idat	 = htb_short_bimc_odat;
      htb_long_bimc_isync	 = htb_short_bimc_osync;
      st_short_bimc_idat	 = htb_long_bimc_odat;
      st_short_bimc_isync	 = htb_long_bimc_osync;
      st_long_bimc_idat		 = st_short_bimc_odat;
      st_long_bimc_isync	 = st_short_bimc_osync;
      ee_bimc_odat		 = st_long_bimc_odat;
      ee_bimc_osync		 = st_long_bimc_osync;

      
  end
   
   
     
 cr_huf_comp_is_short is_short(
			       
			       .is_sc_short_rd	(is_sc_short_rd),
			       .is_ht_short_intf(is_ht_short_intf),
			       
			       .clk		(clk),
			       .rst_n		(rst_n),
			       .sc_is_short_vld	(sc_is_short_vld[3:0]),
			       .sc_is_short_intf(sc_is_short_intf),
			       .ht_is_short_not_ready(ht_is_short_not_ready));
  
 cr_huf_comp_is_long is_long(
			     
			     .is_sc_long_rd	(is_sc_long_rd),
			     .is_ht_long_intf	(is_ht_long_intf),
			     
			     .clk		(clk),
			     .rst_n		(rst_n),
			     .sc_is_long_vld	(sc_is_long_vld),
			     .sc_is_long_intf	(sc_is_long_intf),
			     .ht_is_long_not_ready(ht_is_long_not_ready));
   
  
 cr_huf_comp_htb_short 
    #(
      .SINGLE_PIPE        (SINGLE_PIPE)  
     ) tb_short(
		
		.ht_is_short_not_ready	(ht_is_short_not_ready_pre), 
		.ht1_hw1_short_intf	(ht1_hw1_short_intf),
		.ht1_hw1_short_freq_val	(ht1_hw1_short_freq_val[1:0]),
		.ht2_hw2_short_intf	(ht2_hw2_short_intf),
		.ht2_hw2_short_freq_val	(ht2_hw2_short_freq_val[1:0]),
		.short_ht1_hdr_seq_id	(short_ht1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
		.short_ht2_hdr_seq_id	(short_ht2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
		.short_ht1_dbg_cntr_rebuild(short_ht1_dbg_cntr_rebuild),
		.short_ht1_dbg_cntr_rebuild_failed(short_ht1_dbg_cntr_rebuild_failed),
		.short_ht2_dbg_cntr_rebuild(short_ht2_dbg_cntr_rebuild),
		.short_ht2_dbg_cntr_rebuild_failed(short_ht2_dbg_cntr_rebuild_failed),
		.htb_short_bimc_odat	(htb_short_bimc_odat),
		.htb_short_bimc_osync	(htb_short_bimc_osync),
		.htb_short_ecc_error	(htb_short_ecc_error),
		
		.clk			(clk),
		.rst_n			(rst_n),
		.is_ht_short_intf	(is_ht_short_intf),
		.hw1_ht1_short_not_ready(hw1_ht1_short_not_ready),
		.hw1_ht1_short_intf	(hw1_ht1_short_intf),
		.hw2_ht2_short_not_ready(hw2_ht2_short_not_ready),
		.hw2_ht2_short_intf	(hw2_ht2_short_intf),
		.hdr_short_ht1_type	(hdr_short_ht1_type_r),	 
		.hdr_short_ht2_type	(hdr_short_ht2_type_r),	 
		.sw_short_ht1_xp_max_code_length(sw_short_ht_config_r.xp_max_code_length), 
		.sw_short_ht1_deflate_max_code_length(sw_short_ht_config_r.deflate_max_code_length), 
		.sw_short_ht1_max_rebuild_limit(sw_short_ht_config_r.max_rebuild_limit), 
		.sw_short_ht1_force_rebuild(sw_short_ht_config_r.force_rebuild), 
		.sw_short_ht2_xp_max_code_length(sw_short_ht_config_r.xp_max_code_length), 
		.sw_short_ht2_deflate_max_code_length(sw_short_ht_config_r.deflate_max_code_length), 
		.sw_short_ht2_max_rebuild_limit(sw_short_ht_config_r.max_rebuild_limit), 
		.sw_short_ht2_force_rebuild(sw_short_ht_config_r.force_rebuild), 
		.sw_disable_sub_pipe	(sw_disable_sub_pipe_r), 
		.htb_short_bimc_idat	(htb_short_bimc_idat),
		.htb_short_bimc_isync	(htb_short_bimc_isync),
		.lvm			(lvm),
		.mlvm			(mlvm),
		.mrdten			(mrdten));
   
  
 cr_huf_comp_htb_long 
    #(
      .SINGLE_PIPE        (SINGLE_PIPE)  
     ) tb_long(
	       
	       .ht_is_long_not_ready	(ht_is_long_not_ready_pre), 
	       .ht1_hw1_long_intf	(ht1_hw1_long_intf),
	       .ht1_hw1_long_freq_val	(ht1_hw1_long_freq_val[1:0]),
	       .ht2_hw2_long_intf	(ht2_hw2_long_intf),
	       .ht2_hw2_long_freq_val	(ht2_hw2_long_freq_val[1:0]),
	       .long_ht1_hdr_seq_id	(long_ht1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
	       .long_ht2_hdr_seq_id	(long_ht2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
	       .long_ht1_dbg_cntr_rebuild(long_ht1_dbg_cntr_rebuild),
	       .long_ht1_dbg_cntr_rebuild_failed(long_ht1_dbg_cntr_rebuild_failed),
	       .long_ht2_dbg_cntr_rebuild(long_ht2_dbg_cntr_rebuild),
	       .long_ht2_dbg_cntr_rebuild_failed(long_ht2_dbg_cntr_rebuild_failed),
	       .htb_long_bimc_odat	(htb_long_bimc_odat),
	       .htb_long_bimc_osync	(htb_long_bimc_osync),
	       .htb_long_ecc_error	(htb_long_ecc_error),
	       
	       .clk			(clk),
	       .rst_n			(rst_n),
	       .is_ht_long_intf		(is_ht_long_intf),
	       .hw1_ht1_long_not_ready	(hw1_ht1_long_not_ready),
	       .hw1_ht1_long_intf	(hw1_ht1_long_intf),
	       .hw2_ht2_long_not_ready	(hw2_ht2_long_not_ready),
	       .hw2_ht2_long_intf	(hw2_ht2_long_intf),
	       .hdr_long_ht1_type	(hdr_long_ht1_type_r),	 
	       .hdr_long_ht2_type	(hdr_long_ht2_type_r),	 
	       .sw_long_ht1_xp_max_code_length(sw_long_ht_config_r.xp_max_code_length), 
	       .sw_long_ht1_deflate_max_code_length(sw_long_ht_config_r.deflate_max_code_length), 
	       .sw_long_ht1_max_rebuild_limit(sw_long_ht_config_r.max_rebuild_limit), 
	       .sw_long_ht1_force_rebuild(sw_long_ht_config_r.force_rebuild), 
	       .sw_long_ht2_xp_max_code_length(sw_long_ht_config_r.xp_max_code_length), 
	       .sw_long_ht2_deflate_max_code_length(sw_long_ht_config_r.deflate_max_code_length), 
	       .sw_long_ht2_max_rebuild_limit(sw_long_ht_config_r.max_rebuild_limit), 
	       .sw_long_ht2_force_rebuild(sw_long_ht_config_r.force_rebuild), 
	       .sw_disable_sub_pipe	(sw_disable_sub_pipe_r), 
	       .htb_long_bimc_idat	(htb_long_bimc_idat),
	       .htb_long_bimc_isync	(htb_long_bimc_isync),
	       .lvm			(lvm),
	       .mlvm			(mlvm),
	       .mrdten			(mrdten));
   
 
if (SINGLE_PIPE==1) 

  begin  : one_pipe

   always_comb
     begin

        hw2_lut2_short_wr   = 0;
        hw2_lut2_short_intf = 0;

        hw2_lut2_long_wr    = 0;
        hw2_lut2_long_intf  = 0;

        st2_lut2_short_wr   = 0;
        st2_lut2_short_intf = 0;

        st2_lut2_long_wr   = 0;
        st2_lut2_long_intf = 0;

	st2_sa_short_size_rdy_pre = 0;
	st2_sa_short_table_rdy_pre = 0;
        st2_lut2_short_wr = 0;
	st2_lut2_short_intf = 0;
	st2_sa_short_intf = 0;

	st2_sa_long_size_rdy_pre = 0;
	st2_sa_long_table_rdy_pre = 0;
        st2_lut2_long_wr = 0;
	st2_lut2_long_intf = 0;
	st2_sa_long_intf = 0;
	
     end

   
 cr_huf_comp_htw_short tw_short(
				
				.hw1_ht1_short_not_ready(hw1_ht1_short_not_ready_pre), 
				.hw1_ht1_short_intf(hw1_ht1_short_intf),
				.hw2_ht2_short_not_ready(hw2_ht2_short_not_ready_pre), 
				.hw2_ht2_short_intf(hw2_ht2_short_intf),
				.hw1_short_hw_long_ready(hw1_short_hw_long_ready),
				.hw1_short_hw_long_intf(hw1_short_hw_long_intf),
				.hw2_short_hw_long_ready(),	 
				.hw2_short_hw_long_intf(),	 
				.hw1_lut1_short_wr(hw1_lut1_short_wr),
				.hw1_lut1_short_intf(hw1_lut1_short_intf),
				.hw2_lut2_short_wr(),		 
				.hw2_lut2_short_intf(),		 
				.short_hw1_ph_intf(short_hw1_ph_intf),
				.short_hw2_ph_intf(short_hw2_ph_intf),
				.hw1_st1_short_intf(hw1_st1_short_intf),
				.hw2_st2_short_intf(hw2_st2_short_intf),
				.short_hw1_hdr_seq_id(short_hw1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
				.short_hw2_hdr_seq_id(short_hw2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
				.short_bl_ism_data(short_bl_ism_data),
				.short_bl_ism_vld(short_bl_ism_vld),
				
				.clk		(clk),
				.rst_n		(rst_n),
				.ht1_hw1_short_intf(ht1_hw1_short_intf),
				.ht1_hw1_short_freq_val(ht1_hw1_short_freq_val[1:0]),
				.ht2_hw2_short_intf(ht2_hw2_short_intf),
				.ht2_hw2_short_freq_val(ht2_hw2_short_freq_val[1:0]),
				.hw1_long_hw_short_val(hw1_long_hw_short_val[1:0]),
				.hw1_long_hw_short_intf(hw1_long_hw_short_intf),
				.hw2_long_hw_short_val(2'b0),	 
				.hw2_long_hw_short_intf({$bits(s_hw_long_hw_short_intf){1'b0}}), 
				.lut1_hw1_short_full(lut1_hw1_short_full_r), 
				.lut2_hw2_short_full(1'b0),	 
				.ph_short_hw1_val(ph_short_hw1_val),
				.ph_short_hw1_intf(ph_short_hw1_intf),
				.ph_short_hw2_val(ph_short_hw2_val),
				.ph_short_hw2_intf(ph_short_hw2_intf),
				.st1_hw1_short_not_ready(st1_hw1_short_not_ready),
				.st2_hw2_short_not_ready(st2_hw2_short_not_ready),
				.hdr_short_hw1_type(hdr_short_hw1_type_r), 
				.hdr_short_hw2_type(hdr_short_hw2_type_r), 
				.short_ism_rdy	(short_ism_rdy_r), 
				.sw_ism_on	(sw_debug_control_r.ism_on)); 
   
 
 cr_huf_comp_htw_long tw_long(
			      
			      .hw1_ht1_long_not_ready(hw1_ht1_long_not_ready_pre), 
			      .hw1_ht1_long_intf(hw1_ht1_long_intf),
			      .hw2_ht2_long_not_ready(hw2_ht2_long_not_ready_pre), 
			      .hw2_ht2_long_intf(hw2_ht2_long_intf),
			      .hw1_long_hw_short_val(hw1_long_hw_short_val[1:0]),
			      .hw1_long_hw_short_intf(hw1_long_hw_short_intf),
			      .hw2_long_hw_short_val(),		 
			      .hw2_long_hw_short_intf(),	 
			      .hw1_lut1_long_wr	(hw1_lut1_long_wr),
			      .hw1_lut1_long_intf(hw1_lut1_long_intf),
			      .hw2_lut2_long_wr	(),		 
			      .hw2_lut2_long_intf(),		 
			      .long_hw1_ph_intf	(long_hw1_ph_intf),
			      .long_hw2_ph_intf	(long_hw2_ph_intf),
			      .hw1_st1_long_intf(hw1_st1_long_intf),
			      .hw2_st2_long_intf(hw2_st2_long_intf),
			      .long_hw1_hdr_seq_id(long_hw1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
			      .long_hw2_hdr_seq_id(long_hw2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
			      .long_bl_ism_data	(long_bl_ism_data),
			      .long_bl_ism_vld	(long_bl_ism_vld),
			      
			      .clk		(clk),
			      .rst_n		(rst_n),
			      .ht1_hw1_long_intf(ht1_hw1_long_intf),
			      .ht1_hw1_long_freq_val(ht1_hw1_long_freq_val[1:0]),
			      .ht2_hw2_long_intf(ht2_hw2_long_intf),
			      .ht2_hw2_long_freq_val(ht2_hw2_long_freq_val[1:0]),
			      .hw1_short_hw_long_ready(hw1_short_hw_long_ready),
			      .hw1_short_hw_long_intf(hw1_short_hw_long_intf),
			      .hw2_short_hw_long_ready(1'b0),	 
			      .hw2_short_hw_long_intf({$bits(s_hw_short_hw_long_intf){1'b0}}), 
			      .lut1_hw1_long_full(lut1_hw1_long_full_r), 
			      .lut2_hw2_long_full(1'b0),	 
			      .ph_long_hw1_val	(ph_long_hw1_val),
			      .ph_long_hw1_intf	(ph_long_hw1_intf),
			      .ph_long_hw2_val	(ph_long_hw2_val),
			      .ph_long_hw2_intf	(ph_long_hw2_intf),
			      .st1_hw1_long_not_ready(st1_hw1_long_not_ready),
			      .st2_hw2_long_not_ready(st2_hw2_long_not_ready),
			      .hdr_long_hw1_type(hdr_long_hw1_type_r), 
			      .hdr_long_hw2_type(hdr_long_hw2_type_r), 
			      .long_ism_rdy	(long_ism_rdy_r), 
			      .sw_ism_on	(sw_debug_control_r.ism_on)); 


   
 cr_huf_comp_st_short st_short(
			       
			       .st1_hw1_short_not_ready(st1_hw1_short_not_ready_pre), 
			       .st2_hw2_short_not_ready(st2_hw2_short_not_ready_pre), 
			       .st1_lut1_short_wr(st1_lut1_short_wr),
			       .st1_lut1_short_intf(st1_lut1_short_intf),
			       .st2_lut2_short_wr(),		 
			       .st2_lut2_short_intf(),		 
			       .st1_sa_short_size_rdy(st1_sa_short_size_rdy_pre), 
			       .st1_sa_short_table_rdy(st1_sa_short_table_rdy_pre), 
			       .st1_sa_short_intf(st1_sa_short_intf),
			       .st2_sa_short_size_rdy(),	 
			       .st2_sa_short_table_rdy(),	 
			       .st2_sa_short_intf(),		 
			       .short_st1_dbg_cntr_rebuild(short_st1_dbg_cntr_rebuild),
			       .short_st1_dbg_cntr_rebuild_failed(short_st1_dbg_cntr_rebuild_failed),
			       .short_st2_dbg_cntr_rebuild(short_st2_dbg_cntr_rebuild),
			       .short_st2_dbg_cntr_rebuild_failed(short_st2_dbg_cntr_rebuild_failed),
			       .st_short_bl_ism_data(st_short_bl_ism_data),
			       .st_short_bl_ism_vld(st_short_bl_ism_vld),
			       .st_short_bimc_odat(st_short_bimc_odat),
			       .st_short_bimc_osync(st_short_bimc_osync),
			       
			       .clk		(clk),
			       .rst_n		(rst_n),
			       .hw1_st1_short_intf(hw1_st1_short_intf),
			       .hw2_st2_short_intf(hw2_st2_short_intf),
			       .lut1_st1_short_full(lut1_st1_short_full_r), 
			       .lut2_st2_short_full(1'b0),	 
			       .sa_st1_short_read_done(sa_st1_short_read_done_r), 
			       .sa_st2_short_read_done(1'b0),	 
			       .sw_short_st1_deflate_max_code_length(sw_st_short_ht_config_r.deflate_max_code_length), 
			       .sw_short_st1_force_rebuild(sw_st_short_ht_config_r.force_rebuild), 
			       .sw_short_st1_max_rebuild_limit(sw_st_short_ht_config_r.max_rebuild_limit), 
			       .sw_short_st1_xp_max_code_length(sw_st_short_ht_config_r.xp_max_code_length), 
			       .sw_short_st2_deflate_max_code_length(sw_st_short_ht_config_r.deflate_max_code_length), 
			       .sw_short_st2_force_rebuild(sw_st_short_ht_config_r.force_rebuild), 
			       .sw_short_st2_max_rebuild_limit(sw_st_short_ht_config_r.max_rebuild_limit), 
			       .sw_short_st2_xp_max_code_length(sw_st_short_ht_config_r.xp_max_code_length), 
			       .st_short_ism_rdy(st_short_ism_rdy_r), 
			       .sw_ism_on	(sw_debug_control_r.ism_on), 
			       .st_short_bimc_idat(st_short_bimc_idat),
			       .st_short_bimc_isync(st_short_bimc_isync),
			       .lvm		(lvm),
			       .mlvm		(mlvm),
			       .mrdten		(mrdten));
 
 cr_huf_comp_st_long st_long(
			     
			     .st1_hw1_long_not_ready(st1_hw1_long_not_ready_pre), 
			     .st2_hw2_long_not_ready(st2_hw2_long_not_ready_pre), 
			     .st1_lut1_long_wr	(st1_lut1_long_wr),
			     .st1_lut1_long_intf(st1_lut1_long_intf),
			     .st2_lut2_long_wr	(),		 
			     .st2_lut2_long_intf(),		 
			     .st1_sa_long_size_rdy(st1_sa_long_size_rdy_pre), 
			     .st1_sa_long_table_rdy(st1_sa_long_table_rdy_pre), 
			     .st1_sa_long_intf	(st1_sa_long_intf),
			     .st2_sa_long_size_rdy(),		 
			     .st2_sa_long_table_rdy(),		 
			     .st2_sa_long_intf	(),		 
			     .long_st1_dbg_cntr_rebuild(long_st1_dbg_cntr_rebuild),
			     .long_st1_dbg_cntr_rebuild_failed(long_st1_dbg_cntr_rebuild_failed),
			     .long_st2_dbg_cntr_rebuild(long_st2_dbg_cntr_rebuild),
			     .long_st2_dbg_cntr_rebuild_failed(long_st2_dbg_cntr_rebuild_failed),
			     .st_long_bl_ism_data(st_long_bl_ism_data),
			     .st_long_bl_ism_vld(st_long_bl_ism_vld),
			     .st_long_bimc_odat	(st_long_bimc_odat),
			     .st_long_bimc_osync(st_long_bimc_osync),
			     
			     .clk		(clk),
			     .rst_n		(rst_n),
			     .hw1_st1_long_intf	(hw1_st1_long_intf),
			     .hw2_st2_long_intf	(hw2_st2_long_intf),
			     .lut1_st1_long_full(lut1_st1_long_full_r), 
			     .lut2_st2_long_full(1'b0),		 
			     .sa_st1_long_read_done(sa_st1_long_read_done_r), 
			     .sa_st2_long_read_done(1'b0),	 
			     .sw_long_st1_force_rebuild(sw_st_long_ht_config_r.force_rebuild), 
			     .sw_long_st1_max_rebuild_limit(sw_st_long_ht_config_r.max_rebuild_limit), 
			     .sw_long_st1_xp_max_code_length(sw_st_long_ht_config_r.xp_max_code_length), 
			     .sw_long_st2_force_rebuild(sw_st_long_ht_config_r.force_rebuild), 
			     .sw_long_st2_max_rebuild_limit(sw_st_long_ht_config_r.max_rebuild_limit), 
			     .sw_long_st2_xp_max_code_length(sw_st_long_ht_config_r.xp_max_code_length), 
			     .sw_ism_on		(sw_debug_control_r.ism_on), 
			     .st_long_ism_rdy	(st_long_ism_rdy_r), 
			     .st_long_bimc_idat	(st_long_bimc_idat),
			     .st_long_bimc_isync(st_long_bimc_isync),
			     .lvm		(lvm),
			     .mlvm		(mlvm),
			     .mrdten		(mrdten));
     
  end
else 
  begin : two_pipes

  
 cr_huf_comp_htw_short tw_short(
				
				.hw1_ht1_short_not_ready(hw1_ht1_short_not_ready_pre), 
				.hw1_ht1_short_intf(hw1_ht1_short_intf),
				.hw2_ht2_short_not_ready(hw2_ht2_short_not_ready_pre), 
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
				.hw1_st1_short_intf(hw1_st1_short_intf),
				.hw2_st2_short_intf(hw2_st2_short_intf),
				.short_hw1_hdr_seq_id(short_hw1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
				.short_hw2_hdr_seq_id(short_hw2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
				.short_bl_ism_data(short_bl_ism_data),
				.short_bl_ism_vld(short_bl_ism_vld),
				
				.clk		(clk),
				.rst_n		(rst_n),
				.ht1_hw1_short_intf(ht1_hw1_short_intf),
				.ht1_hw1_short_freq_val(ht1_hw1_short_freq_val[1:0]),
				.ht2_hw2_short_intf(ht2_hw2_short_intf),
				.ht2_hw2_short_freq_val(ht2_hw2_short_freq_val[1:0]),
				.hw1_long_hw_short_val(hw1_long_hw_short_val[1:0]),
				.hw1_long_hw_short_intf(hw1_long_hw_short_intf),
				.hw2_long_hw_short_val(hw2_long_hw_short_val[1:0]),
				.hw2_long_hw_short_intf(hw2_long_hw_short_intf),
				.lut1_hw1_short_full(lut1_hw1_short_full_r), 
				.lut2_hw2_short_full(lut2_hw2_short_full_r), 
				.ph_short_hw1_val(ph_short_hw1_val),
				.ph_short_hw1_intf(ph_short_hw1_intf),
				.ph_short_hw2_val(ph_short_hw2_val),
				.ph_short_hw2_intf(ph_short_hw2_intf),
				.st1_hw1_short_not_ready(st1_hw1_short_not_ready),
				.st2_hw2_short_not_ready(st2_hw2_short_not_ready),
				.hdr_short_hw1_type(hdr_short_hw1_type_r), 
				.hdr_short_hw2_type(hdr_short_hw2_type_r), 
				.short_ism_rdy	(short_ism_rdy_r), 
				.sw_ism_on	(sw_debug_control_r.ism_on)); 
   
 
 cr_huf_comp_htw_long tw_long(
			      
			      .hw1_ht1_long_not_ready(hw1_ht1_long_not_ready_pre), 
			      .hw1_ht1_long_intf(hw1_ht1_long_intf),
			      .hw2_ht2_long_not_ready(hw2_ht2_long_not_ready_pre), 
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
			      .hw1_st1_long_intf(hw1_st1_long_intf),
			      .hw2_st2_long_intf(hw2_st2_long_intf),
			      .long_hw1_hdr_seq_id(long_hw1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
			      .long_hw2_hdr_seq_id(long_hw2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
			      .long_bl_ism_data	(long_bl_ism_data),
			      .long_bl_ism_vld	(long_bl_ism_vld),
			      
			      .clk		(clk),
			      .rst_n		(rst_n),
			      .ht1_hw1_long_intf(ht1_hw1_long_intf),
			      .ht1_hw1_long_freq_val(ht1_hw1_long_freq_val[1:0]),
			      .ht2_hw2_long_intf(ht2_hw2_long_intf),
			      .ht2_hw2_long_freq_val(ht2_hw2_long_freq_val[1:0]),
			      .hw1_short_hw_long_ready(hw1_short_hw_long_ready),
			      .hw1_short_hw_long_intf(hw1_short_hw_long_intf),
			      .hw2_short_hw_long_ready(hw2_short_hw_long_ready),
			      .hw2_short_hw_long_intf(hw2_short_hw_long_intf),
			      .lut1_hw1_long_full(lut1_hw1_long_full_r), 
			      .lut2_hw2_long_full(lut2_hw2_long_full_r), 
			      .ph_long_hw1_val	(ph_long_hw1_val),
			      .ph_long_hw1_intf	(ph_long_hw1_intf),
			      .ph_long_hw2_val	(ph_long_hw2_val),
			      .ph_long_hw2_intf	(ph_long_hw2_intf),
			      .st1_hw1_long_not_ready(st1_hw1_long_not_ready),
			      .st2_hw2_long_not_ready(st2_hw2_long_not_ready),
			      .hdr_long_hw1_type(hdr_long_hw1_type_r), 
			      .hdr_long_hw2_type(hdr_long_hw2_type_r), 
			      .long_ism_rdy	(long_ism_rdy_r), 
			      .sw_ism_on	(sw_debug_control_r.ism_on)); 


  
 cr_huf_comp_st_short st_short(
			       
			       .st1_hw1_short_not_ready(st1_hw1_short_not_ready_pre), 
			       .st2_hw2_short_not_ready(st2_hw2_short_not_ready_pre), 
			       .st1_lut1_short_wr(st1_lut1_short_wr),
			       .st1_lut1_short_intf(st1_lut1_short_intf),
			       .st2_lut2_short_wr(st2_lut2_short_wr),
			       .st2_lut2_short_intf(st2_lut2_short_intf),
			       .st1_sa_short_size_rdy(st1_sa_short_size_rdy_pre), 
			       .st1_sa_short_table_rdy(st1_sa_short_table_rdy_pre), 
			       .st1_sa_short_intf(st1_sa_short_intf),
			       .st2_sa_short_size_rdy(st2_sa_short_size_rdy_pre), 
			       .st2_sa_short_table_rdy(st2_sa_short_table_rdy_pre), 
			       .st2_sa_short_intf(st2_sa_short_intf),
			       .short_st1_dbg_cntr_rebuild(short_st1_dbg_cntr_rebuild),
			       .short_st1_dbg_cntr_rebuild_failed(short_st1_dbg_cntr_rebuild_failed),
			       .short_st2_dbg_cntr_rebuild(short_st2_dbg_cntr_rebuild),
			       .short_st2_dbg_cntr_rebuild_failed(short_st2_dbg_cntr_rebuild_failed),
			       .st_short_bl_ism_data(st_short_bl_ism_data),
			       .st_short_bl_ism_vld(st_short_bl_ism_vld),
			       .st_short_bimc_odat(st_short_bimc_odat),
			       .st_short_bimc_osync(st_short_bimc_osync),
			       
			       .clk		(clk),
			       .rst_n		(rst_n),
			       .hw1_st1_short_intf(hw1_st1_short_intf),
			       .hw2_st2_short_intf(hw2_st2_short_intf),
			       .lut1_st1_short_full(lut1_st1_short_full_r), 
			       .lut2_st2_short_full(lut2_st2_short_full_r), 
			       .sa_st1_short_read_done(sa_st1_short_read_done_r), 
			       .sa_st2_short_read_done(sa_st2_short_read_done_r), 
			       .sw_short_st1_deflate_max_code_length(sw_st_short_ht_config_r.deflate_max_code_length), 
			       .sw_short_st1_force_rebuild(sw_st_short_ht_config_r.force_rebuild), 
			       .sw_short_st1_max_rebuild_limit(sw_st_short_ht_config_r.max_rebuild_limit), 
			       .sw_short_st1_xp_max_code_length(sw_st_short_ht_config_r.xp_max_code_length), 
			       .sw_short_st2_deflate_max_code_length(sw_st_short_ht_config_r.deflate_max_code_length), 
			       .sw_short_st2_force_rebuild(sw_st_short_ht_config_r.force_rebuild), 
			       .sw_short_st2_max_rebuild_limit(sw_st_short_ht_config_r.max_rebuild_limit), 
			       .sw_short_st2_xp_max_code_length(sw_st_short_ht_config_r.xp_max_code_length), 
			       .st_short_ism_rdy(st_short_ism_rdy_r), 
			       .sw_ism_on	(sw_debug_control_r.ism_on), 
			       .st_short_bimc_idat(st_short_bimc_idat),
			       .st_short_bimc_isync(st_short_bimc_isync),
			       .lvm		(lvm),
			       .mlvm		(mlvm),
			       .mrdten		(mrdten));
 
 cr_huf_comp_st_long st_long(
			     
			     .st1_hw1_long_not_ready(st1_hw1_long_not_ready_pre), 
			     .st2_hw2_long_not_ready(st2_hw2_long_not_ready_pre), 
			     .st1_lut1_long_wr	(st1_lut1_long_wr),
			     .st1_lut1_long_intf(st1_lut1_long_intf),
			     .st2_lut2_long_wr	(st2_lut2_long_wr),
			     .st2_lut2_long_intf(st2_lut2_long_intf),
			     .st1_sa_long_size_rdy(st1_sa_long_size_rdy_pre), 
			     .st1_sa_long_table_rdy(st1_sa_long_table_rdy_pre), 
			     .st1_sa_long_intf	(st1_sa_long_intf),
			     .st2_sa_long_size_rdy(st2_sa_long_size_rdy_pre), 
			     .st2_sa_long_table_rdy(st2_sa_long_table_rdy_pre), 
			     .st2_sa_long_intf	(st2_sa_long_intf),
			     .long_st1_dbg_cntr_rebuild(long_st1_dbg_cntr_rebuild),
			     .long_st1_dbg_cntr_rebuild_failed(long_st1_dbg_cntr_rebuild_failed),
			     .long_st2_dbg_cntr_rebuild(long_st2_dbg_cntr_rebuild),
			     .long_st2_dbg_cntr_rebuild_failed(long_st2_dbg_cntr_rebuild_failed),
			     .st_long_bl_ism_data(st_long_bl_ism_data),
			     .st_long_bl_ism_vld(st_long_bl_ism_vld),
			     .st_long_bimc_odat	(st_long_bimc_odat),
			     .st_long_bimc_osync(st_long_bimc_osync),
			     
			     .clk		(clk),
			     .rst_n		(rst_n),
			     .hw1_st1_long_intf	(hw1_st1_long_intf),
			     .hw2_st2_long_intf	(hw2_st2_long_intf),
			     .lut1_st1_long_full(lut1_st1_long_full_r), 
			     .lut2_st2_long_full(lut2_st2_long_full_r), 
			     .sa_st1_long_read_done(sa_st1_long_read_done_r), 
			     .sa_st2_long_read_done(sa_st2_long_read_done_r), 
			     .sw_long_st1_force_rebuild(sw_st_long_ht_config_r.force_rebuild), 
			     .sw_long_st1_max_rebuild_limit(sw_st_long_ht_config_r.max_rebuild_limit), 
			     .sw_long_st1_xp_max_code_length(sw_st_long_ht_config_r.xp_max_code_length), 
			     .sw_long_st2_force_rebuild(sw_st_long_ht_config_r.force_rebuild), 
			     .sw_long_st2_max_rebuild_limit(sw_st_long_ht_config_r.max_rebuild_limit), 
			     .sw_long_st2_xp_max_code_length(sw_st_long_ht_config_r.xp_max_code_length), 
			     .sw_ism_on		(sw_debug_control_r.ism_on), 
			     .st_long_ism_rdy	(st_long_ism_rdy_r), 
			     .st_long_bimc_idat	(st_long_bimc_idat),
			     .st_long_bimc_isync(st_long_bimc_isync),
			     .lvm		(lvm),
			     .mlvm		(mlvm),
			     .mrdten		(mrdten));
     
  end

end
endgenerate
   

`endif   
   
endmodule 









