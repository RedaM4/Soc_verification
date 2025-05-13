ENTRY(main)

MEMORY
{
    DMEM (rwx) : ORIGIN = 0x00000000, LENGTH = 0x00100000   /* Example: 1 MB data memory */
    IMEM (rx)  : ORIGIN = 0x10000000, LENGTH = 0x00100000   /* Example: 1 MB instruction memory */
}

SECTIONS
{
    .text : {
        *(.text*)
        *(.rodata*)
        . = ALIGN(4);
    } > IMEM

    .data : {
        *(.data*)
        . = ALIGN(4);
    } > DMEM

    .bss : {
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
    } > DMEM
}
