    .section .text
    .globl _start

_start:
    # Initialize:
    li   t0, 6       # t0 = multiplicand (e.g. 6)
    li   t1, 5       # t1 = multiplier   (e.g. 5)
    li   t2, 0       # t2 = product

loop:
    beqz t1, done    # if multiplier == 0, we’re done
    andi t3, t1, 1   # t3 = (t1 & 1)
    beqz t3, skip    # if LSB==0, skip add
    add  t2, t2, t0  # product += multiplicand

skip:
    slli t0, t0, 1   # multiplicand <<= 1
    srli t1, t1, 1   # multiplier   >>= 1
    j    loop



done:
    # result is now in t2
   j done
