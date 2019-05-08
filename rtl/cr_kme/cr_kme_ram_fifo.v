/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_ram_fifo (
   
   fifo_in_stall, fifo_out, fifo_out_valid, fifo_bimc_osync,
   fifo_bimc_odat, fifo_mbe,
   
   clk, rst_n, fifo_in, fifo_in_valid, fifo_out_ack, bimc_rst_n,
   fifo_bimc_isync, fifo_bimc_idat
   );

    parameter DATA_SIZE = 10;
    parameter FIFO_DEPTH = 2;
    parameter SPECIALIZE = 1;
    
    input clk;
    input rst_n;
    
    input  [DATA_SIZE-1:0] fifo_in;
    input                  fifo_in_valid;
    output                 fifo_in_stall;
    
    output [DATA_SIZE-1:0] fifo_out;
    output                 fifo_out_valid;
    input                  fifo_out_ack;

    input                  bimc_rst_n;
    input                  fifo_bimc_isync;
    input                  fifo_bimc_idat;
    output                 fifo_bimc_osync;
    output                 fifo_bimc_odat;
    output                 fifo_mbe;

    wire ren;
    wire empty;

    cr_fifo_wrap2 #
    (
        .N_DATA_BITS(DATA_SIZE),
        .N_ENTRIES(FIFO_DEPTH),
        .USE_RAM(1)

    ) ram_fifo (
        .clk        (clk),
        .rst_n      (rst_n),

        .wen        (fifo_in_valid),
        .wdata      (fifo_in),

        .ren        (ren),
        .rdata      (fifo_out),

        .empty      (empty),
        .full       (fifo_in_stall),

        .afull      (),
        .aempty     (),

        .bimc_idat  (fifo_bimc_idat),
        .bimc_isync (fifo_bimc_isync),
        .bimc_rst_n (bimc_rst_n),
        .bimc_odat  (fifo_bimc_odat),
        .bimc_osync (fifo_bimc_osync),
        .ro_uncorrectable_ecc_error(fifo_mbe)
    );

    assign ren            = fifo_out_valid & fifo_out_ack;
    assign fifo_out_valid = !empty;



endmodule


