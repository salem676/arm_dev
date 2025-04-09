#
# Program Name: RecursiveMult.s
# Author: Zuriel Garcia
# Date: 4/9/2025
# Purpose: This program accepts two numbers, the first m multiplier, the second, the successive number of iterations n. Calculates multiplication
# using successive addition iterations. ARM assembly implementation.
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt the user for multiplier m
	LDR r0, =prompt_m
	BL printf

	# read the multiplier into memory
	LDR r0, =format
	LDR r1, =m
	BL scanf

	# prompt the user for number of additions
	LDR r0, =prompt_n
	BL printf

	# read number of additions in memory
	LDR r0, =format
	LDR r1, =n
	BL scanf
	
	# loading n and checking if is < 1
	LDR r1, =n
	LDR r1, [r1, #0]
	CMP r1, #1
	BLT invalid_input

	# load m and n int r0 and r1 for mult
	LDR r0, =m
	LDR r0, [r0, #0]
	LDR r1, =n
	LDR r1, [r1, #0]

	BL mult

	# storing result
	LDR r2, =result
	STR r0, [r2, #0]
	
	# printing result
	LDR r0, =result_msg
	LDR r1, =m
	LDR r1, [r1, #0]
	LDR r2, =n
	LDR r2, [r2, #0]
	LDR r3, =result
	LDR r3, [r3, #0]
	BL printf

	B exit

mult:
	CMP r1, #1
	BEQ mult_base
	
	MOV r2, r0
	SUB r1, r1, #1
	# recursive call mult(m, n - 1)
	BL mult
	ADD r0, r0, r2
	BX lr

mult_base:
	# base case for mult
	MOV r0, r0
	BX lr

invalid_input:
	# prints error message
	LDR r0, =error_msg
	BL printf

exit:
	# restore stack and return
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr


.data
	prompt_m: .asciz "Enter the multiplier (m): \n"
	prompt_n: .asciz "Enter the number of addition (n): \n"
	format: .asciz "%d"
	m: .word 0
	n: .word 0
	result: .word 0
	result_msg: .asciz "Result of %d x %d using successive additions is: %d\n"
	error_msg: .asciz "Number of additions (n) must be at least 1.\n"
