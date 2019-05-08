/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"
`include "messages.vh"
`include "axi_reg_slice_defs.vh"

module cr_xp10_decomp_mtf (
   
   mtf_bhp_hdr_ready, mtf_sdd_dp_ready, mtf_lz_dp_valid,
   mtf_lz_dp_bus,
   
   clk, rst_n, ovstb, lvm, mlvm, bhp_mtf_hdr_valid, bhp_mtf_hdr_bus,
   sdd_mtf_dp_valid, sdd_mtf_dp_bus, lz_mtf_dp_ready
   );

   parameter logic SUPPRESS_EOB = 1'b0;
   
   import crPKG::*;
   
   
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
   
   
   
   
   input         clk;
   input         rst_n; 
   
   
   
   
   input         ovstb;
   input         lvm;
   input         mlvm;

   
   
   
   input logic   bhp_mtf_hdr_valid;
   input         bhp_mtf_hdr_bus_t bhp_mtf_hdr_bus;
   output logic  mtf_bhp_hdr_ready;

   
   
   
   input logic   sdd_mtf_dp_valid;
   input         lz_symbol_bus_t sdd_mtf_dp_bus;
   output logic  mtf_sdd_dp_ready;
   
   
   
   
   output logic  mtf_lz_dp_valid;
   output        lz_symbol_bus_t mtf_lz_dp_bus;
   input logic   lz_mtf_dp_ready;

   logic [63:0]  mtf_lz_dp_bus_raw; 
   assign mtf_lz_dp_bus_raw = mtf_lz_dp_bus;

   logic   header_valid;
   bhp_mtf_hdr_bus_t header_data;
   logic   header_ready;

   
   
   
`define DECLARE_RESET_FLOP(name, reset_val) \
   r_``name, c_``name; \
   always_ff@(posedge clk or negedge rst_n)    \
     if (!rst_n) \
       r_``name <= reset_val; \
     else \
       r_``name <= c_``name
`define DECLARE_FLOP(name) \
   r_``name, c_``name; \
   always_ff@(posedge clk) r_``name <= c_``name 
