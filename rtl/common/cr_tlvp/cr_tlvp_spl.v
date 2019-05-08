/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/





























module cr_tlvp_spl
  
  (
  
  tlvp_pt_ib_wen, tlvp_pt_ib_wdata, tlvp_usr_ib_wen,
  tlvp_usr_ib_wdata,
  
  clk, rst_n, tlv_parse_action, tlvp_id_out_valid, tlvp_id_out
  );

`include "cr_structs.sv"
  
  
  
  
  
  input                                clk;
  input                      rst_n; 
  
  
  
  
  input [`TLVP_PA_WIDTH-1:0] tlv_parse_action;
    
  
  
  
  input                      tlvp_id_out_valid;
  input                      tlvp_if_bus_t tlvp_id_out;
  
  
  
  
  output logic               tlvp_pt_ib_wen;
  output                     tlvp_if_bus_t tlvp_pt_ib_wdata;
  
  
  
  
  output logic               tlvp_usr_ib_wen;
  output                     tlvp_if_bus_t tlvp_usr_ib_wdata;
  
 
  
 
   
  tlv_parse_action_e              tlvp_spl_id_out_action;
  
  logic [`TLVP_ORD_NUM_WIDTH-1:0] tlvp_spl_ordern;
                 
   
  
  
  
  
  
  
  
  
  
  
  always_comb begin
    case(tlvp_id_out.typen)
      0: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[1:0]);
      1: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[3:2]);
      2: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[5:4]);
      3: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[7:6]);
      4: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[9:8]);
      5: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[11:10]);
      6: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[13:12]);
      7: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[15:14]);
      8: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[17:16]);
      9: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[19:18]);
     10: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[21:20]);
     11: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[23:22]);
     12: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[25:24]);
     13: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[27:26]);
     14: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[29:28]);
     15: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[31:30]);
     16: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[33:32]);
     17: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[35:34]);
     18: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[37:36]);
     19: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[39:38]);
     20: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[41:40]);
     21: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[43:42]);
     22: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[45:44]);
     23: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[47:46]);
     24: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[49:48]);
     25: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[51:50]);
     26: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[53:52]);
     27: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[55:54]);
     28: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[57:56]);
     29: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[59:58]);
     30: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[61:60]);
     31: tlvp_spl_id_out_action = tlv_parse_action_e'(tlv_parse_action[63:62]);
      default: tlvp_spl_id_out_action = PASS;
    endcase 
  end
  

  
  
  
  
  
  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) 
      begin
        tlvp_pt_ib_wen <= 1'd0;
        tlvp_pt_ib_wdata <= 0;
        tlvp_usr_ib_wen <= 1'd0;
        tlvp_usr_ib_wdata <= 0;

        tlvp_spl_ordern <= `TLVP_ORD_NUM_WIDTH'd1;
        
        
      end
    else 
      begin
        
        if (tlvp_id_out_valid & tlvp_id_out.tlast) begin
          tlvp_spl_ordern  <= `TLVP_ORD_NUM_WIDTH'd1; 
        end
        
        else if (tlvp_id_out_valid & tlvp_id_out.eot & (tlvp_spl_id_out_action != DELETE)) begin
          tlvp_spl_ordern  <= tlvp_spl_ordern + 1'b1;
        end
        
        tlvp_pt_ib_wdata   <= tlvp_id_out;
        tlvp_usr_ib_wdata <= tlvp_id_out;

        
        tlvp_pt_ib_wdata.ordern <= tlvp_spl_ordern;
        tlvp_usr_ib_wdata.ordern <= tlvp_spl_ordern;
        

        tlvp_pt_ib_wen   <= (tlvp_id_out_valid &
                          ((tlvp_spl_id_out_action == REP) |
                           (tlvp_spl_id_out_action == PASS)));

        tlvp_usr_ib_wen <= (tlvp_id_out_valid &
                          (tlvp_spl_id_out_action != PASS));

      end
   end
 
endmodule












