.text
.global main
main:
	# push the stack record
	SUB sp, sp, #4
	# store return address on stack
	STR lr, [sp, #0]

	# load address of string into r0
	LDR r1, =message
	# call printf("%p", lr)
	BL printf

	# pop the stack record	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	
	# return to caller
	MOV pc, lr

.data
	message: .asciz "Pointer Address> %p\n"
