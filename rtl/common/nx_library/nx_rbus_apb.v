/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

























module nx_rbus_apb 
  #(parameter 
    N_RBUS_ADDR_BITS=32,  
    N_RBUS_DATA_BITS=32)  
   (
   
   rbus_addr_o, rbus_wr_strb_o, rbus_wr_data_o, rbus_rd_strb_o,
   apb_prdata, apb_pready, apb_pslverr,
   
   clk, rst_n, rbus_rd_data_i, rbus_ack_i, rbus_err_ack_i,
   rbus_wr_strb_i, rbus_rd_strb_i, apb_paddr, apb_psel, apb_penable,
   apb_pwrite, apb_pwdata
   );


   input 			       clk;
   input 			       rst_n;
   
   
   output logic [N_RBUS_ADDR_BITS-1:0] rbus_addr_o;
   output logic 		       rbus_wr_strb_o;
   output logic [N_RBUS_DATA_BITS-1:0] rbus_wr_data_o;
   output logic 		       rbus_rd_strb_o;
   
   input [N_RBUS_DATA_BITS-1:0]        rbus_rd_data_i;
   input 			       rbus_ack_i;
   input 			       rbus_err_ack_i;
   input 			       rbus_wr_strb_i;
   input 			       rbus_rd_strb_i;
   
   
   input [N_RBUS_ADDR_BITS-1:0]        apb_paddr;
   input 			       apb_psel;
   input 			       apb_penable;
   input 			       apb_pwrite;
   input [N_RBUS_DATA_BITS-1:0]        apb_pwdata;
   output logic [N_RBUS_DATA_BITS-1:0] apb_prdata;
   output logic 		       apb_pready;
   output logic 		       apb_pslverr;
   

   
   logic [N_RBUS_ADDR_BITS-1:0] apb_paddr_reg;
   logic 			apb_penable_reg;
   logic 			apb_psel_reg;
   logic [N_RBUS_DATA_BITS-1:0] apb_pwdata_reg;
   logic 			apb_pwrite_reg;
   logic 			apb_active;
   logic 			apb_active_reg;
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
	 
	 
	 apb_active <= 0;
	 apb_active_reg <= 0;
	 apb_paddr_reg <= 0;
	 apb_penable_reg <= 0;
	 apb_prdata <= 0;
	 apb_pready <= 0;
	 apb_psel_reg <= 0;
	 apb_pslverr <= 0;
	 apb_pwdata_reg <= 0;
	 apb_pwrite_reg <= 0;
	 rbus_addr_o <= 0;
	 rbus_rd_strb_o <= 0;
	 rbus_wr_data_o <= 0;
	 rbus_wr_strb_o <= 0;
	 
      end
      else begin
	 rbus_wr_strb_o    <= 0;
	 rbus_rd_strb_o    <= 0;
	 apb_paddr_reg     <= apb_paddr;
	 apb_psel_reg      <= apb_psel;
	 apb_penable_reg   <= apb_penable;
	 apb_pwrite_reg    <= apb_pwrite;
	 apb_pwdata_reg    <= apb_pwdata;
	 apb_pready        <= 1'd0;
	 apb_pslverr       <= 1'd0;
	 apb_active_reg    <= apb_active;
	 if (apb_psel_reg && apb_penable_reg && !apb_active && !apb_active_reg && !apb_pready) begin
	    apb_active     <=  1'd1;
	    rbus_addr_o    <=  apb_paddr_reg;
	    rbus_wr_data_o <=  apb_pwdata_reg;		  
	    rbus_wr_strb_o <=  apb_pwrite_reg;
	    rbus_rd_strb_o <= ~apb_pwrite_reg;
	 end
	 if (rbus_ack_i || rbus_err_ack_i || rbus_wr_strb_i || rbus_rd_strb_i) begin
	    apb_pready     <=  1'd1;
	    apb_pslverr    <= rbus_err_ack_i || rbus_wr_strb_i || rbus_rd_strb_i;
	    apb_prdata     <= rbus_rd_data_i;
	 end
	 if (apb_pready) begin
	    apb_active     <=  1'd0;
	 end
      end 
   end 


endmodule 










