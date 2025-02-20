.text
.global main
main:
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	LDR r0, =prompt
	BL printf
	LDR r0, =formatString
	LDR r1, =totalMinutes
	BL scanf

	LDR r0, =totalMinutes
	LDR r0, [r0]
	MOV r1, #60
	BL __aeabi_idiv
	MOV r4, r0 // move hours to r4 to save them
	
	MOV r1, #60
	MOV r0, r4
	MUL r0, r1, r4

	LDR r1, =totalMinutes
	LDR r1, [r1]
	SUB r1, r1, r0

	MOV r2, r1
	MOV r1, r4
	LDR r0, =output
	BL printf

	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr
.data
	output: .asciz "\nHours is %d and minutes is %d\n"
	prompt: .asciz "Enter total minutes: "
	totalMinutes: .word 0
	formatString: .asciz "%d"
