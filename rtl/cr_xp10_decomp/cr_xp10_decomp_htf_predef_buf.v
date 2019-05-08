/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp_htf_predef_buf (
   
   bimc_odat, bimc_osync, predef_ro_uncorrectable_ecc_error,
   htf_fhp_bl_ready, predef_bl_req_ready, predef_bl_rsp_bits_avail,
   predef_bl_rsp_bits_data, predef_stall_stb,
   
   clk, rst_n, ovstb, lvm, mlvm, bimc_idat, bimc_isync, bimc_rst_n,
   fhp_htf_bl_valid, fhp_htf_bl_bus, predef_bl_req_valid,
   predef_bl_req_ll, predef_bl_req_num_bl, predef_bl_rsp_bits_consume,
   predef_bl_done
   );

   parameter DP_WIDTH = 64;
   parameter MAX_RSP_BITS_PER_CYCLE = 10;

   localparam BL_WIDTH = $clog2(`N_MAX_XP_HUFF_BITS);
   localparam PREDEF_TLV_LL_OFFSET = (BL_WIDTH*`N_XP10_64K_SHRT_SYMBOLS+DP_WIDTH-1)/DP_WIDTH;
   localparam PREDEF_TLV_WORDS = PREDEF_TLV_LL_OFFSET + (BL_WIDTH*`N_XP10_64K_LONG_SYMBOLS+DP_WIDTH-1)/DP_WIDTH;
   localparam BUF_IN_FLOP = 1;
   localparam BUF_OUT_FLOP = 1;
   localparam BUF_RD_LATENCY = 1;
   localparam BUF_TOTAL_RD_LATENCY = BUF_OUT_FLOP + BUF_RD_LATENCY;
   localparam PREFETCH_DEPTH = BUF_TOTAL_RD_LATENCY + 1;
   
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   
   
   
   input         clk;
   input         rst_n; 
   
   
   
   
   input         ovstb;
   input         lvm;
   input         mlvm;

   input         bimc_idat;
   input         bimc_isync;
   input         bimc_rst_n;
   output logic  bimc_odat;
   output logic  bimc_osync;

   output logic  predef_ro_uncorrectable_ecc_error;
   
   
   
   
   input logic   fhp_htf_bl_valid;
   input         fhp_htf_bl_bus_t fhp_htf_bl_bus;
   output logic  htf_fhp_bl_ready;

   
   
   
   input         predef_bl_req_valid; 
   input         predef_bl_req_ll; 
                                   
   input [9:0]   predef_bl_req_num_bl;
   
   output logic  predef_bl_req_ready;

   output logic [`LOG_VEC(MAX_RSP_BITS_PER_CYCLE+1)] predef_bl_rsp_bits_avail;
   output logic [`BIT_VEC(MAX_RSP_BITS_PER_CYCLE)]   predef_bl_rsp_bits_data;
   input [`LOG_VEC(MAX_RSP_BITS_PER_CYCLE+1)]        predef_bl_rsp_bits_consume;
   
   input         predef_bl_done; 

   
   
   
   output logic                        predef_stall_stb;

   

   
   
   
`define DECLARE_RESET_FLOP(name, reset_val) \
   r_``name, c_``name; \
   always_ff@(posedge clk or negedge rst_n)    \
     if (!rst_n) \
       r_``name <= reset_val; \
     else \
       r_``name <= c_``name
`define DECLARE_FLOP(name) \
   r_``name, c_``name; \
   always_ff@(posedge clk) r_``name <= c_``name 
