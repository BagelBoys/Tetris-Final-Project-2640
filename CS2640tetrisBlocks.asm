#CS2640 Block Rotation for tetris
# RNG Macro (range and destination register)
.macro RNG(%range, %resultreg)
loop:
    li $v0, 41         # Syscall 41: Generate random integer
    li $a0, 0          # RNG source 0
    syscall            # Random number returned in $a0

    li $t0, %range     # Load range into $t0
    rem %resultreg, $a0, $t0  # result = $a0 % range
    bltz %resultreg, loop  # If result is negative, fix it
    j done_rng

done_rng:
    # Ensure index is valid by checking the result
    # If out of bounds, regenerate the random number
    li $t1, 3                # Set max index (e.g., for 2 blocks: t_block_default, square_default)
    bge %resultreg, $t1, loop  # If index >= 2, regenerate
# Otherwise, done with RNG
.end_macro

.data
t_block_default:
    .byte 1, 1, 1
    .byte 0, 1, 0

square_default:
    .byte 1, 1
    .byte 1, 1
    
s_block_default:
	.byte 0, 1, 1
	.byte 1, 1, 0

blocks:
    .word t_block_default, square_default, s_block_default  # Array of addresses of blocks

block_rows:
    .word 2      # Rows for t_block_default
    .word 2      # Rows for square_default
    .word 2	#Rows For s_block_default

block_cols:
    .word 3      # Columns for t_block_default
    .word 2      # Columns for square_default
    .word 3	# Columns For s_block_default

newline: .asciiz "\n"
hash:    .asciiz "#"  # For 1
dot:     .asciiz "."  # For 0
prompt1: .asciiz "Would You Like to Generate a Block Yes(1) or No(2) : "

   .text
main:

	li $v0, 4
	la $a0, prompt1
	syscall
	
	li $v0, 5
	syscall
	move $s2, $v0
	
	#Check User's Choice
	beq $s2, 1, loop
	beq $s2, 2, done
	

loop:	

	
    # Generate a random index to select a block
    RNG(3, $t0)             # Generate a random number between 0 and 1, store in $t0

    # Load block address, rows, and columns
    la $t1, blocks          # Load address of blocks array
    sll $t0, $t0, 2         # Multiply index by 4 (word size)
    add $t3, $t1, $t0       # Calculate effective address: $t3 = $t1 + $t0
    lw $t2, 0($t3)          # Load address of selected block into $t2
    
    li $v0, 1               # Print integer syscall
    move $a0, $t2            # Move address to $a0
    syscall                  # Print address of selected block
    
    li $v0, 4
    la $a0, newline
    syscall


    # Load row count
    la $t4, block_rows      # Load address of block_rows array
    add $t5, $t4, $t0       # Compute effective address for row count
    lw $t6, 0($t5)          # Load row count for selected block into $t6

    # Load column count
    la $t7, block_cols      # Load address of block_cols array
    add $t8, $t7, $t0       # Compute effective address for column count
    lw $t9, 0($t8)          # Load column count for selected block into $t9

    # Print the selected block
    li $s0, 0               # Row counter

row_loop:
    bge $s0, $t6, main     # Exit if all rows are printed

    # Print one row
    li $t8, 0               # Column counter

column_loop:
    bge $t8, $t9, end_row   # Exit if all columns are printed

    lb $s1, 0($t2)         # Load the next byte (1 or 0) from the block
    addi $t2, $t2, 1        # Move to the next byte

    # Print corresponding character
    beq $s1, 1, print_hash
    j print_dot

print_hash:
    la $a0, hash            # Load address of '#'
    li $v0, 4               # Print string syscall
    syscall
    j continue_column

print_dot:
    la $a0, dot             # Load address of '.'
    li $v0, 4               # Print string syscall
    syscall

continue_column:
    addi $t8, $t8, 1        # Increment column counter
    j column_loop           # Repeat for next column

end_row:
    # Print newline after finishing row
    la $a0, newline
    li $v0, 4               # Print string syscall
    syscall

    addi $s0, $s0, 1        # Increment row counter
    j row_loop              # Repeat for next row

done:
    li $v0, 10              # Exit syscall
    syscall
