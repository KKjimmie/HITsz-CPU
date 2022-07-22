`timescale 1ns / 1ps
`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/06/27 14:23:31
// Module Name: control
// Description: control unit
//////////////////////////////////////////////////////////////////////////////////


module control(
    input wire [31:0] inst,
    
    output wire [2:0] sext_op,
    output wire [2:0] npc_op,
    output wire [1:0] wb_sel,
    output wire rf_we,
    output wire brun,
    output wire alub_sel,
    output wire [2:0] aluop,
    output wire dram_we,
    output wire branch,
    output wire npc_imm_sel,
    output wire rs1_rf, // rs1读有效
    output wire rs2_rf, // rs2读有效

    output wire have_inst
    );

    wire [6:0] opcode;
    wire [6:0] func7;
    wire [2:0] func3;
    assign opcode = inst[6:0];
    assign func7 = inst[31:25];
    assign func3 = inst[14:12];

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
    // // opcode
    // `define R_op    'b0110011
    // `define I_op    'b0010011
    // `define lw_op   'b0000011
    // `define jalr_op 'b1100111
    // `define S_op    'b0100011
    // `define B_op    'b1100011
    // `define lui_op  'b0110111
    // `define J_op    'b1101111
    assign have_inst = (opcode == `R_op) | (opcode == `I_op) | (opcode == `lw_op) | 
                       (opcode == `jalr_op) | (opcode == `S_op) | (opcode == `B_op) |
                       (opcode == `lui_op) | (opcode == `J_op);
    // npc_op
    // `define pc4     'b000
    // `define pcImm   'b001
    // `define Imm     'b010 
    // `define Beq     'b011
    // `define Bne     'b100
    // `define Blt     'b101
    // `define Bge     'b110
    assign npc_op = (opcode == `J_op) ? `pcImm :
                    (opcode == `jalr_op) ? `Imm : 
                    (opcode != `B_op) ? `pc4 : 
                    (branch && func3 == 3'b000) ? `Beq : // beq
                    (branch && func3 == 3'b001) ? `Bne :  // bne
                    (branch && func3 == 3'b100) ? `Blt : // blt
                    (branch && func3 == 3'b101) ? `Bge : // bge
                    (opcode == `R_op || opcode == `I_op || opcode == `S_op || opcode == `lui_op) ? `pc4 : 
                    3'b000;
    
    assign wb_sel = (opcode == `lui_op) ? `wdImm :
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

    assign rs1_rf = ((opcode != `lui_op) & (opcode != `J_op)) ? 1 : 0;

    assign rs2_rf = ((opcode == `R_op) | (opcode == `S_op) | (opcode == `B_op)) ? 1 : 0;

endmodule
