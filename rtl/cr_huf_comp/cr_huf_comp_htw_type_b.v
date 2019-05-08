/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/












`include "cr_huf_comp.vh"

module cr_huf_comp_htw_type_b
  #(parameter
    DAT_WIDTH        =8,      
    SYM_FREQ_WIDTH   =13,      
    SYM_ADDR_WIDTH   =8,      
    MAX_NUM_SYM_USED =248,     
    CODELENGTH_WIDTH =5,       
    SHORT            =0        
   )
  (
   
   hw_ht_sym_freq_rd, hw_ht_sym_freq_seq_id, hw_ht_sym_freq_rd_addr,
   hw_ht_sym_freq_rd_done, hw_ht_not_ready, hw_hw_seq_id_val,
   hw_hw_seq_id_out, hw_hw_val_out, hw_hw_codes_out, hw_hw_last_out,
   hw_hw_sym_hi_out, hw_hw_build_error_out, hw_lut_wr, hw_lut_wr_addr,
   hw_lut_wr_val, hw_lut_wr_data, hw_lut_wr_done, hw_lut_sizes_val,
   hw_lut_ret_size, hw_lut_pre_size, hw_lut_sim_size, hw_lut_seq_id,
   hw_ph_seq_id, hw_ph_sym_addr, hw_ph_rd, hw_stsg_val,
   hw_stsg_symbol, hw_stsg_seq_id, hw_stsg_eob, hw_stsg_build_error,
   hw_stsg_sym_hi_b, hw_stsg_max_sym_table, hw_hdr_seq_id,
   long_bl_ism_data, long_bl_ism_vld,
   
   clk, rst_n, ht_hw_sym_lo, ht_hw_sym_hi, ht_hw_sym_sort_freq,
   ht_hw_sym_sort_freq_val, ht_hw_sym_dpth, ht_hw_zero_symbols,
   ht_hw_build_error, ht_hw_seq_id, ht_hw_eob, ht_hw_sym_unique,
   hw_hw_ready_in, hw_hw_abort_in, lut_hw_full, ph_hw_sym_val,
   ph_hw_sym_dpth, stsg_hw_not_ready, hdr_hw_type, sw_ism_on,
   long_ism_rdy
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

  `define HT_HW_FREQ_RD_LATENCY `HT_FREQ_RD_LATENCY+1

 
 
 
 input                                        clk;
 input                                        rst_n; 
 
 
 
 
  
 input [DAT_WIDTH-1:0] 		             ht_hw_sym_lo;   
 input [DAT_WIDTH-1:0] 		             ht_hw_sym_hi;   
 input [(SYM_FREQ_WIDTH * 2)-1:0]            ht_hw_sym_sort_freq; 
 input [1:0]                                 ht_hw_sym_sort_freq_val;
 input [MAX_NUM_SYM_USED-1:0][CODELENGTH_WIDTH-1:0] ht_hw_sym_dpth; 
 input    				     ht_hw_zero_symbols; 
 input 				             ht_hw_build_error; 
 input [`CREOLE_HC_SEQID_WIDTH-1:0]          ht_hw_seq_id;   
 input e_pipe_eob                            ht_hw_eob;      
                                                             
                                                             
                                                             
                                                             
 input [DAT_WIDTH-1:0]                       ht_hw_sym_unique;

 
 input                                       hw_hw_ready_in; 
                                                             
 input                                       hw_hw_abort_in; 
   
 
 input                                       lut_hw_full;    
   
 
 input 				             ph_hw_sym_val;  
 input [`CREOLE_HC_PHT_WIDTH-1:0] 	     ph_hw_sym_dpth; 
                                                             

 
 input 				             stsg_hw_not_ready;
   
 
 input s_seq_id_type_intf   	             hdr_hw_type;    

 
 input	                                     sw_ism_on;

 
 input		                             long_ism_rdy;

 
 
 

 
 output logic	                              hw_ht_sym_freq_rd;
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]    hw_ht_sym_freq_seq_id;
 output logic [SYM_ADDR_WIDTH-2:0]            hw_ht_sym_freq_rd_addr;
 output logic                                 hw_ht_sym_freq_rd_done; 
 output logic 				      hw_ht_not_ready;

 
 output logic                                 hw_hw_seq_id_val;
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]    hw_hw_seq_id_out;
 output logic [1:0]                           hw_hw_val_out;  
                                                              
 output logic [1:0][CODELENGTH_WIDTH-1:0]     hw_hw_codes_out;
 output logic                                 hw_hw_last_out; 
 output logic [DAT_WIDTH-1:0]                 hw_hw_sym_hi_out;
                                                             
 output logic                                 hw_hw_build_error_out;
                                                                    

 
 output logic                                 hw_lut_wr;      
 output logic [DAT_WIDTH-2:0]                 hw_lut_wr_addr; 
 output logic [1:0]                           hw_lut_wr_val;  
                                                              
 output logic [127:0]                         hw_lut_wr_data; 
 output logic                                 hw_lut_wr_done; 
 output logic                                 hw_lut_sizes_val;
                                                              
 output logic [19:0]                          hw_lut_ret_size;
 output logic [19:0]                          hw_lut_pre_size;
 output logic [19:0]                          hw_lut_sim_size;
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]    hw_lut_seq_id;  
   
 
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]    hw_ph_seq_id;   
 output logic [5:0]                           hw_ph_sym_addr; 
                                                              
 output logic                                 hw_ph_rd;   
   
 
 output logic [MAX_NUM_SYM_USED-1:0]          hw_stsg_val;
 output logic [MAX_NUM_SYM_USED-1:0][CODELENGTH_WIDTH-1:0] hw_stsg_symbol;
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]    hw_stsg_seq_id;
 output e_pipe_eob                            hw_stsg_eob;     
                                                             
                                                             
                                                             
                                                             
 output logic                                 hw_stsg_build_error;
                                                                
                                                                
 
 output logic [DAT_WIDTH-1:0]                 hw_stsg_sym_hi_b;
 output logic [DAT_WIDTH:0]                   hw_stsg_max_sym_table;

 
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]    hw_hdr_seq_id;

 
 output lng_bl_t                              long_bl_ism_data;
 output                                       long_bl_ism_vld; 

 
 
 logic			ism_not_ready;		
 
 
 logic [MAX_NUM_SYM_USED-1:0][CODELENGTH_WIDTH-1:0] retro_bl_table;
 logic [1:0][CODELENGTH_WIDTH-1:0]            retro_bl_c,retro_bl;
 logic [1:0][CODELENGTH_WIDTH-1:0]	      pre_bl_c,pre_bl;
 logic [DAT_WIDTH-1:0]                        sym_lo;
 logic [DAT_WIDTH-1:0]                        sym_hi;
 e_pipe_eob                                   eob_store;
 logic [DAT_WIDTH-1:0]                        retro_bl_rd_ptr,retro_bl_rd_ptr_c;
 logic [`MAX_XP_CODE_LENGTH-1:0][DAT_WIDTH-1:0] retro_bl_cnt,retro_bl_cnt_c;
 logic [CODELENGTH_WIDTH-1:0]                 bl_cnt_bin_ptr,bl_cnt_bin_ptr_c;
 logic [DAT_WIDTH-1:0]                        pre_bl_rd_ptr,pre_bl_rd_ptr_c,pre_bl_wr_ptr,pre_bl_wr_ptr_c,pre_bl_req_cnt,pre_bl_req_cnt_c;
 logic [`MAX_XP_CODE_LENGTH-1:0][DAT_WIDTH-1:0] pre_bl_cnt;
 logic [`MAX_XP_CODE_LENGTH-1:0][DAT_WIDTH-1:0] pre_bl_cnt_c;

 logic [`MAX_XP_CODE_LENGTH:0][`MAX_XP_CODE_LENGTH-1:0] retro_start_code,retro_start_code_c;
 logic [`MAX_XP_CODE_LENGTH:0][`MAX_XP_CODE_LENGTH-1:0] pre_start_code,pre_start_code_c;
 logic                                        ht_hw_build_error_r;
 logic                                        ht_hw_zero_symbols_r;   
 logic                                        process_pre;
 logic [DAT_WIDTH-1:0]                        final_code_sym_ptr,final_code_sym_ptr_c;
 logic [2:0]                                  ht_hw_rd_freq_val;
 logic [(SYM_FREQ_WIDTH * 2)-1:0]             ht_hw_sym_sort_freq_r; 
 logic [1:0]                                  ht_hw_sym_sort_freq_val_r;
 logic [2:0][DAT_WIDTH-1:0]                   final_code_sym_ptr_r;
 logic [MAX_NUM_SYM_USED-1:0][CODELENGTH_WIDTH-1:0] pre_bl_table,pre_bl_table_c;
 logic [MAX_NUM_SYM_USED-1:0] pre_bl_table_val_c,pre_bl_table_val;
 logic                                        hw_ph_rd_c;
 logic [5:0]                                  hw_ph_sym_addr_c;
 logic                                        hw_ht_sym_freq_rd_c; 
 logic [SYM_ADDR_WIDTH-2:0]                   hw_ht_sym_freq_rd_addr_c; 
 logic                                        hw_ht_sym_freq_rd_done_c; 
 logic [19:0]                                 hw_lut_ret_size_c; 
 logic [19:0]                                 hw_lut_pre_size_c;
 logic [19:0]                                 hw_lut_sim_size_c;
 logic [1:0][`MAX_XP_CODE_LENGTH-1:0]         retro_sym_code_c;
 logic [1:0][`MAX_XP_CODE_LENGTH-1:0]         pre_sym_code_c;  
 logic [1:0]                                  hw_lut_wr_val_c;
 logic [DAT_WIDTH-1:0]                        max_sym_used;
 logic [DAT_WIDTH-2:0]                        hw_lut_wr_addr_c;
 logic [MAX_NUM_SYM_USED-1:0]                 hw_stsg_val_c; 
 logic [MAX_NUM_SYM_USED-1:0][CODELENGTH_WIDTH-1:0] hw_stsg_symbol_c;
 logic                                        hw_lut_wr_c;
 s_lut_sa_rd_data_intf [1:0]                  hw_lut_wr_data_c;
 logic                                        hw_lut_wr_done_c;
 e_pipe_eob                                   hw_stsg_eob_c;
 logic [DAT_WIDTH-1:0]                        hw_stsg_sym_hi_b_c;
 logic [CODELENGTH_WIDTH-1:0]                 max_code_length;
 logic [1:0]                                  hw_hw_val_out_c;
 logic [1:0][CODELENGTH_WIDTH-1:0]            hw_hw_codes_out_c;
 logic                                        hw_hw_last_out_c; 
 logic [DAT_WIDTH-1:0]                        hw_hw_sym_hi_out_c;
 logic [DAT_WIDTH:0]                          max_sym_table;
 logic                                        deflate_mode,deflate_mode_c;
 logic 				              ph_hw_sym_val_r;
 logic [`CREOLE_HC_PHT_WIDTH-1:0] 	      ph_hw_sym_dpth_r;
 logic [`LOG_VEC(`ROUND_UP_DIV(MAX_NUM_SYM_USED,`PRE_HUF_TABLE_NUM_SYM_PER_READ))]  ph_rd_credit_count,ph_rd_credit_count_c;
 logic [1:0][CODELENGTH_WIDTH-1:0]           retro_bl_select,retro_bl_select_c;
 logic [1:0][CODELENGTH_WIDTH-1:0]           pre_bl_select,pre_bl_select_c;
 logic [1:0][19:0]                           pre_size_multiplier,pre_size_multiplier_c,
                                             retro_size_multiplier,retro_size_multiplier_c,
                                             sim_size_multiplier,sim_size_multiplier_c;
 logic [`PRE_HUF_TABLE_NUM_SYM_PER_READ-1:0][CODELENGTH_WIDTH-1:0] retro_bl_table_piped,retro_bl_table_piped_c,
                                                                   pre_bl_table_piped,pre_bl_table_piped_c;
 logic [DAT_WIDTH-1:0]                       ht_hw_sym_unique_r;
 logic                                       hw_lut_wr_r;

 logic                                       clk_gate_open, clk_gated;

   


 typedef enum 		 {IDLE,
			  WAIT_FOR_IN_STABLE,
			  WAIT_FOR_IN_STABLE_2,
                          BL_CNT,
			  WAIT_FOR_PRE_DATA,
			  WAIT_HISTO_PIPE,
			  CHECK_INPUT,
                          START_CODE,
                          HANDSHAKE,
                          FINAL_CODE,
                          WAIT_FOR_READY,
			  WAIT_FOR_STSG
                          }
                         e_tr_walker_state;


   
e_tr_walker_state  htw_curr_st,htw_nxt_st,htw_prev_st; 
                                                    
s_simple_bl_range [3:0] simple_bl;
   
 
 
 
   

always_ff @(posedge clk_gated or negedge rst_n)
begin
  if (~rst_n) 
  begin
    hw_stsg_eob <= MIDDLE;
    eob_store <= MIDDLE;
    htw_curr_st <= IDLE;
    htw_prev_st <= IDLE;
    bl_cnt_bin_ptr <= 1;
    
    
    final_code_sym_ptr <= 0;
    final_code_sym_ptr_r <= 0;
    ht_hw_build_error_r <= 0;
    ht_hw_rd_freq_val <= 0;
    ht_hw_sym_sort_freq_r <= 0;
    ht_hw_sym_sort_freq_val_r <= 0;
    ht_hw_sym_unique_r <= 0;
    ht_hw_zero_symbols_r <= 0;
    hw_hdr_seq_id <= 0;
    hw_ht_sym_freq_rd <= 0;
    hw_ht_sym_freq_rd_addr <= 0;
    hw_ht_sym_freq_rd_done <= 0;
    hw_ht_sym_freq_seq_id <= 0;
    hw_hw_codes_out <= 0;
    hw_hw_last_out <= 0;
    hw_hw_seq_id_out <= 0;
    hw_hw_seq_id_val <= 0;
    hw_hw_sym_hi_out <= 0;
    hw_hw_val_out <= 0;
    hw_lut_pre_size <= 0;
    hw_lut_ret_size <= 0;
    hw_lut_seq_id <= 0;
    hw_lut_sim_size <= 0;
    hw_lut_sizes_val <= 0;
    hw_lut_wr <= 0;
    hw_lut_wr_addr <= 0;
    hw_lut_wr_data <= 0;
    hw_lut_wr_done <= 0;
    hw_lut_wr_r <= 0;
    hw_lut_wr_val <= 0;
    hw_ph_rd <= 0;
    hw_ph_seq_id <= 0;
    hw_ph_sym_addr <= 0;
    hw_stsg_build_error <= 0;
    hw_stsg_max_sym_table <= 0;
    hw_stsg_seq_id <= 0;
    hw_stsg_sym_hi_b <= 0;
    hw_stsg_symbol <= 0;
    hw_stsg_val <= 0;
    ph_rd_credit_count <= 0;
    pre_bl <= 0;
    pre_bl_cnt <= 0;
    pre_bl_rd_ptr <= 0;
    pre_bl_req_cnt <= 0;
    pre_bl_select <= 0;
    pre_bl_table <= 0;
    pre_bl_table_piped <= 0;
    pre_bl_table_val <= 0;
    pre_bl_wr_ptr <= 0;
    pre_size_multiplier <= 0;
    pre_start_code <= 0;
    retro_bl <= 0;
    retro_bl_cnt <= 0;
    retro_bl_rd_ptr <= 0;
    retro_bl_select <= 0;
    retro_bl_table <= 0;
    retro_bl_table_piped <= 0;
    retro_size_multiplier <= 0;
    retro_start_code <= 0;
    sim_size_multiplier <= 0;
    sym_hi <= 0;
    sym_lo <= 0;
    
  end
  else
  begin
     
             
	     ht_hw_sym_sort_freq_r		<= ht_hw_sym_sort_freq; 
             ht_hw_sym_sort_freq_val_r		<= ht_hw_sym_sort_freq_val;

	     
	     ht_hw_rd_freq_val			<= {ht_hw_rd_freq_val[1:0],hw_ht_sym_freq_rd};
     	     final_code_sym_ptr_r[0]		<= final_code_sym_ptr;
	     for(int i=1;i < 3;i++)
                 final_code_sym_ptr_r[i]	<= final_code_sym_ptr_r[i-1];

     
             
             htw_curr_st			<= htw_nxt_st;
	  
             
             if(ht_hw_eob != MIDDLE)
	        begin
	   	    retro_bl_table		<= ht_hw_sym_dpth;
	   	    sym_lo			<= ht_hw_sym_lo;
	   	    sym_hi			<= ht_hw_sym_hi;
	   	    eob_store			<= ht_hw_eob;
	   	    ht_hw_zero_symbols_r	<= ht_hw_zero_symbols;
	   	    ht_hw_build_error_r		<= ht_hw_build_error;
                     
	   	    hw_stsg_seq_id		<= ht_hw_seq_id;
	   	    
	   	    hw_ph_seq_id		<= ht_hw_seq_id;
	   	    
                    hw_hdr_seq_id		<= ht_hw_seq_id;
	   	    
	   	    hw_lut_seq_id		<= ht_hw_seq_id;
	   	    
	   	    hw_hw_seq_id_out		<= ht_hw_seq_id;
		    hw_hw_seq_id_val            <= 1'b1;
	   	    
	   	    hw_ht_sym_freq_seq_id	<= ht_hw_seq_id;

		    ht_hw_sym_unique_r          <= ht_hw_sym_unique;
	        end 
             else if(htw_curr_st==IDLE)
	        begin
	            hw_hw_seq_id_val            <= 0;
		    ht_hw_zero_symbols_r        <= 0;
		    ht_hw_build_error_r         <= 0;
		end
	  	 
	     retro_bl_rd_ptr			<= retro_bl_rd_ptr_c;
             retro_bl_cnt			<= retro_bl_cnt_c;
             bl_cnt_bin_ptr			<= bl_cnt_bin_ptr_c;
             retro_start_code			<= retro_start_code_c;
             hw_ph_rd				<= hw_ph_rd_c;
	     hw_ph_sym_addr			<= hw_ph_sym_addr_c;
	     pre_bl_rd_ptr			<= pre_bl_rd_ptr_c;
             pre_bl_req_cnt			<= pre_bl_req_cnt_c;
             pre_bl_wr_ptr			<= pre_bl_wr_ptr_c;
	     pre_bl_table			<= pre_bl_table_c;
             pre_bl_table_val                   <= pre_bl_table_val_c;
             pre_bl_cnt				<= pre_bl_cnt_c;
             pre_start_code			<= pre_start_code_c;
             final_code_sym_ptr			<= final_code_sym_ptr_c;
	     hw_ht_sym_freq_rd			<= hw_ht_sym_freq_rd_c;
	     hw_ht_sym_freq_rd_addr		<= hw_ht_sym_freq_rd_addr_c;
	     hw_ht_sym_freq_rd_done		<= hw_ht_sym_freq_rd_done_c;
	     hw_lut_ret_size			<= hw_lut_ret_size_c;
	     hw_lut_pre_size			<= hw_lut_pre_size_c;
             hw_lut_sim_size			<= hw_lut_sim_size_c;
             hw_lut_wr				<= hw_lut_wr_c;
             hw_lut_wr_addr			<= hw_lut_wr_addr_c;
             hw_lut_wr_val			<= hw_lut_wr_val_c;
             hw_lut_wr_data			<= hw_lut_wr_data_c;
	     hw_lut_wr_done                     <= hw_lut_wr_done_c;
	     
             hw_lut_sizes_val			<= ht_hw_rd_freq_val[`HT_HW_FREQ_RD_LATENCY];

             hw_stsg_eob			<= hw_stsg_eob_c;
	     hw_stsg_val                        <= hw_stsg_val_c;
	     hw_stsg_symbol                     <= hw_stsg_symbol_c;

	     hw_stsg_build_error		<= ht_hw_build_error_r; 
	     

             hw_stsg_sym_hi_b                   <= hw_stsg_sym_hi_b_c;
             hw_stsg_max_sym_table              <= max_sym_table;

             hw_hw_val_out                      <= hw_hw_val_out_c;
             hw_hw_codes_out                    <= hw_hw_codes_out_c;
             hw_hw_last_out                     <= hw_hw_last_out_c; 
             hw_hw_sym_hi_out                   <= hw_hw_sym_hi_out_c;

             
             ph_rd_credit_count                 <= ph_rd_credit_count_c;
             htw_prev_st                        <= htw_curr_st;
             retro_bl_select                    <= retro_bl_select_c;
             pre_bl_select                      <= pre_bl_select_c;
             pre_size_multiplier                <= pre_size_multiplier_c;
	     retro_size_multiplier              <= retro_size_multiplier_c;
             sim_size_multiplier                <= sim_size_multiplier_c;
             pre_bl                             <= pre_bl_c;
             retro_bl                           <= retro_bl_c;
             retro_bl_table_piped               <= retro_bl_table_piped_c;
             pre_bl_table_piped                 <= pre_bl_table_piped_c;

             hw_lut_wr_r                        <= hw_lut_wr;
	  
  end 
