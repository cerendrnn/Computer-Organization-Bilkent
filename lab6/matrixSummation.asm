####################################################################################################################

#Author: Aybüke Ceren Duran
#Matrix Part
#Section: 03

####################################################################################################################
.data

   message: .asciiz "\nHello there!\n"
   options: .asciiz "\nHere are your options: \n"
   optionsDisplay: .asciiz " 1.To create default matrix(with dimension N) which has consecutive values in its columns\n 2. To create your matrix(with dimension N)\n 3.Enter the matrix element to be accessed and also be displayed:\n 4.Obtain sum of matrix elements by row-major (row by row) summation\n 5. Obtain the sum of matrix elements by column-major (column by column) summation\n 6.Display entire row or column\n 7.Quit\n"
   userMatrixArray: .asciiz "Create an array with proper size\n"
   enterN: .asciiz "Please enter N for allocation of default matrix\n"
   userN: .asciiz "Please enter N for allocation of your matrix \n"
   writeDone: .asciiz "Storing consecutive elements is successfully done!\n"
   enterElement: .asciiz "Please enter your element into matrix: \n"
   done: .asciiz "Storing user elements is successfully done!\n"
   askRow: .asciiz "Please enter the row number which is i: \n"
   askColumn: .asciiz "Please enter the column number: which is j: \n"
   theElement: .asciiz "Here is the matrix[i][j]: \n"
   printColByCol: .asciiz "Here is the summation of matrix elements column-major (column by column) summation: \n"
   printRowByRow: .asciiz "Here is the summation of matrix elements row-major (row by row) summation: \n"
   croc: .asciiz " Enter 1 for display a row... \nEnter 0 for display a column...\n"
   enterRow: .asciiz "Please enter the row number to be displayed: \n"
   enterColumn: .asciiz "Please enter the column number to be displayed: \n"
   hereRow: .asciiz "Here is the row-"
   hereColumn: .asciiz"Here is the column-"
   ikinokta: .asciiz":\n"
   newBosluk: .asciiz " "
.text

matrixMenu:

   #we will assume that matrix elements will be placed column by column
   
   li $v0,4#display message
   la $a0,message
   syscall
   
   li $v0,4
   la $a0,options
   syscall
   
   li $v0,4#display options
   la $a0,optionsDisplay
   syscall
   
   li $v0,5
   syscall
   
   move $t7, $v0#copy user choice into $t7
   
   beq $t7, 1, defaultMatrixAllocation
   beq $t7, 2, userMatrixAllocation
   beq $t7, 3, displayElement
   beq $t7, 4, sumRowByRow
   beq $t7, 5, sumColByCol
   beq $t7, 6, displayRowOrColumn
   beq $t7, 7, quit 
 
   
   
   
defaultMatrixAllocation:
   
   li $v0,4
   la $a0, enterN
   syscall
   
   li $v0, 5
   syscall #Now, read N
   
   move $t8, $v0 #copy N for further use
   move $t2, $v0 #copy N into $t2  
   mul $t3, $t2, $t2#In this line I calculated N^2
   mul $a0, $t3, 4 #bytes to allocate matrix in heap   
   #memory allocation
   li $v0,9
   syscall
   
   move $s2, $v0 #base address is in $s2 now... 
   move $t5, $t3#for further use, I copied N^2 into $t5
   li $s5, 1#consecutive value = 1, in the function createDefaultMatrix it will be incremented
   jal createDefaultMatrix
   j promptMenu

createDefaultMatrix:
   addi $sp, $sp, -12
   sw $s2, 0($sp)#base address of the matrix is in the stack
   sw $ra, 4($sp)#ra of the matrix is in the stack
   sw $t5, 8($sp)#value of N^2 is in the stack

storeDefaultElements:
   
   sgt $t4, $s5, $t5
   beq $t4, 1, storeDone
   sw $s5, 0($s2)
   addi $s2, $s2, 4
   addi $s5, $s5, 1
   j storeDefaultElements
   
storeDone:

   li $v0,4
   la $a0, writeDone
   syscall

   lw $s2, 0($sp)#get original address of the base address of the matrix
   lw $ra, 4($sp)# get $ra
   lw $t5, 8($sp)#get tha value of N^2 from the stack
   addi $sp, $sp, 12
   jr $ra
   
