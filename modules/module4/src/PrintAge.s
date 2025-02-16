#
# Program Name: PrintAge.s
# Author: Zuriel Garcia
# Date: 2/13/2025
# Purpose: this program asks for an integer value for age and prints it then. 
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt the user to enter an integer age
	LDR r0, =prompt1
	BL printf

	# debug printing registers before scanf
	MOV r2, r0
	MOV r3, r1
	BL debug_registers_before_scanf

	# read the user integer age
	LDR r0, =format1
	LDR r1, =num1
	BL scanf
	
	# debug printing registers after scanf
	MOV r2, r0
	MOV r3, r1
	BL debug_registers_after_scanf

	# print the user age
	
	LDR r0, =output1
	LDR r1, =num1
	LDR r1, [r1, #0]	
	BL printf

	# debug printing registers after printf
	MOV r2, r0
	MOV r3, r1
	BL debug_registers_after_printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

debug_registers_before_scanf:
	# this function prints register before scanf
	LDR r0, =debug_msg1
	BL printf
	MOV pc, lr

debug_registers_after_scanf:
	# this function prints register after scanf
	LDR r0, =debug_msg2
	BL printf
	MOV pc, lr

debug_registers_after_printf:
	# this function prints register after printf
	LDR r0, =debug_msg3
	BL printf
	MOV pc, lr

.data
	prompt1: .asciz "Enter your age: "
	format1: .asciz "%d"
	num1: .word 0
	output1: .asciz "You are %d years old\n"
	debug_msg1: .asciz "Before scanf: r0=%p, r1=%p\n"
	debug_msg2: .asciz "After scanf: r0=%p, r1=%p\n"
	debug_msg3: .asciz "After printf: r0=%p, r1=%p\n"