`define DEFAULT_FLOP(name) c_``name = r_``name


   logic             `DECLARE_RESET_FLOP(mtf_cache_valid, 0);
   logic             `DECLARE_RESET_FLOP(mtf_cache_present, 0);
   logic [3:0][15:0] `DECLARE_RESET_FLOP(mtf_cache_data, '0);
   logic             `DECLARE_RESET_FLOP(mtf_cache_format, 0);
   logic             `DECLARE_RESET_FLOP(mtf_cache_ptr_last, 0);
   zipline_error_e    `DECLARE_RESET_FLOP(errcode, NO_ERRORS);

   logic             pipe_src_valid;
   lz_symbol_bus_t   pipe_src_data;
   logic             pipe_src_ready;

   always_comb begin
      logic [3:0][7:0] v_data;
      logic [31:0]     v_data_bits;
      v_data = {sdd_mtf_dp_bus.data3,
                sdd_mtf_dp_bus.data2,
                sdd_mtf_dp_bus.data1,
                sdd_mtf_dp_bus.data0};

      v_data_bits = v_data;

      `DEFAULT_FLOP(mtf_cache_valid);
      `DEFAULT_FLOP(mtf_cache_present);
      `DEFAULT_FLOP(mtf_cache_data);
      `DEFAULT_FLOP(mtf_cache_format);
      `DEFAULT_FLOP(mtf_cache_ptr_last);
      `DEFAULT_FLOP(errcode);

      mtf_sdd_dp_ready = 0;

      pipe_src_valid = 0;
      pipe_src_data = sdd_mtf_dp_bus;
      pipe_src_data.backref_type = 0;

      if (sdd_mtf_dp_valid) begin
         if (sdd_mtf_dp_bus.framing == 4'hf) begin
            
            pipe_src_valid = 1;

            
            if ((r_errcode != NO_ERRORS) && 
                (zipline_error_e'(v_data_bits[`BIT_VEC($bits(zipline_error_e))]) == NO_ERRORS)) begin
               v_data_bits[`BIT_VEC($bits(zipline_error_e))] = r_errcode;
               {pipe_src_data.data3,
                pipe_src_data.data2,
                pipe_src_data.data1,
                pipe_src_data.data0} = v_data_bits;
            end
            
            if (pipe_src_ready) begin
               mtf_sdd_dp_ready = 1;
               if (!r_mtf_cache_valid || !r_mtf_cache_present) begin
                  
                  
                  
                  
                  
                  
                  c_mtf_cache_data = '0;
                  c_mtf_cache_ptr_last = 0;
                  
               end 
               c_errcode = NO_ERRORS;
            end
         end
         else if (r_mtf_cache_valid) begin
            
            
            
            
            

            pipe_src_valid = 1;

            if (sdd_mtf_dp_bus.backref) begin
               logic [1:0] v_mtf;
               logic [15:0] v_offset;
               logic [3:1]  v_shift_en;
               if (sdd_mtf_dp_bus.backref_type) begin
                  v_mtf = v_data[sdd_mtf_dp_bus.backref_lane][1:0];
                  if (!r_mtf_cache_format && 
                      r_mtf_cache_ptr_last && 
                      (sdd_mtf_dp_bus.backref_lane==0)) begin
                     
                     
                     if (v_mtf==3) begin
                        c_errcode = HD_MTF_XP9_MTF3_AFTER_BACKREF;
                     end
                     v_mtf++;
                  end
                  
                  v_offset = r_mtf_cache_data[v_mtf];

                  if (v_offset == 0) begin
                     
                     
                     
                     assert #0 (r_mtf_cache_format) else `ERROR("should NOT be possible to get an offset of 0 for XP9 (only XP10 when MTF header is not present)");
                     c_errcode = HD_MTF_XP10_MISSING_MTF;
                  end
                  
                  v_shift_en = ~('1  << v_mtf);

                  
                  {pipe_src_data.offset_msb,
                   v_data[sdd_mtf_dp_bus.backref_lane]} = v_offset;
                  {pipe_src_data.data3,
                   pipe_src_data.data2,
                   pipe_src_data.data1,
                   pipe_src_data.data0} = v_data;
               end
               else begin
                  
                  v_offset = {sdd_mtf_dp_bus.offset_msb, v_data[sdd_mtf_dp_bus.backref_lane]};
                  v_shift_en = 3'b111;
               end 

               
               
               c_mtf_cache_data[0] = v_offset;
               for (int i=1; i<4; i++) begin
                  if (v_shift_en[i])
                    c_mtf_cache_data[i] = r_mtf_cache_data[i-1];
               end

               
               
               if (3'(sdd_mtf_dp_bus.backref_lane + 1) == pipe_src_data.framing[2:0])
                 c_mtf_cache_ptr_last = 1;
               else
                 c_mtf_cache_ptr_last = 0;

            end 
            else
              c_mtf_cache_ptr_last = 0;

            
            assert #0 (sdd_mtf_dp_bus.framing != 0) else `ERROR("can't get valid symbol data with framing==0");

            
            pipe_src_data.framing[3] &= ~SUPPRESS_EOB; 

            
            if (pipe_src_data.framing == 0)
              pipe_src_valid = 0;

            if (pipe_src_ready || !pipe_src_valid) begin
               
               
               mtf_sdd_dp_ready = 1;
               if (sdd_mtf_dp_bus.framing[3]) begin
                  
                   
                  
                  c_mtf_cache_valid = 0;
               end
            end 
            else begin
               
               `DEFAULT_FLOP(mtf_cache_data);
               `DEFAULT_FLOP(mtf_cache_ptr_last);
            end
         end 
      end 
      

      
      header_ready = 0;
      if (header_valid && !c_mtf_cache_valid) begin
         logic [3:0][4:0] v_exp;
         logic [3:0][15:0] v_offset;
         header_ready = 1;
         c_mtf_cache_valid = 1;
         c_mtf_cache_format = header_data.format;
         c_mtf_cache_present = header_data.present;

         
         
         
         
         
         

         if (header_data.present) begin
            c_mtf_cache_ptr_last = header_data.ptr_last;
            
            v_exp = {header_data.exp3,
                     header_data.exp2,
                     header_data.exp1,
                     header_data.exp0};
            
            v_offset = {header_data.offset3,
                        header_data.offset2,
                        header_data.offset1,
                        header_data.offset0};
            
            for (int i=0; i<4; i++) begin
               c_mtf_cache_data[i] = 16'(1 << v_exp[i]) |
                       16'(16'(~('1 << v_exp[i])) & v_offset[i]);
            end
         end
      end
   end

   genvar i, j;
   generate
      for (i=0; i<4; i++) begin
         for (j=0; j<2; j++) begin
            `COVER_PROPERTY(sdd_mtf_dp_valid && sdd_mtf_dp_bus.backref && sdd_mtf_dp_bus.backref_type && (sdd_mtf_dp_bus.backref_lane==0) && (sdd_mtf_dp_bus.data0[1:0] == i) && (r_mtf_cache_format == j));
            `COVER_PROPERTY(sdd_mtf_dp_valid && sdd_mtf_dp_bus.backref && sdd_mtf_dp_bus.backref_type && (sdd_mtf_dp_bus.backref_lane==1) && (sdd_mtf_dp_bus.data1[1:0] == i) && (r_mtf_cache_format == j));
            `COVER_PROPERTY(sdd_mtf_dp_valid && sdd_mtf_dp_bus.backref && sdd_mtf_dp_bus.backref_type && (sdd_mtf_dp_bus.backref_lane==2) && (sdd_mtf_dp_bus.data2[1:0] == i) && (r_mtf_cache_format == j));
            `COVER_PROPERTY(sdd_mtf_dp_valid && sdd_mtf_dp_bus.backref && sdd_mtf_dp_bus.backref_type && (sdd_mtf_dp_bus.backref_lane==3) && (sdd_mtf_dp_bus.data3[1:0] == i) && (r_mtf_cache_format == j));
         end
      end
   endgenerate

   


   axi_channel_reg_slice
     #(.HNDSHK_MODE(`AXI_RS_FULL),
       .PAYLD_WIDTH($bits(bhp_mtf_hdr_bus_t)))
   u_head_info_reg
     (
      
      .ready_src                        (mtf_bhp_hdr_ready),     
      .valid_dst                        (header_valid),          
      .payload_dst                      (header_data),           
      
      .aclk                             (clk),                   
      .aresetn                          (rst_n),                 
      .valid_src                        (bhp_mtf_hdr_valid),     
      .payload_src                      (bhp_mtf_hdr_bus),       
      .ready_dst                        (header_ready));          
   
   

   axi_channel_reg_slice
     #(.HNDSHK_MODE(`AXI_RS_FULL),
       .PAYLD_WIDTH($bits(lz_symbol_bus_t)))
   u_out_reg
     (
      
      .ready_src                        (pipe_src_ready),        
      .valid_dst                        (mtf_lz_dp_valid),       
      .payload_dst                      (mtf_lz_dp_bus),         
      
      .aclk                             (clk),                   
      .aresetn                          (rst_n),                 
      .valid_src                        (pipe_src_valid),        
      .payload_src                      (pipe_src_data),         
      .ready_dst                        (lz_mtf_dp_ready));       

`undef DECLARE_RESET_FLOP
`undef DECLARE_FLOP
`undef DEFAULT_FLOP   

endmodule 







