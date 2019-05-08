/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










`include "ccx_std.vh"

module cr_kme_guid_stitcher (
   
   kme_slv_rd, stitcher_out, stitcher_empty, set_tlv_bip2_error_int,
   
   clk, rst_n, kme_slv_out, kme_slv_aempty, kme_slv_empty,
   stitcher_rd
   );



    `include "cr_kme_body_param.v"

    
    
    
    input clk;
    input rst_n;

    
    
    
    output reg            kme_slv_rd;
    input  axi4s_dp_bus_t kme_slv_out;
    input                 kme_slv_aempty;
    input                 kme_slv_empty;

    
    
    
    input                 stitcher_rd;
    output axi4s_dp_bus_t stitcher_out;
    output reg            stitcher_empty;

    
    
    
    output reg set_tlv_bip2_error_int;


    `CCX_STD_CALC_BIP2(get_bip2, `AXI_S_DP_DWIDTH)

    typedef enum bit [2:0] {
        PASSTHROUGH   = 3'b000,
        AUX_WORD1     = 3'b001,
        AUX_WORD2     = 3'b011,
        BUFFER        = 3'b010,
        GUID_HDR      = 3'b110,
        KEEP_AUX_GUID = 3'b111,
        INSERT_GUID   = 3'b101,
        DRAIN_BUFFER  = 3'b100
    } tlv_fsm;

    tlv_fsm         cur_state;
    tlv_fsm         nxt_state;

    reg             use_aux_guid;
    reg             src_guid_present;

    reg             fifo_in_valid;
    axi4s_dp_bus_t  fifo_in;

    wire            fifo_out_valid;
    axi4s_dp_bus_t  fifo_out;
    reg             fifo_out_ack;

    tlv_rqe_word_0_t tlv_word0;
    tlv_cmd_word_1_t frame_word;

    wire kme_slv_sot  = (kme_slv_out.tuser == 8'd1);
    wire kme_slv_eot  = (kme_slv_out.tuser == 8'd2);

    assign tlv_word0  = kme_slv_out.tdata;
    assign frame_word = kme_slv_out.tdata;

    always @ (*) begin

        set_tlv_bip2_error_int = 1'b0;

        if (kme_slv_rd) begin
            if (kme_slv_sot) begin
                
                set_tlv_bip2_error_int = (get_bip2(kme_slv_out.tdata) != 1'b0);
            end
        end
    end

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cur_state <= PASSTHROUGH;
        end else begin
            cur_state <= nxt_state;
        end
    end


    always @ (*) begin

        nxt_state = cur_state;

        case (cur_state)

            PASSTHROUGH: begin
                if (kme_slv_rd) begin
                    if (tlv_word0.tlv_type != RQE) begin
                        
                        if (kme_slv_sot) begin
                            nxt_state = AUX_WORD1;
                        end
                    end
                end
            end

            AUX_WORD1: begin
                if (kme_slv_rd) begin
                    nxt_state = AUX_WORD2;
                end
            end

            AUX_WORD2: begin
                if (kme_slv_rd) begin
                    if (kme_slv_out.tlast) begin
                        
                        nxt_state = PASSTHROUGH;
                    end else if (kme_slv_eot) begin
                        
                        nxt_state = GUID_HDR;
                    end else if (src_guid_present) begin
                        
                        nxt_state = BUFFER;
                    end else begin
                        
                        nxt_state = PASSTHROUGH;
                    end
                end
            end

            BUFFER: begin
                if (kme_slv_rd) begin
                    if (kme_slv_out.tlast) begin
                        
                        nxt_state = DRAIN_BUFFER;
                    end else if (kme_slv_eot) begin
                        nxt_state = GUID_HDR;
                    end
                end
            end

            GUID_HDR: begin
                if (kme_slv_rd) begin
                    if  (use_aux_guid) begin
                        
                        nxt_state = KEEP_AUX_GUID;
                    end else begin
                        
                        nxt_state = INSERT_GUID;
                    end
                end
            end

            INSERT_GUID: begin
                if (kme_slv_rd) begin
                    if (kme_slv_out.tlast) begin
                        if (fifo_out_valid) begin
                            
                            nxt_state = DRAIN_BUFFER;
                        end else begin
                            
                            nxt_state = PASSTHROUGH;
                        end
                    end
                end
            end

            KEEP_AUX_GUID: begin
                if (kme_slv_rd) begin
                    if (kme_slv_out.tlast) begin
                        if (fifo_out.tuser == 8'd2) begin
                            
                            nxt_state = PASSTHROUGH;
                        end else begin
                            
                            nxt_state = DRAIN_BUFFER;
                        end
                    end
                end
            end


            DRAIN_BUFFER: begin
                if (stitcher_rd) begin
                    if (stitcher_out.tlast) begin
                        nxt_state = PASSTHROUGH;
                    end
                end
            end

        endcase

    end

    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            use_aux_guid <= 1'b0;
            src_guid_present <= 1'b0;
        end else if (cur_state == PASSTHROUGH) begin
            if (kme_slv_sot) begin
                case (tlv_word0.tlv_type)
                    AUX_CMD        : use_aux_guid <= 1'b0;
                    AUX_CMD_IV     : use_aux_guid <= 1'b0;
                    AUX_CMD_GUID   : use_aux_guid <= 1'b1;
                    AUX_CMD_GUID_IV: use_aux_guid <= 1'b1;
                    default        : use_aux_guid <= 1'b0;
                endcase
            end
        end else if (cur_state == AUX_WORD1) begin
            src_guid_present <= (frame_word.src_guid_present == GUID_PRESENT);
        end
    end

    always @ (*) begin

        stitcher_out = {$bits(axi4s_dp_bus_t){1'b0}};
        stitcher_empty = 1'b1;
        kme_slv_rd = 1'b0;

        fifo_in_valid = 1'b0;
        fifo_in = {$bits(axi4s_dp_bus_t){1'b0}};

        fifo_out_ack = 1'b0;

        case (cur_state)

            PASSTHROUGH, AUX_WORD1: begin
                
                stitcher_out = kme_slv_out;
                stitcher_empty = kme_slv_empty;
                kme_slv_rd = stitcher_rd;
            end

            AUX_WORD2: begin
                
                stitcher_out = kme_slv_out;
                stitcher_empty = kme_slv_empty;
                kme_slv_rd = stitcher_rd;

                if (kme_slv_eot) begin
                    if (!kme_slv_out.tlast) begin
                        
                        stitcher_out.tuser = 8'd0;
                        stitcher_out.tlast = 1'b0;
                    end
                end
            end
                        
            BUFFER: begin
                
                fifo_in = kme_slv_out;
                fifo_in_valid = ~kme_slv_empty;
                kme_slv_rd = ~kme_slv_empty;
            end
                
            GUID_HDR: begin
                
                kme_slv_rd = ~kme_slv_empty;
            end

            KEEP_AUX_GUID: begin
                
                stitcher_out = fifo_out;
                stitcher_empty = kme_slv_empty;
                kme_slv_rd = stitcher_rd;
                fifo_out_ack = stitcher_rd;

                if (fifo_out.tuser == 8'd2) begin
                    stitcher_out.tlast = 1'b1;
                end
            end

            INSERT_GUID: begin
                
                stitcher_out = kme_slv_out;
                stitcher_empty = kme_slv_empty;
                kme_slv_rd = stitcher_rd;

                if (fifo_out_valid) begin
                    
                    stitcher_out.tuser = 8'd0;
                    stitcher_out.tlast = 1'b0;
                end
            end

            DRAIN_BUFFER: begin
                stitcher_out = fifo_out;
                stitcher_empty = 1'b0;
                fifo_out_ack = stitcher_rd;

                
                if (fifo_out.tuser == 8'd2) begin
                    stitcher_out.tlast = 1'b1;
                end
            end

        endcase

    end


    cr_kme_fifo #
    (
        .DATA_SIZE($bits(axi4s_dp_bus_t)),
        .FIFO_DEPTH(25)
    )
    aux_cmd_fifo (
        .clk            (clk),
        .rst_n          (rst_n),

        .fifo_in        (fifo_in),
        .fifo_in_valid  (fifo_in_valid),
        .fifo_in_stall  (),

        .fifo_out       (fifo_out),
        .fifo_out_valid (fifo_out_valid),
        .fifo_out_ack   (fifo_out_ack),

        .fifo_overflow  (),
        .fifo_underflow (),
        .fifo_in_stall_override(1'b0)
    );



endmodule









