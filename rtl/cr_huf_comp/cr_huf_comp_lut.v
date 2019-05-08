/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










`include "cr_huf_comp.vh"

module cr_huf_comp_lut
  #(parameter
    N_SYMBOLS          = 576,
    N_SYMBOLS_ENTRY    = 4
   )
  (
   
   lut_bimc_odat, lut_bimc_osync, lut_sa_ro_uncorrectable_ecc_error,
   lut_hw_full, lut_sa_st_vld, lut_sa_hclen, lut_sa_st_stcl_val,
   lut_sa_ret_st_stcl_rd_data, lut_sa_stcl_size, lut_sa_st_size,
   lut_sa_hw_vld, lut_sa_hlit, lut_sa_hdist, lut_sa_ret_size,
   lut_sa_pre_size, lut_sa_sim_size, lut_sa_data_val, lut_sa_rd_data0,
   lut_sa_rd_data1, lut_sa_rd_data2, lut_sa_rd_data3, lut_st_full,
   
   clk, rst_n, lvm, mlvm, mrdten, lut_bimc_rst_n, lut_bimc_isync,
   lut_bimc_idat, hw_lut_wr, hw_lut_wr_val, hw_lut_wr_done,
   hw_lut_wr_odd, hw_lut_wr_data, hw_lut_wr_addr, hw_lut_sizes_val,
   hw_lut_ret_size, hw_lut_pre_size, hw_lut_sim_size, hw_lut_seq_id,
   sa_lut_ret_stcl_rd, sa_lut_ret_stcl_addr, sa_lut_ret_st_rd,
   sa_lut_ret_st_addr, sa_lut_data_rd, sa_lut_data_addr0,
   sa_lut_data_addr1, sa_lut_data_addr2, sa_lut_data_addr3,
   sa_lut_ret_ack, sa_lut_seq_id, st_lut_wr, st_lut_wr_type,
   st_lut_wr_addr, st_lut_wr_data, st_lut_sizes_val, st_lut_seq_id,
   st_lut_stcl_size, st_lut_st_size, st_lut_hclen, st_lut_hlit,
   st_lut_hdist, st_lut_wr_done
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;
 
   
   
   
   input                                                      clk;
   input 						      rst_n;

   
   
   
   input 			      lvm;
   input 			      mlvm;
   input 			      mrdten;
   input  			      lut_bimc_rst_n;
   input  			      lut_bimc_isync;
   input  			      lut_bimc_idat;   
   output logic  		      lut_bimc_odat;   
   output logic  		      lut_bimc_osync;
   output logic 		      lut_sa_ro_uncorrectable_ecc_error;
   
   
   
   
   input 						      hw_lut_wr;        
   input [1:0]						      hw_lut_wr_val;    
   input 						      hw_lut_wr_done;   
   input 						      hw_lut_wr_odd;    
   
   input [(2*`CREOLE_HC_HDR_WIDTH)-1:0] 		      hw_lut_wr_data;   
   input [`CREOLE_HC_SHORT_SYM_ADDR_WIDTH-2:0] 		      hw_lut_wr_addr;
   input 						      hw_lut_sizes_val; 
   
   input [`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0] 		      hw_lut_ret_size;  
   input [`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0] 		      hw_lut_pre_size;  
   input [`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0] 		      hw_lut_sim_size;  
   input [`CREOLE_HC_SEQID_WIDTH-1:0] 			      hw_lut_seq_id;    
   
   
   input 						      sa_lut_ret_stcl_rd;
   input [`CREOLE_HC_STCL_ADDR_WIDTH-1:0] 		      sa_lut_ret_stcl_addr;
   input 						      sa_lut_ret_st_rd;  
   input [`CREOLE_HC_ST_ADDR_WIDTH-1:0] 		      sa_lut_ret_st_addr;
   input 						      sa_lut_data_rd;    
   input [`CREOLE_HC_SHORT_SYM_ADDR_WIDTH-1:0] 		      sa_lut_data_addr0; 
   input [`CREOLE_HC_SHORT_SYM_ADDR_WIDTH-1:0] 		      sa_lut_data_addr1; 
   input [`CREOLE_HC_SHORT_SYM_ADDR_WIDTH-1:0] 		      sa_lut_data_addr2; 
   input [`CREOLE_HC_SHORT_SYM_ADDR_WIDTH-1:0] 		      sa_lut_data_addr3; 
   input 						      sa_lut_ret_ack;    
   input [`CREOLE_HC_SEQID_WIDTH-1:0] 			      sa_lut_seq_id;     
   
   
   input 						      st_lut_wr;      
   input 						      st_lut_wr_type; 
                                                                              
   input [`CREOLE_HC_ST_ADDR_WIDTH-1:0] 		      st_lut_wr_addr;
   input [`CREOLE_HC_HDR_WIDTH-1:0] 			      st_lut_wr_data; 
   input 						      st_lut_sizes_val;
   input [`CREOLE_HC_SEQID_WIDTH-1:0] 			      st_lut_seq_id;  
   input [`CREOLE_HC_STCL_MAX_BITS_WIDTH-1:0] 		      st_lut_stcl_size;
   input [`CREOLE_HC_ST_MAX_BITS_WIDTH-1:0] 		      st_lut_st_size;  
   input [`CREOLE_HC_HCLEN_WIDTH-1:0] 			      st_lut_hclen;    
   input [`CREOLE_HC_HLIT_WIDTH-1:0] 			      st_lut_hlit;      
   input [`CREOLE_HC_HDIST_WIDTH-1:0] 			      st_lut_hdist;     
   input 						      st_lut_wr_done; 
                                                              
   
   
   
   
   
   
   
   output logic						      lut_hw_full;    
   
   
   
   output logic 					      lut_sa_st_vld;   
   output logic [`CREOLE_HC_HCLEN_WIDTH-1:0] 		      lut_sa_hclen;   
   output logic						      lut_sa_st_stcl_val;  
   output logic [`CREOLE_HC_HDR_WIDTH-1:0] 		      lut_sa_ret_st_stcl_rd_data;  
   output logic [`CREOLE_HC_STCL_MAX_BITS_WIDTH-1:0] 	      lut_sa_stcl_size;
   output logic [`CREOLE_HC_ST_MAX_BITS_WIDTH-1:0] 	      lut_sa_st_size; 
   
   
   output logic 					      lut_sa_hw_vld;  
   output logic [`CREOLE_HC_HLIT_WIDTH-1:0] 		      lut_sa_hlit;    
   output logic [`CREOLE_HC_HDIST_WIDTH-1:0] 		      lut_sa_hdist;   
   output logic [`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0] 	      lut_sa_ret_size;
   output logic [`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0] 	      lut_sa_pre_size;
   output logic [`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0] 	      lut_sa_sim_size;
   output logic						      lut_sa_data_val;
   output logic [`CREOLE_HC_HDR_WIDTH-1:0] 		      lut_sa_rd_data0;
   output logic [`CREOLE_HC_HDR_WIDTH-1:0] 		      lut_sa_rd_data1;                           
   output logic [`CREOLE_HC_HDR_WIDTH-1:0] 		      lut_sa_rd_data2;                           
   output logic [`CREOLE_HC_HDR_WIDTH-1:0] 		      lut_sa_rd_data3;                           
   
   output logic						      lut_st_full;
  

   
   
   
   
   logic [`CREOLE_HC_SHORT_SYM_ADDR_WIDTH-1:0] 		                                             hw_rd_addr[N_SYMBOLS_ENTRY];
   logic [`CREOLE_HC_HDR_WIDTH-1:0] 								     hw_rd_data[N_SYMBOLS_ENTRY];
   logic 											     hw_rd_val[N_SYMBOLS_ENTRY];         
   logic 											     hw_full[N_SYMBOLS_ENTRY] ;          
   logic [(3*`CREOLE_HC_SYMB_MAX_BITS_WIDTH)-1:0] 						     hw_meta_data_in;
   logic [(3*`CREOLE_HC_SYMB_MAX_BITS_WIDTH)-1:0] 						     hw_meta_data_out[N_SYMBOLS_ENTRY];  
   logic [(3*`CREOLE_HC_SYMB_MAX_BITS_WIDTH)-1:0] 						     hw_meta_data;
   logic 											     hw_meta_data_val[N_SYMBOLS_ENTRY] ; 
   logic [`CREOLE_HC_SEQID_WIDTH-1:0] 								     hw_lut_seq_id_reg;
   logic 											     hw_wr_meta[N_SYMBOLS_ENTRY] ;
   logic 											     hw_wr_meta_done[N_SYMBOLS_ENTRY] ;
   logic [`CREOLE_HC_ST_ADDR_WIDTH:0] 								     st_lut_wr_addr_mod;
   logic [`CREOLE_HC_STCL_MAX_BITS_WIDTH +`CREOLE_HC_ST_MAX_BITS_WIDTH +`CREOLE_HC_HCLEN_WIDTH+`CREOLE_HC_HLIT_WIDTH +`CREOLE_HC_HDIST_WIDTH-1:0] st_meta_data_in;
   logic [`CREOLE_HC_STCL_MAX_BITS_WIDTH +`CREOLE_HC_ST_MAX_BITS_WIDTH +`CREOLE_HC_HCLEN_WIDTH+`CREOLE_HC_HLIT_WIDTH +`CREOLE_HC_HDIST_WIDTH-1:0] st_meta_data_out;
   logic [`CREOLE_HC_ST_ADDR_WIDTH:0] 								     sa_lut_st_stcl_addr;
   logic 											     st_meta_data_val;
   logic [`CREOLE_HC_HDR_WIDTH-1:0] 								     st_rd_data;
   logic 											     st_rd_val;
   logic [1:0]											     hw_lut_sizes_val_reg;
   logic 											     st_lut_sizes_val_reg;
   logic  											     st_ro_uncorrectable_ecc_error;
   logic 											     st_bimc_odat;
   logic 											     st_bimc_osync;

   logic  									                     hw_ro_uncorrectable_ecc_error[N_SYMBOLS_ENTRY-1:0];
   logic [N_SYMBOLS_ENTRY-1:0] 									     hw_bimc_odat;
   logic [N_SYMBOLS_ENTRY-1:0] 									     hw_bimc_osync;
   logic [N_SYMBOLS_ENTRY-1:0] 									     hw_bimc_idat;
   logic [N_SYMBOLS_ENTRY-1:0] 									     hw_bimc_isync;
   logic [N_SYMBOLS_ENTRY-1:0] 									     hw_ro_uncorrectable_ecc_error_pre;
   

   


   
 
 
 
   
  
   
   always_comb begin
      lut_sa_rd_data1                   =  0;
      lut_sa_rd_data1                   =  0;
      lut_sa_rd_data2                   =  0;
      lut_sa_rd_data3                   =  0;
      lut_bimc_odat                     =  hw_bimc_odat[N_SYMBOLS_ENTRY-1];   
      lut_bimc_osync                    =  hw_bimc_osync[N_SYMBOLS_ENTRY-1];
      hw_ro_uncorrectable_ecc_error_pre = 0;
      
      for (int i=0; i<N_SYMBOLS_ENTRY; i++) begin
	   if (hw_ro_uncorrectable_ecc_error[i] != 0)
	     hw_ro_uncorrectable_ecc_error_pre[i] = 1;	 
      end
	     
      for (int i=0; i<N_SYMBOLS_ENTRY; i++) begin
	 if (i==0)begin
	    hw_bimc_idat[i]  = st_bimc_odat;
	    hw_bimc_isync[i] = st_bimc_osync;
	 end
	 else begin
	    hw_bimc_idat[i]  = hw_bimc_odat[i-1];
	    hw_bimc_isync[i] = hw_bimc_osync[i-1];
	 end
      end
      for (int i=0; i<N_SYMBOLS_ENTRY; i++) begin
	 case (i)
	   0:       hw_rd_addr[0]      = sa_lut_data_addr0;
	   1:       hw_rd_addr[1]      = sa_lut_data_addr1; 
	   2:       hw_rd_addr[2]      = sa_lut_data_addr2; 
	   default: hw_rd_addr[3]      = sa_lut_data_addr3; 
	 endcase
      end
      lut_hw_full        = hw_full[0];
      for (int i=0; i<N_SYMBOLS_ENTRY; i++) begin
	 case (i)
	   0:       lut_sa_rd_data0    = hw_rd_data[0];
	   1:       lut_sa_rd_data1    = hw_rd_data[1]; 
	   2:       lut_sa_rd_data2    = hw_rd_data[2]; 
	   default: lut_sa_rd_data3    = hw_rd_data[3]; 
	 endcase 
      end
      lut_sa_ret_st_stcl_rd_data    = st_rd_data;
      lut_sa_data_val    = hw_rd_val[0];
      hw_meta_data_in    = {hw_lut_ret_size, hw_lut_pre_size, hw_lut_sim_size};
      for (int i=0; i<N_SYMBOLS_ENTRY; i++) begin
	 hw_wr_meta[i]        = 0;
	 hw_wr_meta_done[i]   = 0;
      end
      hw_wr_meta[0]      = hw_lut_sizes_val_reg[0]; 
      hw_wr_meta_done[0] = hw_lut_sizes_val_reg[1] & ~hw_lut_sizes_val_reg[0]; 
      hw_meta_data       = hw_meta_data_out[0];
      lut_sa_sim_size    = hw_meta_data[   `CREOLE_HC_SYMB_MAX_BITS_WIDTH -1:0];
      lut_sa_pre_size    = hw_meta_data[(2*`CREOLE_HC_SYMB_MAX_BITS_WIDTH)-1:   `CREOLE_HC_SYMB_MAX_BITS_WIDTH];
      lut_sa_ret_size    = hw_meta_data[(3*`CREOLE_HC_SYMB_MAX_BITS_WIDTH)-1:(2*`CREOLE_HC_SYMB_MAX_BITS_WIDTH)];
      lut_sa_hw_vld      = hw_meta_data_val[0];
      st_meta_data_in    = {st_lut_hlit, st_lut_hdist, st_lut_stcl_size, st_lut_st_size, st_lut_hclen};
      lut_sa_hclen       = st_meta_data_out[`CREOLE_HC_HCLEN_WIDTH-1:0]; 
      lut_sa_st_size     = st_meta_data_out[`CREOLE_HC_HCLEN_WIDTH+`CREOLE_HC_ST_MAX_BITS_WIDTH-1:`CREOLE_HC_HCLEN_WIDTH];   
      lut_sa_stcl_size   = st_meta_data_out[`CREOLE_HC_HCLEN_WIDTH+`CREOLE_HC_ST_MAX_BITS_WIDTH+`CREOLE_HC_STCL_MAX_BITS_WIDTH-1:`CREOLE_HC_HCLEN_WIDTH+`CREOLE_HC_ST_MAX_BITS_WIDTH];
      lut_sa_hdist       = st_meta_data_out[`CREOLE_HC_HCLEN_WIDTH+`CREOLE_HC_ST_MAX_BITS_WIDTH+`CREOLE_HC_STCL_MAX_BITS_WIDTH+`CREOLE_HC_HDIST_WIDTH-1:`CREOLE_HC_HCLEN_WIDTH+`CREOLE_HC_ST_MAX_BITS_WIDTH+`CREOLE_HC_STCL_MAX_BITS_WIDTH];
      lut_sa_hlit        = st_meta_data_out[`CREOLE_HC_HCLEN_WIDTH+`CREOLE_HC_ST_MAX_BITS_WIDTH+`CREOLE_HC_STCL_MAX_BITS_WIDTH+`CREOLE_HC_HDIST_WIDTH+`CREOLE_HC_HLIT_WIDTH-1:`CREOLE_HC_HCLEN_WIDTH+`CREOLE_HC_ST_MAX_BITS_WIDTH+`CREOLE_HC_STCL_MAX_BITS_WIDTH+`CREOLE_HC_HDIST_WIDTH];
      lut_sa_st_vld      = st_meta_data_val;
      lut_sa_st_stcl_val = st_rd_val;
      
      if (st_lut_wr_type)
	st_lut_wr_addr_mod  = st_lut_wr_addr;
      else
	st_lut_wr_addr_mod  = st_lut_wr_addr+`CREOLE_HC_ST_TBL_ENTRIES;          
      if (sa_lut_ret_st_rd)
	sa_lut_st_stcl_addr = sa_lut_ret_st_addr; 
      else
	sa_lut_st_stcl_addr = sa_lut_ret_stcl_addr + `CREOLE_HC_ST_TBL_ENTRIES;  
   end 

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
	 hw_lut_sizes_val_reg                <= 0;
	 st_lut_sizes_val_reg                <= 0;
	 lut_sa_ro_uncorrectable_ecc_error   <= 0;
	 hw_lut_seq_id_reg                   <= 0;
      end
      else begin
	 hw_lut_seq_id_reg                   <= hw_lut_seq_id;
	 hw_lut_sizes_val_reg                <= {hw_lut_sizes_val_reg[0], hw_lut_sizes_val};
	 st_lut_sizes_val_reg                <= st_lut_sizes_val;
	 if ((st_ro_uncorrectable_ecc_error != 0) || (hw_ro_uncorrectable_ecc_error_pre != 0))
	   lut_sa_ro_uncorrectable_ecc_error <= 1;
	 else
	   lut_sa_ro_uncorrectable_ecc_error <= 0;
      end
   end
   
   
   cr_huf_comp_twin_buffer 
     #(.N_WORDS              (`CREOLE_HC_ST_TBL_ENTRIES+`CREOLE_HC_STCL_TBL_ENTRIES),		         
       .WORD_WIDTH	     (`CREOLE_HC_HDR_WIDTH),	 
       .N_WORDS_PER_ENTRY    (1), 
       .N_RD_WORDS_PER_ENTRY (1),
       .META_DATA_WIDTH      (`CREOLE_HC_STCL_MAX_BITS_WIDTH+`CREOLE_HC_ST_MAX_BITS_WIDTH+`CREOLE_HC_HCLEN_WIDTH+`CREOLE_HC_HLIT_WIDTH+`CREOLE_HC_HDIST_WIDTH),
       .SPECIALIZE           (1),
       .SINGLE_PORT          (1))
   st_tables
   (
    
    .full			(lut_st_full),
    .meta_full	       		(),
    .rd_out			(st_rd_data),
    .rd_valid_word		(st_rd_val),
    .rd_meta_data               (st_meta_data_out), 
    .rd_meta_vld                (st_meta_data_val),
    .ro_uncorrectable_ecc_error	(st_ro_uncorrectable_ecc_error),
    .bimc_odat			(st_bimc_odat),
    .bimc_osync			(st_bimc_osync),
    
    .clk			(clk),
    .rst_n			(rst_n),
    .wr				(st_lut_wr),
    .wr_done			(st_lut_wr_done & st_lut_wr_type),
    .wr_addr			(st_lut_wr_addr_mod),
    .wr_data			(st_lut_wr_data),
    .wr_valid_word		(1'b1),
    .wr_meta                    (st_lut_sizes_val),
    .wr_meta_data               (st_meta_data_in),
    .wr_meta_done               (st_lut_sizes_val_reg & ~st_lut_sizes_val),
    .wr_seq_id			(st_lut_seq_id),
    .rd				(sa_lut_ret_st_rd | sa_lut_ret_stcl_rd),
    .rd_addr			(sa_lut_st_stcl_addr),
    .rd_done			(sa_lut_ret_ack),
    .rd_meta_done		(sa_lut_ret_ack),
    .rd_seq_id			(sa_lut_seq_id),
    .bimc_isync			(lut_bimc_isync),
    .bimc_idat			(lut_bimc_idat),
    .lvm			(lvm),
    .mlvm			(mlvm),
    .mrdten			(mrdten),
    .ovstb                      (1'b1));
   
   
   generate
      for (genvar i=0; i<N_SYMBOLS_ENTRY; i++)
	begin : hw_mem
	   cr_huf_comp_twin_buffer 
		    #(.N_WORDS              (N_SYMBOLS),		         
		      .WORD_WIDTH	    (`CREOLE_HC_HDR_WIDTH),	 
		      .N_WORDS_PER_ENTRY    (2), 
		      .N_RD_WORDS_PER_ENTRY (1),
		      .META_DATA_WIDTH      (3*`CREOLE_HC_SYMB_MAX_BITS_WIDTH),
		      .SPECIALIZE           (1),
                      .SINGLE_PORT          (0))
	   hw_tables
		    (
		     
		     .full				(hw_full[i]),
		     .meta_full				(),
		     .rd_out				(hw_rd_data[i]),
		     .rd_valid_word			(hw_rd_val[i]),
		     .rd_meta_data                      (hw_meta_data_out[i]), 
		     .rd_meta_vld                       (hw_meta_data_val[i]),
		     .ro_uncorrectable_ecc_error	(hw_ro_uncorrectable_ecc_error[i]),
		     .bimc_odat				(hw_bimc_odat[i]),
		     .bimc_osync			(hw_bimc_osync[i]),
		     
		     .clk				(clk),
		     .rst_n				(rst_n),
		     .wr				(hw_lut_wr),
		     .wr_done				(hw_lut_wr_done),
		     .wr_addr				(hw_lut_wr_addr),
		     .wr_data				(hw_lut_wr_data),
		     .wr_valid_word			(hw_lut_wr_val),
		     .wr_meta                           (hw_wr_meta[i]),
		     .wr_meta_done                      (hw_wr_meta_done[i]), 
		     .wr_meta_data                      (hw_meta_data_in),
		     .wr_seq_id				(hw_lut_seq_id_reg),
		     .rd				(sa_lut_data_rd),
		     .rd_addr				(hw_rd_addr[i]),
		     .rd_done				(sa_lut_ret_ack),
		     .rd_meta_done			(sa_lut_ret_ack),
		     .rd_seq_id				(sa_lut_seq_id),
		     .bimc_isync			(hw_bimc_isync[i]),
		     .bimc_idat				(hw_bimc_idat[i]),
		     .lvm				(lvm),
		     .mlvm				(mlvm),
		     .mrdten				(mrdten),
                     .ovstb                             (1'b1));
	end
   endgenerate
   
endmodule 








