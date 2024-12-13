#CS2640 Tetris Final Project

#Group member names: Patrick Hwang, Daniel Ozaraga, Angel Ramos, Kristopher Walsh, Bryan Mayorga


.macro RNG(%range, %resultreg)
	li $v0, 41			#Syscall 41: Generate random int
	li $a0, 0			#Select random generator 0
	syscall			#Random number returned in $a0

	li $t0, %range		#Load range into $t0
	rem %resultreg, $a0, $t0	#result = $a0 % range
	bltz %resultreg, fix_neg	#Fix if result is negative
	j done_rng

fix_neg:
	add %resultreg, %resultreg, $t0 #Add range to fix negative number

done_rng:
.end_macro

.macro gameTitle


.data
gameTitle1:	.asciiz ".,_______, ,______, ,_______, ,______, ,_______,.,_______,.\n"
gameTitle2:	.asciiz ".|__, ,__|.| ,____|.|__, ,__|.| ,_,  |.|__, ,__|.|_ ,__  |.\n"
gameTitle3:	.asciiz "....| |....| |____,....| |....| |_|  |....| |......\\ \\ \\_|.\n"
gameTitle4:	.asciiz "....| |....| |____|....| |....| ,_  /.....| |....._.\\ \\....\n"
gameTitle5:	.asciiz "....| |....| |____,....| |....| |.\\ \\..,__| |__,.| \\_\\ \\_,.\n"
gameTitle6:	.asciiz "....|_|....|______|....|_|....|_|..\\_\\.|_______|.|_______|.\n"


.text
main:
	li $v0, 4
	la $a0, gameTitle1
	syscall
	
	li $v0, 4
	la $a0, gameTitle2
	syscall
	
	li $v0, 4
	la $a0, gameTitle3
	syscall
	
	li $v0, 4
	la $a0, gameTitle4
	syscall
	
	li $v0, 4
	la $a0, gameTitle5
	syscall
	
	li $v0, 4
	la $a0, gameTitle6
	syscall
.end_macro

.macro arrayTraversePrint(%arr)
	#loads array, length, and counter
	la $s0, %arr
	la $t1, 10
	la $t2, 0
traverse_loop:
	#Check if loop counter has reached the array length
	beq $t2, $t1, exitMacro                

	#Load the current element
	lw $t0, 0($s0)                     

	beq $t0, 1, print_hash
	beq $t0, 2, print_X
	#Print empty
	li $v0, 4                          
	la $a0, empty                      
	syscall
	
	
	#Move to the next element
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
	
print_X:
	li $v0, 4
	la $a0, X
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
invalidIns: .asciiz "\nThis is an invalid input! Try again.\n"
moveprompt:     .asciiz "\nEnter your move ('a' = left, 'd' = right, 's' = drop, 'r' = rotate 'q' = quit to menu): "
turnprompt: .asciiz "\nMoves: "
newline:    .asciiz "\n"
hash:      .asciiz "#"
X:    .asciiz "X"
empty:      .asciiz "."
row_end:    .asciiz "\n"
userinput_buffer: .space 2
playPrompt: .asciiz "Enter 'p' to play\n"
exitPrompt: .asciiz "Enter 'e' to exit\n"
userInputPrompt: .asciiz "Please enter your choice: "
invalidmoveMsg: .asciiz "\n\nBlock is being obstructed and cannot move, going to next turn\n\n"
game_over:   .asciiz "\n\n---------------GAME OVER---------------"

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
	gameTitle
	
		
    	li $v0, 4
    	la $a0, playPrompt
    	syscall
  
    	li $v0, 4
    	la $a0, exitPrompt
    	syscall

    	li $v0, 4
    	la $a0, userInputPrompt
    	syscall

    	li $v0, 12            # syscall for reading a character
    	syscall
    	move $t0, $v0         # Store the character input in $t0

    	li $t1, 112            # ASCII value for p
    	beq $t0, $t1, game_loop

    	li $t1, 101            # ASCII value for e
    	beq $t0, $t1, exit

   	# Invalid input handling
   	li $v0, 4
    	la $a0, invalidIns
    	syscall

    	# Jump back to get input again
    	j main
	
	#loads turn counter initial value of 1
	li $s7, 0
	
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
	li $t2, 0
	
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
	
	beqz, $t2, end_game_init1
	#sets currentBlockMoving ($t9) to -1
	li $t9, -1
	
	#gets random number 
	RNG(7, $t7)
		
	beq $t7, 0, square_block	
	beq $t7, 1, line_block
	beq $t7, 2, l_block_left
	beq $t7, 3, l_block_right
	beq $t7, 4, s_block
	beq $t7, 5, z_block
	beq $t7, 6, t_block
