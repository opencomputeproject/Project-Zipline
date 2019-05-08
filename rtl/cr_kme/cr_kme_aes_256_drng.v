/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_aes_256_drng (
    
    output  reg      seed_expired,
    output           drng_valid,
    output  [127:0]  drng_256_out,
    output           drng_fifo_overflow,
    output           drng_fifo_underflow,
    output  reg      drng_idle,
    
    input            start,
    input   [383:0]  seed,
    input    [47:0]  seed_life,
    input            drng_ack,
    input            clk,
    input            rst_n
);

    typedef enum bit [1:0] {
        SEED_EXPIRED = 2'd0,
        SET_KEY      = 2'd1,
        SEND_BLKS    = 2'd2,
        RESULT       = 2'd3
    } drng_fsm;
    
    drng_fsm    cur_state;
    drng_fsm    nxt_state;

    reg  [127:0] CiphIn;
    reg          CiphInVldR;
    reg          CiphInLastR;
    wire         CiphInStall;

    reg          KeyInVld;
    reg  [255:0] KeyIn;
    wire         KeyInStall;

    reg  [127:0] AesCiphOutR;
    reg          AesCiphOutVldR;

    reg          fifo_in_valid;
    reg  [127:0] fifo_in;
    wire         fifo_in_stall;

    wire [127:0] fifo_out;

    reg   [47:0] reseed_counter;
    reg   [47:0] reseed_counter_limit;

    reg  [255:0] internal_state_key;
    reg  [127:0] internal_state_value;

    reg    [2:0] in_count;
    reg    [2:0] out_count;



    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cur_state <= SEED_EXPIRED;
        end else begin
            cur_state <= nxt_state;
        end
    end

    always @ (*) begin
    
        nxt_state = cur_state;

        case (cur_state)

            SEED_EXPIRED: begin
                if (start) begin
                    nxt_state = SET_KEY;
                end
            end

            SET_KEY: begin
                if (!KeyInStall) begin
                    nxt_state = SEND_BLKS;
                end
            end

            SEND_BLKS: begin
                if (CiphInLastR) begin
                    nxt_state = RESULT;
                end
            end

            RESULT: begin
                if (out_count == 3'd4) begin
                    if (reseed_counter_limit == reseed_counter) begin
                        nxt_state = SEED_EXPIRED;
                    end else begin
                        nxt_state = SET_KEY;
                    end
                end
            end

        endcase
    
    end

    always @ (*) begin

        CiphIn = 128'b0;
        CiphInVldR = 1'b0;
        CiphInLastR = 1'b0;

        KeyInVld = 1'b0;
        KeyIn = 256'b0;

        fifo_in_valid = 1'b0;
        fifo_in = 128'b0;

        seed_expired = (nxt_state == SEED_EXPIRED);
        drng_idle    = (nxt_state == SEED_EXPIRED);

        if (cur_state == SET_KEY) begin
            if (!KeyInStall) begin
                KeyInVld = 1'b1;
                KeyIn    = internal_state_key;
            end
        end

        if (cur_state == SEND_BLKS) begin
            if (!CiphInStall) begin
                if ((in_count == 3'd0) | (in_count == 3'd1)) begin
                    
                    
                    if (!fifo_in_stall) begin
                        CiphInVldR  = 1'b1;
                        CiphInLastR = 1'b0;
                        CiphIn      = internal_state_value + in_count;
                    end else begin
                        drng_idle = 1'b1;
                    end
                end else begin
                    
                    CiphInVldR  = 1'b1;
                    CiphInLastR = (in_count == 3'd4);
                    CiphIn      = internal_state_value + in_count;
                end
            end
        end

        if (cur_state == RESULT) begin
            if (AesCiphOutVldR) begin
                if ((out_count == 3'd0) | (out_count == 3'd1)) begin
                    fifo_in_valid = 1'b1;
                    fifo_in = AesCiphOutR;
                end
            end
        end

    end

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reseed_counter <= 48'b0;
            reseed_counter_limit <= 48'b0;
        end else if (cur_state == SEED_EXPIRED) begin
            reseed_counter <= 48'b0;
            reseed_counter_limit <= seed_life;
        end else if (CiphInLastR) begin
            reseed_counter <= reseed_counter + 1'b1;
        end
    end    

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            internal_state_key <= 256'b0;
        end else if (cur_state == SEED_EXPIRED) begin
            internal_state_key <= seed[383:128];
        end else if (AesCiphOutVldR) begin
            if (out_count == 3'd2) internal_state_key[255:128] <= AesCiphOutR;
            if (out_count == 3'd3) internal_state_key[127:0]   <= AesCiphOutR;
        end
    end

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            internal_state_value <= 128'b0;
        end else if (cur_state == SEED_EXPIRED) begin
            internal_state_value <= seed[127:0];
        end else if (KeyInVld) begin
            internal_state_value <= internal_state_value + 1'b1;
        end else if (AesCiphOutVldR) begin
            if (out_count == 3'd4) internal_state_value <= AesCiphOutR;
        end
    end

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            in_count  <= 3'b0;
            out_count <= 3'b0;
        end else if (cur_state == SET_KEY) begin
            in_count  <= 3'b0;
            out_count <= 3'b0;
        end else begin
            if (CiphInVldR)     in_count  <= (in_count  == 3'd4) ? 3'd0 : (in_count  + 1'b1);
            if (AesCiphOutVldR) out_count <= (out_count == 3'd4) ? 3'd0 : (out_count + 1'b1);
        end
    end
    
    //----------------------------------------------------------------------------------
    // KME_MODIFICATION_NOTE:
    // The AES engine has been replaced by a stub here that will always set the
    // random GUID to 0x0. 
    // User must replace this stub with their own engine to add the Random GUID feature using a  
    // DRNG (Deterministic Random Number Generator).  See KME spec for more details.  
    //----------------------------------------------------------------------------------
    AesSecIStub AesSecIStub (
        .clk                (clk),
        .rst_n              (rst_n),

        
        .Aes128             (1'b0),
        .Aes192             (1'b0),
        .Aes256             (1'b1),
        .EncryptEn          (1'b1),

        
        .KeyIn              (KeyIn),
        .KeyInitVldR        (KeyInVld),
        .KeyInitStall       (KeyInStall),

        
        .CiphIn             (CiphIn),
        .CiphInVldR         (CiphInVldR),
        .CiphInLastR        (CiphInLastR),
        .CiphInStall        (CiphInStall),

        
        .AesCiphOutR        (AesCiphOutR),
        .AesCiphOutVldR     (AesCiphOutVldR),
        .AesCiphOutStall    (1'b0)
    );

    cr_kme_fifo # (.DATA_SIZE(128), .FIFO_DEPTH(6))
    rnd_fifo (
        .clk           (clk),
        .rst_n         (rst_n),

        .fifo_in       (fifo_in),
        .fifo_in_valid (fifo_in_valid),
        .fifo_in_stall (fifo_in_stall),

        .fifo_out      (fifo_out),
        .fifo_out_valid(drng_valid),
        .fifo_out_ack  (drng_ack),

        .fifo_overflow (drng_fifo_overflow),
        .fifo_underflow(drng_fifo_underflow),
        .fifo_in_stall_override(1'b0)
    );

    assign drng_256_out = fifo_out;

endmodule

