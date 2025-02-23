#
# Program Name: NegativeInteger.s
# Author: Zuriel Garcia
# Date: 2/22/2025
# Purpose: this program asks for an integer value and prints the negative value. 
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt the user to enter an integer value
	LDR r0, =prompt1
	BL printf

	# read the user integer
	LDR r0, =format1
	LDR r1, =num1
	BL scanf

	# transform to negative value;
	LDR r0, =num1
	LDR r0, [r0, #0]
	MVN r0, r0
	ADD r0, r0, #1
	MOV r1, r0

	# print the new value
	LDR r0, =output1
	BL printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

.data
	prompt1: .asciz "Enter your integer value: "
	format1: .asciz "%d"
	num1: .word 0
	output1: .asciz "The result is %d\n"
