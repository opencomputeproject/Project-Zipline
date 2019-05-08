/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/








`include "cr_lz77_comp.vh"

module cr_lz77_comp_tile_x8
  #(
    parameter TILE_DEPTH     = (`OFFSETS_PER_TILE / 8),
    parameter IN_BYTES       = `IN_BYTES,
    parameter TRUNC_NUM      = `TRUNC_NUM_V3
    )
   (
   
   lz77_tile_shift_data_out, lz77_tile_shift_data_out_vld,
   ti_cl_fwd_therm, ti_cl_offset, ti_cl_len4_ind, ti_cl_len5_6_ind,
   
   clk, rst_n, shift_start_phase, lz77_tile_shift_data,
   lz77_tile_shift_data_vld, lz77_tile_prefix_data,
   lz77_tile_prefix_data_vld, scramble_enb, shift_en, input_en,
   prefix_en, me_tile_enable, lz77_tile_data, lz77_tile_data_vld,
   cl_ti_cont_phases, cl_ti_ongoing_cont_phases, cl_ti_dmw_cont,
   cl_ti_force_done, cl_ti_clr_valid
   );
   
   localparam LOG_TILE_DEPTH = $clog2(`OFFSETS_PER_TILE);
   localparam LONGL          = 13;
   localparam SHIFT_MULT     = `CR_LZ77_TILE_X8_SHIFT_MULT;

   input                                        clk;
   input 					rst_n;

   input [$clog2(SHIFT_MULT)-1:0]               shift_start_phase;

   
   input [IN_BYTES*8-1:0] 			lz77_tile_shift_data;
   input [IN_BYTES-1:0] 			lz77_tile_shift_data_vld;
   output reg [IN_BYTES*8-1:0] 			lz77_tile_shift_data_out;     
   output reg [IN_BYTES-1:0] 			lz77_tile_shift_data_out_vld; 

   
   input [IN_BYTES*8-1:0] 			lz77_tile_prefix_data;
   input [IN_BYTES-1:0] 			lz77_tile_prefix_data_vld;

   
   input                                        scramble_enb;
   input 					shift_en;
   input 					input_en;
   input 					prefix_en;
   input 					me_tile_enable;
  

   input [IN_BYTES*8-1:0] 			lz77_tile_data;
   input [IN_BYTES-1:0] 			lz77_tile_data_vld;

   input [3:0] 					cl_ti_cont_phases;
   input [3:0] 					cl_ti_ongoing_cont_phases;
   input [5:0] 					cl_ti_dmw_cont;
   input 					cl_ti_force_done;
   
   input 					cl_ti_clr_valid;
   
   output [TRUNC_NUM-1:0][LONGL-1:0] 		ti_cl_fwd_therm;
   output [TRUNC_NUM-1:0][LOG_TILE_DEPTH-1:0] 	ti_cl_offset;
   output [3:0] 				ti_cl_len4_ind;
   output [2:0] 				ti_cl_len5_6_ind;
   
`ifdef SHOULD_BE_EMPTY
    
    
`endif

`ifdef NO_PARAMETERIZED_TILE

   wire 					clr_valid;
   wire 					ti_lpo_cont_r;
   wire 					ti_lpo_cont;
   wire [3:0] 					ti_lpo_dmw_cont;
   
   wire [TILE_DEPTH-1:0][3:0] 			lpo_ti_valid_phase;
   wire [TILE_DEPTH-1:0][11:0] 			lpo_ti_fwd_therm;
   wire [TILE_DEPTH-1:0][2:0] 			lpo_ti_offset;
   wire [TILE_DEPTH-1:0][3:0] 			lpo_ti_len4_ind;
   wire [TILE_DEPTH-1:0][2:0] 			lpo_ti_len5_6_ind;
   
   
   
   logic [TILE_DEPTH:0][IN_BYTES-1:0] 		sdi_valid;
   logic [TILE_DEPTH:0][IN_BYTES-1:0][7:0] 	sdi;
   logic [TILE_DEPTH-1:0][5:0] 			bmi;
   logic [IN_BYTES-1:0][7:0] 			input_data;
   logic [IN_BYTES-1:0] 			input_valid;
   

   wire [TILE_DEPTH-1:0][IN_BYTES-1:0] 		sdo_valid;
   wire [TILE_DEPTH-1:0][IN_BYTES-1:0][7:0] 	sdo;
   wire [TILE_DEPTH:0][5:0] 			bmo;
   
   wire 					shift_en_r;
   wire 					input_en_r;
 
   wire [IN_BYTES*8-1:0] 			lz77_tile_data_r;
   wire [IN_BYTES-1:0] 				lz77_tile_data_vld_r;
   wire [IN_BYTES*8-1:0] 			mux_data_r;
   wire [IN_BYTES-1:0] 				mux_data_vld_r;

   logic                                        clk_hb;
   logic                                        clk_lpo;

   
   
   

   
   
   
   always @ (*) begin
      sdi_valid[0]   = mux_data_vld_r;
      sdi[0]         = mux_data_r;

      for (int ofst=0; ofst<TILE_DEPTH; ofst = ofst+1) begin
	 bmi[ofst]         = bmo[ofst+1];
	 sdi_valid[ofst+1] = sdo_valid[ofst];
	 sdi[ofst+1]       = sdo[ofst];
      end

      input_data = lz77_tile_data_r;
      input_valid = lz77_tile_data_vld_r;

      lz77_tile_shift_data_out = sdo[TILE_DEPTH-1];
      lz77_tile_shift_data_out_vld = sdo_valid[TILE_DEPTH-1];
   end

   genvar idx;
   generate 
      for (idx=0; idx<TILE_DEPTH; idx = idx+1) begin : gen_lpo_x8
	 cr_lz77_comp_lpo_x8 lpo_x8
	   (
	    
            .clk_hb                     (clk_hb),
	    .clk                        (clk_lpo),
	    .rst_n                      (rst_n),
	    .input_data                 (input_data),
	    .input_valid                (input_valid),
	    .sdi_valid                  (sdi_valid[idx]),
	    .clr_valid                  (clr_valid),
	    .sdi                        (sdi[idx]),
	    .shift_en                   (shift_en_r),
	    .input_en                   (input_en_r),
	    .ti_lpo_cont                (ti_lpo_cont),
	    .ti_lpo_cont_r              (ti_lpo_cont_r),
	    .ti_lpo_dmw_cont            (ti_lpo_dmw_cont),
	    .bmi                        (bmi[idx]),
	    
	    .sdo_valid                  (sdo_valid[idx]),
	    .sdo                        (sdo[idx]),
	    .bmo                        (bmo[idx]),
	    .lpo_ti_valid_phase         (lpo_ti_valid_phase[idx]),
	    .lpo_ti_fwd_therm           (lpo_ti_fwd_therm[idx]),
	    .lpo_ti_offset              (lpo_ti_offset[idx]),
	    .lpo_ti_len4_ind            (lpo_ti_len4_ind[idx]),
	    .lpo_ti_len5_6_ind          (lpo_ti_len5_6_ind[idx])
	    );
      end
   endgenerate
      
   
   
   cr_lz77_comp_tec_x3 tec_x3
     (
      
      .clk                        (clk),
      .rst_n                      (rst_n),
      .input_data                 (input_data),
      .input_valid                (input_valid),
      .sdi_valid                  (sdi_valid[TILE_DEPTH]),
      .clr_valid                  (clr_valid),
      .sdi                        (sdi[TILE_DEPTH]),
      .shift_en                   (shift_en_r),
      
      .bmo                        (bmo[TILE_DEPTH])
      );


   
   
   
   cr_lz77_comp_lpt_x8
     #(
       .TILE_DEPTH   (TILE_DEPTH)
       )
   lpt_x8
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
      .ti_cl_len5_6_ind                   (ti_cl_len5_6_ind),
      
      
      .lpo_ti_valid_phase                 (lpo_ti_valid_phase),
      .lpo_ti_fwd_therm                   (lpo_ti_fwd_therm),
      .lpo_ti_offset                      (lpo_ti_offset),
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

      .clk_hb                             (clk_hb),
      .clk_lpo                            (clk_lpo)
      );

`else
   
   cr_lz77_comp_tile_xN
     #(
       .LPOS_PER_TILE   (`OFFSETS_PER_TILE / 8),
       .OFFSETS_PER_LPO (8),
       .IN_BYTES  (IN_BYTES),
       .TRUNC_NUM (TRUNC_NUM),
       .SHIFT_MULT (SHIFT_MULT)
       )

   tile_xN
     (
      
      .lz77_tile_shift_data_out         (lz77_tile_shift_data_out[IN_BYTES*8-1:0]),
      .lz77_tile_shift_data_out_vld     (lz77_tile_shift_data_out_vld[IN_BYTES-1:0]),
      .ti_cl_fwd_therm                  (ti_cl_fwd_therm),
      .ti_cl_offset                     (ti_cl_offset),
      .ti_cl_len4_ind                   (ti_cl_len4_ind[3:0]),
      .ti_cl_len5_6_ind                 (ti_cl_len5_6_ind[2:0]),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .shift_start_phase                (shift_start_phase[$clog2(SHIFT_MULT)-1:0]),
      .lz77_tile_shift_data             (lz77_tile_shift_data[IN_BYTES*8-1:0]),
      .lz77_tile_shift_data_vld         (lz77_tile_shift_data_vld[IN_BYTES-1:0]),
      .lz77_tile_prefix_data            (lz77_tile_prefix_data[IN_BYTES*8-1:0]),
      .lz77_tile_prefix_data_vld        (lz77_tile_prefix_data_vld[IN_BYTES-1:0]),
      .scramble_enb                     (scramble_enb),
      .shift_en                         (shift_en),
      .input_en                         (input_en),
      .prefix_en                        (prefix_en),
      .me_tile_enable                   (me_tile_enable),
      .lz77_tile_data                   (lz77_tile_data[IN_BYTES*8-1:0]),
      .lz77_tile_data_vld               (lz77_tile_data_vld[IN_BYTES-1:0]),
      .cl_ti_cont_phases                (cl_ti_cont_phases[3:0]),
      .cl_ti_ongoing_cont_phases        (cl_ti_ongoing_cont_phases[3:0]),
      .cl_ti_dmw_cont                   (cl_ti_dmw_cont[5:0]),
      .cl_ti_force_done                 (cl_ti_force_done),
      .cl_ti_clr_valid                  (cl_ti_clr_valid));

`endif 

endmodule 







