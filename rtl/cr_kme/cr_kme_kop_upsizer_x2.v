/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_kop_upsizer_x2 (
   
   upsizer_in_stall, upsizer_out_valid, upsizer_out_eof,
   upsizer_out_data,
   
   clk, rst_n, in_upsizer_valid, in_upsizer_eof, in_upsizer_data,
   out_upsizer_stall
   );

    `include "cr_kme_body_param.v"

    parameter IN_DATA_SIZE = 64;

    
    
    
    input clk;
    input rst_n;

    
    
    
    input                       in_upsizer_valid;
    input                       in_upsizer_eof;
    input  [(IN_DATA_SIZE-1):0] in_upsizer_data;
    output reg                  upsizer_in_stall;

    
    
    
    output reg                              upsizer_out_valid;
    output reg                              upsizer_out_eof;
    output reg  [((IN_DATA_SIZE*2)-1):0]    upsizer_out_data;
    input  wire                             out_upsizer_stall;

    reg send_data;
    reg [(IN_DATA_SIZE-1):0] buffer;

    
    
    
    
    always_ff @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= {IN_DATA_SIZE{1'b0}};
            send_data <= 1'b0;
        end else if (!send_data) begin
            if (in_upsizer_valid) begin
                buffer <= in_upsizer_data;
                send_data <= 1'b1;
            end
        end else if (in_upsizer_valid) begin
            send_data <= 1'b0;
        end
    end

    always @ (*) begin

        upsizer_out_valid       = 1'b0;
        upsizer_out_eof         = 1'b0;
        upsizer_out_data        = {(IN_DATA_SIZE*2){1'b0}};
        upsizer_in_stall = out_upsizer_stall;

        if (!out_upsizer_stall) begin
            if (send_data) begin
                if (in_upsizer_valid) begin
                    upsizer_out_valid = 1'b1;
                    upsizer_out_eof   = in_upsizer_eof;
                    upsizer_out_data  = {buffer, in_upsizer_data};
                end
            end
        end
    end


endmodule









