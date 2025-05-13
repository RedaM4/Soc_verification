#include <stdint.h>

#define GPIO_LED_REG (*(volatile uint32_t*)0x20000104)

extern void trap_handler(void);  // Provided by trap_handler.S

void init_timer_interrupt(void) {
    // Set mtvec to point to our trap handler.
    asm volatile ("csrw mtvec, %0" :: "r"(trap_handler));

    // Set the initial mtimecmp value (adjust as needed relative to mtime).
    volatile uint32_t *mtimecmp = (volatile uint32_t *)0x20000c00;
    *mtimecmp = 0x00010000;

    
    // Enable machine timer interrupts (set bit 7 in mie).
    asm volatile ("csrs mie, %0" :: "r"(0x80));

    // Enable global machine interrupts (set MIE bit in mstatus, bit 3).
    asm volatile ("csrs mstatus, %0" :: "r"(0x8));


}

int main(void) {
    init_timer_interrupt();

    while(1) {
        // Toggle LED patterns.
        // In normal operation, the main loop toggles LEDs (e.g., 0xAAAA and 0x5555).
        // When a timer interrupt occurs, the trap handler clears the LEDs (0x0000).
        GPIO_LED_REG = 0xAAAA;
        for(volatile int i = 0; i < 1000000; i++);  // delay loop

        GPIO_LED_REG = 0x5555;
        for(volatile int i = 0; i < 1000000; i++);  // delay loop
    }
    return 0;
}
