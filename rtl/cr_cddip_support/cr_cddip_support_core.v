/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_cddip_support.vh"

module cr_cddip_support_core 
  (
  
  pipe_stat, cddip_int, cddip_idle, sup_osf_halt,
  
  clk, rst_n, osf_sup_cqe_exit, isf_sup_cqe_exit, isf_sup_cqe_rx,
  isf_sup_rqe_rx, pre_cddip_int
  );
   	    
`include "cr_structs.sv"
      
  import cr_cddip_supportPKG::*;
  import cr_cddip_support_regsPKG::*;

 
 
 
  input         clk;
  input         rst_n; 
	
  
  
  
  input                        osf_sup_cqe_exit;
  input                        isf_sup_cqe_exit;
  input                        isf_sup_cqe_rx;
  input                        isf_sup_rqe_rx;
  output pipe_stat_t           pipe_stat;

  
  
  
  output reg                   cddip_int;
  input                        pre_cddip_int;

  
  
  
  output reg                   cddip_idle;

  
  
  
  output reg                   sup_osf_halt;

  

  
  
  
  logic [7:0] pipe_cmd_cnt;
  logic [7:0] isf_cmd_cnt;
  logic [7:0] cqe_cnt;

  
  assign pipe_stat.isf_busy  = isf_cmd_cnt > 8'h0;
  assign pipe_stat.data_busy = pipe_cmd_cnt > 8'h0;
  assign pipe_stat.comp_busy = cqe_cnt > 8'h0;
  assign pipe_stat.isf_cmds  = isf_cmd_cnt;
  assign pipe_stat.pipe_cmds = pipe_cmd_cnt;

  always_ff @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
    begin
      
      
      cddip_idle <= 0;
      cddip_int <= 0;
      cqe_cnt <= 0;
      isf_cmd_cnt <= 0;
      pipe_cmd_cnt <= 0;
      sup_osf_halt <= 0;
      
    end
    else
    begin
      cddip_int    <= pre_cddip_int;

      
      sup_osf_halt <= pre_cddip_int;

      
      cddip_idle   <= (pipe_cmd_cnt == 8'h0);


      
      
      
      
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