end_game_init1:
	li $t2, 1
	la $s0, row1 
	la $t3, 2   #row length (only checking first two rows)
	la $t4, 0   #row counter
	
end_game_init2:
	la $t5, 10  #column length
	la $t6, 0   #column counter
end_game_loop:
	beq $t4, 2, block_generate 
	#Load the current element
	lw $t0, 0($s0)                     
	
	#If current cell is 2 end the game
	beq $t0, 2, exit
	#Move to the next element
	add $s0, $s0, 4                  
	add $t6, $t6, 1                   
	bge $t4, $t3, end_game_init2
	bge $t6, $t5, end_next_row
	j end_game_loop

end_next_row:
	add $s0, $s0, 40 #moves to next row
	add $t4, $t4, 1  #increments row counter
	j end_game_loop 
	
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
	
	#prints current move
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
	beq $s0, $t6, move_right
    	
	li $t6, 113	#asciii for 'q'
	beq $s0, $t6, exit

	j invalid 



move_left:
	jal move_block_left
	j valid

	 	
move_block_left:
	la $t0, row1       #Start at the first row
	li $t1, 2         #Number of rows
	li $t2, 0          #Row index
	li $t9, 0          #Flag: 0 = move allowed, 1 = invalid move

check_rows:
	beq $t2, $t1, execute_move  #Finished checking all rows

	#Traverse row to find leftmost active cell
 	li $t3, 10         #Number of columns
	li $t4, 0          #Column index
	add $t5, $t0, $t4  #Pointer to current cell

find_leftmost:
	beq $t4, $t3, next_row  #Move to next row if end of columns reached
	lw $t6, 0($t5)          #Load cell value
	beqz $t6, next_cell     #Skip if cell is empty

	# Check if cell can move left
	blt $t4, 1, set_invalid_move	#Out of bounds (column 0)
	sub $t7, $t4, 1			#Calculate left neighbor index
	mul $t7, $t7, 4
	add $t8, $t0, $t7		#Pointer to left neighbor cell
	lw $t9, 0($t8)			#Load neighbor value
	bnez $t9, set_invalid_move	#Cannot move if neighbor is occupied

	j next_row                    #No need to check further

next_cell:
	addi $t5, $t5, 4	#Move to next column
	addi $t4, $t4, 1
	j find_leftmost

next_row:
	addi $t0, $t0, 40	#Move to next row (10 cols * 4 bytes each)
	addi $t2, $t2, 1
	j check_rows

set_invalid_move:
	li $t9, 1	#Flag as invalid move
	j execute_move

execute_move:
	beqz $t9, perform_shift    #If move is valid, perform shift
    
	li $v0, 4
	la $a0, invalidmoveMsg	   #Prints invalid move message if flagged
	syscall
    
	li $t9, -1 	   #Sets $t9 back to -1 so new block is not generated
    
	add $s7, $s7, 1	   #Increments turn counter

	j game_loop        #Otherwise, return to game loop

perform_shift:
	#Loop through rows again to perform the shift
	la $t0, row1       #Reset to the first row
	li $t2, 0          #Row index

