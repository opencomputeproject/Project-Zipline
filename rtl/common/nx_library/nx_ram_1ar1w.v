/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



















`include "ccx_std.vh"
`include "messages.vh"

module nx_ram_1ar1w #(parameter
                   WIDTH      = 64,
                   DEPTH      = 256,
                   BWEWIDTH = WIDTH,
                   SPECIALIZE = 1,
                   IN_FLOP = 0,
                   OUT_FLOP = 0)
   (input logic                    rst_n,
    input logic                    clk ,
`ifdef ENA_BIMC
    input logic                    lvm, 
    input logic                    mlvm, 
    input logic                    mrdten,
    input logic                    bimc_rst_n,
    input logic                    bimc_isync,
    input logic                    bimc_idat,
    output logic                   bimc_odat,
    output logic                   bimc_osync,
    output logic                   ro_uncorrectable_ecc_error,
`endif
    input logic [`LOG_VEC(DEPTH)]  ra ,
    output logic [`BIT_VEC(WIDTH)] dout ,
    input                          web ,
    input logic [`LOG_VEC(DEPTH)]  wa ,
    input logic [`BIT_VEC(WIDTH)]  din ,
    input logic [`BIT_VEC(WIDTH)]  bwe);

   
   logic [`BIT_VEC(WIDTH)]         ldout;
   logic [`BIT_VEC(WIDTH)]         ldin;
   assign ldin = din;
   
   
   
   
`define _NX_1AR1WRAM_LOCAL(W=WIDTH)         \
   logic [`BIT_VEC(W)]             mdout; \
   logic [`BIT_VEC(W)]             mdin;  \
   assign ldout = mdout >> (W-WIDTH);     \
   assign mdin  = ldin  << (W-WIDTH)
   
`ifndef ENA_BIMC
   logic                           bimc_idat;
   assign bimc_idat   = 1'b0;
   logic                           bimc_isync;
   assign bimc_isync  = 1'b0;
   logic                           lvm;
   assign lvm = 1'b0;
   logic                           mlvm;
   assign mlvm = 1'b0;
   logic                           bimc_odat;
   logic                           bimc_osync;
`endif 

   logic                     bimc_iclk;
   assign bimc_iclk = clk;
   logic                           bimc_irstn;
`ifdef ENA_BIMC
   assign bimc_irstn  = bimc_rst_n;
`else
   assign bimc_irstn  = 1'b0;
`endif

   
   
   
   
   logic [WIDTH-1:0]               mem[DEPTH];

   logic                           p_mode_disable_ecc_mem;
   assign p_mode_disable_ecc_mem = 1'b0;
   logic                           se;
   assign se = 1'b0;
   logic                           rds;
   assign rds = 1'b0;
   
   logic [1:0]                     ecc_corrupt; 
   assign ecc_corrupt = 2'b00;
   logic                           rst_rclk_n;
   assign rst_rclk_n = rst_n;   
   logic                           rst_wclk_n;
   assign rst_wclk_n = rst_n;
   logic                           rclk;
   logic                           wclk;

   assign rclk = clk;
   assign wclk = clk;
   genvar                          ii;
   generate 
      
`ifndef SYNTHESIS
      initial
        `INFO("%dx%db 1AR1WRAM", DEPTH, WIDTH);
`endif
      
      
      


      case ({SPECIALIZE, DEPTH, WIDTH, IN_FLOP, OUT_FLOP})

        
        
        

        
        
        default : begin : _1ar1wramDxWb 
                
`ifndef SYNTHESIS
           initial begin
              if (SPECIALIZE)
                if ((DEPTH*WIDTH)<16384)
                  `WARN("SPECIALIZE parameter set but no specialization found");
                else
                  `WARN("Very large memory needs specialization"); 
              else if ((DEPTH*WIDTH)>16384)
                `WARN("Very large memory should be specialized");

              if (RD_LATENCY < 1)
                `ERROR("Minimum read latency is 1");
           end
`endif
           
`define _DECLARE_ACCESSORS                                     \
           task get_backdoor (input                            \
                              integer                 opcode, \
                              logic [`LOG_VEC(DEPTH)] address, \
                              output                  \
                              logic [`BIT_VEC(WIDTH)] data);   \
              if (opcode != 4)                                 \
              `ERROR("Unexpected opcode %d", opcode);          \
              else                                             \
              data = mem[address];                             \
           endtask : get_backdoor                              \
           task set_backdoor (input                            \
                              integer                 opcode, \
                              logic [`LOG_VEC(DEPTH)] address, \
                              logic [`BIT_VEC(WIDTH)] data);   \
              if (opcode != 6)                                 \
              `ERROR("Unexpected opcode %d", opcode);          \
              else                                             \
              mem[address] = data;                             \
           endtask : set_backdoor
           
           
           
           logic [`LOG_VEC(DEPTH)]                    _ra;
           logic                                      _web;
           logic [`LOG_VEC(DEPTH)]                    _wa;
           logic [      WIDTH-1:0]                    _din;
           logic [BWEWIDTH-1:0]                       _bwe;
           
           if (IN_FLOP) begin
              logic [`LOG_VEC(DEPTH)] ra_r;
              logic                   web_r;
              logic [`LOG_VEC(DEPTH)] wa_r;
              logic [      WIDTH-1:0] din_r;
              logic [BWEWIDTH-1:0]    bwe_r;
              
              always_ff @(posedge clk or negedge rst_n) begin
                 if (!rst_n) begin
                    web_r <= 0;
                 end
                 else begin
                    web_r <= web;
                 end
              end
              always_ff @(posedge clk) begin
                 din_r <= ldin;
                 ra_r <= ra;
                 bwe_r <= bwe;
                 wa_r <= wa;
              end
              assign _ra = ra_r;
              assign _web = web_r;
              assign _wa = wa_r;
              assign _din = din_r;
              assign _bwe = bwe_r;
           end 
           else begin
              assign _ra = ra;
              assign _web = web;
              assign _wa = wa;
              assign _din = ldin;
              assign _bwe = bwe;
           end 

           logic [WIDTH-1:0]       dout_i;
           logic [WIDTH-1:0]       din_i ;
           logic [WIDTH-1:0]       mem[DEPTH];
           
           assign dout_i = mem[_ra];

           logic [WIDTH-1:0] _dout;
           
           if (OUT_FLOP) begin
              logic [WIDTH-1:0] dout_r;
              always_ff @(posedge clk) begin
                 dout_r <= dout_i
              end
              assign ldout = dout_r;
           end
           else begin
              assign ldout = dout_i;
           end
           
           
           assign bimc_odat = bimc_idat;
           assign bimc_osync = bimc_isync;
           assign ro_uncorrectable_ecc_error = 1'd0;
        
`ifndef SYNTHESIS
           `_DECLARE_ACCESSORS 
             
           initial `INFO("Estimate %d latches",
                         DEPTH);       
           initial `INFO("Estimate %d flops",
                         WIDTH +       
                         DEPTH*WIDTH); 
`endif
        
           assign din_i  = mem[_wa] & ~_bwe | _din & _bwe; 
           always @(posedge clk) begin
              if (!_web) begin
                 mem[_wa] <= din_i;
                 `DEBUG("Writing %x to %d", din_i, _wa);
              end
           end
        
`undef _DECLARE_ACCESSORS

        end : _1ar1wramDxWb

      endcase 
      assign dout = ldout;
      
   endgenerate

endmodule : nx_ram_1ar1w








