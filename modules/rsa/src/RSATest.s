#
# Program Name: RSATest.s
# Author: Zuriel Garcia
# Date: 
# Purpose: this file implements tests for the following functions for RSA encryption. Includes: gcd, pow, modulo, cpubexp, cprivexp.
#
.text

.global main
.extern gcd
.extern modulo
.extern cpubexp
.extern cprivexp

main:
	SUB sp, sp, #16
	
	# test gcd(48 ,18) expected result: 6
	MOV r0, #48
	MOV r1, #18
	BL gcd
	STR r0, [sp, #0]
	
	# test modulo(20, 6) expected result: 2
	MOV r0, #20
	MOV r1, #6
	BL modulo
	STR r0, [sp, #4]

	# test cpubexp(phi = 43)
	MOV r0, #43
	BL cpubexp
	STR r0, [sp, #8]
	
	# test cprivexp(e = r0 = ) expected result: d where (d * e) % phi == 1
	MOV r0, #3
	MOV r1, #40
	MOV r4, r0
	BL cprivexp
	STR r0, [sp, #12]
	
	B .
	

