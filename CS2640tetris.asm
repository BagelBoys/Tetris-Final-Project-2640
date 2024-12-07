# CS2640 Tetris Final Project

# RNG macro for generating random numbers within a range
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
# Define grid size
grid_width:  .word 10       # Grid width (10 columns)
grid_height: .word 20       # Grid height (20 rows)

# Define initial position for the current block
block_row:  .word 0         # Row position for the current block (starting at the top)
block_col:  .word 4         # Column position for the current block (starting in the middle)

# Define the grid to hold the Tetris game (10x20 grid)
grid: .space 200  # Grid space (10 columns * 20 rows = 200 bytes)

# Other data for instructions and prompts
instructions: .asciiz "Controls: 'a' = left, 'd' = right, 's' = drop, 'q' = quit\n"
invalidIns: .asciiz "\nThis is an invalid input! Try again."
prompt: .asciiz "Enter your move: "
turnprompt: .asciiz "Turn: "
newline: .asciiz "\n"
hash: .asciiz "#"
dot: .asciiz "."
row_end: .asciiz "\n"
userinput_buffer: .space 2

t_block_default:
    .byte 1, 1, 1      # Row 1: ###
    .byte 0, 1, 0      # Row 2:  # #

blocks:
    .word t_block_default
    
block_rows:
    .word 2      # Rows for t_block_default
block_cols:
    .word 3      # Columns for t_block_default

.text
main:
    # Print the instructions
    li $v0, 4
    la $a0, instructions
    syscall

    # Print the t_block_default before the grid
    li $s0, 0          # Row index
    li $s1, 0          # Column index
    la $t7, t_block_default

block_row_loop:
    bge $s0, 2, block_done
    li $s1, 0          # Reset column index

block_loop:
    bge $s1, 3, next_row
    lb $s6, 0($t7)    # Load byte from block
    addi $t7, $t7, 1   # Move to next byte

    # Print character based on block value
    beq $s6, 1, print_hash
    la $a0, dot             # Load address of '.'
    li $v0, 4
    syscall
    j continue_column

print_hash:
    la $a0, hash            # Load address of '#'
    li $v0, 4
    syscall

continue_column:
    addi $s1, $s1, 1
    j block_loop

next_row:
    addi $s0, $s0, 1       # Move to next row
    printStr(row_end)      # Print newline after each row
    j block_row_loop

block_done:
    # After printing the block, print the grid
    j grid_print_empty

game_loop:
    # Ask for user input
    li $v0, 8
    la $a0, userinput_buffer
    li $a1, 2
    syscall
    lb $s0, 0($a0)

    # Validate user input
    li $t6, 97  # ASCII 'a' (left)
    beq $s0, $t6, valid_move_left
    li $t6, 115  # ASCII 's' (drop)
    beq $s0, $t6, drop_block
    li $t6, 100  # ASCII 'd' (right)
    beq $s0, $t6, valid_move_right
    li $t6, 113  # ASCII 'q' (quit)
    beq $s0, $t6, endgame

    # Handle invalid input
    li $v0, 4
    la $a0, invalidIns
    syscall
    j game_loop

valid_move_left:
    # Handle left move logic here
    j game_loop  # Keep running the game loop after moving

valid_move_right:
    # Handle right move logic here
    j game_loop  # Keep running the game loop after moving

drop_block:
    # Load the current block's position
    la $t0, block_row
    lw $t1, 0($t0)  # Load current row of the block
    la $t2, block_col
    lw $t3, 0($t2)  # Load current column of the block

    # Check if the block can drop further
    li $t4, 19  # Max row (20 rows in the grid, indexed from 0)
    bge $t1, $t4, block_lands  # If block is at the bottom, stop

    # Move block down by one row
    addi $t1, $t1, 1
    sw $t1, 0($t0)  # Save new row position

    # Reprint the grid after the block move
    j grid_print_empty  # Reprint the grid with updated block position

block_lands:
    # Place the block in the grid when it lands
    la $t0, block_row
    lw $t1, 0($t0)  # Block's current row
    la $t2, block_col
    lw $t3, 0($t2)  # Block's current column

    # Place the block's cells (t_block_default) into the grid
    li $s0, 0  # Row offset in block
    li $s1, 0  # Column offset in block
    la $t4, t_block_default  # Start of block

place_block_loop:
    # Loop through each row and column of the block
    bge $s0, 2, block_done_landing     # If row offset exceeds number of rows (2), finish placing the block
    li $s1, 0                          # Reset column index

block_column_loop:
    bge $s1, 3, next_line              # If column offset exceeds number of columns (3), move to next row

    # Calculate the address of the current block cell using row and column offsets
    la $t7, t_block_default           # Load the address of t_block_default
    add $t8, $t7, $s0                  # Add row offset to the base address (for the current row)
    add $t8, $t8, $s1                  # Add column offset to the row address
    lb $s2, 0($t8)                     # Load the value (0 or 1) from the block

    # Calculate grid position (index = row * grid_width + col)
    mul $t5, $t1, 10                   # Multiply row index by grid width (10)
    add $t5, $t5, $t3                  # Add column index to get the position
    la $t6, grid                       # Load the base address of the grid
    add $t6, $t6, $t5                  # Calculate the address of the specific grid cell

    # Place the block value into the grid (if the value is 1)
    beqz $s2, continue_columns          # If the block value is 0 (empty space), skip
    sb $s2, 0($t6)

continue_columns:
    addi $s1, $s1, 1
    j place_block_loop

next_line:
    li $s1, 0  # Reset column index
    addi $s0, $s0, 1  # Move to the next row
    j place_block_loop

block_done_landing:
    # After placing the block, print the grid
    j grid_print_empty  # Reprint the grid to reflect block position

grid_print_empty:
    # Print the current state of the grid
    li $t3, 0                     # Row index
    li $t4, 0                     # Column index

grid_print_loop:
    la $t0, grid                  # Load the base address of the grid
    add $t0, $t0, $t4             # Get address of the current grid cell
    lb $t5, 0($t0)                # Load grid cell value (0 or 1)
    beqz $t5, print_dot           # If 0 (empty), print '.'
    la $a0, hash                  # Print '#'
    li $v0, 4
    syscall
    j continue_grid

print_dot:
    la $a0, dot                   # Print '.'
    li $v0, 4
    syscall

continue_grid:
    addi $t4, $t4, 1              # Move to next column
    bge $t4, 10, next_grid_row    # If 10 columns printed, go to next row
    j grid_print_loop

next_grid_row:
    printStr(newline)             # Print newline after row
    addi $t3, $t3, 1              # Move to next row
    bge $t3, 20, endgame          # If 20 rows printed, end game
    li $t4, 0                     # Reset column index
    j grid_print_loop
endgame:
li $v0, 10
syscall