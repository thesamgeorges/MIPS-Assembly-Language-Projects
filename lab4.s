#                                           CS 240, Lab #4
# 
#                                          IMPORTATNT NOTES:
# 
#                       Write your assembly code only in the marked blocks.
# 
#                       DO NOT change anything outside the marked blocks.
# 
#
j main
###############################################################################
#                           Data Section
.data

# 
# Fill in your name, student ID in the designated sections.
# 
student_name: .asciiz "Samantha Georges"
student_id: .asciiz "130855774"

new_line: .asciiz "\n"
space: .asciiz " "


t1_str: .asciiz "Testing GCD: \n"
t2_str: .asciiz "Testing LCM: \n"
t3_str: .asciiz "Testing RANDOM SUM: \n"

po_str: .asciiz "Obtained output: " 
eo_str: .asciiz "Expected output: "

#GCD_test_data_A:	.word 1, 2, 128, 148, 36, 360, 108, 75, 28300, 0
#GCD_test_data_B:	.word 12, 12, 96, 36, 54, 210, 144, 28300, 74000, 143

GCD_test_data_A:	.word 1, 36, 360, 108, 28300
GCD_test_data_B:	.word 12,54, 210, 144, 74000

GCD_output:           .word 1, 18, 30, 36, 100

#LCM_test_data_A:	.word 0, 1, 2, 128, 148, 36, 360, 108, 75, 28300
#LCM_test_data_B:	.word 143, 12, 12, 96, 36, 54, 210, 144, 28300, 74000
#LCM_output:           .word 0, 12, 12, 384, 1332, 108, 2520, 432, 84900, 20942000 


LCM_test_data_A:	.word 1, 36, 360, 108, 28300
LCM_test_data_B:	.word 12,54, 210, 144, 74000
LCM_output:           .word 12, 108, 2520, 432, 20942000

RANDOM_test_data_A:	.word 1, 144, 42, 260, 74000
RANDOM_test_data_B:	.word 12, 108,  54, 210, 44000
RANDOM_test_data_C:	.word 4, 109, 36, 360, 28300

RANDOM_output:           .word 26, 720, 216, 3120, 21044400

###############################################################################
#                           Text Section
.text
# Utility function to print an array
print_array:
li $t1, 0
move $t2, $a0
print:

lw $a0, ($t2)
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $t2, $t2, 4
addi $t1, $t1, 1
blt $t1, $a1, print
jr $ra
###############################################################################
###############################################################################
#                           PART 1 (GCD)
#a0: input number
#a1: input number

#v0: final gcd answer

.globl gcd
gcd:
############################### Part 1: your code begins here ################

beq $a1, $zero, loop #if equal, then jump to loop:
#else 
div $a0, $a1 #divide a1 by a0
move $a0, $a1 #store a1 in a0
mfhi $a1 #store remainder in a1

j skip
loop: #if equal, then move $a0 to $v0
add $v0, $0, $a0
j end
skip:
j gcd
end:
############################### Part 1: your code ends here  ##################
jr $ra
###############################################################################
###############################################################################
#                           PART 2 (LCM)

# Find the least common multiplier of two numbers given
# Make a call to the GCD function to compute the LCM
# LCM = a1*a2 / GCD

# Preserve all required values in stack before calls to another function.
# preserve the $ra register value in stack before making the call!!!

#a0: input number
#a1: input number
#v0: final gcd answer

.globl lcm
lcm:
############################### Part 2: your code begins here ################
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # move a1 to t0 
    #move a2 to t1 
    move $t0, $a0
    move $t1, $a1

    #call gcd
    addi $sp, $sp, -4
    sw $t0, 0($sp)
    addi $sp, $sp, -4
    sw $t1, 0($sp)
    
    jal gcd2
    
    
    lw $t0, 0($sp)
    addi $sp, $sp, 4
    lw $t1, 0($sp)
    addi $sp, $sp, 4
    
    #store gcd in $t2
    move $t2, $v0
    

    #calculate LCM
    mul $v0, $t0, $t1  #$v0 = a1*a2
    div $v0, $t2
    mflo $v0  # $v0=LCM

    #restore stack values
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
   
############################### Part 2: your code ends here  ##################
jr $ra
###############################################################################
#                           PART 3 (Random SUM)

# You are given three integers. You need to find the smallest 
# one and the largest one.
# 
# Then find the GCD and LCM of the two numbers. 
#
# Return the sum of Smallest, largest, GCD and LCM
#
# Implementation details:
# The three integers are stored in registers $a0, $a1, and $a2.
# Store the answer into register $v0. 
# Preserve all required values in stack before calls to another function.
# preserve the $ra register value in stack before making the call!!!
# Use stacks to store the smallest and largest values before making the function call. 

