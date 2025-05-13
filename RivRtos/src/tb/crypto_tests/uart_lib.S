.globl uartInit
.globl uartGetByte
.globl uartSendByte

.data
#define GPIO_BASE 0x20000100    # Base address for GPIO LED register
#define DMEM_BASE 0         

#define UART_BASE 0x20000000

.equ REG_BRDL,     0x00    # Baud rate divisor (LSB)
.equ REG_IER,      0x04    # Interrupt enable register
.equ REG_FCR,      0x08    # FIFO control register
.equ REG_LCR,      0x0c    # Line control register
.equ REG_LSR,      0x14    # Line status register
.equ LCR_CS8,      0x03    # 8-bit data size
.equ LCR_1_STB,    0x00    # 1 stop bit
.equ LCR_PDIS,     0x00    # Parity disable
.equ LSR_THRE,     0x20    # Transmitter holding register empty
.equ FCR_FIFO,     0x01    # Enable FIFO
.equ FCR_RCVRCLR,  0x02    # Clear receive FIFO
.equ FCR_XMITCLR,  0x04    # Clear transmit FIFO
.equ FCR_MODE0,    0x00    # Receiver mode 0
.equ FCR_FIFO_8,   0x80    # 8 bytes in FIFO

.text

main:
    call uartInit

while:
    # Initialize counter - we only need 16 bytes (4 words) for one AES-128 block
    li s0, 0          # Input buffer index
    li s1, 352         # Total bytes to receive (4 words)

# Step 1: Receive 16 bytes (one AES-128 block)
get_next_byte:
    call uartGetByte
    slli t0, s0, 2    # Calculate memory offset (s0 * 4)
    li t1, DMEM_BASE
    add t0, t0, t1 
    sw a0, 0(t0)      # Store received byte in memory
    addi s0, s0, 1
    blt s0, s1, get_next_byte

# Step 2: Process only one 128-bit block (16 bytes/4 words)
process:
    # Use the start of the input buffer
    li t0, DMEM_BASE  # Base address of input data
    
    # --- Load single block (4 words, 16 bytes) ---
    lw t1, 0(t0)      # Word 0
    lw t4, 4(t0)      # Word 1
    lw t5, 8(t0)      # Word 2
    lw t6, 12(t0)     # Word 3

    # --- Load round key (round 0) ---
    li s5, 64         # Assuming round keys are at address 64
    lw t2, 0(s5)      # Key word 0
    lw t3, 4(s5)      # Key word 1
    lw a0, 8(s5)      # Key word 2
    lw a1, 12(s5)     # Key word 3

    # --- Initial AddRoundKey (XOR plaintext with key) ---
    xor t1, t1, t2
    xor t4, t4, t3
    xor t5, t5, a0
    xor t6, t6, a1

    # Store state for next round
    sw t1, 0(t0)
    sw t4, 4(t0)
    sw t5, 8(t0)
    sw t6, 12(t0)

    # --- Main Rounds (1-9) ---
    li s6, 1          # round = 1
    addi s7, s5, 16   # s7 points to round 1 keys

