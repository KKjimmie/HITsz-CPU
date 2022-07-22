`timescale 1ns / 1ps
`include "param.v"  
////////////////////////////////////////////////////////////////////////////////// 
// Create Date: 2022/06/29 14:52:27
// Module Name: wdata_mux
// Description: wirte data mux
//////////////////////////////////////////////////////////////////////////////////


module wdata_mux(
    input wire [1:0] wd_sel,
    input wire [31:0] pc4,
    input wire [31:0] ALUc,
    input wire [31:0] dm,
    input wire [31:0] imm,

    output wire [31:0] wdata

    );

    // wd_sel
    // `define wdPC4     'b00
    // `define wdALUC    'b01
    // `define wdDM      'b10
    // `define wdImm     'b11
    assign wdata = (wd_sel == `wdPC4) ? pc4 :
                   (wd_sel == `wdALUC) ? ALUc : 
                   (wd_sel == `wdImm) ? imm :
                   dm; 

endmodule
