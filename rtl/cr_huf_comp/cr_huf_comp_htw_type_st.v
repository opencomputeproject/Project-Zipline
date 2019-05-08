/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/












`include "cr_huf_comp.vh"

module cr_huf_comp_htw_type_st
  #(parameter
    DAT_WIDTH        =6,       
    SYM_FREQ_WIDTH   =10,      
    SYM_ADDR_WIDTH   =6,       
    CODELENGTH_WIDTH =4,       
    MAX_NUM_SYM_USED =33       
   )
  (
   
   hw_ht_sym_freq_rd, hw_ht_sym_freq_seq_id, hw_ht_sym_freq_rd_addr,
   hw_ht_sym_freq_rd_done, hw_ht_not_ready, st_lut_symb_code,
   st_lut_symb_codelength, hw_lut_ret_size, hw_lut_seq_id,
   hw_st_symbol, hw_st_seq_id, hw_st_eob, hw_st_build_error,
   hw_st_max_sym_table, st_bl_ism_data, st_bl_ism_vld,
   
   clk, rst_n, ht_hw_sym_lo, ht_hw_sym_hi, ht_hw_sym_sort_freq,
   ht_hw_sym_sort_freq_val, ht_hw_sym_dpth, ht_hw_zero_symbols,
   ht_hw_build_error, ht_hw_seq_id, ht_hw_eob, st_hw_not_ready,
   hdr_hw_type, sw_ism_on, st_ism_rdy
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
                                                             
                                                             
                                                             
                                                             
 
 input 				             st_hw_not_ready;
   
 
 input s_seq_id_type_intf   	             hdr_hw_type;    

 
 input	                                     sw_ism_on;

 
 input		                             st_ism_rdy;

 
 
 

 
 output logic	                              hw_ht_sym_freq_rd;
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]    hw_ht_sym_freq_seq_id;
 output logic [SYM_ADDR_WIDTH-2:0]            hw_ht_sym_freq_rd_addr;
 output logic                                 hw_ht_sym_freq_rd_done; 
 output logic 				      hw_ht_not_ready;

 
 output logic [MAX_NUM_SYM_USED-1:0][`CREOLE_HC_MAX_ST_XP_CODE_LENGTH-1:0] st_lut_symb_code;
 output logic [MAX_NUM_SYM_USED-1:0][`LOG_VEC(`CREOLE_HC_MAX_ST_XP_CODE_LENGTH+1)] st_lut_symb_codelength;
   
 output logic [`CREOLE_HC_ST_MAX_BITS_WIDTH-1:0] hw_lut_ret_size;
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]    hw_lut_seq_id;  
   
 
 output logic [MAX_NUM_SYM_USED-1:0][CODELENGTH_WIDTH-1:0] hw_st_symbol;
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]    hw_st_seq_id;
 output e_pipe_eob                            hw_st_eob;     
                                                             
                                                             
                                                             
                                                             
 output logic                                 hw_st_build_error;
                                                                
                                                                
 
 output logic [DAT_WIDTH-1:0]                 hw_st_max_sym_table;

 
 output st_sh_bl_t                            st_bl_ism_data;
 output                                       st_bl_ism_vld; 

 
 
 logic			ism_not_ready;		
 
 
 logic [MAX_NUM_SYM_USED-1:0][CODELENGTH_WIDTH-1:0] retro_bl_table;
 logic [DAT_WIDTH-1:0]                        sym_lo;
 logic [DAT_WIDTH-1:0]                        sym_hi;
 e_pipe_eob                                   eob_store;
 logic [DAT_WIDTH-1:0]                        retro_bl_rd_ptr,retro_bl_rd_ptr_c;
 logic [`CREOLE_HC_MAX_ST_XP_CODE_LENGTH-1:0][DAT_WIDTH-1:0] retro_bl_cnt,retro_bl_cnt_c;
 logic [CODELENGTH_WIDTH-1:0]                 bl_cnt_bin_ptr,bl_cnt_bin_ptr_c;
 logic [`CREOLE_HC_MAX_ST_XP_CODE_LENGTH:0][`CREOLE_HC_MAX_ST_XP_CODE_LENGTH-1:0] retro_start_code,retro_start_code_c;
 logic                                        ht_hw_build_error_r;
 logic                                        ht_hw_zero_symbols_r;   
 logic [DAT_WIDTH-1:0]                        final_code_sym_ptr,final_code_sym_ptr_c;
 logic [2:0]                                  ht_hw_rd_freq_val;
 logic [(SYM_FREQ_WIDTH * 2)-1:0]             ht_hw_sym_sort_freq_r; 
 logic [1:0]                                  ht_hw_sym_sort_freq_val_r;
 logic [2:0][DAT_WIDTH-1:0]                   final_code_sym_ptr_r;
 logic                                        hw_ht_sym_freq_rd_c; 
 logic [SYM_ADDR_WIDTH-2:0]                   hw_ht_sym_freq_rd_addr_c; 
 logic                                        hw_ht_sym_freq_rd_done_c; 
 logic [12:0]                                 hw_lut_ret_size_c; 
 logic [MAX_NUM_SYM_USED-1:0][`CREOLE_HC_MAX_ST_XP_CODE_LENGTH-1:0] retro_sym_code_c,retro_sym_code;
 logic [DAT_WIDTH-1:0]                        max_sym_used;
 e_pipe_eob                                   hw_st_eob_c;
 logic [CODELENGTH_WIDTH-1:0]                 max_code_length;
 logic [DAT_WIDTH-1:0]                        max_sym_table;
 logic                                        deflate_mode,deflate_mode_c;
 logic [1:0][CODELENGTH_WIDTH-1:0]            retro_bl_select,retro_bl_select_c;
 logic [1:0][12:0]                            retro_size_multiplier,retro_size_multiplier_c;
 logic [3:0][CODELENGTH_WIDTH-1:0]            retro_bl_table_piped,retro_bl_table_piped_c;

 logic                                        clk_gate_open,clk_gated;



 typedef enum 		 {IDLE,
			  WAIT_FOR_IN_STABLE,
                          BL_CNT,
			  WAIT_HISTO_PIPE,
			  CHECK_INPUT,
                          START_CODE,
                          FINAL_CODE
                          }
                         e_tr_walker_state;


   
e_tr_walker_state  htw_curr_st,htw_nxt_st,htw_prev_st; 
                                                    
 
 
 
   

always_ff @(posedge clk_gated or negedge rst_n)
begin
  if (~rst_n) 
  begin
    hw_st_eob <= MIDDLE;
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
    ht_hw_zero_symbols_r <= 0;
    hw_ht_sym_freq_rd <= 0;
    hw_ht_sym_freq_rd_addr <= 0;
    hw_ht_sym_freq_rd_done <= 0;
    hw_ht_sym_freq_seq_id <= 0;
    hw_lut_ret_size <= 0;
    hw_lut_seq_id <= 0;
    hw_st_build_error <= 0;
    hw_st_max_sym_table <= 0;
    hw_st_seq_id <= 0;
    retro_bl_cnt <= 0;
    retro_bl_rd_ptr <= 0;
    retro_bl_select <= 0;
    retro_bl_table <= 0;
    retro_bl_table_piped <= 0;
    retro_size_multiplier <= 0;
    retro_start_code <= 0;
    retro_sym_code <= 0;
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
                     
	   	    hw_st_seq_id		<= ht_hw_seq_id;
	   	    
	   	    hw_lut_seq_id		<= ht_hw_seq_id;
	   	    
	   	    hw_ht_sym_freq_seq_id	<= ht_hw_seq_id;
	        end 
	  	 
	     retro_bl_rd_ptr			<= retro_bl_rd_ptr_c;
             retro_bl_cnt			<= retro_bl_cnt_c;
             bl_cnt_bin_ptr			<= bl_cnt_bin_ptr_c;
             retro_start_code			<= retro_start_code_c;
             final_code_sym_ptr			<= final_code_sym_ptr_c;
	     hw_ht_sym_freq_rd			<= hw_ht_sym_freq_rd_c;
	     hw_ht_sym_freq_rd_addr		<= hw_ht_sym_freq_rd_addr_c;
	     hw_ht_sym_freq_rd_done		<= hw_ht_sym_freq_rd_done_c;
	     hw_lut_ret_size			<= hw_lut_ret_size_c;
             retro_sym_code			<= retro_sym_code_c;
             hw_st_eob				<= hw_st_eob_c;
	     hw_st_build_error		        <= ht_hw_build_error_r; 
	     
             hw_st_max_sym_table                <= max_sym_table;
             
             htw_prev_st                        <= htw_curr_st;
             retro_bl_select                    <= retro_bl_select_c;
	     retro_size_multiplier              <= retro_size_multiplier_c;
             retro_bl_table_piped               <= retro_bl_table_piped_c;
	  
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
    
    end
  else
  begin
       
     
     deflate_mode									<= deflate_mode_c;

     
     if(deflate_mode_c)
          max_code_length                                                               <= `CREOLE_HC_MAX_ST_DEFLATE_CODE_LENGTH;
     else
          max_code_length                                                               <= `CREOLE_HC_MAX_ST_XP_CODE_LENGTH; 

     
     if(deflate_mode_c)
       begin
	      max_sym_table								<= sym_hi + 1;
	      max_sym_used								<= sym_hi + 1;
       end
     else
       begin
	      max_sym_table							        <= `CREOLE_HC_MAX_ST_TABLE_SIZE;
	      max_sym_used							        <= `CREOLE_HC_MAX_ST_TABLE_SIZE;
       end

  end 
end 

always_comb
  begin

      deflate_mode_c									 = hdr_hw_type.comp_mode == GZIP;
  

      
      htw_nxt_st									 = htw_curr_st;
      case(htw_curr_st)
	   IDLE			: if(ht_hw_eob != MIDDLE)
                                       htw_nxt_st					 = WAIT_FOR_IN_STABLE;

	   WAIT_FOR_IN_STABLE   : htw_nxt_st					         = CHECK_INPUT;

	
           
	   CHECK_INPUT          : if(ht_hw_zero_symbols_r)
		                       htw_nxt_st					 = IDLE;
				  else
				       htw_nxt_st					 = BL_CNT;
	
	   
           BL_CNT		: 
                                  
                                  if(retro_bl_rd_ptr + 3'h4 >= {1'b0,max_sym_used}) 
				       htw_nxt_st				         = WAIT_HISTO_PIPE;

	   WAIT_HISTO_PIPE      :  htw_nxt_st					         = START_CODE;

	
	   
	   START_CODE		: if(bl_cnt_bin_ptr == max_code_length) 
                                       htw_nxt_st					 = FINAL_CODE;

           
	   FINAL_CODE		: if({1'b0,final_code_sym_ptr} >= max_sym_used-2)
				    begin
	                                 htw_nxt_st					 = IDLE;
				    end
	
      endcase 
     
     
     retro_bl_rd_ptr_c									 = 0;
     if(htw_curr_st == BL_CNT)
	 retro_bl_rd_ptr_c								 = retro_bl_rd_ptr + 3'h4;

     
     retro_bl_table_piped_c								 = 0;
     if(htw_curr_st==BL_CNT)
       begin
         for(int i=0;i < 4;i++)
	       if(i+retro_bl_rd_ptr < {{(33-DAT_WIDTH){1'b0}},max_sym_used}) 
		 begin
		     
	             if(retro_bl_table[i+retro_bl_rd_ptr] < max_code_length) 

                              retro_bl_table_piped_c[i]		                         = retro_bl_table[i+retro_bl_rd_ptr];
		    
		 end
       end
     

     
     retro_bl_cnt_c									 = retro_bl_cnt;
     if(htw_curr_st==IDLE)
        retro_bl_cnt_c									 = 0;
     else if(htw_curr_st==BL_CNT || htw_curr_st==WAIT_HISTO_PIPE)
       begin
         for(int i=0;i < 4;i++)
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

     
      
      final_code_sym_ptr_c							         = final_code_sym_ptr;
      if(htw_curr_st==CHECK_INPUT)
            final_code_sym_ptr_c							 = {sym_lo[DAT_WIDTH-1:1],1'b0};
      else if (htw_curr_st==FINAL_CODE) 
      	    final_code_sym_ptr_c							 = final_code_sym_ptr + 2;

        
      
      hw_ht_sym_freq_rd_addr_c								 = 0;
      if(htw_curr_st==FINAL_CODE)
           hw_ht_sym_freq_rd_addr_c							 = final_code_sym_ptr[DAT_WIDTH-1:1];
      
      hw_ht_sym_freq_rd_done_c								 = 0;
      if(htw_curr_st==FINAL_CODE && {1'b0,final_code_sym_ptr} >= max_sym_used-2 )
           hw_ht_sym_freq_rd_done_c							 = 1;
      
      hw_ht_sym_freq_rd_c								 = htw_curr_st==FINAL_CODE;


      
      retro_size_multiplier_c	                                                         = 0;
      if(ht_hw_rd_freq_val[`HT_HW_FREQ_RD_LATENCY-1])
	 begin

            for(int i=0;i < 2;i++)

	          
	          if(i+final_code_sym_ptr_r[`HT_HW_FREQ_RD_LATENCY] < {27'b0,max_sym_used})

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
      if(htw_curr_st==CHECK_INPUT)
	begin
	   retro_bl_select_c                                                             = 0;
	end
      else if(htw_curr_st==FINAL_CODE)
	  for(int i=0;i < 2;i++)

	          if(i+final_code_sym_ptr < {27'b0,max_sym_used})
		     begin
                       retro_bl_select_c[i]						 = retro_bl_table[i+final_code_sym_ptr];
		     end
     
      
      retro_sym_code_c									 = retro_sym_code;
      if(htw_prev_st==FINAL_CODE)
	  for(int i=0;i < 2;i++)

	          if(i+final_code_sym_ptr_r[0] < {27'b0,max_sym_used})
		     begin
                       retro_sym_code_c[i+final_code_sym_ptr_r[0]]			 = retro_start_code_c[retro_bl_select[i]];
		       if(retro_bl_select[i]!=0)
                          retro_start_code_c[retro_bl_select[i]]	                 = retro_start_code_c[retro_bl_select[i]] + 1;

		     end

	   
      
      for(int i=0;i < MAX_NUM_SYM_USED;i++)
	  begin
              st_lut_symb_code[i]                                                        = retro_sym_code[i];
              st_lut_symb_codelength[i]                                                  = retro_bl_table[i];
	  end
     
      
      hw_st_symbol                                                                       = 0;
      for(int i=0;i < MAX_NUM_SYM_USED;i++)
	begin
	  if(i < {{(32-DAT_WIDTH){1'b0}},max_sym_used})
	      begin
                 hw_st_symbol[i]	                                                 = retro_bl_table[i];
	      end
	end
     
      
      
      hw_ht_not_ready									 = (htw_curr_st != IDLE) || ism_not_ready;

      
      if(htw_curr_st != IDLE && htw_nxt_st == IDLE && (ht_hw_build_error_r || ht_hw_zero_symbols_r))
      	  hw_st_eob_c									 = PASS_THRU;
      
      else if(htw_curr_st != IDLE && htw_nxt_st == IDLE)
      	  hw_st_eob_c									 = eob_store;
      else
      	  hw_st_eob_c									 = MIDDLE;

end   

assign st_bl_ism_data.unused0 = 0;
assign st_bl_ism_data.unused1 = 0;
assign st_bl_ism_data.tid     = 0;
   
  

   cr_huf_comp_ism_catcher
    #(
      .DAT_WIDTH        (`CREOLE_HC_ST_SYMB_WIDTH), 
      .CODELENGTH_WIDTH (`CREOLE_HC_ST_SYM_CODELENGTH),     
      .ISM_CODELENGTH_WIDTH (8),
      .MAX_NUM_SYM_USED (`CREOLE_HC_ST_SYMB_DEPTH)
     )
    u_ism_catcher (
		   
		   .ism_not_ready	(ism_not_ready),
		   .rd_eob		(st_bl_ism_data.eob),	 
		   .rd_build_error	(st_bl_ism_data.build_error), 
		   .rd_data		({st_bl_ism_data.bl_7_4,st_bl_ism_data.bl_3_0}), 
		   .rd_no_sym		(st_bl_ism_data.no_data), 
		   .rd_seq_id		(),			 
		   .rd_vld		(st_bl_ism_vld),	 
		   
		   .clk			(clk),
		   .rst_n		(rst_n),
		   .sym_dpth_in		(retro_bl_table),	 
		   .zero_symbols_in	(ht_hw_zero_symbols_r),	 
		   .build_error_in	(ht_hw_build_error_r),	 
		   .seq_id_in		(hw_st_seq_id),		 
		   .eob_in		(ht_hw_eob),		 
		   .sw_ism_on		(sw_ism_on),
		   .ism_rdy		(st_ism_rdy));		 

assign clk_gate_open =  htw_curr_st != IDLE |
			htw_prev_st != IDLE |
                        ht_hw_eob != MIDDLE |
                        hw_st_eob != MIDDLE |
                        (|ht_hw_rd_freq_val);
		 

   
`ifdef CLK_GATE  
    cr_clk_gate dont_touch_clk_gate ( .i0(1'b0), .i1(clk_gate_open), .phi(clk), .o(clk_gated) );
`else
    assign clk_gated = clk;
`endif
   
endmodule 









