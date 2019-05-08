/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/































`include "ccx_std.vh"


module cr_tlvp2_rsm_core
  
  (
  
  pt_ob_rd, tlvp_rsm_usr_ob_ren, tlvp_rsm_ob_wen, tlvp_rsm_ob_wdata,
  
  clk, rst_n, pt_ob_empty, pt_ob_aempty, pt_ob_tlv,
  tlvp_rsm_usr_ob_rdata, usr_ob_empty, usr_ob_aempty, tlvp_ob_full,
  tlvp_ob_afull
  );

`include "cr_structs.sv"
  
  
  
  

  
  
  
  

  
  
  
  
  input                           clk;
  input                           rst_n; 
     
  
  
  
  input                           pt_ob_empty;
  input                           pt_ob_aempty;
  input  tlvp_if_bus_t            pt_ob_tlv;
  output logic                    pt_ob_rd;
     
  
  
  
  input tlvp_if_bus_t             tlvp_rsm_usr_ob_rdata;
  input                           usr_ob_empty;
  input                           usr_ob_aempty;
  output logic                    tlvp_rsm_usr_ob_ren;
  
  
  
  
  input                           tlvp_ob_full;
  input                           tlvp_ob_afull;
  output logic                    tlvp_rsm_ob_wen;
  output axi4s_dp_bus_t           tlvp_rsm_ob_wdata;
  

  
  
  
  
  
   `CCX_STD_CALC_BIP2(get_bip2, `AXI_S_DP_DWIDTH)

  
  tlv_word_0_t                    tlvp_rsm_usr_ob_rdata_dw0;
  logic [1:0]                     tlvp_rsm_bip2;
  
  
  logic                           tlvp_rsm_usr_ob_valid;
  tlvp_if_bus_t                   tlvp_rsm_usr_ob_tlv;
  logic                           tlvp_rsm_usr_ob_wen;
  logic                           tlvp_rsm_usr_ob_sel;

  
  logic                           tlvp_rsm_pt_valid;
  tlvp_if_bus_t                   tlvp_rsm_pt_tlv;
  logic                           tlvp_rsm_pt_wen;
  logic                           tlvp_rsm_pt_sel;

  
  tlvp_if_bus_t                   tlvp_rsm_ob_datain;
  
  
  logic [`TLVP_ORD_NUM_WIDTH-1:0] tlvp_rsm_nxt_ordern;
  logic [`TLVP_TYP_NUM_WIDTH-1:0] tlvp_rsm_last_typen;
 

  logic                           tlvp_rsm_pt_next;
  logic                           tlvp_rsm_usr_ob_next;
  logic                           tlvp_rsm_usr_insert;
  
  logic [1:0]                     tlvp_rsm_selector;
  logic [`TLVP_ORD_NUM_WIDTH-1:0] tlvp_rsm_usr_ob_tlv_ordern;
  logic [`TLVP_ORD_NUM_WIDTH-1:0] tlvp_rsm_pt_tlv_ordern;
  
  
  
  enum                            { IDLE,
                                  SEND_PT,
                                  SEND_USR} current_state, next_state;
   
  
   
  assign tlvp_rsm_usr_ob_rdata_dw0 = tlv_word_0_t'(tlvp_rsm_usr_ob_rdata.tdata);
  assign tlvp_rsm_bip2 = get_bip2({2'b00,tlvp_rsm_usr_ob_rdata.tdata[61:0]});
  
  assign tlvp_rsm_usr_ob_wen = tlvp_rsm_usr_ob_valid & (next_state == SEND_USR);
  assign tlvp_rsm_pt_wen     = tlvp_rsm_pt_valid     & (next_state == SEND_PT);
  assign tlvp_rsm_usr_ob_ren = ~usr_ob_empty & ~tlvp_ob_afull & (~tlvp_rsm_usr_ob_valid | tlvp_rsm_usr_ob_wen); 
  assign pt_ob_rd            = ~pt_ob_empty  & ~tlvp_ob_afull & (~tlvp_rsm_pt_valid     | tlvp_rsm_pt_wen);

  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin

      tlvp_rsm_usr_ob_valid  <= 1'b0;
      tlvp_rsm_usr_ob_tlv    <= 0;
      
      tlvp_rsm_pt_valid   <= 1'b0;
      tlvp_rsm_pt_tlv     <= 0;
      
      tlvp_rsm_usr_ob_tlv_ordern <= 0;
      tlvp_rsm_pt_tlv_ordern <= 0;
      
      end
    else begin
      
      if( tlvp_rsm_usr_ob_ren & ~tlvp_rsm_usr_ob_wen) begin
        tlvp_rsm_usr_ob_valid <= 1'b1;
      end
      else if (~tlvp_rsm_usr_ob_ren & tlvp_rsm_usr_ob_wen) begin
        tlvp_rsm_usr_ob_valid <= 1'b0;
      end
      
      
      if(tlvp_rsm_usr_ob_ren) begin
        if( tlvp_rsm_usr_ob_rdata.sot | tlvp_rsm_usr_ob_rdata.tuser[0]) begin
          tlvp_rsm_usr_ob_tlv_ordern <= tlvp_rsm_usr_ob_rdata.ordern; 
          
          tlvp_rsm_usr_ob_tlv <= {
                                  tlvp_rsm_usr_ob_rdata.insert,
                                  tlvp_rsm_usr_ob_rdata.ordern,
                                  tlvp_rsm_usr_ob_rdata.typen,
                                  tlvp_rsm_usr_ob_rdata.sot,
                                  tlvp_rsm_usr_ob_rdata.eot,
                                  tlvp_rsm_usr_ob_rdata.tlast,
                                  tlvp_rsm_usr_ob_rdata.tid,
                                  tlvp_rsm_usr_ob_rdata.tstrb,
                                  tlvp_rsm_usr_ob_rdata.tuser,
                                  {tlvp_rsm_bip2,tlvp_rsm_usr_ob_rdata.tdata[61:0]}
                                 };
        end
        else begin
          tlvp_rsm_usr_ob_tlv <= tlvp_rsm_usr_ob_rdata;
        end
      end  

      
      if( pt_ob_rd & ~tlvp_rsm_pt_wen) begin
        tlvp_rsm_pt_valid <= 1'b1;
      end
      else if (~pt_ob_rd & tlvp_rsm_pt_wen) begin
        tlvp_rsm_pt_valid <= 1'b0;
      end
        
      if(pt_ob_rd) begin
        tlvp_rsm_pt_tlv <= pt_ob_tlv;
        
        if(pt_ob_tlv.sot | pt_ob_tlv.tuser[0]) begin
          tlvp_rsm_pt_tlv_ordern <= pt_ob_tlv.ordern;
        end
      end

    end
  end 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  assign tlvp_rsm_pt_next     = (tlvp_rsm_pt_tlv_ordern <= tlvp_rsm_nxt_ordern);
  assign tlvp_rsm_usr_ob_next = (tlvp_rsm_usr_ob_tlv_ordern == tlvp_rsm_nxt_ordern);
   
  assign tlvp_rsm_selector = {tlvp_rsm_usr_ob_valid,tlvp_rsm_pt_valid};
  
  always@ *
    begin
      case(tlvp_rsm_selector)
        2'b00: 
          begin
            tlvp_rsm_pt_sel  = 1'b0;
            tlvp_rsm_usr_ob_sel  = 1'b0;
          end
        
        2'b01: 
          begin
            if(tlvp_rsm_pt_next && ~tlvp_rsm_usr_insert) begin
            tlvp_rsm_pt_sel = 1'b1;
            end
            else begin
            tlvp_rsm_pt_sel = 1'b0;
            end
            tlvp_rsm_usr_ob_sel  = 1'b0;
          end
        
        2'b10: 
          begin
            tlvp_rsm_pt_sel  = 1'b0;
            if(tlvp_rsm_usr_ob_next | tlvp_rsm_usr_insert) begin
              tlvp_rsm_usr_ob_sel  =  1'b1;
            end
            else begin
              tlvp_rsm_usr_ob_sel  =  1'b0;
            end
          end
        
        2'b11: 
          begin
            
            
            if (tlvp_rsm_usr_insert) begin   
              tlvp_rsm_pt_sel  = 1'b0;
              tlvp_rsm_usr_ob_sel  =1'b1;
            end

            
            else if (tlvp_rsm_usr_ob_next) begin  
              tlvp_rsm_pt_sel  = 1'b0;
              tlvp_rsm_usr_ob_sel  =1'b1;
            end
            
            
            else if (tlvp_rsm_pt_next) begin  
              tlvp_rsm_pt_sel  = 1'b1;
              tlvp_rsm_usr_ob_sel  =1'b0;
            end

            
            else if (tlvp_rsm_pt_tlv_ordern < tlvp_rsm_usr_ob_tlv_ordern) begin  
              tlvp_rsm_pt_sel  = 1'b1;
              tlvp_rsm_usr_ob_sel  =1'b0;
            end

            
            else  begin
              tlvp_rsm_pt_sel  = 1'b0;
              tlvp_rsm_usr_ob_sel  = 1'b1;
            end
          end
      endcase 
    end 
    
  
  
  
  
  
  
  
  
  
  always @ *
    begin
      case (current_state)
        IDLE:
          begin
            if (tlvp_rsm_usr_ob_sel) begin
              next_state = SEND_USR;
            end
            else if(tlvp_rsm_pt_sel) begin
              next_state = SEND_PT;
            end
            else begin
              next_state = IDLE;
            end
          end
        SEND_PT: 
          begin
            if(tlvp_rsm_ob_datain.eot) begin
              if (tlvp_rsm_usr_ob_sel) begin
                next_state = SEND_USR;
              end
              else if(tlvp_rsm_pt_sel) begin
                next_state = SEND_PT;
              end
              else begin
                next_state = IDLE;
              end
            end
            else begin
              next_state = SEND_PT;
            end
          end
        SEND_USR:
          begin
            if(tlvp_rsm_ob_datain.eot) begin
              if (tlvp_rsm_usr_ob_sel) begin
                next_state = SEND_USR;
              end 
              else if(tlvp_rsm_pt_sel) begin
                next_state = SEND_PT;
              end
              else begin
                next_state = IDLE;
              end
            end
            else begin
              next_state = SEND_USR;
            end
          end
        default:
          begin
              next_state = IDLE;
          end
      endcase 
    end 
  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) 
      begin
        current_state <= IDLE;
      end
    else
      begin
        current_state <= next_state;
      end
  end



  
  
  

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      tlvp_rsm_ob_datain <= 0;
      tlvp_rsm_ob_wen <= 1'b0;
      tlvp_rsm_nxt_ordern <= `TLVP_ORD_NUM_WIDTH'd1;
      tlvp_rsm_last_typen <= {`TLVP_TYP_NUM_WIDTH{1'b1}};
      tlvp_rsm_usr_insert <= 1'b0;
      
    end
    else begin
      case(next_state)
        IDLE:
          begin
            tlvp_rsm_ob_datain <= 0;
            tlvp_rsm_ob_wen <= 1'b0;
          end
        
        SEND_PT:
          begin
            tlvp_rsm_ob_wen <= tlvp_rsm_pt_valid;
            tlvp_rsm_ob_datain  <= tlvp_rsm_pt_tlv;
            tlvp_rsm_last_typen <= tlvp_rsm_pt_tlv.typen;

            if(tlvp_rsm_pt_tlv.tlast) begin
              tlvp_rsm_nxt_ordern <= `TLVP_ORD_NUM_WIDTH'd1;
            end
            else if(tlvp_rsm_pt_tlv.eot) begin
              tlvp_rsm_nxt_ordern <= tlvp_rsm_pt_tlv_ordern + 1'b1;
            end
        
          end 
        
        SEND_USR:
          begin
            tlvp_rsm_ob_wen <=  tlvp_rsm_usr_ob_valid ;
            tlvp_rsm_ob_datain  <= tlvp_rsm_usr_ob_tlv;
            tlvp_rsm_last_typen <= tlvp_rsm_usr_ob_tlv.typen;

            if(tlvp_rsm_usr_ob_tlv.tlast) begin
              tlvp_rsm_nxt_ordern <= `TLVP_ORD_NUM_WIDTH'd1;
            end
            else if(tlvp_rsm_usr_ob_tlv.eot) begin
              tlvp_rsm_nxt_ordern <= tlvp_rsm_usr_ob_tlv_ordern + 1'b1;
            end
            
            if(tlvp_rsm_usr_ob_tlv.sot) begin
              tlvp_rsm_usr_insert <= tlvp_rsm_usr_ob_tlv.insert;
            end
            
            
          end 
        
        default:
          begin
            tlvp_rsm_ob_datain <= 0;
            tlvp_rsm_ob_wen <= 1'b0;
            tlvp_rsm_nxt_ordern <= `TLVP_ORD_NUM_WIDTH'd1;
            tlvp_rsm_last_typen <= {`TLVP_TYP_NUM_WIDTH{1'b1}};
            tlvp_rsm_usr_insert <= 1'b0;
          end
        
      endcase 
    end 
  end 
  
  
    
  
  assign tlvp_rsm_ob_wdata.tvalid  = tlvp_rsm_ob_wen;
  assign tlvp_rsm_ob_wdata.tlast   = tlvp_rsm_ob_datain.tlast;
  assign tlvp_rsm_ob_wdata.tid     = tlvp_rsm_ob_datain.tid;
  assign tlvp_rsm_ob_wdata.tstrb   = tlvp_rsm_ob_datain.tstrb;
  assign tlvp_rsm_ob_wdata.tuser   = tlvp_rsm_ob_datain.tuser;
  assign tlvp_rsm_ob_wdata.tdata   = tlvp_rsm_ob_datain.tdata;
  

endmodule












