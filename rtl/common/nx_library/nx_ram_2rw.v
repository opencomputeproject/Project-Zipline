/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/















































`include "ccx_std.vh"
`include "messages.vh"

module nx_ram_2rw
  #(parameter
    WIDTH=64,       
    BWEWIDTH=WIDTH, 
    DEPTH=256,      
    SPECIALIZE=1,   
    OUT_FLOP=0,
    IN_FLOP=0,
    RD_LATENCY=1,
    WRITETHROUGH=0)        
   (
    input                      clk,
    input                      rst_n,
`ifdef ENA_BIMC
    input logic                ovstb,
    input logic                lvm, 
    input logic                mlvm, 
    input logic                mrdten,
    input logic                bimc_rst_n,
    input logic                bimc_isync,
    input logic                bimc_idat,
    output logic               bimc_odat,
    output logic               bimc_osync,
    output logic               ro_uncorrectable_ecc_error,
`endif 
   
    input [`BIT_VEC(BWEWIDTH)] bwea,
    input [`BIT_VEC(WIDTH)]    dina,
    input [`LOG_VEC(DEPTH)]    adda,
    input                      csa,
    input                      wea,
   
    output [`BIT_VEC(WIDTH)]   douta,

    input [`BIT_VEC(BWEWIDTH)] bweb,
    input [`BIT_VEC(WIDTH)]    dinb,
    input [`LOG_VEC(DEPTH)]    addb,
    input                      csb,
    input                      web,
   
    output [`BIT_VEC(WIDTH)]   doutb);

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
   logic                     sew;
   assign sew = 1'b0;
   
   logic                     ro_mem_ecc_error_ev;
   logic                     ro_mem_ecc_corrected;
   
   logic [`LOG_VEC(DEPTH)]   ro_mem_ecc_error_addr;

   genvar                    ii;
                
`ifndef SYNTHESIS
   initial
     `INFO("%dx%db SPRAM", DEPTH, WIDTH);
`endif



   
      

   
   generate

      case ({SPECIALIZE, DEPTH, WIDTH, IN_FLOP, OUT_FLOP, RD_LATENCY})

	
        
        default : begin : g 
           
           
           
                
`ifndef SYNTHESIS
           initial begin
              
           end 

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
           

           logic [`LOG_VEC(DEPTH)] _adda;
           logic [      WIDTH-1:0] _dina;
           logic [BWEWIDTH-1:0]    _bwea;
           logic                   _csa;
           logic                   _wea;

           logic [`LOG_VEC(DEPTH)] _addb;
           logic [      WIDTH-1:0] _dinb;
           logic [BWEWIDTH-1:0]    _bweb;
           logic                   _csb;
           logic                   _web;

           if (IN_FLOP) begin : in_flop
              logic [`LOG_VEC(DEPTH)] adda_r;
              logic [      WIDTH-1:0] dina_r;
              logic [BWEWIDTH-1:0]    bwea_r;
              logic                   csa_r;
              logic                   wea_r;

              logic [`LOG_VEC(DEPTH)] addb_r;
              logic [      WIDTH-1:0] dinb_r;
              logic [BWEWIDTH-1:0]    bweb_r;
              logic                   csb_r;
              logic                   web_r;

              always@(posedge clk or negedge rst_n) begin
                 if (!rst_n) begin
                    csa_r <= 0;
                    wea_r <= 0;
                    csb_r <= 0;
                    web_r <= 0;
                 end
                 else begin
                    csa_r <= csa;
                    wea_r <= wea;
                    csb_r <= csb;
                    web_r <= web;
                 end
              end
              always@(posedge clk) begin
                 dina_r <= dina;
                 adda_r <= adda;
                 bwea_r <= bwea;
                 dinb_r <= dinb;
                 addb_r <= addb;
                 bweb_r <= bweb;
              end

              assign _adda = adda_r;
              assign _dina = dina_r;
              assign _bwea = bwea_r;
              assign _csa = csa_r;
              assign _wea = wea_r;
              assign _addb = addb_r;
              assign _dinb = dinb_r;
              assign _bweb = bweb_r;
              assign _csb = csb_r;
              assign _web = web_r;
           end 
           else begin
              assign _adda = adda;
              assign _dina = dina;
              assign _bwea = bwea;
              assign _csa = csa;
              assign _wea = wea;
              assign _addb = addb;
              assign _dinb = dinb;
              assign _bweb = bweb;
              assign _csb = csb;
              assign _web = web;
           end 

           logic [WIDTH-1:0]       douta_i;
           logic [WIDTH-1:0]       dina_i ;
           logic [WIDTH-1:0]       doutb_i;
           logic [WIDTH-1:0]       dinb_i ;
           logic [WIDTH-1:0]       mem[DEPTH];


           logic                   writethrough;
           if (WRITETHROUGH) begin
              assign writethrough = (_adda == _addb) && _csa && _wea;
           end
           else begin
              assign writethrough = 1'b0;
           end

           assign douta_i = mem[_adda];
           assign dina_i  = douta_i & ~_bwea | _dina & _bwea; 
           assign doutb_i = writethrough ? dina_i : mem[_addb];
           assign dinb_i  = doutb_i & ~_bweb | _dinb & _bweb; 

           logic [WIDTH-1:0] douta_r[RD_LATENCY];
           logic [WIDTH-1:0] doutb_r[RD_LATENCY];
           always@(posedge clk) begin
              if (_csa && !_wea)
                douta_r[0] <= douta_i;
              if (_csb && !_web)
                doutb_r[0] <= doutb_i;
              for (int i=1; i<RD_LATENCY; i++) begin
                 douta_r[i] <= douta_r[i-1];
                 doutb_r[i] <= doutb_r[i-1];
              end              
           end

           
              logic [WIDTH-1:0] douta_rr;
              logic [WIDTH-1:0] doutb_rr;
              always@(posedge clk) begin
                 douta_rr <= douta_r[RD_LATENCY-1];
                 doutb_rr <= doutb_r[RD_LATENCY-1];
              end
              assign douta = douta_rr;
              assign doutb = doutb_rr;
           
           
           
           
           


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
           
           always @(posedge clk) begin
              if (_csa && _wea) begin
                 mem[_adda] <= dina_i;
                 `DEBUG("Writing %x to %d", dina_i, _adda);
              end
              if (_csb && _web) begin
                 mem[_addb] <= dinb_i;
                 `DEBUG("Writing %x to %d", dinb_i, _addb);
              end
           end

`undef _DECLARE_ACCESSORS

        end : g

      endcase 

   endgenerate
   
endmodule : nx_ram_2rw







