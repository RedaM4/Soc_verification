# Peripheral directories


UART_DIR := ../../Peripherals/uart_uvc
SPI_DIR  := ../../Peripherals/spi_uvc
I2C_DIR  := ../../Peripherals/i2c_uvc
PWM_DIR  := ../../Peripherals/pwm_uvc
GPIO_DIR := ../../Peripherals/gpio_uvc

# Core directory
CORE_DIR := ../../RV32_SoC/

# Filelists
CORE_LIST := rtl_filelist.f
# CORE_LIST := ../../RivRtos/src/filelist.f
MODULES_LIST := filelist.f

# Git pulls
pull_uart:
	cd $(UART_DIR) && git pull

pull_spi:
	cd $(SPI_DIR) && git pull

pull_i2c:
	cd $(I2C_DIR) && git pull

# pull_pwm:
# 	cd $(PWM_DIR) && git pull

pull_gpio:
	cd $(GPIO_DIR) && git pull

pull_rtl:	
	cd $(CORE_DIR) && git pull

# Pull all peripherals
pull_all: pull_uart pull_spi pull_i2c  pull_gpio

init:
	cd ../.. && git submodule update --init




# Compile using both filelists
compile:
	vcs -full64 -ntb_opts uvm -sverilog -debug_all -kdb -timescale=1ns/1ns \
	    -f $(MODULES_LIST) -f $(CORE_LIST) -o simv

# Run simulation using run.f
run: compile
	./simv -f run.f

# Clean simulation output files
clean:
	rm -rf simv simv.daidir csrc *.vcd *.log ucli.key *.fsdb *.bak *.sv.d

# Default target: pull all, compile, run
all: compile run


help:
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "important the first time Git/Submodule Setup:"
	@echo "  init           - Initialize and update git submodules"
	@echo ""
	@echo "Peripheral Git Pull Targets:"
	@echo "  pull_uart      - Pull latest UART UVC"
	@echo "  pull_spi       - Pull latest SPI UVC"
	@echo "  pull_i2c       - Pull latest I2C UVC"
	@echo "  pull_pwm       - Pull latest PWM UVC"
	@echo "  pull_gpio      - Pull latest GPIO UVC"
	@echo "  pull_all       - Pull all peripheral UVCs"
	@echo ""
	@echo "Build and Simulation:"
	@echo "  compile        - Compile design using both filelists"
	@echo "  run            - Run simulation using run.f"
	@echo "  clean          - Clean build and simulation artifacts"
	@echo ""
	@echo "Full Flow:"
	@echo "  all            - Pull all, compile, and run"
	@echo ""
