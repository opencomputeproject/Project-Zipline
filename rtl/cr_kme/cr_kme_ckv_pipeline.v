/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_ckv_pipeline (
   
   kme_slv_rd, cceip_encrypt_in, cceip_encrypt_in_valid,
   cceip_validate_in, cceip_validate_in_valid, cddip_decrypt_in,
   cddip_decrypt_in_valid, ckv_rd, ckv_addr, kim_rd, kim_addr,
   drng_ack, stat_req_with_expired_seed, stat_aux_key_type_0,
   stat_aux_key_type_1, stat_aux_key_type_2, stat_aux_key_type_3,
   stat_aux_key_type_4, stat_aux_key_type_5, stat_aux_key_type_6,
   stat_aux_key_type_7, stat_aux_key_type_8, stat_aux_key_type_9,
   stat_aux_key_type_10, stat_aux_key_type_11, stat_aux_key_type_12,
   stat_aux_key_type_13, stat_aux_cmd_with_vf_pf_fail,
   tlv_parser_idle, tlv_parser_int_tlv_start_pulse,
   set_tlv_bip2_error_int,
   
   clk, rst_n, disable_debug_cmd_q, disable_unencrypted_keys,
   always_validate_kim_ref, kme_slv_out, kme_slv_aempty,
   kme_slv_empty, cceip_encrypt_in_stall, cceip_validate_in_stall,
   cddip_decrypt_in_stall, ckv_dout, ckv_mbe, kim_dout, kim_mbe,
   drng_seed_expired, drng_health_fail, drng_256_out, drng_valid
   );


    `include "cr_kme_body_param.v"

    
    
    
    input clk;
    input rst_n;

    
    
    
    input disable_debug_cmd_q;
    input disable_unencrypted_keys;
    input always_validate_kim_ref;

    
    
    
    output                kme_slv_rd;
    input  axi4s_dp_bus_t kme_slv_out;
    input                 kme_slv_aempty;
    input                 kme_slv_empty;

    
    
    
    output kme_internal_t   cceip_encrypt_in;
    output                  cceip_encrypt_in_valid;
    input                   cceip_encrypt_in_stall;

    
    
    
    output kme_internal_t   cceip_validate_in;
    output                  cceip_validate_in_valid;
    input                   cceip_validate_in_stall;

    
    
    
    output kme_internal_t   cddip_decrypt_in;
    output                  cddip_decrypt_in_valid;
    input                   cddip_decrypt_in_stall;

    
    
    
    output           ckv_rd;
    output   [14:0]  ckv_addr;
    input    [63:0]  ckv_dout;
    input            ckv_mbe;

    
    
    
    output              kim_rd;
    output      [13:0]  kim_addr;
    input  kim_entry_t  kim_dout;
    input               kim_mbe;

    
    
    
    input           drng_seed_expired;
    input           drng_health_fail;
    input [127:0]   drng_256_out;
    input           drng_valid;
    output          drng_ack;

    
    
    
    output stat_req_with_expired_seed;
    output stat_aux_key_type_0;
    output stat_aux_key_type_1;
    output stat_aux_key_type_2;
    output stat_aux_key_type_3;
    output stat_aux_key_type_4;
    output stat_aux_key_type_5;
    output stat_aux_key_type_6;
    output stat_aux_key_type_7;
    output stat_aux_key_type_8;
    output stat_aux_key_type_9;
    output stat_aux_key_type_10;
    output stat_aux_key_type_11;
    output stat_aux_key_type_12;
    output stat_aux_key_type_13;
    output stat_aux_cmd_with_vf_pf_fail;

    
    
    
    output tlv_parser_idle;
    output tlv_parser_int_tlv_start_pulse;

    
    
    
    output set_tlv_bip2_error_int;


    
    
    wire		ckvreader_kimreader_ack;
    kme_internal_t	ckvreader_kopassigner_data;
    wire		ckvreader_kopassigner_valid;
    kme_internal_t	kimreader_ckvreader_data;
    wire		kimreader_ckvreader_valid;
    wire		kimreader_parser_ack;	
    wire		kopassigner_ckvreader_ack;
    kme_internal_t	parser_kimreader_data;	
    wire		parser_kimreader_valid;	
    wire		stitcher_empty;		
    axi4s_dp_bus_t	stitcher_out;		
    wire		stitcher_rd;		
    


    
    
    

    

    cr_kme_guid_stitcher
    guid_stitcher (
		   
		   .kme_slv_rd		(kme_slv_rd),
		   .stitcher_out	(stitcher_out),
		   .stitcher_empty	(stitcher_empty),
		   .set_tlv_bip2_error_int(set_tlv_bip2_error_int),
		   
		   .clk			(clk),
		   .rst_n		(rst_n),
		   .kme_slv_out		(kme_slv_out),
		   .kme_slv_aempty	(kme_slv_aempty),
		   .kme_slv_empty	(kme_slv_empty),
		   .stitcher_rd		(stitcher_rd));

    
    
    

    

    cr_kme_tlv_parser
    tlv_parser (
		
		.stitcher_rd		(stitcher_rd),
		.parser_kimreader_valid	(parser_kimreader_valid),
		.parser_kimreader_data	(parser_kimreader_data),
		.tlv_parser_idle	(tlv_parser_idle),
		.tlv_parser_int_tlv_start_pulse(tlv_parser_int_tlv_start_pulse),
		
		.clk			(clk),
		.rst_n			(rst_n),
		.disable_debug_cmd_q	(disable_debug_cmd_q),
		.always_validate_kim_ref(always_validate_kim_ref),
		.stitcher_out		(stitcher_out),
		.stitcher_empty		(stitcher_empty),
		.kimreader_parser_ack	(kimreader_parser_ack));

    
    
    

    

    cr_kme_kim_drng_reader
    kim_drng_reader (
		     
		     .kimreader_parser_ack(kimreader_parser_ack),
		     .kimreader_ckvreader_valid(kimreader_ckvreader_valid),
		     .kimreader_ckvreader_data(kimreader_ckvreader_data),
		     .drng_ack		(drng_ack),
		     .kim_rd		(kim_rd),
		     .kim_addr		(kim_addr[13:0]),
		     .stat_req_with_expired_seed(stat_req_with_expired_seed),
		     .stat_aux_key_type_0(stat_aux_key_type_0),
		     .stat_aux_key_type_1(stat_aux_key_type_1),
		     .stat_aux_key_type_2(stat_aux_key_type_2),
		     .stat_aux_key_type_3(stat_aux_key_type_3),
		     .stat_aux_key_type_4(stat_aux_key_type_4),
		     .stat_aux_key_type_5(stat_aux_key_type_5),
		     .stat_aux_key_type_6(stat_aux_key_type_6),
		     .stat_aux_key_type_7(stat_aux_key_type_7),
		     .stat_aux_key_type_8(stat_aux_key_type_8),
		     .stat_aux_key_type_9(stat_aux_key_type_9),
		     .stat_aux_key_type_10(stat_aux_key_type_10),
		     .stat_aux_key_type_11(stat_aux_key_type_11),
		     .stat_aux_key_type_12(stat_aux_key_type_12),
		     .stat_aux_key_type_13(stat_aux_key_type_13),
		     .stat_aux_cmd_with_vf_pf_fail(stat_aux_cmd_with_vf_pf_fail),
		     
		     .clk		(clk),
		     .rst_n		(rst_n),
		     .parser_kimreader_valid(parser_kimreader_valid),
		     .parser_kimreader_data(parser_kimreader_data),
		     .ckvreader_kimreader_ack(ckvreader_kimreader_ack),
		     .drng_seed_expired	(drng_seed_expired),
		     .drng_health_fail	(drng_health_fail),
		     .drng_256_out	(drng_256_out[127:0]),
		     .drng_valid	(drng_valid),
		     .kim_dout		(kim_dout),
		     .kim_mbe		(kim_mbe),
		     .disable_unencrypted_keys(disable_unencrypted_keys));

    
    
    

    

    cr_kme_ckv_reader
    ckv_reader (
		
		.ckvreader_kimreader_ack(ckvreader_kimreader_ack),
		.ckvreader_kopassigner_valid(ckvreader_kopassigner_valid),
		.ckvreader_kopassigner_data(ckvreader_kopassigner_data),
		.ckv_rd			(ckv_rd),
		.ckv_addr		(ckv_addr[14:0]),
		
		.clk			(clk),
		.rst_n			(rst_n),
		.kimreader_ckvreader_valid(kimreader_ckvreader_valid),
		.kimreader_ckvreader_data(kimreader_ckvreader_data),
		.kopassigner_ckvreader_ack(kopassigner_ckvreader_ack),
		.ckv_dout		(ckv_dout[63:0]),
		.ckv_mbe		(ckv_mbe));


    
    
    

    

    cr_kme_kop_assigner
    kop_assigner (
		  
		  .kopassigner_ckvreader_ack(kopassigner_ckvreader_ack),
		  .cceip_encrypt_in	(cceip_encrypt_in),
		  .cceip_encrypt_in_valid(cceip_encrypt_in_valid),
		  .cceip_validate_in	(cceip_validate_in),
		  .cceip_validate_in_valid(cceip_validate_in_valid),
		  .cddip_decrypt_in	(cddip_decrypt_in),
		  .cddip_decrypt_in_valid(cddip_decrypt_in_valid),
		  
		  .clk			(clk),
		  .rst_n		(rst_n),
		  .ckvreader_kopassigner_valid(ckvreader_kopassigner_valid),
		  .ckvreader_kopassigner_data(ckvreader_kopassigner_data),
		  .cceip_encrypt_in_stall(cceip_encrypt_in_stall),
		  .cceip_validate_in_stall(cceip_validate_in_stall),
		  .cddip_decrypt_in_stall(cddip_decrypt_in_stall));



endmodule









