#
# Program Name: RSALib.s
# Author: Zuriel Garcia
# Date: 
# Purpose: this file saves the functions used to implement RSA encryption. Includes: gcd, pow, modulo, cpubexp, cprivexp, encrypt and decrypt functions.
#

.global gcd
.global pow
.global modulo
.global cpubexp
.global cprivexp
.global encrypt
.global decrypt

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
	BEW gcd_end
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

# Function: pow
# Calculates power of number using recursion
# Parameters: m number in r0 and n power in r1
# Returns: in r0 nth power of m
pow:
	# allocates space for lr and r4
	SUB sp, sp, #12
	# saves return address
	STR lr, [sp, #0]	
	# saves r4
	STR r4, [sp, #4]
	# copy m into r4
	MOV r4, r0
	# saves r5
	STR r4, [sp, #0]
	# copy n into r5
	MOV r5, r1

	CMP r5, #0
	# if n!= 0, go to Else
	BNE Else
		# base case return value
		MOV r1, #0
		# call Return
		B Return
	Else:
		# prepare argument n - 1
		SUB r1, r5, #1
		# recursive call pow(m, n-1)
		BL pow
		# multiply m (in r4) to result
		MUL r1, r4, r1
		# call Return
		B Return
	Return:
	# restore return address
	LDR lr, [sp, #0]
	# restore r5
	LDR r5, [sp, #8]
	# restore r4
	LDR r4, [sp, #4]
	# restore stack
	ADD sp, sp, #12
	# return to caller
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
# Converts  hours and miles to kilometers per hour
# Parameters: r0 hours and miles
# Returns: prints kilometers per hour
cpubexp:

	SUB sp, sp, #4
	STR lr, [sp, #0]	

	BL Miles2Kilometers

	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

# Function: cprivexp
# 
# Parameters:
# Returns:
cprivexp:

# Function: encrypt
#
# Parameters:
# Returns:
encrypt:

# Function: decrypt
#
# Parameters:
# Returns:
decrypt:

