# Filelist for VCS simulation

# Compilation Flags
-timescale=1ns/10ps
-sverilog


#+define+PD_BUILD
#+define+SG
#+define+BOOT
+define+VCS_SIM   
# +define+USE_SRAM
+define+tracer
#i added this 

+incdir+../../RivRtos/src


# lib that many module accesses should be compiled first
soc/core/lib.sv
soc/debug/debug_pkg.sv

# Core files
soc/core/alignment_units.sv
soc/core/alu_control.sv
soc/core/mul.sv
soc/core/div.sv
soc/core/branch_controller.sv
soc/core/csr_file.sv
soc/core/imm_gen.sv
soc/core/main_control.sv
soc/core/reg_file.sv
soc/core/rom.sv
soc/core/forwarding_unit.sv
soc/core/hazard_controller.sv
soc/core/pipeline_controller.sv
soc/core/decompressor.sv
soc/core/iadu.sv
soc/core/atomic_extension.sv
soc/core/exception_encoder.sv
soc/core/alu.sv
soc/core/data_path.sv
soc/core/control_unit.sv
soc/core/core_dbg_fsm.sv
soc/core/rv32i_top.sv

# Wishbone interconnect files
soc/WishboneInterconnect/wb_intercon_1.2.2-r1/wb_mux.v
soc/WishboneInterconnect/wb_intercon.sv
soc/WishboneInterconnect/wishbone_controller.sv

# Peripheral files
soc/uncore/gpio/gpio_defines.v
soc/uncore/gpio/bidirec.sv
soc/uncore/gpio/gpio_top.sv
soc/uncore/spi/fifo4.v
soc/uncore/spi/simple_spi_top.v
soc/uncore/uart/uart_defines.v
soc/uncore/uart/raminfr.v
soc/uncore/uart/uart_receiver.v
soc/uncore/uart/uart_regs.v
soc/uncore/uart/uart_rfifo.v
soc/uncore/uart/uart_sync_flops.v
soc/uncore/uart/uart_tfifo.v
soc/uncore/uart/uart_top.v
soc/uncore/uart/uart_transmitter.v
soc/uncore/uart/uart_wb.v
soc/uncore/clint/clint_wb.sv
soc/uncore/clint/clint_top.sv
soc/uncore/ptc/ptc_defines.v
soc/uncore/ptc/ptc_top.v
soc/uncore/i2c/rtl/i2c_master_defines.v
soc/uncore/i2c/rtl/i2c_master_bit_ctrl.v
soc/uncore/i2c/rtl/i2c_master_byte_ctrl.v
soc/uncore/i2c/rtl/i2c_master_top.v
soc/uncore/plic/plic_pkg.sv
soc/uncore/plic/plic_gateway.sv
soc/uncore/plic/plic_core.sv
soc/uncore/plic/plic_top.sv


# Debug Unit 
soc/debug/dtm.sv
soc/debug/dm.sv
soc/debug/debug_top.sv

# sram 
# verilog model for simulation
soc/core/sram_wrapper.sv

# rom

# system verilog models for prototyping
soc/core/data_mem.sv


# rv32i soc top
soc/io_mux.sv
soc/rv32i_soc.sv

# pad library and top module file 
//pads/top_rv32i_soc.sv

# Testbench files


tb/rv32i_soc_tb.sv
// tb/rv32i_soc_plic_tb.sv

// tb/rv32i_soc_jtag_tb.sv
#tb/rv32_soc_with_pad_tb.sv


# Optionally, include any other files you want for the simulation.
