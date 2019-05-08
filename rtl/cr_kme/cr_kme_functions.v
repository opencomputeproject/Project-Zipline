/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











function [63:0] endian_switch;
    input [63:0] data;

    endian_switch = {data[7:0], data[15:8], data[23:16], data[31:24], data[39:32], data[47:40], data[55:48], data[63:56]};

endfunction

function [3:0] strb_to_bytes;
    input [7:0] strb;

    case (strb)
        8'b00000001: strb_to_bytes = 4'd1;
        8'b00000011: strb_to_bytes = 4'd2;
        8'b00000111: strb_to_bytes = 4'd3;
        8'b00001111: strb_to_bytes = 4'd4;
        8'b00011111: strb_to_bytes = 4'd5;
        8'b00111111: strb_to_bytes = 4'd6;
        8'b01111111: strb_to_bytes = 4'd7;
        8'b11111111: strb_to_bytes = 4'd8;
        default    : strb_to_bytes = 4'd0;
    endcase

endfunction

function [7:0] bytes_to_strb;
    input [3:0] bytes;

    case (bytes)
        4'd1:    bytes_to_strb = 8'b00000001;
        4'd2:    bytes_to_strb = 8'b00000011;
        4'd3:    bytes_to_strb = 8'b00000111;
        4'd4:    bytes_to_strb = 8'b00001111;
        4'd5:    bytes_to_strb = 8'b00011111;
        4'd6:    bytes_to_strb = 8'b00111111;
        4'd7:    bytes_to_strb = 8'b01111111;
        4'd8:    bytes_to_strb = 8'b11111111;
        default: bytes_to_strb = 8'b0;
    endcase

endfunction


function [6:0] strb_to_bits;
    input [7:0] strb;

    case (strb)
        8'b00000001: strb_to_bits = 7'd8;
        8'b00000011: strb_to_bits = 7'd16;
        8'b00000111: strb_to_bits = 7'd24;
        8'b00001111: strb_to_bits = 7'd32;
        8'b00011111: strb_to_bits = 7'd40;
        8'b00111111: strb_to_bits = 7'd48;
        8'b01111111: strb_to_bits = 7'd56;
        8'b11111111: strb_to_bits = 7'd64;
        default    : strb_to_bits = 7'd0;
    endcase

endfunction

