/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


















`include "crPKG.svp"
`include "cr_prefix_attach.vh"

module cr_prefix_attach_ibp 
  (
  
  usr_ib_rd, ibp_ld_phd_crc_addr, ibp_ld_pfd_crc_addr, ibp_prefix_num,
  ibp_prefix_valid, ibp_inc_pfd_addr, ibp_inc_phd_addr,
  ibp_insert_phd_req, ibp_insert_pfd_req, ibp_tlv, ibp_tlv_valid,
  ibp_insert_true,
  
  clk, rst_n, cceip_cfg, usr_ib_empty, usr_ib_aempty, usr_ib_tlv,
  pmc_phd_crc_valid, pmc_pfd_crc_valid, pac_stall,
  pti_insert_phd_inwrk, pti_insert_pfd_inwrk, pti_insert_pfd_ack,
  usr_ob_afull
  );
            
`include "cr_structs.sv"
      
  import cr_prefix_attachPKG::*;
  import cr_prefix_attach_regsPKG::*;

  
  
  
  input                clk;
  input                rst_n; 
        
  
  
  
  input                cceip_cfg;
  
  
  
  
  output logic         usr_ib_rd;
  input  logic         usr_ib_empty;
  input  logic         usr_ib_aempty;
  input  tlvp_if_bus_t usr_ib_tlv;
  

  
  
  
  input  logic         pmc_phd_crc_valid;
  input  logic         pmc_pfd_crc_valid;
  
  output logic         ibp_ld_phd_crc_addr;
  output logic         ibp_ld_pfd_crc_addr;
  output logic [5:0]   ibp_prefix_num;
  output logic         ibp_prefix_valid;
  output logic         ibp_inc_pfd_addr;
  output logic         ibp_inc_phd_addr;

  output logic         ibp_insert_phd_req;
  output logic         ibp_insert_pfd_req;
  

  
  
  
  output tlvp_if_bus_t ibp_tlv;
  output logic         ibp_tlv_valid;
  input                pac_stall;
  input                pti_insert_phd_inwrk;
  input                pti_insert_pfd_inwrk;
  input                pti_insert_pfd_ack;
  input                usr_ob_afull;
  output logic         ibp_insert_true;
  
  

  
`define XP10_ID 32'hC039E510
  
  
  
  


  
  
  tlvp_if_bus_t        ibp_tlv0;
  logic                ibp_tlv0_valid;
  tlvp_if_bus_t        ibp_tlv1;
  logic                ibp_tlv1_valid;
  tlv_word_0_t         ibp_usr_ib_tlv_word_0;
  tlv_cmd_word_2_t     ibp_usr_ib_tlv_word_2;
  logic [13:0]         ibp_word_num;
  logic                ibp_pfd_crc_wait;
  logic                ibp_phd_crc_wait;
  logic                ibp_pipe_stall;
  logic [5:0]          ibp_prefix_num_d;
  logic                ibp_prefix_valid_d;
  logic [5:0]          ibp_prefix_num_r;
  logic                ibp_prefix_r_valid;
  logic                ibp_dunkw1_stall;
  
  
  
  frmd_coding_e             ibp_frmd_coding;
  fmd_int_app_word6_t       ibp_fmd_int_app_word6;
  
  assign ibp_usr_ib_tlv_word_0 = tlv_word_0_t'(usr_ib_tlv.tdata);
  assign ibp_usr_ib_tlv_word_2 = tlv_cmd_word_2_t'(usr_ib_tlv.tdata);
  
  
  assign ibp_fmd_int_app_word6      = fmd_int_app_word6_t'(usr_ib_tlv);
  
  assign ibp_tlv = ibp_tlv1;
  assign ibp_tlv_valid = ibp_tlv1_valid;
  
  assign ibp_prefix_valid = ibp_prefix_valid_d | ibp_prefix_r_valid;

  always@(*) begin
    
    if(ibp_prefix_r_valid) begin
      ibp_prefix_num = ibp_prefix_num_r;
    end
    else begin
      ibp_prefix_num = ibp_prefix_num_d;
    end
    
    
    if(cceip_cfg) begin
      
      ibp_ld_phd_crc_addr = usr_ib_tlv.sot & (usr_ib_tlv.typen == PHD) & ibp_insert_phd_req;
      ibp_ld_pfd_crc_addr = usr_ib_tlv.sot & (usr_ib_tlv.typen == PFD) & ibp_insert_pfd_req;
      ibp_inc_phd_addr = usr_ib_rd & ~usr_ib_tlv.sot & (usr_ib_tlv.typen == PHD) & ibp_insert_phd_req;
      ibp_inc_pfd_addr = usr_ib_rd & ~usr_ib_tlv.sot & (usr_ib_tlv.typen == PFD) & ibp_insert_pfd_req; 
      ibp_prefix_num_d = ibp_usr_ib_tlv_word_0.resv0[5:0];
      ibp_prefix_valid_d = usr_ib_tlv.sot & ((usr_ib_tlv.typen == PHD) | (usr_ib_tlv.typen == PFD)) & ibp_insert_pfd_req;
    end
    else begin
      
      
      ibp_inc_phd_addr = pti_insert_phd_inwrk & ~usr_ob_afull;
      ibp_inc_pfd_addr = pti_insert_pfd_inwrk & ~usr_ob_afull; 
      ibp_prefix_valid_d = (ibp_word_num==13'd1) & (usr_ib_tlv.typen == DATA_UNK);
      if((ibp_frmd_coding==XP10CFH4K) || (ibp_frmd_coding==XP10CFH8K)) begin
        ibp_ld_phd_crc_addr = (ibp_word_num==13'd1) & (usr_ib_tlv.typen==DATA_UNK) & (usr_ib_tlv.tdata[21:16]!=6'd0) & ~ibp_insert_phd_req;
        ibp_ld_pfd_crc_addr = ibp_insert_pfd_req & pmc_phd_crc_valid; 
        ibp_prefix_num_d = usr_ib_tlv.tdata[21:16];
      end
      
      
      
      
      
      
      else if (ibp_frmd_coding==PARSEABLE) begin
        ibp_ld_phd_crc_addr = (ibp_word_num==13'd1) & 
                              (usr_ib_tlv.typen==DATA_UNK) & 
                              (usr_ib_tlv.tdata[31:0]==`XP10_ID) &
                              (usr_ib_tlv.tdata[37:36] == 2'b11) & 
                              ~ibp_insert_phd_req;
        
        ibp_ld_pfd_crc_addr = ((ibp_word_num==13'd1) & 
                               (usr_ib_tlv.typen==DATA_UNK) & 
                              (usr_ib_tlv.tdata[31:0]==`XP10_ID) & 
                               (usr_ib_tlv.tdata[37:36] ==2'b10) & 
                               ~ibp_insert_pfd_req) |
                              (ibp_insert_pfd_req & pmc_phd_crc_valid);
 
        ibp_prefix_num_d = usr_ib_tlv.tdata[43:38];
      end
      else begin
        ibp_ld_phd_crc_addr = 1'b0;
        ibp_ld_pfd_crc_addr = 1'b0;
        ibp_prefix_num_d = 0;
      end
    end 
  end 
  


  
  
  
  assign ibp_insert_true = ~cceip_cfg & (ibp_insert_phd_req | ibp_insert_pfd_req) & ~pti_insert_pfd_ack;
  
  assign ibp_pipe_stall = ibp_phd_crc_wait | ibp_pfd_crc_wait | pac_stall | ibp_insert_true | ibp_dunkw1_stall;
  assign usr_ib_rd = ~usr_ib_empty & ~usr_ob_afull & ~ibp_pipe_stall;
  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      ibp_tlv0   <= 0;
      ibp_tlv0_valid <= 1'b0;
      
      ibp_tlv1   <= 0;
      ibp_tlv1_valid <= 1'b0;
      
      
      ibp_frmd_coding <= PARSEABLE;
      ibp_word_num <= 14'd0;
      ibp_phd_crc_wait <= 1'b0;
      ibp_pfd_crc_wait <= 1'b0;
      ibp_insert_phd_req <= 1'b0;
      ibp_insert_pfd_req <= 1'b0;
      
      ibp_prefix_num_r <= 0;
      ibp_prefix_r_valid <= 1'b0;
      ibp_dunkw1_stall <=1'b0;
    
      
    end 
    else begin
      if(ibp_prefix_valid_d) begin
        ibp_prefix_num_r <= ibp_prefix_num_d;
        ibp_prefix_r_valid <= 1'b1;
      end
      else if (usr_ib_rd && (usr_ib_tlv.typen==FTR) && usr_ib_tlv.sot) begin
        ibp_prefix_r_valid <= 1'b0;
      end
      
      
      
      
      if (pmc_phd_crc_valid) begin
        ibp_phd_crc_wait <= 1'b0;
      end
      else if(ibp_ld_phd_crc_addr) begin
        ibp_phd_crc_wait <= 1'b1;
      end
           
      if (pmc_pfd_crc_valid) begin
        ibp_pfd_crc_wait <= 1'b0;
      end
      else if(ibp_ld_pfd_crc_addr) begin
        ibp_pfd_crc_wait <= 1'b1;
      end
      
      
      
      if(usr_ib_rd & usr_ib_tlv.eot) begin
        ibp_word_num <= 14'd0;
      end
      else if(usr_ib_rd && ~ibp_word_num[13]) begin
        ibp_word_num <= ibp_word_num + 1'b1;
      end
       
      
      
      
      if(~cceip_cfg & pti_insert_pfd_ack) begin
        ibp_insert_phd_req <= 1'b0;
        ibp_insert_pfd_req <= 1'b0;
      end
      
      
      
      
      if(usr_ib_rd && (usr_ib_tlv.typen==DATA_UNK) && (ibp_word_num== 13'd1)) begin
        ibp_dunkw1_stall <=1'b1;
      end
      else  begin
        ibp_dunkw1_stall <=1'b0;
      end
      
      
      
      
      if(usr_ib_rd) begin
        
        ibp_tlv0   <= usr_ib_tlv;
        
        case (usr_ib_tlv.typen)
          CMD:
            begin
              ibp_tlv0_valid <= 1'b0;
              if (usr_ib_tlv.eot && cceip_cfg) begin
                ibp_insert_phd_req <= (ibp_usr_ib_tlv_word_2.xp10_prefix_mode==PREDET_HUFF);
                ibp_insert_pfd_req <= ((ibp_usr_ib_tlv_word_2.xp10_prefix_mode==PREDET_HUFF) |
                                   (ibp_usr_ib_tlv_word_2.xp10_prefix_mode==PREDEF_PREFIX));
              end
            end
          PHD,
          PFD:
            begin
              ibp_tlv0_valid <= 1'b1;
            end
          

          FRMD_INT_APP,
          FRMD_INT_SIP,
          FRMD_INT_LIP,
          FRMD_INT_VM,
          FRMD_INT_VM_SHORT: 
            begin
              ibp_tlv0_valid <= 1'b0;
              if(usr_ib_tlv.eot) begin
                ibp_frmd_coding <= ibp_fmd_int_app_word6.coding;
              end
            end
           

          
          DATA_UNK:
            begin
              ibp_tlv0_valid <= 1'b1;
                
              if(ibp_word_num== 13'd1) begin
                if((ibp_frmd_coding==XP10CFH4K) || (ibp_frmd_coding==XP10CFH8K)) begin
                  ibp_insert_phd_req <= (usr_ib_tlv.tdata[21:16]!=6'd0);
                  ibp_insert_pfd_req <= (usr_ib_tlv.tdata[21:16]!=6'd0);
                end
                else if((ibp_frmd_coding==PARSEABLE) && (usr_ib_tlv.tdata[31:0]==`XP10_ID) && (usr_ib_tlv.tdata[43:38]!=6'd0)) begin
                  ibp_insert_phd_req <= (usr_ib_tlv.tdata[37:36]==PREDET_HUFF);
                  ibp_insert_pfd_req <= ((usr_ib_tlv.tdata[37:36]==PREDET_HUFF) |
                                     (usr_ib_tlv.tdata[37:36]==PREDEF_PREFIX));
                end
              end 
              
            end 
          FTR:
            begin
              ibp_tlv0_valid <= 1'b1;
            end
          
          default:
            begin
              ibp_tlv0_valid <= 1'b1;
            end
        endcase 
      end 
      else begin
        ibp_tlv0_valid <= 1'b0;
      end 
      
        
      
      
      
      ibp_tlv1 <= ibp_tlv0;
      ibp_tlv1_valid <= ibp_tlv0_valid;
      

      
    end 
  end 
  
  
  

endmodule 









