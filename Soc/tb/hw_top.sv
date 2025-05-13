module hw_top;

  logic clock,reset;
  logic [31:0]  clock_period;
  logic         run_clock;

logic cs,sclk ; 

// uart_if in_uart(clock) ; 
wb_if in_wb(clock,reset);
spi_if in_spi1(clock,reset,sclk,cs);


//***************************************************
//   SOC HW
//***************************************************
    wire O_UART_TX_PAD;
     wire I_UART_RX_PAD;
     wire [23:0] gpio_pads; 
  
  //spi1 addrs 
  /*  
  gpio[19] = spi1_ssl
  gpio[20] = spi1_ss0
  gpio[21] = spi1_sck
  gpio[22] = spi1_miso
  gpio[23] = spi1_mosi
  */
 

// top_rv32i_soc #(
//     .DMEM_DEPTH(128),
//     .IMEM_DEPTH(128)
// ) DUT (
//     .O_UART_TX_PAD(O_UART_TX_PAD),
//     .I_UART_RX_PAD(I_UART_RX_PAD),
//     .IO_GPIO_PAD(gpio_pads),
//     .CLK_PAD(clock),
//     .RESET_PAD(reset)
// );

top_rv32i_soc DUT (
  .CLK_PAD       (clock),
  .RESET_N_PAD   (reset),
  .O_UART_TX_PAD (o_uart_tx_pad),
  .I_UART_RX_PAD (i_uart_rx_pad),
  .IO_DATA_PAD   (gpio_pads)
  // .I_TCK_PAD     (i_tck_pad),
  // .I_TMS_PAD     (i_tms_pad),
  // .I_TDI_PAD     (i_tdi_pad),
  // .O_TDO_PAD     (o_tdo_pad)
);








//in_wb signals
  // logic       [31:0]    ADR_O;
  // logic       [7:0]     DAT_I;
  // logic       [7:0]     DAT_O;
  // logic                 WE_O;
  // logic                 STB_O;
  // logic                 ACK_I;
  // logic                 CYC_O;

//rv32i_soc signals 
  // MY_TODO: IO ( wb master signals )
  // the data I in the interface is 32 bits
  logic [31:0] wb_io_adr_i;  // from --> .wb_adr_o
  logic [31:0] wb_io_dat_i;  // from --> .wb_dat_o 
  logic [ 3:0] wb_io_sel_i;  // from --> .wb_sel_o
  logic        wb_io_we_i;  // from --> .wb_we_o
  logic        wb_io_cyc_i;  // from --> .wb_cyc_o
  logic        wb_io_stb_i;  // from --> .wb_stb_o




always @(*)begin 
  force DUT.u_rv32i_soc.wb_m2s_io_adr = in_wb.addr;
  force DUT.u_rv32i_soc.wb_m2s_io_dat = in_wb.dout;
  //there is no sel signal in the interface of the wb
  // force DUT.rv32_soc.wb_m2s_io_sel = 4'b1111; // assuming all bytes selected
  
  force DUT.u_rv32i_soc.wb_m2s_io_we  = in_wb.we;
  force DUT.u_rv32i_soc.wb_m2s_io_stb = in_wb.stb;
  force DUT.u_rv32i_soc.wb_m2s_io_cyc = in_wb.cyc;

end

// // assign in_spi.cs    = gpio_pads[19]; // or gpio_pads[20], based on which slave
// assign in_spi1.sclk  = gpio_pads[21];
// assign in_spi1.miso  = gpio_pads[22]; // input from slave
// assign gpio_pads[23] = in_spi1.mosi;  // output to slave

assign gpio_pads[21] = in_spi1.sclk;
assign gpio_pads[22] = in_spi1.miso; // input from slave (driven by slave)
assign in_spi1.mosi  = gpio_pads[23]; // output to slave (driven by DUT)




clock_and_reset_if clk_rst_if (
    .clock(clock),
    .reset(),
    .run_clock(run_clock),
    .clock_period(clock_period)
);

  clkgen clkgen (
    .clock(clock ),
    .run_clock(run_clock),
    .clock_period(32'd10)
  );



endmodule