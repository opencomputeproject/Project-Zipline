/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


















`include "crPKG.svp"
`include "cr_prefix_attach.vh"

module cr_prefix_attach_pmc 
  (
  
  pfd_mem_addr, pfd_mem_cs, phd_mem_addr, phd_mem_cs,
  pmc_phd_crc_error, pmc_pfd_crc_error, pmc_phd_check_valid,
  pmc_pfd_check_valid, pmc_phd_crc_valid, pmc_pfd_crc_valid,
  pmc_phd_crc, pmc_pfd_crc, pmc_phd_eot, pmc_pfd_eot,
  pmc_phd_dout_valid, pmc_pfd_dout_valid,
  
  clk, rst_n, cceip_cfg, pfd_mem_dout, phd_mem_dout,
  ibp_ld_phd_crc_addr, ibp_ld_pfd_crc_addr, ibp_prefix_num,
  ibp_prefix_valid, ibp_inc_pfd_addr, ibp_inc_phd_addr,
  pti_insert_pfd_ack, pac_phd_check_valid_ack,
  pac_pfd_check_valid_ack
  );
            
`include "cr_structs.sv"
      
  import cr_prefix_attachPKG::*;
  import cr_prefix_attach_regsPKG::*;

  
  
  
  input                                           clk;
  input                                           rst_n; 
        
  
  
  
  input                                           cceip_cfg;

  
  
  
  input  pfd_t                                    pfd_mem_dout;
  output logic [`LOG_VEC(`CR_PREFIX_PFD_ENTRIES)] pfd_mem_addr;
  output logic                                    pfd_mem_cs;
  
  
  
  
  input  phd_t                                    phd_mem_dout;
  output logic [`LOG_VEC(`CR_PREFIX_PHD_ENTRIES)] phd_mem_addr;
  output logic                                    phd_mem_cs;

  
  
  
  input logic                                     ibp_ld_phd_crc_addr;
  input logic                                     ibp_ld_pfd_crc_addr;
  input logic [5:0]                               ibp_prefix_num;
  input logic                                     ibp_prefix_valid;
  input logic                                     ibp_inc_pfd_addr;
  input logic                                     ibp_inc_phd_addr;
 
  
  
  
  output logic                                    pmc_phd_crc_error;
  output logic                                    pmc_pfd_crc_error;
  output logic                                    pmc_phd_check_valid;
  output logic                                    pmc_pfd_check_valid;
  output logic                                    pmc_phd_crc_valid;
  output logic                                    pmc_pfd_crc_valid;
  output logic [31:0]                             pmc_phd_crc;
  output logic [31:0]                             pmc_pfd_crc;
  output logic                                    pmc_phd_eot;
  output logic                                    pmc_pfd_eot;
  output logic                                    pmc_phd_dout_valid;
  output logic                                    pmc_pfd_dout_valid;
  
  input                                           pti_insert_pfd_ack;
  input                                           pac_phd_check_valid_ack;
  input                                           pac_pfd_check_valid_ack;
  
  
  `CCX_STD_DECLARE_CRC(crc32_xp,32'd`XP10CRC32_POLYNOMIAL, 32, 64) 
  
  
  
  logic                                           pmc_ld_phd_crc_addr_r;
  logic                                           pmc_ld_pfd_crc_addr_r;
  logic [11:0]                                    pmc_phd_base;
  logic [7:0]                                     pmc_pfdcounter;
  logic [7:0]                                     pmc_phdcounter;
  logic                                           pmc_phd_eod;
  logic                                           pmc_pfd_eod;
  logic [31:0]                                    pmc_phd_xp10_crc32;
  logic [31:0]                                    pmc_pfd_xp10_crc32;
  
  logic                                           pmc_inc_phd_addr_r;
  logic                                           pmc_inc_pfd_addr_r;
  logic [31:0]                                    pmc_phd_crc_check_value;
  logic [31:0]                                    pmc_pfd_crc_check_value;
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  always_comb begin
    phd_mem_cs = ibp_prefix_valid ;
    pfd_mem_cs = ibp_prefix_valid ;
    pmc_phd_crc_check_value = ~pmc_phd_crc;
    pmc_pfd_crc_check_value = ~pmc_pfd_crc;
    
  end 
  
   
  always_comb begin 
    if(ibp_ld_phd_crc_addr) begin
      pfd_mem_addr = {6'd0,1'b1,ibp_prefix_num};
    end
    else if(ibp_ld_pfd_crc_addr) begin
      pfd_mem_addr = {6'd0,1'b0,ibp_prefix_num};
    end
    else begin
      pfd_mem_addr = {ibp_prefix_num,pmc_pfdcounter[6:0]};
    end
    
    
    phd_mem_addr = (pmc_phd_base + pmc_phdcounter[6:0]);
    
  end 

 
  assign pmc_phd_crc_error = (pmc_phd_xp10_crc32 != pmc_phd_crc_check_value) & pmc_phd_check_valid;
  assign pmc_pfd_crc_error = (pmc_pfd_xp10_crc32 != pmc_pfd_crc_check_value) & pmc_pfd_check_valid;
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      pmc_phd_base <= 0;
      pmc_pfdcounter <= 0;
      pmc_phdcounter <= 0;
      
      pmc_ld_phd_crc_addr_r <= 1'b0;
      pmc_phd_crc_valid <= 1'b0;
      pmc_ld_pfd_crc_addr_r <= 1'b0;
      pmc_pfd_crc_valid <= 1'b0;
      
      pmc_phd_xp10_crc32 <= 32'hffff_ffff;
      pmc_pfd_xp10_crc32 <= 32'hffff_ffff;
      
      pmc_phd_crc  <= 0;
      pmc_pfd_crc  <= 0;
      
      pmc_phd_eod <= 0;
      pmc_pfd_eod <= 0;
      pmc_phd_eot <= 0;
      pmc_pfd_eot <= 0;
      
      pmc_inc_phd_addr_r <= 1'b0;
      pmc_phd_dout_valid <= 1'b0;
      pmc_inc_pfd_addr_r <= 1'b0;
      pmc_pfd_dout_valid <= 1'b0;
      
      pmc_phd_check_valid <= 1'b0;
      pmc_pfd_check_valid <= 1'b0;
      
      
    end
    else begin  
      pmc_phd_base <= ((ibp_prefix_num-1) * 65);
      
      pmc_ld_phd_crc_addr_r <= ibp_ld_phd_crc_addr;
      pmc_ld_pfd_crc_addr_r <= ibp_ld_pfd_crc_addr;
      pmc_phd_crc_valid <= pmc_ld_phd_crc_addr_r;
      pmc_pfd_crc_valid <= pmc_ld_pfd_crc_addr_r;
      
      
      pmc_phd_eot <= pmc_phd_eod & pmc_phd_dout_valid;
      pmc_pfd_eot <= pmc_pfd_eod & pmc_pfd_dout_valid;

      pmc_inc_phd_addr_r <= ibp_inc_phd_addr;
      pmc_phd_dout_valid <= pmc_inc_phd_addr_r & ~pmc_phd_eod;
        
      
      pmc_inc_pfd_addr_r <= ibp_inc_pfd_addr;
      pmc_pfd_dout_valid <= pmc_inc_pfd_addr_r & ~pmc_pfd_eod;

      
      
      
      if(pmc_phd_crc_valid) begin
        pmc_phd_crc <= pfd_mem_dout[31:0];
      end
      
      if(pmc_pfd_crc_valid) begin
        pmc_pfd_crc <= pfd_mem_dout[31:0];
      end
      
      
      
      
      
      if(pmc_phd_eod & pmc_phd_dout_valid) begin
        pmc_phd_check_valid <= 1'b1;
      end
      else if (pac_phd_check_valid_ack) begin
        pmc_phd_check_valid <= 1'b0;
      end
 
      if(pmc_pfd_eod & pmc_pfd_dout_valid) begin
        pmc_pfd_check_valid <= 1'b1;
      end
      else if (pac_pfd_check_valid_ack) begin
        pmc_pfd_check_valid <= 1'b0;
      end     
      
      if(pac_phd_check_valid_ack) begin
        pmc_phd_xp10_crc32 <= 32'hffff_ffff;
      end
      else if(pmc_phd_dout_valid) begin
        pmc_phd_xp10_crc32 <= crc32_xp(phd_mem_dout, pmc_phd_xp10_crc32, 64);
      end
      
      if(pac_pfd_check_valid_ack) begin
        pmc_pfd_xp10_crc32 <= 32'hffff_ffff;
      end
      else if(pmc_pfd_dout_valid) begin
        pmc_pfd_xp10_crc32 <= crc32_xp(pfd_mem_dout, pmc_pfd_xp10_crc32, 64);
      end
 
 
      
      
      
      

      if(ibp_ld_phd_crc_addr || (~cceip_cfg && pti_insert_pfd_ack)) begin
        pmc_phdcounter <= 0;
      end
      else if (ibp_inc_phd_addr) begin
        pmc_phdcounter <= pmc_phdcounter + 1'b1;
      end
      
      if(ibp_ld_phd_crc_addr || (~cceip_cfg && pti_insert_pfd_ack)) begin
        pmc_phd_eod <= 1'b0;
      end 
      else if(pmc_phdcounter == (`CR_PREFIX_N_PHD_WORDS -2)) begin
        pmc_phd_eod <= 1'b1;
      end

      
      
      
      

      if(ibp_ld_pfd_crc_addr || (~cceip_cfg && pti_insert_pfd_ack)) begin
        pmc_pfdcounter <= 0;
      end
      else if (ibp_inc_pfd_addr) begin
        pmc_pfdcounter <= pmc_pfdcounter + 1'b1;
      end
      
      if(ibp_ld_pfd_crc_addr || (~cceip_cfg && pti_insert_pfd_ack)) begin
        pmc_pfd_eod <= 1'b0;
      end
      else if(pmc_pfdcounter == (`CR_PREFIX_N_PFD_WORDS -2)) begin
        pmc_pfd_eod <= 1'b1;
      end
      
    end 
  end 
  

endmodule 









