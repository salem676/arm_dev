#
# Program Name: Miles2Kilometer.s
# Author: Zuriel Garcia
# Date: 3/13/2025
# Purpose: this program asks for an integer miles value and converts it to a rounded kilometers. 
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt the user to enter an integer miles
	MOV r1, #161	
	MUL r0, r0, r1
	MOV r1, #100
	BL __aeabi_idiv

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr
.data
