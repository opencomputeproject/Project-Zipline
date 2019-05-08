/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_kop_kdf (
  
  keyfilter_cmdfifo_ack, kdf_cmdfifo_ack, kdfstream_cmdfifo_ack,
  kdf_gcm_stall, kdf_keybuilder_data, kdf_keybuilder_valid,
  
  clk, rst_n, scan_en, scan_mode, scan_rst_n, labels,
  cmdfifo_keyfilter_valid, cmdfifo_keyfilter_cmd, cmdfifo_kdf_valid,
  cmdfifo_kdf_cmd, cmdfifo_kdfstream_valid, cmdfifo_kdfstream_cmd,
  gcm_kdf_valid, gcm_kdf_eof, gcm_kdf_data, keybuilder_kdf_stall,
  kdf_test_key_size, kdf_test_mode_en
  );

    `include "cr_kme_body_param.v"

    
    
    
    input   clk;
    input   rst_n;

    
    
    
    input scan_en;
    input scan_mode;
    input scan_rst_n;

    
    
    
    input label_t [7:0] labels;
 
    
    
    
    input                   cmdfifo_keyfilter_valid;
    input  keyfilter_cmd_t  cmdfifo_keyfilter_cmd;
    output                  keyfilter_cmdfifo_ack;

    
    
    
    input                   cmdfifo_kdf_valid;
    input  kdf_cmd_t        cmdfifo_kdf_cmd;
    output                  kdf_cmdfifo_ack;

    
    
    
    input                   cmdfifo_kdfstream_valid;
    input  kdfstream_cmd_t  cmdfifo_kdfstream_cmd;
    output                  kdfstream_cmdfifo_ack;

    
    
    
    input                   gcm_kdf_valid;
    input                   gcm_kdf_eof;
    input   [127:0]         gcm_kdf_data;
    output                  kdf_gcm_stall;

    
    
    
    output  [63:0]          kdf_keybuilder_data;
    output                  kdf_keybuilder_valid;
    input                   keybuilder_kdf_stall;

    
    
    
    input [31:0]            kdf_test_key_size;
    input                   kdf_test_mode_en;


    



    `ifdef SHOULD_BE_EMPTY
        
        
    `endif



    
    
    wire                cmdfifo_hash_skip;      
    wire                cmdfifo_hash_small_size;
    wire                cmdfifo_hash_valid;     
    wire                hash_cmdfifo_ack;       
    wire                hash_in_stall;          
    wire [255:0]        hash_key_in;            
    wire                hash_key_in_stall;      
    wire                hash_key_in_valid;      
    wire                hash_keyfifo_ack;       
    wire [31:0]         hash_len_data_out;      
    wire                hash_len_data_out_ack;  
    wire                hash_len_data_out_valid;
    wire [127:0]        in_hash_data;           
    wire                in_hash_eoc;            
    wire                in_hash_eof;            
    wire [4:0]          in_hash_num_bytes;      
    wire                in_hash_valid;          
    wire [255:0]        keyfifo_hash_data;      
    wire                keyfifo_hash_valid;     
    wire                keyfifo_in_stall;       
    wire [127:0]        keyfifo_merger_data;    
    wire                keyfifo_merger_valid;   
    wire                keyfilter_upsizer_stall;
    wire                merger_keyfifo_ack;     
    wire [127:0]        sha_tag_data;           
    wire                sha_tag_last;           
    wire                sha_tag_stall;          
    wire                sha_tag_valid;          
    wire                upsizer_in_stall;       
    wire [255:0]        upsizer_keyfilter_data; 
    wire                upsizer_keyfilter_eof;  
    wire                upsizer_keyfilter_valid;
    



    
    
    

    assign kdf_gcm_stall = upsizer_in_stall | keyfifo_in_stall;



    


    
    
    
    cr_kme_fifo #
        (
        
        .DATA_SIZE(128),
        .FIFO_DEPTH(4)
        )
    gcm_key_fifo (
                  
                  .fifo_in_stall        (keyfifo_in_stall),      
                  .fifo_out             (keyfifo_merger_data[127:0]), 
                  .fifo_out_valid       (keyfifo_merger_valid),  
                  .fifo_overflow        (),                      
                  .fifo_underflow       (),                      
                  
                  .clk                  (clk),
                  .rst_n                (rst_n),
                  .fifo_in              (gcm_kdf_data[127:0]),   
                  .fifo_in_valid        (gcm_kdf_valid),         
                  .fifo_out_ack         (merger_keyfifo_ack),    
                  .fifo_in_stall_override(1'b0));                 



    

    
    
    
    cr_kme_kop_upsizer_x2 #
    (
        .IN_DATA_SIZE(128)
    )
    key_upsizer (
                 
                 .upsizer_in_stall      (upsizer_in_stall),
                 .upsizer_out_valid     (upsizer_keyfilter_valid), 
                 .upsizer_out_eof       (upsizer_keyfilter_eof), 
                 .upsizer_out_data      (upsizer_keyfilter_data[255:0]), 
                 
                 .clk                   (clk),
                 .rst_n                 (rst_n),
                 .in_upsizer_valid      (gcm_kdf_valid),         
                 .in_upsizer_eof        (gcm_kdf_eof),           
                 .in_upsizer_data       (gcm_kdf_data[127:0]),   
                 .out_upsizer_stall     (keyfilter_upsizer_stall)); 
 

    

    
    
    
    cr_kme_kop_kdf_keyfilter
    keyfilter (
               
               .keyfilter_cmdfifo_ack   (keyfilter_cmdfifo_ack),
               .keyfilter_upsizer_stall (keyfilter_upsizer_stall),
               .hash_key_in             (hash_key_in[255:0]),
               .hash_key_in_valid       (hash_key_in_valid),
               
               .clk                     (clk),
               .rst_n                   (rst_n),
               .cmdfifo_keyfilter_valid (cmdfifo_keyfilter_valid),
               .cmdfifo_keyfilter_cmd   (cmdfifo_keyfilter_cmd),
               .upsizer_keyfilter_data  (upsizer_keyfilter_data[255:0]),
               .upsizer_keyfilter_valid (upsizer_keyfilter_valid),
               .upsizer_keyfilter_eof   (upsizer_keyfilter_eof),
               .hash_key_in_stall       (hash_key_in_stall));


    

    
    
    
    cr_kme_fifo #
        (
        
        .DATA_SIZE(256),
        .FIFO_DEPTH(4)
        )
    hash_key_fifo (
                   
                   .fifo_in_stall       (hash_key_in_stall),     
                   .fifo_out            (keyfifo_hash_data[255:0]), 
                   .fifo_out_valid      (keyfifo_hash_valid),    
                   .fifo_overflow       (),                      
                   .fifo_underflow      (),                      
                   
                   .clk                 (clk),
                   .rst_n               (rst_n),
                   .fifo_in             (hash_key_in),           
                   .fifo_in_valid       (hash_key_in_valid),     
                   .fifo_out_ack        (hash_keyfifo_ack),      
                   .fifo_in_stall_override(1'b0));                




    


    
    
    
    
    
    
    
    
    
    //----------------------------------------------------------------------------------
    // KME_MODIFICATION_NOTE:
    // The HMAC-SHA-256 Engine has been replaced by a stub here.
    // User must replace with their own engine to add the KDF feature
    // See KME spec for more details. 
    //----------------------------------------------------------------------------------
    
    cr_kme_hmac_sha256_stub
    hmac_sha256 (
                 
                 .hash_cmdfifo_ack      (hash_cmdfifo_ack),
                 .hash_keyfifo_ack      (hash_keyfifo_ack),
                 .hash_len_data_out_ack (hash_len_data_out_ack),
                 .hash_in_stall         (hash_in_stall),
                 .sha_tag_data          (sha_tag_data[127:0]),
                 .sha_tag_valid         (sha_tag_valid),
                 .sha_tag_last          (sha_tag_last),
                 
                 .clk                   (clk),
                 .rst_n                 (rst_n),
                 .scan_en               (scan_en),
                 .scan_mode             (scan_mode),
                 .scan_rst_n            (scan_rst_n),
                 .cmdfifo_hash_valid    (cmdfifo_hash_valid),
                 .cmdfifo_hash_skip     (cmdfifo_hash_skip),
                 .cmdfifo_hash_small_size(cmdfifo_hash_small_size),
                 .keyfifo_hash_data     (keyfifo_hash_data[255:0]),
                 .keyfifo_hash_valid    (keyfifo_hash_valid),
                 .hash_len_data_out     (hash_len_data_out[31:0]),
                 .hash_len_data_out_valid(hash_len_data_out_valid),
                 .in_hash_valid         (in_hash_valid),
                 .in_hash_eof           (in_hash_eof),
                 .in_hash_eoc           (in_hash_eoc),
                 .in_hash_num_bytes     (in_hash_num_bytes[4:0]),
                 .in_hash_data          (in_hash_data[127:0]),
                 .sha_tag_stall         (sha_tag_stall));

    

    
    
    
    cr_kme_kop_kdf_stream_gen
    stream_gen (
                
                .kdfstream_cmdfifo_ack  (kdfstream_cmdfifo_ack),
                .cmdfifo_hash_valid     (cmdfifo_hash_valid),
                .cmdfifo_hash_skip      (cmdfifo_hash_skip),
                .cmdfifo_hash_small_size(cmdfifo_hash_small_size),
                .hash_len_data_out      (hash_len_data_out[31:0]),
                .hash_len_data_out_valid(hash_len_data_out_valid),
                .in_hash_valid          (in_hash_valid),
                .in_hash_eof            (in_hash_eof),
                .in_hash_eoc            (in_hash_eoc),
                .in_hash_num_bytes      (in_hash_num_bytes[4:0]),
                .in_hash_data           (in_hash_data[127:0]),
                
                .clk                    (clk),
                .rst_n                  (rst_n),
                .cmdfifo_kdfstream_valid(cmdfifo_kdfstream_valid),
                .cmdfifo_kdfstream_cmd  (cmdfifo_kdfstream_cmd),
                .labels                 (labels[7:0]),
                .hash_cmdfifo_ack       (hash_cmdfifo_ack),
                .hash_len_data_out_ack  (hash_len_data_out_ack),
                .hash_in_stall          (hash_in_stall),
                .kdf_test_key_size      (kdf_test_key_size[31:0]),
                .kdf_test_mode_en       (kdf_test_mode_en));


    

    
    
    
    cr_kme_kop_kdf_merger
    merger (
            
            .kdf_cmdfifo_ack            (kdf_cmdfifo_ack),
            .sha_tag_stall              (sha_tag_stall),
            .merger_keyfifo_ack         (merger_keyfifo_ack),
            .kdf_keybuilder_data        (kdf_keybuilder_data[63:0]),
            .kdf_keybuilder_valid       (kdf_keybuilder_valid),
            
            .clk                        (clk),
            .rst_n                      (rst_n),
            .cmdfifo_kdf_valid          (cmdfifo_kdf_valid),
            .cmdfifo_kdf_cmd            (cmdfifo_kdf_cmd),
            .sha_tag_data               (sha_tag_data[127:0]),
            .sha_tag_valid              (sha_tag_valid),
            .sha_tag_last               (sha_tag_last),
            .keyfifo_merger_data        (keyfifo_merger_data[127:0]),
            .keyfifo_merger_valid       (keyfifo_merger_valid),
            .keybuilder_kdf_stall       (keybuilder_kdf_stall));
 


endmodule









