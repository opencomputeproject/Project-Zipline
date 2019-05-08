/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











`ifdef BUILD_FPGA
 
module nx_interface_monitor_pipe 
  (
   
   ob_in_mod, ob_out, im_vld,
   
   clk, rst_n, ob_out_pre, ob_in, im_rdy
   );
   
`include "cr_structs.sv"
   input                 clk;
   input                 rst_n;
   input  axi4s_dp_bus_t ob_out_pre;
   input  axi4s_dp_rdy_t ob_in;
   output axi4s_dp_rdy_t ob_in_mod;
   output axi4s_dp_bus_t ob_out;

   input                 im_rdy;
   output logic          im_vld;
   
  

   logic 		 on_last;
   logic 		 im_rdy_dly;
   

   always_comb begin
      im_vld           =  ob_out_pre.tvalid & ob_in.tready & im_rdy_dly;
      ob_in_mod.tready =  ob_in.tready & im_rdy & im_rdy_dly;
   end
   
   
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (~rst_n) 
        begin
           im_rdy_dly <= 1;
           
	   
	   ob_out.tdata <= 0;
	   ob_out.tid <= 0;
	   ob_out.tlast <= 0;
	   ob_out.tstrb <= 0;
	   ob_out.tuser <= 0;
	   ob_out.tvalid <= 0;
	   on_last <= 0;
	   
        end
      else begin
	 on_last <= im_rdy & ob_in.tready;
	 
         
         
         if((!ob_in.tready && !im_rdy) && on_last) begin
            im_rdy_dly <= 0;
         end
         else if (ob_in.tready && im_rdy) begin
            im_rdy_dly <= 1;
         end
	          
         if (ob_in.tready && im_rdy && im_rdy_dly) begin
	    ob_out.tlast        <= ob_out_pre.tlast;
	    ob_out.tid          <= ob_out_pre.tid;
	    ob_out.tstrb        <= ob_out_pre.tstrb;
	    ob_out.tuser        <= ob_out_pre.tuser;
	    ob_out.tdata        <= ob_out_pre.tdata;
	 end
	 
         if (ob_in.tready && im_rdy) begin
            ob_out.tvalid       <= ob_out_pre.tvalid;
         end
         else if (!im_rdy) begin
            ob_out.tvalid       <= 0;     
         end

	 
	 
	 
	   
      end
   end
   
endmodule 

`else 
module nx_interface_monitor_pipe 
  (
   
   ob_in_mod, ob_out, im_vld,
   
   clk, rst_n, ob_out_pre, ob_in, im_rdy
   );
   
`include "cr_structs.sv"
   input                 clk;
   input 		 rst_n;
   input  axi4s_dp_bus_t ob_out_pre;
   input  axi4s_dp_rdy_t ob_in;
   output axi4s_dp_rdy_t ob_in_mod;
   output axi4s_dp_bus_t ob_out;

   input                 im_rdy;
   output logic 	 im_vld;
   
  
  typedef enum logic [1:0] {
			    OFF_BOTH = 2'b00,
			    OFF_1    = 2'b01,
			    OFF_2    = 2'b10,
			    ON       = 2'b11} pipe_state_e;
   
   typedef struct packed {
      pipe_state_e state;
   } state_t;
   
   state_t state;
   state_t state_last;

   logic       im_rdy_dly;
   

   always_comb begin
      state            =  {im_rdy, ob_in.tready};
      im_vld           =  ob_out_pre.tvalid & ob_in.tready & im_rdy_dly;
      ob_in_mod.tready =  ob_in.tready & im_rdy & im_rdy_dly;
   end
   
   
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (~rst_n) 
	begin
	   im_rdy_dly <= 1;
	   state_last <= OFF_BOTH;
	   
	   
	   ob_out <= 0;
	   ob_out.tvalid <= 0;
	   
	end
      else begin
	 state_last <= state;
	 
	 
	 if (state == OFF_BOTH && state_last == ON) begin
	    im_rdy_dly <= 0;
	 end
	 if (state == ON) begin
	    im_rdy_dly <= 1;
	 end
	 ob_out           <= ob_out_pre;
	 if (!ob_in.tready || !im_rdy || !im_rdy_dly) begin
	    ob_out        <= ob_out;
	 end
	 if ((state==ON) &&  !im_rdy_dly) begin
	    ob_out        <= ob_out;
	    ob_out.tvalid <= 1; 
	 end
	 if (!im_rdy) begin
	    ob_out.tvalid <= 0;	    
	 end
      end
   end
endmodule 

`endif









