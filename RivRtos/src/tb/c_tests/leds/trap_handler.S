    .section .text
    .global trap_handler
    .type trap_handler, @function


trap_handler:
    addi sp, sp, -24       # Allocate 24 bytes (6 registers × 4 bytes)
    sw   a0,   0(sp)        # Save a0
    sw   a1,   4(sp)        # Save a1
    sw   a2,   8(sp)        # Save a2
    sw   a3,  12(sp)        # Save a3
    sw   a4,  16(sp)        # Save a4
    sw   a5,  20(sp)        # Save a5



    # Turn off LEDs: write 0x0000 to GPIO register
    li t0, 0x20000104        # Load LED register address into t0
    li t1, 0xffff            # Prepare the value 0x0000 (LEDs off)
    sw t1, 0(t0)             # Write 0x0000 to the LED register

    li t0, 0
    li t1, 5000000
    add_more_delay3:
        addi t0, t0, 1
        blt t0, t1, add_more_delay3

    # Clear timer
    li t0, 0x20000c00        # Load mtimecmp register address
    li t1, 0x0        # New compare value (adjust as needed)
    sw x0, 8(t0)             # Write new value to mtimecmp
    sw x0, 12(t0)             # Write new value to mtimecmp

    # clear pending interrupts if any
    li t0, 0x880
    csrrc t2, 0x344, t0

    lw   a0,   0(sp)        # Restore a0
    lw   a1,   4(sp)        # Restore a1
    lw   a2,   8(sp)        # Restore a2
    lw   a3,  12(sp)        # Restore a3
    lw   a4,  16(sp)        # Restore a4
    lw   a5,  20(sp)        # Restore a5
    addi sp, sp, 24         # Deallocate the stack frame
    

    # mv t0, s0
    # mv t1, s1
    # mv a3, s2
    # mv a4, s3
    # mv a5, s4
    mret