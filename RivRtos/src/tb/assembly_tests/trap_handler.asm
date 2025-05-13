.data 
.text

# reset the mtime register to value zero
li t0, 0x20000c00
sw x0,  8(t0) #mtimecmp[31:0]
sw x0, 12(t0) #mtimecmp[63:32]
    
    
# clear pending interrupts if any
li t0, 0x880
csrrc t2, 0x344, t0

li s0, 0
li s1, 100
store_another_word:
    sw s0, 0(s0)
    addi s0, s0, 4
    blt s0, s1, store_another_word
nop
nop
nop
nop
