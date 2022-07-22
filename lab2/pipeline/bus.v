`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Create Date: 2022/07/04 14:35:43
// Module Name: bus
// Description: ����,���е�ַ��������ݴ���
//////////////////////////////////////////////////////////////////////////////////


module bus(
    input wire [31:0] cpu_daddr,
    input wire [31:0] cpu_wdata,
    input wire cpu_mem_we,
    input wire [31:0] IOrdata,
    input wire [31:0] mem_rdata,

    output wire IOen,
    output wire [31:0] cpu_rdata,
    output wire [11:0] IOaddr12,
    output wire [31:0] IOwdata,
    output wire [31:0] mem_addr,
    output wire [31:0] mem_wdata,
    output wire mem_we
    );

    assign IOen = (cpu_daddr[31:12] == 20'hfffff) ? 1 : 0;

    // cpu_rdata Ϊ���뿪���������dmem����������
    assign cpu_rdata = (IOen) ? IOrdata : mem_rdata;

    // IOwdata ���������ܻ���led
    assign IOwdata = cpu_wdata;

    // dmemдʹ���ź���cpu����
    assign mem_we = (cpu_daddr[31:12] == 'hfffff) ? 0 : cpu_mem_we;

    // dmemд����Ϊcpu�������ݣ�д�����mem_we�ж�
    assign mem_wdata = cpu_wdata;

    // mem_addr dmem��ַ
    assign mem_addr = cpu_daddr;
    
    assign IOaddr12 =  (IOen) ? cpu_daddr[11:0] : 'hfff;



endmodule
