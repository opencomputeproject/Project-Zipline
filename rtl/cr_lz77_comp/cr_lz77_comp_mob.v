/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/















`include "cr_lz77_comp.vh"
`include "cr_lz77_comp_pkg_include.vh"

module cr_lz77_comp_mob
  #(
    parameter TILPC          = `TILES_PER_CLUSTER,
    parameter OFFPT          = `OFFSETS_PER_TILE,
    parameter CLUSTERS       = `CLUSTERS
    )

   (
   
   mob_input_en, mob_go, mob_done, me_output_type, me_literal,
   me_ptr_length, me_ptr_offset, me_last_output, me_tile_enable,
   
   clk, rst_n, msm_emit_ptr, msm_emit_previous_ptr, msm_emit_lit,
   msm_force_emit_lit, msm_shift_lits_c, msm_global_count,
   msm_adjust_gc, msm_continuing, mdl_ptr_length, mdl_ptr_offset,
   mdl_ptr_is_mtf, mdl_mtf_idx, mdl_previous_ptr_length,
   mdl_previous_ptr_offset, mdl_previous_ptr_is_mtf,
   mdl_previous_mtf_idx, cif_mim1_flag, me_literal_data,
   me_literal_data_valid, me_last, me_win_size
   );
   
   
   
   
   
   

`include "cr_lz77_comp_includes.vh"

   localparam OFFPE     = OFFPT * TILPC * CLUSTERS; 
   localparam LOG_OFFPE = $clog2(OFFPE);


   input 			      clk;
   input 			      rst_n;
   input 			      msm_emit_ptr;
   input 			      msm_emit_previous_ptr;
   input [5:0] 			      msm_emit_lit;
   input    			      msm_force_emit_lit;
   input  			      msm_shift_lits_c;
   input [LOG_OFFPE-1:0] 	      msm_global_count;
   input 			      msm_adjust_gc;
   input 			      msm_continuing;
 			      
   input [LOG_OFFPE-1:0] 	      mdl_ptr_length; 
   input [LOG_OFFPE-1:0] 	      mdl_ptr_offset; 
   input                              mdl_ptr_is_mtf;
   input [LOG_OFFPE-1:0] 	      mdl_mtf_idx; 
   
   input [LOG_OFFPE-1:0] 	      mdl_previous_ptr_length; 
   input [LOG_OFFPE-1:0] 	      mdl_previous_ptr_offset; 
   input                              mdl_previous_ptr_is_mtf;
   input [LOG_OFFPE-1:0] 	      mdl_previous_mtf_idx; 

   input 			      cif_mim1_flag;

   input [3:0][7:0] 		      me_literal_data;
   input [3:0] 			      me_literal_data_valid;
   input  			      me_last;
   
   
   
   
   
   
   
   
   input [2:0] 			      me_win_size;

   output reg 			      mob_input_en;
   output reg 			      mob_go;
   output reg  			      mob_done;

   output reg [4:0][1:0] 	      me_output_type; 
   output reg [3:0][7:0] 	      me_literal; 
   output reg [LOG_OFFPE-1:0] 	      me_ptr_length; 
   output reg [LOG_OFFPE-1:0] 	      me_ptr_offset; 
   output  			      me_last_output; 
   
   output reg [CLUSTERS-1:0][TILPC-1:0] me_tile_enable;
 			      
   
   
   
   
   
   


   logic 			      emit_ptr;
   logic 			      emit_previous_ptr;
   logic [5:0] 			      emit_lit;
   logic [3:0][LOG_OFFPE-1:0] 	      ptr_length; 
   logic [3:0][LOG_OFFPE-1:0] 	      ptr_offset; 
   logic [3:0] 			      ptr_is_mtf;
   logic [3:0][LOG_OFFPE-1:0] 	      mtf_idx; 
   logic [3:0][LOG_OFFPE-1:0] 	      previous_ptr_length; 
   logic [3:0][LOG_OFFPE-1:0] 	      previous_ptr_offset; 
   logic [3:0] 			      previous_ptr_is_mtf;
   logic [3:0][LOG_OFFPE-1:0] 	      previous_mtf_idx; 
   logic 			      emit_ptr_gated;
   logic 			      emit_previous_ptr_gated;
   logic [5:0] 			      emit_lit_gated;
   logic 			      mim1_flag;
   

   logic [3:0][7:0] 		      lit_stack;
   logic [1:0] 			      lit_stack_index;
   logic [2:0] 			      output_index;

   logic [33:0][7:0] 		      lit_shift_data;
   logic [33:0] 		      lit_shift_data_valid;
   logic [5:0][7:0] 		      lits_for_emission;
   logic [5:0] 			      lits_for_emission_valid;
   logic [7:0] 			      pipe_primed;
   logic [15:0] 		      last;
   logic  			      msm_shift_lits;
   
   logic [3:0][7:0] 		      me_literal_data_r;
   logic [3:0] 			      me_literal_data_valid_r;
   logic [3:0][7:0] 		      me_literal_data_2r;
   logic [3:0] 			      me_literal_data_valid_2r;
   logic [LOG_OFFPE-1:0] 	      global_count;
   logic 			      adjust_gc;
   logic [LOG_OFFPE-1:0] 	      adjusted_global_count;
   logic 			      continuing;


   lz77_symbol_type_e  lit_stack_type[4];
   lz77_symbol_type_e  output_type[5];
   lz77_symbol_type_e  output_type_r[5];
   

   assign  me_last_output = last[9];

   always @ (*) begin
      if (mob_input_en && !mob_done) begin
	 emit_lit_gated           = emit_lit;
	 emit_ptr_gated           = emit_ptr;
	 emit_previous_ptr_gated  = emit_previous_ptr;
      end
      else begin
	 emit_lit_gated           = 6'b0;
	 emit_ptr_gated           = 1'b0;
	 emit_previous_ptr_gated  = 1'b0;
      end

      
      
      
      lit_stack_index = 2'b00;
      lit_stack = {4{8'b0}};
      for (int i=0; i<4; i=i+1) begin
	 lit_stack_type[i] = NULL;
      end
      for (int i=0; i<6; i=i+1) begin
	 if (emit_lit_gated[5-i] && lits_for_emission_valid[5-i]) begin
	    
	    lit_stack[lit_stack_index] = lits_for_emission[5-i];
	    lit_stack_type[lit_stack_index] = LIT;
	    lit_stack_index = lit_stack_index + 1;
	 end
      end

      
      for (int i=0; i<5; i=i+1) begin
	 output_type[i] = NULL;
      end
      output_index = 3'b0;

      
      for (int i=0; i<4; i=i+1) begin
	 if (lit_stack_type[i] == LIT) begin
	    output_type[output_index] = LIT;
	    output_index = output_index + 1;
	 end
      end

      if (emit_ptr_gated) begin
	 output_type[output_index] = ptr_is_mtf[1] ? MTF : PTR;
      end
      if (emit_previous_ptr_gated) begin
	 output_type[output_index] = previous_ptr_is_mtf[1] ? MTF : PTR;
      end
      if (emit_ptr_gated || emit_previous_ptr_gated) begin
	 output_index = output_index + 1;
      end

      adjusted_global_count = adjust_gc ? (global_count - 4) : global_count;

      for (int i=0; i<5; i=i+1) begin
	 if (mob_input_en) begin
	    me_output_type[i] = output_type_r[i];
	 end
	 else begin
	    me_output_type[i] = NULL;
	 end
      end

      
      case(me_win_size)
	
	3'd0 : me_tile_enable = { {(128 - 1){1'b0}},  {1{1'b1}} };

	
	3'd1 : me_tile_enable = { {(128 - 8){1'b0}},  {8{1'b1}} };

	
	3'd2 : me_tile_enable = { {(128 - 16){1'b0}}, {16{1'b1}} };

	
	3'd3 : me_tile_enable = { {(128 - 32){1'b0}}, {32{1'b1}} };

	
	3'd4 : me_tile_enable = { {(128 - 64){1'b0}}, {64{1'b1}} };

	
	default : me_tile_enable = {128{1'b1}};
	
      endcase 

   end 
   

   always @ (posedge clk or negedge rst_n) begin
      if (!rst_n) begin

	 emit_ptr            <= 1'b0;
	 emit_previous_ptr   <= 1'b0;
	 emit_lit            <= 6'b0;
	 me_literal          <= {4{8'b0}}; 
	 me_ptr_length       <= {LOG_OFFPE{1'b0}};
	 me_ptr_offset       <= {LOG_OFFPE{1'b0}}; 
	 pipe_primed         <= 8'b0;
	 last                <= 16'b0;
	 mob_input_en        <= 1'b0;
	 mob_done            <= 1'b1;
	 mob_go              <= 1'b0;
	 me_literal_data_r   <= {4{8'b0}};
	 me_literal_data_valid_r <= 4'b0;
	 me_literal_data_2r   <= {4{8'b0}};
	 me_literal_data_valid_2r <= 4'b0;
	 global_count        <= {LOG_OFFPE{1'b0}}; 
	 msm_shift_lits      <= 1'b0;
	 adjust_gc           <= 1'b0;
	 continuing          <= 1'b0;
	 mim1_flag           <= 1'b0;
	 

	 for (int i=0;i<34;i=i+1) begin
	    lit_shift_data[i]       <= 8'b0;
	    lit_shift_data_valid[i] <= 1'b0;
	 end

	 for (int i=0;i<6;i=i+1) begin
	    lits_for_emission[i]       <= 8'b0;
	    lits_for_emission_valid[i] <= 1'b0;
	 end

	 for (int i=0;i<4;i=i+1) begin
	    ptr_length[i]          <= {LOG_OFFPE{1'b0}};
	    ptr_offset[i]          <= {LOG_OFFPE{1'b0}};
	    ptr_is_mtf[i]          <= 1'b0;
	    mtf_idx[i]             <= {LOG_OFFPE{1'b0}};
	    previous_ptr_length[i] <= {LOG_OFFPE{1'b0}};
	    previous_ptr_offset[i] <= {LOG_OFFPE{1'b0}};
	    previous_ptr_is_mtf[i] <= 1'b0;
	    previous_mtf_idx[i]    <= {LOG_OFFPE{1'b0}};
	 end
	 
	 for (int i=0;i<5;i=i+1) begin
	    output_type_r[i]      <= NULL;
	 end
	      
      end else begin

	 me_literal_data_r       <= me_literal_data;
	 me_literal_data_valid_r <= me_literal_data_valid;
	 
	 me_literal_data_2r       <= me_literal_data_r;
	 me_literal_data_valid_2r <= me_literal_data_valid_r;
	    
	 if ( mob_input_en ) begin
	    
	    emit_ptr                 <= msm_emit_ptr;
	    emit_previous_ptr        <= msm_emit_previous_ptr;
	    emit_lit[5:1]            <= msm_emit_lit[5:1];
	    emit_lit[0]              <= msm_emit_lit[0] || msm_force_emit_lit;
	    ptr_length[0]            <= mdl_ptr_length;
	    ptr_offset[0]            <= mdl_ptr_offset;
	    ptr_is_mtf[0]            <= mdl_ptr_is_mtf;

	    mim1_flag                <= cif_mim1_flag;

 	    mtf_idx[0]               <= mdl_mtf_idx;

	    previous_ptr_length[0]   <= mdl_previous_ptr_length;
	    previous_ptr_offset[0]   <= mdl_previous_ptr_offset;
	    previous_ptr_is_mtf[0]   <= mdl_previous_ptr_is_mtf;

	    previous_mtf_idx[0]      <= mdl_previous_mtf_idx;
					
	    global_count             <= msm_global_count;
	    msm_shift_lits           <= msm_shift_lits_c;
	    adjust_gc                <= msm_adjust_gc;
	    continuing               <= msm_continuing;
	    
	    
	    ptr_length[3:1]            <= ptr_length[2:0];
	    ptr_offset[3:1]            <= ptr_offset[2:0];
	    ptr_is_mtf[3:1]            <= ptr_is_mtf[2:0];
	    mtf_idx[3:1]               <= mtf_idx[2:0];

	    mtf_idx[1]                 <= mim1_flag ?
					  mtf_idx[0] - 1 :
					  mtf_idx[0];
	    mtf_idx[3:2]               <= mtf_idx[2:1];

	    previous_ptr_length[3:1]   <= previous_ptr_length[2:0];
	    previous_ptr_offset[3:1]   <= previous_ptr_offset[2:0];
	    previous_ptr_is_mtf[3:1]   <= previous_ptr_is_mtf[2:0];

	    previous_mtf_idx[1]        <= mim1_flag ?
					  previous_mtf_idx[0] - 1 :
					  previous_mtf_idx[0];
	    previous_mtf_idx[3:2]      <= previous_mtf_idx[2:1];
	    
	    
	    if (emit_previous_ptr) begin
	       me_ptr_length <= continuing ? 
				(previous_ptr_length[1] + adjusted_global_count - 4) : 
				(previous_ptr_length[1] + adjusted_global_count);
	    end
	    else begin
	       me_ptr_length <= (ptr_length[1] + adjusted_global_count);
	    end

	    if (emit_previous_ptr) begin
	       me_ptr_offset <= previous_ptr_is_mtf[1] ? 
				previous_mtf_idx[1] : previous_ptr_offset[1];
	    end
	    else begin
	       me_ptr_offset <= ptr_is_mtf[1] ? 
				mtf_idx[1] : ptr_offset[1];
	    end

	    me_literal <= lit_stack;

	    for (int i=0; i<5; i=i+1) begin
	       output_type_r[i] <= output_type[i];
	    end

	    
	    for (int i=0; i<4; i=i+1) begin
	       lit_shift_data[i]       <= me_literal_data_2r[i];
	       lit_shift_data_valid[i] <= me_literal_data_valid_2r[i];
	    end
	    for (int i=4; i<34; i=i+1 ) begin
	       lit_shift_data[i]       <= lit_shift_data[i-4];

	       lit_shift_data_valid[i] <= lit_shift_data_valid[i-4];
	    end

	    
	    if (msm_shift_lits) begin
	       for (int i=0; i<6; i=i+1) begin
		  lits_for_emission[i]       <= lit_shift_data[i+16];
		  lits_for_emission_valid[i] <= lit_shift_data_valid[i+16];
	       end
	    end

	    
	    
	    

	    
	    mob_go <= pipe_primed[3] && !pipe_primed[4];


	 end 

	 
	 if (last[8]) begin
	    pipe_primed <= 8'b0;
	 end
	 else begin
	    if ( (|me_literal_data_valid) || (|last[7:0]) ) begin
	       pipe_primed[0] <= 1'b1;
	       pipe_primed[7:1] <= pipe_primed[6:0];
	    end
	 end
	 
	 last[15:0] <= {last[14:0],me_last};
	 mob_input_en <= (|me_literal_data_valid_r) || (|last[8:0]);

	 
	 
	 
	 mob_done <= last[8] || (mob_done && !(|me_literal_data_valid));


	 

      end 
   end 
   
      
	 
	 
endmodule 

  







