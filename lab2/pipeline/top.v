`timescale 1ns / 1ps

module top(
    input  wire clk_i,
    input  wire rst_i,
    input  wire [23:0] switch,
    
    output wire led0_en_o,
    output wire led1_en_o,
    output wire led2_en_o,
    output wire led3_en_o,
    output wire led4_en_o,
    output wire led5_en_o,
    output wire led6_en_o,
    output wire led7_en_o,
    output wire led_ca_o,
    output wire led_cb_o,
    output wire led_cc_o,
    output wire led_cd_o,
    output wire led_ce_o,
    output wire led_cf_o,
    output wire led_cg_o,
    output wire led_dp_o,
    output wire [23:0] led
);

wire rst_n = !rst_i;

wire [31:0] IOwdata;
wire [7:0] led_en;

 assign {led7_en_o, led6_en_o, led5_en_o, led4_en_o, led3_en_o, led2_en_o, led1_en_o, led0_en_o} = led_en;
 wire clk_out;
 wire clk_g;
 wire locked;
 cpuclk U_cpuclk(
     .clk_in1 (clk_i),
     .locked (locked),
     .clk_out1 (clk_out)
 );
 assign clk_g = locked & clk_out;

wire [31:0] cpu_rdata;
wire cpu_mem_we;
wire [31:0] cpu_daddr;
wire [31:0] cpu_wdata;
miniRV mini_rv_u (
    .rst_i (rst_n),
    .clk_i (clk_out),
    .rdata (cpu_rdata),

    .mem_we (cpu_mem_we),
    .daddr (cpu_daddr),
    .wdata (cpu_wdata)
);

 wire [31:0] IOrdata;
 wire [31:0] mem_rdata;
 wire [11:0] IOaddr12;
 wire [31:0] mem_addr;
 wire [31:0] mem_wdata;
 wire mem_we;
 wire IOen;

 bus U_bus(
     .cpu_daddr (cpu_daddr),
     .cpu_wdata (cpu_wdata),
     .cpu_mem_we (cpu_mem_we),
     .IOrdata (IOrdata),
     .mem_rdata (mem_rdata),
     .IOen (IOen),
     .cpu_rdata (cpu_rdata),
     .IOaddr12 (IOaddr12),
     .IOwdata (IOwdata),
     .mem_addr (mem_addr),
     .mem_wdata (mem_wdata),
     .mem_we (mem_we)
 );

 // 数码管
 digit_driver U_digit_driver(
     .clk (clk_out),
     .rst_n (rst_n),
     .IOen (IOen),
     .IOaddr (IOaddr12),
     .IOwdata (IOwdata),
    
     .led_en (led_en),
     .led_ca (led_ca_o),
     .led_cb (led_cb_o),
     .led_cc (led_cc_o),
     .led_cd (led_cd_o),
     .led_ce (led_ce_o),
     .led_cf (led_cf_o),
     .led_cg (led_cg_o),
     .led_dp (led_dp_o)
 );

 // 拨码开关
 switch_driver SD (
     .clk (clk_out),
     .switch (switch),

     .switch_data (IOrdata)
 );

 // led 驱动
 led_driver U_led_driver(
     .clk (clk_out),
     .rst_n (rst_n),
     .IOen (IOen),
     .IOaddr (IOaddr12),
     .IOwdata (IOwdata),
    
     .led (led)
 );


 DMEM dmem (
     .clk (clk_out),
     .waddr (mem_addr),
     .we (mem_we),
     .wdata (mem_wdata),

     .rdata (mem_rdata)
 );

endmodule
