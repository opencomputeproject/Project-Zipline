/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "ccx_std.vh"
`include "messages.vh"
`include "nx_mem_typePKG.svp"
module nx_tcam_scrubbed_indirect_access (
   
   stat_code, stat_datawords, stat_addr, capability_lst,
   capability_type, rd_dat, hw_matchout, hw_aindex, hw_match,
   hw_yield, scrubber_single_bit_error_count,
   scrubber_single_bit_error_address, scrubber_multi_bit_error_count,
   scrubber_multi_bit_error_address, single_bit_error_interrupt,
   multi_bit_error_interrupt, scrubber_tecc_cs, scrubber_tecc_we,
   scrubber_tecc_add, scrubber_tecc_din, bist_status,
   
   clk, rst_n, tcam_resetb, reg_addr, cmnd_op, cmnd_addr, wr_stb,
   wr_dat, rd_stb, hw_ce, hw_key, hw_matchin, lvm, mlvm, mrdten,
   ovstb, tm, scrubber_en, scrubber_correct_single_bit_errors,
   scrubber_invalidate_multi_bit_errors, scrubber_scrub_interval,
   scrubber_force_single_bit_errors, scrubber_force_multi_bit_errors,
   tecc_scrubber_dout, tecc_scrubber_yield, tcam_pwrdwn_cfg,
   bist_dbg_compare_en, bist_dbg_data,
   bist_dbg_data_slice_or_status_sel, bist_dbg_data_valid,
   bist_dbg_en, bist_en, bist_rst_l, bist_skip_error_cnt
   );

    import nx_mem_typePKG::*; 

    parameter CMND_ADDRESS              = 0;    
    parameter STAT_ADDRESS              = 0;    
    parameter ALIGNMENT                 = 2;    

    parameter SBE_COUNT_BASE_ADDRESS    = 0;    
    parameter MBE_COUNT_BASE_ADDRESS    = 0;    

    parameter N_TIMER_BITS              = 6;    
    parameter N_REG_ADDR_BITS           = 16;   
    parameter N_DATA_BITS               = 258;  
    parameter N_ENTRIES                 = 512;  
    parameter N_INIT_INC_BITS           = 0;    
    parameter SPECIALIZE                = 1;    
    parameter TM_WIDTH                  = 20;   
    parameter CAM_PWRDWN_WIDTH          = 4;    
    parameter ECC_WIDTH                 = 9;    
    parameter NUM_CAMBIST               = 4;    
    parameter [`BIT_VEC(N_DATA_BITS)] RESET_DATA = 0;

    localparam [`LOG_VEC(N_ENTRIES)] ADDR_LIMIT = N_ENTRIES-1;

    
    localparam TCAM_DATA_WIDTH = N_DATA_BITS-2;

    
    localparam WIDTH           = N_DATA_BITS-2;
    localparam DEPTH           = N_ENTRIES/2;
    localparam PWRDWN_WIDTH    = CAM_PWRDWN_WIDTH;


    
    input wire                                  clk;
    input wire                                  rst_n;

   input logic                                  tcam_resetb; 

    
    input  wire  [`BIT_VEC(N_REG_ADDR_BITS)]    reg_addr;
    input  wire  [3:0]                          cmnd_op;
    input  wire  [`LOG_VEC(N_ENTRIES)]          cmnd_addr;

    output wire  [2:0]                          stat_code;
    output wire  [`BIT_VEC(5)]                  stat_datawords;
    output wire  [`LOG_VEC(N_ENTRIES)]          stat_addr;

    output logic [15:0] 			capability_lst;
    output logic [3:0] 				capability_type;
   

    input  wire                                 wr_stb;
    input  wire  [`BIT_VEC(N_DATA_BITS)]        wr_dat;
    
    input  wire                                 rd_stb; 
    output wire  [`BIT_VEC(N_DATA_BITS)]        rd_dat;

    
    input  wire                                 hw_ce;	
    input  wire  [`BIT_VEC(N_DATA_BITS-2)]      hw_key;	
   input wire [`BIT_VEC(N_ENTRIES/2)]           hw_matchin;
    output wire  [`BIT_VEC(N_ENTRIES/2)]        hw_matchout;
   output wire [`LOG_VEC(N_ENTRIES/2)]          hw_aindex;
   output wire                                  hw_match;
    output wire                                 hw_yield;

    
    input  wire                                 lvm;
    input  wire                                 mlvm;
    input  wire                                 mrdten;
    input  wire                                 ovstb;
    input  wire  [`BIT_VEC(TM_WIDTH)]           tm;


    
    input  wire                                 scrubber_en;
    input  wire                                 scrubber_correct_single_bit_errors;
    input  wire                                 scrubber_invalidate_multi_bit_errors;
    input  wire [31:0]                          scrubber_scrub_interval;
    output wire [31:0]                          scrubber_single_bit_error_count;
    output wire [`LOG_VEC(N_ENTRIES)]           scrubber_single_bit_error_address;
    output wire [31:0]                          scrubber_multi_bit_error_count;
    output wire [`LOG_VEC(N_ENTRIES)]           scrubber_multi_bit_error_address;
    input  wire                                 scrubber_force_single_bit_errors;
    input  wire                                 scrubber_force_multi_bit_errors;

    
    output wire                                 single_bit_error_interrupt;
    output wire                                 multi_bit_error_interrupt;

    
    output wire                                 scrubber_tecc_cs;
    output wire                                 scrubber_tecc_we;
    output wire [`LOG_VEC(N_ENTRIES)]           scrubber_tecc_add;
    output wire [ECC_WIDTH-1:0]                 scrubber_tecc_din;
    input  wire [ECC_WIDTH-1:0]                 tecc_scrubber_dout;
    input  wire                                 tecc_scrubber_yield;


    
    input  wire  [`BIT_VEC(CAM_PWRDWN_WIDTH)]   tcam_pwrdwn_cfg;

    
    input                                       bist_dbg_compare_en                 [NUM_CAMBIST-1:0];
    input   [31:0]                              bist_dbg_data                       [NUM_CAMBIST-1:0];
    input   [7:0]                               bist_dbg_data_slice_or_status_sel   [NUM_CAMBIST-1:0];
    input                                       bist_dbg_data_valid                 [NUM_CAMBIST-1:0];
    input                                       bist_dbg_en                         [NUM_CAMBIST-1:0];
    input                                       bist_en                             [NUM_CAMBIST-1:0];
    input                                       bist_rst_l                          [NUM_CAMBIST-1:0];
    input   [7:0]                               bist_skip_error_cnt                 [NUM_CAMBIST-1:0];
    output  [31:0]                              bist_status                         [NUM_CAMBIST-1:0];

   localparam capabilities_t capabilities_t_set
     =  {ack_error      : TRUE,
	 sim_tmo        : TRUE,
         reserved_op    : '0,
	 compare        : TRUE,
	 set_init_start : TRUE,
	 init_inc       : TRUE,
	 init           : TRUE,
	 reset          : TRUE,
	 disabled       : TRUE,
	 enable         : TRUE,
	 write          : TRUE,
	 read           : TRUE,
	 nop            : TRUE}; 
 
    
    
    wire		mbe_count_stb;		
    wire		sbe_count_stb;		
    

    wire  [`BIT_VEC(N_ENTRIES/2)]   matchin;
    wire  [`LOG_VEC(N_ENTRIES)]     add;
    wire                            cs;
    wire                            ce;
    wire  [TCAM_DATA_WIDTH-1:0]     din;
    wire  [1:0]                     dinv;
    wire  [`BIT_VEC(WIDTH)]         dout;
    wire  [1:0]                     doutv;
    wire                            enable;
    wire  [`LOG_VEC(N_ENTRIES)]     sw_add;
    wire                            sw_cs;
    wire                            sw_ce;
    wire  [`BIT_VEC(N_DATA_BITS)]   sw_wdat;
    wire                            sw_we;
    wire                            we;
    wire                            tcam_scrubber_cs;
    wire  [`LOG_VEC(N_ENTRIES)]     tcam_scrubber_add;
    wire                            tcam_scrubber_we;
    wire  [1:0]                     tcam_scrubber_dinv;
    wire  [TCAM_DATA_WIDTH-1:0]     tcam_scrubber_din;
    wire  [`BIT_VEC(N_DATA_BITS)]   sw_rdat;
    wire  [`LOG_VEC(N_ENTRIES/2)]   sw_aindex;
    wire                            sw_match;
    wire [31:0]                     scrubber_sbe_count[1];
    wire [31:0]                     scrubber_mbe_count[1];
 
    
    
    assign tcam_scrubber_cs     =  hw_ce  | sw_cs | sw_ce;
    assign tcam_scrubber_add    = (hw_ce) ? '0     : sw_add;
    assign tcam_scrubber_we     = (hw_ce) ? '0     : sw_we;
    assign tcam_scrubber_dinv   = (hw_ce) ? '0     : sw_wdat[N_DATA_BITS-2 +: 2];
    assign tcam_scrubber_din    = (hw_ce) ? hw_key : sw_wdat[N_DATA_BITS-3:0];
    assign sw_rdat              = {doutv, dout};
    assign sw_match             = hw_match;
    assign sw_aindex            = hw_aindex;
    assign ce                   = hw_ce | sw_ce;

   logic hw_ce_d1, hw_ce_d2;
   assign matchin = hw_ce_d2 ? hw_matchin : '1;


   always_ff@(posedge clk or negedge rst_n) begin
     if (!rst_n) begin
        
	
	hw_ce_d1 <= 0;
	hw_ce_d2 <= 0;
	
     end
     else begin
        hw_ce_d1 <= hw_ce;
        hw_ce_d2 <= hw_ce_d1;
     end
   end


    

    tcam_scrubber # (
		     
		     .N_ENTRIES		(N_ENTRIES),
		     .TCAM_DATA_WIDTH	(TCAM_DATA_WIDTH),
		     .ECC_WIDTH		(ECC_WIDTH))
       u_scrubber   (
		     
		     .scrubber_tcam_cs	(cs),			 
		     .scrubber_tcam_add	(add[`LOG_VEC(N_ENTRIES)]), 
		     .scrubber_tcam_we	(we),			 
		     .scrubber_tcam_dinv(dinv[1:0]),		 
		     .scrubber_tcam_din	(din[TCAM_DATA_WIDTH-1:0]), 
		     .sbe_count_stb	(sbe_count_stb),
		     .scrubber_single_bit_error_address(scrubber_single_bit_error_address[`LOG_VEC(N_ENTRIES)]),
		     .mbe_count_stb	(mbe_count_stb),
		     .scrubber_multi_bit_error_address(scrubber_multi_bit_error_address[`LOG_VEC(N_ENTRIES)]),
		     .single_bit_error_interrupt(single_bit_error_interrupt),
		     .multi_bit_error_interrupt(multi_bit_error_interrupt),
		     .scrubber_tecc_cs	(scrubber_tecc_cs),
		     .scrubber_tecc_we	(scrubber_tecc_we),
		     .scrubber_tecc_add	(scrubber_tecc_add[`LOG_VEC(N_ENTRIES)]),
		     .scrubber_tecc_din	(scrubber_tecc_din[ECC_WIDTH-1:0]),
		     
		     .clk		(clk),
		     .rst_n		(rst_n),
		     .tcam_scrubber_cs	(tcam_scrubber_cs),
		     .tcam_scrubber_add	(tcam_scrubber_add[`LOG_VEC(N_ENTRIES)]),
		     .tcam_scrubber_we	(tcam_scrubber_we),
		     .tcam_scrubber_dinv(tcam_scrubber_dinv[1:0]),
		     .tcam_scrubber_din	(tcam_scrubber_din[TCAM_DATA_WIDTH-1:0]),
		     .tcam_scrubber_doutv(doutv),		 
		     .tcam_scrubber_dout(dout),			 
		     .scrubber_en	(scrubber_en),
		     .scrubber_correct_single_bit_errors(scrubber_correct_single_bit_errors),
		     .scrubber_invalidate_multi_bit_errors(scrubber_invalidate_multi_bit_errors),
		     .scrubber_scrub_interval(scrubber_scrub_interval[31:0]),
		     .scrubber_force_single_bit_errors(scrubber_force_single_bit_errors),
		     .scrubber_force_multi_bit_errors(scrubber_force_multi_bit_errors),
		     .tecc_scrubber_dout(tecc_scrubber_dout[ECC_WIDTH-1:0]),
		     .tecc_scrubber_yield(tecc_scrubber_yield));

    

    nx_tcam_cambist # (
		       
		       .WIDTH		(WIDTH),
		       .DEPTH		(DEPTH),
		       .SPECIALIZE	(SPECIALIZE),
		       .TM_WIDTH	(TM_WIDTH),
		       .PWRDWN_WIDTH	(PWRDWN_WIDTH),
		       .NUM_CAMBIST	(NUM_CAMBIST))
            u_tcam    (
		       
		       .dout		(dout[`BIT_VEC(WIDTH)]),
		       .doutv		(doutv[1:0]),
		       .matchout	(hw_matchout),		 
		       .match		(hw_match),		 
		       .aindex		(hw_aindex),		 
		       .bist_status	(bist_status),
		       
		       .clk		(clk),
		       .rst_n		(rst_n),
		       .add		(add[`LOG_VEC(2*DEPTH)]),
		       .cs		(cs),
		       .we		(we),
		       .din		(din[`BIT_VEC(WIDTH)]),
		       .dinv		(dinv[1:0]),
		       .resetb		(tcam_resetb),		 
		       .ce		(ce),
		       .lvm		(lvm),
		       .mlvm		(mlvm),
		       .mrdten		(mrdten),
		       .ovstb		(ovstb),
		       .tm		(tm[`BIT_VEC(TM_WIDTH)]),
		       .tcam_pwrdwn_cfg	(tcam_pwrdwn_cfg[`BIT_VEC(PWRDWN_WIDTH)]),
		       .matchin		(matchin[`BIT_VEC(DEPTH)]),
		       .bist_dbg_compare_en(bist_dbg_compare_en),
		       .bist_dbg_data	(bist_dbg_data),
		       .bist_dbg_data_slice_or_status_sel(bist_dbg_data_slice_or_status_sel),
		       .bist_dbg_data_valid(bist_dbg_data_valid),
		       .bist_dbg_en	(bist_dbg_en),
		       .bist_en		(bist_en),
		       .bist_rst_l	(bist_rst_l),
		       .bist_skip_error_cnt(bist_skip_error_cnt));


    

    nx_indirect_access_cntrl #(
			       
			       .MEM_TYPE	(TCAM),		 
			       .CMND_ADDRESS	(CMND_ADDRESS),
			       .STAT_ADDRESS	(STAT_ADDRESS),
			       .ALIGNMENT	(ALIGNMENT),
			       .N_TIMER_BITS	(N_TIMER_BITS),
			       .N_REG_ADDR_BITS	(N_REG_ADDR_BITS),
			       .N_DATA_BITS	(N_DATA_BITS),
			       .N_TABLES	(1),		 
			       .N_ENTRIES	(N_ENTRIES),
			       .N_INIT_INC_BITS	(N_INIT_INC_BITS),
			       .CAPABILITIES	(capabilities_t_set), 
			       .RESET_DATA	(RESET_DATA[`BIT_VEC(N_DATA_BITS)]))
                u_controller  (
			       
			       .stat_code	(stat_code[2:0]),
			       .stat_datawords	(stat_datawords[`BIT_VEC(5)]),
			       .stat_addr	(stat_addr[`LOG_VEC(N_ENTRIES)]),
			       .stat_table_id	(),		 
			       .capability_lst	(capability_lst[15:0]),
			       .capability_type	(capability_type[3:0]),
			       .enable		(enable),
			       .rd_dat		(rd_dat[`BIT_VEC(N_DATA_BITS)]),
			       .sw_cs		(sw_cs),
			       .sw_ce		(sw_ce),
			       .sw_we		(sw_we),
			       .sw_add		(sw_add[`LOG_VEC(N_ENTRIES)]),
			       .sw_wdat		(sw_wdat[`BIT_VEC(N_DATA_BITS)]),
			       .yield		(hw_yield),	 
			       .reset		(),		 
			       
			       .clk		(clk),
			       .rst_n		(rst_n),
			       .wr_stb		(wr_stb),
			       .reg_addr	(reg_addr[`BIT_VEC(N_REG_ADDR_BITS)]),
			       .cmnd_op		(cmnd_op[3:0]),
			       .cmnd_addr	(cmnd_addr[`LOG_VEC(N_ENTRIES)]),
			       .cmnd_table_id	('0),		 
			       .addr_limit	(ADDR_LIMIT),	 
			       .wr_dat		(wr_dat[`BIT_VEC(N_DATA_BITS)]),
			       .sw_rdat		(sw_rdat[`BIT_VEC(N_DATA_BITS)]),
			       .sw_match	(sw_match),
			       .sw_aindex	(sw_aindex[`LOG_VEC((N_ENTRIES)/2)]),
			       .grant		(!hw_ce));	 

    
    

    nx_event_counter_array # (
			      
			      .BASE_ADDRESS	(SBE_COUNT_BASE_ADDRESS), 
			      .ALIGNMENT	(ALIGNMENT),
			      .N_ADDR_BITS	(N_REG_ADDR_BITS), 
			      .N_COUNTERS	(1),		 
			      .N_COUNT_BY_BITS	(1),		 
			      .N_COUNTER_BITS	(32))		 
                   sbe_count (
			      
			      .counter_a	(scrubber_sbe_count), 
			      
			      .clk		(clk),
			      .rst_n		(rst_n),
			      .reg_addr		(reg_addr[`BIT_VEC(N_REG_ADDR_BITS)]),
			      .rd_stb		(rd_stb),
			      .wr_stb		(1'b0),		 
			      .reg_data		('0),		 
			      .count_stb	(sbe_count_stb), 
			      .count_by		(1'b1),		 
			      .count_id		(1'b0));		 
    nx_event_counter_array # (
			      
			      .BASE_ADDRESS	(MBE_COUNT_BASE_ADDRESS), 
			      .ALIGNMENT	(ALIGNMENT),
			      .N_ADDR_BITS	(N_REG_ADDR_BITS), 
			      .N_COUNTERS	(1),		 
			      .N_COUNT_BY_BITS	(1),		 
			      .N_COUNTER_BITS	(32))		 
                   mbe_count (
			      
			      .counter_a	(scrubber_mbe_count), 
			      
			      .clk		(clk),
			      .rst_n		(rst_n),
			      .reg_addr		(reg_addr[`BIT_VEC(N_REG_ADDR_BITS)]),
			      .rd_stb		(rd_stb),
			      .wr_stb		(1'b0),		 
			      .reg_data		('0),		 
			      .count_stb	(mbe_count_stb), 
			      .count_by		(1'b1),		 
			      .count_id		(1'b0));		 


    assign scrubber_single_bit_error_count = scrubber_sbe_count[0];
    assign scrubber_multi_bit_error_count  = scrubber_mbe_count[0];

endmodule