main_rounds_loop:
    lw t1, 0(t0)      # Reload state
    lw t4, 4(t0)
    lw t5, 8(t0)
    lw t6, 12(t0)

    # Load round key
    lw t2, 0(s7)
    lw t3, 4(s7)
    lw a0, 8(s7)
    lw a1, 12(s7)

    # Apply AES transformations with encryption middle step instruction
    # Word 0
    aes32esmi t2, t1, t2, 0
    aes32esmi t2, t4, t2, 1
    aes32esmi t2, t5, t2, 2
    aes32esmi t2, t6, t2, 3

    # Word 1
    aes32esmi t3, t1, t3, 0
    aes32esmi t3, t4, t3, 1
    aes32esmi t3, t5, t3, 2
    aes32esmi t3, t6, t3, 3

    # Word 2
    aes32esmi a0, t1, a0, 0
    aes32esmi a0, t4, a0, 1
    aes32esmi a0, t5, a0, 2
    aes32esmi a0, t6, a0, 3

    # Word 3
    aes32esmi a1, t1, a1, 0
    aes32esmi a1, t4, a1, 1
    aes32esmi a1, t5, a1, 2
    aes32esmi a1, t6, a1, 3

    # Store results for next round
    sw t2, 0(t0)
    sw t3, 4(t0)
    sw a0, 8(t0)
    sw a1, 12(t0)

    # Move to next round
    addi s6, s6, 1
    addi s7, s7, 16      # Move to next round keys

    li t2, 10
    bne s6, t2, main_rounds_loop

    # --- Final Round (10) ---
    lw t1, 0(t0)      # Reload state
    lw t4, 4(t0)
    lw t5, 8(t0)
    lw t6, 12(t0)

    # Load round key
    lw t2, 0(s7)
    lw t3, 4(s7)
    lw a0, 8(s7)
    lw a1, 12(s7)

    # Apply AES final round transformations
    aes32esi t2, t1, t2, 0
    aes32esi t3, t4, t3, 1
    aes32esi a0, t5, a0, 2
    aes32esi a1, t6, a1, 3

    # Store ciphertext back to the same memory location
    # (could also use a different location if needed)
    sw t2, 0(t0)
    sw t3, 4(t0)
    sw a0, 8(t0)
    sw a1, 12(t0)

    # Step 3: Send the processed 16 bytes back
    li s0, 0          # Reset output index
    li s1, 352        # Total bytes to send (4 words = 16 bytes)
    
send_next_byte:
    slli t0, s0, 2
    li t1, DMEM_BASE
    add t0, t0, t1 
    lw a0, 0(t0)
    call uartSendByte
    addi s0, s0, 1
    blt s0, s1, send_next_byte
    
    j while           # Go back to wait for more input

exit:
    j exit

# -------------------------------------------------------------------
# ledWrite: Write value in t0 to LED register (GPIO)
# -------------------------------------------------------------------
ledWrite:
    li t1, GPIO_BASE
    sw t0, 4(t1)          # Write to LED register at GPIO_BASE
    ret

# -------------------------------------------------------------------
# delay: A simple delay loop
# -------------------------------------------------------------------
delay:
    li t0, 1000000        # Delay count
delay_loop:
    addi t0, t0, -1
    bnez t0, delay_loop
    ret

# -------------------------------------------------------------------
# uartInit: Initialize UART peripheral
# -------------------------------------------------------------------
uartInit:
    li t0, UART_BASE
    li t1, 0x80
    sb t1, REG_LCR(t0)       # Set DLAB bit to access baud rate divisor
    li t1, 27
    sb t1, REG_BRDL(t0)      # Set baud rate divisor
    ori t1, x0, LCR_CS8
    ori t1, t1, LCR_1_STB
    ori t1, t1, LCR_PDIS
    sb t1, REG_LCR(t0)       # Clear DLAB; set 8-N-1
    ori t1, x0, FCR_FIFO
    ori t1, t1, FCR_MODE0
    ori t1, t1, FCR_FIFO_8
    ori t1, t1, FCR_RCVRCLR
    ori t1, t1, FCR_XMITCLR
    sb t1, REG_FCR(t0)       # Configure FIFO
    sb zero, REG_IER(t0)     # Disable UART interrupts
    ret

# -------------------------------------------------------------------
# uartSendByte: Wait for transmitter ready and send byte (in a0)
# -------------------------------------------------------------------
uartSendByte:
    li t1, UART_BASE
wait_tx:
    lb t0, REG_LSR(t1)
    andi t0, t0, LSR_THRE   # Check Transmitter Holding Register Empty
    beqz t0, wait_tx
    sb a0, 0(t1)
    ret

# -------------------------------------------------------------------
# uartGetByte: Wait for a received byte and return it in a0
# -------------------------------------------------------------------
uartGetByte:
    li t1, UART_BASE
wait_rx:
    lb t0, REG_LSR(t1)
    andi t0, t0, 1         # Check Data Ready bit
    beqz t0, wait_rx
    lb a0, 0(t1)
    ret