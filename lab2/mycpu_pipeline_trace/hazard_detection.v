`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/11 19:34:00
// Design Name: 
// Module Name: hazard_detection
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


module hazard_detection(
    input wire [1:0] EX_wb_sel,
    input wire [1:0] MEM_wb_sel,
    input wire [1:0] WB_wb_sel,
    
    input wire [31:0] EX_imm,
    input wire [31:0] MEM_imm,
    input wire [31:0] WB_imm,

    input wire [31:0] EX_pc4,
    input wire [31:0] MEM_pc4,
    input wire [31:0] WB_pc4,

    input wire [31:0] MEM_dm,
    input wire [31:0] WB_dm,

    input wire [31:0] EX_aluc,
    input wire [31:0] MEM_aluc,
    input wire [31:0] WB_aluc,

    input wire [4:0] ID_rs1,
    input wire [4:0] ID_rs2,
    input wire ID_rs1_rf,
    input wire ID_rs2_rf,

    input wire [4:0] EX_waddr,
    input wire EX_rf_we,

    input wire [4:0] MEM_waddr,
    input wire MEM_rf_we,

    input wire [4:0] WB_waddr,
    input wire WB_rf_we,

    input wire jump, // 发生跳转
    
    output reg stall_PC,
    output reg stall_IF_ID,
    output reg flush_IF_ID,
    output reg flush_ID_EX,
    output reg [31:0] rd1_f, // 前递
    output reg [31:0] rd2_f,
    output rd1_op,
    output rd2_op
    );

    wire data_hzA_rs1;
    wire data_hzA_rs2;
    wire data_hzB_rs1;
    wire data_hzB_rs2;
    wire data_hzC_rs1;
    wire data_hzC_rs2;

    // RAW情形A 
    assign data_hzA_rs1 = ((EX_waddr == ID_rs1) & EX_rf_we & ID_rs1_rf & (ID_rs1 != 5'b0));
    assign data_hzA_rs2 = ((EX_waddr == ID_rs2) & EX_rf_we & ID_rs2_rf & (ID_rs2 != 5'b0)); 

    // RAW情形B
    assign data_hzB_rs1 = ((MEM_waddr == ID_rs1) & MEM_rf_we & ID_rs1_rf & (ID_rs1 != 5'b0));
    assign data_hzB_rs2 = ((MEM_waddr == ID_rs2) & MEM_rf_we & ID_rs2_rf & (ID_rs2 != 5'b0)); 

    // RAW情形C
    assign data_hzC_rs1 = ((WB_waddr == ID_rs1) & WB_rf_we & ID_rs1_rf & (ID_rs1 != 5'b0));
    assign data_hzC_rs2 = ((WB_waddr == ID_rs2) & WB_rf_we & ID_rs2_rf & (ID_rs2 != 5'b0)); 

    assign rd1_op = data_hzA_rs1 | data_hzB_rs1 | data_hzC_rs1;
    assign rd2_op = data_hzA_rs2 | data_hzB_rs2 | data_hzC_rs2;

    wire load_use_hz = (data_hzA_rs1 | data_hzA_rs2) & (EX_wb_sel == `wdDM);

    wire control_hz = jump;

    wire [31:0] EX_f = (EX_wb_sel == `wdALUC) ? EX_aluc : 
                (EX_wb_sel == `wdImm) ? EX_imm : 
                (EX_wb_sel == `wdPC4) ? EX_pc4 :
                0;

    wire [31:0] MEM_f = (MEM_wb_sel == `wdALUC) ? MEM_aluc :
                 (MEM_wb_sel == `wdImm) ? MEM_imm :
                 (MEM_wb_sel == `wdPC4) ? MEM_pc4 :
                 MEM_dm;

    wire [31:0] WB_f = (WB_wb_sel == `wdALUC) ? WB_aluc :
                (WB_wb_sel == `wdImm) ? WB_imm :
                (WB_wb_sel == `wdPC4) ? WB_pc4 :
                WB_dm;


    always @ (*) begin
    rd1_f = (data_hzA_rs1) ? EX_f : 
                   (data_hzB_rs1) ? MEM_f : 
                   (data_hzC_rs1) ? WB_f : 
                   32'b0;

    rd2_f = (data_hzA_rs2) ? EX_f : 
                   (data_hzB_rs2) ? MEM_f : 
                   (data_hzC_rs2) ? WB_f : 
                   32'b0;



    stall_PC = (load_use_hz) ? 1 : 0;
    stall_IF_ID = (load_use_hz) ? 1 : 0;
    flush_IF_ID = (control_hz) ? 1 : 0;
    flush_ID_EX = (load_use_hz) ? 1 : 
                         (control_hz) ? 1 : 
                         0;
    end
endmodule
