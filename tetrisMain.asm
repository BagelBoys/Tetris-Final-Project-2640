#CS2640 Tetris Final Project

#RNG macro takes in 2 parameters (range and resultreg). The range parameter controls range of random numbers (ex: if range set to 20, possible numbers you can get are 0-20)
#The resultreg parameter is the register the random number will be stored in
.macro RNG(%range, %resultreg)
    li $v0, 41        # Syscall 41: Generate random int
    li $a0, 0         # Select random generator 0
    syscall           # Random number returned in $a0

    li $t0, %range    # Load range into $t0
    rem %resultreg, $a0, $t0  # result = $a0 % range
    bltz %resultreg, fix_neg  # Fix if result is negative
    j done_rng

fix_neg:
    add %resultreg, %resultreg, $t0 # Add range to fix negative number

done_rng:
.end_macro


.macro printStr(%str)
	li $v0, 4
	la $a0, %str
	syscall
.end_macro


.data
grid:       .space 200  #Grid to hold the Tetris game(10x20 grid)
instructions: .asciiz "Controls: 'a' = left, 'd' = right, 's' = drop\n"
invalidIns: .asciiz "\nThis is an invalid input! Try again."
prompt:     .asciiz "Enter your move: "
turnprompt: .asciiz "Turn: "
newline:    .asciiz "\n"
block:      .asciiz "#"
empty:      .asciiz "."
row_end:    .asciiz "\n"
userinput_buffer: .space 2
.text

main:
	#prints instructions
	li $v0, 4
	la $a0, instructions
	syscall
	
	#initializes empty grid
	la $t0, grid    
    	li $t1, 200
    	
    	#initializes grid counters
    	li $t2, 9 #row length-1
    	li $t3, 0 #row counter
    	li $t4, 19 #column length-1
    	li $t5, 0 #column counter
    	li $s7, 1 #turn counter
    	
	j grid_init_loop
	

    
game_loop:
	#sets counters back to 0 for next iteration
	li $t3, 0
	li $t5, 0
	#asks for user input
	j get_Instruction
	
	#ends program when end condition is met
	j endgame 
	
grid_init_loop:
	#calls to print empty char or newline
	ble $t3, $t2, grid_printempty 
	bge $t3, $t2, grid_newline
	
grid_printempty:
	#prints empty symbol and adds 1 to row counter
	printStr(empty)
	addi $t3, $t3, 1
	
	#jumps back to grid loop
	j grid_init_loop
	
grid_newline:
	#checks if grid has reached 20 rows
	bge $t5, $t4, game_loop
	
	#prints newline and adds to column length counter
	printStr(newline)
	addi $t5, $t5, 1
	#resets row length counter
	li $t3, 0
	#jumps back to loop init
	j grid_init_loop
	
get_Instruction: #get the user input
    	li $v0, 8
    	la $a0, userinput_buffer
    	li $a1, 2
    	syscall
    	lb $s0, 0($a0)
    	j validate_Instruction
    
validate_Instruction:  #make sure that the instruction is one character, and either 'a', 's', or 'd'
    	li $t6, 97 #ascii for 'a'
    	beq $s0, $t6, valid

    	li $t6, 115 #ascii for 's'
    	beq $s0, $t6, valid

    	li $t6, 100 #ascii for 'd'
    	beq $s0, $t6, valid

    	j invalid 

invalid: #anything other than a, s, d will be considered invalid 
    	li $v0, 4
    	la $a0, invalidIns
    	syscall
    	printStr(newline)
    	j get_Instruction


valid: 
    	#logic here for whenever there's a valid input
    	printStr(newline)
    	printStr(newline)
    	printStr(newline)
    	printStr(turnprompt)
    	
    	#prints current turn
    	li $v0, 1
    	la $a0, ($s7)
    	syscall
    	
    	addi $s7, $s7, 1 #increments turn
    	
    	printStr(newline)
    	
    	j grid_init_loop
	
endgame:
	#ends program
	li $v0, 10
	syscall
	

	
	



