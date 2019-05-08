/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/















































`include "ccx_std.vh"
`include "messages.vh"

module nx_spram_init
  #(parameter
    PDA=8,
    WIDTH=64,       
    BWEWIDTH=WIDTH, 
    DEPTH=256,      
    SPECIALIZE=1,   
    LATCH=0)        
   (
    input 		       clk,
    input 		       rst_n,
`ifdef ENA_BIMC
    input logic 	       ovstb,
    input logic 	       lvm,
    input logic 	       mlvm,
    input logic 	       mrdten,
    input logic 	       bimc_rst_n,
    input logic 	       bimc_isync,
    input logic 	       bimc_idat,
    output logic 	       bimc_odat,
    output logic 	       bimc_osync,
    output logic 	       ro_uncorrectable_ecc_error,
`endif 

    input [`BIT_VEC(BWEWIDTH)] bwe,
    input [`BIT_VEC(WIDTH)]    din,
    input [`LOG_VEC(DEPTH)]    add,
    input 		       cs,
    input 		       we,
    input [`BIT_VEC(WIDTH)]    init_din,
    input 		       init,
    input [PDA-1:0]            pda,
    output 		       init_done,

    output [`BIT_VEC(WIDTH)]   dout);

`ifndef ENA_BIMC
   logic                     bimc_idat;
   assign bimc_idat   = 1'b0;
   logic                     bimc_isync;
   assign bimc_isync  = 1'b0;
   logic                     ovstb;
   assign ovstb = 1'b1;
   logic                     lvm;
   assign lvm = 1'b0;
   logic                     mlvm;
   assign mlvm = 1'b0;
   logic                     bimc_odat;
   logic                     bimc_osync;
`endif 

   logic                     bimc_iclk;
   assign bimc_iclk = clk;
   logic                     bimc_irstn;
`ifdef ENA_BIMC
   assign bimc_irstn  = bimc_rst_n;
`else
   assign bimc_irstn  = 1'b0;
`endif

   logic                     rst_clk_n;
   assign rst_clk_n = rst_n;
   logic                     p_mode_disable_ecc_mem;
   assign p_mode_disable_ecc_mem = 1'b0;
   logic                     byp;
   assign byp = 1'b0;
   logic                     se;
   assign se = 1'b0;
   logic                     rds;
   assign rds = 1'b0;

   logic [1:0]               ecc_corrupt;
   assign ecc_corrupt = 2'b00;
   logic                     rst_rclk_n;
   assign rst_rclk_n = rst_n;
   logic                     sew;
   assign sew = 1'b0;
   logic                     web;
   assign web = !(cs && we);

   logic                     ro_mem_ecc_error_ev;
   logic                     ro_mem_ecc_corrected;
   
   logic [`LOG_VEC(DEPTH)]   ro_mem_ecc_error_addr;

   genvar                    ii;

`ifndef SYNTHESIS
   initial
     `INFO("%dx%db SPRAM", DEPTH, WIDTH);
`endif

   
   

   
   


   generate

      case ({SPECIALIZE, DEPTH, WIDTH})

	
	
	


	
        {32'd1, 32'd8192, 32'd128} : begin : g 
	   CB_M28SPLL8192X137R2082VTS38D322BSIRCNLMAQF_e_i_mc1_wrapper u_ram
             (.*,
	      
	      .eccp_out0		(),			 
	      .so			(),			 
	      
	      .eccp_in0			('0),			 
	      .si			('0),			 
	      .s_rf			('0),			 
	      .s_cf			('0),			 
	      .tm			('0),			 
	      .mrdten			('0),			 
	      .rdt			('0),			 
	      .wbt			('0)			 
	      );
        end : g







        
        default : begin : g 
           
           
           

`ifndef SYNTHESIS
           initial
	     if (SPECIALIZE)
	       if ((DEPTH*WIDTH)<16384)
		 `WARN("SPECIALIZE parameter set but no specialization found");
	       else
		 `ERROR("Very large memory (%dx%db) is missing specialization",
			DEPTH, WIDTH);
	     else if ((DEPTH*WIDTH)>16384)
	       `WARN("Very large memory (%dx%db) should be specialized",
		     DEPTH, WIDTH);
`endif

`define _DECLARE_ACCESSORS                                     \
           task get_backdoor (input                            \
                              integer                 opcode,  \
                              logic [`LOG_VEC(DEPTH)] address, \
                              output                           \
                              logic [`BIT_VEC(WIDTH)] data);   \
              if (opcode != 4)                                 \
              `ERROR("Unexpected opcode %d", opcode);          \
              else                                             \
              data = mem[address];                             \
           endtask : get_backdoor                              \
           task set_backdoor (input                            \
                              integer                 opcode,  \
                              logic [`LOG_VEC(DEPTH)] address, \
                              logic [`BIT_VEC(WIDTH)] data);   \
              if (opcode != 6)                                 \
              `ERROR("Unexpected opcode %d", opcode);          \
              else                                             \
              mem[address] = data;                             \
           endtask : set_backdoor

           logic [`LOG_VEC(DEPTH)] add_r;
           logic [      WIDTH-1:0] dat_r;

           logic [WIDTH-1:0]       dout_i;
           logic [WIDTH-1:0]       din_i ;

           logic [DEPTH-1:0]       we_clk ;
           logic [DEPTH-1:0]       we_gate;

           logic [WIDTH-1:0]       mem[DEPTH];

           assign dout_i = mem[add];                  
           assign din_i  = dout_i & ~bwe | din & bwe; 
           assign dout   = dat_r;

           assign bimc_odat = bimc_idat;
           assign bimc_osync = bimc_isync;
           assign ro_uncorrectable_ecc_error = 1'd0;
	   assign init_done = 1'd0;


           always_ff @(posedge clk or negedge rst_n)
             if (!rst_n)
               dat_r         <= '0;
             else if (cs)
               dat_r         <= we ? din_i : dout_i;

           
           
           
           
           
           
           assign we_clk = {DEPTH{clk}}; 
           if (LATCH) begin : u_ram

`ifndef SYNTHESIS
              `_DECLARE_ACCESSORS 

              initial `INFO("Estimate %d latches",
                            DEPTH +       
                            DEPTH*WIDTH); 
              initial `INFO("Estimate %d flops",
                            WIDTH);       
`endif

              always @*  begin : wr_word
                 for (int jj=0; jj< DEPTH; jj++) begin : latch
                    if (we_clk[jj]) begin 
                       mem[jj] = dat_r;
                       `DEBUG("Writing %x to %d", dat_r, jj);
                    end
                 end : latch
              end : wr_word

           end : u_ram
           else begin : u_ram

`ifndef SYNTHESIS
              `_DECLARE_ACCESSORS 

              initial `INFO("Estimate %d latches",
                            DEPTH);       
              initial `INFO("Estimate %d flops",
                            WIDTH +       
                            DEPTH*WIDTH); 
`endif

                 always @(posedge clk)
                   if (cs && we) begin
                      mem[add] <= din_i;
                      `DEBUG("Writing %x to %d", din_i, add);
                   end


           end : u_ram

`undef _DECLARE_ACCESSORS

        end : g

      endcase 

   endgenerate

endmodule : nx_spram_init







