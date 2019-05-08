/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











module cr_kme_ckv_reader (
   
   ckvreader_kimreader_ack, ckvreader_kopassigner_valid,
   ckvreader_kopassigner_data, ckv_rd, ckv_addr,
   
   clk, rst_n, kimreader_ckvreader_valid, kimreader_ckvreader_data,
   kopassigner_ckvreader_ack, ckv_dout, ckv_mbe
   );



    `include "cr_kme_body_param.v"

    
    
    
    input clk;
    input rst_n;

    
    
    
    input                   kimreader_ckvreader_valid;
    input  kme_internal_t   kimreader_ckvreader_data;
    output reg              ckvreader_kimreader_ack;

    
    
    
    output reg              ckvreader_kopassigner_valid;
    output kme_internal_t   ckvreader_kopassigner_data;
    input                   kopassigner_ckvreader_ack;

    
    
    
    output reg              ckv_rd;
    output reg [14:0]       ckv_addr;
    input  [63:0]           ckv_dout;
    input                   ckv_mbe;



    typedef enum bit [0:0] {
        PASSTHROUGH   = 1'd0,
        CKV_READS     = 1'd1
    } ckv_reader_fsm;



    ckv_reader_fsm  cur_state;
    ckv_reader_fsm  nxt_state;

    reg ckv_rd_q;
    reg half_dek;

    kme_internal_word_0_t   tlv_word0;
    kme_internal_word_42_t  tlv_word42;

    kme_internal_word_8_t   tlv_word8;
    kme_internal_word_8_t   nxt_tlv_word8;

    kme_internal_word_9_t   tlv_word9;
    kme_internal_word_9_t   nxt_tlv_word9;

    aux_key_ctrl_t          aux_key_ctrl;

    wire        fifo_out_mbe;
    wire [63:0] fifo_out;
    wire        fifo_out_valid;
    reg         fifo_out_ack;
    wire        fifo_in_stall;

    reg         report_kme_error;
    reg   [3:0] ckv_read_num;

    reg ktype_is_aux_key_only;
    reg nxt_ktype_is_aux_key_only;


    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cur_state <= PASSTHROUGH;
            ckv_rd_q  <= 1'b0;
            tlv_word8 <= {$bits(kme_internal_word_8_t){1'b0}};
            tlv_word9 <= {$bits(kme_internal_word_8_t){1'b0}};
            ktype_is_aux_key_only <= 1'b0;
        end else begin
            cur_state <= nxt_state;
            ckv_rd_q  <= ckv_rd;
            tlv_word8 <= nxt_tlv_word8;
            tlv_word9 <= nxt_tlv_word9;
            ktype_is_aux_key_only <= nxt_ktype_is_aux_key_only;
        end
    end

    always @ (*) begin

        nxt_state = cur_state;

        case (cur_state)

            PASSTHROUGH: begin
                
                if (ckvreader_kimreader_ack) begin
                    if (kimreader_ckvreader_data.id == KME_KIM) begin
                        if (kimreader_ckvreader_data.eoi) begin
                            nxt_state = CKV_READS;
                        end
                    end
                end
            end

            CKV_READS: begin
                
                if (kopassigner_ckvreader_ack) begin
                    if (ckvreader_kopassigner_data.id == KME_DAK_CKV) begin
                        if (ckvreader_kopassigner_data.eoi) begin
                            nxt_state = PASSTHROUGH;
                        end
                    end
                end
            end

        endcase

    end

    always @ (*) begin

        fifo_out_ack = 1'b0;
        ckvreader_kimreader_ack = 1'b0;

        ckvreader_kopassigner_valid = 1'b0;
        ckvreader_kopassigner_data  = {$bits(kme_internal_t){1'b0}};

        ckv_rd   = 1'b0;
        half_dek = (tlv_word8.dek_kim_entry.ckv_length == 2'd1);

        nxt_tlv_word8 = tlv_word8;
        nxt_tlv_word9 = tlv_word9;

        nxt_ktype_is_aux_key_only = ktype_is_aux_key_only;

        tlv_word0    = kimreader_ckvreader_data.tdata;
        tlv_word42   = kimreader_ckvreader_data.tdata;
        aux_key_ctrl = kimreader_ckvreader_data.tdata[31:0];

        if (report_kme_error) begin
            tlv_word42.error_code = KME_ECC_FAIL;
        end

        case (cur_state)

            PASSTHROUGH: begin
                
                ckvreader_kopassigner_valid = kimreader_ckvreader_valid;
                ckvreader_kopassigner_data  = kimreader_ckvreader_data;
                ckvreader_kimreader_ack     = kopassigner_ckvreader_ack;

                if (kimreader_ckvreader_valid) begin
                    
                    
                    if (kimreader_ckvreader_data.id == KME_WORD0) nxt_tlv_word8    = {$bits(kme_internal_word_8_t){1'b0}};
                    if (kimreader_ckvreader_data.id == KME_WORD0) nxt_tlv_word9    = {$bits(kme_internal_word_9_t){1'b0}};

                    if ((kimreader_ckvreader_data.id == KME_KIM) & (kimreader_ckvreader_data.eoi == 1'b0)) nxt_tlv_word8 = kimreader_ckvreader_data.tdata;
                    if ((kimreader_ckvreader_data.id == KME_KIM) & (kimreader_ckvreader_data.eoi == 1'b1)) nxt_tlv_word9 = kimreader_ckvreader_data.tdata;

                    
                    if (kimreader_ckvreader_data.id == KME_ERROR) ckvreader_kopassigner_data.tdata = tlv_word42;

                    
                    if (kimreader_ckvreader_data.id == KME_WORD0) nxt_ktype_is_aux_key_only = (tlv_word0.key_type == AUX_KEY_ONLY);
                end
            end

            CKV_READS: begin
                
                ckvreader_kopassigner_valid      = kimreader_ckvreader_valid & fifo_out_valid;
                ckvreader_kopassigner_data       = kimreader_ckvreader_data;
                ckvreader_kimreader_ack          = kopassigner_ckvreader_ack;
                fifo_out_ack                     = kopassigner_ckvreader_ack;

                
                case (kimreader_ckvreader_data.id)
                    KME_DEK_CKV0: if (tlv_word8.dek_kim_entry.ckv_length == 2'd2) ckvreader_kopassigner_data.tdata = (tlv_word8.validate_dek) ? fifo_out : 64'b0;
                    KME_DEK_CKV1: if (tlv_word8.dek_kim_entry.ckv_length != 2'd0) ckvreader_kopassigner_data.tdata = (tlv_word8.validate_dek) ? fifo_out : 64'b0;
                    KME_DAK_CKV : if (tlv_word9.dak_kim_entry.ckv_length != 2'd0) ckvreader_kopassigner_data.tdata = (tlv_word9.validate_dak) ? fifo_out : 64'b0;
                endcase

                
                ckv_rd = (ckv_read_num != 4'd12) & ((fifo_in_stall) ? fifo_out_ack : 1'b1);
            end

        endcase

    end

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ckv_read_num <= 4'd0;
            ckv_addr <= 15'd0;
        end else if (cur_state == PASSTHROUGH) begin
            
            ckv_read_num <= 4'd0;
            ckv_addr <= nxt_tlv_word8.dek_kim_entry.ckv_pointer;
        end else if (ckv_rd) begin
            
            ckv_read_num <= ckv_read_num + 1'b1;

            if (half_dek & (ckv_read_num == 4'd3)) begin
                
                
                
                
                
                
                ckv_addr <= tlv_word8.dek_kim_entry.ckv_pointer;
            end else if (ckv_read_num == 4'd7) begin
                
                ckv_addr <= tlv_word9.dak_kim_entry.ckv_pointer;
            end else begin
                ckv_addr <= ckv_addr + 1'b1;
            end
        end
    end

    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            report_kme_error <= 1'b0;
        end else if (fifo_out_ack) begin
            if (fifo_out_mbe) begin
                report_kme_error <= 1'b1;
            end
        end else if (kopassigner_ckvreader_ack) begin
            if (ckvreader_kopassigner_data.id == KME_ERROR) begin
                report_kme_error <= 1'b0;
            end
        end
    end

    cr_kme_fifo #
    (
        .DATA_SIZE(65),
        .FIFO_DEPTH(2),
        .STALL_AT(1)
    )
    ckv_data_fifo (
        .clk            (clk),
        .rst_n          (rst_n),

        .fifo_in        ({ckv_mbe, ckv_dout}),
        .fifo_in_valid  (ckv_rd_q),
        .fifo_in_stall  (fifo_in_stall),

        .fifo_out       ({fifo_out_mbe, fifo_out}),
        .fifo_out_valid (fifo_out_valid),
        .fifo_out_ack   (fifo_out_ack),

        .fifo_overflow  (),
        .fifo_underflow (),
        .fifo_in_stall_override(1'b0)
    );

    

    

    

    genvar ii;

    generate
        
        for (ii=0; ii<=3; ii=ii+1) begin : ckv_len
            brcm_dek_key: `COVER_PROPERTY(ckvreader_kopassigner_valid & ktype_is_aux_key_only & (ckvreader_kopassigner_data.id == KME_ERROR) & (tlv_word8.dek_kim_entry.ckv_length == ii));
            brcm_dak_key: `COVER_PROPERTY(ckvreader_kopassigner_valid & ktype_is_aux_key_only & (ckvreader_kopassigner_data.id == KME_ERROR) & (tlv_word9.dak_kim_entry.ckv_length == ii));
        end
    endgenerate

    

    


endmodule









