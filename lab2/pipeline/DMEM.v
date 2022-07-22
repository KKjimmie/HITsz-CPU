`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/07/01 17:29:00
// Module Name: DMEM
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module DMEM(
    input clk,
    input wire [31:0] waddr,
    input wire we,
    input wire [31:0] wdata,

    output wire [31:0] rdata
    );
    
     wire [31:0] waddr_tmp = waddr - 16'h4000;

     dram U_dram(
//    data_mem dmem(
        .clk (clk),
         .a   (waddr_tmp[15:2]),
//        .a   (waddr[15:2]),
        .spo (rdata),
        .we  (we),
        .d   (wdata)
    );
endmodule
