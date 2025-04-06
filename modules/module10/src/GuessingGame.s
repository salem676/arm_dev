#
# Program Name: GuessingGame.s
# Author: Zuriel Garcia
# Date: 4/5/2025
# Purpose: this program prompts for a number to be the maximum and then prompts the user to make a guess of the number, binary search will be used
#
.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]

	LDR r0, =prompt_max
	BL printf

	LDR r0, =format_int
	LDR r1, =max_value
	BL scanf

	LDR r0, =max_value
	LDR r4, [r0, #0]
	MOV r3, #1
	B guess_loop

guess_loop:
	# compute (max_value+min)/2, save in r1
	ADD r0, r3, r4
	MOV r1, #2
	BL __aeabi_idiv
	MOV r1, r0

	# saving middle value in r7
	MOV r7, r1	

	LDR r0, =guess_msg
	BL printf
	
	LDR r0, =response_prompt
	BL printf
	
	LDR r0, =format_char
	LDR r1, =response
	BL scanf

	LDR r0, =response
	LDRB r1, [r0, #0]

	CMP r1, #'c'
	BEQ correct

	CMP r1, #'l'
	BEQ too_low

	CMP r1, #'h'
	BEQ too_high

	# invalid response, repeat
	B guess_loop

too_low:
	# compute (mid + 1)/2
	MOV r3, r7
	ADD r4, r4, r7
	B guess_loop

too_high:
	# compute (max + mid)/2
	MOV r3, #1
	ADD r4, r7, r3
	B guess_loop

correct:
	# prints success message
	LDR r0, =success_msg
	MOV r1, r2
	BL printf
	B exit
exit:
	# restore stack and return
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr


.data
	prompt_max: .asciz "Choose a maximum number: "
	format_int: .asciz "%d"
	format_char: .asciz " %c"
	max_value: .word 0
	response: .byte 0
	guess_msg: .asciz "Is your number %d? (h = too high, l = too low, c = correct):"
	response_prompt: .asciz ""
	success_msg: .asciz "Yay! I guessed your number: %d\n"
