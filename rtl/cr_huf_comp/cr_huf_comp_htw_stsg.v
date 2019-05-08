/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/












`include "cr_huf_comp.vh"

module cr_huf_comp_htw_stsg
  #(parameter
    DAT_WIDTH        =10,      
    CODELENGTH_WIDTH =5,       
    MAX_NUM_SYM_USED =576,     
    MAX_ST_ENTRIES_USED =584   
   )
  (
   
   stsg_st_val, stsg_st_symbol, stsg_st_extra, stsg_st_extra_length,
   stsg_st_last_ptr, stsg_st_extra_size, stsg_st_seq_id, stsg_st_hlit,
   stsg_st_hdist, stsg_st_deflate, stsg_st_eob, stsg_st_build_error,
   stsg_hw_not_ready,
   
   clk, rst_n, st_stsg_not_ready, hw_stsg_val, hw_stsg_symbol,
   hw_stsg_seq_id, hw_stsg_eob, hw_stsg_build_error, hw_stsg_sym_hi_a,
   hw_stsg_sym_hi_b, hw_stsg_deflate_mode, hw_stsg_max_sym_table
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

  
 
 
 input                                        clk;
 input                                        rst_n; 
 
 
 
 
  
  input 				      st_stsg_not_ready;	

  
  input  [MAX_NUM_SYM_USED-1:0]               hw_stsg_val;	        
  input  [MAX_NUM_SYM_USED-1:0][CODELENGTH_WIDTH-1:0] hw_stsg_symbol;	
  input  [`CREOLE_HC_SEQID_WIDTH-1:0]         hw_stsg_seq_id;		
  input  e_pipe_eob                           hw_stsg_eob;		
									
									
									
									
  input                                       hw_stsg_build_error;	
									
									

  input  [DAT_WIDTH-1:0]                      hw_stsg_sym_hi_a;		
  input  [DAT_WIDTH-1:0]                      hw_stsg_sym_hi_b;		

  input                                       hw_stsg_deflate_mode;	
  input  [DAT_WIDTH:0]                        hw_stsg_max_sym_table;	


  
  
  
 
 
 output logic [MAX_ST_ENTRIES_USED-1:0]       stsg_st_val;		
 output logic [MAX_ST_ENTRIES_USED-1:0][5:0]  stsg_st_symbol;		
 output logic [MAX_ST_ENTRIES_USED-1:0][7:0]  stsg_st_extra;            
 output logic [MAX_ST_ENTRIES_USED-1:0][3:0]  stsg_st_extra_length;     
 output logic [DAT_WIDTH-1:0]                 stsg_st_last_ptr;         
 output	logic [`CREOLE_HC_SMALL_TABLE_XTR_BIT_SIZE:0] stsg_st_extra_size;
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]    stsg_st_seq_id;		
 output logic [`CREOLE_HC_HLIT_WIDTH-1:0]     stsg_st_hlit;             
 output logic [`CREOLE_HC_HDIST_WIDTH-1:0]    stsg_st_hdist;            
 output logic                                 stsg_st_deflate;          
 output e_pipe_eob                            stsg_st_eob;		
									
									
									
									
 output logic                                 stsg_st_build_error;	
									
									

									
 output logic                                 stsg_hw_not_ready;	
   
 
    
 
    logic [1:0]                               wr_val_c,wr_val;
    logic [1:0][5:0]                          symbol_c,wr_symbol;
    logic [1:0][7:0]                          extra_c,wr_extra;
    logic [1:0][3:0]                          extra_length_c,wr_extra_length;
    logic [DAT_WIDTH-1:0]                     output_wr_pntr_c,output_wr_pntr,wr_last_ptr;
    logic [`CREOLE_HC_SMALL_TABLE_XTR_BIT_SIZE:0] extra_size_c,wr_extra_size;
    logic [DAT_WIDTH-1:0]	   	      sym_hi_a;
    logic [DAT_WIDTH-1:0]  	              sym_hi_b;
    logic [DAT_WIDTH:0]                       cl_pntr,cl_pntr_c,cl_pntr_pipe,last_uniq_cl_ptr,last_uniq_cl_ptr_c;
    e_pipe_eob	                              eob_c,wr_eob;
    logic [`MAX_NUM_SYM_TABLE-1:0][CODELENGTH_WIDTH-1:0] cl_table_c;
    logic [`MAX_NUM_SYM_TABLE-1:0]            cl_table_val_c;
    logic [`CREOLE_HC_HLIT_WIDTH-1:0] 	      hlit_c;
    logic [`CREOLE_HC_HDIST_WIDTH-1:0]        hdist_c;
    logic                                     stall_eob;
    logic [CODELENGTH_WIDTH-1:0]              last_uniq_cl,last_uniq_cl_c;
    logic [7:0]    			      zr_cnt,zr_cnt_c;
    logic [2:0]    			      nz_cnt,nz_cnt_c;
    logic [DAT_WIDTH:0]                       boundary;
    logic [`HE_XP_FILL_CNT+1:0]               cl_table_pipe_val,cl_table_pipe_val_c;
    logic [`HE_XP_FILL_CNT+1:0][CODELENGTH_WIDTH-1:0]cl_table_pipe,cl_table_pipe_c;
    logic [1:0]                               rd_table_c,rd_table;
    logic 	                              cl_invalid_start,cl_invalid_start_c;
    logic                                     rd_loc_c;
    logic [MAX_ST_ENTRIES_USED-1:0]           stsg_st_val_c;
    logic [MAX_ST_ENTRIES_USED-1:0][5:0]      stsg_st_symbol_c;
    logic [MAX_ST_ENTRIES_USED-1:0][7:0]      stsg_st_extra_c; 
    logic [MAX_ST_ENTRIES_USED-1:0][3:0]      stsg_st_extra_length_c;
    logic [DAT_WIDTH-1:0]                     stsg_st_last_ptr_c; 
    logic                                     new_data_avail_c,new_data_avail;  
    e_pipe_eob                                hw_stsg_eob_r;
    logic                                     hw_stsg_build_error_r;
    logic [DAT_WIDTH-1:0]                     hw_stsg_sym_hi_a_r;
    logic [DAT_WIDTH-1:0]                     hw_stsg_sym_hi_b_r;
    logic [CODELENGTH_WIDTH-1:0]              nz_val_c,nz_val;
    logic [DAT_WIDTH:0]                       hw_stsg_max_sym_table_r,max_sym_table;
    logic                                     distance_start_c;

    logic                                     clk_gate_open,clk_gated;



 typedef enum 		 {
                          IDLE,
                          CHECK_INPUT,
			  CMPRS,
			  STALL
                          }
                         e_stsg_state;


   
