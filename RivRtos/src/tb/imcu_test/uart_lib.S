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
    call uartGetByte


    sw x0, 400(x0)
    li sp, 16384

interrupt_setup:
   #-------------------------------------#
   #  Setting Up the External Interrupts #
   #-------------------------------------#    
    la t0, trap_handler  
    csrrw t2,mtvec,t0  # base address of the trap handler 
   

    li t0, 0x20000c00
    li t1, 0xffffffff
    sw t1, 0(t0) #mtimecmp[31:0]
    sw x0, 4(t0) #mtimecmp[63:32]
    
    
    # clear pending interrupts if any
   # li t0, 0x880
   # csrrc t2, 0x344, t0
    
    li t0, 0x00800 # enable external interrupts  
    csrrw t2,mie,t0
    
    li t0, 0x8 # to set the global intterupt enable bit
    csrrs t2, mstatus, t0
    
   
	# --------------------------
	# Store first 42 numbers (value = 6) at 0 to 164
	# --------------------------
#	    li t0, 0              # Base address
#	    li t1, 42             # Counter
#	    li t2, 6              # Value to store
#	fill_first_array:
#	    addi x0,x0,0    #nop
#	    addi x0,x0,0    #nop
#	    addi t2,t2,42 
#	    sw t2, 0(t0)          # Store value
#	    addi t0, t0, 4        # Move to next word
#	    addi t1, t1, -1
#	    bnez t1, fill_first_array     
	# --------------------------
	# Store second 42 numbers (value = 7) at 168 to 332
	# --------------------------
#	    li t0, 168            # Base address (42 * 4)
#	    li t1, 42             # Counter
#	    li t2, 7              # Value to store
#	fill_second_array:
#	    addi x0,x0,0    #nop
#	    addi x0,x0,0    #nop
#	    addi t2,t2,345
#	    sw t2, 0(t0)
#	    addi t0, t0, 4
#	    addi t1, t1, -1
#	    bnez t1, fill_second_array

    li x7, 0x00000000       # Base address

    # Store first vector (from address 0 to 164)
    li x6, 123
    sw x6, 0(x7)
    li x6, 1024
    sw x6, 4(x7)
    li x6, 50000
    sw x6, 8(x7)
    li x6, 65536
    sw x6, 12(x7)
    li x6, 1111
    sw x6, 16(x7)
    li x6, 3000
    sw x6, 20(x7)
    li x6, 999
    sw x6, 24(x7)
    li x6, 80000
    sw x6, 28(x7)
    li x6, 16384
    sw x6, 32(x7)
    li x6, 700
    sw x6, 36(x7)
    li x6, 60000
    sw x6, 40(x7)
    li x6, 131072
    sw x6, 44(x7)
    li x6, 32768
    sw x6, 48(x7)
    li x6, 65535
    sw x6, 52(x7)
    li x6, 4096
    sw x6, 56(x7)
    li x6, 1023
    sw x6, 60(x7)
    li x6, 2000000
    sw x6, 64(x7)
    li x6, 2047
    sw x6, 68(x7)
    li x6, 9999
    sw x6, 72(x7)
    li x6, 54321
    sw x6, 76(x7)
    li x6, 8765
    sw x6, 80(x7)
    li x6, 111111
    sw x6, 84(x7)
    li x6, 2222
    sw x6, 88(x7)
    li x6, 31415
    sw x6, 92(x7)
    li x6, 70000
    sw x6, 96(x7)
    li x6, 4095
    sw x6, 100(x7)
    li x6, 32767
    sw x6, 104(x7)
    li x6, 1024
    sw x6, 108(x7)
    li x6, 500000
    sw x6, 112(x7)
    li x6, 123456
    sw x6, 116(x7)
    li x6, 789
    sw x6, 120(x7)
    li x6, 4096
    sw x6, 124(x7)
    li x6, 16000
    sw x6, 128(x7)
    li x6, 1234
    sw x6, 132(x7)
    li x6, 7890
    sw x6, 136(x7)
    li x6, 32000
    sw x6, 140(x7)
    li x6, 98765
    sw x6, 144(x7)
    li x6, 11111
    sw x6, 148(x7)
    li x6, 22222
    sw x6, 152(x7)
    li x6, 34567
    sw x6, 156(x7)
    li x6, 10000
    sw x6, 160(x7)
    li x6, 16384
    sw x6, 164(x7)

    # Store second vector (from address 168 to 332)
    li x6, 456
    sw x6, 168(x7)
    li x6, 2048
    sw x6, 172(x7)
    li x6, 200
    sw x6, 176(x7)
    li x6, 2
    sw x6, 180(x7)
    li x6, 2222
    sw x6, 184(x7)
    li x6, 3000
    sw x6, 188(x7)
    li x6, 1001
    sw x6, 192(x7)
    li x6, 5
    sw x6, 196(x7)
    li x6, 64
    sw x6, 200(x7)
    li x6, 321
    sw x6, 204(x7)
    li x6, 7
    sw x6, 208(x7)
    li x6, 8
    sw x6, 212(x7)
    li x6, 99
    sw x6, 216(x7)
    li x6, 100
    sw x6, 220(x7)
    li x6, 4096
    sw x6, 224(x7)
    li x6, 1023
    sw x6, 228(x7)
    li x6, 2
    sw x6, 232(x7)
    li x6, 4095
    sw x6, 236(x7)
    li x6, 1234
    sw x6, 240(x7)
    li x6, 123
    sw x6, 244(x7)
    li x6, 4321
    sw x6, 248(x7)
    li x6, 9
    sw x6, 252(x7)
    li x6, 3333
    sw x6, 256(x7)
    li x6, 9265
    sw x6, 260(x7)
    li x6, 60
    sw x6, 264(x7)
    li x6, 2047
    sw x6, 268(x7)
    li x6, 99
    sw x6, 272(x7)
    li x6, 8192
    sw x6, 276(x7)
    li x6, 8
    sw x6, 280(x7)
    li x6, 7
    sw x6, 284(x7)
    li x6, 654
    sw x6, 288(x7)
    li x6, 256
    sw x6, 292(x7)
    li x6, 1000
    sw x6, 296(x7)
    li x6, 5678
    sw x6, 300(x7)
    li x6, 1234
    sw x6, 304(x7)
    li x6, 50
    sw x6, 308(x7)
    li x6, 321
    sw x6, 312(x7)
    li x6, 11111
    sw x6, 316(x7)
    li x6, 12345
    sw x6, 320(x7)
    li x6, 7654
    sw x6, 324(x7)
    li x6, 10000
    sw x6, 328(x7)
    li x6, 256
    sw x6, 332(x7)


         call uartSendByte
         call uartSendByte
         call uartSendByte
         call uartSendByte


