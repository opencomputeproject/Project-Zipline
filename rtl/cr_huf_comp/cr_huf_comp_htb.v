/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/














`include "cr_huf_comp.vh"

module cr_huf_comp_htb
  #(parameter
    DAT_WIDTH        =10,      
    SYM_FREQ_WIDTH   =15,      
    SYM_ADDR_WIDTH   =10,      
    CNTRL_WIDTH      =1,       
    CODELENGTH_WIDTH =5,       
    MAX_NUM_SYM_USED =576,     
    SPECIALIZE       =0,       
    REPLICATOR_LOAD  =8        
   )
  (
   
   ht_is_not_ready, ht_hw_sym_lo, ht_hw_sym_hi, ht_hw_meta,
   ht_hw_seq_id, ht_hw_sym_sort_freq, ht_hw_sym_sort_freq_val,
   ht_hw_sym_dpth, ht_hw_zero_symbols, ht_hw_build_error, ht_hw_eob,
   ht_hw_sym_unique, ht_hdr_seq_id, ht_dbg_cntr_rebuild,
   ht_dbg_cntr_rebuild_failed, bimc_odat, bimc_osync, htb_ecc_error,
   
   clk, rst_n, is_ht_sym_lo, is_ht_sym_hi, is_ht_sym_unique,
   is_ht_sym_sort_freq, is_ht_sym_sort_freq_sym, is_ht_meta,
   is_ht_seq_id, is_ht_eob, hw_ht_sym_freq_rd, hw_ht_sym_freq_seq_id,
   hw_ht_sym_freq_rd_addr, hw_ht_sym_freq_rd_done, hw_ht_not_ready,
   hdr_ht_type, sw_ht_xp_max_code_length,
   sw_ht_deflate_max_code_length, sw_ht_max_rebuild_limit,
   sw_ht_force_rebuild, bimc_isync, bimc_idat, lvm, mlvm, mrdten
   );
   	    
`include "cr_structs.sv"
      
  import cr_huf_compPKG::*;
  import cr_huf_comp_regsPKG::*;
   

  
  parameter N_FANOUT_REPLICATORS = MAX_NUM_SYM_USED/REPLICATOR_LOAD;

 
 
 
 input                                        clk;
 input                                        rst_n; 
 
 
 

 
 input [DAT_WIDTH-1:0] 		              is_ht_sym_lo;   
 input [DAT_WIDTH-1:0] 		              is_ht_sym_hi;   
 input [DAT_WIDTH-1:0] 		              is_ht_sym_unique; 
 input [MAX_NUM_SYM_USED-1:0][SYM_FREQ_WIDTH-1:0] is_ht_sym_sort_freq; 
 input [MAX_NUM_SYM_USED-1:0][DAT_WIDTH-1:0]  is_ht_sym_sort_freq_sym; 
 input [CNTRL_WIDTH-1:0]                      is_ht_meta;      
 input [`CREOLE_HC_SEQID_WIDTH-1:0] 	      is_ht_seq_id;    
 input e_pipe_eob                             is_ht_eob;       
                                                               
                                                               
                                                               
                                                               
 
 input                                        hw_ht_sym_freq_rd; 
 input [`CREOLE_HC_SEQID_WIDTH-1:0]           hw_ht_sym_freq_seq_id;
 input [SYM_ADDR_WIDTH-2:0]                   hw_ht_sym_freq_rd_addr; 
 input                                        hw_ht_sym_freq_rd_done; 
 input  				      hw_ht_not_ready; 

 
 input  s_seq_id_type_intf                    hdr_ht_type;     
   
   
   
   
   
   
   
   
   
   
 
 input [CODELENGTH_WIDTH-1:0]   	      sw_ht_xp_max_code_length; 
 input [CODELENGTH_WIDTH-1:0]   	      sw_ht_deflate_max_code_length; 
 input [9:0]  	                              sw_ht_max_rebuild_limit; 
 input [`CR_HUF_COMP_HT_CONFIG_T_FORCE_REBUILD_DECL] sw_ht_force_rebuild; 
   
 input                                        bimc_isync;
 input                                        bimc_idat;
 input                                        lvm;
 input                                        mlvm;
 input                                        mrdten;  

 
 
 

 
 output logic	                              ht_is_not_ready; 

 
 output logic [DAT_WIDTH-1:0] 		      ht_hw_sym_lo;   
 output logic [DAT_WIDTH-1:0] 		      ht_hw_sym_hi;   
 output logic [CNTRL_WIDTH-1:0]               ht_hw_meta;
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]    ht_hw_seq_id; 
 output logic [(SYM_FREQ_WIDTH * 2)-1:0]      ht_hw_sym_sort_freq; 
 output logic [1:0]                           ht_hw_sym_sort_freq_val;
 output logic [MAX_NUM_SYM_USED-1:0][CODELENGTH_WIDTH-1:0] ht_hw_sym_dpth; 
 output logic   			      ht_hw_zero_symbols;   
 output logic				      ht_hw_build_error;    
 output e_pipe_eob                            ht_hw_eob;     
                                                             
                                                             
                                                             
                                                             
 output logic [DAT_WIDTH-1:0]                 ht_hw_sym_unique;
 
 output logic [`CREOLE_HC_SEQID_WIDTH-1:0]    ht_hdr_seq_id; 
   
 
 output logic                                 ht_dbg_cntr_rebuild; 
 output logic                                 ht_dbg_cntr_rebuild_failed; 
   
 output logic                                 bimc_odat;
 output logic                                 bimc_osync;  
 output logic     		              htb_ecc_error; 	

 
 
 logic [DAT_WIDTH-1:0]    actual_row_pntr,row_ptr,row_ptr_c,row_ptr_del_c,data_storage_mem_ptr;
 logic [9:0]              rebuild_cnt,rebuild_cnt_c;
 logic [MAX_NUM_SYM_USED-1:0][CODELENGTH_WIDTH-1:0] depth;
 logic                    wr_freq_mem, wr_freq_mem_c;       
 logic [`LOG_VEC(`ROUND_UP_DIV(MAX_NUM_SYM_USED,2))] wr_freq_mem_addr,wr_freq_mem_addr_c;  
 logic [1:0][SYM_FREQ_WIDTH-1:0] wr_freq_mem_data_int,wr_freq_mem_data_int_c;
 logic [1:0]              wr_freq_mem_val_int,wr_freq_mem_val_int_c;
 logic                    wr_freq_mem_done,wr_freq_mem_done_c;
 logic                    build_fail,rebuild_c,rebuild;
 logic [MAX_NUM_SYM_USED-1:0][SYM_FREQ_WIDTH-1:0] divided_freq;
 logic [MAX_NUM_SYM_USED-1:0][DAT_WIDTH-1:0]	  divided_sym;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0] wr_freq_mem_seq_id,wr_freq_mem_seq_id_c;
 e_pipe_eob               eob_store;
 logic [DAT_WIDTH-1:0]    ht_hw_sym_lo_c;
 logic [DAT_WIDTH-1:0]    ht_hw_sym_hi_c;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0]      ht_hw_seq_id_c;
 logic [CNTRL_WIDTH-1:0]  ht_hw_meta_c;
 logic                    ht_hw_zero_symbols_c;
 logic [DAT_WIDTH-1:0]    ht_hw_sym_unique_c;
 e_pipe_eob               eob_store_c;
 logic [DAT_WIDTH-1:0]    actual_row_pntr_c;
 logic [`CREOLE_HC_SEQID_WIDTH-1:0]      ht_hdr_seq_id_c;
 e_pipe_eob		  ht_hw_eob_c,is_ht_eob_del;
 logic [DAT_WIDTH-1:0]    data_storage_mem_ptr_c;
 logic                    stall_eob;
 logic [1:0][SYM_FREQ_WIDTH-1:0] ht_hw_sym_sort_freq_int;
 logic [1:0]              ht_hw_sym_sort_freq_val_int;
 logic [1:0]		  bimc_odat_int;
 logic [1:0]		  bimc_osync_int;
 logic [1:0]              bimc_isync_int;
 logic [1:0]              bimc_idat_int;
 logic [1:0]      	  ecc_error; 	
 logic [N_FANOUT_REPLICATORS-1:0][DAT_WIDTH-1:0] row_ptr_del;

 logic                    clk_gate_open,clk_gated; 


   

 typedef enum 		 {HTB_IDLE,STALL_BUILD_FAIL,REBUILD,STALL,BUILD,CHECK_REBUILD,PIPE_WAIT,CHECK_REBUILD_PIPE} e_tr_bldr_state;
   

 typedef struct packed {logic node;                  
                        logic [DAT_WIDTH-1:0] value; 
                       } s_work_table_a;
   
 typedef struct packed {logic node;                       
                        logic [SYM_FREQ_WIDTH-1:0] value; 
                       } s_work_table_b;
   
 typedef struct packed {s_work_table_a a; 
                        s_work_table_b b; 
                       } u_work_table;

 typedef struct packed {logic                 val;  
                        logic [DAT_WIDTH-1:0] node; 
                       } s_node_table;
   
  e_tr_bldr_state        htb_curr_st,htb_nxt_st,htb_curr_st_del;
  
  u_work_table           work_table_c[MAX_NUM_SYM_USED],work_table[MAX_NUM_SYM_USED],actual_data_storage[MAX_NUM_SYM_USED]
                         ,node_ptr_c,work_table_entry_c[2],actual_data_storage_c[MAX_NUM_SYM_USED];
  s_node_table           node_table[MAX_NUM_SYM_USED],node_table_c[MAX_NUM_SYM_USED];

  u_work_table           node_ptr[N_FANOUT_REPLICATORS],
                         work_table_entry[N_FANOUT_REPLICATORS][2];
   
 
 
 

assign bimc_osync        = bimc_osync_int[1];   
assign bimc_odat         = bimc_odat_int[1];
assign bimc_isync_int[1] = bimc_osync_int[0];  
assign bimc_idat_int[1]  = bimc_odat_int[0];
assign bimc_isync_int[0] = bimc_isync;  
assign bimc_idat_int[0]  = bimc_idat; 
assign htb_ecc_error     = |ecc_error; 
 
  


   
always_ff @(posedge clk_gated or negedge rst_n)
begin
  if (~rst_n) 
  begin
    
    for(int k=0;k<N_FANOUT_REPLICATORS;k++)
      begin
          work_table_entry    <= '{default:0};
          node_ptr            <= '{default:0};
	  row_ptr_del        <= 0;
      end

    ht_hw_eob           <= MIDDLE;
    eob_store           <= MIDDLE;
    is_ht_eob_del       <= MIDDLE;
    actual_data_storage <= '{default:0};
    node_table          <= '{default:0};
    work_table          <= '{default:0};
    htb_curr_st         <= HTB_IDLE;
    htb_curr_st_del     <= HTB_IDLE;
    
    
    actual_row_pntr <= 0;
    ht_dbg_cntr_rebuild <= 0;
    ht_dbg_cntr_rebuild_failed <= 0;
    ht_hdr_seq_id <= 0;
    ht_hw_build_error <= 0;
    ht_hw_meta <= 0;
    ht_hw_seq_id <= 0;
    ht_hw_sym_dpth <= 0;
    ht_hw_sym_hi <= 0;
    ht_hw_sym_lo <= 0;
    ht_hw_sym_unique <= 0;
    ht_hw_zero_symbols <= 0;
    rebuild <= 0;
    rebuild_cnt <= 0;
    row_ptr <= 0;
    
  end
  else
    begin

       htb_curr_st			<= htb_nxt_st;

       ht_hw_sym_lo			<= ht_hw_sym_lo_c;
       ht_hw_sym_hi			<= ht_hw_sym_hi_c;
       ht_hw_seq_id			<= ht_hw_seq_id_c;
       ht_hw_meta                       <= ht_hw_meta_c;
       ht_hw_zero_symbols		<= ht_hw_zero_symbols_c;
       ht_hw_sym_unique                 <= ht_hw_sym_unique_c;
       eob_store			<= eob_store_c;
       actual_row_pntr			<= actual_row_pntr_c;
       actual_data_storage              <= actual_data_storage_c;
       ht_hdr_seq_id			<= ht_hdr_seq_id_c;

       rebuild_cnt			<= rebuild_cnt_c;
       if(is_ht_eob==MIDDLE)
          rebuild                       <= rebuild_c;
            
       ht_dbg_cntr_rebuild		<= htb_curr_st==REBUILD;
       ht_dbg_cntr_rebuild_failed	<= htb_curr_st==HTB_IDLE && build_fail;

       
       work_table			<=  work_table_c;
       
       row_ptr				<= row_ptr_c;

       
       node_table			<= node_table_c;
       
       
       ht_hw_sym_dpth			<= depth;   

       
       ht_hw_eob			<= ht_hw_eob_c;
           
       
       ht_hw_build_error		<= build_fail;
       

       htb_curr_st_del                  <= htb_curr_st;
       is_ht_eob_del                    <= is_ht_eob;  

       
       for(int k=0;k<N_FANOUT_REPLICATORS;k++)
	begin
            work_table_entry[k]         <= work_table_entry_c;
            node_ptr[k]                 <= node_ptr_c;
            row_ptr_del[k]              <= row_ptr_del_c;
        end
       
  end 
   
end 

   
  




always_comb
 begin

  ht_hw_sym_lo_c	                                                                = ht_hw_sym_lo;
  ht_hw_sym_hi_c	                                                                = ht_hw_sym_hi;
  ht_hw_seq_id_c	                                                                = ht_hw_seq_id;
  ht_hw_meta_c										= ht_hw_meta;
  ht_hw_zero_symbols_c	                                                                = ht_hw_zero_symbols;
  eob_store_c		                                                                = eob_store;
  actual_row_pntr_c	                                                                = actual_row_pntr;
  actual_data_storage_c	                                                                = actual_data_storage;
  ht_hdr_seq_id_c	                                                                = ht_hdr_seq_id;
  ht_hw_sym_unique_c                                                                    = ht_hw_sym_unique;
  if(is_ht_eob != MIDDLE)
     begin
         
         ht_hw_sym_lo_c			                                                = is_ht_sym_lo;
         ht_hw_sym_hi_c			                                                = is_ht_sym_hi;
	 ht_hw_seq_id_c			                                                = is_ht_seq_id;
	 ht_hw_meta_c									= is_ht_meta;
	 
         ht_hw_zero_symbols_c		                                                = (is_ht_sym_unique == MAX_NUM_SYM_USED);
         
	 
	 eob_store_c         		                                                = is_ht_eob;
	 
	 actual_row_pntr_c		                                                = is_ht_sym_unique;
         for(int i =0;i<MAX_NUM_SYM_USED;i++)
             actual_data_storage_c[i]	                                                = '{a: is_ht_sym_sort_freq_sym[i], b: is_ht_sym_sort_freq[i]};
	 
	 ht_hdr_seq_id_c	               	                                        = is_ht_seq_id;
	 ht_hw_sym_unique_c                                                             = is_ht_sym_unique;
                  
     end 

end 


always_comb
  begin

  work_table_entry_c									 = '{default:0};
  node_ptr_c										 = '{default:0} ;
  row_ptr_del_c									 = row_ptr;

  if(htb_curr_st == BUILD)
    begin
          
           
           
           
           
           if(row_ptr+1 < MAX_NUM_SYM_USED)
	       begin
	           
		   
	           if(node_ptr[0].a.node && node_ptr[0].b.value < work_table[row_ptr+1].b.value)
		        
		        
                        work_table_entry_c[0]						 =  node_ptr[0];
                   else if(node_ptr[0].a.node)
                        work_table_entry_c[0]						 =  work_table[row_ptr+1];
		   else
		        work_table_entry_c[0]						 =  work_table[row_ptr];

	       end 
           else if(row_ptr < MAX_NUM_SYM_USED)
	     begin
		   work_table_entry_c[0]						 =  work_table[row_ptr];
	     end 
       
           
	   if(node_ptr[0].a.node && node_ptr[0].b.value < work_table[row_ptr+1].b.value)
	         work_table_entry_c[1]						         =  work_table[row_ptr+1];
           else if(node_ptr[0].a.node && (row_ptr+2 < MAX_NUM_SYM_USED))
               begin
                   if(node_ptr[0].b.value < work_table[row_ptr+2].b.value)
                           work_table_entry_c[1]					 =  node_ptr[0];
	   	   else
	   	           work_table_entry_c[1]					 =  work_table[row_ptr+2];
               end
           else if(node_ptr[0].a.node)
                 work_table_entry_c[1]						         =  node_ptr[0];
	   else if(row_ptr+1 < MAX_NUM_SYM_USED)
	         work_table_entry_c[1]						         =  work_table[row_ptr+1];


	   
           
           node_ptr_c.a.node								 = 1;
           node_ptr_c.a.value								 = row_ptr; 
           node_ptr_c.b.node								 = 0;
           node_ptr_c.b.value								 = work_table_entry_c[0].b.value + work_table_entry_c[1].b.value;

 
    end 
     
end 
   


always_comb
  begin

  
  work_table_c		                                                                 = work_table;
  row_ptr_c		                                                                 = row_ptr;

  
  
  if(is_ht_eob != MIDDLE)
       begin
          for(int i =0;i<MAX_NUM_SYM_USED;i++)
             begin
                work_table_c[i].a.node							 = 0;
    		work_table_c[i].a.value							 = is_ht_sym_sort_freq_sym[i];
    		work_table_c[i].b.node							 = 0;
    		work_table_c[i].b.value							 = is_ht_sym_sort_freq[i];
             end
	  
          row_ptr_c									 = is_ht_sym_unique;
       end 
  else if (htb_curr_st == REBUILD)
    
    begin
        for(int i =0;i<MAX_NUM_SYM_USED;i++)
	   begin
	       work_table_c[i].a.node							 = 0;
               work_table_c[i].a.value							 = divided_sym[i];
               work_table_c[i].b.node							 = 0;
               work_table_c[i].b.value							 = divided_freq[i];     
	   end
        
        row_ptr_c									 = actual_row_pntr;
  end 
  else if(htb_curr_st == BUILD)
    begin
           
           
              row_ptr_c									 = row_ptr + 1;

           
           
           for(int k=0;k<N_FANOUT_REPLICATORS;k++)
             begin
		
		  for(int i=0;i<REPLICATOR_LOAD;i++)
		    begin

		       if(((k*REPLICATOR_LOAD)+i+1 < MAX_NUM_SYM_USED) && node_ptr[k].b.value != 0 &&
			  node_ptr[k].b.value >= work_table[(k*REPLICATOR_LOAD)+i+1].b.value)
			 begin
			    
			    work_table_c[(k*REPLICATOR_LOAD)+i]				 = work_table[(k*REPLICATOR_LOAD)+i+1];
			    work_table_c[(k*REPLICATOR_LOAD)+i+1]			 = node_ptr[k];
			 end

		    end 
             
             end 
       
   end 
    
end 



always_comb
begin  

  
  
  
  rebuild_c										 = 1'b0;
  for(int i =0;i<MAX_NUM_SYM_USED;i++)
     if(((hdr_ht_type.comp_mode == ZLIB || hdr_ht_type.comp_mode == GZIP) && ht_hw_sym_dpth[i] > sw_ht_deflate_max_code_length && is_ht_eob_del==MIDDLE) ||
        ((hdr_ht_type.comp_mode != ZLIB && hdr_ht_type.comp_mode != GZIP) && ht_hw_sym_dpth[i] > sw_ht_xp_max_code_length && is_ht_eob_del==MIDDLE) ||
        (htb_curr_st==CHECK_REBUILD && sw_ht_force_rebuild != 0 && {7'b0,sw_ht_force_rebuild} !=rebuild_cnt))
             rebuild_c									 = ~rebuild;
    

  
  rebuild_cnt_c										 = rebuild_cnt;
  if(htb_curr_st==HTB_IDLE)
    
    
     rebuild_cnt_c									 = 0;

  else if(rebuild_c)
     rebuild_cnt_c									 = rebuild_cnt + 1;
    

  
  build_fail										 = 0;
  if(rebuild_cnt > sw_ht_max_rebuild_limit)
        build_fail									 = 1;

  
  for(int i =0;i<MAX_NUM_SYM_USED;i++)
    begin
        if(actual_data_storage[i].b != 0 && (actual_data_storage[i].b.value >> rebuild_cnt) == 0)
	   divided_freq[i]								 = {{SYM_FREQ_WIDTH-1{1'b0}},1'b1};
        else
           divided_freq[i]								 = actual_data_storage[i].b >> rebuild_cnt;
       
	divided_sym[i]								         = actual_data_storage[i].a;
     end
   
end 

            

always_comb
  begin

  

  node_table_c		= node_table;
  depth			= ht_hw_sym_dpth;

  
  
  

  
  if(is_ht_eob_del != MIDDLE || rebuild)
       begin
          for(int i =0;i<MAX_NUM_SYM_USED;i++)
             begin
                node_table_c[i].val							 = 0;
                depth[i]								 = 0; 
             end
       end 
  else if(htb_curr_st_del == BUILD)
    begin

           
	   
	   
       
           

           for(int j=0;j<2;j++)
	     begin

	       for(int k=0;k<N_FANOUT_REPLICATORS;k++)
                 begin

		    for(int i=0;i<REPLICATOR_LOAD;i++)
		      begin

			  if(work_table_entry[k][j].a.node==0 && work_table_entry[k][j].b.value != 0 && {{($clog2(32*REPLICATOR_LOAD)+1+DAT_WIDTH){1'b0}},work_table_entry[k][j].a.value}==(k*REPLICATOR_LOAD)+i)
			    begin
			       node_table_c[(k*REPLICATOR_LOAD)+i]		        = '{val: 1'b1,node: row_ptr_del[k]};
	                       depth[(k*REPLICATOR_LOAD)+i]				= 1;
			    end
			 else if(work_table_entry[k][j].a.node==1 && work_table_entry[k][j].b.value != 0 && 
                                node_table[(k*REPLICATOR_LOAD)+i].val==1 && node_table[(k*REPLICATOR_LOAD)+i].node==work_table_entry[k][j].a.value)
			    begin
			       node_table_c[(k*REPLICATOR_LOAD)+i].node                 = row_ptr_del[k];
		               depth[(k*REPLICATOR_LOAD)+i]                             = ht_hw_sym_dpth[(k*REPLICATOR_LOAD)+i] + 1;
			    end
			 
		      end

		 end
		
	     end 
       
    end 
    
end 
   

   

always_comb
begin   
    
  
  htb_nxt_st										 = htb_curr_st;
  case(htb_curr_st)
      
      HTB_IDLE: if(is_ht_eob != MIDDLE)
                htb_nxt_st								 = BUILD;
    
      BUILD:   
               if(ht_hw_zero_symbols)
		 begin
		    if(stall_eob)
		    
                       htb_nxt_st							 = STALL;
                    else
		       htb_nxt_st							 = HTB_IDLE;
		 end
               
	       
	       
               else if(build_fail && 
                  stall_eob)
	                 htb_nxt_st							 = STALL_BUILD_FAIL;
               
               else if(build_fail)
	         htb_nxt_st								 = HTB_IDLE;
               
               else if(rebuild)
	         htb_nxt_st								 = REBUILD;
               
               
               else if(row_ptr >= MAX_NUM_SYM_USED-2)
	                      htb_nxt_st						 = PIPE_WAIT;

      PIPE_WAIT:
	       
	       
	       
	       if(build_fail && 
                  stall_eob)
	                 htb_nxt_st							 = STALL_BUILD_FAIL;
               
               else if(build_fail)
	         htb_nxt_st								 = HTB_IDLE;
               
               else if(rebuild)
	         htb_nxt_st								 = REBUILD;
               else
		 
		 htb_nxt_st								 = CHECK_REBUILD;
               
      CHECK_REBUILD:
	        
	       
	       
               if(build_fail && 
                  stall_eob)
	                 htb_nxt_st							 = STALL_BUILD_FAIL;
               
               else if(build_fail)
	         htb_nxt_st								 = HTB_IDLE;
               
               else if(rebuild)
	         htb_nxt_st								 = REBUILD;
               else 
		 htb_nxt_st								 = CHECK_REBUILD_PIPE;
    
      CHECK_REBUILD_PIPE:
	        
	       
	       
               if(build_fail && 
                  stall_eob)
	                 htb_nxt_st							 = STALL_BUILD_FAIL;
               
               else if(build_fail)
	         htb_nxt_st								 = HTB_IDLE;
               
               else if(rebuild)
	         htb_nxt_st								 = REBUILD;
               else if(stall_eob)
		 
                 htb_nxt_st								 = STALL;
               else
		 htb_nxt_st								 = HTB_IDLE;	     
	         
      REBUILD: 
	         htb_nxt_st								 = BUILD;
    
      STALL: 
	     if(~stall_eob)
	        htb_nxt_st								 = HTB_IDLE;

      STALL_BUILD_FAIL: 
	                if(~stall_eob)
	                   htb_nxt_st							 = HTB_IDLE;

  endcase 


 end 



always_comb
  begin

  data_storage_mem_ptr_c								 = data_storage_mem_ptr;
  
  if(is_ht_eob != MIDDLE)
     data_storage_mem_ptr_c								 = is_ht_sym_unique;
  else if(data_storage_mem_ptr < MAX_NUM_SYM_USED)
     data_storage_mem_ptr_c								 = data_storage_mem_ptr + 1;
     

  
  wr_freq_mem_c										 = (htb_curr_st != HTB_IDLE && data_storage_mem_ptr < MAX_NUM_SYM_USED); 
  
  
  
  wr_freq_mem_addr_c									 = data_storage_mem_ptr >= MAX_NUM_SYM_USED ? 0: actual_data_storage[data_storage_mem_ptr].a.value[DAT_WIDTH-1:1];
  wr_freq_mem_data_int_c[0]								 = data_storage_mem_ptr >= MAX_NUM_SYM_USED ? 0: 
                                                                                           actual_data_storage[data_storage_mem_ptr].b.value;
  wr_freq_mem_data_int_c[1]								 = data_storage_mem_ptr >= MAX_NUM_SYM_USED ? 0: 
                                                                                           actual_data_storage[data_storage_mem_ptr].b.value;
  wr_freq_mem_seq_id_c									 = ht_hdr_seq_id;
  
  wr_freq_mem_val_int_c[0]								 = data_storage_mem_ptr >= MAX_NUM_SYM_USED ? 0: 
                                                                                           ~actual_data_storage[data_storage_mem_ptr].a.value[0];
  wr_freq_mem_val_int_c[1]								 = data_storage_mem_ptr >= MAX_NUM_SYM_USED ? 0: 
                                                                                           actual_data_storage[data_storage_mem_ptr].a.value[0];
  wr_freq_mem_done_c									 = data_storage_mem_ptr >= MAX_NUM_SYM_USED-1;


  ht_hw_sym_sort_freq									 = {ht_hw_sym_sort_freq_int[1],ht_hw_sym_sort_freq_int[0]};
  ht_hw_sym_sort_freq_val								 = {ht_hw_sym_sort_freq_val_int[1],ht_hw_sym_sort_freq_val_int[0]};
  

end 


always_comb
  begin
   
  
  if(htb_curr_st != HTB_IDLE && htb_nxt_st == HTB_IDLE)
         ht_hw_eob_c									 = eob_store;
  else
         ht_hw_eob_c									 = MIDDLE;

  
  ht_is_not_ready									 = (htb_curr_st != HTB_IDLE);

  stall_eob										 = hw_ht_not_ready || ht_hw_eob != MIDDLE || wr_freq_mem_done==0;
     
  end 
 

always_ff @(posedge clk or negedge rst_n)
begin
  if (~rst_n) 
  begin
    
    
    data_storage_mem_ptr <= 0;
    wr_freq_mem <= 0;
    wr_freq_mem_addr <= 0;
    wr_freq_mem_data_int <= 0;
    wr_freq_mem_done <= 0;
    wr_freq_mem_seq_id <= 0;
    wr_freq_mem_val_int <= 0;
    
  end
  else
  begin

       wr_freq_mem                      <= wr_freq_mem_c;
       wr_freq_mem_addr                 <= wr_freq_mem_addr_c;
       wr_freq_mem_data_int             <= wr_freq_mem_data_int_c;
       wr_freq_mem_val_int              <= wr_freq_mem_val_int_c;
       wr_freq_mem_done                 <= wr_freq_mem_done_c;
       wr_freq_mem_seq_id               <= wr_freq_mem_seq_id_c;

       
       data_storage_mem_ptr             <= data_storage_mem_ptr_c;
       
  end
end  

  

      
generate
   for(genvar i=0;i<2;i++)
     begin : FREQ_CNT_TWIN_BUF  
 cr_huf_comp_twin_buffer
    
     #(.N_WORDS(`ROUND_UP_DIV(MAX_NUM_SYM_USED,2)),
       .WORD_WIDTH(SYM_FREQ_WIDTH),
       .N_WORDS_PER_ENTRY(1),
       .N_RD_WORDS_PER_ENTRY(1),
       .META_DATA_WIDTH(1),
       .SPECIALIZE(SPECIALIZE))
   u_ht_hw_freq_mem
     (
      
      .full				(),			 
      .meta_full			(),			 
      .rd_out				(ht_hw_sym_sort_freq_int[i]), 
      .rd_valid_word			(ht_hw_sym_sort_freq_val_int[i]), 
      .rd_meta_data			(),			 
      .rd_meta_vld			(),			 
      .ro_uncorrectable_ecc_error	(ecc_error[i]),		 
      .bimc_odat			(bimc_odat_int[i]),	 
      .bimc_osync			(bimc_osync_int[i]),	 
      
      .clk				(clk),			 
      .rst_n				(rst_n),
      .wr				(wr_freq_mem),		 
      .wr_done				(wr_freq_mem_done),	 
      .wr_addr				(wr_freq_mem_addr),	 
      .wr_data				(wr_freq_mem_data_int[i]), 
      .wr_valid_word			(wr_freq_mem_val_int[i]), 
      .wr_meta				(1'd0),			 
      .wr_meta_done			(1'd0),			 
      .wr_meta_data			(1'd0),			 
      .wr_seq_id			(wr_freq_mem_seq_id),	 
      .rd				(hw_ht_sym_freq_rd),	 
      .rd_addr				(hw_ht_sym_freq_rd_addr), 
      .rd_done				(hw_ht_sym_freq_rd_done), 
      .rd_meta_done			(1'd0),			 
      .rd_seq_id			(hw_ht_sym_freq_seq_id), 
      .bimc_isync			(bimc_isync_int[i]),	 
      .bimc_idat			(bimc_idat_int[i]),	 
      .lvm				(lvm),
      .mlvm				(mlvm),
      .mrdten				(mrdten),
      .ovstb				(1'b1));			 

     end 
   endgenerate

assign clk_gate_open =  (ht_is_not_ready && htb_curr_st != STALL && htb_curr_st != STALL_BUILD_FAIL) |
                        is_ht_eob != MIDDLE |
		        ht_hw_eob != MIDDLE |
			(htb_curr_st == STALL && ~stall_eob) |
			(htb_curr_st == STALL_BUILD_FAIL && ~stall_eob) |
                        ht_dbg_cntr_rebuild_failed;
		 
`ifdef CLK_GATE  
   cr_clk_gate dont_touch_clk_gate ( .i0(1'b0), .i1(clk_gate_open), .phi(clk), .o(clk_gated) );
`else
   assign clk_gated = clk;
`endif 

  

     

   
endmodule 








