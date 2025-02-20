#
# Program Name: CelsiusToFahrenheit.s
# Author: Zuriel Garcia
# Date: 2/18/2025
# Purpose: this program asks for a float temperature in celsius and converts to fahrenheit. 
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #8
	STR lr, [sp, #0]
	
	# prompt the user to enter an integer age
	LDR r0, =prompt1
	BL printf

	# read the use input as float
	LDR r0, =format1
	LDR r1, =celsius
	BL scanf

	# convert Celsius to Fahrenheit using floating-point arithmetic
	VLDR.F32 s0, celsius
	VMOV.F32 s1, #9.0
	VMUL.F32 s0, s0, s1
	VMOV.F32 s1, #5.0
	VDIV.F32 s0, s0, s1
	VMOV.F32 s1, #32.0
	VADD.F32 s0, s0, s1
	VSTR.F32 r0, fahrenheit

	# print the result
	LDR r0, =output1
	LDR r1, fahrenheit	
	BL printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #8
	BX lr

.data
	prompt1: .asciz "Enter your temperature in Celsius: "
	format1: .asciz "%f"
	celsius: .float 0.0
	fahrenheit: .float 0.0
	output1: .asciz "Your temperature is: %.2f F°\n"