interrupt_setup_ends:


   #-------------------------------------#
   #     Writing to the weightlayer      # same as old
   #-------------------------------------#
   
   # Store 0x00000CD to ADDRS_CTRL_REG1 (0x10000000)
    li x6, 0x00000CD        # Load 0xCD into x6
    li x7, 0x30000000       # Load base address of ADDRS_CTRL_REG1
    sw x6, 0(x7)            # Store x6 value (0xCD) at ADDRS_CTRL_REG1

    # Store 0 to ADDRS_CTRL_REG2 (0x10000004)
    li x6, 0x0              # Load 0 into x6
    li x7, 0x30000004       # Load base address of ADDRS_CTRL_REG2
    sw x6, 0(x7)            # Store x6 value (0) at ADDRS_CTRL_REG2

    # Store 7 to ADDRS_FLAG_REG (0x1000000C)
    li x6, 7                # Load 7 into x6
    li x7, 0x3000000C       # Load base address of ADDRS_FLAG_REG
    sw x6, 0(x7)            # Store x6 value (7) at ADDRS_FLAG_REG

    # Store 1 to ADDRS_CTRL_REG3 (0x10000008)[Enable the Transcation]
    li x6, 1                # Load 1 into x6
    li x7, 0x30000008       # Load base address of ADDRS_CTRL_REG3
    sw x6, 0(x7)            # Store x6 value (1) at ADDRS_CTRL_REG3

    
    # Now dma has the access 
    # processor will get back the acccess only when interrupt is generated
    
    # doing a dummy read to the data memory just to stall the processor 
    lw x0, 0(x0) # it will stall at this point until dma gives back the access
    
main_ends: 
exit: # infinite loop
        j exit
   







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




# -------------------------------------------------------------------
# Handler
# -------------------------------------------------------------------

trap_handler:

         call uartSendByte
         call uartSendByte
         call uartSendByte
         call uartSendByte
   #-------------------------------------#
   #   Check External Interrupt Cause    #
   #   Read the flags to check which     #
   #        causes the interrupts        #
   #-------------------------------------#    
    li x7, 0x3000000C       # Load the address of ADDRS_FLAG_REG into x7
    check_flags:
    lw x8, 0(x7)            # Load the value from ADDRS_FLAG_REG into x8
    andi x9, x8, 1          # Extract the 0th bit of x8 into x9
    bnez x9, Transmission_Complete
    andi x9, x8, 2          # Extract the 1st bit of x8 into x9
    bnez x9, Multiplication_Complete
    j skip
