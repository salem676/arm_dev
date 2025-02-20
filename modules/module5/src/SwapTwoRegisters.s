#
# Program Name: PrintAge.s
# Author: Zuriel Garcia
# Date: 2/13/2025
# Purpose: this program asks for an integer value for age and prints it then. 
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt the user to enter an integer age
	LDR r0, =prompt1
	BL printf

	# read the user integer age
	LDR r0, =format1
	LDR r1, =num1
	BL scanf

	# print the user age
	
	LDR r0, =output1
	LDR r1, =num1
	LDR r1, [r1]	
	BL printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	BX lr

.data
	prompt1: .asciz "Enter your age: "
	format1: .asciz "%d"
	num1: .word 0
	output1: .asciz "You are %d years old\n"
