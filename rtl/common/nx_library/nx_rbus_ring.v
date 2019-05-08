/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

























module nx_rbus_ring 
  #(parameter
    IO_ASYNC=0,           

    N_RBUS_ADDR_BITS=32,  
    N_LOCL_ADDR_BITS=16,  
    N_RBUS_DATA_BITS=32)  
   (
    input 			      clk,
    input 			      rst_n,

    input [N_RBUS_ADDR_BITS-1:0]      cfg_start_addr,
    input [N_RBUS_ADDR_BITS-1:0]      cfg_end_addr,
    
    
    input [N_RBUS_ADDR_BITS-1:0]      rbus_addr_i,
    input 			      rbus_wr_strb_i,
    input [N_RBUS_DATA_BITS-1:0]      rbus_wr_data_i,
    input 			      rbus_rd_strb_i,
		  
    output reg [N_RBUS_ADDR_BITS-1:0] rbus_addr_o,
    output reg 			      rbus_wr_strb_o,
    output reg [N_RBUS_DATA_BITS-1:0] rbus_wr_data_o,
    output reg 			      rbus_rd_strb_o,
		
    output reg [N_LOCL_ADDR_BITS-1:0] locl_addr_o,
    output reg 			      locl_wr_strb_o,
    output reg [N_RBUS_DATA_BITS-1:0] locl_wr_data_o,
    output reg 			      locl_rd_strb_o, 
		  
    input [N_RBUS_DATA_BITS-1:0]      rbus_rd_data_i,
    input 			      rbus_ack_i,
    input 			      rbus_err_ack_i, 
		  
    input [N_RBUS_DATA_BITS-1:0]      locl_rd_data_i,
    input 			      locl_ack_i,
    input 			      locl_err_ack_i, 
		  
    output reg [N_RBUS_DATA_BITS-1:0] rbus_rd_data_o,
    output reg 			      rbus_ack_o,
    output reg 			      rbus_err_ack_o);
   
   

   generate
      if (IO_ASYNC==0) begin : sync_io
	 reg [N_RBUS_ADDR_BITS-1:0]   rbus_addr_i_reg;
	 reg 			      rbus_wr_strb_i_reg;
	 reg [N_RBUS_DATA_BITS-1:0]   rbus_wr_data_i_reg;
	 reg 			      rbus_rd_strb_i_reg;
	 reg [N_RBUS_DATA_BITS-1:0]   rbus_rd_data_i_reg;
	 reg 			      rbus_ack_i_reg;
	 reg 			      rbus_err_ack_i_reg;
	 always_ff @(posedge clk or negedge rst_n) begin
	    if (!rst_n) begin
	       
	       
	       locl_addr_o <= 0;
	       locl_rd_strb_o <= 0;
	       locl_wr_data_o <= 0;
	       locl_wr_strb_o <= 0;
	       rbus_ack_i_reg <= 0;
	       rbus_ack_o <= 0;
	       rbus_addr_i_reg <= 0;
	       rbus_addr_o <= 0;
	       rbus_err_ack_i_reg <= 0;
	       rbus_err_ack_o <= 0;
	       rbus_rd_data_i_reg <= 0;
	       rbus_rd_data_o <= 0;
	       rbus_rd_strb_i_reg <= 0;
	       rbus_rd_strb_o <= 0;
	       rbus_wr_data_i_reg <= 0;
	       rbus_wr_data_o <= 0;
	       rbus_wr_strb_i_reg <= 0;
	       rbus_wr_strb_o <= 0;
	       
	    end
	    else begin
	       locl_wr_strb_o      <= 0;
	       locl_rd_strb_o      <= 0;
	       rbus_wr_strb_o      <= 0;
	       rbus_rd_strb_o      <= 0;
	       rbus_ack_o          <= 0;
	       rbus_err_ack_o      <= 0;
	       rbus_addr_i_reg     <= rbus_addr_i;
	       rbus_wr_strb_i_reg  <= rbus_wr_strb_i;
	       rbus_wr_data_i_reg  <= rbus_wr_data_i;
	       rbus_rd_strb_i_reg  <= rbus_rd_strb_i;
	       rbus_rd_data_i_reg  <= rbus_rd_data_i;
	       rbus_ack_i_reg      <= rbus_ack_i;
	       rbus_err_ack_i_reg  <= rbus_err_ack_i;
	       if (rbus_wr_strb_i_reg || rbus_rd_strb_i_reg) begin
		  if ((rbus_addr_i_reg >= cfg_start_addr) && (rbus_addr_i_reg <= cfg_end_addr)) begin
		     locl_addr_o    <= rbus_addr_i_reg[N_LOCL_ADDR_BITS-1:0];
		     locl_wr_strb_o <= rbus_wr_strb_i_reg;
		     locl_wr_data_o <= rbus_wr_data_i_reg;
		     locl_rd_strb_o <= rbus_rd_strb_i_reg;
		  end
		  else begin
		     rbus_addr_o     <= rbus_addr_i_reg;
		     rbus_wr_strb_o  <= rbus_wr_strb_i_reg;
		     rbus_wr_data_o  <= rbus_wr_data_i_reg;
		     rbus_rd_strb_o  <= rbus_rd_strb_i_reg;
		  end 
	       end
	       if (locl_ack_i || locl_err_ack_i) begin
		  rbus_rd_data_o <= locl_rd_data_i;
		  rbus_ack_o     <= locl_ack_i;
		  rbus_err_ack_o <= locl_err_ack_i;
	       end
	       else begin
		  rbus_rd_data_o <= rbus_rd_data_i_reg;
		  rbus_ack_o     <= rbus_ack_i_reg;
		  rbus_err_ack_o <= rbus_err_ack_i_reg;
	       end
	    end 
	 end 
      end 
      else begin: async_io
	 always_comb begin
	    locl_addr_o    = 0;
	    locl_rd_strb_o = 0;
	    locl_wr_data_o = 0;
	    locl_wr_strb_o = 0;
	    rbus_ack_o     = 0;
	    rbus_addr_o    = 0;
	    rbus_err_ack_o = 0;
	    rbus_rd_data_o = 0;
	    rbus_rd_strb_o = 0;
	    rbus_wr_data_o = 0;
	    rbus_wr_strb_o = 0;
	    if (rbus_wr_strb_i || rbus_rd_strb_i) begin
	       if ((rbus_addr_i >= cfg_start_addr) && (rbus_addr_i <= cfg_end_addr)) begin
		  locl_addr_o    = rbus_addr_i[N_LOCL_ADDR_BITS-1:0];
		  locl_wr_strb_o = rbus_wr_strb_i;
		  locl_wr_data_o = rbus_wr_data_i;
		  locl_rd_strb_o = rbus_rd_strb_i;
	       end
	       else begin
		  rbus_addr_o     = rbus_addr_i;
		  rbus_wr_strb_o  = rbus_wr_strb_i;
		  rbus_wr_data_o  = rbus_wr_data_i;
		  rbus_rd_strb_o  = rbus_rd_strb_i;
	       end 
	    end
	    if (locl_ack_i || locl_err_ack_i) begin
	       rbus_rd_data_o = locl_rd_data_i;
	       rbus_ack_o     = locl_ack_i;
	       rbus_err_ack_o = locl_err_ack_i;
	    end
	    else begin
	       rbus_rd_data_o = rbus_rd_data_i;
	       rbus_ack_o     = rbus_ack_i;
	       rbus_err_ack_o = rbus_err_ack_i;
	    end
	 end 
      end 
   endgenerate
   

	 
endmodule 









