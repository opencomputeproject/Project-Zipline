/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
















`include "cr_huf_comp.vh"

module cr_huf_comp_ph
  (
   
   ph_bimc_odat, ph_bimc_osync, ph_sa_ro_uncorrectable_ecc_error,
   ph_long_hw1_intf, ph_long_hw2_intf, ph_long_hw1_val,
   ph_long_hw2_val, ph_short_hw1_intf, ph_short_hw2_intf,
   ph_short_hw1_val, ph_short_hw2_val,
   
   clk, rst_n, lvm, mlvm, mrdten, ph_bimc_rst_n, ph_bimc_isync,
   ph_bimc_idat, sm_predet_mem_long_intf, sm_predet_mem_shrt_intf,
   seq_id_intf_array, long_hw1_ph_intf, long_hw2_ph_intf,
   short_hw1_ph_intf, short_hw2_ph_intf
   );
   
`include "cr_structs.sv"
   
   import cr_huf_compPKG::*;
   import cr_huf_comp_regsPKG::*;
   
   
   
   input                              clk;
   input 			      rst_n;
   
   
   
   input 			      lvm;
   input 			      mlvm;
   input 			      mrdten;
   input  			      ph_bimc_rst_n;
   input  			      ph_bimc_isync;
   input  			      ph_bimc_idat;   
   output logic  		      ph_bimc_odat;   
   output logic  		      ph_bimc_osync;
   output logic 		      ph_sa_ro_uncorrectable_ecc_error;                          
   
   
   
   input  s_sm_predet_mem_intf        sm_predet_mem_long_intf; 
   input  s_sm_predet_mem_intf        sm_predet_mem_shrt_intf;
   
   
   
   input  s_sm_seq_id_intf            seq_id_intf_array[`CREOLE_HC_SEQID_NUM]; 
   
   
   
   input  s_hw_ph_intf                long_hw1_ph_intf;
   input  s_hw_ph_intf                long_hw2_ph_intf;
   input  s_hw_ph_intf                short_hw1_ph_intf;
   input  s_hw_ph_intf                short_hw2_ph_intf;

   
   output s_ph_hw_intf                ph_long_hw1_intf;
   output s_ph_hw_intf                ph_long_hw2_intf;
   output logic                       ph_long_hw1_val;
   output logic                       ph_long_hw2_val;
   
   output s_ph_hw_intf                ph_short_hw1_intf;
   output s_ph_hw_intf                ph_short_hw2_intf;
   output logic                       ph_short_hw1_val;
   output logic                       ph_short_hw2_val;
   
   
   logic                              ph_long_hw1_val_pre;
   logic 			      ph_long_hw2_val_pre;
   logic 			      ph_short_hw1_val_pre;
   logic 			      ph_short_hw2_val_pre;
   
   s_hw_ph_intf                       long_hw1_ph_intf_reg;
   s_hw_ph_intf                       long_hw2_ph_intf_reg;
   s_hw_ph_intf                       short_hw1_ph_intf_reg;
   s_hw_ph_intf                       short_hw2_ph_intf_reg;

   logic  		   	           wr_long;
   logic  				   wr_shrt;
   logic [`CREOLE_HC_PHT_WIDTH-1:0] 	   rd_data_long_1;
   logic [`CREOLE_HC_PHT_WIDTH-1:0] 	   rd_data_long_2;
   logic [`CREOLE_HC_PHT_WIDTH-1:0] 	   rd_data_shrt_1;
   logic [`CREOLE_HC_PHT_WIDTH-1:0] 	   rd_data_shrt_2;
   logic [7:0] 				   rd_addr_long_1; 
   logic [7:0] 				   rd_addr_long_2; 
   logic [8:0] 				   rd_addr_shrt_1;
   logic [8:0] 				   rd_addr_shrt_2;
   logic [7:0] 				   wr_addr_long; 
   logic [8:0] 				   wr_addr_shrt;
   
   logic  				   bimc_isync_long_1;
   logic  				   bimc_idat_long_1;   
   logic  				   bimc_odat_long_1;   
   logic  				   bimc_osync_long_1;  
   logic  				   bimc_isync_long_2;
   logic  				   bimc_idat_long_2;   
   logic  				   bimc_odat_long_2;   
   logic  				   bimc_osync_long_2;  
   logic  				   bimc_isync_shrt_1;
   logic  				   bimc_idat_shrt_1;   
   logic  				   bimc_odat_shrt_1;   
   logic  				   bimc_osync_shrt_1; 
   logic  				   bimc_isync_shrt_2;
   logic  				   bimc_idat_shrt_2;   
   logic  				   bimc_odat_shrt_2;   
   logic  				   bimc_osync_shrt_2;
   logic  				   ro_uncorrectable_ecc_error_long_1;
   logic  				   ro_uncorrectable_ecc_error_long_2;
   logic  				   ro_uncorrectable_ecc_error_shrt_1;
   logic  				   ro_uncorrectable_ecc_error_shrt_2;
   
	  
   always_comb begin
      wr_long           = 0;
      wr_shrt           = 0;
      
      ph_bimc_odat      = bimc_odat_shrt_2;
      ph_bimc_osync     = bimc_osync_shrt_2;
      
      bimc_isync_long_1 = ph_bimc_isync;
      bimc_idat_long_1  = ph_bimc_idat; 
      bimc_isync_long_2 = bimc_osync_long_1;
      bimc_idat_long_2  = bimc_odat_long_1;
      bimc_isync_shrt_1 = bimc_osync_long_2;
      bimc_idat_shrt_1  = bimc_odat_long_2; 
      bimc_isync_shrt_2 = bimc_osync_shrt_1;
      bimc_idat_shrt_2  = bimc_odat_shrt_1;
	 	 
      rd_addr_long_1    = 0;
      rd_addr_long_2    = 0;
      rd_addr_shrt_1    = 0;
      rd_addr_shrt_2    = 0;

      for (int i=0; i<10; i++) begin
	 
         if (long_hw1_ph_intf_reg.rd && (seq_id_intf_array[long_hw1_ph_intf_reg.seq_id].predet_mem_id == i)) begin
	    rd_addr_long_1 = long_hw1_ph_intf_reg.addr  + 22*i; 
	 end
	 if (long_hw2_ph_intf_reg.rd && (seq_id_intf_array[long_hw2_ph_intf_reg.seq_id].predet_mem_id == i)) begin
	    rd_addr_long_2 = long_hw2_ph_intf_reg.addr  + 22*i; 
	 end	 
	 if (short_hw1_ph_intf_reg.rd && (seq_id_intf_array[short_hw1_ph_intf_reg.seq_id].predet_mem_id == i)) begin
	    rd_addr_shrt_1 = short_hw1_ph_intf_reg.addr + 48*i; 
	 end
	 if (short_hw2_ph_intf_reg.rd && (seq_id_intf_array[short_hw2_ph_intf_reg.seq_id].predet_mem_id == i)) begin
	    rd_addr_shrt_2 = short_hw2_ph_intf_reg.addr + 48*i; 
	 end
      end 

      wr_addr_long = sm_predet_mem_long_intf.addr + (22*sm_predet_mem_long_intf.mem_id); 
      wr_addr_shrt = sm_predet_mem_shrt_intf.addr + (48*sm_predet_mem_shrt_intf.mem_id); 
         
      if (sm_predet_mem_long_intf.wr == 1)
	wr_long  = 1;      
      if (sm_predet_mem_shrt_intf.wr == 1)
	wr_shrt  = 1;
      
      ph_long_hw1_intf.dpth  = rd_data_long_1;
      ph_long_hw2_intf.dpth  = rd_data_long_2;
      ph_short_hw1_intf.dpth = rd_data_shrt_1;
      ph_short_hw2_intf.dpth = rd_data_shrt_2; 
   end
      
   

   
   always_ff @(negedge rst_n or posedge clk) begin
      if (!rst_n) begin	 
	 
	 
	 long_hw1_ph_intf_reg <= 0;
	 long_hw2_ph_intf_reg <= 0;
	 ph_long_hw1_val <= 0;
	 ph_long_hw1_val_pre <= 0;
	 ph_long_hw2_val <= 0;
	 ph_long_hw2_val_pre <= 0;
	 ph_sa_ro_uncorrectable_ecc_error <= 0;
	 ph_short_hw1_val <= 0;
	 ph_short_hw1_val_pre <= 0;
	 ph_short_hw2_val <= 0;
	 ph_short_hw2_val_pre <= 0;
	 short_hw1_ph_intf_reg <= 0;
	 short_hw2_ph_intf_reg <= 0;
	 
      end
      else begin
	 long_hw1_ph_intf_reg    <= long_hw1_ph_intf;
	 long_hw2_ph_intf_reg    <= long_hw2_ph_intf;
	 short_hw1_ph_intf_reg   <= short_hw1_ph_intf;
	 short_hw2_ph_intf_reg   <= short_hw2_ph_intf;
	 
	 ph_long_hw1_val_pre  <= long_hw1_ph_intf_reg.rd;
	 ph_long_hw2_val_pre  <= long_hw2_ph_intf_reg.rd;
	 ph_short_hw1_val_pre <= short_hw1_ph_intf_reg.rd;
	 ph_short_hw2_val_pre <= short_hw2_ph_intf_reg.rd;
	 
	 ph_long_hw1_val      <= ph_long_hw1_val_pre;
	 ph_long_hw2_val      <= ph_long_hw2_val_pre;
	 ph_short_hw1_val     <= ph_short_hw1_val_pre;
	 ph_short_hw2_val     <= ph_short_hw2_val_pre;
	 
	 if ((ro_uncorrectable_ecc_error_long_1 != 0) || (ro_uncorrectable_ecc_error_long_2 != 0) ||
	     (ro_uncorrectable_ecc_error_shrt_1 != 0) || (ro_uncorrectable_ecc_error_shrt_2 != 0))
	   ph_sa_ro_uncorrectable_ecc_error <= 1;
	 else
	   ph_sa_ro_uncorrectable_ecc_error <= 0;
      end
   end 
   
   nx_ram_1r1w
     #(.WIDTH        (60),
       .DEPTH        (220),
       .BWEWIDTH     (60),
       .SPECIALIZE   (1),
       .IN_FLOP      (0),
       .OUT_FLOP     (1),
       .RD_LATENCY   (1), 
       .WRITETHROUGH (0))
   long_1	   
     (.rst_n                       (rst_n),
      .clk                         (clk),
      .lvm                         (lvm), 
      .mlvm                        (mlvm), 
      .mrdten                      (mrdten),
      .bimc_rst_n                  (ph_bimc_rst_n),
      .bimc_isync                  (bimc_isync_long_1),
      .bimc_idat                   (bimc_idat_long_1),
      .bimc_odat                   (bimc_odat_long_1),
      .bimc_osync                  (bimc_osync_long_1),
      .ro_uncorrectable_ecc_error  (ro_uncorrectable_ecc_error_long_1),
      .reb                         (~long_hw1_ph_intf_reg.rd),
      .ra                          (rd_addr_long_1),
      .dout                        (rd_data_long_1),
      .web                         (~wr_long),
      .wa                          (wr_addr_long),
      .din                         (sm_predet_mem_long_intf.data),
      .bwe                         ({60{1'd1}}));
   
   nx_ram_1r1w
     #(.WIDTH        (60),
       .DEPTH        (220),
       .BWEWIDTH     (60),
       .SPECIALIZE   (1),
       .IN_FLOP      (0),
       .OUT_FLOP     (1),
       .RD_LATENCY   (1), 
       .WRITETHROUGH (0))
   long_2	   
     (.rst_n                       (rst_n),
      .clk                         (clk),     
      .lvm                         (lvm), 
      .mlvm                        (mlvm), 
      .mrdten                      (mrdten),
      .bimc_rst_n                  (ph_bimc_rst_n),
      .bimc_isync                  (bimc_isync_long_2),
      .bimc_idat                   (bimc_idat_long_2),
      .bimc_odat                   (bimc_odat_long_2),
      .bimc_osync                  (bimc_osync_long_2),
      .ro_uncorrectable_ecc_error  (ro_uncorrectable_ecc_error_long_2),
      .reb                         (~long_hw2_ph_intf_reg.rd),
      .ra                          (rd_addr_long_2),
      .dout                        (rd_data_long_2),
      .web                         (~wr_long),
      .wa                          (wr_addr_long),
      .din                         (sm_predet_mem_long_intf.data),
      .bwe                         ({60{1'd1}}));
   
   nx_ram_1r1w
     #(.WIDTH        (60),
       .DEPTH        (480),
       .BWEWIDTH     (60),
       .SPECIALIZE   (1),
       .IN_FLOP      (0),
       .OUT_FLOP     (1),
       .RD_LATENCY   (1), 
       .WRITETHROUGH (0))
   shrt_1	   
     (.rst_n                       (rst_n),
      .clk                         (clk),
      .lvm                         (lvm), 
      .mlvm                        (mlvm), 
      .mrdten                      (mrdten),
      .bimc_rst_n                  (ph_bimc_rst_n),
      .bimc_isync                  (bimc_isync_shrt_1),
      .bimc_idat                   (bimc_idat_shrt_1),
      .bimc_odat                   (bimc_odat_shrt_1),
      .bimc_osync                  (bimc_osync_shrt_1),
      .ro_uncorrectable_ecc_error  (ro_uncorrectable_ecc_error_shrt_1),
      .reb                         (~short_hw1_ph_intf_reg.rd),
      .ra                          (rd_addr_shrt_1),
      .dout                        (rd_data_shrt_1),
      .web                         (~wr_shrt),
      .wa                          (wr_addr_shrt),
      .din                         (sm_predet_mem_shrt_intf.data),
      .bwe                         ({60{1'd1}}));
   
   nx_ram_1r1w
     #(.WIDTH        (60),
       .DEPTH        (480),
       .BWEWIDTH     (60),
       .SPECIALIZE   (1),
       .IN_FLOP      (0),
       .OUT_FLOP     (1),
       .RD_LATENCY   (1), 
       .WRITETHROUGH (0))
   shrt_2	   
     (.rst_n                       (rst_n),
      .clk                         (clk),
      .lvm                         (lvm), 
      .mlvm                        (mlvm), 
      .mrdten                      (mrdten),
      .bimc_rst_n                  (ph_bimc_rst_n),
      .bimc_isync                  (bimc_isync_shrt_2),
      .bimc_idat                   (bimc_idat_shrt_2),
      .bimc_odat                   (bimc_odat_shrt_2),
      .bimc_osync                  (bimc_osync_shrt_2),
      .ro_uncorrectable_ecc_error  (ro_uncorrectable_ecc_error_shrt_2),
      .reb                         (~short_hw2_ph_intf_reg.rd),
      .ra                          (rd_addr_shrt_2),
      .dout                        (rd_data_shrt_2),
      .web                         (~wr_shrt),
      .wa                          (wr_addr_shrt),
      .din                         (sm_predet_mem_shrt_intf.data),
      .bwe                         ({60{1'd1}}));
 
endmodule 








