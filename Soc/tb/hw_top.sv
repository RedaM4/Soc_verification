module hw_top;

  logic clock,reset;
  logic [31:0]  clock_period;
  logic         run_clock;



uart_if in_uart(clock) ; 
wb_if in_wb(clock,reset);



//***************************************************
//   NEEDS TO CHECK
//***************************************************
  initial begin
    reset <= 1'b0;
    @(negedge clock)
      #1 reset <= 1'b1;
    @(negedge clock)
      #1 reset <= 1'b0;
  end
  

// later we need it 
//  wb_soc_top wb_top (

//     .wb_clk(clock),
//     .wb_rst(reset),
//     .wb_m2s_adr(in_wb.ADR_O),
//     .wb_m2s_dat(in_wb.DAT_I), 
//     .wb_m2s_sel(), 
//     .wb_m2s_we(in_wb.WE_O),
//     .wb_m2s_cyc(in_wb.CYC_O),
//     .wb_m2s_stb(in_wb.STB_O),
//     .wb_s2m_dat(in_wb.DAT_O), 
//     .wb_s2m_ack(in_wb.ACK_I),
  
//     // uart
//     .o_uart_tx(in_uart.tx),
//     .i_uart_rx(in_uart.rx)
// );

uart_top uart16550_0(// Wishbone slave interface

         .wb_clk_i	(clock),
         .wb_rst_i	(reset),
         .wb_adr_i	(in_wb.ADR_O),
         .wb_dat_i	(in_wb.DAT_O),
         .wb_we_i	  (in_wb.WE_O),
         .wb_cyc_i	(in_wb.CYC_O),
         .wb_stb_i	(in_wb.STB_O),
         .wb_sel_i	(4'b0), // Not used in 8-bit mode
         .wb_dat_o	(in_wb.DAT_I),
         .wb_ack_o	(in_wb.ACK_I),


         // Outputs
         .int_o     (),
         .stx_pad_o (in_uart.tx),
         .rts_pad_o (),
         .dtr_pad_o (),

         // Inputs
         .srx_pad_i (in_uart.rx),
         .cts_pad_i (1'b0),
         .dsr_pad_i (1'b0),
         .ri_pad_i  (1'b0),
         .dcd_pad_i (1'b0)
         );

// qb signal 
        //  .o_uart_tx(in_uart.tx),
        //  .i_uart_rx(in_uart.rx)
         
         




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