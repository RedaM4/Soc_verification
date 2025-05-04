# Compiler options
VCS = vcs -full64 -ntb_opts uvm -sverilog -debug_all -kdb -timescale=1ns/1ns

# Simulation binary names
UART_SIM = ./uart_simv
WB_SIM = ./wb_simv
SYSTEM_SIM = ./system_simv

# Filelists
UART_FILELIST = uart_uvc/tb/filelist.f
WB_FILELIST = wb_uvc/tb/filelist.f
SYSTEM_FILELIST = uart_wb_system/tb/run_tests.f

uart_runf = uart_uvc/tb/run.f
wb_runf = wb_uvc/tb/run.f
system_runf = uart_wb_system/tb/run.f
# Default test and verbosity
TEST ?= base_test
VER ?= UVM_HIGH

# Compilation targets
compile_uart:
	@echo "🔧 Compiling UART UVC..."
	$(VCS) -f $(UART_FILELIST) -o $(UART_SIM)

compile_wb:
	@echo "🔧 Compiling Wishbone UVC..."
	$(VCS) -f $(WB_FILELIST) -o $(WB_SIM)

compile_system:
	@echo "🔧 Compiling System Integration..."
	$(VCS) -f $(SYSTEM_FILELIST) -o $(SYSTEM_SIM)

# Running targets
run_uart:
	@echo "🚀 Running UART Simulation"
	$(UART_SIM) -f $(uart_runf)

run_wb:
	@echo "🚀 Running WB Simulation"
	$(WB_SIM)  -f $(wb_runf) 

run_system:
	@echo "🚀 Running System Simulation"
	$(SYSTEM_SIM) -f  $(system_runf)

# Regression targets
regress_uart:
	@echo "🧪 Running Regression for UART..."
	$(UART_SIM) +UVM_TESTNAME=all  +UVM_VERBOSITY=$(VER) +ntb_random_seed_automatic  | tee logs/uart_regression.log

regress_wb:
	@echo "🧪 Running Regression for WB..."
	$(WB_SIM) +UVM_TESTNAME=all +UVM_VERBOSITY=$(VER) +ntb_random_seed_automatic | tee logs/wb_regression.log

regress_system:
	@echo "🧪 Running Regression for System..."
	$(SYSTEM_SIM) +UVM_TESTNAME=all +UVM_VERBOSITY=$(VER) +ntb_random_seed_automatic | tee logs/system_regression.log

# Shortcuts
cu: compile_uart
cw: compile_wb
cs: compile_system
ru: run_uart
rw: run_wb
rs: run_system
rua: regress_uart
rwa: regress_wb
rsa: regress_system

# Cleanup
clean:
	@echo "🗑 Cleaning up generated files..."
	rm -rf csrc simv simv.daidir ucli.key *.log *.vpd *.vdb DVEfiles

# Help command
help:
	@echo "Available Commands:"
	@echo "  compile_uart (cu)   - Compile UART UVC"
	@echo "  compile_wb (cw)     - Compile WB UVC"
	@echo "  compile_system (cs) - Compile System"
	@echo "  run_uart (ru)       - Run UART simulation"
	@echo "  run_wb (rw)         - Run WB simulation"
	@echo "  run_system (rs)     - Run System simulation"
	@echo "  regress_uart (rua)  - Run UART regression"
	@echo "  regress_wb (rwa)    - Run WB regression"
	@echo "  regress_system (rsa) - Run System regression"
	@echo "  clean               - Remove compiled files"
