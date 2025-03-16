#
# Program Name: InchesToFt.s
# Author: Zuriel Garcia
# Date: 3/13/2025
# Purpose: this program asks for an integer inches value and converts it to a rounded feet value. 
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt the user to enter an integer age
	LDR r0, =prompt
	BL printf
	LDR r0, =formatString
	LDR r1, =inches
	BL scanf

	LDR r0, =inches
	LDR r0, [r0, #0]
	# next number is 833 = 64 * 13 +1
	MOV r1, #13
	LSL r1, r1, #6
	ADD r1, r1, #1
	MUL r0, r0, r1
	# next number is 10000 = 16 * 625, and 625 = 39 * 16 +1
	MOV r1, #39
	LSL r1, r1, #4
	ADD r1, r1, #1
	LSL r1, r1, #4
	BL __aeabi_idiv

	#
	MOV r1, r0
	LDR r0, =output	
	BL printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr
.data
	output: .asciz "\nDistance in Feet is: %d\n"
	prompt: .asciz "Enter Distance in Inches: "
	inches: .word 0
	formatString: .asciz "%d"
