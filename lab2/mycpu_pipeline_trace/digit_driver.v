`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2022/07/01 15:27:51
// Module Name: digit_driver
// Description: 数码管显示逻辑
//////////////////////////////////////////////////////////////////////////////////


module digit_driver(
    input wire clk,
    input wire rst_n,
    input wire IOen,
    input wire [11:0] IOaddr,
    input wire [31:0] IOwdata,
    output reg [7:0] led_en,
	output reg       led_ca,
	output reg       led_cb,
    output reg       led_cc,
	output reg       led_cd,
	output reg       led_ce,
	output reg       led_cf,
	output reg       led_cg,
	output wire       led_dp

    );

wire cnt_end; // 计数结束标志
reg [12:0] cnt;// 计数器，控制led_en 刷新
reg [7:0] led[15:0];//led显示内容
reg [31:0] tmp_data;

assign cnt_end = (cnt == 13'd5000);
assign led_dp = 1;
    
always @ (posedge clk or negedge rst_n) begin //控制cnt计数器
    if (! rst_n || cnt_end) cnt <= 15'd1;
    else cnt <= cnt + 15'd1;
end

always @ (posedge clk or negedge rst_n) begin // 显示内容赋初值
    if (! rst_n) begin
    led[0]  <= 7'b0000001; led[1]  <= 7'b1001111;
    led[2]  <= 7'b0010010; led[3]  <= 7'b0000110;
    led[4]  <= 7'b1001100; led[5]  <= 7'b0100100;
    led[6]  <= 7'b0100000; led[7]  <= 7'b0001111;
    led[8]  <= 7'b0000000; led[9]  <= 7'b0001100;
    led[10] <= 7'b0001000; led[11] <= 7'b1100000;
    led[12] <= 7'b1110010; led[13] <= 7'b1000010;
    led[14] <= 7'b0110000; led[15] <= 7'b0111000;
    end
end

always @ (posedge clk or negedge rst_n) begin//控制使能信号led_en
    if (! rst_n) led_en <= 8'b0111_1111;
    else if (cnt_end) led_en <= {led_en[0] , led_en[7:1]};
end 

always @(posedge clk or negedge rst_n) begin 
    if (! rst_n) tmp_data <= 32'h0;
    else if (IOen && (IOaddr == 'h000)) tmp_data <= IOwdata;

end

always @ (posedge clk or negedge rst_n) begin// 控制数码管
    if (! rst_n) {led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b111_1111;
    else begin
        case(led_en)//根据使能信号控制灯
            8'b0111_1111 : {led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= led[tmp_data[31:28]];
            8'b1011_1111 : {led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= led[tmp_data[27:24]];
            8'b1101_1111 : {led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= led[tmp_data[23:20]];
            8'b1110_1111 : {led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= led[tmp_data[19:16]];
            8'b1111_0111 : {led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= led[tmp_data[15:12]];
            8'b1111_1011 : {led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= led[tmp_data[11:8]];
            8'b1111_1101 : {led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= led[tmp_data[7:4]];
            8'b1111_1110 : {led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= led[tmp_data[3:0]];
        default;
        endcase
    end
end

endmodule
