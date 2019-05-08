/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/







`include "cr_lz77_comp_pkg_include.vh"

module cr_lz77_comp_regfile 

   (
   
   rbus_ring_o, lz77_comp_ob_in, im_available_lz77c,
   sw_TLV_PARSE_ACTION, sw_COMPRESSION_CFG, sw_POWER_CREDIT_BURST,
   sw_SPARE, debug_status_read,
   
   cfg_start_addr, cfg_end_addr, rst_n, clk, rbus_ring_i,
   lz77_comp_ob_out, im_consumed_lz77c, sw_LZ77_COMP_DEBUG_STATUS
   );

`include "cr_lz77_comp_includes.vh"
   
  input [`N_RBUS_ADDR_BITS-1:0]       cfg_start_addr;
  input [`N_RBUS_ADDR_BITS-1:0]       cfg_end_addr;

  
  
  
   input 	rst_n;
   input 	clk;
   
   
   
   
   input 	rbus_ring_t rbus_ring_i;
   output 	rbus_ring_t rbus_ring_o;
   
   
   
   
   input 			       axi4s_dp_bus_t lz77_comp_ob_out;
   output                              axi4s_dp_rdy_t lz77_comp_ob_in;
   input 			       im_consumed_t  im_consumed_lz77c;
   output 			       im_available_t im_available_lz77c;

   
   
   
   output 	tlv_parse_action_t           sw_TLV_PARSE_ACTION;
   output 	compression_cfg_t            sw_COMPRESSION_CFG;
   output       power_credit_burst_t         sw_POWER_CREDIT_BURST;
   input 	lz77_comp_debug_status_t     sw_LZ77_COMP_DEBUG_STATUS;
   output       spare_t                      sw_SPARE;

   output       debug_status_read;
   

   
   
   
   
   


   
   
   
   

   


   wire			            locl_ack;
   wire			            locl_err_ack;
   wire [31:0]		            locl_rd_data;
   wire			            locl_rd_strb;
   wire			            locl_wr_strb;
   wire [`CR_LZ77_COMP_DECL] 	    reg_addr;
   wire 			    reg_wr_stb;
   wire                             reg_rd_stb;
   
   logic [`CR_LZ77_COMP_DECL] 	    locl_addr;
   logic [`N_RBUS_DATA_BITS-1:0]    locl_wr_data;

   revid_t                          sw_REVID;
   out_t                            ia_wdata;
   out_ia_config_t                  ia_config;
   out_t                            ia_rdata;
   out_ia_status_t                  ia_status;
   out_ia_capability_t              ia_capability;
   out_im_status_t	            im_status;
   out_im_config_t	            im_config;
   im_din_t                         im_din;
   logic 		            im_vld;
   logic 			    im_rdy;

   

   
   always_comb begin
      lz77_comp_ob_in.tready      = im_rdy;
      im_vld                      = lz77_comp_ob_out.tvalid;
      im_din.desc.eob             = lz77_comp_ob_out.tlast;
      im_din.desc.bytes_vld       = lz77_comp_ob_out.tstrb;  
      im_din.desc.im_meta[22:15]  = 8'd0;
      im_din.desc.im_meta[14]     = lz77_comp_ob_out.tid;
      im_din.desc.im_meta[13:6]   = lz77_comp_ob_out.tuser;
      im_din.desc.im_meta[5:0]    = 6'd0;                     
      im_din.data                 = lz77_comp_ob_out.tdata;
   end 

  CR_TIE_CELL revid_wire_0 (.ob(sw_REVID.f.revid[0]), .o());
  CR_TIE_CELL revid_wire_1 (.ob(sw_REVID.f.revid[1]), .o());
  CR_TIE_CELL revid_wire_2 (.ob(sw_REVID.f.revid[2]), .o());
  CR_TIE_CELL revid_wire_3 (.ob(sw_REVID.f.revid[3]), .o());
  CR_TIE_CELL revid_wire_4 (.ob(sw_REVID.f.revid[4]), .o());
  CR_TIE_CELL revid_wire_5 (.ob(sw_REVID.f.revid[5]), .o());
  CR_TIE_CELL revid_wire_6 (.ob(sw_REVID.f.revid[6]), .o());
  CR_TIE_CELL revid_wire_7 (.ob(sw_REVID.f.revid[7]), .o());
   

   assign debug_status_read = reg_rd_stb && (reg_addr == `CR_LZ77_COMP_LZ77_COMP_DEBUG_STATUS);

   
   cr_lz77_comp_regs u_cr_lz77_comp_regs (
                                          
                                          .o_rd_data            (locl_rd_data[31:0]), 
                                          .o_ack                (locl_ack),      
                                          .o_err_ack            (locl_err_ack),  
                                          .o_spare              (sw_SPARE),      
                                          .o_tlv_parse_action_15_0(sw_TLV_PARSE_ACTION.tlv_types_15_0), 
                                          .o_tlv_parse_action_31_16(sw_TLV_PARSE_ACTION.tlv_types_31_16), 
                                          .o_compression_cfg    (sw_COMPRESSION_CFG), 
                                          .o_out_ia_wdata_part0 (ia_wdata.r.part0), 
                                          .o_out_ia_wdata_part1 (ia_wdata.r.part1), 
                                          .o_out_ia_wdata_part2 (ia_wdata.r.part2), 
                                          .o_out_ia_config      (ia_config),     
                                          .o_out_im_config      (im_config),     
                                          .o_out_im_read_done   (),              
                                          .o_power_credit_burst (sw_POWER_CREDIT_BURST), 
                                          .o_reg_written        (reg_wr_stb),    
                                          .o_reg_read           (reg_rd_stb),    
                                          .o_reg_wr_data        (),              
                                          .o_reg_addr           (reg_addr),      
                                          
                                          .clk                  (clk),
                                          .i_reset_             (rst_n),         
                                          .i_sw_init            (1'd0),          
                                          .i_addr               (locl_addr),     
                                          .i_wr_strb            (locl_wr_strb),  
                                          .i_wr_data            (locl_wr_data),  
                                          .i_rd_strb            (locl_rd_strb),  
                                          .i_revid              (sw_REVID),      
                                          .i_spare              (sw_SPARE),      
                                          .i_lz77_comp_debug_status(sw_LZ77_COMP_DEBUG_STATUS), 
                                          .i_out_ia_capability  (ia_capability), 
                                          .i_out_ia_status      (ia_status),     
                                          .i_out_ia_rdata_part0 (ia_rdata.r.part0), 
                                          .i_out_ia_rdata_part1 (ia_rdata.r.part1), 
                                          .i_out_ia_rdata_part2 (ia_rdata.r.part2), 
                                          .i_out_im_status      (im_status),     
                                          .i_out_im_read_done   (2'b0));          

   
   
   
   nx_rbus_ring 
     #(
       .N_RBUS_ADDR_BITS (`N_RBUS_ADDR_BITS),             
       .N_LOCL_ADDR_BITS (`CR_LZ77_COMP_WIDTH),           
       .N_RBUS_DATA_BITS (`N_RBUS_DATA_BITS))             
   u_nx_rbus_ring 
     (.*,
      
      .rbus_addr_o                      (rbus_ring_o.addr),      
      .rbus_wr_strb_o                   (rbus_ring_o.wr_strb),   
      .rbus_wr_data_o                   (rbus_ring_o.wr_data),   
      .rbus_rd_strb_o                   (rbus_ring_o.rd_strb),   
      .locl_addr_o                      (locl_addr),             
      .locl_wr_strb_o                   (locl_wr_strb),          
      .locl_wr_data_o                   (locl_wr_data),          
      .locl_rd_strb_o                   (locl_rd_strb),          
      .rbus_rd_data_o                   (rbus_ring_o.rd_data),   
      .rbus_ack_o                       (rbus_ring_o.ack),       
      .rbus_err_ack_o                   (rbus_ring_o.err_ack),   
      
      .rbus_addr_i                      (rbus_ring_i.addr),      
      .rbus_wr_strb_i                   (rbus_ring_i.wr_strb),   
      .rbus_wr_data_i                   (rbus_ring_i.wr_data),   
      .rbus_rd_strb_i                   (rbus_ring_i.rd_strb),   
      .rbus_rd_data_i                   (rbus_ring_i.rd_data),   
      .rbus_ack_i                       (rbus_ring_i.ack),       
      .rbus_err_ack_i                   (rbus_ring_i.err_ack),   
      .locl_rd_data_i                   (locl_rd_data),          
      .locl_ack_i                       (locl_ack),              
      .locl_err_ack_i                   (locl_err_ack));          


   
   

   
   
   nx_interface_monitor 
     #(.IN_FLIGHT       (5),                                  
       .CMND_ADDRESS    (`CR_LZ77_COMP_OUT_IA_CONFIG),        
       .STAT_ADDRESS    (`CR_LZ77_COMP_OUT_IA_STATUS),        
       .IMRD_ADDRESS    (`CR_LZ77_COMP_OUT_IM_READ_DONE),     
       .N_REG_ADDR_BITS (`CR_LZ77_COMP_WIDTH),                
       .N_DATA_BITS     (`N_AXI_IM_WIDTH),                    
       .N_ENTRIES       (`N_AXI_IM_ENTRIES),                  
       .SPECIALIZE      (1))                                  
   u_nx_interface_monitor 
     (
      
      .stat_code                        (ia_status.f.code),      
      .stat_datawords                   (ia_status.f.datawords), 
      .stat_addr                        (ia_status.f.addr),      
      .capability_lst                   (ia_capability.r.part0[15:0]), 
      .capability_type                  (ia_capability.f.mem_type), 
      .rd_dat                           (ia_rdata),              
      .bimc_odat                        (),                      
      .bimc_osync                       (),                      
      .ro_uncorrectable_ecc_error       (),                      
      .im_rdy                           (im_rdy),
      .im_available                     (im_available_lz77c),    
      .im_status                        (im_status),             
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .reg_addr                         (reg_addr),              
      .cmnd_op                          (ia_config.f.op),        
      .cmnd_addr                        (ia_config.f.addr),      
      .wr_stb                           (reg_wr_stb),            
      .wr_dat                           (ia_wdata),              
      .ovstb                            (1'd1),                  
      .lvm                              (1'd0),                  
      .mlvm                             (1'd0),                  
      .mrdten                           (1'd0),                  
      .bimc_rst_n                       (1'd0),                  
      .bimc_isync                       (1'd0),                  
      .bimc_idat                        (1'd0),                  
      .im_din                           (im_din),                
      .im_vld                           (im_vld),
      .im_consumed                      (im_consumed_lz77c),     
      .im_config                        (im_config));             
   


endmodule 










