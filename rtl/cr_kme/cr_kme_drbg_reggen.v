/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_drbg_reggen (
   
   set_drbg_expired_int, kdf_drbg_ctrl, seed0_valid,
   seed0_internal_state_key, seed0_internal_state_value,
   seed0_reseed_interval, seed1_valid, seed1_internal_state_key,
   seed1_internal_state_value, seed1_reseed_interval,
   
   clk, rst_n, wr_stb, wr_data, reg_addr, o_kdf_drbg_ctrl,
   o_kdf_drbg_seed_0_reseed_interval_0,
   o_kdf_drbg_seed_0_reseed_interval_1,
   o_kdf_drbg_seed_0_state_key_127_96,
   o_kdf_drbg_seed_0_state_key_159_128,
   o_kdf_drbg_seed_0_state_key_191_160,
   o_kdf_drbg_seed_0_state_key_223_192,
   o_kdf_drbg_seed_0_state_key_255_224,
   o_kdf_drbg_seed_0_state_key_31_0,
   o_kdf_drbg_seed_0_state_key_63_32,
   o_kdf_drbg_seed_0_state_key_95_64,
   o_kdf_drbg_seed_0_state_value_127_96,
   o_kdf_drbg_seed_0_state_value_31_0,
   o_kdf_drbg_seed_0_state_value_63_32,
   o_kdf_drbg_seed_0_state_value_95_64,
   o_kdf_drbg_seed_1_reseed_interval_0,
   o_kdf_drbg_seed_1_reseed_interval_1,
   o_kdf_drbg_seed_1_state_key_127_96,
   o_kdf_drbg_seed_1_state_key_159_128,
   o_kdf_drbg_seed_1_state_key_191_160,
   o_kdf_drbg_seed_1_state_key_223_192,
   o_kdf_drbg_seed_1_state_key_255_224,
   o_kdf_drbg_seed_1_state_key_31_0,
   o_kdf_drbg_seed_1_state_key_63_32,
   o_kdf_drbg_seed_1_state_key_95_64,
   o_kdf_drbg_seed_1_state_value_127_96,
   o_kdf_drbg_seed_1_state_value_31_0,
   o_kdf_drbg_seed_1_state_value_63_32,
   o_kdf_drbg_seed_1_state_value_95_64, seed0_invalidate,
   seed1_invalidate
   );


    import cr_kmePKG::*;
    import cr_kme_regfilePKG::*;

    
    
    
    input clk;
    input rst_n;

    
    
    
    output set_drbg_expired_int;

    
    
    
    input                                                wr_stb;
    input  [31:0]                                        wr_data;
    input  [`CR_KME_DECL]                                reg_addr;
    output [`CR_KME_C_KDF_DRBG_CTRL_T_DECL]              kdf_drbg_ctrl;
    input  [`CR_KME_C_KDF_DRBG_CTRL_T_DECL]              o_kdf_drbg_ctrl;
    input  [`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_0_T_DECL] o_kdf_drbg_seed_0_reseed_interval_0;
    input  [`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_1_T_DECL] o_kdf_drbg_seed_0_reseed_interval_1;
    input  [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]         o_kdf_drbg_seed_0_state_key_127_96;
    input  [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]         o_kdf_drbg_seed_0_state_key_159_128;
    input  [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]         o_kdf_drbg_seed_0_state_key_191_160;
    input  [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]         o_kdf_drbg_seed_0_state_key_223_192;
    input  [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]         o_kdf_drbg_seed_0_state_key_255_224;
    input  [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]         o_kdf_drbg_seed_0_state_key_31_0;
    input  [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]         o_kdf_drbg_seed_0_state_key_63_32;
    input  [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]         o_kdf_drbg_seed_0_state_key_95_64;
    input  [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]       o_kdf_drbg_seed_0_state_value_127_96;
    input  [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]       o_kdf_drbg_seed_0_state_value_31_0;
    input  [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]       o_kdf_drbg_seed_0_state_value_63_32;
    input  [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]       o_kdf_drbg_seed_0_state_value_95_64;
    input  [`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_0_T_DECL] o_kdf_drbg_seed_1_reseed_interval_0;
    input  [`CR_KME_C_KDF_DRBG_RESEED_INTERVAL_1_T_DECL] o_kdf_drbg_seed_1_reseed_interval_1;
    input  [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]         o_kdf_drbg_seed_1_state_key_127_96;
    input  [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]         o_kdf_drbg_seed_1_state_key_159_128;
    input  [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]         o_kdf_drbg_seed_1_state_key_191_160;
    input  [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]         o_kdf_drbg_seed_1_state_key_223_192;
    input  [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]         o_kdf_drbg_seed_1_state_key_255_224;
    input  [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]         o_kdf_drbg_seed_1_state_key_31_0;
    input  [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]         o_kdf_drbg_seed_1_state_key_63_32;
    input  [`CR_KME_C_KDF_DRBG_STATE_KEY_T_DECL]         o_kdf_drbg_seed_1_state_key_95_64;
    input  [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]       o_kdf_drbg_seed_1_state_value_127_96;
    input  [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]       o_kdf_drbg_seed_1_state_value_31_0;
    input  [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]       o_kdf_drbg_seed_1_state_value_63_32;
    input  [`CR_KME_C_KDF_DRBG_STATE_VALUE_T_DECL]       o_kdf_drbg_seed_1_state_value_95_64;

    
    
    
    output  reg             seed0_valid;
    output  [255:0]         seed0_internal_state_key;
    output  [127:0]         seed0_internal_state_value;
    output   [47:0]         seed0_reseed_interval;
    output  reg             seed1_valid;
    output  [255:0]         seed1_internal_state_key;
    output  [127:0]         seed1_internal_state_value;
    output   [47:0]         seed1_reseed_interval;
    input                   seed0_invalidate;
    input                   seed1_invalidate;


    
    always_ff @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            seed0_valid <= 1'b0;
        end else if (seed0_invalidate) begin
            seed0_valid <= 1'b0;
        end else if (wr_stb) begin
            if (reg_addr == `CR_KME_KDF_DRBG_CTRL) begin
                seed0_valid <= wr_data[0];
            end
        end
    end

    always_ff @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            seed1_valid <= 1'b0;
        end else if (seed1_invalidate) begin
            seed1_valid <= 1'b0;
        end else if (wr_stb) begin
            if (reg_addr == `CR_KME_KDF_DRBG_CTRL) begin
                seed1_valid <= wr_data[1];
            end
        end
    end

    
    assign set_drbg_expired_int = (seed0_valid & seed0_invalidate) | 
                                  (seed1_valid & seed1_invalidate) ;

    assign kdf_drbg_ctrl = {seed1_valid, seed0_valid};
    

    assign seed0_internal_state_key   = { 
                                          o_kdf_drbg_seed_0_state_key_255_224,
                                          o_kdf_drbg_seed_0_state_key_223_192,
                                          o_kdf_drbg_seed_0_state_key_191_160,
                                          o_kdf_drbg_seed_0_state_key_159_128,
                                          o_kdf_drbg_seed_0_state_key_127_96,
                                          o_kdf_drbg_seed_0_state_key_95_64,
                                          o_kdf_drbg_seed_0_state_key_63_32,
                                          o_kdf_drbg_seed_0_state_key_31_0
                                        };

    assign seed0_internal_state_value = {
                                          o_kdf_drbg_seed_0_state_value_127_96,
                                          o_kdf_drbg_seed_0_state_value_95_64,
                                          o_kdf_drbg_seed_0_state_value_63_32,
                                          o_kdf_drbg_seed_0_state_value_31_0
                                        };

    assign seed0_reseed_interval      = {
                                          o_kdf_drbg_seed_0_reseed_interval_1,
                                          o_kdf_drbg_seed_0_reseed_interval_0
                                        };

    assign seed1_internal_state_key   = { 
                                          o_kdf_drbg_seed_1_state_key_255_224,
                                          o_kdf_drbg_seed_1_state_key_223_192,
                                          o_kdf_drbg_seed_1_state_key_191_160,
                                          o_kdf_drbg_seed_1_state_key_159_128,
                                          o_kdf_drbg_seed_1_state_key_127_96,
                                          o_kdf_drbg_seed_1_state_key_95_64,
                                          o_kdf_drbg_seed_1_state_key_63_32,
                                          o_kdf_drbg_seed_1_state_key_31_0
                                        };

    assign seed1_internal_state_value = {
                                          o_kdf_drbg_seed_1_state_value_127_96,
                                          o_kdf_drbg_seed_1_state_value_95_64,
                                          o_kdf_drbg_seed_1_state_value_63_32,
                                          o_kdf_drbg_seed_1_state_value_31_0
                                        };

    assign seed1_reseed_interval      = {
                                          o_kdf_drbg_seed_1_reseed_interval_1,
                                          o_kdf_drbg_seed_1_reseed_interval_0
                                        };


endmodule

