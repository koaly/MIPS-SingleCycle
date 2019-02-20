j	main
table_A:
	addiu	$t0, $zero, 1	#$t0 = $zero + 1, $t0($8) = 1
	lui	$t1, 32768	#$t1 = 32568 << 16 (add at upper 16 bits), bit31 is 1
	slti	$t2, $t1, 0	#$t2 = $t1 < 0 = 1, $t1 is negative if 2's complement because bit31 is 1
	sltiu	$t3, $t1, 0	#$t3 = $t1 < 0 = 0, $t1 is positive if unsigned because bit31 is 1
	beq	$t2, $zero, L1	#$t2 == $zero goto L1 (always false) (test not taken)
	andi	$t0, $t0, 0	#$t0 = $t0 & 0 = 0
	ori	$t0, $t0, 2	#$t0 = $t0 | 2 = 2
	xori	$t0, $t0, 2	#$t0 = $t0 ^ 2 = 0
	beq	$t0, $zero, L1	#$t0 == $zero goto L1 (true) (test taken)
	addiu	$t0, $zero, 1	#not doing this instruction
L1:
	sb	$t2, 1($sp)	#store 1 from $t2 to $sp+1 (0x10000001) (store byte)
	addiu	$t2, $t2, 384	#$t2 = $t2 + 384 = 385
	sb	$t2, 3($sp)	#store 385 from $t2 to $sp+3 (0x10000003) should store only 385-256 = 129 (stored in 1 byte)
	sw	$t2, 4($sp)	#store 385 from $t2 to $sp+4 (0x10000004) (store word)
	lbu	$t3, 3($sp)	#load byte from $sp+3 (0x10000003) (129 or 0x81)
	lb	$t4, 3($sp)	#load byte from $sp+3 (0x10000003) with sign (0xffffff81)
	lw	$t5, 4($sp)	#load word from $sp+4 (0x10000004) (385)
	jr	$ra
table_B:
	addiu	$t1, $zero, 2	#$t1 = $zero + 2
	lui	$t2, 16384	#$t2 = 16384 << 16 (add at upper 16 bits), bit30 is 1
	sll	$t3, $t2, 1	#$t3 = $t2 << 1 (0x80000000)
	srav	$t2, $t3, $t1	#$t2 = $t3 >> $t1 (0xe0000000)
	or	$t0, $t0, $t1	#$t0 = $t0 | $t1 = 2
	srl	$t0, $t0, 1	#$t0 = $t0 >>> 1 = $t0 / 2 = 1
	sllv	$t2, $t2, $t0	#$t2 = $t2 << $t0 = $t2 << 1 (0xc0000000)
	sra	$t2, $t2, 31	#$t2 = $t2 >> 31 = all bits are 1 (0xffffffff)
	slt	$t3, $t2, $zero	#$t3 = $t2 < $zero = 1, $t2 is negative if 2's complement because bit31 is 1
	sltu	$t4, $t2, $zero	#$t3 = $t2 < $zero = 0, $t2 is positive if unsigned because all bits is 1
	srl	$t2, $t2, 31	#$t2 = $t2 >>> 31 = 1
	subu	$t1, $t1, $t2	#$t1 = $t1 - $t2 = 2 - 1 = 1
	and	$t0, $t1, $zero	#$t0 = $t1 & $zero = 0
	bne	$t4, $zero, L2	#$t4 == $zero goto L2 (always false) (test not taken)
	xor	$t2, $t2, $t2	#$t2 = $t2 ^ $t2 = 0 (reflexive)
	bne	$t3, $zero, L2	#$t3 == $zero goto L2 (true) (test taken)
	addu	$t0, $zero, $t1	#not doing this instruction
L2:
	nor	$t1, $zero, $zero #$t1 = ~($zero | $zero) = 0xffffffff (all bit is 1)
	jr	$ra
main:
	addu 	$sp, $zero, $zero #init stack pointer
	lui	$sp, 4096	#init stack pointer
	#lui	$s0, 64		#$s0 = 64 << 16 (at start instruction 1) for qtSPIM test
	addiu	$s0, $s0, 4	#$s0 = $s0 + 4 = 4 (for jump to instrunction 2)
	jalr	$s0		#jump to $s0 (table_A)
	addu	$t0, $zero, $zero
	jal	table_B
exit:
	addiu	$v0, $zero, 1	#return
	nop