end 

always_ff @(posedge clk_gated or negedge rst_n)
begin
  if (~rst_n) 
    begin
    
    
    deflate_mode <= 0;
    max_code_length <= 0;
    max_sym_table <= 0;
    max_sym_used <= 0;
    ph_hw_sym_dpth_r <= 0;
    ph_hw_sym_val_r <= 0;
    process_pre <= 0;
    simple_bl <= 0;
    
    end
  else
    begin
       
     process_pre									<= 0;
     if(hdr_hw_type.xp10_prefix_mode==PREDET_HUFF) 
         process_pre								        <= 1;
     
     deflate_mode									<= deflate_mode_c;
     
     if(deflate_mode_c)
          max_code_length                                                               <= `MAX_DEFLATE_CODE_LENGTH;
     else
          max_code_length                                                               <= `MAX_XP_CODE_LENGTH; 

     
     if(hdr_hw_type.comp_mode==XP9)
          begin
	      max_sym_table								<= max_sym_table_array[SHORT][0].table_size; 
	      max_sym_used								<= max_sym_table_array[SHORT][0].used;
      	      simple_bl									<= simple_bl_table[SHORT][0];
          end
     else if(deflate_mode_c)
       begin
	      max_sym_table								<= sym_hi + 1;
	      max_sym_used								<= sym_hi + 1;
      	      simple_bl									<= simple_bl_table[SHORT][5];
          end
     else
        case(hdr_hw_type.lz77_win_size)
            WIN_4K : begin
	                 max_sym_table							<= max_sym_table_array[SHORT][4].table_size;
	                 max_sym_used							<= max_sym_table_array[SHORT][4].used;
      	                 simple_bl							<= simple_bl_table[SHORT][4];
      	             end
            WIN_8K : begin
	                 max_sym_table							<= max_sym_table_array[SHORT][3].table_size;
	                 max_sym_used							<= max_sym_table_array[SHORT][3].used;
      	                 simple_bl							<= simple_bl_table[SHORT][3];
      	             end
            WIN_16K: begin
	                 max_sym_table							<= max_sym_table_array[SHORT][2].table_size;
	                 max_sym_used							<= max_sym_table_array[SHORT][2].used;
      	                 simple_bl							<= simple_bl_table[SHORT][2];
      	             end
            default: begin
	                 max_sym_table							<= max_sym_table_array[SHORT][1].table_size;
	                 max_sym_used							<= max_sym_table_array[SHORT][1].used;
      	                 simple_bl							<= simple_bl_table[SHORT][1]; 
      	             end
        endcase 

       ph_hw_sym_val_r                                                                  <= ph_hw_sym_val;
       ph_hw_sym_dpth_r                                                                 <= ph_hw_sym_dpth;

      end 
