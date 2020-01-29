`timescale 1ns / 1ps
module EX(clk,nextPC_ex,ALUCode_ex,ALUSrcB_ex,RegDst_ex,Imm_ex,RsData_ex,RtData_ex,RtAddr_ex,RdAddr_ex,shamt_ex,jmp,RegWrite_ex,aluZero_ex,aluRes_ex,RegWriteAddr_ex);
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
    input [2:0]jmp;
    output RegWrite_ex;
    output aluZero_ex;
    output[31:0] aluRes_ex;
    output reg[4:0] RegWriteAddr_ex;
     
    //ALUSrcB的多选器
    reg[31:0]input1,input2;
    reg[3:0]ALUCode;
    always@(*)begin
        case(jmp)
            3'b011:begin
                input1<=nextPC_ex;
                input2<=32'b100;
                ALUCode=4'b0;
            end
            3'b011:begin
                input1<=nextPC_ex;
                input2<=32'b100;
                ALUCode=4'b0;
            end
            default:begin
                ALUCode<=ALUCode_ex;
                case(shamt_ex)
                    1'b0:input1<=RsData_ex;
                    1'b1:input1<=Imm_ex[10:6];  //使用偏移段进行运算的位移指令
                endcase
                case(ALUSrcB_ex)
                    1'b0:input2<=RtData_ex;
                    1'b1:input2<=Imm_ex;
                endcase
            end
        endcase
    end

    ALU ALU(
    .aluCtr(ALUCode),
    .input1(input1),
    .input2(input2),
    .RegWrite_ex(RegWrite_ex),
    .aluRes(aluRes_ex),
    .zero(aluZero_ex)
    );
     
    //写寄存器堆地址的多选器
    always@(*)begin
        case(jmp)
            3'b011:RegWriteAddr_ex<=5'b11111;
            3'b100:RegWriteAddr_ex<=5'b11111;
            default:begin
                case(RegDst_ex)
                    1'b0:RegWriteAddr_ex<=RtAddr_ex;
                    1'b1:RegWriteAddr_ex<=RdAddr_ex;
                endcase
            end
        endcase
    end
     
endmodule
