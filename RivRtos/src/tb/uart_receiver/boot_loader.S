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
    li sp, 4096            # Set up stack pointer (adjust as needed)
    call uartInit          # Initialize UART

    # --- Handshake: wait for a byte and echo it ---
handshake:
    call uartGetByte       # Wait for a handshake character (result in a0)
    call uartSendByte      # Echo it back

    # --- Receive payload length (2 bytes, LSB first) ---
    call uartGetByte       # Get low byte; result in a0
    andi s0, a0, 0xFF
    call uartGetByte       # Get high byte; result in a0
    andi a0, a0, 0xFF
    slli a0, a0, 8         # Shift high byte left by 8 bits
    or   s0, s0, a0        # Combine into a 16‐bit length in t0
    
    li t0, GPIO_BASE
    sw s0, 4(t0)

    # --- Load Payload ---
    li s2, 0x10000000      # s2 = instruction memory base address
    mv s3, s0              # s3 = number of bytes to load
load_loop:
    beqz s3, load_done     # If s3 == 0, finished loading
    call uartGetByte       # Receive one byte (result in a0)
    sb a0, 0(s2)           # Store byte to instruction memory
    addi s2, s2, 1         # Increment memory pointer
    addi s3, s3, -1        # Decrement counter
    j load_loop
load_done:

    # LEDS INDICATING LOADING IS DONE
    li t0, 0xAAAA
    sw s0, 4(t0)
    
    # --- Echo Back Loaded Payload for Verification ---
    li s2, 0x10000000      # Reset pointer to instruction memory base
    mv s3, s0              # Reset s3 = payload length
echo_loop:
    beqz s3, echo_done
    lb a0, 0(s2)           # Load one byte from instruction memory
    call uartSendByte      # Send it back via UART
    addi s2, s2, 1         # Increment memory pointer
    addi s3, s3, -1        # Decrement counter
    j echo_loop
echo_done:

    # --- Blink LED to Indicate Programming Complete ---
    li s1, 0              # Use s1 as blink counter (initialize to 0)
blink_loop:
    li t0, 0xFFFF         # LED ON value (e.g. all LEDs on)
    call ledWrite
    call delay
    li t0, 0x0000         # LED OFF value
    call ledWrite
    call delay
    addi s1, s1, 1
    li t3, 10             # Blink 10 times (adjust as needed)
    blt s1, t3, blink_loop

    # --- Jump to Instruction Memory Base (start the loaded program) ---
    li t0, 0x10000000
    jr t0
    nop
    nop

# -------------------------------------------------------------------
# ledWrite: Write value in t0 to LED register (GPIO)
# -------------------------------------------------------------------
ledWrite:
    li t1, GPIO_BASE
    sw t0, 4(t1)          # Write to LED register at GPIO_BASE (offset 0)
    ret

# -------------------------------------------------------------------
# delay: A simple delay loop (adjust count as needed)
# -------------------------------------------------------------------
delay:
    li t0, 1000000        # Delay count; adjust for your system speed
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
