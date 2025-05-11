// ===========================
// ========== INCDIR =========
// ===========================

+incdir+../../RV32_SoC/modules/rtl_team/soc


// ===========================
// ========== TOP LEVEL ======
// ===========================

../../RV32_SoC/modules/rtl_team/soc/pads.sv
../../RV32_SoC/modules/rtl_team/soc/glbl.v
../../RV32_SoC/modules/rtl_team/soc/rv32i_soc.sv


// ===========================
// ========== CORE ===========
// ===========================

../../RV32_SoC/modules/rtl_team/soc/core/alignment_units.sv
../../RV32_SoC/modules/rtl_team/soc/core/alu.sv
../../RV32_SoC/modules/rtl_team/soc/core/alu_control.sv
../../RV32_SoC/modules/rtl_team/soc/core/branch_controller.sv
../../RV32_SoC/modules/rtl_team/soc/core/control_unit.sv
../../RV32_SoC/modules/rtl_team/soc/core/data_mem.sv
../../RV32_SoC/modules/rtl_team/soc/core/data_path.sv
../../RV32_SoC/modules/rtl_team/soc/core/forwarding_unit.sv
../../RV32_SoC/modules/rtl_team/soc/core/hazard_controller.sv
../../RV32_SoC/modules/rtl_team/soc/core/imm_gen.sv
../../RV32_SoC/modules/rtl_team/soc/core/lib.sv
../../RV32_SoC/modules/rtl_team/soc/core/main_control.sv
../../RV32_SoC/modules/rtl_team/soc/core/pipeline_controller.sv
../../RV32_SoC/modules/rtl_team/soc/core/program_counter.sv
../../RV32_SoC/modules/rtl_team/soc/core/reg_file.sv
../../RV32_SoC/modules/rtl_team/soc/core/rom.sv
../../RV32_SoC/modules/rtl_team/soc/core/rv32i_top.sv


// ===========================
// ========== GREEN TEAM =====
// ===========================

// Block sqrt
../../RV32_SoC/modules/rtl_team/soc/core/green_team/block_sqrt/fp_add.sv
../../RV32_SoC/modules/rtl_team/soc/core/green_team/block_sqrt/fp_sqrt_Multicycle.sv
../../RV32_SoC/modules/rtl_team/soc/core/green_team/block_sqrt/Register.sv

// FADD/SUB modules
../../RV32_SoC/modules/rtl_team/soc/core/green_team/fadd_sub_modules/add_sub_FP.sv
../../RV32_SoC/modules/rtl_team/soc/core/green_team/fadd_sub_modules/extract_align_FP.sv
../../RV32_SoC/modules/rtl_team/soc/core/green_team/fadd_sub_modules/FP_add_sub_top.sv
../../RV32_SoC/modules/rtl_team/soc/core/green_team/fadd_sub_modules/normalize_FP.sv
../../RV32_SoC/modules/rtl_team/soc/core/green_team/fadd_sub_modules/round_FP.sv

// FPU Units
../../RV32_SoC/modules/rtl_team/soc/core/green_team/fpu_units/fpu.sv

// FCVT (float/int conversion)
../../RV32_SoC/modules/rtl_team/soc/core/green_team/fpu_units/fcvt/float2ints.sv
../../RV32_SoC/modules/rtl_team/soc/core/green_team/fpu_units/fcvt/float2int.sv
../../RV32_SoC/modules/rtl_team/soc/core/green_team/fpu_units/fcvt/FP_converter.sv
../../RV32_SoC/modules/rtl_team/soc/core/green_team/fpu_units/fcvt/int2floats.sv
../../RV32_SoC/modules/rtl_team/soc/core/green_team/fpu_units/fcvt/int2float.sv

// RAW/WAW hazard units
../../RV32_SoC/modules/rtl_team/soc/core/green_team/raw_waw_units/busy_registers.sv
../../RV32_SoC/modules/rtl_team/soc/core/green_team/raw_waw_units/clear_units_decoder.sv
../../RV32_SoC/modules/rtl_team/soc/core/green_team/raw_waw_units/FP_busy_registers.sv
../../RV32_SoC/modules/rtl_team/soc/core/green_team/raw_waw_units/n_bit_delayer.sv
../../RV32_SoC/modules/rtl_team/soc/core/green_team/raw_waw_units/value_capture.sv


// ===========================
// ========== RED TEAM =======
// ===========================

// FP Units
../../RV32_SoC/modules/rtl_team/soc/core/red_team/FP_units/fdiv.sv
../../RV32_SoC/modules/rtl_team/soc/core/red_team/FP_units/FP_final_multiplier.sv
../../RV32_SoC/modules/rtl_team/soc/core/red_team/FP_units/R4_unit.sv

// INT Units
../../RV32_SoC/modules/rtl_team/soc/core/red_team/int_units/int_div_rem.sv
../../RV32_SoC/modules/rtl_team/soc/core/red_team/int_units/int_mul.sv

// Priority Units
../../RV32_SoC/modules/rtl_team/soc/core/red_team/priority_units/P_Decoder.sv
../../RV32_SoC/modules/rtl_team/soc/core/red_team/priority_units/priority_controller.sv
../../RV32_SoC/modules/rtl_team/soc/core/red_team/priority_units/priority_mux.sv


// ===========================
// ========== UNCORE =========
// ===========================

// GPIO
../../RV32_SoC/modules/rtl_team/soc/uncore/gpio/bidirec.sv
../../RV32_SoC/modules/rtl_team/soc/uncore/gpio/gpio_defines.v
../../RV32_SoC/modules/rtl_team/soc/uncore/gpio/gpio_top.sv

// SPI
../../RV32_SoC/modules/rtl_team/soc/uncore/spi/fifo4.v
../../RV32_SoC/modules/rtl_team/soc/uncore/spi/simple_spi_top.v

// UART
../../RV32_SoC/modules/rtl_team/soc/uncore/uart/raminfr.v
../../RV32_SoC/modules/rtl_team/soc/uncore/uart/uart_defines.v
../../RV32_SoC/modules/rtl_team/soc/uncore/uart/uart_receiver.v
../../RV32_SoC/modules/rtl_team/soc/uncore/uart/uart_regs.v
../../RV32_SoC/modules/rtl_team/soc/uncore/uart/uart_rfifo.v
../../RV32_SoC/modules/rtl_team/soc/uncore/uart/uart_sync_flops.v
../../RV32_SoC/modules/rtl_team/soc/uncore/uart/uart_tfifo.v
../../RV32_SoC/modules/rtl_team/soc/uncore/uart/uart_top.v
../../RV32_SoC/modules/rtl_team/soc/uncore/uart/uart_transmitter.v
../../RV32_SoC/modules/rtl_team/soc/uncore/uart/uart_wb.v


// ===========================
// ========== WISHBONE =======
// ===========================

../../RV32_SoC/modules/rtl_team/soc/WishboneInterconnect/wb_intercon.sv
../../RV32_SoC/modules/rtl_team/soc/WishboneInterconnect/wb_intercon_1.2.2-r1/wb_mux.v
../../RV32_SoC/modules/rtl_team/soc/WishboneInterconnect/wishbone_controller.sv
