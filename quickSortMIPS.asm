#Fazer um programa que pegue um arquivo .csv,
#leia seu conteudo e crie um quick sort para ordenar o array

#PASSOS E FUNÇÔES QUE O PROFESSOR SUGERIU
#ABRIR O ARQUIVO fopen(...
#LER O ARQUIVO COMNVERTENDO CHAR PARA INT atoi(...
#ORDENAR O ARRAY DE INT LIDO DO ARQUIVO quicksort(...

######################## QUICK SORT EM C ###########################
#                                                                  #
#	void quick(int *arr, int left, int right) {                #
#		int l = left, r = right, p = left;                 #
#		                                                   #
#		while (l < r) {                                    #
#			while (arr[l] <= arr[p] && l < right)      #
#				l++;                               #
#			while (arr[r] >= arr[p] && r > left)       #
#				r--;                               #
#			if (l >= r) {                              #
#				SWAP(arr[p], arr[r]);              #
#				quick(arr, left, r - 1);           #
#				quick(arr, r + 1, right);          #
#				return;                            #
#			}                                          #
#			SWAP(arr[l], arr[r]);                      #
#		}                                                  #
#	}                                                          #
#                                                                  #
####################################################################	 

.data
	#Array para fazer a conversão
	ascii: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9
	#nome do arquivo
	file_name : .asciiz "numeros.csv"
	#espaço alocado
	file_buffer : .space 58893
	
	.align 2
	array : .space 40000 #espaço pro array ordenado
	intro_msg_ordenacao:	.asciiz "Array ordenado : "
	espaco:	.asciiz " "
	QUEBRA_LINHA:	.asciiz "\n"
	 
.text


	# ABRINDO O ARQUIVO

	la $a0, file_name   # carregando o endereco do nome do arquivo em $a0
	li $a1, 0
	li $a2  0
	li $v0, 13
	syscall             # abrindo o arquivo
	
	# LENDO O ARQUIVO

	add $a0, $v0, $zero   # carregando o endereco do nome do arquivo em $a0
	la $a1, file_buffer
	li $a2, 58893
	li $v0, 14
	syscall             # lendo o arquivo


	addi $t0, $t0, 0   		# valor = 0
	li $t2, 0			# n = 0
	la $s3, array 			# array
	la $s2, ($a1)                   # file
	lb $s1, 0($s2)                  # file[i]
	
WHILE:	beq $s1, 0, SAI		       # while (file[i] !=  '\0' )
	
	beq $s1, 44     ARMAZENA_VALOR        # if(file[i] == ','){    
	beq $s1, 32     IGNORA_CHAR           # if(file[i] == ' '){
	J 		COMPOE_VALOR	      # else{

	ARMAZENA_VALOR : 
		sw $t0, ($s3)		     # vet[n] = valor
		addi $t2, $t2, 1             # n++
		addi $s3, $s3, 4
		li $t0, 0	     	     # valor = 0
		J FIN
	IGNORA_CHAR : 
		J FIN
	COMPOE_VALOR :
		
		li $t3, 10         # 10
		lb $t4, 0($s2)     # file[i]
		addi $a0, $t4, 0   # charToInt(file[i])
		jal CHAR_PARA_INT
		mult  $t0, $t3 	   																																																				
		mflo  $t0          # valor = valor * 10
		add $t0, $t0, $v0  # valor = valor * 10 + charToInt(file[i]);
		J FIN

FIN :
	addi $s2, $s2, 1
	lb $s1, 0($s2)                  # file[i++]
	j WHILE
	
SAI:
	
	sw $t0, ($s3)		     # vet[n] = valor
	addi $t2, $t2, 1
	addi $s7, $t2, 0
	
	
	
	    	#         ----->Registradores utilizados<-----		  
		#               $s3 = int* vet	   
		#               $s7 = vet.length  	



# inicializar a quantidade de numeros  vet.length	
	add		$t2, $s7, $zero  # t2 = vet.length
	

