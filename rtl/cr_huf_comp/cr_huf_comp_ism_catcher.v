/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










`include "cr_huf_comp.vh"

module cr_huf_comp_ism_catcher
   #(parameter
    DAT_WIDTH              =10,  
    MAX_NUM_SYM_USED       =576, 
    CODELENGTH_WIDTH       =5,   
    ISM_CODELENGTH_WIDTH   =8,   
    ISM_DATA_WIDTH         =64   
   )
  (
   
   ism_not_ready, rd_eob, rd_build_error, rd_data, rd_no_sym,
   rd_seq_id, rd_vld,
   
   clk, rst_n, sym_dpth_in, zero_symbols_in, build_error_in,
   seq_id_in, eob_in, sw_ism_on, ism_rdy
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

 
 
 
 input                                        clk;
 input                                        rst_n; 
 
 
 

 
 input [MAX_NUM_SYM_USED-1:0][CODELENGTH_WIDTH-1:0] sym_dpth_in; 
 input    				     zero_symbols_in;    
 input 				             build_error_in;     
 input [`CREOLE_HC_SEQID_WIDTH-1:0]          seq_id_in;          
 input e_pipe_eob                            eob_in;             
                                                                    
                                                                    
                                                                    
                                                                    
 
 input                                       sw_ism_on;          
 
 input                                       ism_rdy;            

 
 output logic 				     ism_not_ready;         
 
 output logic                                rd_eob;                
 output logic                                rd_build_error;        
 output logic [ISM_DATA_WIDTH-1:0]           rd_data;               
 output logic                                rd_no_sym;             
 output logic [7:0]                          rd_seq_id;             
 output logic                                rd_vld;                

 
 

 
 typedef enum 		 {IDLE,WR,RDY} e_ism_state;   

 e_ism_state ism_catch_cur_state,ism_catch_nxt_state;
 logic rd_no_sym_c,rd_build_error_c,rd_eob_c,rd_vld_c,ism_not_ready_c;
 logic [DAT_WIDTH-1:0] packing_pntr,packing_pntr_c;
 logic [7:0] rd_seq_id_c;
 logic [(ISM_DATA_WIDTH/ISM_CODELENGTH_WIDTH)-1:0][ISM_CODELENGTH_WIDTH-1:0] rd_data_c;
 logic zero_symbols_in_r,build_error_in_r,build_error,zero_symbols;
 
 
 
 
  
always_ff @(posedge clk or negedge rst_n)
begin
  if (~rst_n) 
  begin
  ism_catch_cur_state <= IDLE;    
  
  
  build_error_in_r <= 0;
  ism_not_ready <= 0;
  packing_pntr <= 0;
  rd_build_error <= 0;
  rd_data <= 0;
  rd_eob <= 0;
  rd_no_sym <= 0;
  rd_seq_id <= 0;
  rd_vld <= 0;
  zero_symbols_in_r <= 0;
  
  end
  else
    begin

       ism_catch_cur_state						<= ism_catch_nxt_state;
       
       for(int i=0;i<(ISM_DATA_WIDTH/ISM_CODELENGTH_WIDTH);i++)
           rd_data[i*ISM_CODELENGTH_WIDTH+:ISM_CODELENGTH_WIDTH]	<= rd_data_c[i];
       packing_pntr							<= packing_pntr_c;
       rd_eob								<= rd_eob_c;
       rd_seq_id							<= rd_seq_id_c;
       rd_no_sym							<= rd_no_sym_c;
       rd_build_error							<= rd_build_error_c;
       rd_vld								<= rd_vld_c;
       ism_not_ready							<= ism_not_ready_c;

       if(ism_catch_cur_state==RDY)
	 begin
	    if(zero_symbols_in)
	       zero_symbols_in_r                                        <= 1'b1;
	    if(build_error_in)
	       build_error_in_r                                         <= 1'b1;
	 end
       else if(ism_catch_cur_state==IDLE)
	 begin
	    zero_symbols_in_r                                           <= 0;
	    build_error_in_r                                            <= 0;
	 end
       
    end
end

always_comb
  begin

     zero_symbols                                = zero_symbols_in | zero_symbols_in_r;
     build_error                                 = build_error_in | build_error_in_r;

     ism_catch_nxt_state			 = ism_catch_cur_state;
     case(ism_catch_cur_state)
     IDLE:begin
	      
	      if(eob_in!=MIDDLE && eob_in!=PASS_THRU && sw_ism_on)
	         begin
	             ism_catch_nxt_state	 = RDY;
	         end
     end
     RDY:begin
              
	      if(ism_rdy)
	        begin
		     
	             if(zero_symbols || build_error)
	                ism_catch_nxt_state	 = IDLE;
		     
                     else
	                ism_catch_nxt_state	 = WR;
	         end
	
     end 
     WR:begin
              
	      if(ism_rdy)
		begin
		     
		     if((packing_pntr + (ISM_DATA_WIDTH/ISM_CODELENGTH_WIDTH)) >= MAX_NUM_SYM_USED)
		          ism_catch_nxt_state	 = IDLE;
		end
	      else
		ism_catch_nxt_state	 = RDY;
     end
     
     endcase 
     
     packing_pntr_c				 = packing_pntr;
     rd_data_c					 = 0;
     
     if(ism_catch_cur_state==IDLE)
       packing_pntr_c				 = 0;
     else if(ism_catch_cur_state==WR && ism_rdy)
       begin
           for(int i=0;i<ISM_DATA_WIDTH/ISM_CODELENGTH_WIDTH;i++)
	        if(packing_pntr+i < MAX_NUM_SYM_USED)
		    
	            rd_data_c[i]		 = {{ISM_CODELENGTH_WIDTH-CODELENGTH_WIDTH{1'b0}},sym_dpth_in[packing_pntr+i]};
	  
           packing_pntr_c			 = packing_pntr + ISM_DATA_WIDTH/ISM_CODELENGTH_WIDTH;
       end

      rd_eob_c					 = 0;
      rd_seq_id_c				 = 0;
      rd_no_sym_c				 = 0;
      rd_build_error_c				 = 0;
      
      if(ism_catch_cur_state != IDLE && ism_catch_nxt_state==IDLE)
	begin
	   rd_eob_c				 =  1;
	   rd_seq_id_c				 = {{8-`CREOLE_HC_SEQID_WIDTH{1'b0}},seq_id_in};
	   rd_no_sym_c				 = zero_symbols;
	   rd_build_error_c			 = build_error;
	end
     
      rd_vld_c					 = 0;
      
      if((ism_catch_cur_state==RDY && ism_catch_nxt_state==IDLE) || (ism_catch_cur_state==WR && ism_rdy))
        begin
	   rd_vld_c				 = 1;
	end

      ism_not_ready_c			         = 0;
      
      if(ism_catch_cur_state!=IDLE)
	begin
	   ism_not_ready_c			 = 1;
	end
       
end
 
 
endmodule 








