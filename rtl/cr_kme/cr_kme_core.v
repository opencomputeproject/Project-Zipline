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





module cr_kme_core (
  
  kme_ib_out, kme_cceip0_ob_out, kme_cceip1_ob_out, kme_cceip2_ob_out,
  kme_cceip3_ob_out, kme_cddip0_ob_out, kme_cddip1_ob_out,
  kme_cddip2_ob_out, kme_cddip3_ob_out, ckv_rd, ckv_addr, kim_rd,
  kim_addr, cceip_encrypt_bimc_osync, cceip_encrypt_bimc_odat,
  cceip_encrypt_mbe, cceip_validate_bimc_osync,
  cceip_validate_bimc_odat, cceip_validate_mbe,
  cddip_decrypt_bimc_osync, cddip_decrypt_bimc_odat,
  cddip_decrypt_mbe, axi_bimc_osync, axi_bimc_odat, axi_mbe,
  seed0_invalidate, seed1_invalidate, set_txc_bp_int,
  set_gcm_tag_fail_int, set_key_tlv_miscmp_int,
  set_tlv_bip2_error_int, set_rsm_is_backpressuring, idle_components,
  sa_snapshot, sa_count, kme_idle,
  
  clk, rst_n, scan_en, scan_mode, scan_rst_n, disable_debug_cmd,
  disable_unencrypted_keys, suppress_key_tlvs,
  always_validate_kim_ref, kme_ib_in, kme_cceip0_ob_in,
  kme_cceip1_ob_in, kme_cceip2_ob_in, kme_cceip3_ob_in,
  kme_cddip0_ob_in, kme_cddip1_ob_in, kme_cddip2_ob_in,
  kme_cddip3_ob_in, ckv_dout, ckv_mbe, kim_dout, kim_mbe, bimc_rst_n,
  cceip_encrypt_bimc_isync, cceip_encrypt_bimc_idat,
  cceip_validate_bimc_isync, cceip_validate_bimc_idat,
  cddip_decrypt_bimc_isync, cddip_decrypt_bimc_idat, axi_bimc_isync,
  axi_bimc_idat, labels, seed0_valid, seed0_internal_state_key,
  seed0_internal_state_value, seed0_reseed_interval, seed1_valid,
  seed1_internal_state_key, seed1_internal_state_value,
  seed1_reseed_interval, tready_override,
  cceip_encrypt_kop_fifo_override, cceip_validate_kop_fifo_override,
  cddip_decrypt_kop_fifo_override, kdf_test_key_size,
  kdf_test_mode_en, sa_global_ctrl, sa_ctrl
  );

    parameter KME_STUB = 0;

    `include "cr_kme_body_param.v"

    
    
    
    input clk;
    input rst_n; 

    
    
    
    input scan_en;
    input scan_mode;
    input scan_rst_n;

    
    
    
    input disable_debug_cmd;
    input disable_unencrypted_keys;
    input suppress_key_tlvs;
    input always_validate_kim_ref;

    
    
    
    input  axi4s_dp_bus_t kme_ib_in;
    output axi4s_dp_rdy_t kme_ib_out;

    
    
    
    input  axi4s_dp_rdy_t kme_cceip0_ob_in;
    output axi4s_dp_bus_t kme_cceip0_ob_out;

    
    
    
    input  axi4s_dp_rdy_t kme_cceip1_ob_in;
    output axi4s_dp_bus_t kme_cceip1_ob_out;

    
    
    
    input  axi4s_dp_rdy_t kme_cceip2_ob_in;
    output axi4s_dp_bus_t kme_cceip2_ob_out;

    
    
    
    input  axi4s_dp_rdy_t kme_cceip3_ob_in;
    output axi4s_dp_bus_t kme_cceip3_ob_out;

    
    
    
    input  axi4s_dp_rdy_t kme_cddip0_ob_in;
    output axi4s_dp_bus_t kme_cddip0_ob_out;

    
    
    
    input  axi4s_dp_rdy_t kme_cddip1_ob_in;
    output axi4s_dp_bus_t kme_cddip1_ob_out;

    
    
    
    input  axi4s_dp_rdy_t kme_cddip2_ob_in;
    output axi4s_dp_bus_t kme_cddip2_ob_out;

    
    
    
    input  axi4s_dp_rdy_t kme_cddip3_ob_in;
    output axi4s_dp_bus_t kme_cddip3_ob_out;

    
    
    
    output           ckv_rd;
    output   [14:0]  ckv_addr;
    input    [63:0]  ckv_dout;
    input            ckv_mbe;

    
    
    
    output              kim_rd;
    output      [13:0]  kim_addr;
    input  kim_entry_t  kim_dout;
    input               kim_mbe;

    
    
    
    input bimc_rst_n;

    
    
    
    output  cceip_encrypt_bimc_osync;
    output  cceip_encrypt_bimc_odat;
    input   cceip_encrypt_bimc_isync;
    input   cceip_encrypt_bimc_idat;
    output  cceip_encrypt_mbe;

    
    
    
    output  cceip_validate_bimc_osync;
    output  cceip_validate_bimc_odat;
    input   cceip_validate_bimc_isync;
    input   cceip_validate_bimc_idat;
    output  cceip_validate_mbe;

    
    
    
    output  cddip_decrypt_bimc_osync;
    output  cddip_decrypt_bimc_odat;
    input   cddip_decrypt_bimc_isync;
    input   cddip_decrypt_bimc_idat;
    output  cddip_decrypt_mbe;

    
    
    
    output  axi_bimc_osync;
    output  axi_bimc_odat;
    input   axi_bimc_isync;
    input   axi_bimc_idat;
    output  axi_mbe;

    
    
    
    input label_t [7:0] labels;
 
    
    
    
    input           seed0_valid;
    input  [255:0]  seed0_internal_state_key;
    input  [127:0]  seed0_internal_state_value;
    input   [47:0]  seed0_reseed_interval;
    input           seed1_valid;
    input  [255:0]  seed1_internal_state_key;
    input  [127:0]  seed1_internal_state_value;
    input   [47:0]  seed1_reseed_interval;
    output          seed0_invalidate;
    output          seed1_invalidate;

    
    
    
    output set_txc_bp_int;
    output set_gcm_tag_fail_int;
    output set_key_tlv_miscmp_int;
    output set_tlv_bip2_error_int;

    
    
    
    output [7:0]                set_rsm_is_backpressuring;
    input  tready_override_t    tready_override;
    input  kop_fifo_override_t  cceip_encrypt_kop_fifo_override;
    input  kop_fifo_override_t  cceip_validate_kop_fifo_override;
    input  kop_fifo_override_t  cddip_decrypt_kop_fifo_override;
    output idle_t               idle_components;
    input  [31:0]               kdf_test_key_size;
    input                       kdf_test_mode_en;

    
    
    
    input  sa_global_ctrl_t         sa_global_ctrl;
    input  sa_ctrl_t                sa_ctrl[31:0];
    output sa_snapshot_t            sa_snapshot[31:0];
    output sa_count_t               sa_count[31:0];

    
    
    
    output kme_idle;




    

    `ifdef SHOULD_BE_EMPTY
        
        
    `endif


    generate if (KME_STUB == 1) begin : kme_is_stub

        always_comb begin
            
            kme_cceip0_ob_out = {$bits(axi4s_dp_bus_t){1'b0}};
            kme_cceip1_ob_out = {$bits(axi4s_dp_bus_t){1'b0}};
            kme_cceip2_ob_out = {$bits(axi4s_dp_bus_t){1'b0}};
            kme_cceip3_ob_out = {$bits(axi4s_dp_bus_t){1'b0}};

            kme_cddip0_ob_out = {$bits(axi4s_dp_bus_t){1'b0}};
            kme_cddip1_ob_out = {$bits(axi4s_dp_bus_t){1'b0}};
            kme_cddip2_ob_out = {$bits(axi4s_dp_bus_t){1'b0}};
            kme_cddip3_ob_out = {$bits(axi4s_dp_bus_t){1'b0}};

            
            kme_ib_out.tready = 1'b1;
        end

        assign kme_idle      = ~kme_ib_in.tvalid;
        assign ckv_rd        = 1'b0;
        assign ckv_addr      = 15'b0;
        assign kim_rd        = 1'b0;
        assign kim_addr      = 14'b0;

        assign set_txc_bp_int  = 1'b0;
        assign set_gcm_tag_fail_int = 1'b0;
        assign set_key_tlv_miscmp_int = 1'b0;
        assign set_rsm_is_backpressuring = 8'b0;
        assign idle_components = {$bits(idle_t){1'b0}};

        genvar i;

        for (i=0; i<32; i=i+1) begin
            assign sa_snapshot[i] = {$bits(sa_snapshot_t){1'b0}};
            assign sa_count[i] = {$bits(sa_count_t){1'b0}};
        end

        assign seed0_invalidate = 1'b0;
        assign seed1_invalidate = 1'b0;

    end else begin : kme_is_core

        
        
        wire            cceip_encrypt_gcm_tag_fail_int;
        kme_internal_t  cceip_encrypt_in;       
        wire            cceip_encrypt_in_stall; 
        wire            cceip_encrypt_in_valid; 
        wire            cceip_encrypt_ob_afull; 
        wire            cceip_encrypt_ob_full;  
        tlvp_if_bus_t   cceip_encrypt_ob_tlv;   
        wire            cceip_encrypt_ob_wr;    
        wire [($bits(kme_internal_t))-1:0] cceip_encrypt_out;
        wire            cceip_encrypt_out_ack;  
        wire            cceip_encrypt_out_valid;
        wire [3:0]      cceip_key_tlv_rsm_end_pulse;
        wire [3:0]      cceip_key_tlv_rsm_idle; 
        wire [3:0]      cceip_ob_afull;         
        wire [3:0]      cceip_ob_full;          
        tlvp_if_bus_t [3:0] cceip_ob_tlv;       
        wire [3:0]      cceip_ob_wr;            
        wire            cceip_validate_gcm_tag_fail_int;
        kme_internal_t  cceip_validate_in;      
        wire            cceip_validate_in_stall;
        wire            cceip_validate_in_valid;
        wire            cceip_validate_ob_afull;
        wire            cceip_validate_ob_full; 
        tlvp_if_bus_t   cceip_validate_ob_tlv;  
        wire            cceip_validate_ob_wr;   
        wire [($bits(kme_internal_t))-1:0] cceip_validate_out;
        wire            cceip_validate_out_ack; 
        wire            cceip_validate_out_valid;
        wire            cddip_decrypt_gcm_tag_fail_int;
        kme_internal_t  cddip_decrypt_in;       
        wire            cddip_decrypt_in_stall; 
        wire            cddip_decrypt_in_valid; 
        wire [3:0]      cddip_key_tlv_rsm_end_pulse;
        wire [3:0]      cddip_key_tlv_rsm_idle; 
        wire [3:0]      cddip_ob_afull;         
        axi4s_dp_rdy_t  core_kme_ib_out;        
        wire            disable_debug_cmd_q;    
        wire [127:0]    drng_256_out;           
        wire            drng_ack;               
        wire            drng_health_fail;       
        wire            drng_idle;              
        wire            drng_seed_expired;      
        wire            drng_valid;             
        wire            kme_slv_aempty;         
        wire            kme_slv_empty;          
        axi4s_dp_bus_t  kme_slv_out;            
        wire            kme_slv_rd;             
        wire            stat_aux_cmd_with_vf_pf_fail;
        wire            stat_aux_key_type_0;    
        wire            stat_aux_key_type_1;    
        wire            stat_aux_key_type_10;   
        wire            stat_aux_key_type_11;   
        wire            stat_aux_key_type_12;   
        wire            stat_aux_key_type_13;   
        wire            stat_aux_key_type_2;    
        wire            stat_aux_key_type_3;    
        wire            stat_aux_key_type_4;    
        wire            stat_aux_key_type_5;    
        wire            stat_aux_key_type_6;    
        wire            stat_aux_key_type_7;    
        wire            stat_aux_key_type_8;    
        wire            stat_aux_key_type_9;    
        wire            stat_cceip0_stall_on_valid_key;
        wire            stat_cceip1_stall_on_valid_key;
        wire            stat_cceip2_stall_on_valid_key;
        wire            stat_cceip3_stall_on_valid_key;
        wire            stat_cddip0_stall_on_valid_key;
        wire            stat_cddip1_stall_on_valid_key;
        wire            stat_cddip2_stall_on_valid_key;
        wire            stat_cddip3_stall_on_valid_key;
        wire            stat_drbg_reseed;       
        wire            stat_req_with_expired_seed;
        wire            tlv_parser_idle;        
        wire            tlv_parser_int_tlv_start_pulse;
        wire [3:0]      cddip_ob_full;          
        
//----------------------------------------------------------------------------------
// KME_MODIFICATION_NOTE: Lines commented out since signals no longer exist
//----------------------------------------------------------------------------------
/* -----\/----- EXCLUDED -----\/-----
        wire            cddip_decrypt_ob_afull; 
        wire            cddip_decrypt_ob_full;  
        tlvp_if_bus_t   cddip_decrypt_ob_tlv;   
        wire            cddip_decrypt_ob_wr;    
        wire [($bits(kme_internal_t))-1:0] cddip_decrypt_out; 
        wire            cddip_decrypt_out_ack;  
        wire            cddip_decrypt_out_valid;
        tlvp_if_bus_t [3:0] cddip_ob_tlv;       
        wire [3:0]      cddip_ob_wr;            
 -----/\----- EXCLUDED -----/\----- */
       
       //----------------------------------------------------------------------------------
       // KME_MODIFICATION_NOTE: Lines added
       // Assigns added below since driver of these signals no longer exists
       //----------------------------------------------------------------------------------
       assign kme_cceip1_ob_out = {$bits(axi4s_dp_bus_t){1'b0}};
       assign kme_cceip2_ob_out = {$bits(axi4s_dp_bus_t){1'b0}};
       assign kme_cceip3_ob_out = {$bits(axi4s_dp_bus_t){1'b0}};
       assign kme_cddip0_ob_out = {$bits(axi4s_dp_bus_t){1'b0}};
       assign kme_cddip1_ob_out = {$bits(axi4s_dp_bus_t){1'b0}};
       assign kme_cddip2_ob_out = {$bits(axi4s_dp_bus_t){1'b0}};
       assign kme_cddip3_ob_out = {$bits(axi4s_dp_bus_t){1'b0}};

       assign cddip_decrypt_in_stall         = 1'b0;  
       assign stat_cceip1_stall_on_valid_key = 1'b0;
       assign stat_cceip2_stall_on_valid_key = 1'b0;
       assign stat_cceip3_stall_on_valid_key = 1'b0;
       assign stat_cddip0_stall_on_valid_key = 1'b0;
       assign stat_cddip1_stall_on_valid_key = 1'b0;
       assign stat_cddip2_stall_on_valid_key = 1'b0;
       assign stat_cddip3_stall_on_valid_key = 1'b0;

       assign cceip_key_tlv_rsm_end_pulse[3:1] = 3'b0; 
       assign cddip_key_tlv_rsm_end_pulse[3:0] = 4'b0;
       assign cceip_key_tlv_rsm_idle[3:1]      = 3'b0;
       assign cddip_key_tlv_rsm_idle[3:0]      = 4'b0;
       assign cddip_decrypt_gcm_tag_fail_int   = 1'b0;
       assign cddip_ob_full[3:0] = 4'b0;

       assign cddip_decrypt_bimc_osync         = 1'b0;
       assign cddip_decrypt_bimc_odat          = 1'b0;
       assign cddip_decrypt_mbe                = 1'b0;

        
        
        

        cr_axi4s2_slv #
        (
            .N_ENTRIES(168),
            .N_AFULL_VAL(1),
            .N_AEMPTY_VAL(1),
            .USE_RAM(1)
        )
        txc_axi_intf (
                      
                      .axi4s_ib_out     (core_kme_ib_out),       
                      .axi4s_slv_out    (kme_slv_out),           
                      .axi4s_slv_empty  (kme_slv_empty),         
                      .axi4s_slv_aempty (kme_slv_aempty),        
                      .axi4s_slv_bimc_odat(axi_bimc_odat),       
                      .axi4s_slv_bimc_osync(axi_bimc_osync),     
                      .axi4s_slv_ro_uncorrectable_ecc_error(axi_mbe), 
                      
                      .clk              (clk),
                      .rst_n            (rst_n),
                      .axi4s_ib_in      (kme_ib_in),             
                      .axi4s_slv_rd     (kme_slv_rd),            
                      .axi4s_slv_bimc_idat(axi_bimc_idat),       
                      .axi4s_slv_bimc_isync(axi_bimc_isync),     
                      .bimc_rst_n       (bimc_rst_n));            

        

        
        
        

        cr_kme_drng
        drng (
              
              .drng_health_fail         (drng_health_fail),
              .drng_seed_expired        (drng_seed_expired),
              .drng_256_out             (drng_256_out[127:0]),
              .drng_valid               (drng_valid),
              .seed0_invalidate         (seed0_invalidate),
              .seed1_invalidate         (seed1_invalidate),
              .stat_drbg_reseed         (stat_drbg_reseed),
              .drng_idle                (drng_idle),
              
              .clk                      (clk),
              .rst_n                    (rst_n),
              .drng_ack                 (drng_ack),
              .seed0_valid              (seed0_valid),
              .seed0_internal_state_key (seed0_internal_state_key[255:0]),
              .seed0_internal_state_value(seed0_internal_state_value[127:0]),
              .seed0_reseed_interval    (seed0_reseed_interval[47:0]),
              .seed1_valid              (seed1_valid),
              .seed1_internal_state_key (seed1_internal_state_key[255:0]),
              .seed1_internal_state_value(seed1_internal_state_value[127:0]),
              .seed1_reseed_interval    (seed1_reseed_interval[47:0]));
 

        

        
        
        

        cr_kme_ckv_pipeline
        ckv_pipeline (
                      
                      .kme_slv_rd       (kme_slv_rd),
                      .cceip_encrypt_in (cceip_encrypt_in),
                      .cceip_encrypt_in_valid(cceip_encrypt_in_valid),
                      .cceip_validate_in(cceip_validate_in),
                      .cceip_validate_in_valid(cceip_validate_in_valid),
                      .cddip_decrypt_in (cddip_decrypt_in),
                      .cddip_decrypt_in_valid(cddip_decrypt_in_valid),
                      .ckv_rd           (ckv_rd),
                      .ckv_addr         (ckv_addr[14:0]),
                      .kim_rd           (kim_rd),
                      .kim_addr         (kim_addr[13:0]),
                      .drng_ack         (drng_ack),
                      .stat_req_with_expired_seed(stat_req_with_expired_seed),
                      .stat_aux_key_type_0(stat_aux_key_type_0),
                      .stat_aux_key_type_1(stat_aux_key_type_1),
                      .stat_aux_key_type_2(stat_aux_key_type_2),
                      .stat_aux_key_type_3(stat_aux_key_type_3),
                      .stat_aux_key_type_4(stat_aux_key_type_4),
                      .stat_aux_key_type_5(stat_aux_key_type_5),
                      .stat_aux_key_type_6(stat_aux_key_type_6),
                      .stat_aux_key_type_7(stat_aux_key_type_7),
                      .stat_aux_key_type_8(stat_aux_key_type_8),
                      .stat_aux_key_type_9(stat_aux_key_type_9),
                      .stat_aux_key_type_10(stat_aux_key_type_10),
                      .stat_aux_key_type_11(stat_aux_key_type_11),
                      .stat_aux_key_type_12(stat_aux_key_type_12),
                      .stat_aux_key_type_13(stat_aux_key_type_13),
                      .stat_aux_cmd_with_vf_pf_fail(stat_aux_cmd_with_vf_pf_fail),
                      .tlv_parser_idle  (tlv_parser_idle),
                      .tlv_parser_int_tlv_start_pulse(tlv_parser_int_tlv_start_pulse),
                      .set_tlv_bip2_error_int(set_tlv_bip2_error_int),
                      
                      .clk              (clk),
                      .rst_n            (rst_n),
                      .disable_debug_cmd_q(disable_debug_cmd_q),
                      .disable_unencrypted_keys(disable_unencrypted_keys),
                      .always_validate_kim_ref(always_validate_kim_ref),
                      .kme_slv_out      (kme_slv_out),
                      .kme_slv_aempty   (kme_slv_aempty),
                      .kme_slv_empty    (kme_slv_empty),
                      .cceip_encrypt_in_stall(cceip_encrypt_in_stall),
                      .cceip_validate_in_stall(cceip_validate_in_stall),
                      .cddip_decrypt_in_stall(cddip_decrypt_in_stall),
                      .ckv_dout         (ckv_dout[63:0]),
                      .ckv_mbe          (ckv_mbe),
                      .kim_dout         (kim_dout),
                      .kim_mbe          (kim_mbe),
                      .drng_seed_expired(drng_seed_expired),
                      .drng_health_fail (drng_health_fail),
                      .drng_256_out     (drng_256_out[127:0]),
                      .drng_valid       (drng_valid));



        

        
        
        

        cr_kme_ram_fifo #
        (
            .DATA_SIZE($bits(kme_internal_t)),
            .FIFO_DEPTH(2048),
            .SPECIALIZE(1)
        )
        cceip_encrypt_kop_fifo (
                                
                                .fifo_in_stall  (cceip_encrypt_in_stall), 
                                .fifo_out       (cceip_encrypt_out[($bits(kme_internal_t))-1:0]), 
                                .fifo_out_valid (cceip_encrypt_out_valid), 
                                .fifo_bimc_osync(cceip_encrypt_bimc_osync), 
                                .fifo_bimc_odat (cceip_encrypt_bimc_odat), 
                                .fifo_mbe       (cceip_encrypt_mbe), 
                                
                                .clk            (clk),
                                .rst_n          (rst_n),
                                .fifo_in        (cceip_encrypt_in[($bits(kme_internal_t))-1:0]), 
                                .fifo_in_valid  (cceip_encrypt_in_valid), 
                                .fifo_out_ack   (cceip_encrypt_out_ack), 
                                .bimc_rst_n     (bimc_rst_n),
                                .fifo_bimc_isync(cceip_encrypt_bimc_isync), 
                                .fifo_bimc_idat (cceip_encrypt_bimc_idat)); 

        cr_kme_ram_fifo #
        (
            .DATA_SIZE($bits(kme_internal_t)),
            .FIFO_DEPTH(2048),
            .SPECIALIZE(1)
        )
        cceip_validate_kop_fifo (
                                 
                                 .fifo_in_stall         (cceip_validate_in_stall), 
                                 .fifo_out              (cceip_validate_out[($bits(kme_internal_t))-1:0]), 
                                 .fifo_out_valid        (cceip_validate_out_valid), 
                                 .fifo_bimc_osync       (cceip_validate_bimc_osync), 
                                 .fifo_bimc_odat        (cceip_validate_bimc_odat), 
                                 .fifo_mbe              (cceip_validate_mbe), 
                                 
                                 .clk                   (clk),
                                 .rst_n                 (rst_n),
                                 .fifo_in               (cceip_validate_in[($bits(kme_internal_t))-1:0]), 
                                 .fifo_in_valid         (cceip_validate_in_valid), 
                                 .fifo_out_ack          (cceip_validate_out_ack), 
                                 .bimc_rst_n            (bimc_rst_n),
                                 .fifo_bimc_isync       (cceip_validate_bimc_isync), 
                                 .fifo_bimc_idat        (cceip_validate_bimc_idat)); 



// KME_MODIFICATION_NOTE: Lines commented out
/* -----\/----- EXCLUDED -----\/-----
        cr_kme_ram_fifo #
        (
            .DATA_SIZE($bits(kme_internal_t)),
            .FIFO_DEPTH(2048),
            .SPECIALIZE(1)
        )
        cddip_decrypt_kop_fifo (
                                .fifo_in_stall  (cddip_decrypt_in_stall), 
                                .fifo_out       (cddip_decrypt_out[($bits(kme_internal_t))-1:0]), 
                                .fifo_out_valid (cddip_decrypt_out_valid), 
                                .fifo_bimc_osync(cddip_decrypt_bimc_osync), 
                                .fifo_bimc_odat (cddip_decrypt_bimc_odat), 
                                .fifo_mbe       (cddip_decrypt_mbe), 

                                .clk            (clk),
                                .rst_n          (rst_n),
                                .fifo_in        (cddip_decrypt_in[($bits(kme_internal_t))-1:0]), 
                                .fifo_in_valid  (cddip_decrypt_in_valid), 
                                .fifo_out_ack   (cddip_decrypt_out_ack), 
                                .bimc_rst_n     (bimc_rst_n),
                                .fifo_bimc_isync(cddip_decrypt_bimc_isync), 
                                .fifo_bimc_idat (cddip_decrypt_bimc_idat)); 


 -----/\----- EXCLUDED -----/\----- */
        

        cr_kme_kop #
        (
            .CCEIP_ENCRYPT_KOP(1)
        )
        cceip_encrypt_kop (
                           
                           .kme_internal_out_ack(cceip_encrypt_out_ack), 
                           .key_tlv_ob_wr       (cceip_encrypt_ob_wr), 
                           .key_tlv_ob_tlv      (cceip_encrypt_ob_tlv), 
                           .set_gcm_tag_fail_int(cceip_encrypt_gcm_tag_fail_int), 
                           
                           .clk                 (clk),
                           .rst_n               (rst_n),
                           .scan_en             (scan_en),
                           .scan_mode           (scan_mode),
                           .scan_rst_n          (scan_rst_n),
                           .labels              (labels[7:0]),
                           .kme_internal_out    (cceip_encrypt_out), 
                           .kme_internal_out_valid(cceip_encrypt_out_valid), 
                           .key_tlv_ob_full     (cceip_encrypt_ob_full), 
                           .key_tlv_ob_afull    (cceip_encrypt_ob_afull), 
                           .kop_fifo_override   (cceip_encrypt_kop_fifo_override), 
                           .kdf_test_key_size   (kdf_test_key_size[31:0]),
                           .kdf_test_mode_en    (kdf_test_mode_en));

        cr_kme_kop #
        (
            .CCEIP_ENCRYPT_KOP(0)
        )
        cceip_validate_kop (
                            
                            .kme_internal_out_ack(cceip_validate_out_ack), 
                            .key_tlv_ob_wr      (cceip_validate_ob_wr), 
                            .key_tlv_ob_tlv     (cceip_validate_ob_tlv), 
                            .set_gcm_tag_fail_int(cceip_validate_gcm_tag_fail_int), 
                            
                            .clk                (clk),
                            .rst_n              (rst_n),
                            .scan_en            (scan_en),
                            .scan_mode          (scan_mode),
                            .scan_rst_n         (scan_rst_n),
                            .labels             (labels[7:0]),
                            .kme_internal_out   (cceip_validate_out), 
                            .kme_internal_out_valid(cceip_validate_out_valid), 
                            .key_tlv_ob_full    (cceip_validate_ob_full), 
                            .key_tlv_ob_afull   (cceip_validate_ob_afull), 
                            .kop_fifo_override  (cceip_validate_kop_fifo_override), 
                            .kdf_test_key_size  (kdf_test_key_size[31:0]),
                            .kdf_test_mode_en   (kdf_test_mode_en));



// KME_MODIFICATION_NOTE: Lines commented out
/* -----\/----- EXCLUDED -----\/-----

        cr_kme_kop #
        (
            .CCEIP_ENCRYPT_KOP(0)
        )
        cddip_decrypt_kop (
                           // Outputs
                           .kme_internal_out_ack(cddip_decrypt_out_ack), 
                           .key_tlv_ob_wr       (cddip_decrypt_ob_wr), 
                           .key_tlv_ob_tlv      (cddip_decrypt_ob_tlv), 
                           .set_gcm_tag_fail_int(cddip_decrypt_gcm_tag_fail_int), 
                           // Inputs
                           .clk                 (clk),
                           .rst_n               (rst_n),
                           .scan_en             (scan_en),
                           .scan_mode           (scan_mode),
                           .scan_rst_n          (scan_rst_n),
                           .labels              (labels[7:0]),
                           .kme_internal_out    (cddip_decrypt_out), 
                           .kme_internal_out_valid(cddip_decrypt_out_valid), 
                           .key_tlv_ob_full     (cddip_decrypt_ob_full), 
                           .key_tlv_ob_afull    (cddip_decrypt_ob_afull), 
                           .kop_fifo_override   (cddip_decrypt_kop_fifo_override), 
                           .kdf_test_key_size   (kdf_test_key_size[31:0]),
                           .kdf_test_mode_en    (kdf_test_mode_en));
 -----/\----- EXCLUDED -----/\----- */

        
        
        cr_kme_key_tlv_compare_split
        cceip_key_tlv_compare_split (
                                     
                                     .set_key_tlv_miscmp_int(set_key_tlv_miscmp_int),
                                     .cceip_encrypt_ob_full(cceip_encrypt_ob_full),
                                     .cceip_encrypt_ob_afull(cceip_encrypt_ob_afull),
                                     .cceip_validate_ob_full(cceip_validate_ob_full),
                                     .cceip_validate_ob_afull(cceip_validate_ob_afull),
                                     .cceip_ob_wr       (cceip_ob_wr[3:0]),
                                     .cceip_ob_tlv      (cceip_ob_tlv[3:0]),
                                     
                                     .clk               (clk),
                                     .rst_n             (rst_n),
                                     .suppress_key_tlvs (suppress_key_tlvs),
                                     .cceip_encrypt_ob_wr(cceip_encrypt_ob_wr),
                                     .cceip_encrypt_ob_tlv(cceip_encrypt_ob_tlv),
                                     .cceip_validate_ob_wr(cceip_validate_ob_wr),
                                     .cceip_validate_ob_tlv(cceip_validate_ob_tlv),
                                     .cceip_ob_full     (cceip_ob_full[3:0]),
                                     .cceip_ob_afull    (cceip_ob_afull[3:0]));

// KME_MODIFICATION_NOTE: Lines commented out
/* -----\/----- EXCLUDED -----\/-----

        // ---------------------------------------
        // Key TLV Splitter
        // ---------------------------------------
        cr_kme_key_tlv_split
        cddip_key_tlv_split (
                             // Outputs
                             .cddip_decrypt_ob_full(cddip_decrypt_ob_full),
                             .cddip_decrypt_ob_afull(cddip_decrypt_ob_afull),
                             .cddip_ob_wr       (cddip_ob_wr[3:0]),
                             .cddip_ob_tlv      (cddip_ob_tlv[3:0]),
                             // Inputs
                             .clk               (clk),
                             .rst_n             (rst_n),
                             .suppress_key_tlvs (suppress_key_tlvs),
                             .cddip_decrypt_ob_wr(cddip_decrypt_ob_wr),
                             .cddip_decrypt_ob_tlv(cddip_decrypt_ob_tlv),
                             .cddip_ob_full     (cddip_ob_full[3:0]),
                             .cddip_ob_afull    (cddip_ob_afull[3:0]));

 -----/\----- EXCLUDED -----/\----- */
        
        cr_kme_key_tlv_rsm
        cceip0_key_tlv_rsm (
                            
                            .usr_ob_full        (cceip_ob_full[0]), 
                            .usr_ob_afull       (cceip_ob_afull[0]), 
                            .axi4s_ob_out       (kme_cceip0_ob_out), 
                            .stat_stall_on_valid_key(stat_cceip0_stall_on_valid_key), 
                            .key_tlv_rsm_end_pulse(cceip_key_tlv_rsm_end_pulse[0]), 
                            .key_tlv_rsm_idle   (cceip_key_tlv_rsm_idle[0]), 
                            
                            .clk                (clk),
                            .rst_n              (rst_n),
                            .usr_ob_wr          (cceip_ob_wr[0]), 
                            .usr_ob_tlv         (cceip_ob_tlv[0]), 
                            .axi4s_ob_in        (kme_cceip0_ob_in)); 


// KME_MODIFICATION_NOTE: Lines commented out
/* -----\/----- EXCLUDED -----\/-----
        cr_kme_key_tlv_rsm
        cceip1_key_tlv_rsm (
                            // Outputs
                            .usr_ob_full        (cceip_ob_full[1]), 
                            .usr_ob_afull       (cceip_ob_afull[1]), 
                            .axi4s_ob_out       (kme_cceip1_ob_out), 
                            .stat_stall_on_valid_key(stat_cceip1_stall_on_valid_key), 
                            .key_tlv_rsm_end_pulse(cceip_key_tlv_rsm_end_pulse[1]), 
                            .key_tlv_rsm_idle   (cceip_key_tlv_rsm_idle[1]), 
                            // Inputs
                            .clk                (clk),
                            .rst_n              (rst_n),
                            .usr_ob_wr          (cceip_ob_wr[1]), 
                            .usr_ob_tlv         (cceip_ob_tlv[1]), 
                            .axi4s_ob_in        (kme_cceip1_ob_in)); 

        cr_kme_key_tlv_rsm
        cceip2_key_tlv_rsm (
                            // Outputs
                            .usr_ob_full        (cceip_ob_full[2]), 
                            .usr_ob_afull       (cceip_ob_afull[2]), 
                            .axi4s_ob_out       (kme_cceip2_ob_out), 
                            .stat_stall_on_valid_key(stat_cceip2_stall_on_valid_key), 
                            .key_tlv_rsm_end_pulse(cceip_key_tlv_rsm_end_pulse[2]), 
                            .key_tlv_rsm_idle   (cceip_key_tlv_rsm_idle[2]), 
                            // Inputs
                            .clk                (clk),
                            .rst_n              (rst_n),
                            .usr_ob_wr          (cceip_ob_wr[2]), 
                            .usr_ob_tlv         (cceip_ob_tlv[2]), 
                            .axi4s_ob_in        (kme_cceip2_ob_in)); 

        cr_kme_key_tlv_rsm
        cceip3_key_tlv_rsm (
                            // Outputs
                            .usr_ob_full        (cceip_ob_full[3]), 
                            .usr_ob_afull       (cceip_ob_afull[3]), 
                            .axi4s_ob_out       (kme_cceip3_ob_out), 
                            .stat_stall_on_valid_key(stat_cceip3_stall_on_valid_key), 
                            .key_tlv_rsm_end_pulse(cceip_key_tlv_rsm_end_pulse[3]), 
                            .key_tlv_rsm_idle   (cceip_key_tlv_rsm_idle[3]), 
                            // Inputs
                            .clk                (clk),
                            .rst_n              (rst_n),
                            .usr_ob_wr          (cceip_ob_wr[3]), 
                            .usr_ob_tlv         (cceip_ob_tlv[3]), 
                            .axi4s_ob_in        (kme_cceip3_ob_in)); 

        cr_kme_key_tlv_rsm
        cddip0_key_tlv_rsm (
                            // Outputs
                            .usr_ob_full        (cddip_ob_full[0]), 
                            .usr_ob_afull       (cddip_ob_afull[0]), 
                            .axi4s_ob_out       (kme_cddip0_ob_out), 
                            .stat_stall_on_valid_key(stat_cddip0_stall_on_valid_key), 
                            .key_tlv_rsm_end_pulse(cddip_key_tlv_rsm_end_pulse[0]), 
                            .key_tlv_rsm_idle   (cddip_key_tlv_rsm_idle[0]), 
                            // Inputs
                            .clk                (clk),
                            .rst_n              (rst_n),
                            .usr_ob_wr          (cddip_ob_wr[0]), 
                            .usr_ob_tlv         (cddip_ob_tlv[0]), 
                            .axi4s_ob_in        (kme_cddip0_ob_in)); 

        cr_kme_key_tlv_rsm
        cddip1_key_tlv_rsm (
                            // Outputs
                            .usr_ob_full        (cddip_ob_full[1]), 
                            .usr_ob_afull       (cddip_ob_afull[1]), 
                            .axi4s_ob_out       (kme_cddip1_ob_out), 
                            .stat_stall_on_valid_key(stat_cddip1_stall_on_valid_key), 
                            .key_tlv_rsm_end_pulse(cddip_key_tlv_rsm_end_pulse[1]), 
                            .key_tlv_rsm_idle   (cddip_key_tlv_rsm_idle[1]), 
                            // Inputs
                            .clk                (clk),
                            .rst_n              (rst_n),
                            .usr_ob_wr          (cddip_ob_wr[1]), 
                            .usr_ob_tlv         (cddip_ob_tlv[1]), 
                            .axi4s_ob_in        (kme_cddip1_ob_in)); 

        cr_kme_key_tlv_rsm
        cddip2_key_tlv_rsm (
                            // Outputs
                            .usr_ob_full        (cddip_ob_full[2]), 
                            .usr_ob_afull       (cddip_ob_afull[2]), 
                            .axi4s_ob_out       (kme_cddip2_ob_out), 
                            .stat_stall_on_valid_key(stat_cddip2_stall_on_valid_key), 
                            .key_tlv_rsm_end_pulse(cddip_key_tlv_rsm_end_pulse[2]), 
                            .key_tlv_rsm_idle   (cddip_key_tlv_rsm_idle[2]), 
                            // Inputs
                            .clk                (clk),
                            .rst_n              (rst_n),
                            .usr_ob_wr          (cddip_ob_wr[2]), 
                            .usr_ob_tlv         (cddip_ob_tlv[2]), 
                            .axi4s_ob_in        (kme_cddip2_ob_in)); 

        cr_kme_key_tlv_rsm
        cddip3_key_tlv_rsm (
                            // Outputs
                            .usr_ob_full        (cddip_ob_full[3]), 
                            .usr_ob_afull       (cddip_ob_afull[3]), 
                            .axi4s_ob_out       (kme_cddip3_ob_out), 
                            .stat_stall_on_valid_key(stat_cddip3_stall_on_valid_key), 
                            .key_tlv_rsm_end_pulse(cddip_key_tlv_rsm_end_pulse[3]), 
                            .key_tlv_rsm_idle   (cddip_key_tlv_rsm_idle[3]), 
                            // Inputs
                            .clk                (clk),
                            .rst_n              (rst_n),
                            .usr_ob_wr          (cddip_ob_wr[3]), 
                            .usr_ob_tlv         (cddip_ob_tlv[3]), 
                            .axi4s_ob_in        (kme_cddip3_ob_in)); 
 -----/\----- EXCLUDED -----/\----- */

        
        
        cr_kme_core_glue
        core_glue (
                   
                   .disable_debug_cmd_q (disable_debug_cmd_q),
                   .set_gcm_tag_fail_int(set_gcm_tag_fail_int),
                   .set_txc_bp_int      (set_txc_bp_int),
                   .set_rsm_is_backpressuring(set_rsm_is_backpressuring[7:0]),
                   .kme_ib_out          (kme_ib_out),
                   .sa_snapshot         (sa_snapshot),
                   .sa_count            (sa_count),
                   .kme_idle            (kme_idle),
                   .idle_components     (idle_components),
                   
                   .clk                 (clk),
                   .rst_n               (rst_n),
                   .disable_debug_cmd   (disable_debug_cmd),
                   .cceip_encrypt_gcm_tag_fail_int(cceip_encrypt_gcm_tag_fail_int),
                   .cceip_validate_gcm_tag_fail_int(cceip_validate_gcm_tag_fail_int),
                   .cddip_decrypt_gcm_tag_fail_int(cddip_decrypt_gcm_tag_fail_int),
                   .cceip_ob_full       (cceip_ob_full[3:0]),
                   .cddip_ob_full       (cddip_ob_full[3:0]),
                   .tready_override     (tready_override),
                   .core_kme_ib_out     (core_kme_ib_out),
                   .sa_global_ctrl      (sa_global_ctrl),
                   .sa_ctrl             (sa_ctrl),
                   .stat_drbg_reseed    (stat_drbg_reseed),
                   .stat_req_with_expired_seed(stat_req_with_expired_seed),
                   .stat_aux_key_type_0 (stat_aux_key_type_0),
                   .stat_aux_key_type_1 (stat_aux_key_type_1),
                   .stat_aux_key_type_2 (stat_aux_key_type_2),
                   .stat_aux_key_type_3 (stat_aux_key_type_3),
                   .stat_aux_key_type_4 (stat_aux_key_type_4),
                   .stat_aux_key_type_5 (stat_aux_key_type_5),
                   .stat_aux_key_type_6 (stat_aux_key_type_6),
                   .stat_aux_key_type_7 (stat_aux_key_type_7),
                   .stat_aux_key_type_8 (stat_aux_key_type_8),
                   .stat_aux_key_type_9 (stat_aux_key_type_9),
                   .stat_aux_key_type_10(stat_aux_key_type_10),
                   .stat_aux_key_type_11(stat_aux_key_type_11),
                   .stat_aux_key_type_12(stat_aux_key_type_12),
                   .stat_aux_key_type_13(stat_aux_key_type_13),
                   .stat_cceip0_stall_on_valid_key(stat_cceip0_stall_on_valid_key),
                   .stat_cceip1_stall_on_valid_key(stat_cceip1_stall_on_valid_key),
                   .stat_cceip2_stall_on_valid_key(stat_cceip2_stall_on_valid_key),
                   .stat_cceip3_stall_on_valid_key(stat_cceip3_stall_on_valid_key),
                   .stat_cddip0_stall_on_valid_key(stat_cddip0_stall_on_valid_key),
                   .stat_cddip1_stall_on_valid_key(stat_cddip1_stall_on_valid_key),
                   .stat_cddip2_stall_on_valid_key(stat_cddip2_stall_on_valid_key),
                   .stat_cddip3_stall_on_valid_key(stat_cddip3_stall_on_valid_key),
                   .stat_aux_cmd_with_vf_pf_fail(stat_aux_cmd_with_vf_pf_fail),
                   .kme_slv_empty       (kme_slv_empty),
                   .drng_idle           (drng_idle),
                   .tlv_parser_idle     (tlv_parser_idle),
                   .tlv_parser_int_tlv_start_pulse(tlv_parser_int_tlv_start_pulse),
                   .cceip_key_tlv_rsm_end_pulse(cceip_key_tlv_rsm_end_pulse[3:0]),
                   .cddip_key_tlv_rsm_end_pulse(cddip_key_tlv_rsm_end_pulse[3:0]),
                   .cceip_key_tlv_rsm_idle(cceip_key_tlv_rsm_idle[3:0]),
                   .cddip_key_tlv_rsm_idle(cddip_key_tlv_rsm_idle[3:0]));

    end
    endgenerate

   
endmodule 









