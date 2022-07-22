	lui   s1,0xFFFFF
	
start:                          # Test led and switch
	lw   s0,0x70(s1)          # read switch	
	sw   s0,0x60(s1)          # write led
	jal getOp
	
getOp: # 获取操作
	srli s2, s0, 0x15 # get operation
	jal getAandB
	
getAandB: # 获取A和B
	slli s3, s0, 24 # 左移24位，消掉A前面的位数
	srai s3, s3, 24 # 算术右移24位得到符号拓展的操作数A
	slli s4, s0, 16 # 左移16位，消掉B前面的位数
	srai s4, s4, 24 # 算术右移24位得到符号拓展的操作数B
	jal operation
	
operation:
	add s5, zero, zero # s5与操作比较
	beq s2, s5, opNop # 000, 空操作
	addi s5, s5, 0x01
	beq s2, s5, opAdd # 001, +
	addi s5, s5, 0x01
	beq s2, s5, opSub # 010, -
	addi s5, s5, 0x01
	beq s2, s5, opAnd # 011, &
	addi s5, s5, 0x01
	beq s2, s5, opOr  # 100, |
	addi s5, s5, 0x01
	beq s2, s5, opSll # 101, <<
	addi s5, s5, 0x01
	beq s2, s5, opSra # 110, >>>
	addi s5, s5, 0x01
	beq s2, s5, opMul # 111, *
	
opNop: # 空操作
	add s0, zero, zero
	jal over
	
opAdd: # A + B
	add s0, s3, s4
	jal over
	
opSub: # A - B
	sub s0, s3, s4
	jal over
	
opAnd: # A & B
	and s0, s3, s4
	jal over
	
opOr: # A | B
	or s0, s3, s4
	jal over
	
opSll: # A << B
	sll s0, s3, s4
	jal over
	
opSra: # A >> B
	sra s0, s3, s4
	jal over
	
opMul: # A * B，使用booth算法实现
	slli s3, s3, 8 # A左移8位
	add  s6, zero, zero # 辅助位
	add  s7, zero, zero # 循环计数
	addi s8, zero, 8 # 计数终止条件
	addi t0, zero, -1 # t0,t1用来判断加减操作
	addi t1, zero, 1
	add s0, zero, zero # 复位s0
	jal loop
	
loop:
	beq s7, s8, over # 计数到8，结束
	andi s9, s4, 0x01 # 取B的最后一位
	sub s10, s6, s9 # 辅助位减去B最后一位
	addi s7, s7, 1 # 计数器加1
	jal boothJudge
	
	boothJudge:
	beq s10, t0, toSub # -1, 减[A]补
	beq s10, t1, toAdd # 1，加[A]补
	beq s10, zero, toSra # 0,只右移
	
	toSub: # 减[A]补
	sub s0, s0, s3
	jal toSra
	
	toAdd: # 加[A]补
	add s0, s0, s3
	jal toSra
	
	toSra: # 右移
	srai s0, s0, 1 # 结果右移
	srli s4, s4, 1 # B右移
	add  s6, zero, s9 # 辅助位等于B上一次最后一位
	jal loop # 继续循环
	
over:
    	sw   s0,0x00(s1)	  # 写数码管
	jal start
