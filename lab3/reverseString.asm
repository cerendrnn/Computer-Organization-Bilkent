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
    userString: .space 40
    reversedString: .space 40

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
  move $s7, $a0# $s7 will be used to find the address of the last element
  move $s6, $a0# $s6 will be used in the recursive part of the function
  
determineSize:
  lb $t6, 0($s5)  #we used $s5 here
  beq $t6, 0x0A,sizeCalculated
  addi $a2, $a2, 1 #increment size
  addi $s5, $s5, 1
  j determineSize

sizeCalculated:
  
  li $v0, 0
  move $a0, $a3 #STRING POINTED BY $a0 NOW!!!  STRING SIZE IS POINTED BY $a2!!!!
  move $t9, $a2 #STRING SIZE IS COPIED FOR FURTHER USE...
  la $a1, reversedString#$a1 points to the reversed version of the user array
  move $t3, $a1
  
  #NOW, FIND THE ADDRESS OF THE LAST ELEMENT
  #USE $t2 AS AN ITERATOR

lastAddress:

  beq $t2, $t9, addressFound
  addi $s7, $s7, 1
  addi $t2, $t2, 1
  j lastAddress

addressFound:
  #NOW $S7 HOLDS THE ADDRESS OF THE LAST ELEMENT 
  #ABOVE IN THE LINE 50, ADDRESS OF THE STRING PASSED AS AN ARGUMENT, SO CALL reverseString function
  subi $s7, $s7, 1#to avoid data link escape character, I subtract one 
  move $t5, $a0
  jal reverseString
  
  
done:
  
  li $v0, 4
  la $a0, reversedString
  syscall
  
  
  li $v0, 10
  syscall
  
reverseString:
  addi $sp, $sp, -12
  sw $ra, 8($sp)
  sw $a0, 4($sp)
  sw $a2, 0($sp)
  
  #base case of the function is here
  bne $s7, $a0, recursivePart
  lb $t4, 0($s7)#get the last element 
  sb  $t4, 0($t3) #put the value of the last element into reversed array
  #addi $sp, $sp, 16
  #move $a0, $s6#$a0 will point first character again
  jr $ra

recursivePart:
  addi $a0, $a0, 1 
  jal reverseString
  subi $s7, $s7, 1#last character is updated (last-1)
  addi $t3, $t3, 1
  lw $ra,8($sp)
  lw $a0,4($sp)
  lw $a2,0($sp)
  lb $t4, 0($s7)#get the last element 
  sb  $t4, 0($t3) #put the value of the last element into reversed array
  addi $sp, $sp, 12
  move $v0, $a1
  jr $ra
  
  
  
  
  
  
  
  
  
  
  
