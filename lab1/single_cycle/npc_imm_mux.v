`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/06/29 19:30:35
// Module Name: npc_imm_mux
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module npc_imm_mux(
    input wire [31:0] ALUc,
    input wire [31:0] ext,
    input CU_npc_imm_sel,
    
    output wire [31:0] npc_imm

    );

    assign npc_imm = (CU_npc_imm_sel == 0) ? ext : ALUc;

endmodule
