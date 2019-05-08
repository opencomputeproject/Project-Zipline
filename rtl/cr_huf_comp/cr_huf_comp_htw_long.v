/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_huf_comp.vh"

module cr_huf_comp_htw_long
  (
   
   hw1_ht1_long_not_ready, hw1_ht1_long_intf, hw2_ht2_long_not_ready,
   hw2_ht2_long_intf, hw1_long_hw_short_val, hw1_long_hw_short_intf,
   hw2_long_hw_short_val, hw2_long_hw_short_intf, hw1_lut1_long_wr,
   hw1_lut1_long_intf, hw2_lut2_long_wr, hw2_lut2_long_intf,
   long_hw1_ph_intf, long_hw2_ph_intf, hw1_st1_long_intf,
   hw2_st2_long_intf, long_hw1_hdr_seq_id, long_hw2_hdr_seq_id,
   long_bl_ism_data, long_bl_ism_vld,
   
   clk, rst_n, ht1_hw1_long_intf, ht1_hw1_long_freq_val,
   ht2_hw2_long_intf, ht2_hw2_long_freq_val, hw1_short_hw_long_ready,
   hw1_short_hw_long_intf, hw2_short_hw_long_ready,
   hw2_short_hw_long_intf, lut1_hw1_long_full, lut2_hw2_long_full,
   ph_long_hw1_val, ph_long_hw1_intf, ph_long_hw2_val,
   ph_long_hw2_intf, st1_hw1_long_not_ready, st2_hw2_long_not_ready,
   hdr_long_hw1_type, hdr_long_hw2_type, long_ism_rdy, sw_ism_on
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

  `ifdef THESE_AUTOS_SHOULD_BE_EMPTY
   
   
  `endif
 
 
 
 input			                        clk;
 input			                        rst_n;
 
 
 

 
 input s_ht_hw_long_intf                        ht1_hw1_long_intf;
 input [1:0]		                        ht1_hw1_long_freq_val;

 
 input s_ht_hw_long_intf                        ht2_hw2_long_intf;
 input [1:0]		                        ht2_hw2_long_freq_val;

 
 input                                          hw1_short_hw_long_ready;
 input s_hw_short_hw_long_intf                  hw1_short_hw_long_intf;

 
 input                                          hw2_short_hw_long_ready;
 input s_hw_short_hw_long_intf                  hw2_short_hw_long_intf;

 
 input                                          lut1_hw1_long_full;

 
 input                                          lut2_hw2_long_full;    
   
 
 input                                          ph_long_hw1_val;
 input s_ph_hw_intf                             ph_long_hw1_intf;

 
 input                                          ph_long_hw2_val;
 input s_ph_hw_intf                             ph_long_hw2_intf;
   
 
 input                                          st1_hw1_long_not_ready;

 
 input                                          st2_hw2_long_not_ready;  
   
 
 input s_seq_id_type_intf	                hdr_long_hw1_type;
 input s_seq_id_type_intf	                hdr_long_hw2_type;

 
 input		                                long_ism_rdy;
 input		                                sw_ism_on;
   
 
 
 

 
 output                                         hw1_ht1_long_not_ready;
 output s_hw_ht_long_intf                       hw1_ht1_long_intf;

 
 output                                         hw2_ht2_long_not_ready;
 output s_hw_ht_long_intf                       hw2_ht2_long_intf;
   
 
 output [1:0]                                   hw1_long_hw_short_val;
 output s_hw_long_hw_short_intf                 hw1_long_hw_short_intf; 

 
 output [1:0]                                   hw2_long_hw_short_val; 
 output s_hw_long_hw_short_intf                 hw2_long_hw_short_intf;     

 
 output                                         hw1_lut1_long_wr;
 output s_hw_lut_intf                           hw1_lut1_long_intf;

 
 output                                         hw2_lut2_long_wr;
 output s_hw_lut_intf                           hw2_lut2_long_intf; 

 
 output s_hw_ph_intf                            long_hw1_ph_intf;

 
 output s_hw_ph_intf                            long_hw2_ph_intf;

 
 output s_long_hw_st_intf                       hw1_st1_long_intf;

 
 output s_long_hw_st_intf                       hw2_st2_long_intf;

 
 output [`CREOLE_HC_SEQID_WIDTH-1:0]            long_hw1_hdr_seq_id;
 output [`CREOLE_HC_SEQID_WIDTH-1:0]            long_hw2_hdr_seq_id;

 
 output lng_bl_t	                        long_bl_ism_data;
 output		                                long_bl_ism_vld;
 
   
 
 
 logic			hw1_long_hw_short_intf_build_error;
 logic [1:0] [(`CREOLE_HC_SYM_CODELENGTH)-1:0] hw1_long_hw_short_intf_codes;
 logic			hw1_long_hw_short_intf_last;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0] hw1_long_hw_short_intf_seq_id;
 logic			hw1_long_hw_short_intf_seq_id_val;
 logic [19:0]		hw1_lut1_long_intf_pre_size;
 logic [19:0]		hw1_lut1_long_intf_ret_size;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0] hw1_lut1_long_intf_seq_id;
 logic [19:0]		hw1_lut1_long_intf_sim_size;
 logic			hw1_lut1_long_intf_sizes_val;
 logic [127:0]		hw1_lut1_long_intf_wr_data;
 logic			hw1_lut1_long_intf_wr_done;
 logic [1:0]		hw1_lut1_long_intf_wr_val;
 logic			hw1_stsg1_build_error;	
 e_pipe_eob		hw1_stsg1_eob;		
 logic [(`CREOLE_HC_LONG_DAT_WIDTH):0] hw1_stsg1_max_sym_table;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0] hw1_stsg1_seq_id;
 logic [(`CREOLE_HC_LONG_DAT_WIDTH)-1:0] hw1_stsg1_sym_hi_b;
 logic [(`CREOLE_HC_LONG_NUM_MAX_SYM_USED)-1:0] [(`CREOLE_HC_SYM_CODELENGTH)-1:0] hw1_stsg1_symbol;
 logic [(`CREOLE_HC_LONG_NUM_MAX_SYM_USED)-1:0] hw1_stsg1_val;
 logic			hw2_long_hw_short_intf_build_error;
 logic [1:0] [(`CREOLE_HC_SYM_CODELENGTH)-1:0] hw2_long_hw_short_intf_codes;
 logic			hw2_long_hw_short_intf_last;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0] hw2_long_hw_short_intf_seq_id;
 logic			hw2_long_hw_short_intf_seq_id_val;
 logic [19:0]		hw2_lut2_long_intf_pre_size;
 logic [19:0]		hw2_lut2_long_intf_ret_size;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0] hw2_lut2_long_intf_seq_id;
 logic [19:0]		hw2_lut2_long_intf_sim_size;
 logic			hw2_lut2_long_intf_sizes_val;
 logic [127:0]		hw2_lut2_long_intf_wr_data;
 logic			hw2_lut2_long_intf_wr_done;
 logic [1:0]		hw2_lut2_long_intf_wr_val;
 logic			hw2_stsg2_build_error;	
 e_pipe_eob		hw2_stsg2_eob;		
 logic [(`CREOLE_HC_LONG_DAT_WIDTH):0] hw2_stsg2_max_sym_table;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0] hw2_stsg2_seq_id;
 logic [(`CREOLE_HC_LONG_DAT_WIDTH)-1:0] hw2_stsg2_sym_hi_b;
 logic [(`CREOLE_HC_LONG_NUM_MAX_SYM_USED)-1:0] [(`CREOLE_HC_SYM_CODELENGTH)-1:0] hw2_stsg2_symbol;
 logic [(`CREOLE_HC_LONG_NUM_MAX_SYM_USED)-1:0] hw2_stsg2_val;
 
 

 logic [`CREOLE_HC_LONG_DAT_WIDTH-2:0]          hw1_lut1_wr_addr;
 logic [`CREOLE_HC_LONG_DAT_WIDTH-2:0]          hw2_lut2_wr_addr;  
 logic                                          hw_short_hw1_long_ready;
 logic                                          hw_short_hw2_long_ready;   
 s_hw_short_hw_long_intf                        hw_short_hw1_long_intf;
 s_hw_short_hw_long_intf                        hw_short_hw2_long_intf;
 logic                                          stsg1_hw1_not_ready;
 logic                                          stsg2_hw2_not_ready;
 logic [`CREOLE_HC_LONG_DAT_WIDTH-1:0]          hw1_sym_hi,hw2_sym_hi;  

 
 
 

always_comb
begin
   hw1_lut1_long_intf.addr         = {{`CREOLE_HC_SHORT_DAT_WIDTH-`CREOLE_HC_LONG_DAT_WIDTH{1'b0}},hw1_lut1_wr_addr};
   hw1_lut1_long_intf.wr_val       = hw1_lut1_long_intf_wr_val;
   hw1_lut1_long_intf.wr_done      = hw1_lut1_long_intf_wr_done;
   hw1_lut1_long_intf.wr_data      = hw1_lut1_long_intf_wr_data;
   hw1_lut1_long_intf.sizes_val    = hw1_lut1_long_intf_sizes_val;
   hw1_lut1_long_intf.ret_size     = hw1_lut1_long_intf_ret_size;
   hw1_lut1_long_intf.pre_size     = hw1_lut1_long_intf_pre_size;
   hw1_lut1_long_intf.sim_size     = hw1_lut1_long_intf_sim_size;
   hw1_lut1_long_intf.seq_id       = hw1_lut1_long_intf_seq_id;
   
   hw2_lut2_long_intf.addr         = {{`CREOLE_HC_SHORT_DAT_WIDTH-`CREOLE_HC_LONG_DAT_WIDTH{1'b0}},hw2_lut2_wr_addr};
   hw2_lut2_long_intf.wr_val       = hw2_lut2_long_intf_wr_val;
   hw2_lut2_long_intf.wr_done      = hw2_lut2_long_intf_wr_done;
   hw2_lut2_long_intf.wr_data      = hw2_lut2_long_intf_wr_data;
   hw2_lut2_long_intf.sizes_val    = hw2_lut2_long_intf_sizes_val;
   hw2_lut2_long_intf.ret_size     = hw2_lut2_long_intf_ret_size;
   hw2_lut2_long_intf.pre_size     = hw2_lut2_long_intf_pre_size;
   hw2_lut2_long_intf.sim_size     = hw2_lut2_long_intf_sim_size;
   hw2_lut2_long_intf.seq_id       = hw2_lut2_long_intf_seq_id;
   
   hw1_long_hw_short_intf.sym_high = {{`CREOLE_HC_SHORT_DAT_WIDTH-`CREOLE_HC_LONG_DAT_WIDTH{1'b0}},hw1_sym_hi};
   hw1_long_hw_short_intf.seq_id_val = hw1_long_hw_short_intf_seq_id_val;
   hw1_long_hw_short_intf.seq_id   = hw1_long_hw_short_intf_seq_id;
   hw1_long_hw_short_intf.codes    = hw1_long_hw_short_intf_codes;
   hw1_long_hw_short_intf.last     = hw1_long_hw_short_intf_last;
   hw1_long_hw_short_intf.build_error = hw1_long_hw_short_intf_build_error;
   
   hw2_long_hw_short_intf.sym_high = {{`CREOLE_HC_SHORT_DAT_WIDTH-`CREOLE_HC_LONG_DAT_WIDTH{1'b0}},hw2_sym_hi};
   hw2_long_hw_short_intf.seq_id_val = hw2_long_hw_short_intf_seq_id_val;
   hw2_long_hw_short_intf.seq_id   = hw2_long_hw_short_intf_seq_id;
   hw2_long_hw_short_intf.codes    = hw2_long_hw_short_intf_codes;
   hw2_long_hw_short_intf.last     = hw2_long_hw_short_intf_last;
   hw2_long_hw_short_intf.build_error = hw2_long_hw_short_intf_build_error;
end  


always_comb
begin
     
     
     if(hw1_long_hw_short_intf_seq_id_val && hw1_short_hw_long_intf.seq_id_val && hw1_short_hw_long_intf.seq_id == hw1_long_hw_short_intf_seq_id)
     begin
	  hw_short_hw1_long_ready  = hw1_short_hw_long_ready;
          hw_short_hw1_long_intf = hw1_short_hw_long_intf;
     end
     else if(hw1_long_hw_short_intf_seq_id_val && hw2_short_hw_long_intf.seq_id_val && hw2_short_hw_long_intf.seq_id == hw1_long_hw_short_intf_seq_id)
     begin
          hw_short_hw1_long_ready  = hw2_short_hw_long_ready;	  
          hw_short_hw1_long_intf = hw2_short_hw_long_intf;
     end
     else
     begin
	  hw_short_hw1_long_ready  = 0;	  
          hw_short_hw1_long_intf = 0;
     end
     
     if(hw2_long_hw_short_intf_seq_id_val && hw1_short_hw_long_intf.seq_id_val && hw1_short_hw_long_intf.seq_id == hw2_long_hw_short_intf_seq_id)
     begin
          hw_short_hw2_long_ready = hw1_short_hw_long_ready;	  
          hw_short_hw2_long_intf = hw1_short_hw_long_intf;
     end
     else if(hw2_long_hw_short_intf_seq_id_val && hw2_short_hw_long_intf.seq_id_val && hw2_short_hw_long_intf.seq_id == hw2_long_hw_short_intf_seq_id)
     begin
          hw_short_hw2_long_ready = hw2_short_hw_long_ready;	  
          hw_short_hw2_long_intf = hw2_short_hw_long_intf;
     end
     else
     begin
          hw_short_hw2_long_ready = 0; 	   
          hw_short_hw2_long_intf = 0;
     end
end  
   

 

    cr_huf_comp_htw_type_b
    #(
      .DAT_WIDTH        (`CREOLE_HC_LONG_DAT_WIDTH),       
      .SYM_FREQ_WIDTH   (`CREOLE_HC_LONG_FREQ_WIDTH),      
      .SYM_ADDR_WIDTH   (`CREOLE_HC_LONG_SYM_ADDR_WIDTH),  
      .CODELENGTH_WIDTH (`CREOLE_HC_SYM_CODELENGTH),
      .MAX_NUM_SYM_USED (`CREOLE_HC_LONG_NUM_MAX_SYM_USED)  
     )
    tree_walker_inst1 (
		       
		       .hw_ht_sym_freq_rd(hw1_ht1_long_intf.sym_freq_rd), 
		       .hw_ht_sym_freq_seq_id(hw1_ht1_long_intf.seq_id), 
		       .hw_ht_sym_freq_rd_addr(hw1_ht1_long_intf.sym_freq_addr[(`CREOLE_HC_LONG_SYM_ADDR_WIDTH)-2:0]), 
		       .hw_ht_sym_freq_rd_done(hw1_ht1_long_intf.rd_done), 
		       .hw_ht_not_ready	(hw1_ht1_long_not_ready), 
		       .hw_hw_seq_id_val(hw1_long_hw_short_intf_seq_id_val), 
		       .hw_hw_seq_id_out(hw1_long_hw_short_intf_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
		       .hw_hw_val_out	(hw1_long_hw_short_val[1:0]), 
		       .hw_hw_codes_out	(hw1_long_hw_short_intf_codes), 
		       .hw_hw_last_out	(hw1_long_hw_short_intf_last), 
		       .hw_hw_sym_hi_out(hw1_sym_hi),		 
		       .hw_hw_build_error_out(hw1_long_hw_short_intf_build_error), 
		       .hw_lut_wr	(hw1_lut1_long_wr),	 
		       .hw_lut_wr_addr	(hw1_lut1_wr_addr),	 
		       .hw_lut_wr_val	(hw1_lut1_long_intf_wr_val[1:0]), 
		       .hw_lut_wr_data	(hw1_lut1_long_intf_wr_data[127:0]), 
		       .hw_lut_wr_done	(hw1_lut1_long_intf_wr_done), 
		       .hw_lut_sizes_val(hw1_lut1_long_intf_sizes_val), 
		       .hw_lut_ret_size	(hw1_lut1_long_intf_ret_size[19:0]), 
		       .hw_lut_pre_size	(hw1_lut1_long_intf_pre_size[19:0]), 
		       .hw_lut_sim_size	(hw1_lut1_long_intf_sim_size[19:0]), 
		       .hw_lut_seq_id	(hw1_lut1_long_intf_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
		       .hw_ph_seq_id	(long_hw1_ph_intf.seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
		       .hw_ph_sym_addr	(long_hw1_ph_intf.addr[5:0]), 
		       .hw_ph_rd	(long_hw1_ph_intf.rd),	 
		       .hw_stsg_val	(hw1_stsg1_val[(`CREOLE_HC_LONG_NUM_MAX_SYM_USED)-1:0]), 
		       .hw_stsg_symbol	(hw1_stsg1_symbol), 
		       .hw_stsg_seq_id	(hw1_stsg1_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
		       .hw_stsg_eob	(hw1_stsg1_eob),	 
		       .hw_stsg_build_error(hw1_stsg1_build_error), 
		       .hw_stsg_sym_hi_b(hw1_stsg1_sym_hi_b[(`CREOLE_HC_LONG_DAT_WIDTH)-1:0]), 
		       .hw_stsg_max_sym_table(hw1_stsg1_max_sym_table[(`CREOLE_HC_LONG_DAT_WIDTH):0]), 
		       .hw_hdr_seq_id	(long_hw1_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
		       .long_bl_ism_data(long_bl_ism_data),
		       .long_bl_ism_vld	(long_bl_ism_vld),
		       
		       .clk		(clk),			 
		       .rst_n		(rst_n),		 
		       .ht_hw_sym_lo	(ht1_hw1_long_intf.sym_lo[(`CREOLE_HC_LONG_DAT_WIDTH)-1:0]), 
		       .ht_hw_sym_hi	(ht1_hw1_long_intf.sym_hi[(`CREOLE_HC_LONG_DAT_WIDTH)-1:0]), 
		       .ht_hw_sym_sort_freq(ht1_hw1_long_intf.sym_freq[((`CREOLE_HC_LONG_FREQ_WIDTH)*2)-1:0]), 
		       .ht_hw_sym_sort_freq_val(ht1_hw1_long_freq_val[1:0]), 
		       .ht_hw_sym_dpth	(ht1_hw1_long_intf.sym_dpth), 
		       .ht_hw_zero_symbols(ht1_hw1_long_intf.zero_symbols), 
		       .ht_hw_build_error(ht1_hw1_long_intf.build_error), 
		       .ht_hw_seq_id	(ht1_hw1_long_intf.seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
		       .ht_hw_eob	(ht1_hw1_long_intf.eob), 
		       .ht_hw_sym_unique(ht1_hw1_long_intf.sym_unique), 
		       .hw_hw_ready_in	(hw_short_hw1_long_ready), 
		       .hw_hw_abort_in	(hw_short_hw1_long_intf.abort), 
		       .lut_hw_full	(lut1_hw1_long_full),	 
		       .ph_hw_sym_val	(ph_long_hw1_val),	 
		       .ph_hw_sym_dpth	(ph_long_hw1_intf.dpth[`CREOLE_HC_PHT_WIDTH-1:0]), 
		       .stsg_hw_not_ready(stsg1_hw1_not_ready),	 
		       .hdr_hw_type	(hdr_long_hw1_type),	 
		       .sw_ism_on	(sw_ism_on),
		       .long_ism_rdy	(long_ism_rdy));




 cr_huf_comp_htw_stsg
    #(
      .DAT_WIDTH        (`CREOLE_HC_LONG_DAT_WIDTH),
      .CODELENGTH_WIDTH (`CREOLE_HC_SYM_CODELENGTH),
      .MAX_NUM_SYM_USED (`CREOLE_HC_LONG_NUM_MAX_SYM_USED),
      .MAX_ST_ENTRIES_USED (`MAX_LONG_ST_ENTRIES_USED) 
     )
   st_symbol_gen_inst1 (
			
			.stsg_st_val	(hw1_st1_long_intf.val), 
			.stsg_st_symbol	(hw1_st1_long_intf.symbol), 
			.stsg_st_extra	(hw1_st1_long_intf.extra), 
			.stsg_st_extra_length(hw1_st1_long_intf.extra_length), 
			.stsg_st_last_ptr(hw1_st1_long_intf.last_ptr), 
			.stsg_st_extra_size(hw1_st1_long_intf.extra_size), 
			.stsg_st_seq_id	(hw1_st1_long_intf.seq_id), 
			.stsg_st_hlit	(hw1_st1_long_intf.hlit), 
			.stsg_st_hdist	(hw1_st1_long_intf.hdist), 
			.stsg_st_deflate(hw1_st1_long_intf.deflate), 
			.stsg_st_eob	(hw1_st1_long_intf.eob), 
			.stsg_st_build_error(hw1_st1_long_intf.build_error), 
			.stsg_hw_not_ready(stsg1_hw1_not_ready), 
			
			.clk		(clk),			 
			.rst_n		(rst_n),		 
			.st_stsg_not_ready(st1_hw1_long_not_ready), 
			.hw_stsg_val	(hw1_stsg1_val[(`CREOLE_HC_LONG_NUM_MAX_SYM_USED)-1:0]), 
			.hw_stsg_symbol	(hw1_stsg1_symbol), 
			.hw_stsg_seq_id	(hw1_stsg1_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
			.hw_stsg_eob	(hw1_stsg1_eob),	 
			.hw_stsg_build_error(hw1_stsg1_build_error), 
			.hw_stsg_sym_hi_a(hw1_stsg1_sym_hi_b[(`CREOLE_HC_LONG_DAT_WIDTH)-1:0]), 
			.hw_stsg_sym_hi_b(hw1_stsg1_sym_hi_b[(`CREOLE_HC_LONG_DAT_WIDTH)-1:0]), 
			.hw_stsg_deflate_mode(1'b0),		 
			.hw_stsg_max_sym_table(hw1_stsg1_max_sym_table[(`CREOLE_HC_LONG_DAT_WIDTH):0])); 
   
 
 

    cr_huf_comp_htw_type_b
    #(
      .DAT_WIDTH        (`CREOLE_HC_LONG_DAT_WIDTH),       
      .SYM_FREQ_WIDTH   (`CREOLE_HC_LONG_FREQ_WIDTH),      
      .SYM_ADDR_WIDTH   (`CREOLE_HC_LONG_SYM_ADDR_WIDTH),  
      .CODELENGTH_WIDTH (`CREOLE_HC_SYM_CODELENGTH),
      .MAX_NUM_SYM_USED (`CREOLE_HC_LONG_NUM_MAX_SYM_USED)  
     )
    tree_walker_inst2 (
		       
		       .hw_ht_sym_freq_rd(hw2_ht2_long_intf.sym_freq_rd), 
		       .hw_ht_sym_freq_seq_id(hw2_ht2_long_intf.seq_id), 
		       .hw_ht_sym_freq_rd_addr(hw2_ht2_long_intf.sym_freq_addr[(`CREOLE_HC_LONG_SYM_ADDR_WIDTH)-2:0]), 
		       .hw_ht_sym_freq_rd_done(hw2_ht2_long_intf.rd_done), 
		       .hw_ht_not_ready	(hw2_ht2_long_not_ready), 
		       .hw_hw_seq_id_val(hw2_long_hw_short_intf_seq_id_val), 
		       .hw_hw_seq_id_out(hw2_long_hw_short_intf_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
		       .hw_hw_val_out	(hw2_long_hw_short_val[1:0]), 
		       .hw_hw_codes_out	(hw2_long_hw_short_intf_codes), 
		       .hw_hw_last_out	(hw2_long_hw_short_intf_last), 
		       .hw_hw_sym_hi_out(hw2_sym_hi),		 
		       .hw_hw_build_error_out(hw2_long_hw_short_intf_build_error), 
		       .hw_lut_wr	(hw2_lut2_long_wr),	 
		       .hw_lut_wr_addr	(hw2_lut2_wr_addr),	 
		       .hw_lut_wr_val	(hw2_lut2_long_intf_wr_val[1:0]), 
		       .hw_lut_wr_data	(hw2_lut2_long_intf_wr_data[127:0]), 
		       .hw_lut_wr_done	(hw2_lut2_long_intf_wr_done), 
		       .hw_lut_sizes_val(hw2_lut2_long_intf_sizes_val), 
		       .hw_lut_ret_size	(hw2_lut2_long_intf_ret_size[19:0]), 
		       .hw_lut_pre_size	(hw2_lut2_long_intf_pre_size[19:0]), 
		       .hw_lut_sim_size	(hw2_lut2_long_intf_sim_size[19:0]), 
		       .hw_lut_seq_id	(hw2_lut2_long_intf_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
		       .hw_ph_seq_id	(long_hw2_ph_intf.seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
		       .hw_ph_sym_addr	(long_hw2_ph_intf.addr[5:0]), 
		       .hw_ph_rd	(long_hw2_ph_intf.rd),	 
		       .hw_stsg_val	(hw2_stsg2_val[(`CREOLE_HC_LONG_NUM_MAX_SYM_USED)-1:0]), 
		       .hw_stsg_symbol	(hw2_stsg2_symbol), 
		       .hw_stsg_seq_id	(hw2_stsg2_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
		       .hw_stsg_eob	(hw2_stsg2_eob),	 
		       .hw_stsg_build_error(hw2_stsg2_build_error), 
		       .hw_stsg_sym_hi_b(hw2_stsg2_sym_hi_b[(`CREOLE_HC_LONG_DAT_WIDTH)-1:0]), 
		       .hw_stsg_max_sym_table(hw2_stsg2_max_sym_table[(`CREOLE_HC_LONG_DAT_WIDTH):0]), 
		       .hw_hdr_seq_id	(long_hw2_hdr_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
		       .long_bl_ism_data(),			 
		       .long_bl_ism_vld	(),			 
		       
		       .clk		(clk),			 
		       .rst_n		(rst_n),		 
		       .ht_hw_sym_lo	(ht2_hw2_long_intf.sym_lo[(`CREOLE_HC_LONG_DAT_WIDTH)-1:0]), 
		       .ht_hw_sym_hi	(ht2_hw2_long_intf.sym_hi[(`CREOLE_HC_LONG_DAT_WIDTH)-1:0]), 
		       .ht_hw_sym_sort_freq(ht2_hw2_long_intf.sym_freq[((`CREOLE_HC_LONG_FREQ_WIDTH)*2)-1:0]), 
		       .ht_hw_sym_sort_freq_val(ht2_hw2_long_freq_val[1:0]), 
		       .ht_hw_sym_dpth	(ht2_hw2_long_intf.sym_dpth), 
		       .ht_hw_zero_symbols(ht2_hw2_long_intf.zero_symbols), 
		       .ht_hw_build_error(ht2_hw2_long_intf.build_error), 
		       .ht_hw_seq_id	(ht2_hw2_long_intf.seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
		       .ht_hw_eob	(ht2_hw2_long_intf.eob), 
		       .ht_hw_sym_unique(ht2_hw2_long_intf.sym_unique), 
		       .hw_hw_ready_in	(hw_short_hw2_long_ready), 
		       .hw_hw_abort_in	(hw_short_hw2_long_intf.abort), 
		       .lut_hw_full	(lut2_hw2_long_full),	 
		       .ph_hw_sym_val	(ph_long_hw2_val),	 
		       .ph_hw_sym_dpth	(ph_long_hw2_intf.dpth[`CREOLE_HC_PHT_WIDTH-1:0]), 
		       .stsg_hw_not_ready(stsg2_hw2_not_ready),	 
		       .hdr_hw_type	(hdr_long_hw2_type),	 
		       .sw_ism_on	(1'b0),			 
		       .long_ism_rdy	(1'b0));			 


 

 cr_huf_comp_htw_stsg
    #(
      .DAT_WIDTH        (`CREOLE_HC_LONG_DAT_WIDTH),
      .CODELENGTH_WIDTH (`CREOLE_HC_SYM_CODELENGTH),
      .MAX_NUM_SYM_USED (`CREOLE_HC_LONG_NUM_MAX_SYM_USED),
      .MAX_ST_ENTRIES_USED (`MAX_LONG_ST_ENTRIES_USED)  
     )
   st_symbol_gen_inst2 (
			
			.stsg_st_val	(hw2_st2_long_intf.val), 
			.stsg_st_symbol	(hw2_st2_long_intf.symbol), 
			.stsg_st_extra	(hw2_st2_long_intf.extra), 
			.stsg_st_extra_length(hw2_st2_long_intf.extra_length), 
			.stsg_st_last_ptr(hw2_st2_long_intf.last_ptr), 
			.stsg_st_extra_size(hw2_st2_long_intf.extra_size), 
			.stsg_st_seq_id	(hw2_st2_long_intf.seq_id), 
			.stsg_st_hlit	(hw2_st2_long_intf.hlit), 
			.stsg_st_hdist	(hw2_st2_long_intf.hdist), 
			.stsg_st_deflate(hw2_st2_long_intf.deflate), 
			.stsg_st_eob	(hw2_st2_long_intf.eob), 
			.stsg_st_build_error(hw2_st2_long_intf.build_error), 
			.stsg_hw_not_ready(stsg2_hw2_not_ready), 
			
			.clk		(clk),			 
			.rst_n		(rst_n),		 
			.st_stsg_not_ready(st2_hw2_long_not_ready), 
			.hw_stsg_val	(hw2_stsg2_val[(`CREOLE_HC_LONG_NUM_MAX_SYM_USED)-1:0]), 
			.hw_stsg_symbol	(hw2_stsg2_symbol), 
			.hw_stsg_seq_id	(hw2_stsg2_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
			.hw_stsg_eob	(hw2_stsg2_eob),	 
			.hw_stsg_build_error(hw2_stsg2_build_error), 
			.hw_stsg_sym_hi_a(hw2_stsg2_sym_hi_b[(`CREOLE_HC_LONG_DAT_WIDTH)-1:0]), 
			.hw_stsg_sym_hi_b(hw2_stsg2_sym_hi_b[(`CREOLE_HC_LONG_DAT_WIDTH)-1:0]), 
			.hw_stsg_deflate_mode(1'b0),		 
			.hw_stsg_max_sym_table(hw2_stsg2_max_sym_table[(`CREOLE_HC_LONG_DAT_WIDTH):0])); 

 

endmodule 








