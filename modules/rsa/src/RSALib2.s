#
# Program Name: RSALib.s
# Author: Zuriel Garcia
# Date: 
# Purpose: this file saves the functions used to implement RSA encryption. Includes: gcd, pow, modulo, cpubexp, cprivexp, encrypt and decrypt functions.
#

.global gcd
.global pow
.global modulo
.global mod_pow
.global mod_inverse
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
	LDR lr, [sp, #0] ADD sp, sp, #4
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

# Function: mod_pow
# Caclulates
# Parameters:
# Returns: r0 = (base^exp) % mod
mod_pow:
	SUB sp, sp, #16
	STR lr, [sp, #0]
	STR r4, [sp, #4]
	STR r5, [sp, #8]
	STR r6, [sp, #12]
	
	MOV r3, #1
	
	# mod in r1
	MOV r1, r2
	BL modulo
	# r4 = base % mod
	MOV r4, r0

	# exp in r1
	MOV r5, r1
	MOV r6, r2

	mod_low_loop:
	CMP r5, #0
	# while exp > 0
	BEQ mod_pow_done

	# if exp % 2 == 1
	AND r1, r5, #1
	CMP r1, #1
	BNE skip_mul
	
	# r0 is (result * base) % mod
	MOV r0, r3
	MOV r1, r4
	MUL r0, r0, r1
	MOV r1, r6
	BL modulo
	MOV r3, r0

	skip_mul:
	MOV r5, r5, LSR #1
	# base is (base*base) % mod
	MOV r0, r4
	MUL r0, r0, r0
	MOV r1, r6
	BL modulo
	MOV r4, r0

	B mod_pow_loop

	mod_pow_done:
	MOV r0, r3
	# restoring registers and return
	LDR lr, [sp, #0]
	LDR r4, [sp, #4]
	LDR r5, [sp, #8]
	LDR r6, [sp, #12]
	ADD sp, sp, #16
	MOV pc, lr
	

# Fuction: mod_inverse
# Calculates
# Parameters: t (in r4) is prev coefficient, newt (in r5) curr coefficient, r (in r6), curr divisor, newr (in r7) curr dividend
# Returns: r0 division result
mod_inverse:
	SUB sp, sp, #20
	STR lr, [sp, #0]
	STR r4, [sp, #4]
	STR r5, [sp, #8]
	STR r6, [sp, #12]
	STR r7, [sp, #16]
	
	MOV r4, #0
	MOV r5, #1
	MOV r6, r1
	MOV r7, r0
	
	loop:
	CMP r7, #0
	BEQ check_inverse
	# quotient  = r/newr
	MOV r0, r6
	MOV r1, r7
	BL __aeabi_udiv
	
	#newt = t - quotient * newt
	MOV r2, r0
	MUL r3, r2, r5
	SUB r2, r4, r3
	#swap t with newt
	MOV r4, r5
	MOV r5, r2
	# newr = r-quotient*newr
	MUL r3, r0, r7
	SUB r3, r6, r3
	# swap r and newr
	MOV r6, r7
	MOV r7, r2

	B loop
	
	check_inverse:
	CMP R6, #1
	BNE no_inverse

	CMP r4, #0
	BGE end_ok
	ADD r4, r4, r1
	
	end_ok:
	MOV r0, r4
	B Return

	no_inverse:
	MOV r0, #0

	Return:
	LDR lr, [sp, #0]
	LDR r4, [sp, #4]
	LDR r5, [sp, #8]
	LDR r6, [sp, #12]
	LDR r7, [sp, #16]
	ADD sp, sp, #16
	MOV pc, lr
	
	
	

# Function: cpubexp
# Converts  hours and miles to kilometers per hour
# Parameters: r0 phi
# Returns: r0 as smallest e where gcd(e, phi) == 1
cpubexp:
	SUB sp, sp, #16
	STR lr, [sp, #0]
	STR r1, [sp, #4]
	STR r2, [sp, #8]
	STR r3, [sp, #12]

	MOV r1, #3

	loop_cpubexp:
	# if e >= phi
	CMP r1, r0
	BGE cpubexp_fail
	
	MOV r2, r1
	MOV r3, r0
	MOV r0, r2
	MOV r1, r3
	BL gcd
	CMP r0, #1
	BEQ cpubexp_found
	
	LDR r1, [sp, #4]
	ADD r1, r1, #1
	STR r1, [sp, #4]
	B loop_cpubexp

	cpubexp_fail:
	MOV r0, #0
	B cpubexp_return
	
	cpubexp_found:
	LDR r0, [sp, #4]

	cpubexp_return:
	LDR lr, [sp, #0]
	LDR r1, [sp, #4]
	LDR r2, [sp, #8]
	LDR r3, [sp, #12]
	ADD sp, sp, #16
	MOV pc, lr
	

# Function: cprivexp
# 
# Parameters: r0 is e, r1 is phi
# Returns: d as r0
cprivexp:
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	BL mod_inverse

	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

# Function: cexp
#
# Parameters:
# Returns:
cexp:
	SUB sp, sp #4
	STR lr, [sp, #0]
	
	MOV r3, r0
	MOV r4, r1
	BL pow
	MOV r1, r2
	BL modulo
	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

# Function: encrypt
#
# Parameters: msg (in r0), e (in r1), n (in r2)
# Returns: (msg^e) % n in r0
encrypt:
	SUB sp, sp, #4
	STR lr, [sp, #0]

	BL mod_pow

	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

# Function: decrypt
#
# Parameters: cipher (in r0), d (in r1), n (in r2)
# Returns: (cipher^d) % n (in r0)
decrypt:
	SUB sp, sp, #4
	STR lr, [sp, #0]

	BL mod_pow
	
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

