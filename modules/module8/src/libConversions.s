#
# Program Name: libConversions.s
# Author: Zuriel Garcia
# Date: 3/16/2025
# Purpose: this program asks for an integer inches value and converts it to a rounded feet value. 
#

.global CelsiusToFahrenheit
.global Miles2Kilometers
.global InchesToFt
.global KilometersPerHour

.text

# Function: CelsiusToFahrenheit
# Converts celsius degrees to fahrenehit, rounded
# Parameters: r0 celsius degrees in integer
# Returns: prints fahrenheit degrees
CelsiusToFahrenheit:

	SUB sp, sp, #4
	STR lr, [sp, #0]	

	MOV r1, #9
	MUL r0, r0, r1
	MOV r1, #5
	BL __aeabi_idiv
	MOV r1, #32
	ADD r0, r0, r1
	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

# Functions: Miles2Kilometers
# Converts miles to kilometer, rounded
# Parameters: r0 miles in integer
# Returns: r0 kilometer in integer
Miles2Kilometers:

	SUB sp, sp, #4
	STR lr, [sp, #0]	

	MOV r1, #161
	MUL r0, r0, r1
	MOV r1, #100
	BL __aeabi_idiv

	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

# Function: InchesToFt
# Converts inches to rounded feet
# Parameters: r0 inches in integer
# Returns: prints feet
InchesToFt:

	SUB sp, sp, #4
	STR lr, [sp, #0]

	MOV r1, #13
	LSL r1, r1, #6
	ADD r1, r1, #1
	MUL r0, r0, r1

	MOV r1, #39
	LSL r1, r1, #4
	ADD r1, r1, #1
	LSL r1, r1, #4
	BL __aeabi_idiv

	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr
	

# Function: KilometersPerHour
# Converts  hours and miles to kilometers per hour
# Parameters: r0 hours and miles
# Returns: prints kilometers per hour
KilometersPerHour:

	SUB sp, sp, #4
	STR lr, [sp, #0]	

	BL Miles2Kilometers

	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

