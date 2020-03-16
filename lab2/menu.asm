####################################################################################################################

#Author: Aybüke Ceren Duran
#Section: 03
#ID: 21302686

####################################################################################################################
.data
   enterSize:  .asciiz "Hello ! Enter the size of your array please: \n"
   ints: .asciiz "Please enter the numbers\n"
   thespace:   .asciiz "  "
   options : .asciiz "\nPress 1 to read your array \nPress 2 for bubble sort \nPress3 for third min. and max. of your array \nPress 4 for mode of elements \nPress 5 for print \nPress 6 for exit\n"
   thirdMax : .asciiz " \n The third max of the array is: "
   thirdMin : .asciiz " \n The third min of the array is: "
   themod: .asciiz " The mod is "
   elements: .asciiz "\nNow, enter the elements for your array:\n"
   address: .asciiz "\n Here is the address of the beginning of the array: \n"
   size: .asciiz "\nHere is the size of the array: \n"
   dot: .asciiz "-) "
   zeroo: .asciiz "size cannot be zero\n"
   modeArray: .space 40
#################################################################################################################### 
   
.text

pressing:   
   li $v0,4 
   la $a0, options
   syscall
   
   li $v0,5 #get user's choice
   syscall  
   
   beq $v0, 1, option1
   beq $v0, 2, option2
   beq $v0, 3, option3
   beq $v0, 4, option4
   beq $v0, 5, option5
   beq $v0, 6, option6
   
option1:
   
   jal readArray
   
   move $s1, $v0 # address is here
   move $s2, $v1 #size is here
   
   li $v0, 4
   la $a0, address
   syscall
   
   li $v0,1
   add $a0, $s1, $zero
   syscall
   
   li $v0, 4
   la $a0, size
   syscall
   
   li $v0,1
   add $a0, $s2, $zero
   syscall
   
   j pressing
   
option2: 
   
   move $a0, $s1 #address is copied into $a0
   move $a1, $s2 #size is copied into $a1
   
   #void bubbleSort( DataType theArray[], int n) {
   #bool sorted = false; 
   
    #for (int pass = 1; (pass < n) && !sorted; ++pass) {  
      #sorted = true; 
      #for (int index = 0; index < n-pass; ++index) {
         #int nextIndex = index + 1;
         #if (theArray[index] < theArray[nextIndex]) {  
            #swap(theArray[index], theArray[nextIndex]);
            #sorted = false; // signal exchange
         #}
      #}
   #}
#}
     
   jal bubble
   
   j pressing
   
option3:
   move $a0, $s1#address is copied    $a reg?sters are used as parameters.....
   move $a1, $s2 #size is copied into
   jal find3rdMinMax
   
   move $t8, $v0 #put the third max into $t8
   move $t6, $v1 #put the third min into $t9
   
   li $v0, 4
   la $a0, thirdMax
   syscall
   
   li $v0, 1
   add $a0, $t8, $zero
   syscall
   
   li $v0, 4
   la $a0, thirdMin
   syscall
   
   li $v0, 1
   add $a0, $t6, $zero
   syscall
    
   
   j pressing

option4: #TO DO MULTIPLE MODES SMALL ONES
  
   move $a0, $s1
   move $a1, $s2
   la $s4, modeArray
   
   jal mode  
   
   move $t8, $v0
   
   li $v0, 4
   la $a0, themod
   syscall
   
   li $v0,1
   add $a0, $t8, $zero
   syscall
   
   j pressing
   
  
   
option5:#tTO DO PRINT SIZE=0 CASE'? EKS?K
   move $a0, $s1 #address of the array is the argument of the function
   move $a1, $s2 #size of the array is the argument of the function
   jal printNow
  
   j pressing

option6:
   li $v0,10 
   syscall
   
mode: 
    #public static int findMode(int[] a)
    #{
        #int index = 0  ;
        #int soFar = 1 ; 
        #int count = 1 ; 
        #for(int k =1;   k < a.length; k++){
            #if (a[k-1] == a[k]){
                #count++ ; }
            #if(count > soFar)
            #{ 
                #soFar = count ; 
                #index = k -1;       #CORRECTED THIS LINE!!!!!!!
                #count =1;           #CORRECTED THIS LINE!!!!!!!
            #}
            #else {
                #count = 1 ; 
            #}
        #}
        #return a[index] ; 
    #}
        
    addi $sp, $sp, -16
    sw $ra, 12($sp) 
    jal bubble2#bubble2 is the bubble sort without absolute value
    #now we have sorted array
    li $t0, 0#index=0
    li $t1, 1#sofar=1
    li $t2, 1#count=1
    li $t3, 1#k=1
    li $t4, 1#i=1 for memory calculations
    move $s7, $s1
    sw $s1,0($sp) #store the address in the stack
    sw $s2,4($sp) #store the size in the stack because after that we will change its value
    sw $ra,8($sp)
    move $s3, $s1
    j for

