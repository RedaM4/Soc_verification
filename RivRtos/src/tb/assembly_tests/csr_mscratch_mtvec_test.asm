.data 
.text
    
    
# MSTATUS TEST 
    li t0, 0x10000000  
    csrrw t2 0x305 t0
    li t0, 0xABCDEF01
    csrrw t3 0x340 t0 # set the bit number 7
    csrrw a0 0x305 x0 # only read the csr
    csrrw a1 0x340 x0 # only read the csr
    
    
  
    
 
    