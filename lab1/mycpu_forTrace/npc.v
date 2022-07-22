`timescale 1ns / 1ps
`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/06/28 16:23:37
// Module Name: npc
// Description: next pc
//////////////////////////////////////////////////////////////////////////////////


module npc(
    input wire [31:0] pc,
    input wire [31:0] imm,
    input wire [1:0] npc_op,

    output wire [31:0] npc,
    output wire [31:0] pc4
 
    );

    // npc_op
    // `define pc4     'b00
    // `define pcImm   'b01
    // `define Imm     'b10 
    
assign npc = (npc_op == `pc4) ? pc + 4 :
             (npc_op == `pcImm) ? pc + imm :
             imm;



assign pc4 = pc + 4;

endmodule
