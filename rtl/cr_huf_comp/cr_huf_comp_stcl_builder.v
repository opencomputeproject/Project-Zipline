/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_huf_comp.vh"

module cr_huf_comp_stcl_builder
   #(parameter
    MAX_NUM_SYM_USED =33,         
    CODELENGTH_WIDTH =4           
   )
  (
   
   st_lut_wr, st_lut_wr_data, st_lut_wr_addr, st_lut_wr_done,
   st_lut_stcl_size, st_lut_hclen,
   
   clk, rst_n, deflate_mode, start_build, ht_hw_sym_dpth,
   sa_st_read_done
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

 
 
 
 input                                        clk;
 input                                        rst_n; 
 
 
 

 input 				              deflate_mode;
   
   
 
 input 				              start_build;
 input [MAX_NUM_SYM_USED-1:0][CODELENGTH_WIDTH-1:0] ht_hw_sym_dpth;
                                                                   

 
 input                                        sa_st_read_done;
                                                             
                                                             
                                                             
                                                             

   
 
 
 

 
 output logic                               st_lut_wr;      
 output logic [`CREOLE_HC_HDR_WIDTH-1:0]    st_lut_wr_data; 
 output logic [`LOG_VEC(`CREOLE_HC_ST_MAX_BITS/`CREOLE_HC_HDR_WIDTH)] st_lut_wr_addr; 
 output logic                               st_lut_wr_done;
 output logic [`CREOLE_HC_STCL_MAX_BITS_WIDTH-1:0] st_lut_stcl_size;
 output logic [`CREOLE_HC_HCLEN_WIDTH-1:0]  st_lut_hclen;    

 
 

 logic [`LOG_VEC(MAX_NUM_SYM_USED+1)] codelength_rd_ptr,codelength_rd_ptr_c;
 logic [`LOG_VEC(`CREOLE_HC_HDR_WIDTH+CODELENGTH_WIDTH)] coded_sym_ptr,coded_sym_ptr_c;
 logic [`CREOLE_HC_HDR_WIDTH+CODELENGTH_WIDTH:0]  st_lut_build_data,st_lut_build_data_c;
 logic                               st_lut_wr_c;
 logic [`CREOLE_HC_HDR_WIDTH-1:0]    st_lut_wr_data_c;
 logic [`LOG_VEC(`CREOLE_HC_ST_MAX_BITS/`CREOLE_HC_HDR_WIDTH)] st_lut_wr_addr_c;
 logic                               st_lut_wr_done_c;
 logic [5:0] 			     max_table_size;
 logic [`CREOLE_HC_STCL_MAX_BITS_WIDTH-1:0] st_lut_stcl_size_c;
 logic [`CREOLE_HC_HCLEN_WIDTH-1:0]  st_lut_hclen_c;

 
 parameter logic [18:0][4:0] 	     deflate_seq = {5'd15,5'd1,
                                                    5'd14,5'd2,
                                                    5'd13,5'd3,
                                                    5'd12,5'd4,
                                                    5'd11,5'd5,
                                                    5'd10,5'd6,
                                                    5'd9,5'd7,
                                                    5'd8,5'd0,
                                                    5'd18,5'd17,
                                                    5'd16};



 typedef enum 		 {ST_BLDR_IDLE,
                          ST_BLDR_BUILD,
			  ST_BLDR_PACK
                          }
                         e_st_bldr_state;   
   


typedef struct packed { logic [CODELENGTH_WIDTH-1:0] value;
                        logic [`LOG_VEC(CODELENGTH_WIDTH+1)] length; 
                       } s_delta_code;
   
e_st_bldr_state st_bldr_nxt_st,st_bldr_curr_st;
s_delta_code [MAX_NUM_SYM_USED-1:0] delta_cl;
 
 
 
 

always_ff @(posedge clk or negedge rst_n)
begin
  if (~rst_n) 
    begin
    st_bldr_curr_st <= ST_BLDR_IDLE;
    
    
    coded_sym_ptr <= 0;
    codelength_rd_ptr <= 0;
    st_lut_build_data <= 0;
    st_lut_hclen <= 0;
    st_lut_stcl_size <= 0;
    st_lut_wr <= 0;
    st_lut_wr_addr <= 0;
    st_lut_wr_data <= 0;
    st_lut_wr_done <= 0;
    
    end
  else
    begin
       
       
       st_lut_build_data	<= st_lut_build_data_c;
       
       coded_sym_ptr		<= coded_sym_ptr_c;
       
       codelength_rd_ptr	<= codelength_rd_ptr_c;

       st_lut_wr		<= st_lut_wr_c; 
       st_lut_wr_data		<= st_lut_wr_data_c;
       st_lut_wr_addr		<= st_lut_wr_addr_c;
       st_lut_wr_done		<= st_lut_wr_done_c;
       st_lut_stcl_size		<= st_lut_stcl_size_c;
       st_lut_hclen		<= st_lut_hclen_c;

       st_bldr_curr_st		<= st_bldr_nxt_st;
       
    end
end
    
always_comb
  begin

   
   delta_cl							 = delta_code(ht_hw_sym_dpth);

   
   if(deflate_mode)
	max_table_size						 = 6'd19;
   else
	max_table_size						 = MAX_NUM_SYM_USED;

   
   codelength_rd_ptr_c						 = codelength_rd_ptr;
   coded_sym_ptr_c						 = coded_sym_ptr; 
   st_lut_build_data_c						 = st_lut_build_data;
   st_lut_stcl_size_c						 = st_lut_stcl_size;

   if(st_bldr_curr_st==ST_BLDR_IDLE)
     begin
	 coded_sym_ptr_c					 = 0;
	 codelength_rd_ptr_c					 = 0;
	 st_lut_stcl_size_c					 = 0;
     end
   else if(st_bldr_curr_st==ST_BLDR_PACK)
     begin
	st_lut_build_data_c = 0;
	                        
	st_lut_build_data_c[0+:CODELENGTH_WIDTH]	 = st_lut_build_data[`CREOLE_HC_HDR_WIDTH+:CODELENGTH_WIDTH];
	coded_sym_ptr_c						 = coded_sym_ptr - `CREOLE_HC_HDR_WIDTH;
     end
   else 
     begin
       
              

                     
		     if(deflate_mode) 
		         begin
			     if(codelength_rd_ptr < {1'b0,hclen(ht_hw_sym_dpth,deflate_seq)})
				begin
                                    
			            st_lut_build_data_c[coded_sym_ptr+:CODELENGTH_WIDTH] = 
					 ht_hw_sym_dpth[deflate_seq[codelength_rd_ptr]];
			            
			            coded_sym_ptr_c			 =  2'd3 + coded_sym_ptr;
			            
			            st_lut_stcl_size_c			 = st_lut_stcl_size + 2'd3; 
				end
			  end
		     else
		      
		         begin
			     
			     st_lut_build_data_c[coded_sym_ptr+:CODELENGTH_WIDTH] = 
					  delta_cl[codelength_rd_ptr].value;
			     
			     coded_sym_ptr_c			 = delta_cl[codelength_rd_ptr].length + coded_sym_ptr;
			     
			     st_lut_stcl_size_c			 = st_lut_stcl_size + delta_cl[codelength_rd_ptr].length;
			  end    

                     
		     if((codelength_rd_ptr + 1) < max_table_size)
			    codelength_rd_ptr_c			 = codelength_rd_ptr + 1;
		     else
			    codelength_rd_ptr_c			 = max_table_size;


     end 

     
    
    
    st_bldr_nxt_st						 = st_bldr_curr_st;
    case(st_bldr_curr_st)

      ST_BLDR_IDLE:  if(start_build)
		       st_bldr_nxt_st				 = ST_BLDR_BUILD;

      
      
      ST_BLDR_BUILD: if(coded_sym_ptr_c >= `CREOLE_HC_HDR_WIDTH)
		       st_bldr_nxt_st				 = ST_BLDR_PACK;
		     else if(codelength_rd_ptr_c >= max_table_size)
		       st_bldr_nxt_st				 = ST_BLDR_IDLE;

      
      
      ST_BLDR_PACK:  if(codelength_rd_ptr >= max_table_size)
		       st_bldr_nxt_st				 = ST_BLDR_IDLE;
		     else 
		       st_bldr_nxt_st				 = ST_BLDR_BUILD;

    endcase 

    
    st_lut_wr_c							 = 0; 
    st_lut_wr_data_c						 = 0;
    st_lut_wr_addr_c						 = st_lut_wr_addr;
    
    if(st_bldr_curr_st==ST_BLDR_IDLE)
      begin
	  st_lut_wr_addr_c					 = 0;
      end
    else if(st_lut_wr)
      begin
	 st_lut_wr_addr_c					 = st_lut_wr_addr + 1;
      end

    
    
    if( coded_sym_ptr_c >= `CREOLE_HC_HDR_WIDTH || codelength_rd_ptr_c >= max_table_size )
      begin
	 st_lut_wr_c						 = ~sa_st_read_done;
	 
	 st_lut_wr_data_c					 = st_lut_build_data_c[`CREOLE_HC_HDR_WIDTH-1:0];
	 
      end

    st_lut_wr_done_c						 = 0;
    
    if(st_bldr_curr_st!=ST_BLDR_IDLE && st_bldr_nxt_st==ST_BLDR_IDLE)
	st_lut_wr_done_c					 = ~sa_st_read_done;

    
    st_lut_hclen_c						 = hclen(ht_hw_sym_dpth,deflate_seq)-3'd4;
  
end


function s_delta_code [MAX_NUM_SYM_USED-1:0] delta_code;
      
      input [MAX_NUM_SYM_USED-1:0][CODELENGTH_WIDTH-1:0] codelength;
      logic [CODELENGTH_WIDTH-1:0] prev;
      logic [CODELENGTH_WIDTH-1:0] codelength_m1; 
      begin
	 
	 prev = 4;

	 for(int i=0;i<MAX_NUM_SYM_USED;i++)
	     begin

		
	        if(codelength[i]==prev)
		  begin
		   delta_code[i] = '{value:{{CODELENGTH_WIDTH-1{1'b0}},1'b0},length:3'd1};
		  end
		else if(codelength[i] > prev)
		  begin
		   codelength_m1    = codelength[i]-1;
		   delta_code[i] = '{value:{codelength_m1[CODELENGTH_WIDTH-2:0],1'b1},length:3'd4};
		  end
		else
		  begin
		   delta_code[i] = '{value:{codelength[i][CODELENGTH_WIDTH-2:0],1'b1},length:3'd4};
		  end

		prev = codelength[i]; 
		    
	     end
      end
   
endfunction 


function logic[4:0] hclen;
      
      input [MAX_NUM_SYM_USED-1:0][CODELENGTH_WIDTH-1:0] codelength;
      input [18:0][4:0] deflate_seq;

      begin
	 
         hclen = 5'd4;
      
	 for(int i=4;i<19;i++)
	     begin
                
		
		if(codelength[deflate_seq[i]] != 0)
		    hclen = i+1;
	     end
	 
      end
   
endfunction   
   
endmodule 