for: beq $s2, $t3, giveResult # compare k and size of the array
     mul $t4, $t3, 4#for memory iteration
     add $t7, $s1, $t4 # $t7 holds the a[k]
     lw $t5, 0($t7)
     lw $t8, 0($s7) # $t8 holds the a[k-1]   
     beq $t8, $t5, incrementCount
     bgt $t2, $t1, updateSoFar
     li $t2, 1# else count=1;
     addi $t3, $t3, 1#k++
     #addi $t4, $t4, 1
     addi $s7, $s7, 4
     
     j for

incrementCount:
     addi $t2, $t2, 1#count++
     addi $t3, $t3, 1#k++
     #addi $t4, $t4, 1
     addi $s7, $s7, 4
     j for
    
updateSoFar:
     move $t1, $t2
     subi $s5, $t3, 1
     move $t0, $s5
     addi $t3, $t3, 1
     li $t2, 1
     #addi $t4, $t4, 1
     addi $s7, $s7, 4
     j for
          
giveResult:
     #return here   
     mul $t0, $t0, 4
     add $s3, $s1, $t0
     lw $t6, 0($s3)
    
     move $v0, $t6 #return a[index]
     
     lw $s1,0($sp) 
     lw $s2,4($sp) 
     lw $ra,8($sp) 
     lw $ra, 12($sp)
     addi $sp, $sp, 16
     
     jr $ra
     
   
find3rdMinMax: 
     addi $sp, $sp, -24
     sw $ra, 12($sp) 
     sw $t0, 16($sp)
     sw $t1, 20($sp)
     jal bubble2#bubble2 is the bubble sort without absolute value
     #now we have sorted array
     #and we assumed that the array has at least 3 elements.
     #in the last step of bubble sort version 2
     #the address of the array is in $a0 and $s1, the size of the array is in $a1 and $s2.
     #the array is in descending order
     sw $s1,0($sp) #store the address in the stack
     sw $s2,4($sp) #store the size in the stack because after that we will change its value
     sw $ra,8($sp)
     
     lw $t7, 8($s1) # load the 3rd max. into $t7.
     move $t0, $s2
     move $t1, $s1,
     #subi $t0, $t0, 0#size-1
     mul $t0, $t0, 4
     add  $t1, $t1, $t0
     sub $s2, $s2, 2 #so that we can find third min 
     mul $s2, $s2, -4
     add $t1, $t1, $s2
     lw $t9,0($t1)
     move $v0, $t7 #return 3rd max
     move $v1, $t9 #return 3rd min
     
     lw $s1,0($sp) 
     lw $s2,4($sp) 
     lw $ra,8($sp) 
     lw $ra, 12($sp)
     lw $t0, 16($sp)
     lw $t1, 20($sp)
     addi $sp, $sp, 24
     
     j doneFinding
     
doneFinding:      
    jr $ra

bubble2:  

  li $s3, 0 # boolean part (in pseudocode bool sorted = false:)          
  addi $sp, $sp, -12
  sw $a0, 0($sp) #address is put in stack 
  sw $a1, 4($sp)#the size is put on stack
  sw $ra, 8($sp)# $ra is on the stack
  
  #la $s4, 0($s1) # this is used for 'for' loop
  #li $s5, 0 #index = 0
  #li $t4, 0 #nextindex = 0
  li $t8, 1#pass = 1
  move $t0, $a0 #address is copied
  move $t1, $a1#size is copied
  j bubbleSort2

bubbleSort2: #for (int pass = 1; (pass < n) && !sorted; ++pass) {
  #IN THIS BRANCH, CONDITIONS OF EXTERNAL LOOP IS CHECKED.
  #pass=t8  t1 = size
  bnez $s3, not12
  beqz $s3, not22 
  
not12:
  li $s3, 0
  li $t4, 0
  li $s5, 0
  j continue2
