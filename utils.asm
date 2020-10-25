.text
.globl set
	# set allows for setting an in the matrix to an specific value
	set:						# $a0 address, $a1 m, $a2 n, $a3 i, ($t0) $sp + 4 j, ($t1) $sp value
			lw $t0 4($sp)			# get j from the stack
			lw $t1 ($sp)			# get value from the stack
			addi $sp $sp 8			# move the stack to the last relevant element
			blez $a1 set_error		# if m <= 0 jump to set_error
			blez $a2 set_error		# if n <= 0 jump to set_error
			bge $t0 $a1 set_error		# if j >= m jump to set_error
			bltz $t0 set_error		# if j < 0 jump to set_error
			bge $a3 $a2 set_error		# if i >= n jump to set_error
			bltz $a3 set_error		# if i < 0 jump to set_error
			# to obtain the address from (i,j) the following formula is used: (n*j + i)*4 + address
			mul $t2 $a2 $t0 		# n*j
			add $t2 $t2 $a3			# previous + i
			sll $t2 $t2 2			# previous * 4
			add $t2 $t2 $a0			# $t1 is load_address
			sw $t1 ($t2)			# store word at address $t2 from $t1
			li $v0 0			# success, load 0 to result register $v0
			b set_end			# jump to set_end
	set_error:	li $v0 -1			# failure, load -1 to result register $v0
	set_end:	jr $ra				# return to $ra
