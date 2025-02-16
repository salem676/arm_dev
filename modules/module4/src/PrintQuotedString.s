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

	# debug printing registers before scanf
	MOV r2, r0
	MOV r3, r1
	BL debug_registers_before_scanf

	# read the user string
	LDR r0, =format1
	LDR r1, =string1
	BL scanf

	# debug printing registers after scanf

	MOV r2, r0
	MOV r3, r1
	BL debug_registers_after_scanf

	# print the user quoted string
	
	LDR r0, =output1
	LDR r1, =string1
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
	LDR r0, debug_msg2
	BL printf
	MOV pc, lr

debug_registers_after_printf
	# this function prints register after printf
	LDR r0, debug_msg3
	BL printf
	MOV pc, lr


.data
	#%99[^\n] allows us to read characters until \n
	prompt1: .asciz "Enter your string: "
	format1: .asciz "%99[^\n]"
	string1: .space 100
	output1: .asciz "\"%s\"\n"
	debug_msg1: .asciz "Before scanf: r0=%p, r1=%p\n"
	debug_msg2: .asciz "After scanf: r0=%p, r1=%p\n"
	debug_msg3: .asciz "After printf: r0=%p, r1=%p\n"
