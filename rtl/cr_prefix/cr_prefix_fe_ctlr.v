/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


















`include "crPKG.svp"
`include "cr_prefix.vh"

module cr_prefix_fe_ctlr 
  (
  
  usr_ib_rd, fe_ctlr_cmd_tlv, fe_ctlr_cmd_tlv_valid, fe_ctlr_eodb,
  fe_sel_1k, fe_char_in, fe_char_vbytes, fe_ctlr_1k_wr, fe_ctlr_2k_wr,
  fe_ctlr_3k_wr, fe_ctlr_4k_wr,
  
  clk, rst_n, usr_ib_empty, usr_ib_aempty, usr_ib_tlv
  );
            
`include "cr_structs.sv"
      
  import cr_prefixPKG::*;
  import cr_prefix_regsPKG::*;

  
  
  
  input                clk;
  input                rst_n; 
        
  
  
  
  input logic [63:0]  ibc_char_in;
  input logic [63:0]  ibc_char_in_valid;
  input logic [7:0]   ibc_char_vbytes;
  
  output              fe_ready;
  output              fe_eodb;
  
 
  
  
  
  output logic         fe_ctlr_eodb;
  output logic [1:0]   fe_sel_1k;
  output logic [63:0]  fe_char_in;
  output logic [7:0]   fe_char_vbytes;

  output logic         fe_ctlr_1k_wr;
  output logic         fe_ctlr_2k_wr;
  output logic         fe_ctlr_3k_wr;
  output logic         fe_ctlr_4k_wr;
  

  
  logic                fe_ctlr_sw_blk;
  logic                fe_ctlr_flush_blk;
  logic                fe_ctlr_eotp1;
  logic [7:0]          fe_ctlr_1kblk_ctr;  
  logic [1:0]          fe_sel_1k_nxt;
  logic                fe_ctlr_tlv_dlen_gt4k;

  
  tlv_word_0_t         fe_ctlr_usr_ib_dw0;
  
  
  tlvp_if_bus_t        fe_ctlr_usr_ib_tlv0;
  logic                fe_ctlr_usr_ib_tlv0_valid;
  tlvp_if_bus_t        fe_ctlr_usr_ib_tlv1;
  logic                fe_ctlr_usr_ib_tlv1_valid;
  
  
  tlv_cmd_word_2_t     fe_ctlr_cmd_word_2;
  
  
  enum { IDLE,
         GET_CMD,
         WAIT_DW0,
         DATA_W0,
         DATA_BLK,
         SW_BLK,
         FLUSH,
         XX} current_state, next_state;
   
  
  
  
  assign fe_sel_1k_nxt = fe_sel_1k + 1'b1;
  assign fe_ctlr_eodb = fe_ctlr_sw_blk | (~fe_ctlr_cmd_tlv_valid & fe_ctlr_usr_ib_tlv1.eot);

  
  
  
  
  
  
  
  
  always @ *
    begin
      next_state = XX;
      case (current_state)
        IDLE:
          begin
            if(fe_ctlr_usr_ib_tlv0_valid) begin
              next_state = GET_CMD;
            end
            else begin
              next_state = IDLE;
            end
          end
        DATA_BLK: 
          begin
            if(fe_ctlr_sw_blk) begin
              next_state = SW_BLK;
            end
            else if(fe_ctlr_flush_blk) begin
              next_state = FLUSH;
            end
            else begin
              next_state = DATA_BLK;
            end
          end
        SW_BLK: 
          begin
            if(usr_ib_rd && fe_ctlr_eotp1) begin
              next_state = GET_CMD;
            end
            else if(fe_ctlr_eotp1) begin
              next_state = IDLE;
            end
            else begin
              next_state = DATA_BLK;
            end
          end 
        
        default:
          begin
              next_state = IDLE;
          end
      endcase 
    end 
  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      current_state <= IDLE;
    end
    else  begin
      current_state <= next_state;
    end
  end

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  assign ibc_char_in_valid = |ibc_char_vbytes;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      
      fe_ctlr_usr_ib_tlv0 <= 0;
      fe_ctlr_usr_ib_tlv1 <= 0;
      
      fe_ctlr_usr_ib_dw0 <= 64'd0;
      
      fe_ctlr_usr_ib_tlv0_valid <= 1'b0;
      fe_ctlr_usr_ib_tlv1_valid <= 1'b0;
      
      fe_char_in       <= 64'd0;
      fe_char_vbytes <= 8'd0;
      
      fe_ctlr_cmd_tlv_valid <= 1'b0;
      fe_ctlr_cmd_tlv <= 0;
      
      fe_ctlr_sw_blk <= 1'b0;
      fe_ctlr_flush_blk <= 1'b0;
      fe_ctlr_eotp1 <= 1'b0;
      fe_ctlr_1k_wr <= 1'b0;
      fe_ctlr_2k_wr <= 1'b0;
      fe_ctlr_3k_wr <= 1'b0;
      fe_ctlr_4k_wr <= 1'b0;
      fe_ctlr_1kblk_ctr <= 7'd0;
      fe_ctlr_tlv_dlen_gt4k <= 1'b0;
      fe_sel_1k <= 2'd0;
    end
    else begin
       case (next_state)
        IDLE:
          begin
            fe_sel_1k <= 2'd0;
            fe_ctlr_sw_blk <= 1'b0;
            fe_ctlr_cmd_tlv_valid <= 1'b0;;
            fe_char_vbytes <= 8'd0;
            
 
            fe_ctlr_1k_wr <= 1'b0;
            fe_ctlr_2k_wr <= 1'b0;
            fe_ctlr_3k_wr <= 1'b0;
            fe_ctlr_4k_wr <= 1'b0;
            
            fe_ctlr_1kblk_ctr <= 8'b10000000;
            fe_ctlr_tlv_dlen_gt4k <= 1'b0;
            

          end
         
        DATA_BLK: 
          begin
            fe_ctlr_cmd_tlv_valid <= 1'b0;
            fe_ctlr_1k_wr <= 1'b0;
            fe_ctlr_2k_wr <= 1'b0;
            fe_ctlr_3k_wr <= 1'b0;
            fe_ctlr_4k_wr <= 1'b0;
            
            if(fe_ctlr_usr_ib_tlv0_valid) begin
              
              if(fe_ctlr_1kblk_ctr != 7'd0) begin
                fe_ctlr_1kblk_ctr <= fe_ctlr_1kblk_ctr -1'b1;
              end              
              
              
              if((fe_ctlr_usr_ib_tlv0.eot || (fe_ctlr_1kblk_ctr <= 7'd1)) && ~fe_ctlr_tlv_dlen_gt4k) begin
                fe_ctlr_sw_blk <= 1'b1;
              end
              else begin
                fe_ctlr_sw_blk <= 1'b0;
              end
 
            
          end
        SW_BLK: 
          begin
            fe_ctlr_sw_blk <= 1'b0;
            fe_ctlr_cmd_tlv_valid <= 1'b0;
            fe_char_vbytes <= 8'd0;
            
            fe_sel_1k <= fe_sel_1k_nxt; 
            
            
            if(fe_ctlr_usr_ib_tlv1.eot) begin
              case (fe_sel_1k) 
                2'b00: begin
                  fe_ctlr_1k_wr <= 1'b1;
                  fe_ctlr_2k_wr <= 1'b1;
                  fe_ctlr_3k_wr <= 1'b1;
                  fe_ctlr_4k_wr <= 1'b1;
                end
                2'b01: begin
                  fe_ctlr_2k_wr <= 1'b1;
                  fe_ctlr_3k_wr <= 1'b1;
                  fe_ctlr_4k_wr <= 1'b1;
                end
                2'b10: begin
                  fe_ctlr_3k_wr <= 1'b1;
                  fe_ctlr_4k_wr <= 1'b1;
                end
                default: begin
                  fe_ctlr_4k_wr <= 1'b1;
                end
              endcase 
            end 
            
            else begin
              case (fe_sel_1k) 
                2'b00:     fe_ctlr_1k_wr <= 1'b1;
                2'b01:     fe_ctlr_2k_wr <= 1'b1;
                2'b10:     fe_ctlr_3k_wr <= 1'b1;
                default:   fe_ctlr_4k_wr <= 1'b1;
              endcase 
            end 
            
            
            fe_ctlr_1kblk_ctr <= 8'b10000000;
          end 
        FLUSH: begin;
            
            if(fe_ctlr_usr_ib_tlv0.eot) begin
              fe_ctlr_flush_blk <= 1'b0;
            end
        end
         
       
        default:
          begin
            fe_sel_1k <= 2'd0;
            fe_ctlr_sw_blk <= 1'b0;
            fe_ctlr_cmd_tlv_valid <= 1'b0;
            fe_ctlr_1k_wr <= 1'b0;
            fe_ctlr_2k_wr <= 1'b0;
            fe_ctlr_3k_wr <= 1'b0;
            fe_ctlr_4k_wr <= 1'b0;
              
          end
      endcase
                     
                     
    end
  end
  
 
endmodule 











