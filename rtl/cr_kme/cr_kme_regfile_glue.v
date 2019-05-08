/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/










module cr_kme_regfile_glue (
   
   ckv_cmnd_op, ckv_cmnd_addr, ckv_wr_dat, ckv_ia_capability,
   ckv_ia_rdata_part0, ckv_ia_rdata_part1, ckv_ia_status, kim_cmnd_op,
   kim_cmnd_addr, kim_wr_dat, kim_ia_capability, kim_ia_rdata_part0,
   kim_ia_rdata_part1, kim_ia_status, engine_sticky_status,
   disable_ckv_kim_ism_reads, send_kme_ib_beat, debug_kme_ib_tvalid,
   debug_kme_ib_tlast, debug_kme_ib_tid, debug_kme_ib_tstrb,
   debug_kme_ib_tuser, debug_kme_ib_tdata, kme_cceip0_ob_out,
   kme_cceip1_ob_out, kme_cceip2_ob_out, kme_cceip3_ob_out,
   kme_cddip0_ob_out, kme_cddip1_ob_out, kme_cddip2_ob_out,
   kme_cddip3_ob_out, cceip_encrypt_bimc_isync,
   cceip_encrypt_bimc_idat, cceip_validate_bimc_isync,
   cceip_validate_bimc_idat, cddip_decrypt_bimc_isync,
   cddip_decrypt_bimc_idat, axi_bimc_isync, axi_bimc_idat,
   axi_term_bimc_isync, axi_term_bimc_idat,
   
   clk, rst_n, ckv_stat_code, ckv_stat_datawords, ckv_stat_addr,
   ckv_capability_type, ckv_capability_lst, ckv_rd_dat,
   o_ckv_ia_config, o_ckv_ia_wdata_part0, o_ckv_ia_wdata_part1,
   kim_stat_code, kim_stat_datawords, kim_stat_addr,
   kim_capability_type, kim_capability_lst, kim_rd_dat,
   o_kim_ia_config, o_kim_ia_wdata_part0, o_kim_ia_wdata_part1,
   set_rsm_is_backpressuring, wr_stb, wr_data, reg_addr,
   o_engine_sticky_status, o_disable_ckv_kim_ism_reads,
   o_send_kme_ib_beat, cceip0_out_ia_wdata, debug_kme_ib_tready,
   tready_override, kme_cceip0_ob_out_post, kme_cceip1_ob_out_post,
   kme_cceip2_ob_out_post, kme_cceip3_ob_out_post,
   kme_cddip0_ob_out_post, kme_cddip1_ob_out_post,
   kme_cddip2_ob_out_post, kme_cddip3_ob_out_post, cddip3_ism_osync,
   cddip3_ism_odat, cceip_encrypt_bimc_osync, cceip_encrypt_bimc_odat,
   cceip_validate_bimc_osync, cceip_validate_bimc_odat,
   cddip_decrypt_bimc_osync, cddip_decrypt_bimc_odat, axi_bimc_osync,
   axi_bimc_odat
   );

    `include "cr_kme_body_param.v"   

    
    
    
    input clk;
    input rst_n;

    
    
    
    output  [3:0]                       ckv_cmnd_op;
    output  [`LOG_VEC(CKV_NUM_ENTRIES)] ckv_cmnd_addr;

    input   [2:0]                       ckv_stat_code;
    input   [4:0]                       ckv_stat_datawords;
    input   [`LOG_VEC(CKV_NUM_ENTRIES)] ckv_stat_addr;

    input   [3:0]                       ckv_capability_type;
    input   [15:0]                      ckv_capability_lst;

    output  [`BIT_VEC(CKV_DATA_WIDTH)]  ckv_wr_dat; 
    input   [`BIT_VEC(CKV_DATA_WIDTH)]  ckv_rd_dat; 

    
    
    
    output ckv_ia_capability_t          ckv_ia_capability;
    output [`CR_KME_C_CKV_PART0_T_DECL] ckv_ia_rdata_part0;
    output [`CR_KME_C_CKV_PART1_T_DECL] ckv_ia_rdata_part1;
    output ckv_ia_status_t              ckv_ia_status;

    input ckv_ia_config_t               o_ckv_ia_config;
    input [`CR_KME_C_CKV_PART0_T_DECL]  o_ckv_ia_wdata_part0;
    input [`CR_KME_C_CKV_PART1_T_DECL]  o_ckv_ia_wdata_part1;

    
    
    
    output  [3:0]                       kim_cmnd_op;
    output  [`LOG_VEC(KIM_NUM_ENTRIES)] kim_cmnd_addr;

    input   [2:0]                       kim_stat_code;
    input   [4:0]                       kim_stat_datawords;
    input   [`LOG_VEC(KIM_NUM_ENTRIES)] kim_stat_addr;

    input   [3:0]                       kim_capability_type;
    input   [15:0]                      kim_capability_lst;

    output  [`BIT_VEC(KIM_DATA_WIDTH)]  kim_wr_dat; 
    input   [`BIT_VEC(KIM_DATA_WIDTH)]  kim_rd_dat; 

    
    
    
    output kim_ia_capability_t           kim_ia_capability;
    output [`CR_KME_C_KIM_ENTRY0_T_DECL] kim_ia_rdata_part0;
    output [`CR_KME_C_KIM_ENTRY1_T_DECL] kim_ia_rdata_part1;
    output kim_ia_status_t               kim_ia_status;

    input kim_ia_config_t               o_kim_ia_config;
    input [`CR_KME_C_KIM_ENTRY0_T_DECL] o_kim_ia_wdata_part0;
    input [`CR_KME_C_KIM_ENTRY1_T_DECL] o_kim_ia_wdata_part1;

    
    
    
    input [7:0] set_rsm_is_backpressuring;

    
    
    
    input                                       wr_stb;
    input      [31:0]                           wr_data;
    input      [`CR_KME_DECL]                   reg_addr;
    output reg [`CR_KME_C_STICKY_ENG_BP_T_DECL] engine_sticky_status;
    input      [`CR_KME_C_STICKY_ENG_BP_T_DECL] o_engine_sticky_status;
    output reg                                  disable_ckv_kim_ism_reads;
    input                                       o_disable_ckv_kim_ism_reads;
    output reg                                  send_kme_ib_beat;
    input                                       o_send_kme_ib_beat;

    
    
    
    input  cceip0_out_t                 cceip0_out_ia_wdata;
    output reg                          debug_kme_ib_tvalid;
    output reg                          debug_kme_ib_tlast;
    output reg [`AXI_S_TID_WIDTH-1:0]   debug_kme_ib_tid;
    output reg [`AXI_S_TSTRB_WIDTH-1:0] debug_kme_ib_tstrb;
    output reg [`AXI_S_USER_WIDTH-1:0]  debug_kme_ib_tuser;
    output reg [`AXI_S_DP_DWIDTH-1:0]   debug_kme_ib_tdata;
    input  reg                          debug_kme_ib_tready;

    
    
    
    input  tready_override_t    tready_override;
    input  axi4s_dp_bus_t       kme_cceip0_ob_out_post;
    input  axi4s_dp_bus_t       kme_cceip1_ob_out_post;
    input  axi4s_dp_bus_t       kme_cceip2_ob_out_post;
    input  axi4s_dp_bus_t       kme_cceip3_ob_out_post;
    input  axi4s_dp_bus_t       kme_cddip0_ob_out_post;
    input  axi4s_dp_bus_t       kme_cddip1_ob_out_post;
    input  axi4s_dp_bus_t       kme_cddip2_ob_out_post;
    input  axi4s_dp_bus_t       kme_cddip3_ob_out_post;
    output axi4s_dp_bus_t       kme_cceip0_ob_out;
    output axi4s_dp_bus_t       kme_cceip1_ob_out;
    output axi4s_dp_bus_t       kme_cceip2_ob_out;
    output axi4s_dp_bus_t       kme_cceip3_ob_out;
    output axi4s_dp_bus_t       kme_cddip0_ob_out;
    output axi4s_dp_bus_t       kme_cddip1_ob_out;
    output axi4s_dp_bus_t       kme_cddip2_ob_out;
    output axi4s_dp_bus_t       kme_cddip3_ob_out;

    
    
    
    input   cddip3_ism_osync;
    input   cddip3_ism_odat;

    output  cceip_encrypt_bimc_isync;
    output  cceip_encrypt_bimc_idat;

    input   cceip_encrypt_bimc_osync;
    input   cceip_encrypt_bimc_odat;

    output  cceip_validate_bimc_isync;
    output  cceip_validate_bimc_idat;

    input   cceip_validate_bimc_osync;
    input   cceip_validate_bimc_odat;

    output  cddip_decrypt_bimc_isync;
    output  cddip_decrypt_bimc_idat;

    input   cddip_decrypt_bimc_osync;
    input   cddip_decrypt_bimc_odat;

    output  axi_bimc_isync;
    output  axi_bimc_idat;

    input   axi_bimc_osync;
    input   axi_bimc_odat;

    output  axi_term_bimc_isync;
    output  axi_term_bimc_idat;

    integer i;


    
    
    
    assign ckv_cmnd_op               = o_ckv_ia_config.f.op;
    assign ckv_cmnd_addr             = o_ckv_ia_config.f.addr;
    assign ckv_ia_capability.f       = {ckv_capability_type, ckv_capability_lst};
    assign ckv_ia_status.f.code      = ckv_stat_code;
    assign ckv_ia_status.f.datawords = ckv_stat_datawords;
    assign ckv_ia_status.f.addr      = ckv_stat_addr;

    assign ckv_wr_dat = {   o_ckv_ia_wdata_part1, o_ckv_ia_wdata_part0  };

    assign { ckv_ia_rdata_part1,
             ckv_ia_rdata_part0 } = (disable_ckv_kim_ism_reads) ? {CKV_DATA_WIDTH{1'b0}} : ckv_rd_dat;

    
    
    
    assign kim_cmnd_op               = o_kim_ia_config.f.op;
    assign kim_cmnd_addr             = o_kim_ia_config.f.addr;
    assign kim_ia_capability.f       = {kim_capability_type, kim_capability_lst};
    assign kim_ia_status.f.code      = kim_stat_code;
    assign kim_ia_status.f.datawords = kim_stat_datawords;
    assign kim_ia_status.f.addr      = kim_stat_addr;

    assign kim_wr_dat = {o_kim_ia_wdata_part0, o_kim_ia_wdata_part1};

    assign { kim_ia_rdata_part0,
             kim_ia_rdata_part1  } = (disable_ckv_kim_ism_reads) ? {KIM_DATA_WIDTH{1'b0}} : kim_rd_dat;



    
    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<`CR_KME_C_STICKY_ENG_BP_T_WIDTH; i=i+1) begin
                engine_sticky_status <= {`CR_KME_C_STICKY_ENG_BP_T_WIDTH{1'b0}};
            end
        end else begin
            for (i=0; i<`CR_KME_C_STICKY_ENG_BP_T_WIDTH; i=i+1) begin
                if (wr_stb & (reg_addr == `CR_KME_ENGINE_STICKY_STATUS) & wr_data[i]) begin
                    
                    engine_sticky_status[i] <= 1'b0;
                end else if (set_rsm_is_backpressuring[i]) begin
                    engine_sticky_status[i] <= 1'b1;
                end
            end
        end
    end

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            disable_ckv_kim_ism_reads <= 1'b0;
            send_kme_ib_beat <= 1'b0;
        end else begin
            
            
            
            if (debug_kme_ib_tvalid) begin
                if (debug_kme_ib_tready) begin
                    send_kme_ib_beat <= 1'b0;
                end
            end else if (wr_stb & (reg_addr == `CR_KME_SPARE_CONFIG) & wr_data[0]) begin
                send_kme_ib_beat <= 1'b1;
            end
                    
            if (wr_stb & (reg_addr == `CR_KME_SPARE_CONFIG) & wr_data[1]) begin
                
                
                disable_ckv_kim_ism_reads <= 1'b1;
            end
        end
    end

    always @ (*) begin

        
        debug_kme_ib_tvalid = 1'b0;
        debug_kme_ib_tlast  = 1'b0;
        debug_kme_ib_tid    = {`AXI_S_TID_WIDTH{1'b0}};
        debug_kme_ib_tstrb  = {`AXI_S_TSTRB_WIDTH{1'b0}};
        debug_kme_ib_tuser  = {`AXI_S_USER_WIDTH{1'b0}};
        debug_kme_ib_tdata  = {`AXI_S_DP_DWIDTH{1'b0}};

        if (send_kme_ib_beat) begin
            debug_kme_ib_tvalid       = 1'b1;
            debug_kme_ib_tlast        = cceip0_out_ia_wdata.f.eob;
            debug_kme_ib_tid          = cceip0_out_ia_wdata.f.tid;
            debug_kme_ib_tstrb        = cceip0_out_ia_wdata.f.bytes_vld;
            debug_kme_ib_tuser        = cceip0_out_ia_wdata.f.tuser;
            debug_kme_ib_tdata[63:32] = cceip0_out_ia_wdata.f.tdata_hi;
            debug_kme_ib_tdata[31:0]  = cceip0_out_ia_wdata.f.tdata_lo;
        end

        
        kme_cceip0_ob_out = kme_cceip0_ob_out_post;
        kme_cceip1_ob_out = kme_cceip1_ob_out_post;
        kme_cceip2_ob_out = kme_cceip2_ob_out_post;
        kme_cceip3_ob_out = kme_cceip3_ob_out_post;
        kme_cddip0_ob_out = kme_cddip0_ob_out_post;
        kme_cddip1_ob_out = kme_cddip1_ob_out_post;
        kme_cddip2_ob_out = kme_cddip2_ob_out_post;
        kme_cddip3_ob_out = kme_cddip3_ob_out_post;

        if (tready_override.f.engine_0_tready_override) kme_cceip0_ob_out.tvalid = 1'b0;
        if (tready_override.f.engine_1_tready_override) kme_cceip1_ob_out.tvalid = 1'b0;
        if (tready_override.f.engine_2_tready_override) kme_cceip2_ob_out.tvalid = 1'b0;
        if (tready_override.f.engine_3_tready_override) kme_cceip3_ob_out.tvalid = 1'b0;

        if (tready_override.f.engine_4_tready_override) kme_cddip0_ob_out.tvalid = 1'b0;
        if (tready_override.f.engine_5_tready_override) kme_cddip1_ob_out.tvalid = 1'b0;
        if (tready_override.f.engine_6_tready_override) kme_cddip2_ob_out.tvalid = 1'b0;
        if (tready_override.f.engine_7_tready_override) kme_cddip3_ob_out.tvalid = 1'b0;
    end


    
    assign cceip_encrypt_bimc_isync  = cddip3_ism_osync;
    assign cceip_encrypt_bimc_idat   = cddip3_ism_odat;

    assign cceip_validate_bimc_isync = cceip_encrypt_bimc_osync;
    assign cceip_validate_bimc_idat  = cceip_encrypt_bimc_odat;

    assign cddip_decrypt_bimc_isync = cceip_validate_bimc_osync;
    assign cddip_decrypt_bimc_idat  = cceip_validate_bimc_odat;

    assign axi_bimc_isync = cddip_decrypt_bimc_osync;
    assign axi_bimc_idat  = cddip_decrypt_bimc_odat;

    assign axi_term_bimc_isync = axi_bimc_osync;
    assign axi_term_bimc_idat  = axi_bimc_odat;

endmodule