userMatrixAllocation:

   li $v0,4
   la $a0, userN
   syscall
   
   li $v0, 5
   syscall #Now, read N
   
   move $t8, $v0 #copy N for further use
   move $t2, $v0 #copy N into $t2  
   mul $t3, $t2, $t2#In this line I calculated N^2
   mul $a0, $t3, 4 #bytes to allocate matrix in heap   
   #memory allocation
   li $v0,9
   syscall
   
   move $s2, $v0 #base address is in $s2 now... 
   move $t5, $t3#for further use, I copied N^2 into $t5
   move $s0, $t3#for further use, N^2 is copied into $s0
   li $s5, 1#this will be used in iteration
   jal createUserMatrix
   j promptMenu
   
createUserMatrix:

   addi $sp, $sp, -12
   sw $s2, 0($sp)#base address of the matrix is in the stack
   sw $ra, 4($sp)#ra of the matrix is in the stack
   sw $t5, 8($sp)#value of N^2 is in the stack

storeUserElements:
   
   sgt $t4, $s5, $t5
   beq $t4, 1, storingCompleted
   
   li $v0, 4
   la $a0, enterElement
   syscall
   
   li $v0, 5#user will enter the element into matrix
   syscall
   
   move $t9, $v0
   sw $t9, 0($s2)
   addi $s2, $s2, 4
   addi $s5, $s5, 1
   j storeUserElements
   
storingCompleted:

   li $v0,4
   la $a0, done
   syscall

   lw $s2, 0($sp)#get original address of the base address of the matrix
   lw $ra, 4($sp)# get $ra
   lw $t5, 8($sp)#get tha value of N^2 from the stack
   addi $sp, $sp, 12
   jr $ra   
     

displayElement:

   #ask the row
   li $v0, 4
   la $a0, askRow
   syscall
   
   li $v0, 5
   syscall
   
   move $s6, $v0 #copy the row number into $s6    i
   
   #ask the column
   li $v0, 4
   la $a0, askColumn
   syscall
   
   li $v0, 5
   syscall
   
   move $s7, $v0 #copy the column number into $s7      j
   
   #now, calculate the position according to displacement formula
   jal findDisplacement
   move $s3, $v0
   
   li $v0,4
   la $a0, theElement
   syscall
   
   #display matrix[i][j]
   lw $a0, 0($s3)
   li $v0,1
   syscall
   
   j promptMenu
   

findDisplacement:
   #formulation of the displacement is here: (j - 1) x N x 4 + (i - 1) x 4
   subi $s7, $s7, 1 # j-1
   mul $s7, $s7, $t2 # (j-1)*N
   mul $s7, $s7, 4#(j-1)*N*4
   subi $s6, $s6, 1#(i-1)
   mul $s6, $s6, 4#(i-1)*4
   add $t6, $s7, $s6
   add $s3, $s2, $t6 #compute the address of the target element
   
   move $v0, $s3 #put the address into return register
   jr $ra
   
sumColByCol:

   jal findSumColByCol
   move $s7, $v0
   
   li $v0,4
   la $a0, printColByCol
   syscall
   
   add $a0, $s7, $zero
   li $v0,1
   syscall   
   
   j promptMenu
   
      
findSumColByCol:
   
   li $s7, 0 #sum is initialized as 0
   subi $sp, $sp, 16
   sw $s2, 0($sp) # put the base address of the matrix into stack
   sw $t5, 4($sp) #put the value of N^2 into the stack
   sw $ra, 8($sp) #put the $ra into stack
   sw $t8, 12($sp)
   
calculateSumColumn:
  
   beqz $t5, calculationDone
   lw $t1, 0($s2)
   add $s7, $s7, $t1 #update the sum column by column
   add $s2, $s2, 4
   addi $t5, $t5, -1
   j calculateSumColumn
   
calculationDone:
   
   move $v0, $s7
   
   lw $s2, 0($sp) 
   lw $t5, 4($sp)
   lw $ra, 8($sp)   
   lw $t8, 12($sp)
   addi $sp, $sp, 16
   jr $ra
   
sumRowByRow:
   
   jal findSumRowByRow
   
   li $v0,4
   la $a0, printRowByRow
   syscall
   
   add $a0, $s7, $zero
   li $v0,1
   syscall  
   
   j promptMenu 
   
