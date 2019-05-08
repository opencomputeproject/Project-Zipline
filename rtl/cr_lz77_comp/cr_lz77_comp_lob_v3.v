/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/














`include "cr_lz77_comp_pkg_include.vh"

module cr_lz77_comp_lob_v3
  (
   
   lob_prc_full, lob_prc_credit, lob_prs_wr, lob_prs_tlv_if,
   lob_events,
   
   clk, lz77_clk, rst_n, prc_lob_valid, prc_lob_tlv_if,
   prc_lob_is_compressed, prc_lob_enable_stats, lec_lob_type,
   lec_lob_literal, lec_lob_type1_offset, lec_lob_type1_length,
   lec_lob_type0_offset, lec_lob_comp_eot, prs_lob_full,
   prs_lob_afull, prc_debug
   );

`include "ccx_std.vh"
`include "cr_lz77_comp_includes.vh"


   
   
   
   input                        clk;
   input                        lz77_clk;
   input 			rst_n; 
   
   
   
   
   output 			lob_prc_full;    
   output 			lob_prc_credit;  
   input 			prc_lob_valid;
   input 			tlvp_if_bus_t prc_lob_tlv_if;

   
   
   input 			prc_lob_is_compressed;

   
   
   input 			prc_lob_enable_stats;
   

   
   
   
   input [4:0][1:0] 		lec_lob_type;
   input [3:0][7:0] 		lec_lob_literal;
   input [15:0] 		lec_lob_type1_offset;
   input [15:0] 		lec_lob_type1_length;
   input [15:0] 		lec_lob_type0_offset;
   input 			lec_lob_comp_eot;
   
   
   
   
   output 			lob_prs_wr;
   output 			tlvp_if_bus_t  lob_prs_tlv_if;
   input 			prs_lob_full;
   input 			prs_lob_afull;

   
   
   
   output 			lob_events_t lob_events;
   input 			prc_debug;
   

   

   
   
   
   
   

   logic 			bpq_wen;
   wire 			bpq_ren;
   wire 			bpq_empty;
   logic 			pkf_wen;
   bpq_data_t                   bpq_wdata;
   bpq_data_t                   bpq_rdata;
   pkf_data_t                   pkf_wdata;
   pkf_data_t                   pkf_rdata;
   packer_symbol_bus_t          pac_exg_data;
   logic 			pac_exg_val;
   wire 			exg_pac_stb;
   wire 			pkf_empty;
   wire 			pkf_ren;
   wire 			exg_pmu_bypass_stb;
   wire 			exg_pmu_eof_stb;
   wire 			pkf_afull;
   wire 			exg_pmu_enable_stats;



`ifdef CR_LZ77_COMP_ENABLE_RTL_BACKPRESSURE_MODEL
   logic 			backpressure_model;
`endif
   
   

`ifdef CR_LZ77_COMP_ENABLE_RTL_BACKPRESSURE_MODEL
   assign lob_prc_full = pkf_afull || backpressure_model;
