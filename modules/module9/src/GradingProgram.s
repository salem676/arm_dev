#
# Program Name: GradingProgram.s
# Author: Zuriel Garcia
# Date: 3/29/2025
# Purpose: this program prompts for a name and a grade average and calculates grade letter. 
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
	BGE assign_A

	CMP r0, #80
	BGE assign_B
	
	CMP r0, #70
	BGE assign_C

	B assign_F

assign_A:
	LDR r1, =grade_A
	B print_grade

assign_B:
	LDR r1, =grade_B
	B print_grade

assign_C:
	LDR r1, =grade_C
	B print_grade

assign_F:
	LDR r1, =grade_F

print_grade:
	# prints name and grade
	LDR r0, =output_msg
	MOV r2, r1
	LDR r1, =name
	BL printf
	B exit

error:
	# prints error message
	LDR r0, =error_msg
	BL printf
exit:
	# restore stack and retunr
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr


.data
	prompt_name: .asciz "Enter student name: "
	prompt_avg: .asciz "Enter student average: "
	format_str: .asciz "%s"
	format_int: .asciz "%d"
	name: .space 20
	average: .word 0
	error_msg: .asciz "Error: invalid average! Value must be between 0 and 100\n"
	output_msg: .asciz "%s's grade is %s\n"
	grade_A: .asciz "A"
	grade_B: .asciz "B"
	grade_C: .asciz "C"
	grade_F: .asciz "F"
