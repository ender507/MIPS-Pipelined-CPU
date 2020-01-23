## 备注
1. 测试指令集1 (测试指令集.asm) 包含的指令：

|类型|具体指令|
|:-:|:-:|
|立即数相关(i)|addiu, andi, ori, xori, slti, sltiu|
|寄存器相关(r)|addu, subu, and, or, xor, nor, slt, sltu|
|移动(r)|movn, movz|
|位移(r)|sll, srl, sra, sllv, srlv, srav|
|高位立即数装入(i)|lui|

2. 测试指令集2 (测试指令集2.asm) 应当包含的指令：

|类型|具体指令|
|:-:|:-:|
|跳转(j/r)|j, jr, jal, jalr|
|分支(i)|beq, bne, blez, bgtz, bltz, bgez|
|内存访问(i)|lw, lb, lbu, sw, sb|

注意：
  - 跳转和分支指令都含有一个延迟槽
  - 实际asm文件中只选取了部分有代表性的指令进行验证，不包含全部指令，但写出来的CPU支持以上全部指令
  - 在实现的CPU中默认数据和指令使用不同的内存，存在数据和指令地址相同的情况（在不同内存的相同地址）

3. 仿真使用的机器语言的路径：
  - 指令集1：\pipelined CPU\pipelined CPU.srcs\sources_1\ROM.coe
  - 指令集2：\pipelined CPU\pipelined CPU.srcs\sources_1\ROM2.coe
