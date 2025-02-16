#
# Program Name: PrintQuotedString.s
# Author: Zuriel Garcia
# Date: 2/13/2025
# Purpose: this program asks for a string and then prints it back quoted. 
#
.text
.global main
.extern exit
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt the user to enter a string
	LDR r0, =prompt1
	BL printf

	# debug printing registers before scanf
	LDR r2, =format1
	LDR r3, =string1
	BL debug_registers_before_scanf

	# read the user string
	LDR r0, =format1
	LDR r1, =string1
	BL scanf

	# debug printing registers after scanf

	LDR r2, =format1
	LDR r3, =string1
	BL debug_registers_after_scanf

	# print the user quoted string
	
	LDR r0, =output1
	LDR r1, =string1
	BL printf

	# debug printing registers after printf
	LDR r2, =output1
	LDR r3, =string1
	BL debug_registers_after_printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4

	# explicit exit
	LDR r0, =0
	BL exit

debug_registers_before_scanf:
	# this function prints register before scanf
	LDR r0, =debug_msg1
	BL printf
	BX lr

debug_registers_after_scanf:
	# this function prints register after scanf
	LDR r0, =debug_msg2
	BL printf
	BX lr

debug_registers_after_printf:
	# this function prints register after printf
	LDR r0, =debug_msg3
	BL printf
	BX lr


.data
	#%99[^\n] allows us to read characters until \n
	.align 4
	prompt1: .asciz "Enter your string: "
	format1: .asciz "%s"
	string1: .space 100
	output1: .asciz "\"%s\"\n"
	debug_msg1: .asciz "\nBefore scanf: r0=%p, r1=%p\n"
	debug_msg2: .asciz "\nAfter scanf: r0=%p, r1=%p\n"
	debug_msg3: .asciz "\nAfter printf: r0=%p, r1=%p\n"
