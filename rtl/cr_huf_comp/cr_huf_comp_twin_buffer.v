/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_huf_comp.vh"

module cr_huf_comp_twin_buffer
  #(parameter
    N_WORDS		 = 576,
    WORD_WIDTH		 = 15,
    N_WORDS_PER_ENTRY	 = 2,
    N_RD_WORDS_PER_ENTRY = 2,
    META_DATA_WIDTH      = 1,
    SPECIALIZE           = 0,
    SINGLE_PORT          = 1
   )
  (
   
   full, meta_full, rd_out, rd_valid_word, rd_meta_data, rd_meta_vld,
   ro_uncorrectable_ecc_error, bimc_odat, bimc_osync,
   
   clk, rst_n, wr, wr_done, wr_addr, wr_data, wr_valid_word, wr_meta,
   wr_meta_done, wr_meta_data, wr_seq_id, rd, rd_addr, rd_done,
   rd_meta_done, rd_seq_id, bimc_isync, bimc_idat, lvm, mlvm, mrdten,
   ovstb
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

  parameter DEPTH    = `ROUND_UP_DIV(N_WORDS,N_WORDS_PER_ENTRY);
  parameter RD_DEPTH = `ROUND_UP_DIV(N_WORDS,N_RD_WORDS_PER_ENTRY);
   
 
 
 
 
   input                                        clk;
   input                                        rst_n; 
 
 
 
   input                                        wr;
   input                                        wr_done;
   input [`LOG_VEC(DEPTH)]                      wr_addr;
   input [N_WORDS_PER_ENTRY * WORD_WIDTH-1:0]   wr_data;
   input [N_WORDS_PER_ENTRY-1:0]                wr_valid_word;
   input                                        wr_meta;
   input                                        wr_meta_done;
   input [META_DATA_WIDTH-1:0] 			wr_meta_data;
   input [`CREOLE_HC_SEQID_WIDTH-1:0]           wr_seq_id;
   
   input 			                rd;
   input [`LOG_VEC(RD_DEPTH)]			rd_addr;
   input 			                rd_done;
   input 			                rd_meta_done;
   input [`CREOLE_HC_SEQID_WIDTH-1:0]           rd_seq_id;          

   input                                        bimc_isync;
   input                                        bimc_idat;
   input                                        lvm;
   input                                        mlvm;
   input                                        mrdten;
   input                                        ovstb;

 
 
 
   output logic                                          full;
   output logic                                          meta_full;
   output logic [N_RD_WORDS_PER_ENTRY * WORD_WIDTH-1:0]  rd_out;
   output logic [N_RD_WORDS_PER_ENTRY-1:0]               rd_valid_word;
   output logic [META_DATA_WIDTH-1:0] 			 rd_meta_data;
   output logic 					 rd_meta_vld;
 
   output logic 		                         ro_uncorrectable_ecc_error;
   output logic                                          bimc_odat;
   output logic                                          bimc_osync;
 
 
 
 logic 				              wr_meta_0;
 logic 				              wr_meta_1;
 logic [META_DATA_WIDTH-1:0]                  meta_data_0;
 logic [META_DATA_WIDTH-1:0]                  meta_data_1;
 logic                                        wr_mem_0_b;
 logic                                        wr_mem_1_b;
 logic                                        wr_mem_b;
 logic [`LOG_VEC(DEPTH*2)]                    wr_mem_addr,wr_init_mem_addr;
 logic [(N_WORDS_PER_ENTRY * WORD_WIDTH)-1:0] wr_mem_data;
 logic [(N_WORDS_PER_ENTRY * WORD_WIDTH)-1:0] wr_mem_bwe;
 logic                                        rd_mem_0_b;
 logic                                        rd_mem_1_b;
 logic                                        rd_mem_b;
 logic [(N_WORDS_PER_ENTRY*WORD_WIDTH)-1:0]   mem_dout;
 logic [DEPTH-1:0][N_WORDS_PER_ENTRY-1:0]     mem_0_word_val;
 logic [DEPTH-1:0][N_WORDS_PER_ENTRY-1:0]     mem_1_word_val;
 logic [`LOG_VEC(DEPTH*2)]                    rd_mem_addr;
 logic [2:0][N_WORDS_PER_ENTRY-1:0]           rd_valid_word_0_r;
 logic [2:0][N_WORDS_PER_ENTRY-1:0]           rd_valid_word_1_r;
 logic [2:0][`CREOLE_HC_SEQID_WIDTH-1:0]      rd_seq_id_r;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0]           mem0_seq_id;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0]           mem1_seq_id;
 logic [2:0][`CREOLE_HC_SEQID_WIDTH-1:0]      mem0_seq_id_r;
 logic [2:0][`CREOLE_HC_SEQID_WIDTH-1:0]      mem1_seq_id_r;
 logic [`LOG_VEC(DEPTH)]                      rd_addr_shift;
 logic [2:0]                                  rd_mux_r;
   
   
   logic [`CREOLE_HC_SEQID_WIDTH-1:0] 	      meta0_seq_id;
   logic [`CREOLE_HC_SEQID_WIDTH-1:0] 	      meta1_seq_id;
 
   logic   				      wr_meta_reg;
   logic [META_DATA_WIDTH-1:0] 		      wr_meta_data_reg;
   logic   				      wr_meta_mod_reg, wr_meta_mod;
   logic [META_DATA_WIDTH-1:0] 		      wr_meta_data_mod;
   logic [`CREOLE_HC_SEQID_WIDTH-1:0] 	      wr_seq_id_reg, wr_seq_id_mod;
   logic                                      wr_valid; 
   


 typedef enum {MEM_0_IDLE,MEM_0_INIT,MEM_0_WR,MEM_0_FULL} e_mem0_st;
 typedef enum {MEM_1_IDLE,MEM_1_INIT,MEM_1_WR,MEM_1_FULL} e_mem1_st;
 typedef enum {META_0_IDLE,META_0_WR,META_0_FULL} e_meta0_st;
 typedef enum {META_1_IDLE,META_1_WR,META_1_FULL} e_meta1_st;
   
 e_mem0_st              mem0_nxt_st,mem0_curr_st;
 e_mem1_st              mem1_nxt_st,mem1_curr_st;

 
 e_meta0_st             meta0_nxt_st,meta0_curr_st;
 e_meta1_st             meta1_nxt_st,meta1_curr_st;
 
 
 
   
  


   
always_ff @(posedge clk or negedge rst_n)
begin 
  if (~rst_n) 
  begin
    mem0_curr_st  <= MEM_0_INIT;
    mem1_curr_st  <= MEM_1_INIT;

    meta0_curr_st <= META_0_IDLE;
    meta1_curr_st <= META_1_IDLE;
    
    
    mem0_seq_id <= 0;
    mem0_seq_id_r <= 0;
    mem1_seq_id <= 0;
    mem1_seq_id_r <= 0;
    mem_0_word_val <= 0;
    mem_1_word_val <= 0;
    meta0_seq_id <= 0;
    meta1_seq_id <= 0;
    meta_data_0 <= 0;
    meta_data_1 <= 0;
    rd_mux_r <= 0;
    rd_seq_id_r <= 0;
    rd_valid_word_0_r <= 0;
    rd_valid_word_1_r <= 0;
    wr_init_mem_addr <= 0;
    wr_meta_data_reg <= 0;
    wr_meta_mod_reg <= 0;
    wr_meta_reg <= 0;
    wr_seq_id_reg <= 0;
    
  end
  else
    begin
       if (rd_meta_done && wr_meta) begin
	 wr_meta_reg         <= wr_meta;
	 wr_meta_data_reg    <= wr_meta_data;
	 wr_seq_id_reg       <= wr_seq_id; 
       end
       else begin
	  wr_meta_reg         <= 0;
	  wr_meta_data_reg    <= 0; 
       end

       wr_meta_mod_reg <= wr_meta_mod;
       
       
       rd_valid_word_0_r <= {rd_valid_word_0_r[1:0],(mem_0_word_val[rd_addr_shift] & {N_WORDS_PER_ENTRY{rd}})};
       rd_valid_word_1_r <= {rd_valid_word_1_r[1:0],(mem_1_word_val[rd_addr_shift] & {N_WORDS_PER_ENTRY{rd}})};
       
       rd_mux_r          <= {rd_mux_r[1:0],rd_addr[0]};
       rd_seq_id_r       <= {rd_seq_id_r[1:0],rd_seq_id};
       mem0_seq_id_r     <= {mem0_seq_id_r[1:0],mem0_seq_id};
       mem1_seq_id_r     <= {mem1_seq_id_r[1:0],mem1_seq_id};
       
       
       mem0_curr_st      <= mem0_nxt_st;
       mem1_curr_st      <= mem1_nxt_st;
       meta0_curr_st     <= meta0_nxt_st;
       meta1_curr_st     <= meta1_nxt_st;

       
       
       if(~wr_mem_0_b)
          mem_0_word_val[wr_addr]         <= wr_valid_word | mem_0_word_val[wr_addr];
       else if(rd_done && rd_seq_id==mem0_seq_id)
	  mem_0_word_val                  <= 0;

      
       if(~wr_mem_1_b)
          mem_1_word_val[wr_addr]         <= wr_valid_word | mem_1_word_val[wr_addr];
       else if(rd_done && rd_seq_id==mem1_seq_id)
	  mem_1_word_val                  <= 0;

       
       if(~wr_mem_0_b)
           mem0_seq_id <= wr_seq_id;
       if(~wr_mem_1_b)
           mem1_seq_id <= wr_seq_id;

       
       if (wr_meta_0)
         meta_data_0 <= wr_meta_data_mod;
       if (wr_meta_1)
         meta_data_1 <= wr_meta_data_mod;

       if (wr_meta_0 && wr_meta_mod && !wr_meta_mod_reg)
	 meta0_seq_id <= wr_seq_id_mod;
       if (wr_meta_1 && wr_meta_mod && !wr_meta_mod_reg)
	 meta1_seq_id <= wr_seq_id_mod;

       if(wr_init_mem_addr <= (DEPTH*2-1))
          wr_init_mem_addr <= wr_init_mem_addr + 1;
       
  end 
   
end 
   
  






always_comb
  begin

     wr_valid = wr & wr_valid_word!=0;

     if (rd_meta_done && wr_meta) begin
	wr_meta_mod = 0;
     end
     else begin
	wr_meta_mod = wr_meta | wr_meta_reg;
     end
     if (wr_meta_reg) begin
	wr_meta_data_mod = wr_meta_data_reg;
	wr_seq_id_mod    = wr_seq_id_reg;
     end
     else begin
	wr_meta_data_mod = wr_meta_data;
	wr_seq_id_mod    = wr_seq_id;
     end
	
     



  
  mem0_nxt_st = mem0_curr_st;
  case(mem0_curr_st)

     MEM_0_INIT : if(wr_init_mem_addr >= (DEPTH-1))
                     mem0_nxt_st = MEM_0_IDLE;
    
     
     MEM_0_IDLE : if(wr_valid && wr_done && mem1_curr_st != MEM_1_WR)
                       mem0_nxt_st = MEM_0_FULL;
                  else if(wr_valid && mem1_curr_st != MEM_1_WR)
                       mem0_nxt_st = MEM_0_WR;
     
     MEM_0_WR   : if(wr_done)
                       mem0_nxt_st = MEM_0_FULL;
     
     MEM_0_FULL : if(rd_done && (rd_seq_id == mem0_seq_id))
                       mem0_nxt_st = MEM_0_IDLE;
                  
  endcase 
   
  
  mem1_nxt_st = mem1_curr_st;
  case(mem1_curr_st)

     MEM_1_INIT : if(wr_init_mem_addr >= (DEPTH*2-1))
                     mem1_nxt_st = MEM_1_IDLE;

     
     
     MEM_1_IDLE : if(wr_valid && wr_done && mem0_curr_st == MEM_0_FULL)
                       mem1_nxt_st = MEM_1_FULL;
                  else if(wr_valid && mem0_curr_st == MEM_0_FULL)
                       mem1_nxt_st = MEM_1_WR;
     
     MEM_1_WR   : if(wr_done)
                       mem1_nxt_st = MEM_1_FULL;
     
     MEM_1_FULL : if(rd_done && (rd_seq_id == mem1_seq_id))
                       mem1_nxt_st = MEM_1_IDLE;
                  
  endcase 

     
  
  meta0_nxt_st = meta0_curr_st;
  case(meta0_curr_st)
       
     
     META_0_IDLE : 
	 if(wr_meta_mod && (meta1_curr_st != META_1_WR))
	   begin
	     if (!wr_meta_done)
               meta0_nxt_st = META_0_WR;
	     else
	       meta0_nxt_st = META_0_FULL;
	   end
     
     META_0_WR   : if(wr_meta_done)
                        meta0_nxt_st = META_0_FULL;
     
     META_0_FULL : if(rd_meta_done && (rd_seq_id == meta0_seq_id))
                        meta0_nxt_st = META_0_IDLE;
       
     endcase 
     
  
  meta1_nxt_st = meta1_curr_st;
  case(meta1_curr_st)
       
     
     
     META_1_IDLE : 
	 if(wr_meta_mod && (meta0_curr_st != META_0_WR) && (meta0_curr_st != META_0_IDLE))
	   begin
	      if (!wr_meta_done)
                meta1_nxt_st = META_1_WR;
	      else
	        meta1_nxt_st = META_1_FULL;
	   end
       
       META_1_WR   : if(wr_meta_done)
                          meta1_nxt_st = META_1_FULL;
       
       META_1_FULL : if(rd_meta_done && (rd_seq_id == meta1_seq_id))
                          meta1_nxt_st = META_1_IDLE;
       
     endcase 

  
  
  
  wr_mem_0_b  = ~(wr_valid && mem0_nxt_st!=MEM_0_IDLE && mem0_curr_st!=MEM_0_FULL); 
  wr_mem_1_b  = ~(wr_valid && mem1_nxt_st!=MEM_1_IDLE && mem1_curr_st!=MEM_1_FULL); 

  wr_mem_b    = (wr_mem_0_b & wr_mem_1_b) & ~(mem0_curr_st==MEM_0_INIT | mem1_curr_st==MEM_1_INIT);
     
  wr_meta_0   =  wr_meta_mod & (meta0_nxt_st==META_0_WR || meta0_nxt_st==META_0_FULL || meta0_curr_st==META_0_WR) & meta0_curr_st!=META_0_FULL; 
  wr_meta_1   =  wr_meta_mod & (meta1_nxt_st==META_1_WR || meta1_nxt_st==META_1_FULL || meta1_curr_st==META_1_WR) & meta1_curr_st!=META_1_FULL; 

  if(mem0_curr_st==MEM_0_INIT | mem1_curr_st==MEM_1_INIT)
    wr_mem_addr = wr_init_mem_addr;
  else if(wr_mem_0_b==0)
    wr_mem_addr = {1'b0,wr_addr}; 
  else
    wr_mem_addr = wr_addr + DEPTH;
     
  wr_mem_data = mem0_curr_st==MEM_0_INIT | mem1_curr_st==MEM_1_INIT ? 0 : wr_data;

  for(int i=0;i<N_WORDS_PER_ENTRY;i++)
     if(mem0_curr_st==MEM_0_INIT | mem1_curr_st==MEM_1_INIT)
        wr_mem_bwe[i*WORD_WIDTH+:WORD_WIDTH] = {WORD_WIDTH{1'b1}}; 
     else
        wr_mem_bwe[i*WORD_WIDTH+:WORD_WIDTH] = {WORD_WIDTH{wr_valid_word[i]}}; 

  full      = mem0_curr_st==MEM_0_FULL   && mem1_curr_st==MEM_1_FULL;
  meta_full = meta0_curr_st==META_0_FULL && meta1_curr_st==META_1_FULL;
  

  
  
  
  
  rd_addr_shift = rd_addr >> (N_WORDS_PER_ENTRY-N_RD_WORDS_PER_ENTRY);
  
  rd_mem_0_b    = ~(rd && rd_seq_id == mem0_seq_id && mem0_curr_st==MEM_0_FULL);
  rd_mem_1_b    = ~(rd && rd_seq_id == mem1_seq_id && mem1_curr_st==MEM_1_FULL);

  rd_mem_b      = rd_mem_0_b & rd_mem_1_b;

  if(rd_mem_0_b==0)
    rd_mem_addr   = {1'b0,rd_addr_shift}; 
  else
    rd_mem_addr   = rd_addr_shift + DEPTH;

  
  

  
  if (rd_seq_id == meta0_seq_id && meta0_curr_st==META_0_FULL) begin
     rd_meta_data = meta_data_0;
     rd_meta_vld  = 1;
  end
  else if (rd_seq_id == meta1_seq_id && meta1_curr_st==META_1_FULL) begin
     rd_meta_data = meta_data_1;
     rd_meta_vld  = 1;
  end
  else begin
     rd_meta_data = 0;
     rd_meta_vld  = 0; 
  end
 
end 


  

      
  


generate
   
if (SINGLE_PORT==1) 

begin  : single


   always_comb begin
      if(rd_seq_id_r[`HT_FREQ_RD_LATENCY-1] == mem0_seq_id_r[`HT_FREQ_RD_LATENCY-1])
	begin
	   rd_out = mem_dout >> ((N_WORDS_PER_ENTRY - N_RD_WORDS_PER_ENTRY) * rd_mux_r[`HT_FREQ_RD_LATENCY-1] * WORD_WIDTH); 
	   rd_valid_word = rd_valid_word_0_r[`HT_FREQ_RD_LATENCY-1]; 
	end
      else if(rd_seq_id_r[`HT_FREQ_RD_LATENCY-1] == mem1_seq_id_r[`HT_FREQ_RD_LATENCY-1])
	begin
	   rd_out = mem_dout >> ((N_WORDS_PER_ENTRY - N_RD_WORDS_PER_ENTRY) * rd_mux_r[`HT_FREQ_RD_LATENCY-1] * WORD_WIDTH); 
	   rd_valid_word = rd_valid_word_1_r[`HT_FREQ_RD_LATENCY-1]; 
	end
      else
	begin
	   rd_out = 0;
	   rd_valid_word = 0;
	end
   end
   

   nx_ram_1r1w 
     #(.WIDTH(N_WORDS_PER_ENTRY * WORD_WIDTH),
       .DEPTH(DEPTH*2),
       .IN_FLOP(0),
       .OUT_FLOP(0),
       .RD_LATENCY(1),
       .SPECIALIZE(SPECIALIZE))
   u_mem
     (
      
      .bimc_odat			(bimc_odat),
      .bimc_osync			(bimc_osync),
      .ro_uncorrectable_ecc_error	(ro_uncorrectable_ecc_error),
      .dout				(mem_dout),		 
      
      .rst_n				(rst_n),		 
      .clk				(clk),			 
      .lvm				(lvm),
      .mlvm				(mlvm),
      .mrdten				(mrdten),
      .bimc_rst_n			(rst_n),		 
      .bimc_isync			(bimc_isync),
      .bimc_idat			(bimc_idat),
      .reb				(rd_mem_b),		 
      .ra				(rd_mem_addr),		 
      .web				(wr_mem_b),		 
      .wa				(wr_mem_addr),		 
      .din				(wr_mem_data),		 
      .bwe				(wr_mem_bwe));		 
end
else begin : pseudo_dual

   wire csb;
   wire web;
   assign csb = ~wr_mem_b;
   assign web = ~wr_mem_b;
   
   always_comb begin
      if(rd_seq_id_r[`HT_FREQ_RD_LATENCY] == mem0_seq_id_r[`HT_FREQ_RD_LATENCY])
	begin
	   rd_out = mem_dout >> ((N_WORDS_PER_ENTRY - N_RD_WORDS_PER_ENTRY) * rd_mux_r[`HT_FREQ_RD_LATENCY] * WORD_WIDTH); 
	   rd_valid_word = rd_valid_word_0_r[`HT_FREQ_RD_LATENCY]; 
	end
      else if(rd_seq_id_r[`HT_FREQ_RD_LATENCY] == mem1_seq_id_r[`HT_FREQ_RD_LATENCY])
	begin
	   rd_out = mem_dout >> ((N_WORDS_PER_ENTRY - N_RD_WORDS_PER_ENTRY) * rd_mux_r[`HT_FREQ_RD_LATENCY] * WORD_WIDTH); 
	   rd_valid_word = rd_valid_word_1_r[`HT_FREQ_RD_LATENCY]; 
	end
      else
	begin
	   rd_out = 0;
	   rd_valid_word = 0;
	end
   end
   
  
   nx_ram_2rw 
     #(.WIDTH(N_WORDS_PER_ENTRY * WORD_WIDTH),
       .DEPTH(DEPTH*2),
       .IN_FLOP(0),
       .OUT_FLOP(0),
       .RD_LATENCY(1),
       .SPECIALIZE(SPECIALIZE))
   u_mem
     (
      
      .bimc_odat			(bimc_odat),
      .bimc_osync			(bimc_osync),
      .ro_uncorrectable_ecc_error	(ro_uncorrectable_ecc_error),
      .douta				(mem_dout),			 
      .doutb				(),		 
      
      .clk				(clk),			 
      .rst_n				(rst_n),		 
      .ovstb				(ovstb),
      .lvm				(lvm),
      .mlvm				(mlvm),
      .mrdten				(mrdten),
      .bimc_rst_n			(rst_n),		 
      .bimc_isync			(bimc_isync),
      .bimc_idat			(bimc_idat),
      .bwea				({N_WORDS_PER_ENTRY * WORD_WIDTH{1'b0}}), 
      .dina				({N_WORDS_PER_ENTRY * WORD_WIDTH{1'b0}}), 
      .adda				(rd_mem_addr),		 
      .csa				(~rd_mem_b),		 
      .wea				(1'b0),			 
      .bweb				(wr_mem_bwe),		 
      .dinb				(wr_mem_data),		 
      .addb				(wr_mem_addr),		 
      .csb				(csb),
      .web				(web));
end
endgenerate   
       
   
endmodule 








