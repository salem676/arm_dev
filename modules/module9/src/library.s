#
# Program Name: library.s
# Author: Zuriel Garcia
# Date: 3/31/2025
# Purpose: this library inclues the findMaxOf3 function, the distribution among check_r0_r2 and return_max functions
# allows better readability
#

.global findMaxOf3
text:

# Function: findMaxOf3
# determines the biggest of three integer values
# Parameters: r0 and r1 first and second values
# Returns: r0 biggest value integer
findMaxOf3:
	CMP r0, r1
	BGE check_r0_r2
	MOV r0, r1
# Function: check_r0_r2
# helps function findMaxOf3
# Parameters: r0 and r2 having the next values to compare
# Returns: r0 biggest value
check_r0_r2:
	CMP r0, r2
	BGE return_max
	MOV r0, r2
# Function: return_max
# helps function check_r0_r2
# Parameters:
# Returns:
return_max:
	BX lr
