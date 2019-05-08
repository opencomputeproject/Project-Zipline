/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "cr_huf_comp.vh"
module cr_huf_comp_is_sorter
  #(parameter
    DAT_WIDTH        =10,       
    SYM_FREQ_WIDTH   =15,       
    CNTRL_WIDTH      =1,        
    MAX_NUM_SYM_USED =576,      
    REPLICATOR_LOAD  =8         
   )
  (
   
   not_ready, is_ht_sym_lo, is_ht_sym_hi, is_ht_sym_unique,
   is_ht_sym_sort_freq, is_ht_sym_sort_freq_sym, is_ht_meta,
   is_ht_seq_id, is_ht_eob,
   
   clk, rst_n, new_freq, meta, seq_id, eob, sym_lo, sym_hi,
   ht_is_not_ready
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;

  parameter NUM_IN_SYMBOLS   =2;
  
  parameter N_FANOUT_REPLICATORS = MAX_NUM_SYM_USED/REPLICATOR_LOAD;
 
 
 
 
 input                                        clk;
 input                                        rst_n; 
 
 
 

 
 input [MAX_NUM_SYM_USED-1:0][SYM_FREQ_WIDTH-1:0] new_freq;
 input [CNTRL_WIDTH-1:0]                      meta;      
 input [`CREOLE_HC_SEQID_WIDTH-1:0] 	      seq_id;    
 input e_pipe_eob                             eob;       
                                                               
                                                               
                                                               
                                                               
 input [DAT_WIDTH-1:0] 		              sym_lo;   
 input [DAT_WIDTH-1:0] 		              sym_hi;   
 
 input  				      ht_is_not_ready; 

 
 
 

 
 output 	                              not_ready; 

 
 output [DAT_WIDTH-1:0] 		      is_ht_sym_lo;   
 output [DAT_WIDTH-1:0] 		      is_ht_sym_hi;   
 output [DAT_WIDTH-1:0] 		      is_ht_sym_unique; 
 output [MAX_NUM_SYM_USED-1:0][SYM_FREQ_WIDTH-1:0] is_ht_sym_sort_freq; 
 output [MAX_NUM_SYM_USED-1:0][DAT_WIDTH-1:0] is_ht_sym_sort_freq_sym; 
 output [CNTRL_WIDTH-1:0]                     is_ht_meta;    
 output [`CREOLE_HC_SEQID_WIDTH-1:0]          is_ht_seq_id;  
 output e_pipe_eob                            is_ht_eob;     
                                                              
                                                              
                                                              
                                                              

 
 
 
 reg [CNTRL_WIDTH-1:0]	is_ht_meta;
 reg [`CREOLE_HC_SEQID_WIDTH-1:0] is_ht_seq_id;
 reg [DAT_WIDTH-1:0]	is_ht_sym_hi;
 reg [DAT_WIDTH-1:0]	is_ht_sym_lo;
 reg [MAX_NUM_SYM_USED-1:0] [SYM_FREQ_WIDTH-1:0] is_ht_sym_sort_freq;
 reg [MAX_NUM_SYM_USED-1:0] [DAT_WIDTH-1:0] is_ht_sym_sort_freq_sym;
 reg [DAT_WIDTH-1:0]	is_ht_sym_unique;
 reg			not_ready;
 
 e_pipe_eob                                                 eob_r;
 reg [DAT_WIDTH-1:0]                                        sym_unique;
 reg [MAX_NUM_SYM_USED-1:0] [SYM_FREQ_WIDTH-1:0]            is_ht_sym_sort_freq_mod;
 reg [MAX_NUM_SYM_USED-1:0] [DAT_WIDTH-1:0]                 is_ht_sym_sort_freq_sym_mod;
 reg                                                        stall_pipe;
 reg [MAX_NUM_SYM_USED-1:0][SYM_FREQ_WIDTH-1:0]             freq_counters;
 reg [DAT_WIDTH-1:0] 					    freq_counter_ptr;
 reg [CNTRL_WIDTH-1:0]                                      meta_r;
 reg [`CREOLE_HC_SEQID_WIDTH-1:0]                           seq_id_r;
 reg [DAT_WIDTH-1:0]                                        sym_hi_r;
 reg [DAT_WIDTH-1:0]                                        sym_lo_r;
 
  
 
 typedef enum logic [1:0] {
			     CODE_0  = 2'b00,
			     CODE_1  = 2'b01,
			     CODE_M1 = 2'b10 
			      } e_pre_sort_order;

 
	         
 typedef enum logic [3:0] {
			     KEEP        = 4'b0000,
			     PULL_BY_1   = 4'b0101,
			     PULL_BY_2   = 4'b0110,
			     INSERT_SYM0 = 4'b1100,
			     INSERT_SYM1 = 4'b1101
			      } e_merged_sort_order;

 
 typedef enum 		 {IDLE,SORT} e_is_state;
   
 e_pre_sort_order [MAX_NUM_SYM_USED-1:0][NUM_IN_SYMBOLS-1:0] per_sym_freq_sort; 
 e_merged_sort_order [MAX_NUM_SYM_USED-1:0]                  merged_freq_sort; 
 e_is_state                                                  is_cur_st,is_nxt_st;
   

 
   
 typedef struct {                             
 logic [DAT_WIDTH-1:0]                        sym;
 logic [SYM_FREQ_WIDTH-1:0]                   freq;
 } sym_entry_t;

 typedef struct packed {                      
 logic  [DAT_WIDTH-1:0]                       symbol;
 logic  [SYM_FREQ_WIDTH-1:0]                  freq;
 } val_data_t;

sym_entry_t                                   sort_table[MAX_NUM_SYM_USED];
val_data_t                                    sorted_inputs_c[NUM_IN_SYMBOLS];
val_data_t                                    sorted_inputs[N_FANOUT_REPLICATORS][NUM_IN_SYMBOLS];  

logic                                         clk_gate_open;
logic                                         clk_gated;

   
 
 
 
   

always_ff @(posedge clk_gated or negedge rst_n)
begin
  if (~rst_n) 
  begin
    eob_r <= MIDDLE;
    is_cur_st <= IDLE;
    for(int k=0;k<N_FANOUT_REPLICATORS;k++)
       sorted_inputs[k] <= '{default:0}; 
    
    
    freq_counter_ptr <= 0;
    freq_counters <= 0;
    meta_r <= 0;
    seq_id_r <= 0;
    sym_hi_r <= 0;
    sym_lo_r <= 0;
    sym_unique <= 0;
    
    
  end
  else
    begin
            
	    if(eob != MIDDLE)
	      begin
		  freq_counters			<= new_freq;
		  meta_r			<= meta;      
		  seq_id_r			<= seq_id;  
		  eob_r				<= eob; 
		  sym_lo_r			<= sym_lo;  
		  sym_hi_r			<= sym_hi;
	      end

	    
	    
	    
	    
	    if(eob == PASS_THRU)
	          freq_counter_ptr		<= MAX_NUM_SYM_USED;
	    else if(eob != MIDDLE)
	          freq_counter_ptr		<= sym_lo;
	    else if(freq_counter_ptr < MAX_NUM_SYM_USED)
	          freq_counter_ptr		<= freq_counter_ptr + 2; 

	    
	    
	    
	    
	    
            if(eob==PASS_THRU)
	          sym_unique		        <= MAX_NUM_SYM_USED;
	    else if(freq_counter_ptr==sym_lo_r)
	      begin
		  if(sorted_inputs_c[0].freq!=0)
		        sym_unique		<= MAX_NUM_SYM_USED - 2;
		  else if(sorted_inputs_c[1].freq!=0)
		        sym_unique		<= MAX_NUM_SYM_USED - 1;
		  else
		        sym_unique		<= MAX_NUM_SYM_USED;
	      end
	    else if(is_cur_st==SORT)
	      begin
		  if(sorted_inputs_c[0].freq!=0)
		        sym_unique		<= sym_unique - 2;
		  else if(sorted_inputs_c[1].freq!=0)
		        sym_unique		<= sym_unique - 1;
		  else
		        sym_unique		<= sym_unique;
	      end

	    
	    
	    for(int k=0;k<N_FANOUT_REPLICATORS;k++)
	     begin
			sorted_inputs[k][0]	<= sorted_inputs_c[0];
			sorted_inputs[k][1]	<= sorted_inputs_c[1];
	     end

	    
	    if(stall_pipe == 0)
		 is_cur_st			<= is_nxt_st;

    end 
end 



always_comb
  begin

     
     if(is_ht_eob != MIDDLE)
       begin
           is_ht_sym_sort_freq_mod	 =  0;
           is_ht_sym_sort_freq_sym_mod	 =  0; 
       end
     else
       begin
	   is_ht_sym_sort_freq_mod	 =  is_ht_sym_sort_freq;
           is_ht_sym_sort_freq_sym_mod	 =  is_ht_sym_sort_freq_sym;
       end 

     
     sorted_inputs_c[0]			 = '{default:0};
     sorted_inputs_c[1]			 = '{default:0};
     if(freq_counter_ptr+1 <= sym_hi_r)
                                       
      begin
      if(freq_counters[freq_counter_ptr] > freq_counters[freq_counter_ptr+1])
       
       begin
           sorted_inputs_c[0]		 = '{freq:freq_counters[freq_counter_ptr+1],symbol:freq_counter_ptr+1};
           sorted_inputs_c[1]		 = '{freq:freq_counters[freq_counter_ptr],symbol:freq_counter_ptr};
       end
       else 
       begin
           sorted_inputs_c[0]		 = '{freq:freq_counters[freq_counter_ptr],symbol:freq_counter_ptr};
           sorted_inputs_c[1]		 = '{freq:freq_counters[freq_counter_ptr+1],symbol:freq_counter_ptr+1};	
       end 
     end 
     else if(freq_counter_ptr <= sym_hi_r)
      begin
	   sorted_inputs_c[0]		 = '{freq:0,symbol:0};
           sorted_inputs_c[1]		 = '{freq:freq_counters[freq_counter_ptr],symbol:freq_counter_ptr};
      end
     else
      begin
	   sorted_inputs_c[0]		 = '{freq:0,symbol:0};
           sorted_inputs_c[1]		 = '{freq:0,symbol:0};	
      end
     
     
     is_nxt_st				 = is_cur_st;
     case(is_cur_st)
       
       IDLE: if(eob != MIDDLE)
	 is_nxt_st			 = SORT;
       
       SORT: if(freq_counter_ptr > sym_hi_r)
	 is_nxt_st			 = IDLE;
     endcase 

     
     stall_pipe				 = (is_cur_st==SORT && is_nxt_st==IDLE) && ht_is_not_ready;

     
     not_ready				 =  is_cur_st != IDLE;
     
 end 
   

always_comb
begin



   for(int k=0;k<N_FANOUT_REPLICATORS;k++)
   begin
   
          for(int j=0;j<REPLICATOR_LOAD;j++)
	  begin

	     
             for(int i=0;i<NUM_IN_SYMBOLS;i++)
             begin
                
                if( ((k*REPLICATOR_LOAD)+j+1 < MAX_NUM_SYM_USED) && (is_ht_sym_sort_freq_mod[(k*REPLICATOR_LOAD)+j+1] <= sorted_inputs[k][i].freq) )
                    per_sym_freq_sort[(k*REPLICATOR_LOAD)+j][i]	 =  CODE_1;
	        
	        
		else if(is_ht_sym_sort_freq_mod[(k*REPLICATOR_LOAD)+j] > sorted_inputs[k][i].freq)
		    per_sym_freq_sort[(k*REPLICATOR_LOAD)+j][i]	 = CODE_0;
	        
                else
                    per_sym_freq_sort[(k*REPLICATOR_LOAD)+j][i]	 = CODE_M1;
	  
             end 
	       
	end 
      
 end 

end 
 

always_comb
  begin
  
  
   for(int k=0;k<N_FANOUT_REPLICATORS;k++)
   begin   
      
     for(int j=0;j<REPLICATOR_LOAD;j++)
       begin

	    
	    merged_freq_sort[(k*REPLICATOR_LOAD)+j]				 = KEEP;
	    sort_table[(k*REPLICATOR_LOAD)+j]					 = '{sym :is_ht_sym_sort_freq_sym_mod[(k*REPLICATOR_LOAD)+j],
                                                                                     freq:is_ht_sym_sort_freq_mod[(k*REPLICATOR_LOAD)+j]};

	    
	    
	    if(per_sym_freq_sort[(k*REPLICATOR_LOAD)+j][1]==CODE_0)
                            begin
                                     merged_freq_sort[(k*REPLICATOR_LOAD)+j]	 = KEEP;
	                             sort_table[(k*REPLICATOR_LOAD)+j]		 = '{sym :is_ht_sym_sort_freq_sym_mod[(k*REPLICATOR_LOAD)+j],
                                                                                     freq:is_ht_sym_sort_freq_mod[(k*REPLICATOR_LOAD)+j]};
			    end
	    
	    else if(per_sym_freq_sort[(k*REPLICATOR_LOAD)+j][1]==CODE_M1)
	                    begin
                                     merged_freq_sort[(k*REPLICATOR_LOAD)+j]	 = INSERT_SYM1;
	                             sort_table[(k*REPLICATOR_LOAD)+j]		 = '{sym :sorted_inputs[k][1].symbol,
                                                                                     freq:sorted_inputs[k][1].freq};

			    end
	    
            else if(((k*REPLICATOR_LOAD)+j+1 < MAX_NUM_SYM_USED) && per_sym_freq_sort[(k*REPLICATOR_LOAD)+j+1][0]==CODE_M1)
	                    begin
                                     merged_freq_sort[(k*REPLICATOR_LOAD)+j]	 = INSERT_SYM0;
	                             sort_table[(k*REPLICATOR_LOAD)+j]		 = '{sym :sorted_inputs[k][0].symbol,
                                                                                     freq:sorted_inputs[k][0].freq};

			    end
	    
            else if(((k*REPLICATOR_LOAD)+j+1 < MAX_NUM_SYM_USED) && 
                    per_sym_freq_sort[(k*REPLICATOR_LOAD)+j][0]!=CODE_1 && per_sym_freq_sort[(k*REPLICATOR_LOAD)+j][1]==CODE_1)
	                    begin
                                     merged_freq_sort[(k*REPLICATOR_LOAD)+j]	 = PULL_BY_1;
	                             sort_table[(k*REPLICATOR_LOAD)+j]		 = '{sym :is_ht_sym_sort_freq_sym_mod[(k*REPLICATOR_LOAD)+j+1],
                                                                                     freq:is_ht_sym_sort_freq_mod[(k*REPLICATOR_LOAD)+j+1]};
		   
	                    end
	    
	    else if(((k*REPLICATOR_LOAD)+j+2 < MAX_NUM_SYM_USED) && per_sym_freq_sort[(k*REPLICATOR_LOAD)+j][1]==CODE_1)
	                    begin
                                     merged_freq_sort[(k*REPLICATOR_LOAD)+j]	 = PULL_BY_2;
	                             sort_table[(k*REPLICATOR_LOAD)+j]		 = '{sym :is_ht_sym_sort_freq_sym_mod[(k*REPLICATOR_LOAD)+j+2],
                                                                                     freq:is_ht_sym_sort_freq_mod[(k*REPLICATOR_LOAD)+j+2]};
		   
	                    end

  	 end 
   
    end 

