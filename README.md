## 备注
1. 测试指令集1 (测试指令集.asm) 包含的指令：

|类型|具体指令|
|:-:|:-:|
|立即数相关(i)|addiu, andi, ori, xori, slti, sltiu|
|寄存器相关(r)|addu, subu, and, or, xor, nor, slt, sltu|
|移动(r)|movn, movz|
|位移(r)|sll, srl, sra, sllv, srlv, srav|
|高位立即数装入(i)|lui|

2. 测试指令集2 (测试指令集2.asm) 包含的指令：

|类型|具体指令|
|:-:|:-:|
|跳转(j/r)|j, jr, jal, jalr|
|分支(i)|beq, bne, blez, bgtz, bltz, bgez|
|内存访问(i)|lw, lb, lbu, sw, sb|

其中，跳转和分支指令含有1个延迟槽

3. 仿真使用的机器语言的路径：
  - 指令集1：\pipelined CPU\pipelined CPU.srcs\sources_1\ROM.coe
  - 指令集2：\pipelined CPU\pipelined CPU.srcs\sources_1\ROM2.coe
