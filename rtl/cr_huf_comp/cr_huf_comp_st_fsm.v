/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











`include "cr_huf_comp.vh"

module cr_huf_comp_st_fsm
  (
   
   st_nxt_st, st_curr_st,
   
   clk, rst_n, tw_pass_thru_rdy, tw_code_rdy, st_st_lut_wr_done,
   st_stcl_lut_wr_done, sa_st_read_done
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

 
 
 
 input                                        clk;
 input                                        rst_n; 
 
 
 
 
 input 				             tw_pass_thru_rdy;
 input                                       tw_code_rdy;
 input 				             st_st_lut_wr_done;
 input                                       st_stcl_lut_wr_done;

 
 input                                       sa_st_read_done;
                                                             
                                                             
                                                             
                                                             

 
 
 
 

  output e_st_state                          st_nxt_st;
  output e_st_state                          st_curr_st; 
   
 
 
   
 
 
 

always_ff @(posedge clk or negedge rst_n)
begin
  if (~rst_n) 
    begin
    st_curr_st <= ST_IDLE;
    
    end
  else
    begin
   
       st_curr_st <= st_nxt_st;
       
    end
end
    
always_comb
begin

     st_nxt_st				 = st_curr_st;
     case(st_curr_st)
       
       
       
       
       ST_IDLE:
	       if(tw_pass_thru_rdy)
		  st_nxt_st		 = RDY_TO_SA;
	       else if(tw_code_rdy)
		  st_nxt_st		 = START_STCL;

       
       
       RDY_TO_SA:
	       if(sa_st_read_done)
		  st_nxt_st		 = ST_IDLE;
	       else if(st_st_lut_wr_done)
		  st_nxt_st		 = TBL_RDY_TO_SA;

       
       TBL_RDY_TO_SA:
		    if(sa_st_read_done)
			st_nxt_st	 = ST_IDLE;

       
       START_STCL:
	       if(st_stcl_lut_wr_done)
		  st_nxt_st		 = RDY_TO_SA;

     endcase 
   
end

   
endmodule 








