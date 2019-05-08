/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/















`include "messages.vh"
`include "ccx_std.vh"
module nx_event_counter_array
  #(parameter 
    BASE_ADDRESS=0,       
    ALIGNMENT=2,          
    N_ADDR_BITS=16,       
    N_COUNTERS=1,         
    N_COUNT_BY_BITS=1,    
    N_COUNTER_BITS=32)    
   (input logic                             clk,
    input logic 			    rst_n,
    input logic [`BIT_VEC(N_ADDR_BITS)]     reg_addr,
    input logic 			    counter_config,
    input logic 			    rd_stb,
    input logic 			    wr_stb,
    input logic [`BIT_VEC(N_COUNTER_BITS)]  reg_data,
    input logic 			    count_stb,
    input logic [`BIT_VEC(N_COUNT_BY_BITS)] count_by,
    input logic [`LOG_VEC(N_COUNTERS)] 	    count_id,
    output logic [`BIT_VEC(N_COUNTER_BITS)] counter_a[N_COUNTERS]);
   
   logic [`BIT_VEC(N_COUNTER_BITS)]  counter_a_int[N_COUNTERS];
   
   logic                             count_stb_reg;
   logic [`BIT_VEC(N_COUNT_BY_BITS)] count_by_reg;
   logic [`LOG_VEC(N_COUNTERS)]      count_id_reg;
      
   logic                             count_stb_int;
   logic [`BIT_VEC(N_COUNT_BY_BITS)] count_by_int;
   logic [`LOG_VEC(N_COUNTERS)]      count_id_int;

   assign                            count_stb_int = count_stb;
   assign                            count_by_int  = count_by;
   assign                            count_id_int  = count_id;
   
   wire [`LOG_VEC(N_COUNTERS)] rw_count_id = ((reg_addr - BASE_ADDRESS) >> 
                                              ALIGNMENT); 

   wire                        selected = ((reg_addr >= BASE_ADDRESS) && 
                                           (reg_addr <  BASE_ADDRESS + 
                                            (N_COUNTERS << ALIGNMENT)));
   
   wire 		       global_rd_stb = rd_stb && (reg_addr == (BASE_ADDRESS + (N_COUNTERS+1 << ALIGNMENT)));
   
   wire                        rd_stb_valid = counter_config == 1'd0 ? (rd_stb && selected) : global_rd_stb; 
   wire                        wr_stb_valid = (wr_stb && selected); 

`ifndef SYNTHESIS
   initial begin : parameter_check

      assert(ALIGNMENT>=0 && ALIGNMENT<=4) else
        `ERROR("Expect byte, word, longword, quadword or octaword alignment");

      assert(((BASE_ADDRESS >> ALIGNMENT) << ALIGNMENT) == BASE_ADDRESS) else
        `ERROR("Base address is not %dB aligned", (1<<ALIGNMENT));

      assert(N_COUNTER_BITS <= (8 << ALIGNMENT)) else
        `ERROR("Number of counter bits (%d) too large for alignment (%d)",
               N_COUNTER_BITS, (8 << ALIGNMENT));

      assert(N_COUNTERS > 0) else
        `ERROR("Number of counters must be greater than zero");

      assert(N_ADDR_BITS > (ALIGNMENT + $clog2(N_COUNTERS))) else
        `ERROR("Not enough address bits to address all counters");
      
   end : parameter_check
`endif 

   localparam ADDER_MSB = `MAX(N_COUNTER_BITS, N_COUNT_BY_BITS);
   logic [`BIT_VEC(ADDER_MSB+1)] counter_v;
   
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         count_stb_reg <= 0;
         count_by_reg  <= 0;
         count_id_reg  <= 0;
      end
      else begin
         count_stb_reg <= count_stb_int;
         count_by_reg  <= count_by_int;
         count_id_reg  <= count_id_int;
      end
   end 

   
   always @(posedge clk or negedge rst_n) begin : counters
      if (!rst_n) begin : rst
         integer ii;

         for (ii=0; ii<N_COUNTERS; ii++)
           counter_a_int[ii] <= 0;
         
         
      end : rst
      else if (count_stb_int || rd_stb_valid || wr_stb_valid) begin

         if (count_stb_int) 
           if (!counter_v[ADDER_MSB]) 
             counter_a_int[count_id_int] <= counter_v[`BIT_VEC(N_COUNTER_BITS)];
           else 
             counter_a_int[count_id_int] <= '1; 
	   
         if (rd_stb_valid) begin 
           if (counter_config == 1'd0) begin 
               if (count_stb_int && (rw_count_id == count_id_int)) 
		 counter_a_int[rw_count_id] <= count_by_int + (count_stb_reg ? count_by_reg : 0); 
               else if (count_stb_reg && (rw_count_id == count_id_reg)) 
		 counter_a_int[rw_count_id] <= count_by_reg; 
               else
		 counter_a_int[rw_count_id] <= 0;
	    end
	    else begin 
	       for (int ii=0; ii<N_COUNTERS; ii++) begin
		  if (count_stb_int && (ii == count_id_int)) 
		    counter_a_int[ii] <= count_by_int + (count_stb_reg ? count_by_reg : 0); 
		  else if (count_stb_reg && (ii == count_id_reg)) 
		    counter_a_int[ii] <= count_by_reg; 
		  else
		    counter_a_int[ii] <= 0;
	       end
	    end
	 end
         else if (wr_stb_valid) begin 
           if (count_stb_int && (rw_count_id == count_id_int)) 
             counter_a_int[rw_count_id] <= N_COUNTER_BITS'(counter_v - reg_data);
           else
             counter_a_int[rw_count_id] <= N_COUNTER_BITS'(counter_a_int[rw_count_id] - 
						       reg_data);
         end
	 
      end 
   end : counters
   

   assign counter_v  = counter_a_int[count_id_int] + count_by_int;
   
            
   always @(posedge clk or negedge rst_n) begin : counters_out
      if (!rst_n) begin : rst
         for (int ii=0; ii<N_COUNTERS; ii++) begin
            counter_a[ii] <= 0;
	 end
	  
      end
      else begin
	 if (counter_config == 1'd0) begin 
	    for (int ii=0; ii<N_COUNTERS; ii++) begin
	       counter_a[ii] <= counter_a_int[ii];
	    end
	 end
	 else begin
	    if (rd_stb_valid) begin
	       for (int ii=0; ii<N_COUNTERS; ii++) begin
		  counter_a[ii] <= counter_a_int[ii];
	       end
	    end
	 end 
      end
   end : counters_out



   

`ifndef SYNTHESIS
   logic stb_tog     = 0;
   logic stb_tog_dly = 0;
   logic [`BIT_VEC(N_COUNT_BY_BITS)] count_by_fcn  = 0;
   logic [`LOG_VEC(N_COUNTERS)]      count_id_fcn  = 0;
   
   function [N_COUNTER_BITS-1:0] increment (integer ndx, integer by=1);
      `INFO("(%d, %d)", ndx, by);
      
      count_by_fcn  <= by;
      count_id_fcn  <= ndx;
      stb_tog       <= ~stb_tog;
      return 1;
   endfunction 
   
   always @(posedge clk) begin
      stb_tog_dly    <= stb_tog;
   end

   always @(*)
     if (stb_tog_dly ^ stb_tog) begin
        force count_stb_int = 1;
        force count_by_int  = count_by_fcn;
        force count_id_int  = count_id_fcn;
     end
     else begin
        release count_stb_int;
        release count_by_int;
        release count_id_int;
     end
   
   
  `ifdef END_OF_TEST_COUNTER_CHECKS_ENABLED
 
   final begin : end_of_sim
      integer ii;

      
      
      for (ii=0; ii<N_COUNTERS; ii++)
        if (counter_a_int[ii] != 0) begin : counter_not_zero
	   string this_module = $sformatf("%m");

           `ERROR("Please read and validate counter %m[%d]=%d at address 0x%x",
                  ii, counter_a_int[ii], BASE_ADDRESS+(ii<<ALIGNMENT));
	   end
        end : counter_not_zero

    end : end_of_sim

  `endif 


`endif 
   
endmodule : nx_event_counter_array






