# Filelist for VCS simulation

# Compilation Flags
-timescale=1ns/10ps
-sverilog

# Defines
+define+VCS_SIM   
+define+tracer

# Include directories
+incdir+../../RivRtos/src

# lib that many modules access (compile first)
../../RivRtos/src/soc/core/lib.sv
../../RivRtos/src/soc/debug/debug_pkg.sv

# Core files
../../RivRtos/src/soc/core/alignment_units.sv
../../RivRtos/src/soc/core/alu_control.sv
../../RivRtos/src/soc/core/mul.sv
../../RivRtos/src/soc/core/div.sv
../../RivRtos/src/soc/core/branch_controller.sv
../../RivRtos/src/soc/core/csr_file.sv
../../RivRtos/src/soc/core/imm_gen.sv
../../RivRtos/src/soc/core/main_control.sv
../../RivRtos/src/soc/core/reg_file.sv
../../RivRtos/src/soc/core/rom.sv
../../RivRtos/src/soc/core/forwarding_unit.sv
../../RivRtos/src/soc/core/hazard_controller.sv
../../RivRtos/src/soc/core/pipeline_controller.sv
../../RivRtos/src/soc/core/decompressor.sv
../../RivRtos/src/soc/core/iadu.sv
../../RivRtos/src/soc/core/atomic_extension.sv
../../RivRtos/src/soc/core/exception_encoder.sv
../../RivRtos/src/soc/core/alu.sv
../../RivRtos/src/soc/core/data_path.sv
../../RivRtos/src/soc/core/control_unit.sv
../../RivRtos/src/soc/core/core_dbg_fsm.sv
../../RivRtos/src/soc/core/rv32i_top.sv

# Wishbone interconnect files
../../RivRtos/src/soc/WishboneInterconnect/wb_intercon_1.2.2-r1/wb_mux.v
../../RivRtos/src/soc/WishboneInterconnect/wb_intercon.sv
../../RivRtos/src/soc/WishboneInterconnect/wishbone_controller.sv

# Peripheral files
../../RivRtos/src/soc/uncore/gpio/gpio_defines.v
../../RivRtos/src/soc/uncore/gpio/bidirec.sv
../../RivRtos/src/soc/uncore/gpio/gpio_top.sv
../../RivRtos/src/soc/uncore/spi/fifo4.v
../../RivRtos/src/soc/uncore/spi/simple_spi_top.v
../../RivRtos/src/soc/uncore/uart/uart_defines.v
../../RivRtos/src/soc/uncore/uart/raminfr.v
../../RivRtos/src/soc/uncore/uart/uart_receiver.v
../../RivRtos/src/soc/uncore/uart/uart_regs.v
../../RivRtos/src/soc/uncore/uart/uart_rfifo.v
../../RivRtos/src/soc/uncore/uart/uart_sync_flops.v
../../RivRtos/src/soc/uncore/uart/uart_tfifo.v
../../RivRtos/src/soc/uncore/uart/uart_top.v
../../RivRtos/src/soc/uncore/uart/uart_transmitter.v
../../RivRtos/src/soc/uncore/uart/uart_wb.v
../../RivRtos/src/soc/uncore/clint/clint_wb.sv
../../RivRtos/src/soc/uncore/clint/clint_top.sv
../../RivRtos/src/soc/uncore/ptc/ptc_defines.v
../../RivRtos/src/soc/uncore/ptc/ptc_top.v
../../RivRtos/src/soc/uncore/i2c/rtl/i2c_master_defines.v
../../RivRtos/src/soc/uncore/i2c/rtl/i2c_master_bit_ctrl.v
../../RivRtos/src/soc/uncore/i2c/rtl/i2c_master_byte_ctrl.v
../../RivRtos/src/soc/uncore/i2c/rtl/i2c_master_top.v
../../RivRtos/src/soc/uncore/plic/plic_pkg.sv
../../RivRtos/src/soc/uncore/plic/plic_gateway.sv
../../RivRtos/src/soc/uncore/plic/plic_core.sv
../../RivRtos/src/soc/uncore/plic/plic_top.sv

# Debug Unit 
../../RivRtos/src/soc/debug/dtm.sv
../../RivRtos/src/soc/debug/dm.sv
../../RivRtos/src/soc/debug/debug_top.sv

# SRAM
../../RivRtos/src/soc/core/sram_wrapper.sv

# ROM / data memory
../../RivRtos/src/soc/core/data_mem.sv

# SoC Top
../../RivRtos/src/soc/io_mux.sv
../../RivRtos/src/soc/rv32i_soc.sv

# Pads (commented out if unused)
../../RivRtos/src/pads/top_rv32i_soc.sv

# Testbench
//../../RivRtos/src/tb/rv32i_soc_tb.sv
//../../RivRtos/src/tb/rv32i_soc_plic_tb.sv
//../../RivRtos/src/tb/rv32i_soc_jtag_tb.sv
//../../RivRtos/src/tb/rv32_soc_with_pad_tb.sv

// ========== pads dir ==========
//+incdir+/home/Reda_Alhashem/shared_folder/soc-rtl/pads/tpz018nv_270a
///home/Reda_Alhashem/shared_folder/soc-rtl/pads/tpz018nv_270a/tpz018nv.v


