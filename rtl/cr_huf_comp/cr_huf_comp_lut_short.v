/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_huf_comp.vh"

module cr_huf_comp_lut_short
  (
   
   lut_short_bimc_odat, lut_short_bimc_osync,
   lut_short_sa_ro_uncorrectable_ecc_error, lut1_hw1_short_full,
   lut2_hw2_short_full, lut1_st1_short_full, lut2_st2_short_full,
   lut_sa_short_st_stcl_val, lut_sa_short_data_val, lut_sa_short_intf,
   
   clk, rst_n, lvm, mlvm, mrdten, lut_short_bimc_rst_n,
   lut_short_bimc_isync, lut_short_bimc_idat, hw1_lut1_short_wr,
   hw1_lut1_short_intf, hw2_lut2_short_wr, hw2_lut2_short_intf,
   st1_lut1_short_wr, st1_lut1_short_intf, st2_lut2_short_wr,
   st2_lut2_short_intf, sa_lut_short_intf
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

  `ifdef THESE_AUTOS_SHOULD_BE_EMPTY
   
   
  `endif
 
 
 
 input			                        clk;
 input			                        rst_n;

   
   
   
   input 					lvm;
   input 					mlvm;
   input 					mrdten;
   input 					lut_short_bimc_rst_n;
   input 					lut_short_bimc_isync;
   input 					lut_short_bimc_idat;   
   output logic 				lut_short_bimc_odat;   
   output logic 				lut_short_bimc_osync;
   output logic 				lut_short_sa_ro_uncorrectable_ecc_error;
   
 
 
 

 
 input                                         hw1_lut1_short_wr;
 input s_hw_lut_intf                           hw1_lut1_short_intf;
 
 input                                         hw2_lut2_short_wr;
 input s_hw_lut_intf                           hw2_lut2_short_intf;
 
 input                                         st1_lut1_short_wr;
 input s_st_lut_intf                           st1_lut1_short_intf;
 
 input                                         st2_lut2_short_wr;
 input s_st_lut_intf                           st2_lut2_short_intf;
 
 input s_sa_lut_intf                           sa_lut_short_intf; 
   
 
 
 

 
 output                                          lut1_hw1_short_full;
 
 output                                          lut2_hw2_short_full;
 
 output                                          lut1_st1_short_full;
 
 output                                          lut2_st2_short_full;
 
 output logic 				         lut_sa_short_st_stcl_val;
 output logic 				         lut_sa_short_data_val;
 output s_lut_sa_intf                            lut_sa_short_intf;
    
 
 
   s_lut_sa_intf lut1_sa_short_intf;
   logic         lut1_sa_short_st_stcl_val;
   logic 	 lut1_sa_short_data_val;
   logic 	 lut1_sa_st_vld;
   logic 	 lut1_sa_hw_vld;
   
   s_lut_sa_intf lut2_sa_short_intf;
   logic         lut2_sa_short_st_stcl_val;
   logic 	 lut2_sa_short_data_val;
   logic 	 lut2_sa_st_vld;
   logic 	 lut2_sa_hw_vld;

   logic 	 lut1_short_bimc_odat;
   logic 	 lut1_short_bimc_osync;
   logic 	 lut1_short_sa_ro_uncorrectable_ecc_error;
   logic 	 lut2_short_sa_ro_uncorrectable_ecc_error;
   
 
 
 
   always_comb begin
      lut_short_sa_ro_uncorrectable_ecc_error = lut1_short_sa_ro_uncorrectable_ecc_error | lut2_short_sa_ro_uncorrectable_ecc_error;
      
      lut_sa_short_intf                        = 0;
      if (lut1_sa_st_vld) begin
	 lut_sa_short_intf.hlit                = lut1_sa_short_intf.hlit;
	 lut_sa_short_intf.hdist               = lut1_sa_short_intf.hdist;
	 lut_sa_short_intf.hclen               = lut1_sa_short_intf.hclen;
	 lut_sa_short_intf.ret_stcl_size       = lut1_sa_short_intf.ret_stcl_size;
	 lut_sa_short_intf.ret_st_size         = lut1_sa_short_intf.ret_st_size;
	 lut_sa_short_intf.ret_st_stcl_rd_data = lut1_sa_short_intf.ret_st_stcl_rd_data;
	 lut_sa_short_st_stcl_val              = lut1_sa_short_st_stcl_val;
      end
      else if (lut2_sa_st_vld) begin
	 lut_sa_short_intf.hlit                = lut2_sa_short_intf.hlit;
	 lut_sa_short_intf.hdist               = lut2_sa_short_intf.hdist;
	 lut_sa_short_intf.hclen               = lut2_sa_short_intf.hclen;
	 lut_sa_short_intf.ret_stcl_size       = lut2_sa_short_intf.ret_stcl_size;
	 lut_sa_short_intf.ret_st_size         = lut2_sa_short_intf.ret_st_size;
	 lut_sa_short_intf.ret_st_stcl_rd_data = lut2_sa_short_intf.ret_st_stcl_rd_data;
	 lut_sa_short_st_stcl_val              = lut2_sa_short_st_stcl_val;
      end
      else begin
	 lut_sa_short_st_stcl_val = 0;
      end
      
      if (lut1_sa_hw_vld) begin
	 lut_sa_short_intf.ret_size      = lut1_sa_short_intf.ret_size;
	 lut_sa_short_intf.pre_size      = lut1_sa_short_intf.pre_size;
	 lut_sa_short_intf.sim_size      = lut1_sa_short_intf.sim_size;
	 lut_sa_short_intf.rd_data0      = lut1_sa_short_intf.rd_data0;
	 lut_sa_short_intf.rd_data1      = lut1_sa_short_intf.rd_data1;
	 lut_sa_short_intf.rd_data2      = lut1_sa_short_intf.rd_data2;
	 lut_sa_short_intf.rd_data3      = lut1_sa_short_intf.rd_data3;
	 lut_sa_short_data_val           = lut1_sa_short_data_val;
      end
      else if (lut2_sa_hw_vld) begin
	 lut_sa_short_intf.ret_size      = lut2_sa_short_intf.ret_size;
	 lut_sa_short_intf.pre_size      = lut2_sa_short_intf.pre_size;
	 lut_sa_short_intf.sim_size      = lut2_sa_short_intf.sim_size;
	 lut_sa_short_intf.rd_data0      = lut2_sa_short_intf.rd_data0;
	 lut_sa_short_intf.rd_data1      = lut2_sa_short_intf.rd_data1;
	 lut_sa_short_intf.rd_data2      = lut2_sa_short_intf.rd_data2;
	 lut_sa_short_intf.rd_data3      = lut2_sa_short_intf.rd_data3;
	 lut_sa_short_data_val           = lut2_sa_short_data_val; 
      end
      else begin
	 lut_sa_short_data_val           = 0;
      end
   end

 

    cr_huf_comp_lut     huff_comp_lut_inst1 (
					     
					     .lut_bimc_odat	(lut1_short_bimc_odat), 
					     .lut_bimc_osync	(lut1_short_bimc_osync), 
					     .lut_sa_ro_uncorrectable_ecc_error(lut1_short_sa_ro_uncorrectable_ecc_error), 
					     .lut_hw_full	(lut1_hw1_short_full), 
					     .lut_sa_st_vld	(lut1_sa_st_vld), 
					     .lut_sa_hclen	(lut1_sa_short_intf.hclen[`CREOLE_HC_HCLEN_WIDTH-1:0]), 
					     .lut_sa_st_stcl_val(lut1_sa_short_st_stcl_val), 
					     .lut_sa_ret_st_stcl_rd_data(lut1_sa_short_intf.ret_st_stcl_rd_data[`CREOLE_HC_HDR_WIDTH-1:0]), 
					     .lut_sa_stcl_size	(lut1_sa_short_intf.ret_stcl_size), 
					     .lut_sa_st_size	(lut1_sa_short_intf.ret_st_size), 
					     .lut_sa_hw_vld	(lut1_sa_hw_vld), 
					     .lut_sa_hlit	(lut1_sa_short_intf.hlit[`CREOLE_HC_HLIT_WIDTH-1:0]), 
					     .lut_sa_hdist	(lut1_sa_short_intf.hdist[`CREOLE_HC_HDIST_WIDTH-1:0]), 
					     .lut_sa_ret_size	(lut1_sa_short_intf.ret_size[`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0]), 
					     .lut_sa_pre_size	(lut1_sa_short_intf.pre_size[`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0]), 
					     .lut_sa_sim_size	(lut1_sa_short_intf.sim_size[`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0]), 
					     .lut_sa_data_val	(lut1_sa_short_data_val), 
					     .lut_sa_rd_data0	(lut1_sa_short_intf.rd_data0[`CREOLE_HC_HDR_WIDTH-1:0]), 
					     .lut_sa_rd_data1	(lut1_sa_short_intf.rd_data1[`CREOLE_HC_HDR_WIDTH-1:0]), 
					     .lut_sa_rd_data2	(lut1_sa_short_intf.rd_data2[`CREOLE_HC_HDR_WIDTH-1:0]), 
					     .lut_sa_rd_data3	(lut1_sa_short_intf.rd_data3[`CREOLE_HC_HDR_WIDTH-1:0]), 
					     .lut_st_full	(lut1_st1_short_full), 
					     
					     .clk		(clk),		 
					     .rst_n		(rst_n),	 
					     .lvm		(lvm),
					     .mlvm		(mlvm),
					     .mrdten		(mrdten),
					     .lut_bimc_rst_n	(lut_short_bimc_rst_n), 
					     .lut_bimc_isync	(lut_short_bimc_isync), 
					     .lut_bimc_idat	(lut_short_bimc_idat), 
					     .hw_lut_wr		(hw1_lut1_short_wr), 
					     .hw_lut_wr_val	(hw1_lut1_short_intf.wr_val), 
					     .hw_lut_wr_done	(hw1_lut1_short_intf.wr_done), 
					     .hw_lut_wr_odd	(1'b0),		 
					     .hw_lut_wr_data	(hw1_lut1_short_intf.wr_data[(2*`CREOLE_HC_HDR_WIDTH)-1:0]), 
					     .hw_lut_wr_addr	(hw1_lut1_short_intf.addr[`CREOLE_HC_SHORT_SYM_ADDR_WIDTH-2:0]), 
					     .hw_lut_sizes_val	(hw1_lut1_short_intf.sizes_val), 
					     .hw_lut_ret_size	(hw1_lut1_short_intf.ret_size[`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0]), 
					     .hw_lut_pre_size	(hw1_lut1_short_intf.pre_size[`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0]), 
					     .hw_lut_sim_size	(hw1_lut1_short_intf.sim_size[`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0]), 
					     .hw_lut_seq_id	(hw1_lut1_short_intf.seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
					     .sa_lut_ret_stcl_rd(sa_lut_short_intf.ret_stcl_rd), 
					     .sa_lut_ret_stcl_addr(sa_lut_short_intf.ret_stcl_addr[`CREOLE_HC_STCL_ADDR_WIDTH-1:0]), 
					     .sa_lut_ret_st_rd	(sa_lut_short_intf.ret_st_rd), 
					     .sa_lut_ret_st_addr(sa_lut_short_intf.ret_st_addr[`CREOLE_HC_ST_ADDR_WIDTH-1:0]), 
					     .sa_lut_data_rd	(sa_lut_short_intf.data_rd), 
					     .sa_lut_data_addr0	(sa_lut_short_intf.data_addr0[`CREOLE_HC_SHORT_SYM_ADDR_WIDTH-1:0]), 
					     .sa_lut_data_addr1	(sa_lut_short_intf.data_addr1[`CREOLE_HC_SHORT_SYM_ADDR_WIDTH-1:0]), 
					     .sa_lut_data_addr2	(sa_lut_short_intf.data_addr2[`CREOLE_HC_SHORT_SYM_ADDR_WIDTH-1:0]), 
					     .sa_lut_data_addr3	(sa_lut_short_intf.data_addr3[`CREOLE_HC_SHORT_SYM_ADDR_WIDTH-1:0]), 
					     .sa_lut_ret_ack	(sa_lut_short_intf.ret_ack), 
					     .sa_lut_seq_id	(sa_lut_short_intf.seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
					     .st_lut_wr		(st1_lut1_short_wr), 
					     .st_lut_wr_type	(st1_lut1_short_intf.wr_type), 
					     .st_lut_wr_addr	(st1_lut1_short_intf.wr_addr[`CREOLE_HC_ST_ADDR_WIDTH-1:0]), 
					     .st_lut_wr_data	(st1_lut1_short_intf.wr_data[`CREOLE_HC_HDR_WIDTH-1:0]), 
					     .st_lut_sizes_val	(st1_lut1_short_intf.sizes_val), 
					     .st_lut_seq_id	(st1_lut1_short_intf.seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
					     .st_lut_stcl_size	(st1_lut1_short_intf.stcl_size[`CREOLE_HC_STCL_MAX_BITS_WIDTH-1:0]), 
					     .st_lut_st_size	(st1_lut1_short_intf.st_size[`CREOLE_HC_ST_MAX_BITS_WIDTH-1:0]), 
					     .st_lut_hclen	(st1_lut1_short_intf.hclen[`CREOLE_HC_HCLEN_WIDTH-1:0]), 
					     .st_lut_hlit	(st1_lut1_short_intf.hlit[`CREOLE_HC_HLIT_WIDTH-1:0]), 
					     .st_lut_hdist	(st1_lut1_short_intf.hdist[`CREOLE_HC_HDIST_WIDTH-1:0]), 
					     .st_lut_wr_done	(st1_lut1_short_intf.wr_done)); 

 

    cr_huf_comp_lut     huff_comp_lut_inst2 (
					     
					     .lut_bimc_odat	(lut_short_bimc_odat), 
					     .lut_bimc_osync	(lut_short_bimc_osync), 
					     .lut_sa_ro_uncorrectable_ecc_error(lut2_short_sa_ro_uncorrectable_ecc_error), 
					     .lut_hw_full	(lut2_hw2_short_full), 
					     .lut_sa_st_vld	(lut2_sa_st_vld), 
					     .lut_sa_hclen	(lut2_sa_short_intf.hclen[`CREOLE_HC_HCLEN_WIDTH-1:0]), 
					     .lut_sa_st_stcl_val(lut2_sa_short_st_stcl_val), 
					     .lut_sa_ret_st_stcl_rd_data(lut2_sa_short_intf.ret_st_stcl_rd_data[`CREOLE_HC_HDR_WIDTH-1:0]), 
					     .lut_sa_stcl_size	(lut2_sa_short_intf.ret_stcl_size), 
					     .lut_sa_st_size	(lut2_sa_short_intf.ret_st_size), 
					     .lut_sa_hw_vld	(lut2_sa_hw_vld), 
					     .lut_sa_hlit	(lut2_sa_short_intf.hlit[`CREOLE_HC_HLIT_WIDTH-1:0]), 
					     .lut_sa_hdist	(lut2_sa_short_intf.hdist[`CREOLE_HC_HDIST_WIDTH-1:0]), 
					     .lut_sa_ret_size	(lut2_sa_short_intf.ret_size[`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0]), 
					     .lut_sa_pre_size	(lut2_sa_short_intf.pre_size[`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0]), 
					     .lut_sa_sim_size	(lut2_sa_short_intf.sim_size[`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0]), 
					     .lut_sa_data_val	(lut2_sa_short_data_val), 
					     .lut_sa_rd_data0	(lut2_sa_short_intf.rd_data0[`CREOLE_HC_HDR_WIDTH-1:0]), 
					     .lut_sa_rd_data1	(lut2_sa_short_intf.rd_data1[`CREOLE_HC_HDR_WIDTH-1:0]), 
					     .lut_sa_rd_data2	(lut2_sa_short_intf.rd_data2[`CREOLE_HC_HDR_WIDTH-1:0]), 
					     .lut_sa_rd_data3	(lut2_sa_short_intf.rd_data3[`CREOLE_HC_HDR_WIDTH-1:0]), 
					     .lut_st_full	(lut2_st2_short_full), 
					     
					     .clk		(clk),		 
					     .rst_n		(rst_n),	 
					     .lvm		(lvm),
					     .mlvm		(mlvm),
					     .mrdten		(mrdten),
					     .lut_bimc_rst_n	(lut_short_bimc_rst_n), 
					     .lut_bimc_isync	(lut1_short_bimc_osync), 
					     .lut_bimc_idat	(lut1_short_bimc_odat), 
					     .hw_lut_wr		(hw2_lut2_short_wr), 
					     .hw_lut_wr_val	(hw2_lut2_short_intf.wr_val), 
					     .hw_lut_wr_done	(hw2_lut2_short_intf.wr_done), 
					     .hw_lut_wr_odd	(1'b0),		 
					     .hw_lut_wr_data	(hw2_lut2_short_intf.wr_data[(2*`CREOLE_HC_HDR_WIDTH)-1:0]), 
					     .hw_lut_wr_addr	(hw2_lut2_short_intf.addr[`CREOLE_HC_SHORT_SYM_ADDR_WIDTH-2:0]), 
					     .hw_lut_sizes_val	(hw2_lut2_short_intf.sizes_val), 
					     .hw_lut_ret_size	(hw2_lut2_short_intf.ret_size[`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0]), 
					     .hw_lut_pre_size	(hw2_lut2_short_intf.pre_size[`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0]), 
					     .hw_lut_sim_size	(hw2_lut2_short_intf.sim_size[`CREOLE_HC_SYMB_MAX_BITS_WIDTH-1:0]), 
					     .hw_lut_seq_id	(hw2_lut2_short_intf.seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
					     .sa_lut_ret_stcl_rd(sa_lut_short_intf.ret_stcl_rd), 
					     .sa_lut_ret_stcl_addr(sa_lut_short_intf.ret_stcl_addr[`CREOLE_HC_STCL_ADDR_WIDTH-1:0]), 
					     .sa_lut_ret_st_rd	(sa_lut_short_intf.ret_st_rd), 
					     .sa_lut_ret_st_addr(sa_lut_short_intf.ret_st_addr[`CREOLE_HC_ST_ADDR_WIDTH-1:0]), 
					     .sa_lut_data_rd	(sa_lut_short_intf.data_rd), 
					     .sa_lut_data_addr0	(sa_lut_short_intf.data_addr0[`CREOLE_HC_SHORT_SYM_ADDR_WIDTH-1:0]), 
					     .sa_lut_data_addr1	(sa_lut_short_intf.data_addr1[`CREOLE_HC_SHORT_SYM_ADDR_WIDTH-1:0]), 
					     .sa_lut_data_addr2	(sa_lut_short_intf.data_addr2[`CREOLE_HC_SHORT_SYM_ADDR_WIDTH-1:0]), 
					     .sa_lut_data_addr3	(sa_lut_short_intf.data_addr3[`CREOLE_HC_SHORT_SYM_ADDR_WIDTH-1:0]), 
					     .sa_lut_ret_ack	(sa_lut_short_intf.ret_ack), 
					     .sa_lut_seq_id	(sa_lut_short_intf.seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
					     .st_lut_wr		(st2_lut2_short_wr), 
					     .st_lut_wr_type	(st2_lut2_short_intf.wr_type), 
					     .st_lut_wr_addr	(st2_lut2_short_intf.wr_addr[`CREOLE_HC_ST_ADDR_WIDTH-1:0]), 
					     .st_lut_wr_data	(st2_lut2_short_intf.wr_data[`CREOLE_HC_HDR_WIDTH-1:0]), 
					     .st_lut_sizes_val	(st2_lut2_short_intf.sizes_val), 
					     .st_lut_seq_id	(st2_lut2_short_intf.seq_id[`CREOLE_HC_SEQID_WIDTH-1:0]), 
					     .st_lut_stcl_size	(st2_lut2_short_intf.stcl_size[`CREOLE_HC_STCL_MAX_BITS_WIDTH-1:0]), 
					     .st_lut_st_size	(st2_lut2_short_intf.st_size[`CREOLE_HC_ST_MAX_BITS_WIDTH-1:0]), 
					     .st_lut_hclen	(st2_lut2_short_intf.hclen[`CREOLE_HC_HCLEN_WIDTH-1:0]), 
					     .st_lut_hlit	(st2_lut2_short_intf.hlit[`CREOLE_HC_HLIT_WIDTH-1:0]), 
					     .st_lut_hdist	(st2_lut2_short_intf.hdist[`CREOLE_HC_HDIST_WIDTH-1:0]), 
					     .st_lut_wr_done	(st2_lut2_short_intf.wr_done)); 

endmodule









