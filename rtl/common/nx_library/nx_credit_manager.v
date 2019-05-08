/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


























`include "messages.vh"



module nx_credit_manager
  #(parameter
    N_MAX_CREDITS=16,          
    N_USED_LAG_CYCLES=0,       
    N_MAX_CREDITS_PER_CYCLE=1, 
    N_OUTSTANDING_CREDITS=0)    
                                  	
   (
   
   credit_available, hw_status,
   
   clk, rst_n, sw_init, credit_return, credit_used, sw_config
   );

   typedef struct packed {
      logic 	  dis_used;   
      logic 	  dis_return; 
      logic [`LOG_VEC(N_MAX_CREDITS+1)] credit_limit;
   } sw_config_t;

   typedef struct packed {
      logic 	  used_err;   
      logic 	  return_err; 
      logic [`LOG_VEC(N_MAX_CREDITS+1)] credit_issued;
   } hw_status_t;

   input                                              clk;
   input                                              rst_n;
   input 					      sw_init;
   

   input [`LOG_VEC(N_MAX_CREDITS_PER_CYCLE+1)]        credit_return;

   output logic [`LOG_VEC(N_MAX_CREDITS_PER_CYCLE+1)] credit_available;
   input [`LOG_VEC(N_MAX_CREDITS_PER_CYCLE+1)]        credit_used;
   
   input sw_config_t                                  sw_config;
   output hw_status_t                                 hw_status;

   
   
   
   localparam RESERVED_CREDIT = N_USED_LAG_CYCLES*N_MAX_CREDITS_PER_CYCLE; 

   logic [`LOG_VEC(N_MAX_CREDITS+1)]         credit_issued_r;
   logic 				     used_err_v;
   logic 				     return_err_v;

   logic [`LOG_VEC(N_MAX_CREDITS+1)]         credit_issued_v;
   logic [`LOG_VEC(N_MAX_CREDITS+1)]         remaining_credit_v;
   
`ifndef SYNTHESIS
   integer 				     outstanding;
   logic 				     credit_decrease;
   logic [`LOG_VEC(N_MAX_CREDITS+1)] 	     credit_limit;
   
   assign credit_decrease = sw_config.credit_limit < credit_limit;   
   always @(posedge clk or negedge rst_n)
     if (!rst_n) begin
	outstanding <= 0;
	credit_limit <= N_MAX_CREDITS;
     end
     else begin
	if (sw_init)
	  begin
	     outstanding <= 0;
	     credit_limit <= N_MAX_CREDITS;
	  end
	else begin
	   
	   outstanding <= outstanding + credit_used - credit_return;
	   credit_limit <= sw_config.credit_limit;
	end
     end
   
   
   
   
   credit_return_check : assert property
   (@(posedge clk) (credit_return |-> (credit_return <= outstanding)))
     else `ERROR("Whoa getting credits that were not issued.");

   
   
   credit_danger_check : assert property
   (@(posedge clk) (sw_config.credit_limit <= N_MAX_CREDITS))
     else `WARN("Credit limit is greater than max credits.");

   final
     
     
     credit_outstanding_check :
       assert #0 (outstanding == N_OUTSTANDING_CREDITS)
	 else `ERROR("Simulation ended with %d outstanding credits",
		     outstanding);
`endif 
 
   always_comb begin : cm
      
      
      return_err_v = 0;
      if (credit_issued_r >= ($bits(credit_issued_r))'(credit_return))
	credit_issued_v
          = ($bits(credit_issued_r))'(credit_issued_r - credit_return);
      else begin
	 return_err_v = 1;
	 credit_issued_v = 0;
      end
      
      
      
      
      
      
      if (32'(sw_config.credit_limit) > 32'(credit_issued_v+RESERVED_CREDIT))
	remaining_credit_v
          = ($bits(remaining_credit_v))'(sw_config.credit_limit - credit_issued_v);
      else
	remaining_credit_v = 0;
      
      used_err_v = (32'(credit_issued_v+credit_used) > 
		    32'(sw_config.credit_limit));
      
      
      
`ifndef SYNTHESIS
      if (rst_n) begin
	 credit_used_check : assert #0
	   (credit_decrease || !used_err_v)
	   else `ERROR("Attempt to use more credits than allowed");
      end
`endif
      credit_issued_v   
	= `MIN(($bits(credit_issued_v)+1)'(credit_issued_v+credit_used),
	       ($bits(credit_issued_v)+1)'(sw_config.credit_limit));
      
      credit_available = 0;
      if (remaining_credit_v != 0)
	credit_available
          = ($bits(credit_available))'(`MIN(N_MAX_CREDITS_PER_CYCLE, 
                                            remaining_credit_v));
   end : cm

   always @(posedge clk or negedge rst_n) 
      if (!rst_n) begin
         credit_issued_r <= 0;
	 hw_status <= 0;
      end
      else begin
	 if (sw_init) begin
	    credit_issued_r <= 0;
	    hw_status <= 0;
	 end
	 else begin
            credit_issued_r <= credit_issued_v;
	    
	    hw_status.used_err
	      <= !sw_config.dis_used && (hw_status.used_err || used_err_v);
	    hw_status.return_err
	      <= !sw_config.dis_return && (hw_status.return_err || return_err_v);
	    hw_status.credit_issued <= credit_issued_v;
	 end 
      end    
   

endmodule 