typedef struct packed    {
             logic [7:0]                    value;
             logic [3:0]                    bits; 
                         } 
                        s_xtra_encode_lut;

e_stsg_state                                  stsg_curr_st,stsg_nxt_st;

parameter s_xtra_encode_lut [10:0] extra_encode_table = '{'{value:8'b00011111,bits:4'd8}, 
                                                          '{value:8'b11011,bits:4'd5},
                                                          '{value:8'b10111,bits:4'd5},
                                                          '{value:8'b10011,bits:4'd5},
                                                          '{value:8'b01111,bits:4'd5},
							  '{value:8'b01011,bits:4'd5},
                                                          '{value:8'b00111,bits:4'd5},
                                                          '{value:8'b00011,bits:4'd5},
                                                          '{value:8'b10,bits:4'd2},
                                                          '{value:8'b01,bits:4'd2},
                                                          '{value:8'b00,bits:4'd2}};   
   
 
 
 




  
always_ff @(posedge clk_gated or negedge rst_n)  
begin
  if (~rst_n) 
    begin
    hw_stsg_eob_r <= MIDDLE;
    
    
    cl_invalid_start <= 0;
    cl_pntr <= 0;
    cl_pntr_pipe <= 0;
    cl_table_pipe <= 0;
    cl_table_pipe_val <= 0;
    hw_stsg_build_error_r <= 0;
    hw_stsg_max_sym_table_r <= 0;
    hw_stsg_sym_hi_a_r <= 0;
    hw_stsg_sym_hi_b_r <= 0;
    new_data_avail <= 0;
    nz_val <= 0;
    rd_table <= 0;
    
  end
  else
    begin
                   cl_table_pipe_val		<= cl_table_pipe_val_c;
                   cl_table_pipe		<= cl_table_pipe_c ;
                   cl_pntr			<= cl_pntr_c;
                   cl_invalid_start		<= cl_invalid_start_c;
                   new_data_avail		<= new_data_avail_c; 
                   
                   
                   

                   if(rd_table_c[0]^rd_table_c[1] && new_data_avail)
                       cl_pntr_pipe		<= cl_pntr-1;
                   else if(&rd_table_c && new_data_avail)
 		       cl_pntr_pipe		<= cl_pntr;

                   hw_stsg_eob_r		<= hw_stsg_eob;
                   if(hw_stsg_eob_r==MIDDLE && hw_stsg_eob!=MIDDLE)
		     begin
			hw_stsg_build_error_r	<= hw_stsg_build_error;
                        hw_stsg_sym_hi_a_r	<= hw_stsg_sym_hi_a;
                        hw_stsg_sym_hi_b_r	<= hw_stsg_sym_hi_b;
		     end

                    if(hw_stsg_eob_r==MIDDLE && hw_stsg_eob!=MIDDLE)
			hw_stsg_max_sym_table_r <= hw_stsg_max_sym_table;
                    else if(cl_table_val_c[0]==0)
		        hw_stsg_max_sym_table_r <= {DAT_WIDTH+1{1'b1}}; 

                   if(new_data_avail_c==0 && new_data_avail)
                     rd_table			<= rd_table_c;

                   nz_val                       <= nz_val_c;
       
    end
end 

always_comb
  begin

     if(hw_stsg_eob_r==MIDDLE && hw_stsg_eob!=MIDDLE)
            max_sym_table = hw_stsg_max_sym_table;
     else
	    max_sym_table = hw_stsg_max_sym_table_r;

     
     
     for(int i=0;i<`MAX_NUM_SYM_TABLE;i++)
        begin
            cl_table_c[i]					 = i<MAX_NUM_SYM_USED ? hw_stsg_symbol[i]: 0;
	    cl_table_val_c[i]					 = i<MAX_NUM_SYM_USED ? hw_stsg_val[i]: 1;
	end
     
     cl_table_pipe_val_c					 = cl_table_pipe_val;
     cl_table_pipe_c						 = cl_table_pipe;
     cl_pntr_c							 = cl_pntr;
     cl_invalid_start_c						 = cl_invalid_start;
     new_data_avail_c                                            = 1;
     
     if(cl_table_val_c[0]==0)
       begin
	  cl_pntr_c						 = 0;
	  cl_table_pipe_val_c					 = 0;
          cl_table_pipe_c					 = 0;
	  cl_invalid_start_c					 = 0;
       end
     else
       begin

             
             if(cl_pntr+1<max_sym_table)
		begin
                     if(cl_table_val_c[cl_pntr+1])
		         begin
                             for(int i=0;i<2;i++)
                                begin
                                    if(new_data_avail==0)
			                begin
					    if(rd_table[i])
                                              begin
                                                   cl_table_pipe_val_c	 = {cl_table_pipe_val_c[`HE_XP_FILL_CNT:0],cl_table_val_c[cl_pntr_c]};
                                                   cl_table_pipe_c	 = {cl_table_pipe_c[`HE_XP_FILL_CNT:0],cl_table_c[cl_pntr_c]};
		                                   cl_pntr_c		 = cl_pntr_c + 1;
						end
           		                end
				  
			            
                                    else if(rd_table_c[i])
			              begin
                                            cl_table_pipe_val_c	 = {cl_table_pipe_val_c[`HE_XP_FILL_CNT:0],cl_table_val_c[cl_pntr_c]};
                                            cl_table_pipe_c	 = {cl_table_pipe_c[`HE_XP_FILL_CNT:0],cl_table_c[cl_pntr_c]};
		                            cl_pntr_c		 = cl_pntr_c + 1; 
           		                end
			  
		                 end 
			 end 
		     else
		       begin
                           
			   new_data_avail_c                      = 0; 
			  
		       end
		   
		end 
	  
	      
	      else if(cl_pntr<max_sym_table)
		begin

		     if(cl_table_val_c[cl_pntr])
		       begin
                            for(int i=0;i<2;i++)
                              begin
			           
                                   if(rd_table_c[i])
			           begin
					if(cl_pntr_c<max_sym_table)
					begin
					  
                                            cl_table_pipe_val_c	 = {cl_table_pipe_val_c[`HE_XP_FILL_CNT:0],cl_table_val_c[cl_pntr_c]};
                                            cl_table_pipe_c	 = {cl_table_pipe_c[`HE_XP_FILL_CNT:0],cl_table_c[cl_pntr_c]};
		                            cl_pntr_c		 = cl_pntr_c + 1;

					end
				        else
					  
					  begin
					    cl_table_pipe_val_c	 = {cl_table_pipe_val_c[`HE_XP_FILL_CNT:0],1'b0};
                                            cl_table_pipe_c	 = {cl_table_pipe_c[`HE_XP_FILL_CNT:0],{CODELENGTH_WIDTH{1'b0}}};
			                    cl_pntr_c		 = cl_pntr_c + 1;
					end
           		           end
				  
			       end
		       end 
		   
		end 
	  
	      
	      
	      else
		begin

                      for(int i=0;i<2;i++)
			begin

                             if(rd_table_c[i])
			     begin
			         cl_table_pipe_val_c		 = {cl_table_pipe_val_c[`HE_XP_FILL_CNT:0],1'b0};
                                 cl_table_pipe_c		 = {cl_table_pipe_c[`HE_XP_FILL_CNT:0],{CODELENGTH_WIDTH{1'b0}}};
			         cl_pntr_c		         = cl_pntr_c + 1;
		             end
			   
			end
		   
		end 
	    
	 end
  end
 
   

always_ff @(posedge clk_gated or negedge rst_n)
begin
  if (~rst_n) 
  begin
    wr_eob <= MIDDLE;
    stsg_curr_st <= IDLE;
    
    
    last_uniq_cl <= 0;
    last_uniq_cl_ptr <= 0;
    nz_cnt <= 0;
    output_wr_pntr <= 0;
    wr_extra <= 0;
    wr_extra_length <= 0;
    wr_extra_size <= 0;
    wr_last_ptr <= 0;
    wr_symbol <= 0;
    wr_val <= 0;
    zr_cnt <= 0;
    
  end
  else
  begin
	    
            stsg_curr_st	 <= stsg_nxt_st;
     
	    last_uniq_cl         <= last_uniq_cl_c;
	    zr_cnt               <= zr_cnt_c;
	    nz_cnt               <= nz_cnt_c;
	    last_uniq_cl_ptr     <= last_uniq_cl_ptr_c;

            wr_val               <= wr_val_c;
            wr_symbol            <= symbol_c;
            wr_extra             <= extra_c; 
            wr_extra_length      <= extra_length_c;
            wr_last_ptr          <= output_wr_pntr;
            wr_extra_size        <= extra_size_c;
            wr_eob               <= eob_c;
            output_wr_pntr       <= output_wr_pntr_c;

  end 
end 

   
always_comb
  begin
     
     sym_hi_a			                         = hw_stsg_sym_hi_a_r+1;
     sym_hi_b			                         = hw_stsg_sym_hi_b_r+1;

     
     stall_eob						 = st_stsg_not_ready | stsg_st_eob != MIDDLE;
     
     stsg_nxt_st					 = stsg_curr_st;
     case(stsg_curr_st)
	 
	 IDLE       : if(hw_stsg_eob == MIDDLE)
	                 stsg_nxt_st			 = CHECK_INPUT;
	 
	 CHECK_INPUT: if(hw_stsg_eob == PASS_THRU)
	                 begin
	                    if(stall_eob)
			       stsg_nxt_st		 = STALL;
			    else
	                       stsg_nxt_st		 = IDLE;
			 end
                      
	              else if(cl_table_val_c[0])
	                 stsg_nxt_st			 = CMPRS;

         
	 CMPRS      : if(cl_pntr_pipe >= max_sym_table && zr_cnt==0 && nz_cnt==0)
	                 begin
	                     if(stall_eob)
			       stsg_nxt_st		 = STALL;
			     else 
	                       stsg_nxt_st		 = IDLE;
			 end

	 STALL       : if(stall_eob==0)
	                 stsg_nxt_st			 = IDLE;
	 
     endcase 

  
     wr_val_c						 = 0;
     symbol_c						 = 0;
     extra_c						 = 0;
     extra_length_c					 = 0;
     extra_size_c					 = wr_extra_size;
     rd_table_c						 = 0;
     last_uniq_cl_c					 = last_uniq_cl;
     boundary						 = 0;
     last_uniq_cl_ptr_c					 = last_uniq_cl_ptr;
     nz_cnt_c						 = nz_cnt;
     zr_cnt_c						 = zr_cnt;
     output_wr_pntr_c                                    = output_wr_pntr;
     
     rd_loc_c                                            = 1;
     nz_val_c                                            = nz_val;
     distance_start_c                                    = 0;
     
     if(stsg_curr_st==CHECK_INPUT && stsg_nxt_st==IDLE)
       begin
	   wr_val_c					 = 2'b01;
	   output_wr_pntr_c                              = 0;
	   symbol_c					 = 0;
           extra_c					 = 0;
           extra_length_c				 = 0;
	   extra_size_c					 = 0;
       end
     else if(stsg_curr_st==IDLE && stsg_nxt_st==CHECK_INPUT)
       
       begin
	   wr_val_c					 = 0;
           symbol_c					 = 0;
           extra_c					 = 0;
           extra_length_c				 = 0;
	   extra_size_c					 = 0;
	   last_uniq_cl_c				 = 4'h8;
	   last_uniq_cl_ptr_c				 = 0;
	   zr_cnt_c					 = 0;
	   nz_cnt_c					 = 0;
	   output_wr_pntr_c                              = 0;
       end 
     else if(stsg_curr_st==CHECK_INPUT && stsg_nxt_st==CMPRS)
       
       begin
	  rd_table_c					 = 2'b11;
       end
     else if(~hw_stsg_deflate_mode && stsg_curr_st==CMPRS)
       
       begin
	  
	     for(int i=0;i<2;i++)
             begin

		 
		 boundary				 = ((cl_pntr_pipe + 1 - rd_loc_c) + `HE_XP_FILL_CNT)>>$clog2(`HE_XP_FILL_CNT)<<$clog2(`HE_XP_FILL_CNT);
		 
	         rd_table_c[rd_loc_c]		         = 1;

		 
		 if(cl_table_pipe_val[rd_loc_c] && cl_table_pipe[rd_loc_c]==0 && new_data_avail)
		     begin
                         
		         zr_cnt_c			 = zr_cnt_c + 1;
			
                         
		         if(last_uniq_cl_ptr_c + zr_cnt_c == {1'b0,boundary})
		            begin
		                wr_val_c[i]		 = 1;
			        symbol_c[i]		 = `HE_XP_FILL_ENCODE;
			        zr_cnt_c		 = 0;
			        last_uniq_cl_ptr_c	 = boundary;
                                output_wr_pntr_c         = output_wr_pntr_c + 1;

			    end 
                          
                          rd_loc_c			 = 0;
		     end 

	          
		  
		 else if((cl_table_pipe_val[rd_loc_c] || (cl_pntr_pipe + 1 - rd_loc_c)>={1'b0,max_sym_table}) && zr_cnt_c >= 5 && new_data_avail)
		     begin
			  
	                  wr_val_c[i]			 = 1;
	                  symbol_c[i]			 = `HE_XP_ZR_RPT_ENCODE;
			  
	                  extra_c[i]			 = extra_encode_table[zr_cnt_c -5].value;
			  extra_length_c[i]		 = extra_encode_table[zr_cnt_c -5].bits;
			  extra_size_c			 = extra_size_c + extra_encode_table[zr_cnt_c -5].bits;
			  zr_cnt_c			 = 0;
                          output_wr_pntr_c		 = output_wr_pntr_c + 1;
			  if((cl_pntr_pipe + 1 - rd_loc_c)<{1'b0,max_sym_table})
			    
		            rd_table_c[rd_loc_c]	 = 0;
			  else
			    
                            rd_loc_c			 = 0;
		     end 
		 
		 else if((cl_table_pipe_val[rd_loc_c] || (cl_pntr_pipe + 1 - rd_loc_c)>={1'b0,max_sym_table}) && zr_cnt_c!=0 && new_data_avail)
		     begin
			  wr_val_c[i]			 = 1;
			  symbol_c[i]			 = 0;
			  zr_cnt_c			 = zr_cnt_c - 1;
			  output_wr_pntr_c		 = output_wr_pntr_c + 1;
			  if((cl_pntr_pipe + 1 - rd_loc_c)<{1'b0,max_sym_table})
			    
			    rd_table_c[rd_loc_c]	 = 0;
			  else
			    
                            rd_loc_c			 = 0;
		     end 
                 
		 else if(cl_table_pipe_val[rd_loc_c] && cl_table_pipe[rd_loc_c] == last_uniq_cl_c && new_data_avail)
		     begin
			  wr_val_c[i]			 = 1;
			  symbol_c[i]			 = `HE_XP_PREV_ENCODE;
  			  output_wr_pntr_c		 = output_wr_pntr_c + 1;
			  
			  last_uniq_cl_c		 = cl_table_pipe[rd_loc_c];
			  last_uniq_cl_ptr_c		 = cl_pntr_pipe + 2 - rd_loc_c;
			  
			  rd_loc_c			 = 0;
		     end
		 
		 else if(cl_table_pipe_val[rd_loc_c] && (cl_pntr_pipe + 1 - rd_loc_c) >= `HE_XP_FILL_CNT && 
                         cl_table_pipe[rd_loc_c]!=0 && cl_table_pipe[rd_loc_c] == cl_table_pipe[`HE_XP_FILL_CNT+rd_loc_c] && new_data_avail)
		     begin
			  wr_val_c[i]			 = 1;
			  symbol_c[i]			 = `HE_XP_ROW_0_ENCODE;
			  output_wr_pntr_c		 = output_wr_pntr_c + 1;
			  
			  last_uniq_cl_c		 = cl_table_pipe[rd_loc_c];
			  last_uniq_cl_ptr_c		 = cl_pntr_pipe + 2 - rd_loc_c;
			  
			  rd_loc_c			 = 0;
		     end
		 
		 else if(cl_table_pipe_val[rd_loc_c] && (cl_pntr_pipe + 1 - rd_loc_c) >= `HE_XP_FILL_CNT &&  
                         cl_table_pipe[rd_loc_c]!=0 && cl_table_pipe[rd_loc_c] == cl_table_pipe[`HE_XP_FILL_CNT+rd_loc_c]+1 && new_data_avail)
		     begin
			  wr_val_c[i]			 = 1;
			  symbol_c[i]			 = `HE_XP_ROW_1_ENCODE;
                          output_wr_pntr_c		 = output_wr_pntr_c + 1;
			  
			  last_uniq_cl_c		 = cl_table_pipe[rd_loc_c];
			  last_uniq_cl_ptr_c		 = cl_pntr_pipe + 2 - rd_loc_c;
			  
			  rd_loc_c			 = 0;
		     end
		 else if(cl_table_pipe_val[rd_loc_c] && new_data_avail)
		     begin
			  wr_val_c[i]			 = 1;
			  symbol_c[i]			 = {1'b0,cl_table_pipe[rd_loc_c]};
                          output_wr_pntr_c		 = output_wr_pntr_c + 1;
			  
			  last_uniq_cl_c		 = cl_table_pipe[rd_loc_c];
			  last_uniq_cl_ptr_c		 = cl_pntr_pipe + 2 - rd_loc_c;
			  
			  rd_loc_c			 = 0;
		     end 
		else
		   begin
		          rd_loc_c			 = 0;
		   end
                          
	     end 

       end 
     


    else if(stsg_curr_st==CMPRS)
       begin
	 
	    
	    for(int i=0;i<2;i++)
            begin
                 
                 rd_table_c[rd_loc_c]		         = 1;
	         distance_start_c                        = 0;

	         if(cl_table_pipe_val[rd_loc_c] && (cl_pntr_pipe + 1 - rd_loc_c)=={1'b0,(hw_stsg_sym_hi_a+1'b1)})
		   begin

		      if(zr_cnt_c!=0 || nz_cnt_c!=0 || (cl_table_pipe[rd_loc_c]!=0 && cl_table_pipe[rd_loc_c]==cl_table_pipe[rd_loc_c+1]))

			begin
			   distance_start_c              = 1;
			   if(zr_cnt_c!=0 || nz_cnt_c!=0)
			      rd_table_c[rd_loc_c]	 = 0;
			end
		      
		   end
	       
                 
                 if(cl_table_pipe_val[rd_loc_c] && cl_table_pipe[rd_loc_c]==0 && nz_cnt_c==0 && new_data_avail && ~distance_start_c)
		     begin
                             
			  zr_cnt_c			 = zr_cnt_c + 1;
			     
                          
			  if(zr_cnt_c == `HE_DFLT_MX_ZR_RPT_THRESHOLD)
			       begin
			           wr_val_c[i]		 = 1;
			           symbol_c[i]		 = `HE_DFLT_HI_ZR_RPT_SYM;
			           
			           extra_c[i]		 = zr_cnt_c -`HE_DFLT_HI_ZR_RPT_THRESHOLD;
			           extra_length_c[i]	 = 4'd7;
			           extra_size_c		 = extra_size_c + 4'd7;
			           zr_cnt_c		 = 0;
                                   output_wr_pntr_c      = output_wr_pntr_c + 1;
			       end
			       
                               rd_loc_c			 = 0;
		     end 
  
                 
	         
                 else if((cl_table_pipe_val[rd_loc_c] || (cl_pntr_pipe + 1 - rd_loc_c)>={1'b0,max_sym_table} || distance_start_c) && zr_cnt_c >= `HE_DFLT_HI_ZR_RPT_THRESHOLD && new_data_avail)
		     begin
			  
	                  wr_val_c[i]			 = 1;
	                  symbol_c[i]			 = `HE_DFLT_HI_ZR_RPT_SYM;
			  
	                  extra_c[i]			 = zr_cnt_c -`HE_DFLT_HI_ZR_RPT_THRESHOLD;
			  extra_length_c[i]		 = 4'd7;
			  extra_size_c			 = extra_size_c + 4'd7;
			  zr_cnt_c			 = 0;
                          output_wr_pntr_c		 = output_wr_pntr_c + 1;
			  if((cl_pntr_pipe + 1 - rd_loc_c)<{1'b0,max_sym_table})
			    
			    rd_table_c[rd_loc_c]	 = 0;
			  else
			    
                            rd_loc_c			 = 0;
		     end
 
		 else if((cl_table_pipe_val[rd_loc_c] || (cl_pntr_pipe + 1 - rd_loc_c)>={1'b0,max_sym_table} || distance_start_c) && 
                         zr_cnt_c >= `HE_DFLT_LO_ZR_RPT_THRESHOLD && new_data_avail)
		     begin
			  
			  wr_val_c[i]			 = 1;
	                  symbol_c[i]			 = `HE_DFLT_LO_ZR_RPT_SYM;
			  extra_c[i]			 = zr_cnt_c - `HE_DFLT_LO_ZR_RPT_THRESHOLD;
			  extra_length_c[i]		 = 4'd3;
			  extra_size_c			 = extra_size_c + 4'd3;
			  zr_cnt_c			 = 0;
                          output_wr_pntr_c		 = output_wr_pntr_c + 1;
			  if((cl_pntr_pipe + 1 - rd_loc_c)<{1'b0,max_sym_table})
			    
			    rd_table_c[rd_loc_c]	 = 0;
			  else
			    
                            rd_loc_c			 = 0;
		     end
                 
		 else if((cl_table_pipe_val[rd_loc_c] || (cl_pntr_pipe + 1 - rd_loc_c)>={1'b0,max_sym_table} || distance_start_c) && zr_cnt_c!=0 && new_data_avail)
		     begin
		          wr_val_c[i]			 = 1;
		          symbol_c[i]			 = 0;
		          zr_cnt_c			 = zr_cnt_c - 1;
                          output_wr_pntr_c		 = output_wr_pntr_c + 1;
			  if((cl_pntr_pipe + 1 - rd_loc_c)<{1'b0,max_sym_table})
			    
			    rd_table_c[rd_loc_c]	 = 0;
			  else
			    
                            rd_loc_c			 = 0;
		     end 
                 
                 else if(cl_table_pipe_val[rd_loc_c] &&  
                        (cl_pntr_pipe + 1 - rd_loc_c)!=0 && cl_table_pipe[rd_loc_c]==cl_table_pipe[rd_loc_c+1] && new_data_avail && ~distance_start_c) 
                     begin
                          nz_val_c                       = cl_table_pipe[rd_loc_c];
                          
                          nz_cnt_c			 = nz_cnt_c + 1;

                          
                          if(nz_cnt_c == `HE_DFLT_HI_NZ_RPT_THRESHOLD)
	                       begin
	                           wr_val_c[i]		 = 1;
		                   symbol_c[i]		 = `HE_DFLT_NZ_RPT_SYM;
		                   extra_c[i]		 = nz_cnt_c -`HE_DFLT_LO_NZ_RPT_THRESHOLD;
		                   extra_length_c[i]	 = 4'd2;
		                   extra_size_c		 = extra_size_c + 4'd2;
		                   nz_cnt_c		 = 0;
                                   output_wr_pntr_c      = output_wr_pntr_c + 1;
		                end
                          
                          rd_loc_c			 = 0;
 
                    end 
	                                
                 else if((cl_table_pipe_val[rd_loc_c] || (cl_pntr_pipe + 1 - rd_loc_c)>={1'b0,max_sym_table} || distance_start_c) && 
                          nz_cnt_c >= `HE_DFLT_LO_NZ_RPT_THRESHOLD && new_data_avail)
		    begin
		          
	                  wr_val_c[i]			 = 1;
	                  symbol_c[i]			 = `HE_DFLT_NZ_RPT_SYM;
		          extra_c[i]			 = nz_cnt_c -`HE_DFLT_LO_NZ_RPT_THRESHOLD;
		          extra_length_c[i]		 = 4'd2;
			  
                          extra_size_c			 = extra_size_c + 4'd2;
			  nz_cnt_c			 = 0;
                          output_wr_pntr_c		 = output_wr_pntr_c + 1;
		          if((cl_pntr_pipe + 1 - rd_loc_c)<{1'b0,max_sym_table})
			    
			    rd_table_c[rd_loc_c]	 = 0;
			  else
			    
                            rd_loc_c			 = 0;
		    end
                 
		 else if((cl_table_pipe_val[rd_loc_c] || (cl_pntr_pipe + 1 - rd_loc_c)>={1'b0,max_sym_table} || distance_start_c) && nz_cnt_c!=0 && new_data_avail)
		    begin
			  wr_val_c[i]			 = 1;
			  symbol_c[i]			 = {1'b0,nz_val_c};
			  nz_cnt_c			 = nz_cnt_c - 1;
                          output_wr_pntr_c		 = output_wr_pntr_c + 1;
		          if((cl_pntr_pipe + 1 - rd_loc_c)<{1'b0,max_sym_table})
			    
			    rd_table_c[rd_loc_c]	 = 0;
			  else
			    
                            rd_loc_c			 = 0;

		    end 
                                         
                 else if(cl_table_pipe_val[rd_loc_c] && new_data_avail)
                    begin
		          
		          wr_val_c[i]			 = 1;
	                  symbol_c[i]			 = {1'b0,cl_table_pipe[rd_loc_c]};
                          output_wr_pntr_c		 = output_wr_pntr_c + 1;
		          
			  rd_loc_c			 = 0;
		    end
	         else
		   begin
		          rd_loc_c			 = 0;
		   end
 
	    end 
	       
       end 
     
     
     
     hlit_c						 = sym_hi_a >= `MIN_LITERAL_SYMBOL ? sym_hi_a - `MIN_LITERAL_SYMBOL 
                                                                                             : 0;
     
     hdist_c						 = sym_hi_b - `MIN_DISTANCE_SYMBOL;

     
     eob_c						 = (stsg_curr_st!=IDLE && stsg_nxt_st==IDLE) ? hw_stsg_eob : MIDDLE;
         
     
     stsg_hw_not_ready					 = stsg_curr_st != IDLE & stsg_curr_st != CHECK_INPUT;
     
  end 



always_ff @(posedge clk_gated or negedge rst_n)
begin
  if (~rst_n) 
  begin
    stsg_st_eob <= MIDDLE;
    
    
    stsg_st_build_error <= 0;
    stsg_st_deflate <= 0;
    stsg_st_extra <= 0;
    stsg_st_extra_length <= 0;
    stsg_st_extra_size <= 0;
    stsg_st_hdist <= 0;
    stsg_st_hlit <= 0;
    stsg_st_last_ptr <= 0;
    stsg_st_seq_id <= 0;
    stsg_st_symbol <= 0;
    stsg_st_val <= 0;
    
  end
  else
  begin
	   
            stsg_st_val                 <= stsg_st_val_c;
            stsg_st_symbol              <= stsg_st_symbol_c;
            stsg_st_extra               <= stsg_st_extra_c; 
            stsg_st_extra_length        <= stsg_st_extra_length_c;
            
            
	    if(|wr_val)
                   stsg_st_last_ptr     <= stsg_st_last_ptr_c-1;
                 
            stsg_st_extra_size          <= wr_extra_size;
            stsg_st_seq_id              <= hw_stsg_seq_id;	
            stsg_st_hlit                <= hlit_c;       
            stsg_st_hdist               <= hdist_c;      
            stsg_st_deflate             <= hw_stsg_deflate_mode;    
            stsg_st_eob                 <= wr_eob;	
            stsg_st_build_error         <= hw_stsg_build_error_r;

  end 
end 


always_comb
  begin

      stsg_st_val_c							 = stsg_st_val;
      stsg_st_symbol_c							 = stsg_st_symbol;
      stsg_st_extra_c							 = stsg_st_extra; 
      stsg_st_extra_length_c						 = stsg_st_extra_length;
      
      stsg_st_last_ptr_c						 = wr_last_ptr;
      for(int i=0;i<2;i++)
          begin
             if(wr_val[i])
		   begin
                       stsg_st_val_c[stsg_st_last_ptr_c]                 = 1'b1;
                       stsg_st_symbol_c[stsg_st_last_ptr_c]              = wr_symbol[i];
                       stsg_st_extra_c[stsg_st_last_ptr_c]               = wr_extra[i]; 
                       stsg_st_extra_length_c[stsg_st_last_ptr_c]        = wr_extra_length[i];
                       stsg_st_last_ptr_c				 = stsg_st_last_ptr_c+1;
		   end
          end  
  end 

assign clk_gate_open =  (stsg_curr_st==CHECK_INPUT && (hw_stsg_eob == PASS_THRU | cl_table_val_c[0])) |
                        (stsg_curr_st == IDLE && hw_stsg_eob == MIDDLE) |
			(stsg_curr_st == STALL && ~st_stsg_not_ready) |
                        (stsg_curr_st != CHECK_INPUT && stsg_curr_st != IDLE && stsg_curr_st != STALL) | 
                        (stsg_st_eob != MIDDLE) |
                        (wr_eob != MIDDLE);
		 
  
`ifdef CLK_GATE  
    cr_clk_gate dont_touch_clk_gate ( .i0(1'b0), .i1(clk_gate_open), .phi(clk), .o(clk_gated) );
`else
    assign clk_gated = clk;
`endif

endmodule 








