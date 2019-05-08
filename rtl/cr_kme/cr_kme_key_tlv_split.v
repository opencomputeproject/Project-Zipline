/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_key_tlv_split (
   
   cddip_decrypt_ob_full, cddip_decrypt_ob_afull, cddip_ob_wr,
   cddip_ob_tlv,
   
   clk, rst_n, suppress_key_tlvs, cddip_decrypt_ob_wr,
   cddip_decrypt_ob_tlv, cddip_ob_full, cddip_ob_afull
   );


    `include "cr_kme_body_param.v"

    
    
    
    input clk;
    input rst_n;
    input suppress_key_tlvs;

    
    
    
    input                   cddip_decrypt_ob_wr;
    input  tlvp_if_bus_t    cddip_decrypt_ob_tlv;
    output                  cddip_decrypt_ob_full;
    output                  cddip_decrypt_ob_afull;

    
    
    
    output reg           [3:0] cddip_ob_wr;
    output tlvp_if_bus_t [3:0] cddip_ob_tlv;
    input  wire          [3:0] cddip_ob_full;
    input  wire          [3:0] cddip_ob_afull;

    typedef enum bit [0:0] {
        KEY_TLV_WORD0 = 1'b0,
        ENGINE_BCAST  = 1'b1
    } split_fsm;

    split_fsm       cur_state, nxt_state;
    reg [1:0]       engine_select, nxt_engine_select;

    tlvp_if_bus_t   decrypt_out;
    wire            decrypt_out_valid;
    reg             decrypt_out_ack;

    tlv_word_0_t    key_tlv_w0;

    integer i;

    cr_kme_fifo #
    (
        .DATA_SIZE($bits(tlvp_if_bus_t)),
        .FIFO_DEPTH(2)
    )
    decrypt_fifo (
        .clk            (clk),
        .rst_n          (rst_n),

        .fifo_in        (cddip_decrypt_ob_tlv),
        .fifo_in_valid  (cddip_decrypt_ob_wr),
        .fifo_in_stall  (cddip_decrypt_ob_full),

        .fifo_out       (decrypt_out),
        .fifo_out_valid (decrypt_out_valid),
        .fifo_out_ack   (decrypt_out_ack),

        .fifo_overflow  (),
        .fifo_underflow (),
        .fifo_in_stall_override(1'b0)
    );


    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cur_state <= KEY_TLV_WORD0;
            engine_select <= 2'b0;
        end else begin
            cur_state <= nxt_state;
            engine_select <= nxt_engine_select;
        end
    end

    always @ (*) begin

        key_tlv_w0 = decrypt_out.tdata;
        nxt_state  = cur_state;

        case (cur_state)

            KEY_TLV_WORD0: begin
                if (decrypt_out_valid) begin
                    nxt_state = ENGINE_BCAST;
                end
            end

            ENGINE_BCAST: begin
                if (decrypt_out_ack) begin
                    if (decrypt_out.eot) begin
                        nxt_state = KEY_TLV_WORD0;
                    end
                end
            end

        endcase

    end

    
    always @ (*) begin

        decrypt_out_ack  = 1'b0;

        for (i=0; i<4; i=i+1) begin
            cddip_ob_wr [i] = 1'b0;
            cddip_ob_tlv[i] = {$bits(tlvp_if_bus_t){1'b0}};
        end

        nxt_engine_select = engine_select;

        case (cur_state)

            KEY_TLV_WORD0: begin
                case (key_tlv_w0.tlv_eng_id)
                    4'd4:    nxt_engine_select = 2'd0;
                    4'd5:    nxt_engine_select = 2'd1;
                    4'd6:    nxt_engine_select = 2'd2;
                    4'd7:    nxt_engine_select = 2'd3;
                endcase
            end

            ENGINE_BCAST: begin
                if (!cddip_ob_full[engine_select]) begin
                    if (decrypt_out_valid) begin
                        decrypt_out_ack  = 1'b1;

                        
                        cddip_ob_wr  [engine_select]        = ~suppress_key_tlvs;
                        cddip_ob_tlv [engine_select]        = decrypt_out;
                        cddip_ob_tlv [engine_select].tlast  = decrypt_out.eot;
                        cddip_ob_tlv [engine_select].ordern = `TLVP_ORD_NUM_WIDTH'd1;
                    end
                end
            end

        endcase
    end

    
    assign cddip_decrypt_ob_afull = 1'b0;



    

    

    genvar ii;

    generate
        
        for (ii=0; ii<=3; ii=ii+1) begin : engine
            brcm_cddip: `COVER_PROPERTY(decrypt_out_ack & decrypt_out.eot & (engine_select == ii));
        end
    endgenerate

    

endmodule









