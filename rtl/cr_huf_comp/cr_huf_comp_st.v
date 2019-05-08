/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/












`include "cr_huf_comp.vh"

module cr_huf_comp_st
   #(parameter
    DAT_WIDTH        =10,       
    MAX_SYMBOL_TABLE_DEPTH =584 
   )
  (
   
   st_hw_not_ready, st_lut_wr, st_lut_wr_type, st_lut_wr_data,
   st_lut_wr_addr, st_lut_wr_done, st_lut_sizes_val, st_lut_seq_id,
   st_lut_stcl_size, st_lut_st_size, st_lut_hclen, st_lut_hlit,
   st_lut_hdist, st_sa_size_rdy, st_sa_size_seq_id, st_sa_eob,
   st_sa_build_error, st_sa_table_rdy, st_dbg_cntr_rebuild,
   st_dbg_cntr_rebuild_failed, st_bl_ism_data, st_bl_ism_vld,
   bimc_odat, bimc_osync,
   
   clk, rst_n, hw_st_val, hw_st_symbol, hw_st_extra,
   hw_st_extra_length, hw_st_last_ptr, hw_st_extra_size, hw_st_seq_id,
   hw_st_hlit, hw_st_hdist, hw_st_deflate, hw_st_eob,
   hw_st_build_error, lut_st_full, sa_st_read_done,
   sw_st_xp_max_code_length, sw_st_deflate_max_code_length,
   sw_st_max_rebuild_limit, sw_st_force_rebuild, sw_ism_on,
   st_ism_rdy, bimc_idat, bimc_isync, lvm, mlvm, mrdten
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

 
 
 
 input                                        clk;
 input                                        rst_n; 
 
 
 
 
 
 input [MAX_SYMBOL_TABLE_DEPTH-1:0]          hw_st_val;   
 input [MAX_SYMBOL_TABLE_DEPTH-1:0][`CREOLE_HC_ST_SYMB_WIDTH-1:0]   hw_st_symbol;
 input [MAX_SYMBOL_TABLE_DEPTH-1:0][7:0]     hw_st_extra; 
 input [MAX_SYMBOL_TABLE_DEPTH-1:0][3:0]     hw_st_extra_length;
 input [DAT_WIDTH-1:0]                       hw_st_last_ptr;         
 input [`CREOLE_HC_SMALL_TABLE_XTR_BIT_SIZE:0] hw_st_extra_size;
 input [`CREOLE_HC_SEQID_WIDTH-1:0]          hw_st_seq_id;
 input [`CREOLE_HC_HLIT_WIDTH-1:0] 	     hw_st_hlit;  
 input [`CREOLE_HC_HDIST_WIDTH-1:0] 	     hw_st_hdist; 
 input                                       hw_st_deflate;
 input e_pipe_eob                            hw_st_eob;     
                                                            
                                                            
                                                            
                                                            
 input                                       hw_st_build_error;
                                                               
                                                               
   
 
 
 input                                       lut_st_full;

 
 input                                       sa_st_read_done;
                                                             
                                                             
                                                             
                                                             

  
 input [`CREOLE_HC_ST_SYM_CODELENGTH-1:0]    sw_st_xp_max_code_length;
 input [`CREOLE_HC_ST_SYM_CODELENGTH-1:0]    sw_st_deflate_max_code_length;
 input [9:0]  	                             sw_st_max_rebuild_limit;
 input [`CR_HUF_COMP_HT_CONFIG_T_FORCE_REBUILD_DECL] sw_st_force_rebuild;

 input                                       sw_ism_on;
 input                                       st_ism_rdy;

 input		                             bimc_idat;
 input		                             bimc_isync;
 input		                             lvm;	
 input		                             mlvm;	
 input		                             mrdten;	

 
 
 

 
 output logic				    st_hw_not_ready;

 
 output logic                               st_lut_wr;      
 output logic                               st_lut_wr_type; 
                                                            
 output logic [`CREOLE_HC_HDR_WIDTH-1:0]    st_lut_wr_data; 
 output logic [`LOG_VEC(`CREOLE_HC_ST_MAX_BITS/`CREOLE_HC_HDR_WIDTH)] st_lut_wr_addr; 
 output logic                               st_lut_wr_done;
 output logic                               st_lut_sizes_val;
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]  st_lut_seq_id;  
 output logic [`CREOLE_HC_STCL_MAX_BITS_WIDTH-1:0] st_lut_stcl_size;
 output logic [`CREOLE_HC_ST_MAX_BITS_WIDTH-1:0] st_lut_st_size;  
 output logic [`CREOLE_HC_HCLEN_WIDTH-1:0]  st_lut_hclen;    
 output logic [`CREOLE_HC_HLIT_WIDTH-1:0]   st_lut_hlit;     
 output	logic [`CREOLE_HC_HDIST_WIDTH-1:0]  st_lut_hdist;    

 
 output logic                               st_sa_size_rdy;
                                                           
                                                           
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]  st_sa_size_seq_id;
 output e_pipe_eob                          st_sa_eob;
                                                      
                                                      
                                                      
                                                      
 output logic                               st_sa_build_error;
                                                              
                                                              
 output logic                               st_sa_table_rdy;
                                                            
                                                            
  

 output logic                               st_dbg_cntr_rebuild;
 output logic                               st_dbg_cntr_rebuild_failed;

 
 output st_sh_bl_t		            st_bl_ism_data;
 output			                    st_bl_ism_vld;

 output logic		                    bimc_odat;
 output logic		                    bimc_osync; 

 
 
 s_seq_id_type_intf	hdr_ht_type_mod,hdr_ht_type_mod_r;	
 logic			ht_hw_build_error;	
 e_pipe_eob		ht_hw_eob;		
 logic [0:0]		ht_hw_meta;		
 logic [`CREOLE_HC_SEQID_WIDTH-1:0] ht_hw_seq_id;
 logic [(`CREOLE_HC_ST_SYMB_DEPTH)-1:0] [(`CREOLE_HC_ST_SYM_CODELENGTH)-1:0] ht_hw_sym_dpth;
 logic [(`CREOLE_HC_ST_SYMB_WIDTH)-1:0] ht_hw_sym_hi;
 logic [(`CREOLE_HC_ST_SYMB_WIDTH)-1:0] ht_hw_sym_lo;
 logic [((`CREOLE_HC_ST_SYMB_FREQ_WIDTH)*2)-1:0] ht_hw_sym_sort_freq;
 logic [1:0]		ht_hw_sym_sort_freq_val;
 logic			ht_hw_zero_symbols;	
 logic			ht_is_not_ready;	
 logic			hw_ht_not_ready;	
 logic			hw_ht_sym_freq_rd;	
 logic [($clog2(`CREOLE_HC_MAX_ST_TABLE_SIZE))-2:0] hw_ht_sym_freq_rd_addr;
 logic			hw_ht_sym_freq_rd_done;	
 logic [`CREOLE_HC_SEQID_WIDTH-1:0] hw_ht_sym_freq_seq_id;
 e_pipe_eob		is_ht_eob;		
 wire [0:0]		is_ht_meta;		
 wire [`CREOLE_HC_SEQID_WIDTH-1:0] is_ht_seq_id;
 wire [(`CREOLE_HC_ST_SYMB_WIDTH)-1:0] is_ht_sym_hi;
 wire [(`CREOLE_HC_ST_SYMB_WIDTH)-1:0] is_ht_sym_lo;
 wire [(`CREOLE_HC_ST_SYMB_DEPTH)-1:0] [(`CREOLE_HC_ST_SYMB_FREQ_WIDTH)-1:0] is_ht_sym_sort_freq;
 wire [(`CREOLE_HC_ST_SYMB_DEPTH)-1:0] [(`CREOLE_HC_ST_SYMB_WIDTH)-1:0] is_ht_sym_sort_freq_sym;
 wire [(`CREOLE_HC_ST_SYMB_WIDTH)-1:0] is_ht_sym_unique;
 wire			is_sc_rd;		
 logic			sc_is_build_error;	
 logic [3:0] [2:0]	sc_is_cnt;		
 e_pipe_eob		sc_is_eob;		
 logic [`CREOLE_HC_SEQID_WIDTH-1:0] sc_is_seq_id;
 logic [3:0] [`CREOLE_HC_ST_SYMB_WIDTH-1:0] sc_is_symbol;
 logic [3:0]		sc_is_vld;		
 logic			st_build_error;		
 e_st_state		st_curr_st;		
 logic			st_deflate_store;	
 e_pipe_eob		st_eob;			
 logic [`CREOLE_HC_SMALL_TABLE_XTR_BIT_SIZE:0] st_extra_size_store;
 logic [`CREOLE_HC_HDIST_WIDTH-1:0] st_hdist_store;
 logic [`CREOLE_HC_HLIT_WIDTH-1:0] st_hlit_store;
 logic [`CREOLE_HC_STCL_MAX_BITS_WIDTH-1:0] st_lut_stcl_size_c;
 logic [(`CREOLE_HC_MAX_ST_TABLE_SIZE)-1:0] [`CREOLE_HC_MAX_ST_XP_CODE_LENGTH-1:0] st_lut_symb_code;
 logic [(`CREOLE_HC_MAX_ST_TABLE_SIZE)-1:0] [`LOG_VEC(`CREOLE_HC_MAX_ST_XP_CODE_LENGTH+1)] st_lut_symb_codelength;
 e_st_state		st_nxt_st;		
 logic [`CREOLE_HC_SEQID_WIDTH-1:0] st_seq_id;	
 logic			st_st_lut_wr;		
 logic [`LOG_VEC(`CREOLE_HC_ST_MAX_BITS/`CREOLE_HC_HDR_WIDTH)] st_st_lut_wr_addr;
 logic [`CREOLE_HC_HDR_WIDTH-1:0] st_st_lut_wr_data;
 logic			st_st_lut_wr_done;	
 logic			st_stcl_lut_wr;		
 logic [`LOG_VEC(`CREOLE_HC_ST_MAX_BITS/`CREOLE_HC_HDR_WIDTH)] st_stcl_lut_wr_addr;
 logic [`CREOLE_HC_HDR_WIDTH-1:0] st_stcl_lut_wr_data;
 logic			st_stcl_lut_wr_done;	
 logic			st_walker_build_error;	
 e_pipe_eob		st_walker_eob;		
 logic [`CREOLE_HC_SEQID_WIDTH-1:0] st_walker_seq_id;
 logic			sym_buf_full;		
 logic [`LOG_VEC(MAX_SYMBOL_TABLE_DEPTH+1)] sym_buf_wr_ptr;
 
 

 logic                               ht_hw_build_error_mod;
 logic [`CREOLE_HC_ST_MAX_BITS_WIDTH-1:0] st_sym_size;
 logic                               tw_pass_thru_rdy,tw_code_rdy;
 logic                               st_lut_wr_c;
 logic [`CREOLE_HC_HDR_WIDTH-1:0]    st_lut_wr_data_c;
 logic [`LOG_VEC(`CREOLE_HC_ST_MAX_BITS/`CREOLE_HC_HDR_WIDTH)] st_lut_wr_addr_c;
 logic                               st_lut_wr_done_c;
 logic                               st_lut_wr_type_c; 
 logic [`CREOLE_HC_SEQID_WIDTH-1:0]  seq_id_store,seq_id_store_c;
 e_pipe_eob                          eob_store,eob_store_c;
 logic                               st_sa_size_rdy_c;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0]  st_sa_size_seq_id_c;
 e_pipe_eob                          st_sa_eob_c;
 logic                               st_sa_build_error_c;
 logic                               st_sa_table_rdy_c;
 logic                               stcl_wr_done,st_wr_done;
   

   
s_st_sym_buf_intf [MAX_SYMBOL_TABLE_DEPTH-1:0] sym_buf;
 
 
 


 
   cr_huf_comp_st_sc  
   #(
      .MAX_SYMBOL_TABLE_DEPTH (MAX_SYMBOL_TABLE_DEPTH)
     ) u_st_symbol_collapser_inst1 (
				    
				    .sc_is_vld		(sc_is_vld[3:0]),
				    .sc_is_cnt		(sc_is_cnt),
				    .sc_is_symbol	(sc_is_symbol),
				    .sc_is_seq_id	(sc_is_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
				    .sc_is_eob		(sc_is_eob),
				    .sc_is_build_error	(sc_is_build_error),
				    
				    .clk		(clk),
				    .rst_n		(rst_n),
				    .sym_buf_wr_ptr	(sym_buf_wr_ptr[`LOG_VEC(MAX_SYMBOL_TABLE_DEPTH+1)]),
				    .st_build_error	(st_build_error),
				    .st_seq_id		(st_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
				    .st_eob		(st_eob),
				    .sym_buf		(sym_buf[MAX_SYMBOL_TABLE_DEPTH-1:0]),
				    .hw_st_eob		(hw_st_eob),
				    .is_sc_rd		(is_sc_rd));


 

   cr_huf_comp_is 
    #(
      .DAT_WIDTH        (`CREOLE_HC_ST_SYMB_WIDTH),  
      .CNT_WIDTH        (3),                         
      .CNTRL_WIDTH      (1),
      .REPLICATOR_LOAD  (11),
      .SYM_FREQ_WIDTH   (`CREOLE_HC_ST_SYMB_FREQ_WIDTH), 
      .MAX_NUM_SYM_USED (`CREOLE_HC_ST_SYMB_DEPTH)   
     )
   u_st_insert_sort (
		     
		     .is_sc_rd		(is_sc_rd),
		     .is_ht_sym_lo	(is_ht_sym_lo[(`CREOLE_HC_ST_SYMB_WIDTH)-1:0]),
		     .is_ht_sym_hi	(is_ht_sym_hi[(`CREOLE_HC_ST_SYMB_WIDTH)-1:0]),
		     .is_ht_sym_unique	(is_ht_sym_unique[(`CREOLE_HC_ST_SYMB_WIDTH)-1:0]),
		     .is_ht_sym_sort_freq(is_ht_sym_sort_freq),
		     .is_ht_sym_sort_freq_sym(is_ht_sym_sort_freq_sym),
		     .is_ht_meta	(is_ht_meta[0:0]),
		     .is_ht_seq_id	(is_ht_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
		     .is_ht_eob		(is_ht_eob),
		     
		     .clk		(clk),
		     .rst_n		(rst_n),
		     .sc_is_vld		(sc_is_vld[3:0]),	 
		     .sc_is_sym0	(sc_is_symbol[0]),	 
		     .sc_is_sym1	(sc_is_symbol[1]),	 
		     .sc_is_sym2	(sc_is_symbol[2]),	 
		     .sc_is_sym3	(sc_is_symbol[3]),	 
		     .sc_is_cnt0	(sc_is_cnt[0]),		 
		     .sc_is_cnt1	(sc_is_cnt[1]),		 
		     .sc_is_cnt2	(sc_is_cnt[2]),		 
		     .sc_is_cnt3	(sc_is_cnt[3]),		 
		     .sc_is_meta	(sc_is_build_error),	 
		     .sc_is_seq_id	(sc_is_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
		     .sc_is_eob		(sc_is_eob),
		     .ht_is_not_ready	(ht_is_not_ready));

  
   

    cr_huf_comp_htb
    #(
      .DAT_WIDTH        (`CREOLE_HC_ST_SYMB_WIDTH),       
      .SYM_FREQ_WIDTH   (`CREOLE_HC_ST_SYMB_FREQ_WIDTH),  
      .CNTRL_WIDTH      (1),
      .CODELENGTH_WIDTH (`CREOLE_HC_ST_SYM_CODELENGTH),
      .SYM_ADDR_WIDTH   (`CREOLE_HC_ST_SYMB_ADDR_WIDTH),  
      .MAX_NUM_SYM_USED (`CREOLE_HC_ST_SYMB_DEPTH),  
      .REPLICATOR_LOAD  (11),
      .SPECIALIZE       (0)
     )
   st_tree_builder (
		    
		    .ht_is_not_ready	(ht_is_not_ready),
		    .ht_hw_sym_lo	(ht_hw_sym_lo[(`CREOLE_HC_ST_SYMB_WIDTH)-1:0]),
		    .ht_hw_sym_hi	(ht_hw_sym_hi[(`CREOLE_HC_ST_SYMB_WIDTH)-1:0]),
		    .ht_hw_meta		(ht_hw_meta[0:0]),
		    .ht_hw_seq_id	(ht_hw_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
		    .ht_hw_sym_sort_freq(ht_hw_sym_sort_freq[((`CREOLE_HC_ST_SYMB_FREQ_WIDTH)*2)-1:0]),
		    .ht_hw_sym_sort_freq_val(ht_hw_sym_sort_freq_val[1:0]),
		    .ht_hw_sym_dpth	(ht_hw_sym_dpth),
		    .ht_hw_zero_symbols	(ht_hw_zero_symbols),
		    .ht_hw_build_error	(ht_hw_build_error),
		    .ht_hw_eob		(ht_hw_eob),
		    .ht_hw_sym_unique	(),			 
		    .ht_hdr_seq_id	(),			 
		    .ht_dbg_cntr_rebuild(st_dbg_cntr_rebuild),	 
		    .ht_dbg_cntr_rebuild_failed(st_dbg_cntr_rebuild_failed), 
		    .bimc_odat		(bimc_odat),
		    .bimc_osync		(bimc_osync),
		    .htb_ecc_error	(),			 
		    
		    .clk		(clk),
		    .rst_n		(rst_n),
		    .is_ht_sym_lo	(is_ht_sym_lo[(`CREOLE_HC_ST_SYMB_WIDTH)-1:0]),
		    .is_ht_sym_hi	(is_ht_sym_hi[(`CREOLE_HC_ST_SYMB_WIDTH)-1:0]),
		    .is_ht_sym_unique	(is_ht_sym_unique[(`CREOLE_HC_ST_SYMB_WIDTH)-1:0]),
		    .is_ht_sym_sort_freq(is_ht_sym_sort_freq),
		    .is_ht_sym_sort_freq_sym(is_ht_sym_sort_freq_sym),
		    .is_ht_meta		(is_ht_meta[0:0]),
		    .is_ht_seq_id	(is_ht_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
		    .is_ht_eob		(is_ht_eob),
		    .hw_ht_sym_freq_rd	(hw_ht_sym_freq_rd),
		    .hw_ht_sym_freq_seq_id(hw_ht_sym_freq_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
		    .hw_ht_sym_freq_rd_addr(hw_ht_sym_freq_rd_addr[(`CREOLE_HC_ST_SYMB_ADDR_WIDTH)-2:0]),
		    .hw_ht_sym_freq_rd_done(hw_ht_sym_freq_rd_done),
		    .hw_ht_not_ready	(hw_ht_not_ready),
		    .hdr_ht_type	(hdr_ht_type_mod_r),	 
		    .sw_ht_xp_max_code_length(sw_st_xp_max_code_length), 
		    .sw_ht_deflate_max_code_length(sw_st_deflate_max_code_length), 
		    .sw_ht_max_rebuild_limit(sw_st_max_rebuild_limit[9:0]), 
		    .sw_ht_force_rebuild(sw_st_force_rebuild[`CR_HUF_COMP_HT_CONFIG_T_FORCE_REBUILD_DECL]), 
		    .bimc_isync		(bimc_isync),
		    .bimc_idat		(bimc_idat),
		    .lvm		(lvm),
		    .mlvm		(mlvm),
		    .mrdten		(mrdten));


 

 cr_huf_comp_htw_type_st
    #(
    .DAT_WIDTH       (`CREOLE_HC_ST_SYMB_WIDTH),           
    .SYM_FREQ_WIDTH  (`CREOLE_HC_ST_SYMB_FREQ_WIDTH),      
    .SYM_ADDR_WIDTH  ($clog2(`CREOLE_HC_MAX_ST_TABLE_SIZE)), 
    .CODELENGTH_WIDTH (`CREOLE_HC_ST_SYM_CODELENGTH),
    .MAX_NUM_SYM_USED(`CREOLE_HC_MAX_ST_TABLE_SIZE)
     )       
   st_tree_walker (
		   
		   .hw_ht_sym_freq_rd	(hw_ht_sym_freq_rd),
		   .hw_ht_sym_freq_seq_id(hw_ht_sym_freq_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
		   .hw_ht_sym_freq_rd_addr(hw_ht_sym_freq_rd_addr[($clog2(`CREOLE_HC_MAX_ST_TABLE_SIZE))-2:0]),
		   .hw_ht_sym_freq_rd_done(hw_ht_sym_freq_rd_done),
		   .hw_ht_not_ready	(hw_ht_not_ready),
		   .st_lut_symb_code	(st_lut_symb_code),
		   .st_lut_symb_codelength(st_lut_symb_codelength),
		   .hw_lut_ret_size	(st_sym_size),		 
		   .hw_lut_seq_id	(),			 
		   .hw_st_symbol	(),			 
		   .hw_st_seq_id	(st_walker_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
		   .hw_st_eob		(st_walker_eob),	 
		   .hw_st_build_error	(st_walker_build_error), 
		   .hw_st_max_sym_table	(),			 
		   .st_bl_ism_data	(st_bl_ism_data),
		   .st_bl_ism_vld	(st_bl_ism_vld),
		   
		   .clk			(clk),
		   .rst_n		(rst_n),
		   .ht_hw_sym_lo	(ht_hw_sym_lo[(`CREOLE_HC_ST_SYMB_WIDTH)-1:0]),
		   .ht_hw_sym_hi	(ht_hw_sym_hi[(`CREOLE_HC_ST_SYMB_WIDTH)-1:0]),
		   .ht_hw_sym_sort_freq	(ht_hw_sym_sort_freq[((`CREOLE_HC_ST_SYMB_FREQ_WIDTH)*2)-1:0]),
		   .ht_hw_sym_sort_freq_val(ht_hw_sym_sort_freq_val[1:0]),
		   .ht_hw_sym_dpth	(ht_hw_sym_dpth),
		   .ht_hw_zero_symbols	(ht_hw_zero_symbols),
		   .ht_hw_build_error	(ht_hw_build_error_mod), 
		   .ht_hw_seq_id	(ht_hw_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
		   .ht_hw_eob		(ht_hw_eob),
		   .st_hw_not_ready	(st_sa_size_rdy),	 
		   .hdr_hw_type		(hdr_ht_type_mod),	 
		   .sw_ism_on		(sw_ism_on),
		   .st_ism_rdy		(st_ism_rdy));





 cr_huf_comp_st_builder
    #(
    .MAX_SYMBOL_TABLE_DEPTH(MAX_SYMBOL_TABLE_DEPTH)
     )       
   small_table_builder (
			
			.st_lut_wr	(st_st_lut_wr),		 
			.st_lut_wr_data	(st_st_lut_wr_data[`CREOLE_HC_HDR_WIDTH-1:0]), 
			.st_lut_wr_addr	(st_st_lut_wr_addr[`LOG_VEC(`CREOLE_HC_ST_MAX_BITS/`CREOLE_HC_HDR_WIDTH)]), 
			.st_lut_wr_done	(st_st_lut_wr_done),	 
			
			.clk		(clk),
			.rst_n		(rst_n),
			.start_build	(stcl_wr_done),		 
			.st_lut_symb_code(st_lut_symb_code),
			.st_lut_symb_codelength(st_lut_symb_codelength),
			.sym_buf	(sym_buf[MAX_SYMBOL_TABLE_DEPTH-1:0]),
			.sym_buf_wr_ptr	(sym_buf_wr_ptr[`LOG_VEC(MAX_SYMBOL_TABLE_DEPTH+1)]),
			.sa_st_read_done(sa_st_read_done));
   



 cr_huf_comp_stcl_builder
    #(
      .CODELENGTH_WIDTH (`CREOLE_HC_ST_SYM_CODELENGTH),
      .MAX_NUM_SYM_USED (`CREOLE_HC_ST_SYMB_DEPTH)
     )       
   st_codelength_table_builder (
				
				.st_lut_wr	(st_stcl_lut_wr), 
				.st_lut_wr_data	(st_stcl_lut_wr_data[`CREOLE_HC_HDR_WIDTH-1:0]), 
				.st_lut_wr_addr	(st_stcl_lut_wr_addr[`LOG_VEC(`CREOLE_HC_ST_MAX_BITS/`CREOLE_HC_HDR_WIDTH)]), 
				.st_lut_wr_done	(st_stcl_lut_wr_done), 
				.st_lut_stcl_size(st_lut_stcl_size_c[`CREOLE_HC_STCL_MAX_BITS_WIDTH-1:0]), 
				.st_lut_hclen	(st_lut_hclen[`CREOLE_HC_HCLEN_WIDTH-1:0]),
				
				.clk		(clk),
				.rst_n		(rst_n),
				.deflate_mode	(st_deflate_store), 
				.start_build	(tw_code_rdy),	 
				.ht_hw_sym_dpth	(ht_hw_sym_dpth),
				.sa_st_read_done(sa_st_read_done));



 

 cr_huf_comp_st_queue
    #(
      .DAT_WIDTH        (DAT_WIDTH),
      .MAX_SYMBOL_TABLE_DEPTH(MAX_SYMBOL_TABLE_DEPTH)
     )       
   st_symbol_queue(
		   
		   .hdr_ht_type_mod	(hdr_ht_type_mod),
		   .st_extra_size_store	(st_extra_size_store[`CREOLE_HC_SMALL_TABLE_XTR_BIT_SIZE:0]),
		   .sym_buf_wr_ptr	(sym_buf_wr_ptr[`LOG_VEC(MAX_SYMBOL_TABLE_DEPTH+1)]),
		   .sym_buf_full	(sym_buf_full),
		   .st_deflate_store	(st_deflate_store),
		   .st_hdist_store	(st_hdist_store[`CREOLE_HC_HDIST_WIDTH-1:0]),
		   .st_hlit_store	(st_hlit_store[`CREOLE_HC_HLIT_WIDTH-1:0]),
		   .st_build_error	(st_build_error),
		   .st_seq_id		(st_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
		   .st_eob		(st_eob),
		   .sym_buf		(sym_buf[MAX_SYMBOL_TABLE_DEPTH-1:0]),
		   
		   .clk			(clk),
		   .rst_n		(rst_n),
		   .hw_st_val		(hw_st_val[MAX_SYMBOL_TABLE_DEPTH-1:0]),
		   .hw_st_symbol	(hw_st_symbol),
		   .hw_st_extra		(hw_st_extra),
		   .hw_st_extra_length	(hw_st_extra_length),
		   .hw_st_last_ptr	(hw_st_last_ptr[DAT_WIDTH-1:0]),
		   .hw_st_extra_size	(hw_st_extra_size[`CREOLE_HC_SMALL_TABLE_XTR_BIT_SIZE:0]),
		   .hw_st_seq_id	(hw_st_seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]),
		   .hw_st_hlit		(hw_st_hlit[`CREOLE_HC_HLIT_WIDTH-1:0]),
		   .hw_st_hdist		(hw_st_hdist[`CREOLE_HC_HDIST_WIDTH-1:0]),
		   .hw_st_deflate	(hw_st_deflate),
		   .hw_st_eob		(hw_st_eob),
		   .hw_st_build_error	(hw_st_build_error),
		   .sa_st_read_done	(sa_st_read_done));



    
   cr_huf_comp_st_fsm
   st_fsm         (
		   
		   .st_nxt_st		(st_nxt_st),
		   .st_curr_st		(st_curr_st),
		   
		   .clk			(clk),
		   .rst_n		(rst_n),
		   .tw_pass_thru_rdy	(tw_pass_thru_rdy),
		   .tw_code_rdy		(tw_code_rdy),
		   .st_st_lut_wr_done	(st_wr_done),		 
		   .st_stcl_lut_wr_done	(stcl_wr_done),		 
		   .sa_st_read_done	(sa_st_read_done));


always_ff @(posedge clk or negedge rst_n)
begin
  if (~rst_n) 
    begin
    eob_store <= MIDDLE;
    st_sa_eob <= MIDDLE;
    hdr_ht_type_mod_r <= 0; 
    
    
    seq_id_store <= 0;
    st_lut_hdist <= 0;
    st_lut_hlit <= 0;
    st_lut_seq_id <= 0;
    st_lut_sizes_val <= 0;
    st_lut_st_size <= 0;
    st_lut_stcl_size <= 0;
    st_lut_wr <= 0;
    st_lut_wr_addr <= 0;
    st_lut_wr_data <= 0;
    st_lut_wr_done <= 0;
    st_lut_wr_type <= 0;
    st_sa_build_error <= 0;
    st_sa_size_rdy <= 0;
    st_sa_size_seq_id <= 0;
    st_sa_table_rdy <= 0;
    
    end
  else
    begin

       seq_id_store		<= seq_id_store_c;
       eob_store		<= eob_store_c;
   
       st_sa_size_rdy		<= st_sa_size_rdy_c;
       st_sa_eob		<= st_sa_eob_c;
       st_sa_size_seq_id	<= st_sa_size_seq_id_c;
       st_sa_build_error	<= st_sa_build_error_c;
       st_sa_table_rdy		<= st_sa_table_rdy_c;

       st_lut_wr		<= st_lut_wr_c; 
       st_lut_wr_data		<= st_lut_wr_data_c;
       st_lut_wr_addr		<= st_lut_wr_addr_c;
       st_lut_wr_done		<= st_lut_wr_done_c;
       st_lut_wr_type		<= st_lut_wr_type_c;
       st_lut_seq_id		<= seq_id_store_c;
       
       st_lut_hlit		<= st_hlit_store;
       st_lut_hdist		<= st_hdist_store;

       
       st_lut_sizes_val		<= stcl_wr_done;
       
       st_lut_st_size		<= st_extra_size_store + st_sym_size;
       st_lut_stcl_size         <= st_lut_stcl_size_c;

       if(ht_is_not_ready)
	 hdr_ht_type_mod_r      <= hdr_ht_type_mod;
	 
       
    end
end
    
always_comb
  begin

stcl_wr_done = st_stcl_lut_wr_done; 
st_wr_done   = st_st_lut_wr_done && st_st_lut_wr;   


     tw_code_rdy		 = st_walker_eob != PASS_THRU && st_walker_eob != MIDDLE;

     tw_pass_thru_rdy		 = st_walker_eob == PASS_THRU;

     seq_id_store_c		 = seq_id_store;
     eob_store_c		 = eob_store;
     if(st_walker_eob != MIDDLE)
       begin
	  seq_id_store_c	 = st_walker_seq_id;
	  eob_store_c		 = st_walker_eob;
       end 

     st_hw_not_ready		 = sym_buf_full;


     ht_hw_build_error_mod	 = ht_hw_meta | ht_hw_build_error;



     if(st_curr_st==START_STCL) 
       begin 
	st_lut_wr_c		 = st_stcl_lut_wr; 
	st_lut_wr_data_c	 = st_stcl_lut_wr_data;
	st_lut_wr_addr_c	 = st_stcl_lut_wr_addr;
	st_lut_wr_done_c	 = st_stcl_lut_wr_done;
	st_lut_wr_type_c	 = 0;
       end
     else
       begin
	st_lut_wr_c		 = st_st_lut_wr; 
	st_lut_wr_data_c	 = st_st_lut_wr_data;
	st_lut_wr_addr_c	 = st_st_lut_wr_addr;
	st_lut_wr_done_c	 = st_st_lut_wr_done;
	st_lut_wr_type_c	 = 1;
       end 


      st_sa_size_rdy_c		 = 0;
      st_sa_eob_c		 = MIDDLE;
      st_sa_size_seq_id_c	 = 0;
      st_sa_build_error_c	 = 0;
      if(st_nxt_st == RDY_TO_SA || st_nxt_st == TBL_RDY_TO_SA)
	begin
	   st_sa_size_rdy_c	 = 1;
	   st_sa_eob_c		 = eob_store_c;
	   st_sa_size_seq_id_c	 = seq_id_store_c;
	   st_sa_build_error_c	 = st_walker_build_error;
	end

      st_sa_table_rdy_c		 = 0;
      if(st_nxt_st == TBL_RDY_TO_SA)
	 st_sa_table_rdy_c	 = 1;


end

   
endmodule 








