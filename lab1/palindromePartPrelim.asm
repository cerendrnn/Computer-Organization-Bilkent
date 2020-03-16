####################################################################################################################

#Author: Aybüke Ceren Duran
#Lab01 Preliminary question 02
#Section: 03
#ID: 21302686

####################################################################################################################

.data
    userArray: .space 80
    message: .asciiz "\nHello there! Please enter the size of the array: "
    elements: .asciiz "\nNow, enter the elements for your array:\n"
    warning: .asciiz "The size you have entered is invalid. You must enter max. 20 \n"
    display: .asciiz "Your array elements: "
    done: .asciiz "\n Bye stranger :) "
    thespace:.asciiz "  "
    dot: .asciiz "-) "
    yes: "\n YES, IT IS A PALINDROME \n"
    no: "\n NO, IT IS NOT A PALINDROME \n"
    end:"\n THE END :)\n"
        
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
      
      beqz $v0, yesPalindrome #if the size is 0, the array is palindrome
      beq  $v0, 1, yesPalindrome #if the size is 1, the array is palindrome      
      la $a1, userArray
      move $t3, $a1
      move $t2, $v0
      move $s7, $v0
      move $t6, $v0
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
     
     beq $t6, 1, computeMiddle# display completed, it is time for reverse version
     addi $a1, $a1, 4 #trace next element
     subi $t6, $t6, 1 #subtract the size now
     j displayElements
  
  computeMiddle:
  
     #now we will hold the address of the middle element
     #add $t4, $t5, $a1
     #srl $t4, $t4, 1 #now $t4 holds the address of the middle element of the array
     sra $t4, $s7, 1
     
     j palindromeDecision
  
  palindromeDecision:
  
    #compare the elements from begin and end
    
    lw $s4, 0($t5) #load from begin
    lw $s5, 0($a1) #load from end
    
    bne $s4, $s5, noPalindrome
    addi $t5, $t5, 4 #update left side
    subi $a1, $a1, 4 #update right side
    addi $t4,$t4,-1 #decrement the midpoint to trace the comparisons
    beq  $t4, 0, yesPalindrome
    #beq $t4, $t5, checkMiddleRight
    j palindromeDecision
    
  checkMiddleRight:
  
    beq $a1, $t4, yesPalindrome
        
  yesPalindrome:
     li $v0,4
     la $a0, yes
     syscall
     
     j endingScene
 
 noPalindrome:
     li $v0,4
     la $a0, no
     syscall
     
     j endingScene
     
 endingScene:
     li $v0,4
     la $a0,end
     syscall
     
     li $v0,10
     syscall
   
