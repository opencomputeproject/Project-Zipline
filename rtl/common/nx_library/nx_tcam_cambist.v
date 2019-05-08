/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

























`include "ccx_std.vh"

module nx_tcam_cambist (
   
   dout, doutv, matchout, match, aindex, bist_status,
   
   clk, rst_n, add, cs, we, din, dinv, resetb, ce, lvm, mlvm, mrdten,
   ovstb, tm, tcam_pwrdwn_cfg, matchin, bist_dbg_compare_en,
   bist_dbg_data, bist_dbg_data_slice_or_status_sel,
   bist_dbg_data_valid, bist_dbg_en, bist_en, bist_rst_l,
   bist_skip_error_cnt
   );

   parameter   WIDTH        = 256;  
   parameter   DEPTH        = 1024; 
   parameter   SPECIALIZE   = 1;    
   parameter   TM_WIDTH     = 20;   
   parameter   PWRDWN_WIDTH = 4;    
   parameter   NUM_CAMBIST  = 4;    

   input                               clk; 
   input                               rst_n; 

   input [`LOG_VEC(2*DEPTH)]           add; 
   input                               cs;
   input                               we;
   input [`BIT_VEC(WIDTH)]             din; 
   input [1:0]                         dinv; 
   input                               resetb;
   input                               ce;
   input                               lvm;
   input                               mlvm;
   input                               mrdten;
   input                               ovstb;
   input [`BIT_VEC(TM_WIDTH)]          tm;
   input [`BIT_VEC(PWRDWN_WIDTH)]      tcam_pwrdwn_cfg;

   output [`BIT_VEC(WIDTH)]            dout;
   output [1:0]                        doutv;
   input [`BIT_VEC(DEPTH)]             matchin;
   output logic [`BIT_VEC(DEPTH)]            matchout;
   output logic                        match;
   output logic [`LOG_VEC(DEPTH)]      aindex;

   input                               bist_dbg_compare_en                 [NUM_CAMBIST-1:0];
   input [31:0]                        bist_dbg_data                       [NUM_CAMBIST-1:0];
   input [7:0]                         bist_dbg_data_slice_or_status_sel   [NUM_CAMBIST-1:0];
   input                               bist_dbg_data_valid                 [NUM_CAMBIST-1:0];
   input                               bist_dbg_en                         [NUM_CAMBIST-1:0];
   input                               bist_en                             [NUM_CAMBIST-1:0];
   input                               bist_rst_l                          [NUM_CAMBIST-1:0];
   input [7:0]                         bist_skip_error_cnt                 [NUM_CAMBIST-1:0];
   output [31:0]                       bist_status                         [NUM_CAMBIST-1:0];

   integer                             i;
   genvar                              k;

   wire [NUM_CAMBIST-1:0]              jtag_so;
   wire [NUM_CAMBIST-1:0]              jtag_capture;
   wire [NUM_CAMBIST-1:0]              jtag_resetb;
   wire [NUM_CAMBIST-1:0]              jtag_select;
   wire [NUM_CAMBIST-1:0]              jtag_shift;
   wire [NUM_CAMBIST-1:0]              jtag_si;
   wire [NUM_CAMBIST-1:0]              jtag_tck;
   wire [NUM_CAMBIST-1:0]              jtag_update;
   wire                                scan_mode;
   wire                                scan_rst_l;

   wire [NUM_CAMBIST-1:0]              jtag_so_buf;
   wire [NUM_CAMBIST-1:0]              jtag_capture_buf;
   wire [NUM_CAMBIST-1:0]              jtag_resetb_buf;
   wire [NUM_CAMBIST-1:0]              jtag_select_buf;
   wire [NUM_CAMBIST-1:0]              jtag_shift_buf;
   wire [NUM_CAMBIST-1:0]              jtag_si_buf;
   wire [NUM_CAMBIST-1:0]              jtag_tck_buf;
   wire [NUM_CAMBIST-1:0]              jtag_update_buf;
   wire                                scan_mode_buf;
   wire                                scan_rst_l_buf;

   


   

   wire [`LOG_VEC(DEPTH+1)]            ADDR;
   DW01_binenc #(.A_width(DEPTH), .ADDR_width($clog2(DEPTH+1))) u_bienc
   (.A(matchout & matchin),
    .ADDR(ADDR));

   assign aindex = ADDR[`LOG_VEC(DEPTH)];

   generate
      
      
      if ((1<<$clog2(DEPTH)) == DEPTH) begin
         
         assign match = !ADDR[$clog2(DEPTH)];
      end
      else begin
         
         assign match = ADDR != '1;
      end
   endgenerate

   generate

      case ({SPECIALIZE, DEPTH, WIDTH})

        {32'd1, 32'd1024, 32'd256} : begin : tcam1024x256b

           reg  [0:0]   we_tcam     [3:0];
           reg [255:0]  din_tcam    [3:0];
           wire [255:0] dout_tcam   [3:0];
           reg [1:0]    dinv_tcam   [3:0];
           wire [1:0]   doutv_tcam  [3:0];
           reg [8:0]    add_tcam    [3:0];
           reg [0:0]    cs_tcam     [3:0];
           reg [0:0]    resetb_tcam [3:0];
           reg [0:0]    ce_tcam     [3:0];
           logic [`BIT_VEC(DEPTH)] matchout_raw;

           reg [1:0]    add_q;

           always @ (*) begin
              for (i=0; i<4; i=i+1) begin
                 we_tcam     [i] = 1'b0;
                 din_tcam    [i] = 256'b0;
                 dinv_tcam   [i] = 2'b0;
                 add_tcam    [i] = 9'b0;

                 cs_tcam     [i] = cs & (add[10:9] == i) & ~tcam_pwrdwn_cfg[i];
                 we_tcam     [i] = we;
                 resetb_tcam [i] = resetb;
                 ce_tcam     [i] = ce & ~tcam_pwrdwn_cfg[i];
                 din_tcam    [i] = din;
                 dinv_tcam   [i] = dinv;
                 add_tcam    [i] = add[8:0];
                 matchout[i*256+:256] = matchout_raw[i*256+:256] & {256{~tcam_pwrdwn_cfg[i]}};
              end
           end

           always @ (posedge clk or negedge rst_n) begin
              if (!rst_n) begin
                 add_q <= 2'b0;
              end else begin
                 add_q <= add[10:9];
              end
           end

           assign doutv = doutv_tcam[add_q];
           assign dout  = dout_tcam [add_q];
           
           
           

           for (k=0; k<4; k=k+1) begin : k_loop1
              CU0_M28CAMSLL256Y256CR6022VTES35VLMQBSIRCG_wrapper_1 u_cfp_tcam
                  (
		   
		   .o_bist_status	(bist_status[k]),	 
		   .bist_aindex		(),			 
		   .bist_match		(),			 
		   .dout		(dout_tcam[k]),		 
		   .doutv		(doutv_tcam[k]),	 
		   .matchout		(matchout_raw[(k*256) +:256]), 
		   .o_ijtag_so		(jtag_so[k]),		 
		   .so			(),			 
		   
		   .add			(add_tcam[k]),		 
		   .byp			({1{1'b0}}),		 
		   .ce			(ce_tcam[k]),		 
		   .clk			(clk),			 
		   .cs			(cs_tcam[k]),		 
		   .din			(din_tcam[k]),		 
		   .dinm		({256{1'b1}}),		 
		   .dinv		(dinv_tcam[k]),		 
		   .i_bist_block_select	({4{1'b0}}),		 
		   .i_bist_cache_enable	({1{1'b0}}),		 
		   .i_bist_cache_index	({16{1'b0}}),		 
		   .i_bist_cascade_select({3{1'b0}}),		 
		   .i_bist_dbg_compare_en(bist_dbg_compare_en[k]), 
		   .i_bist_dbg_data	(bist_dbg_data[k]),	 
		   .i_bist_dbg_data_slice_or_status_sel(bist_dbg_data_slice_or_status_sel[k]), 
		   .i_bist_dbg_data_valid(bist_dbg_data_valid[k]), 
		   .i_bist_en		({15'b0, bist_en[k]}),	 
		   .i_bist_lpt_sel	({1{1'b0}}),		 
		   .i_bist_mode		({2{1'b0}}),		 
		   .i_bist_repair_enable({1{1'b0}}),		 
		   .i_bist_rst_l	(bist_rst_l[k]),	 
		   .i_bist_skip_error_cnt(bist_skip_error_cnt[k]), 
		   .i_dbg_en		({15'b0, bist_dbg_en[k]}), 
		   .i_ijtag_capture	(jtag_capture_buf[k]),	 
		   .i_ijtag_resetb	(jtag_resetb_buf[k]),	 
		   .i_ijtag_select	(jtag_select_buf[k]),	 
		   .i_ijtag_shift	(jtag_shift_buf[k]),	 
		   .i_ijtag_si		(jtag_si_buf[k]),	 
		   .i_ijtag_tck		(jtag_tck_buf[k]),	 
		   .i_ijtag_update	(jtag_update_buf[k]),	 
		   .i_scan_mode		(scan_mode_buf),	 
		   .i_scan_rst_l	(scan_rst_l_buf),	 
		   .lvm			(lvm ),			 
		   .mlvm		(mlvm ),		 
		   .mrdten		(mrdten ),		 
		   .ovstb		(ovstb),		 
		   .rds			({1{1'b0}}),		 
		   .resetb		(resetb_tcam[k]),	 
		   .s_cf		({16{1'b0}}),		 
		   .s_rf		({16{1'b0}}),		 
		   .se			({1{1'b0}}),		 
		   .si			({5{1'b0}}),		 
		   .tm			(tm),			 
		   .we			(we_tcam[k]));		 
           end

        end : tcam1024x256b

        {32'd1, 32'd256, 32'd256} : begin : tcam256x256b

           logic cs_tcam;
           logic ce_tcam;
           logic [`BIT_VEC(DEPTH)] matchout_raw;

           assign cs_tcam = cs & ~tcam_pwrdwn_cfg[0];
           assign ce_tcam = ce & ~tcam_pwrdwn_cfg[0];
           assign matchout = matchout_raw & {256{~tcam_pwrdwn_cfg[0]}};

           


           CU0_M28CAMSLL256Y256CR6022VTES35VLMQBSIRCG_wrapper_1 u_slicm_tcam 
             (
	      
	      .o_bist_status		(bist_status[0]),	 
	      .bist_aindex		(),			 
	      .bist_match		(),			 
	      .dout			(dout),			 
	      .doutv			(doutv),		 
	      .matchout			(matchout_raw),		 
	      .o_ijtag_so		(jtag_so[0]),		 
	      .so			(),			 
	      
	      .add			(add),			 
	      .byp			({1{1'b0}}),		 
	      .ce			(ce_tcam),		 
	      .clk			(clk),			 
	      .cs			(cs_tcam),		 
	      .din			(din),			 
	      .dinm			({256{1'b1}}),		 
	      .dinv			(dinv),			 
	      .i_bist_block_select	({4{1'b0}}),		 
	      .i_bist_cache_enable	({1{1'b0}}),		 
	      .i_bist_cache_index	({16{1'b0}}),		 
	      .i_bist_cascade_select	({3{1'b0}}),		 
	      .i_bist_dbg_compare_en	(bist_dbg_compare_en[0]), 
	      .i_bist_dbg_data		(bist_dbg_data[0]),	 
	      .i_bist_dbg_data_slice_or_status_sel(bist_dbg_data_slice_or_status_sel[0]), 
	      .i_bist_dbg_data_valid	(bist_dbg_data_valid[0]), 
	      .i_bist_en		({15'b0, bist_en[0]}),	 
	      .i_bist_lpt_sel		({1{1'b0}}),		 
	      .i_bist_mode		({2{1'b0}}),		 
	      .i_bist_repair_enable	({1{1'b0}}),		 
	      .i_bist_rst_l		(bist_rst_l[0]),	 
	      .i_bist_skip_error_cnt	(bist_skip_error_cnt[0]), 
	      .i_dbg_en			({15'b0, bist_dbg_en[0]}), 
	      .i_ijtag_capture		(jtag_capture_buf[0]),	 
	      .i_ijtag_resetb		(jtag_resetb_buf[0]),	 
	      .i_ijtag_select		(jtag_select_buf[0]),	 
	      .i_ijtag_shift		(jtag_shift_buf[0]),	 
	      .i_ijtag_si		(jtag_si_buf[0]),	 
	      .i_ijtag_tck		(jtag_tck_buf[0]),	 
	      .i_ijtag_update		(jtag_update_buf[0]),	 
	      .i_scan_mode		(scan_mode_buf),	 
	      .i_scan_rst_l		(scan_rst_l_buf),	 
	      .lvm			(lvm ),			 
	      .mlvm			(mlvm ),		 
	      .mrdten			(mrdten ),		 
	      .ovstb			(ovstb),		 
	      .rds			({1{1'b0}}),		 
	      .resetb			(resetb),		 
	      .s_cf			({16{1'b0}}),		 
	      .s_rf			({16{1'b0}}),		 
	      .se			({1{1'b0}}),		 
	      .si			({5{1'b0}}),		 
	      .tm			(tm),			 
	      .we			(we));			 

        end : tcam256x256b

        {32'd1, 32'd1024, 32'd192} : begin : tcam1024x192b

           reg  [0:0]   we_tcam     [3:0];
           reg [191:0]  din_tcam    [3:0];
           wire [191:0] dout_tcam   [3:0];
           reg [1:0]    dinv_tcam   [3:0];
           wire [1:0]   doutv_tcam  [3:0];
           reg [8:0]    add_tcam    [3:0];
           reg [0:0]    cs_tcam     [3:0];
           reg [0:0]    resetb_tcam [3:0];
           reg [0:0]    ce_tcam     [3:0];
           logic [`BIT_VEC(DEPTH)] matchout_raw;

           reg [1:0]    add_q;

           always @ (*) begin
              for (i=0; i<4; i=i+1) begin
                 we_tcam     [i] = 1'b0;
                 din_tcam    [i] = 192'b0;
                 dinv_tcam   [i] = 2'b0;
                 add_tcam    [i] = 9'b0;

                 cs_tcam     [i] = cs & ~tcam_pwrdwn_cfg[i];
                 we_tcam     [i] = we & (add[10:9] == i);
                 resetb_tcam [i] = resetb;
                 ce_tcam     [i] = ce & ~tcam_pwrdwn_cfg[i];
                 din_tcam    [i] = din;
                 dinv_tcam   [i] = dinv;
                 add_tcam    [i] = add[8:0];
                 matchout[i*256+:256] = matchout_raw[i*256+:256] & {256{~tcam_pwrdwn_cfg[i]}};
              end
           end

           always @ (posedge clk or negedge resetb) begin
              if (!resetb) begin
                 add_q <= 2'b0;
              end else begin
                 add_q <= add[10:9];
              end
           end

           assign doutv = doutv_tcam[add_q];
           assign dout  = dout_tcam [add_q];
           
           
           
           

           for (k=0; k<4; k=k+1) begin: k_loop2
              CU0_M28CAMSLL256Y192CR6022VTES35VLMQBSIRCG_wrapper_1 u_cfp_tcam    
                  (
		   
		   .o_bist_status	(bist_status[k]),	 
		   .bist_aindex		(),			 
		   .bist_match		(),			 
		   .dout		(dout_tcam[k]),		 
		   .doutv		(doutv_tcam[k]),	 
		   .matchout		(matchout_raw[(k*256) +:256]), 
		   .o_ijtag_so		(jtag_so[k]),		 
		   .so			(),			 
		   
		   .add			(add_tcam[k]),		 
		   .byp			({1{1'b0}}),		 
		   .ce			(ce_tcam[k]),		 
		   .clk			(clk),			 
		   .cs			(cs_tcam[k]),		 
		   .din			(din_tcam[k]),		 
		   .dinm		({192{1'b1}}),		 
		   .dinv		(dinv_tcam[k]),		 
		   .i_bist_block_select	({4{1'b0}}),		 
		   .i_bist_cache_enable	({1{1'b0}}),		 
		   .i_bist_cache_index	({16{1'b0}}),		 
		   .i_bist_cascade_select({3{1'b0}}),		 
		   .i_bist_dbg_compare_en(bist_dbg_compare_en[k]), 
		   .i_bist_dbg_data	(bist_dbg_data[k]),	 
		   .i_bist_dbg_data_slice_or_status_sel(bist_dbg_data_slice_or_status_sel[k]), 
		   .i_bist_dbg_data_valid(bist_dbg_data_valid[k]), 
		   .i_bist_en		({15'b0, bist_en[k]}),	 
		   .i_bist_lpt_sel	({1{1'b0}}),		 
		   .i_bist_mode		({2{1'b0}}),		 
		   .i_bist_repair_enable({1{1'b0}}),		 
		   .i_bist_rst_l	(bist_rst_l[k]),	 
		   .i_bist_skip_error_cnt(bist_skip_error_cnt[k]), 
		   .i_dbg_en		({15'b0, bist_dbg_en[k]}), 
		   .i_ijtag_capture	(jtag_capture_buf[k]),	 
		   .i_ijtag_resetb	(jtag_resetb_buf[k]),	 
		   .i_ijtag_select	(jtag_select_buf[k]),	 
		   .i_ijtag_shift	(jtag_shift_buf[k]),	 
		   .i_ijtag_si		(jtag_si_buf[k]),	 
		   .i_ijtag_tck		(jtag_tck_buf[k]),	 
		   .i_ijtag_update	(jtag_update_buf[k]),	 
		   .i_scan_mode		(scan_mode_buf),	 
		   .i_scan_rst_l	(scan_rst_l_buf),	 
		   .lvm			(lvm ),			 
		   .mlvm		(mlvm ),		 
		   .mrdten		(mrdten ),		 
		   .ovstb		(ovstb),		 
		   .rds			({1{1'b0}}),		 
		   .resetb		(resetb_tcam[k]),	 
		   .s_cf		({16{1'b0}}),		 
		   .s_rf		({16{1'b0}}),		 
		   .se			({1{1'b0}}),		 
		   .si			({5{1'b0}}),		 
		   .tm			(tm),			 
		   .we			(we_tcam[k]));		 
           end

        end : tcam1024x192b
	    
        default : begin : tcamDxWb 
           
        end : tcamDxWb
        
      endcase

      for (k=0; k<NUM_CAMBIST; k=k+1) begin : k_loop3
         M10S31B_BUFX4 dont_touch_zero_buf_jtag_so_buf (.i(jtag_so[k]), .o(jtag_so_buf[k]));
         M10S31B_BUFX4 dont_touch_zero_buf_jtag_capture_buf (.i(jtag_capture[k]), .o(jtag_capture_buf[k]));
         M10S31B_BUFX4 dont_touch_zero_buf_jtag_resetb_buf (.i(jtag_resetb[k]), .o(jtag_resetb_buf[k]));
         M10S31B_BUFX4 dont_touch_zero_buf_jtag_select_buf (.i(jtag_select[k]), .o(jtag_select_buf[k]));
         M10S31B_BUFX4 dont_touch_zero_buf_jtag_shift_buf (.i(jtag_shift[k]), .o(jtag_shift_buf[k]));
         M10S31B_BUFX4 dont_touch_zero_buf_jtag_si_buf (.i(jtag_si[k]), .o(jtag_si_buf[k]));
         M10S31B_BUFX4 dont_touch_zero_buf_jtag_tck_buf (.i(jtag_tck[k]), .o(jtag_tck_buf[k]));
         M10S31B_BUFX4 dont_touch_zero_buf_jtag_update_buf (.i(jtag_update[k]), .o(jtag_update_buf[k]));
      end
      M10S31B_BUFX4 dont_touch_scan_mode_buf (.i(scan_mode), .o(scan_mode_buf));
      M10S31B_BUFX4 dont_touch_scan_rst_l_buf (.i(scan_rst_l), .o(scan_rst_l_buf));
      
      tcam_dft_danglers #(.WIDTH(NUM_CAMBIST)) u_dft_danglers
        (.jtag_so(jtag_so_buf),
         .*);
      
   endgenerate
   
endmodule