end 

always_comb
  begin

      deflate_mode_c									 = hdr_hw_type.comp_mode == ZLIB || hdr_hw_type.comp_mode == GZIP;
   

      
      htw_nxt_st									 = htw_curr_st;
      case(htw_curr_st)
	   IDLE			: if(ht_hw_eob != MIDDLE)
                                        htw_nxt_st					 = WAIT_FOR_IN_STABLE;

	   WAIT_FOR_IN_STABLE   : htw_nxt_st					         = WAIT_FOR_IN_STABLE_2;
	   WAIT_FOR_IN_STABLE_2 : htw_nxt_st					         = CHECK_INPUT;
	
           
	   CHECK_INPUT          : if(ht_hw_zero_symbols_r && deflate_mode)
	                          
	                               htw_nxt_st					 = HANDSHAKE;
	                          else if(ht_hw_zero_symbols_r)
		                       htw_nxt_st					 = WAIT_FOR_STSG;
	                          
				  else
				       htw_nxt_st					 = BL_CNT;
	
	   
           BL_CNT		: 
                                  if( retro_bl_rd_ptr + `PRE_HUF_TABLE_NUM_SYM_PER_READ >= {1'b0,max_sym_used} ) 
                                       begin 
				          if(process_pre) 
	                                      htw_nxt_st				 = WAIT_FOR_PRE_DATA;
					  else
					      htw_nxt_st				 = WAIT_HISTO_PIPE;
                                       end

	   WAIT_FOR_PRE_DATA    : 
	                          if(ph_rd_credit_count==0 && (pre_bl_rd_ptr + `PRE_HUF_TABLE_NUM_SYM_PER_READ >= {1'b0,max_sym_used})) 
                                     
                                     htw_nxt_st					         = WAIT_HISTO_PIPE;

           WAIT_HISTO_PIPE      :  htw_nxt_st					         = START_CODE;
	
	   
	   START_CODE		: if((bl_cnt_bin_ptr == max_code_length) && (hw_hw_ready_in | ~deflate_mode))
                                       htw_nxt_st					 = FINAL_CODE;
	                          else if(bl_cnt_bin_ptr == max_code_length)
                                       htw_nxt_st					 = WAIT_FOR_READY;

           
	   
	   
	   HANDSHAKE		: if(hw_hw_ready_in)
	                               htw_nxt_st					 = WAIT_FOR_STSG;

	   WAIT_FOR_READY       : if(hw_hw_ready_in)
	                              htw_nxt_st					 = FINAL_CODE;

           
	   FINAL_CODE		: if(max_sym_used <= {{DAT_WIDTH-2{1'b0}},2'h2} || 
                                     {1'b0,final_code_sym_ptr} >= max_sym_used-2)
				    begin
                                             htw_nxt_st					 = WAIT_FOR_STSG;
				    end

	   
           
	   WAIT_FOR_STSG        : if(stsg_hw_not_ready==0)
                                           htw_nxt_st					 = IDLE;
	
      endcase 
     
     
     retro_bl_rd_ptr_c									 = 0;
     if(htw_curr_st == BL_CNT)
	 retro_bl_rd_ptr_c								 = retro_bl_rd_ptr + `PRE_HUF_TABLE_NUM_SYM_PER_READ;


     
     retro_bl_table_piped_c								 = 0;
     if(htw_curr_st==BL_CNT)
       begin
         for(int i=0;i < `PRE_HUF_TABLE_NUM_SYM_PER_READ;i++)
	       if(i+retro_bl_rd_ptr < {25'b0,max_sym_used}) 
		 begin
	             if(retro_bl_table[i+retro_bl_rd_ptr] < max_code_length) 
                     
                              retro_bl_table_piped_c[i]		                         = retro_bl_table[i+retro_bl_rd_ptr];
		    
		 end
       end

       
     retro_bl_cnt_c									 = retro_bl_cnt;
     if(htw_curr_st==IDLE)
        retro_bl_cnt_c									 = 0;
     else
       begin
         for(int i=0;i < `PRE_HUF_TABLE_NUM_SYM_PER_READ;i++)
	      if(retro_bl_table_piped[i] != 0) 

                              retro_bl_cnt_c[retro_bl_table_piped[i]]		         = retro_bl_cnt_c[retro_bl_table_piped[i]] + 1;
		    

       end
     
      
      bl_cnt_bin_ptr_c									 = 1;
      if(htw_curr_st == START_CODE && bl_cnt_bin_ptr != max_code_length)
              bl_cnt_bin_ptr_c								 = bl_cnt_bin_ptr + 1;

      
      retro_start_code_c								 = retro_start_code;
      retro_start_code_c[0]								 = 0;
      if(htw_curr_st == START_CODE)
           retro_start_code_c[bl_cnt_bin_ptr]						 = (retro_start_code[bl_cnt_bin_ptr-1] + retro_bl_cnt[bl_cnt_bin_ptr-1]) << 1;


      
      ph_rd_credit_count_c                                                                = ph_rd_credit_count;
      if(htw_curr_st==WAIT_FOR_IN_STABLE)
         ph_rd_credit_count_c                                                            = 0;
      else if(hw_ph_rd && ~ph_hw_sym_val_r)
         ph_rd_credit_count_c                                                            = ph_rd_credit_count + 1;
      else if(~hw_ph_rd && ph_hw_sym_val_r)
         ph_rd_credit_count_c                                                            = ph_rd_credit_count - 1;

      hw_ph_rd_c                                                                         = 0;
      
      if((htw_curr_st==BL_CNT || htw_curr_st==WAIT_FOR_PRE_DATA) && (pre_bl_req_cnt + `CREOLE_HC_PHT_WIDTH/CODELENGTH_WIDTH < {1'b0,max_sym_used}))
        begin
             hw_ph_rd_c								         = process_pre;
        end

      hw_ph_sym_addr_c									 = 0;
      pre_bl_req_cnt_c								         = pre_bl_req_cnt;
      if(htw_curr_st==WAIT_FOR_IN_STABLE)
	pre_bl_req_cnt_c								 = 0;
      else if(hw_ph_rd)
	begin
	     hw_ph_sym_addr_c								 = hw_ph_sym_addr + 1;
             pre_bl_req_cnt_c								 = pre_bl_req_cnt + `CREOLE_HC_PHT_WIDTH/CODELENGTH_WIDTH;
	end

      pre_bl_wr_ptr_c									 = 0;
      if(ph_hw_sym_val_r)
        begin
            pre_bl_wr_ptr_c 								 = pre_bl_wr_ptr + `CREOLE_HC_PHT_WIDTH/CODELENGTH_WIDTH;

        end

     
      pre_bl_table_c									 = pre_bl_table;
      pre_bl_table_val_c                                                                 = pre_bl_table_val;
      if(htw_curr_st==CHECK_INPUT)
	begin
	    pre_bl_table_c                                                               = 0;
            pre_bl_table_val_c                                                           = 0;
	end
      else
          for(int i=0;i < (`CREOLE_HC_PHT_WIDTH/CODELENGTH_WIDTH);i++)
	    
      	       if(ph_hw_sym_val_r &&
                  (i+pre_bl_wr_ptr) < {25'b0,max_sym_used})
		       begin
		           if(bit_swap(ph_hw_sym_dpth_r[i*CODELENGTH_WIDTH+:CODELENGTH_WIDTH]) <= max_code_length)
      	                        pre_bl_table_c[i+pre_bl_wr_ptr]				 = bit_swap(ph_hw_sym_dpth_r[i*CODELENGTH_WIDTH+:CODELENGTH_WIDTH]);
			   else
			        pre_bl_table_c[i+pre_bl_wr_ptr]				 = 0;
			   pre_bl_table_val_c[i+pre_bl_wr_ptr]                           = 1;
		       end


     
     pre_bl_table_piped_c								 = 0;
     pre_bl_rd_ptr_c                                                                     = pre_bl_rd_ptr;
     if(htw_curr_st==CHECK_INPUT)
        pre_bl_rd_ptr_c                                                                  = 0;
     else
        for(int i=0;i < `PRE_HUF_TABLE_NUM_SYM_PER_READ;i++)
	    if(pre_bl_table_val[i+pre_bl_rd_ptr] && i+pre_bl_rd_ptr < {25'b0,max_sym_used}) 
		 begin
	             

                              pre_bl_table_piped_c[i]		                         = pre_bl_table[i+pre_bl_rd_ptr];
			      pre_bl_rd_ptr_c						 = pre_bl_rd_ptr + `PRE_HUF_TABLE_NUM_SYM_PER_READ;

		    
		 end

       
       pre_bl_cnt_c									 = pre_bl_cnt;
       if(htw_curr_st==IDLE)
         pre_bl_cnt_c									 = 0;
       else 
         begin
           for(int i=0;i < `PRE_HUF_TABLE_NUM_SYM_PER_READ;i++)
	      if(pre_bl_table_piped[i] != 0) 

                              pre_bl_cnt_c[pre_bl_table_piped[i]]		         = pre_bl_cnt_c[pre_bl_table_piped[i]] + 1;
		    

         end
       
      
      pre_start_code_c									 = pre_start_code;
      pre_start_code_c[0]								 = 0;
      if(htw_curr_st == START_CODE)
         pre_start_code_c[bl_cnt_bin_ptr]						 = (pre_start_code[bl_cnt_bin_ptr-1] + pre_bl_cnt[bl_cnt_bin_ptr-1]) << 1;

      
      final_code_sym_ptr_c							         = final_code_sym_ptr;
      if(htw_curr_st==CHECK_INPUT)
            final_code_sym_ptr_c							 = 0;
      else if (htw_curr_st==FINAL_CODE) 
      	    final_code_sym_ptr_c							 = final_code_sym_ptr + 2;

      
      retro_bl_c								         = 0;
      pre_bl_c								                 = 0;
      for(int i=0;i < 2;i++)
	   if(i+final_code_sym_ptr < {25'b0,max_sym_used})
	      begin
                retro_bl_c[i]								 = retro_bl_table[i+final_code_sym_ptr];
		pre_bl_c[i]								 = pre_bl_table[i+final_code_sym_ptr];
              end
     
      
      hw_ht_sym_freq_rd_addr_c								 = 0;
      if(htw_curr_st==FINAL_CODE)
           hw_ht_sym_freq_rd_addr_c							 = final_code_sym_ptr[DAT_WIDTH-1:1];
      
      hw_ht_sym_freq_rd_done_c								 = 0;
      if(htw_curr_st==FINAL_CODE && 
        ((max_sym_used <= {{DAT_WIDTH-2{1'b0}},2'h2} && final_code_sym_ptr==0) || {1'b0,final_code_sym_ptr} >= max_sym_used-2)) 
           hw_ht_sym_freq_rd_done_c							 = 1;
      
      hw_ht_sym_freq_rd_c								 = htw_curr_st==FINAL_CODE;


      
      retro_size_multiplier_c	                                                         = 0;
      if(ht_hw_rd_freq_val[`HT_HW_FREQ_RD_LATENCY-1])
	 begin

            for(int i=0;i < 2;i++)

	          
	          if(i+final_code_sym_ptr_r[`HT_HW_FREQ_RD_LATENCY] < {25'b0,max_sym_used})

                         retro_size_multiplier_c[i]          				 = retro_bl_table[i+final_code_sym_ptr_r[`HT_HW_FREQ_RD_LATENCY]] * 
                                               ({SYM_FREQ_WIDTH{ht_hw_sym_sort_freq_val_r[i]}} & ht_hw_sym_sort_freq_r[i*SYM_FREQ_WIDTH+:SYM_FREQ_WIDTH]);
	                 
	 end

      
      hw_lut_ret_size_c							                 = hw_lut_ret_size;
      if(htw_curr_st==CHECK_INPUT)
          hw_lut_ret_size_c							         = 0;
      else
          for(int i=0;i < 2;i++)
         	hw_lut_ret_size_c					                 = retro_size_multiplier[i] +  
                                                                                           hw_lut_ret_size_c;

       
      
      retro_bl_select_c                                                                  = retro_bl_select;
      pre_bl_select_c                                                                    = pre_bl_select;
      if(htw_curr_st==CHECK_INPUT)
	begin
	   retro_bl_select_c                                                             = 0;
	   pre_bl_select_c                                                               = 0;
	end
      else if(htw_curr_st==FINAL_CODE)
	  for(int i=0;i < 2;i++)

	          if(i+final_code_sym_ptr < {25'b0,max_sym_used})
		     begin
                       retro_bl_select_c[i]						 = retro_bl_table[i+final_code_sym_ptr];
		       pre_bl_select_c[i]                                                = pre_bl_table[i+final_code_sym_ptr];
		     end
     
      
      retro_sym_code_c									 = 0;
      pre_sym_code_c									 = 0;
      hw_lut_wr_val_c									 = 0;
      if(htw_prev_st==FINAL_CODE)
	  for(int i=0;i < 2;i++)

	          if(i+final_code_sym_ptr_r[0] < {25'b0,max_sym_used})
		     begin
                       retro_sym_code_c[i]						 = retro_start_code_c[retro_bl_select[i]];
		       if(retro_bl_select[i]!=0)
                          retro_start_code_c[retro_bl_select[i]]	                 = retro_start_code_c[retro_bl_select[i]] + 1;
			
		       pre_sym_code_c[i]						 = pre_start_code_c[pre_bl_select[i]];
		       if(pre_bl_select[i]!=0)
                          pre_start_code_c[pre_bl_select[i]]		                 = pre_start_code_c[pre_bl_select[i]] + 1;
			
		       hw_lut_wr_val_c[i]						 = 1'b1;
		     end


      
      pre_size_multiplier_c	                                                         = 0;
      if(ht_hw_rd_freq_val[`HT_HW_FREQ_RD_LATENCY-1])
	 begin

            for(int i=0;i < 2;i++)

	          
	          if(i+final_code_sym_ptr_r[`HT_HW_FREQ_RD_LATENCY] < {25'b0,max_sym_used})

                         pre_size_multiplier_c[i]          				 = pre_bl_table[i+final_code_sym_ptr_r[`HT_HW_FREQ_RD_LATENCY]] * 
                                               ({SYM_FREQ_WIDTH{ht_hw_sym_sort_freq_val_r[i]}} & ht_hw_sym_sort_freq_r[i*SYM_FREQ_WIDTH+:SYM_FREQ_WIDTH]);
	                 
	 end  

      
      
      hw_lut_pre_size_c	                                                                 = hw_lut_pre_size;
      if(htw_curr_st==CHECK_INPUT)
	   hw_lut_pre_size_c 							         = 0;
      else 
         for(int i=0;i < 2;i++)
             hw_lut_pre_size_c						                 = pre_size_multiplier[i] + hw_lut_pre_size_c;

      
      sim_size_multiplier_c	                                                         = 0;
      if(ht_hw_rd_freq_val[`HT_HW_FREQ_RD_LATENCY-1])
	 begin

            for(int i=0;i < 2;i++)
	        begin

	            
	            
	            if(i+final_code_sym_ptr_r[`HT_HW_FREQ_RD_LATENCY] <= {23'b0,simple_bl[0].sym})
		       	   sim_size_multiplier_c[i]                			 = simple_bl[0].bl * 
                                                                                           ({SYM_FREQ_WIDTH{ht_hw_sym_sort_freq_val_r[i]}} & ht_hw_sym_sort_freq_r[i*SYM_FREQ_WIDTH+:SYM_FREQ_WIDTH]);
                       

                   
	           else if(i+final_code_sym_ptr_r[`HT_HW_FREQ_RD_LATENCY] <= {23'b0,simple_bl[1].sym})
                       	sim_size_multiplier_c[i]					 = simple_bl[1].bl * 
                                                                                           ({SYM_FREQ_WIDTH{ht_hw_sym_sort_freq_val_r[i]}} & ht_hw_sym_sort_freq_r[i*SYM_FREQ_WIDTH+:SYM_FREQ_WIDTH]);
		end
	                 
	 end  
	   
      
      
      hw_lut_sim_size_c							                 = hw_lut_sim_size;
      if(htw_curr_st==CHECK_INPUT)
	    hw_lut_sim_size_c                                                            = 0;
      else
         for(int i=0;i < 2;i++)
	    hw_lut_sim_size_c						                 = sim_size_multiplier[i] + 
                                                                                           hw_lut_sim_size_c;

       
      hw_lut_wr_c									 = htw_prev_st == FINAL_CODE;

      if(deflate_mode && ht_hw_sym_unique_r >= MAX_NUM_SYM_USED-1 && final_code_sym_ptr_r[0]==sym_hi && sym_hi>=2)
	
	begin
	   hw_lut_wr_data_c								 = '{
      						                                             '{retro_sym_code_c[1],retro_bl[1],
      						                                               pre_sym_code_c[1],pre_bl[1]},
                                                                                             '{{{`MAX_XP_CODE_LENGTH-1{1'b0}},1'b1},retro_bl[0],
      						                                               pre_sym_code_c[0],pre_bl[0]}
                                                                                            };
        end
      else if(deflate_mode && ht_hw_sym_unique_r >= MAX_NUM_SYM_USED-1 && final_code_sym_ptr_r[0]+1==sym_hi && sym_hi>=2)
	
	begin
	   hw_lut_wr_data_c								 = '{
      						                                             '{{{`MAX_XP_CODE_LENGTH-1{1'b0}},1'b1},retro_bl[1],
      						                                               pre_sym_code_c[1],pre_bl[1]},
                                                                                             '{retro_sym_code_c[0],retro_bl[0],
      						                                               pre_sym_code_c[0],pre_bl[0]}
                                                                                            };
	end
      else
	begin
	   hw_lut_wr_data_c								 = '{
      						                                             '{retro_sym_code_c[1],retro_bl[1],
      						                                               pre_sym_code_c[1],pre_bl[1]},
                                                                                             '{retro_sym_code_c[0],retro_bl[0],
      						                                               pre_sym_code_c[0],pre_bl[0]}
                                                                                            };
	end
                                                                                            
      hw_lut_wr_addr_c									 = htw_prev_st == FINAL_CODE ? final_code_sym_ptr_r[0][DAT_WIDTH-1:1] : 0;
      hw_lut_wr_done_c                                                                   = htw_prev_st == FINAL_CODE && htw_curr_st != FINAL_CODE ? 1'b1 : 0;

      

      hw_hw_val_out_c                                                                    = 0;
      hw_hw_codes_out_c                                                                  = 0;
      
      if((htw_curr_st==HANDSHAKE) || (htw_curr_st==FINAL_CODE && sym_hi==0))
	 begin
	      if(hw_hw_ready_in)
		begin
                    
                    hw_hw_val_out_c                                                      = 2'b11;
	            hw_hw_codes_out_c                                                    = {{{CODELENGTH_WIDTH-1{1'b0}},1'b1},{{CODELENGTH_WIDTH-1{1'b0}},1'b1}};
		end
	 end
      else if(ht_hw_sym_unique_r >= MAX_NUM_SYM_USED-1 && sym_hi==1)
	begin
	      if(htw_curr_st==FINAL_CODE)
		begin
                    
                    hw_hw_val_out_c                                                      = 2'b11;
	            hw_hw_codes_out_c                                                    = { {{CODELENGTH_WIDTH-1{1'b0}},1'b1},{CODELENGTH_WIDTH{1'b0}} };
		end
	      else if(htw_curr_st==WAIT_FOR_STSG)
		begin
		    hw_hw_val_out_c                                                      = 2'b01;
	            hw_hw_codes_out_c                                                    = { {CODELENGTH_WIDTH{1'b0}},{{CODELENGTH_WIDTH-1{1'b0}},1'b1} };
		end
	 end
      else if(htw_curr_st==FINAL_CODE)
	 begin
	     for(int i=0;i < 2;i++) 
		  if(i+final_code_sym_ptr < {25'b0,max_sym_used})
		     begin
		        hw_hw_val_out_c[i]                                               = 1;
			
			if(ht_hw_sym_unique_r >= MAX_NUM_SYM_USED-1 && i+final_code_sym_ptr==0)
			  hw_hw_codes_out_c[i]                                           = 1;
			else
                          hw_hw_codes_out_c[i]                                           = retro_bl_c[i];
			
		     end
	 end
     
      hw_hw_sym_hi_out_c                                                                 = sym_hi;
      hw_hw_build_error_out                                                              = ht_hw_build_error_r;	
	    
      hw_hw_last_out_c                                                                   = 0;
      
      if((htw_curr_st==HANDSHAKE) || (htw_curr_st==FINAL_CODE && sym_hi==0))
	  begin
	    hw_hw_last_out_c                                                             = 1;
	    hw_hw_sym_hi_out_c                                                           = {{DAT_WIDTH-1{1'b0}},1'b1};
	  end
      else if(ht_hw_sym_unique_r >= MAX_NUM_SYM_USED-1 && sym_hi==1)
	  begin
	   
	    if(htw_curr_st==FINAL_CODE) 
	      hw_hw_last_out_c                                                           = 0;
	    else if(htw_curr_st==WAIT_FOR_STSG)
	      hw_hw_last_out_c                                                           = 1;
	        
	    hw_hw_sym_hi_out_c                                                           = {{DAT_WIDTH-2{1'b0}},2'd2};
	     
	  end
      else if(htw_curr_st==FINAL_CODE &&
	((max_sym_used <= {{DAT_WIDTH-2{1'b0}},2'h2} && final_code_sym_ptr==0) || {1'b0,final_code_sym_ptr} >= max_sym_used-2))
            hw_hw_last_out_c                                                             = 1;
     

      
      hw_stsg_val_c									 = hw_stsg_val;
      hw_stsg_symbol_c								         = hw_stsg_symbol;
      if(htw_curr_st==WAIT_FOR_IN_STABLE)
	begin
            hw_stsg_symbol_c								 = 0;
	    hw_stsg_val_c								 = 0;
	end
      else if(~deflate_mode && htw_curr_st==FINAL_CODE)
	begin
	     for(int i=0;i < 2;i++) 
		  if(i+final_code_sym_ptr < {25'b0,max_sym_used})
		    begin
		         hw_stsg_val_c[final_code_sym_ptr + i]				 = 1;
		         hw_stsg_symbol_c[final_code_sym_ptr + i]	                 = retro_bl_c[i];
		     end
	end

      hw_stsg_sym_hi_b_c                                                                   = sym_hi;
      
      
      hw_ht_not_ready									 = (htw_curr_st != IDLE) ||
                                                                                            lut_hw_full || hw_lut_wr_r || 
											     
                                                                                            ism_not_ready ||
                                                                                            hw_lut_wr ||
                                                                                            stsg_hw_not_ready;
      
      
      if(htw_curr_st != WAIT_FOR_STSG && htw_nxt_st == WAIT_FOR_STSG && (ht_hw_build_error_r || ht_hw_zero_symbols_r) && ~deflate_mode)
      	  hw_stsg_eob_c									 = PASS_THRU;
      
      else if(htw_curr_st != WAIT_FOR_STSG && htw_nxt_st == WAIT_FOR_STSG && ~deflate_mode)
      	  hw_stsg_eob_c									 = eob_store;
      else if(htw_curr_st==WAIT_FOR_IN_STABLE)
      
	  hw_stsg_eob_c									 = MIDDLE;
      else
      
      	  hw_stsg_eob_c									 = hw_stsg_eob;

  end 


  assign long_bl_ism_data.unused0                                                        = 0;
  assign long_bl_ism_data.unused1                                                        = 0;
  assign long_bl_ism_data.tid                                                            = 0;   
   
  

   cr_huf_comp_ism_catcher
    #(
      .DAT_WIDTH        (`CREOLE_HC_LONG_DAT_WIDTH), 
      .CODELENGTH_WIDTH (`CREOLE_HC_SYM_CODELENGTH),     
      .ISM_CODELENGTH_WIDTH (8),
      .MAX_NUM_SYM_USED (`CREOLE_HC_LONG_NUM_MAX_SYM_USED)
     )
    u_ism_catcher (
		   
		   .ism_not_ready	(ism_not_ready),
		   .rd_eob		(long_bl_ism_data.eob),	 
		   .rd_build_error	(long_bl_ism_data.build_error), 
		   .rd_data		({long_bl_ism_data.bl_7_4,long_bl_ism_data.bl_3_0}), 
		   .rd_no_sym		(long_bl_ism_data.no_data), 
		   .rd_seq_id		(),			 
		   .rd_vld		(long_bl_ism_vld),	 
		   
		   .clk			(clk),
		   .rst_n		(rst_n),
		   .sym_dpth_in		(retro_bl_table),	 
		   .zero_symbols_in	(ht_hw_zero_symbols_r),	 
		   .build_error_in	(ht_hw_build_error_r),	 
		   .seq_id_in		(hw_stsg_seq_id),	 
		   .eob_in		(ht_hw_eob),		 
		   .sw_ism_on		(sw_ism_on),
		   .ism_rdy		(long_ism_rdy));		 

 
function logic [CODELENGTH_WIDTH-1:0] bit_swap;
      input [CODELENGTH_WIDTH-1:0] symbol_in;
   begin
      bit_swap = 0;
      for(int i=0;i<CODELENGTH_WIDTH;i++)
	begin
	   if(i<CODELENGTH_WIDTH)
	      bit_swap[CODELENGTH_WIDTH-1 - i] = symbol_in[i];
	end
      
   end
endfunction  

assign clk_gate_open =  (htw_curr_st != IDLE && htw_curr_st != WAIT_FOR_STSG) |
                        ht_hw_eob != MIDDLE |
			(htw_prev_st != IDLE  && htw_curr_st == IDLE) |
			(htw_curr_st == WAIT_FOR_STSG && ~stsg_hw_not_ready) |
                        (|ht_hw_rd_freq_val)|
                        hw_lut_sizes_val;
		 
  
`ifdef CLK_GATE  
    cr_clk_gate dont_touch_clk_gate ( .i0(1'b0), .i1(clk_gate_open), .phi(clk), .o(clk_gated) );
`else
    assign clk_gated = clk;
`endif
   
endmodule 








