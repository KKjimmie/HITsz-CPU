`timescale 1ns / 1ps

module miniRV(
    input rst_i,
    input clk_i,
    input wire [31:0] rdata,

    output wire mem_we,
    output wire [31:0] daddr, // 访存地址
    output wire [31:0] wdata
);

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
    .pc4 (pc4)
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
    .rdata2 (rdata2)
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
);

assign mem_we = dram_we; // dmem写使能信号为CU来的dram_we
assign dm = rdata; // dm(dmem来的数据)为rdata
assign daddr = ALUc; // 写地址为ALU计算得出的地址
assign wdata = rdata2;
  
endmodule
