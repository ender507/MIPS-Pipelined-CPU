`timescale 1ns / 1ps
module IF(clk,reset,BranchOrPc,BranchAddr,nextPC_if,inst_if,pc);
    input clk;
    input reset;   
    input BranchOrPc;//== Branch & aluZero
    input[31:0]BranchAddr;//Branch跳转地址
    output[31:0]nextPC_if;//pc+4
    output[31:0]inst_if;//从ROM中读的指令
    output[31:0]pc;
    
    assign nextPC_if = pc + 32'b100;   
    reg[31:0]  pc_in;
    always@(*)
    begin
        case(BranchOrPc)
            1'b0:pc_in<=nextPC_if;
            1'b1:pc_in<=BranchAddr;
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
