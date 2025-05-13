CC       = riscv64-unknown-linux-gnu-gcc
AS       = riscv64-unknown-linux-gnu-as
OBJDUMP  = riscv64-unknown-linux-gnu-objdump
OBJCOPY  = riscv64-unknown-linux-gnu-objcopy

CFLAGS   = -O2 -Wall -ffreestanding -nostdlib -nostartfiles -T linker.ld -march=rv32ic -mabi=ilp32

# Automatically get libgcc path
GCC_LIB_DIR = $(shell $(CC) -print-libgcc-file-name | xargs dirname)

OBJS = startup.o main.o

# The main target (calls everything needed)
all: machine.hex

# Object file rules
main.o: main.c
	$(CC) $(CFLAGS) -c -o $@ $<

startup.o: startup.S
	$(AS) -march=rv32iac -o $@ $<

# Link object files to ELF
test.elf: $(OBJS)
	$(CC) -march=rv32iac -mabi=ilp32 -T linker.ld -nostdlib -o $@ $(OBJS) -lgcc

# Disassemble ELF
test.asm: test.elf
	$(OBJDUMP) -D test.elf > $@
	@echo "Disassembly saved to $@"

# Convert ELF to Verilog hex (intermediate)
inst.hex: test.elf
	$(OBJCOPY) -O verilog test.elf $@
	@echo "Verilog HEX generated as $@"

# Format hex to machine.hex (final)
machine.hex: inst.hex
	python3 convert_hex.py $< $@
	@echo "Final formatted HEX file: $@"

# Optional run
program:
	python3 program_soc.py

# Clean all generated files
clean:
	rm -f test.elf test.asm inst.hex machine.hex $(OBJS)
