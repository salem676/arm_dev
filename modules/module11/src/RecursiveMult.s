#
# Program Name: RecursiveMult.s
# Author: Zuriel Garcia
# Date: 4/9/2025
# Purpose: This program accepts two numbers, the first m multiplier, the second, the successive number of iterations n. Calculates multiplication
# using successive addition iterations. ARM assembly implementation.
#
.global main
main:
	# makes room on stack
	SUB sp, sp, #4
	# saves link register
	STR lr, [sp, #0]
	
	# load the address of the prompt for multiplier
	LDR r0, =prompt_m
	BL printf

	# load format string %d and address of the multiplier variable
	LDR r0, =format
	LDR r1, =m
	BL scanf

	# load address of the prompt for number of additions
	LDR r0, =prompt_n
	BL printf

	# load format string %d and address of number of additions variable
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

	# moves result to r3
	MOV r3, r1
	
	# load output message
	LDR r0, =result_msg
	# load m into r1
	LDR r1, =m
	LDR r1, [r1, #0]
	LDR r2, =n
	LDR r2, [r2, #0]
	BL printf

	B exit
.text
mult:
	# allocates space for lr and r4
	SUB sp, sp, #12
	# saves return address
	STR lr, [sp, #0]
	# save r4
	STR r4, [sp, #4]
	# copy m into r4
	MOV r4, r0
	# save r5
	STR r5, [sp, #8]
	# copy n into r5
	MOV r5, r1
	
	CMP r5, #0
	# if n != 0, go to Else
	BNE Else
		# base case return value
		MOV r1, #0
		# call Return
		B Return
	Else:
		# prepare argument n - 1
		SUB r1, r5, #1
		# recursive call mult(m, n - 1)
		BL mult
		# add m (in r4) to result
		ADD r1, r4, r1
		# call Return
		B Return
	Endif:
	
	# pop the stack
	Return:
	# restore return address
	LDR lr, [sp, #0]
	# restore r5
	LDR r5, [sp, #8]
	# restore r4
	LDR r4, [sp, #4]
	# restore stack
	ADD sp, sp, #12
	# return to caller
	MOV pc, lr
	

invalid_input:
	# prints error message
	LDR r0, =error_msg
	BL printf
	B exit
exit:
	# load link register
	LDR lr, [sp, #0]
	# restore stack space
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