findSumRowByRow:

   li $s7,0 #sum is initialized as 0
   move $t4, $t8
   move $a3, $s2
   subi $sp, $sp, 16
   sw $s2, 0($sp) # put the base address of the matrix into stack
   sw $t5, 4($sp) #put the value of N^2 into the stack
   sw $ra, 8($sp) #put the $ra into stack
   sw $t8, 12($sp)
  
calculateSumRow:
   li $a2, 1
   move $t4, $t8
   move $s2, $a3
   beqz $t5, calculationDone2
   
internalLoop:
   beqz $t4, calculateSumRowBefore
   lw $t1, 0($s2)
   add $s7, $s7, $t1 #update the value of the sum
   mul $a2, $a2, $t8
   mul $a2, $a2, 4
   add $s2, $s2, $a2
   subi $t4, $t4, 1
   subi $t5, $t5, 1
   li $a2, 1   
   j internalLoop
   
calculateSumRowBefore:
  add $a3, $a3, 4
  j calculateSumRow
   
calculationDone2:

   lw $s2, 0($sp) 
   lw $t5, 4($sp)
   lw $ra, 8($sp)   
   lw $t8, 12($sp)
   addi $sp, $sp, 16
   
   move $v0, $s7
   jr $ra
    
   
promptMenu:

   j matrixMenu
   
   
displayRowOrColumn:

   li $v0, 4
   la $a0, croc
   syscall
   
   li $v0, 5
   syscall #enter
   
   move $s7, $v0
   beq $v0, 1, displayRow
   beq $v0, 0, displayColumn
   
displayRow:

   li $v0, 4
   la $a0, enterRow
   syscall   
   
   li $v0, 5
   syscall
   
   move $s7, $v0 #store row number in $s7
   jal dRow
   
   j matrixMenu
   
   
displayColumn:

   li $v0, 4
   la $a0, enterColumn
   syscall   
   
   li $v0, 5
   syscall
   
   move $s7, $v0 #store column number in $s7
   jal dColumn
   
   j matrixMenu
   
dRow:   
   addi $sp, $sp, -12
   sw $s2, 0($sp)#base address of the matrix is in the stack
   sw $ra, 4($sp)
   sw $t8, 8($sp)#value of N is in the stack
   move $a2, $t8
   
   li $v0, 4
   la $a0, hereRow
   syscall
  
      
   li $v0,1
   move $a0, $s7
   syscall
   
   li $v0, 4
   la $a0, ikinokta
   syscall
   
#calculate the base address of the row
calcAddresRow:
   beq $s7, 1,forRow
   add $s2, $s2, 4
   subi $s7, $s7, 1
   j calcAddresRow
   
forRow: 
    beq $a2, 0, dRowDone
    lw $a0, 0($s2)#load row element 
    li $v0,1 #display row element
    syscall
    
    li $v0, 4
    la $a0, newBosluk
    syscall
    
after:
    subi $a2, $a2, 1
    mul $t4, $t8, 4
    add $s2, $s2, $t4
    j forRow
    
    
dRowDone:
    
   lw $s2, 0($sp) 
   lw $ra, 4($sp)   
   lw $t8, 8($sp)
   addi $sp, $sp, 12
   
   jr $ra 
   
dColumn:   

   addi $sp, $sp, -12
   sw $s2, 0($sp)#base address of the matrix is in the stack
   sw $ra, 4($sp)
   sw $t8, 8($sp)#value of N is in the stack
   
   li $v0, 4
   la $a0, hereColumn
   syscall
   
   li $v0,1
   move $a0, $s7
   syscall
   
   li $v0, 4
   la $a0, ikinokta
   syscall
   
   #calculate the base address of the column
calcAddresCol:
   beq $s7, 1,forColumn
   mul $t4, $t8, 4
   add $s2, $s2, $t4
   subi $s7, $s7, 1
   
forColumn: 
    beq $t8, 0, dColumnDone
    lw $a0, 0($s2)#load column element 
    li $v0,1 #display column element
    syscall
    
    li $v0, 4
    la $a0, newBosluk
    syscall
    
then:
    subi $t8, $t8, 1
    add $s2, $s2, 4
    j forColumn
    
dColumnDone:
    
   lw $s2, 0($sp) 
   lw $ra, 4($sp)   
   lw $t8, 8($sp)
   addi $sp, $sp, 12
   
   jr $ra    
   
   
quit:   
   li $v0, 10
   syscall
   
