/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_kop_kdf_merger (
   
   kdf_cmdfifo_ack, sha_tag_stall, merger_keyfifo_ack,
   kdf_keybuilder_data, kdf_keybuilder_valid,
   
   clk, rst_n, cmdfifo_kdf_valid, cmdfifo_kdf_cmd, sha_tag_data,
   sha_tag_valid, sha_tag_last, keyfifo_merger_data,
   keyfifo_merger_valid, keybuilder_kdf_stall
   );

    `include "cr_kme_body_param.v"

    
    
    
    input   clk;
    input   rst_n;

    
    
    
    input               cmdfifo_kdf_valid;
    input  kdf_cmd_t    cmdfifo_kdf_cmd;
    output reg          kdf_cmdfifo_ack;

    
    
    
    input  [127:0]      sha_tag_data;
    input               sha_tag_valid;
    input               sha_tag_last;
    output reg          sha_tag_stall;

    
    
    
    input  [127:0]      keyfifo_merger_data;
    input               keyfifo_merger_valid;
    output reg          merger_keyfifo_ack;

    
    
    
    output reg [63:0]   kdf_keybuilder_data;
    output reg          kdf_keybuilder_valid;
    input               keybuilder_kdf_stall;


    reg  [127:0] fifo_in;
    reg          fifo_in_vld;
    wire         fifo_in_stall;

    wire [127:0] fifo_out;
    wire         fifo_out_vld;
    reg          fifo_out_ack;

    reg    [2:0] in_counter;
    reg          out_counter;


    
    
    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            in_counter <= 3'd0;
        end else if (merger_keyfifo_ack) begin
            case (in_counter)
                3'd5:    in_counter <= 3'd0;
                default: in_counter <= in_counter + 1'b1;
            endcase
        end
    end

    
    always @ (*) begin

        fifo_in_vld     = 1'b0;
        sha_tag_stall   = 1'b1;
        fifo_in         = 128'b0;

        kdf_cmdfifo_ack    = 1'b0;
        merger_keyfifo_ack = 1'b0;

        if (cmdfifo_kdf_valid) begin

            case (in_counter)
                
                
                
                
                3'd0, 3'd1: begin
                    
                    if (cmdfifo_kdf_cmd.dek_key_op == NOOP) begin
                        
                        if ((cmdfifo_kdf_cmd.combo_mode) && (cmdfifo_kdf_cmd.kdf_dek_iter)) begin  
                            fifo_in_vld        = sha_tag_valid;
                            sha_tag_stall      = fifo_in_stall;
                            merger_keyfifo_ack = sha_tag_valid;
                            fifo_in            = keyfifo_merger_data;
                        
                        end else if (!fifo_in_stall) begin  
                            fifo_in_vld        = keyfifo_merger_valid;
                            merger_keyfifo_ack = keyfifo_merger_valid;
                            fifo_in            = keyfifo_merger_data;
                        end
                    
                    end else if (cmdfifo_kdf_cmd.kdf_dek_iter) begin
                        fifo_in_vld        = sha_tag_valid;
                        sha_tag_stall      = fifo_in_stall;
                        merger_keyfifo_ack = sha_tag_valid;
                        fifo_in            = sha_tag_data;
                    
                    end else if (!fifo_in_stall) begin
                        fifo_in_vld        = keyfifo_merger_valid;
                        merger_keyfifo_ack = keyfifo_merger_valid;
                        fifo_in            = 128'h0;
                    end
                end

                
                
                
                
                3'd2, 3'd3: begin
                    
                    if (cmdfifo_kdf_cmd.dek_key_op == NOOP) begin
                        
                        if (cmdfifo_kdf_cmd.combo_mode) begin  
                            fifo_in_vld        = sha_tag_valid;
                            sha_tag_stall      = fifo_in_stall;
                            merger_keyfifo_ack = sha_tag_valid;
                            fifo_in            = keyfifo_merger_data;
                        
                        end else if (!fifo_in_stall) begin  
                            fifo_in_vld        = keyfifo_merger_valid;
                            merger_keyfifo_ack = keyfifo_merger_valid;
                            fifo_in            = keyfifo_merger_data;
                        end
                    
                    end else begin
                        fifo_in_vld        = sha_tag_valid;
                        sha_tag_stall      = fifo_in_stall;
                        merger_keyfifo_ack = sha_tag_valid;
                        fifo_in            = sha_tag_data;
                    end
                end

                
                3'd4, 3'd5: begin
                    
                    if (cmdfifo_kdf_cmd.dak_key_op == NOOP) begin
                        
                        if (cmdfifo_kdf_cmd.combo_mode) begin
                            fifo_in_vld        = sha_tag_valid;
                            sha_tag_stall      = fifo_in_stall;
                            merger_keyfifo_ack = sha_tag_valid;
                            fifo_in            = keyfifo_merger_data;
                        end else if (!fifo_in_stall) begin
                            fifo_in_vld        = keyfifo_merger_valid;
                            merger_keyfifo_ack = keyfifo_merger_valid;
                            fifo_in            = keyfifo_merger_data;
                        end
                    end else begin
                        fifo_in_vld        = sha_tag_valid;
                        sha_tag_stall      = fifo_in_stall;
                        merger_keyfifo_ack = sha_tag_valid;
                        fifo_in            = sha_tag_data;
                    end
                end
            endcase

            kdf_cmdfifo_ack = (in_counter == 3'd5) & fifo_in_vld;

        end

    end

    cr_kme_fifo # (.DATA_SIZE(128), .FIFO_DEPTH(3))
    downsizer_fifo (
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


    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_counter <= 1'd0;
        end else if (!keybuilder_kdf_stall) begin
            if (kdf_keybuilder_valid) begin
                out_counter <= ~out_counter;
            end
        end
    end

    
    always @ (*) begin

        kdf_keybuilder_data = 64'b0;
        kdf_keybuilder_valid = 1'b0;
        fifo_out_ack = 1'b0;

        if (!keybuilder_kdf_stall) begin
            if (fifo_out_vld) begin
                kdf_keybuilder_valid = 1'b1;
                kdf_keybuilder_data  = (out_counter == 1'b0) ? fifo_out[127:64] : fifo_out[63:0];
                fifo_out_ack         = (out_counter == 1'b1) ;
            end
        end
    end


endmodule









