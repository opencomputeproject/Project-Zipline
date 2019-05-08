/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/













`include "ccx_std.vh"
`include "messages.vh"
module nx_tcam_indirect_access
  #(parameter 
    CMND_ADDRESS=0,       
    STAT_ADDRESS=0,       
    ALIGNMENT=2,          
    N_TIMER_BITS=6,       
    N_REG_ADDR_BITS=16,   
    N_DATA_BITS=32,       
    N_DATA_BITS_D2=16,    
    N_ENTRIES=0,            
    SPECIALIZE=1,         
    TM_WIDTH=20,          
    CAM_PWRDWN_WIDTH=4,   
    parameter [`BIT_VEC(N_DATA_BITS)] RESET_DATA=0)

   (
   
   stat_code,stat_datawords, stat_addr,
   rd_dat, hw_matchout, hw_yield, 
   
   clk, rst_n, reg_addr, cmnd_op, cmnd_addr, wr_stb, wr_dat, rd_stb,
   hw_ce, hw_key, lvm, mlvm, mrdten, ovstb, tm,tcam_pwrdwn_cfg
   );

    input logic                             clk;
    input logic 			    rst_n;

    
    input logic [`BIT_VEC(N_REG_ADDR_BITS)] reg_addr;
    
    input logic [3:0]                       cmnd_op;
    input logic [`LOG_VEC(N_ENTRIES)]       cmnd_addr;

    output logic [2:0]                      stat_code;
    output logic [`BIT_VEC(5)]              stat_datawords;
    output logic [`LOG_VEC(N_ENTRIES)]      stat_addr;

    input logic 			    wr_stb;
    input logic [`BIT_VEC(N_DATA_BITS)]     wr_dat;
    
    input  logic 			    rd_stb; 
    output logic [`BIT_VEC(N_DATA_BITS)]    rd_dat;

    

    input  logic			                      hw_ce;	
    input  logic [`BIT_VEC(N_DATA_BITS_D2)]	  hw_key;	

    output logic [`BIT_VEC(N_ENTRIES)]     hw_matchout;
    output logic                            hw_yield;
    input  logic                            lvm;
    input  logic                            mlvm;
    input  logic                            mrdten;
    input  logic                            ovstb;
    input  logic [`BIT_VEC(TM_WIDTH)]       tm;

    
    input  [`BIT_VEC(CAM_PWRDWN_WIDTH)]     tcam_pwrdwn_cfg;

   
   


  typedef enum bit [3:0]
	       {NOP        = 4'h0,
		READ       = 4'h1,
		WRITE      = 4'h2,
		ENABLE     = 4'h3,
		DISABLE    = 4'h4,
		RESET      = 4'h5,
		INITIALIZE = 4'h6,
		ACK_ERROR  = 4'hf} ia_operation_e;
   ia_operation_e cmnd;
   assign cmnd = ia_operation_e'(cmnd_op);

  typedef enum bit [2:0]
	       {RDY   = 3'h0,
		BSY   = 3'h1,
		TMO   = 3'h2,
		OVR   = 3'h3,
		NXM   = 3'h4} ia_status_e;
 
   
  logic   init_r;
  logic   sw_wr_frst_ac;
  logic   sw_wr_scnd_ac;
  logic   resetb;


  logic [`LOG_VEC(2*N_ENTRIES)]	add;	
  logic			        cs;	
  logic [`BIT_VEC(N_DATA_BITS_D2)]	din;	
  logic [1:0]       dinv;
  logic			        we;	
  logic [`BIT_VEC(N_DATA_BITS_D2)]	dout;	
  logic [1:0]       doutv;
  logic [1:0]       rst_cnt_r;

   
   assign add = sw_wr_frst_ac ? {cmnd_addr, 1'b0}  : 
                                {cmnd_addr, 1'b1} ;
                                
   
   
   
   
   
   
   assign din =  hw_ce ? hw_key  : 
                 (sw_wr_frst_ac) ? wr_dat[N_DATA_BITS-N_DATA_BITS_D2-5:0]  : 
                                   wr_dat[N_DATA_BITS-3:N_DATA_BITS-N_DATA_BITS_D2-2]; 
   assign dinv = hw_ce ? 2'b11 :
                 sw_wr_frst_ac ? wr_dat[N_DATA_BITS-N_DATA_BITS_D2-3:N_DATA_BITS-N_DATA_BITS_D2-4] :
                 sw_wr_scnd_ac ? wr_dat[N_DATA_BITS-1:N_DATA_BITS-2] : 
                                 2'b00;
   assign we  = hw_ce ? 1'b0   : (cmnd == WRITE);
   
  logic sw_cs_r; 
  logic rst_r;
  logic rst_or_ini_r; 

  logic ce;
   assign cs  = hw_ce || sw_cs_r || ~rst_n;
   assign ce  = hw_ce;
   assign resetb = rst_n & ~rst_r;
   
   nx_tcam
     #(.WIDTH(N_DATA_BITS_D2), 
       .DEPTH(N_ENTRIES),
       .SPECIALIZE(SPECIALIZE), 
       .TM_WIDTH(TM_WIDTH),
       .PWRDWN_WIDTH(CAM_PWRDWN_WIDTH)
       ) 
   u_tcam
     (.matchout(hw_matchout),
      .*);

   logic [`LOG_VEC(N_ENTRIES)] addr_limit; 
   assign addr_limit = N_ENTRIES-1;
  

   

   logic cmnd_rd_stb;
   logic cmnd_wr_stb;
   logic cmnd_ena_stb;
   logic cmnd_dis_stb;
   logic cmnd_rst_stb;
   logic cmnd_issued;
   logic ack_error;
   
   always @* begin

     cmnd_rd_stb   = 0;
     cmnd_wr_stb   = 0;
     cmnd_ena_stb  = 0;
     cmnd_dis_stb  = 0;
     cmnd_rst_stb  = 0;
     ack_error     = 0;
     cmnd_issued   = 0;

     if (wr_stb && (reg_addr == CMND_ADDRESS)) begin
       cmnd_issued = 1;
       unique case (cmnd)
	 NOP        : cmnd_issued   = 0;
	 READ       : cmnd_rd_stb   = 1;
	 WRITE      : cmnd_wr_stb   = 1;
	 ENABLE     : cmnd_ena_stb  = 1;
	 DISABLE    : cmnd_dis_stb  = 1;
	 RESET      : cmnd_rst_stb  = 1;
	 ACK_ERROR  : ack_error     = 1;
       endcase 
     end
   end
   
  typedef enum bit [3:0] {INIT, READY, ERROR, DO_RESET,
        
        
			  DO_WRITE,
        
        DO_WRITE_WAIT, 
        
        DO_READ,DO_READ_WAIT,
        READ_DONE} state_e;
   state_e state_r;
   
  logic [`BIT_VEC(N_TIMER_BITS)] timer_r;
  logic timeout;

   assign hw_yield = timer_r[N_TIMER_BITS-1];
   assign timeout  = (timer_r == {N_TIMER_BITS{1'b1}});

  logic [`LOG_VEC(N_ENTRIES)] maxaddr;
   assign maxaddr = init_r ? 0 : `MAX(N_ENTRIES-1, addr_limit);
   
  logic badaddr;
   assign badaddr = cmnd_issued && (cmnd_addr > maxaddr);

   
   
   always @(posedge clk  or negedge rst_n) begin : cntrlr
     if (!rst_n) begin : rst
       stat_code    <= RDY;
       state_r 	    <= INIT;
       rd_dat 	    <= RESET_DATA;
       sw_cs_r 	    <= 0;
       timer_r 	    <= 0;
       init_r       <= 1;
       sw_wr_frst_ac   <= 0;
       sw_wr_scnd_ac   <= 0;
       rst_r        <= 0;
       rst_or_ini_r <= 0;
       rst_cnt_r    <= 0;
     end : rst
     else begin
       state_e state_v;

       rst_r 	      <= 0;
       rst_or_ini_r <= 0;
       rst_cnt_r    <= 0;
       timer_r 	  <= 0;
       sw_cs_r 	  <= 0;
       init_r     <= 0;
       sw_wr_frst_ac <= 0;
       sw_wr_scnd_ac <= 0;
 
       
      state_v       = state_r;

       case (state_r)

	 INIT : begin
	   rd_dat <= wr_dat;

	   if (cmnd_ena_stb)
	     state_v = READY;
	 end
	 
	 READY : begin
	   if (cmnd_wr_stb)
	     if (badaddr)
	       state_v = ERROR;
	     else
	       state_v = DO_WRITE;
	   else if (cmnd_rd_stb)
	     if (badaddr)
	       state_v = ERROR;
	     else
	       state_v = DO_READ;
	   else if (cmnd_rst_stb)
	     state_v = DO_RESET;
	   else if (cmnd_dis_stb)
	     state_v = INIT;
	 end

	 ERROR : begin
	   if (ack_error) 
	     state_v = READY;
	 end

	 DO_WRITE : begin
	   if (timeout || cmnd_issued)
	     state_v = ERROR;
	   else if (!hw_ce ) 
	     state_v = DO_WRITE_WAIT;
	 end

   DO_WRITE_WAIT : begin 
     if(timeout || cmnd_issued)
       state_v = ERROR;
     else 
       state_v = READY;
   end
 
	 DO_READ : begin
	   if (timeout || cmnd_issued)
	     state_v = ERROR;
	   else if (!hw_ce )
	     state_v = DO_READ_WAIT; 
	 end

	 DO_READ_WAIT : begin
	   rd_dat[N_DATA_BITS-1:N_DATA_BITS-N_DATA_BITS_D2-2]  <= { dout, doutv }; 
	   if (timeout || cmnd_issued)
	     state_v = ERROR;
	   else  
	     state_v = READ_DONE; 
	 end

  DO_RESET : begin
    rst_cnt_r <= rst_cnt_r + (!hw_ce );

    if (timeout || cmnd_issued)
      state_v = ERROR;
    else if((!hw_ce )  && rst_cnt_r == 2'b11) 
         
      state_v = READY;
  end


	 READ_DONE : begin
     rd_dat[N_DATA_BITS-N_DATA_BITS_D2-3:0] <=  { dout, doutv} ; 

	   if (timeout || cmnd_issued)
	     state_v = ERROR;
	   else
	     state_v = READY;
	 end

   default: begin
      state_v = INIT;
   end
	 
       endcase 

      
       case (state_v)

	 INIT : begin
	   init_r <= 1;
	   stat_code <= RDY;
	 end

	 READY : begin
	   stat_code <= RDY;
	 end

	 ERROR : begin
	   if (state_r != ERROR) begin
	     
	     priority case (1'b1)
	       cmnd_issued : stat_code <= OVR;
	       timeout     : stat_code <= TMO;
	       badaddr     : stat_code <= NXM;
       endcase
     end
	 end

	 DO_WRITE : begin
	   stat_code  <= BSY;
	   timer_r    <= timer_r + 1;
	   sw_cs_r    <= 1;
     sw_wr_frst_ac <= 1;
	 end

	 DO_WRITE_WAIT : begin
	   stat_code <= BSY;
     if(!hw_ce)
  	   timer_r <= 0;
     else
       timer_r <= timer_r + 1;
	   sw_cs_r <= 1;
     sw_wr_scnd_ac <= 1;
	 end


	 DO_READ : begin
	   stat_code <= BSY;
	   timer_r  <= timer_r + 1;
	   sw_cs_r  <= 1;
	 end

	 DO_READ_WAIT : begin
	   stat_code <= BSY;
     if(!hw_ce)
  	   timer_r <= 0;
     else
       timer_r <= timer_r + 1;
	   sw_cs_r <= 1;
	 end

	 DO_RESET : begin
	   stat_code <= BSY;
	   timer_r <= timer_r + 1;
	   rst_or_ini_r <= 1;
	   sw_cs_r <= 1;
	   rst_r   <= 1;
	 end

	 READ_DONE : begin
	 end

   default: begin
   end
	 
       endcase 

       state_r <= state_v;
     end
   end : cntrlr
   
   assign stat_datawords = ((CMND_ADDRESS-STAT_ADDRESS)>>ALIGNMENT)-2;
   assign stat_addr      = init_r ? 0 : (N_ENTRIES-1);

   
   final begin : end_of_sim


     if (stat_code != RDY)
       if (stat_code != BSY)
	 `ERROR("Please acknowledge indirect access error");
       else
	 `ERROR("Please wait for indirect access completion");


   end : end_of_sim
   
     
   
   
















































   
endmodule 






