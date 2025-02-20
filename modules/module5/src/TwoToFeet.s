#
# Program Name: TwoToFeet.s
# Author: Zuriel Garcia
# Date: 2/20/2025
# Purpose: this program asks for integer inches and prints feet and inches. 
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt the user to enter an integer inches number
	LDR r0, =prompt
	BL printf
	LDR r0, =formatString
	LDR r1, =totalInches
	BL scanf

	LDR r0, =totalInches
	LDR r0, [r0, #0]
	MOV r1, #12
	BL __aeabi_idiv
	MOV r4, r0 // save feet to r4

	MOV r1, #12
	MOV r0, r4
	MUL r0, r1, r4

	# read the user integer inches
	LDR r1, =totalInches
	LDR r1, [r1, #0]
	SUB r1, r1, r0

	#
	MOV r2, r1
	MOV r1, r4
	LDR r0, =output	
	BL printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

.data
	output: .asciz "\nFeet are %d and Inches are %d\n"
	prompt: .asciz "Enter total Inches: "
	totalInches: .word 0
	formatString: .asciz "%d"
