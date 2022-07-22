`timescale 1ns / 1ps
`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/06/27 14:22:59
// Module Name: idecode
// Description: instruction decode
//////////////////////////////////////////////////////////////////////////////////


module idecode(
    input clk,
    input wire [31:0] inst,
    input wire [31:0] pc4,
    input wire [31:0] ALUc,
    input wire [31:0] dm,
    input wire [2:0] CU_sext_op,
    input wire [1:0] CU_wd_sel,
    input wire CU_rf_we,

    output wire [31:0] ext,
    output wire [31:0] rdata1,
    output wire [31:0] rdata2,
    output [31:0] debug_wb_value       // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)

    );

    wire [31:0] wdata;
    assign debug_wb_value = wdata;

    wdata_mux U0_wd(
        .CU_wd_sel (CU_wd_sel),
        .pc4 (pc4),
        .ALUc (ALUc),
        .imm  (ext),
        .dm (dm),

        .wdata (wdata)

    // input wire [1:0] CU_wd_sel,
    // input wire [31:0] pc4,
    // input wire [31:0] ALUc,
    // input wire [31:0] dm,

    // output wire [31:0] wdata
    );

    regfile U0_RF(
        .clk (clk),
        .cu_we (CU_rf_we),
        .raddr1 (inst[19:15]),
        .raddr2 (inst[24:20]),
        .waddr  (inst[11:7]),
        .wdata  (wdata),

        .rdata1 (rdata1),
        .rdata2 (rdata2)

    // input wire clk,
    // input wire cu_we,
    // input wire [4:0] raddr1,
    // input wire [4:0] raddr2,
    // input wire [4:0] waddr,
    // input wire [31:0] wdata,

    // output wire [31:0] rdata1,
    // output wire [31:0] rdata2
    );

    sext U0_sext(
        .inst (inst[31:7]),
        .sext_op (CU_sext_op),

        .ext (ext)
    // input wire [31:7] inst,
    // input wire [2:0] sext_op,

    // output wire [31:0] ext
    );

endmodule
