li t0, 0
li t1, 100

back:
    sw t0, 0(t0)
    addi t0, t0, 4
    blt t0, t1, back

end:
    j end