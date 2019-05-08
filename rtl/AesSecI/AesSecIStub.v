// *************************************************************************
//
// Copyright © Microsoft Corporation. All rights reserved.
// Copyright © Broadcom Inc. All rights reserved.
// Licensed under the MIT License.
//
// *************************************************************************



module AesSecIStub (
    // Outputs
    output  [127:0]  AesCiphOutR,
    output           AesCiphOutVldR,
    output           KeyInitStall,
    output           CiphInStall,
    // Inputs
    input            Aes128,
    input            Aes192,
    input            Aes256,
    input   [127:0]  CiphIn,
    input            CiphInVldR,
    input            CiphInLastR,
    input            EncryptEn,
    input   [255:0]  KeyIn,
    input            KeyInitVldR,
    input            AesCiphOutStall,
    input            clk,
    input            rst_n
);

  assign AesCiphOutR = 128'h0;
  assign AesCiphOutVldR = AesCiphOutStall ? 1'b0 : 1'b1;
  assign KeyInitStall = 1'b0;
  assign CiphInStall = 1'b0;

endmodule

