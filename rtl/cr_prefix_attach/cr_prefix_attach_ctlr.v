/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


















`include "crPKG.svp"
`include "cr_prefix_attach.vh"

module cr_prefix_attach_ctlr 
  (
  
  usr_ib_rd, pfd_mem_addr, pfd_mem_cs, phd_mem_addr, phd_mem_cs,
  usr_ob_wr, usr_ob_tlv,
  
  clk, rst_n, usr_ib_empty, usr_ib_aempty, usr_ib_tlv, pfd_mem_dout,
  phd_mem_dout, usr_ob_full, usr_ob_afull
  );
            
`include "cr_structs.sv"
      
  import cr_prefix_attachPKG::*;
  import cr_prefix_attach_regsPKG::*;

  
  
  
  input                clk;
  input                rst_n; 
        
  
  
  
 
  
  
  
  output logic         usr_ib_rd;
  input  logic         usr_ib_empty;
  input  logic         usr_ib_aempty;
  input  tlvp_if_bus_t usr_ib_tlv;
   
  
  
  
  input  pfd_t                              pfd_mem_dout;
  output [`LOG_VEC(`CR_PREFIX_PFD_ENTRIES)] pfd_mem_addr;
  output logic                              pfd_mem_cs;
  
  
  
  
  input  phd_t                              phd_mem_dout;
  output [`LOG_VEC(`CR_PREFIX_PHD_ENTRIES)] phd_mem_addr;
  output logic                              phd_mem_cs;
  
  
  
  
  
  input                usr_ob_full;
  input                usr_ob_afull; 
  output logic         usr_ob_wr;
  output tlvp_if_bus_t usr_ob_tlv;



  
  logic [5:0]          pac_prefix_num ;
  
  tlvp_if_bus_t        pac_usr_tlv0;
  logic                pac_usr_valid0;
      
  logic                pac_pfdcounter_zero;
  logic                pac_pfdcounter_max;
  logic                pac_phdcounter_zero;
  logic                pac_phdcounter_max;
  logic [7:0]          pac_pfdcounter;
  logic [7:0]          pac_phdcounter;
  logic                pac_usr_wr_ok;
  logic                pac_sotp1;
  logic                pac_usr_w01;
  
 
  assign pfd_mem_cs = 1'b1;
  assign phd_mem_cs = 1'b1;
  
  assign pfd_mem_addr = {pac_prefix_num,pac_pfcounter};
  assign phd_mem_addr = {pac_prefix_num,pac_hfcounter};
  
  assign pac_phdcounter_max  = (pac_phdcounter == `N_PHD_WORDS);
  assign pac_pfdcounter_max  = (pac_pfdcounter == `N_PFD_WORDS); 
 
  assign pac_usr_w01 = pac_usr_tlv0.sot | pac_sotp1;

  
  
  
  
  
  assign usr_ib_rd = ~usr_ib_empty & ~usr_ob_full ;
  assign pac_usr_wr_ok = ~usr_ob_full & (~usr_ob_afull | ~usr_ob_wr);
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      pac_usr_tlv0   <= 0;
      pac_usr_valid0 <= 1'b0;

      usr_ob_tlv     <= 0;
      usr_ob_wr      <= 1'b0;
      
      pac_prefix_num <= 0;
      pac_pfdcounter <= 0;
      pac_phdcounter <= 0;
      pac_sotp1      <= 1'b0;
      
      
    end
    else begin      
      
      if(usr_ib_rd) begin
        pac_usr_tlv0   <= usr_ib_tlv;
      end
      pac_usr_valid0 <= usr_ib_rd;
      
      if(pac_usr_valid0) begin
        case(pac_usr_tlv0.typen)
          PHD:
            begin
              if(pac_usr_w01) begin
                usr_ob_tlv <= pac_usr_tlv0;
                pac_prefix_num <= pac_usr_tlv0.tdata[5:0];
              end
              else begin
                usr_ob_tlv <= phd_mem_dout;
              end
              
              usr_ob_wr <= 1'b1;
              pac_sotp1 <= pac_usr_tlv0.sot;
            end 
          
          PFD:
            begin
              if(pac_usr_w01) begin
                usr_ob_tlv <= pac_usr_tlv0;
                pac_prefix_num <= pac_usr_tlv0.tdata[5:0];
              end
              else begin
                usr_ob_tlv <= pfd_mem_dout;
              end
              
              usr_ob_wr <= 1'b1;
              pac_sotp1 <= pac_usr_tlv0.sot;
            end 
          
          default:
            begin
              usr_ob_tlv <= pac_usr_tlv0;
              usr_ob_wr <= 1'b1;
              pac_prefix_num <= 0;
            end
        endcase 
      end 
      else begin
        usr_ob_wr <= 1'b0;
      end 
            
      
      
      
      if(pac_phdcounter_max) begin
        pac_phdcounter <= 0;
      end
      else if (pac_usr_wr_ok & (pac_usr_tlv0.typen == PHD) & ~pac_usr_w01) begin
        pac_phdcounter <= pac_phdcounter + 1'b1;
      end
       
      
      
      
      if(pac_pfdcounter_max) begin
        pac_pfdcounter <= 0;
      end
      else if (pac_usr_wr_ok && (pac_usr_tlv0.typen == PFD)& ~pac_usr_w01) begin
        pac_pfdcounter <= pac_pfdcounter + 1'b1;
      end
           
    end 
  end 
  

endmodule 









