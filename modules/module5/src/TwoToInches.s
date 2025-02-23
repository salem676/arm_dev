#
# Program Name: TwoToInches.s
# Author: Zuriel Garcia
# Date: 2/20/2025
# Purpose: this program asks for integer feet and integer inches, prints inches. 
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt the user to enter an integer feet number
	LDR r0, =prompt1
	BL printf
	LDR r0, =formatString
	LDR r1, =totalFeet
	BL scanf

	# read the user integer feet
	LDR r1, =totalFeet
	LDR r1, [r1, #0]

	MOV r4, r1

	# prompt the user to enter an integer inches number	
	LDR r0, =prompt2
	BL printf
	LDR r0, =formatString
	LDR r1, =totalInches
	BL scanf

	# read the user integer inches
	LDR r1,  =totalInches
	LDR r1, [r1, #0]

	#
	MOV r5, #12
	MUL r6, r4, r5
	ADD r7, r6, r1

	#
	MOV r1, r7
	LDR r0, =output	
	BL printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

.data
	output: .asciz "\nTotal Inches are %d\n"
	prompt1: .asciz "Enter total Feet: "
	prompt2: .asciz "Enter total Inches: "
	totalFeet: .word 0
	totalInches: .word 0
	formatString: .asciz "%d"
