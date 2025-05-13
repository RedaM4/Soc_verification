CC       = riscv64-unknown-linux-gnu-gcc
AS       = riscv64-unknown-linux-gnu-as
OBJDUMP  = riscv64-unknown-linux-gnu-objdump
OBJCOPY  = riscv64-unknown-linux-gnu-objcopy

CFLAGS   = -O2 -Wall -ffreestanding -nostdlib -nostartfiles -T linker.ld -march=rv32i_zicsr -mabi=ilp32

# Include the startup file here
OBJS     = startup.o main.o trap_handler.o

all: led_test.elf disasm hex program

startup.o: startup.S
	$(AS) -march=rv32i_zicsr -o $@ $<

main.o: main.c
	$(CC) $(CFLAGS) -c -o $@ $<

trap_handler.o: trap_handler.S
	$(AS) -march=rv32i_zicsr -o $@ $<

led_test.elf: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS)

disasm: led_test.elf
	$(OBJDUMP) -D led_test.elf > led_test.asm
	@echo "Disassembly saved to led_test.asm"

hex: led_test.elf
	$(OBJCOPY) -O verilog led_test.elf machine.hex
	@echo "HEX file generated as machine.hex"

inst_hex:led_test.elf
	$(OBJCOPY) -j .text -O verilog led_test.elf machine.hex
	@echo "HEX file generated as machine.hex with .text section only"

data_hex:led_test.elf
	$(OBJCOPY) -j .text -O verilog led_test.elf machine.hex
	@echo "HEX file generated as machine.hex with .text section only"

program:
	python3 program_soc.py

clean:
	rm -f led_test.elf led_test.asm *.hex $(OBJS)
