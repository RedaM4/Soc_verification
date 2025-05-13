.data 
.text
    
#define IMEM_BASE_ADDR 0x80000000 // for riscv dv using this as base of insturciton memory 
    
# Writing 0x1000000 in the trap vector ( base address of the instruction memory)

    la t0, trap_handler  
    csrrw t2, mtvec, t0
   
    li t0, 0x20000c00
    li t1, 0x100
    sw t1, 0(t0) #mtimecmp[31:0]
    sw x0, 4(t0) #mtimecmp[63:32] // 0x0000000000000400
        
    li t0, 0x0880 # enable timer and external interrupts   
    csrrw t2, mie, t0
    
    li t0, 0x8 # to set the global intterupt enable bit
    csrrs t2, mstatus, t0
    
    
    li t0, IMEM_BASE_ADDR
    jr t0 # jump to instruction memory base address 
    
    # Should never reach there
    exit: # infinite loop
        j exit
         

trap_handler:
    # mv s0, sp
    csrrw x0, mscratch, sp
    li sp, 0x80042000
    addi sp, sp, -124         # Allocate space for 31 registers (31 × 4 = 124 bytes)

    # Save all general-purpose registers (x1 to x31)
    sw x2,   4(sp)
    sw x1,   0(sp)
    sw x3,   8(sp)
    sw x4,  12(sp)
    sw x5,  16(sp)
    sw x6,  20(sp)
    sw x7,  24(sp)
    sw x8,  28(sp)
    sw x9,  32(sp)
    sw x10, 36(sp)
    sw x11, 40(sp)
    sw x12, 44(sp)
    sw x13, 48(sp)
    sw x14, 52(sp)
    sw x15, 56(sp)
    sw x16, 60(sp)
    sw x17, 64(sp)
    sw x18, 68(sp)
    sw x19, 72(sp)
    sw x20, 76(sp)
    sw x21, 80(sp)
    sw x22, 84(sp)
    sw x23, 88(sp)
    sw x24, 92(sp)
    sw x25, 96(sp)
    sw x26, 100(sp)
    sw x27, 104(sp)
    sw x28, 108(sp)
    sw x29, 112(sp)
    sw x30, 116(sp)
    sw x31, 120(sp)

    # Clear the timer interrupt by updating mtimecmp
    li t0, 0x20000C00         # base address of mtimecmp (CLINT)
    lw t1, 0(t0)              # read mtimecmp[31:0]
    addi t1, t1, 0x400        # increment it
    sw t1, 0(t0)              # write back to mtimecmp[31:0]
    sw x0, 4(t0)              # clear mtimecmp[63:32] to 0 (Not needed)

    # Restore all general-purpose registers
    lw x1,   0(sp)
    lw x2,   4(sp)
    lw x3,   8(sp)
    lw x4,  12(sp)
    lw x5,  16(sp)
    lw x6,  20(sp)
    lw x7,  24(sp)
    lw x8,  28(sp)
    lw x9,  32(sp)
    lw x10, 36(sp)
    lw x11, 40(sp)
    lw x12, 44(sp)
    lw x13, 48(sp)
    lw x14, 52(sp)
    lw x15, 56(sp)
    lw x16, 60(sp)
    lw x17, 64(sp)
    lw x18, 68(sp)
    lw x19, 72(sp)
    lw x20, 76(sp)
    lw x21, 80(sp)
    lw x22, 84(sp)
    lw x23, 88(sp)
    lw x24, 92(sp)
    lw x25, 96(sp)
    lw x26, 100(sp)
    lw x27, 104(sp)
    lw x28, 108(sp)
    lw x29, 112(sp)
    lw x30, 116(sp)
    lw x31, 120(sp)
    addi sp, sp, 124         # Deallocate stack space used above

    csrrw sp, mscratch, sp
    # mv sp, s0

    mret                     # Return from trap