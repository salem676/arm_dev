#
# Program Name: LogicAlphabetic.s
# Author: Zuriel Garcia
# Date: 3/31/2025
# Purpose: this program asks for an input value and prints message to determine if its alphabetic. 
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
	
	# convert uppercase check, r1 = r0 - 0x41, TST checks if r3 is zero, if zero branchs alpha
	SUB r1, r0, #0x41
	MVN r2, #0x1F
	AND r3, r1, r2
	TST r3, r3
	BEQ is_alpha 

	# convert lowercase check, r1 = r0 - 0x61
	SUB r1, r0, #0x61
	AND r3, r1, r2
	TST r3, r3
	BEQ is_alpha

	B not_alpha	

not_alpha:
	# prints the result is not alphabetic
	LDR r0, =output2
	BL printf
	B exit
is_alpha:
	# prints the result is alphabetic
	LDR r0, =output1
	BL printf
	B exit
exit:
	#pop the stack record
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr


.data
	prompt1: .asciz "Enter your input value: "
	format1: .asciz "%c"
	input1: .word 0
	output1: .asciz "The result is alphabetic\n"
	output2: .asciz "The result is not alphabetic\n"
