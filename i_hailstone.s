j 	main	# jump to main
i_hailstone: 	# int i_hailstone(int n)
	addiu 	$sp, $sp, -8 	# allocate 8 bytes for $fp and $ra
	sw 	$ra, 4($sp) 	# push $ra to stack
	sw 	$fp, 0($sp) 	# push $fp to stack
	addiu 	$fp, $sp, 0 	# move frame pointer pointing at stack pointer
	lw 	$t0, 8($fp) 	# load 1st arg (n) to $t0
	
	addiu	$t1, $zero, 0	# i in $t1 = 0
	addiu	$t2, $zero, 1	# $t2 = 1
while:
	beq	$t0, $t2, end_while
	addiu	$t1, $t1, 1	# i = i + 1
	
	#if ((n % 2) == 0)
	sra 	$t3, $t0, 1 	# sra 1 for divide $t0 by 2 and put to $t3
	sll 	$t3, $t3, 1 	# sll 1 for multiply $t3 by 2 and put to $t3
	subu 	$t3, $t0, $t3 	# $t3 = $t0 - $t3 (1 if n is odd and 0 if n is even)
	bne 	$t3, $zero, else
	sra	$t0, $t0, 1	# sra 1 for divide $t0 by 2 and put to $t0 (n = n / 2)
	j	end_if
else:
	addu	$t3, $t0, $t0	# $t3 = $t0 + $t0 = n + n = 2n
	addu	$t0, $t0, $t3	# $t0 = $t0 + $t3 = n + 2n = 3n	
	addiu	$t0, $t0, 1	# $t0 = 3n + 1
end_if:
	j	while
end_while:
	addu	$v0, $zero, $t1	# return i
	jr	$ra		# return function by jump to return address

main:
	lui 	$sp, 32767 	# init stack pointer
	
	# call i_hailstone(5)
	addiu	$t0, $zero, 5	# n = 5
	addiu	$sp, $sp, -4	# allocate 4 bytes for 1 arg (n)
	sw	$t0, 0($sp)	# push n in $t0 to stack
	jal	i_hailstone
	addiu	$sp, $sp, 4	# pop stack (free 4 bytes of arg)