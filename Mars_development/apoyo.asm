.text
.globl cmp
	cmp: 		beq $a0 $a1 equal_symbol		# if $a0 == $a1 jump to equal_symbol
			li $v0 0				# $a0 != $a1, load 0
			jr $ra					# return to $ra
	equal_symbol:	li $v0 1				# $a0 == $a1, load 1
			jr $ra					# return to $ra