end 

   

always @(posedge clk_gated or negedge rst_n)
begin
  if (~rst_n) 
  begin
    is_ht_eob <= MIDDLE;
    is_ht_sym_unique <= MAX_NUM_SYM_USED;
    
    
    is_ht_meta <= 0;
    is_ht_seq_id <= 0;
    is_ht_sym_hi <= 0;
    is_ht_sym_lo <= 0;
    is_ht_sym_sort_freq <= 0;
    is_ht_sym_sort_freq_sym <= 0;
    
  end
  else
    begin

      
      for(int i=0;i<MAX_NUM_SYM_USED;i++)
        begin
            is_ht_sym_sort_freq[i]      <= sort_table[i].freq;
            is_ht_sym_sort_freq_sym[i]  <= sort_table[i].sym;
        end
    
      is_ht_sym_lo			<= sym_lo_r;
      is_ht_sym_hi			<= sym_hi_r;
      is_ht_sym_unique			<= sym_unique;

      is_ht_seq_id			<= seq_id_r;
      is_ht_meta			<= meta_r;

      
      
      if( (is_cur_st==SORT && is_nxt_st==IDLE) && stall_pipe==0)
        is_ht_eob			<= eob_r;
      else
	is_ht_eob			<=  MIDDLE;
       
  end
end

assign clk_gate_open = (eob != MIDDLE) | 
                       (is_ht_eob != MIDDLE) |
                       (is_cur_st != IDLE && ~stall_pipe);

`ifdef CLK_GATE  
    cr_clk_gate dont_touch_clk_gate ( .i0(1'b0), .i1(clk_gate_open), .phi(clk), .o(clk_gated) ); 
`else
    assign clk_gated = clk;
`endif




   
 
endmodule 







