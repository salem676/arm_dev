.data
    @ Menu and Messages
    title:      .asciz "\n=== RSA Encryption Program ===\n"
    menu:       .asciz "\n1. Generate Keys\n2. Encrypt Message\n3. Decrypt Message\n4. Exit\nChoice: "
    prompt_p:   .asciz "Enter prime p (<50): "
    prompt_q:   .asciz "Enter prime q (<50): "
    prompt_msg: .asciz "Enter message to encrypt: "
    error_msg:  .asciz "\nError: Please enter a valid prime number\n"
    
    @ Output formats
    key_fmt:    .asciz "\nPublic Key (e,n): (%d,%d)\nPrivate Key (d,n): (%d,%d)\n"
    ascii_fmt:  .asciz "ASCII: %d\n"
    enc_fmt:    .asciz "Encrypted: %d\n"
    dec_fmt:    .asciz "Decrypted: %c"
    newline:    .asciz "\n"
    
    @ File names and modes
    enc_file:   .asciz "encrypted.txt"
    dec_file:   .asciz "decrypted.txt"
    write_mode: .asciz "w"
    read_mode:  .asciz "r"
    
    @ Input formats
    scanf_fmt:  .asciz "%d"
    char_fmt:   .asciz "%c"
    str_fmt:    .asciz "%s"
    
    @ Buffers
    .align 4
    message:    .space 1024
    buffer:     .space 1024
    
    @ Variables to store keys
    .align 4
    public_key: .word 0   @ e
    private_key:.word 0   @ d
    modulus:    .word 0   @ n
.text
.global main
.extern printf
.extern scanf
.extern fopen
.extern fclose
.extern fprintf
.extern fscanf
.extern getchar
main:
    PUSH {r4-r11, lr}
menu_loop:
    LDR r0, =title
    BL printf
    LDR r0, =menu
    BL printf
    
    SUB sp, sp, #4
    LDR r0, =scanf_fmt
    MOV r1, sp
    BL scanf
    LDR r4, [sp]
    ADD sp, sp, #4
    
    @ Clear input buffer
    BL getchar
    
    CMP r4, #1
    BEQ generate_keys
    CMP r4, #2
    BEQ encrypt_message
    CMP r4, #3
    BEQ decrypt_message
    CMP r4, #4
    BEQ exit_program
    B menu_loop
generate_keys:
    @ Get prime p
    LDR r0, =prompt_p
    BL printf
    
    SUB sp, sp, #4
    LDR r0, =scanf_fmt
    MOV r1, sp
    BL scanf
    LDR r4, [sp]    @ r4 = p
    ADD sp, sp, #4
    
    MOV r0, r4
    BL is_prime
    CMP r0, #0
    BEQ prime_error
    
    @ Get prime q
    LDR r0, =prompt_q
    BL printf
    
    SUB sp, sp, #4
    LDR r0, =scanf_fmt
    MOV r1, sp
    BL scanf
    LDR r5, [sp]    @ r5 = q
    ADD sp, sp, #4
    
    MOV r0, r5
    BL is_prime
    CMP r0, #0
    BEQ prime_error
    
    @ Calculate n = p * q
    MOV r0, r4
    MOV r1, r5
    MUL r6, r0, r1   @ r6 = n
    
    @ Calculate totient = (p-1) * (q-1)
    SUB r0, r4, #1
    SUB r1, r5, #1
    MUL r7, r0, r1   @ r7 = totient
    
    @ Find public key e
    MOV r0, r7
    BL find_e
    MOV r8, r0       @ r8 = e
    
    @ Calculate private key d
    MOV r0, r8
    MOV r1, r7
    BL mod_inverse
    MOV r9, r0       @ r9 = d
    
    @ Store keys
    LDR r0, =public_key
    STR r8, [r0]
    LDR r0, =private_key
    STR r9, [r0]
    LDR r0, =modulus
    STR r6, [r0]
    
    @ Display keys
    LDR r0, =key_fmt
    MOV r1, r8
    MOV r2, r6
    MOV r3, r9
    PUSH {r6}
    BL printf
    ADD sp, sp, #4
    
    B menu_loop
