/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp_htf_small_tables 
  (
   
   small_blt, small_smt, small_svt, small_tables_done,
   small_tables_error,
   
   clk, rst_n, small_blt_hist_start_valid,
   small_blt_hist_complete_valid, small_blt_hist_complete_deflate,
   small_blt_hist_wen, small_blt_hist_wdata
   );

   parameter SMALL_BL_PER_CYCLE = 2;

   import crPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;

   
   
   
   input         clk;
   input         rst_n;

   
   
   
   
   
   input         small_blt_hist_start_valid;
   input         small_blt_hist_complete_valid;
   input         small_blt_hist_complete_deflate;

   input [`LOG_VEC(SMALL_BL_PER_CYCLE+1)] small_blt_hist_wen;
   input [`BIT_VEC(SMALL_BL_PER_CYCLE)][`LOG_VEC(`N_MAX_SMALL_HUFF_BITS+1)] small_blt_hist_wdata;
   
   
   
   
   output logic [`BIT_VEC(`N_SMALL_SYMBOLS)][`LOG_VEC(`N_MAX_SMALL_HUFF_BITS+1)] small_blt;
   output logic [`BIT_VEC(`N_SMALL_SYMBOLS)][`BIT_VEC(`N_MAX_SMALL_HUFF_BITS)]   small_smt;
   output logic [`BIT_VEC(`N_SMALL_SYMBOLS)][`BIT_VEC(`N_MAX_SMALL_HUFF_BITS)]   small_svt;
   
   output logic                                                                  small_tables_done;
   output logic                                                                  small_tables_error;
   
   
   
   
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

   logic                                      bct_wen;
   logic                                      bct_error;
   logic                                      bct_last;
   logic [`LOG_VEC(`N_MAX_SMALL_HUFF_BITS+1)] bct_addr;
   logic [`BIT_VEC(`N_MAX_SMALL_HUFF_BITS-1)] bct_data;
   
   logic [`BIT_VEC(SMALL_BL_PER_CYCLE)]       svt_wen;
   logic [`LOG_VEC(`N_SMALL_SYMBOLS)]         svt_addr;
   logic [`BIT_VEC(SMALL_BL_PER_CYCLE)][`BIT_VEC(`N_MAX_SMALL_HUFF_BITS)] svt_data;
   logic                                                                  svt_last;

   logic                                                            bct_complete;

   logic [`LOG_VEC(`N_MAX_SMALL_HUFF_BITS+1)]                       hist_depth;
   logic [`BIT_VEC_BASE((`N_MAX_SMALL_HUFF_BITS),1)][`LOG_VEC(`N_SMALL_SYMBOLS+1)] histogram;
   logic [`LOG_VEC(`N_SMALL_SYMBOLS+1)]                                            blt_depth;

   
   logic [`BIT_VEC(((`N_SMALL_SYMBOLS+SMALL_BL_PER_CYCLE-1)/SMALL_BL_PER_CYCLE)*SMALL_BL_PER_CYCLE*`N_MAX_SMALL_HUFF_BITS)] `DECLARE_FLOP(svt);
   logic                 `DECLARE_RESET_FLOP(small_tables_done, 1);
   logic                 `DECLARE_RESET_FLOP(small_tables_error, 0);
   
   assign small_svt = $bits(small_svt)'(r_svt);
   assign small_tables_done = r_small_tables_done;
   assign small_tables_error = r_small_tables_error;
   
   enum logic [1:0] {WAIT_FOR_BLT_HIST_COMPLETE=0,
                     BCT=1,
                     WAIT_FOR_SVT_LAST=2} `DECLARE_RESET_FLOP(state, WAIT_FOR_BLT_HIST_COMPLETE);
   logic `DECLARE_RESET_FLOP(deflate, 0);

   always_comb begin
      `DEFAULT_FLOP(state);
      `DEFAULT_FLOP(small_tables_done);
      `DEFAULT_FLOP(small_tables_error);
      `DEFAULT_FLOP(deflate);
      `DEFAULT_FLOP(svt);

      bct_complete = 0;
      
      if (r_deflate) begin
         hist_depth = `N_MAX_CODELEN_HUFF_BITS;
      end
      else begin
         hist_depth = `N_MAX_SMALL_HUFF_BITS;
      end

      case (r_state)
        WAIT_FOR_BLT_HIST_COMPLETE: begin
           if (small_blt_hist_complete_valid) begin
              c_small_tables_done = 0;
              c_small_tables_error = 0;
              c_deflate = small_blt_hist_complete_deflate;
              c_state = BCT;
           end
        end 
        BCT: begin
           if (bct_wen) begin
              if (bct_error) begin
                 c_small_tables_done = 1;
                 c_small_tables_error = 1;
                 c_state = WAIT_FOR_BLT_HIST_COMPLETE;
              end
              else if (bct_last) begin
                 bct_complete = 1;
                 c_state = WAIT_FOR_SVT_LAST;
                 c_svt = '1; 
              end
           end
        end 
        WAIT_FOR_SVT_LAST: begin
           if (svt_last) begin
              c_small_tables_done = 1;
              c_small_tables_error = 0;
              c_state = WAIT_FOR_BLT_HIST_COMPLETE;
           end
        end
      endcase 

      for (int i=0; i<SMALL_BL_PER_CYCLE; i++) begin
         if (svt_wen[i]) begin
            c_svt[(svt_addr+i)*`N_MAX_SMALL_HUFF_BITS +: `N_MAX_SMALL_HUFF_BITS] = svt_data[i]; 
         end
      end
   end

   

   cr_xp10_decomp_htf_bct_sat_writer
     #(.MAX_DEPTH(`N_MAX_SMALL_HUFF_BITS),
       .WIDTH($clog2(`N_SMALL_SYMBOLS+1)))
   u_bct_writer
     (
      
      .bct_sat_wen                      (bct_wen),               
      .bct_sat_addr                     (bct_addr),              
      .bct_sat_last                     (bct_last),              
      .bct_valid                        (),                      
      .bct_data                         (bct_data[`BIT_VEC((`N_MAX_SMALL_HUFF_BITS)-1)]),
      .sat_data                         (),                      
      .bct_sat_error                    (bct_error),             
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .hist_complete                    (small_blt_hist_complete_valid), 
      .hist_depth                       (hist_depth[`LOG_VEC((`N_MAX_SMALL_HUFF_BITS)+1)]),
      .histogram                        (histogram));

   

   cr_xp10_decomp_htf_svt_writer
     #(.MAX_BLT_DEPTH(`N_SMALL_SYMBOLS), 
       .MAX_BCT_DEPTH(`N_MAX_SMALL_HUFF_BITS),
       .BL_PER_CYCLE(SMALL_BL_PER_CYCLE))
   u_svt_writer
     (
      
      .svt_wen                          (svt_wen[`BIT_VEC(SMALL_BL_PER_CYCLE)]),
      .svt_addr                         (svt_addr[`LOG_VEC((`N_SMALL_SYMBOLS))]),
      .svt_data                         (svt_data),
      .svt_last                         (svt_last),              
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .bct_wen                          (bct_wen),               
      .bct_addr                         (bct_addr[`LOG_VEC((`N_MAX_SMALL_HUFF_BITS)+1)]), 
      .bct_data                         ({bct_data, 1'b0}),      
      .bct_complete                     (bct_complete),          
      .blt_depth                        (blt_depth[`LOG_VEC((`N_SMALL_SYMBOLS)+1)]),
      .blt                              (small_blt),             
      .abort                            (1'b0));                  

   
   cr_xp10_decomp_htf_histogram
     #(.DEPTH(`N_MAX_SMALL_HUFF_BITS),
       .WIDTH($clog2(`N_SMALL_SYMBOLS+1)),
       .NUM_INC_PORTS(SMALL_BL_PER_CYCLE))
   u_histogram
     (
      
      .histogram                        (histogram),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .hist_waddr                       (small_blt_hist_wdata),  
      .hist_inc                         (small_blt_hist_wen),    
      .hist_start                       (small_blt_hist_start_valid)); 

   
   
   
   
   
   logic [`BIT_VEC(SMALL_BL_PER_CYCLE)][`BIT_VEC(`N_MAX_SMALL_HUFF_BITS)] small_smt_wdata;

   always_comb begin
      for (int i=0; i<SMALL_BL_PER_CYCLE; i++)
        small_smt_wdata[i] = ~('1 << small_blt_hist_wdata[i]);
   end

   
   cr_xp10_decomp_htf_blt
     #(.DEPTH(`N_SMALL_SYMBOLS),
       .WIDTH($clog2(`N_MAX_SMALL_HUFF_BITS+1)),
       .NUM_WR_PORTS(SMALL_BL_PER_CYCLE))
   u_blt
     (
      
      .blt                              (small_blt),             
      .blt_depth                        (blt_depth[`LOG_VEC((`N_SMALL_SYMBOLS)+1)]),
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .blt_wdata                        (small_blt_hist_wdata),  
      .blt_wen                          (small_blt_hist_wen),    
      .blt_start                        (small_blt_hist_start_valid)); 

   
   cr_xp10_decomp_htf_blt
     #(.DEPTH(`N_SMALL_SYMBOLS),
       .WIDTH(`N_MAX_SMALL_HUFF_BITS),
       .NUM_WR_PORTS(SMALL_BL_PER_CYCLE),
       .CLEAR_ON_FIRST_WRITE(1))
   u_smt
     (
      
      .blt                              (small_smt),             
      .blt_depth                        (),                      
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .blt_wdata                        (small_smt_wdata),       
      .blt_wen                          (small_blt_hist_wen),    
      .blt_start                        (small_blt_hist_start_valid)); 

`undef DECLARE_RESET_FLOP
`undef DECLARE_FLOP
`undef DEFAULT_FLOP

endmodule 








