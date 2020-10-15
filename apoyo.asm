.text
.globl cmp
	cmp: 		beq $a0 $a1 equal_symbol
			li $v0 0
			jr $ra
	equal_symbol:	li $v0 1
			jr $ra