#
# Program Name: PrimeChecker.s
# Author: Zuriel Garcia
# Date: 4/5/2025
# Purpose: this program prompts for a number and determines if that number is prime. -1 ends program and handles 0,1,2 or other negative
# as errors. 
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
loop:	
	# prompt the user to enter an input value
	LDR r0, =prompt1
	BL printf

	# read the user's number
	LDR r0, =format1
	LDR r1, =input1
	BL scanf

	# load input into r1
	LDR r0, =input1
	LDR r1, [r0, #0]

	# check for -1 to exit
	CMP r1, #-1
	BEQ exit
	
	# check if input is less than 3
	CMP r1, #3
	BLT invalid_input

	# initialize r2 = 2 divisor, r7 = 1, is_prime = true
	MOV r2, #2
	MOV r7, #1
	
	# saving r1
	MOV r4, r1
	B check_loop

check_loop:
	# calculate r5 = r2 * r2, then if r5 > n, done checking
	MUL r5, r2, r2
	CMP r5, r4
	BGT done_check

	# checking divisibility
	MOV r0, r4
	MOV r1, r2
	BL __aeabi_idiv
	
	# calculate remainder
	MOV r3, r0
	MUL r3, r3, r1
	SUB r2, r4, r3	

	# check remainder (its in r1)
	CMP r2, #0
	BEQ not_prime

	# return divisor to r2
	MOV r2, r1	

	# increment divisor
	ADD r2, r2, #1
	B check_loop

done_check:
	CMP r7, #1
	BEQ is_prime
	B not_prime

is_prime:
	# prints prime message
	LDR r0, =prime_msg
	LDR r1, =input1
	LDR r1, [r1, #0]
	BL printf
	B loop

not_prime:
	# prints not prime message
	MOV r7, #0
	LDR r0, =not_prime_msg
	LDR r1, =input1
	LDR r1, [r1, #0]
	BL printf
	B loop

invalid_input:
	# prints error message
	LDR r0, =error_msg
	BL printf
	B loop
exit:
	# restore stack and return
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr


.data
	prompt1: .asciz "Enter a number (-1 to quit): "
	format1: .asciz "%d"
	input1: .word 0
	prime_msg: .asciz "Number %d is prime\n"
	error_msg: .asciz "Invalid input. Please enter a number >= 3 or -1 to quit.\n"
	not_prime_msg: .asciz "Number %d is not prime\n"
