/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "messages.vh"
module nx_stat_counter_indirect_access_cntrl
  import nx_stat_counter::*;
   #(parameter MEM_TYPE=0,            
     parameter [15:0] CAPABILITIES=0, 
     parameter CMND_ADDRESS=0,       
     parameter STAT_ADDRESS=0,       
     parameter ALIGNMENT=2,          
     parameter N_TIMER_BITS=6,       
     parameter N_REG_ADDR_BITS=16,   
	 
     parameter N_ENTRIES=1,          
     parameter N_INIT_INC_BITS=0,    
	 
     parameter integer  N_COUNTERS_PER_ENTRY = 2,
     parameter integer COUNTER_LSB_OFFSET[N_COUNTERS_PER_ENTRY:0] = '{70, 32, 0},
     parameter N_OUTSTANDING_RMW = 4,
     
     parameter [`BIT_VEC(N_COUNTERS_PER_ENTRY*64)] RESET_DATA=0)
   (input logic                                           clk,
    input logic 						    rst_n,
    
   
    input logic 						    wr_stb,
    input logic [`BIT_VEC(N_REG_ADDR_BITS)] 			    reg_addr,

    input logic [3:0] 						    cmnd_op,
    input logic [`LOG_VEC(N_ENTRIES)] 				    cmnd_addr,

    output logic [2:0] 						    stat_code,
    output logic [`BIT_VEC(5)] 					    stat_datawords,
    output logic [`LOG_VEC(N_ENTRIES)] 				    stat_addr,

    output logic [15:0] 					    capability_lst,
    output logic [3:0] 						    capability_type, 
    
   
    output logic 						    enable,

    input logic [`BIT_VEC(N_COUNTERS_PER_ENTRY*64)] 		    wr_dat,
    output logic [`BIT_VEC(N_COUNTERS_PER_ENTRY*64)] 		    rd_dat,

    output 							    yield,

    output logic 						    sw_req_valid,
    input logic 						    sw_req_ready,
    output logic [`LOG_VEC(N_ENTRIES)] 				    sw_req_addr,
    output logic [`BIT_VEC(COUNTER_LSB_OFFSET[N_COUNTERS_PER_ENTRY] )] sw_req_data,
    output 							    counter_op_e sw_req_op,
    
    input logic 						    sw_rsp_valid,
    output logic 						    sw_rsp_ready,
    input logic [`BIT_VEC(COUNTER_LSB_OFFSET[N_COUNTERS_PER_ENTRY]  )] sw_rsp_data,
    
    input logic 						    clear_on_read);

   localparam N_DATA_BITS = N_COUNTERS_PER_ENTRY*64;

   logic                                                  sw_cs;
   logic                                                  sw_we;
   logic [`LOG_VEC(N_ENTRIES)]                            sw_add;
   logic [`BIT_VEC(N_DATA_BITS)]                          sw_wdat; 
   logic [`BIT_VEC(N_DATA_BITS)]                          sw_rdat;
   logic                                                  grant;

   typedef enum logic {
                       IDLE=0, 
                       WAIT_FOR_READ_RESPONSE=1
                       } state_e;

   state_e r_state, c_state;
   logic [$clog2(N_OUTSTANDING_RMW):0] r_in_flight_count, c_in_flight_count;

   logic [`LOG_VEC(N_ENTRIES)]         addr_limit; 
   assign addr_limit = N_ENTRIES-1;
   
   nx_indirect_access_cntrl #(.MEM_TYPE (MEM_TYPE),
			      .CAPABILITIES (CAPABILITIES),
			      .CMND_ADDRESS(CMND_ADDRESS),
                              .STAT_ADDRESS(STAT_ADDRESS),
                              .ALIGNMENT(ALIGNMENT),
                              .N_TIMER_BITS(N_TIMER_BITS),
                              .N_REG_ADDR_BITS(N_REG_ADDR_BITS),
                              .N_DATA_BITS(N_DATA_BITS),
                              .N_TABLES(1),
                              .N_ENTRIES(N_ENTRIES),
                              .N_INIT_INC_BITS(N_INIT_INC_BITS),
                              .RESET_DATA(RESET_DATA)) nx_indirect_access_cntrl
     (.reset(),
      .cmnd_table_id ('0),
      .stat_table_id (),
      .sw_ce (),
      .sw_match ('0),
      .sw_aindex ('0),
      .*);


   assign sw_rsp_ready = 1'b1;
   assign sw_req_addr = sw_add;

   logic [`BIT_VEC(COUNTER_LSB_OFFSET[N_COUNTERS_PER_ENTRY] )] r_sw_rsp_data;

   always_ff@(posedge clk)
     r_sw_rsp_data <= sw_rsp_data; 

   generate
      genvar                           i;
      
      for (i=0; i<N_COUNTERS_PER_ENTRY; i++) begin
         assign sw_req_data[COUNTER_LSB_OFFSET[i] +: (COUNTER_LSB_OFFSET[i+1]-COUNTER_LSB_OFFSET[i])] = sw_wdat[i*64 +: (COUNTER_LSB_OFFSET[i+1]-COUNTER_LSB_OFFSET[i])];

         always_comb begin
            if (r_sw_rsp_data[COUNTER_LSB_OFFSET[i] +: (COUNTER_LSB_OFFSET[i+1]-COUNTER_LSB_OFFSET[i])] == '1)
              sw_rdat[i*64 +: 64] = '1;
            else
              sw_rdat[i*64 +: 64] = r_sw_rsp_data[COUNTER_LSB_OFFSET[i] +: (COUNTER_LSB_OFFSET[i+1]-COUNTER_LSB_OFFSET[i])]; 
         end
      end
   endgenerate

   always_comb begin
      
      c_state = r_state;
      c_in_flight_count = r_in_flight_count;

      sw_req_valid = 1'b0;
      sw_req_op = WRITE;
      grant = 1'b0;
      case (r_state)
        IDLE: begin
           if (sw_cs) begin
              if (sw_we) begin
                 
                 sw_req_valid = 1'b1;
                 sw_req_op = WRITE;
                 if (sw_req_ready)
                   grant = 1'b1;
              end
              else if (r_in_flight_count == '0) begin
                 sw_req_valid = 1'b1;
                 if (clear_on_read)
                   sw_req_op = READ_CLEAR;
                 else
                   sw_req_op = READ;
                 if (sw_req_ready) begin
                    c_state = WAIT_FOR_READ_RESPONSE;
                 end
              end
           end 
        end 
        WAIT_FOR_READ_RESPONSE: begin
           if (sw_rsp_valid) begin
              grant = 1'b1;
              c_state = IDLE;
           end
        end
      endcase

      case ({sw_req_valid && sw_req_ready, sw_rsp_valid && sw_rsp_ready})
        2'b01: c_in_flight_count = r_in_flight_count - 1;
        2'b10: c_in_flight_count = r_in_flight_count + 1;
      endcase
      
   end

   always@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         r_state <= IDLE;
         
         
         r_in_flight_count <= 0;
         
      end
      else begin
         r_state <= c_state;
         r_in_flight_count <= c_in_flight_count;         
      end
   end


endmodule 