shift_rows:
	beq $t2, $t1, end_move_block_left  #All rows processed

	#Traverse row to shift active cells left
	li $t3, 10         #Number of columns
	li $t4, 0          #Column index
	add $t5, $t0, $t4  #Pointer to current cell

shift_cells:
	beq $t4, $t3, shift_next_row  #Move to next row if end of columns reached
	lw $t6, 0($t5)                #Load cell value
	beqz $t6, skip_shift          #Skip if cell is empty

	#Perform the shift
	sub $t7, $t4, 1               #Calculate new column index
	mul $t7, $t7, 4
	add $t8, $t0, $t7             #Pointer to new cell
	sw $t6, 0($t8)                #Move block to new position
	sw $zero, 0($t5)              #Clear the old position

skip_shift:
	addi $t5, $t5, 4             #Move to next column
	addi $t4, $t4, 1
	j shift_cells

shift_next_row:
	addi $t0, $t0, 40            #Move to next row
	addi $t2, $t2, 1
	j shift_rows

end_move_block_left:
	jr $ra
    
    
#MOVE RIGHT BEGINS    
move_right:
	jal move_block_right
	j valid

move_block_right:
	la $t0, row1       #Start at the first row
	li $t1, 2          #Number of rows
	li $t2, 0          #Row index
	li $t9, 0          #Flag: 0 = move allowed, 1 = invalid move

check_rows_right:
	beq $t2, $t1, execute_move_right  #Finished checking all rows

	# Traverse row to find rightmost active cell
	li $t3, 10         #Number of columns
	li $t4, 9          #Start from the rightmost column
	mul $t5, $t4, 4    #Calculate offset for rightmost column
	add $t5, $t0, $t5  #Pointer to current cell

find_rightmost:
	bltz $t4, next_row_right  #Move to next row if out of bounds
	lw $t6, 0($t5)            #Load cell value
	beqz $t6, next_cell_right #Skip if cell is empty

	#Check if cell can move right
	bge $t4, 9, set_invalid_move_right  #Out of bounds (column 9)
	add $t7, $t4, 1                     #Calculate right neighbor index
	mul $t7, $t7, 4
	add $t8, $t0, $t7                   #Pointer to right neighbor cell
	lw $t9, 0($t8)                      #Load neighbor value
	bnez $t9, set_invalid_move_right    #Cannot move if neighbor is occupied

	j next_row_right                    #No need to check further

next_cell_right:
	sub $t5, $t5, 4             #Move to previous column (rightward traversal)
	sub $t4, $t4, 1
	j find_rightmost

next_row_right:
	addi $t0, $t0, 40           #Move to next row (10 cols * 4 bytes each)
	addi $t2, $t2, 1
	j check_rows_right

set_invalid_move_right:
	li $t9, 1                   #Flag as invalid move
	j execute_move_right

execute_move_right:
	beqz $t9, perform_shift_right     #If move is valid, perform shift
    
	li $v0, 4
	la $a0, invalidmoveMsg	   #Prints invalid move message if flagged
 	syscall
    
	li $t9, -1 	   #Sets $t9 back to -1 so new block is not generated
    
	add $s7, $s7, 1	   #Increments turn counter
    
	j game_loop                 #Otherwise, return to game loop

perform_shift_right:
	#Loop through rows again to perform the shift
	la $t0, row1       #Reset to the first row
	li $t2, 0          #Row index
	
shift_rows_right:
	beq $t2, $t1, end_move_block_right  #All rows processed

	#Traverse row to shift active cells right
	li $t3, 10         #Number of columns
	li $t4, 9          #Start from the rightmost column
	mul $t5, $t4, 4    #Offset for rightmost column
	add $t5, $t0, $t5  #Pointer to current cell

