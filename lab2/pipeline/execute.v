`timescale 1ns / 1ps
`include "param.v"                      
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/06/27 14:23:17
// Module Name: execute
// Description: 执锟叫阶讹拷
//////////////////////////////////////////////////////////////////////////////////


module execute(
    input wire [2:0] EX_npc_op,
    input wire EX_brun,
    input wire EX_alub_sel,
    input wire [2:0] EX_aluop,
    input wire EX_branch,
    input wire EX_npc_imm_sel,

    input wire [31:0] EX_pc,
    input wire [31:0] EX_pc4,
    input wire [31:0] EX_imm,
    input wire [31:0] EX_dataA,
    input wire [31:0] EX_rd2,

    output wire [31:0] ALUc,
    output wire [31:0] npc,
    output wire jump
    );

    wire zero;
    wire brlt;
    wire [31:0] npc_imm, EX_dataB;

    npc_imm_mux U_npc_imm_mux(
        .ALUc (ALUc),
        .imm (EX_imm),
        .EX_npc_imm_sel (EX_npc_imm_sel),

        .npc_imm (npc_imm)
    // input wire [31:0] ALUc,
    // input wire [31:0] imm,
    // input EX_npc_imm_sel,
    
    // output wire [31:0] npc_imm
    );

    npc U_npc(
        .pc (EX_pc),
        .pc4 (EX_pc4),
        .imm (npc_imm),
        .npc_op (EX_npc_op),
        .alu_breq (zero),
        .alu_brlt (brlt),

        .npc (npc),
        .jump (jump)
    // input wire [31:0] pc,
    // input wire [31:0] pc4,
    // input wire [31:0] imm,
    // input wire [2:0] npc_op,
    // input wire alu_breq,
    // input wire alu_brlt,

    // output wire [31:0] npc,
    // output wire jump // 表示发生跳转
    );
    
    alub_mux U0_alub(
    .alub_sel (EX_alub_sel),
    .rdata2 (EX_rd2),
    .imm    (EX_imm),

    .alub   (EX_dataB)
    );

    alu U0_alu(
        .CU_brun (EX_brun),
        .CU_branch (EX_branch),
        .CU_aluop  (EX_aluop),
        .dataA     (EX_dataA),
        .dataB     (EX_dataB),

        .aluc      (ALUc),
        .zero      (zero),
        .brlt      (brlt)
    // input wire CU_brun,
    // input wire CU_branch,
    // input wire CU_aluop,
    // input wire [31:0] dataA,
    // input wire [31:0] dataB,

    // output wire [31:0] aluc,
    // output wire zero,
    // output wire brlt
    );



endmodule
