`timescale 1ns / 1ps
module EX(clk,nextPC_ex,ALUCode_ex,ALUSrcB_ex,RegDst_ex,Imm_ex,RsData_ex,RtData_ex,RtAddr_ex,RdAddr_ex,shamt_ex,RegWrite_ex,BranchAddr_ex,aluZero_ex,aluRes_ex,RegWriteAddr_ex);
    input clk;
    input[31:0] nextPC_ex;
    input[3:0] ALUCode_ex;
    input ALUSrcB_ex;
    input RegDst_ex;
    input[31:0] Imm_ex;
    input[31:0] RsData_ex;
    input[31:0] RtData_ex;
    input[4:0] RtAddr_ex;
    input[4:0] RdAddr_ex;
    input shamt_ex;
    output RegWrite_ex;
    output[31:0] BranchAddr_ex;
    output aluZero_ex;
    output[31:0] aluRes_ex;
    output reg[4:0] RegWriteAddr_ex;
     
    assign BranchAddr_ex=nextPC_ex+(Imm_ex<<2);
    //ALUSrcB的多选器
    reg[31:0]input1,input2;
    always@(*)begin
        case(shamt_ex)
            1'b0:input1<=RsData_ex;
            1'b1:input1<=Imm_ex[10:6];  //使用偏移段进行运算的位移指令
        endcase
        case(ALUSrcB_ex)
            1'b0:input2<=RtData_ex;
            1'b1:input2<=Imm_ex;
        endcase
    end

    ALU ALU(
    .aluCtr(ALUCode_ex),
    .input1(input1),
    .input2(input2),
    .RegWrite_ex(RegWrite_ex),
    .aluRes(aluRes_ex),
    .zero(aluZero_ex)
    );
     
    //写寄存器堆地址的多选器
    always@(*)begin
        case(RegDst_ex)
            1'b0:RegWriteAddr_ex<=RtAddr_ex;
            1'b1:RegWriteAddr_ex<=RdAddr_ex;
        endcase
    end
     
endmodule
