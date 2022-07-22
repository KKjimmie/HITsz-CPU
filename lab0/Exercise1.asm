	lui   s1,0xFFFFF
	
start:                          # Test led and switch
	lw   s0,0x70(s1)          # read switch	
	sw   s0,0x60(s1)          # write led
	jal getOp
	
getOp: # ��ȡ����
	srli s2, s0, 0x15 # get operation
	jal getAandB
	
getAandB: # ��ȡA��B
	slli s3, s0, 24 # ����24λ������Aǰ���λ��
	srai s3, s3, 24 # ��������24λ�õ�������չ�Ĳ�����A
	slli s4, s0, 16 # ����16λ������Bǰ���λ��
	srai s4, s4, 24 # ��������24λ�õ�������չ�Ĳ�����B
	jal operation
	
operation:
	add s5, zero, zero # s5������Ƚ�
	beq s2, s5, opNop # 000, �ղ���
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
	
opNop: # �ղ���
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
	
opMul: # A * B��ʹ��booth�㷨ʵ��
	slli s3, s3, 8 # A����8λ
	add  s6, zero, zero # ����λ
	add  s7, zero, zero # ѭ������
	addi s8, zero, 8 # ������ֹ����
	addi t0, zero, -1 # t0,t1�����жϼӼ�����
	addi t1, zero, 1
	add s0, zero, zero # ��λs0
	jal loop
	
loop:
	beq s7, s8, over # ������8������
	andi s9, s4, 0x01 # ȡB�����һλ
	sub s10, s6, s9 # ����λ��ȥB���һλ
	addi s7, s7, 1 # ��������1
	jal boothJudge
	
	boothJudge:
	beq s10, t0, toSub # -1, ��[A]��
	beq s10, t1, toAdd # 1����[A]��
	beq s10, zero, toSra # 0,ֻ����
	
	toSub: # ��[A]��
	sub s0, s0, s3
	jal toSra
	
	toAdd: # ��[A]��
	add s0, s0, s3
	jal toSra
	
	toSra: # ����
	srai s0, s0, 1 # �������
	srli s4, s4, 1 # B����
	add  s6, zero, s9 # ����λ����B��һ�����һλ
	jal loop # ����ѭ��
	
over:
    	sw   s0,0x00(s1)	  # д�����
	jal start
