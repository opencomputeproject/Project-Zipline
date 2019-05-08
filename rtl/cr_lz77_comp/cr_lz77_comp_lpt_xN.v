/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


`include "cr_lz77_comp.vh"

module cr_lz77_comp_lpt_xN
  #(
    parameter IN_BYTES        = `IN_BYTES,   
    parameter TRUNC_NUM       = `TRUNC_NUM_V3,      
    parameter LONGL           = `LONGL_V3,
    parameter LPOS_PER_TILE   = (`OFFSETS_PER_TILE / 8),
    parameter OFFSETS_PER_LPO = 8
    )
   (
   
   ti_cl_fwd_therm, ti_cl_offset, ti_cl_len4_ind, ti_cl_len5_6_ind,
   mux_data_r, mux_data_vld_r, ti_lpo_cont, ti_lpo_cont_r,
   ti_lpo_dmw_cont, clr_valid, shift_en_r, input_en_r,
   lz77_tile_data_r, lz77_tile_data_vld_r, clk_lpo,
   
   clk, rst_n, lz77_tile_shift_data, lz77_tile_shift_data_vld,
   lz77_tile_prefix_data, lz77_tile_prefix_data_vld, lz77_tile_data,
   lz77_tile_data_vld, shift_en, input_en, prefix_en, me_tile_enable,
   cl_ti_cont_phases, cl_ti_ongoing_cont_phases, cl_ti_dmw_cont,
   cl_ti_force_done, cl_ti_clr_valid, lpo_ti_valid_phase,
   lpo_ti_fwd_therm, lpo_ti_offset, lpo_ti_len4_ind,
   lpo_ti_len5_6_ind
   );


   localparam LOG_OFFPT = $clog2(`OFFSETS_PER_TILE);
   localparam LOG_OFFPL = $clog2(OFFSETS_PER_LPO);
   
   

   
   input                                                  clk;
   input 						  rst_n;
   
   input [IN_BYTES-1:0][7:0] 				  lz77_tile_shift_data;
   input [IN_BYTES-1:0] 				  lz77_tile_shift_data_vld;
   input [IN_BYTES-1:0][7:0] 				  lz77_tile_prefix_data;
   input [IN_BYTES-1:0] 				  lz77_tile_prefix_data_vld;
  
   input [IN_BYTES-1:0][7:0] 				  lz77_tile_data;
   input [IN_BYTES-1:0] 				  lz77_tile_data_vld;
   
   
   input 						  shift_en;
   input 						  input_en;
   input 						  prefix_en;
   input 						  me_tile_enable;
   
   input [3:0] 						  cl_ti_cont_phases;
   input [3:0] 						  cl_ti_ongoing_cont_phases;
   input [5:0] 						  cl_ti_dmw_cont;
   input 						  cl_ti_force_done;
   
   input 						  cl_ti_clr_valid;   

   
   output [TRUNC_NUM-1:0][LONGL-1:0] 			  ti_cl_fwd_therm;
   output [TRUNC_NUM-1:0][LOG_OFFPT-1:0] 		  ti_cl_offset;
   output reg [3:0] 					  ti_cl_len4_ind;
   output reg [2:0] 					  ti_cl_len5_6_ind;
   
   input [LPOS_PER_TILE-1:0][3:0]                         lpo_ti_valid_phase;   
   input [LPOS_PER_TILE-1:0][11:0] 			  lpo_ti_fwd_therm; 
   input [LPOS_PER_TILE-1:0][LOG_OFFPL-1:0]               lpo_ti_offset;
   input [LPOS_PER_TILE-1:0][3:0]                         lpo_ti_len4_ind;
   input [LPOS_PER_TILE-1:0][2:0]                         lpo_ti_len5_6_ind;
 				  
   
   output reg [IN_BYTES-1:0][7:0] 			  mux_data_r;
   output reg [IN_BYTES-1:0] 				  mux_data_vld_r;
   
   output reg 						  ti_lpo_cont;
   output reg 						  ti_lpo_cont_r;
   output reg [3:0] 					  ti_lpo_dmw_cont;
  
   output reg 						  clr_valid ;
   output reg 						  shift_en_r;
   output reg 						  input_en_r;
   output reg [IN_BYTES-1:0][7:0] 			  lz77_tile_data_r;
   output reg [IN_BYTES-1:0] 				  lz77_tile_data_vld_r;
   
   
   output logic                                           clk_lpo;
 
   
   logic [TRUNC_NUM-1:0][LPOS_PER_TILE/2-1:0][LONGL-1:0] 	  fwd_therm_stage0;
   logic [LPOS_PER_TILE/2-1:0] 				  fwd_sel_stage0;  
   logic 						  offset_stage0_sel;
   logic [TRUNC_NUM-1:0][LPOS_PER_TILE/2-1:0][LOG_OFFPL:0] offset_stage0;   
   logic 						  prefix_en_r;
   logic [3:0] 						  cont_phases_r;
   logic [3:0] 						  cont_phases_2r;
   logic [5:0] 						  cl_ti_dmw_cont_r;
   logic 						  cl_ti_force_done_r;
   logic [5:0] 						  cluster_cont_phases;
   logic [3:0] 						  cluster_cont_valid_phases;
   logic [3:0] 						  ongoing_cont_r;
   logic 						  me_tile_enable_r;
   
   logic [2:0] 						  init_cnt;
   logic 						  init_stb;
   assign init_stb = init_cnt != 0;
   logic 						  lpo_clk_enable_r;
   
   
   wire                                                   hb_clk_enable = (shift_en_r & mux_data_vld_r[3]);  
   
   
   
   wire lpo_clk_enable = hb_clk_enable | lpo_clk_enable_r | init_stb;   
   cr_clk_gate dont_touch_clk_gate_lpo ( .i0(1'b0), .i1(lpo_clk_enable), .phi(clk), .o(clk_lpo) );

   always @ (*) begin    
      if (prefix_en_r)          
	begin
	   mux_data_r     = lz77_tile_prefix_data ;
	   mux_data_vld_r = lz77_tile_prefix_data_vld & {4{me_tile_enable_r}};
	end
      else
	begin                   
	   mux_data_r     = lz77_tile_shift_data;
	   mux_data_vld_r = lz77_tile_shift_data_vld & {4{me_tile_enable_r}};
	end

      
      
      for (int idx=0; idx<LPOS_PER_TILE/2; idx = idx + 1) begin

	 
         fwd_sel_stage0[idx] =  |(lpo_ti_fwd_therm[2*idx+1][10:0] & ~lpo_ti_fwd_therm[2*idx][10:0]);
	 
         for (int phase=0; phase<TRUNC_NUM; phase=phase+1) 
	   begin
	      offset_stage0_sel = lpo_ti_valid_phase[2*idx+1][phase] & ( fwd_sel_stage0[idx] | ~lpo_ti_valid_phase[2*idx][phase]);
	      
	      if (offset_stage0_sel==1'b1)
		offset_stage0[phase][idx] = {1'b1,lpo_ti_offset[2*idx+1]} ;
	      else
		offset_stage0[phase][idx] = {1'b0,lpo_ti_offset[2*idx  ]};
	      
	      
	      fwd_therm_stage0[phase][idx] = { {LONGL-1{lpo_ti_valid_phase[2*idx+1][phase]}} & lpo_ti_fwd_therm[2*idx+1], lpo_ti_valid_phase[2*idx+1][phase] } |
                                             { {LONGL-1{lpo_ti_valid_phase[2*idx  ][phase]}} & lpo_ti_fwd_therm[2*idx  ], lpo_ti_valid_phase[2*idx  ][phase] };
           end
      end 
      
      
      ti_cl_len4_ind   = 4'd0;
      ti_cl_len5_6_ind  = 3'd0;
      
      for (int i=0; i<LPOS_PER_TILE; i = i + 1)
	begin
	   ti_cl_len4_ind   = ti_cl_len4_ind   | lpo_ti_len4_ind[i];
	   ti_cl_len5_6_ind = ti_cl_len5_6_ind  | lpo_ti_len5_6_ind[i];
	end

      
      
      cluster_cont_phases = {cont_phases_2r[3:0],cont_phases_r[3:2]};

      ti_lpo_dmw_cont  = cl_ti_dmw_cont_r[5:2];
      
      ti_lpo_cont      = (
			  
			  
			  (  ( cluster_cont_phases > cl_ti_dmw_cont_r) && |cl_ti_dmw_cont_r) ||
			  
			  ( |( cluster_cont_phases & cl_ti_dmw_cont_r) && |cl_ti_dmw_cont_r) ||
			  
			  ( |(cluster_cont_valid_phases & ongoing_cont_r) && 
			    ti_lpo_cont_r && !cl_ti_force_done_r)
			  );
   end 
   
    
   logic input_en_rr;

   
   
   
   always_ff@(posedge clk_lpo or negedge rst_n) begin
      if (!rst_n) begin
         lz77_tile_data_r <= {IN_BYTES{8'b0}};
      end
      else begin
         lz77_tile_data_r <= lz77_tile_data;
      end
   end

   always @ (posedge clk or negedge rst_n) begin
      if (!rst_n) begin
	 clr_valid             <= 1'b1;
	 
	 cont_phases_r         <= 4'b0;
	 cont_phases_2r        <= 4'b0;
	 cl_ti_dmw_cont_r      <= 6'b0;
	 input_en_r            <= 1'b1;
         input_en_rr           <= 1'b1;
	 lz77_tile_data_vld_r  <= {IN_BYTES{1'b0}};
	 prefix_en_r           <= 1'b0;
	 shift_en_r            <= 1'b0;
	 ti_lpo_cont_r         <= 1'b0;
	 cluster_cont_valid_phases <= 4'b0;
	 ongoing_cont_r           <= 4'h0;
	 me_tile_enable_r      <= 1'b0;
	 cl_ti_force_done_r    <= 1'b0;
         init_cnt <= 7;
	 
	 
         
         lpo_clk_enable_r <= 0;
         
      end
      else begin
	 
	 prefix_en_r              <= prefix_en;
	 shift_en_r               <= shift_en | prefix_en ;
	 input_en_r               <= input_en | init_stb;
         input_en_rr              <= input_en_r;
	 clr_valid                <= cl_ti_clr_valid | init_stb; 
	 lz77_tile_data_vld_r     <= lz77_tile_data_vld;
	 me_tile_enable_r         <= me_tile_enable;
	 
	 if (init_cnt != 0) begin
	    init_cnt <= init_cnt - 1;
	 end
         
	 if (hb_clk_enable | clr_valid)
	   lpo_clk_enable_r       <= 1;
	 else if (!input_en_rr)
	   lpo_clk_enable_r       <= 0;

	 if (input_en_rr) begin
	    cont_phases_r         <= cl_ti_cont_phases;
	    cont_phases_2r        <= cont_phases_r;
	    cl_ti_dmw_cont_r      <= cl_ti_dmw_cont;
	    ongoing_cont_r        <= cl_ti_ongoing_cont_phases;
	    cl_ti_force_done_r    <= cl_ti_force_done;
	    
	    if (|cl_ti_dmw_cont_r) begin
	       if ( cluster_cont_phases > cl_ti_dmw_cont_r) begin
		  cluster_cont_valid_phases <= cl_ti_dmw_cont_r[5:2] | {cl_ti_dmw_cont_r[1:0],2'b00};
	       end
	       else begin
		  cluster_cont_valid_phases <= (cluster_cont_phases[5:2] & cl_ti_dmw_cont_r[5:2]) |
					       ({cluster_cont_phases[1:0],2'b0} & {cl_ti_dmw_cont_r[1:0],2'b0});
	       end
	    end
	    
	    ti_lpo_cont_r         <= ti_lpo_cont;
	 end 

      end 
   end 
   
   
   
   genvar phase_num;
   
   generate 
      
      
      
      
      
      for (phase_num=0; phase_num<TRUNC_NUM; phase_num=phase_num+1) 
	 begin : gen_match_stree
	    
	    cr_lz77_comp_stree
 	      #(
 		.OFFSETS (LPOS_PER_TILE/2),
 		.T_WIDTH (LONGL),
 		.T_MASK  (1),
 		.OI_WIDTH(LOG_OFFPL+1)
 		)
 	    match_stree
 	      (
 	       .therm_in    (fwd_therm_stage0 [phase_num]),          
 	       .offset_in   (offset_stage0    [phase_num]),          
 	       .therm_out   (ti_cl_fwd_therm  [phase_num]),          
 	       .offset_out  (ti_cl_offset     [phase_num])           
 		 );
       end 
    endgenerate
   
endmodule 