not22:
  li $s3, 1
  li $t4, 0
  li $s5, 0
  j continue2
  
continue2:
  #not $s7, $s3# !sorted
  move $s7, $s3
  slt $t7, $t8, $t1 #check pass<n
  and $t9, $s7, $t7 # check the conditions of the external loop
  beqz $t9, endOfBubbleSort2
  li $s3, 1#sorted = true;
  bnez $t9,bubbleExternalLoop2#begin to execute instructions in externalLoop
 
bubbleExternalLoop2: #INSTRUCTIONS OF EXTERNAL LOOP ARE HERE
  #s5=index t4=nextindex
  #IN THIS BRANCH, SORTED=TRUE IS DONE, AND ALSO WE CHECKED THE CONDITIONS OF INTERNAL LOOP
  sub $s6, $t1, $t8 # n-pass is calculated here
  slt $t7, $s5, $s6 #check index<n-pass
  bnez $t7,bubbleInternalLoop2
  addi $t8, $t8, 1 #pass++
  beqz $t7, bubbleSort2

bubbleInternalLoop2: 
  addi $t4, $s5, 1 #int nextIndex = index + 1;
  move $a2, $s5
  move $a3, $t4
  #CONDITION OF THE IF STATEMENT WILL ALSO BE CHECKED IN THIS BRANCH
  sll $a3, $a3, 2
  sll $a2, $a2, 2
  add $s4, $a0, $a2 #for array[index]
  add $s7, $a0, $a3 #for array[index+1]
  lw $t7, 0($s4)#we get array[index]
  lw $t9, 0($s7)#we get array[index+1]
  #abs $t7, $t7#get the absolute value of the element
  #abs $t9, $t9#get the absolute value of the element
  slt $s6, $t7, $t9
  bnez $s6, swap2
  addi $s5, $s5, 1 #index++
  beqz $s6, bubbleExternalLoop2
swap2:
  #$s6 will be used as temp variable
  move $s6, $t7
  sw $t9, 0($s4)
  sw $s6, 0($s7)
  li $s3, 0 #sorted = false again
  addi $s5, $s5, 1
  j bubbleExternalLoop2
  
endOfBubbleSort2:
   
   lw $a0,0($sp)
   lw $a1,4($sp)
   lw $ra,8($sp)
   addi $sp, $sp, 12
   
   move $s1, $a0 # address is again in $s1
   move $s2, $a1 
      
   jr $ra     

printNow: 
    
     addi $sp, $sp, -16
     sw $a0, 0($sp)
     sw $a1, 4($sp)
     sw $ra, 8($sp)
     sw $s1, 12($sp)
     j print
  
print:
     beqz $a1, pressing
    
     
     lw $a0, 0($s1)
     li $v0, 1
     syscall
    
     
     li $v0, 4
     la $a0, thespace
     syscall
     
     beq $a1, 1, endOfPrint# display the options
     addi $s1, $s1, 4 #trace next element
     subi $a1, $a1, 1 #subtract the size now
     j print

endOfPrint:

     lw $a0, 0($sp)
     lw $a1, 4($sp)
     lw $ra, 8($sp)
     lw $s1, 12($sp)
     addi $sp, $sp, 16
     
     jr $ra
    

bubble:  

  li $s3, 0 # boolean part (in pseudocode bool sorted = false:)          
  addi $sp, $sp, -12
  sw $a0, 0($sp) #address is put in stack 
  sw $a1, 4($sp)#the size is put on stack
  sw $ra, 8($sp)# $ra is on the stack
   
  #la $s4, 0($s1) # this is used for 'for' loop
  #li $s5, 0 #index = 0
  #li $t4, 0 #nextindex = 0
  li $t8, 1#pass = 1
  move $t0, $a0 #address is copied
  move $t1, $a1#size is copied
  j bubbleSort

bubbleSort: #for (int pass = 1; (pass < n) && !sorted; ++pass) {
  #IN THIS BRANCH, CONDITIONS OF EXTERNAL LOOP IS CHECKED.
  #pass=t8  t1 = size
  bnez $s3, not1
  beqz $s3, not2
 
  
not1:
  li $s3, 0
  li $t4, 0
  li $s5, 0
  j continue
not2:
  li $s3, 1
  li $t4, 0
  li $s5, 0
  j continue
  
