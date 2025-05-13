

start:
    li a0, 13
    li a1, 11
    li a2, 0 
    li t0, 32

mul_loop:
    andi t1, a1, 1
    beqz t1, skip_add
    add a2, a2, a0 

skip_add:
    slli a0, a0, 1
    srli a1, a1, 1

    addi t0, t0, -1 
    bnez t0, mul_loop

done:
    j done