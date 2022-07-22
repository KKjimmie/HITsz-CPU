`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/07/04 15:11:27 
// Module Name: switch_driver
// Description: 拨码开关，读拨码开关数据
//////////////////////////////////////////////////////////////////////////////////


module switch_driver(
    input wire clk,
    input wire [23:0] switch,

    output reg [31:0] switch_data
    );

always @(posedge clk) begin
    switch_data <= switch;
end


endmodule
