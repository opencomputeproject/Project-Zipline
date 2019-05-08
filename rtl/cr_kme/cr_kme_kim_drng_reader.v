/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











module cr_kme_kim_drng_reader (
   
   kimreader_parser_ack, kimreader_ckvreader_valid,
   kimreader_ckvreader_data, drng_ack, kim_rd, kim_addr,
   stat_req_with_expired_seed, stat_aux_key_type_0,
   stat_aux_key_type_1, stat_aux_key_type_2, stat_aux_key_type_3,
   stat_aux_key_type_4, stat_aux_key_type_5, stat_aux_key_type_6,
   stat_aux_key_type_7, stat_aux_key_type_8, stat_aux_key_type_9,
   stat_aux_key_type_10, stat_aux_key_type_11, stat_aux_key_type_12,
   stat_aux_key_type_13, stat_aux_cmd_with_vf_pf_fail,
   
   clk, rst_n, parser_kimreader_valid, parser_kimreader_data,
   ckvreader_kimreader_ack, drng_seed_expired, drng_health_fail,
   drng_256_out, drng_valid, kim_dout, kim_mbe,
   disable_unencrypted_keys
   );



    `include "cr_kme_body_param.v"

    
    
    
    input clk;
    input rst_n;

    
    
    
    input                   parser_kimreader_valid;
    input  kme_internal_t   parser_kimreader_data;
    output reg              kimreader_parser_ack;

    
    
    
    output reg              kimreader_ckvreader_valid;
    output kme_internal_t   kimreader_ckvreader_data;
    input                   ckvreader_kimreader_ack;

    
    
    
    input                   drng_seed_expired;
    input                   drng_health_fail;
    input [127:0]           drng_256_out;
    input                   drng_valid;
    output reg              drng_ack;

    
    
    
    output reg              kim_rd;
    output reg [13:0]       kim_addr;
    input  kim_entry_t      kim_dout;
    input                   kim_mbe;

    
    
    
    output reg stat_req_with_expired_seed;
    output reg stat_aux_key_type_0;
    output reg stat_aux_key_type_1;
    output reg stat_aux_key_type_2;
    output reg stat_aux_key_type_3;
    output reg stat_aux_key_type_4;
    output reg stat_aux_key_type_5;
    output reg stat_aux_key_type_6;
    output reg stat_aux_key_type_7;
    output reg stat_aux_key_type_8;
    output reg stat_aux_key_type_9;
    output reg stat_aux_key_type_10;
    output reg stat_aux_key_type_11;
    output reg stat_aux_key_type_12;
    output reg stat_aux_key_type_13;
    output reg stat_aux_cmd_with_vf_pf_fail;

    
    
    
    input disable_unencrypted_keys;


    typedef enum bit [2:0] {
        PASSTHROUGH    = 3'd0,
        DEK_KIM_READ   = 3'd1,
        DAK_KIM_READ   = 3'd2,
        TX_KIM_ENTRIES = 3'd3,
        INSERT_RGUID0  = 3'd4,
        INSERT_RGUID1  = 3'd5,
        INSERT_RGUID2  = 3'd6,
        INSERT_RGUID3  = 3'd7
    } kim_drng_reader_fsm;

    kim_drng_reader_fsm  cur_state;
    kim_drng_reader_fsm  nxt_state;

    reg [13:0] dek_ref_q;
    reg [13:0] dak_ref_q;

    reg dek_is_kdf_key_q;
    reg dak_is_kdf_key_q;

    zipline_error_e  kim_errors_q;
    kim_entry_t     dek_kim_entry_q;
    kim_entry_t     dak_kim_entry_q;
    reg             dek_kim_mbe_q;
    reg             dak_kim_mbe_q;
    reg             kim_rd_q;

    kme_internal_word_0_t   tlv_word0;
    kme_internal_word_8_t   tlv_word8;
    kme_internal_word_9_t   tlv_word9;
    kme_internal_word_42_t  tlv_word42;
    aux_key_ctrl_t          aux_key_ctrl;
    aux_key_type_e          aux_key_type;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cur_state <= PASSTHROUGH;
            kim_rd_q  <= 1'b0;
        end else begin
            cur_state <= nxt_state;
            kim_rd_q  <= kim_rd;
        end
    end

    always @ (*) begin

        nxt_state = cur_state;

        case (cur_state)

            PASSTHROUGH: begin
                
                if (kimreader_parser_ack) begin
                    if (parser_kimreader_data.id == KME_DEBUG_KEYHDR) begin
                        
                        if ((aux_key_ctrl.dek_key_op == KDF) | (aux_key_ctrl.dak_key_op == KDF)) begin
                            if ((aux_key_ctrl.kdf_mode == KDF_MODE_COMB_RGUID) | (aux_key_ctrl.kdf_mode == KDF_MODE_RGUID)) begin
                                nxt_state = INSERT_RGUID0;
                            end
                        end
                    end
                    if (parser_kimreader_data.id == KME_IVTWEAK) begin
                        if (parser_kimreader_data.eoi) begin
                            nxt_state = DEK_KIM_READ;
                        end
                    end
                end
            end

            INSERT_RGUID0: begin
                
                if (ckvreader_kimreader_ack) begin
                    nxt_state = INSERT_RGUID1;
                end
            end

            INSERT_RGUID1: begin
                if (ckvreader_kimreader_ack) begin
                    nxt_state = INSERT_RGUID2;
                end
            end

            INSERT_RGUID2: begin
                if (ckvreader_kimreader_ack) begin
                    nxt_state = INSERT_RGUID3;
                end
            end

            INSERT_RGUID3: begin
                if (ckvreader_kimreader_ack) begin
                    nxt_state = PASSTHROUGH;
                end
            end

            DEK_KIM_READ: begin
                
                if (kim_rd) begin
                    nxt_state = DAK_KIM_READ;
                end
            end

            DAK_KIM_READ: begin
                
                if (kim_rd) begin
                    nxt_state = TX_KIM_ENTRIES;
                end
            end

            TX_KIM_ENTRIES: begin
                
                
                if (kimreader_ckvreader_valid) begin
                    if (kimreader_ckvreader_data.eoi) begin
                        if (ckvreader_kimreader_ack) begin
                            nxt_state = PASSTHROUGH;
                        end
                    end
                end
            end

        endcase

    end

    always @ (*) begin

        drng_ack = 1'b0;
        kimreader_parser_ack = 1'b0;

        kimreader_ckvreader_valid = 1'b0;
        kimreader_ckvreader_data  = {$bits(kme_internal_t){1'b0}};

        kim_rd   = 1'b0;
        kim_addr = 14'b0;

        aux_key_ctrl = parser_kimreader_data.tdata[31:0];
        tlv_word0    = parser_kimreader_data.tdata;
        tlv_word8    = {$bits(kme_internal_word_8_t){1'b0}};
        tlv_word9    = {$bits(kme_internal_word_9_t){1'b0}};

        tlv_word42            = parser_kimreader_data.tdata;
        tlv_word42.error_code = kim_errors_q;

        case (cur_state)

            PASSTHROUGH: begin
                
                kimreader_ckvreader_valid = parser_kimreader_valid;
                kimreader_ckvreader_data  = parser_kimreader_data;
                kimreader_parser_ack      = ckvreader_kimreader_ack;

                if (parser_kimreader_data.id == KME_ERROR) begin
                    kimreader_ckvreader_data.tdata = tlv_word42;
                end
            end

            INSERT_RGUID0, INSERT_RGUID1,
            INSERT_RGUID2, INSERT_RGUID3: begin
                
                
                
                if (parser_kimreader_valid) begin
                    if (drng_valid) begin
                        kimreader_ckvreader_valid = 1'b1;
                        kimreader_ckvreader_data  = parser_kimreader_data;
                        kimreader_parser_ack      = ckvreader_kimreader_ack;

                        case (cur_state)
                            INSERT_RGUID0: kimreader_ckvreader_data.tdata = drng_256_out[127:64];
                            INSERT_RGUID1: kimreader_ckvreader_data.tdata = drng_256_out[63:0];
                            INSERT_RGUID2: kimreader_ckvreader_data.tdata = drng_256_out[127:64];
                            INSERT_RGUID3: kimreader_ckvreader_data.tdata = drng_256_out[63:0];
                        endcase

                        case (cur_state)
                            INSERT_RGUID1: drng_ack = ckvreader_kimreader_ack;
                            INSERT_RGUID3: drng_ack = ckvreader_kimreader_ack;
                        endcase

                    end else if (drng_seed_expired) begin
                        kimreader_ckvreader_valid = 1'b1;
                        kimreader_ckvreader_data  = parser_kimreader_data;
                        kimreader_parser_ack      = ckvreader_kimreader_ack;
                    end
                end
            end

            DEK_KIM_READ: begin
                
                kim_rd   = 1'b1;
                kim_addr = dek_ref_q; 
            end

            DAK_KIM_READ: begin
                
                
                kim_rd   = 1'b1;
                kim_addr = dak_ref_q; 
            end

            TX_KIM_ENTRIES: begin
                
                tlv_word8 = parser_kimreader_data.tdata;
                tlv_word8.dek_kim_entry = (tlv_word8.validate_dek) ? dek_kim_entry_q : {$bits(kim_entry_t){1'b0}};

                tlv_word9 = parser_kimreader_data.tdata;
                tlv_word9.dak_kim_entry = (tlv_word9.validate_dak) ? dak_kim_entry_q : {$bits(kim_entry_t){1'b0}};

                
                if (parser_kimreader_data.id == KME_KIM) begin

                    kimreader_ckvreader_valid = 1'b1;
                    kimreader_ckvreader_data  = parser_kimreader_data;
                    kimreader_parser_ack      = ckvreader_kimreader_ack;

                    if (parser_kimreader_data.eoi == 1'b0) begin
                        kimreader_ckvreader_data.tdata = tlv_word8;
                    end else begin
                        kimreader_ckvreader_data.tdata = tlv_word9;
                    end
                end
            end

        endcase

    end

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            aux_key_type <= NO_AUX_KEY;
            kim_errors_q <= NO_ERRORS;
            dek_ref_q <= 14'b0;
            dak_ref_q <= 14'b0;
            dek_is_kdf_key_q <= 1'b0;
            dak_is_kdf_key_q <= 1'b0;

            stat_req_with_expired_seed   <= 1'b0;
            stat_aux_key_type_0          <= 1'b0;
            stat_aux_key_type_1          <= 1'b0;
            stat_aux_key_type_2          <= 1'b0;
            stat_aux_key_type_3          <= 1'b0;
            stat_aux_key_type_4          <= 1'b0;
            stat_aux_key_type_5          <= 1'b0;
            stat_aux_key_type_6          <= 1'b0;
            stat_aux_key_type_7          <= 1'b0;
            stat_aux_key_type_8          <= 1'b0;
            stat_aux_key_type_9          <= 1'b0;
            stat_aux_key_type_10         <= 1'b0;
            stat_aux_key_type_11         <= 1'b0;
            stat_aux_key_type_12         <= 1'b0;
            stat_aux_key_type_13         <= 1'b0;
            stat_aux_cmd_with_vf_pf_fail <= 1'b0;
        end else begin
            stat_req_with_expired_seed   <= 1'b0;
            stat_aux_key_type_0          <= 1'b0;
            stat_aux_key_type_1          <= 1'b0;
            stat_aux_key_type_2          <= 1'b0;
            stat_aux_key_type_3          <= 1'b0;
            stat_aux_key_type_4          <= 1'b0;
            stat_aux_key_type_5          <= 1'b0;
            stat_aux_key_type_6          <= 1'b0;
            stat_aux_key_type_7          <= 1'b0;
            stat_aux_key_type_8          <= 1'b0;
            stat_aux_key_type_9          <= 1'b0;
            stat_aux_key_type_10         <= 1'b0;
            stat_aux_key_type_11         <= 1'b0;
            stat_aux_key_type_12         <= 1'b0;
            stat_aux_key_type_13         <= 1'b0;
            stat_aux_cmd_with_vf_pf_fail <= 1'b0;

            if (kimreader_parser_ack) begin

                if (parser_kimreader_data.id == KME_WORD0) begin
                    
                    aux_key_type <= tlv_word0.key_type;

                    case (tlv_word0.key_type)
                        DEK256, DEK512, DAK,   
                        DEK256_DAK, DEK512_DAK: kim_errors_q <= (disable_unencrypted_keys) ? KME_UNSUPPORTED_KEY_TYPE : NO_ERRORS;
                        NO_AUX_KEY            : kim_errors_q <= (tlv_word0.keyless_algos)  ? NO_ERRORS : KME_UNSUPPORTED_KEY_TYPE;
                        default               : kim_errors_q <= NO_ERRORS;
                    endcase
                end

                if (parser_kimreader_data.id == KME_DEBUG_KEYHDR) begin
                    
                    dek_ref_q        <= (aux_key_ctrl.dek_key_ref);
                    dak_ref_q        <= (aux_key_ctrl.dak_key_ref);
                    dek_is_kdf_key_q <= (aux_key_ctrl.dek_key_op == KDF);
                    dak_is_kdf_key_q <= (aux_key_ctrl.dak_key_op == KDF);
                end


		   
              //----------------------------------------------------------------------------------
              // KME_MODIFICATION_NOTE:
              // The logic that checks for and generates the DRNG (Deterministic Random Number Generator)
              // KME_SEED_EXPIRED and KME_DRNG_HEALTH_FAIL errors is commented out below because the
              // AES engine in the DRNG (cr_kme_aes_256_drng.v) is stubbed out.  As a result,
              // selecting the Random GUID option in the KME will always result in a GUID of 0x0
              //----------------------------------------------------------------------------------

/* -----\/----- EXCLUDED -----\/-----
                if (parser_kimreader_data.id == KME_GUID) begin
                    if (cur_state == INSERT_RGUID0) begin
                        if (!drng_valid & drng_seed_expired) begin
                            kim_errors_q <= KME_SEED_EXPIRED;
                            stat_req_with_expired_seed <= 1'b1;
                        end
                    end
		    else if (cur_state == INSERT_RGUID2) begin
		        if (drng_health_fail && (kim_errors_q == NO_ERRORS)) begin
			   kim_errors_q <= KME_DRNG_HEALTH_FAIL;
		        end
		    end
		end 
 -----/\----- EXCLUDED -----/\----- */

                if (parser_kimreader_data.id == KME_KIM) begin
                    
                    if (aux_key_type != NO_AUX_KEY) begin
                        if (parser_kimreader_data.eoi == 1'b0) begin

                          
                          
                          
                          if (tlv_word8.missing_guid || tlv_word8.missing_iv) begin
                            kim_errors_q <= KME_UNSUPPORTED_KEY_TYPE;

                          end else begin

                            
                            if (tlv_word8.validate_dek) begin
                              if (tlv_word8.dek_kim_entry.pf_num[3]) begin
                                
                                if (~dek_needs_kek(aux_key_type)) begin
                                  kim_errors_q <= KME_DEK_ILLEGAL_KEK_USAGE;
                                  end
                                end else begin

                                  
                                  if (dek_needs_kek(aux_key_type)) begin
                                    kim_errors_q <= KME_DEK_ILLEGAL_KEK_USAGE;
                                  end
                                end

                                if (tlv_word8.pf_num[0] != tlv_word8.dek_kim_entry.pf_num[0]) kim_errors_q <= KME_DEK_PF_VF_VAL_ERR;
                                if (tlv_word8.vf_valid  != tlv_word8.dek_kim_entry.vf_valid)  kim_errors_q <= KME_DEK_PF_VF_VAL_ERR;

                                if (tlv_word8.vf_valid) begin
                                  if (tlv_word8.vf_num != tlv_word8.dek_kim_entry.vf_num) begin
                                    kim_errors_q <= KME_DEK_PF_VF_VAL_ERR;
                                  end
                                end

                                  if (tlv_word8.dek_kim_entry.valid == 1'b0) kim_errors_q <= KME_DEK_INV_KIM;
                                end
                              end

                            end else begin

                            if (tlv_word9.validate_dak) begin
                                
                                if (tlv_word9.dak_kim_entry.pf_num[3]) begin
                                    
                                    if (~dak_needs_kek(aux_key_type)) begin
                                        kim_errors_q <= KME_DAK_ILLEGAL_KEK_USAGE;
                                    end
                                end else begin
                                    
                                    if (dak_needs_kek(aux_key_type)) begin
                                        kim_errors_q <= KME_DAK_ILLEGAL_KEK_USAGE;
                                    end
                                end

                                if (tlv_word9.pf_num[0] != tlv_word9.dak_kim_entry.pf_num[0]) kim_errors_q <= KME_DAK_PF_VF_VAL_ERR;
                                if (tlv_word9.vf_valid  != tlv_word9.dak_kim_entry.vf_valid)  kim_errors_q <= KME_DAK_PF_VF_VAL_ERR;

                                if (tlv_word9.vf_valid) begin
                                    if (tlv_word9.vf_num != tlv_word9.dak_kim_entry.vf_num) begin
                                        kim_errors_q <= KME_DAK_PF_VF_VAL_ERR;
                                    end
                                end

                                if (tlv_word9.dak_kim_entry.valid == 1'b0) kim_errors_q <= KME_DAK_INV_KIM;
                            end
                        end
                    end
                end

                if (parser_kimreader_data.id == KME_DEK_CKV0) begin
                    if (parser_kimreader_data.eoi) begin
                        
                        case (aux_key_type)
                            NO_AUX_KEY:          stat_aux_key_type_0  <= 1'b1;
                            AUX_KEY_ONLY:        stat_aux_key_type_1  <= 1'b1;
                            DEK256:              stat_aux_key_type_2  <= 1'b1;
                            DEK512:              stat_aux_key_type_3  <= 1'b1;
                            DAK:                 stat_aux_key_type_4  <= 1'b1;
                            DEK256_DAK:          stat_aux_key_type_5  <= 1'b1;
                            DEK512_DAK:          stat_aux_key_type_6  <= 1'b1;
                            ENC_DEK256:          stat_aux_key_type_7  <= 1'b1;
                            ENC_DEK512:          stat_aux_key_type_8  <= 1'b1;
                            ENC_DAK:             stat_aux_key_type_9  <= 1'b1;
                            ENC_DEK256_DAK:      stat_aux_key_type_10 <= 1'b1;
                            ENC_DEK512_DAK:      stat_aux_key_type_11 <= 1'b1;
                            ENC_DEK256_DAK_COMB: stat_aux_key_type_12 <= 1'b1;
                            ENC_DEK512_DAK_COMB: stat_aux_key_type_13 <= 1'b1;
                        endcase

                        
                        if (kim_errors_q == KME_DEK_PF_VF_VAL_ERR) stat_aux_cmd_with_vf_pf_fail <= 1'b1;
                        if (kim_errors_q == KME_DAK_PF_VF_VAL_ERR) stat_aux_cmd_with_vf_pf_fail <= 1'b1;
                    end
                end

                if (parser_kimreader_data.id == KME_DEK_CKV1) begin
                    
                    if (dek_kim_mbe_q | dak_kim_mbe_q) begin
                        kim_errors_q <= KME_ECC_FAIL;
                    end
                end
            end
        end
    end

    
    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dek_kim_entry_q <= {$bits(kim_entry_t){1'b0}};
            dak_kim_entry_q <= {$bits(kim_entry_t){1'b0}};
            dek_kim_mbe_q   <= 1'b0;
            dak_kim_mbe_q   <= 1'b0;
        end else if (kim_rd_q) begin
            if (cur_state == DAK_KIM_READ  ) {dek_kim_mbe_q, dek_kim_entry_q} <= {kim_mbe, kim_dout};
            if (cur_state == TX_KIM_ENTRIES) {dak_kim_mbe_q, dak_kim_entry_q} <= {kim_mbe, kim_dout};
        end else if (kimreader_ckvreader_valid) begin
            if (kimreader_ckvreader_data.id == KME_ERROR) begin
                if (ckvreader_kimreader_ack) begin
                    dek_kim_entry_q <= {$bits(kim_entry_t){1'b0}};
                    dak_kim_entry_q <= {$bits(kim_entry_t){1'b0}};
                    dek_kim_mbe_q   <= 1'b0;
                    dak_kim_mbe_q   <= 1'b0;
                end
            end
        end
    end


    function dek_needs_kek;
        input aux_key_type_e key_type;
        begin
            case (key_type)
                ENC_DEK256, ENC_DEK512,
                ENC_DEK256_DAK, ENC_DEK512_DAK,
                ENC_DEK256_DAK_COMB, ENC_DEK512_DAK_COMB: dek_needs_kek = 1'b1;
                default: dek_needs_kek = 1'b0;
            endcase
        end
    endfunction

    function dak_needs_kek;
        input aux_key_type_e key_type;
        begin
            case (key_type)
                ENC_DAK,
                ENC_DEK256_DAK, ENC_DEK512_DAK,
                ENC_DEK256_DAK_COMB, ENC_DEK512_DAK_COMB: dak_needs_kek = 1'b1;
                default: dak_needs_kek = 1'b0;
            endcase
        end
    endfunction


    

    

    genvar nn;

  generate
    
    for (nn=2; nn<=6; nn=nn+1) begin : key_type_enc_dek
      
      
      disable_unenc_keys: `COVER_PROPERTY((parser_kimreader_data.id == KME_WORD0) &&
                                          disable_unencrypted_keys && 
                                          (tlv_word0.key_type == nn));
          
      
      enable_unenc_keys: `COVER_PROPERTY((parser_kimreader_data.id == KME_WORD0) &&
                                         !disable_unencrypted_keys && 
                                         (tlv_word0.key_type == nn));
    end
  endgenerate

  

endmodule









