/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/




//----------------------------------------------------------------------------------
// KME_MODIFICATION_NOTE:
// All of the changes below, indicated by a KME_MODIFICATION_NOTE comment, were done
// to trim down the engines interfaces from 1 to 0 for simplcity. The
// remaining interface is the one for CCEIP0.
//----------------------------------------------------------------------------------












`include "cr_kme.vh"

module cr_kme 
#(parameter KME_STUB = 0)

    (
  
  kme_interrupt, kme_ib_tready, kme_cceip0_ob_tvalid,
  kme_cceip0_ob_tlast, kme_cceip0_ob_tid, kme_cceip0_ob_tstrb,
  kme_cceip0_ob_tuser, kme_cceip0_ob_tdata, apb_prdata, apb_pready,
  apb_pslverr, kme_idle,
  
  clk, rst_n, scan_en, scan_mode, scan_rst_n, ovstb, lvm, mlvm,
  disable_debug_cmd, disable_unencrypted_keys, kme_ib_tvalid,
  kme_ib_tlast, kme_ib_tid, kme_ib_tstrb, kme_ib_tuser, kme_ib_tdata,
  kme_cceip0_ob_tready, apb_paddr, apb_psel, apb_penable, apb_pwrite,
  apb_pwdata
  );

    `include "ccx_std.vh"
    `include "cr_kme_body_param.v"


    
    
    
    input         clk;
    input         rst_n; 

    
    
    
    output        kme_interrupt;


    
    
    
    input         scan_en;
    input         scan_mode;
    input         scan_rst_n;

    
    
    
    input         ovstb;
    input         lvm;
    input         mlvm;

    
    
    
    input         disable_debug_cmd;
    input         disable_unencrypted_keys;

    
    
    
    input                          kme_ib_tvalid;
    input                          kme_ib_tlast;
    input [`AXI_S_TID_WIDTH-1:0]   kme_ib_tid;
    input [`AXI_S_TSTRB_WIDTH-1:0] kme_ib_tstrb;
    input [`AXI_S_USER_WIDTH-1:0]  kme_ib_tuser;
    input [`AXI_S_DP_DWIDTH-1:0]   kme_ib_tdata;
    output                         kme_ib_tready;

    
    
    
    output                          kme_cceip0_ob_tvalid;
    output                          kme_cceip0_ob_tlast;
    output [`AXI_S_TID_WIDTH-1:0]   kme_cceip0_ob_tid;
    output [`AXI_S_TSTRB_WIDTH-1:0] kme_cceip0_ob_tstrb;
    output [`AXI_S_USER_WIDTH-1:0]  kme_cceip0_ob_tuser;
    output [`AXI_S_DP_DWIDTH-1:0]   kme_cceip0_ob_tdata;
    input                           kme_cceip0_ob_tready;

    
// KME_MODIFICATION_NOTE: Lines commented out
/* -----\/----- EXCLUDED -----\/-----
    output                          kme_cceip1_ob_tvalid;
    output                          kme_cceip1_ob_tlast;
    output [`AXI_S_TID_WIDTH-1:0]   kme_cceip1_ob_tid;
    output [`AXI_S_TSTRB_WIDTH-1:0] kme_cceip1_ob_tstrb;
    output [`AXI_S_USER_WIDTH-1:0]  kme_cceip1_ob_tuser;
    output [`AXI_S_DP_DWIDTH-1:0]   kme_cceip1_ob_tdata;
    input                           kme_cceip1_ob_tready;

    output                          kme_cceip2_ob_tvalid;
    output                          kme_cceip2_ob_tlast;
    output [`AXI_S_TID_WIDTH-1:0]   kme_cceip2_ob_tid;
    output [`AXI_S_TSTRB_WIDTH-1:0] kme_cceip2_ob_tstrb;
    output [`AXI_S_USER_WIDTH-1:0]  kme_cceip2_ob_tuser;
    output [`AXI_S_DP_DWIDTH-1:0]   kme_cceip2_ob_tdata;
    input                           kme_cceip2_ob_tready;

    output                          kme_cceip3_ob_tvalid;
    output                          kme_cceip3_ob_tlast;
    output [`AXI_S_TID_WIDTH-1:0]   kme_cceip3_ob_tid;
    output [`AXI_S_TSTRB_WIDTH-1:0] kme_cceip3_ob_tstrb;
    output [`AXI_S_USER_WIDTH-1:0]  kme_cceip3_ob_tuser;
    output [`AXI_S_DP_DWIDTH-1:0]   kme_cceip3_ob_tdata;
    input                           kme_cceip3_ob_tready;

    output                          kme_cddip0_ob_tvalid;
    output                          kme_cddip0_ob_tlast;
    output [`AXI_S_TID_WIDTH-1:0]   kme_cddip0_ob_tid;
    output [`AXI_S_TSTRB_WIDTH-1:0] kme_cddip0_ob_tstrb;
    output [`AXI_S_USER_WIDTH-1:0]  kme_cddip0_ob_tuser;
    output [`AXI_S_DP_DWIDTH-1:0]   kme_cddip0_ob_tdata;
    input                           kme_cddip0_ob_tready;

    output                          kme_cddip1_ob_tvalid;
    output                          kme_cddip1_ob_tlast;
    output [`AXI_S_TID_WIDTH-1:0]   kme_cddip1_ob_tid;
    output [`AXI_S_TSTRB_WIDTH-1:0] kme_cddip1_ob_tstrb;
    output [`AXI_S_USER_WIDTH-1:0]  kme_cddip1_ob_tuser;
    output [`AXI_S_DP_DWIDTH-1:0]   kme_cddip1_ob_tdata;
    input                           kme_cddip1_ob_tready;

    output                          kme_cddip2_ob_tvalid;
    output                          kme_cddip2_ob_tlast;
    output [`AXI_S_TID_WIDTH-1:0]   kme_cddip2_ob_tid;
    output [`AXI_S_TSTRB_WIDTH-1:0] kme_cddip2_ob_tstrb;
    output [`AXI_S_USER_WIDTH-1:0]  kme_cddip2_ob_tuser;
    output [`AXI_S_DP_DWIDTH-1:0]   kme_cddip2_ob_tdata;
    input                           kme_cddip2_ob_tready;

    output                          kme_cddip3_ob_tvalid;
    output                          kme_cddip3_ob_tlast;
    output [`AXI_S_TID_WIDTH-1:0]   kme_cddip3_ob_tid;
    output [`AXI_S_TSTRB_WIDTH-1:0] kme_cddip3_ob_tstrb;
    output [`AXI_S_USER_WIDTH-1:0]  kme_cddip3_ob_tuser;
    output [`AXI_S_DP_DWIDTH-1:0]   kme_cddip3_ob_tdata;
    input                           kme_cddip3_ob_tready;
 -----/\----- EXCLUDED -----/\----- */
    
    input  [`N_KME_RBUS_ADDR_BITS-1:0]  apb_paddr;
    input                           apb_psel;
    input                           apb_penable;
    input                           apb_pwrite;
    input  [`N_RBUS_DATA_BITS-1:0]  apb_pwdata;  
    output [`N_RBUS_DATA_BITS-1:0]  apb_prdata;
    output                          apb_pready;		        
    output                          apb_pslverr;		        

    
    
    
    output kme_idle;
 
    
    kme_rbus_ring_t     rbus_ring_i;
    kme_rbus_ring_t     rbus_ring_o;

    axi4s_dp_bus_t      kme_ib_in; 
    axi4s_dp_rdy_t	    kme_ib_out;

    axi4s_dp_bus_t      kme_cceip0_ob_out; 
    axi4s_dp_bus_t      kme_cceip1_ob_out; 
    axi4s_dp_bus_t      kme_cceip2_ob_out; 
    axi4s_dp_bus_t      kme_cceip3_ob_out; 
    axi4s_dp_rdy_t	    kme_cceip0_ob_in;
    axi4s_dp_rdy_t	    kme_cceip1_ob_in;
    axi4s_dp_rdy_t	    kme_cceip2_ob_in;
    axi4s_dp_rdy_t	    kme_cceip3_ob_in;

    axi4s_dp_bus_t      kme_cddip0_ob_out; 
    axi4s_dp_bus_t      kme_cddip1_ob_out; 
    axi4s_dp_bus_t      kme_cddip2_ob_out; 
    axi4s_dp_bus_t      kme_cddip3_ob_out; 
    axi4s_dp_rdy_t	    kme_cddip0_ob_in;
    axi4s_dp_rdy_t	    kme_cddip1_ob_in;
    axi4s_dp_rdy_t	    kme_cddip2_ob_in;
    axi4s_dp_rdy_t	    kme_cddip3_ob_in;

    wire                debug_kme_ib_tready;


    
    
    wire                always_validate_kim_ref;
    wire                axi_bimc_idat;          
    wire                axi_bimc_isync;         
    wire                axi_bimc_odat;          
    wire                axi_bimc_osync;         
    wire                axi_mbe;                
    wire                bimc_rst_n;             
    wire                cceip_encrypt_bimc_idat;
    wire                cceip_encrypt_bimc_isync;
    wire                cceip_encrypt_bimc_odat;
    wire                cceip_encrypt_bimc_osync;
    kop_fifo_override_t cceip_encrypt_kop_fifo_override;
    wire                cceip_encrypt_mbe;      
    wire                cceip_validate_bimc_idat;
    wire                cceip_validate_bimc_isync;
    wire                cceip_validate_bimc_odat;
    wire                cceip_validate_bimc_osync;
    kop_fifo_override_t cceip_validate_kop_fifo_override;
    wire                cceip_validate_mbe;     
    wire                cddip_decrypt_bimc_idat;
    wire                cddip_decrypt_bimc_isync;
    wire                cddip_decrypt_bimc_odat;
    wire                cddip_decrypt_bimc_osync;
    kop_fifo_override_t cddip_decrypt_kop_fifo_override;
    wire                cddip_decrypt_mbe;      
    wire [14:0]         ckv_addr;               
    wire [`BIT_VEC(CKV_DATA_WIDTH)] ckv_dout;   
    wire                ckv_mbe;                
    wire                ckv_rd;                 
    wire [`AXI_S_DP_DWIDTH-1:0] debug_kme_ib_tdata;
    wire [`AXI_S_TID_WIDTH-1:0] debug_kme_ib_tid;
    wire                debug_kme_ib_tlast;     
    wire [`AXI_S_TSTRB_WIDTH-1:0] debug_kme_ib_tstrb;
    wire [`AXI_S_USER_WIDTH-1:0] debug_kme_ib_tuser;
    wire                debug_kme_ib_tvalid;    
    idle_t              idle_components;        
    wire [31:0]         kdf_test_key_size;      
    wire                kdf_test_mode_en;       
    wire [13:0]         kim_addr;               
    kim_entry_t         kim_dout;               
    wire                kim_mbe;                
    wire                kim_rd;                 
    axi4s_dp_rdy_t      kme_cceip0_ob_in_mod;   
    axi4s_dp_bus_t      kme_cceip0_ob_out_pre;  
    axi4s_dp_rdy_t      kme_cceip1_ob_in_mod;   
    axi4s_dp_bus_t      kme_cceip1_ob_out_pre;  
    axi4s_dp_rdy_t      kme_cceip2_ob_in_mod;   
    axi4s_dp_bus_t      kme_cceip2_ob_out_pre;  
    axi4s_dp_rdy_t      kme_cceip3_ob_in_mod;   
    axi4s_dp_bus_t      kme_cceip3_ob_out_pre;  
    axi4s_dp_rdy_t      kme_cddip0_ob_in_mod;   
    axi4s_dp_bus_t      kme_cddip0_ob_out_pre;  
    axi4s_dp_rdy_t      kme_cddip1_ob_in_mod;   
    axi4s_dp_bus_t      kme_cddip1_ob_out_pre;  
    axi4s_dp_rdy_t      kme_cddip2_ob_in_mod;   
    axi4s_dp_bus_t      kme_cddip2_ob_out_pre;  
    axi4s_dp_rdy_t      kme_cddip3_ob_in_mod;   
    axi4s_dp_bus_t      kme_cddip3_ob_out_pre;  
    label_t [7:0]       labels;                 
    wire                manual_txc;             
    wire                rst_sync_n;             
    sa_count_t          sa_count [31:0];        
    sa_ctrl_t           sa_ctrl [31:0];         
    sa_global_ctrl_t    sa_global_ctrl;         
    sa_snapshot_t       sa_snapshot [31:0];     
    wire [255:0]        seed0_internal_state_key;
    wire [127:0]        seed0_internal_state_value;
    wire                seed0_invalidate;       
    wire [47:0]         seed0_reseed_interval;  
    wire                seed0_valid;            
    wire [255:0]        seed1_internal_state_key;
    wire [127:0]        seed1_internal_state_value;
    wire                seed1_invalidate;       
    wire [47:0]         seed1_reseed_interval;  
    wire                seed1_valid;            
    wire                set_gcm_tag_fail_int;   
    wire                set_key_tlv_miscmp_int; 
    wire [7:0]          set_rsm_is_backpressuring;
    wire                set_tlv_bip2_error_int; 
    wire                set_txc_bp_int;         
    wire                suppress_key_tlvs;      
    tready_override_t   tready_override;        
    



    
    

    `ifdef SHOULD_BE_EMPTY
        
        
    `endif

    
    
    
    
    
    //----------------------------------------------------------------------------------
    // KME_MODIFICATION_NOTE:
    // Lines below added to tie off the tready input signals for all engines
    // except CCEIP0 since engine interfaces trimmed down from 8 to 1.
    //----------------------------------------------------------------------------------
    wire kme_cceip1_ob_tready = 1'b1;
    wire kme_cceip2_ob_tready = 1'b1;
    wire kme_cceip3_ob_tready = 1'b1;
    wire kme_cddip0_ob_tready = 1'b1;
    wire kme_cddip1_ob_tready = 1'b1;
    wire kme_cddip2_ob_tready = 1'b1;
    wire kme_cddip3_ob_tready = 1'b1;
 
    assign kme_ib_in.tvalid    = manual_txc ? debug_kme_ib_tvalid : kme_ib_tvalid; 
    assign kme_ib_in.tlast     = manual_txc ? debug_kme_ib_tlast  : kme_ib_tlast ; 
    assign kme_ib_in.tid       = manual_txc ? debug_kme_ib_tid    : kme_ib_tid   ; 
    assign kme_ib_in.tstrb     = manual_txc ? debug_kme_ib_tstrb  : kme_ib_tstrb ; 
    assign kme_ib_in.tuser     = manual_txc ? debug_kme_ib_tuser  : kme_ib_tuser ; 
    assign kme_ib_in.tdata     = manual_txc ? debug_kme_ib_tdata  : kme_ib_tdata ; 
    assign kme_ib_tready       = manual_txc ? 1'b1                : kme_ib_out.tready;
    assign debug_kme_ib_tready = manual_txc ? kme_ib_out.tready   : 1'b1;

    assign kme_cceip0_ob_tvalid     = kme_cceip0_ob_out.tvalid;
    assign kme_cceip0_ob_tlast      = kme_cceip0_ob_out.tlast;
    assign kme_cceip0_ob_tid        = kme_cceip0_ob_out.tid;
    assign kme_cceip0_ob_tstrb      = kme_cceip0_ob_out.tstrb;
    assign kme_cceip0_ob_tuser      = kme_cceip0_ob_out.tuser;
    assign kme_cceip0_ob_tdata      = kme_cceip0_ob_out.tdata;
    assign kme_cceip0_ob_in.tready  = kme_cceip0_ob_tready;

// KME_MODIFICATION_NOTE: Lines commented out
/* -----\/----- EXCLUDED -----\/-----
    assign kme_cceip1_ob_tvalid     = kme_cceip1_ob_out.tvalid;
    assign kme_cceip1_ob_tlast      = kme_cceip1_ob_out.tlast;
    assign kme_cceip1_ob_tid        = kme_cceip1_ob_out.tid;
    assign kme_cceip1_ob_tstrb      = kme_cceip1_ob_out.tstrb;
    assign kme_cceip1_ob_tuser      = kme_cceip1_ob_out.tuser;
    assign kme_cceip1_ob_tdata      = kme_cceip1_ob_out.tdata;
    assign kme_cceip1_ob_in.tready  = kme_cceip1_ob_tready;

    assign kme_cceip2_ob_tvalid     = kme_cceip2_ob_out.tvalid;
    assign kme_cceip2_ob_tlast      = kme_cceip2_ob_out.tlast;
    assign kme_cceip2_ob_tid        = kme_cceip2_ob_out.tid;
    assign kme_cceip2_ob_tstrb      = kme_cceip2_ob_out.tstrb;
    assign kme_cceip2_ob_tuser      = kme_cceip2_ob_out.tuser;
    assign kme_cceip2_ob_tdata      = kme_cceip2_ob_out.tdata;
    assign kme_cceip2_ob_in.tready  = kme_cceip2_ob_tready;

    assign kme_cceip3_ob_tvalid     = kme_cceip3_ob_out.tvalid;
    assign kme_cceip3_ob_tlast      = kme_cceip3_ob_out.tlast;
    assign kme_cceip3_ob_tid        = kme_cceip3_ob_out.tid;
    assign kme_cceip3_ob_tstrb      = kme_cceip3_ob_out.tstrb;
    assign kme_cceip3_ob_tuser      = kme_cceip3_ob_out.tuser;
    assign kme_cceip3_ob_tdata      = kme_cceip3_ob_out.tdata;
    assign kme_cceip3_ob_in.tready  = kme_cceip3_ob_tready;

    assign kme_cddip0_ob_tvalid     = kme_cddip0_ob_out.tvalid;
    assign kme_cddip0_ob_tlast      = kme_cddip0_ob_out.tlast;
    assign kme_cddip0_ob_tid        = kme_cddip0_ob_out.tid;
    assign kme_cddip0_ob_tstrb      = kme_cddip0_ob_out.tstrb;
    assign kme_cddip0_ob_tuser      = kme_cddip0_ob_out.tuser;
    assign kme_cddip0_ob_tdata      = kme_cddip0_ob_out.tdata;
    assign kme_cddip0_ob_in.tready  = kme_cddip0_ob_tready;

    assign kme_cddip1_ob_tvalid     = kme_cddip1_ob_out.tvalid;
    assign kme_cddip1_ob_tlast      = kme_cddip1_ob_out.tlast;
    assign kme_cddip1_ob_tid        = kme_cddip1_ob_out.tid;
    assign kme_cddip1_ob_tstrb      = kme_cddip1_ob_out.tstrb;
    assign kme_cddip1_ob_tuser      = kme_cddip1_ob_out.tuser;
    assign kme_cddip1_ob_tdata      = kme_cddip1_ob_out.tdata;
    assign kme_cddip1_ob_in.tready  = kme_cddip1_ob_tready;

    assign kme_cddip2_ob_tvalid     = kme_cddip2_ob_out.tvalid;
    assign kme_cddip2_ob_tlast      = kme_cddip2_ob_out.tlast;
    assign kme_cddip2_ob_tid        = kme_cddip2_ob_out.tid;
    assign kme_cddip2_ob_tstrb      = kme_cddip2_ob_out.tstrb;
    assign kme_cddip2_ob_tuser      = kme_cddip2_ob_out.tuser;
    assign kme_cddip2_ob_tdata      = kme_cddip2_ob_out.tdata;
    assign kme_cddip2_ob_in.tready  = kme_cddip2_ob_tready;

    assign kme_cddip3_ob_tvalid     = kme_cddip3_ob_out.tvalid;
    assign kme_cddip3_ob_tlast      = kme_cddip3_ob_out.tlast;
    assign kme_cddip3_ob_tid        = kme_cddip3_ob_out.tid;
    assign kme_cddip3_ob_tstrb      = kme_cddip3_ob_out.tstrb;
    assign kme_cddip3_ob_tuser      = kme_cddip3_ob_out.tuser;
    assign kme_cddip3_ob_tdata      = kme_cddip3_ob_out.tdata;
    assign kme_cddip3_ob_in.tready  = kme_cddip3_ob_tready;
 -----/\----- EXCLUDED -----/\----- */

    

    cr_rst_sync
    cr_rst_sync (
                 
                 .rst_n                 (rst_sync_n),            
                 
                 .clk                   (clk),
                 .async_rst_n           (rst_n),                 
                 .bypass_reset          (scan_mode),             
                 .test_rst_n            (scan_rst_n));            


    

    
    
    
    
    cr_kme_core #(.KME_STUB(KME_STUB))
    u_cr_kme_core (
                   
                   .kme_ib_out          (kme_ib_out),
                   .kme_cceip0_ob_out   (kme_cceip0_ob_out_pre), 
                   .kme_cceip1_ob_out   (kme_cceip1_ob_out_pre), 
                   .kme_cceip2_ob_out   (kme_cceip2_ob_out_pre), 
                   .kme_cceip3_ob_out   (kme_cceip3_ob_out_pre), 
                   .kme_cddip0_ob_out   (kme_cddip0_ob_out_pre), 
                   .kme_cddip1_ob_out   (kme_cddip1_ob_out_pre), 
                   .kme_cddip2_ob_out   (kme_cddip2_ob_out_pre), 
                   .kme_cddip3_ob_out   (kme_cddip3_ob_out_pre), 
                   .ckv_rd              (ckv_rd),
                   .ckv_addr            (ckv_addr[14:0]),
                   .kim_rd              (kim_rd),
                   .kim_addr            (kim_addr[13:0]),
                   .cceip_encrypt_bimc_osync(cceip_encrypt_bimc_osync),
                   .cceip_encrypt_bimc_odat(cceip_encrypt_bimc_odat),
                   .cceip_encrypt_mbe   (cceip_encrypt_mbe),
                   .cceip_validate_bimc_osync(cceip_validate_bimc_osync),
                   .cceip_validate_bimc_odat(cceip_validate_bimc_odat),
                   .cceip_validate_mbe  (cceip_validate_mbe),
                   .cddip_decrypt_bimc_osync(cddip_decrypt_bimc_osync),
                   .cddip_decrypt_bimc_odat(cddip_decrypt_bimc_odat),
                   .cddip_decrypt_mbe   (cddip_decrypt_mbe),
                   .axi_bimc_osync      (axi_bimc_osync),
                   .axi_bimc_odat       (axi_bimc_odat),
                   .axi_mbe             (axi_mbe),
                   .seed0_invalidate    (seed0_invalidate),
                   .seed1_invalidate    (seed1_invalidate),
                   .set_txc_bp_int      (set_txc_bp_int),
                   .set_gcm_tag_fail_int(set_gcm_tag_fail_int),
                   .set_key_tlv_miscmp_int(set_key_tlv_miscmp_int),
                   .set_tlv_bip2_error_int(set_tlv_bip2_error_int),
                   .set_rsm_is_backpressuring(set_rsm_is_backpressuring[7:0]),
                   .idle_components     (idle_components),
                   .sa_snapshot         (sa_snapshot),
                   .sa_count            (sa_count),
                   .kme_idle            (kme_idle),
                   
                   .clk                 (clk),
                   .rst_n               (rst_sync_n),            
                   .scan_en             (scan_en),
                   .scan_mode           (scan_mode),
                   .scan_rst_n          (scan_rst_n),
                   .disable_debug_cmd   (disable_debug_cmd),
                   .disable_unencrypted_keys(disable_unencrypted_keys),
                   .suppress_key_tlvs   (suppress_key_tlvs),
                   .always_validate_kim_ref(always_validate_kim_ref),
                   .kme_ib_in           (kme_ib_in),
                   .kme_cceip0_ob_in    (kme_cceip0_ob_in_mod),  
                   .kme_cceip1_ob_in    (kme_cceip1_ob_in_mod),  
                   .kme_cceip2_ob_in    (kme_cceip2_ob_in_mod),  
                   .kme_cceip3_ob_in    (kme_cceip3_ob_in_mod),  
                   .kme_cddip0_ob_in    (kme_cddip0_ob_in_mod),  
                   .kme_cddip1_ob_in    (kme_cddip1_ob_in_mod),  
                   .kme_cddip2_ob_in    (kme_cddip2_ob_in_mod),  
                   .kme_cddip3_ob_in    (kme_cddip3_ob_in_mod),  
                   .ckv_dout            (ckv_dout[63:0]),
                   .ckv_mbe             (ckv_mbe),
                   .kim_dout            (kim_dout),
                   .kim_mbe             (kim_mbe),
                   .bimc_rst_n          (bimc_rst_n),
                   .cceip_encrypt_bimc_isync(cceip_encrypt_bimc_isync),
                   .cceip_encrypt_bimc_idat(cceip_encrypt_bimc_idat),
                   .cceip_validate_bimc_isync(cceip_validate_bimc_isync),
                   .cceip_validate_bimc_idat(cceip_validate_bimc_idat),
                   .cddip_decrypt_bimc_isync(cddip_decrypt_bimc_isync),
                   .cddip_decrypt_bimc_idat(cddip_decrypt_bimc_idat),
                   .axi_bimc_isync      (axi_bimc_isync),
                   .axi_bimc_idat       (axi_bimc_idat),
                   .labels              (labels[7:0]),
                   .seed0_valid         (seed0_valid),
                   .seed0_internal_state_key(seed0_internal_state_key[255:0]),
                   .seed0_internal_state_value(seed0_internal_state_value[127:0]),
                   .seed0_reseed_interval(seed0_reseed_interval[47:0]),
                   .seed1_valid         (seed1_valid),
                   .seed1_internal_state_key(seed1_internal_state_key[255:0]),
                   .seed1_internal_state_value(seed1_internal_state_value[127:0]),
                   .seed1_reseed_interval(seed1_reseed_interval[47:0]),
                   .tready_override     (tready_override),
                   .cceip_encrypt_kop_fifo_override(cceip_encrypt_kop_fifo_override),
                   .cceip_validate_kop_fifo_override(cceip_validate_kop_fifo_override),
                   .cddip_decrypt_kop_fifo_override(cddip_decrypt_kop_fifo_override),
                   .kdf_test_key_size   (kdf_test_key_size[31:0]),
                   .kdf_test_mode_en    (kdf_test_mode_en),
                   .sa_global_ctrl      (sa_global_ctrl),
                   .sa_ctrl             (sa_ctrl));


    

    
    
    

    nx_rbus_apb #
    (
        .N_RBUS_ADDR_BITS(`N_KME_RBUS_ADDR_BITS),   
        .N_RBUS_DATA_BITS(`N_RBUS_DATA_BITS)    
    )
    u_nx_rbus_apb (
                   
                   .rbus_addr_o         (rbus_ring_i.addr),      
                   .rbus_wr_strb_o      (rbus_ring_i.wr_strb),   
                   .rbus_wr_data_o      (rbus_ring_i.wr_data),   
                   .rbus_rd_strb_o      (rbus_ring_i.rd_strb),   
                   .apb_prdata          (apb_prdata[(`N_RBUS_DATA_BITS)-1:0]),
                   .apb_pready          (apb_pready),
                   .apb_pslverr         (apb_pslverr),
                   
                   .clk                 (clk),
                   .rst_n               (rst_sync_n),            
                   .rbus_rd_data_i      (rbus_ring_o.rd_data),   
                   .rbus_ack_i          (rbus_ring_o.ack),       
                   .rbus_err_ack_i      (rbus_ring_o.err_ack),   
                   .rbus_wr_strb_i      (rbus_ring_o.wr_strb),   
                   .rbus_rd_strb_i      (rbus_ring_o.rd_strb),   
                   .apb_paddr           (apb_paddr[(`N_KME_RBUS_ADDR_BITS)-1:0]), 
                   .apb_psel            (apb_psel),
                   .apb_penable         (apb_penable),
                   .apb_pwrite          (apb_pwrite),
                   .apb_pwdata          (apb_pwdata[(`N_RBUS_DATA_BITS)-1:0]));

    

    
    
    
    cr_kme_regfile 
        
    u_cr_kme_regfile 
      (
       
       .suppress_key_tlvs               (suppress_key_tlvs),
       .kme_interrupt                   (kme_interrupt),
       .rbus_ring_o                     (rbus_ring_o),           
       .kme_cceip0_ob_out               (kme_cceip0_ob_out),
       .kme_cceip0_ob_in_mod            (kme_cceip0_ob_in_mod),
       .kme_cceip1_ob_out               (kme_cceip1_ob_out),
       .kme_cceip1_ob_in_mod            (kme_cceip1_ob_in_mod),
       .kme_cceip2_ob_out               (kme_cceip2_ob_out),
       .kme_cceip2_ob_in_mod            (kme_cceip2_ob_in_mod),
       .kme_cceip3_ob_out               (kme_cceip3_ob_out),
       .kme_cceip3_ob_in_mod            (kme_cceip3_ob_in_mod),
       .kme_cddip0_ob_out               (kme_cddip0_ob_out),
       .kme_cddip0_ob_in_mod            (kme_cddip0_ob_in_mod),
       .kme_cddip1_ob_out               (kme_cddip1_ob_out),
       .kme_cddip1_ob_in_mod            (kme_cddip1_ob_in_mod),
       .kme_cddip2_ob_out               (kme_cddip2_ob_out),
       .kme_cddip2_ob_in_mod            (kme_cddip2_ob_in_mod),
       .kme_cddip3_ob_out               (kme_cddip3_ob_out),
       .kme_cddip3_ob_in_mod            (kme_cddip3_ob_in_mod),
       .ckv_dout                        (ckv_dout[`BIT_VEC(CKV_DATA_WIDTH)]),
       .ckv_mbe                         (ckv_mbe),
       .kim_dout                        (kim_dout),
       .kim_mbe                         (kim_mbe),
       .bimc_rst_n                      (bimc_rst_n),
       .cceip_encrypt_bimc_isync        (cceip_encrypt_bimc_isync),
       .cceip_encrypt_bimc_idat         (cceip_encrypt_bimc_idat),
       .cceip_validate_bimc_isync       (cceip_validate_bimc_isync),
       .cceip_validate_bimc_idat        (cceip_validate_bimc_idat),
       .cddip_decrypt_bimc_isync        (cddip_decrypt_bimc_isync),
       .cddip_decrypt_bimc_idat         (cddip_decrypt_bimc_idat),
       .axi_bimc_isync                  (axi_bimc_isync),
       .axi_bimc_idat                   (axi_bimc_idat),
       .labels                          (labels[7:0]),
       .seed0_valid                     (seed0_valid),
       .seed0_internal_state_key        (seed0_internal_state_key[255:0]),
       .seed0_internal_state_value      (seed0_internal_state_value[127:0]),
       .seed0_reseed_interval           (seed0_reseed_interval[47:0]),
       .seed1_valid                     (seed1_valid),
       .seed1_internal_state_key        (seed1_internal_state_key[255:0]),
       .seed1_internal_state_value      (seed1_internal_state_value[127:0]),
       .seed1_reseed_interval           (seed1_reseed_interval[47:0]),
       .tready_override                 (tready_override),
       .cceip_encrypt_kop_fifo_override (cceip_encrypt_kop_fifo_override),
       .cceip_validate_kop_fifo_override(cceip_validate_kop_fifo_override),
       .cddip_decrypt_kop_fifo_override (cddip_decrypt_kop_fifo_override),
       .manual_txc                      (manual_txc),
       .always_validate_kim_ref         (always_validate_kim_ref),
       .kdf_test_mode_en                (kdf_test_mode_en),
       .kdf_test_key_size               (kdf_test_key_size[31:0]),
       .sa_global_ctrl                  (sa_global_ctrl),
       .sa_ctrl                         (sa_ctrl),
       .debug_kme_ib_tvalid             (debug_kme_ib_tvalid),
       .debug_kme_ib_tlast              (debug_kme_ib_tlast),
       .debug_kme_ib_tid                (debug_kme_ib_tid[`AXI_S_TID_WIDTH-1:0]),
       .debug_kme_ib_tstrb              (debug_kme_ib_tstrb[`AXI_S_TSTRB_WIDTH-1:0]),
       .debug_kme_ib_tuser              (debug_kme_ib_tuser[`AXI_S_USER_WIDTH-1:0]),
       .debug_kme_ib_tdata              (debug_kme_ib_tdata[`AXI_S_DP_DWIDTH-1:0]),
       
       .clk                             (clk),
       .rst_n                           (rst_sync_n),            
       .ovstb                           (ovstb),
       .lvm                             (lvm),
       .mlvm                            (mlvm),
       .rbus_ring_i                     (rbus_ring_i),           
       .cfg_start_addr                  (`N_KME_RBUS_ADDR_BITS'h0), 
       .cfg_end_addr                    (`N_KME_RBUS_ADDR_BITS'd`CR_KME_MAXREG), 
       .kme_cceip0_ob_out_pre           (kme_cceip0_ob_out_pre),
       .kme_cceip0_ob_in                (kme_cceip0_ob_in),
       .kme_cceip1_ob_out_pre           (kme_cceip1_ob_out_pre),
       .kme_cceip1_ob_in                (kme_cceip1_ob_in),
       .kme_cceip2_ob_out_pre           (kme_cceip2_ob_out_pre),
       .kme_cceip2_ob_in                (kme_cceip2_ob_in),
       .kme_cceip3_ob_out_pre           (kme_cceip3_ob_out_pre),
       .kme_cceip3_ob_in                (kme_cceip3_ob_in),
       .kme_cddip0_ob_out_pre           (kme_cddip0_ob_out_pre),
       .kme_cddip0_ob_in                (kme_cddip0_ob_in),
       .kme_cddip1_ob_out_pre           (kme_cddip1_ob_out_pre),
       .kme_cddip1_ob_in                (kme_cddip1_ob_in),
       .kme_cddip2_ob_out_pre           (kme_cddip2_ob_out_pre),
       .kme_cddip2_ob_in                (kme_cddip2_ob_in),
       .kme_cddip3_ob_out_pre           (kme_cddip3_ob_out_pre),
       .kme_cddip3_ob_in                (kme_cddip3_ob_in),
       .ckv_rd                          (ckv_rd),
       .ckv_addr                        (ckv_addr[`LOG_VEC(CKV_NUM_ENTRIES)]),
       .kim_rd                          (kim_rd),
       .kim_addr                        (kim_addr[`LOG_VEC(KIM_NUM_ENTRIES)]),
       .cceip_encrypt_bimc_osync        (cceip_encrypt_bimc_osync),
       .cceip_encrypt_bimc_odat         (cceip_encrypt_bimc_odat),
       .cceip_encrypt_mbe               (cceip_encrypt_mbe),
       .cceip_validate_bimc_osync       (cceip_validate_bimc_osync),
       .cceip_validate_bimc_odat        (cceip_validate_bimc_odat),
       .cceip_validate_mbe              (cceip_validate_mbe),
       .cddip_decrypt_bimc_osync        (cddip_decrypt_bimc_osync),
       .cddip_decrypt_bimc_odat         (cddip_decrypt_bimc_odat),
       .cddip_decrypt_mbe               (cddip_decrypt_mbe),
       .axi_bimc_osync                  (axi_bimc_osync),
       .axi_bimc_odat                   (axi_bimc_odat),
       .axi_mbe                         (axi_mbe),
       .seed0_invalidate                (seed0_invalidate),
       .seed1_invalidate                (seed1_invalidate),
       .set_txc_bp_int                  (set_txc_bp_int),
       .set_gcm_tag_fail_int            (set_gcm_tag_fail_int),
       .set_key_tlv_miscmp_int          (set_key_tlv_miscmp_int),
       .set_tlv_bip2_error_int          (set_tlv_bip2_error_int),
       .set_rsm_is_backpressuring       (set_rsm_is_backpressuring[7:0]),
       .idle_components                 (idle_components),
       .sa_snapshot                     (sa_snapshot),
       .sa_count                        (sa_count),
       .debug_kme_ib_tready             (debug_kme_ib_tready));


    
    assign rbus_ring_i.ack = 1'b0;
    assign rbus_ring_i.err_ack = 1'b0;
    assign rbus_ring_i.rd_data = {`N_RBUS_DATA_BITS{1'b0}};

  
endmodule









