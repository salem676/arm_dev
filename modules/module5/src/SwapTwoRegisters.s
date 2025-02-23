#
# Program Name: MultiplyByTen.s
# Author: Zuriel Garcia
# Date: 2/22/2025
# Purpose: this program asks for an integer value and then multiplies it by ten using left shifts. 
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

	# read the user integer number
	LDR r0, =format1
	LDR r1, =num1
	BL scanf


	# print the value multiplied by ten
	LDR r0, =output1
	LDR r1, =num1
	LDR r1, [r1]	
	
	MOV r2, r1, LSL #3
	MOV r3, r1, LSL #1
	ADD r1, r3, r2

	BL printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

.data
	prompt1: .asciz "Enter your number: "
	format1: .asciz "%d"
	num1: .word 0
	output1: .asciz "The result is: %d\n"
