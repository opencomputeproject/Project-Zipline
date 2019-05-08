/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_kop_kdf_stream_pipe (
   
   pipe_valid, pipe_data, pipe_byte_count,
   
   clk, rst_n, cmd_valid, cmd_data_size, cmd_data, pipe_ack,
   pipe_ack_num_bytes
   );



    `include "cr_kme_body_param.v"

    parameter  IN_DATA_SIZE_IN_BYTES = 4;

    localparam IN_DATA_SIZE_IN_BITS  = IN_DATA_SIZE_IN_BYTES * 8;
    localparam LOG_IN_DATA_SIZE      = $clog2(IN_DATA_SIZE_IN_BYTES);

    
    
    
    input clk;
    input rst_n;

    
    
    
    input                            cmd_valid;
    input [LOG_IN_DATA_SIZE-1:0]     cmd_data_size;
    input [IN_DATA_SIZE_IN_BITS-1:0] cmd_data;

    
    
    
    output   [0:0] pipe_valid;
    output [127:0] pipe_data;
    input    [0:0] pipe_ack;
    input    [4:0] pipe_ack_num_bytes;

    
    
    
    output reg [LOG_IN_DATA_SIZE-1:0] pipe_byte_count;


    reg [IN_DATA_SIZE_IN_BITS-1:0] cmd_data_q;


    
    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cmd_data_q      <= {IN_DATA_SIZE_IN_BITS{1'b0}};
            pipe_byte_count <= {LOG_IN_DATA_SIZE{1'b0}};
        end else if (cmd_valid) begin
            cmd_data_q      <= cmd_data;
            pipe_byte_count <= cmd_data_size;
        end else if (pipe_valid) begin
            if (pipe_ack) begin
                cmd_data_q      <= (cmd_data_q << (pipe_ack_num_bytes*8));
                pipe_byte_count <= pipe_byte_count - pipe_ack_num_bytes;
            end
        end
    end

    assign pipe_data  = cmd_data_q[(IN_DATA_SIZE_IN_BITS-1):(IN_DATA_SIZE_IN_BITS-128)];
    assign pipe_valid = (pipe_byte_count != {LOG_IN_DATA_SIZE{1'b0}});

 
endmodule