shift_cells_right:
	bltz $t4, shift_next_row_right  #Move to next row if out of bounds
	lw $t6, 0($t5)                  #Load cell value
	beqz $t6, skip_shift_right      #Skip if cell is empty

	#Perform the shift
	add $t7, $t4, 1                 #Calculate new column index
	mul $t7, $t7, 4
	add $t8, $t0, $t7               #Pointer to new cell
	sw $t6, 0($t8)                  #Move block to new position
	sw $zero, 0($t5)                #Clear the old position

skip_shift_right:
	sub $t5, $t5, 4               #Move to previous column
	sub $t4, $t4, 1
	j shift_cells_right

shift_next_row_right:
	addi $t0, $t0, 40             #Move to next row
	addi $t2, $t2, 1
	j shift_rows_right

end_move_block_right:
	jr $ra





#DROP
drop:
	la $t0, row1            #Start at the bottom-most row in the Tetris grid
	li $t1, 0               #Drop distance counter
	li $t2, 1               #Current row
	li $t6, 0  		#Blocks found
init_locate_block:
	#shows address of new row
	#li $v0, 1
	#syscall
	#move $a0, $t0
	
	li $t3, 0  #column index 
	li $t4, 10 #column total
	
locate_block_loop:
	beq $t3, $t4, locate_next_row #If all columns checked go to next row
	lw $t5, 0($t0)               #Loads the cell value at current index
	beq $t5, 1, store_cell      #If cell is occupied, goes to store its position
	add $t3, $t3, 1	#Else, add to column index
	add $t0, $t0, 4	#Move right to next index
	j locate_block_loop
	
locate_next_row:
	#add $t0, $t0, 4     #Move to next row
	add $t2, $t2, 1
	beq $t2, 5, start_drop_check    #Stop if no more rows are left
	j init_locate_block   #loop through next row above
    	
store_cell:
	add $t6, $t6, 1
	beq $t6, 1, block_cell1
	beq $t6, 2, block_cell2
	beq $t6, 3, block_cell3
	beq $t6, 4, block_cell4

block_cell1:
	add $s0, $t3, $zero   #Stores the column of the occupied cell in $s0 
	add $s1, $t2, $zero   #Stores the row of the occupied cell in $s1
	add $t3, $t3, 1	#Else, add to column index
	add $t0, $t0, 4	#Move right to next index
	j locate_block_loop
	
block_cell2:
	add $s2, $t3, $zero   #Stores the column of the occupied cell in $s0 
	add $s3, $t2, $zero   #Stores the row of the occupied cell in $s1
	add $t3, $t3, 1	#Else, add to column index
	add $t0, $t0, 4	#Move right to next index
	j locate_block_loop

block_cell3:
	add $s4, $t3, $zero   #Stores the column of the occupied cell in $s0 
	add $s5, $t2, $zero   #Stores the row of the occupied cell in $s1
	add $t3, $t3, 1	#Else, add to column index
	add $t0, $t0, 4	#Move right to next index
	j locate_block_loop
	
block_cell4:
	add $s6, $t3, $zero   #Stores the column of the occupied cell in $s0 
	add $t3, $t2, $zero   #Stores the row of the occupied cell in $s1
	
	
	j start_drop_check

start_drop_check:
	la $t0, row1
	li $t1, 0 #new cell row
	li $t2, 0 #new cell column
	li $t9, 1 #block cell counter
	#subract by 1 so multipliers won't be off
	sub $s1, $s1, 1
	sub $s3, $s3, 1
	sub $s5, $s5, 1
	sub $t3, $t3, 1

check_drop_cell1:
	#check each spot below cell until you find a occupied space or bottom
	li $t4, 0 #current row 
	li $t5, 0 #current column
	mul $t6, $s0, 4 #column offset
	mul $t7, $s1, 40 #row offset
	add $t0, $t6, $t0 #adds the row offset
	add $t0, $t7, $t0 #Now $t0 is a pointer to cell1
	lw $t6, 0($t0)    #Loads value of cell1 pointer into $t6
	
	beq $t6, 1, success #If it worked you should get 1 (Validates that the locator worked correctly)
	beq $t6, 0, failure #If it didn't work you get 0
	
