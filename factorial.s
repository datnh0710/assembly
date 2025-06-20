.data
    input: .asciiz "Input an integer x:\n"
    ouput: .asciiz "Fact(x) = "
    error_negative:  .asciiz "Error messages: negative number can't factorial! \n"
    error_outofbound:  .asciiz "Error messages: Input number too large. Out of boundary!\n"   
.text
.globl main
main:
    # show input
    li        $v0, 4
    la        $a0, input
    syscall

    # read x
    li        $v0, 5
    syscall

    # check negative number
    blt		$v0, $zero, error_neg	# if $v0 < 0 then error_neg
    
    # check input > 12
    li      $t9, 12             # load t9=12
    bgt		$v0, $t9, error_oob	# if $v0 > $t1 then error_oob
    
    # function call
    move      $a0, $v0
    jal      factorial       # jump factorial and save position to $ra
    move      $t0, $v0        # $t0 = $v0

    # show input
    li        $v0, 4
    la        $a0, ouput
    syscall

    # print the ouput
    li        $v0, 1        # system call #1 - print int
    move      $a0, $t0        # $a0 = $t0
    syscall                # execute
    j Exit
    
    # print error negative number
    error_neg:
        li        $v0, 4
        la        $a0, error_negative
        syscall 
        j Exit

    # print error out of boundary
    error_oob:
        li        $v0, 4
        la        $a0, error_outofbound
        syscall
        j Exit

    Exit:
        # return 0
        li        $v0, 10        # $v0 = 10
        syscall
    


.text
factorial:
    # base case -- still in parent's stack segment
    # adjust stack pointer to store return address and argument
    addi    $sp, $sp, -8
    # save $s0 and $ra
    sw      $s0, 4($sp)
    sw      $ra, 0($sp)
    bne     $a0, 0, else
    addi    $v0, $zero, 1    # return 1
    j fact_return

else:
    # backup $a0
    move    $s0, $a0
    addi    $a0, $a0, -1 # x -= 1
    jal     factorial
    # when we get here, we already have Fact(x-1) store in $v0
    multu   $s0, $v0 # return x*Fact(x-1)
    mflo    $v0
fact_return:
    lw      $s0, 4($sp)
    lw      $ra, 0($sp)
    addi    $sp, $sp, 8
    jr      $ra