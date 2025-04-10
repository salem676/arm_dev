#
# Program Name: Summation.s
# Author: Zuriel Garcia
# Date: 4/10/2025
# Purpose: This program accepts does a summation for an n integer to all of the subsequent lower positive numbers. ARM assembly implementation.
#
.global main
main:
	# makes room on the stack
	SUB sp, sp, #4
	# saves the link register
	STR lr, [sp, #0]
	
	# load address of the prompt string
	LDR r0, =prompt
	# calls printf
	BL printf
	# loads format string "%d"
	LDR r0, =format
	# loads address of the number variable
	LDR r1, =number
	# calls scanf to read integer input
	BL scanf

	# loads address of number
	LDR r0, =number
	# loads value from number into r0
	LDR r0, [r0, #0]
	# calls Sum
	BL Sum
	# moves result into r1 for printf
	MOV r1, r0
	
	# loads output format string
	LDR r0, =output
	# calls printf result
	BL printf

	B exit

exit:
	# restores saved lr
	LDR lr, [sp, #0]
	# restores stack
	ADD sp, sp, #4
	# 		
	MOV pc, lr
.text
Sum:
	# allocates space for lr and r4
	SUB sp, sp, #8
	# saves return address
	STR lr, [sp, #0]
	# saves r4
	STR r4, [sp, #4]
	
	# copies n into r4
	MOV r4, r0

	CMP r4, #0
	# if n != 0, go to Else
	BNE Else
		# base case return value
		MOV r0, #0
		# call Return
		B Return
	Else:
		# prepare argument n - 1
		SUB r0, r4, #1
		# recursive call
		BL Sum
		# add current n (in r4) to result
		ADD r0, r4, r0
		# call Return
		B Return
	Endif:
	
	# pop the stack
	Return:
	# restore return address
	LDR lr, [sp, #0]
	# restore r4
	LDR r4, [sp, #4]
	# restore stack
	ADD sp, sp, #8
	# return to caller
	MOV pc, lr

.data
	prompt: .asciz "Enter a value to sum to: \n"
	output: .asciz "Your summation is: %d\n"
	format: .asciz "%d"
	number: .word 0
