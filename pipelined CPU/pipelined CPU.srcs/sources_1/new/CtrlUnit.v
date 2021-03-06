`timescale 1ns / 1ps
module CtrlUnit(inst,RegWrite,RegDst,Branch,MemRead,MemWrite,ALUCode,ALUSrc_B,MemtoReg,shamt,jmp,flag);
    input[31:0]inst;
    output RegWrite;
    output RegDst;
    output[2:0]Branch;
    output MemRead;
    output MemWrite;
    output[3:0]ALUCode;
    output ALUSrc_B;
    output MemtoReg;
    output shamt;
    output[2:0]jmp;
    output[1:0]flag;
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
    parameter JR_func=6'b001000;
    parameter JALR_func=6'b001001;
    wire ADDU,SUBU,AND,OR,XOR,NOR,SLT,SLTU,MOVN,MOVZ,SLL,SRL,SRA,SLLV,SRLV,SRAV,JR,JALR;
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
    assign JR=(op==R_type_op)&&(func==JR_func);
    assign JALR=(op==R_type_op)&&(func==JALR_func);
    wire R_type;
    assign R_type=ADDU||SUBU||AND||OR||XOR||NOR||SLT||SLTU||MOVN||MOVZ||SLL||SRL||SRA||SLLV||SRLV||SRAV||JR||JALR;
     
    //分支
    parameter BEQ_op=6'b000100;
    parameter BNE_op=6'b000101;
    parameter BLEZ_op=6'b000110;
    parameter BGTZ_op=6'b000111;
    parameter BLTZ_op=6'b000001;
    parameter BGEZ_op=6'b000001;
    wire BEQ,BNE,BLEZ,BGTZ,BLTZ,BGEZ;
    wire[2:0]Branch;
    assign BEQ=(op==BEQ_op);
    assign BNE=(op==BNE_op);
    assign BLEZ=(op==BLEZ_op);
    assign BGTZ=(op==BGTZ_op);
    assign BLTZ=(op==BLTZ_op)&&(inst[20:16]==5'b00000);
    assign BGEZ=(op==BGEZ_op)&&(inst[20:16]==5'b00001);
    assign Branch=BEQ? 3'b001: BNE? 3'b010: BLEZ? 3'b011 : BGTZ? 3'b100 : BLTZ? 3'b101 :BGEZ? 3'b110 : 3'b000;
    
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
     
    //J型指令
    parameter J_op=6'b000010;
    parameter JAL_op=6'b000011;
    wire J,JAL;
    assign J=(op==J_op);
    assign JAL=(op==JAL_op);
     
    // 内存读写
    parameter SW_op=6'b101011;
    parameter LW_op=6'b100011;
    parameter SB_op=6'b101000;
    parameter LB_op=6'b100000;
    parameter LBU_op=6'b100100;
    wire SW,LW,SB,LB,LBU;
    assign SW=(op==SW_op);
    assign LW=(op==LW_op);
    assign SB=(op==SB_op);
    assign LB=(op==LB_op);
    assign LBU=(op==LBU_op);
    wire[1:0]flag;
    assign flag=(SB||LB||LBU)? 2'b00:2'b11;
     
    // 控制信号
    assign RegWrite=LW||LB||LBU||R_type||I_type;
    assign RegDst=R_type;
    assign MemWrite=SW||SB;
    assign MemRead=LW||LB||LBU;
    assign MemtoReg=LW||LB||LBU;
    assign ALUSrc_B=LW||SW||SB||LB||LBU||I_type;
    assign shamt=SLL||SRL||SRA;
    assign jmp=J?3'b001:JR?3'b010:JAL?3'b011:JALR?3'b100:3'b000;
    
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
