`timescale 1ns / 1ps
`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/06/27 14:22:59
// Module Name: idecode
// Description: instruction decode
//////////////////////////////////////////////////////////////////////////////////


module idecode(
    input clk,
    input wire [31:0] ID_inst,
    input wire [31:0] ID_pc4,
    input wire [1:0] WB_wb_sel,
    input wire WB_rf_we,
    input wire [4:0] WB_waddr,
    input wire [31:0] WB_pc4,
    input wire [31:0] WB_aluc,
    input wire [31:0] WB_imm,
    input wire [31:0] WB_dm,

    output wire [2:0] CU_npc_op,
    output wire CU_brun,
    output wire [2:0] CU_aluop,
    output wire CU_dram_we,
    output wire CU_branch,
    output wire CU_npc_imm_sel,
    output wire CU_rf_we,
    output wire ID_alub_sel,
    output wire [1:0] CU_wb_sel,
    output wire [31:0] ID_dataA,
    output wire [31:0] ID_rd2,
    output wire [31:0] ID_imm,
    output wire [4:0] ID_waddr,
    output wire [4:0] ID_rs1,
    output wire [4:0] ID_rs2,
    output wire ID_rs1_rf,
    output wire ID_rs2_rf,

    output [31:0] debug_wb_value,        // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output wire ID_hava_inst
    ); 



    wire [31:0] wdata;
    wire [2:0] CU_sext_op;
    wire CU_alub_sel;
    
    assign ID_waddr = ID_inst[11:7];
    assign ID_rs1 = ID_inst[19:15];
    assign ID_rs2 = ID_inst[24:20];

    control CU(
        .inst (ID_inst),
        
        .sext_op (CU_sext_op),
        .npc_op (CU_npc_op),
        .wb_sel (CU_wb_sel),
        .rf_we (CU_rf_we),
        .brun (CU_brun),
        .alub_sel (ID_alub_sel),
        .aluop (CU_aluop),
        .dram_we (CU_dram_we),
        .branch (CU_branch),
        .npc_imm_sel (CU_npc_imm_sel),
        .rs1_rf (ID_rs1_rf),
        .rs2_rf (ID_rs2_rf),
        .have_inst (ID_hava_inst)
    );


    wdata_mux U0_wd(
        .wd_sel (WB_wb_sel),
        .pc4 (WB_pc4),
        .ALUc (WB_aluc),
        .dm (WB_dm),
        .imm (WB_imm),

        .wdata (wdata)
    );

    assign debug_wb_value = wdata;

    regfile U0_RF(
        .clk (clk),
        .cu_we (WB_rf_we),
        .raddr1 (ID_inst[19:15]),
        .raddr2 (ID_inst[24:20]),
        .waddr  (WB_waddr),
        .wdata  (wdata),

        .rdata1 (ID_dataA),
        .rdata2 (ID_rd2)

    );

    sext U0_sext(
        .inst (ID_inst[31:7]),
        .sext_op (CU_sext_op),

        .ext (ID_imm)
    );


endmodule
