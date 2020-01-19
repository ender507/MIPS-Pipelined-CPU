`timescale 1ns / 1ps
module ALU( 
input [31:0] input1, 
input [31:0] input2, 
input [2:0] aluCtr, 
input RegWrite_ex,
output reg[31:0] aluRes, 
output reg zero 
);
    always @(input1 or input2 or aluCtr)
    begin 
        case(aluCtr) 
            4'b0000: aluRes = input1 + input2;
            4'b0001: aluRes = input1 & input2;
            4'b0010: aluRes = input1 | input2;
            4'b0011: aluRes = input1 ^ input2; 
            4'b0100: aluRes = input1 - input2;
            4'b0101: aluRes =~(input1 & input2);
            4'b0110: aluRes = input1 << input2;
            4'b0111: aluRes = input1 >> input2;
            4'b1000: aluRes = input1 >>> input2;
            4'b1001: aluRes = input2 << 16;
            4'b1010: aluRes = (input1<input2);
            4'b1011: 
            begin
                aluRes = input1;
                if(input2[31]==0)RegWrite_ex=0;
            end 
            4'b1100:
            begin
                aluRes = input1;
                if(input2!=32'b0)RegWrite_ex=0;
            end
            default: aluRes = 0; 
        endcase 
        if(aluRes == 0) zero = 1; 
        else zero = 0;
    end 
endmodule 