.globl random_sum
random_sum:
############################### Part 3: your code begins here ################
   # save stack values
     subiu $sp, $sp, 4 
    sw $ra, 0($sp)
    move $t0, $a0     
	move $t1, $a0     

	slt $t2, $a1, $t0  # if $a1 < $t0
	beqz $t2, check  #if $a1 >= $t0
	move $t0, $a1      

	check:
	slt $t2, $a2, $t0  # set $t2 to 1 if $a2 < $t0
	beqz $t2, smallest  # if $a2 >= $t0
	move $t0, $a2      

	smallest:
	slt $t2, $t1, $a1  # set $t2 to 1 if $t1 < $a1
	beqz $t2, smallest2  # if $t1 >= $a1
	move $t1, $a1      
	smallest2:
	slt $t2, $t1, $a2  # if $t1 < $a2
	beqz $t2, smallestEnd  # if $t1 >= $a2
	move $t1, $a2      

	smallestEnd:
    
    # find gcd of largest and smallest #
    move $a0, $t0
    move $a1, $t1
    addi $sp, $sp, -8
    sw $t0 0($sp)
    sw $t1 4($sp)
    jal gcd2
   
    move $t3, $v0  # store gcd in $s3
    # find LCM of the largest and smallest #
    lw $t0, 0($sp)
     lw $t1, 4($sp)
     addi $sp, $sp, -4
     sw $t3, 0($sp)
    move $a0, $t0
    move $a1, $t1
    move $a2, $t3  # pass gcd in
    jal lcm2
    move $t4, $v0  # store lcm in $s4
    lw $t3, 0($sp)
    lw $t0, 4($sp)
    lw $t1, 8($sp)
    addiu $sp, $sp, 12
    # add smallest, largest, GCD, and LCM
    add $v0, $t0, $t1
    add $v0, $v0, $t3
    add $v0, $v0, $t4

    # restore stack values
    lw $ra, 0($sp)
    addiu $sp, $sp, 4


############################### Part 3: your code ends here  ##################
jr $ra
###############################################################################

#                          Main Function 
main:
li $v0, 4
la $a0, student_name
syscall
la $a0, new_line
syscall  
la $a0, student_id
syscall 
la $a0, new_line
syscall
la $a0, new_line
syscall
###############################################################################
#                          TESTING PART 1 - GCD
li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, t1_str
syscall

li $v0, 4
la $a0, eo_str
syscall

li $v0, 4
la $a0, new_line
syscall

li $s0, 5 # num tests
la $s2, GCD_output
move $a0, $s2
move $a1, $s0
jal print_array

li $v0, 4
la $a0, new_line
syscall


li $v0, 4
la $a0, po_str
syscall

li $v0, 4
la $a0, new_line
syscall


#test_GCD:
li $s0, 5 # num tests
li $s1, 0
la $s2, GCD_test_data_A
la $s3, GCD_test_data_B
#j skip_line
##############################################
test_gcd:
#li $v0, 4
#la $a0, new_line
#syscall
#skip_line:
add $s4, $s2, $s1
add $s5, $s3, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 0($s5)
jal gcd

move $a0, $v0
li $v0,1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_gcd

###############################################################################

#                          TESTING PART 2 - LCM
li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, t2_str
syscall

li $v0, 4
la $a0, eo_str
syscall

li $v0, 4
la $a0, new_line
syscall

li $s0, 5 # num tests
la $s2, LCM_output
move $a0, $s2
move $a1, $s0
jal print_array

li $v0, 4
la $a0, new_line
syscall


li $v0, 4
la $a0, po_str
syscall

li $v0, 4
la $a0, new_line
syscall


#test_GCD:
li $s0, 5 # num tests
li $s1, 0
la $s2, LCM_test_data_A
la $s3, LCM_test_data_B
#j skip_line
##############################################
test_lcm:
#li $v0, 4
#la $a0, new_line
#syscall
#skip_line:
add $s4, $s2, $s1
add $s5, $s3, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 0($s5)
jal lcm

move $a0, $v0
li $v0,1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_lcm

###############################################################################
#                          TESTING PART 3 - RANDOM SUM
li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, t3_str
syscall

li $v0, 4
la $a0, eo_str
syscall

li $v0, 4
la $a0, new_line
syscall

li $s0, 5 # num tests
la $s2, RANDOM_output
move $a0, $s2
move $a1, $s0
jal print_array

li $v0, 4
la $a0, new_line
syscall


li $v0, 4
la $a0, po_str
syscall

li $v0, 4
la $a0, new_line
syscall


#test_GCD:
li $s0, 5 # num tests
li $s1, 0
la $s2, RANDOM_test_data_A
la $s3, RANDOM_test_data_B
la $s4, RANDOM_test_data_C
#j skip_line
##############################################
test_random:
#li $v0, 4
#la $a0, new_line
#syscall
#skip_line:
add $s5, $s2, $s1
add $s6, $s3, $s1
add $s7, $s4, $s1
# Pass input parameter
lw $a0, 0($s5)
lw $a1, 0($s6)
lw $a2, 0($s7)
jal random_sum

move $a0, $v0
li $v0,1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_random

###############################################################################

_end:

# new line
li $v0, 4
la $a0, new_line
syscall

# end program
li $v0, 10
syscall
###############################################################################
