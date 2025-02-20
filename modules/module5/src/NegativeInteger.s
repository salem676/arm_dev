#
# Program Name: NegativeInteger.s
# Author: Zuriel Garcia
# Date: 2/18/2025
# Purpose: this program asks for an integer value and then prints its negative. 
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

	# read the user integer
	LDR r0, =format1
	LDR r1, =num1
	BL scanf

	# convert integer using complements of two
	LDR r0, =num1
	MVN r0, r0
	ADD r0, r0, #1
	STR r0, num1

	# print the negative integer
	LDR r0, =output1
	LDR r1, =num1
	BL printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	BX lr

.data
	prompt1: .asciz "Enter your integer: "
	format1: .asciz "%d"
	num1: .word 0
	output1: .asciz "The negative integer is %d\n"
