.global main
.extern scanf
.extern printf
.extern __aeabi_idiv
.extern __aeabi_idivmod
.data
        prompte: .asciz "\nEnter your public key exponent e: "
        format: .asciz "%d"
        error_msg: .asciz "\nSelected e does not meet criteria: "
        e: .word 0
        debug_msg: .asciz "GCD result: %d\n"
        debug_msg2: .asciz "Before modulo: a=%d, b=%d\n"
        output_msg: .asciz "Valid e: %d\n"
.text

.global main
.extern scanf
.extern printf
.extern __aeabi_idiv
.extern __aeabi_idivmod
 
.data
number_format: .asciz " %d"
 
@ Part 2  
@ 2a - Displays a prompts to input two positive integers p and q with a limit of 50 for simplicity 
@ 2b - Checks if both integers are prime
@ 2c - Calculates the modulus n for the public and private keys: n = p * q
@ 2d - Calculate the totient: Φ(n) = (p – 1) (q – 1)
 
 
@@ Inputs, Outputs, and Variables
p_prompt: .asciz "Please Enter a Prime Number less than 50 For Variable P, 0 to end the Program: "
q_prompt: .asciz "For Variable Q, Please Enter a Prime Number less than 50, 0 to end the Program: "
 
prime_invalid: .asciz "Selected Number is not valid. Try Again. \n"
output_zero: .asciz "Program End." 
output_both_prime: .asciz "The number %d and %d are prime. \n"
 
output_modulo: .asciz "The modulo (n) is: %d\n"
output_totient: .asciz "The totient (phi(n)) is: %d\n"
output_d: .asciz "The d value is : %d\n"
 
input_number: .word 0
p_value: .word 0
q_value: .word 0
modulo_value: .word 0
totient_value: .word 0
d_value: .word 0
 
.text
.align 2
 
