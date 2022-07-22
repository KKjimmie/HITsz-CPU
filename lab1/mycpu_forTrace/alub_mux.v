`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/06/29 14:59:57
// Module Name: alub_mux
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module alub_mux(
    input wire CU_alub_sel,
    input wire [31:0] rdata2,
    input wire [31:0] imm,

    output wire [31:0] alub

    );

    assign alub = (CU_alub_sel == 1) ? rdata2 : 
                  imm;

endmodule
