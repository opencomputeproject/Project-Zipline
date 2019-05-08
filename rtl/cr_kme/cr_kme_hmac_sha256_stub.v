/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_hmac_sha256_stub (
   
   hash_cmdfifo_ack, hash_keyfifo_ack, hash_len_data_out_ack,
   hash_in_stall, sha_tag_data, sha_tag_valid, sha_tag_last,
   
   clk, rst_n, scan_en, scan_mode, scan_rst_n, cmdfifo_hash_valid,
   cmdfifo_hash_skip, cmdfifo_hash_small_size, keyfifo_hash_data,
   keyfifo_hash_valid, hash_len_data_out, hash_len_data_out_valid,
   in_hash_valid, in_hash_eof, in_hash_eoc, in_hash_num_bytes,
   in_hash_data, sha_tag_stall
   );


    
    
    
    input           clk;
    input           rst_n;

    
    
    
    input         scan_en;
    input         scan_mode;
    input         scan_rst_n;

    
    
    
    input           cmdfifo_hash_valid;
    input           cmdfifo_hash_skip;
    input           cmdfifo_hash_small_size;
    output          hash_cmdfifo_ack;
 
    
    
    
    input   [255:0] keyfifo_hash_data;
    input           keyfifo_hash_valid;
    output          hash_keyfifo_ack;

    
    
    
    input   [31:0]  hash_len_data_out;
    input           hash_len_data_out_valid;
    output          hash_len_data_out_ack;

    
    
    
    input           in_hash_valid;
    input           in_hash_eof;
    input           in_hash_eoc;
    input   [4:0]   in_hash_num_bytes;
    input   [127:0] in_hash_data;
    output          hash_in_stall;

    
    
    
    output  [127:0] sha_tag_data;
    output          sha_tag_valid;
    output          sha_tag_last;
    input           sha_tag_stall;


    assign          hash_cmdfifo_ack = 1'b1;
    assign          hash_keyfifo_ack = 1'b1;
    assign          hash_len_data_out_ack = 1'b1;
    assign          hash_in_stall = 1'b0;
    assign          sha_tag_data = 128'h0;
    assign          sha_tag_valid = sha_tag_stall ? 1'b0 : 1'b1;
    assign          sha_tag_last = 1'b0;


endmodule









