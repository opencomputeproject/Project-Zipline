/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp
  #(parameter 
    XP10_DECOMP_STUB=0,
    FPGA_MOD=0
 )        
   (
   
   xp10_decomp_ib_out, rbus_ring_o, xp10_decomp_ob_out,
   xp10_decomp_sch_update, im_available_xpd, im_available_lz77d,
   im_available_htf_bl, xp10_decomp_hufd_stat_events,
   xp10_decomp_lz77d_stat_events, xp10_decomp_int,
   
   clk, rst_n, scan_en, scan_mode, scan_rst_n, ovstb, lvm, mlvm,
   xp10_decomp_ib_in, rbus_ring_i, cfg_start_addr, cfg_end_addr,
   xp10_decomp_ob_in, su_afull_n, im_consumed_xpd, im_consumed_lz77d,
   im_consumed_htf_bl, xp10_decomp_module_id, cceip_cfg
   );

   import crPKG::*;
   import cr_xp10_decompPKG::*;
   import cr_xp10_decomp_regsPKG::*;
   
   
   
   input         clk;
   input         rst_n; 

   
   
   
   input         scan_en;
   input         scan_mode;
   input         scan_rst_n;

   
   
   
   input         ovstb;
   input         lvm;
   input         mlvm;

   
   
   
   input         axi4s_dp_bus_t xp10_decomp_ib_in;
   output        axi4s_dp_rdy_t xp10_decomp_ib_out;
   
   
   
   
   input         rbus_ring_t rbus_ring_i;
   output        rbus_ring_t rbus_ring_o;

   input [`N_RBUS_ADDR_BITS-1:0] cfg_start_addr;
   input [`N_RBUS_ADDR_BITS-1:0] cfg_end_addr;
   
   
   
   
   input         axi4s_dp_rdy_t xp10_decomp_ob_in;
   output        axi4s_dp_bus_t xp10_decomp_ob_out;

   
   
   
   output        sched_update_if_bus_t xp10_decomp_sch_update;
   input         su_afull_n;

   
   
   
   input         im_consumed_t  im_consumed_xpd;
   output        im_available_t im_available_xpd;

   input         im_consumed_t  im_consumed_lz77d;
   output        im_available_t im_available_lz77d;

   input         im_consumed_t  im_consumed_htf_bl;
   output        im_available_t im_available_htf_bl;

   
   
   
   output [`HUFD_STATS_WIDTH-1:0]  xp10_decomp_hufd_stat_events;
   output [`LZ77D_STATS_WIDTH-1:0]  xp10_decomp_lz77d_stat_events;

   
   
   
   input [`MODULE_ID_WIDTH-1:0]    xp10_decomp_module_id;

   output                          generic_int_t xp10_decomp_int;
   input                           cceip_cfg;
   
  `ifndef CR_XP10_DECOMP_BBOX
   
   
   logic [HUFD_STAT_EVENTS_LIMIT:HUFD_STAT_EVENTS_BASE] _hufd_stat_events;
   logic [LZ77D_STAT_EVENTS_LIMIT:LZ77D_STAT_EVENTS_BASE] _xp10_decomp_lz77d_stat_events;
   logic                bimc_core_odat;         
   logic                bimc_core_osync;        
   logic                bimc_ecc_error;         
   logic                bimc_interrupt;         
   logic                bimc_regfile_odat;      
   logic                bimc_regfile_osync;     
   logic                bimc_rst_n;             
   logic                fe_tlvp_error;          
   htf_bl_out_t         htf_bl_im_data;         
   logic                htf_bl_im_ready;        
   logic                htf_bl_im_valid;        
   logic [16:0]         lz_bytes_decomp;        
   logic [16:0]         lz_hb_bytes;            
   logic [11:0]         lz_hb_head_ptr;         
   logic [11:0]         lz_hb_tail_ptr;         
   logic [16:0]         lz_local_bytes;         
   logic                ro_uncorrectable_ecc_error;
   logic                rst_sync_n;             
   logic                sw_IGNORE_CRC_CONFIG;   
   logic                sw_LZ_BYPASS_CONFIG;    
   logic [23:0]         sw_LZ_DECOMP_OLIMIT;    
   logic [31:0]         sw_TLVP_ACTION_CFG0;    
   logic [31:0]         sw_TLVP_ACTION_CFG1;    
   axi4s_dp_rdy_t       xp10_decomp_ob_in_mod;  
   axi4s_dp_bus_t       xp10_decomp_ob_out_pre; 
   lz_symbol_bus_t      xpd_im_data;            
   logic                xpd_im_ready;           
   logic                xpd_im_valid;           
   

   
   
   logic                bimc_core_idat;         
   logic                bimc_core_isync;        
   logic                bimc_regfile_idat;      
   logic                bimc_regfile_isync;     
   

      
`define __BIMC_CHAIN(src,dst)                                 \
      assign bimc_``dst``_idat  = bimc_``src``_odat; \
      assign bimc_``dst``_isync = bimc_``src``_osync

      `__BIMC_CHAIN(regfile, core);
      `__BIMC_CHAIN(core, regfile);
      
`undef __BIMC_CHAIN
   

   logic                r_uncor_ecc_err;
   always_ff@(posedge clk or negedge rst_sync_n) begin
      if (!rst_sync_n) begin
         r_uncor_ecc_err <= 0;
      end
      else begin
         r_uncor_ecc_err <= bimc_ecc_error || ro_uncorrectable_ecc_error;
      end
   end

   assign xp10_decomp_int.uncor_ecc_err = r_uncor_ecc_err;
   assign xp10_decomp_int.tlvp_err = fe_tlvp_error;
   assign xp10_decomp_int.bimc_int = bimc_interrupt;

   assign xp10_decomp_lz77d_stat_events = 64'(_xp10_decomp_lz77d_stat_events);
   assign xp10_decomp_hufd_stat_events = 64'(_hufd_stat_events);

    
   cr_rst_sync comp_rst
     (
      
      .rst_n                            (rst_sync_n),            
      
      .clk                              (clk),
      .async_rst_n                      (rst_n),                 
      .bypass_reset                     (scan_mode),             
      .test_rst_n                       (scan_rst_n));            

   generate if (XP10_DECOMP_STUB == 1)
     begin : xp10_decomp_stub_start
        reg [3:0] ftr_cnt;
        reg       tlv_is_ftr_reg;
        
        tlv_ftr_word12_t ftr_wd12;
        wire tlv_is_ftr = (tlv_types_e'(xp10_decomp_ib_in.tdata[7:0]) == FTR) & xp10_decomp_ib_in.tuser[0] & xp10_decomp_ib_in.tvalid;
        wire ftr_wd12_valid = tlv_is_ftr_reg && (ftr_cnt == 4'd12);
        always_comb
          begin
             xp10_decomp_ob_out_pre.tvalid = xp10_decomp_ib_in.tvalid;
             xp10_decomp_ob_out_pre.tlast  = xp10_decomp_ib_in.tlast;
             xp10_decomp_ob_out_pre.tid    = xp10_decomp_ib_in.tid;
             xp10_decomp_ob_out_pre.tstrb  = xp10_decomp_ib_in.tstrb;   
             xp10_decomp_ob_out_pre.tuser  = xp10_decomp_ib_in.tuser;  
             xp10_decomp_ob_out_pre.tdata  = xp10_decomp_ib_in.tdata;  
             xp10_decomp_ib_out.tready     = xp10_decomp_ob_in.tready; 
             
          
             if (ftr_wd12_valid) begin
                ftr_wd12 = xp10_decomp_ib_in.tdata;
                ftr_wd12.bytes_out = ftr_wd12.bytes_in;
                xp10_decomp_ob_out_pre.tdata = ftr_wd12;
             end
          end 

        always @(posedge clk or negedge rst_n) begin
           if (!rst_n) begin
              tlv_is_ftr_reg <= 1'b0;
           end
           else begin
              if ((tlv_is_ftr || tlv_is_ftr_reg) && xp10_decomp_ib_in.tvalid && xp10_decomp_ob_in.tready)
                ftr_cnt <= ftr_cnt + 1;
              else if (!tlv_is_ftr_reg)
                ftr_cnt <= '0;
              
              if (tlv_is_ftr)
                tlv_is_ftr_reg <= 1'b1;
              else if (tlv_is_ftr_reg && xp10_decomp_ib_in.tuser[1] & xp10_decomp_ib_in.tvalid &&
                       xp10_decomp_ob_in.tready)
                tlv_is_ftr_reg <= 1'b0;
          
           end 
        end 
        
        
     end 

   else
     begin : xp10_decomp_rtl_start
      
   

   cr_xp10_decomp_core 
   #(.XP10_DECOMP_STUB (XP10_DECOMP_STUB), .FPGA_MOD(FPGA_MOD))
   u_cr_xp10_decomp_core
     (
      
      .xp10_decomp_ib_out               (xp10_decomp_ib_out),
      .xp10_decomp_ob_out               (xp10_decomp_ob_out_pre), 
      .xp10_decomp_sch_update           (xp10_decomp_sch_update),
      .bimc_odat                        (bimc_core_odat),        
      .bimc_osync                       (bimc_core_osync),       
      .ro_uncorrectable_ecc_error       (ro_uncorrectable_ecc_error),
      .fe_tlvp_error                    (fe_tlvp_error),
      .lz_bytes_decomp                  (lz_bytes_decomp[16:0]),
      .lz_hb_bytes                      (lz_hb_bytes[16:0]),
      .lz_hb_head_ptr                   (lz_hb_head_ptr[11:0]),
      .lz_hb_tail_ptr                   (lz_hb_tail_ptr[11:0]),
      .lz_local_bytes                   (lz_local_bytes[16:0]),
      .xp10_decomp_lz77d_stat_events    (_xp10_decomp_lz77d_stat_events[LZ77D_STAT_EVENTS_LIMIT:LZ77D_STAT_EVENTS_BASE]), 
      .hufd_stat_events                 (_hufd_stat_events[HUFD_STAT_EVENTS_LIMIT:HUFD_STAT_EVENTS_BASE]), 
      .xpd_im_valid                     (xpd_im_valid),
      .xpd_im_data                      (xpd_im_data),
      .htf_bl_im_valid                  (htf_bl_im_valid),
      .htf_bl_im_data                   (htf_bl_im_data),
      
      .clk                              (clk),
      .rst_n                            (rst_sync_n),            
      .lvm                              (lvm),
      .mlvm                             (mlvm),
      .ovstb                            (ovstb),
      .xp10_decomp_ib_in                (xp10_decomp_ib_in),
      .xp10_decomp_ob_in                (xp10_decomp_ob_in_mod), 
      .sw_TLVP_ACTION_CFG0              (sw_TLVP_ACTION_CFG0[31:0]),
      .sw_TLVP_ACTION_CFG1              (sw_TLVP_ACTION_CFG1[31:0]),
      .su_afull_n                       (su_afull_n),
      .bimc_idat                        (bimc_core_idat),        
      .bimc_isync                       (bimc_core_isync),       
      .bimc_rst_n                       (bimc_rst_n),
      .sw_LZ_BYPASS_CONFIG              (sw_LZ_BYPASS_CONFIG),
      .sw_IGNORE_CRC_CONFIG             (sw_IGNORE_CRC_CONFIG),
      .xpd_im_ready                     (xpd_im_ready),
      .htf_bl_im_ready                  (htf_bl_im_ready),
      .xp10_decomp_module_id            (xp10_decomp_module_id[`MODULE_ID_WIDTH-1:0]),
      .sw_LZ_DECOMP_OLIMIT              (sw_LZ_DECOMP_OLIMIT[23:0]),
      .cceip_cfg                        (cceip_cfg));
     end 
   endgenerate
   
   

   cr_xp10_decomp_regfile
  
   u_cr_xp10_decomp_regfile 
     (
      
      .rbus_ring_o                      (rbus_ring_o),
      .xp10_decomp_ob_out               (xp10_decomp_ob_out),
      .xp10_decomp_ob_in_mod            (xp10_decomp_ob_in_mod),
      .im_available_xpd                 (im_available_xpd),
      .im_available_lz77d               (im_available_lz77d),
      .im_available_htf_bl              (im_available_htf_bl),
      .sw_TLVP_ACTION_CFG0              (sw_TLVP_ACTION_CFG0[31:0]),
      .sw_TLVP_ACTION_CFG1              (sw_TLVP_ACTION_CFG1[31:0]),
      .bimc_odat                        (bimc_regfile_odat),     
      .bimc_osync                       (bimc_regfile_osync),    
      .bimc_rst_n                       (bimc_rst_n),
      .bimc_ecc_error                   (bimc_ecc_error),
      .bimc_interrupt                   (bimc_interrupt),
      .sw_LZ_BYPASS_CONFIG              (sw_LZ_BYPASS_CONFIG),
      .sw_IGNORE_CRC_CONFIG             (sw_IGNORE_CRC_CONFIG),
      .xpd_im_ready                     (xpd_im_ready),
      .htf_bl_im_ready                  (htf_bl_im_ready),
      .sw_LZ_DECOMP_OLIMIT              (sw_LZ_DECOMP_OLIMIT[23:0]),
      
      .rst_n                            (rst_sync_n),            
      .clk                              (clk),
      .rbus_ring_i                      (rbus_ring_i),
      .cfg_start_addr                   (cfg_start_addr[`N_RBUS_ADDR_BITS-1:0]),
      .cfg_end_addr                     (cfg_end_addr[`N_RBUS_ADDR_BITS-1:0]),
      .xp10_decomp_ob_out_pre           (xp10_decomp_ob_out_pre),
      .xp10_decomp_ob_in                (xp10_decomp_ob_in),
      .im_consumed_xpd                  (im_consumed_xpd),
      .im_consumed_lz77d                (im_consumed_lz77d),
      .im_consumed_htf_bl               (im_consumed_htf_bl),
      .bimc_idat                        (bimc_regfile_idat),     
      .bimc_isync                       (bimc_regfile_isync),    
      .xpd_im_valid                     (xpd_im_valid),
      .xpd_im_data                      (xpd_im_data),
      .htf_bl_im_valid                  (htf_bl_im_valid),
      .htf_bl_im_data                   (htf_bl_im_data),
      .lz_bytes_decomp                  (lz_bytes_decomp[16:0]),
      .lz_hb_bytes                      (lz_hb_bytes[16:0]),
      .lz_local_bytes                   (lz_local_bytes[16:0]),
      .lz_hb_tail_ptr                   (lz_hb_tail_ptr[11:0]),
      .lz_hb_head_ptr                   (lz_hb_head_ptr[11:0]));
`endif  


 
endmodule














