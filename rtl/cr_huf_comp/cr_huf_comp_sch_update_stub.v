/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
  
  
   reg                  rqe_word_1;
   reg [15:0] 		scheduler_handle;
   reg [23:0] 		num_bytes;
   reg 			data_word_n;
   reg  		emit_scheduler;
   reg [10:0] 		tlv_frame_num;
   reg [3:0] 		tlv_eng_id;
   reg [7:0] 		tlv_seq_num;
   
   
   wire 		sot = huf_comp_ib_in.tvalid & huf_comp_ob_in_mod.tready & huf_comp_ib_in.tuser[0];
   wire 		eot = huf_comp_ib_in.tvalid & huf_comp_ob_in_mod.tready & huf_comp_ib_in.tuser[1];
   wire 		mot = huf_comp_ib_in.tvalid & huf_comp_ob_in_mod.tready;
   
   wire 		tlv_is_rqe  = tlv_types_e'(huf_comp_ib_in.tdata[7:0]) == RQE;
   wire 		tlv_is_data = tlv_types_e'(huf_comp_ib_in.tdata[7:0]) == DATA_UNK;
   wire 		tlv_is_lz77 = tlv_types_e'(huf_comp_ib_in.tdata[7:0]) == LZ77;
   
   always @(posedge clk or negedge rst_n)
     begin
	if (!rst_n)
	  begin
	     
	     
	     data_word_n <= 0;
	     emit_scheduler <= 0;
	     huf_comp_sch_update.basis <= 0;
	     huf_comp_sch_update.bytes_in <= 0;
	     huf_comp_sch_update.bytes_out <= 0;
	     huf_comp_sch_update.last <= 0;
	     huf_comp_sch_update.rqe_sched_handle <= 0;
	     huf_comp_sch_update.tlv_frame_num <= 0;
	     huf_comp_sch_update.valid <= 0;
	     num_bytes <= 0;
	     rqe_word_1 <= 0;
	     scheduler_handle <= 0;
	     tlv_eng_id <= 0;
	     tlv_frame_num <= 0;
	     tlv_seq_num <= 0;
	     
	     
	  end
	else
	  begin
	     huf_comp_sch_update.valid <= 0 ;

	     
	     if (sot & tlv_is_rqe) begin
		rqe_word_1 <= 1;
		tlv_frame_num <= huf_comp_ib_in.tdata[42:32];
		
		tlv_eng_id <= huf_comp_ib_in.tdata[27:24];
		tlv_seq_num <= huf_comp_ib_in.tdata[23:16];
	     end

	     if (rqe_word_1 & mot)
	       begin
		  scheduler_handle <= huf_comp_ib_in.tdata[47:32];
		  rqe_word_1 <= 0;
	       end
	     

	     
	     if (sot & tlv_is_data) begin
		num_bytes   <= 0;		
		data_word_n <= 1;
	     end

	     if (sot & tlv_is_lz77) begin
		num_bytes   <= 0;		
		data_word_n <= 0;
	     end

	     if (data_word_n & (eot | mot))
	       num_bytes <= num_bytes + 
			    huf_comp_ib_in.tstrb[0] + huf_comp_ib_in.tstrb[1] + huf_comp_ib_in.tstrb[2] + huf_comp_ib_in.tstrb[3] +
			    huf_comp_ib_in.tstrb[4] + huf_comp_ib_in.tstrb[5] + huf_comp_ib_in.tstrb[6] + huf_comp_ib_in.tstrb[7] ;

	     if (data_word_n & eot) begin
		data_word_n    <= 0;
		emit_scheduler <= 1;
	     end
	  		
	     if (emit_scheduler)
	       begin
		  emit_scheduler <= 0;		  
		  huf_comp_sch_update.valid <= 1;
		  huf_comp_sch_update.rqe_sched_handle <= scheduler_handle;
		  huf_comp_sch_update.last <= 1;
		  huf_comp_sch_update.tlv_frame_num <= tlv_frame_num;
		  huf_comp_sch_update.tlv_eng_id    <= tlv_eng_id;
		  huf_comp_sch_update.tlv_seq_num   <= tlv_seq_num;
		  huf_comp_sch_update.bytes_in      <= num_bytes;
		  huf_comp_sch_update.bytes_out     <= num_bytes;
		  huf_comp_sch_update.basis         <= num_bytes;		  
	       end	     
	  end
     end
   