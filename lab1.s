#                                           CS 240, Lab #1
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


t1_str: .asciiz "Testing Arithmetic Expression: \n"
t2_str: .asciiz "Testing Total Surface Area of rectangular box: \n"
t3_str: .asciiz "Testing Random Sum: \n"

po_str: .asciiz "Obtained output: " 
eo_str: .asciiz "Expected output: "

Arith_test_data_A:	.word 2, 1, -2, 2, 0
Arith_test_data_B:	.word 4, 2, -4, 4, 0
Arith_test_data_C:	.word 6, 3, -6, 6, -1
Arith_test_data_D:	.word 5,10, 5, 7, 0

Arith_output:           .word 7, -4, -17, 5, -1 


Rect_test_data_A:	.word 5, 10, 2, 18, 2
Rect_test_data_B:	.word 4, 10, 4, 14, 74
Rect_test_data_C:	.word 3, 10, 6, 1, 7

Rect_output:           .word 94, 600, 88, 568, 1360 

RANDOM_test_data_A:	.word 1, 144, -42, 260, -12
RANDOM_test_data_B:	.word 5, 108, 54, 210, -15
RANDOM_test_data_C:	.word 7, 109, 36, 360, -20

RANDOM_output:        .word 8, 252, 12, 570, -32

output_1:              .space 5
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
#                           PART 1 (Arithmetic expression )
#$t0 is A
#$t1 is B
#$t2 is C
#$t3 is D
#$t4 is Z
# Solve for Z= A+B+C-D
# Make sure your final answer is in register $t4. 
.globl Arith
Arith:
move $t0, $a0
move $t1, $a1
move $t2, $a2
move $t3, $a3
############################### Part 1: your code begins here ################

add $t4, $t0, $t1 #adds A and B, puts output in $t4
add $t4, $t4, $t2 #adds (A+B) and C, puts output in $t4
sub $t4, $t4, $t3 # subtracts D from (A+B+C) and puts the result in $t4 register





############################### Part 1: your code ends here  ##################
add $v0, $t4, $zero
jr $ra
###############################################################################
###############################################################################
#                           PART 2 (Total Surface Area of Rectangle Box)

# Load the values of height, width and length from memory
# Find the Total Surface Area of the rectangular box and store back in memory

## Implementation details:
# The memory address are preloaded for you in registers $s2, $s3, $s4 and $s5. 
# $s2 = address of length
# $s3 = address of width
# $s4 = address of height
# store the final answer in memory address $s5. 

# IMPORTANT: DO NOT CHANGE VALUES IN $s registers!!!! You will break the code. 
.globl rectangle
rectangle:
############################### Part 2: your code begins here ################

lw $t2, 0($s2) #loads length
lw $t3, 0($s3) #loads width
lw $t4, 0($s4) #loads height

mult $t2, $t3 # multiplies length x width
mflo $t6 # moves lower register to $t6
mult $t2, $t4 # length x height
mflo $t7 # moves lower register to $t7
mult $t3, $t4 # width x height
mflo $t8 # moves lower register to $t8

add $t5, $t6, $t7 # adds multiplied values
add $t5, $t5, $t8

addi $t9, $zero, 2 
mult $t5, $t9 #multiplies sum by 2
mflo $t5
sw $t5, 0($s5) #stores the total surface area




############################### Part 2: your code ends here  ##################
jr $ra
###############################################################################
#                           PART 3 (Random SUM)

# You are given three integers. You need to find the smallest 
# one and the largest one.
# 
#
# Return the sum of Smallest and largest
#
# Implementation details:
# The three integers are stored in registers $t0, $t1, and $t2. 
# Store the answer into register $t9.
# You are allowed to use only the $t registers.  

.globl random_sum
random_sum:
move $t0, $a0
move $t1, $a1
move $t2, $a2
############################### Part 3: your code begins here ################


### CODE TO GET BIGGEST # 
bgt $t0, $t1, l1 # if a > b, go to l1
bgt $t1, $t0, l2 # ELSE: if b>a, go to l2

l1: #add $t3, $t3, $t0
add $t3, $zero, $t0
j end1
l2: #add $t3, $t3, $t1 
add $t3, $zero, $t1
j end2

end1: 
end2: 
bgt $t3, $t2, l3 # compare bigger number to c - if $t3 > c, go to l3
bgt $t2, $t3, l4 # if c > $t3

l3: #add $t4, $t4, $t3 # add biggest number to $t4
add $t4, $zero, $t3
j end3
l4: #add $t4, $t4, $t2 # add c to $t4
add $t4, $zero, $t2
j end4

#### CODE TO GET SMALLEST #
end3:
end4: 
blt $t0, $t1, l5 # if a < b, go to l1
blt $t1, $t0, l6 # ELSE: if b < a, go to l2

l5: #add $t5, $t5, $t0
add $t5, $zero, $t0
j end5
l6: #add $t5, $t5, $t1 
add $t5, $zero, $t1
j end6

end5:
end6: 
blt $t5, $t2, l7 # compare smallest number to c - if $t3 < c, go to l3
blt $t2, $t5, l8 # if c < $t3


l7: #add $t6, $t6, $t3 # add smallest number to $t6
add $t6, $zero, $t3
j end7
l8: #add $t6, $t6, $t2 # add c to $t6
add $t6, $zero, $t2
j end8
#### ADD SMALLEST AND BIGGEST NUMBERS

#Compare $t4 and $t6
end7:
end8:
add $t9, $zero, $zero
add $t9, $t4, $t6
#add $t9, $zero, $t6



############################### Part 3: your code ends here  ##################
add $v0, $t9, $zero
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
#                          TESTING PART 1 - Arithmetic
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
la $s2, Arith_output
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

#j skip_line
##############################################
test_arith:
la $s2, Arith_test_data_A
la $s3, Arith_test_data_B
la $s4, Arith_test_data_C
la $s5, Arith_test_data_D
add $s2, $s2, $s1
add $s3, $s3, $s1
add $s4, $s4, $s1
add $s5, $s5, $s1
# Pass input parameter
lw $a0, 0($s2)
lw $a1, 0($s3)
lw $a2, 0($s4)
lw $a3, 0($s5)
jal Arith

move $a0, $v0
li $v0,1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_arith

###############################################################################
#                          TESTING PART 2 - Area of Rectangular box
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
la $s2, Rect_output
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

#j skip_line
##############################################
test_lcm:
la $s2, Rect_test_data_A
la $s3, Rect_test_data_B
la $s4, Rect_test_data_C
la $s5, output_1
add $s2, $s2, $s1
add $s3, $s3, $s1
add $s4, $s4, $s1
add $s5, $s5, $s1
# Pass input parameter
#lw $a0, 0($s4)
#lw $a1, 0($s5)
jal rectangle

lw $a0, 0($s5)
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

#j skip_line
##############################################
test_random:
la $s2, RANDOM_test_data_A
la $s3, RANDOM_test_data_B
la $s4, RANDOM_test_data_C
add $s2, $s2, $s1
add $s3, $s3, $s1
add $s4, $s4, $s1
# Pass input parameter
lw $a0, 0($s2)
lw $a1, 0($s3)
lw $a2, 0($s4)
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