`else
   assign lob_prc_full = pkf_afull;
`endif

   assign bpq_wen                  = prc_lob_valid;
   assign bpq_wdata.tlv_bus        = prc_lob_tlv_if;
   assign bpq_wdata.is_compressed  = prc_lob_is_compressed;
   assign bpq_wdata.enable_stats   = prc_lob_enable_stats;

   
   
   
   
     
   nx_fifo # 
     (
      
      .WIDTH            ($bits(bpq_data_t)),
      .DEPTH            (32),
      .DATA_RESET       (1),
      .UNDERFLOW_ASSERT (1),
      .OVERFLOW_ASSERT  (1)
      )
   bpq
     (
      
      .empty                            (bpq_empty),             
      .full                             (),                      
      .underflow                        (),                      
      .overflow                         (),                      
      .used_slots                       (),                      
      .free_slots                       (),                      
      .rdata                            (bpq_rdata),             
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .wen                              (bpq_wen),               
      .ren                              (bpq_ren),               
      .clear                            (1'b0),                  
      .wdata                            (bpq_wdata));             
   

   
   
   
   
   
   
   assign pkf_wdata.symbol_type[4]   = lec_lob_type[4];
   assign pkf_wdata.symbol_type[3]   = lec_lob_type[3];
   assign pkf_wdata.symbol_type[2]   = lec_lob_type[2];
   assign pkf_wdata.symbol_type[1]   = lec_lob_type[1];
   assign pkf_wdata.symbol_type[0]   = lec_lob_type[0];
   assign pkf_wdata.literal[3]       = lec_lob_literal[3];
   assign pkf_wdata.literal[2]       = lec_lob_literal[2];
   assign pkf_wdata.literal[1]       = lec_lob_literal[1];
   assign pkf_wdata.literal[0]       = lec_lob_literal[0];
   assign pkf_wdata.type3_offset     = lec_lob_type1_offset;
   assign pkf_wdata.type3_length     = lec_lob_type1_length;
   assign pkf_wdata.type4_offset     = lec_lob_type0_offset;
   assign pkf_wdata.eot              = lec_lob_comp_eot;

   assign pkf_wen = |lec_lob_type | lec_lob_comp_eot;

   
   
   
     
   cr_cdc_fifo_wrap1 #
     (
      
      .N_DATA_BITS          ($bits(pkf_data_t)),
      .N_ENTRIES            (24),
      .N_AFULL_VAL          (18),
      .N_AEMPTY_VAL         (1),
      .TYPE                 (0)
      )
   pkf
     (
      
      .full                             (),                      
      .afull                            (pkf_afull),             
      .rdata                            (pkf_rdata),             
      .empty                            (pkf_empty),             
      .aempty                           (),                      
      
      .wclk                             (lz77_clk),              
      .wrst_n                           (rst_n),                 
      .rclk                             (clk),                   
      .rrst_n                           (rst_n),                 
      .wdata                            (pkf_wdata),             
      .wen                              (pkf_wen),               
      .ren                              (pkf_ren));               


   cr_lz77_comp_pac_v3 pac
     (
      
      .pkf_ren                          (pkf_ren),
      .pac_exg_data                     (pac_exg_data),
      .pac_exg_val                      (pac_exg_val),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .pkf_empty                        (pkf_empty),
      .pkf_rdata                        (pkf_rdata),
      .exg_pac_stb                      (exg_pac_stb),
      .prs_lob_afull                    (prs_lob_afull));


   cr_lz77_comp_exg exg
     (
      
      .exg_pac_stb                      (exg_pac_stb),
      .bpq_ren                          (bpq_ren),
      .lob_prc_credit                   (lob_prc_credit),
      .lob_prs_wr                       (lob_prs_wr),
      .lob_prs_tlv_if                   (lob_prs_tlv_if),
      .exg_pmu_bypass_stb               (exg_pmu_bypass_stb),
      .exg_pmu_eof_stb                  (exg_pmu_eof_stb),
      .exg_pmu_enable_stats             (exg_pmu_enable_stats),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .pac_exg_data                     (pac_exg_data),
      .pac_exg_val                      (pac_exg_val),
      .bpq_empty                        (bpq_empty),
      .bpq_rdata                        (bpq_rdata),
      .prs_lob_afull                    (prs_lob_afull));


   cr_lz77_comp_pmu pmu
     (
      
      .lob_events                       (lob_events),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .pac_exg_data                     (pac_exg_data),
      .pac_exg_val                      (pac_exg_val),
      .exg_pmu_bypass_stb               (exg_pmu_bypass_stb),
      .exg_pmu_eof_stb                  (exg_pmu_eof_stb),
      .exg_pmu_enable_stats             (exg_pmu_enable_stats));
   


   
   
   
   
   
   
`ifdef CR_LZ77_COMP_ENABLE_RTL_BACKPRESSURE_MODEL
   always @ (posedge lz77_clk or negedge rst_n) begin
      if (!rst_n) begin
	 backpressure_model <= 1'b0;
      end
      else begin
	 backpressure_model <= $random;
         
	 
      end
   end
`endif
   
   
   
   
   

endmodule 









