/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_core_glue (
   
   disable_debug_cmd_q, set_gcm_tag_fail_int, set_txc_bp_int,
   set_rsm_is_backpressuring, kme_ib_out, sa_snapshot, sa_count,
   kme_idle, idle_components,
   
   clk, rst_n, disable_debug_cmd, cceip_encrypt_gcm_tag_fail_int,
   cceip_validate_gcm_tag_fail_int, cddip_decrypt_gcm_tag_fail_int,
   cceip_ob_full, cddip_ob_full, tready_override, core_kme_ib_out,
   sa_global_ctrl, sa_ctrl, stat_drbg_reseed,
   stat_req_with_expired_seed, stat_aux_key_type_0,
   stat_aux_key_type_1, stat_aux_key_type_2, stat_aux_key_type_3,
   stat_aux_key_type_4, stat_aux_key_type_5, stat_aux_key_type_6,
   stat_aux_key_type_7, stat_aux_key_type_8, stat_aux_key_type_9,
   stat_aux_key_type_10, stat_aux_key_type_11, stat_aux_key_type_12,
   stat_aux_key_type_13, stat_cceip0_stall_on_valid_key,
   stat_cceip1_stall_on_valid_key, stat_cceip2_stall_on_valid_key,
   stat_cceip3_stall_on_valid_key, stat_cddip0_stall_on_valid_key,
   stat_cddip1_stall_on_valid_key, stat_cddip2_stall_on_valid_key,
   stat_cddip3_stall_on_valid_key, stat_aux_cmd_with_vf_pf_fail,
   kme_slv_empty, drng_idle, tlv_parser_idle,
   tlv_parser_int_tlv_start_pulse, cceip_key_tlv_rsm_end_pulse,
   cddip_key_tlv_rsm_end_pulse, cceip_key_tlv_rsm_idle,
   cddip_key_tlv_rsm_idle
   );

    `include "cr_kme_body_param.v"

    
    
    
    input clk;
    input rst_n; 

    
    
    
    input  wire disable_debug_cmd;
    output reg  disable_debug_cmd_q;

    
    
    
    input cceip_encrypt_gcm_tag_fail_int;
    input cceip_validate_gcm_tag_fail_int;
    input cddip_decrypt_gcm_tag_fail_int;

    
    
    
    output     set_gcm_tag_fail_int;
    output reg set_txc_bp_int;

    
    
    
    input [3:0] cceip_ob_full;
    input [3:0] cddip_ob_full;

    
    
    
    output [7:0]                set_rsm_is_backpressuring;
    input  tready_override_t    tready_override;

    
    
    
    input  axi4s_dp_rdy_t core_kme_ib_out;

    
    
    
    output axi4s_dp_rdy_t kme_ib_out;

    
    
    
    input   sa_global_ctrl_t sa_global_ctrl;
    input   sa_ctrl_t        sa_ctrl[31:0];
    output  sa_snapshot_t    sa_snapshot[31:0];
    output  sa_count_t       sa_count[31:0];
 
    
    
    
    input stat_drbg_reseed;
    input stat_req_with_expired_seed;
    input stat_aux_key_type_0;
    input stat_aux_key_type_1;
    input stat_aux_key_type_2;
    input stat_aux_key_type_3;
    input stat_aux_key_type_4;
    input stat_aux_key_type_5;
    input stat_aux_key_type_6;
    input stat_aux_key_type_7;
    input stat_aux_key_type_8;
    input stat_aux_key_type_9;
    input stat_aux_key_type_10;
    input stat_aux_key_type_11;
    input stat_aux_key_type_12;
    input stat_aux_key_type_13;
    input stat_cceip0_stall_on_valid_key;
    input stat_cceip1_stall_on_valid_key;
    input stat_cceip2_stall_on_valid_key;
    input stat_cceip3_stall_on_valid_key;
    input stat_cddip0_stall_on_valid_key;
    input stat_cddip1_stall_on_valid_key;
    input stat_cddip2_stall_on_valid_key;
    input stat_cddip3_stall_on_valid_key;
    input stat_aux_cmd_with_vf_pf_fail;

    
    
    
    output reg    kme_idle;
    input         kme_slv_empty;
    input         drng_idle;
    input         tlv_parser_idle;
    input         tlv_parser_int_tlv_start_pulse;
    input  [3:0]  cceip_key_tlv_rsm_end_pulse;
    input  [3:0]  cddip_key_tlv_rsm_end_pulse;
    input  [3:0]  cceip_key_tlv_rsm_idle;
    input  [3:0]  cddip_key_tlv_rsm_idle;
    output idle_t idle_components;


    genvar  i;
    integer k;
    reg [63:0] sa_events [15:0];
    reg [31:0] num_key_tlv_in_flight;

    reg sa_snap, sa_clear;
    reg regs_sa_snap_r, regs_sa_clear_live_r;

    assign set_gcm_tag_fail_int = cceip_encrypt_gcm_tag_fail_int  |
                                  cceip_validate_gcm_tag_fail_int |
                                  cddip_decrypt_gcm_tag_fail_int  ;


    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            set_txc_bp_int <= 1'b0;
            disable_debug_cmd_q <= 1'b0;
        end else begin
            set_txc_bp_int <= ~kme_ib_out.tready;
            disable_debug_cmd_q <= disable_debug_cmd;
        end
    end

    
    assign set_rsm_is_backpressuring = {cddip_ob_full[3:0], cceip_ob_full[3:0]};


    
    assign kme_ib_out.tready = (tready_override.f.txc_tready_override) ? 1'b0 : core_kme_ib_out.tready;


    
    
    

    always @ (*) begin
        
        for (k=0; k<16; k=k+1) begin
            sa_events[k] = 64'b0;
        end

        sa_events[0][0]  = stat_drbg_reseed;
        sa_events[0][1]  = stat_req_with_expired_seed;
        sa_events[0][2]  = stat_aux_key_type_0;
        sa_events[0][3]  = stat_aux_key_type_1;
        sa_events[0][4]  = stat_aux_key_type_2;
        sa_events[0][5]  = stat_aux_key_type_3;
        sa_events[0][6]  = stat_aux_key_type_4;
        sa_events[0][7]  = stat_aux_key_type_5;
        sa_events[0][8]  = stat_aux_key_type_6;
        sa_events[0][9]  = stat_aux_key_type_7;
        sa_events[0][10] = stat_aux_key_type_8;
        sa_events[0][11] = stat_aux_key_type_9;
        sa_events[0][12] = stat_aux_key_type_10;
        sa_events[0][13] = stat_aux_key_type_11;
        sa_events[0][14] = stat_aux_key_type_12;
        sa_events[0][15] = stat_aux_key_type_13;
        sa_events[0][16] = stat_cceip0_stall_on_valid_key;
        sa_events[0][17] = stat_cceip1_stall_on_valid_key;
        sa_events[0][18] = stat_cceip2_stall_on_valid_key;
        sa_events[0][19] = stat_cceip3_stall_on_valid_key;
        sa_events[0][20] = stat_cddip0_stall_on_valid_key;
        sa_events[0][21] = stat_cddip1_stall_on_valid_key;
        sa_events[0][22] = stat_cddip2_stall_on_valid_key;
        sa_events[0][23] = stat_cddip3_stall_on_valid_key;
        sa_events[0][24] = stat_aux_cmd_with_vf_pf_fail;
    end

    
    
    
    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sa_snap <= 1'b0;
            sa_clear <= 1'b0;

            regs_sa_snap_r <= 1'b0;
            regs_sa_clear_live_r <= 1'b0;
        end
        else begin
            regs_sa_snap_r <= sa_global_ctrl.f.sa_snap;
            regs_sa_clear_live_r <= sa_global_ctrl.f.sa_clear_live;

            sa_snap <= sa_global_ctrl.f.sa_snap & ~regs_sa_snap_r;
            sa_clear <= sa_global_ctrl.f.sa_clear_live & ~regs_sa_clear_live_r;
        end
    end

    

    generate

        for (i=0; i<32; i=i+1) begin : num
            cr_sa_counter
            sa_counter_i (
                          
                          .sa_count             ({sa_count[i].f.upper,sa_count[i].f.lower}), 
                          .sa_snapshot          ({sa_snapshot[i].f.upper,sa_snapshot[i].f.lower}), 
                          
                          .clk                  (clk),
                          .rst_n                (rst_n),
                          .sa_event_sel         ({5'b0, sa_ctrl[i].f.sa_event_sel}), 
                          .sa_events            (sa_events),     
                          .sa_clear             (sa_clear),      
                          .sa_snap              (sa_snap));       
        end

    endgenerate  

    
    always @ (*) begin
        for (k=0; k<32; k=k+1) begin
            sa_count   [k].f.unused = 14'b0;
            sa_snapshot[k].f.unused = 14'b0;
        end
    end


    
    
    
    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            num_key_tlv_in_flight <= 32'b0;
        end else begin
            case ({tlv_parser_int_tlv_start_pulse, ((|cceip_key_tlv_rsm_end_pulse) | (|cddip_key_tlv_rsm_end_pulse))})
                2'b00: num_key_tlv_in_flight <= num_key_tlv_in_flight;
                2'b01: num_key_tlv_in_flight <= num_key_tlv_in_flight - 1'b1;
                2'b10: num_key_tlv_in_flight <= num_key_tlv_in_flight + 1'b1;
                2'b11: num_key_tlv_in_flight <= num_key_tlv_in_flight;
            endcase
        end
    end

    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            kme_idle <= 1'b0;
        end else begin
            kme_idle <= (kme_slv_empty)                  & 
                        (drng_idle)                      & 
                        (tlv_parser_idle)                &
                        (num_key_tlv_in_flight == 32'b0) &
                        (&cceip_key_tlv_rsm_idle)        &
                        (&cddip_key_tlv_rsm_idle)        ;
        end
    end

    assign idle_components.f.num_key_tlvs_in_flight   = num_key_tlv_in_flight[19:0];
    assign idle_components.f.cddip0_key_tlv_rsm_idle  = cddip_key_tlv_rsm_idle[0];
    assign idle_components.f.cddip1_key_tlv_rsm_idle  = cddip_key_tlv_rsm_idle[1];
    assign idle_components.f.cddip2_key_tlv_rsm_idle  = cddip_key_tlv_rsm_idle[2];
    assign idle_components.f.cddip3_key_tlv_rsm_idle  = cddip_key_tlv_rsm_idle[3];
    assign idle_components.f.cceip0_key_tlv_rsm_idle  = cceip_key_tlv_rsm_idle[0];
    assign idle_components.f.cceip1_key_tlv_rsm_idle  = cceip_key_tlv_rsm_idle[1];
    assign idle_components.f.cceip2_key_tlv_rsm_idle  = cceip_key_tlv_rsm_idle[2];
    assign idle_components.f.cceip3_key_tlv_rsm_idle  = cceip_key_tlv_rsm_idle[3];
    assign idle_components.f.no_key_tlv_in_flight     = (num_key_tlv_in_flight == 32'b0);
    assign idle_components.f.tlv_parser_idle          = tlv_parser_idle;
    assign idle_components.f.drng_idle                = drng_idle;
    assign idle_components.f.kme_slv_empty            = kme_slv_empty;




endmodule










