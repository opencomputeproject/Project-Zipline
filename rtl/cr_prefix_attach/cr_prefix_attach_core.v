/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/








`include "cr_prefix_attach.vh"
`include "crPKG.svp"

module cr_prefix_attach_core 
  #(parameter PREFIX_ATTACH_STUB=0)
  (
  
  prefix_attach_ib_out, prefix_attach_ob_out, pfd_mem_addr,
  pfd_mem_cs, phd_mem_addr, phd_mem_cs, tlvp_error,
  
  clk, rst_n, cceip_cfg, prefix_attach_module_id, tlv_parse_action_0,
  tlv_parse_action_1, prefix_attach_ib_in, prefix_attach_ob_in,
  pfd_mem_dout, pfd_mem_yield, phd_mem_dout, phd_mem_yield
  );
            
`include "cr_structs.sv"
      
  import cr_prefix_attachPKG::*;
  import cr_prefix_attach_regsPKG::*;
  
  
  
  

  parameter N_UF_ENTRIES      = 32; 
  parameter N_UF_AFULL_VAL    = 5;  
  parameter N_UF_AEMPTY_VAL   = 1;  
    
  
  
  
     
  
  
  
  input                                           clk;
  input                                           rst_n; 
  
  
  
  
  input                                           cceip_cfg;
  input [`MODULE_ID_WIDTH-1:0]                    prefix_attach_module_id;
  input logic [31:0]                              tlv_parse_action_0;
  input logic [31:0]                              tlv_parse_action_1;
        
  
  
  
  input  axi4s_dp_bus_t                           prefix_attach_ib_in;
  output axi4s_dp_rdy_t                           prefix_attach_ib_out;

  
  
  
  input  axi4s_dp_rdy_t                           prefix_attach_ob_in;
  output axi4s_dp_bus_t                           prefix_attach_ob_out;
  
  
  
  
  output logic [`LOG_VEC(`CR_PREFIX_PFD_ENTRIES)] pfd_mem_addr;
  output logic                                    pfd_mem_cs;
  input                                           pfd_t pfd_mem_dout;
  input logic                                     pfd_mem_yield;
  
  
  
  
  output logic [`LOG_VEC(`CR_PREFIX_PHD_ENTRIES)] phd_mem_addr;
  output logic                                    phd_mem_cs;
  input                                           phd_t phd_mem_dout;
  input logic                                     phd_mem_yield;

 
  
  
  
  output logic                           tlvp_error;
  
  tlvp_if_bus_t         usr_ib_tlv;
  tlvp_if_bus_t         usr_ob_tlv;
  
  generate if (PREFIX_ATTACH_STUB == 1)
  begin : prefix_attach_stub_code
   assign prefix_attach_ib_out.tready = prefix_attach_ob_in.tready;
 
   always_comb
     begin
        prefix_attach_ob_out.tvalid = prefix_attach_ib_in.tvalid;
        prefix_attach_ob_out.tlast  = prefix_attach_ib_in.tlast;
        prefix_attach_ob_out.tid    = prefix_attach_ib_in.tid;
        prefix_attach_ob_out.tstrb  = prefix_attach_ib_in.tstrb;   
        prefix_attach_ob_out.tuser  = prefix_attach_ib_in.tuser;  
        prefix_attach_ob_out.tdata  = prefix_attach_ib_in.tdata;

       pfd_mem_addr = 0;
       pfd_mem_cs = 0;
       phd_mem_addr = 0;
       phd_mem_cs = 0;
       
     end 
  end
  else
   begin :prefix_attach_core
    
    
    logic               ibp_inc_pfd_addr;       
    logic               ibp_inc_phd_addr;       
    logic               ibp_insert_pfd_req;     
    logic               ibp_insert_phd_req;     
    logic               ibp_insert_true;        
    logic               ibp_ld_pfd_crc_addr;    
    logic               ibp_ld_phd_crc_addr;    
    logic [5:0]         ibp_prefix_num;         
    logic               ibp_prefix_valid;       
    tlvp_if_bus_t       ibp_tlv;                
    logic               ibp_tlv_valid;          
    logic               pac_pfd_check_valid_ack;
    logic               pac_phd_check_valid_ack;
    logic               pac_stall;              
    tlvp_if_bus_t       pac_usr_ob_tlv;         
    logic               pac_usr_ob_wr;          
    logic               pmc_pfd_check_valid;    
    logic [31:0]        pmc_pfd_crc;            
    logic               pmc_pfd_crc_error;      
    logic               pmc_pfd_crc_valid;      
    logic               pmc_pfd_dout_valid;     
    logic               pmc_pfd_eot;            
    logic               pmc_phd_check_valid;    
    logic [31:0]        pmc_phd_crc;            
    logic               pmc_phd_crc_error;      
    logic               pmc_phd_crc_valid;      
    logic               pmc_phd_dout_valid;     
    logic               pmc_phd_eot;            
    logic               pti_insert_pfd_ack;     
    logic               pti_insert_pfd_inwrk;   
    logic               pti_insert_phd_inwrk;   
    logic               pti_usr_ob_sel;         
    tlvp_if_bus_t       pti_usr_ob_tlv;         
    logic               pti_usr_ob_wr;          
    logic               usr_ib_aempty;          
    logic               usr_ib_empty;           
    logic               usr_ib_rd;              
    logic               usr_ob_afull;           
    logic               usr_ob_full;            
    
    logic              usr_ob_wr;
     
  always_comb begin    

    if(pti_usr_ob_sel) begin
      usr_ob_wr  = pti_usr_ob_wr;
      usr_ob_tlv = pti_usr_ob_tlv;
    end
    else begin
      usr_ob_wr  = pac_usr_ob_wr;
      usr_ob_tlv = pac_usr_ob_tlv;
    end
  end 
        
  
  
  
  
  

  cr_tlvp_top #
    (
     .N_AXIS_ENTRIES                    (32),
     .N_UF_ENTRIES                      (N_UF_ENTRIES),
     .N_UF_AFULL_VAL                    (N_UF_AFULL_VAL),
     .N_UF_AEMPTY_VAL                   (N_UF_AEMPTY_VAL)) 
    u_cr_tlvp_top  
    (
     
     .axi4s_ib_out                      (prefix_attach_ib_out),  
     .usr_ib_empty                      (usr_ib_empty),
     .usr_ib_aempty                     (usr_ib_aempty),
     .usr_ib_tlv                        (usr_ib_tlv),
     .usr_ob_full                       (usr_ob_full),
     .usr_ob_afull                      (usr_ob_afull),
     .tlvp_error                        (tlvp_error),
     .axi4s_ob_out                      (prefix_attach_ob_out),  
     
     .clk                               (clk),
     .rst_n                             (rst_n),
     .axi4s_ib_in                       (prefix_attach_ib_in),   
     .tlv_parse_action                  ({tlv_parse_action_1,tlv_parse_action_0}), 
     .module_id                         (prefix_attach_module_id), 
     .usr_ib_rd                         (usr_ib_rd),
     .usr_ob_wr                         (usr_ob_wr),
     .usr_ob_tlv                        (usr_ob_tlv),
     .axi4s_ob_in                       (prefix_attach_ob_in));  

  
  
  
  

  cr_prefix_attach_ibp
    u_cr_prefix_attach_ibp  
      (
       
       .usr_ib_rd                       (usr_ib_rd),
       .ibp_ld_phd_crc_addr             (ibp_ld_phd_crc_addr),
       .ibp_ld_pfd_crc_addr             (ibp_ld_pfd_crc_addr),
       .ibp_prefix_num                  (ibp_prefix_num[5:0]),
       .ibp_prefix_valid                (ibp_prefix_valid),
       .ibp_inc_pfd_addr                (ibp_inc_pfd_addr),
       .ibp_inc_phd_addr                (ibp_inc_phd_addr),
       .ibp_insert_phd_req              (ibp_insert_phd_req),
       .ibp_insert_pfd_req              (ibp_insert_pfd_req),
       .ibp_tlv                         (ibp_tlv),
       .ibp_tlv_valid                   (ibp_tlv_valid),
       .ibp_insert_true                 (ibp_insert_true),
       
       .clk                             (clk),
       .rst_n                           (rst_n),
       .cceip_cfg                       (cceip_cfg),
       .usr_ib_empty                    (usr_ib_empty),
       .usr_ib_aempty                   (usr_ib_aempty),
       .usr_ib_tlv                      (usr_ib_tlv),
       .pmc_phd_crc_valid               (pmc_phd_crc_valid),
       .pmc_pfd_crc_valid               (pmc_pfd_crc_valid),
       .pac_stall                       (pac_stall),
       .pti_insert_phd_inwrk            (pti_insert_phd_inwrk),
       .pti_insert_pfd_inwrk            (pti_insert_pfd_inwrk),
       .pti_insert_pfd_ack              (pti_insert_pfd_ack),
       .usr_ob_afull                    (usr_ob_afull));
     
  
  
  
  

  cr_prefix_attach_pmc
    u_cr_prefix_attach_pmc  
      (
       
       .pfd_mem_addr                    (pfd_mem_addr[`LOG_VEC(`CR_PREFIX_PFD_ENTRIES)]),
       .pfd_mem_cs                      (pfd_mem_cs),
       .phd_mem_addr                    (phd_mem_addr[`LOG_VEC(`CR_PREFIX_PHD_ENTRIES)]),
       .phd_mem_cs                      (phd_mem_cs),
       .pmc_phd_crc_error               (pmc_phd_crc_error),
       .pmc_pfd_crc_error               (pmc_pfd_crc_error),
       .pmc_phd_check_valid             (pmc_phd_check_valid),
       .pmc_pfd_check_valid             (pmc_pfd_check_valid),
       .pmc_phd_crc_valid               (pmc_phd_crc_valid),
       .pmc_pfd_crc_valid               (pmc_pfd_crc_valid),
       .pmc_phd_crc                     (pmc_phd_crc[31:0]),
       .pmc_pfd_crc                     (pmc_pfd_crc[31:0]),
       .pmc_phd_eot                     (pmc_phd_eot),
       .pmc_pfd_eot                     (pmc_pfd_eot),
       .pmc_phd_dout_valid              (pmc_phd_dout_valid),
       .pmc_pfd_dout_valid              (pmc_pfd_dout_valid),
       
       .clk                             (clk),
       .rst_n                           (rst_n),
       .cceip_cfg                       (cceip_cfg),
       .pfd_mem_dout                    (pfd_mem_dout),
       .phd_mem_dout                    (phd_mem_dout),
       .ibp_ld_phd_crc_addr             (ibp_ld_phd_crc_addr),
       .ibp_ld_pfd_crc_addr             (ibp_ld_pfd_crc_addr),
       .ibp_prefix_num                  (ibp_prefix_num[5:0]),
       .ibp_prefix_valid                (ibp_prefix_valid),
       .ibp_inc_pfd_addr                (ibp_inc_pfd_addr),
       .ibp_inc_phd_addr                (ibp_inc_phd_addr),
       .pti_insert_pfd_ack              (pti_insert_pfd_ack),
       .pac_phd_check_valid_ack         (pac_phd_check_valid_ack),
       .pac_pfd_check_valid_ack         (pac_pfd_check_valid_ack));
     
  
  
  
  

  cr_prefix_attach_pac
    u_cr_prefix_attach_pac  
      (
       
       .pac_stall                       (pac_stall),
       .pac_phd_check_valid_ack         (pac_phd_check_valid_ack),
       .pac_pfd_check_valid_ack         (pac_pfd_check_valid_ack),
       .pac_usr_ob_wr                   (pac_usr_ob_wr),
       .pac_usr_ob_tlv                  (pac_usr_ob_tlv),
       
       .clk                             (clk),
       .rst_n                           (rst_n),
       .cceip_cfg                       (cceip_cfg),
       .pfd_mem_dout                    (pfd_mem_dout),
       .phd_mem_dout                    (phd_mem_dout),
       .ibp_ld_phd_crc_addr             (ibp_ld_phd_crc_addr),
       .ibp_ld_pfd_crc_addr             (ibp_ld_pfd_crc_addr),
       .ibp_tlv                         (ibp_tlv),
       .ibp_tlv_valid                   (ibp_tlv_valid),
       .ibp_insert_phd_req              (ibp_insert_phd_req),
       .ibp_insert_pfd_req              (ibp_insert_pfd_req),
       .ibp_insert_true                 (ibp_insert_true),
       .pmc_phd_crc_error               (pmc_phd_crc_error),
       .pmc_pfd_crc_error               (pmc_pfd_crc_error),
       .pmc_phd_check_valid             (pmc_phd_check_valid),
       .pmc_pfd_check_valid             (pmc_pfd_check_valid),
       .pmc_phd_crc_valid               (pmc_phd_crc_valid),
       .pmc_pfd_crc_valid               (pmc_pfd_crc_valid),
       .pmc_phd_crc                     (pmc_phd_crc[31:0]),
       .pmc_pfd_crc                     (pmc_pfd_crc[31:0]),
       .usr_ob_full                     (usr_ob_full),
       .usr_ob_afull                    (usr_ob_afull));
  
      
  
  
  
  

  cr_prefix_attach_pti
    u_cr_prefix_attach_pti  
      (
       
       .pti_insert_phd_inwrk            (pti_insert_phd_inwrk),
       .pti_insert_pfd_inwrk            (pti_insert_pfd_inwrk),
       .pti_insert_pfd_ack              (pti_insert_pfd_ack),
       .pti_usr_ob_sel                  (pti_usr_ob_sel),
       .pti_usr_ob_wr                   (pti_usr_ob_wr),
       .pti_usr_ob_tlv                  (pti_usr_ob_tlv),
       
       .clk                             (clk),
       .rst_n                           (rst_n),
       .cceip_cfg                       (cceip_cfg),
       .ibp_insert_phd_req              (ibp_insert_phd_req),
       .ibp_insert_pfd_req              (ibp_insert_pfd_req),
       .ibp_tlv                         (ibp_tlv),
       .ibp_tlv_valid                   (ibp_tlv_valid),
       .ibp_prefix_num                  (ibp_prefix_num[5:0]),
       .pfd_mem_dout                    (pfd_mem_dout),
       .phd_mem_dout                    (phd_mem_dout),
       .pmc_phd_crc                     (pmc_phd_crc[31:0]),
       .pmc_pfd_crc                     (pmc_pfd_crc[31:0]),
       .pmc_phd_eot                     (pmc_phd_eot),
       .pmc_pfd_eot                     (pmc_pfd_eot),
       .pmc_phd_dout_valid              (pmc_phd_dout_valid),
       .pmc_pfd_dout_valid              (pmc_pfd_dout_valid));
     
end
endgenerate
endmodule 









