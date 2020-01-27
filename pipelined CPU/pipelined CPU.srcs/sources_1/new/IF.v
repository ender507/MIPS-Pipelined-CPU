`timescale 1ns / 1ps
module IF(clk,reset,BranchOrPc,BranchAddr,jmp,jmpAddr,RsData,nextPC_if,inst_if,pc);
    input clk;
    input reset;   
    input BranchOrPc;//== Branch & aluZero
    input[31:0]BranchAddr;//Branch跳转地址
    input[2:0]jmp;
    input[25:0]jmpAddr;
    input[31:0]RsData;
    output[31:0]nextPC_if;//pc+4
    output[31:0]inst_if;//从ROM中读的指令
    output[31:0]pc;
    
    assign nextPC_if = pc + 32'b100;   
    reg[31:0]  pc_in;
    always@(*)
    begin
        case({jmp,BranchOrPc})
            4'b0000:pc_in<=nextPC_if;
            4'b0010:pc_in<={nextPC_if[29:26],jmpAddr[25:0],2'b00};//j
            4'b0100:pc_in<=RsData;//jr
            4'b0110:pc_in<={nextPC_if[29:26],jmpAddr[25:0],2'b00};//jal
            4'b1000:pc_in<=RsData;//jalr
            default:pc_in<=BranchAddr;
        endcase
    end
    reg[31:0] pc;
    always@(posedge clk)
    begin
        if(reset) pc<=32'b0;
        else pc<=pc_in;
    end 
    
    //指令ROM
    InstructionROM InstructionROM (
        .a(pc[11:2]),
        .spo(inst_if)
    );
     
endmodule
