.global	main
.extern cpubexp
.extern gcd

main:
	SUB sp, sp, #8
	STR lr, [sp, #0]
	
	MOV r0, #84
	BL cpubexp
	
	LDR r1, =result_e
	STR r0, [r1]
	
	LDR lr, [sp, #0]
	ADD sp, sp, #8
	MOV pc, lr

.data
result_e: .word 0
