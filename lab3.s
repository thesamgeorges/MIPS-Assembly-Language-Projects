jal main
#                                           CS 240, Lab #3
# 
#                                          IMPORTATNT NOTES:
# 
#                       Write your assembly code only in the marked blocks.
# 
#                     	DO NOT change anything outside the marked blocks.
# 
#               Remember to fill in your name, student ID in the designated sections.
# 
#
j main
###############################################################
#                           Data Section
.data
# 
# Fill in your name, student ID in the designated sections.
# 
student_name: .asciiz "Samantha Georges"
student_id: .asciiz "130855774#"

new_line: .asciiz "\n"
space: .asciiz " "
testing_label: .asciiz ""
unsigned_addition_label: .asciiz "Unsigned Addition (Hexadecimal Values)\nExpected Output:\n0154B8FB06E97360 BAC4BABA1BBBFDB9 00AA8FAD921FE305 \nObtained Output:\n"
fibonacci_label: .asciiz "Fibonacci\nExpected Output:\n0 1 5 55 6765 3524578 \nObtained Output:\n"
file_label: .asciiz "File I/O\nObtained Output:\n"

addition_test_data_A:	.word 0xeee94560, 0x0154a8d0, 0x09876543, 0x000ABABA, 0xFEABBAEF, 0x00a9b8c7
addition_test_data_B:	.word 0x18002e00, 0x0000102a, 0x12349876, 0xBABA0000, 0x93742816, 0x0000d6e5

fibonacci_test_data:	.word  0, 1, 2, 3, 5, 6, 

bcd_2_bin_lbl: .asciiz "\nAiken to Binary (Hexadecimal Values)\nExpected output:\n004CC853 00BC614E 00008AE0\nObtained output:\n"
bin_2_bcd_lbl: .asciiz "\nBinary to Aiken (Hexadecimal Values) \nExpected output:\n0B03201F 0CC3C321 000CBB3B\nObtained output:\n"


bcd_2_bin_test_data: .word 0x0B03201F, 0x1234BCDE, 0x3BBB2

bin_2_bcd_test_data: .word 0x4CC853, 0x654321, 0xFFFF


hex_digits: .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

file_name:
	.asciiz	"lab3_data.dat"	# File name
	.word	0
read_buffer:
	.space	300			# Place to store character
###############################################################
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
###############################################################
###############################################################
###############################################################
#                           PART 1 (Unsigned Addition)
# You are given two 64-bit numbers A,B located in 4 registers
# $t0 and $t1 for lower and upper 32-bits of A and $t2 and $t3
# for lower and upper 32-bits of B, You need to store the result
# of the unsigned addition in $t4 and $t5 for lower and upper 32-bits.
#
.globl Unsigned_Add_64bit
Unsigned_Add_64bit:
move $t0, $a0
move $t1, $a1
move $t2, $a2
move $t3, $a3
############################## Part 1: your code begins here ###

addu $t4, $t0, $t2   

# add upper 32 bits
addu $t5, $t1, $t3   

# #check for carry (lower)
bgeu $t4, $t0, uppercarry
addiu $t5, $t5, 1      # add carry to upper 32 bits
uppercarry:

# check if $t4 or $t5 greater than sum
bgeu $t4, $t2, overflow
bgeu $t5, $t3, overflow
j no_overflow

overflow:
addi $t1, $t1, 1  #add one to account for loss from overflow

no_overflow:

############################## Part 1: your code ends here   ###
move $v0, $t4
move $v1, $t5
jr $ra
###############################################################
###############################################################
###############################################################
#                            PART 2 (Aiken Code to Binary)
# 
# You are given a 32-bits integer stored in $t0. This 32-bits
# present a Aiken number. You need to convert it to a binary number.
# For example: 0xDCB43210 should return 0x48FF4EA.
# The result must be stored inside $t0 as well.
.globl aiken2bin
aiken2bin:
move $t0, $a0
############################ Part 2: your code begins here ###

add $t2, $zero, $zero # result = 0

    
    jump:             
    andi $t1, $t0, 0xF0000000 #mask first 4 bits
    srl $t1, $t1, 28              # Shift right 28 times

    #bgt $t1, 4, subtractsix
    ble $t1, 4, subtractsix #branch if less than 4
  addi $t1, $t1, -6 #sub six 
    subtractsix: 
    
	mul $t2, $t2, 10 #multiply result by 10
	add $t2, $t2, $t1 #add result and $t1
	sll $t0, $t0, 4  #shift left to discard the 4 bits
	beq $t0, 0, quitloop # if $t0 = 0, then quit the loop
  j jump           #loop if $t0 =/= 0
  quitloop:
        add $t0, $zero, $t2 # combine $t0 and $t2
  
           

