.data

arr:    .word  34, 32, 2, 4, 6, 1, 12, 3, 14   	  # Pre-defined array of 9 integers

n:      .word   9                                 # Default number of elements in the array



.text

main:
lw   $t1, n                                  # Load the number of elements into $t1
# Initial setup for sorting
la   $t0, arr                                # Load address of array into $t0
li   $t2, 0                                  # Initialize outer loop counter i to 0

outer_loop:
blt  $t2, $t1, inner_loop_init               # If i < n, go to inner loop initialization
halt

inner_loop_init:
li   $t3, 0                                  # Initialize inner loop counter j to 0

inner_loop:
blt  $t3, $t2, compare                       # If j < i, go to compare
j    update_outer

compare:
lw   $t4, 0($t0)                             # Load arr[j] into $t4
lw   $t5, 4($t0)                             # Load arr[j+1] into $t5
blt  $t5, $t4, swap                          # If arr[j+1] < arr[j], go to swap
j    update_inner

swap:
sw   $t4, 4($t0)                             # Swap arr[j] with arr[j+1]
sw   $t5, 0($t0)

update_inner:
addi $t3, $t3, 1                             # Increment j
addi $t0, $t0, 4                             # Move to the next element in the array
j    inner_loop

update_outer:
addi $t2, $t2, 1                             # Increment i
la   $t0, arr                                # Reset address of array to $t0
halt
