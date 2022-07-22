`timescale 1ns / 1ps
`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/06/28 16:30:47 
// Module Name: sext
// Dependencies: immediate generation unit
//////////////////////////////////////////////////////////////////////////////////


module sext(
    input wire [31:7] inst,
    input wire [2:0] sext_op,

    output wire [31:0] ext
    );

wire [11:0] low12;
wire [19:0] high20;

    // sext_op
    // `define sext_R    'b000
    // `define sext_I    'b001
    // `define sext_IS   'b010
    // `define sext_S    'b011
    // `define sext_B    'b100
    // `define sext_U    'b101
    // `define sext_J    'b110

assign low12 = (sext_op == `sext_R) ? 0 : 
               (sext_op == `sext_I) ? inst[31:20] :
               (sext_op == `sext_IS) ? inst[24:20] : 
               (sext_op == `sext_S) ? {inst[31:25], inst[11:7]} :
               (sext_op == `sext_B) ? {inst[31], inst[7], inst[30:25], inst[11:8]} :
               0;

assign high20 = (sext_op == `sext_U) ? inst[31:12] : 
                (sext_op == `sext_J) ? {inst[31], inst[19:12], inst[20], inst[30:21]} :
                (inst[31] == 'b1) ? 20'hfffff :
                20'b0;


assign ext = (sext_op == `sext_R) ? 0 :
             (sext_op == `sext_J) ? {high20, 1'b0} :
             (sext_op == `sext_IS) ? {19'b0, low12} :
             (sext_op == `sext_B) ? {high20[19:1], low12, 1'b0} :
             {high20, low12};



endmodule
