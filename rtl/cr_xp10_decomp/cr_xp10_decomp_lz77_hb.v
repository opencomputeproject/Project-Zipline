/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
module cr_xp10_decomp_lz77_hb (
   
   bimc_odat, bimc_osync, hb_ag_rdata,
   lz77_hb_ro_uncorrectable_ecc_error_a,
   lz77_hb_ro_uncorrectable_ecc_error_b,
   lz77_pfx0_ro_uncorrectable_ecc_error,
   lz77_pfx1_ro_uncorrectable_ecc_error,
   lz77_pfx2_ro_uncorrectable_ecc_error,
   
   clk, rst_n, ovstb, lvm, mlvm, bimc_idat, bimc_isync, bimc_rst_n,
   ag_ep_hb_wr, ag_hb_waddr, ag_hb_wdata, ag_hb_rd, ag_hb_raddr,
   ag_hb_eof, pl_hb_pfx0_pld_wr, pl_hb_pfx0_pld_waddr,
   pl_hb_pfx0_pld_wdata, pl_hb_pfx1_pld_wr, pl_hb_pfx1_pld_waddr,
   pl_hb_pfx1_pld_wdata, pl_hb_pfx2_pld_wr, pl_hb_pfx2_pld_waddr,
   pl_hb_pfx2_pld_wdata, pl_hb_pfx0_in_use, pl_hb_pfx1_in_use,
   pl_hb_pfx2_in_use, pl_hb_usr_wr, pl_hb_usr_wdata, pl_hb_usr_waddr
   );
   
   import crPKG::lz_symbol_bus_t;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   
   
   
   input                               clk;
   input                               rst_n; 
   
   
   
   
   input                               ovstb;
   input                               lvm;
   input                               mlvm;
   input                               bimc_idat;
   input                               bimc_isync;
   input                               bimc_rst_n;
   output logic                        bimc_odat;
   output logic                        bimc_osync;
   
   input                               ag_ep_hb_wr;
   input [11:0]                        ag_hb_waddr;
   input [127:0]                       ag_hb_wdata;
   
   input                               ag_hb_rd;
   input [11:0]                        ag_hb_raddr;
   output logic [127:0]                hb_ag_rdata;

   input                               ag_hb_eof;

   input                               pl_hb_pfx0_pld_wr;
   input [5:0]                         pl_hb_pfx0_pld_waddr;
   input [127:0]                       pl_hb_pfx0_pld_wdata;
   
   input                               pl_hb_pfx1_pld_wr;
   input [5:0]                         pl_hb_pfx1_pld_waddr;
   input [127:0]                       pl_hb_pfx1_pld_wdata;

   input                               pl_hb_pfx2_pld_wr;
   input [5:0]                         pl_hb_pfx2_pld_waddr;
   input [127:0]                       pl_hb_pfx2_pld_wdata;
   
   input                               pl_hb_pfx0_in_use;
   input                               pl_hb_pfx1_in_use;
   input                               pl_hb_pfx2_in_use;

   input                               pl_hb_usr_wr;
   input [127:0]                       pl_hb_usr_wdata;
   input [11:0]                        pl_hb_usr_waddr;

   output logic                        lz77_hb_ro_uncorrectable_ecc_error_a;
   output logic                        lz77_hb_ro_uncorrectable_ecc_error_b;
   output logic                        lz77_pfx0_ro_uncorrectable_ecc_error;
   output logic                        lz77_pfx1_ro_uncorrectable_ecc_error;
   output logic                        lz77_pfx2_ro_uncorrectable_ecc_error;
   
   
   logic                               pfx0_wr;
   logic [5:0]                         pfx0_waddr;
   logic [127:0]                       pfx0_wdata;
   
   logic                               pfx1_wr;
   logic [5:0]                         pfx1_waddr;
   logic [127:0]                       pfx1_wdata;

   logic                               pfx2_wr;
   logic [5:0]                         pfx2_waddr;
   logic [127:0]                       pfx2_wdata;
   
   logic                               hb_wr;
   logic [11:0]                        hb_waddr;
   logic [127:0]                       hb_wdata;
   
   logic                               hb_rd;
   logic [11:0]                        hb_raddr;
   logic [11:0]                        r_hb_raddr; 
   logic                               pfx0_rd;
   logic [5:0]                         pfx0_raddr;
   logic                               pfx1_rd;
   logic [5:0]                         pfx1_raddr;
   logic                               pfx2_rd;
   logic [5:0]                         pfx2_raddr;
   logic                               r_pfx0_rd;
   logic                               r_pfx1_rd;
   logic                               r_pfx2_rd;
   logic                               rr_pfx0_rd;
   logic                               rr_pfx1_rd;
   logic                               rr_pfx2_rd;

   logic [127:0]                       pfx0_rdata;
   logic [127:0]                       pfx1_rdata;
   logic [127:0]                       pfx2_rdata;
   logic [127:0]                       r_pfx0_rdata;
   logic [127:0]                       r_pfx1_rdata;
   logic [127:0]                       r_pfx2_rdata;
   logic [127:0]                       hb_rdata;

   logic                               pfx0_hb_wr;
   logic [5:0]                         pfx0_hb_waddr;
   logic [127:0]                       pfx0_hb_wdata;

   logic                               pfx1_hb_wr;
   logic [5:0]                         pfx1_hb_waddr;
   logic [127:0]                       pfx1_hb_wdata;

   logic                               pfx2_hb_wr;
   logic [5:0]                         pfx2_hb_waddr;
   logic [127:0]                       pfx2_hb_wdata;

   logic [11:0]                        usr_waddr;

   logic                               bimc_pfx0_odat;
   logic                               bimc_pfx0_osync;
   logic                               bimc_pfx1_odat;
   logic                               bimc_pfx1_osync;
   logic                               bimc_hb_odat;
   logic                               bimc_hb_osync;

   logic                               read_pfx;



   logic                               pfx0_ro_uncorrectable_ecc_error;
   logic                               pfx1_ro_uncorrectable_ecc_error;
   logic                               pfx2_ro_uncorrectable_ecc_error;

   
   assign pfx0_wr = pfx0_hb_wr || pl_hb_pfx0_pld_wr;
   assign pfx0_waddr = pfx0_hb_wr ? pfx0_hb_waddr : pl_hb_pfx0_pld_waddr;
   assign pfx0_wdata = pfx0_hb_wr ? pfx0_hb_wdata : pl_hb_pfx0_pld_wdata;

   assign pfx1_wr = pfx1_hb_wr || pl_hb_pfx1_pld_wr;
   assign pfx1_waddr = pfx1_hb_wr ? pfx1_hb_waddr : pl_hb_pfx1_pld_waddr;
   assign pfx1_wdata = pfx1_hb_wr ? pfx1_hb_wdata : pl_hb_pfx1_pld_wdata;

   assign pfx2_wr = pfx2_hb_wr || pl_hb_pfx2_pld_wr;
   assign pfx2_waddr = pfx2_hb_wr ? pfx2_hb_waddr : pl_hb_pfx2_pld_waddr;
   assign pfx2_wdata = pfx2_hb_wr ? pfx2_hb_wdata : pl_hb_pfx2_pld_wdata;
   
   always_comb
     begin
        pfx0_hb_wr = 1'b0;
        pfx1_hb_wr = 1'b0;
        pfx2_hb_wr = 1'b0;
        hb_wr = 1'b0;
        pfx0_rd = 1'b0;
        pfx1_rd = 1'b0;
        pfx2_rd = 1'b0;
        hb_rd = 1'b0;
        pfx0_hb_waddr = '0;
        pfx1_hb_waddr = '0;
        pfx2_hb_waddr = '0;
        pfx0_hb_wdata = '0;
        pfx1_hb_wdata = '0;
        pfx2_hb_wdata = '0;
        hb_waddr = '0;
        pfx0_raddr = '0;
        pfx1_raddr = '0;
        pfx2_raddr = '0;
        hb_raddr = '0;
        hb_wdata = '0;
        
        if (ag_ep_hb_wr) begin
           if (ag_hb_waddr < `CR_LZ_PRFX_SZ) begin
              if (pl_hb_pfx0_in_use) begin
                 pfx0_hb_wr = 1'b1;
                 pfx0_hb_waddr = ag_hb_waddr[5:0];
                 pfx0_hb_wdata = ag_hb_wdata;
              end
              else if (pl_hb_pfx1_in_use) begin
                 pfx1_hb_wr = 1'b1;
                 pfx1_hb_waddr = ag_hb_waddr[5:0];
                 pfx1_hb_wdata = ag_hb_wdata;
              end
              else if (pl_hb_pfx2_in_use) begin
                 pfx2_hb_wr = 1'b1;
                 pfx2_hb_waddr = ag_hb_waddr[5:0];
                 pfx2_hb_wdata = ag_hb_wdata;
              end
              else begin
                 hb_wr = 1'b1;
                 hb_waddr = ag_hb_waddr;
                 hb_wdata = ag_hb_wdata;
              end
           end
           else begin
              hb_wr = 1'b1;
              hb_waddr = ag_hb_waddr;
              hb_wdata = ag_hb_wdata;
           end
        end 
        else if (pl_hb_usr_wr) begin
           hb_wr = 1'b1;
           hb_waddr = pl_hb_usr_waddr;
           hb_wdata = pl_hb_usr_wdata;
        end
        if (ag_hb_rd) begin
           if (ag_hb_raddr < `CR_LZ_PRFX_SZ) begin
              if (pl_hb_pfx0_in_use) begin
                 pfx0_rd = 1'b1;
                 pfx0_raddr = ag_hb_raddr[5:0];
              end
              else if (pl_hb_pfx1_in_use) begin
                 pfx1_rd = 1'b1;
                 pfx1_raddr = ag_hb_raddr[5:0];
              end
              else if (pl_hb_pfx2_in_use) begin
                 pfx2_rd = 1'b1;
                 pfx2_raddr = ag_hb_raddr[5:0];
              end
              else begin
                 hb_rd = 1'b1;
                 hb_raddr = ag_hb_raddr;
              end
           end
           else begin
              hb_rd = 1'b1;
              hb_raddr = ag_hb_raddr;
           end
        end 
      
        if (rr_pfx0_rd) hb_ag_rdata = r_pfx0_rdata;
        else if (rr_pfx1_rd) hb_ag_rdata = r_pfx1_rdata;
        else if (rr_pfx2_rd) hb_ag_rdata = r_pfx2_rdata;
        else hb_ag_rdata = hb_rdata;

     end 

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         usr_waddr <= 12'd64;
         
         
         r_hb_raddr <= 0;
         r_pfx0_rd <= 0;
         r_pfx0_rdata <= 0;
         r_pfx1_rd <= 0;
         r_pfx1_rdata <= 0;
         r_pfx2_rd <= 0;
         r_pfx2_rdata <= 0;
         read_pfx <= 0;
         rr_pfx0_rd <= 0;
         rr_pfx1_rd <= 0;
         rr_pfx2_rd <= 0;
         
      end
      else begin
         if (ag_hb_eof)
           usr_waddr <= 12'd64;
         else if (pl_hb_usr_wr)
           usr_waddr <= usr_waddr + 1;

         r_pfx0_rdata <= pfx0_rdata;
         r_pfx1_rdata <= pfx1_rdata;
         r_pfx2_rdata <= pfx2_rdata;
         
         r_pfx0_rd <= pfx0_rd;
         r_pfx1_rd <= pfx1_rd;
         r_pfx2_rd <= pfx2_rd;
         rr_pfx0_rd <= r_pfx0_rd;
         rr_pfx1_rd <= r_pfx1_rd;
         rr_pfx2_rd <= r_pfx2_rd;

         
         if (pfx0_rd || pfx1_rd || pfx2_rd)
           read_pfx <= 1'b1;
         else if (ag_hb_rd)
           read_pfx <= 1'b0;

         if (hb_rd)
           r_hb_raddr <= hb_raddr;
         
      end 
   end 


   nx_ram_2rw 
     #(.WIDTH(128),
       .DEPTH(4096),
       .IN_FLOP(0),
       .OUT_FLOP(0),
       .RD_LATENCY(1),
       .SPECIALIZE(0))
   hb_inst
     (
      
      .bimc_odat			(bimc_hb_odat),
      .bimc_osync			(bimc_hb_osync),
      .ro_uncorrectable_ecc_error	(),
      .douta				(hb_rdata),		
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
      .adda				(hb_raddr),		 
      .csa				(hb_rd),		 
      .wea				(1'b0),			 
      .bweb				({128{1'b1}}),		 
      .dinb				(hb_wdata),		 
      .addb				(hb_waddr),		 
      .csb				(hb_wr),
      .web				(hb_wr));

   nx_ram_1r1w #(.DEPTH (64), .WIDTH(128)) prefix0 
     (.rst_n (rst_n),
      .clk (clk),
      .reb (!pfx0_rd),
      .ra (pfx0_raddr),
      .dout (pfx0_rdata),
      .web (!pfx0_wr),
      .wa (pfx0_waddr),
      .din (pfx0_wdata),
      .bwe (128'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff),
      .lvm(lvm), 
      .mlvm(mlvm), 
      .mrdten(1'b0),
      .bimc_rst_n(bimc_rst_n),
      .bimc_isync(bimc_hb_osync),
      .bimc_idat(bimc_hb_odat),
      .bimc_odat(bimc_pfx0_odat),
      .bimc_osync(bimc_pfx0_osync),
      .ro_uncorrectable_ecc_error(pfx0_ro_uncorrectable_ecc_error));

   nx_ram_1r1w #(.DEPTH (64), .WIDTH(128)) prefix1
     (.rst_n (rst_n),
      .clk (clk),
      .reb (!pfx1_rd),
      .ra (pfx1_raddr),
      .dout (pfx1_rdata),
      .web (!pfx1_wr),
      .wa (pfx1_waddr),
      .din (pfx1_wdata),
      .bwe (128'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff),
      .lvm(lvm), 
      .mlvm(mlvm), 
      .mrdten(1'b0),
      .bimc_rst_n(bimc_rst_n),
      .bimc_isync(bimc_pfx0_osync),
      .bimc_idat(bimc_pfx0_odat),
      .bimc_odat(bimc_pfx1_odat),
      .bimc_osync(bimc_pfx1_osync),
      .ro_uncorrectable_ecc_error(pfx1_ro_uncorrectable_ecc_error));

   nx_ram_1r1w #(.DEPTH (64), .WIDTH(128)) prefix2
     (.rst_n (rst_n),
      .clk (clk),
      .reb (!pfx2_rd),
      .ra (pfx2_raddr),
      .dout (pfx2_rdata),
      .web (!pfx2_wr),
      .wa (pfx2_waddr),
      .din (pfx2_wdata),
      .bwe (128'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff),
      .lvm(lvm), 
      .mlvm(mlvm), 
      .mrdten(1'b0),
      .bimc_rst_n(bimc_rst_n),
      .bimc_isync(bimc_pfx1_osync),
      .bimc_idat(bimc_pfx1_odat),
      .bimc_odat(bimc_odat),
      .bimc_osync(bimc_osync),
      .ro_uncorrectable_ecc_error(pfx2_ro_uncorrectable_ecc_error));

      always @(posedge clk or negedge rst_n) begin
         if (!rst_n) begin
            
            
            lz77_hb_ro_uncorrectable_ecc_error_a <= 0;
            lz77_hb_ro_uncorrectable_ecc_error_b <= 0;
            lz77_pfx0_ro_uncorrectable_ecc_error <= 0;
            lz77_pfx1_ro_uncorrectable_ecc_error <= 0;
            lz77_pfx2_ro_uncorrectable_ecc_error <= 0;
            
         end
         else begin
           lz77_pfx1_ro_uncorrectable_ecc_error <= pfx1_ro_uncorrectable_ecc_error;
            lz77_pfx0_ro_uncorrectable_ecc_error <= pfx0_ro_uncorrectable_ecc_error;
            lz77_pfx2_ro_uncorrectable_ecc_error <= pfx2_ro_uncorrectable_ecc_error;
            lz77_hb_ro_uncorrectable_ecc_error_a <= 1'b0;
            lz77_hb_ro_uncorrectable_ecc_error_b <= 1'b0;
         end
      end 

   
   `COVER_PROPERTY(read_pfx && ag_hb_rd && hb_rd && (ag_hb_raddr == 12'h040));
   `COVER_PROPERTY(hb_rd && (ag_hb_raddr == usr_waddr) && (r_hb_raddr == (usr_waddr -1)) && (usr_waddr > 12'h040));
   
endmodule 







