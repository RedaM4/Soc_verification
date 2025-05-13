.data 
.text
    

    
# Writing 0x1000000 in the trap vector ( base address of the instruction memory)

    la t0, trap_handler  
    csrrw t2 0x305 t0
   

    li t0, 0x20000c00
    li t1, 10
    sw t1, 0(t0) #mtimecmp[31:0]
    sw x0, 4(t0) #mtimecmp[63:32]
    
    
    # clear pending interrupts if any
    li t0, 0x880
    csrrc t2, 0x344, t0
    
    li t0, 0x0880 # enable timer and external interrupts   
    csrrw t2 0x304 t0
    
    li t0, 0x8 # to set the global intterupt enable bit
    csrrs t2, 0x300, t0
    
    
again:
    li t0, 0xAAAA
    li t1, 0x20000104
    sw t0, 0(t1)
    
    li t0, 0
    li t1, 1000000
    add_delay:
        addi t0, t0, 1
        blt t0, t1, add_delay
        
    li t0, 0x5555
    li t1, 0x20000104
    sw t0, 0(t1)
    
    
    li s0, 0
    li t1, 1000000
    add_delay2:
        addi t0, t0, 1
        blt t0, t1, add_delay2
    
    j again
        
    
    exit: # infinite loop
        j exit
    
    
    

        

trap_handler:
    li sp, 508
    # addi sp, sp, -16         # Allocate 16 bytes of stack space
    # sw ra, 12(sp)            # Save return address
    # sw t0, 8(sp)             # Save t0
    # sw t1, 4(sp)             # Save t1
    mv s0, t0
    mv s1, t1
    mv s2, a3 
    mv s3, a4
    mv s4, a5 

    # Turn off LEDs: write 0x0000 to GPIO register
    li t0, 0x20000104        # Load LED register address into t0
    li t1, 0xffff            # Prepare the value 0x0000 (LEDs off)
    sw t1, 0(t0)             # Write 0x0000 to the LED register

    li t0, 0
    li t1, 500
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

    # lw t1, 4(sp)             # Restore t1
    # lw t0, 8(sp)             # Restore t0
    # lw ra, 12(sp)            # Restore ra
    # addi sp, sp, 16          # Deallocate stack

    mv t0, s0
    mv t1, s1
    mv a3, s2
    mv a4, s3
    mv a5, s4
    # mret                     # Return from interrupt
  
    
 
    