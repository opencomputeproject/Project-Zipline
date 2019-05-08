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
   reg       		emit_scheduler;
   reg [10:0] 		tlv_frame_num;
   reg [3:0] 		tlv_eng_id;
   reg [7:0] 		tlv_seq_num;
   
   
   wire 		sot = xp10_decomp_ib_in.tvalid & xp10_decomp_ob_in.tready & xp10_decomp_ib_in.tuser[0];
   wire 		eot = xp10_decomp_ib_in.tvalid & xp10_decomp_ob_in.tready & xp10_decomp_ib_in.tuser[1];
   wire 		mot = xp10_decomp_ib_in.tvalid & xp10_decomp_ob_in.tready;
   
   wire 		tlv_is_rqe  = tlv_types_e'(xp10_decomp_ib_in.tdata[7:0]) == RQE;
   wire 		tlv_is_data = tlv_types_e'(xp10_decomp_ib_in.tdata[7:0]) == DATA_UNK;
   
   always @(posedge clk or negedge rst_n)
     begin
	if (!rst_n)
	  begin
	     
	     
	     data_word_n <= 0;
	     emit_scheduler <= 0;
	     xp10_decomp_sch_update.basis <= 0;
	     xp10_decomp_sch_update.bytes_in <= 0;
	     xp10_decomp_sch_update.bytes_out <= 0;
	     xp10_decomp_sch_update.last <= 0;
	     xp10_decomp_sch_update.rqe_sched_handle <= 0;
	     xp10_decomp_sch_update.tlv_frame_num <= 0;
	     xp10_decomp_sch_update.valid <= 0;
	     num_bytes <= 0;
	     rqe_word_1 <= 0;
	     scheduler_handle <= 0;
	     tlv_eng_id <= 0;
	     tlv_frame_num <= 0;
	     tlv_seq_num <= 0;
	     
	     
	  end
	else
	  begin
	     xp10_decomp_sch_update.valid <= 0 ;

	     
	     if (sot & tlv_is_rqe) begin
		rqe_word_1 <= 1;
		tlv_frame_num <= xp10_decomp_ib_in.tdata[42:32];
		
		tlv_eng_id <= xp10_decomp_ib_in.tdata[27:24];
		tlv_seq_num <= xp10_decomp_ib_in.tdata[23:16];
	     end

	     if (rqe_word_1 & mot)
	       begin
		  scheduler_handle <= xp10_decomp_ib_in.tdata[47:32];
		  rqe_word_1 <= 0;
	       end
	     

	     
	     if (sot & tlv_is_data) begin
		num_bytes <= 0;		
		data_word_n <= 1;
	     end

	     if (data_word_n & (eot | mot))
	       num_bytes <= num_bytes + 
			    xp10_decomp_ib_in.tstrb[0] + xp10_decomp_ib_in.tstrb[1] + xp10_decomp_ib_in.tstrb[2] + xp10_decomp_ib_in.tstrb[3] +
			    xp10_decomp_ib_in.tstrb[4] + xp10_decomp_ib_in.tstrb[5] + xp10_decomp_ib_in.tstrb[6] + xp10_decomp_ib_in.tstrb[7] ;

	     if (data_word_n & eot) begin
		data_word_n <= 0;
		emit_scheduler <= 1;
	     end
	  		
	     if (emit_scheduler)
	       begin
		  emit_scheduler <= 0;		  
		  xp10_decomp_sch_update.valid <= 1;
		  xp10_decomp_sch_update.rqe_sched_handle <= scheduler_handle;
		  xp10_decomp_sch_update.last <= 1;
		  xp10_decomp_sch_update.tlv_frame_num <= tlv_frame_num;
		  xp10_decomp_sch_update.tlv_eng_id    <= tlv_eng_id;
		  xp10_decomp_sch_update.tlv_seq_num   <= tlv_seq_num;
		  xp10_decomp_sch_update.bytes_in      <= num_bytes;
		  xp10_decomp_sch_update.bytes_out     <= num_bytes;
		  xp10_decomp_sch_update.basis         <= num_bytes;		  
	       end	     
	  end
     end
   