`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/11 14:44:28
// Design Name: 
// Module Name: npc_mux
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


module npc_mux(
    input wire [31:0] EX_npc,
    input wire EX_jump,
    input wire [31:0] pc4,

    output wire [31:0] npc
    );

    assign npc = (! EX_jump) ? pc4 : EX_npc;

endmodule
