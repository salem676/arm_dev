#
# Program name: PrintFloating.s
# Author: Zuriel Garcia
# Date: 2/13/2025
# Purpose: This program asks for a float number and prints it.
#
.text
.global main
main:
	# push the stack record, extra space must be allocated for alingment
	SUB sp, sp, #8
	STR lr, [sp, #0]
	
	# prompt the user to enter a float
	LDR r0, =prompt1
	BL printf

	# read the user float
	LDR r0, =format1
	LDR r1, =num1
	BL scanf

	# load 32bit float from num1
	LDR r1, =num1
	LDR r2, [r1]

	# extend float to double
	SUB sp, sp, #8
	STR r2, [sp]
	MOV r3, #0
	STR r3, [sp, #4]

	# print 64bit
	LDR r0, =output1
	MOV r1, sp
	BL printf

	# clean stack
	ADD sp, sp, #8

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #8
	MOV pc, lr
.data
	prompt1: .asciz "Enter a float number: "
	format1: .asciz "%f"
	num1: .word 0
	output1: .asciz "You entered the number %f\n"
