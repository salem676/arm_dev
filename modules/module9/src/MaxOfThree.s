#
# Program Name: MaxOfThree.s
# Author: Zuriel Garcia
# Date: 3/29/2025
# Purpose: this program prompts for three values and returns the biggest. 
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt name
	LDR r0, =prompt_name
	BL printf

	# read the user's name
	LDR r0, =format_str
	LDR r1, =name
	BL scanf

	# prompt for average
	LDR r0, =prompt_avg
	BL printf

	# read average input
	LDR r0, =format_int
	LDR r1, =average
	BL scanf
	
	# load the input average
	LDR r0, =average
	LDR r0, [r0, #0]

	# check if avg is < 0
	CMP r0, #0
	BLT error

	# check if avg is > 0
	CMP r0, #100
	BGT error
	
	#determine grade
	CMP r0, #90
	LDR r0, =grade_A
	BL printf

	CMP r0, #80
	LDR r0, =grade_B
	BL printf

	CMP r0, #70
	LDR r0, =grade_C
	BL printf

	LDR r0, =grade_F
	BL printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

print_grade:


.data
	prompt_val1: .asciz "Enter first value: "
	prompt_val2: .asciz "Enter second value: "
	prompt_val3: .asciz "Enter third value: "
	format_int: .asciz "%d"
	val1: .word 0
	val2: .word 0
	val3: .word 0
	result_msg: .asciz "The maximum value is: %d\n"
