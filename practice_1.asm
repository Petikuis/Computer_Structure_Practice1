.data
	.align 2
		array: 	.space 800

.text
.globl main
	main:
			la $a0 array
			li $a1 20
			li $a2 10
			jal init
			move $a0 $v0
			li $v0 1
			syscall
			
			la $a0 array
			li $a1 20
			li $a2 10
			li $a3 0
			subi $sp $sp 8
			li $t0 0
			sw $t0 8($sp)
			li $t0 3
			sw $t0 4($sp)
			li $t0 0
			sw $t0 ($sp)
			jal sum
			move $a0 $v0
			li $v0 1
			syscall
			move $a0 $v1
			li $v0 1
			syscall
			
			li $v0 10
			syscall
		
.globl init
	init:						# $a0 address, $a1 m, $a2 n
			blez $a1 init_error		# if m <= 0 jump to init_error
			blez $a2 init_error		# if n <= 0 jump to init_error
			move $t0 $a0			# $t0 is current_address
			# to obtain the final address the following formula is used: n*m*4 + address
			mul $t1 $a1 $a2			# n*m
			mul $t1 $t1 4			# previous * 4
			add $t1 $t1 $a0			# $t1 is final_address
			li $t2 0			# $t2 is the value to be stored in each cell
	init_loop:	bge $t0 $t1 init_success	# if current_address >= final_adress jump to init_success
							# 	the >= is a result of final_address being the address of the last index + 1
							#	and the last address that needs to be written is that of the last index
			sw $t2 ($t0)			# load word at current_address to $t6
			addi $t0 $t0 4			# increment current_adress by 4
			b init_loop			# jump to add_loop
	init_success:	li $v0 0			# success, load 0 to result register $v0
			b init_end			# jump to end
	init_error:	li $v0 -1			# failure, load -1 to result register $v0
	init_end:	jr $ra				# return to $ra
	
.globl sum
	sum:						# $a0 address, $a1 m, $a2 n, $a3 i, ($t0) $sb + 8 j, ($t1) $sb + 4 k, ($t2) $sb l
			lw $t0 8($sp)			# get j from the stack
			lw $t1 4($sp)			# get k from the stack
			lw $t2 ($sp)			# get l from the stack
			addi $sp $sp 8			# move the stack to the last relevant element
			blez $a1 add_error		# if m <= 0 jump to add_error
			blez $a2 add_error		# if n <= 0 jump to add_error
			bge $t0 $a1 add_error		# if j >= m jump to add_error
			bge $t2 $a1 add_error		# if l >= m jump to add_error
			bge $a3 $a2 add_error		# if i >= n jump to add_error
			bge $t1 $a2 add_error		# if k >= n jump to add_error
			blt $t0 $t2 add_no_errors	# if j < l jumt to add_no_error
			bgt $t0 $t2 add_error		# if j > l jump to add_error
			bgt $a3 $t1 add_error		# having reached this branch we know j == l, if i > k jump to error
	add_no_errors:	# to obtain the address from (i,j) the following formula is used: (n*j + i)*4 + address
			mul $t3 $a2 $t0 		# n*j
			add $t3 $t3 $a3			# previous + i
			mul $t3 $t3 4			# previous * 4
			add $t3 $t3 $a0			# $t3 is current_address
			# to obtain the address from (k,l) the following formula is used: (n*l + k)*4 + address
			mul $t4 $a2 $t2 		# n*l
			add $t4 $t4 $t1			# previous + k
			mul $t4 $t4 4			# previous * 4
			add $t4 $t4 $a0			# $t4 is final_address
			move $t5 $zero			# $t5 is sum
	add_loop:	bgt $t3 $t4 add_success		# if current_address > final_address jump to add_success
							#	the > is a result of final_address being the address of the second index
							#	and the second index must also be taken into account
			lw $t6 ($t3)			# load word at current_address to $t6
			add $t5 $t5 $t6			# increment sum by $t6
			addi $t3 $t3 4			# increment current_adress by 4
			b add_loop			# jump to add_loop
	add_success:	li $v0 0			# success, load 0 to result register $v0
			move $v1 $t5			# copy sum to $v1
			b add_end			# jump to end
	add_error:	li $v0 -1			# failure, load -1 to result register $v0
	add_end:	jr $ra				# return to $ra
			
			

			
		
		
