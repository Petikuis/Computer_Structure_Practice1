.globl extractValues
	extractValues:					# $a0 addressA, $a1 addressS, $a2 addressE, $a3 addressMa, ($t0) $sp + 4 m, ($t1) $sp n
			lw $t0 4($sp)			# get m from the stack
			lw $t1($sp)			# get n from the stack
			blez $t0 extV_error		# if m <= 0 go to extV_error
			blez $t1 extV_error		# if n <= 0 go to extV_error
			mul $t3 $t0 $t1			# m*n
			mul $t3 $t3 4			# previous*4
			add $t3 $t3 $a0			# $t3 is the final_address
			move $t4 $zero 			# register for operations to separate the float numbers parts
			
	extV_loop:	bge $a0 $t3 extV_success	# Go to extV_success whe it has finished with the matrix
			lw $t5 ($a0)			# Get the float in the corresponding cell
			srl $t4 $t5 31			# Move the sign to the less significant bit
			sw $t4 ($a1) 			# Store the sgin in its corresponding position
			
			srl $t4 $t5 23			# Move the exponent to the less significant bits
			and $t4 $t4 255			# Get just the exponent of the floats values
			bnez $t4 check_255		# Check if the exponent is equal to 0
			li $t6 1			# If exponent == 0 store 1
			b store_exp			# Jump to store exponent
	check_255:	bne $t4 255 store_exp		# Check if the exponent is equal to 255
			li $t6 2			# If exponent == 255 store 2	
	store_exp:	sw $t4 ($a2)			# Store the exponent in its corresponding position
			
			sll $t4 $t5 9			# Get rid of exponent and sign
			srl $t4 $t4 9			# Move the mantissato the less significant bit
			bne $t6 $zero store_mantissa	# If exponent == 0 or 255 m23 is 0 and we store
			add $t4 $t4 8388608		# m23 = 1 if exponent between 1 and 254
	store_mantissa: sw $t4 ($a3)			# Store the mantissa in its correspondig position
			add $a0 $a0 4			# Add 4 to the current address of matrixA
			add $a1 $a1 4			# Add 4 to the current address of matrixS
			add $a2 $a2 4			# Add 4 to the current address of matrixE
			add $a3 $a3 4			# Add 4 to the current address of matrixMa
			b extV_loop			# Jump to extV_loop
			
	extV_success:	li $v0 0			# Return 0 if success
			b extV_end			# Jump to end
	extV_error:	li $v0 -1			# Return -1 if error
	extV_end:	jr $ra				# Return								
							
					
			