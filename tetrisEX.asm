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
invalidmoveMsg: .asciiz "\n\nBlock is being obstructed and cannot move, going to next turn\n\n"

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
    j execute_move

execute_move:
    beqz $t9, perform_shift     # If move is valid, perform shift
    
    li $v0, 4
    la $a0, invalidmoveMsg	   # Prints invalid move message if flagged
    syscall
    
    li $t9, -1 	   # Sets $t9 back to -1 so new block is not generated
    
    add $s7, $s7, 1	   # Increments turn counter
    
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

#DROP
drop:
    jal hard_drop          # Call hard_drop to calculate and apply the drop
    j valid

hard_drop:
    la $t0, row1           # Start at the first row (row1)
    li $t1, 20             # Total number of rows in the grid
    li $t9, 0              # Initialize drop distance as 0 (no drop yet)

# Step 1: Calculate the drop distance for the block
calculate_drop_distance:
    li $t2, 0              # Row index (starting at 0)
    li $t3, 10             # Total number of columns (10 columns)
    li $t4, 0              # Column index (starting at 0)
    add $t5, $t0, $t4      # Pointer to the first cell in row1

check_cells:
    beq $t4, $t3, next_drop_row  # Move to next row if all columns checked
    lw $t6, 0($t5)         # Load cell value (0 if empty, 1 if occupied)
    beqz $t6, skip_cell    # Skip if cell is empty (0)

    # Step 2: Find how far this cell can move down
    li $t7, 1              # Start with 1 row as the initial drop distance
find_max_drop:
    mul $t8, $t7, 40       # Calculate the row offset (40 bytes per row)
    add $t8, $t0, $t8      # Add the row offset to the current row address
    add $t8, $t8, $t4      # Add the column offset (same column)
    li $t9, 1596           # Maximum valid address for the grid (bottom row of grid)
    blt $t8, $t9, valid_drop_address
    j valid                # Exit if out of bounds (drop beyond grid)

valid_drop_address:
    lw $s5, 0($t8)         # Load the cell value of the cell below

    bnez $s5, update_drop  # If the cell below is occupied (not empty), stop
    addi $t7, $t7, 1       # Increment drop distance by 1 row
    blt $t7, $t9, find_max_drop # Continue checking until the bottom of the grid

update_drop:
    move $t9, $t7          # Update maximum drop distance in $t9 (the drop distance)
    j skip_cell

skip_cell:
    addi $t5, $t5, 4       # Move to the next column in the row (4 bytes per column)
    addi $t4, $t4, 1
    j check_cells

next_drop_row:
    addi $t0, $t0, 40      # Move to next row (grid has 10 columns, 4 bytes per cell)
    addi $t2, $t2, 1
    blt $t2, $t1, calculate_drop_distance

# Step 3: Perform the actual hard drop by moving the block down by the calculated distance
perform_hard_drop:
    la $t0, row1           # Start at the first row
    li $t1, 0              # Row index
    li $t2, 10             # Number of columns (10)
    li $t3, 0              # Column index (starting at 0)
    add $t4, $t0, $t3      # Pointer to the current cell in the first row

hard_drop_cells:
    beq $t3, $t2, drop_next_row # Move to the next row if all columns are checked
    lw $t6, 0($t4)         # Load cell value (current block's value)
    beqz $t6, skip_hard_cell  # Skip if the cell is empty

    # Move the cell down by the drop distance (t9 rows)
    mul $t7, $t9, 40       # Calculate row offset for drop distance (40 bytes per row)
    add $t8, $t0, $t7      # Move pointer to the correct row (based on drop distance)
    add $t8, $t8, $t3      # Add column offset (same column as current cell)
    sw $t6, 0($t8)         # Move the block's cell to the new position (after drop)
    sw $zero, 0($t4)       # Clear the old position (set to 0)

skip_hard_cell:
    addi $t4, $t4, 4       # Move to the next column (4 bytes per column)
    addi $t3, $t3, 1
    j hard_drop_cells

drop_next_row:
    addi $t0, $t0, 40      # Move to the next row
    addi $t1, $t1, 1
    blt $t1, 20, perform_hard_drop  # Ensure we go through all rows in the grid

finalize_hard_drop:
    jr $ra                # Finalize block, clear rows, and spawn new block







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

