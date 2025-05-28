.data
Array: .space 5000
input_size: .asciiz "Please enter your size of array: \n"
input_numb: .asciiz "Please enter your array below\n"
input_integer: .asciiz "Please enter your Integer at i= "
output_title: .asciiz "You have enter: \n"
output_array: .asciiz "\nHere is the sorted list in ascending order: "
output_space: .asciiz " "
next_line: .asciiz "\n"

.text
.globl main
main:

    #print the messages input_size
    li $v0,4
    la $a0,input_size
    syscall

    #get size of array
    li $v0,5
    syscall
    move $s0,$v0

    # print the messages input_numb
    li $v0,4
    la $a0,input_numb
    syscall

    addi $t0,$zero,0 # init i = 0

    input_loop:
        bge $t0,$s0,Exit # if i > size of array, then jump to sort

        # print the messages integer
        li $v0,4
        la $a0,input_integer
        syscall

        # print the i-th of array
        add $a0,$zero,$t0
        li $v0,1
        syscall

        # print the next line
        li $v0,4
        la $a0,next_line
        syscall

        #get the integer
        li $v0,5
        syscall

        #
        add $t1,$t0,$zero
        sll $t1,$t0,2           #caculating offset of i
        add $t3,$v0,$zero       

        #store data at location
        sw $t3,Array( $t1 )

        addi $t0,$t0,1 # i= i+1

        slt $t1,$s0,$t0
    j input_loop
    Exit:
        #reduce s0 by 1 as zero based index
        li $t9,1
        sub $s0,$s0,$t9
        li $v0,4
        la $a0,output_title
        syscall

        jal printArray #print array before sorting

    la $a0,Array
    addi $a1,$s0,1 

    #call buble_sort
    jal sorting

    addi $s5,$s0,1 #get number of element

    #print table
    li $v0,4
    la $a0,output_array
    syscall

    jal printArray #print array after sorting


    li $v0,10
    syscall

sorting:
    #a0=address of table
    #a1=sizeof table
    add $t0,$zero,$zero #counter1( i )=0

    sorting_loop1:
        addi $t0,$t0,1 #i++
        bgt $t0,$a1,Exit_loop #if i > array size break;

        add $t1,$a1,$zero #counter2=size=6
    sorting_loop2:

        bge $t0,$t1,sorting_loop1 #j < = i

        addi $t1,$t1,-1 #j--

        mul $t4,$t1,4 #t4+a0=table[j]
        addi $t3,$t4,-4 #t3+a0=table[j-1]
        add $t7,$t4,$a0 #t7=table[j]
        add $t8,$t3,$a0 #t8=table[j-1]
        lw $t5,0($t7)
        lw $t6,0($t8)

        bgt $t5,$t6,sorting_loop2

        #switch t5,t6
        sw $t5,0($t8)
        sw $t6,0($t7)
        j sorting_loop2
    Exit_loop:
        jr $ra
printArray:
    la $a1,Array

    #init i= 0
    li $t9, 0  

    print_loop:
        bgt $t9, $s0, done
        lw $a0,0($a1)
        li $v0,1
        syscall

        la $a0,output_space
        li $v0,4
        syscall

        addi $a1,$a1,4
        addi $t9,$t9,1
    j print_loop
    done:
        jr $ra