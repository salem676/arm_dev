#
# Program Name: RSALib.s
# Author: Zuriel Garcia
# Date: 
# Purpose: this file saves the functions used to implement RSA encryption. Includes: gcd, pow, modulo, cpubexp, cprivexp, encrypt and decrypt functions.
#

.global gcd
.global modulo
.global cpubexp
.global cprivexp

.text

# Function: gcd
# Calculates greatest common denominator for a and b
# Parameters: r1 is b, r2 is a
# Returns: saves gcd value between to r0
gcd:
	SUB sp, sp, #4
	STR lr, [sp, #0]
gcd_loop:
	# while (b != 0)
	CMP r1, #0
	BEQ gcd_end
	# r2 = a
	MOV r2, r0
	# r3 = b
	MOV r3, r1
	# b temp into r1
	MOV r1, r2

	BL modulo

	# b = a%b
	MOV r1, r0
	# a = b in temp
	MOV r0, r2
	B gcd_loop
gcd_end:
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

# Function: modulo
# Calculates a%b
# Parameters: r0 a and r1 b
# Returns: modulo of a and b in r0
modulo:

	SUB sp, sp, #4
	STR lr, [sp, #0]

	MOV r2, r0
	MOV r3, r1
	BL __aeabi_idiv
	MUL r4, r0, r3
	SUB r0, r2, r4	

	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

# Function: cpubexp
# Generates a valid candidate public exponent e
# Parameters: r0 phi(n)
# Returns: r0 valid e such that 1 < e < phi where gcd(e, phi) == 1
cpubexp:
	SUB sp, sp, #4
	STR lr, [sp, #0]
	# start test at e = 3
	MOV r2, #3
	
	loop_e:
	CMP r2, r0
	BGE non_valid_e
	
	# call gcd(e, phi)
	MOV r1, r0
	MOV r0, r2
	BL gcd

	# gcd(e, phi) == 1?
	CMP r0, #1
	BEQ found_valid_e

	# try next odd
	ADD r2, r2, #2
	B loop_e
	
	non_valid_e:
	MOV r0, #0
	B Return_e
	
	found_valid_e:
	MOV r0, r2

	Return_e:
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr	
	

# Function: cprivexp
# Calculates private exponent d such that (1 + x * phi) % e == 0 for some x integer 
# Parameters: e (in r0), phi (in r1)
# Returns: d (in r0)
cprivexp:
	SUB sp, sp, #8
	STR lr, [sp, #0]
	STR r4, [sp, #4]
	
	# x is 1
	MOV r2, #1
	
	find_x:
	# r3 is x * phi
	MUL r3, r2, r1
	# r3 is 1 + x * phi
	ADD r3, r3, #1
	
	MOV r0, r3
	# r1 is e	
	MOV r1, r4
	# r0 is a % b
	BL modulo

	# (1 + x * phi) % e == 0?
	CMP r0, #0
	BEQ found_d

	# x++
	ADD r2, r2, #1
	B find_x

	found_d:
	MUL r3, r2, r1
	ADD r3, r3, #1
	
	MOV r0, r3
	MOV r1, r4
	# r0 is d
	BL __aeabi_idiv

	LDR r4, [sp, #4]
	LDR lr, [sp, #0]
	ADD sp, sp, #8
	MOV pc, lr

