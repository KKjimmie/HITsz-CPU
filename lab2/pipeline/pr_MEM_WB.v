`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/08 15:53:46
// Design Name: 
// Module Name: pr_MEM_WB
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


module pr_MEM_WB(
    input wire clk,
    input wire rst_n,
    input wire [1:0] MEM_wb_sel,  
    input wire MEM_rf_we,
    input wire [4:0] MEM_waddr,
    input wire [31:0] MEM_dm,
    input wire [31:0] MEM_aluc,

    output reg [1:0] WB_wb_sel,
    output reg WB_rf_we,
    output reg [4:0] WB_waddr,
    output reg [31:0] WB_dm,

    input wire [31:0] MEM_pc,
    input wire [31:0] MEM_pc4,
    input wire [31:0] MEM_imm,
    output reg [31:0] WB_pc,
    output reg [31:0] WB_pc4,
    output reg [31:0] WB_imm,
    output reg [31:0] WB_aluc
    );

always @ (posedge clk or posedge rst_n) begin
    if( rst_n) WB_aluc <= 32'b0;
    else WB_aluc <= MEM_aluc;
end

always @ (posedge clk or posedge rst_n) begin
    if( rst_n) WB_pc <= 32'b0;
    else WB_pc <= MEM_pc;
end

always @ (posedge clk or posedge rst_n) begin
    if( rst_n) WB_pc4 <= 32'b0;
    else WB_pc4 <= MEM_pc4;
end

always @ (posedge clk or posedge rst_n) begin
    if( rst_n) WB_imm <= 32'b0;
    else WB_imm <= MEM_imm;
end

always @ (posedge clk or posedge rst_n) begin
    if( rst_n) WB_dm <= 32'b0;
    else WB_dm <= MEM_dm;
end

always @ (posedge clk or posedge rst_n) begin
    if( rst_n) WB_wb_sel <= 2'b0;
    else WB_wb_sel <= MEM_wb_sel;
end

always @ (posedge clk or posedge rst_n) begin
    if( rst_n) WB_rf_we <= 1'b0;
    else WB_rf_we <= MEM_rf_we;
end

always @ (posedge clk or posedge rst_n) begin
    if( rst_n) WB_waddr <= 5'b0;
    else WB_waddr <= MEM_waddr;
end


endmodule
