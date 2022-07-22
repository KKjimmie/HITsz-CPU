`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/07/01 15:55:38
// Module Name: led_driver
// Description: ledœ‘ æ
//////////////////////////////////////////////////////////////////////////////////

module led_driver(
    input wire clk,
    input wire rst_n,
    input wire IOen,
    input wire [11:0] IOaddr,
    input wire [31:0] IOwdata,

    output reg [23:0] led
    );

    always@(posedge clk or negedge rst_n) begin
        if(~ rst_n) led <= 'h00000000;
        else if (IOen && (IOaddr == 'h060))led <= IOwdata[23:0];
    end
endmodule
