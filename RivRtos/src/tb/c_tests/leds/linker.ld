ENTRY(_start)

MEMORY
{
    DMEM (rwx) : ORIGIN = 0x00000000, LENGTH = 0x1000   /* 1024 words = 4096 bytes data memory */
    IMEM (rx)  : ORIGIN = 0x10000000, LENGTH = 0x4000   /* 4096 words = 16384 bytes instruction memory */
}

SECTIONS
{
    /* Reserve a stack section in DMEM and define _stack_top as the end of DMEM */
    .stack (NOLOAD) : 
    {
        _stack_top = ORIGIN(DMEM) + LENGTH(DMEM);
    } > DMEM

    .text : 
    {
        *(.init)        /* Place startup code at the beginning */
        *(.text*)
        *(.rodata*)
        . = ALIGN(4);
    } > IMEM

    .data : 
    {
        *(.data*)
        . = ALIGN(4);
    } > DMEM

    .bss : 
    {
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
    } > DMEM
}
