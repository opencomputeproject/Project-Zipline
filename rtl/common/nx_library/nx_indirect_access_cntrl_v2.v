/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/












`include "ccx_std.vh"
`include "messages.vh"
`include "nx_mem_typePKG_v2.svp"
module nx_indirect_access_cntrl_v2
  #(parameter
    MEM_TYPE=0,           
    CMND_ADDRESS=0,       
    STAT_ADDRESS=0,       
    ALIGNMENT=2,          
    N_TIMER_BITS=6,       
    N_REG_ADDR_BITS=16,   
			  
    N_DATA_BITS=32,       
    N_TABLES=1,           
    N_ENTRIES=1,          
    N_INIT_INC_BITS=0,    
			  
    parameter [15:0] CAPABILITIES=0, 
    parameter [`BIT_VEC(N_DATA_BITS)] RESET_DATA=0)
  (input logic                             clk,
   input logic                                           rst_n,

   
   input logic                                           wr_stb,
   input logic [`BIT_VEC(N_REG_ADDR_BITS)]               reg_addr,

   input logic [3:0]                                     cmnd_op,
   input logic [`LOG_VEC(N_ENTRIES)]                     cmnd_addr,
   input logic [`LOG_VEC(N_TABLES)]                      cmnd_table_id,

   output logic [2:0]                                    stat_code,
   output logic [`BIT_VEC(5)]                            stat_datawords,
   output logic [`LOG_VEC(N_ENTRIES)]                    stat_addr,
   output logic [`LOG_VEC(N_TABLES)]                     stat_table_id,

   output logic [15:0]                                   capability_lst,
   output logic [3:0]                                    capability_type,
   
   output logic                                          enable,

   
   
   input logic [`BIT_VEC(N_TABLES)][`LOG_VEC(N_ENTRIES)] addr_limit,

   input logic [`BIT_VEC(N_DATA_BITS)]                   wr_dat,

   output logic [`BIT_VEC(N_DATA_BITS)]                  rd_dat,

   output logic                                          sw_cs,
   output logic                                          sw_ce, 
   output logic                                          sw_we,
   output logic [`LOG_VEC(N_ENTRIES)]                    sw_add,
   output logic [`BIT_VEC(N_DATA_BITS)]                  sw_wdat,

   input logic [`BIT_VEC(N_DATA_BITS)]                   sw_rdat,
   input logic                                           sw_match, 
   input logic [`LOG_VEC(N_ENTRIES/2)]                   sw_aindex,

   input logic                                           grant,
   input logic                                           rsp,
   output logic                                          yield,
   output logic                                          reset);


   import nx_mem_typePKG_v2::*;
   


  typedef enum bit [3:0]
               {NOP            = 4'h0,
                READ           = 4'h1,
                WRITE          = 4'h2,
                ENABLE         = 4'h3,
                DISABLED       = 4'h4,
                RESET          = 4'h5,
                INIT           = 4'h6,
                INIT_INC       = 4'h7,
                SET_INIT_START = 4'h8,
                COMPARE        = 4'h9,
                SIM_TMO        = 4'he,
                ACK_ERROR      = 4'hf} ia_operation_e;
  ia_operation_e cmnd;
  assign cmnd = ia_operation_e'(cmnd_op);

    
   assign capability_lst = {CAPABILITIES};

   
   assign capability_type = 4'(MEM_TYPE);
  
 
  
   
   
  typedef enum bit [2:0]
               {RDY   = 3'h0,
                BSY   = 3'h1,
                TMO   = 3'h2,
                OVR   = 3'h3,
                NXM   = 3'h4,
                UOP   = 3'h5,
                PDN   = 3'h7} ia_status_e;

  logic   init_r;
  assign enable = !init_r;

  logic [`BIT_VEC(N_INIT_INC_BITS)] inc_r;
  logic                             init_inc_r;

  logic                             sw_cs_r;
  logic                             sw_ce_r;
  logic                             rst_r;
  logic                             rst_or_ini_r;
  logic [`LOG_VEC(N_ENTRIES)]       rst_addr_r;
  logic                             sw_we_r;
   
  assign sw_cs   = sw_cs_r;
  assign sw_ce   = sw_ce_r;
  assign sw_we   = sw_we_r;
  assign sw_add  = rst_or_ini_r ? rst_addr_r : cmnd_addr;


   
  generate


     if (MEM_TYPE == REG)
       assign reset   = rst_r;
     else
       assign reset   = rst_or_ini_r;

     case (1'b1)
       (N_INIT_INC_BITS == N_DATA_BITS) :
         assign sw_wdat = (rst_r ? RESET_DATA : inc_r);
       (N_INIT_INC_BITS == 0) :
         assign sw_wdat = (rst_r ? RESET_DATA : wr_dat);
       (N_INIT_INC_BITS < N_DATA_BITS) :
         assign sw_wdat = (rst_r      ?
                           RESET_DATA :
                           {wr_dat[N_DATA_BITS-1:N_INIT_INC_BITS], inc_r});
`ifndef SYNTHESIS
       default :
         initial assert (N_INIT_INC_BITS<=N_DATA_BITS); 
`endif
     endcase 

  endgenerate

  

  logic cmnd_rd_stb;
  logic cmnd_wr_stb;
  logic cmnd_ena_stb;
  logic cmnd_dis_stb;
  logic cmnd_rst_stb;
  logic cmnd_ini_stb;
  logic cmnd_inc_stb;
  logic cmnd_sis_stb;
  logic cmnd_tmo_stb;
  logic cmnd_cmp_stb;
  logic cmnd_issued;
  logic ack_error;
  logic unsupported_op;

   always_comb begin

    cmnd_rd_stb    = 0;
    cmnd_wr_stb    = 0;
    cmnd_ena_stb   = 0;
    cmnd_dis_stb   = 0;
    cmnd_rst_stb   = 0;
    cmnd_ini_stb   = 0;
    cmnd_inc_stb   = 0;
    cmnd_sis_stb   = 0;
    cmnd_tmo_stb   = 0;
    cmnd_cmp_stb   = 0;
    ack_error      = 0;
    cmnd_issued    = 0;
    unsupported_op = 0;

      if (wr_stb && (reg_addr == CMND_ADDRESS)) begin
      if (cmnd != SIM_TMO)
        cmnd_issued = 1;
      unique case (cmnd)
        NOP            : cmnd_issued    = 0;
        READ           : cmnd_rd_stb    = 1;
        WRITE          : cmnd_wr_stb    = 1;
        ENABLE         : cmnd_ena_stb   = 1;
        DISABLED       : cmnd_dis_stb   = 1;
        RESET          : cmnd_rst_stb   = 1;
        INIT           : cmnd_ini_stb   = 1;
        INIT_INC       : cmnd_inc_stb   = 1;
        SET_INIT_START : cmnd_sis_stb   = 1;
        COMPARE        : cmnd_cmp_stb   = 1;
	SIM_TMO        : cmnd_tmo_stb   = 1;
        ACK_ERROR      : ack_error      = 1;
        default        : unsupported_op = 1;
      endcase 
      end 
   end 

  typedef enum bit [3:0] {POWERDOWN, READY, ERROR, DO_RESET, DO_INIT,
                          DO_WRITE, DO_READ, READ_DONE, DO_COMPARE, 
                          COMPARE_DONE} state_e;
  state_e state_r;

  logic [`BIT_VEC(N_TIMER_BITS)] timer_r;

  assign yield    = `msb(timer_r);

  logic timeout;
  assign timeout  = (timer_r == '1);
  logic sim_tmo_r;
   
  logic [`LOG_VEC(N_ENTRIES)] maxaddr;
  assign maxaddr = init_r ? 0 : addr_limit[cmnd_table_id%N_TABLES]; 

  logic badaddr;
  assign badaddr = cmnd_issued && (cmnd_addr > maxaddr);

  logic igrant;
  assign igrant = !sim_tmo_r && grant;
   
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin : rst
	 if (MEM_TYPE != REG) begin  
	    stat_code    <= PDN;
	    state_r      <= POWERDOWN;
	    init_r       <= 1;
	 end
	 else begin
	    stat_code    <= RDY;
	    state_r      <= READY;
	    init_r       <= 0;
	 end
	 rd_dat       <= RESET_DATA;
	 sw_cs_r      <= 0;
	 sw_we_r      <= 0;
	 sw_ce_r      <= 0;
	 timer_r      <= 0;
	 rst_r        <= 0;
	 rst_or_ini_r <= 0;
	 rst_addr_r   <= 0;
	 inc_r        <= 0;
	 init_inc_r   <= 0;
	 sim_tmo_r    <= 0;
      end : rst
      else begin : cntrlr
	 
	 
	 state_e state_v;

	 state_v       = state_r;

	 rst_r        <= 0;
	 rst_or_ini_r <= 0;
	 timer_r      <= 0;
	 sw_cs_r      <= 0;
	 sw_ce_r      <= 0;
	 sw_we_r      <= 0;

	 if (cmnd_sis_stb)
           rst_addr_r <= cmnd_addr;
	 else if (cmnd_rst_stb)
           rst_addr_r <= 0;

	 if (cmnd_tmo_stb)
	   sim_tmo_r <= 1;
	 else if (timeout)
	   sim_tmo_r <= 0;
	 
	 if (badaddr)
           
           
           state_v = ERROR;
	 else
	   unique case (state_r)

             POWERDOWN : begin
		rd_dat <= wr_dat;

		if (cmnd_ena_stb) begin
		   init_r <= 0; 
		   state_v = READY;
		end
             end

             READY : begin
		if (N_INIT_INC_BITS == 0) 
		  inc_r <= 0;
		else
		  inc_r <= wr_dat[`BIT_VEC(N_INIT_INC_BITS)];
		init_inc_r <= 0;

		unique case (1'b1)
		  cmnd_wr_stb                    : state_v = DO_WRITE;
		  cmnd_rd_stb                    : state_v = DO_READ;
		  cmnd_cmp_stb                   : state_v = DO_COMPARE;
		  cmnd_rst_stb                   : state_v = DO_RESET;
		  (cmnd_ini_stb || cmnd_inc_stb) : state_v = DO_INIT;
		  cmnd_dis_stb                   : state_v = POWERDOWN;
		  unsupported_op                 : state_v = ERROR;
		  default                        : state_v = state_r;
		endcase 

		init_inc_r <= (N_INIT_INC_BITS != 0) && cmnd_inc_stb;
             end 

             DO_WRITE : begin
		if (igrant)
		  state_v = READY;
             end

             DO_READ : begin
		if (igrant)
		  state_v = READ_DONE;
             end

             DO_COMPARE : begin
		if (igrant)
		  state_v = COMPARE_DONE;
             end

             DO_RESET : begin
		if (MEM_TYPE == REG)  
		  state_v = READY;
		else begin
		   rst_addr_r <= ($bits(rst_addr_r))'(rst_addr_r + igrant);

		   if (igrant && rst_addr_r == maxaddr)
		     state_v = READY;
		end
             end

             DO_INIT : begin
		rst_addr_r <= ($bits(rst_addr_r))'(rst_addr_r + igrant);
		inc_r <= ($bits(inc_r))'(inc_r + (init_inc_r && igrant));

		if (igrant && rst_addr_r == cmnd_addr)
		  state_v = READY;
             end

             READ_DONE : begin
                if (rsp) begin
		   rd_dat  <= sw_rdat;
                   
		   state_v = READY;
                end
             end

             COMPARE_DONE : begin
                if (rsp) begin
		   rd_dat <= sw_aindex |  (sw_match << $clog2(N_ENTRIES/2));
                   
		   state_v = READY;
                end
             end

	     
             default : begin
		if (ack_error)
		  state_v = init_r ? POWERDOWN : READY;
		else
		  state_v = ERROR;
             end

	   endcase 
	 
	 if ((timeout || cmnd_issued) &&
	     (state_r != POWERDOWN)   &&
	     (state_r != READY)       &&
	     (state_r != ERROR))
	   state_v = ERROR;
	 
	 case (state_v)

           POWERDOWN : begin
              stat_code <= PDN;
	      if (state_r != POWERDOWN)
		init_r <= 1; 
           end

           READY : begin
              stat_code <= RDY;
           end

           ERROR : begin
              if (state_r != ERROR) begin
		 
		 priority case (1'b1)
		   unsupported_op : stat_code <= UOP;
		   badaddr        : stat_code <= NXM;
		   timeout        : stat_code <= TMO;
		   cmnd_issued    : stat_code <= OVR;
		 endcase 
              end
           end 

           DO_WRITE : begin
              stat_code <= BSY;
              timer_r   <= timer_r + 1;
              sw_cs_r   <= 1;
              sw_we_r   <= 1;
           end

           DO_READ : begin
              stat_code <= BSY;
              timer_r   <= timer_r + 1;
              sw_cs_r   <= 1;
           end

           DO_COMPARE : begin
              stat_code <= BSY;
              timer_r   <= timer_r + 1;
              sw_cs_r   <= 1;
              sw_ce_r   <= 1;
           end

           DO_RESET : begin
              stat_code    <= BSY;
              timer_r      <= timer_r + 1;
              rst_or_ini_r <= 1;
              rst_r        <= 1;
              sw_cs_r      <= 1;
              sw_we_r      <= 1;
           end

           DO_INIT : begin
              stat_code    <= BSY;
              timer_r      <= timer_r + 1;
              rst_or_ini_r <= 1;
              sw_cs_r      <= 1;
              sw_we_r      <= 1;
           end

           
	   default      : stat_code    <= BSY;
	   
	 endcase 

	 if (igrant)
           timer_r <= 0;

	 state_r <= state_v;
	 
      end : cntrlr 
   end 

  assign stat_datawords = ((CMND_ADDRESS-STAT_ADDRESS)>>ALIGNMENT)-2; 
  assign stat_addr      = maxaddr;
  assign stat_table_id  = init_r ? 0 : (N_TABLES-1);

`ifndef SYNTHESIS
 `ifndef COVERAGE

   ia_status_e stat;
   assign stat = ia_status_e'(stat_code);
   
   final begin : end_of_sim

      
      if (stat_code != RDY && stat_code != PDN)
	if (stat_code != BSY)
          `ERROR("Please acknowledge indirect access error (%s)", stat.name());
	else
          `ERROR("Please wait for indirect access completion");

   end : end_of_sim

 `endif 
`endif 


endmodule : nx_indirect_access_cntrl_v2






