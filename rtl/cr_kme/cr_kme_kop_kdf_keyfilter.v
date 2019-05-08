/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_kop_kdf_keyfilter (
   
   keyfilter_cmdfifo_ack, keyfilter_upsizer_stall, hash_key_in,
   hash_key_in_valid,
   
   clk, rst_n, cmdfifo_keyfilter_valid, cmdfifo_keyfilter_cmd,
   upsizer_keyfilter_data, upsizer_keyfilter_valid,
   upsizer_keyfilter_eof, hash_key_in_stall
   );


    `include "cr_kme_body_param.v"

    
    
    
    input clk;
    input rst_n;

    
    
    
    input                   cmdfifo_keyfilter_valid;
    input  keyfilter_cmd_t  cmdfifo_keyfilter_cmd;
    output reg              keyfilter_cmdfifo_ack;


    
    
    
    input  wire [255:0]     upsizer_keyfilter_data;
    input  wire             upsizer_keyfilter_valid;
    input  wire             upsizer_keyfilter_eof;
    output reg              keyfilter_upsizer_stall;

    
    
    
    output reg  [255:0]     hash_key_in;
    output reg              hash_key_in_valid;
    input  wire             hash_key_in_stall;


    reg [1:0] counter;

    always @ (*) begin

        
        
        

        hash_key_in = 256'b0;
        hash_key_in_valid = 1'b0;
        keyfilter_upsizer_stall = 1'b0;
        keyfilter_cmdfifo_ack = 1'b0;

        if (counter == 2'd1) begin
            hash_key_in = upsizer_keyfilter_data;
            hash_key_in_valid = upsizer_keyfilter_valid;
            keyfilter_upsizer_stall = hash_key_in_stall;
        end

        if (counter == 2'd2) begin

            keyfilter_cmdfifo_ack = upsizer_keyfilter_valid;

            if (cmdfifo_keyfilter_cmd.combo_mode == 1'b0) begin 
                hash_key_in = upsizer_keyfilter_data;
                hash_key_in_valid = upsizer_keyfilter_valid;
                keyfilter_upsizer_stall = hash_key_in_stall;
            end
        end


    end

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 2'd0;
        end else if (upsizer_keyfilter_valid) begin
            case (counter)
                2'd2:    counter <= 2'd0;
                default: counter <= counter + 1'b1;
            endcase
        end
    end

endmodule










 
