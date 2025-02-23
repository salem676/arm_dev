#
# Program Name: SwapTwoRegisters.s
# Author: Zuriel Garcia
# Date: 2/23/2025
# Purpose: this program swaps two registers. 
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# swapping
	EOR r0, r0, r1
	EOR r1, r0, r1
	EOR r0, r0, r1

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr
.data