encrypt_message:
    @ Get message
    LDR r0, =prompt_msg
    BL printf
    
    @ Clear input buffer
    BL getchar
    
    @ Read message
    LDR r0, =message
    MOV r1, #1024
    BL gets
    
    @ Open output file
    LDR r0, =enc_file
    LDR r1, =write_mode
    BL fopen
    MOV r4, r0       @ r4 = file handle
    
    @ Load keys
    LDR r5, =public_key
    LDR r5, [r5]     @ r5 = e
    LDR r6, =modulus
    LDR r6, [r6]     @ r6 = n
    
    @ Process message
    LDR r7, =message
encrypt_loop:
    LDRB r0, [r7], #1
    CMP r0, #0
    BEQ encrypt_done
    
    @ Show ASCII value
    PUSH {r0-r7}
    LDR r0, =ascii_fmt
    MOV r1, r0
    BL printf
    POP {r0-r7}
    
    @ Encrypt character
    PUSH {r4-r7}
    MOV r1, r5       @ e
    MOV r2, r6       @ n
    BL mod_pow
    MOV r8, r0       @ Save encrypted value
    POP {r4-r7}
    
    @ Write to file
    MOV r0, r4
    LDR r1, =scanf_fmt
    MOV r2, r8
    BL fprintf
    
    @ Show encrypted value
    PUSH {r0-r7}
    LDR r0, =enc_fmt
    MOV r1, r8
    BL printf
    POP {r0-r7}
    
    B encrypt_loop
encrypt_done:
    MOV r0, r4
    BL fclose
    B menu_loop
decrypt_message:
    @ Open input file
    LDR r0, =enc_file
    LDR r1, =read_mode
    BL fopen
    MOV r4, r0       @ r4 = file handle
    
    @ Open output file
    LDR r0, =dec_file
    LDR r1, =write_mode
    BL fopen
    MOV r5, r0       @ r5 = file handle
    
    @ Load keys
    LDR r6, =private_key
    LDR r6, [r6]     @ r6 = d
    LDR r7, =modulus
    LDR r7, [r7]     @ r7 = n
    
decrypt_loop:
    @ Read encrypted value
    SUB sp, sp, #4
    MOV r0, r4
    LDR r1, =scanf_fmt
    MOV r2, sp
    BL fscanf
    CMP r0, #1
    BNE decrypt_done
    
    LDR r0, [sp]
    ADD sp, sp, #4
    
    @ Decrypt value
    PUSH {r4-r7}
    MOV r1, r6       @ d
    MOV r2, r7       @ n
    BL mod_pow
    MOV r8, r0       @ Save decrypted value
    POP {r4-r7}
    
    @ Write to file
    MOV r0, r5
    LDR r1, =char_fmt
    MOV r2, r8
    BL fprintf
    
    @ Show decrypted character
    LDR r0, =dec_fmt
    MOV r1, r8
    BL printf
    
    B decrypt_loop
decrypt_done:
    MOV r0, r4
    BL fclose
    MOV r0, r5
    BL fclose
    LDR r0, =newline
    BL printf
    B menu_loop
@ Helper Functions
is_prime:
    PUSH {r4-r6, lr}
    MOV r4, r0
    CMP r4, #2
    BLT not_prime
    CMP r4, #2
    BEQ is_prime_true
    
    MOV r5, #2
prime_loop:
    CMP r5, r4
    BEQ is_prime_true
    
    UDIV r0, r4, r5
    MOV r6, r5
    MUL r1, r0, r6   @ Fixed: Use different registers
    CMP r1, r4
    BEQ not_prime
    
    ADD r5, r5, #1
    B prime_loop
    
not_prime:
    MOV r0, #0
    B prime_done
is_prime_true:
    MOV r0, #1
