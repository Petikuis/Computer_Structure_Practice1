.data
	.align 2
		array: 	.space 800

.text
.globl main
	main:		la $a0 array
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
			sub $sp $sp 8
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
			
			li $a0 0
			li $a1 0
			jal cmp
			
			move $a0 $v0
			li $v0 1
			syscall 
			
			li $v0 10
			syscall