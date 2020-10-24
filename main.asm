.data
	.align 2
		array1: 	.space 800
		array2:		.space 800
		array3:		.space 800
		vector: 	.space 20
		
		choose:		.asciiz "Enter a number to select a function:\n1. init\n2. add\n3. compare\n4. extract integer\n5. extract\n"
		amount:		.asciiz "\nEnter the amount of tests you want to perform: "
		newline:	.asciiz "\n"
		
		address:	.asciiz "\nEnter an address: "
		width:		.asciiz "\nEnter a matrix width: "
		height:		.asciiz "\nEnter a matrix height: "
		size:		.asciiz "\nEnter a vector size: "
		x:		.asciiz "\nEnter an x coordinate: "
		y:		.asciiz "\nEnter a y coordinate: "
		value:		.asciiz "\nEnter a value: "

.text
.globl main
	main:				# print choose
					la $a0 choose
					li $v0 4
					syscall
					# get function choice
					li $v0 5
					syscall
					move $t0 $v0
					# print amount
					la $a0 amount
					li $v0 4
					syscall
					# get amount
					li $v0 5
					syscall
					move $t1 $v0
					sub $sp $sp 8
					sw $t1 ($sp)
					sw $t0 4($sp)
	main_loop:			beqz $t1 exit
					# jump to appropriate function
					lw $t0 4($sp)
					sub $t1 $t1 1
					sw $t1 ($sp)
					beq $t0 1 main_init
					beq $t0 2 main_add
					beq $t0 3 main_compare
					beq $t0 4 main_extract_int
					beq $t0 5 main_extract_float
	main_return:			lw $t1 ($sp)
					b main_loop
					
					# exit
	exit:				li $v0 10
					syscall
	
	main_init:			# print address
					la $a0 address
					li $v0 4
					syscall
					# get address
					li $v0 5
					syscall
					move $t0 $v0
					# print width
					la $a0 width
					li $v0 4
					syscall
					# get width
					li $v0 5
					syscall
					move $a2 $v0
					# print height
					la $a0 height
					li $v0 4
					syscall
					# get height
					li $v0 5
					syscall
					move $a1 $v0
					# restore the address
					move $a0 $t0
					# save current $ra
					sub $sp $sp 4
					sw $ra ($sp)
					# jump to init
					jal init
					lw $ra ($sp)
					addi $sp $sp 4
					# print result
					b main_single_result
					
	main_add:			# save current $ra
					sub $sp $sp 4
					sw $ra ($sp)
					# print address
					la $a0 address
					li $v0 4
					syscall
					# get address
					li $v0 5
					syscall
					move $t0 $v0
					# print width
					la $a0 width
					li $v0 4
					syscall
					# get width
					li $v0 5
					syscall
					move $a2 $v0
					# print height
					la $a0 height
					li $v0 4
					syscall
					# get height
					li $v0 5
					syscall
					move $a1 $v0
					sub $sp $sp 12
					# print first x
					la $a0 x
					li $v0 4
					syscall
					# get first x
					li $v0 5
					syscall
					move $a3 $v0
					# setup stack
					sub $sp $sp 12
					# print first y
					la $a0 y
					li $v0 4
					syscall
					# get first y
					li $v0 5
					syscall
					sw $v0 8($sp)
					# print second x
					la $a0 x
					li $v0 4
					syscall
					# get second x
					li $v0 5
					syscall
					sw $v0 4($sp)
					# print second y
					la $a0 y
					li $v0 4
					syscall
					# get second y
					li $v0 5
					syscall
					sw $v0 ($sp)
					# restore the address
					move $a0 $t0
					# jump to sum
					jal sum
					lw $ra ($sp)
					addi $sp $sp 4
					# print result
					b main_double_result
					
	main_compare:			# save current $ra
					sub $sp $sp 4
					sw $ra ($sp)
					# print address
					la $a0 address
					li $v0 4
					syscall
					# get address
					li $v0 5
					syscall
					move $t0 $v0
					
					# print address
					la $a0 address
					li $v0 4
					syscall
					# get address
					li $v0 5
					syscall
					move $a1 $v0
					# print width
					la $a0 width
					li $v0 4
					syscall
					# get width
					li $v0 5
					syscall
					move $a3 $v0
					# print height
					la $a0 height
					li $v0 4
					syscall
					# get height
					li $v0 5
					syscall
					move $a2 $v0
					sub $sp $sp 12
					# setup stack
					sub $sp $sp 16
					# print first x
					la $a0 x
					li $v0 4
					syscall
					# get first x
					li $v0 5
					syscall
					sw $v0 12($sp)
					# print first y
					la $a0 y
					li $v0 4
					syscall
					# get first y
					li $v0 5
					syscall
					sw $v0 8($sp)
					# print second x
					la $a0 x
					li $v0 4
					syscall
					# get second x
					li $v0 5
					syscall
					sw $v0 4($sp)
					# print second y
					la $a0 y
					li $v0 4
					syscall
					# get second y
					li $v0 5
					syscall
					sw $v0 ($sp)
					# restore the address
					move $a0 $t0
					# jump to sum
					jal compare
					lw $ra ($sp)
					addi $sp $sp 4
					# print result
					b main_double_result
					
	main_extract_int:		# save current $ra
					sub $sp $sp 4
					sw $ra ($sp)
					# print address
					la $a0 address
					li $v0 4
					syscall
					# get address
					li $v0 5
					syscall
					move $t0 $v0
					# print width
					la $a0 width
					li $v0 4
					syscall
					# get width
					li $v0 5
					syscall
					move $a2 $v0
					# print height
					la $a0 height
					li $v0 4
					syscall
					# get height
					li $v0 5
					syscall
					move $a1 $v0
					sub $sp $sp 12
					# print address
					la $a0 address
					li $v0 4
					syscall
					# get address
					li $v0 5
					syscall
					move $a3 $v0
					# setup stack
					sub $sp $sp 20
					# print size
					la $a0 size
					li $v0 4
					syscall
					# get size
					li $v0 5
					syscall
					sw $v0 16($sp)
					# print first x
					la $a0 x
					li $v0 4
					syscall
					# get first x
					li $v0 5
					syscall
					sw $v0 12($sp)
					# print first y
					la $a0 y
					li $v0 4
					syscall
					# get first y
					li $v0 5
					syscall
					sw $v0 8($sp)
					# print second x
					la $a0 x
					li $v0 4
					syscall
					# get second x
					li $v0 5
					syscall
					sw $v0 4($sp)
					# print second y
					la $a0 y
					li $v0 4
					syscall
					# get second y
					li $v0 5
					syscall
					sw $v0 ($sp)
					# restore the address
					move $a0 $t0
					# jump to sum
					jal extract
					lw $ra ($sp)
					addi $sp $sp 4
					# print result
					b main_single_result
					
	main_extract_float:		nop
					b main_return
	
	main_single_result:		# print result
					move $a0 $v0
					li $v0 1
					syscall
					# return to main
					b main_return
	
	main_double_result:		# print result
					move $a0 $v0
					li $v0 1
					syscall
					la $a0 newline
					li $v0 4
					syscall
					move $a0 $v1
					li $v0 1
					syscall
					#return to main
					b main_return
					
					
