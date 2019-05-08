/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/














module cr_sa_counter
  (
  
  sa_count, sa_snapshot,
  
  clk, rst_n, sa_event_sel, sa_events, sa_clear, sa_snap
  );

`include "cr_structs.sv"

  
  
  
  input               clk;
  input               rst_n; 

  
  
  
  input [9:0]         sa_event_sel;
  input [63:0]        sa_events[15:0];

  
  
  
  input               sa_clear;
  input               sa_snap;

  
  
  
  output logic [49:0] sa_count;  
  output logic [49:0] sa_snapshot; 

  
  
  
  logic [63:0]        sa_mux1;
  logic               sa_mux2;
  logic [5:0]         mux2_sel;
  
   
 

       
  
  
  
  always_comb begin case(sa_event_sel[9:6])
      4'd0:  sa_mux1 = sa_events[0];
      4'd1:  sa_mux1 = sa_events[1];
      4'd2:  sa_mux1 = sa_events[2];
      4'd3:  sa_mux1 = sa_events[3];
      4'd4:  sa_mux1 = sa_events[4];
      4'd5:  sa_mux1 = sa_events[5];
      4'd6:  sa_mux1 = sa_events[6];
      4'd7:  sa_mux1 = sa_events[7];
      4'd8:  sa_mux1 = sa_events[8];
      4'd9:  sa_mux1 = sa_events[9];
      4'd10: sa_mux1 = sa_events[10];
      4'd11: sa_mux1 = sa_events[11];
      4'd12: sa_mux1 = sa_events[12];
      4'd13: sa_mux1 = sa_events[13];
      4'd14: sa_mux1 = sa_events[14];
      4'd15: sa_mux1 = sa_events[15];
    endcase 
  end 
 
  
  
  
  assign mux2_sel = sa_event_sel[5:0];
  assign sa_mux2 = sa_mux1[mux2_sel];

  
  
  
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      sa_count <= 50'd0;
      sa_snapshot <= 50'd0;
    end
    else begin
      if(sa_clear) begin
        sa_count <= 50'd0;
      end       
      else if(sa_mux2) begin
        sa_count <= sa_count + 1'b1;
      end
      
      if(sa_snap) begin
        sa_snapshot <= sa_count;
      end
      
    end
  end 
  
  

endmodule











