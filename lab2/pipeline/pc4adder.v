`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/07 15:20:18
// Design Name: 
// Module Name: pc4adder
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


module pc4adder(
    input wire [31:0] pc,

    output wire [31:0] pc4
    );

    assign pc4 = pc + 'd4;
endmodule