# chama o quicksort
	la		$a0, array
	li		$a1, 0
	# a2 = vet.length - 1
	add	$t0, $s7, $zero
	addi	$t0, $t0, -1
	add	$a2, $t0, $zero
	# chama a funcao quisort
	jal		quicksort
	
# imprime "Resultado apos ordenacao : "
	li		$v0, 4
	la		$a0, intro_msg_ordenacao
	syscall
# imprime array ordenado
	jal		IMPRESSAO_ARRAY

# fim do programa
	li		$v0, 10
	syscall
	
IMPRESSAO_ARRAY:
## imprime array ordenado
	la		$s0, array # s0 = array*
	add		$t0, $zero, $s7
loop_iteracao_vetor:
	beq		$t0, $zero, loop_iteracao_vetor_fim  # while(to != 0)
	li		$v0, 4
	la		$a0, espaco
	syscall
	# imprimindo os elementos do array ordenado
	li		$v0, 1
	lw		$a0, 0($s0) # a0 = vet[i]
	syscall
	
	addi	$t0, $t0, -1   # t0--
	addi	$s0, $s0, 4    # i++
	
	j		loop_iteracao_vetor
	
loop_iteracao_vetor_fim:
	# Da o quebra linha
	li		$v0, 4
	la		$a0, QUEBRA_LINHA
	syscall
	jr		$ra

quicksort:
# QUICK SORT

	# HOUSEKEEPING INICIO
	addi	$sp, $sp, -24	
	sw		$s0, 0($sp)		
	sw		$s1, 4($sp)		
	sw		$s2, 8($sp)		
	sw		$a1, 12($sp)	
	sw		$a2, 16($sp)	
	sw		$ra, 20($sp)	
	# HOUSEKEEPING FIM

	add	$s0, $a1, $zero		# s0 = esquerdo
	add	$s1, $a2, $zero		# s1 = direito
	add	$s2, $a1, $zero		# s2 = pivot = esquerdo

# while (esquerdo < direito)
loop_principal:
	bge		$s0, $s1, saida_loop_1
	
# while (esquerdo < direito && array[esquerdo] <= array[pivot])
loop_principal_1:
	li		$t7, 4			# t7 = 4
	# t0 = &array[esquerdo]
	mult	$s0, $t7
	mflo	$t0				# t0 =  esquerdo * 4
	add		$t0, $t0, $a0		# t0 = &array[esquerdo]
	lw		$t0, 0($t0)
	# t1 = &array[pivot]
	mult	$s2, $t7
	mflo	$t1				# t1 =  pivot * 4
	add		$t1, $t1, $a0		# t1 = &array[pivot]
	lw		$t1, 0($t1)
	# verifica que array[esquerdo] <= array[pivot]
	bgt		$t0, $t1, loop_principal_1_fim
	# verifica que esquerdo < direito
	bge		$s0, $a2, loop_principal_1_fim
	# l++
	addi	$s0, $s0, 1
	j		loop_principal_1
	
loop_principal_1_fim:

# while (direito > esquerdo && array[direito] >= array[pivot])
loop_principal_2:
	li		$t7, 4			# t7 = 4
	# t0 = &array[direito]
	mult	$s1, $t7
	mflo	$t0				# t0 =  direito * 4
	add		$t0, $t0, $a0		# t0 = &array[direito]
	lw		$t0, 0($t0)
	# t1 = &array[pivot]
	mult	$s2, $t7
	mflo	$t1				# t1 =  pivot * 4
	add		$t1, $t1, $a0		# t1 = &array[pivot]
	lw		$t1, 0($t1)
	# verifica que array[direito] >= array[pivot]
	blt		$t0, $t1, loop_principal_2_fim
	# verifica que direito > esquerdo
	ble		$s1, $a1, loop_principal_2_fim
	# r--
	addi	$s1, $s1, -1
	j		loop_principal_2
	
loop_principal_2_fim:

# if (esquerdo >= direito)
	blt		$s0, $s1, esquerdo_menor_que_direito
