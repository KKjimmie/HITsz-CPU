`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/06/27 14:22:38
// Module Name: ifetch
// Description: instruction fetch
//////////////////////////////////////////////////////////////////////////////////


module ifetch(
    input wire clk,
    input wire rst,
    input wire [1:0] CU_npc_op,
    input wire [31:0] ALUc,
    input wire [31:0] ext,
    input wire CU_npc_imm_sel,
    
    output wire [31:0] instruction,
    output wire [31:0] pc4
    );

    wire [31:0] npc;
    wire [31:0] pc;

    pc U0_pc (
        .clk (clk),
        .rst (rst),
        .npc (npc),

        .pc (pc)
    );
    
    prgrom imem(
        .a (pc[15:2]),
        .spo (instruction)
    );

    wire [31:0] npc_imm;
    npc_imm_mux U0_npc_imm(
        .ALUc (ALUc),
        .ext  (ext),
        .CU_npc_imm_sel (CU_npc_imm_sel),

        .npc_imm (npc_imm)
    );

    npc U0_npc(
        .pc (pc),
        .imm (npc_imm),
        .npc_op (CU_npc_op),

        .npc (npc),
        .pc4 (pc4)
    );

endmodule
