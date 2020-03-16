.data

    message: .asciiz "Hello there\n"
    enterA: .asciiz "Enter your input for A:\n "
    enterB: .asciiz "Enter your input for B: \n "
    enterC: .asciiz "Enter your input for C: \n "
    enterD: .asciiz "Enter your input for D: \n "
    enterE: .asciiz "Enter your input for E: \n "
    result: .asciiz "Here is the result: \n"
.text
   li $v0, 4
   la $a0, message 
   syscall
   
   li $s0, 0 #$s0 is used for storing A
   li $s1, 0 #$s0 is used for storing B
   li $s2, 0 #$s0 is used for storing C
   li $s3, 0 #$s0 is used for storing D
   li $s4, 0 #$s0 is used for storing E
   li $t0, 0# for storing 4A - B 
   li $t1, 0# for storing C+D
   li $t2, 0#for storing (4A-B)*(C+D)
   li $t3, 0#for storing result
   li $t4, 4
   
   li $v0, 4
   la $a0, enterA
   syscall
   
   li $v0, 5
   syscall
   
   move $s0, $v0
   
   li $v0, 4
   la $a0, enterB
   syscall
   
   li $v0, 5
   syscall
   
   move $s1, $v0
   
   li $v0, 4
   la $a0, enterC
   syscall
   
   li $v0, 5
   syscall
   
   move $s2, $v0
   
   li $v0, 4
   la $a0, enterD
   syscall
   
   li $v0, 5
   syscall
   
   move $s3, $v0
   
   li $v0, 4
   la $a0, enterE
   syscall
   
   li $v0, 5
   syscall
   
   move $s4, $v0
   
   mul $s0, $s0, $t4 # get 4A
   sub $t0 $s0, $s1 #get 4A-B
   add $s2, $s2, $s3 #get C+D
   mul $t2, $t0, $s2# get (4A-B)*(C+D)
   div $t2, $s4#get result
   mfhi $t3#get result
   
   li $v0, 4
   la $a0, result
   syscall
   
   li $v0,1   
   move $a0, $t3
   syscall
   
   li $v0, 10
   syscall
   
   
   
   