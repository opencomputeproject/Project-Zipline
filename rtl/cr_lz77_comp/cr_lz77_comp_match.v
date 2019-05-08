/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/








`include "cr_lz77_comp.vh"
`include "cr_lz77_comp_pkg_include.vh"

module cr_lz77_comp_match
  #(
    parameter TILPC          = `TILES_PER_CLUSTER,
    parameter OFFPT          = `OFFSETS_PER_TILE,
    parameter IN_BYTES       = `IN_BYTES,
    parameter CLUSTERS       = `CLUSTERS,
    parameter TRUNC_NUM      = `TRUNC_NUM_V3,
    parameter LONGL          = `LONGL_V3,
    parameter MTF_NUM        = `MTF_NUM,
    parameter TILE_MTF_NUM   = `TILE_MTF_NUM
    )
   (
   
   me_clt_dmw_cont, me_clt0_mtf_list, me_clt0_mtf_list_valid,
   me_tile_enable, me_clt_max_match_len, me_clt_win_size,
   me_output_type, me_literal, me_ptr_length, me_ptr_offset,
   me_last_output, lec_prc_lz_error,
   
   clk, rst_n, clt_me_offset, clt_me_fwd_therm, clt_me_truncated,
   clt0_me_mtf_offset, clt0_me_mtf_phase, clt0_me_mtf_fwd_therm,
   clt_me_len4_ind, clt_me_len5_6_ind, clt_me_cont, me_last,
   me_literal_data, me_literal_data_valid, me_win_size,
   me_dly_match_win, me_max_match_len, me_isXp9, me_num_mtf
   );
   
