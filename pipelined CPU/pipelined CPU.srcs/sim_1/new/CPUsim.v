`timescale 1ns / 1ps
module CPUsim;
    reg clkin; 
    reg reset; 
    wire [31:0]inst_if,aluRes_ex,Dout_mem,RtData_id,PC_out;
    top  uut(
        .clk(clkin), 
        .reset(reset),
        .inst_if(inst_if),
        .aluRes_ex(aluRes_ex),
        .Dout_mem(Dout_mem),
        .RtData_id(RtData_id),
        .PC_out(PC_out)
    ); 
    initial begin  
    clkin = 0; 
    reset = 1;  
    #100;                        //开始100ns对整个CPU进行初始化
    reset = 0; 
    end 
    parameter PERIOD = 20;      //周期长度(ns) 
    always begin 
    clkin = 1'b0; 
    #(PERIOD / 2) clkin = 1'b1; 
    #(PERIOD / 2) ; 
    end 
endmodule 