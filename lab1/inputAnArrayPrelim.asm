####################################################################################################################

#Author: Aybüke Ceren Duran
#Lab01 Preliminary question 01
#Section: 03
#ID: 21302686

####################################################################################################################

.data
    userArray: .space 80
    revArray: .space 80 #this array is allocated for user's reversed version array
    message: .asciiz "\nHello there! Please enter the size of the array: "
    elements: .asciiz "\nNow, enter the elements for your array:\n"
    warning: .asciiz "The size you have entered is invalid. You must enter max. 20 \n"
    display: .asciiz "Your array elements: "
    reverseArray: .asciiz "This is the reversed version of your array: "
    done: .asciiz "\n Bye stranger :) "
    thespace:.asciiz "  "
    dot: .asciiz "-) "
        
 .text
 
   welcome:
       #t1 holds the max. size which is 20
       li $t1, 20
       li $s6, 0
       
       #display the message
       li $v0, 4
       la $a0, message
       syscall
       #user will enter the size
       li $v0, 5
       syscall
       j validateSize
       
   validateSize: 
       sgt $s1, $v0, $t1 #this instruction decides whether if the user array size exceeds max. size
       bnez $s1, warnTheUser
       beqz $s1, enterElementsMessage
   
   warnTheUser:
       #display the message
       li $v0, 4
       la $a0, warning
       syscall
       b  welcome #branch welcome now
       
   enterElementsMessage:
      # $t2 will hold the user array size for further use
      # $t3 will hold the address of the array
      
      la $a1, userArray
      la $s7, revArray #it will hold the reverse array address for further use.
      
      move $t3, $a1
      move $t2, $v0
      move $t6, $v0
      move $s3, $v0
      move $t5, $a1 #for further use, we have copied
      
      addi $s6, $s6, 1
      
      #now the user can enter the array elements
      li $v0, 4
      la $a0, elements
      syscall
      
   enterElements:
      li $v0, 1
      add $a0, $s6, $zero
      syscall
      
      li $v0, 4
      la $a0, dot
      syscall     
      
     
      li $v0, 5
      syscall
      
      addi $s6, $s6, 1
      
      sw $v0, 0($t3)#store the element user entered
      seq $t7, $t2, 1
      beq $t7, 1, enteringOver
      addi $t3, $t3,4 #its is time for next element
      subi $t2, $t2, 1 #subtract the size by 1 now
      j enterElements
      
   enteringOver:
      li $v0,4
      la $a0, display
      syscall
      j displayElements
  
   displayElements: 
      
     lw $a0, 0($a1)
     li $v0, 1
     syscall
     
     li $v0, 4
     la $a0, thespace
     syscall
     
     beq $t6, 1, reverseElementsMessage# display completed, it is time for reverse version
     addi $a1, $a1, 4 #trace next element
     subi $t6, $t6, 1 #subtract the size now
     j displayElements
     
   reverseElementsMessage:
     li $v0,4
     la $a0, reverseArray
     syscall
     
   reverseNow:      
     lw $t4, 0($a1) #copy the last element of the user's array.
     sw $t4, 0($s7) #copy from user's array element into reversed array.  
     
     lw $a0, 0($s7)
     li $v0, 1
     syscall      
     
     li $v0, 4
     la $a0, thespace
     syscall
     
     beq $s3, 1, finish    
     add $s7, $s7, 4
     sub $a1, $a1, 4
     subi $s3, $s3, 1 #subtract the size now 
    
     j reverseNow   
     
     
   finish:
   
     li $v0,4
     la $a0, done
     syscall
     
     li $v0, 10
     syscall
     
     
     
     
     
     
     
    
      
   
                
      
      
   
       
      
       
       
       
      
    
    
    
    
