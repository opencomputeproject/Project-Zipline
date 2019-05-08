/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/

























`include "cr_su.vh"

module cr_su_ctl
(
   
   su_ready, hb_sup, su_hb, su_agg_cnt_stb, in_fifo_wdata, in_fifo_wr,
   in_fifo_rd, out_fifo_wr, out_fifo_wdata,
   
   clk, rst_n, su_in, in_fifo_rdata, in_fifo_empty,
   in_fifo_free_slots, out_fifo_empty, out_fifo_rdata, axi_mstr_rd
   );
  
`include "cr_structs.sv"
`include "ccx_std.vh"
  
  import cr_suPKG::*;
  import cr_su_regsPKG::*;

  
  
  
  input                                         clk;
  input                                         rst_n; 
  
  
  
  
  input  sched_update_if_bus_t                  su_in;
  output reg                                    su_ready;

  
  
  
  output hb_sup_t                               hb_sup;
  output reg [107:0]                            su_hb[7:0];
  output reg                                    su_agg_cnt_stb; 

  
  
  
  input  sched_update_if_bus_t                  in_fifo_rdata;
  input                                         in_fifo_empty;
  input  [`LOG_VEC(`SU_FIFO_ENTRIES+3)]         in_fifo_free_slots;   
  output sched_update_if_bus_t                  in_fifo_wdata;
  output reg                                    in_fifo_wr;
  output reg                                    in_fifo_rd;

  
  
  
  input                                         out_fifo_empty;
  input  axi4s_su_dp_bus_t                      out_fifo_rdata;  
  output reg                                    out_fifo_wr;
  output axi4s_su_dp_bus_t                      out_fifo_wdata;

  
  
  
  input                                         axi_mstr_rd;

  
  
  
  su_ctl_st_e                                   su_ctl_st;
  su_ctl_st_e                                   su_ctl_st_nxt;
  logic                                         in_fifo_rd_nxt;
  logic                                         out_fifo_wr_nxt;
  logic [4:0]                                   serial_mux_sel_nxt;
  logic                                         su_axi_tlast_nxt;
  logic [1:0]                                   su_axi_tuser_nxt;
  logic                                         su_hb_wr_nxt;
  logic [4:0]                                   serial_mux_sel;
  logic                                         su_axi_tlast;
  logic [1:0]                                   su_axi_tuser;
  logic                                         su_hb_wr;
  logic [`SU_BYTES_WIDTH:0]                     adj_bytes_in; 
  logic [`SU_BYTES_WIDTH:0]                     adj_bytes_out; 
  logic [1:0]                                   su_tlv_bip2;
  logic [7:0]                                   su_axi_tdata;
  logic [2:0]                                   su_hb_add;
  tlv_types_e                                   su_tlv_type; 
  logic [7:0]                                   su_tlv_len; 
  
  
  
   `CCX_STD_CALC_BIP2(get_bip2, `AXI_S_DP_DWIDTH);  
  
  
  
  
  
  always_ff @(posedge clk or negedge rst_n)
  begin
    if (~rst_n) 
    begin
      su_ctl_st      <= SU_CTL_IDLE;      
      su_ready       <= 1'b1;
      
      
      in_fifo_rd <= 0;
      in_fifo_wdata <= 0;
      in_fifo_wr <= 0;
      out_fifo_wr <= 0;
      serial_mux_sel <= 0;
      su_agg_cnt_stb <= 0;
      su_axi_tlast <= 0;
      su_axi_tuser <= 0;
      su_hb_wr <= 0;
      
    end
    else
    begin
      in_fifo_wr     <= su_in.valid;
      in_fifo_wdata  <= su_in;  
      su_ready       <= in_fifo_free_slots > 7'h8; 
      su_ctl_st      <= su_ctl_st_nxt;      
      in_fifo_rd     <= in_fifo_rd_nxt;
      out_fifo_wr    <= out_fifo_wr_nxt;
      serial_mux_sel <= serial_mux_sel_nxt;
      su_axi_tlast   <= su_axi_tlast_nxt;
      su_axi_tuser   <= su_axi_tuser_nxt;
      su_hb_wr       <= su_hb_wr_nxt;

      
      
      
      su_agg_cnt_stb <= axi_mstr_rd && out_fifo_rdata.tlast;
    end
  end

  
  
  
  
  
  
  
  always_comb
  begin
    
    in_fifo_rd_nxt      = 1'b0;
    out_fifo_wr_nxt     = 1'b0;
    serial_mux_sel_nxt  = 5'b0;
    su_axi_tlast_nxt    = 1'b0;
    su_axi_tuser_nxt    = 2'b0;
    su_hb_wr_nxt        = 1'b0;

    case (su_ctl_st)
      
      
      
      
      
       SU_CTL_IDLE:
      begin
        if (!in_fifo_empty && out_fifo_empty)
        begin
          su_axi_tuser_nxt  = 2'b1;
          out_fifo_wr_nxt   = 1'b1;
          su_hb_wr_nxt      = 1'b1;       
          su_ctl_st_nxt     = SU_CTL_SERIAL;
        end
        else
        begin
          su_ctl_st_nxt  = SU_CTL_IDLE;
        end
      end

      
      
      
      
      SU_CTL_SERIAL:
      begin
        
        
        if (serial_mux_sel == 5'd18) 
        begin
          out_fifo_wr_nxt     = 1'b1;
          su_axi_tuser_nxt    = 2'b10;
          su_axi_tlast_nxt    = 1'b1;
          in_fifo_rd_nxt      = 1'b1;
          serial_mux_sel_nxt  = serial_mux_sel + 5'h1;
          su_ctl_st_nxt       = SU_CTL_IDLE;
        end
        
        else
        begin
          out_fifo_wr_nxt     = 1'b1;
          serial_mux_sel_nxt  = serial_mux_sel + 5'h1;
          su_ctl_st_nxt       = SU_CTL_SERIAL;
        end
      end

      default: su_ctl_st_nxt  = SU_CTL_IDLE;
    endcase
  end

  
  
  

  assign su_tlv_type = SCH; 
  assign su_tlv_len  = `TLV_LEN_WIDTH'h5;

  assign adj_bytes_in  = {1'b0, in_fifo_rdata.bytes_in};  
  assign adj_bytes_out = {1'b0, in_fifo_rdata.bytes_out};  

  assign su_tlv_bip2   = get_bip2(
                                  {
                                   2'b0,                  
                                   in_fifo_rdata.last,
                                   2'b0,
                                   in_fifo_rdata.rqe_sched_handle,
                                   11'h0,
                                   4'b0,
                                   in_fifo_rdata.tlv_eng_id, 
                                   in_fifo_rdata.tlv_seq_num, 
                                   su_tlv_len,
                                   su_tlv_type
                                  });


  always_comb
  begin
    case (serial_mux_sel)
      
      5'h0 : su_axi_tdata    = su_tlv_type;
      5'h1 : su_axi_tdata    = su_tlv_len;
      5'h2 : su_axi_tdata    = in_fifo_rdata.tlv_seq_num;
      5'h3 : su_axi_tdata    = {4'b0,in_fifo_rdata.tlv_eng_id};
      5'h4 : su_axi_tdata    = 8'h0;  
      5'h5 : su_axi_tdata    = {in_fifo_rdata.rqe_sched_handle[4:0], 3'h0}; 
      5'h6 : su_axi_tdata    = in_fifo_rdata.rqe_sched_handle[12:5];
      5'h7 : su_axi_tdata    = {su_tlv_bip2, in_fifo_rdata.last, 2'b0, in_fifo_rdata.rqe_sched_handle[15:13]};
      
      5'h8 : su_axi_tdata    = adj_bytes_out[7:0];
      5'h9 : su_axi_tdata    = adj_bytes_out[15:8];
      5'ha : su_axi_tdata    = adj_bytes_out[23:16];
      5'hb : su_axi_tdata    = 8'b0;
      5'hc : su_axi_tdata    = adj_bytes_in[7:0];
      5'hd : su_axi_tdata    = adj_bytes_in[15:8];
      5'he : su_axi_tdata    = adj_bytes_in[23:16];
      5'hf : su_axi_tdata    = 8'b0;
      
      5'h10 : su_axi_tdata   = in_fifo_rdata.basis[7:0]; 
      5'h11 : su_axi_tdata   = in_fifo_rdata.basis[15:8];
      5'h12 : su_axi_tdata   = in_fifo_rdata.basis[23:16];
      default: su_axi_tdata  = 8'b0;
    endcase
  end

  assign out_fifo_wdata.tvalid  = 1'b1;
  assign out_fifo_wdata.tlast   = su_axi_tlast;
  assign out_fifo_wdata.tuser   = su_axi_tuser;
  assign out_fifo_wdata.tdata   = su_axi_tdata;

  
  
  
  assign hb_sup.wr_pointer  = su_hb_add;

  always @(posedge clk or negedge rst_n) 
  begin
    if (~rst_n) 
    begin
      for (int i=0; i<8; i++) 
      begin
        su_hb[i] <= 108'h0; 
      end
      su_hb_add <= 3'h0;
    end
    else 
    begin
      if(su_hb_wr) 
      begin
        su_hb[su_hb_add] <= {in_fifo_rdata.last, 
                             in_fifo_rdata.tlv_frame_num,  
                             in_fifo_rdata.rqe_sched_handle, 
                             in_fifo_rdata.tlv_seq_num,
                             in_fifo_rdata.basis, 
                             in_fifo_rdata.bytes_in, 
                             in_fifo_rdata.bytes_out};

        su_hb_add        <= su_hb_add + 3'h1;
      end
    end
  end
   
endmodule 









