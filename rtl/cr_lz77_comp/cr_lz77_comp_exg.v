/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/














`include "cr_lz77_comp_pkg_include.vh"

module cr_lz77_comp_exg
  (
   
   exg_pac_stb, bpq_ren, lob_prc_credit, lob_prs_wr, lob_prs_tlv_if,
   exg_pmu_bypass_stb, exg_pmu_eof_stb, exg_pmu_enable_stats,
   
   clk, rst_n, pac_exg_data, pac_exg_val, bpq_empty, bpq_rdata,
   prs_lob_afull
   );

`include "cr_lz77_comp_includes.vh"

   input                   clk;
   input                   rst_n; 

   output                  exg_pac_stb;
   input                   packer_symbol_bus_t pac_exg_data;
   input                   pac_exg_val;

   input                   bpq_empty;
   output                  bpq_ren;
   input                   bpq_data_t bpq_rdata;

   output                  lob_prc_credit;

   input                   prs_lob_afull;
   output                  lob_prs_wr;
   output                  tlvp_if_bus_t lob_prs_tlv_if;

   output reg 		   exg_pmu_bypass_stb;
   output 		   exg_pmu_eof_stb;
   output reg 		   exg_pmu_enable_stats;

   
   
   
   localparam WORD_ZERO_ST      = 2'd0;
   localparam BYPASS_TLV_ST     = 2'd1;
   localparam PACKER_ST         = 2'd2;
   localparam WORD_EOF_ST       = 2'd3;


   
   
   
   
   

   tlv_bus_sidebands_t     word_0_sidebands;
   logic                   bpq_ren_c;
   logic                   grab_sidebands_c;
   logic                   exg_pac_stb_c;
   logic 		   exg_pmu_bypass_stb_c;
   logic 		   exg_pmu_eof_stb_c;
   logic                   lob_prs_wr_c;
   logic [1:0]             exg_st;
   logic [1:0]             exg_st_c;
   logic 		   enable_stats_c;
   logic 		   disable_stats_c;
   logic 		   enable_stats;


   assign bpq_ren = bpq_ren_c;
   assign lob_prc_credit = bpq_ren_c;
   assign lob_prs_wr = lob_prs_wr_c;
   assign exg_pac_stb = exg_pac_stb_c;
   assign exg_pmu_eof_stb = exg_pmu_eof_stb_c;


   always @ (posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         word_0_sidebands     <= {$bits(tlv_bus_sidebands_t){1'b0}};
         exg_st               <= WORD_ZERO_ST;
	 exg_pmu_enable_stats <= 1'b0;
	 exg_pmu_bypass_stb   <= 1'b0;
      end else begin
         
         if (grab_sidebands_c) begin
            word_0_sidebands.insert  <= bpq_rdata.tlv_bus.insert;
            word_0_sidebands.ordern  <= bpq_rdata.tlv_bus.ordern;
            word_0_sidebands.typen   <= bpq_rdata.tlv_bus.typen;
            word_0_sidebands.sot     <= bpq_rdata.tlv_bus.sot;
            word_0_sidebands.eot     <= bpq_rdata.tlv_bus.eot;
            word_0_sidebands.tlast   <= bpq_rdata.tlv_bus.tlast;
            word_0_sidebands.tid     <= bpq_rdata.tlv_bus.tid;
            word_0_sidebands.tstrb   <= bpq_rdata.tlv_bus.tstrb;
            word_0_sidebands.tuser   <= bpq_rdata.tlv_bus.tuser;
         end 
         exg_st <= exg_st_c;

	 if (enable_stats_c)
	   exg_pmu_enable_stats <= 1'b1;
	 else if (disable_stats_c)
	   exg_pmu_enable_stats <= 1'b0;

	 exg_pmu_bypass_stb   <= exg_pmu_bypass_stb_c;

      end
   end
   
      
   
   
   
   always @ (*) begin
      if (exg_st == WORD_ZERO_ST) begin
         lob_prs_tlv_if = bpq_rdata.tlv_bus;
         if (bpq_rdata.is_compressed) begin
            tlv_word_0_t bpq_word_zero;
            
            lob_prs_tlv_if.typen = LZ77;
            
	    
            bpq_word_zero = tlv_word_0_t'(bpq_rdata.tlv_bus.tdata);
            bpq_word_zero.tlv_type = LZ77;
            bpq_word_zero.tlv_len = 24'b0;
            lob_prs_tlv_if.tdata = bpq_word_zero;
         end
      end 
      else if (exg_st == BYPASS_TLV_ST) begin
         lob_prs_tlv_if = bpq_rdata.tlv_bus;
      end
      else if (exg_st == PACKER_ST) begin
         lob_prs_tlv_if.insert     = word_0_sidebands.insert;
         lob_prs_tlv_if.ordern     = word_0_sidebands.ordern;
         lob_prs_tlv_if.typen      = LZ77;
         lob_prs_tlv_if.sot        = 1'b0;
         lob_prs_tlv_if.eot        = 1'b0;
         lob_prs_tlv_if.tlast      = word_0_sidebands.tlast;
         lob_prs_tlv_if.tid        = word_0_sidebands.tid;
         lob_prs_tlv_if.tstrb      = 8'hff;
         lob_prs_tlv_if.tuser      = word_0_sidebands.tuser;
         lob_prs_tlv_if.tuser[1:0] = 2'b00;
         lob_prs_tlv_if.tdata      = pac_exg_data.lz77_frame_data;
      end
      else begin 
         packer_symbol_bus_t lz_eof_word;

         lob_prs_tlv_if.insert      = word_0_sidebands.insert;
         lob_prs_tlv_if.ordern      = word_0_sidebands.ordern;
         lob_prs_tlv_if.typen       = LZ77;
         lob_prs_tlv_if.sot         = 1'b0;
         lob_prs_tlv_if.eot         = 1'b1;
         lob_prs_tlv_if.tlast       = word_0_sidebands.tlast;
         lob_prs_tlv_if.tid         = word_0_sidebands.tid;
         lob_prs_tlv_if.tstrb       = 8'hff;
         lob_prs_tlv_if.tuser       = word_0_sidebands.tuser;
         lob_prs_tlv_if.tuser[1:0]  = 2'b10;
         lz_eof_word                = {$bits(packer_symbol_bus_t){1'b0}};
         lz_eof_word.
	   lz77_frame_data.framing  = 4'hf;
         lob_prs_tlv_if.tdata       = lz_eof_word.lz77_frame_data;
      end
   end 


   
   
   
   always @ (*) begin

      
      bpq_ren_c               = 1'b0;
      lob_prs_wr_c            = 1'b0;
      grab_sidebands_c        = 1'b0;
      exg_pac_stb_c           = 1'b0;
      exg_pmu_bypass_stb_c    = 1'b0;
      exg_pmu_eof_stb_c       = 1'b0;
      exg_st_c                = exg_st;
      enable_stats_c          = 1'b0;
      disable_stats_c         = 1'b0;

      case (exg_st)

        WORD_ZERO_ST: begin
           if (!bpq_empty && !prs_lob_afull) begin
              bpq_ren_c        = 1'b1;
              lob_prs_wr_c     = 1'b1;
              grab_sidebands_c = 1'b1;
              
	      
	      
	      
              if (bpq_rdata.enable_stats) begin
		 enable_stats_c = 1'b1;
	      end
	      else begin
		 disable_stats_c = 1'b1;
	      end

	      
	      
	      
	      
              if (bpq_rdata.is_compressed) begin
		 exg_pac_stb_c = 1'b1;
                 exg_st_c = PACKER_ST;
              end else begin
                 exg_st_c = BYPASS_TLV_ST;
		 
		 
		 
		 if (
		     (bpq_rdata.tlv_bus.typen == DATA) ||
		     (bpq_rdata.tlv_bus.typen == DATA_UNK)
		     )
		   exg_pmu_bypass_stb_c = 1'b1;
	      end
           end
        end 
        
        BYPASS_TLV_ST : begin
           if (!bpq_empty && !prs_lob_afull) begin
              bpq_ren_c    = 1'b1;
              lob_prs_wr_c = 1'b1;
              if (bpq_rdata.tlv_bus.eot)
                exg_st_c = WORD_ZERO_ST;
           end
        end
        
        PACKER_ST : begin
	   
	   
	   
	   if (pac_exg_val) begin
              if (pac_exg_data.eot)
                exg_st_c = WORD_EOF_ST;
	      else
		lob_prs_wr_c = 1'b1;
	   end
        end

         WORD_EOF_ST: begin
           if (!prs_lob_afull) begin
              lob_prs_wr_c = 1'b1;
	      exg_pmu_eof_stb_c = 1'b1;
              exg_st_c = WORD_ZERO_ST;
           end
        end
      endcase 

   end 
      
endmodule 










