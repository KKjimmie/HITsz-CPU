`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/07 16:56:22
// Design Name: 
// Module Name: pr_ID_EX
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


module pr_ID_EX(
    input wire clk,
    input wire rst_n,
    input wire flush,

    input wire [2:0] CU_npc_op,
    input wire CU_brun,
    input wire [2:0] CU_aluop,
    input wire CU_dram_we,
    input wire CU_branch,
    input wire CU_npc_imm_sel,
    input wire CU_rf_we,
    input wire ID_alub_sel,
    input wire [1:0] CU_wb_sel,
    input wire [31:0] ID_pc,
    input wire [31:0] ID_pc4,
    input wire [31:0] ID_imm,
    input wire [31:0] ID_dataA,
    input wire [31:0] ID_rd2,
    input wire [4:0] ID_waddr,

    input wire [31:0] rd1_f,
    input wire [31:0] rd2_f,
    input wire rd1_op,
    input wire rd2_op,
 
    output reg [2:0] EX_npc_op,
    output reg EX_brun,
    output reg [2:0] EX_aluop,
    output reg EX_dram_we,
    output reg EX_branch,
    output reg EX_npc_imm_sel,
    output reg EX_rf_we,
    output reg EX_alub_sel,
    output reg [1:0] EX_wb_sel,
    output reg [31:0] EX_pc,
    output reg [31:0] EX_pc4,
    output reg [31:0] EX_imm,
    output reg [31:0] EX_dataA,
    output reg [31:0] EX_rd2,
    output reg [4:0] EX_waddr
    );
always @ (posedge clk or posedge rst_n) begin   
    if(rst_n | flush) EX_npc_op <= 3'b0;
    else EX_npc_op <= CU_npc_op;
end


always @ (posedge clk or posedge rst_n) begin   
    if(rst_n | flush) EX_brun <= 1'b0;
    else EX_brun <= CU_brun;
end

always @ (posedge clk or posedge rst_n) begin   
    if(rst_n | flush) EX_aluop <= 3'b0;
    else EX_aluop <= CU_aluop;
end

always @ (posedge clk or posedge rst_n) begin   
    if(rst_n | flush) EX_alub_sel <= 1'b0;
    else EX_alub_sel <= ID_alub_sel;
end

always @ (posedge clk or posedge rst_n) begin   
    if(rst_n | flush) EX_dram_we <= 1'b0;
    else EX_dram_we <= CU_dram_we;
end


always @ (posedge clk or posedge rst_n) begin   
    if(rst_n | flush) EX_branch <= 1'b0;
    else EX_branch <= CU_branch;
end

always @ (posedge clk or posedge rst_n) begin   
    if(rst_n | flush) EX_npc_imm_sel <= 1'b0;
    else EX_npc_imm_sel <= CU_npc_imm_sel;
end

always @ (posedge clk or posedge rst_n) begin   
    if(rst_n | flush) EX_rf_we <= 1'b0;
    else EX_rf_we <= CU_rf_we;
end

always @ (posedge clk or posedge rst_n) begin   
    if(rst_n | flush) EX_wb_sel <= 2'b0;
    else EX_wb_sel <= CU_wb_sel;
end

always @ (posedge clk or posedge rst_n) begin   
    if(rst_n | flush) EX_pc <= 32'b0;
    else EX_pc <= ID_pc;
end

always @ (posedge clk or posedge rst_n) begin   
    if(rst_n | flush) EX_pc4 <= 32'b0;
    else EX_pc4 <= ID_pc4;
end

always @ (posedge clk or posedge rst_n) begin   
    if(rst_n | flush) EX_imm <= 32'b0;
    else EX_imm <= ID_imm;
end

always @ (posedge clk or posedge rst_n) begin   
    if(rst_n | flush) EX_dataA <= 32'b0;
    else if (rd1_op) EX_dataA <= rd1_f;
    else EX_dataA <= ID_dataA;
end


always @ (posedge clk or posedge rst_n) begin   
    if(rst_n | flush) EX_rd2 <= 32'b0;
    else if (rd2_op) EX_rd2 <= rd2_f;
    else EX_rd2 <= ID_rd2;
end

always @ (posedge clk or posedge rst_n) begin   
    if(rst_n | flush) EX_waddr <= 5'b0;
    else EX_waddr <= ID_waddr;
end
endmodule
