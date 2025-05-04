
+incdir+../../uart_rtl
../../uart_rtl/uart_defines.v
../../uart_rtl/uart_regs.v
../../uart_rtl/uart_top.v
../../uart_rtl/uart_receiver.v
../../uart_rtl/uart_transmitter.v
../../uart_rtl/uart_wb.v
../../uart_rtl/uart_rfifo.v
../../uart_rtl/uart_tfifo.v
../../uart_rtl/uart_sync_flops.v
../../uart_rtl/raminfr.v


+incdir+../../wb_soc_rtl/WishboneInterconnect
../../wb_soc_rtl/WishboneInterconnect/wb_intercon.sv
../../wb_soc_rtl/WishboneInterconnect/wb_mux.v

+incdir+../../wb_soc_rtl/spi
../../wb_soc_rtl/spi/simple_spi_top.v
../../wb_soc_rtl/spi/fifo4.v
../../wb_soc_rtl/wb_soc_top.sv

+incdir+../../clock_and_reset/sv              
../../clock_and_reset/sv/clock_and_reset_pkg.sv
../../clock_and_reset/sv/clock_and_reset_if.sv

+incdir+../../uart_uvc/sv
../../uart_uvc/sv/uart_pkg.sv
../../uart_uvc/sv/uart_if.sv

+incdir+../../wb_uvc/sv
../../wb_uvc/sv/wb_pkg.sv
../../wb_uvc/sv/wb_if.sv

+incdir+../../uart_ver/tb
../../uart_ver/tb/uart_ver_top.sv
../../uart_ver/tb/uart_ver_hw_dut.sv
../../uart_ver/tb/clkgen.sv