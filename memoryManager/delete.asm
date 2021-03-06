
.text

delete: 
	## This function receives the address of a list and the position of a node to be deleted
	## It returns the address of the element contained in the deleted node 
	
	sw $s0, 0($sp) 
	sw $s1, -4($sp) 
	sw $s2, -8($sp)
	sw $s3, -12($sp)
	sw $s4, -16($sp) 
	sw $s5, -20($sp) 
	sw $s6, -24($sp) 
	sw $s7, -28($sp)
	sw $t0, -32($sp)
	sw $ra, -36($sp)
	
	addi $sp, $sp, -40
		
	move $s0, $a0
	lw $t0, 12($s0)
	bne $t0, -1, deleteException 			# Determining if the pointer addres does point a valid list
	
	move $s1, $a1
		
	lw $s2, 8($s0) 			
		
	bgt $s1, $s2, pasoInt			# Determining if the position to delete is a valid one
	
		pasoInt: 
			beq $s2, 0, deleteException2

	lw $s3, 0($s0) 		
	addi $s4, $zero, 1 	
	move $s5, $s3		
		
	whileDelete: 
		beq $s4, $s1, exitWhileDelete
		move $s5, $s3		
		addi $s4, $s4, 1 	
		lw $s3, 4($s3) 		
		
		j whileDelete
		
	exitWhileDelete: 
		lw $s6, 4($s3)	
		move $a0, $s3
		jal free
		addi $s2, $s2, -1	
		sw $s2, 8($s0)
		li $v0, 0 
				
	bne $s1, 1, deleteNormal 		
	
	beq $s1, 1, deleteFirst
	
	deleteNormal: 
		sw $s6, 4($s5)
		j ver
		
	deleteFirst: 
		bne $s2, 0, updateFirst		
		
		beq $s2, 0, single 			
		
		updateFirst: 			# This tag updates the "first" attribute if the deleted element was first on the list
			sw $s6, 0($s0) 		# FIRST = nNext
			j ver
		
		single: 					# This tag deals with lists that, after deletion, have no elements left
			addi $t0, $zero, -1
			sw $t0, 0($s0) 			# FIRST = -1
			sw $t0, 4($s0) 			# LAST = -1
			j exitDelete
	
	ver: 
	
	addi $s2, $s2, 1
	
	beq $s1, $s2, updateLast
	bne $s1, $s2, exitDelete
	
	updateLast: 			# This tag updates the "last" atribute if the deleted element was the last one on the list
		sw $s5, 4($s0) 		
		j exitDelete
		
	deleteException: 
		li $v0, -5			# The given address does not contain a list
		j exitDelete
		
	deleteException2: 
		li $v0, -6			# The position to delete is greater than size
		j exitDelete
		
	exitDelete: 		
		lw $ra, 4($sp) 
		lw $t0, 8($sp)
		lw $s7 12($sp)
		lw $s6, 16($sp) 
		lw $s5, 20($sp) 
		lw $s4, 24($sp) 
		lw $s3, 28($sp) 
		lw $s2, 32($sp) 
		lw $s1, 36($sp) 
		lw $s0, 40($sp) 
		

		addi $sp, $sp, 40
		
		jr $ra

		

		
		
