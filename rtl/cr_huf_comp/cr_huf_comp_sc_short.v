/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_huf_comp.vh"

module cr_huf_comp_sc_short
  (
   
   sc_short_bimc_odat, sc_short_bimc_osync,
   sc_short_sa_ro_uncorrectable_ecc_error, sc_sm_shrt_intf,
   sc_is_short_intf, sc_is_short_vld,
   
   clk, rst_n, lvm, mlvm, mrdten, sc_short_bimc_rst_n,
   sc_short_bimc_isync, sc_short_bimc_idat, sm_sc_shrt_intf,
   is_sc_short_rd
   );
   
`include "cr_structs.sv"
   
   import cr_huf_compPKG::*;
   import cr_huf_comp_regsPKG::*;
   
   
   
   input                               clk;
   input 			       rst_n;
   
   
   
   input 			      lvm;
   input 			      mlvm;
   input 			      mrdten;
   input  			      sc_short_bimc_rst_n;
   input  			      sc_short_bimc_isync;
   input  			      sc_short_bimc_idat;   
   output logic  		      sc_short_bimc_odat;   
   output logic  		      sc_short_bimc_osync;
   output logic 		      sc_short_sa_ro_uncorrectable_ecc_error;
   
   
   
   input  s_sm_sc_shrt_intf            sm_sc_shrt_intf;
   output s_sc_sm_shrt_intf            sc_sm_shrt_intf;
   
   
   
   
   input                               is_sc_short_rd;
   output s_sc_is_short_intf           sc_is_short_intf;
   output logic [3:0]                  sc_is_short_vld;
   
   
   
      
   
   
   logic		empty;			
   logic		full;			
   logic		overflow;		
   logic		underflow;		
   



   logic             mtch_0_1;
   logic 	     mtch_0_2;
   logic 	     mtch_0_3;
   logic 	     mtch_1_2;
   logic 	     mtch_1_3;
   logic 	     mtch_2_3;
   logic [57:0]      rd_data;
   logic [57:0]      wr_data;
   logic 	     wr;
   logic 	     aempty;  
   logic 	     fifo_rd;
   logic [`LOG_VEC(257)] free_slots;		
   logic [`LOG_VEC(257)] used_slots;		
   
   
   always_comb begin
      sc_is_short_intf       = 0;
      fifo_rd                = 0;
      if (is_sc_short_rd && used_slots > 0)
	fifo_rd              = 1;
      mtch_0_1               = sm_sc_shrt_intf.shrt0 == sm_sc_shrt_intf.shrt1;
      mtch_0_2               = sm_sc_shrt_intf.shrt0 == sm_sc_shrt_intf.shrt2;
      mtch_0_3               = sm_sc_shrt_intf.shrt0 == sm_sc_shrt_intf.shrt3;
      mtch_1_2               = sm_sc_shrt_intf.shrt1 == sm_sc_shrt_intf.shrt2;
      mtch_1_3               = sm_sc_shrt_intf.shrt1 == sm_sc_shrt_intf.shrt3;
      mtch_2_3               = sm_sc_shrt_intf.shrt2 == sm_sc_shrt_intf.shrt3;
      
      sc_sm_shrt_intf.rdy    = free_slots > 4;
      aempty                 = 0;
      
      if (used_slots <= 1)
	aempty = 1;
      
      if (!empty)
	sc_is_short_vld = 4'b1111;
      else
	sc_is_short_vld = 4'b0000;
      
      sc_is_short_intf.short0 = rd_data[57:48];
      sc_is_short_intf.short1 = rd_data[47:38];
      sc_is_short_intf.short2 = rd_data[37:28];
      sc_is_short_intf.short3 = rd_data[27:18];
      sc_is_short_intf.cnt3   = rd_data[17:15];
      sc_is_short_intf.cnt2   = rd_data[14:12];
      sc_is_short_intf.cnt1   = rd_data[11:9];
      sc_is_short_intf.cnt0   = rd_data[8:6];
      sc_is_short_intf.seq_id = rd_data[5:2];
      sc_is_short_intf.eob    = e_pipe_eob'(rd_data[1:0]);
      
   end

   
   always_ff @(negedge rst_n or posedge clk) begin
      if (!rst_n) begin
	 
	 
	 
	 wr <= 0;
	 wr_data <= 0;
	 
      end
      else begin
	 wr    <= 1'd0;
	 if (sm_sc_shrt_intf.wr) begin
	    wr <= 1'd1;
	    
	    if (sm_sc_shrt_intf.vld == 4'b1111) begin
	       case ({mtch_2_3, mtch_1_3, mtch_1_2, mtch_0_3, mtch_0_2, mtch_0_1})
		 
		 6'b000000: wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt1, 
					sm_sc_shrt_intf.shrt2, 
					sm_sc_shrt_intf.shrt3, 
					  3'd1,3'd1,3'd1,3'd1,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 6'b000001: wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt2, 
					sm_sc_shrt_intf.shrt3, 
					                10'd0, 
					  3'd0,3'd1,3'd1,3'd2,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 
		 6'b100001: wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt2, 
					                10'd0, 
					                10'd0, 
					  3'd0,3'd0,3'd2,3'd2,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 
		 6'b000010: wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt1, 
					sm_sc_shrt_intf.shrt3, 
					                10'd0, 
					  3'd0,3'd1,3'd1,3'd2,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 6'b010010: wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt1, 
					                10'd0, 
					                10'd0, 
					  3'd0,3'd0,3'd2,3'd2,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 6'b001011: wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt3, 
					                10'd0,
					                10'd0,
					  3'd0,3'd0,3'd1,3'd3,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 6'b000100: wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt1, 
					sm_sc_shrt_intf.shrt2, 
					                10'd0, 
					  3'd0,3'd1,3'd1,3'd2,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 6'b001100: wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt1, 
					                10'd0, 
					                10'd0, 
					  3'd0,3'd0,3'd2,3'd2,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 6'b010101: wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt2,  
				                        10'd0, 
			       	                        10'd0, 
		       		          3'd0,3'd0,3'd1,3'd3,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 6'b100110: wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt1,
					                10'd0, 
					                10'd0, 
					  3'd0,3'd0,3'd1,3'd3,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 6'b001000: wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt1,
					sm_sc_shrt_intf.shrt3, 
					                10'd0, 
					  3'd0,3'd1,3'd2,3'd1,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 6'b010000: wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt1,
					sm_sc_shrt_intf.shrt2, 
				                        10'd0, 
			       		  3'd0,3'd1,3'd2,3'd1,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 6'b111000: wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt1, 
					                20'd0, 
					  3'd0,3'd0,3'd3,3'd1,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 6'b100000: wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt1, 
					sm_sc_shrt_intf.shrt2,
					                10'd0,
					  3'd0,3'd2,3'd1,3'd1,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 default:   wr_data <= {sm_sc_shrt_intf.shrt0, 
					                10'd0, 
					                10'd0, 
					                10'd0, 
					  3'd0,3'd0,3'd0,3'd4,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
	       endcase 
	    end
	    
	    else if (sm_sc_shrt_intf.vld == 4'b0111) begin
	       case ({mtch_1_2, mtch_0_2, mtch_0_1})
		 
		 3'b000 :   wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt1,
					sm_sc_shrt_intf.shrt2, 
					                10'd0, 
					  3'd0,3'd1,3'd1,3'd1,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 3'b001 :   wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt2,
					                10'd0, 
					                10'd0, 
					  3'd0,3'd0,3'd1,3'd2,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 3'b010 :   wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt1,
					                10'd0, 
					                10'd0, 
					  3'd0,3'd0,3'd1,3'd2,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 3'b100 :   wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt1,
					                10'd0, 
					                10'd0, 
					  3'd0,3'd0,3'd2,3'd1,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
		 
		 default:   wr_data <= {sm_sc_shrt_intf.shrt0, 
					                10'd0, 
					                10'd0, 
					                10'd0, 
					  3'd0,3'd0,3'd0,3'd3,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
	       endcase 
	    end 
	    
	    else if (sm_sc_shrt_intf.vld == 4'b0011) begin
	       
	       if (mtch_0_1) begin
		            wr_data <= {sm_sc_shrt_intf.shrt0, 
					                10'd0, 
					                10'd0, 
					                10'd0, 
					  3'd0,3'd0,3'd0,3'd2,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
	       end
	       
	       else begin
		            wr_data <= {sm_sc_shrt_intf.shrt0, 
					sm_sc_shrt_intf.shrt1, 
					                10'd0, 
					                10'd0, 
					  3'd0,3'd0,3'd1,3'd1,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
	       end
	    end 
	    
	    else if (sm_sc_shrt_intf.vld == 4'b0001) begin
	                    wr_data <= {sm_sc_shrt_intf.shrt0,  
					                10'd0,  
					                10'd0,  
					                10'd0,  
					  3'd0,3'd0,3'd0,3'd1,  
				       sm_sc_shrt_intf.seq_id,  
					  sm_sc_shrt_intf.eob}; 
	    end
	    
	    else begin
	                    wr_data <= {                 10'd0, 
				                         10'd0, 
					                 10'd0, 
					                 10'd0, 
					   3'd0,3'd0,3'd0,3'd0,
					sm_sc_shrt_intf.seq_id,sm_sc_shrt_intf.eob};
	    end
	 end
      end 
   end 
   
   
   
   
   
   nx_fifo_ram_1r1w
     #(.DEPTH            (256),               
       .WIDTH            (58),
       .UNDERFLOW_ASSERT (1),
       .OVERFLOW_ASSERT  (1),
       .SPECIALIZE       (1),
       .IN_FLOP          (0),
       .OUT_FLOP         (0),
       .RD_LATENCY       (1))  
   sc_fifo_short
     (
      
      .empty				(empty),
      .full				(full),
      .used_slots			(used_slots),		 
      .free_slots			(free_slots),		 
      .rerr				(),			 
      .rdata				(rd_data),		 
      .underflow			(underflow),
      .overflow				(overflow),
      .bimc_odat			(sc_short_bimc_odat),	 
      .bimc_osync			(sc_short_bimc_osync),	 
      .ro_uncorrectable_ecc_error	(sc_short_sa_ro_uncorrectable_ecc_error), 
      
      .clk				(clk),
      .rst_n				(rst_n),
      .wen				(wr),			 
      .wdata				(wr_data),		 
      .ren				(fifo_rd),		 
      .clear				(1'd0),			 
      .bimc_idat			(sc_short_bimc_idat),	 
      .bimc_isync			(sc_short_bimc_isync),	 
      .bimc_rst_n			(sc_short_bimc_rst_n),	 
      .lvm				(lvm),
      .mlvm				(mlvm),
      .mrdten				(mrdten));
 
   
endmodule 









