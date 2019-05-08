/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
















`include "bimc_master.vh"

module bimc_master (

   
   bimc_ecc_error,
   bimc_interrupt,
   bimc_odat,
   bimc_osync,
   bimc_rst_n,
   
   clk,
   rst_n,
   bimc_idat,
   bimc_isync,
  
  o_bimc_monitor_mask,
  o_bimc_ecc_uncorrectable_error_cnt,
  o_bimc_ecc_correctable_error_cnt,
  o_bimc_parity_error_cnt,
  o_bimc_global_config,
  o_bimc_eccpar_debug,
  o_bimc_cmd2,
  o_bimc_cmd1,
  o_bimc_cmd0,
  o_bimc_rxcmd2,
  o_bimc_rxrsp2,
  o_bimc_pollrsp2,
  o_bimc_dbgcmd2,


  i_bimc_monitor,
  i_bimc_ecc_uncorrectable_error_cnt,
  i_bimc_ecc_correctable_error_cnt,
  i_bimc_parity_error_cnt,
  i_bimc_global_config,
  i_bimc_memid,
  i_bimc_eccpar_debug,
  i_bimc_cmd2,
  i_bimc_rxcmd2,
  i_bimc_rxcmd1,
  i_bimc_rxcmd0,
  i_bimc_rxrsp2,
  i_bimc_rxrsp1,
  i_bimc_rxrsp0,
  i_bimc_pollrsp2,
  i_bimc_pollrsp1,
  i_bimc_pollrsp0,
  i_bimc_dbgcmd2,
  i_bimc_dbgcmd1,
  i_bimc_dbgcmd0
   );

parameter MSB= 71; 
parameter BIMC_FLENGTH= 72;














parameter NOP      =8'h00; 
parameter RD_REG   =8'h01; 
parameter WR_ID    =8'h02; 
parameter POLL_ERR =8'h03; 
parameter WR_ECTRL =8'h0A; 
parameter WR_ECCP  =8'h0B; 
parameter WR_ECCCNT=8'h0C; 
parameter WR_ECCIN =8'h10; 
parameter WR_ECCOUT=8'h11; 

parameter WR_TM    =8'd30;
parameter WR_LVM   =8'd31;
parameter WR_MLVM  =8'd32;
parameter WR_MRDTEN=8'd33;
parameter WR_RDT   =8'd34;
parameter WR_WBT   =8'd35;
parameter WR_WMS   =8'd36;
parameter MEM_INIT= 8'hFF; 


parameter RESET=         4'h0; 
parameter AUTOID=        4'hB; 
parameter CPU=           4'h1; 
parameter IDLE=          4'h2; 
parameter AUTOPOLL=      4'h7; 
parameter MEMWRINIT=     4'h8; 
parameter PICK_NXT=      4'h3; 
parameter ECCPAR_DEBUG=  4'h5; 

`ifdef AUTOS_SHOULD_BE_EMPTY
   
   
   
   
   
   
   
   
   
