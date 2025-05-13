# ───────────────
# Toolchain Vars
# ───────────────
VCS         := vcs -full64 -sverilog
VCS_FLAGS   := -f filelist.f \
                tb/SimJTAG.cc tb/remote_bitbang.cc \
                -cc g++ \
                -CFLAGS "-std=c++11 -Itb" \
                -debug_all -debug_pp -debug_access+all+xrw \
                -kdb +vcs+lic+wait \
                -cm line+cond+fsm \
                -o simv

OPENOCD     := openocd
OPENOCD_CFG := tb/remote_bitbang.cfg

GDB         := riscv32-unknown-elf-gdb
GDB_ELF     := /home/qamar/Documents/rtl/RivRtos/src/tb/jtag_tests/firmware.elf
# GDB_ELF     := /home/qamar/Documents/rtl/RivRtos/src/tb/RTOS/demo.elf

# ───────────────
# Default target
# ───────────────
.PHONY: all
all: simv

# ───────────────
# Build the simulator
# ───────────────
.PHONY: simv
simv: 
	@echo ">>> Building simv with VCS..."
	$(VCS) $(VCS_FLAGS)

# ───────────────
# Remove stale database directory
# ───────────────
.PHONY: clean_daidir
clean_daidir:
	@echo ">>> Removing stale simv.daidir (if any)…"
	-@rm -rf simv.daidir

# ───────────────
# Run each component
# ───────────────
.PHONY: run_simv openocd run_gdb
run_simv: simv
	@echo ">>> Launching simv…"
	./simv 

openocd:
	@echo ">>> Launching OpenOCD…"
	$(OPENOCD) -f $(OPENOCD_CFG) 

run_gdb:
	@echo ">>> Launching GDB…"
	$(GDB) $(GDB_ELF) 

kill:
	killall -9 simv
	killall -9 openocd

