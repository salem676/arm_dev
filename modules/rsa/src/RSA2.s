.arch armv6
.arm
.fpu vfp
.global main
.extern scanf
.extern printf
.extern __aeabi_idiv
.extern __aeabi_idivmod
.extern getchar
.data
@ Menu strings
menu_prompt: .asciz "\nRSA Encryption/Decryption Menu:\n1. Enter Prime Numbers\n2. Encrypt Message\n3. Decrypt Message\n4. Exit\nEnter your choice (1-4): "
menu_format: .asciz "%d"
invalid_choice: .asciz "\nInvalid choice. Please enter 1-4.\n"
@ Prime number related strings
p_prompt: .asciz "Please Enter a Prime Number less than 50 For Variable P, 0 to exit: "
q_prompt: .asciz "For Variable Q, Please Enter a Prime Number less than 50, 0 to exit: "
prime_invalid: .asciz "Selected Number is not valid. Try Again. \n"
output_zero: .asciz "Program End.\n"
output_both_prime: .asciz "The number %d and %d are prime. \n"
output_modulo: .asciz "The modulo (n) is: %d\n"
output_totient: .asciz "The totient (phi(n)) is: %d\n"
output_d: .asciz "The d value is : %d \n"
prompte: .asciz "\nEnter your public key exponent e: "
format: .asciz "%d"
error_msg: .asciz "\nSelected e does not meet criteria.\n"
debug_msg: .asciz "GCD result: %d\n"
debug_msg2: .asciz "Before modulo: a=%d, b=%d\n"
output_msg: .asciz "Valid e: %d\n"
number_format: .asciz "%d"
@ Encryption/Decryption strings
msg_prompt: .asciz "Enter message: "
msg_encrypted: .asciz "\nEncrypted: "
msg_decrypted: .asciz "\nDecrypted: "
format_str: .asciz "%s"
@ Variables
input_number: .word 0
p_value: .word 0
q_value: .word 0
n_value: .word 0
totient_value: .word 0
e_value: .word 0
d_value: .word 0
buffer: .space 100
encrypted: .space 400
temp: .word 0
.text
.align 2

@ Main program
main:
    push {r4-r10, lr}
menu_loop:
    ldr r0, =menu_prompt
    bl printf
    ldr r0, =menu_format
    ldr r1, =temp
    bl scanf
    bl clear_input
    ldr r4, =temp
    ldr r4, [r4]
    cmp r4, #1
    beq do_prime_numbers
    cmp r4, #2
    beq do_encryption
    cmp r4, #3
    beq do_decryption
    cmp r4, #4
    beq exit_program
    ldr r0, =invalid_choice
    bl printf
    b menu_loop
do_prime_numbers:
    @ Get and validate p
get_p:
    ldr r0, =p_prompt
    bl printf
    ldr r0, =number_format
    ldr r1, =p_value
    bl scanf
    bl clear_input
    
    ldr r0, =p_value
    ldr r0, [r0]
    bl is_prime
    cmp r0, #0
    beq invalid_p
    @ Get and validate q
get_q:
    ldr r0, =q_prompt
    bl printf
    ldr r0, =number_format
    ldr r1, =q_value
    bl scanf
    bl clear_input
    ldr r0, =q_value
    ldr r0, [r0]
    bl is_prime
    cmp r0, #0
    beq invalid_q
    @ Calculate n and totient
    ldr r0, =p_value
    ldr r0, [r0]
    ldr r1, =q_value
    ldr r1, [r1]
    mul r2, r0, r1
    ldr r3, =n_value
    str r2, [r3]
    sub r0, r0, #1
    sub r1, r1, #1
    mul r2, r0, r1
    ldr r3, =totient_value
    str r2, [r3]
    @ Print results
    ldr r0, =output_both_prime
    ldr r1, =p_value
    ldr r1, [r1]
    ldr r2, =q_value
    ldr r2, [r2]
    bl printf
    ldr r0, =output_modulo
    ldr r1, =n_value
    ldr r1, [r1]
    bl printf
    ldr r0, =output_totient
    ldr r1, =totient_value
    ldr r1, [r1]
    bl printf
    @ Get and validate e
get_e:
    ldr r0, =prompte
    bl printf
    ldr r0, =number_format
    ldr r1, =e_value
    bl scanf
    bl clear_input
    ldr r0, =e_value
    ldr r0, [r0]
    ldr r1, =totient_value
    ldr r1, [r1]
    bl gcd
    cmp r0, #1
    bne invalid_e
    @ Calculate d
    ldr r4, =e_value
    ldr r4, [r4]
    ldr r5, =totient_value
    ldr r5, [r5]
    mov r6, #1
find_d:
    mul r7, r6, r5
    add r7, r7, #1
    mov r0, r7
    mov r1, r4
    bl __aeabi_idivmod
    cmp r1, #0
    beq found_d
    add r6, r6, #1
    b find_d
found_d:
    mov r0, r7
    mov r1, r4
    bl __aeabi_idiv
    ldr r1, =d_value
    str r0, [r1]
    ldr r0, =output_d
    mov r1, r0
    bl printf
    b menu_loop
invalid_p:
    ldr r0, =prime_invalid
    bl printf
    b get_p
invalid_q:
    ldr r0, =prime_invalid
    bl printf
    b get_q
invalid_e:
    ldr r0, =error_msg
    bl printf
    b get_e
do_encryption:
    ldr r0, =msg_prompt
    bl printf
    
    @ Read message
    ldr r4, =buffer
    mov r5, #0
read_msg:
    bl getchar
    cmp r0, #10
    beq read_done
    strb r0, [r4, r5]
    add r5, r5, #1
    b read_msg
read_done:
    mov r0, #0
    strb r0, [r4, r5]
    ldr r0, =msg_encrypted
    bl printf
    bl encrypt_message
    b menu_loop
do_decryption:
    ldr r0, =msg_decrypted
    bl printf
    bl decrypt_message
    b menu_loop
exit_program:
    ldr r0, =output_zero
    bl printf
    mov r0, #0
    pop {r4-r10, pc}
