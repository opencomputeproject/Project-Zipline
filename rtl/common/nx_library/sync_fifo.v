/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
module sync_fifo (
   
   dout, full, empty,
   
   clk, rst_n, din, wr_en, rd_en,
   space_avail

   );



parameter DATAWIDTH = 64;
parameter DEPTH = 16;
parameter RD_REG_MODE   = 1; 
parameter RD_LATCH_MODE = 1; 



localparam L2DEPTH = (DEPTH <= 2) ?   1 :
                     (DEPTH <= 4) ?   2 :
                     (DEPTH <= 8) ?   3 :
                     (DEPTH <= 16) ?  4 :
                     (DEPTH <= 32) ?  5 :
                     (DEPTH <= 64) ?  6 :
                     (DEPTH <= 128) ? 7 :
                                       8 ;
localparam PTRW = L2DEPTH+1;
localparam DW = DATAWIDTH;

input clk;
input rst_n;
input [DW-1:0] din;
input wr_en; 
input rd_en; 

output [DW-1:0] dout; 
output full;  
output empty; 
output [PTRW-1:0] space_avail; 




















wire [PTRW-1:0] wr_ptr_nxt;
wire [PTRW-1:0] rd_ptr_nxt;
reg  [PTRW-1:0] wr_ptr_r;
reg  [PTRW-1:0] rd_ptr_r;
wire            full_i;
wire            empty_i;


integer         i;



assign wr_ptr_nxt = (wr_en & (~full_i | rd_en))  ? ((func_check_next_ptr_eq_depth(wr_ptr_r[PTRW-2:0])) ? {~wr_ptr_r[PTRW-1],{(PTRW-1){1'b0}}} : 
                                                                                                         wr_ptr_r+1'b1) : wr_ptr_r;

assign rd_ptr_nxt = (rd_en & ~empty_i) ? ((func_check_next_ptr_eq_depth(rd_ptr_r[PTRW-2:0])) ? {~rd_ptr_r[PTRW-1],{(PTRW-1){1'b0}}} : 
                                                                                               rd_ptr_r+1'b1) : rd_ptr_r;

always  @ (posedge clk or negedge rst_n)
if (~rst_n)
  begin
     wr_ptr_r  <= 0;
     rd_ptr_r  <= 0;
  end  
else  
  begin
    wr_ptr_r  <= wr_ptr_nxt;
    rd_ptr_r  <= rd_ptr_nxt;
  end 


assign full_i  = (rd_ptr_r[PTRW-2:0] ==  wr_ptr_r[PTRW-2:0]) & (rd_ptr_r[PTRW-1] !=  wr_ptr_r[PTRW-1]);
assign empty_i = (rd_ptr_r[PTRW-1:0] ==  wr_ptr_r[PTRW-1:0]);


reg  [DW-1:0] mem_nxt[DEPTH-1:0];
reg  [DW-1:0] mem_r[DEPTH-1:0];

always @(*) begin
  for (i=0;i<DEPTH;i=i+1) begin
    if(wr_en & (~full_i | rd_en) & wr_ptr_r[PTRW-2:0] == i) 
       mem_nxt[i] = din; 
    else
       mem_nxt[i] = mem_r[i]; 
  end
end


always  @ (posedge clk or negedge rst_n)
if (~rst_n) begin
  for(i=0;i<DEPTH;i=i+1) begin
     mem_r[i] <= 0;
  end
end
else begin
  for(i=0;i<DEPTH;i=i+1) begin
    mem_r[i] <= mem_nxt[i];
  end
end


reg [DW-1:0] dout_i;

reg  [DW-1:0] dout_r;
wire [DW-1:0] default_data;

  
  generate 
    if(RD_LATCH_MODE==1) begin : GEN_RD_LATCH_MODE
      assign default_data = (rd_en == 0) ? dout_r : mem_r[0];
    end
    else begin
      assign default_data = mem_r[0]; 
    end
  endgenerate


reg hit_flag;
always @(*) begin

  
  hit_flag = 0;
  dout_i = default_data;


  
  for(i=0;i<DEPTH;i=i+1) begin
     if(rd_ptr_r[PTRW-2:0] == i & hit_flag == 0) begin
       dout_i = mem_r[i];
       hit_flag = 1;
     end
  end

end




generate 
  if(RD_REG_MODE==1) begin : GEN_RD_REG_MODE
    wire [DW-1:0] dout_nxt;

    assign dout_nxt = rd_en ? dout_i : dout_r;

    always  @ (posedge clk or negedge rst_n)
    if (~rst_n)
      dout_r <= 0;
    else  
      dout_r <= dout_nxt;
     
  end
endgenerate

generate 
  if(RD_REG_MODE==0) begin  : GEN_NO_RD_REG_MODE
    always  @ (*)
      dout_r  = dout_i;
  end
endgenerate
   


assign full  = full_i; 
assign empty = empty_i;
assign dout  = dout_r;  

assign space_avail = ($bits(space_avail))'((wr_ptr_r[PTRW-1] == rd_ptr_r[PTRW-1]) ? 
					   (DEPTH-(wr_ptr_r[L2DEPTH-1:0]-rd_ptr_r[L2DEPTH-1:0])) :
					   (rd_ptr_r[L2DEPTH-1:0]-wr_ptr_r[L2DEPTH-1:0]));

   

function func_check_next_ptr_eq_depth;
input [PTRW-2:0] cur_ptr;
reg  [PTRW-1:0] cur_ptr_nxt;
begin
   cur_ptr_nxt = {1'b0,cur_ptr} + 1;

   if(cur_ptr_nxt == DEPTH[PTRW-1:0])
     func_check_next_ptr_eq_depth = 1;
   else
     func_check_next_ptr_eq_depth = 0;

end
endfunction

endmodule  
