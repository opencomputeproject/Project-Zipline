/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/






























`include "cr_su.vh"

module cr_su_core 
(
   
   bimc_odat, bimc_osync, su_ready, su_ob_out, hb_sup, su_hb,
   su_agg_cnt_stb, su_int,
   
   clk, rst_n, ovstb, lvm, mlvm, bimc_rst_n, bimc_isync, bimc_idat,
   su_in, su_ob_in, dbg_config
   );
  
`include "cr_structs.sv"
  
  import cr_suPKG::*;
  import cr_su_regsPKG::*;

  
  
  
  input                        clk;
  input                        rst_n; 
  
  
  
  
  input                        ovstb;
  input                        lvm;
  input                        mlvm;

  
  
  
  input                        bimc_rst_n;
  input                        bimc_isync;
  input                        bimc_idat;
  output                       bimc_odat;
  output                       bimc_osync;

  
  
  
  input  sched_update_if_bus_t su_in;

  
  
  
  output                       su_ready;  

  
  
  
  input  axi4s_dp_rdy_t        su_ob_in;
  output axi4s_su_dp_bus_t     su_ob_out;

  
  
  
  input  dbg_t                 dbg_config; 
  output hb_sup_t              hb_sup;
  output reg [107:0]           su_hb[7:0];
  output                       su_agg_cnt_stb;

  
  
  
  output ecc_int_t             su_int;


  
  
  wire			axi_mstr_rd;		
  logic			in_fifo_empty;		
  wire			in_fifo_rd;		
  logic [($bits(sched_update_if_bus_t))-1:0] in_fifo_rdata;
  sched_update_if_bus_t	in_fifo_wdata;		
  wire			in_fifo_wr;		
  axi4s_su_dp_bus_t	out_fifo_wdata;		
  wire			out_fifo_wr;		
  

  
  logic                 out_fifo_empty;
  logic                 out_fifo_empty_mod;
  axi4s_su_dp_bus_t     out_fifo_rdata; 
  logic [`LOG_VEC(`SU_FIFO_ENTRIES+3)] in_fifo_free_slots;
  
  
  



  nx_fifo_ram_1r1w  
  #(.DEPTH            (`SU_FIFO_ENTRIES),               
    .WIDTH            ($bits(sched_update_if_bus_t)),
    .UNDERFLOW_ASSERT (1),
    .OVERFLOW_ASSERT  (1),
    .SPECIALIZE       (1), 
    .IN_FLOP          (0),
    .OUT_FLOP         (1),
    .RD_LATENCY       (1),
    .REN_COMB         (0),
    .RDATA_COMB       (0)) 
  u_su_in_fifo
  (
   
   
   .empty				(in_fifo_empty),	 
   .full				(),			 
   .used_slots				(),			 
   .free_slots				(in_fifo_free_slots),	 
   .rerr				(),			 
   .rdata				(in_fifo_rdata[($bits(sched_update_if_bus_t))-1:0]), 
   .underflow				(),			 
   .overflow				(),			 
   .bimc_odat				(bimc_odat),
   .bimc_osync				(bimc_osync),
   .ro_uncorrectable_ecc_error		(su_int.uncor_ecc_err),	 
   
   .clk					(clk),
   .rst_n				(rst_n),
   .wen					(in_fifo_wr),		 
   .wdata				(in_fifo_wdata[`BIT_VEC(($bits(sched_update_if_bus_t)))]), 
   .ren					(in_fifo_rd),		 
   .clear				(1'd0),			 
   .bimc_idat				(bimc_idat),
   .bimc_isync				(bimc_isync),
   .bimc_rst_n				(bimc_rst_n),
   .lvm					(lvm),
   .mlvm				(mlvm),
   .mrdten				(1'b0));			 

cr_su_ctl u_cr_su_ctl
(
 
 .su_ready				(su_ready),
 .hb_sup				(hb_sup),
 .su_hb					(su_hb),
 .su_agg_cnt_stb			(su_agg_cnt_stb),
 .in_fifo_wdata				(in_fifo_wdata),
 .in_fifo_wr				(in_fifo_wr),
 .in_fifo_rd				(in_fifo_rd),
 .out_fifo_wr				(out_fifo_wr),
 .out_fifo_wdata			(out_fifo_wdata),
 
 .clk					(clk),
 .rst_n					(rst_n),
 .su_in					(su_in),
 .in_fifo_rdata				(in_fifo_rdata),
 .in_fifo_empty				(in_fifo_empty),
 .in_fifo_free_slots			(in_fifo_free_slots[`LOG_VEC(`SU_FIFO_ENTRIES+3)]),
 .out_fifo_empty			(out_fifo_empty),
 .out_fifo_rdata			(out_fifo_rdata),
 .axi_mstr_rd				(axi_mstr_rd));



  
  
  




  cr_fifo_wrap1 
  #(
    .N_DATA_BITS ($bits(axi4s_su_dp_bus_t)),    
    .N_ENTRIES (24),                     
    .N_AFULL_VAL (3),                    
    .N_AEMPTY_VAL (1))                   
  u_su_out_fifo
  (
   
   
   .full				(),			 
   .afull				(),			 
   .rdata				(out_fifo_rdata[($bits(axi4s_su_dp_bus_t))-1:0]), 
   .empty				(out_fifo_empty),	 
   .aempty				(),			 
   
   .clk					(clk),
   .rst_n				(rst_n),
   .wdata				(out_fifo_wdata[($bits(axi4s_su_dp_bus_t))-1:0]), 
   .wen					(out_fifo_wr),		 
   .ren					(axi_mstr_rd));		 

  
  
  

  
  
  assign out_fifo_empty_mod  = dbg_config.force_ob_bp || out_fifo_empty;

  

  cr_axi4s_mstr_su u_su_axi4s_mstr
  (
   
   
   .axi4s_mstr_rd			(axi_mstr_rd),		 
   .axi4s_ob_out			(su_ob_out),		 
   
   .clk					(clk),
   .rst_n				(rst_n),
   .axi4s_in				(out_fifo_rdata),	 
   .axi4s_in_empty			(out_fifo_empty_mod),	 
   .axi4s_in_aempty			(1'b0),			 
   .axi4s_ob_in				(su_ob_in));		 

endmodule 









