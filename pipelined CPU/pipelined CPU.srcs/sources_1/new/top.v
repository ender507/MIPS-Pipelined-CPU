`timescale 1ns / 1ps
module top(clk,reset,inst_if,alu_res_ex,Dout_mem,RtData_id,PC_out);

    input clk;
    input reset;
    output[31:0]inst_if;
    output[31:0]aluRes_ex;
    output[31:0]Dout_mem;//memory读出的结果
    output[31:0]RtData_id;
    output[31:0]PC_out;
 
    
    //IF级
    wire BranchOrPc_mem;        //跳转与否
    wire[31:0]BranchAddr_mem;   //跳转地址
    wire[31:0]nextPC_if;        //下一条指令的地址
    wire[31:0]inst_if;          //取出的指令
    
    IF IF(
        //输入
        .clk(clk),
        .reset(reset),
        .BranchOrPc(BranchOrPc_mem),
        .BranchAddr(BranchAddr_mem),
        //输出
        .nextPC_if(nextPC_if),
        .inst_if(inst_if),
        .pc(PC_out)
    );
    //IF_ID级间寄存器
    wire[31:0]nextPC_id;
    wire[31:0]inst_id;
    flipflop#(.width(32))IF_ID1(.clk(clk),.reset(reset),.in(nextPC_if),.out(nextPC_id));
    flipflop#(.width(32))IF_ID2(.clk(clk),.reset(reset),.in(inst_if),.out(inst_id));


    //ID级(寄存器模块包含WB级的功能，故需要部分WB级的信号)
    wire[4:0]RtAddr_id,RdAddr_id;                        
    wire MemtoReg_id,RegWrite_id,MemWrite_id;
    wire MemRead_id,ALUSrcB_id,RegDst_id,Branch_id;         
    wire[3:0]ALUCode_id;
    wire[31:0]Imm_id,RsData_id,RtData_id;
    wire shamt_id;
    //WB的数据与信号
    wire RegWrite_wb;
    wire[31:0]RegWriteData_wb;
    wire[4:0]RegWriteAddr_wb;
    assign RegWriteData_wb = RegData_wb;
    ID ID(
        //输入 
        .clk(clk),
        .reset(reset),
        .inst_id(inst_id),
        .RegWrite_wb(RegWrite_wb),
        .RegWriteAddr_wb(RegWriteAddr_wb),
        .RegWriteData_wb(RegWriteData_wb),
        //输出
        .RegWrite_id(RegWrite_id),
        .RegDst_id(RegDst_id),
        .MemtoReg_id(MemtoReg_id),
        .MemWrite_id(MemWrite_id),
        .MemRead_id(MemRead_id),
        .ALUCode_id(ALUCode_id),
        .ALUSrcB_id(ALUSrcB_id),
        .Branch_id(Branch_id),
        .Imm_id(Imm_id),
        .RsData_id(RsData_id),
        .RtData_id(RtData_id),
        .RtAddr_id(RtAddr_id),
        .RdAddr_id(RdAddr_id),
        .shamt(shamt_id)
    );
    //ID_EX级间寄存器
    wire[4:0] RtAddr_ex,RdAddr_ex;
    wire MemtoReg_ex,RegWrite_ex,MemWrite_ex;
    wire MemRead_ex,ALUSrcB_ex,RegDst_ex,Branch_ex;
    wire[3:0] ALUCode_ex;
    wire[31:0] Imm_ex,RsData_ex,RtData_ex,next_pc_ex;
    wire shamt_ex;
    flipflop#(.WIDTH(1))ID_EX1(.clk(clk),.reset(reset),.in(RegWrite_id),.out(RegWrite_ex));
    flipflop#(.WIDTH(1))ID_EX2(.clk(clk),.reset(reset),.in(RegDst_id),.out(RegDst_ex));
    flipflop#(.WIDTH(1))ID_EX3(.clk(clk),.reset(reset),.in(MemRead_id),.out(MemRead_ex));
    flipflop#(.WIDTH(1))ID_EX4(.clk(clk),.reset(reset),.in(MemWrite_id),.out(MemWrite_ex));
    flipflop#(.WIDTH(1))ID_EX5(.clk(clk),.reset(reset),.in(ALUSrcB_id),.out(ALUSrcB_ex));
    flipflop#(.WIDTH(1))ID_EX6(.clk(clk),.reset(reset),.in(MemtoReg_id),.out(MemtoReg_ex));
    flipflop#(.WIDTH(1))ID_EX7(.clk(clk),.reset(reset),.in(Branch_id),.out(Branch_ex));
    flipflop#(.WIDTH(4))ID_EX8(.clk(clk),.reset(reset),.in(ALUCode_id),.out(ALUCode_ex));
    flipflop#(.WIDTH(32))ID_EX9(.clk(clk),.reset(reset),.in(nextPC_id),.out(nextPC_ex));
    flipflop#(.WIDTH(32))ID_EX10(.clk(clk),.reset(reset),.in(RsData_id),.out(RsData_ex));
    flipflop#(.WIDTH(32))ID_EX11(.clk(clk),.reset(reset),.in(RtData_id),.out(RtData_ex));
    flipflop#(.WIDTH(32))ID_EX12(.clk(clk),.reset(reset),.in(Imm_id),.out(Imm_ex));
    flipflop#(.WIDTH(5))ID_EX13(.clk(clk),.reset(reset),.in(RtAddr_id),.out(RtAddr_ex));
    flipflop#(.WIDTH(5))ID_EX14(.clk(clk),.reset(reset),.in(RdAddr_id),.out(RdAddr_ex));
    flipflop#(.WIDTH(1))ID_EX14(.clk(clk),.reset(reset),.in(shamt_id),.out(shamt_ex));
    
    //EX级
    wire[31:0] BranchAddr_ex;
    wire[31:0] alu_res_ex;
    wire alu_zero_ex;
    wire[4:0] RegWriteAddr_ex;
    EX EX(
        //输入
        .clk(clk),
        .nextPC_ex(nextPC_ex),
        .ALUCode_ex(ALUCode_ex),
        .ALUSrcB_ex(ALUSrcB_ex),
        .RegDst_ex(RegDst_ex),
        .Imm_ex(Imm_ex),
        .RsData_ex(RsData_ex),
        .RtData_ex(RtData_ex),
        .RtAddr_ex(RtAddr_ex),
        .RdAddr_ex(RdAddr_ex),
        .shamt_ex(shamt_ex),
        .RegWrite_ex(RegWrite_ex),
        //输出
        .BranchAddr_ex(BranchAddr_ex),
        .aluZero_ex(aluZero_ex),
        .aluRes_ex(aluRes_ex),
        .RegWriteAddr_ex(RegWriteAddr_ex)
    );
    //EX_MEM级间寄存器
    wire RegWrite_mem;
    wire MemRead_mem;
    wire MemWrite_mem;
    wire MemtoReg_mem;
    wire[31:0] aluRes_mem;
    wire aluZero_mem;
    wire[31:0] RtData_mem;
    wire[4:0] RegWriteAddr_mem;
    flipflop#(.WIDTH(1))EX_MEM1(.clk(clk),.reset(reset),.in(RegWrite_ex),.out(RegWrite_mem));
    flipflop#(.WIDTH(1))EX_MEM2(.clk(clk),.reset(reset),.in(MemRead_ex),.out(MemRead_mem));
    flipflop#(.WIDTH(1))EX_MEM3(.clk(clk),.reset(reset),.in(MemWrite_ex),.out(MemWrite_mem));
    flipflop#(.WIDTH(1))EX_MEM4(.clk(clk),.reset(reset),.in(MemtoReg_ex),.out(MemtoReg_mem));
    flipflop#(.WIDTH(1))EX_MEM5(.clk(clk),.reset(reset),.in(Branch_ex),.out(Branch_mem));
    flipflop#(.WIDTH(32))EX_MEM6(.clk(clk),.reset(reset),.in(Branch_addr_ex),.out(Branch_addr_mem));
    flipflop#(.WIDTH(32))EX_MEM7(.clk(clk),.reset(reset),.in(aluRes_ex),.out(aluRes_mem));
    flipflop#(.WIDTH(1))EX_MEM8(.clk(clk),.reset(reset),.in(aluZero_ex),.out(aluZero_mem));
    flipflop#(.WIDTH(32))EX_MEM9(.clk(clk),.reset(reset),.in(RtData_ex),.out(RtData_mem));
    flipflop#(.WIDTH(5))EX_MEM10(.clk(clk),.reset(reset),.in(RegWriteAddr_ex),.out(RegWriteAddr_mem));


    //MEM级
    wire[31:0] Dout_mem;
    MEM MEM(
        //输入
        .clk(clk),
        .MemRead_mem(MemRead_mem),
        .MemWrite_mem(MemWrite_mem),
        .Branch_mem(Branch_mem),
        .aluZero_mem(aluZero_mem),
        .aluRes_mem(aluRes_mem),
        .RtData_mem(RtData_mem),
        .BranchOrPc_mem(BranchOrPc_mem),
        .Dout_mem(Dout_mem)
    );     
    //MEM_WB级间寄存器
    wire[31:0] Dout_wb;
    wire[31:0] aluRes_wb;
    wire MemtoReg_wb;
    flipflop#(.WIDTH(1))MEM_WB1(.clk(clk),.reset(reset),.in(RegWrite_mem),.out(RegWrite_wb));
    flipflop#(.WIDTH(1))MEM_WB2(.clk(clk),.reset(reset),.in(MemtoReg_mem),.out(MemtoReg_wb));
    flipflop#(.WIDTH(32))MEM_WB3(.clk(clk),.reset(reset),.in(Dout_mem),.out(Dout_wb));
    flipflop#(.WIDTH(32))MEM_WB4(.clk(clk),.reset(reset),.in(aluRes_mem),.out(aluRes_wb));
    flipflop#(.WIDTH(5))MEM_WB5(.clk(clk),.reset(reset),.in(RegWriteAddr_mem),.out(RegWriteAddr_wb));
    
    
    //WB级
    reg[31:0] regData_wb;
    always@(*)
    begin
        case(MemtoReg_wb)
            1'b0:regData_wb<=aluRes_wb;   //来自ALU
            1'b1:regData_wb<=Dout_wb;      //来自RAM
        endcase
    end
    
endmodule
