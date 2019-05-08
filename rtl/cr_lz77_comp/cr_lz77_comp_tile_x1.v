/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "ccx_std.vh"
`include "messages.vh"
`include "cr_lz77_comp.vh"

module cr_lz77_comp_tile_x1
  #(
    parameter TILE_DEPTH     = `OFFSETS_PER_TILE,
    parameter IN_BYTES       = `IN_BYTES,
    parameter TRUNC_NUM      = `TRUNC_NUM_V3,
    parameter MTF_NUM        = `MTF_NUM,
    parameter TILE_MTF_NUM   = `TILE_MTF_NUM,
    parameter LONGL          = `LONGL_V3,
    parameter FIRST_TILE     = 1
    )
   (
   
   lz77_tile_shift_data_out, lz77_tile_shift_data_out_vld,
   ti_cl_fwd_therm, ti_cl_offset, ti_cl_len4_ind, ti_cl_len5_6_ind,
   clt0_me_mtf_offset, clt0_me_mtf_phase, clt0_me_mtf_fwd_therm,
   
   clk, rst_n, shift_start_phase, lz77_tile_shift_data,
   lz77_tile_shift_data_vld, lz77_tile_prefix_data,
   lz77_tile_prefix_data_vld, scramble_enb, shift_en, input_en,
   prefix_en, me_tile_enable, lz77_tile_data, lz77_tile_data_vld,
   cl_ti_cont_phases, cl_ti_ongoing_cont_phases, cl_ti_dmw_cont,
   cl_ti_force_done, cl_ti_clr_valid, me_cl_mtf_list,
   me_cl_mtf_list_valid, ph4_mask, ph3_mask, ph2_mask, ph1_mask
   );
   
   
   localparam LOG_TILE_DEPTH = $clog2(TILE_DEPTH);
   localparam SHIFT_MULT     = `CR_LZ77_TILE_X1_SHIFT_MULT;
   

   input                                          clk;
   input 					  rst_n;

   input [$clog2(SHIFT_MULT)-1:0]                 shift_start_phase;
   
   
   input [IN_BYTES*8-1:0] 			  lz77_tile_shift_data;
   input [IN_BYTES-1:0] 			  lz77_tile_shift_data_vld;
   output reg [IN_BYTES*8-1:0] 			  lz77_tile_shift_data_out;     
   output reg [IN_BYTES-1:0] 			  lz77_tile_shift_data_out_vld; 
   
   
   input [IN_BYTES*8-1:0] 			  lz77_tile_prefix_data;
   input [IN_BYTES-1:0] 			  lz77_tile_prefix_data_vld;
   
   
   input                                          scramble_enb;
   input 					  shift_en;
   input 					  input_en;
   input 					  prefix_en;
   input 					  me_tile_enable;
   
   
   input [IN_BYTES*8-1:0] 			  lz77_tile_data;
   input [IN_BYTES-1:0] 			  lz77_tile_data_vld;
   
   input [3:0] 					  cl_ti_cont_phases;
   input [3:0] 					  cl_ti_ongoing_cont_phases;
   input [5:0] 					  cl_ti_dmw_cont;
   input 					  cl_ti_force_done;
   
   input 					  cl_ti_clr_valid;
   
   output [TRUNC_NUM-1:0][LONGL-1:0] 		  ti_cl_fwd_therm;
   output [TRUNC_NUM-1:0][LOG_TILE_DEPTH-1:0] 	  ti_cl_offset;
   output [3:0] 				  ti_cl_len4_ind;
   output [2:0] 				  ti_cl_len5_6_ind;
   
   
   input [MTF_NUM-1:0][LOG_TILE_DEPTH-1:0] 	  me_cl_mtf_list ;
   input [MTF_NUM-1:0] 				  me_cl_mtf_list_valid;
   output [TILE_MTF_NUM-1:0][LOG_TILE_DEPTH-1:0]  clt0_me_mtf_offset;
   output [TILE_MTF_NUM-1:0][3:0] 		  clt0_me_mtf_phase;
   output [TILE_MTF_NUM-1:0][11:0] 		  clt0_me_mtf_fwd_therm;
   
   input [LONGL-1:0] 				  ph4_mask;
   input [LONGL-1:0] 				  ph3_mask;
   input [LONGL-1:0] 				  ph2_mask;
   input [LONGL-1:0] 				  ph1_mask;
   
   
`ifdef SHOULD_BE_EMPTY
    
    
`endif
   wire 					clr_valid;
   wire 					ti_lpo_cont_r;
   wire 					ti_lpo_cont;
   wire [3:0] 					ti_lpo_dmw_cont;
   
   wire [TILE_DEPTH-1:0][3:0] 			lpo_ti_valid_phase;
   wire [TILE_DEPTH-1:0][11:0] 			lpo_ti_fwd_therm;
   wire [TILE_DEPTH-1:0][3:0] 			lpo_ti_len4_ind;
   wire [TILE_DEPTH-1:0][2:0] 			lpo_ti_len5_6_ind;
   
   
   logic [IN_BYTES-1:0]                         sdi_valid;
   logic [IN_BYTES-1:0][7:0]                    sdi;
   logic [IN_BYTES-1:0][7:0]                    input_data;
   logic [IN_BYTES-1:0]                         input_valid;
   

   wire                                         sdo_valid;
   wire [IN_BYTES-1:0][7:0]                     sdo;
   

   logic [TILE_DEPTH-1:0][3:0] 			bm;
   logic [TILE_DEPTH-1:0][3:0]                  bm_mod;
   
   wire 					shift_en_r;
   wire 					input_en_r;
 
   wire [IN_BYTES*8-1:0] 			lz77_tile_data_r;
   wire [IN_BYTES-1:0] 				lz77_tile_data_vld_r;
   wire [IN_BYTES*8-1:0] 			mux_data_r;
   wire [IN_BYTES-1:0] 				mux_data_vld_r;

   logic                                        clk_lpo;
   
   

   logic                                        scramble_enb_r;
   always_ff@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         scramble_enb_r <= 1'b0;
      end
      else begin
         scramble_enb_r <= scramble_enb;
      end
   end

   

   
   
   
   
   generate
      if (FIRST_TILE) begin : first_tile_sdi_valid
         assign sdi_valid   = mux_data_vld_r;
      end
      else begin : non_first_tile_sdi_valid
         
         
         assign sdi_valid   = {IN_BYTES{mux_data_vld_r[IN_BYTES-1]}};
         `ASSERT_PROPERTY((mux_data_vld_r==0) || (mux_data_vld_r=={IN_BYTES{1'b1}})) else `ERROR("always expect %0d bytes shifted at a time: mux_data_vld_r=0x%h", IN_BYTES, mux_data_vld_r);
      end
   endgenerate
   always @ (*) begin
      sdi         = mux_data_r;

      input_data = lz77_tile_data_r;
      input_valid = lz77_tile_data_vld_r;

      lz77_tile_shift_data_out = sdo;
      lz77_tile_shift_data_out_vld = {4{sdo_valid}};
   end

   
   assign bm_mod = {bm[TILE_DEPTH-1:1], FIRST_TILE?4'b0:bm[0]};

   genvar idx;
   generate 
      
      for (idx=0; idx<TILE_DEPTH; idx = idx+1) begin : gen_lpo
	 cr_lz77_comp_lpo_x1 lpo_x1
	   (
	    
	    .clk                        (clk_lpo),
	    .input_en                   (input_en_r),
	    .ti_lpo_cont                (ti_lpo_cont),
	    .ti_lpo_cont_r              (ti_lpo_cont_r),
	    .ti_lpo_dmw_cont            (ti_lpo_dmw_cont),
	    .bm                         (bm_mod[idx]),
	    
	    .lpo_ti_valid_phase         (lpo_ti_valid_phase[idx]),
	    .lpo_ti_fwd_therm           (lpo_ti_fwd_therm[idx]),
	    .lpo_ti_len4_ind            (lpo_ti_len4_ind[idx]),
	    .lpo_ti_len5_6_ind          (lpo_ti_len5_6_ind[idx])
	    );
      end

   endgenerate

   
   
   
   cr_lz77_comp_lpt_x1
     #(
       .TILE_DEPTH   (TILE_DEPTH)
       )
   lpt_x1
     (
      .clk                                (clk),
      .rst_n                              (rst_n),

      .lz77_tile_shift_data               (lz77_tile_shift_data),
      .lz77_tile_shift_data_vld           (lz77_tile_shift_data_vld),
      .lz77_tile_prefix_data              (lz77_tile_prefix_data),
      .lz77_tile_prefix_data_vld          (lz77_tile_prefix_data_vld),

      .lz77_tile_data                     (lz77_tile_data),
      .lz77_tile_data_vld                 (lz77_tile_data_vld),

      
      .shift_en                           (shift_en),
      .input_en                           (input_en),
      .prefix_en                          (prefix_en),
      .me_tile_enable                     (me_tile_enable),

      .cl_ti_cont_phases                  (cl_ti_cont_phases),
      .cl_ti_ongoing_cont_phases          (cl_ti_ongoing_cont_phases),
      .cl_ti_dmw_cont                     (cl_ti_dmw_cont),
      .cl_ti_force_done                   (cl_ti_force_done),
      .cl_ti_clr_valid                    (cl_ti_clr_valid),

      
      .ti_cl_fwd_therm                    (ti_cl_fwd_therm),
      .ti_cl_offset                       (ti_cl_offset),
      .ti_cl_len4_ind                     (ti_cl_len4_ind),
      .ti_cl_len5_6_ind                    (ti_cl_len5_6_ind),
      
      .lpo_ti_valid_phase                 (lpo_ti_valid_phase),
      .lpo_ti_fwd_therm                   (lpo_ti_fwd_therm),
      .lpo_ti_len4_ind                    (lpo_ti_len4_ind),
      .lpo_ti_len5_6_ind                  (lpo_ti_len5_6_ind),
      
      .mux_data_r                         (mux_data_r),
      .mux_data_vld_r                     (mux_data_vld_r),
      
      .ti_lpo_cont                        (ti_lpo_cont),
      .ti_lpo_cont_r                      (ti_lpo_cont_r),
      .ti_lpo_dmw_cont                    (ti_lpo_dmw_cont),
      
      .clr_valid                          (clr_valid),
      .shift_en_r                         (shift_en_r),
      .input_en_r                         (input_en_r),
      .lz77_tile_data_r                   (lz77_tile_data_r),
      .lz77_tile_data_vld_r               (lz77_tile_data_vld_r),

      
      .me_cl_mtf_list                     (me_cl_mtf_list),
      .me_cl_mtf_list_valid               (me_cl_mtf_list_valid),
      .clt0_me_mtf_offset                 (clt0_me_mtf_offset),
      .clt0_me_mtf_phase                  (clt0_me_mtf_phase),
      .clt0_me_mtf_fwd_therm              (clt0_me_mtf_fwd_therm),
      .ph4_mask                           (ph4_mask),
      .ph3_mask                           (ph3_mask),
      .ph2_mask                           (ph2_mask),
      .ph1_mask                           (ph1_mask),

      .clk_lpo                            (clk_lpo)
      );

   cr_lz77_comp_hb_xN
     #(.LPOS_PER_TILE (TILE_DEPTH),
       .OFFSETS_PER_LPO (1),
       .SHIFT_MULT (SHIFT_MULT),
       .FIRST_TILE (FIRST_TILE)
       )
   hb_xN
     (
      .sdo_valid                        (sdo_valid),
      .sdo                              (sdo),
      .best_new_offset                  (),
      .best_new_offset_bm               (),
      .prev_sel_offset_bm               (bm),
      
      .scramble_enb                     (scramble_enb_r),
      .clk_hb                           (clk),
      .clk                              (clk_lpo),
      .shift_start_phase                (shift_start_phase),
      .rst_n                            (rst_n),
      .input_data                       (input_data),
      .input_valid                      (input_valid[3:0]),
      .sdi_valid                        (sdi_valid),
      .clr_valid                        (clr_valid),
      .sdi                              (sdi),
      .shift_en                         (shift_en_r),
      .prev_sel_offset                  ('0));
   

endmodule 









