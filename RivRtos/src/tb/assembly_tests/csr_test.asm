.data 
.text
    
    
# MSTATUS TEST 
    li t0, 0x8  
    csrrw t2 0x300 t0
    li t0, 0x80
    csrrs t3 0x300 t0 # set the bit number 7
    csrrw t4 0x300 x0 # only read the csr
    
    mv x30 t3
    mv x31 t4
    mv t4, t2
    
  
    
 
    