`endif
   reg                bimc_monitor_uncorrectable_ecc_error_din;
   reg                bimc_monitor_correctable_ecc_error_din;
   reg                bimc_monitor_parity_error_din;
   reg                bimc_monitor_bimc_chain_rcv_error_din;
   reg                bimc_monitor_rcv_invalid_opcode_din;
   reg                bimc_monitor_unanswered_read_din;

   reg                bimc_ecc_uncorrectable_error_cnt_uncorrectable_ecc_en;
   reg                bimc_ecc_correctable_error_cnt_correctable_ecc_en;
   reg                bimc_parity_error_cnt_parity_errors_en;
   reg                debug_write_en;
   reg [11:0]         number_of_memories;

   wire [1:0]         bimc_eccpar_debug_eccpar_corrupt;
   wire [1:0]         bimc_eccpar_debug_eccpar_disable;
   wire [3:0]         bimc_eccpar_debug_jabber_off;
   wire [11:0]        bimc_eccpar_debug_memaddr;
   wire [3:0]         bimc_eccpar_debug_memtype;
   reg                bimc_eccpar_debug_send;
   wire               bimc_eccpar_debug_write_notify_ev;
   reg [2:0]          r_bimc_eccpar_debug_write_notify_ev;
   reg                bimc_eccpar_debug_sent_din;
   reg                bimc_eccpar_debug_sent; 

   wire               bimc_global_config_poll_ecc_par_error;
   wire [25:0]        bimc_global_config_poll_ecc_par_timer;
   wire               bimc_global_config_mem_wr_init;

   wire [31:0]        bimc_cmd0_data;         
   wire [15:0]        bimc_cmd1_addr;         
   wire [11:0]        bimc_cmd1_mem;          
   wire [3:0]         bimc_cmd1_memtype;      
   wire [7:0]         bimc_cmd2_opcode;       
   reg                bimc_cmd2_send;         
   wire               bimc_cmd2_write_notify_ev;
   reg [2:0]          r_bimc_cmd2_write_notify_ev;
   reg                bimc_cmd2_sent_din;     

   reg                 bimc_rxrsp2_rxflag_din; 
   reg [31:0]         bimc_rxrsp0_data_din;   
   reg [31:0]         bimc_rxrsp1_data_din;   
   reg [7:0]          bimc_rxrsp2_data_din;   

   reg                 bimc_pollrsp2_rxflag_din; 
   reg [31:0]         bimc_pollrsp0_data_din;   
   reg [31:0]         bimc_pollrsp1_data_din;   
   reg [7:0]          bimc_pollrsp2_data_din;   

   reg         bimc_rxcmd2_rxflag_din; 
   reg [31:0] bimc_rxcmd0_data_din;   
   reg [15:0] bimc_rxcmd1_addr_din;   
   reg [11:0] bimc_rxcmd1_mem_din;    
   reg [3:0]  bimc_rxcmd1_memtype_din;
   reg [7:0]  bimc_rxcmd2_opcode_din; 

   reg         bimc_dbgcmd2_rxflag_din; 
   reg [31:0] bimc_dbgcmd0_data_din;   
   reg [15:0] bimc_dbgcmd1_addr_din;   
   reg [11:0] bimc_dbgcmd1_mem_din;    
   reg [3:0]  bimc_dbgcmd1_memtype_din;
   reg [7:0]  bimc_dbgcmd2_opcode_din; 

   
  
   

  input          clk; 
  input          rst_n;
   
  output bimc_ecc_error;
  output bimc_interrupt;
  
  input  bimc_idat;   
  
  input  bimc_isync;  
  output bimc_odat;   
  output bimc_rst_n;
  output bimc_osync;
  reg bimc_odat;
  reg bimc_rst_n;
  reg bimc_osync;

  input     [`CR_C_BIMC_MONITOR_MASK_T_DECL] o_bimc_monitor_mask;
  input     [`CR_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_uncorrectable_error_cnt;
  input     [`CR_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] o_bimc_ecc_correctable_error_cnt;
  input     [`CR_C_BIMC_PARITY_ERROR_CNT_T_DECL] o_bimc_parity_error_cnt;
  input     [`CR_C_BIMC_GLOBAL_CONFIG_T_DECL] o_bimc_global_config;
  input     [`CR_C_BIMC_ECCPAR_DEBUG_T_DECL] o_bimc_eccpar_debug;
  input     [`CR_C_BIMC_CMD2_T_DECL]  o_bimc_cmd2;
  input     [`CR_C_BIMC_CMD1_T_DECL]  o_bimc_cmd1;
  input     [`CR_C_BIMC_CMD0_T_DECL]  o_bimc_cmd0;
  input     [`CR_C_BIMC_RXCMD2_T_DECL] o_bimc_rxcmd2;
  input     [`CR_C_BIMC_RXRSP2_T_DECL] o_bimc_rxrsp2;
  input     [`CR_C_BIMC_POLLRSP2_T_DECL] o_bimc_pollrsp2;
  input     [`CR_C_BIMC_DBGCMD2_T_DECL] o_bimc_dbgcmd2;


  output      [`CR_C_BIMC_MONITOR_T_DECL] i_bimc_monitor;
  output      [`CR_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_uncorrectable_error_cnt;
  output      [`CR_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] i_bimc_ecc_correctable_error_cnt;
  output      [`CR_C_BIMC_PARITY_ERROR_CNT_T_DECL] i_bimc_parity_error_cnt;
  output      [`CR_C_BIMC_GLOBAL_CONFIG_T_DECL] i_bimc_global_config;
  output      [`CR_C_BIMC_MEMID_T_DECL] i_bimc_memid;
  output      [`CR_C_BIMC_ECCPAR_DEBUG_T_DECL] i_bimc_eccpar_debug;
  output      [`CR_C_BIMC_CMD2_T_DECL]  i_bimc_cmd2;
  reg 		bimc_cmd2_sent;
  output      [`CR_C_BIMC_RXCMD2_T_DECL] i_bimc_rxcmd2;
  output      [`CR_C_BIMC_RXCMD1_T_DECL] i_bimc_rxcmd1;
  output      [`CR_C_BIMC_RXCMD0_T_DECL] i_bimc_rxcmd0;
  output      [`CR_C_BIMC_RXRSP2_T_DECL] i_bimc_rxrsp2;
  output      [`CR_C_BIMC_RXRSP1_T_DECL] i_bimc_rxrsp1;
  output      [`CR_C_BIMC_RXRSP0_T_DECL] i_bimc_rxrsp0;
  output      [`CR_C_BIMC_POLLRSP2_T_DECL] i_bimc_pollrsp2;
  output      [`CR_C_BIMC_POLLRSP1_T_DECL] i_bimc_pollrsp1;
  output      [`CR_C_BIMC_POLLRSP0_T_DECL] i_bimc_pollrsp0;
  output      [`CR_C_BIMC_DBGCMD2_T_DECL] i_bimc_dbgcmd2;
  output      [`CR_C_BIMC_DBGCMD1_T_DECL] i_bimc_dbgcmd1;
  output      [`CR_C_BIMC_DBGCMD0_T_DECL] i_bimc_dbgcmd0;

  reg      [`CR_C_BIMC_ECC_UNCORRECTABLE_ERROR_CNT_T_DECL] bimc_ecc_uncorrectable_error_cnt;
  reg      [`CR_C_BIMC_ECC_CORRECTABLE_ERROR_CNT_T_DECL] bimc_ecc_correctable_error_cnt;
  reg      [`CR_C_BIMC_PARITY_ERROR_CNT_T_DECL] bimc_parity_error_cnt;

  reg                bimc_ecc_error;
  wire               bimc_ecc_error_c;
  reg                bimc_interrupt;
  wire               bimc_interrupt_c;
  wire               bimc_global_config_soft_reset;


reg [ MSB:0] bimc_rdat;



reg [ MSB:0] bimc_dat;
reg          bimc_frm;  
reg          bimc_chk;  


reg [3:0]  rx_type; 
reg [7:0]  rx_op  ; 
reg [11:0] rx_mem ; 
reg [15:0] rx_addr; 
reg [31:0] rx_dat ; 
reg          rx_resp;
reg          rx_frm ;
reg [1:0]    rx_chk ;

wire  [ MSB:0]     rcv_dat;                
wire               rcv_resp;               
wire               rcv_frm;                
wire               rcv_chk;                


wire [3:0]  bm_type = bimc_dat[71:68];
wire [7:0]  bm_op   = bimc_dat[67:60];
wire [11:0] bm_mem  = bimc_dat[59:48];
wire [15:0] bm_addr = bimc_dat[47:32];
wire [31:0] bm_dat  = bimc_dat[31:0]; 
reg         bm_resp; 
reg [6:0]   bm_cnt;  


always @(posedge clk or negedge rst_n)
  begin
  if (!rst_n)
    begin
    
    bimc_rdat  <= 71'h0; 
    bimc_dat <= 71'h0;
    bm_resp    <= 1'b0; 
    bimc_frm <= 1'b0;
    bimc_chk <= 1'b0;
    bm_cnt <= 7'h7C;  
    end
  else
    begin
    
    bimc_rdat  <= {bimc_rdat[ ( MSB - 1):0], bimc_idat  };
    bimc_dat <= (bimc_isync)? bimc_rdat[ MSB:0] : bimc_dat;
    bm_resp  <= (bimc_isync)? bimc_idat : bm_resp; 
    
    bimc_frm <= (bimc_isync)? (bm_cnt==( MSB+1)) : bimc_frm; 
    bimc_chk <= (bimc_isync)? ~bimc_chk : bimc_chk;                 
    bm_cnt <= (bimc_isync)? 7'd0 : ((bm_cnt==7'h7F)? 7'h7F:bm_cnt+7'd1); 
    end
  end

  

   assign rcv_chk   = bimc_chk;
   assign rcv_frm   = bimc_frm;
   assign rcv_resp  = bm_resp;
   assign rcv_dat   = bimc_dat;
   

wire new_frame = (rx_chk==2'b10||rx_chk==2'b01); 

reg [3:0] rstate, nxt_rstate;
reg [3:0] tstate, nxt_tstate;


reg bimc_global_config_bimc_mem_init_done_din;


parameter COMMAND=       4'h1; 
parameter CMD_DONE=      4'h0; 
parameter RESPONSE_CMD=  4'h3; 
parameter RESPONSE_IDLE= 4'h4; 
parameter RESPONSE_MEM=  4'h5; 
parameter RSP_DONE=      4'h6; 

parameter  POLL_ERR_CMD  = 4'h7; 
parameter  POLL_ERR_IDLE = 4'h8; 
parameter  POLL_ERR_MEM  = 4'h9; 
parameter  POLL_ERR_DONE = 4'hA; 

wire [ (13 * 8) - 1 : 0] rstate_text;
assign rstate_text = (rstate==IDLE         )? "         idle" : 
                     (rstate==COMMAND      )? "      COMMAND" :
                     (rstate==CMD_DONE     )? "     CMD_DONE" :
                     (rstate==RESPONSE_CMD )? " RESPONSE_CMD" :
                     (rstate==RESPONSE_IDLE)? "RESPONSE_IDLE" :
                     (rstate==RESPONSE_MEM )? " RESPONSE_MEM" :
                     (rstate==RSP_DONE     )? "     RSP_DONE" :
                     (rstate==POLL_ERR_CMD )? " POLL_ERR_CMD" :
                     (rstate==POLL_ERR_IDLE)? "POLL_ERR_IDLE" :
                     (rstate==POLL_ERR_MEM )? " POLL_ERR_MEM" :
                     (rstate==POLL_ERR_DONE)? "POLL_ERR_DONE" : "      unknown" ;


always @(posedge clk or negedge rst_n)
  begin
  if (!rst_n)
    begin
    rx_type <= 4'h0;
    rx_op   <= 8'h0;
    rx_mem  <= 12'h0;
    rx_addr <= 16'h0;
    rx_dat  <= 32'h0;
    rx_resp <= 1'h0; 
    rx_frm  <= 1'b0; 
    rx_chk  <= 2'b0; 
    rstate  <= IDLE; 
    number_of_memories <= 12'h0;
    bimc_global_config_bimc_mem_init_done_din <= 1'b0;

    bimc_dbgcmd2_rxflag_din <= 1'b0; 
    bimc_dbgcmd2_opcode_din <= 8'h0 ;
    bimc_dbgcmd1_memtype_din<= 4'h0 ;
    bimc_dbgcmd1_mem_din    <= 12'h0;
    bimc_dbgcmd1_addr_din   <= 16'h0;
    bimc_dbgcmd0_data_din   <= 32'h0;

    bimc_rxcmd2_rxflag_din <= 1'b0; 
    bimc_rxcmd2_opcode_din <= 8'h0 ;
    bimc_rxcmd1_memtype_din<= 4'h0 ;
    bimc_rxcmd1_mem_din    <= 12'h0;
    bimc_rxcmd1_addr_din   <= 16'h0;
    bimc_rxcmd0_data_din   <= 32'h0;

    bimc_rxrsp2_rxflag_din <= 1'b0; 
    bimc_rxrsp0_data_din <= 32'h0  ;   
    bimc_rxrsp1_data_din <= 32'h0  ;   
    bimc_rxrsp2_data_din <=  8'h0  ;   

    bimc_pollrsp2_rxflag_din <= 1'b0; 
    bimc_pollrsp0_data_din <= 32'h0  ;   
    bimc_pollrsp1_data_din <= 32'h0  ;   
    bimc_pollrsp2_data_din <=  8'h0  ;   

    bimc_monitor_bimc_chain_rcv_error_din   <= 1'b0;
    bimc_monitor_correctable_ecc_error_din  <= 1'b0;
    bimc_monitor_parity_error_din           <= 1'b0;
    bimc_monitor_uncorrectable_ecc_error_din<= 1'b0;
    bimc_monitor_rcv_invalid_opcode_din <= 1'b0;
    bimc_monitor_unanswered_read_din <= 1'b0;

    bimc_ecc_uncorrectable_error_cnt_uncorrectable_ecc_en <= 1'b0;
    bimc_ecc_correctable_error_cnt_correctable_ecc_en <= 1'b0;  
    bimc_parity_error_cnt_parity_errors_en <= 1'b0;    
    end
  else
    begin
    rx_type <= rcv_dat[71:68];
    rx_op   <= rcv_dat[67:60];
    rx_mem  <= rcv_dat[59:48];
    rx_addr <= rcv_dat[47:32];
    rx_dat  <= rcv_dat[31:0]; 
    rx_resp <= rcv_resp;
    rx_frm  <= rcv_frm;
    rx_chk  <= {rx_chk[0],rcv_chk};
    rstate  <= nxt_rstate;
    number_of_memories <= ((rstate==COMMAND) && ({rx_type,rx_op,rx_mem,rx_addr}=={4'hF,WR_ID,12'hFFF,16'h1}))? rx_dat[11:0]-1 : number_of_memories;
    bimc_global_config_bimc_mem_init_done_din <= (tstate== RESET)? 1'b0:((rstate==COMMAND && rx_op==WR_ID && rx_addr==16'h1)?1'b1:bimc_global_config_bimc_mem_init_done_din);

    
    bimc_dbgcmd2_rxflag_din <= (o_bimc_dbgcmd2[09:09]==1)?1'b0:(rstate== CMD_DONE && (rx_op!=NOP))? 1'b1: bimc_dbgcmd2_rxflag_din; 
    bimc_dbgcmd2_opcode_din <= ((rstate==COMMAND) && (rx_op!=NOP) && !bimc_dbgcmd2_rxflag_din)? rx_op[7:0]   : bimc_dbgcmd2_opcode_din ;
    bimc_dbgcmd1_memtype_din<= ((rstate==COMMAND) && (rx_op!=NOP) && !bimc_dbgcmd2_rxflag_din)? rx_type[3:0] : bimc_dbgcmd1_memtype_din;
    bimc_dbgcmd1_mem_din    <= ((rstate==COMMAND) && (rx_op!=NOP) && !bimc_dbgcmd2_rxflag_din)? rx_mem[11:0] : bimc_dbgcmd1_mem_din    ;
    bimc_dbgcmd1_addr_din   <= ((rstate==COMMAND) && (rx_op!=NOP) && !bimc_dbgcmd2_rxflag_din)? rx_addr[15:0]: bimc_dbgcmd1_addr_din   ;
    bimc_dbgcmd0_data_din   <= ((rstate==COMMAND) && (rx_op!=NOP) && !bimc_dbgcmd2_rxflag_din)? rx_dat[31:0] : bimc_dbgcmd0_data_din   ;

    
    bimc_rxcmd2_rxflag_din <= (o_bimc_rxcmd2[09:09]==1)?1'b0:(rstate==RESPONSE_IDLE)? 1'b1: bimc_rxcmd2_rxflag_din;
    bimc_rxcmd2_opcode_din  <= (rstate==RESPONSE_CMD && !bimc_rxcmd2_rxflag_din)? rx_op[7:0]   : bimc_rxcmd2_opcode_din ;
    bimc_rxcmd1_memtype_din <= (rstate==RESPONSE_CMD && !bimc_rxcmd2_rxflag_din)? rx_type[3:0] : bimc_rxcmd1_memtype_din;
    bimc_rxcmd1_mem_din     <= (rstate==RESPONSE_CMD && !bimc_rxcmd2_rxflag_din)? rx_mem[11:0] : bimc_rxcmd1_mem_din    ;
    bimc_rxcmd1_addr_din    <= (rstate==RESPONSE_CMD && !bimc_rxcmd2_rxflag_din)? rx_addr[15:0]: bimc_rxcmd1_addr_din   ;
    bimc_rxcmd0_data_din    <= (rstate==RESPONSE_CMD && !bimc_rxcmd2_rxflag_din)? rx_dat[31:0] : bimc_rxcmd0_data_din   ;

    
    bimc_rxrsp2_rxflag_din <= (o_bimc_rxrsp2[09:09]==1)?1'b0:(rstate==RSP_DONE && (rx_op!=NOP))? 1'b1: bimc_rxrsp2_rxflag_din;
    bimc_rxrsp2_data_din <= (rstate==RESPONSE_MEM && (rx_op!=NOP) && !bimc_rxrsp2_rxflag_din)? rx_op[7:0]   : bimc_rxrsp2_data_din;
    bimc_rxrsp1_data_din <= (rstate==RESPONSE_MEM && (rx_op!=NOP) && !bimc_rxrsp2_rxflag_din)? {rx_type[3:0],rx_mem[11:0],rx_addr[15:0]} : bimc_rxrsp1_data_din;
    bimc_rxrsp0_data_din <= (rstate==RESPONSE_MEM && (rx_op!=NOP) && !bimc_rxrsp2_rxflag_din)? rx_dat[31:0] : bimc_rxrsp0_data_din;
    bimc_monitor_bimc_chain_rcv_error_din   <= (o_bimc_monitor_mask[04:04]==1)?1'b0:((rstate==RESPONSE_IDLE || rstate==POLL_ERR_IDLE || rstate==IDLE) && !rx_frm && new_frame)?1'b1:bimc_monitor_bimc_chain_rcv_error_din;

    
    bimc_pollrsp2_rxflag_din <= (o_bimc_pollrsp2[09:09]==1)?1'b0:(rstate==POLL_ERR_DONE && (rx_op!=NOP))? 1'b1: bimc_pollrsp2_rxflag_din;
    bimc_pollrsp2_data_din <= (rstate==POLL_ERR_MEM && (rx_op!=NOP) && !bimc_pollrsp2_rxflag_din)? rx_op[7:0] : bimc_pollrsp2_data_din;
    bimc_pollrsp1_data_din <= (rstate==POLL_ERR_MEM && (rx_op!=NOP) && !bimc_pollrsp2_rxflag_din)? {rx_type[3:0],rx_mem[11:0],rx_addr[15:0]} : bimc_pollrsp1_data_din;
    bimc_pollrsp0_data_din <= (rstate==POLL_ERR_MEM && (rx_op!=NOP) && !bimc_pollrsp2_rxflag_din)? rx_dat[31:0]   : bimc_pollrsp0_data_din;

    
    bimc_monitor_correctable_ecc_error_din  <= (o_bimc_monitor_mask[01:01])?1'b0:((rstate==POLL_ERR_MEM)&& (rx_op==POLL_ERR)&&(rx_addr==16'hECC) &&(rx_dat[1:0]==2'b11))?1'b1:bimc_monitor_correctable_ecc_error_din;
    bimc_monitor_parity_error_din           <= (o_bimc_monitor_mask[02:02])?1'b0:((rstate==POLL_ERR_MEM)&& (rx_op==POLL_ERR)&&(rx_addr==16'h9A4) &&(rx_dat!=32'h0))?1'b1:bimc_monitor_parity_error_din;
    bimc_monitor_uncorrectable_ecc_error_din<= (o_bimc_monitor_mask[00:00])?1'b0:((rstate==POLL_ERR_MEM)&& (rx_op==POLL_ERR)&&(rx_addr==16'hECC) &&((rx_dat[2]&rx_dat[0])==1'h1))?1'b1:bimc_monitor_uncorrectable_ecc_error_din;

    bimc_monitor_rcv_invalid_opcode_din <= (o_bimc_monitor_mask[05:05])?1'b0:(((rstate==RESPONSE_CMD)&& (rx_op!=RD_REG))||((rstate==POLL_ERR_CMD)&& (rx_op!=POLL_ERR)))?1'b1:bimc_monitor_rcv_invalid_opcode_din;
    bimc_monitor_unanswered_read_din <= (o_bimc_monitor_mask[06:06])?1'b0:((rstate==COMMAND)&&(rx_op==RD_REG))?1'b1:bimc_monitor_unanswered_read_din;

    
    bimc_ecc_uncorrectable_error_cnt_uncorrectable_ecc_en <= (rstate==POLL_ERR_MEM)&& (rx_op==POLL_ERR)&&(rx_addr==16'hECC) &&((rx_dat[2]&rx_dat[0])==1'h1);
    bimc_ecc_correctable_error_cnt_correctable_ecc_en   <= (rstate==POLL_ERR_MEM)&& (rx_op==POLL_ERR)&&(rx_addr==16'hECC) &&(rx_dat[1:0]==2'b11);
    bimc_parity_error_cnt_parity_errors_en     <= (rstate==POLL_ERR_MEM)&& (rx_op==POLL_ERR)&&(rx_addr==16'h9A4) &&(rx_dat!=32'h0);
    end
  end



always @*
  begin
      case (rstate)
       IDLE : if (rx_frm && !rx_resp && new_frame) begin 
          nxt_rstate <=  COMMAND;
          end else if (rx_frm && rx_resp && new_frame && rx_op!= POLL_ERR) begin 
          nxt_rstate <=  RESPONSE_CMD;
          end else if (rx_frm && rx_resp && new_frame && rx_op== POLL_ERR) begin 
          nxt_rstate <=  POLL_ERR_CMD;
          end else if (!rx_frm && new_frame) begin 
          nxt_rstate <=  IDLE;
          
          end else begin
          nxt_rstate <= rstate;
          end
       COMMAND : if (rx_op== RD_REG) begin 
            nxt_rstate <=  CMD_DONE;
          end else if (rx_op== POLL_ERR) begin 
            nxt_rstate <=  CMD_DONE;
          end else begin
            nxt_rstate <=  CMD_DONE; 
          end
       CMD_DONE : begin
          nxt_rstate <=  IDLE;
          end

       RESPONSE_CMD: if (rx_op== RD_REG) begin 
          nxt_rstate <=  RESPONSE_IDLE;
          end else if (rx_op== POLL_ERR) begin 
          nxt_rstate <=  RESPONSE_IDLE;
          end else begin 
          
          nxt_rstate <=  CMD_DONE;
          end
       RESPONSE_IDLE : if (rx_frm && rx_resp && (rx_chk==2'b10||rx_chk==2'b01)) begin
          nxt_rstate <=  RESPONSE_MEM;
          end else if (rx_frm && !rx_resp && (rx_chk==2'b10||rx_chk==2'b01)) begin
          nxt_rstate <=  RSP_DONE; 
          end else if (!rx_frm && (rx_chk==2'b10||rx_chk==2'b01)) begin
          nxt_rstate <=  RSP_DONE; 
          end else begin 
          nxt_rstate <= rstate;
          end
       RESPONSE_MEM : begin 
          nxt_rstate <=  RSP_DONE;
          end
       RSP_DONE : begin
          nxt_rstate <=  IDLE;
          end

       POLL_ERR_CMD: if (rx_op== POLL_ERR) begin 
          nxt_rstate <=  POLL_ERR_IDLE;
          end else begin 
          
          nxt_rstate <=  CMD_DONE;
          end
       POLL_ERR_IDLE : if (rx_frm && rx_resp && (rx_chk==2'b10||rx_chk==2'b01)) begin
          nxt_rstate <=  POLL_ERR_MEM;
          end else if (rx_frm && !rx_resp && (rx_chk==2'b10||rx_chk==2'b01)) begin
          nxt_rstate <=  POLL_ERR_DONE; 
          end else if (!rx_frm && (rx_chk==2'b10||rx_chk==2'b01)) begin
          nxt_rstate <=  POLL_ERR_DONE; 
          end else begin 
          nxt_rstate <= rstate;
          end
       POLL_ERR_MEM : begin 
          nxt_rstate <=  POLL_ERR_DONE;
          end
       POLL_ERR_DONE : begin
          nxt_rstate <=  IDLE;
          end
      default : begin
          nxt_rstate <= IDLE; 
          end
    endcase
  end




reg [6:0] sync_cnt;
reg cmd_cnt;
reg mem_wr_init_dly, mem_wr_init_ev ; 
reg                  eccpar_debug_ev; 
reg                  cpu_transmit_ev; 

reg [ BIMC_FLENGTH:0] reg_send, r_reg_send; 

reg [3:0]  cputx_type;
reg [7:0]  cputx_op  ;
reg [11:0] cputx_mem ;
reg [15:0] cputx_addr;
reg [31:0] cputx_dat ;

reg auto_poll_ecc_par_ev;
reg [25:0] poll_ecc_par_timer;


always @(posedge clk or negedge rst_n)
  begin
  if (!rst_n)
    begin
    bimc_ecc_error <= 1'b0;
    bimc_interrupt <= 1'b0;
    bimc_rst_n <= 1'b0;
    bimc_osync <= 1'b0;
    bimc_odat  <= 1'b0;
    r_reg_send <= 73'h0;
    tstate   <=  RESET; 
    sync_cnt <= 7'h1; 
                      
    cmd_cnt <= 1'b1;
    auto_poll_ecc_par_ev <= 1'b0;
    poll_ecc_par_timer<= 26'h0;
    mem_wr_init_dly <= 1'b0;
    mem_wr_init_ev <= 1'b0;

    r_bimc_eccpar_debug_write_notify_ev <= 3'b0;
    eccpar_debug_ev <= 1'b0;
    bimc_eccpar_debug_sent_din <= 1'b0;

    bimc_cmd2_send <= 1'b0;
    bimc_eccpar_debug_send <= 1'b0;
    r_bimc_cmd2_write_notify_ev <= 3'h0;
    cpu_transmit_ev <= 1'b0;
    bimc_cmd2_sent_din <= 1'b0;
    cputx_type <= 4'h0;
    cputx_op   <= 8'h0;
    cputx_mem  <= 12'h0;
    cputx_addr <= 16'h0;
    cputx_dat  <= 32'h0;
    end
  else
    begin
    bimc_ecc_error <= bimc_ecc_error_c;
    bimc_interrupt <= bimc_interrupt_c;
    bimc_rst_n <= !bimc_global_config_soft_reset;
    bimc_osync <= (sync_cnt== BIMC_FLENGTH)? 1'b1 : 1'b0; 
    bimc_odat  <= reg_send[sync_cnt]; 
    r_reg_send <= reg_send;
    tstate <= nxt_tstate;
    sync_cnt <= (sync_cnt == 7'h0)?  BIMC_FLENGTH : sync_cnt - 7'h1; 
    cmd_cnt <= (sync_cnt == 7'h0)?  ~cmd_cnt : cmd_cnt; 

    auto_poll_ecc_par_ev <= (poll_ecc_par_timer==26'h2)? 1'b1 : (tstate== AUTOPOLL)? 1'b0 : auto_poll_ecc_par_ev;
    poll_ecc_par_timer<= ((poll_ecc_par_timer == bimc_global_config_poll_ecc_par_timer) || !bimc_global_config_poll_ecc_par_error)? 26'h0 : poll_ecc_par_timer + 26'h1;

    mem_wr_init_dly <= bimc_global_config_mem_wr_init; 
    mem_wr_init_ev <= (!mem_wr_init_dly && bimc_global_config_mem_wr_init)? 1'b1 : ((sync_cnt==7'h1 && tstate== MEMWRINIT)? 1'b0 : mem_wr_init_ev);

    r_bimc_eccpar_debug_write_notify_ev <= {r_bimc_eccpar_debug_write_notify_ev[1:0],bimc_eccpar_debug_write_notify_ev};
    eccpar_debug_ev <= (r_bimc_eccpar_debug_write_notify_ev[2] && bimc_eccpar_debug_send)? 1'b1 : ((sync_cnt==7'h1 && tstate== ECCPAR_DEBUG)? 1'b0 : eccpar_debug_ev);
    bimc_eccpar_debug_sent_din <= (sync_cnt==7'h1 && tstate== ECCPAR_DEBUG)? 1'b1 : 1'b0; 
    bimc_eccpar_debug_send <= o_bimc_eccpar_debug[22:22]; 

    bimc_cmd2_send            <= o_bimc_cmd2[08:08]; 
    r_bimc_cmd2_write_notify_ev <= {r_bimc_cmd2_write_notify_ev[1:0],bimc_cmd2_write_notify_ev};
    cpu_transmit_ev <= (r_bimc_cmd2_write_notify_ev[2] && bimc_cmd2_send)? 1'b1 : ((sync_cnt==7'h1 && tstate== CPU)? 1'b0 : cpu_transmit_ev);
    bimc_cmd2_sent_din <= (sync_cnt==7'h1 && tstate== CPU)? 1'b1 : 1'b0; 
    cputx_op   <= (r_bimc_cmd2_write_notify_ev[2] && bimc_cmd2_send)? bimc_cmd2_opcode : cputx_op  ;
    cputx_type <= (r_bimc_cmd2_write_notify_ev[2] && bimc_cmd2_send)? bimc_cmd1_memtype: cputx_type;
    cputx_mem  <= (r_bimc_cmd2_write_notify_ev[2] && bimc_cmd2_send)? bimc_cmd1_mem    : cputx_mem ;
    cputx_addr <= (r_bimc_cmd2_write_notify_ev[2] && bimc_cmd2_send)? bimc_cmd1_addr   : cputx_addr;
    cputx_dat  <= (r_bimc_cmd2_write_notify_ev[2] && bimc_cmd2_send)? bimc_cmd0_data   : cputx_dat ;
    end
  end

wire [ BIMC_FLENGTH:0] cputx_frame = {1'b0,cputx_type[3:0],cputx_op[7:0],cputx_mem[11:0],cputx_addr[15:0],cputx_dat [31:0]};

wire [ (12 * 8) - 1 : 0] tstate_text;
assign tstate_text = (tstate==RESET       )? "       RESET" : 
                     (tstate==AUTOID      )? "      AUTOID" :
                     (tstate==CPU         )? "         CPU" :
                     (tstate==IDLE        )? "        idle" :
                     (tstate==AUTOPOLL    )? "    AUTOPOLL" :
                     (tstate==MEMWRINIT   )? "   MEMWRINIT" :
                     (tstate==PICK_NXT    )? "    PICK_NXT" :
                     (tstate==ECCPAR_DEBUG)? "ECCPAR_DEBUG" : "     unknown" ;
always @*
  begin
      case (tstate)
       RESET : if (bimc_rst_n && (sync_cnt== BIMC_FLENGTH)) begin
          reg_send = {4'h0,     NOP  ,        12'h000,   16'h0,      32'h0,    1'b0};
          nxt_tstate =  AUTOID;
          end else begin
          reg_send = {4'h0,     NOP  ,        12'h000,   16'h0,      32'h0,    1'b0};
          nxt_tstate = tstate;
          end
       AUTOID : if (sync_cnt==7'h1) begin
          reg_send = r_reg_send;
          nxt_tstate =  PICK_NXT;
          end else begin
          
          reg_send = {1'b0, 4'hF,     WR_ID,        12'hFFF,   16'h1,      32'h1};
          nxt_tstate = tstate;
          end
       PICK_NXT : 
          if (sync_cnt==7'h0 && cmd_cnt==1'b1) begin
            reg_send = r_reg_send;
            if (!bimc_rst_n) begin 
              nxt_tstate =  RESET;
            end else if ( cpu_transmit_ev ) begin
              nxt_tstate =  CPU;
            end else if ( auto_poll_ecc_par_ev) begin
              nxt_tstate =  AUTOPOLL;
            end else if (mem_wr_init_ev) begin
              nxt_tstate =  MEMWRINIT;
            end else if (eccpar_debug_ev) begin
              nxt_tstate =  ECCPAR_DEBUG;
            end else begin
              nxt_tstate = IDLE;
            end

          end else begin
            
            reg_send = r_reg_send;
            nxt_tstate = IDLE;
          end
       CPU  : if (sync_cnt==7'h1) begin
          reg_send = r_reg_send;
          nxt_tstate =  PICK_NXT;
          end else begin
          reg_send = cputx_frame;
          nxt_tstate = tstate;
          end
       IDLE : if (sync_cnt==7'h1) begin
          reg_send = r_reg_send;
          nxt_tstate =  PICK_NXT;
          end else begin
          
          reg_send = {1'b0, 4'h0,      NOP ,        12'h000,   16'h0,      32'h0};
          nxt_tstate = tstate;
          end
       AUTOPOLL : if (sync_cnt==7'h1) begin
          reg_send = r_reg_send;
          nxt_tstate =  PICK_NXT;
          end else begin
          
          reg_send = {1'b0, 4'hF, POLL_ERR ,        12'hFFF,   16'hFFFF,      32'h0};
          nxt_tstate = tstate;
          end
       MEMWRINIT : if (sync_cnt==7'h1) begin
          reg_send = r_reg_send;
          nxt_tstate =  PICK_NXT;
          end else begin
          
          reg_send = {1'b0, 4'hF,     MEM_INIT,        12'hFFF,   16'h8,      32'h1};
          nxt_tstate = tstate;
          end
       ECCPAR_DEBUG : if (sync_cnt==7'h1) begin
          reg_send = r_reg_send;
          nxt_tstate =  PICK_NXT;
          end else begin
          
	  if (bimc_eccpar_debug_memtype == 'hf) begin
          reg_send = {1'b0, bimc_eccpar_debug_memtype, WR_ID, 16'd0, bimc_eccpar_debug_memaddr, 
                      {4'h0,bimc_eccpar_debug_jabber_off[3:0],20'h0,bimc_eccpar_debug_eccpar_corrupt[1:0],bimc_eccpar_debug_eccpar_disable[1:0]}
	             };
	  end
	  else begin
          reg_send = {1'b0, bimc_eccpar_debug_memtype, WR_ID,bimc_eccpar_debug_memaddr,   16'd10, 
                      {4'h0,bimc_eccpar_debug_jabber_off[3:0],20'h0,bimc_eccpar_debug_eccpar_corrupt[1:0],bimc_eccpar_debug_eccpar_disable[1:0]}
	             };
          end
          nxt_tstate = tstate;
          end
      default: begin
          reg_send = r_reg_send;
          nxt_tstate = tstate; 
          end
    endcase
  end



  
  assign bimc_cmd0_data[31:0] = o_bimc_cmd0[31:00]; 
  assign bimc_cmd1_addr[15:0]   = o_bimc_cmd1[15:00]; 
  assign bimc_cmd1_mem[11:0]    = o_bimc_cmd1[27:16]; 
  assign bimc_cmd1_memtype[3:0] = o_bimc_cmd1[31:28]; 
  assign bimc_cmd2_opcode[7:0]     = o_bimc_cmd2[07:00]; 
  
  assign bimc_cmd2_write_notify_ev = o_bimc_cmd2[08:08] && !bimc_cmd2_send ; 
  assign bimc_eccpar_debug_eccpar_corrupt[1:0] = o_bimc_eccpar_debug[17:16]; 
  assign bimc_eccpar_debug_eccpar_disable[1:0] = o_bimc_eccpar_debug[21:20]; 
  assign bimc_eccpar_debug_jabber_off[3:0]     = o_bimc_eccpar_debug[27:24]; 
  assign bimc_eccpar_debug_memaddr[11:0]       = o_bimc_eccpar_debug[11:00]; 
  assign bimc_eccpar_debug_memtype[3:0]        = o_bimc_eccpar_debug[15:12]; 
  
  assign bimc_eccpar_debug_write_notify_ev     = o_bimc_eccpar_debug[22] && !bimc_eccpar_debug_send; 
  assign bimc_global_config_mem_wr_init              = o_bimc_global_config[03:03]; 
  assign bimc_global_config_poll_ecc_par_error       = o_bimc_global_config[04:04]; 
  assign bimc_global_config_poll_ecc_par_timer[25:0] = o_bimc_global_config[31:06]; 
  assign bimc_global_config_soft_reset               = o_bimc_global_config[00:00]; 

  
  assign bimc_ecc_error_c = (bimc_monitor_uncorrectable_ecc_error_din||bimc_monitor_correctable_ecc_error_din||bimc_monitor_parity_error_din); 
  
  assign bimc_interrupt_c = |i_bimc_monitor;

  assign debug_write_en = o_bimc_global_config[05:05]; 
      
  assign i_bimc_global_config[01:00] = o_bimc_global_config[01:00];
  assign i_bimc_global_config[02:02]= bimc_global_config_bimc_mem_init_done_din; 
  assign i_bimc_global_config[04:03] = o_bimc_global_config[04:03];
  assign i_bimc_global_config[05:05] = debug_write_en; 
  assign i_bimc_global_config[31:06] = o_bimc_global_config[31:06];
  assign i_bimc_cmd2[09:09] = bimc_cmd2_sent; 
  assign i_bimc_cmd2[07:00] = o_bimc_cmd2[07:00]; 
  assign i_bimc_cmd2[08:08] = o_bimc_cmd2[08:08]; 
  assign i_bimc_cmd2[10:10] = o_bimc_cmd2[10:10]; 
  assign i_bimc_eccpar_debug[22:0 ] = o_bimc_eccpar_debug[22:0]; 
  assign i_bimc_eccpar_debug[23:23] = bimc_eccpar_debug_sent; 
  assign i_bimc_eccpar_debug[28:24] = o_bimc_eccpar_debug[28:24]; 
  assign i_bimc_monitor[00:00]= bimc_monitor_uncorrectable_ecc_error_din; 
  assign i_bimc_monitor[01:01]= bimc_monitor_correctable_ecc_error_din  ; 
  assign i_bimc_monitor[02:02]= bimc_monitor_parity_error_din           ; 
  assign i_bimc_monitor[04:04]= bimc_monitor_bimc_chain_rcv_error_din   ; 
  assign i_bimc_monitor[05:05]= bimc_monitor_rcv_invalid_opcode_din     ; 
  assign i_bimc_monitor[06:06]= bimc_monitor_unanswered_read_din        ; 
  assign i_bimc_monitor[03:03]= 1'b0; 

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n)
  begin
    bimc_cmd2_sent <= 1'b0;
    bimc_eccpar_debug_sent <= 1'b0;
    bimc_ecc_uncorrectable_error_cnt <= 32'b0;
    bimc_ecc_correctable_error_cnt <= 32'b0;
    bimc_parity_error_cnt <= 32'b0;
  end
  else begin
    bimc_cmd2_sent <= (o_bimc_cmd2[10:10])?1'b0:(bimc_cmd2_sent_din==1)?1'b1:i_bimc_cmd2[09:09];
    bimc_eccpar_debug_sent <= (o_bimc_eccpar_debug[28:28]==1)?1'b0:(bimc_eccpar_debug_sent_din==1)?1'b1:i_bimc_eccpar_debug[23:23];
    bimc_ecc_uncorrectable_error_cnt <= (o_bimc_monitor_mask[0])?32'h0:(debug_write_en)? o_bimc_ecc_uncorrectable_error_cnt:(i_bimc_ecc_uncorrectable_error_cnt==32'hFFFFFFFF)?32'hFFFFFFFF:(i_bimc_ecc_uncorrectable_error_cnt[31:0] + {31'h0,bimc_ecc_uncorrectable_error_cnt_uncorrectable_ecc_en}); 
  
    bimc_ecc_correctable_error_cnt <= (o_bimc_monitor_mask[01:01])?32'h0:(debug_write_en)? o_bimc_ecc_correctable_error_cnt:(i_bimc_ecc_uncorrectable_error_cnt==32'hFFFFFFFF)?32'hFFFFFFFF:i_bimc_ecc_correctable_error_cnt + {31'h0,bimc_ecc_correctable_error_cnt_correctable_ecc_en}; 
  
    bimc_parity_error_cnt <= (o_bimc_monitor_mask[02:02])?32'h0:(debug_write_en)? o_bimc_parity_error_cnt:(i_bimc_parity_error_cnt==32'hFFFFFFFF)?32'hFFFFFFFF:i_bimc_parity_error_cnt + {31'h0,bimc_parity_error_cnt_parity_errors_en}; 
  end
end

  assign i_bimc_ecc_uncorrectable_error_cnt[31:00] = bimc_ecc_uncorrectable_error_cnt;
  assign i_bimc_ecc_correctable_error_cnt[31:00]   = bimc_ecc_correctable_error_cnt;
  assign i_bimc_parity_error_cnt[31:00]            = bimc_parity_error_cnt;
  assign i_bimc_memid[11:00]= number_of_memories[11:0];    

  assign i_bimc_rxcmd0[31:00]= bimc_rxcmd0_data_din[31:0];   
  assign i_bimc_rxcmd1[15:00]= bimc_rxcmd1_addr_din[15:0];   
  assign i_bimc_rxcmd1[27:16]= bimc_rxcmd1_mem_din[11:0];    
  assign i_bimc_rxcmd1[31:28]= bimc_rxcmd1_memtype_din[3:0]; 
  assign i_bimc_rxcmd2[07:00]= bimc_rxcmd2_opcode_din[7:0];  
  assign i_bimc_rxcmd2[08:08]= bimc_rxcmd2_rxflag_din;       
  assign i_bimc_rxcmd2[09:09]= o_bimc_rxcmd2[09:09];

  assign i_bimc_dbgcmd0[31:00]= bimc_dbgcmd0_data_din[31:0];  
  assign i_bimc_dbgcmd1[15:00]= bimc_dbgcmd1_addr_din[15:0];  
  assign i_bimc_dbgcmd1[27:16]= bimc_dbgcmd1_mem_din[11:0];   
  assign i_bimc_dbgcmd1[31:28]= bimc_dbgcmd1_memtype_din[3:0];
  assign i_bimc_dbgcmd2[07:00]= bimc_dbgcmd2_opcode_din[7:0]; 
  assign i_bimc_dbgcmd2[08:08]= bimc_dbgcmd2_rxflag_din;      
  assign i_bimc_dbgcmd2[09:09]= o_bimc_dbgcmd2[09:09];

  assign i_bimc_rxrsp0[31:00]= bimc_rxrsp0_data_din[31:0];
  assign i_bimc_rxrsp1[31:00]= bimc_rxrsp1_data_din[31:0];
  assign i_bimc_rxrsp2[07:00]= bimc_rxrsp2_data_din[7:0]; 
  assign i_bimc_rxrsp2[08:08]= bimc_rxrsp2_rxflag_din;    
  assign i_bimc_rxrsp2[09:09]= o_bimc_rxrsp2[09:09];

  assign i_bimc_pollrsp0[31:00]= bimc_pollrsp0_data_din[31:0];
  assign i_bimc_pollrsp1[31:00]= bimc_pollrsp1_data_din[31:0];
  assign i_bimc_pollrsp2[07:00]= bimc_pollrsp2_data_din[7:0];
  assign i_bimc_pollrsp2[08:08]= bimc_pollrsp2_rxflag_din;   
  assign i_bimc_pollrsp2[09:09]= o_bimc_pollrsp2[09:09];

endmodule






