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

.macro arrayTraversePrint(%arr)
	#loads array, length, and counter
	la $s0, %arr
	la $t1, 10
	la $t2, 0
traverse_loop:
	# Check if loop counter has reached the array length
    	beq $t2, $t1, exitMacro                

    	# Load the current element
    	lw $t0, 0($s0)                     

    	bnez $t0, print_hash
    	# Print empty
    	li $v0, 4                          
    	la $a0, empty                      
    	syscall

    	# Move to the next element
    	addi $s0, $s0, 4                  
    	addi $t2, $t2, 1                   

    	bne $t1, $t2, traverse_loop
    	j exitMacro
    	     
print_hash:
	li $v0, 4
	la $a0, hash
	syscall
	
	addi $s0, $s0, 4                  
    	addi $t2, $t2, 1                   

	j traverse_loop
exitMacro:
	li $v0, 4
	la $a0, newline
	syscall                 
.end_macro	


.macro printStr(%str)
	li $v0, 4
	la $a0, %str
	syscall
.end_macro

.macro printGrid
	arrayTraversePrint(row1)
	arrayTraversePrint(row2)
	arrayTraversePrint(row3)
	arrayTraversePrint(row4)
	arrayTraversePrint(row5)
	arrayTraversePrint(row6)
	arrayTraversePrint(row7)
	arrayTraversePrint(row8)
	arrayTraversePrint(row9)
	arrayTraversePrint(row10)
	arrayTraversePrint(row11)
	arrayTraversePrint(row12)
	arrayTraversePrint(row13)
	arrayTraversePrint(row14)
	arrayTraversePrint(row15)
	arrayTraversePrint(row16)
	arrayTraversePrint(row17)
	arrayTraversePrint(row18)
	arrayTraversePrint(row19)
	arrayTraversePrint(row20)
.end_macro

.data
instructions: .asciiz "\nControls: 'a' = left, 'd' = right, 's' = drop\n\n"
invalidIns: .asciiz "\nThis is an invalid input! Try again."
moveprompt:     .asciiz "\nEnter your move ('a' = left, 'd' = right, 's' = drop, 'q' = quit): "
turnprompt: .asciiz "Turn: "
newline:    .asciiz "\n"
hash:      .asciiz "#"
empty:      .asciiz "."
row_end:    .asciiz "\n"
userinput_buffer: .space 2

#grid arrays (20 rows, 10 columns)
gridspace: .space 200
row1: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row2: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row3: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row4: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row5: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row6: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row7: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row8: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row9: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row10: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row11: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row12: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row13: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row14: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row15: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row16: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row17: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row18: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row19: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row20: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0




.text

main:
	#loads turn counter initial value of 1
	li $s7, 1
	
	#initiates boolean for currentBlockMoving ($t9)
	li $t9, 0 #start of game, no blocks are moving so false
	
	#prints rng number in reg $t7
	#li $v0, 1
	#la $a0, ($t7)
	#syscall
	
	#prints instructions
	li $v0, 4
	la $a0, instructions
	syscall

	    
game_loop:
	
	#block generation jump if no moving block
	bgezal, $t9, block_generate
	
	j print_current_iteration
	
move_prompt:
	
	#Move prompt
	li $v0, 4
	la $a0, moveprompt
	syscall
	
	#asks for user input
	j get_Instruction
	
	#ends program when end condition is met
	j exit
	
block_generate:
	#sets currentBlockMoving ($t9) to -1
	li $t9, -1
	
	#gets random number 
	RNG(6, $t7)
		
	beq $t7, 0, square_block	
	beq $t7, 1, line_block
	beq $t7, 2, l_block_left
	beq $t7, 3, l_block_right
	beq $t7, 4, s_block
	beq $t7, 5, z_block
	beq $t7, 6, t_block
	
##
##	
square_block:

	#loads in row1 array and sets index 3 and 4 to hashes
	la $s3, row1
	li $s4, 1
	sw $s4, 16($s3)
	sw $s4, 20($s3)
	
	#switches to row2 array and sets index 3 and 4 to hashes
	la $s3, row2
	sw $s4, 16($s3)
	sw $s4, 20($s3)
	
	jr $ra
  

