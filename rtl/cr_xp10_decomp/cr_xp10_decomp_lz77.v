/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp_lz77 (
   
   bimc_odat, bimc_osync, lz_fhp_prefix_hdr_ready,
   lz_fhp_pre_prefix_ready, lz_fhp_usr_prefix_ready,
   lz_fhp_dbg_data_ready, lz_mtf_dp_ready, lz_be_dp_valid,
   lz_be_dp_bus, lz_bytes_decomp, lz_hb_bytes, lz_hb_head_ptr,
   lz_hb_tail_ptr, lz_local_bytes, xp10_decomp_lz77d_stat_events,
   lz77_hb_ro_uncorrectable_ecc_error_a,
   lz77_hb_ro_uncorrectable_ecc_error_b,
   lz77_pfx0_ro_uncorrectable_ecc_error,
   lz77_pfx1_ro_uncorrectable_ecc_error,
   lz77_pfx2_ro_uncorrectable_ecc_error,
   
   clk, rst_n, ovstb, lvm, mlvm, bimc_idat, bimc_isync, bimc_rst_n,
   fhp_lz_prefix_hdr_valid, fhp_lz_prefix_hdr_bus,
   fhp_lz_prefix_valid, fhp_lz_prefix_dp_bus, fhp_lz_dbg_data_valid,
   fhp_lz_dbg_data_bus, mtf_lz_dp_valid, mtf_lz_dp_bus,
   be_lz_dp_ready, sw_LZ_BYPASS_CONFIG
   );

   import crPKG::*;
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
   
   
   
   input         fhp_lz_prefix_hdr_valid;
   input         fhp_lz_prefix_hdr_bus_t fhp_lz_prefix_hdr_bus;
   output        lz_fhp_prefix_hdr_ready;

   
   
   
   input         fhp_lz_prefix_valid;
   input         fhp_lz_prefix_dp_bus_t fhp_lz_prefix_dp_bus;
   output  logic lz_fhp_pre_prefix_ready;
   output  logic lz_fhp_usr_prefix_ready;
   
   
   
   
   input         fhp_lz_dbg_data_valid;
   input         lz_symbol_bus_t fhp_lz_dbg_data_bus;
   output        lz_fhp_dbg_data_ready;

   
   
   
   input         mtf_lz_dp_valid;
   input         lz_symbol_bus_t mtf_lz_dp_bus;
   output        lz_mtf_dp_ready;
   
   
   
   
   output        lz_be_dp_valid;
   output        lz_be_dp_bus_t lz_be_dp_bus;
   input         be_lz_dp_ready;

   input         sw_LZ_BYPASS_CONFIG;

   output logic [16:0] lz_bytes_decomp; 
   output logic [16:0] lz_hb_bytes;     
   output logic [11:0] lz_hb_head_ptr;  
   output logic [11:0] lz_hb_tail_ptr;  
   output logic [16:0] lz_local_bytes;   
   output [LZ77D_STAT_EVENTS_LIMIT:LZ77D_STAT_EVENTS_BASE] xp10_decomp_lz77d_stat_events;

   output logic lz77_hb_ro_uncorrectable_ecc_error_a;
   output logic lz77_hb_ro_uncorrectable_ecc_error_b;
   output logic lz77_pfx0_ro_uncorrectable_ecc_error;
   output logic lz77_pfx1_ro_uncorrectable_ecc_error;
   output logic lz77_pfx2_ro_uncorrectable_ecc_error;
   
   
   
   logic [127:0]        ag_bm_hb_data;          
   logic                ag_ep_hb_wr;            
   logic                ag_ep_head_moved;       
   logic                ag_hb_eof;              
   logic [11:0]         ag_hb_raddr;            
   logic                ag_hb_rd;               
   logic [11:0]         ag_hb_waddr;            
   logic [127:0]        ag_hb_wdata;            
   logic                ag_hb_wr;               
   logic                ag_pl_eof;              
   logic [2:0]          bm_do_even_bytes_valid; 
   logic [1:0]          bm_do_even_type;        
   logic                bm_do_even_valid;       
   logic [63:0]         bm_do_even_word;        
   logic [2:0]          bm_do_odd_bytes_valid;  
   logic [1:0]          bm_do_odd_type;         
   logic                bm_do_odd_valid;        
   logic [63:0]         bm_do_odd_word;         
   logic                bm_ep_copy_done;        
   logic                bm_ep_pause;            
   logic [127:0]        do_ag_hb_wdata;         
   logic                do_ag_hb_wr;            
   logic                do_bm_pause;            
   logic                ep_ag_eof;              
   logic                ep_ag_hb_1st_rd;        
   logic [11:0]         ep_ag_hb_num_words;     
   logic                ep_ag_hb_rd;            
   logic [15:0]         ep_bm_copy_length;      
   logic [4:0]          ep_bm_copy_offset;      
   logic                ep_bm_copy_valid;       
   logic                ep_bm_eob;              
   logic                ep_bm_eof;              
   logic [31:0]         ep_bm_eof_err_code;     
   logic [3:0]          ep_bm_from_offset;      
   logic [31:0]         ep_bm_lit_data;         
   logic                ep_bm_lit_valid;        
   logic [5:0]          ep_bm_lwl;              
   logic                ep_bm_lwrd_valid;       
   logic [1:0]          ep_bm_num_lit;          
   logic                ep_bm_ptr_valid;        
   logic [3:0]          ep_bm_to_offset;        
   logic                ep_if_entry_done;       
   logic                ep_if_load_trace_bit;   
   logic                ep_if_trace_bit;        
   logic [127:0]        hb_ag_rdata;            
   sym_t                if_ep_sym;              
   logic                if_ep_sym_valid;        
   logic                pl_ag_load_tail;        
   logic [12:0]         pl_ag_tail_ptr;         
   logic [16:0]         pl_ep_prefix_cnt;       
   logic                pl_ep_prefix_load;      
   logic                pl_ep_trace_bit;        
   logic                pl_hb_pfx0_in_use;      
   logic [5:0]          pl_hb_pfx0_pld_waddr;   
   logic [127:0]        pl_hb_pfx0_pld_wdata;   
   logic                pl_hb_pfx0_pld_wr;      
   logic                pl_hb_pfx1_in_use;      
   logic [5:0]          pl_hb_pfx1_pld_waddr;   
   logic [127:0]        pl_hb_pfx1_pld_wdata;   
   logic                pl_hb_pfx1_pld_wr;      
   logic                pl_hb_pfx2_in_use;      
   logic [5:0]          pl_hb_pfx2_pld_waddr;   
   logic [127:0]        pl_hb_pfx2_pld_wdata;   
   logic                pl_hb_pfx2_pld_wr;      
   logic [11:0]         pl_hb_usr_waddr;        
   logic [127:0]        pl_hb_usr_wdata;        
   logic                pl_hb_usr_wr;           
   
   

   lz_symbol_bus_t      lz_dp_bus;
   logic                lz_dp_valid;

   
   assign lz_fhp_dbg_data_ready = lz_mtf_dp_ready;

   assign lz_dp_bus = (fhp_lz_dbg_data_valid) ? fhp_lz_dbg_data_bus : mtf_lz_dp_bus;
   assign lz_dp_valid = fhp_lz_dbg_data_valid || 
                        (mtf_lz_dp_valid && lz_mtf_dp_ready);

      
   
   
   cr_xp10_decomp_lz77_if if_inst (
                                   
                                   .lz_mtf_dp_ready     (lz_mtf_dp_ready),
                                   .if_ep_sym           (if_ep_sym),
                                   .if_ep_sym_valid     (if_ep_sym_valid),
                                   .lane_lit_stb        (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_LANE_1_LITERALS_TOTAL +: 4]), 
                                   .ptr_stb             (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_PTRS_TOTAL]), 
                                   .frm_in_stb          (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_FRM_IN_TOTAL]), 
                                   .frm_out_stb         (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_FRM_OUT_TOTAL]), 
                                   .lz77_stall_stb      (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_STALL_TOTAL]), 
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .mtf_lz_dp_bus       (lz_dp_bus),     
                                   .mtf_lz_dp_valid     (lz_dp_valid),   
                                   .ep_if_entry_done    (ep_if_entry_done),
                                   .sw_LZ_BYPASS_CONFIG (sw_LZ_BYPASS_CONFIG),
                                   .ep_if_load_trace_bit(ep_if_load_trace_bit),
                                   .ep_if_trace_bit     (ep_if_trace_bit));

   

   cr_xp10_decomp_lz77_ep ep_inst (
                                   
                                   .ep_ag_hb_rd         (ep_ag_hb_rd),
                                   .ep_ag_hb_num_words  (ep_ag_hb_num_words[11:0]),
                                   .ep_ag_hb_1st_rd     (ep_ag_hb_1st_rd),
                                   .ep_bm_lit_valid     (ep_bm_lit_valid),
                                   .ep_bm_num_lit       (ep_bm_num_lit[1:0]),
                                   .ep_bm_lit_data      (ep_bm_lit_data[31:0]),
                                   .ep_bm_ptr_valid     (ep_bm_ptr_valid),
                                   .ep_bm_lwrd_valid    (ep_bm_lwrd_valid),
                                   .ep_bm_from_offset   (ep_bm_from_offset[3:0]),
                                   .ep_bm_to_offset     (ep_bm_to_offset[3:0]),
                                   .ep_bm_lwl           (ep_bm_lwl[5:0]),
                                   .ep_bm_copy_valid    (ep_bm_copy_valid),
                                   .ep_bm_copy_offset   (ep_bm_copy_offset[4:0]),
                                   .ep_bm_copy_length   (ep_bm_copy_length[15:0]),
                                   .ep_bm_eof           (ep_bm_eof),
                                   .ep_bm_eof_err_code  (ep_bm_eof_err_code[31:0]),
                                   .ep_bm_eob           (ep_bm_eob),
                                   .ep_if_entry_done    (ep_if_entry_done),
                                   .ep_ag_eof           (ep_ag_eof),
                                   .ep_if_load_trace_bit(ep_if_load_trace_bit),
                                   .ep_if_trace_bit     (ep_if_trace_bit),
                                   .ptr_256_stb         (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_PTR_LEN_256_TOTAL]), 
                                   .ptr_128_stb         (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_PTR_LEN_128_TOTAL]), 
                                   .ptr_64_stb          (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_PTR_LEN_64_TOTAL]), 
                                   .ptr_32_stb          (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_PTR_LEN_32_TOTAL]), 
                                   .ptr_11_stb          (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_PTR_LEN_11_TOTAL]), 
                                   .ptr_10_stb          (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_PTR_LEN_10_TOTAL]), 
                                   .ptr_9_stb           (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_PTR_LEN_9_TOTAL]), 
                                   .ptr_8_stb           (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_PTR_LEN_8_TOTAL]), 
                                   .ptr_7_stb           (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_PTR_LEN_7_TOTAL]), 
                                   .ptr_6_stb           (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_PTR_LEN_6_TOTAL]), 
                                   .ptr_5_stb           (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_PTR_LEN_5_TOTAL]), 
                                   .ptr_4_stb           (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_PTR_LEN_4_TOTAL]), 
                                   .ptr_3_stb           (xp10_decomp_lz77d_stat_events[crPKG::LZ77D_PTR_LEN_3_TOTAL]), 
                                   .lz_bytes_decomp     (lz_bytes_decomp[16:0]),
                                   .lz_local_bytes      (lz_local_bytes[16:0]),
                                   .lz_hb_bytes         (lz_hb_bytes[16:0]),
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .if_ep_sym           (if_ep_sym),
                                   .if_ep_sym_valid     (if_ep_sym_valid),
                                   .ag_ep_head_moved    (ag_ep_head_moved),
                                   .ag_ep_hb_wr         (ag_ep_hb_wr),
                                   .bm_ep_copy_done     (bm_ep_copy_done),
                                   .pl_ep_prefix_load   (pl_ep_prefix_load),
                                   .pl_ep_prefix_cnt    (pl_ep_prefix_cnt[16:0]),
                                   .pl_ep_trace_bit     (pl_ep_trace_bit),
                                   .bm_ep_pause         (bm_ep_pause));

   cr_xp10_decomp_lz77_bm bm_inst (
                                   
                                   .bm_ep_copy_done     (bm_ep_copy_done),
                                   .bm_do_odd_word      (bm_do_odd_word[63:0]),
                                   .bm_do_odd_valid     (bm_do_odd_valid),
                                   .bm_do_odd_type      (bm_do_odd_type[1:0]),
                                   .bm_do_odd_bytes_valid(bm_do_odd_bytes_valid[2:0]),
                                   .bm_do_even_word     (bm_do_even_word[63:0]),
                                   .bm_do_even_valid    (bm_do_even_valid),
                                   .bm_do_even_type     (bm_do_even_type[1:0]),
                                   .bm_do_even_bytes_valid(bm_do_even_bytes_valid[2:0]),
                                   .bm_ep_pause         (bm_ep_pause),
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .ep_bm_lit_valid     (ep_bm_lit_valid),
                                   .ep_bm_num_lit       (ep_bm_num_lit[1:0]),
                                   .ep_bm_lit_data      (ep_bm_lit_data[31:0]),
                                   .ep_bm_ptr_valid     (ep_bm_ptr_valid),
                                   .ep_bm_from_offset   (ep_bm_from_offset[3:0]),
                                   .ep_bm_to_offset     (ep_bm_to_offset[3:0]),
                                   .ag_bm_hb_data       (ag_bm_hb_data[127:0]),
                                   .ep_bm_lwrd_valid    (ep_bm_lwrd_valid),
                                   .ep_bm_lwl           (ep_bm_lwl[5:0]),
                                   .ep_bm_copy_valid    (ep_bm_copy_valid),
                                   .ep_bm_copy_offset   (ep_bm_copy_offset[4:0]),
                                   .ep_bm_copy_length   (ep_bm_copy_length[15:0]),
                                   .ep_bm_eof           (ep_bm_eof),
                                   .ep_bm_eof_err_code  (ep_bm_eof_err_code[31:0]),
                                   .ep_bm_eob           (ep_bm_eob),
                                   .do_bm_pause         (do_bm_pause));

   cr_xp10_decomp_lz77_do do_inst (
                                   
                                   .do_bm_pause         (do_bm_pause),
                                   .lz_be_dp_valid      (lz_be_dp_valid),
                                   .lz_be_dp_bus        (lz_be_dp_bus),
                                   .do_ag_hb_wdata      (do_ag_hb_wdata[127:0]),
                                   .do_ag_hb_wr         (do_ag_hb_wr),
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .bm_do_odd_word      (bm_do_odd_word[63:0]),
                                   .bm_do_odd_valid     (bm_do_odd_valid),
                                   .bm_do_odd_type      (bm_do_odd_type[1:0]),
                                   .bm_do_odd_bytes_valid(bm_do_odd_bytes_valid[2:0]),
                                   .bm_do_even_word     (bm_do_even_word[63:0]),
                                   .bm_do_even_valid    (bm_do_even_valid),
                                   .bm_do_even_type     (bm_do_even_type[1:0]),
                                   .bm_do_even_bytes_valid(bm_do_even_bytes_valid[2:0]),
                                   .be_lz_dp_ready      (be_lz_dp_ready));

   cr_xp10_decomp_lz77_ag ag_inst (
                                   
                                   .ag_ep_head_moved    (ag_ep_head_moved),
                                   .ag_ep_hb_wr         (ag_ep_hb_wr),
                                   .ag_hb_wr            (ag_hb_wr),
                                   .ag_hb_waddr         (ag_hb_waddr[11:0]),
                                   .ag_hb_wdata         (ag_hb_wdata[127:0]),
                                   .ag_hb_rd            (ag_hb_rd),
                                   .ag_hb_raddr         (ag_hb_raddr[11:0]),
                                   .ag_bm_hb_data       (ag_bm_hb_data[127:0]),
                                   .ag_hb_eof           (ag_hb_eof),
                                   .ag_pl_eof           (ag_pl_eof),
                                   .lz_hb_tail_ptr      (lz_hb_tail_ptr[11:0]),
                                   .lz_hb_head_ptr      (lz_hb_head_ptr[11:0]),
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .ep_ag_hb_rd         (ep_ag_hb_rd),
                                   .ep_ag_hb_1st_rd     (ep_ag_hb_1st_rd),
                                   .ep_ag_hb_num_words  (ep_ag_hb_num_words[11:0]),
                                   .do_ag_hb_wr         (do_ag_hb_wr),
                                   .do_ag_hb_wdata      (do_ag_hb_wdata[127:0]),
                                   .hb_ag_rdata         (hb_ag_rdata[127:0]),
                                   .ep_ag_eof           (ep_ag_eof),
                                   .pl_ag_load_tail     (pl_ag_load_tail),
                                   .pl_ag_tail_ptr      (pl_ag_tail_ptr[12:0]));

   cr_xp10_decomp_lz77_hb hb_inst (
                                   
                                   .bimc_odat           (bimc_odat),
                                   .bimc_osync          (bimc_osync),
                                   .hb_ag_rdata         (hb_ag_rdata[127:0]),
                                   .lz77_hb_ro_uncorrectable_ecc_error_a(lz77_hb_ro_uncorrectable_ecc_error_a),
                                   .lz77_hb_ro_uncorrectable_ecc_error_b(lz77_hb_ro_uncorrectable_ecc_error_b),
                                   .lz77_pfx0_ro_uncorrectable_ecc_error(lz77_pfx0_ro_uncorrectable_ecc_error),
                                   .lz77_pfx1_ro_uncorrectable_ecc_error(lz77_pfx1_ro_uncorrectable_ecc_error),
                                   .lz77_pfx2_ro_uncorrectable_ecc_error(lz77_pfx2_ro_uncorrectable_ecc_error),
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .ovstb               (ovstb),
                                   .lvm                 (lvm),
                                   .mlvm                (mlvm),
                                   .bimc_idat           (bimc_idat),
                                   .bimc_isync          (bimc_isync),
                                   .bimc_rst_n          (bimc_rst_n),
                                   .ag_ep_hb_wr         (ag_ep_hb_wr),
                                   .ag_hb_waddr         (ag_hb_waddr[11:0]),
                                   .ag_hb_wdata         (ag_hb_wdata[127:0]),
                                   .ag_hb_rd            (ag_hb_rd),
                                   .ag_hb_raddr         (ag_hb_raddr[11:0]),
                                   .ag_hb_eof           (ag_hb_eof),
                                   .pl_hb_pfx0_pld_wr   (pl_hb_pfx0_pld_wr),
                                   .pl_hb_pfx0_pld_waddr(pl_hb_pfx0_pld_waddr[5:0]),
                                   .pl_hb_pfx0_pld_wdata(pl_hb_pfx0_pld_wdata[127:0]),
                                   .pl_hb_pfx1_pld_wr   (pl_hb_pfx1_pld_wr),
                                   .pl_hb_pfx1_pld_waddr(pl_hb_pfx1_pld_waddr[5:0]),
                                   .pl_hb_pfx1_pld_wdata(pl_hb_pfx1_pld_wdata[127:0]),
                                   .pl_hb_pfx2_pld_wr   (pl_hb_pfx2_pld_wr),
                                   .pl_hb_pfx2_pld_waddr(pl_hb_pfx2_pld_waddr[5:0]),
                                   .pl_hb_pfx2_pld_wdata(pl_hb_pfx2_pld_wdata[127:0]),
                                   .pl_hb_pfx0_in_use   (pl_hb_pfx0_in_use),
                                   .pl_hb_pfx1_in_use   (pl_hb_pfx1_in_use),
                                   .pl_hb_pfx2_in_use   (pl_hb_pfx2_in_use),
                                   .pl_hb_usr_wr        (pl_hb_usr_wr),
                                   .pl_hb_usr_wdata     (pl_hb_usr_wdata[127:0]),
                                   .pl_hb_usr_waddr     (pl_hb_usr_waddr[11:0]));

   cr_xp10_decomp_lz77_pl pl_inst (
                                   
                                   .lz_fhp_pre_prefix_ready(lz_fhp_pre_prefix_ready),
                                   .lz_fhp_usr_prefix_ready(lz_fhp_usr_prefix_ready),
                                   .lz_fhp_prefix_hdr_ready(lz_fhp_prefix_hdr_ready),
                                   .pl_hb_pfx0_pld_wr   (pl_hb_pfx0_pld_wr),
                                   .pl_hb_pfx0_pld_waddr(pl_hb_pfx0_pld_waddr[5:0]),
                                   .pl_hb_pfx0_pld_wdata(pl_hb_pfx0_pld_wdata[127:0]),
                                   .pl_hb_pfx1_pld_wr   (pl_hb_pfx1_pld_wr),
                                   .pl_hb_pfx1_pld_waddr(pl_hb_pfx1_pld_waddr[5:0]),
                                   .pl_hb_pfx1_pld_wdata(pl_hb_pfx1_pld_wdata[127:0]),
                                   .pl_hb_pfx2_pld_wr   (pl_hb_pfx2_pld_wr),
                                   .pl_hb_pfx2_pld_waddr(pl_hb_pfx2_pld_waddr[5:0]),
                                   .pl_hb_pfx2_pld_wdata(pl_hb_pfx2_pld_wdata[127:0]),
                                   .pl_hb_usr_wr        (pl_hb_usr_wr),
                                   .pl_hb_usr_wdata     (pl_hb_usr_wdata[127:0]),
                                   .pl_hb_usr_waddr     (pl_hb_usr_waddr[11:0]),
                                   .pl_ep_prefix_cnt    (pl_ep_prefix_cnt[16:0]),
                                   .pl_ep_prefix_load   (pl_ep_prefix_load),
                                   .pl_ep_trace_bit     (pl_ep_trace_bit),
                                   .pl_hb_pfx0_in_use   (pl_hb_pfx0_in_use),
                                   .pl_hb_pfx1_in_use   (pl_hb_pfx1_in_use),
                                   .pl_hb_pfx2_in_use   (pl_hb_pfx2_in_use),
                                   .pl_ag_load_tail     (pl_ag_load_tail),
                                   .pl_ag_tail_ptr      (pl_ag_tail_ptr[12:0]),
                                   
                                   .clk                 (clk),
                                   .rst_n               (rst_n),
                                   .fhp_lz_prefix_valid (fhp_lz_prefix_valid),
                                   .fhp_lz_prefix_dp_bus(fhp_lz_prefix_dp_bus),
                                   .fhp_lz_prefix_hdr_valid(fhp_lz_prefix_hdr_valid),
                                   .fhp_lz_prefix_hdr_bus(fhp_lz_prefix_hdr_bus),
                                   .ag_pl_eof           (ag_pl_eof));
   
   
endmodule 







