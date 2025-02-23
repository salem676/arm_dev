#
# Program Name: FahrenheitToCelsius.s
# Author: Zuriel Garcia
# Date: 2/22/2025
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
	LDR r1, =celsius
	BL scanf

	LDR r0, =celsius
	LDR r0, [r0, #0]
	MOV r1, #32
	SUB r0, r0, r1
	MOV r1, #5
	MUL r0, r0, r1
	MOV r1, #9
	BL __aeabi_idiv

	#
	MOV r1, r0
	LDR r0, =output	
	BL printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr
.data
	output: .asciz "\nTemperature in Celsius is: %d\n"
	prompt: .asciz "Enter temperature is Fahrenheit: "
	celsius: .word 0
	formatString: .asciz "%d"
