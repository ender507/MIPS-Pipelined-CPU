`timescale 1ns / 1ps
module MEM(clk,reset,MemRead_mem,MemWrite_mem,aluZero_mem,aluRes_mem,RtData_mem,flag,Dout_mem);
    input clk;
    input reset;
    input MemRead_mem;
    input MemWrite_mem;
    input aluZero_mem;
    input[31:0]aluRes_mem;
    input[31:0] RtData_mem;
    input[1:0]flag;
    output[31:0] Dout_mem;
     
    DataRAM DataRAM(
        .clk(clk),
        .we(~MemRead_mem&MemWrite_mem),     //дʹ��
        .reset(reset),
        .flag(flag),                       //������д����
        .a(aluRes_mem[9:0]),                //��ַ
        .wd(RtData_mem),                    //д�������
        .rd(Dout_mem)                       //����������
    );
     
endmodule