success: 
	add $t0, $t0, 40 #moves down to next row
	lw $t8, 0($t0)  #gets value of current cell
	beq $t8, 2, next_cell_check
	add $t4, $t4, 1
	#beq $t8, 1, block_check
	j distance_loop
	
init_cell2_check:
	la $t0, row1
	li $t4, 0 #current row 
	mul $t6, $s2, 4 #column offset
	mul $t7, $s3, 40 #row offset
	add $t0, $t6, $t0 #adds the row offset
	add $t0, $t7, $t0 #Now $t0 is a pointer to cell2
	lw $t6, 0($t0)    #Loads value of cell2 pointer into $t6
	
	beq $t6, 1, success#If it worked you should get 1 (Validates that the locator worked correctly)
	beq $t6, 0, failure #If it didn't work you get 0

init_cell3_check:
	la $t0, row1
	li $t4, 0 #current row 
	mul $t6, $s4, 4 #column offset
	mul $t7, $s5, 40 #row offset
	add $t0, $t6, $t0 #adds the row offset
	add $t0, $t7, $t0 #Now $t0 is a pointer to cell3
	lw $t6, 0($t0)    #Loads value of cell3 pointer into $t6
	
	beq $t6, 1, success#If it worked you should get 1 (Validates that the locator worked correctly)
	beq $t6, 0, failure #If it didn't work you get 0

init_cell4_check:
	la $t0, row1
	li $t4, 0 #current row 
	mul $t6, $s6, 4 #column offset
	mul $t7, $t3, 40 #row offset
	add $t0, $t6, $t0 #adds the row offset
	add $t0, $t7, $t0 #Now $t0 is a pointer to cell4
	lw $t6, 0($t0)    #Loads value of cell4 pointer into $t6
	
	
	beq $t6, 1, success#If it worked you should get 1 (Validates that the locator worked correctly)
	beq $t6, 0, failure #If it didn't work you get 0
	

distance_loop:
	#now you checked the row below cell continue down until bottom or non-empty space
	li $t2, 1
	beq $t4, 20, next_cell_check
	add $t0, $t0, 40 #moves down again
	lw $t8, 0($t0)
	beq $t8, 2, next_cell_check
	add $t4, $t4, 1
	
	j distance_loop
	
	

failure: #Should never run
	li $v0, 1
	lw $a0, ($t0)
	syscall
	j exit

next_cell_check:
	beqz $t1, init_distance_compare
	beq $t2, 1, distance_compare
	li $t2, 1
	add $t9, $t9, 1 #increments cell counter
	beq $t9, 2, init_cell2_check
	beq $t9, 3, init_cell3_check
	beq $t9, 4, init_cell4_check
	#sub $t1, $t1, 2
	j update_cell1
	
	
init_distance_compare:
	add $t1, $t4, $t1 #sets true drop distance
	beqz $t4, exit #if true drop distance is zero there is no more space and game ends
	printStr(newline)
	j next_cell_check
	
distance_compare:
	li $t2, 0
	ble $t4, $t1, new_distance
	
	j next_cell_check
	
new_distance:
	add $t1, $t4, $zero  #sets new distance that was less
	
	j next_cell_check
	
	
update_cell1:
	la $t0, row1
	la $t6, 0  #column counter
	la $t7, 0  #active cell counter
	jal if_line  #checks if line because the line's offset is different from other blocks sometimes idk why
	
	la $t0, row1 #resets $t0 because it was altered above
	
	mul $t6, $s0, 4 #column offset
	mul $t7, $s1, 40 #row offset
	add $t0, $t6, $t0 #adds the row offset
	add $t0, $t7, $t0 #Now $t0 is a pointer to cell
	li $t6, 0
	sw $t6, 0($t0)    #Sets previous cell to 0
	
	mul $t6, $t1, 40 # Sets row offset to max drop distance
	jal max_dropdistance_check #If offset greater than 19 rows branch	
	add $t0, $t0, $t6
	
	li $t2, 2
	sw $t2, 0($t0) #saves 2 value in new cell spot 

