##
##	Program3.asm is a loop implementation
##	of the Fibonacci function
##        

#################################
#					 	#
#		text segment		#
#						#
#################################

	.text		
.globl __start
 
__start:		# execution starts here
	li $s1,2
	li $a0,7	# to calculate fib(7)
	jal fib		# call fib
	move $a0,$v0	# print result
	li $v0, 1
	syscall

	la $a0,endl	# print newline
	li $v0,4
	syscall
	
	li $v0, 4
	la $a0, enterInput
	syscall
	
	li $v0, 5
	syscall
	
	move $t3, $v0 #store user input here
	
	div $t3, $s1
	mfhi $t4
	
	beqz $t4, calFact #even call factorial
	bnez $t4, calFib #0dd call fibonacci
	
 calFib:
       move $a0, $t3
       jal fib
       move $t8, $v0
       j valueFib
       
 calFact:
      move $a0, $t3
      jal fact
      move $s5, $v0
      j valueFact
      
valueFib:
     li $v0, 4
     la $a0, val
     syscall
     
     li $v0,1
     move $a0, $t8
     syscall    
     
     j end
valueFact:

    li $v0, 4
     la $a0, val
     syscall
     
     li $v0,1
     move $a0, $s5
     syscall    
     
     j end
    

 end:

	li $v0,10
	syscall		# bye bye

#------------------------------------------------


fib:	move $v0,$a0	# initialise last element    call fib(7)
	blt $a0,2,done	# fib(0)=0, fib(1)=1

	li $t0,0	# second last element
	li $v0,1	# last element

loop:	add $t1,$t0,$v0	# get next value
	move $t0,$v0	# update second last
	move $v0,$t1	# update last element
	sub $a0,$a0,1	# decrement count
	bgt $a0,1,loop	# exit loop when count=0   CHANGE MADE HERE
done:	jr $ra

fact:  move $t6, $a0
       move $t7, $t6
       move $t9, $t6
       bgt $t6, 1, calculate
       beq $t6, 1, complete

calculate:
       sub $t9, $t9, 1
       mul $t7, $t7, $t9
       move $t6, $t7
       beq $t9, 1, complete
       j calculate
       
complete:
      move $v0, $t6
      jr $ra

#################################
#					 	#
#     	 data segment		#
#						#
#################################

	.data
endl:	.asciiz "\n"
enterInput: .asciiz"\nEnter your input: "
val: .asciiz"\nThe result is: "
##
## end of Program3.asm
