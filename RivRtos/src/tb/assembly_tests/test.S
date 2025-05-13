.section .text
.globl _start

_start:
    c.li    x1, 5
    c.li    x2, 10

    c.li    x3, 15
    addi    x4, x0, 20

    addi    x5, x0, 25
    c.li    x6, 30

    c.li    x7, -10
    c.li    x8, -20

    c.li    x9, 0
    addi    x10, x0, 10
    c.li    x11, 1

loop:
    j loop
