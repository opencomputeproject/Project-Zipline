/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_huf_comp.vh"

module cr_huf_comp_st_builder
   #(parameter
    
    MAX_SYMBOL_TABLE_DEPTH =584, 
    MAX_NUM_SYM_USED =33         
   )
  (
   
   st_lut_wr, st_lut_wr_data, st_lut_wr_addr, st_lut_wr_done,
   
   clk, rst_n, start_build, st_lut_symb_code, st_lut_symb_codelength,
   sym_buf, sym_buf_wr_ptr, sa_st_read_done
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

 
 
 
 input                                        clk;
 input                                        rst_n; 
 
 
 
 
 
 input 				              start_build;
 
 input  [MAX_NUM_SYM_USED-1:0][`CREOLE_HC_MAX_ST_XP_CODE_LENGTH-1:0] st_lut_symb_code;
 input  [MAX_NUM_SYM_USED-1:0][`LOG_VEC(`CREOLE_HC_MAX_ST_XP_CODE_LENGTH+1)] st_lut_symb_codelength;

 
 
 input s_st_sym_buf_intf [MAX_SYMBOL_TABLE_DEPTH-1:0] sym_buf;
 input [`LOG_VEC(MAX_SYMBOL_TABLE_DEPTH+1)] sym_buf_wr_ptr;
   
   
 
 input                                       sa_st_read_done;
                                                             
                                                             
                                                             
                                                             

   
 
 
 

 
 output logic                               st_lut_wr;      
 output logic [`CREOLE_HC_HDR_WIDTH-1:0]    st_lut_wr_data; 
 output logic [`LOG_VEC(`CREOLE_HC_ST_MAX_BITS/`CREOLE_HC_HDR_WIDTH)] st_lut_wr_addr; 
 output logic                               st_lut_wr_done;

 
 

 logic [`LOG_VEC(MAX_SYMBOL_TABLE_DEPTH+1)] sym_buf_rd_ptr,sym_buf_rd_ptr_c;
 logic [`LOG_VEC(`CREOLE_HC_HDR_WIDTH+4*(`CREOLE_HC_MAX_ST_XP_CODE_LENGTH+8))] coded_sym_ptr,coded_sym_ptr_c;
 logic [`CREOLE_HC_HDR_WIDTH+4*(`CREOLE_HC_MAX_ST_XP_CODE_LENGTH+8)-1:0]  st_lut_build_data,st_lut_build_data_c;
 logic                               st_lut_wr_c;
 logic [`CREOLE_HC_HDR_WIDTH-1:0]    st_lut_wr_data_c;
 logic [`LOG_VEC(`CREOLE_HC_ST_MAX_BITS/`CREOLE_HC_HDR_WIDTH)] st_lut_wr_addr_c;
 logic                               st_lut_wr_done_c;

 logic [3:0]                         symbol_pipe_val_c,symbol_pipe_val;
 logic [3:0] [`CREOLE_HC_MAX_ST_XP_CODE_LENGTH-1:0] symbol_pipe_enc_symbol_c,symbol_pipe_enc_symbol;
 logic [3:0] [`LOG_VEC(`CREOLE_HC_MAX_ST_XP_CODE_LENGTH+1)] symbol_pipe_enc_symbol_length_c,symbol_pipe_enc_symbol_length;
 logic [3:0] [7:0]                   symbol_pipe_extra_c,symbol_pipe_extra;
 logic [3:0] [3:0]                   symbol_pipe_extra_length_c,symbol_pipe_extra_length;     
 



 typedef enum 		 {ST_BLDR_IDLE,
                          ST_BLDR_BUILD
                          }
                         e_st_bldr_state;   
   


e_st_bldr_state st_bldr_nxt_st,st_bldr_curr_st,st_bldr_curr_st_del ; 
 
 
 

always_ff @(posedge clk or negedge rst_n)
begin
  if (~rst_n) 
    begin
    st_bldr_curr_st <= ST_BLDR_IDLE;
    st_bldr_curr_st_del <= ST_BLDR_IDLE;
    
    
    coded_sym_ptr <= 0;
    st_lut_build_data <= 0;
    st_lut_wr <= 0;
    st_lut_wr_addr <= 0;
    st_lut_wr_data <= 0;
    st_lut_wr_done <= 0;
    sym_buf_rd_ptr <= 0;
    symbol_pipe_enc_symbol <= 0;
    symbol_pipe_enc_symbol_length <= 0;
    symbol_pipe_extra <= 0;
    symbol_pipe_extra_length <= 0;
    symbol_pipe_val <= 0;
    
    end
  else
    begin

       
       st_lut_build_data		<= st_lut_build_data_c;
       
       coded_sym_ptr			<= coded_sym_ptr_c;
       
       sym_buf_rd_ptr			<= sym_buf_rd_ptr_c;

       symbol_pipe_val			<= symbol_pipe_val_c    ;
       symbol_pipe_enc_symbol		<= symbol_pipe_enc_symbol_c ;
       symbol_pipe_enc_symbol_length	<= symbol_pipe_enc_symbol_length_c ;
       symbol_pipe_extra		<= symbol_pipe_extra_c     ;
       symbol_pipe_extra_length		<= symbol_pipe_extra_length_c ;

       st_lut_wr			<= st_lut_wr_c; 
       st_lut_wr_data			<= st_lut_wr_data_c;
       st_lut_wr_addr			<= st_lut_wr_addr_c;
       st_lut_wr_done			<= st_lut_wr_done_c; 

       st_bldr_curr_st			<= st_bldr_nxt_st;
       
       st_bldr_curr_st_del		<= sa_st_read_done ? ST_BLDR_IDLE: st_bldr_curr_st;

    end
end   


always_comb
  begin
     

     
     
     st_bldr_nxt_st											 = st_bldr_curr_st;
     case(st_bldr_curr_st)

      ST_BLDR_IDLE:  if(start_build && ~sa_st_read_done)
		       st_bldr_nxt_st									 = ST_BLDR_BUILD;

      
      
      ST_BLDR_BUILD: if(sa_st_read_done || sym_buf_rd_ptr >= sym_buf_wr_ptr)
		       st_bldr_nxt_st									 = ST_BLDR_IDLE;

     endcase 

     
     sym_buf_rd_ptr_c											 = sym_buf_rd_ptr;
     symbol_pipe_val_c											 = 0;
     symbol_pipe_enc_symbol_c										 = 0;
     symbol_pipe_enc_symbol_length_c									 = 0;
     symbol_pipe_extra_c										 = 0;
     symbol_pipe_extra_length_c										 = 0;
     for(int i=0;i<4;i++)
     begin

	 if(st_bldr_curr_st==ST_BLDR_IDLE)
	   sym_buf_rd_ptr_c										 = 0;
	 else if(st_bldr_curr_st==ST_BLDR_BUILD && (sym_buf_rd_ptr_c < MAX_SYMBOL_TABLE_DEPTH))
	   begin
	       
	       symbol_pipe_val_c[i]									 = sym_buf[sym_buf_rd_ptr_c].val;
	       symbol_pipe_enc_symbol_c[i]								 = sym_buf[sym_buf_rd_ptr_c].val ? st_lut_symb_code[sym_buf[sym_buf_rd_ptr_c].symbol] : 0;
	       symbol_pipe_enc_symbol_length_c[i]							 = sym_buf[sym_buf_rd_ptr_c].val ? st_lut_symb_codelength[sym_buf[sym_buf_rd_ptr_c].symbol] : 0;
	       symbol_pipe_extra_c[i]									 = sym_buf[sym_buf_rd_ptr_c].val ? sym_buf[sym_buf_rd_ptr_c].extra : 0;
	       symbol_pipe_extra_length_c[i]								 = sym_buf[sym_buf_rd_ptr_c].val ? sym_buf[sym_buf_rd_ptr_c].extra_length : 0;

	       sym_buf_rd_ptr_c										 = sym_buf_rd_ptr_c + 1;
	   end

	  
     end
     
  end 

 always_comb
   begin
       
      
       
       coded_sym_ptr_c											 = coded_sym_ptr; 
       st_lut_build_data_c										 = st_lut_build_data; 


       if(coded_sym_ptr >= `CREOLE_HC_HDR_WIDTH)
	 begin
	     
	     st_lut_build_data_c									 = 0;
             
	     st_lut_build_data_c[0+:4*(`CREOLE_HC_MAX_ST_XP_CODE_LENGTH+8)]				 = st_lut_build_data[`CREOLE_HC_HDR_WIDTH+:4*(`CREOLE_HC_MAX_ST_XP_CODE_LENGTH+8)];
	     coded_sym_ptr_c										 = coded_sym_ptr - `CREOLE_HC_HDR_WIDTH;
       end   
	    
       for(int i=0;i<4;i++)
           begin
              
	      if(st_bldr_curr_st_del==ST_BLDR_IDLE || sa_st_read_done)
		begin
	          coded_sym_ptr_c									 = 0;
		end
	      else if(st_bldr_curr_st_del==ST_BLDR_BUILD)
	      begin

                   if(symbol_pipe_val[i])
		   begin
		    
                            
			  
			    
                            
			    
			    st_lut_build_data_c[coded_sym_ptr_c+:`CREOLE_HC_MAX_ST_XP_CODE_LENGTH]	 =  byte_swap(symbol_pipe_enc_symbol[i],symbol_pipe_enc_symbol_length[i]);
                            
			    coded_sym_ptr_c								 = symbol_pipe_enc_symbol_length[i] + coded_sym_ptr_c;
                            
			    st_lut_build_data_c[coded_sym_ptr_c+:8]					 = symbol_pipe_extra[i];
                            
			    coded_sym_ptr_c								 = symbol_pipe_extra_length[i] + coded_sym_ptr_c;

		   end 
                
	      end 
	      
	   end 
	 
   end 

  
always_comb
  begin
    
     
    
    st_lut_wr_c												 = 0; 
    st_lut_wr_data_c											 = 0;
    st_lut_wr_addr_c											 = st_lut_wr_addr;

   
   
   
   if( (coded_sym_ptr_c >= `CREOLE_HC_HDR_WIDTH) ||
       (st_bldr_curr_st==ST_BLDR_IDLE && st_bldr_curr_st_del==ST_BLDR_BUILD) ||
       (st_bldr_curr_st_del==ST_BLDR_IDLE && coded_sym_ptr > `CREOLE_HC_HDR_WIDTH) ||
       (st_bldr_curr_st_del!=ST_BLDR_IDLE && sa_st_read_done))
      begin
	 st_lut_wr_c											 = ~sa_st_read_done;
	 
	 st_lut_wr_data_c										 = st_lut_build_data_c[`CREOLE_HC_HDR_WIDTH-1:0];
	 
      end

   st_lut_wr_done_c											 = 0; 
   
   if( (st_bldr_curr_st==ST_BLDR_IDLE && st_bldr_curr_st_del==ST_BLDR_BUILD && coded_sym_ptr_c <= `CREOLE_HC_HDR_WIDTH) ||
      
       (st_bldr_curr_st_del!=ST_BLDR_IDLE && sa_st_read_done) ||
      
       (st_bldr_curr_st_del==ST_BLDR_IDLE && coded_sym_ptr > `CREOLE_HC_HDR_WIDTH))
       st_lut_wr_done_c											 = 1;

   if(st_bldr_curr_st_del==ST_BLDR_IDLE && coded_sym_ptr==0)
      begin
	 st_lut_wr_addr_c										 = 0;
      end
   else if(st_lut_wr)
      begin
	 st_lut_wr_addr_c										 = st_lut_wr_addr + 1;
      end
   
end 
   

function logic [`CREOLE_HC_MAX_ST_XP_CODE_LENGTH-1:0] byte_swap;
  
      input [`CREOLE_HC_MAX_ST_XP_CODE_LENGTH-1:0] symbol_in;
      input [`LOG_VEC(`CREOLE_HC_MAX_ST_XP_CODE_LENGTH+1)] symbol_length;
      
   begin
      byte_swap = 0;
      for(int i=0;i<`CREOLE_HC_MAX_ST_XP_CODE_LENGTH;i++)
	begin
	   
	   if(i<symbol_length && symbol_length > 0)
	      byte_swap[symbol_length-1 - i] = symbol_in[i];
	end
      
   end
endfunction  

   
endmodule 








