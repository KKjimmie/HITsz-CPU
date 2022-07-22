`timescale 1ns / 1ps
`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/06/27 14:23:31
// Module Name: control
// Description: control unit
//////////////////////////////////////////////////////////////////////////////////


module control(
    input wire [31:0] IF_inst,
    input wire EX_brlt,
    input wire EX_breq,
    
    output wire [2:0] sext_op,
    output wire [1:0] npc_op,
    output wire [1:0] wd_sel,
    output wire rf_we,
    output wire brun,
    output wire alub_sel,
    output wire [2:0] aluop,
    output wire dram_we,
    output wire branch,
    output wire npc_imm_sel
    );

    wire [6:0] opcode;
    wire [6:0] func7;
    wire [2:0] func3;
    assign opcode = IF_inst[6:0];
    assign func7 = IF_inst[31:25];
    assign func3 = IF_inst[14:12];

    // sext_op
    // `define sext_R    'b000
    // `define sext_I    'b001
    // `define sext_IS   'b010
    // `define sext_S    'b011
    // `define sext_B    'b100
    // `define sext_U    'b101
    // `define sext_J    'b110
    assign sext_op = (opcode == `R_op) ? `sext_R : 
                    (opcode == `S_op) ? `sext_S :
                    (opcode == `I_op && (func3 == 'b001 || func3 == 'b101)) ? `sext_IS :
                    (opcode == `B_op) ? `sext_B :
                    (opcode == `lui_op) ? `sext_U :
                    (opcode == `J_op) ? `sext_J :
                    `sext_I;

    // npc_op
    // `define pc4     'b00
    // `define pcImm   'b01
    // `define Imm     'b10 
    assign npc_op = (opcode == `J_op) ? `pcImm :
                    (opcode == `jalr_op) ? `Imm : 
                    (opcode != `B_op) ? `pc4 : 
                    (branch && func3 == 3'b000 && EX_breq) ? `pcImm : // beq
                    (branch && func3 == 3'b001 && ! EX_breq) ? `pcImm :  // bne
                    (branch && func3 == 3'b100 && EX_brlt) ? `pcImm : // blt
                    (branch && func3 == 3'b101 && (! EX_brlt)) ? `pcImm : // bge
                    `pc4;

    assign wd_sel = (opcode == `lui_op) ? `wdImm :
                    (opcode == `lw_op) ? `wdDM : 
                    (opcode == `J_op | opcode == `jalr_op) ? `wdPC4 : 
                    `wdALUC;

    assign rf_we = (opcode == `B_op | opcode == `S_op) ? 0 : 1;

    assign brun = (opcode == `B_op) ? 0 : 1;

    assign alub_sel = (opcode == `R_op | opcode == `B_op) ? 1 : 0;

    assign aluop = ((opcode == `R_op && func7 == 'b0100000 && func3 == 000) || opcode == `B_op) ? `SUB : 
                (((opcode == `R_op && func7 == 'b0000000) || opcode == `I_op) && func3 == 'b111) ? `AND :
                (((opcode == `R_op && func7 == 'b0000000) || opcode == `I_op) && func3 == 'b110) ? `OR :
                (((opcode == `R_op && func7 == 'b0000000) || opcode == `I_op) && func3 == 'b100) ? `XOR :
                (((opcode == `R_op && func7 == 'b0000000) || opcode == `I_op) && func3 == 'b001) ? `SLL :
                (((opcode == `R_op && func7 == 'b0000000) || (opcode == `I_op && func7 == 'b0000000)) && func3 == 'b101) ? `SRL :
                (((opcode == `R_op && func7 == 'b0100000) || (opcode == `I_op && func7 == 'b0100000)) && func3 == 'b101) ? `SRA :
                `ADD;

    assign dram_we = (opcode == `S_op) ? 1 : 0;

    assign branch = (opcode == `B_op) ? 1 : 0;

    assign npc_imm_sel = (opcode == `J_op | opcode == `B_op) ? 0 : 1;


endmodule
