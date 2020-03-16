####################################################################################################################

#Author: Aybüke Ceren Duran
#Lab01 Preliminary question 03
#Section: 03
#ID: 21302686

####################################################################################################################

.data
   input1: .asciiz "Please enter your first input as integer: \n"
   input2: .asciiz "Please enter your second input as integer: \n"
   welcome: .asciiz "Hello there! \n"
   results: .asciiz "Here are the results: \n"
   division: .asciiz "Here is the division: "
   blank: .asciiz "\n"
   remainder: .asciiz "\nHere is the remainder: "
   bye: .asciiz "\nBye :) "
   
.text

 entering:
   li $v0, 4
   la $a0, welcome
   syscall
   
   li $v0, 4
   la $a0, input1
   syscall
   
   li $v0,5 
   syscall
   
   move $t0, $v0#input1 is copied
   move $t2, $v0#input1 is copied for further use in the loop

   li $t3, 0#this is for holding the result, for quotient (case: all inputs are positive)
   li $t4, 0#this is for holding remainder
   li $t5, 0#this is for holding the result, for quotient (case: all inputs are positive)
   li $s0, 0#for checking sign of inputs for further use
   li $s1, 0#for checking sign of inputs for further use
   li $s2, 0# this is for OR operation for further use
   li $s3, 0#this is for AND operation for further use
   li $s4, 0#this is for XOR operation for further use
      
   li $v0, 4
   la $a0, input2
   syscall
   
   li $v0,5 
   syscall
   
   move $t1, $v0 #input2 is copied
   
   checkSignOfInputs:
     slt $s0, $t0, $zero #check the sign of input1     
     slt $s1, $t1, $zero #check the sign of input2
     or $s2, $s1, $s0 #s2=0 go to allPositiveLoop
     and $s3, $s1, $s0
     xor $s4, $s1, $s0 #if inputs have different sign 
     beq $s2, 0, allPositiveLoop
     beq $s3, 1, allNegativeLoop
     beq $s4, 1, difSignLoop
     
   difSignLoop:
     bgez $t0, difSignLoop1
     blez $t0, difSignLoop2
     
   difSignLoop1:
     blez  $t2, findRemainder
     add $t2, $t2, $t1
     subi $t3, $t3, 1
     j difSignLoop1
     
   difSignLoop2:
     bgez $t2, findRemainder
     add $t2, $t2, $t1
     sub $t3, $t3, 1
     j difSignLoop2
   
   #if all the inputs are positive, go to allPositiveLoop  
   allPositiveLoop: 
    
     blt $t2, $t1, findRemainder
     sub $t2, $t2, $t1
     addi $t3, $t3, 1
     j allPositiveLoop
     
  #if all the inputs are negative, go to allNegativeLoop     
  allNegativeLoop:
   
     sge $t7, $t2, $zero
     beq $t7, 1, findRemainder
     sub $t2, $t2, $t1
     addi $t5, $t5, 1
     j allNegativeLoop         
     
   findRemainder:
      
     rem $t4, $t0, $t1     
      
  printResults:  
              
      li $v0,4
      la $a0, results
      syscall
      
      li $v0, 4
      la $a0, division
      syscall
      
      beq $s2, 0, printPosRes
      beq $s3, 1, printNegRes
      
  printPosRes:
        
      li $v0, 1
      move $a0, $t3
      syscall
      
      li $v0, 4
      la $a0, remainder
      syscall
      
      li $v0,1
      move $a0, $t4
      syscall
      
      j done
      
 printNegRes:
     
      li $v0, 1
      move $a0, $t5
      syscall
      
      li $v0, 4
      la $a0, remainder
      syscall
      
      li $v0,1
      move $a0, $t4
      syscall
      
      j done
  
  done:
    
     li $v0,4
     la $a0, bye
     syscall
     
     li $v0, 10
     syscall
  
      
      
   
  
   
   
   
   
   
  
 
   
   
