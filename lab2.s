#                                           CS 240, Lab #2
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
# 
# Fill in your name, student ID in the designated sections.
# 
student_name: .asciiz "Sam G"
student_id: .asciiz "ID #"

################################################################################
new_line: .asciiz "\n"
space: .asciiz " "
endian_lbl: .asciiz "\nEndianness (Hexadecimal Values) \nExpected output:\n6 4 12\nObtained output:\n"
swap_bits_lbl: .asciiz "\nSwap bits (Hexadecimal Values)\nExpected output:\n33333333 048C159D FB73EA62\nObtained output:\n"
count_ones_lbl: .asciiz "\nCount ones \nExpected output:\n16 12 20\nObtained output:\n"

swap_bits_test_data:  .word  0xCCCCCCCC, 0x01234567, 0xFEDCBA98
swap_bits_expected_data:  .word 0x33333333, 0x048C159D, 0xFB736A62

endian_test_data:  .word 14, 8, 123
endian_expected_data:  .word 0xCDABCDAB, 0x67452301, 0x98BADCFE


hex_digits: .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

######################################################################################
#                           Text Section
.text
# Utility function to print hexadecimal numbers
print_hex:
move $t0, $a0
li $t1, 8 # digits
lui $t2, 0xf000 # mask
mask_and_print:
# print last hex digit
and $t4, $t0, $t2 
srl $t4, $t4, 28
la    $t3, hex_digits  
add   $t3, $t3, $t4 
lb    $a0, 0($t3)            
li    $v0, 11                
syscall 
# shift 4 times
sll $t0, $t0, 4
addi $t1, $t1, -1
bgtz $t1, mask_and_print
exit:
jr $ra
########################################################################################################
########################################################################################################
########################################################################################################
#                            PART 1 (Count Bits)
# 
# You are given an 32-bits integer stored in $t0. Count the number of 1's
#in the given number. For example: 1111 0000 should return 4
# Store you final answer in register $t9
.globl count_ones
count_ones:
move $t0, $a0 
############################## Part 1: your code begins here ###              
 
add $t9, $zero, $zero     #make sure $t9 is set to 0           

count: 
    andi $t1, $t0, 1        # andi 1 to $t0, store in $t1
    add $t9, $t9, $t1       # add $t9 and $t1

    srl $t0, $t0, 1         # shift right by 1

    bnez $t0, count  # branch if $t0 is not 0 
    

############################## Part 1: your code ends here ###
move $v0, $t9
jr $ra

########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
#                            PART 2 (Swap Bit Pairs)
# 
# You are given an 32-bits integer stored in $t0. You need swap pair of bits
# at within every 4 bits. i.e. b31, b30 <-> b29, b28, ... , b3, b2 <-> b1, b0
# The result must be stored inside $t9.

.globl swap_bits
swap_bits:
move $t0, $a0 
############################## Part 2: your code begins here ############################################
add $t9, $zero, $zero         # set $t9 to 0

    andi $t1, $t0, 0xCCCCCCCC   # mask (1100 = 12)
    srl $t1, $t1, 2              #shift right by 2

    andi $t2, $t0, 0x33333333  #mask (0011 = 00)
    sll $t2, $t2, 2              #shift left by 2

    or $t9, $t9, $t1            #combine
    or $t9, $t9, $t2		#combine

#no loop

############################## Part 2: your code ends here ############################################
move $v0, $t9
jr $ra

########################################################################################################
########################################################################################################
########################################################################################################
#                           PART 3
# 
# You are given an interger in register $t0
# Determine the number of steps to make this integer 0
# Allowed operations:
#        - If the number is even, divide by 2
#        - If the numebr is odd, subtract 1
#You may not use div, rem or mod instrctions to check for evenness or perform division
#use logical bit-wise instrucations to perform division. 

.globl StepsToZero
StepsToZero:
move $t0, $a0 
############################## Part 3: your code begins here ############################################
               
add $t9, $zero, $zero # initialize $t9 to 0
loop:
    andi $t1, $t0, 1      # if $t0 is 0, then even --- if 1, then odd
    beqz $t1, even    # if even, jump to even
    
    subi $t0, $t0, 1 #since odd, sub 1
    j countloops      # jump to increment 

even: 

    srl $t0, $t0, 1 # since even, divide by 2

countloops:
    addi $t9, $t9, 1      # increment count by 1

    bnez $t0, loop   # continue to loop until $t0 == 0


############################## Part 3: your code ends here ############################################
move $v0, $t9
jr $ra

########################################################################################################
########################################################################################################
########################################################################################################
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
li $v0, 4
la $a0, new_line
syscall
la $a0, count_ones_lbl
syscall

# Testing part 2
li $s0, 3 # num of test cases
li $s1, 0
la $s2, swap_bits_test_data

test_p1:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal count_ones

move $a0, $v0        # $integer to print
li $v0, 1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p1

li $v0, 4
la $a0, new_line
syscall
la $a0, swap_bits_lbl
syscall

# Testing part 2
li $s0, 3 # num of test cases
li $s1, 0
la $s2, swap_bits_test_data

test_p2:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal swap_bits

move $a0, $v0
jal print_hex
li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p2

li $v0, 4
la $a0, new_line
syscall
la $a0, endian_lbl
syscall


# Testing part 3
li $s0, 3 # num of test cases
li $s1, 0
la $s2, endian_test_data

test_p3:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal StepsToZero

move $a0, $v0        # $integer to print
li $v0, 1
syscall

li $v0, 4
la $a0, space
syscall


addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p3


_end:
# end program
li $v0, 10
syscall

