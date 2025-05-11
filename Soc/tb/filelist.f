// ========== UART ==========  //NEED TO BE UPDATED
//+incdir+../../Peripherals/uart_uvc
//../../Peripherals/uart_uvc/sv/ 
//../../Peripherals/uart_uvc/sv/


// ========== wb_uvc ==========
+incdir+../../wb_uvc/sv
../../Peripherals/uart_uvc/sv/wb_pkg.sv
../../Peripherals/uart_uvc/sv/wb_if.sv


// ========== clock_and_reset ==========
+incdir+../../Soc/clock_and_reset              
../../Soc/clock_and_reset/sv/clock_and_reset_pkg.sv
../../Soc/clock_and_reset/sv/clock_and_reset_if.sv


// ========== spi ==========
+incdir+../../Peripherals/spi_uvc/sv
../../Peripherals/spi_uvc/sv/spi_pkg.sv         
../../Peripherals/spi_uvc/sv/spi_if.sv         


// ========== SOC ==========
+incdir+../../Soc/tb
../../Soc/tb/soc_tb.sv
../../Soc/tb/soc_test_lib.sv
../../Soc/tb/top.sv
../../Soc/tb/hw_top.sv
../../Soc/tb/clkgen.sv


// ========== pads dir ==========
+incdir+/home/Reda_Alhashem/shared_folder/soc-rtl/pads/tpz018nv_270a
tpz018nv.v

