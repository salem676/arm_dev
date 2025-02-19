.text
.global main
main:
	sub sp, sp, #4
	str lr, [sp, #0]

	ldr r4,=num1
	ldr r0, [r4, #0]
	
	mov r0, #7
	str r0, [r4, #0]

	ldr lr, [sp, #0]
	add sp, sp, #4
	mov pc, lr
.data
	num1: .word 25
