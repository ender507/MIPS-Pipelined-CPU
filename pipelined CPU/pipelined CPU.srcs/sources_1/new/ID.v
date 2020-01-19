`timescale 1ns / 1ps
module ID(clk,reset,inst_id,
RegWrite_wb,RegWriteAddr_wb,RegWriteData_wb,
RegDst_id,MemtoReg_id,RegWrite_id,
MemWrite_id,MemRead_id,ALUCode_id,
ALUSrcB_id,Branch_id,
Imm_id,RsData_id,RtData_id,
RtAddr_id,RdAddr_id,shamt
);
    input clk;
    input reset;
    input[31:0]inst_id;
    input RegWrite_wb;
    input[4:0]RegWriteAddr_wb;
    input[31:0]RegWriteData_wb;
    output RegWrite_id;
    output RegDst_id;
    output MemRead_id;
    output MemWrite_id;
    output ALUSrcB_id;
    output Branch_id;
    output MemtoReg_id;
    output[2:0]ALUCode_id;
    output[31:0] Imm_id;
    output[31:0] RsData_id;
    output[31:0] RtData_id;
    output[4:0] RtAddr_id;
    output[4:0] RdAddr_id;
    output shamt;
     
    assign RtAddr_id=inst_id[20:16];
    assign RdAddr_id=inst_id[15:11];
    assign Imm_id={{16{inst_id[15]}},inst_id[15:0]};//立即数的符号拓展
     
    //控制模块
    CtrlUnit CtrlUnit(
        //输入
        .inst(inst_id),
        //输出
        .RegWrite(RegWrite_id),
        .RegDst(RegDst_id),
        .Branch(Branch_id),
        .MemRead(MemRead_id),
        .MemWrite(MemWrite_id),
        .ALUCode(ALUCode_id),
        .ALUSrc_B(ALUSrcB_id),
        .MemtoReg(MemtoReg_id),
        .shamt(shamt)
    ); 
    
    //寄存器
    RegisterFiles RegisterFiles(
        //输入，写入信号和数据由WB级来提供
        .clk(clk),
        .reset(reset),
        .RegWrite_wb(RegWrite_wb),
        .Addr_A(inst_id[25:21]),
        .Addr_B(inst_id[20:16]),
        .RegWriteAddr(RegWriteAddr_wb),
        .RegWriteData(RegWriteData_wb),
        //输出
        .data_A(RsData_id),
        .data_B(RtData_id)
    );
     
endmodule