`define DEFAULT_FLOP(name) c_``name = r_``name
`define DECLARE_RESET_OUT_FLOP(name, reset_val) \
   `DECLARE_RESET_FLOP(name, reset_val); \
   assign name = r_``name


   
   logic [`LOG_VEC(PREDEF_TLV_WORDS*2)] `DECLARE_RESET_FLOP(buf_waddr, 0);
   logic [`LOG_VEC(PREDEF_TLV_WORDS*2)] `DECLARE_RESET_FLOP(buf_raddr, 0);
   logic [`LOG_VEC(PREDEF_TLV_WORDS)]   `DECLARE_RESET_FLOP(word_count, 0);
   logic [1:0]                          `DECLARE_RESET_FLOP(buf_wbank, 0);
   logic [1:0]                          `DECLARE_RESET_FLOP(buf_rbank, 0);
   logic [`LOG_VEC(PREFETCH_DEPTH+1)]   `DECLARE_RESET_FLOP(buf_prefetch_count, 0);
   enum logic {IDLE, READ_BL} `DECLARE_RESET_FLOP(state, IDLE);
   logic [`BIT_VEC(BUF_TOTAL_RD_LATENCY)] `DECLARE_RESET_FLOP(buf_ren, 0);
   logic                                  `DECLARE_RESET_OUT_FLOP(predef_stall_stb, 0);

   
   logic                                  prefetch_clear;
   logic                                  buf_wen;
   logic [63:0]                           buf_dout;
   logic                                  buf_prefetch_ren;
   logic                                  buf_prefetch_empty;
   logic                                  ro_uncorrectable_ecc_error;
   always@(posedge clk or negedge rst_n) begin
      if (!rst_n)
        predef_ro_uncorrectable_ecc_error <= 0;
      else
        predef_ro_uncorrectable_ecc_error <= ro_uncorrectable_ecc_error;
   end

   logic                                  predef_bl_rsp_valid;
   logic [`BIT_VEC(DP_WIDTH)]             predef_bl_rsp_data;
   logic                                  predef_bl_rsp_ready;
   
   logic                                  bl_valid;
   fhp_htf_bl_bus_t bl_bus;
   logic                                  bl_ready;
   axi_channel_reg_slice
     #(.PAYLD_WIDTH($bits(fhp_htf_bl_bus_t)),
       .HNDSHK_MODE(`AXI_RS_FULL))
   u_reg_slice
     (.aclk (clk),
      .aresetn (rst_n),
      .valid_src (fhp_htf_bl_valid),
      .payload_src (fhp_htf_bl_bus),
      .ready_src (htf_fhp_bl_ready),
      .valid_dst (bl_valid),
      .payload_dst (bl_bus),
      .ready_dst (bl_ready));

   


   nx_ram_1r1w 
     #(.WIDTH(DP_WIDTH),
       .DEPTH(PREDEF_TLV_WORDS*2),
       .IN_FLOP(BUF_IN_FLOP),
       .OUT_FLOP(BUF_OUT_FLOP),
       .RD_LATENCY(BUF_RD_LATENCY),
       .SPECIALIZE(1))
   u_buf
     (
      
      .bimc_odat                        (bimc_odat),
      .bimc_osync                       (bimc_osync),
      .ro_uncorrectable_ecc_error       (ro_uncorrectable_ecc_error),
      .dout                             (buf_dout),              
      
      .rst_n                            (rst_n),
      .clk                              (clk),
      .lvm                              (lvm),
      .mlvm                             (mlvm),
      .mrdten                           ({1{1'b0}}),             
      .bimc_rst_n                       (bimc_rst_n),
      .bimc_isync                       (bimc_isync),
      .bimc_idat                        (bimc_idat),
      .reb                              (!c_buf_ren[0]),         
      .ra                               (r_buf_raddr),           
      .web                              (!buf_wen),              
      .wa                               (r_buf_waddr),           
      .din                              (bl_bus.data),           
      .bwe                              ({DP_WIDTH{1'b1}}));      

   
   always_comb begin
      `DEFAULT_FLOP(buf_waddr);
      `DEFAULT_FLOP(buf_wbank);

      bl_ready = 0;
      buf_wen = 0;

      if ((r_buf_wbank ^ r_buf_rbank) != 2'b10)
        bl_ready = 1;
      
      if (bl_valid && bl_ready) begin
         
         if (r_buf_waddr == (PREDEF_TLV_WORDS*2-1))
           c_buf_waddr = 0;
         else
           c_buf_waddr = r_buf_waddr + 1;
         
         if (bl_bus.last) begin
            assert #0 ((r_buf_waddr%PREDEF_TLV_WORDS) == (PREDEF_TLV_WORDS-1)) else `ERROR("predef Huffman TLV was NOT %d words", PREDEF_TLV_WORDS);
            c_buf_wbank = r_buf_wbank + 1;
         end
         
         buf_wen = 1;
      end 

      c_predef_stall_stb = bl_valid && !bl_ready && bl_bus.trace_bit;
   end

   
   

   nx_fifo
     #(.WIDTH(DP_WIDTH),
       .DEPTH(PREFETCH_DEPTH),
       .OVERFLOW_ASSERT(1),
       .UNDERFLOW_ASSERT(1))
   prefetch
     (
      
      .empty                            (buf_prefetch_empty),    
      .full                             (),                      
      .underflow                        (),                      
      .overflow                         (),                      
      .used_slots                       (),                      
      .free_slots                       (),                      
      .rdata                            (predef_bl_rsp_data),    
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .wen                              (r_buf_ren[BUF_TOTAL_RD_LATENCY-1]), 
      .ren                              (buf_prefetch_ren),      
      .clear                            (prefetch_clear),        
      .wdata                            (buf_dout));              
   
   
   always_comb begin
      logic [`LOG_VEC(PREDEF_TLV_WORDS*2)] v_buf_base;

      `DEFAULT_FLOP(buf_prefetch_count);
      `DEFAULT_FLOP(state);
      `DEFAULT_FLOP(buf_raddr);
      `DEFAULT_FLOP(buf_rbank);
      `DEFAULT_FLOP(word_count);

      
      buf_prefetch_ren = 0;
      if (!buf_prefetch_empty && predef_bl_rsp_ready) begin
         buf_prefetch_ren = 1;
         c_buf_prefetch_count = r_buf_prefetch_count - 1;
      end

      
      
      c_buf_ren = r_buf_ren << 1;
      if ((r_state != IDLE) && 
          ((r_buf_prefetch_count < PREFETCH_DEPTH) || buf_prefetch_ren)) begin
         c_buf_ren[0] = 1;
         c_buf_raddr = r_buf_raddr + 1;
         c_word_count = r_word_count - 1;
         if (buf_prefetch_ren)
           c_buf_prefetch_count = r_buf_prefetch_count;
         else
           c_buf_prefetch_count = r_buf_prefetch_count + 1;
      end

      prefetch_clear = 0;
      predef_bl_req_ready = 0;
      if (r_buf_rbank[0])
        v_buf_base = PREDEF_TLV_WORDS;
      else
        v_buf_base = 0;
      case (r_state)
        IDLE: begin
           if (predef_bl_req_valid) begin
              predef_bl_req_ready = 1;
              prefetch_clear = 1;

              assert #0 (r_buf_wbank != r_buf_rbank) else `ERROR("shouldn't get predef_buf requests unless phd is present");

              c_word_count = ((predef_bl_req_num_bl*BL_WIDTH)+DP_WIDTH-1)/DP_WIDTH; 
              c_state = READ_BL;
              if (predef_bl_req_ll) begin
                 
                 c_buf_raddr = v_buf_base + PREDEF_TLV_LL_OFFSET;
              end
              else begin
                 
                 c_buf_raddr = v_buf_base;
              end
           end 
        end 
        READ_BL: begin
           if (c_buf_ren[0]) begin
              if (r_word_count == 1)
                c_state = IDLE;
           end
        end
      endcase 

      if (predef_bl_done)
        c_buf_rbank = r_buf_rbank + 1;
   end 

   assign predef_bl_rsp_valid = !buf_prefetch_empty;

   logic [`LOG_VEC(DP_WIDTH+1)] predef_bl_rsp_items_valid;
   assign predef_bl_rsp_items_valid = predef_bl_rsp_valid?DP_WIDTH:0;   

   
   
   cr_xp10_decomp_unpacker
     #(.IN_ITEMS(DP_WIDTH),
       .OUT_ITEMS(MAX_RSP_BITS_PER_CYCLE),
       .MAX_CONSUME_ITEMS(MAX_RSP_BITS_PER_CYCLE),
       .BITS_PER_ITEM(1))
     u_predef_unpacker
     (
      
      .src_ready                        (predef_bl_rsp_ready),   
      .dst_items_avail                  (predef_bl_rsp_bits_avail[`LOG_VEC(MAX_RSP_BITS_PER_CYCLE+1)]), 
      .dst_data                         (predef_bl_rsp_bits_data[`BIT_VEC(MAX_RSP_BITS_PER_CYCLE*1)]), 
      .dst_last                         (),                      
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .src_items_valid                  (predef_bl_rsp_items_valid), 
      .src_data                         (predef_bl_rsp_data[`BIT_VEC(DP_WIDTH*1)]), 
      .src_last                         ({1{1'b0}}),             
      .dst_items_consume                (predef_bl_rsp_bits_consume[`LOG_VEC(MAX_RSP_BITS_PER_CYCLE+1)]), 
      .clear                            (prefetch_clear));        
   
`undef DECLARE_FLOP
`undef DECLARE_RESET_FLOP
`undef DECLARE_RESET_OUT_FLOP
`undef DEFAULT_FLOP

endmodule 







