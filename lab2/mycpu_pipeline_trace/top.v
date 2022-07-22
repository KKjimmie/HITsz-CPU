module top(
    input  wire clk,
    input  wire rst_n,
    // input  wire [23:0] switch,

    // output wire led0_en_o,
    // output wire led1_en_o,
    // output wire led2_en_o,
    // output wire led3_en_o,
    // output wire led4_en_o,
    // output wire led5_en_o,
    // output wire led6_en_o,
    // output wire led7_en_o,
    // output wire led_ca_o,
    // output wire led_cb_o,
    // output wire led_cc_o,
    // output wire led_cd_o,
    // output wire led_ce_o,
    // output wire led_cf_o,
    // output wire led_cg_o,
    // output wire led_dp_o,
    // output wire [23:0] led,


    output        debug_wb_have_inst,   // WB阶段是否有指令 (对单周期CPU，此flag恒为1)
    output [31:0] debug_wb_pc,          // WB阶段的PC (若wb_have_inst=0，此项可为任意值)
    output        debug_wb_ena,         // WB阶段的寄存器写使能 (若wb_have_inst=0，此项可为任意值)
    output [4:0]  debug_wb_reg,         // WB阶段写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output [31:0] debug_wb_value        // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
);

wire rst_i = !rst_n;

// wire cnt_end;
// reg [2:0] cnt;

// assign cnt_end = (cnt == 3'b101) ? 1 : 0;

// always @(posedge clk or negedge rst_n) begin
//     if (~ rst_n) cnt <= 3'b0;
//     else if (! cnt_end) cnt <= cnt + 3'b1;
//     else cnt <= cnt;
// end

// assign debug_wb_have_inst = (cnt_end) ? 1 : 0;

wire [31:0] IOwdata;
wire [7:0] led_en;

// assign {led7_en_o, led6_en_o, led5_en_o, led4_en_o, led3_en_o, led2_en_o, led1_en_o, led0_en_o} = led_en;
// wire clk_out;
// wire clk_g;
// wire locked;
// cpuclk U_cpuclk(
//     .clk_in1 (clk_i),
//     .locked (locked),
//     .clk_out1 (clk_out)
// );
// assign clk_g = locked & clk_out;

wire [31:0] cpu_rdata;
wire cpu_mem_we;
wire [31:0] cpu_daddr;
wire [31:0] cpu_wdata;
miniRV mini_rv_u (
    .rst_i (rst_i),
    .clk_i (clk),
    .rdata (cpu_rdata),

    .mem_we (cpu_mem_we),
    .daddr (cpu_daddr),
    .wdata (cpu_wdata),
    
    .debug_wb_pc (debug_wb_pc),
    .debug_wb_ena (debug_wb_ena),
    .debug_wb_reg (debug_wb_reg),
    .debug_wb_value (debug_wb_value),
    .debug_wb_have_inst (debug_wb_have_inst)
);

// wire [31:0] IOrdata;
// wire [31:0] mem_rdata;
// wire [11:0] IOaddr12;
// wire [31:0] mem_addr;
// wire [31:0] mem_wdata;
// wire mem_we;
// wire IOen;

// bus U_bus(
//     .cpu_daddr (cpu_daddr),
//     .cpu_wdata (cpu_wdata),
//     .cpu_mem_we (cpu_mem_we),
//     .IOrdata (IOrdata),
//     .mem_rdata (mem_rdata),
//     .IOen (IOen),
//     .cpu_rdata (cpu_rdata),
//     .IOaddr12 (IOaddr12),
//     .IOwdata (IOwdata),
//     .mem_addr (mem_addr),
//     .mem_wdata (mem_wdata),
//     .mem_we (mem_we)
// );

// // 数码管
// digit_driver U_digit_driver(
//     .clk (clk_i),
//     .rst_n (rst_n),
//     .IOen (IOen),
//     .IOaddr (IOaddr12),
//     .IOwdata (IOwdata),
    
//     .led_en (led_en),
//     .led_ca (led_ca_o),
//     .led_cb (led_cb_o),
//     .led_cc (led_cc_o),
//     .led_cd (led_cd_o),
//     .led_ce (led_ce_o),
//     .led_cf (led_cf_o),
//     .led_cg (led_cg_o),
//     .led_dp (led_dp_o)
// );

// // 拨码开关
// switch_driver SD (
//     .clk (clk_i),
//     .switch (switch),

//     .switch_data (IOrdata)
// );

// // led 驱动
// led_driver U_led_driver(
//     .clk (clk_i),
//     .rst_n (rst_n),
//     .IOen (IOen),
//     .IOaddr (IOaddr12),
//     .IOwdata (IOwdata),
    
//     .led (led)
// );

// 外部存储器
DMEM dmem (
    .clk (clk),
    .waddr (cpu_daddr),
    .we (cpu_mem_we),
    .wdata (cpu_wdata),

    .rdata (cpu_rdata)
);


// DMEM dmem (
//     .clk (clk),
//     .waddr (mem_addr),
//     .we (mem_we),
//     .wdata (mem_wdata),

//     .rdata (mem_rdata)
// );

endmodule
