`timescale 1ns / 1ps
module top(clk,reset,inst_if,aluRes_ex,Dout_mem,RtData_id,PC_out);

    input clk;
    input reset;
    output[31:0]inst_if;
    output[31:0]aluRes_ex;
    output[31:0]Dout_mem;//memory读出的结果
    output[31:0]RtData_id;
    output[31:0]PC_out;
    
    //IF级
    wire[31:0]nextPC_if;        //下一条指令的地址
    wire[31:0]inst_if;          //取出的指令
    wire[2:0]jmp_id;            //跳转指令的类型。如果不是跳转指令则为3'b000
    wire[25:0]jmpAddr_id;       // == inst[25:0]
    wire[31:0]RsData_id;        //jr和jalr需要Rs寄存器的数据进行跳转
    wire[31:0]jmpRegData;       //jr和jalr需要的寄存器可能需要转发数据
    wire[31:0]aluRes_ex;
    wire branch;
    wire[31:0]branchAddr;
    wire[4:0]RsAddr_mem;
    wire[4:0] RegWriteAddr_mem;
    wire[4:0]RsAddr_ex;
    assign jmpRegData=(RsAddr_mem==RsAddr_ex)? aluRes_ex : RsData_id;
   
    IF IF(
        //输入
        .clk(clk),
        .reset(reset),
        .branch(branch),
        .branchAddr(branchAddr),
        .jmp(jmp_id),
        .jmpAddr(jmpAddr_id),
        .RsData(jmpRegData),
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
    wire[4:0]RsAddr_id,RtAddr_id,RdAddr_id;                        
    wire MemtoReg_id,RegWrite_id,MemWrite_id;
    wire MemRead_id,ALUSrcB_id,RegDst_id;         
    wire[3:0]ALUCode_id;
    wire[31:0]Imm_id,RtData_id;
    wire shamt_id;
    wire[1:0]flag_id;
    //WB的数据与信号
    wire RegWrite_wb;
    wire[31:0]RegWriteData_wb;
    wire[4:0]RegWriteAddr_wb;
    reg[31:0] regData_wb;
    assign RegWriteData_wb = regData_wb;
    ID ID(
        //输入 
        .clk(clk),
        .reset(reset),
        .inst_id(inst_id),
        .RegWrite_wb(RegWrite_wb),
        .RegWriteAddr_wb(RegWriteAddr_wb),
        .RegWriteData_wb(RegWriteData_wb),
        .nextPC_id(nextPC_id),
        //输出
        .RegWrite_id(RegWrite_id),
        .RegDst_id(RegDst_id),
        .MemtoReg_id(MemtoReg_id),
        .MemWrite_id(MemWrite_id),
        .MemRead_id(MemRead_id),
        .ALUCode_id(ALUCode_id),
        .ALUSrcB_id(ALUSrcB_id),
        .Imm_id(Imm_id),
        .RsData_id(RsData_id),
        .RtData_id(RtData_id),
        .RsAddr_id(RsAddr_id),
        .RtAddr_id(RtAddr_id),
        .RdAddr_id(RdAddr_id),
        .shamt(shamt_id),
        .jmp(jmp_id),
        .jmpAddr(jmpAddr_id),
        .branch(branch),
        .branchAddr(branchAddr),
        .flag(flag_id)
    );
    //ID_EX级间寄存器
    wire[4:0] RtAddr_ex,RdAddr_ex;
    wire MemtoReg_ex,RegWrite_ex,MemWrite_ex;
    wire MemRead_ex,ALUSrcB_ex,RegDst_ex;
    wire[3:0] ALUCode_ex;
    wire[31:0] Imm_ex,RsData_ex,RtData_ex,nextPC_ex;
    wire shamt_ex;
    wire[2:0]jmp_ex;
    wire[1:0]flag_ex;
    flipflop#(.width(1))ID_EX1(.clk(clk),.reset(reset),.in(RegWrite_id),.out(RegWrite_ex));
    flipflop#(.width(1))ID_EX2(.clk(clk),.reset(reset),.in(RegDst_id),.out(RegDst_ex));
    flipflop#(.width(1))ID_EX3(.clk(clk),.reset(reset),.in(MemRead_id),.out(MemRead_ex));
    flipflop#(.width(1))ID_EX4(.clk(clk),.reset(reset),.in(MemWrite_id),.out(MemWrite_ex));
    flipflop#(.width(1))ID_EX5(.clk(clk),.reset(reset),.in(ALUSrcB_id),.out(ALUSrcB_ex));
    flipflop#(.width(1))ID_EX6(.clk(clk),.reset(reset),.in(MemtoReg_id),.out(MemtoReg_ex));
    flipflop#(.width(3))ID_EX7(.clk(clk),.reset(reset),.in(jmp_id),.out(jmp_ex));
    flipflop#(.width(4))ID_EX8(.clk(clk),.reset(reset),.in(ALUCode_id),.out(ALUCode_ex));
    flipflop#(.width(32))ID_EX9(.clk(clk),.reset(reset),.in(nextPC_id),.out(nextPC_ex));
    flipflop#(.width(32))ID_EX10(.clk(clk),.reset(reset),.in(RsData_id),.out(RsData_ex));
    flipflop#(.width(32))ID_EX11(.clk(clk),.reset(reset),.in(RtData_id),.out(RtData_ex));
    flipflop#(.width(32))ID_EX12(.clk(clk),.reset(reset),.in(Imm_id),.out(Imm_ex));
    flipflop#(.width(5))ID_EX13(.clk(clk),.reset(reset),.in(RtAddr_id),.out(RtAddr_ex));
    flipflop#(.width(5))ID_EX14(.clk(clk),.reset(reset),.in(RdAddr_id),.out(RdAddr_ex));
    flipflop#(.width(1))ID_EX15(.clk(clk),.reset(reset),.in(shamt_id),.out(shamt_ex));
    flipflop#(.width(5))ID_EX16(.clk(clk),.reset(reset),.in(RsAddr_id),.out(RsAddr_ex));
    flipflop#(.width(2))ID_EX17(.clk(clk),.reset(reset),.in(flag_id),.out(flag_ex));
    
    //EX级
    wire aluZero_ex;
    wire[4:0] RegWriteAddr_ex;
    wire RegWrite2_ex;
    wire[31:0]RsData2_ex,RtData2_ex;
    wire[31:0]aluRes_mem;
    wire[31:0] aluRes_wb;
    //转发条件的引入
    assign RsData2_ex = (jmp_ex==3'b001||jmp_ex==3'b010)?0:(RsAddr_ex == RegWriteAddr_mem)? aluRes_mem : (RsAddr_ex == RegWriteAddr_wb)? aluRes_wb : RsData_ex;
    assign RtData2_ex = (jmp_ex==3'b001||jmp_ex==3'b010)?0:(RtAddr_ex == RegWriteAddr_mem)? aluRes_mem : (RtAddr_ex == RegWriteAddr_wb)? aluRes_wb : RtData_ex;
    EX EX(
        //输入
        .clk(clk),
        .nextPC_ex(nextPC_ex),
        .ALUCode_ex(ALUCode_ex),
        .ALUSrcB_ex(ALUSrcB_ex),
        .RegDst_ex(RegDst_ex),
        .Imm_ex(Imm_ex),
        .RsData_ex(RsData2_ex),
        .RtData_ex(RtData2_ex),
        .RtAddr_ex(RtAddr_ex),
        .RdAddr_ex(RdAddr_ex),
        .shamt_ex(shamt_ex),
        .jmp(jmp_ex),
        //输出
        .RegWrite_ex(RegWrite2_ex),
        .aluZero_ex(aluZero_ex),
        .aluRes_ex(aluRes_ex),
        .RegWriteAddr_ex(RegWriteAddr_ex)
    );
    //EX_MEM级间寄存器
    wire RegWrite_mem;
    wire MemRead_mem;
    wire MemWrite_mem;
    wire MemtoReg_mem;
    wire aluZero_mem;
    wire[31:0] RtData_mem;
    wire[1:0]flag_mem;
    flipflop#(.width(1))EX_MEM1(.clk(clk),.reset(reset),.in(RegWrite_ex & RegWrite2_ex),.out(RegWrite_mem));
    flipflop#(.width(1))EX_MEM2(.clk(clk),.reset(reset),.in(MemRead_ex),.out(MemRead_mem));
    flipflop#(.width(1))EX_MEM3(.clk(clk),.reset(reset),.in(MemWrite_ex),.out(MemWrite_mem));
    flipflop#(.width(1))EX_MEM4(.clk(clk),.reset(reset),.in(MemtoReg_ex),.out(MemtoReg_mem));
    flipflop#(.width(32))EX_MEM5(.clk(clk),.reset(reset),.in(aluRes_ex),.out(aluRes_mem));
    flipflop#(.width(1))EX_MEM6(.clk(clk),.reset(reset),.in(aluZero_ex),.out(aluZero_mem));
    flipflop#(.width(32))EX_MEM7(.clk(clk),.reset(reset),.in(RtData_ex),.out(RtData_mem));
    flipflop#(.width(5))EX_MEM8(.clk(clk),.reset(reset),.in(RegWriteAddr_ex),.out(RegWriteAddr_mem));
    flipflop#(.width(5))EX_MEM9(.clk(clk),.reset(reset),.in(RsAddr_ex),.out(RsAddr_mem));
    flipflop#(.width(2))EX_MEM10(.clk(clk),.reset(reset),.in(flag_ex),.out(flag_mem));
    //MEM级
    
    wire[31:0] Dout_mem;
    MEM MEM(
        //输入
        .clk(clk),
        .reset(reset),
        .MemRead_mem(MemRead_mem),
        .MemWrite_mem(MemWrite_mem),
        .aluZero_mem(aluZero_mem),
        .aluRes_mem(aluRes_mem),
        .RtData_mem(RtData_mem),
        .flag(flag_mem),
        //输出
        .Dout_mem(Dout_mem)
    );     
    //MEM_WB级间寄存器
    wire[31:0] Dout_wb;
    wire MemtoReg_wb;
    flipflop#(.width(1))MEM_WB1(.clk(clk),.reset(reset),.in(RegWrite_mem),.out(RegWrite_wb));
    flipflop#(.width(1))MEM_WB2(.clk(clk),.reset(reset),.in(MemtoReg_mem),.out(MemtoReg_wb));
    flipflop#(.width(32))MEM_WB3(.clk(clk),.reset(reset),.in(Dout_mem),.out(Dout_wb));
    flipflop#(.width(32))MEM_WB4(.clk(clk),.reset(reset),.in(aluRes_mem),.out(aluRes_wb));
    flipflop#(.width(5))MEM_WB5(.clk(clk),.reset(reset),.in(RegWriteAddr_mem),.out(RegWriteAddr_wb));
    
    
    //WB级
    always@(*)
    begin
        case(MemtoReg_wb)
            1'b0:regData_wb<=aluRes_wb;   //来自ALU
            1'b1:regData_wb<=Dout_wb;      //来自RAM
        endcase
    end
    
endmodule
