/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/






















`include "crPKG.svp"
`include "cr_prefix.vh"

module cr_prefix_ibc 
  (
  
  usr_ib_rd, ibc_bp_tlv, ibc_bp_tlv_valid, ibc_data_tlv,
  ibc_data_vbytes, ibc_blk_sel, ibc_ctr_reload, ibc_ctr_1_wr,
  ibc_ctr_2_wr, ibc_ctr_3_wr, ibc_ctr_4_wr,
  
  clk, rst_n, usr_ib_empty, usr_ib_aempty, usr_ib_tlv, bp_tlv_full,
  bp_tlv_afull, fe_ctr_1_ib_full, fe_ctr_1_ib_afull, fe_ctr_2_ib_full,
  fe_ctr_2_ib_afull, fe_ctr_3_ib_full, fe_ctr_3_ib_afull,
  fe_ctr_4_ib_full, fe_ctr_4_ib_afull
  );
            
`include "cr_structs.sv"
      
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;

  
  
  
  input                clk;
  input                rst_n; 
        
  
  
  
  output logic         usr_ib_rd;
  input  logic         usr_ib_empty;
  input  logic         usr_ib_aempty;
  input  tlvp_if_bus_t usr_ib_tlv;
  
  
  
  
  input                bp_tlv_full;
  input                bp_tlv_afull;
  
  output tlvp_if_bus_t ibc_bp_tlv;
  output logic         ibc_bp_tlv_valid;
  
  
  
  
  output tlvp_if_bus_t ibc_data_tlv;
  output logic [7:0]   ibc_data_vbytes;
  output logic [1:0]   ibc_blk_sel;
  output logic         ibc_ctr_reload;
  
  
  
  
  input                fe_ctr_1_ib_full;
  input                fe_ctr_1_ib_afull;
  input                fe_ctr_2_ib_full;
  input                fe_ctr_2_ib_afull;
  input                fe_ctr_3_ib_full;
  input                fe_ctr_3_ib_afull;
  input                fe_ctr_4_ib_full;
  input                fe_ctr_4_ib_afull;
  output logic         ibc_ctr_1_wr;
  output logic         ibc_ctr_2_wr;
  output logic         ibc_ctr_3_wr;
  output logic         ibc_ctr_4_wr;
  

 
`define PREFIX_BLK_SIZE 127 

  
  
  
  logic                usr_ib_tlv_eodb;
  
  tlvp_if_bus_t        ibc_usr_ib_tlv0;
  logic                ibc_usr_ib_tlv0_valid;
  logic                ibc_usr_ib_tlv0_eodb;
  
  tlv_cmd_word_2_t     ibc_usr_ib_tlv0_word_2_data; 
  logic                ibc_insert_pfd_tlv; 
  
  logic                ibc_data_tlv_valid;
  logic                ibc_data_tlv_eodb;
  logic                ibc_data_tlv_eodb1;
  
  logic                ibc_stall;
  logic                ibc_busy;
  logic [7:0]          ibc_wd_counter;
  
  logic                ibc_fe_ctr_ib_full;
  logic                ibc_wr_ctr;
  logic                ibc_wr_ctr_en;
  
  
  
  
  assign ibc_usr_ib_tlv0_word_2_data = tlv_cmd_word_2_t'(ibc_usr_ib_tlv0.tdata);
  
  
  
  
  
  
  
  
  
  
  
 assign ibc_fe_ctr_ib_full = fe_ctr_1_ib_full |
                             fe_ctr_2_ib_full |
                             fe_ctr_3_ib_full |
                             fe_ctr_4_ib_full;
  
  assign ibc_stall = bp_tlv_full | (bp_tlv_afull  & ibc_bp_tlv_valid) | ibc_fe_ctr_ib_full;
  assign usr_ib_rd = ~usr_ib_empty & ~ibc_stall & ~ibc_busy ;
  
  assign usr_ib_tlv_eodb = usr_ib_rd && 
                           (usr_ib_tlv.typen==DATA_UNK) && 
                           (usr_ib_tlv.eot || (ibc_wd_counter==8'd0));
  
 
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      
      ibc_usr_ib_tlv0 <= 0;
      ibc_usr_ib_tlv0_valid <= 1'b0;
      ibc_usr_ib_tlv0_eodb <= 1'b0;
      ibc_insert_pfd_tlv <= 1'b0;
     
      ibc_data_tlv <= 0;
      ibc_data_tlv_valid <= 1'b0;
      ibc_data_vbytes    <= 8'd0;
      ibc_data_tlv_eodb  <= 1'b0;
      ibc_data_tlv_eodb1 <= 1'b0;
      
      
      ibc_bp_tlv <= 0;
      ibc_bp_tlv_valid <= 1'b0;

      ibc_busy <= 1'b0;
      ibc_wd_counter <= `PREFIX_BLK_SIZE;
      
        
      ibc_blk_sel <= 2'b0;

      ibc_ctr_reload <= 1'b0;
      ibc_wr_ctr_en <= 1'b0;
      ibc_wr_ctr <= 1'b0;
      ibc_ctr_1_wr <= 1'b0;
      ibc_ctr_2_wr <= 1'b0;
      ibc_ctr_3_wr <= 1'b0;
      ibc_ctr_4_wr <= 1'b0;
      
    end
    else begin
      
      
      
      if(usr_ib_rd) begin
        ibc_usr_ib_tlv0       <= usr_ib_tlv;
      end
      if(~ibc_stall) begin
        ibc_usr_ib_tlv0_valid <= usr_ib_rd;
      end
      
      
      
      
      ibc_usr_ib_tlv0_eodb <= usr_ib_tlv_eodb;
      ibc_data_tlv_eodb    <= ibc_usr_ib_tlv0_eodb;
      ibc_data_tlv_eodb1   <= ibc_data_tlv_eodb;
      
      ibc_ctr_reload       <= ibc_data_tlv_eodb1 & ibc_wr_ctr_en;
      ibc_wr_ctr           <= ibc_data_tlv_eodb1 & ibc_wr_ctr_en;
      
      
      
      
      
      if (usr_ib_tlv_eodb  && ibc_wr_ctr_en) begin
        ibc_busy <= 1'b1;
      end
      else if (ibc_wr_ctr) begin 
        ibc_busy <= 1'b0;
      end
      
      
      
      
      
      if((usr_ib_rd && usr_ib_tlv.sot) || usr_ib_tlv_eodb) begin
        ibc_wd_counter <= `PREFIX_BLK_SIZE;
      end
      else if(usr_ib_rd && (usr_ib_tlv.typen==DATA_UNK)) begin
        ibc_wd_counter <= ibc_wd_counter - 1'b1;
      end

      
      
      
      if (usr_ib_rd && usr_ib_tlv.sot) begin
        ibc_blk_sel <= 2'b00;
      end
      else if(ibc_wr_ctr) begin
        ibc_blk_sel <= ibc_blk_sel + 1'b1;
      end

      
      
      
      if (usr_ib_rd && usr_ib_tlv.sot && ibc_insert_pfd_tlv &&
          (usr_ib_tlv.typen==DATA_UNK))
      begin
        ibc_wr_ctr_en <= 1'b1;
      end
      
      else if (ibc_wr_ctr && (ibc_usr_ib_tlv0.eot || (ibc_blk_sel==2'b11))) begin
        ibc_wr_ctr_en <= 1'b0;
      end
      
      

      
      
      
      if(ibc_usr_ib_tlv0.eot && ibc_wr_ctr) begin
        case (ibc_blk_sel) 
           2'b00: begin
             ibc_ctr_1_wr <= 1'b1;
             ibc_ctr_2_wr <= 1'b1;
             ibc_ctr_3_wr <= 1'b1;
             ibc_ctr_4_wr <= 1'b1;
           end
           2'b01: begin
             ibc_ctr_1_wr <= 1'b0;
             ibc_ctr_2_wr <= 1'b1;
             ibc_ctr_3_wr <= 1'b1;
             ibc_ctr_4_wr <= 1'b1;
           end
           2'b10: begin
             ibc_ctr_1_wr <= 1'b0;
             ibc_ctr_2_wr <= 1'b0;
             ibc_ctr_3_wr <= 1'b1;
             ibc_ctr_4_wr <= 1'b1;
           end
           default: begin
             ibc_ctr_1_wr <= 1'b0;
             ibc_ctr_2_wr <= 1'b0;
             ibc_ctr_3_wr <= 1'b0;
             ibc_ctr_4_wr <= 1'b1;
           end
        endcase 
      end 
      
      else if (ibc_wr_ctr) begin
        case (ibc_blk_sel) 
          2'b00: ibc_ctr_1_wr <= 1'b1;
          2'b01: ibc_ctr_2_wr <= 1'b1;
          2'b10: ibc_ctr_3_wr <= 1'b1;
          2'b11: ibc_ctr_4_wr <= 1'b1;
        endcase 
      end
      else begin
        ibc_ctr_1_wr <= 1'b0;
        ibc_ctr_2_wr <= 1'b0;
        ibc_ctr_3_wr <= 1'b0;
        ibc_ctr_4_wr <= 1'b0;
      end 
          
      
      
      
      if(ibc_usr_ib_tlv0_valid && ~ibc_stall) begin
        case(ibc_usr_ib_tlv0.typen)
          CMD:
            begin
              ibc_bp_tlv_valid   <= 1'b1;
              ibc_data_tlv_valid <= 1'b0;
              
              ibc_bp_tlv <= ibc_usr_ib_tlv0;
              if (ibc_usr_ib_tlv0.eot) begin
                ibc_insert_pfd_tlv <= (ibc_usr_ib_tlv0_word_2_data.xp10_user_prefix_size == 0) &&
                                      ((ibc_usr_ib_tlv0_word_2_data.xp10_prefix_mode ==PREDET_HUFF) |
                                       (ibc_usr_ib_tlv0_word_2_data.xp10_prefix_mode ==PREDEF_PREFIX));
              end
            end
          
          FRMD_USER_NULL,
          FRMD_USER_PI16,
          FRMD_USER_PI64,
          FRMD_USER_VM:
            begin
              ibc_bp_tlv_valid   <= 1'b1;
              ibc_data_tlv_valid <= 1'b0;
              
              ibc_bp_tlv <= ibc_usr_ib_tlv0;
 
            end
          
          DATA_UNK:
            begin
              ibc_bp_tlv_valid   <= 1'b0;
              ibc_data_tlv_valid <= ibc_usr_ib_tlv0_valid & ibc_insert_pfd_tlv;
              
              ibc_bp_tlv <= 0;
              
              ibc_data_tlv       <= ibc_usr_ib_tlv0;
              
              
              
              if (ibc_wr_ctr_en && ~ibc_usr_ib_tlv0.sot) begin
                ibc_data_vbytes <= ibc_usr_ib_tlv0.tstrb;
              end
              else begin
                 ibc_data_vbytes <= 0;
              end
            end 
          
          default:
            begin
              ibc_bp_tlv_valid   <= 1'b1;
              ibc_data_tlv_valid <= 1'b0;
              ibc_data_tlv <= 0;
              ibc_data_vbytes    <= 8'd0;
              ibc_data_tlv_eodb  <= 1'b0;
              ibc_bp_tlv         <= ibc_usr_ib_tlv0;
              
            end
        endcase 
      end 
      
      else begin
        ibc_bp_tlv_valid   <= 1'b0;
        ibc_data_tlv_valid <= 1'b0;
        
        ibc_data_vbytes   <= 8'd0;
        ibc_data_tlv_eodb  <= 1'b0;
        ibc_data_tlv <= 0;
        ibc_bp_tlv <= 0;
      end 
    end 
  end 
  
 

endmodule 











