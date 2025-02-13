#
# Program Name: PrintQuotedString.s
# Author: Zuriel Garcia
# Date: 2/13/2025
# Purpose: 
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt the user to enter a string
	LDR r0, =prompt1
	BL printf

	# read the user string
	LDR r0, =format1
	LDR r1, =string1
	BL scanf

	# print the user quoted string
	
	LDR r0, =output1
	LDR r1, =string1
	# LDR r1, [r1, #0] this line is removed because string1 is 
	# the address of the string	
	BL printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr
.data
	prompt1: .asciz "Enter your string: "
	format1: .asciz "%s"
	string1: .space 100
	output1: .asciz "\"%s\"\n"
