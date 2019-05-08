/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_kop_tlv_inspector (
   
   kme_internal_out_ack, gcm_cmd_in, gcm_cmd_in_valid,
   gcm_tag_data_in, gcm_tag_data_in_valid, inspector_upsizer_valid,
   inspector_upsizer_eof, inspector_upsizer_data, keyfilter_cmd_in,
   keyfilter_cmd_in_valid, kdfstream_cmd_in, kdfstream_cmd_in_valid,
   kdf_cmd_in, kdf_cmd_in_valid, tlv_sb_data_in, tlv_sb_data_in_valid,
   
   clk, rst_n, labels, kme_internal_out, kme_internal_out_valid,
   gcm_cmd_in_stall, gcm_tag_data_in_stall, upsizer_inspector_stall,
   keyfilter_cmd_in_stall, kdfstream_cmd_in_stall, kdf_cmd_in_stall,
   tlv_sb_data_in_stall
   );

    `include "cr_kme_body_param.v"

    parameter CCEIP_ENCRYPT_KOP = 0;

    
    
    
    input clk;
    input rst_n;

    
    
    
    input label_t [7:0]     labels;
 
    
    
    
    input  kme_internal_t   kme_internal_out;
    input                   kme_internal_out_valid;
    output reg              kme_internal_out_ack;

    
    
    
    output gcm_cmd_t        gcm_cmd_in;
    output reg              gcm_cmd_in_valid;
    input  wire             gcm_cmd_in_stall;

    
    
    
    output reg  [95:0]      gcm_tag_data_in;
    output reg              gcm_tag_data_in_valid;
    input  wire             gcm_tag_data_in_stall;

    
    
    
    output reg              inspector_upsizer_valid;
    output reg              inspector_upsizer_eof;
    output reg  [63:0]      inspector_upsizer_data;
    input  wire             upsizer_inspector_stall;

    
    
    
    output keyfilter_cmd_t  keyfilter_cmd_in;
    output reg              keyfilter_cmd_in_valid;
    input  wire             keyfilter_cmd_in_stall;

    
    
    
    output kdfstream_cmd_t  kdfstream_cmd_in;
    output reg              kdfstream_cmd_in_valid;
    input  wire             kdfstream_cmd_in_stall;

    
    
    
    output kdf_cmd_t        kdf_cmd_in;
    output reg              kdf_cmd_in_valid;
    input  wire             kdf_cmd_in_stall;

    
    
    
    output reg [63:0]       tlv_sb_data_in;
    output reg              tlv_sb_data_in_valid;
    input                   tlv_sb_data_in_stall;




    cmd_debug_t             debug_cmd;
    kme_internal_word_0_t   int_tlv_word0;
    kme_internal_word_8_t   int_tlv_word8;
    kme_internal_word_9_t   int_tlv_word9;
    kme_internal_word_42_t  int_tlv_word42;
    aux_key_ctrl_t          key_header;
    kdfstream_cmd_t         stream_cmd_in;
    kdfstream_cmd_t         stream_cmd_in_nxt;
    gcm_cmd_t               gcm_dek_cmd_in;
    gcm_cmd_t               gcm_dek_cmd_in_nxt;
    gcm_cmd_t               gcm_dak_cmd_in;
    gcm_cmd_t               gcm_dak_cmd_in_nxt;
    reg                     skip_dek_kdf;
    reg                     skip_dek_kdf_nxt;
    reg                     skip_dak_kdf;
    reg                     skip_dak_kdf_nxt;
    reg [95:0]              gcm_dek_tag;
    reg [95:0]              gcm_dek_tag_nxt;
    reg [95:0]              gcm_dak_tag;
    reg [95:0]              gcm_dak_tag_nxt;
    reg                     corrupt_kme_error_bit_0;
    reg                     rst_corrupt_kme_error_bit_0;
    reg                     corrupt_crc32;
    reg                     rst_corrupt_crc32;
    reg                     kdf_dek_iter_nxt;
    reg                     kdf_dek_iter;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stream_cmd_in  <= {$bits(kdfstream_cmd_t){1'b0}};
            gcm_dek_cmd_in <= {$bits(gcm_cmd_t){1'b0}};
            gcm_dak_cmd_in <= {$bits(gcm_cmd_t){1'b0}};
            gcm_dek_tag    <= 96'b0;
            gcm_dak_tag    <= 96'b0;
            skip_dek_kdf   <= 1'b0;
            skip_dak_kdf   <= 1'b0;
            kdf_dek_iter   <= 1'b0;
        end else begin
            stream_cmd_in  <= stream_cmd_in_nxt;
            gcm_dek_cmd_in <= gcm_dek_cmd_in_nxt;
            gcm_dak_cmd_in <= gcm_dak_cmd_in_nxt;
            gcm_dek_tag    <= gcm_dek_tag_nxt;
            gcm_dak_tag    <= gcm_dak_tag_nxt;
            skip_dek_kdf   <= skip_dek_kdf_nxt;
            skip_dak_kdf   <= skip_dak_kdf_nxt;
            kdf_dek_iter   <= kdf_dek_iter_nxt;
        end
    end

    
    
    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            corrupt_kme_error_bit_0 <= 1'b0;
            rst_corrupt_kme_error_bit_0 <= 1'b0;
            corrupt_crc32 <= 1'b0;
            rst_corrupt_crc32 <= 1'b0;
        end else if (kme_internal_out_ack) begin
            if (kme_internal_out.id == KME_DEBUG_KEYHDR) begin
                if (debug_cmd.tlvp_corrupt == USER) begin
                    if (debug_cmd.module_id == 5'h1F) begin
                        if (debug_cmd.cmd_type == FUNCTIONAL_ERROR) begin

                            
                            if (debug_cmd.cmd_mode == SINGLE_ERR) begin
                                case (debug_cmd.byte_msk[0])
                                    1'd0: begin corrupt_kme_error_bit_0 <= 1'b1; rst_corrupt_kme_error_bit_0 <= 1'b1; end
                                    1'd1: begin corrupt_crc32           <= 1'b1; rst_corrupt_crc32           <= 1'b1; end
                                endcase
                            end

                            if (debug_cmd.cmd_mode == CONTINUOUS_ERROR) begin
                                case (debug_cmd.byte_msk[0])
                                    1'd0: corrupt_kme_error_bit_0 <= 1'b1;
                                    1'd1: corrupt_crc32           <= 1'b1;
                                endcase
                            end

                            if (debug_cmd.cmd_mode == STOP) begin
                                case (debug_cmd.byte_msk[0])
                                    1'd0: corrupt_kme_error_bit_0 <= 1'b0;
                                    1'd1: corrupt_crc32           <= 1'b0;
                                endcase
                            end
                        end
                    end
                end
            end

            if (kme_internal_out.id == KME_ERROR) begin
                if (rst_corrupt_kme_error_bit_0) begin
                    corrupt_kme_error_bit_0     <= 1'b0;
                    rst_corrupt_kme_error_bit_0 <= 1'b0;
                end

                if (rst_corrupt_crc32) begin
                    corrupt_crc32     <= 1'b0;
                    rst_corrupt_crc32 <= 1'b0;
                end
            end
        end
    end
 

    always @ (*) begin

        inspector_upsizer_valid = 1'b0;
        inspector_upsizer_eof = 1'b0;
        inspector_upsizer_data = 64'b0;

        gcm_cmd_in_valid = 1'b0;
        gcm_cmd_in = {$bits(gcm_cmd_t){1'b0}};

        gcm_tag_data_in = 96'b0;
        gcm_tag_data_in_valid = 1'b0;

        keyfilter_cmd_in_valid = 1'b0;
        keyfilter_cmd_in = {$bits(keyfilter_cmd_t){1'b0}};

        kdf_cmd_in_valid = 1'b0;
        kdf_cmd_in = {$bits(kdf_cmd_t){1'b0}};

        kdfstream_cmd_in_valid = 1'b0;
        kdfstream_cmd_in = {$bits(kdfstream_cmd_t){1'b0}};

        tlv_sb_data_in_valid = 1'b0;
        tlv_sb_data_in = 64'b0;

        int_tlv_word0  = kme_internal_out.tdata;
        int_tlv_word8  = kme_internal_out.tdata;
        int_tlv_word9  = kme_internal_out.tdata;
        int_tlv_word42 = kme_internal_out.tdata;
        debug_cmd      = kme_internal_out.tdata[63:32];
        key_header     = kme_internal_out.tdata[31:0];

        stream_cmd_in_nxt  = stream_cmd_in;
        gcm_dek_cmd_in_nxt = gcm_dek_cmd_in;
        gcm_dak_cmd_in_nxt = gcm_dak_cmd_in;

        gcm_dek_tag_nxt = gcm_dek_tag;
        gcm_dak_tag_nxt = gcm_dak_tag;

        skip_dek_kdf_nxt = skip_dek_kdf;
        skip_dak_kdf_nxt = skip_dak_kdf;
  
        kdf_dek_iter_nxt = kdf_dek_iter;

        
        int_tlv_word42.corrupt_crc32 = corrupt_crc32;

        if (CCEIP_ENCRYPT_KOP == 1) begin
            if (corrupt_kme_error_bit_0) begin
                int_tlv_word42[0] = ~kme_internal_out.tdata[0];
            end
        end

        
        kme_internal_out_ack = kme_internal_out_valid;

        
        
        
        if ((kme_internal_out.id == KME_DEK0) & upsizer_inspector_stall) kme_internal_out_ack = 1'b0;
        if ((kme_internal_out.id == KME_DEK1) & upsizer_inspector_stall) kme_internal_out_ack = 1'b0;
        if ((kme_internal_out.id == KME_DAK ) & upsizer_inspector_stall) kme_internal_out_ack = 1'b0;

        
        
        
        
        
        
        if ((kme_internal_out.id == KME_EIV) & kme_internal_out.eoi &  gcm_cmd_in_stall) kme_internal_out_ack = 1'b0;
        if ((kme_internal_out.id == KME_AIV) & kme_internal_out.eoi &  gcm_cmd_in_stall) kme_internal_out_ack = 1'b0;

        
        
        
        if ((kme_internal_out.id == KME_ETAG) & kme_internal_out.eoi & gcm_tag_data_in_stall) kme_internal_out_ack = 1'b0;
        if ((kme_internal_out.id == KME_ATAG) & kme_internal_out.eoi & gcm_tag_data_in_stall) kme_internal_out_ack = 1'b0;

        
        
        if ((kme_internal_out.id == KME_DEBUG_KEYHDR) & kme_internal_out.eoi & kdf_cmd_in_stall) kme_internal_out_ack = 1'b0;
        if ((kme_internal_out.id == KME_DEBUG_KEYHDR) & kme_internal_out.eoi & keyfilter_cmd_in_stall) kme_internal_out_ack = 1'b0;

        
        
        
        
        if ((kme_internal_out.id == KME_KIM) & kdfstream_cmd_in_stall) kme_internal_out_ack = 1'b0;

        
        
        
        
        
        if ((kme_internal_out.id == KME_WORD0  ) & kme_internal_out.eoi   & tlv_sb_data_in_stall) kme_internal_out_ack = 1'b0;
        if ((kme_internal_out.id == KME_GUID   ) & kme_internal_out_valid & tlv_sb_data_in_stall) kme_internal_out_ack = 1'b0;
        if ((kme_internal_out.id == KME_IVTWEAK) & kme_internal_out_valid & tlv_sb_data_in_stall) kme_internal_out_ack = 1'b0;
        if ((kme_internal_out.id == KME_ERROR  ) & kme_internal_out_valid & tlv_sb_data_in_stall) kme_internal_out_ack = 1'b0;



        
        if (kme_internal_out_ack) begin
            if (kme_internal_out.id == KME_DEK0) begin
                inspector_upsizer_valid = 1'b1;
                inspector_upsizer_data = kme_internal_out.tdata;
            end
            if (kme_internal_out.id == KME_DEK1) begin
                inspector_upsizer_valid = 1'b1;
                inspector_upsizer_eof = kme_internal_out.eoi;
                inspector_upsizer_data = kme_internal_out.tdata;
            end
            if (kme_internal_out.id == KME_DAK) begin
                inspector_upsizer_valid = 1'b1;
                inspector_upsizer_eof = kme_internal_out.eoi;
                inspector_upsizer_data = kme_internal_out.tdata;
            end
        end

        
        if (kme_internal_out_ack) begin

            if (kme_internal_out.id == KME_WORD0) begin
                
                gcm_dek_cmd_in_nxt = {$bits(gcm_cmd_t){1'b0}};
                gcm_dak_cmd_in_nxt = {$bits(gcm_cmd_t){1'b0}};

                kdf_dek_iter_nxt   = int_tlv_word0.kdf_dek_iter;

                
                case (int_tlv_word0.key_type)
                    NO_AUX_KEY:          gcm_dek_cmd_in_nxt.op = PT_KEY_BLOB;
                    AUX_KEY_ONLY:        gcm_dek_cmd_in_nxt.op = PT_CKV;
                    DEK256:              gcm_dek_cmd_in_nxt.op = PT_KEY_BLOB;
                    DEK512:              gcm_dek_cmd_in_nxt.op = PT_KEY_BLOB;
                    DAK:                 gcm_dek_cmd_in_nxt.op = PT_CKV;
                    DEK256_DAK:          gcm_dek_cmd_in_nxt.op = PT_KEY_BLOB;
                    DEK512_DAK:          gcm_dek_cmd_in_nxt.op = PT_KEY_BLOB;
                    ENC_DEK256:          gcm_dek_cmd_in_nxt.op = DECRYPT_DEK256;
                    ENC_DEK512:          gcm_dek_cmd_in_nxt.op = DECRYPT_DEK512;
                    ENC_DAK:             gcm_dek_cmd_in_nxt.op = PT_CKV;
                    ENC_DEK256_DAK:      gcm_dek_cmd_in_nxt.op = DECRYPT_DEK256;
                    ENC_DEK512_DAK:      gcm_dek_cmd_in_nxt.op = DECRYPT_DEK512;
                    ENC_DEK256_DAK_COMB: gcm_dek_cmd_in_nxt.op = DECRYPT_DEK256_COMB;
                    ENC_DEK512_DAK_COMB: gcm_dek_cmd_in_nxt.op = DECRYPT_DEK512_COMB;
                endcase

                
                case (int_tlv_word0.key_type)
                    NO_AUX_KEY:          gcm_dak_cmd_in_nxt.op = PT_KEY_BLOB;
                    AUX_KEY_ONLY:        gcm_dak_cmd_in_nxt.op = PT_CKV;
                    DEK256:              gcm_dak_cmd_in_nxt.op = PT_CKV;
                    DEK512:              gcm_dak_cmd_in_nxt.op = PT_CKV;
                    DAK:                 gcm_dak_cmd_in_nxt.op = PT_KEY_BLOB;
                    DEK256_DAK:          gcm_dak_cmd_in_nxt.op = PT_KEY_BLOB;
                    DEK512_DAK:          gcm_dak_cmd_in_nxt.op = PT_KEY_BLOB;
                    ENC_DEK256:          gcm_dak_cmd_in_nxt.op = PT_CKV;
                    ENC_DEK512:          gcm_dak_cmd_in_nxt.op = PT_CKV;
                    ENC_DAK:             gcm_dak_cmd_in_nxt.op = DECRYPT_DAK;
                    ENC_DEK256_DAK:      gcm_dak_cmd_in_nxt.op = DECRYPT_DAK;
                    ENC_DEK512_DAK:      gcm_dak_cmd_in_nxt.op = DECRYPT_DAK;
                    ENC_DEK256_DAK_COMB: gcm_dak_cmd_in_nxt.op = DECRYPT_DAK_COMB;
                    ENC_DEK512_DAK_COMB: gcm_dak_cmd_in_nxt.op = DECRYPT_DAK_COMB;
                endcase

            end

            if (kme_internal_out.id == KME_DEK_CKV0) begin
                
                gcm_dek_cmd_in_nxt.key0 = {gcm_dek_cmd_in_nxt.key0[191:0], kme_internal_out.tdata};
            end

            if (kme_internal_out.id == KME_DEK_CKV1) begin
                
                gcm_dek_cmd_in_nxt.key1 = {gcm_dek_cmd_in_nxt.key1[191:0], kme_internal_out.tdata};
            end

            if (kme_internal_out.id == KME_DAK_CKV) begin
                
                
                gcm_dak_cmd_in_nxt.key0 = {gcm_dak_cmd_in_nxt.key0[191:0], kme_internal_out.tdata};
                gcm_dak_cmd_in_nxt.key1 = {gcm_dak_cmd_in_nxt.key1[191:0], kme_internal_out.tdata};
            end

            if (kme_internal_out.id == KME_EIV) begin
                
                case (kme_internal_out.eoi)
                    1'b0: gcm_dek_cmd_in_nxt.iv[95:32] = kme_internal_out.tdata;
                    1'b1: gcm_dek_cmd_in_nxt.iv[31:0]  = kme_internal_out.tdata[63:32];
                endcase

                
                if (kme_internal_out.eoi) gcm_cmd_in_valid = 1'b1;
                if (kme_internal_out.eoi) gcm_cmd_in = gcm_dek_cmd_in_nxt;
            end

            if (kme_internal_out.id == KME_AIV) begin
                
                case (kme_internal_out.eoi)
                    1'b0: gcm_dak_cmd_in_nxt.iv[95:32] = kme_internal_out.tdata;
                    1'b1: gcm_dak_cmd_in_nxt.iv[31:0]  = kme_internal_out.tdata[63:32];
                endcase

                
                if (kme_internal_out.eoi) gcm_cmd_in_valid = 1'b1;
                if (kme_internal_out.eoi) gcm_cmd_in = gcm_dak_cmd_in_nxt;
            end

        end

        
        if (kme_internal_out_ack) begin

            if (kme_internal_out.id == KME_ETAG) begin
                
                case (kme_internal_out.eoi)
                    1'b0: gcm_dek_tag_nxt[95:32] = kme_internal_out.tdata;
                    1'b1: gcm_dek_tag_nxt[31:0]  = kme_internal_out.tdata[63:32];
                endcase

                
                if (kme_internal_out.eoi) gcm_tag_data_in_valid = 1'b1;
                if (kme_internal_out.eoi) gcm_tag_data_in = gcm_dek_tag_nxt;
            end

            if (kme_internal_out.id == KME_ATAG) begin
                
                case (kme_internal_out.eoi)
                    1'b0: gcm_dak_tag_nxt[95:32] = kme_internal_out.tdata;
                    1'b1: gcm_dak_tag_nxt[31:0]  = kme_internal_out.tdata[63:32];
                endcase

                
                if (kme_internal_out.eoi) gcm_tag_data_in_valid = 1'b1;
                if (kme_internal_out.eoi) gcm_tag_data_in = gcm_dak_tag_nxt;
            end

        end

        
        if (kme_internal_out_ack) begin
            if (kme_internal_out.id == KME_DEBUG_KEYHDR) begin
                kdf_cmd_in_valid = 1'b1;
                kdf_cmd_in.dek_key_op = key_header.dek_key_op;
                kdf_cmd_in.dak_key_op = key_header.dak_key_op;
                kdf_cmd_in.combo_mode = (key_header.kdf_mode == KDF_MODE_COMB_GUID) | 
                                        (key_header.kdf_mode == KDF_MODE_COMB_RGUID);

                skip_dek_kdf_nxt        = (key_header.dek_key_op == NOOP);
                skip_dak_kdf_nxt        = (key_header.dak_key_op == NOOP);
                kdf_cmd_in.kdf_dek_iter = kdf_dek_iter;

                keyfilter_cmd_in_valid = 1'b1;
                keyfilter_cmd_in.combo_mode = (key_header.kdf_mode == KDF_MODE_COMB_GUID) | 
                                              (key_header.kdf_mode == KDF_MODE_COMB_RGUID);
            end
        end

        
        if (kme_internal_out_ack) begin
            if (kme_internal_out.id == KME_DEBUG_KEYHDR) begin
              stream_cmd_in_nxt       = {$bits(kdfstream_cmd_t){1'b0}};

                
                
                
                
                if ((key_header.kdf_mode == KDF_MODE_GUID) || (key_header.kdf_mode == KDF_MODE_RGUID)) begin
                    stream_cmd_in_nxt.num_iter   = 2'h1 + {1'b0, kdf_dek_iter};                 
                    stream_cmd_in_nxt.combo_mode = 1'b0;
                end
                else begin
                    stream_cmd_in_nxt.num_iter   = 2'h2 + {1'b0, kdf_dek_iter};                 
                    stream_cmd_in_nxt.combo_mode = 1'b1;  
                end

            end

            if (kme_internal_out.id == KME_GUID) begin
                
                stream_cmd_in_nxt.guid = {stream_cmd_in.guid[191:0], kme_internal_out.tdata};
            end

            if (kme_internal_out.id == KME_KIM) begin    
                if (kme_internal_out.eoi == 1'b0) begin  
                    
                    kdfstream_cmd_in_valid = 1'b1;
                    kdfstream_cmd_in = stream_cmd_in;
                    kdfstream_cmd_in.label_index = int_tlv_word8.dek_kim_entry.label_index;

                    
                    if (!stream_cmd_in.combo_mode) begin
                        kdfstream_cmd_in.skip = skip_dek_kdf;  
                    end
                end else begin
                    
                    if (!stream_cmd_in.combo_mode) begin
                        kdfstream_cmd_in_valid = 1'b1;
                        kdfstream_cmd_in = stream_cmd_in;
                        kdfstream_cmd_in.label_index = int_tlv_word9.dak_kim_entry.label_index;
                        kdfstream_cmd_in.num_iter = 2'd1;
                        kdfstream_cmd_in.skip = skip_dak_kdf;
                    end
                end
            end

        end


        
        if (kme_internal_out_ack) begin
            if (kme_internal_out.id == KME_WORD0) begin
                tlv_sb_data_in_valid = 1'b1;
                tlv_sb_data_in = kme_internal_out.tdata;
            end

            if (kme_internal_out.id == KME_GUID) begin
                tlv_sb_data_in_valid = 1'b1;
                tlv_sb_data_in = kme_internal_out.tdata;
            end

            if (kme_internal_out.id == KME_IVTWEAK) begin
                tlv_sb_data_in_valid = 1'b1;
                tlv_sb_data_in = kme_internal_out.tdata;
            end

            if (kme_internal_out.id == KME_ERROR) begin
                tlv_sb_data_in_valid = 1'b1;
                tlv_sb_data_in = int_tlv_word42;
            end
        end

    end

    

    

    reg [1:0] dek_ckv_length_q;
    reg       kek_tag_q;
    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dek_ckv_length_q <= 2'b0;
            kek_tag_q <= 1'b0;
        end else if (kme_internal_out_ack) begin
            if (kme_internal_out.id == KME_KIM) begin
                if (kme_internal_out.eoi == 1'b0) begin
                    dek_ckv_length_q <= int_tlv_word8.dek_kim_entry.ckv_length;
                    kek_tag_q <= int_tlv_word8.pf_num[3];
                end
            end
        end
    end

    

    genvar ii,jj;

    generate
        
        for (ii=0; ii<=7; ii=ii+1) begin : op
            brcm_gcm: `COVER_PROPERTY(gcm_cmd_in_valid & (gcm_cmd_in.op == ii));
        end

        
      brcm_gcm_dek256_with_512bit_key   : `COVER_PROPERTY(gcm_cmd_in_valid & (dek_ckv_length_q == 2) & (gcm_cmd_in.op == DECRYPT_DEK256));
      brcm_gcm_dek512_with_512bit_key   : `COVER_PROPERTY(gcm_cmd_in_valid & (dek_ckv_length_q == 2) & (gcm_cmd_in.op == DECRYPT_DEK512));
      brcm_gcm_dek256dak_with_512bit_key: `COVER_PROPERTY(gcm_cmd_in_valid & (dek_ckv_length_q == 2) & (gcm_cmd_in.op == DECRYPT_DEK256_COMB));
      brcm_gcm_dek512dak_with_512bit_key: `COVER_PROPERTY(gcm_cmd_in_valid & (dek_ckv_length_q == 2) & (gcm_cmd_in.op == DECRYPT_DEK512_COMB));

        
      brcm_gcm_enc_dek256_no_kbk   : `COVER_PROPERTY(gcm_cmd_in_valid & !kek_tag_q & (gcm_cmd_in.op == DECRYPT_DEK256));
      brcm_gcm_enc_dek512_no_kbk   : `COVER_PROPERTY(gcm_cmd_in_valid & !kek_tag_q & (gcm_cmd_in.op == DECRYPT_DEK512));
      brcm_gcm_enc_dek256_comb_no_kbk   : `COVER_PROPERTY(gcm_cmd_in_valid & !kek_tag_q & (gcm_cmd_in.op == DECRYPT_DEK256_COMB));
      brcm_gcm_enc_dek512_comb_no_kbk   : `COVER_PROPERTY(gcm_cmd_in_valid & !kek_tag_q & (gcm_cmd_in.op == DECRYPT_DEK512_COMB));


        
        for (ii=0; ii<=1; ii=ii+1) begin : guid
            for (jj=0; jj<=1; jj=jj+1) begin : delimiter
                brcm_kdf_label0_8  : `COVER_PROPERTY(kdfstream_cmd_in_valid & (labels[kdfstream_cmd_in.label_index].guid_size       == ii) 
                                                                            & (labels[kdfstream_cmd_in.label_index].delimiter_valid == jj)
                                                                            & (labels[kdfstream_cmd_in.label_index].label_size      >= 0 )
                                                                            & (labels[kdfstream_cmd_in.label_index].label_size      <= 8 ));

                brcm_kdf_label9_16 : `COVER_PROPERTY(kdfstream_cmd_in_valid & (labels[kdfstream_cmd_in.label_index].guid_size       == ii) 
                                                                            & (labels[kdfstream_cmd_in.label_index].delimiter_valid == jj)
                                                                            & (labels[kdfstream_cmd_in.label_index].label_size      >= 9 )
                                                                            & (labels[kdfstream_cmd_in.label_index].label_size      <= 16));

                brcm_kdf_label17_24: `COVER_PROPERTY(kdfstream_cmd_in_valid & (labels[kdfstream_cmd_in.label_index].guid_size       == ii) 
                                                                            & (labels[kdfstream_cmd_in.label_index].delimiter_valid == jj)
                                                                            & (labels[kdfstream_cmd_in.label_index].label_size      >= 17)
                                                                            & (labels[kdfstream_cmd_in.label_index].label_size      <= 24));

                brcm_kdf_label25_32: `COVER_PROPERTY(kdfstream_cmd_in_valid & (labels[kdfstream_cmd_in.label_index].guid_size       == ii) 
                                                                            & (labels[kdfstream_cmd_in.label_index].delimiter_valid == jj)
                                                                            & (labels[kdfstream_cmd_in.label_index].label_size      >= 25)
                                                                            & (labels[kdfstream_cmd_in.label_index].label_size      <= 32));
            end
        end

        
        brcm_tlv_sb_stall_on_guid: `COVER_PROPERTY((kme_internal_out.id == KME_GUID) & kme_internal_out_valid & tlv_sb_data_in_stall);


    endgenerate

    

    

endmodule









