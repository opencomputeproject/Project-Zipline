/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/






















module nx_ipchecksum
   (
   
   checksum,
   
   clk, rst_n, word_0, word_1, word_2, word_3, word_4, word_5, word_6,
   word_7, word_8
   );

   input clk;
   input rst_n;
   input [15:0] word_0;
   input [15:0] word_1;
   input [15:0] word_2;
   input [15:0] word_3;
   input [15:0] word_4;
   input [15:0] word_5;
   input [15:0] word_6;
   input [15:0] word_7;
   input [15:0] word_8;

   output [15:0] checksum;
   reg [15:0]    checksum;
   reg [19:0] 	 checksum_sum;
   reg [20:0] 	 checksum_carry;
 
   wire [15:0]   isum_0   = (word_0 ^ word_1 ^ word_2);
   wire [16:0]   icarry_0 = {(word_0 & word_1 |
                              word_0 & word_2 | 
                              word_1 & word_2), 1'b0};

   wire [15:0]   isum_1   = (word_3 ^ word_4 ^ word_5);
   wire [16:0]   icarry_1 = {(word_3 & word_4 |
                              word_3 & word_5 | 
                              word_4 & word_5), 1'b0};

   wire [15:0]   isum_2   = (word_6 ^ word_7 ^ word_8);
   wire [16:0]   icarry_2 = {(word_6 & word_7 |
                              word_6 & word_8 | 
                              word_7 & word_8), 1'b0};

   wire [15:0]   jsum_0 = (isum_0 ^ isum_1 ^ isum_2);
   wire [16:0]   jcarry_0 = {(isum_0 & isum_1 |
                              isum_0 & isum_2 | 
                              isum_1 & isum_2), 1'b0};

   wire [16:0]   jsum_1 = (icarry_0 ^ icarry_1 ^ icarry_2);
   wire [17:0]   jcarry_1 = {(icarry_0 & icarry_1 |
                              icarry_0 & icarry_2 | 
                              icarry_1 & icarry_2), 1'b0};

   wire [16:0]   ksum_0 = {1'b0, jsum_0} ^ jsum_1 ^ jcarry_0;
   wire [17:0]   kcarry_0 = {({1'b0, jsum_0} & jsum_1 |
                              {1'b0, jsum_0} & jcarry_0 |
                              jsum_1 & jcarry_0), 1'b0};

   wire [17:0]   lsum_0 = {1'b0, ksum_0} ^ kcarry_0 ^ jcarry_1;
   wire [18:0]   lcarry_0 = {({1'b0, ksum_0}     &  kcarry_0 |
                              {1'b0, ksum_0}     &  jcarry_1 |
                               kcarry_0          &  jcarry_1), 1'b0};

   wire [19:0]   r_checksum_sum   = ({2'b00,lsum_0[17:0]} ^ 
				     {1'b0,lcarry_0[18:0]});
   wire [20:0]   r_checksum_carry = {({2'b00,lsum_0[17:0]} & 
				      {1'b0,lcarry_0[18:0]}),1'b0};


   wire [16:0] 	 checksum_pre   = (checksum_sum[15:0] + 
				   checksum_carry[15:0]);

   wire [5:0] 	 checksum_hi_plus0 = ({1'b0, checksum_sum[19:16]} + 
				      checksum_carry[20:16]);
   wire [5:0] 	 checksum_hi_plus1 = ({1'b0, checksum_sum[19:16]} + 
				      checksum_carry[20:16] + 1'b1);
   wire [5:0] 	 checksum_hi_plus2 = ({1'b0, checksum_sum[19:16]} + 
				      checksum_carry[20:16] + 2'b10);
   
   wire [17:0]   checksum_unabridged       = (checksum_pre[16:0] + 
					      {11'd0, checksum_hi_plus0[5:0]});
   wire [17:0]   checksum_unabridged_plus1 = (checksum_pre[16:0] + 
					      {11'd0, checksum_hi_plus1[5:0]});
   wire [17:0]   checksum_unabridged_plus2 = (checksum_pre[16:0] + 
					      {11'd0, checksum_hi_plus2[5:0]});
   
   always@(checksum_unabridged
	   or checksum_unabridged_plus1 or checksum_unabridged_plus2)
   begin
      case (checksum_unabridged[17:16])
        2'b00: checksum = ~checksum_unabridged[15:0];
        2'b01: checksum = ~checksum_unabridged_plus1[15:0];
        2'b10: checksum = ~checksum_unabridged_plus2[15:0];
        2'b11: checksum = 16'hxxxx;
      endcase 
   end
   
   always@(posedge clk or negedge rst_n)
   begin
      if (!rst_n)
      begin
         checksum_sum 	   <= 0;
         checksum_carry    <= 0;
      end
      else
      begin
         checksum_sum 	   <= r_checksum_sum;
         checksum_carry    <= r_checksum_carry;
      end
   end 
   
   
endmodule 
