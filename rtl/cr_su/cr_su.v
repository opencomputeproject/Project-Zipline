/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_su.vh"

module cr_su

  (
   
   bimc_odat, bimc_osync, rbus_ring_o, su_ready, su_ob_out, su_int,
   
   clk, rst_n, scan_en, scan_mode, scan_rst_n, bimc_rst_n, bimc_isync,
   bimc_idat, ovstb, lvm, mlvm, su_in, rbus_ring_i, cfg_start_addr,
   cfg_end_addr, su_ob_in
   );

`include "cr_structs.sv"
`include "ccx_std.vh"

  import cr_suPKG::*;
  import cr_su_regsPKG::*;
  
  
  
  input         clk;
  input         rst_n; 

  
  
  
  input         scan_en;
  input         scan_mode;
  input         scan_rst_n;

  
  
  
  input         bimc_rst_n;
  input         bimc_isync;
  input         bimc_idat;
  output        bimc_odat;
  output        bimc_osync;

  
  
  
  input         ovstb;
  input         lvm;
  input         mlvm;

  
  
  
  input         sched_update_if_bus_t su_in;
  
  
  
  
  input         rbus_ring_t rbus_ring_i;
  output        rbus_ring_t rbus_ring_o;
   input [`N_RBUS_ADDR_BITS-1:0] cfg_start_addr;
   input [`N_RBUS_ADDR_BITS-1:0] cfg_end_addr;
   
  
  
  
  output        su_ready;  

  
  
  
  input         axi4s_dp_rdy_t su_ob_in;
  output        axi4s_su_dp_bus_t su_ob_out;

  
  
  
  output ecc_int_t             su_int;

  
  
  dbg_t			dbg_config;		
  hb_sup_t		hb_sup;			
  logic			su_agg_cnt_stb;		
  logic [107:0]		su_hb [7:0];		
  

  cr_su_core u_cr_su_core
  (
   
   
   .bimc_odat				(bimc_odat),
   .bimc_osync				(bimc_osync),
   .su_ready				(su_ready),
   .su_ob_out				(su_ob_out),
   .hb_sup				(hb_sup),
   .su_hb				(su_hb),
   .su_agg_cnt_stb			(su_agg_cnt_stb),
   .su_int				(su_int),
   
   .clk					(clk),
   .rst_n				(rst_n),
   .ovstb				(ovstb),
   .lvm					(lvm),
   .mlvm				(mlvm),
   .bimc_rst_n				(bimc_rst_n),
   .bimc_isync				(bimc_isync),
   .bimc_idat				(bimc_idat),
   .su_in				(su_in),
   .su_ob_in				(su_ob_in),
   .dbg_config				(dbg_config));

  cr_su_regfile
 
  u_cr_su_regfile 
  (
   
   
   .rbus_ring_o				(rbus_ring_o),
   .dbg_config				(dbg_config),
   
   .rst_n				(rst_n),
   .clk					(clk),
   .rbus_ring_i				(rbus_ring_i),
   .cfg_start_addr			(cfg_start_addr[`N_RBUS_ADDR_BITS-1:0]),
   .cfg_end_addr			(cfg_end_addr[`N_RBUS_ADDR_BITS-1:0]),
   .hb_sup				(hb_sup),
   .su_hb				(su_hb),
   .su_agg_cnt_stb			(su_agg_cnt_stb));
  
endmodule