####
line_block:
	#loads in row1 array and sets index 3 and 4 to hashes
	la $s3, row1
	li $s4, 1
	sw $s4, 12($s3)
	sw $s4, 16($s3)
	sw $s4, 20($s3)
	sw $s4, 24($s3)
	
	jr $ra
  #
###
l_block_left:
	la $s3, row1


	li $s4, 1
	sw $s4, 20($s3)
	
	la $s3, row2
	sw $s4, 12($s3)
	sw $s4, 16($s3)
	sw $s4, 20($s3)
	
	jr $ra                                                                
#
###
l_block_right:
	la $s3, row1
	li $s4, 1
	sw $s4, 12($s3)
	
	la $s3, row2
	sw $s4, 12($s3)
	sw $s4, 16($s3)
	sw $s4, 20($s3)
	
	jr $ra


 ##
##
s_block:
	la $s3, row1
	li $s4, 1
	sw $s4, 16($s3)	
	sw $s4, 20($s3)
	
	la $s3, row2
	sw $s4, 12($s3)
	sw $s4, 16($s3)
	
	jr $ra
##
 ##
z_block:
	la $s3, row1
	li $s4, 1
	sw $s4, 12($s3)	
	sw $s4, 16($s3)
	
	la $s3, row2
	sw $s4, 16($s3)
	sw $s4, 20($s3)
	
	jr $ra	
	
 #
###
t_block:
	la $s3, row1
	li $s4, 1	
	sw $s4, 16($s3)
	
	la $s3, row2
	sw $s4, 12($s3)
	sw $s4, 16($s3)
	sw $s4, 20($s3)
	
	jr $ra	
	
print_current_iteration:
	printStr(turnprompt)
	
	#prints current turn
    	li $v0, 1
    	la $a0, ($s7)
    	syscall
    	
    	printStr(newline)

	#using arrayTraverse method prints out each row based on arrays in data
	printGrid
	#jumps back to grid loop
	j move_prompt
	
	
get_Instruction: #get the user input
    	li $v0, 8
    	la $a0, userinput_buffer
    	li $a1, 2
    	syscall
    	lb $s0, 0($a0)
    	j validate_Instruction
    
validate_Instruction:  #make sure that the instruction is one character, and either 'a', 's', or 'd'
    	li $t6, 97 #ascii for 'a'
    	beq $s0, $t6, move_left

    	li $t6, 115 #ascii for 's'
    	beq $s0, $t6, drop

    	li $t6, 100 #ascii for 'd'
    	beq $s0, $t6, valid
    	
    	li $t6, 113	#asciii for 'q'
    	beq $s0, $t6, exit

    	j invalid 
    	
move_left:
	jal move_block_left
	j valid
	 	
move_block_left:
    la $t0, row1       # Start at the first row
    li $t1, 20         # Number of rows
    li $t2, 0          # Row index
    li $t9, 0          # Flag: 0 = move allowed, 1 = invalid move

check_rows:
    beq $t2, $t1, execute_move  # Finished checking all rows

    # Traverse row to find leftmost active cell
    li $t3, 10         # Number of columns
    li $t4, 0          # Column index
    add $t5, $t0, $t4  # Pointer to current cell

find_leftmost:
    beq $t4, $t3, next_row  # Move to next row if end of columns reached
    lw $t6, 0($t5)          # Load cell value
    beqz $t6, next_cell     # Skip if cell is empty

    # Check if cell can move left
    blt $t4, 1, set_invalid_move  # Out of bounds (column 0)
    sub $t7, $t4, 1              # Calculate left neighbor index
    mul $t7, $t7, 4
    add $t8, $t0, $t7            # Pointer to left neighbor cell
    lw $t9, 0($t8)               # Load neighbor value
    bnez $t9, set_invalid_move   # Cannot move if neighbor is occupied

    j next_row                   # No need to check further

next_cell:
    addi $t5, $t5, 4            # Move to next column
    addi $t4, $t4, 1
    j find_leftmost

next_row:
    addi $t0, $t0, 40           # Move to next row (10 cols * 4 bytes each)
    addi $t2, $t2, 1
    j check_rows

set_invalid_move:
    li $t9, 1                   # Flag as invalid move
    j check_rows