prime_done:
    POP {r4-r6, pc}
find_e:
    PUSH {r4-r5, lr}
    MOV r4, r0       @ totient
    MOV r5, #3       @ e starts at 3
find_e_loop:
    MOV r0, r5
    MOV r1, r4
    BL gcd
    CMP r0, #1
    BEQ find_e_done
    ADD r5, r5, #2
    B find_e_loop
find_e_done:
    MOV r0, r5
    POP {r4-r5, pc}
gcd:
    PUSH {r4-r6, lr}
gcd_loop:
    CMP r1, #0
    BEQ gcd_done
    MOV r4, r1
    UDIV r2, r0, r1
    MOV r5, r1
    MUL r6, r2, r5   @ Fixed: Use different registers
    SUB r1, r0, r6   @ r1 = r0 % r1
    MOV r0, r4
    B gcd_loop
gcd_done:
    POP {r4-r6, pc}
mod_inverse:
    PUSH {r4-r9, lr}
    MOV r4, r0       @ a
    MOV r5, r1       @ m
    MOV r6, #1       @ x1
    MOV r7, #0       @ x2
    MOV r8, r1       @ Original m
mod_inv_loop:
    CMP r1, #0
    BLE mod_inv_done
    
    UDIV r2, r4, r1      @ r2 = quotient
    MOV r9, r1           @ Save r1 temporarily
    MUL r3, r2, r9       @ r3 = quotient * divisor
    SUB r0, r4, r3       @ r0 = remainder
    
    MOV r4, r1           @ r4 = divisor
    MOV r1, r0           @ r1 = remainder
    
    MOV r0, r6           @ Save x1
    MOV r3, r2           @ Save quotient
    MUL r9, r3, r7       @ r9 = quotient * x2
    SUB r6, r0, r9       @ x1 = x1 - quotient * x2
    MOV r0, r7           @ x2 becomes old x1
    MOV r7, r6           @ Update x2
    MOV r6, r0           @ Update x1
    
    B mod_inv_loop
    
mod_inv_done:
    CMP r6, #0
    ADDLT r6, r6, r8
    MOV r0, r6
    POP {r4-r9, pc}
mod_pow:
    PUSH {r4-r9, lr}
    MOV r4, #1       @ result
    MOV r5, r0       @ base
    MOV r6, r1       @ exponent
    MOV r7, r2       @ modulus
mod_pow_loop:
    CMP r6, #0
    BEQ mod_pow_done
    
    TST r6, #1
    BEQ mod_pow_skip
    
    MOV r0, r4
    MOV r8, r5
    MUL r9, r0, r8   @ Fixed: Use different registers
    UDIV r0, r9, r7
    MUL r8, r0, r7
    SUB r4, r9, r8   @ r4 = (r4 * r5) % r7
    
mod_pow_skip:
    MOV r0, r5
    MOV r8, r5
    MUL r9, r0, r8   @ Fixed: Use different registers
    UDIV r0, r9, r7
    MUL r8, r0, r7
    SUB r5, r9, r8   @ r5 = (r5 * r5) % r7
    
    LSR r6, r6, #1
    B mod_pow_loop
    
mod_pow_done:
    MOV r0, r4
    POP {r4-r9, pc}
prime_error:
    LDR r0, =error_msg
    BL printf
    B generate_keys
exit_program:
    MOV r0, #0
    POP {r4-r11, pc}
.global gets
gets:
    PUSH {r4, r5, lr}
    MOV r4, r0       @ Buffer address
    MOV r5, r1       @ Buffer size
gets_loop:
    BL getchar
    CMP r0, #10      @ Check for newline
    BEQ gets_done
    CMP r0, #0       @ Check for EOF
    BEQ gets_done
    STRB r0, [r4], #1
    SUBS r5, r5, #1
    BNE gets_loop
gets_done:
    MOV r0, #0
    STRB r0, [r4]    @ Null terminate
    POP {r4, r5, pc}