#
# Program Name: PrintStringWTabs.s
# Author: Zuriel Garcia
# Date: 2/16/2025
# Purpose: this program outputs a string with tabs between the number output and the characters before and after it.
#
.text
.global main
main: 
	# push the stack
	SUB sp, sp, #4
	STR lr, [sp, #0]

	# print the output string
	LDR r0, =output1
	BL printf
	
	# pop the stack and return
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	BX lr

.data
	output1: .asciz "Z\t76\tL\n"
