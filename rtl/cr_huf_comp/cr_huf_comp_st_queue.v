/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











`include "cr_huf_comp.vh"

module cr_huf_comp_st_queue
   #(parameter
    DAT_WIDTH        =10,       
    MAX_SYMBOL_TABLE_DEPTH =584 
   )
  (
   
   hdr_ht_type_mod, st_extra_size_store, sym_buf_wr_ptr, sym_buf_full,
   st_deflate_store, st_hdist_store, st_hlit_store, st_build_error,
   st_seq_id, st_eob, sym_buf,
   
   clk, rst_n, hw_st_val, hw_st_symbol, hw_st_extra,
   hw_st_extra_length, hw_st_last_ptr, hw_st_extra_size, hw_st_seq_id,
   hw_st_hlit, hw_st_hdist, hw_st_deflate, hw_st_eob,
   hw_st_build_error, sa_st_read_done
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
                                                               
                                                               
 
 input                                       sa_st_read_done;
                                                             
                                                             
                                                             
                                                             

   
 
 
 
   
 output s_seq_id_type_intf                   hdr_ht_type_mod;   
 output logic [`CREOLE_HC_SMALL_TABLE_XTR_BIT_SIZE:0] st_extra_size_store;
 output logic [`LOG_VEC(MAX_SYMBOL_TABLE_DEPTH+1)] sym_buf_wr_ptr;
 output logic                                      sym_buf_full;
 output logic 			             st_deflate_store;  
 output logic [`CREOLE_HC_HDIST_WIDTH-1:0]   st_hdist_store;    
 output logic [`CREOLE_HC_HLIT_WIDTH-1:0]    st_hlit_store;     
 output logic                                st_build_error;    
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]   st_seq_id;         
 output e_pipe_eob                           st_eob;            
 output s_st_sym_buf_intf [MAX_SYMBOL_TABLE_DEPTH-1:0] sym_buf;


 
 

 s_seq_id_type_intf                         hdr_ht_type_mod_c;
 logic [`CREOLE_HC_SMALL_TABLE_XTR_BIT_SIZE:0] st_extra_size_store_c;
 logic [`LOG_VEC(MAX_SYMBOL_TABLE_DEPTH+1)] sym_buf_wr_ptr_c;
 logic                                      sym_buf_full_c;
 logic 			     st_deflate_store_c;
 logic                       st_build_error_c;
 logic [`CREOLE_HC_HDIST_WIDTH-1:0]  st_hdist_store_c;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0]  st_seq_id_c;
 logic [`CREOLE_HC_HLIT_WIDTH-1:0]  st_hlit_store_c;
 e_pipe_eob                         st_eob_c;

 logic                                     clk_gate_open,clk_gated;
  
s_st_sym_buf_intf [MAX_SYMBOL_TABLE_DEPTH-1:0] sym_buf_c;
   
 
 
 
 
always_ff @(posedge clk_gated or negedge rst_n)
begin
  if (~rst_n) 
    begin
     st_eob <= MIDDLE;
     
     
     hdr_ht_type_mod <= 0;
     st_build_error <= 0;
     st_deflate_store <= 0;
     st_extra_size_store <= 0;
     st_hdist_store <= 0;
     st_hlit_store <= 0;
     st_seq_id <= 0;
     sym_buf <= 0;
     sym_buf_full <= 0;
     sym_buf_wr_ptr <= 0;
     
    end
  else
    begin

       
       hdr_ht_type_mod		<= hdr_ht_type_mod_c;
       
       st_deflate_store		<= st_deflate_store_c;
       
       st_extra_size_store	<= st_extra_size_store_c;
       
       st_hlit_store		<= st_hlit_store_c;
       
       st_hdist_store		<= st_hdist_store_c;
       
       sym_buf_full		<= sym_buf_full_c;
       
       sym_buf			<= sym_buf_c;
       
       sym_buf_wr_ptr		<= sym_buf_wr_ptr_c;
       
       st_build_error           <= st_build_error_c;
       
       st_seq_id                <= st_seq_id_c;
       
       st_eob                   <= st_eob_c;
       
    end
end
    
always_comb
begin



     sym_buf_full_c				 = sym_buf_full;
     if(sa_st_read_done)
       sym_buf_full_c				 = 0;
     else if(hw_st_eob!=MIDDLE)
       sym_buf_full_c				 = 1;




     sym_buf_wr_ptr_c				 = sym_buf_wr_ptr;
     sym_buf_c					 = sym_buf;
     if(sa_st_read_done)
        begin
	    sym_buf_wr_ptr_c			 = 0;
            sym_buf_c                            = 0;
	end
     else
	begin
	      if(hw_st_eob!=MIDDLE)
		begin
                   for(int i=0;i<MAX_SYMBOL_TABLE_DEPTH;i++)
		      sym_buf_c[i]	         = '{extra:hw_st_extra[i],extra_length:hw_st_extra_length[i],symbol:hw_st_symbol[i],val:hw_st_val[i]}; 
		   sym_buf_wr_ptr_c		 = hw_st_last_ptr;
		end
	end




     st_extra_size_store_c			 = st_extra_size_store;
     st_hlit_store_c				 = st_hlit_store;
     st_hdist_store_c				 = st_hdist_store;
     st_deflate_store_c				 = st_deflate_store;
     st_build_error_c                            = st_build_error;
     st_seq_id_c                                 = st_seq_id;
     hdr_ht_type_mod_c				 = hdr_ht_type_mod;
     st_eob_c                                    = st_eob;
     if(hw_st_eob!=MIDDLE)
       begin
	  st_extra_size_store_c			 = hw_st_extra_size;
	  st_hlit_store_c			 = hw_st_hlit;
	  st_hdist_store_c			 = hw_st_hdist; 
	  st_deflate_store_c			 = hw_st_deflate;
	  st_build_error_c                       = hw_st_build_error;
	  st_seq_id_c                            = hw_st_seq_id;
	  st_eob_c                               = hw_st_eob;

	  
	  
	  if(hw_st_deflate)
	     hdr_ht_type_mod_c			 = '{comp_mode:GZIP,lz77_win_size:WIN_64K,xp10_prefix_mode:NO_PREFIX};
	  else
	     hdr_ht_type_mod_c			 = '{comp_mode:XP10,lz77_win_size:WIN_64K,xp10_prefix_mode:NO_PREFIX};

       end 


end 

assign clk_gate_open =  sym_buf_full | 
                        (hw_st_eob != MIDDLE);
		 
  
`ifdef CLK_GATE  
    cr_clk_gate dont_touch_clk_gate ( .i0(1'b0), .i1(clk_gate_open), .phi(clk), .o(clk_gated) );
`else
    assign clk_gated = clk;
`endif   

   
endmodule 









