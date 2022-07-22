`timescale 1ns / 1ps

module miniRV(
    input rst_i,
    input clk_i,

    output        debug_wb_have_inst,   // WB阶段是否有指令 (对单周期CPU，此flag恒为1)
    output [31:0] debug_wb_pc,          // WB阶段的PC (若wb_have_inst=0，此项可为任意值)
    output        debug_wb_ena,         // WB阶段的寄存器写使能 (若wb_have_inst=0，此项可为任意值)
    output [4:0]  debug_wb_reg,         // WB阶段写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output [31:0] debug_wb_value        // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
);

assign debug_wb_have_inst = 1;

assign debug_wb_ena = rf_we;
assign debug_wb_reg = instruction[11:7];

wire rst_n = ! rst_i;
wire [31:0] instruction;
wire breq;
wire brlt;
wire [2:0] sext_op;
wire [1:0] npc_op;
wire [1:0] wd_sel;
wire rf_we;
wire brun;
wire alub_sel;
wire [2:0] aluop;
wire dram_we;
wire branch;
wire [31:0] ALUc;
wire [31:0] pc4;
wire npc_imm_sel;

wire [31:0] ext;
ifetch IF(
    .clk (clk_i),
    .rst (rst_n),
    .CU_npc_op (npc_op),
    .ALUc (ALUc),
    .ext (ext),
    .CU_npc_imm_sel (npc_imm_sel),
    
    .instruction (instruction),
    .pc4 (pc4),
    .debug_wb_pc (debug_wb_pc)

    // input wire clk,
    // input wire rst,
    // input wire [1:0] CU_npc_op,
    // input wire [31:0] pc,
    // input wire [31:0] alu_imm,
    // output wire [31:0] instruction,
    // output wire [31:0] pc4
);

control CU (
    .IF_inst (instruction),
    .EX_brlt (brlt),
    .EX_breq (breq),

    .sext_op (sext_op),
    .npc_op  (npc_op),
    .wd_sel (wd_sel),
    .rf_we (rf_we),
    .brun (brun),
    .alub_sel (alub_sel),
    .aluop (aluop),
    .dram_we (dram_we),
    .branch (branch),
    .npc_imm_sel (npc_imm_sel)

    // input wire [31:0] IF_inst,
    // input wire EX_brlt,
    // input wire EX_breq,
    
    // output wire [2:0] sext_op,
    // output wire [1:0] npc_op,
    // output wire wd_sel,
    // output wire rf_we,
    // output wire brun,
    // output wire alub_sel,
    // output wire [2:0] aluop,
    // output wire dram_we,
    // output wire branch
);

wire [31:0] dm;
wire [31:0] rdata1;
wire [31:0] rdata2;
idecode ID(
    .clk (clk_i),
    .inst (instruction),
    .pc4 (pc4),
    .ALUc (ALUc),
    .dm (dm),
    .CU_sext_op (sext_op),
    .CU_wd_sel (wd_sel),
    .CU_rf_we (rf_we),

    .ext (ext),
    .rdata1 (rdata1),
    .rdata2 (rdata2),
    .debug_wb_value (debug_wb_value)

    // input clk,
    // input wire [31:0] inst,
    // input wire [31:0] pc4,
    // input wire [31:0] ALUc,
    // input wire [31:0] dm,
    // input wire [2:0] CU_sext_op,
    // input wire [1:0] CU_wd_sel,
    // input wire CU_rf_we,

    // output wire [31:0] ext,
    // output wire [31:0] rdata1,
    // output wire [31:0] rdata2
);

execute EX(
    .ID_rd1 (rdata1),
    .ID_rd2 (rdata2),
    .ID_ext (ext),
    .CU_alub_sel (alub_sel),
    .CU_brun (brun),
    .CU_branch (branch),
    .CU_aluop (aluop),

    .ALUc (ALUc),
    .brlt (brlt),
    .zero (breq)
    // input wire [31:0] ID_rd1,
    // input wire [31:0] ID_rd2,
    // input wire [31:0] ID_ext,
    // input wire CU_alub_sel,
    // input wire CU_brun,
    // input wire CU_branch,
    // input wire CU_aluop,

    // output wire [31:0] ALUc,
    // output wire brlt,
    // output wire zero
);

amemory MEM(
    .clk (clk_i),
    .daddr (ALUc),
    .CU_we (dram_we),
    .din (rdata2),

    .dout (dm)
    // input clk,
    // input wire [31:0] daddr,
    // input wire CU_we,
    // input wire [31:0] din,

    // output wire [31:0] dout

);


    
endmodule
