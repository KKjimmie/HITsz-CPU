`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/06/27 14:22:38
// Module Name: ifetch
// Description: instruction fetch
//////////////////////////////////////////////////////////////////////////////////


module ifetch(
    input wire clk,
    input wire rst,
    input wire stall,
    input wire [31:0] EX_npc,
    input wire EX_jump,
    output wire [31:0] IF_inst,
    output wire [31:0] IF_pc4,
    output wire [31:0] IF_pc
    );
    
    wire [31:0] npc;

    npc_mux U_npc_mux(
        .EX_npc (EX_npc),
        .EX_jump (EX_jump),
        .pc4 (IF_pc4),

        .npc (npc)
    );

    pc U_pc(
        .clk (clk),
        .rst (rst),
        .npc (npc),
        .stall (stall),
        .pc  (IF_pc)
    // input wire clk, 
    // input wire rst,
    // input wire [31:0] npc,

    // output reg [31:0] pc
    );

    pc4adder U_pc4adder (
        .pc (IF_pc),
        .pc4 (IF_pc4)
    // input wire [31:0] pc,

    // output wire [31:0] pc4

    );

     prgrom imem(
//    inst_mem imem(
        .a (IF_pc[15:2]),
        .spo (IF_inst)
    );


endmodule
