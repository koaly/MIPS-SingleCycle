j 	main	# jump to main
r_hailstone: 	# int r_hailstone(int n)
	addiu 	$sp, $sp, -8 	# allocate 8 bytes for $fp and $ra
	sw 	$ra, 4($sp) 	# push $ra to stack
	sw 	$fp, 0($sp) 	# push $fp to stack
	addiu 	$fp, $sp, 0 	# move frame pointer pointing at stack pointer
	lw 	$t0, 8($fp) 	# load 1st arg (n) to $t0
	
 	# if (n == 1)
	addiu 	$t1, $zero, 1 	# load 1 to $t1
	bne 	$t0, $t1, elif 	# if n != 1 jump to "elif"
	lw 	$ra, 4($fp) 	# load return address
	lw 	$fp, 0($fp) 	# load previous frame pointer
	addiu 	$sp, $sp, 8 	# pop stack (free 8 bytes of $ra and $fp)
	addiu 	$v0, $zero, 0 	# return 0
	jr 	$ra	 	# return function by jump to return address
	
elif: 	# else if ((n % 2) == 0)
	sra 	$t1, $t0, 1 	# sra 1 for divide $t0 by 2 and put to $t1
	sll 	$t1, $t1, 1 	# sll 1 for multiply $t1 by 2 and put to $t1
	subu 	$t1, $t0, $t1 	# $t1 = $t0 - $t1 (1 if n is odd and 0 if n is even)
	bne 	$t1, $zero, else
	sra	$t0, $t0, 1	# sra 1 for divide $t0 by 2 and put to $t0 (n = n / 2)
	addiu	$sp, $sp, -4	# allocate 4 bytes for 1 arg (n)
	sw	$t0, 0($sp)	# push n in $t0 to stack
	jal	r_hailstone	# call r_hailstorn(n/2)
	addiu	$sp, $sp, 4	# pop stack (free 4 bytes of arg)
	lw	$ra, 4($fp)	# load return address
	lw	$fp, 0($fp)	# load previous frame pointer
	addiu	$sp, $sp, 8	# pop stack (free 2 bytes of $ra and $fp)
	addiu 	$v0, $v0, 1 	# return 1 + older return value
	jr	$ra		# return function by jump to return address
	
else:	# else
	addu	$t1, $t0, $t0	# $t1 = $t0 + $t0 = n + n = 2n
	addu	$t0, $t0, $t1	# $t0 = $t0 + $t1 = n + 2n = 3n
	addiu	$t0, $t0, 1	# $t0 = 3n + 1
	addiu	$sp, $sp, -4	# allocate 4 bytes for 1 arg (n)
	sw	$t0, 0($sp)	# push n in $t0 to stack
	jal	r_hailstone	# call r_hailstorn(3n+1)
	addiu	$sp, $sp, 4	# pop stack (free 4 bytes of arg)
	lw	$ra, 4($fp)	# load return address
	lw	$fp, 0($fp)	# load previous frame pointer
	addiu	$sp, $sp, 8	# pop stack (free 2 bytes of $ra and $fp)
	addiu 	$v0, $v0, 1 	# return 1 + older return value
	jr	$ra		# return function by jump to return address
	
main:
	lui 	$sp, 32767 	# init stack pointer
	
	# call r_hailstone(5)
	addiu	$t0, $zero, 5	# n = 5
	addiu	$sp, $sp, -4	# allocate 4 bytes for 1 arg (n)
	sw	$t0, 0($sp)	# push n in $t0 to stack
	jal	r_hailstone
	addiu	$sp, $sp, 4	# pop stack (free 4 bytes of arg)