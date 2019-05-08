/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
module cr_adler
    (
   
   adler_out,
   
   clk, rst_n, data_in, bytes_valid, sof
   );
   
   input               clk;
   input               rst_n;
   
   input [63:0]        data_in;
   input [7:0]         bytes_valid;
   input               sof;
   
   output logic [31:0] adler_out;
   int                 i;
   
   logic [7:0]         data_arr[8];
   logic [15:0]        b_out;
   logic [15:0]        a_int_out[8];
   logic [15:0]        r_a_out;
   logic [15:0]        r_a_int_out[8];
   logic [15:0]        r_b_out;
   logic [7:0]         r_bytes_valid;
   logic [16:0]        a_tmp_out;
   logic [19:0]        b_tmp_out;
   logic               val_sof;

   assign val_sof = ((sof) && (bytes_valid != 0)) ? 1'b1 : 1'b0;
   
   always_comb begin
      b_out = r_b_out;
      for (i=0; i < 8; i++) begin
         data_arr[i] = data_in[i*8 +:8];
      end
      a_tmp_out = (val_sof) ? 17'b1 : {1'b0, r_a_out};
      b_tmp_out = (val_sof) ? '0 : {4'b0, r_b_out};
      
      for (int i=0; i < 8; i++) begin
         a_int_out[i] = '0;
         if (bytes_valid[i]) begin
            a_tmp_out = data_arr[i] + a_tmp_out; 
            a_int_out[i] = a_tmp_out % 65521;
         end
         if (r_bytes_valid[i]) begin
            b_tmp_out = (r_a_int_out[i] + b_tmp_out); 
         end
      end
      b_out = b_tmp_out % 65521;
   end
        
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         r_a_int_out[0] <= 16'h0;
         r_a_int_out[1] <= 16'h0;
         r_a_int_out[2] <= 16'h0;
         r_a_int_out[3] <= 16'h0;
         r_a_int_out[4] <= 16'h0;
         r_a_int_out[5] <= 16'h0;
         r_a_int_out[6] <= 16'h0;
         r_a_int_out[7] <= 16'h0;
         r_a_out <= '0;
         
         
         r_b_out <= 16'h0;
         r_bytes_valid <= 8'h0;
         
      end
      else begin
         if (val_sof) begin
           r_b_out <= 16'h0;
         end
           
         if (bytes_valid != 0)
           r_a_out <= a_int_out[7]; 
         
         r_a_int_out <= a_int_out;
         if (r_bytes_valid != 0)
           r_b_out <= b_out;
         r_bytes_valid <= bytes_valid;
      end
   end
         
   always_comb begin
         case(r_bytes_valid)                
           8'b00000001 :adler_out     = {b_out, r_a_int_out[0]};
           8'b00000011 :adler_out     = {b_out, r_a_int_out[1]};
           8'b00000111 :adler_out     = {b_out, r_a_int_out[2]};
           8'b00001111 :adler_out     = {b_out, r_a_int_out[3]};
           8'b00011111 :adler_out     = {b_out, r_a_int_out[4]};
           8'b00111111 :adler_out     = {b_out, r_a_int_out[5]};
           8'b01111111 :adler_out     = {b_out, r_a_int_out[6]};
           8'b11111111 :adler_out     = {b_out, r_a_int_out[7]};
           default     :adler_out     = {b_out, r_a_int_out[7]};
        endcase 

      
   end 
endmodule 
