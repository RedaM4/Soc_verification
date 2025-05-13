#include <stdio.h>

int main() {
    // Step 1: Create a pointer to memory address 0 (for test)
    volatile int *mem = (int*)0x00000000;

    // Step 2: Write initial value to memory (e.g., 10)
    *mem = 10;

    // Step 3: Perform atomic add of 5 using inline RISC-V `amoadd.w`
    int old_val;
    int add_val = 5;
    __asm__ volatile (
        "amoadd.w %0, %2, %1"
        : "=r"(old_val), "+A"(*mem)
        : "r"(add_val)
        : "memory"
    );

    // Step 4: Print results
    printf("Old value: %d\n", old_val);     // Should be 10
    printf("New value: %d\n", *mem);        // Should be 15

    return 0;
}