############################ Part 2: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
#                            PART 3 (Binary to Aiken Code)
# 
# You are given a 32-bits integer stored in $t0. This 32-bits
# present an integer number. You need to convert it to a Aiken.
# The result must be stored inside $t0 as well.
.globl bin2aiken
bin2aiken:
move $t0, $a0
############################ Part 3: your code begins here ###
   add $t4, $zero, $zero #result = 0
   add $t6, $zero, $zero #shift amount = 0
   addi $t7, $zero, 10
  
     move $t1, $t0       #store number in $t1
     jump_here:
     div $t0, $t7 #divide number by 10 
     mfhi $t5 # -- quotient & num
     #number = quotient
     mflo $t0 ## remainder
     ble $t5, 4, addsix #if remainder less than 4, branch
     addi $t5, $t5, 6 # if remainder greater than 4
     addsix: 
     
     sllv $t5, $t5, $t6 #shift remainder by shift amount in $t6
     
     add $t4, $t4, $t5 #result  = result + remainder 
     addi $t6, $t6, 4 #shift amount = shift amount + 4
     
     beq $t0, $0, quit_loop        
	j jump_here

quit_loop: 
	add $t0, $zero, $t4


############################ Part 3: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
###############################################################
###############################################################


###############################################################
###############################################################
###############################################################
#                           PART 4 (ReadFile)
#
# You will read characters (bytes) from a file (lab3_data.dat) 
# and print them. 
#Valid characters are defined to be
# alphanumeric characters (a-z, A-Z, 0-9),
# " " (space),
# "." (period),
# (new line).
#
# 
# Hint: Remember the ascii table. 
#
.globl file_read
file_read:
############################### Part 4: your code begins here ##

    # Open the file
    li   $v0, 13           # open file
    la   $a0, file_name    # file name
    li   $a1, 0            # read only
    li   $a2, 0            # mode
    syscall
    move $s6, $v0          # save file descriptor

    			# read from file to buffer
    li   $v0, 14           # syscall for read file
    move $a0, $s6          # file descriptor
    la   $a1, read_buffer  #buffer address
    li   $a2, 300          # buffer size
    syscall

    move $a0, $s6          #file descriptor
    li   $v0, 16           # syscall for close file
    syscall

    move $a0, $a1          # store buffer
    li   $v0, 11           # syscall for print character
    add $t0, $zero, $zero            # set loop counter to 0

la $t7, read_buffer
    # loop for printing valid chars
    printloop:
    lb   $t1, 0($t7)    # load from buffer
    beq  $t1, $zero, endloop  # exit if no more to read

  # check if space, period, newline, a-z, A-Z, 0-9
        
        blt $t1, 10, invalid # if less than 10, invalid
        beq $t1, 10, valid #new line
        blt $t1, 32, invalid  #if less than 32, invalid
        beq $t1, 32, valid # space
        blt $t1, 46, invalid # if less tan 46 invalid
        beq $t1, 46, valid #period
        blt $t1, 48, invalid  # if less than 48 invalid
        blt $t1, 58, valid  #0-9
        blt $t1, 65, invalid #less than 65 invalid
        blt $t1, 91, valid #A-Z
        blt $t1, 97, invalid # less than 97 invalid
        blt $t1, 123, valid #a-z
        bge $t1, 123, invalid #less than or equal to 123 invalid
        
        
        
        
        
      
# send valid values for $t1 here
        valid:
            
           move $a0, $t1 #stores valid $t1
            
            syscall 

        addi $t7, $t7, 1 #increment counter
        
        j printloop

    invalid: #send invalid values here
        
        addi $t7, $t7, 1  #increment loop counter
        j printloop

    endloop:
 


############################### Part 4: your code ends here   ##
jr $ra
###############################################################
###############################################################
###############################################################

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
##############################################
##############################################
test_64bit_Add_Unsigned:
li $s0, 3
li $s1, 0
la $s2, addition_test_data_A
la $s3, addition_test_data_B
li $v0, 4
la $a0, testing_label
syscall
la $a0, unsigned_addition_label
syscall
##############################################
test_add:
add $s4, $s2, $s1
add $s5, $s3, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 4($s4)
lw $a2, 0($s5)
lw $a3, 4($s5)
jal Unsigned_Add_64bit

move $s6, $v0
move $a0, $v1
jal print_hex
move $a0, $s6
jal print_hex

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 8
addi $s0, $s0, -1
bgtz $s0, test_add

li $v0, 4
la $a0, new_line
syscall
##############################################
##############################################
li $v0, 4
la $a0, new_line
syscall
la $a0, bcd_2_bin_lbl
syscall
# Testing part 2
li $s0, 3 # num of test cases
li $s1, 0
la $s2, bcd_2_bin_test_data

test_p2:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal aiken2bin

move $a0, $v0        # hex to print
jal print_hex

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p2

##############################################
##############################################
li $v0, 4
la $a0, new_line
syscall
la $a0, bin_2_bcd_lbl
syscall

# Testing part 3
li $s0, 3 # num of test cases
li $s1, 0
la $s2, bin_2_bcd_test_data

test_p3:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal bin2aiken

move $a0, $v0        # hex to print
jal print_hex

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p3
##############################################
##############################################
li $v0, 4
la $a0, new_line
syscall
test_file_read:
li $v0, 4
la $a0, new_line
syscall
li $s0, 0
li $v0, 4
la $a0, testing_label
syscall
la $a0, file_label
syscall 
jal file_read
end:
# end program
li $v0, 10
syscall
