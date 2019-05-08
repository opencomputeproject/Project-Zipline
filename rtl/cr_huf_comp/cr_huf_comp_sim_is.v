/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_huf_comp.vh"

module cr_huf_comp_sim_is
  #(parameter
    DAT_WIDTH        =10,       
    CNT_WIDTH        =3,        
    MAX_NUM_SYM_USED =576,      
    SHORT            =1   
   )
  (
   
   is_sc_rd, hw_lut_wr, hw_lut_wr_done, hw_lut_wr_val, hw_lut_wr_addr,
   hw_lut_sizes_val, hw_lut_sim_size, hw_lut_seq_id, st_sa_size_rdy,
   st_sa_size_seq_id, st_sa_eob, hw_hdr_seq_id,
   
   clk, rst_n, sc_is_vld, sc_is_sym0, sc_is_sym1, sc_is_sym2,
   sc_is_sym3, sc_is_cnt0, sc_is_cnt1, sc_is_cnt2, sc_is_cnt3,
   sc_is_seq_id, sc_is_eob, sa_st_read_done, hdr_hw_type
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

  parameter NUM_IN_SYMBOLS   =4;

  `ifdef THESE_AUTOS_SHOULD_BE_EMPTY
   
   
  `endif
 
 
 
 input			                         clk;
 input			                         rst_n;
 
 
 

 
 input [NUM_IN_SYMBOLS-1:0] 		      sc_is_vld;       
 input [DAT_WIDTH-1:0]  		      sc_is_sym0;      
 input [DAT_WIDTH-1:0]  		      sc_is_sym1;      
 input [DAT_WIDTH-1:0]  		      sc_is_sym2;      
 input [DAT_WIDTH-1:0]  		      sc_is_sym3;      
 input [CNT_WIDTH-1:0]  		      sc_is_cnt0;      
 input [CNT_WIDTH-1:0]  		      sc_is_cnt1;      
 input [CNT_WIDTH-1:0]  		      sc_is_cnt2;      
 input [CNT_WIDTH-1:0]  		      sc_is_cnt3;      
 input [`CREOLE_HC_SEQID_WIDTH-1:0] 	      sc_is_seq_id;    
 input e_pipe_eob                             sc_is_eob;       
                                                               
                                                               
                                                               
                                                               

 
 input                                        sa_st_read_done; 

 
 input s_seq_id_type_intf   	              hdr_hw_type;    
   
 
 
 

 
 output logic                                 is_sc_rd;

 
 
 output logic                                 hw_lut_wr;      
 output logic                                 hw_lut_wr_done; 
 output logic [1:0]                           hw_lut_wr_val;
 output logic [DAT_WIDTH-2:0]                 hw_lut_wr_addr; 
 output logic                                 hw_lut_sizes_val;
                                                              
 output logic [19:0]                          hw_lut_sim_size;
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]    hw_lut_seq_id;  


 
 output logic                                 st_sa_size_rdy;
                                                           
                                                           
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]    st_sa_size_seq_id;
 output e_pipe_eob                            st_sa_eob;
                                                      
                                                      
                                                      
                                                      

 
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]    hw_hdr_seq_id;
    
 
 

 
 logic [NUM_IN_SYMBOLS-1:0][DAT_WIDTH-1:0]                    sc_is_sym_r,sc_is_sym_r1;
 logic [NUM_IN_SYMBOLS-1:0][CNT_WIDTH-1:0]                    sc_is_cnt_r,sc_is_cnt_r1; 
 logic [NUM_IN_SYMBOLS-1:0] 		                      sc_is_vld_r,sc_is_vld_r1;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0]                           sc_is_seq_id_r,sc_is_seq_id_r1;
 e_pipe_eob                                                   sc_is_eob_r,sc_is_eob_r1;
 logic [19:0]                                                 hw_lut_sim_size_c;
   
 logic                                                        busy;
 logic [NUM_IN_SYMBOLS-1:0][19:0]                             sim_size_multiplier,sim_size_multiplier_c;

 s_simple_bl_range [3:0] simple_bl;

 
 
 

   

always_ff @(posedge clk or negedge rst_n)
begin
  if (~rst_n) 
  begin
    sc_is_eob_r <= MIDDLE;
    sc_is_eob_r1 <= MIDDLE;
    
    
    busy <= 0;
    hw_hdr_seq_id <= 0;
    hw_lut_sim_size <= 0;
    sc_is_cnt_r <= 0;
    sc_is_cnt_r1 <= 0;
    sc_is_seq_id_r <= 0;
    sc_is_seq_id_r1 <= 0;
    sc_is_sym_r <= 0;
    sc_is_sym_r1 <= 0;
    sc_is_vld_r <= 0;
    sc_is_vld_r1 <= 0;
    sim_size_multiplier <= 0;
    
    
  end
  else
  begin

	      sc_is_vld_r	<= sc_is_vld & {NUM_IN_SYMBOLS{~busy}};
              sc_is_sym_r[0]	<= sc_is_sym0;
              sc_is_sym_r[1]	<= sc_is_sym1;
              sc_is_sym_r[2]	<= sc_is_sym2;
              sc_is_sym_r[3]	<= sc_is_sym3;
              sc_is_cnt_r[0]	<= sc_is_cnt0;
              sc_is_cnt_r[1]	<= sc_is_cnt1;
              sc_is_cnt_r[2]	<= sc_is_cnt2;
              sc_is_cnt_r[3]	<= sc_is_cnt3;
              sc_is_seq_id_r	<= sc_is_seq_id;
              sc_is_eob_r	<= sc_is_eob;

              sc_is_vld_r1	<= sc_is_vld_r;
              sc_is_sym_r1	<= sc_is_sym_r;
              sc_is_cnt_r1	<= sc_is_cnt_r;
              sc_is_seq_id_r1	<= sc_is_seq_id_r;
              sc_is_eob_r1	<= sc_is_eob_r;

	      
              if(busy==0 && |sc_is_vld && sc_is_eob!=MIDDLE)
	         busy		<= 1'b1;
              else if(sa_st_read_done)
	         busy		<= 1'b0;


	      sim_size_multiplier                <= sim_size_multiplier_c;
	  
	      if(sa_st_read_done)
		hw_lut_sim_size		         <= 0;
	      else
	        hw_lut_sim_size		         <= hw_lut_sim_size_c;

              hw_hdr_seq_id                      <= |sc_is_vld && busy==0 ? sc_is_seq_id : hw_hdr_seq_id;

          
  end
end 

always_comb
  begin
     

     if(hdr_hw_type.comp_mode==XP9)
          begin
      	      simple_bl									 = simple_bl_table[SHORT][0];
          end
     else
        case(hdr_hw_type.lz77_win_size)
            WIN_4K : begin
      	                 simple_bl							 = simple_bl_table[SHORT][4];
      	             end
            WIN_8K : begin
      	                 simple_bl							 = simple_bl_table[SHORT][3];
      	             end
            WIN_16K: begin
      	                 simple_bl							 = simple_bl_table[SHORT][2];
      	             end
            default: begin
      	                 simple_bl							 = simple_bl_table[SHORT][1]; 
      	             end
        endcase 


      
      
      hw_lut_sim_size_c							                 = hw_lut_sim_size;
     
      for(int i=0;i <NUM_IN_SYMBOLS ;i++)
	    hw_lut_sim_size_c						                 = sim_size_multiplier[i] + 
                                                                                           hw_lut_sim_size_c;

end


always_comb
  begin

          sim_size_multiplier_c	                                                         = 0; 

	  for(int i=0;i<NUM_IN_SYMBOLS;i++)
	  begin
		     if(sc_is_vld_r[i] & (sc_is_cnt_r[i] != 0) & (sc_is_sym_r[i] < MAX_NUM_SYM_USED))
		       begin

	                    if({{(10-DAT_WIDTH){1'b0}},sc_is_sym_r[i]} <= simple_bl[0].sym)
		       	          sim_size_multiplier_c[i]                		 = simple_bl[0].bl * 
                                                                                           sc_is_cnt_r[i];
                       

                           
	                   else if({{(10-DAT_WIDTH){1'b0}},sc_is_sym_r[i]} <= simple_bl[1].sym)
                       	         sim_size_multiplier_c[i]				 = simple_bl[1].bl * 
                                                                                           sc_is_cnt_r[i];
		   
		           
	                  else if({{(10-DAT_WIDTH){1'b0}},sc_is_sym_r[i]} <= simple_bl[2].sym)
                       	        sim_size_multiplier_c[i]				 = simple_bl[2].bl * 
                                                                                           sc_is_cnt_r[i];
		   
		          
	                  else if({{(10-DAT_WIDTH){1'b0}},sc_is_sym_r[i]} <= simple_bl[3].sym)
                       	        sim_size_multiplier_c[i]				 = simple_bl[3].bl * 
                                                                                           sc_is_cnt_r[i];		   
		       end

	  end 
     

is_sc_rd					 = ~busy;

hw_lut_wr        = 0;  
hw_lut_wr_val    = 0;   
if(hw_lut_wr_addr!=0)  
begin   
  hw_lut_wr_val                                    = 2'h3;
  hw_lut_wr                                        = 1'b1;
end

end 

   

always @(posedge clk or negedge rst_n)
begin
  if (~rst_n) 
  begin
    st_sa_eob <= MIDDLE;
    
    
    hw_lut_seq_id <= 0;
    hw_lut_sizes_val <= 0;
    hw_lut_wr_addr <= 0;
    hw_lut_wr_done <= 0;
    st_sa_size_rdy <= 0;
    st_sa_size_seq_id <= 0;
    
  end
  else
    begin
      
      hw_lut_wr_done   <= 0;
      hw_lut_sizes_val <= 0;
      hw_lut_seq_id    <= 0;
    
      if(|sc_is_vld_r1 && sc_is_eob_r1!=MIDDLE) 
	begin
          
          hw_lut_sizes_val <= 1'b1;
          st_sa_size_seq_id<= sc_is_seq_id_r1;
          st_sa_eob        <= sc_is_eob_r1;

	end 
      else if(sa_st_read_done)
	begin

          st_sa_size_rdy   <= 0;
          st_sa_size_seq_id<= 0;
          st_sa_eob        <= MIDDLE;
	   
	end

      
      if(sa_st_read_done)
	begin
	    hw_lut_wr_addr <= 0;
	end
      else if(|sc_is_vld_r1 | hw_lut_wr_addr!=0)
	begin
	    hw_lut_wr_addr <= hw_lut_wr_addr + 1;
	    hw_lut_seq_id    <= sc_is_seq_id_r1;
	end

       

      if(hw_lut_wr_addr==({DAT_WIDTH-1{1'b1}}-1))
	begin
            hw_lut_wr_done   <= 1'b1;
	    st_sa_size_rdy   <= 1'b1;
	end
       
    end 
   
end 

 
endmodule 








