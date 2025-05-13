# === File: Makefile ===

CC      = riscv64-unknown-elf-gcc
OBJCOPY = riscv64-unknown-elf-objcopy
OBJDUMP = riscv64-unknown-elf-objdump


CFLAGS   = -march=rv32i_zicsr -mabi=ilp32 -nostdlib -Wall
LDSCRIPT = linker.ld

TARGET   = firmware
SRC      = mul.S

all: $(TARGET).elf $(TARGET).dis inst.hex data.hex

$(TARGET).elf: $(SRC)
	$(CC) $(CFLAGS) -T $(LDSCRIPT) -o $@ $^

# Generate the assembly file for reference 
$(TARGET).dis: $(TARGET).elf
	$(OBJDUMP) -d $(TARGET).elf > $(TARGET).dis

# Extract .text section for instruction memory
inst.hex: $(TARGET).elf
	$(OBJCOPY) -O verilog -j .text $(TARGET).elf inst.hex
	./convert_hex inst.hex inst.hex
	cp inst.hex ../inst_formatted.hex

# Extract .data, .rodata, .bss (merged) for data memory
data.hex: $(TARGET).elf
	$(OBJCOPY) -O verilog -j .data -j .rodata -j .bss $(TARGET).elf data.hex
	./convert_hex data.hex data.hex
	cp data.hex ../data_formatted.hex


clean:
	rm -f *.elf *.hex *.bin *.o

.PHONY: all clean
