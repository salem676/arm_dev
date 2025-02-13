#
# Program name: PrintFloating.s
# Author: Zuriel Garcia
# Date: 2/13/2025
# Purpose: This program asks for a float number and prints it.
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt the user to enter a float
	LDR r0, =prompt1
	BL printf

	# read the user float
	LDR r0, =format1
	LDR r1, =num1
	BL scanf

	# print the user float
	
	LDR r0, =output1
	LDR r1, =num1
	LDR r1, [r1, #0]	
	BL printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr
.data
	prompt1: .asciz "Enter an float number: "
	format1: .asciz "%f"
	num1: .word 0
	output1: .asciz "You entered the number %f\n"
