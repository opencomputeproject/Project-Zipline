/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
module cr_xp10_decomp_lz77_pl (
   
   lz_fhp_pre_prefix_ready, lz_fhp_usr_prefix_ready,
   lz_fhp_prefix_hdr_ready, pl_hb_pfx0_pld_wr, pl_hb_pfx0_pld_waddr,
   pl_hb_pfx0_pld_wdata, pl_hb_pfx1_pld_wr, pl_hb_pfx1_pld_waddr,
   pl_hb_pfx1_pld_wdata, pl_hb_pfx2_pld_wr, pl_hb_pfx2_pld_waddr,
   pl_hb_pfx2_pld_wdata, pl_hb_usr_wr, pl_hb_usr_wdata,
   pl_hb_usr_waddr, pl_ep_prefix_cnt, pl_ep_prefix_load,
   pl_ep_trace_bit, pl_hb_pfx0_in_use, pl_hb_pfx1_in_use,
   pl_hb_pfx2_in_use, pl_ag_load_tail, pl_ag_tail_ptr,
   
   clk, rst_n, fhp_lz_prefix_valid, fhp_lz_prefix_dp_bus,
   fhp_lz_prefix_hdr_valid, fhp_lz_prefix_hdr_bus, ag_pl_eof
   );
   
   import crPKG::lz_symbol_bus_t;
   import cr_xp10_decomp_regsPKG::*;
   import cr_xp10_decompPKG::*;
    
   input                               clk;
   input                               rst_n;
   
   output logic                        lz_fhp_pre_prefix_ready;
   output logic                        lz_fhp_usr_prefix_ready;
   input                               fhp_lz_prefix_valid;
   input fhp_lz_prefix_dp_bus_t        fhp_lz_prefix_dp_bus;
   
   output logic                        lz_fhp_prefix_hdr_ready;
   input                               fhp_lz_prefix_hdr_valid;
   input fhp_lz_prefix_hdr_bus_t       fhp_lz_prefix_hdr_bus;
   
   input                               ag_pl_eof;
   
   output logic                        pl_hb_pfx0_pld_wr;
   output logic [5:0]                  pl_hb_pfx0_pld_waddr;
   output logic [127:0]                pl_hb_pfx0_pld_wdata;
   
   output logic                        pl_hb_pfx1_pld_wr;
   output logic [5:0]                  pl_hb_pfx1_pld_waddr;
   output logic [127:0]                pl_hb_pfx1_pld_wdata;

   output logic                        pl_hb_pfx2_pld_wr;
   output logic [5:0]                  pl_hb_pfx2_pld_waddr;
   output logic [127:0]                pl_hb_pfx2_pld_wdata;

   output logic                        pl_hb_usr_wr;
   output logic [127:0]                pl_hb_usr_wdata;
   output logic [11:0]                 pl_hb_usr_waddr;
   
   output logic [16:0]                 pl_ep_prefix_cnt;
   output logic                        pl_ep_prefix_load;
   output logic                        pl_ep_trace_bit;
   
   output logic                        pl_hb_pfx0_in_use;
   output logic                        pl_hb_pfx1_in_use;
   output logic                        pl_hb_pfx2_in_use;

   output logic                        pl_ag_load_tail;
   output logic [12:0]                 pl_ag_tail_ptr;
   
   logic                               pfx0_avail;
   logic                               pfx1_avail;
   logic                               pfx2_avail;

   logic                               pfx0_in_use;
   logic                               pfx1_in_use;
   logic                               pfx2_in_use;

   logic                               hdr_wr;
   logic                               hdr_rd;
   logic                               data_wr;
   logic                               data_rd;
   logic                               hdr_empty;
   logic                               data_empty;
   
   logic [10:0]                         hdr_wr_data;
   logic [10:0]                         hdr_rd_data;

   logic [10:0]                         data_wr_data;
   logic [10:0]                         data_rd_data; 

   logic [10:0]                         hold_wr_data;
   logic [10:0]                         hold_rd_data;
   logic                                pfx0_load;
   logic                                pfx1_load;
   logic                                pfx2_load;
   logic                                pfx_load;
   logic                                space_avail;
   logic                                wr_data;
   logic                                r_last;
   
   logic [1:0]                          cnt;
   logic                                tgl;
   logic [5:0]                          blk_cnt;
   logic [4:0]                          l_cnt;
   
   logic                                rr_last;
   logic [63:0]                         r_data_3;
   logic [63:0]                         r_data_2;
   logic [63:0]                         r_data_1;
   logic [63:0]                         r_data_0;
   logic [63:0]                         rr_data_0; 
   logic                                prefix_avail;

   logic                                hold_empty;
   logic                                hold_rd;
   logic                                pfx0_avail_load;
   logic                                pfx1_avail_load;
   logic                                pfx2_avail_load;
   logic                                pfx0_done;
   logic                                pfx1_done;
   logic                                pfx2_done;
   logic                                hold_wr;
   
   assign lz_fhp_usr_prefix_ready = hdr_empty && data_empty && hold_empty;
   
   assign lz_fhp_pre_prefix_ready = ((!pfx_load && hdr_empty && prefix_avail) ||
                                     (pfx_load && space_avail));

   assign lz_fhp_prefix_hdr_ready = hdr_empty;
   
   assign pl_hb_pfx0_in_use = pfx0_in_use;
   assign pl_hb_pfx1_in_use = pfx1_in_use;
   assign pl_hb_pfx2_in_use = pfx2_in_use;
   assign pfx_load = pfx0_load || pfx1_load || pfx2_load;

   assign prefix_avail = (pfx0_avail || pfx1_avail || pfx2_avail) ? 1'b1 : 1'b0;

   always_comb
     begin
        pfx0_avail_load = 1'b0;
        pfx1_avail_load = 1'b0;
        pfx2_avail_load = 1'b0;
        pfx0_done = 1'b0;
        pfx1_done = 1'b0;
        pfx2_done = 1'b0;
        
        if (fhp_lz_prefix_valid && fhp_lz_prefix_dp_bus.sof) begin
           if (pfx0_avail)
              pfx0_avail_load = 1'b1;
           else if (pfx1_avail)
             pfx1_avail_load = 1'b1;
           else if (pfx2_avail)
             pfx2_avail_load = 1'b1;
        end
        if (data_rd && (data_rd_data[9:0] !=0)) begin
           if (data_rd_data[1:0] == 2'b0)
             pfx0_done = 1'b1;
           
           if (data_rd_data[1:0] == 2'b01)
             pfx1_done = 1'b1;
           
           if (data_rd_data[1:0] == 2'b10)
             pfx2_done = 1'b1;
        end
     end
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         blk_cnt <= 0;
         cnt <= 0;
         l_cnt <= 0;
         pl_hb_pfx0_pld_waddr <= 0;
         pl_hb_pfx0_pld_wdata <= 0;
         pl_hb_pfx0_pld_wr <= 0;
         pl_hb_pfx1_pld_waddr <= 0;
         pl_hb_pfx1_pld_wdata <= 0;
         pl_hb_pfx1_pld_wr <= 0;
         pl_hb_pfx2_pld_waddr <= 0;
         pl_hb_pfx2_pld_wdata <= 0;
         pl_hb_pfx2_pld_wr <= 0;
         pl_hb_usr_waddr <= 0;
         pl_hb_usr_wdata <= 0;
         pl_hb_usr_wr <= 0;
         r_data_0 <= 0;
         r_data_1 <= 0;
         r_data_2 <= 0;
         r_data_3 <= 0;
         r_last <= 0;
         rr_data_0 <= 0;
         rr_last <= 0;
         tgl <= 0;
         wr_data <= 0;
         
      end
      else begin
         if ((cnt == 3) && fhp_lz_prefix_valid) 
           wr_data <= 1'b1;
         else
           wr_data <= 1'b0;

         if (wr_data) begin
            tgl <= 1'b1;
            rr_data_0 <= r_data_0;
         end
         else
           tgl <= 1'b0;

         if (fhp_lz_prefix_valid) begin
            if (fhp_lz_prefix_dp_bus.last)
              cnt <= 2'b0;
            else
              cnt <= cnt + 1;
            case (cnt) 
               2'b00  : r_data_0 <= fhp_lz_prefix_dp_bus.data;
               2'b01  : r_data_1 <= fhp_lz_prefix_dp_bus.data;
               2'b10  : r_data_2 <= fhp_lz_prefix_dp_bus.data;
               2'b11  : r_data_3 <= fhp_lz_prefix_dp_bus.data;
            endcase
         end
         
         if (hdr_rd)
           r_last <= 1'b0;
         else if (fhp_lz_prefix_valid && fhp_lz_prefix_dp_bus.last) begin
            r_last <= 1'b1;
         end
         rr_last <= r_last;
        
         if (wr_data && !space_avail) begin
            pl_hb_usr_wr <= 1'b1;
            pl_hb_usr_wdata <= {r_data_3[31:0],r_data_2[31:0],
                                r_data_1[31:0],r_data_0[31:0]};
            pl_hb_usr_waddr <= (blk_cnt * 64) + l_cnt; 
         end
         else if (tgl && !space_avail) begin
            pl_hb_usr_wr <= 1'b1;
            pl_hb_usr_wdata <= {r_data_3[63:32],r_data_2[63:32],
                                r_data_1[63:32],rr_data_0[63:32]};
            pl_hb_usr_waddr <= (blk_cnt * 64) + 6'd32 + l_cnt; 
         end
         else begin
               
               if ((pfx0_load) && wr_data) begin
                  pl_hb_pfx0_pld_wr <= 1'b1;
                  pl_hb_pfx0_pld_wdata <= {r_data_3[31:0],r_data_2[31:0],
                                           r_data_1[31:0],r_data_0[31:0]};
                  pl_hb_pfx0_pld_waddr <= (blk_cnt * 64) + l_cnt; 
                  
               end
               else if ((pfx1_load) && wr_data) begin
                  pl_hb_pfx1_pld_wr <= 1'b1;
                  pl_hb_pfx1_pld_wdata <= {r_data_3[31:0],r_data_2[31:0],
                                           r_data_1[31:0],r_data_0[31:0]};
                  pl_hb_pfx1_pld_waddr <= (blk_cnt * 64) + l_cnt; 
               end
               else if ((pfx2_load) && wr_data) begin
                  pl_hb_pfx2_pld_wr <= 1'b1;
                  pl_hb_pfx2_pld_wdata <= {r_data_3[31:0],r_data_2[31:0],
                                           r_data_1[31:0],r_data_0[31:0]};
                  pl_hb_pfx2_pld_waddr <= (blk_cnt * 64) + l_cnt; 
               end
               else if (pfx0_load && tgl) begin
                  pl_hb_pfx0_pld_wr <= 1'b1;
                  pl_hb_pfx0_pld_wdata <= {r_data_3[63:32],r_data_2[63:32],
                                           r_data_1[63:32],rr_data_0[63:32]};
                  pl_hb_pfx0_pld_waddr <= (blk_cnt * 64) + 6'd32 + l_cnt; 
               end
               else if (pfx1_load && tgl) begin
                  pl_hb_pfx1_pld_wr <= 1'b1;
                  pl_hb_pfx1_pld_wdata <= {r_data_3[63:32],r_data_2[63:32],
                                           r_data_1[63:32],rr_data_0[63:32]};
                  pl_hb_pfx1_pld_waddr <= (blk_cnt * 64) + 6'd32 + l_cnt; 
               end
               else if (pfx2_load && tgl) begin
                  pl_hb_pfx2_pld_wr <= 1'b1;
                  pl_hb_pfx2_pld_wdata <= {r_data_3[63:32],r_data_2[63:32],
                                           r_data_1[63:32],rr_data_0[63:32]};
                  pl_hb_pfx2_pld_waddr <= (blk_cnt * 64) + 6'd32 + l_cnt; 
               end
               else begin
                  pl_hb_pfx0_pld_wr <= 1'b0;
                  pl_hb_pfx1_pld_wr <= 1'b0;
                  pl_hb_pfx2_pld_wr <= 1'b0;
                  pl_hb_usr_wr <= 1'b0;
               end
         end
         
         if (rr_last) begin
            blk_cnt <= '0;
            l_cnt <= '0;
         end
         else begin
            if ((l_cnt == 5'd31) && tgl)
              blk_cnt <= blk_cnt + 1;
            if (tgl)
              l_cnt <= l_cnt + 1;
         end
      end 
   end 

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         space_avail <= 1;
         pfx0_avail <= 1'b1;
         pfx1_avail <= 1'b1;
         pfx2_avail <= 1'b1;
         
         
         hdr_wr <= 0;
         hdr_wr_data <= 0;
         pfx0_in_use <= 0;
         pfx0_load <= 0;
         pfx1_in_use <= 0;
         pfx1_load <= 0;
         pfx2_in_use <= 0;
         pfx2_load <= 0;
         
      end
      else begin
         if (rr_last)
           space_avail <= 1'b1;
         else if (!r_last && (blk_cnt == 0) && (l_cnt == 5'd31) && tgl)
           space_avail <= 1'b0;

         if (pfx0_load) pfx0_avail <= 1'b0;
         else if (pfx0_done)
           pfx0_avail <= 1'b1;
         
         if (pfx1_load) pfx1_avail <= 1'b0;
         else if (pfx1_done)
           pfx1_avail <= 1'b1;

         if (pfx2_load) pfx2_avail <= 1'b0;
         else if (pfx2_done)
           pfx2_avail <= 1'b1;

         if (pfx0_avail_load)
           pfx0_load <= 1'b1;
         else if (hdr_wr && pfx0_load)
           pfx0_load <= 1'b0;
         
         if (pfx1_avail_load)
           pfx1_load <= 1'b1;
         else if (hdr_wr && pfx1_load)
           pfx1_load <= 1'b0;

         if (pfx2_avail_load)
           pfx2_load <= 1'b1;
         else if (hdr_wr && pfx2_load)
           pfx2_load <= 1'b0;
         
                 
         if (ag_pl_eof) begin
            if (data_rd_data[9:0] != 0) begin
               if (data_rd_data[1:0] == '0)
                 pfx0_in_use <= 1'b0;
               else if (data_rd_data[1:0] == 2'b01)
                 pfx1_in_use <= 1'b0;
               else 
                 pfx2_in_use <= 1'b0;
            end
         end
         else begin
            if (hold_rd) begin
               if (hold_rd_data[9:0] != 10'b0) begin
                  if (hold_rd_data[1:0] == 2'b0) begin
                     pfx0_in_use <= 1'b1;
                     pfx1_in_use <= 1'b0;
                     pfx2_in_use <= 1'b0;
                  end
                  else if (hold_rd_data[1:0] == 2'b01) begin
                     pfx1_in_use <= 1'b1;
                     pfx0_in_use <= 1'b0;
                     pfx2_in_use <= 1'b0;
                  end
                  else begin
                     pfx1_in_use <= 1'b0;
                     pfx0_in_use <= 1'b0;
                     pfx2_in_use <= 1'b1;
                  end
               end
               else begin
                  pfx1_in_use <= 1'b0;
                  pfx2_in_use <= 1'b0;
                  pfx0_in_use <= 1'b0;
               end
            end
         end 

         if (fhp_lz_prefix_hdr_valid) begin
            hdr_wr <= 1'b1;
            if (fhp_lz_prefix_hdr_bus.data_sz == 0) begin
               hdr_wr_data <= {fhp_lz_prefix_hdr_bus.trace_bit, 10'b0};
            end
            else begin
               if (fhp_lz_prefix_hdr_bus.prefix_type == 1'b1) begin
                  
                  if (pfx0_load)
                    hdr_wr_data <= {fhp_lz_prefix_hdr_bus.trace_bit,
                                    fhp_lz_prefix_hdr_bus.data_sz, 3'b100};
                  else if (pfx1_load)
                    hdr_wr_data <= {fhp_lz_prefix_hdr_bus.trace_bit,
                                    fhp_lz_prefix_hdr_bus.data_sz, 3'b101};
                  else 
                    hdr_wr_data <= {fhp_lz_prefix_hdr_bus.trace_bit,
                                    fhp_lz_prefix_hdr_bus.data_sz, 3'b110};
               end
               else begin
                  if (pfx0_load) 
                    hdr_wr_data <= {fhp_lz_prefix_hdr_bus.trace_bit,
                                    fhp_lz_prefix_hdr_bus.data_sz, 3'b000};
                  else if (pfx1_load)
                    hdr_wr_data <= {fhp_lz_prefix_hdr_bus.trace_bit,
                                    fhp_lz_prefix_hdr_bus.data_sz, 3'b001};
                  else 
                    hdr_wr_data <= {fhp_lz_prefix_hdr_bus.trace_bit,
                                    fhp_lz_prefix_hdr_bus.data_sz, 3'b010};
               end
            end 
         end 
         else begin
            hdr_wr_data <= 11'b0;
            hdr_wr <= 1'b0;
         end 
      end 
   end 
   
                  
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         
         
         pl_ag_load_tail <= 0;
         pl_ag_tail_ptr <= 0;
         pl_ep_prefix_cnt <= 0;
         pl_ep_prefix_load <= 0;
         pl_ep_trace_bit <= 0;
         
      end
      else begin
         if (data_wr) begin
            pl_ep_prefix_load <= 1'b1;
            pl_ep_prefix_cnt <= (hold_rd_data[9:3] * 1024);
            pl_ep_trace_bit <= hold_rd_data[10];

               pl_ag_load_tail <= 1'b1;
               pl_ag_tail_ptr <= (hold_rd_data[9:3] * 64);
  
         end
         else begin
            pl_ep_prefix_load <= 1'b0;
            pl_ep_prefix_load <= '0;
            pl_ag_load_tail <= 1'b0;
            pl_ag_tail_ptr <= '0;
         end
      end
   end

   
   nx_fifo #(.DEPTH (1), .WIDTH (11))
   hdr_fifo (.empty (hdr_empty),
             .full (),
             .used_slots (),
             .free_slots (),
             .rdata (hdr_rd_data),
             .clk (clk),
             .rst_n (rst_n),
             .wen (hdr_wr),
             .ren (hdr_rd),
             .clear (1'b0),
             .underflow (),
              .overflow (),
             .wdata (hdr_wr_data));
   
   
   nx_fifo #(.DEPTH (1), .WIDTH (11))
   hold_fifo (.empty (hold_empty),
             .full (),
             .used_slots (),
             .free_slots (),
             .rdata (hold_rd_data),
             .clk (clk),
             .rst_n (rst_n),
             .wen (hold_wr),
             .ren (hold_rd),
             .clear (1'b0),
             .underflow (),
             .overflow (),
             .wdata (hold_wr_data));
   

   

   assign data_rd = ag_pl_eof;

   assign hdr_rd = hold_empty && !hdr_empty;
   assign hold_wr = hdr_rd;
   assign hold_wr_data = hdr_rd_data;
   
   assign hold_rd = data_empty && !hold_empty;
   assign data_wr = hold_rd;
   assign data_wr_data = hold_rd_data;
   
   nx_fifo #(.DEPTH (1), .WIDTH (11))
   data_fifo (.empty (data_empty),
              .full (),
              .used_slots (),
              .free_slots (),
              .rdata (data_rd_data),
              .clk (clk),
              .rst_n (rst_n),
              .wen (data_wr),
              .ren (data_rd),
              .clear (1'b0),
              .underflow (),
              .overflow (),
              .wdata (data_wr_data));

   
endmodule 







