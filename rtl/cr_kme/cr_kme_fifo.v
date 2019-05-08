/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_fifo (
   
   fifo_in_stall, fifo_out, fifo_out_valid, fifo_overflow,
   fifo_underflow,
   
   clk, rst_n, fifo_in, fifo_in_valid, fifo_out_ack,
   fifo_in_stall_override
   );

    parameter DATA_SIZE = 10;
    parameter FIFO_DEPTH = 2;
    parameter OVERRIDE_EN = 0;
    parameter STALL_AT = 0;
    
    input clk;
    input rst_n;
    
    input  [DATA_SIZE-1:0] fifo_in;
    input                  fifo_in_valid;
    output                 fifo_in_stall;
    
    output [DATA_SIZE-1:0] fifo_out;
    output                 fifo_out_valid;
    input                  fifo_out_ack;

    output                 fifo_overflow;
    output                 fifo_underflow;
    input                  fifo_in_stall_override;

    wire ren;
    wire empty;
    wire [`LOG_VEC(FIFO_DEPTH+1)] free_slots;

    nx_fifo #
    (
        .DEPTH(FIFO_DEPTH),
        .WIDTH(DATA_SIZE),
        .DATA_RESET(1)

    ) std_fifo (
        .clk        (clk),
        .rst_n      (rst_n),
        .clear      (1'b0),

        .wen        (fifo_in_valid),
        .wdata      (fifo_in),

        .ren        (ren),
        .rdata      (fifo_out),

        .empty      (empty),
        .full       (),

        .underflow  (fifo_underflow),
        .overflow   (fifo_overflow),

        .used_slots (),
        .free_slots (free_slots)
    );

    assign fifo_out_valid = !empty;

    assign ren = fifo_out_valid & fifo_out_ack;


    generate

        case (OVERRIDE_EN)
            0:       assign fifo_in_stall = ({1'b0, free_slots} <= STALL_AT) ;
            default: assign fifo_in_stall = ({1'b0, free_slots} <= STALL_AT) | fifo_in_stall_override;
        endcase

    endgenerate
    

endmodule


