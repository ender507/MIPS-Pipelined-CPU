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
        .we(~MemRead_mem&MemWrite_mem),     //写使能
        .reset(reset),
        .flag(flag),                       //决定读写长度
        .a(aluRes_mem[9:0]),                //地址
        .wd(RtData_mem),                    //写入的数据
        .rd(Dout_mem)                       //读出的数据
    );
     
endmodule
