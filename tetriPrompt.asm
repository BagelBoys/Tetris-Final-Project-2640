.data
terisPrompt: .asciiz "TETRIS\n"
playPrompt: .asciiz "Enter 'p' to play\n"
exitPrompt: .asciiz "Enter 'e' to exit\n"
userInputPrompt: .asciiz "Please enter your choice: "
invalidInputPrompt: .asciiz "Invalid input, please enter 'p' or 'e'.\n"

.text
main:
    # Print "TETRIS"
    li $v0, 4
    la $a0, terisPrompt
    syscall

    # Print "Enter 'p' to play"
    li $v0, 4
    la $a0, playPrompt
    syscall

    # Print "Enter 'e' to exit"
    li $v0, 4
    la $a0, exitPrompt
    syscall

    # Print the user input prompt
    li $v0, 4
    la $a0, userInputPrompt
    syscall

    # Get the user's input (character)
    li $v0, 12            # syscall for reading a character
    syscall
    move $t0, $v0         # Store the character input in $t0

    # Check if the input is 'p' (play)
    li $t1, 112            # ASCII value for 'p'
    beq $t0, $t1, user_Yes

    # Check if the input is 'e' (exit)
    li $t1, 101            # ASCII value for 'e'
    beq $t0, $t1, exit

    # Invalid input handling
    li $v0, 4
    la $a0, invalidInputPrompt
    syscall

    # Jump back to get input again
    j main

user_Yes:
    # You can add code for the "play" logic here.
    # For now, we'll just print a placeholder message.
    li $v0, 4
    la $a0, playPrompt
    syscall
    j
    

exit:
    # Exit the program
    li $v0, 10
    syscall


