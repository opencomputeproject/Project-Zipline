/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/





























`include "ccx_std.vh"
`include "messages.vh"

module nx_rr_arb
  #(N=8) 
   (input                clk,
    input                rst_n,

    input                enable,
    input [`BIT_VEC(N)]  req,
    output logic [`BIT_VEC(N)] grant);
   

   logic [`LOG_VEC(N+1)] last_r;
   logic [`LOG_VEC(N+1)] nxt_grant;
   
   function [`LOG_VEC(N+1)] rr_sel
     (input [`BIT_VEC(N)] ready,
      input [`LOG_VEC(N)] last);
      
      integer             ii;
      logic [`BIT_VEC(N)] hilo_v, hi_v, lo_v;

      
      
      hilo_v = {N{1'b1}} << last+1;

      
      hi_v =  hilo_v & ready;
      if (hi_v != 0)
        for (ii=0; ii<N; ii++)
          if (ii > last) begin
             if (hi_v[ii]) return(ii);
          end
      
      lo_v = ~hilo_v & ready;
      if (lo_v != 0)
        for (ii=0; ii<=last; ii++)
          if (lo_v[ii]) return(ii);

      
      return N;
   endfunction : rr_sel

   always @(posedge clk or negedge rst_n) 
     if (!rst_n)
       last_r <= 0;
     else
       if (enable)
         last_r <= nxt_grant;
   
   always_comb begin
      grant = 0;
      if (enable) 
        nxt_grant = rr_sel(req, last_r);
      else
        nxt_grant = N;
      
      if (nxt_grant != N) 
        grant[nxt_grant] = 1;
      else
        grant = 0;
      
   end
     
endmodule 
