
#Doyle Chism
.data
array:  .word 2,6,3,9,1   

.text
.globl main
main:
    # Initialize
    la $t0, array         # load array
    li $t1, 8             # num elements 
    li $t2, 4             

outer_loop:
    # Initialize inner loop variables
    li $t3, 0             #  i = 0
    li $t4, 0             #  j = 0

inner_loop:
    #  array[j] and array[j+1] addresses
    sll $t5, $t4, 2       
    sll $t6, $t4, 2       
    add $t5, $t0, $t5     # t5 = &array[j]
    add $t6, $t0, $t6     # t6 = &array[j+1]

    # Load array[j] and array[j+1] into $t7 and $t8
    lw $t7, 0($t5)        # $t7 = array[j]
    lw $t8, 0($t6)        # $t8 = array[j+1]

    sub $t9, $t7, $t8     # $t9 = array[j] - array[j+1]

    bne $t9, $zero, bubbleSort_instructions  # Check $t9 value

    # Swap array[j] and array[j+1]
    sw $t7, 0($t6)        # array[j+1] = $t7
    sw $t8, 0($t5)        # array[j] = $t8

bubbleSort_instructions:
  
    addi $t4, $t4, 1      # j++
    sub $t9, $t1, $t3     # $t9 = (size - i - 1)

    bne $t4, $t9, inner_loop #  if $t4 is less than $t9

    addi $t3, $t3, 1      # i++
    sub $t9, $t1, 1       # t9 = (size - 1)

    bne $t3, $t9, outer_loop  # Check if $t3 is less than $t9
    add $zero, $zero, $zero
    li $v0, 10             # Exit code
    syscall
