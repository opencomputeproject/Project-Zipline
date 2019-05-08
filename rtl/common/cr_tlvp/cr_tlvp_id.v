/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
































`include "ccx_std.vh"


module cr_tlvp_id
  
  (
  
  tlvp_ib_rd, tlvp_id_out_valid, tlvp_id_out, tlvp_error,
  
  clk, rst_n, tlvp_ib_empty, tlvp_ib_aempty, tlvp_ib, pt_ib_full,
  pt_ib_afull, usr_ib_full, usr_ib_afull, module_id
  );

`include "cr_structs.sv"
 

  
  
  
  input                         clk;
  input                          rst_n; 
     
  
  
  
  input                          tlvp_ib_empty;
  input                          tlvp_ib_aempty;
  input  axi4s_dp_bus_t          tlvp_ib;
  output logic                   tlvp_ib_rd; 

  
  
  
  input logic                    pt_ib_full;
  input logic                    pt_ib_afull;
  
  
  
  
  input logic                    usr_ib_full;
  input logic                    usr_ib_afull;
  
  
  
  
  output logic                   tlvp_id_out_valid;
  output tlvp_if_bus_t           tlvp_id_out;
  
  
  
  
  output logic                   tlvp_error;
    
  
  
  
  input  [`MODULE_ID_WIDTH-1:0]  module_id;

  
  tlvp_if_bus_t                  tlvp_id_tlv0;
  logic                          tlvp_id_tlv0_valid;
  tlvp_if_bus_t                  tlvp_id_tlv0_save;
  
  logic [1:0]                    tlvp_id_bip2;
  
  logic                          tlvp_id_bip2_error;
  logic                          tlvp_id_bip2_ftr_error;
  logic                          tlvp_id_frame;
  logic                          tlvp_id_frame_error;
  logic [18:0]                   tlvp_id_word_num;
  logic [18:0]                   tlvp_id_debug_word_num;
  tlv_cmd_word_1_t               tlvp_id_cmd_word1;
  cmd_debug_t                    tlvp_id_dp_debug_cmd;
  cmd_debug_t                    tlvp_id_bp_debug_cmd;

  logic [10:0]                   tlvp_id_tm_count;
  logic [10:0]                   tlvp_id_tm_on_count;
  logic [10:0]                   tlvp_id_tm_off_count;
  logic                          tlvp_id_tm_off;
  tlv_word_0_t                   tlvp_ib_word0_data ;
  logic                          tlvp_id_corrupt_data;
  logic                          tlvp_id_corrupt_eot;
  logic [63:0]                   tlvp_id_debuq_word_msk;
 
  logic                          tlvp_id_dp_cmd_wr;
  logic                          tlvp_id_bp_cmd_wr;
  tlv_types_e                    tlvp_id_dp_type;
  bp_debug_t                     tlvp_id_bp_debug_data;
  logic                          tlvp_id_tm_count_en;
  logic                          tlvp_id_error;
  logic                          tlvp_id_errors;
  logic                          tlvp_id_errors_p1;
  logic                          tlvp_id_padtlv;
  logic                          tlvp_id_pad_detect;
  logic                          tlvp_id_trunc_detect;
  
  
  
  
  
  
  
  
  
   `CCX_STD_CALC_BIP2(get_bip2, `AXI_S_DP_DWIDTH)

  
  
  assign tlvp_ib_rd = ~tlvp_ib_empty & 
                      ~pt_ib_afull & 
                      ~usr_ib_afull & 
                      ~tlvp_id_tm_off & 
                      ~tlvp_id_pad_detect & 
                      ~tlvp_id_padtlv;
  
  
  assign tlvp_ib_word0_data = tlv_word_0_t'(tlvp_ib.tdata);
  assign tlvp_id_cmd_word1  = tlv_cmd_word_1_t'(tlvp_id_tlv0.tdata);


  
  assign tlvp_id_bip2 = get_bip2(tlvp_id_tlv0.tdata);
  
  
  
  
  
  assign tlvp_id_dp_cmd_wr = (tlvp_id_cmd_word1.debug.tlvp_corrupt==TLVP) & 
                             (tlvp_id_cmd_word1.debug.module_id == module_id) &
                             (tlvp_id_cmd_word1.debug.cmd_type == DATAPATH_CORRUPT);
  
  assign tlvp_id_bp_cmd_wr = (tlvp_id_cmd_word1.debug.tlvp_corrupt==TLVP) & 
                             (tlvp_id_cmd_word1.debug.module_id == module_id) &
                             (tlvp_id_cmd_word1.debug.cmd_type == FUNCTIONAL_ERROR);
  
  
  assign tlvp_id_dp_type = tlv_types_e'({3'd0,tlvp_id_dp_debug_cmd.tlv_num});
  
  assign tlvp_id_debug_word_num = {11'd0,tlvp_id_dp_debug_cmd.byte_num >> 3};
  assign tlvp_id_debuq_word_msk = tlvp_id_dp_debug_cmd.byte_msk << ({tlvp_id_dp_debug_cmd.byte_num[2:0],3'b000});
  
    
  assign tlvp_id_bp_debug_data = bp_debug_t'({tlvp_id_bp_debug_cmd.tlv_num,tlvp_id_bp_debug_cmd.byte_num,tlvp_id_bp_debug_cmd.byte_msk});
  assign tlvp_id_tm_on_count  =  tlvp_id_bp_debug_data.on_count;
  assign tlvp_id_tm_off_count =  tlvp_id_bp_debug_data.off_count;

  assign tlvp_id_pad_detect =  tlvp_id_corrupt_eot &&  tlvp_id_tlv0.eot && 
                               (tlvp_id_tlv0.typen == tlvp_id_dp_type) &&
                               (tlvp_id_debug_word_num > tlvp_id_word_num);
  
  assign tlvp_id_trunc_detect = tlvp_id_corrupt_eot && 
                                (tlvp_id_tlv0.typen == tlvp_id_dp_type) &&
                                (tlvp_id_debug_word_num <= tlvp_id_word_num) &&
                                 ~tlvp_id_tlv0.eot;
  
  assign tlvp_id_tlv0.insert = 1'b0;
  assign tlvp_id_tlv0.ordern = {`TLVP_ORD_NUM_WIDTH{1'b0}};
                                          
  
  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      
      tlvp_id_tlv0.typen <= RQE;
      tlvp_id_tlv0.sot   <= 1'd0;
      tlvp_id_tlv0.eot   <= 1'd0;
      tlvp_id_tlv0.tlast <= 1'b0;
      tlvp_id_tlv0.tid   <= {`AXI_S_TID_WIDTH{1'b0}};
      tlvp_id_tlv0.tstrb <= {`AXI_S_TSTRB_WIDTH{1'b0}};
      tlvp_id_tlv0.tuser <= {`AXI_S_USER_WIDTH{1'b0}};
      tlvp_id_tlv0.tdata <= 0;
      tlvp_id_tlv0_valid <= 1'd0;
        
      tlvp_id_out.insert <= 1'b0;
      tlvp_id_out.ordern <= {`TLVP_ORD_NUM_WIDTH{1'b0}};
      tlvp_id_out.typen  <= RQE;
      tlvp_id_out.sot    <= 1'd0;
      tlvp_id_out.eot    <= 1'd0;
      tlvp_id_out.tlast  <= 1'd0;
      tlvp_id_out.tid    <= {`AXI_S_TID_WIDTH{1'b0}};
      tlvp_id_out.tstrb  <= {`AXI_S_TSTRB_WIDTH{1'b0}};
      tlvp_id_out.tuser  <= {`AXI_S_USER_WIDTH{1'b0}};
      tlvp_id_out.tdata  <= {`AXI_S_DP_DWIDTH{1'b0}};
      tlvp_id_out_valid  <= 1'd0;
      
      tlvp_id_bip2_error  <= 1'b0;
      tlvp_id_bip2_ftr_error  <= 1'b0;
      tlvp_id_frame       <= 1'b0;
      tlvp_id_frame_error <= 1'b0;
      tlvp_id_error       <= 1'b0;
      tlvp_id_errors      <= 1'b0;
      tlvp_id_errors_p1   <= 1'b0;
      tlvp_id_word_num    <= 19'd0;
      tlvp_id_corrupt_data <= 1'b0;
      tlvp_id_corrupt_eot <= 1'b0;
      tlvp_id_dp_debug_cmd <= 0;
      tlvp_id_bp_debug_cmd <= 0;
      
      tlvp_id_tm_count <= 11'd0;
      tlvp_id_tm_off       <= 1'b0;
      tlvp_id_tm_count_en <= 1'b0;
      tlvp_id_padtlv         <= 1'b0;
      
      tlvp_id_tlv0_save <= 0;
      
    end
    else begin
      
      tlvp_id_errors    <= tlvp_id_frame_error | tlvp_id_bip2_error; 
      tlvp_id_errors_p1 <= tlvp_id_errors;
      tlvp_error        <= tlvp_id_errors & ~tlvp_id_errors_p1;
        
      
      
      
      if(tlvp_ib.tuser[0] && tlvp_ib_rd) begin
        tlvp_id_tlv0.typen <= tlvp_ib_word0_data.tlv_type;
      end
      
      
      tlvp_id_tlv0.sot      <= tlvp_ib.tuser[0];
      tlvp_id_tlv0.eot      <= tlvp_ib.tuser[1];
      tlvp_id_tlv0.tlast    <= tlvp_ib.tlast;
      tlvp_id_tlv0.tid      <= tlvp_ib.tid;
      tlvp_id_tlv0.tstrb    <= tlvp_ib.tstrb;
      tlvp_id_tlv0.tuser    <= tlvp_ib.tuser;
      tlvp_id_tlv0.tdata    <= tlvp_ib.tdata;
      tlvp_id_tlv0_valid    <= tlvp_ib_rd;

      
      tlvp_id_out.insert <= tlvp_id_tlv0.insert;
      tlvp_id_out.ordern <= tlvp_id_tlv0.ordern;
      tlvp_id_out.typen  <= tlvp_id_tlv0.typen;
      tlvp_id_out.sot    <= tlvp_id_tlv0.sot;
      tlvp_id_out.eot    <= tlvp_id_tlv0.eot;
      tlvp_id_out.tlast  <= tlvp_id_tlv0.tlast;
      tlvp_id_out.tid    <= tlvp_id_tlv0.tid;
      tlvp_id_out.tstrb  <= tlvp_id_tlv0.tstrb;
      tlvp_id_out.tuser  <= tlvp_id_tlv0.tuser;


      
      
      
      
      if(tlvp_id_bp_debug_cmd.cmd_mode == CONTINUOUS_ERROR) begin
        tlvp_id_tm_count_en <= 1'b1;
      end
      else if(tlvp_id_bp_debug_cmd.cmd_mode == STOP)  begin
        tlvp_id_tm_count_en <= 1'b0;
      end
      
      if(tlvp_id_tm_count_en)  begin
         if(tlvp_id_tm_count <= 11'd1) begin
           if(tlvp_id_tm_off && (tlvp_id_tm_on_count > 11'd0)) begin
             tlvp_id_tm_count  <= tlvp_id_tm_on_count;
             tlvp_id_tm_off <= 1'b0;
           end
           else if (~tlvp_id_tm_off && (tlvp_id_tm_off_count > 11'd0)) begin
             tlvp_id_tm_count  <= tlvp_id_tm_off_count;
             tlvp_id_tm_off <= 1'b1;
           end
         end
         else begin
           tlvp_id_tm_count  <= tlvp_id_tm_count - 1'b1;
         end 
      end
      else begin
         tlvp_id_tm_count  <= 11'd0;
         tlvp_id_tm_off <= 1'b0;
      end
 
              
      
      if(tlvp_ib_rd & tlvp_ib.tuser[0]) begin
        tlvp_id_word_num <= 19'd0;
      end
      else if(tlvp_ib_rd) begin
        tlvp_id_word_num <= tlvp_id_word_num + 1'b1;
      end
        
      
      if(tlvp_id_tlv0_valid) begin
        case(tlvp_id_tlv0.typen)
          CMD:
            begin
              tlvp_id_out.tdata <= tlvp_id_tlv0.tdata;
              
              if(tlvp_id_word_num == 19'd1) begin
                if((tlvp_id_cmd_word1.debug.tlvp_corrupt==TLVP) && 
                   (tlvp_id_cmd_word1.debug.module_id == module_id) &&
                   (tlvp_id_cmd_word1.debug.cmd_type == DATAPATH_CORRUPT)) 
                begin
                   tlvp_id_dp_debug_cmd <= tlvp_id_cmd_word1.debug;
                end
                
                if(tlvp_id_bp_cmd_wr) begin
                   tlvp_id_bp_debug_cmd <= tlvp_id_cmd_word1.debug;
                end
                
                if(tlvp_id_dp_cmd_wr &&
                  ((tlvp_id_cmd_word1.debug.cmd_mode == SINGLE_ERR) ||
                   (tlvp_id_cmd_word1.debug.cmd_mode == CONTINUOUS_ERROR)))
                begin
                  tlvp_id_corrupt_data <= 1'b1;
                end
                
                else if (tlvp_id_dp_cmd_wr && (tlvp_id_cmd_word1.debug.cmd_mode == STOP)) begin
                  tlvp_id_corrupt_data <= 1'b0;
                end
                
                else if (tlvp_id_dp_cmd_wr && (tlvp_id_cmd_word1.debug.cmd_mode == EOT)) begin
                  tlvp_id_corrupt_eot <= 1'b1;
                end
                
              end
            end
          
          FTR:
            begin
              if((tlvp_id_word_num==19'd21) && (tlvp_id_tlv0.tdata[15:0] == 16'd0) && tlvp_id_bip2_ftr_error) begin
                tlvp_id_out.tdata <= {tlvp_id_tlv0.tdata[63:16],TLVP_BIP2_ERROR};
              end
              else begin
                tlvp_id_out.tdata <= tlvp_id_tlv0.tdata;
              end
           end
          
          default:
            begin
              tlvp_id_out.tdata <= tlvp_id_tlv0.tdata;
            end
        endcase 
        

        
        
        
        if (tlvp_id_corrupt_data && (tlvp_id_debug_word_num == tlvp_id_word_num) && 
           (tlvp_id_tlv0.typen == tlvp_id_dp_type)) 
        begin
          tlvp_id_out.tdata   <= tlvp_id_tlv0.tdata ^ tlvp_id_debuq_word_msk;
          if( tlvp_id_dp_debug_cmd.cmd_mode == SINGLE_ERR) begin
            tlvp_id_corrupt_data <= 1'b0;
          end
        end
        
        else if (tlvp_id_corrupt_data && (tlvp_id_tlv0.typen == tlvp_id_dp_type) && tlvp_id_tlv0.eot) begin
          tlvp_id_out.tdata   <= tlvp_id_tlv0.tdata ^ {56'd0,tlvp_id_dp_debug_cmd.byte_msk};
          if( tlvp_id_dp_debug_cmd.cmd_mode == SINGLE_ERR) begin
            tlvp_id_corrupt_data <= 1'b0;
          end
        end

        
        
        
        if(tlvp_id_corrupt_eot && tlvp_id_tlv0.eot && (tlvp_id_tlv0.typen==tlvp_id_dp_type)) begin
          tlvp_id_corrupt_eot  <= 1'b0;
        end
        
        if (tlvp_id_pad_detect) begin
          tlvp_id_tlv0_save <= tlvp_id_tlv0; 
          tlvp_id_out.eot      <= 1'b0;
          tlvp_id_out.tlast    <= 1'b0;
          tlvp_id_out.tuser[1] <= 1'b0;
          tlvp_id_padtlv <= 1'b1;
        end
      end 
      
      if(tlvp_id_padtlv) begin
        tlvp_id_out <= tlvp_id_tlv0_save;
        tlvp_id_out.tdata    <= 64'd0;
        if(tlvp_id_debug_word_num == tlvp_id_word_num) begin
          tlvp_id_out.eot      <= 1'b1;
          tlvp_id_out.tuser[1] <= 1'b1;
          tlvp_id_padtlv <= 1'b0;
        end
        else begin
          tlvp_id_out.eot      <= 1'b0;
          tlvp_id_out.tlast    <= 1'b0;
          tlvp_id_out.tuser[1] <= 1'b0;
          tlvp_id_word_num <= tlvp_id_word_num + 1'b1;
        end
      end 
      
      if(tlvp_id_padtlv) begin
        tlvp_id_out_valid <= 1'b1;
      end
      else if (tlvp_id_trunc_detect)  begin
        tlvp_id_out_valid <= 1'b0;
      end
      else begin
        tlvp_id_out_valid <= tlvp_id_tlv0_valid;
      end 
        
      
      
      
      
      if(tlvp_id_tlv0.tuser[0] && tlvp_id_tlv0_valid && ~tlvp_id_bip2_error) begin
        tlvp_id_bip2_ftr_error <= (tlvp_id_bip2 != 2'd0);
      end
      else if (tlvp_id_tlv0_valid && tlvp_id_tlv0.tlast) begin
        tlvp_id_bip2_ftr_error <= 1'b0;
      end
      
      
      
      
      
      if(tlvp_id_tlv0.tuser[0] && tlvp_id_tlv0_valid) begin
        tlvp_id_bip2_error <= (tlvp_id_bip2 != 2'd0);
      end
      else  begin
        tlvp_id_bip2_error <= 1'b0;
      end
      
                                                     
      
      
      

      if (tlvp_id_tlv0_valid) begin
        case(tlvp_id_tlv0.tuser[1:0])
          2'b00: 
            begin
               tlvp_id_frame_error <= ~tlvp_id_frame;
            end
          2'b01:  
            begin
               tlvp_id_frame <= 1'b1;
               tlvp_id_frame_error <= tlvp_id_frame;
            end
          2'b10:  
            begin
              tlvp_id_frame <= 1'b0;
              tlvp_id_frame_error <= ~tlvp_id_frame;
            end
          2'b11:  
            begin
               tlvp_id_frame <= 1'b0;
               tlvp_id_frame_error <= tlvp_id_frame;
            end
        endcase 
      end
 
    end 
  end 

endmodule












