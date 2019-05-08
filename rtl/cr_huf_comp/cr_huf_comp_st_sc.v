/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/









`include "cr_huf_comp.vh"

module cr_huf_comp_st_sc
  #(parameter
    MAX_SYMBOL_TABLE_DEPTH =584 
   )
  (
   
   sc_is_vld, sc_is_cnt, sc_is_symbol, sc_is_seq_id, sc_is_eob,
   sc_is_build_error,
   
   clk, rst_n, sym_buf_wr_ptr, st_build_error, st_seq_id, st_eob,
   sym_buf, hw_st_eob, is_sc_rd
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;
 
 
 
 
 input                                        clk;
 input                                        rst_n; 
 
 
 
 
 
 input [`LOG_VEC(MAX_SYMBOL_TABLE_DEPTH+1)] sym_buf_wr_ptr;    
 input                                      st_build_error;    
 input [`CREOLE_HC_SEQID_WIDTH-1:0]         st_seq_id;         
 input e_pipe_eob                           st_eob;            
 input s_st_sym_buf_intf [MAX_SYMBOL_TABLE_DEPTH-1:0] sym_buf; 
 input e_pipe_eob                           hw_st_eob;
   
   
 
 input 				            is_sc_rd;

 
 
 

 
 output logic [3:0]                               sc_is_vld;   
 output logic [3:0][2:0]                          sc_is_cnt;   
 output logic [3:0][`CREOLE_HC_ST_SYMB_WIDTH-1:0] sc_is_symbol;
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]        sc_is_seq_id;
 output e_pipe_eob                                sc_is_eob;   
                                                         
                                                         
                                                         
                                                         
 output logic                                    sc_is_build_error;
                                                              
                                                              

 
 
 logic [`LOG_VEC(MAX_SYMBOL_TABLE_DEPTH+1)] sym_buf_rd_ptr_c,sym_buf_rd_ptr;
 logic                                      start_rd_c,start_rd;
 logic [3:0]                                val;
 logic [3:0][`CREOLE_HC_ST_SYMB_WIDTH-1:0]  symbol;
 e_pipe_eob                                 eob;
 logic                                      build_error;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0]         seq_id;
 e_pipe_eob                                 sc_is_eob_r,sc_is_eob_r1;
 logic [3:0]                                sc_is_vld_r,sc_is_vld_r1,sc_is_vld_c,sc_is_vld_c1,sc_is_vld_c2;
 logic [3:0][2:0]                           sc_is_cnt_r,sc_is_cnt_r1,sc_is_cnt_c,sc_is_cnt_c1,sc_is_cnt_c2;
 logic [3:0][`CREOLE_HC_ST_SYMB_WIDTH-1:0]  sc_is_symbol_r,sc_is_symbol_r1;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0]         sc_is_seq_id_r,sc_is_seq_id_r1;
 logic                                      sc_is_build_error_r,sc_is_build_error_r1;
   
 
 
 

 
 always_comb
   begin

      sym_buf_rd_ptr_c				 = sym_buf_rd_ptr;
      start_rd_c				 = start_rd;
      val					 = 0;
      symbol					 = 0;
      eob					 = MIDDLE;
      build_error				 = 0;
      seq_id					 = 0;
      
      if(hw_st_eob!=MIDDLE)
	begin
	   sym_buf_rd_ptr_c			 = 0;
	   start_rd_c				 = 1;
	end
      
      else if(start_rd)
	 begin
	   
             for(int i=0;i<4;i++)
	       begin
		   
		   if(sym_buf_rd_ptr_c<=sym_buf_wr_ptr)
		     begin
			
			 val[i]			 = sym_buf[sym_buf_rd_ptr_c].val;
			 symbol[i]		 = sym_buf[sym_buf_rd_ptr_c].symbol;
			 
			 if(sym_buf_rd_ptr_c==sym_buf_wr_ptr)
			     begin
			         eob		 = st_eob;
                                 build_error	 = st_build_error;
                                 seq_id		 = st_seq_id;
                                 start_rd_c      = 0;
			     end
			
			 sym_buf_rd_ptr_c	 = sym_buf_rd_ptr_c + 1;
			
		     end 
	       end 
	 end 
   end 
     
always_ff @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    begin
     sc_is_eob <= MIDDLE;
     sc_is_eob_r1 <= MIDDLE;
     sc_is_eob_r <= MIDDLE;
     
     
     sc_is_build_error <= 0;
     sc_is_build_error_r <= 0;
     sc_is_build_error_r1 <= 0;
     sc_is_cnt <= 0;
     sc_is_cnt_r <= 0;
     sc_is_cnt_r1 <= 0;
     sc_is_seq_id <= 0;
     sc_is_seq_id_r <= 0;
     sc_is_seq_id_r1 <= 0;
     sc_is_symbol <= 0;
     sc_is_symbol_r <= 0;
     sc_is_symbol_r1 <= 0;
     sc_is_vld <= 0;
     sc_is_vld_r <= 0;
     sc_is_vld_r1 <= 0;
     start_rd <= 0;
     sym_buf_rd_ptr <= 0;
     
     
   end
  else
    begin
         sym_buf_rd_ptr		<= sym_buf_rd_ptr_c;
         start_rd		<= start_rd_c; 

         sc_is_vld_r		<= sc_is_vld_c;
         sc_is_cnt_r		<= sc_is_cnt_c;
         sc_is_symbol_r		<= symbol;
         sc_is_seq_id_r		<= seq_id;
         sc_is_eob_r		<= eob;
         sc_is_build_error_r	<= build_error;

         
         sc_is_vld_r1	        <= sc_is_vld_c1;
         sc_is_cnt_r1       	<= sc_is_cnt_c1;
         sc_is_symbol_r1	<= sc_is_symbol_r;
         sc_is_seq_id_r1	<= sc_is_seq_id_r;
         sc_is_eob_r1		<= sc_is_eob_r;
         sc_is_build_error_r1	<= sc_is_build_error_r;

         sc_is_vld	        <= sc_is_vld_c2;
         sc_is_cnt       	<= sc_is_cnt_c2;
         sc_is_symbol		<= sc_is_symbol_r1;
         sc_is_seq_id	        <= sc_is_seq_id_r1;
         sc_is_eob	        <= sc_is_eob_r1;
         sc_is_build_error      <= sc_is_build_error_r1;
    end 
   
end 


always_comb
  begin
         

         
         sc_is_vld_c		                = val;
         sc_is_cnt_c		                = {{2'b0,val[3]},{2'b0,val[2]},{2'b0,val[1]},{2'b0,val[0]}};
       
         for(int i=1;i<4;i++ )
	   begin
                 if(val[0])
		   begin
		      
		      if(val[i] && symbol[i]==symbol[0])
                         begin
                           sc_is_vld_c[i]	= 0;
                           sc_is_cnt_c[0]	= sc_is_cnt_c[0] + 1;
                         end
		      
		   end
                 
	   end
         
         
         sc_is_vld_c1	                        = sc_is_vld_r;
         sc_is_cnt_c1       	                = sc_is_cnt_r;
         for(int i=2;i<4;i++ )
	   begin
                 if(sc_is_vld_r[1])
		   begin
		      
		      if(sc_is_vld_r[i] && sc_is_symbol_r[i]==sc_is_symbol_r[1])
                         begin
                           sc_is_vld_c1[i]	= 0;
                           sc_is_cnt_c1[1]	= sc_is_cnt_c1[1] + 1;
                         end
		      
		   end
                 
	   end
         
         
         sc_is_vld_c2	                        = sc_is_vld_r1;
         sc_is_cnt_c2                           = sc_is_cnt_r1;
         for(int i=3;i<4;i++ )
	   begin
                 if(sc_is_vld_r1[2])
		   begin
		      
		      if(sc_is_vld_r1[i] && sc_is_symbol_r1[i]==sc_is_symbol_r1[2])
                         begin
                           sc_is_vld_c2[i]	= 0;
                           sc_is_cnt_c2[2]	= sc_is_cnt_c2[2] + 1;
                         end
		      
		   end
                 
	   end
     
  end
   
   
   
endmodule 








