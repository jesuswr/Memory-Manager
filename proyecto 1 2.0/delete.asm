
.text

delete: 
	sw $s0, 0($sp) 
	sw $s1, 4($sp) 
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp) 
	sw $s5, 20($sp) 
	sw $s6, 24($sp) 
	sw $s7, 28($sp)
	sw $t0, 32($sp)
	sw $ra, 36($sp)
	
	addi $sp, $sp, -40
		
	move $s0, $a0
	move $s1, $a1
		
	lw $s2, 8($s0) 		# se carga SIZE
		
	bgt $s1, $s2, noSuchPosition

	lw $s3, 0($s0) 		# se carga FIRST == s
	addi $s4, $zero, 1 	# contador i = 1
	move $s5, $s3		# inicializo variable auxiliar temp
		
	whileDelete: 
		beq $s4, $s1, exitWhileDelete
		move $s5, $s3		# temp = s.prev
		addi $s4, $s4, 1 	# i = i + 1
		lw $s3, 4($s3) 		# s = s.next
		
		j whileDelete
		
	exitWhileDelete: 
		lw $s6, 4($s3)	# guardo el next del elemento a eliminar
		lw $a0, 0($s3) 	# guardo en $a0 la direccion a liberar
		jal free
		addi $s2, $s2, -1	# SIZE = SIZE - 1
		sw $s2, 8($s0)
		li $v0, 0 
				
	bne $s1, 1, deleteNormal 		
	
	beq $s1, 1, deleteFirst
	
	deleteNormal: 
		sw $s6, 4($s5) 		# guardo el next del elemento eliminado en el next de su anterior: temp.next = nNext
		j ver
		
	deleteFirst: 
		bne $s2, 0, updateFirst		# Si el tamano termina distinto de 0
		
		beq $s2, 0, single 			# Si se elimina el unico elemento
		
		updateFirst: 
			sw $s6, 0($s0) 		# FIRST = nNext
			j ver
		
		single: 
			addi $t0, $zero, -1
			sw $t0, 0($s0) 		# FIRST = -1
			sw $t0, 4($s0) 		# LAST = -1
			j exitDelete
	
	ver: 
	addi $s2, $s2, 1
	
	beq $s1, $s2, updateLast 		# Si la posicion correspondia al ultimo elemento
	bne $s1, $s2, exitDelete
	
	updateLast: 
		sw $s5, 4($s0) 		# LAST = temp
		j exitDelete
		
	noSuchPosition: 
		li $v0, -1
		j exitDelete
		
	exitDelete: 		
		lw $ra, 4($sp) 
		lw $t0, 8($sp)
		lw $s6, 12($sp) 
		lw $s5, 16($sp) 
		lw $s4, 20($sp) 
		lw $s3, 24($sp) 
		lw $s2, 28($sp) 
		lw $s1, 32($sp) 
		lw $s0, 36($sp) 
		

		addi $sp, $sp, 40
		
		jr $ra

		
## falta: 
### verificar lo del $ra cuando llamo a free
### verificar que funcione la asignacion a $a0, en deleting
### verificar que no haya que crear una etiqueta de salida		
		
.
		