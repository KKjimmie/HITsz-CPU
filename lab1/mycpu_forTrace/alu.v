`timescale 1ns / 1ps
`include "param.v"  
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/06/28 17:34:24
// Module Name: alu
// Description: arithmetic and logic unit
//////////////////////////////////////////////////////////////////////////////////


module alu(
    input wire CU_brun,
    input wire CU_branch,
    input wire [2:0] CU_aluop,
    input wire [31:0] dataA,
    input wire [31:0] dataB,

    output wire [31:0] aluc,
    output wire zero,
    output wire brlt
    );

    reg [32:0] result;

    // `define ADD     'b000
    // `define SUB     'b001
    // `define AND     'b010
    // `define OR      'b011
    // `define XOR     'b100
    // `define SLL     'b101
    // `define SRL     'b110
    // `define SRA     'b111
    always @(*) begin
        case(CU_aluop)
            `ADD : result = dataA + dataB;
            `SUB : result = dataA - dataB;
            `AND : result = dataA & dataB;
            `OR  : result = dataA | dataB;
            `XOR : result = dataA ^ dataB;
            `SLL : result = dataA << dataB[4:0];
            `SRL : result = dataA >> dataB[4:0];
            `SRA : result = ($signed(dataA)) >>> dataB[4:0];
            default : result = 0;
        endcase

    end

    assign aluc = result[31:0];

    assign zero = (CU_branch && (result == 0)) ? 1 : 0;

    assign brlt = (CU_branch && (aluc[31] == 1'b1)) ? 1 : 0;

endmodule
