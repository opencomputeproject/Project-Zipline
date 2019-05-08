/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/















`include "cr_cceip_64_support.vh"

module cr_cceip_64_support_core 
  (
  
  crcg0_ib_out, crcc1_ib_out, df_mux_ob_out, pipe_stat, cceip_int,
  cceip_idle, sup_osf_halt,
  
  clk, rst_n, crcc0_crcg0_ib_out, crcg0_ib_in, cg_crcc1_ib_out,
  crcc1_ib_in, df_mux_sel, df_mux_ob_in, osf_sup_cqe_exit,
  isf_sup_cqe_exit, isf_sup_cqe_rx, isf_sup_rqe_rx, cceip_int0,
  cceip_int1
  );
   	    
`include "cr_structs.sv"
      
  import cr_cceip_64_supportPKG::*;
  import cr_cceip_64_support_regsPKG::*;

 
 
 
  input         clk;
  input         rst_n; 
	
  
  
  
  input  axi4s_dp_rdy_t        crcc0_crcg0_ib_out;
  input  axi4s_dp_bus_t        crcg0_ib_in;
  output axi4s_dp_rdy_t        crcg0_ib_out;

  input  axi4s_dp_rdy_t        cg_crcc1_ib_out;
  input  axi4s_dp_bus_t        crcc1_ib_in;
  output axi4s_dp_rdy_t        crcc1_ib_out;

  input  [`CR_CCEIP_64_SUPPORT_DF_MUX_CTRL_T_DF_MUX_SEL_DECL] df_mux_sel;
 
 
 
  input  axi4s_dp_rdy_t        df_mux_ob_in;
  output axi4s_dp_bus_t        df_mux_ob_out;

  
  
  
  input                        osf_sup_cqe_exit;
  input                        isf_sup_cqe_exit;
  input                        isf_sup_cqe_rx;
  input                        isf_sup_rqe_rx;
  output pipe_stat_t           pipe_stat;

  
  
  
  output reg                   cceip_int;
  input                        cceip_int0;
  input                        cceip_int1;

  
  
  
  output reg                   cceip_idle;

  
  
  
  output reg                   sup_osf_halt;

  
  
  
  
  logic [7:0] pipe_cmd_cnt;
  logic [7:0] isf_cmd_cnt;
  logic [7:0] cqe_cnt;

  
  
  
  
  
  
 
  always_comb
  begin
    
    crcg0_ib_out.tready  = 1'b1;
    crcc1_ib_out.tready  = 1'b1;

    case (df_mux_sel)
      1'b0:
      begin

        
        
	df_mux_ob_out.tvalid  = crcc0_crcg0_ib_out.tready ? crcg0_ib_in.tvalid : 1'b0;
	df_mux_ob_out.tlast   = crcg0_ib_in.tlast;
	df_mux_ob_out.tid     = crcg0_ib_in.tid;
	df_mux_ob_out.tstrb   = crcg0_ib_in.tstrb;   
	df_mux_ob_out.tuser   = crcg0_ib_in.tuser;  
	df_mux_ob_out.tdata   = crcg0_ib_in.tdata;  
        crcg0_ib_out          = df_mux_ob_in;
      end

      1'b1:
      begin

        
        
	df_mux_ob_out.tvalid  = cg_crcc1_ib_out.tready ? crcc1_ib_in.tvalid : 1'b0;
	df_mux_ob_out.tlast   = crcc1_ib_in.tlast;
	df_mux_ob_out.tid     = crcc1_ib_in.tid;
	df_mux_ob_out.tstrb   = crcc1_ib_in.tstrb;   
	df_mux_ob_out.tuser   = crcc1_ib_in.tuser;  
	df_mux_ob_out.tdata   = crcc1_ib_in.tdata;  
        crcc1_ib_out          = df_mux_ob_in;
      end
    endcase
  end

  
  
  
  
  

  
  assign pipe_stat.isf_busy  = isf_cmd_cnt > 8'h0;
  assign pipe_stat.data_busy = pipe_cmd_cnt > 8'h0;
  assign pipe_stat.comp_busy = cqe_cnt > 8'h0;
  assign pipe_stat.isf_cmds  = isf_cmd_cnt;
  assign pipe_stat.pipe_cmds = pipe_cmd_cnt;


  always_ff @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
    begin
      
      
      cceip_idle <= 0;
      cceip_int <= 0;
      cqe_cnt <= 0;
      isf_cmd_cnt <= 0;
      pipe_cmd_cnt <= 0;
      sup_osf_halt <= 0;
      
    end
    else
    begin
      cceip_int    <= cceip_int0 || cceip_int1;

      
      sup_osf_halt <= cceip_int0 || cceip_int1;

      
      cceip_idle   <= (pipe_cmd_cnt == 8'h0);

      
      
      
      
      if (isf_sup_rqe_rx && !osf_sup_cqe_exit)
      begin
        pipe_cmd_cnt <= pipe_cmd_cnt + 8'h1;
      end
      else if (!isf_sup_rqe_rx && osf_sup_cqe_exit)
      begin
        pipe_cmd_cnt <= pipe_cmd_cnt - 8'h1;
      end
      else if (isf_sup_rqe_rx && osf_sup_cqe_exit)
      begin
        pipe_cmd_cnt <= pipe_cmd_cnt;
      end

      
      
      
      
      if (isf_sup_rqe_rx && !isf_sup_cqe_exit)
      begin
        isf_cmd_cnt <= isf_cmd_cnt + 8'h1;
      end
      else if (!isf_sup_rqe_rx && isf_sup_cqe_exit)
      begin
        isf_cmd_cnt <= isf_cmd_cnt - 8'h1;
      end
      else if (isf_sup_rqe_rx && isf_sup_cqe_exit)
      begin
        isf_cmd_cnt <= isf_cmd_cnt;
      end

      
      
      
      
      if (isf_sup_cqe_rx && !osf_sup_cqe_exit)
      begin
        cqe_cnt <= cqe_cnt + 8'h1;
      end
      else if (!isf_sup_cqe_rx && osf_sup_cqe_exit)
      begin
        cqe_cnt <= cqe_cnt - 8'h1;
      end
      else if (isf_sup_cqe_rx && osf_sup_cqe_exit)
      begin
        cqe_cnt <= cqe_cnt;
      end
    end
  end




endmodule 