execute_move:
    beqz $t9, perform_shift     # If move is valid, perform shift
    j game_loop                 # Otherwise, return to game loop

perform_shift:
    # Loop through rows again to perform the shift
    la $t0, row1       # Reset to the first row
    li $t2, 0          # Row index

shift_rows:
    beq $t2, $t1, end_move_block_left  # All rows processed

    # Traverse row to shift active cells left
    li $t3, 10         # Number of columns
    li $t4, 0          # Column index
    add $t5, $t0, $t4  # Pointer to current cell

shift_cells:
    beq $t4, $t3, shift_next_row  # Move to next row if end of columns reached
    lw $t6, 0($t5)                # Load cell value
    beqz $t6, skip_shift          # Skip if cell is empty

    # Perform the shift
    sub $t7, $t4, 1               # Calculate new column index
    mul $t7, $t7, 4
    add $t8, $t0, $t7             # Pointer to new cell
    sw $t6, 0($t8)                # Move block to new position
    sw $zero, 0($t5)              # Clear the old position

skip_shift:
    addi $t5, $t5, 4             # Move to next column
    addi $t4, $t4, 1
    j shift_cells

shift_next_row:
    addi $t0, $t0, 40            # Move to next row
    addi $t2, $t2, 1
    j shift_rows

end_move_block_left:
    jr $ra

drop:
    jal hard_drop          # Call hard_drop to calculate and apply the drop
    j valid                # After drop, continue execution with the "valid" label

hard_drop:
    la $t0, row1           # Load base address of the grid (starting at row1)
    li $t1, 20             # Total number of rows (20)
    li $t2, 0              # Row index (starting at 0)

# Step 1: Calculate the maximum drop distance for the block
calculate_drop_distance:
    li $t3, 0              # Column index (starting at 0)
    li $t4, 10             # Total number of columns (10)
    li $t5, 0              # Drop distance (in rows, initialized to 0)

check_column:
    beq $t3, $t4, next_column  # If we've checked all columns, move to next step
    add $t6, $t0, $t3      # Calculate address of the current cell (row1 + column offset)
    lw $t7, 0($t6)         # Load value of the current cell (1 if occupied, 0 if empty)
    beqz $t7, skip_column  # Skip if the cell is empty (0)

    # Step 2: Calculate how far the block can drop in the current column
    li $t8, 1              # Start checking the next row (start with 1 row)
find_max_drop:
    add $t9, $t0, $t8      # Calculate address of the row below
    mul $t9, $t9, 40       # 40 bytes per row (10 columns * 4 bytes)
    add $t9, $t9, $t3      # Add the column offset (same column as current cell)
    lw $s5, 0($t9)         # Load the value of the cell below

    bnez $s5, stop_drop    # If the cell below is occupied, stop
    addi $t8, $t8, 1       # Otherwise, increment drop distance by 1 row
    blt $t8, 20, find_max_drop  # Continue searching if we're within bounds

stop_drop:
    move $t5, $t8          # Store the maximum drop distance for this column
skip_column:
    addi $t3, $t3, 1       # Move to the next column
    j check_column

next_column:
    # Step 3: Perform the actual drop for each column
    li $t3, 0              # Reset column index to 0
    li $t4, 10             # Reset total columns to 10

perform_drop:
    beq $t3, $t4, done_drop # If all columns have been processed, finish
    add $t6, $t0, $t3      # Calculate address of the current cell
    lw $t7, 0($t6)         # Load the value of the current cell
    beqz $t7, skip_cell    # If the cell is empty, skip

    # Move the block down to the calculated distance
    mul $t8, $t5, 40       # Calculate the byte offset for the drop distance
    add $t9, $t0, $t8      # Add the byte offset to the base address
    add $t9, $t9, $t3      # Add the column offset

    sw $t7, 0($t9)         # Store the block in the new position
    sw $zero, 0($t6)       # Clear the old position (set to 0)

skip_cell:
    addi $t3, $t3, 1       # Move to the next column
    j perform_drop

done_drop:
    jr $ra                 # Return to the calling function








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
    	
    	addi $s7, $s7, 1 #increments turn
    	
    	printStr(newline)
    	
    	j print_current_iteration
	
exit:
	#ends program
	li $v0, 10
	syscall
