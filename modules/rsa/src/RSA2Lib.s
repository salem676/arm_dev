.arch armv6
.arm
.fpu vfp
.extern scanf
.extern printf
.extern __aeabi_idiv
.extern __aeabi_idivmod
.extern getchar

.global clear_input
.global clear_loop
.global is_prime
.global prime_loop
.global prime_ret
.global not_prime_ret
.global gcd
.global gcd_loop
.global gcd_done
.global mod_pow
.global mod_pow_loop
.global mod_pow_skip
.global mod_pow_done
.global encrypt_message
.global encrypt_loop
.global encrypt_done
.global decrypt_message
.global decrypt_loop
.global decrypt_done

.data
buffer: .space 100
encrypted: .space 400
e_value: .word 0
n_value: .word 0
format_int: .asciz "%d "
newline: .asciz "\n"
d_value: .word 0
format_char: .asciz "%s"

.text
.align 2
@ Function to clear input buffer
clear_input:
    push {lr}
clear_loop:
    bl getchar
    cmp r0, #10
    bne clear_loop
    pop {pc}
@ Function to check if a number is prime
is_prime:
    push {r4-r7, lr}
    mov r4, r0          @ Save input number
    cmp r4, #2
    blt not_prime_ret
    beq prime_ret
    tst r4, #1          @ Check if even
    beq not_prime_ret
    mov r5, #3          @ Start checking from 3
prime_loop:
    mul r6, r5, r5
    cmp r6, r4
    bgt prime_ret
    mov r0, r4
    mov r1, r5
    bl __aeabi_idivmod
    cmp r1, #0
    beq not_prime_ret
    add r5, r5, #2
    b prime_loop
prime_ret:
    mov r0, #1
    pop {r4-r7, pc}
not_prime_ret:
    mov r0, #0
    pop {r4-r7, pc}
@ Function to calculate GCD
gcd:
    push {r4-r5, lr}
    mov r4, r0
    mov r5, r1
gcd_loop:
    cmp r5, #0
    beq gcd_done
    mov r0, r4
    mov r1, r5
    bl __aeabi_idivmod
    mov r4, r5
    mov r5, r1
    b gcd_loop
gcd_done:
    mov r0, r4
    pop {r4-r5, pc}
@ Function to calculate modular exponentiation
mod_pow:
    push {r4-r8, lr}
    mov r4, r0      @ base
    mov r5, r1      @ exponent
    mov r6, r2      @ modulus
    mov r7, #1      @ result
mod_pow_loop:
    cmp r5, #0
    beq mod_pow_done
    tst r5, #1
    beq mod_pow_skip
    mul r8, r7, r4
    mov r0, r8
    mov r1, r6
    bl __aeabi_idivmod
    mov r7, r1
mod_pow_skip:
    mul r8, r4, r4
    mov r0, r8
    mov r1, r6
    bl __aeabi_idivmod
    mov r4, r1
    lsr r5, r5, #1
    b mod_pow_loop
mod_pow_done:
    mov r0, r7
    pop {r4-r8, pc}
@ Main encryption function
encrypt_message:
    push {r4-r9, lr}
    ldr r4, =buffer
    ldr r5, =encrypted
    mov r6, #0
encrypt_loop:
    ldrb r0, [r4, r6]
    cmp r0, #0
    beq encrypt_done
    ldr r1, =e_value
    ldr r1, [r1]
    ldr r2, =n_value
    ldr r2, [r2]
    bl mod_pow
    str r0, [r5, r6, lsl #2]
    mov r1, r0
    ldr r0, =format_int
    bl printf
    add r6, r6, #1
    b encrypt_loop
encrypt_done:
    str r6, [r5, r6, lsl #2]    @ Store length
    ldr r0, =newline
    bl printf
    pop {r4-r9, pc}
@ Main decryption function
decrypt_message:
    push {r4-r9, lr}
    ldr r4, =encrypted
    mov r6, #0
decrypt_loop:
    ldr r0, [r4, r6, lsl #2]
    ldr r7, [r4, r6, lsl #2]
    cmp r7, #0
    beq decrypt_done
    mov r0, r7
    ldr r1, =d_value
    ldr r1, [r1]
    ldr r2, =n_value
    ldr r2, [r2]
    bl mod_pow
    mov r1, r0
    ldr r0, =format_char
    bl printf
    add r6, r6, #1
    b decrypt_loop
decrypt_done:
    ldr r0, =newline
    bl printf
    pop {r4-r9, pc}
