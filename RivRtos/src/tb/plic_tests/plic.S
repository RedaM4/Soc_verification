    .section .text
    .globl _start
_start:
    # ----------------------------
    # 1) Set trap vector → trap_entry
    # ----------------------------
    la    t0, trap_entry
    csrw  mtvec, t0

    # ----------------------------
    # 2) PLIC base & source ID
    # ----------------------------
    li    a0, 0x21000000      # PLIC_BASE
    li    a1, 1               # IRQ source = 1

    # ----------------------------
    # 3) Set priority[1] = 1
    # ----------------------------
    slli  t1, a1, 2           # t1 = source_id * 4
    add   t1, a0, t1          # addr = PLIC_BASE + 4
    li    t2, 1
    sw    t2, 0(t1)

    # ----------------------------
    # 4) Enable source 1
    # ----------------------------
    li    a2, 0x21002000      # PLIC_ENABLE[0]
    li    t2, 2               # mask = 1<<1
    sw    t2, 0(a2)

    # ----------------------------
    # 5) Threshold = 0
    # ----------------------------
    li    a3, 0x21020000      # PLIC_THRESHOLD[0]
    sw    zero, 0(a3)

    # ----------------------------
    # 6) Enable mech. interrupts
    # ----------------------------
    li    t0, (1<<11)         # MEIE
    csrs  mie, t0
    li    t0, (1<<3)          # MIE
    csrs  mstatus, t0



exit:
    j exit

# -------------------------------------------------------
# Trap/Interrupt handler
# -------------------------------------------------------
    .align 2
trap_entry:
    li    a4, 0x21200004      # PLIC_CLAIM[0]
    lw    t0, 0(a4)           # claim
    sw    t0, 0(a4)           # complete

    la    t1, test_result
    li    t2, 1
    sw    t2, 0(t1)           # mark PASS

    mret

# -------------------------------------------------------
# Data for test flag
# -------------------------------------------------------
    .section .data
    .align 2
test_result:
    .word 0
