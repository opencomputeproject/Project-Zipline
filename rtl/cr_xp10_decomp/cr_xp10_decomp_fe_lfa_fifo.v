/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
module cr_xp10_decomp_fe_lfa_fifo(
   
   rd_avail, waddr, rdata, empty, avail, bimc_odat, bimc_osync,
   fe_lfa_ro_uncorrectable_ecc_error_a,
   fe_lfa_ro_uncorrectable_ecc_error_b,
   
   clk, rst_n, wdata, wr, rd, raddr, rd_ack, rd_ack_addr, ovstb, lvm,
   mlvm, bimc_idat, bimc_isync, bimc_rst_n
   );
   
   import crPKG::*;
   import cr_xp10_decompPKG::*;
   import cr_xp10_decomp_regsPKG::*;

   input                           clk;
   input                           rst_n;
   input fe_dp_bus_t               wdata;
   input                           wr;
   input                           rd;
   input [9:0]                     raddr;
   input                           rd_ack;
   input [9:0]                     rd_ack_addr;
   output logic                    rd_avail;
   
   output logic [9:0]              waddr;
   
   output fe_dp_bus_t              rdata;
   output logic                    empty;
   output logic                    avail;

   input                          ovstb;
   input                          lvm;
   input                          mlvm;
   
   input                          bimc_idat;
   input                          bimc_isync;
   input                          bimc_rst_n;
   output logic                   bimc_odat;
   output logic                   bimc_osync;

   output logic                   fe_lfa_ro_uncorrectable_ecc_error_a;
   output logic                   fe_lfa_ro_uncorrectable_ecc_error_b;
   
   logic [9:0]                    tail_ptr;
   logic [9:0]                    head_ptr;
   logic [9:0]                    new_head_ptr;
   
   logic                          wr_pg;
   logic                          rd_pg;

   logic                          lfa_ro_uncorrectable_ecc_error_a;
   logic                          lfa_ro_uncorrectable_ecc_error_b;
   logic                          rd_val;
   
   assign waddr = tail_ptr;
   assign rd_val = rd && rd_avail;
   
   always_comb
     begin
        if ((wr_pg == rd_pg) && (tail_ptr == head_ptr))
          empty = 1'b1;
        else
          empty = 1'b0;
        
        if (wr_pg == rd_pg) begin 
           if ((tail_ptr < `LFA_MEM_SZ) &&
               ((head_ptr + `LFA_MEM_SZ) - tail_ptr) > `LFA_MEM_AEMPTY)
             avail = 1'b1;
           else
             avail = 1'b0;
        end
        else if ((head_ptr - tail_ptr) > `LFA_MEM_AEMPTY)
          avail = 1'b1;
        else
          avail = 1'b0;

        rd_avail = check_if_rd_valid(waddr, raddr, head_ptr, wr_pg, rd_pg);

     end 

   assign new_head_ptr = rd_ack_addr;
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         fe_lfa_ro_uncorrectable_ecc_error_a <= 0;
         fe_lfa_ro_uncorrectable_ecc_error_b <= 0;
         head_ptr <= 0;
         rd_pg <= 0;
         tail_ptr <= 0;
         wr_pg <= 0;
         
      end
      else begin
         if (wr) begin
            if (tail_ptr == (`LFA_MEM_SZ-1))
              wr_pg <= ~wr_pg;
            else
              wr_pg <= wr_pg;
            tail_ptr <= tail_ptr + 1;
         end
         if (rd_ack) begin
            head_ptr <= new_head_ptr;
            if (new_head_ptr < head_ptr)
              rd_pg <= ~rd_pg;
         end
         fe_lfa_ro_uncorrectable_ecc_error_a <= lfa_ro_uncorrectable_ecc_error_a;
         fe_lfa_ro_uncorrectable_ecc_error_b <= lfa_ro_uncorrectable_ecc_error_b;
         
      end 
   end 

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

   nx_ram_2rw 
     #(.WIDTH(70),
       .DEPTH(1024),
       .IN_FLOP(0),
       .OUT_FLOP(0),
       .RD_LATENCY(1),
       .SPECIALIZE(0))
   lfa_inst
     (
      
      .bimc_odat			(bimc_odat),
      .bimc_osync			(bimc_osync),
      .ro_uncorrectable_ecc_error	(),
      .douta				(rdata),		
      .doutb				(),		        
      
      .clk				(clk),		
      .rst_n				(rst_n ),		 
      .ovstb				('0),
      .lvm				('0),
      .mlvm				('0),
      .mrdten				('0),
      .bimc_rst_n			(bimc_rst_n),		 
      .bimc_isync			(bimc_isync),
      .bimc_idat			(bimc_idat),
      .bwea				('0), 
      .dina				('0), 
      .adda				(raddr),		 
      .csa				(rd_val),		 
      .wea				(1'b0),			 
      .bweb				({70{1'b1}}),		 
      .dinb				(wdata),		 
      .addb				(waddr),		 
      .csb				(wr),
      .web				(wr));

   assign lfa_ro_uncorrectable_ecc_error_a = 0;
   assign lfa_ro_uncorrectable_ecc_error_b = 0;
   
   
   

   function logic check_if_rd_valid;
      input [9:0] w_addr;
      input [9:0] r_addr;
      input [9:0] h_addr;
      input       w_pg;
      input       r_pg;
      logic       r_val;
      
      begin
         if (w_pg == r_pg) begin
           if ((r_addr < w_addr) &&
               (r_addr >= h_addr))
             r_val = 1'b1;
           else
             r_val = 1'b0;
         end
         else begin

 

            if ((r_addr >= h_addr) ||
                (r_addr < w_addr))
              r_val = 1'b1;
            else
              r_val = 1'b0;
         end 
         check_if_rd_valid = r_val;
         
      end
   endfunction 
   
endmodule 







