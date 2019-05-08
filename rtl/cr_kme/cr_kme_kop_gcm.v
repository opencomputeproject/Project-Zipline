/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_kop_gcm (
   
   set_gcm_tag_fail_int, gcm_cmdfifo_ack, gcm_upsizer_stall,
   gcm_tag_data_out_ack, gcm_kdf_valid, gcm_kdf_eof, gcm_kdf_data,
   gcm_status_data_in_valid, gcm_status_data_in,
   
   clk, rst_n, cmdfifo_gcm_valid, cmdfifo_gcm_cmd, upsizer_gcm_valid,
   upsizer_gcm_eof, upsizer_gcm_data, gcm_tag_data_out,
   gcm_tag_data_out_valid, kdf_gcm_stall, gcm_status_data_in_stall
   );

    `include "cr_kme_body_param.v"

    
    
    
    input clk;
    input rst_n;

    
    
    
    output set_gcm_tag_fail_int;

    
    
    
    input  wire         cmdfifo_gcm_valid;
    input  gcm_cmd_t    cmdfifo_gcm_cmd;
    output reg          gcm_cmdfifo_ack;

    
    
    
    input  wire         upsizer_gcm_valid;
    input  wire         upsizer_gcm_eof;
    input  wire [127:0] upsizer_gcm_data;
    output reg          gcm_upsizer_stall;

    
    
    
    input  wire  [95:0] gcm_tag_data_out;
    input  wire         gcm_tag_data_out_valid;
    output reg          gcm_tag_data_out_ack;

    
    
    
    output reg          gcm_kdf_valid;
    output reg          gcm_kdf_eof;
    output reg [127:0]  gcm_kdf_data;
    input  wire         kdf_gcm_stall;

    
    
    
    output reg          gcm_status_data_in_valid;
    output gcm_status_t gcm_status_data_in;
    input  wire         gcm_status_data_in_stall;





    typedef enum bit [2:0] {
        SET_KEY, ENCRYPT_0, STREAM_AES_BLKS,
        SEND_LEN, SEND_DUMMY_TAG, SEND_TAG
    } gcm_fsm;

    typedef enum bit [2:0] {
        H_PARAM, COPY_FIFO, FIFO_XOR_AES, 
        MULT_LEN, TAG_COMPARE, TAG_IGNORE
    } post_op;
    
    typedef struct packed {
        post_op           op;  
        logic     [127:0] pt;  
        logic       [0:0] eof; 
    } fifo_entry;
 

    gcm_fsm      cur_state;
    gcm_fsm      nxt_state;

    reg [127:0]  ciph_in;
    reg          ciph_in_vld;
    reg          ciph_in_last;
    wire         ciph_in_stall;

    reg [255:0]  key_in;
    reg          key_in_vld;
    wire         key_in_stall;

    wire [127:0] ciph_out;
    wire         ciph_out_vld;
    reg          ciph_out_stall;
 
    fifo_entry   fifo_in;
    reg          fifo_in_vld;
    wire         fifo_in_stall;

    fifo_entry   fifo_out;
    wire         fifo_out_vld;
    reg          fifo_out_ack;

    reg [127:0]  iv_counter;
    reg   [1:0]  beat_num;

    reg          stream_end;
    reg          ciph_fifo_in_stall;
    reg          combo_dek512, nxt_combo_dek512;

    reg [127:0]  operand_X;
    reg [127:0]  operand_Y;
    reg [127:0]  mult_out;

    reg [127:0]  h_value, nxt_h_value;
    reg [127:0]  auth_tag, nxt_auth_tag;



    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cur_state    <= SET_KEY;
            h_value      <= 128'b0;
            auth_tag     <= 128'b0;
            combo_dek512 <= 1'b0;
        end else begin
            cur_state    <= nxt_state;
            h_value      <= nxt_h_value;
            auth_tag     <= nxt_auth_tag;
            combo_dek512 <= nxt_combo_dek512;
        end
    end

    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            iv_counter <= 128'b0;
        end else if (cur_state == SET_KEY) begin
            
            iv_counter <= {cmdfifo_gcm_cmd.iv, 32'd2};
        end else if (fifo_in_vld) begin
            
            if (fifo_in.op == FIFO_XOR_AES) begin
                iv_counter <= iv_counter + 1'b1;
            end
        end
    end

    
    
    
    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            beat_num <= 2'b0;
        end else if (upsizer_gcm_valid) begin
            if (upsizer_gcm_eof) begin
                beat_num <= 2'b0;
            end else begin
                beat_num <= beat_num + 1'b1;
            end
        end
    end

    
    
    
    always @ (*) begin
    
        nxt_state = cur_state;
    
        case (cur_state)

            SET_KEY:         if (!ciph_in_stall) nxt_state = ENCRYPT_0;
            ENCRYPT_0:       if (fifo_in_vld)    nxt_state = STREAM_AES_BLKS;
            STREAM_AES_BLKS: if (stream_end)     nxt_state = SEND_LEN;

            SEND_LEN: begin
                
                

                if (fifo_in_vld) begin
                    if (cmdfifo_gcm_cmd.op == DECRYPT_DAK_COMB) begin
                        nxt_state = SEND_DUMMY_TAG;
                    end else begin
                        nxt_state = SEND_TAG;
                    end
                end
            end

            SEND_DUMMY_TAG:  if (fifo_in_vld) nxt_state = SEND_TAG;
            SEND_TAG:        if (fifo_in_vld) nxt_state = SET_KEY;

        endcase


    end

    always @ (*) begin

        
        key_in = 256'b0;
        key_in_vld = 1'b0;

        
        ciph_in_vld = 1'b0;
        ciph_in = 128'b0;
        ciph_in_last = 1'b0;

        
        fifo_in_vld = 1'b0;
        fifo_in = {$bits(fifo_entry){1'b0}};

        
        gcm_cmdfifo_ack = 1'b0;
        gcm_upsizer_stall = 1'b1;
        gcm_tag_data_out_ack = 1'b0;

        
        ciph_fifo_in_stall = ciph_in_stall | fifo_in_stall;

        
        stream_end = 1'b0;

        
        nxt_combo_dek512 = combo_dek512;

        case (cur_state)

            SET_KEY: begin
                
                if (cmdfifo_gcm_valid) begin
                    if (!key_in_stall) begin
                        key_in = cmdfifo_gcm_cmd.key1;
                        key_in_vld = 1'b1;
                        nxt_combo_dek512 = 1'b0;
                    end
                end
            end

            ENCRYPT_0: begin
                if (!ciph_fifo_in_stall) begin
                    
                    
                    ciph_in = 128'b0;
                    ciph_in_vld = 1'b1;

                    fifo_in.op = H_PARAM;
                    fifo_in.pt = 128'b0;
                    fifo_in_vld = 1'b1;
                end
            end

            STREAM_AES_BLKS: begin

                gcm_upsizer_stall = ciph_fifo_in_stall;

                if (upsizer_gcm_valid) begin

                    ciph_in_vld = 1'b1;
                    fifo_in_vld = 1'b1;
                    ciph_in = iv_counter;

                    case (cmdfifo_gcm_cmd.op)

                        PT_CKV: begin
                            
                            fifo_in.eof = upsizer_gcm_eof;
                            stream_end  = upsizer_gcm_eof;

                            case (beat_num)
                                2'd0: {fifo_in.op, fifo_in.pt} = {COPY_FIFO, cmdfifo_gcm_cmd.key0[255:128]};
                                2'd1: {fifo_in.op, fifo_in.pt} = {COPY_FIFO, cmdfifo_gcm_cmd.key0[127:0]  };
                                2'd2: {fifo_in.op, fifo_in.pt} = {COPY_FIFO, cmdfifo_gcm_cmd.key1[255:128]};
                                2'd3: {fifo_in.op, fifo_in.pt} = {COPY_FIFO, cmdfifo_gcm_cmd.key1[127:0]  };
                            endcase
                        end

                        PT_KEY_BLOB: begin
                            
                            fifo_in.eof = upsizer_gcm_eof;
                            stream_end  = upsizer_gcm_eof;

                            {fifo_in.op, fifo_in.pt} = {COPY_FIFO, upsizer_gcm_data};
                        end

                        DECRYPT_DEK256,
                        DECRYPT_DEK256_COMB: begin

                            
                            
                            
                            
                            
                            
                            fifo_in.eof     = upsizer_gcm_eof;
                            stream_end      = upsizer_gcm_eof & (cmdfifo_gcm_cmd.op != DECRYPT_DEK256_COMB);
                            gcm_cmdfifo_ack = upsizer_gcm_eof & (cmdfifo_gcm_cmd.op == DECRYPT_DEK256_COMB);

                            case (beat_num)
                                2'd0, 2'd1: {fifo_in.op, fifo_in.pt} = {COPY_FIFO   , 128'b0};
                                2'd2, 2'd3: {fifo_in.op, fifo_in.pt} = {FIFO_XOR_AES, upsizer_gcm_data};
                            endcase
                        end

                        DECRYPT_DEK512, DECRYPT_DAK_COMB,
                        DECRYPT_DEK512_COMB, DECRYPT_DAK: begin

                            fifo_in.eof     = upsizer_gcm_eof;
                            stream_end      = upsizer_gcm_eof & (cmdfifo_gcm_cmd.op != DECRYPT_DEK512_COMB);
                            gcm_cmdfifo_ack = upsizer_gcm_eof & (cmdfifo_gcm_cmd.op == DECRYPT_DEK512_COMB);

                            if (cmdfifo_gcm_cmd.op == DECRYPT_DEK512_COMB) begin
                                nxt_combo_dek512 = upsizer_gcm_eof;
                            end

                            {fifo_in.op, fifo_in.pt} = {FIFO_XOR_AES, upsizer_gcm_data};
                        end

                    endcase

                end
            end

            SEND_LEN: begin
                if (!ciph_fifo_in_stall) begin
                    
                    
                    ciph_in_vld = 1'b1;
                    ciph_in = {iv_counter[127:32], 32'd1};

                    fifo_in_vld = 1'b1;
                    fifo_in.op = MULT_LEN;

                    case (cmdfifo_gcm_cmd.op)
                        DECRYPT_DEK256  : fifo_in.pt = 128'd256;
                        DECRYPT_DEK512  : fifo_in.pt = 128'd512;
                        DECRYPT_DAK     : fifo_in.pt = 128'd256;
                        DECRYPT_DAK_COMB: fifo_in.pt = (combo_dek512) ? 128'd768 : 128'd512;
                        default         : fifo_in.pt = 128'd0;
                    endcase
                end
            end

            SEND_DUMMY_TAG: begin
                if (!ciph_fifo_in_stall) begin
                    if (gcm_tag_data_out_valid) begin
                        
                        
                        ciph_in_vld = 1'b1;
                        ciph_in = 128'b0;

                        fifo_in_vld = 1'b1;
                        fifo_in.op  = TAG_IGNORE;
                        fifo_in.pt  = 128'b0;

                        gcm_tag_data_out_ack = 1'b1;
                    end
                end
            end

            SEND_TAG: begin
                if (!ciph_fifo_in_stall) begin
                    if (gcm_tag_data_out_valid) begin
                        
                        
                        ciph_in_vld = 1'b1;
                        ciph_in_last = 1'b1;
                        ciph_in = 128'b0;

                        fifo_in_vld = 1'b1;
                        fifo_in.pt = {gcm_tag_data_out, 32'b0};

                        case (cmdfifo_gcm_cmd.op)
                            DECRYPT_DEK256  : fifo_in.op = TAG_COMPARE;
                            DECRYPT_DEK512  : fifo_in.op = TAG_COMPARE;
                            DECRYPT_DAK     : fifo_in.op = TAG_COMPARE;
                            DECRYPT_DAK_COMB: fifo_in.op = TAG_COMPARE;
                            default         : fifo_in.op = TAG_IGNORE;
                        endcase

                        gcm_cmdfifo_ack = 1'b1;
                        gcm_tag_data_out_ack = 1'b1;
                    end
                end
            end

        endcase

    end


    
    
    

    
    
    
    
    
    //----------------------------------------------------------------------------------
    // KME_MODIFICATION_NOTE:
    // The AES engine has been replaced by a stub here.
    // User must replace with their own engine to add support for decryption 
    // of encrypted Key Blobs.  See KME spec for more details.  
    //----------------------------------------------------------------------------------
    
    AesSecIStub AesSecI (
        .clk                (clk),
        .rst_n              (rst_n),

        
        .Aes128             (1'b0),
        .Aes192             (1'b0),
        .Aes256             (1'b1),
        .EncryptEn          (1'b1),

        
        .KeyIn              (key_in),
        .KeyInitVldR        (key_in_vld),
        .KeyInitStall       (key_in_stall),

        
        .CiphIn             (ciph_in),
        .CiphInVldR         (ciph_in_vld),
        .CiphInLastR        (ciph_in_last),
        .CiphInStall        (ciph_in_stall),

        
        .AesCiphOutR        (ciph_out),
        .AesCiphOutVldR     (ciph_out_vld),
        .AesCiphOutStall    (ciph_out_stall)
    );

    
    
    
    

    cr_kme_fifo # (.DATA_SIZE($bits(fifo_entry)), .FIFO_DEPTH(16))
    bypass_fifo (
        .clk           (clk),
        .rst_n         (rst_n),

        .fifo_in       (fifo_in),
        .fifo_in_valid (fifo_in_vld),
        .fifo_in_stall (fifo_in_stall),

        .fifo_out      (fifo_out),
        .fifo_out_valid(fifo_out_vld),
        .fifo_out_ack  (fifo_out_ack),

        .fifo_overflow (),
        .fifo_underflow(),
        .fifo_in_stall_override(1'b0)
    );







//----------------------------------------------------------------------------------
// KME_MODIFICATION_NOTE:
// With the AES engine has replaced by a stub here, the Galois Field Multiplier
// is commented out and the mult_out is tied off.
// User must replace with their own engine to add support for decryption 
// of encrypted Key Blobs.  See KME spec for more details.  
//----------------------------------------------------------------------------------

  assign mult_out = 128'h0;   // KME_MODIFICATION_NOTE: Line added to tie off multiplier output

/* -----\/----- EXCLUDED -----\/-----
    // Galois Field Multiplier
    
    Gfm128 multiplier (
        // Outputs
        .GfmDataZ(mult_out),
        // Inputs
        .GfmDataX(operand_X),
        .GfmDataY(operand_Y)
    );
 -----/\----- EXCLUDED -----/\----- */
 
    always @ (*) begin

        ciph_out_stall  = 1'b0;
        fifo_out_ack    = ciph_out_vld;

        operand_X = 128'b0;
        operand_Y = h_value;

        nxt_h_value  = h_value;
        nxt_auth_tag = auth_tag;

        gcm_kdf_valid = 1'b0;
        gcm_kdf_eof = 1'b0;
        gcm_kdf_data = 128'b0;

        gcm_status_data_in_valid = 1'b0;
        gcm_status_data_in = {$bits(gcm_status_t){1'b0}};


        if (fifo_out_vld) begin

            case (fifo_out.op)

                H_PARAM: begin
                    
                    
                    
                    ciph_out_stall = 1'b0;

                    if (ciph_out_vld) begin
                        nxt_h_value  = ciph_out;
                        nxt_auth_tag = 128'b0;
                    end
                end

                COPY_FIFO: begin
                    
                    ciph_out_stall = kdf_gcm_stall;

                    if (ciph_out_vld) begin
                        gcm_kdf_valid = ciph_out_vld;
                        gcm_kdf_eof   = fifo_out.eof;
                        gcm_kdf_data  = fifo_out.pt;
                    end
                end

                FIFO_XOR_AES: begin
                    
                    
                    ciph_out_stall = kdf_gcm_stall;

                    if (ciph_out_vld) begin
                        gcm_kdf_valid = ciph_out_vld;
                        gcm_kdf_eof   = fifo_out.eof;
                        gcm_kdf_data  = fifo_out.pt ^ ciph_out;
                        operand_X     = fifo_out.pt ^ auth_tag;
                        nxt_auth_tag  = mult_out;
                    end
                end

                MULT_LEN: begin
                    
                    ciph_out_stall = 1'b0;

                    if (ciph_out_vld) begin
                        operand_X    = fifo_out.pt ^ auth_tag;
                        nxt_auth_tag = mult_out ^ ciph_out;
                    end
                end

                TAG_COMPARE: begin
                    
                    ciph_out_stall = gcm_status_data_in_stall;

                  
                  
                  
                  
                  
                  
                  //----------------------------------------------------------------------------------
                  // KME_MODIFICATION_NOTE:
                  // With the AES engine stubbed, cannot check the authentication TAG. The TAG mismatch 
                  // comparision logic is disabled by adding the new line below and commenting
                  // out the line that did the check.
                  //----------------------------------------------------------------------------------
                    if (ciph_out_vld) begin
                        gcm_status_data_in_valid        = ciph_out_vld;
                        // gcm_status_data_in.tag_mismatch = (auth_tag[127:32] != fifo_out.pt[127:32]);  // KME_MODIFICATION_NOTE: Line commented out
                       gcm_status_data_in.tag_mismatch = 1'b0;   // KME_MODIFICATION_NOTE: Line added
                    end
                end

                TAG_IGNORE: begin
                    
                    ciph_out_stall = gcm_status_data_in_stall;

                    if (ciph_out_vld) begin
                        gcm_status_data_in_valid        = ciph_out_vld;
                        gcm_status_data_in.tag_mismatch = 1'b0;
                    end
                end

            endcase

        end
    end

    
    assign set_gcm_tag_fail_int = gcm_status_data_in_valid & gcm_status_data_in.tag_mismatch;

endmodule