Transmission_Complete:
   # use memory location 100 as the number of transmissions completed so far
   lw a0, 400(x0)
   bnez a0, second_transmission_complete
   addi a0, a0, 1
   sw a0, 400(x0)    # use memory location 100 as the number of transmissions completed so far

   #-------------------------------------#
   #     Writing to the InputBuffer      #
   #-------------------------------------#  
   # clear the flags
    li x6, 7               # TC = 0, MC = 0, AE = 0
    li x7, 0x3000000C      # Load address of ADDRS_FLAG_REG
    sw x6, 0(x7)           # Store 7 at ADDRS_FLAG_REG
    # Clear the TEN bit 
    li x7, 0x30000008       # Load base address of ADDRS_CTRL_REG3 (0x10000008)
    li x6, 0x0000
    sw x6, 0(x7)            # Store 0x0000 at ADDRS_CTRL_REG3
    # Load 0x00004F to dma_ctrl_reg1 (0x10000000)
    li x6, 0x00004F         # dir = mem to IMCU, type = input, valid = 1, imcu_addrs_stride = 1
    li x7, 0x30000000       # Load base address of ADDRS_CTRL_REG1
    sw x6, 0(x7)            # Store 0x00004F at ADDRS_CTRL_REG1
    # Load 0x0000 to dma_ctrl_reg2 (0x10000004)
    li x6, 0x00A8           # starting address IMCU = 0, Starting Addrsss data memory = 42*4[in decimal]
    li x7, 0x30000004       # Load base address of ADDRS_CTRL_REG2
    sw x6, 0(x7)            # Store 0x0000 at ADDRS_CTRL_REG2
    # Write 0x1 to dma_ctrl_reg3 (0x10000008)
    li x6, 0x1              # enable the transaction [this time for input buffer]
    li x7, 0x30000008       # Load base address of ADDRS_CTRL_REG3
    sw x6, 0(x7)            # Store 0x1 at ADDRS_CTRL_REG3
    j intterupt_ret
second_transmission_complete:
    #-------------------------------------#
    #     Starting the Multiplication     #
    #-------------------------------------#  
    # clear the flags
     li x6, 7               # TC = 0, MC = 0, AE = 0
     li x7, 0x3000000C      # Load address of ADDRS_FLAG_REG
     sw x6, 0(x7)           # Store 7 at ADDRS_FLAG_REG
     # Clear the TEN bit 
     li x7, 0x30000008       # Load base address of ADDRS_CTRL_REG3 (0x10000008)
     li x6, 0x0000
     sw x6, 0(x7)            # Store 0x0000 at ADDRS_CTRL_REG3
     #Enable multipliation 
     li x6, 1               # IMC = 1
     li x7, 0x30000010      # Load address of ADDRS_MUL_EN
     sw x6, 0(x7)           # Store 1 at ADDRS_MUL_EN


Multiplication_Complete:
  #poll the MC flag
  li x7, 0x3000000C
poll_MC:
  lw x8, 0(x7)
  andi x9, x8, 0x2
  beqz x9, poll_MC

   #-------------------------------------#
   #   Configuring IMCU to  Read Memory  #
   #-------------------------------------#

    #loading output buffer lsw to mem[504] //dot prod
    li x14, 0x30000014     # Load the address of output_buffer_lsw into x14
    lw x16, 0(x14)         # Load the *value* at address 0x30000014 into x16
    li x15, 504            # Load the target memory address (504) into x15
    sw x16, 0(x15)         # Store the value from x16 into memory location 504

    # Load the base addresses of DMA registers
    li x10, 0x30000000      # Base address of DMA_CTRL_REG1
    li x11, 0x30000004      # Base address of DMA_CTRL_REG2
    li x12, 0x3000000C      # Base address of DMA_FLAG_REG
    li x13, 0x30000008      # Base address of DMA_CTRL_REG3

    # Write values to the DMA control and flag registers
    li x14, 0xCC           # dma_ctrl_reg1 = 32'b11001100
    sw x14, 0(x10)         # Store in DMA_CTRL_REG1

    li x14, 0x20150        # dma_ctrl_reg2 = 32'h14
    sw x14, 0(x11)         # Store in DMA_CTRL_REG2

    li x14, 0x07           # dma_flag_reg = 32'h7
    sw x14, 0(x12)         # Store in DMA_FLAG_REG

    li x14, 0x3E9           # dma_ctrl_reg3 = 32'h41 (Read operation mode)
    sw x14, 0(x13)         # Store in DMA_CTRL_REG3


    li t0, 504
    lbu a0, 0(t0)
    call uartSendByte
    lbu a0, 1(t0)
    call uartSendByte
    lbu a0, 2(t0)
    call uartSendByte
    lbu a0, 3(t0)
    call uartSendByte
    
    j intterupt_ret


   
skip:
skip_imcu_read_mem:
intterupt_ret:


    mret                     # Return from interrupt
    
    

