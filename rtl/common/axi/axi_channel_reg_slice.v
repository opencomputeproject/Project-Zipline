/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "axi_reg_slice_defs.vh"

module axi_channel_reg_slice(
   
   ready_src, valid_dst, payload_dst,
   
   aclk, aresetn, valid_src, payload_src, ready_dst
   );

   parameter PAYLD_WIDTH = 8;
   parameter HNDSHK_MODE = `AXI_RS_FULL;
   parameter BITS_PER_CHUNK = 8;
   localparam CHUNKS = (PAYLD_WIDTH+BITS_PER_CHUNK-1)/BITS_PER_CHUNK;

   input aclk;
   input aresetn;

   input valid_src;
   input [PAYLD_WIDTH-1:0] payload_src;
   output            ready_src;

   output            valid_dst;
   output [PAYLD_WIDTH-1:0] payload_dst;
   input              ready_dst;

   generate
      genvar          i;

      if (HNDSHK_MODE == `AXI_RS_FULL) begin: full
         reg              r_wptr, c_wptr;
         reg [CHUNKS-1:0] r_rptr, c_rptr;
         reg              r_full, c_full;
         reg              r_empty, c_empty;
         reg              r_enable;

         reg [PAYLD_WIDTH-1:0]  r_payload[1:0];

         assign ready_src = r_enable && !r_full;
         assign valid_dst = !r_empty;

         always_comb begin
            c_full = r_full;
            c_empty = r_empty;
            c_rptr = r_rptr;
            c_wptr = r_wptr;

            if (valid_dst && ready_dst) begin
               if (!r_full)
                 c_empty = 1'b1; 
               else
                 c_rptr = ~r_rptr;
               c_full = 1'b0;
            end

            if (valid_src && ready_src) begin
               if (!c_empty)
                 c_full = 1'b1;
               else
                 c_rptr = ~r_rptr; 
               c_empty = 1'b0;
               c_wptr = ~r_wptr;
            end

         end 

         for (i=0; i<CHUNKS; i++) begin
            if (i<CHUNKS-1) begin
               assign payload_dst[i*BITS_PER_CHUNK +: BITS_PER_CHUNK] = r_payload[r_rptr[i]][i*BITS_PER_CHUNK +: BITS_PER_CHUNK];
            end
            else begin
               assign payload_dst[i*BITS_PER_CHUNK +: PAYLD_WIDTH-(CHUNKS-1)*BITS_PER_CHUNK] = r_payload[r_rptr[i]][i*BITS_PER_CHUNK +: PAYLD_WIDTH-(CHUNKS-1)*BITS_PER_CHUNK];
            end
         end


         always_ff@(posedge aclk or negedge aresetn) begin
            if (!aresetn) begin
               r_empty <= 1'b1;
               r_rptr <= {CHUNKS{1'b1}};
               
               
               r_enable <= 1'h0;
               r_full <= 1'h0;
               r_wptr <= 1'h0;
               
            end
            else begin
               r_enable <= 1'b1;

               r_full <= c_full;
               r_empty <= c_empty;
               r_rptr <= c_rptr;
               r_wptr <= c_wptr;
            end
         end 

         
         always_ff@(posedge aclk) begin
            if (valid_src && ready_src)
              r_payload[r_wptr] <= payload_src;
         end
         
         
      end 
      else if (HNDSHK_MODE == `AXI_RS_REV) begin: rev
         reg [CHUNKS-1:0] r_full, c_full;
         reg [PAYLD_WIDTH-1:0]  r_payload;
         reg              r_enable;

         assign ready_src = r_enable && !r_full[0];
         assign valid_dst = r_full[0] || valid_src;
         
         always_comb begin
            
            if (valid_src && ready_src && !ready_dst)
              c_full = ({CHUNKS{1'b1}});
            else if (valid_dst && ready_dst && !valid_src)
              c_full = ({CHUNKS{1'b0}});
            else
              c_full = r_full;
            
         end 

         for (i=0; i<CHUNKS; i++) begin
            if (i<CHUNKS-1) begin
               assign payload_dst[i*8 +: 8] = r_full[i] ? r_payload[i*8 +: 8] : payload_src[i*8 +: 8];
            end
            else begin
               assign payload_dst[i*8 +: PAYLD_WIDTH-(CHUNKS-1)*8] = r_full[i] ? r_payload[i*8 +: PAYLD_WIDTH-(CHUNKS-1)*8] : payload_src[i*8 +: PAYLD_WIDTH-(CHUNKS-1)*8];
            end
         end

         always_ff@(posedge aclk or negedge aresetn) begin
            if (!aresetn) begin
               
               
               r_enable <= 1'h0;
               r_full <= 1'h0;
               
            end
            else begin
               r_enable <= 1'b1;

               r_full <= c_full;
            end
         end

         
         always_ff@(posedge aclk) begin
            if (valid_src && ready_src && !ready_dst)
              r_payload <= payload_src;
         end
         
         
      end 
      else if (HNDSHK_MODE == `AXI_RS_FWD) begin: fwd
         reg r_full, c_full;
         reg [PAYLD_WIDTH-1:0] r_payload;
         reg             r_enable;

         assign ready_src = r_enable && (!r_full || ready_dst);
         assign valid_dst = r_full;
         assign payload_dst = r_payload;

         always_comb begin
            if (valid_src && ready_src)
              c_full = 1'b1;
            else if (valid_dst && ready_dst)
              c_full = 1'b0;
            else
              c_full = r_full;
         end

         always_ff@(posedge aclk or negedge aresetn) begin
            if (!aresetn) begin
               
               
               r_enable <= 1'h0;
               r_full <= 1'h0;
               
            end
            else begin
               r_enable <= 1'b1;

               r_full <= c_full;
            end
         end

         
         always_ff@(posedge aclk) begin
            if (valid_src && ready_src)
              r_payload <= payload_src;
         end
         

      end 
      else begin: bypass

         assign ready_src = ready_dst;
         assign valid_dst = valid_src;
         assign payload_dst = payload_src;
         
      end
   endgenerate

endmodule 
