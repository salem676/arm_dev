#
# Program Name: CelsiusToFahrenheit.s
# Author: Zuriel Garcia
# Date: 2/20/2025
# Purpose: this program asks for an integer celsius value and converts it to a rounded fahrenheit. 
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt the user to enter an integer temperature
	LDR r0, =prompt
	BL printf
	LDR r0, =formatString
	LDR r1, =fahrenheit
	BL scanf

	LDR r0, =fahrenheit
	LDR r0, [r0, #0]
	MOV r1, #9	
	MUL r0, r0, r1
	MOV r1, #5
	BL __aeabi_idiv
	MOV r1, #32
	ADD r0, r0, r1

	#
	MOV r1, r0
	LDR r0, =output	
	BL printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr
.data
	output: .asciz "\nTemperature in Fahrenheit is: %d\n"
	prompt: .asciz "Enter temperature is Celsius: "
	fahrenheit: .word 0
	formatString: .asciz "%d"
