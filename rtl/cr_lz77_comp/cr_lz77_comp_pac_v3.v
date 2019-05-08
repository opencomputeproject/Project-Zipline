/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_lz77_comp_pkg_include.vh"

module cr_lz77_comp_pac_v3
  (
   
   pkf_ren, pac_exg_data, pac_exg_val,
   
   clk, rst_n, pkf_empty, pkf_rdata, exg_pac_stb, prs_lob_afull
   );

`include "cr_lz77_comp_includes.vh"

   input                        clk;
   input 			rst_n; 

   input                        pkf_empty;
   input 			pkf_data_t pkf_rdata;
   output                       pkf_ren;

   input 			exg_pac_stb;
   input 			prs_lob_afull;

   output 			packer_symbol_bus_t pac_exg_data;
   output logic 		pac_exg_val;

   
   
   
   
   

   logic [1:0] 			starting_lz_lane;
   logic [1:0] 			starting_lz_stage;
   logic 			pointer_flag;
   logic [2:0] 			loader_occupancy;
   packer_symbol_bus_t          stage[0:3];
   packer_symbol_bus_t          stage_c[0:3];
   logic 			this_stage_has_ptr_c;
   logic [1:0] 			occupancy_inc_c;
   logic [1:0] 			lz_lane_c;
   logic [1:0] 			lz_stage_c;
   logic [7:0] 			offset_lsb_c;
   logic 			packer_done_c;
   logic 			pkf_ren_c;
   logic [1:0] 			stage_sel;
   logic 			send_stage;
   logic [3:0] 			stage_ren;
   logic 			packer_go;
   logic [1:0] 			lec_lit_idx_c;
   

   
   assign pkf_ren = pkf_ren_c;


   
   
   
   
   
   
   
   
   
   
   
   
   
   
   always @ (posedge clk or negedge rst_n) begin
      if (!rst_n) begin

	 starting_lz_lane    <= 2'b0;
	 starting_lz_stage   <= 2'b0;
	 pointer_flag        <= 1'b0;
	 loader_occupancy    <= 3'b0;
	 packer_go           <= 1'b0;

	 for (int s=0; s<4; s++) begin
	    stage[s] <= {$bits(packer_symbol_bus_t){1'b0}};
	 end
	 
      end else begin
	 
	 packer_go <= (exg_pac_stb && !packer_done_c) ||
		      (packer_go && !packer_done_c);

	 starting_lz_lane <= packer_go ? lz_lane_c : 2'b0;
	 starting_lz_stage <= packer_go ? lz_stage_c : 2'b0;
	 pointer_flag <= this_stage_has_ptr_c;
	 
	 
	 if (exg_pac_stb) begin
	    loader_occupancy  <= 3'b0;
	 end 
	 else if (|stage_ren && |occupancy_inc_c) begin
	    loader_occupancy <= loader_occupancy +
				(occupancy_inc_c - 1);
	 end 
	 else if (|occupancy_inc_c) begin
	    loader_occupancy <= loader_occupancy +
				occupancy_inc_c;
	 end
	 else if (|stage_ren) begin
	    loader_occupancy <= loader_occupancy - 1;
	 end
      
	 
	 
	 for (int s=0; s<4; s++) begin
	    stage[s] <= stage_c[s];
	    
	    if (stage_ren[s])
	      stage[s].lz77_frame_data.framing <= stage_c[s].lz77_frame_data.framing;
	    else
	      stage[s].lz77_frame_data.framing <= stage[s].lz77_frame_data.framing + 
						  stage_c[s].lz77_frame_data.framing;
	 end
      end
   end 
      
   
   
   
   always @ (*) begin
      
      
      
      
      occupancy_inc_c       = 2'b0;
      lz_lane_c             = starting_lz_lane;
      lz_stage_c            = starting_lz_stage;
      this_stage_has_ptr_c  = pointer_flag;
      offset_lsb_c          = pkf_rdata.type3_offset[7:0];
      packer_done_c         = 1'b0;
      pkf_ren_c             = 1'b0;
      lec_lit_idx_c         = 2'b00;

      for (int s=0; s<4; s++) begin
	 if (stage_ren[s])
	   
	   stage_c[s] = {$bits(packer_symbol_bus_t){1'b0}};
	 else
	   
	   stage_c[s] = stage[s];

	 
	 
	 
	 
	 stage_c[s].lz77_frame_data.framing = 4'b0;
      end
      
      
      
      
      if (packer_go && 
	  !pkf_empty && 
	  (loader_occupancy < 2) ) begin
	 
	 pkf_ren_c = 1'b1;

	 
	 
	 for (int lec_lane=0; lec_lane<5; lec_lane++) begin


	    
	    if (pkf_rdata.symbol_type[lec_lane] == LIT) begin
	       case (lz_lane_c)
		 0: stage_c[lz_stage_c].lz77_frame_data.data0 = pkf_rdata.literal[lec_lit_idx_c];
		 1: stage_c[lz_stage_c].lz77_frame_data.data1 = pkf_rdata.literal[lec_lit_idx_c];
	         2: stage_c[lz_stage_c].lz77_frame_data.data2 = pkf_rdata.literal[lec_lit_idx_c];
	         3: stage_c[lz_stage_c].lz77_frame_data.data3 = pkf_rdata.literal[lec_lit_idx_c];
	       endcase
	       stage_c[lz_stage_c].lz77_frame_data.framing += 4'b1;
	       lec_lit_idx_c += 2'b1;
	       
	       
	       if (lz_lane_c == 2'b11) begin
		  lz_stage_c += 1;
		  occupancy_inc_c += 1;
		  this_stage_has_ptr_c = 1'b0;
	       end
	       lz_lane_c += 1;
	    end 
	    
	    
	    else if ( (pkf_rdata.symbol_type[lec_lane] == PTR) ||
		      (pkf_rdata.symbol_type[lec_lane] == MTF)
		      ) begin
	       
	       
	       
	       
	       if (this_stage_has_ptr_c) begin
		  lz_stage_c += 1;
		  lz_lane_c = 2'b0;
		  occupancy_inc_c += 1;
	       end
	       
	       case (lz_lane_c)
	         0: stage_c[lz_stage_c].lz77_frame_data.data0 = offset_lsb_c;
	         1: stage_c[lz_stage_c].lz77_frame_data.data1 = offset_lsb_c;
	         2: stage_c[lz_stage_c].lz77_frame_data.data2 = offset_lsb_c;
	         3: stage_c[lz_stage_c].lz77_frame_data.data3 = offset_lsb_c;
	       endcase
	       
	       stage_c[lz_stage_c].lz77_frame_data.backref = 1'b1;
	       stage_c[lz_stage_c].lz77_frame_data.backref_type = (pkf_rdata.
								   symbol_type[lec_lane] == 
								   MTF);
	       
	       stage_c[lz_stage_c].lz77_frame_data.backref_lane = lz_lane_c;
	       
	       stage_c[lz_stage_c].lz77_frame_data.offset_msb = pkf_rdata.type3_offset[15:8];
									       
	       stage_c[lz_stage_c].lz77_frame_data.length = pkf_rdata.type3_length;
	       
	       stage_c[lz_stage_c].lz77_frame_data.framing += 4'b1;
	    
	       

	       
	       
	       if (lz_lane_c == 2'b11) begin
		  lz_stage_c += 1;
		  occupancy_inc_c += 1;
		  this_stage_has_ptr_c = 1'b0;
	       end
	       
	       
	       
	       else begin
		  this_stage_has_ptr_c = 1'b1;
	       end
	       lz_lane_c += 1;

	    end
	    
	    
	    
	 end 

	 
	 if (pkf_rdata.eot) begin
	    packer_done_c = 1'b1;
	    this_stage_has_ptr_c = 1'b0;
























	    
	    
	    
	    
	    
	    
 	    
 	    
 	    
	    
	    
 	    
 	    
 	    if (lz_lane_c == 2'b0) begin
 	       stage_c[lz_stage_c].eot = 1'b1;
 	       occupancy_inc_c += 1;  
 	    end
 	    else begin
 	       case(lz_stage_c)
 		 2'd0: stage_c[1].eot = 1'b1;
 		 2'd1: stage_c[2].eot = 1'b1;
 		 2'd2: stage_c[3].eot = 1'b1;
 		 2'd3: stage_c[0].eot = 1'b1;
 	       endcase 
 	       occupancy_inc_c += 2;  
 	    end

	 end

      end 
   end 
      
	 
	       
   
   
   
   
   
   always @ (posedge clk or negedge rst_n) begin
      if (!rst_n) begin
	 stage_sel <= 2'b0;
      end else begin
	 if (exg_pac_stb)
	   stage_sel <= 2'b0;
	 else if (send_stage)
	   stage_sel <= stage_sel + 1;
      end
   end

   always @ (*) begin
      
      send_stage = 1'b0;
      if ( (loader_occupancy != 3'b0) && !prs_lob_afull )
	send_stage = 1'b1;
	
      case (stage_sel)
	0 : pac_exg_data = stage[0];
	1 : pac_exg_data = stage[1];
	2 : pac_exg_data = stage[2];
	3 : pac_exg_data = stage[3];
      endcase
      pac_exg_val = send_stage;
      
      
      stage_ren[0] = send_stage && (stage_sel == 2'd0);
      stage_ren[1] = send_stage && (stage_sel == 2'd1);
      stage_ren[2] = send_stage && (stage_sel == 2'd2);
      stage_ren[3] = send_stage && (stage_sel == 2'd3);
   end
   
	 
   
   
   
   
   
   

   logic       _v; 
   logic [3:0] _f; 
   logic       _p; 
   logic       _m; 
   logic [1:0] _l; 
   
   always_comb begin
      _v = pac_exg_val;
      _f = pac_exg_data.lz77_frame_data.framing;
      _p = pac_exg_data.lz77_frame_data.backref;
      _m = pac_exg_data.lz77_frame_data.backref_type;
      _l = pac_exg_data.lz77_frame_data.backref_lane;
   end

   `COVER_PROPERTY( _v && (_f==4'd1) && (_p==1'b0) );                             
   `COVER_PROPERTY( _v && (_f==4'd1) && (_p==1'b1) && (_m==1'b0) );               
   `COVER_PROPERTY( _v && (_f==4'd1) && (_p==1'b1) && (_m==1'b1) );               
   
   `COVER_PROPERTY( _v && (_f==4'd2) && (_p==1'b0) );                             
   `COVER_PROPERTY( _v && (_f==4'd2) && (_p==1'b1) && (_m==1'b0) && (_l==2'd0) ); 
   `COVER_PROPERTY( _v && (_f==4'd2) && (_p==1'b1) && (_m==1'b0) && (_l==2'd1) ); 
   `COVER_PROPERTY( _v && (_f==4'd2) && (_p==1'b1) && (_m==1'b1) && (_l==2'd0) ); 
   `COVER_PROPERTY( _v && (_f==4'd2) && (_p==1'b1) && (_m==1'b1) && (_l==2'd1) ); 

   `COVER_PROPERTY( _v && (_f==4'd3) && (_p==1'b0) );                             
   `COVER_PROPERTY( _v && (_f==4'd3) && (_p==1'b1) && (_m==1'b0) && (_l==2'd0) ); 
   `COVER_PROPERTY( _v && (_f==4'd3) && (_p==1'b1) && (_m==1'b0) && (_l==2'd1) ); 
   `COVER_PROPERTY( _v && (_f==4'd3) && (_p==1'b1) && (_m==1'b0) && (_l==2'd2) ); 
   `COVER_PROPERTY( _v && (_f==4'd3) && (_p==1'b1) && (_m==1'b1) && (_l==2'd0) ); 
   `COVER_PROPERTY( _v && (_f==4'd3) && (_p==1'b1) && (_m==1'b1) && (_l==2'd1) ); 
   `COVER_PROPERTY( _v && (_f==4'd3) && (_p==1'b1) && (_m==1'b1) && (_l==2'd2) ); 

   `COVER_PROPERTY( _v && (_f==4'd4) && (_p==1'b0) );                             
   `COVER_PROPERTY( _v && (_f==4'd4) && (_p==1'b1) && (_m==1'b0) && (_l==2'd0) ); 
   `COVER_PROPERTY( _v && (_f==4'd4) && (_p==1'b1) && (_m==1'b0) && (_l==2'd1) ); 
   `COVER_PROPERTY( _v && (_f==4'd4) && (_p==1'b1) && (_m==1'b0) && (_l==2'd2) ); 
   `COVER_PROPERTY( _v && (_f==4'd4) && (_p==1'b1) && (_m==1'b0) && (_l==2'd3) ); 
   `COVER_PROPERTY( _v && (_f==4'd4) && (_p==1'b1) && (_m==1'b1) && (_l==2'd0) ); 
   `COVER_PROPERTY( _v && (_f==4'd4) && (_p==1'b1) && (_m==1'b1) && (_l==2'd1) ); 
   `COVER_PROPERTY( _v && (_f==4'd4) && (_p==1'b1) && (_m==1'b1) && (_l==2'd2) ); 
   `COVER_PROPERTY( _v && (_f==4'd4) && (_p==1'b1) && (_m==1'b1) && (_l==2'd3) ); 

   
   
   
   
   

endmodule 









