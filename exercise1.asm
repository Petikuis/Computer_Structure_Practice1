.globl init
	init:						# $a0 address, $a1 m, $a2 n
			blez $a1 init_error		# if m <= 0 jump to init_error
			blez $a2 init_error		# if n <= 0 jump to init_error
			move $t0 $a0			# $t0 is current_address
			# to obtain the final address the following formula is used: n*m*4 + address
			mul $t1 $a1 $a2			# n*m
			sll $t1 $t1 2			# previous * 4
			add $t1 $t1 $a0			# $t1 is final_address
			li $t2 1			# $t2 is the value to be stored in each cell
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
	sum:						# $a0 address, $a1 m, $a2 n, $a3 i, ($t0) $sp + 8 j, ($t1) $sp + 4 k, ($t2) $sp l
			lw $t0 8($sp)			# get j from the stack
			lw $t1 4($sp)			# get k from the stack
			lw $t2 ($sp)			# get l from the stack
			addi $sp $sp 12			# move the stack to the last relevant element
			blez $a1 sum_error		# if m <= 0 jump to add_error
			blez $a2 sum_error		# if n <= 0 jump to add_error
			bge $t0 $a1 sum_error		# if j >= m jump to add_error
			bge $t2 $a1 sum_error		# if l >= m jump to add_error
			bge $a3 $a2 sum_error		# if i >= n jump to add_error
			bge $t1 $a2 sum_error		# if k >= n jump to add_error
			blt $t0 $t2 sum_no_errors	# if j < l jumt to add_no_error
			bgt $t0 $t2 sum_error		# if j > l jump to add_error
			bgt $a3 $t1 sum_error		# having reached this branch we know j == l, if i > k jump to error
	sum_no_errors:	# to obtain the address from (i,j) the following formula is used: (n*j + i)*4 + address
			mul $t3 $a2 $t0 		# n*j
			add $t3 $t3 $a3			# previous + i
			sll $t3 $t3 2			# previous * 4
			add $t3 $t3 $a0			# $t3 is current_address
			# to obtain the address from (k,l) the following formula is used: (n*l + k)*4 + address
			mul $t4 $a2 $t2 		# n*l
			add $t4 $t4 $t1			# previous + k
			sll $t4 $t4 2			# previous * 4
			add $t4 $t4 $a0			# $t4 is final_address
			move $t5 $zero			# $t5 is sum
	sum_loop:	bgt $t3 $t4 sum_success		# if current_address > final_address jump to add_success
							#	the > is a result of final_address being the address of the second index
							#	and the second index must also be taken into account
			lw $t6 ($t3)			# load word at current_address to $t6
			add $t5 $t5 $t6			# increment sum by $t6
			addi $t3 $t3 4			# increment current_address by 4
			b sum_loop			# jump to add_loop
	sum_success:	li $v0 0			# success, load 0 to result register $v0
			move $v1 $t5			# copy sum to $v1
			b sum_end			# jump to end
	sum_error:	li $v0 -1			# failure, load -1 to result register $v0
	sum_end:	jr $ra				# return to $ra			
			
