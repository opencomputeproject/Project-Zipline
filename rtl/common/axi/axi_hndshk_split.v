/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/


module axi_hndshk_split(
   
   ready_src, valid_dst,
   
   aclk, aresetn, valid_src, ready_dst
   );

   parameter N_OUTPUTS = 2;

   input aclk;
   input aresetn;

   input                  valid_src;
   output logic           ready_src;
   
   output logic [N_OUTPUTS-1:0] valid_dst;
   input [N_OUTPUTS-1:0]  ready_dst;
   
   logic [N_OUTPUTS-1:0]  r_done, c_done;

   always_comb begin
      c_done = r_done;

      ready_src = 0;
      valid_dst = '0;

      if (valid_src) begin
         for (int i=0; i<N_OUTPUTS; i++) begin
            if (!c_done[i]) begin
               
               
               valid_dst[i] = 1;
               if (ready_dst[i])
                 c_done[i] = 1;
            end
         end
         if (&c_done) begin
            
            ready_src = 1;
            c_done = 0;
         end
      end
   end

   always_ff@(posedge aclk or negedge aresetn) begin
      if (!aresetn) begin
         r_done <= 0;
      end
      else begin
         r_done <= c_done;
      end
   end

endmodule 
