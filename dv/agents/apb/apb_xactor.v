
/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

module apb_xactor #( parameter ADDR_WIDTH = 32, DATA_WIDTH = 32 ) (/*AUTOARG*/
   // Outputs
   psel, penable, paddr, pwdata, pwrite,
   // Inputs
   clk, reset_n, prdata, pready, pslverr
   );
   input                    clk;
   input 		    reset_n;
   
   output reg 		    psel;
   output reg 		    penable;
   output reg [ADDR_WIDTH-1:0] 	    paddr;
   output reg [DATA_WIDTH-1:0] 	    pwdata;
   output reg 		    pwrite;
   input [DATA_WIDTH-1:0] 	    prdata;
   input                    pready;
   input 		    pslverr;
   
   
   reg [7:0] 		    bus_timer;
   parameter 		    BUS_TIMER_EXPIRATION = 100;

   
   always @(posedge clk)
     begin
	if (!reset_n)
	  begin	        
	     bus_timer <= 0;	  
	     psel    <= 0;
	     penable <= 0;
	     paddr   <= 0;
	     pwdata  <= 0;
	     pwrite  <= 0;	     
	  end	
     end
   


   task write;
      input [63:0] addr;
      input [31:0] data;
      output reg   response;
      
      begin
	 psel      <= 1;
	 penable   <= 0;
	 pwrite    <= 1;
	 paddr     <= addr[31:0];
	 pwdata    <= data[31:0];

	 @(posedge clk);
	 penable   <= 1;
	 
	 while ((!pready) && (bus_timer < BUS_TIMER_EXPIRATION))
	   begin
	      bus_timer <= bus_timer + 1;
	      @(posedge clk);
	   end
	 
	 bus_timer <= 0;	  
	 psel      <= 0 ;
	 penable   <= 0 ;
	 pwrite    <= 0 ;
	 paddr     <= 0 ;
	 pwdata    <= 0 ;
	 response  <= (pslverr) | (bus_timer == BUS_TIMER_EXPIRATION) ;
	 
	 @(posedge clk);
      end      
   endtask // write
   
   task read;
      input [63:0]      addr;
      output reg [31:0] data;
      output reg 	response;
      begin
	 psel      <= 1;
	 penable   <= 0;
	 pwrite    <= 0;
	 paddr     <= addr[31:0];

	 @(posedge clk);
	 penable   <= 1;

	 while ((!pready) && (bus_timer < BUS_TIMER_EXPIRATION))
	   begin
	      bus_timer <= bus_timer + 1;
	      @(posedge clk);
	   end
	 
	 bus_timer <= 0;	 
	 psel      <= 0 ;
	 penable   <= 0 ;
	 pwrite    <= 0 ;
	 paddr     <= 0 ;
	 data      <= prdata;	 
	 response  <= (pslverr) | (bus_timer == BUS_TIMER_EXPIRATION) ;

	 @(posedge clk);
      end
   endtask
   


endmodule // apb_xactor
