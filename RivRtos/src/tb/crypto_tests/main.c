#include <stdint.h>

#define DMEM_BASE   0x00000000  // Base address of data memory
#define UART_BYTES  16          // 128 bits = 16 bytes

// External assembly functions
extern void uartInit();
extern uint8_t uartGetByte();
extern void uartSendByte(uint8_t byte);

// Buffer to hold data (in DMEM)
volatile uint8_t* const uart_buffer = (volatile uint8_t*) DMEM_BASE;

int main() {
    uartInit();  // Initialize UART

while(1){
   
    // Step 1: Receive 16 bytes over UART
    for (int i = 0; i < UART_BYTES; i++) {
        uart_buffer[i] = uartGetByte();
    }

    // Step 2: Process - Invert each byte
    for (int i = 0; i < UART_BYTES; i++) {
        uart_buffer[i] = ~uart_buffer[i];
    }

    // Step 3: Transmit all processed bytes over UART
    for (int i = 0; i < UART_BYTES; i++) {
        uartSendByte(uart_buffer[i]);
    }
    }

    return 0;
}