create_values:
 
    SUB sp, sp, #24      
    STR lr, [sp, #20]
    STR r4, [sp, #16]
    STR r5, [sp, #12]
    STR r6, [sp, #8]
    STR r7, [sp, #4]
    STR r8, [sp, #0]
    mov r6, #0
 
@ prompts and scans for p value from user, loads into r2 to calc as the prime check value
p_prompt_loop:
 
    ldr r0, =p_prompt
    bl printf
 
    ldr r0, =number_format
    ldr r1, =input_number 
    bl scanf
    ldr r2, =input_number 
    ldr r2, [r2]
	mov r7, r2
 
@ User Exit Selection if Zero 
    cmp r2, #0
    beq is_zero
 
@ Pre-Prime Check, remove negatives and 1, 2 is known prime, no need to calc
    cmp r2, #2
    blt not_prime
    beq valid_prime
    cmp r2, #3
    beq valid_prime
@ removes check value if even since values > 2 cannot be prime 
    tst r2, #1
    beq not_prime
@ ------------------------------------	
  @ The prime check is done through a looped mod division from 3 to the square root of the target value as a ceiling for the loop 
  @ as any non-prime number can only be a factored into two integers that are both less than the squate root of the number  
  @ because we are only working with integers, the calculated square root is rounded down, not exact 
@ -----------------------------------

@ initial values start at 3 as divisor r4, move prime check value r2 into r0 
    mov r4, #3
    mov r0, r2
 
@ Calc to calculate the square root, after  
    bl sqrt_calc
    mov r5, r0
 
 
@ compare value, exist r4 is greater than r5 
prime_check_loop:
    cmp r4, r5
    bgt valid_prime

@mod division to check if prime, value is not prime is there is a mod of 0   
    mov r0, r2
    mov r1, r4
    bl __aeabi_idivmod
    cmp r1, #0
    beq not_prime
@ add 2 to the odd divisor r4 to check next odd value 
    add r4, r4, #2
    b prime_check_loop
 
 
@ Square Root Calculation is done through subtraction of successive odd number 
sqrt_calc:
    SUB sp, sp, #12      
    STR lr, [sp, #8]
    STR r4, [sp, #4]
    STR r5, [sp, #0]
@ r1 is the target value, r2 is the sucessive odd numbers starting at 1  
    mov r1, r0
    mov r0, #0
    mov r2, #1
 
@ The target number is subtracted by 1, 3, 5, ... n+2 until r0 is less than zero   
sqrt_loop:
    subs r1, r1, r2
    addlt r0, r0, #1
    blt sqrt_done
    add r2, r2, #2
    add r0, r0, #1
    b sqrt_loop
 
sqrt_done:
    LDR lr, [sp, #8]
    LDR r4, [sp, #4]
    LDR r5, [sp, #0]
    ADD sp, sp, #12
    MOV pc, lr
 
@ if we've correctly found q, this skips to the results 
valid_prime:
    cmp r6, #1
    beq q_valid_prime
 
@ stores p in r7 for later, moves to q prompt, it set r6 to 1 so loop for p value isn't allowed 
    mov r6, #1
    b q_prompt_loop
 
 
@ Q loop starts here, prompting for q and running through the loop again  
q_prompt_loop:
    ldr r0, =q_prompt
    bl printf
 
    ldr r0, =number_format
    ldr r1, =input_number
    bl scanf
 
    ldr r2, =input_number 
    ldr r2, [r2]
    b valid_number_check
 
 
@ these are the output messages
@ first check is if the value is a number between 2 and 50, zero here for an easy exis 
valid_number_check:
    cmp r2, #2
    blt not_prime
    cmp r2, #50
    bgt not_prime
    cmp r2, #0
    beq is_zero
    b prime_check_loop
 
not_prime:
    ldr r0, =prime_invalid
    bl printf
    cmp r6, #0
    beq p_prompt_loop
    b q_prompt_loop
 
is_zero:
    ldr r0, =output_zero
    bl printf
    b end_create_values
 
 
@ if prime is correct for both, outputs p and q and exits the create value function 
q_valid_prime:
    ldr r0, =p_value    @ Store p
    str r7, [r0]
    ldr r0, =q_value    @ Store q
    str r2, [r0]
    ldr r0, =output_both_prime
    mov r1, r7
    mov r2, r2
    bl printf

 
end_create_values:
    LDR lr, [sp, #20]
    LDR r4, [sp, #16]
    LDR r5, [sp, #12]
    LDR r6, [sp, #8]
    LDR r7, [sp, #4]
    LDR r8, [sp, #0]
    ADD sp, sp, #24
    MOV pc, lr
modulo:
    SUB sp, sp, #8
    STR lr, [sp, #4]
    STR r4, [sp, #0]
 
    ldr r4, =p_value
    ldr r0, [r4]
    ldr r4, =q_value
    ldr r1, [r4]
 
    mul r1, r0, r1
 
    ldr r0, =output_modulo
    bl printf
 
    ldr r2, =modulo_value
    str r6, [r2]
 
    LDR lr, [sp, #4]
    LDR r4, [sp, #0]
    ADD sp, sp, #8
    bx lr
 
totient:
    SUB sp, sp, #8 
    STR lr, [sp, #4]
    STR r4, [sp, #0]
    ldr r4, =p_value
    ldr r0, [r4]
    sub r0, r0, #1
    ldr r4, =q_value
    ldr r1, [r4]
    sub r1, r1, #1
    mul r1, r0, r1
    ldr r0, =totient_value
    ldr r0, =output_totient
	mov r5, r1
    bl printf
    LDR lr, [sp, #4]
    LDR r4, [sp, #0]
    ADD sp, sp, #8
    MOV pc, lr

find_e:
    SUB sp, sp, #4
    STR lr, [sp]
find_e_loop:
    ldr r0, =prompte
    bl printf
    ldr r0, =format
    ldr r1, =e
    bl scanf
    ldr r1, =e
    ldr r1, [r1]
    mov r4, r1
    cmp r1, #1
    ble invalid_e
    cmp r1, r5
    bge invalid_e
    mov r2, r5
    bl gcd
    cmp r1, #1
    bne invalid_e
    b find_e_success
invalid_e:
    ldr r0, =error_msg
    bl printf
    b find_e_loop
find_e_success:
    mov r1, r4
    ldr r0, =output_msg
    bl printf
    ldr lr, [sp]
    add sp, sp, #4
    mov pc, lr
cprivexp:
	SUB sp, sp, #8
	STR lr, [sp, #0]
	STR r4, [sp, #4]
	
	# x is 1
	MOV r7, #1
	
	find_x:
	# r3 is x * phi
	MUL r3, r7, r5
	# r3 is 1 + x * phi
	ADD r3, r3, #1

	MOV r0, r3
	# r1 is e
	MOV r1, r4
	# r0 is a%b
	BL modulo2

	# (1 + x* phi)%e == 0?
	CMP r0, #0
	BEQ found_d
	
	# x++
	ADD r7, r7, #1
	B find_x
	
	found_d:
	
	MOV r0, r3
	MOV r1, r4
	BL __aeabi_idiv

	MOV r1, r0
	LDR r0, =output_d
	BL printf
	LDR r1, =d_value
	
	LDR r4, [sp, #4]
	LDR lr, [sp, #0]
	ADD sp, sp, #8
	MOV pc, lr
main:
        SUB sp, sp, #4
        STR lr, [sp, #0]
		bl create_values
		bl modulo
		bl totient	

		bl find_e
		bl cprivexp
        LDR lr, [sp, #0]
        ADD sp, sp, #4
        MOV pc, lr
#END MAIN
gcd:
        SUB sp, sp, #4
        STR lr, [sp, #0]
gcd_loop:
        # while (b != 0)
        CMP r2, #0
        BEQ gcd_end
        MOV r0, r1
        MOV r1, r2
        BL modulo2
        MOV r1, r2
        MOV r2, r0
        B gcd_loop
gcd_end:
        LDR lr, [sp, #0]
        ADD sp, sp, #4
        MOV pc, lr
modulo2:
        SUB sp, sp, #4
        STR lr, [sp, #0]
        BL __aeabi_idivmod
        MOV r0, r1
        LDR lr, [sp, #0]
        ADD sp, sp, #4
        MOV pc, lr
