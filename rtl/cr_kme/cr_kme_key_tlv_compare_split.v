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










module cr_kme_key_tlv_compare_split (
  
  set_key_tlv_miscmp_int, cceip_encrypt_ob_full,
  cceip_encrypt_ob_afull, cceip_validate_ob_full,
  cceip_validate_ob_afull, cceip_ob_wr, cceip_ob_tlv,
  
  clk, rst_n, suppress_key_tlvs, cceip_encrypt_ob_wr,
  cceip_encrypt_ob_tlv, cceip_validate_ob_wr, cceip_validate_ob_tlv,
  cceip_ob_full, cceip_ob_afull
  );


    `include "cr_kme_body_param.v"

    
    
    
    input clk;
    input rst_n;
    input suppress_key_tlvs;

    
    
    
    output set_key_tlv_miscmp_int;

    
    
    
    input                   cceip_encrypt_ob_wr;
    input  tlvp_if_bus_t    cceip_encrypt_ob_tlv;
    output                  cceip_encrypt_ob_full;
    output                  cceip_encrypt_ob_afull;

    
    
    
    input                   cceip_validate_ob_wr;
    input  tlvp_if_bus_t    cceip_validate_ob_tlv;
    output                  cceip_validate_ob_full;
    output                  cceip_validate_ob_afull;

    
    
    
    output reg           [3:0] cceip_ob_wr;
    output tlvp_if_bus_t [3:0] cceip_ob_tlv;
    input  wire          [3:0] cceip_ob_full;
    input  wire          [3:0] cceip_ob_afull;

    typedef enum bit [0:0] {
        KEY_TLV_WORD0 = 1'b0,
        ENGINE_BCAST  = 1'b1
    } split_fsm;

    split_fsm       cur_state, nxt_state;
    reg [1:0]       engine_select, nxt_engine_select;

    tlvp_if_bus_t   encrypt_out;
    wire            encrypt_out_valid;
    reg             encrypt_out_ack;

    tlvp_if_bus_t   validate_out;
    wire            validate_out_valid;
    reg             validate_out_ack;

    tlv_word_0_t    key_tlv_w0;

    reg             tlv_miscmp;
    reg             set_tlv_miscmp;
    reg             clr_tlv_miscmp;

    integer i;
 
    cr_kme_fifo #
    (
        .DATA_SIZE($bits(tlvp_if_bus_t)),
        .FIFO_DEPTH(2)
    )
    encrypt_fifo (
        .clk            (clk),
        .rst_n          (rst_n),

        .fifo_in        (cceip_encrypt_ob_tlv),
        .fifo_in_valid  (cceip_encrypt_ob_wr),
        .fifo_in_stall  (cceip_encrypt_ob_full),

        .fifo_out       (encrypt_out),
        .fifo_out_valid (encrypt_out_valid),
        .fifo_out_ack   (encrypt_out_ack),

        .fifo_overflow  (),
        .fifo_underflow (),
        .fifo_in_stall_override(1'b0)
    );

    cr_kme_fifo #
    (
        .DATA_SIZE($bits(tlvp_if_bus_t)),
        .FIFO_DEPTH(2)
    )
    validate_fifo (
        .clk            (clk),
        .rst_n          (rst_n),

        .fifo_in        (cceip_validate_ob_tlv),
        .fifo_in_valid  (cceip_validate_ob_wr),
        .fifo_in_stall  (cceip_validate_ob_full),

        .fifo_out       (validate_out),
        .fifo_out_valid (validate_out_valid),
        .fifo_out_ack   (validate_out_ack),

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

        nxt_state  = cur_state;

        case (cur_state)

            KEY_TLV_WORD0: begin
                if (encrypt_out_valid) begin
                    nxt_state = ENGINE_BCAST;
                end
            end

            ENGINE_BCAST: begin
                if (encrypt_out_ack) begin
                    if (encrypt_out.eot) begin
                        nxt_state = KEY_TLV_WORD0;
                    end
                end
            end

        endcase

    end

    
    always @ (*) begin

        encrypt_out_ack  = 1'b0;
        validate_out_ack = 1'b0;

        key_tlv_w0 = encrypt_out.tdata;

        for (i=0; i<4; i=i+1) begin
            cceip_ob_wr [i] = 1'b0;
            cceip_ob_tlv[i] = {$bits(tlvp_if_bus_t){1'b0}};
        end

        set_tlv_miscmp = 1'b0;
        clr_tlv_miscmp = 1'b0;

        nxt_engine_select = engine_select;

        case (cur_state)

            KEY_TLV_WORD0: begin

                nxt_engine_select = 2'd0;  // KME_MODIFICATION_NOTE: Line added
// KME_MODIFICATION_NOTE: Lines commented out
/* -----\/----- EXCLUDED -----\/-----
                case (key_tlv_w0.tlv_eng_id)
                    4'd0:    nxt_engine_select = 2'd0;
                    4'd1:    nxt_engine_select = 2'd1;
                    4'd2:    nxt_engine_select = 2'd2;
                    4'd3:    nxt_engine_select = 2'd3;
                endcase
 -----/\----- EXCLUDED -----/\----- */

            end

            ENGINE_BCAST: begin
                if (!cceip_ob_full[engine_select]) begin
                    if (encrypt_out_valid & validate_out_valid) begin
                        encrypt_out_ack  = 1'b1;
                        validate_out_ack = 1'b1;

                        
                        cceip_ob_wr  [engine_select]        = ~suppress_key_tlvs;
                        cceip_ob_tlv [engine_select]        = encrypt_out;
                        cceip_ob_tlv [engine_select].tlast  = encrypt_out.eot;
                        cceip_ob_tlv [engine_select].ordern = `TLVP_ORD_NUM_WIDTH'd1;

                        set_tlv_miscmp = (encrypt_out != validate_out);
                        clr_tlv_miscmp = encrypt_out.eot;

                        if (tlv_miscmp & encrypt_out.eot) begin
                            
                            cceip_ob_tlv[engine_select].tdata = ~encrypt_out.tdata;
                        end
                    end
                end
            end
        endcase
    end

    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tlv_miscmp <= 1'b0;
        end else if (clr_tlv_miscmp) begin
            tlv_miscmp <= 1'b0;
        end else if (set_tlv_miscmp) begin
            tlv_miscmp <= 1'b1;
        end
    end

    assign set_key_tlv_miscmp_int = set_tlv_miscmp;

    
    assign cceip_encrypt_ob_afull  = 1'b0;
    assign cceip_validate_ob_afull = 1'b0;


    

    

    genvar ii;

    generate
        
        for (ii=0; ii<=3; ii=ii+1) begin : engine
            brcm_cceip: `COVER_PROPERTY(encrypt_out_ack & encrypt_out.eot & (engine_select == ii));
        end
    endgenerate

    

endmodule









