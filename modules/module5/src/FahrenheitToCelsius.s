#
# Program Name: FahrenheitToCelsius.s
# Author: Zuriel Garcia
# Date: 2/20/2025
# Purpose: this program asks for an integer fahrenheit value and converts it to a rounded celsius. 
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt the user to enter an integer age
	LDR r0, =prompt
	BL printf
	LDR r0, =formatString
	LDR r1, =fahrenheit
	BL scanf

	LDR r0, =fahrenheit
	LDR r0, [r0, #0]	
	MOV r1, #5
	MOV r2, #9
	MOV r3, #32
	BL __aeabi_idiv
	MOV r4, r0 // move hours to r4 save them	

	#
	LDR r1, =fahrenheit
	LDR r1, =[r1, #0]
	SUB r1, r1, r0

	#
	LDR r2, r1
	MOV r1, r4
	LDR r0, =output	
	BL printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr
.data
	output: .asciz "\nTemperature in C°is %d\n"
	prompt: .asciz "Enter temperature in F° "
	fahrenheit: .word 0
	formatString: .asciz "%d"
