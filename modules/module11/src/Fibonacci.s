#
# Program Name: Fibonacci.s
# Author: Zuriel Garcia
# Date: 4/9/2025
# Purpose: This program calculates the n-th Fibonnaci number, based on user input. ARM assembly implementation.
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
input_loop:
	# prompt the user for n
	LDR r0, =prompt
	BL printf

	# read the number into memory
	LDR r0, =format
	LDR r1, =n
	BL scanf

	
	# loading n and checking if non-negative
	LDR r1, =n
	LDR r1, [r1, #0]
	CMP r1, #0
	BLT invalid_input
	
	B compute

compute:
	# load  n int r0 for Fibonacci
	LDR r0, =n
	LDR r0, [r0, #0]

	BL Fibonacci

	# storing result
	LDR r1, =result
	STR r0, [r1, #0]
	
	# printing result
	LDR r0, =result_msg
	LDR r1, =n
	LDR r1, [r1, #0]
	LDR r2, =result
	LDR r2, [r2, #0]
	BL printf

	B exit

Fibonacci:	

	CMP r0, #0
	BEQ fib_zero

	CMP r0, #1
	BEQ fib_one

	MOV r2, r0

	# n-1
	SUB r0, r0, #1
	# recursive call Fibonacci(n-1)
	BL Fibonacci
	
	MOV r3, r0

	# n-2
	SUB r0, r2, #2
	# recursive call Fibonacci(n-2)
	BL Fibonacci

	ADD r0, r0, r3
	BX lr

fib_zero:
	# base case zero
	MOV r0, #0
	BX lr

fib_one:
	# base case one
	MOV r0, #1
	BX lr

invalid_input:
	# prints error message
	LDR r0, =error_msg
	BL printf
	B input_loop

exit:
	# restore stack and return
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr


.data
	prompt: .asciz "Enter the position (n) of the Fibonacci sequence: \n"
	format: .asciz "%d"
	n: .word 0
	result: .word 0
	result_msg: .asciz "Fibonnaci number at position %d is: %d\n"
	error_msg: .asciz "Please enter a non-negative number!\n"
