/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

























`include "ccx_std.vh"

module nx_tcam (
   
   dout, doutv, matchout,
   
   clk, rst_n, add, cs, we, din, dinv, resetb, ce, lvm, mlvm, mrdten,
   ovstb, tm, tcam_pwrdwn_cfg
   );

   parameter   WIDTH        = 256;  
   parameter   DEPTH        = 1024; 
   parameter   SPECIALIZE   = 1;    
   parameter   TM_WIDTH     = 20;   
   parameter   PWRDWN_WIDTH = 1;    

   localparam  ADDR_WIDTH = $clog2(2*DEPTH); 
   
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
   output [`BIT_VEC(DEPTH)]            matchout;

   integer                             i;
   genvar                              k;

   

   

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

           reg [1:0]    add_q;

           always @ (*) begin
              for (i=0; i<4; i=i+1) begin
                 we_tcam     [i] = 1'b0;
                 din_tcam    [i] = 256'b0;
                 dinv_tcam   [i] = 2'b0;
                 add_tcam    [i] = 9'b0;

                 cs_tcam     [i] = cs &  (add[10:9] == i) & ~tcam_pwrdwn_cfg[i];
                 we_tcam     [i] = we;
                 resetb_tcam [i] = resetb;
                 ce_tcam     [i] = ce & ~tcam_pwrdwn_cfg[i];
                 din_tcam    [i] = din;
                 dinv_tcam   [i] = dinv;
                 add_tcam    [i] = add[8:0];
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
              CU0_M28CAMSLL256Y256CR6022VTES35VLMQBSIRCG u_cfp_tcam    (
									
									.dout		(dout_tcam[k]),	 
									.doutv		(doutv_tcam[k]), 
									.so		(),		 
									.matchout	(matchout[(k*256) +:256]), 
									
									.clk		(clk),		 
									.add		(add_tcam[k]),	 
									.cs		(cs_tcam[k]),	 
									.we		(we_tcam[k]),	 
									.din		(din_tcam[k]),	 
									.dinm		({256{1'b1}}),	 
									.dinv		(dinv_tcam[k]),	 
									.resetb		(resetb_tcam[k]), 
									.ce		(ce_tcam[k]),	 
									.lvm		(lvm ),		 
									.mlvm		(mlvm ),	 
									.mrdten		(mrdten ),	 
									.rds		({1{1'b0}}),	 
									.byp		({1{1'b0}}),	 
									.ovstb		(ovstb),	 
									.s_rf		({16{1'b0}}),	 
									.s_cf		({16{1'b0}}),	 
									.se		({1{1'b0}}),	 
									.si		({5{1'b0}}),	 
									.tm		(tm));		 
           end
           
        end : tcam1024x256b

        {32'd1, 32'd256, 32'd256} : begin : tcam256x256b

           

           CU0_M28CAMSLL256Y256CR6022VTES35VLMQBSIRCG u_slicm_tcam (
								    
								    .dout		(dout),		 
								    .doutv		(doutv),	 
								    .so			(),		 
								    .matchout		(matchout[255:0]),
								    
								    .clk		(clk),
								    .add		(add),		 
								    .cs			(cs),		 
								    .we			(we),		 
								    .din		(din),		 
								    .dinm		({256{1'b1}}),	 
								    .dinv		(dinv),		 
								    .resetb		(resetb),
								    .ce			(ce),
								    .lvm		(lvm),
								    .mlvm		(mlvm),
								    .mrdten		(mrdten),
								    .rds		({1{1'b0}}),	 
								    .byp		({1{1'b0}}),	 
								    .ovstb		(ovstb),
								    .s_rf		({16{1'b0}}),	 
								    .s_cf		({16{1'b0}}),	 
								    .se			({1{1'b0}}),	 
								    .si			({5{1'b0}}),	 
								    .tm			(tm[19:0]));
           
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
                 ce_tcam     [i] = ce;
                 din_tcam    [i] = din;
                 dinv_tcam   [i] = dinv;
                 add_tcam    [i] = add[8:0];
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
              CU0_M28CAMSLL256Y192CR6022VTES35VLMQBSIRCG u_cfp_tcam    
                  (
		   
		   .dout		(dout_tcam[k]),		 
		   .doutv		(doutv_tcam[k]),	 
		   .so			(),			 
		   .matchout		(matchout[(k*256) +:256]), 
		   
		   .clk			(clk),			 
		   .add			(add_tcam[k]),		 
		   .cs			(cs_tcam[k]),		 
		   .we			(we_tcam[k]),		 
		   .din			(din_tcam[k]),		 
		   .dinm		({192{1'b1}}),		 
		   .dinv		(dinv_tcam[k]),		 
		   .resetb		(resetb_tcam[k]),	 
		   .ce			(ce_tcam[k]),		 
		   .lvm			(lvm ),			 
		   .mlvm		(mlvm ),		 
		   .mrdten		(mrdten ),		 
		   .rds			({1{1'b0}}),		 
		   .byp			({1{1'b0}}),		 
		   .ovstb		(ovstb),		 
		   .s_rf		({16{1'b0}}),		 
		   .s_cf		({16{1'b0}}),		 
		   .se			({1{1'b0}}),		 
		   .si			({5{1'b0}}),		 
		   .tm			(tm));			 
           end

        end : tcam1024x192b
	    
        default : begin : tcamDxWb 
           
        end : tcamDxWb
        
      endcase
      
   endgenerate
   
endmodule





