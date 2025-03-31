#
# Program Name: MaxOfThree.s
# Author: Zuriel Garcia
# Date: 3/29/2025
# Purpose: this program prompts for three values and returns the biggest. 
#
.text
.global main
.global max_of_three
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt for first value
	LDR r0, =prompt_val1
	BL printf
	LDR r0, =format_int
	LDR r1, =val1
	BL scanf

	# prompt for second value
	LDR r0, = prompt_val2
	BL printf
	LDR r0, =format_int
	LDR r1, =val2
	BL scanf

	# prompt for third value
	LDR r0, =prompt_val3
	BL printf
	LDR r0, =format_int
	LDR r1, =val3
	BL scanf

	# load values and function call
	LDR r0, =val1
	LDR r0, [r0, #0]
	LDR r1, =val2
	LDR r1, [r1, #0]
	LDR r2, =val3
	LDR r2, [r2, #0]
	BL max_of_three

	# printing
	LDR r1, =output_msg
	MOV r1, r0
	LDR r0, =result_msg
	BL printf

max_of_three:
	CMP r0, r1
	BGE check_r0_r2
	MOV r0, r1
	
check_r0_r2:
	CMP r0, r2
	BGE return_max
	MOV r0, r2

return_max:
	BX lr

exit:
	# pop the stack register
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr


.data
	prompt_val1: .asciz "Enter first value: "
	prompt_val2: .asciz "Enter second value: "
	prompt_val3: .asciz "Enter third value: "
	format_int: .asciz "%d"
	val1: .word 0
	val2: .word 0
	val3: .word 0
	result_msg: .asciz "The maximum value is: %d\n"
