`timescale 1ns / 1ps
`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/06/28 16:23:37
// Module Name: npc
// Description: next pc
//////////////////////////////////////////////////////////////////////////////////


module npc(
    input wire [31:0] pc,
    input wire [31:0] pc4,
    input wire [31:0] imm,
    input wire [2:0] npc_op,
    input wire alu_breq,
    input wire alu_brlt,

    output wire [31:0] npc,
    output wire jump // 表示发生跳转
    );
    
        // npc_op
    // `define pc4     'b000
    // `define pcImm   'b001
    // `define Imm     'b010 
    // `define Beq     'b011
    // `define Bne     'b100
    // `define Blt     'b101
    // `define Bge     'b110
assign npc = (npc_op == `pc4) ? pc4 :
             (npc_op == `pcImm) ? pc + imm :
             (npc_op == `Imm) ? imm :
             (npc_op == `Beq && alu_breq) ? pc + imm :
             (npc_op == `Bne && ! alu_breq) ? pc + imm :
             (npc_op == `Blt && alu_brlt) ? pc + imm :
             (npc_op == `Bge && ! alu_brlt) ? pc + imm :
             pc4;

assign jump = (npc_op == `pcImm) ? 1 :
             (npc_op == `Imm) ? 1 :
             (npc_op == `Beq && alu_breq) ? 1 :
             (npc_op == `Bne && ! alu_breq) ? 1 :
             (npc_op == `Blt && alu_brlt) ? 1 :
             (npc_op == `Bge && ! alu_brlt) ? 1 :
             0;

endmodule
