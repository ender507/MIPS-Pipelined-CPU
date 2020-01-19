`timescale 1ns / 1ps
module flipflop(clk,reset,in,out);

    parameter width=32;
    input clk;
    input reset;
    input [width-1:0]in;
    output [width-1:0]out;
    reg [width-1:0]out;
    always@(posedge clk)
        if(reset)out<={width{1'b0}};
        else out<=in;
        
endmodule
