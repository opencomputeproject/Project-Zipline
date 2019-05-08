/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_hmac_sha256 (
   
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
    output reg      hash_in_stall;

    
    
    
    output  [127:0] sha_tag_data;
    output          sha_tag_valid;
    output          sha_tag_last;
    input           sha_tag_stall;


    `include "cr_crypto_structs.v"

    



    `ifdef SHOULD_BE_EMPTY
        
        
    `endif


    
    
    wire [127:0]        fifo_hash_data;         
    wire                fifo_hash_eoc;          
    wire                fifo_hash_eof;          
    wire [4:0]          fifo_hash_num_bytes;    
    wire                fifo_hash_penultimate;  
    wire                fifo_hash_valid;        
    wire                hash_cipher_stall;      
    wire                hash_fifo_stall;        
    wire                sha_cmdfifo_ack;        
    wire                sha_fifo_stall;         
    wire                sha_keyfifo_ack;        
    wire                sha_len_data_out_ack;   
    


    reg [127:0] cipher_hash_data;
    reg         cipher_hash_eoc;
    reg         cipher_hash_eof;
    reg [4:0]   cipher_hash_num_bytes;
    reg         cipher_hash_valid;
    hash_cmd_t  cmdfifo_hash_cmd;



    always @ (*) begin

        
        cmdfifo_hash_cmd.auth_mode  = (cmdfifo_hash_skip) ? AUTH_NULL : HMAC_SHA2;
        cmdfifo_hash_cmd.gmac_mode  = 1'b0;
        cmdfifo_hash_cmd.small_size = cmdfifo_hash_small_size;
        cmdfifo_hash_cmd.aad_length = 8'b0;

        
        cipher_hash_data      = in_hash_data;
        cipher_hash_eoc       = in_hash_eoc;
        cipher_hash_eof       = in_hash_eof;
        cipher_hash_num_bytes = in_hash_num_bytes;
        cipher_hash_valid     = in_hash_valid;
        hash_in_stall         = hash_cipher_stall;
    end



    

    
    
    

    cr_crypto_hash_fifo
    hash_fifo (
               
               .hash_cipher_stall       (hash_cipher_stall),
               .fifo_hash_valid         (fifo_hash_valid),
               .fifo_hash_penultimate   (fifo_hash_penultimate),
               .fifo_hash_eof           (fifo_hash_eof),
               .fifo_hash_eoc           (fifo_hash_eoc),
               .fifo_hash_num_bytes     (fifo_hash_num_bytes[4:0]),
               .fifo_hash_data          (fifo_hash_data[127:0]),
               .hash_fifo_overflow      (),                      
               .hash_fifo_underflow     (),                      
               
               .clk                     (clk),
               .rst_n                   (rst_n),
               .cipher_hash_valid       (cipher_hash_valid),
               .cipher_hash_eof         (cipher_hash_eof),
               .cipher_hash_eoc         (cipher_hash_eoc),
               .cipher_hash_num_bytes   (cipher_hash_num_bytes[4:0]),
               .cipher_hash_data        (cipher_hash_data[127:0]),
               .hash_fifo_stall         (hash_fifo_stall));

    

    
    
    

    cr_crypto_hash_sha
    hash_sha (
              
              .hash_cmdfifo_ack         (sha_cmdfifo_ack),       
              .hash_keyfifo_ack         (sha_keyfifo_ack),       
              .hash_len_data_out_ack    (sha_len_data_out_ack),  
              .hash_fifo_stall          (sha_fifo_stall),        
              .sha_tag_data             (sha_tag_data[127:0]),
              .sha_tag_valid            (sha_tag_valid),
              .sha_tag_last             (sha_tag_last),
              .sha256b_fifo_overflow    (),                      
              .sha256b_fifo_underflow   (),                      
              
              .clk                      (clk),
              .rst_n                    (rst_n),
              .scan_en                  (scan_en),
              .scan_mode                (scan_mode),
              .scan_rst_n               (scan_rst_n),
              .cmdfifo_hash_valid       (cmdfifo_hash_valid),
              .cmdfifo_hash_cmd         (cmdfifo_hash_cmd),
              .keyfifo_hash_data        (keyfifo_hash_data[255:0]),
              .keyfifo_hash_valid       (keyfifo_hash_valid),
              .hash_len_data_out        (hash_len_data_out[31:0]),
              .hash_len_data_out_valid  (hash_len_data_out_valid),
              .fifo_hash_valid          (fifo_hash_valid),
              .fifo_hash_eof            (fifo_hash_eof),
              .fifo_hash_eoc            (fifo_hash_eoc),
              .fifo_hash_penultimate    (fifo_hash_penultimate),
              .fifo_hash_num_bytes      (fifo_hash_num_bytes[4:0]),
              .fifo_hash_data           (fifo_hash_data[127:0]),
              .sha_tag_stall            (sha_tag_stall));

    
    
    

    
    
    
    
    
    cr_crypto_hash_glue
    hash_glue (
               
               .hash_cmdfifo_ack        (hash_cmdfifo_ack),
               .hash_keyfifo_ack        (hash_keyfifo_ack),
               .hash_len_data_out_ack   (hash_len_data_out_ack),
               .hash_fifo_stall         (hash_fifo_stall),
               
               .cmdfifo_hash_valid      (cmdfifo_hash_valid),
               .cmdfifo_hash_cmd        (cmdfifo_hash_cmd),
               .keyfifo_hash_valid      (keyfifo_hash_valid),
               .fifo_hash_valid         (fifo_hash_valid),
               .fifo_hash_eoc           (fifo_hash_eoc),
               .fifo_hash_eof           (fifo_hash_eof),
               .sha_cmdfifo_ack         (sha_cmdfifo_ack),
               .gmac_cmdfifo_ack        ({1{1'b0}}),             
               .sha_keyfifo_ack         (sha_keyfifo_ack),
               .gmac_keyfifo_ack        ({1{1'b0}}),             
               .sha_len_data_out_ack    (sha_len_data_out_ack),
               .gmac_len_data_out_ack   ({1{1'b0}}),             
               .sha_fifo_stall          (sha_fifo_stall),
               .gmac_fifo_stall         (1'b1));                  


endmodule









