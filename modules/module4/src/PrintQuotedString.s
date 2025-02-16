#
# Program Name: PrintQuotedString.s
# Author: Zuriel Garcia
# Date: 2/13/2025
# Purpose: this program asks for a string and then prints it back quoted. 
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
	BL printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4

	# explicit exit
	LDR r0, =0
	BL exit


.data
	#%99[^\n] allows us to read characters until \n
	prompt1: .asciz "Enter your string: "
	format1: .asciz "%99[^\n]"
	string1: .space 100
	output1: .asciz "\"%s\"\n"
