/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/















`include "cr_huf_comp.vh"
module cr_huf_comp_is_counter
  #(parameter
    DAT_WIDTH        =10,       
    CNT_WIDTH        =3,        
    SYM_FREQ_WIDTH   =15,       
    CNTRL_WIDTH      =1,        
    MAX_NUM_SYM_USED =576       
   )
  (
   
   is_sc_rd, new_freq, meta, seq_id, eob, sym_lo, sym_hi,
   
   clk, rst_n, sc_is_vld, sc_is_sym0, sc_is_sym1, sc_is_sym2,
   sc_is_sym3, sc_is_cnt0, sc_is_cnt1, sc_is_cnt2, sc_is_cnt3,
   sc_is_meta, sc_is_seq_id, sc_is_eob, not_ready
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

  parameter NUM_IN_SYMBOLS   =4;
 
 
 
 
 input                                        clk;
 input                                        rst_n; 
 
 
 

 
 input [NUM_IN_SYMBOLS-1:0] 		      sc_is_vld;       
 input [DAT_WIDTH-1:0]  		      sc_is_sym0;      
 input [DAT_WIDTH-1:0]  		      sc_is_sym1;      
 input [DAT_WIDTH-1:0]  		      sc_is_sym2;      
 input [DAT_WIDTH-1:0]  		      sc_is_sym3;      
 input [CNT_WIDTH-1:0]  		      sc_is_cnt0;      
 input [CNT_WIDTH-1:0]  		      sc_is_cnt1;      
 input [CNT_WIDTH-1:0]  		      sc_is_cnt2;      
 input [CNT_WIDTH-1:0]  		      sc_is_cnt3;      
 input [CNTRL_WIDTH-1:0]                      sc_is_meta;      
 input [`CREOLE_HC_SEQID_WIDTH-1:0] 	      sc_is_seq_id;    
 input e_pipe_eob                             sc_is_eob;       
                                                               
                                                               
                                                               
                                                               
 
 input  				      not_ready;       

 
 
 

 
 output 	                               is_sc_rd;       

 
 output [MAX_NUM_SYM_USED-1:0][SYM_FREQ_WIDTH-1:0] new_freq;   
                                                               
 output [CNTRL_WIDTH-1:0]                      meta;           
 output [`CREOLE_HC_SEQID_WIDTH-1:0] 	       seq_id;         
 output e_pipe_eob                             eob;            
                                                                
                                                                
                                                                
                                                                
 output [DAT_WIDTH-1:0] 		        sym_lo;         
 output [DAT_WIDTH-1:0] 		        sym_hi;         

 
 
 
 reg			is_sc_rd;
 reg [CNTRL_WIDTH-1:0]	meta;
 reg [MAX_NUM_SYM_USED-1:0] [SYM_FREQ_WIDTH-1:0] new_freq;
 reg [`CREOLE_HC_SEQID_WIDTH-1:0] seq_id;
 reg [DAT_WIDTH-1:0]	sym_hi;
 reg [DAT_WIDTH-1:0]	sym_lo;
 
 reg [NUM_IN_SYMBOLS-1:0][DAT_WIDTH-1:0]                    sc_is_sym_r;
 reg [NUM_IN_SYMBOLS-1:0][CNT_WIDTH-1:0]                    sc_is_cnt_r; 
 reg [NUM_IN_SYMBOLS-1:0] 		                    sc_is_vld_r;
 reg [`CREOLE_HC_SEQID_WIDTH-1:0]                           sc_is_seq_id_r;
 reg                                                        sc_is_meta_r;
 e_pipe_eob                                                 sc_is_eob_r;
 reg [MAX_NUM_SYM_USED-1:0][SYM_FREQ_WIDTH-1:0]             new_freq_c;
 reg                                                        last_lowest_sym_val;
 reg                                                        last_highest_sym_val;
 reg [NUM_IN_SYMBOLS-1:0] 		                    vld_gated_with_cnt;
 reg                                                        stall_pipe,busy;
 
 
 
 
 typedef struct {                                            
 logic                                                      val;
 logic  [DAT_WIDTH-1:0]                                     sym;
 } val_sym_t; 

 val_sym_t                                                  lowest_sym,highest_sym;

 logic                                                      clk_gate_open;
 logic                                                      clk_gated; 

 
 
 
   

always_ff @(posedge clk_gated or negedge rst_n)
begin
  if (~rst_n) 
  begin
    sc_is_eob_r <= MIDDLE;
    
    
    busy <= 0;
    sc_is_cnt_r <= 0;
    sc_is_meta_r <= 0;
    sc_is_seq_id_r <= 0;
    sc_is_sym_r <= 0;
    sc_is_vld_r <= 0;
    
    
  end
  else
  begin
	  if(stall_pipe==0)
	    begin
	      
	      
	      sc_is_vld_r	<= sc_is_vld & {NUM_IN_SYMBOLS{~busy}};
              sc_is_sym_r[0]	<= sc_is_sym0;
              sc_is_sym_r[1]	<= sc_is_sym1;
              sc_is_sym_r[2]	<= sc_is_sym2;
              sc_is_sym_r[3]	<= sc_is_sym3;
              sc_is_cnt_r[0]	<= sc_is_cnt0;
              sc_is_cnt_r[1]	<= sc_is_cnt1;
              sc_is_cnt_r[2]	<= sc_is_cnt2;
              sc_is_cnt_r[3]	<= sc_is_cnt3;
              sc_is_seq_id_r	<= sc_is_seq_id;
	      sc_is_meta_r	<= sc_is_meta;
              sc_is_eob_r	<= sc_is_eob;

	      
              if(busy==0 && |sc_is_vld && sc_is_eob!=MIDDLE)
	         busy		<= 1'b1;
              else if(eob!=MIDDLE)
	         busy		<= 1'b0;
	      
	  end 
          
  end
end 


always_comb
  begin
     
    
    if(eob != MIDDLE)
       begin
          new_freq_c					 =  0;
       end
    else
       begin

          new_freq_c					 =  new_freq;
	  for(int i=0;i<NUM_IN_SYMBOLS;i++)
	  begin
		     if(sc_is_vld_r[i] & (sc_is_cnt_r[i] != 0) & (sc_is_sym_r[i] < MAX_NUM_SYM_USED))
		       begin

			 
			 new_freq_c[sc_is_sym_r[i]]	 = new_freq[sc_is_sym_r[i]] + sc_is_cnt_r[i];
		       end

	   end 

       end 

     
     
     for(int i=0;i<NUM_IN_SYMBOLS;i++)
           vld_gated_with_cnt[i]		         = sc_is_vld_r[i] & (sc_is_cnt_r[i] != 0) & (sc_is_sym_r[i] < MAX_NUM_SYM_USED);
     





     lowest_sym					 = '{val:last_lowest_sym_val,
                                                    sym:sym_lo};

     for(int i=0;i<NUM_IN_SYMBOLS;i++)
         if(lowest_sym.val==0)
	                      
	      lowest_sym			 = '{val:vld_gated_with_cnt[i],
                                                    sym:sc_is_sym_r[i]};
         else if(vld_gated_with_cnt[i] && (sc_is_sym_r[i] < lowest_sym.sym))
	                                                             
	                                                             
	      lowest_sym			 = '{val:vld_gated_with_cnt[i],
                                                    sym:sc_is_sym_r[i]};
	      
    



     highest_sym				 = '{val:last_highest_sym_val,
                                                    sym:sym_hi};

     for(int i=0;i<NUM_IN_SYMBOLS;i++)
         if(highest_sym.val==0)
	                      
	      highest_sym			 = '{val:vld_gated_with_cnt[i],
                                                    sym:sc_is_sym_r[i]};
         else if(vld_gated_with_cnt[i] && (sc_is_sym_r[i] > highest_sym.sym))
	                                                             
	                                                             
	      highest_sym			 = '{val:vld_gated_with_cnt[i],
                                                    sym:sc_is_sym_r[i]}; 
    

 



stall_pipe					 = (sc_is_eob_r != MIDDLE && |sc_is_vld_r) && not_ready;


is_sc_rd					 = ~busy;

end 
   

always @(posedge clk_gated or negedge rst_n)
begin
  if (~rst_n) 
    begin
    
    
    last_highest_sym_val <= 0;
    last_lowest_sym_val <= 0;
    
    end
  else
    begin
        
        if(eob != MIDDLE)
	  begin
           last_lowest_sym_val   <= 0; 
	   last_highest_sym_val  <= 0;
	  end
        else if(stall_pipe==0)
	  begin
	   last_lowest_sym_val   <= lowest_sym.val;
	   last_highest_sym_val  <= highest_sym.val;
	  end

    end
end 

   

always @(posedge clk_gated or negedge rst_n)
begin
  if (~rst_n) 
  begin
    eob <= MIDDLE;
    
    
    meta <= 0;
    new_freq <= 0;
    seq_id <= 0;
    sym_hi <= 0;
    sym_lo <= 0;
    
  end
  else
    begin
       if(stall_pipe==0)
         begin

             new_freq   <= new_freq_c;
             sym_lo     <= lowest_sym.sym;
             sym_hi     <= highest_sym.sym;
	     seq_id     <= sc_is_seq_id_r;
	     meta       <= sc_is_meta_r;

	     
         end 

      if(|sc_is_vld_r && stall_pipe==0) 
          eob           <= sc_is_eob_r;
      else
	  eob           <= MIDDLE;
       
    end
end				       


assign clk_gate_open = (eob != MIDDLE) | 
                       (|sc_is_vld_r != 0 && ~stall_pipe) |
                       (|sc_is_vld != 0 && ~stall_pipe);
 
`ifdef CLK_GATE  
    cr_clk_gate dont_touch_clk_gate ( .i0(1'b0), .i1(clk_gate_open), .phi(clk), .o(clk_gated) ); 
`else
    assign clk_gated = clk;
`endif

   
endmodule 







