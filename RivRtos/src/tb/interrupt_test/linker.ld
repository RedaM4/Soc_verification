SECTIONS
{
  . = 0xfffff000;        /* Base address for code */
  .text : {
    *(.text)
  }

  _end = .;              /* Mark the end of memory */
}