`include "cr_lz77_comp_includes.vh"

   localparam OFFPC     = OFFPT * TILPC;            
   localparam OFFPE     = OFFPT * TILPC * CLUSTERS; 
   localparam LOG_OFFPC = $clog2(OFFPC);
   localparam LOG_OFFPE = $clog2(OFFPE);
   localparam LOG_OFFPT = $clog2(OFFPT);

   input 	     clk;
   input 	     rst_n;
   
   
   input [CLUSTERS-1:0][TRUNC_NUM-1:0][LOG_OFFPC-1:0]    clt_me_offset;
   input [CLUSTERS-1:0][TRUNC_NUM-1:0][LONGL-1:0] 	 clt_me_fwd_therm;
   input [CLUSTERS-1:0][TRUNC_NUM-1:0] 			 clt_me_truncated;
   input [TILE_MTF_NUM-1:0][LOG_OFFPT-1:0] 		 clt0_me_mtf_offset;
   input [TILE_MTF_NUM-1:0][TRUNC_NUM-1:0] 		 clt0_me_mtf_phase;
   input [TILE_MTF_NUM-1:0][11:0] 			 clt0_me_mtf_fwd_therm;

   input [CLUSTERS-1:0][3:0] 				 clt_me_len4_ind;
   input [CLUSTERS-1:0][2:0] 				 clt_me_len5_6_ind;
   input [CLUSTERS-1:0] 				 clt_me_cont;

   
   input  						 me_last;
   input [3:0][7:0] 					 me_literal_data;
   input [3:0] 						 me_literal_data_valid;

   input [2:0] 						 me_win_size;
   input [1:0] 						 me_dly_match_win;
   input [1:0] 						 me_max_match_len; 
   input 						 me_isXp9;
   input 						 me_num_mtf;
   
   
   output [CLUSTERS-1:0][5:0] 				 me_clt_dmw_cont;
   output [MTF_NUM-1:0][LOG_OFFPT-1:0] 			 me_clt0_mtf_list;
   output [MTF_NUM-1:0] 				 me_clt0_mtf_list_valid;
   output [CLUSTERS-1:0][TILPC-1:0] 			 me_tile_enable;
   output [CLUSTERS-1:0][1:0] 				 me_clt_max_match_len;
   output [CLUSTERS-1:0][2:0] 				 me_clt_win_size;
   
   
   output [4:0][1:0] 					 me_output_type; 
   output [IN_BYTES-1:0][7:0] 				 me_literal; 
   output [LOG_OFFPE-1:0] 				 me_ptr_length; 
   output [LOG_OFFPE-1:0] 				 me_ptr_offset; 
   output 						 me_last_output; 
   
   
   output 						 lec_prc_lz_error;
   

   
   

   msm_states_e  state_enum;




   localparam MSM_MSB = 30;  
   

   wire [TRUNC_NUM-1:0] [LONGL-1:0] cif_fwd_therm;
   wire [3:0]           cif_len4_ind;
   wire [MTF_NUM-1:0] [11:0] cif_mtf_fwd_therm;
   wire [MTF_NUM-1:0] [LOG_OFFPE-1:0] cif_mtf_offset;
   wire [MTF_NUM-1:0] [TRUNC_NUM-1:0] cif_mtf_phase;
   wire [TRUNC_NUM-1:0] [LOG_OFFPE-1:0] cif_offset;
   wire [3:0]           mdl_f;
   wire [LOG_OFFPE-1:0] mdl_previous_ptr_length;
   wire [LOG_OFFPE-1:0] mdl_previous_ptr_offset;
   wire [LOG_OFFPE-1:0] mdl_ptr_length;
   wire [LOG_OFFPE-1:0] mdl_ptr_offset;
   match_tuple_t        mdl_tuple;
   wire [5:0]           msm_emit_lit;

   wire                 msm_emit_previous_ptr;
   wire                 msm_emit_previous_ptr_c;
   wire                 msm_emit_ptr;
   wire                 msm_emit_ptr_c;
   wire [LOG_OFFPE-1:0] msm_global_count;
   wire [MSM_MSB:0]     msm_state;
   wire [2:0]           cif_len5_6_ind;
   wire                 mdl_current_tuple_wins;



   wire                 mdl_previous_is_2_back;
   match_tuple_t        mdl_previous_tuple;
   wire                 msm_save_tuple_c;
   wire                 msm_update_saved_tuple_c;
   wire                 msm_shift_lits_c;
   wire                 msm_continuing_c;
   wire                 mob_input_en;
   wire                 mob_done;
   wire                 mob_go;
   wire                 msm_clear_saved_tuple_c;
   wire                 msm_adjust_gc;
   wire                 msm_continuing;
   wire [5:0]           msm_dmw;
   wire                 msm_um2_um1_to_cont_c;
   wire                 mdl_previous_ptr_is_mtf;
   wire                 mdl_ptr_is_mtf;
   wire [LOG_OFFPE-1:0] mdl_mtf_idx;
   wire [LOG_OFFPE-1:0] mdl_previous_mtf_idx;
   wire 		cif_mim1_flag;
   wire [TRUNC_NUM-1:0] mdl_previous_winning_phase;
   wire [TRUNC_NUM-1:0] mdl_winning_phase;
   wire [5:0]           msm_emit_lit_c;


   wire [TRUNC_NUM-1:0] 	     cif_truncated;

   
   
   wire [LOG_OFFPE-1:0] clt_offset_winner;      
   wire                 mdl_valid_run;          
   wire                 msm_force_emit_lit;     
   wire                 winning_mtf_sel;        
   

   
   
   cr_lz77_comp_cif
     #(
       .TILPC          (TILPC),
       .OFFPT          (OFFPT),
       .CLUSTERS       (CLUSTERS),
       .TRUNC_NUM      (TRUNC_NUM),
       .LONGL          (LONGL),
       .MSM_MSB        (MSM_MSB)
       )
   cif
     (
      
      .cif_offset                       (cif_offset),
      .cif_fwd_therm                    (cif_fwd_therm),
      .cif_truncated                    (cif_truncated[TRUNC_NUM-1:0]),
      .cif_len4_ind                     (cif_len4_ind[3:0]),
      .cif_len5_6_ind                   (cif_len5_6_ind[2:0]),
      .cif_mtf_offset                   (cif_mtf_offset),
      .cif_mtf_phase                    (cif_mtf_phase),
      .cif_mtf_fwd_therm                (cif_mtf_fwd_therm),
      .cif_mim1_flag                    (cif_mim1_flag),
      .me_clt0_mtf_list                 (me_clt0_mtf_list),
      .me_clt0_mtf_list_valid           (me_clt0_mtf_list_valid[MTF_NUM-1:0]),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .clt_me_offset                    (clt_me_offset),
      .clt_me_fwd_therm                 (clt_me_fwd_therm),
      .clt_me_truncated                 (clt_me_truncated),
      .clt0_me_mtf_offset               (clt0_me_mtf_offset),
      .clt0_me_mtf_phase                (clt0_me_mtf_phase),
      .clt0_me_mtf_fwd_therm            (clt0_me_mtf_fwd_therm),
      .msm_emit_ptr_c                   (msm_emit_ptr_c),
      .msm_emit_previous_ptr_c          (msm_emit_previous_ptr_c),
      .msm_emit_lit_c                   (msm_emit_lit_c[5:0]),
      .mdl_ptr_offset                   (mdl_ptr_offset[LOG_OFFPE-1:0]),
      .mdl_ptr_is_mtf                   (mdl_ptr_is_mtf),
      .mdl_mtf_idx                      (mdl_mtf_idx[LOG_OFFPE-1:0]),
      .mdl_previous_ptr_offset          (mdl_previous_ptr_offset[LOG_OFFPE-1:0]),
      .mdl_previous_ptr_is_mtf          (mdl_previous_ptr_is_mtf),
      .mdl_previous_mtf_idx             (mdl_previous_mtf_idx[LOG_OFFPE-1:0]),
      .mob_done                         (mob_done),
      .mob_input_en                     (mob_input_en),
      .me_num_mtf                       (me_num_mtf),
      .mdl_winning_phase                (mdl_winning_phase[TRUNC_NUM-1:0]),
      .mdl_previous_winning_phase       (mdl_previous_winning_phase[TRUNC_NUM-1:0]),
      .me_isXp9                         (me_isXp9),
      .clt_me_len4_ind                  (clt_me_len4_ind),
      .clt_me_len5_6_ind                (clt_me_len5_6_ind),
      .clt_me_cont                      (clt_me_cont[CLUSTERS-1:0]),
      .msm_state                        (msm_state[MSM_MSB:0]),
      .clt_offset_winner                (clt_offset_winner[LOG_OFFPE-1:0]),
      .winning_mtf_sel                  (winning_mtf_sel),
      .mdl_current_tuple_wins           (mdl_current_tuple_wins),
      .mdl_valid_run                    (mdl_valid_run),
      .mdl_f                            (mdl_f[3:0]));

   
   cr_lz77_comp_mdl
     #(
       .TILPC          (TILPC),
       .OFFPT          (OFFPT),
       .CLUSTERS       (CLUSTERS),
       .TRUNC_NUM      (TRUNC_NUM),
       .LONGL          (LONGL),
       .MSM_MSB        (MSM_MSB)
       )
   mdl   
     (
      
      .mdl_tuple                        (mdl_tuple),
      .mdl_f                            (mdl_f[3:0]),
      .mdl_previous_tuple               (mdl_previous_tuple),
      .mdl_previous_is_2_back           (mdl_previous_is_2_back),
      .mdl_current_tuple_wins           (mdl_current_tuple_wins),
      .mdl_ptr_length                   (mdl_ptr_length[LOG_OFFPE-1:0]),
      .mdl_ptr_offset                   (mdl_ptr_offset[LOG_OFFPE-1:0]),
      .mdl_ptr_is_mtf                   (mdl_ptr_is_mtf),
      .mdl_mtf_idx                      (mdl_mtf_idx[LOG_OFFPE-1:0]),
      .mdl_previous_ptr_length          (mdl_previous_ptr_length[LOG_OFFPE-1:0]),
      .mdl_previous_ptr_offset          (mdl_previous_ptr_offset[LOG_OFFPE-1:0]),
      .mdl_previous_ptr_is_mtf          (mdl_previous_ptr_is_mtf),
      .mdl_previous_mtf_idx             (mdl_previous_mtf_idx[LOG_OFFPE-1:0]),
      .mdl_winning_phase                (mdl_winning_phase[TRUNC_NUM-1:0]),
      .mdl_previous_winning_phase       (mdl_previous_winning_phase[TRUNC_NUM-1:0]),
      .clt_offset_winner                (clt_offset_winner[LOG_OFFPE-1:0]),
      .winning_mtf_sel                  (winning_mtf_sel),
      .mdl_valid_run                    (mdl_valid_run),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .cif_offset                       (cif_offset),
      .cif_fwd_therm                    (cif_fwd_therm),
      .cif_truncated                    (cif_truncated[TRUNC_NUM-1:0]),
      .cif_mtf_offset                   (cif_mtf_offset),
      .cif_mtf_phase                    (cif_mtf_phase),
      .cif_mtf_fwd_therm                (cif_mtf_fwd_therm),
      .msm_state                        (msm_state[MSM_MSB:0]),
      .me_dly_match_win                 (me_dly_match_win[1:0]),
      .msm_dmw                          (msm_dmw[5:0]),
      .mob_input_en                     (mob_input_en),
      .msm_save_tuple_c                 (msm_save_tuple_c),
      .msm_update_saved_tuple_c         (msm_update_saved_tuple_c),
      .msm_clear_saved_tuple_c          (msm_clear_saved_tuple_c),
      .msm_continuing_c                 (msm_continuing_c),
      .msm_um2_um1_to_cont_c            (msm_um2_um1_to_cont_c));

   
   cr_lz77_comp_msm 
     #(
       .TILPC          (TILPC),
       .OFFPT          (OFFPT),
       .CLUSTERS       (CLUSTERS),
       .MSM_MSB        (MSM_MSB)
       )
   msm
     (
      
      .msm_state                        (msm_state[MSM_MSB:0]),
      .msm_emit_ptr                     (msm_emit_ptr),
      .msm_emit_lit                     (msm_emit_lit[5:0]),
      .msm_force_emit_lit               (msm_force_emit_lit),
      .msm_global_count                 (msm_global_count[LOG_OFFPE-1:0]),
      .msm_adjust_gc                    (msm_adjust_gc),
      .msm_emit_previous_ptr            (msm_emit_previous_ptr),
      .me_clt_dmw_cont                  (me_clt_dmw_cont),
      .me_clt_max_match_len             (me_clt_max_match_len),
      .me_clt_win_size                  (me_clt_win_size),
      .msm_emit_ptr_c                   (msm_emit_ptr_c),
      .msm_emit_previous_ptr_c          (msm_emit_previous_ptr_c),
      .msm_emit_lit_c                   (msm_emit_lit_c[5:0]),
      .msm_save_tuple_c                 (msm_save_tuple_c),
      .msm_update_saved_tuple_c         (msm_update_saved_tuple_c),
      .msm_clear_saved_tuple_c          (msm_clear_saved_tuple_c),
      .msm_shift_lits_c                 (msm_shift_lits_c),
      .msm_continuing_c                 (msm_continuing_c),
      .msm_continuing                   (msm_continuing),
      .msm_um2_um1_to_cont_c            (msm_um2_um1_to_cont_c),
      .msm_dmw                          (msm_dmw[5:0]),
      .lec_prc_lz_error                 (lec_prc_lz_error),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .mdl_tuple                        (mdl_tuple),
      .cif_len4_ind                     (cif_len4_ind[3:0]),
      .cif_len5_6_ind                   (cif_len5_6_ind[2:0]),
      .mdl_f                            (mdl_f[3:0]),
      .mob_input_en                     (mob_input_en),
      .mob_done                         (mob_done),
      .mob_go                           (mob_go),
      .me_dly_match_win                 (me_dly_match_win[1:0]),
      .me_max_match_len                 (me_max_match_len[1:0]),
      .me_win_size                      (me_win_size[2:0]),
      .mdl_previous_tuple               (mdl_previous_tuple),
      .mdl_previous_is_2_back           (mdl_previous_is_2_back),
      .mdl_current_tuple_wins           (mdl_current_tuple_wins));
   
   cr_lz77_comp_mob
     #(
       .TILPC          (TILPC),
       .OFFPT          (OFFPT),
       .CLUSTERS       (CLUSTERS)
       )
   mob
     (
      
      .mob_input_en                     (mob_input_en),
      .mob_go                           (mob_go),
      .mob_done                         (mob_done),
      .me_output_type                   (me_output_type),
      .me_literal                       (me_literal),
      .me_ptr_length                    (me_ptr_length[LOG_OFFPE-1:0]),
      .me_ptr_offset                    (me_ptr_offset[LOG_OFFPE-1:0]),
      .me_last_output                   (me_last_output),
      .me_tile_enable                   (me_tile_enable),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .msm_emit_ptr                     (msm_emit_ptr),
      .msm_emit_previous_ptr            (msm_emit_previous_ptr),
      .msm_emit_lit                     (msm_emit_lit[5:0]),
      .msm_force_emit_lit               (msm_force_emit_lit),
      .msm_shift_lits_c                 (msm_shift_lits_c),
      .msm_global_count                 (msm_global_count[LOG_OFFPE-1:0]),
      .msm_adjust_gc                    (msm_adjust_gc),
      .msm_continuing                   (msm_continuing),
      .mdl_ptr_length                   (mdl_ptr_length[LOG_OFFPE-1:0]),
      .mdl_ptr_offset                   (mdl_ptr_offset[LOG_OFFPE-1:0]),
      .mdl_ptr_is_mtf                   (mdl_ptr_is_mtf),
      .mdl_mtf_idx                      (mdl_mtf_idx[LOG_OFFPE-1:0]),
      .mdl_previous_ptr_length          (mdl_previous_ptr_length[LOG_OFFPE-1:0]),
      .mdl_previous_ptr_offset          (mdl_previous_ptr_offset[LOG_OFFPE-1:0]),
      .mdl_previous_ptr_is_mtf          (mdl_previous_ptr_is_mtf),
      .mdl_previous_mtf_idx             (mdl_previous_mtf_idx[LOG_OFFPE-1:0]),
      .cif_mim1_flag                    (cif_mim1_flag),
      .me_literal_data                  (me_literal_data),
      .me_literal_data_valid            (me_literal_data_valid[3:0]),
      .me_last                          (me_last),
      .me_win_size                      (me_win_size[2:0]));


endmodule 







