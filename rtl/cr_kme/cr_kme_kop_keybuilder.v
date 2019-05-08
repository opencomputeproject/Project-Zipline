/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_kop_keybuilder (
   
   tlv_sb_data_out_ack, keybuilder_kdf_stall, gcm_status_data_out_ack,
   key_tlv_ob_wr, key_tlv_ob_tlv,
   
   clk, rst_n, tlv_sb_data_out, tlv_sb_data_out_valid,
   kdf_keybuilder_data, kdf_keybuilder_valid,
   gcm_status_data_out_valid, gcm_status_data_out, key_tlv_ob_full,
   key_tlv_ob_afull
   );

    `include "cr_kme_body_param.v"

    
    
    
    input clk;
    input rst_n;

    
    
    
    input  [63:0]        tlv_sb_data_out;
    input                tlv_sb_data_out_valid;
    output reg           tlv_sb_data_out_ack;

    
    
    
    input  wire [63:0]   kdf_keybuilder_data;
    input  wire          kdf_keybuilder_valid;
    output reg           keybuilder_kdf_stall;

    
    
    
    input  wire          gcm_status_data_out_valid;
    input  gcm_status_t  gcm_status_data_out;
    output reg           gcm_status_data_out_ack;

    
    
    
    output reg           key_tlv_ob_wr;
    output tlvp_if_bus_t key_tlv_ob_tlv;
    input                key_tlv_ob_full;
    input                key_tlv_ob_afull;




    tlv_word_0_t            key_tlv_word0;
    tlv_key_word19_t        key_tlv_word19;
    tlv_key_word20_t        key_tlv_word20;
    kme_internal_word_0_t   int_tlv_word0;
    kme_internal_word_42_t  int_tlv_word42;
    reg [2:0]               key_tlv_beat_num;

    wire                    init;
    wire                    data_valid;
    wire [31:0]             crc;

    typedef enum bit [2:0] {
        KEY_WORD0,
        KEY_GUID,
        KEY_IVTWEAK,
        KEY_DEK,
        KEY_DAK,
        KEY_ERRORS,
        KEY_CRC
    } key_builder_fsm;


    key_builder_fsm     cur_state;
    key_builder_fsm     nxt_state;

    reg dek_gcm_err, nxt_dek_gcm_err;
    reg dak_gcm_err, nxt_dak_gcm_err;
    reg corrupt_crc, nxt_corrupt_crc;
    reg needs_dek  , nxt_needs_dek;
    reg needs_dak  , nxt_needs_dak;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cur_state <= KEY_WORD0;
            key_tlv_beat_num <= 3'd0;
            dek_gcm_err <= 1'b0;
            dak_gcm_err <= 1'b0;
            corrupt_crc <= 1'b0;
            needs_dek <= 1'b0;
            needs_dak <= 1'b0;
        end else begin
            cur_state <= nxt_state;
            dek_gcm_err <= nxt_dek_gcm_err;
            dak_gcm_err <= nxt_dak_gcm_err;
            corrupt_crc <= nxt_corrupt_crc;
            needs_dek <= nxt_needs_dek;
            needs_dak <= nxt_needs_dak;

            if (cur_state == nxt_state) begin
                if (key_tlv_ob_wr) begin
                    key_tlv_beat_num <= key_tlv_beat_num + 1'd1;
                end
            end else begin
                key_tlv_beat_num <= 3'd0;
            end
        end
    end

    always @ (*) begin

        nxt_state = cur_state;

        case (cur_state)

            KEY_WORD0: begin
                if (key_tlv_ob_wr) begin
                    nxt_state = KEY_GUID;
                end
            end

            KEY_GUID: begin
                if (key_tlv_ob_wr) begin
                    if (key_tlv_beat_num == 3'd3) begin
                        nxt_state = KEY_IVTWEAK;
                    end
                end
            end

            KEY_IVTWEAK: begin
                if (key_tlv_ob_wr) begin
                    if (key_tlv_beat_num == 3'd1) begin
                        nxt_state = KEY_DEK;
                    end
                end
            end

            KEY_DEK: begin
                if (key_tlv_ob_wr) begin
                    if (key_tlv_beat_num == 3'd7) begin
                        nxt_state = KEY_DAK;
                    end
                end
            end

            KEY_DAK: begin
                if (key_tlv_ob_wr) begin
                    if (key_tlv_beat_num == 3'd3) begin
                        nxt_state = KEY_ERRORS;
                    end
                end
            end

            KEY_ERRORS: begin
                if (key_tlv_ob_wr) begin
                    nxt_state = KEY_CRC;
                end
            end

            KEY_CRC: begin
                if (key_tlv_ob_wr) begin
                    nxt_state = KEY_WORD0;
                end
            end


        endcase

    end



    always @ (*) begin

        key_tlv_ob_wr = 1'b0;
        key_tlv_ob_tlv = {$bits(tlvp_if_bus_t){1'b0}};
        tlv_sb_data_out_ack = 1'b0;

        key_tlv_ob_tlv.typen = KEY;
        key_tlv_ob_tlv.ordern = `TLVP_ORD_NUM_WIDTH'd0;
        key_tlv_ob_tlv.tstrb = {`AXI_S_TSTRB_WIDTH{1'b1}};

        int_tlv_word0  = tlv_sb_data_out;
        int_tlv_word42 = tlv_sb_data_out;

        key_tlv_word0               = {$bits(tlv_word_0_t){1'b0}};
        key_tlv_word0.tlv_frame_num = int_tlv_word0.tlv_frame_num;
        key_tlv_word0.tlv_seq_num   = int_tlv_word0.tlv_seq_num;
        key_tlv_word0.tlv_eng_id    = int_tlv_word0.tlv_eng_id;
        key_tlv_word0.tlv_len       = 24'd168;
        key_tlv_word0.tlv_type      = KEY;

        key_tlv_word19 = {$bits(tlv_key_word19_t){1'b0}};
        key_tlv_word20 = {$bits(tlv_key_word20_t){1'b0}};

        gcm_status_data_out_ack = 1'b0;

        keybuilder_kdf_stall = 1'b1;

        nxt_dek_gcm_err = dek_gcm_err;
        nxt_dak_gcm_err = dak_gcm_err;
        nxt_corrupt_crc = corrupt_crc;
        nxt_needs_dek   = needs_dek;
        nxt_needs_dak   = needs_dak;

        if (!key_tlv_ob_full) begin
            case (cur_state)

                KEY_WORD0: begin
                    if (tlv_sb_data_out_valid) begin
                        key_tlv_ob_wr = 1'b1;
                        key_tlv_ob_tlv.sot = 1'b1;
                        key_tlv_ob_tlv.tuser = 2'b01;
                        key_tlv_ob_tlv.tdata = key_tlv_word0;
                        nxt_needs_dek = int_tlv_word0.needs_dek; 
                        nxt_needs_dak = int_tlv_word0.needs_dak; 
                        tlv_sb_data_out_ack = 1'b1;
                    end
                end

                KEY_GUID: begin
                    if (tlv_sb_data_out_valid) begin
                        key_tlv_ob_wr = 1'b1;
                        key_tlv_ob_tlv.tdata = endian_switch(tlv_sb_data_out);
                        tlv_sb_data_out_ack = 1'b1;
                    end
                end

                KEY_IVTWEAK: begin
                    if (tlv_sb_data_out_valid) begin
                        key_tlv_ob_wr = 1'b1;
                        key_tlv_ob_tlv.tdata = tlv_sb_data_out;
                        tlv_sb_data_out_ack = 1'b1;
                    end
                end

                KEY_DEK, KEY_DAK: begin
                    if (gcm_status_data_out_valid) begin
                        if (tlv_sb_data_out_valid) begin
                            keybuilder_kdf_stall    = key_tlv_ob_full;
                            key_tlv_ob_wr           = kdf_keybuilder_valid;
                            gcm_status_data_out_ack = (nxt_state != cur_state);

                            if ((cur_state == KEY_DEK) & (nxt_state != cur_state)) nxt_dek_gcm_err = gcm_status_data_out.tag_mismatch;
                            if ((cur_state == KEY_DAK) & (nxt_state != cur_state)) nxt_dak_gcm_err = gcm_status_data_out.tag_mismatch;

                            
                            
                            if (int_tlv_word42.error_code == NO_ERRORS) begin
                                if (gcm_status_data_out.tag_mismatch == 1'b0) begin
                                    if ((cur_state == KEY_DEK) & needs_dek) key_tlv_ob_tlv.tdata = endian_switch(kdf_keybuilder_data);
                                    if ((cur_state == KEY_DAK) & needs_dak) key_tlv_ob_tlv.tdata = endian_switch(kdf_keybuilder_data);
                                end
                            end
                        end
                    end
                end

                KEY_ERRORS: begin
                    key_tlv_word19.kme_errors = int_tlv_word42.error_code;
                    
                    if (int_tlv_word42.error_code == NO_ERRORS) begin
                        if (dak_gcm_err) key_tlv_word19.kme_errors = KME_DAK_GCM_TAG_FAIL;
                        if (dek_gcm_err) key_tlv_word19.kme_errors = KME_DEK_GCM_TAG_FAIL;
                    end

                    key_tlv_ob_tlv.tdata = key_tlv_word19;
                    key_tlv_ob_wr = 1'b1;
                    tlv_sb_data_out_ack = 1'b1;

                    
                    nxt_corrupt_crc = int_tlv_word42.corrupt_crc32;
                end

                KEY_CRC: begin
                    key_tlv_ob_wr = 1'b1;
                    key_tlv_word20.crc32 = {crc[31:1], (crc[0] ^ corrupt_crc)};
                    key_tlv_ob_tlv.tdata = key_tlv_word20;
                    key_tlv_ob_tlv.eot = 1'b1;
                    key_tlv_ob_tlv.tuser = 2'b10;
                    nxt_dek_gcm_err = 1'b0;
                    nxt_dak_gcm_err = 1'b0;
                    nxt_corrupt_crc = 1'b0;
                end

            endcase
        end
    end


    
    cr_crc #
    (
        .POLYNOMIAL     (32'd`XP10CRC32_POLYNOMIAL),
        .N_CRC_WIDTH    (32),
        .N_DATA_WIDTH   (64)
    )
    crc32 (

        .clk(clk),
        .rst_n(rst_n),

        .data_in(key_tlv_ob_tlv.tdata),
        .data_valid(data_valid),
        .data_vbytes(8'hFF),

        .enable(1'b1),
        .init_value(32'd`XP10CRC32_INIT),
        .init(init),

        .crc(crc)
    );

    
    
    assign init       = key_tlv_ob_wr &  (key_tlv_ob_tlv.sot);
    assign data_valid = key_tlv_ob_wr & ~(key_tlv_ob_tlv.sot|key_tlv_ob_tlv.eot);



endmodule










