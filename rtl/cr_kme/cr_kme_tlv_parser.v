/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










`include "ccx_std.vh"

module cr_kme_tlv_parser (
   
   stitcher_rd, parser_kimreader_valid, parser_kimreader_data,
   tlv_parser_idle, tlv_parser_int_tlv_start_pulse,
   
   clk, rst_n, disable_debug_cmd_q, always_validate_kim_ref,
   stitcher_out, stitcher_empty, kimreader_parser_ack
   );



    `include "cr_kme_body_param.v"

    
    
    
    input clk;
    input rst_n;

    
    
    
    input disable_debug_cmd_q;
    input always_validate_kim_ref;

    
    
    
    output reg            stitcher_rd;
    input  axi4s_dp_bus_t stitcher_out;
    input                 stitcher_empty;

    
    
    
    output                parser_kimreader_valid;
    output kme_internal_t parser_kimreader_data;
    input                 kimreader_parser_ack;

    
    
    
    output tlv_parser_idle;
    output tlv_parser_int_tlv_start_pulse;



    typedef struct packed {
        logic [0:0]     start;
        logic [0:0]     partial;
        logic [0:0]     endian_swap;
        kme_internal_id till;
    } skip_control;



    kme_internal_t  fifo_in;    
    wire            fifo_in_stall;
    reg             fifo_in_valid;
    reg             key_blob_region;
    reg [5:0]       int_tlv_counter;
    reg [4:0]       tlv_counter;

    tlv_rqe_word_0_t        tlv_word0;
    tlv_rqe_word_1_t        tlv_word1;
    tlv_cmd_word_2_t        tlv_word2;

    kme_internal_id         nxt_fifo_in_id;
    tlv_cmd_word_1_t        frame_word;
    kme_internal_word_0_t   kme_internal_word0       , nxt_kme_internal_word0;
    kme_internal_word_8_t   kme_internal_dek_kim_word, nxt_kme_internal_dek_kim_word;
    kme_internal_word_9_t   kme_internal_dak_kim_word, nxt_kme_internal_dak_kim_word;
    tlv_types_e             tlv_type                 , nxt_tlv_type;
    aux_key_type_e          aux_key_type             , nxt_aux_key_type;
    cmd_iv_op_e             aux_iv_op                , nxt_aux_iv_op;
    cmd_cipher_op_e         aux_cipher_op            , nxt_aux_cipher_op;
    cmd_auth_op_e           aux_auth_op              , nxt_aux_auth_op;
    cmd_auth_op_e           aux_raw_auth_op          , nxt_aux_raw_auth_op;
    cmd_debug_t             debug_cmd                , nxt_debug_cmd;    
    aux_key_ctrl_t          aux_key_header           , nxt_aux_key_header;
    skip_control            skip                     , nxt_skip;
    
    reg [63:0] guid0, nxt_guid0;
    reg [63:0] guid1, nxt_guid1;
    reg [63:0] guid2, nxt_guid2;
    reg [63:0] guid3, nxt_guid3;
    
    reg [63:0] iv0, nxt_iv0;
    reg [63:0] iv1, nxt_iv1;

    reg [31:0] buffer, nxt_buffer;




    wire stitcher_sot = (stitcher_out.tuser == 8'd1);
    wire stitcher_eot = (stitcher_out.tuser == 8'd2);

  
    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tlv_counter <= 5'd0;
        end else if (stitcher_rd) begin
            if (stitcher_eot) begin
                tlv_counter <= 5'd0;
            end else begin
                tlv_counter <= tlv_counter + 1'b1;
            end
        end
    end

    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tlv_type <= RQE;
            aux_key_type <= NO_AUX_KEY;
            aux_iv_op <= IV_SRC;
            aux_cipher_op <= CPH_NULL;
            aux_auth_op <= AUTH_NULL;
            aux_raw_auth_op <= AUTH_NULL;
            kme_internal_word0 <= {$bits(kme_internal_word_0_t){1'b0}};
            kme_internal_dek_kim_word <= {$bits(kme_internal_word_8_t){1'b0}};
            kme_internal_dak_kim_word <= {$bits(kme_internal_word_9_t){1'b0}};
            debug_cmd <= {$bits(cmd_debug_t){1'b0}};
            aux_key_header <= {$bits(aux_key_ctrl_t){1'b0}};
            skip <= {$bits(skip_control){1'b0}};
            guid0 <= 64'b0;
            guid1 <= 64'b0;
            guid2 <= 64'b0;
            guid3 <= 64'b0;
            iv0 <= 64'b0;
            iv1 <= 64'b0;
            buffer <= 32'b0;
            fifo_in.id <= KME_WORD0;
        end else begin
            tlv_type <= nxt_tlv_type;
            aux_key_type <= nxt_aux_key_type;
            aux_iv_op <= nxt_aux_iv_op;
            aux_cipher_op <= nxt_aux_cipher_op;
            aux_auth_op <= nxt_aux_auth_op;
            aux_raw_auth_op <= nxt_aux_raw_auth_op;
            kme_internal_word0 <= nxt_kme_internal_word0;
            kme_internal_dek_kim_word <= nxt_kme_internal_dek_kim_word;
            kme_internal_dak_kim_word <= nxt_kme_internal_dak_kim_word;
            debug_cmd <= nxt_debug_cmd;
            aux_key_header <= nxt_aux_key_header;
            skip <= nxt_skip;
            guid0 <= nxt_guid0;
            guid1 <= nxt_guid1;
            guid2 <= nxt_guid2;
            guid3 <= nxt_guid3;
            iv0 <= nxt_iv0;
            iv1 <= nxt_iv1;
            buffer <= nxt_buffer;
            fifo_in.id <= nxt_fifo_in_id;
        end
    end




    always @ (*) begin

        
        fifo_in.tdata = 64'b0;
        fifo_in_valid = 1'b0;

        nxt_tlv_type                  = tlv_type;
        nxt_aux_key_type              = aux_key_type;
        nxt_aux_iv_op                 = aux_iv_op;
        nxt_aux_cipher_op             = aux_cipher_op;
        nxt_aux_auth_op               = aux_auth_op;
        nxt_aux_raw_auth_op           = aux_raw_auth_op;
        nxt_kme_internal_word0        = kme_internal_word0;
        nxt_kme_internal_dek_kim_word = kme_internal_dek_kim_word;
        nxt_kme_internal_dak_kim_word = kme_internal_dak_kim_word;
        nxt_aux_key_header            = aux_key_header;
        nxt_debug_cmd                 = debug_cmd;
        nxt_skip                      = skip;
        nxt_guid0                     = guid0;
        nxt_guid1                     = guid1;
        nxt_guid2                     = guid2;
        nxt_guid3                     = guid3;
        nxt_iv0                       = iv0;
        nxt_iv1                       = iv1;
        nxt_buffer                    = buffer;

        tlv_word0  = stitcher_out.tdata;
        tlv_word1  = stitcher_out.tdata;
        tlv_word2  = stitcher_out.tdata;
        frame_word = stitcher_out.tdata;

        
        
        
        
        stitcher_rd = ~stitcher_empty & ~fifo_in_stall & ~skip.start;


        if (!fifo_in_stall) begin
            if (skip.start) begin
                if (fifo_in.id == skip.till) begin
                    nxt_skip.start = 1'b0;
                end else begin
                    fifo_in_valid = 1'b1;
                end

                
                
                
                if (skip.partial) begin
                    nxt_skip.partial = 1'b0;
                    nxt_skip.endian_swap = 1'b0;
                    fifo_in.tdata = (skip.endian_swap) ? endian_switch({32'b0, buffer}) : {buffer, 32'b0};
                end

                
                case (int_tlv_counter)
                    6'd2: fifo_in.tdata = guid0;
                    6'd3: fifo_in.tdata = guid1;
                    6'd4: fifo_in.tdata = guid2;
                    6'd5: fifo_in.tdata = guid3;
                    6'd6: fifo_in.tdata = iv0;
                    6'd7: fifo_in.tdata = iv1;
                    6'd8: fifo_in.tdata = kme_internal_dek_kim_word;
                    6'd9: fifo_in.tdata = kme_internal_dak_kim_word;
                endcase

                if (int_tlv_counter == IDX_KME_IVTWEAK) begin
                    
                    
                    nxt_kme_internal_dek_kim_word.validate_dek = validate_dek(always_validate_kim_ref, aux_key_type, aux_cipher_op, aux_key_header.kdf_mode);
                    nxt_kme_internal_dek_kim_word.missing_guid = missing_guid(tlv_type, aux_key_header.kdf_mode, aux_key_header.dek_key_op, aux_key_header.dak_key_op);
                    nxt_kme_internal_dek_kim_word.missing_iv   = missing_iv(tlv_type, aux_iv_op, aux_cipher_op);
                    nxt_kme_internal_dak_kim_word.validate_dak = validate_dak(always_validate_kim_ref, aux_key_type, aux_auth_op  , aux_raw_auth_op);

                    
                    
                    
                    
                    //----------------------------------------------------------------------------------
                    // KME_MODIFICATION_NOTE:
                    // Fatal added to report unsupported feature
                    //----------------------------------------------------------------------------------
                    // synopsys translate_off
                    if (aux_key_header.dek_key_op | aux_key_header.dak_key_op) $fatal("KDF operations are not supported");
                    // synopsys translate_on
                end
            end 
        end







        if (stitcher_rd) begin

            if (key_blob_region) begin

                case (aux_key_type)

                    DEK256, DEK512, DAK: begin
                        
                        
                        fifo_in_valid = 1'b1;
                        fifo_in.tdata = endian_switch({stitcher_out.tdata[31:0], buffer});
                        nxt_buffer    = stitcher_out.tdata[63:32];

                        
                        if (stitcher_eot) begin
                            fifo_in.tdata = endian_switch({stitcher_out.tdata[31:0], buffer});
                            nxt_skip.start = 1'b1;
                            nxt_skip.till = KME_WORD0;
                        end
                    end

                    DEK256_DAK, DEK512_DAK: begin
                        fifo_in_valid = 1'b1;
                        fifo_in.tdata = endian_switch({stitcher_out.tdata[31:0], buffer});
                        nxt_buffer    = stitcher_out.tdata[63:32];

                        
                        if (int_tlv_counter == (IDX_KME_ETAG-1)) begin
                            fifo_in.tdata  = endian_switch({stitcher_out.tdata[31:0], buffer});
                            nxt_skip.start = 1'b1;
                            nxt_skip.till  = KME_DAK;
                        end

                        
                        if (stitcher_eot) begin
                            fifo_in.tdata  = endian_switch({stitcher_out.tdata[31:0], buffer});
                            nxt_skip.start = 1'b1;
                            nxt_skip.till = KME_WORD0;
                        end
                    end

                    ENC_DEK256, ENC_DEK512, ENC_DAK: begin
                        fifo_in_valid = 1'b1;
                        fifo_in.tdata = endian_switch(stitcher_out.tdata);
                        nxt_buffer    = stitcher_out.tdata[63:32];

                        
                        
                        if (int_tlv_counter == IDX_KME_EIV) begin
                            fifo_in.tdata = endian_switch({stitcher_out.tdata[31:0], buffer});
                            nxt_skip.start = 1'b1;
                            nxt_skip.partial = 1'b1;
                            nxt_skip.endian_swap = 1'b1;
                            nxt_skip.till = (aux_key_type == ENC_DEK256) ? KME_DEK1 : KME_DEK0;
                        end

                        
                        
                        if (int_tlv_counter == IDX_KME_AIV) begin
                            fifo_in.tdata = endian_switch({stitcher_out.tdata[31:0], buffer});
                            nxt_skip.start = 1'b1;
                            nxt_skip.partial = 1'b1;
                            nxt_skip.endian_swap = 1'b1;
                            nxt_skip.till = KME_DAK;
                        end

                        
                        if (stitcher_eot) begin
                            fifo_in.tdata = endian_switch({32'b0, stitcher_out.tdata[31:0]});
                            nxt_skip.start = 1'b1;
                            nxt_skip.till  = KME_WORD0;
                        end 
                    end

                    ENC_DEK256_DAK, ENC_DEK512_DAK: begin
                        fifo_in_valid = 1'b1;
                        fifo_in.tdata = endian_switch(stitcher_out.tdata);
                        nxt_buffer    = stitcher_out.tdata[63:32];

                        
                        if (int_tlv_counter == IDX_KME_EIV) begin
                            fifo_in.tdata = endian_switch({stitcher_out.tdata[31:0], buffer});
                            nxt_skip.start = 1'b1;
                            nxt_skip.partial = 1'b1;
                            nxt_skip.endian_swap = 1'b1;
                            nxt_skip.till = (aux_key_type == ENC_DEK256_DAK) ? KME_DEK1 : KME_DEK0;
                        end

                        
                        if (int_tlv_counter == (IDX_KME_AIV-1)) begin
                            fifo_in.tdata = endian_switch({32'b0, stitcher_out.tdata[31:0]});
                        end

                        
                        if (int_tlv_counter == IDX_KME_AIV) begin
                            fifo_in.tdata = endian_switch({stitcher_out.tdata[31:0], buffer});
                            nxt_skip.start = 1'b1;
                            nxt_skip.partial = 1'b1;
                            nxt_skip.endian_swap = 1'b1;
                            nxt_skip.till = KME_DAK;
                        end

                        
                        if (stitcher_eot) begin
                            fifo_in.tdata = endian_switch({32'b0, stitcher_out.tdata[31:0]});
                            nxt_skip.start = 1'b1;
                            nxt_skip.till  = KME_WORD0;
                        end
                    end

                    ENC_DEK256_DAK_COMB, ENC_DEK512_DAK_COMB: begin
                        fifo_in_valid = 1'b1;
                        fifo_in.tdata = endian_switch(stitcher_out.tdata);
                        nxt_buffer    = stitcher_out.tdata[63:32];

                        
                        if (int_tlv_counter == IDX_KME_EIV) begin
                            fifo_in.tdata = endian_switch({stitcher_out.tdata[31:0], buffer});
                            nxt_skip.start = 1'b1;
                            nxt_skip.partial = 1'b1;
                            nxt_skip.endian_swap = 1'b1;
                            nxt_skip.till = (aux_key_type == ENC_DEK256_DAK_COMB) ? KME_DEK1 : KME_DEK0;
                        end

                        
                        if (int_tlv_counter == (IDX_KME_ETAG-1)) begin
                            nxt_skip.start = 1'b1;
                            nxt_skip.till  = KME_DAK;
                        end

                        
                        if (stitcher_eot) begin
                            fifo_in.tdata = endian_switch({32'b0, stitcher_out.tdata[31:0]});
                            nxt_skip.start = 1'b1;
                            nxt_skip.till  = KME_WORD0;
                        end
                   end

                endcase

            end else begin

                case (tlv_counter)

                    5'd0: begin
                        nxt_kme_internal_word0 = {$bits(kme_internal_word_0_t){1'b0}};
                        nxt_kme_internal_word0.tlv_type = tlv_word0.tlv_type;
                        nxt_kme_internal_word0.tlv_eng_id = tlv_word0.tlv_eng_id;
                        nxt_kme_internal_word0.tlv_seq_num = tlv_word0.tlv_seq_num;
                        nxt_kme_internal_word0.tlv_frame_num = tlv_word0.tlv_frame_num;

                        nxt_tlv_type = tlv_word0.tlv_type;

                        if (tlv_word0.tlv_type == RQE) begin
                            nxt_kme_internal_dek_kim_word = {$bits(kme_internal_word_8_t){1'b0}};
                            nxt_kme_internal_dak_kim_word = {$bits(kme_internal_word_9_t){1'b0}};
                            nxt_kme_internal_dek_kim_word.vf_valid = tlv_word0.vf_valid;
                            nxt_kme_internal_dak_kim_word.vf_valid = tlv_word0.vf_valid;
                        end

                        
                        
                        nxt_aux_key_type = NO_AUX_KEY;
                        nxt_aux_iv_op = IV_SRC;
                        nxt_aux_cipher_op = CPH_NULL;
                        nxt_aux_auth_op = AUTH_NULL;
                        nxt_aux_raw_auth_op = AUTH_NULL;
                        nxt_aux_key_header = {$bits(aux_key_ctrl_t){1'b0}};
                        nxt_iv0 = 64'b0;
                        nxt_iv1 = 64'b0;
                        nxt_guid0 = 64'b0;
                        nxt_guid1 = 64'b0;
                        nxt_guid2 = 64'b0;
                        nxt_guid3 = 64'b0;
                    end

                    5'd1: begin
                        if (tlv_type == RQE) begin
                            
                            nxt_kme_internal_dek_kim_word.pf_num = tlv_word1.pf_number;
                            nxt_kme_internal_dek_kim_word.vf_num = tlv_word1.vf_number;
                            nxt_kme_internal_dak_kim_word.pf_num = tlv_word1.pf_number;
                            nxt_kme_internal_dak_kim_word.vf_num = tlv_word1.vf_number;
                        end else begin

                            case (tlv_type)
                                AUX_CMD    : if (frame_word.src_guid_present == GUID_PRESENT) nxt_tlv_type = AUX_CMD_GUID;
                                AUX_CMD_IV : if (frame_word.src_guid_present == GUID_PRESENT) nxt_tlv_type = AUX_CMD_GUID_IV;
                            endcase

                            if (disable_debug_cmd_q) begin
                                
                                nxt_debug_cmd = {$bits(cmd_debug_t){1'b0}};
                            end else begin
                                
                                nxt_debug_cmd = stitcher_out.tdata[63:32];
                            end
                        end
                    end

                    5'd2: begin
                        
                        
                        nxt_kme_internal_word0.key_type  = tlv_word2.key_type;

                        
                        
                        nxt_kme_internal_word0.needs_dek = needs_dek(always_validate_kim_ref, tlv_word2.key_type, tlv_word2.cipher_op);
                        nxt_kme_internal_word0.needs_dak = needs_dak(always_validate_kim_ref, tlv_word2.key_type, tlv_word2.auth_op, tlv_word2.raw_auth_op);

                        
                        nxt_kme_internal_word0.keyless_algos = is_keyless_cipher(tlv_word2.cipher_op) & is_keyless_hash(tlv_word2.auth_op, tlv_word2.raw_auth_op);

                       
                        nxt_kme_internal_word0.kdf_dek_iter  = kdf_dek_iter_f(tlv_word2.cipher_op);

                        nxt_aux_key_type    = tlv_word2.key_type;
                        nxt_aux_iv_op       = tlv_word2.iv_op;
                        nxt_aux_cipher_op   = tlv_word2.cipher_op;
                        nxt_aux_auth_op     = tlv_word2.auth_op;
                        nxt_aux_raw_auth_op = tlv_word2.raw_auth_op;

                        
                        
                        
                        
                        
                        //----------------------------------------------------------------------------------
                        // KME_MODIFICATION_NOTE:
                        // Fatal added to report unsupported feature
                        //----------------------------------------------------------------------------------
                        // synopsys translate_off
                        if (tlv_word2.key_type > 6'h6) $fatal("Encrypted key blobs not supported");
                        // synopsys translate_on

                        fifo_in_valid = 1'b1;
                        fifo_in.tdata = nxt_kme_internal_word0;

                        if (stitcher_eot) begin
                            nxt_buffer = debug_cmd;
                            nxt_skip.start = 1'b1;
                            nxt_skip.partial = 1'b1;
                        end

                    end

                    5'd3: begin
                        case (tlv_type)
                            AUX_CMD_GUID    : nxt_guid0 = endian_switch(stitcher_out.tdata);
                            AUX_CMD_GUID_IV : nxt_guid0 = endian_switch(stitcher_out.tdata);
                            AUX_CMD_IV      : nxt_iv0   = stitcher_out.tdata;
                        endcase

                        if (tlv_type == AUX_CMD) begin
                            {nxt_buffer, nxt_aux_key_header} = stitcher_out.tdata;
                            fifo_in_valid  = 1'b1;
                            fifo_in.tdata  = {debug_cmd, nxt_aux_key_header};
                            nxt_skip.start = 1'b1;
                        end
                    end

                    5'd4: begin
                        case (tlv_type)
                            AUX_CMD_GUID    : nxt_guid1 = endian_switch(stitcher_out.tdata);
                            AUX_CMD_GUID_IV : nxt_guid1 = endian_switch(stitcher_out.tdata);
                            AUX_CMD_IV      : nxt_iv1   = stitcher_out.tdata;
                        endcase

                        if (stitcher_eot) begin
                            nxt_buffer = debug_cmd;
                            nxt_skip.start = 1'b1;
                            nxt_skip.partial = 1'b1;
                        end
                    end

                    5'd5: begin 
                        case (tlv_type)
                            AUX_CMD_GUID    : nxt_guid2 = endian_switch(stitcher_out.tdata);
                            AUX_CMD_GUID_IV : nxt_guid2 = endian_switch(stitcher_out.tdata);
                        endcase

                        if (tlv_type == AUX_CMD_IV) begin
                            {nxt_buffer, nxt_aux_key_header} = stitcher_out.tdata;
                            fifo_in_valid  = 1'b1;
                            fifo_in.tdata  = {debug_cmd, nxt_aux_key_header};
                            nxt_skip.start = 1'b1;
                        end
                    end

                    5'd6: begin
                        case (tlv_type)
                            AUX_CMD_GUID    : nxt_guid3 = endian_switch(stitcher_out.tdata);
                            AUX_CMD_GUID_IV : nxt_guid3 = endian_switch(stitcher_out.tdata);
                        endcase

                        if (stitcher_eot) begin
                            nxt_buffer = debug_cmd;
                            nxt_skip.start = 1'b1;
                            nxt_skip.partial = 1'b1;
                        end
                    end

                    5'd7: begin
                        case (tlv_type)
                            AUX_CMD_GUID_IV : nxt_iv0 = stitcher_out.tdata;
                        endcase

                        if (tlv_type == AUX_CMD_GUID) begin
                            {nxt_buffer, nxt_aux_key_header} = stitcher_out.tdata;
                            fifo_in_valid  = 1'b1;
                            fifo_in.tdata  = {debug_cmd, nxt_aux_key_header};
                            nxt_skip.start = 1'b1;
                        end
                    end

                    5'd8: begin
                        case (tlv_type)
                            AUX_CMD_GUID_IV : nxt_iv1 = stitcher_out.tdata;
                        endcase

                        if (stitcher_eot) begin
                            nxt_buffer = debug_cmd;
                            nxt_skip.start = 1'b1;
                            nxt_skip.partial = 1'b1;
                        end
                    end

                    5'd9: begin
                        {nxt_buffer, nxt_aux_key_header} = stitcher_out.tdata;
                        fifo_in_valid  = 1'b1;
                        fifo_in.tdata  = {debug_cmd, nxt_aux_key_header};
                        nxt_skip.start = 1'b1;
                    end

                endcase

                case (aux_key_type)
                    NO_AUX_KEY:          nxt_skip.till = KME_WORD0;
                    AUX_KEY_ONLY:        nxt_skip.till = KME_WORD0;
                    DEK256:              nxt_skip.till = KME_DEK1;
                    DEK512:              nxt_skip.till = KME_DEK0;
                    DAK:                 nxt_skip.till = KME_DAK;
                    DEK256_DAK:          nxt_skip.till = KME_DEK1;
                    DEK512_DAK:          nxt_skip.till = KME_DEK0;
                    ENC_DEK256:          nxt_skip.till = KME_EIV;
                    ENC_DEK512:          nxt_skip.till = KME_EIV;
                    ENC_DAK:             nxt_skip.till = KME_AIV; 
                    ENC_DEK256_DAK:      nxt_skip.till = KME_EIV;
                    ENC_DEK512_DAK:      nxt_skip.till = KME_EIV;
                    ENC_DEK256_DAK_COMB: nxt_skip.till = KME_EIV;
                    ENC_DEK512_DAK_COMB: nxt_skip.till = KME_EIV;
                endcase
            end
        end


    end

    
    
    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fifo_in.eot <= 1'b0;
            key_blob_region <= 1'b0;
            int_tlv_counter <= 6'd0;
        end else if (fifo_in_valid) begin
            case (int_tlv_counter)
                6'd41:   fifo_in.eot <= 1'b1;
                6'd42:   fifo_in.eot <= 1'b0;
                default: fifo_in.eot <= fifo_in.eot;
            endcase

            case (int_tlv_counter)
                6'd21:   key_blob_region <= 1'b1;
                6'd42:   key_blob_region <= 1'b0;
                default: key_blob_region <= key_blob_region;
            endcase

            case (int_tlv_counter)
                6'd42:   int_tlv_counter <= 6'd0;
                default: int_tlv_counter <= int_tlv_counter + 1'b1;
            endcase
        end
    end 

    
    always @ (*) begin
        nxt_fifo_in_id = fifo_in.id;
        fifo_in.sot = fifo_in_valid & (fifo_in.id == KME_WORD0);
        fifo_in.eoi = 1'b0;

        if (fifo_in_valid) begin
            case (int_tlv_counter)
                (IDX_KME_DEBUG_KEYHDR-6'd1): begin nxt_fifo_in_id = KME_DEBUG_KEYHDR; fifo_in.eoi = 1'b1; end
                (IDX_KME_GUID        -6'd1): begin nxt_fifo_in_id = KME_GUID;         fifo_in.eoi = 1'b1; end
                (IDX_KME_IVTWEAK     -6'd1): begin nxt_fifo_in_id = KME_IVTWEAK;      fifo_in.eoi = 1'b1; end
                (IDX_KME_KIM         -6'd1): begin nxt_fifo_in_id = KME_KIM;          fifo_in.eoi = 1'b1; end
                (IDX_KME_DEK_CKV0    -6'd1): begin nxt_fifo_in_id = KME_DEK_CKV0;     fifo_in.eoi = 1'b1; end
                (IDX_KME_DEK_CKV1    -6'd1): begin nxt_fifo_in_id = KME_DEK_CKV1;     fifo_in.eoi = 1'b1; end
                (IDX_KME_DAK_CKV     -6'd1): begin nxt_fifo_in_id = KME_DAK_CKV;      fifo_in.eoi = 1'b1; end
                (IDX_KME_EIV         -6'd1): begin nxt_fifo_in_id = KME_EIV;          fifo_in.eoi = 1'b1; end
                (IDX_KME_DEK0        -6'd1): begin nxt_fifo_in_id = KME_DEK0;         fifo_in.eoi = 1'b1; end
                (IDX_KME_DEK1        -6'd1): begin nxt_fifo_in_id = KME_DEK1;         fifo_in.eoi = 1'b1; end
                (IDX_KME_ETAG        -6'd1): begin nxt_fifo_in_id = KME_ETAG;         fifo_in.eoi = 1'b1; end
                (IDX_KME_AIV         -6'd1): begin nxt_fifo_in_id = KME_AIV;          fifo_in.eoi = 1'b1; end
                (IDX_KME_DAK         -6'd1): begin nxt_fifo_in_id = KME_DAK;          fifo_in.eoi = 1'b1; end
                (IDX_KME_ATAG        -6'd1): begin nxt_fifo_in_id = KME_ATAG;         fifo_in.eoi = 1'b1; end
                (IDX_KME_ERROR       -6'd1): begin nxt_fifo_in_id = KME_ERROR;        fifo_in.eoi = 1'b1; end
                (IDX_KME_ERROR            ): begin nxt_fifo_in_id = KME_WORD0;        fifo_in.eoi = 1'b1; end
            endcase
        end
    end

    cr_kme_fifo #
    (
        .DATA_SIZE($bits(kme_internal_t)),
        .FIFO_DEPTH(2)
    )
    parser_fifo (
        .clk            (clk),
        .rst_n          (rst_n),

        .fifo_in        (fifo_in),
        .fifo_in_valid  (fifo_in_valid),
        .fifo_in_stall  (fifo_in_stall),

        .fifo_out       (parser_kimreader_data),
        .fifo_out_valid (parser_kimreader_valid),
        .fifo_out_ack   (kimreader_parser_ack),

        .fifo_overflow  (),
        .fifo_underflow (),
        .fifo_in_stall_override(1'b0)
    );

    
    assign tlv_parser_idle                = stitcher_empty & (tlv_counter == 5'd0);
    assign tlv_parser_int_tlv_start_pulse = fifo_in_valid & fifo_in.sot;



    
    
    
    
    function missing_guid;
        input tlv_types_e       l_tlv_type;
        input aux_kdf_mode_e    kdf_mode;
        input aux_key_op_e      dek_key_op;
        input aux_key_op_e      dak_key_op;
        begin
          missing_guid  = (((l_tlv_type == AUX_CMD) || (l_tlv_type == AUX_CMD_IV)) &&           
                           ((dek_key_op == KDF) || (dak_key_op == KDF)) &&                      
                           ((kdf_mode == KDF_MODE_GUID) || (kdf_mode == KDF_MODE_COMB_GUID)));  
        end
    endfunction

    
    
    
    function missing_iv;
        input tlv_types_e       l_tlv_type;
        input cmd_iv_op_e       iv_op;
        input cmd_cipher_op_e   cipher_op;
        begin
          missing_iv  = (((l_tlv_type == AUX_CMD) || (l_tlv_type == AUX_CMD_GUID)) &&  
                         (iv_op == IV_INC) &&                                          
                         ~is_keyless_cipher(cipher_op));                               
        end
    endfunction


    
    function validate_dek;
        input                   off;
        input aux_key_type_e    key_type;
        input cmd_cipher_op_e   cipher_op;
        input aux_kdf_mode_e    kdf_mode;
        begin
            validate_dek = 1'b1;

            if (!off) begin
                case (key_type)
                    NO_AUX_KEY  : validate_dek = 1'b0;





                    AUX_KEY_ONLY: if (is_keyless_cipher(cipher_op) & is_kdf_non_combo(kdf_mode)) validate_dek = 1'b0;  
                    ENC_DAK     : if (is_keyless_cipher(cipher_op) & is_kdf_non_combo(kdf_mode)) validate_dek = 1'b0;  
                endcase
            end
        end
    endfunction

    
    function validate_dak;
        input                   off;
        input aux_key_type_e    key_type;
        input cmd_auth_op_e     auth_op;
        input cmd_auth_op_e     raw_auth_op;
        begin
            validate_dak = 1'b1;

            if (!off) begin
                case (key_type)
                    NO_AUX_KEY  : validate_dak = 1'b0;





                    AUX_KEY_ONLY: if (is_keyless_hash(auth_op, raw_auth_op)) validate_dak = 1'b0; 
                    ENC_DEK256  : if (is_keyless_hash(auth_op, raw_auth_op)) validate_dak = 1'b0; 
                    ENC_DEK512  : if (is_keyless_hash(auth_op, raw_auth_op)) validate_dak = 1'b0; 
                endcase
            end
        end
    endfunction

    
    function needs_dek;
        input                   off;
        input aux_key_type_e    key_type;
        input cmd_cipher_op_e   cipher_op;
        begin
            needs_dek = 1'b1;

            if (!off) begin
                case (key_type)
                    NO_AUX_KEY  : needs_dek = 1'b0;



                    AUX_KEY_ONLY: if (is_keyless_cipher(cipher_op)) needs_dek = 1'b0;  
                    ENC_DAK     : if (is_keyless_cipher(cipher_op)) needs_dek = 1'b0;  
                endcase
            end
        end
    endfunction

    
    function needs_dak;
        input                   off;
        input aux_key_type_e    key_type;
        input cmd_auth_op_e     auth_op;
        input cmd_auth_op_e     raw_auth_op;
        begin
            needs_dak = 1'b1;

            if (!off) begin
                case (key_type)
                    NO_AUX_KEY  : needs_dak = 1'b0;



                    AUX_KEY_ONLY: if (is_keyless_hash(auth_op, raw_auth_op)) needs_dak = 1'b0; 
                    ENC_DEK256  : if (is_keyless_hash(auth_op, raw_auth_op)) needs_dak = 1'b0; 
                    ENC_DEK512  : if (is_keyless_hash(auth_op, raw_auth_op)) needs_dak = 1'b0; 
                endcase
            end
        end
    endfunction

    function is_keyless_cipher;
        input cmd_cipher_op_e cipher_op;
        begin
            
            is_keyless_cipher = ~((cipher_op == AES_GCM) | (cipher_op == AES_XTS_XEX) | (cipher_op == AES_GMAC)); 
        end
    endfunction

    function is_keyless_hash;
        input cmd_auth_op_e auth_op;
        input cmd_auth_op_e raw_auth_op;
        begin
            
            is_keyless_hash = (auth_op != HMAC_SHA2) & (raw_auth_op != HMAC_SHA2); 
        end
    endfunction

    function is_kdf_non_combo;
        input aux_kdf_mode_e kdf_mode;
        begin
            
            is_kdf_non_combo = (kdf_mode == KDF_MODE_GUID) | (kdf_mode == KDF_MODE_RGUID); 
        end
    endfunction

    
    function kdf_dek_iter_f;
        input cmd_cipher_op_e cipher_op;
        begin
            
            
            kdf_dek_iter_f = (cipher_op == AES_XTS_XEX) ? 1'b1 : 1'b0; 
        end
    endfunction


    

    

    genvar ii, jj, kk, nn, qq;

    generate
        
        for (jj=0; jj<=13; jj=jj+1) begin : key_type
            brcm_aux_cmd        : `COVER_PROPERTY(fifo_in_valid & (fifo_in.id == KME_WORD0) & (tlv_type == 21) & (tlv_word2.key_type == jj)); 
            brcm_aux_cmd_iv     : `COVER_PROPERTY(fifo_in_valid & (fifo_in.id == KME_WORD0) & (tlv_type == 23) & (tlv_word2.key_type == jj)); 
            brcm_aux_cmd_guid   : `COVER_PROPERTY(fifo_in_valid & (fifo_in.id == KME_WORD0) & (tlv_type == 24) & (tlv_word2.key_type == jj)); 
            brcm_aux_cmd_guid_iv: `COVER_PROPERTY(fifo_in_valid & (fifo_in.id == KME_WORD0) & (tlv_type == 25) & (tlv_word2.key_type == jj)); 
            brcm_key_type       : `COVER_PROPERTY(fifo_in_valid & (fifo_in.id == KME_WORD0)                    & (tlv_word2.key_type == jj)); 
        end

        
        for (ii=0; ii<=3; ii=ii+1) begin : kdf_mode
            for (jj=0; jj<=1; jj=jj+1) begin : dek_op
                for (kk=0; kk<=1; kk=kk+1) begin : dak_op
                    brcm_kdf_ops: `COVER_PROPERTY(fifo_in_valid & (fifo_in.id == KME_ERROR) & (aux_key_header.kdf_mode   == ii) 
                                                                                            & (aux_key_header.dek_key_op == jj)
                                                                                            & (aux_key_header.dak_key_op == kk));
                end
            end
        end

      

      
      key_type0_line4: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                       ((aux_auth_op == HMAC_SHA2) || 
                                       (aux_raw_auth_op == HMAC_SHA2)) && 
                                       (aux_cipher_op == CPH_NULL) && 
                                       (aux_key_type == NO_AUX_KEY));

      key_type0_line5a: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                        (aux_auth_op != HMAC_SHA2) &&
                                        (aux_raw_auth_op != HMAC_SHA2) && 
                                        (aux_cipher_op == AES_XTS_XEX) && 
                                        (aux_key_type == NO_AUX_KEY));

      key_type0_line5b: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                        (aux_auth_op != HMAC_SHA2) &&
                                        (aux_raw_auth_op != HMAC_SHA2) && 
                                        (aux_cipher_op == AES_GCM) && 
                                        (aux_key_type == NO_AUX_KEY));


      
      key_type1_line7a: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                        (aux_auth_op == AUTH_NULL) && 
                                        (aux_raw_auth_op == AUTH_NULL) && 
                                        (aux_cipher_op == CPH_NULL) && 
                                        (aux_key_type == AUX_KEY_ONLY) && 
                                        (aux_key_header.kdf_mode != KDF_MODE_COMB_GUID) && 
                                        (aux_key_header.kdf_mode != KDF_MODE_COMB_RGUID));

      key_type1_line7b: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                        (aux_auth_op == SHA2) && 
                                        (aux_raw_auth_op == SHA2) && 
                                        (aux_cipher_op == CPH_NULL) && 
                                        (aux_key_type == AUX_KEY_ONLY) && 
                                        (aux_key_header.kdf_mode != KDF_MODE_COMB_GUID) && 
                                        (aux_key_header.kdf_mode != KDF_MODE_COMB_RGUID));


      key_type1_line8a: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                        (aux_auth_op == AUTH_NULL) && 
                                        (aux_raw_auth_op == AUTH_NULL) && 
                                        (aux_cipher_op == CPH_NULL) && 
                                        (aux_key_type == AUX_KEY_ONLY) && 
                                        ((aux_key_header.kdf_mode == KDF_MODE_COMB_GUID) || (aux_key_header.kdf_mode == KDF_MODE_COMB_RGUID)));


      key_type1_line8b: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                        (aux_auth_op == SHA2) && 
                                        (aux_raw_auth_op == SHA2) && 
                                        (aux_cipher_op == CPH_NULL) && 
                                        (aux_key_type == AUX_KEY_ONLY) && 
                                        ((aux_key_header.kdf_mode == KDF_MODE_COMB_GUID) || (aux_key_header.kdf_mode == KDF_MODE_COMB_RGUID))); 


      key_type1_line9: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                       (aux_auth_op == HMAC_SHA2) && 
                                       (aux_raw_auth_op == HMAC_SHA2) && 
                                       (aux_cipher_op == CPH_NULL) && 
                                       (aux_key_type == AUX_KEY_ONLY) && 
                                       (aux_key_header.kdf_mode != KDF_MODE_COMB_GUID) && 
                                       (aux_key_header.kdf_mode != KDF_MODE_COMB_RGUID));


      key_type1_line10: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                        (aux_auth_op == HMAC_SHA2) && 
                                        (aux_raw_auth_op == HMAC_SHA2) && 
                                        (aux_cipher_op == CPH_NULL) && 
                                        (aux_key_type == AUX_KEY_ONLY) && 
                                        ((aux_key_header.kdf_mode == KDF_MODE_COMB_GUID) || (aux_key_header.kdf_mode == KDF_MODE_COMB_RGUID)));

      key_type1_line11a: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                         (aux_auth_op == AUTH_NULL) && 
                                         (aux_raw_auth_op == AUTH_NULL) && 
                                         (aux_cipher_op == AES_GCM) && 
                                         (aux_key_type == AUX_KEY_ONLY));

      key_type1_line11b: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                         (aux_auth_op == AUTH_NULL) && 
                                         (aux_raw_auth_op == AUTH_NULL) && 
                                         (aux_cipher_op == AES_XTS_XEX) && 
                                         (aux_key_type == AUX_KEY_ONLY));

      key_type1_line11c: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                         (aux_auth_op == SHA2) && 
                                         (aux_raw_auth_op == SHA2) && 
                                         (aux_cipher_op == AES_GCM) && 
                                         (aux_key_type == AUX_KEY_ONLY));

      key_type1_line11d: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                         (aux_auth_op == SHA2) && 
                                         (aux_raw_auth_op == SHA2) && 
                                         (aux_cipher_op == AES_XTS_XEX) && 
                                         (aux_key_type == AUX_KEY_ONLY));

      key_type1_line12a: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                         (aux_auth_op == HMAC_SHA2) && 
                                         (aux_raw_auth_op == HMAC_SHA2) && 
                                         (aux_cipher_op == AES_GCM) && 
                                         (aux_key_type == AUX_KEY_ONLY));


      key_type1_line12b: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                         (aux_auth_op == HMAC_SHA2) && 
                                         (aux_raw_auth_op == HMAC_SHA2) && 
                                         (aux_cipher_op == AES_XTS_XEX) && 
                                         (aux_key_type == AUX_KEY_ONLY));

      
      key_type9_line14: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                        (aux_auth_op == HMAC_SHA2) && 
                                        (aux_raw_auth_op == HMAC_SHA2) && 
                                        (aux_cipher_op == CPH_NULL) && 
                                        (aux_key_type == ENC_DAK) && 
                                        (aux_key_header.kdf_mode != KDF_MODE_COMB_GUID) && 
                                        (aux_key_header.kdf_mode != KDF_MODE_COMB_RGUID));

      key_type9_line15: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                        (aux_auth_op == HMAC_SHA2) && 
                                        (aux_raw_auth_op == HMAC_SHA2) && 
                                        (aux_cipher_op == CPH_NULL) && 
                                        (aux_key_type == ENC_DAK) && 
                                        ((aux_key_header.kdf_mode == KDF_MODE_COMB_GUID) || (aux_key_header.kdf_mode == KDF_MODE_COMB_RGUID)));
      
      key_type9_line16a: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                         (aux_auth_op == HMAC_SHA2) && 
                                         (aux_raw_auth_op == HMAC_SHA2) && 
                                         (aux_cipher_op == AES_GCM) && 
                                         (aux_key_type == ENC_DAK));

      key_type9_line16b: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                         (aux_auth_op == HMAC_SHA2) && 
                                         (aux_raw_auth_op == HMAC_SHA2) && 
                                         (aux_cipher_op == AES_XTS_XEX) && 
                                         (aux_key_type == ENC_DAK));

      key_type9_line17a: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                         (aux_auth_op == AUTH_NULL) && 
                                         (aux_raw_auth_op == AUTH_NULL) && 
                                         (aux_cipher_op == CPH_NULL) && 
                                         (aux_key_type == ENC_DAK) && 
                                         (aux_key_header.kdf_mode != KDF_MODE_COMB_GUID) && 
                                         (aux_key_header.kdf_mode != KDF_MODE_COMB_RGUID));


      key_type9_line17b: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                         (aux_auth_op == SHA2) && 
                                         (aux_raw_auth_op == SHA2) && 
                                         (aux_cipher_op == CPH_NULL) && 
                                         (aux_key_type == ENC_DAK) && 
                                         (aux_key_header.kdf_mode != KDF_MODE_COMB_GUID) && 
                                         (aux_key_header.kdf_mode != KDF_MODE_COMB_RGUID));

      key_type9_line18a: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                         (aux_auth_op == AUTH_NULL) && 
                                         (aux_raw_auth_op == AUTH_NULL) && 
                                         (aux_cipher_op == CPH_NULL) && 
                                         (aux_key_type == ENC_DAK) && 
                                         ((aux_key_header.kdf_mode == KDF_MODE_COMB_GUID) || (aux_key_header.kdf_mode == KDF_MODE_COMB_RGUID))); 
                                         

      key_type9_line18b: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                         (aux_auth_op == SHA2) && 
                                         (aux_raw_auth_op == SHA2) && 
                                         (aux_cipher_op == CPH_NULL) && 
                                         (aux_key_type == ENC_DAK) && 
                                         ((aux_key_header.kdf_mode == KDF_MODE_COMB_GUID) || (aux_key_header.kdf_mode == KDF_MODE_COMB_RGUID))); 


      key_type9_line19a: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                         (aux_auth_op == AUTH_NULL) && 
                                         (aux_raw_auth_op == AUTH_NULL) && 
                                         (aux_cipher_op == AES_GCM) && 
                                         (aux_key_type == ENC_DAK));
                                         

      key_type9_line19b: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                         (aux_auth_op == SHA2) && 
                                         (aux_raw_auth_op == SHA2) && 
                                         (aux_cipher_op == AES_GCM) && 
                                         (aux_key_type == ENC_DAK)); 

      key_type9_line19c: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                         (aux_auth_op == AUTH_NULL) && 
                                         (aux_raw_auth_op == AUTH_NULL) && 
                                         (aux_cipher_op == AES_XTS_XEX) && 
                                         (aux_key_type == ENC_DAK));
                                         

      key_type9_line19d: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                         (aux_auth_op == SHA2) && 
                                         (aux_raw_auth_op == SHA2) && 
                                         (aux_cipher_op == AES_XTS_XEX) && 
                                         (aux_key_type == ENC_DAK)); 



      

        
        for (nn=7; nn<=8; nn=nn+1) begin : key_type_enc_dek

          null_gcm: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                    (aux_auth_op == AUTH_NULL) && 
                                    (aux_raw_auth_op == AUTH_NULL) && 
                                    (aux_cipher_op == AES_GCM) && 
                                    (aux_key_type == nn));
          

          sha_gcm: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                   (aux_auth_op == SHA2) && 
                                   (aux_raw_auth_op == SHA2) && 
                                   (aux_cipher_op == AES_GCM) && 
                                   (aux_key_type == nn)); 

          null_xts: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                    (aux_auth_op == AUTH_NULL) && 
                                    (aux_raw_auth_op == AUTH_NULL) && 
                                    (aux_cipher_op == AES_XTS_XEX) && 
                                    (aux_key_type == nn));

          sha_xts: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                   (aux_auth_op == SHA2) && 
                                   (aux_raw_auth_op == SHA2) && 
                                   (aux_cipher_op == AES_XTS_XEX) && 
                                   (aux_key_type == nn)); 

          null_null: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                     (aux_auth_op == AUTH_NULL) && 
                                     (aux_raw_auth_op == AUTH_NULL) && 
                                     (aux_cipher_op == CPH_NULL) && 
                                     (aux_key_type == nn));

          sha_null: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                    (aux_auth_op == SHA2) && 
                                    (aux_raw_auth_op == SHA2) && 
                                    (aux_cipher_op == CPH_NULL) && 
                                    (aux_key_type == nn)); 


          hmac_gcm: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                    (aux_auth_op == HMAC_SHA2) && 
                                    (aux_raw_auth_op == HMAC_SHA2) && 
                                    (aux_cipher_op == AES_GCM) && 
                                    (aux_key_type == nn));

          hmac_xts: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                    (aux_auth_op == HMAC_SHA2) && 
                                    (aux_raw_auth_op == HMAC_SHA2) && 
                                    (aux_cipher_op == AES_XTS_XEX) && 
                                    (aux_key_type == nn));

          hmac_null: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                     (aux_auth_op == HMAC_SHA2) && 
                                     (aux_raw_auth_op == HMAC_SHA2) && 
                                     (aux_cipher_op == CPH_NULL) && 
                                     (aux_key_type == nn));
        end


        
        for (qq=10; qq<=13; qq=qq+1) begin : key_type_enc_dek_dak

          null_gcm: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                    (aux_auth_op == AUTH_NULL) && 
                                    (aux_raw_auth_op == AUTH_NULL) && 
                                    (aux_cipher_op == AES_GCM) && 
                                    (aux_key_type == qq));
          

          sha_gcm: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                   (aux_auth_op == SHA2) && 
                                   (aux_raw_auth_op == SHA2) && 
                                   (aux_cipher_op == AES_GCM) && 
                                   (aux_key_type == qq)); 

          null_xts: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                    (aux_auth_op == AUTH_NULL) && 
                                    (aux_raw_auth_op == AUTH_NULL) && 
                                    (aux_cipher_op == AES_XTS_XEX) && 
                                    (aux_key_type == qq));

          sha_xts: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                   (aux_auth_op == SHA2) && 
                                   (aux_raw_auth_op == SHA2) && 
                                   (aux_cipher_op == AES_XTS_XEX) && 
                                   (aux_key_type == qq)); 

          null_null: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                     (aux_auth_op == AUTH_NULL) && 
                                     (aux_raw_auth_op == AUTH_NULL) && 
                                     (aux_cipher_op == CPH_NULL) && 
                                     (aux_key_type == qq));

          sha_null: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                    (aux_auth_op == SHA2) && 
                                    (aux_raw_auth_op == SHA2) && 
                                    (aux_cipher_op == CPH_NULL) && 
                                    (aux_key_type == qq)); 


          hmac_gcm: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                    (aux_auth_op == HMAC_SHA2) && 
                                    (aux_raw_auth_op == HMAC_SHA2) && 
                                    (aux_cipher_op == AES_GCM) && 
                                    (aux_key_type == qq));

          hmac_xts: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                    (aux_auth_op == HMAC_SHA2) && 
                                    (aux_raw_auth_op == HMAC_SHA2) && 
                                    (aux_cipher_op == AES_XTS_XEX) && 
                                    (aux_key_type == qq));

          hmac_null: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                     (aux_auth_op == HMAC_SHA2) && 
                                     (aux_raw_auth_op == HMAC_SHA2) && 
                                     (aux_cipher_op == CPH_NULL) && 
                                     (aux_key_type == qq));
        end


      
      guid_miss_aux_cmd_0: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                           (tlv_type == AUX_CMD) && 
                                           (aux_key_header.kdf_mode == KDF_MODE_GUID) && 
                                           (aux_key_header.dek_key_op == KDF) && 
                                           (aux_key_header.dak_key_op == NOOP)); 

      guid_miss_aux_cmd_1: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                           (tlv_type == AUX_CMD) && 
                                           (aux_key_header.kdf_mode == KDF_MODE_GUID) && 
                                           (aux_key_header.dek_key_op == NOOP) && 
                                           (aux_key_header.dak_key_op == KDF)); 
      
      guid_miss_aux_cmd_2: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                           (tlv_type == AUX_CMD) && 
                                           (aux_key_header.kdf_mode == KDF_MODE_COMB_GUID) && 
                                           (aux_key_header.dek_key_op == KDF) && 
                                           (aux_key_header.dak_key_op == NOOP)); 

      guid_miss_aux_cmd_3: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                           (tlv_type == AUX_CMD) && 
                                           (aux_key_header.kdf_mode == KDF_MODE_COMB_GUID) && 
                                           (aux_key_header.dek_key_op == NOOP) && 
                                           (aux_key_header.dak_key_op == KDF)); 

      guid_miss_aux_cmd_iv_0: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                              (tlv_type == AUX_CMD_IV) && 
                                              (aux_key_header.kdf_mode == KDF_MODE_GUID) && 
                                              (aux_key_header.dek_key_op == KDF) && 
                                              (aux_key_header.dak_key_op == NOOP)); 

      guid_miss_aux_cmd_iv_1: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                              (tlv_type == AUX_CMD_IV) && 
                                              (aux_key_header.kdf_mode == KDF_MODE_GUID) && 
                                              (aux_key_header.dek_key_op == NOOP) && 
                                              (aux_key_header.dak_key_op == KDF)); 
      
      guid_miss_aux_cmd_iv_2: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                              (tlv_type == AUX_CMD_IV) && 
                                              (aux_key_header.kdf_mode == KDF_MODE_COMB_GUID) && 
                                              (aux_key_header.dek_key_op == KDF) && 
                                              (aux_key_header.dak_key_op == NOOP)); 

      guid_miss_aux_cmd_iv_3: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                              (tlv_type == AUX_CMD_IV) && 
                                              (aux_key_header.kdf_mode == KDF_MODE_COMB_GUID) && 
                                              (aux_key_header.dek_key_op == NOOP) && 
                                              (aux_key_header.dak_key_op == KDF)); 

      
      iv_miss_aux_cmd_0: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                       (tlv_type == AUX_CMD) && 
                                       (aux_iv_op == IV_INC) && 
                                       (aux_cipher_op == AES_GCM)); 

      iv_miss_aux_cmd_1: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                       (tlv_type == AUX_CMD) && 
                                       (aux_iv_op == IV_INC) && 
                                       (aux_cipher_op == AES_XTS_XEX)); 

      iv_miss_aux_cmd_guid: `COVER_PROPERTY((int_tlv_counter == IDX_KME_IVTWEAK) && 
                                            (tlv_type == AUX_CMD_GUID) && 
                                            (aux_iv_op == IV_INC) && 
                                            (aux_cipher_op == AES_XTS_XEX)); 



    endgenerate





    

endmodule









