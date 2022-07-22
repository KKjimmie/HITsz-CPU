`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/06/29 14:33:49
// Module Name: pc 
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module pc(
    input wire clk,
    input wire rst,
    input wire [31:0] npc,

    output reg [31:0] pc

    );

    always @ (posedge clk) begin
        if(rst) pc <= -4;
        else pc <= npc;
    end
endmodule