.globl compare
	compare:					# $a0 address matrix A, $a1 adress matrix B, $a2 m, $a3 n, ($t0) $sp + 12 i, ($t1) $sp + 8 j, ($t2) $sp + 4 k, ($t3) $sp l
			lw $t0 12($sp)			# get i from the stack
			lw $t1 8($sp)			# get j from the stack
			lw $t2 4($sp)			# get k from the stack
			lw $t3 ($sp)			# get l from the stack
			addi $sp $sp 16			# move the stack to the last relevant element
			blez $a2 com_error		# if m <= 0 jump to com_error
			blez $a3 com_error		# if n <= 0 jump to com_error
			bge $t1 $a2 com_error		# if j >= m jump to com_error
			bge $t3 $a2 com_error		# if l >= m jump to com_error
			bge $t0 $a3 com_error		# if i >= n jump to com_error
			bge $t2 $a3 com_error		# if k >= n jump to com_error
			bgt $t1 $t2 com_error		# if j > l jump to com_error
			bgt $t0 $t1 com_error		# having reached this branch we know j == l, if i > k jump to error		
			# to obtain the address from (i,j) the following formula is used: (n*j + i)*4 + address
			mul $t4 $a3 $t1 		# n*j
			add $t4 $t4 $t0			# previous + i
			sll $t4 $t4 2			# previous * 4
			# to obtain the address from (k,l) the following formula is used: (n*l + k)*4 + address
			mul $t5 $a3 $t3 		# n*l
			add $t5 $t6 $t2			# previous + k
			sll $t5 $t6 2			# previous * 4
			move $t6 $zero			# $t5 is sum
			move $t7 $a0			# move to $t7 pointer in memory of matrix A
			move $t0 $a1			# move to $t0 pointer in memory of matrix B
	com_loop:	bgt $t4 $t5 com_success		# if current_address > final_address jump to com_success
							#	the > is a result of final_address being the address of the second index
							#	and the second index must also be taken into account
			add $t4 $t4 $t7			# Address in memory of matrix A
			lw $a0 ($t4)			# Load value of matrix A	
			sub $t4 $t4 $t7			# Back to current_adress	
			add $t4 $t4 $t0			# Address in memory of matrix B
			lw $a1 ($t4)			# Load value of matrix B	
			sub $t4 $t4 $t0			# Back to current_adress
			addi $t4 $t4 4			# increment current_address by 4
			sub $sp $sp 4			# Move stack pointer to store one value
			sw $ra ($sp)			# Store the $ra into the stack
			jal cmp				# Jump to compare
			lw $ra ($sp)			# Return the $ra value
			addi $sp $sp 4			# move the stack to the last relevant element
			add $t6 $t6 $v0			# add result of cmp to the result
			b com_loop			# jump to com_loop
	com_success:	li $v0 0			# success, load 0 to result register $v0
			add $v1 $zero $t6		# copy sum to $v1
			b com_exit			# jump to exit
	com_error:	li $v0 -1			# error, load -1 to result register $v0
	com_exit:	jr $ra				# return to $ra


.globl extract
	extract:					# $a0 address of the matrix, $a1 m, $a2 n, $a3 address of the vector, ($t0) $sp + 16 p, ($t1) $sp + 12 i, ($t2) $sp + 8 j, ($t3) $sp + 4 k, ($t4) $sp l
			lw $t0 16($sp)			# get p from the stack
			lw $t1 12($sp)			# get i from the stack
			lw $t2 8($sp)			# get j from the stack
			lw $t3 4($sp)			# get k from the stack
			lw $t4 ($sp)			# get l from the stack
			addi $sp $sp 20			# move the stack to the last relevant element
			blez $a1 ext_error		# if m <= 0 jump to ext_error
			blez $a2 ext_error		# if n <= 0 jump to ext_error
			blez $t0 ext_error		# if p <= 0 jump to ext_error
			bge $t2 $a1 ext_error		# if j >= m jump to ext_error
			bge $t4 $a1 ext_error		# if l >= m jump to ext_error
			bge $t1 $a2 ext_error		# if i >= n jump to ext_error
			bge $t3 $a2 ext_error		# if k >= n jump to ext_error
			blt $t2 $t4 ext_check_p		# if j < l jumt to ext_check_p
			bgt $t2 $t4 ext_error		# if j > l jump to ext_error
			bgt $t1 $t3 ext_error		# having reached this branch we know j == l, if i > k jump to error
	ext_check_p:	# to validate the size of the vector we will substract the points's indexes
			# to obtain the index from (i,j) the following formula is used: n*j + i
			mul $t5 $a2 $t2 		# n*j
			add $t5 $t5 $t1			# previous + i, $t5 is index_start
			# to obtain the address from (k,l) the following formula is used: n*l + k
			mul $t6 $a2 $t4 		# n*l
			add $t6 $t6 $t3			# previous + k, $t6 is index_end
			sub $t7 $t6 $t5			# substraction of the indexes
			addi $t7 $t7 1			# add 1 to convert from index to amount of indexes, $t7 is index_amount
			bne $t0 $t7 ext_error		# p != index_amount jump to ext_error
			sll $t5 $t5 2			# index_start * 4
			add $t5 $t5 $a0			# $t5 is current_address
			sll $t6 $t6 2			# index_end * 4
			add $t6 $t6 $a0			# $t6 is final_address
	ext_loop:	bgt $t5 $t6 ext_success		# current_address > final_address
			lw $t7 ($t5)			# load word at current_address to $t7
			sw $t7 ($a3)			# store word at vector_address from $t7
			addi $t5 $t5 4			# increment current_address by 4
			addi $a3 $a3 4			# increment vector_address by 4
			b ext_loop			# jump to ext_loop
	ext_success:	li $v0 0			# success, load 0 to result register $v0
			b ext_end			# jump to end
	ext_error:	li $v0 -1			# failure, load -1 to result register $v0
	ext_end:	jr $ra				# return to $ra