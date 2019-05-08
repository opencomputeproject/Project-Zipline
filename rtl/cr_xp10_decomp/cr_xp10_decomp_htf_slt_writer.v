/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "ccx_std.vh"
`include "cr_xp10_decomp.vh"

module cr_xp10_decomp_htf_slt_writer (
   
   slt_wen, slt_addr, slt_data, slt_last,
   
   clk, rst_n, pointer_wen, pointer_addr, pointer_data,
   pointer_complete, blt_depth, blt, abort
   );

   parameter MAX_BLT_DEPTH = 576;
   parameter MAX_POINTER_DEPTH = 27;
   parameter BL_PER_CYCLE = 2;
   
   
   
   input         clk;
   input         rst_n;    
   
   
   
   
   input                                 pointer_wen;
   input [`LOG_VEC(MAX_POINTER_DEPTH+1)] pointer_addr;
   input [`LOG_VEC(MAX_BLT_DEPTH)]       pointer_data;
   input                                 pointer_complete;

   
   
   
   input [`LOG_VEC(MAX_BLT_DEPTH+1)] blt_depth;
   input [`BIT_VEC(MAX_BLT_DEPTH)][`LOG_VEC(MAX_POINTER_DEPTH+1)] blt;

   
   
   
   output logic [`BIT_VEC(BL_PER_CYCLE)]                          slt_wen;
   output logic [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(MAX_BLT_DEPTH)] slt_addr;
   output logic [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(MAX_BLT_DEPTH)] slt_data;
   output logic                                                   slt_last;

   
   
   input                                  abort;

   
   
   
   
   
`define DECLARE_FLOP(name) r_``name, c_``name
`define DEFAULT_FLOP(name) c_``name = r_``name
`define UPDATE_FLOP(name) r_``name <= c_``name
   
   enum  logic {IDLE=0, WRITE=1}               `DECLARE_FLOP(state);
   logic [`LOG_VEC(MAX_BLT_DEPTH)]             `DECLARE_FLOP(blt_index);
   logic [`LOG_VEC(MAX_BLT_DEPTH+1)]             `DECLARE_FLOP(blt_count);
   
   logic [`BIT_VEC_BASE(MAX_POINTER_DEPTH, 1)] pointer_preload_en;
   logic [`BIT_VEC_BASE(MAX_POINTER_DEPTH, 1)] pointer_inc_onehot[BL_PER_CYCLE];
   logic [`BIT_VEC_BASE(MAX_POINTER_DEPTH, 1)][`LOG_VEC(MAX_BLT_DEPTH)] pointer;

   
   
   
   logic [`BIT_VEC(((MAX_BLT_DEPTH+BL_PER_CYCLE-1)/BL_PER_CYCLE)*BL_PER_CYCLE*$clog2(MAX_POINTER_DEPTH+1))] blt_padded; 


   assign blt_padded = ($bits(blt_padded))'(blt);

   always_comb begin
      logic [`BIT_VEC(BL_PER_CYCLE)][`LOG_VEC(MAX_POINTER_DEPTH+1)] bl;

      `DEFAULT_FLOP(state);
      `DEFAULT_FLOP(blt_index);
      `DEFAULT_FLOP(blt_count);

      
      
      
      
      
      
      
      
      

      slt_wen = 0;
      slt_last = 0;
      pointer_inc_onehot = '{default: 0};
      bl = blt_padded[r_blt_index*$clog2(MAX_POINTER_DEPTH+1) +: BL_PER_CYCLE*$clog2(MAX_POINTER_DEPTH+1)]; 
      
      for (int i=0; i<BL_PER_CYCLE; i++) begin
         slt_addr[i] = pointer[bl[i]]; 
         for (int j=i-1; j>= 0; j--)
           slt_addr[i] += (bl[i] == bl[j]); 
         slt_data[i] = $bits(r_blt_index)'(r_blt_index+i);
      end

      pointer_preload_en = '0;
      pointer_preload_en[pointer_addr] = pointer_wen; 
      
      case (r_state)
        IDLE: begin
           if (pointer_complete) begin
              
              c_state = WRITE;
              c_blt_index = 0;
              c_blt_count = blt_depth;
           end
        end
        WRITE: begin
           logic [`BIT_VEC(BL_PER_CYCLE)] v_slt_wen_mask;

           v_slt_wen_mask = ~('1 << r_blt_count);
           assert #0 (!pointer_wen) else `ERROR("pointers should NOT get initialized while SLT is being written");
           assert #0 (!pointer_complete) else `ERROR("pointers should NOT be completed while SLT is being written");
           for (int i=0; i<BL_PER_CYCLE; i++) begin
              if ((bl[i] != 0) && v_slt_wen_mask[i]) begin
                 slt_wen[i] = 1;
                 
                 
                 pointer_inc_onehot[i][bl[i]] = 1; 
              end
           end
           
           if (r_blt_count <= BL_PER_CYCLE) begin
              
              c_blt_index = 0;
              c_state = IDLE;
              slt_last = 1;
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
     #(.DEPTH(MAX_POINTER_DEPTH),
       .RANGE_BASE(1),
       .WIDTH($clog2(MAX_BLT_DEPTH)),
       .NUM_INC_PORTS(BL_PER_CYCLE))
   pointer_inst
     (
      
      .array                            (pointer),               
      
      .clk                              (clk),
      .rst_n                            (rst_n),
      .preload_en                       (pointer_preload_en),    
      .preload_data                     (pointer_data),          
      .inc_onehot                       (pointer_inc_onehot));    

`undef DECLARE_FLOP
`undef DEFAULT_FLOP
`undef UPDATE_FLOP

endmodule 







