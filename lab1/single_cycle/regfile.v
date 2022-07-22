`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/06/29 14:03:21
// Module Name: regfile
// Description:  
//////////////////////////////////////////////////////////////////////////////////


module regfile(
    input wire clk,
    input wire cu_we,
    input wire [4:0] raddr1,
    input wire [4:0] raddr2,
    input wire [4:0] waddr,
    input wire [31:0] wdata,

    output wire [31:0] rdata1,
    output wire [31:0] rdata2

    );

    reg[31:0] rf[31:0];
    wire[31:0] zero = 32'b0;
    
    assign rdata1 = ( raddr1 == 5'b0 )? zero : rf[raddr1];
    assign rdata2 = ( raddr2 == 5'b0 )? zero : rf[raddr2];
    
    always @(posedge clk) begin
        if (cu_we && !(waddr == 5'b0) ) begin
            rf[waddr] <= wdata;
        end
    end

endmodule
