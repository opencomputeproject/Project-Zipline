/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_kop (
  
  kme_internal_out_ack, key_tlv_ob_wr, key_tlv_ob_tlv,
  set_gcm_tag_fail_int,
  
  clk, rst_n, scan_en, scan_mode, scan_rst_n, labels,
  kme_internal_out, kme_internal_out_valid, key_tlv_ob_full,
  key_tlv_ob_afull, kop_fifo_override, kdf_test_key_size,
  kdf_test_mode_en
  );

    `include "cr_kme_body_param.v"

    parameter CCEIP_ENCRYPT_KOP = 0;

    
    
    
    input clk;
    input rst_n;

    
    
    
    input scan_en;
    input scan_mode;
    input scan_rst_n;

    
    
    
    input label_t [7:0] labels;
 
    
    
    
    input  kme_internal_t   kme_internal_out;
    input                   kme_internal_out_valid;
    output                  kme_internal_out_ack;

    
    
    
    output                  key_tlv_ob_wr;
    output tlvp_if_bus_t    key_tlv_ob_tlv;
    input                   key_tlv_ob_full;
    input                   key_tlv_ob_afull;

    
    
    
    output set_gcm_tag_fail_int;

    
    
    
    input kop_fifo_override_t kop_fifo_override;

    
    
    
    input [31:0]            kdf_test_key_size;
    input                   kdf_test_mode_en;

    `ifdef SHOULD_BE_EMPTY
        
        
    `endif



    
    
    wire [($bits(gcm_cmd_t))-1:0] cmdfifo_gcm_cmd;
    wire                cmdfifo_gcm_valid;      
    wire [($bits(kdf_cmd_t))-1:0] cmdfifo_kdf_cmd;
    wire                cmdfifo_kdf_valid;      
    wire [($bits(kdfstream_cmd_t))-1:0] cmdfifo_kdfstream_cmd;
    wire                cmdfifo_kdfstream_valid;
    wire [($bits(keyfilter_cmd_t))-1:0] cmdfifo_keyfilter_cmd;
    wire                cmdfifo_keyfilter_valid;
    gcm_cmd_t           gcm_cmd_in;             
    wire                gcm_cmd_in_stall;       
    wire                gcm_cmd_in_valid;       
    wire                gcm_cmdfifo_ack;        
    wire [127:0]        gcm_kdf_data;           
    wire                gcm_kdf_eof;            
    wire                gcm_kdf_valid;          
    gcm_status_t        gcm_status_data_in;     
    wire                gcm_status_data_in_stall;
    wire                gcm_status_data_in_valid;
    wire [($bits(gcm_status_t))-1:0] gcm_status_data_out;
    wire                gcm_status_data_out_ack;
    wire                gcm_status_data_out_valid;
    wire [95:0]         gcm_tag_data_in;        
    wire                gcm_tag_data_in_stall;  
    wire                gcm_tag_data_in_valid;  
    wire [95:0]         gcm_tag_data_out;       
    wire                gcm_tag_data_out_ack;   
    wire                gcm_tag_data_out_valid; 
    wire                gcm_upsizer_stall;      
    wire [63:0]         inspector_upsizer_data; 
    wire                inspector_upsizer_eof;  
    wire                inspector_upsizer_valid;
    kdf_cmd_t           kdf_cmd_in;             
    wire                kdf_cmd_in_stall;       
    wire                kdf_cmd_in_valid;       
    wire                kdf_cmdfifo_ack;        
    wire                kdf_gcm_stall;          
    wire [63:0]         kdf_keybuilder_data;    
    wire                kdf_keybuilder_valid;   
    kdfstream_cmd_t     kdfstream_cmd_in;       
    wire                kdfstream_cmd_in_stall; 
    wire                kdfstream_cmd_in_valid; 
    wire                kdfstream_cmdfifo_ack;  
    wire                keybuilder_kdf_stall;   
    keyfilter_cmd_t     keyfilter_cmd_in;       
    wire                keyfilter_cmd_in_stall; 
    wire                keyfilter_cmd_in_valid; 
    wire                keyfilter_cmdfifo_ack;  
    wire [63:0]         tlv_sb_data_in;         
    wire                tlv_sb_data_in_stall;   
    wire                tlv_sb_data_in_valid;   
    wire [63:0]         tlv_sb_data_out;        
    wire                tlv_sb_data_out_ack;    
    wire                tlv_sb_data_out_valid;  
    wire [127:0]        upsizer_gcm_data;       
    wire                upsizer_gcm_eof;        
    wire                upsizer_gcm_valid;      
    wire                upsizer_inspector_stall;
    


    

    
    
    
    cr_kme_kop_tlv_inspector #
    (
        .CCEIP_ENCRYPT_KOP(CCEIP_ENCRYPT_KOP)
    )
    tlv_inspector (
                   
                   .kme_internal_out_ack(kme_internal_out_ack),
                   .gcm_cmd_in          (gcm_cmd_in),
                   .gcm_cmd_in_valid    (gcm_cmd_in_valid),
                   .gcm_tag_data_in     (gcm_tag_data_in[95:0]),
                   .gcm_tag_data_in_valid(gcm_tag_data_in_valid),
                   .inspector_upsizer_valid(inspector_upsizer_valid),
                   .inspector_upsizer_eof(inspector_upsizer_eof),
                   .inspector_upsizer_data(inspector_upsizer_data[63:0]),
                   .keyfilter_cmd_in    (keyfilter_cmd_in),
                   .keyfilter_cmd_in_valid(keyfilter_cmd_in_valid),
                   .kdfstream_cmd_in    (kdfstream_cmd_in),
                   .kdfstream_cmd_in_valid(kdfstream_cmd_in_valid),
                   .kdf_cmd_in          (kdf_cmd_in),
                   .kdf_cmd_in_valid    (kdf_cmd_in_valid),
                   .tlv_sb_data_in      (tlv_sb_data_in[63:0]),
                   .tlv_sb_data_in_valid(tlv_sb_data_in_valid),
                   
                   .clk                 (clk),
                   .rst_n               (rst_n),
                   .labels              (labels[7:0]),
                   .kme_internal_out    (kme_internal_out),
                   .kme_internal_out_valid(kme_internal_out_valid),
                   .gcm_cmd_in_stall    (gcm_cmd_in_stall),
                   .gcm_tag_data_in_stall(gcm_tag_data_in_stall),
                   .upsizer_inspector_stall(upsizer_inspector_stall),
                   .keyfilter_cmd_in_stall(keyfilter_cmd_in_stall),
                   .kdfstream_cmd_in_stall(kdfstream_cmd_in_stall),
                   .kdf_cmd_in_stall    (kdf_cmd_in_stall),
                   .tlv_sb_data_in_stall(tlv_sb_data_in_stall));


    

    
    
    
    cr_kme_kop_upsizer_x2 #
    (
        .IN_DATA_SIZE(64)
    )
    upsizer (
             
             .upsizer_in_stall          (upsizer_inspector_stall), 
             .upsizer_out_valid         (upsizer_gcm_valid),     
             .upsizer_out_eof           (upsizer_gcm_eof),       
             .upsizer_out_data          (upsizer_gcm_data[127:0]), 
             
             .clk                       (clk),
             .rst_n                     (rst_n),
             .in_upsizer_valid          (inspector_upsizer_valid), 
             .in_upsizer_eof            (inspector_upsizer_eof), 
             .in_upsizer_data           (inspector_upsizer_data[63:0]), 
             .out_upsizer_stall         (gcm_upsizer_stall));     


    

    
    
    
    cr_kme_kop_gcm
    gcm (
         
         .set_gcm_tag_fail_int          (set_gcm_tag_fail_int),
         .gcm_cmdfifo_ack               (gcm_cmdfifo_ack),
         .gcm_upsizer_stall             (gcm_upsizer_stall),
         .gcm_tag_data_out_ack          (gcm_tag_data_out_ack),
         .gcm_kdf_valid                 (gcm_kdf_valid),
         .gcm_kdf_eof                   (gcm_kdf_eof),
         .gcm_kdf_data                  (gcm_kdf_data[127:0]),
         .gcm_status_data_in_valid      (gcm_status_data_in_valid),
         .gcm_status_data_in            (gcm_status_data_in),
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .cmdfifo_gcm_valid             (cmdfifo_gcm_valid),
         .cmdfifo_gcm_cmd               (cmdfifo_gcm_cmd),
         .upsizer_gcm_valid             (upsizer_gcm_valid),
         .upsizer_gcm_eof               (upsizer_gcm_eof),
         .upsizer_gcm_data              (upsizer_gcm_data[127:0]),
         .gcm_tag_data_out              (gcm_tag_data_out[95:0]),
         .gcm_tag_data_out_valid        (gcm_tag_data_out_valid),
         .kdf_gcm_stall                 (kdf_gcm_stall),
         .gcm_status_data_in_stall      (gcm_status_data_in_stall));


    


    
    
    
    cr_kme_kop_kdf
    kdf (
         
         .keyfilter_cmdfifo_ack         (keyfilter_cmdfifo_ack),
         .kdf_cmdfifo_ack               (kdf_cmdfifo_ack),
         .kdfstream_cmdfifo_ack         (kdfstream_cmdfifo_ack),
         .kdf_gcm_stall                 (kdf_gcm_stall),
         .kdf_keybuilder_data           (kdf_keybuilder_data[63:0]),
         .kdf_keybuilder_valid          (kdf_keybuilder_valid),
         
         .clk                           (clk),
         .rst_n                         (rst_n),
         .scan_en                       (scan_en),
         .scan_mode                     (scan_mode),
         .scan_rst_n                    (scan_rst_n),
         .labels                        (labels[7:0]),
         .cmdfifo_keyfilter_valid       (cmdfifo_keyfilter_valid),
         .cmdfifo_keyfilter_cmd         (cmdfifo_keyfilter_cmd),
         .cmdfifo_kdf_valid             (cmdfifo_kdf_valid),
         .cmdfifo_kdf_cmd               (cmdfifo_kdf_cmd),
         .cmdfifo_kdfstream_valid       (cmdfifo_kdfstream_valid),
         .cmdfifo_kdfstream_cmd         (cmdfifo_kdfstream_cmd),
         .gcm_kdf_valid                 (gcm_kdf_valid),
         .gcm_kdf_eof                   (gcm_kdf_eof),
         .gcm_kdf_data                  (gcm_kdf_data[127:0]),
         .keybuilder_kdf_stall          (keybuilder_kdf_stall),
         .kdf_test_key_size             (kdf_test_key_size[31:0]),
         .kdf_test_mode_en              (kdf_test_mode_en));

    


    
    
    
    cr_kme_kop_keybuilder
    key_builder (
                 
                 .tlv_sb_data_out_ack   (tlv_sb_data_out_ack),
                 .keybuilder_kdf_stall  (keybuilder_kdf_stall),
                 .gcm_status_data_out_ack(gcm_status_data_out_ack),
                 .key_tlv_ob_wr         (key_tlv_ob_wr),
                 .key_tlv_ob_tlv        (key_tlv_ob_tlv),
                 
                 .clk                   (clk),
                 .rst_n                 (rst_n),
                 .tlv_sb_data_out       (tlv_sb_data_out[63:0]),
                 .tlv_sb_data_out_valid (tlv_sb_data_out_valid),
                 .kdf_keybuilder_data   (kdf_keybuilder_data[63:0]),
                 .kdf_keybuilder_valid  (kdf_keybuilder_valid),
                 .gcm_status_data_out_valid(gcm_status_data_out_valid),
                 .gcm_status_data_out   (gcm_status_data_out),
                 .key_tlv_ob_full       (key_tlv_ob_full),
                 .key_tlv_ob_afull      (key_tlv_ob_afull));
 

    
    
    

    

    
    
    
    cr_kme_fifo #
        (
        
        .DATA_SIZE($bits(gcm_cmd_t)),
        .FIFO_DEPTH(4),
        .OVERRIDE_EN(1)
        )
    gcm_cmd_fifo (
                  
                  .fifo_in_stall        (gcm_cmd_in_stall),      
                  .fifo_out             (cmdfifo_gcm_cmd[($bits(gcm_cmd_t))-1:0]), 
                  .fifo_out_valid       (cmdfifo_gcm_valid),     
                  .fifo_overflow        (),                      
                  .fifo_underflow       (),                      
                  
                  .clk                  (clk),
                  .rst_n                (rst_n),
                  .fifo_in              (gcm_cmd_in),            
                  .fifo_in_valid        (gcm_cmd_in_valid),      
                  .fifo_out_ack         (gcm_cmdfifo_ack),       
                  .fifo_in_stall_override(kop_fifo_override.f.gcm_cmd_fifo)); 

    
    
    
    cr_kme_fifo #
        (
        
        .DATA_SIZE($bits(keyfilter_cmd_t)),
        .FIFO_DEPTH(4),
        .OVERRIDE_EN(1)
        )
    keyfilter_cmd_fifo (
                        
                        .fifo_in_stall  (keyfilter_cmd_in_stall), 
                        .fifo_out       (cmdfifo_keyfilter_cmd[($bits(keyfilter_cmd_t))-1:0]), 
                        .fifo_out_valid (cmdfifo_keyfilter_valid), 
                        .fifo_overflow  (),                      
                        .fifo_underflow (),                      
                        
                        .clk            (clk),
                        .rst_n          (rst_n),
                        .fifo_in        (keyfilter_cmd_in),      
                        .fifo_in_valid  (keyfilter_cmd_in_valid), 
                        .fifo_out_ack   (keyfilter_cmdfifo_ack), 
                        .fifo_in_stall_override(kop_fifo_override.f.keyfilter_cmd_fifo)); 


    
    
    
    cr_kme_fifo #
        (
        
        .DATA_SIZE($bits(kdf_cmd_t)),
        .FIFO_DEPTH(4),
        .OVERRIDE_EN(1)
        )
    kdf_cmd_fifo (
                  
                  .fifo_in_stall        (kdf_cmd_in_stall),      
                  .fifo_out             (cmdfifo_kdf_cmd[($bits(kdf_cmd_t))-1:0]), 
                  .fifo_out_valid       (cmdfifo_kdf_valid),     
                  .fifo_overflow        (),                      
                  .fifo_underflow       (),                      
                  
                  .clk                  (clk),
                  .rst_n                (rst_n),
                  .fifo_in              (kdf_cmd_in),            
                  .fifo_in_valid        (kdf_cmd_in_valid),      
                  .fifo_out_ack         (kdf_cmdfifo_ack),       
                  .fifo_in_stall_override(kop_fifo_override.f.kdf_cmd_fifo)); 

    
    
    
    cr_kme_fifo #
        (
        
        .DATA_SIZE($bits(kdfstream_cmd_t)),
        .FIFO_DEPTH(4),
        .OVERRIDE_EN(1)
        )
    kdfstream_cmd_fifo (
                        
                        .fifo_in_stall  (kdfstream_cmd_in_stall), 
                        .fifo_out       (cmdfifo_kdfstream_cmd[($bits(kdfstream_cmd_t))-1:0]), 
                        .fifo_out_valid (cmdfifo_kdfstream_valid), 
                        .fifo_overflow  (),                      
                        .fifo_underflow (),                      
                        
                        .clk            (clk),
                        .rst_n          (rst_n),
                        .fifo_in        (kdfstream_cmd_in),      
                        .fifo_in_valid  (kdfstream_cmd_in_valid), 
                        .fifo_out_ack   (kdfstream_cmdfifo_ack), 
                        .fifo_in_stall_override(kop_fifo_override.f.kdfstream_cmd_fifo)); 



    


    
    
    
    cr_kme_fifo #
        (
        
        .DATA_SIZE(64),
        .FIFO_DEPTH(16),
        .OVERRIDE_EN(1)
        )
    tlv_sb_data_fifo (
                      
                      .fifo_in_stall    (tlv_sb_data_in_stall),  
                      .fifo_out         (tlv_sb_data_out[63:0]), 
                      .fifo_out_valid   (tlv_sb_data_out_valid), 
                      .fifo_overflow    (),                      
                      .fifo_underflow   (),                      
                      
                      .clk              (clk),
                      .rst_n            (rst_n),
                      .fifo_in          (tlv_sb_data_in[63:0]),  
                      .fifo_in_valid    (tlv_sb_data_in_valid),  
                      .fifo_out_ack     (tlv_sb_data_out_ack),   
                      .fifo_in_stall_override(kop_fifo_override.f.tlv_sb_data_fifo)); 
 

    
    
    
    cr_kme_fifo #
        (
        
        .DATA_SIZE(96),
        .FIFO_DEPTH(4),
        .OVERRIDE_EN(1)
        )
    gcm_tag_data_fifo (
                       
                       .fifo_in_stall   (gcm_tag_data_in_stall), 
                       .fifo_out        (gcm_tag_data_out[95:0]), 
                       .fifo_out_valid  (gcm_tag_data_out_valid), 
                       .fifo_overflow   (),                      
                       .fifo_underflow  (),                      
                       
                       .clk             (clk),
                       .rst_n           (rst_n),
                       .fifo_in         (gcm_tag_data_in[95:0]), 
                       .fifo_in_valid   (gcm_tag_data_in_valid), 
                       .fifo_out_ack    (gcm_tag_data_out_ack),  
                       .fifo_in_stall_override(kop_fifo_override.f.gcm_tag_data_fifo)); 


    
    
    
    cr_kme_fifo #
        (
        
        .DATA_SIZE($bits(gcm_status_t)),
        .FIFO_DEPTH(4),
        .OVERRIDE_EN(1)
        )
    gcm_status_data_fifo (
                          
                          .fifo_in_stall        (gcm_status_data_in_stall), 
                          .fifo_out             (gcm_status_data_out[($bits(gcm_status_t))-1:0]), 
                          .fifo_out_valid       (gcm_status_data_out_valid), 
                          .fifo_overflow        (),              
                          .fifo_underflow       (),              
                          
                          .clk                  (clk),
                          .rst_n                (rst_n),
                          .fifo_in              (gcm_status_data_in[($bits(gcm_status_t))-1:0]), 
                          .fifo_in_valid        (gcm_status_data_in_valid), 
                          .fifo_out_ack         (gcm_status_data_out_ack), 
                          .fifo_in_stall_override(kop_fifo_override.f.gcm_status_data_fifo)); 



endmodule









