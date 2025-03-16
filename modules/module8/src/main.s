#
# Program Name: main.s
# Author: Zuriel Garcia
# Date: 3/16/2025
# Purpose: this program asks for an integer inches value and converts it to a rounded feet value. 
#
.text
.global main
.global CelsiusToFahrenheit
.global Miles2Kilometers
.global KilometersPerHour
.global InchesToFt
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt for hours and miles, then calcuate kilometers per hour
	LDR r0, =prompt_hours
	BL printf
	LDR r0, =formatString
	LDR r1, =hours
	BL scanf
	LDR r1, =hours
	LDR r1, [r1, #0]

	MOV r4, r1

	LDR r0, =prompt_miles
	BL printf
	LDR r0, =formatString
	LDR r1, =miles
	BL scanf

	LDR r1, =miles
	LDR r1, [r1, #0]
	MOV r0, r1

	BL KilometersPerHour
	MOV r1, r4
	BL __aeabi_idiv
	MOV r1, r0
	LDR r0, =output_kmh
	BL printf

	# prompt for celsius and convert to fahrenheit
	LDR r0, =prompt_celsius
	BL printf
	LDR r0, =formatString
	LDR r1, =celsius
	BL scanf
	LDR r0, =celsius
	LDR r0, [r0, #0]
	BL CelsiusToFahrenheit
	MOV r1, r0
	LDR r0, =output_fahrenheit
	BL printf

	# prompt for inches and convert to feet
	LDR r0, =prompt_inches
	BL printf
	LDR r0, =formatString
	LDR r1, =inches
	BL scanf
	LDR r0, =inches
	LDR r0, [r0, #0]
	BL InchesToFt
	MOV r1, r0
	LDR r0, =output_ft
	BL printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr
.data
	prompt_celsius: .asciz "Enter temperature in Celsius: "
	output_fahrenheit: .asciz "\nTemperature in Fahrenheit: %d\n"
	prompt_hours: .asciz "Enter total Hours: "
	prompt_inches: .asciz "Enter distance in Inches: "
	output_ft: .asciz "\nDistance in Feet is: %d\n"
	prompt_miles: .asciz "Enter Total Miles: "
	output_kmh: .asciz "\nTotal Kilometers per Hour: %d\n"
	miles: .word 0
	celsius: .word 0	
	hours: .word 0
	inches: .word 0
	formatString: .asciz "%d"
