	.section .init
	.globl _start
	.globl Reset_Handler
_start:
    j Reset_Handler

	.section .text.Reset_Handler
	.align 4
Reset_Handler:
    /* Set up the stack pointer; _stack_top will be defined in the linker script */
    # la sp, _stack_top
    li sp, 1000

    /* Optionally initialize .data and .bss segments if required */
    /* For many simple systems this may not be needed */

    /* Call the main function */
    call main

    /* If main returns, loop forever */
1:  j 1b
