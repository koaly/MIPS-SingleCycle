ori $sp,$zero,0
addiu $t0, $zero, 12
addu $a0, $t0, $zero
jal mul3
addu $t0, $v0, $zero
j exit

mul3:
addu $t1, $a0, $a0
addu $t1, $t1, $a0
addu $v0, $zero, $t1
jr $ra

exit:
ori $s0, $t0, 0
ori $s1, $ra, 0
