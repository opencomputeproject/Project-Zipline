/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/























module cr_osf_debug_ctl
(
  
  fifo_hw_rd, fifo_hw_wr, fifo_empty_mod,
  
  clk, rst_n, fifo_debug_mode, single_step_rd, fifo_empty, fifo_full,
  ob_rd_ok, src_empty
  );
  
`include "cr_structs.sv"
  
  import cr_osfPKG::*;
  import cr_osf_regsPKG::*;

  
  
  
  input                                    clk;
  input                                    rst_n; 
  
  
  
  
  input [1:0]                              fifo_debug_mode;  
  input                                    single_step_rd;

  
  
  
  input                                    fifo_empty;
  input                                    fifo_full;
  output reg                               fifo_hw_rd;
  output reg                               fifo_hw_wr;

  
  
  
  input                                    ob_rd_ok;
  input                                    src_empty;
  output reg                               fifo_empty_mod;

  
  
  
  osf_debug_mode_e                         fifo_debug_mode_fmt;

  
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  assign fifo_debug_mode_fmt =  osf_debug_mode_e'(fifo_debug_mode);

  always_comb
  begin
    case (fifo_debug_mode)
      
      
      OSF_DEBUG_NORMAL:
      begin
        fifo_hw_rd      = ob_rd_ok;  
        fifo_empty_mod  = fifo_empty; 
        fifo_hw_wr      = !src_empty && !fifo_full;  
      end

      
      
      OSF_DEBUG_BLK_RDWR:
      begin
        fifo_hw_rd      = 1'b0;
        fifo_empty_mod  = 1'b1;
        fifo_hw_wr      = 1'b0;
      end

      
      
      
      OSF_DEBUG_BLK_RD:
      begin
        fifo_hw_rd      = 1'b0;
        fifo_empty_mod  = 1'b1;
        fifo_hw_wr      = !src_empty && !fifo_full;  
      end

      
      
      
      
      OSF_DEBUG_SS:
      begin
        fifo_hw_rd      = ob_rd_ok;  
        
        fifo_empty_mod  = !single_step_rd; 
        fifo_hw_wr      = !src_empty && !fifo_full;  
      end

      
      
      
      
      default:
      begin
        fifo_hw_rd      = ob_rd_ok;  
        fifo_empty_mod  = fifo_empty; 
        fifo_hw_wr      = !src_empty && !fifo_full;  
      end
    endcase
  end

endmodule 












