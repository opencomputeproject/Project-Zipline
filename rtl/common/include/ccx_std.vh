/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`ifndef _CCX_STD_VH
 `define _CCX_STD_VH


 `define MAX(a,b) \
    (((a)>(b))?(a):(b))
 `define MIN(a,b) \
    (((a)<(b))?(a):(b))
 `define CEIL_DIV(a, b) \
    (((a)+(b)-1)/(b))



 `define NDXLIM(a,b) a[`MIN(`MAX((b),$low(a)),$high(a))] 

 `define msb(a) (a[$high(a)]) 
 `define lsb(a) (a[$low(a)])  

 `define LOG_VEC(a) `MAX(0, ($clog2(a)-1)):0
 `define BIT_VEC_BASE(a, base) `MAX(base, ((a)+(base)-1)):(base)
 `define BIT_VEC(a) `BIT_VEC_BASE(a, 0)
 `define ARRAY(a)   0:`MAX(0, ((a)-1))

 `define BYTES(t) ($bits(t)/8)

 `define ERROR_IF_EQ(str,a,b) if ((a)==(b)) `ERROR(str, a, b)
 `define ERROR_IF_NE(str,a,b) if ((a)!=(b)) `ERROR(str, a, b)

 `define ZEXT(n,a) {{n-$bits(a){1'b0}}, (a)}


 `define ROTATE_LEFT(a, b) ($bits(a))'(({2{a}} << (b)) >> $bits(a))

 `define ROTATE_RIGHT(a, b) ($bits(a))'({2{a}} >> (b))

 `define _GET_STRUCT_FIELD_OFFSET(lh, typ, field, msb, reverse) \
do begin \
   typ t; \
   t = '0; \
   t.field = '1; \
   lh = 0; \
   for (int i=0; i<$bits(typ); i++) begin \
      if (t[msb?($bits(typ)-1-i):i]) \
        break; \
      else \
        lh++; \
   end \
   if (msb!=reverse) \
     lh = $bits(typ)-1-lh; \
end while (0)


`define GET_STRUCT_FIELD_OFFSET(lh, typ, field) `_GET_STRUCT_FIELD_OFFSET(lh, typ, field, 0, 0)

`define GET_STRUCT_FIELD_OFFSET_MSB(lh, typ, field) `_GET_STRUCT_FIELD_OFFSET(lh, typ, field, 1, 0)

`define GET_STRUCT_FIELD_OFFSET_REV(lh, typ, field) `_GET_STRUCT_FIELD_OFFSET(lh, typ, field, 0, 1)

`define GET_STRUCT_FIELD_OFFSET_MSB_REV(lh, typ, field) `_GET_STRUCT_FIELD_OFFSET(lh, typ, field, 1, 1)




`define CCX_STD_DECLARE_CRC(NAME,POLY,CW,DW)              \
function logic [`BIT_VEC(CW)] NAME                        \
  (input [`BIT_VEC(DW)]   data,                           \
   input [`BIT_VEC(CW)]   crc,                            \
   input [`LOG_VEC(DW+1)] bits);                          \
   logic [`BIT_VEC(CW)]   shifted_poly;                   \
   shifted_poly = POLY;                                   \
   data ^= $bits(data)'(crc);                             \
   data = `ROTATE_RIGHT(data, bits) & ~('1 >> bits);      \
   NAME = `ROTATE_RIGHT(crc, bits) & ('1 >> bits);        \
   for (int ii=DW-1; ii>=0; ii--) begin                   \
      NAME ^= {CW{data[ii]}} & shifted_poly;              \
      shifted_poly = CW'(shifted_poly >> 1) ^             \
                     ({CW{shifted_poly[0]}} & POLY);      \
   end                                                    \
   return NAME;                                           \
endfunction : NAME 


`define CCX_STD_DECLARE_PRICOD(NAME, N)                                 \
function [N-1:0] NAME;                                                  \
                                   \
                            \
                                     \
                                    \
   input [N-1:0]  A;                                                    \
   reg [N-1:0]    cod;                                                  \
   cod = '0;                                                            \
   for (int i=0; i<N; i++) begin                                        \
      if (A[i]) begin                                                   \
         cod = 1 << i;                                                  \
      end                                                               \
   end                                                                  \
   NAME = cod;                                                          \
endfunction : NAME


 `define CCX_STD_DECLARE_PRI_LO2HI_SEL(NAME, N)                         \
function [`LOG_VEC(N+1)] NAME;                                          \
                                   \
                            \
                                       \
                                    \
   input [`BIT_VEC(N)] A;                                               \
   for (int ii=0; ii<N; ii++)                                           \
     if (A[ii]) return(ii);                                             \
   return -1;                                                           \
endfunction : NAME


 `define CCX_STD_DECLARE_RR_LO2HI_SEL(NAME, N)                          \
 `CCX_STD_DECLARE_PRI_LO2HI_SEL(NAME``_pri_lo2hi_sel, N)                \
function [`LOG_VEC(N+1)] NAME                                           \
   (input [`BIT_VEC(N)] ready,                                          \
    input [`LOG_VEC(N)] offset,                                         \
    input               last);                                          \
   logic [`BIT_VEC(N)]  hilo_v, hi_v, lo_v;                             \
   logic [`LOG_VEC(N+1)] sel_v;                                         \
   hilo_v = ~(N'(last)) << offset;                                      \
   hi_v = ready & hilo_v;                                               \
   lo_v = ready & ~hilo_v;                                              \
   sel_v = NAME``_pri_lo2hi_sel(hi_v);                                  \
   if (hi_v != '0)                                                      \
     return sel_v;                                                      \
   else                                                                 \
     return NAME``_pri_lo2hi_sel(lo_v);                                 \
endfunction : NAME

  
 `define CCX_STD_DECLARE_PRI_HI2LO_SEL(NAME, N)                         \
function [`LOG_VEC(N+1)] NAME;                                          \
   input [`BIT_VEC(N)] A;                                               \
   for (int ii=N-1; ii>=0; ii--)                                        \
     if (A[ii]) return(ii);                                             \
   return -1;                                                           \
endfunction : NAME


 `define CCX_STD_DECLARE_RR_HI2LO_SEL(NAME, N)                          \
 `CCX_STD_DECLARE_PRI_HI2LO_SEL(NAME``_pri_hi2lo_sel, N)                \
function [`LOG_VEC(N+1)] NAME                                           \
   (input [`BIT_VEC(N)] ready,                                          \
    input [`LOG_VEC(N)] offset,                                         \
    input               last);                                          \
   logic [`BIT_VEC(N)]  hilo_v, hi_v, lo_v;                             \
   logic [`LOG_VEC(N+1)] sel_v;                                         \
   hilo_v = ~(N'(!last)) << offset;                                     \
   hi_v = ready & hilo_v;                                               \
   lo_v = ready & ~hilo_v;                                              \
   sel_v = NAME``_pri_hi2lo_sel(lo_v);                                  \
   if (lo_v != '0)                                                      \
     return sel_v;                                                      \
   else                                                                 \
     return NAME``_pri_hi2lo_sel(hi_v);                                 \
endfunction : NAME

                   
`define CCX_STD_CALC_BIP2(NAME, N_BITS)                                \
function [1:0] NAME;                                                   \
   input [N_BITS-1:0] data_in;                                         \
   int                        evn, odd;                                \
   int                        i;                                       \
   logic [1:0]                par;                                     \
    evn = 0;                                                           \
         odd = 0;                                                      \
         for (i=0; i < N_BITS; i=i+2) begin                            \
            if (data_in[i] == 1'b1)                                    \
              evn++;                                                   \
         end                                                           \
         for (i=1; i < N_BITS; i=i+2) begin                            \
            if (data_in[i] == 1'b1)                                    \
              odd++;                                                   \
         end                                                           \
                                                                       \
         if ((evn % 2) > 0)                                            \
           par[0] = 1'b1;                                              \
         else                                                          \
           par[0] = 1'b0;                                              \
                                                                       \
         if ((odd %2) > 0)                                             \
           par[1] = 1'b1;                                              \
         else                                                          \
           par[1] = 1'b0;                                              \
           NAME = par;                                                 \
   endfunction : NAME                   



`define CCX_STD_DECLARE_ADLER32(NAME, N_BITS)                          \
function [31:0] NAME;                                                  \
   input [N_BITS-1:0] data_in;                                         \
   input [31:0] adler_in;                                              \
   input [N_BITS/8-1:0] bytes_valid;                                   \
                                                                       \
   logic [15:0] a_out;                                                 \
   logic [15:0] b_out;                                                 \
   logic [31:0] ad32;                                                  \
   logic [16:0] a_out_int ;\
   logic [16:0]  b_out_int;\
   logic [7:0] data_arr[N_BITS/8];                                     \
   `define ADLER_BASE 65521                                            \
   int i;                                                              \
   begin                                                               \
    for (i=0; i < N_BITS/8; i++) begin                                 \
         data_arr[i] = data_in[i*8 +:8];                               \
      end                                                              \
     a_out_int = {1'b0, adler_in[15:0] };                              \
     b_out_int = {1'b0, adler_in[31:16]};                              \
     for (i=0; i < N_BITS/8; i++) begin                                \
         if (bytes_valid[i]) begin                                     \
            a_out_int  = (data_arr[i] + a_out_int) ;                   \
            b_out_int  = (a_out + b_out_int);                          \
         end                                                           \
     end                                                               \
    a_out  = a_out_int % `ADLER_BASE;                                  \
    b_out  = b_out_int % `ADLER_BASE;                                  \
    ad32  = {b_out,a_out};                                             \
    NAME  = ad32;                                                      \
   end                                                                 \
endfunction : NAME                     

`ifdef SPYGLASS
 `define CLOCKING_DISABLE(clk, rst_n)
`else
 `define CLOCKING_DISABLE(clk, rst_n)  @(posedge clk) disable iff (rst_n!==1) 
`endif

 `define ASSERT_PROPERTY_CLK_RST(clk, rst_n, prop) \
     assert property (`CLOCKING_DISABLE(clk, rst_n) (prop)) 
     
 `define ASSERT_PROPERTY(prop) `ASSERT_PROPERTY_CLK_RST(clk, rst_n, prop) 

     
 `define ASSUME_PROPERTY_CLK_RST(clk, rst_n, prop) \
     assume property (`CLOCKING_DISABLE(clk, rst_n) (prop))  
     
 `define ASSUME_PROPERTY(prop) `ASSUME_PROPERTY_CLK_RST(clk, rst_n, prop) 

     
 `define COVER_PROPERTY_CLK_RST(clk, rst_n, prop) \
     cover property (`CLOCKING_DISABLE(clk, rst_n) (prop))  
     
 `define COVER_PROPERTY(prop) `COVER_PROPERTY_CLK_RST(clk, rst_n, prop) 

     
 `define _debug_output output
`endif