# troca (array[pivot], array[direito])
	li		$t7, 4			# t7 = 4
	# t0 = &array[pivot]
	mult	$s2, $t7
	mflo	$t6				# t6 =  pivot * 4
	add		$t0, $t6, $a0		# t0 = &array[pivot]
	# t1 = &array[direito]
	mult	$s1, $t7
	mflo	$t6				# t6 =  direito * 4
	add		$t1, $t6, $a0		# t1 = &array[direito]
	# Swap
	lw		$t2, 0($t0)
	lw		$t3, 0($t1)
	sw		$t3, 0($t0)
	sw		$t2, 0($t1)
	

	# set arguments
	move	$a2, $s1
	addi	$a2, $a2, -1	# a2 = direito-1
	jal		quicksort
	
	
	lw		$a1, 12($sp)	
	lw		$a2, 16($sp)	
	lw		$ra, 20($sp)	
	move	$a1, $s1
	addi	$a1, $a1, 1		# a1++
	jal		quicksort
	
	#retorno do estado original dos regs pre funcao
	lw		$a1, 12($sp)	
	lw		$a2, 16($sp)	
	lw		$ra, 20($sp)	
	lw		$s0, 0($sp)		
	lw		$s1, 4($sp)		
	lw		$s2, 8($sp)		
	addi	$sp, $sp, 24	
	#retorna da funcao
	jr		$ra

esquerdo_menor_que_direito:

# troca (array[esquerdo], array[direito])
	li		$t7, 4			# t7 = 4
	# t0 = &array[esquerdo]
	mult	$s0, $t7
	mflo	$t6				# t6 =  esquerdo * 4
	add		$t0, $t6, $a0		# t0 = &array[esquerdo]
	# t1 = &array[direito]
	mult	$s1, $t7
	mflo	$t6				# t6 =  direito * 4
	add		$t1, $t6, $a0		# t1 = &array[direito]
	# Swap
	lw		$t2, 0($t0)
	lw		$t3, 0($t1)
	sw		$t3, 0($t0)
	sw		$t2, 0($t1)
	
	j		loop_principal
	
saida_loop_1:
	
	#retorno do estado original dos registradores da pre função
	lw		$s0, 0($sp)		
	lw		$s1, 4($sp)		
	lw		$s2, 8($sp)		
	addi	$sp, $sp, 24
	#retorna da função	
	jr		$ra
	
	
	
	
# $a0 -> char representando um inteiro a ser transformado em inteiro
# $v0 -> valor em decimal resultante da transformacao do char em int

CHAR_PARA_INT:	#housekeeping (pre-execucao da funcao)
		#salvar na pilha os valores de todos os registradores "s" "a" e "ra" utilizados na função
		sw		$ra,    0($sp)
		sw		$a0,   -4($sp)
		sw		$a1,   -8($sp)
		sw		$a2,  -12($sp)
		sw		$a3,  -16($sp)
		sw		$s0,  -20($sp)
		sw		$s1,  -24($sp)
		sw		$s2,  -28($sp)
		sw		$s3,  -32($sp)
		sw		$s4,  -36($sp)
		sw		$s5,  -40($sp)
		sw		$s6,  -44($sp)
		sw		$s7,  -48($sp)
		addi	$sp, $sp, -52
		#fim do housekeeping		
	  
		la $t5, ascii
		add  $t6, $zero, $a0   # valor em bytes
		sll  $t6, $t6, 2    
		add  $t5, $t5, $t6
		lw $v0, ($t5)

		#retorno do estado original dos registradores da pre função
		lw		$s7, 4($sp)
		lw		$s6, 8($sp)
		lw		$s5, 12($sp)
		lw		$s4, 16($sp)
		lw		$s3, 20($sp)
		lw		$s2, 24($sp)
		lw		$s1, 28($sp)
		lw		$s0, 32($sp)
		lw		$a3, 36($sp)
		lw		$a2, 40($sp)
		lw		$a1, 44($sp)
		lw		$a0, 48($sp)
		lw		$ra, 52($sp)
		addi	$sp, $sp, 52
				
		#retorna da função
		jr	$ra
