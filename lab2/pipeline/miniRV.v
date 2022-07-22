`timescale 1ns / 1ps

module miniRV(
    input wire rst_i,
    input wire clk_i,
    input wire [31:0] rdata,

    output wire mem_we,
    output wire [31:0] daddr, // cpu访问地址
    output wire [31:0] wdata
);

wire ID_have_inst, EX_hava_inst, MEM_have_inst;


wire rst_n = ! rst_i;
wire [31:0] EX_npc;
wire [31:0] IF_inst;
wire [31:0] IF_pc4;
wire [31:0] IF_pc;
wire [2:0] EX_npc_op;
wire stall_PC;
wire EX_jump;
ifetch IF(
    .clk (clk_i),
    .rst (rst_n),
    .stall (stall_PC),
    .EX_npc (EX_npc),
    .EX_jump (EX_jump),

    .IF_inst (IF_inst),
    .IF_pc4 (IF_pc4),
    .IF_pc (IF_pc)
);

wire [31:0] ID_inst;
wire [31:0] ID_pc;
wire [31:0] ID_pc4;
wire pipeline_stop;
wire stall_IF_ID;
wire flush_IF_ID;
wire [31:0] WB_aluc;

pr_IF_ID U_pr_IF_ID(
    .clk (clk_i),
    .rst_n (rst_n),
    .stall (stall_IF_ID),
    .flush (flush_IF_ID),

    .IF_inst (IF_inst),
    .IF_pc (IF_pc),
    .IF_pc4 (IF_pc4),

    .ID_inst (ID_inst),
    .ID_pc (ID_pc),
    .ID_pc4 (ID_pc4)
);

wire [31:0] dm;
wire [2:0] CU_npc_op;
wire CU_brun;
wire [2:0] CU_aluop;
wire CU_dram_we;
wire CU_branch;
wire CU_npc_imm_sel;
wire [31:0] ID_dataA;
wire [31:0] ID_dataB;
wire [31:0] ID_rd2;
wire [31:0] ID_imm;
wire [1:0] WB_wb_sel;
wire WB_rf_we;
wire [4:0] WB_waddr;
wire [31:0] WB_pc4;
wire [31:0] WB_imm;
wire CU_rf_we;
wire [1:0] CU_wb_sel;
wire [4:0] ID_waddr;
wire [4:0] ID_rs1;
wire [4:0] ID_rs2;
wire ID_rs1_rf;
wire ID_rs2_rf;
wire [31:0] WB_dm;
wire ID_alub_sel;
wire ID_hava_inst;
idecode ID(
    .clk (clk_i),
    .ID_inst (ID_inst),
    .WB_wb_sel (WB_wb_sel),
    .WB_rf_we (WB_rf_we),
    .WB_waddr (WB_waddr),
    .WB_pc4 (WB_pc4),
    .WB_aluc (WB_aluc),
    .WB_imm (WB_imm),
    .WB_dm (WB_dm),
    
    .CU_npc_op (CU_npc_op),
    .CU_brun (CU_brun),
    .CU_aluop (CU_aluop),
    .CU_dram_we (CU_dram_we),
    .CU_branch (CU_branch),
    .CU_npc_imm_sel (CU_npc_imm_sel),
    .CU_rf_we (CU_rf_we),
    .ID_alub_sel (ID_alub_sel),
    .CU_wb_sel (CU_wb_sel),
    .ID_dataA (ID_dataA),
    .ID_rd2 (ID_rd2),
    .ID_imm (ID_imm),
    .ID_waddr (ID_waddr),
    .ID_rs1 (ID_rs1),
    .ID_rs2 (ID_rs2),
    .ID_rs1_rf (ID_rs1_rf),
    .ID_rs2_rf (ID_rs2_rf)
);

wire EX_brun;
wire [2:0] EX_aluop;
wire EX_dram_we;
wire EX_branch;
wire EX_npc_imm_sel;
wire [31:0] EX_pc;
wire [31:0] EX_pc4;
wire [31:0] EX_imm;
wire [31:0] EX_dataA;
wire [31:0] EX_dataB;
wire [31:0] EX_rd2;
wire EX_rf_we;
wire [1:0] EX_wb_sel;
wire EX_rs1_rf;
wire EX_rs2_rf;
wire [4:0] EX_waddr;
wire flush_ID_EX;
wire [31:0] rd1_f, rd2_f;
wire rd1_op, rd2_op;
wire EX_alub_sel;
pr_ID_EX U_pr_ID_EX(
    .clk (clk_i),
    .rst_n (rst_n),
    .flush (flush_ID_EX),

    .CU_npc_op (CU_npc_op),
    .CU_brun (CU_brun),
    .CU_aluop (CU_aluop),
    .CU_dram_we (CU_dram_we),
    .CU_branch (CU_branch),
    .CU_npc_imm_sel (CU_npc_imm_sel),
    .CU_rf_we (CU_rf_we),
    .CU_wb_sel (CU_wb_sel),
    .ID_alub_sel (ID_alub_sel),
    .ID_pc (ID_pc),
    .ID_pc4 (ID_pc4),
    .ID_imm (ID_imm),
    .ID_dataA (ID_dataA),
    .ID_rd2 (ID_rd2),
    .ID_waddr (ID_waddr),
    .rd1_f (rd1_f),
    .rd2_f (rd2_f),
    .rd1_op (rd1_op),
    .rd2_op (rd2_op),
 
    .EX_npc_op (EX_npc_op),
    .EX_brun (EX_brun),
    .EX_aluop (EX_aluop),
    .EX_dram_we (EX_dram_we),
    .EX_branch (EX_branch),
    .EX_npc_imm_sel (EX_npc_imm_sel),
    .EX_rf_we (EX_rf_we),
    .EX_wb_sel (EX_wb_sel),
    .EX_alub_sel (EX_alub_sel),
    .EX_pc (EX_pc),
    .EX_pc4 (EX_pc4),
    .EX_imm (EX_imm),
    .EX_dataA (EX_dataA),
    .EX_rd2 (EX_rd2),
    .EX_waddr (EX_waddr)
);

wire [31:0] EX_aluc;

execute EX(
    .EX_npc_op (EX_npc_op),
    .EX_brun (EX_brun),
    .EX_alub_sel (EX_alub_sel),
    .EX_aluop (EX_aluop),
    .EX_branch (EX_branch),
    .EX_npc_imm_sel (EX_npc_imm_sel),
    .EX_pc (EX_pc),
    .EX_pc4 (EX_pc4),
    .EX_imm (EX_imm),
    .EX_dataA (EX_dataA),
    .EX_rd2 (EX_rd2),

    .ALUc (EX_aluc),
    .npc (EX_npc),
    .jump (EX_jump)
);
wire MEM_dram_we;
wire [31:0] MEM_aluc;
wire [31:0] MEM_rd2;
wire [1:0] MEM_wb_sel;
wire MEM_rf_we;
wire [4:0] MEM_waddr;
wire MEM_rs1_rf;
wire MEM_rs2_rf;
wire [31:0] MEM_pc; // *****************************
wire [31:0] MEM_pc4;
wire [31:0] MEM_imm;
pr_EX_MEM U_pr_EX_MEM(
    .clk (clk_i),
    .rst_n (rst_n),
    .EX_dram_we (EX_dram_we),
    .EX_aluc (EX_aluc),
    .EX_rd2 (EX_rd2),
    .EX_wb_sel (EX_wb_sel),
    .EX_rf_we (EX_rf_we),
    .EX_waddr (EX_waddr),
    
    .MEM_dram_we (MEM_dram_we),
    .MEM_aluc (MEM_aluc),
    .MEM_rd2 (MEM_rd2),
    .MEM_wb_sel (MEM_wb_sel),
    .MEM_rf_we (MEM_rf_we),
    .MEM_waddr (MEM_waddr),

    .EX_pc (EX_pc),
    .EX_pc4 (EX_pc4),
    .EX_imm (EX_imm),
    .MEM_pc (MEM_pc),
    .MEM_pc4 (MEM_pc4),
    .MEM_imm (MEM_imm)
);


// MEM阶段
assign mem_we = MEM_dram_we; 
assign dm = rdata; // dm(dmem来的数据)为rdata
assign daddr = MEM_aluc; // 地址为ALU计算得出的地址
assign wdata = MEM_rd2;

wire [31:0] WB_pc; // *****************
pr_MEM_WB U_pr_MEM_WB(
    .clk (clk_i),
    .rst_n (rst_n),
    .MEM_wb_sel (MEM_wb_sel),
    .MEM_rf_we (MEM_rf_we),
    .MEM_waddr (MEM_waddr),
    .MEM_dm (dm),
    .MEM_aluc (MEM_aluc),
    
    .WB_wb_sel (WB_wb_sel),
    .WB_rf_we (WB_rf_we),
    .WB_waddr (WB_waddr),
    .WB_dm (WB_dm),

    .MEM_pc (MEM_pc),
    .MEM_pc4 (MEM_pc4),
    .MEM_imm (MEM_imm),
    .WB_pc (WB_pc),
    .WB_pc4 (WB_pc4),
    .WB_imm (WB_imm),
    .WB_aluc (WB_aluc)
    );

hazard_detection HD(
    .EX_wb_sel (EX_wb_sel),
    .MEM_wb_sel (MEM_wb_sel),
    .WB_wb_sel (WB_wb_sel),
    .EX_imm (EX_imm),
    .MEM_imm (MEM_imm),
    .WB_imm (WB_imm),
    .EX_pc4 (EX_pc4),
    .MEM_pc4 (MEM_pc4),
    .WB_pc4 (WB_pc4),
    .MEM_dm (dm),
    .WB_dm (WB_dm),
    .EX_aluc (EX_aluc),
    .MEM_aluc (MEM_aluc),
    .WB_aluc (WB_aluc),
    .ID_rs1 (ID_rs1),
    .ID_rs2 (ID_rs2),
    .ID_rs1_rf (ID_rs1_rf),
    .ID_rs2_rf (ID_rs2_rf),

    .EX_waddr (EX_waddr),
    .EX_rf_we (EX_rf_we),

    .MEM_waddr (MEM_waddr),
    .MEM_rf_we (MEM_rf_we),

    .WB_waddr (WB_waddr),
    .WB_rf_we (WB_rf_we),

    .jump (EX_jump),

    .stall_PC (stall_PC),
    .stall_IF_ID (stall_IF_ID),
    .flush_IF_ID (flush_IF_ID),
    .flush_ID_EX (flush_ID_EX),
    .rd1_f (rd1_f),
    .rd2_f (rd2_f),
    .rd1_op (rd1_op),
    .rd2_op (rd2_op)
);
endmodule
