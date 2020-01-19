`timescale 1ns / 1ps
module RegisterFiles(clk, reset, RegWrite_wb,Addr_A,Addr_B,RegWriteAddr,RegWriteData,data_A,data_B);
    input clk, reset, RegWrite_wb;
    input[4:0] Addr_A,Addr_B,RegWriteAddr;
    input[31:0] RegWriteData;
    output[31:0] data_A,data_B;
    //¶Á¼Ä´æÆ÷
    reg[31:0]register [1:31];
    integer i;
    assign data_A=(Addr_A==0)?0: register[Addr_A];
    assign data_B=(Addr_B==0)?0: register[Addr_B];
    //Ğ´¼Ä´æÆ÷
    always@(posedge clk or posedge reset)begin
        if(reset==1)
            for(i=1; i<32; i= i+1)
            register[i]<=0;
        else if((RegWriteAddr!=0)&&(RegWrite_wb==1))
            register[RegWriteAddr]<= RegWriteData;
    end
 
endmodule
