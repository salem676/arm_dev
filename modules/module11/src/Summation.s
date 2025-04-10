#
# Program Name: Summation.s
# Author: Zuriel Garcia
# Date: 4/10/2025
# Purpose: This program accepts does a summation for an n integer to all of the subsequent lower positive numbers. ARM assembly implementation.
#
.global main
main:
	# push the stack
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	LDR r0, =prompt
	BL printf
	LDR r0, =format
	LDR r1, =number
	BL scanf

	LDR r0, =number
	LDR r0, [r0, #0]
	BL Sum
	MOV r1, r0
	
	LDR r0, =output
	BL printf

	B exit

exit:
	# restore stack and return
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr
.text
Sum:
	# push the stack
	SUB sp, sp, #8
	STR lr, [sp, #0]
	STR r4, [sp, #4]
	
	MOV r4, r0

	# if n == 0, ret 0
	CMP r4, #0
	BNE Else
		MOV r0, #0
		B Return
	Else:
		SUB r0, r4, #1
		BL Sum
		ADD r0, r4, r0
		B Return
	Endif:
	
	# pop the stack
	Return:
	LDR lr, [sp, #0]
	LDR r4, [sp, #4]
	ADD sp, sp, #8
	MOV pc, lr

.data
	prompt: .asciz "Enter a value to sum to: \n"
	output: .asciz "Your summation is: %d\n"
	format: .asciz "%d"
	number: .word 0
