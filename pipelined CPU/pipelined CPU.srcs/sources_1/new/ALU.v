`timescale 1ns / 1ps
module ALU( 
input [31:0] input1, 
input [31:0] input2, 
input [3:0] aluCtr, 
output reg RegWrite_ex,
output reg[31:0] aluRes, 
output reg zero 
);
    reg[31:0]tmp;
    reg[31:0]i;
    always @(input1 or input2 or aluCtr)
    begin 
        assign RegWrite_ex=1;
        case(aluCtr) 
            4'b0000: aluRes = input1 + input2;
            4'b0001: aluRes = input1 & input2;
            4'b0010: aluRes = input1 | input2;
            4'b0011: aluRes = input1 ^ input2; 
            4'b0100: aluRes = input1 - input2;
            4'b0101: aluRes =~(input1 | input2);
            4'b0110: aluRes = input2 << input1;
            4'b0111: aluRes = input2 >> input1;
            4'b1000: 
            begin
                aluRes=input2;
                assign i=input1;
                while(i!=32'b0)begin
                    assign i=i>>1;
                    aluRes = aluRes>>1;
                    aluRes[31]=input2[31];
                end
            end            
            4'b1001: aluRes = input2 << 16;
            4'b1010: 
            begin
                tmp = input1 - input2;
                aluRes = tmp[31];
            end 
            4'b1011: 
            begin
                aluRes = input1;
                if(input2==0)assign RegWrite_ex=0;
            end 
            4'b1100:
            begin
                aluRes = input1;
                if(input2!=0)assign RegWrite_ex=0;
            end
            default: aluRes = 0; 
        endcase 
        if(aluRes == 0) zero = 1; 
        else zero = 0;
    end 
endmodule 
