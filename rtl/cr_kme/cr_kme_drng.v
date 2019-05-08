/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_drng (
   
   drng_health_fail, drng_seed_expired, drng_256_out, drng_valid,
   seed0_invalidate, seed1_invalidate, stat_drbg_reseed, drng_idle,
   
   clk, rst_n, drng_ack, seed0_valid, seed0_internal_state_key,
   seed0_internal_state_value, seed0_reseed_interval, seed1_valid,
   seed1_internal_state_key, seed1_internal_state_value,
   seed1_reseed_interval
   );



    `include "cr_kme_body_param.v"

    
    
    
    input           clk;
    input           rst_n;

    
    
    
    output  	    drng_health_fail;
    output          drng_seed_expired;
    output [127:0]  drng_256_out;
    output          drng_valid;
    input           drng_ack;

    
    
    
    input           seed0_valid;
    input  [255:0]  seed0_internal_state_key;
    input  [127:0]  seed0_internal_state_value;
    input   [47:0]  seed0_reseed_interval;
    input           seed1_valid;
    input  [255:0]  seed1_internal_state_key;
    input  [127:0]  seed1_internal_state_value;
    input   [47:0]  seed1_reseed_interval;
    output          seed0_invalidate;
    output          seed1_invalidate;

    
    
    
    output stat_drbg_reseed;

    
    
    
    output drng_idle;


    reg [127:0]  drng_256_last;
    reg 	 drng_health_fail;
    reg 	 drng_first;
    reg  [0:0]   seed_entry;
    wire [383:0] seed [1:0];
    wire [47:0]  seed_life [1:0];
    wire [0:0]   seed_valid [1:0];
    wire         seed_expired;
    wire 	 drng_health_test;
    wire [127:0] drng_256_out_pre;

    assign drng_256_out = drng_health_test ? 128'd0 : drng_256_out_pre;
   

    


    cr_kme_aes_256_drng 
    drng(
        
        .seed_expired       (seed_expired),
        .drng_valid         (drng_valid),
        .drng_256_out       (drng_256_out_pre),
        .drng_fifo_overflow (),
        .drng_fifo_underflow(),
        .drng_idle          (drng_idle),
        
        .start              (seed_valid[seed_entry]),
        .seed               (seed[seed_entry]),
        .seed_life          (seed_life[seed_entry]),
        .drng_ack           (drng_ack),
        .clk                (clk),
        .rst_n              (rst_n)
    );

    
    
    
   always_ff @ (posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         seed_entry       <= 1'b0;
	 drng_256_last    <= 48'd0;
	 drng_first       <= 1'b0;
	 drng_health_fail <= 1'd0;
      end
      else begin
         if (drng_ack) begin
	    drng_first          <= 1'b1;
	    drng_256_last       <= drng_256_out;
	    if (drng_first && (drng_256_last == drng_256_out)) begin
	       drng_health_fail <= 1'b1;
	    end
	    else begin
	       drng_health_fail <= 1'b0;
	    end
	 end
	 if (seed_valid[seed_entry]) begin
	    case (seed_entry)
	      1'b0: if (seed0_invalidate) seed_entry <= seed_entry + 1'b1;
	      1'b1: if (seed1_invalidate) seed_entry <= seed_entry + 1'b1;
            endcase
         end else if (seed0_valid|seed1_valid) begin
            seed_entry <= seed_entry + 1'b1;
         end
      end 
   end    
   

    assign seed[0] = {seed0_internal_state_key, seed0_internal_state_value};
    assign seed[1] = {seed1_internal_state_key, seed1_internal_state_value};

    assign seed_life[0]  = seed0_reseed_interval;
    assign seed_life[1]  = seed1_reseed_interval;

    assign seed_valid[0] = seed0_valid;
    assign seed_valid[1] = seed1_valid;

    assign seed0_invalidate = seed0_valid & seed_expired & (seed_entry == 1'b0);
    assign seed1_invalidate = seed1_valid & seed_expired & (seed_entry == 1'b1);

    assign drng_seed_expired = ~(seed0_valid | seed1_valid);

    assign stat_drbg_reseed = seed0_invalidate | seed1_invalidate;

    assign drng_health_test = (seed_life[seed_entry] == 48'hffff_ffff_ffff);
   


endmodule









 
