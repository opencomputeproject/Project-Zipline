/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/























`include "axi_reg_slice_defs.vh"
module cr_axi4s_mstr
  
  (
  
  axi4s_mstr_rd, axi4s_ob_out,
  
  clk, rst_n, axi4s_in, axi4s_in_empty, axi4s_in_aempty, axi4s_ob_in
  );

`include "cr_structs.sv"
  
  
  
  
    
  
  
  
  
  
  
  
  input                         clk;
  input                         rst_n; 
    
  
  
  
  input  axi4s_dp_bus_t         axi4s_in;
  input                         axi4s_in_empty;
  input                         axi4s_in_aempty;
  output logic                  axi4s_mstr_rd;
  
  
  
  
  input  axi4s_dp_rdy_t         axi4s_ob_in;
  output axi4s_dp_bus_t         axi4s_ob_out;
  
  
  
 typedef struct packed {
  logic                          tlast;
  logic [`AXI_S_TID_WIDTH-1:0]   tid;
  logic [`AXI_S_TSTRB_WIDTH-1:0] tstrb;
  logic [`AXI_S_USER_WIDTH-1:0]  tuser;
  logic [`AXI_S_DP_DWIDTH-1:0]   tdata;
} axi4s_payload_t;
 
  axi4s_dp_bus_t                 axi4s_ib_out;
  axi4s_dp_rdy_t                 axi4s_ib_in;

  axi4s_payload_t                axi4s_ib_out_payload;
  axi4s_payload_t                axi4s_ob_out_payload;

  
  
  
  
  
  
  
  
  
  
  assign axi4s_mstr_rd = ~axi4s_in_empty & (~axi4s_ib_out.tvalid | axi4s_ib_in.tready);
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      axi4s_ib_out <= '{default:0};
    end
    else begin
      if(axi4s_mstr_rd) begin
        axi4s_ib_out <= axi4s_in;
      end
      
      
      
      else if(axi4s_ib_out.tvalid & axi4s_ib_in.tready) begin
        axi4s_ib_out.tvalid <= 1'b0;
      end
    end
  end
  
  
  assign axi4s_ib_out_payload.tlast = axi4s_ib_out.tlast;
  assign axi4s_ib_out_payload.tid   = axi4s_ib_out.tid;
  assign axi4s_ib_out_payload.tstrb = axi4s_ib_out.tstrb;
  assign axi4s_ib_out_payload.tuser = axi4s_ib_out.tuser;
  assign axi4s_ib_out_payload.tdata = axi4s_ib_out.tdata;

  
  assign axi4s_ob_out.tlast = axi4s_ob_out_payload.tlast;
  assign axi4s_ob_out.tid   = axi4s_ob_out_payload.tid;
  assign axi4s_ob_out.tstrb = axi4s_ob_out_payload.tstrb;
  assign axi4s_ob_out.tuser = axi4s_ob_out_payload.tuser;
  assign axi4s_ob_out.tdata = axi4s_ob_out_payload.tdata;
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  axi_channel_reg_slice #
    (
      
      .PAYLD_WIDTH($bits(axi4s_ib_out_payload)),
      .HNDSHK_MODE(`AXI_RS_FULL))
   u_axi_channel_reg_slice
     (
      
      .ready_src                        (axi4s_ib_in.tready),    
      .valid_dst                        (axi4s_ob_out.tvalid),   
      .payload_dst                      (axi4s_ob_out_payload),  
      
      .aclk                             (clk),                   
      .aresetn                          (rst_n),                 
      .valid_src                        (axi4s_ib_out.tvalid),   
      .payload_src                      (axi4s_ib_out_payload),  
      .ready_dst                        (axi4s_ob_in.tready));   

 
endmodule












