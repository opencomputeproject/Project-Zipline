/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


`include "cr_lz77_comp.vh"

module cr_lz77_comp_lpt_x1
  #(
    parameter TILE_DEPTH     = `OFFSETS_PER_TILE,
    parameter IN_BYTES       = `IN_BYTES,   
    parameter TRUNC_NUM      = `TRUNC_NUM_V3,      
    parameter LONGL          = `LONGL_V3,
    parameter MTF_NUM        = `MTF_NUM,
    parameter TILE_MTF_NUM   = `TILE_MTF_NUM
    )
   (
   
   ti_cl_fwd_therm, ti_cl_offset, ti_cl_len4_ind, ti_cl_len5_6_ind,
   mux_data_r, mux_data_vld_r, ti_lpo_cont, ti_lpo_cont_r,
   ti_lpo_dmw_cont, clr_valid, shift_en_r, input_en_r,
   lz77_tile_data_r, lz77_tile_data_vld_r, clt0_me_mtf_offset,
   clt0_me_mtf_phase, clt0_me_mtf_fwd_therm, clk_lpo,
   
   clk, rst_n, lz77_tile_shift_data, lz77_tile_shift_data_vld,
   lz77_tile_prefix_data, lz77_tile_prefix_data_vld, lz77_tile_data,
   lz77_tile_data_vld, shift_en, input_en, prefix_en, me_tile_enable,
   cl_ti_cont_phases, cl_ti_ongoing_cont_phases, cl_ti_dmw_cont,
   cl_ti_force_done, cl_ti_clr_valid, lpo_ti_valid_phase,
   lpo_ti_fwd_therm, lpo_ti_len4_ind, lpo_ti_len5_6_ind,
   me_cl_mtf_list, me_cl_mtf_list_valid, ph4_mask, ph3_mask, ph2_mask,
   ph1_mask
   );


   localparam LOG_TILE_DEPTH = $clog2(TILE_DEPTH);
   

   
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
   output [TRUNC_NUM-1:0][LOG_TILE_DEPTH-1:0] 		  ti_cl_offset;
   output reg [3:0] 					  ti_cl_len4_ind;
   output reg [2:0] 					  ti_cl_len5_6_ind;
   
   input [TILE_DEPTH-1:0][3:0] 				  lpo_ti_valid_phase;   
   input [TILE_DEPTH-1:0][11:0] 			  lpo_ti_fwd_therm; 
   input [TILE_DEPTH-1:0][3:0] 				  lpo_ti_len4_ind;
   input [TILE_DEPTH-1:0][2:0] 				  lpo_ti_len5_6_ind;
 				  
   
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
   

   
   input [MTF_NUM-1:0][LOG_TILE_DEPTH-1:0] 		  me_cl_mtf_list ;
   input [MTF_NUM-1:0] 					  me_cl_mtf_list_valid;
   output logic [TILE_MTF_NUM-1:0][LOG_TILE_DEPTH-1:0] 	  clt0_me_mtf_offset;
   output logic [TILE_MTF_NUM-1:0][3:0] 		  clt0_me_mtf_phase;
   output logic [TILE_MTF_NUM-1:0][11:0] 		  clt0_me_mtf_fwd_therm;
   input [LONGL-1:0] 					  ph4_mask;
   input [LONGL-1:0] 					  ph3_mask;
   input [LONGL-1:0] 					  ph2_mask;
   input [LONGL-1:0] 					  ph1_mask;

   
   output logic                                           clk_lpo;
 
   
   logic [TRUNC_NUM-1:0][TILE_DEPTH/2-1:0][LONGL-1:0] 	  fwd_therm_stage0;
   logic [TILE_DEPTH/2-1:0] 				  fwd_sel_stage0;  
   logic [TRUNC_NUM-1:0][TILE_DEPTH/2-1:0] 		  offset_stage0;
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
   logic                                                  init_stb;
   assign init_stb = init_cnt != 0;
   logic 						  lpo_clk_enable_r;
   
   
   wire hb_clk_enable = (shift_en_r & mux_data_vld_r[3]);  
   
   
   
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

      
      
      for (int idx=0; idx<TILE_DEPTH/2; idx = idx + 1) 
	begin 	   
           fwd_sel_stage0[idx] =  |(lpo_ti_fwd_therm[2*idx+1][10:0] & ~lpo_ti_fwd_therm[2*idx][10:0]);
	   
           for (int phase=0; phase<TRUNC_NUM; phase=phase+1) 
	     begin
		offset_stage0[phase][idx] = lpo_ti_valid_phase[2*idx+1][phase] & ( fwd_sel_stage0[idx] | ~lpo_ti_valid_phase[2*idx][phase]);
		
		
		fwd_therm_stage0[phase][idx] = { {LONGL-1{lpo_ti_valid_phase[2*idx+1][phase]}} & lpo_ti_fwd_therm[2*idx+1], lpo_ti_valid_phase[2*idx+1][phase] } |
                                               { {LONGL-1{lpo_ti_valid_phase[2*idx  ][phase]}} & lpo_ti_fwd_therm[2*idx  ], lpo_ti_valid_phase[2*idx  ][phase] };
             end
	end 
      
      
      
      ti_cl_len4_ind   = 4'd0;
      ti_cl_len5_6_ind  = 3'd0;
      
      for (int i=0; i<TILE_DEPTH; i = i + 1)
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
 		.OFFSETS (TILE_DEPTH/2),
 		.T_WIDTH (LONGL),
 		.T_MASK  (1),
 		.OI_WIDTH(1)
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
   

   
   
   
   

   
   
   localparam H = (TILE_MTF_NUM - 4) / 4; 

   logic [TILE_MTF_NUM-1:0][LOG_TILE_DEPTH-1:0]     mtf_list;
   logic [TILE_MTF_NUM-1:0] 			    mtf_list_valid;
   
   logic [TILE_MTF_NUM-1:0][TILE_DEPTH-1:0][3:0]    mtf_per_ofst_phase;   
   logic [TILE_MTF_NUM-1:0][TILE_DEPTH-1:0][11:0]   mtf_per_ofst_fwd_therm; 

   logic [TILE_MTF_NUM-1:0][3:0] 		    mtf_phase;
   logic [TILE_MTF_NUM-1:0][11:0] 		    mtf_fwd_therm;
   logic [TILE_MTF_NUM-1:0][11:0] 		    mtf_mask;

   typedef logic [LOG_TILE_DEPTH-1:0] 		    offset_type;


   always @ (*) begin

      for (int k=0; k<TILE_MTF_NUM; k=k+1) begin

	 for (int ofst=0; ofst<TILE_DEPTH; ofst = ofst+1) begin
	    if ( (mtf_list[k] == offset_type'(ofst)) &&
		 (mtf_list_valid[k])
		 ) begin
	       mtf_per_ofst_fwd_therm[k][ofst] = lpo_ti_fwd_therm[ofst];
	       mtf_per_ofst_phase[k][ofst]     = lpo_ti_valid_phase[ofst];
	    end
	    else begin
	       mtf_per_ofst_fwd_therm[k][ofst] = 12'b0;
	       mtf_per_ofst_phase[k][ofst]     = 4'b0;
	    end
	 end 


	 mtf_phase[k] = 4'b0;
	 mtf_fwd_therm[k] = 12'b0;
	 for (int ofst=0; ofst<TILE_DEPTH; ofst = ofst+1) begin
	    mtf_phase[k] = mtf_phase[k] | mtf_per_ofst_phase[k][ofst];
	    mtf_fwd_therm[k] = mtf_fwd_therm[k] | 
			       mtf_per_ofst_fwd_therm[k][ofst];
	 end

	 case (1'b1)
	   mtf_phase[k][0] : mtf_mask[k] = ph1_mask[LONGL-1:1]; 
	   mtf_phase[k][1] : mtf_mask[k] = ph2_mask[LONGL-1:1]; 
	   mtf_phase[k][2] : mtf_mask[k] = ph3_mask[LONGL-1:1]; 
	   mtf_phase[k][3] : mtf_mask[k] = ph4_mask[LONGL-1:1]; 
	   default         : mtf_mask[k] = 12'hfff;             
	 endcase 

	 
      end 

   end
   

   always @ (posedge clk or negedge rst_n) begin
      if (!rst_n) begin
	 mtf_list              <= {TILE_MTF_NUM{{LOG_TILE_DEPTH{1'b0}}}};
	 mtf_list_valid        <= {TILE_MTF_NUM{1'b0}};
	 clt0_me_mtf_offset    <= {TILE_MTF_NUM{{LOG_TILE_DEPTH{1'b0}}}};
	 clt0_me_mtf_phase     <= {TILE_MTF_NUM{4'b0}};
	 clt0_me_mtf_fwd_therm <= {TILE_MTF_NUM{12'b0}};
      end
      else begin

	 if (input_en_rr) begin
	    
	    
	    
	    
	    for (int p=0; p<MTF_NUM; p=p+1) begin
	       mtf_list[p]       <= ti_cl_offset[p];
	       mtf_list_valid[p] <= ti_cl_fwd_therm[p][0];
	    end
	    
	    for (int k=1; k<H; k=k+1) begin
	       for (int p=0; p<MTF_NUM; p=p+1) begin
		  mtf_list[p+(MTF_NUM*k)]       <= mtf_list[p+(MTF_NUM*(k-1))];
		  mtf_list_valid[p+(MTF_NUM*k)] <= mtf_list_valid[p+(MTF_NUM*(k-1))];
	       end
	    end
	    
	    for (int i=0; i<MTF_NUM; i=i+1) begin
	       mtf_list[i+(TILE_MTF_NUM-4)]       <= me_cl_mtf_list[i];
	       mtf_list_valid[i+(TILE_MTF_NUM-4)] <= me_cl_mtf_list_valid[i];
	    end
	    
	    
	    
	    
	    for (int k=0; k<TILE_MTF_NUM; k=k+1) begin
	       clt0_me_mtf_offset[k]    <= mtf_list[k];
	       clt0_me_mtf_phase[k]     <= mtf_phase[k];
	       clt0_me_mtf_fwd_therm[k] <= mtf_fwd_therm[k] & mtf_mask[k];
	    end
	 end 

      end 
   end 

endmodule 







