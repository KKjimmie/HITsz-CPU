`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/07 16:37:46
// Design Name: 
// Module Name: pr_IF_ID
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pr_IF_ID(
    input wire clk,
    input wire rst_n,
    input wire stall,
    input wire flush,

    input wire [31:0] IF_inst,
    input wire [31:0] IF_pc,
    input wire [31:0] IF_pc4,

    output reg [31:0] ID_inst,
    output reg [31:0] ID_pc,
    output reg [31:0] ID_pc4
    );

always @ (posedge clk or negedge rst_n) begin
    if(~ rst_n) ID_pc <= 32'b0;
    else if (flush) ID_pc <= 32'b0;
    else if (stall) ID_pc <= ID_pc;
    else ID_pc <= IF_pc;
end

always @ (posedge clk or negedge rst_n) begin
    if(~ rst_n | flush) ID_pc4 <= 32'b0;
    else if (stall) ID_pc4 <= ID_pc4;
    else ID_pc4 <= IF_pc4;
end

always @ (posedge clk or negedge rst_n) begin
    if (~ rst_n | flush) ID_inst <= 32'b0;
    else if (stall) ID_inst <= ID_inst;
    else ID_inst <= IF_inst;
end

endmodule
