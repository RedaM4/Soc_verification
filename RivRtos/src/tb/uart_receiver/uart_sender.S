    .data
    # Define peripheral base addresses and register offsets
    .equ GPIO_BASE,    0x20000100    # Base address for GPIO LED register
    .equ UART_BASE,    0x20000000    # UART base address

    .equ REG_BRDL,     0x00          # Baud rate divisor (LSB)
    .equ REG_IER,      0x04          # Interrupt enable register
    .equ REG_FCR,      0x08          # FIFO control register
    .equ REG_LCR,      0x0c          # Line control register
    .equ REG_LSR,      0x14          # Line status register

    .equ LCR_CS8,      0x03          # 8-bit data size
    .equ LCR_1_STB,    0x00          # 1 stop bit
    .equ LCR_PDIS,     0x00          # Parity disable

    .equ LSR_THRE,     0x20          # Transmitter holding register empty

    .equ FCR_FIFO,     0x01          # Enable FIFO
    .equ FCR_RCVRCLR,  0x02          # Clear receive FIFO
    .equ FCR_XMITCLR,  0x04          # Clear transmit FIFO
    .equ FCR_MODE0,    0x00          # Receiver mode 0
    .equ FCR_FIFO_8,   0x80          # 8 bytes in FIFO

    .text
.global main
main:
    li sp, 508              # Set up stack pointer (adjust if needed)
    call uartInit           # Initialize UART

    li t0, 1                # Counter = 1
loop:
    li t3, 513              # t3 = 513 (end marker)
    bge t0, t3, done        # if t0 >= 513, done

    # --- Send 16-bit value (little-endian) over UART ---
    andi a0, t0, 0xFF       # lower byte = t0 & 0xFF
    call uartSendByte
    srai a0, t0, 8          # upper byte = t0 >> 8 (for values < 256 this is 0)
    andi a0, a0, 0xFF
    call uartSendByte

    # --- Display the value on GPIO ---
    mv a0, t0             # put counter in a0
    call gpioWrite        # gpioWrite writes a0 to LED register

    # --- Mini delay ---
    call delay

    addi t0, t0, 1        # increment counter
    j loop

done:
    j done                # infinite loop

# -------------------------------------------------------------------
# uartInit: Initialize UART peripheral
# -------------------------------------------------------------------
uartInit:
    li t0, UART_BASE
    li t1, 0x80
    sb t1, REG_LCR(t0)       # Set DLAB bit
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
    sb zero, REG_IER(t0)     # Disable interrupts
    ret

# -------------------------------------------------------------------
# uartSendByte: Wait for transmitter ready and send byte (in a0)
# -------------------------------------------------------------------
uartSendByte:
    li t1, UART_BASE
wait_tx:
    lb t0, REG_LSR(t1)
    andi t0, t0, LSR_THRE   # Wait until THR is empty
    beqz t0, wait_tx
    sb a0, 0(t1)
    ret

# -------------------------------------------------------------------
# gpioWrite: Write the value in a0 to GPIO LED register
# -------------------------------------------------------------------
gpioWrite:
    li t1, GPIO_BASE
    sw a0, 4(t1)          # Write a0 to LED register (offset 4)
    ret

# -------------------------------------------------------------------
# delay: A simple delay loop
# -------------------------------------------------------------------
delay:
    li t0, 100000         # Adjust delay count as needed
delay_loop:
    addi t0, t0, -1
    bnez t0, delay_loop
    ret
