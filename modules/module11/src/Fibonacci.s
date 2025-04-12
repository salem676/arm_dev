#
# Program Name: Fibonacci.s
# Author: Zuriel Garcia
# Date: 4/11/2025
# Purpose: This program calculates nth Fibonacci term for the Fibonacci series. ARM assembly implementation.
#
.global main
main:
	# makes room on stack
	SUB sp, sp, #4
	# saves link register
	STR lr, [sp, #0]
	
	# load the address of the prompt for fibonacci
	LDR r0, =prompt
	BL printf

	# load format string %d and address of the n number
	LDR r0, =format
	LDR r1, =n
	BL scanf
	
	# loading n and checking if is < 0
	LDR r0, =n
	LDR r0, [r0, #0] 
	CMP r0, #0
	BLT invalid_input

	BL Fibo

	# moves result to r4
	MOV r3, r0
	
	# load output message
	LDR r0, =result_msg
	# load n into r1
	LDR r1, =n
	LDR r1, [r1, #0]
	MOV r2, r3
	BL printf

	B exit
.text
Fibo:
	# allocates space for lr, r4 and r5
	SUB sp, sp, #12
	# saves return address
	STR lr, [sp, #0]
	# save r4
	STR r4, [sp, #4]
	# copy  into r4
	MOV r4, r0
	# save r5
	STR r5, [sp, #8]
	
	CMP r4, #0
	# if n != 0, go to Else1
	BNE Else1
		# base case return value 0
		MOV r1, #0
		# call Return
		B Return
	Else1:
		CMP r4, #1
		# if n != 1, go to Else2
		BNE Else2
			# base case return value 1
			MOV r1, #1
			# call Return
			B Return
		
	Else2:
		# prepare argument n - 1
		SUB r0, r4, #1
		# recursive call Fibo(n - 1)
		BL Fibo
		# save result to r5
		MOV r5, r0
		# prepare argument n - 2
		SUB r0, r4, #2
		# recursive call Fibo(n - 2)
		BL Fibo
		# add r0, r5
		ADD r0, r0, r5
		# call Return
		B Return
	Endif:
	
	
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
	prompt: .asciz "Enter the number (n) for the Fibonacci term: \n"
	format: .asciz "%d"
	n: .word 0
	result: .word 0
	result_msg: .asciz "Fibonacci term for %d is: %d\n"
	error_msg: .asciz "Error! Number for Fibonacci term must be a non-negative integer.\n"