update_cell2:
	la $t0, row1
	
	mul $t6, $s2, 4 #column offset
	mul $t7, $s3, 40 #row offset
	add $t0, $t6, $t0 #adds the row offset
	add $t0, $t7, $t0 #Now $t0 is a pointer to cell
	li $t6, 0
	sw $t6, 0($t0)    #Sets previous cell to 0
	
	mul $t6, $t1, 40 # Sets row offset to max drop distance
	jal max_dropdistance_check #If offset greater than 19 rows branch	
	add $t0, $t0, $t6
	
	li $t2, 2
	sw $t2, 0($t0) #saves 2 value in new cell spot 

update_cell3:
	la $t0, row1
	
	mul $t6, $s4, 4 #column offset
	mul $t7, $s5, 40 #row offset
	add $t0, $t6, $t0 #adds the row offset
	add $t0, $t7, $t0 #Now $t0 is a pointer to cell
	li $t6, 0
	sw $t6, 0($t0)    #Sets previous cell to 0
	
	mul $t6, $t1, 40 # Sets row offset to max drop distance
	jal max_dropdistance_check #If offset greater than 19 rows branch	
	add $t0, $t0, $t6
	
	li $t2, 2
	sw $t2, 0($t0) #Saves 2 value in new cell spot (2 is used to reference for non-moving blocks)
update_cell4:
	la $t0, row1
	
	mul $t6, $s6, 4 #column offset
	mul $t7, $t3, 40 #row offset
	add $t0, $t6, $t0 #adds the row offset
	add $t0, $t7, $t0 #Now $t0 is a pointer to cell
	li $t6, 0
	sw $t6, 0($t0)    #Sets previous cell to 0
	
	mul $t6, $t1, 40 #Sets row offset to max drop distance
	
	jal max_dropdistance_check #If offset greater than 19 rows branch	
	add $t0, $t0, $t6
	
	li $t2, 2
	sw $t2, 0($t0) #saves 2 value in new cell spot 
	
	li $t9, -1 #resets generate block flag
	j valid_drop
	
max_dropdistance_check:
	#printStr(game_over)
	bge $t6, 761, fix_maxdrop
	jr $ra
fix_maxdrop:
	beq $t9, 1, line_case
	li $t6, 720
	jr $ra
	
if_line:
	bge $t7, 4, exit_ifline  #if 4 blocks are found in row1 block is line
	bge $t6, 10, exit_ifnotline #if not it isnt line
	lw $t9, 0($t0)
	add $t6, $t6, 1 #increments column count
	add $t0, $t0, 4  #next column
	beqz $t9, if_line #if cell is 0 loop
	beq $t9, 2, exit  #if cell is 2, the game is over
	add $t7, $t7, 1   #adds to block count since it can only be 1 
	beq $t9, 1, if_line #just makes sure block is 1 and loops
	j exit  #if not game broke and end it
	
	
exit_ifnotline:
	jr $ra
	
exit_ifline:
	li $t9, 1 #sets a temp flag to show that the block is a line for special case
	jr $ra
	
	
line_case:
	li $t6, 760
	jr $ra


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
	
	li $t9, -1
	j game_loop
	
valid_drop:
	#logic here for whenever there's a valid input
	printStr(newline)
	printStr(newline)
	printStr(newline)
    	
	addi $s7, $s7, 1 #increments turn
    	
	printStr(newline)
	
	li $t9, 0
	j game_loop
	
exit:
	#prints game over
	li $v0, 4
	la $a0, game_over
	syscall
	
	li $v0, 10
	syscall
	

