`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/06/29 15:48:24
// Module Name: amemory
// Description: access memory
//////////////////////////////////////////////////////////////////////////////////


module amemory(
    input clk,
    input wire [31:0] daddr,
    input wire CU_we,
    input wire [31:0] din,

    output wire [31:0] dout
    );

    data_mem dmem(
        .clk (clk),
        .a   (daddr[15:2]),
        .spo (dout),
        .we  (CU_we),
        .d   (din)
    );

endmodule
