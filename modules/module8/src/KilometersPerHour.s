#
# Program Name: KilometersPerHour.s
# Author: Zuriel Garcia
# Date: 3/16/2025
# Purpose: this program asks for integer hours and integer miles, printing kilometers per hour
# , it uses the Miles2Kilometer function for conversion. 
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# prompt the user to enter an integer hours number
	LDR r0, =prompt1
	BL printf
	LDR r0, =formatString
	LDR r1, =totalHours
	BL scanf

	# read the user integer hours
	LDR r1, =totalHours
	LDR r1, [r1, #0]

	MOV r4, r1

	# prompt the user to enter an integer miles number	
	LDR r0, =prompt2
	BL printf
	LDR r0, =formatString
	LDR r1, =totalMiles
	BL scanf

	# read the user integer miles
	LDR r1,  =totalMiles
	LDR r1, [r1, #0]

	#
	BL Miles2Kilometer
	MOV r1, r4
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
	output: .asciz "\nTotal Kilometers Per Hour is %d\n"
	prompt1: .asciz "Enter total Hours: "
	prompt2: .asciz "Enter total Miles: "
	totalHours: .word 0
	totalMiles: .word 0
	formatString: .asciz "%d"
