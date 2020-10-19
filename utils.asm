.globl set
	# set allows for setting an in the matrix to an specific value
	set:						# $a0 address, $a1 m, $a2 n, $a3 i, ($t0) $sp + 4 j, ($t1) $sp value
			lw $t0 4($sp)			# get j from the stack
			lw $t1 ($sp)			# get value from the stack
			addi $sp $sp 8			# move the stack to the last relevant element
			# to obtain the address from (i,j) the following formula is used: (n*j + i)*4 + address
			mul $t2 $a2 $t0 		# n*j
			add $t2 $t2 $a3			# previous + i
			sll $t2 $t2 2			# previous * 4
			add $t2 $t2 $a0			# $t1 is load_address
			sw $t1 ($t2)			# store word at address $t2 from $t1
			jr $ra				# return to $ra