`timescale 1ns / 1ps
`include "param.v"                      
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/06/27 14:23:17
// Module Name: execute
// Description: ִ�н׶�
//////////////////////////////////////////////////////////////////////////////////


module execute(
    input wire [31:0] ID_rd1,
    input wire [31:0] ID_rd2,
    input wire [31:0] ID_ext,
    input wire CU_alub_sel,
    input wire CU_brun,
    input wire CU_branch,
    input wire [2:0] CU_aluop,

    output wire [31:0] ALUc,
    output wire brlt,
    output wire zero

    );

    wire [31:0] alub;

    alub_mux U0_alub(
        .CU_alub_sel (CU_alub_sel),
        .rdata2 (ID_rd2),
        .imm    (ID_ext),

        .alub   (alub)

    // input wire CU_alub_sel,
    // input wire [31:0] rdata2,
    // input wire [31:0] imm,

    // output wire [31:0] alub
    );

    alu U0_alu(
        .CU_brun (CU_brun),
        .CU_branch (CU_branch),
        .CU_aluop  (CU_aluop),
        .dataA     (ID_rd1),
        .dataB     (alub),

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
