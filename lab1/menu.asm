####################################################################################################################

#Author: Aybüke Ceren Duran
#Part 5
#Section: 03
#ID: 21302686

####################################################################################################################
.data 
   userArray: .space 400
   message: .asciiz "\nHello there! Please enter the size of the array: "
   warning: .asciiz "The size you have entered is invalid. You must enter max. 100 \n"
   elements: .asciiz "\nNow, enter the elements for your array:\n"
   display: .asciiz "Your array elements: "
   done: .asciiz "\n Bye stranger :) "
   options: .asciiz "\n Here are your options: \n Press 1 for finding summation of numbers stored in the array which is less than an input number. \n Press 2 for finding summation of numbers out of a value range specified by two numbers and display that value. \n Press 3 for displaying the number of occurrences of the array elements divisible by a certain input number. \n Press 4 for quit \n Enter your option: \n"
   dot: .asciiz "-) "
   thespace:.asciiz "  "
   invalidNumber: .asciiz "\n This is invalid option! You must enter between 1 and 4\n"
   enterInput:.asciiz  "\n Enter input for summation: "
   lessMessage: .asciiz "\n Here is the summation of the numbers which are less than the input you entered:\n"
   enterRange1: .asciiz "\n Enter range input 1: \n"
   enterRange2: .asciiz "\n Enter range input 2: \n"   
   rangeSum: .asciiz  "\n Range sum is: \n"
   occurrenceMessage: .asciiz " \n Enter input to divide:\n "
   occurrenceResult: .asciiz "\n Number of occurrences of the array elements divisible by given input: \n"
   userArraySize: .word 0
.text
   welcome:
       #t1 holds the max. size which is 20
       li $t1, 100
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
          
      move $t3, $a1 #array address copied
      move $t2, $v0 #size copied
      move $t6, $v0
      move $s3, $v0
      move $t5, $a1 #for further use, we have copied
      sw $v0, userArraySize
      
      addi $s6, $s6, 1 # $s6 is used for entering 1-)... 2-)...
      
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
      move $t2, $t6#size is copied again
      move $t3, $t5#array address is copied again
      
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
     
     beq $t6, 1, userOptions # display the options
     addi $a1, $a1, 4 #trace next element
     subi $t6, $t6, 1 #subtract the size now
     j displayElements
   
   userOptions:
      
     li $v0,4
     la $a0, options
     syscall
     
     li $v0, 5
     syscall
     
     move $a1, $v0
     
     blt $a1,1, warnOption
     bgt $a1,4, warnOption
     beq $a1,1, lessThan
     beq $v0,2, range
     beq $v0,3, occurrence
     beq $v0,4, quit    
     
   warnOption:
   
     li $v0, 4
     la $a0, invalidNumber
     syscall
     
     j userOptions
     
   lessThan: 
     
     move $t6, $zero #sum is zero initially
     li $v0,4
     la $a0, enterInput
     syscall
     
     li $v0, 5 #enter the input
     syscall
     
     move $s5, $v0
     
   traceLessElements:
   
     lw $t7, 0($t5)
     slt $s4, $t7, $s5 #check whether if the array element is less than input
     bnez $s4, sumLess
     
     beq $s3, 1, finishTraceLess   
     add $t5, $t5, 4
     subi $s3, $s3, 1 #subtract the size now 
     
     j traceLessElements
     
   sumLess:
     
     add $t6, $t6, $t7
     beq $s3, 1, finishTraceLess
     add $t5, $t5,4
     subi $s3, $s3, 1
     j traceLessElements
     
  finishTraceLess:
  
     li $v0,4
     la $a0, lessMessage
     syscall
     
     li $v0, 1
     add $a0,$t6,$zero
     syscall
     
     j userOptions
     
   range: 
   
     move $t6, $zero #summation is zero initially
     li $v0,4
     la $a0, enterRange1
     syscall
     
     li $v0,5
     syscall
     
     move $s5, $v0#range 1 is copied
     
     li $v0,4
     la $a0, enterRange2
     syscall
     
     li $v0,5 
     syscall
          
     move $s7, $v0#range 2 is copied 
     
   rangeTrace:
      lw $t8, 0($t3)#check elements for the ranges
      sgt $t9, $t8, $s5 #check whether the array element is greater than range1
      slt $s0, $t8, $s7 #check whether the array element is less than range2
      and $s3, $t9, $s0 #check whether both conditions are satisfied
      beq $s3, 0, sumRange
      addi $t3, $t3, 4
      subi $t2, $t2, 1
      beq $t2, 0, displayRangeSum
      j rangeTrace
   
   sumRange:
     
      add $t6, $t6, $t8 #update the result of sum, if both conditions are satisfied.
      addi $t3, $t3, 4
      subi $t2, $t2, 1
      beq $t2, 0, displayRangeSum      
      j rangeTrace    
   
   displayRangeSum:
   
      li $v0, 4
      la $a0, rangeSum
      syscall
      
      li $v0, 1
      move $a0, $t6
      syscall
      
      j userOptions
      
   occurrence:
   
      li $s4, 0#$t9 will hold the result
     
      li $v0, 4
      la $a0, occurrenceMessage
      syscall
      
      li $v0, 5
      syscall
      move $t6, $v0 #input for dividing is copied into $t6
      
      
      la $a0, userArray # address of the array is copied for tracing its elements
      move $t3, $a0 #the address is copied into $t3
      la $a1, userArraySize
      lw $t2, 0($a1)#t2 holds the size of the array
      j divisibleLoop
      
   divisibleLoop:
   
      lw $t8, 0($t3) #get the element of the array
      div $t8, $t6
      mfhi $s1 #get the remainder
      beq $s1, 0, updateOccurrence
      addi $t3, $t3, 4#go to next element
      subi $t2, $t2, 1
      beq $t2, 0, displayOccurrence
      j divisibleLoop
      
   updateOccurrence:
      
      addi $t3, $t3, 4#go to next element
      subi $t2, $t2, 1
      addi $s4, $s4, 1
      beq $t2, 0, displayOccurrence
      j divisibleLoop     
      
   displayOccurrence:
      
      li $v0, 4
      la $a0, occurrenceResult
      syscall
      
      move $a0, $s4
      li $v0,1
      syscall
      

      j userOptions
         
   quit:
   
     li $v0,4
     la $a0, done
     syscall
     
     li $v0, 10
     syscall
     
     
          
         
     
     
     #used registers: $t1, $s6, $s1 t2 t3 t6 s3 t5 t7 s4 s5 t8 t9  s0
   
