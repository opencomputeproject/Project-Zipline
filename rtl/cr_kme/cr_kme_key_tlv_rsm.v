/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/











module cr_kme_key_tlv_rsm (
   
   usr_ob_full, usr_ob_afull, axi4s_ob_out, stat_stall_on_valid_key,
   key_tlv_rsm_end_pulse, key_tlv_rsm_idle,
   
   clk, rst_n, usr_ob_wr, usr_ob_tlv, axi4s_ob_in
   );


    `include "cr_kme_body_param.v"

    
    
    
    input clk;
    input rst_n;

    
    
    
    input                   usr_ob_wr;
    input  tlvp_if_bus_t    usr_ob_tlv;
    output                  usr_ob_full;
    output                  usr_ob_afull;

    
    
    
    input  axi4s_dp_rdy_t   axi4s_ob_in;
    output axi4s_dp_bus_t   axi4s_ob_out;

    
    
    
    output stat_stall_on_valid_key;

    
    
    
    output key_tlv_rsm_end_pulse;
    output key_tlv_rsm_idle;


    

    `ifdef SHOULD_BE_EMPTY
        
        
    `endif

    
    
    axi4s_dp_bus_t      tlvp_ob;                
    logic               tlvp_ob_aempty;         
    logic               tlvp_ob_empty;          
    logic               tlvp_ob_rd;             
    


    
    
    

    

    cr_tlvp2_rsm #
    (
       
       .N_UF_ENTRIES(16),  
       .N_OF_ENTRIES(168), 
       .UF_USE_RAM(0),
       .OF_USE_RAM(1)
    )
    u_cr_tlvp2_rsm (
                    
                    .pt_ob_rd           (),                      
                    .usr_ob_full        (usr_ob_full),
                    .usr_ob_afull       (usr_ob_afull),
                    .tlvp_ob_empty      (tlvp_ob_empty),
                    .tlvp_ob_aempty     (tlvp_ob_aempty),
                    .tlvp_ob            (tlvp_ob),
                    .tlvp_rsm_bimc_odat (),                      
                    .tlvp_rsm_bimc_osync(),                      
                    .tlvp_ob_ro_uncorrectable_ecc_error(),       
                    .usr_ob_ro_uncorrectable_ecc_error(),        
                    
                    .clk                (clk),
                    .rst_n              (rst_n),
                    .pt_ob_empty        (1'b1),                  
                    .pt_ob_aempty       (1'b1),                  
                    .pt_ob_tlv          ({$bits(tlvp_if_bus_t){1'b0}}), 
                    .usr_ob_wr          (usr_ob_wr),
                    .usr_ob_tlv         (usr_ob_tlv),
                    .tlvp_ob_rd         (tlvp_ob_rd),
                    .tlvp_rsm_bimc_idat (1'b0),                  
                    .tlvp_rsm_bimc_isync(1'b0),                  
                    .bimc_rst_n         (1'b0));                  
 
    
    
    

    
    
    cr_axi4s_mstr
    u_cr_axi4s_mstr (
                     
                     .axi4s_mstr_rd     (tlvp_ob_rd),            
                     .axi4s_ob_out      (axi4s_ob_out),
                     
                     .clk               (clk),
                     .rst_n             (rst_n),
                     .axi4s_in          (tlvp_ob),               
                     .axi4s_in_empty    (tlvp_ob_empty),         
                     .axi4s_in_aempty   (tlvp_ob_aempty),        
                     .axi4s_ob_in       (axi4s_ob_in));


    
    assign stat_stall_on_valid_key = ~tlvp_ob_empty & ~tlvp_ob_rd;

    
    assign key_tlv_rsm_end_pulse = usr_ob_wr & usr_ob_tlv.eot;
    assign key_tlv_rsm_idle      = tlvp_ob_empty & ~axi4s_ob_out.tvalid;


endmodule









