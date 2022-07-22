# HITsz-miniRV-cpu

HITsz 2022夏季学期计算机设计与实践课程实验，设计及实现了能够执行miniRV-1中24条指令的单周期CPU以及流水线CPU。

> 实现的指令：add,sub,and,or,xor,sll,srl,sra,addi,andi,ori,xori,alli,aril,aria,lw,jalr,sw,beq,bne, lt,bge,lui,jal

```
├─lab0 /* RISC-V汇编程序设计*/
├─lab1 /* 实验1：单周期cpu设计*/
│  ├─mycpu_forTrace /* trace测试用*/
│  └─single_cycle /* 下板用*/
└─lab2 /*实验2：流水线cpu设计*/
    ├─mycpu_pipeline_trace /* trace测试用*/
    └─pipeline /*下板用*/
```

仅供参考。trace比对中，可能会有的变量定义了但是没有使用。