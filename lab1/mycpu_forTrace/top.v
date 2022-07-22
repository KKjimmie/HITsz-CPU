module top(
    input clk,
    input rst_n,
    output        debug_wb_have_inst,   // WB阶段是否有指令 (对单周期CPU，此flag恒为1)
    output [31:0] debug_wb_pc,          // WB阶段的PC (若wb_have_inst=0，此项可为任意值)
    output        debug_wb_ena,         // WB阶段的寄存器写使能 (若wb_have_inst=0，此项可为任意值)
    output [4:0]  debug_wb_reg,         // WB阶段写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output [31:0] debug_wb_value        // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
);

// wire [31:0] waddr_tmp = waddr;// - 16'h4000;

miniRV mini_rv_u (
    .rst_i(rst_n),
    .clk_i(clk),
    .debug_wb_have_inst(debug_wb_have_inst),
    .debug_wb_pc(debug_wb_pc),
    .debug_wb_ena(debug_wb_ena),
    .debug_wb_reg(debug_wb_reg),
    .debug_wb_value(debug_wb_value)
);
// // 下面两个模块，只需要实例化并连线，不需要添加文件
// inst_mem imem(

// );

// data_mem dmem(
//     .clk    (cpu_clk),
//     .a      (waddr_tmp[15:2]),
//     .spo    (rdata),
//     .we     (we),
//     .d      (wdata)
// );
endmodule
