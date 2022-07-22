`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/08 15:24:58
// Design Name: 
// Module Name: pr_EX_MEM
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


module pr_EX_MEM(
    input clk,
    input rst_n,
    input wire EX_dram_we,
    input wire [31:0] EX_aluc,
    input wire [31:0] EX_rd2,
    input wire [1:0] EX_wb_sel,
    input wire EX_rf_we,
    input wire [4:0] EX_waddr,
    input wire [4:0] EX_rs1,
    input wire [4:0] EX_rs2,

    output reg MEM_dram_we,
    output reg [31:0] MEM_aluc,
    output reg [31:0] MEM_rd2,
    output reg [1:0] MEM_wb_sel,
    output reg MEM_rf_we,
    output reg [4:0] MEM_waddr,
    output reg [4:0] MEM_rs1,
    output reg [4:0] MEM_rs2,

    input wire [31:0] EX_pc,
    input wire [31:0] EX_pc4,
    input wire [31:0] EX_imm,
    output reg [31:0] MEM_pc,
    output reg [31:0] MEM_pc4,
    output reg [31:0] MEM_imm,

    input wire EX_hava_inst,
    output reg MEM_have_inst

    );

always @ (posedge clk or negedge rst_n) begin
    if(~ rst_n) MEM_have_inst <= 1'b0;
    else MEM_have_inst <= EX_hava_inst;
end

always @ (posedge clk or negedge rst_n) begin
    if(~ rst_n) MEM_pc <= 32'b0;
    else MEM_pc <= EX_pc;
end

always @ (posedge clk or negedge rst_n) begin
    if(~ rst_n) MEM_pc4 <= 32'b0;
    else MEM_pc4 <= EX_pc4;
end

always @ (posedge clk or negedge rst_n) begin
    if(~ rst_n) MEM_imm <= 32'b0;
    else MEM_imm <= EX_imm;
end

always @ (posedge clk or negedge rst_n) begin
    if(~ rst_n) MEM_dram_we <= 1'b0;
    else MEM_dram_we <= EX_dram_we;
end

always @ (posedge clk or negedge rst_n) begin
    if(~ rst_n) MEM_aluc <= 32'b0;
    else MEM_aluc <= EX_aluc;
end

always @ (posedge clk or negedge rst_n) begin
    if(~ rst_n) MEM_rd2 <= 32'b0;
    else MEM_rd2 <= EX_rd2;
end

always @ (posedge clk or negedge rst_n) begin
    if(~ rst_n) MEM_wb_sel <= 2'b0;
    else MEM_wb_sel <= EX_wb_sel;
end

always @ (posedge clk or negedge rst_n) begin
    if(~ rst_n) MEM_rf_we <= 1'b0;
    else MEM_rf_we <= EX_rf_we;
end

always @ (posedge clk or negedge rst_n) begin
    if(~ rst_n) MEM_waddr <= 5'b0;
    else MEM_waddr <= EX_waddr;
end

always @ (posedge clk or negedge rst_n) begin
    if(~ rst_n) MEM_rs1 <= 5'b0;
    else MEM_rs1 <= EX_rs1;
end

always @ (posedge clk or negedge rst_n) begin
    if(~ rst_n) MEM_rs2 <= 5'b0;
    else MEM_rs2 <= EX_rs2;
end

endmodule
