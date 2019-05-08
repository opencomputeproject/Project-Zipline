/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_int_handler (
   
   kme_interrupt, interrupt_status, suppress_key_tlvs,
   
   clk, rst_n, set_drbg_expired_int, set_txc_bp_int,
   set_gcm_tag_fail_int, set_key_tlv_miscmp_int,
   set_tlv_bip2_error_int, cceip0_ism_mbe, cceip1_ism_mbe,
   cceip2_ism_mbe, cceip3_ism_mbe, cddip0_ism_mbe, cddip1_ism_mbe,
   cddip2_ism_mbe, cddip3_ism_mbe, kim_mbe, ckv_mbe,
   cceip_encrypt_mbe, cceip_validate_mbe, cddip_decrypt_mbe, axi_mbe,
   bimc_interrupt, wr_stb, wr_data, reg_addr, o_interrupt_mask
   );


    import cr_kmePKG::*;
    import cr_kme_regfilePKG::*;

    
    
    
    input clk;
    input rst_n;

    
    
    
    output reg kme_interrupt;

    
    
    
    input set_drbg_expired_int;
    input set_txc_bp_int;
    input set_gcm_tag_fail_int;
    input set_key_tlv_miscmp_int;
    input set_tlv_bip2_error_int;
    input cceip0_ism_mbe;
    input cceip1_ism_mbe;
    input cceip2_ism_mbe;
    input cceip3_ism_mbe;
    input cddip0_ism_mbe;
    input cddip1_ism_mbe;
    input cddip2_ism_mbe;
    input cddip3_ism_mbe;
    input kim_mbe;
    input ckv_mbe;
    input cceip_encrypt_mbe;
    input cceip_validate_mbe;
    input cddip_decrypt_mbe;
    input axi_mbe;

    
    
    
    input bimc_interrupt;

    
    
    
    input                                    wr_stb;
    input      [31:0]                        wr_data;
    input      [`CR_KME_DECL]                reg_addr;
    input      [`CR_KME_C_INT_MASK_T_DECL]   o_interrupt_mask;
    output reg [`CR_KME_C_INT_STATUS_T_DECL] interrupt_status;

    
    
    
    output suppress_key_tlvs;

    reg [`CR_KME_C_INT_STATUS_T_DECL] set_triggers;

    integer i;

    always @ (*) begin
        set_triggers[`CR_KME_C_INT_STATUS_T_DRBG_SEED_EXPIRED] = set_drbg_expired_int;
        set_triggers[`CR_KME_C_INT_STATUS_T_TXC_BP]            = set_txc_bp_int;
        set_triggers[`CR_KME_C_INT_STATUS_T_GCM_TAG_FAIL]      = set_gcm_tag_fail_int;
        set_triggers[`CR_KME_C_INT_STATUS_T_ECC_MBE]           = cceip0_ism_mbe|cceip1_ism_mbe|cceip2_ism_mbe|cceip3_ism_mbe|
                                                                 cddip0_ism_mbe|cddip1_ism_mbe|cddip2_ism_mbe|cddip3_ism_mbe|
                                                                 cceip_encrypt_mbe|cceip_validate_mbe|cddip_decrypt_mbe|
                                                                 kim_mbe|ckv_mbe|axi_mbe|set_tlv_bip2_error_int;
        set_triggers[`CR_KME_C_INT_STATUS_T_TLV_MISCOMP]       = set_key_tlv_miscmp_int;
    end

    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<`CR_KME_C_INT_STATUS_T_WIDTH; i=i+1) begin
                interrupt_status <= {`CR_KME_C_INT_STATUS_T_WIDTH{1'b0}};
            end
        end else begin
            for (i=0; i<`CR_KME_C_INT_STATUS_T_WIDTH; i=i+1) begin
                if (wr_stb & (reg_addr == `CR_KME_INTERRUPT_STATUS) & wr_data[i]) begin
                    
                    interrupt_status[i] <= 1'b0;
                end else if (set_triggers[i]) begin
                    interrupt_status[i] <= 1'b1;
                end
            end
        end
    end

    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            kme_interrupt <= 1'b0;
        end else begin
            
            kme_interrupt <= ((|(interrupt_status & o_interrupt_mask)) | bimc_interrupt);
        end
    end

    
    assign suppress_key_tlvs = interrupt_status[`CR_KME_C_INT_STATUS_T_ECC_MBE];

endmodule









 
