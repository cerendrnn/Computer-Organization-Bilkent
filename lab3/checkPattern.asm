.data

  enterBits: .asciiz "Please enter the bits now: \n"
  pattern: .asciiz "Please enter the pattern to be searched: \n"
  nUser: .asciiz "Please enter the n: \n"
  count: .asciiz "\n Count is: \n"
  userBits: .space 32
  userPattern: .space 32
  n: .space 10
  reversedString: .space 40
  notApply: .asciiz " We cannot apply due to pattern size is greater than window size. "
  
.text
main:
   li $v0,4
   la $a0, enterBits
   syscall
   
   li $v0, 8
   la $a0, userBits
   li $a1, 32
   syscall
   
  
  move $a3, $a0#user string address is copied into $a3 
  move $s5, $a0#user string address is copied into $s5  
  move $s7, $a0# $s7 will be used to find the address of the last element
  move $s6, $a0# $s6 will be used in the recursive part of the function
  move $t1, $a0
  
   li $v0,4
   la $a0, pattern
   syscall 
     
   
   
   li $v0, 8
   la $a0, userPattern
   li $a1, 32
   syscall
   
   move $s3, $a0
   
   
   
   li $v0,4
   la $a0, nUser
   syscall   
  
      
   li $v0, 8
   la $a0, n
   li $a1, 10
   syscall
   
 determineSizeWindow:
  lb $t6, 0($a0)  #we used $s5 here
  beq $t6, 0x0A,determineSize
  addi $a0, $a0, 1 #increment size
  addi $t8, $t8, 1
  j determineSizeWindow
  
   
  #Firstly, I will reverse the user string

  
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
  move $s6, $a2
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
  
  
  la $a0, reversedString #the address of the reversed string will be argument in $a0
  move $a1, $s3 #input to search is taken as argument in $a1
  move $a2, $t8 # n is taken as argument in $a2
  move $t0, $a0
  
  li $t9, 0 #this will hold the count of the pattern in user string
  li $t7, 0 #this will hold the size of the pattern to be searched.
  jal checkPattern #Now, call the non-recursive function
  
  move $t9, $v0
  
  li $v0, 4
  la $a0, count
  syscall
  
  li $v0, 1
  move $a0, $t9
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
  
checkPattern:   
  # $a0 holds the address of the reversed string
  #$a1 holds the address of the pattern to be searched
  # $a2 holds the window size 
  move $t8, $a2 # $t8 will be used for checking
  move $t3, $a1
  la $a0, reversedString
  j sizePattern

sizePattern:  
#calculate the szie of the pattern to be searched.
  lb $t6, 0($t3)  #we used $t3 here
  beq $t6, 0x0A,sizeDone
  addi $t7, $t7, 1 #increment size
  addi $t3, $t3, 1
  j sizePattern
  
sizeDone: 
  #sgt $t6, $t7, $a2 #check whether if pattern size is greater than window size.
  #beq $t7, $a2, checkLoop
  #bnez $t6, cannotApply
  j checkLoop
  
checkLoop:
  beq $t8, $0, iterationDone
  beqz $s6, returnCount
  lb $t4, 0($a0)#get bit from user input
  lb $t5, 0($a1)#get bit from the pattern
  beq $t4,0x0A, returnCount
  bne $t4, $t5, goToAnotherWindowOrStay
  addi $a0, $a0, 1
  addi $a1, $a1, 1
  subi $t8, $t8, 1
  subi $s6, $s6, 1
  j checkLoop
  
goToAnotherWindowOrStay:
  slt $t6, $t7, $a2
  beq $t6, 1, checkLoop
  add $a0, $a0, $t8
  move $a1, $s3
  move $t8, $a2
  subi $s6, $s6, 1
  beqz $s6, returnCount
  j checkLoop
 
iterationDone:

  addi $t9, $t9, 1 
  move $t8, $a2
  move $a1, $s3
  subi $s6, $s6, 1 
  beqz $s6, returnCount
  j checkLoop 

returnCount:
  
  move $v0, $t9
  jr $ra
  
cannotApply:
  
 
  jr $ra

