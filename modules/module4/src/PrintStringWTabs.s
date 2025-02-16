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

	# debug printing registers before printf
	MOV r2, r0
	MOV r3, r1
	BL debug_registers_before_printf

	# print the output string
	LDR r0, =output1
	BL printf

	# debug printing registers after printf
	MOV r2, r0
	MOV r3, r1
	BL debug_registers_after_printf
	
	# pop the stack and return
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

debug_registers_before_printf:
	# this function prints register before printf
	LDR r0, =debug_msg1
	BL printf
	MOV pc, lr

debug_registers_after_printf:
	# this function prints register after printf
	LDR r0, =debug_msg2
	BL printf
	MOV pc, lr

.data
	output1: .asciz "Z\t76\tL\n"
	debug_msg1: .asciz "Before printf: r0=%p, r1=%p\n"
	debug_msg2: .asciz "After printf: r0=%p, r1=%p\n"
