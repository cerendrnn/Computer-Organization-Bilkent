####################################################################################################################

#Author: Aybüke Ceren Duran
#Section: 03
#Lab: 03
#ID: 21302686

####################################################################################################################
.data
   promptSize: .asciiz "Hello! Please enter the size of your number: \n"
   enterString: .asciiz "Please enter the string now: \n"
   result: .asciiz "Here is the result: \n"
   userString: .space 20
   
.text

entering:
  li $v0, 4
  la $a0, promptSize
  syscall
  
  li $v0, 5
  syscall #get the size
  
 
  li $v0, 4
  la $a0, enterString
  syscall
   
  li $v0, 8
  la $a0, userString
  li $a1, 20
  syscall #get the string now
  
  move $a3, $a0#user string address is copied into $a3 
  move $s5, $a0#user string address is copied into $s5  
  
determineSize:
  lb $t6, 0($s5)
  beq $t6, 0x0A,sizeCalculated
  addi $a2, $a2, 1 #increment size
  addi $s5, $s5, 1
  j determineSize

sizeCalculated:
  
  li $v0, 0
  
  jal recursiveSummation
  move $s1, $v0
  
done:
  
  li $v0, 4
  la $a0, result
  syscall
  
  li $v0,1
  add $a0, $zero, $s1
  syscall
  
  li $v0, 10
  syscall
  
#####################
# def digit_sum(n):
#    if n==0 or n==1:
#        return n
#    else:
#        return n+digit_sum(n-1)
#####################
recursiveSummation:
  
  addi $sp, $sp, -12
  sw $a2, 8($sp)
  sw $a3, 4($sp)
  sw $ra, 0($sp)
  
 
  bgt $a2, 1, sumLoop
  
  lb $t2, 0($a3)
  subi $t2, $t2, 48
  add $v0, $v0, $t2    
  addi $sp, $sp, 12
  jr $ra
  
sumLoop:
  
  lb $t2, 0($a3)#get the digit
  subi $t2, $t2, 48
  add $a3, $a3, 1
  subi $a2, $a2, 1
  add $v0, $t2, $v0
  jal recursiveSummation
  lw $a2, 8($sp)
  lw $a3, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 12
  jr $ra
  