continue:
  #not $s7, $s3# !sorted
  move $s7, $s3
  slt $t7, $t8, $t1 #check pass<n
  and $t9, $s7, $t7 # check the conditions of the external loop
  beqz $t9, endOfBubbleSort
  li $s3, 1#sorted = true;
  bnez $t9,bubbleExternalLoop #begin to execute instructions in externalLoop
 
bubbleExternalLoop: #INSTRUCTIONS OF EXTERNAL LOOP ARE HERE
  #s5=index t4=nextindex
  #IN THIS BRANCH, SORTED=TRUE IS DONE, AND ALSO WE CHECKED THE CONDITIONS OF INTERNAL LOOP
  sub $s6, $t1, $t8 # n-pass is calculated here
  slt $t7, $s5, $s6 #check index<n-pass
  bnez $t7,bubbleInternalLoop
  addi $t8, $t8, 1 #pass++
  beqz $t7, bubbleSort

bubbleInternalLoop: 
  addi $t4, $s5, 1 #int nextIndex = index + 1;
  move $a2, $s5
  move $a3, $t4
  #CONDITION OF THE IF STATEMENT WILL ALSO BE CHECKED IN THIS BRANCH
  sll $a3, $a3, 2
  sll $a2, $a2, 2
  add $s4, $a0, $a2 #for array[index]
  add $s7, $a0, $a3 #for array[index+1]
  lw $t7, 0($s4)#we get array[index]
  lw $t9, 0($s7)#we get array[index+1]
  sw $t7, 12($sp)
  sw $t9, 16($sp)
  abs $t7, $t7#get the absolute value of the element
  abs $t9, $t9#get the absolute value of the element
  slt $s6, $t7, $t9
  lw $t7, 12($sp)
  lw $t9, 16($sp)
  bnez $s6, swap
  addi $s5, $s5, 1 #index++
  beqz $s6, bubbleExternalLoop
swap:
  #$s6 will be used as temp variable
  move $s6, $t7
  sw $t9, 0($s4)
  sw $s6, 0($s7)
  li $s3, 0 #sorted = false again
  addi $s5, $s5, 1
  j bubbleExternalLoop
  
endOfBubbleSort:
   
   lw $a0,0($sp)
   lw $a1,4($sp)
   lw $ra,8($sp)
   addi $sp, $sp, 20
   
   move $s1, $a0 # address is again in $s1
   move $s2, $a1 
      
   jr $ra

zeroMessage:
   li $v0, 4
   la $a0, zeroo
   syscall
   
   j pressing
   
   
readArray:
   li $v0,4
   la $a0, enterSize
   syscall
   
   li $v0, 5
   syscall
   
   beqz $v0,zeroMessage
   
   move $s0, $v0 #user's array size is copied into $s0
   move $t2, $v0#for further use, it is copied.
   
   sll $a0, $v0, 2 # ALLOCATE $v0*4 bytes 2^2
   li $v0,9
   syscall #ALLOCATED SPACE PART IS HERE
      
   move $s1, $v0 #user's array address is copied into $s1.
   li $t0, 0#this will be used for iteration in the entering elements part.
   addi $t6, $t6, 1 # $t6 is used for entering 1-)... 2-)...
   
   #now the user can enter the array elements
   li $v0, 4
   la $a0, elements
   syscall    
   
   
   addi $sp, $sp, -12
   sw $s0, 0($sp)#$s0 is on the stack
   sw $s1, 4($sp)#$s1 is on the stack, the contents of $s1 will change in enterElements branch but original valued is saved here.
   sw $ra, 8($sp)# $ra is on the stack
  
   
   jal enterElements
   lw  $s0, 0($sp)
   lw  $s1, 4($sp)
   lw  $ra, 8($sp)
   addi $sp, $sp, 12
   
   move $v0, $s1
   move $v1, $s0
   jr $ra   
   
  
 
enterElements:
   li $v0, 1
   add $a0, $t6, $zero
   syscall
      
   li $v0, 4
   la $a0, dot
   syscall       
     
   li $v0, 5
   syscall      
      
   addi $t6, $t6, 1
   
   sw $v0, 0($s1)#store the element user entered
   seq $t7, $t2, 1
   beq $t7, 1, enteringOver
   addi $s1, $s1,4 #its is time for next element
   subi $t2, $t2, 1 #subtract the size by 1 now
   j enterElements

enteringOver:
   
   jr $ra #end of enterElements function, now go to readArray function again.
   

   
   
   
   
 
   
   
   
