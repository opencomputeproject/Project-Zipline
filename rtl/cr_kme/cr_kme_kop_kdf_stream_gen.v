/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_kop_kdf_stream_gen (
  
  kdfstream_cmdfifo_ack, cmdfifo_hash_valid, cmdfifo_hash_skip,
  cmdfifo_hash_small_size, hash_len_data_out, hash_len_data_out_valid,
  in_hash_valid, in_hash_eof, in_hash_eoc, in_hash_num_bytes,
  in_hash_data,
  
  clk, rst_n, cmdfifo_kdfstream_valid, cmdfifo_kdfstream_cmd, labels,
  hash_cmdfifo_ack, hash_len_data_out_ack, hash_in_stall,
  kdf_test_key_size, kdf_test_mode_en
  );

    `include "cr_kme_body_param.v"

    
    
    
    input           clk;
    input           rst_n;

    
    
    
    input                   cmdfifo_kdfstream_valid;
    input  kdfstream_cmd_t  cmdfifo_kdfstream_cmd;
    output reg              kdfstream_cmdfifo_ack;

    
    
    
    input label_t [7:0]     labels;
 
    
    
    
    output reg              cmdfifo_hash_valid;
    output reg              cmdfifo_hash_skip;
    output reg              cmdfifo_hash_small_size;
    input                   hash_cmdfifo_ack;
 
    
    
    
    output reg [31:0]       hash_len_data_out;
    output reg              hash_len_data_out_valid;
    input                   hash_len_data_out_ack;

    
    
    
    output reg              in_hash_valid;
    output reg              in_hash_eof;
    output reg              in_hash_eoc;
    output reg  [4:0]       in_hash_num_bytes;
    output reg  [127:0]     in_hash_data;
    input  wire             hash_in_stall;

    
    
    
    input [31:0]            kdf_test_key_size;
    input                   kdf_test_mode_en;

    
    reg          cmd_il_valid;
    reg    [5:0] cmd_il_data_size;
    reg  [287:0] cmd_il_data;

    reg          cmd_dgl_valid;
    reg    [5:0] cmd_dgl_data_size;
    reg  [295:0] cmd_dgl_data;
 
    wire   [0:0] pipe_array_valid        [1:0];
    wire [127:0] pipe_array_data         [1:0];
    reg    [0:0] pipe_array_ack          [1:0];
    reg    [4:0] pipe_array_ack_num_bytes[1:0];
    wire   [5:0] pipe_array_byte_count   [1:0];

    typedef enum logic [1:0] {
        IDLE    = 2'd0,
        TX_DATA = 2'd1,
        ITERATE = 2'd2
    } stream_fsm;

    stream_fsm  cur_state;
    stream_fsm  nxt_state;

    reg   [1:0] iter_num;
    reg   [6:0] num_bytes_remaining;
    reg   [4:0] num_bytes_to_tx;

    reg   [4:0] in_hash_byte_accumulator;

    reg  [33:0] hash_cmd_in;
    reg   [0:0] hash_cmd_in_valid;
    wire  [0:0] hash_cmd_in_stall;

    wire [33:0] fifo_out;
    wire  [0:0] fifo_out_valid;
    wire  [0:0] fifo_out_ack;

    wire  [31:0] iter1_kdf_key_size;
    wire  [31:0] iter2_kdf_key_size;
    wire  [31:0] iter3_kdf_key_size;

    integer i;


    
    
    

    
    
    
    cr_kme_kop_kdf_stream_pipe # (.IN_DATA_SIZE_IN_BYTES(36))
    il_var (
        .clk                (clk),
        .rst_n              (rst_n),

        .cmd_valid          (cmd_il_valid),
        .cmd_data_size      (cmd_il_data_size),
        .cmd_data           (cmd_il_data),

        .pipe_valid         (pipe_array_valid        [0]),
        .pipe_data          (pipe_array_data         [0]),
        .pipe_ack           (pipe_array_ack          [0]),
        .pipe_ack_num_bytes (pipe_array_ack_num_bytes[0]),
        .pipe_byte_count    (pipe_array_byte_count   [0])
    );

    
    
    
    
    cr_kme_kop_kdf_stream_pipe # (.IN_DATA_SIZE_IN_BYTES(37))
    dgl_var (
        .clk                (clk),
        .rst_n              (rst_n),

        .cmd_valid          (cmd_dgl_valid),
        .cmd_data_size      (cmd_dgl_data_size),
        .cmd_data           (cmd_dgl_data),

        .pipe_valid         (pipe_array_valid        [1]),
        .pipe_data          (pipe_array_data         [1]),
        .pipe_ack           (pipe_array_ack          [1]),
        .pipe_ack_num_bytes (pipe_array_ack_num_bytes[1]),
        .pipe_byte_count    (pipe_array_byte_count   [1])
    );




    wire        st_tx_data        = (cur_state == TX_DATA);
    wire        program_pipes     = (cur_state != TX_DATA);
    wire        moving_to_tx_data = (cur_state != TX_DATA) & (nxt_state == TX_DATA);
    wire        is_small_size     = (cmd_il_data_size + cmd_dgl_data_size) <= 7'd64;
    wire [31:0] total_hash_size   = (cmd_il_data_size + cmd_dgl_data_size);




    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cur_state <= IDLE;
        end else begin
            cur_state <= nxt_state;
        end
    end


    
    always @ (*) begin

        nxt_state = cur_state;

        case (cur_state)

            IDLE: begin
                
                
                if (!hash_cmd_in_stall) begin
                    if (cmdfifo_kdfstream_valid) begin
                        nxt_state = TX_DATA;
                    end
                end
            end

            TX_DATA: begin
                
                
                if (in_hash_eof) nxt_state = ITERATE;
                if (in_hash_eoc) nxt_state = IDLE;
            end

            ITERATE: begin
                
                if (!hash_cmd_in_stall) begin
                    nxt_state = TX_DATA;
                end
            end

        endcase

    end

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            iter_num      <= 2'd0;
        end else begin
            
            
            if (nxt_state == IDLE) begin
                iter_num      <= 2'd1;
            end else if (in_hash_eof) begin
                iter_num <= iter_num + 2'd1;
            end
        end
    end

    
    assign iter1_kdf_key_size  = kdf_test_mode_en ? kdf_test_key_size : 32'd256;
    assign iter2_kdf_key_size  = kdf_test_mode_en ? kdf_test_key_size : 32'd512;
    assign iter3_kdf_key_size  = kdf_test_mode_en ? kdf_test_key_size : 32'd768;

    always @ (*) begin

        cmd_il_valid     = 1'b0;
        cmd_il_data_size = 6'd0;
        cmd_il_data      = 288'b0;

        cmd_dgl_valid     = 1'b0;
        cmd_dgl_data_size = 6'd0;
        cmd_dgl_data      = 296'b0;

        
        hash_cmd_in[0]        = is_small_size;
        hash_cmd_in[33]       = cmdfifo_kdfstream_cmd.skip;
        hash_cmd_in[32:1]     = {total_hash_size[28:0], 3'b000} + 10'd512;
        hash_cmd_in_valid     = moving_to_tx_data;
        kdfstream_cmdfifo_ack = in_hash_eoc;

        

        if (!st_tx_data) begin
            
            cmd_il_valid     = 1'b1;
            cmd_il_data_size = 3'd4 + (labels[cmdfifo_kdfstream_cmd.label_index].label_size);
            cmd_il_data      = {30'b0, iter_num, labels[cmdfifo_kdfstream_cmd.label_index].label};  

            
            cmd_dgl_valid     = 1'b1;
            cmd_dgl_data_size = ((labels[cmdfifo_kdfstream_cmd.label_index].delimiter_valid) ? 1'd1  : 1'd0 ) +
                                ((labels[cmdfifo_kdfstream_cmd.label_index].guid_size      ) ? 6'd32 : 6'd16) + 3'd4;

            
            if (labels[cmdfifo_kdfstream_cmd.label_index].guid_size) begin
                case (cmdfifo_kdfstream_cmd.num_iter)  
                    2'd1: cmd_dgl_data = {cmdfifo_kdfstream_cmd.guid, iter1_kdf_key_size, 8'b0};
                    2'd2: cmd_dgl_data = {cmdfifo_kdfstream_cmd.guid, iter2_kdf_key_size, 8'b0};
                    2'd3: cmd_dgl_data = {cmdfifo_kdfstream_cmd.guid, iter3_kdf_key_size, 8'b0};
                endcase
            end else begin
                case (cmdfifo_kdfstream_cmd.num_iter) 
                    2'd1: cmd_dgl_data = {cmdfifo_kdfstream_cmd.guid[127:0], iter1_kdf_key_size, 136'b0};
                    2'd2: cmd_dgl_data = {cmdfifo_kdfstream_cmd.guid[127:0], iter2_kdf_key_size, 136'b0};
                    2'd3: cmd_dgl_data = {cmdfifo_kdfstream_cmd.guid[127:0], iter3_kdf_key_size, 136'b0};
                endcase
            end

            
            if (labels[cmdfifo_kdfstream_cmd.label_index].delimiter_valid) begin
                cmd_dgl_data[287:0]   = cmd_dgl_data[295:8];
                cmd_dgl_data[295:288] = labels[cmdfifo_kdfstream_cmd.label_index].delimiter;
            end

        end

    end

    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            num_bytes_remaining <= 7'd0;
        end else if (program_pipes) begin
            num_bytes_remaining <= total_hash_size[6:0];
        end else if (st_tx_data) begin
            num_bytes_remaining <= num_bytes_remaining - in_hash_num_bytes;
        end
    end


    always @ (*) begin

        in_hash_valid     = 1'b0;
        in_hash_eof       = 1'b0;
        in_hash_eoc       = 1'b0;
        in_hash_num_bytes = 5'b0;
        num_bytes_to_tx   = 5'd0;


        for (i=0; i < 2; i=i+1) begin
            pipe_array_ack          [i] = 1'b0;
            pipe_array_ack_num_bytes[i] = 5'b0;
        end

        if (st_tx_data) begin

            if (!hash_in_stall) begin

                
                
                in_hash_valid     = 1'b1;
                in_hash_eof       = (num_bytes_remaining <= 7'd16);
                in_hash_eoc       = in_hash_eof & (iter_num == cmdfifo_kdfstream_cmd.num_iter);
                in_hash_num_bytes = in_hash_eof ? num_bytes_remaining[4:0] : 5'd16;

                if (num_bytes_remaining < 7'd16) begin
                    num_bytes_to_tx = num_bytes_remaining[4:0];
                end else begin
                    num_bytes_to_tx = 5'd16;
                end

                
                for (i=0; i < 2; i=i+1) begin
                    if (num_bytes_to_tx != 5'b0) begin
                        if (pipe_array_valid[i]) begin
                            if ({1'b0, num_bytes_to_tx} >= pipe_array_byte_count[i]) begin
                                pipe_array_ack          [i] = 1'b1;
                                pipe_array_ack_num_bytes[i] = pipe_array_byte_count[i][4:0];
                                num_bytes_to_tx             = num_bytes_to_tx - pipe_array_byte_count[i][4:0];
                            end else begin
                                pipe_array_ack          [i] = 1'b1;
                                pipe_array_ack_num_bytes[i] = num_bytes_to_tx;
                                num_bytes_to_tx             = 5'b0;
                            end
                        end
                    end
                end
            end
        end
    end


    
    always @ (*) begin
        in_hash_data = 128'b0;
        in_hash_byte_accumulator = 5'd0;
 
        for (i=0; i < 2; i=i+1) begin
            if (pipe_array_ack[i]) begin
                in_hash_data             = in_hash_data | (get_msb_bytes(pipe_array_data[i], pipe_array_ack_num_bytes[i]) >> (in_hash_byte_accumulator*8));  
                in_hash_byte_accumulator = in_hash_byte_accumulator + pipe_array_ack_num_bytes[i];
            end
        end
    end


    cr_kme_fifo #
    (
        .DATA_SIZE(34),
        .FIFO_DEPTH(2)
    )
    parser_fifo (
        .clk            (clk),
        .rst_n          (rst_n),

        .fifo_in        (hash_cmd_in),
        .fifo_in_valid  (hash_cmd_in_valid),
        .fifo_in_stall  (hash_cmd_in_stall),

        .fifo_out       (fifo_out),
        .fifo_out_valid (fifo_out_valid),
        .fifo_out_ack   (fifo_out_ack),

        .fifo_overflow  (),
        .fifo_underflow (),
        .fifo_in_stall_override(1'b0)
    );

    assign cmdfifo_hash_valid      = fifo_out_valid;
    assign cmdfifo_hash_skip       = fifo_out[33];
    assign cmdfifo_hash_small_size = fifo_out[0];

    assign hash_len_data_out_valid = fifo_out_valid;
    assign hash_len_data_out       = fifo_out[32:1];

    
    
    
    assign fifo_out_ack = hash_cmdfifo_ack;



    function  [127:0] get_msb_bytes;
        input [127:0] data;
        input [4:0]   num_bytes;
        begin
            
            get_msb_bytes = data & ~({128{1'b1}} >> (num_bytes*8));
        end
    endfunction


endmodule











