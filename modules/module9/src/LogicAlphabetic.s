#
# Program Name: LogicAlphabetic.s
# Author: Zuriel Garcia
# Date: 3/29/2025
# Purpose: this program asks for an input value and prints message to determine if alphabetic. 
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt the user to enter an input value
	LDR r0, =prompt1
	BL printf

	# read the user integer
	LDR r0, =format1
	LDR r1, =input1
	BL scanf

	# load input value on r0;
	LDR r0, =input1
	LDR r0, [r0, #0]
	
	# check if 'A' <= r0 <= 'Z' (0x41 <= r0 <= 0x5A)
	CMP r0, #0x41
	BLT not_alpha
	CMP r0, #0x5A
	BLE is_alpha

	# check if 'a' <= r0 <= 'z' (0x61 <= r0 <= 0x7A)	
	CMP r0, #0x61
	BLT not_alpha
	CMP r0, #0x7A
	BLE is_alpha

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

not_alpha:
	# prints the result is not alphabetic
	LDR r0, =output2
	BL printf
is_alpha:
	# prints the result is alphabetic
	LDR r0, =output1
	BL printf


.data
	prompt1: .asciz "Enter your input value: "
	format1: .asciz "%d"
	input1: .word 0
	output1: .asciz "The result is alphabetic\n"
	output2: .asciz "The result is not alphabetic\n"
