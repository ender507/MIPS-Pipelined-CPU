`timescale 1ns / 1ps
module CtrlUnit(inst,RegWrite,RegDst,Branch,MemRead,MemWrite,ALUCode,ALUSrc_B,MemtoReg,shamt);
    input[31:0]inst;
    output RegWrite;
    output RegDst;
    output Branch;
    output MemRead;
    output MemWrite;
    output[3:0]ALUCode;
    output ALUSrc_B;
    output MemtoReg;
    output shamt;
    wire[5:0] op;
    wire[5:0] func;
    wire[4:0] rt;
    assign op = inst[31:26];
    assign func = inst[5:0];
     
    //R型指令
    parameter R_type_op=6'b000000;
    parameter ADDU_func=6'b100001;
    parameter SUBU_func=6'b100011;
    parameter AND_func=6'b100100;
    parameter OR_func=6'b100101;
    parameter XOR_func=6'b100110;
    parameter NOR_func=6'b100111;
    parameter SLT_func=6'b101010;
    parameter SLTU_func=6'b101011;
    parameter MOVN_func=6'b001011;
    parameter MOVZ_func=6'b001010;
    parameter SLL_func=6'b000000;
    parameter SRL_func=6'b000010;
    parameter SRA_func=6'b000011;
    parameter SLLV_func=6'b000100;
    parameter SRLV_func=6'b000110;
    parameter SRAV_func=6'b000111;
    wire ADDU,SUBU,AND,OR,XOR,NOR,SLT,SLTU,MOVN,MOVZ,SLL,SRL,SRA,SLLV,SRLV,SRAV;
    assign ADDU=(op==R_type_op)&&(func==ADDU_func);
    assign SUBU=(op==R_type_op)&&(func==SUBU_func);
    assign AND=(op==R_type_op)&&(func==AND_func);
    assign OR=(op==R_type_op)&&(func==OR_func);
    assign XOR=(op==R_type_op)&&(func==XOR_func);
    assign NOR=(op==R_type_op)&&(func==NOR_func);
    assign SLT=(op==R_type_op)&&(func==SLT_func);
    assign SLTU=(op==R_type_op)&&(func==SLTU_func);
    assign MOVN=(op==R_type_op)&&(func==MOVN_func);
    assign MOVZ=(op==R_type_op)&&(func==MOVZ_func);
    assign SLL=(op==R_type_op)&&(func==SLL_func);
    assign SRL=(op==R_type_op)&&(func==SRL_func);
    assign SRA=(op==R_type_op)&&(func==SRA_func);
    assign SLLV=(op==R_type_op)&&(func==SLLV_func);
    assign SRLV=(op==R_type_op)&&(func==SRLV_func);
    assign SRAV=(op==R_type_op)&&(func==SRAV_func);
    wire R_type;
    assign R_type=ADDU||SUBU||AND||OR||XOR||NOR||SLT||SLTU||MOVN||MOVZ||SLL||SRL||SRA||SLLV||SRLV||SRAV;
     
    //Branch
    parameter BEQ_op=6'b000100;
    parameter BNE_op=6'b000101;
    wire BEQ,BNE,Branch;
    assign BEQ=(op==BEQ_op);
    assign BNE=(op==BNE_op);
    assign Branch=BEQ||BNE;
    
    // I型指令
    parameter ADDIU_op=6'b001001;
    parameter ANDI_op=6'b001100;
    parameter ORI_op=6'b001101;
    parameter XORI_op=6'b001110;
    parameter SLTI_op=6'b001010;
    parameter SLTIU_op=6'b001011;
    parameter LUI_op=6'b001111;
    wire ADDIU,ANDI,ORI,XORI,SLTI,SLTIU,LUI;
    assign ADDIU=(op==ADDIU_op);
    assign ANDI=(op==ANDI_op);
    assign ORI=(op==ORI_op);
    assign XORI=(op==XORI_op);
    assign SLTI=(op==SLTI_op);
    assign SLTIU=(op==SLTIU_op);
    assign LUI=(op==LUI_op);
    wire I_type;
    assign I_type=ADDIU||ANDI||ORI||XORI||SLTI||SLTIU||LUI;
     
    // sw或lw
    parameter SW_op=6'b101011;
    parameter LW_op=6'b100011;
    wire SW,LW;
    assign SW=(op==SW_op);
    assign LW=(op==LW_op);
     
    // 控制信号
    assign RegWrite=LW||R_type||I_type;
    assign RegDst=R_type;
    assign MemWrite=SW;
    assign MemRead=LW;
    assign MemtoReg=LW;
    assign ALUSrc_B=LW||SW||I_type;
    assign shamt=SLL||SRL||SRA;
    
    // ALUCode
    parameter alu_add=4'b0000;
    parameter alu_and=4'b0001;
    parameter alu_or=4'b0010;
    parameter alu_xor=4'b0011;
    parameter alu_sub=4'b0100;
    parameter alu_nor=4'b0101;
    parameter alu_sll=4'b0110;
    parameter alu_srl=4'b0111;
    parameter alu_sra=4'b1000;
    parameter alu_lui=4'b1001;
    parameter alu_slt=4'b1010;
    parameter alu_movn=4'b1011;
    parameter alu_movz=4'b1100;
    reg[3:0] ALUCode;
    always@(*)begin
        if(op==R_type_op)begin
            case(func)
                ADDU_func: ALUCode<=alu_add;
                SUBU_func: ALUCode<=alu_sub;
                AND_func: ALUCode<=alu_and;
                OR_func: ALUCode<=alu_or;
                XOR_func: ALUCode<=alu_xor;
                NOR_func: ALUCode<=alu_nor;
                SLT_func: ALUCode<=alu_slt;
                SLTU_func: ALUCode<=alu_slt;
                MOVN_func: ALUCode<=alu_movn;
                MOVZ_func: ALUCode<=alu_movz;
                SLL_func: ALUCode<=alu_sll;
                SRL_func: ALUCode<=alu_srl;
                SRA_func: ALUCode<=alu_sra;
                SLLV_func: ALUCode<=alu_sll;
                SRLV_func: ALUCode<=alu_srl;
                SRAV_func: ALUCode<=alu_sra;
                default: ALUCode<=alu_add;
            endcase
        end
        else begin
            case(op)
                BEQ_op: ALUCode<=alu_sub;
                BNE_op: ALUCode<=alu_sub;
                ADDIU_op: ALUCode<=alu_add;
                ANDI_op: ALUCode<=alu_and;
                ORI_op: ALUCode<=alu_or;
                XORI_op: ALUCode<=alu_xor;
                SLTI_op: ALUCode<=alu_slt;
                SLTIU_op: ALUCode<=alu_slt;
                LUI_op: ALUCode<=alu_lui;
                SW_op: ALUCode<=alu_add;
                LW_op: ALUCode<=alu_add;
                default: ALUCode<=alu_add;
            endcase
        end
    end
     
endmodule
