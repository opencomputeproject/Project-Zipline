/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/




  




`include "ccx_std.vh"
`include "cr_lz77_comp_pkg_include.vh"
`include "axi_reg_slice_defs.vh"
`include "cr_lz77_comp.vh"

module cr_lz77_comp
  #(
    parameter 
    CR_LZ77_COMPRESSOR_STUB = 0,
    LZ77_COMP_SHORT_WINDOW  = 0     
    )
   (
   
   lz77_comp_ib_out, rbus_ring_o, lz77_comp_ob_out,
   im_available_lz77c, lz77_comp_stat_events, lz77_comp_int,
   
   cfg_start_addr, cfg_end_addr, clk, rst_n, scan_en, scan_mode,
   scan_rst_n, ovstb, lvm, mlvm, lz77_comp_ib_in, rbus_ring_i,
   lz77_comp_ob_in, im_consumed_lz77c, lz77_comp_module_id
   );

 
  `include "cr_lz77_comp_includes.vh"
   
   
  input [`N_RBUS_ADDR_BITS-1:0]       cfg_start_addr;
  input [`N_RBUS_ADDR_BITS-1:0]       cfg_end_addr;

   
   
   
   input         clk;
   input         rst_n; 
   
   
   
   
   input         scan_en;
   input         scan_mode;
   input         scan_rst_n;

   
   
   
   input         ovstb;
   input         lvm;
   input         mlvm;

   
   
   
   input         axi4s_dp_bus_t lz77_comp_ib_in;
   output        axi4s_dp_rdy_t lz77_comp_ib_out;
   
   
   
   
   input         rbus_ring_t rbus_ring_i;
   output        rbus_ring_t rbus_ring_o;
   
   
   
   
   input         axi4s_dp_rdy_t lz77_comp_ob_in;
   output        axi4s_dp_bus_t lz77_comp_ob_out;

   
   
   
   input         im_consumed_t   im_consumed_lz77c;
   output        im_available_t  im_available_lz77c;
   
   
   
   
   output [`LZ77C_STATS_WIDTH-1:0] lz77_comp_stat_events;

   
   
   
   input [`MODULE_ID_WIDTH-1:0]    lz77_comp_module_id;

   
   
   
   output 			   tlvp_int_t lz77_comp_int;

   
   
 
   

`ifndef CR_LZ77_COMP_BBOX
   
   
   
   
   

   compression_cfg_t         sw_COMPRESSION_CFG;        
   power_credit_burst_t      sw_POWER_CREDIT_BURST;  
   lz77_comp_debug_status_t  sw_LZ77_COMP_DEBUG_STATUS;
   tlv_parse_action_t        sw_TLV_PARSE_ACTION;       
   axi4s_dp_rdy_t            lz77_comp_ob_in_int;
   axi4s_dp_bus_t            lz77_comp_ob_out_int;
   axi4s_dp_rdy_t            lz77_comp_ob_in_im;
   axi4s_dp_bus_t            lz77_comp_ob_out_im;
   axi4s_dp_rdy_t            lz77_comp_ob_in_pre;
   axi4s_dp_bus_t            lz77_comp_ob_out_pre;


   wire 			   bypass_reset = scan_mode;
   wire                            test_rst_n = scan_rst_n;

   
   
   wire                 comp_rst_n;             
   wire                 debug_status_read;      
   spare_t              sw_SPARE;               
   
   
   

   assign lz77_comp_ob_out_int[$bits(axi4s_dp_bus_t)-2:0] = lz77_comp_ob_out_im[$bits(axi4s_dp_bus_t)-2:0];
   
   axi_channel_split_slice
       #(.N_OUTPUTS(2),
         .PAYLD_WIDTH($bits(axi4s_dp_bus_t)-1),
         .HNDSHK_MODE(`AXI_RS_BYPASS))
   u_im_split
     (
      
      .ready_src                        (lz77_comp_ob_in_pre),   
      .valid_dst                        ({lz77_comp_ob_out_im.tvalid,  lz77_comp_ob_out_int.tvalid}), 
      .payload_dst                      (lz77_comp_ob_out_im[$bits(axi4s_dp_bus_t)-2:0]), 
      
      .aclk                             (clk),                   
      .aresetn                          (comp_rst_n),            
      .valid_src                        (lz77_comp_ob_out_pre.tvalid), 
      .payload_src                      (lz77_comp_ob_out_pre[$bits(axi4s_dp_bus_t)-2:0]), 
      .ready_dst                        ({lz77_comp_ob_in_im, lz77_comp_ob_in_int})); 

   
   axi_channel_reg_slice
     #(.PAYLD_WIDTH($bits(axi4s_dp_bus_t)-1),
       .HNDSHK_MODE(`AXI_RS_FULL))
   u_ob_reg_slice
     (
      
      .ready_src                        (lz77_comp_ob_in_int),   
      .valid_dst                        (lz77_comp_ob_out.tvalid), 
      .payload_dst                      (lz77_comp_ob_out[$bits(axi4s_dp_bus_t)-2:0]), 
      
      .aclk                             (clk),                   
      .aresetn                          (comp_rst_n),            
      .valid_src                        (lz77_comp_ob_out_int.tvalid), 
      .payload_src                      (lz77_comp_ob_out_int[$bits(axi4s_dp_bus_t)-2:0]), 
      .ready_dst                        (lz77_comp_ob_in));       

   
   
   cr_lz77_comp_core 
     #(
       .CR_LZ77_COMPRESSOR_STUB (CR_LZ77_COMPRESSOR_STUB),
       .LZ77_COMP_SHORT_WINDOW  (LZ77_COMP_SHORT_WINDOW)
       )
   u_cr_lz77_comp_core
     (
      
      
      .lz77_comp_ib_out                 (lz77_comp_ib_out),
      .lz77_comp_ob_out                 (lz77_comp_ob_out_pre),  
      .sw_LZ77_COMP_DEBUG_STATUS        (sw_LZ77_COMP_DEBUG_STATUS),
      .lz77_comp_stat_events            (lz77_comp_stat_events[`LZ77C_STATS_WIDTH-1:0]),
      .lz77_comp_int                    (lz77_comp_int),
      
      .clk                              (clk),
      .rst_n                            (comp_rst_n),            
      .raw_rst_n                        (rst_n),                 
      .bypass_reset                     (bypass_reset),
      .test_rst_n                       (test_rst_n),
      .lz77_comp_ib_in                  (lz77_comp_ib_in),
      .lz77_comp_ob_in                  (lz77_comp_ob_in_pre),   
      .sw_TLV_PARSE_ACTION              (sw_TLV_PARSE_ACTION),
      .sw_COMPRESSION_CFG               (sw_COMPRESSION_CFG),
      .sw_POWER_CREDIT_BURST            (sw_POWER_CREDIT_BURST),
      .lz77_comp_module_id              (lz77_comp_module_id[`MODULE_ID_WIDTH-1:0]),
      .debug_status_read                (debug_status_read),
      .sw_SPARE                         (sw_SPARE));
   
   
   cr_lz77_comp_regfile u_cr_lz77_comp_regfile 
     (
      
      
      .rbus_ring_o                      (rbus_ring_o),
      .lz77_comp_ob_in                  (lz77_comp_ob_in_im),    
      .im_available_lz77c               (im_available_lz77c),
      .sw_TLV_PARSE_ACTION              (sw_TLV_PARSE_ACTION),
      .sw_COMPRESSION_CFG               (sw_COMPRESSION_CFG),
      .sw_POWER_CREDIT_BURST            (sw_POWER_CREDIT_BURST),
      .sw_SPARE                         (sw_SPARE),
      .debug_status_read                (debug_status_read),
      
      .cfg_start_addr                   (cfg_start_addr[`N_RBUS_ADDR_BITS-1:0]),
      .cfg_end_addr                     (cfg_end_addr[`N_RBUS_ADDR_BITS-1:0]),
      .rst_n                            (comp_rst_n),            
      .clk                              (clk),
      .rbus_ring_i                      (rbus_ring_i),
      .lz77_comp_ob_out                 (lz77_comp_ob_out_im),   
      .im_consumed_lz77c                (im_consumed_lz77c),
      .sw_LZ77_COMP_DEBUG_STATUS        (sw_LZ77_COMP_DEBUG_STATUS));
   
   
   
   cr_rst_sync comp_rst
     (
      
      .rst_n                            (comp_rst_n),            
      
      .clk                              (clk),
      .async_rst_n                      (rst_n),                 
      .bypass_reset                     (bypass_reset),          
      .test_rst_n                       (test_rst_n));            

  `ifdef CR_USE_ROSC
   
   
   
   
   

   
   
  `endif
   
`endif   
endmodule








