/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/



module nx_sp_sch
  #(N=8)
   (input                      clk,
    input                      rst_n,
    input                      enable,
    input [`BIT_VEC(N)]        req,
    output logic [`BIT_VEC(N)] grant);
   
   logic [`LOG_VEC(N+1)]        nxt_grant;

   function [`LOG_VEC(N+1)] sp_sel
     (input [`BIT_VEC(N)] ready);
      integer                  i;
      for (i=N-1; i >=0; i=i-1) begin
         if (ready[i] == 1'b1) begin
            return(i);
         end
      end
      return (N);
   endfunction : sp_sel

   always_comb
     begin
        grant =0;
        nxt_grant = sp_sel(req);
        if (enable) begin
           if (nxt_grant != N)
             grant[nxt_grant] = 1'b1;
        end
     end
   
endmodule 
