/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "messages.vh"
`include "nx_stat_counter.svp"
`include "nx_mem_typePKG.svp"
module nx_srf_stat_counter_indirect_access
  import nx_stat_counter::*;
  #(parameter CMND_ADDRESS=0,       
    parameter STAT_ADDRESS=0,       
    parameter ALIGNMENT=2,          
    parameter N_TIMER_BITS=6,       
	
    parameter N_REG_ADDR_BITS=16,   
	
    parameter N_ENTRIES=1,          
    parameter N_INIT_INC_BITS=0,    
	
	
    parameter SPECIALIZE=0,         
    parameter LATCH=0,              

    parameter integer N_COUNTERS_PER_ENTRY = 2,
    parameter integer COUNTER_LSB_OFFSET[N_COUNTERS_PER_ENTRY:0] = '{70, 32, 0},
    parameter integer COUNTER_ADD_WIDTH[N_COUNTERS_PER_ENTRY-1:0] = '{14, 1},
    parameter [`BIT_VEC(N_COUNTERS_PER_ENTRY*64)] RESET_DATA=0)
   (input logic                             clk,
    input logic 						    rst_n,

    
    input logic [`BIT_VEC(N_REG_ADDR_BITS)] 			    reg_addr,
    
    input logic [3:0] 						    cmnd_op,
    input logic [`LOG_VEC(N_ENTRIES)] 				    cmnd_addr, 

    output logic [2:0] 						    stat_code,
    output logic [`BIT_VEC(5)] 					    stat_datawords,
    output logic [`LOG_VEC(N_ENTRIES)] 				    stat_addr,


    output logic [15:0] 					    capability_lst,
    output logic [3:0] 						    capability_type,    
    
    input logic 						    wr_stb,
    input logic [`BIT_VEC(N_COUNTERS_PER_ENTRY*64)] 		    wr_dat,
    
    output logic [`BIT_VEC(N_COUNTERS_PER_ENTRY*64)] 		    rd_dat,


`ifdef ENA_BIMC
    input logic 						    lvm, 
    input logic 						    mlvm, 
    input logic 						    mrdten,
    input logic 						    bimc_rst_n,
    input logic 						    bimc_isync,
    input logic 						    bimc_idat,
    output logic 						    bimc_odat,
    output logic 						    bimc_osync,
    output logic 						    ro_uncorrectable_ecc_error,
`endif
    input logic 						    hw_req_valid,
    output logic 						    hw_req_ready,
    input logic [`LOG_VEC(N_ENTRIES)] 				    hw_req_addr,
    input 							    counter_op_e hw_req_op,
    input logic [`BIT_VEC(COUNTER_LSB_OFFSET[N_COUNTERS_PER_ENTRY]  )] hw_req_data,

    
    output logic 						    hw_rsp_valid,
    input logic 						    hw_rsp_ready,
    output logic [`BIT_VEC(COUNTER_LSB_OFFSET[N_COUNTERS_PER_ENTRY] )] hw_rsp_data,

    output logic 						    hw_yield,

    input logic 						    clear_on_read);
   
  localparam TOTAL_WIDTH = COUNTER_LSB_OFFSET[N_COUNTERS_PER_ENTRY];


   import nx_mem_typePKG::*;

   localparam capabilities_t capabilities_t_set
     = '{ init_inc     : (N_INIT_INC_BITS>0)? TRUE : FALSE,
	  compare      : FALSE,
          reserved_op  : 4'b0,
          default      : TRUE};   
                  
   logic              sw_req_valid;
   logic              sw_req_ready;
   logic [`LOG_VEC(N_ENTRIES)] sw_req_addr;
   logic [`BIT_VEC(TOTAL_WIDTH)] sw_req_data;

   counter_op_e sw_req_op;

   logic                                                           sw_rsp_valid;
   logic                                                           sw_rsp_ready;
   logic [`BIT_VEC(TOTAL_WIDTH)]                                   sw_rsp_data;

   logic                                                           req_valid;
   logic                                                           req_ready;
   logic [`LOG_VEC(N_ENTRIES)]                                     req_addr;
   logic [`BIT_VEC(TOTAL_WIDTH)]                                   req_data;
   logic                                                           req_id;
   counter_op_e                                                    req_op;

   logic                                                           rsp_valid;
   logic                                                           rsp_ready;
   logic [`BIT_VEC(TOTAL_WIDTH)]                                   rsp_data;
   logic                                                           rsp_id;

   logic                                                           yield;

   logic                                                           ar_valid;
   logic                                                           ar_ready;
   logic [`LOG_VEC(N_ENTRIES)]                                     ar_addr;
   
   logic                                                           r_valid;
   logic                                                           r_ready;
   logic [`BIT_VEC(TOTAL_WIDTH)]                                   r_data;

   logic                                                           aw_valid;
   logic                                                           aw_ready;
   logic [`LOG_VEC(N_ENTRIES)]                                     aw_addr;
   logic [`BIT_VEC(TOTAL_WIDTH)]                                   aw_data;
   logic [`BIT_VEC(TOTAL_WIDTH)]                                   aw_bwe;
   
   logic                                                           b_valid;
   logic                                                           b_ready; 

   assign req_valid = hw_req_valid || sw_req_valid;
   assign req_addr = hw_req_valid ? hw_req_addr : sw_req_addr;
   assign req_data = hw_req_valid ? hw_req_data : sw_req_data;
   assign req_op = hw_req_valid ? hw_req_op : sw_req_op;
   assign req_id = hw_req_valid;

   assign hw_req_ready = hw_req_valid && req_ready;
   assign sw_req_ready = sw_req_valid && !hw_req_valid && req_ready;

   assign hw_rsp_valid = rsp_valid && rsp_id;
   assign sw_rsp_valid = rsp_valid && !rsp_id;
   assign hw_rsp_data = rsp_data;
   assign sw_rsp_data = rsp_data;
   assign rsp_ready = (hw_rsp_valid && hw_rsp_ready) || (sw_rsp_valid && sw_rsp_ready);

   assign hw_yield = yield;

   assign aw_bwe = '1;

   nx_srfram_channelized
     #(.WIDTH(TOTAL_WIDTH),
       .DEPTH(N_ENTRIES),
       .SPECIALIZE(SPECIALIZE),
       .LATCH(LATCH),
       .RD_FLOP(1),
       .WR_FLOP(1))
   u_ram
     (.rclk(clk),
      .wclk(clk),
      .rst_rclk_n(rst_n),
      .rst_wclk_n(rst_n),
      .*);

   nx_stat_counter_ctrl
     #(.N_COUNTERS_PER_ENTRY(N_COUNTERS_PER_ENTRY),
       .COUNTER_LSB_OFFSET(COUNTER_LSB_OFFSET),
       .COUNTER_ADD_WIDTH(COUNTER_ADD_WIDTH),
       .N_ENTRIES(N_ENTRIES),
       .N_OUTSTANDING_RMW(4),
       .ID_WIDTH(1))
   u_stat_counter_ctrl
     (.*);

   nx_stat_counter_indirect_access_cntrl
     #(.MEM_TYPE              (SRFRAM),
       .CAPABILITIES          (capabilities_t_set),
       .CMND_ADDRESS	      (CMND_ADDRESS),
       .STAT_ADDRESS	      (STAT_ADDRESS),
       .ALIGNMENT	      (ALIGNMENT),
       .N_TIMER_BITS	      (N_TIMER_BITS),
       .N_REG_ADDR_BITS	      (N_REG_ADDR_BITS),
       .N_INIT_INC_BITS	      (N_INIT_INC_BITS),
       .N_ENTRIES	      (N_ENTRIES),
       .RESET_DATA	      (RESET_DATA),
       .N_COUNTERS_PER_ENTRY (N_COUNTERS_PER_ENTRY),
       .COUNTER_LSB_OFFSET(COUNTER_LSB_OFFSET),
       .N_OUTSTANDING_RMW(4))
   u_indirect_access_cntrl
     (.enable(),
      .*);

endmodule 


   
    