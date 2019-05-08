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











module cr_kme_kop_assigner (
  
  kopassigner_ckvreader_ack, cceip_encrypt_in, cceip_encrypt_in_valid,
  cceip_validate_in, cceip_validate_in_valid, cddip_decrypt_in,
  cddip_decrypt_in_valid,
  
  clk, rst_n, ckvreader_kopassigner_valid, ckvreader_kopassigner_data,
  cceip_encrypt_in_stall, cceip_validate_in_stall,
  cddip_decrypt_in_stall
  );



    `include "cr_kme_body_param.v"

    
    
    
    input clk;
    input rst_n;

    
    
    
    input                   ckvreader_kopassigner_valid;
    input  kme_internal_t   ckvreader_kopassigner_data;
    output reg              kopassigner_ckvreader_ack;

    
    
    
    output kme_internal_t   cceip_encrypt_in;
    output reg              cceip_encrypt_in_valid;
    input                   cceip_encrypt_in_stall;

    
    
    
    output kme_internal_t   cceip_validate_in;
    output reg              cceip_validate_in_valid;
    input                   cceip_validate_in_stall;

    
    
    
    output kme_internal_t   cddip_decrypt_in;
    output reg              cddip_decrypt_in_valid;
    input                   cddip_decrypt_in_stall;



    typedef enum bit [1:0] {
        TLV_WORD0       = 2'd0,
        ENCRYPT_VALIDATE= 2'd1,
        DECRYPT         = 2'd3
    } kop_assigner_fsm;



    kop_assigner_fsm        cur_state;
    kop_assigner_fsm        nxt_state;
    kme_internal_word_0_t   tlv_word0;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cur_state <= TLV_WORD0;
        end else begin
            cur_state <= nxt_state;
        end
    end

    always @ (*) begin

        nxt_state = cur_state;

        case (cur_state)

            TLV_WORD0: begin
                
                if (kopassigner_ckvreader_ack) begin
                    nxt_state = ENCRYPT_VALIDATE;  // KME_MODIFICATION_NOTE: Line added
// KME_MODIFICATION_NOTE: Lines commented out
/* -----\/----- EXCLUDED -----\/-----
                    case (tlv_word0.tlv_eng_id[2:0])
                        3'd0: nxt_state = ENCRYPT_VALIDATE;
                        3'd1: nxt_state = ENCRYPT_VALIDATE;
                        3'd2: nxt_state = ENCRYPT_VALIDATE;
                        3'd3: nxt_state = ENCRYPT_VALIDATE;

                        3'd4: nxt_state = DECRYPT;
                        3'd5: nxt_state = DECRYPT;
                        3'd6: nxt_state = DECRYPT;
                        3'd7: nxt_state = DECRYPT;
                    endcase
 -----/\----- EXCLUDED -----/\----- */
                end
            end

            ENCRYPT_VALIDATE: begin
                
                if (cceip_encrypt_in_valid) begin
                    if (cceip_encrypt_in.eot) begin
                        nxt_state = TLV_WORD0;
                    end
                end
            end

// KME_MODIFICATION_NOTE: Lines commented out
/* -----\/----- EXCLUDED -----\/-----
            DECRYPT: begin
                if (cddip_decrypt_in_valid) begin
                    if (cddip_decrypt_in.eot) begin
                        nxt_state = TLV_WORD0;
                    end
                end
            end
 -----/\----- EXCLUDED -----/\----- */

        endcase
    end

    always @ (*) begin

        kopassigner_ckvreader_ack   = 1'b0;
        cceip_encrypt_in            = {$bits(kme_internal_t){1'b0}};
        cceip_encrypt_in_valid      = 1'b0;
        cceip_validate_in           = {$bits(kme_internal_t){1'b0}};
        cceip_validate_in_valid     = 1'b0;
        cddip_decrypt_in            = {$bits(kme_internal_t){1'b0}};
        cddip_decrypt_in_valid      = 1'b0;

        tlv_word0 = ckvreader_kopassigner_data.tdata;

        if (ckvreader_kopassigner_valid) begin
            
            if (!(cceip_encrypt_in_stall & cceip_validate_in_stall)) begin

                case (cur_state)

                    TLV_WORD0: begin
                        // if (tlv_word0.tlv_eng_id[2] == 1'b0) begin // KME_MODIFICATION_NOTE: Line commented out
                            cceip_encrypt_in_valid    = 1'b1;
                            cceip_validate_in_valid   = 1'b1;
                            cceip_encrypt_in          = ckvreader_kopassigner_data;
                            cceip_validate_in         = ckvreader_kopassigner_data;
                            kopassigner_ckvreader_ack = 1'b1;
                        // end // KME_MODIFICATION_NOTE: Line commented out
                    end

                    ENCRYPT_VALIDATE: begin
                        cceip_encrypt_in_valid    = 1'b1;
                        cceip_validate_in_valid   = 1'b1;
                        cceip_encrypt_in          = ckvreader_kopassigner_data;
                        cceip_validate_in         = ckvreader_kopassigner_data;
                        kopassigner_ckvreader_ack = 1'b1;
                    end

                endcase
            end

// KME_MODIFICATION_NOTE: Lines commented out
/* -----\/----- EXCLUDED -----\/-----
            if (!cddip_decrypt_in_stall) begin

                case (cur_state)

                    TLV_WORD0: begin
                        if (tlv_word0.tlv_eng_id[2] == 1'b1) begin
                            cddip_decrypt_in_valid    = 1'b1;
                            cddip_decrypt_in          = ckvreader_kopassigner_data;
                            kopassigner_ckvreader_ack = 1'b1;
                        end
                    end

                    DECRYPT: begin
                        cddip_decrypt_in_valid    = 1'b1;
                        cddip_decrypt_in          = ckvreader_kopassigner_data;
                        kopassigner_ckvreader_ack = 1'b1;
                    end

                endcase
            end
 -----/\----- EXCLUDED -----/\----- */

        end
    end



endmodule









