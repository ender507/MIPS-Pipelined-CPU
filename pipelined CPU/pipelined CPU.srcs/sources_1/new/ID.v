`timescale 1ns / 1ps
module ID(clk,reset,inst_id,
RegWrite_wb,RegWriteAddr_wb,RegWriteData_wb,
nextPC_id,
RegDst_id,MemtoReg_id,RegWrite_id,
MemWrite_id,MemRead_id,ALUCode_id,
ALUSrcB_id,
Imm_id,RsData_id,RtData_id,
RsAddr_id,RtAddr_id,RdAddr_id,
shamt,jmp,jmpAddr,
branch,branchAddr,flag
);
    input clk;
    input reset;
    input[31:0]inst_id;
    input RegWrite_wb;
    input[4:0]RegWriteAddr_wb;
    input[31:0]RegWriteData_wb;
    input[31:0]nextPC_id;
    output RegWrite_id;
    output RegDst_id;
    output MemRead_id;
    output MemWrite_id;
    output ALUSrcB_id;
    output MemtoReg_id;
    output[3:0]ALUCode_id;
    output[31:0] Imm_id;
    output[31:0] RsData_id;
    output[31:0] RtData_id;
    output[4:0] RsAddr_id;
    output[4:0] RtAddr_id;
    output[4:0] RdAddr_id;
    output shamt;
    output[2:0]jmp;
    output[25:0]jmpAddr;
    output branch;
    output[31:0]branchAddr;
    output[1:0]flag;
    
    assign RsAddr_id=inst_id[25:21];
    assign RtAddr_id=inst_id[20:16];
    assign RdAddr_id=inst_id[15:11];
    assign Imm_id={{16{inst_id[15]}},inst_id[15:0]};//立即数的符号拓展
    assign jmpAddr=inst_id[25:0];
    assign branchAddr=nextPC_id+(Imm_id<<2);
    
     wire[2:0]Branch;
     reg branch;
     always@(*)begin
        case(Branch)
            3'b000:begin
                assign branch=1'b0;
            end
            3'b001:begin    //beq
                if(RsData_id==RtData_id)assign branch=1'b1;
                else assign branch=1'b0;
            end
            3'b010:begin    //bne
                if(RsData_id==RtData_id)assign branch=1'b0;
                else assign branch=1'b1;
            end
            3'b011:begin    //blez
                if(RsData_id == 32'b0 || RsData_id[31])assign branch=1'b1;
                else assign branch=1'b0;
            end
            3'b100:begin    //bgtz
                if(RsData_id != 32'b0 && RsData_id[31]==1'b0)assign branch=1'b1;
                else assign branch=1'b0;
            end
            3'b101:begin    //bltz
                if(RsData_id[31]==1'b0)assign branch=1'b1;
                else assign branch=1'b0;
            end
            3'b110:begin    //bgez
                if(RsData_id == 32'b0 || RsData_id[31]==1'b0)assign branch=1'b1;
                else assign branch=1'b0;
            end
        endcase
     end
     
    //控制模块
    CtrlUnit CtrlUnit(
        //输入
        .inst(inst_id),
        //输出
        .RegWrite(RegWrite_id),
        .RegDst(RegDst_id),
        .Branch(Branch),
        .MemRead(MemRead_id),
        .MemWrite(MemWrite_id),
        .ALUCode(ALUCode_id),
        .ALUSrc_B(ALUSrcB_id),
        .MemtoReg(MemtoReg_id),
        .shamt(shamt),
        .jmp(jmp),
        .flag(flag)
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

