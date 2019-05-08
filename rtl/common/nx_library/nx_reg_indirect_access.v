/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
























`include "messages.vh"
`include "nx_mem_typePKG.svp"
module nx_reg_indirect_access
  #(parameter 
    CMND_ADDRESS=0,       
    STAT_ADDRESS=0,       
    ALIGNMENT=2,          
    N_DATA_BITS=32,       
    N_REG_ADDR_BITS=16,   
    N_ENTRIES=1)          
   (
   
   stat_code, stat_datawords, stat_addr, capability_lst,
   capability_type, rd_dat, mem_a,
   
   clk, rst_n, addr, cmnd_op, cmnd_addr, wr_stb, wr_dat, rst_dat
   );


   import nx_mem_typePKG::*;
   
   input logic                             clk;
   input logic 				   rst_n;
   
   input logic [`BIT_VEC(N_REG_ADDR_BITS)] addr;
   
   input logic [3:0] 			   cmnd_op;
   input logic [`LOG_VEC(N_ENTRIES)] 	   cmnd_addr;

   output logic [2:0] 			   stat_code;
   output logic [`BIT_VEC(5)] 		   stat_datawords;
   output logic [`LOG_VEC(N_ENTRIES)] 	   stat_addr;

   output logic [15:0] 			   capability_lst;
   output logic [3:0] 			   capability_type;

   input logic                             wr_stb;
   input logic [`BIT_VEC(N_DATA_BITS)] 	   wr_dat;
   input logic [`BIT_VEC(N_DATA_BITS)] 	   rst_dat[N_ENTRIES];
   
   output logic [`BIT_VEC(N_DATA_BITS)]    rd_dat;
   output logic [`BIT_VEC(N_DATA_BITS)]    mem_a[N_ENTRIES];

   localparam capabilities_t capabilities_t_set
     = '{ack_error      : TRUE,
	 sim_tmo        : FALSE,
         reserved_op    : '0,
	 compare        : FALSE,
	 set_init_start : FALSE,
	 init_inc       : FALSE,
	 init           : FALSE,
	 reset          : TRUE,
	 disabled       : FALSE,
	 enable         : FALSE,
	 write          : TRUE,
	 read           : TRUE,
	 nop            : TRUE};
   
   logic 				   reset;
   logic [`LOG_VEC(N_ENTRIES)] 		   sw_add;
   logic 				   sw_cs;
   logic [`BIT_VEC(N_DATA_BITS)] 	   sw_wdat;
   logic [`BIT_VEC(N_DATA_BITS)] 	   sw_rdat;
   logic 				   sw_we;

   logic [`LOG_VEC(N_ENTRIES)] 		   addr_limit; 
   assign addr_limit = N_ENTRIES-1;


   
   
   
   nx_indirect_access_cntrl
     #(.MEM_TYPE              (REG),
       .CAPABILITIES          (capabilities_t_set),
       .CMND_ADDRESS          (CMND_ADDRESS),
       .STAT_ADDRESS          (STAT_ADDRESS),
       .ALIGNMENT             (ALIGNMENT),
       .N_TIMER_BITS          (0),
       .N_REG_ADDR_BITS       (N_REG_ADDR_BITS),
       .N_INIT_INC_BITS       (0),
       .N_DATA_BITS           (N_DATA_BITS),
       .N_ENTRIES             (N_ENTRIES),
       .RESET_DATA            (0),
       .N_TABLES              (1))
   u_cntrl
     (.grant                ('1),
      .enable		    (), 
      .yield		    (), 
      .cmnd_table_id        ('0),
      .stat_table_id        (),
      .sw_ce                (),
      .sw_match             ('0),
      .sw_aindex            ('0),
      .reg_addr	      (addr[`BIT_VEC(N_REG_ADDR_BITS)]),
      .*);

   
   
   
   always_ff @(posedge clk or negedge rst_n) begin : mem_wr_rst
      if (!rst_n) begin : rst
	 for (int ii=0; ii<N_ENTRIES; ii++)
           mem_a[ii] <= rst_dat[ii];
      end : rst
      else if (reset) begin
	 for (int ii=0; ii<N_ENTRIES; ii++)
           mem_a[ii] <= rst_dat[ii];
      end else if (sw_cs && sw_we && 16'(sw_add) < 16'(N_ENTRIES)) begin
	 
	 
	 mem_a[sw_add] <= sw_wdat; 
      end
   end : mem_wr_rst

   
   always_ff @(posedge clk or negedge rst_n) begin : mem_rd
      if (!rst_n) begin : rst
	 sw_rdat <= 0;
      end : rst
      else if (sw_cs) begin
	 if (16'(sw_add) < 16'(N_ENTRIES)) begin
	    if (sw_we) 
	      sw_rdat <= sw_wdat;
	    else
	      
	      
	      sw_rdat <= mem_a[sw_add]; 
	 end
	 else
	   sw_rdat <= 0;
      end
   end : mem_rd

`ifndef SYNTHESIS
   initial begin
      `INFO("%dx%db RegArray (%db)", N_ENTRIES, N_DATA_BITS, 
            N_ENTRIES*N_DATA_BITS);
      `INFO("Estimate %d flops", 
            N_ENTRIES*N_DATA_BITS + 
            N_DATA_BITS);           
   end

   

   
   task read (input string name, input integer addr,
              output bit [`BIT_VEC(N_DATA_BITS)] rdata,
              input [`BIT_VEC(N_DATA_BITS)] 	 check={N_DATA_BITS{1'bx}});
      if (addr >= N_ENTRIES) begin
	 `ERROR("Received address of %d, maximum supported is %d", 
		addr, N_ENTRIES);
	 rdata = {N_DATA_BITS{1'bx}};
      end
      else
	rdata = mem_a[addr];

      if ((check !== {N_DATA_BITS{1'bx}}) && (rdata != check))
	`ERROR("read 0x%0x from %s[%d] but expecting 0x%0x", 
               rdata, name, addr, check);
      else
	`INFO("backdoor read 0x%0x from %s[%d]", rdata, name, addr);
   endtask : read
   
   
   task write (input string name, input integer addr,
               input bit [`BIT_VEC(N_DATA_BITS)] wdata);
      if (addr >= N_ENTRIES)
	`ERROR("Received address of %d, maximum supported is %d", 
               addr, N_ENTRIES);
      else
	mem_a[addr] = wdata;

      `INFO("backdoor write 0x%0x to %s[%d]", wdata, name, addr);
   endtask : write
`endif 
   
endmodule 






