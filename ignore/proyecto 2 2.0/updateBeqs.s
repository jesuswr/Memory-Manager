
updateBeqs: 
	
	sw $s0, ($sp)
	sw $s1, -4($sp)
	sw $s2, -8($sp)
	sw $s3, -12($sp)
	sw $s4, -16($sp) 
	sw $s5, -20($sp)
	sw $s6, -24($sp)
	sw $s7, -28($sp)
	sw $t0, -32($sp)
	sw $t1, -36($sp)
	sw $t2, -40($sp)
	sw $t3, -44($sp)
	sw $t4, -48($sp)
	
	addi $sp, $sp, -52
	
	addi $s0, $a0, 0 			## Esto es una direccion de memoria
	addi $s1, $a1, 0 
	
	addi $t4, $zero, 0
	
	whileToCorrect: 
		lw $t1, ($s0)							# Cargo la instruccion a revisar ## Esto es una instruccion
		beq $t1, 0x0000040d, exitWhileToCorrect
		
		srl $s3, $t1, 26
		andi $s3, $s3, 63
		
		bne $s3, 4, skipCorrection			# Si no es un beq, lo ignoro
		# hay que determinar si el offset es positivo o negativo
		andi $s4, $t1, 65535 				# Considero el offset
		
		andi $t3, $s4, 61440			# Aqui cargo el signo del offset a $t3
		bne $t3, 61440, skipCorrection		# Si no es negativo, no hay que cambiar nada.
		beq $t3, 0, skipCorrection

		# Si es negativo 
		#
		addi $t2, $zero, 65535
		sub $s4, $t2, $s4				# Como el offset es un negativo, lo resto de su tope para saber cuanto es
		addi $s4, $s4, 2
		mul $s4, $s4, 4					# Lo multiplico * 4 para considerar palabras			
		#
		lw $s5, ($s1)						# Cargo movesArray[i]
		add $s5, $s5, $t4
		addi $t3, $s5, 0
		lw $s5 ($s5)						#### ESTO SE CAMBIO
		
		sub $s6, $t3, $s4					# Hallo la direccion referida por el offset
		lw $s6, ($s6) 						# Cargo su valor respectivo en movesArray
		sub $s7, $s5, $s6					# Considero la diferencia entre las entradas de movesArray
		
		beq $s5, $s6, skipCorrection 		# Si son iguales, no hay adds de por medio, asi que ignoro
		
		div $s7, $s7, 4						# Debo dividir pues las entradas de movesArray estan *4 y beq no las cuenta como c|4
		sub $t0, $t1, $s7					# Sumo a la instruccion el offset hallado
		sw $t0, ($s0)						# Almaceno la instruccion de vuelta a su direccion de memoria
		
		skipCorrection: 
		
		addi $s0, $s0, 4
		addi $t4, $t4, 4
		#addi $s1, $s1, 4
		
		j whileToCorrect
		
	exitWhileToCorrect: 
	lw $t4, 4($sp)
	lw $t3, 8($sp)
	lw $t2, 12($sp)	
	lw $t1, 16($sp)
	lw $t0, 20($sp)
	lw $s7, 24($sp)
	lw $s6, 28($sp)
	lw $s5, 32($sp)
	lw $s4, 36($sp)
	lw $s3, 40($sp)
	lw $s2, 44($sp)
	lw $s1, 48($sp)
	lw $s0, 52($sp)
	
	addi $sp, $sp, 52
	
	jr $ra