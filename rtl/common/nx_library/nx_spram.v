/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/















































`include "ccx_std.vh"
`include "messages.vh"

module nx_spram
  #(parameter
    WIDTH=64,       
    BWEWIDTH=WIDTH, 
    DEPTH=256,      
    SPECIALIZE=1,   
    LATCH=0)        
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
   
    input [`BIT_VEC(BWEWIDTH)] bwe,
    input [`BIT_VEC(WIDTH)]    din,
    input [`LOG_VEC(DEPTH)]    add,
    input                      cs,
    input                      we,
   
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

        
        
        

        
        {32'd1, 32'd128, 32'd16} : begin : g 
           
           CB_M28SPLL128X22R2011VTES35D111BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g
        
        
        {32'd1, 32'd96, 32'd32} : begin : g 
           CB_M28SPLL96X39R2011VTS31D111BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g

        
        {32'd1, 32'd512, 32'd10} : begin : g 
           
           CB_M28SPLL512X15R2011VTES35D121BSIRCNLMAQF_e_mc1_wrapper u_ram 
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .pda                      ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g

        
        {32'd4, 32'd1024, 32'd10} : begin : g 
           
           CB_M28SPLL1024X15R2011VTES35D121BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g

  
        {32'd1, 32'd2048, 32'd4} : begin : g 
           
           CB_M28SPLL2048X8R3011VTES35D121BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g

        
        {32'd1, 32'd256, 32'd64} : begin : g 
        CB_M28SPLL256X72R2012VTS35D211BSIRCLMAQF_e_mc1_wrapper u_ram
          (.*,
           
           .eccp_out0                   (),                      
           .so                          (),                      
           
           .eccp_in0                    ('0),                    
           .si                          ('0),                    
           .s_rf                        ('0),                    
           .s_cf                        ('0),                    
           .tm                          ('0),                    
           .mrdten                      ('0),                    
           .rdt                         ('0),                    
           .wbt                         ('0)                     
           );
        end : g

  
        
        {32'd1, 32'd2048, 32'd9} : begin : g 
           
           CB_M28SPLL2048X9R3011VTES35D121BSIRCLMAQF_mc1_wrapper u_ram
             (.*,
              
              .so                       (),                      
              
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g


        
        {32'd1, 32'd256, 32'd97} : begin : g 
           
           CB_M28SPLL256X105R2012VTES35D211BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g

        
        {32'd1, 32'd1024, 32'd29} : begin : g 
           
           CB_M28SPLL1024X36R2011VTES35D121BSIRCLMAQF_e_mc1_wrapper u_ram 
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g

        
        {32'd1, 32'd2048, 32'd19} : begin : g 
           CB_M28SPLL2048X25R3012VTS31D121BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g

        
        {32'd1, 32'd1152, 32'd51} : begin : g 
           
           CB_M28SPLL1152X58R2021VTS31D122BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g


  
  {32'd2, 32'd4608, 32'd13},
  {32'd1, 32'd4608, 32'd13} : begin : g 
           
           CB_M28SPLL4608X19R4022VTES35D222BSIRCNLMAQF_e_mc1_wrapper u_ram 
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .pda                      ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
  end : g

        
        {32'd1, 32'd4608, 32'd14} : begin : g 
          CB_M28SPLL4608X20R4022VTS38D222BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g

        
        {32'd1, 32'd1024, 32'd97} : begin : g 
           
           CB_M28SPLL1024X105R2012VTES35D221BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g

  
  {32'd1, 32'd4608, 32'd25} : begin : g 
           
           CB_M28SPLL4608X31R3041VTES35D122BSIRCLMAQF_e_mc1_wrapper u_ram 
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
  end : g

  
  {32'd1, 32'd4096, 32'd28} : begin : g 
           
           CB_M28SPLL4096X35R2041VTES35D122BSIRCNLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .pda                      ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
  end : g


        
        {32'd1, 32'd6144, 32'd18} : begin : g 
           
           CB_M28SPLL6144X24R4022VTS38D222BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g
  
        
        {32'd1, 32'd4096, 32'd32} : begin : g 
           
           CB_M28SPLL4096X39R3022VTS31D222BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g

        
        {32'd1, 32'd2048, 32'd81} : begin : g 
           
     
           CB_M28SPLL2048X89R2022VTS38D222BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g 

        
        {32'd1, 32'd4096, 32'd44} : begin : g 
           
           CB_M28SPLL4096X51R2042VTES35D122BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g


  
        {32'd1, 32'd4608, 32'd45} : begin : g 
           
           CB_M28SPLL4608X52R3042VTES35D222BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g

  
  {32'd1, 32'd4096, 32'd67} : begin : g 
           
           CB_M28SPLL4096X75R2042VTES35D222BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
  end : g

        
        {32'd1, 32'd16384, 32'd16} : begin : g 
           
           CB_M28SPLL16384X22R4042VTES35D222BSIRCLMAQF_e_mc1_wrapper u_ram 
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g


        
        {32'd1, 32'd4608, 32'd78} : begin : g 
           
           CB_M28SPLL4608X86R2082VTS31D222BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g

        
        {32'd1, 32'd5120, 32'd128},
        {32'd1, 32'd16384, 32'd16} : begin : g 
           CB_M28SPLL5120X137R2082VTES35D322BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g 


  
        {32'd1, 32'd8192, 32'd128} : begin : g 
           CB_M28SPLL8192X137R2082VTS38D322BSINLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .pda                      ('0),                    
              .si                       ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
              );
        end : g
        
    
        {32'd1, 32'd8192, 32'd32} : begin : g 
           CB_M28SPLL8192X39R3042VTES35D222BSIRCLMAQF_e_mc1_wrapper u_ram
             (.*,
              
              .eccp_out0                (),                      
              .so                       (),                      
              
              .eccp_in0                 ('0),                    
              .si                       ('0),                    
              .s_rf                     ('0),                    
              .s_cf                     ('0),                    
              .tm                       ('0),                    
              .mrdten                   ('0),                    
              .rdt                      ('0),                    
              .wbt                      ('0)                     
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
   
endmodule : nx_spram







