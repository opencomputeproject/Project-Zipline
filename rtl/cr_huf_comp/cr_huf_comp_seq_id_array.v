/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_huf_comp.vh"

module cr_huf_comp_seq_id_array
  (
   
   seq_id_intf_array, seq_id_intf_array_vld, hdr_short_ht1_type,
   hdr_short_ht2_type, hdr_long_ht1_type, hdr_long_ht2_type,
   hdr_short_hw1_type, hdr_short_hw2_type, hdr_long_hw1_type,
   hdr_long_hw2_type, hdr_short_st1_type, hdr_short_st2_type,
   hdr_long_st1_type, hdr_long_st2_type,
   
   clk, rst_n, sm_seq_id_wr_intf, sm_seq_id_intf, sa_sm_intf,
   short_ht1_hdr_seq_id, short_ht2_hdr_seq_id, long_ht1_hdr_seq_id,
   long_ht2_hdr_seq_id, short_hw1_hdr_seq_id, short_hw2_hdr_seq_id,
   long_hw1_hdr_seq_id, long_hw2_hdr_seq_id, short_st1_hdr_seq_id,
   short_st2_hdr_seq_id, long_st1_hdr_seq_id, long_st2_hdr_seq_id
   );
   
`include "cr_structs.sv"
   
   import cr_huf_compPKG::*;
   import cr_huf_comp_regsPKG::*;
   
   
   
   input                              clk;
   input 			      rst_n;

   
   
   
   input s_sm_seq_id_wr_intf          sm_seq_id_wr_intf;
   input s_sm_seq_id_intf             sm_seq_id_intf;

   
   
   
   input  s_sa_sm_intf                 sa_sm_intf;

   
   
   
   output s_sm_seq_id_intf                 seq_id_intf_array[`CREOLE_HC_SEQID_NUM];
   output logic [`CREOLE_HC_SEQID_NUM-1:0] seq_id_intf_array_vld;

   
   input [`CREOLE_HC_SEQID_WIDTH-1:0] short_ht1_hdr_seq_id;   
   input [`CREOLE_HC_SEQID_WIDTH-1:0] short_ht2_hdr_seq_id;   
   input [`CREOLE_HC_SEQID_WIDTH-1:0] long_ht1_hdr_seq_id;		
   input [`CREOLE_HC_SEQID_WIDTH-1:0] long_ht2_hdr_seq_id;
   input [`CREOLE_HC_SEQID_WIDTH-1:0] short_hw1_hdr_seq_id; 
   input [`CREOLE_HC_SEQID_WIDTH-1:0] short_hw2_hdr_seq_id;
   input [`CREOLE_HC_SEQID_WIDTH-1:0] long_hw1_hdr_seq_id; 
   input [`CREOLE_HC_SEQID_WIDTH-1:0] long_hw2_hdr_seq_id;
   input [`CREOLE_HC_SEQID_WIDTH-1:0] short_st1_hdr_seq_id;
   input [`CREOLE_HC_SEQID_WIDTH-1:0] short_st2_hdr_seq_id;
   input [`CREOLE_HC_SEQID_WIDTH-1:0] long_st1_hdr_seq_id;
   input [`CREOLE_HC_SEQID_WIDTH-1:0] long_st2_hdr_seq_id;

   output s_seq_id_type_intf	      hdr_short_ht1_type;
   output s_seq_id_type_intf	      hdr_short_ht2_type;   
   output s_seq_id_type_intf	      hdr_long_ht1_type;
   output s_seq_id_type_intf	      hdr_long_ht2_type;
   output s_seq_id_type_intf	      hdr_short_hw1_type;
   output s_seq_id_type_intf	      hdr_short_hw2_type;   
   output s_seq_id_type_intf	      hdr_long_hw1_type;
   output s_seq_id_type_intf	      hdr_long_hw2_type;
   output s_seq_id_type_intf	      hdr_short_st1_type;
   output s_seq_id_type_intf	      hdr_short_st2_type;   
   output s_seq_id_type_intf	      hdr_long_st1_type;
   output s_seq_id_type_intf	      hdr_long_st2_type;
   
   always_comb begin
      hdr_short_ht1_type.comp_mode = seq_id_intf_array[short_ht1_hdr_seq_id].comp_mode;
      hdr_short_ht2_type.comp_mode = seq_id_intf_array[short_ht2_hdr_seq_id].comp_mode;      
      hdr_long_ht1_type.comp_mode  = seq_id_intf_array[long_ht1_hdr_seq_id].comp_mode;
      hdr_long_ht2_type.comp_mode  = seq_id_intf_array[long_ht2_hdr_seq_id].comp_mode;      
      hdr_short_hw1_type.comp_mode = seq_id_intf_array[short_hw1_hdr_seq_id].comp_mode;
      hdr_short_hw2_type.comp_mode = seq_id_intf_array[short_hw2_hdr_seq_id].comp_mode;      
      hdr_long_hw1_type.comp_mode  = seq_id_intf_array[long_hw1_hdr_seq_id].comp_mode;
      hdr_long_hw2_type.comp_mode  = seq_id_intf_array[long_hw2_hdr_seq_id].comp_mode;      
      hdr_short_st1_type.comp_mode = seq_id_intf_array[short_st1_hdr_seq_id].comp_mode;
      hdr_short_st2_type.comp_mode = seq_id_intf_array[short_st2_hdr_seq_id].comp_mode;      
      hdr_long_st1_type.comp_mode  = seq_id_intf_array[long_st1_hdr_seq_id].comp_mode;
      hdr_long_st2_type.comp_mode  = seq_id_intf_array[long_st2_hdr_seq_id].comp_mode;
      
      hdr_short_ht1_type.lz77_win_size = seq_id_intf_array[short_ht1_hdr_seq_id].lz77_win_size;
      hdr_short_ht2_type.lz77_win_size = seq_id_intf_array[short_ht2_hdr_seq_id].lz77_win_size;      
      hdr_long_ht1_type.lz77_win_size  = seq_id_intf_array[long_ht1_hdr_seq_id].lz77_win_size;
      hdr_long_ht2_type.lz77_win_size  = seq_id_intf_array[long_ht2_hdr_seq_id].lz77_win_size;      
      hdr_short_hw1_type.lz77_win_size = seq_id_intf_array[short_hw1_hdr_seq_id].lz77_win_size;
      hdr_short_hw2_type.lz77_win_size = seq_id_intf_array[short_hw2_hdr_seq_id].lz77_win_size;      
      hdr_long_hw1_type.lz77_win_size  = seq_id_intf_array[long_hw1_hdr_seq_id].lz77_win_size;
      hdr_long_hw2_type.lz77_win_size  = seq_id_intf_array[long_hw2_hdr_seq_id].lz77_win_size;      
      hdr_short_st1_type.lz77_win_size = seq_id_intf_array[short_st1_hdr_seq_id].lz77_win_size;
      hdr_short_st2_type.lz77_win_size = seq_id_intf_array[short_st2_hdr_seq_id].lz77_win_size;      
      hdr_long_st1_type.lz77_win_size  = seq_id_intf_array[long_st1_hdr_seq_id].lz77_win_size;
      hdr_long_st2_type.lz77_win_size  = seq_id_intf_array[long_st2_hdr_seq_id].lz77_win_size;
      
      hdr_short_ht1_type.xp10_prefix_mode = NO_PREFIX;
      hdr_short_ht2_type.xp10_prefix_mode = NO_PREFIX; 
      hdr_long_ht1_type.xp10_prefix_mode  = NO_PREFIX;
      hdr_long_ht2_type.xp10_prefix_mode  = NO_PREFIX;
      hdr_short_hw1_type.xp10_prefix_mode = NO_PREFIX;
      hdr_short_hw2_type.xp10_prefix_mode = NO_PREFIX; 
      hdr_long_hw1_type.xp10_prefix_mode  = NO_PREFIX;
      hdr_long_hw2_type.xp10_prefix_mode  = NO_PREFIX;
      hdr_short_st1_type.xp10_prefix_mode = NO_PREFIX;
      hdr_short_st2_type.xp10_prefix_mode = NO_PREFIX;  
      hdr_long_st1_type.xp10_prefix_mode  = NO_PREFIX;
      hdr_long_st2_type.xp10_prefix_mode  = NO_PREFIX;

      
      if (seq_id_intf_array[short_ht1_hdr_seq_id].predet_mem_mask)
	hdr_short_ht1_type.xp10_prefix_mode = seq_id_intf_array[short_ht1_hdr_seq_id].xp10_prefix_mode;      
      if (seq_id_intf_array[short_ht2_hdr_seq_id].predet_mem_mask)
	hdr_short_ht2_type.xp10_prefix_mode = seq_id_intf_array[short_ht2_hdr_seq_id].xp10_prefix_mode;      
      if (seq_id_intf_array[long_ht1_hdr_seq_id].predet_mem_mask)
	hdr_long_ht1_type.xp10_prefix_mode  = seq_id_intf_array[long_ht1_hdr_seq_id].xp10_prefix_mode;      
      if (seq_id_intf_array[long_ht2_hdr_seq_id].predet_mem_mask)
	hdr_long_ht2_type.xp10_prefix_mode  = seq_id_intf_array[long_ht2_hdr_seq_id].xp10_prefix_mode;      
      if (seq_id_intf_array[short_hw1_hdr_seq_id].predet_mem_mask)
	hdr_short_hw1_type.xp10_prefix_mode = seq_id_intf_array[short_hw1_hdr_seq_id].xp10_prefix_mode;      
      if (seq_id_intf_array[short_hw2_hdr_seq_id].predet_mem_mask)
	hdr_short_hw2_type.xp10_prefix_mode = seq_id_intf_array[short_hw2_hdr_seq_id].xp10_prefix_mode;      
      if (seq_id_intf_array[long_hw1_hdr_seq_id].predet_mem_mask)
	hdr_long_hw1_type.xp10_prefix_mode  = seq_id_intf_array[long_hw1_hdr_seq_id].xp10_prefix_mode;      
      if (seq_id_intf_array[long_hw2_hdr_seq_id].predet_mem_mask)
	hdr_long_hw2_type.xp10_prefix_mode  = seq_id_intf_array[long_hw2_hdr_seq_id].xp10_prefix_mode;      
      if (seq_id_intf_array[short_st1_hdr_seq_id].predet_mem_mask)
	hdr_short_st1_type.xp10_prefix_mode = seq_id_intf_array[short_st1_hdr_seq_id].xp10_prefix_mode;      
      if (seq_id_intf_array[short_st2_hdr_seq_id].predet_mem_mask)
	hdr_short_st2_type.xp10_prefix_mode = seq_id_intf_array[short_st2_hdr_seq_id].xp10_prefix_mode;      
      if (seq_id_intf_array[long_st1_hdr_seq_id].predet_mem_mask)
	hdr_long_st1_type.xp10_prefix_mode  = seq_id_intf_array[long_st1_hdr_seq_id].xp10_prefix_mode;      
      if (seq_id_intf_array[long_st2_hdr_seq_id].predet_mem_mask)
	hdr_long_st2_type.xp10_prefix_mode  = seq_id_intf_array[long_st2_hdr_seq_id].xp10_prefix_mode;
   end
   
   

   
   always_ff @(negedge rst_n or posedge clk) begin
      if (!rst_n) begin
	 for (int i=0; i<`CREOLE_HC_SEQID_NUM; i++)
	   seq_id_intf_array[i] <= 0;
	 
	 
	 seq_id_intf_array_vld <= 0;
	 
      end
      else begin
	 if (sm_seq_id_wr_intf.vld) begin
	    seq_id_intf_array[sm_seq_id_wr_intf.seq_id]                  <= sm_seq_id_intf;
	    seq_id_intf_array_vld[sm_seq_id_wr_intf.seq_id]              <= 1;
	 end
	 if (sm_seq_id_wr_intf.vld_crc) begin
	    seq_id_intf_array[sm_seq_id_wr_intf.seq_id].raw_crc          <= sm_seq_id_intf.raw_crc;
	 end
	 if (sa_sm_intf.vld) begin
	    seq_id_intf_array_vld[sa_sm_intf.seq_id]                     <= 1'd0;
	 end
      end
   end
   
endmodule 








