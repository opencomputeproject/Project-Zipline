/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp_htf_svt_writer (
   
   svt_wen, svt_addr, svt_data, svt_last,
   
   clk, rst_n, bct_wen, bct_addr, bct_data, bct_complete, blt_depth,
   blt, abort
   );

   parameter MAX_BLT_DEPTH = 33;
   parameter MAX_BCT_DEPTH = 8;
   parameter BL_PER_CYCLE = 2;
   
   
   
   input         clk;
   input         rst_n;    
   
   
   
   
   input                                 bct_wen;
   input [`LOG_VEC(MAX_BCT_DEPTH+1)]     bct_addr;
   input [`BIT_VEC(MAX_BCT_DEPTH)]       bct_data;
   input                                 bct_complete;

   
   
   
   input [`LOG_VEC(MAX_BLT_DEPTH+1)]                          blt_depth;
   input [`BIT_VEC(MAX_BLT_DEPTH)][`LOG_VEC(MAX_BCT_DEPTH+1)] blt;

   
   
   
   output logic [`BIT_VEC(BL_PER_CYCLE)]                      svt_wen;
   output logic [`LOG_VEC(MAX_BLT_DEPTH)]                     svt_addr;
   output logic [`BIT_VEC(BL_PER_CYCLE)][`BIT_VEC(MAX_BCT_DEPTH)] svt_data;
   output logic                                                   svt_last;

   
   
   input                                  abort;

   
   
   
   
   
`define DECLARE_FLOP(name) r_``name, c_``name
`define DEFAULT_FLOP(name) c_``name = r_``name
`define UPDATE_FLOP(name) r_``name <= c_``name
   
   enum  logic {IDLE=0, WRITE=1}               `DECLARE_FLOP(state);
   logic [`LOG_VEC(MAX_BLT_DEPTH)]             `DECLARE_FLOP(blt_index);
   logic [`LOG_VEC(MAX_BLT_DEPTH+1)]           `DECLARE_FLOP(blt_count);
   
   logic [`BIT_VEC_BASE(MAX_BCT_DEPTH, 1)] bct_preload_en;
   logic [`BIT_VEC_BASE(MAX_BCT_DEPTH, 1)] bct_inc_onehot[BL_PER_CYCLE];
   logic [`BIT_VEC_BASE(MAX_BCT_DEPTH, 1)][`BIT_VEC(MAX_BCT_DEPTH)] bct;


   
   
   logic [`BIT_VEC(((MAX_BLT_DEPTH+BL_PER_CYCLE-1)/BL_PER_CYCLE)*BL_PER_CYCLE*$clog2(MAX_BCT_DEPTH+1))] blt_padded; 


   assign blt_padded = ($bits(blt_padded))'(blt);

   always_comb begin
      logic [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(MAX_BCT_DEPTH+1)]   bl;

      `DEFAULT_FLOP(state);
      `DEFAULT_FLOP(blt_index);
      `DEFAULT_FLOP(blt_count);

      
      
      
      
      
      
      
      

      svt_wen = 0;
      svt_last = 0;
      bct_inc_onehot = '{default: 0};
      bl = blt_padded[r_blt_index*$clog2(MAX_BCT_DEPTH+1) +: BL_PER_CYCLE*$clog2(MAX_BLT_DEPTH+1)]; 

      svt_addr = r_blt_index;
      for (int i=0; i<BL_PER_CYCLE; i++) begin
         if (bl[i] == 0)
           svt_data[i] = '1; 
         else begin
            svt_data[i] = bct[bl[i]]; 
            
            for (int j=i-1; j>= 0; j--)
              svt_data[i] += (bl[i] == bl[j]); 
            
            
            
            svt_data[i] = { << {svt_data[i]} }; 
            svt_data[i] >>= MAX_BCT_DEPTH-bl[i]; 
         end 
      end 

      bct_preload_en = '0;
      bct_preload_en[bct_addr] = bct_wen; 
      
      case (r_state)
        IDLE: begin
           if (bct_complete) begin
              
              c_state = WRITE;
              c_blt_index = 0;
              c_blt_count = blt_depth;
           end
        end
        WRITE: begin
           logic [`BIT_VEC(BL_PER_CYCLE)] v_slt_wen_mask;

           v_slt_wen_mask = ~('1 << r_blt_count);
           assert #0 (!bct_wen) else `ERROR("bct should NOT get initialized while SVT is being written");
           assert #0 (!bct_complete) else `ERROR("bct should NOT be completed while SVT is being written");
           for (int i=0; i<BL_PER_CYCLE; i++) begin
              if ((bl[i] != 0) && v_slt_wen_mask[i]) begin
                 svt_wen[i] = 1;
                 
                 
                 bct_inc_onehot[i][bl[i]] = 1; 
              end
           end
           
           if (r_blt_count <= BL_PER_CYCLE) begin
              
              c_blt_index = 0;
              c_state = IDLE;
              svt_last = 1;
           end
           else begin
              c_blt_index = $bits(r_blt_index)'(r_blt_index + BL_PER_CYCLE);
              c_blt_count = $bits(r_blt_count)'(r_blt_count - BL_PER_CYCLE);
           end
        end
      endcase 
      
      if (abort) begin
         c_state = IDLE;
      end

   end

   always@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         r_state <= IDLE;
         r_blt_index <= 0;
         r_blt_count <= 0;
      end
      else begin
         `UPDATE_FLOP(state);
         `UPDATE_FLOP(blt_index);
         `UPDATE_FLOP(blt_count);
      end
   end

   

   cr_xp10_decomp_htf_array_inc
     #(.DEPTH(MAX_BCT_DEPTH),
       .RANGE_BASE(1),
       .WIDTH(MAX_BCT_DEPTH),
       .NUM_INC_PORTS(BL_PER_CYCLE))
   bct_inst
     (
      
      .array                            (bct),                   
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .preload_en                       (bct_preload_en),        
      .preload_data                     (bct_data),              
      .inc_onehot                       (bct_inc_onehot));        

`undef DECLARE_FLOP
`undef DEFAULT_FLOP
`undef UPDATE_FLOP

endmodule 







